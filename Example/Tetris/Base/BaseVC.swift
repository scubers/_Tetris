//
//  BaseVC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit
import Tetris

class BaseVC: UIViewController, Intentable {

    class func ts_create(by intent: Intent) -> Self {
        return self.init(intent: intent)
    }

    required init(intent: Intent) {
        ts_sourceIntent = intent
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var ts_sourceIntent: Intent


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Swift-\(NSStringFromClass(type(of: self)))"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "back", style: .plain, target: self, action: #selector(BaseVC.back))
        view.backgroundColor = UIColor.lightGray
    }

    @objc func back() {
        ts_finishDisplay()
    }

    func alert(msg: String?, complete: (() -> Void)?) {
        let alert = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Confirm", style: .default, handler: { (action) in
            complete?()
        }))
        present(alert, animated: true, completion: nil)
    }

    func alert(msg: String?) {
        alert(msg: msg, complete: nil)
    }

}
