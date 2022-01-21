//
//  LocalFileManager.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation
import SwiftUI

/// Manages thumbnail images from Coins to prevent re-downloading
class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    /// Saves an image to cachesDirectory

    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        
        guard
            let data = image.pngData(),
            let url = getURLFromImage(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            try data.write(to: url)
        } catch {
            print("Error saving image [\(imageName)]: \(error)")
        }
    }
    
    /// Loads an image from a folder

    func loadImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLFromImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    /// Creates a folder if it does not exist

    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory [\(folderName)]: \(error)")
            }
        }
    }
    
    /// Gets the path for a folder name if it exists in cachesDirectory

    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    /// Creates the path for a specific image in a folder

    private func getURLFromImage(imageName: String, folderName: String) -> URL? {
        guard let folder = getURLForFolder(folderName: folderName) else { return nil }
        return folder.appendingPathComponent(imageName + ".png")
    }
}
