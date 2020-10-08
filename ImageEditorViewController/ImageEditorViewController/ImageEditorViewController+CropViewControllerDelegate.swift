//
//  ImageEditorViewController+CropViewControllerDelegate.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 04/04/20.
//  Copyright © 2020 Ali M Irshad. All rights reserved.
//

import UIKit

// MARK: - CropViewControllerDelegate
extension ImageEditorViewController: CropViewControllerDelegate {
    
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        
        UIApplication.topViewController()?.view.addWaitView()
        let currentImage = self.imageView.image
        DispatchQueue.global(qos: .userInteractive).async {
            if image.pngData() == currentImage?.pngData() {
                DispatchQueue.main.async { [weak self] in
                    UIApplication.topViewController()?.view.removeWaitView()
                    self?.removeCropView(controller: controller, image: nil)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    UIApplication.topViewController()?.view.removeWaitView()
                    self?.removeCropView(controller: controller, image: image)
                }
            }
        }
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        self.removeCropView(controller: controller, image: nil)
    }
}
