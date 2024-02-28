//
//  PieceDamgeType.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 20.01.2024.
//

import Foundation
import CoreData

class PartDamage: NSObject, NSCoding, NSCopying, NSSecureCoding {
    var pieceName: String
    var damageType: String?
    var labelImage: String?
    var showIndsideBox: Bool?

    static var supportsSecureCoding: Bool {
        return true
    }
    
    init(pieceName: String, damageType: String?, labelImage: String? = "labels/orijinal", showIndsideBox: Bool? = false) {
        self.pieceName = pieceName
        self.damageType = damageType
        self.labelImage = labelImage
        self.showIndsideBox = showIndsideBox
        
    }

    required init?(coder aDecoder: NSCoder) {
        pieceName = aDecoder.decodeObject(forKey: "pieceName") as? String ?? ""
        damageType = aDecoder.decodeObject(forKey: "damageType") as? String
        labelImage = aDecoder.decodeObject(forKey: "labelImage") as? String
        showIndsideBox = aDecoder.decodeObject(forKey: "showIndsideBox") as? Bool
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(pieceName, forKey: "pieceName")
        aCoder.encode(damageType, forKey: "damageType")
        aCoder.encode(labelImage, forKey: "labelImage")
        aCoder.encode(showIndsideBox, forKey: "showIndsideBox")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PartDamage(pieceName: self.pieceName, damageType: self.damageType, showIndsideBox: self.showIndsideBox)
        return copy
    }

}
