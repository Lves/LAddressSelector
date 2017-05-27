//
//  Province.swift
//  AddressSelection
//
//  Created by lixingle on 2017/5/17.
//  Copyright © 2017年 com.lvesli. All rights reserved.
//

import UIKit
import MJExtension
class City: NSObject {
    var city:String?    //市
    var areas:[String]? //区
}

class Province: NSObject {
    var state:String?   //省
    var cities:[City]?
    override static func mj_objectClassInArray() -> [NSObject : AnyObject]! {
        return ["cities": NSStringFromClass(City.self)]
    }
}


