//
//  LoginViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 3/3/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var googleSignInBtn: UIButton!
    @IBOutlet weak var loginSign: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginSign.textColor = MyColors().superDarkText;
//        var path = Bundle.main.resourcePath! + "/Images/background.jpg" ;
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: path)!);

        
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//        backgroundImage.image = UIImage(named: path);
//        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
//        self.view.insertSubview(backgroundImage, at: 0)
        
        self.navigationController?.isNavigationBarHidden = true;
        self.view.backgroundColor = MyColors().backgroundColor;
        
        // Do any additional setup after loading the view.

        
        let path = Bundle.main.resourcePath! + "/Images/Ice_Block_icon.png" ;
        logoImageView.image = UIImage(named: path);
        logoImageView.contentMode = .scaleAspectFit;
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        
        //add google sign in button
            //        let googleButton = GIDSignInButton()
            //        googleButton.frame = CGRect(x: 16, y: 116 + 66 + 66 + 66 + 66 + 66 + 30, width: view.frame.width - 32, height: 50)
            //        view.addSubview(googleButton)

        googleSignInBtn.frame = CGRect(x: 16, y: 116 + 66 + 66 + 66 + 66 + 66 + 30, width: view.frame.width - 32, height: 50);
//        let pathToIcon = Bundle.main.resourcePath! + "/Images/" + "googleIcon.png" ;
//        cell.imgView.image = UIImage(named: path)
//        googleSignInBtn.setImage(UIImage(named: pathToIcon), for: .normal)
        
//        googleSignIn.backgroundColor = UIColor.white;
        
        /* check for user's token */
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            /* Code to show your tab bar controller */
            print("logged in")
//            googleButton.text = "You are signed in!";
            googleSignInBtn.setTitle("You are Logged in!", for: .normal);
//            googleSignIn.backgroundColor = UIColor.red
        } else {
            /* code to show your login VC */
            print("not Logged in")
            googleSignInBtn.setTitle("Sign In", for: .normal);
//            googleSignIn.backgroundColor = UIColor.white
        }
        
    }

    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            /* Code to show your tab bar controller */
            print("logged in")
            //            googleButton.text = "You are signed in!";
            googleSignInBtn.setTitle("You are Logged in!", for: .normal);
        } else {
            /* code to show your login VC */
            print("not Logged in")
            googleSignInBtn.setTitle("Sign In", for: .normal);
        }
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
