#!/bin/bash

gcc -g -Wall -o resize resize.c `pkg-config vips --cflags --libs`

