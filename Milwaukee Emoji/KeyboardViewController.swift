//
//  KeyboardViewController.swift
//  Milwaukee Emoji
//
//  Created by Luke Stevens on 2/1/16.
//  Copyright © 2016 OnMilwaukee. All rights reserved.
//

import UIKit
import Foundation

class KeyboardViewController: UIInputViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    let emojiList : [String] = ["test1", "test2"]
    
    var imagePaths : NSArray!;
    
//    var emojiCollectionView : UICollectionView!;

    @IBOutlet var fullAccessWarningView: UIView!
    @IBOutlet var emojiCollectionView: UICollectionView!
    
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var nextKeyboardButton: UIButton!
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "Keyboard", bundle: nil)
        let objects = nib.instantiateWithOwner(self, options: nil)
        self.view = objects[0] as! UIView;
        
        if(UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard))
        {
            self.fullAccessWarningView.hidden = true
        }
        
        emojiCollectionView.registerNib(UINib.init(nibName: "emojiCell", bundle: nil), forCellWithReuseIdentifier: "theOne")
        
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        self.deleteButton.addTarget(self.textDocumentProxy, action: "deleteBackward", forControlEvents: .TouchUpInside)
        
        imagePaths = NSBundle.mainBundle().pathsForResourcesOfType("png", inDirectory: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        Localytics.integrate("cea1a9fb83fbf112dfc35cc-73b24038-dfe5-11e5-7ef9-0086bc74ca0f")
        
        Localytics.openSession()
        
        print("Session Opened!")

    }
    
    override func viewDidDisappear(animated: Bool) {
        Localytics.closeSession()
        Localytics.upload()
        print("We be dissappearin'!!")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imagePaths.count)
        print(emojiCollectionView.frame.size)
        print(UIScreen.mainScreen().bounds)
        return imagePaths.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : emojiCell =  emojiCollectionView.dequeueReusableCellWithReuseIdentifier("theOne", forIndexPath: indexPath) as! emojiCell
        cell.emojiIMage.contentMode = UIViewContentMode.ScaleAspectFit;
        cell.emojiIMage.image = UIImage(contentsOfFile: imagePaths[indexPath.row] as! String)
        cell.copiedView.layer.cornerRadius = 8
        cell.copiedView.layer.masksToBounds = true
        print(indexPath)
        print("Well at least the method is being called...")
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : emojiCell = emojiCollectionView.cellForItemAtIndexPath(indexPath) as! emojiCell
        UIPasteboard.generalPasteboard().image = UIImage(contentsOfFile: imagePaths[indexPath.row] as! String)
        
        Localytics.tagEvent("Emoji Copied!", attributes: ["File" : imagePaths[indexPath.row].lastPathComponent as String])
        
        UIView.animateWithDuration(0.7, animations: { () -> Void in
            selectedCell.copiedView.hidden = false
            selectedCell.copiedView.alpha = 1;
            }) { (completed) -> Void in
                UIView.animateWithDuration(0.7, delay: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                        selectedCell.copiedView.alpha = 0
                    }, completion: { (completed) -> Void in
                        selectedCell.copiedView.hidden = true
                })
        }
        
        //selectedCell.copiedView.hidden = false
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(54, 51);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 40;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
    }

}
