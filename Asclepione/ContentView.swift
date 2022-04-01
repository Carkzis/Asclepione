//
//  ContentView.swift
//  Asclepione
//
//  Created by Marc Jowett on 08/02/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AsclepioneViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            PlaceholderTextView(
                placeholderText: Text(">9000"), text: $viewModel.newVaccinationsEngland.country)
        }
        Text("Hello, world!")
            .padding()
    }
}

struct PlaceholderTextView: View {
    var placeholderText: Text
    @Binding var text: String?
    
    var body: some View {
        VStack(alignment: .center) {
            if let unwrapped = Binding($text) {
                TextField("", text: unwrapped)
            } else {
                placeholderText
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
