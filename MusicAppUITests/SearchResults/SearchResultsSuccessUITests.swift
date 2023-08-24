//
//  TeacherScreenUITest.swift
//  MusicAppUITests
//
//  Created by Steve on 18/08/2023.
//

import XCTest

class SearchResultsSuccessUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launchEnvironment = ["-searchResults-networking-success":"1"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
    }
    
    func test_grid_has_correct_number_of_items_when_screen_loads() {
        // select first instrument
//        let instrumentsScrollView = app.scrollViews["instrumentsScrollView"]
//        XCTAssertTrue(instrumentsScrollView.waitForExistence(timeout: 5), "The Scroll View should be shown on screen")

//        let instrumentPredicate = NSPredicate(format: "identifier CONTAINS 'item_'")
//        let instrumentItems = instrumentsScrollView.buttons.containing(instrumentPredicate)
//        XCTAssertEqual(instrumentItems.count, 11, "There should be 11 instruments")
//
//        instrumentItems.firstMatch.tap()
//
//        // select first grade
//        let gradesScrollView = app.scrollViews["gradesScrollView"]
//        XCTAssertTrue(gradesScrollView.waitForExistence(timeout: 5), "The Scroll View should be shown on screen")
//
//        let gradePredicate = NSPredicate(format: "identifier CONTAINS 'item_'")
//        let gradeItems = gradesScrollView.buttons.containing(gradePredicate)
//        XCTAssertEqual(gradeItems.count, 12, "There should be 12 grades")
//
//        gradeItems.firstMatch.tap()
//
//
//        let searchButton = app.buttons["searchButton"]
//        searchButton.firstMatch.tap()
        
        
        
//        instrumentsScrollView.buttons["item_1"].firstMatch.tap()
//        gradesScrollView.buttons["item_1"].firstMatch.tap()
        
        
        app.buttons["instrument_1"].firstMatch.tap()
        app.buttons["grade_1"].firstMatch.tap()
        app.buttons["searchButton"].firstMatch.tap()
        
    }
    
}
