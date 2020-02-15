//
//  SecondTabView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 08/02/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct SecondTabView: View
{
    @State var tabIndex:Int = 0
    var body: some View
    {
        TabView(selection: $tabIndex)
        {
            SplitMoneyView().tabItem
            {
                Group
                {
                    Image(systemName: "bag.fill")
                    Text("SplitMoney")
                }
            }.tag(0)
            
            MonthAverageView().tabItem
            {
                Group
                {
                    Image(systemName: "function")
                    Text("Month Average")
                }
            }.tag(1)
        }
    }
}



struct SecondTabView_Previews: PreviewProvider {
    static var previews: some View {
        SecondTabView()
    }
}
