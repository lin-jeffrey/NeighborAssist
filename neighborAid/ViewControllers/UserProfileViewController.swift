//
//  UserProfileViewController.swift
//  neighborAid
//
//  Created by Jeffrey Lin on 7/20/21.
//

import Foundation
import Firebase

class UserProfileViewController: UIViewController {
    @IBOutlet var userName: UILabel!
    @IBOutlet var userAboutMe: UILabel!
    @IBOutlet var contactDonorButton: UIButton!
    
    public var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName.text = user?.name
        self.userAboutMe.text = user?.aboutMe
        
        self.userAboutMe.numberOfLines = 0;
        self.userAboutMe.sizeToFit()
    }
    
    @IBAction func returnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contactPress(_ sender: Any) {
        let email = user?.email
        let url = NSURL(string: "mailto:\(email!)")
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        } else {
           // Fallback on earlier versions
            UIApplication.shared.openURL(url! as URL)
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
