//
//  Network.swift
//  SolanaSwift
//
//  Created by Chung Tran on 26/01/2021.
//

import Foundation

extension SolanaSDK {
    public enum Network: String, CaseIterable, Codable {
        case mainnetBeta = "mainnet-beta"
        case devnet = "devnet"
        case testnet = "testnet"
        
        public var swapProgramId: PublicKey {
            switch self {
            case .mainnetBeta:
                return try! SolanaSDK.PublicKey(string: "DjVE6JNiYqPL2QXyCUUh8rNjHrbz9hXHNYt99MQ59qw1")
            case .devnet:
                return try! SolanaSDK.PublicKey(string: "DjVE6JNiYqPL2QXyCUUh8rNjHrbz9hXHNYt99MQ59qw1")
            case .testnet:
                return try! SolanaSDK.PublicKey(string: "DjVE6JNiYqPL2QXyCUUh8rNjHrbz9hXHNYt99MQ59qw1")
            }
        }
        
        public var cluster: String {rawValue}
    }
}
