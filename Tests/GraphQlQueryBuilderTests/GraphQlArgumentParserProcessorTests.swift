//
//  GraphQlArgumentParserProcessorTests.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import XCTest
@testable import GraphQlQueryBuilder

final class GraphQlArgumentParserProcessorTests: XCTestCase {

    func testOnParsingQuery() {
        let firstObject = ["name": "John"]
        let query = GraphQLQuery {
            From("resolveWebinarsAppModel") {
                Field("id")
            }
            From(
                "userGetCategoryByName",
                args: Arg(key: "input2", objectType: "UserCategoryNameInput", object: firstObject)
            ) {
                Field("name")
                Field("types")
            }
        }
        let argumentsShouldBe: [String: Any] = ["input2": firstObject]

        let queryParser: GraphQlQueryParserProcessorProtocol = GraphQlQueryParserProcessor(buildedQuery: query)
        _ = queryParser.parse()
        let argumentParser: GraphQlArgumentParserProcessorProtocol = GraphQlArgumentParserProcessor()
        let parsedArguments = argumentParser.parse(arguments: queryParser.getCollectedArguments())

        XCTAssertEqual(argumentsShouldBe.description, parsedArguments.description)
    }

}
