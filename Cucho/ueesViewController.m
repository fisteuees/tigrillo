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
#import "Escena_juego.h"
#import "View_ajustes.h"
#import "View_terminado.h"
#import "conexionBase.h"
//para volver a tutorial
#import "Escena_juego_tutorial.h"

#import "Escena_mundos.h"

@interface ueesViewController(){
    SKView * skView;
    BOOL isPhone;
    gameCenterManager *gc;
    UIView *mask;
    UIView *mask_terminado;
    View_ajustes *ajustes;
    
    View_terminado *terminado;
    BOOL desplegado;
    BOOL desplegado_terminado;
    conexionBase *cb;
    NSString *mapa;
    //para volver a tutorial
    SKTransition *reveal;
    Escena_menu *es;
    BOOL recargar;
    
    UIImageView *background,*btatras;
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
                                             selector:@selector(jugarDeNuevo:)
                                                 name:@"jugardenuevo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarMenu:)
                                                 name:@"mostrarmenu"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(siguienteNivel:)
                                                 name:@"siguientenivel"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mostrarTerminado:)
                                                 name:@"mostrarTerminado"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertBase:)
                                                 name:@"insertBase"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(nombreMapa:)
                                                 name:@"nombreMapa"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recargarEscena)
                                                 name:@"recargarEscena"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(borrarFondo)
                                                 name:@"borrarFondo"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eliminarAtras)
                                                 name:@"eliminarAtras"
                                               object:nil];
    //base de datos
    cb = [[conexionBase alloc]init];
    [cb abrirBD];
    [cb crearTabla:@"prueba" conCampo1:@"id" conCampo2:@"nombre" conCampo3:@"puntaje" conCampo4:@"tema"];
    
    background=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pre_fondo_bosque"]];
    btatras=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bt_atras"]];
    
    [btatras setFrame:CGRectMake(20, 20, btatras.frame.size.width, btatras.frame.size.height)];
    
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
    if ( !skView.scene ) {
        
        scene = [[Escena_menu alloc]initWithSize:skView.bounds.size conGameCenter:gc];
        scene.scaleMode = SKSceneScaleModeAspectFit;
        
        [skView presentScene:scene];
    }

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(mostrarGCController)
     name:@"mostrarGCController"
     object:nil];
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
    if (!recargar) {
        
        es=notification.object;
        
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

    [self.carousel reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"anadirAtras" object:self];
        
    }
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is availab le for recycling
    //if (view == nil)
    //{
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
            ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_bosque"];
            label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
            label.text = @"Mundo de bosque";
            
            background.image=[UIImage imageNamed:@"pre_fondo_bosque"];
            [self.view addSubview:background];
            [self.view sendSubviewToBack:background];
            self.view.contentMode=UIViewContentModeScaleAspectFit;
            
            btatras.image=[UIImage imageNamed:@"bt_atras"];
            [self.view addSubview:btatras];
            
           
            
            NSLog(@"mundo bosque");
            break;
        case 1:
            ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_nieve"];
            label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
            label.text = @"Mundo de Nieve";
            NSLog(@"mundo nieve");
            break;
        case 2:
            ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_agua"];
            label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
            label.text = @"Mundo de Agua";
            NSLog(@"mundo agua");
            break;
        case 3:
            ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_fuego"];
            label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
            label.text = @"Mundo de Fuego";
            NSLog(@"mundo fuego");
            break;
        case 4:
            ((UIImageView *)view).image = [UIImage imageNamed:@"pre_mundo_cementerio"];
            label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+300, view.frame.size.width, view.frame.size.height)];
            label.text = @"Mundo de Cementerio";
            NSLog(@"mundo cementerio");
            break;
    }
    
        view.contentMode = UIViewContentModeCenter;
        //view.clipsToBounds=YES;
    
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    
  //  }

    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    return view;
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    switch ([carousel currentItemIndex]) {
        case 0:
            background.image=[UIImage imageNamed:@"pre_fondo_bosque"];
            break;
        case 1:
            background.image=[UIImage imageNamed:@"pre_fondo_nieve"];
            break;
        case 2:
            background.image=[UIImage imageNamed:@"pre_fondo_agua"];
            break;
        case 3:
            background.image=[UIImage imageNamed:@"pre_fondo_fuego"];
            break;
        case 4:
            background.image=[UIImage imageNamed:@"pre_fondo_cementerio"];
            break;
            
        default:
            break;
    }
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    self.view.contentMode=UIViewContentModeScaleAspectFit;
    
}

-(void)eliminarAtras{
    [btatras removeFromSuperview];
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        //NSLog(@"espacio: %f",value * 3.3f);
        return value * 3.3f;
    }
    if (option == iCarouselOptionTilt)
    {
        //NSLog(@"tilt: %f",0.1f);
        return 0.1f;
    }
    return value;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"SI PASA DID SELECT %ld",(long)index);
    
    [background removeFromSuperview];
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    [carousel removeFromSuperview];
    //[UIView commitAnimations];
    
    //Nuevo para reconocer niveles
    NSMutableDictionary *informacion = [[NSMutableDictionary alloc] init];
    NSString *nroMundo = [NSString stringWithFormat:@"%li",(long)index+1];
    [informacion setObject:nroMundo forKey:@"nroMundo"];
        SKTransition *reveal = [SKTransition crossFadeWithDuration:0.7];
    Escena_mundos *current_scene=(Escena_mundos*)skView.scene;
         SKScene * gameOverScene = [[Escena_nivel alloc] initWithSize:skView.bounds.size conGameCenter:gc conInformacion:informacion conAudioPlayer:current_scene.ap1];
    
        [skView presentScene:gameOverScene transition:reveal];
    
    //Nuevo para reconocer niveles

}

-(void)borrarCarousel:(NSNotification *)notification
{
    [self.carousel removeFromSuperview];
    
}

#pragma mark View ajustes

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
    
     recargar=NO;
        mask.alpha=0.0f;
    [mask removeFromSuperview];
    desplegado=NO;
    [skView.scene setUserInteractionEnabled:YES];
    
}

#pragma mark View terminado
//Nuevo para reconocer niveles
-(void)mostrarTerminado:(NSNotification *)notification{
    NSDictionary *puntajes = notification.userInfo;
    //NSNumber *monedas = [puntajes objectForKey:@"monedas"];
    //NSString *puntaje = [NSString stringWithFormat:@"%i",monedas.intValue];
    //NSString *mundo = [puntajes objectForKey:@"mundo"];
    //NSString *nivel = [puntajes objectForKey:@"nivel"];
    
    CGRect rect = CGRectMake(CGRectGetMidX(skView.bounds),CGRectGetMidY(skView.bounds), 350, 450);
    terminado = [[View_terminado alloc] initWithFrame:rect withPuntaje:puntajes];//[NSString stringWithFormat:@"Puntaje = %@",puntaje]];
    //[terminado.score setText:[NSString stringWithFormat:@"Puntaje= %@",puntaje]];
    terminado.layer.anchorPoint = CGPointMake(1, 1);
    terminado.alpha=0.0f;
    [terminado setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
    [self.view addSubview:terminado];
    //ajustes.center = CGPointMake(ajustes.frame.size.width / 2, ajustes.frame.size.height / 2);
    [UIView animateWithDuration:0.5
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [terminado setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                         terminado.alpha=1.0f;
                         
                         
                     }
                     completion:^(BOOL finished){
                         mask_terminado = [[UIView alloc] initWithFrame:skView.bounds];
                         [mask_terminado setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.38]];
                         [self.view addSubview:mask_terminado];
                         [self.view sendSubviewToBack:mask_terminado];
                         desplegado_terminado=YES;
                         
                         
                     }];
    
}
//Nuevo para reconocer niveles
-(void)siguienteNivel:(NSNotification *)notification{
    
    mask_terminado.alpha=0.0f;
    [mask_terminado removeFromSuperview];
    desplegado_terminado=NO;
    [skView.scene setUserInteractionEnabled:YES];
    NSDictionary *informacion = [NSDictionary dictionary];
    informacion = notification.userInfo;
    NSString *mundo1 = [informacion objectForKey:@"nroMundo"];
    NSString *nivel1 = [informacion objectForKey:@"nroNivel"];
    NSString *nomNivel;
    int mundoInt = [mundo1 intValue];
    int nivelInt = [nivel1 intValue];
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    if (mundoInt<5 && nivelInt==5) {
        mundoInt++;
    }else if (mundoInt==5 && nivelInt==5){
        mundoInt=1;
        //para volver a tutorial
        SKScene *juego = [[Escena_juego_tutorial alloc] initWithSize:skView.bounds.size];
        [skView presentScene:juego transition:reveal];
    }
    if (nivelInt<5) {
        nivelInt++;
    }else if (nivelInt==5){
        nivelInt=1;
    }
    
    nomNivel = [NSString stringWithFormat:@"w%i_lvl%i.tmx",mundoInt,nivelInt];
    
    [info setObject:[NSString stringWithFormat:@"%i",mundoInt] forKey:@"nroMundo"];
    [info setObject:[NSString stringWithFormat:@"%i",nivelInt] forKey:@"nroNivel"];
    [info setObject:nomNivel forKey:@"nombreNivel"];
    
    /*SKTransition */reveal = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    SKScene * gameOverScene = [[Escena_juego alloc] initWithSize:skView.bounds.size conInformacion:info conAudioPlayer:es.audioPlayer]; //withBase: cb
    [skView presentScene:gameOverScene transition: reveal];
    
    NSLog(@"siguiente nivel");
    
}

//Nuevo para reconocer niveles
-(void)jugarDeNuevo:(NSNotification *)notification{
    NSDictionary *informacion = [NSDictionary dictionary];
    informacion = notification.userInfo;
    NSString *mundo1 = [informacion objectForKey:@"nroMundo"];
    NSString *nivel1 = [informacion objectForKey:@"nroNivel"];
    NSString *nomNivel;
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    nomNivel = [NSString stringWithFormat:@"w%@_lvl%@.tmx",mundo1,nivel1];
    [info setObject:[NSString stringWithFormat:@"%@",mundo1] forKey:@"nroMundo"];
    [info setObject:[NSString stringWithFormat:@"%@",nivel1] forKey:@"nroNivel"];
    [info setObject:nomNivel forKey:@"nombreNivel"];
    mask_terminado.alpha=0.0f;
    [mask_terminado removeFromSuperview];
    desplegado_terminado=NO;
    [skView.scene setUserInteractionEnabled:YES];
    
    SKTransition *reveal1 = [SKTransition doorsOpenHorizontalWithDuration:1.0];
    SKScene * gameOverScene = [[Escena_juego alloc] initWithSize:skView.bounds.size conInformacion:info conAudioPlayer:es.audioPlayer]; //withBase: cb
    [skView presentScene:gameOverScene transition: reveal1];
    
    NSLog(@"jugar de nuevo");
    
}

-(void)mostrarMenu:(NSNotification *)notification{
    
    mask_terminado.alpha=0.0f;
    [mask_terminado removeFromSuperview];
    desplegado_terminado=NO;
    [skView.scene setUserInteractionEnabled:YES];
    
    SKTransition *reveal1 = [SKTransition doorsCloseHorizontalWithDuration:1.0];
    SKScene * gameOverScene = [[Escena_menu alloc] initWithSize:skView.bounds.size conGameCenter:gc]; //withBase: cb
    [skView presentScene:gameOverScene transition: reveal1];
    
    NSLog(@"mostrar menu");
    
}

-(void)insertBase:(NSNotification *)notification{
    //------------------Nuevo para base de datos
    NSDictionary* userInfo = notification.userInfo;
    int puntaje = [[userInfo objectForKey:@"total"] intValue];
    [cb insert:puntaje];
    NSLog (@"Successfully received test notification! %i", puntaje);
    //----------------Nuevo para base de datos
}

-(void)nombreMapa:(NSNotification *)notification{
    NSDictionary* userInfo = notification.userInfo;
    mapa = [userInfo objectForKey:@"mapa"];
    NSLog(@"%@",mapa);
}

-(void)recargarEscena{
    SKScene *scene;
    scene = [[Escena_menu alloc]initWithSize:skView.bounds.size conGameCenter:gc];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    recargar=YES;
    [skView presentScene:scene];
    
}

-(void)borrarFondo{
    [background removeFromSuperview];
}



@end
