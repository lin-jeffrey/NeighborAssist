//
//  CreateAccountViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/1/21.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var password1Field: UITextField!
    @IBOutlet var password2Field: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //email input validation
    func isValidEmail(_ email: String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: email)
    }
    
    @IBAction func createAccountPress(_ sender: Any) {
        let email = emailField.text!
        let password1 = password1Field.text!
        let password2 = password2Field.text!
        
        if (!isValidEmail(email)){
            self.resultLabel.text = "Invalid email entered"
            self.resultLabel.isHidden = false
            return
        }
        else if(password1 == ""){
            self.resultLabel.text = "No password entered"
            self.resultLabel.isHidden = false
            return
        }
        else if(password1.count < 6){
            self.resultLabel.text = "PW must be >6 chars"
            self.resultLabel.isHidden = false
            return
        }
        else if(password1 != password2){
            self.resultLabel.text = "Passwords do not match"
            self.resultLabel.isHidden = false
            return
        }
        //creates user in auth and in db
        Auth.auth().createUser(withEmail: email, password: password1) { authResult, error in
            if (error == nil) {
                print(email)
                print(password1)
                print(password2)
                let userData = ["uid": authResult?.user.uid,
                                "email": email,
                                "accountType": "Unknown"]
                
                self.ref.child("users").child((authResult?.user.uid)!).setValue(userData)
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print(error!)
            }
        }
    }
    
    @IBAction func cancelPress(_ sender: Any) {
        //print("dismissed dismissed yes yes yes")
        self.dismiss(animated: true, completion: nil)
    }
}
