//
//  UIDrawingView.swift
//  24HWDrawingViewSwift
//
//  Created by Сергей on 12.11.2019.
//  Copyright © 2019 Sergei. All rights reserved.
//

//1. Нарисуйте пятиконечную звезду :)
//2. Добавьте окружности на концах звезды
//3. Соедините окружности линиями


import UIKit

enum TouchButton {
    
    case star
    case circle
    case rectangule
    case triangle
    case freeDrawing
    case drawingEnded
    case cleanUp
    
}

//MARK: - Delegate
protocol UIDrawingFigureDelegate {
    
    var touch: TouchButton?          { get set }
    var sizeRect: CGRect?            { get set }
    var initialSize: CGFloat?        { get set }
    
    var sizeRectForStar: CGRect?     { get set }
    var sizeRectForCircle: CGRect?   { get set }
    var sizeRectForSquare: CGRect?   { get set }
    var sizeRectForTriangle: CGRect? { get set }
    var sizeWidthLine: CGFloat?       { get set }
    
    var drawPointBegan: CGPoint?     { get set }
    var drawPointEnd: CGPoint?       { get set }
    
    var colorOfFigure: UIColor?      { get set }
    
}


@IBDesignable

class UIDrawingFigure: UIView {

    var delegate: UIDrawingFigureDelegate?
    var pathBezier = UIBezierPath()
    var pointsOfDrawing = [Any]()
    var startPointOfLine: CGPoint?
    
    override func draw(_ rect: CGRect) {

        switch self.delegate?.touch {
            
        case .star:
            self.pathBezier = self.drawStar(in: self.delegate?.sizeRectForStar ?? rect, numberOfVertices: 5, percentOfRadius: 0.45, color: self.delegate?.colorOfFigure)
            self.pathBezier.fill()
        case .circle:
            self.pathBezier = self.drawCircle(in: self.delegate?.sizeRectForCircle ?? rect, color: self.delegate?.colorOfFigure)
            self.pathBezier.fill()
        case .rectangule:
            self.pathBezier = self.drawSquare(in: self.delegate?.sizeRectForSquare ?? rect, color: self.delegate?.colorOfFigure, width: self.delegate?.sizeRectForSquare?.width ?? 0.0)
            self.pathBezier.fill()
        case .triangle:
            self.pathBezier = self.drawRightTriangle(in: self.delegate?.sizeRectForTriangle ?? rect, indent: 0, color: self.delegate?.colorOfFigure)
            self.pathBezier.fill()
        case .freeDrawing:
            self.drawLines(on: self.delegate?.drawPointEnd, beganPoint: self.delegate?.drawPointBegan, color: self.delegate?.colorOfFigure, widthLine: self.delegate?.sizeWidthLine)
        case .cleanUp:
            self.pathBezier.removeAllPoints()
            
        default:
            break
        
        }
    }
    
    //MARK: - Star
    private func drawStar(in rect: CGRect, numberOfVertices: Int, percentOfRadius: CGFloat, color: UIColor?) -> UIBezierPath {
        let path = UIBezierPath()
        
        var firstPoint = true
        
        let center = CGPoint(x: rect.origin.x + rect.width / 2.0, y: rect.origin.y + rect.height / 2.0)
        let radius = rect.width / 2
        let midRadius = percentOfRadius * radius
        
        var angle = CGFloat(CGFloat.pi / 2.0)
        let angleIncrement = CGFloat(Double.pi * 2.0 / Double(numberOfVertices))
        
        for _ in 1...numberOfVertices {
            
            let point = self.pointFrom(offset: center, radius: midRadius, angle: angle)
            let nextPoint = self.pointFrom(offset: center, radius: midRadius, angle: angle + angleIncrement)
            let midPoint = self.pointFrom(offset: center, radius: radius, angle: angle + angleIncrement / 2)
            
            if  firstPoint {
                
                firstPoint = false
                path.move(to: point)
                
            }
            
            path.addLine(to: midPoint)
            path.addLine(to: nextPoint)
            angle += angleIncrement
            
        }
        
        color?.setFill()
        path.close()
        
        return path
    }
    
    private func pointFrom(offset: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        
        let x = radius * cos(angle) + offset.x
        let y = radius * sin(angle) + offset.y
        
        return CGPoint(x: x, y: y)
    }
    
    //MARK: draw circle
    private func drawCircle(in rect: CGRect, color: UIColor?) -> UIBezierPath {
        
        let rectPath = CGRect(x: rect.origin.x, y: rect.origin.y,
                              width: rect.width, height: rect.height)
        let path = UIBezierPath(ovalIn: rectPath)
        color?.setFill()
        
        return path
    }
    
    //MARK: draw square
    private func drawSquare(in rect: CGRect, color: UIColor?, width: CGFloat) -> UIBezierPath {
    
        let pathRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: width, height: width)
        let path = UIBezierPath(rect: pathRect)
        
        color?.setFill()
        
        return path
    }
    
    //MARK: draw right triangle
    private func drawRightTriangle(in rect: CGRect, indent: CGFloat, color: UIColor?) -> UIBezierPath {
        
        let pathTriangle = UIBezierPath()
    
        let point1 = CGPoint(x: rect.origin.x + indent, y: rect.origin.y + indent)
        let point2 = CGPoint(x: rect.origin.x + indent, y: rect.maxY)
        let point3 = CGPoint(x: rect.maxX, y: rect.maxY)
        
        pathTriangle.move(to: point1)
        pathTriangle.addLine(to: point2)
        pathTriangle.addLine(to: point3)
        pathTriangle.addLine(to: point1)
        
        color?.setFill()
        
        return pathTriangle
    }
    
    //MARK: Draw line
    private func drawLines(on pointEnd: CGPoint?, beganPoint: CGPoint?, color: UIColor?, widthLine: CGFloat?) {
        
        if beganPoint != nil {

            self.startPointOfLine = beganPoint
            self.pathBezier.move(to: self.startPointOfLine!)
        }

        if pointEnd != nil {
            self.pathBezier.addLine(to: pointEnd!)
        }
        self.pathBezier.lineWidth = widthLine ?? 1
        self.pathBezier.lineCapStyle = .round
        color?.setStroke()
        self.pathBezier.stroke()
        //return path
    }
}
