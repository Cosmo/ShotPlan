//
//  Xcode.swift
//  
//
//  Created by Devran on 16.07.22.
//

import Foundation

struct XcodeSimulator: Codable {
    let devices: [String: [Device]]
    
    struct Device: Codable {
        let name: String
        let udid: String
    }
}

