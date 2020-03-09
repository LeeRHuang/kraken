/*
 * Copyright (C) 2019 Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */

#ifndef KRAKEN_BRIDGE_TEST_EXPORT_H
#define KRAKEN_BRIDGE_TEST_EXPORT_H

#include "bridge_export.h"
#include <cstdint>
#define KRAKEN_EXPORT extern "C" __attribute__((visibility("default"))) __attribute__((used))

using TestCallback = void (*)(void *);
typedef void *(*Describe)(const char *, void *context, TestCallback callback);

using ItCallback = void (*)(void*, int32_t);
typedef void *(*It)(const char *, void *context, ItCallback callback);
typedef void *(*ItDone)(int32_t, const char*);

typedef void *(*BeforeEach)(void *context, TestCallback callback);
typedef void *(*BeforeAll)(void *context, TestCallback callback);
typedef void *(*AfterEach)(void *context, TestCallback callback);
typedef void *(*AfterAll)(void *context, TestCallback callback);

KRAKEN_EXPORT
void initTestFramework();
KRAKEN_EXPORT
int8_t evaluteTestScripts(const char *code, const char *bundleFilename, int startLine);


KRAKEN_EXPORT
void registerOnJSError(OnJSError jsError);
KRAKEN_EXPORT
void registerDescribe(Describe describe);
KRAKEN_EXPORT
void registerIt(It it);
KRAKEN_EXPORT
void registerItDone(ItDone itDone);
KRAKEN_EXPORT
void registerBeforeEach(BeforeEach beforeEach);
KRAKEN_EXPORT
void registerBeforeAll(BeforeAll beforeAll);
KRAKEN_EXPORT
void registerAfterEach(AfterEach afterEach);
KRAKEN_EXPORT
void registerAfterAll(AfterAll afterAll);

#endif