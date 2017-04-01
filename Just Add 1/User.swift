//
//  User.swift
//  Just Add 1
//
//  Created by Chris Richards on 27/03/2017.
//  Copyright © 2017 Chris Richards. All rights reserved.
//

import Foundation
import Alamofire

class User: NSObject {
 
    func NewUser(uuid: String) {
        Alamofire.request("https://justadd1.herokuapp.com/?action=newuser&uuid=\(uuid)").responseJSON { response in
            print("NewUser Request Sent")
        }
    }
    
    func NewUsername(uuid: String, username: String) {
        Alamofire.request("https://justadd1.herokuapp.com/?action=newusername&uuid=\(uuid)&username=\(username)").responseJSON { response in
            print("NewUsername Request Sent")
        }
    }
    
}
