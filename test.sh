#!/usr/bin/env bash
# test.sh — regression suite for ipv4 extractor
# Usage: bash test.sh   (or via: make test)

BINARY=./ipv4
PASS=0
FAIL=0

GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# run_test DESC INPUT EXPECTED
#   Pipes INPUT + "END" into the binary, strips the interactive prompt,
#   and compares the single result line to EXPECTED.
run_test() {
    local desc="$1"
    local input="$2"
    local expected="$3"

    local actual
    actual=$(printf '%s\nEND\n' "$input" \
             | "$BINARY" \
             | sed "s/^Enter a string (or 'END' to quit): //" \
             | grep -v "^Program terminated")

    if [ "$actual" = "$expected" ]; then
        printf "${GREEN}PASS${NC}  %s\n" "$desc"
        ((PASS++))
    else
        printf "${RED}FAIL${NC}  %s\n" "$desc"
        printf "      ${BOLD}expected:${NC} %s\n" "$expected"
        printf "      ${BOLD}actual  :${NC} %s\n" "$actual"
        ((FAIL++))
    fi
}

# ── from spec example output ──────────────────────────────────────────────────

run_test "ip embedded in sentence" \
    "connecting to 192.168.1.1 now" \
    "Extracted IPv4 address: 192.168.1.1 (decimal value: 3232235777, port: none)"

run_test "ip:port with trailing non-numeric text" \
    "server=10.0.0.255:8080end" \
    "Extracted IPv4 address: 10.0.0.255 (decimal value: 167772415, port: 8080)"

run_test "non-dot separator causes first group to be skipped" \
    "192a168.1.1.1" \
    "Extracted IPv4 address: 168.1.1.1 (decimal value: 2818638081, port: none)"

run_test "stray trailing period" \
    "192.168.1.1." \
    "Invalid input: no valid IPv4 address found"

run_test "ip surrounded by words" \
    "Connection from 192.168.1.1 refused" \
    "Extracted IPv4 address: 192.168.1.1 (decimal value: 3232235777, port: none)"

run_test "leading zero in octet" \
    "192.168.01.1" \
    "Invalid input: no valid IPv4 address found"

run_test "port out of range (>65535)" \
    "1.2.3.4:99999" \
    "Invalid input: no valid IPv4 address found"

run_test "only 3 octets" \
    "12.34.56" \
    "Invalid input: no valid IPv4 address found"

run_test "no numbers at all" \
    "no number here" \
    "Invalid input: no valid IPv4 address found"

# ── boundary / extra cases ────────────────────────────────────────────────────

run_test "all zeros" \
    "0.0.0.0" \
    "Extracted IPv4 address: 0.0.0.0 (decimal value: 0, port: none)"

run_test "all 255s (max address)" \
    "255.255.255.255" \
    "Extracted IPv4 address: 255.255.255.255 (decimal value: 4294967295, port: none)"

run_test "first octet = 256 (out of range)" \
    "256.1.1.1" \
    "Invalid input: no valid IPv4 address found"

run_test "max valid port (65535)" \
    "192.168.1.1:65535" \
    "Extracted IPv4 address: 192.168.1.1 (decimal value: 3232235777, port: 65535)"

run_test "port = 65536 (out of range)" \
    "192.168.1.1:65536" \
    "Invalid input: no valid IPv4 address found"

run_test "ip at very start of string" \
    "10.20.30.40 is up" \
    "Extracted IPv4 address: 10.20.30.40 (decimal value: 169090600, port: none)"

run_test "ip alone, no surrounding text" \
    "172.16.254.1" \
    "Extracted IPv4 address: 172.16.254.1 (decimal value: 2886794753, port: none)"

run_test "stray leading period" \
    ".192.168.1.1" \
    "Invalid input: no valid IPv4 address found"

run_test "stray leading colon" \
    ":192.168.1.1" \
    "Invalid input: no valid IPv4 address found"

run_test "double colon before port" \
    "192.168.1.1::8080" \
    "Invalid input: no valid IPv4 address found"

run_test "second colon after port (multiple colons)" \
    "192.168.1.1:8080:extra" \
    "Invalid input: no valid IPv4 address found"

run_test "leading zero in first octet" \
    "00.1.2.3" \
    "Invalid input: no valid IPv4 address found"

run_test "five octets" \
    "1.2.3.4.5" \
    "Invalid input: no valid IPv4 address found"

run_test "ip assigned via equals sign" \
    "ip=192.168.100.200" \
    "Extracted IPv4 address: 192.168.100.200 (decimal value: 3232261320, port: none)"

run_test "colon with no port digits (empty port)" \
    "192.168.1.1:" \
    "Invalid input: no valid IPv4 address found"

# ── summary ───────────────────────────────────────────────────────────────────

echo "────────────────────────────────────────"
TOTAL=$((PASS + FAIL))
if [ "$FAIL" -eq 0 ]; then
    printf "${GREEN}${BOLD}All $TOTAL tests passed.${NC}\n"
else
    printf "${RED}${BOLD}$FAIL / $TOTAL tests FAILED.${NC}\n"
fi

# exit 1 so `make test` shows an error on failure
[ "$FAIL" -eq 0 ]