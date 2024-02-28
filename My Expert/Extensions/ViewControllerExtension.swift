//
//  ViewControllerExtension.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 6.01.2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    func saveCoreDataChanges() {
        do {
            let appDelegete = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegete.persistentContainer.viewContext
            try context.save()
        } catch {
            print("Error durin saving changes to core data.")
        }
    }
}
