//
//  BaseModel.swift
//  SwiftMappingDemo
//
//  Created by jins on 14/10/29.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import Foundation

class BaseModel: NSObject {
    lazy private var __properties: [String: AnyObject] = {
        return self.getPropertiesFromClass(self.dynamicType)
    }()

    func properties() -> [String: AnyObject] {
        var properties: [String: AnyObject] = Dictionary()
        for (key, value) in self.__properties {
            if let value: AnyObject = self.valueForKey(key) {
                properties[key] = value
            } else {
                properties[key] = ""
            }
        }
        return properties
    }
    
    // MARK: NSCoding protocol
    
    func encodeWithCoder(aCoder: NSCoder!) {
        for (key, value) in self.properties() {
            aCoder.encodeObject(self.valueForKey(key), forKey: key)
        }
    }

    
    func hasProperty(propertyName: String) -> Bool {
        if let property: AnyObject = self.__properties[propertyName] {
            return true
        }
        return false
    }
    
    private func getPropertiesFromClass(className: AnyClass) -> [String: AnyObject] {
        var properties: [String: AnyObject] = Dictionary()

//        if className.superclass()?.isSubclassOfClass(BaseModel.self) {
//            properties += self.getPropertiesFromClass(className.superclass())
//        }
        properties.removeValueForKey("description")
        var outCount: CUnsignedInt = 0;
        var cProperties: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(className, &outCount)
        for counter in 0..<outCount {
            let property: objc_property_t = cProperties[Int(counter)]
            let propertyName = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            properties[propertyName] = NSString(CString: property_getAttributes(property), encoding: NSUTF8StringEncoding)!
        }
        return properties
    }
    
    
    func setAttributes(jsonData : [ String: AnyObject ]) {
        let mainBundle = NSBundle.mainBundle()
        let info =  mainBundle.infoDictionary as NSDictionary?
        let bundleName = info!.objectForKey("CFBundleName") as NSString
        
        for (key, value) in jsonData {
            autoreleasepool({
                if self.hasProperty(key) {
                    if let modelClass = NSClassFromString("\(bundleName).\(key)") as? NSObject.Type {
                        if value is [[String: AnyObject]] {
                            var models: [AnyObject] = Array()
                            for values in value as [[String: AnyObject]] {
                                let model: BaseModel = modelClass() as BaseModel
                                model.setAttributes(values as [String: AnyObject])
                                models.append(model)
                            }
                            self.setValue(models, forKey: key)
                        } else if value is [String: AnyObject] {
                            let model: BaseModel = modelClass() as BaseModel
                            model.setAttributes(value as [String: AnyObject])
                            self.setValue(model, forKey: key)
                        }

                    } else if !value.isKindOfClass(NSNull.self) {
                        self.setValue(value, forKey: key)
                    }
                }
            })
        }
    }
}