//
//  NewEmployeeViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 12/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit

class NewEmployeeViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userNameTextfieldView: CornerRadius!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var dobSelectionView: CornerRadius!
    @IBOutlet var dobLbl: UILabel!
    @IBOutlet var emailView: CornerRadius!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var streetNameView: CornerRadius!
    @IBOutlet var streetNameTextField: UITextField!
    @IBOutlet var pincodeView: CornerRadius!
    @IBOutlet var pincodeTextField: UITextField!
    
    @IBOutlet var clearBtn: UIButton!
    
    @IBOutlet var saveBtn: UIButton!
    
    @IBOutlet var idCardSwitchBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //        let location: String = "641045"
        //        let geocoder: CLGeocoder = CLGeocoder()
        //        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
        //            if ((placemarks?.count)! > 0) {
        //                let placemark: CLPlacemark = (placemarks?[0])!
        //                let country : String = placemark.country!
        //                let state: String = placemark.administrativeArea!
        //                let city: String = placemark.locality!
        //
        //                print(state)
        //                print(country)
        //                print(city)
        //
        //            }
        //        } )
    }
    

    @IBAction func didTapClearBtn(_ sender: Any) {
        
    }
    
    @IBAction func didTapSaveBtn(_ sender: Any) {
        
    }
    @IBAction func idCardSwitch(_ sender: Any) {
    }
}
