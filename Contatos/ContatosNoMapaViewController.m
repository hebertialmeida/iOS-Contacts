//
//  ContatosNoMapaViewController.m
//  Contatos
//
//  Created by Heberti Almeida on 10/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import "ContatosNoMapaViewController.h"
#import "Contato.h"

@interface ContatosNoMapaViewController ()

@end

@implementation ContatosNoMapaViewController

@synthesize mapa, contatos;

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *imagemTabItem = [UIImage imageNamed:@"mapa-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Mapa" image:imagemTabItem tag:0];
        
        self.tabBarItem = tabItem;
        self.navigationItem.title = @"Localização";
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapa addAnnotations:contatos];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapa removeAnnotations:contatos];
}

- (void)viewDidLoad
{
    MKUserTrackingBarButtonItem *botaoLocalizacao = [[MKUserTrackingBarButtonItem alloc]
                                                     initWithMapView:mapa];
    self.navigationItem.leftBarButtonItem = botaoLocalizacao;
}


//
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"pino";
    MKPinAnnotationView *pino = (MKPinAnnotationView *)[mapa dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pino) {
        pino = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        pino.annotation = annotation;
    }
    
    Contato *contato = (Contato *)annotation;
    pino.pinColor = MKPinAnnotationColorRed;
    pino.canShowCallout = YES;
    if (contato.foto) {
        UIImageView *imagemContato = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        imagemContato.image = contato.foto;
        pino.leftCalloutAccessoryView = imagemContato;
    }
    
    return pino;
}



@end
