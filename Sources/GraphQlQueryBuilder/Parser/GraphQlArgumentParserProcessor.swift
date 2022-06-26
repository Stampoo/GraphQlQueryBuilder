//
//  GraphQlArgumentParserProcessor.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import Foundation

public protocol GraphQlArgumentParserProcessorProtocol: GraphQlKeyDuplicateTransformer {

    func parse(arguments: [ArgumentProtocol]) -> [String: Any]

}

public struct GraphQlArgumentParserProcessor: GraphQlArgumentParserProcessorProtocol {

    public func parse(arguments: [ArgumentProtocol]) -> [String: Any] {
        parseIntoDictionary(from: arguments)
    }

}

// MARK: - Private Methods

private extension GraphQlArgumentParserProcessor {

    func parseIntoDictionary(from arguments: [ArgumentProtocol]) -> [String: Any] {
        var passedArguments: [ArgumentProtocol] = []
        return arguments.reduce(into: [String: Any]()) { partialResult, argument in
            partialResult[transformDuplicateKey(argument.key, in: passedArguments)] = argument.object
            passedArguments.append(argument)
        }
    }

}

