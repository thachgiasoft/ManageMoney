//
//  AuthView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 13/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase

struct SignInView: View
{
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    let db = Firestore.firestore()
    
    func signIn()
    {
        session.signIn(email: email, password: password)
        {
            (result, error) in
            if let error = error
            {
                self.error = error.localizedDescription
            }
            else
            {
                self.email =  ""
                self.password = ""
            }
        }
    }
    
    var body: some View
    {
        VStack
        {
            Image("MoneyTrackerLogo").padding(-100)
            
            VStack(spacing: 18)
            {
                TextField("email address", text: $email)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray),lineWidth: 2))
                
                SecureField("password", text: $password)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).strokeBorder(Color(.gray), lineWidth: 2))
            }
            .padding(.vertical, 64)
            Button(action: signIn)
            {
                Text("Sign In")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size:14, weight: .bold))
                    .background(LinearGradient(gradient: Gradient(colors: [Color(.systemYellow), Color(.systemYellow)]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(14)
            }
            if(error != "")
            {
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
            
            NavigationLink(destination: SignUpView())
            {
                HStack
                {
                    Text("I'm a new user!")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.primary)
                    Text("Create an account")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(.systemYellow))
                }.padding(.all, 4)
            }
        }.padding(.horizontal, 32)
    }
}

struct AuthView: View
{
    var body: some View
    {
        NavigationView
        {
            SignInView()
            
        }
    }
}

struct AuthView_Previews: PreviewProvider
{
    static var previews: some View
    {
        AuthView().environmentObject(SessionStore())
    }
}
