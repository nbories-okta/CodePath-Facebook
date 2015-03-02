//
//  FeedViewController.swift
//  Facebook-Week4
//
//  Created by Nicolas Bories on 2/28/15.
//  Copyright (c) 2015 Nico. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    
    var isPresenting: Bool = true
    var selectedImageView: UIImageView!
    var movingImageView: UIImageView!
    var blackView: UIView!
    var originalSelectedImagePosition: CGRect!
    var endFrame: CGRect!
    

    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        feedScrollView.contentSize = feedImageView.frame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as PhotoViewController
        
        destinationViewController.detailImage = self.selectedImageView.image
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        blackView = UIView(frame: fromViewController.view.frame)
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0
        
        movingImageView = UIImageView(frame: selectedImageView.frame)
        movingImageView.image = selectedImageView.image
        movingImageView.contentMode = selectedImageView.contentMode
        movingImageView.clipsToBounds = selectedImageView.clipsToBounds
        
        
        var window = UIApplication.sharedApplication().keyWindow!
        window.addSubview(movingImageView)
        
        if (isPresenting) {
            
            containerView.addSubview(blackView)
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            
            var photoViewController = toViewController as PhotoViewController
            var finalImageView = photoViewController.bigImageView
            
            var height = (320 * movingImageView.image!.size.height) / movingImageView.image!.size.width
            endFrame = CGRect(x: 0, y: (view.frame.size.height - height) / 2, width: 320, height: height)
            
            var startFrame = containerView.convertRect(selectedImageView.frame, fromView: feedScrollView)
            movingImageView.frame = startFrame
            
            finalImageView.hidden = true
            finalImageView.contentMode = .ScaleAspectFit
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                toViewController.view.alpha = 1
                self.blackView.alpha = 0.8
                self.movingImageView.frame = self.endFrame
                
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    finalImageView.hidden = false
                    self.movingImageView.removeFromSuperview()
                    
            }
            
        } else {
            var photoViewController = fromViewController as PhotoViewController
            var finalImageView = photoViewController.bigImageView
            
            movingImageView.frame = self.endFrame
            var startFrame = containerView.convertRect(selectedImageView.frame, fromView: feedScrollView)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                fromViewController.view.alpha = 0.0
                self.blackView.alpha = 0
                self.movingImageView.frame = startFrame
                
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    self.movingImageView.removeFromSuperview()
                    self.blackView.removeFromSuperview()
                    fromViewController.view.removeFromSuperview()
                    
            }
        }
    }

    
    @IBAction func onTapPhoto(sender: UITapGestureRecognizer) {
        
        var imageView = sender.view as UIImageView
        selectedImageView = imageView
        originalSelectedImagePosition = selectedImageView.frame
        
        performSegueWithIdentifier("photoSegue", sender: self)
        
    }

}
