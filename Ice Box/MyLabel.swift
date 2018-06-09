//
//  MyLabel.swift
//  Ice Box
//
//  Created by Anita Souv on 6/8/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class MyLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.textColor = MyColors().lightTextColor;
        self.font = UIFont.boldSystemFont(ofSize: 20.0);
        self.font = UIFont (name: "Euphemia UCAS", size: 20);
    }

}
