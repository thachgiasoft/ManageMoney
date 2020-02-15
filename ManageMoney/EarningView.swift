//
//  EarningView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 01/02/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct EarningItem : Identifiable, Codable
{
    let id = UUID()
    let idItem: String
    let name: String
    let type: String
    let amount: Double
}

class Earnings: ObservableObject
{
    @Published var item = [EarningItem] ()
        {
            didSet
            {
                   let encoder = JSONEncoder()
                   if let encoded = try? encoder.encode(item)
                   {
                       UserDefaults.standard.set(encoded, forKey: "Item")
                   }
            }
        }
    
    init()
    {
        if let item = UserDefaults.standard.data(forKey: "Item")
        {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([EarningItem].self, from: item)
            {
                self.item = decoded
                return
            }
        }
        self.item = []
    }
}


struct EarningView: View
{
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid

    @ObservedObject var earnings = Earnings()
    @State private var showingAddEarning = false
    
    func removeItems(at offsets: IndexSet)
    {
        let itemTmp: EarningItem = myArray[offsets.first!]
        myArray.remove(atOffsets: offsets)

        ref.child("users").child(self.userID!).child("earnings").child(itemTmp.idItem).removeValue()
    }
    
    var numberOfEarnings: Int
    {
        let numberOfIncome = Int(myArray.count)
        
        return numberOfIncome
    }
    
    var totalMoneyIncome : Double
    {
        var totalEarnings:Double = 0
        for item in myArray
        {
            totalEarnings += item.amount
        }
        self.ref.child("users").child(self.userID!).updateChildValues(["totalIncome": totalEarnings])
        return totalEarnings
    }
        
    @State var arrayAmount:[String] = []
    @State var arrayName:[String] = []
    @State var arrayType:[String] = []
    @State var updateTotalIncome:Double = 0
    @State var myArray:[EarningItem] = []

        func retrieveEarnings()
        {
            print("entrato")
            ref.child("users").child(userID!).child("earnings").observe(.value){ (snapshot) in
                self.myArray = []
                for item in snapshot.children
                {
                    let todoData = item as! DataSnapshot
                    let idItem:String = todoData.key
                    let todoItem = todoData.value as! [String:Any]
                    let ammontareEntrata:String = String(describing: todoItem["earningAmount"]!)
                    let nomeEntrata:String = String(describing: todoItem["earningName"]!)
                    let tipologiaEntrata:String = String(describing: todoItem["earningType"]!)
                    self.arrayAmount.append(ammontareEntrata)
                    self.arrayName.append(nomeEntrata)
                    self.arrayType.append(tipologiaEntrata)
                    let earningObject:EarningItem = EarningItem(idItem: idItem, name: nomeEntrata, type: tipologiaEntrata, amount: Double(ammontareEntrata)!)
                    self.myArray.append(earningObject)
                }
            }
        }
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            NavigationView
            {
                List
                {
                    ForEach(myArray)
                    {
                        item in HStack
                            {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .font(.subheadline)
                            }.padding(9.0)
                            Spacer()
                                Text("$\(item.amount, specifier: "%.2f")").padding(15.0)
                        }
                        .listRowInsets(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius:20)
                                .stroke(Color.gray, lineWidth: 5)
                        )
                    }.onDelete(perform: removeItems)
                    
                }
                .frame(height: 450)
                .navigationBarTitle("Earnings")
                .navigationBarItems(trailing:
                HStack
                {
                    Button(action:
                    {
                        self.showingAddEarning = true
                    })
                    {
                        Image(systemName: "plus.circle.fill").padding(.trailing,5)
                    }
                })
                .sheet(isPresented: $showingAddEarning) {
                    AddEarningsView(earnings: self.earnings)
                }
            }.onAppear(perform: retrieveEarnings)
               
            Divider()
            VStack
            {
                Text("You're total earnings are $ \(totalMoneyIncome, specifier: "%.2f") ")
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.yellow, lineWidth: 5)
                )
                .position(x: 185, y: 100)
                .padding(.bottom,270)
            }.frame(height: 15)
        }
    }
}

struct EarningView_Previews: PreviewProvider
{
    static var previews: some View
    {
        EarningView()
    }
}
