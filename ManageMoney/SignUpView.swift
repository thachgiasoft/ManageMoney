//
//  SignUpView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 22/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct SignUpView: View
{
    
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var current_city: String = ""
    @State var instagram_username: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    
    var ref: DatabaseReference! = Database.database().reference()

    func signUp()
    {
        session.signUp(email: email, password: password) { (resukt, error) in
            if let error = error
            {
                self.error = error.localizedDescription
            }
            else
            {
                let userID = Auth.auth().currentUser!.uid

                self.ref.child("users").child(userID).updateChildValues(
                    [
                        "email": self.email ,
                        "firstName": self.first_name,
                        "lastName" : self.last_name,
                        "userInstagram" : self.instagram_username,
                        "currentCity": self.current_city
                    ]
                )
            }
        }
    }
    
    var body: some View
    {
        VStack
        {
            Text("Create Account")
                .font(.system(size: 32, weight: .heavy))
            
            Text("Sign up to get started")
                .font(.system(size: 32, weight: .medium))
            ScrollView {
                VStack(spacing: 12)
                {
                    TextField("First Name", text: $first_name)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray),
                                lineWidth: 2))
                    
                    TextField("Last Name", text: $last_name)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray),
                                lineWidth: 2))
                    
                    TextField("Instagram username", text: $instagram_username)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray),
                                lineWidth: 2))
                    
                    TextField("Current City", text: $current_city)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray),
                                lineWidth: 2))
                    
                    TextField("Email address", text: $email)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray),
                                    lineWidth: 2))
                    
                    SecureField("Password", text: $password)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray),
                        lineWidth: 2))
                    
                }.padding(.vertical, 64)
                .keyboardResponsive()
            }
            Button(action: signUp)
            {
                Text("Create Account")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [Color(.systemYellow), Color(.systemYellow)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(14)
            }
            .padding(.top, 2.0)
            if (error != "")
            {
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
        }.padding(.horizontal , 32)
    }
}

struct SignUpView_Previews: PreviewProvider
{
    static var previews: some View
    {
        SignUpView().environmentObject(SessionStore())
    }
}
