//
//  DetailViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/3/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

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
            
            imgView.image = nameToImage(subject: (item?.img)!);
            
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            dateAddedLbl.text = "Date Added: " + dateFormatter.string(from: (item?.dateAdded)!);
            expDateLbl.text = "Exp Date: " + dateFormatter.string(from: (item?.expirationDate)!);
            
            notesTextView.text = item?.notes;
        }
        
        self.view.backgroundColor = MyColors().backgroundColor;
        // Do any additional setup after loading the view.
    }

    @IBAction func saveNotes(_ sender: Any) {
        item?.notes = notesTextView.text;
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if notesTextView.isFirstResponder {
            notesTextView.resignFirstResponder();
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder();
        return true;
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder();
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
