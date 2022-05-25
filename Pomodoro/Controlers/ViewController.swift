//
//  ViewController.swift
//  Pomodoro
//
//  Created by mac on 20.05.22.
//


import UIKit
import AVFoundation

class ViewController: UIViewController {
    // MARK: - Constants
    
    enum Static {
        static let indent: CGFloat = 40
        static let indentSmall: CGFloat = 8
        static let buttonHeight: CGFloat = 88
        static let buttonWidth: CGFloat = 98
        static let startPoint: CGFloat = (-Double.pi / 2)
        static let endPoint: CGFloat = (2 * Double.pi)
        static let circleRadius: CGFloat = 116
        static let circleSize: CGFloat = 230
        static let plantHeight: CGFloat = 58
        static let plantWidth: CGFloat = 68
        static let plusButtoWidth: CGFloat = 20
        static let plusButtonHeight: CGFloat = 26
        static let plusButtonIndent: CGFloat = 4
        static let musicButtoWidth: CGFloat = 146
        static let musicButtonHeight: CGFloat = 106
        static let musicButtonIndent: CGFloat = 12
        static let musicViewSize: CGFloat = 38
    }
    
    // MARK: - Properties
    
    var player: AVAudioPlayer?
    let url = Bundle.main.url(forResource: "Music", withExtension: ".mp3")
    
    let background: UIImageView = {
        let background = UIImageView(image: UIImage(named: "background"))
        background.contentMode = .scaleAspectFill
        return background
    }()
    
    private var isPlayMusic = false
    private var isWorkTime = false
    private var isStopTime = false
    private var isPressed = false
    private var timer = Timer()
    private var timeDuration = 150000
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "25:00"
        label.sizeToFit()
        label.textColor = UIColor(hex: "#DC143C")
        label.font = UIFont.systemFont(ofSize: 38, weight: UIFont.Weight.medium)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "tomato"), for: UIControl.State.normal)
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startWork)))
        return button
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "chevron.compact.up"), for: UIControl.State.normal)
        button.tintColor = UIColor(hex: "#DC143C")
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusTime)))
        return button
    }()
    
    private lazy var minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "chevron.compact.down"), for: UIControl.State.normal)
        button.tintColor = UIColor(hex: "#DC143C")
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(minusTime)))
        return button
    }()
    
    private lazy var musicView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "music"))
        return imageView
    }()
    
    private lazy var musicButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "music.quarternote.3"), for: UIControl.State.normal)
        button.tintColor = UIColor(hex: "#6B8E23")
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playMusic)))
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
            plusButton,
            minusButton,
            musicView,
            musicButton,
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
            
            plusButton.widthAnchor.constraint(equalToConstant: Static.plusButtoWidth),
            plusButton.heightAnchor.constraint(equalToConstant: Static.plusButtonHeight),
            plusButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            plusButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: Static.plusButtonIndent),
            
            minusButton.widthAnchor.constraint(equalToConstant: Static.plusButtoWidth),
            minusButton.heightAnchor.constraint(equalToConstant: Static.plusButtonHeight),
            minusButton.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            minusButton.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -Static.plusButtonIndent),
            
            musicView.widthAnchor.constraint(equalToConstant: Static.musicButtoWidth),
            musicView.heightAnchor.constraint(equalToConstant: Static.musicButtonHeight),
            musicView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Static.musicButtonIndent),
            musicView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -Static.musicButtonIndent),
            
            musicButton.centerXAnchor.constraint(equalTo: musicView.centerXAnchor),
            musicButton.centerYAnchor.constraint(equalTo: musicView.centerYAnchor),
            musicButton.heightAnchor.constraint(equalToConstant: Static.musicViewSize),
            musicButton.widthAnchor.constraint(equalToConstant: Static.musicViewSize),
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
    
    @objc
    func plusTime() {
        timeDuration += 6000
        let newTime = timeDuration / 100
        let minutes = (newTime / 60) % 60
        let hours = (newTime % 60)
        label.text = String(format: "%02d:%02d", minutes, hours)
    }
    
    @objc
    func minusTime() {
        timeDuration -= 6000
        let newTime = timeDuration / 100
        let minutes = (newTime / 60) % 60
        let hours = (newTime % 60)
        label.text = String(format: "%02d:%02d", minutes, hours)
    }
    
    @objc
    func playMusic() {
        if let url = url {
            player = try? AVAudioPlayer(contentsOf: url)
            if isPlayMusic {
                player?.stop()
                isPlayMusic = false
            } else {
                player?.play()
                isPlayMusic = true
            }
        }
    }
    
    // MARK: - Animation
    
    func progressAnimation(duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1.0
        animation.duration = duration
        animation.fillMode = .removed
        progressLayer.add(animation, forKey: "progressAnim")
        plusButton.isEnabled = false
        minusButton.isEnabled = false
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
        plusButton.isEnabled = true
        minusButton.isEnabled = true
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(startAnimation), userInfo: nil, repeats: true)
    }
    
    func formatTime(_ time: Int) -> String {
        let newTime = (time + 100) / 100
        let minutes = (newTime / 60) % 60
        let hours = (newTime % 60)
        return String(format: "%02d:%02d", minutes, hours)
    }
    
    func loadNewColor() {
        if !isStopTime {
            timeDuration = 30000
            label.text = "05:00"
            label.textColor = UIColor(hex: "#006400")
            tomatoView.backgroundColor = UIColor(hex: "#A8E4A0")
            circleLayer.strokeColor = UIColor(hex: "#8FBC8F").cgColor
            progressLayer.strokeColor = UIColor(hex: "#006400").cgColor
            plusButton.tintColor = UIColor(hex: "#006400")
            minusButton.tintColor = UIColor(hex: "#006400")
            isStopTime = true
        } else {
            timeDuration = 150000
            label.text = "25:00"
            label.textColor = UIColor(hex: "#DC143C")
            tomatoView.backgroundColor = UIColor(hex: "#FFA07A")
            circleLayer.strokeColor = UIColor(hex: "#FA8072").cgColor
            progressLayer.strokeColor = UIColor(hex: "#DC143C").cgColor
            plusButton.tintColor = UIColor(hex: "#DC143C")
            minusButton.tintColor = UIColor(hex: "#DC143C")
            isStopTime = false
        }
    }
}


