//
//  BSModalViewController.h
//  timewebmail
//
//  Created by BoogL on 22.01.13.
//  Copyright (c) 2013 timeweb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BSModalViewAppearAnimationDirection) {
    BSModalViewAppearAnimationDirectionLeft,
    BSModalViewAppearAnimationDirectionRight,
    BSModalViewAppearAnimationDirectionTop,
    BSModalViewAppearAnimationDirectionBottom
};

typedef NS_ENUM(NSInteger, BSModalViewAppearAnimationType) {
    BSModalViewAppearAnimationTypeWave,
    BSModalViewAppearAnimationTypeSizeScale
};

@interface BSModalViewController : UIViewController

- (id) initWithMainViewFrameSize:(CGSize)newMainViewFrameSize animationDuration:(float)newAnimationDuration getBackgroundImageFromView:(UIView *)backgroundView;

@property (nonatomic, strong) UIImage *backgroundImage;
- (void) setBackgroundImage:(UIImage *)newBackgroundImage;
- (void) getBackgroundImageFromView:(UIView *)backgroundView;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic) float animationDuration;
@property (nonatomic) BOOL moveMainViewToTheMiddle;
@property (nonatomic) BSModalViewAppearAnimationType animationType;
@property (nonatomic) BSModalViewAppearAnimationDirection animationDirection;

- (void) showMainViewAnimated:(BOOL)animate;
- (void) hideMainViewAnimated:(BOOL)animate;

- (void) mainViewDidShow;
- (void) mainViewDidHide;
@end
