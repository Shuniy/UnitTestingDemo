//
//  NewMockDataServiceTests.swift
//  UnitTestingDemoTests
//
//  Created by Shubham Kumar on 21/02/22.
//

import XCTest
@testable import UnitTestingDemo
import Combine

class NewMockDataServiceTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: TESTS
    func test_NewMockDataService_init_doesSetValuesCorrectly() {
        // Given
        let items1:[String]? = nil
        let items2:[String]? = []
        let items3:[String]? = [UUID().uuidString, UUID().uuidString, UUID().uuidString]
        
        // When
        let dataService1 = NewMockDataService(items: items1)
        let dataService2 = NewMockDataService(items: items2)
        let dataService3 = NewMockDataService(items: items3)
        
        // Then
        XCTAssertFalse(dataService1.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
    }
    
    func test_NewMockDataService_downloadItemsWithEscaping_doesReturnValues() {
        // Given
        let dataService = NewMockDataService(items: nil)
        
        // When
        var items:[String] = []
        let expectation = XCTestExpectation(description: "Expectation Fullfills after 3 seconds")
        dataService.downloadItemsWithEscaping(completion: {
            returnedItems in
            items = returnedItems
            expectation.fulfill()
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesReturnValues() {
        // Given
        let dataService = NewMockDataService(items: nil)
        
        // When
        var items:[String] = []
        let expectation = XCTestExpectation(description: "Expectation Fullfills after 3 seconds")
        dataService.downloadItemsWithCombine()
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(_):
                    XCTFail()
                }
            }, receiveValue: {
                returnedItems in
                items = returnedItems
            }).store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesFail() {
        // Given
        let dataService = NewMockDataService(items: [])
        
        // When
        var items:[String] = []
        let expectation1 = XCTestExpectation(description: "Should throw error")
        let expectation2 = XCTestExpectation(description: "Should throw bad server response")
        dataService.downloadItemsWithCombine()
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation1.fulfill()
                    let urlError = error as? URLError
                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    
                    if urlError == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                }
            }, receiveValue: {
                returnedItems in
                items = returnedItems
            }).store(in: &cancellables)
        
        // Then
        wait(for: [expectation1, expectation2], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
}
