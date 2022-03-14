//
//  UnitTestingViewModel.swift
//  UnitTestingDemo
//
//  Created by Shubham Kumar on 21/02/22.
//

import SwiftUI
import Combine

enum DataError:LocalizedError {
    case noData
    case itemNotFound
}

class UnitTestingViewModel: ObservableObject {
    @Published var isPremium:Bool
    @Published var dataArray:[String] = []
    @Published var selectedItem: String? = nil
    let dataService: NewDataServiceProtocol
    var cancellables = Set<AnyCancellable>()
    
    init(isPremium:Bool, dataService:NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item:String) {
        guard !item.isEmpty else {return}
        self.dataArray.append(item)
    }
    
    func selectedItem(item:String) {
        if let x = dataArray.first(where: { $0 == item }) {
            selectedItem = x
        } else {
            selectedItem = nil
        }
    }
    
    func saveItem(item:String) throws {
        guard !item.isEmpty else {
            print("No Data Error")
            throw DataError.noData
        }
        if let x = dataArray.first(where: { $0 == item }) {
            print("Save item here !!! \(x)")
        } else {
            print("Item Not Found")
            throw DataError.itemNotFound
            
        }
    }
    
    func downloadWithEscaping() {
        dataService.downloadItemsWithEscaping(completion: {
            [weak self] returnedItems in
            self?.dataArray = returnedItems
        })
    }
    
    func downloadWithCombine() {
        dataService.downloadItemsWithCombine()
            .sink(receiveCompletion: {_ in
                
            }, receiveValue: { [weak self] returnedItems in
                self?.dataArray = returnedItems
            }).store(in: &cancellables)
    }
    
}
