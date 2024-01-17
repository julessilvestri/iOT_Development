//
//  DocumentViewController.swift
//  Document App
//
//  Created by Jules SILVESTRI on 1/17/24.
//

import UIKit

class DocumentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Dans DocumentTableViewController
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // 1. Récuperer l'index de la ligne sélectionnée
            // 2. Récuperer le document correspondant à l'index
            // 3. Cibler l'instance de DocumentViewController via le segue.destination
            // 4. Caster le segue.destination en DocumentViewController
            // 5. Remplir la variable imageName de l'instance de DocumentViewController avec le nom de l'image du document
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
