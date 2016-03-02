//
//  TableViewController.swift
//  SlackWebHook
//
//  Created by nonylene on 3/2/16.
//  Copyright © 2016 nonylene. All rights reserved.
//
import MBProgressHUD
import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var textTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var iconTextField: UITextField!
    @IBOutlet weak var webHookTextField: UITextField!

    struct Key {
        static let textKey = "text"
        static let userKey = "user"
        static let iconKey = "icon"
        static let webHookKey = "webhook"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults = NSUserDefaults.standardUserDefaults()
        textTextField.text = userDefaults.stringForKey(Key.textKey)
        userTextField.text = userDefaults.stringForKey(Key.userKey)
        iconTextField.text = userDefaults.stringForKey(Key.iconKey)
        webHookTextField.text = userDefaults.stringForKey(Key.webHookKey)
    }

    @IBAction func sendMessage(sender: UIBarButtonItem) {
        // set the request-body(JSON)
        let text = textTextField.text ?? ""
        let icon = iconTextField.text ?? ""
        let username =  userTextField.text ?? ""
        let url = webHookTextField.text ?? ""

        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(text, forKey: Key.textKey)
        userDefaults.setObject(username, forKey: Key.userKey)
        userDefaults.setObject(icon, forKey: Key.iconKey)
        userDefaults.setObject(url, forKey: Key.webHookKey)

        let params: [String: String] = [
            "text": text,
            "icon_emoji": icon,
            "username": username
        ]

        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let progress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progress.mode = MBProgressHUDMode.Indeterminate
        progress.labelText = "Sending"

        try! request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:  {data, response, error in
            // main thread
            dispatch_async(dispatch_get_main_queue(), {
                var errorMessage: String?
                if let error = error {
                    errorMessage = error.localizedDescription
                } else if (response as! NSHTTPURLResponse).statusCode / 100 != 2 {
                    errorMessage = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                }
                if let message = errorMessage {
                    progress.hide(true)
                    let alert = UIAlertController(title: "Message not send", message: message, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    progress.customView = UIImageView(image: UIImage(named: "CheckMark"))
                    progress.mode = .CustomView
                    progress.labelText = "Message send"
                    progress.hide(true, afterDelay: 1)
                }
            })
        }).resume()
    }
}
