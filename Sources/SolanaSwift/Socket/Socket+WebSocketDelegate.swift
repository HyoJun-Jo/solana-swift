//
//  Socket+WebSocketDelegate.swift
//  SolanaSwift
//
//  Created by Chung Tran on 31/05/2021.
//

import Foundation
import Starscream

extension SolanaSDK.Socket: WebSocketDelegate {
    public func websocketDidConnect(socket: Starscream.WebSocketClient) {
        status.accept(.connected)
        onOpen()
    }
    
    public func websocketDidDisconnect(socket: Starscream.WebSocketClient, error: Error?) {
        status.accept(.disconnected)
        onClose(0)
        socket.connect()
    }
    
    public func websocketDidReceiveMessage(socket: Starscream.WebSocketClient, text: String) {
        if let data = text.data(using: .utf8) {
            dataSubject.onNext(data)
        }
    }
    
    public func websocketDidReceiveData(socket: Starscream.WebSocketClient, data: Data) {
        dataSubject.onNext(data)
    }
    
    // MARK: - Handlers
    /// On socket opened
    func onOpen() {
        // wipe old subscriptions
        unsubscribeToAllSubscriptions()
        
        // set status
        status.accept(.connected)
        
        // set heart beat
        wsHeartBeat?.invalidate()
        wsHeartBeat = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (_) in
            // Ping server every 5s to prevent idle timeouts
            self.socket.write(ping: Data())
        }
        
        // resubscribe
        subscribeToAllAccounts()
    }
    
    /// On socket error
    /// - Parameter error: socket's error
    func onError(_ error: Error) {
        status.accept(.error(error))
        Logger.log(message: "Socket error: \(error.localizedDescription)", event: .error)
    }
    
    /// On socket closed
    /// - Parameter code: code
    func onClose(_ code: Int) {
        wsHeartBeat?.invalidate()
        wsHeartBeat = nil
    }
}
