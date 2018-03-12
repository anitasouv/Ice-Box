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
    var inventory: [Location:[Item]] = [:]

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory[Location(rawValue: section)!]?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var temp:Item? = nil;
        temp = inventory[Location(rawValue: indexPath.section)!]?[indexPath.row]
 
        let cell = inventroyTableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell;
        
        cell.nameLbl.text = temp?.name.capitalized;
        cell.qtyLbl.text = "QTY: " + String((temp?.qty)!) + " " + (temp?.units.rawValue)!
//        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        
        // image setting TODO: only png are shown, if add ".jpg" or ".jpeg" then it will be okay
        let path = Bundle.main.resourcePath! + "/Images/" + (temp?.img)! ;
        cell.imgView.image = UIImage(named: path)
        
        return cell;
    }
    
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationStringArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationStringArray[section].capitalized;
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToInventory(segue: UIStoryboardSegue) {
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "itemDetails", let destVC = segue.destination as? DetailViewController {
//            destVC.item
            let selectedIndexPath = inventroyTableView.indexPathForSelectedRow;
            let item = self.inventory[Location(rawValue: (selectedIndexPath?.section)!)!]?[selectedIndexPath!.row];
            let location = item?.locationOfItem.rawValue
            let locationString = locationStringArray[location!].capitalized;
            destVC.item = item
            destVC.locationString = locationString;
//                locationStringArray[(self.inventory[Location(rawValue: (selectedIndexPath?.section)!)!]?[selectedIndexPath!.row].locationOfItem.rawValue)!].capitalized;
            
            
            // want the location string -> locationStringArray -> need the item location from the chosen
            
//            locationStringArray[selectedIndexPath!.section].capitalized;
        }
    }


}
