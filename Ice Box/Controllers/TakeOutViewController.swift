//
//  TakeOutViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/11/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit
import Firebase


class TakeOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    // suggestion table -> when entering the word, search through the inventory and populate this source with only the names in the table
    // big table-> the user
    
    
    // put a check on the number they attempt to remove (both: over the number they have and negative numbers)
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    var UID:String? = nil;
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var suggestionsTableView: UITableView!
    @IBOutlet weak var inventoryTableView: UITableView!
    var inventory: [Location:[Item]] = [:]
    
    var suggestions: [Location: [String]] = [:]
    var userRoot : DatabaseReference?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == inventoryTableView) {
            return locationStringArray.count
        } else {
            var i = 0;
            var sect = 0;
            for _ in locationStringArray {
                if ((suggestions[Location(rawValue: i)!]!.count) > 0) {
                    sect = sect + 1;
                }
                
                i = i + 1;
            }
            return sect;
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == inventoryTableView) {
            return inventory[Location(rawValue: section)!]?.count ?? 0;
        } else {
            var i = 0;
            for _ in locationStringArray {
                if (suggestions[Location.init(rawValue: i)!]!.count > 0) {
                    break;
                }
                i = i + 1;
            }
            return suggestions[Location(rawValue: i + section)!]?.count ?? 0;
//            return suggestions[Location(rawValue: section)!]?.count ?? 0;
        }
    }
    

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return locationStringArray[section].capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == inventoryTableView) {
            var temp:Item? = nil;
            temp = inventory[Location(rawValue: indexPath.section)!]?[indexPath.row]
            
            let cell = inventoryTableView.dequeueReusableCell(withIdentifier: "itemToTakeOut") as! RemoveItemTableViewCell;
            
            cell.nameLbl.text = temp?.name.capitalized;
            cell.qtyLbl.text = "QTY: " + String((temp?.qty)!) + " " + (temp?.units.rawValue)!
            
            // image setting TODO: only png are shown, if add ".jpg" or ".jpeg" then it will be okay
            var path = Bundle.main.resourcePath! + "/Images/" + (temp?.img)! ;
            cell.imgView.image = nameToImage(subject: (temp?.img)!);
            cell.imgView.layer.cornerRadius = 10;
            cell.imgView.contentMode = .scaleAspectFit;
            
            cell.nameLbl.font = UIFont.boldSystemFont(ofSize: 20.0);
            cell.qtyLbl.text = "QTY: " + String((temp?.qty)!) + " " + (temp?.units.rawValue)!
            
            cell.nameLbl.textColor = MyColors().darkTextColor;
            cell.qtyLbl.textColor = MyColors().darkTextColor;
            
            
            cell.qtyTextField.delegate = cell;
            
            return cell;
        } else {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "suggestion") as! SuggestionTableViewCell;
            var temp2:String? = nil;
            
            var i = 0; //numberOfPreviousBlankSections
            // pad section index by the numebr of previous blank suggestions
            for index in 0...indexPath.section {
                if (suggestions[Location.init(rawValue: i)!]!.count > 0) {
                    break;
                }
                i = i + 1;
            }
            printSuggestions();
            temp2 = suggestions[Location(rawValue: indexPath.section)!]?[indexPath.row];
            cell.itemLabel.text = temp2;
            
            return cell;
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected!");
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
        printSuggestions();
        
        if (tableView == inventoryTableView) {
            print("Editing the item");
            // lesson: use dequeueReusableCell or the cell will be resused, which is annoying
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemToTakeOut", for: indexPath) as! RemoveItemTableViewCell;
            print("edit this item " + cell.nameLbl.text!);
            cell.qtyTextField.becomeFirstResponder();
            // start the editor for that item to input the qty

        } else {
            // auto fill? or select the cell that matches the name and start editing
            // let cell = tableView.cellForRow(at: indexPath)as! SuggestionTableViewCell;
            let cell = tableView.dequeueReusableCell(withIdentifier: "suggestion", for: indexPath) as! SuggestionTableViewCell;
            
            print(cell.itemLabel.text);
            searchBarTextField.text = cell.itemLabel.text;
            searchBarTextField.resignFirstResponder();
        }
    }





// Functions that do things to the Database
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
                self.inventoryTableView.reloadData();
                
                //self.loadItemsToSuggestions()
                // get all sections and then add the names to the suggestions
        })
    }

    func updateQtyInDatabase(loc: Location, remove: Item, newQty: Int) {
        let ref = self.userRoot?.child("inventory").child(locationStringArray[loc.rawValue]).child(remove.name);
        ref?.updateChildValues(["qty": newQty]);
    }
    
    func removeFromDatabase(loc: Location, remove: Item) {
        let ref = self.userRoot?.child("inventory").child(locationStringArray[loc.rawValue]).child(remove.name);
        ref?.removeValue { error, _ in print(error) };
    }

    func makeItemArrayFromSnapshotArray(snapshot: DataSnapshot) -> [Item] {
        var array: [Item] = [];
        
        for item in snapshot.children {
            array.append(Item(snapshot: item as! DataSnapshot));
        }
        
        return array;
    }



    @IBAction func removeItems(_ sender: Any) {
        //ask to confirm to get rid of the items
        // once confirmed
            // gather all of the items into a list with the corresponding section
            // use below code to remove each item OR edit the qty of an item
            //
        
//        var cell:ItemTableViewCell?;
        var cell:RemoveItemTableViewCell?;
        for section in 0...(inventoryTableView.numberOfSections-1) {
            for row in 0...(inventoryTableView.numberOfRows(inSection: section)) {
                cell = inventoryTableView.cellForRow(at: IndexPath(row:row, section:section)) as? RemoveItemTableViewCell
                let removeQty = Int( (cell?.qtyTextField.text) ?? "0")!;
                
                if (removeQty != 0) {
                    let name = (cell?.nameLbl.text)!;
                    let (loca, itemToRemove) = searchForItem(itemToFind: name.lowercased());
                    let itemQty = (itemToRemove?.qty)!;
                    
                    if (removeQty < itemQty) {// this means that there are less number to remove than there are (just update the value in database)
                        updateQtyInDatabase(loc: loca!, remove: itemToRemove!, newQty: (itemToRemove?.qty)! - removeQty);
                    } else if (removeQty == itemQty) { // sam enumber, just remove the whole item
                        removeFromDatabase(loc: loca!, remove: itemToRemove!);
                    } else {
                        // error! should never get here once the error checking is implemented
                    }
                }
            }
        }
        
        // TODO reset display
        // re get the data?
        clearQty(self);
        inventoryTableView.reloadData();
        resetSuggestions();
        showConfirmingMessage();
        //loadItemsToSuggestions();
        
    }
    

    
    @IBAction func editTheItemInSearch(_ sender: Any) {
        // error if cannot find the item in the search bar
        // else go to the item in the table view and start the editor
        print("here in editItemInsearch");
        inventoryTableView.reloadData();
        searchBarTextField.resignFirstResponder();
        let (loc, item) = searchForItem(itemToFind: searchBarTextField.text!);
        if (loc != nil) {

            let indexPath = getIndexPathFromItem(loc: loc!, item: item!);
            
            self.tableView( inventoryTableView, didSelectRowAt: indexPath);
        }

    }
    
    func getIndexPathFromItem(loc: Location, item: Item) -> IndexPath {
        var section = -1;
        for (index, location) in self.inventory.enumerated() {
            if (location.key == loc) {
                section = index;
            }
        }
        let list = self.inventory[loc];
        
        for (index, itemFromList) in list!.enumerated() {
            if (itemFromList.name == item.name) {
                print("Row: " + String(index) + " section: " + String(section));
                return IndexPath(row: index, section: section);
            }
        }
        return IndexPath(row: 0, section: 0);
    }
    
    func printInventory() {
        for (loc, list) in self.inventory {
            for item in list {
                print("inventory: " + item.name);
            }
        }
    }

    func printSuggestions() {
        print("Suggestions");
        for (loc, list) in self.suggestions {
            for item in list {
                print("suggested: " + item);
            }
            print( locationStringArray[loc.rawValue] + ": " + String(list.count));
        }
    }
    
    func searchForItem(itemToFind: String) -> (Location?, Item?) {
        for (loc, list) in self.inventory {
            for item in list {
                if (item.name == itemToFind) {
                    print ("Found the item: " + itemToFind);
                    return (loc, item);
                }
            }
        }
        print("could not find: " + itemToFind);
        return (nil, nil);
    }
    
    // TODO add a pop up that tells user that everything is now clear
    // TODO ask to confirm before clearing?
    
    @IBAction func clearQty(_ sender: Any) {
        var cell:RemoveItemTableViewCell?;
        for section in 0...(inventoryTableView.numberOfSections-1) {
            for row in 0...(inventoryTableView.numberOfRows(inSection: section)) {
                cell = inventoryTableView.cellForRow(at: IndexPath(row:row, section:section)) as? RemoveItemTableViewCell;
                cell?.qtyTextField.text = "0";
            }
        }
    }
    

// Setthing up page   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.inventoryTableView.delegate = self
        self.inventoryTableView.dataSource = self
        self.suggestionsTableView.delegate = self
        self.suggestionsTableView.dataSource = self
        
        print("Loading in Take Out VC");
        suggestionsTableView.isHidden = true;
        
        self.UID = Auth.auth().currentUser?.uid;
        // This must precede getting the database reference
        userRoot = Database.database().reference(withPath: "/users/" + UID!);
        
        //        loadDataToFirebase();
        loadDataFromFirebase();
        resetSuggestions();

        searchBarTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        self.view.backgroundColor = MyColors().backgroundColor;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




// influnce on the suggestions array
    func resetSuggestions() {
        var index = 0;
        for _ in locationStringArray {
            suggestions[Location(rawValue: index)!] = [];
            index = index + 1;
        }
    }

    func loadItemsToSuggestions() {
        for (loc,list) in self.inventory {
            for item in list {
                suggestions[loc]?.append(item.name);
            }
        }
    }


    
// Textfield things
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchBarTextField.isFirstResponder {
            searchBarTextField.resignFirstResponder()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let input = textField.text;
        if ((input?.count)! > 2) {
            print("Searching..");
            filterSuggestionsWithWord(word: input!);
            printSuggestions();
            suggestionsTableView.reloadData();
        }
    }
    
    // helper function
    func filterSuggestionsWithWord(word: String) {
        for (loc,list) in self.inventory {
            suggestions[loc] = [];
            for item in list {
                print("Looking at: " + item.name);
                if( item.name.contains(word) ) {
                    print("Adding " + item.name + "based on: " + word);
                    suggestions[loc]?.append(item.name);
                }
            }
        }
    }
    
    @IBAction func textFieldChanged(_ sender: AnyObject) {
        //searchTableView.isHidden = false
        print("changing");
        let input = (sender as! UITextField).text;
        filterSuggestionsWithWord(word: input!);
        printSuggestions();
//        suggestionsTableView.reloadData();
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let input = textField.text;
        filterSuggestionsWithWord(word: input!);
        
        suggestionsTableView.isHidden = false;
        suggestionsTableView.reloadData();
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: Your app can do something when textField finishes editing
//        print("The textField ended editing. Do something based on app requirements.")
        

        let input = textField.text;
        filterSuggestionsWithWord(word: input!);
        textField.resignFirstResponder();
        suggestionsTableView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        suggestionsTableView.isHidden = true
        return true
    }
    
    
    func showConfirmingMessage(){
        let alert = UIAlertController(title: "Success!", message: "Succefully added Items!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
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
