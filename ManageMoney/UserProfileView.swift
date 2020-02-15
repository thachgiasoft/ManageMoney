//
//  ContentView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 09/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct UserProfileView: View
{
    
    @State var firstName = ""
    @State var lastName = ""
    @State var userEmail = ""
    @State var userInstagram = ""
    @State var currentCity: String = ""
    @State var shown = false
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
          }) { (error) in print(error.localizedDescription) }
    }
    
    var logOutButton : some View
     {
        Button(action: session.signOut)
        {
            Text("Sign Out");
            Image(systemName: "escape")
        }
     }
    
    var body: some View
    {
        VStack()
        {
            MapView().frame(height: 300)
            CircleImage().offset(y: -130).padding(.bottom, -130)
        
            VStack(alignment: .leading)
            {
                HStack
                {
                    Text("\(firstName) \(lastName)")
                        .font(.title)
                    Spacer()
                    Button(action:
                    {
                        self.shown.toggle()
                    })
                    {
                        Text("Upload Image")
                        Image(systemName: "person.crop.circle.badge.plus.fill")
                        }.sheet(isPresented: $shown) {
                        imagePicker(shown: self.$shown)
                    }
                }
               
                HStack()
                {
                    Text("Università di \(currentCity)")
                        .font(.subheadline)
                    Spacer()
                    logOutButton
                }
    
            }.padding()
            SocialMediaListView()
        }.edgesIgnoringSafeArea(.top)
        .onAppear(perform: retrieveUser )
    }
}


struct UserProfileView_Previews: PreviewProvider
{
    static var previews: some View
    {
        UserProfileView()
    }
}

struct imagePicker: UIViewControllerRepresentable
{
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePicker.Coordinator(parent1: self)
    }
    @Binding var shown : Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> imagePicker.UIViewControllerType
    {
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        return imagepic
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context:
        UIViewControllerRepresentableContext<imagePicker>) {

    }
    class Coordinator: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate
    {
        var parent : imagePicker!
        init(parent1 : imagePicker)
        {
            parent = parent1
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
        {
            parent.shown.toggle()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {

            let userID = Auth.auth().currentUser?.uid

            let image = info[.originalImage] as! UIImage
            let storage = Storage.storage()
            storage.reference().child(userID!).putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) {(_, err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                print("success")
            }
            parent.shown.toggle()
        }
    }
}

