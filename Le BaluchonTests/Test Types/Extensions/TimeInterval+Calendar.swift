//
//  TimeInterval+Calendar.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 09/06/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

extension TimeInterval {
  
  public var year: TimeInterval { return years }
    public var years: TimeInterval { return self * 366.days}
  
  public var month: TimeInterval { return months }
  public var months: TimeInterval { return self * 31.days }
  
  public var week: TimeInterval { return weeks }
  public var weeks: TimeInterval { return self * 7.days }
  
  public var day: TimeInterval { return days }
  public var days: TimeInterval { return self * 24.hours }
  
  public var hour: TimeInterval { return hours }
  public var hours: TimeInterval { return self * 60.minutes }
  
  public var minute: TimeInterval { return minutes }
  public var minutes: TimeInterval { return self * 60.seconds }
  
  public var second: TimeInterval { return seconds }
  public var seconds: TimeInterval { return self }
  
  public var pastDate: Date {
    return Date(timeIntervalSinceNow: -1 * self)
  }
}
