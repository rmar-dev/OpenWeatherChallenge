//
//  String+removeAfter.swift
//  OpenWeatherChallenge
//
//  Created by Ricardo Rabeto on 29/02/2020.
//  Copyright © 2020 Ricardo Rabeto. All rights reserved.
//

import Foundation

extension String {
    func removeAfter(char: String) -> String {
        if let dotRange = self.range(of: char) {
            return "\(self[dotRange.lowerBound...])"
        }else {
            return self
        }
    }
}
