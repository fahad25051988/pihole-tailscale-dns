 # Private DNS Ad-Blocking and Remote Access with Pi-hole + Tailscale

## 👋 Why I Built This

I care about online privacy and wanted to block ads and trackers across all my devices — not just in browsers. Public DNS providers like Google or Cloudflare are fast, but they often log data. I wanted full control over DNS resolution and to keep it private.

Also, my internet provider (Jio Fiber) uses CGNAT, which means I don't get a public IP address. So remote access was tricky. This project helped me learn how to work around that using Tailscale.

---

## 🔍 Problem I Solved

* Block ads and trackers on every device (not just browsers)
* Encrypt and control all DNS queries (no third-party logging)
* Remotely access DNS and admin panel (even behind CGNAT)
* Learn real-world tools like Linux, DNS, VPNs, Docker, and iptables

---

## 🧰 Tools I Used

* macOS (my laptop)
* [UTM](https://mac.getutm.app/) to run Ubuntu Server on Mac
* Ubuntu Server 22.04 (inside UTM)
* Docker
* Pi-hole (ad-blocking DNS)
* Unbound (recursive DNS resolver)
* Tailscale (zero-config VPN)

---

## 🛠️ How I Built It (Step-by-Step)

### 1. Set Up Ubuntu VM

* Installed UTM on macOS
* Created a VM with Ubuntu Server 22.04
* Gave it 2 CPU cores, 2GB RAM, and 15GB disk

![Ubuntu-running](/screenshots/Ubuntu-UTM.png)

---

### 2. Update Ubuntu

```shell
sudo apt update && sudo apt upgrade -y
![ubuntu-update](/screenshots/Ubuntu-Update.png)
```
---

### 3. Install Docker

```shell
sudo apt install docker.io -y
```
```shell
sudo usermod -aG docker $USER
```

exit  # Then re-login



![Docker-version](/screenshots/Docker-version.png)

---

### 4. Run Pi-hole in Docker

```shell
sudo docker run -d \
  --name pihole \
  -p 53:53/tcp -p 53:53/udp \
  -p 80:80 \
  -p 443:443 \
  -e TZ="Asia/Kolkata" \
  -e WEBPASSWORD="yourpassword" \
  -v $(pwd)/pihole/etc-pihole:/etc/pihole \
  -v $(pwd)/pihole/etc-dnsmasq.d:/etc/dnsmasq.d \
  --dns=127.0.0.1 --dns=1.1.1.1 \
  --restart=unless-stopped \
  --cap-add=NET_ADMIN \
  pihole/pihole:latest

```
![pi-hole-web](/screenshots/Pihole-web-ui.png)

---

### 5. Add Unbound for Private DNS

```shell
sudo apt install unbound -y
```

```shell
curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache
```

Create config:

```shell
sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf
```
```shell
Restart Unbound:
```
```shell
sudo systemctl enable unbound
```

```shell
sudo systemctl restart unbound
```


![unbound-rules](/screenshots/unbound+pi-hole-integration.png)

---

### 6. Install Tailscale

```shell
curl -fsSL https://tailscale.com/install.sh | sh
```


```shell
sudo tailscale up --advertise-tags=tag:pihole --accept-dns=false
```

![Tailscale-ip](/screenshots/Tailscale-ip.png)

---

### 7. Firewall Setup for DNS Access via Tailscale
```shell
sudo iptables -A INPUT -s 100.0.0.0/8 -p udp --dport 53 -j ACCEPT
```
```shell
sudo iptables -A INPUT -s 100.0.0.0/8 -p tcp --dport 53 -j ACCEPT
```

(Optional: Block others)

```shell
sudo iptables -A INPUT -p udp --dport 53 -j DROP
```
```shell
sudo iptables -A INPUT -p tcp --dport 53 -j DROP
```

![Ip-tables](/screenshots/IP-table-rules.png)

---

### 8. Set Global DNS in Tailscale (No Need to Configure Each Device)

Instead of changing DNS settings manually on every device, I used Tailscale’s admin panel:

1. Went to [https://login.tailscale.com](https://login.tailscale.com/)
2. Opened the **DNS** section
3. Added Pi-hole’s Tailscale IP (100.x.x.x) as **Global Nameserver**
4. Saved and synced settings

Now every Tailscale-connected device automatically uses Pi-hole for DNS. Super easy.

![dns-override](/screenshots/Tailscale-global-dns.png)

---

### 9. Test on Remote Device

```shell
nslookup doubleclick.net 100.x.x.x
```

Should return:

```shell
Name: doubleclick.net
Address: 0.0.0.0
```

![remote-device](/screenshots/nslookup-remote-device.png)

---

## 🔄 How It Works

1. Remote devices connect to Pi-hole using Tailscale
2. Pi-hole blocks ads and trackers
3. Other queries go to Unbound for secure, recursive resolution
4. Everything stays encrypted, private, and works even behind CGNAT


📝 Note: The connection from Unbound to the root DNS servers is not encrypted (DNS still uses port 53).
But the traffic from your device to Pi-hole (and Unbound) is fully encrypted through Tailscale, so your ISP or others can’t see or log your DNS activity.
Later, you can add DNS-over-HTTPS for full end-to-end encryption.


![architecture](/screenshots/Network-diagram.png)

---

## 🤯 What I Learned

* Recursive DNS vs Forwarded DNS
* How Docker volumes and ports work
* What CGNAT is and how Tailscale helps bypass it
* How firewall rules and DNS resolution interact

---

## 😤 Challenges I Faced

* Unbound wouldn’t start until I added the `root.hints` file manually
* DNS wasn’t working remotely until I fixed firewall + Tailscale DNS override
* Learned Docker’s port forwarding the hard way 😅

---

## 🚀 What I Plan to Improve

* Use `docker-compose` for easier management
* Add DNS-over-HTTPS fallback option
* Run it on Raspberry Pi or always-on server
* Add login + 2FA for remote admin

---

## ✨ License

This project is licensed under the [MIT License](LICENSE).
You're free to use, modify, and share it — personally or commercially.

Feel free to fork it, improve it for your own setup, or share with others!

---
