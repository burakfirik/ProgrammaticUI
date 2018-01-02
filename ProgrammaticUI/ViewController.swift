//
//  ViewController.swift
//  ProgrammaticUI
//
//  Created by Burak Firik on 1/2/18.
//  Copyright © 2018 Burak Firik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
  
  
  
  var image: UIImage!
  var imageView: UIImageView!
  var num1TextField: UITextField!
  var num2TextField: UITextField!
  var sumLabel: UILabel!
  var sumButton: UIButton!
  var squareView: UIView!
  var pinchGesture: UIPinchGestureRecognizer!
  var panGesture : UIPanGestureRecognizer!
  var swipeGesture : UISwipeGestureRecognizer!
  var gestureView: UIView!
  var rotateGesture  = UIRotationGestureRecognizer()
  var lastRotation   = CGFloat()
  var longGesture = UILongPressGestureRecognizer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createBottomSquare()
    createUIViews()
    editViews()
    addViews()
    setupGestures()
    
    
    
  }
  
  func setupGestures() {
    let singleTap = UITapGestureRecognizer(target: self, action:#selector(handleSingleTap(sender:)))
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
    let twoFingerTap = UITapGestureRecognizer(target: self, action: #selector(twoFingerTap(sender:)))
    
    
    doubleTap.numberOfTapsRequired = 2
    twoFingerTap.numberOfTouchesRequired = 2
    singleTap.delegate = self
    doubleTap.delegate = self
    gestureView.addGestureRecognizer(singleTap)
    gestureView.addGestureRecognizer(doubleTap)
    gestureView.addGestureRecognizer(twoFingerTap)
    
    pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinchedView))
    gestureView.isUserInteractionEnabled = true
    gestureView.addGestureRecognizer(pinchGesture)
    
    self.panGesture  = UIPanGestureRecognizer(target: self, action: #selector(ViewController.draggedView(_:)))
    
    gestureView.isUserInteractionEnabled = true
    
    // To Add Pan Gesture
    gestureView.addGestureRecognizer(panGesture)
    
    let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .right, .left]
    
    
    //    for direction in directions {
    //      swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipwView(_:)))
    //      gestureView.addGestureRecognizer(swipeGesture)
    //      swipeGesture.direction = direction
    //      gestureView.isUserInteractionEnabled = true
    //      gestureView.isMultipleTouchEnabled = true
    //    }
    
    
    rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.rotatedView(_:)))
    gestureView.addGestureRecognizer(rotateGesture)
    gestureView.isUserInteractionEnabled = true
    gestureView.isMultipleTouchEnabled = true
    
    
    longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(_:)))
    longGesture.minimumPressDuration = 1
    gestureView.addGestureRecognizer(longGesture)
  }
  
  
  @objc func swipwView(_ sender : UISwipeGestureRecognizer){
    UIView.animate(withDuration: 1.0) {
      if sender.direction == .right {
        self.gestureView.frame = CGRect(x: self.view.frame.size.width - self.gestureView.frame.size.width, y: self.gestureView.frame.origin.y , width: self.gestureView.frame.size.width, height: self.gestureView.frame.size.height)
      }else if sender.direction == .left{
        self.gestureView.frame = CGRect(x: 0, y: self.gestureView.frame.origin.y , width: self.gestureView.frame.size.width, height: self.gestureView.frame.size.height)
        
      }else if sender.direction == .up{
        self.gestureView.frame = CGRect(x: self.view.frame.size.width - self.gestureView.frame.size.width, y: 0 , width: self.gestureView.frame.size.width, height: self.gestureView.frame.size.height)
      }else if sender.direction == .down{
        self.gestureView.frame = CGRect(x: self.view.frame.size.width - self.gestureView.frame.size.width, y: self.view.frame.size.height - self.gestureView.frame.height , width: self.gestureView.frame.size.width, height: self.gestureView.frame.size.height)
      }
      self.gestureView.layoutIfNeeded()
      self.gestureView.setNeedsDisplay()
    }
  }
  
  
  @objc  func pinchedView(sender:UIPinchGestureRecognizer){
    self.view.bringSubview(toFront: gestureView)
    sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
    sender.scale = 1.0
  }
  
  @objc func draggedView(_ sender:UIPanGestureRecognizer){
    self.view.bringSubview(toFront: gestureView)
    let translation = sender.translation(in: self.view)
    gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
    sender.setTranslation(CGPoint.zero, in: self.view)
  }
  
  @objc func rotatedView(_ sender : UIRotationGestureRecognizer){
    var lastRotation = CGFloat()
    self.view.bringSubview(toFront: gestureView)
    if(sender.state == UIGestureRecognizerState.ended){
      lastRotation = 0.0;
    }
    let rotation = 0.0 - (lastRotation - sender.rotation)
    // var point = rotateGesture.location(in: viewRotate)
    let currentTrans = sender.view?.transform
    let newTrans = currentTrans!.rotated(by: rotation)
    sender.view?.transform = newTrans
    lastRotation = sender.rotation
  }
  
  @objc func longPress(_ sender: UILongPressGestureRecognizer) {
    let alertC = UIAlertController(title: "Long Press", message: "Long press gesture called when you press on view of 1 second duration.", preferredStyle: UIAlertControllerStyle.alert)
    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (alert) in
    }
    alertC.addAction(ok)
    self.present(alertC, animated: true, completion: nil)
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    squareView.frame = CGRect(x: size.width - 40, y: size.height - 40, width: 40, height: 40)
  }
  
  func createBottomSquare() {
    self.squareView = UIView(frame:CGRect(x: self.view.frame.maxX - 40, y: self.view.frame.maxY - 40, width: 40, height: 40) )
    squareView.backgroundColor = UIColor.brown
  }
  
  // MARK:- ---> CreateUIViews
  func createUIViews() {
    self.num1TextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    self.num2TextField =  UITextField(frame: CGRect(x: 20, y: 150, width: 300, height: 40))
    self.sumLabel = UILabel(frame:CGRect(x: 20, y: 200, width: 300, height: 40) )
    self.sumButton = UIButton(frame:CGRect(x: 20, y: 250, width: 300, height: 40) )
    //sumButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
    gestureView = UIView(frame:CGRect(x: 20, y: 300, width: 270, height: 190) )
    gestureView.backgroundColor = UIColor.gray
    image = UIImage(named: "poke")
    imageView = UIImageView(image: image)
    
  }
  
  // MARK:- ---> EditViews
  func editViews() {
    num1TextField.placeholder = "Number1"
    num1TextField.font = UIFont.systemFont(ofSize: 15)
    num1TextField.borderStyle = UITextBorderStyle.roundedRect
    num1TextField.autocorrectionType = UITextAutocorrectionType.no
    num1TextField.keyboardType = UIKeyboardType.default
    num1TextField.returnKeyType = UIReturnKeyType.done
    num1TextField.clearButtonMode = UITextFieldViewMode.whileEditing;
    num1TextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    num1TextField.tag = 0
    num1TextField.delegate = self
    
    num2TextField.placeholder = "Number2"
    num2TextField.tag = 1
    num2TextField.font = UIFont.systemFont(ofSize: 15)
    num2TextField.borderStyle = UITextBorderStyle.roundedRect
    num2TextField.autocorrectionType = UITextAutocorrectionType.no
    num2TextField.keyboardType = UIKeyboardType.default
    num2TextField.returnKeyType = UIReturnKeyType.done
    num2TextField.clearButtonMode = UITextFieldViewMode.whileEditing;
    num2TextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
    num2TextField.delegate = self
    
    sumLabel.text = "Result"
    sumLabel.font = UIFont(name: "MarkerFelt-Thin", size: 25)
    sumLabel.textColor = UIColor.red
    sumLabel.textAlignment = .center
    sumLabel.numberOfLines = 5
    
    sumButton.setTitle("+", for: .normal)
    sumButton.setTitleColor(UIColor.blue, for: .normal)
    sumButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
    
  }
  
  func addViews() {
    self.view.addSubview(num1TextField)
    self.view.addSubview(num2TextField)
    self.view.addSubview(sumLabel)
    self.view.addSubview(sumButton)
    self.view.addSubview(squareView)
    gestureView.addSubview(imageView)
    self.view.addSubview(gestureView)
    
    
  }
  
  @objc func handleSingleTap(sender: UITapGestureRecognizer) {
    print("Single Tapped")
  }
  
  @objc func handleDoubleTap(sender: UITapGestureRecognizer) {
    
    print("Double Tapped")
    
  }
  
  @objc func twoFingerTap(sender: UITapGestureRecognizer) {
    
    print("Two Finger Tapped")
    
  }
  
  
  @objc func pressed(sender: UIButton!) {
    if let  num1 = Int(num1TextField.text!) {
      if let num2 = Int(num2TextField.text!) {
        sumLabel.text = "\(num1 + num2)"
      }
    }
  }
  
  
}
// MARK:- ---> UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    // return NO to disallow editing.
    print("TextField should begin editing method called")
    if textField.tag == 0 {
      print ("Number 1")
    } else if textField.tag == 1 {
      print ("Number 2")
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // became first responder
    print("TextField did begin editing method called")
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    print("TextField should snd editing method called")
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    print("TextField did end editing method called")
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
    // if implemented, called in place of textFieldDidEndEditing:
    print("TextField did end editing with reason method called")
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // return NO to not change text
    
    print("While entering the characters this method gets called")
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    // called when clear button pressed. return NO to ignore (no notifications)
    print("TextField should clear method called")
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // called when 'return' key pressed. return NO to ignore.
    print("TextField should return method called")
    // may be useful: textField.resignFirstResponder()
    return true
  }
  
}






