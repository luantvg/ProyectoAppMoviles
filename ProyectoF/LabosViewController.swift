//
//  LabosViewController.swift
//  ProyectoF
//
//  Created by cdt307 on 10/23/18.
//  Copyright © 2018 Fafnir. All rights reserved.
//

import UIKit

extension LabosViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class LabosViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var floor : Any?
    let address : String = "http://martinmolina.com.mx/201813/data/A01338209_JSON/A01338209_NombreSalones.json"
    var filteredArrayLab:[Any] = []
    var superfilteredLab = [Any]()
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        superfilteredLab = filteredArrayLab.filter({(lab:Any) -> Bool in return ((lab as! [String:Any])["nombre"] as! String).lowercased().contains(searchText.lowercased())})
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
        
        //This should allow us to get information from the URL
        let url = URL(string:address)
        let labJSONData = try? Data(contentsOf: url!)
        let labArray = try! JSONSerialization.jsonObject(with: labJSONData!) as? [Any]
        // To remove it, just call removeFromSuperview()
        
        var actf:String?
        
        switch(floor as! String){
        case "Primer piso":
            actf = "1"
            break;
        case "Segundo piso":
            actf = "2"
            break;
        case "Tercer piso":
            actf = "3"
            break;
        case "Cuarto piso":
            actf = "4"
            break;
        default:
            actf = "0"
            break;
        }
        print(actf!)
        for i in labArray! {
            let objectLab = i as! [String:Any]
            if((objectLab["piso"]! as! String) == actf!){
                filteredArrayLab.append(i)
            }
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar Laboratorios"
        let tdisb = searchController.searchBar.value(forKey: "searchField") as? UITextField
        tdisb?.textColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue:  255.0/255.0, alpha: 1.0)
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltering()){
            return superfilteredLab.count
        }else{
            return filteredArrayLab.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pisidentifier", for: indexPath) as! LabTableViewCell
        //This is gonna be harde
        if(isFiltering()){
            let objectLab = superfilteredLab[indexPath.row] as! [String:Any]
            cell.textLabel?.text = (objectLab["nombre"] as! String)
            
            //For the image
            return cell
        }else{
            let objectLab = filteredArrayLab[indexPath.row] as! [String:Any]
            cell.textLabel?.text = (objectLab["nombre"] as! String)
            
            //For the image
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(isFiltering()){
            let vc = segue.destination as! DetalleViewController
            let selectedLab = superfilteredLab[(tableView.indexPathForSelectedRow?.row)!] as! [String : Any]
            vc.lab = selectedLab
            vc.navigationItem.title = selectedLab["nombre"] as? String
        }else{
            let vc = segue.destination as! DetalleViewController
            let selectedLab = filteredArrayLab[(tableView.indexPathForSelectedRow?.row)!] as! [String : Any]
            vc.lab = selectedLab
            vc.navigationItem.title = selectedLab["nombre"] as? String
        }
    }
    
    
}
