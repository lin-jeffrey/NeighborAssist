//
//  NewRequestViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/12/21.
//

import Foundation
import Firebase

class NewRequestViewController: UIViewController {

    @IBOutlet var itemNameField: UITextField!
    @IBOutlet var itemDescriptionField: UITextView!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    //takes input from form and creates new request in db
    //under /requests/\(key) and /user-requests/\(userID)/\(key)
    @IBAction func requestConfirmPress(_ sender: Any) {
        let itemName = itemNameField.text!
        let itemDescription = itemDescriptionField.text!
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        let dateTime = formatter.string(from: currentDateTime)
        
        guard let key = ref.child("requests").childByAutoId().key else { return }
        let request = ["uid": userID,
                       "dateTime": dateTime,
                       "itemName": itemName,
                       "itemDescription": itemDescription,
                       "donationStatus": "Pending",
                       "donorID": "NA",
                       "donationItem": "",
                       "donationDescription": "",]
        let childUpdates = ["/requests/\(key)": request,
                            "/user-requests/\(userID)/\(key)/": request]
        ref.updateChildValues(childUpdates)
        
        print(userID)
        print(dateTime)
        print(itemName)
        print(itemDescription)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
