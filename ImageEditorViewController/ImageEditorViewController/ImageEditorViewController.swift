//
//  ImageEditorViewController.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 02/04/20.
//  Copyright © 2020 Ali M Irshad. All rights reserved.
//

import UIKit

// MARK: ImageEditorState
enum ImageEditorState {
    case comment
    case crop
    case circle
    case arrow
    case line
    case none
}

/// Enum to represent canvas view draw mode
// MARK: CanvasMode
enum CanvasMode {
    case circle
    case line
    case arrow
    case none
}

// MARK: ImageEditorViewControllerProtocol
protocol ImageEditorViewControllerProtocol: class {
    func imageEditorViewControllerDidFinishEditing(with image: UIImage?, controller: ImageEditorViewController)
}
struct EditingHistory {
    var imageEditorState: ImageEditorState!
    var image: UIImage?
}
class ImageEditorViewController: UIViewController {

    // MARK: Variables
    let lineWidth: CGFloat = 3.0
    //let eraserWidth: CGFloat = 10
    var image: UIImage! //image to be edited
    var imageEditorState: ImageEditorState = .none
    var lastPoint: CGPoint!
    var swiped = false
    var drawColor: UIColor = UIColor.red
    weak var delegate: ImageEditorViewControllerProtocol?
    //array to store all changes related to image edits
    var imageEditingHistory = [EditingHistory]() {
        didSet {
            btnUndo.isHidden = !(imageEditingHistory.count > 0)
        }
    }
    
    /**
     Array of Colors that will show while drawing or typing
     */
    var colors = [UIColor.red,
                  UIColor.darkGray,
                  UIColor.blue,
                  UIColor.green,
                  UIColor.black]
    
    // MARK: IBOutlets
    @IBOutlet weak var canvasView: CanvasView!
    // to hold the image
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnCrop: UIButton!
    @IBOutlet weak var btnCircle: UIButton!
    @IBOutlet weak var btnArrow: UIButton!
    @IBOutlet weak var btnLine: UIButton!
    @IBOutlet weak var btnUndo: UIButton!
    
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var toolsStackView: UIStackView!
    @IBOutlet weak var gestureCommitStackView: UIStackView!
    
    @IBOutlet weak var cropToolbarView: UIView!
    @IBOutlet weak var btnCancelCrop: UIButton!
    @IBOutlet weak var btnDoneCrop: UIButton!
    
    // canvas view heigh width layout constraints
    @IBOutlet weak var canvasViewHeight: NSLayoutConstraint!
    @IBOutlet weak var canvasViewWidth: NSLayoutConstraint!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //call the method to setup initial UI of the view controller
        self.setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //set the canvas view frame to the image frame inside the image view
        updateCanvasFrame()
    }
    
    static func presentImageEditor(with image: UIImage, delegate: ImageEditorViewControllerProtocol?) {
        if let imageEditorViewController = UIStoryboard(name: "ImageEditorSB", bundle: nil).instantiateViewController(withIdentifier: "ImageEditorViewController") as? ImageEditorViewController {
            imageEditorViewController.image = image
            imageEditorViewController.delegate = delegate
            imageEditorViewController.title = "Edit Image"
            let navigationController = UINavigationController(rootViewController: imageEditorViewController)
            navigationController.modalPresentationStyle = .overCurrentContext
            
            //add left bar button
            let leftBarBtn = UIButton()
            leftBarBtn.setTitle("Cancel", for: .normal)
            leftBarBtn.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
            leftBarBtn.setTitleColor(UIColor.black, for: .normal)
            leftBarBtn.addTarget(imageEditorViewController, action: #selector(imageEditorViewController.actionBackButton), for: .touchUpInside)
            imageEditorViewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
            
            UIApplication.topViewControllerForPersentation()?.present(navigationController, animated: true, completion: {
                
                //add right bar button
                let rightBarBtn = UIButton()
                rightBarBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
                rightBarBtn.setTitle("Done", for: .normal)
                rightBarBtn.contentHorizontalAlignment = .right
                rightBarBtn.setTitleColor(UIColor.black, for: .normal)
                rightBarBtn.addTarget(imageEditorViewController, action: #selector(imageEditorViewController.actionRightBarButton), for: .touchUpInside)
                
                imageEditorViewController.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
            })
        }
    }
}
