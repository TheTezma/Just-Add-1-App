//
//  ViewController.swift
//  Just Add 1
//
//  Created by Chris Richards on 20/12/2016.
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
import UIKit
import AVFoundation
import GoogleMobileAds
import Flurry_iOS_SDK

class ViewController: UIViewController {

    // UI ELEMENTS
    @IBOutlet weak var EasyButton: UIButton!
    @IBOutlet weak var MediumButton: UIButton!
    @IBOutlet weak var UnlimitedButton: UIButton!
    @IBOutlet weak var RandomButton: UIButton!
    @IBOutlet weak var TopButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    @IBOutlet weak var SetUsernameBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Flurry.logEvent("App Started", timed: true)
        
        SetUIStyling()
        CheckUsername()
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "UUID") != nil {
            let uuid = userDefaults.object(forKey: "UUID")
            print("UUID: \(uuid)")
        } else {
            let uuid = NSUUID().uuidString
            userDefaults.set(uuid, forKey: "UUID")
            userDefaults.synchronize()
            let UUID = userDefaults.object(forKey: "UUID")
            print("Attempting to create UUID")
            print("UUID: \(uuid)")
            let Users = User()
            Users.NewUser(uuid: UUID as! String)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // SET UI STYLE
    func SetUIStyling() {
        // COLORS

        // UI STYLING
        EasyButton?.layer.cornerRadius = 5.0
        UnlimitedButton?.layer.cornerRadius = 5.0
        RandomButton?.layer.cornerRadius = 5.0
        TopButton?.layer.cornerRadius = 5.0
        SettingsButton?.layer.cornerRadius = 5.0
        SetUsernameBtn?.layer.cornerRadius = 5.0
    }

    func CheckUsername() {
        if((UserDefaults.standard.object(forKey: "username")) != nil) {
            // DISPLAY "SET USERNAME" BUTTON
            SetUsernameBtn.isHidden = true;
        } else {
            // DO NOTHING
        }
    }
    
}
