//
//  MockURLSessionDataTask.swift
//  Le BaluchonTests
//
//  Created by Mahieu Bayon on 02/07/2020.
//  Copyright © 2020 Mabayon. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    var completionHandler: (Data?, URLResponse?, Error?) -> Void
    var url: URL
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void,
         url: URL,
         queue: DispatchQueue?) {
        if let queue = queue {
            self.completionHandler = { data, response, error in
                queue.async {
                    completionHandler(data, response, error)
                }
            }
        } else {
            self.completionHandler = completionHandler
        }
        self.url = url
        super.init()
    }
    
    var calledResume = false
    override func resume() {
        calledResume = true
    }
}
