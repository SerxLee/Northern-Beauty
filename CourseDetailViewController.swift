//
//  CourseDetailViewController.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/10.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import UIKit

var dict: NSDictionary!


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
        
        courseNum.text = dict["course_id"] as? String
        courseName.text = dict["course_name"] as? String
        courseID.text = dict["course_no"] as? String
        courseCredit.text = dict["credit"] as? String
        courseAttribute.text = dict["course_attribute"] as? String
        courseScore.text = dict["socre"] as? String
    }
    
    @IBAction func backAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ToCommentController"{
            let nextViewController = segue.destinationViewController as! SSCourseCommentTableView
            nextViewController.navigationController?.title = dict["course_name"] as? String
        }
    }
}
