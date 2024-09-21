//
//  ExtractViewModelTests.swift
//  testedasdTests
//
//  Created by João Marcos on 21/09/24.
//

import XCTest
@testable import testedasd

class ExtractViewModelTests: XCTestCase {

    var viewModel: ExtractViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = ExtractViewModel()
        viewModel.networkManager = mockNetworkManager
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    // MARK: - Teste: Total de Itens no Extrato
    func testGetExtractListItemsTotalCount() {
        mockNetworkManager.shouldSucceed = true
        viewModel.getExtract()

        viewModel.onSuccess = {
            XCTAssertEqual(self.viewModel.getExtractListItemsTotalCount(), 1)
        }
    }

    // MARK: - Teste: Número de Itens em uma Seção
    func testGetExtractListCount() {
        mockNetworkManager.shouldSucceed = true
        viewModel.getExtract()

        viewModel.onSuccess = {
            XCTAssertEqual(self.viewModel.getExtractListCount(with: 0), 1)
        }
    }

    // MARK: - Teste: Transação específica
    func testGetExtractListTransaction() {
        mockNetworkManager.shouldSucceed = true
        viewModel.getExtract()

        viewModel.onSuccess = {
            let transaction = self.viewModel.getExtractListTransaction(with: 0, and: 0)
            XCTAssertNotNil(transaction)
            XCTAssertEqual(transaction?.amount, "R$ 150,00")
            XCTAssertEqual(transaction?.type, "Aprovada")
            XCTAssertEqual(transaction?.sender, "João")
            XCTAssertEqual(transaction?.time, "14:47")
        }

    }

    // MARK: - Teste: Obter ID da Transação
    func testGetTransactionID() {
        mockNetworkManager.shouldSucceed = true
        viewModel.getExtract()

        viewModel.onSuccess = {
            let transactionID = self.viewModel.getTransactionID(with: 0, and: 0)
            XCTAssertEqual(transactionID, "1")
        }

    }

    // MARK: - Teste: Logout
    func testLogout() {
        viewModel.logout()
    }

    // MARK: - Teste: Falha ao obter extratos
    func testGetExtractFailure() {
        mockNetworkManager.shouldSucceed = false
        viewModel.getExtract()

        let expectation = self.expectation(description: "Falha ao obter extratos")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.getExtractListItemsTotalCount(), 0)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: - Teste: Formatação da Data
    func testGetDate() {
        mockNetworkManager.shouldSucceed = true
        viewModel.getExtract()

        viewModel.onSuccess = {
            let date = self.viewModel.getDate(with: 0)
            XCTAssertEqual(date, "20 de Setembro de 2024")
        }

    }
}

