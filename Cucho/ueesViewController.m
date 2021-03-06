//
//  ueesViewController.m
//  Cucho
//
//  Created by Centro de Investigaciones on 29/05/14.
//  Copyright (c) 2014 FISTE. All rights reserved.
//

#import "ueesViewController.h"
#import "Escena_menu.h"
#import "gameCenterManager.h"
#import "Escena_nivel.h"
#import "View_ajustes.h"
#import "conexionBase.h"

@interface ueesViewController(){
    SKView * skView;
    BOOL isPhone;
    gameCenterManager *gc;
    UIView *mask;
    View_ajustes *ajustes;
    BOOL desplegado;
}

@end

@implementation ueesViewController

-(void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:@"anadir"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(borrarCarousel:)
                                                 name:@"borrar"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cerrarVentanaAjustes:)
                                                 name:@"cerrar"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarAjustes:)
                                                 name:@"mostrarAjustes"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertBase:)
                                                 name:@"insertBase"
                                               object:nil];
    //base de datos
    conexionBase *cb = [[conexionBase alloc]init];
    [cb abrirBD];
    [cb crearTabla:@"prueba" conCampo1:@"id" conCampo2:@"nombre" conCampo3:@"puntaje" conCampo4:@"tema"];
    
    
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Configure the view.
    skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    gc=[gameCenterManager solicitarManager];
    [gc autenticarJugador];
    SKScene *scene;
    // Create and configure the scene.
    if ( !skView.scene ) {
        
        scene = [[Escena_menu alloc]initWithSize:skView.bounds.size conGameCenter:gc];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        
        [skView presentScene:scene];
    }
   /* self.items = [NSMutableArray array];
    for (int i = 1; i <=5; i++)
    {
        [_items addObject:@(i)];
    }
    self.carousel=[[iCarousel alloc]initWithFrame:scene.frame];
    self.carousel.backgroundColor=[UIColor blackColor];
    NSLog(@"frame view: %@",NSStringFromCGRect(skView.frame));
    self.carousel.dataSource=self;
    self.carousel.delegate=self;*/
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(mostrarGCController)
     name:@"mostrarGCController"
     object:nil];
    // Present the scene.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)mostrarGCController{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate =self;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
        [self presentViewController: gameCenterController animated: YES
                         completion:nil];
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark iCarousel methods

-(void)reload:(NSNotification *)notification
{
    NSLog(@"ANADIR");
    self.items = [NSMutableArray array];
    for (int i = 1; i <=5; i++)
    {
        [_items addObject:@(i)];
    }
    self.carousel=[[iCarousel alloc]initWithFrame:skView.bounds];
    self.carousel.backgroundColor=[UIColor clearColor];
    self.carousel.dataSource=self;
    self.carousel.delegate=self;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.25];
    self.carousel.type=iCarouselTypeCoverFlow2
    ;
    [self.view addSubview:self.carousel];
    [UIView commitAnimations];
    /*[UIView animateWithDuration:1.25 animations:^{
     [self.view addSubview:self.carousel];
     }];*/
    [self.carousel reloadData];
    NSLog(@"frame view: %@",NSStringFromCGRect(skView.frame));
    NSLog(@"frame scena 2: %@",NSStringFromCGRect(skView.scene.frame));
    //NSLog(@"frame scena 2: %@",NSStringFromCGRect(skView.));
    
    
    
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    NSLog(@"datasource items : %d",_items.count);
    return [_items count];
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is availab le for recycling
    if (view == nil)
    {
        NSLog(@"de entrar entra" );
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            isPhone = YES;
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 400.0f)];
            //((UIImageView *)view).image = [UIImage imageNamed:@"mario_phone.jpg"];
        } else {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800.0f, 800.0f)];
            //((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_nieve.jpg"];
        }
        
        switch (index) {
            case 0:
                 ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_nieve"];
                label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
                label.text = @"Mundo de nieve";
                NSLog(@"mundo nieve");
                break;
            case 1:
                ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_fuego"];
                label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
                label.text = @"Mundo de fuego";
                NSLog(@"mundo fuego");
                break;
            case 2:
                ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_montana"];
                label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
                label.text = @"Mundo de montaña";
                NSLog(@"mundo montaña");
                break;
            case 3:
                ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_agua"];
                label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
                label.text = @"Mundo de agua";
                NSLog(@"mundo agua");
                break;
            case 4:
                ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_bosque"];
                label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
                label.text = @"Mundo de bosque";
                NSLog(@"mundo bosque");
                break;
        }
        
        view.contentMode = UIViewContentModeCenter;
        //view.clipsToBounds=YES;
        
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    return view;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        NSLog(@"espacio: %f",value * 3.3f);
        return value * 3.3f;
    }
    if (option == iCarouselOptionTilt)
    {
        NSLog(@"tilt: %f",0.1f);
        return 0.1f;
    }
    return value;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"SI PASA DID SELECT %d",index);
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    [carousel removeFromSuperview];
    //[UIView commitAnimations];
    
        SKTransition *reveal = [SKTransition crossFadeWithDuration:0.7];
    SKScene * gameOverScene = [[Escena_nivel alloc] initWithSize:skView.bounds.size conGameCenter:gc];
        [skView presentScene:gameOverScene transition:reveal];
    

}

-(void)borrarCarousel:(NSNotification *)notification
{
    [self.carousel removeFromSuperview];
    
}

-(void)mostrarAjustes:(NSNotification *)notification{
    
    CGRect rect = CGRectMake(CGRectGetMidX(skView.bounds),CGRectGetMidY(skView.bounds), 364, 492);
    ajustes = [[View_ajustes alloc] initWithFrame:rect];
    ajustes.layer.anchorPoint = CGPointMake(1, 1);
    ajustes.alpha=0.0f;
    [ajustes setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
    [self.view addSubview:ajustes];
    //ajustes.center = CGPointMake(ajustes.frame.size.width / 2, ajustes.frame.size.height / 2);
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [ajustes setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                         ajustes.alpha=1.0f;
                         
                         
                     }
                     completion:^(BOOL finished){
                         mask = [[UIView alloc] initWithFrame:skView.bounds];
                         [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.38]];
                         [self.view addSubview:mask];
                         [self.view sendSubviewToBack:mask];
                         desplegado=YES;
                         
                         
                     }];
    
}




-(void)cerrarVentanaAjustes:(NSNotification *)notification{
    
    
        mask.alpha=0.0f;
    [mask removeFromSuperview];
    desplegado=NO;
    [skView.scene setUserInteractionEnabled:YES];
    
}

-(void)insertBase:(NSNotification *)notification{
    
}


@end
