//
//  QuestionViewController.swift
//  Guess the Fighter, Угадай Бойца
//
//  Created by Artem on 11/14/16.
//  Copyright © 2016 piqapp. All rights reserved.

///FONTS///

// Avenir-LightOblique  AvenirNext-UltraLight Didot-Bold HelveticaNeue-UltraLight PingFangHK-Ultralight PingFangTC-Thin


import UIKit

func setupGradient(layerAttachTo: CALayer, frame: CGRect, gradient: CAGradientLayer, colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint, zPosition: Float) {
    
    gradient.frame = frame
    gradient.colors = colors
    gradient.locations = locations
    gradient.startPoint = startPoint
    gradient.endPoint = endPoint
    gradient.zPosition = CGFloat(zPosition)
    layerAttachTo.addSublayer(gradient)
}


var qVController: QuestionViewController!

class QuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var picker: UIPickerView!
    
    
    @IBOutlet var signX: [UIImageView]!
    @IBOutlet weak var answerButton: UIButton!
    
    var gradient: CAGradientLayer!
    var theGameController: GameController!
    
    var currentSelectedAnswer: String!
    
/////////////////////////// VIEW /////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qVController = self
        theGameController = GameController(debugLabel: self.testLabel)
        initGradient()
    }
    override func viewDidAppear(animated: Bool) {
    }
    override func viewWillAppear(animated: Bool) {
        
        self.imageView.image = UIImage(named:theGameController.currentFighter.image)
        
        //viberaem centralniy element po umolchaniyu
        pickerSelectMiddleOption()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
///////////////////////// PICKER VIEW DELEGATE//////////////// PICKER VIEW DELEGATE//////////////////
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.theGameController.answerListCount
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let title: String!
        title = self.theGameController.currentAnswerListData[row]
        
        ///picker rows color and text
        let thetitle = NSAttributedString(string: title, attributes: [NSFontAttributeName:UIFont(name: "PingFangTC-Thin", size: 26.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        let hue = CGFloat(0.70)
        pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        pickerLabel.textAlignment = .Center
        pickerLabel.attributedText = thetitle
        return pickerLabel
        
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentSelectedAnswer = self.theGameController.currentAnswerListData[row]
        self.testLabel.text = self.theGameController.currentAnswerListData[row]
    }
    
////////////////////// ANIMATION DELEGATE ///////////////////////////////////////////////////////////
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let name = anim.valueForKey("name") as? String {
            if name == "anim" {
                
               
                
                
            }
        }
    }
    
//////////////////////////////////////////// CUSTOM FUNCTIONS ///////////////////////////////////////

    func pickerSelectMiddleOption() {
        let index: Int = Int(self.theGameController.answerListCount/2)
        picker.selectRow(index, inComponent: 0, animated: true)
        self.currentSelectedAnswer = self.theGameController.currentAnswerListData[picker.selectedRowInComponent(0)]
        self.testLabel.text = currentSelectedAnswer
    }
    
    func reloadPickerView() {
        self.picker.reloadAllComponents()
    }
    
    func setNewImage(imageName: String) {
        self.imageView.image = UIImage(named: imageName)
        pickerSelectMiddleOption()
        self.testLabel.text = currentSelectedAnswer
    }
    
    func gameOverFunc() {
        myGradientAnimation(self)
        
    }
    
    func changeXtoDot() -> Void {
        switch (self.theGameController.triesLeft) {
        case 2:
            self.signX[2].image = UIImage(named: "X")
            self.signX[2].backgroundColor = UIColor.redColor()
            break
        case 1:
            self.signX[1].image = UIImage(named: "X")
            self.signX[1].backgroundColor = UIColor.redColor()

            break
        case 0:
            self.signX[0].image = UIImage(named: "X")
            self.signX[0].backgroundColor = UIColor.redColor()

            break
        default:
            break
        }
    }
    
    func initGradient() {
        gradient = CAGradientLayer()
        let gradientColors = [UIColor.blueColor().CGColor, UIColor.blackColor().CGColor, UIColor.whiteColor().CGColor]
        let startPoint = CGPoint(x: 0.95, y: 0.95)
        let endPoint = CGPoint(x: 1.0, y: 0.0)
        let locations = [NSNumber(double: 0.0), NSNumber(double: 0.2), NSNumber(double: 0.4)]
        let gradientInitialFrame = CGRect(x: 0.0, y: 0.0, width: mainView.bounds.width+5.0, height: mainView.bounds.height) //kostilik
        
        setupGradient(gradientView.layer, frame: gradientInitialFrame, gradient: gradient, colors: gradientColors, locations: locations, startPoint: startPoint, endPoint: endPoint, zPosition: -100)
    }
    
    func answerButtonAnimationOnPress() {
        let anim = CASpringAnimation(keyPath: "transform.scale")
        anim.damping = 4.5
        anim.initialVelocity = 15.0
        //anim.stiffness = 100.0
        anim.mass = 2.0
        anim.duration = anim.settlingDuration
        anim.fromValue = 1.2
        anim.toValue = 1.0
        self.answerButton.layer.addAnimation(anim, forKey: nil)
    }
    
////////////////////////////// ANSWER BUTTON HANDLER /////////////////////// HANDLERS ////////////////
    
    @IBAction func answerButton(sender: UIButton) {
        answerButtonAnimationOnPress()
        testLabel.text = currentSelectedAnswer
        self.theGameController.checkRightOrWrong(answer: self.currentSelectedAnswer, changeXToDotFunc: self.changeXtoDot, gameOverFunc: self.gameOverFunc)
    }
    
    @IBAction func returnToQuestionViewController(segue: UIStoryboardSegue) {
        
    }
    
    
    
////////////////////////////////////////////// GRADIENT ///////////////////////// GRADIENT ///////////
    
    func animateGradient(gradient gradient: CAGradientLayer, animKeyPath: String, from: AnyObject, to: AnyObject, duration: CFTimeInterval, repeatCount: Float, autoreverse: Bool, timingFunc: CAMediaTimingFunction, beginTime: CFTimeInterval = 0.0, deleg: AnyObject?, animName: String?) {
        var animation: CABasicAnimation!
        switch (animKeyPath) {
        case "colors":
            animation = CABasicAnimation(keyPath: "colors")
            let fromArr = from as! [CGColor]
            let toArr = to as! [CGColor]
            animation.fromValue = fromArr
            animation.toValue = toArr
            break
        case "locations":
            animation = CABasicAnimation(keyPath: "locations")
            let fromArr = from as! [NSNumber]
            let toArr = to as! [NSNumber]
            animation.fromValue = fromArr
            animation.toValue = toArr
            break
        case "startPoint.x":
            animation = CABasicAnimation(keyPath: "startPoint.x")
            let fromArr = from as! Float
            let toArr = to as! Float
            animation.fromValue = fromArr
            animation.toValue = toArr
            break
        case "startPoint.y":
            animation = CABasicAnimation(keyPath: "startPoint.y")
            let fromArr = from as! Float
            let toArr = to as! Float
            animation.fromValue = fromArr
            animation.toValue = toArr
            break
        default:
            return
        }
        
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = autoreverse
        animation.timingFunction = timingFunc
        animation.beginTime = beginTime
        animation.delegate = qVController
        animation.setValue(animName, forKey: "name")
        gradient.addAnimation(animation, forKey: nil)
    }
    
    func animateGradientPredefined(gradient: CAGradientLayer) {
        //locations
        let gradientAnimationLocations = CABasicAnimation(keyPath: "locations")
        gradientAnimationLocations.fromValue = [0.0, 0.0, 0.2]
        gradientAnimationLocations.toValue = [0.8, 1.0, 1.0]
        //colors
        let gradientAnimationColors = CABasicAnimation(keyPath: "colors")
        gradientAnimationColors.fromValue = [UIColor.blackColor().CGColor, UIColor.blueColor().CGColor, UIColor.whiteColor().CGColor]
        gradientAnimationColors.toValue = [UIColor.magentaColor().CGColor, UIColor.whiteColor().CGColor, UIColor.blueColor().CGColor]
        //startPoint.x
        let gradientAnimationStartPointX = CABasicAnimation(keyPath: "startPoint.x")
        gradientAnimationStartPointX.fromValue = 0.0
        gradientAnimationStartPointX.toValue = 0.0
        
        //startPoint.y
        let gradientAnimationStartPointY = CABasicAnimation(keyPath: "startPoint.y")
        gradientAnimationStartPointY.fromValue = 0.0
        gradientAnimationStartPointY.toValue = 0.0
        
        //group
        let gradientAnimationGroup = CAAnimationGroup()
        gradientAnimationGroup.delegate = self
        gradientAnimationGroup.duration = 30.0
        gradientAnimationGroup.repeatCount = Float.infinity
        gradientAnimationGroup.autoreverses = true
        gradientAnimationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        gradientAnimationGroup.animations = [gradientAnimationLocations, gradientAnimationColors, gradientAnimationStartPointX, gradientAnimationStartPointY]
        
        gradient.addAnimation(gradientAnimationGroup, forKey: "GradientComplexAnimation")
    }
    
    
    func myGradientAnimation(delegate: UIViewController?) {
        let duration = 4.0
        animateGradient(gradient: gradient, animKeyPath: "colors", from: [UIColor.blackColor().CGColor, UIColor.blueColor().CGColor, UIColor.whiteColor().CGColor], to: [UIColor.blueColor().CGColor, UIColor.blackColor().CGColor, UIColor.whiteColor().CGColor], duration: duration, repeatCount: Float.infinity, autoreverse: true, timingFunc: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), deleg: delegate!, animName: "anim2")
        
        animateGradient(gradient: gradient, animKeyPath: "startPoint.x", from: gradient.startPoint.x, to: 1.0, duration: duration, repeatCount: 1, autoreverse: false, timingFunc: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), deleg: delegate!, animName: "anim1")
        
        animateGradient(gradient: gradient, animKeyPath: "startPoint.y", from: gradient.startPoint.y, to: 1.0, duration: duration, repeatCount: 1, autoreverse: false, timingFunc: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), deleg: delegate!, animName: "anim")
        
    }
    
    //    [self.view.layer insertSublayer:gradient atIndex:0];

    
    
    //UIColor.init(colorLiteralRed: 0.0, green: 0.0, blue: 0.25*Float(arc4random())/Float(UINT32_MAX), alpha: 1.0).CGColor   -   random color
    
    func gradientDefaultAnimationSetup(delegate: UIViewController?) {
         animateGradient(gradient: gradient, animKeyPath: "colors", from: [UIColor.blueColor().CGColor, UIColor.blueColor().CGColor, UIColor.whiteColor().CGColor], to: [UIColor.blueColor().CGColor, UIColor.blackColor().CGColor, UIColor.blueColor().CGColor], duration: 10, repeatCount: Float.infinity, autoreverse: true, timingFunc: CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear), deleg: delegate!, animName: "anim2")
        
        
    }
    
}






