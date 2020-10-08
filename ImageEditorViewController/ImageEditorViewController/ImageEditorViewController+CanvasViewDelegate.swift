//
//  ImageEditorViewController+CanvasViewDelegate.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 09/05/20.
//  Copyright © 2020 Ali M Irshad. All rights reserved.
//

import UIKit

extension ImageEditorViewController: CanvasViewDelegate {
    func canvasViewWillDraw(_ canvasView: CanvasView, mode: CanvasMode) {
        
        //create and append EditingHistory
        var state = ImageEditorState.arrow
        if mode == .circle {
            state = .circle
        } else if mode == .line {
            state = .line
        }
        let history = EditingHistory(imageEditorState: state, image: nil)
        self.imageEditingHistory.append(history)
    }
}
