#!/bin/bash
export APOLLO_ELV2_LICENSE=accept
export APOLLO_ROUTER_LOG=warn

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  ./router.exe --config router.yaml --supergraph supergraph-schema.graphql
else
  ./router --config router.yaml --supergraph supergraph-schema.graphql
fi
