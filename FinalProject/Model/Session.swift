import Foundation

final class Session {

    static let shared = Session()
    private init() {}
}

// MARK: - Protocol
protocol SessionProtocol: class {
}
