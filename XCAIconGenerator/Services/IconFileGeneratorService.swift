//
//  IconFileGeneratorService.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import Foundation
import UIKit

protocol IconFileGeneratorServiceProtocol {
    
    func generateIconsURL(for appIconTypes: [AppIconType], with image: UIImage) async throws -> URL
    
}

struct IconFileGeneratorService: IconFileGeneratorServiceProtocol {
    
    let fileService: FileIconServiceProtocol
    let resizeService: IconResizerServiceProtocol
    
    func generateIconsURL(for appIconTypes: [AppIconType], with image: UIImage) async throws -> URL {
        self.fileService.deleteExistingTemporaryDirectoryURL()
        
        for appIconType in appIconTypes {
            let icons = try await self.resizeService.resizeIcons(from: image, for: appIconType)
            try await self.fileService.saveIconsToTemporaryDir(icons: icons, appIconType: appIconType)
        }
        
        let url = try await self.fileService.archiveTemporaryDirectoryToURL()
        return url
    }
    
}
