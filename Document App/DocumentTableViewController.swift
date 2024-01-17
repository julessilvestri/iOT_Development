//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Jules SILVESTRI on 1/16/24.
//

import UIKit

struct DocumentFile {
    var title: String
    var size: Int
    var imageName: String? = nil
    var url: URL
    var type: String
    
    static var testDocuments: [DocumentFile] {
        return listFileInBundle()
    }
}

extension Int {
    func formatedSize() -> String {
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: .file)
    }
}

func listFileInBundle() -> [DocumentFile] {
    
    // Instance du gestionnaire de fichiers par défaut
    let fm = FileManager.default
    
    // Chemin du répertoire de l'application
    let path = Bundle.main.resourcePath!
    
    // Liste des éléments dans le répertoire "path"
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    // Initialise un tableau vide qui stock les objets DocumentFile
    var documentListBundle = [DocumentFile]()
    
    // Parcours chaque élément dans la liste des éléments du répertoire
    for item in items {
        // Vérifie que l'élément n'est pas un fichier "DS_Store" et a l'extension ".jpg"
        if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
            
            // Crée une URL à partir du chemin du fichier
            let currentUrl = URL(fileURLWithPath: path + "/" + item)
            
            // Obtient les valeurs des propriétés spécifiées pour l'URL
            let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            
            // Ajoute un nouvel objet DocumentFile au tableau
            documentListBundle.append(DocumentFile(
                title: resourcesValues.name!,
                size: resourcesValues.fileSize ?? 0,
                imageName: item,
                url: currentUrl,
                type: resourcesValues.contentType!.description)
            )
        }
    }
    
    // Retourne le tableau d'objets DocumentFile
    return documentListBundle
}


class DocumentTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections (in this case, just one section)
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section, which is the count of test documents
        return DocumentFile.testDocuments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
                
        let document = DocumentFile.testDocuments[indexPath.row]
        
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "Size: \(document.size.formatedSize())"
        
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
