//
//  SettingsViewController.swift
//  InstaClone
//
//  Created by Yasin Cengiz on 15.02.2020.
//  Copyright © 2020 MrYC. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
    

    
    @IBAction func logOutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print("Error")
        }
        
    }
    
    
    
    
    
    
    
    

}
