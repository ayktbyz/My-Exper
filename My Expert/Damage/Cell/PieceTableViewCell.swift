//
//  PieceTableViewCell.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 20.01.2024.
//

import UIKit

class PieceTableViewCell: UITableViewCell {

    @IBOutlet weak var pieceLabel: UILabel!
    @IBOutlet weak var pieceButton: UIButton!
    @IBOutlet weak var damageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
