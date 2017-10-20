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
        
        scroll.displayImage(image!)
        
        scroll.backgroundColor = UIColor.white
//        scroll.contentSize = (image?.size)!
//        print(scroll.contentSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

