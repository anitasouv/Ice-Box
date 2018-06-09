//
//  RemoveItemTableViewCell.swift
//  Ice Box
//
//  Created by Anita Souv on 6/6/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class RemoveItemTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib();

        var path = Bundle.main.resourcePath! + "/Icons/" + "minus" + ".png";
        minusBtn.setImage(UIImage(named: path), for: .normal);
        minusBtn.setTitle("", for: .normal);
        minusBtn.tintColor = MyColors().darkTextColor;
        minusBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        minusBtn.imageView?.contentMode = .scaleAspectFit
        
        path = Bundle.main.resourcePath! + "/Icons/" + "plus" + ".png";
        plusBtn.setImage(UIImage(named: path), for: .normal);
        plusBtn.setTitle("", for: .normal);
        plusBtn.imageView?.contentMode = .scaleAspectFit
        plusBtn.tintColor = MyColors().darkTextColor;
        plusBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);

        qtyTextField.textColor = MyColors().darkTextColor;

        // Initialization code
    }
    //NEED TO CHANGE THE UPDATEING BC NO THERE IS A INVENTORY KEY

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func decreaseQty(_ sender: Any) {
        var num = Int(qtyTextField.text!)!;
        if(num > 0) {
           num = num - 1;
        }
        qtyTextField.text = String(num);
    }
    
    @IBAction func increaseQty(_ sender: Any) {
        let num = Int(qtyTextField.text!)!;
        // TODO check for the limit of the numebr of items
        let limit = Int(String(qtyLbl.text!.characters.filter { "0"..."9" ~= $0 }))!;
        if (num < limit) {
            qtyTextField.text = String(num + 1);
        }
    }
    
}
