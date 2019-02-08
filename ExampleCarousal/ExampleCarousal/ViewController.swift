//
//  ViewController.swift
//  ExampleCarousal
//
//  Created by Raynelle on 08/02/2019.
//  Copyright © 2019 Raynelle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var arrPlayers: [Player]!
    @IBOutlet var playersSelector: CarousalSelector!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         arrPlayers = [
            Player(name: "test1", image: "test.png", club: "abc", height: "5.8", rank: "3" ),
            Player(name: "test2", image: "test.png", club: "abc", height: "5.8", rank: "3" ),
            Player(name: "test3", image: "test.png", club: "abc", height: "5.8", rank: "3" ),
            Player(name: "test4", image: "test.png", club: "abc", height: "5.8", rank: "3" ),
            Player(name: "test5", image: "test.png", club: "abc", height: "5.8", rank: "3" ),
            Player(name: "test6", image: "test.png", club: "abc", height: "5.8", rank: "3" )
        ]
        playersSelector.delegate = self
        playersSelector.reloadData()
    }
}

extension ViewController: CarousalSelectorDelegate {
    func numberOfItems(in selector: CarousalSelector) -> Int {
        return arrPlayers.count
    }

    func itemForIndex(_ index: Int, in selector: CarousalSelector) -> CarousalItem {
        var item = CarousalItem()
        item.backgroundColor = .gray
        item.title = arrPlayers[index].name
        item.canBeEdited = true
        item.showsBorder = true
        return item
    }

    func carousalSelector(_ selector: CarousalSelector, willRemoveItemAt index: Int) {

    }

    func carousalSelectorWillStartEditing(_ selector: CarousalSelector) {

    }

    func carousalSelector(_ selector: CarousalSelector, didSelectItemAt index: Int) {

    }

    
}
