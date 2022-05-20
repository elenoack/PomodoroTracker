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
        static let indent: CGFloat = 32
        static let indentSmall: CGFloat = 2
        static let buttonHeight: CGFloat = 88
        static let buttonWidth: CGFloat = 98
        static let startPoint: CGFloat = (-Double.pi / 2)
        static let endPoint: CGFloat = (2 * Double.pi)
        static let circleRadius: CGFloat = 106
        static let circleSize: CGFloat = 220
        static let plantHeight: CGFloat = 76
        static let plantWidth: CGFloat = 86
    }
    
    // MARK: - Properties
    
    let background: UIImageView = {
        let background = UIImageView(image: UIImage(named: "background"))
        background.contentMode = .scaleAspectFill
        return background
    }()
    
    private var isWorkTime = false
    private var isStopTime = false
    private var isPressed = false
    private var timer = Timer()
    private var timeDuration = 1500
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "25:00"
        label.sizeToFit()
        label.textColor = UIColor(hex: "#DC143C")
        label.font = UIFont.systemFont(ofSize: 37, weight: UIFont.Weight.medium)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "tomato"), for: UIControl.State.normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startWork)))
        return button
    }()
    
    private let progressLayer = CAShapeLayer()
    private let circleLayer = CAShapeLayer()
    
    private lazy var circul: UIBezierPath = {
        let bezier = UIBezierPath(arcCenter: view.center, radius: Static.circleRadius, startAngle: Static.startPoint, endAngle: Static.endPoint, clockwise: true)
        return bezier
    }()
    
    private lazy var plantView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "plant"))
        return view
    }()
    
    private lazy var tomatoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#FFA07A")
        view.layer.cornerRadius = Static.circleSize / 2
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCircul()
        setupView()
        setupLayout()
    }
}

// MARK: - Private

private extension ViewController {
    
    func setupView() {
        view.addSubviewsForAutoLayout([
            background,
            tomatoView,
            label,
            button,
            plantView,
        ])
        
        view.layer.addSublayer(circleLayer)
        view.layer.addSublayer(progressLayer)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            background.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            background.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            background.widthAnchor.constraint(equalTo: view.widthAnchor),
            background.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: Static.buttonHeight),
            button.widthAnchor.constraint(equalToConstant: Static.buttonWidth),
            
            tomatoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tomatoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tomatoView.heightAnchor.constraint(equalToConstant: Static.circleSize),
            tomatoView.widthAnchor.constraint(equalToConstant: Static.circleSize),
            
            plantView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plantView.heightAnchor.constraint(equalToConstant: Static.plantHeight),
            plantView.widthAnchor.constraint(equalToConstant: Static.plantWidth),
            plantView.bottomAnchor.constraint(equalTo: tomatoView.topAnchor, constant: -Static.indentSmall),
            
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -Static.indent),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: plantView.bottomAnchor, constant: Static.indent),
        ])
    }
}

// MARK: - Configuration

extension ViewController {
    
    func createCircul() {
        circleLayer.path = circul.cgPath
        progressLayer.path = circul.cgPath
        
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor(hex: "#FA8072").cgColor
        circleLayer.lineWidth = 15
        circleLayer.strokeEnd = 1.0
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor(hex: "#DC143C").cgColor
        progressLayer.lineWidth = 15
        progressLayer.strokeEnd = 0
    }
}

// MARK: - Actions

extension ViewController {
    
    @objc
    func startWork()  {
        if !isPressed {
            startTimer()
            progressAnimation(duration: TimeInterval(timeDuration))
            isPressed = true
            isWorkTime = true
        } else {
            if isWorkTime {
                stopAnimation()
            } else {
                resumeAnimation()
            }
        }
    }
    
    @objc
    func startAnimation() {
        if timeDuration > 1 {
            timeDuration -= 1
            label.text = formatTime(timeDuration)
        } else {
            finishAnimation()
            loadNewColor()
        }
    }
    
    // MARK: - Animation
    
    func progressAnimation(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1.0
        animation.duration = duration
        animation.fillMode = .removed
        progressLayer.add(animation, forKey: "progressAnim")
    }
    
    func stopAnimation() {
        timer.invalidate()
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
        isWorkTime = false
    }
    
    func resumeAnimation() {
        startTimer()
        let pausedTime = progressLayer.timeOffset
        progressLayer.timeOffset = 0.0
        progressLayer.speed = 1.0
        progressLayer.fillMode = .forwards
        let timeSincePause = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeSincePause
        isWorkTime = true
    }
    
    func finishAnimation() {
        progressLayer.removeAnimation(forKey: "progressAnim")
        progressLayer.strokeEnd = 0
        timer.invalidate()
        isWorkTime = false
        isPressed = false
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
    }
    
    func formatTime(_ time: Int) -> String {
        let minutes = (time / 60) % 60
        let hours = (time % 60)
        return String(format: "%02d:%02d", minutes, hours)
    }
    
    func loadNewColor() {
        if !isStopTime {
            timeDuration = 300
            label.text = formatTime(timeDuration)
            label.textColor = UIColor(hex: "#006400")
            tomatoView.backgroundColor = UIColor(hex: "#A8E4A0")
            circleLayer.strokeColor = UIColor(hex: "#8FBC8F").cgColor
            progressLayer.strokeColor = UIColor(hex: "#006400").cgColor
            isStopTime = true
        } else {
            timeDuration = 1500
            label.text = formatTime(timeDuration)
            label.textColor = UIColor(hex: "#DC143C")
            tomatoView.backgroundColor = UIColor(hex: "#FFA07A")
            circleLayer.strokeColor = UIColor(hex: "#FA8072").cgColor
            progressLayer.strokeColor = UIColor(hex: "#DC143C").cgColor
            isStopTime = false
        }
    }
}


