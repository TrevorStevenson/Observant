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
    
    func authenticateLocalPlayer()
    {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController: UIViewController?, error: Error?) in
            
            if let VC = viewController { self.present(VC, animated: true, completion: nil) }
            else
            {
                guard localPlayer.isAuthenticated else { return }
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler:nil)
            }
        }
    }
    
    func showLeaderboard(withIdentifier identifier: String)
    {
        let GKVC = GKGameCenterViewController()
        GKVC.gameCenterDelegate = self
        GKVC.viewState = GKGameCenterViewControllerState.leaderboards
        GKVC.leaderboardIdentifier = identifier
        
        present(GKVC, animated: true, completion: nil)
    }

    @IBAction func leaderboard(_ sender: AnyObject) {
        
        showLeaderboard(withIdentifier: "highScoreEasy")
        
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        dismiss(animated: true, completion: nil)
        
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
