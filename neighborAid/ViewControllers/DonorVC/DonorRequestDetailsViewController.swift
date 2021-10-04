//
//  DonorRequestDetailsViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/18/21.
//

import Foundation
import Firebase

class DonorRequestDetailsViewController: UIViewController {
    public var request: Request?
    
    var recipient: User = User(aboutMe: "", accountType: "", email: "", name: "", uid: "")
    
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemDescriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var recipientButton: UIButton!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemNameLabel.text = request?.itemName
        self.itemDescriptionLabel.text = request?.itemDescription
        self.dateLabel.text = request?.dateTime
            
        //make item description box wrap text
        self.itemDescriptionLabel.numberOfLines = 0;
        self.itemDescriptionLabel.sizeToFit()
        
        //get recipient user information
        ref.child("users/\(request!.uid)").observeSingleEvent(of: .value, with: { snapshot in
            if let Item = snapshot.value as? [String: Any]{
                let aboutMe = Item["aboutMe"] as? String ?? ""
                let accountType = Item["accountType"] as? String ?? ""
                let email = Item["email"] as? String ?? ""
                let name = Item["name"] as? String ?? ""
                let uid = Item["uid"] as? String ?? ""
                self.recipient = User(aboutMe: aboutMe, accountType: accountType, email: email, name: name, uid: uid)
                self.recipientButton.setTitle(self.recipient.name, for: .normal)
            }
        })
    }
    
    @IBAction func donatePress(_ sender: Any) {
        self.performSegue(withIdentifier: "DonationOfferSegue", sender: self)
    }
    
    @IBAction func userProfilePress(_ sender: Any) {
        self.performSegue(withIdentifier: "RecipientProfileSegue", sender: self)
    }
    
    @IBAction func returnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //send data to vc via segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DonationOfferSegue") {
            let vc = segue.destination as! DonationOfferViewController
            vc.request = request
        }
        if (segue.identifier == "RecipientProfileSegue") {
            let vc = segue.destination as! UserProfileViewController
            vc.user = recipient
        }
    }
    
}

