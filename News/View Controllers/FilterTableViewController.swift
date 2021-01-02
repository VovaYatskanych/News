//
//  SortedTableViewController.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 07.11.2020.
//

import UIKit

final class FilterTableViewController: UITableViewController {

    weak var delegate: FilterDelegate?
    
    private var filerItems: [FilerItems] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        filerItems.append(FilerItems.init(category: "Category",
                                          item: ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]))
        filerItems.append(FilerItems.init(category: "Source", item: ["BBC News", "Bloomberg", "CBC News", "CNN", "Google News"]))
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filerItems.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filerItems[section].item!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortedCell", for: indexPath)
        
        cell.textLabel?.text = filerItems[indexPath.section].item![indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filerItems[section].category
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            NewsService.category = filerItems[indexPath.section].item![indexPath.row]
            NewsService.source = ""
        } else if indexPath.section == 1 {
            NewsService.source = filerItems[indexPath.section].item![indexPath.row]
            NewsService.category = ""
        }
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.setOne()
        self.delegate?.fetchData(page: 1)
    }
}
