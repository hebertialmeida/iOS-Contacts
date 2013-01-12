//
//  ListaContatosProtocol.h
//  Contatos
//
//  Created by Heberti Almeida on 09/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contato.h"

@protocol ListaContatosProtocol <NSObject>

- (void)contatoAtualizado:(Contato *)contato;
- (void)contatoAdicionado:(Contato *)contato;

@end
