//
//  HomeViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 12/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var newEmployeeBtnCardView: CardView!
    @IBOutlet var viewEmployeeCardView: CardView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newEmployeeeCardTapped = UITapGestureRecognizer(target: self, action: #selector(self.didTapNewEmployeeCardView(gesture:)))
        self.newEmployeeBtnCardView.addGestureRecognizer(newEmployeeeCardTapped)
        
        let viewEmployeeCardTapped = UITapGestureRecognizer(target: self, action: #selector(self.didTapviewEmployeeCardView(gesture:)))
        self.viewEmployeeCardView.addGestureRecognizer(viewEmployeeCardTapped)
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapNewEmployeeCardView(gesture: UITapGestureRecognizer){
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           let vc = storyBoard.instantiateViewController(withIdentifier: "NewEmployeeViewController") as! NewEmployeeViewController
           self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapviewEmployeeCardView(gesture: UITapGestureRecognizer){
              let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
              let vc = storyBoard.instantiateViewController(withIdentifier: "EmployeeDetailListViewController") as! EmployeeDetailListViewController
              self.navigationController?.pushViewController(vc, animated: true)
    }

}
