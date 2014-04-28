//            [instance addObserver:[OTSUserSwitcher sharedInstance]
//                       forKeyPath:@"token"
//                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
//                          context:NULL];

//#pragma mark -
//-(void)observeValueForKeyPath:(NSString *)keyPath
//                     ofObject:(id)object
//                       change:(NSDictionary *)change
//                      context:(void *)context
//{
//    if (object == [GlobalValue getGlobalValueInstance]
//        && [keyPath isEqualToString:@"token"])
//    {
//        DebugLog(@"token old :%@", [change objectForKey:@"old"]);
//        DebugLog(@"token new :%@", [change objectForKey:@"new"]);
//        DebugLog(@"token current :%@", [GlobalValue getGlobalValueInstance].token);
//
//        NSString* oldToken = [change objectForKey:@"old"];
//        NSString* newToken = [change objectForKey:@"new"];
//
//        oldToken = [oldToken isKindOfClass:[NSNull class]] ? nil : oldToken;
//        newToken = [newToken isKindOfClass:[NSNull class]] ? nil : newToken;
//
//        if (newToken == nil)
//        {
//            self.currentUser = nil;
//        }
//        else if (![oldToken isEqualToString:newToken])
//        {
//            // request user info
//            //self.needRequestUser = YES;
//            [self requestSessionUser];
//        }
//    }
//    else
//    {
//        [super observeValueForKeyPath:keyPath ofObject:object
//                               change:change context:context];
//    }
//}
