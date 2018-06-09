//
//  MySegCtrl.swift
//  Ice Box
//
//  Created by Anita Souv on 6/5/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class MySegCtrl: UISegmentedControl {

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
//        self.layer.cornerRadius = 10;
        //self.backgroundColor = MyColors().featureColor;
//        let titleTextAttributes = [NSAttributedStringKey.foregroundColor: MyColors().backgroundColor];
//        self.setTitleTextAttributes(titleTextAttributes, for: .normal);
//        let selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor: MyColors().darkTextColor];
//        self.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected);

//        self.setTitleColor(MyColors().backgroundColor, for: .normal);
    }

}
