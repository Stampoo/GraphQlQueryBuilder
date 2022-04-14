# GraphQlQueryBuilder

### How to

```swift
// GraphQL query in request builder representation with friendly API
let query = GraphQLQuery {
    From("posts") {
        Field("id")
    }
}

// Builder query parser, generate query in [String: Any] type
let parser = GraphQlParser(query: query)
let parsedQuery = parser.parseToDictionary(for: GraphQlMethod.query)

// Create request with GraphQL query
let url = URL(string: "https://example.com")
var request = try getRequest(for: url)
request.httpBody = try JSONSerialization.data(withJSONObject: parsedQuery)

// Send request to any GraphQL backend
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
            print(error)
        }
    } receiveValue: { model in
        print(model)
    }
```
