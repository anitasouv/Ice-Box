//
//  ListItem.swift
//  Ice Box
//
//  Created by Anita Souv on 5/28/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import Foundation
import FirebaseDatabase


class ListItem {
    
    var name: String;
    var loc: Location;
    var qty: Int;
    var unit: Units;
    var checked: Bool;
    
    init( name: String,
          loc: Location,
          qty: Int,
          unit: Units,
          checked: Bool) {
        
        self.name = name;
        self.loc = loc;
        self.qty = qty;
        self.unit = unit;
        self.checked = checked;

    }
    
    init( newItem: ListItem) {
        
        self.name = newItem.name;
        self.loc = newItem.loc;
        self.qty = newItem.qty;
        self.unit = newItem.unit;
        self.checked = newItem.checked;
        
    }
    
    init (item: (String, Int, Int, Units)) {
        self.name = item.0;
        self.loc = Location(rawValue: item.1)!;
        self.qty = item.2;
        self.unit = item.3;
        self.checked = false;
    }
    
    init(snapshot: DataSnapshot) {
        let snapvalues = snapshot.value as! [String : AnyObject]
        self.name = snapvalues["name"] as! String;
        self.loc = Location(rawValue: snapvalues["loc"] as! Int)!;
        self.qty = snapvalues["qty"] as! Int;
        self.unit = Units(rawValue: (snapvalues["unit"] as! String))!;
        self.checked = snapvalues["checked"] as! Bool;
    }
    
    func printItem() {
        let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];

        print("Name: " + name);
        print("loc: " + locationStringArray[loc.rawValue]);
        print("qty: " + String(qty));
        print("unit: " + unit.rawValue);
        print("checked: " + String(checked));
    }
    
    func toAnyObject() -> Any {
        return [
            "name" : name,
            "loc" : loc.rawValue,
            "qty" : qty,
            "unit" : unit.rawValue,
            "checked" : checked
        ]
    }
}

