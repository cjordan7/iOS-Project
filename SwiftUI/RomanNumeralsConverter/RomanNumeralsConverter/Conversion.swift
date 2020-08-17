//
//  Conversion.swift
//  RomanNumeralsConverter
//
//  Created by Cosme Jordan on 02.08.20.
//  Copyright © 2020 Cosme Jordan. All rights reserved.
//

import SwiftUI

struct RomanView: View {
    var roman: String
    
    var body: some View {
        Text(tryRoman(roman)).padding(.horizontal)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 3))
    }
    
    func tryRoman(_ roman: String) -> String {
        do {
            return "\(try roman.uppercased().romanNumeralValue())"
        } catch {
            return "Not convertible"
        }
    }
}

struct NumeralView: View {
    var numeral: String
    
    var body: some View {
        Text(tryNumeral(numeral)).padding(.horizontal)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 3))
    }
    
    func tryNumeral(_ numeral: String) -> String {
        if let numeralInt = Int(numeral) {
            return numeralInt.toRoman()
        } else {
            return "Not convertible"
        }
    }
}


struct Conversion: View {
    var mainText: String
    @State var textFromField: String
    var isRomanNumerals: Bool
    @State var value: CGFloat = 0
    
    var body: some View {
        VStack {
            Text(mainText)
            TextField(textFromField, text: $textFromField)
                .autocapitalization(.allCharacters)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 20)
                .padding(.horizontal, 10)
                .keyboardType(keyboard(isRomanNumerals))
            
            Text("Result: ").padding(.vertical, 20)
            if(isRomanNumerals) {
                RomanView(roman: textFromField)
            } else {
                NumeralView(numeral: textFromField)
            }
            
        }.padding(.bottom)
            .font(.system(size: 32))
            .offset(y: -self.value/2)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main)
                { (noti) in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    
                    let height = value.height
                    self.value = height
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main)
                { (noti) in
                    self.value = 0
                }
        }
    }
    
    private func keyboard(_ isRomanNumerals: Bool) -> UIKeyboardType {
        return isRomanNumerals ? UIKeyboardType.default : UIKeyboardType.numberPad
    }
}

struct Conversion_Previews: PreviewProvider {
    static var previews: some View {
        Conversion(mainText: "Roman", textFromField: "VII", isRomanNumerals: true)
    }
}
