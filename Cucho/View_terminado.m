//
//  View_terminado.m
//  Cucho Run
//
//  Created by FISTE on 23/9/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "View_terminado.h"

@interface View_terminado() {
    
    UISwitch* voiceFXSwitch;
    UISwitch* soundFXSwitch;
    BOOL isPhone;
    NSNumber *puntuacion;
    NSString *mundo;
    NSString *nivel;
    NSString *puntos;
    
    //para mostrar siguiente
    NSString *ganar;
    
}

@end

@implementation View_terminado
@synthesize score, siguienteNivel;
//Nuevo para reconocer niveles
- (id)initWithFrame:(CGRect)frame withPuntaje:(NSDictionary *)puntaje
{
    mundo = [NSString stringWithFormat:@"%@",[puntaje objectForKey:@"mundo"]];
    nivel = [[NSString alloc] initWithFormat:@"%@",[puntaje objectForKey:@"nivel"]];
    puntuacion = [puntaje objectForKey:@"monedas"];
    //mundo = [puntaje objectForKey:@"mundo"];
    //nivel = [puntaje objectForKey:@"nivel"];
    puntos = [NSString stringWithFormat:@"Puntaje = %i",puntuacion.intValue];
    
    //para mostrar siguiente
    ganar = [puntaje objectForKey:@"gano"];
    NSLog(@"%@",puntos);
    self = [super initWithFrame:frame];
    
    if (self) {
        NSLog(@" Terminado Screen is Open");
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            isPhone = YES;
            
        } else {
            
            isPhone = NO;
            
        }
        
        self.backgroundColor = [UIColor clearColor]; //clearColor is an option along with many other preset colors.
        [self setBackground];
        
    }
    return self;
}

-(void) setBackground {
    
    CGRect theFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    /*UIImageView* background  = [[UIImageView alloc] initWithFrame:theFrame];
     background.image = [UIImage imageNamed:@"fondo_ajustes"];
     
     
     [self addSubview:background]; //as long as this method runs before everything else, this will go at an index of 0
     */
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"terminado_view" owner:self options:nil];
    UIView *mainView = [subviewArray objectAtIndex:0];
    mainView.frame=theFrame;
    //
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.frame = CGRectMake(116, 104, 118, 21);
    lbl1.text = puntos;
    [mainView addSubview:lbl1];
    [mainView addSubview:siguienteNivel];
    NSLog(@"Se añade");
    //
    //Nuevo para reconocer niveles
    //para mostrar siguiente
    if ([ganar isEqualToString:@"gano"]) {
        if (mundo.intValue == 5 && nivel.intValue == 5) {
            
        }else{
        UIButton *siguiente = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [siguiente addTarget:self action:@selector(siguiente:) forControlEvents:UIControlEventTouchUpInside];
        [siguiente setTitle:@"Siguiente Nivel" forState:UIControlStateNormal];
        siguiente.frame = CGRectMake(118, 177, 115, 30);
        [mainView addSubview:siguiente];
        }
    }
    
    //
    UIButton *deNuevo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deNuevo addTarget:self action:@selector(jugarDeNuevo:) forControlEvents:UIControlEventTouchUpInside];
    [deNuevo setTitle:@"Jugar de nuevo" forState:UIControlStateNormal];
    deNuevo.frame = CGRectMake(121, 231, 108, 43);
    [mainView addSubview:deNuevo];
    //
    [self addSubview:mainView];
    
}

-(IBAction)jugarDeNuevo:(id)sender{
    NSMutableDictionary *mundoNivel = [NSMutableDictionary dictionary];
    [mundoNivel setObject:mundo forKey:@"nroMundo"];
    [mundoNivel setObject:nivel forKey:@"nroNivel"];
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
                         self.alpha=0.0f;
                         [self removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"jugardenuevo" object:self userInfo:mundoNivel];
                         
                     }];
}
//Nuevo para reconocer niveles
-(IBAction)siguienteNivel:(id)sender{
    NSMutableDictionary *mundoNivel = [NSMutableDictionary dictionary];
    //mundo = [NSString stringWithFormat:@"4"];
    [mundoNivel setObject:mundo forKey:@"nroMundo"];
    [mundoNivel setObject:nivel forKey:@"nroNivel"];
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
                         self.alpha=0.0f;
                         [self removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"siguientenivel" object:self userInfo:mundoNivel];
                         
                     }];
}

-(IBAction)salirMenu:(id)sender{
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
                         self.alpha=0.0f;
                         [self removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"mostrarmenu" object:nil];
                         
                     }];
}

//Nuevo para reconocer niveles
-(IBAction)siguiente:(id)sender{
    NSMutableDictionary *mundoNivel = [NSMutableDictionary dictionary];
    //mundo = [NSString stringWithFormat:@"4"];
    [mundoNivel setObject:mundo forKey:@"nroMundo"];
    [mundoNivel setObject:nivel forKey:@"nroNivel"];
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
                         self.alpha=0.0f;
                         [self removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"siguientenivel" object:self userInfo:mundoNivel];
                         
                     }];
}
@end
