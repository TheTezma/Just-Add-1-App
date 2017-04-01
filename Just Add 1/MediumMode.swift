//
//  MediumMode.swift
//  Just Add 1
//
//  Created by Chris Richards on 22/12/2016.
//  Copyright © 2016 Chris Richards. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MediumMode: UIViewController {

  // UI ELEMENTS
  @IBOutlet weak var MediumTextInput: UITextField!
  @IBOutlet weak var TextInputView: UIView!
  @IBOutlet weak var RNGView: UIView!
  @IBOutlet weak var TimeView: UIView!
  @IBOutlet weak var ScoreView: UIView!
  @IBOutlet weak var BackBtn: UIButton!
  @IBOutlet weak var ScoreLabel: UILabel!
  @IBOutlet weak var TimeLabel: UILabel!
  @IBOutlet weak var RNGLabel: UILabel!

  // INIT VARIABLES
  var score:Int = 0
  var timer:Timer?
  var seconds:Int = 60

  var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        InitGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func InitGame() {
        setRandomNumberLabel()
        updateScoreLabel()
        updateTimeLabel()
        SetUIStyling()

        MediumTextInput?.addTarget(self, action: #selector(textFieldDidChange(textField:)), for:UIControlEvents.editingChanged)
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
        if MediumTextInput?.text?.characters.count ?? 0 < 4
        {
            return
        }

        if  let numbers_text    = RNGLabel?.text,
            let input_text      = MediumTextInput?.text,
            let numbers         = Int(numbers_text),
            let input           = Int(input_text)
        {
            print("Comparing: \(input_text) minus \(numbers_text) == \(input - numbers)")

            if(input - numbers == 1111)
            {
                print("Correct!")

                score += 1

                MediumTextInput?.text = ""

                playSoundCorrect()
            }
            else
            {
                print("Incorrect!")

                score -= 1

                MediumTextInput?.text = ""

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

                let savedhighscoreMedium = UserDefaults.standard.integer(forKey: "userhighscoreMedium");

                if(score > savedhighscoreMedium) {
                    let alertController = UIAlertController(title: "HIGHSCORE", message: "You got a new highscore of: \(score) points. Very good!", preferredStyle: .alert)
                    let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                    alertController.addAction(restartAction)

                    self.present(alertController, animated: true, completion: nil)

                    UserDefaults.standard.set(score, forKey: "userhighscoreMedium");

                } else {
                    let alertController = UIAlertController(title: "Time Up!", message: "Your time is up! You got a score of: \(score) points. Very good!", preferredStyle: .alert)
                    let restartAction = UIAlertAction(title: "Restart", style: .default, handler: nil)
                    alertController.addAction(restartAction)

                    self.present(alertController, animated: true, completion: nil)
                }

                score = 0
                seconds = 60

                MediumTextInput?.text = ""

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
            let alertController = UIAlertController(title: "You Lose!", message: "You went below 0 score!", preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Try Again", style: .default, handler: { action in
                //run your function here
                self.RestartGame()
            })
            alertController.addAction(restartAction)

            self.present(alertController, animated: true, completion: nil)
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

        for _ in 1...4
        {
            let digit:Int = Int(arc4random_uniform(8) + 1)

            result += "\(digit)"
        }

        return result
    }

}
