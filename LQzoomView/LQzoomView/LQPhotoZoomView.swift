//
//  LQPhotoZoomView.swift
//  LQzoomView
//
//  Created by Artron_LQQ on 2017/10/17.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

typealias LQPhotoZoomViewHandle = () -> Void
class LQPhotoZoomView: UIView {

    var maximumZoomScale: CGFloat = 4.0
    var isDoubleTapEnable: Bool = true
    var isSingleTapEnable: Bool = true
    
    private var singleTapHandle: LQPhotoZoomViewHandle?
    private var doubleTapHandle: LQPhotoZoomViewHandle?
    private var suitableScale: CGFloat = 1.0
    private var imageSize: CGSize = .zero
    private lazy var zoomView: UIImageView = {
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    private lazy var scrollView: UIScrollView = {
        
        let scroll = UIScrollView()
        
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.minimumZoomScale = 1
        scroll.bouncesZoom = true
        scroll.scrollsToTop = false
        scroll.decelerationRate = UIScrollViewDecelerationRateFast
        scroll.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scroll.delegate = self
        scroll.clipsToBounds = true
        self.addSubview(scroll)
        return scroll
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.addSubview(zoomView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.backgroundColor = self.backgroundColor
        scrollView.frame = self.bounds
        scrollView.maximumZoomScale = maximumZoomScale
        zoomViewToCenter()
        addGestureRecognizer()
    }
    
    func displayImage(_ image: UIImage) {
        
        imageSize = image.size
        zoomView.image = image
        layoutZoomView()
    }
    
    func displayWeburl(_ handle: (_ imageView: UIImageView) -> Void ) {
        
        handle(zoomView)
    }
    
    func layoutZoomView() {
        
        layoutZoomViewFrame()
        calculateSuitableScale()
    }
    
    func reset() {
        
        scrollView.zoomScale = 1.0
        scrollView.maximumZoomScale = maximumZoomScale
        scrollView.minimumZoomScale = 1.0
        scrollView.contentOffset = .zero
        scrollView.contentSize = .zero
    }
    
    @discardableResult
    func doubleTapAction(_ handle: @escaping LQPhotoZoomViewHandle) -> LQPhotoZoomView {
        doubleTapHandle = handle
        return self
    }
    
    @discardableResult
    func singleTapAction(_ handle: @escaping LQPhotoZoomViewHandle) -> LQPhotoZoomView {
        singleTapHandle = handle
        return self
    }
}

//MARK: - UIScrollViewDelegate
extension LQPhotoZoomView: UIScrollViewDelegate {
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.zoomViewToCenter()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return zoomView
    }
}

//MARK: - private methods
private extension LQPhotoZoomView {
    
    func layoutZoomViewFrame() {
        
        var zoomFrame: CGRect = .zero
        var zoomViewWidth = self.bounds.width
        var zoomViewS = zoomViewWidth/imageSize.width
        var zoomViewHeight = zoomViewS*imageSize.height
        
        var zoomX: CGFloat = 0
        var zoomY: CGFloat = (self.bounds.height - zoomViewHeight)/2.0
        
        if zoomViewHeight > self.bounds.height {
            zoomViewHeight = self.bounds.height
            zoomViewS = zoomViewHeight/imageSize.height
            zoomViewWidth = imageSize.width*zoomViewS
            zoomY = 0
            zoomX = (self.bounds.width - zoomViewWidth)/2.0
        }
        
        zoomFrame.size = CGSize(width: zoomViewWidth, height: zoomViewHeight)
        zoomFrame.origin = CGPoint(x: zoomX, y: zoomY)
        zoomView.frame = zoomFrame
        
        scrollView.setZoomScale(1.0, animated: false)
    }
    
    func calculateSuitableScale() {
        
        let size = zoomView.frame.size
        var zoomViewS: CGFloat = 1.0
        if size.width < size.height {
            zoomViewS = self.bounds.width/size.width
        } else {
            zoomViewS = self.bounds.height/size.height
        }
        
        suitableScale = zoomViewS
    }
    
    func zoomViewToCenter() {
        
        let boundSize = self.bounds.size
        var frameToCenter = self.zoomView.frame
        
        if frameToCenter.width < boundSize.width {
            frameToCenter.origin.x = (boundSize.width - frameToCenter.width)/2.0
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.height < boundSize.height {
            frameToCenter.origin.y = (boundSize.height - frameToCenter.height)/2.0
        } else {
            frameToCenter.origin.y = 0
        }
        
        self.zoomView.frame = frameToCenter
    }

    //MARK: - 添加手势
    func addGestureRecognizer() {
        
        var doubleTap: UITapGestureRecognizer?
        var singleTap: UITapGestureRecognizer?
        
        if isDoubleTapEnable {
            doubleTap = UITapGestureRecognizer(target: self, action: #selector(doupleTapGesture))
            doubleTap?.numberOfTapsRequired = 2
            self.addGestureRecognizer(doubleTap!)
        }
        
        if isSingleTapEnable {
            singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapGesture))
            self.addGestureRecognizer(singleTap!)
        }
        
        if isDoubleTapEnable && isSingleTapEnable {
            // 避免单双击冲突
            singleTap?.require(toFail: doubleTap!)
        }
    }
    
    @objc func doupleTapGesture(_ gesture: UITapGestureRecognizer) {
        
        if scrollView.zoomScale != 1 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            scrollView.setZoomScale(suitableScale, animated: true)
        }
        
        if let handle = doubleTapHandle {
            handle()
        }
    }
    
    @objc func singleTapGesture( _ gesture: UITapGestureRecognizer) {
        if let handle = singleTapHandle {
            handle()
        }
    }
}
