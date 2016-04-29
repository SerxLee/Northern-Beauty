//
//  SSReplyComment.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/10.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation
import UIKit

class SSReplyComment{
    
    var authorName: AnyObject = ""
    var stuId:AnyObject = ""
    var content: AnyObject = ""
    
    
    var RefedAuthorId: AnyObject = ""
    var refedAuthor: AnyObject = ""
    var refedContent: AnyObject = ""
    var refId: AnyObject = "0"
    
    var digg: AnyObject = 0
    var className: AnyObject = ""
    var time: AnyObject = 0
    var digged: AnyObject = false
    var id: AnyObject = "0"
    
    var getNewDict: NSDictionary!
    
    var errNumber = 0
    
    var isNew: Bool?
    var courseName: String?
    var commentText: String!
    var dict: NSDictionary?
    
    init(dict: NSDictionary?, comment: String, courseName: String, isNew: Bool){
        
        var urlComment = "https://usth.eycia.me/Reply/course/\(courseName)"
        self.authorName = studenInfo["name"]!
        self.stuId = studenInfo["stu_id"]!
        self.content = comment
        self.time = NSDate().timeIntervalSince1970
        
        if !isNew{
            self.RefedAuthorId = dict!["id"]!
            self.refedAuthor = dict!["authorName"]!
            self.refedContent = dict!["content"]!
            self.refId = dict!["id"]!
            self.className = dict!["className"]!
            urlComment = "https://usth.eycia.me/Reply/course/\(courseName)/\(refId)/reply"
        }
        
        let parameters: Dictionary<String, String> = ["content": content as! String]
        session.POST(urlComment, parameters: parameters, success: { (dataTask, response) in
            let errNum = response!["err"] as! Int
            self.errNumber = errNum
            if errNum == 1{
                let messageString = response!["reason"] as! String
                print(messageString)
            }else{
                self.id = response!["data"] as! String
            }
            }, failure: { (dataTask, error) in
                NSLog("find it is error")
                print(error.localizedDescription)
        })
        
        self.getNewDict = ["refedAuthor": refedAuthor, "content": content, "id": id, "time": time, "digged": digged, "authorName": authorName, "className": className, "refedContent": refedContent, "RefedAuthorId": RefedAuthorId, "digg": digg, "refId": refId, "stuId": stuId]
    }
}