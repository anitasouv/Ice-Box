//
//  ManualInputViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/13/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit
import Firebase


class ManualInputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    
    var itemToAdd:Item?

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addAllBtn: UIButton!
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var itemTableView: UITableView!
    var addingList:[Location: [Item]] = [:]
    
    var UID:String? = nil;
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = MyColors().backgroundColor;
        searchBarTextField.delegate = self;
        itemTableView.delegate = self;
        itemTableView.dataSource = self;
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.cancelsTouchesInView = false;
        tap.delegate = self
        self.view.addGestureRecognizer(tap);
        self.view.isUserInteractionEnabled = true
        
      
        self.UID = Auth.auth().currentUser?.uid;
        userRoot = Database.database().reference(withPath: "/users/" + UID!);
        
        for loc in locationArray {
            addingList[loc] = [];
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// textfield functions
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if searchBarTextField.isFirstResponder {
            searchBarTextField.resignFirstResponder();
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textField finishes editing
        textField.resignFirstResponder();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    let locationArray = [Location.fridge, Location.cupboard, Location.freezer, Location.counter];
    
// table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationArray.count;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (addingList[locationArray[section]]!.count > 0) {
            return locationStringArray[section].capitalized;
        }
        return nil;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addingList[locationArray[section]]!.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAdding") as! AddingItemTableViewCell!
        let name = addingList[locationArray[indexPath.section]]![indexPath.row].name;
        cell?.nameLbl.text = name.capitalized;
        print("adding an item!");
        
        cell?.qtyLbl.text = "QTY: " + String(addingList[locationArray[indexPath.section]]![indexPath.row].qty) + addingList[locationArray[indexPath.section]]![indexPath.row].units.rawValue;
        // TODO enter image
        cell?.imgView.image = nameToImage(subject: name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression).lowercased());
        
        cell?.imgView.layer.cornerRadius = 10;
        cell?.imgView.contentMode = .scaleAspectFit;
        
        cell?.nameLbl.font = UIFont.boldSystemFont(ofSize: 20.0);
        
        cell?.nameLbl.textColor = MyColors().darkTextColor;
        cell?.qtyLbl.textColor = MyColors().darkTextColor;
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editItemInManualInput", sender: self);
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row % 2) == 0) {
            cell.backgroundColor = MyColors().tableRowLight;
        } else {
            cell.backgroundColor = MyColors().tableRowDark;
        }
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
    
    // MARK: - Navigation
    
    @IBAction func unwindToManualAdding(segue: UIStoryboardSegue) {
        
        // TODO if from add, then make sure to add the item to the list/table and refresh the table view
        if (itemToAdd != nil) {
            // add to the array that feeds the table view
            (addingList[(itemToAdd?.locationOfItem)!])!.append(itemToAdd!);
            itemToAdd = nil;
            // refresh the table view
            itemTableView.reloadData();
        }
    }
    
    @IBAction func addItemFromSearchBar(_ sender: Any) {
        
        // TODO add in the passing and check of the name in the textfield
        print("adding the item! Segue");
        self.performSegue(withIdentifier: "addItem", sender: sender);
    }
    
    
    var userRoot : DatabaseReference?
    func addListToDatabase() {
        for (indexLoc, loc) in locationStringArray.enumerated() {
            let newListRef = self.userRoot?.child("inventory").child(loc);
            if ((self.addingList[locationArray[indexLoc]]) != nil) {
                let arrayOfItems = arrayToAnyObject(arrayOfItems: self.addingList[locationArray[indexLoc]]!);
                for (index, item) in arrayOfItems.enumerated() {
                    newListRef?.child(self.addingList[locationArray[indexLoc]]![index].name).setValue(item);
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
    
    
    // In a storyboard-based application, you will often want to do a littl8e preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "cancelAddAllItems") {
            print("Canceling");
        } else if (segue.identifier == "completeAddAllItems") {
            // TODO add in the check of the qty? (this might be done before actually adding in the item to the table/list)
            // TODO add all the items into the database
            print("Add all items");
            
            // check if u are over writing another item?
            addListToDatabase();
            
        } else if (segue.identifier == "addItem") {
            let tempVC = segue.destination as! AddingItemViewController;
            tempVC.ogName = searchBarTextField.text;
        } else if (segue.identifier == "editItemInManualInput") {
            print("Editing this item!");
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
