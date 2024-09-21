//
//  LoginViewModel.swift
//  testedasd
//
//  Created by João Marcos on 19/09/24.
//

import Foundation

class LoginViewModel {

    // MARK: - Private Constants
    private var cpf = ""
    private var password = ""

    // MARK: - Constants
    var onSuccess: (() -> Void)?
    var networkManager: NetworkManagerProtocol = NetworkManager.shared


    func isValidCPF(cpf: String) -> Bool {
        return cpf.isCPF
    }

    func isValidPassword(password: String) -> Bool {
        return password.count >= 6
    }

    func setCPF(with cpf: String?) {
        guard let cpf = cpf else { return }
        self.cpf = cpf
    }

    func setPassword(with password: String?) {
        guard let password = password else { return }
        self.password = password
    }

    func login() {
        print("cpf: \(cpf), senha: \(password)")
        networkManager.loginRequest(with: cpf, and: password) { result in
            switch result {
                case .success(let token):
                    print("token: \(token)")
                    self.onSuccess?()
                case .failure(let error):
                    print("error : \(error)")
            }
        }
    }

}
