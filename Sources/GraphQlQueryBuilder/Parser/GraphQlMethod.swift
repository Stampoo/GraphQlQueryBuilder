//
//  GraphQlMethod.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

public protocol GraphQlMethodProtocol {

    var key: String { get }

}

public enum GraphQlMethod: String {
    case query
    case mutations
}

extension GraphQlMethod: GraphQlMethodProtocol {

    public var key: String {
       rawValue
    }

}
