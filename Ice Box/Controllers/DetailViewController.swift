//
//  DetailViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/3/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var item: Item? = nil
    var locationString: String? = "";
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var dateAddedLbl: UILabel!
    @IBOutlet weak var expDateLbl: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if item != nil {
            locationLbl.text = "Location: " + locationString!
            nameLbl.text = "Item: " + item!.name.capitalized;
            qtyLbl.text = "QTY: " + String((item?.qty)!) + " " + (item?.units.rawValue)!;
            
            // image setting TODO: only png are shown, if add ".jpg" or ".jpeg" then it will be okay
            let path = Bundle.main.resourcePath! + "/Images/" + (item?.img)! ;
            imgView.image = UIImage(named: path);
            
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            dateAddedLbl.text = "Date Added: " + dateFormatter.string(from: (item?.dateAdded)!);
            expDateLbl.text = "Exp Date: " + dateFormatter.string(from: (item?.expirationDate)!);
            
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = formatType.rawValue // Your New Date format as per requirement change it own
            
//            let newDate: String = dateFormatter.string(from: date) // pass Date here
//            print(newDate) // New formatted Date string

        }
        
        

        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

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
