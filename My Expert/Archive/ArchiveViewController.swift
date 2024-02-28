//
//  ArchiveViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class ArchiveViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ArchiveCarTableViewCellDelegate {
    
    static let identifier = "ArchiveViewController"
    
    @IBOutlet weak var tableView: UITableView!
    private var archiveViewModel: ArchiveViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Araç Listesi"
        
        archiveViewModel = ArchiveViewModel()
        archiveViewModel.fetchAllUserCarInfo()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: "ArchiveCarTableViewCell", bundle: nil), forCellReuseIdentifier: "ArchiveCarTableViewCell")
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (archiveViewModel == nil) ? 0 : archiveViewModel.userCarInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveCarTableViewCell", for: indexPath) as! ArchiveCarTableViewCell
        let car = archiveViewModel.userCarInfos[indexPath.row]
        let carType = CarTypeManager.getCarTypeByVersion(car.carModel!)
        
        cell.reportLabel.text = "Rapor: \(car.reportNumber ?? "")"
        cell.plakaLabel.text = "Plaka: \(car.plateNumber ?? "")"
        cell.carTypeLabel.text = "Araç Tipi: \(carType?.version ?? "")"
        cell.carInfoCoreDataModel = car
        cell.carModel.image = carType?.image
        cell.indexPath = indexPath
        cell.delegate = self
        cell.statusLabel.text = car.status

        cell.separatorInset = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
       
        return cell
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.00
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func deleteTapped() {
        archiveViewModel.fetchAllUserCarInfo()
        tableView.reloadData()
    }
    
    func cellTapped(indexPath: IndexPath) {
        let car = archiveViewModel.userCarInfos[indexPath.row]
        
        if let vc = UIStoryboard(name: "Summary", bundle: nil).instantiateViewController(withIdentifier: SummaryViewController.identifier) as? SummaryViewController {
            vc.carInfoCoreDataModel = car
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        archiveViewModel.fetchAllUserCarInfo()
        tableView.reloadData()
    }

}
