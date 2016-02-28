//
//  TweetsViewController.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/20/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    
    var tweets : [Tweet]?
    var imageTapped: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150

        loadHomeTimeLine()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func OnLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func profileImageTapped(sender: AnyObject) {
        imageTapped = sender.view as? UIImageView
        self.performSegueWithIdentifier("ProfileDetail", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ProfileDetail" {
            let tweet = tweets![(imageTapped?.tag)!]
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = tweet.user
        }
        if segue.identifier == "segueForDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            print(tweet)
            let tweetDetailViewController = segue.destinationViewController as! DetailViewController
            tweetDetailViewController.tweet = tweet
        }
    }
    
    
    func loadHomeTimeLine(){
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
           
                self.tweets = tweets //store tweets
               // print(tweet.text)
                self.tableView.reloadData()
            
            }, failure: { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        })
        

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetViewCell") as! TweetViewCell
        cell.loadCellContents(self.tweets![indexPath.row])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "profileImageTapped:")
        cell.profileImage.tag = indexPath.row
        cell.profileImage.addGestureRecognizer(tapGesture)
        cell.profileImage.userInteractionEnabled = true
        
       // print(self.tweets![indexPath.row])s
        return cell

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweetsArray = self.tweets  {
           // print(tweetsArray.count)
            return tweetsArray.count
        } else {
            return 0
        }
    }
    
   
}