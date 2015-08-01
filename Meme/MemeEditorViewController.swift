//
//  ViewController.swift
//  Meme
//
//  Created by James Tench on 7/31/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UITextFieldDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    // default text color
    var memeTextColor = UIColor.whiteColor()
    var topText = "TOP"
    var bottomText = "BOTTOM"
    
    // if passed a meme index to edit, use these variables for one time edit
    var indexOfMemeToEdit: Int?
    var memeEditModeFlag = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
        shareButton.enabled = memeImageView.image != nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // if the view was passed a meme index to edit a meme configure the view based on that image
        if let index = indexOfMemeToEdit {
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let meme = applicationDelegate.memes[index]
            topText = meme.topText
            bottomText = meme.bottomText
            memeImageView.image = meme.originalImage
            shareButton.enabled = true
            memeEditModeFlag = true
        }
        
        // custom font with inset stroke to simulate meme font
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40.0)!,
            NSStrokeWidthAttributeName: -3.0,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = topText
        bottomTextField.text = bottomText
        topTextField.delegate = self;
        bottomTextField.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        // we don't want the status bar in this modal view
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // convert meme to upper case text
        var newText = textField.text as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        newText = newText.uppercaseString
        textField.text = newText as String
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // only toggle if bottom text field is the first responder
        // bumps the view up by the height of the keyboard
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // resets the view to initial y location after keyboard is closed
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    func pickAnImage(type: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = type
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageUsingAlbum(sender: AnyObject) {
        let type = UIImagePickerControllerSourceType.PhotoLibrary
        pickAnImage(type)
    }
    @IBAction func pickAnImageUsingCamera(sender: AnyObject) {
        let type = UIImagePickerControllerSourceType.Camera
        pickAnImage(type)
    }
    
    @IBAction func cancelMemeEditor(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func toggleToolBars() {
        topToolbar.hidden = !topToolbar.hidden
        bottomToolbar.hidden = !bottomToolbar.hidden
    }
    
    func generateMemedImage() -> UIImage {
        // hide the toolbar
        toggleToolBars()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // show the tool bar
        toggleToolBars()
        return memedImage
    }
    
    func save() {
        // make a new Meme, if edit flag is set replace that meme with new meme
        // else append a brand new meme to the array
        if let memedImage = memeImageView.image {
            var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text,
                originalImage: memedImage, memedImage: generateMemedImage())
            // if not in edit mode, insert
            if !memeEditModeFlag {
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
            } else {
                // replace the current meme with new meme, then turn off edit mode
                if let index = indexOfMemeToEdit {
                    (UIApplication.sharedApplication().delegate as! AppDelegate).memes[index] = meme
                }
                memeEditModeFlag = !memeEditModeFlag
            }
        }
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.presentViewController(controller, animated: true) {
            self.save()
        }
    }
}














































