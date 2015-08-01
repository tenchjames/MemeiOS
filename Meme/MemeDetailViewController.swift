//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by James Tench on 7/31/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme?
    // the specific meme to get from the array
    var memeIndex: Int?
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = memeIndex {
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            meme = applicationDelegate.memes[index]
            memeImageView.image = meme?.memedImage
            let deleteIcon = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "confirmDelete")
            self.navigationItem.rightBarButtonItem = deleteIcon
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func confirmDelete() {
        let controller = UIAlertController()
        controller.title = "Delete Meme?"
        controller.message = "Are you sure you want to delete?"
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default) {
            action in self.deleteMeme()
        }
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func deleteMeme() {
        let applicaionDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        if let index = memeIndex {
            applicaionDelegate.memes.removeAtIndex(index)
            // after delete, pop back to table / collection view as image will not be available any longer
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    @IBAction func editMeme(sender: AnyObject) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
        controller.indexOfMemeToEdit = memeIndex
        // when done editing this one meme, pop the user back to the initial view
        self.presentViewController(controller, animated: true) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
