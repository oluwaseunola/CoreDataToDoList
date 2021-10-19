//
//  Extensions.swift
//  CoreDataToDoApp
//
//  Created by Seun Olalekan on 2021-10-19.
//

import Foundation
import UIKit

extension UIView {
    
    public var width : CGFloat {
        return frame.width
    }
    
    public var height : CGFloat {
        return frame.height
    }
    
    public var top : CGFloat {
        return frame.origin.y
    }
    
    public var bottom : CGFloat {
        return frame.origin.y + height
    }
    
    public var left : CGFloat {
        return frame.origin.x
    }
    
    public var right : CGFloat {
        return frame.origin.x + width
    }
    
}
