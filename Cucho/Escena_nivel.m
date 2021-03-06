//
//  Escena_nivel.m
//  Cucho Run
//
//  Created by FISTE on 08/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_nivel.h"
#import "Escena_juego.h"
#import "gameCenterManager.h"
#import "Escena_mundos.h"

@interface Escena_nivel(){
    bool isPhone,atras;
    NSArray *cuchoCaminando;
    SKSpriteNode *cucho;
    gameCenterManager *gc1;
}

@end

@implementation Escena_nivel

-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc{
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];

        gc1=gc;
        
        SKSpriteNode *bt_atras=[SKSpriteNode spriteNodeWithImageNamed:@"bt_atras"];
        bt_atras.position=CGPointMake(CGRectGetMinX(self.frame)+60, CGRectGetMaxY(self.frame)-60);
        bt_atras.name=@"atras";
        [self addChild:bt_atras];
        
        SKSpriteNode *bt_nivel1=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel1"];
        bt_nivel1.position=CGPointMake(60, 60);
        bt_nivel1.name=@"nivel1";
        [self addChild:bt_nivel1];
        
        SKSpriteNode *bt_nivel2=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel2"];
        bt_nivel2.position=CGPointMake(290, 260);
        bt_nivel2.name=@"nivel2";
        [self addChild:bt_nivel2];
        
        SKSpriteNode *bt_nivel3=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel3"];
        bt_nivel3.position=CGPointMake(460, 80);
        bt_nivel3.name=@"nivel3";
        [self addChild:bt_nivel3];
        
        SKSpriteNode *bt_nivel4=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel4"];
        bt_nivel4.position=CGPointMake(660, 460);
        bt_nivel4.name=@"nivel4";
        [self addChild:bt_nivel4];
        
        SKSpriteNode *bt_nivel5=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel5"];
        bt_nivel5.position=CGPointMake(860, 660);
        bt_nivel5.name=@"nivel5";
        [self addChild:bt_nivel5];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"cuchoNiveles"];
        SKTexture *f1 = [atlas textureNamed:@"cucho-1.png"];
        SKTexture *f2 = [atlas textureNamed:@"cucho-2.png"];
        SKTexture *f3 = [atlas textureNamed:@"cucho-3.png"];
        cuchoCaminando = @[f1,f2,f3];
        
        cucho=[SKSpriteNode spriteNodeWithImageNamed:@"cucho-1"];
        cucho.position=CGPointMake(60, 60);
        cucho.name=@"cucho";
        [self addChild:cucho];

        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    NSLog(@"se movio");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *nodo=[self nodeAtPoint:location];
        if([nodo.name isEqualToString:@"nivel2"]){
            SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
            [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
            [cucho runAction:[SKAction moveTo:location duration:2.5]completion:^{
                [cucho removeAllActions];
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:1.0];
                SKScene * gameOverScene = [[Escena_juego alloc] initWithSize:self.size];
                [self.view presentScene:gameOverScene transition:reveal];
            
            }];
            
        }
        else if([nodo.name isEqualToString:@"nivel3"]){
            SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
            [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
            [cucho runAction:[SKAction moveTo:location duration:2.5]completion:^{[cucho removeAllActions];}];
            
        }
        else if([nodo.name isEqualToString:@"nivel4"]){
            SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
            [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
            [cucho runAction:[SKAction moveTo:location duration:2.5]completion:^{[cucho removeAllActions];}];
            
        }
        else if([nodo.name isEqualToString:@"nivel5"]){
            SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
            [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
            [cucho runAction:[SKAction moveTo:location duration:2.5]completion:^{[cucho removeAllActions];}];
            
        }
        else if([nodo.name isEqualToString:@"atras"]){
            atras=YES;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"borrar" object:self];
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:1.0];
            SKScene * gameOverScene = [[Escena_mundos alloc] initWithSize:self.size conGameCenter:gc1];
            [self.view presentScene:gameOverScene transition:reveal];
        }
    }
    
}

-(void)willMoveFromView:(SKView *)view{
    if (atras) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"anadir" object:self];
    }
    
}



@end
