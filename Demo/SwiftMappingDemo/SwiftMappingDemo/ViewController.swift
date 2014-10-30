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

        let serializer = ModelSerializer(modelClass: SubBaseModel.self, path: "data")
        let json = ["data": ["id": 12, "name": "A"]]
        let response: AnyObject! = serializer.serialize(json)
        let subObject: SubBaseModel =  response.valueForKeyPath("data")! as SubBaseModel
        println(subObject.id)
        println(subObject.name)
        
        let peopleJson = ["name": "Andy", "identity": 1.11, "kids":[
            ["name": "Big", "isMale": false],
            ["name": "Small", "isMale": false]
            ]
        ]
        let childSerializer = ModelSerializer(modelClass: Child.self, path: "kids")
        let childResponse: AnyObject! = childSerializer.serialize(peopleJson)
        let childs: [Child] = childResponse.valueForKeyPath("kids")! as [Child]
        println(childs[0].name)
        println(childs[1].name)
        
        let peopleSerializer = ModelSerializer(modelClass: People.self, path: "")
        let peopleResponse: AnyObject! = peopleSerializer.serialize(peopleJson)
        let people: People = peopleResponse.valueForKeyPath("")! as People
        println(people.name)
        println(people.identity)
        println(people.kids.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

