//
//  LoginViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/3/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let image : UIImage = UIImage(contentsOfFile:"Image/Ice_Block_icon.png")!
//        let fileName = "Ice_Block_icon.png"
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + fileName
//        let image : UIImage = UIImage(contentsOfFile: path)!
//
//        logoImageView = UIImageView(image: image)
//
        
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
