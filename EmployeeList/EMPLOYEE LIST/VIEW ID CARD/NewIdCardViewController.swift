//
//  NewIdCardViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 13/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit

class NewIdCardViewController: UIViewController {

    @IBOutlet var userImageView: CornerRadius!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var geolocationLbl: UILabel!
    
    @IBOutlet var barCodeImage: UIImageView!
    
    var userID = 0
    var database: EmployeeDataBase!
    var employeeList: [EmployeeList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = EmployeeDataBase()
        self.employeeList = self.database.getTable()
        self.userImageView.layer.borderColor = #colorLiteral(red: 0.1921568627, green: 0.2, blue: 0.3333333333, alpha: 1)
        self.userImageView.layer.borderWidth = 1.0
        for data in employeeList{
           if userID == data.userID{
                self.userNameLbl.text = data.name
                let userImage = UIImage(data: data.userImage)
                self.userImage.image = userImage!
                let barCode = UIImage(data: data.barCode)
                self.barCodeImage.image = barCode
                let dateFormatter : DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
            
            
                self.geolocationLbl.text = "\(data.geoLocation),\(dateString),\(data.weather)"
            
                
           }
        }

        // Do any additional setup after loading the view.
    }
    

}
