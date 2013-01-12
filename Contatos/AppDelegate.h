//
//  AppDelegate.h
//  Contatos
//
//  Created by Heberti Almeida on 07/01/13.
//  Copyright (c) 2013 Heberti Almeida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong) NSMutableArray *contatos;
@property (strong) NSString *arquivoContatos;

@end
