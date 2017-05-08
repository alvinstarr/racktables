#!/bin/bash

secret=/etc/secret.php

chown apache:apache $secret && chmod 400 $secret
