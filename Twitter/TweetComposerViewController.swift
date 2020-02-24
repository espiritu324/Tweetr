

import UIKit

class TweetComposerViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetTextView.becomeFirstResponder()
        tweetTextView.placeholder = "What's happening?"
    }
    
    @IBAction func cancelTweet(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postTweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetText: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error: Could not post tweet. \(error)")
            })
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
