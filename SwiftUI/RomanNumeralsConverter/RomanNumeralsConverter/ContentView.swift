
import SwiftUI

struct ContentView: View {
    private var mainRomanText = "Enter Roman Number: "
    private var romanPlaceHolder: String = "VII"
    
    private var mainText = "Enter a Number: "
    private var placeHolder: String = "7"
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination:
                    Conversion(mainText: mainRomanText,
                               textFromField: romanPlaceHolder,
                               isRomanNumerals: true),
                               label: {
                    Text("Numeral To Roman Number")
                })
                
                NavigationLink(destination:
                    Conversion(mainText: mainText,
                               textFromField: placeHolder,
                               isRomanNumerals: false),
                               label: {
                    Text("Roman Number To Numeral")
                })
            }.navigationBarTitle(Text("Roman Numbers"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
