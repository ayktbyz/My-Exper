//
//  UserDefaultsManager.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 28.01.2024.
//

import Foundation


class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let settingsKey = "settings"

    private init() {}

    func saveSettings(_ settings: [SettingItem]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }

    func loadSettings() -> [SettingItem] {
        let decoder = JSONDecoder()
        if let savedSettings = UserDefaults.standard.object(forKey: settingsKey) as? Data,
           let loadedSettings = try? decoder.decode([SettingItem].self, from: savedSettings) {
            return loadedSettings
        } else {
            return [
                SettingItem(title: "Cihaz Adı:", value: "", isButtonEnabled: false),
                SettingItem(title: "Cihaz Mac Adresi:", value: "", isButtonEnabled: false),
                SettingItem(title: "IP Adresi:", value: "", isButtonEnabled: true),
                SettingItem(title: "İşletme Adı:", value: "", isButtonEnabled: true),
                SettingItem(title: "İşletme Adresi:", value: "", isButtonEnabled: true),
                SettingItem(title: "Şube Numarası:", value: "", isButtonEnabled: true),
                SettingItem(title: "Alt Sınır:", value: "", isButtonEnabled: true),
                SettingItem(title: "Üst Sınır:", value: "", isButtonEnabled: true)
            ]
        }
    }
    
    func loadLimits() -> (altSinir: String?, ustSinir: String?) {
        let settings = loadSettings()
        let altSinir = settings.first { $0.title == "Alt Sınır" }?.value
        let ustSinir = settings.first { $0.title == "Üst Sınır" }?.value
        return (altSinir, ustSinir)
    }
    
    func getIPAdress() -> (String?) {
        let settings = loadSettings()
        let ipAdress = settings.first { $0.title == "IP Adresi:" }?.value
        return (ipAdress)
    }
    
    func getDeviceName() -> (String?) {
        let settings = loadSettings()
        let ipAdress = settings.first { $0.title == "Cihaz Adı:" }?.value
        return (ipAdress)
    }
    
    func getMACAdress() -> (String?) {
        let settings = loadSettings()
        let ipAdress = settings.first { $0.title == "Cihaz Mac Adresi:" }?.value
        return (ipAdress)
    }
}
