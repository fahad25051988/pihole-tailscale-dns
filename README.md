# Pi-hole Unbound Tailscale DNS: Self-Hosted Privacy, Secure Global Remote Access

[![Releases](https://img.shields.io/badge/Releases-pihole--tailscale--dns-blue?logo=github&style=for-the-badge)](https://github.com/fahad25051988/pihole-tailscale-dns/releases)

Install from: https://github.com/fahad25051988/pihole-tailscale-dns/releases. From that page, download the installer script (install.sh) and run it. This repository brings together Pi-hole, Unbound, and Tailscale to give you a private, recursive DNS resolver with ad blocking, remote access, and strong privacy. It runs on Ubuntu via Docker and can run on macOS using UTM. It is designed to be fully self-hosted, secure, and easy to operate behind CGNAT.

Topics: not provided

Overview
- This project provides a cohesive DNS and ad-blocking stack you host yourself. It combines Pi-hole for DHCP/DNS and ad blocking, Unbound as a recursive resolver, and Tailscale to create a private, secure network tunnel you can use from anywhere.
- You gain control over your DNS paths. You block ads on devices you own while keeping DNS queries private within your own network.
- The setup is designed to work in a variety of environments. It runs on Ubuntu using Docker for portability. It can also run on macOS via UTM, a virtual machine. Either way, you stay in control of data.

Why this approach
- Ad blocking at the network layer reduces tracking and speeds up browsing. Pi-hole excels at blocking at the DNS level.
- Unbound provides a local, recursive resolver that you control. It improves privacy and reduces reliance on upstream resolvers you don’t fully trust.
- Tailscale creates a private mesh network. It lets you reach your own DNS server from remote locations without exposing it to the open internet and without relying on a public VPN.
- The whole stack can be fully self-contained. You define who can access the DNS, what is blocked, and how queries flow through the system.

What you get
- A private DNS service that is recursive, fast, and privacy-focused.
- A robust ad-blocking layer that stops tracking and reduces bandwidth usage.
- A secure remote access channel to your DNS server, even when you are behind CGNAT.
- A Docker-based deployment on Ubuntu, plus a macOS option via UTM.
- Clear firewall rules and an optional VPN tunnel to guard traffic.

Images and visuals
- Pi-hole in action: visual reference to a DNS-based ad blocker. 
- Tailscale: a simple VPN-like network overlay that creates a private network between devices.
- Unbound: a reliable recursive resolver that handles queries locally.

Key concepts explained
- DNS: The system that translates domain names into IP addresses.
- Ad blocking at the DNS level: Blocking known ad domains before requests leave your device.
- Recursive resolver: The resolver that looks up domain names and follows the DNS chain to get the final IP.
- Private network with Tailscale: A secure way to connect devices and services without exposing them publicly.
- CGNAT: Carrier-grade NAT can make direct connections tricky; this stack helps by providing private access via Tailscale.

Architecture and components
- Pi-hole: DNS server with ad-blocking and optional DHCP services.
- Unbound: Local recursive resolver, authoritative for local zones, caching for speed.
- Tailscale: VPN-like service that creates a private network among your machines. You reach the DNS service through this private network.
- Docker (Ubuntu): Containerized deployment for portability and ease of management.
- UTM (macOS): Virtualization for macOS users who want to run Ubuntu in a VM.

How the pieces fit
- Clients configure their DNS to point to the Pi-hole instance, which handles ad blocking and forwards unresolved queries to Unbound.
- Unbound resolves queries recursively using upstream servers you choose and caches results for speed.
- Tailscale provides secure access to the DNS service from remote devices. It acts like a private VPN that only you can join.
- Firewall rules guard the DNS ports and limit exposure to the minimal surface necessary.

Prerequisites
- A supported host:
  - Ubuntu server or desktop with Docker installed (recommended for consistency and updates).
  - A macOS host using UTM to run an Ubuntu VM if you want a desktop option.
- Network basics:
  - A stable local network with a known IP range.
  - Optional port forwards if you must expose DNS to the internet (not required with Tailscale).
- Access permissions:
  - Root or sudo privileges to install and configure services.
- External knowledge:
  - Basic familiarity with Docker and Linux command line.
  - A Tailscale account or the ability to install Tailscale on your devices for remote access.

Getting started (fast path)
- Install on Ubuntu with Docker:
  - Ensure your system is up to date.
  - Install Docker and docker-compose (or use Docker Compose V2).
  - Download and run the installer script from the Releases page.
- Install on macOS with UTM:
  - Create an Ubuntu VM with sufficient resources.
  - Install Docker inside the VM and run the installer script.
  - Connect devices via Tailscale to reach the DNS service.

Install and run (Ubuntu with Docker)
- Step 1: Update the system
  - sudo apt update && sudo apt upgrade -y
- Step 2: Install Docker and Docker Compose
  - sudo apt install -y docker.io docker-compose
  - sudo systemctl enable --now docker
- Step 3: Start the installer
  - From the Releases page, download the installer script (install.sh) and run:
    - chmod +x install.sh
    - sudo ./install.sh
- Step 4: Follow prompts
  - The installer guides you through selecting modules, configuring Pi-hole, Unbound, and Tailscale, and setting firewall rules.
- Step 5: Verify the stack
  - Check that Pi-hole is reachable on its configured port.
  - Ensure Unbound is resolving queries locally.
  - Confirm the Tailscale connection to your devices is up and that you can route DNS queries through the setup.

Install and run (macOS with UTM)
- Step 1: Create a lightweight Ubuntu VM
  - Use UTM to run an Ubuntu image with enough CPU, memory, and disk space for Docker and services.
- Step 2: Install Docker inside the VM
  - Follow the Ubuntu-based Docker install instructions.
- Step 3: Start the installer
  - As with the Ubuntu path, download the installer script from the Releases page and run it inside the VM.
- Step 4: Connect via Tailscale
  - Install Tailscale on your host Mac and on devices you want to use to reach the DNS server.
  - Use the Tailscale IP to reach the Pi-hole service or the Docker-hosted DNS port, depending on your network design.
- Step 5: Validate
  - Confirm you can resolve private DNS entries through the VM and that ads are blocked as expected.

Configuration overview
- Pi-hole
  - Acts as the DNS hub, providing ad blocking and offering optional DHCP services.
  - You can customize block lists, allow lists, and analytics preferences.
  - The web interface offers a view into queries, blocked domains, and system status.
- Unbound
  - Serves as a recursive DNS resolver.
  - Provides DNSSEC validation and caching for faster responses.
  - You can adjust forwarders, cache settings, and privacy-oriented options.
- Tailscale
  - Creates a private mesh network that you can use to reach the DNS service securely.
  - You can install Tailscale on devices across platforms and connect to the same network.
  - With Tailscale, you avoid exposing the DNS service to the public internet and still reach it from anywhere.
- Firewall rules
  - The installer configures rules to allow DNS traffic through specific ports.
  - It blocks unwanted access and reduces exposure to the internet.
  - You can adjust rules to fit your local network and security posture.
- VPN tunnel
  - The Tailscale setup acts as a VPN-like channel to reach your DNS service remotely.
  - This tunnel protects DNS queries from eavesdropping and ensures they reach the intended server.

Networking model
- Local network (LAN)
  - Devices in your LAN use Pi-hole as their primary DNS server.
  - Pi-hole forwards unresolved requests to Unbound for recursion.
- Remote access (via Tailscale)
  - When you are away from home, you connect to your Tailscale network.
  - The DNS server is reachable through the Tailscale network, with the same domain resolution behavior.
- CGNAT considerations
  - CGNAT can complicate direct connections. The Tailscale-based approach handles this by using the private network to reach your DNS server.
  - You don’t rely on a public IP or port mapping to access the DNS service.

Security posture
- Self-hosted means you own your data.
- Access is controlled by Tailscale, which creates a private, authenticated network.
- Unbound provides DNSSEC validation where available, helping ensure responses are authentic.
- Pi-hole blocks many common ad domains, reducing exposure to trackers and malvertising.
- Firewall rules constrain what traffic can reach the DNS stack, reducing the blast radius if a component is compromised.
- Regular updates to Docker images and base OS keep the stack protected against known issues.

Maintenance and updates
- Updating components
  - The installer script is designed to fetch and deploy current images and configurations.
  - You can re-run the installer to pull newer versions or adjust settings.
- Backups
  - Regularly back up Pi-hole configuration (blocklists, allowlists, and DNS data).
  - Back up Unbound configuration and any custom DNS records you maintain locally.
  - Preserve Tailscale credentials and device connections, following best practices for key storage.
- Logs and monitoring
  - Review Pi-hole’s query log for blocked domains and traffic patterns.
  - Monitor Unbound’s cache statistics to adjust performance.
  - Use Tailscale’s admin features to manage devices joined to your private network.
- Resource planning
  - Allocate enough CPU and memory for all components to run smoothly, especially on smaller devices.
  - Docker adds a layer of isolation, but it consumes some resources.

Security considerations and best practices
- Keep the system updated regularly. Apply OS and container updates promptly.
- Use strong, unique credentials for any admin interfaces.
- Limit admin access to Pi-hole and the Docker stack to trusted users.
- Use Tailscale to control who can reach the DNS service; avoid exposing DNS to the public internet.
- Consider enabling DNSSEC verification in Unbound for stronger query integrity.
- Regularly audit firewall rules and connected devices.

Troubleshooting quick wins
- No DNS responses
  - Check that Pi-hole is running and reachable on its port.
  - Verify Unbound is listening and forwarding requests correctly.
  - Confirm DNS settings on clients point to the Pi-hole IP.
- Ads still appearing
  - Confirm blocklists are active and properly loaded.
  - Review query logs to identify blocked vs allowed domains and adjust lists as needed.
- Remote access not working
  - Ensure Tailscale is installed and devices are joined to the same network.
  - Check that the DNS server’s Tailscale IP is reachable from remote devices.
- Performance issues
  - Look at Unbound’s cache hits; adjust cache size if needed.
  - Verify Docker resource limits to prevent throttling.
  - Revisit hardware capacity for the VM or Docker host.
- CGNAT traversal problems
  - Verify that you are using the Tailscale network for remote access, not public endpoints.
  - Ensure that the DNS client devices use the Tailscale-provided route to the DNS server.

Examples and reference configurations
- Sample DNS flow
  - Client DNS query -> Pi-hole DNS (ads blocked) -> Unbound resolver (recursive) -> Upstream servers (if needed) -> Cache (for speed) -> DNS reply back to client
- Example settings you may adjust
  - Pi-hole: customize blocklists, enable or disable analytics, set up local DNS records for private hosts
  - Unbound: enable DNSSEC, set privacy-forwarding options, adjust forwarders
  - Tailscale: add devices, configure access controls, monitor device status
- Illustrative service map
  - Client devices on LAN or via Tailscale
  - Pi-hole container
  - Unbound container
  - Docker host and network bridge
  - Tailscale network to reach the DNS service remotely

Configuration tips and notes
- Use stable blocklists you trust. Avoid listing sources that may cause performance issues.
- Consider enabling DoH or DoT if you want encrypted upstream queries; plan the client side accordingly.
- When testing remote access, only enable ports you truly need. The Tailscale path should be enough for most use cases.
- Document any local DNS entries you add. They might be overwritten during updates if not stored in a persistent place.
- Keep a version log. Record the installer version and the major component versions you deploy.

Security-friendly defaults
- DNS port exposure is restricted to local and private networks unless you explicitly enable remote access through authenticated channels.
- All critical services run in containers with limited privileges.
- Access to the admin interfaces is restricted by host-based access or VPN-based access only.

What to customize for your environment
- Blocklists and allowed domains: tailor to household needs or organization policy.
- Local DNS records: add private hosts (e.g., printer.local, NAS.local) for faster resolution.
- Upstream DNS: choose trusted resolvers that fit your privacy policy.
- Tailscale network topology: decide which devices join the DNS network and how you route traffic.
- Firewall policies: adapt to your environment’s security posture.

Project structure and how to customize
- The installer script orchestrates container deployment, configuration files, and initial setup.
- Key configuration files (simplified names) reside in a dedicated directory, with clear separation for Pi-hole, Unbound, and Tailscale.
- You can modify settings by editing these files or re-running the installer to apply changes.

Contributing and community
- This project aims to be simple to use while offering a robust feature set. If you want to contribute:
  - Propose changes to the installer to support additional environments or newer versions.
  - Add or refine blocklists, upstream DNS choices, or privacy settings.
  - Improve documentation with real-world use cases and performance data.
- Be mindful of security when making changes. Validate new network flows and ensure they don’t open unexpected access.

Releases and versioning
- For the latest installer and updates, visit the Releases page. The link is provided at the top and in the Releases section below.
- See latest release notes and assets on the official page: https://github.com/fahad25051988/pihole-tailscale-dns/releases
- The installer is designed to fetch current components when you run it. Re-run the installer to pick up updates or to adjust configurations as you evolve your network.

Releases
- Latest release access: https://github.com/fahad25051988/pihole-tailscale-dns/releases
- What you’ll find there
  - Installer packages for Ubuntu with Docker
  - Optional VM images for macOS via UTM
  - Updated blocklists, configuration templates, and deployment guides
  - Release notes detailing changes, improvements, and bug fixes
- How to use the releases page
  - Download the installer script named install.sh (or other assets as described on the page)
  - Run the script with proper permissions
  - Follow the prompts to configure Pi-hole, Unbound, and Tailscale
- If you can’t find what you need
  - Check the Releases section for the latest assets
  - Review the repository’s documentation for installation steps and troubleshooting
  - If the link changes, look for the updated link in the Releases section and adjust your workflow accordingly

Troubleshooting and support resources
- Common issues and fixes
  - DNS not resolving: verify the DNS path and ensure Docker containers are running.
  - Ads not blocked: re-check blocklists, ensure Pi-hole is active, check the query logs.
  - Remote access fails: confirm Tailscale is connected and devices are part of the same network.
  - Performance problems: monitor resource use and adjust container limits or VM size.
- Where to ask for help
  - Open issues in the repository for bug reports and feature requests.
  - Engage with the community in discussions around best practices for privacy-centric DNS and ad blocking.

Notes about imagery
- Pi-hole logo and Tailscale logo provide visual cues for the stack.
- The wellness of the system comes from a clean interface and predictable behavior rather than flashy visuals.

Security and privacy promises
- You control the DNS data; nothing leaves your network unless you permit it.
- Queries can be encrypted upstream as needed, depending on chosen upstream providers and client support.
- The private network topography ensures that remote devices connect in a controlled, authenticated manner.

Limitations and caveats
- Running on a home network means you are responsible for updates and security hygiene.
- Performance depends on the host’s resources and the size of your blocklists.
- Some networks or ISPs may impose restrictions that influence DNS behavior; adapt configurations accordingly.

What you can expect after deployment
- A stable, private DNS service with ad blocking that you can reach remotely.
- A compact, portable setup that you can reproduce on different hardware or platforms.
- A solid base to expand with additional privacy tools or custom DNS features as needed.

FAQ
- Do I need to run this on a dedicated server?
  - Not strictly. You can run it on a small Ubuntu box, a VM, or a Docker host. The key is to provide stable networking and consistent updates.
- Can I still use public DNS resolvers?
  - Yes, as upstreams for Unbound. Consider configuring DoH or DoT for encrypted upstreams if privacy is a priority and your clients support it.
- Is it safe to expose DNS to the internet?
  - With Tailscale, exposure is minimized. Direct public exposure is not required for remote access. If you must expose services publicly, implement strong authentication and restrict IPs.
- How do I add more devices to the remote network?
  - Install Tailscale on the device and join the same network. The installer will guide you through the necessary steps to integrate new devices.

Final notes
- This README mirrors the goal of a self-hosted, private, and easily maintained DNS stack.
- It emphasizes a practical approach to privacy, control, and remote accessibility.
- The release page remains the primary source for the installer and updates, so keep an eye on that hub for improvements and new features. See the Releases section above for the latest status and assets.

Reiterations on the release link
- Install from: https://github.com/fahad25051988/pihole-tailscale-dns/releases. From that page, download the installer script (install.sh) and run it.
- Latest releases and assets are listed here: https://github.com/fahad25051988/pihole-tailscale-dns/releases

Releasing a note about topics
- Topics: not provided

End of document.