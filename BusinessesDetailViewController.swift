//
//  BusinessesDetailViewController.swift
//  Yelp
//
//  Created by Pann Cherry on 9/23/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

final class RestrauntsAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, name: String?, address: String?){
        self.coordinate = coordinate
        self.name = name
        self.address = address
        
        super.init()
        
    }
    
}


class BusinessesDetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImgaeView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    var business: Business!
    var offset = 0
    var term:String = "All"
    var category: String = "All"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBusinesses(forTerm: term, at: offset, categories: category)
    }
    
    func getBusinesses(forTerm term: String, at offset: Int, categories category: String){
        Business.searchWithTerm(term: term, offset: offset, category: [category], completion: { (businesses: [Business]?, error: Error?) -> Void in
            if let businesses = businesses, businesses.count != 0 {
                self.nameLabel.text = self.business.name
                self.reviewsCountLabel.text = "\(self.business.reviewCount!)Reviews"
                self.categoriesLabel.text = self.business.categories
                self.addressLabel.text = self.business.address
                self.ratingImageView.image = self.business.ratingImage
                self.thumbImgaeView.setImageWith(self.business.imageURL!)
            }
    })
    
}
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
         */

}
