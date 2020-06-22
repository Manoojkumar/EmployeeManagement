//
//  CornerRadiusView.swift
//  EmployeeList
//
//  Created by UITOUX on 12/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CornerRadius: UIView{
    
    @IBInspectable var cornerRadius: CGFloat = 5.0
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }

}
