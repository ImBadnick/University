#!/bin/bash
cut -d':' -f1,6 /etc/passwd | grep '/home/' |  sort

