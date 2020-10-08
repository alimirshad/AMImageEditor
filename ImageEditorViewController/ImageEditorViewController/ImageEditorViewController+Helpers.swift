//
//  ImageEditorViewController+Helpers.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 04/04/20.
//  Copyright © 2020 Ali M Irshad. All rights reserved.
//

import UIKit

// MARK: Helpers
extension ImageEditorViewController {
    
    /// Initial set up for view controller
    func setUpUI() {
        //initally hide the history button
        btnUndo.isHidden = true
        
        //set canvas view delegate
        self.canvasView.delegate = self
        
        // set image for editing
        self.imageView.image = image
        
        // call the method to show hide toolbaar options
        // based on current image editor state
        self.updateToolbar()
        
        //set the mode to none on set up
        self.setToolMode(mode: .none, canvasMode: .none)
        
        //add corner radius to buttons
        toolsStackView.arrangedSubviews.filter({$0 is UIButton}).forEach { (btn) in
            btn.setBorderColorAndCornerWith(radius: 4.0, masksToBounds: true)
        }
        gestureCommitStackView.arrangedSubviews.filter({$0 is UIButton}).forEach { (btn) in
            btn.setBorderColorAndCornerWith(radius: 4.0, masksToBounds: true)
        }
        cropToolbarView.subviews.filter({$0 is UIButton}).forEach { (btn) in
            btn.setBorderColorAndCornerWith(radius: 4.0, masksToBounds: true)
        }
    }
    
    /// This method is used to hide the toolbar button option for editing
    func updateToolbar() {
        switch imageEditorState {
        case .circle, .arrow, .line:
            self.cropToolbarView.isHidden = true
            self.toolsStackView.isHidden = true
            self.controlsStackView.isHidden = false
            self.gestureCommitStackView.isHidden = false
        case .crop:
            self.controlsStackView.isHidden = true
            self.cropToolbarView.isHidden = false
        default:
            self.toolsStackView.isHidden = false
            self.controlsStackView.isHidden = false
            self.gestureCommitStackView.isHidden = true
            self.cropToolbarView.isHidden = true
        }
    }
    
    /// This method will update the toolbar UI
    /// - Parameters:
    ///   - mode: Image Editor state to be set to represent the current UI
    ///   - canvasMode: CanvasMode to line, circle or arrow
    func setToolMode(mode: ImageEditorState, canvasMode: CanvasMode) {
        imageEditorState = mode
        canvasView.updateCanvasMode(canvasMode)
        canvasView.isUserInteractionEnabled = true
        canvasView.lineColor = drawColor
        canvasView.lineWidth = lineWidth
        // call the method to show hide toolbaar options
        // based on current image editor state
        updateToolbar()
    }
    
    /// This method will add the crop view controller as a subview when user will tap on crop image button
    func addCropView() {
        //set the current image editor state to 'crop'
        imageEditorState = .crop
        
        // create CropViewController instance
        let controller = CropViewController()
        controller.delegate = self
        controller.image = imageView.image
        //add as child view controller, for view life cycle events to happen
        self.addChild(controller)
        
        // remove the previous targets
        self.btnCancelCrop.removeTarget(nil, action: nil, for: .allEvents)
        self.btnDoneCrop.removeTarget(nil, action: nil, for: .allEvents)
        // add targets to the button
        self.btnCancelCrop.addTarget(controller, action: #selector(controller.cancel(_:)), for: .touchUpInside)
        self.btnDoneCrop.addTarget(controller, action: #selector(controller.done(_:)), for: .touchUpInside)
        //add view controllers view to subview
        self.imageView.superview?.addSubViewWithConstraints(subview: controller.view)
        controller.didMove(toParent: self)
        
        // call the method to show hide toolbaar options
        // based on current image editor state
        updateToolbar()
    }
    /// Removed the 'CropViewController' for this view controller, will be called when user press 'Done' or 'Cancel' for 'CropViewController'
    /// - Parameters:
    ///   - controller: The 'CropViewController' instance
    ///   - image: Image(optional)
    func removeCropView(controller: CropViewController, image: UIImage?) {
        
        self.imageEditorState = .none
        
        if let image = image {
            //store the current image for undo operation
            if let image = self.imageView.image {
                //create and append EditingHistory
                let history = EditingHistory(imageEditorState: .crop, image: image)
                self.imageEditingHistory.append(history)
            }
            self.imageView.image = image
        }
        //remove the crop view controller from the child view
        controller.removeFromParent()
        controller.view.removeFromSuperview()
        
        //update the toolbar back to normal with tools options
        updateToolbar()
        //set the canvas view frame to the image frame inside the image view
        updateCanvasFrame()
        
    }
    
    /// set the canvas view frame to the image frame inside the image view
    func updateCanvasFrame() {
        if let imageRect = self.imageView.getImageRect() {
            let convertedRect = self.imageView.convert(imageRect, to: self.imageView.superview)
            self.canvasViewWidth.constant = convertedRect.width
            self.canvasViewHeight.constant = convertedRect.height
            self.canvasView.center = self.imageView.center
            self.imageView.superview?.layoutIfNeeded()
        }
    }
    /// Adds a shape to the canvas view
    func addShape() {
        let center = imageView.convert(imageView.center, to: canvasView)
        canvasView.addShape(center: center)
    }
}
