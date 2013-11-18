//
//  IDZViewController.m
//  IDZWebBrowser
//
//  Created by idz on 11/16/13.
//
// Copyright (c) 2013 iOSDeveloperZone.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "IDZWebBrowserViewController.h"

@interface IDZWebBrowserViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forward;

- (void)loadRequestFromString:(NSString*)urlString;
- (void)updateButtons;
@end

@implementation IDZWebBrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSAssert([self.webView isKindOfClass:[UIWebView class]], @"You webView outlet is not correctly connected.");
    NSAssert(self.back, @"Your back button outlet is not correctly connected");
    NSAssert(self.stop, @"Your stop button outlet is not correctly connected");
    NSAssert(self.refresh, @"Your refresh button outlet is not correctly connected");
    NSAssert(self.forward, @"Your forward button outlet is not correctly connected");
    NSAssert((self.back.target == self.webView) && (self.back.action = @selector(goBack)), @"Your back button action is not connected to goBack.");
    NSAssert((self.stop.target == self.webView) && (self.stop.action = @selector(stopLoading)), @"Your stop button action is not connected to stopLoading.");
    NSAssert((self.refresh  .target == self.webView) && (self.refresh.action = @selector(reload)), @"Your refresh button action is not connected to reload.");
    NSAssert((self.forward.target == self.webView) && (self.forward.action = @selector(goForward)), @"Your forward button action is not connected to goForward.");
    NSAssert(self.webView.scalesPageToFit, @"You forgot to check 'Scales Page to Fit' for your web view.");
	// Do any additional setup after loading the view, typically from a nib.
    self.webView.delegate = self;
    [self loadRequestFromString:@"http://iosdeveloperzone.com"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequestFromString:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - Updating the UI
- (void)updateButtons
{
    NSLog(@"%s loading = %@", __PRETTY_FUNCTION__, self.webView.loading ? @"YES" : @"NO");
    self.forward.enabled = self.webView.canGoForward;
    self.back.enabled = self.webView.canGoBack;
    self.stop.enabled = self.webView.loading;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

@end
