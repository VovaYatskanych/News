//
//  NetworkManager.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 05.11.2020.
//

import Foundation

class NetworkManager {

    private init() { }
    
    static let shared: NetworkManager = NetworkManager()
    
    func getNews(page: Int, result: @escaping (NewsResponse?) -> Void) {
        
        URLSession.shared.dataTask(with: NewsService.authenticatedBaseUrl(page: page) as URL) { (data, response, error) in
            if error == nil {
                if data != nil {
                    do {
                        let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data!)
                        print(newsResponse.articles.count)
                        result(newsResponse)
                    } catch let error {
                        print(error as Any)
                    }
                }
            }
        }.resume()
    }
}
