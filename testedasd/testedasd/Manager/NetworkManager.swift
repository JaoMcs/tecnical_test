//
//  NetworkManager.swift
//  testedasd
//
//  Created by João Marcos on 05/09/24.
//

import Foundation

struct NetworkManagerHelper {
    typealias loginHandler = (Result<String, Error>) -> Void
    typealias extractHandler = (Result<TransactionDTO, Error>) -> Void
    typealias detailsHandler = (Result<TransferDTO, Error>) -> Void

    enum NetworkError: Error {
        case invalidResponse
        case noData
        case failedRequest
        case jsonEncodingError
    }

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }

    enum APIEndpoint: String {
        case authEndpoint = "https://api.challenge.stage.cora.com.br/challenge/auth"
        case listEndpoint = "https://api.challenge.stage.cora.com.br/challenge/list"
        case detailsEndpoint = "https://api.challenge.stage.cora.com.br/challenge/details/:"
    }
}

protocol NetworkManagerProtocol {
    func loginRequest(with cpf: String, and password: String, completion: @escaping NetworkManagerHelper.loginHandler)
    func getExtract(completion: @escaping NetworkManagerHelper.extractHandler)
    func getExtractDetails(with id: String, completion: @escaping NetworkManagerHelper.detailsHandler)
    func refreshToken()
    func startTokenRefreshTimer()
    func stopTokenRefreshTimer()
    func logout()
    func isUserLogger() -> Bool
}

class NetworkManager: NetworkManagerProtocol {

    // MARK: - Shared Singleton
    static let shared = NetworkManager()

    // MARK: - Constants
    private let apiKey = "3bb95636935ec423e9ab7a19c43db6e4"
    private var newToken = ""
    private let decoder = JSONDecoder()
    private var timer: Timer?

    func startTokenRefreshTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.refreshToken()
        }
    }

    func stopTokenRefreshTimer() {
        timer?.invalidate()
        timer = nil
    }

    func isUserLogger() -> Bool {
        guard let token = KeychainManager.loadToken() else { return false }
        newToken = token
        if !newToken.isEmpty {
            startTokenRefreshTimer()
            return true
        }
        return false
    }

    func logout() {
        KeychainManager.deleteToken()
        newToken = ""
        stopTokenRefreshTimer()
    }

    private func createRequest(for endpoint: NetworkManagerHelper.APIEndpoint,
                               method: NetworkManagerHelper.HTTPMethod,
                               with body: [String: String]? = nil,
                               identifier: String? = nil, isRefresh: Bool = false) -> URLRequest? {
        guard let url = URL(string: endpoint.rawValue + (identifier ?? "")) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(apiKey, forHTTPHeaderField: "apikey")
        if method == .get || isRefresh {
            request.addValue(newToken, forHTTPHeaderField: "token")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                return nil
            }
        }
        return request
    }

    func loginRequest(with cpf: String,
                         and password: String,
                         completion: @escaping NetworkManagerHelper.loginHandler) {

        let body: [String: String] = [
            "cpf": cpf,
            "password": password
        ]

        guard let request = createRequest(for: .authEndpoint, method: .post, with: body) else {
            completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            if let error = error {
                print("Erro na requisição: \(error)")
                completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
                return
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token =  json["token"] as? String {
                        self.newToken = token
                        self.startTokenRefreshTimer()
                        KeychainManager.saveToken(self.newToken)
                        completion(.success(token))
                    }
                } catch {
                    completion(.failure(NetworkManagerHelper.NetworkError.invalidResponse))
                }
            }
        }
        task.resume()
    }

    func refreshToken() {
        guard let request = createRequest(for: .authEndpoint, method: .post, isRefresh: true) else {
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            if let error = error {
                print("Erro na requisição: \(error)")
                return
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token =  json["token"] as? String {
                        self.newToken = token
                        KeychainManager.saveToken(self.newToken)
                    }
                } catch {
                }
            }
        }
        task.resume()
    }

    func getExtract(completion: @escaping NetworkManagerHelper.extractHandler) {
        guard let request = createRequest(for: .listEndpoint, 
                                          method: .get) else {
            completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [self] data, _ , error in
            if let error = error {
                print("Erro na requisição: \(error)")
                completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
                return
            }

            if let data = data {
                do {
                    let transactionResult = try decoder.decode(TransactionDTO.self, from: data)
                    completion(.success(transactionResult))
                } catch {
                    print("Erro ao decodificar JSON: \(error)")
                    completion(.failure(NetworkManagerHelper.NetworkError.jsonEncodingError))
                }
            }
        }
        task.resume()
    }

    func getExtractDetails(with id: String,
                           completion: @escaping NetworkManagerHelper.detailsHandler) {
        guard let request = createRequest(for: .detailsEndpoint,
                                          method: .get,
                                          identifier: id) else { return }
        let task = URLSession.shared.dataTask(with: request) { [self] data, response , error in
            if let error = error {
                print("Erro na requisição: \(error)")
                completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
                return
            }

            if let data = data {
                do {
                    let transactionResult = try decoder.decode(TransferDTO.self, from: data)
                    print("transactionResult: \(transactionResult)")
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("json\(json)")
                    }
                    completion(.success(transactionResult))
                } catch {
                    print("Erro ao decodificar JSON: \(error)")
                    completion(.failure(NetworkManagerHelper.NetworkError.jsonEncodingError))
                }
            }
        }
        task.resume()
    }
}
/*

 Fluxo de login:
 CPF: 21021049077
 Senha: qlqr 6 digitos
 (retorna TOKEN)

 OK
 (TELAS DE LOGIN) UI
    -> TELA INICIAL
        -> BOTÃO APARECE UM ALERTA SEI-LA OQUE CONTATE NOSSO SUPORTE SEI-LA OQ
    -> TELA DIGITE CPF
        -> TEM QUE SER CPF VALIDO
    -> TELA DIGITE SUA SENHA
        (SENHA SÓ É LIBERADA SE TIVER 6 DIGITOS
 OK
 (REQUISIÇÃO DE LOGIN) BACKEND
    -> REQUEST DE LOGIN
    -> FUNÇÃO DE VALIDAÇÃO DO CPF
    -> FUNÇÃO DE VALIDAÇÃO DA SENHA
    -> CONTROLE DO FLUXO DAS TELAS

 (LISTAGEM) UI
    -> UITABLEVIEW COM ABAS
    -> TABLEVIEW COM SESSÃO (TITULOZINHO)
    -> MONTAR A CELL QUE VAI SER USADA

 (LISTAGEM) BACKEND
    -> REQUISIÇÃO DA LISTA
    -> GERENCIAMENTO DAS INFORMAÇÕES
    -> AÇÃO DO CLICK PRA IR PRA DETALHES
    -> FILTRO
    -> ABINHAS

 DETALHES UI
    -> LISTA AS INFORMAÇÕES DETALHADAS
    -> BOTÃO DE COMPARTILHAR?
    -> SEI-LA ACHO QUE SÓ ISSO
    -> FAZER EM SWIFTUI

 DETALHES BACKEND
    -> REQUISIÇÃO DE DETALHES
    -> LOGICA DE COMPARTILHAR COMPROVANTE
    -> SEI-LA

 LOADING SKELETON LISTAGEM
    -> SEI-LA
 LOADING SKELETON DETALHES
    -> SEI-LA


Token expira em 1min (fazer requisição de novo token a cada request? )
    DESENVOLVIMENTO FINAL



esqueleto de uma ViewController:

 Constantes

 Componentes

 Ciclo de vida

 setups
    SetupHierarqui
    SetupConstraint
    SetupView (conteúdo)

 Extensions privada
    metodos privados


*/
