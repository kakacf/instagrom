//
//  SignUpViewController.swift
//  Instagrom
//
//  Created by KaKa on 2017/1/14.
//  Copyright © 2017年 KaKa. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth



class SignUpViewController: UIViewController {

    //UI
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text, let checkPassword = checkPasswordField.text{
            if password != checkPassword{
                print("Wrong password!")
                return
            }
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error{
                    print("Sign up \(error)!")
                }else{
                    print("Sign up success! (\(user?.email))")
                }
            })
        }
        
    }
    
    
    @IBAction func backToLogInTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}
