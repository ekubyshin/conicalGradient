//
//  ViewController.swift
//  cgpath
//
//  Created by Evgeniy Kubyshin on 14/03/2019.
//

import UIKit

class ConicalGradient: UIView {
    override func draw(_ rect: CGRect) {
        let beginColor = UIColor.red
        let endColor = UIColor.yellow
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let longerSide = max(rect.width, rect.height)
        let radius = Double(longerSide) * 2.squareRoot()
        let length = 2 * .pi * radius
        let step = 360 / length
        var angle = 0.0
        while angle <= 360 {
            let line = UIBezierPath(rect: CGRect.zero)
            line.move(to: center)
            let nextCords = coordsForAngel(CGFloat(angle), in: rect)
            let color = self.color(for: CGFloat(angle), from: beginColor, to: endColor)
            color.setStroke()
            line.addLine(to: CGPoint(x: nextCords.0, y: nextCords.1))
            line.stroke()
            angle += step
        }
    }
    func coordsForAngel(_ angle: CGFloat, in rect: CGRect) -> (CGFloat, CGFloat) {
        let longerSide = max(rect.width, rect.height)
        let radius = longerSide * CGFloat(2.squareRoot())
        let x0 = rect.midX
        let y0 = rect.midY
        let rad = Measurement(value: Double(angle), unit: UnitAngle.degrees).converted(to: UnitAngle.radians).value
        let x = x0 + radius * CGFloat(cos(rad))
        let y = y0 + radius * CGFloat(sin(rad))
        return (x, y)
    }
    func color(for angle: CGFloat, from: UIColor, to: UIColor) -> UIColor {
        let percent = angle / 360
        return UIColor.lerp(from: from.rgba, to: to.rgba, percent: percent)
    }
}

private extension UIColor {
    struct RGBA {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        init(color: UIColor) {
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
    }
    
    var rgba: RGBA {
        return RGBA(color: self)
    }
    
    class func lerp(from: RGBA, to: RGBA, percent: CGFloat) -> UIColor {
        let red = from.red + percent * (to.red - from.red)
        let green = from.green + percent * (to.green - from.green)
        let blue = from.blue + percent * (to.blue - from.blue)
        let alpha = from.alpha + percent * (to.alpha - from.alpha)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let size: CGFloat = 400
        let v = ConicalGradient(frame: CGRect(x: view.frame.midX - size / 2, y: view.frame.midY - size / 2, width: size, height: size))
        view.addSubview(v)
    }

}

