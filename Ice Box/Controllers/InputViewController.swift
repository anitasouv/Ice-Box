//
//  InputViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/13/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var manualImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.performSegue(withIdentifier: "toManualInput", sender: self);
        // Your action
    }
    
    @objc func imageTappedCamera(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.performSegue(withIdentifier: "toCameraInput", sender: self);
        // Your action
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

        manualImageView.image = nameToImage(subject: "manual");
        cameraImageView.image = nameToImage(subject: "camera");
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        manualImageView.isUserInteractionEnabled = true
        manualImageView.addGestureRecognizer(tapGestureRecognizer)
        manualImageView.contentMode = UIViewContentMode.scaleAspectFit;

        
        let tapGestureRecognizerCamera = UITapGestureRecognizer(target: self, action: #selector(imageTappedCamera(tapGestureRecognizer:)))
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(tapGestureRecognizerCamera);
        cameraImageView.contentMode = UIViewContentMode.scaleAspectFit;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

     @IBAction func unwindToInputMain(segue: UIStoryboardSegue) {
        
        // if from the add all button, refresh everyone's table views and re-pull data
     }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
