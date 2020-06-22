//
//  NewEmployeeViewController.swift
//  EmployeeList
//
//  Created by UITOUX on 12/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit
import SQLite
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftMessages
import NVActivityIndicatorView

class NewEmployeeViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet var superView: UIView!
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
    @IBOutlet var newIDCardLbl: UILabel!
    
    static let loader = ActivityData(size: CGSize(width: 65, height: 50),
                                    message: nil,
                                    messageFont: nil,
                                    type: .ballPulseSync,
                                    color: #colorLiteral(red: 0.886983633, green: 0.3813175857, blue: 0.3260977864, alpha: 1),
                                    padding: nil,
                                    displayTimeThreshold: nil,
                                    minimumDisplayTime: 1,
                                    backgroundColor: .clear,
                                    textColor: nil)
    
    var userName: String = ""
    var email: String = ""
    var streetName: String = ""
    var pincode: String = ""
    var toolBar = UIToolbar()
    let datePicker = UIDatePicker()
    var datePickerContainer = UIView()
    var selectedDate = ""
    var pincodeValidation = false
    var edit = false
    var imageChangeValidation = false
    var switchStatus = false
    var latitude = ""
    var longitude = ""
    var placeName = ""
    var temperature = ""
    var temperatureName = ""
    var database: EmployeeDataBase!
    var geoLocation = ""
    var employeeList: [EmployeeList] = []
    var userID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = EmployeeDataBase()
        self.profileView.layer.cornerRadius = self.profileView.frame.size.height / 2
        self.profileView.clipsToBounds = true
        self.profileView.layer.masksToBounds = true
            
        self.userImage.layer.cornerRadius = self.userImage.frame.size.height / 2
        self.userImage.clipsToBounds = true
        self.userImage.layer.masksToBounds = true

        self.userNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.streetNameTextField.delegate = self
        self.pincodeTextField.delegate = self
        
        let dobTapped = UITapGestureRecognizer(target: self, action: #selector(self.didTapDob(gesture:)))
        self.dobSelectionView.addGestureRecognizer(dobTapped)
        
        let userImageViewTapped = UITapGestureRecognizer(target: self, action: #selector(self.didTapUserImage(gesture:)))
        self.profileView.addGestureRecognizer(userImageViewTapped)
        
        if edit == false{
            self.userNameTextField.text = ""
            self.dobLbl.text = "Select date"
            self.emailTextField.text = ""
            self.streetNameTextField.text = ""
            self.pincodeTextField.text = ""
            self.imageChangeValidation = false
            self.idCardSwitchBtn.isOn = false
            self.pincodeValidation = false
            self.userImage.image = UIImage(named:"user1")
            self.getAllValidation()
        }else{
            for data in employeeList{
               if userID == data.userID{
                   self.userNameTextField.text = data.name
                   self.emailTextField.text = data.email
                   self.dobLbl.text = data.dob
                   self.streetNameTextField.text = data.streetName
                   self.pincodeTextField.text = data.pincode
                   if data.showIdCard == "false"{
                        self.idCardSwitchBtn.isOn = false
                        self.switchStatus = false
                   }else{
                        self.idCardSwitchBtn.isOn = true
                        self.switchStatus = true
                   }
                    let userImage = UIImage(data: data.userImage)
                    self.userImage.image = userImage!
                    self.imageChangeValidation = true
                    self.pincodeValidationFinal(pincode: data.pincode)
                    
               }
           }
        }
    }
    
    func pincodeValidationFinal(pincode: String){
        let location: String = pincode
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if placemarks != nil{
                if ((placemarks?.count)! > 0) {
                    let placemark: CLPlacemark = (placemarks?[0])!
                    let country : String = placemark.country!
                    let state: String = placemark.administrativeArea!
                    let city: String = placemark.locality!
                   
                    self.latitude = String((placemark.location?.coordinate.latitude.debugDescription)!)
                    self.longitude = String((placemark.location?.coordinate.longitude.debugDescription)!)
                    self.pincode = pincode
                    self.pincodeValidation = true
                    self.geoLocation = "\(city),\(state),\(country)"
                    
                }
            }else{
                self.messageView(title: "Alert", body: "Enter an valid pincode.", theme: .warning)
                self.pincodeValidation = false
                self.pincode = ""
                self.geoLocation = ""
            }
        } )
    }
    
    @objc func didTapUserImage(gesture: UITapGestureRecognizer){
        self.openCamera()
    }
    
    @objc func didTapDob(gesture: UITapGestureRecognizer){
        doDatePicker()
        
    }

    func doDatePicker(){
        
         datePicker.datePickerMode = UIDatePicker.Mode.date

         let startDateLbl = "01-01-1940"
         let endDateLbl = "31-12-2004"
             
         let inputDateFormatter = DateFormatter()
         inputDateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
         inputDateFormatter.dateFormat = "dd-MM-yyyy"
         let minDateValue = inputDateFormatter.date(from: startDateLbl)
         let maxDateValue = inputDateFormatter.date(from: endDateLbl)
         datePicker.minimumDate = minDateValue
         datePicker.maximumDate = maxDateValue

         datePickerContainer.frame = CGRect(x: 0.0, y: self.view.frame.height - 250, width: self.view.frame.width, height: 250)
         datePickerContainer.backgroundColor = UIColor.white
         
         toolBar.barStyle = .default
         toolBar.isTranslucent = true
         toolBar.sizeToFit()
         // Adding Button ToolBar
         toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
         let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick(sender:)))
         let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick(sender:)))
         toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
         self.datePickerContainer.addSubview(toolBar)
         
         datePicker.frame = CGRect(x: 0.0, y: 44.0, width: self.view.frame.width, height: 200.0)
        
         datePicker.backgroundColor = UIColor.white
         datePickerContainer.addSubview(datePicker)
         self.view.addSubview(datePickerContainer)
         self.mainView.isUserInteractionEnabled = false
    }
        
    func openCamera(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ? .alert :.actionSheet)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
            actionSheet.popoverPresentationController?.sourceView = self.view
        }
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.cameraDevice = .rear
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL
        self.dismiss(animated: true, completion: nil)
        if info.isEmpty{
            print("")
            if userImage.image == UIImage(named: "user1"){
                self.imageChangeValidation = false
            }else{
                self.imageChangeValidation = true
            }
            self.getAllValidation()
        }else{
            var name = ""
            if imageURL == nil {
                name = "Asset.png"
            }else{
                name = "\(imageURL!.lastPathComponent.lowercased())"
            }
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            self.userImage.image = image
            
            if userImage.image == UIImage(named: "user1"){
                self.imageChangeValidation = false
            }else{
                self.imageChangeValidation = true
            }
            self.getAllValidation()
        }
        
    }

    @objc func doneClick(sender: UIBarButtonItem) {
        datePickerContainer.removeFromSuperview()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.selectedDate = dateFormatter.string(from: datePicker.date)
        self.mainView.isUserInteractionEnabled = true
        self.dobLbl.text = selectedDate
        self.view.endEditing(true)
    }
    
    @objc func cancelClick(sender: UIBarButtonItem) {
        self.mainView.isUserInteractionEnabled = true
        datePickerContainer.removeFromSuperview()
        datePickerContainer.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.returnKeyType = .done
        self.mainView.isUserInteractionEnabled = true
        datePickerContainer.removeFromSuperview()
        if textField == pincodeTextField{
            textField.keyboardType = .numberPad
        }else if textField == emailTextField{
            textField.keyboardType = .emailAddress
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == userNameTextField{
            self.userName = textField.text!
        }else if textField == emailTextField{
            let validEmail =  textField.text!.isValidEmail
            if validEmail == true{
                self.email = textField.text!
            }else{
                self.email = ""
                self.messageView(title: "Alert", body: "Enter an valid email.", theme: .warning)
            }
        }else if textField == streetNameTextField{
            self.streetName = textField.text!
            
        }else if textField == pincodeTextField{
            
            if textField.text!.count > 0{
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(NewEmployeeViewController.loader, nil)
                let location: String = textField.text!
                let geocoder: CLGeocoder = CLGeocoder()
                geocoder.geocodeAddressString(location, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                    if placemarks != nil{
                        if ((placemarks?.count)! > 0) {
                            let placemark: CLPlacemark = (placemarks?[0])!
                            let country : String = placemark.country!
                            let state: String = placemark.administrativeArea!
                            let city: String = placemark.locality!
                           
                            self.latitude = String((placemark.location?.coordinate.latitude.debugDescription)!)
                            self.longitude = String((placemark.location?.coordinate.longitude.debugDescription)!)
                            print(self.longitude)
                            print(self.latitude)
                            self.pincode = textField.text!
                            self.pincodeValidation = true
                            self.geoLocation = "\(city),\(state),\(country)"
                            self.getAllValidation()
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        }
                    }else{
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        self.messageView(title: "Alert", body: "Enter an valid pincode.", theme: .warning)
                        self.pincodeValidation = false
                        self.pincode = ""
                        self.geoLocation = ""
                        self.getAllValidation()
                        
                    }
                } )
            }else{
                self.pincode = ""
                self.geoLocation = ""
                self.pincodeValidation = false
                self.getAllValidation()
                
            }
        }
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pincodeTextField{
            return range.location < 6
        }else{
            return range.location < 150
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func didTapClearBtn(_ sender: Any) {
        self.userNameTextField.text = ""
        self.emailTextField.text = ""
        self.streetNameTextField.text = ""
        self.pincodeTextField.text = ""
        self.idCardSwitchBtn.isOn = false
        self.dobLbl.text = "Select date"
        self.switchStatus = false
        self.userImage.image = UIImage(named: "user1")
        self.imageChangeValidation = false
        self.pincodeValidation = false
    }
    
    func getAllValidation() {
       
        if pincodeValidation == true && imageChangeValidation == true{
            self.newIDCardLbl.alpha = 1
            self.idCardSwitchBtn.isUserInteractionEnabled = true
            if idCardSwitchBtn.isOn == true{
                self.idCardSwitchBtn.isOn = true
                self.switchStatus = true
            }else{
                self.idCardSwitchBtn.isOn = false
                self.switchStatus = false
            }
        }else{
           self.newIDCardLbl.alpha = 0.5
           self.idCardSwitchBtn.isUserInteractionEnabled = false
            self.idCardSwitchBtn.isOn = false
            self.switchStatus = false
        }
    }
    
    @IBAction func didTapSaveBtn(_ sender: Any) {
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(NewEmployeeViewController.loader, nil)
        
        if self.userNameTextField.text != "" && self.dobLbl.text != "Select date" && self.emailTextField.text != "" && self.streetNameTextField.text != "" && self.pincodeTextField.text != "" && self.imageChangeValidation == true {
            if pincodeValidation == true{
                self.database.createTable()
                let barCodeImage = self.generateBarcode(from: self.userNameTextField.text!)
                let userImageString = self.userImage.image!.jpegData(compressionQuality: 0.75)
                let barCodeString = barCodeImage!.jpegData(compressionQuality: 0.75)
                let header:HTTPHeaders = ["Accept" : "application/json",
                                           "Content-Type" : "application/x-www-form-urlencoded"]
                let url = "http://api.openweathermap.org/data/2.5/weather?APPID=e3a1436b582fe4b1e1aa3dbcd4fd332a&lat=\(self.latitude)&lon=\(self.longitude)&units=metric"
                let alamofire = SecurityCertificateManager.sharedInstance.defaultManager
                alamofire.request(url, method: .get, headers: header).responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        let responseData = response.data!
                        let json = JSON(responseData)
                        let placeName = json["name"].debugDescription
                        let weather = json["main"]["temp"].debugDescription
                        let weathers = json["weather"][0]
                        let weatherName = weathers["main"].debugDescription
                       
                        self.temperature = "\(weather)c - "
                        if weatherName == "Clouds"{
                            self.temperatureName = "Cloudy"
                        }else{
                            self.temperatureName = weatherName
                        }
                        
                        self.geoLocation = "\(placeName),\(self.geoLocation)"
                        
                        
                        if self.edit == false{
                            let getTable = self.database.getTable()
                           
                            var userID = 0
                            if getTable.count == 0{
                                userID = 1
                            }else{
                                let userData = getTable.last!
                                userID = userData.userID + 1
                            }
                           
                            let insertRow = self.database.insertTable(name: self.userNameTextField.text!, userId: userID, email: self.emailTextField.text!, dob: self.dobLbl.text!, streetName: self.streetNameTextField.text!, pincode: self.pincodeTextField.text!, userImage: userImageString!, barcode: barCodeString!,geoLocation:self.geoLocation, weather: "\(self.temperature)\(self.temperatureName)", showIdCard: "\(self.switchStatus)")
                            if insertRow == true{
                                self.messageAlertView(title: "Success", body: "Employee Added Successfully", theme: .success, showButton: true, action: {_ in
                                    self.navigationController?.popViewController(animated: true)
                                    SwiftMessages.hide()
                                })
                            }else{
                                self.messageView(title: "Alert", body: "Something wrong with database..", theme: .warning)
                            }
                            
                        }else{
                            
                            let filteredIndex = self.employeeList.enumerated().filter({ $0.element.userID == self.userID}).map({$0.offset})
                            let employeeData = self.employeeList[filteredIndex.first!]
                            employeeData.name = self.userNameTextField.text!
                            employeeData.email = self.emailTextField.text!
                            employeeData.dob = self.dobLbl.text!
                            employeeData.streetName = self.streetNameTextField.text!
                            employeeData.pincode = self.pincodeTextField.text!
                            employeeData.geoLocation = self.geoLocation
                            employeeData.userImage = userImageString!
                            employeeData.barCode = barCodeString!
                            employeeData.weather = "\(self.temperature)\(self.temperatureName)"
                            employeeData.showIdCard = "\(self.switchStatus)"
                            
                            
                            //self.database.updateUser(employee: employeeData)
                            
                            let updatedStatus = self.database.updateUser(employee: employeeData)
                            
                            if updatedStatus == true{
                                self.messageAlertView(title: "Success", body: "Employee Updated Successfully", theme: .success, showButton: true, action: {_ in
                                    self.navigationController?.popViewController(animated: true)
                                    SwiftMessages.hide()
                                })
                            }else{
                                self.messageView(title: "Alert", body: "something went wrong.", theme: .warning)
                            }
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                            
                        }
                    case .failure(let error):
                        print(error)
                        self.messageAlertView(title: "Alert", body: "\(error.localizedDescription)", theme: .warning, showButton: false,action: nil)

                        }
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    }

            }else{
                self.messageView(title: "Alert", body: "Enter an valid pincode.", theme: .warning)
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        }else if self.userNameTextField.text == ""{
            self.messageView(title: "Alert", body: "Enter employee name.", theme: .warning)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }else if self.dobLbl.text == "Select date"{
            self.messageView(title: "Alert", body: "Select an date of birth.", theme: .warning)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
        }else if self.emailTextField.text == ""{
            self.messageView(title: "Alert", body: "Enter employeee email.", theme: .warning)
           
           NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }else if self.streetNameTextField.text == "" {
            self.messageView(title: "Alert", body: "Enter employee street name.", theme: .warning)
            
          NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }else if self.pincodeTextField.text == ""{
            self.messageView(title: "Alert", body: "Enter employee pincode.", theme: .warning)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
        }else if self.imageChangeValidation == false{
            self.messageView(title: "Alert", body: "Please take an picture of an employee.", theme: .warning)
            
           NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
        
    }
    
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
    
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    @IBAction func idCardSwitch(_ sender: Any) {
        if idCardSwitchBtn.isOn == true{
            self.switchStatus = true
        }else{
            self.switchStatus = false
        }
    }
}


extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
   
    
    var isValidEmail: Bool {
           NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
       }
}

public extension UIViewController{
    func messageView(title: String,body: String,theme: Theme){

           let messageView: MessageView
           messageView = MessageView.viewFromNib(layout: .cardView)
           messageView.titleLabel?.isHidden = true
           messageView.button?.isHidden = true
           messageView.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "    Ok    ", buttonTapHandler: { _ in SwiftMessages.hide() })
           messageView.configureTheme(theme)
           messageView.backgroundView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.3803921569, blue: 0.3254901961, alpha: 1)
           messageView.configureDropShadow()

           var config = SwiftMessages.defaultConfig
           config.presentationStyle = .bottom
           config.duration = .seconds(seconds: 1)
           config.interactiveHide = true
           config.shouldAutorotate = false
           config.dimMode = .color(color: .clear, interactive: true)
           SwiftMessages.show(config: config, view: messageView)

       }
       
       func messageAlertView(title: String,body: String,theme: Theme,showButton:Bool,action: ((UIButton) -> Void)? = nil){

           let messageView: MessageView
           messageView = MessageView.viewFromNib(layout: .cardView)
           messageView.titleLabel?.isHidden = false
           messageView.button?.isHidden = false
           if showButton == false{
               messageView.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "    Ok    ", buttonTapHandler: { _ in SwiftMessages.hide() })
               messageView.configureTheme(theme)
           }else{
               messageView.configureContent(title: title, body: body, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "    Ok    ", buttonTapHandler: action)
               messageView.configureTheme(theme)
           }
           
           messageView.backgroundView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.3803921569, blue: 0.3254901961, alpha: 1)
           messageView.configureDropShadow()
           
           var config = SwiftMessages.defaultConfig
           config.presentationStyle = .center
           config.duration = .forever
           config.interactiveHide = false
           config.shouldAutorotate = false
           config.dimMode = .color(color: .clear, interactive: false)
           
           SwiftMessages.show(config: config, view: messageView)
       }
}
