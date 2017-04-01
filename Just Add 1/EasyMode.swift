//
//  EasyMode.swift
//  Just Add 1
//
//  Created by Chris Richards on 22/12/2016.
//  Copyright © 2016 Chris Richards. All rights reserved.
//

//          ,--.,--. ,--. ,---. ,--------.      ,---.  ,------.  ,------.       ,--.
//          |  ||  | |  |'   .-''--.  .--'     /  O  \ |  .-.  \ |  .-.  \     /   |
//     ,--. |  ||  | |  |`.  `-.   |  |       |  .-.  ||  |  \  :|  |  \  :    `|  |
//     |  '-'  /'  '-'  '.-'    |  |  |       |  | |  ||  '--'  /|  '--'  /     |  |
//      `-----'  `-----' `-----'   `--'       `--' `--'`-------' `-------'      `--'

//      _____ _          _       _____  _      _                   _
//     / ____| |        (_)     |  __ \(_)    | |                 | |
//    | |    | |__  _ __ _ ___  | |__) |_  ___| |__   __ _ _ __ __| |___
//    | |    | '_ \| '__| / __| |  _  /| |/ __| '_ \ / _` | '__/ _` / __|
//    | |____| | | | |  | \__ \ | | \ \| | (__| | | | (_| | | | (_| \__ \
//     \_____|_| |_|_|  |_|___/ |_|  \_\_|\___|_| |_|\__,_|_|  \__,_|___/

import Foundation
import UIKit
import AVFoundation
import GoogleMobileAds
import Alamofire
import Social
import Flurry_iOS_SDK

class EasyMode: UIViewController {
    
    // UI ELEMENTS
    @IBOutlet weak var EasyTextInput: UITextField!
    @IBOutlet weak var TextInputView: UIView!
    @IBOutlet weak var RNGView: UIView!
    @IBOutlet weak var TimeView: UIView!
    @IBOutlet weak var ScoreView: UIView!
    @IBOutlet weak var BackBtn: UIButton!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var RNGLabel: UILabel!

    /*
    * AD SHIT
    */
    @IBOutlet weak var BannerView: GADBannerView!

    // INIT VARIABLES
    var score:Int = 0
    var timer:Timer?
    var seconds:Int = 60

    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("Standard Game Started", timed: true)
        
        InitGame()
        
        let UUID = UserDefaults.standard.object(forKey: "UUID")
        
        print("UUID: \(UUID)")
        
        Alamofire.request("https://justadd1.herokuapp.com/?action=newgame&score=0&gamemode=1").responseJSON { response in
            print("REQUEST SENT")
        }
        
        BannerView.adUnitID = "ca-app-pub-9891054964508855/5364308922"
        BannerView.rootViewController = self
        BannerView.load(GADRequest())
        print("Loaded Ad")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func InitGame() {
        setRandomNumberLabel()
        updateScoreLabel()
        updateTimeLabel()
        SetUIStyling()

        EasyTextInput?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for:UIControlEvents.editingChanged)
    }

    // SET UX STYLING
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

    func textFieldDidChange(textField:UITextField)
    {
        if EasyTextInput?.text?.characters.count ?? 0 < 3
        {
            return
        }

        if  let numbers_text    = RNGLabel?.text,
            let input_text      = EasyTextInput?.text,
            let numbers         = Int(numbers_text),
            let input           = Int(input_text)
        {
            print("Comparing: \(input_text) minus \(numbers_text) == \(input - numbers)")

            if(input - numbers == 111)
            {
                print("Correct!")

                score += 1

                EasyTextInput?.text = ""

                playSoundCorrect()
            }
            else
            {
                print("Incorrect!")

                score -= 1

                EasyTextInput?.text = ""

                playSoundWrong()
            }
        }

        setRandomNumberLabel()
        updateScoreLabel()

        if(timer == nil)
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:#selector(onUpdateTimer), userInfo:nil, repeats:true)
        }
    }

    func onUpdateTimer()
    {
        if(seconds > 0 && seconds <= 60)
        {
            seconds -= 1

            updateTimeLabel()

            if(seconds <= 10) {
                TimeLabel?.textColor = UIColor.red
            }
        }
        else if(seconds == 0)
        {
            if(timer != nil)
            {
                timer!.invalidate()
                timer = nil

                let savedhighscoreEasy = UserDefaults.standard.integer(forKey: "userhighscoreEasy");

                if(score > savedhighscoreEasy) {
                    UserDefaults.standard.set(score, forKey: "userhighscoreEasy");
                    UserDefaults.standard.set(score, forKey: "lastscore")
                    UserDefaults.standard.set("New Highscore!", forKey: "endstatus")
                    performSegue(withIdentifier: "EasyEndGame", sender: nil)
                } else {
                    UserDefaults.standard.set(score, forKey: "lastscore")
                    UserDefaults.standard.set("Times Up!", forKey: "endstatus")
                    performSegue(withIdentifier: "EasyEndGame", sender: nil)
                }

                score = 0
                seconds = 60

                EasyTextInput?.text = ""

                updateTimeLabel()
                updateScoreLabel()
                setRandomNumberLabel()

                SetUIStyling()
            }
        }
    }

    func updateTimeLabel()
    {
        if(TimeLabel != nil)
        {
            let min:Int = (seconds / 60) % 60
            let sec:Int = seconds % 60

            let min_p:String = String(format: "%02d", min)
            let sec_p:String = String(format: "%02d", sec)

            TimeLabel!.text = "\(min_p):\(sec_p)"
        }
    }

    func RestartGame() {
        timer!.invalidate();
        timer = nil;

        score = 0
        seconds = 60

        updateTimeLabel()
        updateScoreLabel()
        setRandomNumberLabel()
    }

    func updateScoreLabel()
    {
        if(score < 0) {
            UserDefaults.standard.set(score, forKey: "lastscore")
            UserDefaults.standard.set("Game Over!", forKey: "endstatus")
            performSegue(withIdentifier: "EasyEndGame", sender: nil)
        } else {
            ScoreLabel?.text = "\(score)"
        }
    }

    func setRandomNumberLabel()
    {
        RNGLabel?.text = generateRandomNumber()
    }

    func generateRandomNumber() -> String
    {
        var result:String = ""

        for _ in 1...3
        {
            let digit:Int = Int(arc4random_uniform(8) + 1)

            result += "\(digit)"
        }

        return result
    }

}
