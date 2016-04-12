//
//  SSReplyComment.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/10.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation
import UIKit

class SSReplyComment: AnyObject{
    
    
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
    
    func getAddLim() -> NSDictionary{
        let getNewDict: NSDictionary = {
            let addLim = ["refedAuthor": refedAuthor, "content": content, "id": id, "time": time, "digged": digged, "authorName": authorName, "className": className, "refedContent": refedContent, "RefedAuthorId": RefedAuthorId, "digg": digg, "refId": refId, "stuId": stuId] as NSDictionary
            return addLim
        }()
        return getNewDict
    }
}