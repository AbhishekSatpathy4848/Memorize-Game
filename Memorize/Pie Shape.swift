//
//  Pie Shape.swift
//  Memorize
//
//  Created by Abhishek Satpathy on 20/04/23.
//

import SwiftUI

struct Pie:Shape{
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width,rect.height)/2
        let topCoordinate = CGPoint(x: center.x, y:center.y - radius)
    
        
        var path = Path()
        path.move(to: center)
        path.addLine(to: topCoordinate)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: !clockwise)
        return path;
    }


}
