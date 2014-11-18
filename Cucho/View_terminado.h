//
//  View_terminado.h
//  Cucho Run
//
//  Created by FISTE on 23/9/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View_terminado : UIView

@property (nonatomic, retain) IBOutlet UIView *terminado;
@property (weak, nonatomic) IBOutlet UILabel *score;
//Nuevo para reconocer niveles
-(id)initWithFrame:(CGRect)frame withPuntaje: (NSDictionary *)puntaje;
@property (weak, nonatomic) IBOutlet UIButton *siguienteNivel;

@end
