//
//  ViewController.swift
//  LQzoomView
//
//  Created by Artron_LQQ on 2017/10/17.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let scroll = LQPhotoScrollView()
        let scroll = LQPhotoZoomView()
//        let scroll = LQPhotoPreviewCell()
        
        scroll.frame = self.view.bounds
        self.view.addSubview(scroll)
        let image = UIImage.init(named: "4.jpg")
        
//        scroll.displayImage(image!)
        // 加载网络图片
        scroll.displayWeburl { (imageView, handle)  in
            
            print("开始加载")
            DispatchQueue.global().async {
                // 异步加载图片
                sleep(2)
                DispatchQueue.main.async {
                    imageView.image = image
                    // 在异步加载完成的方法里调用一下这个闭包
                    handle()
                }
                
//                non-escaping 
            }
        }
        
        scroll.backgroundColor = UIColor.white
//        scroll.contentSize = (image?.size)!
//        print(scroll.contentSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

