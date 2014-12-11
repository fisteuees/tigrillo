//
//  Escena_menu.h
//  Cucho
//

//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "gameCenterManager.h"
#import <AVFoundation/AVFoundation.h>

@interface Escena_menu : SKScene

-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end
