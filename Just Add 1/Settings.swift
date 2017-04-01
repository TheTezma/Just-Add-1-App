//
//  Settings.swift
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
import Alamofire

class Settings: UIViewController {
    
    // UI ELEMENTS
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var EasyHighscore: UILabel!
    @IBOutlet weak var MediumHighscore: UILabel!
    @IBOutlet weak var RandomHighscore: UILabel!
    @IBOutlet weak var SettingsView1: UIView!
    @IBOutlet weak var SettingsView2: UIView!
    @IBOutlet weak var usernameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUIStyling()
        FetchHighscores()
        CheckUsername()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // SET UI STYLE
    func SetUIStyling() {
        // COLORS
        
        // UI STYLING
        BackButton?.layer.cornerRadius = 5.0
        SettingsView2?.layer.cornerRadius = 5.0
        SettingsView1?.layer.cornerRadius = 5.0
    }
    
    func FetchHighscores() {
        let savedhighscoreEasy = UserDefaults.standard.integer(forKey: "userhighscoreEasy");
        EasyHighscore.text = "Standard Highscore: \(savedhighscoreEasy)"
        
        let savedhighscoreMedium = UserDefaults.standard.integer(forKey: "userhighscoreUnlimited");
        MediumHighscore.text = "Unlimited Highscore: \(savedhighscoreMedium)"
        
        let savedhighscoreRandom = UserDefaults.standard.integer(forKey: "userhighscoreRandom");
        RandomHighscore.text = "Random Highscore: \(savedhighscoreRandom)"
    }
    
    @IBAction func SaveUsername(_ sender: Any) {
        let username = usernameInput.text
        
        UserDefaults.standard.set(username, forKey: "username");
        
        let UUID = UserDefaults.standard.object(forKey: "UUID")
        let Username = UserDefaults.standard.object(forKey: "username")
        
        let Users = User()
        Users.NewUsername(uuid: UUID as! String, username: Username as! String)
        
        print("UUID: \(UUID)")
        print("Username: \(Username)")
    }
    
    func CheckUsername() {
        if((UserDefaults.standard.object(forKey: "username")) != nil) {
            // DISPLAY "SET USERNAME" BUTTON
            SettingsView2.isHidden = true;
        } else {
            // DO NOTHING
        }
    }
    
}
