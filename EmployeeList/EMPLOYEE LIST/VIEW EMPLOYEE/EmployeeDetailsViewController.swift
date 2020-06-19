//
//  EmployeeDetailsViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 13/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit

class EmployeeDetailsViewController: UIViewController {

    @IBOutlet var userImageUiView: UIView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var dobLbl: UILabel!
    
    @IBOutlet var emailLbl: UILabel!
    
    @IBOutlet var streetLbl: UILabel!
    @IBOutlet var pincodeLbl: UIStackView!
    
    @IBOutlet var idCardStatusLbl: UILabel!
    
    @IBOutlet var newIdCardView: CardView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapEditBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewEmployeeViewController") as! NewEmployeeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapCreateNewIdCardBtn(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewIdCardViewController") as! NewIdCardViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
   
}
