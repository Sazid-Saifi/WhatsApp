//
//  Spinner.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 16/04/24.
//

import UIKit

open class Spinner {
    
    internal static var spinner: UIActivityIndicatorView?
    public static var style: UIActivityIndicatorView.Style = .white
    public static var baseBackColor = UIColor(white: 0, alpha: 0.6)
    public static var baseColor = UIColor.red
    public static func start() {
        Spinner.start(style: .whiteLarge)
    }
    
    public static func start(style: UIActivityIndicatorView.Style = style,
                             backColor: UIColor = UIColor.black.withAlphaComponent(0.4),
                             baseColor: UIColor = UIColor.white) {
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.style = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    public static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
}

