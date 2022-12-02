//
//  SocketManager.swift
//  FADE
//
//  Created by Devang Lakhani on 25/06/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import SocketIO

enum MyError : Error {
    case runtimeError(String)
    
    var errDesc: String{
        if case let .runtimeError(str) = self{
            return str
        }else{
            return ""
        }
    }
}

typealias CompBlock = (_ json: Any?, _ error: MyError?) -> ()

// Constants
let socketUrl = URL(string: _socketUrl)!

// Observers
let _observerConnectionStateChage     = "observerConnectionStateChage"
let _observerInboxListData            = "observerInboxListData"
let _observerGetMessageHistory        = "observerGetMessageHistory"
let _observerGetSentMessage           = "observerGetSentMessage"
let _observerGetSentMediaMessage      = "obeserverGetSentMediaMessage"
let _observerReceiveNewMessage        = "observerReceiveNewMessage"
let _observerReceiveMediaMessage      = "observerReceiveMediaMessage"
let _observerDeleteChat               = "observerDeleteChat"

class SocketManager {
    
    static var shared = SocketManager()
    
    let token = ["token":"\(_appDelegator.getAuthorizationToken()!)"]
    
    var jsonTokenString: String {
        let jsonData = try! JSONSerialization.data(withJSONObject: token, options:.prettyPrinted)
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(JSONString)
            return JSONString
        } else {
            return ""
        }
    }
    
    lazy var socket: SocketIOClient = SocketIOClient(socketURL: socketUrl, config: SocketIOClientConfiguration(arrayLiteral: SocketIOClientOption.extraHeaders(["token" : "Bearer \(_appDelegator.getAuthorizationToken()!)"]), .log(true), .reconnectWait(3), .forceNew(true)))
    
    init() {
        addConnectionListner()
        addChatObservers()
    }
    
    deinit {
        _defaultCenter.removeObserver(self)
    }
    
    func reConnectSocket() {
        socket = SocketIOClient(socketURL: socketUrl, config: SocketIOClientConfiguration(arrayLiteral: SocketIOClientOption.extraHeaders(["token" : "Bearer \(_appDelegator.getAuthorizationToken()!)"]), .log(true), .reconnectWait(3), .forceNew(true)))
        addConnectionListner()
        addChatObservers()
        socket.connect(timeoutAfter: 0) {
            kprint(items: "socket connected")
        }
    }
    
    func addConnectionListner() {
        socket.on(clientEvent: SocketClientEvent.connect) { (obj, ack) in
            kprint(items: obj)
            kprint(items: "Connected")
        }
        
        socket.on(clientEvent: SocketClientEvent.error) { (obj, ack) in
            kprint(items: obj)
            kprint(items: "Error")
        }
        
        socket.on(clientEvent: SocketClientEvent.disconnect) { (obj, ack) in
            kprint(items: obj)
            kprint(items: "DisConnected")
        }
        
        socket.on(clientEvent: SocketClientEvent.statusChange) { (obj, ack) in
            switch self.socket.status{
            case .connected:
                kprint(items: "Connected")
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerConnectionStateChage), object: nil)
                break
            case .connecting:
                kprint(items: "Connecting....")
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerConnectionStateChage), object: nil)
                break
            case .disconnected:
                kprint(items: "disconnected....")
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerConnectionStateChage), object: nil)
                break
            case .notConnected:
                kprint(items: "notConnected....")
                break
            }
        }
    }
    
    func connectSockect() {
        socket.connect(timeoutAfter: 0) {
            kprint(items: "Socket Connected")
        }
    }
    
    func disConnect() {
        kprint(items: "Socket Disconnected")
        socket.disconnect()
    }
}

// MARK: - Private Methods
extension SocketManager {
    
    fileprivate func emitWitAck(channel: String, param: [String: Any], block: @escaping CompBlock) {
        kprint(items: param)
        if socket.status == .connected{
            socket.emitWithAck(channel, with: [param]).timingOut(after: 0, callback: { (data) in
                if data.count == 2 && ((data.first as? NSNull) != nil){
                    block(data[1], nil)
                }else{
                    if let errStr = data.first as? String{
                        block(nil, MyError.runtimeError(errStr))
                    }else{
                        block(nil, MyError.runtimeError("Error"))
                    }
                }
            })
        }else{
            self.connectSockect()
            block(nil, nil)
        }
    }
}

// MARK: - Chat observer
extension SocketManager {
    
    func addChatObservers() {
        
        /// for get inbox list
        socket.on("setInbox") { (data, ack) in
            if let arr = data as? [NSDictionary], !arr.isEmpty, let dict = arr.first {
                let inboxToken = dict.getStringValue(key: "token")
                guard inboxToken.isEqual(str: _appDelegator.getAuthorizationToken()!) else {return}
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerInboxListData), object: nil, userInfo: ["inboxData":dict])
            }
        }
        
        /// get message history
        socket.on("setMessages") { (data, ack) in
            if let  arr = data as? [NSDictionary], !arr.isEmpty, let dict = arr.first {
                let inboxToken = dict.getStringValue(key: "token")
                guard inboxToken.isEqual(str: _appDelegator.getAuthorizationToken()!) else {return}
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerGetMessageHistory), object: nil, userInfo: ["msgHistory" : dict])
            }
        }
        
        /// for received message
        socket.on("received") { (data, ack) in
            if let arr = data as? [NSDictionary], !arr.isEmpty, let dict = arr.first as? [AnyHashable: Any]{
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerReceiveNewMessage), object: nil, userInfo: ["rcvedMsg":dict])
            }
        }
        
        /// for received media message
        socket.on("receivedmedia") { (data, ack) in
            if let arr = data as? [NSDictionary], !arr.isEmpty, let dict = arr.first as? [AnyHashable: Any]{
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerReceiveMediaMessage), object: nil, userInfo: ["rcvedMediaMsg":dict])
            }
        }
        
        /// get sent message
        socket.on("getCurrentMessage") { (data, ack) in
            if let  arr = data as? [NSDictionary], !arr.isEmpty, let dict = arr.first {
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerGetSentMessage), object: nil, userInfo: ["sentMsg" : dict])
            }
        }
        
        socket.on("sendmedia") { (data, ack) in
            if let arr = data as? [NSDictionary], !arr.isEmpty, let dict = arr.first {
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerGetSentMediaMessage), object: nil, userInfo: ["sentMediaMsg" : dict])
            }
        }
        
        /// delete chat window
        socket.on("deletewindow") { (data, ack) in
            if let  arr = data as? [NSDictionary], !arr.isEmpty, let dict = arr.first {
                _defaultCenter.post(name: NSNotification.Name(rawValue: _observerDeleteChat), object: nil, userInfo: ["dltMsg" : dict])
            }
        }
    }
}

// MARK: - Socket Emits
extension SocketManager {
    
    //get inbox/window list
    func getInboxList() {
        kprint(items: "------------ GET INBOX LIST -----------")
        socket.emit("getInbox", with: [token])
    }
    
    //get chat history
    func getHistory(with grpId:String) {
        kprint(items: "------------ GET CHAT HISTORY -----------")
        let param: [String:Any] = ["token": "\(_appDelegator.getAuthorizationToken()!)", "group_id": grpId]
        socket.emit("getMessages", with: [param])
    }
    
    //get chat history
    func markMsgsAsRead(with userID:String) {
        kprint(items: "------------ MARK MESSAGE AS READ -----------")
        let param: [String:Any] = ["opponent":userID]
        socket.emit("markasread", with: [param])
    }
    
    func sendNewMessage(to id: String,textMsg: String) {
        kprint(items: "------------ SEND NEW MESSAGE -----------")
        let param: [String: Any] = ["message": textMsg,"token": "\(_appDelegator.getAuthorizationToken()!)", "group_id": id, "type": "1"]
        socket.emit("sendMessage", with: [param])
    }
    
    func sendDocument(to id: String, videoUrl: URL?) {
        var mediaBase64String: String!
        if let video = videoUrl {
            do {
                let data = try Data(contentsOf: video)
                mediaBase64String = data.base64EncodedString()
                
                guard mediaBase64String != nil else {return}
                kprint(items: "------------ SEND PDF DOC -----------")
                let param: [String: Any] = ["group_id": id,"media": "data:application/;base64,\(mediaBase64String!)", "type": "5", "token": "\(_appDelegator.getAuthorizationToken()!)"]
                socket.emit("sendFile", with: [param])
                
            } catch let err{
                kprint(items: err.localizedDescription)
            }
        }
    }
    
    func sendAudioMsg(to id: String, videoUrl: URL?) {
        var mediaBase64String: String!
        if let video = videoUrl {
            do {
                let data = try Data(contentsOf: video)
                mediaBase64String = data.base64EncodedString()
                
                guard mediaBase64String != nil else {return}
                kprint(items: "------------ SEND AUDIO MESSAGE -----------")
                let param: [String: Any] = ["group_id": id,"media": "data:audio/m4a;base64,\(mediaBase64String!)", "type": "4", "token": "\(_appDelegator.getAuthorizationToken()!)"]
                socket.emit("sendFile", with: [param])
                
            } catch let err{
                kprint(items: err.localizedDescription)
            }
        }
    }
    
    func sendVideoMsg(to id: String, videoUrl: URL?) {
        var mediaBase64String: String!
        if let video = videoUrl {
            do {
                let data = try Data(contentsOf: video)
                mediaBase64String = data.base64EncodedString()
                
                guard mediaBase64String != nil else {return}
                kprint(items: "------------ SEND VIDEO MESSAGE -----------")
                let param: [String: Any] = ["group_id": id,"media": "data:video/mp4;base64,\(mediaBase64String!)", "type": "3", "token": "\(_appDelegator.getAuthorizationToken()!)"]
                socket.emit("sendFile", with: [param])
                
            } catch let err{
                kprint(items: err.localizedDescription)
            }
        }
    }

    func sendMediaMsg(to id: String,media: UIImage?) {
        var mediaBase64String: String!
        if let img = media {
            var imgData: Data!
            imgData = img.jpegData(compressionQuality: 0.6)
            mediaBase64String = imgData.base64EncodedString()
        }
        guard mediaBase64String != nil else {return}
        kprint(items: "------------ SEND MEDIA MESSAGE -----------")
        //
        let param: [String: Any] = ["group_id": id,"media": "data:image/png;base64,\(mediaBase64String!)", "type": "2", "token": "\(_appDelegator.getAuthorizationToken()!)"]
        socket.emit("sendFile", with: [param])
    }
    
    //deletewindow: {window_id:1}
    func deleteChat(at windowID: String) {
        kprint(items: "------------ DELETE CHAT -----------")
        let param: [String: Any] = ["window_id": windowID]
        socket.emit("deletewindow", with: [param])
    }
    
    
    func deleteMsg(msgId : String){
        kprint(items: "---------- DELETE Message ---------")
        let param : [String:Any] = ["token": "\(_appDelegator.getAuthorizationToken()!)","message_id" : msgId]
        socket.emit("deleteMessage", [param])
    }
    
}

