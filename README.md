# readmylogin

A small C utility to **decrypt and display** the contents of a MySQL `.mylogin.cnf` file — the encrypted login credentials file created by `mysql_config_editor`.

No MySQL library required. Uses OpenSSL's `libcrypto` only.

---

## Origin

This is a modernized fork of **version 1** (May 21, 2015) of `readmylogin.c`,  
originally written by **Peter Gulutzan** (Ocelot Computer Services Inc.)  
and published on [Planet MySQL](https://planet.mysql.com/entry/?id=5990165) / [ocelot.ca](http://ocelot.ca/blog/blog/2015/05/21/decrypt-mylogin-cnf/).

The upstream source is also part of the [ocelotgui](https://github.com/ocelot-inc/ocelotgui) project.

### Changes from the original

| # | Change |
|---|--------|
| 1 | Added missing `#include <unistd.h>` to expose `lseek()` and `read()` |
| 2 | Replaced the manual AES struct stub with the real `#include <openssl/aes.h>` |
| 3 | Fixed `key_after_xor` type (`char` → `unsigned char`) to match the OpenSSL API signature |
| 4 | Added `#define OPENSSL_SUPPRESS_DEPRECATED` for clean compilation under OpenSSL 3.0 |

---

## How it works

MySQL's `mysql_config_editor` stores login credentials (host, user, password, port, socket) in `~/.mylogin.cnf`, encrypted with AES-128 ECB. The file structure is:

| Offset | Size     | Description                           |
|--------|----------|---------------------------------------|
| 0      | 4 bytes  | Reserved (unused)                     |
| 4      | 20 bytes | Key material (XOR-folded to 16 bytes) |
| 24+    | repeated | 4-byte chunk length + cipher chunk    |

The tool derives the AES key from the embedded key material, then decrypts each chunk to reveal the plaintext INI-style configuration.

---

## Requirements

- Linux (tested on Ubuntu/Debian)
- GCC
- OpenSSL (`libssl-dev`)

---
 
## Installation
 
### Manual
 
```bash
# Install OpenSSL dev library
sudo apt install libssl-dev gcc
 
# Compile
make
```
 
The binary `readmylogin` appears in the current directory. Move it wherever you like.
 
---
 
## Usage
 
```bash
./readmylogin ~/.mylogin.cnf
```
 
### Example output
 
```ini
[client]
user = myuser
password = mypassword
host = 127.0.0.1
 
[client_prod]
user = admin
password = s3cr3t
host = db.example.com
port = 3306
```
 
---

## Compatibility

The `.mylogin.cnf` file format has not officially changed since it was introduced in **MySQL 5.6**, and the MySQL documentation describes the same AES-128 ECB structure across versions 5.6, 5.7, 8.0, 8.4, and 9.x. This tool should therefore work with any of these versions.

That said, **this has not been personally tested** beyond MySQL 5.6 files. The original author also noted that MySQL may change the format without notice. If you test it with a specific version and it works (or doesn't), feel free to open an issue.

---

## License

BSD 3-Clause — see source file header for full license text.  
Original copyright: Ocelot Computer Services Inc.