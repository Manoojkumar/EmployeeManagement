//
//  EmployeeDetailListViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 12/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit
import SQLite
import NVActivityIndicatorView
class EmployeeDetailListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var employeeListTableView: UITableView!
    @IBOutlet var noDataFoundVIew: UIView!
    
    var database: EmployeeDataBase!
    var employeeList: [EmployeeList] = []
    
    override func viewDidLoad() {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(NewEmployeeViewController.loader, nil)
        super.viewDidLoad()
        self.employeeListTableView.register(UINib(nibName: "EmployeeDetailListTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeDetailListTableViewCell")
        self.database = EmployeeDataBase()
        self.employeeList = self.database.getTable()
        DispatchQueue.main.async {
            self.employeeListTableView.reloadData()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
       }
    
    override func viewDidAppear(_ animated: Bool) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(NewEmployeeViewController.loader, nil)
        self.employeeList = self.database.getTable()
        DispatchQueue.main.async {
            self.employeeListTableView.reloadData()
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if employeeList.count == 0{
            self.employeeListTableView.isHidden = true
            self.noDataFoundVIew.isHidden = false
            return 0
        }else{
            self.employeeListTableView.isHidden = false
            self.noDataFoundVIew.isHidden = true
            return employeeList.count
        }
        
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDetailListTableViewCell", for: indexPath) as! EmployeeDetailListTableViewCell
        let list = self.employeeList[indexPath.row]
       
        cell.namelbl.text = list.name
        cell.dobLbl.text = list.dob
        cell.emailLbl.text = list.email
        cell.streetLbl.text = list.streetName
        cell.pincodeLbl.text = list.pincode
        if list.showIdCard == "false"{
             cell.idCardStatusLbl.text = "Id Card: Not Created"
        }else{
             cell.idCardStatusLbl.text = "Id Card: Created"
        }
       
        let userImage = UIImage(data: list.userImage)
        cell.userImage.image = userImage!
       
        cell.imageUiView.layer.cornerRadius = cell.imageUiView.frame.size.width / 2
        cell.imageUiView.clipsToBounds = true
        cell.imageUiView.layer.masksToBounds = true

        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2
        cell.userImage.clipsToBounds = true
        cell.userImage.layer.masksToBounds = true
        cell.selectionStyle = .none
        return cell
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EmployeeDetailsViewController") as! EmployeeDetailsViewController
        let data = employeeList[indexPath.row]
        vc.userID = data.userID
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTapCreateNewEmployeeBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
            UIView.animate(withDuration: 0.2){
                let data = self.employeeList[indexPath.row]
                let userID = data.userID
                self.database.delete(userID: userID)
                self.employeeList.remove(at: indexPath.row)
                self.employeeListTableView.deleteRows(at: [IndexPath.init(row: indexPath.row, section: 0)], with: .automatic)
               
                DispatchQueue.main.async {
                    self.employeeListTableView.reloadData()
                }
            }
        }

   
}
