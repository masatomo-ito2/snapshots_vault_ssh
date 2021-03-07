#!/bin/bash

set -x 

vault secrets enable -path=ssh-client-signer ssh 
