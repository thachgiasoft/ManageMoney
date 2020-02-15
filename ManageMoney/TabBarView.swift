//
//  TabBarView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 18/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct TabBarView: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var userEmail = ""
    @State var currentCity: String = ""
    @EnvironmentObject var session: SessionStore

    
    @State var dbReference:DatabaseReference = Database.database().reference().child("users")

    func retrieveUser()
    {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            let value = snapshot.value as? NSDictionary
            self.firstName = value?["firstName"] as? String ?? ""
            self.lastName = value?["lastName"] as? String ?? ""
            self.userEmail = value?["email"] as? String ?? ""
            self.currentCity = value?["currentCity"] as? String ?? ""
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    var body: some View {
        TabView
        {
            LineChartsFull()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.bar.fill")
                        Text("Chart's")
                    }
            }.tag(1)
            
            SpendingView()
                .tabItem {
                    VStack {
                        Image(systemName: "bag.fill.badge.minus")
                        Text("Spending")
                    }
            }.tag(2)
            
            EarningView()
                .tabItem {
                VStack
                {
                    Image(systemName: "bag.fill.badge.plus")
                    Text("Earnings")
                    }
            }.tag(3)
            
            SecondTabView()
                .tabItem {
                    VStack {
                        Image(systemName: "bag.fill")
                        Text("Average")
                    }
            }.tag(4)
            
            UserProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }.tag(5)
        }
    }
}
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
