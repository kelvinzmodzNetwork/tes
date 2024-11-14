#!/bin/bash

# Menghapus file dan folder lama jika ada
echo "======================="
echo "Cleaning up old ngrok and files"
echo "======================="
rm -rf ngrok ngrok.zip ng.sh > /dev/null 2>&1

# Mengunduh ngrok versi terbaru
echo "======================="
echo "Downloading ngrok"
echo "======================="
wget -O ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1

# Mengekstrak file zip
unzip ngrok.zip > /dev/null 2>&1

# Memberikan izin eksekusi
chmod +x ngrok

# Meminta token ngrok
echo "======================="
read -p "Paste Ngrok Authtoken: " CRP
./ngrok authtoken $CRP

# Menjalankan ngrok untuk membuat tunnel TCP ke port 3388
echo "======================="
echo "Starting ngrok for RDP"
echo "======================="
read -p "Choose ngrok region (us/eu/ap/au/sa/jp/in): " CRP
./ngrok tcp --region $CRP 3388 &>/dev/null &

# Menunggu beberapa detik agar ngrok siap
sleep 5

# Memastikan ngrok berjalan dan mendapatkan URL RDP
echo "======================="
echo "RDP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:\/\/([^"]*).*/\1/p'
echo "======================="

# Mengunduh dan menjalankan Docker untuk RDP
echo "======================="
echo "Installing RDP"
echo "======================="
docker pull danielguerra/ubuntu-xrdp

# Menjalankan Docker untuk RDP
echo "======================="
echo "Starting RDP"
echo "======================="
docker run --rm -p 3388:3389 danielguerra/ubuntu-xrdp

# Memberi informasi login
echo "======================="
echo "Username: ubuntu"
echo "Password: ubuntu"
echo "Don't close this tab to keep RDP running."
echo "Wait for 2 minutes for the setup to finish, then use the RDP address."
echo "======================="
