//
//  BusRouteOnlineNetworkTests.swift
//  BusRouteTests
//
//  Created by Tomislav Luketic on 4/29/18.
//  Copyright © 2018 lux. All rights reserved.
//

import XCTest
@testable import BusRoute

class BusRouteOnlineNetworkTests: XCTestCase {
    
    let client = NetworkClient(session: URLSession(configuration: .default))
    let url = URL(string: "http://www.mocky.io/v2/5a0b474a3200004e08e963e5")
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOnlineNetworkCall()
    {
        let expectation = XCTestExpectation(description: "Download routes")
        
        client.get(url: url!, callback: { (data, response, error) in
            
            let code = (response as! HTTPURLResponse).statusCode
            
            XCTAssert(code == 200)
            XCTAssertNotNil(data)
            
            expectation.fulfill();
            
            
        })
        
        wait(for: [expectation], timeout: 10.0)
        
    }
    
    
}
