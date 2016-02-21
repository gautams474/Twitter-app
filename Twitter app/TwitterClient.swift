//
//  TwitterClient.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/20/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

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
    
    func handleOpenUrl(url: NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("I got access token")
            
            self.loginSuccess?()
            /*
            self.currentAccount()
                        */
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
                
        }

    }
    
    func homeTimeline(success: ([Tweet])->(), failure: (NSError)->()){
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil , success: { (task:NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.TweetsWithArray(dictionaries)
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
               failure(error) 
        })
    }
        func currentAccount(){
            GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask,response: AnyObject?) -> Void in
                //print("account: \(response)")
                let user = response as! NSDictionary
                print("name: \(user["name"])")
                
                }, failure: { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                    
            })

    }

}
