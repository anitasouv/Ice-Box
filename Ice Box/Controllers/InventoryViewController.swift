//
//  InventoryViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/2/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit
import Firebase


class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inventroyTableView: UITableView!
    var inventory: [Location:[Item]] = [:]

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory[Location(rawValue: section)!]?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row % 2) == 0) {
            cell.backgroundColor = MyColors().tableRowLight;
        } else {
            cell.backgroundColor = MyColors().tableRowDark;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var temp:Item? = nil;
        temp = inventory[Location(rawValue: indexPath.section)!]?[indexPath.row]
 
        let cell = inventroyTableView.dequeueReusableCell(withIdentifier: "itemCell") as! ItemTableViewCell;
        
        cell.nameLbl.text = temp?.name.capitalized;
        cell.nameLbl.font = UIFont.boldSystemFont(ofSize: 20.0);

        cell.qtyLbl.text = "QTY: " + String((temp?.qty)!) + " " + (temp?.units.rawValue)!
        
        cell.imgView.image = nameToImage(subject: (temp?.img)!);
        cell.imgView.layer.cornerRadius = 10;
        cell.imgView.contentMode = .scaleAspectFit;
//        cell.imgView.backgroundColor = MyColors().tableRowDark;
        
        cell.cellView.layer.cornerRadius = 10;
        cell.cellView.layer.masksToBounds = true;
        
        cell.nameLbl.textColor = MyColors().darkTextColor;
        cell.qtyLbl.textColor = MyColors().darkTextColor;
        
        let path = Bundle.main.resourcePath! + "/Icons/" + "next" + ".png";
        cell.detailsImgView.image = UIImage(named: path);
        cell.detailsImgView.contentMode = .scaleAspectFit;

        return cell;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView();
        view.backgroundColor = MyColors().testColor;

        let icon = UIImageView();
        let path = Bundle.main.resourcePath! + "/Icons/" + locationStringArray[section] + "-light" + ".png";
        icon.image = UIImage(named: path);
        icon.frame = CGRect(x: 5, y: 5, width: 35, height: 35);

        view.addSubview(icon);

        let label = UILabel();
        label.text = locationStringArray[section].capitalized;
        label.textColor = MyColors().lightTextColor;
        label.font = UIFont.boldSystemFont(ofSize: 14.0);
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35);
        view.addSubview(label);
        
        return view;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45;
    }
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationStringArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationStringArray[section].capitalized;
    }
    
    func nameToImage(subject: String) -> UIImage {
        let extentions = [".png", ".jpg", ".jpeg"];
        var i = 0;
        var path = Bundle.main.resourcePath! + "/Images/" + subject;
        var img = UIImage(named: path);
        while ((img == nil) && i < extentions.count) {
            path = Bundle.main.resourcePath! + "/Images/" + subject + extentions[i];
            i = i + 1;
            img = UIImage(named: path);
        }
        var temp = "";
        i = 0;
        while ((img == nil) && i < extentions.count) {
            if (subject.last! == "s") {
                temp = String(subject.prefix(upTo: subject.index(before: subject.endIndex)));
            } else {
                temp = subject + "s"
            }
            path = Bundle.main.resourcePath! + "/Images/" + temp + extentions[i];
            i = i + 1;
            img = UIImage(named: path);
        }
        if ((img == nil)) {
            path  = Bundle.main.resourcePath! + "/Images/" + "couldNotFind"
            img = UIImage(named: path);
        }
        return img!;
    }
    
    var userRoot : DatabaseReference?

//    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    
    func loadDataToFirebase() {
        // for each key -> add an array of toAnyObject()
        
        let locationsTotal = [Location.fridge, Location.cupboard, Location.freezer, Location.counter];
        
        for lo in locationsTotal {
            print ("Loading in " + locationStringArray[lo.rawValue]);
            
            let newListRef = self.userRoot?.child("inventory").child( self.locationStringArray[lo.rawValue]);
            if ((self.inventory[lo]) != nil) {
                let arrayOfItems = arrayToAnyObject(arrayOfItems: self.inventory[lo]!);
                for (index, item) in arrayOfItems.enumerated() {
                    newListRef?.child(self.inventory[lo]![index].name).setValue(item);
                }
            }
        }
    }
    
    func arrayToAnyObject(arrayOfItems: [Item]) -> [Any] {
        var listOfStuff = [Any]();
        for item in arrayOfItems {
            print ("Adding: " + item.name)
            listOfStuff.append(item.toAnyObject());
        }
        return listOfStuff;
    }
    
    

    

    var UID:String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.UID = Auth.auth().currentUser?.uid;
        
        // This must precede getting the database reference
        Database.database().isPersistenceEnabled = true
        userRoot = Database.database().reference(withPath: "/users/" + UID!);
        
        loadDataFromFirebase();
//        loadDataToFirebase();
        print("Loading in inventory VC");
        self.view.backgroundColor = MyColors().backgroundColor;
        self.inventroyTableView.backgroundColor = MyColors().backgroundColor;
//        self.inventroyTableView.headerView(forSection: 0)?.backgroundView?.backgroundColor = MyColors().extraColor
        // Do any additional setup after loading the view.
    }
    @IBAction func startReupload(_ sender: Any) {
        loadDataToFirebase();
    }
    
    func loadDataFromFirebase() {
        userRoot?.child("inventory").queryOrdered(byChild: ("/users/" + UID!) ).observe(.value, with:
        {
            snapshot in
            var newInventory: [Location:[Item]] = [:]
            
            var keyOfInventory = 0;
            var arrayOfSection = [Item]();
            for section in snapshot.children {
                keyOfInventory = self.locationStringArray.index(of: (section as! DataSnapshot).key)!
                arrayOfSection = self.makeItemArrayFromSnapshotArray(snapshot: section as! DataSnapshot);
                newInventory[Location(rawValue: keyOfInventory)!] = arrayOfSection;
            }
            
            self.inventory = newInventory;
            self.inventroyTableView.reloadData();
        })
    }
    
    func makeItemArrayFromSnapshotArray(snapshot: DataSnapshot) -> [Item] {
        var array: [Item] = [];
        
        for item in snapshot.children {
            array.append(Item(snapshot: item as! DataSnapshot));
        }
        
        return array;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToInventory(segue: UIStoryboardSegue) {
        if (segue.identifier == "backToInventroy") {
            // insert this item back in and
            let srcVC = segue.source as! DetailViewController;
            let selectedIndexPath = inventroyTableView.indexPathForSelectedRow;
            self.inventory[Location(rawValue: (selectedIndexPath?.section)!)!]?[selectedIndexPath!.row].notes = srcVC.item?.notes;
            
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "itemDetails", let destVC = segue.destination as? DetailViewController {
            let selectedIndexPath = inventroyTableView.indexPathForSelectedRow;
            let item = self.inventory[Location(rawValue: (selectedIndexPath?.section)!)!]?[selectedIndexPath!.row];
            let location = item?.locationOfItem.rawValue
            let locationString = locationStringArray[location!].capitalized;
            destVC.item = item
            destVC.locationString = locationString;
        }
    }


}
