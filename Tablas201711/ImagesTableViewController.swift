//
//  ImagesTableViewController.swift
//  Tablas201711
//
//  Created by Diogo Burnay on 01/11/18.
//  Copyright © 2018 Tec de Monterrey. All rights reserved.
//

import UIKit

class ImagesTableViewController: UITableViewController {

    var piso:String=""
    
    var datosFiltrados = [Any]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text! == "" {
            datosFiltrados = nuevoArray!
        } else {
            
            datosFiltrados = nuevoArray!.filter {
                let objetoPiso=$0 as! [String:Any];
                let s:String = objetoPiso["nombre"] as! String;
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        }
        
        self.tableView.reloadData()
    }
    
    var nuevoArray:[Any]?
    
    var arrayAux:[Any]?
    
    func JSONParseArray(_ string: String) -> [AnyObject]{
        if let data = string.data(using: String.Encoding.utf8){
            
            do{
                
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
                    return array
                }
            }catch{
                
                print("error")
                //handle errors here
                
            }
        }
        return [AnyObject]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let direccion = "http://martinmolina.com.mx/201813/data/SalonesPorPiso/TodosLosPisosJSON.json"
        
        var indexPiso = ""
        
        print(piso)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //nuevoArray=(JSONParseArray(datosJSON) as NSArray) as! [Any]
        
        if(piso == "Primer piso") {
            indexPiso="1"
        }
        if(piso == "Segundo piso") {
            indexPiso="2"
        }
        if(piso == "Tercer piso") {
            indexPiso="3"
        }
        if(piso == "Cuarto piso") {
            indexPiso="4"
        }
        
        let url = URL(string: direccion)
        let datos = try? Data(contentsOf: url!)
        
        nuevoArray = try! JSONSerialization.jsonObject(with: datos! ) as? [Any]
        
        nuevoArray = nuevoArray!.filter{
            let objetoPiso = $0 as![String:Any]
            let s:String = objetoPiso["piso"] as! String;
            return(s == "2")
        }
        
        //paso 5: copiar el contenido del arreglo en el arreglo filtrado
        datosFiltrados = nuevoArray!
        
        //Paso 6: usar la vista actual para presentar los resultados de la búsqueda
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        //paso 7: controlar el background de los datos al momento de hacer la búsqueda
        searchController.dimsBackgroundDuringPresentation = false
        //Paso 8: manejar la barra de navegación durante la busuqeda
        searchController.hidesNavigationBarDuringPresentation = false
        //Paso 9: Definir el contexto de la búsqueda
        definesPresentationContext = true
        //Paso 10: Instalar la barra de búsqueda en la cabecera de la tabla
        tableView.tableHeaderView = searchController.searchBar
        //El re-uso de las celdas se puede realizar de manera programática a través del registro de la celda
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EntradaMarca")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //paso 11 remplazar el uso de nuevoArray por datosFiltrados
        return (datosFiltrados.count)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntradaSalon", for: indexPath)
        
        let objetoPiso = datosFiltrados[indexPath.row] as! [String: Any]
        let s:String = objetoPiso["nombre"] as! String
        
        cell.textLabel?.text=s
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indice = 0
        var objetoPiso = [String:Any]()
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "Detalle") as! DetalleViewController
        if (self.searchController.isActive)
        {
            indice = indexPath.row
            objetoPiso = datosFiltrados[indice] as! [String: Any]
            
        }
        else
        {
            indice = indexPath.row
            objetoPiso = nuevoArray![indice] as! [String: Any]
        }
        
        let nombre:String = objetoPiso["nombre"] as! String
        let horario:String = objetoPiso["horario"] as! String
        siguienteVista.nombre = nombre
        siguienteVista.horario = horario
        
        self.navigationController?.pushViewController(siguienteVista, animated: true)
        
    }

}
