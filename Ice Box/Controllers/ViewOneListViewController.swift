//
//  ViewOneListViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/28/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit
import Firebase

class ViewOneListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (main != nil) {
            return main!.list[Location(rawValue: section)!]!.count;
        } else {
            return 1;
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (main != nil) {
            return main!.list.count;
        } else {
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (main?.list[Location(rawValue: indexPath.section)!]![indexPath.row].checked)! {
            main?.list[Location(rawValue: indexPath.section)!]![indexPath.row].checked = false;
            let ref = self.userRoot?.child("groceryList").child((main?.name)!).child(locationStringArray[indexPath.section]).child((main?.list[Location(rawValue: indexPath.section)!]![indexPath.row].name)!);
            ref?.updateChildValues(["checked": false ]);
            
            tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath).accessoryType = .none;
        } else {
            main?.list[Location(rawValue: indexPath.section)!]![indexPath.row].checked = true;
            let ref = self.userRoot?.child("groceryList").child((main?.name)!).child(locationStringArray[indexPath.section]).child((main?.list[Location(rawValue: indexPath.section)!]![indexPath.row].name)!);
            ref?.updateChildValues(["checked": true ]);

            tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath).accessoryType = .checkmark;
        }
        main?.printList();
        tableView.reloadData();
    }
    
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return locationStringArray[section].capitalized;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (main != nil) {
            let temp: [ListItem] = main!.list[Location(rawValue: indexPath.section)!]!;
            let item = temp[indexPath.row];
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as? AddingItemTableViewCell;
            
            cell?.nameLbl?.text = item.name;
            cell?.imgView?.image = nameToImage(subject: item.name.replacingOccurrences(of: "\\s", with: "", options: .regularExpression).lowercased());
            
            cell?.qtyLbl?.text = "QTY: " + String(item.qty) + " " + item.unit.rawValue;
            
            if (item.checked) {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            
            cell?.imgView.layer.cornerRadius = 10;
            cell?.imgView.contentMode = .scaleAspectFit;
            
            cell?.nameLbl?.font = UIFont.boldSystemFont(ofSize: 20.0);
            cell?.nameLbl?.textColor = MyColors().darkTextColor;
            cell?.qtyLbl?.textColor = MyColors().darkTextColor;
            
            
            return cell!;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as? AddingItemTableViewCell;
            
            cell?.nameLbl?.text = "What";

            return cell!;
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row % 2) == 0) {
            cell.backgroundColor = MyColors().tableRowLight;
        } else {
            cell.backgroundColor = MyColors().tableRowDark;
        }
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
    
    var main: GroceryList? = nil;
    @IBOutlet weak var nameLabel: UILabel!
    var userRoot : DatabaseReference?
    var UID:String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColors().backgroundColor;
        if (main != nil) {
            nameLabel.text = "Viewing list: " + main!.name;
        }
        
        self.UID = Auth.auth().currentUser?.uid;
        // This must precede getting the database reference
        userRoot = Database.database().reference(withPath: "/users/" + UID!);
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backBtn(_ sender: Any) {
        // show alert warning, and ask if they want to save changes
        performSegue(withIdentifier: "backNoSave", sender: self)
    }
    @IBAction func saveBtn(_ sender: Any) {
        // save changes and go back
        // maybe alert that you saved the changes
        performSegue(withIdentifier: "backSave", sender: self)

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    

}
