//
//  LogInViewController.swift
//  Instagrom
//
//  Created by KaKa on 2017/1/15.
//  Copyright © 2017年 KaKa. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth

class LogInViewController: UIViewController {

    //UI
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func logInTapped(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if let error:NSError = error as NSError?{
                    print("Log in \(error)")
                    print("\(error.code)") //利用NSError來做判斷:code 或是 ERROR_NAME來判斷,較不易被原廠更動到內容,而導致無法正確判斷
                    return
                }
                
                if let user = user{
                    print("Log in success! Welcome : \(user.email)")
                }
            
            })
        
        
        }
        
    }
    
    
    @IBAction func signOutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
