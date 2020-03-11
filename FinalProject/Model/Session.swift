//
//  Session.swift
//  FinalProject
//
//  Created by Tung Nguyen C.T. on 3/11/20.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation

final class Session {

    static let shared = Session()

    private init() {}
}

// MARK: - Protocol
protocol SessionProtocol: class {
}
