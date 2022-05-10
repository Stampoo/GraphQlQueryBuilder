//
//  ArgumentProtocol.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import Foundation

public protocol ArgumentProtocol {

    var key: String { get }
    var objectType: String { get }
    var object: [String: Any] { get }

}

public struct Arg: ArgumentProtocol {

    public let key: String
    public let objectType: String
    public let object: [String: Any]

    public init(key: String, objectType: String, object: [String: Any]) {
        self.key = key
        self.objectType = objectType
        self.object = object
    }

}
