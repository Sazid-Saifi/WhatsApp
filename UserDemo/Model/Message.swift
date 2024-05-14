//
//  Message.swift
//  UserDemo
//
//  Created by Braintech on 01/05/24.
//

import Foundation
import FirebaseFirestoreInternal



struct Message {
    var receiverId: String?
    var receiverName: String?
    var senderId: String?
    var senderName: String?
    var text: String?
    var chatImage: String?
    var fileUrl: String?
    var messageType: String?
    var senderKey: String?
    var receiverKey: String?
    var date: String?
    
    init(receiverId: String?,receiverName: String? ,senderId: String?,senderName: String?, text: String?, chatImage: String?,fileUrl: String?, messageType: String?, senderKey: String?, receiverKey: String?, date: String?) {
        self.receiverId = receiverId
        self.receiverName = receiverId
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.chatImage = chatImage
        self.fileUrl = fileUrl
        self.messageType = messageType
        self.receiverKey = receiverKey
        self.senderKey = senderKey
    }
}
