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
var cacheCourseData = NSMutableDictionary()
var cacheSemester = NSMutableDictionary()
var cacheSemesterNum = NSMutableDictionary()

var allCourse : [NSDictionary] = []
var studenInfo: NSDictionary!

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var urlString: String =  "http://msghub.eycia.me:4001/Score"
    var userName: String!
    var passWord: String!
    var type: String = "passing"
    var selectedTitle: String!
    
    var sectionTitle: String!

    var courseDataSourse : [Dictionary<String, String>] = []
    var threeName: NSMutableDictionary!
    var DataSourse : NSMutableDictionary!

    
    override func viewDidLoad() {
        getDataWithAllCourse()
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView.init()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func segmentChangeAction(sender: UISegmentedControl) {
        courseDataSourse = []
        allSemesters = []
        //FIXME: change the path of the data of course
        let title = self.segment.titleForSegmentAtIndex(self.segment.selectedSegmentIndex)
        getType(title!)
        if cacheCourseData[type] == nil || cacheSemesterNum[type] == nil || cacheSemester[type] == nil{
            connetURL()
            segment.enabled = false
        }else{
            allSemesters = cacheSemester[type] as! [String]
            semestersNum = cacheSemesterNum[type] as! Int
            DataSourse = cacheCourseData[type] as! NSMutableDictionary
            self.tableView.reloadData()
        }
    }
    
    func connetURL(){
        let eyciaURL = "http://msghub.eycia.me:4001/Score?username=\(userName)&password=\(passWord)&type=\(type)"

        session.POST(eyciaURL, parameters: nil, success: { (dataTask, response) in
            
//            print(response)
            let error = response!["err"] as! Int
            if error == 0{
                let lim_data = response!["data"] as! NSDictionary
                allCourse = lim_data["info"] as! [NSDictionary]
                self.semestersNum = allCourse.count
                
                let limm = NSMutableDictionary()
                for dic in allCourse{
                    let dicType = dic["block_name"] as! String
                    self.allSemesters.append(dicType)
                    let lim = dic["courses"] as! [NSDictionary]
                    
                    limm.addEntriesFromDictionary([dicType : lim])
                }
                self.DataSourse = limm
                cacheSemester.addEntriesFromDictionary([self.type : self.allSemesters])
                cacheSemesterNum.addEntriesFromDictionary([self.type : self.semestersNum])
                cacheCourseData.addEntriesFromDictionary([self.type : limm])
                self.tableView.reloadData()
                self.segment.enabled = true
            }
        })
        {  (dataTask, error) -> Void in
            print(error.localizedDescription)
            self.segment.enabled = true
        }

    }
    
    //FIXME: get the information according segmentString
    private func getType(segmentString: String){
        if segmentString == "最近一学期成绩"{
            type = "semester"
        }else if segmentString == "全部及格成绩"{
            type = "passing"
        }else if segmentString == "不及格成绩"{
            type = "fail"
        }
    }
    
    var semestersNum: Int = 0
    var allSemesters =  [String]()
    
    //before load the view
    func getDataWithAllCourse(){
//        var fen: Int = 0
        self.semestersNum = allCourse.count
        let limm = NSMutableDictionary()
        for dic in allCourse{
            let dicType = dic["block_name"] as! String
            self.allSemesters.append(dicType)
            let lim = dic["courses"] as! [NSDictionary]
//            
//            for course in lim{
//                let aa = course["score"] as! Int
//                if aa >= 60{
//                    fen = fen + (course["credit"] as! Int)
//                }
//            }
            
            limm.addEntriesFromDictionary([dicType : lim])
        }
//        xuefen = fen
        DataSourse = limm
        cacheSemester.addEntriesFromDictionary([self.type : self.allSemesters])
        cacheSemesterNum.addEntriesFromDictionary([self.type : self.semestersNum])
        cacheCourseData.addEntriesFromDictionary([self.type : limm])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //MARK: - tableview delegate and datasourse
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSourse[allSemesters[section]]!.count

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.semestersNum
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return allSemesters[section]

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "MainTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MainViewControllerTableViewCell

        let row = indexPath.row
        let indexOfSection = indexPath.section
        var stringOfSection: String!
        
        stringOfSection = allSemesters[indexOfSection]
        courseDataSourse = cacheCourseData[type]![stringOfSection]! as! [Dictionary<String, String>]

        cell!.CourseNum.text = courseDataSourse[row]["id"]! as String
        cell!.CourseScore.text = courseDataSourse[row]["score"]! as String
        cell!.CourseName.text = courseDataSourse[row]["name"]! as String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let indexOfSection = indexPath.section
        var stringOfSection: String!
        stringOfSection = allSemesters[indexOfSection]

        dict = cacheCourseData[type]![stringOfSection]!![row] as! NSDictionary
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