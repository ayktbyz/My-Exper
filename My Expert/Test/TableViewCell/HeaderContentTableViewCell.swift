//
//  HeaderContentTableViewCell.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class HeaderContentTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var carImage: UIImageView!
    
    func initCell(title: String, content: CarType?, enabled: Bool = true, withArrow: Bool = false) {
        
        self.selectionStyle = .none
        
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.masksToBounds = true
        
        contentLabel.text = content?.version ?? title
        
        arrow.isHidden = !withArrow
        
        if let image = content?.image {
            carImage.image = image
        } else {
            carImage.image = UIImage(named: "car")
        }
    }
    
}
