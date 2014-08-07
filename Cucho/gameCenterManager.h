//
//  gameCenterManager.h
//  Cucho Run
//
//  Created by FISTE on 10/06/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

@protocol GCManagerDelegate <NSObject>

-(void)puntajeEnviado:(BOOL)exito;

@end


@interface gameCenterManager : NSObject

@property (assign,readonly) BOOL gameCenterDisponible;
@property BOOL usuarioAutenticado;
@property BOOL puntajeEnviado;
@property (retain) UIViewController *vcActual;
@property (nonatomic,assign) id <GCManagerDelegate> delegate;
@property (nonatomic,readonly) NSError *ultimoError;


-(void)autenticarJugador;
-(void)jugadorAutenticado;
+(gameCenterManager*)solicitarManager;
-(void)autenticacionCambio;
-(void)setUltimoError:(NSError *)ultimoError;
-(UIViewController*)obtenerViewController;
-(void)presentarViewController:(UIViewController*)vc;
-(void)enviarPuntaje:(int64_t)puntaje conIdentificador:(NSString*)identificador;
-(void)enviarPuntaje:(int64_t)puntaje conLogro:(NSString*)logro conIdentificador:(NSString*)identificador;
-(void)reportarLogro:(NSString*)identificador conPorcentaje:(float)porcentaje;
-(void)resetLogros;


@end
