//
//  ChartView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 28/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import SwiftUICharts
import Firebase

struct LineChartsFull: View
{
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    @State var arrayAmount:[Double] = [0]
    @State var arrayEarnings:[Double] = [0]
    @State var totalExpense:Double = 0
    @State var totalEarning:Double = 0
    

    func retrieveSpendings()
    {
        ref.child("users").child(userID!).child("spendings").observe(.value){ (snapshot) in
            self.arrayAmount = []
            for item in snapshot.children
            {
                let todoData = item as! DataSnapshot
                let todoItem = todoData.value as! [String:Any]
                let ammontareSpesa:String = String(describing: todoItem["spendingAmount"]!)
                let intSpending:Double = Double(ammontareSpesa)!
                self.arrayAmount.append(intSpending)
            }
        }
    }
    func retrieveEarnings()
    {
        ref.child("users").child(userID!).child("earnings").observe(.value){ (snapshot) in
            self.arrayEarnings = []
            for item in snapshot.children
            {
                let todoData = item as! DataSnapshot
                let todoItem = todoData.value as! [String:Any]
                let ammontareIncome:String = String(describing: todoItem["earningAmount"]!)
                let intIncome:Double = Double(ammontareIncome)!
                self.arrayEarnings.append(intIncome)
            }
        }
    }

    
    func retrieveTotalIncome()
    {
        let pippo = ref.child("users").child(userID!).child("totalIncome")

        pippo.observeSingleEvent(of : .value, with : {(Snapshot) in
            if let totalIncome = Snapshot.value as? Double
            {
                self.totalEarning = totalIncome
                    print(totalIncome)
            }
        })
    }
    
    func retrieveTotalExpenses()
    {
        let pluto = ref.child("users").child(userID!).child("totalSpendings")

        pluto.observeSingleEvent(of : .value, with : {(Snapshot) in
            if let totalSpending = Snapshot.value as? Double
            {
                self.totalExpense = totalSpending
                    print(totalSpending)
            }
        })
    }
    
    var body: some View
    {
        VStack
        {
            LineView(data: arrayAmount , title: "Spendings : \(self.totalExpense)$")
            .onAppear(perform: retrieveSpendings)
            .onAppear(perform: retrieveTotalExpenses)
            
            Spacer()
            
            LineView(data: arrayEarnings, title: "Incomes : \(self.totalEarning)$")
            .onAppear(perform: retrieveEarnings)
            .onAppear(perform: retrieveTotalIncome)

            
                
            
            }.padding(.bottom, 80)
    }
}


struct ChartView_Previews: PreviewProvider
{
    static var previews: some View
    {
        LineChartsFull()
    }
}
