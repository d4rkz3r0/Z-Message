//
//  MessagesViewController.swift
//  Z-Message
//
//  Created by Steve Kerney on 12/29/16.
//  Copyright © 2016 Steve Kerney. All rights reserved.
//

import UIKit
import Firebase


class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //VC UI Vars
    @IBOutlet weak var tableView: UITableView!
    
    //VC Vars
    var userMessages : [Message] = [];
    
    
    // Init
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self;
        tableView.delegate = self;

        
        // Check for new messages
        //Grab currently logged-in user's Message DB
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("msgDB").observe(FIRDataEventType.childAdded, with: { (dataSnapShot) in
            
            //For each message in the user database...
            //Create New Message Obj
            let message = Message();
            //Set message values
            message.imgUrl = dataSnapShot.childSnapshot(forPath: "imgUrl").value! as! String;
            message.msgText = dataSnapShot.childSnapshot(forPath: "msgText").value! as! String;
            message.sender = dataSnapShot.childSnapshot(forPath: "sender").value! as! String;
            message.messageID = dataSnapShot.key;
            message.imgUUID = dataSnapShot.childSnapshot(forPath: "imgUUID").value as! String;
            message.isImgHQ = dataSnapShot.childSnapshot(forPath: "isHQ").value as! String;
            
            
            //Insert each Message into TableView
            self.userMessages.append(message);
            
            //Update UserList
            self.tableView.reloadData();
        });
        
        // Check for deleted messages
        //Grab currently logged-in user's Message DB
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("msgDB").observe(FIRDataEventType.childRemoved, with: { (dataSnapShot) in
            
            //For each message in the user database...
            var currIndex = 0;
            for aMessage in self.userMessages
            {
                if(aMessage.messageID == dataSnapShot.key)
                {
                    self.userMessages.remove(at: currIndex);
                }
                currIndex += 1;
            }
            
            //Update UserList
            self.tableView.reloadData();
        });
        
        
    }

    // Log user out of Firebase
    @IBAction func LogoutPressed(_ sender: Any)
    {
        dismiss(animated: true)
        {
            
        };
    }
        
    // Cell Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(userMessages.count == 0)
        {
            return 1;
        }
        else
        {
            return userMessages.count;
        }
    }
    
    // Cell Creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let newCell = UITableViewCell();
        
        if(userMessages.count == 0)
        {
           newCell.textLabel?.text = "You have no messages. 😢"
        }
        else
        {
            let message = userMessages[indexPath.row];
            newCell.textLabel?.text = message.sender;
        }
  
    
        return newCell;
    }
    
    // Cell Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedMessage = userMessages[indexPath.row];
        
        performSegue(withIdentifier: "ViewMessageSegue", sender: selectedMessage);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "ViewMessageSegue")
        {
            let nextVC = segue.destination as! ViewMessageViewController;
            nextVC.message = sender as! Message;
        }
    }
    
    // Misc
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
