//
//  File.swift
//  ManageMoney
//
//  Created by Omar Serrah on 27/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import Combine

class UserInfo: ObservableObject
{
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
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with:
        {
            (snapshot) in let value = snapshot.value as? NSDictionary
                self.firstName = value?["firstName"] as? String ?? ""
                self.lastName = value?["lastName"] as? String ?? ""
                self.userEmail = value?["email"] as? String ?? ""
                self.currentCity = value?["currentCity"] as? String ?? ""
        })
        {
            (error) in print(error.localizedDescription)
        }
    }
}
