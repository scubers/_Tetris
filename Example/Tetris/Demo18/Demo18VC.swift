//
//  Demo18VC.swift
//  Tetris_Example
//
//  Created by Junren Wong on 2019/4/10.
//  Copyright © 2019 wangjunren. All rights reserved.
//

import UIKit

class Demo18VC: BaseVC, Routable {
    
    class var routeURLs: [URLPresentable] {
        return ["/demo18"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 强制置空
        ts_sourceIntent?.displayer = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ts_finishDisplay()
    }

}
