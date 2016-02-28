//
//  User.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/20/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit

let defaults = NSUserDefaults.standardUserDefaults()
class User: NSObject {
    
    var name: NSString?
    var screenName: NSString?
    var tagLine: NSString?
    var profileUrl: NSURL?
    var dictionary: NSDictionary?
    var tweetsCount: Int?
    var followingCount: Int?
    var followersCount: Int?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagLine = dictionary["description"] as? String
        tweetsCount = dictionary["statuses_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString{
            profileUrl = NSURL(string: profileUrlString)
        }
    }
    
    static var _currentUser: User?
    
    
    
    class var currentUser: User? {
        
        get {
        if _currentUser == nil {
        let userData = defaults.objectForKey("currentUserData") as? NSData
        
        if let userData = userData {
        let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
        _currentUser = User(dictionary: dictionary)
        }
        }
        return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }}
