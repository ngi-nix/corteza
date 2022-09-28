# Stuff todo

- exposing dream2nix flake attribute properly to the calling flake

- Maybe look for different available API paths in the source.
- <https://docs.cortezaproject.org/corteza-docs/2020.12/dev-ops-guide/architecture-overview.html>
- [ ] We are currently getting an error from vue-cli
  ```
      Something something, "\[contenthash:8\]\.js"
  ```
  You can find the sources for vue-cli-service in
  `/nix/store/*****-corteza-webapp-admin-2022.3.4/lib/node_modules/corteza-webapp-admin/node_modules/@vue/cli-service`, and it looks like it needs a bit of patching.
