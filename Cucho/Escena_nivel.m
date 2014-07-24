//
//  Escena_nivel.m
//  Cucho Run
//
//  Created by FISTE on 08/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_nivel.h"

@interface Escena_nivel(){
    bool isPhone;
}

@end

@implementation Escena_nivel

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    NSLog(@"se movio");
}

@end
