//
//  CastTest.swift
//  MoviDBTests
//
//  Created by Nitesh Singh on 05/07/22.
//

import Foundation
import XCTest
@testable import MoviDB

class CastTests: XCTestCase {
    
    let cast1 = Cast(id: 1, name: "Nitesh", profile_path: "https", character: "1223")
    let cast2 = Cast(id: 1, name: "Nitesh", profile_path: "http", character: "1223")
    let cast3 = Cast(id: 2, name: "Nitesh", profile_path: "https", character: "1223")
    
    func test_CastHashable() {
        XCTAssertEqual(cast1.hashValue, cast2.hashValue)
    }
    
    func test_CastEquality() {
        XCTAssertEqual(cast1, cast2)
    }
    
    func test_CastImagePathGeneration() throws {
        XCTAssertEqual(cast1.imagePath, URL(string: AppConstants.imageBaseURL + cast1.profile_path!))
    }
}
