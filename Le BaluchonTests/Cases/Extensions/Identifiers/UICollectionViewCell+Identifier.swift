//
//  UICollectionViewCell+Identifier.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 04/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

@testable import Le_Baluchon
import XCTest

class UICollectionViewCell_Identifier: XCTestCase {

    func test_identifier_returnExpected() {
        // given
        let expected = "\(TestCollectionViewCell.self)"
        
        // when
        let actual = TestCollectionViewCell.identifier
        
        // then
        XCTAssertEqual(actual, expected)

    }
}
