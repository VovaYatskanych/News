//
//  NewsResponse.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 05.11.2020.
//

import Foundation

public struct NewsResponse: Codable {
    
    public let status: String?
    public let totalResults: Int?
    public let articles: [Articles]
}

public struct Articles: Codable {

    public let source: Source?
    public let author: String?
    public let title: String?
    public let description: String?
    public let url: String?
    public let urlToImage: String?
    public let publishedAt: String?
}

public struct Source: Codable {

    public let id: String?
    public let name: String?
}
