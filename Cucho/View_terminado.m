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
    
    
}

@end

@implementation View_terminado

- (id)initWithFrame:(CGRect)frame
{
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
    [self addSubview:mainView];
    
}

-(IBAction)jugarDeNuevo:(id)sender{
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
                         self.alpha=0.0f;
                         [self removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"jugardenuevo" object:nil];
                         
                     }];
}

-(IBAction)siguienteNivel:(id)sender{
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setTransform:CGAffineTransformMakeScale(0.0, 0.0)];
                         self.alpha=0.0f;
                         [self removeFromSuperview];
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"siguientenivel" object:nil];
                         
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
@end
