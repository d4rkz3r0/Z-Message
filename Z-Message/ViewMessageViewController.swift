//
//  ViewMessageViewController.swift
//  Z-Message
//
//  Created by Steve Kerney on 1/22/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ViewMessageViewController: UIViewController
{
    //VC UI Vars
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    //VC Var
    var message : Message = Message();
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        messageTextLabel.text = message.msgText;
        let imageUrl = URL(string: message.imgUrl);
        
        imageView.sd_setImage(with: imageUrl);

    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        //Remove message from user messageDB
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("msgDB").child(message.messageID).removeValue();
        
        //Delete image from storageDB
        //Navigate to ImageDB root folder
        print(message.imgUUID);
        
        let imagesFolder = FIRStorage.storage().reference().child("messageImages");
        
        if(message.isImgHQ == "y")
        {
            imagesFolder.child("\(message.imgUUID)" + ".png").delete { (err) in
                print("HQ Image deleted server side.");
            };
        }
        else
        {
            imagesFolder.child("\(message.imgUUID)" + ".jpg").delete { (err) in
                print("LQ Image deleted server side.");
            };
        }
    }
}
