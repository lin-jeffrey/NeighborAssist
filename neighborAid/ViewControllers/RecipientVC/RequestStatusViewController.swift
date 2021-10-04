//
//  RequestStatusViewController.swift
//  neighborAid
//
//  Created by Jeffrey Lin on 7/20/21.
//

import Foundation
import Firebase

class RequestStatusViewController: UIViewController {
    public var request: Request?
    
    var donor: User = User(aboutMe: "", accountType: "", email: "", name: "", uid: "")
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var donationItemNameLabel: UILabel!
    @IBOutlet var donationItemDescriptionLabel: UILabel!
    @IBOutlet var donationItemNameTitleLabel: UILabel!
    @IBOutlet var donationItemDescriptionTitleLabel: UILabel!
    @IBOutlet var contactDonorButton: UIButton!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusLabel.text = request?.donationStatus
        self.donationItemNameLabel.text = request?.donationItem
        self.donationItemDescriptionLabel.text = request?.donationDescription
        let donorID = request?.donorID
        if (donorID == "NA"){
            contactDonorButton.setTitle("", for: .normal)
            self.donationItemNameTitleLabel.text = ""
            self.donationItemDescriptionTitleLabel.text = ""
        }
        
        
        self.donationItemDescriptionLabel.numberOfLines = 0;
        self.donationItemDescriptionLabel.sizeToFit()
        
        //get donor
        if (donorID != "NA"){
            ref.child("users/\(request!.donorID)").observeSingleEvent(of: .value, with: { snapshot in
                if let Item = snapshot.value as? [String: Any]{
                    let aboutMe = Item["aboutMe"] as? String ?? ""
                    let accountType = Item["accountType"] as? String ?? ""
                    let email = Item["email"] as? String ?? ""
                    let name = Item["name"] as? String ?? ""
                    let uid = Item["uid"] as? String ?? ""
                    self.donor = User(aboutMe: aboutMe, accountType: accountType, email: email, name: name, uid: uid)
                }
            })
        }
    }
    
    
    @IBAction func contactDonorPress(_ sender: Any) {
        self.performSegue(withIdentifier: "DonorProfileSegue", sender: self)
    }
    
    
    @IBAction func returnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //send data to vc via segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DonorProfileSegue") {
            let vc = segue.destination as! UserProfileViewController
            vc.user = donor
        }
    }
}

