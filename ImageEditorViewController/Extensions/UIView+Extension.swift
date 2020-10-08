//
//  UIView+Extension.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//
import UIKit

extension UIView {
    func setBorderColorAndCornerWith(radius: CGFloat? = 0.0, color: UIColor? = .clear, width: CGFloat? = 0.0, masksToBounds: Bool = false) {
        self.layer.borderColor = color!.cgColor
        self.layer.borderWidth = width!
        self.layer.cornerRadius = radius!
        self.layer.masksToBounds = masksToBounds
    }
    func removeSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    var waitViewTag: Int {
        return 500
    }
    
    func addWaitView(backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.2), indicatorColor: UIColor = UIColor.red) {
        
        if viewWithTag(waitViewTag) != nil {
            return
        }
        removeWaitView()
        
        let containerView = UIView(frame: frame)
        containerView.backgroundColor = backgroundColor
        containerView.tag = waitViewTag
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubViewWithConstraints(subview: containerView)

        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.color = indicatorColor
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        activityIndicator.startAnimating()
        
        bringSubviewToFront(containerView)
        
    }
    
    func removeWaitView() {
        viewWithTag(waitViewTag)?.removeFromSuperview()
    }
    
    func addSubViewWithConstraints(subview: UIView, padding: CGFloat = 0.0) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subview)
        
        subview.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        
    }
    
    func asImage(captureRect: CGRect? = nil) -> UIImage {
        if let captureRect = captureRect {
            let renderer = UIGraphicsImageRenderer(bounds: captureRect)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        }
    }
}
