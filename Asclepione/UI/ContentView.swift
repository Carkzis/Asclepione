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
    var textFieldHeight = CGFloat(45)
    
    var body: some View {
        ZStack {
            Color.red
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                self.titleView
                self.countryView
                self.dateView
                self.newVaccinationsView
                self.cumulativeVaccinationsView
                self.uptakePercentageView
                Spacer()
                    .frame(width: 100, height: 32, alignment: .center)
                self.refreshButtonView
                self.progressView
            }.foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(16)
            .border(.white)
        }
    }
    
    var titleView: some View {
        VStack {
            Text("Asclepione")
                .font(.largeTitle)
                .bold()
                .padding(8)
                .accessibilityIdentifier("titleText")
            Text("Keep track of the nation's vaccination uptake!")
                .accessibilityIdentifier("subtitleText")
        }
    }
    
    var countryView: some View {
        HStack(alignment: .center) {
            Text("Country:")
                .frame(width: lefthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("countryText")
            PlaceholderTextView(
                placeholderText: Text("???"), text: $viewModel.country)
                .frame(width: righthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("countryData")
        }
    }
    
    var dateView: some View {
        HStack(alignment: .center) {
            Text("Date:")
                .frame(width: lefthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("dateText")
            PlaceholderTextView(
                placeholderText: Text("???"), text: $viewModel.date)
                .frame(width: righthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("dateData")
        }
    }
    
    var newVaccinationsView: some View {
        HStack(alignment: .center) {
            Text("New Vaccinations:")
                .frame(width: lefthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("newVaccText")
            PlaceholderTextView(
                placeholderText: Text(">9000"), text: $viewModel.newVaccinations)
                .frame(width: righthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("newVaccData")
        }
    }
    
    var cumulativeVaccinationsView: some View {
        HStack(alignment: .center) {
            Text("Cumulative Vaccinations:")
                .frame(width: lefthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("cumVaccText")
            PlaceholderTextView(
                placeholderText: Text(">9000"), text: $viewModel.cumVaccinations)
                .frame(width: righthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("cumVaccData")
        }
    }
    
    var uptakePercentageView: some View {
        HStack(alignment: .center) {
            Text("Uptake Percentage:")
                .frame(width: lefthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("uptakePercentageText")
            PlaceholderTextView(
                placeholderText: Text("110%"), text: $viewModel.uptakePercentages)
                .frame(width: righthandWidth, height: textFieldHeight, alignment: .center)
                .accessibilityIdentifier("uptakePercentageData")
        }
    }
    
    var refreshButtonView: some View {
        Button("Refresh data?") {
            refreshData()
        }
        .padding(16)
        .border(.white)
        .accessibilityIdentifier("refreshButton")
    }
    
    @ViewBuilder
    var progressView: some View {
        ProgressView()
            .hidden($viewModel.isLoading.wrappedValue)
    }
    
    private func refreshData() {
        viewModel.refreshVaccinationData()
    }
}

struct PlaceholderTextView: View {
    var placeholderText: Text
    @Binding var text: String
    var fontStyle = Font.body
    
    var body: some View {
        VStack(alignment: .center) {
            if text == "" {
                placeholderText
            } else {
                Text($text.wrappedValue)
                    .font(fontStyle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 1 : 0)
    }
}
