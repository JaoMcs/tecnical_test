//
//  MockNetworkManager.swift
//  testedasdTests
//
//  Created by João Marcos on 21/09/24.
//

import Foundation
@testable import testedasd

class MockNetworkManager: NetworkManagerProtocol {

    var shouldSucceed = true
    var mockToken = "mock_token"

    func loginRequest(with cpf: String, and password: String, completion: @escaping NetworkManagerHelper.loginHandler) {
        if shouldSucceed {
            completion(.success(mockToken))
        } else {
            completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
        }
    }

    func getExtract(completion: @escaping NetworkManagerHelper.extractHandler) {
        if shouldSucceed {
            let mockTransaction = TransactionItem(id: "1", description: "Compra", label: "Aprovada", entry: "DEBIT", amount: 150, name: "João", dateEvent: "2024-09-20T14:47:00Z", status: "COMPLETED")
            let mockDateResult = DateResult(items: [mockTransaction], date: "2024-09-20")
            let mockTransactionDTO = TransactionDTO(results: [mockDateResult], itemsTotal: 1)
            completion(.success(mockTransactionDTO))
        } else {
            completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
        }
    }

    func getExtractDetails(with id: String, completion: @escaping NetworkManagerHelper.detailsHandler) {
        if shouldSucceed {
            let mockDetails = TransferDTO.mock()
            completion(.success(mockDetails))
        } else {
            completion(.failure(NetworkManagerHelper.NetworkError.failedRequest))
        }
    }

    func refreshToken() {
    }

    func startTokenRefreshTimer() {
    }

    func stopTokenRefreshTimer() {
    }

    func logout() {
    }

    func isUserLogger() -> Bool {
        return shouldSucceed
    }
}
