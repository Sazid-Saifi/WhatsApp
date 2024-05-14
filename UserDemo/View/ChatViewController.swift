//
//  ChatViewController.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 19/04/24.
//

import UIKit
import FirebaseDatabase
import Firebase
import Network
import FirebaseAuth
import CallKit
import AgoraUIKit
import AgoraRtcKit
import IQKeyboardManagerSwift
import FirebaseFirestoreInternal


class ChatViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var backgroundView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var videoChatView: UIView!
    @IBOutlet weak var VideoCallbutton: UIButton!
    
    //MARK: - PROPERTIES
    var userDetail:User?
    var senderId:String?
    var receiverId:String?
    var message:[[String:Any]] = []
    var arrayOfMessage = [Message]()
    var dateString:String?
    var agoraKit: AgoraRtcEngineKit!
    var endButton:UIButton?
    var isCallLive:Bool = false
    var agoraView: AgoraVideoViewer?
    //MARK: - LIFECYCLE
    override func viewDidLoad()   {
        
        configUI()
        registerCell()
        self.fetchMessageData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configUI()
    }
    
    
    //MARK: - HELPERS
    func configUI() {
        videoChatView.isHidden = true
        chatTableView.dataSource = self
        chatTableView.delegate = self
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        senderId = Auth.auth().currentUser?.email
        if let data = userDetail {
            configData(data: data)
        }
        receiverId = userDetail?.userId
        chatTableView.showsVerticalScrollIndicator  = true
        chatTableView.showsVerticalScrollIndicator = true
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateString = dateFormatter.string(from: currentDate)
        messageTextView.layer.cornerRadius = 8
        //        messageTextView.delegate = self
        //        messageTextView.text = "Type Message..."
        //        messageTextView.textColor = UIColor.lightGray
        //                endButton = UIButton(type: .custom)
        //                endButton?.setTitle("End Call", for: .normal)
        //                endButton?.setTitleColor(.white, for: .normal)
        //                endButton?.backgroundColor = .red
        //        endButton.addTarget(self, action: #selector(), for: .touchUpInside)
    }
    
    func configData(data:User) {
        if let name = data.name {
            userNameLabel.text = name.capitalized
        }
        profileImageView.sd_setImage(with: URL(string: data.url ?? ""), placeholderImage: UIImage(named: "download"))
    }
    
    func scrollToBottom(){
        if arrayOfMessage.count > 1 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.arrayOfMessage.count-1, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func registerCell() {
        chatTableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        chatTableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceiverTableViewCell")
        
    }
    
    func sendMessage(with message: String?, chatType: String?) {
        guard let senderId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let databaseRef = Database.database().reference()
        
        guard let senderKey = databaseRef.child("Users").child(senderId).child("message").childByAutoId().key else { return }
        guard let receiverKey = databaseRef.child("Users").child(receiverId ?? " ").child("message").childByAutoId().key else { return }
        
        let dictData: [String: Any?]  = ["receiverId": self.userDetail?.email, "receiverName": self.userDetail?.name, "senderId": Auth.auth().currentUser?.email, "senderName": Auth.auth().currentUser?.displayName, "text": message,"senderKey": senderKey, "receiverKey": receiverKey,"chatImageUrl": nil, "chatType": chatType,"date": self.dateString!]
        
        //Send data to Self
        let user = databaseRef.child("Users").child(senderId)
        user.child("message").child(senderKey).setValue(dictData) { (error, ref) in
            if(error == nil){
                self.messageTextView.text = ""
                self.view.endEditing(true)
            } else {
                print("Error to send textMessage to self")
            }
        }
        
        //Send data to Receiver
        let receiver = databaseRef.child("Users").child(receiverId ?? "")
        receiver.child("message").child(receiverKey).setValue(dictData) { (error, ref) in
            if(error == nil){
                self.messageTextView.text = ""
                self.view.endEditing(true)
                //                self.fetchMessageData()
                
                print("Done")
            } else {
                print("Error to send textMessage to Receiver")
            }
        }
    }
    
    
    
    private func fetchMessageData() {
        
        guard let recieverUid = self.userDetail?.userId else {
            return
        }
        
        Database.database().reference().child("Users").child(recieverUid).child("message").observe(.value) { (snapshot) in
            self.arrayOfMessage.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if let dict = snap.value as? [String: String] {
                        let recieverId1 = (dict["receiverId"] ?? "") as String
                        let recieverName = (dict["receiverName"] ?? "") as String
                        let senderId = (dict["senderId"] ?? "") as String
                        let senderName = (dict["senderName"] ?? "") as String
                        let text = (dict["text"] ?? "") as String
                        let chatImageUrl  = (dict["chatImageUrl"] ?? "") as String
                        let chatType  = (dict["chatType"] ?? "") as String
                        let fileUrl  = (dict["fileUrl"] ?? "") as String
                        let senderKey  = (dict["senderKey"] ?? "") as String
                        let receiverKey  = (dict["receiverKey"] ?? "") as String
                        let date  = (dict["date"] ?? "") as String
                        if ((self.userDetail?.email == senderId && Auth.auth().currentUser?.email == recieverId1) || Auth.auth().currentUser?.email == senderId) {
                            self.arrayOfMessage.append(Message(receiverId: recieverId1, receiverName: recieverName, senderId: senderId, senderName: senderName, text: text, chatImage: chatImageUrl, fileUrl: fileUrl, messageType: chatType, senderKey: senderKey, receiverKey: receiverKey, date: date))
                        }
                    }
                }
                
                self.chatTableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    func joinChannel(channelID: String) {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byToken: nil, channelId: channelID, info:nil, uid:0) {(sid, uid, elapsed) -> Void in
            // Did join channel "demoChannel1"
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    
    func saveChannelID(userID: String, channelID: String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("channels").document(userID) // Assuming 'channels' is your collection name
        
        documentReference.setData(["channelID": channelID]) { error in
            if let error = error {
                // Handle any errors that occur during saving
                print("Error saving channel ID: \(error.localizedDescription)")
            } else {
                print("Channel ID saved successfully for user: \(userID)")
            }
        }
    }
    
    func getChannelID(for userID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection("channels").document(userID)
        
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                if let channelID = document.data()?["channelID"] as? String {
                    completion(channelID)
                } else {
                    completion(nil)
                }
            } else {
                print("Document does not exist or error occurred: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    func removeChannelID(for userID: String) {
        let db = Firestore.firestore()
        let documentReference = db.collection("channels").document(userID)
        
        documentReference.delete { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed")
            }
        }
    }
    
    func endCallButton(view: UIView) {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setImage(UIImage(named: "end_call"), for: .normal)
        //        button.setTitle("End Call", for: .normal)
        let buttonSize = CGSize(width: 65, height: 65) // Adjust size as needed 315 632
        let buttonMargin: CGFloat = 20 // Adjust margin as needed
        button.frame = CGRect(x: view.frame.width - 260,
                              y: view.frame.height - buttonSize.height - 20 ,
                              width: buttonSize.width,
                              height: buttonSize.height)
        print(view.bounds.width)
        button.layer.cornerRadius = buttonSize.width/2
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    // Function to handle button tap
    @objc func buttonTapped(_ sender: UIButton) {
        agoraKit.leaveChannel { [weak self] stats in
            guard let self = self else { return }
            print("Left channel")
            self.videoChatView.removeFromSuperview()
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func sendMessageAction(_ sender: Any) {
        if messageTextView.text != "" {
            sendMessage(with: messageTextView.text, chatType: "text" )
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func CallbuttonAction(_ sender: Any) {
        messageTextView.isHidden = true
        isCallLive = !isCallLive
        if isCallLive {
            // Create a new instance of AgoraVideoViewer if it's not already initialized
            if agoraView == nil {
                agoraView = AgoraVideoViewer(connectionData: AgoraConnectionData(appId: "6341eb03fdc8477da77bb6383159fe0c"))
            }
            
            getChannelID(for: userDetail?.email ?? "") { [weak self] (data) in
                guard let self = self else { return }
                guard let agoraView = self.agoraView else { return }
                agoraView.frame = CGRect(x: 4, y: 90, width: self.videoChatView.frame.width, height: self.videoChatView.frame.height)
                if let channelID = data {
                    self.view.addSubview(agoraView)
                    agoraView.join(channel: channelID, as: .broadcaster)
                } else {
                    let channelID = UUID().uuidString
                    self.saveChannelID(userID: Auth.auth().currentUser?.email ?? "", channelID: channelID)
                    self.view.addSubview(agoraView)
                    agoraView.join(channel: channelID, as: .broadcaster)
                }
                self.VideoCallbutton.setImage(UIImage(named: "end_call"), for: .normal)
            }
        } else {
            messageTextView.isHidden = false
            agoraView?.leaveChannel(stopPreview: true)
            agoraView?.removeFromSuperview()
            removeChannelID(for: userDetail?.email ?? "")
            self.VideoCallbutton.setImage(UIImage(named: "phone-call_24"), for: .normal)
        }
    }
}

//MARK: - UITableViewDataSource,UITableViewDelegate
extension ChatViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.arrayOfMessage[indexPath.row].senderId == self.senderId {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell") as! TextTableViewCell
            cell.confiqureData(data: self.arrayOfMessage[indexPath.row].text ?? "")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as! ReceiverTableViewCell
            cell.confiqureData(data: self.arrayOfMessage[indexPath.row].text ?? "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//extension ChatViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//               textView.text = nil
//               textView.textColor = UIColor.black
//           }
//    }
//}
