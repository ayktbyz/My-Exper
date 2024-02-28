//
//  PhotoSelectionViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 6.01.2024.
//

import UIKit

class PhotoSelectionViewController: BaseViewController {
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    
    var selectedImage: UIImageView!
    var carInfoCoreDataModel: UserCarInfo!
    
    var selectedTag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageName1 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-0"
        let imageName2 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-1"
        let imageName3 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-2"
        let imageName4 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-3"

        
        if let loadedImage1 = ImageManager.shared.loadImage(withName: imageName1) {
            self.image1.image = loadedImage1
        }
        
        if let loadedImage2 = ImageManager.shared.loadImage(withName: imageName2) {
            self.image2.image = loadedImage2
        }
        
        if let loadedImage3 = ImageManager.shared.loadImage(withName: imageName3) {
            self.image3.image = loadedImage3
        }
        
        if let loadedImage4 = ImageManager.shared.loadImage(withName: imageName4) {
            self.image4.image = loadedImage4
        }

        addTapGesture(to: image1, withTag: 0)
        addTapGesture(to: image2, withTag: 1)
        addTapGesture(to: image3, withTag: 2)
        addTapGesture(to: image4, withTag: 3)
        
        title = "Fotoğraf Ekle"
    }

    private func addTapGesture(to stackView: UIImageView, withTag tag: Int) {
          let tap = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped(sender:)))
          stackView.tag = tag
          stackView.addGestureRecognizer(tap)
    }
    
    @objc private func stackViewTapped(sender: UITapGestureRecognizer) {
           if let tag = sender.view?.tag {
               selectedTag = tag
               switch tag {
               case 0:
                   selectedImage = image1
               case 1:
                   selectedImage = image2
               case 2:
                   selectedImage = image3
               case 3:
                   selectedImage = image4
               default:
                   break
               }
           }
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            print("Kamera kullanılamıyor.")
            return
        }

        present(picker, animated: true)
    }
    
    
    @IBAction func continueClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PhotoSelectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        if let tag = selectedTag {
            let imageName = "\(carInfoCoreDataModel.id!.uuidString as String)-image-\(tag)"
            ImageManager.shared.saveImage(image, withName: imageName)
        }
        
        selectedImage.image = image
        dismiss(animated: true)
    }
}
