//
//  MenuVC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class MenuVC: BaseVC, Routable {

    class var routeURLs: [URLPresentable] {
        return ["/swift/menu"]
    }

    var tableView: UITableView!
    var intents: [[String: Intent]] = [
        ["1. Just route" : Intent.pushPop(byUrl: "/swift/demo1")],
        ["2. Route with params" : Intent.pushPop(byUrl: "/swift/demo2/demo2?name=jack&number=33#i_am_fragment")],
        ["3. Intercepter: Reject" : Intent.pushPop(byUrl: "/swift/demo3")],
        ["4. Intercepter: Continue" : Intent.pushPop(byUrl: "/swift/demo4")],
        ["5. Intercepter: Switch" : Intent.pushPop(byUrl: "/swift/demo5")],
        ["6. Intercepter: Login or something need prepare" : Intent.pushPop(byUrl: "/swift/demo6")],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "1")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        navigationItem.title = "Swift Demo"

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Switch", style: .plain, target: self, action: #selector(MenuVC.change))
    }

    @objc func change() {
//        TSTetris.shared().router.driven(byUrl: "/changeDemo")?.post(nil)
//        TSTetris.shared().router.postStream("/changeDemo", params: nil)
        TSTetris.shared().router.postDriven(byUrl: "/changeDemo", params: nil)
    }


}


extension MenuVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "1")!
        cell.textLabel?.text = intents[indexPath.row].keys.first
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let intent = intents[indexPath.row].values.first!.copy() as? Intent
        intent?.onResult
            .subscribe({ (obj) in
                print(obj as Any)
            })

        ts_prepare(intent!, complete: {
            print("---- swift finish route ----")
            })
            .subscribe({ (_) in

            }, error: {
                self.alert(msg: $0.debugDescription)
            })
    }
}