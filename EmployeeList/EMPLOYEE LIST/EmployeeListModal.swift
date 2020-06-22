//
//  EmployeeListModal.swift
//  EmployeeList
//
//  Created by UITOUX on 14/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import Foundation

class EmployeeListModal{

    var name: String
    var userID: Int
    var email: String
    var dob: String
    var streetName: String
    var pincode: String
    var userImage: String
    var barCode: String
    var weather: String
    var showIdCard: String

    init(name: String, userID: Int, email: String, dob: String, streetName: String, pincode: String, userImage: String, barCode: String, weather: String, showIdCard: String) {

        self.name = name
        self.userID = userID
        self.email = email
        self.dob = dob
        self.streetName = streetName
        self.pincode = pincode
        self.userImage = userImage
        self.barCode = barCode
        self.weather = weather
        self.showIdCard = showIdCard
    }
}
