//
//  BluetoothManager.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 26.01.2024.
//

import CoreBluetooth

extension Notification.Name {
    static let didReceiveBluetoothData = Notification.Name("didReceiveBluetoothData")
}

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    static let shared = BluetoothManager()
    
    var isScanning: Bool {
        return centralManager.isScanning
    }
    
    var centralManager: CBCentralManager!
    
    var connectedPeripheral: CBPeripheral?
    var discoveredPeripherals: [CBPeripheral] = []
    var onPeripheralDiscovered: (([CBPeripheral]) -> Void)?
    var onConnectionChange: ((CBPeripheral, Bool) -> Void)?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func changeScan() {
        if !centralManager.isScanning {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            centralManager.stopScan()
            discoveredPeripherals.removeAll()
            onPeripheralDiscovered?(discoveredPeripherals)
        }
    }
    
    func stopScan() {
        centralManager.stopScan()
        discoveredPeripherals.removeAll()
        onPeripheralDiscovered?(discoveredPeripherals)
    }
    
    func startScan() {
        if !isScanning {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.connectedPeripheral {
            self.connectedPeripheral = nil
            onConnectionChange?(peripheral, false)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
        if let connectedPeripheral = connectedPeripheral, !discoveredPeripherals.contains(connectedPeripheral) {
            discoveredPeripherals.append(connectedPeripheral)
        }
        onPeripheralDiscovered?(discoveredPeripherals)
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)  // Tüm servisleri keşfet
        
        self.connectedPeripheral = peripheral
        onConnectionChange?(peripheral, true)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        let dataModel = processData(data)
        
        NotificationCenter.default.post(name: .didReceiveBluetoothData, object: nil, userInfo: ["dataModel": dataModel])
    }
    
    private func processData(_ data: Data) -> MtsDataModel {
        let dataModel = MtsDataModel()
        let hexString = byteToHexString(data)
        
        guard hexString.count > 37 else {
            print("Okunan veri hatalı")
            return dataModel
        }
        
        let input = hexString.index(hexString.startIndex, offsetBy: 24)..<hexString.index(hexString.startIndex, offsetBy: 35)
        let inputString = String(hexString[input]).replacingOccurrences(of: " ", with: "")
        
        var chunks: [String] = []
        
        for i in stride(from: 0, to: inputString.count, by: 2) {
            let startIndex = inputString.index(inputString.startIndex, offsetBy: i)
            let endIndex = inputString.index(startIndex, offsetBy: 2)
            chunks.append(String(inputString[startIndex..<endIndex]))
        }
        
        chunks.reverse()
        let reversedString = chunks.joined()
        
        guard let decimalInt = Int(reversedString, radix: 16) else {
            print("Hexadecimal'den Integer'a dönüşüm başarısız")
            return dataModel
        }
        
        let decimal = Float(decimalInt) / 10.0
        
        if let thickness = decimal >= 100 ? "\(Int(decimal))" : "\(decimal)", let sonuc = Float(thickness) {
            dataModel.thickness = "\(sonuc)"
        }
        
        let tipRange = hexString.index(hexString.startIndex, offsetBy: 36)..<hexString.index(hexString.startIndex, offsetBy: 38)
        let tip = String(hexString[tipRange])
        dataModel.medicine = tip == "01" ? "Çlk" : "Alu"
        
        return dataModel
    }
    
    func byteToHexString(_ bytes: Data) -> String {
        return bytes.map { String(format: "%02hhx", $0) }.joined(separator: " ")
    }
    
    func disconnectPeripheral(_ peripheral: CBPeripheral) {
        if peripheral == connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func isBluetoothConnected() -> Bool {
        return connectedPeripheral != nil
    }
    
}

