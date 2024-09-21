//
//  KeychainManager.swift
//  testedasd
//
//  Created by João Marcos on 21/09/24.
//

import Foundation
import Security

struct KeychainManager {

    // MARK: - Keychain Keys
    static let tokenKey = "com.coraapp.token"

    // MARK: - Save Token
    static func saveToken(_ token: String){
        guard let tokenData = token.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecValueData as String: tokenData
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
    }

    // MARK: - Load Token
    static func loadToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess, let tokenData = dataTypeRef as? Data else {
            return nil
        }
        return String(data: tokenData, encoding: .utf8)
    }

    // MARK: - Delete Token
    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKey
        ]
        let status = SecItemDelete(query as CFDictionary)
    }
}

