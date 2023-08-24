//
//  SearchResultsFailureUITest.swift
//  MusicAppUITests
//
//  Created by Steve on 18/08/2023.
//

import XCTest

//final class SearchResultsFailureUITests: XCTestCase {
//
//    private var app: XCUIApplication!
//    
//    override func setUp() {
//        continueAfterFailure = false
//        app = XCUIApplication()
//        app.launchArguments = ["-ui-testing"]
//        app.launchEnvironment = ["-searchResults-networking-success":"0"]
//        app.launch()
//    }
//    
//    override func tearDown() {
//        app = nil
//    }
//    
//    func test_grid_has_correct_number_of_items_when_screen_loads() {
//        
//        let alert = app.alerts.firstMatch
//        XCTAssertTrue(alert.waitForExistence(timeout: 3), "There should be an alert on the screen")
//        
//        XCTAssertTrue(alert.staticTexts["URL isn't valid"].exists)
//        XCTAssertTrue(alert.buttons["Retry"].exists)
//        
//    }
//}
