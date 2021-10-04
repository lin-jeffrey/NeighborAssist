//
//  LoginViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 6/30/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    var ref = Database.database().reference()
    
    // takes email/pass from VC and logs in
    @IBAction func loginPress(_ sender: Any) {
        
        let email = emailField.text!
        let password = passwordField.text!
            
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if (error != nil) {
                self.resultLabel.text = "Unable to login"
                self.resultLabel.isHidden = false
            } else {
                self.emailField.text = ""
                self.passwordField.text = ""
                self.resultLabel.isHidden = true
                self.performLogin()
            }
        })
    }
    
    //logs in via Firebase auth and choose role segue
    func performLogin() {
        if let userId = Auth.auth().currentUser?.uid {
            self.ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if (snapshot.value != nil) {
                    var value = snapshot.value as! [String: Any]
                    value["uid"] = userId
                    UserDefaults.standard.set(value, forKey: "userInfo")
                    self.chooseSegueForRole(value["accountType"] as! String)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    //choose vc segue depending on account type
    func chooseSegueForRole(_ accountType: String) {
        if (accountType == "Donor") {
            self.performSegue(withIdentifier: "donorLoginSegue", sender: self)
        } else if (accountType == "Recipient") {
            self.performSegue(withIdentifier: "recipientLoginSegue", sender: self)
        } else if (accountType == "Unknown"){
            self.performSegue(withIdentifier: "chooseRoleSegue", sender: self)
        } else {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing in: %@", signOutError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (Auth.auth().currentUser != nil) {
            performLogin()
        }
    }
}

