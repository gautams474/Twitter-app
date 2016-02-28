//
//  DetailViewController.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/27/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var retweetImage: UIImageView!
    
    
    var tweet: Tweet!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tweet)
       profileView.setImageWithURL((tweet.user?.profileUrl)!)
        nameLabel.text = tweet.user?.name as? String
        tweetLabel.text = tweet.text as? String
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MMM d HH:mm"
        createdAtLabel.text = dateformatter.stringFromDate(tweet.timeStamp!)+""
        
        favoriteImage.image = UIImage(named: "grey_heart")
        retweetImage.image = UIImage(named: "retweetImg")
        
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favouritesCount)"
        
        // Do any additional setup after loading the view.
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

}
