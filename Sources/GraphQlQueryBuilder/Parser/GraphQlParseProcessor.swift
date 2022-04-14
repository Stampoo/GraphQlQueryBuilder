//
//  GraphQlQueryParserProcessorProtocol.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import Foundation

public protocol GraphQlQueryParserProcessorProtocol {

    init(buildedQuery: GraphQLQueryProtocol)

    func parse() -> String
    func getCollectedArguments() -> [ArgumentProtocol]

}

public final class GraphQlQueryParserProcessor: GraphQlQueryParserProcessorProtocol {

    // MARK: - Private Properties

    private let newLine = "\n"
    private let figuredBracketLeft = "{"
    private let figuredBracketRight = "}"
    private let bracketLeft = "("
    private let bracketRight = ")"
    private let pointer = "$"
    private let doubleDot = ":"
    private let comma = ","
    private let whiteSpace = " "
    private let doubleWhiteSpace = "  "
    private let queryPrefix = "query"

    private let rawQueryBuilderResult: GraphQLQueryProtocol
    private var arguments: [ArgumentProtocol] = []

    // MARK: - GraphQlQueryParserProcessorProtocol

    required public init(buildedQuery: GraphQLQueryProtocol) {
        self.rawQueryBuilderResult = buildedQuery
    }

    public func parse() -> String {
        parsedQuery(rawQueryBuilderResult)
    }

    public func getCollectedArguments() -> [ArgumentProtocol] {
        arguments
    }

}

// MARK: - Internal Methods

extension GraphQlQueryParserProcessor {

    func parsedQuery(_ query: GraphQLQueryProtocol) -> String {
        guard
            let queryName = query.components.first?.name,
            let firstLetter = queryName.first
        else {
            return ""
        }
        let transformedName = String(firstLetter).capitalized + queryName.dropFirst()
        let queryElements = query.components.reduce("") { partialResult, element in
            partialResult + parsedQeryElement(element, level: 1) + newLine
        }
        let parsedQuery = queryPrefix
            + whiteSpace
            + transformedName
            + parsedArgumentsForQueryHeader(arguments)
            + whiteSpace
            + figuredBracketLeft
            + newLine
            + queryElements
            + newLine
            + figuredBracketRight
        return parsedQuery.replacingOccurrences(of: newLine + newLine, with: newLine)
    }

    func parsedArgumentsForQueryHeader(_ arguments: [ArgumentProtocol]) -> String {
        arguments.isEmpty ? "" : arguments.enumerated().reduce(bracketLeft) { partialResult, element in
            let argument = element.element
            let index = element.offset
            let parsedArgument = partialResult
                + pointer
                + argument.key
                + doubleDot
                + whiteSpace
                + argument.objectType
                + comma
                + whiteSpace
            if arguments.endIndex - 1 == index {
                return parsedArgument.dropLast(2) + bracketRight
            }
            return parsedArgument
        }
    }

    func parsedQeryElement(_ queryElement: QueryElement, level: Int) -> String {
        let parsedArguments = parsedArgumentsForQueryElement(queryElement.args)
        let parsedChilds = queryElement.subItems.reduce("") { partialResult, element in
            partialResult + parsedQeryElement(element, level: level + 1)
        }
        let rightIdent = level < 1 ? "" : (0...level - 1).reduce("") { partialResult, _ in
            partialResult + doubleWhiteSpace
        }
        let childsPart = queryElement.subItems.isEmpty ? newLine : whiteSpace
            + figuredBracketLeft
            + newLine
            + parsedChilds
            + newLine
            + rightIdent
            + figuredBracketRight
        let parsedQueryElement = rightIdent
            + queryElement.name
            + parsedArguments
            + childsPart

        return parsedQueryElement.replacingOccurrences(of: newLine + newLine, with: newLine)
    }

    func parsedArgumentsForQueryElement(_ arguments: [ArgumentProtocol]) -> String {
        self.arguments.append(contentsOf: arguments)
        return arguments.isEmpty ? "" : arguments.enumerated().reduce(bracketLeft) { partialResult, element in
            let argument = element.element
            let index = element.offset
            let parsedArgument = partialResult
                + argument.key
                + doubleDot
                + whiteSpace
                + pointer
                + argument.key
                + comma
                + whiteSpace
            if arguments.endIndex - 1 == index {
                return parsedArgument.dropLast(2) + bracketRight
            }
            return parsedArgument
        }
    }

}
