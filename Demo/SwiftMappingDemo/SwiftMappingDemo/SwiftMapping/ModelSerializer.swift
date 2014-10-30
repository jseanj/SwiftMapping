//
//  ModelSerializer.swift
//  SwiftMappingDemo
//
//  Created by jin.shang on 14-10-31.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import Foundation

class ModelSerializer {
    var className: NSObject.Type
    var path: String
    
    init(modelClass className: NSObject.Type, path modelsPath: String) {
        self.className = className
        self.path = modelsPath
    }
    
    func serialize(jsonDictionary: NSDictionary) -> AnyObject? {
        var response: NSMutableDictionary = CFPropertyListCreateDeepCopy(kCFAllocatorDefault, self.removeNullValues(jsonDictionary), 1) as NSMutableDictionary
        var values: AnyObject!
        if self.path == "" {
            values = jsonDictionary
        } else {
            values = jsonDictionary.valueForKeyPath(self.path)
        }
        if values is Array<NSDictionary> {
            var models: Array<BaseModel> = Array<BaseModel>()
            for value in values as [NSDictionary] {
                var model = self.className() as BaseModel
                model.setAttributes(value as [String: AnyObject])
                models.append(model)
            }
            response.setValue(models, forKeyPath: self.path)
        } else if values is Dictionary<String, AnyObject> {
            var model = self.className() as BaseModel
            model.setAttributes(values as [String: AnyObject])
            response.setValue(model, forKeyPath: self.path)
        }
        return response
    }
    
    func removeNullValues(JSONObject: AnyObject) -> AnyObject {
        if JSONObject.isKindOfClass(NSArray.self) {
            let mutableArray = NSMutableArray(capacity: (JSONObject as NSArray).count)
            for value in (JSONObject as NSArray) {
                mutableArray.addObject(self.removeNullValues(value))
            }
            return mutableArray.copy() as NSArray
        } else if JSONObject.isKindOfClass(NSDictionary.self) {
            let mutableDictionary = (JSONObject as NSDictionary).mutableCopy() as NSMutableDictionary
            for (key, value) in (JSONObject as NSDictionary) {
                if value.isKindOfClass(NSNull.self) {
                    mutableDictionary.removeObjectForKey(key)
                } else if value.isKindOfClass(NSArray.self) || value.isKindOfClass(NSDictionary.self) {
                    mutableDictionary.setObject(self.removeNullValues(value), forKey: (key as String))
                }
            }
            return mutableDictionary.copy() as NSDictionary
        }
        return JSONObject
    }
}