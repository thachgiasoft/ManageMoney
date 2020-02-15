//
//  ContentView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 09/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI

struct SplitMoneyView: View
{

    @State var checkAmount = ""
    @State var numberOfPeople = 0
    @State var tipPercentage = 0
    @EnvironmentObject var session: SessionStore

    
    let tipPercentages: [Int] = [0, 5, 10, 15, 20, 25]

    var peopleNumber : Double
    {
        let peopleCount = Double(numberOfPeople + 2)
        
        return peopleCount
    }
    var tipSelectioned : Double
    {
        let tipSelection = Double(tipPercentages[tipPercentage])
        
        return tipSelection
    }
    
    var orderTotal : Double
    {
        let orderAmount = Double(checkAmount) ?? 0
        
        return orderAmount
    }
    
    var tipTotalAmount: Double
    {
        let tipValue = Double(orderTotal/100 * tipSelectioned)
        
        return tipValue
    }
    
    var superTotal : Double
    {
        let grandTotal = orderTotal + tipTotalAmount
        
        return grandTotal
    }
    
    var totalPerPerson: Double
    {
        let amountPerPerson = superTotal/peopleNumber
        
        return amountPerPerson
    }
    
    var tipPerPerson: Double
    {
        let singleTip = tipTotalAmount / peopleNumber
        
        return singleTip
    }
    
    var body: some View
    {
        NavigationView
        {
            Form
            {
                Section
                {
                    TextField("Amount" , text: $checkAmount)
                    .keyboardType(.decimalPad)
                    .onTapGesture
                    {
                        let keyWindow = UIApplication.shared.connectedScenes
                                           .filter({$0.activationState == .foregroundActive})
                                           .map({$0 as? UIWindowScene})
                                           .compactMap({$0})
                                           .first?.windows
                                           .filter({$0.isKeyWindow}).first
                        keyWindow!.endEditing(true)
                    }
                    Picker("number of people", selection: $numberOfPeople)
                    {
                        ForEach(2 ..< 25)
                        {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section(header: Text("How much tip do you want to leave?"))
                {
                    Picker("Tip percentage", selection: $tipPercentage)
                    {
                        ForEach(0 ..< tipPercentages.count)
                        {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Tip to pay per person"))
                {
                    Text("\(tipPerPerson , specifier: "%.2f") €")
                }
                
                Section(header: Text("Amount to pay per person (included tips)"))
                {
                    Text("\(totalPerPerson , specifier: "%.2f") €")
                }
                    
                .navigationBarTitle("Split Money")
            }
        }
    }
}


struct SplitMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        SplitMoneyView()
    }
}
