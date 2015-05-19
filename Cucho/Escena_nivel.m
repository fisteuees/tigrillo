//
//  Escena_nivel.m
//  Cucho Run
//
//  Created by FISTE on 08/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "Escena_nivel.h"
#import "Escena_juego.h"
#import "Escena_juego_tutorial.h"
#import "gameCenterManager.h"
#import "Escena_mundos.h"

@interface Escena_nivel(){
    bool isPhone,atras;
    NSArray *cuchoCaminando;
    SKSpriteNode *cucho;
    gameCenterManager *gc1;
    //Nuevo para reconocer niveles
    NSString *nroMundo;
    NSMutableDictionary *informacion;
    SKTransition *reveal;
    AVAudioPlayer *ap1;
    //Nuevo para reconocer niveles
    NSString *nombreMundo;
    NSArray *info_nivel;
    BOOL bloquea1;
    BOOL bloquea2;
    BOOL bloquea3;
    BOOL bloquea4;
    BOOL bloquea5;
}

@end

@implementation Escena_nivel

-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc conInformacion:(NSMutableDictionary *)info conAudioPlayer:(AVAudioPlayer*)ap{
    if (self = [super initWithSize:size]) {
        //Nuevo para reconocer niveles
        ap1=ap;
        reveal = [SKTransition doorsOpenVerticalWithDuration:0.1];
        nroMundo = [info objectForKey:@"nroMundo"];
        informacion = info;
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        //Nuevo para reconocer niveles
        gc1=gc;
        
        SKSpriteNode *bt_atras=[SKSpriteNode spriteNodeWithImageNamed:@"bt_atras"];
        bt_atras.position=CGPointMake(CGRectGetMinX(self.frame)+60, CGRectGetMaxY(self.frame)-60);
        bt_atras.name=@"atras";
        bt_atras.zPosition=250;
        [self addChild:bt_atras];
        
        SKSpriteNode *bt_nivel1=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel1"];
        bt_nivel1.position=CGPointMake(75, 280);
        bt_nivel1.name=@"nivel1";
        bt_nivel1.zPosition=250;
        [self addChild:bt_nivel1];
        
        SKSpriteNode *bt_nivel2=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel2"];
        bt_nivel2.position=CGPointMake(300, 230);
        bt_nivel2.name=@"nivel2";
        bt_nivel2.zPosition=250;
        [self addChild:bt_nivel2];
        
        SKSpriteNode *bt_nivel3=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel3"];
        bt_nivel3.position=CGPointMake(560, 150);
        bt_nivel3.name=@"nivel3";
        bt_nivel3.zPosition=250;
        [self addChild:bt_nivel3];
        
        SKSpriteNode *bt_nivel4=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel4"];
        bt_nivel4.position=CGPointMake(760, 360);
        bt_nivel4.name=@"nivel4";
        bt_nivel4.zPosition=250;
        [self addChild:bt_nivel4];
        
        SKSpriteNode *bt_nivel5=[SKSpriteNode spriteNodeWithImageNamed:@"bt_nivel5"];
        bt_nivel5.position=CGPointMake(880, 565);
        bt_nivel5.name=@"nivel5";
        bt_nivel5.zPosition=250;
        [self addChild:bt_nivel5];
        
        //Bloqueado
        SKSpriteNode *bloqueado1 = [SKSpriteNode spriteNodeWithImageNamed:@"bloqueado.png"];
        bloqueado1.position=CGPointMake(75, 280);
        bloqueado1.zPosition=500;
        [self addChild:bloqueado1];
        
        SKSpriteNode *bloqueado2 = [SKSpriteNode spriteNodeWithImageNamed:@"bloqueado.png"];
        bloqueado2.position=CGPointMake(300, 230);
        bloqueado2.zPosition=500;
        [self addChild:bloqueado2];
        
        SKSpriteNode *bloqueado3 = [SKSpriteNode spriteNodeWithImageNamed:@"bloqueado.png"];
        bloqueado3.position=CGPointMake(560, 150);
        bloqueado3.zPosition=500;
        [self addChild:bloqueado3];
        
        SKSpriteNode *bloqueado4 = [SKSpriteNode spriteNodeWithImageNamed:@"bloqueado.png"];
        bloqueado4.position=CGPointMake(760, 360);
        bloqueado4.zPosition=500;
        [self addChild:bloqueado4];
        
        SKSpriteNode *bloqueado5 = [SKSpriteNode spriteNodeWithImageNamed:@"bloqueado.png"];
        bloqueado5.position=CGPointMake(880, 565);
        bloqueado5.zPosition=500;
        [self addChild:bloqueado5];
        
        //NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *ruta = [documentsDirectory stringByAppendingPathComponent:@"info_niveles.plist"];
        NSMutableDictionary *contenido_plist = [[NSMutableDictionary alloc] initWithContentsOfFile:ruta];
        NSMutableDictionary *contenido_niveles = [[NSMutableDictionary alloc] initWithDictionary:[contenido_plist objectForKey:@"Niveles"]];
        
        if (nroMundo.intValue==1) {
            nombreMundo = @"fondo_niveles_bosque";
            info_nivel = [contenido_niveles objectForKey:@"Bosque"];
        }else if (nroMundo.intValue==2){
            nombreMundo = @"fondo_niveles_hielo";
            info_nivel = [contenido_niveles objectForKey:@"Hielo"];
        }else if (nroMundo.intValue==3){
            nombreMundo = @"fondo_niveles_agua";
            info_nivel = [contenido_niveles objectForKey:@"Agua"];
        }else if (nroMundo.intValue==4){
            nombreMundo = @"fondo_niveles_fuego";
            info_nivel = [contenido_niveles objectForKey:@"Fuego"];
        }else{
            nombreMundo = @"fondo_niveles_cementerio.png";
            info_nivel = [contenido_niveles objectForKey:@"Cementerio"];
        }
        
        
        SKSpriteNode *fondo = [SKSpriteNode spriteNodeWithImageNamed:nombreMundo];
        fondo.position=CGPointMake( CGRectGetMidX(self.scene.frame) , CGRectGetMidY(self.scene.frame));
        [self addChild:fondo];
        
        NSLog(@"Este es el mundo %@",nombreMundo);
        
        
        if ([[info_nivel objectAtIndex:0] isEqualToString:@"NO"]) {
            //[bloqueado1 setHidden:YES];
            [bloqueado1 removeFromParent];
            bloquea1 = YES;
        }
        if ([[info_nivel objectAtIndex:1] isEqualToString:@"NO"]) {
            //[bloqueado2 setHidden:YES];
            [bloqueado2 removeFromParent];
            bloquea2 = YES;
        }
        if ([[info_nivel objectAtIndex:2] isEqualToString:@"NO"]) {
            //[bloqueado3 setHidden:YES];
            [bloqueado3 removeFromParent];
            bloquea3 = YES;
        }
        if ([[info_nivel objectAtIndex:3] isEqualToString:@"NO"]) {
            //[bloqueado4 setHidden:YES];
            [bloqueado4 removeFromParent];
            bloquea4 = YES;
        }
        if ([[info_nivel objectAtIndex:4] isEqualToString:@"NO"]) {
            //[bloqueado5 setHidden:YES];
            [bloqueado5 removeFromParent];
            bloquea5 = YES;
        }
        
        /*SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"cuchoNiveles"];
         SKTexture *f1 = [atlas textureNamed:@"cucho-1.png"];
         SKTexture *f2 = [atlas textureNamed:@"cucho-2.png"];
         SKTexture *f3 = [atlas textureNamed:@"cucho-3.png"];
         cuchoCaminando = @[f1,f2,f3];
         
         cucho=[SKSpriteNode spriteNodeWithImageNamed:@"cucho-1"];
         cucho.position=CGPointMake(60, 60);
         cucho.name=@"cucho";
         [self addChild:cucho];*/
        
        
        
    }
    return self;
}

-(void)didMoveToView:(SKView *)view{
    NSLog(@"se movio");
}

//Nuevo para reconocer niveles
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *nodo=[self nodeAtPoint:location];
        if ([nodo.name isEqualToString:@"nivel1"]) {
            if ([[info_nivel objectAtIndex:0] isEqualToString:@"NO"]) {
                
                if (nroMundo.intValue == 1) {
                    
                    SKScene *juego = [[Escena_juego_tutorial alloc] initWithSize:self.size];
                    [self.view presentScene:juego transition:reveal];
                    
                }
                else{
                    [informacion setObject:[NSString stringWithFormat:@"1"] forKey:@"nroNivel"];
                    [informacion setObject:[NSString stringWithFormat:@"w%@_lvl1.tmx",nroMundo] forKey:@"nombreNivel"];
                    [informacion setObject:nroMundo forKey:@"nroMundo"];
                    SKScene *juego = [[Escena_juego alloc] initWithSize:self.size conInformacion:informacion conAudioPlayer:ap1];
                    [self.view presentScene:juego transition:reveal];
                    NSLog(@"w%@_lvl1.tmx",nroMundo);
                }
                
            }
            
            
            
        }else if([nodo.name isEqualToString:@"nivel2"]){
            /*SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
             [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
             [cucho runAction:[SKAction moveTo:location duration:2.0]completion:^{
             [cucho removeAllActions];
             SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.1];
             SKScene * gameOverScene = [[Escena_juego alloc] initWithSize:self.size];
             [self.view presentScene:gameOverScene transition:reveal];
             
             }];*/
            if ([[info_nivel objectAtIndex:1] isEqualToString:@"NO"]){
                [informacion setObject:[NSString stringWithFormat:@"2"] forKey:@"nroNivel"];
                [informacion setObject:[NSString stringWithFormat:@"w%@_lvl2.tmx",nroMundo] forKey:@"nombreNivel"];
                [informacion setObject:nroMundo forKey:@"nroMundo"];
                SKScene * juego = [[Escena_juego alloc] initWithSize:self.size conInformacion:informacion conAudioPlayer:ap1];
                [self.view presentScene:juego transition:reveal];
                NSLog(@"w%@_lvl2.tmx",nroMundo);
            }
        }
        else if([nodo.name isEqualToString:@"nivel3"]){
            /*SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
             [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
             [cucho runAction:[SKAction moveTo:location duration:2.5]completion:^{[cucho removeAllActions];}];*/
            if ([[info_nivel objectAtIndex:2] isEqualToString:@"NO"]){
                [informacion setObject:[NSString stringWithFormat:@"3"] forKey:@"nroNivel"];
                [informacion setObject:[NSString stringWithFormat:@"w%@_lvl3.tmx",nroMundo] forKey:@"nombreNivel"];
                [informacion setObject:nroMundo forKey:@"nroMundo"];
                SKScene * juego = [[Escena_juego alloc] initWithSize:self.size conInformacion:informacion conAudioPlayer:ap1];
                [self.view presentScene:juego transition:reveal];
                NSLog(@"w%@_lvl3.tmx",nroMundo);
            }
            
        }
        else if([nodo.name isEqualToString:@"nivel4"]){
            /*SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
             [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
             [cucho runAction:[SKAction moveTo:location duration:2.5]completion:^{[cucho removeAllActions];}];*/
            if ([[info_nivel objectAtIndex:3] isEqualToString:@"NO"]){
                [informacion setObject:[NSString stringWithFormat:@"4"] forKey:@"nroNivel"];
                [informacion setObject:[NSString stringWithFormat:@"w%@_lvl4.tmx",nroMundo] forKey:@"nombreNivel"];
                [informacion setObject:nroMundo forKey:@"nroMundo"];
                SKScene * juego = [[Escena_juego alloc] initWithSize:self.size conInformacion:informacion conAudioPlayer:ap1];
                [self.view presentScene:juego transition:reveal];
                NSLog(@"w%@_lvl4.tmx",nroMundo);
            }
            
        }
        else if([nodo.name isEqualToString:@"nivel5"]){
            /*SKAction *walkAnimation = [SKAction animateWithTextures:cuchoCaminando timePerFrame:0.1];
             [cucho runAction:[SKAction repeatActionForever:walkAnimation]];
             [cucho runAction:[SKAction moveTo:location duration:2.5]completion:^{[cucho removeAllActions];}];*/
            if ([[info_nivel objectAtIndex:4] isEqualToString:@"NO"]){
                [informacion setObject:[NSString stringWithFormat:@"5"] forKey:@"nroNivel"];
                [informacion setObject:[NSString stringWithFormat:@"w%@_lvl5.tmx",nroMundo] forKey:@"nombreNivel"];
                [informacion setObject:nroMundo forKey:@"nroMundo"];
                SKScene * juego = [[Escena_juego alloc] initWithSize:self.size conInformacion:informacion conAudioPlayer:ap1];
                [self.view presentScene:juego transition:reveal];
                NSLog(@"w%@_lvl5.tmx",nroMundo);
            }
        }
        else if([nodo.name isEqualToString:@"atras"]){
            atras=YES;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"borrar" object:self];
            SKTransition *reveal1 = [SKTransition doorsCloseHorizontalWithDuration:1.0];
            SKScene * gameOverScene = [[Escena_mundos alloc] initWithSize:self.size conGameCenter:gc1 conAudioPlayer:ap1];
            [self.view presentScene:gameOverScene transition:reveal1];
        }
    }
    
}
//Nuevo para reconocer niveles
-(void)willMoveFromView:(SKView *)view{
    if (atras) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"anadir" object:self];
    }
    
}



@end
