//
//  Escena_mundos.m
//  Cucho Run
//
//  Created by FISTE on 12/06/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_mundos.h"

@interface Escena_mundos(){
    bool isPhone;
}

@end

@implementation Escena_mundos

-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
            
        }
    return self;
}


@end
