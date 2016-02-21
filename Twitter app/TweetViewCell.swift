//
//  TweetViewCell.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 2/20/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var handleLable: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     func loadCellContents(tweet: Tweet) {
        
        let imageURL = (tweet.user?.profileUrl)! as NSURL
        self.profileImage.setImageWithURL(imageURL)
        
        //labels
        userLabel.text = tweet.user!.name as? String
        handleLable.text = "@\(tweet.user!.screenName!)"
        tweetLabel.text = tweet.text! as String
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
