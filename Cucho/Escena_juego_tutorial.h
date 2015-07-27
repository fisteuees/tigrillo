//
//  Escena_juego_tutorial_tutorial.h
//  Cucho Run
//
//  Created by FISTE on 29/10/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Jugador.h"
#import "JSTileMap.h"
#import "EfectoParallax.h"
#import "conexionBase.h"
#import <AVFoundation/AVFoundation.h>
#import "gameCenterManager.h"

@interface Escena_juego_tutorial : SKScene

@property (strong, nonatomic) JSTileMap *mapa;
@property (strong, nonatomic) Jugador *jugador;
@property (nonatomic, assign) NSTimeInterval tiempoAnterior;
@property (nonatomic, strong) TMXLayer *suelo;
@property (nonatomic, strong) TMXLayer *rocas;
@property (nonatomic, strong) TMXLayer *fondo;
@property (nonatomic, strong) TMXLayer *monedas;
@property (nonatomic, strong) TMXLayer *volar;
@property (nonatomic, strong) TMXLayer *escudo;
@property (nonatomic, strong) TMXLayer *multiplicador;
@property (nonatomic, strong) TMXLayer *Decoracion1;
@property (nonatomic, strong) TMXLayer *Decoracion2;
@property (nonatomic, strong) TMXLayer *Decoracion3;
@property (nonatomic, strong) TMXLayer *monedasVolar;
@property (nonatomic, strong) TMXLayer *correccion;
@property (nonatomic, strong) EfectoParallax *fondo0;
@property (nonatomic, strong) EfectoParallax *fondo1;
@property (nonatomic, assign) BOOL juegoTermino;
//


-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc conInformacion:(NSMutableDictionary *)informacion conAudioPlayer:(AVAudioPlayer *)ap;

//
@property NSTimer *tiempo;
@end
