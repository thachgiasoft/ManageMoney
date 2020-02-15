//
//  AddSpendingsView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 18/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct AddSpendingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var spendings : Spendings
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var spendingDate = ""
//    @State private var showNotification: Bool = false
    let userID = Auth.auth().currentUser!.uid
    var ref: DatabaseReference! = Database.database().reference()
    
  
    @State var time = Date()
       var dateFormatter:DateFormatter{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
       }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.spendingDate = formatter.string(from: date)
        return spendingDate
    }
    
    func retrieveMonth()
    {
        
    }
    
    func retrieveYear()
    {
        
    }


    static let types =
    [
        "Personal",
        "Restaurants",
        "Car",
        "Groceries",
        "School Supplies",
        "Home",
        "Cinema",
        "Assurance",
        "Work",
        "Trip",
        "Tech",
        "Farmacy",
        "Hospital",
        "Medical Visits",
    ]

    var body: some View
    {
        NavigationView
        {
            Form
            {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type)
                {
                    ForEach(Self.types, id: \.self)
                    {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
                
                DatePicker(selection: $time, label: {
                    Text("\(time, formatter: dateFormatter)")
                })
                
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing: Button("Save")
            {
                if let actualAmount = Double(self.amount)
                {
                    let item = SpendingItem(idItem: self.name + "_" + self.type ,name: self.name , type: self.type , amount: actualAmount)
                    
                    self.spendings.item.append(item)
                    self.ref.child("users").child(self.userID).child("spendings").child(item.idItem).updateChildValues(
                    [
                            "spendingName": self.name,
                            "spendingType": self.type,
                            "spendingAmount": self.amount,
                            "spendingDate": self.stringFromDate(self.time)
                    ])
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct AddSpendingsView_Previews: PreviewProvider
{
    static var previews: some View
    {
        AddSpendingsView(spendings: Spendings())
    }
}
