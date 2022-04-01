//
//  ContentView.swift
//  Asclepione
//
//  Created by Marc Jowett on 08/02/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AsclepioneViewModel()
    
    var lefthandWidth = CGFloat(150)
    var righthandWidth = CGFloat(150)
    
    var body: some View {
        VStack(alignment: .center) {
            self.countryView
            self.dateView
            self.newVaccinationsView
            self.cumulativeVaccinationsView
            self.uptakePercentageView
        }
        .multilineTextAlignment(.center)
        .padding(16)
    }
    
    var countryView: some View {
        HStack(alignment: .center) {
            PlaceholderTextView(
                placeholderText: Text("End of the World"), text: $viewModel.country)
        }
        .padding(16)
    }
    
    var dateView: some View {
        HStack(alignment: .center) {
            Text("Date:")
                .frame(width: lefthandWidth, height: 50, alignment: .center)
            PlaceholderTextView(
                placeholderText: Text("End of Time"), text: $viewModel.date)
                .frame(width: righthandWidth, height: 50, alignment: .center)
        }
    }
    
    var newVaccinationsView: some View {
        HStack(alignment: .center) {
            Text("New Vaccinations:")
                .frame(width: lefthandWidth, height: 50, alignment: .center)
            PlaceholderTextView(
                placeholderText: Text(">9000"), text: $viewModel.newVaccinationsEngland)
                .frame(width: righthandWidth, height: 50, alignment: .center)
        }
    }
    
    var cumulativeVaccinationsView: some View {
        HStack(alignment: .center) {
            Text("Cumulative Vaccinations:")
                .frame(width: lefthandWidth, height: 50, alignment: .center)
            PlaceholderTextView(
                placeholderText: Text(">9000"), text: $viewModel.cumVaccinationsEngland)
                .frame(width: righthandWidth, height: 50, alignment: .center)
        }
    }
    
    var uptakePercentageView: some View {
        HStack(alignment: .center) {
            Text("Uptake Percentage:")
                .frame(width: lefthandWidth, height: 50, alignment: .center)
            PlaceholderTextView(
                placeholderText: Text("110%"), text: $viewModel.uptakePercentagesEngland)
                .frame(width: righthandWidth, height: 50, alignment: .center)
        }
    }
}

struct PlaceholderTextView: View {
    var placeholderText: Text
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .center) {
            if text == "" {
                placeholderText
            } else {
                TextField("", text: $text)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
