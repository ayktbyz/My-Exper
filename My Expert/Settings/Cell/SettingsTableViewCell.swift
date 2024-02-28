//
//  SettingsTableViewCell.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit



class SettingsTableViewCell: UITableViewCell {
        
    static let identifier = "SettingsTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "SettingsTableViewCell", bundle: nil)
    }
    
    var callback: (() -> ())? = nil
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func clicked(_ sender: Any) {
        callback?()
    }
}
