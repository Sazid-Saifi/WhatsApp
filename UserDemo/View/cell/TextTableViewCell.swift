//
//  TextTableViewCell.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 19/04/24.
//

import UIKit

class TextTableViewCell: UITableViewCell {

    //MARK: - OUTLETS
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet weak var contentViewWiidth: NSLayoutConstraint!
    @IBOutlet weak var contentViewHight: NSLayoutConstraint!
    @IBOutlet weak var messageContentView: UIView!
    
    //MARK: - LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        confiqureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - Helpers
    func confiqureUI() {
        messageContentView.layer.cornerRadius = 8
    }
    
    func confiqureData(data:String) {
     messageLabel.text = data
//        contentViewWiidth.constant = messageLabel.intrinsicContentSize.width+15
//        if  contentViewWiidth.constant < 300 {
//            contentViewWiidth.constant = messageLabel.intrinsicContentSize.width+15
//        } else {
//            contentViewWiidth.constant = 300
//        }
//        
//        contentViewHight.constant = messageLabel.intrinsicContentSize.height+15
    }
    
}
