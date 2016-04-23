//
//  Extend.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/19.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation

enum CommentError{
    case NoData, ParsingError
}

enum Result{
    case Success(NSData)
    case Failure(ErrorType)
}

extension NSDictionary{
    static func loadJSONFromBundle() -> NSDictionary? {
        if let path = NSBundle.mainBundle().pathForResource("-1", ofType: "json") {
            let data: NSData?
            do{
                data = try! NSData(contentsOfFile: path, options: NSDataReadingOptions())
            }
            if let data = data {
                do{
                    let dictionary: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                    if let dictionary = dictionary as? NSDictionary {
                        return dictionary
                    } else {
                        print("not valid JSON: (error!)")
                        return nil
                    }
                }catch let error{
                    print(error)
                }
            } else {
                print("Could not load file: (filename), error: (error!)")
                return nil
            }
        } else {
            print("Could not find file: (filename)")
            return nil
        }
        return nil
    }
}
