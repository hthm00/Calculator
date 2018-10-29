//
//  AppDelegate.swift
//  Calculator
//
//  Created by Minh Huynh on 7/29/18.
//  Copyright © 2018 Minh Huynh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!
    var clear: Bool!
    var prevIsMath: Bool!
    var lbResult: UILabel!
    var math1, math2, math3: String!
    var number1, number2, number3 : Double!
    var btnAC: UIButton!
    
    
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        let btnTitle = ["0", ".", "=", "1", "2", "3", "+", "4", "5", "6", "-", "7", "8", "9", "x", "AC", "+/-", "%", "÷"]
        
        
        print(btnTitle)
        
        math1 = nil
        clear = false
        prevIsMath = false
        var padding : CGFloat = 2
        
        if self.window.bounds.height == 812.0 {
            padding = 10
        }
        
        let screenHeight = self.window.frame.height
        let screenWidth = self.window.frame.width
        let buttonSize = (screenWidth - 5*padding) / 4
        
        var cursorX : CGFloat = padding
        var cursorY = screenHeight - buttonSize - padding
        self.window.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
        
        var btn : MyButton!
        
        var count = 0
    
        while (true) {
            if count == 19 {
                break;
            } else if (btnTitle[count] == "0") {
                btn = MyButton(frame: CGRect(x: cursorX, y: cursorY, width: buttonSize*2 + padding, height: buttonSize))
                btn.contentHorizontalAlignment = .left
                btn.titleEdgeInsets.left = (buttonSize*2 + padding) / 4 - (buttonSize / 3 / 3)
                cursorX = cursorX + buttonSize*2 + padding*2
                
            } else {
                btn = MyButton(frame: CGRect(x: cursorX, y: cursorY, width: buttonSize, height: buttonSize))
                if (btnTitle[count] == "=" || btnTitle[count] == "+" || btnTitle[count] == "-" || btnTitle[count] == "x" || btnTitle[count] == "÷") {
                    btn.myTitleColor = UIColor.white
                    btn.myBackgroundColor = UIColor.orange
                    btn.myIsHighLightedColor = UIColor(red:0.73, green:0.47, blue:0.22, alpha:1.0)
                    btn.layer.borderColor = UIColor.clear.cgColor
                    btn.layer.borderWidth = 2
                } else if btnTitle[count] == "AC"  {
                    btnAC = btn
                }
                cursorX = cursorX + buttonSize + padding
                if (count % 4 == 2) {
                    cursorX = padding;
                    cursorY = cursorY - buttonSize - padding
                }
            }
            
            if self.window.bounds.height == 812.0 {
                btn.layer.cornerRadius = buttonSize / 2
            }
            btn.setTitle(btnTitle[count], for: .normal)
            btn.addTarget(self, action: #selector(functionName(sender:)), for: UIControlEvents.touchUpInside)
            self.window.addSubview(btn)
            count+=1
            
        }
        
        lbResult = UILabel(frame: CGRect(x: cursorX, y: cursorY, width: screenWidth - 2*padding, height: buttonSize))
        lbResult.backgroundColor = UIColor.clear
        lbResult.textColor = .white
        lbResult.text = "0"
        lbResult.textAlignment = NSTextAlignment.right
        lbResult.font = UIFont(name: "Arial", size: 70)
        lbResult.adjustsFontSizeToFitWidth = true
        self.window.addSubview(lbResult)
        
        return true
    }
    
    
    
    @objc func functionName(sender: UIButton) {
        let lbTitle = sender.titleLabel?.text;
        print(lbTitle)
        if (lbTitle == "+" || lbTitle == "-" || lbTitle == "x" || lbTitle == "÷") {
            if (math1 != nil && !prevIsMath) { // Check if there is another math before
                clearBorders()
                math2 = lbTitle; // current operation
                number2 = Double(lbResult.text!);
                var result = 0.0;
                
                // check second operation
                if (math2 == "x" || math2 == "÷") {
                    if (math1 == "x" || math1 == "÷") {
                        result = operate(num1: number1, num2: number2, math: math1)
                        number1 = result
                        math1 = math2
                        lbResult.text = String(format: "%g", result)
                        number1 = Double(lbResult.text!);
                    } else {
                        number3 = number1;
                        number1 = Double(lbResult.text!);
                        math3 = math1;
                    }
                } else {
                    
                    //check first operation
                    if (math1 == "-" || math1 == "+") {
                        result = operate(num1: number1, num2: number2, math: math1)
                        lbResult.text = String(format: "%g", result)
                        number1 = Double(lbResult.text!);
                    } else {
                        result = operate(num1: number1, num2: number2, math: math1)
                        
                        //check least priority operation
                        if (math3 == "-" || math3 == "+") {
                            result = operate(num1: number3, num2: result, math: math3)
                        } else {
                            number1 = result;
                            math1 = math2;
                        }
                        lbResult.text = String(format: "%g", result)
                        number1 = Double(lbResult.text!);
                    }
                }
            } else if (prevIsMath) { // Check if multiple operations are proceeded
                clearBorders()
                
                /* This code will function like old calculator
                var result = 0.0;
                if (math2 == "-" || math2 == "+") {
                    if (math1 == "-" || math1 == "+") {
                        math2 = lbTitle; // current operation
                        number2 = Double(lbResult.text!);
                        result = operate(num1: number1, num2: number2, math: math1)
                        lbResult.text = String(format: "%g", result)
                        number1 = Double(lbResult.text!);
                    }
                }
                 */
                
                // Assign new math to the old one
                if (math1 != nil) {
                    math1 = lbTitle;
                }
            } else {
                number1 = Double(lbResult.text!)
            }
            //change border color
            sender.layer.borderColor = UIColor.gray.cgColor

            math1 = lbTitle;
            prevIsMath = true;
            clear = true;
        } else if (lbTitle == "=") {
            clearBorders()
            if math1 != nil {
                number2 = Double(lbResult.text!);
                var result: Double!;
                if (math1 == "-" || math1 == "+") {
                    result = operate(num1: number1, num2: number2, math: math1)
                    
                } else {
                    result = operate(num1: number1, num2: number2, math: math1)
                    if (math3 == "-" || math3 == "+") {
                        result = operate(num1: number3, num2: result, math: math3)
                    }
                }
                print(String(number1) + " " + String(number2))
                lbResult.text = String(format: "%g", result)
                clear = true
                math1 = nil
                math2 = nil
                math3 = nil
            }
            
        } else if (lbTitle == "AC") {
            clearBorders()
            math1 = nil;
            math2 = nil;
            math3 = nil;
            lbResult.text = "0";
            clear = false;
        } else if (lbTitle == "C") {
            if prevIsMath {
                clearBorders()
                prevIsMath = false
                math1 = nil
            } else {
                lbResult.text = "0"
            }
            btnAC.setTitle("AC", for: .normal)
        } else if (lbTitle == "+/-") {
            lbResult.text = String(format: "%g", 0 - Double(lbResult.text!)!);
        } else if (lbTitle == "%") {
            if (math1 != nil) {
                number2 = Double(lbResult.text!);
                lbResult.text = String(format: "%g", (number1 * number2) / 100.0);
                number2 = Double(lbResult.text!);
            } else {
                number1 = Double(lbResult.text!)! / 100.0;
                lbResult.text = String(format: "%g", number1);
            }
            clear = true;
        } else if (sender.tag == 0) { //button number is pressed
            if (clear) {
                lbResult.text = ""
                clear = false
            }
            if lbResult.text == "0" {
                lbResult.text = String(describing: Int(lbResult.text! + lbTitle!)!)
            } else {
                lbResult.text = lbResult.text! + lbTitle!
            }
            prevIsMath = false
            btnAC.setTitle("C", for: .normal)
        }
    }
    
    func operate(num1: Double, num2:Double, math:String) -> Double {
        var result = 0.0;
        if (math == "+") {
            result = num1 + num2
        } else if (math == "-") {
            result = num1 - num2
        } else if (math == "x") {
            result = num1 * num2
        } else if (math == "÷") {
            result = num1 / num2
        }
        return result
    }
    
    func clearBorders() {
        for btn in self.window.subviews {
            btn.layer.borderColor = UIColor.clear.cgColor
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

