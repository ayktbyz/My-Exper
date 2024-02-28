//
//  PDViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 14.01.2024.
//

import UIKit
import PDFKit

class PDFViewController: BaseViewController {
    
    static let identifier = "PDF"
    private var carImagesWithDots: [String]?
    private var takedCarPhotos: [UIImage] = []
    var carInfoCoreDataModel: UserCarInfo!
    var dotTexts: [[String]]!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overlay: UIView!
    
    var pdfDocument: PDFDocument!
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let pdfView = gestureRecognizer.view as! PDFView
        let location = gestureRecognizer.location(in: pdfView)
        
        if let currentPage = pdfView.currentPage {
            let pageLocation = pdfView.convert(location, to: currentPage)
            print("Clicked Location on Page: \(pageLocation)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImagesFromStoreage()
        preparePDF()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let config = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)
        let rightBarButton: UIButton = UIButton()
        rightBarButton.setImage(image, for: UIControl.State())
        rightBarButton.addTarget(self, action: #selector(saveAndShareAnnotatedPDF(sender:)), for: UIControl.Event.touchUpInside)
        rightBarButton.sizeToFit()
        changeRightBarButtonItem(button: rightBarButton)
    }
    
    
    private func fetchImagesFromStoreage() {
        
        carImagesWithDots  = [
            "K\(carInfoCoreDataModel.plateNumber ?? "")0",
            "K\(carInfoCoreDataModel.plateNumber ?? "")1",
            "K\(carInfoCoreDataModel.plateNumber ?? "")2",
            "K\(carInfoCoreDataModel.plateNumber ?? "")3",
            "K\(carInfoCoreDataModel.plateNumber ?? "")4"
        ]
        
        let imageName1 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-0"
        let imageName2 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-1"
        let imageName3 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-2"
        let imageName4 = "\(carInfoCoreDataModel.id!.uuidString as String)-image-3"
        
        
        if let loadedImage1 = ImageManager.shared.loadImage(withName: imageName1) {
            takedCarPhotos.append(loadedImage1)
        }
        
        if let loadedImage2 = ImageManager.shared.loadImage(withName: imageName2) {
            takedCarPhotos.append(loadedImage2)
        }
        
        if let loadedImage3 = ImageManager.shared.loadImage(withName: imageName3) {
            takedCarPhotos.append(loadedImage3)
        }
        
        if let loadedImage4 = ImageManager.shared.loadImage(withName: imageName4) {
            takedCarPhotos.append(loadedImage4)
        }
    }
    
    private func preparePDF() {
        
        
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(pdfView)
        
        let plateNumber = carInfoCoreDataModel?.plateNumber ?? "-"
        let chassisNumber = carInfoCoreDataModel?.chassisNumber ?? "-"
        let brand = carInfoCoreDataModel?.brand ?? "-"
        let model = carInfoCoreDataModel?.model ?? "-"
        let manufacturingYear = carInfoCoreDataModel?.manufacturingYear ?? "-"
        let km = carInfoCoreDataModel?.km ?? "-"
        let noteText = carInfoCoreDataModel?.noteText ?? "-"
        
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = formatter.string(from: currentDate)
        
        if let path = Bundle.main.path(forResource: "Template", ofType: "pdf"){
            
            pdfDocument = PDFDocument(url: URL(fileURLWithPath: path))
            
            if let page = pdfDocument.page(at: 0) {
                
                addTextAnnotation(textAnnotations: [
                    (CGRect(x: 10, y: 750, width: 120, height: 40), formattedDate),
                    (CGRect(x: 91, y: 685, width: 70, height: 20), plateNumber),
                    (CGRect(x: 260, y: 685, width: 70, height: 20), chassisNumber),
                    (CGRect(x: 430, y: 685, width: 70, height: 20), brand),
                    (CGRect(x: 91, y: 665, width: 70, height: 20), model),
                    (CGRect(x: 260, y: 665, width: 70, height: 20), manufacturingYear),
                    (CGRect(x: 430, y: 665, width: 70, height: 20), km)
                ], page: page)
                
                
                for index in 0..<(takedCarPhotos.count) {
                    let image = takedCarPhotos[index]
                    
                    let imageBounds: CGRect = {
                        switch index {
                        case 0: return CGRect(x: 18, y: 438, width: 124, height: 124)
                        case 1: return CGRect(x: 165, y: 438, width: 124, height: 124)
                        case 2: return CGRect(x: 308, y: 438, width: 124, height: 124)
                        case 3: return CGRect(x: 453, y: 438, width: 124, height: 124)
                        default: return CGRect(x: 18, y: 438, width: 124, height: 124)
                        }
                    }()
                    
                    let imageStamp = ImageStampAnnotation(with: image, forBounds: imageBounds, withProperties: nil)
                    page.addAnnotation(imageStamp)
                }
                
                
                let carType = CarTypeManager.getCarTypeByVersion(carInfoCoreDataModel?.carModel ?? "")
                
                addPhotoAnnotation(imageBounds: CGRect(x: 10, y: 100, width: 400, height: 200), image:  UIImage(named: carType?.damageString ?? "suv/suv_damage")!, page: page)
                
                if let logo = ImageManager.shared.loadImage(withName: "logo") {
                    addPhotoAnnotation(imageBounds: CGRect(x: 260, y: 750, width: 160, height: 80), image:  logo, page: page)
                }
                
                if let data = carInfoCoreDataModel?.pieces {
                    let newPieceList = convertDataToPieces(data: data as! NSData) ?? AppConstants.pieceList
                    var multiplier = 0
                    for piece in newPieceList {
                        if piece.showIndsideBox == true {
                            addTextAnnotation(textAnnotations: [(CGRect(x: 495, y: (135 + (20 * multiplier)), width: 80, height: 15), piece.pieceName)], page: page, size: 8.0)
                            addLabelAnnotation(cgRect: CGRect(x: 470, y: (135 + (20 * multiplier)), width: 15, height: 15), page: page, image: piece.labelImage ?? "labels/orijinal")
                            multiplier += 1
                            
                        } else {
                            if let calculatedArea = PointHelper.calculateCoordinates(for: carType ?? .sedan , pieceName: piece.pieceName) {
                                addLabelAnnotation(cgRect: calculatedArea, page: page, image: piece.labelImage ?? "labels/orijinal")
                            }
                        }
                    }
                }
                
                if let page = pdfDocument.page(at: 1) {
                    
                    addTextAnnotation(textAnnotations: [
                        (CGRect(x: 27, y: 780, width: 120, height: 40), formattedDate),
                        (CGRect(x: 91, y: 720, width: 70, height: 20), plateNumber),
                        (CGRect(x: 260, y: 720, width: 70, height: 20), chassisNumber),
                        
                    ], page: page)
                    
                    
                    for (index, dotText) in dotTexts.prefix(3).enumerated() {
                        var textAnnotations: [(CGRect, String)] = []
                        let yCoordinate: CGFloat = CGFloat(450 - (215 * index))
                        
                        if dotText.count > 12 {
                            let firstPart = Array(dotText.prefix(12))
                            let secondPart = Array(dotText.suffix(from: 12))
                            
                            textAnnotations.append((CGRect(x: 400, y: yCoordinate, width: 65, height: 150), createCombinedText(texts: firstPart, isSecondPart: false)))
                            textAnnotations.append((CGRect(x: 465, y: yCoordinate, width: 65, height: 150), createCombinedText(texts: secondPart, isSecondPart: true)))
                        } else {
                            textAnnotations.append((CGRect(x: 400, y: yCoordinate, width: 65, height: 150), createCombinedText(texts: dotText, isSecondPart: false)))
                        }
                        
                        addTextAnnotation(textAnnotations: textAnnotations, page: page, size: 9)
                    }

                    
//                    addTextAnnotation(textAnnotations: [
//                        (CGRect(x: 400, y: 450, width: 140, height: 150), createCombinedText(texts: dotTexts[0])),
//                        (CGRect(x: 400, y: 235, width: 140, height: 150), createCombinedText(texts: dotTexts[1])),
//                        (CGRect(x: 400, y: 35, width: 140, height: 150), createCombinedText(texts: dotTexts[2]))
//                    ], page: page, size: 9)
                    
                    
                    addPhotoAnnotationByIndex(imageBounds:  CGRect(x: 10, y: 430, width: 400, height: 180), index: 0, page: page)
                    addPhotoAnnotationByIndex(imageBounds: CGRect(x: 10, y: 240, width: 400, height: 180), index: 1, page: page)
                    addPhotoAnnotationByIndex(imageBounds: CGRect(x: 15, y: 30, width: 400, height: 180), index: 2, page: page)
                    
                }
                
                if let page = pdfDocument.page(at: 2) {
                    
                    addTextAnnotation(textAnnotations: [
                        (CGRect(x: 27, y: 780, width: 120, height: 40), formattedDate),
                        (CGRect(x: 91, y: 720, width: 70, height: 20), plateNumber),
                        (CGRect(x: 260, y: 720, width: 70, height: 20), chassisNumber),
                        (CGRect(x: 75, y: 30, width: 400, height: 150), noteText)], page: page)
                    
//                    addTextAnnotation(textAnnotations: [
//                        (CGRect(x: 400, y: 455, width: 140, height: 150), createCombinedText(texts: dotTexts[3])),
//                        (CGRect(x: 400, y: 260, width: 140, height: 150), createCombinedText(texts: dotTexts[4]))
//                    ], page: page, size: 9)
                    
                    let yCoordinates: [CGFloat] = [455, 260]

                    for (index, dotText) in dotTexts[3...4].enumerated() {
                        var textAnnotations: [(CGRect, String)] = []
                        let yCoordinate: CGFloat = yCoordinates[index]

                        if dotText.count > 12 {
                            let firstPart = Array(dotText.prefix(12))
                            let secondPart = Array(dotText.suffix(from: 12))
                            
                            textAnnotations.append((CGRect(x: 400, y: yCoordinate, width: 65, height: 150), createCombinedText(texts: firstPart, isSecondPart: false)))
                            textAnnotations.append((CGRect(x: 465, y: yCoordinate, width: 65, height: 150), createCombinedText(texts: secondPart, isSecondPart: true)))
                        } else {
                            textAnnotations.append((CGRect(x: 400, y: yCoordinate, width: 65, height: 150), createCombinedText(texts: dotText, isSecondPart: false)))
                        }
                        
                        addTextAnnotation(textAnnotations: textAnnotations, page: page, size: 9)
                    }
                    
                    addPhotoAnnotationByIndex(imageBounds: CGRect(x: 10, y: 430, width: 400, height: 180), index: 3, page: page)
                    addPhotoAnnotationByIndex(imageBounds: CGRect(x: 10, y: 240, width: 400, height: 180), index: 4, page: page)
                    
                }
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                pdfView.addGestureRecognizer(tapGesture)
                pdfView.document = pdfDocument
                
            }
        }
    }
    
    private func createCombinedText(texts: [String], isSecondPart: Bool) -> String {
        var result = ""
        let startIndex = isSecondPart ? 13 : 1
        for (index, value) in texts.enumerated() {
             let numberedValue = "\(startIndex + index). \(value)"
             result.append(numberedValue)
             if ((startIndex + index) % 2 == 0) {
                 result.append("\n")
             } else {
                 result.append("    ")
             }
         }
        
        return result
    }
    
    private func addPhotoAnnotationByIndex(imageBounds: CGRect, index: Int, page: PDFPage) {
        if let photo = carImagesWithDots?[index] {
            if let loadedImage = ImageManager.shared.loadImage(withName: photo) {
                let imageCar = loadedImage
                let imageStamp = ImageStampAnnotation(with: imageCar, forBounds: imageBounds, withProperties: nil)
                page.addAnnotation(imageStamp)
            }
        }
    }
    
    private func addPhotoAnnotation(imageBounds: CGRect, image: UIImage, page: PDFPage) {
        let imageStamp = ImageStampAnnotation(with: image, forBounds: imageBounds, withProperties: nil)
        page.addAnnotation(imageStamp)
    }
    
    private func addLabelAnnotation(cgRect: CGRect, page: PDFPage, image: String) {
        if let imageLabel = UIImage(named: image) {
            let imageBounds =  cgRect
            let imageStamp = ImageStampAnnotation(with: imageLabel, forBounds: imageBounds, withProperties: nil)
            page.addAnnotation(imageStamp)
        }
    }
    
    private func addTextAnnotation(textAnnotations: [(CGRect,String)], page: PDFPage, size: CGFloat = 12.0) {
        for (bounds, text) in textAnnotations {
            let textAnnotation = PDFAnnotation(bounds: bounds, forType: .freeText, withProperties: nil)
            textAnnotation.color = .clear
            textAnnotation.font = UIFont.systemFont(ofSize: size)
            textAnnotation.contents = text
            page.addAnnotation(textAnnotation)
        }
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
    
    @objc func saveAndShareAnnotatedPDF(sender: UIBarButtonItem) {
        guard let document = self.pdfDocument else { return }
        
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.overlay.isHidden = false
        self.view.bringSubviewToFront(self.overlay)
        
        // Geçici bir dosya yoluna kaydet
        let tempFilePath = NSTemporaryDirectory().appending("/\(carInfoCoreDataModel?.plateNumber ?? "myexpert").pdf")
        let tempFileURL = URL(fileURLWithPath: tempFilePath)
        
        // PDF'i diske kaydet
        document.write(to: tempFileURL)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.activityIndicator.stopAnimating()
            self.overlay.isHidden = false
            self.view.isUserInteractionEnabled = true
            
            
            // Kaydedilen PDF'i UIActivityViewController ile paylaş
            let activityViewController = UIActivityViewController(activityItems: [tempFileURL], applicationActivities: nil)
            
            // iPad için popover ayarlaması
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            activityViewController.completionWithItemsHandler = { activity, success, items, error in
                // Paylaşım işlemi tamamlandıktan sonra geçici dosyayı sil
                do {
                    try FileManager.default.removeItem(at: tempFileURL)
                    print("Geçici PDF dosyası silindi.")
                } catch {
                    print("Geçici dosya silinirken hata oluştu: \(error)")
                }
            }
            
            // UIActivityViewController'ı sun
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}


class ImageStampAnnotation: PDFAnnotation {
    
    var image: UIImage!
    
    init(with image: UIImage!, forBounds bounds: CGRect, withProperties properties: [AnyHashable : Any]?) {
        super.init(bounds: bounds, forType: PDFAnnotationSubtype.stamp, withProperties: properties)
        
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(with box: PDFDisplayBox, in context: CGContext) {
        
        guard let cgImage = self.image.cgImage else { return }
        
        context.draw(cgImage, in: self.bounds)
        
    }
}
