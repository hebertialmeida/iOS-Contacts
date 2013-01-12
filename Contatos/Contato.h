//
//  Contato.h
//  Contatos
//
//  Created by Heberti Almeida on 07/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface Contato : NSObject <NSCoding, MKAnnotation>

@property (strong) NSString *nome;
@property (strong) NSString *telefone;
@property (strong) NSString *email;
@property (strong) NSString *endereco;
@property (strong) NSString *site;
@property (strong) UIImage  *foto;
@property (strong) NSString *twitter;
@property (strong) NSNumber *latitude;
@property (strong) NSNumber *longitude;

@end
