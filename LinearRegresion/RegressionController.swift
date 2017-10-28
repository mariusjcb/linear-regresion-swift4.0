//
//  ViewController.swift
//  LinearRegresion
//
//  Created by Marius Ilie on 22/10/2017.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

class RegressionController: UIViewController, RegressionViewDelegate {
    private var regression: Regression?
    private var regressionView: RegressionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegression()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupRegression() {
        regression = Regression()
        if regression != nil {
            let screen = UIScreen.main.bounds
            let frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
            
            regressionView = RegressionView(regression: regression!, frame: frame)
            regressionView.delegate = self
        }
        
        self.view.addSubview(regressionView)
    }
    
    func needsDraw(touchPoint point: CGPoint) -> Bool {
        do {
            try regression!.add(point: point)
            return true
        } catch {
            return false
        }
    }
}

