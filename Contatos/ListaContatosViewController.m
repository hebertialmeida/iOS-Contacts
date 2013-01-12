//
//  ListaContatosViewController.m
//  Contatos
//
//  Created by Heberti Almeida on 08/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import "ListaContatosViewController.h"
#import "FormularioContatoViewController.h"
#import "Contato.h"


@implementation ListaContatosViewController

@synthesize contatos, linhaDestaque;

- (id)init
{
    self = [super init];
    if (self) {
        
        //Add tabbar item
        UIImage *imagemTabItem = [UIImage imageNamed:@"lista-contatos.png"];
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"Contatos" image:imagemTabItem tag:0];
        
        self.tabBarItem = tabItem;
        self.navigationItem.title = NSLocalizedString(@"contatos", nil);
        
        // Add button item +
        UIBarButtonItem *botaoExibirFormulario = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(exibeFormulario)];
        self.navigationItem.rightBarButtonItem = botaoExibirFormulario;
        
        // Add Edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        self.editButtonItem.title = @"Editar";
        
        linhaDestaque = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    // Add Long Press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(exibeMaisAcoes:)];
    [self.tableView addGestureRecognizer:longPress];
    
    // Custom cell
    [self.tableView registerNib:[UINib nibWithNibName:@"customCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"customCell"];
    self.tableView.rowHeight = 54;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Reload tableView
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (linhaDestaque >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:linhaDestaque inSection:0];
        
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        
        linhaDestaque = -1;
    }
}


- (void)exibeFormulario
{
    FormularioContatoViewController *form = [[FormularioContatoViewController alloc] init];
    
    //Reference contatos
    form.delegate = self;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:form];
    
    //form.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal; //Change transition effect
    [self presentViewController:navigation animated:YES completion:nil];
}

// Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contatos count];
}

// Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"customCell";
    
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
//    if (!cell) {
//        cell = [[UITableViewCell alloc]
//                initWithStyle:UITableViewCellStyleDefault
//                reuseIdentifier:cellIdentifier];
//    }
    
    Contato *contato = [self.contatos objectAtIndex:indexPath.row];
    //cell.textLabel.text = contato.nome;
    //cell.detailTextLabel.text = contato.email;
    
    cell.titleLabel.text = contato.nome;
    cell.subTitleLabel.text = contato.email;
    cell.image.image = contato.foto;
    
    return cell;
}

// Selected row in table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contato * contato = [self.contatos objectAtIndex:indexPath.row];
    
    FormularioContatoViewController *form = [[FormularioContatoViewController alloc] initWithContato:contato];
    form.delegate = self;
    form.contatos = self.contatos;
    
    [self.navigationController pushViewController:form animated:YES];
}

// Editing table itens
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.contatos removeObjectAtIndex:indexPath.row];
    }
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

// Move row
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Contato *contato = [self.contatos objectAtIndex:sourceIndexPath.row];
    
    [self.contatos removeObjectAtIndex:sourceIndexPath.row];
    [self.contatos insertObject:contato atIndex:destinationIndexPath.row];
}


// Change Edit Title
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Make sure you call super first
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        self.editButtonItem.title = @"Pronto";
    }
    else
    {
        self.editButtonItem.title = @"Editar";
    }
}


// Protocol log
- (void)contatoAtualizado:(Contato *)contato {
    NSLog(@"Atualizado: %d", [self.contatos indexOfObject:contato]);
    linhaDestaque = [self.contatos indexOfObject:contato];
}

- (void)contatoAdicionado:(Contato *)contato {
    NSLog(@"Adicionado: %d", [self.contatos indexOfObject:contato]);
    [self.contatos addObject:contato];
    linhaDestaque = [self.contatos indexOfObject:contato];
    [self.tableView reloadData];
}

// Show more options
- (void)exibeMaisAcoes:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint ponto = [gesture locationInView:self.tableView];
        NSIndexPath *index = [self.tableView indexPathForRowAtPoint:ponto];
        
        contatoSelecionado = [contatos objectAtIndex:index.row];
        
        UIActionSheet *opcoes = [[UIActionSheet alloc] initWithTitle:contatoSelecionado.nome
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancelar"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Ligar",@"Enviar Email", @"Visualizar site", @"Abrir Mapa", @"Enviar Tweet", nil];
        
        [opcoes showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self ligar];
            break;
        case 1:
            [self enviarEmail];
            break;
        case 2:
            [self abrirSite];
            break;
        case 3:
            [self abrirMapa];
            break;
        case 4:
            [self abrirTwitter];
            break;
      default:
            break;
    }
}

- (void)ligar
{
    UIDevice *device = [UIDevice currentDevice];
    if ([device.model isEqualToString:@"iPhone"]) {
        NSString *numero = [NSString stringWithFormat:@"telprompt://%@", contatoSelecionado.telefone];
        [self openUrl:numero];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Indisponível" message:@"Seu dispositivo não tem telefone" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    
}

- (void)abrirSite
{
    NSString *url = contatoSelecionado.site;
    [self openUrl:url];
}

- (void)enviarEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *enviadorEmail = [[MFMailComposeViewController alloc] init];
        
        enviadorEmail.mailComposeDelegate = self;
        
        [enviadorEmail setToRecipients:[NSArray arrayWithObject:contatoSelecionado.email]];
        [enviadorEmail setSubject:@"Contato"];
        
        [self presentViewController:enviadorEmail animated:YES completion:nil];
    } else {
        NSLog(@"Não pode enviar email");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)abrirMapa
{
    NSString *url = [[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", contatoSelecionado.endereco] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self openUrl:url];
}

- (void)abrirTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        if (contatoSelecionado.twitter) {
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ ", contatoSelecionado.twitter]];
        }
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (void)openUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
