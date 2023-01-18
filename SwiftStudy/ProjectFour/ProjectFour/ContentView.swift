//
//  ContentView.swift
//  ProjectFour
//
//  Created by user on 04/01/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaulWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    @State private var selectedNumberOfCups = 1
    
    static var defaulWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section(header: Text("Desired Amount of sleep")) {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section(header: Text("Daily coffee intake")) {
                    Picker("Cups", selection: $selectedNumberOfCups ) {
                        ForEach(1..<21) {
                            Text($0 > 1 ? "\($0) cups" : "1 cup")
                        }
                    }
                    //Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                }
                
                Section(header: Text("\(alertTitle)")) {
                    Text("ass")
                        .font(.title3)
                        .onAppear(perform: calculateBedTime)
                }
                
            }
        .navigationTitle("BetterRest")
            //.toolbar {
            //    Button("Calculate", action: calculateBedTime)
            //}
            //.alert(alertTitle, isPresented: $showingAlert) {
            //    Button("Ok") { }
            //} message: {
            //    Text(alertMessage)
            //}
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is:"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
