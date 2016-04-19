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

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    //MARK: - all properties
    //MARK: -
    let recordData = RecordData()

    
    @IBOutlet weak var titleTopBoundHeight: NSLayoutConstraint!
    @IBOutlet weak var pswTitleTpoUserName: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let checkURL = "http://msghub.eycia.me:4001/Score"

    var courseDataSourse: [NSDictionary] = []
    var studenInfoData: NSDictionary!
    
    var getDataOK: Bool = false
    
    var dataSource: [String] = []
    var resultData: [String] = []
    
    var showList: Bool = false
    
    //MARK: - override fun
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUI()
        getRecordData()
        
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
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.userName.text = cell?.textLabel?.text
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        showList = false
        self.tableView.hidden = !showList
        self.pswTitleTpoUserName.constant = 8.0
    }
    
    //tableview datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = resultData[indexPath.row]
//        cell.textLabel?.font.fontWithSize(11.0)
        print(resultData[indexPath.row])
        return cell
    }

    
    //MARK: - my fun
    //MARK: -
    
    func didChange(textField: UITextField){
        //TODO
        resultData = []
        let currentStr = userName.text!
        print(currentStr)
        if currentStr.isEmpty{
            showList = false
            self.tableView.hidden = !showList
            pswTitleTpoUserName.constant = 8.0
        }else{
            let myMatch = UserNameMatch(array: dataSource, string: currentStr)
            resultData = myMatch.sl_matchlist()
            
            if resultData.count > 0{
                showList = true
                if resultData.count <= 5{
                    tableViewHeight.constant = CGFloat(resultData.count) * tableViewCellHeight
                    pswTitleTpoUserName.constant = 8.0 + tableViewHeight.constant
                    
                }else{
                    tableViewHeight.constant = 120.0
                }
                
            }else{
                showList = false
            }
        }
        if showList{
            print(resultData)
            self.tableView.reloadData()
            self.tableView.hidden = !showList

        }
    }
    
    //get data from .plist
    func getRecordData(){
        recordData.dataRead()
        dataSource = recordData.toReadArray
    }
    
    func loadUI(){
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.hidden = !showList
        self.pswTitleTpoUserName.constant = 8.0
        
        self.userName.addTarget(self, action: #selector(ViewController.didChange(_:)), forControlEvents: .EditingChanged)
    }
    
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
                NSLog("bb")
                print(self.dataSource)
                //TODO: add username to data
                //FIXME: put it to asyn
                if self.dataSource.count == 0{
                    self.dataSource.append(account)
                    let limMutableArray = NSMutableArray(array: self.dataSource)
                    self.recordData.toWriteArray = limMutableArray
                    self.recordData.dataWrite()
                }else{
                    var hasSave = false
                    for str in self.dataSource{
                        print(str)
                        print(account)
                        if account == str{
                            hasSave = true
                        }
                    }
                    if !hasSave{
                        self.dataSource.append(account)
                        let limMutableArray = NSMutableArray(array: self.dataSource)
                        self.recordData.toWriteArray = limMutableArray
                        self.recordData.dataWrite()
                    }

                }
                
                
                self.getDataOK = true
                let lim_data = operation!["data"] as! NSDictionary
                self.courseDataSourse = lim_data["info"] as! [NSDictionary]
                self.studenInfoData = lim_data["school_roll_info"] as! NSDictionary
                
                SVProgressHUD.showSuccessWithStatus("登录成功")
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

let slidLenght: CGFloat = 100.0
let tableViewCellHeight: CGFloat = 25.0
