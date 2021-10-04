//
//  ChooseAccountTypeViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/8/21.
//

import UIKit
import Firebase

class ChooseAccountTypeViewController: UIViewController {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var aboutMeField: UITextField!
    @IBOutlet var accountTypeChoice: UISegmentedControl!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //takes in user info from VC and stores in db under uid
    @IBAction func confirmPress (_ sender: Any) {
        let name = nameField.text!
        let aboutMe = aboutMeField.text!
        let accountType = accountTypeChoice.titleForSegment(at: accountTypeChoice.selectedSegmentIndex)!
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        self.ref.child("users").child(userID).updateChildValues(["name": name,
                                                                 "aboutMe": aboutMe,
                                                                 "accountType": accountType])
        self.chooseSegueForRole(accountType)
        
        print(name)
        print(aboutMe)
        print(accountType)
    }
    
    //taken from login VC
    func chooseSegueForRole(_ accountType: String) {
        if (accountType == "Donor") {
            self.performSegue(withIdentifier: "donorLoginSegue", sender: self)
        } else if (accountType == "Recipient") {
            self.performSegue(withIdentifier: "recipientLoginSegue", sender: self)
        } else {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing in: %@", signOutError)
            }
        }
    }
    
}
