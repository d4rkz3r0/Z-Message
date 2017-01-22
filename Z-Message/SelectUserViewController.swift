//
//  SelectUserViewController.swift
//  Z-Message
//
//  Created by Steve Kerney on 1/22/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import UIKit
import Firebase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //VC UI Vars
    @IBOutlet weak var tableView: UITableView!
    
    //VC Vars
    var users : [User] = [];
    
    //MSG Vars
    var imgUrl : String = "";
    var msgText : String = "";
    var imgUUID : String = "";
    var isImgHQ : String = "";
    
    // Init
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        //Grab UserDB root key
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (dataSnapShot) in

            //For every user that was added to the database...
            //Create New User
            let user = User();
            //Set user values
            user.emailAddress = dataSnapShot.childSnapshot(forPath: "emailAddress").value! as! String;
            user.userID = dataSnapShot.key;
            
            //Insert New User into TableView
            self.users.append(user);
            
            //Update UserList
            self.tableView.reloadData();
        });
    }
    
    // Cell Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count;
    }
    
    // Cell Creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let user = users[indexPath.row];
        
        let newCell = UITableViewCell();
        newCell.textLabel?.text = user.emailAddress;
        
        return newCell;
    }
    
    // Cell Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedUser = users[indexPath.row];
        
        //Compose Message
        let message = ["sender" : FIRAuth.auth()!.currentUser!.email!, "msgText" : self.msgText, "imgUrl" : self.imgUrl, "imgUUID" : self.imgUUID, "isHQ" : self.isImgHQ];
        
        //Update recipient msgDB.
        FIRDatabase.database().reference().child("users").child(selectedUser.userID).child("msgDB").childByAutoId().setValue(message);
        
        //Return to 1st screen.
        _ = navigationController!.popToRootViewController(animated: true);
    }
}
