//
//  Simulator.swift
//  
//
//  Created by Devran on 14.07.22.
//

import Foundation

struct Simulator {
    static let defaultTime: String = "9:41"
    static let defaultTimeLong: String = "9:41 AM"
    
    static func setStatusBar(device: Device) {
        switch device.idiom {
        case .tablet:
            Simulator.setStatusBarPad(simulatorName: device.simulatorName)
        case .phone:
            switch device.homeStyle {
            case .indicator:
                Simulator.setStatusBarPhoneWithHomeIndicator(simulatorName: device.simulatorName)
            default:
                Simulator.setStatusBarPhoneWithHomeButton(simulatorName: device.simulatorName)
            }
        default:
            break
        }
    }
    
    static func boot(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl boot \(simulatorName.quoted())")
    }
    
    static func setStatusBarPhoneWithHomeButton(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) clear")
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) override --time \(defaultTimeLong.quoted()) --wifiBars 3 --cellularBars 4 --operatorName \"\"")
        let _ = try? Shell.call("xcrun simctl spawn \(simulatorName.quoted()) defaults write com.apple.springboard SBShowBatteryPercentage 1")
    }
    
    static func setStatusBarPhoneWithHomeIndicator(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) clear")
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) override --time \(defaultTime.quoted()) --wifiBars 3 --cellularBars 4")
    }
    
    static func setStatusBarPad(simulatorName: String) {
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) clear")
        let _ = try? Shell.call("xcrun simctl status_bar \(simulatorName.quoted()) override --time \(defaultTimeLong.quoted()) --wifiBars 3 --wifiMode active")
        let _ = try? Shell.call("xcrun simctl spawn \(simulatorName.quoted()) defaults write com.apple.springboard SBShowBatteryPercentage 1")
        let _ = try? Shell.call("xcrun simctl spawn \(simulatorName.quoted()) defaults write com.apple.UIKit StatusBarHidesDate 1")
    }
}
