#! /usr/bin/env bash

# uncheck Find Implicit Dependencies

source "$HOME/.rvm/scripts/rvm"
rvm use ruby-1.9.3-p194
cd ${SRCROOT}
pod install