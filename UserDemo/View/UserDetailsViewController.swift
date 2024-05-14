//
//  UserDetailsViewController.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 16/04/24.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestoreInternal


class UserDetailsViewController: UIViewController {
    
    
    //MARK: - OUTLETS
    @IBOutlet var tableView: UITableView!
    
    //MARK: - PROPERTIES
    var ref: DatabaseReference!
    var arrayOfUser = [User]()
    var user:User?
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllUsersFromFirestore()
    }
    
    
    //MARK: - HELPERS
    func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllUsersFromFirestore()
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: "UserDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "UserDetailTableViewCell")
    }
    
    func getAllUser() {
        ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if let data = value as? [String: Any] {
                if let userData = data["userData"] as? [String: Any] {
                    print(userData)
                }
                
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func fetchAllUsersFromFirestore() {
        Spinner.start()
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (querySnapshot, error) in
            Spinner.stop()
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var users: [String: Any] = [:]
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let userId = document.documentID
                    users[userId] = data
                }
                print("All users: \(users)")
                self.arrayOfUser = []
                for (_,value) in users {
                    guard let resultNew = value as? [String:Any] else {return}
                    let user = User()
                    user.userId = resultNew["userId"] as? String
                    user.email = resultNew["email"] as? String
                    user.name = resultNew["name"] as? String
                    user.url = resultNew["url"] as? String
                    user.lastChat = resultNew["Last Chat"] as? String
                    if  user.email != (Auth.auth().currentUser?.email) {
                        self.arrayOfUser.append(user)
                    } else {
                        self.user = user
                    }
                }
                print(self.arrayOfUser)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func addUserAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        nextVC.isComingFromDashBoard = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func signOutAction(_ sender: Any) {
//        UserDefaults.standard.set(false, forKey: "Exict")
//        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func homeButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func profileButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: false)
    }

}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension UserDetailsViewController:UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailTableViewCell") as! UserDetailTableViewCell
        cell.configData(data: arrayOfUser[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        nextVC.userDetail = arrayOfUser[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
