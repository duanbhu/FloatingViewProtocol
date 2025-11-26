//
//  ViewController.swift
//  FloatingViewProtocol
//
//  Created by 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 on 10/17/2025.
//  Copyright (c) 2025 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. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let floatingView = FloatingView(frame: CGRect(x: 0, y: 100, width: 56, height: 56))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        floatingView.frame = CGRect(x: view.frame.width - 28, y: 100, width: 56, height: 56)
        view.addSubview(floatingView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

