#!/bin/sh

ruby \
  --disable-gems \
  --enable-frozen-string-literal \
  test/automated.rb \
  $@
