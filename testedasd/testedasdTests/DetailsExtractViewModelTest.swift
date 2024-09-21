//
//  DetailsExtractViewModelTest.swift
//  testedasdTests
//
//  Created by João Marcos on 21/09/24.
//

import XCTest
import Combine
@testable import testedasd

class DetailsExtractViewModelTests: XCTestCase {

    var viewModel: DetailsExtractViewModel!
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        cancellables = []
        viewModel = DetailsExtractViewModel(id: "mockID")
        viewModel.networkManager = mockNetworkManager
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Teste de Carregamento com Sucesso
    func testGetDetailsSuccess() {
        mockNetworkManager.shouldSucceed = true

        // Definimos o estado inicial de loading como true
        XCTAssertTrue(viewModel.isLoading)

        let expectation = self.expectation(description: "Detalhes carregados com sucesso")

        viewModel.$extract
            .dropFirst()
            .sink { extract in
                // Verifica se o valor do extrato foi atualizado
                XCTAssertEqual(extract.id, "abcdef12-3456-7890-abcd-ef1234567890")  // Depende do seu mock
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.getDetails()

        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertFalse(viewModel.isLoading) // Verifica se o carregamento foi finalizado
    }

    // MARK: - Teste de Falha ao Carregar Detalhes
    func testGetDetailsFailure() {
        mockNetworkManager.shouldSucceed = false

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    XCTAssertTrue(self.viewModel.extract.id.isEmpty) // Verifica que o extrato está vazio

                }
            }
            .store(in: &cancellables)

        viewModel.getDetails()
    }

    // MARK: - Teste de Estado de Carregamento
    func testLoadingState() {
        mockNetworkManager.shouldSucceed = true

        let expectation = self.expectation(description: "Verifica estado de carregamento")

        XCTAssertTrue(viewModel.isLoading)

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                XCTAssertFalse(isLoading)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.getDetails()

        waitForExpectations(timeout: 2, handler: nil)
    }
}
