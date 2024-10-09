//
//  ContentView.swift
//  BetterRest
//
//  Created by Rodrigo Carballo on 10/4/24.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showinglert = false
    
    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section(header: Text("When do you wnat to wake up ?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                .font(.headline)
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                .font(.headline)
                
                Section(header: Text("Daily coffee intake")) {
                    Stepper("^[\(coffeeAmount) cup](inflect:true)", value: $coffeeAmount, in: 1...20)
                }
                .font(.headline)
                
            }
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calculate", action: calculateBedTimne)
            }
            .alert(alertTitle, isPresented: $showinglert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }

    }
    
    func calculateBedTimne() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your Ideal bedtime is..."
            alertMessage = "\(sleepTime.formatted(date: .omitted, time: .shortened))"

            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was an error calculating your bedtime."
        }
        
        showinglert = true
    }
}

#Preview {
    ContentView()
}
