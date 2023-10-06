//
//  PreviewView.swift
//  PersonRez
//
//  Created by Hồ Sĩ Tuấn on 06/09/2020.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit

import UIKit
import Vision
import AVFoundation

class PreviewView: UIView {
    
    private var maskLayer = [CAShapeLayer]()
    private var textLayer = [CATextLayer]()
    
    // MARK: AV capture properties
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            videoPreviewLayer.videoGravity = .resizeAspectFill
            return videoPreviewLayer.session
        }
        
        set {
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // Create a new layer drawing the bounding box
    private func createLayer(in rect: CGRect, prediction: String) -> CAShapeLayer{
        
        let mask = CAShapeLayer()
        mask.frame = rect
        mask.cornerRadius = 10
        mask.opacity = 1
        mask.borderColor = UIColor.yellow.cgColor
        mask.borderWidth = 2.0
        
        let label = CATextLayer()
        label.frame = rect
        label.string = prediction
        label.fontSize = 20
        layer.addSublayer(label)
        
        textLayer.append(label)
        maskLayer.append(mask)
        layer.insertSublayer(mask, at: 1)
        
        return mask
    }
    
    
    func drawFaceboundingBox(face : VNFaceObservation) {
        
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -frame.height)
        
        let translate = CGAffineTransform.identity.scaledBy(x: frame.width, y: frame.height)
        
        let facebounds = face.boundingBox.applying(translate).applying(transform)
        
        var label = "Unknown"
        if let frame = currentFrame {
            let result = model.predict(image:  (frame.resized(smallestSide: 227)!))
            print(result)
            let confidence = result.1! * 100
            if confidence >= 80 {

                if result.0 == "unknown" {
                    label = "Unknown"
                }
                else {
                    if let name = userDict[result.0!] {
                        label = "\(name): \(confidence.rounded() )%"
                        //print(attendList.count)
                        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .medium)
                        let detectedUser = User(name: name, image: frame, time: timestamp, confidence: "- \(confidence.rounded())%")
                        if attendList.count == 0 {
                            attendList.append(detectedUser)
//                            let utterance = AVSpeechUtterance(string: "Hello \(name)")
//                            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//                            utterance.rate = 0.1
//
//                            let synthesizer = AVSpeechSynthesizer()
//                            synthesizer.speak(utterance)
                        }
                        else {
                            var count = 0
                            for item in attendList {
                                if item.name != name {
                                    count += 1
                                }
                            }
                            if count == attendList.count {
                                attendList.append(detectedUser)
                            }
                            else {
                                //print("User added")
                            }
                        }
                    }

                }
            }
            else {
            }
        }
        

        _ = createLayer(in: facebounds, prediction: label)
        
    }
    func ImageInRect(_ rect: CGRect) -> UIImage?
    {
        
        return nil
    }
    func removeMask() {
        for mask in maskLayer {
            mask.removeFromSuperlayer()
        }
        for text in textLayer {
            text.removeFromSuperlayer()
        }
        textLayer.removeAll()
        maskLayer.removeAll()
    }
    
}





