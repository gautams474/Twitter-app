//
//  ComposeViewController.swift
//  Twitter app
//
//  Created by Gautam Sadarangani on 3/4/16.
//  Copyright © 2016 Gautam Sadarangani. All rights reserved.
//

import UIKit



class ComposeViewController: UIViewController {


    @IBOutlet weak var textField: UITextView!

    var user : User?
    var tweet: Tweet?
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.updateStatusWithCompletion(self.textField.text) { (tweet, error) -> () in
            print(tweet)
            if tweet != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            if error != nil {
                print("error")
            }
        }
        navigationController?.popViewControllerAnimated(true)

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
