#!/bin/bash

stack build &&
stack exec ens-search -- $*
