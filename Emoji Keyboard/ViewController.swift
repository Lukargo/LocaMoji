//
//  ViewController.swift
//  Emoji Keyboard
//
//  Created by Luke Stevens on 2/1/16.
//  Copyright © 2016 OnMilwaukee. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionToLogoConstraint: NSLayoutConstraint!
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var emojiCollectionView: UICollectionView!
    var products = [SKProduct]()
    
    let imageNames : [String] = ["Accordian", "Alice Cooper", "Bar Dice", "Beastie", "Bloody Marry with Chaser", "Bratwurst", "Bronze Fonz’s Thumbs", "Cheesehead (Female)", "Cheesehead (Male)", "City Hall", "Fish Fry", "One Mitchell Park Dome", "The Mitchell Park Domes", "Hoan Bridge", "Lake Michigan", "Laverne", "The Milverine", "The Milwaukee Flag", "Old Fashioned", "Rumchata", "Shirley", "Mark di Suervo’s “The Calling”", "Shorts & Melting Snow (Female)", "Shorts & Melting Snow (Male)", "Vel Phillips", "Hot Ham and Rolls", "James Lovell", "Red Lighthouse", "A Shot and a Beer", "Swing Park", "Burke Brise Soleil - Closed", "Burke Brise Soleil - Open", "Duane Hanson's \"Janitor\"", "Dale Chihuly's \"Isola di San Giacomo in Palude Chandelier II\"", "Alex Katz's \"Sunny #4\"", "Art Patrons", "Beach Volleyball Female", "Beach Volleyball Male", "Beer Garden", "Beer In Glass Stein", "Beer In Plastic Cup Stacked", "Beer In Plastic Cup", "Bob Uecker", "Cheese Curds Fried", "Cream Puff", "Custard Cone", "Miller Park Closed", "Miller Park Open", "Tailgating", "Underwear Ride Female", "Underwear Ride Male"]
    
    let summerPack : Set<String> = ["Beach Volleyball Female", "Beach Volleyball Male", "Beer Garden", "Beer In Glass Stein", "Beer In Plastic Cup Stacked", "Beer In Plastic Cup", "Bob Uecker", "Cheese Curds Fried", "Cream Puff", "Custard Cone", "Miller Park Closed", "Miller Park Open", "Tailgating", "Underwear Ride Female", "Underwear Ride Male"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emojiCollectionView.registerNib(UINib.init(nibName: "emojiCollectionCell", bundle: nil), forCellWithReuseIdentifier: "jasonsGallery")
        
        if(NSUserDefaults.init(suiteName: "group.com.onmilwaukee.locamoji")!.boolForKey("theyEnabledFullAccess"))
        {
            instructionsLabel.hidden = true
            //instructionsLabel.frame = CGRectMake(0, 0, 0, 0)
            collectionToLogoConstraint.constant = 0
        }
        //textView.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        products = []
        
        
        
        RageProducts.store.requestProducts{success, products in
            if success {
                self.products = products!
                print("We did it!")
                print(products)
                //self.tableView.reloadData()
            }
            else
            {
                print("No bueno!!")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = imageNames[indexPath.row]
        cell.imageView!.image = UIImage(named: imageNames[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : emojiCollectionCell =  emojiCollectionView.dequeueReusableCellWithReuseIdentifier("jasonsGallery", forIndexPath: indexPath) as! emojiCollectionCell
        print(indexPath.row)
        print("Here we are waiting")
        
        cell.payWall.hidden = true;
        cell.emojiIMage.image = UIImage(named: imageNames[indexPath.row])
        cell.emojiNameLabel.text = imageNames[indexPath.row]
        cell.emojiIMage.alpha = 1
        
        if(summerPack.contains(imageNames[indexPath.row]))
        {
            if(!NSUserDefaults.standardUserDefaults().boolForKey(RageProducts.SummerPack))
            {
                cell.payWall.hidden = false
                cell.emojiIMage.alpha = 0.55
                cell.emojiNameLabel.text = ""
                cell.buyButton.addTarget(self, action: #selector(ViewController.buyButtonClicked(_:)), forControlEvents: .TouchUpInside)
                cell.buyButton.titleLabel?.textAlignment = NSTextAlignment.Center
                cell.buyButton.layer.cornerRadius = 3
                cell.buyButton.clipsToBounds = true
            }
            //cell.emojiNameLabel.text = "Giggle gigle";
        }
        
        return cell;
    }
    
    func buyButtonClicked(sender: AnyObject?)
    {
        print(products)
        RageProducts.store.buyProduct(products[0])
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let itemsToShare = [UIImage(named: imageNames[indexPath.row])!]
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(90, 121);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(5, 15, 5, 15);
//    }


}

