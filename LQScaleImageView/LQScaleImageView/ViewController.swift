//
//  ViewController.swift
//  LQScaleImageView
//
//  Created by NewTV on 2022/3/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let scroll = RBScaleImageView()
        
        scroll.frame = self.view.bounds
        self.view.addSubview(scroll)
        let image = UIImage.init(named: "4.jpg")
        
//        scroll.displayImage(image!)
        // 加载网络图片
        scroll.asyncDisplayImage { (imageView, handle)  in
            
            print("开始加载")
            DispatchQueue.global().async {
                // 异步加载图片
                sleep(2)
                DispatchQueue.main.async {
                    imageView.image = image
                    // 在异步加载完成的方法里调用一下这个闭包
                    handle(image)
                }
            }
        }
        
        scroll.backgroundColor = UIColor.white
    }


}

