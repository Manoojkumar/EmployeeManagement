//
//  EmployeeDetailListTableViewCell.swift
//  EmployeeList
//
//  Created by UITOUX on 12/06/20.
//  Copyright © 2020 KGISL. All rights reserved.
//

import UIKit

class EmployeeDetailListTableViewCell: UITableViewCell {

    @IBOutlet var namelbl: UILabel!
    @IBOutlet var dobLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var streetLbl: UILabel!
    @IBOutlet var pincodeLbl: UILabel!
    @IBOutlet var imageUiView: UIView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var idCardStatusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
