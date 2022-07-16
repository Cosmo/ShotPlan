//
//  Configuration.swift
//  
//
//  Created by Devran on 14.07.22.
//

import Foundation

extension ShotPlan {
    struct Configuration: Codable {
        let scheme: String
        let testPlan: String
        let devices: [Device]
        let localizeSimulator: Bool
    }
}

extension ShotPlan.Configuration {
    static let defaultFileName: String = "ShotPlan.json"
    static let defaultSchemeName: String = "YOUR_SCHEME"
    static let defaultTestPlan: String = "YOUR_TESTPLAN"
    static let defaultDevices: [Device] = [
        Device(simulatorName: "iPhone 11 Pro Max", displaySize: "6.5", homeStyle: .indicator),
        Device(simulatorName: "iPhone 8 Plus", displaySize: "5.5", homeStyle: .button),
        Device(simulatorName: "iPad Pro (12.9-inch) (5th generation)", displaySize: "12.9", homeStyle: .indicator),
        // Device(simulatorName: "iPad Pro (12.9-inch) (2th generation)", displaySize: "12.9", homeStyle: .button),
    ]
    
    static func defaultConfiguration(schemeName: String?, testPlan: String?) -> Self {
        return Self(scheme: schemeName ?? defaultSchemeName,
                     testPlan: testPlan ?? defaultTestPlan,
                    devices: defaultDevices, localizeSimulator: true)
    }
    
    var data: Data {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        guard let encodedData = try? jsonEncoder.encode(self) else { fatalError() }
        return encodedData
    }
}

extension ShotPlan.Configuration {
    static var configurationFileURL: URL {
        return Project.currentDirectoryURL.appendingPathComponent(defaultFileName)
    }
    
    static var exists: Bool {
        return Project.fileManager.fileExists(atPath: configurationFileURL.path)
    }
    
    static func save(contents: Data) {
        Project.fileManager.createFile(atPath: configurationFileURL.path, contents: contents)
    }
    
    static func load() throws -> Self {
        return try JSONDecoder().decode(self, from: Data(contentsOf: configurationFileURL))
    }
}
