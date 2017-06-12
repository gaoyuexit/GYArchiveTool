//
//  CustomShowMessageAnimator.swift
//  MaiDou
//
//  Created by 郜宇 on 2017/3/10.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit
import LPTransitions

class CustomShowMessageAnimator: LPTransitions {
    
    override init(fromController: UIViewController?) {
        super.init(fromController: fromController)
        duration = 0.35
        interactionControllerType = MessageDismissDrivenTransition.self
    }
    
    func performPresentedTransition(originalView: UIView, presentedView: UIView,context: UIViewControllerContextTransitioning) {

        presentedView.frame.origin.y = .screenHeight
        
        (interactionController as? MessageDismissDrivenTransition)?.setupDismiss(view: presentedView)
        
        UIView.animate(withDuration: duration, animations: {
            presentedView.transform = CGAffineTransform(translationX: 0, y: -.screenHeight)
        }) { (complete) in
            if context.transitionWasCancelled {
                context.completeTransition(false)
            }else{
                context.completeTransition(complete)
            }
        }
    }
    
    func performDismissedTransition(originalView: UIView, presentedView: UIView,context: UIViewControllerContextTransitioning)
    {
        UIView.animate(withDuration: duration, animations: {
            presentedView.transform = CGAffineTransform.identity
        }) { (complete) in
            if context.transitionWasCancelled {
                context.completeTransition(false)
            }else{
                context.completeTransition(complete)
            }
        }
    }
}

class MessageDismissDrivenTransition: LPPercentDrivenInteractiveTransition {
    
    func setupDismiss(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dismissPan(pan:)))
        view.addGestureRecognizer(pan)
    }

    func dismissPan(pan: UIPanGestureRecognizer) {
        let offset = -pan.translation(in: pan.view?.superview).y
        let persent = -offset / .screenHeight
        
        switch pan.state {
        case .began:
            isTransiting = true
            transition?.toController?.dismiss(animated: true, completion: nil)
        case .changed:
            if persent >= 1 {
                update(0.999)
                return
            }
            update(persent)
        case .ended, .cancelled, .failed:
            isTransiting = false
//            let vel = pan.velocity(in: pan.view).y
//            vel <= 0 ? cancel() : finish()
            if persent > 0.10 {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}

