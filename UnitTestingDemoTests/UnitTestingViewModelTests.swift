//
//  UnitTestingViewModelTests.swift
//  UnitTestingDemoTests
//
//  Created by Shubham Kumar on 21/02/22.
//

import XCTest
@testable import UnitTestingDemo
import Combine

// Naming Structure: testUnitOfWorkStateUnderTestExpectedBehaviour
// Naming Structure: test_[struct or class]_[variable or function]_[expected result]

// Testing Structure: Given, When, Then

class UnitTestingViewModelTests: XCTestCase {
    
    var defaultViewModel:UnitTestingViewModel?
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        defaultViewModel = UnitTestingViewModel(isPremium: Bool.random())
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        defaultViewModel = nil
    }
    
    func test_UnitTestingViewModel_isPremium_shouldBeTrue() {
        // Given
        let userIsPremium: Bool = true
        
        // When
        let viewModel = UnitTestingViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertTrue(viewModel.isPremium)
        
    }
    
    func test_UnitTestingViewModel_isPremium_shouldBeFalse() {
        // Given
        let userIsPremium: Bool = false
        
        // When
        let viewModel = UnitTestingViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertFalse(viewModel.isPremium)
    }
    
    func test_UnitTestingViewModel_isPremium_shouldBeInjectedValue() {
        // Given
        let userIsPremium: Bool = Bool.random()
        
        // When
        let viewModel = UnitTestingViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertEqual(viewModel.isPremium, userIsPremium)
    }
    
    func test_UnitTestingViewModel_isPremium_shouldBeInjectedValue_stress() {
        
        for _ in 0..<100 {
            // Given
            let userIsPremium: Bool = Bool.random()
            
            // When
            let viewModel = UnitTestingViewModel(isPremium: userIsPremium)
            
            // Then
            XCTAssertEqual(viewModel.isPremium, userIsPremium)
        }
    }
    
    func test_UnitTestingViewModel_dataArray_shouldBeEmpty() {
        // Given
        
        // When
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // Then
        XCTAssertTrue(viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingViewModel_dataArray_shouldAddItem() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        let loopCount = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            viewModel.addItem(item: UUID().uuidString)
        }
        // Then
        XCTAssertTrue(!viewModel.dataArray.isEmpty)
        XCTAssertFalse(viewModel.dataArray.isEmpty)
        XCTAssertNotEqual(viewModel.dataArray.count, 0)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
        XCTAssertLessThanOrEqual(viewModel.dataArray.count, loopCount)
    }
    
    func test_UnitTestingViewModel_dataArray_shouldNotAddBlankString() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        viewModel.addItem(item: "")
        // Then
        XCTAssertTrue(viewModel.dataArray.isEmpty)
        XCTAssertFalse(!viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingViewModel_dataArray_shouldNotAddBlankString2() {
        // Given
        guard let defaultViewModel = defaultViewModel else {
            return
        }

        let viewModel = defaultViewModel
        // When
        viewModel.addItem(item: "")
        // Then
        XCTAssertTrue(viewModel.dataArray.isEmpty)
        XCTAssertFalse(!viewModel.dataArray.isEmpty)
        XCTAssertEqual(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldStartAsNil() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        // Then
        XCTAssertTrue(viewModel.selectedItem == nil)
        XCTAssertNil(viewModel.selectedItem)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        viewModel.selectedItem(item: UUID().uuidString)
        // Then
        XCTAssertNil(viewModel.selectedItem)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldBeSelected() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        let newItem = UUID().uuidString
        viewModel.addItem(item: newItem)
        viewModel.selectedItem(item: newItem)
        // Then
        XCTAssertNotNil(viewModel.selectedItem)
        XCTAssertEqual(viewModel.selectedItem, newItem)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldBeNilWhenSelectedInvalidItem() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        let newItem = UUID().uuidString
        viewModel.addItem(item: newItem)
        viewModel.selectedItem(item: newItem)
        viewModel.selectedItem(item: UUID().uuidString)
        // Then
        //        XCTAssertNotNil(viewModel.selectedItem)
        XCTAssertNil(viewModel.selectedItem)
    }
    
    func test_UnitTestingViewModel_selectedItem_shouldBeSelected_stress() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        let loopcount = Int.random(in: 1..<100)
        var itemsArray:[String] = []
        for _ in 0..<loopcount {
            let newItem = UUID().uuidString
            viewModel.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        let randomItem = itemsArray.randomElement() ?? ""
        viewModel.selectedItem(item: randomItem)
        // Then
        XCTAssertNotNil(viewModel.selectedItem)
        XCTAssertEqual(viewModel.selectedItem, randomItem)
    }
    
    func test_UnitTestingViewModel_saveItem_shouldThrowError_itemNotFound() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        
        // Then
        XCTAssertThrowsError(try viewModel.saveItem(item: UUID().uuidString), "Item not Found!") { error in
            let returnedError = error as? DataError
            XCTAssertEqual(returnedError, DataError.itemNotFound)
        }
    }
    
    func test_UnitTestingViewModel_saveItem_shouldThrowError_noData() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        
        // Then
        XCTAssertThrowsError(try viewModel.saveItem(item: ""), "No Data Found") {error in
            let returnedError = error as? DataError
            XCTAssertEqual(returnedError, DataError.noData)
        }
    }
    
    func test_UnitTestingViewModel_saveItem_shouldThrowError_itemNotFound_stress() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        let loopcount = Int.random(in: 1..<100)
        for _ in 0..<loopcount {
            let newItem = UUID().uuidString
            XCTAssertThrowsError(try viewModel.saveItem(item: newItem), "Item Not Found") {error in
                let returnedError = error as? DataError
                XCTAssertEqual(returnedError, DataError.itemNotFound)
            }
        }
        // Then
        XCTAssertThrowsError(try viewModel.saveItem(item: UUID().uuidString), "Item not Found!") { error in
            let returnedError = error as? DataError
            XCTAssertEqual(returnedError, DataError.itemNotFound)
        }
    }
    
    func test_UnitTestingViewModel_saveItem_shouldThrowError_noData_stress() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        let loopcount = Int.random(in: 1..<100)
        for _ in 0..<loopcount {
            let newItem = ""
            XCTAssertThrowsError(try viewModel.saveItem(item: newItem), "No Data Found") {error in
                let returnedError = error as? DataError
                XCTAssertEqual(returnedError, DataError.noData)
            }
        }
        // Then
        XCTAssertThrowsError(try viewModel.saveItem(item: ""), "No Data Found") {error in
            let returnedError = error as? DataError
            XCTAssertEqual(returnedError, DataError.noData)
        }
    }
    
    func test_UnitTestingViewModel_saveItem_shouldSaveItem_stress() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        // When
        let loopcount = Int.random(in: 1..<100)
        var itemsArray:[String] = []
        for _ in 0..<loopcount {
            let newItem = UUID().uuidString
            viewModel.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        let randomElement = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomElement.isEmpty)
        // Then
        XCTAssertNoThrow(try viewModel.saveItem(item: randomElement))
        do {
            try viewModel.saveItem(item: randomElement)
        } catch {
            XCTFail()
        }
    }
    
    func test_UnitTestingViewModel_downloadWithEscaping_shouldReturnItems() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds!")
        viewModel.$dataArray
            .dropFirst()
            .sink(receiveValue: {
                returnedItems in
                expectation.fulfill()
            }).store(in: &cancellables)
        
        viewModel.downloadWithEscaping()
        
        //Then
        wait(for: [expectation], timeout: 3)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingViewModel_downloadWithCombine_shouldReturnItems() {
        // Given
        let viewModel = UnitTestingViewModel(isPremium: Bool.random())
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after 1 seconds!")
        viewModel.$dataArray
            .dropFirst()
            .sink(receiveValue: {
                returnedItems in
                expectation.fulfill()
            }).store(in: &cancellables)
        
        viewModel.downloadWithCombine()
        
        //Then
        wait(for: [expectation], timeout: 3)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
    }
    
    func test_UnitTestingViewModel_downloadWithCombine_shouldReturnItem2() {
        // Given
        let items = [UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let dataService: NewDataServiceProtocol = NewMockDataService(items: items)
        let viewModel = UnitTestingViewModel(isPremium: Bool.random(), dataService: dataService)
        
        // When
        let expectation = XCTestExpectation(description: "Should return items after 1 seconds!")
        viewModel.$dataArray
            .dropFirst()
            .sink(receiveValue: {
                returnedItems in
                expectation.fulfill()
            }).store(in: &cancellables)
        
        viewModel.downloadWithCombine()
        
        //Then
        wait(for: [expectation], timeout: 3)
        XCTAssertGreaterThan(viewModel.dataArray.count, 0)
        XCTAssertEqual(viewModel.dataArray.count, items.count)
    }
}
