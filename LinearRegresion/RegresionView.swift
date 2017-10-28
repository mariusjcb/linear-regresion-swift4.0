//
//  RegresionView.swift
//  LinearRegresion
//
//  Created by Marius Ilie on 22/10/2017.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

protocol RegressionViewDelegate {
    func needsDraw(touchPoint point: CGPoint) -> Bool
}

class RegressionView: UIView {
    var delegate: RegressionViewDelegate?
    private(set) var regression: Regression!
    
    private var lineEquationLabel: UITextView!
    private var gridView: UIImageView!
    private var regressionLine = CAShapeLayer()
    
    convenience init(regression: Regression, frame: CGRect) {
        self.init(frame: frame)
        self.regression = regression
        
        self.backgroundColor = UIColor.white
        
        setupGridView()
        setupEquationLabel()
        
        drawRegressionLine()
        drawRegressionDots()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupEquationLabel() {
        lineEquationLabel = UITextView()
        lineEquationLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
        lineEquationLabel.backgroundColor = UIColor.black.withAlphaComponent(1)
        lineEquationLabel.textColor = UIColor.white
        lineEquationLabel.textAlignment = .left
        lineEquationLabel.textContainerInset = UIEdgeInsets(top: 27, left: 16, bottom: 0, right: 16)
        lineEquationLabel.font = UIFont(name: "Helvetica Bold", size: 30)!
        
        self.addSubview(lineEquationLabel)
    }
    
    private func reloadEquationText() {
        let text = String(format: "f(x) = %.1f x + %.1f", regression.b, regression.a)
        lineEquationLabel.text = text
    }
    
    private func setupGridView() {
        gridView = UIImageView(image: #imageLiteral(resourceName: "grid.svg"))
        gridView.frame = self.frame
        gridView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gridView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegressionView.didTap(touch:)))
        tap.numberOfTapsRequired = 1
        
        gridView.isUserInteractionEnabled = true
        gridView.addGestureRecognizer(tap)
        
        self.addSubview(gridView)
    }
    
    @objc private func didTap(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: gridView)
        
        if delegate?.needsDraw(touchPoint: touchPoint) == true {
            draw(point: touchPoint)
            drawRegressionLine()
        }
    }
    
    private func drawRegressionLine() {
        let endy = regression.a + regression.b * self.frame.width
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: regression.a))
        path.addLine(to: CGPoint(x: self.frame.width, y: endy))
        
        regressionLine.path = path.cgPath
        regressionLine.strokeColor = UIColor.blue.cgColor
        regressionLine.lineWidth = 3
        regressionLine.lineJoin = kCALineJoinRound
        
        gridView.layer.addSublayer(regressionLine)
        reloadEquationText()
    }
    
    private func drawRegressionDots() {
        for point in regression.points {
            draw(point: point)
        }
    }
    
    private func draw(point: CGPoint) {
        let dot = CAShapeLayer()
        let dotPath = UIBezierPath()
        
        dotPath.addArc(withCenter: point, radius: 6, startAngle: 0, endAngle: 360, clockwise: true)
        
        dot.path = dotPath.cgPath
        dot.fillColor = UIColor.red.cgColor
        
        gridView.layer.addSublayer(dot)
        
        drawCoordinatesText(point: point)
    }
    
    private func drawCoordinatesText(point: CGPoint) {
        let text = String(format: "(%.1f, %.1f)", point.x, point.y)
        let drawPoint = CGPoint(x: point.x + 46, y: point.y - 13)
        draw(text: text, at: drawPoint)
    }
    
    private func draw(text: String, at point: CGPoint) {
        let font = UIFont(name: "Helvetica Bold", size: 11)!
        
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.font = font
        textLayer.fontSize = 11
        textLayer.foregroundColor = UIColor.darkGray.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.bounds = CGRect(x: 0, y: 0, width: text.width(font: font), height: 40)
        textLayer.position = point
        
        textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        textLayer.transform = CATransform3DMakeScale(1, -1, 1)
        
        gridView.layer.addSublayer(textLayer)
    }
}
