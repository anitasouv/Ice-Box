//
//  GroceryList.swift
//  Ice Box
//
//  Created by Anita Souv on 5/28/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import Foundation
import FirebaseDatabase


class GroceryList {
    var name: String;
    var list: [Location:[ListItem]];
 
    // another constructor or function to add in the image of item
    
    init(name: String, list: [Location:[ListItem]]) {
        self.name = name;
        self.list = list;
    }
    
    init(newList: GroceryList) {
        self.name = newList.name;
        self.list = [:];
        let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];

        for (index, _ ) in locationStringArray.enumerated() {
            self.list[Location(rawValue: index)!] = [];
            if (newList.list[Location(rawValue: index)!] != nil) {
                for item in newList.list[Location(rawValue: index)!]! {
                    self.list[Location(rawValue: index)!]?.append(ListItem(newItem: item));
                }
            }

        }
    }
    
    init(snapshot: DataSnapshot) {
        let snapvalues = snapshot.value as! [String : AnyObject]
        self.name = snapvalues["name"] as! String;
        self.list = snapvalues["list"] as! [Location:[ListItem]];
    }

    func printList() {
        let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];

        print("Name: " + name);
        for (index, l) in locationStringArray.enumerated() {
            let cur = list[Location(rawValue: index)!];
            print("in " + l);
            if (cur != nil) {
                for item in cur! {
                    item.printItem();
                }
            }
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "name" : name,
            "list" : list
        ]
    }
}

