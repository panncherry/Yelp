//
//  FilterViewController.swift
//  Yelp
//
//  Created by Pann Cherry on 9/24/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    @objc optional func filterViewController(filterViewConfroller: FilterViewController, didUpdateFilters filters: [String:AnyObject])
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FilterViewControllerDelegate?
    
    var categories: [[String: String]]!
    var switchState = [Int: Bool] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = yelpCategories()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let filters = [String: AnyObject]()
        delegate?.filterViewController!(filterViewConfroller: self, didUpdateFilters: filters)
    }
    
    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func yelpCategories() -> [[String: String]]{
        return [["name": "Afghan", "code": "afgfhani"], ["name":"African","code":"african"],["name":"American, New", "code": "newamerican"],["name":"American, Tradional","code":"tradamerican"], ["name":"Andalusian", "code":"andalusian"],["name":"Arabian","code":"arabian"], ["name":"Argentine","code":"argentine"], ["name":"Armenian","code":"armenian"],["name":"Asian Fusion","code":"asianfusion"], ["name":"Asturian","code":"asturian"], ["name":"Australian","code":"australian"], ["name":"Austrian","code":"austrian"], ["name":"Baguettes","code":"baguettes"],
            ["name":"Bangladeshi","code":"bangladeshi"], ["name":"Barbeque","code":"bbq"],
            ["name":"Basque","code":"basque"], ["name":"Bavarian","code":"bavarian"],
            ["name":"Beer Garden","code":"beergarden"], ["name":"Beer Hall","code":"beerhall"],
            ["name":"Beisl","code":"beisl"], ["name":"Belgian","code":"belgian"],
            ["name":"Bistros","code":"bistros"], ["name":"Brasseries","code":"brasseries"],
            ["name":"Black Sea","code":"blacksea"], ["name":"Brazilian","code":"brazilian"],
            ["name":"Breakfast & Brunch","code":"breakfast_brunch"], ["name":"British","code":"british"],
            ["name":"Buffets","code":"buffets"], ["name":"Bulgarian","code":"bulgarian"],
            ["name":"Burgers","code":"burgers"], ["name":"Burmese","code":"burmese"],
            ["name":"Cafes","code":"cafes"], ["name":"Cafeteria","code":"cafeteria"],
            ["name":"Cajun/Creole","code":"cajun"], ["name":"Cambodian","code":"cambodian"],
            ["name":"Canadian, New","code":"newcanadian"], ["name":"Canteen","code":"canteen"],
            ["name":"Caribbean","code":"caribbean"], ["name":"Catalan","code":"catalan"],
            ["name":"Cheesesteaks","code":"cheesesteaks"], ["name":"Chicken Shop","code":"chickenshop"],
            ["name":"Chicken Wings","code":"chicken_wings"], ["name":"Chilean","code":"chilean"],
            ["name":"Chinese","code":"chinese"], ["name":"Comfort Food","code":"comfortfood"],
            ["name":"Corsican","code":"corsican"], ["name":"Creperies","code":"creperies"],
            ["name":"Cuban","code":"cuban"], ["name":"Curry Sausage","code":"currysausage"],
            ["name":"Cypriot","code":"cypriot"], ["name":"Czech","code":"czech"],
            ["name":"Czech/Slovakian","code":"czechslovakian"]]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.swtichLabel.text =  categories[indexPath.row]["name"]
        cell.delegate = self
        cell.onSwitch.isOn = switchState[indexPath.row] ?? false
        return cell
    }
   
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchState[indexPath.row] = value
    }

}
