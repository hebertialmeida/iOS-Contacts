//
//  ContatosNoMapaViewController.h
//  Contatos
//
//  Created by Heberti Almeida on 10/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ContatosNoMapaViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapa;
@property (strong, nonatomic) NSMutableArray *contatos;

@end
