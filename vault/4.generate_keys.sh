#!/bin/bash

set -x

ssh-keygen -t rsa -N "" -C masa@hashicorp -f dev 
ssh-keygen -t rsa -N "" -C masa@hashicorp -f ops
