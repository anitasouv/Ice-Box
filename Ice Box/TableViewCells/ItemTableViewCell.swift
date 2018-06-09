//
//  ItemTableViewCell.swift
//  Ice Box
//
//  Created by Anita Souv on 3/3/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell, UITextFieldDelegate {

//    @IBOutlet weak var qtyTextfield: UITextField!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var detailsImgView: UIImageView!
    
    @IBOutlet weak var cellView: UIView!
    //    var item: Item?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("inside the cell!");
        textField.resignFirstResponder();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("inside the cell");
        textField.resignFirstResponder();
        return true;
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if qtyTextfield.isFirstResponder {
//            qtyTextfield.resignFirstResponder()
//        }
//    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
