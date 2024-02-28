//
//  AppConstants.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 31.12.2023.
//

import UIKit

struct AppConstants {
    static let carTypes: [CarType] = [.sedan, .sw, .hatchback, .coupe,
                                      .suv, .van1, .van2, .vanpickup1,
                                      .vanpickup2, .minivan1, .minivan2,
                                      .minivan3, .minivan4, .pickup1,
                                      .pickup2]
    
    static let pieceList: [PartDamage] = [
        PartDamage(pieceName: "Sol Ön Çamurluk", damageType: nil),
        PartDamage(pieceName: "Sol Ön Kapı", damageType: nil),
        PartDamage(pieceName: "Sol Arka Kapı", damageType: nil),
        PartDamage(pieceName: "Sol Arka Çamurluk", damageType: nil),
        PartDamage(pieceName: "Arka Kaput", damageType: nil),
        PartDamage(pieceName: "Sağ Arka Çamurluk", damageType: nil),
        PartDamage(pieceName: "Sağ Arka Kapı", damageType: nil),
        PartDamage(pieceName: "Sağ Ön Kapı", damageType: nil),
        PartDamage(pieceName: "Sağ Ön Çamurluk", damageType: nil),
        PartDamage(pieceName: "Ön Kaput", damageType: nil),
        PartDamage(pieceName: "Tavan", damageType: nil),
        PartDamage(pieceName: "Sol Ön Direk", damageType: nil, showIndsideBox: true),
        PartDamage(pieceName: "Sol Orta Direk", damageType: nil, showIndsideBox: true),
        PartDamage(pieceName: "Sol Arka Direk", damageType: nil, showIndsideBox: true),
        PartDamage(pieceName: "Sağ Ön Direk", damageType: nil, showIndsideBox: true),
        PartDamage(pieceName: "Sağ Orta Direk", damageType: nil, showIndsideBox: true),
        PartDamage(pieceName: "Sağ Arka Direk", damageType: nil, showIndsideBox: true),
        PartDamage(pieceName: "Ön", damageType: nil),
        PartDamage(pieceName: "Arka", damageType: nil),
        PartDamage(pieceName: "Sol Marşpiyel", damageType: nil, showIndsideBox: true),
        PartDamage(pieceName: "Sağ Marşpiyel", damageType: nil, showIndsideBox: true)
    ]
    
    static let damageTypeList: [String] = [
        "Orijinal",
        "Boyalı",
        "Lokal Boya",
        "Yarım Boya",
        "Tamirli Boya",
        "İnce Boya",
        "Ezik",
        "Değişen",
        "Vernikli",
        "Macunlu",
        "Çizik",
        "Plastik"
    ]
    
    static let damageLabelImages: [String] = [
        "labels/orijinal",
        "labels/boyali",
        "labels/lokal",
        "labels/yarim",
        "labels/tamirli",
        "labels/ince",
        "labels/ezik",
        "labels/degisen",
        "labels/vernikli",
        "labels/macunlu",
        "labels/cizik",
        "labels/plastik"
    ]
}

enum CarType: Int {
    case sedan
    case sw
    case hatchback
    case coupe
    case suv
    case van1
    case van2
    case vanpickup1
    case vanpickup2
    case minivan1
    case minivan2
    case minivan3
    case minivan4
    case pickup1
    case pickup2
    
    var image: UIImage {
        return UIImage(named: "\(self.version)/\(self.version)") ?? UIImage(named: "car")!
    }
    
    var left: UIImage {
        return UIImage(named: "\(self.version)/\(self.version)_left") ?? UIImage(named: "car")!
    }
    
    var right: UIImage {
        return UIImage(named: "\(self.version)/\(self.version)_right") ?? UIImage(named: "car")!
    }
    
    var top: UIImage {
        return UIImage(named: "\(self.version)/\(self.version)_top") ?? UIImage(named: "car")!
    }
    
    var back: UIImage {
        return UIImage(named: "\(self.version)/\(self.version)_back2") ?? UIImage(named: "car")!
    }
    
    var front: UIImage {
        return UIImage(named: "\(self.version)/\(self.version)_front2") ?? UIImage(named: "car")!
    }
    
    var damage: UIImage {
        return UIImage(named: "\(self.version)/\(self.version)_damage") ?? UIImage(named: "car")!
    }
    
    var imageString: String {
        return "\(self.version)/\(self.version)"
    }
    
    var leftString: String {
        return "\(self.version)/\(self.version)_left"
    }
    
    var rightString: String {
        return "\(self.version)/\(self.version)_right"
    }
    
    var topString: String {
        return "\(self.version)/\(self.version)_top"
    }
    
    var backString: String {
        return "\(self.version)/\(self.version)_back2"
    }
    
    var frontString: String {
        return "\(self.version)/\(self.version)_front2"
    }
    
    var damageString: String {
        return "\(self.version)/\(self.version)_damage"
    }
    
    var version: String {
        switch self {
        case .sedan: return "sedan"
        case .sw: return "sw"
        case .hatchback: return "hatchback"
        case .coupe: return "coupe"
        case .suv: return "suv"
        case .van1: return "van1"
        case .van2: return "van2"
        case .vanpickup1: return "vanpickup1"
        case .vanpickup2: return "vanpickup2"
        case .minivan1: return "minivan1"
        case .minivan2: return "minivan2"
        case .minivan3: return "minivan3"
        case .minivan4: return "minivan4"
        case .pickup1: return "pickup1"
        case .pickup2: return "pickup2"
        }
    }
}

class CarTypeManager {
    static func getCarTypeByVersion(_ version: String) -> CarType? {
        switch version {
        case "sedan": return .sedan
        case "sw": return .sw
        case "hatchback": return .hatchback
        case "coupe": return .coupe
        case "suv": return .suv
        case "van1": return .van1
        case "van2": return .van2
        case "vanpickup1": return .vanpickup1
        case "vanpickup2": return .vanpickup2
        case "minivan1": return .minivan1
        case "minivan2": return .minivan2
        case "minivan3": return .minivan3
        case "minivan4": return .minivan4
        case "pickup1": return .pickup1
        case "pickup2": return .pickup2
        default: return nil
        }
    }
}
