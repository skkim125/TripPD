//
//  ImageManager.swift
//  TripPD
//
//  Created by 김상규 on 9/18/24.
//

import Foundation

final class ImageManager {
    static let shared = ImageManager()
    private init() { }
    
    private let fileManager = FileManager.default
    
    func saveImage(imageData: Data?) -> String? {
        guard let imageData = imageData else { return nil }
        
        guard let documentDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let folderURL = documentDirectory.appendingPathComponent("TripPD_CoverImage")
        print(folderURL)

        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
        } catch let error {
            print("Create file error: \(error.localizedDescription)")
        }
        
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = folderURL.appendingPathComponent(fileName)
        print(fileURL)
        
        do {
            try imageData.write(to: fileURL)
        } catch {
            print("file save error", error)
        }
        
        return fileName
    }
    
    func loadImage(imageName: String?) -> Data? {
        guard let documentDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let folderURL = documentDirectory.appendingPathComponent("TripPD_CoverImage")
        guard let imageName = imageName else { return nil }
        let fileURL = folderURL.appendingPathComponent(imageName)
        print(fileURL.path())
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let imageData = try Data(contentsOf: fileURL)
                return imageData
                
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func removeImage(imageName: String?) {
        guard let documentDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let folderURL = documentDirectory.appendingPathComponent("TripPD_CoverImage")
        
        guard let imageName = imageName else { return }
        let fileURL = folderURL.appendingPathComponent(imageName)
//        print(fileURL)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(atPath: fileURL.path())
                
            } catch {
                print("file remove error", error)
            }
        } else {
            print("file no exist")
        }
    }
}
