//
//  SWHttpRequestOperation.m
//  SWiOS
//
//  Created by YuchenZhang on 8/30/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWHttpRequestOperation.h"

static inline NSString * SWKeyPathFromOperationState(SWHttpReqOperationStatus status) {
    switch (status) {
        case SWHttpReqOperationStatusReady:
            return @"isReady";
        case SWHttpReqOperationStatusExecuting:
            return @"isExecuting";
        case SWHttpReqOperationStatusFinish:
            return @"isFinished";
//        case AFOperationPausedState:
//            return @"isPaused";
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}

@interface SWHttpRequestOperation () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation SWHttpRequestOperation

+ (void)requestThreadEntryPoint:(id)object
{
    @autoreleasepool {
        NSThread *currentThread = [NSThread currentThread];
        [currentThread setName:@"SWHttpRequestThread"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)requestThread
{
    static NSThread *t ;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        t = [[NSThread alloc] initWithTarget:self selector:@selector(requestThreadEntryPoint:) object:nil];
        [t start];
    });
    return t;
}

- (instancetype)initWithReqURL:(NSURLRequest *)reqURL successBlock:(SWApiSuccessBlock)successBlock failureBlock:(SWApiFailureBlock)failureBlock
{
    self = [super init];
    
    if (self) {
        _reqURL = reqURL;
        _successBlock = successBlock;
        _failBlock = failureBlock;
        _outputStream = [NSOutputStream outputStreamToMemory];
        __weak __typeof(self)weakSelf = self;
        self.completionBlock = ^{
            if (weakSelf.error) {
                failureBlock(nil, weakSelf.error);
            }
            else if(weakSelf.responseData)
            {
                NSError *jsonError = weakSelf.error;
                
//                &weakSelf->_error);
                
                
                
                id res = [NSJSONSerialization JSONObjectWithData:weakSelf.responseData options:NSJSONReadingAllowFragments error:&(jsonError)];
                successBlock(weakSelf, res);
            }
        };
        self.status = SWHttpReqOperationStatusReady;
    }
    
    return self;
}

- (NSOutputStream *)outputStream
{
    if (_outputStream == nil) {
        self.outputStream = [NSOutputStream outputStreamToMemory];
    }
    
    return _outputStream;
}

- (void)setStatus:(SWHttpReqOperationStatus)status
{
    NSString *oldStateKey = SWKeyPathFromOperationState(self.status);
    NSString *newStateKey = SWKeyPathFromOperationState(status);
    
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _status = status;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
}

- (BOOL)isReady {
    return self.status == SWHttpReqOperationStatusReady && [super isReady];
}

- (BOOL)isExecuting {
    return self.status == SWHttpReqOperationStatusExecuting;
}

- (BOOL)isFinished {
    return self.status == SWHttpReqOperationStatusFinish;
}

- (void)start
{
    [self performSelector:@selector(operationDidStart) onThread:[[self class] requestThread] withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
    
}

- (void)operationDidStart
{
    self.status = SWHttpReqOperationStatusExecuting;
    _connection = [[NSURLConnection alloc] initWithRequest:_reqURL delegate:self startImmediately:NO];
    
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
    
    [_connection scheduleInRunLoop:currentRunloop forMode:NSRunLoopCommonModes];
    [_outputStream open];
    [_connection start];
}


#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    NSUInteger dataLength = data.length;
    if ([_outputStream hasSpaceAvailable]) {
        const uint8_t *bytes = data.bytes;
        [_outputStream write:bytes maxLength:dataLength];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.responseData = [self.outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    
    [_outputStream close];
    self.outputStream = nil;
    
    [self finish];
    
}

- (void)finish
{
    self.status = SWHttpReqOperationStatusFinish;
}


@end
