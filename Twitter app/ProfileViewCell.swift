//
//  ProfileViewCell.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/26/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var FavouriteImage: UIImageView!

    @IBOutlet weak var favouriteCountLabel: UILabel!
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ProfileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadCellContents(tweet: Tweet) {
        
        let imageURL = (tweet.user?.profileUrl)! as NSURL
        self.ProfileImageView.setImageWithURL(imageURL)
        
        //labels
        nameLabel.text = tweet.user!.name as? String
        screenNameLabel.text = "@\(tweet.user!.screenName!)"
        tweetLabel.text = tweet.text! as String
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favouriteCountLabel.text = "\(tweet.favouritesCount)"
        FavouriteImage.image = UIImage(named: "grey_heart")
        retweetImage.image = UIImage(named: "retweetImg")
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MMM d HH:mm"
        createdAtLabel.text = dateformatter.stringFromDate(tweet.timeStamp!)+""
    }


}
