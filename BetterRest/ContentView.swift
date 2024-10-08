//
//  ContentView.swift
//  BetterRest
//
//  Created by Rodrigo Carballo on 10/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("When do you wnat to wake up ?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                
                Text("Desired amount of slee")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Daily coffee intake")
                    .font(.headline)
                
                Stepper("\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
           
            }
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calculate", action: calculateBedTimne)

            }
        }

    }
    
    func calculateBedTimne() {
        
    }
}

#Preview {
    ContentView()
}
