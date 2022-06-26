//
//  GraphQlKeyDuplicateTransformer.swift
//  
//
//  Created by Князьков Илья on 26.06.2022.
//

import Foundation

public protocol GraphQlKeyDuplicateTransformer {

    func transformDuplicateKey(_ argumentKey: String, in arguments: [ArgumentProtocol]) -> String

}

public extension GraphQlKeyDuplicateTransformer {

    func transformDuplicateKey(_ argumentKey: String, in arguments: [ArgumentProtocol]) -> String {
        let repeatingArgumentsCount = arguments.filter { argument in
            argument.key == argumentKey
        }.count
        guard repeatingArgumentsCount != .zero else {
            return argumentKey
        }
        return argumentKey + "\(repeatingArgumentsCount)"
    }

}
