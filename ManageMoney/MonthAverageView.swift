//
//  MonthAverageView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 08/02/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct MonthAverageView: View {
    
    @State var arrayJanuary: [SpendingItem] = []
    @State var arrayFebruary: [SpendingItem] = []
    @State var arrayMarch: [SpendingItem] = []
    @State var arrayApril: [SpendingItem] = []
    @State var arrayMay: [SpendingItem] = []
    @State var arrayJune: [SpendingItem] = []
    @State var arrayJuly: [SpendingItem] = []
    @State var arrayAugust: [SpendingItem] = []
    @State var arraySeptember: [SpendingItem] = []
    @State var arrayOctober: [SpendingItem] = []
    @State var arrayNovember: [SpendingItem] = []
    @State var arrayDecember: [SpendingItem] = []
    
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    @State var arrayAmount:[String] = []
    @State var arrayName:[String] = []
    @State var arrayType:[String] = []
    @State var myArray:[SpendingItem] = []
    @State var showingAddSpending = false
    @State var speseTotali: Double = 0
    @State var mediaSpese: Double = 0
    
    var numberOfSpendings: Double
    {
        let numberOfExpenses = Double(myArray.count)
        self.ref.child("users").child(self.userID!).updateChildValues(["numberOfExpenses": numberOfExpenses])

        return numberOfExpenses
    }
    
    func retrieveAverageMonth(arrayMesi: [SpendingItem]) -> Double
    {
        self.mediaSpese = 0
        if arrayMesi == nil || arrayMesi.count == 0
        {
            return 0
        }
        var totalMonthSpending: Double = 0
        for item in arrayMesi
        {
            totalMonthSpending += item.amount
        }
        
        return totalMonthSpending/Double(arrayMesi.count)
    }
    
    func retrieveSpendings()
    {
        print("stocazzo")
        ref.child("users").child(userID!).child("spendings").observe(.value){ (snapshot) in
            self.arrayJanuary = []
            self.arrayFebruary = []
            self.arrayMarch = []
            self.arrayApril = []
            self.arrayMay = []
            self.arrayJune = []
            self.arrayJuly = []
            self.arrayAugust = []
            self.arraySeptember = []
            self.arrayOctober = []
            self.arrayNovember = []
            self.arrayDecember = []
            self.speseTotali = 0
            for item in snapshot.children
            {
                let todoData = item as! DataSnapshot
                let idItem:String = todoData.key
                let todoItem = todoData.value as! [String:Any]
                let ammontareSpesa:String = String(describing: todoItem["spendingAmount"]!)
                let nomeSpesa:String = String(describing: todoItem["spendingName"]!)
                let tipologiaeSpesa:String = String(describing: todoItem["spendingType"]!)
                let dataSpesa:String = String(describing: todoItem["spendingDate"]!)
                let spendingObject:SpendingItem = SpendingItem(idItem: idItem, name: nomeSpesa, type: tipologiaeSpesa, amount: Double(ammontareSpesa)!)

                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                print(dataSpesa)
                guard let date = formatter.date(from: dataSpesa) else {
                    return
                }

                formatter.dateFormat = "MM"
                let month = formatter.string(from: date)
                print(month)
                
                switch month {
                case "01":
                    self.arrayJanuary.append(spendingObject)
                case "02":
                    self.arrayFebruary.append(spendingObject)
                case "03":
                    self.arrayMarch.append(spendingObject)
                case "04":
                    self.arrayApril.append(spendingObject)
                case "05":
                    self.arrayMay.append(spendingObject)
                case "06":
                    self.arrayJune.append(spendingObject)
                case "07":
                    self.arrayJuly.append(spendingObject)
                case "08":
                    self.arrayAugust.append(spendingObject)
                case "09":
                    self.arraySeptember.append(spendingObject)
                case "10":
                    self.arrayOctober.append(spendingObject)
                case "11":
                    self.arrayNovember.append(spendingObject)
                case "12":
                    self.arrayDecember.append(spendingObject)
                default:
                    print("Some other character")
                }
            }
        }
    }
    


    var body: some View
    {
        NavigationView
        {
            List
            {
                Section
                {
                    Text("January ➣ \(retrieveAverageMonth(arrayMesi: arrayJanuary), specifier: "%.2f")$")
                    Text("February ➣ \(retrieveAverageMonth(arrayMesi: arrayFebruary), specifier: "%.2f")$")
                    Text("March ➣ \(retrieveAverageMonth(arrayMesi: arrayMarch), specifier: "%.2f")$")
                }
                Section
                {
                    Text("April ➣ \(retrieveAverageMonth(arrayMesi: arrayApril), specifier: "%.2f")$")
                    Text("May ➣ \(retrieveAverageMonth(arrayMesi: arrayMay), specifier: "%.2f")$")
                    Text("June ➣ \(retrieveAverageMonth(arrayMesi: arrayJune), specifier: "%.2f")$")
                }
                Section
                {
                    Text("July ➣ \(retrieveAverageMonth(arrayMesi: arrayJuly), specifier: "%.2f")$")
                    Text("August ➣ \(retrieveAverageMonth(arrayMesi: arrayAugust), specifier: "%.2f")$")
                    Text("September ➣ \(retrieveAverageMonth(arrayMesi: arraySeptember), specifier: "%.2f")$")
                }
                Section
                {
                    Text("October ➣ \(retrieveAverageMonth(arrayMesi: arrayOctober), specifier: "%.2f")$")
                    Text("November ➣ \(retrieveAverageMonth(arrayMesi: arrayNovember), specifier: "%.2f")$")
                    Text("December ➣ \(retrieveAverageMonth(arrayMesi: arrayDecember), specifier: "%.2f")$")
                }
                
            }
            .onAppear(perform: retrieveSpendings)
            .navigationBarTitle("Month Average")
        }
    }
}

struct MonthAverageView_Previews: PreviewProvider {
    static var previews: some View {
        MonthAverageView()
    }
}
