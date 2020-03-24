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
import GoogleMobileAds

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var views = [UIView]()
    var labels = [UILabel]()

//    var bannerView: GADBannerView!

    @IBOutlet weak var label: UILabel!
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
        
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
////        bannerView.adUnitID = "ca-app-pub-2006923484031604~8393105852"
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
//
//        bannerView.rootViewController = self
//
//        addBannerViewToView(bannerView)
//        bannerView.load(GADRequest())

    }

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else  {return}
        guard let model = try? VNCoreMLModel(for: YOLOv3().model) else {return}
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            let array = finishedReq.results

            if(array!.count > 0){
//                let poop = array?.first as! VNRecognizedObjectObservation
//                print("object", poop.labels[0].identifier, array!.count)
                DispatchQueue.main.async {
                    if(self.views.count > 0){
                        for object in self.views{
                            object.removeFromSuperview()
                        }
                            self.views.removeAll()
                        }
                    if(self.labels.count > 0){
                        for object in self.labels{
                            object.removeFromSuperview()
                        }
                            self.labels.removeAll()
                        }
                    for object in array!{
                        if(((object as! VNRecognizedObjectObservation).labels[0].identifier == "person") && ((object as! VNRecognizedObjectObservation).labels[0].confidence > 0.51)){
                            var tempView = UIView()
                            let width = self.view.frame.height * (object as AnyObject).boundingBox.width
                            let height = self.view.frame.width * (object as AnyObject).boundingBox.height
                            let x = self.view.frame.height * (object as AnyObject).boundingBox.minX
                            let y = self.view.frame.width * (object as AnyObject).boundingBox.minY
//                            self.label.text = "Y: \(y) W: \(width) h: \(height)"
                            tempView.frame = CGRect(x: y, y: x, width: height, height: width)
                            
                            let label = UILabel(frame: CGRect(x: y, y: x, width: height, height: 21))
//                            label.center = CGPoint(x:  self.view.frame.width / 2, y:          self.view.frame.height - 21 - (bannerView.adSize.size.height * 1.5)  )
                            label.textAlignment = .center
//                            label.alpha = 0.3
                            label.textColor = .black
//                            self.view.addSubview(label)
                            if(height < 180 && width < 470){
                                tempView.backgroundColor = .green
                                label.backgroundColor = .green
                                label.text = "You are safe!"

                            }else{
                                tempView.backgroundColor = .red
                                label.backgroundColor = .red
                                label.text = "Stay back!"

                            }
                            tempView.alpha = 0.3
                            
                            self.views.append(tempView)
                            self.labels.append(label)

                        }
                    }
                    if(self.views.count > 0){
                        for object in self.views{
                            self.view.addSubview(object)
                        }
                    }
                    if(self.labels.count > 0){
                        for object in self.labels{
                            self.view.addSubview(object)
                        }
                        
                    }

                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
     view.addSubview(bannerView)
     view.addConstraints(
       [NSLayoutConstraint(item: bannerView,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: bottomLayoutGuide,
                           attribute: .top,
                           multiplier: 1,
                           constant: 0),
        NSLayoutConstraint(item: bannerView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0)
       ])
    }
}
