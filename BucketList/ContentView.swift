//
//  ContentView.swift
//  BucketList
//
//  Created by Yashraj jadhav on 26/03/23.
//

import SwiftUI

struct ContentView: View {
    let users = [
        User(firstName: "Arnold", LastName: "Rimmer"),
        User(firstName: "Kristine", LastName: "Kochanski"),
        User(firstName: "David", LastName: "Lister"),
    ].sorted()
    

    var body: some View {
        Text("Hello World")
            .onTapGesture {
                let str = "Test Message"
                let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                
                do {
                    try str.write(to: url , atomically: true , encoding: .utf8)
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one

        return path[0]
    }
}

struct User : Identifiable ,Comparable {
    let id = UUID()
    let firstName : String
    let LastName : String
    
    static func <(lhs:User , rhs:User) ->Bool {
        lhs.LastName < rhs.LastName
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
