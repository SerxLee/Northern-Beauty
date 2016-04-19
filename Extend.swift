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

