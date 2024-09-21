//
//  TransferDTO.swift
//  testedasd
//
//  Created by João Marcos on 21/09/24.
//

import Foundation

// MARK: - TransferDTO
struct TransferDTO: Codable {
    let description: String
    let label: String
    let amount: Int
    let counterPartyName: String
    let id: String
    let dateEvent: String
    let recipient: BankAccountDTO
    let sender: BankAccountDTO
    let status: String

    // Inicializador vazio
    init() {
        self.description = ""
        self.label = ""
        self.amount = 0
        self.counterPartyName = ""
        self.id = ""
        self.dateEvent = ""
        self.recipient = BankAccountDTO()
        self.sender = BankAccountDTO()
        self.status = ""
    }

    init(description: String, label: String, amount: Int, counterPartyName: String, id: String, dateEvent: String, recipient: BankAccountDTO, sender: BankAccountDTO, status: String) {
        self.description = description
        self.label = label
        self.amount = amount
        self.counterPartyName = counterPartyName
        self.id = id
        self.dateEvent = dateEvent
        self.recipient = recipient
        self.sender = sender
        self.status = status
    }
}

// MARK: - BankAccountDTO
struct BankAccountDTO: Codable {
    let bankName: String
    let bankNumber: String
    let documentNumber: String
    let documentType: String
    let accountNumberDigit: String
    let agencyNumberDigit: String
    let agencyNumber: String
    let name: String
    let accountNumber: String

    // Inicializador vazio
    init() {
        self.bankName = ""
        self.bankNumber = ""
        self.documentNumber = ""
        self.documentType = ""
        self.accountNumberDigit = ""
        self.agencyNumberDigit = ""
        self.agencyNumber = ""
        self.name = ""
        self.accountNumber = ""
    }

    init(bankName: String, bankNumber: String, documentNumber: String, documentType: String, accountNumberDigit: String, agencyNumberDigit: String, agencyNumber: String, name: String, accountNumber: String) {
        self.bankName = bankName
        self.bankNumber = bankNumber
        self.documentNumber = documentNumber
        self.documentType = documentType
        self.accountNumberDigit = accountNumberDigit
        self.agencyNumberDigit = agencyNumberDigit
        self.agencyNumber = agencyNumber
        self.name = name
        self.accountNumber = accountNumber
    }
}

// MARK: - TransferDTO Mock
extension TransferDTO {
    static func mock() -> TransferDTO {
        return TransferDTO(
            description: "Developed by the Intel Corporation, HDCP stands for high-bandwidth digital content protection. As the descriptive name implies.",
            label: "Pagamento recebido",
            amount: 150000,
            counterPartyName: "Empresa ABC LTDA",
            id: "abcdef12-3456-7890-abcd-ef1234567890",
            dateEvent: "2024-02-05T14:30:45Z",
            recipient: BankAccountDTO.mockRecipient(),
            sender: BankAccountDTO.mockSender(),
            status: "COMPLETED"
        )
    }
}

// MARK: - BankAccountDTO Mock
extension BankAccountDTO {
    static func mockRecipient() -> BankAccountDTO {
        return BankAccountDTO(
            bankName: "Banco XYZ",
            bankNumber: "001",
            documentNumber: "11223344000155",
            documentType: "CNPJ",
            accountNumberDigit: "9",
            agencyNumberDigit: "7",
            agencyNumber: "1234",
            name: "Empresa ABC LTDA",
            accountNumber: "987654"
        )
    }

    static func mockSender() -> BankAccountDTO {
        return BankAccountDTO(
            bankName: "Banco ABC",
            bankNumber: "002",
            documentNumber: "99887766000112",
            documentType: "CNPJ",
            accountNumberDigit: "3",
            agencyNumberDigit: "1",
            agencyNumber: "5678",
            name: "Empresa XYZ LTDA",
            accountNumber: "543210"
        )
    }
}
