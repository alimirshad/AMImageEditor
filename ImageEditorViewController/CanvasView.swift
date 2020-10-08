//
//  CanvasView.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//

import UIKit

/// Structure to store the drawing data on view, drawing points, color and line width
struct Line {
    var points: [CGPoint]
    var color: UIColor
    var width: CGFloat
}
/// This protocolo contains method that will be triggred on delegate on a draw circle
protocol CanvasViewDelegate: class {
    func canvasViewWillDraw(_ canvasView: CanvasView, mode: CanvasMode)
}

/// Class responsible for gesture base drawing for lines, circle and arrow
class CanvasView: UIView {
    //default mode
    private var canvasMode: CanvasMode = .none
    //default color and line width
    var lineColor: UIColor = .black
    var lineWidth: CGFloat = 2.0
    
    //child view for circle
    var shapeView: ShapeView?
    
    //CanvasViewDelegate
    weak var delegate: CanvasViewDelegate?
    
    func addShape(center: CGPoint) {
        //we don't expect to have .none as canvasMode
        if canvasMode == .none {
            fatalError()
        }
        
        //create a new shape view
        shapeView = ShapeView(frame: .zero)
        guard  let shapeView = shapeView else {
            return
        }
        //set the shape type for shape view
        shapeView.shapeType = canvasMode
        //set the line width and line color of the shapeview
        shapeView.borderWidth = lineWidth
        shapeView.borderColor = lineColor
        
        var width = frame.size.width
        var height = frame.size.height
        let minValue = min(width, height)
        
        if minValue < 200 {
            width = minValue
            height = canvasMode == .circle ? minValue : minValue / 2
        } else {
            if canvasMode == .circle {
                width = 200
                height = 200
            } else {
                width = 300
                height = 100
            }
        }
        shapeView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(shapeView)
        layoutSubviews()
        shapeView.center = center
        //update the delegate for new shape
        self.delegate?.canvasViewWillDraw(self, mode: canvasMode)
            
    }
    
    /// This method will undo the drawing base on the canvas mode, if no mode is passed it will use current canvas mode
    func undo() {
        if let view = self.subviews.last(where: {$0 is ShapeView}) {
            view.removeFromSuperview()
        }
        shapeView = nil
    }
    /// This method will clear all shapes from the canvas view
    func clear() {
        self.removeSubviews()
        //this will trigger the draw circle again
        setNeedsDisplay()
    }
    
    /// Updates the canvas mode and commit's the shape
    func updateCanvasMode(_ mode: CanvasMode) {
        canvasMode = mode
        commitShape()
    }
    
    /// Remove the crop rect view from the shapeView's subviews
    func commitShape() {
        shapeView?.removeGestures()
        shapeView = nil
    }
}

