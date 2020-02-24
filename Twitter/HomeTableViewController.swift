

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweets = [NSDictionary]()
    var tweetsToFetch = 20
    let tweetRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 180
        
        getTweets()
        tweetRefreshControl.addTarget(self, action: #selector(getTweets), for: .valueChanged)
        tableView.refreshControl = tweetRefreshControl
    }
    
    // MARK: - Twitter API fetching
    
    @objc func getTweets() {
        self.getTweets(tweetsToFetch: tweetsToFetch)
    }
    
    func getTweets(tweetsToFetch: Int = 20) {
        let URL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": tweetsToFetch]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: URL, parameters: params, success: { (tweets: [NSDictionary]) in
            self.tweets.removeAll()
            for tweet in tweets {
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            self.tweetRefreshControl.endRefreshing()
            print("success")
        }, failure: { (Error) in
            print("Error retrieving tweets")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row + 3 == tweets.count {
                tweetsToFetch += 20
                getTweets(tweetsToFetch: tweetsToFetch)
           }
       }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "USER_LOGGED_IN")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    // Fill in table cell with the tweet data fetched from Twitter API

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweets[indexPath.row]["user"] as! NSDictionary
        
        cell.userFullName.text = user["name"] as? String
        
        // append @ to the username
        cell.userUsername.text = "@" + String(user["screen_name"] as? String ?? "username")
        cell.userTweet.text = tweets[indexPath.row]["text"] as? String
        
        // Get a bigger version of the profile image
        let imageURLString = user["profile_image_url_https"] as? String
        let bigImage = imageURLString?.replacingOccurrences(of: #"_normal"#, with: "_200x200")
        
        let userProfileURL = URL(string: bigImage!)
        let data = try? Data(contentsOf: userProfileURL!)
        
        if let imageData = data {
            cell.userProfilePicture.image = UIImage(data: imageData)
        }
        
        // Format tweet creation date as time ago
        
        let twitterDate = (tweets[indexPath.row]["created_at"] as? String)!
        
        let df = DateFormatter()
        df.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        let date = df.date(from: twitterDate)
        
        cell.timeCreated.text = date?.timeAgo()
        
        // Favorite / Retweet logic
        
        cell.tweetID = tweets[indexPath.row]["id"] as! Int
        
        cell.setRetweet(tweets[indexPath.row]["retweeted"] as! Bool)
        cell.rtCount = tweets[indexPath.row]["retweet_count"] as! Int
        cell.retweetCount.text = "\(cell.rtCount)"
        
        cell.setFavorite(tweets[indexPath.row]["favorited"] as! Bool)
        cell.favCount = tweets[indexPath.row]["favorite_count"] as! Int
        cell.favoriteCount.text = "\(cell.favCount)"
        
        return cell
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
