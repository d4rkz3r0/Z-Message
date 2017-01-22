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

    // FireBase Signin/Acc Creation
    @IBAction func LogInButtonPressed(_ sender: Any)
    {
        //Sign into User Acc
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
        
            // On Completion Code Block
            print("Attempting Sign in.");
            
            if(error != nil)
            {
                print("Sign in failed, user does not exist, or invalid login credentials.");
                
                //Create User Acc
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                
                    print("Creating user..");
                    
                    if(error != nil)
                    {
                        print("Unable to create user.");
                    }
                    else
                    {
                        print("User was created.");
                        
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

