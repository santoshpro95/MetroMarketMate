//
//  Item.swift
//  MetroMarketMate
//
//  Created by Santosh Kumar on 03/01/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
