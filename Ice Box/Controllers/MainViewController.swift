//
//  MainViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 2/26/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var inventoryView: UIView!
    @IBOutlet weak var inputItemsView: UIView!
    @IBOutlet weak var takeOutItemsView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var groceryListView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.alpha = 0
        inventoryView.alpha = 1
        inputItemsView.alpha = 0
        takeOutItemsView.alpha = 0
        profileView.alpha = 0
        groceryListView.alpha = 0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showComponent(_ sender: UISegmentedControl) {
        
        loadingView.alpha = 1
        inventoryView.alpha = 0
        inputItemsView.alpha = 0
        takeOutItemsView.alpha = 0
        profileView.alpha = 0
        groceryListView.alpha = 0
        
        if (sender.selectedSegmentIndex == 0 ) {
            UIView.animate(withDuration: 0.5, animations: {
                self.inventoryView.alpha = 1
                self.loadingView.alpha = 0
            })
        } else if (sender.selectedSegmentIndex == 1) {
            UIView.animate(withDuration: 0.5, animations: {
                self.inputItemsView.alpha = 1
                self.loadingView.alpha = 0
            })
        } else if (sender.selectedSegmentIndex == 2) {
            UIView.animate(withDuration: 0.5, animations: {
                self.takeOutItemsView.alpha = 1
                self.loadingView.alpha = 0
            })
        } else if (sender.selectedSegmentIndex == 3) {
            UIView.animate(withDuration: 0.5, animations: {
                self.profileView.alpha = 1
                self.loadingView.alpha = 0
            })
        } else if (sender.selectedSegmentIndex == 4) {
            UIView.animate(withDuration: 0.5, animations: {
                self.groceryListView.alpha = 1
                self.loadingView.alpha = 0
            })
        }
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
