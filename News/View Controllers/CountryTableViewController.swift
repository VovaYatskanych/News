//
//  CountryTableViewController.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 07.11.2020.
//

import UIKit

class CountryTableViewController: UITableViewController {

    weak var delegate: FilterDelegate?
    var country: [String] = ["Ukraine", "USA", "Poland"]

    override func viewDidLayoutSubviews() {
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)

        cell.textLabel?.text = country[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NewsService.country = country[indexPath.row]
        NewsService.category = ""
        NewsService.source = ""
        
        self.delegate?.setOne()
        self.delegate?.fetchData(page: 1)
        self.delegate?.changeNavigationTitle(title: country[indexPath.row])
        
        self.dismiss(animated: true, completion: nil)
    }
}
