//
//  ueesViewController.h
//  Cucho
//

//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>

@interface ueesViewController : UIViewController<GKGameCenterControllerDelegate>

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController
                                          *)gameCenterViewController;

@end
