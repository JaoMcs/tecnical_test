//
//  LoginViewModelTests.swift
//  testedasdTests
//
//  Created by João Marcos on 21/09/24.
//

import XCTest
@testable import testedasd

class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()
        // Configura o mock e o viewModel
        mockNetworkManager = MockNetworkManager()
        viewModel = LoginViewModel()
        viewModel.networkManager = mockNetworkManager
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    // MARK: - Teste de validação do CPF
    func testValidCPF() {
        XCTAssertTrue(viewModel.isValidCPF(cpf: "12345678909"))
        XCTAssertFalse(viewModel.isValidCPF(cpf: "123"))
    }

    // MARK: - Teste de validação da senha
    func testValidPassword() {
        XCTAssertTrue(viewModel.isValidPassword(password: "123456"))
        XCTAssertFalse(viewModel.isValidPassword(password: "123"))
    }

    // MARK: - Teste de login com sucesso
    func testLoginSuccess() {
        viewModel.setCPF(with: "12345678909")
        viewModel.setPassword(with: "123456")

        let expectation = self.expectation(description: "Login com sucesso")
        viewModel.onSuccess = {
            expectation.fulfill()
        }
        mockNetworkManager.shouldSucceed = true
        viewModel.login()
        waitForExpectations(timeout: 2, handler: nil)
    }

    // MARK: - Teste de login com falha
    func testLoginFailure() {
        viewModel.setCPF(with: "12345678909")
        viewModel.setPassword(with: "123456")

        let expectation = self.expectation(description: "Login falhou")
        mockNetworkManager.shouldSucceed = false
        viewModel.login()
        expectation.fulfill()
        waitForExpectations(timeout: 2, handler: nil)
    }
}
