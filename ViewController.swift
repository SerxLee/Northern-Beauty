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
   
    //MARK: - ------All Properties------
    //MARK: -

    let myQueue: dispatch_queue_t = dispatch_queue_create("com.serxlee.updata", DISPATCH_QUEUE_CONCURRENT)
    
    
    let recordData = RecordData()
    
    @IBOutlet weak var titleTopBoundHeight: NSLayoutConstraint!
    @IBOutlet weak var pswTitleTpoUserName: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let checkURL = "https://usth.eycia.me/Score"

    var courseDataSourse: [NSDictionary] = []
    var studenInfoData: NSDictionary!
    
    var getDataOK: Bool = false
    
    var dataSource: [String] = []
    var resultData: [String] = []
    
    var showList: Bool = false
    
    var tapGesture = UITapGestureRecognizer()

    

    //MARK: - ------Apple Inc.Func------
    //MARK: -
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadUI()
        getRecordData()
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Inti all the 'Public' data of cache
    static func initAllPublicCache(){
        cacheSemester.removeAllObjects()
        cacheCourseData.removeAllObjects()
        cacheSemesterNum.removeAllObjects()
    }
    
    
    /*
       if the textField is nil, the segue didn't work~
     
            identifier: the identifier of segue
    */
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
    
    
    /*
        1. prepareForSegue. before segue the view to the All score view,

        2. I gave the value of userName and passWord for the MainView's userName and password properties

        3. put the score data for the 'Public' property 'allCourse'

        4. put student's information to the 'Public' properties 'studenInfo'
    */
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
    
    /*
        1. set the keyBoard's return key
            
            the userName textField is dif to the passWord textField
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == userName {
            self.userName.resignFirstResponder()
            self.passWord.becomeFirstResponder()
            
            showList = false
            //auto
            
            pswTitleTpoUserName.constant = 8.0
            
            self.tableView.hidden = !showList
        }else if textField ==  passWord{
            UIView.animateWithDuration(1.0, animations: { 
                self.titleTopBoundHeight.constant = noSlideLengh
                self.passWord.resignFirstResponder()
            })
            
            checkLoginInformation()
        }
        return true
    }
    
    
    /*
      1. while enter the textField editing,
        you move all UI implement up Slidlenght
    */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        UIView.animateWithDuration(1.0) {
            self.titleTopBoundHeight.constant = slidLenght
        }
        return true
    }
    
    
    //MARK: tableview datasource and delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DataTableViewCell
        self.userName.text = cell.UserName.text!
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        showList = false
        self.tableView.hidden = !showList
        self.pswTitleTpoUserName.constant = 8.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "myCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! DataTableViewCell
        cell.UserName.text = resultData[indexPath.row]
        return cell
    }

    
    
    
    
    //MARK: - ------Individual Func------
    //MARK: -

    
    

    
    /*
        oberver the userName TextField, if the text change ,
        the target will tigger the 'didChange' method
    */
    func didChange(textField: UITextField){
        //TODO
        resultData = []
        let currentStr = userName.text!
        if currentStr.isEmpty{
            showList = false
            self.tableView.hidden = !showList
            pswTitleTpoUserName.constant = 8.0
        }else{
            
            /*
                match the storage userName data,
                resultData is the matched data
            */
            let myMatch = UserNameMatch(array: dataSource, string: currentStr)
            resultData = myMatch.sl_matchlist()
            if resultData.count > 0{
                
                //auto fix
                showList = true
                if resultData.count <= 5{
                    tableViewHeight.constant = CGFloat(resultData.count) * tableViewCellHeight
                    pswTitleTpoUserName.constant = 8.0 + tableViewHeight.constant
                }else{
                    tableViewHeight.constant = 120.0
                    pswTitleTpoUserName.constant = 8.0 + tableViewHeight.constant
                }
            }else{
                showList = false
                self.tableView.hidden = !showList
                pswTitleTpoUserName.constant = 8.0
            }
        }
        if showList{
            self.tableView.reloadData()
            self.tableView.hidden = !showList

        }
    }
    
    func getRecordData(){
        recordData.dataRead()
        dataSource = recordData.toReadArray
    }
    
    func didEndEditing(textFile: UITextField){
        showList = false
        self.tableView.hidden = !showList
        pswTitleTpoUserName.constant = 8.0
    }
    
    
    /*
        while tap the view,
            hide the keyBoard
     
        error: it view inferent to the match userName data tableview
                I have to change the mine, and finish in the next few days
    */
    /*
    func backToView(gestrue: UITapGestureRecognizer){
        
        if self.userName.isFirstResponder(){
            self.userName.resignFirstResponder()
            self.showList = false
            self.pswTitleTpoUserName.constant = 8.0
            self.titleTopBoundHeight.constant = noSlideLengh
        }
        if self.passWord.isFirstResponder(){
            self.passWord.resignFirstResponder()
            self.showList = false
            self.pswTitleTpoUserName.constant = 8.0
            self.titleTopBoundHeight.constant = noSlideLengh
        }
    }
     */
    
    
    
    /*  
        initalize the view's properties
    */
    func loadUI(){

        /*
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.backToView(_:)))
        self.view.addGestureRecognizer(tapGesture)
        */
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.hidden = !showList
        self.pswTitleTpoUserName.constant = 8.0
        
        //add the action to userName,
        self.userName.addTarget(self, action: #selector(ViewController.didChange(_:)), forControlEvents: .EditingChanged)
        self.userName.addTarget(self, action: #selector(ViewController.didEndEditing(_:)), forControlEvents: .EditingDidEnd)
        
        userName.delegate = self
        passWord.delegate = self
        
        userName.returnKeyType = .Next
        passWord.returnKeyType = .Go
        userName.clearButtonMode=UITextFieldViewMode.WhileEditing
        passWord.clearButtonMode=UITextFieldViewMode.WhileEditing
        
        loginButton.layer.cornerRadius = 5.0
        
        //
        ViewController.progressInit()
        //
        ViewController.initAllPublicCache()
        
        
        /*
            get the data from .plist file
            
            and then save them to the 'recordData' array
        */
        recordData.dataRead()
        dataSource = recordData.toReadArray
    }
    
    
    @IBAction func LoginAction(sender: UIButton) {
        /*
            while click the login button,
                hide the keyboard via 'textFieldShouldReturn' method
        */
        self.textFieldShouldReturn(userName)
        self.textFieldShouldReturn(passWord)
        
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
                
                        //FIXME: put it to asyn
                    if self.dataSource.count == 0{
                        self.dataSource.append(account)
                        let limMutableArray = NSMutableArray(array: self.dataSource)
                        self.recordData.toWriteArray = limMutableArray
                        self.recordData.dataWrite()
                    }else{
                        var hasSave = false
                        for str in self.dataSource{
    //                        print(account)
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
                
            }else if error == 1{
//                print(operation!["reason"])
                var message = operation!["reason"] as! String
//                if message == "Post http://60.219.165.24/loginAction.do: net/http: request canceled (Client.Timeout exceeded while awaiting headers)"{
//                    message = "^ ^...Timeout, try again"
//                }
//                SVProgressHUD.showErrorWithStatus(message)
                print(message)

            }
        }) {  (dataTask, error) -> Void in
            print(error.localizedDescription)
        }
    }
    
    static func progressInit(){
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.setFont(UIFont(name: "AmericanTypewriter", size: 12.0))
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)


    }
}

let slidLenght: CGFloat = 50.0
let noSlideLengh: CGFloat = 110.0
let tableViewCellHeight: CGFloat = 25.0
