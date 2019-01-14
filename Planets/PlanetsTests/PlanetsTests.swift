//
//  PlanetsTests.swift
//  PlanetsTests
//
//  Created by Pradeep K. Deshmukh on 05/01/19.
//  Copyright © 2019 Pradeep K. Deshmukh. All rights reserved.
//

import XCTest
@testable import Planets

class PlanetsTests: XCTestCase {

    var totalCount = 0
    override func setUp() {
    
        // Unit Test sample  - Check if records exists in coredata
        print("Find no of records in coredata.")
        CoredataManager().fetchRecords { (planets: [Planet]) in
            totalCount = planets.count
        }
        
        if (totalCount > 0) {
            print("Total Records found are : \(totalCount)")
        } else {
            print("No Records found")
        }
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func totalRecordsInCoredata() {
        // Check record count > 0 or not
        XCTAssertTrue(totalCount > 0)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
