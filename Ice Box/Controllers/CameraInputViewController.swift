//
//  CameraInputViewController.swift
//  Ice Box
//
//  Created by Anita Souv on 5/13/18.
//  Copyright © 2018 Anita Souv. All rights reserved.
//

import UIKit

class CameraInputViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = Bundle.main.resourcePath! + "/Images/" + "underConstructionSign" ;
        imgView.image = UIImage(named: path);
        self.view.backgroundColor = MyColors().backgroundColor;
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
