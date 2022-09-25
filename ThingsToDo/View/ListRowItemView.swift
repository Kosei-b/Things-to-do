//
//  ListRowItemView.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-24.
//

import SwiftUI

struct ListRowItemView: View {
    //MARK: - Property
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    
    //MARK: - Body
    var body: some View {
        Toggle(isOn: $item.completion){
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical, 8)
                .animation(.default)
        }//: Toggle
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange) { _ in
            if self.viewContext.hasChanges {
              try? self.viewContext.save()
            }
        }
    }//: Body
}//: Struct

