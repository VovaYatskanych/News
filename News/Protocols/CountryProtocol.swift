//
//  CountryProtocol.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 07.11.2020.
//

import Foundation

protocol FilterDelegate: class {
    
    func setOne()
    func changeNavigationTitle(title: String)
    func fetchData(page: Int)
}
