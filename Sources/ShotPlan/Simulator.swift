//
//  Simulator.swift
//  
//
//  Created by Devran on 14.07.22.
//

import Foundation

struct Simulator {
    static func defaultDate(timeZone: String) -> Date {
        let timeZone = TimeZone(identifier: timeZone) ?? .current
        let dateComponents = DateComponents(
            calendar: Calendar.current,
            timeZone: timeZone,
            year: 2007,
            month: 01,
            day: 09,
            hour: 9,
            minute: 41,
            second: 0,
            nanosecond: 0)
        guard dateComponents.isValidDate, let importantDate = dateComponents.date else {
            fatalError("Date Invalid.")
        }
        return importantDate
    }
    
    static func defaultDateString(timeZone: String) -> String {
        defaultDate(timeZone: timeZone).ISO8601Format()
    }
    
    static func setStatusBar(device: Device, timeZone: String) {
        clearStatusBar(simulatorName: device.simulatorName)
        switch device.idiom {
        case .tablet:
            setStatusBarPad(simulatorName: device.simulatorName, timeZone: timeZone)
        case .phone:
            switch device.homeStyle {
            case .indicator:
                setStatusBarPhoneWithHomeIndicator(simulatorName: device.simulatorName, timeZone: timeZone)
            default:
                setStatusBarPhoneWithHomeButton(simulatorName: device.simulatorName, timeZone: timeZone)
            }
        default:
            break
        }
    }
    
    static func findUDID(from simulatorName: String) -> String? {
        guard let jsonString = try? Shell.call("xcrun simctl list --json") else { return nil }
        guard let data = jsonString.data(using: .utf8) else { fatalError() }
        guard let knownSimulators = try? JSONDecoder().decode(XcodeSimulator.self, from: data) else { fatalError() }
        return knownSimulators.devices.values.flatMap { $0 }.first { $0.name == simulatorName }?.udid
    }
    
    static func boot(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl boot \(simulatorName.quoted())")
    }
    
    static func shutdown(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl shutdown \(simulatorName.quoted())")
    }
    
    static func clearStatusBar(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) clear")
    }
    
    static func setStatusBarPhoneWithHomeButton(simulatorName: String, timeZone: String) {
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) override --time \(defaultDateString(timeZone: timeZone).quoted()) --wifiBars 3 --cellularBars 4 --operatorName \"\"")
    }
    
    static func setStatusBarPhoneWithHomeIndicator(simulatorName: String, timeZone: String) {
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) override --time \(defaultDateString(timeZone: timeZone).quoted()) --wifiBars 3 --cellularBars 4")
    }
    
    static func setStatusBarPad(simulatorName: String, timeZone: String) {
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) override --time \(defaultDateString(timeZone: timeZone).quoted()) --wifiBars 3 --wifiMode active")
        hideDate(simulatorName: simulatorName)
    }
    
    static func hideDate(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl spawn \(simulatorName.quoted()) defaults write com.apple.UIKit StatusBarHidesDate 1")
    }
    
    static func setLocalization(simulatorName: String, locale: String = "en_US", language: String = "en") {
        if let udid = Simulator.findUDID(from: simulatorName) {
            // Boot
            // If the simulator was never used before, you have to boot it at least once, so that changes can be applied.
            Simulator.shutdown(simulatorName: simulatorName)
            Simulator.boot(simulatorName: simulatorName)
            
            // Change Locale and Language
            let _ = try? Shell.call("plutil -replace AppleLocale -string \"\(locale)\" ~/Library/Developer/CoreSimulator/Devices/\(udid)/data/Library/Preferences/.GlobalPreferences.plist")
            let _ = try? Shell.call("plutil -replace AppleLanguages -json \"[\\\"\(language)\\\"]\" ~/Library/Developer/CoreSimulator/Devices/\(udid)/data/Library/Preferences/.GlobalPreferences.plist")
            
            // Boot again
            Simulator.shutdown(simulatorName: simulatorName)
            Simulator.boot(simulatorName: simulatorName)
        }
    }
}
