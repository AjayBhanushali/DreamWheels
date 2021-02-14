//
//  NetworkingTests.swift
//  DreamWheelsTests
//
//  Created by Ajay Bhanushali on 14/02/21.
//

import XCTest
@testable import DreamWheels

final class NetworkingTests: XCTestCase {

    var network: NetworkService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        network = NetworkClientMock()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        network = nil
    }

    func testNetworkDataRequestManufacturersSuccess() {
        _ = network.dataRequest(DreamWheelsAPI.getManufacturersFor(page: 0), objectType: DreamWheelsBaseModel.self, completion: { (result) in
            switch result {
            case let .success(baseModel):
                XCTAssertTrue(baseModel.wkda?.list?.count == 15)
                XCTAssertFalse(baseModel.page == 1)
            case .failure:
                break
            }
        })
        
        _ = network.dataRequest(DreamWheelsAPI.getManufacturersFor(page: 1), objectType: DreamWheelsBaseModel.self, completion: { (result) in
            switch result {
            case let .success(baseModel):
                XCTAssertTrue(baseModel.wkda?.list?.count == 15)
                XCTAssertFalse(baseModel.page == 0)
            case .failure:
                break
            }
        })
    }
    
    func testNetworkDataRequestModelsSuccess() {
        _ = network.dataRequest(DreamWheelsAPI.getModelsFor(manufacturId: "130", page: 0), objectType: DreamWheelsBaseModel.self, completion: { (result) in
            switch result {
            case let .success(baseModel):
                XCTAssertFalse(baseModel.wkda?.list?.count == 15)
                XCTAssertFalse(baseModel.page == 1)
            case .failure:
                break
            }
        })
    }
    
    func testNetworkDataRequestInvalidStatusFailure() {
        
        _ = network.dataRequest(DreamWheelsAPI.getManufacturersFor(page: -1), objectType: DreamWheelsBaseModel.self, completion: { (result) in
            switch result {
            case .success:
                XCTFail("Should fail with error")
            case let .failure(error):
                XCTAssertTrue(error.description == "Server is down with status code: 401")
            }
        })
    }
    
    func testNetworkDataRequestEmptyDataFailure() {
        _ = network.dataRequest(DreamWheelsAPI.getModelsFor(manufacturId: "INVALID", page: 0), objectType: DreamWheelsBaseModel.self, completion: { (result) in
            switch result {
            case .success:
                XCTFail("Should fail with error")
            case let .failure(error):
                XCTAssertTrue(error.description == "Empty response from the server")
            }
        })
    }
}

