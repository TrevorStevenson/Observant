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
    var shouldShowAds: Bool = true
    
    @IBOutlet weak var adBanner: ADBannerView!

    override func viewWillAppear(_ animated: Bool) {
        
        if (UserDefaults.standard.bool(forKey: "showAds") == false)
        {
            adBanner.removeFromSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        
   
        UIView.beginAnimations(nil, context: nil)
    
        UIView.setAnimationDuration(1.0)
    
        banner.alpha = 1.0
    
        UIView.commitAnimations()
  
        
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        

        UIView.beginAnimations(nil, context: nil)
    
        UIView.setAnimationDuration(1.0)
    
        banner.alpha = 0.0
    
        UIView.commitAnimations()
            
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

    @IBAction func removeAds(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("removeAds", block: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        } as! (Error?) -> Void)
    }
    
    @IBAction func buy10Hints(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("hints10", block: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        } as! (Error?) -> Void)
        
    }
    
    @IBAction func buy50hints(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("hints50", block: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        } as! (Error?) -> Void)

    }
    
    @IBAction func buy100Hints(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("hints100", block: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        } as! (Error?) -> Void)

    }
    @IBAction func buy20Fifty(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("fifty20", block: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        } as! (Error?) -> Void)

    }
    
    @IBAction func buy50Fifty(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("fifty50", block: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        } as! (Error?) -> Void)
    }
    
    @IBAction func buy100Fifty(_ sender: AnyObject)
    {
        PFPurchase.buyProduct("fifty100", block: { (error:NSError?) -> Void in
            
            if (error != nil)
            {
                let alert = UIAlertView(title: "Error", message: "There was an error in the transaction. Please try again.", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        } as! (Error?) -> Void)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
