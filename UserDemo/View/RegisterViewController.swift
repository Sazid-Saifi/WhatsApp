//
//  RegisterViewController.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 16/04/24.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase
import FirebaseFirestoreInternal

class RegisterViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var haveAccountLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var selectImageButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    var ref: DatabaseReference!
    var isComingFromDashBoard = false
    var imagePicker = UIImagePickerController()
    var url = ""
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    //MARK: - HELPERS
    func saveText(userID:String) {
        let db = Firestore.firestore()
        let dict = ["email": self.emailTextfield.text!,"name": self.nameTextField.text!, "url": self.url, "userId": userID]
        db.collection("users").addDocument(data: dict as [String : Any])
    }
    
    func configUI() {
        ref = Database.database().reference()
        if isComingFromDashBoard {
            haveAccountLabel.isHidden = true
            backButton.setTitle("Back", for: .normal)
        }
        selectImageButton.layer.borderWidth = 0.3
        selectImageButton.layer.borderColor = UIColor.gray.cgColor
        selectImageButton.layer.cornerRadius = 4
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "Email Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        ageTextField.attributedPlaceholder = NSAttributedString(
            string: "Age",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
    func validation() -> String? {
        if nameTextField.text == "" {
            return Messages.name
        } else if emailTextfield.text == "" {
            return Messages.email
        } else if ageTextField.text == "" {
            return Messages.age
        } else if passwordTextField.text == "" {
            return Messages.password
        } else {
            return nil
        }
    }
    
    //MARK: - BUTTON ACTION
    @IBAction func submitAction(_ sender: Any) {
        if let result = validation() {
            let alertController = UIAlertController(title: nil, message: result, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: false)
        } else {
            Spinner.start()
            Auth.auth().createUser(withEmail: emailTextfield.text ?? "", password: passwordTextField.text ?? "") { (user, error) in
                Spinner.stop()
                if let error = error {
                    let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: false)
                }
                else if let _ = user {
                    print(user?.user.uid)
                    self.saveText(userID: (user?.user.uid)! )
                    let alertController = UIAlertController(title: nil, message: "Successfully Register", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: false)
                }
            }
        }
    }
    
    
    @IBAction func backToLoginPage(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func selectImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
}

//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageView.image = image
        Spinner.start()
        RegisterViewController.uploadImage(imageView.image!, completion: { result in
            Spinner.stop()
            switch result {
            case .success(let url):
                print("Image uploaded successfully. URL: \(url)")
                self.url = "\(url)"
                
            case .failure(let error):
                print("Error uploading image: \(error)")
            }
        })
        
    }
    
    static func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let imageName = "\(UUID().uuidString).jpg"
        let storageRef = Storage.storage().reference().child("images/\(imageName)")
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "YourAppDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
    
        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "YourAppDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])))
                }
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let url = url {
                    completion(.success(url))
                } else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.failure(NSError(domain: "YourAppDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                    }
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Handle progress
        }
        
        uploadTask.observe(.success) { snapshot in
            // Handle success
        }
        
        uploadTask.observe(.failure) { snapshot in
            // Handle failure
        }
    }
  
}

