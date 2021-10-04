//
//  RecipientRequestDetailsViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/15/21.
//

import Foundation
import Firebase

class RecipientRequestDetailsViewController: UIViewController {
    public var request: Request?
    
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemNameLabel.text = request?.itemName
        self.itemDescriptionLabel.text = request?.itemDescription
        self.dateLabel.text = request?.dateTime
        statusButton.setTitle(request?.donationStatus, for: .normal)
        
        self.itemDescriptionLabel.numberOfLines = 0;
        self.itemDescriptionLabel.sizeToFit()
    }
    
    @IBAction func deletePress(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete the request?", preferredStyle: .alert)
        
        //create ok button, moves to delete()
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             self.delete()
        })
        //create cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    //remove task from database
    func delete() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        ref.child("user-requests").child(userID).child(request!.requestID).removeValue()
        ref.child("requests").child(request!.requestID).removeValue()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func statusPress(_ sender: Any) {
        self.performSegue(withIdentifier: "RequestStatusSegue", sender: self)
    }
    
    //send data to vc via segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RequestStatusSegue") {
            let vc = segue.destination as! RequestStatusViewController
            vc.request = request
        }
    }
    
}
