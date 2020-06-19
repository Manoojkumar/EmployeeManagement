//
//  EmployeeDetailListViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 12/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit

class EmployeeDetailListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var employeeListTableView: UITableView!
    
    @IBOutlet var noDataFoundVIew: UIView!
    override func viewDidLoad() {
           super.viewDidLoad()

           self.employeeListTableView.register(UINib(nibName: "EmployeeDetailListTableViewCell", bundle: nil), forCellReuseIdentifier: "EmployeeDetailListTableViewCell")
           DispatchQueue.main.async {
               self.employeeListTableView.reloadData()
           }
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 5
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeDetailListTableViewCell", for: indexPath) as! EmployeeDetailListTableViewCell
           cell.selectionStyle = .none
           return cell
       }
       
       func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "EmployeeDetailsViewController") as! EmployeeDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTapCreateNewEmployeeBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewEmployeeViewController") as! NewEmployeeViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
