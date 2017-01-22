//
//  LoginViewController.swift
//  Z-Message
//
//  Created by Steve Kerney on 12/23/16.
//  Copyright © 2016 Steve Kerney. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController
{

    // Sign In UI Vars
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    // Init
    override func viewDidLoad()
    {
        super.viewDidLoad();
    }
    
    
    // FireBase Signin/Acc Creation
    @IBAction func LogInButtonPressed(_ sender: Any)
    {
        //Sign into User Acc
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
        
            // On Completion Code Block
            print("Attempting User Sign in...");
            
            if(error != nil)
            {
                print("Sign in failed, user does not exist, or login credentials were invalid.");
                
                //Create User Acc
                print("Creating user..");
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                
                    
                    
                    if(error != nil)
                    {
                        print("Unable to create user.");
                    }
                    else
                    {
                        print("User was succesfully created.");
                        
                        // Generate unique ID for each new user and store their email address.
                        //Access FireBase Database
                        //Set it's 1st available child to be the user's unique ID.
                        //Add a child to the unique user ID so their email address can be stored in it.
                        FIRDatabase.database().reference().child("users").child(user!.uid).child("emailAddress").setValue(user!.email);
                        
                        print("Signing in new user...");
                        //After Successful User Creation...
                        self.performSegue(withIdentifier: "SignInSegue", sender: nil);
                    }
                })
            }
            else
            {
                print("Sign in successful.");
                
                //After Successful Sign In...
                self.performSegue(withIdentifier: "SignInSegue", sender: nil);
            }
        });
    }
    

    // Misc
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

