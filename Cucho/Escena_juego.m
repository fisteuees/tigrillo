//
//  Escena_juego.m
//  Cucho Run
//
//  Created by FISTE on 29/7/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_juego.h"
#import "JSTileMap.h"
#import "Jugador.h"
#import "SKTUtils.h"
#import "EfectoParallax.h"
#import <AVFoundation/AVFoundation.h>
#import "conexionBase.h"
#import "Escena_menu.h"

@interface Escena_juego ()
{
    NSTimeInterval delta;
    BOOL salto_doble;
    int contar_monedas;
    //conexionBase *con;
    NSNumber *contador;
    double espacio_movimiento;
    int contador_vidas;
    SKLabelNode *con_monedas;
    SKSpriteNode *corazon1;
    SKSpriteNode *corazon2;
    SKSpriteNode *corazon3;
    SKSpriteNode *pausa;
    SKSpriteNode *menu_pausa;
    SKAction *action;
    SKAction *accion_reanudar;
    int lugar_actual;
    int lugar_anterior;
    int transmision;
    BOOL pausado;
    int termino;
    UIView *oscuro;
    UIView *vpausa;
    UILabel *prueba_mensaje;
    NSTimer *tiempo_reanudar;
    NSString *strTiempo;
    NSNumber *cont_tiempo;
    NSArray *cuchoCaminando;
    
}
@end

@implementation Escena_juego
@synthesize tiempo;

/*-(id)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        
    }
    return self;
}*/
//-(id)initWithSize:(CGSize)size withBase:(conexionBase *)cb{
-(id)initWithSize:(CGSize)size{
    //con = cb; pendiente para base de datos
    if (self = [super initWithSize:size]) {
        //
        espacio_movimiento = 4;
        contador_vidas = 2;
        lugar_anterior = 0;
        pausado = NO;
        lugar_actual = espacio_movimiento;
        termino = 0;
        //
        //NOTIFICACIONES PARA IR Y VOLVER DE PAUSA
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pausar_prueba)
         name:UIApplicationWillResignActiveNotification
         object:nil];
        //
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(reanudar)
         name:UIApplicationDidBecomeActiveNotification
         object:nil];
        //FIN DE NOTIFICACIONES
        self.userInteractionEnabled = YES;
        /*
        self.fondo0=[[EfectoParallax alloc]initWithBackground:@"fondo0" size:size speed:1.0];
        self.fondo0.zPosition=-3;
        [self addChild:self.fondo0];
        self.fondo1=[[EfectoParallax alloc]initWithBackground:@"fondo1" size:size speed:1.5];
        self.fondo1.zPosition=-2;
        [self addChild:self.fondo1];
         */
        
        con_monedas = [[SKLabelNode alloc] initWithFontNamed:@"Verdana"];
        [con_monedas setFontSize:20];
        con_monedas.position = CGPointMake(CGRectGetMaxX(self.frame)-50, CGRectGetMaxY(self.frame)-35);
        [self addChild:con_monedas];
        
        //PARA VIDAS
        corazon1 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon1.position = CGPointMake(CGRectGetMinX(self.frame)+10, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon1];
        
        corazon2 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon2.position = CGPointMake(CGRectGetMinX(self.frame)+30, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon2];
        
        corazon3 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon3.position = CGPointMake(CGRectGetMinX(self.frame)+50, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon3];
        
        pausa = [[SKSpriteNode alloc] initWithImageNamed:@"images.png"];
        pausa.position = CGPointMake(CGRectGetMinX(self.frame)+80, CGRectGetMaxY(self.frame)-35);
        pausa.name = @"pausa";
        [self addChild:pausa];
        //FIN PARA VIDAS
        
        
        
        self.mapa = [JSTileMap mapNamed:@"w2_lvl1.tmx"]; //cambiar aquí nombre de mapa
        self.mapa.zPosition=99;
        [self addChild:self.mapa];
        self.suelo = [self.mapa layerNamed:@"Suelo"]; //revisar nombre de capas
        self.rocas = [self.mapa layerNamed:@"Obstaculos"]; //y pide x20
        self.monedas = [self.mapa layerNamed:@"Monedas"];
        self.iman = [self.mapa layerNamed:(@"Iman")];
        self.multiplicador = [self.mapa layerNamed:(@"Multiplicador")];
        self.escudo = [self.mapa layerNamed:(@"Escudo")];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"cuchoAnimacion"];
        SKTexture *f1 = [atlas textureNamed:@"cucho01.png"];
        SKTexture *f2 = [atlas textureNamed:@"cucho02.png"];
        SKTexture *f3 = [atlas textureNamed:@"cucho03.png"];
        SKTexture *f4 = [atlas textureNamed:@"cucho04.png"];
        SKTexture *f5 = [atlas textureNamed:@"cucho05.png"];
        SKTexture *f6 = [atlas textureNamed:@"cucho06.png"];
        SKTexture *f7 = [atlas textureNamed:@"cucho07.png"];
        cuchoCaminando = @[f1,f2,f3,f4,f5,f6,f7];
        
        self.jugador = [[Jugador alloc] initWithImageNamed:@"cucho01.png"];
        self.jugador.position = CGPointMake(50, 230);
        self.jugador.zPosition = 100;
        self.jugador.modo=1;
        self.jugador.puede_moverse=NO;
        [self.mapa addChild:self.jugador];
        
        SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
        [self.jugador runAction:[SKAction repeatActionForever:walkAnimation]];

        
        //BOTON DE PAUSA
        menu_pausa = [[SKSpriteNode alloc] initWithImageNamed:@"orange-round-play-button.png"];
        menu_pausa.position = CGPointMake(100, 100);
        menu_pausa.hidden = YES;
        menu_pausa.zPosition = 101;
        menu_pausa.name = @"reanuda";
        [self addChild:menu_pausa];
        //FIN BOTON DE PAUSA
        
        //RETORNO PAUSA
        
        
        
        
        //FIN RETORNO PAUSA
        
        action = [SKAction runBlock:^{
            [menu_pausa setHidden:NO];
            NSLog(@"salio la imagen");
            
        }];
        
        /*NSString *path = [[NSBundle mainBundle] pathForResource:@"MyParticle"
         ofType:@"sks"];
         SKEmitterNode *particula = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
         particula.position=CGPointMake(-20, 0);
         [self.jugador addChild:particula];*/
        
        
        
        
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saltoDoble)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTap];
}

- (void)saltoDoble{
    if (salto_doble) {
        self.jugador.enPiso=YES;
        self.jugador.puede_saltar=YES;
        [self.jugador update:delta];
        self.jugador.salto_doble=YES;
        [self.jugador update:delta];
    }
    self.jugador.puede_saltar=NO;
    salto_doble=NO;
}

-(void)update:(CFTimeInterval)currentTime {
    if (self.juegoTermino) return;
    if (self.mapa.position.x<-6500) {
        [self juegoTerminado:1];
    }
    delta = currentTime - self.tiempoAnterior;
    //3
    if (delta > 0.02) {
        delta = 0.02;
    }
    //4
    self.tiempoAnterior = currentTime;
    //5
    [self setViewpointCenter:CGPointMake(0, CGRectGetMidY(self.frame))];
    [self.jugador update:delta];
    [self.fondo0 update:delta];
    [self.fondo1 update:delta];
    
    [self comprobarColisiones:self.jugador porCapas:self.suelo];
    if (espacio_movimiento!=4) {
        //NSLog(@"No se comprueban colisiones v:%f",tiempo_movimiento);
    }else{
        [self comprobarColisionesTrampas:self.jugador porCapas:self.rocas];
    }
    [self comprobarColisionesMonedas:self.jugador porCapas:self.monedas];
    
    
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch  locationInNode:self];
        SKNode *nodo=[self nodeAtPoint:location];
        self.jugador.puede_saltar=YES;
        NSLog(@"saltando");
        if([nodo.name isEqualToString:@"salir"]){
            SKTransition *reveal = [SKTransition doorsCloseVerticalWithDuration:1.0];
            //Cambiar aquí para ir a la otra pantalla
            //SKScene * gameOverScene = [[Menu alloc] initWithSize:self.size withBase:con];
            //[self.view presentScene:gameOverScene transition: reveal];
        }
        else if([nodo.name isEqualToString:@"recargar"]){
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1.0];
            SKScene * gameOverScene = [[Escena_juego alloc] initWithSize:self.size]; //withBase: cb
            [self.view presentScene:gameOverScene transition: reveal];
        }
        else if ([nodo.name isEqualToString:@"pausa"]){

            if(self.scene.view.paused){

            }else{
                [tiempo_reanudar invalidate];
                pausado=YES;
                self.jugador.puede_saltar=NO;
                salto_doble = YES;
                cont_tiempo = [NSNumber numberWithInt:3];
                [self pausar];
            }
            
            
        }else if ([nodo.name isEqualToString:@"reanuda"]){
            if(self.scene.view.paused && pausado){
                pausado = NO;
                menu_pausa.hidden = YES;
                vpausa = [[UIView alloc] initWithFrame:self.frame];
                [vpausa setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
                [self.scene.view addSubview:vpausa];
                //
                prueba_mensaje = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
                [prueba_mensaje setText:@"3"];
                [vpausa addSubview:prueba_mensaje];
                [tiempo_reanudar invalidate];
                tiempo_reanudar = [NSTimer scheduledTimerWithTimeInterval:0.67 target:self selector:@selector(disminuirTiempo) userInfo:nil repeats:YES];
            }
        }
        
    }
    
}

#pragma mark metodoPausa

-(void)pausar{
    
    if (self.scene.view.paused) {
        
    }else{
        //        oscuro = [[UIView alloc] initWithFrame:self.frame];
        //        [oscuro setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
        //        [self.scene.view addSubview:oscuro];
        //        [self.scene.view sendSubviewToBack:oscuro];
        pausado = YES;
        NSLog(@"SE pausa");
        [menu_pausa runAction:action completion:^{
            [self.scene.view setPaused:YES];
            NSLog(@"Se pausa 2");
        }];
    }
}

-(void)pausar_prueba{
    cont_tiempo = [NSNumber numberWithInt:3];
    NSLog(@"de llegar llega");
    if (self.scene.view.paused) {
        
    }else{
        [menu_pausa setHidden:NO];
        [self.scene.view setPaused:YES];
        NSLog(@"se pausa");
    }
    
    
}

-(void)reanudar{
    pausado = NO;
    cont_tiempo = [NSNumber numberWithInt:3];
    [tiempo_reanudar invalidate];
    action = [SKAction runBlock:^{
        [menu_pausa setHidden:NO];
        NSLog(@"salio la imagen");
        
    }];
    NSLog(@"%i",termino);
    if(termino == 0){
        NSLog(@"Entre en 0 : %i",termino);
        [self.scene.view setPaused:NO];
        NSLog(@"Se despausa");
        [menu_pausa runAction:action completion:^{
            [self.scene.view setPaused:YES];
            NSLog(@"Se vuelve a pausar");
        }];
    }else if(termino==1){
        NSLog(@"Entre a 1");
        [self.scene.view setPaused:NO];
    }
}

-(void)disminuirTiempo{
    if(cont_tiempo.intValue > 1){
        cont_tiempo = [NSNumber numberWithInt:cont_tiempo.intValue-1];
        strTiempo = [NSString stringWithFormat:@"%i",cont_tiempo.intValue];
        [prueba_mensaje setText:strTiempo];
        NSLog(@"%i",cont_tiempo.intValue);
    }else{
        self.jugador.puede_saltar = NO;
        //salto_doble = YES;
        self.scene.view.paused = NO;
        
        [vpausa setHidden:YES];
        [prueba_mensaje setHidden:YES];
        cont_tiempo = [NSNumber numberWithInt:3];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch  locationInNode:self];
        SKNode *nodo=[self nodeAtPoint:location];
        self.jugador.puede_saltar=NO;
    }
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
    float levelHeightInPixels = self.mapa.mapSize.height * self.mapa.tileSize.height;
    CGPoint origin = CGPointMake(tileCoords.x * self.mapa.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * self.mapa.tileSize.height));
    return CGRectMake(origin.x, origin.y, self.mapa.tileSize.width, self.mapa.tileSize.height);
}

- (NSInteger)tileGIDAtTileCoord:(CGPoint)coord forLayer:(TMXLayer *)layer {
    TMXLayerInfo *layerInfo = layer.layerInfo;
    return [layerInfo tileGidAtCoord:coord];
}

#pragma mark Colisiones

- (void)comprobarColisionesMonedas:(Jugador *)jugador porCapas:(TMXLayer *)capa {
    NSInteger indices[8] = {7, 1, 3, 5, 0, 2, 6, 8};
    for (NSUInteger i = 0; i < 8; i++) {
        NSInteger indice = indices[i];
        
        //2
        CGRect areaJugador = [jugador rectanguloColision];
        //3
        CGPoint posiJugador = [capa coordForPoint:jugador.posicionDeseada];
        //4
        NSInteger tileColumn = indice % 3;
        NSInteger tileRow = indice / 3;
        CGPoint posiTile = CGPointMake(posiJugador.x + (tileColumn - 1), posiJugador.y + (tileRow - 1));
        //5
        NSInteger gid = [self tileGIDAtTileCoord:posiTile forLayer:capa];
        //6
        if (gid) {
            
            //7
            CGRect areaTile = [self tileRectFromTileCoords:posiTile];
            //1
            if (CGRectIntersectsRect(areaJugador, areaTile)) {
                [self.monedas removeTileAtCoord:posiTile];
                //[self runAction:[SKAction playSoundFileNamed:@"coin.mp3" waitForCompletion:NO]];
                contar_monedas++;
                con_monedas.text = [NSString stringWithFormat:@"%i",contar_monedas];
            }
        }
    }
}

- (void)comprobarColisionesTrampas:(Jugador *)jugador porCapas:(TMXLayer *)capa {
    NSInteger indices[8] = {7, 1, 3, 5, 0, 2, 6, 8};
    for (NSUInteger i = 0; i < 8; i++) {
        NSInteger indice = indices[i];
        
        //2
        CGRect areaJugador = [jugador rectanguloColision];
        //3
        CGPoint posiJugador = [capa coordForPoint:jugador.posicionDeseada];
        //4
        NSInteger tileColumn = indice % 3;
        NSInteger tileRow = indice / 3;
        CGPoint posiTile = CGPointMake(posiJugador.x + (tileColumn - 1), posiJugador.y + (tileRow - 1));
        //5
        NSInteger gid = [self tileGIDAtTileCoord:posiTile forLayer:capa];
        //6
        if (gid) {
            
            //7
            CGRect areaTile = [self tileRectFromTileCoords:posiTile];
            //1
            if (CGRectIntersectsRect(areaJugador, areaTile)) {
                //[self.rocas removeTileAtCoord:posiTile];
                //  para terminar el juego
                //[self juegoTerminado:0];
                //
                //NSLog(@"%d",contador_vidas);
                if (contador_vidas > 0) {
                    contador = [NSNumber numberWithInt:0];
                    [self.tiempo invalidate];
                    self.tiempo = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(chocar) userInfo:nil repeats:YES];
                    espacio_movimiento = 2;
                    
                }else{
                    [corazon1 setHidden:YES];
                    [self juegoTerminado:0];
                }
                
                
                
                
            }
        }
    }
}

-(void)chocar
{
    
    if (contador.intValue<1) {
        //self.mapa.position = CGPointMake(self.mapa.position.x-1, self.mapa.position.y);
        //self.jugador.position= CGPointMake(self.jugador.position.x+1, self.jugador.position.y);
        espacio_movimiento = 3;
        contador = [NSNumber numberWithInt:[contador intValue]+1];
        //NSLog(@"Menor a 2");
        contador_vidas--;
        
    }else{
        //self.mapa.position = CGPointMake(self.mapa.position.x-4, self.mapa.position.y);
        //self.jugador.position= CGPointMake(self.jugador.position.x+4, self.jugador.position.y);
        espacio_movimiento = 4;
        
    }
    // Your Code
    
    
}

- (void)comprobarColisiones:(Jugador *)jugador porCapas:(TMXLayer *)capa {
    //1
    NSInteger indices[8] = {7, 1, 3, 5, 0, 2, 6, 8};
    jugador.enPiso = NO;
    for (NSUInteger i = 0; i < 8; i++) {
        NSInteger indice = indices[i];
        
        //2
        CGRect areaJugador = [jugador rectanguloColision];
        //3
        CGPoint posiJugador = [capa coordForPoint:jugador.posicionDeseada];
        //4
        NSInteger tileColumn = indice % 3;
        NSInteger tileRow = indice / 3;
        CGPoint posiTile = CGPointMake(posiJugador.x + (tileColumn - 1), posiJugador.y + (tileRow - 1));
        //5
        
        NSInteger gid = [self tileGIDAtTileCoord:posiTile forLayer:capa];
        //6
        if (gid) {
            //7
            CGRect areaTile = [self tileRectFromTileCoords:posiTile];
            //1
            if (CGRectIntersectsRect(areaJugador, areaTile)) {
                CGRect intersection = CGRectIntersection(areaJugador, areaTile);
                //2
                if (indice == 7) {
                    //tile is directly below Koala
                    jugador.posicionDeseada = CGPointMake(jugador.posicionDeseada.x, jugador.posicionDeseada.y + intersection.size.height);
                    jugador.velocity = CGPointMake(jugador.velocity.x, 0.0);
                    jugador.enPiso = YES;
                    salto_doble=YES;
                } else if (indice  == 1) {
                    //tile is directly above Koala
                    jugador.posicionDeseada = CGPointMake(jugador.posicionDeseada.x, jugador.posicionDeseada.y - intersection.size.height);
                } else if (indice  == 3) {
                    //tile is left of Koala
                    jugador.posicionDeseada = CGPointMake(jugador.posicionDeseada.x + intersection.size.width, jugador.posicionDeseada.y);
                } else if (indice  == 5) {
                    //tile is right of Koala
                    jugador.posicionDeseada = CGPointMake(jugador.posicionDeseada.x - intersection.size.width, jugador.posicionDeseada.y);
                    //3
                } else {
                    if (intersection.size.width > intersection.size.height) {
                        //tile is diagonal, but resolving collision vertically
                        //4
                        jugador.velocity = CGPointMake(jugador.velocity.x, 0.0);
                        float intersectionHeight;
                        if (indice > 4) {
                            intersectionHeight = intersection.size.height;
                            jugador.enPiso = YES;
                        } else {
                            intersectionHeight = -intersection.size.height;
                        }
                        jugador.posicionDeseada = CGPointMake(jugador.posicionDeseada.x, jugador.posicionDeseada.y + intersection.size.height );
                    } else {
                        //tile is diagonal, but resolving horizontally
                        float intersectionWidth;
                        if (indice == 6 || indice == 0) {
                            intersectionWidth = intersection.size.width;
                        } else {
                            intersectionWidth = -intersection.size.width;
                        }
                        jugador.posicionDeseada = CGPointMake(jugador.posicionDeseada.x  + intersectionWidth, jugador.posicionDeseada.y);
                    }
                }
            }
        }
    }
    //5
    jugador.position = jugador.posicionDeseada;
}


-(void)juegoTerminado:(BOOL)gano {
    //
    [self.tiempo invalidate];
    pausa.hidden = YES;
    termino = 1;
    [self.jugador removeAllActions];
    //
    self.juegoTermino=YES;
    SKLabelNode *mensaje=[SKLabelNode labelNodeWithFontNamed:@"Arial"];
    mensaje.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+30);
    mensaje.fontSize=50.0f;
    mensaje.fontColor=[SKColor blackColor];
    
    SKSpriteNode *bt_recargar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_recargar"];
    bt_recargar.position=CGPointMake(CGRectGetMidX(self.frame)+50, CGRectGetMidY(self.frame)-40);
    bt_recargar.name=@"recargar";
    bt_recargar.zPosition=102;
    
    SKSpriteNode *bt_salir=[SKSpriteNode spriteNodeWithImageNamed:@"bt_salir"];
    bt_salir.position=CGPointMake(CGRectGetMidX(self.frame)-80, CGRectGetMidY(self.frame)-40);
    bt_salir.name=@"salir";
    bt_salir.zPosition=103;
    if(gano){
        NSLog(@"ganaste");
        mensaje.text=@"Ganaste!";
        //Para base
        //conexionBase *cb;// = [[conexionBase alloc] init];
        //[con insert:contar_monedas];
        ///-----------------------------Nuevo en base de datos
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:contar_monedas] forKey:@"total"];
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"insertBase" object:self userInfo:userInfo];
        //------------------------
        contar_monedas = 0;
        contador_vidas = 2;
        //Fin para base
    }else{
        NSLog(@"perdiste");
        mensaje.text=@"Perdiste";
        contador_vidas = 2;
    }
    [self addChild:mensaje];
    [self addChild:bt_salir];
    [self addChild:bt_recargar];
    
    [mensaje runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction scaleTo:1.5 duration:1.0],[SKAction scaleTo:0.5 duration:1.0]]]]];
}

- (void)setViewpointCenter:(CGPoint)position {
    //v=e/t;
    //e=6400 px
    //self.suelo.position = CGPointMake(self.suelo.position.x-4, self.suelo.position.y);
    //self.rocas.position = CGPointMake(self.rocas.position.x-4, self.rocas.position.y);
    //self.fondo.position = CGPointMake(self.fondo.position.x-1, self.fondo.position.y);
    lugar_anterior = lugar_actual;
    lugar_actual = espacio_movimiento;
    //NSLog(@"ac: %i an: %i",lugar_anterior,lugar_actual);
    if (lugar_actual == 2 && lugar_anterior==4) {
        //NSLog(@"%d",contador_vidas);
        if (contador_vidas == 2) {
            [corazon3 setHidden:YES];
        }
        if (contador_vidas == 1) {
            [corazon2 setHidden:YES];
        }
    }
    self.mapa.position = CGPointMake(self.mapa.position.x-espacio_movimiento, self.mapa.position.y);
    self.jugador.position= CGPointMake(self.jugador.position.x+espacio_movimiento, self.jugador.position.y);
    
    //NSLog(@"posicion mapa %.f",self.mapa.position.x);
    //NSLog(@"posicion jugador %.f",self.jugador.position.x);
    
    
}

@end
