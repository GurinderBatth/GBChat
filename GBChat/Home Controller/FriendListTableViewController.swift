//
//  FriendListTableViewController.swift
//  GBChat
//
//  Created by Apple on 25/12/18.
//  Copyright © 2018 Batth. All rights reserved.
//

import UIKit
import Firebase

class FriendListTableViewController: UITableViewController {

    lazy var ref = Database.database().reference()

    var arrayFriends = [FriendsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Friends"
        self.getList()
        self.tableView.tableFooterView = UIView()
    }

// MARK:-  Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayFriends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
        let friend = self.arrayFriends[indexPath.row]
        cell.details = friend
        return cell
    }
 

//MARK:-  Local Functions
    func getList() {
        ref.child("Users").observe(.childAdded) { (snapShot) in
            if let dict = snapShot.value as? [String:String]{
                let model = FriendsModel(name: dict["username"], email: dict["email"], image: dict["image"])
                self.arrayFriends.append(model)
            }
            self.tableView.reloadData()
        }
        
        ref.child("Users").observe(.childRemoved) { (snapShot) in
            if let dict = snapShot.value as? [String:String]{
                let modelDelete = FriendsModel(name: dict["username"], email: dict["email"], image: dict["image"])
                if let index = self.arrayFriends.index(where: {$0.email == modelDelete.email}){
                    self.arrayFriends.remove(at: index)
                }
            }
            self.tableView.reloadData()
        }
        
        ref.child("Users").observe(.childChanged) { (snapShot) in
            if let dict = snapShot.value as? [String:String]{
                let modelChange = FriendsModel(name: dict["username"], email: dict["email"], image: dict["image"])
                if let index = self.arrayFriends.index(where: {$0.email == modelChange.email}){
                    self.arrayFriends[index] = modelChange
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
}
