//
//  UITestingHelper.swift
//  MusicApp
//
//  Created by Steve on 18/08/2023.
//
#if DEBUG

import Foundation

/// Helper struct for simulating values to facilitate UI Testing
struct UITestingHelper {
    
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui-testing")
    }
    
    static var isSearchNetworkingSuccessful: Bool {
        ProcessInfo.processInfo.environment["-search-networking-success"] == "1"
    }
    
    static var isSearchResultsNetworkingSuccessful: Bool {
        ProcessInfo.processInfo.environment["-searchResults-networking-success"] == "1"
    }
}

#endif
