#!/bin/bash

mysql --defaults-extra-file=../dbaccess.cnf < ./ddl.sql
