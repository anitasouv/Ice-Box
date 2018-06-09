//
//  ListMainViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/25/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit
import Firebase

class ListMainViewController: UIViewController {

    @IBOutlet weak var createListImageView: UIImageView!
    @IBOutlet weak var viewListsImageList: UIImageView!
   
    var inventory: [Location:[Item]] = [:]
    var UID:String? = nil;
    var userRoot : DatabaseReference?
    let locationStringArray = ["fridge", "cupboard", "freezer", "counter"];

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
                self.inventoryToTupleArray();
                // get all sections and then add the names to the suggestions
        })
    }
    
    func makeItemArrayFromSnapshotArray(snapshot: DataSnapshot) -> [Item] {
        var array: [Item] = [];
        for item in snapshot.children {
            array.append(Item(snapshot: item as! DataSnapshot));
        }
        return array;
    }
    
    func addNewList(newList: GroceryList) {
        let newListRef = self.userRoot?.child("groceryList");
        let ref = newListRef?.child(newList.name);
        for (index, lo) in locationStringArray.enumerated() {
            let refLoc = ref?.child(lo);
            if ( newList.list[Location(rawValue: index)!] != nil) {
                let items = newList.list[Location(rawValue: index)!]!;
                let arrayOfListItems = self.arrayToAny(array: items);
                for (index, temp) in arrayOfListItems.enumerated() {
                    refLoc?.child(items[index].name).setValue(temp);
                }
            }
        }
    }

    
    func loadGroceryListsToFirebase() {
        let newListRef = self.userRoot?.child("groceryList");

        for list in lists {
            let ref = newListRef?.child(list.name);
            for (index, lo) in locationStringArray.enumerated() {
                let refLoc = ref?.child(lo);
                if ( list.list[Location(rawValue: index)!] != nil) {
                    let items = list.list[Location(rawValue: index)!]!;
                    let arrayOfListItems = self.arrayToAny(array: items);
                    for (index, temp) in arrayOfListItems.enumerated() {
                        refLoc?.child(items[index].name).setValue(temp);
                    }
                }
            }
        }
    }
    
    func arrayToAny(array: [ListItem]) -> [Any]{
        var ret = [Any]();
        for item in array {
            ret.append(item.toAnyObject());
        }
        return ret;
    }


    func loadListsFromFirebase() {
        userRoot?.child("groceryList").queryOrdered(byChild: ("/users/" + UID!) ).observe(.value, with:
            {
                snapshot in

                var newGroceryLists: [GroceryList] = []
                var nameOfList: String = "";
                var glist: DataSnapshot;
                for section in snapshot.children {
                    nameOfList = (section as! DataSnapshot).key;
                    
                    print("loading in the list: " + nameOfList);
                    glist = (section as! DataSnapshot);
                    var temp: [Location: [ListItem]] = [:]
                    
                    for (index, _) in self.locationStringArray.enumerated() {
                        let l = Location(rawValue: index)!;
                        print("working on: " + self.locationStringArray[index]);
                        for child in glist.children {
                            let r = child as! DataSnapshot;
                            
                            if (r.key == self.locationStringArray[index]) {
                                temp[l] = self.makeLocationListItemFromSnap(snapshot: r);
                            }
                        }
                        if (temp[l] == nil) {
                            temp[l] = []
                        }
                    }
                    newGroceryLists.append(GroceryList(name: nameOfList, list: temp));
                }
                self.lists = newGroceryLists;

        })
    }

    func makeLocationListItemFromSnap(snapshot: DataSnapshot) -> [ListItem] {
        var array: [ListItem] = [];
        for itemOfList in snapshot.children {
            print("Loading in " + (itemOfList as! DataSnapshot).key);
            array.append(ListItem(snapshot: itemOfList as! DataSnapshot));
        }
        return array;
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = MyColors().backgroundColor;
        
        
        createListImageView.image = nameToImage(subject: "clipboard");
        viewListsImageList.image = nameToImage(subject: "viewList");
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedCreateList(tapGestureRecognizer:)));
        createListImageView.isUserInteractionEnabled = true;
        createListImageView.addGestureRecognizer(tapGestureRecognizer)
        createListImageView.contentMode = UIViewContentMode.scaleAspectFit;
        
        let tapGestureRecognizeView = UITapGestureRecognizer(target: self, action: #selector(imageTappedViewLists(tapGestureRecognizer:)));
        viewListsImageList.isUserInteractionEnabled = true;
        viewListsImageList.addGestureRecognizer(tapGestureRecognizeView);
        viewListsImageList.contentMode = UIViewContentMode.scaleAspectFit;

        
        
        self.UID = Auth.auth().currentUser?.uid;
        // This must precede getting the database reference
        userRoot = Database.database().reference(withPath: "/users/" + UID!);
        loadDataFromFirebase(); // for the inventory in the next page
        loadListsFromFirebase();
        // Do any additional setup after loading the view.
    }
    
    var arrayTuple: [(String, Int, Int, Units)] = []
    func inventoryToTupleArray() {
        for (index, _) in locationStringArray.enumerated()  {
            for item in inventory[Location(rawValue: index)!]! {
//                print("addign " + item.name + " -> " + String(index));
                arrayTuple.append((item.name, index, item.qty, item.units));
            }
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func imageTappedViewLists(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.performSegue(withIdentifier: "viewLists", sender: self);
        // Your action
    }
    
    @objc func imageTappedCreateList(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.performSegue(withIdentifier: "createList", sender: self);
        // Your action
    }
    
    var lists: [GroceryList] = [];
//    var newList: GroceryList? = nil;
    @IBAction func unwindToListMain(segue: UIStoryboardSegue) {
        if (segue.identifier == "createList") {
            let srcVC = segue.source as! GroceryListViewController;
            self.lists.append(srcVC.list!);
            srcVC.list!.printList();
            self.addNewList(newList: srcVC.list!);
        }
        // if from the add all button, refresh everyone's table views and re-pull data
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "createList") {
            let destVC = segue.destination as! GroceryListViewController;
            destVC.currentItems = arrayTuple;
        } else if (segue.identifier == "viewLists") {
            let destVC = segue.destination as! ViewAllListsViewController;
            destVC.lists = lists;
            for i in lists {
                i.printList();
            }
        }
    }
 

}
