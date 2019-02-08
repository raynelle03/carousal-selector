//
//  CarousalSelector.swift
//  Networking_Ray
//
//  Created by Raynelle on 24/01/2019.
//  Copyright © 2019 Raynelle. All rights reserved.
//


import UIKit

struct CarousalItem {
    var image: UIImage = UIImage()
    var title: String = ""
    var backgroundColor: UIColor = .blue
    var borderColor: UIColor = .gray
    var showsBorder: Bool = false
    var canBeEdited: Bool = false
}
protocol CarousalSelectorDelegate: class {
    func carousalSelector(_ selector: CarousalSelector, willRemoveItemAt index: Int)
    func carousalSelectorWillStartEditing(_ selector: CarousalSelector)
    func numberOfItems(in selector: CarousalSelector) -> Int
    func itemForIndex(_ index: Int, in selector: CarousalSelector) -> CarousalItem
    func carousalSelector(_ selector: CarousalSelector, didSelectItemAt index: Int)
}

@IBDesignable class CarousalSelector: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, CAAnimationDelegate {
    var animate = 0
     var arrSelected = [Int]()
     var selectedIndex: Int?
     var view: UIView!
     weak var delegate: CarousalSelectorDelegate?
     var isEditing = false
     var longPress: UILongPressGestureRecognizer!
    @IBOutlet private var viewcollection: UICollectionView!
    @IBOutlet var viewForTransition: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        viewcollection.delegate = self
        viewcollection.dataSource = self
        viewcollection.register(UINib(nibName:"CarousalSelectorCell", bundle: nil), forCellWithReuseIdentifier: "CarousalSelectorCell")
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.delaysTouchesBegan = true
        longPress.delegate = self
        viewcollection.addGestureRecognizer(longPress)
        viewcollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        viewcollection.reloadData()
        viewForTransition.layer.borderWidth = 2.0
        viewForTransition.layer.masksToBounds = false
        viewForTransition.layer.borderColor = UIColor.blue.cgColor
        viewForTransition.layer.cornerRadius = viewForTransition.frame.size.height/2
        viewForTransition.clipsToBounds = true
        viewForTransition.isHidden = true
    }

    func reloadData() {
        viewcollection.reloadData()
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CarousalSelector", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    var tint: UIColor = .black {
        didSet {
            self.view.backgroundColor = tint
           }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfItems(in: self) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = viewcollection.dequeueReusableCell(withReuseIdentifier: "CarousalSelectorCell", for: indexPath) as! CarousalSelectorCell
        guard let item = delegate?.itemForIndex(indexPath.item, in: self) else {
            return cell
        }
        cell.imageView.image = item.image
        cell.setBorderColor(color: item.borderColor)
        cell.imageView.backgroundColor = item.backgroundColor
        cell.lblTitle.text = item.title
        cell.deleteButton.isHidden = true
        cell.setUnselectedOrange()
        if item.showsBorder {
            cell.setBorderColor(color: item.borderColor)
        } else {
            cell.setUnselectedBlue()
        }
        if selectedIndex == indexPath.row && !isEditing {
                cell.animateOncell = animate
                cell.setSelectedOrange()
                let frame = viewcollection.convert((cell.frame), to: self.view)
                arrSelected.append(Int(frame.origin.x - 5))
            } else {
                cell.setUnselectedOrange()
        }
        cell.itemSelectedButton.addTarget(self, action: #selector(self.itemselected(_:)), for: UIControl.Event.touchUpInside)
        cell.itemSelectedButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(self.deleteSelectedCard(_:)), for: UIControl.Event.touchUpInside)
        cell.deleteButton.tag = indexPath.row
        if isEditing && item.canBeEdited {
            cell.deleteButton.isHidden = false
            if cell.contentView.layer.animation(forKey: "transform") == nil {
                cell.shakeEffect(view: cell.contentView)
            }
        } else {
            cell.deleteButton.isHidden = true
            cell.contentView.layer.removeAllAnimations()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt selected Item \(indexPath.item)")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 150.0)
    }

    @objc func itemselected(_ sender: UIButton) {
        if isEditing {
            return
        }
        if selectedIndex == sender.tag {
            return
        }
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = viewcollection.cellForItem(at: indexPath) as? CarousalSelectorCell
        let frame = viewcollection.convert((cell?.frame)!, to: self.view)
        arrSelected.append(Int(frame.origin.x - 5))
        selectedIndex = sender.tag
        animate = 1
        delegate?.carousalSelector(self, didSelectItemAt: indexPath.row)
        animateWhenSelected()
    }

    func animateWhenSelected() {
        if arrSelected.count > 0 {
            viewForTransition.isHidden = false
            viewForTransition.transform = CGAffineTransform(translationX: 0, y: 0)
            if  arrSelected.count > 1 {
                viewForTransition.transform = CGAffineTransform(translationX: CGFloat(arrSelected[arrSelected.count - 2]), y: 0)
            }
            viewForTransition.layer.shadowColor = UIColor.black.cgColor
            viewForTransition.layer.shadowOffset = CGSize(width: 10, height: 10)
            viewForTransition.alpha = 0
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(self.stoppedAnimating))
            UIView.setAnimationDuration(0.5)
            viewForTransition.transform = CGAffineTransform(translationX: CGFloat(arrSelected[arrSelected.count - 1] + 10), y: 0)
            viewForTransition.alpha = 1
            viewForTransition.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
         viewcollection.reloadData()
    }

    @objc func stoppedAnimating() {
        print("stopped animating")
        viewForTransition.isHidden = true
        animate = 0
    }

    @objc func deleteSelectedCard(_ sender: UIButton) {
        print("DElete Selected Item \(sender.tag)")
        delegate?.carousalSelector(self, willRemoveItemAt: sender.tag)
    }

   @objc func handleLongPress (_ gestureReconizer: UILongPressGestureRecognizer) {
        isEditing = true
        let p = gestureReconizer.location(in: viewcollection)
        guard let indexPath = viewcollection.indexPathForItem(at: p),
         let item = delegate?.itemForIndex(indexPath.row, in: self) else {
            isEditing = false
            return
        }

    if !item.canBeEdited {
            isEditing = false
            return
        }
        delegate?.carousalSelectorWillStartEditing(self)

        self.reloadData()
    }
}
