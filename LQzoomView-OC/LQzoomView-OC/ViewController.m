//
//  ViewController.m
//  LQzoomView-OC
//
//  Created by Artron_LQQ on 2017/10/24.
//  Copyright © 2017年 Artup. All rights reserved.
//

#import "ViewController.h"
#import "LQPhotoZoomView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LQPhotoZoomView *scroll = [[LQPhotoZoomView alloc]init];
    scroll.frame = self.view.bounds;
    [self.view addSubview:scroll];
    
    UIImage *img = [UIImage imageNamed:@"4.jpg"];
//    [scroll displayImage:img];
    [scroll displayWebImage:^(UIImageView *imageView, LQPhotoZoomViewHandle showImageBlock) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            sleep(2);
            imageView.image = img;
            dispatch_queue_t main = dispatch_get_main_queue();
            dispatch_async(main, ^{
                showImageBlock();
            });
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
