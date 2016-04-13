//
//  ViewController.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/6.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD

class ViewController: UIViewController, UITextFieldDelegate{

    //MARK: - all properties
    //MARK: -
    
    let checkURL = "http://msghub.eycia.me:4001/Score"
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var courseDataSourse: [NSDictionary] = []
    var studenInfoData: NSDictionary!
    
    var getDataOK: Bool = false
    
    //MARK: - override fun
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        passWord.delegate = self
        
        userName.returnKeyType = .Next
        passWord.returnKeyType = .Go
        userName.clearButtonMode=UITextFieldViewMode.WhileEditing
        passWord.clearButtonMode=UITextFieldViewMode.WhileEditing
        
        loginButton.layer.cornerRadius = 5.0
            
        ViewController.progressInit()
        ViewController.initAllPublicCache()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    //MARK: Inti all the cache
    static func initAllPublicCache(){
        cacheSemester.removeAllObjects()
        cacheCourseData.removeAllObjects()
        cacheSemesterNum.removeAllObjects()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "goToMainView"{
            let account = userName.text
            let password = passWord.text
            
            if account == "" || password == "" || getDataOK == false{
                //                var errorMessage:String?
                //                if account == "" && password != ""{
                //                    errorMessage = "请输入学号"
                //                }else if account != "" && password == ""{
                //                    errorMessage = "请输入密码"
                //                }else{
                //                    errorMessage = "请输入学号和密码"
                //                }
                //                let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .Alert)
                //                let okAction = UIAlertAction(title: "确定", style: .Default, handler: { (nil) in
                //                    self.userName.isFirstResponder()
                //                })
                //                alert.addAction(okAction)
                
                //                if getDataOK == false && account != "" && password != ""{
                //                    //FIXME: add the login info
                //
                //                }else{
                //                    self.presentViewController(alert, animated: true, completion: nil)
                //                }
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == userName {
            self.userName.resignFirstResponder()
            self.passWord.becomeFirstResponder()
        }else if textField ==  passWord{
            self.passWord.resignFirstResponder()
            checkLoginInformation()
        }
        
        return true
    }


    
    //MARK: - my fun
    //MARK: -
    
    
    @IBAction func LoginAction(sender: UIButton) {
        checkLoginInformation()
    }
    
    func checkLoginInformation(){

        let account: String = userName.text!
        let password: String = passWord.text!
        let myParameters: Dictionary = ["username":account, "password": password, "type": "passing"]
        SVProgressHUD.show()
        
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
                
//                print(self.studenInfoData)
                SVProgressHUD.showSuccessWithStatus("登录成功")
                
//                SVProgressHUD.dismiss()
                self.performSegueWithIdentifier("goToMainView", sender: nil)
                
            }else{
                print(operation!["reason"])
                var message = operation!["reason"] as! String
                if message == "Post http://60.219.165.24/loginAction.do: net/http: request canceled (Client.Timeout exceeded while awaiting headers)"{
                    message = "^ ^...Timeout, try again"
                }
                SVProgressHUD.showErrorWithStatus(message)

            }
        }) {  (dataTask, error) -> Void in
            print(error.localizedDescription)
        }
    }
    
    static func progressInit(){
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.setFont(UIFont(name: "AmericanTypewriter", size: 12.0))
        SVProgressHUD.setMinimumDismissTimeInterval(3.0)


    }
    
    
    
    }

