//
//  HiredManager.swift
//  Hired
//
//  Created by Zeeshan Khan on 17/08/2020.
//  Copyright © 2020 Zeeshan Khan. All rights reserved.
//

import Foundation

public class HiredManager {
    public init() {
        
    }
    
    public func getAllTopics() -> Data? {
        guard let url = Bundle.module.url(forResource: "Content", withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
