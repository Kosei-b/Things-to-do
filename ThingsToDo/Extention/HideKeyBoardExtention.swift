//
//  HideKeyBoardExtention.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-20.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard () {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
    }
}
#endif
