//
//  SettingsViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 30.12.2023.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    static let identifier = "SettingsViewController"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImage: UIImageView!
    
    lazy var itemList: [SettingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ayarlar"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.nib(), forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        itemList = UserDefaultsManager.shared.loadSettings()
        
        if let logo = ImageManager.shared.loadImage(withName: "logo") {
            logoImage.image = logo
        }

    }
    
    @IBAction func logoEditClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        
        let item = itemList[indexPath.row]
        cell.label.text = item.title
        cell.subLabel.text = item.value
        cell.saveButton.isHidden = !item.isButtonEnabled
        cell.callback = {
            self.showDialog(position: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
}

extension SettingsViewController {
    
    func showDialog(position: Int) {
        let storyboard = UIStoryboard(name: "InputDialog", bundle: nil)
        let inputDialog = storyboard.instantiateViewController(withIdentifier: InputDialogViewController.identifier) as! InputDialogViewController
        
        inputDialog.modalPresentationStyle = .overFullScreen
        inputDialog.modalTransitionStyle = .crossDissolve
        inputDialog.dialogTitle = itemList[position].title
        
        inputDialog.saveAction = { text in
            self.itemList[position].value = text
            self.tableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
            UserDefaultsManager.shared.saveSettings(self.itemList)

        }
        
        self.present(inputDialog, animated: true)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        let imageName = "logo"
        ImageManager.shared.saveImage(image, withName: imageName)
        
        logoImage.image = image
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
