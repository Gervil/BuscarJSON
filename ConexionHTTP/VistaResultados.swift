//
//  VistaResultados.swift
//  ConexionHTTP
//
//  Created by Gerardo Villarroel on 9/4/16.
//  Copyright © 2016 Gerardo Villarroel. All rights reserved.
//

import UIKit

class VistaResultados: UIViewController {

    @IBOutlet weak var portadaLibro: UIImageView!
    @IBOutlet weak var textoResultado: UILabel!
    var textoISBNvr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (textoISBNvr.count > 2) {
            if (textoISBNvr[1] != "Sin Portada") {
                loadImageFromUrl(textoISBNvr[1], view: portadaLibro)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Recuperación de los datos para mostrarlos en el segue.
        if (textoISBNvr[0] == "No Encontrado") {
            textoResultado.text = "El ISBN ingresado no corresponde a ningun Libro!"
        }
        else {
            textoResultado.text = "Tìtulo: " + textoISBNvr[0] + "\n"
            if (textoISBNvr.count - 2) == 1 {
                textoResultado.text =  textoResultado.text! + "Autor: " + textoISBNvr[2]
            } else {
                textoResultado.text =  textoResultado.text! + "Autores: " + textoISBNvr[2]
                for i in 4...textoISBNvr.count {
                    textoResultado.text =  textoResultado.text! + " " + textoISBNvr[i-1]
                }
            }
        }
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        let url = NSURL(string: url)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        task.resume()
    }
}
