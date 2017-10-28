//
//  Regression.swift
//  LinearRegresion
//
//  Created by Marius Ilie on 22/10/2017.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

enum RegressionError: Error {
    case hasNoPoints
}

class Regression {
    private(set) var points: [CGPoint]
    
    private(set) var a: CGFloat!
    private(set) var b: CGFloat!
    private(set) var confidence: CGFloat!
    
    var hasEquation: Bool {
        return points.count > 0
    }
    
    init() {
        self.points = [CGPoint]()
        
        self.a = CGFloat.nan
        self.b = CGFloat.nan
        self.confidence = CGFloat.nan
    }
    
    init(points: [CGPoint]) throws {
        self.points = points
        try calculateRegression()
    }
    
    func add(point: CGPoint) throws {
        points.append(point)
        try calculateRegression()
    }
    
    private func calculateRegression() throws {
        guard points.count > 0 else {
            throw RegressionError.hasNoPoints
        }
        
        let n = CGFloat(points.count)
        
        let medx = points.reduce(0, { (s, p) in s + p.x }) / n
        let medy = points.reduce(0, { (s, p) in s + p.y }) / n
        
        let sxx = points.reduce(0, { (s, p) in s + pow(p.x, 2) }) / n - pow(medx, 2)
        let syy = points.reduce(0, { (s, p) in s + pow(p.y, 2) }) / n - pow(medy, 2)
        let sxy = points.reduce(0, { (s, p) in s + p.x * p.y }) / n - medx * medy
        
        let b = sxy / sxx
        let a = medy - b * medx
        
        var r = sxy / (sxx.squareRoot() * syy.squareRoot())
        if r < 0 { r = -r }
        
        self.a = a
        self.b = b
        self.confidence = r
    }
}
