//
//  Jugador.m
//  Cucho Run
//
//  Created by FISTE on 01/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Jugador.h"
#import "SKTUtils.h"

@implementation Jugador

- (instancetype)initWithImageNamed:(NSString *)name {
    if (self == [super initWithImageNamed:name]) {
        self.velocity = CGPointMake(0.0, 0.0);
    }
    return self;
}

- (void)update:(NSTimeInterval)delta {
    //3
    if (self.modo==0) {
        CGPoint gravity = CGPointMake(0.0, -650.0);
        //4
        CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta);
        CGPoint moverX = CGPointMake(800.0, 0.0);
        CGPoint moverXcon = CGPointMultiplyScalar(moverX, delta);
        //5
        self.velocity = CGPointAdd(self.velocity, gravityStep);
        self.velocity = CGPointMake(self.velocity.x * 0.9, self.velocity.y);
        CGPoint jumpForce = CGPointMake(0.0, 500.0);
        float corteVelocidad = 150.0;
        
        if (self.puede_moverse) {
            self.velocity = CGPointAdd(self.velocity, moverXcon);
        }
        if ((self.puede_saltar && self.enPiso) || self.salto_doble) {
            self.velocity = CGPointAdd(self.velocity, jumpForce);
        }
        else if (!self.puede_saltar && self.velocity.y > corteVelocidad) {
            self.velocity = CGPointMake(self.velocity.x, corteVelocidad);
        }
        CGPoint minMovement = CGPointMake(0.0, -450);
        CGPoint maxMovement = CGPointMake(120.0, 250.0);
        self.velocity = CGPointMake(Clamp(self.velocity.x, minMovement.x, maxMovement.x), Clamp(self.velocity.y, minMovement.y, maxMovement.y));
        CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
        //6
        self.posicionDeseada = CGPointAdd(self.position, velocityStep);
    }
    else if (self.modo==1) {
        CGPoint gravity = CGPointMake(0.0, -650.0);
        //4
        CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta);
        CGPoint moverX = CGPointMake(800.0, 0.0);
        CGPoint moverXcon = CGPointMultiplyScalar(moverX, delta);
        //5
        self.velocity = CGPointAdd(self.velocity, gravityStep);
        self.velocity = CGPointMake(self.velocity.x * 0.9, self.velocity.y);
        CGPoint jumpForce = CGPointMake(0.0, 500.0);
        
        if (self.puede_moverse) {
            self.velocity = CGPointAdd(self.velocity, moverXcon);
        }
        if (self.puede_saltar && self.enPiso) {
            self.velocity = CGPointAdd(self.velocity, jumpForce);
        }
        CGPoint minMovement = CGPointMake(0.0, -450);
        CGPoint maxMovement = CGPointMake(250.0, 350.0);
        self.velocity = CGPointMake(Clamp(self.velocity.x, minMovement.x, maxMovement.x), Clamp(self.velocity.y, minMovement.y, maxMovement.y));
        CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
        //6
        self.posicionDeseada = CGPointAdd(self.position, velocityStep);
    }
    
}

-(CGRect)rectanguloColision{
    CGRect boundingBox= CGRectInset(self.frame, 10, 10);
    CGPoint diferencia = CGPointSubtract(self.posicionDeseada, self.position);
    return CGRectOffset(boundingBox, diferencia.x, diferencia.y);
}

@end
