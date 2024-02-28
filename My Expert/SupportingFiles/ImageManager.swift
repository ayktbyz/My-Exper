//
//  ImageManager.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 20.01.2024.
//

import Foundation
import UIKit

class ImageManager {
    
    static let shared = ImageManager()

    private init() {}

    public func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func saveImage(_ image: UIImage, withName imageName: String) {
        guard let imageData = image.pngData() else { return }
        let filePath = getDocumentsDirectory().appendingPathComponent("\(imageName).png")
        do {
            try imageData.write(to: filePath)
            print("Resim kaydedildi: \(filePath)")
        } catch {
            print("Resmi kaydederken hata oluştu: \(error)")
        }
    }
    
    func saveImage(_ image: UIImage, withName imageName: String, quality: CGFloat) {
        guard let imageData = image.jpegData(compressionQuality: quality) else { return }
        let filePath = getDocumentsDirectory().appendingPathComponent("\(imageName).jpg")
        do {
            try imageData.write(to: filePath)
            print("Resim kaydedildi: \(filePath)")
        } catch {
            print("Resmi kaydederken hata oluştu: \(error)")
        }
    }

    func loadImage(withName imageName: String) -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent("\(imageName).png")
        return UIImage(contentsOfFile: filePath.path)
    }

    func deleteImage(withName imageName: String) -> Bool {
        let filePath = getDocumentsDirectory().appendingPathComponent("\(imageName).png")
        do {
            try FileManager.default.removeItem(at: filePath)
            print("Resim silindi: \(filePath)")
            return true
        } catch {
            print("Resmi silerken hata oluştu: \(error)")
            return false
        }
    }
}
