//
//  GraphQlParser.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import Foundation

public protocol GraphQlParserProtocol {

    var queryParser: GraphQlQueryParserProcessorProtocol { get }
    var argumentParser: GraphQlArgumentParserProcessorProtocol { get }

    init(query: GraphQLQueryProtocol, method: GraphQlMethod)

    func parseToDictionary(for method: GraphQlMethodProtocol) -> [String: Any]

}

public struct GraphQlParser: GraphQlParserProtocol {

    // MARK: - GraphQlParserProtocol

    public let queryParser: GraphQlQueryParserProcessorProtocol
    public let argumentParser: GraphQlArgumentParserProcessorProtocol

    // MARK: - Private Properties

    private let variablesKey = "variables"

    // MARK: - Initialization

    public init(query: GraphQLQueryProtocol, method: GraphQlMethod) {
        self.queryParser = GraphQlQueryParserProcessor(buildedQuery: query, method: method)
        self.argumentParser = GraphQlArgumentParserProcessor()
    }

    // MARK: - GraphQlParserProtocol

    public func parseToDictionary(for method: GraphQlMethodProtocol) -> [String: Any] {
        let parsedQuery = queryParser.parse()
        let unparsedArguments = queryParser.getCollectedArguments()
        let parsedArguments = argumentParser.parse(arguments: unparsedArguments)
        var bodyQuery: [String: Any] = [
            method.key: parsedQuery
        ]
        if !parsedArguments.isEmpty {
            bodyQuery[variablesKey] = parsedArguments
        }
        return bodyQuery
    }

}
