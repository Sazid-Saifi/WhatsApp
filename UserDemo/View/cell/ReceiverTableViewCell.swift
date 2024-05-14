//
//  ReceiverTableViewCell.swift
//  UserDemo
//
//  Created by Braintech on 02/05/24.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    
    
    //MARK: - Outlet's
    @IBOutlet weak var messsageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentViewWiidth: NSLayoutConstraint!
    @IBOutlet weak var contentViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var messageContentView: UIView!
    
    
    //MARK: - Life-Cycle-Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        confiqureUI()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func confiqureUI() {
        messageContentView.layer.cornerRadius = 8
    }
    
   //MARK: - Helpers
    
        func confiqureData(data:String){
            messsageLabel.text = data
//            contentViewWiidth.constant = messsageLabel.intrinsicContentSize.width+15
//            if  contentViewWiidth.constant < 300 {
//                contentViewWiidth.constant = messsageLabel.intrinsicContentSize.width+15
//            } else {
//                contentViewWiidth.constant = 300
//            }
//            contentViewHight.constant = messsageLabel.intrinsicContentSize.height+15
            
            
        }
    
   //MARK: - Button Actions

}
