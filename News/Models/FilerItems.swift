//
//  FilerItems.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 07.11.2020.
//

import Foundation

class FilerItems {
    
    let category: String?
    let item: [String]?
    
    init(category: String, item: [String]) {
        self.category = category
        self.item = item
    }
}
