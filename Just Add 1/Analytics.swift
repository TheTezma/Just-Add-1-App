//
//  Analytics.swift
//  Just Add 1
//
//  Created by Chris Richards on 27/03/2017.
//  Copyright © 2017 Chris Richards. All rights reserved.
//

import Foundation
import Alamofire

class Analytics: NSObject {
    
    func GameEnd(gamemode: Int, score: Int) {
        Alamofire.request("https://justadd1.herokuapp.com/?action=newgame&score=\(score)&gamemode=\(gamemode)").responseJSON { response in
            print("GameEnd Request Sent")
        }
    }
    
}
