//
//  VideoChatViewController.swift
//  UserDemo
//
//  Created by Braintech on 08/05/24.
//

import UIKit
import AgoraUIKit

class VideoChatViewController: UIViewController {
    
    //MARK: - Outlet's
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    
    
    //MARK: - Properties
    
    var channelID:String = ""
  
    
    //MARK: - Life-Cycle-Methods
    override func viewDidLoad()   {
        super.viewDidLoad()
        let view  = AgoraVideoViewer(connectionData: AgoraConnectionData(appId: "6341eb03fdc8477da77bb6383159fe0c"))
        view.fills(view: self.videoView)
        view.join(channel: channelID, as: .broadcaster)
        
    }
    
    //MARK: - Helpers
    
    
    //MARK: - Button Actions
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
