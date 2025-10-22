# Troubleshooting

## Docker Issues
- **Build fails (bulk-extractor)**: Update Dockerfile to use Debian stable; run `docker compose build dfir --no-cache`.
- **Permission errors**: Set .env PUID/PGID to your user (id -u). Restart: `docker compose down -v; docker compose up -d`.
- **Autopsy not launching**: `docker compose exec autopsy autopsy &`; access http://localhost:8080/vnc.html.

## Tool Errors
- **Volatility "no profile"**: Run `vol -f memory.ram windows.info.Info` first for profile.
- **Plaso "no artifacts"**: Ensure usb.img complete (rerun make_practice_image.sh).
- **tshark not found**: Install host-side `sudo apt install tshark` for Lab 5 (container lacks).

## Evidence
- **Disk.img empty deleted file**: Rerun script with sudo; check fls output.
- **Hashes change**: Normal for runtime generated; focus on content.

Logs: `docker compose logs <service>`. Rebuild: `docker compose down; docker compose up --build`.
