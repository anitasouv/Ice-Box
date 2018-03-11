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

enum Units: String {
    case none = "";
    case cartons = "carton(s)";
    case dozens = "dozen(s)";
    case bushels = "bushel(s)";
    case gallons = "gallon(s)";
    case count = "count";
    case pounds = "pound(s)";
}
