//
//  ViewController.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: "sample")
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBAction func onEditImageClick(_ sender: Any) {
        ImageEditorViewController.presentImageEditor(with: imageView.image!, delegate: self)
    }
}

extension ViewController: ImageEditorViewControllerProtocol {
    func imageEditorViewControllerDidFinishEditing(with image: UIImage?, controller: ImageEditorViewController) {
        imageView.image = image
        controller.dismiss(animated: true, completion: nil)
    }
}

