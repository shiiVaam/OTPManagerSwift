// The Swift Programming Language
// https://docs.swift.org/swift-book

enum OTPManager {
    enum OTPLength {
        case four
        case six
        case custom(Int)
        
        var value: Int {
            switch self {
            case .four: return 4
            case .six: return 6
            case .custom(let number): return number
            }
        }
        
        static func instance(for value: Int) -> OTPLength {
            switch value {
            case _ where value < 2, 4: return .four
            case _ where value > 7, 6: return .six
            default: return .custom(value)
            }
        }
    }
}
