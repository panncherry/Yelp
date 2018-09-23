//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Contributed by Pann Cherry 9/23/2018.
//  Copyright (c) 2015 Timothy Lee and Pann Cherry. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    var businesses: [Business]!
    
    var filteredBusiness: [Business] = []
    
    var loadingMoreViews: InfiniteScrollActivityView?
    
    var isMoreDataLoading = false
    
    var isEnd = false
    
    var offset = 50
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize table
        tableView.delegate = self
        tableView.dataSource = self
        //initialize searchBar
        searchBar.delegate = self
        //change the size of the table height dynamically
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreViews = InfiniteScrollActivityView(frame: frame)
        loadingMoreViews!.isHidden = true
        tableView.addSubview(loadingMoreViews!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        getBusinesses()
  
        
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
    
    func getBusinesses(){
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredBusiness = self.businesses
            self.tableView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                    print(businesses.count)

                }
            }
        }
        )

    }
    
    //code to fetch photos when pull to refresh
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        getBusinesses()
    }
    
    //code to load more data
    func loadMoreData() {
        offset += 50
        self.isMoreDataLoading = false
        // Stop the loading indicator
        self.loadingMoreViews!.stopAnimating()
        getBusinesses()
        self.tableView.reloadData()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*/ code to update filteredMovie based on the text in the Search Box
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     businesses = searchText.isEmpty ? filteredBusiness : filteredBusiness.filter { ($0[Business["name"]] as! String).lowercased().contains(searchBar.text!.lowercased()) }
     tableView.reloadData()
     }*/
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        businesses = searchText.isEmpty ? filteredBusiness : filteredBusiness.filter({ businesses -> Bool in
            let dataString = businesses.name
            return dataString!.lowercased().range(of: searchText.lowercased()) != nil
        })
        tableView.reloadData()
    }
    
    //code to display more posts when scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreViews?.frame = frame
                // Code to load more results
                loadMoreData()

            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    /*func loadMoreData() {
        self.offset += businesses.count
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            if let businesses = businesses, businesses.count != 0 {
                if self.offset == 0 {
                    self.businesses = businesses
                }
                else {
                    self.businesses += businesses
                }
            }
            else {
                self.isEnd = true
            }
            self.tableView.reloadData()
            if self.tableView.alpha == 0 {
                self.tableView.alpha = 1
            }
            self.isMoreDataLoading = false
        })
    }*/
    
}
