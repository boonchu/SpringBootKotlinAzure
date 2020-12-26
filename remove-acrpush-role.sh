#!/bin/bash

SERVICE_PRINCIPAL_NAME=acrpush-sp-role

az ad sp delete --id http://$SERVICE_PRINCIPAL_NAME
