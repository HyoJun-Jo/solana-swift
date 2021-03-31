//
//  SolanaSDK+Close.swift
//  SolanaSwift
//
//  Created by Chung Tran on 24/02/2021.
//

import Foundation
import RxSwift

extension SolanaSDK {
    public func closeTokenAccount(
        account: SolanaSDK.Account? = nil,
        tokenPubkey: String,
        isSimulation: Bool = false
    ) -> Single<TransactionID> {
        guard let account = account ?? accountStorage.account else {
            return .error(Error.unauthorized)
        }
        do {
            let tokenPubkey = try PublicKey(string: tokenPubkey)
            
            var transaction = Transaction()
            transaction.closeAccount(tokenPubkey, destination: account.publicKey, owner: account.publicKey)
            return serializeAndSend(transaction: transaction, signers: [account], isSimulation: isSimulation)
        } catch {
            return .error(error)
        }
    }
}