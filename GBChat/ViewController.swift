//
//  ViewController.swift
//  GBChat
//
//  Created by Apple on 25/12/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit
import Firebase
import GBFloatingTextField
import MBProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: GBTextField!
    @IBOutlet weak var textFieldPassword: GBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//MARK:-  IBAction Methods
    @IBAction func btnSignIn(_ sender: Any?){
        guard let email = self.textFieldEmail.text else { return }
        guard let password = self.textFieldPassword.text else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil{
                print(error!.localizedDescription)
            }else{
                let friendListController = self.storyboard?.instantiateViewController(withIdentifier: "FriendListTableViewController") as! FriendListTableViewController
                self.navigationController?.pushViewController(friendListController, animated: true)
            }
        }
    }
}

