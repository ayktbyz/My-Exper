//
//  ImageTableViewCell.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 16.01.2024.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    static let identifier = "ImageTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ImageTableViewCell", bundle: nil)
        
    }

    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var dotsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
