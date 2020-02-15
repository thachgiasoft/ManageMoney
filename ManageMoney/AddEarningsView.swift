//
//  AddEarnings.swift
//  ManageMoney
//
//  Created by Omar Serrah on 01/02/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct AddEarningsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var earnings : Earnings
    @State private var name = ""
    @State private var type = "Salary"
    @State private var amount = ""
    
    let userID = Auth.auth().currentUser!.uid
    
    
    var ref: DatabaseReference! = Database.database().reference()



    static let types = ["Salary", "Freelance", "Birthday", "Prize"]

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
                DatePicker(selection: .constant(Date()), label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
            }
            .navigationBarTitle("Add new earning")
            .navigationBarItems(trailing: Button("Save")
            {
                if let actualAmount = Double(self.amount)
                {
                    let item = EarningItem(idItem: self.name + "_" + self.type ,name: self.name , type: self.type , amount: actualAmount)
                    self.earnings.item.append(item)
                    
                    self.ref.child("users").child(self.userID).child("earnings").child(item.idItem).updateChildValues(["earningName": self.name ,"earningType": self.type, "earningAmount": self.amount])
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct AddEarningsView_Previews: PreviewProvider {
    static var previews: some View {
        AddEarningsView(earnings: Earnings())
    }
}
