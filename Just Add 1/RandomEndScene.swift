//
//  EndGame.swift
//  Just Add 1
//
//  Created by Chris Richards on 19/03/2017.
//  Copyright © 2017 Chris Richards. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import Alamofire
import Social

class RandomEndScene: UIViewController {
    
    @IBOutlet weak var EndGameStatus: UILabel!
    @IBOutlet weak var EndGameScore: UILabel!
    @IBOutlet weak var EndGameHighScore: UILabel!
    
    @IBOutlet weak var EndGameView: UIView!
    @IBOutlet weak var RestartButton: UIButton!
    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var FBShareBtn: UIButton!
    @IBOutlet weak var TwttrShareBtn: UIButton!
    
    @IBOutlet weak var BannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EndGameView?.layer.cornerRadius = 5.0
        RestartButton?.layer.cornerRadius = 5.0
        HomeButton?.layer.cornerRadius = 5.0
        FBShareBtn?.layer.cornerRadius = 5.0
        TwttrShareBtn?.layer.cornerRadius = 5.0
        
        let endgamestatus = UserDefaults.standard.string(forKey: "endstatus")
        let savedhighscoreRandom = UserDefaults.standard.integer(forKey: "userhighscoreRandom");
        let endgamescore = UserDefaults.standard.integer(forKey: "lastscore")
        
        EndGameStatus.text = endgamestatus
        EndGameHighScore.text = String("Highscore: " + String(savedhighscoreRandom))
        EndGameScore.text = String("Score: " + String(endgamescore))
        
        BannerView.adUnitID = "ca-app-pub-9891054964508855/5364308922"
        BannerView.rootViewController = self
        BannerView.load(GADRequest())
        
        let Analytic = Analytics()
        Analytic.GameEnd(gamemode: 3, score: endgamescore)
        
    }
    
    @IBAction func FacebookShare(_ sender: Any) {
        let endgamescore = UserDefaults.standard.integer(forKey: "lastscore")
        
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        vc?.add(URL(string: "https://itunes.apple.com/au/app/just-add-1/id1188951549?mt=8&ign-mpt=uo%3D4"))
        vc?.setInitialText(String("I just scored \(endgamescore) on #justadd1"))
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func TwitterShare(_ sender: Any) {
        let endgamescore = UserDefaults.standard.integer(forKey: "lastscore")
        
        let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        vc?.add(URL(string: "https://itunes.apple.com/au/app/just-add-1/id1188951549?mt=8&ign-mpt=uo%3D4"))
        vc?.setInitialText(String("I just scored \(endgamescore) on #justadd1"))
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
