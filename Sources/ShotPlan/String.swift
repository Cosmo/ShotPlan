//
//  String.swift
//  
//
//  Created by Devran on 14.07.22.
//

import Foundation

extension String {
    func quoted() -> String {
        return "\u{22}\(self)\u{22}"
    }
}
