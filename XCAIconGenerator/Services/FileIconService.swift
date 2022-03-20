//
//  FileIconService.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import Foundation

protocol FileIconServiceProtocol {
    
    func deleteExistingTemporaryDirectoryURL()
    func saveIconsToTemporaryDir(icons: [AppIcon], appIconType: AppIconType) async throws
    func archiveTemporaryDirectoryToURL() async throws -> URL
}

struct FileIconService: FileIconServiceProtocol {
    
    let coordinator = NSFileCoordinator()
    let fileManager = FileManager.default
    
    private var temporaryDirectoryURL: URL {
        fileManager.temporaryDirectory.appendingPathComponent("AppIcons")
    }
    
    func deleteExistingTemporaryDirectoryURL() {
        try? fileManager.removeItem(at: temporaryDirectoryURL)
    }
    
    func archiveTemporaryDirectoryToURL() async throws -> URL {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            self.coordinator.coordinate(readingItemAt: temporaryDirectoryURL, options: [.forUploading], error: nil) { zipURL in
                let destinationURL = self.temporaryDirectoryURL.appendingPathComponent("app_icons.zip")
                do {
                    try self.fileManager.moveItem(at: zipURL, to: destinationURL)
                    continuation.resume(returning: destinationURL)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func saveIconsToTemporaryDir(icons: [AppIcon], appIconType: AppIconType) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
             
                let dirURL = self.temporaryDirectoryURL
                    .appendingPathComponent(appIconType.folderName)
                    .appendingPathComponent("AppIcon.appiconset")
                try self.fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
                for icon in icons {
                    let url = dirURL.appendingPathComponent(icon.filename)
                    try icon.data?.write(to: url)
                }
                
                let jsonData = try JSONSerialization.data(withJSONObject: appIconType.json, options: [.prettyPrinted, .sortedKeys])
                try jsonData.write(to: dirURL.appendingPathComponent("Contents.json"))
                continuation.resume()
            } catch let error as NSError {
                continuation.resume(throwing: error)
            }
        }
    }
    
}

