//
//  GroceryListViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/25/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class GroceryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 0) {
            return unitArray.count;
        } else {
            return locationStringArray.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 0) {
            return unitArray[row];
        } else {
            return locationStringArray[row];
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var list = groceryList;
        
        if (tableView == groceryListTableView) {
            list = groceryList;
        } else {
            list = pastItems + currentItems;
        }
        
        var counts = [0, 0, 0, 0];
        for i in list {
            counts[i.1] = counts[i.1] + 1;
        }
        return counts[section];
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locationStringArray.count;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationStringArray[section].capitalized;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // remove from which ever list and add to grocery list
        // maybe an alert to ask how many of that item
        // reload the tables if nessary
        if (tableView == pastItemsTableView) {
            var temp = pastItems.filter{ $0.1 == indexPath.section };
            if (temp.count <= indexPath.row) {
                temp = temp + currentItems.filter{ $0.1 == indexPath.section };
            }
            showAddingAlert(name: temp[indexPath.row].0, lo: temp[indexPath.row].1);
        }
    }
    @IBAction func addItem(_ sender: Any) {
        let name = manualTextField.text;
        if (name == "") {
            noTextAlert();
        } else {
            showAddingAlert(name: name!, lo: -1);
        }
    }
    
    func showConfirmingMessage(item: String){
        let alert = UIAlertController(title: "Success!", message: "Succefully added " + item.capitalized + " to grocery list", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func noTextAlert() {
        let alert = UIAlertController(title: "Error", message: "Must enter the name of an item to add to list", preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func didNotEnterQuantity() {
        let alert = UIAlertController(title: "Error", message: "Must enter the quantity to add an item", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showAddingAlert(name: String, lo: Int) {
        var loc = lo;
        let alert = UIAlertController(title: "Enter Quantity and Unit", message: "for " + name.capitalized + "\n\n\n", preferredStyle: UIAlertControllerStyle.alert)
        
        let label = UILabel(frame: CGRect(x: 25, y: 60, width: 200, height: 70));
        label.text = "Units:";
        alert.view.addSubview(label);
        
        let pickerView = UIPickerView(frame: CGRect(x: 35, y: 60, width: 200, height: 70));
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.tag = 0;
        alert.view.addSubview(pickerView);

        
        let locationPickerView = UIPickerView(frame: CGRect(x: 35, y: 140, width: 200, height: 70));
        locationPickerView.delegate = self;
        locationPickerView.dataSource = self;
        
        if (loc == -1) {
            pickerView.frame = CGRect(x: 35, y: 75, width: 200, height: 70);
            label.frame = CGRect(x: 25, y: 75, width: 200, height: 70)
            alert.title = "Enter Quantity, Unit, and Location";
            alert.message = "for " + name.capitalized + "\n\n\n\n\n\n\n";
            let label1 = UILabel(frame: CGRect(x: 15, y: 140, width: 200, height: 70));
            label1.text = "Location:";
            alert.view.addSubview(label1);
            

            locationPickerView.tag = 1;

            alert.view.addSubview(locationPickerView);
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler:
            { (action:UIAlertAction) in
                guard let textField =  alert.textFields?.first else {
                    return
                }
                if (loc == -1) {
                    loc = locationPickerView.selectedRow(inComponent: 0);
                }
                if (textField.text! != "") {
                    self.addToGroceryList(name: name, loc: loc,  qty: textField.text!, unit: self.unitArray[pickerView.selectedRow(inComponent: 0)]);
                } else {
                    self.didNotEnterQuantity();
                }
                
            }
        ));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Quantity"
            textField.keyboardType = UIKeyboardType.numberPad;
        }
        self.present(alert, animated: true)
    }
    
    let unitArray = ["none", "carton(s)", "dozen(s)", "bushel(s)", "gallon(s)", "count", "pound(s)"];
    
    func addToGroceryList(name: String, loc: Int, qty: String, unit: String) {
        var temp = unit;
        print("Adding item " + name + " -> " + qty + " " + unit);
        if (temp == "none") { temp = "" }
        groceryList.append((name, loc, Int(qty)!, Units(rawValue: temp)!));
        groceryListTableView.reloadData();
        showConfirmingMessage(item: name);
    }
    
    @IBOutlet weak var manualTextField: UITextField!
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    
    typealias itemPlaceQty = (String, Int, Int, Units);
    var groceryList:[itemPlaceQty] = [("eggs", 0, 1, Units(rawValue: "dozen(s)")!),
                       ("chicken", 2, 2, Units(rawValue:"pound(s)")!),
                       ("apple", 0, 3, Units(rawValue: "count")!) ];
    
    var pastItems:[itemPlaceQty] = [("blueberries", 3, 0,  Units(rawValue:"pound(s)")!),
                     ("asparagus", 3, 0, Units(rawValue: "bushel(s)")!),
                     ("bread", 1, 0, Units(rawValue: "")!),
                     ("chips", 1, 0,  Units(rawValue: "")!)];
    var currentItems: [itemPlaceQty] = []
    
    @IBOutlet weak var pastItemsTableView: UITableView!
    @IBOutlet weak var groceryListTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var temp: [itemPlaceQty] = [];
        var id = "";
        if (tableView == groceryListTableView) {
            temp = groceryList.filter{ $0.1 == indexPath.section };
            id = "groceryListItem"
        } else {
            temp = pastItems.filter{ $0.1 == indexPath.section };
            id = "pastItem";
            if (temp.count <= indexPath.row) {
                temp = temp + currentItems.filter{ $0.1 == indexPath.section };
            }
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? AddingItemTableViewCell;
        
        cell?.nameLbl?.text = temp[indexPath.row].0.capitalized;
        cell?.imgView?.image = nameToImage(subject: temp[indexPath.row].0.replacingOccurrences(of: "\\s", with: "", options: .regularExpression).lowercased());
        
        if (temp[indexPath.row].2 != 0) {
            let unit = temp[indexPath.row].3.rawValue;
            cell?.qtyLbl?.text = "QTY: " + String(temp[indexPath.row].2) + " " + unit;
            cell?.nameLbl?.textColor = MyColors().darkTextColor;
            cell?.qtyLbl?.textColor = MyColors().darkTextColor;
        } else {
            cell?.qtyLbl?.text = "";

            cell?.nameLbl?.textColor = MyColors().darkTextColorGray;
            cell?.qtyLbl?.textColor = MyColors().darkTextColorGray;
        }
        
        if (id == "groceryListItem") {
            cell?.qtyLbl?.text = "QTY: " + String(temp[indexPath.row].2) + " " + temp[indexPath.row].3.rawValue;
            cell?.nameLbl?.textColor = MyColors().darkTextColor;
            cell?.qtyLbl?.textColor = MyColors().darkTextColor;
        }
        
        cell?.imgView.layer.cornerRadius = 10;
        cell?.imgView.contentMode = .scaleAspectFit;
        
        cell?.nameLbl.font = UIFont.boldSystemFont(ofSize: 20.0);
        return cell!;
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


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColors().backgroundColor;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// Textfield things
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if manualTextField.isFirstResponder {
            manualTextField.resignFirstResponder()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder();
    }
    
    // TODO: maybe intiate the button action?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    // MARK: - Navigation
    @IBAction func createList(_ sender: Any) {
        getNameOfList();
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
  
    func getNameOfList() {
        let alert = UIAlertController(title: "Enter Name of List", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name";
            textField.text = "<default>";
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
            { (action:UIAlertAction) in
                guard let textField =  alert.textFields?.first else {
                    return
                }
                self.nameOfList = textField.text!;
                self.performSegue(withIdentifier: "createList", sender: self);
            }
        
        ));
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        self.present(alert, animated: true, completion: nil);
    }
    
    var nameOfList: String = "";
    var finalList: [Location: [ListItem]] = [:];
    var list: GroceryList? = nil;
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "createList") {
            var temp:[itemPlaceQty];
            for (index, _) in locationStringArray.enumerated() {
                finalList[Location(rawValue: index)!] = [];
                temp = groceryList.filter{ $0.1 == index };
                for j in temp {
                    finalList[Location(rawValue: index)!]!.append(ListItem(item: j));
                }
            }
            list = GroceryList(name: nameOfList,list: finalList);
        } else if (segue.identifier == "cancel") {
            print("Canceling creating list");
        }
    }
    

}
