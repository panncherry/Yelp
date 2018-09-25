//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Contributed by Pann Cherry 9/23/2018.
//  Copyright (c) 2015 Timothy Lee and Pann Cherry. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking

var allBusiness: [Business] = []

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, FilterViewControllerDelegate{
    
    var businesses: [Business]!
    var filteredBusiness: [Business] = []
    var loadingMoreViews: InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var offset = 0
    var term: String = "Restraunts"
    var category: String = "All"
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(BusinessesViewController.didPullToRefresh(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreViews = InfiniteScrollActivityView(frame: frame)
        loadingMoreViews!.isHidden = true
        tableView.addSubview(loadingMoreViews!)
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        getBusinesses(forTerm: term, at: offset, categories: category)

        /* Example of Yelp search with more search options specified
         Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"]) { (businesses, error) in
         self.businesses = businesses
         for business in self.businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
    }
    
    func getBusinesses(forTerm term: String, at offset: Int, categories category: String){
        Business.searchWithTerm(term: term, offset: offset, category: [category], completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses, businesses.count != 0 {
                if offset == 0 {
                    self.businesses = businesses
                }
                else {
                    self.businesses += businesses
                }
                self.filteredBusiness = businesses
            }
            self.tableView.reloadData()
            self.isMoreDataLoading = false
        })
        self.refreshControl.endRefreshing()
    }
    
    //code to fetch photos when pull to refresh
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        getBusinesses(forTerm: term, at: offset, categories: category)
    }
    
    //code to load more data
    func loadMoreData() {
        isMoreDataLoading = true
        self.loadingMoreViews!.stopAnimating()
        offset += businesses.count
        getBusinesses(forTerm: term, at: offset, categories: category)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        businesses = searchText.isEmpty ? filteredBusiness : filteredBusiness.filter({ businesses -> Bool in
            let dataString = businesses.name
            return dataString?.lowercased().range(of: searchText.lowercased()) != nil
         })
        tableView.reloadData()
    }

    
    //code to display more posts when scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreViews?.frame = frame
                loadMoreData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let business = businesses[indexPath.row]
            let businessesDetailsViewController = segue.destination as! BusinessesDetailViewController
            businessesDetailsViewController.business = business
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FilterViewController
        filtersViewController.delegate = self
        
    }
    
    func filterViewController(filterViewConfroller: FilterViewController, didUpdateFilters filters: [String : AnyObject]) {
        var categories = filters["categories"] as? [String]
        Business.searchWithTerm(term: "Restraunts", categories: categories){(businesses:[Business]!, error: NSError) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
}*/
}
