# General instructions

This project is used only to test a general configuration of `poetry` + `docker` + `environment`. I intend to use this Dockerfile for different projects.

## Build docker Files

How to build this dockerfile.

### Development

```bash
docker build --build-arg dependecies='' . -t poetry_dev
```

### Production

```bash
docker build --build-arg dependecies='--only=main' . -t poetry_production
```