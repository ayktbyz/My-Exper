//
//  TextViewTableViewCell.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class TextViewTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var textView: UITextField!
    
    var tagValue: Int = 0
    weak var delegate: TextViewCellDelegate?

     func initCell(tag: Int, title: String?, content: String?) {
         self.tagValue = tag
         labelView.text = title ?? ""
         textView.text = content ?? ""
         textView.tag = tag
         textView.delegate = self
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        delegate?.didUpdateText(tag: tagValue, newText: textField.text ?? "")
    }
}
