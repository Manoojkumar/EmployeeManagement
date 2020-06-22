//
//  EmployeeDetailsViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 13/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit
import SwiftMessages
import NVActivityIndicatorView

class EmployeeDetailsViewController: UIViewController {

    @IBOutlet var userImageUiView: UIView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var dobLbl: UILabel!
    
    @IBOutlet var emailLbl: UILabel!
    
    @IBOutlet var streetLbl: UILabel!
    @IBOutlet var pincodeLbl: UILabel!
    
    @IBOutlet var idCardStatusLbl: UILabel!
    
    @IBOutlet var newIdCardView: CardView!
    @IBOutlet var newOrViewIdCardLbl: UIButton!
    
    var userID = 0
    var database: EmployeeDataBase!
    var employeeList: [EmployeeList] = []
    var idCardBtnStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(NewEmployeeViewController.loader, nil)
        self.database = EmployeeDataBase()
        self.employeeList = self.database.getTable()
        self.userImageUiView.layer.cornerRadius = self.userImageUiView.frame.size.width / 2
        self.userImageUiView.clipsToBounds = true
        self.userImageUiView.layer.masksToBounds = true

        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.userImage.clipsToBounds = true
        self.userImage.layer.masksToBounds = true
        
        
        self.getData()

        // Do any additional setup after loading the view.
    }
    
    func getData(){
        
        for data in employeeList{
            if userID == data.userID{
                self.nameLbl.text = data.name
                self.emailLbl.text = data.email
                self.dobLbl.text = data.dob
                self.streetLbl.text = data.streetName
                self.pincodeLbl.text = data.pincode
                if data.showIdCard == "false"{
                    self.idCardStatusLbl.textColor = #colorLiteral(red: 0.8862745098, green: 0.3803921569, blue: 0.3254901961, alpha: 1)
                    self.idCardStatusLbl.text = "Not Created"
                    self.newOrViewIdCardLbl.setTitle("Create New Id Card", for: .normal)
                    self.idCardBtnStatus = false
                }else{
                    self.idCardStatusLbl.textColor = #colorLiteral(red: 0.2039215686, green: 0.6588235294, blue: 0.3215686275, alpha: 1)
                    self.idCardStatusLbl.text = "Created"
                    self.newOrViewIdCardLbl.setTitle("View Id Card", for: .normal)
                    self.idCardBtnStatus = true
                }
                let userImage = UIImage(data: data.userImage)
                self.userImage.image = userImage!
                
            }
        }
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(NewEmployeeViewController.loader, nil)
        self.getData()
    }
    
    @IBAction func didTapEditBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewEmployeeViewController") as! NewEmployeeViewController
        vc.userID = userID
        vc.edit = true
        vc.employeeList = employeeList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapCreateNewIdCardBtn(_ sender: Any) {
        if idCardBtnStatus == false{
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(NewEmployeeViewController.loader, nil)
            let filteredIndex = self.employeeList.enumerated().filter({ $0.element.userID == self.userID}).map({$0.offset})
            let employeeData = self.employeeList[filteredIndex.first!]
            employeeData.showIdCard = "true"
            let updatedData = self.database.updateUser(employee: employeeData)
            if updatedData == true{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.messageAlertView(title: "Success", body: "ID Card Generated Successfully", theme: .success, showButton: true, action: {_ in
                        self.idCardStatusLbl.textColor = #colorLiteral(red: 0.2039215686, green: 0.6588235294, blue: 0.3215686275, alpha: 1)
                        self.idCardStatusLbl.text = "Created"
                        self.newOrViewIdCardLbl.setTitle("View Id Card", for: .normal)
                        self.idCardBtnStatus = true
                        SwiftMessages.hide()
                    })
                }
            }else{
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                self.messageView(title: "Alert", body: "Something went wrong in database", theme: .warning)
            }
                        
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NewIdCardViewController") as! NewIdCardViewController
            vc.userID = self.userID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
   
    
   
}
