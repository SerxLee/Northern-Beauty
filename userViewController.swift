//
//  userViewController.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/11.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit


class userViewController: UITableViewController, UIAlertViewDelegate{
   
    
    //MARK: - ------All Properties------
    //MARK: -


    var xuefen: Float = 0
    var xuefenXuan: Float = 0
    var xuefenMust: Float = 0
    var xuefenNet: Float = 0

    var isExit: Bool = false
    
    @IBOutlet weak var stdName: UILabel!
    @IBOutlet weak var sumOfCredit: UILabel!
    @IBOutlet weak var stdClass: UILabel!
    @IBOutlet weak var stdNumber: UILabel!
    
    @IBOutlet weak var sumOfMust: UILabel!
    @IBOutlet weak var sumOfChoose: UILabel!
    @IBOutlet weak var sumOfNet: UILabel!
    



    //MARK: - ------Apple Inc.Func------
    //MARK: -

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.scrollEnabled = false
        tableView.allowsSelection = false
        getNameAndID()
        getSumOfScore()
        self.tableView.tableFooterView = UIView.init()
        
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if identifier == "exitSegue"{
            if isExit == false{
                return false
            }
        }
        return true
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if section == 2{
            return 0
        }
        return 40.0
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == alertView.firstOtherButtonIndex{

            //确认退出
            self.isExit = true
            self.shouldPerformSegueWithIdentifier("exitSegue", sender: nil)
            self.performSegueWithIdentifier("exitSegue", sender: nil)
        }
        if buttonIndex == alertView.cancelButtonIndex{
            
            //取消退出
            self.isExit = false
            self.shouldPerformSegueWithIdentifier("exitSegue", sender: nil)
        }
    }
    
    
    //MARK: - ------Individual Func------
    //MARK: -

    
    
    /*
    @IBAction func lookOrChangeButton(sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "更改头像", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let lookBigPicture = UIAlertAction(title: "拍照", style: .Default) { (nil) in
            
            //TODO: chang the userImage

        }
        let changePicture = UIAlertAction(title: "从相册获取", style: .Default) { (nil) in
            
            //TODO: chang the userImage

        }
        actionSheet.addAction(lookBigPicture)
        actionSheet.addAction(changePicture)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    */
    
    @IBAction func exit(sender: UIButton) {
        
        if #available(iOS 8.0, *) {
            let alertExit = UIAlertController(title: nil, message: "确认注销登录？", preferredStyle: .Alert)
            let cancleAction = UIAlertAction(title: "取消", style: .Cancel) { (nil) in
                
                //取消退出
                self.isExit = false
                self.shouldPerformSegueWithIdentifier("exitSegue", sender: nil)
            }
            let okAction = UIAlertAction(title: "确认", style: .Default) { (nil) in
                
                //确认退出
                self.isExit = true
                self.shouldPerformSegueWithIdentifier("exitSegue", sender: nil)
                self.performSegueWithIdentifier("exitSegue", sender: nil)
            }
            alertExit.addAction(cancleAction)
            alertExit.addAction(okAction)
            self.presentViewController(alertExit, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let alertExit = UIAlertView(title: "", message: "确认注销登录？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确认")
            alertExit.show()
        }
        
    }

    func getNameAndID(){
        let studentName = studenInfo["name"] as! String
        let studentId = studenInfo["stu_id"] as! String
        let studentClass = studenInfo["class"] as! String
        
        self.stdName.text = studentName
        self.stdClass.text = studentClass + "班"
        self.stdNumber.text = studentId
    }
    
    func getSumOfScore(){
        let allsemester = cacheSemester["passing"] as! [String]
        let courseData = cacheCourseData["passing"] as! NSMutableDictionary

        if !allsemester.isEmpty{
            for str in allsemester{
                let limDic: [Dictionary<String, AnyObject>] = courseData[str] as! [Dictionary<String, AnyObject>]
                for dic in limDic{
                    let score: String = dic["score"] as! String
                    let scoreFloat: Float = Float(score)!
                    if scoreFloat >= 60{
                        let credit = dic["credit"] as! String
                        let creditFloat: Float = Float(credit)!
                        xuefen += creditFloat
                        let attribute = dic["type"] as! String
                        if attribute == "必修"{
                            xuefenMust += creditFloat
                        }else if attribute == "选修"{
                            xuefenXuan += creditFloat
                        }else{
                            xuefenNet += creditFloat
                        }
                    }
                }
            }
        }
        sumOfCredit.text = String(xuefen)
        sumOfMust.text = String(xuefenMust)
        sumOfChoose.text = String(xuefenXuan)
        sumOfNet.text = String(xuefenNet)
    }

}
