//
//  BSModalViewController.m
//  timewebmail
//
//  Created by BoogL on 22.01.13.
//  Copyright (c) 2013 timeweb. All rights reserved.
//

#import "BSFunctions.h"
#import "BSModalViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BSModalViewController{
    CGSize mainViewFrameSize;
    UIImageView *bgImage;
    
    UIView *blackView;
    
    float newHeight;
    float tmpHeight;
    float newWidth;
    float tmpWidth;
    
    BOOL firstRun;
    
    CGRect mainViewStartRect;
    CGRect mainViewDestinationRect;
    
    CGPoint bgImageStartAnchorPoint;
    CGPoint bgImageDestinationAnchorPoint;
    
    float distanceCoeficient;
}

@synthesize mainView;
@synthesize backgroundImage;
@synthesize animationDuration;
@synthesize moveMainViewToTheMiddle;
@synthesize animationDirection;
@synthesize animationType;

#pragma mark - View Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) initWithMainViewFrameSize:(CGSize)newMainViewFrameSize animationDuration:(float)newAnimationDuration getBackgroundImageFromView:(UIView *)backgroundView{
    self = [super init];
    if (self) {
        [self getBackgroundImageFromView:backgroundView];
        
        animationDuration = newAnimationDuration;
        mainViewFrameSize = newMainViewFrameSize;
        
        animationDirection = BSModalViewAppearAnimationDirectionTop;
        animationType = BSModalViewAppearAnimationTypeWave;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self checkRects];
    
    bgImage = [[UIImageView alloc] initWithImage:backgroundImage];
    bgImage.layer.anchorPoint = bgImageStartAnchorPoint;
    bgImage.frame = CGRectMake(0, 0, bgImage.frame.size.width, bgImage.frame.size.height);
    bgImage.userInteractionEnabled = YES;
    [self.view addSubview:bgImage];
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.0f;
    [self.view addSubview:blackView];
    
    mainView = [[UIView alloc] initWithFrame: mainViewStartRect];
    [self.view addSubview:mainView];
    
    firstRun = YES;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated{
    if (firstRun) [self showMainViewAnimated:YES];
}

#pragma mark - Self Methods
- (void) getBackgroundImageFromView:(UIView *)backgroundView{
    if (NULL != UIGraphicsBeginImageContextWithOptions){
        UIGraphicsBeginImageContextWithOptions(backgroundView.frame.size, NO, [[UIScreen mainScreen] scale]);
    }else{
        UIGraphicsBeginImageContext(backgroundView.frame.size);
    }
    
    [backgroundView.layer renderInContext:UIGraphicsGetCurrentContext()];
    [self setBackgroundImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    UIGraphicsEndImageContext();
}

- (void) setBackgroundImage:(UIImage *)newBackgroundImage{
    backgroundImage = newBackgroundImage;
    bgImage.image = backgroundImage;
}

- (void) showMainViewAnimated:(BOOL)animate{
    firstRun = NO;
    if (animationType == BSModalViewAppearAnimationTypeWave){
        [self showMainViewWaveAnimated:animate];
    }else if (animationType == BSModalViewAppearAnimationTypeSizeScale){
        [self showMainViewSizeScaleAnimated:animate];
    }
}

- (void) hideMainViewAnimated:(BOOL)animate{
    if (animationType == BSModalViewAppearAnimationTypeWave){
        [self hideMainViewWaveAnimated:animate];
    }else if (animationType == BSModalViewAppearAnimationTypeSizeScale){
        [self hideMainViewSizeScaleAnimated:animate];
    }
}

#pragma mark - AnimationWithTypeWave
- (void) showMainViewWaveAnimated:(BOOL)animate{
    float tmpAnimationDuration = animationDuration;
    if (!animate) tmpAnimationDuration = 0;
    
    [UIView animateWithDuration:tmpAnimationDuration delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        mainView.frame = mainViewDestinationRect;
    }completion:^(BOOL finished){
        [self mainViewDidShow];
    }];
    
    [UIView animateWithDuration:tmpAnimationDuration / 2 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        CATransform3D tmpTransform = CATransform3DIdentity;
        tmpTransform.m34 = distanceCoeficient;
        if (animationDirection == BSModalViewAppearAnimationDirectionBottom || animationDirection == BSModalViewAppearAnimationDirectionTop){
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        }else{
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
        }
        
        bgImage.layer.transform = tmpTransform;
    }completion:^(BOOL finished){
        CATransform3D tmpTransform = CATransform3DIdentity;
        tmpTransform.m34 = distanceCoeficient;
        
        if (animationDirection == BSModalViewAppearAnimationDirectionBottom || animationDirection == BSModalViewAppearAnimationDirectionTop){
            newHeight = self.view.frame.size.height - 50;
            tmpHeight = floorf(bgImage.frame.size.height);
            newWidth = 302;
            
            tmpTransform = CATransform3DRotate(tmpTransform, 0 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
            bgImage.layer.transform = tmpTransform;
            bgImage.layer.anchorPoint = bgImageDestinationAnchorPoint;
        }else{
            newHeight = self.view.frame.size.height - 18;
            tmpWidth = floorf(bgImage.frame.size.width);
            newWidth = 295;
            
            tmpTransform = CATransform3DRotate(tmpTransform, 0 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
            bgImage.layer.transform = tmpTransform;
            bgImage.layer.anchorPoint = bgImageDestinationAnchorPoint;
        }
        
        if (animationDirection == BSModalViewAppearAnimationDirectionTop){
            bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), floorf(self.view.frame.size.height - tmpHeight), newWidth, newHeight);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionRight){
            bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), floorf(self.view.frame.size.height - tmpHeight), newWidth, newHeight);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionBottom){
            bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), 8, newWidth, newHeight);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionLeft){
            bgImage.frame = CGRectMake(floorf(self.view.frame.size.width - tmpWidth), floorf((self.view.frame.size.height - newHeight) / 2), newWidth, newHeight);
        }
        
        
        tmpTransform.m34 = distanceCoeficient;
        
        if (animationDirection == BSModalViewAppearAnimationDirectionBottom || animationDirection == BSModalViewAppearAnimationDirectionTop){
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        }else{
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
        }
        
        bgImage.layer.transform = tmpTransform;
        
        [UIView animateWithDuration:tmpAnimationDuration / 2 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            CATransform3D tmpTransform = CATransform3DIdentity;
            tmpTransform.m34 = distanceCoeficient;
            tmpTransform = CATransform3DRotate(tmpTransform, 0 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
            bgImage.layer.transform = tmpTransform;
            
            if (animationDirection == BSModalViewAppearAnimationDirectionTop){
                bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), 0, newWidth, self.view.frame.size.height - 26);
            }else if (animationDirection == BSModalViewAppearAnimationDirectionRight){
                bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), floorf(self.view.frame.size.height - tmpHeight), newWidth, newHeight);
            }else if (animationDirection == BSModalViewAppearAnimationDirectionBottom){
                bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), floorf(self.view.frame.size.height - (self.view.frame.size.height - 26)), newWidth, self.view.frame.size.height - 26);
            }else if (animationDirection == BSModalViewAppearAnimationDirectionLeft){
                bgImage.frame = CGRectMake(0, floorf((self.view.frame.size.height - newHeight) / 2), floorf(self.view.frame.size.width - 23), newHeight);
            }
            
            blackView.alpha = 0.6f;
        }completion:^(BOOL finished){
            
        }];
    }];
}

- (void) hideMainViewWaveAnimated:(BOOL)animate{
    float tmpAnimationDuration = animationDuration;
    if (!animate) tmpAnimationDuration = 0;
    
    [UIView animateWithDuration:tmpAnimationDuration delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        mainView.frame = mainViewStartRect;
    }completion:^(BOOL finished){
        
    }];
    
    [UIView animateWithDuration:tmpAnimationDuration / 2 delay:0 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        CATransform3D tmpTransform = CATransform3DIdentity;
        tmpTransform.m34 = distanceCoeficient;
        if (animationDirection == BSModalViewAppearAnimationDirectionBottom || animationDirection == BSModalViewAppearAnimationDirectionTop){
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        }else{
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
        }
        bgImage.layer.transform = tmpTransform;
        
        if (animationDirection == BSModalViewAppearAnimationDirectionTop){
            bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), floorf(self.view.frame.size.height - tmpHeight), newWidth, newHeight);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionRight){
            bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), floorf(self.view.frame.size.height - tmpHeight), newWidth, newHeight);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionBottom){
            bgImage.frame = CGRectMake(floorf((self.view.frame.size.width - newWidth) / 2), 8, newWidth, newHeight);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionLeft){
            bgImage.frame = CGRectMake(floorf(self.view.frame.size.width - tmpWidth), floorf((self.view.frame.size.height - newHeight) / 2), newWidth, newHeight);
        }
        
        blackView.alpha = 0.0f;
    }completion:^(BOOL finished){
        
        bgImage.layer.anchorPoint = bgImageStartAnchorPoint;
        bgImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        CATransform3D tmpTransform = CATransform3DIdentity;
        tmpTransform.m34 = distanceCoeficient;
        if (animationDirection == BSModalViewAppearAnimationDirectionBottom || animationDirection == BSModalViewAppearAnimationDirectionTop){
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        }else{
            tmpTransform = CATransform3DRotate(tmpTransform, 15 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
        }
        bgImage.layer.transform = tmpTransform;
        
        
        [UIView animateWithDuration:tmpAnimationDuration / 2 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            CATransform3D tmpTransform = CATransform3DIdentity;
            tmpTransform.m34 = distanceCoeficient;
            if (animationDirection == BSModalViewAppearAnimationDirectionBottom || animationDirection == BSModalViewAppearAnimationDirectionTop){
                tmpTransform = CATransform3DRotate(tmpTransform, 0 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
            }else{
                tmpTransform = CATransform3DRotate(tmpTransform, 0 * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
            }
            bgImage.layer.transform = tmpTransform;
        }completion:^(BOOL finished){
            [self mainViewDidHide];
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }];
}

#pragma mark - AnimationWithTypeSizeScale
- (void) showMainViewSizeScaleAnimated:(BOOL)animate{
    float tmpAnimationDuration = animationDuration;
    if (!animate) tmpAnimationDuration = 0;
    
    [UIView animateWithDuration:tmpAnimationDuration delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        mainView.frame = mainViewDestinationRect;
        bgImage.transform = CGAffineTransformMakeScale(0.95, 0.95);
        blackView.alpha = 0.6f;
    }completion:^(BOOL finished){
        [self mainViewDidShow];
    }];
}

- (void) hideMainViewSizeScaleAnimated:(BOOL)animate{
    float tmpAnimationDuration = animationDuration;
    if (!animate) tmpAnimationDuration = 0;
    
    [UIView animateWithDuration:tmpAnimationDuration delay:0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        mainView.frame = mainViewStartRect;
        bgImage.transform = CGAffineTransformMakeScale(1, 1);
        blackView.alpha = 0.0f;
    }completion:^(BOOL finished){
        [self mainViewDidHide];
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - Additional
- (void) checkRects{
    if (animationDirection == BSModalViewAppearAnimationDirectionTop){
        mainViewStartRect = CGRectMake(floorf((self.view.frame.size.width - mainViewFrameSize.width) / 2), self.view.frame.size.height, mainViewFrameSize.width, mainViewFrameSize.height);
        bgImageStartAnchorPoint = CGPointMake(0.5, 1);
        bgImageDestinationAnchorPoint = CGPointMake(0.5, 0);
        distanceCoeficient = -0.0005;
    }else if (animationDirection == BSModalViewAppearAnimationDirectionRight){
        mainViewStartRect = CGRectMake(-self.view.frame.size.width, floorf((self.view.frame.size.height - mainViewFrameSize.height) / 2), mainViewFrameSize.width, mainViewFrameSize.height);
        bgImageStartAnchorPoint = CGPointMake(0, 0.5);
        bgImageDestinationAnchorPoint = CGPointMake(1, 0.5);
        distanceCoeficient = -0.0005;
    }else if (animationDirection == BSModalViewAppearAnimationDirectionBottom){
        mainViewStartRect = CGRectMake(floorf((self.view.frame.size.width - mainViewFrameSize.width) / 2), -self.view.frame.size.height, mainViewFrameSize.width, mainViewFrameSize.height);
        bgImageStartAnchorPoint = CGPointMake(0.5, 0);
        bgImageDestinationAnchorPoint = CGPointMake(0.5, 1);
        distanceCoeficient = 0.0005;
    }else if (animationDirection == BSModalViewAppearAnimationDirectionLeft){
        mainViewStartRect = CGRectMake(self.view.frame.size.width, floorf((self.view.frame.size.height - mainViewFrameSize.height) / 2), mainViewFrameSize.width, mainViewFrameSize.height);
        bgImageStartAnchorPoint = CGPointMake(1, 0.5);
        bgImageDestinationAnchorPoint = CGPointMake(0, 0.5);
        distanceCoeficient = 0.0005;
    }
    
    if (moveMainViewToTheMiddle){
        mainViewDestinationRect = CGRectMake(floorf((self.view.frame.size.width - mainViewFrameSize.width) / 2), floorf((self.view.frame.size.height - mainView.frame.size.height) / 2), mainViewFrameSize.width, mainViewFrameSize.height);
    }else{
        if (animationDirection == BSModalViewAppearAnimationDirectionTop){
            mainViewDestinationRect = CGRectMake(floorf((self.view.frame.size.width - mainViewFrameSize.width) / 2), self.view.frame.size.height - mainViewFrameSize.height, mainViewFrameSize.width, mainViewFrameSize.height);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionRight){
            mainViewDestinationRect = CGRectMake(0, floorf((self.view.frame.size.height - mainViewFrameSize.height) / 2), mainViewFrameSize.width, mainViewFrameSize.height);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionBottom){
            mainViewDestinationRect = CGRectMake(floorf((self.view.frame.size.width - mainViewFrameSize.width) / 2), 0, mainViewFrameSize.width, mainViewFrameSize.height);
        }else if (animationDirection == BSModalViewAppearAnimationDirectionLeft){
            mainViewDestinationRect = CGRectMake(self.view.frame.size.width - mainViewFrameSize.width, floorf((self.view.frame.size.height - mainViewFrameSize.height) / 2), mainViewFrameSize.width, mainViewFrameSize.height);
        }
    }
}

- (void) mainViewDidShow{
    
}

- (void) mainViewDidHide{
    
}
@end
