//
//  PisosViewController.swift
//  ProyectoF
//
//  Created by cdt307 on 10/23/18.
//  Copyright © 2018 Fafnir. All rights reserved.
//

import UIKit

extension PisosViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class PisosViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    //This is the floors internet address
    let floorAddress:String = "http://martinmolina.com.mx/201813/data/pisos.json"
    var floorArray : [Any]?
    var filteredFloor = [Any]()
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredFloor = floorArray!.filter({(floor:Any) -> Bool in return ((floor as! [String:Any])["piso"] as! String).lowercased().contains(searchText.lowercased())})
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar pisos"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        let url = URL(string:floorAddress)
        let floorJSONData = try? Data(contentsOf: url!)
        floorArray = try! JSONSerialization.jsonObject(with: floorJSONData!) as? [Any]
        let tdisb = searchController.searchBar.value(forKey: "searchField") as? UITextField
        tdisb?.textColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue:  255.0/255.0, alpha: 1.0)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(isFiltering()){
            return filteredFloor.count
        }else{
            return (floorArray?.count)!
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fidentifier", for: indexPath) as UITableViewCell
        
        if(isFiltering()){
            let objectFloor = filteredFloor[indexPath.row] as! [String:Any]
            let s:String = objectFloor["piso"] as! String
            cell.textLabel?.text = s
            return cell
        }else{
            let objectFloor = floorArray?[indexPath.row] as! [String:Any]
            let s:String = objectFloor["piso"] as! String
            cell.textLabel?.text = s
            return cell
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! LabosViewController
        if(isFiltering()){
            let selectedFloor = filteredFloor[(tableView.indexPathForSelectedRow?.row)!] as! [String : Any]
            vc.floor = selectedFloor["piso"]!
            vc.navigationItem.title = selectedFloor["piso"] as? String
        }else{
            let selectedFloor = floorArray?[(tableView.indexPathForSelectedRow?.row)!] as! [String : Any]
            vc.floor = selectedFloor["piso"]!
            vc.navigationItem.title = selectedFloor["piso"] as? String
        }
        
    }
}

