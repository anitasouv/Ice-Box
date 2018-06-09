//
//  Item.swift
//  Ice Box
//
//  Created by Anita Souv on 3/2/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Item {
    var name: String;
    var qty: Int;
    var units: Units;
    
    var dateAdded: Date;
    var expirationDate: Date;
    var img: String; // img or image link?
    
    var notes: String?;
    var locationOfItem: Location;
    
    var qtyToRemove: Int?;
    
    // another constructor or function to add in the image of item
    
    init(name: String, qty: Int, dateAdded: Date, expirationDate: Date, notes: String?, locationOfItem: Location, units: Units) {
        
        self.name = name;
        self.qty = qty;
        self.units = units;
        self.dateAdded = dateAdded;
        self.expirationDate = expirationDate;
        // get img by looking locally and looking at the name
        
        self.img = name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression).lowercased(); // img or image link?
        
        self.notes = notes;
        self.locationOfItem = locationOfItem;
        
        self.qtyToRemove = 0;
    }
    
    //    let dateFormatter = DateFormatter();
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//
//    dateAddedLbl.text = "Date Added: " + dateFormatter.string(from: (item?.dateAdded)!);
//
    
    init(snapshot: DataSnapshot) {
        
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let snapvalues = snapshot.value as! [String : AnyObject]
        self.name = snapvalues["name"] as! String;
        self.qty = snapvalues["qty"] as! Int;
        self.units = Units(rawValue: (snapvalues["units"] as! String))!;
        self.dateAdded = dateFormatter.date(from: snapvalues["dateAdded"] as! String)!;
        self.expirationDate = dateFormatter.date(from: snapvalues["expirationDate"] as! String)!;
        
        // get img by looking locally and looking at the name
        self.img = (snapvalues["img"] as! String).trimmingCharacters(in: .whitespaces).lowercased(); // img or image link?
        
        self.notes = snapvalues["notes"] as? String;
        self.locationOfItem = Location(rawValue: snapvalues["locationOfItem"] as! Int)!;
        self.qtyToRemove = (snapvalues["qtyToRemove"] as? Int);
    }
    
    func toAnyObject() -> Any {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return [
            "name" : name,
            "qty" : qty,
            "units" : units.rawValue,
            "dateAdded": dateFormatter.string(from: (dateAdded)),
            "expirationDate": dateFormatter.string(from: (expirationDate)),
            "img": img.trimmingCharacters(in: .whitespaces).lowercased(),
            "notes": notes ?? "",
            "locationOfItem": locationOfItem.rawValue,
            "qtyToRemove": qtyToRemove
        ]
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
