# 6. Encryption Model

- Encryption is performed using **AES-256-CBC**
- Implemented via `openssl`
- Password is:
  - Read from environment variable, or
  - Prompted interactively (once per session)
- Passwords are **never stored on disk**

This approach balances security with simplicity.
