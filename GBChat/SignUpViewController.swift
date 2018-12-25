//
//  SignUpViewController.swift
//  GBChat
//
//  Created by Apple on 25/12/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit
import GBFloatingTextField
import Firebase
import MBProgressHUD

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textFieldName: GBTextField!
    @IBOutlet weak var textFieldEmail: GBTextField!
    @IBOutlet weak var textFieldPassword: GBTextField!
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageViewProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImage)))
    }
    
    
//MARK:-  Local Functions
    @objc func profileImage(){
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.sourceType = .photoLibrary
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
//MARK:-  UIImage PickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageViewProfile.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
//MARK:- IBAction Methods
    @IBAction func btnSignUp(_ sender: Any?){
        guard let name = self.textFieldName.text else { return }
        guard let email = self.textFieldEmail.text else { return }
        guard let password = self.textFieldPassword.text else { return }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil{
                let data = self.imageViewProfile.image!.jpegData(compressionQuality: 0.5)
                let storageRef = Storage.storage().reference()
                MBProgressHUD.showAdded(to: self.view, animated: true)
                storageRef.child("UserImages/\(email)/\(email).jpg").putData(data ?? Data(), metadata: nil, completion: { (metadata, storageError) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if storageError != nil{
                        
                    }else{
                        let imageFullPath = "\(metadata!.path!)"
                        let ref = Database.database().reference()
                        MBProgressHUD.showAdded(to: self.view, animated: true)
                        ref.child("Users").childByAutoId().setValue(["username":name, "email":email,"image":imageFullPath], withCompletionBlock: { (dataError, database) in
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if dataError != nil{
                                print(dataError!.localizedDescription)
                            }else{
                                let friendListController = self.storyboard?.instantiateViewController(withIdentifier: "FriendListTableViewController") as! FriendListTableViewController
                                self.navigationController?.pushViewController(friendListController, animated: true)
                            }
                        })
                    }
                })
            }else{
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func btnSignIn(_ sender: Any?){
        self.navigationController?.popViewController(animated: true)
    }
}
