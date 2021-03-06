//
//  TweetCell.swift
//  Tweeter
//
//  Created by Alex Clark on 2/7/16.
//  Copyright © 2016 R. Alex Clark. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    // Outlets
    
    // Images
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var usersRetweetImageView: UIImageView!
    
    // Labels
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var tweetContentLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    
    // Buttons
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    
    
    // Variables
    
    // Retweet & Fav tests and counts
    var isRetweet = false
    var isFavorite = false
    var retweetCount: Int!
    var favoriteCount: Int!
    
    // Tweet we are referencing for this cell
    var tweet: Tweet! {
        didSet {
            // Tweet content
            tweetContentLabel.text = tweet.text!
            tweetContentLabel.sizeToFit()
            
            // Users' profile and username
            profileNameLabel.text = tweet.user!.name
            usernameLabel.text = "@\(tweet.user!.screenName!)"

            // Setup count labels
            retweetCountLabel.text = "\(tweet.retweetCount!)"
            favoriteCountLabel.text = "\(tweet.favoriteCount!)"
            
            // User's image
            profileImageView.setImageWithURL(NSURL(string: (tweet.user?.profileImageURL)!)!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true;
            
            // Set cell counts
            retweetCount = tweet.retweetCount!
            favoriteCount = tweet.favoriteCount!
            timeLabel.text = "\(tweet.createdAtString!)"
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        checkLabelColors()
        // Initialization code
    }
    
    
    // Check the label colors
    func checkLabelColors() {
        if (tweet != nil) {
            tweet.isFavorited! ? (favoriteCountLabel.textColor = UIColor.redColor()) : (favoriteCountLabel.textColor = UIColor.blackColor())
            tweet.isRetweeted! ? (retweetCountLabel.textColor = UIColor.greenColor()) : (retweetCountLabel.textColor = UIColor.blackColor())
        }
    }
    
    // Increment the fav or RT counts and their labels
    func labelIncrement(type: String) {
        if (type.lowercaseString == "retweet") {
            // It is a rt
            
            // Setup the label & button colors
            retweetButton.tintColor = UIColor.greenColor()
            retweetCountLabel.textColor = UIColor.greenColor()
            
            tweet.retweetCount! = tweet.retweetCount! + 1
            retweetCount = tweet.retweetCount
            retweetCountLabel.text = "\(retweetCount)"
        } else {
            // It is a fav
            
            // Setup the label & button colors
            favoriteButton.tintColor = UIColor.redColor()
            favoriteCountLabel.textColor = UIColor.redColor()
            
            tweet.favoriteCount! = tweet.favoriteCount! + 1
            favoriteCount = tweet.favoriteCount!
            favoriteCountLabel.text = "\(favoriteCount)"
        }
    }
    
    // Increment the fav or RT counts and their labels
    func labelDecrement(type: String) {
        if (type.lowercaseString == "retweet") {
            // It is a rt
            
            retweetButton.tintColor = UIColor.grayColor()
            retweetCountLabel.textColor = UIColor.grayColor()
            
            // Adjust labels
            tweet.retweetCount! = tweet.retweetCount! - 1
            retweetCount = tweet.retweetCount
            retweetCountLabel.text = "\(retweetCount)"
            
        } else {
            // It is a fav
            
            // Setup the label and button colors
            favoriteButton.tintColor = UIColor.grayColor()
            favoriteCountLabel.textColor = UIColor.grayColor()
            
            // Adjust labels
            tweet.favoriteCount! = tweet.favoriteCount! - 1
            favoriteCount = tweet.favoriteCount!
            favoriteCountLabel.text = "\(favoriteCount)"
            
        }
    }
    
    // Retweeting Action
    @IBAction func onRetweet(sender: AnyObject) {
        
        if !(tweet.isRetweeted!) {
            
            tweet.isRetweeted = true
            
            // Change the RT label
            labelIncrement("retweet")
            
            // Send retweet
            TwitterClient.sharedInstance.retweet(tweet.id!)
            
        }
        
        else {
            if (tweet.retweetCount != nil) {
                
                tweet.isRetweeted = false
                
                labelDecrement("retweet")
            }
            
            // Call unretweet api func
            TwitterClient.sharedInstance.unRetweet(tweet.id!)
        }
    }
    
    
    // Favoriting Action
    @IBAction func onFavorite(sender: AnyObject) {
        if !(tweet.isFavorited!) {
            
            tweet.isFavorited = true
            
            // Change fav label
            labelIncrement("favorite")
            
            // Send retweet
            TwitterClient.sharedInstance.favorite(tweet.id!)
        }
            
        else {
            
            if (tweet.favoriteCount != nil) {
                
                tweet.isFavorited = false
                
                labelDecrement("favorite")
                
            }
            
            // Call unfavorite api func
            TwitterClient.sharedInstance.unFavorite(tweet.id!)
        }
    }

}
