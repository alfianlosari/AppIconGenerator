//
//  AppIcon.swift
//  XCAIconGenerator
//
//  Created by Alfian Losari on 19/03/22.
//

import Foundation
import UIKit

struct AppIcon {
    
    let idiom: Idiom
    let point: CGFloat
    let scale: CGFloat
    let data: Data?
    
    let watchRole: WatchRole?
    let watchSubtype: WatchSubtype?
    
    var filename: String {
        "icon_\(point.formattedString)@\(scale.formattedString)x.png"
    }
    
    var sizename: String {
        "\(point.formattedString)x\(point.formattedString)"
    }
    
    init(idiom: Idiom, point: CGFloat, scale: CGFloat, data: Data? = nil, watchRole: WatchRole? = nil, watchSubtype: WatchSubtype? = nil) {
        self.idiom = idiom
        self.point = point
        self.scale = scale
        self.data = data
        self.watchRole = watchRole
        self.watchSubtype = watchSubtype
    }
    
    var json: [String: Any] {
        var json: [String: Any] = [
            "size": sizename,
            "idiom": idiom.rawValue,
            "filename": filename,
            "scale": "\(scale.formattedString)x"
        ]
        
        if let watchRole = watchRole {
            json["role"] = watchRole.rawValue
        }
        
        if let watchSubtype = watchSubtype {
            json["subtype"] = watchSubtype.rawValue
        }
        
        return json
    }
    
}


extension CGFloat {
    
    var formattedString: String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(Int(self)) : String(format: "%.1f", self)
    }
    
}
