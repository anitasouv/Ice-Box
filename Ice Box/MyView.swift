//
//  MyView.swift
//  Ice Box
//
//  Created by Anita Souv on 6/8/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class MyView: UIView {

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
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        layer.mask = maskLayer;
    }
}
