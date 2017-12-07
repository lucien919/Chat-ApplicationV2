//
//  ChatContentView.swift
//  CGChatFrameworl
//
//  Created by Mac on 11/27/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

public enum MessageSender:Int{
    case user = 0
    case other = 1
}

//@IBDesignable
class ChatContentView: UIView {

    @IBInspectable var type:Int = 0{
        didSet{
            guard type > 1 else{return}
            type = 1
        }
    }
    @IBInspectable var HeightOfTriangle:CGFloat = 20.0{
        didSet{
            guard HeightOfTriangle > 10 else{
                HeightOfTriangle = 10
                return
            }
        }
    }
    @IBInspectable var WidthOfTriangle:CGFloat = 40.0{
        didSet{
            guard WidthOfTriangle > 20 else{
                WidthOfTriangle = 20
                return
            }
        }
    }
    @IBInspectable var StrokeWidth:CGFloat = 3.0
    @IBInspectable var BorderRadius:CGFloat = 10.0
    
    @IBInspectable var StrokeColor:UIColor = .blue
    @IBInspectable var FillColor:UIColor = .green
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0.0, y: self.bounds.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        let currentFrame = self.bounds
        
        context?.setLineJoin(.round)
        context?.setLineWidth(StrokeWidth)
        context?.setStrokeColor(StrokeColor.cgColor)
        context?.setFillColor(FillColor.cgColor)
        
        context?.beginPath()
        
        if(type==1){
            
            //Triangle
            context?.move(to:CGPoint(
                x: StrokeWidth + 0.5,
                y: StrokeWidth + 0.5))
        
            context?.addLine(to: CGPoint(
                x: WidthOfTriangle/2 + 0.5,
                y: HeightOfTriangle + StrokeWidth + 0.5))
        
            //Bubble
            //arc 1
            context?.addArc(
                tangent1End: CGPoint(
                    x: currentFrame.size.width - StrokeWidth - 0.5,
                    y: StrokeWidth + HeightOfTriangle + 0.5),
                tangent2End: CGPoint(
                    x: currentFrame.size.width - StrokeWidth - 0.5,
                    y: currentFrame.size.height - StrokeWidth - 0.5),
                radius: BorderRadius - StrokeWidth)
            //arc 2
            context?.addArc(
                tangent1End: CGPoint(
                    x: currentFrame.size.width - StrokeWidth - 0.5,
                    y: currentFrame.size.height - StrokeWidth - 0.5),
                tangent2End: CGPoint(
                    x: currentFrame.size.width/2 + WidthOfTriangle/2 - StrokeWidth - 0.5,
                    y: currentFrame.size.height - StrokeWidth - 0.5),
                radius: BorderRadius - StrokeWidth)
            //arc 3
            context?.addArc(
                tangent1End: CGPoint(
                    x: StrokeWidth + 0.5,
                    y: currentFrame.size.height - StrokeWidth - 0.5),
                tangent2End: CGPoint(
                    x: StrokeWidth + 0.5,
                    y: HeightOfTriangle + StrokeWidth + 0.5),
                radius: BorderRadius - StrokeWidth)
        
        }else{
            //Triangle
            
            context?.move(to:CGPoint(
                x: currentFrame.size.width - WidthOfTriangle/2 - StrokeWidth - 0.5,
                y: HeightOfTriangle + StrokeWidth + 0.5))
            
            context?.addLine(to: CGPoint(
                x: currentFrame.size.width - StrokeWidth - 0.5,
                y: StrokeWidth + 0.5))
            
            //Bubble
            
            //arc 1
            context?.addArc(
                tangent1End: CGPoint(
                    x: currentFrame.size.width - StrokeWidth - 0.5,
                    y: currentFrame.size.height - StrokeWidth - 0.5),
                tangent2End: CGPoint(
                    x: round(currentFrame.size.width/2 + WidthOfTriangle/2) - StrokeWidth - 0.5,
                    y: currentFrame.size.height - StrokeWidth - 0.5),
                radius: BorderRadius - StrokeWidth)
            //arc 2
            context?.addArc(
                tangent1End: CGPoint(
                    x: StrokeWidth + 0.5,
                    y: currentFrame.size.height - StrokeWidth - 0.5),
                tangent2End: CGPoint(
                    x: StrokeWidth + 0.5,
                    y: HeightOfTriangle + StrokeWidth + 0.5),
                radius: BorderRadius - StrokeWidth)
            //arc 3
            context?.addArc(
                tangent1End: CGPoint(
                    x: StrokeWidth + 0.5,
                    y: HeightOfTriangle + StrokeWidth + 0.5),
                tangent2End: CGPoint(
                    x: currentFrame.size.width/2,
                    y: HeightOfTriangle + StrokeWidth + 0.5),
                radius: BorderRadius - StrokeWidth)
            
        }
        
        //Close and Draw
        context?.closePath()
        context?.drawPath(using: .fillStroke)
    }

}

















