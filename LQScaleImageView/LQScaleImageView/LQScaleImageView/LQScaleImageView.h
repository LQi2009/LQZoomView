//
//  LQScaleImageView.h
//  LQScaleImageView
//
//  Created by Qrice on 2017/10/24.
//  Copyright © 2017年 Qrice. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^LQScaleImageHandler)(void);
typedef void(^LQDownloadImageCompleteHandler)(UIImage *__nullable image);
@interface LQScaleImageView : UIView

@property (nonatomic, assign) BOOL doubleTapEnable;
@property (nonatomic, assign) BOOL singleTapEnable;
@property (nonatomic, assign) CGFloat maximumScale;

/// 将视图重置为初始状态
- (void)reset;

/// 展示一个 UIImage
/// @param image UIImage 对象
- (void)displayImage:(UIImage *)image;

/// 异步展示一个Image
/// 需要在合适的时机调用completeHandler回调Image
/// 如果给imageView进行赋值了，image参数可为nil
/// @param handler 异步下载图片回调
- (void)asyncDisplayImage:(void(^)(UIImageView * imageView, LQDownloadImageCompleteHandler completeHandler)) handler ;

- (void)doubleTapAction:(LQScaleImageHandler)handler;
- (void)singleTapAction:(LQScaleImageHandler)handler;

@end

NS_ASSUME_NONNULL_END
