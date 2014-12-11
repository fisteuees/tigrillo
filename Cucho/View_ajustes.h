//
//  View_ajustes.h
//  Cucho Run
//
//  Created by FISTE on 01/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View_ajustes : UIView

@property (nonatomic, retain) IBOutlet UIView *ajustes;
@property  UISwitch *musica;
@property (nonatomic, strong) IBOutlet UISwitch *sonido;

-(IBAction)switchSeleccionadoMusica:(id)sender;
-(IBAction)switchSeleccionadoSonido:(id)sender;

@end
