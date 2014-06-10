//
//  gameCenterManager.m
//  Cucho Run
//
//  Created by FISTE on 10/06/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "gameCenterManager.h"

@implementation gameCenterManager
@synthesize gameCenterDisponible,usuarioAutenticado,vcActual,delegate,ultimoError,puntajeEnviado;

static gameCenterManager *helper=nil;

-(id)init{
    if((self=[super init])){
        NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(autenticacionCambio) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
    }
    return self;
}

+(gameCenterManager *)solicitarManager{
    if(!helper){
        helper=[[gameCenterManager alloc]init];
    }
    return helper;
}

-(void)autenticacionCambio{
    if([GKLocalPlayer localPlayer].isAuthenticated && !usuarioAutenticado){
        NSLog(@"Jugador Autenticado");
        usuarioAutenticado=TRUE;
    }
    else if(![GKLocalPlayer localPlayer].isAuthenticated && usuarioAutenticado){
        NSLog(@"Jugador NO Autenticado");
        usuarioAutenticado=FALSE;
    }
}

-(void)autenticarJugador{
    GKLocalPlayer *jugadorLocal=[GKLocalPlayer localPlayer];
    jugadorLocal.authenticateHandler = ^(UIViewController *viewController, NSError
                                         *error){
        [self setUltimoError:error];
        if (viewController != nil)
        {
            [self presentarViewController:viewController];
        }
        else if (jugadorLocal.isAuthenticated)
        {
            [self jugadorAutenticado];
        }
    };
    
}

-(void)jugadorAutenticado{
    GKLocalPlayer *jugadorLocal=[GKLocalPlayer localPlayer];
    if(jugadorLocal.isAuthenticated){
        self.usuarioAutenticado=YES;
    }
    else{
        self.usuarioAutenticado=NO;
    }
}

-(UIViewController*) obtenerViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentarViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self obtenerViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}

-(void)enviarPuntaje:(int64_t)puntaje conIdentificador:(NSString *)identificador{
    GKScore *GMpuntaje=[[GKScore alloc]initWithLeaderboardIdentifier:identificador];
    GMpuntaje.value=puntaje;
    GMpuntaje.context=0;
    NSArray *scores = @[GMpuntaje];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error reportando puntaje: %@", error);
        }
        else{}
    }];
}

-(void)enviarPuntaje:(int64_t)puntaje conLogro:(NSString*)logro conIdentificador:(NSString*)identificador{
    GKScore *GMpuntaje=[[GKScore alloc]initWithLeaderboardIdentifier:identificador];
    GMpuntaje.value=puntaje;
    GMpuntaje.context=0;
    NSArray *scores = @[GMpuntaje];
    GKAchievement *logro1=[[GKAchievement alloc]initWithIdentifier:logro];
    logro1.percentComplete=100;
    logro1.showsCompletionBanner=YES;
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"Error reportando puntaje: %@", error);
        }
        else{}
    }];
    if(logro1){
        NSArray *achievements = [NSArray arrayWithObjects:logro1, nil];
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error reportando logro: %@", error);
            }
            else{
                if(logro1.isCompleted){
                    if([logro isEqualToString:@"Puntos15000"]){
                        //[GKNotificationBanner showBannerWithTitle:@"Logro obtenido" message:@"Hiciste 15000 puntos!" completionHandler:^{}];
                        //[logro1 showsCompletionBanner];
                    }
                }
            }
            
        }];
    }
}

-(void)reportarLogro:(NSString *)identificador conPorcentaje:(float)porcentaje{
    GKAchievement *logro=[[GKAchievement alloc]initWithIdentifier:identificador];
    logro.percentComplete=porcentaje;
    logro.showsCompletionBanner=YES;
    if(logro){
        NSArray *achievements = [NSArray arrayWithObjects:logro, nil];
        [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"Error reportando logro: %@", error);
            }
            else{
                if(logro.isCompleted){
                    if([identificador isEqualToString:@"1"]){
                        //[GKNotificationBanner showBannerWithTitle:@"Logro obtenido" message:@"Jugaste 2 veces!" completionHandler:^{}];
                        //[logro showsCompletionBanner];
                    }
                    
                }
                
            }
        }];
    }
}

-(void)setUltimoError:(NSError*)error {
    ultimoError = [error copy];
    if (ultimoError) {
        NSLog(@"Error de game center: %@", [[ultimoError userInfo]
                                            description]);
    }
}

-(void)resetLogros{
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil){
             
         }
     }];
}

@end
