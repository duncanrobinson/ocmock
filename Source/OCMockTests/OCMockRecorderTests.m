//---------------------------------------------------------------------------------------
//  $Id$
//  Copyright (c) 2004-2009 by Mulle Kybernetik. See License file for details.
//---------------------------------------------------------------------------------------

#import <XCTest/XCTest.h>
#import <OCMock/OCMockRecorder.h>
#import <OCMock/OCMockObject.h>
#import "OCMReturnValueProvider.h"
#import "OCMExceptionReturnValueProvider.h"
#import "OCMArg.h"
#import "OCMInvocationMatcher.h"


@interface OCMockRecorderTests : XCTestCase

@end


@implementation OCMockRecorderTests

- (void)testCreatesInvocationMatcher
{
    NSString *arg = @"I love mocks.";

    id mock = [OCMockObject mockForClass:[NSString class]];
    OCMockRecorder *recorder = [[[OCMockRecorder alloc] initWithMockObject:mock] autorelease];
    [(id)recorder initWithString:arg];

    NSMethodSignature *signature = [NSString instanceMethodSignatureForSelector:@selector(initWithString:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(initWithString:)];
    [invocation setArgument:&arg atIndex:2];
    XCTAssertTrue([[recorder invocationMatcher] matchesInvocation:invocation], @"Should match.");
}

- (void)testAddsReturnValueProvider
{
    id mock = [OCMockObject mockForClass:[NSString class]];
    OCMockRecorder *recorder = [[[OCMockRecorder alloc] initWithMockObject:mock] autorelease];
    [recorder andReturn:@"foo"];
    NSArray *handlerList = [recorder invocationHandlers];

    XCTAssertEqual((NSUInteger)1, [handlerList count], @"Should have added one handler.");
    XCTAssertEqualObjects([OCMReturnValueProvider class], [[handlerList objectAtIndex:0] class], @"Should have added correct handler.");
}

- (void)testAddsExceptionReturnValueProvider
{
    id mock = [OCMockObject mockForClass:[NSString class]];
    OCMockRecorder *recorder = [[[OCMockRecorder alloc] initWithMockObject:mock] autorelease];
    [recorder andThrow:[NSException exceptionWithName:@"TestException" reason:@"A reason" userInfo:nil]];
    NSArray *handlerList = [recorder invocationHandlers];

    XCTAssertEqual((NSUInteger)1, [handlerList count], @"Should have added one handler.");
    XCTAssertEqualObjects([OCMExceptionReturnValueProvider class], [[handlerList objectAtIndex:0] class], @"Should have added correct handler.");

}

@end
