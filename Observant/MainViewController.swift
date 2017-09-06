//
//  MainViewController.swift
//  Observant
//
//  Created by Trevor Stevenson on 9/28/14.
//  Copyright (c) 2014 ncunited. All rights reserved.
//

import UIKit
import GameKit

class MainViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate, UIAlertViewDelegate {
    
    var gameCenterEnabled: Bool = false
    var leaderBoardIdentifier: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        authenticateLocalPlayer()
    }
    
    func authenticateLocalPlayer()
    {
        let localPlayer = GKLocalPlayer()
        
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: NSError?) in
            
            if (viewController != nil)
            {
                self.present(viewController!, animated: true, completion: nil)
            }
            else
            {
                if (GKLocalPlayer.localPlayer().isAuthenticated)
                {
                    self.gameCenterEnabled = true
                    
                    GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier:String?, error:NSError?) -> Void in
                        
                        if (error != nil)
                        {
                            print(error?.localizedDescription)
                        }
                        else
                        {
                            self.leaderBoardIdentifier = leaderboardIdentifier!
                        }
                        
                        } as! (String?, Error?) -> Void)
                    
                }
                else
                {
                    self.gameCenterEnabled = false
                }
            }
            
        } as! (UIViewController?, Error?) -> Void
    }
    @IBAction func restorePurchases(_ sender: AnyObject)
    {
        PFPurchase.restore()
        
        let alert = UIAlertView(title: "Restored", message: "Your purchases have been restored. If you are experiencing issues or you have questions, please contact the developer.", delegate: self, cancelButtonTitle: "Ok")
        
        alert.show()
        
    }
    
    @IBAction func twitter(_ sender: AnyObject)
    {
        let twitterURL = URL(string: "twitter://user?screen_name=NCUnitedApps")
        
        if (UIApplication.shared.canOpenURL(twitterURL!))
        {
            UIApplication.shared.openURL(twitterURL!)
        }
        else
        {
            UIApplication.shared.openURL(URL(fileURLWithPath: "www.twitter.com/NCUnitedApps"))
        }
        
    }
    
    func showLeaderboard(_ identifier: NSString)
    {
        let GKVC = GKGameCenterViewController()
        
        GKVC.gameCenterDelegate = self
        
        GKVC.viewState = GKGameCenterViewControllerState.leaderboards
            
        GKVC.leaderboardIdentifier = identifier as String
        
        present(GKVC, animated: true, completion: nil)
        
    }

    @IBAction func leaderboard(_ sender: AnyObject) {
        
        showLeaderboard("highScoreEasy")
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func freeHInt(_ sender: AnyObject) {
        
        if (AdColony.isVirtualCurrencyRewardAvailable(forZone: "vz5f919c3261564e74a9"))
        {
            print("yes")
            AdColony.playVideoAd(forZone: "vz5f919c3261564e74a9", with: nil, withV4VCPrePopup: true, andV4VCPostPopup: true)
            
        }
        else
        {
            print("no")
            let alert = UIAlertView(title: "Sorry", message: "Ad currently unavailable.", delegate: self, cancelButtonTitle: "Ok")
            
            alert.show()
        }

        
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if ((sender as AnyObject).tag < 5)
        {
            let GVC: GameViewController = segue.destination as! GameViewController
        
            GVC.numberOfButtons = 9
            GVC.numberOfRows = 3
            GVC.numberOfColumns = 3
      

        }
        
        
        
    }
    

}
