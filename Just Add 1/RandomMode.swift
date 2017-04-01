//
//  RandomMode.swift
//  Just Add 1
//
//  Created by Chris Richards on 25/03/2017.
//  Copyright © 2017 Chris Richards. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import GoogleMobileAds
import Alamofire
import SwiftyJSON
import Flurry_iOS_SDK

class RandomMode: UIViewController {
   
    //
    // UI ELEMENTS
    //
    @IBOutlet weak var EasyTextInput: UITextField!
    @IBOutlet weak var TextInputView: UIView!
    @IBOutlet weak var RNGView: UIView!
    @IBOutlet weak var TimeView: UIView!
    @IBOutlet weak var ScoreView: UIView!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var RNGLabel: UILabel!
    @IBOutlet weak var BannerView: GADBannerView!
    
    //
    // INIT VARIABLES
    //
    var timer:Timer?
    
    var StartSeconds:Int = 30
    var StartScore:Int = 0
    var StartInputAmount:Int = 1
    
    var Seconds:Int = 30
    var Score:Int = 0
    var InputAmount:Int = 1
    var Round:Int = 1
    var MathInput:Int = 1
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Random Game Started", timed: true)
        
        InitGame()
        
        BannerView.adUnitID = "ca-app-pub-9891054964508855/5364308922"
        BannerView.rootViewController = self
        BannerView.load(GADRequest())
        
        let UUID = UserDefaults.standard.object(forKey: "UUID")
        
        print("UUID: \(UUID)")
        
        Alamofire.request("https://justadd1.herokuapp.com/?action=newgame&score=0&gamemode=3").responseJSON { response in
            print("REQUEST SENT")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //
    // INITIALIZE GAME FUNCTIONS
    //
    func InitGame() {
        setRandomNumberLabel()
        updateScoreLabel()
        updateTimeLabel()
        SetUIStyling()
        
        EasyTextInput?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for:UIControlEvents.editingChanged)
    }
    
    //
    // SET UX STYLING
    //
    func SetUIStyling() {
        // COLORS
        
        // UI STYLING
        TextInputView?.layer.cornerRadius = 5.0
        RNGView?.layer.cornerRadius = 5.0
        TimeView?.layer.cornerRadius = 5.0
        TimeLabel?.textColor = UIColor.white
        ScoreView?.layer.cornerRadius = 5.0
        BackBtn?.layer.cornerRadius = 5.0
    }
    
    //
    // PLAY THE CORRECT SOUND
    //
    func playSoundCorrect() {
        let url = Bundle.main.url(forResource: "correct", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //
    // PLAY THE WRONG SOUND
    //
    func playSoundWrong() {
        let url = Bundle.main.url(forResource: "wrong", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //
    // CHECK IF ANSWER IS CORRECT OR NOT
    //
    func textFieldDidChange(textField:UITextField) {
        if EasyTextInput?.text?.characters.count ?? 0 < InputAmount
        {
            return
        }
        
        var ConvInput:Int = 0
        
        switch InputAmount {
        case 1:
            ConvInput = 1
        case 2:
            ConvInput = 11
        case 3:
            ConvInput = 111
        case 4:
            ConvInput = 1111
        case 5:
            ConvInput = 11111
        case 6:
            ConvInput = 111111
        case 7:
            ConvInput = 1111111
        case 8:
            ConvInput = 11111111
        default:
            print("wtf is this")
        }
        
        MathInput = ConvInput
        
        if  let numbers_text    = RNGLabel?.text,
            let input_text      = EasyTextInput?.text,
            let numbers         = Int(numbers_text),
            let input           = Int(input_text)
        {
            print("Comparing: \(input_text) minus \(numbers_text) == \(input - numbers)")
            
            if(input - numbers == MathInput)
            {
                print("Correct!")
                
                Score += 1
                
                Seconds += 2
                
                EasyTextInput?.text = ""
                
                updateTimeLabel()
                
                playSoundCorrect()
                
                print(InputAmount)
                
                var ConvInput:Int = 0
                
                switch InputAmount {
                case 1:
                    ConvInput = 1
                case 2:
                    ConvInput = 11
                case 3:
                    ConvInput = 111
                case 4:
                    ConvInput = 1111
                case 5:
                    ConvInput = 11111
                case 6:
                    ConvInput = 111111
                case 7:
                    ConvInput = 1111111
                case 8:
                    ConvInput = 11111111
                default:
                    print("wtf is this")
                }
                
                MathInput = ConvInput
                
            }
            else
            {
                print("Incorrect!")
                
                Score -= 1
                
                Seconds = Seconds - 2
                
                EasyTextInput?.text = ""
                
                updateTimeLabel()

                playSoundWrong()
                
                if InputAmount == 0 {
                    Seconds = 0
                }
                
                var ConvInput:Int = 0
                
                switch InputAmount {
                case 1:
                    ConvInput = 1
                case 2:
                    ConvInput = 11
                case 3:
                    ConvInput = 111
                case 4:
                    ConvInput = 1111
                case 5:
                    ConvInput = 11111
                case 6:
                    ConvInput = 111111
                case 7:
                    ConvInput = 1111111
                case 8:
                    ConvInput = 11111111
                default:
                    print("wtf is this")
                }
                
                MathInput = ConvInput
            }
        }
        
        setRandomNumberLabel()
        updateScoreLabel()
        
        if(timer == nil)
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(onUpdateTimer), userInfo:nil, repeats:true)
        }
    }
    
    //
    // CHECK IF PLAYER HAS RUN OUT OF TIME
    //
    func onUpdateTimer() {
        if(Seconds > 0 && Seconds <= 60)
        {
            Seconds -= 1
            
            updateTimeLabel()
            
            if(Seconds <= 10) {
                TimeLabel?.textColor = UIColor.red
            }
        } else if(Seconds <= 0 && Seconds < 60) {
            
            if(timer != nil)
            {
                timer!.invalidate()
                timer = nil
                
                let savedhighscoreUnlimited = UserDefaults.standard.integer(forKey: "userhighscoreRandom");
                
                if(Score > savedhighscoreUnlimited) {
                    UserDefaults.standard.set(Score, forKey: "userhighscoreRandom");
                    UserDefaults.standard.set(Score, forKey: "lastscore")
                    UserDefaults.standard.set("New Highscore!", forKey: "endstatus")
                    performSegue(withIdentifier: "RandomEndGame", sender: nil)
                } else {
                    UserDefaults.standard.set(Score, forKey: "lastscore")
                    UserDefaults.standard.set("Times Up!", forKey: "endstatus")
                    performSegue(withIdentifier: "RandomEndGame", sender: nil)
                }
                
                Score = 0
                Seconds = 30
                MathInput = Int(1)
                
                TimeLabel?.textColor = UIColor.white
                
                EasyTextInput?.text = ""
                
                updateTimeLabel()
                updateScoreLabel()
                setRandomNumberLabel()
                
                SetUIStyling()
            }
        }
    }
    
    //
    // UPDATE TIME LABEL
    //
    func updateTimeLabel() {
        if(TimeLabel != nil)
        {
            let min:Int = (Seconds / 60) % 60
            let sec:Int = Seconds % 60
            
            let min_p:String = String(format: "%02d", min)
            let sec_p:String = String(format: "%02d", sec)
            
            TimeLabel!.text = "\(min_p):\(sec_p)"
        }
    }
    
    //
    // RESTART GAME
    //
    func RestartGame() {
        timer!.invalidate();
        timer = nil;
        
        Score = 0
        Seconds = 30
        MathInput = Int(1)
        
        TimeLabel?.textColor = UIColor.white
        
        updateTimeLabel()
        updateScoreLabel()
        setRandomNumberLabel()
    }
    
    //
    // UPDATE SCORE LABEL
    //
    func updateScoreLabel() {
        if(Score < 0) {
            UserDefaults.standard.set("Game Over!", forKey: "endstatus")
            performSegue(withIdentifier: "RandomEndGame", sender: nil)
        } else {
            ScoreLabel?.text = "\(Score)"
        }
    }
    
    //
    // SET RNG LABEL
    //
    func setRandomNumberLabel() {
        RNGLabel?.text = generateRandomNumber()
    }
    
    //
    // DIGIT AMOUNT GENERATOR
    //
    func generateRandomDigitAmount() -> String {
        var result2:Int
        
        for _ in 1...6
        {
            let digit:Int = Int(arc4random_uniform(8) + 1)
            
            result2 = digit
            InputAmount = digit
        }
        print("InputAmount: \(InputAmount)")
        return "yoo"
    }
    
    //
    // RANDOM NUMBER GENERATOR
    //
    func generateRandomNumber() -> String {
        generateRandomDigitAmount()
        
        var result:String = ""
        
        for _ in 1...InputAmount
        {
            let digit:Int = Int(arc4random_uniform(8) + 1)
            
            result += "\(digit)"
        }
        
        return result
    }
    
}
