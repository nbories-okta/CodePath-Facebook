//
//  PhotoViewController.swift
//  Facebook-Week4
//
//  Created by Nicolas Bories on 2/28/15.
//  Copyright (c) 2015 Nico. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var photoScrollView: UIScrollView!
    @IBOutlet weak var photoActionsImage: UIImageView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var doneButtonImage: UIImageView!
    
    var detailImage: UIImage!
    var scrollMove: CGFloat!
    var scrollAlpha: CGFloat!
    
    var imageOriginalCenter: CGFloat!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoScrollView.contentSize = CGSize(width: 320, height: 678)
        bigImageView.image = detailImage
        photoScrollView.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapDoneButton(sender: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        
        scrollMove = abs(photoScrollView.contentOffset.y)
        photoScrollView.backgroundColor = UIColor(white: 0, alpha: ((100-abs(scrollMove))/100))
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        doneButtonImage.hidden = true
        photoActionsImage.hidden = true
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        
        if (scrollMove > 75) {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
                self.photoScrollView.contentOffset.y = 0
                self.photoScrollView.backgroundColor = UIColor(white: 0, alpha: 1)
                }, completion: nil)
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        doneButtonImage.hidden = false
        photoActionsImage.hidden = false
        
        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 10, options: nil, animations: { () -> Void in
            self.photoScrollView.contentOffset.y = 0
            self.photoScrollView.backgroundColor = UIColor(white: 0, alpha: 1)
            }, completion: nil)
    }
    
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return bigImageView
    }

}
