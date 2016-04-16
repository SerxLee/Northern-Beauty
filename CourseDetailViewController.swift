//
//  CourseDetailViewController.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/10.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

var dict: NSDictionary?


class CourseDetailViewController: UIViewController {

    
    @IBOutlet weak var courseNum: UILabel!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseID: UILabel!
    @IBOutlet weak var courseCredit: UILabel!
    @IBOutlet weak var courseAttribute: UILabel!
    @IBOutlet weak var courseScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillTheInfomation()
    }
    
    func fillTheInfomation(){
        
        courseNum.text = dict!["id"] as? String
        courseName.text = dict!["name"] as? String
        courseID.text = dict!["no"] as? String
        courseCredit.text = dict!["credit"] as? String
        courseAttribute.text = dict!["type"] as? String
        courseScore.text = dict!["score"] as? String
    }
    
    @IBAction func backAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ToCommentController"{
            let nextViewController = segue.destinationViewController as! SSCourseCommentTableView
            nextViewController.courseName = (dict!["id"] as? String)!
            nextViewController.navigationItem.title = dict!["name"] as? String
        }
    }
    @IBAction func commentButton(sender: AnyObject) {
        
        
    }
}
