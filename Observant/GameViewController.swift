//
//  GameViewController.swift
//  Observant
//
//  Created by Trevor Stevenson on 9/28/14.
//  Copyright (c) 2014 ncunited. All rights reserved.
//

import UIKit
import GameKit

class GameViewController: UIViewController, UIAlertViewDelegate {
        
    //outlets
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var FiftyFiftyButton: UIButton!
    
    @IBOutlet weak var hintsLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var fiftyLabel: UILabel!
    
    // stores what level it is
    var level: Int = 1
    
    // layout variables
    var numberOfButtons: Int = 0
    var numberOfRows: Int = 0
    var numberOfColumns: Int = 0
    
    // stores the buttons in an array
    var buttonsArray: [UIButton] = []
    //the random index of the button to be changed
    var randIndex: Int = 0
    
    // timer variables
    var timerRunning = false
    var timerValue: Int = 10
    var timer = Timer()
    var timeTaken: Int = 21
    var afterTimer = Timer()
    
    // bool to see whether the buttons have been layed out to avoid doing it twice
    var levelHasLayedOutSubviews = false
    
    // stores the player score
    var score: Int = 0
    
    // hint credits
    var numberOfHints: Int = UserDefaults.standard.integer(forKey: "hints")
    var numberOfFifty: Int = UserDefaults.standard.integer(forKey: "fifty")
    
    // the two labels on screen
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // calls new level which prompts a pop up box with the level number
        newLevel()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        
        highScoreLabel.text = "High Score: \(highScore)"
        
        let mainQueue = OperationQueue.main
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: mainQueue) { (notification:Notification) -> Void in
            
            self.quitGame()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        UserDefaults.standard.set(numberOfHints, forKey: "hints")
        UserDefaults.standard.set(numberOfFifty, forKey: "fifty")
        
        submitScore()

    }
    
    
    func newLevel()
    {
        levelHasLayedOutSubviews = false
        
        // creates pop up box which fades in and out
        presentMessage(200, height: 50, x: self.view.center.x - 100, y: self.view.center.y - 25, bgColor: UIColor.black, message: "Level \(level)", textColor: UIColor.white, fontSize: 30)
        
        timerValue = 10
        timeTaken = 21
        
        timerLabel.text = String(timerValue)
        
        updateScore()
    }
    
    func presentMessage(_ width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat, bgColor: UIColor, message: String, textColor: UIColor, fontSize: CGFloat)
    {
        let box = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        
        box.backgroundColor = bgColor
        box.layer.cornerRadius = 5.0
        box.clipsToBounds = true
        box.alpha = 0.0
        
        let label = UILabel(frame: box.frame)
        
        label.text = message as String
        label.font = UIFont(name: "Avenir-Book", size: fontSize)
        label.textColor = textColor
        label.textAlignment = .center
        label.alpha = 0.0
        
        self.view.addSubview(box)
        self.view.addSubview(label)
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            box.alpha = 1.0
            label.alpha = 1.0
            
            }, completion: {(finished: Bool) in
            
            self.fadeOut(1, subview: box)
            self.fadeOut(1, subview: label)
            
        })
    }
    
    func fadeOut(_ withDuration: TimeInterval, subview : UIView)
    {
        UIView.animate(withDuration: withDuration, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {subview.alpha = 0.0}, completion: {finished in if(self.levelHasLayedOutSubviews == false)
        {
            self.layoutButtons()
            self.levelHasLayedOutSubviews = true
            
        }})
    }
    
    func layoutButtons()
    {
        var xPos: CGFloat = 20
        var yPos: CGFloat = 40
        
        let width: CGFloat = self.view.frame.size.width - 40
        var height: CGFloat
        
        if (self.view.frame.size.height == 480)
        {
            height = self.view.frame.size.height - 180
           
        }
        else if (self.view.frame.size.height == 568)
        {
            height = self.view.frame.size.height - 180
        }
        else if (self.view.frame.size.height == 667)
        {
            height = self.view.frame.size.height - 180
        }
        else
        {
            height = self.view.frame.size.height - (self.view.frame.size.height/4)
        }
        
        let buttonsPerRow = numberOfButtons / numberOfRows
        
        
        for i: Int in 1...numberOfRows
        {
            for ink in 1...buttonsPerRow
            {
                let button = UIButton(frame: CGRect(x: xPos, y: yPos, width: (width / CGFloat(numberOfColumns)) - 2.5, height: (height / CGFloat(numberOfRows)) - 2.5))
                
                button.backgroundColor = UIColor.white
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.borderWidth = 2.0
                button.layer.cornerRadius = 15.0
                button.clipsToBounds = true
                
                let randNum: Int = Int(arc4random_uniform(11))
                
                button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 17)
                button.setTitle(String(randNum), for: UIControlState())
                button.setTitleColor(UIColor.black, for: UIControlState())
                button.addTarget(self, action: #selector(GameViewController.chooseNumber(_:)), for: UIControlEvents.touchUpInside)
                button.isUserInteractionEnabled = false
                
                buttonsArray.append(button)
            
                self.view.insertSubview(button, belowSubview: highScoreLabel)
                
                if (ink < buttonsPerRow)
                {
                    xPos += button.frame.width + 5
                }
                
            }
            
            if (i < numberOfRows)
            {
                yPos += (height / CGFloat(numberOfRows)) + 2.5
                xPos = 20
            }
        }
        
        setUpTimer()
    }
    
    func setUpTimer()
    {
        if (timerRunning == false)
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.timerCountdown), userInfo: nil, repeats: true)
            timerRunning = true
        }
    }
    
    func timerCountdown()
    {
        timerValue -= 1
        
        timerLabel.text = String(timerValue)
        
        if (timerValue <= 0)
        {
            timer.invalidate()
            timerRunning = false
            
            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(GameViewController.makeChange), userInfo: nil, repeats: false)
            
            callCurtain()
        }
    }
    
    func makeChange()
    {
        randIndex = Int(arc4random_uniform(UInt32(numberOfButtons)))
        
        var newNumber: Int = Int(arc4random_uniform(11))
        
        let theChosenButton: UIButton = buttonsArray[randIndex] as UIButton
        let titleText = theChosenButton.titleLabel?.text
        
        while (String(newNumber) == titleText)
        {
            newNumber = Int(arc4random_uniform(11))
        }
        
        theChosenButton.setTitle(String(newNumber), for: UIControlState())
        
        for button in buttonsArray
        {
            button.isUserInteractionEnabled = true
        }
    }
    
    func callCurtain()
    {
        let curtain = UIView(frame: CGRect(x: 0, y: -(self.view.frame.size.height), width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        curtain.backgroundColor = UIColor.black
        
        self.view.insertSubview(curtain, belowSubview: highScoreLabel)
        
        UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            curtain.frame.origin.y = self.view.frame.size.height
            
            }, completion: {(finished: Bool) in
                
                curtain.removeFromSuperview()
                self.afterTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.afterTimerCount), userInfo: nil, repeats: true)
        })
    }
    
    func afterTimerCount()
    {
        timeTaken -= 1
        
        if (timeTaken <= 0)
        {
            afterTimer.invalidate()
        }
    }
    
    @IBAction func chooseNumber (_ sender: UIButton!)
    {
        if (sender.title(for: UIControlState()) == buttonsArray[randIndex].title(for: UIControlState()))
        {
            self.presentMessage(200, height: 50, x: self.view.center.x - 100, y: self.view.center.y - 25, bgColor: UIColor.black, message: "Correct", textColor: UIColor.white, fontSize: 30)
            
            score += (100 * timeTaken)
            score += level * 10
                        
            self.updateScore()
            
            level += 1
            
            _ = Timer.scheduledTimer(timeInterval: 2.1, target: self, selector: #selector(GameViewController.newLevel), userInfo: nil, repeats: false)
            
            
        }
        else
        {
            self.presentMessage(200, height: 50, x: self.view.center.x - 100, y: self.view.center.y - 25, bgColor: UIColor.black, message: "Incorrect, Game Over", textColor: UIColor.white, fontSize: 15)
            
            submitScore()
            
            _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(GameViewController.quitGame), userInfo: nil, repeats: false)
        }
        
        for button in buttonsArray
        {
            button.removeFromSuperview()
        }
        
        buttonsArray = []
        
        scoreLabel.text = String(score)
        
        afterTimer.invalidate()
    }
    
    func quitGame()
    {
        //make this a navigation controller
        self.navigationController?.popToRootViewController(animated: true)
        
        timer.invalidate()
        afterTimer.invalidate()

    }
    
    func updateScore()
    {
        scoreLabel.text = String(score)
    }
    
    
    @IBAction func hint(_ sender: AnyObject)
    {
        if (numberOfHints > 0)
        {
            giveHint()
            
            numberOfHints -= 1
            
            hintsLabel.text = "Hints: \(numberOfHints)"
            
        }
        else
        {
            let alert = UIAlertView(title: "No hints remaining.", message: "You have no more hints. Go to the store to buy more and help you reach the top of the leaderboards!", delegate: self, cancelButtonTitle: "Ok", otherButtonTitles: "Store")
            
            alert.show()
        
        }
       
    }
    
    
    @IBAction func FiftyFifty(_ sender: AnyObject)
    {
        
        if (numberOfFifty > 0)
        {
            giveFiftyFifty()
            numberOfFifty -= 1
            fiftyLabel.text = "50/50s: \(numberOfFifty)"
        }
        else
        {
            let alert = UIAlertView(title: "No 50/50 remaining.", message: "You have no more 50/50s. Go to the store to buy more and help you reach the top of the leaderboards!", delegate: self, cancelButtonTitle: "Ok", otherButtonTitles: "Store")
            alert.show()
        }
    }
    
    func giveHint()
    {
        let hintButton = buttonsArray[randIndex]
        hintButton.backgroundColor = UIColor.green
    }
    
    func giveFiftyFifty()
    {
        var numberToEliminate: Int
            
        if (numberOfButtons % 2 == 0)
        {
            numberToEliminate = (numberOfButtons / 2)
        }
        else
        {
            numberToEliminate = (numberOfButtons / 2) + 1
        }
    
        var sequenceArray: [Int] = []
        
        for i in 0 ..< numberOfButtons
        {
            sequenceArray.append(i)
        }
        
        for i in 0..<numberToEliminate
        {
            var rand = arc4random_uniform(UInt32(numberOfButtons) - UInt32(i))
            
            while (sequenceArray[Int(rand)] == randIndex)
            {
                rand = arc4random_uniform(UInt32(numberOfButtons) - UInt32(i))
            }
            
            let button = buttonsArray[sequenceArray[Int(rand)]] as UIButton
            button.setTitle("", for: UIControlState())
            button.isUserInteractionEnabled = false
            
            sequenceArray.remove(at: Int(rand))
        }
    }
    
    func submitScore()
    {
        var id: String = ""
        
        if (numberOfButtons == 9)
        {
            id = "highScoreEasy"
        }
        else if (numberOfButtons == 16)
        {
            id = "highScoreMedium"
        }
        else if (numberOfButtons == 25)
        {
            id = "highScoreHard"
        }
        
        let highScore = GKScore(leaderboardIdentifier:id)
        highScore.value = Int64(score)
        
        GKScore.report([highScore], withCompletionHandler: { (error: Error?) -> Void in
            
            if let err = error
            {
                print(err.localizedDescription)
            }
            
        })
        
        UserDefaults.standard.set(score, forKey: "highScore")
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        let SVC = storyboard?.instantiateViewController(withIdentifier: "SVC") as? StoreViewController
        
        if let storeVC = SVC, buttonIndex == 1
        {
            self.navigationController?.present(storeVC, animated: true, completion: nil)
            storeVC.isPresentedModally = true
        }
    }

}
