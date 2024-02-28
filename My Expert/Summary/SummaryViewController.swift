//
//  SummaryViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 6.01.2024.
//

import UIKit

class SummaryViewController: BaseViewController, UINavigationControllerDelegate {
    
    static let identifier = "SummaryViewController"
    
    var carInfoCoreDataModel: UserCarInfo!
    var carImagesWithDots: [String]?
    var imageListForSocketService: [UIImage] = []
    var imageList: [String] = []
    var dotTexts: [[String]] = [[], [], [], [], [], []]
    
    var customBackButton: Bool = false
    
    @IBOutlet weak var edit: UIImageView!
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var note: UIImageView!
    @IBOutlet weak var pdf: UIImageView!
    @IBOutlet weak var device: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var loadingView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingView()
        loadingView.isHidden = true

        addTapGesture(to: edit, withTag: 0)
        addTapGesture(to: camera, withTag: 1)
        addTapGesture(to: note, withTag: 2)
        addTapGesture(to: pdf, withTag: 3)
        addTapGesture(to: device, withTag: 4)
        
        title = "\(carInfoCoreDataModel.plateNumber ?? "") - \(carInfoCoreDataModel.reportNumber ?? "")"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTableViewCell.nib(), forCellReuseIdentifier: ImageTableViewCell.identifier)
        
        
        let carType = CarTypeManager.getCarTypeByVersion(carInfoCoreDataModel?.carModel ?? "")
        
        imageList = [
            carType?.frontString ?? "",
            carType?.rightString ?? "",
            carType?.leftString ?? "",
            carType?.backString ?? "",
            carType?.topString ?? "",
        ]
        
        carImagesWithDots = [
            "K\(carInfoCoreDataModel.plateNumber ?? "")0",
            "K\(carInfoCoreDataModel.plateNumber ?? "")1",
            "K\(carInfoCoreDataModel.plateNumber ?? "")2",
            "K\(carInfoCoreDataModel.plateNumber ?? "")3",
            "K\(carInfoCoreDataModel.plateNumber ?? "")4"
        ]
        
        for index in 0..<(imageList.count) {
            
            let currentImage = imageList[index]
            
            if let data = carInfoCoreDataModel?.dotList {
                let dict: [String: [CoordinateValueModel]]? = convertDataToDictionary(data: data as! NSData)
                if let dotList = dict?[currentImage] {
                    
                    for dot in dotList {
                        dotTexts[index].append(dot.value)
                    }
                }
            }
        }
        
        if customBackButton {
            let leftBarButton: UIButton = UIButton()
            leftBarButton.setImage(UIImage(systemName: "arrow.backward"), for: UIControl.State())
            leftBarButton.setTitle("Arşiv", for: .normal)
            leftBarButton.addTarget(self, action: #selector(back(sender:)), for: UIControl.Event.touchUpInside)
            leftBarButton.sizeToFit()
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let archiveViewController = storyboard.instantiateViewController(withIdentifier: ArchiveViewController.identifier) as? ArchiveViewController {
            self.navigationController?.pushViewController(archiveViewController, animated: true)
        }
    }
    
    func setupLoadingView() {
        loadingView = UIView()
        loadingView.layer.cornerRadius = 10
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(activityIndicator)
        
        loadingLabel = UILabel()
        loadingLabel.text = "Gönderim başladı..."
        loadingLabel.textColor = .white
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 200),
            loadingView.heightAnchor.constraint(equalToConstant: 100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loadingView.topAnchor, constant: 20),
            
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10)
        ])
    }
    
    func showLoadingView(show: Bool) {
        loadingView.isHidden = !show
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func addTapGesture(to imageView: UIImageView, withTag tag: Int) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped(sender:)))
        imageView.tag = tag
        imageView.addGestureRecognizer(tap)
    }
    
    @objc private func stackViewTapped(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            switch tag{
            case 0:
                editTapped()
            case 1:
                cameraTapped()
            case 2:
                noteTapped()
            case 3:
                pdfTapped()
            case 4:
                deviceTapped()
            default:
                break
            }
        }
    }
    
    func imageFromCell(cell: UITableViewCell) -> UIImage? {
        // Hücrenin boyutlarına uygun bir grafik bağlamı başlatıyoruz.
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0.0)
        
        // Hücrenin içeriğini bu bağlama çiziyoruz.
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        // Oluşturulan görüntüyü alıyoruz.
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // Grafik bağlamını temizliyoruz.
        UIGraphicsEndImageContext()
        
        return image
    }
    
    @objc func editTapped() {
        if let vc = UIStoryboard(name: "PointSelect", bundle: nil).instantiateViewController(withIdentifier: PointSelectViewController.identifier) as? PointSelectViewController {
            vc.carInfoCoreDataModel = self.carInfoCoreDataModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func pdfTapped() {
        if let vc = UIStoryboard(name: "PDF", bundle: nil).instantiateViewController(withIdentifier: PDFViewController.identifier) as? PDFViewController {
            vc.carInfoCoreDataModel = self.carInfoCoreDataModel
            vc.dotTexts = self.dotTexts
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func deviceTapped() {
        self.device.isUserInteractionEnabled = false
        showLoadingView(show: true)

        guard let ipAddress = UserDefaultsManager.shared.getIPAdress() else {
            self.showAlert(title: "Uyarı", message: "Ayarlar kısımından ip adresiniz giriniz.")
            self.device.isUserInteractionEnabled = true
            showLoadingView(show: false)
            return
        }
        
        var pointsLineByLine = ""
        
        for (index, subArray) in dotTexts.enumerated() {
            for (_, value) in subArray.enumerated() {
                let formattedOutput = "X: 0 Y: 0 değer: \(value) Araç Yüzü: \(index)"
                pointsLineByLine += formattedOutput + "\n"
            }
        }
        
        let fileName = "K\(carInfoCoreDataModel.plateNumber ?? "").txt"
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentDirectory?.appendingPathComponent(fileName)
        
        do {
            try pointsLineByLine.write(to: fileURL!, atomically: true, encoding: .utf8)
        } catch {
            print("Dosya oluşturulamadı veya içeriği yazılamadı: \(error)")
        }
        
        var fileURLs: [URL] = []
        fileURLs.append(fileURL!)
        
        for (index, item) in carImagesWithDots!.enumerated() {
            
            if let image = ImageManager.shared.loadImage(withName: item) {
                ImageManager.shared.saveImage(image, withName: "K\(carInfoCoreDataModel.plateNumber ?? "")-\(index)", quality: 1)
                
                let fileURL = ImageManager.shared.getDocumentsDirectory().appendingPathComponent("K\(carInfoCoreDataModel.plateNumber ?? "")-\(index).jpg")
                fileURLs.append(fileURL)
                print(fileURL)
            }
        }
        
        let totalFiles = fileURLs.count
        var filesSentCount = 0
        var filesSentSuccessfully = 0
        var filesSentError = 0
        
        let encoder = JSONEncoder()
        
        var delayInSeconds = 0.0
        var shouldStop = false
        
        for (index, fileURL) in fileURLs.enumerated() {
            if shouldStop { break }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                if shouldStop { return }

                let fileName = fileURL.lastPathComponent
                let fileType = fileURL.pathExtension
                if let fileData = FileManager.default.contents(atPath: fileURL.path) {
                    let fileTransferMessage = FileTransferMessage(fileName: fileName, fileType: fileType, data: fileData.base64EncodedString(options: .lineLength64Characters))

                    if let jsonData = try? encoder.encode(fileTransferMessage) {
                        var jsonString = String(data: jsonData, encoding: .utf8)!
                        jsonString += "END_OF_MESSAGE"
                        if let finalData = jsonString.data(using: .utf8) {
                            let ipAddress = UserDefaultsManager.shared.getIPAdress() ?? ""
                            SocketFileManager.shared.sendData(ipAddress: ipAddress, port: 27018, data: finalData) { success, error in

                                filesSentCount += 1
                                if success {
                                    filesSentSuccessfully += 1
                                } else {
                                    filesSentError += 1
                                }

                                DispatchQueue.main.async {
                                    if filesSentSuccessfully >= fileURLs.count {
                                        self.showLoadingView(show: false)
                                        self.carInfoCoreDataModel.status = "Gönderildi"
                                        self.showAlert(title: "Başarılı", message: "Tüm dosyalar başarıyla gönderildi.")
                                    } else if filesSentError == 1 {
                                        shouldStop = true
                                        
                                        self.showLoadingView(show: false)
                                        self.showAlert(title: "Başarısız", message: "IP adresinizi veya socketinizi kontrol ediniz.")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            delayInSeconds += 2.0
        }

                
        self.device.isUserInteractionEnabled = true
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func cameraTapped() {
        performSegue(withIdentifier: "toImageSelect", sender: nil)
    }
    
    @objc func noteTapped() {
        performSegue(withIdentifier: "toNote", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNote" {
            let dvc = segue.destination as! NoteViewController
            dvc.carInfoCoreDataModel = self.carInfoCoreDataModel
            
        } else if segue.identifier == "toImageSelect" {
            if let photoSelectionView = segue.destination as? PhotoSelectionViewController {
                photoSelectionView.carInfoCoreDataModel = carInfoCoreDataModel
            }
        }
    }
}

extension SummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        
        if let item = carImagesWithDots?[indexPath.row] {
            if let loadedImage = ImageManager.shared.loadImage(withName: item) {
                cell.carImage.image = loadedImage
            }
        }
        
        var result = ""
        for (index, value) in dotTexts[indexPath.row].enumerated() {
            let numberedValue = "\(index + 1). \(value)"
            result.append(numberedValue)
            
            if (index + 1) % 5 == 0 {
                result.append("\n")
            } else {
                result.append("  ")
            }
        }
        
        cell.dotsLabel.text = result
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carImagesWithDots?.count ?? 0
    }
    
    func createCombinedImageWithMultilineText(with image: UIImage, textArray: [String], font: UIFont = UIFont.systemFont(ofSize: 30), textColor: UIColor = .black, textPadding: CGFloat = 8, valuesPerLine: Int = 5) -> UIImage? {
        let imageSize = image.size
        let textAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0.0)
        
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: imageSize))
        
        image.draw(in: CGRect(origin: .zero, size: imageSize))
        
        var yOffset: CGFloat = imageSize.height - 80
        
        for i in stride(from: 0, to: textArray.count, by: valuesPerLine) {
            let end = min(i + valuesPerLine, textArray.count)
            let lineTextArray = textArray[i..<end].enumerated().map { (offset, element) -> String in
                return "\(i + offset + 1). \(element)"
            }
            let lineText = lineTextArray.joined(separator: "     ")
            
            let boundingRect = (lineText as NSString).boundingRect(with: CGSize(width: imageSize.width - 2 * textPadding, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
            let textHeight = boundingRect.height
            
            (lineText as NSString).draw(in: CGRect(x: textPadding + 60, y: yOffset, width: imageSize.width - 2 * textPadding, height: textHeight), withAttributes: textAttributes)
            
            yOffset += textHeight + textPadding
        }
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage
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
