//
//  AddingItemViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/13/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class AddingItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate {
    @IBOutlet var viewLong: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addingBtn: UIButton!
    
    @IBOutlet weak var itemImg: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var expDatePicker: UIDatePicker!
    @IBOutlet weak var dateAddedPicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
 
    var ogName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColors().backgroundColor;
        viewLong.backgroundColor = MyColors().backgroundColor;
        let path = Bundle.main.resourcePath! + "/Images/" + "camera" ;
        itemImg.image = UIImage(named: path);
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false;
        viewLong.addGestureRecognizer(tap);
        viewLong.isUserInteractionEnabled = true

        self.locationPicker.delegate = self;
        self.locationPicker.dataSource = self;
        
        self.unitPicker.delegate = self;
        self.unitPicker.dataSource = self;
        
        self.nameTextField.delegate = self;
        self.qtyTextField.delegate = self;
        
        self.notesTextView.delegate = self;
        
        self.nameTextField.text = ogName;
        
        self.reset();
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    let unitsArray = ["none", "carton(s)", "dozen(s)", "bushel(s)", "gallon(s)", "count", "pound(s)"]
    
    @IBAction func resetInput(_ sender: Any) {
        reset();
    }
    
    func reset() {
        self.nameTextField.text = self.ogName;
        self.qtyTextField.text = "0"
        self.locationPicker.selectRow(0, inComponent: 0, animated: true);
        self.unitPicker.selectRow(0, inComponent: 0, animated: true);
        self.expDatePicker.date = Date();
        self.dateAddedPicker.date = Date();
        self.notesTextView.text = ""
    }
    
    // Picker things:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == unitPicker) {
            return unitsArray.count;
        } else if (pickerView == locationPicker) {
            return locationStringArray.count;
        }
        return 0;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == unitPicker) {
            let first = String(unitsArray[row].prefix(1)).capitalized
            let other = String(unitsArray[row].dropFirst())
            return first + other;
        } else if (pickerView == locationPicker) {
            let first = String(locationStringArray[row].prefix(1)).capitalized
            let other = String(locationStringArray[row].dropFirst())
            return first + other;
        }
        return "?";
    }
    

    // textview funcs
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.notesTextView.resignFirstResponder();
        return true
    }
    
    // textField funcs
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if nameTextField.isFirstResponder {
            nameTextField.resignFirstResponder();
        } else if (qtyTextField.isFirstResponder ) {
            qtyTextField.resignFirstResponder();
        } else if (notesTextView.isFirstResponder) {
            notesTextView.resignFirstResponder();
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

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cancelAddItem") {
            print("Canceling from adding item");
            let destVC = segue.destination as! ManualInputViewController;
            destVC.itemToAdd = nil;
            // TODO create a nil an dsend that (this will tell the the other page that )
        } else if (segue.identifier == "completeAddItem") {
            // TODO add in the check of the qty?
            // TODO create the item here and pass it over
            print("Add the created item");
            let destVC = segue.destination as! ManualInputViewController;
            
            
            let name = self.nameTextField.text;
            let qty = Int(self.qtyTextField.text!);
            if (qty != nil) {
                // TODO ^ check if zero or negative
                print("Must check quantity");
            } else{
                // invalid number
                print("invalid number!");
            }
            
            let unitRow = self.unitPicker.selectedRow(inComponent: 0);
            var unit = unitsArray[unitRow];
            if (unit == "none") { unit = "" }
            let u = Units(rawValue: unit)!;
            
            let locationRow = self.locationPicker.selectedRow(inComponent: 0);
            let location = Location(rawValue: locationRow)!;
            print("Item location: " + String(locationRow) + " whcih is: " + locationStringArray[locationRow]);
            
            let expDate = expDatePicker.date;
            let dateAdded = dateAddedPicker.date;
            
            let notes = notesTextView.text;
            
            var item = Item(name: name!, qty: qty!, dateAdded: dateAdded, expirationDate: expDate, notes: notes, locationOfItem: location, units: u);
            
            destVC.itemToAdd = item;
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
