//
//  View_ajustes.m
//  Cucho Run
//
//  Created by FISTE on 01/07/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "View_ajustes.h"

@interface View_ajustes() {
    
    UISwitch* voiceFXSwitch;
    UISwitch* soundFXSwitch;
    BOOL isPhone;
    
    
}

@end

@implementation View_ajustes

@synthesize musica;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        NSLog(@" Option Screen is Open");
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            isPhone = YES;
            
        } else {
            
            isPhone = NO;
            
        }
        
        self.backgroundColor = [UIColor clearColor]; //clearColor is an option along with many other preset colors.
        [self setBackground];
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([defaults integerForKey:@"estadoSwitch1"]==0) {
            [self.musica setOn:NO];
            
        }else{
            [self.musica setOn:YES];
        }
        
        if ([defaults integerForKey:@"estadoSwitch2"]==0) {
            [self.sonido setOn:NO];
        }else{
            [self.sonido setOn:YES];
        }
        [defaults synchronize];
        
        
    }
    return self;
}

-(void) setBackground {
    
    CGRect theFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    /*UIImageView* background  = [[UIImageView alloc] initWithFrame:theFrame];
     background.image = [UIImage imageNamed:@"fondo_ajustes"];
     
     
     [self addSubview:background]; //as long as this method runs before everything else, this will go at an index of 0
     */
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ajustes_view" owner:self options:nil];
    UIView *mainView = [subviewArray objectAtIndex:0];
    mainView.frame=theFrame;
    [self addSubview:mainView];
    UIImageView* equis  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    equis.image = [UIImage imageNamed:@"ajustes_equis"];
    equis.layer.anchorPoint = CGPointMake(1, 1);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 50);
    button.layer.anchorPoint = CGPointMake(1, 1);
    [button setImage:equis.image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cerrarVentana:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    self.musica = [[UISwitch alloc] initWithFrame: CGRectMake(273, 209, 51, 31)];
    [self.musica addTarget: self action: @selector(switchSeleccionadoMusica:) forControlEvents: UIControlEventValueChanged];
    // Set the desired frame location of onoff here
    [self addSubview: self.musica];
    
    self.sonido = [[UISwitch alloc] initWithFrame: CGRectMake(273, 305, 51, 31)];
    [self.sonido addTarget: self action: @selector(switchSeleccionadoSonido:) forControlEvents: UIControlEventValueChanged];
    // Set the desired frame location of onoff here
    [self addSubview: self.sonido];
    
    
    
    
}

-(IBAction)cerrarVentana:(id)sender{
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
                         self.alpha=0.0f;
                         [self removeFromSuperview];
                         NSLog(@"si entra");
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"cerrar" object:nil];
                         
                         
                         
                     }];
    //revsar esta notificacion, parece que hay un error haciendo los notifications en los uiviews
}

-(IBAction)switchSeleccionadoMusica:(id)sender{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (self.musica.on) {
        [defaults setInteger:1 forKey:@"estadoSwitch1"];
        [defaults setBool:YES forKey:@"repMusica"];
        
        
    }else{
        [defaults setInteger:0 forKey:@"estadoSwitch1"];
        [defaults setBool:NO forKey:@"repMusica"];
    }
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recargarEscena" object:nil];
}

-(IBAction)switchSeleccionadoSonido:(id)sender{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if (self.sonido.on) {
        [defaults setInteger:1 forKey:@"estadoSwitch2"];
        [defaults setBool:YES forKey:@"repSonido"];
    }else{
        [defaults setInteger:0 forKey:@"estadoSwitch2"];
        [defaults setBool:NO forKey:@"repSonido"];
    }
    [defaults synchronize];
}


@end
