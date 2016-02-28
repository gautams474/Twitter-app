//
//  ProfileViewController.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/26/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var FollowersCountLabel: UILabel!
    
    var user: User!
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = user?.name as? String
        handleLabel.text = user?.screenName as? String
        let imageURL = (user?.profileUrl)! as NSURL
        profileView.setImageWithURL(imageURL)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        tweetCountLabel.text = formatter.stringFromNumber((user?.tweetsCount)!)
        followingCountLabel.text = formatter.stringFromNumber((user?.followingCount)!)
        FollowersCountLabel.text = formatter.stringFromNumber((user?.followersCount)!)
        
        tableView.delegate = self
        tableView.dataSource = self
        /*
        TwitterClient.sharedInstance.userTimeLineWithParams((user.screenName as! String), params: nil, completion: {(tweets, error) -> () in
            print(self.user.screenName)
            self.tweets = tweets
            self.tableView.reloadData()
        })*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileViewCell", forIndexPath: indexPath) as! ProfileViewCell
        cell.loadCellContents(self.tweets![indexPath.row])
        //cell.tweet = tweets![indexPath.row]
        
        cell.selectionStyle = .Default
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

}
