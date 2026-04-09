#!/bin/bash
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  ./router.exe --config router.yaml --supergraph supergraph-schema.graphql
else
  ./router --config router.yaml --supergraph supergraph-schema.graphql
fi
