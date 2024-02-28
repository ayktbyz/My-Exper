//
//  DeviceManager.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 31.01.2024.
//

import Foundation

class DeviceManager {
    
    static let shared = DeviceManager()
    private let strMessage = "https://mates.com.tr/android_connect/text.txt"
    
    private init() {}
    
    func processMACAddresses(selectedMac: String, completion: @escaping (Bool) -> Void) {
        fetchTextFromURL(strMessage) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let result):
                    let storedMacs = result.split(separator: "\n").map(String.init)
                    let macExists = storedMacs.contains(selectedMac)
                    
                     if macExists {
                        var items = UserDefaultsManager.shared.loadSettings()
                        
                        if let macIndex = items.firstIndex(where: { $0.title == "Cihaz Mac Adresi:" }) {
                            items[macIndex].value = selectedMac
                        }
                        
                        if let deviceNameIndex = items.firstIndex(where: { $0.title == "Cihaz Adı:" }) {
                            items[deviceNameIndex].value = "MTS 4500"
                        }
                        
                        UserDefaultsManager.shared.saveSettings(items)
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func fetchTextFromURL(_ urlString: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data, let string = String(data: data, encoding: .utf8) else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to read data"])))
                    return
                }
                
                completion(.success(string))
            }
        }
        
        task.resume()
    }

}

