//
//  NoteViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 7.01.2024.
//

import UIKit

class NoteViewController: BaseViewController {

    @IBOutlet weak var textView: UITextView!
    
    var carInfoCoreDataModel: UserCarInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 12
        
        if let text = carInfoCoreDataModel?.noteText {
            textView.text = text
        }
        
        title = "Notlar"
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        carInfoCoreDataModel?.noteText = textView.text
        self.navigationController?.popViewController(animated: true)
    }
    
}
