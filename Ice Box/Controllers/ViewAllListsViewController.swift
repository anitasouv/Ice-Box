//
//  ViewAllListsViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/28/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit
import Firebase

class ViewAllListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as UITableViewCell;
        cell.textLabel?.text = lists[indexPath.row].name;
        cell.textLabel?.textColor = MyColors().darkTextColor;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath.row % 2) == 0) {
            cell.backgroundColor = MyColors().tableRowLight;
        } else {
            cell.backgroundColor = MyColors().tableRowDark;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSelected", sender: self);
    }
    
    var lists:[GroceryList] = []
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColors().backgroundColor;
        
        self.UID = Auth.auth().currentUser?.uid;
        // This must precede getting the database reference
        userRoot = Database.database().reference(withPath: "/users/" + UID!);
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userRoot : DatabaseReference?
    var UID:String? = nil;
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];
    func updateValues(index: Int, newlist: GroceryList) {
        print("Trying to update");

        let curr = lists[index];
        for (j, loc) in locationStringArray.enumerated() {
            let l = Location(rawValue: j)!;
            print("Location" + loc);

            if (newlist.list[l] != nil) {
                for (i, item) in newlist.list[l]!.enumerated() {
                    print("looking at: " + curr.list[l]![i].name);
                    print(String(curr.list[l]![i].checked) + " != " + String(item.checked));
                    if (curr.list[l]![i].checked != item.checked) {
                        print("Updating");
//                        let ref = self.userRoot?.child("groceryList").child(newlist.name).child(locationStringArray[item.loc.rawValue]).child(item.name);
//                        ref?.updateChildValues(["checked": item.checked]);
                        print("Loading into " + "groceryList" + " -> " + newlist.name + " -> " + locationStringArray[item.loc.rawValue] + " -> " + item.name + " -> checked");
                    }
                }
            }
        }
    }
    
    
    // MARK: - Navigation

    @IBAction func unwindToViewAllLists(segue: UIStoryboardSegue) {
        // check to see if new data, if so update the storage
        if (segue.identifier == "backSave") {
            // check if any new
            let srcVC = segue.source as! ViewOneListViewController;
            let index = listTableView.indexPathForSelectedRow!.row;
            print("src");
            srcVC.main!.printList();
            print("list");
            lists[index].printList();
            updateValues(index: index, newlist: srcVC.main!);
            lists[index] = srcVC.main!;
            // also need to update the database
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showSelected") {
            let destVC = segue.destination as! ViewOneListViewController;
            let index = listTableView.indexPathForSelectedRow!.row;
//            destVC.main = GroceryList(newList: lists[index]);
            destVC.main = lists[index];
            lists[index].printList();
        }
    }
    

}
