//
//  Chat.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 22/04/24.
//

import Foundation
import Firebase
//
//class Message {
//    var userId = ""
//    var chatType = " "
//    var date = ""
//    var messageBody = " "
//    var receiver = ""
//    var sender = " "
//}
//
//
//
//class MessageModel {
//    var text: String
//    var senderId: String
//    var receiverId: String
//    var timestamp: TimeInterval
//
//    init(text: String, senderId: String, receiverId: String) {
//        self.text = text
//        self.senderId = senderId
//        self.receiverId = receiverId
//        self.timestamp = Date().timeIntervalSince1970
//    }
//
//    func save() {
//        let ref = Database.database().reference().child("messages").childByAutoId()
//        let messageData: [String: Any] = [
//            "text": text,
//            "senderId": senderId,
//            "receiverId": receiverId,
//            "timestamp": timestamp
//        ]
//        ref.setValue(messageData)
//    }
//}


struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
