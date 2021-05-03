#!/bin/bash

for i in {1..100}; do
  sleep 1 && echo "{\"value\":$i}" | tee assets/linux/test
done
