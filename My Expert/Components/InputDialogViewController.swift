//
//  InputDialogViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class InputDialogViewController: UIViewController {
    
    static let identifier = "InputDialogViewController"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var alertView: UIView!
    
    var dialogTitle: String?
    
    var saveAction: ((String) -> ())? = nil

    
    let grayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }

    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        if let title = dialogTitle {
                titleLabel.text = title
            }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        saveAction?(input.text ?? "")
        self.dismiss(animated: true)
    }
}
