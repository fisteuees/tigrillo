//
//  Escena_nivel.h
//  Cucho Run
//
//  Created by FISTE on 08/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "gameCenterManager.h"

@interface Escena_nivel : SKScene


//Nuevo para reconocer niveles
-(id)initWithSize:(CGSize)size conGameCenter:(gameCenterManager*)gc conInformacion:(NSMutableDictionary*)info;

@end
