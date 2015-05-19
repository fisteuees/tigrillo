//
//  Escena_mundos.m
//  Cucho Run
//
//  Created by FISTE on 12/06/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_mundos.h"
#import "Escena_menu.h"
#import "Escena_nivel.h"
#import "gameCenterManager.h"

@interface Escena_mundos(){
    bool isPhone;
    gameCenterManager *gc1;
    SKSpriteNode *bt_atras;
}

@end

@implementation Escena_mundos

-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc conAudioPlayer:(AVAudioPlayer*)audio{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        //[audio stop];
        self.backgroundColor = [SKColor clearColor];
        gc1=gc;
        self.ap1=audio;
        bt_atras=[SKSpriteNode spriteNodeWithImageNamed:@"bt_atras"];
        bt_atras.position=CGPointMake(CGRectGetMinX(self.frame)+60, CGRectGetMaxY(self.frame)-60);
        bt_atras.name=@"atras";
        bt_atras.zPosition=150;
        bt_atras.alpha=0.0f;
        [self addChild:bt_atras];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(alphaAtras)
                                                     name:@"anadirAtras"
                                                   object:nil];
    }
    return self;
}

-(void)alphaAtras{
    bt_atras.alpha=1.0f;
    
}

-(void)willMoveFromView:(SKView *)view{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"eliminarAtras" object:nil];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *nodo=[self nodeAtPoint:location];
        if([nodo.name isEqualToString:@"atras"]){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"borrar" object:self];
            [self.ap1 stop];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"borrarFondo" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eliminarAtras" object:nil];
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:1.0];
            SKScene * gameOverScene = [[Escena_menu alloc] initWithSize:self.size conGameCenter:gc1];
            [self.view presentScene:gameOverScene transition:reveal];
            
        }
    }
}






@end
