//
//  SocialMediaListView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 09/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import SafariServices
import Firebase

struct Account: Identifiable {
    var id: Int
    let image: String
    let name: String
    let username: String
    let url: String
}

struct SocialMediaListView: View
{

    @State var firstName = ""
    @State var lastName = ""
    @State var userInstagram = ""
    @State var userEmail = ""
    @State var currentCity: String = ""
    @State var account: [Account] = []
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
                self.userInstagram = value?["userInstagram"] as? String ?? ""
                self.userEmail = value?["email"] as? String ?? ""
                self.currentCity = value?["currentCity"] as? String ?? ""
            
                self.account =
                [
                    .init(id: 0, image: "github", name: "Github", username: self.firstName + self.lastName, url: "https://github.com/" + self.firstName + self.lastName),
                   .init(id: 1, image: "facebook", name: "Facebook", username: self.firstName + " " +  self.lastName, url: "https://www.facebook.com/" + self.firstName + "." + self.lastName),
                   .init(id: 2, image: "instagram", name: "Instagram", username: self.userInstagram, url: "https://www.instagram.com/" + self.userInstagram)
                ]
             })
           {
            (error) in print(error.localizedDescription)
           }
       } 

    var body: some View
    {
        List(account, id: \.id)
        {
            info in HStack
            {
                Image(info.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading)
                {
                    Text(info.name)
                        .font(.headline)
                    Text("Username: \(info.username)")
                        .font(.subheadline)
                    Button(action:
                    {
                        if let url = URL(string: info.url)
                        {
                            UIApplication.shared.open(url)
                        }
                    })
                    {
                        Text("")
                    }
                }
            }
        }.onAppear(perform: retrieveUser)
    }
}

#if DEBUG
struct SocialMediaListView_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaListView()

    }
}
#endif
