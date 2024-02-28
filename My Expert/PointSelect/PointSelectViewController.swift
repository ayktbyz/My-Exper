//
//  PointSelectViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 31.12.2023.
//

import UIKit


enum PointState {
    case waitingForScan
    case waitingForTap
}

class PointSelectViewController: BaseViewController {
    
    static let identifier = "PointSelectViewController"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var dotsText: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var carInfoCoreDataModel: UserCarInfo!
    var carModel: CarModel!
    var limits: (String?, String?)
    
    
    var selectedIndex = 0 {
        didSet {
            nextButton.isEnabled = selectedIndex < carModel.imageList.count - 1
            previousButton.isEnabled = selectedIndex > 0
            completeButton.isEnabled = selectedIndex == carModel.imageList.count - 1
            if state == .waitingForScan {
                dotViewList.last?.removeFromSuperview()
            }
            updateStatus(state: .waitingForTap)
            updateImage()
        }
    }
    
    var currentTouchLocation: CGPoint = CGPoint(x: 0, y: 0)
    var state: PointState = .waitingForTap
    
    var dotViewList: [UIView] = []
    var savedImages: [String] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didReceiveBluetoothData, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousButton.isEnabled = false
        completeButton.isEnabled = false
        
        carModel = CarModel()
        let carType = CarTypeManager.getCarTypeByVersion(carInfoCoreDataModel?.carModel ?? "")
        
        carModel.imageList = [
            carType?.frontString ?? "",
            carType?.rightString ?? "",
            carType?.leftString ?? "",
            carType?.backString ?? "",
            carType?.topString ?? "",
        ]
        
        carModel.imageList.forEach { imageName in
            savedImages.append("")
        }
        
        initializePage()
        initializeBluetooth()
        limits = UserDefaultsManager.shared.loadLimits()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateImage()
        
        configureBluetoothButton()
        
        BluetoothManager.shared.onConnectionChange = { peripheral, isConnected in
            self.configureBluetoothButton()
        }
    }
    
    private func configureBluetoothButton() {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "icon_bluetooth")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.tintColor = BluetoothManager.shared.isBluetoothConnected() ? .green : .white
        
        button.addTarget(self, action: #selector(openBluetoothPage(sender:)), for: .touchUpInside)
        changeRightBarButtonItem(button: button)
    }
    private func initializePage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    private func initializeBluetooth() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleBluetoothData(_:)), name: .didReceiveBluetoothData, object: nil)
        
        if !BluetoothManager.shared.isBluetoothConnected() {
            let alert = UIAlertController(title: "Bluetooth Bağlantı Hatası", message: "Bluetooth bağlantısı kurulu değil. Bağlantı kurmak istiyor musunuz?", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Bağlantı kur", style: .default) { (action) in
                self.openBluetoothPage()
            }
            alert.addAction(action)
            
            let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func openBluetoothPage(sender: UIBarItem? = nil) {
        if let vc = UIStoryboard(name: "BluetoothView", bundle: nil).instantiateViewController(withIdentifier: BluetoothViewController.identifier) as? BluetoothViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func handleBluetoothData(_ notification: Notification) {
        
        if state == .waitingForScan {
            if let dataModel = notification.userInfo?["dataModel"] as? MtsDataModel {
                let thicknessDescription = String(describing: dataModel.thickness)
                print("Bluetooth verisi alındı: \(thicknessDescription)")
                
                if !thicknessDescription.contains("e") {
                    if let thickness = dataModel.thickness, let thicknessDouble = Double(thickness), let medicine = dataModel.medicine {
                        let displayThickness: Any = thicknessDouble > 100.0 ? Int(thicknessDouble) : thicknessDouble

                        let currentImage = carModel.imageList[selectedIndex]
                        let newCoordinate = CoordinateValueModel(x: currentTouchLocation.x,
                                                                 y: currentTouchLocation.y,
                                                                 value: "\(displayThickness)µm \(medicine)")
                        
                        if carModel.dotList[currentImage] == nil {
                            carModel.dotList[currentImage] = []
                        }
                        
                        carModel.dotList[currentImage]?.append(newCoordinate)
                        
                        if let carInfo = carInfoCoreDataModel {
                            carInfo.dotList = convertDictionaryToData(dictionary: carModel.dotList)
                        }
                        
                        updateDotsLabel()
                        saveCoreDataChanges()
                        updateStatus(state: .waitingForTap)
                        
                        
                        
                        
                        let dotView = createScannedDot(point: currentTouchLocation,
                                                       index: dotViewList.count,
                                                       isUnderLimit: Double(thickness)! < Double(limits.1 ?? "0") ?? 0.0)
                        
                        dotViewList.last?.removeFromSuperview()
                        dotViewList.removeLast()
                        
                        imageView.addSubview(dotView)
                        dotViewList.append(dotView)
                    }
                }
            }
        }
    }
    
    @objc func imageTapped(gesture: UITapGestureRecognizer) {
        
        if state == .waitingForTap {
            
            let touchLocation = gesture.location(in: imageView)
            currentTouchLocation = touchLocation
            print(touchLocation)
            
            if let color = imageView.image?.getPixelColor(pos: touchLocation, withFrameSize: imageView.frame.size) {
                if color.isWhite() {
                    let dotView = createDot(point: touchLocation)
                    imageView.addSubview(dotView)
                    dotViewList.append(dotView)
                    updateStatus(state: .waitingForScan)
                    removeButton.isEnabled = true
                }
            }
        }
    }
    
    private func updateDotsLabel() {
        let currentImage = carModel.imageList[selectedIndex]
        if let dotList = carModel.dotList[currentImage] {
            dotsText.text = dotList.last?.value ?? ""
        }
    }
    
    private func clearDotsLabel() {
        dotsText.text = ""
    }
    
    private func removeLastDot() {
        if let lastDot = dotViewList.popLast() {
            lastDot.removeFromSuperview()
        }
        
        // Control for tapped but not scanned status.
        if state == .waitingForTap {
            let currentImage = carModel.imageList[selectedIndex]
            if carModel.dotList[currentImage]?.isEmpty == false {
                carModel.dotList[currentImage]?.removeLast()
            }
            
            self.carInfoCoreDataModel!.dotList = convertDictionaryToData(dictionary: carModel.dotList)
            
            removeButton.isEnabled = !dotViewList.isEmpty
            
            updateDotsLabel()
            saveCoreDataChanges()
        } else {
            updateStatus(state: .waitingForTap)
        }
    }
    
    
    private func updateStatus(state: PointState) {
        
        self.state = state
        if state == .waitingForScan {
            statusLabel.text = "Cihazı Okutunuz"
            clearDotsLabel()
        } else {
            statusLabel.text = "Nokta Seçiniz"
            updateDotsLabel()
        }
    }
    
    @IBAction func leftClicked(_ sender: Any) {
        saveImageToListWithDots()
        selectedIndex -= 1
    }
    
    
    @IBAction func rightClicked(_ sender: Any) {
        saveImageToListWithDots()
        selectedIndex += 1
    }
    
    
    
    private func updateImage() {
        
        removeButton.isEnabled = false
        
        if let image = UIImage(named: carModel.imageList[selectedIndex]) {
            imageView.image = image
        }
        
        let currentImage = carModel.imageList[selectedIndex]
        
        dotViewList.forEach { $0.removeFromSuperview() }
        dotViewList.removeAll()
        carModel.dotList[currentImage] = []
        
        if let data = carInfoCoreDataModel?.dotList {
            let dict: [String: [CoordinateValueModel]]? = convertDataToDictionary(data: data as! NSData)
            if let dotList = dict?[currentImage] {
                
                removeButton.isEnabled = !dotList.isEmpty
                
                for dot in dotList {
                    
                    if carModel.dotList[currentImage] == nil {
                        carModel.dotList[currentImage] = []
                    }
                    
                    let dotView = createScannedDot(point: CGPoint(x: dot.x, y: dot.y),
                                                   index: dotViewList.count + 1,
                                                   isUnderLimit: calculateIsUnderLimit(value: dot.value))
                    imageView.addSubview(dotView)
                    dotViewList.append(dotView)
                    
                    carModel.dotList[currentImage]?.append(CoordinateValueModel(x: dot.x, y: dot.y, value: dot.value))
                }
            }
        }
        
        updateDotsLabel()
    }
    
    private func calculateIsUnderLimit(value: String) -> Bool {
        return Double(value.split(separator: "µ").first!)! < Double(limits.1 ?? "0.0") ?? 0.0
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        removeLastDot()
    }
    
    @IBAction func completeClicked(_ sender: Any) {
        saveImageToListWithDots()
        navigateToDamage()
    }
    
    private func navigateToDamage() {
        if let vc = UIStoryboard(name: "Summary", bundle: nil).instantiateViewController(withIdentifier: DamageViewController.identifier) as? DamageViewController {
            vc.carInfoCoreDataModel = self.carInfoCoreDataModel
            vc.carImagesWithDots = savedImages
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func createDot(point: CGPoint) -> UIView {
        let circleSize: CGFloat = 14
        let dotView = UIView(frame: CGRect(x: point.x - circleSize / 2, y: point.y - circleSize / 2, width: circleSize, height: circleSize))
        
        dotView.layer.cornerRadius = circleSize / 2
        dotView.layer.borderWidth = 4
        dotView.layer.borderColor = UIColor.red.cgColor
        dotView.backgroundColor = .clear
        
        return dotView
    }
    
    private func createScannedDot(point: CGPoint, index: Int, isUnderLimit: Bool) -> UIView {
        let circleSize: CGFloat = 12
        let dotView = UIView(frame: CGRect(x: point.x - circleSize / 2, y: point.y - circleSize / 2, width: circleSize, height: circleSize))
        
        dotView.layer.cornerRadius = circleSize / 2
        dotView.backgroundColor = isUnderLimit ? UIColor.green : UIColor.red
        
        let label = UILabel(frame: CGRect(x: -4, y: circleSize, width: 20, height: 20))
        label.text = "\(index)"
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        dotView.addSubview(label)
        
        return dotView
    }
    
    func saveImageToListWithDots() {
        let renderer = UIGraphicsImageRenderer(size: imageView.bounds.size)
        let mergedImage = renderer.image { context in
            imageView.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        }
        
        let imageName = "K\(carInfoCoreDataModel.plateNumber ?? "" as String)\(selectedIndex)"
        ImageManager.shared.saveImage(mergedImage, withName: imageName)
        
        savedImages[selectedIndex] = imageName
    }
    
}

extension PointSelectViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.deviceOrientation = .landscapeLeft
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            
        } else {
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.deviceOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
            
        } else {
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
    }
    
    func convertDictionaryToData(dictionary: [String: [CoordinateValueModel]]) -> NSData? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: dictionary, requiringSecureCoding: false) as NSData
        } catch {
            print("Error during convert [String: [CoordinateOld]] to NSDAta")
            return nil
        }
    }
    
    // NSData'yı Dictionary'ye dönüştürme
    func convertDataToDictionary(data: NSData) -> [String: [CoordinateValueModel]]? {
        do {
            let coordinates = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, NSArray.self, CoordinateValueModel.self], from: data as Data) as? [String: [CoordinateValueModel]]
            return coordinates
        } catch {
            print("Failed to unarchive data: \(error)")
            return nil
        }
    }
}
