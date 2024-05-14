//
//  AccountViewController.swift
//  UserDemo
//
//  Created by Braintech on 06/05/24.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {
    
    
    //MARK: - Outlet's
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Properties
    var user:User?
    
    //MARK: - Life-Cycle-Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        confiqureUI()
    }
    
    //MARK: - Helpers
    
    func confiqureUI() {
        emailLabel.text = Auth.auth().currentUser?.email
        nameLabel.text = user?.name?.capitalized
        
    }

    //MARK: - Button Actions
    @IBAction func homeButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func iimageSelectButtonAction(_ sender: Any) {
        
    }
    
    
    @IBAction func menuButtonAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "Exict")
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
