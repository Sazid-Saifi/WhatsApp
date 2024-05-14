//
//  ViewController.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 16/04/24.
//

import UIKit
//import FirebaseDatabase
import FirebaseAuth
 import Firebase


class LoginViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var loginFormView: UIView!
    @IBOutlet var changeButtonView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var confrimPasswordView: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField2: UITextField!
    @IBOutlet var confrimTextField: UITextField!
    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var loginformLabelView: UIView!
    @IBOutlet var loginbuttonView: UIView!
    @IBOutlet var loginFormLabel: UILabel!
    @IBOutlet var loginformViewhightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewOfbutton: UIStackView!
    @IBOutlet weak var loginLabelSwitch: UILabel!
    @IBOutlet weak var loginButttonSwiitch: UIButton!
    @IBOutlet weak var segementControl: UISegmentedControl!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTextfield: UITextField!
    
    
    //MARK: - PROPERTIES
    var isSignUp = false
    
    //MARK: - PROPERTIES
    var ref: DatabaseReference!
    
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: "Exict") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            configureUI()
        }
    }
     
    
    //MARK: - HELPERS
    func configureUI() {
        ref = Database.database().reference()
            loginFormView.layer.cornerRadius = 6
            loginformLabelView.layer.cornerRadius = 6
            emailView.layer.cornerRadius = 6
            passwordView.layer.cornerRadius = 6
            confrimPasswordView.layer.cornerRadius = 6
            emailView.layer.borderWidth = 0.5
            passwordView.layer.borderWidth = 0.5
            confrimPasswordView.layer.borderWidth = 0.5
            loginButton.layer.cornerRadius = 10
            confrimPasswordView.isHidden = true
            view.backgroundColor = .white
            let gradernt = CAGradientLayer()
            gradernt.colors = [UIColor.blue,UIColor.white]
            gradernt.locations = [0.0, 1.0]
            gradernt.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradernt.endPoint = CGPoint(x: 1.0, y: 1.0)
            //        self.view.layer.insertSublayer(gradernt, at: 0)
            loginButton.layer.insertSublayer(gradernt, at: 0)
            loginFormLabel.text = "Login Form"
            loginformViewhightConstraint.constant = 310
            loginbuttonView.layer.cornerRadius = 6
            stackViewOfbutton.layer.cornerRadius = 6
            loginLabelSwitch.layer.cornerRadius = 6
            loginButttonSwiitch.layer.cornerRadius = 6
            loginLabelSwitch.backgroundColor = UIColor(red: 146/255, green: 168/255, blue: 206/255, alpha: 0.5)
            changeButtonView.layer.cornerRadius = 6
            nameView.isHidden = true
            nameView.layer.cornerRadius = 6
            nameView.layer.borderWidth = 0.5
        
    }
    
    func getUser(userEmail: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        ref.child("users").queryOrdered(byChild: "email").queryEqual(toValue: userEmail).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userData = snapshot.value as? [String: Any] {
                // User data found
                completion(userData, nil)
            } else {
                // User data not found
                completion(nil, nil)
            }
        }) { (error) in
            // Error handling
            completion(nil, error)
        }
    }
    
    func saveText(userID:String, completion: () -> ()) {
        let db = Firestore.firestore()
        let dict = ["email": self.emailTextField.text as Any, "userId": userID, "name": nameTextfield.text as Any, "Last Chat": "" as Any] as [String : Any]
        db.collection("users").addDocument(data: dict as [String : Any])
        completion()
    }
    
    
    func fetchAllUsersFromFirestore() {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (querySnapshot, error) in
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
            }
        }
    }
    
    
    //MARK: - BUTTON ACTION
    @IBAction func submitAction(_ sender: Any) {
        self.view.endEditing(true)
        Spinner.start()
        
        if isSignUp {
            if passwordTextField2.text == confrimTextField.text {
                Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField2.text ?? "") { (user, error) in
                    Spinner.stop()
                    if let error = error {
                        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alertController, animated: false)
                    } else {
                        if let user = user {
                            self.saveText(userID: (user.user.uid), completion: { () in
                                self.nameTextfield.text = ""
                                self.emailTextField.text = ""
//                               self.passwordTextField.text = ""
                                self.confrimTextField.text = ""
                                self.passwordTextField2.text = ""
                                let alertController = UIAlertController(title: nil, message: "User Register Successfully", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alertController, animated: false)
                             })
                            
                        }
                    }
                    
                }
            } else {
                Spinner.stop()
                let alertController = UIAlertController(title: nil, message: "Password and Confrim Password is not same", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: false)
            }
            
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField2.text ?? "") { (user, error) in
                Spinner.stop()
                if let error = error {
                    let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: false)
                }
                else if user != nil {
                    UserDefaults.standard.set(true, forKey: "Exict")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let nextVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
                    self.navigationController?.pushViewController(nextVC, animated: false)
                }
            }
        }
        
    }
    
    
    @IBAction func SegmentAction(_ sender: Any) {
        
        switch segementControl.selectedSegmentIndex {
        case 1:
            loginFormLabel.text = "Sign Up"
            isSignUp = true
            signUpLabel.backgroundColor = UIColor(red: 146/255, green: 168/255, blue: 206/255, alpha: 0.5)
            signUpLabel.textColor = .white
            loginLabelSwitch.backgroundColor = .white
            loginLabelSwitch.textColor = .black
            confrimPasswordView.isHidden = false
            loginformViewhightConstraint.constant = 380
            loginButton.setTitle("Register", for: .normal)
            nameView.isHidden = false
            
        case 0:
            loginFormLabel.text = "Login"
            isSignUp = false
            loginLabelSwitch.backgroundColor = UIColor(red: 146/255, green: 168/255, blue: 206/255, alpha: 0.5)
            loginLabelSwitch.textColor = .white
            signUpLabel.backgroundColor = .white
            signUpLabel.textColor = .black
            confrimPasswordView.isHidden = true
            loginformViewhightConstraint.constant = 290
            loginButton.setTitle("Login", for: .normal)
            nameView.isHidden = true
            
        default:
            print("hii")
        }
    }
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func signUpFormAction(_ sender: Any) {
       
    }
    
    
    @IBAction func loginFormAction(_ sender: Any) {
        
    }
}








//
//if let userEmail = emailTextfield.text {
//            getUser(userEmail: userEmail) { (userData, error) in
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                } else if let userData = userData {
////                    print("User data: \(userData)")
//
//
//                    if let data = userData["userData"] as? [String: Any] {
//
//
//                        if let age = data["age"] {
//                            print("Age:: ",age)
//                        }
//
//                        if let name = data["name"] {
//                            print("name:: ",name)
//                        }
//
//                        if let password = data["password"] {
//                            print("Password:: ",password)
//                        }
//
//                        if let email = data["email"] {
//                            print("email:: ",email)
//                        }
//
//                    }
//
//
//
//                } else {
//
//                    print("User not found")
//                }
//            }
//        }
//
