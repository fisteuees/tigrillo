//
//  Jugador.h
//  Cucho Run
//
//  Created by FISTE on 01/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Jugador : SKSpriteNode

@property (nonatomic, assign) CGPoint velocity;
@property (nonatomic, assign) CGPoint posicionDeseada;
@property (nonatomic, assign) BOOL enPiso;
@property (nonatomic, assign) BOOL puede_moverse;
@property (nonatomic, assign) BOOL puede_saltar;
@property (nonatomic, assign) BOOL modo;
@property (nonatomic, assign) BOOL salto_doble;

- (void)update:(NSTimeInterval)delta;
-(CGRect)rectanguloColision;

@end
