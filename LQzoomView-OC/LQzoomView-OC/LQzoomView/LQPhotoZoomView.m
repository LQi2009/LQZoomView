//
//  LQPhotoZoomView.m
//  LQzoomView-OC
//
//  Created by Artron_LQQ on 2017/10/24.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "LQPhotoZoomView.h"

@interface LQPhotoZoomView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *zoomView;
@property (nonatomic, copy) LQPhotoZoomViewHandle singleTapHandle;
@property (nonatomic, copy) LQPhotoZoomViewHandle doubleTapHandle;
@property (nonatomic, assign) CGFloat suitableScale;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LQPhotoZoomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.isDoubleTapEnable = YES;
        self.isSingleTapEnable = YES;
        self.maximumScale = 4.0;
        
        [self.scrollView addSubview:self.zoomView];
    }
    return self;
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
        UIImageView *img = [[UIImageView alloc]init];
        img.contentMode = UIViewContentModeScaleAspectFit;
        
        _zoomView = img;
    }
    
    return _zoomView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.backgroundColor = self.backgroundColor;
    self.scrollView.frame = self.bounds;
    self.scrollView.maximumZoomScale = self.maximumScale;
    [self zoomViewToCenter];
    [self addGestures];
}

- (void)displayImage:(UIImage *)image {
    
    self.imageSize = image.size;
    self.zoomView.image = image;
    
    [self layoutZoomView];
}


- (void)displayWebImage:(void(^)(UIImageView * imageView, LQPhotoZoomViewHandle showImageBlock))block {
    
    if (block) {
//        block(self.zoomView, showImageBlock{
//
//        });
        block(self.zoomView, ^(){
            
            
        });
    }
}

- (void)layoutZoomView {
    [self layoutZoomViewFrame];
    [self calculateSuitableScale];
}

- (void)setMaximumScale:(CGFloat)maximumScale {
    _maximumScale = maximumScale;
    self.scrollView.maximumZoomScale = maximumScale;
}

- (void)reset {
    
    _scrollView.zoomScale = 1.0;
    _scrollView.maximumZoomScale = self.maximumScale;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.contentOffset = CGPointZero;
    _scrollView.contentSize = CGSizeZero;
}

- (void)doubleTapAction:(LQPhotoZoomViewHandle)handle {
    self.doubleTapHandle = handle;
}

- (void)singleTapAction:(LQPhotoZoomViewHandle)handle {
    self.singleTapHandle = handle;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self zoomViewToCenter];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zoomView;
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
    
    if (size.width < size.height) {
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
- (void)addGestures {
    
    UITapGestureRecognizer *doubleTap;
    UITapGestureRecognizer *singleTap;
    
    for (UITapGestureRecognizer* gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }
    
    if (self.isDoubleTapEnable) {
        doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doupleTapGesture:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    
    if (self.isSingleTapEnable) {
        singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapGesture:)];
        [self addGestureRecognizer:singleTap];
    }
    
    if (_isDoubleTapEnable && _isSingleTapEnable) {
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
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

















/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
