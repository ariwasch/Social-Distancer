//
//  Instructions.swift
//  Social Distance Checker
//
//  Created by Ari Wasch on 3/25/20.
//  Copyright © 2020 Ari Wasch. All rights reserved.
//

import UIKit
import GoogleMobileAds
class Instructions: UIViewController {
    
    
    @IBOutlet weak var text: UITextView!
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        bannerView = GADBannerView(adSize: kGADAdSizeLargeBanner)
        bannerView.adUnitID = "ca-app-pub-2006923484031604/2807760775"
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"//test
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
        bannerView.load(GADRequest())
        super.viewDidLoad()

        text.text = "Information \n \nThis simple but useful App uses your iPhone’s camera to alert you when someone is within your six-foot safety zone. If someone is within 6 feet, the box around the person turns red. If the person is more than 6 feet away (approximately 2 meters), the the box around the person turns green. \n\nBest Use \n\nHold the phone horizontally and point the camera at a person. For increased results, tilt your phone 90° to the left (counter clockwise). This app works best with the newest iPhone models. If your phone is old, be careful with the battery drainage."

        self.view.bringSubviewToFront(bannerView);

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
