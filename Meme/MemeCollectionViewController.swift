//
//  MemeCollectionViewController.swift
//  Meme
//
//  Created by James Tench on 7/31/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//

import UIKit

let reuseIdentifier = "collectionViewCell"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        // call this so data refreshes when page appears
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> MemeCollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        
        // Configure the cell
        let currentMeme = memes[indexPath.row]
        cell.memeImageView.image = currentMeme.memedImage
        return cell
    }

    // MARK: UICollectionViewDelegate
    // programatically performing segue to detail view
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetailView") as! MemeDetailViewController
        controller.memeIndex = indexPath.row
        self.navigationController?.pushViewController(controller, animated: true)
    }


    @IBAction func launchMemeEditor(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
