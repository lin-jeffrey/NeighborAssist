//
//  Request.swift
//  neighborAssist
//
//  Created by Jeffrey Lin on 7/8/21.
//

import Foundation

//struct for Requests
struct Request{
    var requestID: String = ""
    var itemName: String = ""
    var itemDescription: String = ""
    var dateTime: String = ""
    var uid: String = ""
    var donationStatus: String = ""
    var donorID: String = ""
    var donationItem: String = ""
    var donationDescription: String = ""
    
    init(requestID: String, itemName: String, itemDescription: String, dateTime: String, uid: String, donationStatus: String, donorID: String, donationItem: String, donationDescription: String) {
        self.requestID = requestID
        self.itemName = itemName
        self.itemDescription = itemDescription
        self.dateTime = dateTime
        self.uid = uid
        self.donationStatus = donationStatus
        self.donorID = donorID
        self.donationItem = donationItem
        self.donationDescription = donationDescription
    }
}
