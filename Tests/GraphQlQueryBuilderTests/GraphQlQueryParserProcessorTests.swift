//
//  GraphQlQueryBuilder.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import XCTest
@testable import GraphQlQueryBuilder

final class GraphQlQueryParserProcessorTests: XCTestCase {

    func testOnParsingArgumentsForField() {
        let firstArg = Arg(key: "argOne", objectType: "", object: [:])
        let secondArg = Arg(key: "argTwo", objectType: "", object: [:])
        let thirdArg = Arg(key: "argThree", objectType: "", object: [:])

        let argumentWillShouldBe = "(argOne: $argOne, argTwo: $argTwo, argThree: $argThree)"
        let parser = GraphQlQueryParserProcessor(buildedQuery: GraphQLQuery { }, method: .query)
        let parsedArguments = parser.parsedArgumentsForQueryElement([firstArg, secondArg, thirdArg])

        XCTAssertEqual(argumentWillShouldBe, parsedArguments)

        let parsedZeroArguments = parser.parsedArgumentsForQueryElement([])

        XCTAssertEqual("", parsedZeroArguments)
    }

    func testOnParsingQueryElement() {
        let queryElement = From("fieldName", args: Arg(key: "input", objectType: "", object: [:])) {
            Field("id")
        }
        let queryWillShouldBe = """
        fieldName(input: $input) {
          id
        }
        """
        let parser = GraphQlQueryParserProcessor(buildedQuery: GraphQLQuery { }, method: .query)
        let parsedQueryElement = parser.parsedQeryElement(queryElement, level: .zero)
        XCTAssertEqual(queryWillShouldBe, parsedQueryElement)

        let queryWithSubQueryElement = From("fieldName", args: Arg(key: "input", objectType: "", object: [:])) {
            From("secondField", args: Arg(key: "input2", objectType: "", object: [:])) {
                Field("id")
                Field("name")
            }
        }
        let queryWithSubQueryWillShouldBe = """
        fieldName(input: $input) {
          secondField(input2: $input2) {
            id
            name
          }
        }
        """
        let secondParser = GraphQlQueryParserProcessor(buildedQuery: GraphQLQuery { }, method: .query)
        let parsedQueryWithSubQueryElement = secondParser.parsedQeryElement(queryWithSubQueryElement, level: .zero)
        print(parsedQueryWithSubQueryElement)
        XCTAssertEqual(queryWithSubQueryWillShouldBe, parsedQueryWithSubQueryElement)
    }

    func testOnParsingQuery() {
        let queryShoulBe = """
        query ResolvedAppModel($input: BaseInput!, $input2: CategoryNameInput!) {
          resolvedAppModel {
            id
          }
          userGetPayload(input: $input) {
            signature
          }
          userGetCategoryByName(input2: $input2) {
            name
            types
          }
        }
        """
        let query = GraphQLQuery {
            From("resolvedAppModel") {
                Field("id")
            }
            From("userGetPayload", args: Arg(key: "input", objectType: "BaseInput!", object: [:])) {
                Field("signature")
            }
            From("userGetCategoryByName", args: Arg(key: "input2", objectType: "CategoryNameInput!", object: [:])) {
                Field("name")
                Field("types")
            }
        }

        let parser = GraphQlQueryParserProcessor(buildedQuery: query, method: .query)
        let parsedQuery = parser.parse()
        print(parsedQuery)

        XCTAssertEqual(queryShoulBe, parsedQuery)
    }

}
