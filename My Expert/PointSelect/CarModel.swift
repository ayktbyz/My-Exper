//
//  CarModel.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 1.01.2024.
//

import Foundation
import CoreData

class CarModel {
        
    var imageList: [String] = []
    var dotList: [String: [CoordinateValueModel]] = [:]
}

class CoordinateValueModel: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    var x: Double
    var y: Double
    var value: String
    
    init(x: Double, y: Double, value: String) {
        self.x = x
        self.y = y
        self.value = value
    }

    required init?(coder aDecoder: NSCoder) {
        x = aDecoder.decodeDouble(forKey: "x")
        y = aDecoder.decodeDouble(forKey: "y")
        value = aDecoder.decodeObject(forKey: "value") as! String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
        aCoder.encode(value, forKey: "value")
    }
}
