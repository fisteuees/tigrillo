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

@interface ueesViewController(){
    SKView * skView;
    BOOL isPhone;
}

@end

@implementation ueesViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:@"anadir"
                                               object:nil];
    // Configure the view.
    skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    gameCenterManager *gc=[gameCenterManager solicitarManager];
    [gc autenticarJugador];
    SKScene *scene;
    // Create and configure the scene.
    if ( !skView.scene ) {
        
        scene = [[Escena_menu alloc]initWithSize:skView.bounds.size conGameCenter:gc];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        
        [skView presentScene:scene];
    }
    self.items = [NSMutableArray array];
    for (int i = 1; i <=5; i++)
    {
        [_items addObject:@(i)];
    }
    self.carousel=[[iCarousel alloc]initWithFrame:scene.frame];
    self.carousel.backgroundColor=[UIColor whiteColor];
    NSLog(@"frame view: %@",NSStringFromCGRect(skView.frame));
    self.carousel.dataSource=self;
    self.carousel.delegate=self;
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
            ((UIImageView *)view).image = [UIImage imageNamed:@"mario_phone.jpg"];
        } else {
            view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 800.0f, 800.0f)];
            ((UIImageView *)view).image = [UIImage imageNamed:@"mario.jpg"];
        }
        
        view.contentMode = UIViewContentModeCenter;
        //view.clipsToBounds=YES;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:60];
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
    label.text = [_items[index] stringValue];
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

@end
