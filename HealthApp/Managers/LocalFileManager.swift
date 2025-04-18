//
//  LocalFileManager.swift
//  HealthApp
//
//  Created by Александр Потёмкин on 02.04.2025.
//

import Foundation

class LocalFileManager {

    static let instance = LocalFileManager()
    
    private init() {}
    
    // MARK: - Public Methods

    func saveData<T: Codable>(records: [T], folderName: String, fileName: String) {
        createFolderIfNeeded(folderName: folderName)

        guard let url = getURLForFile(fileName: fileName, folderName: folderName) else {
            print("Error: Unable to get URL for file.")
            return
        }

        do {
            let data = try JSONEncoder().encode(records)
            try data.write(to: url, options: .atomic)
        } catch {
            print("Error saving records. FileName: \(fileName). \(error.localizedDescription)")
        }
    }

    func loadData<T: Codable>(folderName: String, fileName: String) -> [T] {
        guard let url = getURLForFile(fileName: fileName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("Error loading records. FileName: \(fileName). \(error.localizedDescription)")
            return []
        }
    }

    func clearData(folderName: String, fileName: String) {
        guard let url = getURLForFile(fileName: fileName, folderName: folderName) else {
            print("Error: Unable to get URL for file.")
            return
        }

        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error clearing data. FileName: \(fileName). \(error.localizedDescription)")
        }
    }


    // MARK: - Private Methods
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {
            print("Error: Unable to get URL for folder.")
            return
        }

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory. FolderName: \(folderName). \(error.localizedDescription)")
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }

    private func getURLForFile(fileName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(fileName)
    }
    
}
