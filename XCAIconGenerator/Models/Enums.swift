//
//  Enums.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import Foundation

enum AppIconType {
    
    case iPhoneAndiPad
    case iphone
    case ipad
    case mac
    case appleWatch
    
    var templateAppIcons: [AppIcon] {
        switch self {
        case .iPhoneAndiPad:
            return AppIconType.iphone.templateAppIcons + AppIconType.ipad.templateAppIcons.dropLast()
            
        case .iphone:
            return  [
                .init(idiom: .iphone, point: 20, scale: 2),
                .init(idiom: .iphone, point: 20, scale: 3),
                .init(idiom: .iphone,point: 29, scale: 2),
                .init(idiom: .iphone,point: 29, scale: 3),
                .init(idiom: .iphone,point: 40, scale: 2),
                .init(idiom: .iphone,point: 40, scale: 3),
                .init(idiom: .iphone,point: 60, scale: 2),
                .init(idiom: .iphone,point: 60, scale: 3),
                .init(idiom: .iosMarketing, point: 1024, scale: 1)
            ]
        case .ipad:
            return [
                .init(idiom: .ipad, point: 20, scale: 1),
                .init(idiom: .ipad, point: 20, scale: 2),
                .init(idiom: .ipad, point: 29, scale: 1),
                .init(idiom: .ipad, point: 29, scale: 2),
                .init(idiom: .ipad, point: 40, scale: 1),
                .init(idiom: .ipad, point: 40, scale: 2),
                .init(idiom: .ipad, point: 76, scale: 1),
                .init(idiom: .ipad, point: 76, scale: 2),
                .init(idiom: .ipad, point: 83.5, scale: 2),
                .init(idiom: .iosMarketing, point: 1024, scale: 1)
            ]
            
        case .mac:
            return [
                .init(idiom: .mac, point: 16, scale: 1),
                .init(idiom: .mac, point: 16, scale: 2),
                .init(idiom: .mac, point: 32, scale: 1),
                .init(idiom: .mac, point: 32, scale: 2),
                .init(idiom: .mac, point: 128, scale: 1),
                .init(idiom: .mac, point: 128, scale: 2),
                .init(idiom: .mac, point: 256, scale: 1),
                .init(idiom: .mac, point: 256, scale: 2),
                .init(idiom: .mac, point: 512, scale: 1),
                .init(idiom: .mac, point: 512, scale: 2)
            ]
        case .appleWatch:
            return [
                .init(idiom: .watch, point: 24, scale: 2, watchRole: .notificationCenter, watchSubtype: ._38mm),
                .init(idiom: .watch, point: 27.5, scale: 2, watchRole: .notificationCenter, watchSubtype: ._42mm),
                .init(idiom: .watch, point: 29, scale: 2, watchRole: .companionSettings),
                .init(idiom: .watch, point: 29, scale: 3, watchRole: .companionSettings),
                .init(idiom: .watch, point: 33, scale: 2, watchRole: .notificationCenter, watchSubtype: ._45mm),
                .init(idiom: .watch, point: 40, scale: 2, watchRole: .appLauncher, watchSubtype: ._38mm),
                .init(idiom: .watch, point: 44, scale: 2, watchRole: .appLauncher, watchSubtype: ._40mm),
                .init(idiom: .watch, point: 46, scale: 2, watchRole: .appLauncher, watchSubtype: ._41mm),
                .init(idiom: .watch, point: 50, scale: 2, watchRole: .appLauncher, watchSubtype: ._44mm),
                .init(idiom: .watch, point: 51, scale: 2, watchRole: .appLauncher, watchSubtype: ._45mm),
                .init(idiom: .watch, point: 86, scale: 2, watchRole: .quickLook, watchSubtype: ._38mm),
                .init(idiom: .watch, point: 98, scale: 2, watchRole: .quickLook, watchSubtype: ._42mm),
                .init(idiom: .watch, point: 108, scale: 2, watchRole: .quickLook, watchSubtype: ._44mm),
                .init(idiom: .watch, point: 117, scale: 2, watchRole: .quickLook, watchSubtype: ._45mm),
                .init(idiom: .watchMarketing, point: 1024, scale: 1)
            ]
        }
    }
    
    var folderName: String {
        switch self {
        case .iPhoneAndiPad,
             .iphone,
             .ipad:
            return "iOS"
        case .mac:
            return "Mac"
        case .appleWatch:
            return "Watch"
        }
    }
    
    var json: [String: Any] {
        [
            "images": templateAppIcons.map { $0.json },
            "info": [
                "version": 1,
                "author": "xcode"
            ],
        ]
    }
}


enum Idiom: String {
    
    case iphone
    case ipad
    case iosMarketing = "ios-marketing"
    case mac
    case watch
    case watchMarketing = "watch-marketing"
    
}


enum WatchRole: String {
    
    case notificationCenter
    case appLauncher
    case quickLook
    case companionSettings
    
}

enum WatchSubtype: String {
        
    case _38mm = "38mm"
    case _40mm = "40mm"
    case _41mm = "41mm"
    case _42mm = "42mm"
    case _44mm = "44mm"
    case _45mm = "45mm"
}
