//
//  FormularioContatoViewController.m
//  Contatos
//
//  Created by Heberti Almeida on 07/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import "FormularioContatoViewController.h"


@interface FormularioContatoViewController ()
    @property (strong) Contato *contato;
@end


@implementation FormularioContatoViewController

@synthesize nome, telefone, email, endereco, site, btnFoto, twitter, latitude, longitude, spiner, ok, contato, delegate;

// Init in edit mode
- (id)initWithContato:(Contato *)_contato
{
    self = [super init];
    if (self) {
        self.contato = _contato;
        
        UIBarButtonItem *confirmar = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Salvar"
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(atualizaContato)];
        self.navigationItem.rightBarButtonItem = confirmar;
    }
    return self;
}

// Overrides init method
- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Cadastro";
        
        // Add cancel button
        UIBarButtonItem *cancela = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Cancelar"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(escondeFormulario)];
        self.navigationItem.leftBarButtonItem = cancela;
        
        // Add ok button
        ok = [[UIBarButtonItem alloc]
              initWithTitle:@"Adicionar"
              style:UIBarButtonItemStylePlain
              target:self
              action:@selector(criaContato)];
        self.navigationItem.rightBarButtonItem = ok;
        
        // Disable ok button
        ok.enabled = NO;
        
        // Add notification for Nome change
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(enableOkButton)
         name:UITextFieldTextDidChangeNotification
         object:nome];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.contato) {
        nome.text = contato.nome;
        telefone.text = contato.telefone;
        email.text = contato.email;
        endereco.text = contato.endereco;
        site.text = contato.site;
        twitter.text = contato.twitter;
        latitude.text = [contato.latitude stringValue];
        longitude.text = [contato.longitude stringValue];
        
        if (contato.foto) {
            [btnFoto setImage:contato.foto forState:UIControlStateNormal];
        }
    }
    
    // Add observer for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoApareceu:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoSumiu:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)escondeFormulario
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)enableOkButton
{
    ok.enabled = YES;
}

- (Contato *)pegaDadosDoFormulario
{
    if (!self.contato) {
         contato = [[Contato alloc] init];
    }
    
    if (btnFoto.imageView.image) {
        contato.foto = btnFoto.imageView.image;
    }
    
    contato.nome      = nome.text;
    contato.telefone  = telefone.text;
    contato.email     = email.text;
    contato.endereco  = endereco.text;
    contato.site      = site.text;
    contato.twitter   = twitter.text;
    contato.latitude  = [NSNumber numberWithFloat:[latitude.text floatValue]];
    contato.longitude = [NSNumber numberWithFloat:[longitude.text floatValue]];
    
    return contato;
}

- (void)criaContato
{
    // Class Contato
    Contato *novoContato = [self pegaDadosDoFormulario];
    
    [self.contatos addObject:novoContato];
    [self escondeFormulario];
    if (self.delegate) {
        [self.delegate contatoAdicionado:novoContato];
    }
}

- (void)atualizaContato
{
    Contato *contatoAtualizado = [self pegaDadosDoFormulario];
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.delegate) {
        [self.delegate contatoAtualizado:contatoAtualizado];
    }
}

- (IBAction)selecionaFoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //disponivel
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imagemSelecionada = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [btnFoto setImage:imagemSelecionada forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// Next text field on return
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSLog(@"return");
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

// Hide Keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tecladoApareceu:(NSNotification *)notification
{
    NSLog(@"um teclado apareceu");
}

- (void)tecladoSumiu:(NSNotification *)notification
{
    NSLog(@"um teclado sumiu");
}


//
- (IBAction)buscarCordenadas:(id)sender
{
    [spiner startAnimating];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:endereco.text completionHandler:^(NSArray *resultados, NSError *error) {
        if (error == nil && [resultados count] > 0) {
            CLPlacemark *resultado = [resultados objectAtIndex:0];
            CLLocationCoordinate2D cordenada = resultado.location.coordinate;
            
            latitude.text = [NSString stringWithFormat:@"%.06f", cordenada.latitude];
            longitude.text = [NSString stringWithFormat:@"%.06f", cordenada.longitude];
            
        }
        [spiner stopAnimating];
    }];
}


@end
