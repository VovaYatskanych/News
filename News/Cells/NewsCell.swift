//
//  NewsCell.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 05.11.2020.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }

    func setNewsImage(_ image: UIImage) {
        self.newsImage.image = image
    }
    
    func setDescription(_ description: String) {
        self.descriptionLabel.text = description
    }
    
    func setSource(_ source: String) {
        sourceLabel.text = source
    }
}
