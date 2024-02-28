//
//  TestViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit
import CoreData

protocol DropdownCellDelegate: AnyObject {
    func didSelectOption(option: String?)
}

protocol TextViewCellDelegate: AnyObject {
    func didUpdateText(tag: Int, newText: String)
}

public enum FormRowType: Int {
    case carModel = 0
    case plakaNumber = 1
    case chassisNumber = 2
    case brand = 3
    case model = 4
    case manufacturingYear = 5
    case km = 6
}

fileprivate enum FormRowTypeKeys: String {
    case carModel = "CarModel"
    case plakaNumber = "PlakaNumber"
    case chassisNumber = "ChassisNumber"
    case brand = "Brand"
    case model = "Model"
    case manufacturingYear = "ManufacturingYear"
    case km = "Km"
}

class TestViewController: BaseViewController,
                          UITableViewDataSource,
                          UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    private var archiveViewModel: ArchiveViewModel!

    var selectedCar: CarType = .sedan
    fileprivate var rowTupleList = [(title: String, content : Any?, required : Bool, type : FormRowType)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        initializeFields()
    }
    
    fileprivate func setupUi() {
        title = "Araç Seçimi"
        
        btnSave.backgroundColor = UIColor.red
        btnSave.setTitle("Kaydet", for: .normal)
        btnSave.isEnabled = false
        btnSave.addTarget(self, action: #selector(btnSaveClickedAction), for: .touchUpInside)

        archiveViewModel = ArchiveViewModel()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "HeaderContentTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderContentTableViewCell")
        tableView.register(UINib(nibName: "TextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "TextViewTableViewCell")
    }
    
    private func initializeFields() {
        rowTupleList = [
            (title: "Araç Modeli", content: CarType.sedan, required: true, type: .carModel),
            (title: "Plaka No", content: nil, required: true, type: .plakaNumber),
            (title: "Şaşe No", content: nil, required: false,  type: .plakaNumber),
            (title: "Marka", content: nil, required: false,  type: .brand),
            (title: "Model", content: nil, required: false,  type: .model),
            (title: "İmalat Yılı", content: nil, required: false,  type: .manufacturingYear),
            (title: "Km", content: nil, required: false,  type: .km)
        ]
    }
    
    @objc func btnSaveClickedAction() {
       saveUserData()
     }

    
    private func saveUserData(){
        let appDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegete.persistentContainer.viewContext
        let newCar = NSEntityDescription.insertNewObject(forEntityName: "UserCarInfo", into: context)
        let carId = UUID()
        newCar.setValue(carId, forKey: "id")
        newCar.setValue(selectedCar.version, forKey: "carModel")
        newCar.setValue(rowTupleList[FormRowType.plakaNumber.rawValue].content, forKey: "plateNumber")
        newCar.setValue(rowTupleList[FormRowType.chassisNumber.rawValue].content, forKey: "chassisNumber")
        newCar.setValue(rowTupleList[FormRowType.brand.rawValue].content, forKey: "brand")
        newCar.setValue(rowTupleList[FormRowType.model.rawValue].content, forKey: "model")
        newCar.setValue(rowTupleList[FormRowType.manufacturingYear.rawValue].content, forKey: "manufacturingYear")
        newCar.setValue(rowTupleList[FormRowType.km.rawValue].content, forKey: "km")
        newCar.setValue("Gönderilmedi", forKey: "status")


        do {
            
            btnSave.isEnabled = false
            
            try context.save()
       
            if let vc = UIStoryboard(name: "PointSelect", bundle: nil).instantiateViewController(withIdentifier: PointSelectViewController.identifier) as? PointSelectViewController {
                vc.carInfoCoreDataModel = UserCarInfoManager.shared.fetchUserCarInfo(by: carId)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        } catch {
            btnSave.isEnabled = true
            showAlert(withTitle: "Hata", message: "Veri kaydedilemedi: \(error.localizedDescription)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTupleList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = rowTupleList[indexPath.row]

        if [.carModel].contains(item.type) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderContentTableViewCell", for: indexPath) as! HeaderContentTableViewCell
            cell.initCell(title: item.title, content: (item.content as? CarType),withArrow: true)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewTableViewCell", for: indexPath) as! TextViewTableViewCell
            cell.initCell(tag: indexPath.row, title: item.title, content: item.content as? String)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = rowTupleList[indexPath.row]

        switch item.type {
        case .carModel:
            performSegue(withIdentifier: "navigateToCarList", sender: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
     }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToCarList",
           let destinationVC = segue.destination as? CarListViewController {
            destinationVC.delegate = self
        }
    }
    
    func validateFields() {
        let allRequiredContentsExist = rowTupleList.allSatisfy { tuple in
            return !tuple.required || (tuple.required && tuple.content != nil)
        }
        
        btnSave.isEnabled = allRequiredContentsExist
    }

    
    func tableReloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }

}

extension TestViewController: CarListViewControllerDelegate {
    func didSelectCar(carType: CarType) {
        selectedCar = carType
        
        if let index = rowTupleList.firstIndex(where: { $0.type == .carModel }) {
            rowTupleList[index].content = selectedCar
        }
        
        tableReloadData()
        validateFields()
    }
}

extension TestViewController: TextViewCellDelegate {
    func didUpdateText(tag: Int, newText: String) {
        rowTupleList[tag].content = newText
        validateFields()
    }
}
