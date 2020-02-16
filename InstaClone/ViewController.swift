//
//  ViewController.swift
//  InstaClone
//
//  Created by Yasin Cengiz on 15.02.2020.
//  Copyright © 2020 MrYC. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailTextField.text != ""  && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (authData, error) in
                if error != nil {
                    self.presentAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            presentAlert(title: "Error!", message: "Username or Password field is empty.")
        }
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailTextField.text != ""  && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (authData, error) in
                if error != nil {
                    self.presentAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            presentAlert(title: "Error!", message: "Username or Password field is empty.")
        }
    }
    
    
    
    

    func presentAlert(title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

