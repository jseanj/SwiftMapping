//
//  SubBaseModel.swift
//  SwiftMappingDemo
//
//  Created by jin.shang on 14-10-31.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import Foundation

class SubBaseModel: BaseModel {
    var id: Int = 0
    var name: String = ""
}

class People: BaseModel {
    var name: String = ""
    var identity: Double = 0.00
    var kids = [Child]()
}

class Child: BaseModel {
    var name: String = ""
    var isMale: Bool = true
}