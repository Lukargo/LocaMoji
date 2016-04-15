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
    
    let numberStrings : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "/", ":", ";", "(", ")", "$", "&", "@", ",", ".", "#", "!", "=", "%", "?" ]
    
    let charStrings : [String] = ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m"]
    
    var imagePaths : NSArray!;
    
    var singleCharButtons : NSArray!
    
    let normalHeight : CGFloat = 230.0
    let expandedHeight : CGFloat = 230.0
    var heightContraint : NSLayoutConstraint = NSLayoutConstraint()
    var normalHeightConstraint : NSLayoutConstraint = NSLayoutConstraint()
//    var emojiCollectionView : UICollectionView!;

    @IBOutlet var shiftButton: UIButton!
    @IBOutlet var viewSwitcherButton: UIButton!
    @IBOutlet var keyHolderView: UIView!
    @IBAction func handleKeyPress(sender: UIButton) {
        
        if(sender.tag == 50)
        {
            for view in self.singleCharButtons
            {

                var button = view as! UIButton
                var buttonText = button.titleLabel!.text
                if(buttonText == buttonText?.lowercaseString)
                {
                    buttonText = buttonText?.uppercaseString
                    button.setTitle(buttonText, forState: UIControlState.Normal)
                    self.shiftButton.setImage(UIImage(named: "shift-132-black"), forState: UIControlState.Normal)
                    
                }
                else
                {
                    buttonText = buttonText?.lowercaseString
                    button.setTitle(buttonText, forState: UIControlState.Normal)
                    self.shiftButton.setImage(UIImage(named: "shift-132-outline-black"), forState: UIControlState.Normal)
                }
                
            }

        }
        else if(sender.tag == 28)
        {
            self.shiftButton.setImage(UIImage(named: "shift-132-outline-black"), forState: UIControlState.Normal)
            
            var swappingToNumbers = (self.singleCharButtons.firstObject?.titleLabel!!.text?.caseInsensitiveCompare(self.charStrings[0]) == NSComparisonResult.OrderedSame) ? true : false
            
            if (swappingToNumbers)
            {
                sender.setTitle("ABC", forState: UIControlState.Normal)
            }
            
            for (index, view) in self.singleCharButtons.enumerate()
            {
                print(index)
                print(self.singleCharButtons.count)
                print(self.charStrings[0])
                if(swappingToNumbers)
                {
                    view.setTitle(self.numberStrings[view.tag], forState: UIControlState.Normal)
                }
                else
                {
                    view.setTitle(self.charStrings[view.tag], forState: UIControlState.Normal)
                }
            }
        }
        else if(sender.tag == 29)
        {
            self.textDocumentProxy.insertText(" ")
        }
        else if(sender.tag == 30)
        {
            self.textDocumentProxy.insertText("\n")
        }
        else if(sender.tag == 27)
        {
            self.textDocumentProxy.deleteBackward()
        }
        else
        {
            self.textDocumentProxy.insertText(sender.titleLabel!.text!)

        }
        
    }
    @IBAction func emojiToTextViewSwap(sender: AnyObject) {
        if(self.keyHolderView.hidden)
        {
            self.keyHolderView.hidden = false
            self.viewSwitcherButton.setImage(UIImage(named: "locamoji-132-white"), forState: UIControlState.Normal)
            self.fullAccessWarningView.hidden = true
            Localytics.tagEvent("Someone actually used the text keyboard!")

        }
        else
        {
            self.keyHolderView.hidden = true
            self.viewSwitcherButton.setImage(UIImage(named: "keyboard-132-white"), forState: UIControlState.Normal)
            if(UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard))
            {
                self.fullAccessWarningView.hidden = true
            }
            else
            {
                self.fullAccessWarningView.hidden = false
            }

        }
        
    }
    @IBOutlet var mainView: UIView!
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
        
        self.heightContraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: expandedHeight)
        
        self.normalHeightConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0.0, constant: normalHeight)
        
        self.singleCharButtons = self.keyHolderView.subviews.filter({ (view) -> Bool in
            if(view.isKindOfClass(UIButton))
            {
                let button = view as! UIButton
                let buttonText = button.titleLabel!.text
                if (buttonText != nil && buttonText!.characters.count == 1)
                {
                    return true
                }
            }
                return false
        })
        
        self.keyHolderView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        Localytics.integrate("cea1a9fb83fbf112dfc35cc-73b24038-dfe5-11e5-7ef9-0086bc74ca0f")
        
        Localytics.openSession()
        
        print("Session Opened!")

    }
    
    override func viewWillAppear(animated: Bool) {
        if(UIScreen.mainScreen().bounds.size.width > UIScreen.mainScreen().bounds.size.height){
            self.mainView.addConstraint(heightContraint)
            
        }
        else
        {
            self.mainView.addConstraint(normalHeightConstraint)
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if(toInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft || toInterfaceOrientation == UIInterfaceOrientation.LandscapeRight)
        {
                    self.mainView.removeConstraint(normalHeightConstraint)
                    self.mainView.addConstraint(heightContraint)
        }
        else
        {
                    self.mainView.removeConstraint(heightContraint)
                    self.mainView.addConstraint(normalHeightConstraint)
            
        }
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
        return CGSizeMake(44, 44);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 15, 5, 15);
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
