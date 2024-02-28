    //
    //  CarListViewController.swift
    //  My Expert
    //
    //  Created by AYKUT BEYAZ on 31.12.2023.
    //

    import UIKit

protocol CarListViewControllerDelegate: AnyObject {
    func didSelectCar(carType: CarType)
}

class CarListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    weak var delegate: CarListViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Araç Model Seçimi"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CarTableViewCell", bundle: nil), forCellReuseIdentifier: "CarTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppConstants.carTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: indexPath) as! CarTableViewCell
         let carType = AppConstants.carTypes[indexPath.row]
         cell.label.text = carType.version
         cell.carImage.image = carType.image
         
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = AppConstants.carTypes[indexPath.row]
        delegate?.didSelectCar(carType: item)
        self.navigationController?.popViewController(animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
     }
    
}
