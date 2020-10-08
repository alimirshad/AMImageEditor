//
//  ShadowView.swift
//  AMImageEditor
//
//  Created by Ali M Irshad on 08/10/20.
//

import UIKit

///This class is used to give shadow to the container view of any given view
class ShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }
    
    private func setupShadow() {
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }
}

///This class is used to give shadow to the container view of any given view
class RedShadowView: UIView {
    override var frame: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    override func draw(_ rect: CGRect) {
        setupShadow()
    }
    
    private func setupShadow() {
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRedView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addRedView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addRedView()
    }
    
    func addRedView() {
        self.backgroundColor = .clear
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubViewWithConstraints(subview: view)
        view.layer.cornerRadius = 2.0
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.red.withAlphaComponent(0.8)
    }
}

