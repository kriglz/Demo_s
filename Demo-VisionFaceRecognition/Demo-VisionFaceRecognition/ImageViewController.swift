//
//  ImageViewController.swift
//  Demo-VisionFaceRecognition
//
//  Created by Kristina Gelzinyte on 8/13/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit
import Vision

class ImageViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    // MARK: - Lifecycle functions

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView?.image = image
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: UIButton) {
        imageView.image = nil
        image = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proceedAction(_ sender: UIButton) {
        performFaceRecognition()
    }
    
    // MARK: - Image processing
    
    private func performFaceRecognition() {
        guard let image = self.image, let cgImage = image.cgImage else { return }
        
        let faceLandmarkRequest = VNDetectFaceLandmarksRequest { [weak self] (request, error) in
            self?.handleFaceFeatures(request: request, error: error)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: image.orientation, options: [:])
        
        do {
            try requestHandler.perform([faceLandmarkRequest])
        } catch {
            print(error)
        }
    }
    
    private func handleFaceFeatures(request: VNRequest, error: Error?) {
        guard let observationResults = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result tyoe")
        }
        
        for face in observationResults {
            drawFaceLandmark(face: face)
        }
    }
    
    private func drawFaceLandmark(face: VNFaceObservation) {
        guard let image = self.image else { return }
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        image.draw(in: CGRect(origin: .zero, size: image.size))
        
        // Flip image.
        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1, y: -1)
        
        // Draw face rect.
        let width = face.boundingBox.size.width * image.size.width
        let height = face.boundingBox.size.height * image.size.height
        let originX = face.boundingBox.origin.x * image.size.width
        let originY = face.boundingBox.origin.y * image.size.height
        let faceRect = CGRect(x: originX, y: originY, width: width, height: height)
        
        context.saveGState()
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(8)
        context.addRect(faceRect)
        context.drawPath(using: .stroke)
        context.restoreGState()
        
        // Face contour.
        if let faceContourPoints = face.landmarks?.faceContour?.normalizedPoints {
            context.drawCustomShape(using: faceContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height), isPathClosed: false)
        }
        
        // Outer lips contour.
        if let outerLipContourPoints = face.landmarks?.outerLips?.normalizedPoints {
            context.drawCustomShape(using: outerLipContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height))
        }
        
        // Inner lips contour.
        if let innerLipContourPoints = face.landmarks?.innerLips?.normalizedPoints {
            context.drawCustomShape(using: innerLipContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height))
        }
        
        // Left eye
        if let leftEyeContourPoints = face.landmarks?.leftEye?.normalizedPoints {
            context.drawCustomShape(using: leftEyeContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height))
        }
        
        // Right eye
        if let rightEyeContourPoints = face.landmarks?.rightEye?.normalizedPoints {
            context.drawCustomShape(using: rightEyeContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height))
        }
        
        // Left eye pupil
        if let leftEyePupilContourPoints = face.landmarks?.leftPupil?.normalizedPoints {
            context.drawCustomShape(using: leftEyePupilContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height))
        }
        
        // Right eye pupil
        if let rightEyePupilContourPoints = face.landmarks?.rightPupil?.normalizedPoints {
            context.drawCustomShape(using: rightEyePupilContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height))
        }
        
        // Left eyebrow
        if let leftEyebrowContourPoints = face.landmarks?.leftEyebrow?.normalizedPoints {
            context.drawCustomShape(using: leftEyebrowContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height), isPathClosed: false)
        }
        
        // Right eyebrow
        if let rightEyebrowContourPoints = face.landmarks?.rightEyebrow?.normalizedPoints {
            context.drawCustomShape(using: rightEyebrowContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height), isPathClosed: false)
        }
        
        // Nose
        if let noseContourPoints = face.landmarks?.nose?.normalizedPoints {
            context.drawCustomShape(using: noseContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height))
        }
        
        // Nose crest
        if let noseCrestContourPoints = face.landmarks?.noseCrest?.normalizedPoints {
            context.drawCustomShape(using: noseCrestContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height), isPathClosed: false)
        }
        
        // Median line
        if let medianLineContourPoints = face.landmarks?.medianLine?.normalizedPoints {
            context.drawCustomShape(using: medianLineContourPoints, pointOrigin: CGPoint(x: originX, y: originY), imageSize: CGSize(width: width, height: height), isPathClosed: false)
        }
        
        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        imageView.image = processedImage
    }
}

extension CGContext {
    
    func drawCustomShape(using points: [CGPoint], pointOrigin: CGPoint, imageSize: CGSize, isPathClosed: Bool? = true) {
        self.saveGState()
        self.setStrokeColor(UIColor.white.cgColor)
        self.setLineWidth(8)
        
        for i in 0..<points.count {
            let faceContourPoint = points[i]
            let point = CGPoint(x: pointOrigin.x + CGFloat(faceContourPoint.x) * imageSize.width,
                                y: pointOrigin.y + CGFloat(faceContourPoint.y) * imageSize.height)
            
            if i == 0 {
                self.move(to: point)
            } else {
                self.addLine(to: point)
            }
        }
        
        if let isClosed = isPathClosed, isClosed {
            self.closePath()
        }
        
        self.drawPath(using: .stroke)
        self.restoreGState()
    }
}

extension UIImage {
    
    var orientation: CGImagePropertyOrientation {
        switch self.imageOrientation {
        case .up:
            return CGImagePropertyOrientation(rawValue: 1)!
        case .right:
            return CGImagePropertyOrientation(rawValue: 6)!
        case .down:
            return CGImagePropertyOrientation(rawValue: 3)!
        case .left:
            return CGImagePropertyOrientation(rawValue: 8)!
        default:
            return CGImagePropertyOrientation(rawValue: 1)!
        }
    }
}
