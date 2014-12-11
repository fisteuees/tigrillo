//
//  Escena_menu.m
//  Cucho
//
//  Created by Centro de Investigaciones on 29/05/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_menu.h"
#import "gameCenterManager.h"
#import "Escena_mundos.h"
#import "View_ajustes.h"
#import <QuartzCore/QuartzCore.h>

@interface Escena_menu(){
    
    bool isPhone;
    
    
    gameCenterManager *gc1;
}

@end

@implementation Escena_menu

-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        gc1=gc;
        self.backgroundColor = [SKColor whiteColor];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            isPhone = YES;
            
        } else {
            
            isPhone = NO;
            
        }
        
        SKSpriteNode *bt_puntajes=[SKSpriteNode spriteNodeWithImageNamed:@"BTpuntajes"];//crear boton puntajes, va en el lado izquierdo inferior de la pantalla
        bt_puntajes.position=CGPointMake(90, 50);
        bt_puntajes.name=@"bt_puntajes";//se le asigna un nombre para saber que fué seleccionado
        [self addChild:bt_puntajes];
        
        SKSpriteNode *bt_jugar=[SKSpriteNode spriteNodeWithImageNamed:@"BTjugar"];//crear boton jugar, va en el centro inferior de la pantalla
        bt_jugar.position=CGPointMake(CGRectGetMidX(self.frame), 50);
        bt_jugar.name=@"bt_jugar";//se le asigna un nombre para saber que fué seleccionado
        [self addChild:bt_jugar];
        
        /*SKSpriteNode *bt_comprar=[SKSpriteNode spriteNodeWithImageNamed:@"BTcomprar"];//crear boton carrito de compras, va en el lado derecho inferior de la pantalla
         bt_comprar.position=CGPointMake(CGRectGetMaxX(self.frame)-90, 50);
         bt_comprar.name=@"bt_comprar";//se le asigºna un nombre para saber que fué seleccionado
         [self addChild:bt_comprar];*/
        
        SKSpriteNode *bt_ajustes=[SKSpriteNode spriteNodeWithImageNamed:@"BTajustes"];//crear boton carrito de compras, va en el lado derecho inferior de la pantalla
        bt_ajustes.position=CGPointMake(CGRectGetMaxX(self.frame)-90,CGRectGetMaxY(self.frame)-50);
        bt_ajustes.name=@"bt_ajustes";//se le asigna un nombre para saber que fué seleccionado
        [self addChild:bt_ajustes];
        
        /*SKAction *s_fondo=[SKAction playSoundFileNamed:@"s_fondo_menu.mp3" waitForCompletion:NO];
         [self runAction:s_fondo withKey:@"fondo"];*/
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/s_fondo_menu.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.audioPlayer.numberOfLoops = -1;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        
        if ([defaults integerForKey:@"estadoSwitch1"]==1) {
            if (!self.audioPlayer)
                NSLog([error localizedDescription]);
            else
                [self.audioPlayer play];
        }
        [defaults synchronize];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *nodo=[self nodeAtPoint:location];
        if([nodo.name isEqualToString:@"bt_puntajes"]){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"mostrarGCController" object:self];
        }
        if([nodo.name isEqualToString:@"bt_jugar"]){
            SKTransition *reveal = [SKTransition doorwayWithDuration:1.0];
            SKScene * gameOverScene = [[Escena_mundos alloc] initWithSize:self.size conGameCenter:gc1 conAudioPlayer:self.audioPlayer];
            NSLog(@"size: %@",NSStringFromCGSize(self.size));
            [self.view presentScene:gameOverScene transition:reveal];
        }
        if([nodo.name isEqualToString:@"bt_comprar"]){
            
        }
        if([nodo.name isEqualToString:@"bt_ajustes"]){
            CGRect rect;
            NSLog(@"mostrar ajustes");
            if (isPhone == YES) {
                
                rect = CGRectMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame), 230, 150);
                
                
            } else {
                
                
            }
            //if (!desplegado) {
            [self setUserInteractionEnabled:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarAjustes" object:self];
            
            //}
            
            
            /*[UIView animateWithDuration:1.25 animations:^{
             [self.view addSubview:ajustes];
             }];*/
            
        }
    }
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)willMoveFromView:(SKView *)view{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"anadir" object:self];
}

@end
