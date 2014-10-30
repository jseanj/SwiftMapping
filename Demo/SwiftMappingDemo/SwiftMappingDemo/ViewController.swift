//
//  ViewController.swift
//  SwiftMappingDemo
//
//  Created by jins on 14/10/29.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let testModel = BaseModel(jsonData: ["propertyNSString": "test"])
        println(testModel.toDictionary())
        let mainBundle = NSBundle.mainBundle()
        let info =  mainBundle.infoDictionary as NSDictionary?
        let appName = info!.objectForKey("CFBundleName") as NSString
        println(appName)
        println(testModel.propertyNSString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

