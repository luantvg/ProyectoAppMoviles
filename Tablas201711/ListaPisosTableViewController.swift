//
//  ListaMarcasTableViewController.swift
//  Tablas201711
//
//  Created by molina on 20/02/17.
//  Copyright © 2017 Tec de Monterrey. All rights reserved.
//

import UIKit
// paso 1: agregar el prtotocolo UISearchResultsUpdating
class ListaPisosTableViewController: UITableViewController, UISearchResultsUpdating {
    //paso 2: crear una variable para almacenar lo datos que son filtrados
    var datosFiltrados = [Any]()
    //paso 3: crear un control de búsqueda
    let searchController = UISearchController(searchResultsController: nil)
    
    //paso 4: crear la función updateSearchResults para cumplir con el protocolo
    //UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
        // si la caja de búsuqeda es vacía, entonces mostrar todos los resultados
        if searchController.searchBar.text! == "" {
            datosFiltrados = nuevoArray!
        } else {
            // Filtrar los resultados de acuerdo al texto escrito en la caja que es obtenido a través del parámetro $0
            datosFiltrados = nuevoArray!.filter {
                let objetoMarca=$0 as! [String:Any];
                let s:String = objetoMarca["marca"] as! String;
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased())) }
        }
        
        self.tableView.reloadData()
    }
    
    let direccion="http://martinmolina.com.mx/201813/data/datos.json"
    /*
    private let datos = [
        "Ford", "BMW", "Audi", "VW", "Chrysler", "Nissan", "Peugeot", "Renault", "Seat", "Citroen"
    ]
    let datosJSON = "[ {\"marca\": \"FORD\", \"agencias\": 21}, {\"marca\": \"BMW\", \"agencias\": 35} ]"
    */
    var nuevoArray:[Any]?
    
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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //nuevoArray=(JSONParseArray(datosJSON) as NSArray) as! [Any]
        
        let url = URL(string: direccion)
        let datos = try? Data(contentsOf: url!)
        nuevoArray = try! JSONSerialization.jsonObject(with: datos!) as? [Any]
        
        //paso 5: copiar el contenido del arreglo en el arreglo filtrado
        datosFiltrados = nuevoArray!
        
        //Paso 6: usar la vista actual para presentar los resultados de la búsqueda
        searchController.searchResultsUpdater = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntradaMarca", for: indexPath)

        //paso 12 remplazar el uso de nuevoArray por datosFitrados
        //Usar el objeto marca para la obtencion de los datos
        let objetoMarca = datosFiltrados[indexPath.row] as! [String: Any]
        let s:String = objetoMarca["marca"] as! String
        
        cell.textLabel?.text=s
        
        return cell
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

    

    // Paso 13 comentar todo el método de prepare for segue
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indice = 0
        var objetoMarca = [String:Any]()
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let siguienteVista = segue.destination as! DetalleViewController
        if (self.searchDisplayController?.isActive)!
        {
            indice = (self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow?.row)!
            objetoMarca = datosFiltrados[indice] as! [String: Any]
            
        }
        else
        {
            indice = (self.tableView.indexPathForSelectedRow?.row)!
            objetoMarca = nuevoArray![indice] as! [String: Any]
        }
     
        let s:String = objetoMarca["marca"] as! String
        
        siguienteVista.marca = s
    }
    */
    
    //Paso 13: eliminar el segue de entre la tabla y el detalle
    //Paso 14: crear la funcion disSelectRow
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indice = 0
        var objetoMarca = [String:Any]()
        //Paso 15: crear un identificador para el controlador de vista a nivel detalle
        let siguienteVista = self.storyboard?.instantiateViewController(withIdentifier: "Detalle") as! DetalleViewController
        //Verificar si la vista actual es la de búsqueda
        if (self.searchController.isActive)
        {
            indice = indexPath.row
            objetoMarca = datosFiltrados[indice] as! [String: Any]
            
        }
        //sino utilizar la vista sin filtro
        else
        {
            indice = indexPath.row
            objetoMarca = nuevoArray![indice] as! [String: Any]
        }
        let s:String = objetoMarca["marca"] as! String
        
        siguienteVista.marca = s
        self.navigationController?.pushViewController(siguienteVista, animated: true)
        
    }

}
