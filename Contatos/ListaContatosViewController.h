//
//  ListaContatosViewController.h
//  Contatos
//
//  Created by Heberti Almeida on 08/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>
#import "ListaContatosProtocol.h"
#import "customCell.h"

@interface ListaContatosViewController : UITableViewController <ListaContatosProtocol, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
{
    Contato *contatoSelecionado;
}

@property (strong) NSMutableArray *contatos;
@property NSInteger linhaDestaque;

- (void)exibeMaisAcoes:(UILongPressGestureRecognizer *)gesture;

@end
