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

@implementation ueesViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    [[gameCenterManager solicitarManager]autenticarJugador];
    
    // Create and configure the scene.
    SKScene * scene = [Escena_menu sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController*)gameCenterViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
