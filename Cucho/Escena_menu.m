//
//  Escena_menu.m
//  Cucho
//
//  Created by Centro de Investigaciones on 29/05/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_menu.h"

@implementation Escena_menu

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor whiteColor];
        
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
        bt_comprar.name=@"bt_comprar";//se le asigna un nombre para saber que fué seleccionado
        [self addChild:bt_comprar];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
