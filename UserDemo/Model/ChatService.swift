//
//  ChatService.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 25/04/24.
//

import Foundation
import Firebase


class ChatService {
    // Function to observe messages between two users
    func observeMessages(senderId: String, receiverId: String, completion: @escaping ([MessageReciveModel]) -> Void) {
        let messagesRef = Database.database().reference().child("messages")
        
       let query = messagesRef.queryOrdered(byChild: "senderId")
                     .queryLimited(toLast: 50)
        
        // Observe changes in the database
        query.observe(.value) { snapshot,error  in
            var messages: [MessageReciveModel] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let messageData = snapshot.value as? [String: Any] {
                    let message = MessageReciveModel(snapshot: messageData)
                    messages.append(message)
                }
            }
            completion(messages)
        }
    }
}


// Message model
struct MessageReciveModel {
    let text: String
    let senderId: String
    let receiverId: String
    let timestamp: TimeInterval

    init(snapshot: [String: Any]) {
        self.text = snapshot["text"] as? String ?? ""
        self.senderId = snapshot["senderId"] as? String ?? ""
        self.receiverId = snapshot["receiverId"] as? String ?? ""
        self.timestamp = snapshot["timestamp"] as? TimeInterval ?? 0
    }
}
