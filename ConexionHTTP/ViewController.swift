//
//  ViewController.swift
//  ConexionHTTP
//
//  Created by Gerardo Villarroel on 8/4/16.
//  Copyright © 2016 Gerardo Villarroel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var textoISBN: UITextField!
    @IBOutlet weak var scroll: UIScrollView!
    var textoSalidaWebService: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textoISBN.delegate = self
        self.logo.image = UIImage(named: "logo_OL-lg")
        textoISBN.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        textoISBN.becomeFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sigVista = segue.destinationViewController as! VistaResultados
        sigVista.textoISBNvr = sincrono(textoISBN.text!)
        
        //Cambiar nombre del botón BACK de un segue
        let backItem = UIBarButtonItem()
        backItem.title = "Atrás"
        navigationItem.backBarButtonItem = backItem
    }
    
    //Mueve el scroll del campo de texto
    @IBAction func textFieldDidBeginEditing(textField: UITextField) {
        var punto: CGPoint
        punto = CGPointMake(0, textField.frame.origin.y - 50)
        self.scroll.setContentOffset(punto, animated: true)
    }
    
    @IBAction func textFieldDidEndEditing(textField: UITextField) {
        self.scroll.setContentOffset(CGPointZero, animated: true)
    }

    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder() //desaparecer el teclado
    }
    
    //ISBN de prueba: 0671041177
    //ISBN sin datos: 5
    //ISBN sin portada: 4
    func sincrono(textoISBN: String)-> [String] {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(textoISBN)"
        let url = NSURL(string: urls)
        var resultado = [String]()
        //0 = titulo
        //1 = portada
        //2 = autor1
        //3 = autor2
        //4.. autores!
        do {
            let datos = try NSData(contentsOfURL: url!, options: NSDataReadingOptions())
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                
                //Busqueda del Libro
                var dico2: NSDictionary? = nil
                dico2 = dico1["ISBN:\(textoISBN)"] as? NSDictionary
                if dico2 != nil {
                    resultado.append(dico2!["title"] as! NSString as String)
                    
                    //Portada del Libro
                    var dico3: NSDictionary? = nil
                    dico3 = dico2!["cover"] as? NSDictionary
                    if dico3 != nil {
                        resultado.append(dico3!["medium"] as! NSString as String)
                    } else {
                        resultado.append("Sin Portada")
                    }
                    
                    //Autores del Libro
                    if let autores = dico2!["authors"] as? [[String: AnyObject]] {
                        for autor in autores {
                            if let name = autor["name"] as? String {
                                resultado.append(name)
                            }
                        }
                    }
                    
                } else {
                    resultado.append("No Encontrado")
                }
            } catch {
                
            }
        }catch {
            let alertController = UIAlertController(title: "Error", message:
                "Por favor revisa tu conexión a Internet.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        return resultado
    }
}

