//
//  QueryElement.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import Foundation

public protocol QueryElement {

    var name: String { get }
    var args: [ArgumentProtocol] { get }
    var subItems: [QueryElement] { get }

}

public struct From: QueryElement {

    public let name: String
    public let args: [ArgumentProtocol]
    public let subItems: [QueryElement]

    public init(_ fieldName: String, args: ArgumentProtocol..., @GrapqhQlQueryBuilder fields: () -> [QueryElement] = { [] }) {
        self.name = fieldName
        self.args = args
        self.subItems = fields()
    }

}

struct Field: QueryElement {

    public let name: String
    public let args: [ArgumentProtocol]
    public let subItems: [QueryElement]

    public init(_ fieldName: String) {
        self.name = fieldName
        self.args = []
        self.subItems = []
    }

}
