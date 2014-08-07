//
//  EfectoParallax.m
//  Cucho Run
//
//  Created by FISTE on 01/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "EfectoParallax.h"

@implementation EfectoParallax

-(id)initWithBackground:(NSString *)background size:(CGSize)size speed:(CGFloat)speed{
    
    {
        self = [super init];
        if (self)
        {
            // load background image
            self.fondo = [[SKSpriteNode alloc] initWithImageNamed:background];
            
            // position background
            self.position = CGPointMake(size.width / 2, size.height / 2);
            
            // speed
            self.velocidad = speed;
            
            // create duplicate background and insert location
            SKSpriteNode *node = self.fondo;
            node.position = CGPointMake(0, self.size.height);
            
            self.fondo_clon = [node copy];
            CGFloat clonedPosX = node.position.x;
            CGFloat clonedPosY = node.position.y;
            clonedPosX = node.size.width;
            
            self.fondo_clon.position = CGPointMake(clonedPosX, clonedPosY);
            
            [self addChild:node];
            [self addChild:self.fondo_clon];
        }
        
    }
    
    return self;
}


-(void)update:(NSTimeInterval)currentTime{
    CGFloat speed = self.velocidad;
    SKSpriteNode *bg = self.fondo;
    SKSpriteNode *cBg = self.fondo_clon;
    
    CGFloat newBgX = bg.position.x, newBgY = bg.position.y,
    newCbgX = cBg.position.x, newCbgY = cBg.position.y;
    //NSLog(@"1 newbgX %f",newBgX);
    newBgX -= speed;
    newCbgX -= speed;
    //NSLog(@"2 newbgX %f",newBgX);
    if (newBgX <= -bg.size.width) newBgX = newCbgX + cBg.size.width;
    if (newCbgX <= -cBg.size.width) newCbgX =  newBgX + bg.size.width;
    bg.position = CGPointMake(newBgX, newBgY);
    cBg.position = CGPointMake(newCbgX, newCbgY);
}

@end
