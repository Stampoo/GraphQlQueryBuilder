//
//  GraphQLQueryProtocol.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import Foundation

public protocol GraphQLQueryProtocol {

    var components: [QueryElement] { get }

}

public struct GraphQLQuery: GraphQLQueryProtocol {

    public let components: [QueryElement]

    public init(@GrapqhQlQueryBuilder _ componentsBlock: () -> [QueryElement]) {
        self.components = componentsBlock()
    }

}
