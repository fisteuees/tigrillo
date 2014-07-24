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
    View_ajustes *ajustes;
    bool isPhone;
    UIView *mask;
    BOOL desplegado;
}

@end

@implementation Escena_menu

-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc{
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cerrarVentanaAjustes:)
                                                     name:@"cerrar"
                                                   object:nil];
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
        
        SKSpriteNode *bt_comprar=[SKSpriteNode spriteNodeWithImageNamed:@"BTcomprar"];//crear boton carrito de compras, va en el lado derecho inferior de la pantalla
        bt_comprar.position=CGPointMake(CGRectGetMaxX(self.frame)-90, 50);
        bt_comprar.name=@"bt_comprar";//se le asigºna un nombre para saber que fué seleccionado
        [self addChild:bt_comprar];
        
        SKSpriteNode *bt_ajustes=[SKSpriteNode spriteNodeWithImageNamed:@"BTajustes"];//crear boton carrito de compras, va en el lado derecho inferior de la pantalla
        bt_ajustes.position=CGPointMake(CGRectGetMaxX(self.frame)-90,CGRectGetMaxY(self.frame)-50);
        bt_ajustes.name=@"bt_ajustes";//se le asigna un nombre para saber que fué seleccionado
        [self addChild:bt_ajustes];
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
            SKTransition *reveal = [SKTransition doorwayWithDuration:1.5];
            SKScene * gameOverScene = [[Escena_mundos alloc] initWithSize:self.size];
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
                
                rect = CGRectMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame), 364, 492);
            }
            if (!desplegado) {
                
                ajustes = [[View_ajustes alloc] initWithFrame:rect];
                ajustes.layer.anchorPoint = CGPointMake(1, 1);
                ajustes.alpha=0.0f;
                [ajustes setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
                [self.view addSubview:ajustes];
                //ajustes.center = CGPointMake(ajustes.frame.size.width / 2, ajustes.frame.size.height / 2);
                [UIView animateWithDuration:0.5
                                      delay: 0.0
                                    options: UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [ajustes setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                                     ajustes.alpha=1.0f;
                                     
                                 }
                                 completion:^(BOOL finished){
                                     mask = [[UIView alloc] initWithFrame:self.frame];
                                     [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.38]];
                                     [self.view addSubview:mask];
                                     [self.view sendSubviewToBack:mask];
                                     desplegado=YES;
                                     
                                 }];
            }
            
            
            /*[UIView animateWithDuration:1.25 animations:^{
             [self.view addSubview:ajustes];
             }];*/
            
        }
    }
}

-(void)cerrarVentanaAjustes:(NSNotification *)notification{
    

                         mask.alpha=0.0f;
                         [mask removeFromSuperview];
    desplegado=NO;

}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)willMoveFromView:(SKView *)view{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"anadir" object:self];
}

@end
