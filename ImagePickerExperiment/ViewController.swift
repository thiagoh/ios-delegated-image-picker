//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Thiago Andrade on 2017-01-14.
//  Copyright © 2017 Thiago Andrade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var imageView: UIImageView!;
  @IBOutlet weak var textField1: UITextField!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);

    subscribeToKeyboardNotifications();

    let memeTextAttributes: [String: Any] = [
      NSStrokeColorAttributeName: UIColor.black,
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
      NSStrokeWidthAttributeName: 1.0]

    textField1.defaultTextAttributes = memeTextAttributes;
    textField1.minimumFontSize = 12.0;
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated);

    unsubscribeFromKeyboardNotifications();
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  func imagePickerController(_ imagePicker: UIImagePickerController,
                             didFinishPickingMediaWithInfo infoArray: [String: Any]) {

    for item in infoArray {
      print(item);
    }

    imagePicker.dismiss(animated: true) {
      if let image = infoArray["UIImagePickerControllerOriginalImage"] as? UIImage {
        self.imageView.image = image;
      }
    };
  }

  func getKeyboardHeight(_ notification: Notification) -> CGFloat {

    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.cgRectValue.height
  }

  func keyboardWillShow(_ notification: Notification) {
    view.frame.origin.y = 0 - getKeyboardHeight(notification)
  }

  func keyboardWillHide(_ notification: Notification) {
    view.frame.origin.y = 0;
  }

  func subscribeToKeyboardNotifications() {

    NotificationCenter.default.addObserver(
                                           self, selector: #selector(keyboardWillShow(_:)),
                                           name: .UIKeyboardWillShow, object: nil)

    NotificationCenter.default.addObserver(
                                           self, selector: #selector(keyboardWillHide(_:)),
                                           name: .UIKeyboardWillHide, object: nil)
  }

  func unsubscribeFromKeyboardNotifications() {

    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }


  @IBAction func pickImage(_ sender: Any) {

    let imagePicker = UIImagePickerController();
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;

    self.present(imagePicker, animated: true, completion: nil);
  }

}

