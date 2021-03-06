//
//  TwitterClient.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/20/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let verifyAccountEndPoint = "1.1/account/verify_credentials.json"

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "3dvuLZdWPVV9gIsnPMW1IEb6f", consumerSecret: "mRrVSUnlDf6mWHPmLzNbykemZgoqojy9N8dZz2V1MP6GEOvwNO")
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError)->())?
    
    func login(success: ()->(), failure: (NSError)->() ){
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oath"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
            
            }) { (error: NSError! ) -> Void in
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                
                self.verifyAccount({ (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                    
                    }, failure: { (error: NSError) -> () in
                        self.loginFailure?(error)
                        
                })
                
                print("Got access token!")
                self.loginSuccess!()
                
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure!(error)
        }
    }
    
    func homeTimeline(success: ([Tweet])->(), failure: (NSError)->()){
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil , success: { (task:NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.TweetsWithArray(dictionaries)
           // print(tweets)
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
               failure(error) 
        })
    }
    
    func userTimeLineWithParams(screen_name: String?, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        print(screen_name)
        GET("1.1/statuses/user_timeline.json?screen_name=\(screen_name!)&count=20", parameters: params, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.TweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Error getting user timeline")
                completion(tweets: nil, error: error)
            }
        )
    }
    
    func updateStatusWithCompletion(status: String, inReplyToStatusId: String? = nil, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        self.POST("1.1/statuses/update.json",
            parameters: [
                "status": status,
                "in_reply_to_status_id": inReplyToStatusId ?? ""
            ],
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error updating status")
                print(error.localizedDescription)
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func verifyAccount(success: (User)->(), failure: (NSError)->()) {
        GET(verifyAccountEndPoint, parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                success(user)
                /*
                print("name: \(user.name)")
                print("screenname: \(user.screenName)")
                */
            },
            
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
}
