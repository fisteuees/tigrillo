//
//  EfectoParallax.h
//  Cucho Run
//
//  Created by FISTE on 01/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EfectoParallax : SKSpriteNode

@property (nonatomic,strong) SKSpriteNode *fondo;
@property (nonatomic,strong) SKSpriteNode *fondo_clon;
@property (nonatomic) CGFloat velocidad;

- (id)initWithBackground:(NSString *)background
                    size:(CGSize)size
                   speed:(CGFloat)speed;

- (void) update: (NSTimeInterval) currentTime;

@end
