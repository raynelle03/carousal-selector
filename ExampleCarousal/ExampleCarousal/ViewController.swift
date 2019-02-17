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

    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblClub: UILabel!
    @IBOutlet var lblHeight: UILabel!
    @IBOutlet var lblRank: UILabel!
    @IBOutlet var imgViewPlayer: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         arrPlayers = [
            Player(name: "Ronaldo", iconimage: "ronaldo.png", image:"ronaldoWall.jpg",  club: "Juventus", height: "1.87 m", desp: "Cristiano Ronaldo dos Santos Aveiro GOIH ComM is a Portuguese professional footballer who plays as a forward for Italian club Juventus and captains the Portugal national team." ),
            Player(name: "Messi", iconimage: "messi.png", image:"messiWall.jpg", club: "Barcelona", height: "1.7 m", desp: "Lionel Andrés Messi Cuccittini is an Argentine professional footballer who plays as a forward and captains both Spanish club Barcelona and the Argentina national team." ),
            Player(name: "Pogba", iconimage: "pogba.png", image:"pogbaWall.png", club: "Manchester United", height: "1.91 m", desp: "Paul Labile Pogba is a French professional footballer who plays for Premier League club Manchester United and the French national team." ),
            Player(name: "Suarez", iconimage: "suarez.png", image:"suarezWall.jpg", club: "Barcelona", height: "1.82 m", desp: "Luis Alberto Suárez Díaz is a Uruguayan professional footballer who plays as a striker for Spanish club Barcelona and the Uruguay national team." ),
            Player(name: "Fabregas", iconimage: "fabregas.png", image:"fabregasWall.jpg", club: "Ligue 1", height: "1.8 m", desp: "Francesc 'Cesc' Fàbregas Soler is a Spanish professional footballer who plays as a central midfielder for Ligue 1 club Monaco and the Spain national team." ),
            Player(name: "Neymar", iconimage: "neymar.png", image:"neymarWall.jpg", club: "Paris Saint-Germain", height: "1.75 m", desp: "Neymar da Silva Santos Júnior, commonly known as Neymar Jr. or simply Neymar, is a Brazilian professional footballer who plays as a forward for French club Paris Saint-Germain and the Brazil national team." )
        ]
        playersSelector.delegate = self
        playersSelector.reloadData()
        displayData(index: 0)
    }

    func displayData(index: Int) {
        lblName.text = arrPlayers[index].name.uppercased()
        lblClub.text = "Club: \(arrPlayers[index].club)"
        lblHeight.text = "Height: \(arrPlayers[index].height)"
        lblRank.text = "Rank: \(arrPlayers[index].desp)"
        imgViewPlayer.image = UIImage(named:"\(arrPlayers[index].image)")!
    
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
        item.image = UIImage(named:"\(arrPlayers[index].iconimage)")!
        item.canBeEdited = true
        item.showsBorder = true
        return item
    }

    func carousalSelector(_ selector: CarousalSelector, willRemoveItemAt index: Int) {

    }

    func carousalSelectorWillStartEditing(_ selector: CarousalSelector) {

    }

    func carousalSelector(_ selector: CarousalSelector, didSelectItemAt index: Int) {
          displayData(index: index)
    }

    
}
