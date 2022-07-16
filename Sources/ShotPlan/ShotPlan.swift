import Foundation
import ArgumentParser

@main
struct ShotPlan: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility creating automated screenshots with Xcode Test Plans.",
        subcommands: [Init.self, Run.self, Debug.self],
        defaultSubcommand: Run.self)
    
    mutating func run() {
    }
}

extension ShotPlan {
    struct Run: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Starts creating screenshots based on your configuration.")
        
        @Option(name: .short, help: "Name of your project scheme.")
        var schemeName: String?
        
        @Option(name: .short, help: "Name of your Xcode Test Plan.")
        var testPlan: String?
        
        mutating func run() {
            let configurationFromFile = try? Configuration.load()
            
            guard let schemeName = schemeName ?? configurationFromFile?.scheme else {
                print("\(Configuration.defaultSchemeName) not found. Create a configuration by running 'shotplan init'")
                return
            }
            
            guard let testPlan = testPlan ?? configurationFromFile?.testPlan else {
                print("\(Configuration.defaultSchemeName) not found. Create a configuration by running 'shotplan init'")
                return
            }
            
            let devices = configurationFromFile?.devices ?? Configuration.defaultDevices
            
            guard let localizeSimulator = configurationFromFile?.localizeSimulator else {
                print("\(Configuration.defaultSchemeName) not found. Create a configuration by running 'shotplan init'")
                return
            }
            
            let configuration = Configuration(scheme: schemeName, testPlan: testPlan, devices: devices, localizeSimulator: localizeSimulator)
            let targetFolder = Project.targetDirectoryURL.relativePath
            let derivedDataPath = Project.derivedDataDirectoryURL.relativePath
            
            for device in devices {
                let screenshotsPath = "\(targetFolder)/\(device.description)/\(device.simulatorName)"
                print("Starting Simulator: \(device.simulatorName)")
                Simulator.boot(simulatorName: device.simulatorName)
                print("Simulator started.")
                
                print("Setting Status Bar …")
                Simulator.setStatusBar(device: device)
                print("Status Bar set.")
                
                print("Deleting Derived Data …")
                let _ = try? Shell.call("rm -rf \(derivedDataPath.quoted())")
                
                print("Creating Screenshots Directory …")
                let _ = try? Shell.call("mkdir -p \(screenshotsPath.quoted())")
                
                print("Running Tests …")
                let _ = try? Shell.call("xcodebuild test -scheme \(configuration.scheme) -destination \"platform=iOS Simulator,name=\(device.simulatorName)\" -testPlan \(configuration.testPlan) -derivedDataPath \(derivedDataPath.quoted())")
                
                print("Copying Screenshots …")
                let _ = try? Shell.call("find \"\(derivedDataPath)/Logs/Test\" -maxdepth 1 -type d -exec xcparse screenshots {} \(screenshotsPath.quoted()) \\;")
                
                //    run("xcrun simctl shutdown \"\(device.simulatorName)\"")
            }
            
        }
    }
}

extension ShotPlan {
    struct Init: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Creates a configuration file.")
        
        @Option(name: .short, help: "Name of your project scheme.")
        var schemeName: String?
        
        @Option(name: .short, help: "Name of your Xcode Test Plan.")
        var testPlan: String?
        
        mutating func run() {
            print("Creating default configuration …")
            
            let defaultConfiguration = Configuration.defaultConfiguration(
                schemeName: schemeName,
                testPlan: testPlan)
            Configuration.save(contents: defaultConfiguration.data)
            
            if Configuration.exists {
                print("\(Configuration.defaultFileName) created.")
                print("Call 'shotplan run' command to start creating screenshots.")
            }
        }
    }
}


extension ShotPlan {
    struct Debug: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Debug.")
        
        mutating func run() {
            
        }
    }
}
