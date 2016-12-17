//
//  SocketManager.swift
//  ClassE
//
//  Created by JinHongxu on 2016/12/15.
//  Copyright © 2016年 JinHongxu. All rights reserved.
//

import SocketIO

protocol SocketManagerDelegate {
    func SocketDidConnect()
    func SocketDidReciveMessage(message: String)
}

class SocketManager {
    
    let socket = SocketIOClient(socketURL: URL(string: "http://104.194.67.188:12345")!, config: [.log(true), .forcePolling(true)])
    var delegate: SocketManagerDelegate?
    
    static let shared = SocketManager()
    private init() {}
    
    func initHandler() {
        
        socket.on("connect") { data, ack in
            self.delegate?.SocketDidConnect()
        }
        
        socket.on("messageS2C") { data, ack in
            let dict = data[0] as! Dictionary<String, String>
            let message = dict["message"] ?? "A Message From No Man's Sky"
            self.delegate?.SocketDidReciveMessage(message: message)
        }
        
        connect()
    }
    
    func emit(message: String) {
        socket.emit("messageC2S", ["message": message])
    }
    
    private func connect() {
        socket.connect()
    }
    
    func reconnect() {
        socket.reconnect()
    }
    
}
