//
//  SSCommentPublicData.swift
//  Northern Beauty
//
//  Created by Serx on 16/4/10.
//  Copyright © 2016年 serxlee. All rights reserved.
//

import Foundation

public var dictData: NSDictionary = NSDictionary.loadJSONFromBundle()!
public var digged: [Bool] = []

public class limTest{
    let datasource = dictData["data"] as! [NSDictionary]
    public var digged: [Bool] = []
    func get(){
        
        for inde in datasource{
            digged.append(inde["digged"] as! Bool)
        }
//        print(digged)
    }
}