//
//  DropDownTableViewCell.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {
    @IBOutlet weak var pickerView: UIPickerView!

     var options: [String] = []
     var selectedOption: String?
     weak var delegate: DropdownCellDelegate?

     func setup(options: [String], selectedOption: String?) {
         self.options = options
         self.selectedOption = selectedOption
         /*pickerView.reloadAllComponents()
         if let index = options.firstIndex(of: selectedOption ?? "") {
             pickerView.selectRow(index, inComponent: 0, animated: false)
         }*/
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         selectedOption = options[row]
         delegate?.didSelectOption(option: selectedOption)
     }
}
