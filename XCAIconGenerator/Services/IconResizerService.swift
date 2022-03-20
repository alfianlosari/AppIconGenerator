//
//  IconResizerService.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import Foundation
import UIKit

protocol IconResizerServiceProtocol {
    
    func resizeIcons(from image: UIImage, for appIconType: AppIconType) async throws -> [AppIcon]
    
}

struct IconResizerService: IconResizerServiceProtocol {
    
    func resizeIcons(from image: UIImage, for appIconType: AppIconType) async throws -> [AppIcon] {
        let icons = appIconType.templateAppIcons
        return try await withThrowingTaskGroup(of: AppIcon.self) { group in
            var results = [AppIcon]()
            for icon in icons {
                group.addTask { try await self.iconResizedData(from: image, appIcon: icon) }
            }
            
            for try await iconData in group {
                results.append(iconData)
            }
            
            return results
        }
    }
    
    private func iconResizedData(from image: UIImage, appIcon: AppIcon) async throws -> AppIcon {
        let size = CGSize(width: appIcon.point * appIcon.scale, height: appIcon.point * appIcon.scale)
        guard let thumbnail = await image.byPreparingThumbnail(ofSize: size),
              let data = thumbnail.pngData()
        else {
            throw NSError(domain: "XCA", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail data"])
        }
        return AppIcon(idiom: appIcon.idiom, point: appIcon.point, scale: appIcon.scale, data: data, watchRole: appIcon.watchRole, watchSubtype: appIcon.watchSubtype)
    }
    
}
