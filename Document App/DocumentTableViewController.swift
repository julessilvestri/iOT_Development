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
    
    return documentListBundle
}
class DocumentTableViewController: UITableViewController, QLPreviewControllerDataSource, UIDocumentPickerDelegate {
    var selectedDocumentURL: URL?
    var listDocuments: [DocumentFile] = []

    override func viewDidLoad() {
            super.viewDidLoad()
            let bundleDocuments = listFileInBundle()
            let appDocuments = listFilesInDocumentsDirectory()
            listDocuments = bundleDocuments + appDocuments

            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openDocumentPicker))
        }
    
    @objc func openDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        present(documentPicker, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDocuments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
         let document = listDocuments[indexPath.row]
         cell.textLabel?.text = document.title
         cell.detailTextLabel?.text = "Size: \(document.size.formatedSize())"
         return cell
     }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = indexPath.row
        navigationController?.pushViewController(previewController, animated: true)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedUrl = urls.first else { return }
            do {
                let resourcesValues = try selectedUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                let newDocument = DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: nil,
                    url: selectedUrl,
                    type: resourcesValues.contentType?.description ?? "Unknown"
                )
                listDocuments.append(newDocument)
                tableView.reloadData()
                copyFileToDocumentsDirectory(fromUrl: selectedUrl)
            } catch {
                print("Erreur lors de la récupération des informations du document: \(error)")
            }
        }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return listDocuments.count
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let document = listDocuments[index]
        return document.url as QLPreviewItem
    }
    func listFilesInDocumentsDirectory() -> [DocumentFile] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            let documentFiles = fileURLs.map { fileURL in
                let resourcesValues = try! fileURL.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                return DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: fileURL.lastPathComponent,
                    url: fileURL,
                    type: resourcesValues.contentType?.description ?? "Unknown"
                )
            }
            return documentFiles
        } catch {
            print("Error reading files from documents directory: \(error)")
            return []
        }
    }
    
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                try FileManager.default.copyItem(at: url, to: destinationUrl)
            } catch {
                print(error)
            }
        }
}

