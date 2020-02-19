//
//  TweetCell.swift
//  Twitter
//
//  Created by Carlos Estrada on 9/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userUsername: UILabel!
    @IBOutlet weak var userTweet: UILabel!
    @IBOutlet weak var timeCreated: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCount: UILabel!
    
    var retweeted:Bool = false
    var favorited:Bool = false
    var rtCount:Int = 0
    var favCount:Int = 0
    var tweetID:Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfilePicture.layer.masksToBounds = false
        userProfilePicture.layer.cornerRadius = userProfilePicture.frame.height / 2
        userProfilePicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Retweet Logic

    @IBAction func retweetTweet(_ sender: Any) {
        let willBeRetweeted = !retweeted
        if (willBeRetweeted) {
            TwitterAPICaller.client?.retweetTweet(tweetID: tweetID, success: {
                self.setRetweet(true)
                self.rtCount += 1
                self.retweetCount.text = "\(self.rtCount)"
            }, failure: { (Error) in
                print("Error retweeting tweet \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unretweetTweet(tweetID: tweetID, success: {
                self.setRetweet(false)
                self.rtCount -= 1
                self.retweetCount.text = "\(self.rtCount)"
            }, failure: { (Error) in
                print("Error unretweeting tweet \(Error)")
            })
        }
    }
    
    func setRetweet(_ isRetweeted:Bool) {
        retweeted = isRetweeted
        if (retweeted) {
            retweetButton.setBackgroundImage(UIImage(named: "retweet-selected"), for: UIControl.State.normal)
        } else {
            retweetButton.setBackgroundImage(UIImage(named: "retweet-deselected"), for: UIControl.State.normal)
        }
    }
    
    // MARK: - Favorite Logic
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let willBeFavorited = !favorited
        if (willBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(true)
                self.favCount += 1
                self.favoriteCount.text = "\(self.favCount)"
            }, failure: { (Error) in
                print("Error favoriting tweet \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetID: tweetID, success: {
                self.setFavorite(false)
                self.favCount -= 1
                self.favoriteCount.text = "\(self.favCount)"
            }, failure: { (Error) in
                print("Error unfavoriting tweet \(Error)")
            })
        }
    }
    
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favoriteButton.setBackgroundImage(UIImage(named: "favorite-selected"), for: UIControl.State.normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage(named: "favorite-deselected"), for: UIControl.State.normal)
        }
    }
}
