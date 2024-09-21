//
//  DetailsExtractViewModel.swift
//  testedasd
//
//  Created by João Marcos on 21/09/24.
//

import Foundation

class DetailsExtractViewModel: ObservableObject {

    var networkManager: NetworkManagerProtocol = NetworkManager.shared

    @Published var extract = TransferDTO()

    @Published var isLoading: Bool = true


    let id: String

    init(id: String) {
        self.id = id
    }

    init () {
        self.id = ""
        self.extract = TransferDTO.mock()
    }

    func getDetails() {
        DispatchQueue.global().async {
            self.networkManager.getExtractDetails(with: self.id) { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let details):
                            self.extract = details
                            self.isLoading = false
                        case .failure(let error):
                            print("error: \(error)")
                            // Tratamento de error
                    }
                }

            }
        }
    }

}
