//
//  TransactionDTO.swift
//  testedasd
//
//  Created by João Marcos on 20/09/24.
//

import Foundation

struct TransactionItem: Codable {
    let id: String
    let description: String
    let label: String
    let entry: String
    let amount: Int
    let name: String
    let dateEvent: String
    let status: String

    init() {
        self.id = ""
        self.description = ""
        self.label = ""
        self.entry = ""
        self.amount = 0
        self.name = ""
        self.dateEvent = ""
        self.status = ""
    }

    init(id: String, description: String, label: String, entry: String, amount: Int, name: String, dateEvent: String, status: String) {
        self.id = id
        self.description = description
        self.label = label
        self.entry = entry
        self.amount = amount
        self.name = name
        self.dateEvent = dateEvent
        self.status = status
    }
}


struct DateResult: Codable {
    let items: [TransactionItem]
    let date: String

    init() {
        self.items = []
        self.date = ""
    }

    init(items: [TransactionItem], date: String) {
        self.items = items
        self.date = date
    }
}

struct TransactionDTO: Codable {
    let results: [DateResult]
    let itemsTotal: Int

    init() {
        self.results = []
        self.itemsTotal = 0
    }

    init(results: [DateResult], itemsTotal: Int) {
        self.results = results
        self.itemsTotal = itemsTotal
    }
}


