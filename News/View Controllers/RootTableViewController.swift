//
//  TableViewController.swift
//  News_Pecode
//
//  Created by Volodymyr Yatskanych on 05.11.2020.
//

import UIKit
import SafariServices

final class RootTableViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    //MARK: - Properties
    
    private var searchTimer: Timer?
    
    private var articles: [Articles] = []
    private var currentPage = 1
    private var totalPage: Int?
    private var filteredArticles: [Articles] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        navigationItem.title = "Ukraine"
        fetchData(page: 1)
    }
    
    @IBAction func countryButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let countryVC = storyboard.instantiateViewController(withIdentifier: "CountrySB") as! CountryTableViewController
        
        self.present(countryVC, animated: true, completion: nil)
        
        countryVC.delegate = self
    }
    
    @IBAction func filterButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filterVC = storyboard.instantiateViewController(withIdentifier: "FilterSB") as! FilterTableViewController
        self.present(filterVC, animated: true, completion: nil)
        filterVC.delegate = self
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        articles = []
        fetchData(page: 1)

        sender.endRefreshing()
    }
    
    //MARK: - Functions
    
    func setup() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            print("Error")
        }
        
        definesPresentationContext = true
        searchController.delegate = self
    }
    
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredArticles.count
        }
        
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentPage < totalPage! && indexPath.row == articles.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Loading")
            
            return cell!
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
            
            if isFiltering{
                
                //Getting image from URL
                let imageURL: String = self.filteredArticles[indexPath.row].urlToImage ?? "https://www.newregion.kz/images/photorep/11062018/45f97e204457c61b9b1831607acac14a.jpg"
                if let url = URL(string: imageURL) {
                    if let data = try? Data(contentsOf: url) {
                        cell.setNewsImage(UIImage(data: data)!)
                    }
                }
                
                cell.setSource((self.filteredArticles[indexPath.row].source?.name)! + ": " + (self.filteredArticles[indexPath.row].author ?? "Невідомий автор"))
                cell.setDescription(self.filteredArticles[indexPath.row].description!)
                cell.setTitle(self.filteredArticles[indexPath.row].title!)
                
                return cell
            } else {
                //Getting image from URL
                let imageURL: String = self.articles[indexPath.row].urlToImage ?? "https://www.newregion.kz/images/photorep/11062018/45f97e204457c61b9b1831607acac14a.jpg"
                if let url = URL(string: imageURL) {
                    if let data = try? Data(contentsOf: url) {
                        cell.setNewsImage(UIImage(data: data)!)
                    }
                }
                
                cell.setTitle(self.articles[indexPath.row].title ?? "")
                cell.setDescription(self.articles[indexPath.row].description ?? "")
                cell.setSource((self.articles[indexPath.row].source?.name)! + ": " + (self.articles[indexPath.row].author ?? "Невідомий автор"))
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 551.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage < totalPage! && indexPath.row == articles.count - 1 {
            currentPage = currentPage + 1
            NetworkManager.shared.getNews(page: currentPage) { (model, error) in
                
                if let model = model {
                    self.articles.append(contentsOf: model.articles)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let stringUrl: String? = self.articles[indexPath.row].url
        if let url = URL(string: stringUrl!) {
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            safariViewController.delegate = self
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension RootTableViewController: FilterDelegate {
    
    func setOne() {
        self.currentPage = 1
    }
    
    func fetchData(page: Int) {
        NetworkManager.shared.getNews(page: 1) { (model, error) in
            
            if let model = model {
                self.articles = model.articles
                self.totalPage = model.totalResults! / 5
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func changeNavigationTitle(title: String) {
        self.navigationItem.title = title
    }
}

extension RootTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        searchTimer?.invalidate()
        let searchBar = searchController.searchBar
        NewsService.searchString = searchBar.text
        searchTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in
            NetworkManager.shared.getNews(page: 1) { (model, error) in
                if let model = model {
                    self.filteredArticles = model.articles
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        })
        self.currentPage = 1
    }
}
