//
//  ViewController.swift
//  Eevo
//
//  Created by CK on 10/11/14.
//  Copyright (c) 2014 Eevo. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController, PFLogInViewControllerDelegate {

    @IBOutlet var logInViewTitleLabel: UILabel!
    
    var logInController = PFLogInViewController()
    var requireLoggedInOnView = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.logInController.delegate = self
        self.logInController.emailAsUsername = true
        var nib = UINib(nibName: "LoggedInView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        self.logInViewTitleLabel.sizeToFit()
        self.logInController.logInView.logo = self.logInViewTitleLabel
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if requireLoggedInOnView {
            requireLoggedin()
        }
    }
    
    func requireLoggedin() {
        var currentUser = PFUser.currentUser()
        if currentUser == nil {
            presentViewController(logInController, animated: true, completion: nil)
        }
    }
    
    func onLogOut() {
        PFUser.logOut()
        requireLoggedin()
    }

    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        println("didLogInUser: User logged in")
        self.logInController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        println("didFailToLogInWithError: Login failed")
        self.logInController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
        println("Login cancelled")
        self.logInController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

