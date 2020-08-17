
import SwiftUI

enum Buttons: String {
    case zero = "0", one="1", two="2", three="3", four="4", five="5", six="6", seven="7", eight="8", nine="9"
    case equals="=", plus="+", minus="-", divide="÷", multiply="*"
    case ac="AC", plusMinus="±", percent="%", dot="."
    
    var color: Color {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .dot:
            return Color(.darkGray)
        case .equals, .plus, .minus, .divide, .multiply:
            return .orange
        default:
            return Color(.lightGray)
        }
    }
}

struct ContentView: View {
    private let rowButtons: [[Buttons]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .dot, .equals]
    ]
    
    private let cornerRadius: CGFloat = 42
    private let spacing: CGFloat = 10
    private let buttonHeight = (UIScreen.main.bounds.width - 5*11)/4

    var body: some View {
        ZStack(alignment: .bottom) {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack(spacing: self.spacing) {
            HStack {
                Spacer()
                Text("42")
                // TODO: TODO Calcualtion logic
            }.padding()
            
            ForEach(rowButtons, id: \.self) { row in
                HStack(spacing: self.spacing) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            // TODO: TODO Action
                        }, label: {
                            Text(button.rawValue)
                                .font(.system(size: 32))
                                .frame(width: self.buttonWidth(button), height: self.buttonHeight)
                                .background(button.color)
                                .cornerRadius(self.cornerRadius)
                        })
                    }
                }
            }
        }.padding(.bottom)
            .foregroundColor(.white)
            .font(.system(size: 72))
        }
    }
    
    private func buttonWidth(_ button: Buttons) -> CGFloat {
        if(button == .zero) {
            return buttonHeight * 2
        }
        return buttonHeight
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
