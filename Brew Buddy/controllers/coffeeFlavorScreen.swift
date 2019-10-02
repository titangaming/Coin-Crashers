//
//  coffeeFlavorScreen.swift
//  Brew Buddy
//
//  Created by Alex Cevicelow on 3/21/19.
//  Copyright © 2019 Alex Cevicelow. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase


class coffeeFlavorScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    //link for collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    //array for types of coffee
    let coffeeNames = ["one", "two", "three", "Four"]
    
    //array of images of coffee
    let coffeeImages: [UIImage] = [
    UIImage(named: "coffeMaker")!,
    UIImage(named: "coffeMaker")!,
    UIImage(named: "coffeMaker")!,
    UIImage(named: "coffeMaker")!,
    ]
    

    //start view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.height/3)
        

        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coffeeNames.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        cell.coffeeName.text = coffeeNames[indexPath.item]
        cell.coffeeImage.image = coffeeImages[indexPath.item]
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        print(indexPath.item)
    }
   
    

 

}
