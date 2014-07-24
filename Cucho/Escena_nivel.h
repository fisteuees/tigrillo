//
//  Escena_nivel.h
//  Cucho Run
//
//  Created by FISTE on 08/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "JSTileMap.h"
#import "EfectoParallax.h"
#import "Jugador.h"

@interface Escena_nivel : SKScene

@property (strong, nonatomic) JSTileMap *mapa;
@property (strong, nonatomic) Jugador *jugador;

@property (nonatomic, strong) TMXLayer *suelo;
@property (nonatomic, strong) TMXLayer *rocas;
@property (nonatomic, strong) TMXLayer *fondo;
@property (nonatomic, strong) TMXLayer *monedas;
@property (nonatomic, strong) TMXLayer *power_ups;

@property (nonatomic, strong) EfectoParallax *fondo0;
@property (nonatomic, strong) EfectoParallax *fondo1;

@property (nonatomic, assign) NSTimeInterval tiempoAnterior;
@property (nonatomic, assign) BOOL juegoTermino;

@end
