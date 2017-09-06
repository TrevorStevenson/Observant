//
//  StoreViewController.swift
//  Observant
//
//  Created by Trevor Stevenson on 12/1/14.
//  Copyright (c) 2014 ncunited. All rights reserved.
//

import UIKit
import iAd

class StoreViewController: UIViewController, ADBannerViewDelegate {
    
    var isPresentedModally = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
    }

    @IBAction func back(_ sender: AnyObject)
    {
        if (isPresentedModally)
        {
            self.dismiss(animated: true, completion: nil)
            self.isPresentedModally = false
        }
        else
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
