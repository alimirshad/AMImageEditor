//
//  ShapeView.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//

import UIKit

class ShapeView: UIView {
    // default color and border width for circle
    var borderColor: UIColor = .black
    var borderWidth: CGFloat = 2.0
    var shapeType: CanvasMode = .circle
    
    // draw method to draw line or arrow
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //drawing on views are heavy task
        //only call this if the canvas mode is .line or .arrow
        if shapeType == .line || shapeType == .arrow {
            if let context = UIGraphicsGetCurrentContext() {
                //call the method to perform the drawing operations
                performCustomDrawing(context)
            }
        }
    }
    /// Draws lines and arrows using CGContext
    /// - Parameter context: CGContext object
    fileprivate func performCustomDrawing(_ context: CGContext) {
        context.setBlendMode( CGBlendMode.normal)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(borderWidth)
        context.setStrokeColor(borderColor.cgColor)
        let point1 = CGPoint(x: 5, y: frame.size.height / 2)
        let point2 = CGPoint(x: frame.size.width - 5, y: frame.size.height / 2)
        if shapeType == .line {
            context.move(to: point1)
            context.addLine(to: point2)
            context.strokePath()
        } else if shapeType == .arrow {
            createArrowPath(context: context, start: point1, end: point2, pointerLineLength: 20.0, arrowAngle: CGFloat(Double.pi / 4))
        }
    }
    
    override init(frame: CGRect) {
        //call the parent intializer
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        //enable multipe touch
        isMultipleTouchEnabled = true
        //add gesture recognizers
        addGestureRecognisers()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Update the UI for circle when this method called
    override func layoutSubviews() {
        if shapeType == .circle {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        }
        self.backgroundColor = .clear
        
        if layer.sublayers?.first(where: {$0.name == "borderLayer" }) == nil {
            let borderLayer  = dashedBorderLayerWithColor(color: UIColor.white.cgColor)
            layer.addSublayer(borderLayer)
        }
        setNeedsDisplay()
    }
    
    /// Remove all gestures from the view
    func removeGestures() {
        if let gestures = gestureRecognizers {
            gestures.forEach { [weak self](gesture) in
                self?.removeGestureRecognizer(gesture)
            }
        }
        if let layer = layer.sublayers?.first(where: {$0.name == "borderLayer" }) as? CAShapeLayer {
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = UIColor.clear.cgColor
        }
    }
    
    func createArrowPath(context: CGContext, start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        
        context.move(to: start)
        context.addLine(to: end)
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        
        context.addLine(to: arrowLine1)
        context.move(to: end)
        context.addLine(to: arrowLine2)
        context.strokePath()
    }
    
    @objc func onDrag(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            // note: 'view' is optional and need to be unwrapped
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self)
        }
    }
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        if let view = pinch.view {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
    }
    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        if let view = gestureRecognizer.view {
            view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        }
    }
}

// MARK: - CropView delegate methods
extension ShapeView: UIGestureRecognizerDelegate {
    // MARK: - Gesture Recognizer delegate methods
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ShapeView {
    /// Add gesture recognizer to the view
    func addGestureRecognisers() {
        //add pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag(gesture:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        //add rotation gesture recognizer
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        rotationGestureRecognizer.delegate = self
        addGestureRecognizer(rotationGestureRecognizer)
        
        //add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchRecognized(pinch:)))
        pinchGesture.delegate = self
        addGestureRecognizer(pinchGesture)
    }
    func dashedBorderLayerWithColor(color: CGColor) -> CAShapeLayer {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth = 3.0
        borderLayer.lineJoin = .round
        borderLayer.lineDashPattern = NSArray(array: [NSNumber(value: 8), NSNumber(value: 4)]) as? [NSNumber]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.cgPath
        
        return borderLayer
        
    }
}

