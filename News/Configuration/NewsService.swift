//
//  NewsService.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 05.11.2020.
//

import Foundation

enum NewsService {
    
    public static var country: String = "Ukraine"
    public static var category: String = ""
    public static var source: String = ""
    public static var searchString: String?
    
    private static let apiKey = "f460cffee55c4d94af75df06b6346f85"
    
    private static let countries: [String : String] = [
        "Ukraine" : "ua",
        "USA" : "us",
        "Poland" : "pl"
    ]
    
    private static let categories: [String : String] = [
        "Business" : "business",
        "Entertainment" : "entertainment",
        "General" : "general",
        "Health" : "health",
        "Science" : "science",
        "Sports" : "sports",
        "Technology" : "technology"
    ]
    
    private static let sources: [String : String] = [
        "BBC News" : "bbc-news",
        "Bloomberg" : "bloomberg",
        "CBC News" : "cbc-news",
        "CNN" : "cnn",
        "Google News" : "google-news"
    ]
    
    private static func createURL(page: Int) -> String {
        
        guard let search = searchString else {
            
            if let cat: String = categories[category]{
                return "http://newsapi.org/v2/top-headlines?category=\(cat)&country=\(countries[country] ?? "ua")&sortBy=publishedAt&pageSize=5&page=\(page)&apiKey=\(apiKey)"
            } else if let sou: String = sources[source] {
                return "http://newsapi.org/v2/top-headlines?sources=\(sou)&sortBy=publishedAt&pageSize=5&page=\(page)&apiKey=\(apiKey)"
            } else {
                return "http://newsapi.org/v2/top-headlines?&country=\(countries[country] ?? "ua")&sortBy=publishedAt&pageSize=5&page=\(page)&apiKey=\(apiKey)"
            }
        }
        searchString = "+\(search)"
        
        return "http://newsapi.org/v2/everything?qInTitle=\(searchString ?? "")&sortBy=publishedAt&pageSize=5&page=\(page)&apiKey=\(apiKey)"
    }
    
    static func authenticatedBaseUrl(page:Int?) -> NSURL {
        return NSURL(string: self.createURL(page: page ?? 1).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
    }
}
