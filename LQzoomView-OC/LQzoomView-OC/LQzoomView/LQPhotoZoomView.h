//
//  LQPhotoZoomView.h
//  LQzoomView-OC
//
//  Created by Artron_LQQ on 2017/10/24.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LQPhotoZoomViewHandle)(void);
@interface LQPhotoZoomView : UIView


@property (nonatomic, assign) BOOL isDoubleTapEnable;
@property (nonatomic, assign) BOOL isSingleTapEnable;
@property (nonatomic, assign) CGFloat maximumScale;

- (void)reset;
- (void)displayImage:(UIImage *)image;
- (void)displayWebImage:(void(^)(UIImageView * imageView, LQPhotoZoomViewHandle showImageBlock))block;
- (void)doubleTapAction:(LQPhotoZoomViewHandle)handle;
- (void)singleTapAction:(LQPhotoZoomViewHandle)handle;


















@end
