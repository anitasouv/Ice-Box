//
//  InventoryViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/2/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inventroyTableView: UITableView!
//    var inventory: [Item] = []
    var inventoryFridge: [Item] = []
    var inventoryCupboard: [Item] = []
    var inventoryFreezer: [Item] = []
    var inventoryCounter: [Item] = []
    
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    let unitStringArray = ["", "carton(s)", "dozen(s)", "bushel(s)", "gallon(s)", "count", "pound(s)"];
    let locationValueArray = [Location.fridge, Location.cupboard, Location.freezer, Location.counter];
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch locationValueArray[section] {
            case Location.fridge:
                return inventoryFridge.count
            case Location.cupboard:
                return inventoryCupboard.count
            case Location.freezer:
                return inventoryFreezer.count
            case Location.counter:
                return inventoryCounter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var temp:Item? = nil;
        
        switch locationValueArray[indexPath.section] {
            case .fridge:
                temp = inventoryFridge[indexPath.row]
            case .cupboard:
                temp = inventoryCupboard[indexPath.row]
            case .freezer:
                temp = inventoryFreezer[indexPath.row]
            case .counter:
                temp = inventoryCounter[indexPath.row]
        }
        
        let cell = inventroyTableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell;
        
        cell.nameLbl.text = temp?.name.capitalized;
        cell.qtyLbl.text = "QTY: " + String((temp?.qty)!) + " " + unitStringArray[(temp?.units.rawValue)!]
        
//        var image : UIImage = UIImage(named:"afternoon")!
//        bgImage = UIImageView(image: image)
        let path = Bundle.main.resourcePath! + "/Images/" + (temp?.img)! ;
//        let fileManager = FileManager.default
        
        cell.imgView.image = UIImage(named: path)
        print(path);
        
        return cell;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationStringArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationStringArray[section].capitalized;
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let path = Bundle.main.resourcePath! + "/Images";
//        let fileManager = FileManager.default
//        var a:NSArray = [];
//        do {
//            a = try fileManager.contentsOfDirectory(atPath: path) as NSArray
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        var counter = 0;
//        for i in a {
//            print((i as AnyObject).object(at: counter) as! String)
//            counter = counter + 1;
//        }
        
        // load the data to inventory
        loadFakeInventory();
    }

    
    let names = ["milk", "eggs", "chicken", "beef", "cereal", "spinach", "lettuce", "onion", "cheese"]
    let qty = [1, 2, 2, 2, 1, 1, 1, 3, 4];
    let dateAdded = Date(); // its just current date
    let notes = ["full", "small eggs", "frozen", "fresh ground beef", "coco puffs", "not much left", "a whole head of lettuse", "white onions", "roma tomatoes"];
    let locations = [Location.fridge, Location.fridge, Location.freezer, Location.fridge, Location.cupboard, Location.fridge,Location.fridge,Location.fridge,Location.fridge, Location.freezer];
    let units = [Units.gallons, Units.dozens, Units.pounds, Units.pounds, Units.count, Units.bushels,  Units.count, Units.count, Units.count];
    
    func loadFakeInventory() {
        let expirationDate = Date(timeInterval: 2*86400, since: dateAdded);
        var i = 0;
        for name in names {
            switch locations[i] {
                case .fridge:
                    inventoryFridge.append(Item(name: name, qty: qty[i], dateAdded: dateAdded, expirationDate: expirationDate, notes: notes[i], locationOfItem: locations[i], units: units[i]));
                case .cupboard:
                    inventoryCupboard.append(Item(name: name, qty: qty[i], dateAdded: dateAdded, expirationDate: expirationDate, notes: notes[i], locationOfItem: locations[i], units: units[i]));
                case .freezer:
                    inventoryFreezer.append(Item(name: name, qty: qty[i], dateAdded: dateAdded, expirationDate: expirationDate, notes: notes[i], locationOfItem: locations[i], units: units[i]));
                case .counter:
                    inventoryCounter.append(Item(name: name, qty: qty[i], dateAdded: dateAdded, expirationDate: expirationDate, notes: notes[i], locationOfItem: locations[i], units: units[i]));
            }
            
            i = i + 1;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindToInventory(segue: UIStoryboardSegue) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
