//
//  Item.swift
//  Ice Box
//
//  Created by Anita Souv on 3/2/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import Foundation

class Item {
    var name: String;
    var qty: Int;
    var units: Units;
    
    var dateAdded: Date;
    var expirationDate: Date;
    var img: String; // img or image link?
    
    var notes: String?;
    var locationOfItem: Location;
    
    init(name: String, qty: Int, dateAdded: Date, expirationDate: Date, notes: String?, locationOfItem: Location, units: Units) {
        

        self.name = name;
        self.qty = qty;
        self.units = units;
        self.dateAdded = dateAdded;
        self.expirationDate = expirationDate;
        // get img by looking locally and looking at the name
        self.img = name ; // img or image link?
        
        self.notes = notes;
        self.locationOfItem = locationOfItem;
    }
}

enum Location: Int {
    case fridge = 0;
    case cupboard = 1;
    case freezer = 2;
    case counter = 3;
}



enum Units: Int {
    case none = 0;
    case cartons = 1;
    case dozens = 2;
    case bushels = 3;
    case gallons = 4;
    case count = 5;
    case pounds = 6;
    
    
}

//let none = TestEnum(rawValue: "Name")!       //Name
//let gender = TestEnum(rawValue: "Gender")!   //Gender
//let birth = TestEnum(rawValue: "Birth Day")! //Birth

