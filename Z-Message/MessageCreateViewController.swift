//
//  MessageCreateViewController.swift
//  Z-Message
//
//  Created by Steve Kerney on 1/3/17.
//  Copyright © 2017 Steve Kerney. All rights reserved.
//

import UIKit
import Firebase

class MessageCreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    //VC UI Elements
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var MessageTextField: UITextField!
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var QualityButton: UIButton!
    
    var isHQSelected : Bool!;
    var imgUUID : String! = NSUUID().uuidString;
    
    //VC UI Helpers
    var imagePicker = UIImagePickerController();
    
    
    //Init
    override func viewDidLoad()
    {
        super.viewDidLoad()

        QualityButton.setTitle("HQ", for: UIControlState.normal);
        isHQSelected = true;
        NextButton.isEnabled = false;
        
        imagePicker.delegate = self;
    }
    
    //When a user presses the camera button.
    @IBAction func CameraPressed(_ sender: Any)
    {
        //Image Picker's Source
        imagePicker.sourceType = .camera;
        imagePicker.allowsEditing = false;
        
        //Show to user
        present(imagePicker, animated: true, completion: nil);
    }
    
    // After Image is picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //Grab Selected Image
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage;
        
        //Update UIImageView
        ImageView.image = selectedImage;
        
        //Clear BG Color
        ImageView.backgroundColor = UIColor.clear;
        
        //Enable Next Button
        NextButton.isEnabled = true;
        
        //Pop ImagePicker
        imagePicker.dismiss(animated: true, completion: nil);
    }
    

    // Attempt to upload message to FireBase.
    @IBAction func NextPressed(_ sender: Any)
    {
        //Disable multiple uploads.
        NextButton.isEnabled = false;
        
        //Move into server images folder.
        let imagesFolder = FIRStorage.storage().reference().child("messageImages");
  
        if(isHQSelected == true)
        {
            //Grab UIImage from ImageView and convert to .png.
            let imageData = UIImagePNGRepresentation(ImageView.image!)!;
            
            //Create new image to store in the server folder.
            
            let imgUUID = "\(self.imgUUID!)" + ".png";
            
            imagesFolder.child(imgUUID).put(imageData, metadata: nil, completion:
                { (metadata, err) in
                    print("Attempting image upload to FireBase.");
                    
                    if(err != nil)
                    {
                        //Unable to upload image to FB.
                        print("Error:\(err)")
                    }
                    else
                    {
                        print("Image successfully uploaded.");
                        //Present contacts to send image/text to.
                        self.performSegue(withIdentifier: "SelectUserSegue", sender: metadata!.downloadURL()!.absoluteString);
                    }
            });

        }
        else
        {
            //Grab UIImage from ImageView and convert to .jpg.
            let jpgCompressionLevel = CGFloat(1.0);
            let imageData = UIImageJPEGRepresentation(ImageView.image!, jpgCompressionLevel)!;
            
            //Create new image to store in the server folder.
            let imgUUID = "\(self.imgUUID!)" + ".jpg";
            
            imagesFolder.child(imgUUID).put(imageData, metadata: nil, completion:
                { (metadata, err) in
                    print("Attempting image upload to FireBase.");
                    
                    if(err != nil)
                    {
                        //Unable to upload image to FB.
                        print("Error:\(err)")
                    }
                    else
                    {
                        print("Image successfully uploaded.");
                        //Present contacts to send image/text to.
                        self.performSegue(withIdentifier: "SelectUserSegue", sender: metadata!.downloadURL()!.absoluteString);
                    }
            });

        }
    }
    
    
    @IBAction func QualityButtonPressed(_ sender: Any)
    {
        isHQSelected = !isHQSelected;
        if(isHQSelected == true)
        {
            QualityButton.setTitle("HQ", for: UIControlState.normal);
        }
        else
        {
            QualityButton.setTitle("LQ", for: UIControlState.normal);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let nextVC = segue.destination as! SelectUserViewController;
        nextVC.msgText = MessageTextField.text!;
        nextVC.imgUrl = sender as! String;
        nextVC.imgUUID = self.imgUUID;
        if(isHQSelected == true)
        {
            nextVC.isImgHQ = "y";
        }
        else
        {
            nextVC.isImgHQ = "n";
        }
    }
}
