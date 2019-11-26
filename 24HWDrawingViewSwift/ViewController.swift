//
//  ViewController.swift
//  24HWDrawingViewSwift
//
//  Created by Сергей on 12.11.2019.
//  Copyright © 2019 Sergei. All rights reserved.
//

import UIKit

//Вот такой вот базовый урок получился. Эта тема - поле непаханое. Вы можете, если захотите, поискать кучу гайдов и примеров по этому материалу. Можно делать классные вещи. Но я не хочу на этом на долго останавливаться, нам нужно идти дальше :)
//
//Ученик.
//
//1. Нарисуйте пятиконечную звезду :)
//2. Добавьте окружности на концах звезды
//3. Соедините окружности линиями
//
//Студент.
//
//4. Закрасте звезду любым цветом цветом оО
//5. При каждой перерисовке рисуйте пять таких звезд (только мелких) в рандомных точках экрана
//
//Мастер
//
//6. После того как вы попрактиковались со звездами нарисуйте что-то свое, проявите творчество :)
//
//Супермен
//
//7. Сделайте простую рисовалку - веду пальцем по экрану и рисую :)

class ViewController: UIViewController, UIDrawingFigureDelegate {

    //MARK: UIDrawingFigureDelegate
    
    internal var drawPointBegan: CGPoint?
    internal var drawPointEnd: CGPoint?
    internal var initialSize: CGFloat? = 1
    internal var sizeRect: CGRect?
    internal var sizeRectForStar: CGRect?
    internal var sizeRectForCircle: CGRect?
    internal var sizeRectForSquare: CGRect?
    internal var sizeRectForTriangle: CGRect?
    internal var touch: TouchButton?
    internal var colorOfFigure: UIColor?
    internal var sizeWidthLine: CGFloat?
    
    //MARK: IBOutlet
    
    @IBOutlet weak var buttonStar: UIButton!
    @IBOutlet weak var buttonCircle: UIButton!
    @IBOutlet weak var buttonRectangle: UIButton!
    @IBOutlet weak var buttonTriangle: UIButton!
    @IBOutlet weak var drawFigure: UIDrawingFigure!
    @IBOutlet var buttonsFigures: [UIButton]!
    @IBOutlet var sliders: [UISlider]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var buttonCleanup: UIButton!
    
    private var isFreeDrawing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.drawFigure.delegate = self
        
        for i in 0..<self.buttonsFigures.count {
            
            self.buttonsFigures[i].layer.cornerRadius = 20.0
            self.sliders[i].minimumValue = Float(self.initialSize ?? 0.0)
            self.sliders[i].maximumValue = Float(self.drawFigure.bounds.width - 40)
            
            if self.sliders[i].tag == 4 {
                
                self.sliders[i].maximumValue = 200
                
            }
        }
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {

        self.drawFigure.setNeedsDisplay()
        
    }
    
    //MARK: button action figure
    
    @IBAction func buttonFigureAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.sizeRectForStar = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY,
                                          width: CGFloat(self.sliders[0].value), height: CGFloat(self.sliders[0].value))
            self.touch = .star
            self.labels[0].text = String(Int(self.sliders[0].value))
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 1:
            self.sizeRectForCircle = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY,
                                          width: CGFloat(self.sliders[1].value), height: CGFloat(self.sliders[1].value))
            self.touch = .circle
            self.labels[1].text = String(Int(self.sliders[1].value))
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 2:
            self.sizeRectForSquare = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY,
                                            width: CGFloat(self.sliders[2].value), height: CGFloat(self.sliders[2].value))
            self.touch = .rectangule
            self.labels[2].text = String(Int(self.sliders[2].value))
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 3:
            self.touch = .triangle
            self.labels[3].text = String(Int(self.sliders[3].value))
            self.sizeRectForTriangle = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY,
                                                width: CGFloat(self.sliders[3].value), height: CGFloat(self.sliders[3].value))
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 4:
            self.touch = .freeDrawing
            self.isFreeDrawing = true
            self.drawFigure.setNeedsDisplay()
        default:
            break
        }
    }
    
    //MARK: action for all sliders
    @IBAction func slidersActions(_ sender: UISlider) {
    
        let textForLabel = String(Int(sender.value))
        
        switch sender.tag {
        case 0:
            self.touch = .star
            self.sizeRectForStar = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY, width: CGFloat(sender.value),height: CGFloat(sender.value))
            self.labels[0].text = textForLabel
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 1:
            self.touch = .circle
            self.sizeRectForCircle = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY,
                                            width: CGFloat(sender.value), height: CGFloat(sender.value))
            self.labels[1].text = textForLabel
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 2:
            self.touch = .rectangule
            self.sizeRectForSquare = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY,
                                            width: CGFloat(sender.value), height: CGFloat(sender.value))
            self.labels[2].text = textForLabel
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 3:
            self.touch = .triangle
            self.sizeRectForTriangle = CGRect(x: self.drawFigure.frame.minX, y: self.drawFigure.frame.minY,
                                              width: CGFloat(sender.value), height: CGFloat(sender.value))
            self.labels[3].text = textForLabel
            self.isFreeDrawing = false
            self.drawFigure.setNeedsDisplay()
        case 4:
            self.touch = .freeDrawing
            self.sizeWidthLine = CGFloat(sender.value)
            self.isFreeDrawing = true
            self.drawFigure.setNeedsDisplay()
        default:
            break
        }
    }
    
    //MARK: switch action
    @IBAction func swithAction(_ sender: UISwitch) {
        
        for subView in self.view.subviews {
            
            if sender.isOn && !subView.isKind(of: UISwitch.self) &&
               !subView.isKind(of: UIDrawingFigure.self) &&
                subView.tag != 5 {
                
                subView.isHidden = true

            } else if !sender.isOn {
                
                subView.isHidden = false
                
            }
        }
        
        if sender.isOn {
            
            UIView.animate(withDuration: 0.3) {
                
                self.drawFigure.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY,
                                                width: self.view.bounds.width, height: self.view.bounds.height - 100)
                self.isFreeDrawing = true
                self.drawFigure.setNeedsDisplay()
            }
            
        } else {
            
            UIView.animate(withDuration: 0.3) {
                
                self.drawFigure.frame = CGRect(x: 20, y: 20, width: 977, height: 962)
                self.touch = .cleanUp
                self.drawFigure.setNeedsDisplay()
            }
        }
    }
    
    //MARK: button cleanup action
    
    @IBAction func cleanupAction(_ sender: UIButton) {

        self.touch = .cleanUp
        self.drawFigure.setNeedsDisplay()
        
    }
    
    //MARK: Button action setting color
    
    @IBAction func buttonActionSettingColor(_ sender: UIButton) {
        
        if sender.tag == 7 {
         
            let alert = UIAlertController(title: "Setting color", message: "Please set color background", preferredStyle: .alert)
            alert.addTextField { (textField) in
                  
                textField.placeholder = "Entry name color"
                
            }
        
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(action) in
                
                let textField = alert.textFields![0] as UITextField
                let text = textField.text
                let colorFromText = self.defineColorBy(text: text, oldColor: self.drawFigure.backgroundColor ?? UIColor.white)
                self.drawFigure.backgroundColor = colorFromText
                self.drawFigure.setNeedsDisplay()
             
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Setting color", message: "Please set color line", preferredStyle: .alert)
                alert.addTextField { (textField) in
                      
                    textField.placeholder = "Entry name color"
                    
                }
            
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(action) in
                    
                    let textField = alert.textFields![0] as UITextField
                    let text = textField.text
                    let colorFromText = self.defineColorBy(text: text, oldColor: self.drawFigure.backgroundColor ?? UIColor.white)
                    self.colorOfFigure = colorFromText
                    self.drawFigure.setNeedsDisplay()

                }))
                
                self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    

    //MARK: UITouches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 
        let touchBegan = touches.first ?? UITouch()
    
        let pointBegan = touchBegan.location(in: self.view)
        
        let viewUnderPoint = self.view.hitTest(pointBegan, with: nil)
        
        if viewUnderPoint?.isEqual(self.drawFigure ?? UIView()) ?? false && self.isFreeDrawing {
            
            self.drawPointBegan = pointBegan
            self.touch = .freeDrawing
            self.drawFigure.setNeedsDisplay()
            
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        self.drawPointBegan = nil
        let touch = touches.first ?? UITouch()
        
        let pointMoving = touch.location(in: self.view)
        
        let viewUnderPoint = self.view.hitTest(pointMoving, with: nil)
        
        if viewUnderPoint?.isEqual(self.drawFigure ?? UIView()) ?? false && self.isFreeDrawing {
            
            self.drawPointEnd = pointMoving
            self.touch = .freeDrawing
            self.drawFigure.setNeedsDisplay()
            
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.drawPointBegan = nil
        self.drawPointEnd = nil
        
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
   
        self.drawPointBegan = nil
        self.drawPointEnd = nil
        
    }
    
    //Help functions
    func defineColorBy(text: String?, oldColor: UIColor) -> UIColor {
        
        let color = Color.init(rawValue: text?.lowercased() ?? "")
        
        switch color {
        case .red:
            return .red
        case .black:
            return .black
        case .blue:
            return .blue
        case .brown:
            return .brown
        case .clear:
            return .clear
        case .cyan:
            return .cyan
        case .darkGray:
            return .darkGray
        case .gray:
            return .gray
        case .green:
            return .green
        case .lightGray:
            return .lightGray
        case .magenta:
            return .magenta
        case .orange:
            return .orange
        case .purple:
            return .purple
        case .white:
            return .white
        case .yellow:
            return .yellow
        default:
            return oldColor
            
        }
    }
}




