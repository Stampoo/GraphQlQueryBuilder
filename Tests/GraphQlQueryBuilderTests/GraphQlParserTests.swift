//
//  GraphQlParserTests.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//

import XCTest
import Combine
@testable import GraphQlQueryBuilder

final class GraphQlParserTests: XCTestCase {
    
    private enum Error: Swift.Error {
        case urlWasNotFound
        case objectIsNotValidJson
    }

    private var cancellableEventsContainer: Set<AnyCancellable> = []

    func testOnSuccessfulRequest() throws {
        let query = GraphQLQuery {
            From("movies") {
                Field("name")
                Field("genre")
            }
        }
        let parser = GraphQlParser(query: query)
        let parsedQuery = parser.parseToDictionary(for: GraphQlMethod.query)
        let expectation = expectation(description: "GraphQL request")
        let url = URL(string: "https://n7b67.sse.codesandbox.io/graphql")
        var request = try getRequest(for: url)
        request.httpBody = try JSONSerialization.data(withJSONObject: parsedQuery)
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data -> [String: Any] in
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    throw Error.objectIsNotValidJson
                }
                return json
            }
            .sink { result in
                if case let .failure(error) = result {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { model in
                expectation.fulfill()
            }
            .store(in: &cancellableEventsContainer)

        waitForExpectations(timeout: 3, handler: nil)
    }

}

extension GraphQlParserTests {

    func getRequest(for url: URL?) throws -> URLRequest {
        guard let url = url else {
            throw Error.urlWasNotFound
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        return request
    }

}
