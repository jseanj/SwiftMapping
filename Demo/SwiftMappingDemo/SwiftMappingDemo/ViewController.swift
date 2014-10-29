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
        let testModel = BaseModel().toDictionary()
        println(testModel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

