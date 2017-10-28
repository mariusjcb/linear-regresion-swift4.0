//
//  NSAttributedString.swift
//  LinearRegresion
//
//  Created by Marius Ilie on 23/10/2017.
//  Copyright © 2017 Marius Ilie. All rights reserved.
//

import UIKit

extension String {
    func height(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
