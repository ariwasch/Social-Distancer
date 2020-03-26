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
    var tempLabel = UILabel()
    var tempView = UIView()
    @IBOutlet weak var info: UIButton!
    
    var bannerView: GADBannerView!

    @IBOutlet weak var hiddenLabel: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    var model:VNCoreMLModel? = nil
    override func viewDidLoad() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        model = try? VNCoreMLModel(for: YOLOv3FP16().model)
        super.viewDidLoad()
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
            
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession.addInput(input)
        captureSession.sessionPreset = .vga640x480
        captureSession.startRunning()
        if let frameSupportRange = captureDevice.activeFormat.videoSupportedFrameRateRanges.first {
            captureSession.beginConfiguration()
            // currentCamera.activeVideoMinFrameDuration = CMTimeMake(1, Int32(frameSupportRange.maxFrameRate))
            captureDevice.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 25)
            captureSession.commitConfiguration()
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        self.view.bringSubviewToFront(self.hiddenLabel);
        self.view.bringSubviewToFront(self.labelTitle);
        self.view.bringSubviewToFront(self.info);
                bannerView = GADBannerView(adSize: kGADAdSizeBanner)
                bannerView.adUnitID = "ca-app-pub-2006923484031604/1126410802"
//                bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111" //test ad
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
//        bannerView.frame = CGRect(x: 1,y: 1,width: 1,height: 1)
//        bannerView.backgroundColor = .blue
        addBannerViewToView(bannerView)
        self.view.bringSubviewToFront(bannerView);

    }

    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else  {return}
        let request = VNCoreMLRequest(model: model!) { (finishedReq, err) in
            let array = finishedReq.results
            if(array!.count > 0){
                self.addLayers(array: array!)
            }else{
                self.clearLayers()
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func addLayers(array: [Any?]){
        clearLayers()

        DispatchQueue.main.async {
        for object in array{
            if(((object as! VNRecognizedObjectObservation).labels[0].identifier == "person") && ((object as! VNRecognizedObjectObservation).labels[0].confidence > 0.51)){
                
                let width = self.view.frame.height * (object as AnyObject).boundingBox.width
                let height = self.view.frame.width * (object as AnyObject).boundingBox.height
                let x = self.view.frame.height * (object as AnyObject).boundingBox.minX
                let y = self.view.frame.width * (object as AnyObject).boundingBox.minY
                let tempView = UIView(frame: CGRect(x: y, y: x, width: height, height: width))
                let label = UILabel(frame: CGRect(x: y, y: x, width: height, height: 21))

                if(UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft){
                    label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                    label.bounds = CGRect(x: y, y: x, width: width, height: 21)
                    label.center.x = y + height
                    label.center.y = x + (width/2)

                }
                
                tempView.alpha = 0.3
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont(name:"Courier", size: 17.0)

                if(height < 180 && width < 470){
                    tempView.backgroundColor = .green
                    label.backgroundColor = .green
                    label.text = "Safe!"
                }else{
                    tempView.backgroundColor = .red
                    label.backgroundColor = .red
                    label.text = "Stay back!"
                }
                self.views.append(tempView)
                self.labels.append(label)
            }
        }
        if(self.views.count > 0 && self.views.count == self.labels.count){
            for i in 0...self.views.count-1{
                self.view.addSubview(self.views[i])
                self.view.addSubview(self.labels[i])
            }
        }
        }
    }
    func clearLayers(){
        DispatchQueue.main.async {

        if(self.views.count > 0 && self.views.count == self.labels.count){
            for i in 0...self.views.count-1{
                self.views[i].removeFromSuperview()
                self.labels[i].removeFromSuperview()
            }
            self.views.removeAll()
            self.labels.removeAll()
        }
        }
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

