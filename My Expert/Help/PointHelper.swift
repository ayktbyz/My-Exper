//
//  PointHelper.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.01.2024.
//

import Foundation


struct PointHelper {
    static func calculateCoordinates(for carType: CarType, pieceName: String) -> CGRect? {
        let width: CGFloat = 20.0
        let height: CGFloat = 20.0
        
        switch carType {
        case .sedan:
            switch pieceName {
            case "Ön":
                return CGRect(x: 34.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 105.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 232.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return CGRect(x: 317.0, y: 190.0, width: width, height: height)
            case "Arka":
                return CGRect(x: 372.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 82.0, y: 115.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 182.0, y: 120.0, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 232.0, y: 120.0, width: width, height: height)
            case "Sol Arka Çamurluk":
                return CGRect(x: 290.0, y: 128.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 82.0, y: 265.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 182.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 232.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return CGRect(x: 290.0, y: 245.0, width: width, height: height)
            default:
                return nil
            }
            
        case .coupe:
            switch pieceName {
            case "Ön":
                return CGRect(x: 24.0, y: 190, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 95.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 222.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return CGRect(x: 307.0, y: 190.0, width: width, height: height)
            case "Arka":
                return CGRect(x: 362.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 131, y: 122, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 193, y: 125, width: width, height: height)
            case "Sol Arka Kapı":
                return nil
            case "Sol Arka Çamurluk":
                return CGRect(x: 270.0, y: 128.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 137, y: 260, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 182, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return nil
            case "Sağ Arka Çamurluk":
                return CGRect(x: 271.0, y: 255.0, width: width, height: height)
            default:
                return nil
            }
        case .sw:
            switch pieceName {
            case "Ön":
                return CGRect(x: 24.0, y: 190, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 95.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 222.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return CGRect(x: 332, y: 190.0, width: width, height: height)
            case "Arka":
                return CGRect(x: 362.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 136, y: 120, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 190, y: 120, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 243, y: 120, width: width, height: height)
            case "Sol Arka Çamurluk":
                return CGRect(x: 310, y: 137, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 130, y: 260.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 172.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 235, y: 260.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return CGRect(x: 300, y: 250, width: width, height: height)
            default:
                return nil
            }
            
        case .hatchback:
            switch pieceName {
            case "Ön":
                return CGRect(x: 54.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 125.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 232.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return CGRect(x: 317.0, y: 190.0, width: width, height: height)
            case "Arka":
                return CGRect(x: 362.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 145, y: 128.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 182.0, y: 120.0, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 252.0, y: 120.0, width: width, height: height)
            case "Sol Arka Çamurluk":
                return CGRect(x: 300.0, y: 133.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 145, y: 260.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 182.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 252.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return CGRect(x: 300.0, y: 245.0, width: width, height: height)
            default:
                return nil
            }
        case .suv:
            switch pieceName {
            case "Ön":
                return CGRect(x: 34.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 105.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 232.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return CGRect(x: 317.0, y: 190.0, width: width, height: height)
            case "Arka":
                return CGRect(x: 360.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 135, y: 130, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 182.0, y: 120.0, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 232.0, y: 120.0, width: width, height: height)
            case "Sol Arka Çamurluk":
                return CGRect(x: 290.0, y: 128.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 135, y: 250, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 182.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 232.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return CGRect(x: 290.0, y: 245.0, width: width, height: height)
            default:
                return nil
            }
        case .van1, .van2:
            switch pieceName {
            case "Ön":
                return CGRect(x: 77, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 105.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 200, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return nil
            case "Arka":
                return CGRect(x: 317.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 130, y: 115.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 160, y: 120.0, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 202, y: 120.0, width: width, height: height)
            case "Sol Arka Çamurluk":
                return nil
            case "Sağ Ön Çamurluk":
                return CGRect(x: 130, y: 265.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 160, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 202, y: 260.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return nil
            default:
                return nil
            }
        case .vanpickup1:
            switch pieceName {
            case "Ön":
                return CGRect(x: 65.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 110.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 160, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return nil
            case "Arka":
                return nil
            case "Sol Ön Çamurluk":
                return CGRect(x: 122.0, y: 125.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 152.0, y: 130.0, width: width, height: height)
            case "Sol Arka Kapı":
                return nil
            case "Sol Arka Çamurluk":
                return nil
            case "Sağ Ön Çamurluk":
                return CGRect(x: 122.0, y: 260.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 152.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return nil
            case "Sağ Arka Çamurluk":
                return nil
            default:
                return nil
            }
            
        case .vanpickup2:
            switch pieceName {
            case "Ön":
                return CGRect(x: 65.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 110.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 160, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return nil
            case "Arka":
                return nil
            case "Sol Ön Çamurluk":
                return CGRect(x: 122.0, y: 125.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 152.0, y: 130.0, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 192.0, y: 130.0, width: width, height: height)
            case "Sol Arka Çamurluk":
                return nil
            case "Sağ Ön Çamurluk":
                return CGRect(x: 122.0, y: 260.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 152.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 192.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return nil
            default:
                return nil
            }
        case .minivan1, .minivan2:
            switch pieceName {
            case "Ön":
                return CGRect(x: 70.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 115.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 242.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return nil
            case "Arka":
                return CGRect(x: 340.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 140, y: 125.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 192.0, y: 130.0, width: width, height: height)
            case "Sol Arka Kapı":
                return nil
            case "Sol Arka Çamurluk":
                return CGRect(x: 260, y: 138.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 140, y: 265.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 192.0, y: 270.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return nil
            case "Sağ Arka Çamurluk":
                return CGRect(x: 260, y: 255.0, width: width, height: height)
            default:
                return nil
            }
            // Diğer araç türleri için benzer switch-case yapıları eklenir
        case .minivan3, .minivan4:
            switch pieceName {
            case "Ön":
                return CGRect(x: 75, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 125.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 242.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return nil
            case "Arka":
                return CGRect(x: 340.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 150, y: 125.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 192.0, y: 130.0, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 235, y: 130.0, width: width, height: height)
            case "Sol Arka Çamurluk":
                return CGRect(x: 265, y: 138.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 150, y: 265.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 192.0, y: 270.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 235, y: 270.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return CGRect(x: 265, y: 255.0, width: width, height: height)
            default:
                return nil
            }
        case .pickup1:
            switch pieceName {
            case "Ön":
                return CGRect(x: 34.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 105.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 232.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return nil
            case "Arka":
                return CGRect(x: 352.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 112.0, y: 125.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 182.0, y: 120.0, width: width, height: height)
            case "Sol Arka Kapı":
                return nil
            case "Sol Arka Çamurluk":
                return CGRect(x: 290.0, y: 128.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 112.0, y: 255.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 182.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return nil
            case "Sağ Arka Çamurluk":
                return CGRect(x: 290.0, y: 245.0, width: width, height: height)
            default:
                return nil
            }
        case .pickup2:
            switch pieceName {
            case "Ön":
                return CGRect(x: 34.0, y: 190.0, width: width, height: height)
            case "Ön Kaput":
                return CGRect(x: 105.0, y: 190.0, width: width, height: height)
            case "Tavan":
                return CGRect(x: 222.0, y: 190.0, width: width, height: height)
            case "Arka Kaput":
                return nil
            case "Arka":
                return CGRect(x: 352.0, y: 190.0, width: width, height: height)
            case "Sol Ön Çamurluk":
                return CGRect(x: 112.0, y: 125.0, width: width, height: height)
            case "Sol Ön Kapı":
                return CGRect(x: 182.0, y: 120.0, width: width, height: height)
            case "Sol Arka Kapı":
                return CGRect(x: 222.0, y: 120.0, width: width, height: height)
            case "Sol Arka Çamurluk":
                return CGRect(x: 280.0, y: 128.0, width: width, height: height)
            case "Sağ Ön Çamurluk":
                return CGRect(x: 112.0, y: 255.0, width: width, height: height)
            case "Sağ Ön Kapı":
                return CGRect(x: 182.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Kapı":
                return CGRect(x: 232.0, y: 260.0, width: width, height: height)
            case "Sağ Arka Çamurluk":
                return CGRect(x: 290.0, y: 245.0, width: width, height: height)
            default:
                return nil
            }
        }
    }

}
