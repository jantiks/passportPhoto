//
//  ExportController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class ExportController: UIViewController, UIPrintInteractionControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIToolbarDelegate {
    
    @IBOutlet var cropAgainButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var printButton: UIButton!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var toolbarPickerView: UIView!
    
    
    let coutNumbers = [1,2,3,4,5,6,7,8,9,10,11,12]
    var croppedImage: UIImage?
    var sizeArr = [(width: Double, height: Double)]()
    var paperSize = CGSize(width: 2480, height: 3505) //a4 paper size in pixeles
    var acTitle = "Paper and Quantity"
    var paperType = "A4"
    var photoCount = 6
    var printedImages = 0
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        
        toolbarPickerView.isHidden = true
        
        pickerView.delegate = self
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneButton], animated: true)
        
        cropAgainButton.layer.borderWidth = 3
        cropAgainButton.layer.cornerRadius = 5
        cropAgainButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        downloadButton.layer.borderWidth = 3
        downloadButton.layer.cornerRadius = 5
        downloadButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        printButton.layer.borderWidth = 3
        printButton.layer.cornerRadius = 5
        printButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let image = croppedImage {
            imageView.image = image
        }
    }
    
    
    @IBAction func downloadTapped(_ sender: Any) {
        
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func printTapped(_ sender: Any) {
        
        callAc()
    }
    
    @objc func doneTapped() {
        print("done")
        toolbarPickerView.isHidden = true
        acTitle = "Paper is \(paperType) : photo count is \(self.photoCount)"
        callAc()
    }
    @objc func willResignActive() {
        print("passed")
        let spiner = SpinnerView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.view.addSubview(spiner)
    }
    
    func callAc() {
        guard let img = imageView else { return }
        
        
        
        let ac = UIAlertController(title: acTitle, message: "Choose paper type and number of photos", preferredStyle: .alert)
        let choosePaper = UIAlertAction(title: "Paper", style: .default) {
            [weak ac, weak self] action in
            guard let self = self else { return }
            guard let ac = ac else { return }

            
            let paperSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            
            let a4 = UIAlertAction(title: "A4 8.3 x 11.7 in", style: .default) { action in
                self.paperType = "A4"
                let a2Width = 2480
                let a2Height = 3505
                
                ac.title = "Paper is \(self.paperType) : photo count is \(self.photoCount)"
                self.paperSize = CGSize(width: a2Width, height: a2Height)
                self.present(ac, animated: true)
            }
            let a5 = UIAlertAction(title: "A5 5.8 x 8.3 in", style: .default) { action in
                self.paperType = "A5"
                let a2Width = 1746
                let a2Height = 2480
                
                ac.title = "Paper is \(self.paperType) : photo count is \(self.photoCount)"
                self.paperSize = CGSize(width: a2Width, height: a2Height)
                self.present(ac, animated: true)
            }
            let a6 = UIAlertAction(title: "A6 4.1 x 5.8 in", style: .default) { action in
                self.paperType = "A6"
                let a2Width = 1239
                let a2Height = 1746
                
                ac.title = "Paper is \(self.paperType) : photo count is \(self.photoCount)"
                self.paperSize = CGSize(width: a2Width, height: a2Height)
                self.present(ac, animated: true)
            }
            
            
            paperSheet.addAction(a4)
            paperSheet.addAction(a5)
            paperSheet.addAction(a6)
            self.present(paperSheet, animated: true)
        }
        
        //uipickerview
        
        let quantity = UIAlertAction(title: "Quantity", style: .default) {
            [weak self] action in
            guard let self = self else { return }
            self.toolbarPickerView.isHidden = false

        }
        
        //print controller
        let presentPrintController = UIAlertAction(title: "Print", style: .default){ [weak self] action in
            guard let self = self else { return }
            let loadView = UIView()
            

            loadView.frame = CGRect(x: (self.view.bounds.width / 2) - 60, y: (self.view.frame.height / 2) - 30, width: 120, height: 60)
            loadView.backgroundColor = .white
            loadView.layer.cornerRadius = 30
            
            let spiner = SpinnerView(frame: CGRect(x: 40, y: 10, width: 40, height: 40))

            loadView.addSubview(spiner)
            self.view.addSubview(loadView)
            

            
            DispatchQueue.main.async {
                let printController = UIPrintInteractionController.shared
                printController.delegate = self
                printController.showsPaperSelectionForLoadedPapers = true
                let printInfo = UIPrintInfo.printInfo()
                
                printController.printInfo = printInfo
                let changedImg = self.imageResize(croppingImageView: img, viewSize: self.paperSize)

                printController.printingItem = changedImg
                
                printController.present(animated: true)
                loadView.removeFromSuperview()
            }
            
            
            


        }
        
        ac.addAction(choosePaper)
        ac.addAction(quantity)
        ac.addAction(presentPrintController)
        present(ac, animated: true)


    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        12
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(coutNumbers[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        photoCount = row + 1
    }
    
    
    func imageResize(croppingImageView: UIImageView, viewSize: CGSize) -> UIImage {
        printedImages = 0
        let imageWidth: Double = sizeArr[0].width
        let imageHeight: Double = sizeArr[0].height
        let newView = UIView()
        newView.frame.size = viewSize
        let columns: Int = Int(viewSize.width / ((CGFloat(imageWidth)) + 30))
        let rows: Int = Int(viewSize.height / ((CGFloat(imageHeight)) + 30))
        
        for column in 0..<columns {
            for row in 0..<rows {
                if printedImages == photoCount { break }
                let img = UIImageView.init(image: croppingImageView.image)
                img.frame = CGRect(x: (Double(column) * imageWidth) + Double(column * 60) , y: ((Double(row) * imageHeight)) + Double(row * 60), width: imageWidth, height: imageHeight)
                
                newView.addSubview(img)
                printedImages += 1
            }
        }
        
        let renderedImage = newView.asImage()
        return renderedImage
        
    }
    
    
    @IBAction func cropAgainTapped(_ sender: Any) {
        if let svc = storyboard?.instantiateViewController(withIdentifier: "Main") {
            
            present(svc, animated: true)
            
        }
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has beed save to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
}


extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContect in
            layer.render(in: rendererContect.cgContext)
            
        }
    }
    
}



// load animation

class SpinnerView : UIView {

    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 3
        setPath()
    }

    override func didMoveToWindow() {
        animate()
    }

    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
        }
    }

    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)

        animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }

    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 2
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        animation.values = (0 ... count).map {
            UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 1, brightness: 1, alpha: 1).cgColor
        }
        animation.duration = duration
        animation.calculationMode = .linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
        
    }

}
