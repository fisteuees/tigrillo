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

#define IPAD UIUserInterfaceIdiomPad
#define idiom UI_USER_INTERFACE_IDIOM()

const float maxVelocidad1 = 850.0f;
const float maxAceleracion1 = 850.0f;
const float BorderCollisionDamping1 = 0.2f;
const float CannonCollisionSpeed1 = 100.0f;

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
    NSArray *cuchoVolando;
    SKAction *walkAnimation;
    UITapGestureRecognizer *doubleTap;

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
    
    //Audio Player
    AVAudioPlayer *ap1;
    NSUserDefaults *defaults;

    //para nuevo de pausa
    SKSpriteNode *fondo_oscuro;
    SKEmitterNode *myParticle;
    BOOL choque;
}
@end

@implementation Escena_juego
@synthesize tiempo;

-(id)initWithSize:(CGSize)size conInformacion:(NSMutableDictionary *)informacion conAudioPlayer:(AVAudioPlayer *)ap {
    //con = cb; pendiente para base de datos
    if (self = [super initWithSize:size]) {
        //
        [ap stop];
        ap1=ap;
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
        //Nuevo para particulas
        int particulas_x;
        int particulas_y;
        //Nuevo para reconocer niveles
        mundo = [informacion objectForKey:@"nroMundo"];
        nivel = [informacion objectForKey:@"nroNivel"];
        nomMapa = [informacion objectForKey:@"nombreNivel"];
        SKAction *s_fondo;
        NSURL *url;
        
        switch (mundo.intValue) {
            case 1:
                fondo = @"fondo_bosque_";
                url= [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/s_fondo_bosque.mp3", [[NSBundle mainBundle] resourcePath]]];
                particulas_x = 1024;
                particulas_y = 450;
                break;
            case 2:
                fondo = @"fondo_hielo_";
                url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/s_fondo_hielo.mp3", [[NSBundle mainBundle] resourcePath]]];
                particulas_x = 100;
                particulas_y = 750;
                break;
            case 3:
                fondo = @"fondo_agua_";
                url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/s_fondo_agua.mp3", [[NSBundle mainBundle] resourcePath]]];
                particulas_x = 10;
                particulas_y = 10;
                break;
            case 4:
                fondo = @"fondo_fuego_";
                url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/s_fondo_fuego.mp3", [[NSBundle mainBundle] resourcePath]]];
                particulas_x = 100;
                particulas_y = 750;
                break;
            case 5:
                fondo = @"fondo_cementerio_";
                url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/s_fondo_cementerio.mp3", [[NSBundle mainBundle] resourcePath]]];
                particulas_x = 1024;
                particulas_y = 450;
                break;
            default:
                particulas_x = 0;
                particulas_y = 0;
                break;
        }
        
        NSError *error;
        ap1 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        ap1.numberOfLoops = -1;
        
        defaults=[NSUserDefaults standardUserDefaults];
        
        if ([defaults integerForKey:@"estadoSwitch1"]==1) {
            [ap1 play];
            
        }
        [defaults synchronize];
        
        //NOTIFICACIONES PARA IR Y VOLVER DE PAUSA
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pausarJuego)
         name:UIApplicationWillResignActiveNotification
         object:nil];
        //
        /*[[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(reanudarJuego)
         name:UIApplicationDidBecomeActiveNotification
         object:nil];*/
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
        corazon1.position = CGPointMake(CGRectGetMinX(self.frame)+20, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon1];
        
        corazon2 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon2.position = CGPointMake(CGRectGetMinX(self.frame)+50, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon2];
        
        corazon3 = [[SKSpriteNode alloc] initWithImageNamed:@"corazon.png"];
        corazon3.position = CGPointMake(CGRectGetMinX(self.frame)+80, CGRectGetMaxY(self.frame)-35);
        [self addChild:corazon3];
        
        pausa = [[SKSpriteNode alloc] initWithImageNamed:@"BTpausa.png"];
        pausa.position = CGPointMake(CGRectGetMinX(self.frame)+110, CGRectGetMaxY(self.frame)-35);
        pausa.name = @"pausa";
        pausa.zPosition = 120;
        [self addChild:pausa];
        //FIN PARA VIDAS
        
        //Particulas
        NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Particulas_%i",mundo.intValue] ofType:@"sks"];
        myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
        myParticle.position=CGPointMake(particulas_x, particulas_y);
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
        
        if (idiom != IPAD) {
            self.mapa.xScale=0.60;
            self.mapa.yScale=0.60;
        }
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

        
        //BOTON DE PAUSA
        menu_pausa = [[SKSpriteNode alloc] initWithImageNamed:@"orange-round-play-button.png"];
        menu_pausa.position = CGPointMake(100, 100);
        menu_pausa.hidden = YES;
        menu_pausa.zPosition = 500;
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
        
        
        //ocultar monedas
        [self.monedasVolar setHidden:YES];
        
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
        _aceleracionX = -maxAceleracion1;
    }
    else if (_aceX <= -0.30)
    {
        _aceleracionX = maxAceleracion1;
    }
    
    if (_aceY<0.30 || _aceY>0.0){
        _aceleracionY=_aceY*1200;
    }
    else if (_aceY>-0.30 || _aceY<0.0){
        _aceleracionY=-_aceY*1200;
    }
    if (_aceY >= 0.30)
    {
        _aceleracionY = maxAceleracion1;
    }
    else if (_aceY <= -0.30)
    {
        _aceleracionY = -maxAceleracion1;
    }
    
}


-(void)actualizarJugador:(CFTimeInterval)delta1{
    _velociX += _aceleracionX*delta1;
    _velociY += _aceleracionY*delta1;
    
    // 2
    _velociX = fmaxf(fminf(_velociX, maxVelocidad1), -maxVelocidad1);
    _velociY = fmaxf(fminf(_velociY, maxVelocidad1), -maxVelocidad1);
    
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
        _aceleracionX = -_aceleracionX * BorderCollisionDamping1;
        _velociX = -_velociX * BorderCollisionDamping1;
        _aceleracionY= _aceleracionY * BorderCollisionDamping1;
        _velociY = _velociY * BorderCollisionDamping1;
    }
    
    if (collidedWithHorizontalBorder)
    {
        _aceleracionX = _aceleracionX * BorderCollisionDamping1;
        _velociX = _velociX * BorderCollisionDamping1;
        _aceleracionY = -_aceleracionY * BorderCollisionDamping1;
        _velociY = -_velociY * BorderCollisionDamping1;
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
    
    
   /*
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
    */
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
                if (!escudo) {
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

            if(pausado){

            }else{
                /*[tiempo_reanudar invalidate];
                pausado=YES;
                self.jugador.puede_saltar=NO;
                salto_doble = YES;*/
                cont_tiempo = [NSNumber numberWithInt:3];
                [self pausarJuego];
            }
            
            
        }else if ([nodo.name isEqualToString:@"reanuda"]){
            if(pausado){
                //vpausa = [[UIView alloc] initWithFrame:self.frame];
                //[vpausa setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
                //[self.scene.view addSubview:vpausa];
                //
                prueba_mensaje = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
                [prueba_mensaje setText:@"3"];
                self.jugador.puede_saltar = NO;
                //[vpausa addSubview:prueba_mensaje];
                [self reanudarJuego];
                //[tiempo_reanudar invalidate];
                //tiempo_reanudar = [NSTimer scheduledTimerWithTimeInterval:0.67 target:self selector:@selector(disminuirTiempo) userInfo:nil repeats:YES];
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
        //self.scene.view.paused = NO;
        [self reanudarJuego];
        //[vpausa setHidden:YES];
        [prueba_mensaje setHidden:YES];
        cont_tiempo = [NSNumber numberWithInt:3];
    }
}

#pragma mark pausa2
-(void)pausarJuego{
    if (pausado) {
        
    }else{
        pausado=YES;
        //self.jugador.puede_moverse=NO;
        self.jugador.puede_saltar=NO;
        [self.jugador removeAllActions];
        //myParticle.paused=YES;
        espacio_movimiento = 0;
        menu_pausa.hidden = NO;
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
    menu_pausa.hidden = YES;
    espacio_movimiento = 5;
    //fondo_oscuro.alpha=0.0f;
    [self.jugador runAction:[SKAction repeatActionForever:walkAnimation]];
    [fondo_oscuro removeFromParent];
    //bt_aceptar.alpha=0.0f;
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
                            if ([defaults integerForKey:@"estadoSwitch2"]==1) {
                                [self runAction:[SKAction playSoundFileNamed:@"s_moneda.mp3" waitForCompletion:NO]];
                                
                            }
                            [defaults synchronize];
                            
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
                    if ([defaults integerForKey:@"estadoSwitch2"]==1) {
                        [self runAction:[SKAction playSoundFileNamed:@"s_multiplicador.mp3" waitForCompletion:NO]];
                        
                    }
                    [defaults synchronize];
                    [self performSelector:@selector(mult) withObject:self afterDelay:3.0];
                }else if (capa == self.volar){
                    //Cambios para timers
                    //timVolar = 0;
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
                }else if (capa == self.escudo){
                    escudo = YES;
                    if ([defaults integerForKey:@"estadoSwitch2"]==1) {
                        [self runAction:[SKAction playSoundFileNamed:@"s_escudo.mp3" waitForCompletion:NO]];
                        
                    }
                    [defaults synchronize];
                    
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
        doubleTap.enabled = YES;
        volando = NO;
        colisiones = YES;
        [self.jugador removeActionForKey:@"volar"];
        walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
        [self.jugador runAction:[SKAction repeatActionForever:walkAnimation]];
        self.jugador.size = CGSizeMake(70,70);
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
    //para mostrar siguiente
    NSString *ganar;
    //[self removeActionForKey:@"fondo"];
    [ap1 stop];
    [self.tiempo invalidate];
    pausa.hidden = YES;
    termino = 1;
    [self.jugador removeAllActions];
    //
    self.juegoTermino=YES;

    if(gano){
        if ([defaults integerForKey:@"estadoSwitch2"]==1) {
            [self runAction:[SKAction playSoundFileNamed:@"s_ganar.wav" waitForCompletion:NO]];
            
        }
        [defaults synchronize];
        //para mostrar siguiente
        ganar = @"gano";
        NSLog(@"ganaste");

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
        //para mostrar siguiente
        if ([defaults integerForKey:@"estadoSwitch2"]==1) {
            [self runAction:[SKAction playSoundFileNamed:@"s_perder.wav" waitForCompletion:NO]];
            
        }
        [defaults synchronize];
        ganar = @"perdio";
        NSLog(@"perdiste");
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
    //para mostrar siguiente
    [puntajes setObject:ganar forKey:@"gano"];
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
    slider.value=slider.value+espacio_movimiento;

}


#pragma mark Slider

-(void)anadirSlider{
    CGRect frame = CGRectMake(130.0, 30.0, 824.0, 10.0);
    slider = [[UISlider alloc] initWithFrame:frame];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 0.0;
    slider.maximumValue = 9680;
    slider.continuous = YES;
    slider.value = 0.0;
    slider.userInteractionEnabled=NO;
    UIImage *cuchito=[UIImage imageNamed:@"cuchoThumb"];
    
    [slider setThumbImage:cuchito forState:UIControlStateNormal];
    [self.view addSubview:slider];
}





@end
