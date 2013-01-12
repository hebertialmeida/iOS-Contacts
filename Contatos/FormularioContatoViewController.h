//
//  FormularioContatoViewController.h
//  Contatos
//
//  Created by Heberti Almeida on 07/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Contato.h"
#import "ListaContatosProtocol.h"

@interface FormularioContatoViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nome;
@property (weak, nonatomic) IBOutlet UITextField *telefone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *endereco;
@property (weak, nonatomic) IBOutlet UITextField *site;
@property (weak, nonatomic) IBOutlet UIButton    *btnFoto;
@property (weak, nonatomic) IBOutlet UITextField *twitter;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UIButton *gps;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spiner;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ok;

@property (strong) NSMutableArray *contatos;
@property (weak) id<ListaContatosProtocol> delegate;

- (id)initWithContato:(Contato *)contato;
- (IBAction)selecionaFoto:(id)sender;
- (IBAction)buscarCordenadas:(id)sender;

@end