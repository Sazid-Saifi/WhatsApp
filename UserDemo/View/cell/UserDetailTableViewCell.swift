//
//  UserDetailTableViewCell.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 16/04/24.
//

import UIKit
import SDWebImage

class UserDetailTableViewCell: UITableViewCell {

    //MARK: - OUTLETS
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    
    //MARK: - LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    func configUI() {
    profileImageView.layer.cornerRadius = profileImageView.frame.width/2
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        
    }
    
    func configData(data:User) {
        nameLabel.text = data.name
        emailLabel.text = data.email
        profileImageView.sd_setImage(with: URL(string: data.url ?? ""), placeholderImage: UIImage(named: "download"))
    }

}
