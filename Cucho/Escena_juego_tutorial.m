//
//  Escena_juego_tutorial.m
//  Cucho Run
//
//  Created by FISTE on 29/7/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_juego_tutorial.h"
#import "JSTileMap.h"
#import "Jugador.h"
#import "SKTUtils.h"
#import "EfectoParallax.h"
#import <AVFoundation/AVFoundation.h>
#import "conexionBase.h"
#import "Escena_menu.h"
#import "Escena_nivel.h"

const float maxVelocidad = 400.0f;
const float maxAceleracion = 400.0f;
const float BorderCollisionDamping = 0.5f;
const float CannonCollisionSpeed = 100.0f;

@import CoreMotion;



@interface Escena_juego_tutorial ()
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
    SKSpriteNode *menu_play,*menu_salir,*menu_recargar;
    SKSpriteNode *menu_pausa;
    SKAction *action;
    SKAction *accion_reanudar;
    int velocidad_actual;
    int velocidad_anterior;
    int transmision;
    BOOL pausado;
    BOOL volando;
    int termino;
    UIView *oscuro;
    UIView *vpausa;
    UILabel *prueba_mensaje;
    NSTimer *tiempo_reanudar;
    NSString *strTiempo;
    NSNumber *cont_tiempo;
    NSArray *cuchoCaminando;
    NSArray *cuchoVolando;
    
    
    //datosAcelerometro
    CGSize tamanoPantalla;
    UIAccelerationValue _aceX;
    UIAccelerationValue _aceY;
    CMMotionManager *_motionManager;
    float _aceleracionX;
    float _aceleracionY;
    float _velociX;
    float _velociY;
    float _radioJugador;
    float _NaveSpin;
    
    
    //slider
    UISlider *slider;
    
    //power up
    BOOL multiplica;
    int suma_x2;
    NSTimer *multi;
    NSNumber *int_mult;
    
    
    NSTimer *volar1;
    int timVolar;
    //para mapa
    NSString *nomMapa;
    BOOL colisiones;
    int vidas;
    
    
    //particula
    SKEmitterNode *myParticle;
    
    
    //animacion de caminar
    SKAction *walkAnimation;
    
    
    //tutorial
    
    int num_mensaje;
    UIView *mask_terminado;
    SKSpriteNode *fondo_oscuro;
    SKSpriteNode *mensaje;
    SKSpriteNode *bt_aceptar;
    SKSpriteNode *bt_mano;
    SKSpriteNode *bt_mano2;
    
    BOOL choque;
    BOOL choque_escudo;
    
    //Audio Player
    AVAudioPlayer *ap1;
    NSUserDefaults *defaults;
    
    
    //gesture recognizer
    UITapGestureRecognizer *doubleTap;
    
    //contador timer
    int MainInt;
    NSTimer *timer;
    
    //valores para base
    NSMutableDictionary *informacion1;
    gameCenterManager *gc1;
    
}
@end

@implementation Escena_juego_tutorial

-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc conInformacion:(NSMutableDictionary *)informacion conAudioPlayer:(AVAudioPlayer *)ap{
    //con = cb; pendiente para base de datos
    if (self = [super initWithSize:size]) {
        //
        [ap stop];
        ap1=ap;
        gc1=gc;
        informacion1=informacion;
        espacio_movimiento = 5;
        contador_vidas = 2;
        velocidad_anterior = 0;
        pausado = NO;
        velocidad_actual = espacio_movimiento;
        termino = 0;
        //PARA Power Up
        suma_x2 = 1;
        int_mult = 0;
        colisiones = YES;
        //nomMapa = mapa;
        vidas = 3;
        
        NSURL *url= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/s_fondo_bosque.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        NSError *error;
        ap1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        ap1.numberOfLoops = -1;
        
        defaults=[NSUserDefaults standardUserDefaults];
        
        if ([defaults integerForKey:@"estadoSwitch1"]==1) {
            [ap1 play];
            
        }
        [defaults synchronize];
        
        //
        //NOTIFICACIONES PARA IR Y VOLVER DE PAUSA
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pausarJuegoNotification)
         name:UIApplicationWillResignActiveNotification
         object:nil];
        //FIN DE NOTIFICACIONES
        self.userInteractionEnabled = YES;
        
        self.fondo0=[[EfectoParallax alloc]initWithBackground:@"fondo_bosque_1" size:size speed:1.0];
        self.fondo0.zPosition=-3;
        [self addChild:self.fondo0];
        self.fondo1=[[EfectoParallax alloc]initWithBackground:@"fondo_bosque_2" size:size speed:1.5];
        self.fondo1.zPosition=-2;
        [self addChild:self.fondo1];
        
        
        
        con_monedas = [[SKLabelNode alloc] initWithFontNamed:@"Verdana"];
        [con_monedas setFontSize:20];
        con_monedas.position = CGPointMake(CGRectGetMaxX(self.frame)-50, CGRectGetMaxY(self.frame)-35);
        [self addChild:con_monedas];
        
        //PARA VIDAS
        corazon1 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon1.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon1];
        
        corazon2 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon2.position = CGPointMake(CGRectGetMinX(self.frame)+50, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon2];
        
        corazon3 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon3.position = CGPointMake(CGRectGetMinX(self.frame)+80, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon3];
        
        
        pausa = [[SKSpriteNode alloc] initWithImageNamed:@"bt_pausa"];
        pausa.position = CGPointMake(CGRectGetMinX(self.frame)+110, CGRectGetMaxY(self.frame)-35);
        pausa.name = @"pausa";
        pausa.zPosition = 120;
        [self addChild:pausa];
        /*pausa = [[SKSpriteNode alloc] initWithImageNamed:@"images.png"];
         pausa.position = CGPointMake(CGRectGetMinX(self.frame)+80, CGRectGetMaxY(self.frame)-35);
         pausa.name = @"pausa";
         pausa.zPosition = 120;
         [self addChild:pausa];*/
        //FIN PARA VIDAS
        
        //Particulas
        NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"snow" ofType:@"sks"];
        myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
        myParticle.particlePosition = CGPointMake(CGRectGetMidX(self.frame),780);
        myParticle.particleRotation = -0.5;
        //myParticle.particleScale = 0.5;
        //myParticle.position=CGPointMake(-100, -230);
        //[self addChild:myParticle];
        
        
        self.mapa = [JSTileMap mapNamed:@"w1_lvl1.tmx"]; //cambiar aquí nombre de mapa
        self.mapa.zPosition=99;
        [self addChild:self.mapa];
        self.suelo = [self.mapa layerNamed:@"Suelo"]; //revisar nombre de capas
        self.rocas = [self.mapa layerNamed:@"Obstaculos"]; //y pide x20
        self.monedas = [self.mapa layerNamed:@"Monedas"];
        self.monedas.zPosition=80;
        self.rocas.zPosition=90;
        
        //self.Decoracion1 = [self.mapa layerNamed: @"Decoracion 1"];
        //self.Decoracion2 = [self.mapa layerNamed:@"Decoracion 2"];
        //self.Decoracion1.zPosition = 1;
        //self.Decoracion2.zPosition = 1;
        
        self.volar = [self.mapa layerNamed:(@"Volar")];
        self.volar.zPosition = 110;
        self.multiplicador = [self.mapa layerNamed:(@"Multiplicador")];
        self.multiplicador.zPosition = 110;
        self.escudo = [self.mapa layerNamed:(@"Escudo")];
        self.escudo.zPosition = 110;
        self.monedasVolar = [self.mapa layerNamed:(@"MonedasVolar")];
        self.monedasVolar.zPosition = 110;
        self.correccion =[self.mapa layerNamed:@"Correccion"];
        self.correccion.zPosition = 90;
        
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"cuchoAnimacion"];
        SKTexture *f1 = [atlas textureNamed:@"cucho01.png"];
        SKTexture *f2 = [atlas textureNamed:@"cucho02.png"];
        SKTexture *f3 = [atlas textureNamed:@"cucho03.png"];
        SKTexture *f4 = [atlas textureNamed:@"cucho04.png"];
        SKTexture *f5 = [atlas textureNamed:@"cucho05.png"];
        SKTexture *f6 = [atlas textureNamed:@"cucho06.png"];
        SKTexture *f7 = [atlas textureNamed:@"cucho07.png"];
        cuchoCaminando = @[f1,f2,f3,f4,f5,f6,f7];
        
        SKTextureAtlas *atlas1 = [SKTextureAtlas atlasNamed:@"cuchoAnimacion"];
        SKTexture *f8 = [atlas1 textureNamed:@"fly01.png"];
        SKTexture *f9 = [atlas1 textureNamed:@"fly02.png"];
        cuchoVolando = @[f8,f9];
        
        self.jugador = [[Jugador alloc] initWithImageNamed:@"cucho01.png"];
        self.jugador.position = CGPointMake(140, 150);
        self.jugador.zPosition = 100;
        self.jugador.modo=1;
        self.jugador.puede_moverse=NO;
        self.jugador.physicsBody.dynamic=YES;
        [self.mapa addChild:self.jugador];
        
        walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
        [self.jugador runAction:[SKAction repeatActionForever:walkAnimation]];
        
        
        //BOTON DE REANUDAR
        menu_play = [[SKSpriteNode alloc] initWithImageNamed:@"bt_play"];
        menu_play.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        menu_play.hidden = YES;
        menu_play.zPosition = 500;
        menu_play.name = @"reanuda";
        [self addChild:menu_play];
        
        //BOTON DE SALIR
        menu_salir = [[SKSpriteNode alloc] initWithImageNamed:@"bt_atras2"];
        menu_salir.position = CGPointMake(CGRectGetMidX(self.frame)-300, CGRectGetMidY(self.frame));
        menu_salir.hidden = YES;
        menu_salir.zPosition = 500;
        menu_salir.name = @"atras";
        [self addChild:menu_salir];
        
        //BOTON DE RECARGAR
        menu_recargar = [[SKSpriteNode alloc] initWithImageNamed:@"bt_recargar"];
        menu_recargar.position = CGPointMake(CGRectGetMidX(self.frame)+300, CGRectGetMidY(self.frame));
        menu_recargar.hidden = YES;
        menu_recargar.zPosition = 500;
        menu_recargar.name = @"recargar";
        [self addChild:menu_recargar];
        
    
        //iniciar datos de acelerometro
        volando=NO;
        tamanoPantalla=self.frame.size;
        _radioJugador=20.0f;
        _motionManager=[[CMMotionManager alloc]init];
        [self startMonitoringAcceleration];
        
        
        //se pausa el juego al comienzo
        [self mostrarMensaje];
    }
    return self;
}

#pragma mark metodos acelerometro

- (void)dealloc
{
    [self stopMonitoringAcceleration];
    _motionManager = nil;
}

- (void)startMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable) {
        [_motionManager startAccelerometerUpdates];
        NSLog(@"accelerometer updates on...");
    }
}


- (void)stopMonitoringAcceleration
{
    if (_motionManager.accelerometerAvailable && _motionManager.accelerometerActive) {
        [_motionManager stopAccelerometerUpdates];
        NSLog(@"accelerometer updates off...");
    }
}

- (void)updatePlayerAccelerationFromMotionManager
{
    
    CMAcceleration acceleration = _motionManager.accelerometerData.acceleration;
    _aceX=acceleration.y;
    _aceY=acceleration.x;
    if (_aceX<0.30 || _aceX>0.0){
        _aceleracionX=-_aceX*1200;
    }
    else if (_aceX>-0.30 || _aceX<0.0){
        _aceleracionX=_aceX*1200;
    }
    if (_aceX >= 0.30)
    {
        _aceleracionX = -maxAceleracion;
    }
    else if (_aceX <= -0.30)
    {
        _aceleracionX = maxAceleracion;
    }
    
    if (_aceY<0.30 || _aceY>0.0){
        _aceleracionY=_aceY*1200;
    }
    else if (_aceY>-0.30 || _aceY<0.0){
        _aceleracionY=-_aceY*1200;
    }
    if (_aceY >= 0.30)
    {
        _aceleracionY = maxAceleracion;
    }
    else if (_aceY <= -0.30)
    {
        _aceleracionY = -maxAceleracion;
    }
    
}


-(void)actualizarJugador:(CFTimeInterval)delta1{
    _velociX += _aceleracionX*delta1;
    _velociY += _aceleracionY*delta1;
    
    // 2
    _velociX = fmaxf(fminf(_velociX, maxVelocidad), -maxVelocidad);
    _velociY = fmaxf(fminf(_velociY, maxVelocidad), -maxVelocidad);
    
    float newY = self.jugador.position.y + _velociY*delta1;
    
    BOOL collidedWithVerticalBorder = NO;
    BOOL collidedWithHorizontalBorder = NO;
    
    
    if (newY < 150.0f)
    {
        newY = 150.0f;
        collidedWithHorizontalBorder = YES;
    }
    else if (newY > tamanoPantalla.height-100)
    {
        newY = tamanoPantalla.height-100;
        collidedWithHorizontalBorder = YES;
    }
    if (collidedWithVerticalBorder)
    {
        _aceleracionX = -_aceleracionX * BorderCollisionDamping;
        _velociX = -_velociX * BorderCollisionDamping;
        _aceleracionY= _aceleracionY * BorderCollisionDamping;
        _velociY = _velociY * BorderCollisionDamping;
    }
    
    if (collidedWithHorizontalBorder)
    {
        _aceleracionX = _aceleracionX * BorderCollisionDamping;
        _velociX = _velociX * BorderCollisionDamping;
        _aceleracionY = -_aceleracionY * BorderCollisionDamping;
        _velociY = -_velociY * BorderCollisionDamping;
    }
    
    self.jugador.position = CGPointMake(self.jugador.position.x, newY);
    
}

-(void)didMoveToView:(SKView *)view{
    doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saltoDoble)];
    
    doubleTap.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTap];
    
    [self anadirSlider];
}

-(void)willMoveFromView:(SKView *)view{
    [slider removeFromSuperview];
}

- (void)saltoDoble{
    NSLog(@"salto doble");
    
    if (salto_doble && num_mensaje!=1) {
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
    if (self.mapa.position.x<-11400) {
        [self juegoTerminado:1];
    }
    delta = currentTime - self.tiempoAnterior;
    //3
    if (delta > 0.02) {
        delta = 0.02;
    }
    //4
    self.tiempoAnterior = currentTime;
    
    if ((choque && num_mensaje==3)||(choque && num_mensaje==5)||(!choque_escudo && num_mensaje==9 && choque)) {
        //[self reiniciar];
        //[self pausarJuego];
        SKSpriteNode *cara_triste=[SKSpriteNode spriteNodeWithImageNamed:@"cara_triste"];
        cara_triste.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:cara_triste];
        
        num_mensaje=0;
        choque=NO;
        choque_escudo=NO;
        [self performSelector:@selector(reiniciar) withObject:self afterDelay:3.0];
        
    }
    
    //5
    if (!pausado) {
        
        
        [self setViewpointCenter:CGPointMake(0, CGRectGetMidY(self.frame))];
        [self updatePlayerAccelerationFromMotionManager];
        if (volando) {
            
            [self actualizarJugador:delta];
            [self.jugador update:delta];
        }
        else{
            [self.jugador update:delta];
            [self comprobarColisiones:self.jugador porCapas:self.suelo];
        }
        
        //volando=YES;
        //se lo pone cuando coga el powerup de volar!
        [self.fondo0 update:delta];
        [self.fondo1 update:delta];
        
        
        if (espacio_movimiento!=5) {
        }else{
            if (colisiones) {
                [self comprobarColisionesMonedas:self.jugador porCapas:self.monedas];
                [self comprobarColisionesPU:self.jugador porCapas:self.multiplicador];
                [self comprobarColisionesPU:self.jugador porCapas:self.volar];
                [self comprobarColisionesPU:self.jugador porCapas:self.escudo];
                if (!choque_escudo) {
                    [self comprobarColisionesTrampas:self.jugador porCapas:self.rocas];
                }
            }else{
                [self comprobarColisionesMonedas:self.jugador porCapas:self.monedasVolar];
            }
        }
    }
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch  locationInNode:self];
        SKNode *nodo=[self nodeAtPoint:location];
        
        NSLog(@"saltando %@",nodo.name);
        if ([nodo.name isEqualToString:@"pausa"] && menu_play.isHidden){
                [self pausarJuego:YES];
        }
        
        //comprobar esto, hay una falla al momento de reiniciar, se confunde entre el reiniciar con el boton y el resumir con click en la pantalla
        
        else if (pausado && menu_play.isHidden) {
            NSLog(@"pasa por aqui 1");
            num_mensaje++;
            [self reanudarJuego];
            switch (num_mensaje) {
                case 1:
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:4.0];
                    MainInt=40;
                    timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reducirTiempo) userInfo:Nil repeats:YES];
                    break;
                case 2:
                    MainInt=10;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:1.0];
                    break;
                case 3:
                    MainInt=25;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:2.5];
                    break;
                case 4:
                    MainInt=7;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:0.7];
                    break;
                case 5:
                    MainInt=30;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:3.0];
                    break;
                case 6:
                    MainInt=30;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:3.0];
                    break;
                case 7:
                    MainInt=10;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:0.6];
                    break;
                case 8:
                    MainInt=62;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:6.2];
                    break;
                case 9:
                    MainInt=48;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:4.8];
                    break;
                case 10:
                    MainInt=4;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:0.4];
                    break;
                case 11:
                    MainInt=120;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:12.0];
                    break;
                    
                default:
                    MainInt=30;
                    //[self performSelector:@selector(mostrarMensaje) withObject:nil afterDelay:3.0];
                    break;
            }
            
        }
         else if (pausado && !menu_play.isHidden && [nodo.name isEqualToString:@"reanuda"]) {
             NSLog(@"pasa por aqui 2");
             [self reanudarJuego];
         }
        
        else if([nodo.name isEqualToString:@"atras"]){
            [self salir];
        }
        else if([nodo.name isEqualToString:@"recargar"]){
            [self reiniciar];
        }
        else if([nodo.name isEqualToString:@"aceptar1"]){
            
            
        }
        /*else if(nodo==bt_aceptar){
         num_mensaje++;
         [self reanudarJuego];
         [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(mostrarMensaje) userInfo:nil repeats:NO];
         
         }*/
        else if (num_mensaje==1){
            
        }
        else{
            self.jugador.puede_saltar=YES;
        }
        
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
        //Para borrar monedas
        int x;
        int y;
        x=-1;
        y=1;
        CGPoint posiTile = CGPointMake(posiJugador.x + (tileColumn - 1), posiJugador.y + (tileRow - 1));
        NSInteger gid = [self tileGIDAtTileCoord:posiTile forLayer:capa];
        if (gid) {
            CGRect areaTile = [self tileRectFromTileCoords:posiTile];
            if (CGRectIntersectsRect(areaJugador, areaTile)) {
                contar_monedas = contar_monedas + suma_x2;
                con_monedas.text = [NSString stringWithFormat:@"%i",contar_monedas];
                for (x=-1; x<2; x++) {
                    for (y=-1; y<2; y++) {
                        CGPoint posiTile1 = CGPointMake(posiJugador.x + (tileColumn - 1) + x, posiJugador.y + (tileRow - 1) + y);
                        NSInteger gid1 = [self tileGIDAtTileCoord:posiTile1 forLayer:capa];
                        if (gid1) {
                            [capa removeTileAtCoord:posiTile1];
                            //[self runAction:[SKAction playSoundFileNamed:@"MONEDAS.mp3" waitForCompletion:NO]];
                            
                            //}
                        }
                    }
                }
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
                
                if (contador_vidas > 0) {
                    contador = [NSNumber numberWithInt:0];
                    [self.tiempo invalidate];
                    self.tiempo = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chocar) userInfo:nil repeats:YES];
                    SKAction *fadeOut=[SKAction fadeAlphaTo:0.30 duration:0.2];
                    SKAction *fadeIn=[SKAction fadeAlphaTo:1.0 duration:0.2];
                    [self.jugador runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeOut,fadeIn]]]withKey:@"fade"];
                    espacio_movimiento = 2;
                    choque=YES;
                    
                }else{
                    [corazon1 setHidden:YES];
                    vidas--;
                    [self juegoTerminado:0];
                }
                
            }
        }
    }
}

- (void)comprobarColisionesPU:(Jugador *)jugador porCapas:(TMXLayer *)capa {
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
        //Para borrar power ups
        int x;
        int y;
        x=-1;
        y=1;
        CGPoint posiTile = CGPointMake(posiJugador.x + (tileColumn - 1), posiJugador.y + (tileRow - 1));
        NSInteger gid = [self tileGIDAtTileCoord:posiTile forLayer:capa];
        if (gid) {
            CGRect areaTile = [self tileRectFromTileCoords:posiTile];
            if (CGRectIntersectsRect(areaJugador, areaTile)) {
                if (capa == self.multiplicador) {
                    //Aquí hacer la notificación del multiplicador
                    suma_x2 = 2;
                    int_mult = [NSNumber numberWithInt:0];
                    [multi invalidate];
                    multi = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(mult) userInfo:nil repeats:YES];
                }else if (capa == self.volar){
                    [self.jugador removeActionForKey:@"volar"];
                    walkAnimation = [SKAction animateWithTextures:cuchoVolando timePerFrame:0.5];
                    [self.jugador runAction:[SKAction repeatActionForever:walkAnimation]];
                    self.jugador.size = CGSizeMake(80, 130);
                    NSLog(@"se llama");
                    doubleTap.enabled = NO;
                    [self.rocas setHidden:YES];
                    [self.monedas setHidden:YES];
                    [self.correccion setHidden:YES];
                    [self.monedasVolar setHidden:NO];
                    [self.multiplicador setHidden:YES];
                    
                    [self.jugador runAction:[SKAction moveTo:CGPointMake(self.jugador.position.x+100, self.jugador.position.y+150) duration:0.5]];
                    //[volar1 invalidate];
                    //volar1 = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(metVolar) userInfo:nil repeats:YES];
                    if ([defaults integerForKey:@"estadoSwitch2"]==1) {
                        [self runAction:[SKAction playSoundFileNamed:@"s_volar.mp3" waitForCompletion:NO]];
                        
                    }
                    [defaults synchronize];
                    
                    [self performSelector:@selector(metVolar) withObject:self afterDelay:9.0];
                    volando = YES;
                    colisiones = NO;
                }
                else if (capa == self.escudo){
                    choque_escudo=YES;
                    [self performSelector:@selector(metEscudo) withObject:self afterDelay:3.0];
                }
                for (x=-1; x<2; x++) {
                    for (y=-1; y<2; y++) {
                        CGPoint posiTile1 = CGPointMake(posiJugador.x + (tileColumn - 1) + x, posiJugador.y + (tileRow - 1) + y);
                        NSInteger gid1 = [self tileGIDAtTileCoord:posiTile1 forLayer:capa];
                        if (gid1) {
                            [capa removeTileAtCoord:posiTile1];
                            //[self runAction:[SKAction playSoundFileNamed:@"coin.mp3" waitForCompletion:NO]];
                            //contar_monedas++;
                            //con_monedas.text = [NSString stringWithFormat:@"%i",contar_monedas];
                            //}
                        }
                    }
                }
            }
        }
    }
}

-(void)metEscudo{
    choque_escudo=NO;
}

-(void)mult{
    if (int_mult.intValue < 3) {
        int_mult = [NSNumber numberWithInt:[int_mult intValue]+1];
        suma_x2 = 2;
        NSLog(@"Multiplicador cogido");
    }else{
        suma_x2 = 1;
    }
}

-(void)metVolar{
    if (timVolar < 9) {
        timVolar++;
        NSLog(@"Se cogió la pluma");
        
    }else{
        volando = NO;
        colisiones = YES;
        [self.correccion setHidden:NO];
        [self.multiplicador setHidden:NO];
        [self.monedas setHidden:NO];
        [self.rocas setHidden:NO];
        [self.monedasVolar setHidden:YES];
        [volar1 invalidate];
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
        espacio_movimiento = 5;
        [self.jugador removeActionForKey:@"fade"];
        self.jugador.alpha=1.0f;
        
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
                    if (num_mensaje!=1|| num_mensaje!=2) {
                        salto_doble=YES;
                    }
                    else{
                        NSLog(@"no se permite salto doble");
                        salto_doble=NO;
                    }
                    
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
    SKLabelNode *mensaje1=[SKLabelNode labelNodeWithFontNamed:@"Arial"];
    mensaje1.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+30);
    mensaje1.fontSize=100.0f;
    mensaje1.fontColor=[SKColor blackColor];
    
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
        mensaje1.text=@"Ganaste!";
        //Para base
        //conexionBase *cb;// = [[conexionBase alloc] init];
        //[con insert:contar_monedas];
        ///-----------------------------Nuevo en base de datos
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:contar_monedas] forKey:@"total"];
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"insertBase" object:self userInfo:userInfo];
        //------------------------
        //contar_monedas = 0;
        contador_vidas = 2;
        //Fin para base
        
        //Para desbloquear niveles
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *ruta = [documentsDirectory stringByAppendingPathComponent:@"info_niveles.plist"];
        NSMutableDictionary *contenido_plist = [[NSMutableDictionary alloc] initWithContentsOfFile:ruta];
        NSMutableDictionary *contenido_niveles = [[NSMutableDictionary alloc] initWithDictionary:[contenido_plist objectForKey:@"Niveles"]];
        //NSMutableDictionary *contenido_cucho = [[NSMutableDictionary alloc] initWithDictionary:[contenido_plist objectForKey:@"Jugador"]];
        NSMutableArray *contenido_nivel = [[NSMutableArray alloc] initWithArray:[contenido_niveles objectForKey:@"Bosque"]];
        [contenido_nivel insertObject:@"NO" atIndex:1];
        [contenido_niveles setObject:contenido_nivel forKey:@"Bosque"];
        [contenido_plist setObject:contenido_niveles forKey:@"Niveles"];
        [contenido_plist writeToFile:ruta atomically:YES];
    }else{
        NSLog(@"perdiste");
        mensaje1.text=@"Perdiste";
        contador_vidas = 2;
    }
    //[self addChild:mensaje];
    //[self addChild:bt_salir];
    //[self addChild:bt_recargar];
    
    [self setUserInteractionEnabled:NO];
    NSMutableDictionary *puntajes = [NSMutableDictionary dictionary];
    NSNumber *puntuacion;
    puntuacion=[NSNumber numberWithInt:contar_monedas+(vidas*20)];//*20);
    NSLog(@"%i",contar_monedas);
    [puntajes setObject:@"1" forKey:@"mundo"];
    [puntajes setObject:@"1" forKey:@"nivel"];
    [puntajes setObject:puntuacion forKey:@"monedas"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarTerminado" object:self userInfo:puntajes];
    
}

- (void)setViewpointCenter:(CGPoint)position {
    velocidad_anterior = velocidad_actual;
    velocidad_actual = espacio_movimiento;
    if (velocidad_actual == 2 && velocidad_anterior==5) {
        if (contador_vidas == 2) {
            [corazon3 setHidden:YES];
            vidas--;
        }
        if (contador_vidas == 1) {
            [corazon2 setHidden:YES];
            vidas--;
        }
    }
    self.mapa.position = CGPointMake(self.mapa.position.x-espacio_movimiento, self.mapa.position.y);
    self.jugador.position= CGPointMake(self.jugador.position.x+espacio_movimiento, self.jugador.position.y);
    slider.value=slider.value+4;
    
}


#pragma mark Slider

-(void)anadirSlider{
    CGRect frame = CGRectMake(130.0, 30.0, 824.0, 10.0);
    slider = [[UISlider alloc] initWithFrame:frame];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 10500;
    slider.continuous = YES;
    slider.value = 0.0;
    slider.userInteractionEnabled=NO;
    UIImage *cuchito=[UIImage imageNamed:@"cucho_thumb"];
    [slider setThumbImage:cuchito forState:UIControlStateNormal];
    [self.view addSubview:slider];
}


#pragma mark Pausar y reanudar juego
-(void)pausarJuego:(BOOL)mostrarBotones{
    //NSNumber *monedas = [puntajes objectForKey:@"monedas"];
    if (pausado) {
        
    }else{
        pausado=YES;
        //self.jugador.puede_moverse=NO;
        self.jugador.puede_saltar=NO;
        [self.jugador removeAllActions];
        //myParticle.paused=YES;
        espacio_movimiento = 0;
    if(mostrarBotones){
        menu_play.hidden = NO;
        menu_salir.hidden = NO;
        menu_recargar.hidden = NO;
       
    }else{
        menu_play.hidden = YES;
        menu_salir.hidden =YES;
        menu_recargar.hidden = YES;
    }
    
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarPausa" object:self userInfo:nil];
        fondo_oscuro=[SKSpriteNode spriteNodeWithImageNamed:@"fondo_oscuro"];
        fondo_oscuro.alpha=0.5f;
        fondo_oscuro.position=CGPointMake(512, 384);
        [self addChild:fondo_oscuro];
        //[self.view sendSubviewToBack:mask_terminado];
    }
}

-(void)pausarJuegoNotification{

    if (pausado) {
        
    }else{
        pausado=YES;
        //self.jugador.puede_moverse=NO;
        self.jugador.puede_saltar=NO;
        [self.jugador removeAllActions];
        //myParticle.paused=YES;
        espacio_movimiento = 0;
            menu_play.hidden = NO;
            menu_salir.hidden = NO;
            menu_recargar.hidden = NO;

        //[[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarPausa" object:self userInfo:nil];
        fondo_oscuro=[SKSpriteNode spriteNodeWithImageNamed:@"fondo_oscuro"];
        fondo_oscuro.alpha=0.5f;
        fondo_oscuro.position=CGPointMake(512, 384);
        [self addChild:fondo_oscuro];
        //[self.view sendSubviewToBack:mask_terminado];
    }
}

-(void)reanudarJuego{
    pausado=NO;
    self.jugador.puede_saltar=NO;
    myParticle.paused=NO;
    choque=NO;
    menu_play.hidden = YES;
    menu_salir.hidden = YES;
    menu_recargar.hidden = YES;
    espacio_movimiento = 5;
    //fondo_oscuro.alpha=0.0f;
    [self.jugador runAction:[SKAction repeatActionForever:walkAnimation]];
    [fondo_oscuro removeFromParent];
    [bt_mano removeFromParent];
    [bt_mano2 removeFromParent];
    [bt_aceptar removeFromParent];
    [mensaje removeFromParent];
    //bt_aceptar.alpha=0.0f;
}

-(void)reducirTiempo{
    if (pausado == NO) {
        MainInt --;
        //NSLog(@"maintint: %d",MainInt);
        if (MainInt<=0) {
            [self mostrarMensaje];
        }
    }else{
        //NSLog(@"maintint: %d",MainInt);
    }
}

-(void)reiniciar{
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    SKScene * gameOverScene = [[Escena_juego_tutorial alloc] initWithSize:self.size conGameCenter:gc1 conInformacion:informacion1 conAudioPlayer:ap1]; //withBase: cb
    [self.view presentScene:gameOverScene transition: reveal];
}

-(void)salir{
    SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    SKScene * gameOverScene = [[Escena_nivel alloc] initWithSize:self.size conGameCenter:gc1 conInformacion:informacion1 conAudioPlayer:ap1]; //withBase: cb
    [self.view presentScene:gameOverScene transition: reveal];
}

//metodos Tutorial


#pragma mark Metodos Tutorial

-(void)mostrarMensaje{
    [self pausarJuego:NO];
    
    switch (num_mensaje) {
        case 0:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje1"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
        {
            NSArray *gestures = self.view.gestureRecognizers;
       
            for(UIGestureRecognizer *gesture in gestures)
            {
                if([gesture isKindOfClass: [UITapGestureRecognizer class]])
                {
                    gesture.enabled = NO;
                }
            }
             }
            
            /*bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
             bt_mano.position=CGPointMake(600, 200);
             [self addChild:bt_mano];*/
            break;
            
        case 1:
            NSLog(@"wey");
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje2"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            // [self addChild:bt_aceptar];
            
            bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
            bt_mano.position=CGPointMake(55, 680);
            //bt_mano.zRotation = M_PI/1.5f;
            [self addChild:bt_mano];
            
        {
            SKAction *mover1=[SKAction moveTo:CGPointMake(70, 640) duration:0.5];
            SKAction *mover2=[SKAction moveTo:CGPointMake(55, 680) duration:0.5];
            SKAction *sequence=[SKAction sequence:@[mover1,mover2]];
            [bt_mano runAction:[SKAction repeatActionForever:sequence]];
        }
            doubleTap.enabled=YES;
            
            break;
            
        case 2:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje3"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
            bt_mano.position=CGPointMake(600, 220);
            bt_mano.zRotation = M_PI/1.0f;
            [self addChild:bt_mano];
            
        {
            SKAction *mover1=[SKAction moveTo:CGPointMake(600, 220) duration:0.5];
            SKAction *mover2=[SKAction moveTo:CGPointMake(580, 240) duration:0.5];
            SKAction *sequence=[SKAction sequence:@[mover1,mover2]];
            [bt_mano runAction:[SKAction repeatActionForever:sequence]];
        }
            
            bt_mano2=[SKSpriteNode spriteNodeWithImageNamed:@"mano_touch1"];
            bt_mano2.position=CGPointMake(512, 450);
            //bt_mano2.zRotation = M_PI/1.0f;
            [self addChild:bt_mano2];
            
        {
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"manotouch"];
            SKTexture *mano1 = [atlas textureNamed:@"mano_touch1.png"];
            SKTexture *mano2 = [atlas textureNamed:@"mano_touch2.png"];
            
            NSArray *ar_manos = @[mano1,mano2];
            
            SKAction *manos = [SKAction animateWithTextures:ar_manos timePerFrame:0.3];
            [bt_mano2 runAction:[SKAction repeatActionForever:manos]];
        }
            break;
        case 3:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje4"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            /*bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
             bt_mano.position=CGPointMake(600, 200);
             [self addChild:bt_mano];*/
            break;
        case 4:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje5"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
            bt_mano.position=CGPointMake(530, 270);
            bt_mano.zRotation = M_PI/1.0f;
            [self addChild:bt_mano];
            
        {
            SKAction *mover1=[SKAction moveTo:CGPointMake(550, 240) duration:0.5];
            SKAction *mover2=[SKAction moveTo:CGPointMake(530, 270) duration:0.5];
            SKAction *sequence=[SKAction sequence:@[mover1,mover2]];
            [bt_mano runAction:[SKAction repeatActionForever:sequence]];
        }
            break;
        case 5:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje6"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            /*bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
             bt_mano.position=CGPointMake(600, 200);
             [self addChild:bt_mano];*/
            break;
        case 6:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje7"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
            bt_mano.position=CGPointMake(900, 680);
            bt_mano.zRotation =-M_PI/2.0f;
            [self addChild:bt_mano];
            
        {
            SKAction *mover1=[SKAction moveTo:CGPointMake(920, 690) duration:0.5];
            SKAction *mover2=[SKAction moveTo:CGPointMake(900, 680) duration:0.5];
            SKAction *sequence=[SKAction sequence:@[mover1,mover2]];
            [bt_mano runAction:[SKAction repeatActionForever:sequence]];
        }
            break;
        case 7:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje8"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
            bt_mano.position=CGPointMake(530, 270);
            bt_mano.zRotation = M_PI/1.0f;
            [self addChild:bt_mano];
            
        {
            SKAction *mover1=[SKAction moveTo:CGPointMake(550, 240) duration:0.5];
            SKAction *mover2=[SKAction moveTo:CGPointMake(530, 270) duration:0.5];
            SKAction *sequence=[SKAction sequence:@[mover1,mover2]];
            [bt_mano runAction:[SKAction repeatActionForever:sequence]];
        }
            break;
        case 8:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje9"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
            bt_mano.position=CGPointMake(530, 270);
            bt_mano.zRotation = M_PI/1.0f;
            [self addChild:bt_mano];
            
        {
            SKAction *mover1=[SKAction moveTo:CGPointMake(550, 240) duration:0.5];
            SKAction *mover2=[SKAction moveTo:CGPointMake(530, 270) duration:0.5];
            SKAction *sequence=[SKAction sequence:@[mover1,mover2]];
            [bt_mano runAction:[SKAction repeatActionForever:sequence]];
        }
            break;
        case 9:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje10"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            break;
        case 10:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje11"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
            bt_mano.position=CGPointMake(600, 220);
            bt_mano.zRotation = M_PI/1.0f;
            [self addChild:bt_mano];
            
        {
            SKAction *mover1=[SKAction moveTo:CGPointMake(600, 220) duration:0.5];
            SKAction *mover2=[SKAction moveTo:CGPointMake(580, 240) duration:0.5];
            SKAction *sequence=[SKAction sequence:@[mover1,mover2]];
            [bt_mano runAction:[SKAction repeatActionForever:sequence]];
        }
            
            bt_mano2=[SKSpriteNode spriteNodeWithImageNamed:@"mano_touch21"];
            bt_mano2.position=CGPointMake(512, 450);
            //bt_mano2.zRotation = M_PI/1.0f;
            [self addChild:bt_mano2];
            
        {
            SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"manotouch2"];
            SKTexture *mano1 = [atlas textureNamed:@"mano_touch21.png"];
            SKTexture *mano2 = [atlas textureNamed:@"mano_touch22.png"];
            
            NSArray *ar_manos = @[mano1,mano2];
            
            SKAction *manos = [SKAction animateWithTextures:ar_manos timePerFrame:0.3];
            [bt_mano2 runAction:[SKAction repeatActionForever:manos]];
        }
            break;
        case 11:
            mensaje=[SKSpriteNode spriteNodeWithImageNamed:@"mensaje12"];
            mensaje.position=CGPointMake(305, 270);
            [self addChild:mensaje];
            
            bt_aceptar=[SKSpriteNode spriteNodeWithImageNamed:@"bt_aceptar"];
            bt_aceptar.position=CGPointMake(400, 170);
            bt_aceptar.name=@"aceptar1";
            bt_aceptar.zPosition = 200;
            //[self addChild:bt_aceptar];
            
            /*bt_mano=[SKSpriteNode spriteNodeWithImageNamed:@"mano"];
             bt_mano.position=CGPointMake(600, 200);
             [self addChild:bt_mano];*/
            break;
            
        default:
            break;
    }
    
    
    
    
}







@end
