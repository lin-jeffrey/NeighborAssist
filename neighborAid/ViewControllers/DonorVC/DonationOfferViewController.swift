//
//  DonationOfferViewController.swift
//  neighborAid
//
//  Created by Jeffrey Lin on 7/20/21.
//

import Foundation
import Firebase

class DonationOfferViewController: UIViewController {
    public var request: Request?
    
    @IBOutlet var itemNameField: UITextField!
    @IBOutlet var itemDescriptionField: UITextView!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func donateConfirmPress(_ sender: Any) {
        let itemName = itemNameField.text!
        let itemDescription = itemDescriptionField.text!
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Offer Donation?", preferredStyle: .alert)
        
        //create ok button, moves to donate
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            guard let key = self.request?.requestID else { return }
            guard let recipientID = self.request?.uid else { return }
            
            let donation = ["uid": self.request?.uid,
                            "dateTime": self.request?.dateTime,
                            "itemName": self.request?.itemName,
                            "itemDescription": self.request?.itemDescription,
                            "donationStatus": "Donation Offered",
                            "donorID": userID,
                            "donationItem": itemName,
                            "donationDescription": itemDescription]
            let childUpdates = ["/requests/\(key)": donation,
                                "/user-requests/\(recipientID)/\(key)/": donation]
            self.ref.updateChildValues(childUpdates)
            self.dismiss(animated: true, completion: nil)
        })
        //create cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
