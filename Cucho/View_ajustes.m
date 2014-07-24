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
    bool isPhone;

    
}

@end

@implementation View_ajustes

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
        
        self.backgroundColor = [UIColor blackColor]; //clearColor is an option along with many other preset colors.
        [self setBackground];
        
    }
    return self;
}

-(void) setBackground {
    
    CGRect theFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIImageView* background  = [[UIImageView alloc] initWithFrame:theFrame];
    background.image = [UIImage imageNamed:@"fondo_ajustes"];
    
    
    [self addSubview:background]; //as long as this method runs before everything else, this will go at an index of 0
    
    UIImageView* equis  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    equis.image = [UIImage imageNamed:@"ajustes_equis"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50, 50);
    button.layer.anchorPoint = CGPointMake(1, 1);
    [button setImage:equis.image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cerrarVentana:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:button];
    
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

                         
                     }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cerrar" object:nil];//revsar esta notificacion, parece que hay un error haciendo los notifications en los uiviews
}
@end
