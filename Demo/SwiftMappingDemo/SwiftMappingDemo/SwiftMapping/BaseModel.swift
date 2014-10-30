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
    var propertyNSString: NSString = "prop One"
    var propertyNSDictionary: NSDictionary = ["a": 1, "b": 2]
    var propertyNSArray: NSArray = ["a", "b", "c"]
    var propertyArray = [1, 2, 3]
    var propertyDict = ["A":1, "B":2, "C":3]
    var propertyInt = 5
    var propertyString = "wwww"
    var propertyBool = true
    var propertyFloat = 0.5
    
    override init() {
        super.init()
    }
    
    init(jsonData : [ String : AnyObject ]) {
        super.init()
        setAttributes(jsonData)
//        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: getSetterAttributeName(""), userInfo: nil, repeats: false)
    }
    
    
    
    func setAttributes(jsonData : [ String: AnyObject ]) {
        let properties = toDictionary()
        for propName in properties.allKeys {
            // 取出属性名
            let name = propName as String
            let sel = getSetterAttributeName(name)
            if self.respondsToSelector(sel) {
                println(sel.description)
                var value: AnyObject? = jsonData[name]
                
                // 在json中取出此属性名所对应的值，根据这个值生成一个属性类型的对象
                if let jsonValue: AnyObject = value {
                    // 取出属性类型名
                    let type = properties[name] as String
                    println("\(type) + \(name)")
                    println(jsonValue)
                    
//                    let propClass = NSClassFromString(type) as NSObject.Type
//                    let propObject = propClass()
//                    NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: getSetterAttributeName(name), userInfo: nil, repeats: false)
                    self.setValue(jsonValue, forKey: name)
                    /*
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
                    */
                }
            }
        }
    }


    
    func getSetterAttributeName(attributeName: String) -> Selector{
        // http://swifter.tips/selector/
        // 生成setPropertyName，比如 setPropertyOne
        let firstIndex: String.Index = advance(attributeName.startIndex, 1)
        let capital = attributeName.substringToIndex(firstIndex).uppercaseString
        let rest = attributeName.substringFromIndex(firstIndex)
        let setterSelStr = String.localizedStringWithFormat("set%@%@:", capital, rest)
        return Selector(setterSelStr)
    }
    
    // http://stackoverflow.com/questions/24219179/how-do-i-serialise-nsdictionary-from-a-class-swift-implementation
    func toDictionary() -> NSDictionary {
        var aClass: AnyClass? = self.dynamicType
        var propertiesCount: CUnsignedInt = 0
        var propertiesInAClass: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        
        var propertiesDictionary: NSMutableDictionary = NSMutableDictionary()
        
        for i in 0..<Int(propertiesCount) {
            let property = propertiesInAClass[i]
            let propName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            let propType = NSString(CString: property_getAttributes(property), encoding: NSUTF8StringEncoding)!
            let propValue: AnyObject? = self.valueForKey(propName)
            
            let propTypeAttributes = propType.componentsSeparatedByString(",")
            let typeAttribute = propTypeAttributes[0] as String
            
            if typeAttribute.hasPrefix("TB") {
                propertiesDictionary.setValue("Bool", forKey: propName)
            }
            else if typeAttribute.hasPrefix("Td") {
                propertiesDictionary.setValue("Double", forKey: propName)
            }
            else if typeAttribute.hasPrefix("Tf") {
                propertiesDictionary.setValue("Float", forKey: propName)
            }
            else if typeAttribute.hasPrefix("Tl") {
                propertiesDictionary.setValue("Long", forKey: propName)
            }
            else if typeAttribute.hasPrefix("T@") {
                switch(propValue) {
                case let stringValue as String:
                    propertiesDictionary.setValue("NSString", forKey: propName)
                case let dateValue as NSDate:
                    propertiesDictionary.setValue("NSDate", forKey: propName)
                case let dataValue as NSData:
                    propertiesDictionary.setValue("NSData", forKey: propName)
                case let arrayValue as Array<AnyObject>:
                    propertiesDictionary.setValue("NSArray", forKey: propName)
                case let dictValue as Dictionary<String, AnyObject>:
                    propertiesDictionary.setValue("NSDictionary", forKey: propName)
                default:
                    propertiesDictionary.setValue("", forKey: propName)
                }
            }
            
            
//            propertiesDictionary.setObject(typeAttribute, forKey: propType)
//            propertiesDictionary.setValue(self.valueForKey(propName), forKey: propName!)
        }
        return propertiesDictionary
    }
}