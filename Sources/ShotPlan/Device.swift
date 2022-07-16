//
//  File.swift
//  
//
//  Created by Devran on 14.07.22.
//

import Foundation

struct Device: Codable {
    let simulatorName: String
    let displaySize: String?
    let homeStyle: HomeStyle?
    var idiom: Idiom? {
        return Idiom.allCases.first { idiom in
            simulatorName.contains(idiom.description)
        }
    }
    
    enum Idiom: String, CaseIterable, Codable, CustomStringConvertible {
        case tablet
        case phone
        case watch
        case tv
        
        var description: String {
            switch self {
            case .tablet:
                return "iPad"
            case .phone:
                return "iPhone"
            case .watch:
                return "Apple Watch"
            case .tv:
                return "Apple TV"
            }
        }
    }
    
    enum HomeStyle: String, Codable, CustomStringConvertible {
        case button
        case indicator
        
        var description: String {
            switch self {
            case .indicator:
                return "Home Indicator"
            case .button:
                return "Home Button"
            }
        }
    }
    
    var description: String {
        return "\(idiom?.description ?? "") \(displaySize ?? "")-inch with \(homeStyle?.description ?? "")"
    }
}
