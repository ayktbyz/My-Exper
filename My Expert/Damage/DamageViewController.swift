//
//  DamageViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 19.01.2024.
//

import UIKit
import CoreData

class DamageViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    static let identifier = "DamageViewController"

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var carInfoCoreDataModel: UserCarInfo!
    var newPieceList: [PartDamage] = []
    var carImagesWithDots: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Araç Hasar Detay"
        
        if let data = carInfoCoreDataModel?.pieces {
            newPieceList = convertDataToPieces(data: data as! NSData) ??
            AppConstants.pieceList.map { $0.copy() as! PartDamage }
        } else {
            newPieceList = AppConstants.pieceList.map { $0.copy() as! PartDamage }
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PieceTableViewCell", bundle: nil), forCellReuseIdentifier: "PieceTableViewCell")
        
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPieceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PieceTableViewCell", for: indexPath) as! PieceTableViewCell
        let piece = newPieceList[indexPath.row]
        cell.pieceLabel.text = piece.pieceName
        cell.damageLabel.text = piece.damageType ?? ""

        cell.pieceButton.tag = indexPath.row
        cell.pieceButton.addTarget(self, action: #selector(pieceButtonTapped(_:)), for: .touchUpInside)
      
        return cell
    }
    
    @objc func pieceButtonTapped(_ sender: UIButton) {
        let rowIndex = sender.tag

        let alert = UIAlertController(title: "Hasar Seçimi", message: "Hasar tipi seçin", preferredStyle: .actionSheet)

        for (index, damageType) in AppConstants.damageTypeList.enumerated() {
            alert.addAction(UIAlertAction(title: damageType, style: .default, handler: { [self] (action) in
                newPieceList[rowIndex].damageType = damageType
                newPieceList[rowIndex].labelImage = AppConstants.damageLabelImages[index]
                self.tableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
            }))
        }

        self.present(alert, animated: true, completion: nil)
    }
    


    @objc func saveButtonTapped(_ sender: UIButton) {
        do {
            carInfoCoreDataModel.pieces = convertPiecesToData(pieces: newPieceList)
            saveCoreDataChanges()
            
            if let vc = UIStoryboard(name: "Summary", bundle: nil).instantiateViewController(withIdentifier: SummaryViewController.identifier) as? SummaryViewController {
                vc.carInfoCoreDataModel = self.carInfoCoreDataModel
                vc.carImagesWithDots = self.carImagesWithDots
                vc.customBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func convertPiecesToData(pieces: [PartDamage]) -> NSData? {
        return try? NSKeyedArchiver.archivedData(withRootObject: pieces, requiringSecureCoding: false) as NSData
    }

    func convertDataToPieces(data: NSData) -> [PartDamage]? {
        do {
            let pieces = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, PartDamage.self], from: data as Data) as? [PartDamage]
            return pieces
        } catch {
            print("Failed to unarchive data: \(error)")
            return nil
        }
    }
    
}
