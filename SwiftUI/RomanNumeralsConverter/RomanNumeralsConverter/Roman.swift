
import Foundation

extension Int {
    func toRoman() -> String {
        var number = self
        var result = ""
        let listRomansConversion = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        
        for i in listRomansConversion {
            while(number >= i.0) {
                number -= i.0
                result += i.1
            }
        }
        return result
    }
}

extension String {
    enum RomanError: Error {
        case invalidRomanNumber
    }
    
    func romanNumeralValue() throws -> Int  {
        guard range(of: "^(?=[MDCLXVI])M*(C[MD]|D?C{0,3})(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$", options: .regularExpression) != nil else {
            throw RomanError.invalidRomanNumber
        }

        var result = 0
        var maxValue = 0
        uppercased().reversed().forEach {
            let value: Int
            switch $0 {
            case "M":
                value = 1000
            case "D":
                value = 500
            case "C":
                value = 100
            case "L":
                value = 50
            case "X":
                value = 10
            case "V":
                value = 5
            case "I":
                value = 1
            default:
                value = 0
            }
            maxValue = max(value, maxValue)
            result += value == maxValue ? value : -value
        }
        return result
    }
}
