//
//  TransactionModel.swift
//  testedasd
//
//  Created by João Marcos on 20/09/24.
//

import Foundation

struct TransactionModel {
    let amount: String
    let type: String
    let sender: String
    let time: String?
}

enum StatusTransaction {
    case recive // Recebido
    case refunded // Estornado
    case paid // Pago
    case sent // Enviado
    case compensated // Compensado

    init?(from string: String) {
        switch string.lowercased() {
            case "transferência recebida", "pagamento recebido", "depósito via boleto":
                self = .recive
            case "transferência estornada":
                self = .refunded
            case "pagamento de serviço", "compra aprovada", "débito automático", "pagamento efetuado":
                self = .paid
            case "transferência enviada":
                self = .sent
            case "taxa boleto compensado":
                self = .compensated
            default:
                return nil // Retorna nil se o texto não corresponder a nenhum caso
        }
    }
}
