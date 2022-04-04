# perl-test-container

Needs postgresql connection information as environment variable and wait for connection during start.

Sample usage:

```Dockerfile
---
version: '3.9'

services:

  db:
    image: postgres:12
    environment:
      POSTGRES_PASSWORD: xxxx

  perl-test-container:
    image: quay.io/modellaachen/perl-test
    environment:
      POSTGRES_HOST: db
      POSTGRES_PORT: 5432
    depends_on:
      - db
```