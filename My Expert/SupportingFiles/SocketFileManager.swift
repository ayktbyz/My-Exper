//
//  SocketFileManager.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 28.01.2024.
//

import Foundation

struct FileTransferMessage: Codable {
    let fileName: String
    let fileType: String
    let data: String
}

class SocketFileManager {

    static let shared = SocketFileManager()
    static var serverConnection = 0

    private init() {}

    func sendData(ipAddress: String, port: UInt32, data: Data, completion: @escaping (Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var readStream: Unmanaged<CFReadStream>?
            var writeStream: Unmanaged<CFWriteStream>?

            CFStreamCreatePairWithSocketToHost(nil, ipAddress as CFString, port, &readStream, &writeStream)

            guard let outputStream = writeStream?.takeRetainedValue() else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }

            if !CFWriteStreamOpen(outputStream) {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }

            defer {
                CFWriteStreamClose(outputStream)
            }
            
            do {
                var bytesRemaining = data.count
                var totalBytesWritten = 0

                while bytesRemaining > 0 {
                    let bytesWritten = try data.withUnsafeBytes { rawBufferPointer -> CFIndex in
                        let buffer = rawBufferPointer.bindMemory(to: UInt8.self).baseAddress! + totalBytesWritten
                        
                        print(SocketFileManager.serverConnection)
                        if(SocketFileManager.serverConnection == 0){
                            SocketFileManager.serverConnection = SocketFileManager.serverConnection + 1
                        } else {
                            completion(false, nil)
                        }
                        
                        let bytesWritten = CFWriteStreamWrite(outputStream, buffer, bytesRemaining)
                       
                        SocketFileManager.serverConnection = 0
                        
                        if bytesWritten < 0 {
                            throw NSError(domain: "SocketFileManagerError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data could not be written to the output stream."])
                        }
                        
                        return bytesWritten
                    }

                    bytesRemaining -= bytesWritten
                    totalBytesWritten += bytesWritten
                }
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }

}

