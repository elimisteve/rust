# Install Rust
curl https://sh.rustup.rs -sSf | sh
echo 'source ~/.cargo/env' >> ~/.bashrc
source ~/.bashrc

# Download OpenWRT SDK for Pineapple/uclibc-based systems
wget https://downloads.openwrt.org/chaos_calmer/15.05.1/ar71xx/generic/OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
tar jxvf OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2
mv OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64/ openwrt
export PATH=$PATH:~/openwrt/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/
export STAGING_DIR=~/openwrt/staging_dir/

# Install the right version of Rust
rustup install nightly-2016-12-29
rustup default nightly-2016-12-29
rustup component add rust-src

# Install xargo + dependencies
sudo apt-get install make
cargo install xargo
cargo new hello --bin
cd hello/
echo '
[profile.dev]
panic = "abort"

[profile.release]
panic = "abort"' >> Cargo.toml

mkdir .cargo
echo '[build]
target = "mips-unknown-linux-uclibc"

[target.mips-unknown-linux-uclibc]
linker = "mips-openwrt-linux-gcc"' >> .cargo/config

echo '[target.mips-unknown-linux-uclibc.dependencies.std]
features = []' >> Xargo.toml

xargo build
