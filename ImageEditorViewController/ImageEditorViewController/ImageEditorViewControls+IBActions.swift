//
//  ImageEditorViewControls+IBAction.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 04/04/20.
//  Copyright © 2020 Ali M Irshad. All rights reserved.
//

import UIKit

// MARK: IBAction
extension ImageEditorViewController {
    /// Left bar button action
    @objc func actionBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    /// Right bar button action
    @objc func actionRightBarButton() {
        
        if imageEditorState == .crop {
            if let childVC = children.first as? CropViewController {
                removeCropView(controller: childVC, image: nil)
            }
        } else if imageEditorState != .none {
            onGestureDoneButtonClick(btnDoneCrop)
        }
        if delegate == nil {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.view.addWaitView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if let imageRect = self.imageView.getImageRect() {
                self.delegate?.imageEditorViewControllerDidFinishEditing(with: self.imageView.superview?.asImage(captureRect: imageRect), controller: self)
            } else {
                self.delegate?.imageEditorViewControllerDidFinishEditing(with: self.imageView.superview?.asImage(), controller: self)
            }
        }
        
    }
    /// crop button action
    @IBAction func onCropButtonClick(_ sender: Any) {
        addCropView()
    }
    @IBAction func onCircleButtonClick(_ sender: UIButton) {
        setToolMode(mode: .circle, canvasMode: .circle)
        addShape()
    }
    @IBAction func onArrowButtonClick(_ sender: UIButton) {
        setToolMode(mode: .arrow, canvasMode: .arrow)
        addShape()
    }
    @IBAction func onLineButtonClick(_ sender: UIButton) {
        setToolMode(mode: .line, canvasMode: .line)
        addShape()
    }
    @IBAction func onGestureDoneButtonClick(_ sender: UIButton) {
        canvasView.commitShape()
        setToolMode(mode: .none, canvasMode: .none)
    }
    @IBAction func onGestureCancelButtonClick(_ sender: UIButton) {
        //undo the last change which will of type .circle, .arrow or .line
        _ = self.imageEditingHistory.popLast()
        self.canvasView.undo()
        setToolMode(mode: .none, canvasMode: .none)
    }
    @IBAction func onUndoButtonClick(_ sender: Any) {
        //grab the last history from array
        //add undo it
        if let history = self.imageEditingHistory.popLast() {
            if let image = history.image {
                self.imageView.image = image
                updateCanvasFrame()
            } else {
                self.canvasView.undo()
            }
        }
    }
}
