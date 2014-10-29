//
//  BaseModel.swift
//  SwiftMappingDemo
//
//  Created by jins on 14/10/29.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import Foundation
// http://liming.me/2014/01/16/dynamic-object-mapping-for-json/
class BaseModel: NSObject {
    var propertyOne: NSString = "prop One"
    var propertyTwo = [1, 2, 3]
    var propertyThree = ["A":1, "B":2, "C":3]
    var propertyFour = 5
    
    override init() {
        super.init()
    }
    
    init(jsonData : [ String : AnyObject? ]) {
        super.init()
        setAttributes(jsonData)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: getSetterAttributeName(""), userInfo: nil, repeats: false)
    }
    
    func setAttributes(jsonData : [ String: AnyObject? ]) {
        let propertys = toDictionary()
        for attributeName in propertys.allKeys {
            let name = attributeName as String
            let sel = getSetterAttributeName(name)
            if self.respondsToSelector(sel) {
                var value = jsonData[name]
                if let jsonValue = value {
                    let type = propertys[name]
                    
                    if jsonValue is NSDictionary {
//                        var subObject = NSClassFromString(type)
                        // 在子类别上执行set方法
                        continue
                    }
                    if jsonValue is NSArray {
                        if type == "NSString" || type == "NSNumber" {
                            // 在jsonvalue上执行set方法
                            continue
                        }
                        var dataArray = NSMutableArray()
                        for dataItem in jsonValue as NSArray {
//                          var subObject = NSClassFromString(type)
                            var subObject = ""
                            dataArray.addObject(subObject)
                        }
                        // 用数组来设置值
                    }
                    // 在jsonvalue上执行set方法
                }
            }
        }
    }
    
    func getSetterAttributeName(attributeName: String) -> Selector{
        // http://swifter.tips/selector/
        // 生成setPropertyName，比如 setPropertyOne
        let capital = attributeName.substringToIndex("".endIndex).uppercaseString
        let setterSelStr = String.localizedStringWithFormat("set%@%@", capital, capital)
        return Selector("setPropertyOne:")
    }
    
    // http://stackoverflow.com/questions/24219179/how-do-i-serialise-nsdictionary-from-a-class-swift-implementation
    func toDictionary() -> NSDictionary {
        var aClass: AnyClass? = self.dynamicType
        var propertiesCount: CUnsignedInt = 0
        var propertiesInAClass: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        
        var propertiesDictionary: NSMutableDictionary = NSMutableDictionary()
        
        for var i = 0; i < Int(propertiesCount); i++ {
            var propName: NSString? = NSString(CString: property_getName(propertiesInAClass[i]), encoding: NSUTF8StringEncoding)
            var propTypeName: NSString? = NSString(CString: property_getAttributes(propertiesInAClass[i]), encoding: NSUTF8StringEncoding)
            propertiesDictionary.setObject(propTypeName!, forKey: propName!)
//            propertiesDictionary.setValue(self.valueForKey(propName!), forKey: propName!)
        }
        return propertiesDictionary
    }
}