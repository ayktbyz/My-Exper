//
//  ArchiveCarTableViewCell.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 2.01.2024.
//

import UIKit

protocol ArchiveCarTableViewCellDelegate: AnyObject {
    func deleteTapped()
    func cellTapped(indexPath: IndexPath)
}

class ArchiveCarTableViewCell: UITableViewCell {
    
    var carInfoCoreDataModel: UserCarInfo!
    
    weak var delegate: ArchiveCarTableViewCellDelegate?
    
    @IBOutlet weak var carModel: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var plakaLabel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    
    @IBOutlet weak var btnDelete: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteTapped))
        btnDelete.tag = tag
        btnDelete.addGestureRecognizer(tap)
        
        let containerTap = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(containerTap)
    }
    
    @objc private func deleteTapped() {
        UserCarInfoManager.shared.deleteUserCarInfo(by: carInfoCoreDataModel!.id!)
        delegate?.deleteTapped()
    }
    
    @objc private func containerTapped() {
        delegate?.cellTapped(indexPath: indexPath)
    }
}
