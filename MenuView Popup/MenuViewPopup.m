//
//  MenuViewPopup.m
//  Cabxy
//
//  Created by Immanuel Infant Raj.S on 7/27/15.
//  Copyright (c) 2015 Immanuel Infant Raj.S. All rights reserved.
//


#import "MenuViewPopup.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "Constant.h"



@implementation MenuViewPopup
@synthesize rootView, window;
@synthesize btn_ad,btn_fb,btn_chat,btn_home,btn_lang,btn_help,btn_about,btn_logout,btn_settings,btn_ridehistory,btn_newbooking;


+(MenuViewPopup *)sharedInstance{
    
    // the instance of this class is stored here
    static MenuViewPopup *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        
        myInstance = [[[self class] alloc] initWithView];
        
        
    }//End of if statement
    
    myInstance.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    myInstance.window.windowLevel = UIWindowLevelStatusBar;
    myInstance.window.hidden = YES;
    myInstance.window.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.01];
    myInstance.onMenuItemSelect = nil;
    // gk
    [myInstance.window setFrame:CGRectMake(0, 64, myInstance.window.bounds.size.width, myInstance.bounds.size.height)];
    
    return myInstance;
}








-(id)initWithView{
    
    
    
       NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MenuViewPopup"
                                                     owner:nil
                                                   options:nil];
    
    if ([arrayOfViews count] < 1){
        
        return nil;
    }
    
    
    
    //[self addMeAsObserverMethod2];
    NSLog(@"initview");
    
    MenuViewPopup *newView = [arrayOfViews objectAtIndex:0];
    //[newView setFrame:frame];
    //newView.layer.cornerRadius = 10.0;
    //newView.clipsToBounds = YES;
    self = newView;
    
    
    return self;
    
    
}




- (void)didMenuViewPopupLoad:(UIView *)parentView andMenuItemSelect:(OnMenuItemSelect)menuItemSelect{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    NSLog(@"LOADING VIEW NAME  :  %@",[def valueForKey:@"name"]);
    self.rootView = parentView;
    self.onMenuItemSelect = menuItemSelect;
    NSLog(@"LOADING VIEW ");
    //Add alertview into transparent view to hide parent view interaction
    UIButton *transparentView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [transparentView setBackgroundColor:[UIColor clearColor]];
    [transparentView addTarget:self action:@selector(actionCancelMenuItem) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:self];
    //float x = (int)(transparentView.bounds.size.width - self.bounds.size.width);
    //float y = (int)(transparentView.bounds.size.height - self.bounds.size.height)>>1;
    // gk
    if ([[UIScreen mainScreen] bounds].size.height==812 || [[UIScreen mainScreen] bounds].size.height==896) {
        [self setFrame:CGRectMake(0, 104, self.bounds.size.width, parentView.frame.size.height)];
    }
    else{
    [self setFrame:CGRectMake(0, 80, self.bounds.size.width, parentView.frame.size.height)];
    }
    [self.window setFrame:parentView.frame];
    [self.window addSubview:transparentView];
    [self.window makeKeyAndVisible];
    self.img_profile.layer.cornerRadius = self.img_profile.frame.size.width / 2;
    self.img_profile.clipsToBounds = YES;
   dispatch_async(dispatch_get_main_queue(), ^{
      NSUserDefaults *def1=[NSUserDefaults standardUserDefaults];
       self->_lbl_name.text=[NSString stringWithFormat:@"%@",[def valueForKey:@"name"]];
       self->_lbl_mble.text=[NSString stringWithFormat:@"%@",[def valueForKey:@"mobile"]];
//       [self image];
       if (![def1 valueForKey:@"newprofile"]||[[def1 valueForKey:@"newprofile"] isEqual:(id)[NSNull null]]) {
           self.img_profile.image= [UIImage imageNamed:@"profile.png"];
       }
       NSData *imageData = [def1 valueForKey:@"newprofile"];
       //                NSData *imageData = [[NSData alloc]initWithBase64EncodedString:response1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
       if (imageData.length==0) {
           self.img_profile.image= [UIImage imageNamed:@"profile.png"];
       }
       else {
           
           self.img_profile.image=[UIImage imageWithData:imageData];
           
       }
       self.rootView.alpha=0.5;
   });
}
-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    if (string.length > 0) {
        
        //the iPhone has base 64 decoding built in but not obviously. The trick is to
        //create a data url that's base 64 encoded and ask an NSData to load it.
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    return nil;
}
-(void)actionCancelMenuItem{
    
    
    self.onMenuItemSelect(MENU_ITEM_CANCEL);
    [self didMenuViewPopupUnload];
    
}

-(void)image{
    //-LQ8ppkPCzkywOEjPq4z
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    def=[NSUserDefaults standardUserDefaults];
    NSString *acctok=[def valueForKey:@"acc_tok"];
    NSString *toktyp=[def valueForKey:@"tok_type"];
    NSString *tot=[NSString stringWithFormat:@"%@ %@",toktyp,acctok];
    NSURL *url2 =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?userId=%@",BASE_URL,@"getBaseProfileImage",[def valueForKey:@"userid"]]];
    NSLog(@"menu Http Url  :  %@",url2);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2];
    
    [request setHTTPMethod:@"GET"];
    //    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:tot forHTTPHeaderField:@"Authorization"];
    
    // add any additional headers or parameters
    NSURLSessionDataTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            // do your response handling
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Http Resp  :  %@",httpResponse);
            NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
            if (httpResponse.statusCode==200) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Resp  :  %@",responseDictionary);
            NSString *response1=[responseDictionary valueForKeyPath:@"response.image"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSData *imageData = [self dataFromBase64EncodedString:response1];
//                NSData *imageData = [[NSData alloc]initWithBase64EncodedString:response1 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                if (imageData.length==0) {
                    self.img_profile.image= [UIImage imageNamed:@"profile.png"];
                }
                else {
                    
                    self.img_profile.image=[UIImage imageWithData:imageData];
                    
                }
                
            });
            NSLog(@"Tot Resp  :  %@",response1);
            }
            else if (httpResponse.statusCode==401){
                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self login];
                });
            }
            else{
                
            }
        }
    }];
    [downloadTask resume];
}


-(void)login{
    NSUserDefaults *def;
    def=[NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://test.canadiansaferide.com/Login"]]];
    //    [urlRequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    NSString *userUpdate =[NSString stringWithFormat:@"grant_type=%@&username=%@&password=%@&user_type=%@&device_id=%@",@"password",[def valueForKey:@"mobile"],[def valueForKey:@"password"],@"2",@"123"];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Http Resp  :  %@",httpResponse);
        NSLog(@"Http Code  :  %ld",(long)httpResponse.statusCode);
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if(httpResponse.statusCode == 200)
        {
           NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            NSString *access_token = [responseDictionary valueForKey:@"access_token"];
            NSString *email=[responseDictionary valueForKey:@"email"];
            NSString *exp_in=[responseDictionary valueForKey:@"expires_in"];
            NSString *mble=[responseDictionary valueForKey:@"mobile"];
            NSString *name=[responseDictionary valueForKey:@"name"];
            NSString *token_type=[responseDictionary valueForKey:@"token_type"];
            NSString *userid=[responseDictionary valueForKey:@"user_id"];
            [def setObject:access_token forKey:@"acc_tok"];
            [def setObject:email forKey:@"email"];
            [def setObject:exp_in forKey:@"exp_in"];
            [def setObject:mble forKey:@"mobile"];
            [def setObject:name forKey:@"name"];
            [def setObject:token_type forKey:@"tok_type"];
            [def setObject:userid forKey:@"userid"];
            [def setObject:@"1" forKey:@"UserLogin"];
            [def synchronize];
            NSLog(@"Login User Id  :  %@",[def valueForKey:@"userid"]);
            NSString *returnstring=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"The response is - %@",returnstring);
//            NSInteger success = [[responseDictionary objectForKey:@"success"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self image];
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }
    }];
    [dataTask resume];
}

-(void)didMenuViewPopupUnload{
    
    self.rootView.alpha=1.0;
    //gk
    [self.superview removeFromSuperview];
    // Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[self.rootView layer] addAnimation:animation forKey:@"layerAnimation"];
    self.window = nil;
    


    
}


- (IBAction)actionDidMenuItem:(id)sender {
  
    self.onMenuItemSelect((int)[(UIButton *)sender tag]);
    switch ([(UIButton *)sender tag]) {
        case 0:
         NSLog(@"case0");

            break;
        case 1:
        NSLog(@"case1");

            break;
        case 2:
         NSLog(@"case2");

            break;
        case 3:
        
         NSLog(@"case3");


            break;
        case 4:
        
        NSLog(@"case4");

            break;
        
        
        case 5:
        
        NSLog(@"case5");
            
            
            break;

            
         case 6:
            
            NSLog(@"case6");
            
            break;
        case 7:
            
            NSLog(@"case6");
            
            break;
        case 8:
            
            NSLog(@"case6");
            
            break;
            
        case 9:
            
            NSLog(@"case6");
            
            break;
            
        default:
            break;
    }
    
    [self didMenuViewPopupUnload];
}



















@end
