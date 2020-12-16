#!/bin/bash
find ~/ -mmin -$1 -type f -exec grep -l $2 {} \;
