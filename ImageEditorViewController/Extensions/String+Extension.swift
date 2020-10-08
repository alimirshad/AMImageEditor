//
//  String+Extension.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//

import UIKit

/// A extension of String class with multiiple enhance methods.
extension String {

    /**
     A method to get storyboard identifier of class
     
     - parameter  aClass: A object of any class
     - returns: Return the storyboard identifier of class
     */
    public static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }

}
