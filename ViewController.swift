//
//  ViewController.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/6.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {

    let checkURL = "http://msghub.eycia.me:4001/Score"
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    
    var courseDataSourse: [NSDictionary] = []
    var studenInfoData: NSDictionary!
    
    var getDataOK: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginAction(sender: UIButton) {
        checkLoginInformation()
    }
    
    func checkLoginInformation(){
        let account: String = userName.text!
        let password: String = passWord.text!
        let myParameters: Dictionary = ["username":account, "password": password, "type": "passing"]
        
        session.POST(checkURL, parameters: myParameters, success: {  (dataTask, operation) -> Void in
            
            let error = operation!["err"] as! Int
            if error == 0{
//                print(operation)
                self.getDataOK = true
                self.shouldPerformSegueWithIdentifier("goToMainView", sender: nil)
//                print(operation!["item"])
                
                let lim_data = operation!["data"] as! NSDictionary
                self.courseDataSourse = lim_data["info"] as! [NSDictionary]
                self.studenInfoData = lim_data["school_roll_info"] as! NSDictionary
                
                self.performSegueWithIdentifier("goToMainView", sender: nil)
                
            }else{
                print(operation!["reason"])
            }
        }) {  (dataTask, error) -> Void in
            print(error.localizedDescription)
        }
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "goToMainView"{
            let account = userName.text
            let password = passWord.text
            
            if account == "" || password == "" || getDataOK == false{
                var errorMessage:String?
                if account == "" && password != ""{
                    errorMessage = "请输入学号"
                }else if account != "" && password == ""{
                    errorMessage = "请输入密码"
                }else{
                    errorMessage = "请输入学号和密码"
                }
                let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: { (nil) in
                    self.userName.isFirstResponder()
                })
                alert.addAction(okAction)

                if getDataOK == false && account != "" && password != ""{
                    //FIXME: add the login info
                    
                }else{
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToMainView"{
            
            let tabBar = segue.destinationViewController as! UITabBarController
            
            let nextViewController = tabBar.viewControllers![0] as! MainViewController
            nextViewController.userName = self.userName.text
            nextViewController.passWord = self.passWord.text
            allCourse = self.courseDataSourse
            studenInfo = self.studenInfoData
        }
    }

}

