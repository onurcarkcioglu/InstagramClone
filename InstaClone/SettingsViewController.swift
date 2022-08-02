//
//  SettingsViewController.swift
//  InstaClone
//
//  Created by Macbook on 30.06.2022.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
 
    @IBAction func LogoutCliked(_ sender: Any) {
     
          
            do{
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toViewController", sender: nil)
                
            }catch {
                
                print("error")
            }
            
            
        }
        
    }
    


