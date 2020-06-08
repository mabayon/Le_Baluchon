//
//  XCTAssertEqualToAny.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 08/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import XCTest

public func XCTAssertEqualToAny<T: Equatable>(_ actual: @autoclosure () throws -> T,
                                              _ expected: @autoclosure () throws -> Any?,
                                              file: StaticString = #file,
                                              line: UInt = #line) throws {
  let actual = try actual()
  let expected = try XCTUnwrap(expected() as? T)
  XCTAssertEqual(actual, expected, file: file, line: line)
}

public func XCTAssertEqualToDate(_ actual: @autoclosure () throws -> Date,
                                 _ expected: @autoclosure () throws -> Any?,
                                 file: StaticString = #file,
                                 line: UInt = #line) throws {
  let actual = try actual()
  let value = try expected()
  let expected: Date
  if let value = value as? TimeInterval {
    expected = Date(timeIntervalSinceReferenceDate: value)
  } else {
    expected = try XCTUnwrap(value as? Date)
  }
  XCTAssertEqual(actual, expected, file: file, line: line)
}
