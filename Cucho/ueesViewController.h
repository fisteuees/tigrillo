//
//  ueesViewController.h
//  Cucho
//

//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>
#import "iCarousel.h"

@interface ueesViewController : UIViewController<GKGameCenterControllerDelegate,iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong)  iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController
                                          *)gameCenterViewController;

@end
