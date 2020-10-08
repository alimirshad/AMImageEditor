//
//  UIImageView+Extension.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//
import UIKit

extension UIImageView {
    
    /// Returns the image Rect(optional) from the image view
    /// the Image content mode should be Aspect Fit
    func getImageRect() -> CGRect? {
        if let imageSize = self.image?.size {
            let imageScale = fminf(Float(self.bounds.width / (imageSize.width)), Float(self.bounds.height / (imageSize.height)))
            let scaledImageSize = CGSize(width: (imageSize.width) * CGFloat(imageScale), height: (imageSize.height ) * CGFloat(imageScale))
            let imageFrame = CGRect(x: CGFloat(roundf(Float(0.5 * (self.bounds.width - scaledImageSize.width)))), y: CGFloat(roundf(Float(0.5 * (self.bounds.height - scaledImageSize.height)))), width: CGFloat(roundf(Float(scaledImageSize.width))), height: CGFloat(roundf(Float(scaledImageSize.height))))
            return imageFrame
        }
        return nil
    }
}
