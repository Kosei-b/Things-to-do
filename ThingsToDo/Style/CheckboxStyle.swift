//
//  CheckboxStyle.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-24.
//

import SwiftUI

//MARK: - CheckboxStyle
struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
              .foregroundColor(configuration.isOn ? .pink : .primary)
              .font(.system(size: 30, weight: .semibold, design: .rounded))
              .onTapGesture {
                configuration.isOn.toggle()
                feedback.notificationOccurred(.success)
                
                if configuration.isOn {
                  playSound(sound: "sound-rise", type: "mp3")
                } else {
                  playSound(sound: "sound-tap", type: "mp3")
                }
              }
            
            configuration.label
                  
        }//: HStack
    }//: func
}

//MARK: - Preview
struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholde label", isOn: .constant(true))
            .toggleStyle(CheckboxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
