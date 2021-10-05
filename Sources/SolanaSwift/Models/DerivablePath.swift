//
//  DerivablePath.swift
//  SolanaSwift
//
//  Created by Chung Tran on 06/05/2021.
//

import Foundation

extension SolanaSDK {
    public struct DerivablePath: Hashable, Codable {
        // MARK: - Nested type
        public enum DerivableType: String, CaseIterable, Codable {
            case bip44
            case bip44Account
            case bip44Change
//            case deprecated
            
//            var prefix: String {
//                switch self {
//                case .deprecated:
//                    return "m/501'"
//                    case
//
//                case .bip44, .bip44Change:
//                    return "m/44'/501'"
//                }
//            }
        }
        
        // MARK: - Properties
        public let type: DerivableType
        public let account: Int?
        public let change: Int?
        
        
        public init(type: SolanaSDK.DerivablePath.DerivableType, account: Int? = nil, change: Int? = nil) {
            self.type = type
            self.account = account
            self.change = change
        }
        
        public static var `default`: Self {
            .init(
                type: .bip44Change,
                account: 0,
                change: 0
            )
        }
        
        public var rawValue: String {
//            var value = type.prefix
            switch type {
//            case .deprecated:
//                value += "/\(change)'/0/\(account ?? 0)"
            case .bip44:
//                value += "/\(walletIndex)'"
                return "m"
            case .bip44Account:
                return "m/44'/501'/\(account ?? 0)'"
            case .bip44Change:
//                value += "/\(walletIndex)'/0'"
                return "m/44'/501'/\(account ?? 0)'/\(change ?? 0)'"
            }
        }
    }
}
