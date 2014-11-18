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

const float maxVelocidad = 400.0f;
const float maxAceleracion = 400.0f;
const float BorderCollisionDamping = 0.5f;
const float CannonCollisionSpeed = 100.0f;

@import CoreMotion;



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
    
    //Nuevo para reconocer niveles
    NSString *mundo;
    NSString *nivel;
    NSString *fondo;
    
    //Nuevo para escudo
    BOOL escudo;
}
@end

@implementation Escena_juego
@synthesize tiempo;

-(id)initWithSize:(CGSize)size conInformacion:(NSMutableDictionary *)informacion{
    //con = cb; pendiente para base de datos
    if (self = [super initWithSize:size]) {
        //
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
        //
        //Nuevo para reconocer niveles
        mundo = [informacion objectForKey:@"nroMundo"];
        nivel = [informacion objectForKey:@"nroNivel"];
        nomMapa = [informacion objectForKey:@"nombreNivel"];
        
        switch (mundo.intValue) {
            case 1:
                fondo = @"fondo_bosque_";
                break;
            case 2:
                fondo = @"fondo_hielo_";
                break;
            case 3:
                fondo = @"fondo_agua_";
                break;
            case 4:
                fondo = @"fondo_fuego_";
                break;
            case 5:
                fondo = @"fondo_cementerio_";
                break;
            default:
                break;
        }
        
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
        
        self.fondo0=[[EfectoParallax alloc]initWithBackground:[NSString stringWithFormat:@"%@1",fondo] size:size speed:1.0]; //1
        self.fondo0.zPosition=-3;
        [self addChild:self.fondo0];
        self.fondo1=[[EfectoParallax alloc]initWithBackground:[NSString stringWithFormat:@"%@2",fondo] size:size speed:1.5]; //2
        self.fondo1.zPosition=-2;
        [self addChild:self.fondo1];
        
        
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
        pausa.zPosition = 120;
        [self addChild:pausa];
        //FIN PARA VIDAS
        
        //Particulas
        NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"bosque" ofType:@"sks"];
        SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
        myParticle.position=CGPointMake(1024, 450);
        [self addChild:myParticle];
        
        NSLog(@"El nombre del mapa es: %@",nomMapa);
        self.mapa = [JSTileMap mapNamed:nomMapa]; //cambiar aquí nombre de mapa //Nuevo para reconocer niveles
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
        self.correccion.zPosition = 110;

        
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
        self.jugador.position = CGPointMake(140, 150);
        self.jugador.zPosition = 100;
        self.jugador.modo=1;
        self.jugador.puede_moverse=NO;
        self.jugador.physicsBody.dynamic=YES;
        [self.mapa addChild:self.jugador];
        
        SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
        [self.jugador runAction:[SKAction repeatActionForever:walkAnimation]];

        
        //BOTON DE PAUSA
        menu_pausa = [[SKSpriteNode alloc] initWithImageNamed:@"orange-round-play-button.png"];
        menu_pausa.position = CGPointMake(100, 100);
        menu_pausa.hidden = YES;
        menu_pausa.zPosition = 200;
        menu_pausa.name = @"reanuda";
        [self addChild:menu_pausa];
        
        action = [SKAction runBlock:^{
            [menu_pausa setHidden:NO];
            NSLog(@"salio la imagen");
            
        }];
        
        /*NSString *path = [[NSBundle mainBundle] pathForResource:@"MyParticle"
         ofType:@"sks"];
         SKEmitterNode *particula = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
         particula.position=CGPointMake(-20, 0);
         [self.jugador addChild:particula];*/
        
        
        
        
        //iniciar datos de acelerometro
        volando=NO;
        tamanoPantalla=self.frame.size;
        _radioJugador=20.0f;
        _motionManager=[[CMMotionManager alloc]init];
        [self startMonitoringAcceleration];
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
    
    
    if (newY < 130.0f)
    {
        newY = 130.0f;
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
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saltoDoble)];
    doubleTap.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:doubleTap];
    
    [self anadirSlider];
}

-(void)willMoveFromView:(SKView *)view{
    [slider removeFromSuperview];
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
    if (self.mapa.position.x<-9840) {
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
            if (!escudo) {
               [self comprobarColisionesTrampas:self.jugador porCapas:self.rocas];
            }
        }else{
            [self comprobarColisionesMonedas:self.jugador porCapas:self.monedasVolar];
        }
    }
    
    
    
    
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
                    self.tiempo = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(chocar) userInfo:nil repeats:YES];
                    SKAction *fadeOut=[SKAction fadeAlphaTo:0.30 duration:0.2];
                    SKAction *fadeIn=[SKAction fadeAlphaTo:1.0 duration:0.2];
                    [self.jugador runAction:[SKAction repeatActionForever:[SKAction sequence:@[fadeOut,fadeIn]]]withKey:@"fade"];
                    espacio_movimiento = 2;
                    
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
                    //Cambios para timers
                    //int_mult = [NSNumber numberWithInt:0];
                    //[multi invalidate];
                    //multi = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(mult) userInfo:nil repeats:YES];
                    [self performSelector:@selector(mult) withObject:self afterDelay:3.0];
                }else if (capa == self.volar){
                    //Cambios para timers
                    //timVolar = 0;
                    NSLog(@"se llama");
                    [self.rocas setHidden:YES];
                    [self.monedas setHidden:YES];
                    [self.correccion setHidden:YES];
                    [self.monedasVolar setHidden:NO];
                    [self.multiplicador setHidden:YES];
                    //[volar1 invalidate];
                    //volar1 = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(metVolar) userInfo:nil repeats:YES];
                    [self performSelector:@selector(metVolar) withObject:self afterDelay:9.0];
                    volando = YES;
                    colisiones = NO;
                }else if (capa == self.escudo){
                    escudo = YES;
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

//Nuevo para escudo
-(void)metEscudo{
    escudo = NO;
    //NSLog(@"pasaron 3 segundos");
}
//Cambios para timers
-(void)mult{
    /*if (int_mult.intValue < 3) {
        int_mult = [NSNumber numberWithInt:[int_mult intValue]+1];
        suma_x2 = 2;
        NSLog(@"Multiplicador cogido");
    }else{*/
        suma_x2 = 1;
    //}
}
//Cambios para timers
-(void)metVolar{
    /*if (timVolar < 13) {
        timVolar++;
        NSLog(@"Se cogió la pluma");
        
    }else{*/
        volando = NO;
        colisiones = YES;
        [self.correccion setHidden:NO];
        [self.multiplicador setHidden:NO];
        [self.monedas setHidden:NO];
        [self.rocas setHidden:NO];
        [self.monedasVolar setHidden:YES];
        //[volar1 invalidate];
    //}
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
        //contar_monedas = 0;
        contador_vidas = 2;
        //Fin para base
    }else{
        NSLog(@"perdiste");
        mensaje.text=@"Perdiste";
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
    [puntajes setObject:puntuacion forKey:@"monedas"];
    [puntajes setObject:mundo forKey:@"mundo"];
    [puntajes setObject:nivel forKey:@"nivel"];
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
    CGRect frame = CGRectMake(100.0, 30.0, 824.0, 10.0);
    slider = [[UISlider alloc] initWithFrame:frame];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 6110;
    slider.continuous = YES;
    slider.value = 0.0;
    slider.userInteractionEnabled=NO;
    UIImage *cuchito=[UIImage imageNamed:@"cucho04.png"];
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[cuchito CGImage]
                        scale:(cuchito.scale * 2.0)
                  orientation:(cuchito.imageOrientation)];
    
    [slider setThumbImage:scaledImage forState:UIControlStateNormal];
    [self.view addSubview:slider];
}





@end
