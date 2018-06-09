//
//  AddingItemTableViewCell.swift
//  Ice Box
//
//  Created by Anita Souv on 5/13/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class AddingItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
