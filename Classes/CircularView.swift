//
//  CircularView.swift
//  MyProgressView
//
//  Created by Adriaan van Schalkwyk on 2022/06/07.
//

public class CircularView: UIView {
    
    private var totalProgressLayer = CAShapeLayer()
    private var currentProgressLayer = CAShapeLayer()
    private var label = UILabel()
    public var progressLimit: Int?
    
    public var labelText: String? {
        didSet {
            updateLabel(text: labelText ?? "")
        }
    }
    
    public var currentProgress: Int? {
        didSet {
           drawProgressLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayerViews()
        addLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayerViews()
        addLabel()
    }
    
    
    private func drawProgressLayer() {
       let calculatedProgress = calculateCurrentProgress
        setLayerColours(for: Int(calculatedProgress))
        animateStroke(strokeValue: calculatedProgress)
    }
    
    private func setLayerColours(for currentProgress: Int) {
        switch currentProgress {
        case 0...180:
            currentProgressLayer.strokeColor = UIColor(red: 0/255, green: 204/255, blue: 102/255, alpha: 1).cgColor
            totalProgressLayer.strokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        case 181...270:
            currentProgressLayer.strokeColor = UIColor(red: 255/255, green: 178/255, blue: 102/255, alpha: 1).cgColor
            totalProgressLayer.strokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        case 271...359:
            currentProgressLayer.strokeColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1).cgColor
            totalProgressLayer.strokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        case 360:
            currentProgressLayer.strokeColor = UIColor(red: 255/255, green: 51/255, blue: 51/255, alpha: 1).cgColor
            totalProgressLayer.strokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        default:
            currentProgressLayer.strokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
            totalProgressLayer.strokeColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        }
    }
    
    private var calculateCurrentProgress: Double {
        guard let progress = currentProgress,
           let progressLimit = progressLimit else {
               return 0.0
        }
        return (Double(progress) / Double(progressLimit)) * 360
    }
    
    private func setupLayerViews() {
        let center = CGPoint(x: self.frame.size.width / 2,
                             y: self.frame.size.height / 2)
        
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 80,
                                        startAngle: -90.degreesToRadians,
                                        endAngle: 270.degreesToRadians,
                                        clockwise: true)
        
        totalProgressLayer.path = circularPath.cgPath
        totalProgressLayer.fillColor = UIColor.clear.cgColor
        totalProgressLayer.lineWidth = 10.0
        totalProgressLayer.strokeEnd = 1.0
        
        currentProgressLayer.path = circularPath.cgPath
        currentProgressLayer.fillColor = UIColor.clear.cgColor
        currentProgressLayer.strokeColor = UIColor.white.cgColor
        currentProgressLayer.lineWidth = 10.0
        currentProgressLayer.strokeEnd = 0.0
        currentProgressLayer.lineCap = .round
        
        layer.addSublayer(totalProgressLayer)
        layer.addSublayer(currentProgressLayer)
    }
    
    private func updateLabel(text: String) {
        label.text = text
    }
    
    private func addLabel() {
        let x = self.frame.size.width / 2
        let y = self.frame.size.height / 2
        let center = CGPoint(x: x, y: y)
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        label.center = center
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        self.addSubview(label)
    }
    
    private func animateStroke(strokeValue: Double) {
        let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
        strokeIt.fromValue = -90.degreesToRadians
        strokeIt.toValue = strokeValue / 360
        strokeIt.fillMode = .forwards
        strokeIt.isRemovedOnCompletion = false
        currentProgressLayer.add(strokeIt, forKey: nil)
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
