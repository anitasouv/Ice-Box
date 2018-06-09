//
//  ProfileViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/2/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var houseNameLabel: UIView!
    @IBOutlet weak var numberOfListsLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var profileFrame: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loading in Profile VC");
        
        profilePictureImageView.image = nameToImage(subject: "Ice_Block_icon");
//        profilePictureImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor;
//        profilePictureImageView.layer.cornerRadius = (profilePictureImageView.frame.size.height)/2 ;
//        profilePictureImageView.layer.masksToBounds = true;
//        profilePictureImageView.safeAreaInsets =
        profilePictureImageView.contentMode = .scaleAspectFill;
//        profilePictureImageView.layer.borderWidth = 2 // as you wish

        profileFrame.layer.cornerRadius = profileFrame.frame.size.height / 2;
        
        self.view.backgroundColor = MyColors().backgroundColor;
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
