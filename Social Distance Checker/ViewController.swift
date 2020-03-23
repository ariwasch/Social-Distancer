//
//  ViewController.swift
//  Social Distance Checker
//
//  Created by Ari Wasch on 3/22/20.
//  Copyright © 2020 Ari Wasch. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreML

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
//    let yolo = YOLOv3TinyInput(image: kCVPixelFormatType_32BGRA as! CVPixelBuffer)
//    var bigArray = [VNRecognizedObjectObservation]()
    var firstPerson = VNRecognizedObjectObservation()
//    var views = [UIView]()
    var firstView = UIView()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.startRunning()
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
//        print("SDadasjdkasdKASD")

    }

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        print("SDKASD")
//        print("popopo", Date())
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else  {return}
        guard let model = try? VNCoreMLModel(for: YOLOv3().model) else {return}
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
//            print(finishedReq.results ?? "nothingg")
            let array = finishedReq.results
            if(array!.count > 0){
//                self.bigArray = [VNRecognizedObjectObservation]()
                let poop = array?.first as! VNRecognizedObjectObservation
                self.firstPerson = poop
//                print("object", poop.labels[0].identifier)
//                print("confidence", poop.confidence)
//                print("height", poop.boundingBox.height)
                
//                self.bigArray.append(poop)
            guard let results = finishedReq.results as? [VNClassificationObservation] else {
                return }

            
                
            guard let firstObservation = results.first else { print("jh")
                return }
            }
//            print("thing", firstObservation.identifier, firstObservation.confidence)

        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        DispatchQueue.main.async {
            if(self.firstPerson != nil){
                print("confidence ", self.firstPerson.confidence)
                if(self.firstPerson.confidence > 0.8    && self.firstPerson.labels[0].identifier == "person"){
                self.firstView.removeFromSuperview()

                let width = self.view.frame.width * self.firstPerson.boundingBox.width
                print("width ", width)
                let height = self.view.frame.height * self.firstPerson.boundingBox.height
                print("height ", height)

                let x = self.view.frame.width * self.firstPerson.boundingBox.minX
                let y = self.view.frame.height * self.firstPerson.boundingBox.minY
//                    self.firstPerson.boundingBox.width < 224 &&
                    if(height < 336 && width < 224){
                        self.firstView.backgroundColor = .green
                        print("FUCK OFF")

                    }else{
                        self.firstView.backgroundColor = .red
                        print("GOOD")
                    }
                self.firstView.alpha = 0.4
//                336 224
                self.firstView.frame = CGRect(x: x, y: y, width: width, height: height)
                self.view.addSubview(self.firstView)
//                print(x)
                }else{
                    self.firstView.removeFromSuperview()

                }
            }
            
        }
        
    }
    
}
////
////  ViewController.swift
////  Social Distance Checker
////
////  Created by Ari Wasch on 3/22/20.
////  Copyright © 2020 Ari Wasch. All rights reserved.
////
//
//import UIKit
//import AVKit
//import Vision
//import CoreML
//
//class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//
////    let yolo = YOLOv3TinyInput(image: kCVPixelFormatType_32BGRA as! CVPixelBuffer)
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let captureSession = AVCaptureSession()
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
//        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
//        captureSession.addInput(input)
//        captureSession.startRunning()
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        captureSession.addOutput(dataOutput)
//        print("SDadasjdkasdKASD")
//
//    }
//
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
////        print("SDKASD")
////        print("popopo", Date())
//        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else  {return}
//
//        guard let model = try? VNCoreMLModel(for: YOLOv3Int8LUT().model) else {return}
//        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
////            print(finishedReq.results ?? "nothingg")
//            var array = finishedReq.results
//            if(array!.count > 0){
//            var poop = array?.first as! VNRecognizedObjectObservation
//
//                print("object", poop.labels[0].identifier)
//                print("confidence", poop.confidence)
//                print("height", poop.boundingBox.height)
//            guard let results = finishedReq.results as? [VNClassificationObservation] else { print("pp ppoo")
//                return }
////            print(results.count)
//            guard let firstObservation = results.first else { print("jh")
//                return }
//            }
////            print("thing", firstObservation.identifier, firstObservation.confidence)
//
//        }
//
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//    }
//
//}
////
////  ViewController.swift
////  Social Distance Checker
////
////  Created by Ari Wasch on 3/22/20.
////  Copyright © 2020 Ari Wasch. All rights reserved.
////
//
//import UIKit
//import AVKit
//import Vision
//import CoreML
//
//class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
//
////    let yolo = YOLOv3TinyInput(image: kCVPixelFormatType_32BGRA as! CVPixelBuffer)
//    var bigArray = [VNRecognizedObjectObservation]()
//    var firstPerson = VNRecognizedObjectObservation()
//    var views = [UIView]()
//    var firstView = UIView()
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//        let captureSession = AVCaptureSession()
//        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
//        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
//        captureSession.addInput(input)
//        captureSession.startRunning()
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        view.layer.addSublayer(previewLayer)
//        previewLayer.frame = view.frame
//
//
//        let dataOutput = AVCaptureVideoDataOutput()
//        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        captureSession.addOutput(dataOutput)
//        print("SDadasjdkasdKASD")
//
//    }
//
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
////        print("SDKASD")
////        print("popopo", Date())
//        self.bigArray.removeAll()
////        DispatchQueue.main.async {
//
////        }
//        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else  {return}
//        guard let model = try? VNCoreMLModel(for: YOLOv3().model) else {return}
//        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
////            print(finishedReq.results ?? "nothingg")
//            let array = finishedReq.results
//            if(array!.count > 0){
////                self.bigArray = [VNRecognizedObjectObservation]()
//                DispatchQueue.main.async {
//
//
//                let poop = array?.first as! VNRecognizedObjectObservation
//                self.firstPerson = poop
//                print("object", poop.labels[0].identifier)
//                print("confidence", poop.confidence)
//                print("height", poop.boundingBox.height)
//
//                var tempView = UIView()
//                let width = self.view.frame.width * poop.boundingBox.width
//                let height = self.view.frame.height * poop.boundingBox.height
//                let x = self.view.frame.width * poop.boundingBox.minX
//                let y = self.view.frame.height * poop.boundingBox.minY
//
//                tempView.backgroundColor = .red
//                tempView.alpha = 0.2
//                print("objetc", 1, x)
//                tempView.frame = CGRect(x: x, y: y, width: width, height: height)
//                    self.view.addSubview(tempView)
//
//                if(array!.count > 1){
//                let poop2 = array?[1] as! VNRecognizedObjectObservation
//                self.firstPerson = poop
//                print("object2", poop2.labels[0].identifier)
//                print("confidence2", poop2.confidence)
//                print("height2", poop2.boundingBox.height)
//                }
////                self.bigArray.removeAll()
//
//                var i: Int = 0
//
////                for object in self.view.subviews{
////                    object.removeFromSuperview()
////                }
////                for object in array! {
////                    i += 1
////                    print(i, (object as AnyObject).labels[0].identifier, array!.count)
////                    if(((object as! VNRecognizedObjectObservation).labels[0].identifier) == "banana"){
////                        var tempView = UIView()
////                        let width = self.view.frame.width * (object as AnyObject).boundingBox.width
////                        let height = self.view.frame.height * (object as AnyObject).boundingBox.height
////                        let x = self.view.frame.width * (object as AnyObject).boundingBox.minX
////                        let y = self.view.frame.height * (object as AnyObject).boundingBox.minY
////
////                        tempView.backgroundColor = .red
////                        tempView.alpha = 0.2
////                        print("objetc", i, x)
////                        tempView.frame = CGRect(x: x, y: y, width: width, height: height)
////                            self.view.addSubview(tempView)
////                        }
////
////                        self.bigArray.append(object as! VNRecognizedObjectObservation)
////                    }
//                }
////                self.bigArray.append(poop)
//
//            guard let results = finishedReq.results as? [VNClassificationObservation] else { print("pp ppoo")
//                return }
//
//
//
//            guard let firstObservation = results.first else { print("jh")
//                return }
//            }
////            print("thing", firstObservation.identifier, firstObservation.confidence)
//
//        }
//
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
//
////        DispatchQueue.main.async {
////            if(self.firstPerson != nil){
////                self.firstView.removeFromSuperview()
////                let width = self.view.frame.width * self.firstPerson.boundingBox.width
////                let height = self.view.frame.height * self.firstPerson.boundingBox.height
////                let x = self.view.frame.width * self.firstPerson.boundingBox.minX
////                let y = self.view.frame.height * self.firstPerson.boundingBox.minY
////                self.firstView.backgroundColor = .red
////                self.firstView.alpha = 0.2
////
////                self.firstView.frame = CGRect(x: x, y: y, width: width, height: height)
////                self.view.addSubview(self.firstView)
////                print(x)
////
////            }
////            if(self.bigArray.count > 0){
////
////                if(self.views.count > 0){
////                    for view1 in self.views{
////                        view1.removeFromSuperview()
////                    }
////                }
////                self.views.removeAll()
////                var redView = UIView()
////                for object in self.bigArray{
//////                    print("HSFAF", self.bigArray.count)
////                let width = self.view.frame.width * (object as AnyObject).boundingBox.width
////                let height = self.view.frame.height * (object as AnyObject).boundingBox.height
////                let x = self.view.frame.width * (object as AnyObject).boundingBox.minX
////                let y = self.view.frame.height * (object as AnyObject).boundingBox.minY
////                redView.backgroundColor = .red
////                redView.alpha = 0.2
////                print("objetc", x)
////                redView.frame = CGRect(x: x, y: y, width: width, height: height)
////                self.views.append(redView)
////                }
////                print("ASFAJFO", self.views.count)
////                if(self.views.count > 0){
////                    for view in self.views{
////                        self.view.addSubview(view)
////                        print(self.views.count)
////                        print(self.bigArray.count)
////
////                    }
////                }
////
////            }
//
//
//
////    }
//    }
//
//
//}
//////
//////  ViewController.swift
//////  Social Distance Checker
//////
//////  Created by Ari Wasch on 3/22/20.
//////  Copyright © 2020 Ari Wasch. All rights reserved.
//////
////
////import UIKit
////import AVKit
////import Vision
////import CoreML
////
////class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
////
//////    let yolo = YOLOv3TinyInput(image: kCVPixelFormatType_32BGRA as! CVPixelBuffer)
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        let captureSession = AVCaptureSession()
////        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
////        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
////        captureSession.addInput(input)
////        captureSession.startRunning()
////        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
////        view.layer.addSublayer(previewLayer)
////        previewLayer.frame = view.frame
////
////        let dataOutput = AVCaptureVideoDataOutput()
////        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
////        captureSession.addOutput(dataOutput)
////        print("SDadasjdkasdKASD")
////
////    }
////
////
////    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//////        print("SDKASD")
//////        print("popopo", Date())
////        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else  {return}
////
////        guard let model = try? VNCoreMLModel(for: YOLOv3Int8LUT().model) else {return}
////        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
//////            print(finishedReq.results ?? "nothingg")
////            var array = finishedReq.results
////            if(array!.count > 0){
////            var poop = array?.first as! VNRecognizedObjectObservation
////
////                print("object", poop.labels[0].identifier)
////                print("confidence", poop.confidence)
////                print("height", poop.boundingBox.height)
////            guard let results = finishedReq.results as? [VNClassificationObservation] else { print("pp ppoo")
////                return }
//////            print(results.count)
////            guard let firstObservation = results.first else { print("jh")
////                return }
////            }
//////            print("thing", firstObservation.identifier, firstObservation.confidence)
////
////        }
////
////        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
////    }
////
////}
