#!/bin/bash

set -eufo pipefail

nameserver="$NAMESERVER"
domain="$DOMAIN"
next_test=1

function try() {
    local name="$1"
    local type="$2"
    local want="$3"

    local got=$(dig +short "@$nameserver" "$name" "$type" | sort)

    if [ "$got" == "$want" ]; then
        echo "ok ${next_test} ${name} ${type}"
    else
        echo >&2 "wrong result for '${name}' ${type}"
        echo >&2 "   got: ${got}"
        echo >&2 "  want: ${want}"
        echo "not ok ${next_test} ${name} ${type}"
    fi
    let next_test+=1
}

echo "1..9"
try "$domain" "TXT" \
    '"hello world"'

try "foo.$domain" "TXT" \
    '"This is foo"'

try "boop.$domain" "A" \
    "192.168.1.1
192.168.1.2"

try "boop2.$domain" "CNAME" \
    "boop.terraformdns-test.com."

try "boop3.$domain" "CNAME" \
    "boop.terraformdns-test.com."

try "boop2.$domain" "A" \
    "192.168.1.1
192.168.1.2
boop.terraformdns-test.com."

try "boop3.$domain" "A" \
    "192.168.1.1
192.168.1.2
boop.terraformdns-test.com."

try "_foo._tcp.$domain" "SRV" \
    "1 2 3 boop.terraformdns-test.com."

try "$domain" "MX" \
    "1 boop.terraformdns-test.com."
