//
//  ContentView.swift
//  UnitTestingDemo
//
//  Created by Shubham Kumar on 21/02/22.
//

import SwiftUI

struct UnitTestingView: View {
    //MARK: PROPERTIES
    @StateObject private var viewModel:UnitTestingViewModel
    
    init(isPremium:Bool) {
        _viewModel = StateObject(wrappedValue: UnitTestingViewModel(isPremium: isPremium))
    }
    
    //MARK: BODY
    var body: some View {
        Text(viewModel.isPremium.description)
            .padding()
    }
}

//MARK: PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UnitTestingView(isPremium: true)
    }
}
