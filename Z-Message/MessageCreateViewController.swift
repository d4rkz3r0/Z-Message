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
    
    //VC UI Helpers
    var imagePicker = UIImagePickerController();
    
    
    //Init
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        QualityButton.setTitle("HQ", for: UIControlState.normal);
        isHQSelected = true;
        NextButton.isEnabled = true;
        
        imagePicker.delegate = self;
    }
    
    //When a user presses the camera button.
    @IBAction func CameraPressed(_ sender: Any)
    {
        //Image Picker's Source
        imagePicker.sourceType = .savedPhotosAlbum;
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
            imagesFolder.child("\(NSUUID().uuidString)" + ".png").put(imageData, metadata: nil, completion:
                { (metadata, err) in
                    print("Attempting image upload to FireBase.");
                    
                    if(err != nil)
                    {
                        //Unable to upload image to FB.
                        print("Error:\(err)")
                    }
                    else
                    {
                        print("Image successfully uploaded to: \(metadata!.downloadURL()!)");
                        //Present contacts to send image/text to.
                        self.performSegue(withIdentifier: "SelectUserSegue", sender: nil);
                    }
            });

        }
        else
        {
            //Grab UIImage from ImageView and convert to .jpg.
            let jpgCompressionLevel = CGFloat(1.0);
            let imageData = UIImageJPEGRepresentation(ImageView.image!, jpgCompressionLevel)!;
            
            //Create new image to store in the server folder.
            imagesFolder.child("\(NSUUID().uuidString)" + ".jpg").put(imageData, metadata: nil, completion:
                { (metadata, err) in
                    print("Attempting image upload to FireBase.");
                    
                    if(err != nil)
                    {
                        //Unable to upload image to FB.
                        print("Error:\(err)")
                    }
                    else
                    {
                        print("Image successfully uploaded to: \(metadata!.downloadURL()!)");
                        //Present contacts to send image/text to.
                        self.performSegue(withIdentifier: "SelectUserSegue", sender: nil);
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
        
        
    }
    
    
    
}
