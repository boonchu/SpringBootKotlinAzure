#!/bin/bash

SERVICE_PRINCIPAL_NAME=acrpull-sp-role

az ad sp delete --id http://$SERVICE_PRINCIPAL_NAME
