//
//  FileManager+Extension.swift
//  BranchTalk
//
//  Created by 황인호 on 2/19/24.
//

import UIKit

extension ViewModelType {
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("삭제됨")
        } catch {
            print("삭제안됨")
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "star.fill")! }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return UIImage()
        }
    }
    
    func saveImageToDocument(fileName: String, image: UIImage?) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        print(fileURL)
        guard let data = image?.jpegData(compressionQuality: 1) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
}
