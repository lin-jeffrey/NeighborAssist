//
//  SettingsViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/12/21.
//

import Foundation
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutPress(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    @IBAction func returnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
