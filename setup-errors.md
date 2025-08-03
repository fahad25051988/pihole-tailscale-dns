❗ Common Errors I Faced (And How I Solved Them)  This file documents the real issues I ran into while setting up Pi-hole + Unbound + Tailscale inside a UTM VM (behind CGNAT). These are not just technical errors — they helped me learn a lot about Linux networking, Docker, and VPNs.  ---  

## 1. ❌ Pi-hole DNS not responding  **Problem:**   When I ran `dig google.com @127.0.0.1` or from a remote device, it timed out.  **Cause:**   Pi-hole’s Docker container wasn't exposing port 53 correctly, or firewall was blocking it.  **Fix:** - Changed Docker run command:   --dns=127.0.0.1 --dns=1.1.1.1 \   -p 53:53/tcp -p 53:53/udp

- Allowed DNS traffic from Tailscale:
    
    `sudo iptables -A INPUT -s 100.0.0.0/8 -p udp --dport 53 -j ACCEPT sudo iptables -A INPUT -s 100.0.0.0/8 -p tcp --dport 53 -j ACCEPT`
    

---

## 2. ❌ No remote access due to CGNAT (Jio Fiber)

**Problem:**  
I had no public IP to access my Pi-hole from outside.

**Fix:**

- Installed **Tailscale** VPN on both my Ubuntu VM and all remote devices.
    
- On the VM:
    
    `sudo tailscale up --advertise-tags=tag:pihole --accept-dns=false`
    
- On remote devices:  
    Set the Pi-hole’s Tailscale IP (e.g., `100.x.x.x`) as the DNS resolver.
    

---

## 3. ❌ Had to manually set DNS on each device

**Problem:**  
Even after enabling `--accept-dns=true`, devices didn’t use the Pi-hole DNS by default.

**Fix:**

- Logged in to Tailscale admin console
    
- Under “Global Nameservers”, added:  
    `100.x.x.x` (Tailscale IP of Pi-hole)
    
- This auto-set the DNS across all devices without manually editing each one.
    

---

## 4. ❌ Unbound not resolving domains

**Problem:**  
Pi-hole was working, but Unbound didn’t resolve anything.

**Fix:**  
I forgot to fetch root DNS hints. Fixed it by:

`curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache sudo systemctl restart unbound`

---

## 5. ❌ Forgot Pi-hole web password

**Fix:**  
Reset it from inside the container:

`docker exec -it pihole pihole -a -p`

---

## 6. ❌ Pi-hole settings not saving after restart

**Problem:**  
Every time I restarted the container, everything reset.

**Fix:**  
Added Docker volumes for persistence:

`-v $(pwd)/pihole/etc-pihole:/etc/pihole \ -v $(pwd)/pihole/etc-dnsmasq.d:/etc/dnsmasq.d`

---

## ✅ Final Setup Summary

- Pi-hole blocks ads and tracks via DNS
    
- Unbound handles private recursive DNS
    
- All DNS traffic routes securely via Tailscale
    
- CGNAT bypassed without port forwarding
    
- DNS override works on all devices automatically
    

---

**⭐ Tip:**  
Always test using:

`nslookup doubleclick.net 100.x.x.x`

If it returns `0.0.0.0`, blocking works 🎉