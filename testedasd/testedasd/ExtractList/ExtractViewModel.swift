//
//  ExtractViewModel.swift
//  testedasd
//
//  Created by João Marcos on 20/09/24.
//

import Foundation

class ExtractViewModel {
    
    // MARK: - Private Constants
    private var extractList: TransactionDTO?

    // MARK: - Constants
    var onSuccess: (() -> Void)?
    var networkManager: NetworkManagerProtocol = NetworkManager.shared

    func getExtractListItemsTotalCount() -> Int {
        guard let count = extractList?.itemsTotal else {
            return 0
        }
        return count
    }

    func getExtractListCount(with section: Int) -> Int {
        guard let count = extractList?.results[section].items.count else {
            return 0
        }
        return count
    }

    func getExtractListTransaction(with section: Int, and index: Int) -> TransactionModel? {
        guard let item = extractList?.results[section].items[index] else {
            return nil
        }
        return TransactionModel(amount: String(item.amount.toBrazilianCurrency()),
                                type: item.label,
                                sender: item.name,
                                time: item.dateEvent.formatToTime())
    }

    func getTransactionID(with section: Int, and index: Int) -> String {
        guard let item = extractList?.results[section].items[index] else {
            return ""
        }
        return item.id
    }
    
    func logout() {
        networkManager.logout()
    }

    func getExtract() {
        networkManager.getExtract() { result in
            switch result {
                case .success(let list):
                    self.extractList = list
                    self.onSuccess?()
                    print("list: \(list)")
                case .failure(let error):
                    print("error: \(error)")
                    //TODO: Tratamento de erro
            }
        }
    }

    func getDate(with section: Int) -> String{
        guard let date = extractList?.results[section].date.formattedDateString() else {
            return ""
        }
        return date
    }
}
