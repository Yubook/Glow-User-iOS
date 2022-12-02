//
//  ZoomImageVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 6/10/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ImageCollCell : ConstrainedCollectionViewCell, UIScrollViewDelegate{
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var scrollView : UIScrollView!
    
    func prepareZoom() {
        let dblTapGesture = UITapGestureRecognizer(target: self, action: #selector(userDoubleTappedScrollview(recognizer:)))
        dblTapGesture.numberOfTapsRequired = 2
        imgView.addGestureRecognizer(dblTapGesture)
    }
    
    @objc func userDoubleTappedScrollview(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
        else {
            let zoomRect = zoomRectForScale(scale: scrollView.maximumZoomScale / 2.0, center: recognizer.location(in: recognizer.view))
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func zoomRectForScale(scale : CGFloat, center : CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        if let imageV = self.imgView {
            zoomRect.size.height = imageV.frame.size.height / scale;
            zoomRect.size.width  = imageV.frame.size.width  / scale;
            let newCenter = imageV.convert(center, from: scrollView)
            zoomRect.origin.x = newCenter.x - ((zoomRect.size.width / 2.0));
            zoomRect.origin.y = newCenter.y - ((zoomRect.size.height / 2.0));
        }
        return zoomRect;
    }
    
}

class ZoomImageVC: ParentViewController {
    
    var arrUrls : [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnCloseTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
}
//MARK:- UICollectionView Delegate & DataSource Methods
extension ZoomImageVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollCell
        cell.imgView.kf.setImage(with: arrUrls[indexPath.row], placeholder: _placeImage)
        cell.prepareZoom()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: _screenSize.width, height: _screenSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

