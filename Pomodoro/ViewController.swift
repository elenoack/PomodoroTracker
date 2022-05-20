//
//  ViewController.swift
//  Pomodoro
//
//  Created by mac on 20.05.22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    // MARK: - Constants
    
    enum Static {
        static let centerIndent: CGFloat = 100
        static let centerStopIndent: CGFloat = 92
        static let indent: CGFloat = 16
        static let labelHeight: CGFloat = 200
        static let heightButton: CGFloat = 72
        static let widhtButton: CGFloat = 82
        static let startPoint: CGFloat = (-Double.pi / 2)
        static let endPoint: CGFloat = (2 * Double.pi)
        static let circleRadius: CGFloat = 83
        static let circleSize: CGFloat = 166
        static let heightPlant: CGFloat = 54
        static let widhtPlant: CGFloat = 62
    }
    
    // MARK: - Properties
    
    let background: UIImageView = {
        let background = UIImageView(image: UIImage(named: "background"))
        background.contentMode = .scaleAspectFill
        return background
    }()
    
    var isStopTime = false
    var isWorkTime = false
    var isPressed = false
    var isStopPressed = false
    private var timer = Timer()
    private var stopTimer =  Timer()
    private var workTimeDuration = 1500
    private var stopTimeDuration = 300
    
    // MARK: - Properties Work
    
    private lazy var workLabel: UILabel = {
        let label = UILabel()
        label.text = "25:00"
        label.sizeToFit()
        label.textColor = UIColor(hex: "#DC143C")
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.medium)
        return label
    }()
    
    private lazy var workButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "button"), for: UIControl.State.normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startWork)))
        return button
    }()
    
    private let progressLayer = CAShapeLayer()
    private let circleLayer = CAShapeLayer()
    
    private lazy var circularPath: UIBezierPath = {
        let bezier = UIBezierPath(arcCenter: CGPoint(x:  view.frame.midX, y: view.frame.midY - Static.centerIndent - Static.indent * 2), radius: Static.circleRadius, startAngle: Static.startPoint, endAngle: Static.endPoint, clockwise: true)
        return bezier
    }()
    
    private lazy var plantView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "plant"))
        return view
    }()
    
    private lazy var tomatoWorkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFA07A")
        view.layer.cornerRadius = Static.circleSize / 2
        return view
    }()
    
    // MARK: - Properties Stop
    
    private lazy var stopLabel: UILabel = {
        let label = UILabel()
        label.text = "05:00"
        label.sizeToFit()
        label.textColor = UIColor(hex: "#006400")
        label.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.medium)
        return label
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "button"), for: UIControl.State.normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startStop)))
        return button
    }()
    
    private lazy var tomatoStopView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#A8E4A0")
        view.layer.cornerRadius = Static.circleSize / 2
        return view
    }()
    
    private lazy var plantStopView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "plant"))
        return view
    }()
    
    private let progressStopLayer = CAShapeLayer()
    private let circleStopLayer = CAShapeLayer()
    
    private lazy var circularStopPath: UIBezierPath = {
        let bezier = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY + Static.centerIndent + Static.indent * 2), radius: Static.circleRadius, startAngle: Static.startPoint, endAngle: Static.endPoint, clockwise: true)
        return bezier
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc
    func startWork()  {}
    
    @objc
    func startStop()  {}
    
}

