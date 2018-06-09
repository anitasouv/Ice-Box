//
//  EditItemManualInputViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/26/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class EditItemManualInputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MyColors().backgroundColor;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "saveEditManualInput") {
            print("Save the edit of the item in manual Input")
        } else if (segue.identifier == "cancelEditManualInput") {
            print("Cancel edit of the item in manual Input");
        }
    }
    

}
