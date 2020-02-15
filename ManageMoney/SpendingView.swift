//
//  SpendingView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 18/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct SpendingItem : Identifiable, Codable
{
    let id = UUID()
    let idItem: String
    let name: String
    let type: String
    let amount: Double
}

class Spendings: ObservableObject
{
    @Published var item = [SpendingItem] ()
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
            if let decoded = try? decoder.decode([SpendingItem].self, from: item)
            {
                self.item = decoded
                return
            }
        }
        self.item = []
    }
}


struct SpendingView: View
{
    var ref = Database.database().reference()
    
    let userID = Auth.auth().currentUser?.uid

    @ObservedObject var spendings = Spendings()
    
    func removeItems(at offsets: IndexSet)
    {
        let itemTmp: SpendingItem = myArray[offsets.first!]
        myArray.remove(atOffsets: offsets)
        
        ref.child("users").child(self.userID!).child("spendings").child(itemTmp.idItem).removeValue()
        
    }
    
    var numberOfSpendings: Double
    {
        let numberOfExpenses = Double(myArray.count)
        self.ref.child("users").child(self.userID!).updateChildValues(["numberOfExpenses": numberOfExpenses])

        return numberOfExpenses
    }

    
    @State var arrayAmount:[String] = []
    @State var arrayName:[String] = []
    @State var arrayType:[String] = []
    @State var myArray:[SpendingItem] = []
    @State var showingAddSpending = false
    @State var speseTotali: Double = 0


        func retrieveSpendings()
        {
            ref.child("users").child(userID!).child("spendings").observe(.value){ (snapshot) in
                self.myArray = []
                self.speseTotali = 0
                for item in snapshot.children
                {
                    let expenseData = item as! DataSnapshot
                    let idItem:String = expenseData.key
                    let expenseItem = expenseData.value as! [String:Any]
                    let ammontareSpesa:String = String(describing: expenseItem["spendingAmount"]!)
                    let nomeSpesa:String = String(describing: expenseItem["spendingName"]!)
                    let tipologiaeSpesa:String = String(describing: expenseItem["spendingType"]!)
                    self.arrayAmount.append(ammontareSpesa)
                    self.arrayName.append(nomeSpesa)
                    self.arrayType.append(tipologiaeSpesa)
                    let spendingObject:SpendingItem = SpendingItem(idItem: idItem, name: nomeSpesa, type: tipologiaeSpesa, amount: Double(ammontareSpesa)!)
                    self.myArray.append(spendingObject)
                }
                for item in self.myArray
                {
                    self.speseTotali += item.amount
                }
                print("total spendings is " ,self.speseTotali)
                self.ref.child("users").child(self.userID!).updateChildValues(["totalSpendings": self.speseTotali])
            }
        }
    
    init() {
        // To remove only extra separators below the list:
        UITableView.appearance().tableFooterView = UIView()

        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
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
                .navigationBarTitle("Spendings")
                .navigationBarItems(trailing:
                HStack
                {
                    Button(action:
                    {
                        self.showingAddSpending = true
                    })
                    {
                        Image(systemName: "plus.circle.fill").padding(.trailing,5)
                    }
                })
                .sheet(isPresented: $showingAddSpending) {
                    AddSpendingsView(spendings: self.spendings)
                }
            }.onAppear(perform: retrieveSpendings)
               
            Divider()
            VStack
            {
                Text("You're total spendings are $ \(self.speseTotali, specifier: "%.2f")")
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

struct SpendingView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SpendingView()
    }
}
