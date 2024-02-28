//
//  ViewController.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 28.12.2023.
//

import UIKit

class HomePageViewController: UIViewController {
    
    static let identifier = "HomePageViewController"
    
    @IBOutlet weak var testStackView: UIStackView!
    @IBOutlet weak var archiveStackView: UIStackView!
    @IBOutlet weak var settingsStackView: UIStackView!
    @IBOutlet weak var bluetoothStackView: UIStackView!
    @IBOutlet weak var helpStackView: UIStackView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addTapGesture(to: testStackView, withTag: 1)
        addTapGesture(to: archiveStackView, withTag: 2)
        addTapGesture(to: bluetoothStackView, withTag: 3)
        addTapGesture(to: settingsStackView, withTag: 4)
        addTapGesture(to: helpStackView, withTag: 5)
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let logo = ImageManager.shared.loadImage(withName: "logo") {
            logoImageView.image = logo
        }
    }

    private func addTapGesture(to stackView: UIStackView, withTag tag: Int) {
          let tap = UITapGestureRecognizer(target: self, action: #selector(stackViewTapped(sender:)))
          stackView.tag = tag
          stackView.addGestureRecognizer(tap)
    }
    
    @objc private func stackViewTapped(sender: UITapGestureRecognizer) {
           if let tag = sender.view?.tag {
               switch tag{
               case 1:
                   performSegue(withIdentifier: "navigateToTest", sender: nil)
               case 2:
                   performSegue(withIdentifier: "navigateToArchive", sender: nil)
               case 3:
                   navigateToBluetooth()
               case 4:
                   navigateToSettings()
               case 5:
                   performSegue(withIdentifier: "navigateToHelp", sender: nil)
               default:
                   break
               }
           }
    }
    
    private func navigateToSettings() {
        if let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: SettingsViewController.identifier) as? SettingsViewController {
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    private func navigateToBluetooth() {
        if let vc = UIStoryboard(name: "BluetoothView", bundle: nil).instantiateViewController(withIdentifier: BluetoothViewController.identifier) as? BluetoothViewController {
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
}

