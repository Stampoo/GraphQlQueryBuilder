//
//  Builders.swift
//
//
//  Created by Князьков Илья on 14.04.2022.
//


import Foundation

@resultBuilder
enum GrapqhQlQueryBuilder {

    static func buildBlock(_ components: QueryElement...) -> [QueryElement] {
        components
    }

}
