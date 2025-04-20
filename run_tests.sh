#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

TEST_DIR="lastTests/tests"

for test_input in "$TEST_DIR"/*.in; do
    test_number=$(basename "$test_input" .in)
    test_output="$TEST_DIR/${test_number}.in.out"
    test_result="$TEST_DIR/${test_number}.in.res"
    test_diff="$TEST_DIR/${test_number}.diff"

    ./hw1 < "$test_input" > "$test_result"

    if diff "$test_result" "$test_output" > /dev/null; then
        echo -e "Test ${test_number} ${GREEN}PASSED${NC}"
    else
        echo -e "Test ${test_number} ${RED}FAILED${NC}"
        diff "$test_result" "$test_output" > "$test_diff"
    fi
done