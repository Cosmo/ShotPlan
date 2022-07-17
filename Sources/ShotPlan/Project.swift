//
//  Project.swift
//  
//
//  Created by Devran on 16.07.22.
//

import Foundation

struct Project {
    static let fileManager = FileManager()
    
    static var currentDirectoryURL: URL {
        return URL(fileURLWithPath: fileManager.currentDirectoryPath)
    }
    
    static var targetDirectoryURL: URL {
        return currentDirectoryURL.appendingPathComponent("Screenshots", isDirectory: true)
    }
    
    static var derivedDataDirectoryURL: URL {
        return fileManager.temporaryDirectory.appendingPathComponent("ShotPlan-DerivedData", isDirectory: true)
    }
}
