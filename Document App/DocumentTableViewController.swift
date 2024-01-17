//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Jules SILVESTRI on 1/16/24.
//

import UIKit
import QuickLook

struct DocumentFile {
    var title: String
    var size: Int
    var imageName: String? = nil
    var url: URL
    var type: String
    
    static var documents: [DocumentFile] {
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


class DocumentTableViewController: UITableViewController, QLPreviewControllerDataSource {
    var selectedDocumentURL: URL?

    override func viewDidLoad() {
            super.viewDidLoad()

            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
        }
    
    @objc func addDocument() {
        // Code à exécuter lorsque le bouton d'ajout est pressé
        // Par exemple, ouvrir une vue pour ajouter un nouveau document
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DocumentFile.documents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        let document = DocumentFile.documents[indexPath.row]

        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "Size: \(document.size.formatedSize())"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let file = DocumentFile.documents[indexPath.row]
        selectedDocumentURL = file.url
        showQLPreviewController()*/
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = indexPath.row
        navigationController?.pushViewController(previewController, animated: true)
    }

    /*func showQLPreviewController() {
        guard selectedDocumentURL != nil else {
            return
        }

        let previewController = QLPreviewController()
        previewController.dataSource = self
        navigationController?.pushViewController(previewController, animated: true)
    }*/


    // QLPreviewControllerDataSource methods
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return DocumentFile.documents.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let document = DocumentFile.documents[index]
        return document.url as QLPreviewItem
    }
}

