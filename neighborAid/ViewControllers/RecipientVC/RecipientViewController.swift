//
//  RecipientViewController.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/13/21.
//

import Foundation
import Firebase
import UIKit

class RecipientViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    //table IBOutlet
    @IBOutlet var table: UITableView!
    
    //stores past user requests
    var requestList = [Request]()
    
    var requestDetailSelection: Request = Request(requestID: "", itemName: "", itemDescription: "", dateTime: "", uid: "", donationStatus: "", donorID: "", donationItem: "", donationDescription: "")
    
    //querys db for user requests and stores on local array
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //connecting table to storyboard tableview
        table.delegate = self
        table.dataSource = self
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        print(userID)
        
        // querys /user-requests/\(userID) and stores each kv pairs in array
        ref.child("user-requests").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            if let allValues = snapshot.value as? [String: Any]{
                for (key,value) in allValues{
                    let Item = value as? [String: Any]
                    let itemName = Item?["itemName"] as? String ?? ""
                    let itemDescription = Item?["itemDescription"] as? String ?? ""
                    let dateTime = Item?["dateTime"] as? String ?? ""
                    let uid = Item?["uid"] as? String ?? ""
                    let donationStatus = Item?["donationStatus"] as? String ?? ""
                    let donorID = Item?["donorID"] as? String ?? ""
                    let donationItem = Item?["donationItem"] as? String ?? ""
                    let donationDescription = Item?["donationDescription"] as? String ?? ""
                    
                    self.requestList.append(Request(requestID: key, itemName: itemName, itemDescription: itemDescription, dateTime: dateTime, uid: uid, donationStatus: donationStatus, donorID: donorID, donationItem: donationItem, donationDescription: donationDescription))
                    self.requestList = self.requestList.sorted(by: { $0.dateTime > $1.dateTime })
                    self.table.reloadData()
                    print(key)
                    print(self.requestList.count)
                }
            }
        })
    }
    
    //refreshes the table (rn it requires two pushes idk why that is)
    @IBAction func refreshPress(_ sender: Any) {
        self.refresh()
    }
    
    func refresh() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        print(userID)
        
        ref.child("user-requests").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            if let allValues = snapshot.value as? [String: Any]{
                self.requestList.removeAll()
                for (key,value) in allValues{
                   let Item = value as? [String: Any]
                    let itemName = Item?["itemName"] as? String ?? ""
                    let itemDescription = Item?["itemDescription"] as? String ?? ""
                    let dateTime = Item?["dateTime"] as? String ?? ""
                    let uid = Item?["uid"] as? String ?? ""
                    let donationStatus = Item?["donationStatus"] as? String ?? ""
                    let donorID = Item?["donorID"] as? String ?? ""
                    let donationItem = Item?["donationItem"] as? String ?? ""
                    let donationDescription = Item?["donationDescription"] as? String ?? ""
                    
                    self.requestList.append(Request(requestID: key, itemName: itemName, itemDescription: itemDescription, dateTime: dateTime, uid: uid, donationStatus: donationStatus, donorID: donorID, donationItem: donationItem, donationDescription: donationDescription))
                    self.requestList = self.requestList.sorted(by: { $0.dateTime > $1.dateTime })
                    self.table.reloadData()
                    print(key)
                    print(self.requestList)
                    print(self.requestList.count)
                }
            }
        })
    }
    
    //following three functions are required to create table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.requestList.count
    }
    
    //connect cell to storyboard celll and then populate each table row with request
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        cell.textLabel?.text = self.requestList[indexPath.row].itemName
        cell.detailTextLabel?.text = self.requestList[indexPath.row].itemDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //sort the request List
        requestList = requestList.sorted(by: { $0.dateTime > $1.dateTime })
        requestDetailSelection = requestList[indexPath.row]
        print(indexPath.row)
        //perform segue to the request detail vc
        self.performSegue(withIdentifier: "RequestDetailSegue", sender: self)
    }
    
    //send data to request detail vc via segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RequestDetailSegue") {
            let vc = segue.destination as! RecipientRequestDetailsViewController
            vc.request = requestDetailSelection
        }
    }
    
    
}
