//
//  ViewController.m
//  Instagram
//
//  Created by  Li Yang on 2/1/17.
//  Copyright © 2017 Li Yang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, assign) CGPoint trayCenterWhenOpen;
@property (nonatomic, assign) CGPoint trayCenterWhenClose;

@property (nonatomic, strong) UIImageView *newlyCreatedFace;
@property (nonatomic, assign) CGPoint faceOriginalCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.trayView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin  |
    UIViewAutoresizingFlexibleBottomMargin;
    
    NSLog(@"self.view.bounds is %@", NSStringFromCGPoint(self.view.bounds.origin));
    NSLog(@"self.view.bounds is %@", NSStringFromCGSize(self.view.bounds.size));
    NSLog(@"self.trayView size is %@", NSStringFromCGSize(self.trayView.bounds.size));
    
    CGFloat trayCenterX = self.trayView.bounds.size.width/2;
    CGFloat trayOpenCenterY = self.view.bounds.size.height - self.trayView.bounds.size.height/2;
    
    CGFloat trayCloseCenterY = self.view.bounds.size.height + self.trayView.bounds.size.height/2 - 25;
    
    NSLog(@"calculated open center is (%f, %f}", trayCenterX, trayOpenCenterY);
    NSLog(@"calculated close center is (%f, %f}", trayCenterX, trayCloseCenterY);
    NSLog(@"current tray open center is %@", NSStringFromCGPoint(self.trayView.center));
    
    
    self.trayCenterWhenOpen = CGPointMake(trayCenterX, trayOpenCenterY);
    self.trayCenterWhenClose = CGPointMake(trayCenterX, trayCloseCenterY);
    
    self.trayView.center = self.trayCenterWhenClose;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    // Absolute (x,y) coordinates in parentView
    CGPoint location = [sender locationInView:self.view];
    
    CGPoint beginLocation;
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(location));
        self.trayOriginalCenter = self.trayView.center;
        beginLocation = location;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed at: %@", NSStringFromCGPoint(location));
        CGPoint translation = [sender translationInView:self.view];
        NSLog(@"translation y is %f", translation.y);
        
        NSLog(@"begin y is %f", beginLocation.y);
        NSLog(@"current y is %f", location.y);
        CGFloat diff = beginLocation.y - location.y;
        NSLog(@"manual calculated y is %f", diff);
        self.trayView.center = CGPointMake(self.trayOriginalCenter.x,
                                      self.trayOriginalCenter.y + translation.y);
//        self.trayView.center = CGPointMake(self.trayOriginalCenter.x,
//                                           self.trayOriginalCenter.y - 10);
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at: %@", NSStringFromCGPoint(location));
        CGPoint velocity = [sender velocityInView:self.view];            [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:10 initialSpringVelocity:velocity.y options:0 animations:^{
                if (velocity.y >0 ) {
                    self.trayView.center = self.trayCenterWhenClose;
                }else {
                    self.trayView.center = self.trayCenterWhenOpen;
                }
                
            } completion:^(BOOL finished) {
                NSLog(@"animation is done");
            }];
    }
    

}
- (IBAction)onTrayTapGesture:(id)sender {
    
    CGPoint currentTrayCenter = self.trayView.center;
    self.trayView.center = CGPointEqualToPoint(currentTrayCenter, self.trayCenterWhenOpen)? self.trayCenterWhenClose:self.trayCenterWhenOpen;

}

- (IBAction)onFacePanGesture:(UIPanGestureRecognizer *)sender {
    
    CGPoint location = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // Gesture recognizers know the view they are attached to
        UIImageView *imageView = (UIImageView *)sender.view;
        self.faceOriginalCenter = CGPointMake(imageView.center.x,
                                              self.view.bounds.size.height - self.trayView.bounds.size.height + imageView.center.y);
        
        NSLog(@"tray view origin is %@", NSStringFromCGPoint(self.trayView.bounds.origin));
        NSLog(@"face center is %@", NSStringFromCGPoint(imageView.center));
        // Create a new image view that has the same image as the one currently panning
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        // Add the new face to the tray's parent view.
        [self.view addSubview:self.newlyCreatedFace];
        
        // Initialize the position of the new face.
        self.newlyCreatedFace.center = imageView.center;
        
        // Since the original face is in the tray, but the new face is in the
        // main view, you have to offset the coordinates
        CGPoint faceCenter = self.newlyCreatedFace.center;
        self.newlyCreatedFace.center = CGPointMake(faceCenter.x,
                                                   faceCenter.y + self.trayView.frame.origin.y);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:sender.view];
        self.newlyCreatedFace.center = CGPointMake(self.faceOriginalCenter.x + translation.x,
                                                   self.faceOriginalCenter.y + translation.y + self.trayView.bounds.origin.y);
//        self.newlyCreatedFace.center = CGPointMake(self.faceOriginalCenter.x ,
//                                                   self.faceOriginalCenter.y );
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {

    }
    
}


@end
