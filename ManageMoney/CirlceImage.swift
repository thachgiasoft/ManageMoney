//
//  CircleImage.swift
//  ManageMoney
//
//  Created by Omar Serrah on 09/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI
import SDWebImage

struct CircleImage: View {
    @State var url = ""
    
    let userID = Auth.auth().currentUser?.uid
    
    var body: some View
    {
        VStack
        {
            if url != ""
            {
                AnimatedImage(url: URL(string: url)!)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 10)
            }
            else
            {
                Loader()
            }
        }
        .onAppear{
            let storage = Storage.storage().reference()
            storage.child(self.userID!).downloadURL { (url, err) in
                if err != nil
                {
                    storage.child("placeholder.jpeg").downloadURL { (url, err) in
                        if err != nil
                        {
                            
                        }
                        else
                        {
                            self.url = "\(url!)"
                        }
                    }
                }
                else
                {
                    self.url = "\(url!)"
                }
            }
        }
    }
}

struct Loader : UIViewRepresentable
{
    func makeUIView(context: UIViewRepresentableContext<Loader>) -> UIActivityIndicatorView
    {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Loader>)
    {
        
    }
}


struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
