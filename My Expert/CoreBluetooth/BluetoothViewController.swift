//
//  BluetoothViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 26.01.2024.
//

import UIKit
import CoreBluetooth

class BluetoothViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let identifier = "BluetoothViewController"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scanButton: UIButton!
    
    var peripherals: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cihaz Bağlantısı"
        
        tableView.register(BluetoothCustomCell.self, forCellReuseIdentifier: "BluetoothCustomCell")

        BluetoothManager.shared.onPeripheralDiscovered = { [weak self] discoveredPeripherals in
            self?.peripherals = discoveredPeripherals
            self?.tableView.reloadData()
        }
        
        BluetoothManager.shared.onConnectionChange = { [weak self] peripheral, isConnected in
            guard let self = self else { return }
            if isConnected {
                print("\(peripheral.name ?? "Cihaz") bağlandı")
                navigationController?.popViewController(animated: true)
            } else {
                print("\(peripheral.name ?? "Cihaz") bağlantısı kesildi")
            }
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    
        setupScanButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BluetoothManager.shared.stopScan()
    }
    
    func setupScanButton() {
        BluetoothManager.shared.startScan()
        activityIndicator.startAnimating()
        scanButton.setTitle("Aramayı Durdur", for: .normal)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
    }
    
    @objc func scanButtonTapped() {
        BluetoothManager.shared.changeScan()

        if BluetoothManager.shared.isScanning {
            scanButton.setTitle("Aramayı Durdur", for: .normal)
            activityIndicator.startAnimating()
            
        } else {
            scanButton.setTitle("Aramayı Başlat", for: .normal)
            activityIndicator.stopAnimating()

        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.filter { $0.name != nil && $0.name != "Unknown Device" }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCustomCell", for: indexPath) as! BluetoothCustomCell

        let peripheral = peripherals.filter { $0.name != nil && $0.name != "Unknown Device" }[indexPath.row]
       
        var displayName = peripheral.name ?? "Unknown Device"
        if displayName.hasPrefix("CT2") || displayName.hasPrefix("LS2") {
            displayName = "MTS4500"
        }
        
        if peripheral == BluetoothManager.shared.connectedPeripheral{
            cell.customLabel.text = "\(displayName) -Bağlandı \n ID: \(peripheral.identifier.uuidString)"
        } else {
            cell.customLabel.text = "\(displayName)\n ID: \(peripheral.identifier.uuidString)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeripheral = peripherals.filter { $0.name != nil && $0.name != "Unknown Device" }[indexPath.row]
        
        DeviceManager.shared.processMACAddresses(selectedMac: selectedPeripheral.identifier.uuidString) { success in
            if success {
                if selectedPeripheral == BluetoothManager.shared.connectedPeripheral {
                    BluetoothManager.shared.disconnectPeripheral(selectedPeripheral)
                } else {
                    BluetoothManager.shared.centralManager.connect(selectedPeripheral, options: nil)
                }
            } else {
                if selectedPeripheral == BluetoothManager.shared.connectedPeripheral {
                    BluetoothManager.shared.disconnectPeripheral(selectedPeripheral)
                } else {
                    BluetoothManager.shared.centralManager.connect(selectedPeripheral, options: nil)
                }
            }
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

class BluetoothCustomCell: UITableViewCell {
    let customLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customLabel.numberOfLines = 0
        customLabel.lineBreakMode = .byWordWrapping
        customLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(customLabel)
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
