//
//  LogInCheck.swift
//  ManageMoney
//
//  Created by Omar Serrah on 09/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//


import SwiftUI

struct LogInCheck: View
{
    @EnvironmentObject var session: SessionStore
    
    func getUser()
    {
        session.listen()
    }
    
    var body: some View {
        Group
        {
            if (session.session != nil)
            {
                TabBarView()
            }
            else
            {
                AuthView()
            }
        }.onAppear(perform: getUser)
    }
}

struct LogInCheck_Previews: PreviewProvider
{
    static var previews: some View
    {
        LogInCheck().environmentObject(SessionStore())
    }
}

