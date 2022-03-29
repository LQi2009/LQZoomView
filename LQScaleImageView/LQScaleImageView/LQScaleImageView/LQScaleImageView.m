//
//  LQScaleImageView.h
//  LQScaleImageView
//
//  Created by Qrice on 2017/10/24.
//  Copyright © 2017年 Qrice. All rights reserved.
//

#import "LQScaleImageView.h"

@interface LQScaleImageView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *zoomView;
@property (nonatomic, copy) LQScaleImageHandler singleTapHandle;
@property (nonatomic, copy) LQScaleImageHandler doubleTapHandle;
@property (nonatomic, strong) UITapGestureRecognizer *doubleGesture;
@property (nonatomic, strong) UITapGestureRecognizer *singleGesture;
@property (nonatomic, assign) CGFloat suitableScale;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isNeedAutolayout;
@end

@implementation LQScaleImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.doubleTapEnable = YES;
        self.singleTapEnable = YES;
        self.maximumScale = 4.0;
        self.isNeedAutolayout = NO;
        
        [self addGestures];
    }
    return self;
}

- (void) displayImage:(UIImage *)image {
    self.imageSize = image.size;
    self.zoomView.image = image;
    [self layoutZoomView];
}

- (void) asyncDisplayImage:(void(^)(UIImageView * imageView, LQDownloadImageCompleteHandler completeHandler)) handler {
    
    __weak typeof(self) ws = self;
    if (handler) {
        handler(self.zoomView, ^(UIImage *image){
            [ws resetImageSize:image];
        });
    }
}

- (void)reset {
    
    _scrollView.zoomScale = 1.0;
    _scrollView.maximumZoomScale = self.maximumScale;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.contentOffset = CGPointZero;
    _scrollView.contentSize = CGSizeZero;
}

- (void)doubleTapAction:(LQScaleImageHandler)handler {
    self.doubleTapHandle = handler;
}

- (void)singleTapAction:(LQScaleImageHandler)handler {
    self.singleTapHandle = handler;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.backgroundColor = self.backgroundColor;
    self.scrollView.frame = self.bounds;
    self.scrollView.maximumZoomScale = self.maximumScale;
    [self zoomViewToCenter];
    
    if (self.isNeedAutolayout) {
        [self layoutZoomView];
    }
}

- (void) resetImageSize:(UIImage *) image {
    if (image) {
        self.zoomView.image = image;
    }
    
    self.imageSize = self.zoomView.image.size;
    if ([self isFramZero]) {
        self.isNeedAutolayout = YES;
    } else {
        self.isNeedAutolayout = NO;
        [self layoutZoomView];
    }
}

- (void)layoutZoomView {
    [self layoutIfNeeded];
    [self layoutZoomViewFrame];
    [self calculateSuitableScale];
}

- (void)setMaximumScale:(CGFloat)maximumScale {
    _maximumScale = maximumScale;
    self.scrollView.maximumZoomScale = maximumScale;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zoomView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self zoomViewToCenter];
}

- (void)layoutZoomViewFrame {
    
    CGRect zoomFrame = CGRectZero;
    CGFloat zoomViewWidth = self.bounds.size.width;
    CGFloat zoomViewS = zoomViewWidth/self.imageSize.width;
    CGFloat zoomViewHeight = zoomViewS*self.imageSize.height;
    
    CGFloat zoomX = 0;
    CGFloat zoomY = (self.bounds.size.height - zoomViewHeight)/2.0;
    
    if (zoomViewHeight > self.bounds.size.height) {
        zoomViewHeight = self.bounds.size.height;
        zoomViewS = zoomViewHeight/self.imageSize.height;
        zoomViewWidth = self.imageSize.width*zoomViewS;
        zoomY = 0;
        zoomX = (self.bounds.size.width - zoomViewWidth)/2.0;
    }
    
    zoomFrame.size = CGSizeMake(zoomViewWidth, zoomViewHeight);
    zoomFrame.origin = CGPointMake(zoomX, zoomY);
    self.zoomView.frame = zoomFrame;
    
    [_scrollView setZoomScale:1.0 animated:NO];
}

- (void)calculateSuitableScale {
 
    CGSize size = self.zoomView.frame.size;
    CGFloat zoomViewS = 1.0;
    
    if (size.width < self.bounds.size.width) {
        zoomViewS = self.bounds.size.width/size.width;
    } else {
        zoomViewS = self.bounds.size.height/size.height;
    }
    
    self.suitableScale = zoomViewS;
}

- (void)zoomViewToCenter {
 
    CGSize boundSize = self.bounds.size;
    CGRect frameToCenter = self.zoomView.frame;
    
    if (frameToCenter.size.width < boundSize.width) {
        frameToCenter.origin.x = (boundSize.width - frameToCenter.size.width)/2.0;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundSize.height) {
        frameToCenter.origin.y = (boundSize.height - frameToCenter.size.height)/2.0;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    self.zoomView.frame = frameToCenter;
}

#pragma mark - Gestures And Actions
- (void)setDoubleTapEnable:(BOOL)doubleTapEnable {
    _doubleTapEnable = doubleTapEnable;
    if (_doubleGesture) {
        _doubleGesture.enabled = doubleTapEnable;
    }
}

- (void) setSingleTapEnable:(BOOL)singleTapEnable {
    _singleTapEnable = singleTapEnable;
    if (_singleGesture) {
        _singleGesture.enabled = singleTapEnable;
    }
}

- (void)addGestures {
    
    _doubleGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doupleTapGesture:)];
    _doubleGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleGesture];
    
    _singleGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
    [self addGestureRecognizer:_singleGesture];
    
    [_singleGesture requireGestureRecognizerToFail:_doubleGesture];
}

- (void)doupleTapGesture:(UITapGestureRecognizer *)gesture {
    
    if (_scrollView.zoomScale != 1) {
        [_scrollView setZoomScale:1 animated:YES];
    } else {
        [_scrollView setZoomScale:self.suitableScale animated:YES];
    }
    
    if (self.doubleTapHandle) {
        self.doubleTapHandle();
    }
}

- (void)singleTapGesture:(UITapGestureRecognizer *)gesture {
    if (self.singleTapHandle) {
        self.singleTapHandle();
    }
}

- (BOOL) isFramZero {
    
    if (CGRectGetWidth(self.frame) == 0 || CGRectGetHeight(self.frame) == 0) {
        return  YES;
    }
    
    return NO;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1;
//        _scrollView.maximumZoomScale = 4.0;
        _scrollView.bouncesZoom = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.clipsToBounds = YES;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UIImageView *)zoomView {
    
    if (_zoomView == nil) {
        _zoomView = [[UIImageView alloc]init];
        _zoomView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.scrollView addSubview:_zoomView];
    }
    
    return _zoomView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
