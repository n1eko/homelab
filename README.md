# homelab

<p align="center">
  <img src="https://static.n1eko.com/cat.webp" alt="A cat" width="320">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Docker_Compose-2496ED?style=flat-square&logo=docker&logoColor=white" alt="Docker Compose">
  <img src="https://img.shields.io/badge/Komodo-deploys-6E56CF?style=flat-square" alt="Komodo">
  <img src="https://img.shields.io/badge/Traefik-24A1C1?style=flat-square&logo=traefikproxy&logoColor=white" alt="Traefik">
  <img src="https://img.shields.io/badge/Tailscale-242424?style=flat-square&logo=tailscale&logoColor=white" alt="Tailscale">
  <img src="https://img.shields.io/badge/Renovate-enabled-1A1F6C?style=flat-square&logo=renovatebot&logoColor=white" alt="Renovate">
  <a href="https://github.com/n1eko/homelab/actions/workflows/gitleaks.yml"><img src="https://img.shields.io/github/actions/workflow/status/n1eko/homelab/gitleaks.yml?branch=main&style=flat-square&label=gitleaks" alt="gitleaks"></a>
</p>

Docker Compose stacks for my homelab and two Oracle Cloud servers, deployed by
[Komodo](https://komo.do) from this repo. See [CONTRIBUTING.md](CONTRIBUTING.md) for the layout,
secrets and conventions.

## What's running

| | |
|---|---|
| 🎬 **Media** | Jellyfin · Sonarr · Radarr · Bazarr · Prowlarr · qBittorrent · Seerr · Calibre-Web · Homarr |
| 🏡 **Home** | Home Assistant · Mosquitto · Frigate · Immich · Mealie |
| 🔐 **Core** | Traefik · Vaultwarden · Cloudflare DDNS · private Docker registry |
| 💾 **Backups** | nightly DB dumps → Kopia on an external drive |
| 📈 **Monitoring** | Prometheus + exporters · Grafana Cloud |
| 🧪 **Projects** | schassis (API + scraper) · Kafka · MongoDB · Budget Tracker |
| 🎮 **Games** | Project Zomboid · Assetto Corsa |

<sub>3 servers · 23 stacks · 55 containers</sub>
