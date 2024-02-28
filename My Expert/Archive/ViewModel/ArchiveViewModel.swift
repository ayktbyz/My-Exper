//
//  ArchiveViewModel.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 2.01.2024.
//

import Foundation
import CoreData
import UIKit


class ArchiveViewModel {
    var userCarInfos: [UserCarInfo] = []

    func fetchAllUserCarInfo() {
        userCarInfos = UserCarInfoManager.shared.fetchAllUserCarInfo() ?? []
    }
}
