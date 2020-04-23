# UFS Project Web Site

Source code of website <https://ufs.co.ua/>

Development here <https://dev.ufs.co.ua/>

## Build and test

```sh
make build && make test
```

## For fast PHP development

First of all need to set project root directory in `~/.bashrc` file:

```sh
export UFS_RUST_WEBSITE=/home/${USER}/GitHub/ufs-rust-website
```

And then you can simply run `make dev` command to start a server and make any changes in `/htdocs` folder in any PHP file
