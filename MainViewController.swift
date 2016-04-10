//
//  MainViewController.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/6.
//  Copyright © 2016年 serxlee. All rights reserved.

//  username=2013025014&password=1&type=(semester/passing/fail)
//  http://usth.applinzi.com
//

import UIKit
import Foundation
import AFNetworking

public let session = AFHTTPSessionManager()

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var urlString: String =  "http://msghub.eycia.me:4001/Score"
    var userName: String!
    var passWord: String!
    var type: String!
    var selectedTitle: String!
    
    var sectionTitle: String!

    var dataSourse = [NSDictionary]()
    var yetFailDataSourse = [NSDictionary]()
    var allPassCourse = NSDictionary()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let title = self.segment.titleForSegmentAtIndex(self.segment.selectedSegmentIndex)
        getType(title!)
        connectAndSearch()
        
        //remove the blank space tableView Cell
        self.tableView.tableFooterView = UIView.init()

    }


    @IBAction func segmentChangeAction(sender: UISegmentedControl) {
        
        let title = self.segment.titleForSegmentAtIndex(self.segment.selectedSegmentIndex)
        getType(title!)
        
        dataSourse = []
        yetFailDataSourse = []
        tableView.reloadData()
        connectAndSearch()
    }
    
    private func getType(segmentString: String){
        if segmentString == "最近一学期成绩"{
            type = "semester"
        }else if segmentString == "全部及格成绩"{
            type = "passing"
        }else if segmentString == "不及格成绩"{
            type = "fail"
        }
    }
    
    var semesters: [String] = []
    
    func connectAndSearch(){
        
        let myParameters: Dictionary = ["username":userName, "password": passWord, "type": type]
        
        session.POST(urlString, parameters: myParameters, success: {  (dataTask, operation) -> Void in
            
            NSLog("GET seccess")
//            let dict =  operation?.cookies
            
            if operation != nil{
//                print(operation)

                let status:String = operation!["status"] as! String
                if status == "ok"{
                    if self.type == "passing"{
                        self.semesters = operation!["semeters"] as! [String]
                        self.allPassCourse = operation as! NSDictionary
                        
                    }else if self.type == "fail"{
                        self.dataSourse = operation!["ever_fail_grade"] as! [NSDictionary]
                        self.yetFailDataSourse = operation!["yet_fail_grade"] as! [NSDictionary]
                    }else{
                       self.dataSourse = operation!["this_semester_grade"] as! [NSDictionary]
                    }
                    self.tableView.reloadData()
                }
            }
            }) {  (dataTask, error) -> Void in
                print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == "semester"{
            return self.dataSourse.count
        }else if type == "fail"{
            if section == 0{
                return self.dataSourse.count
            }
            if section == 1{
                return self.yetFailDataSourse.count
            }
        }else{
            return self.allPassCourse[semesters[section]]!.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if type == "semester"{
            return 1
        }else if type == "fail"{
            return 2
        }else{
            return self.semesters.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var titleString: String = ""
        if type == "semester"{
            titleString = "最近一学期成绩"
        }else if type == "fail"{
            if section == 0{
                titleString = "曾经未通过"
            }else if section == 1{
                titleString = "还未通过"
            }
        }else{
            
            titleString = semesters[section] + "学期"
        }
        return titleString
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "MainTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MainViewControllerTableViewCell

        
        let row = indexPath.row
        let indexOfSection = indexPath.section
        var stringOfSection: String!
        
        if type == "passing"{
            stringOfSection = semesters[indexOfSection]
            dataSourse = allPassCourse[stringOfSection] as! [NSDictionary]
        }
        
        if type == "fail"{
            if indexOfSection == 1{
                cell!.CourseNum.text = yetFailDataSourse[row]["course_id"] as? String
                cell!.CourseScore.text = yetFailDataSourse[row]["socre"] as? String
                cell!.CourseName.text = yetFailDataSourse[row]["course_name"] as? String
                return cell!
            }
        }
        cell!.CourseNum.text = dataSourse[row]["course_id"] as? String
        cell!.CourseScore.text = dataSourse[row]["socre"] as? String
        cell!.CourseName.text = dataSourse[row]["course_name"] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dict = dataSourse[indexPath.row]
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