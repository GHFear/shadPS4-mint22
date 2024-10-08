# ShadPS4-QT Build Setup for Linux Mint 22

# List all shadPS4 branches
echo "List of shadPS4 branches:\n"
git ls-remote --heads https://github.com/shadps4-emu/shadPS4.git
echo "\n"

# Select branch to download and build
read -p "Enter shadPS4 branch path: " branchpath

# Remove path from branch name.
prefix="refs/heads/"
branchname=${branchpath#"$prefix"}
echo "\nYou selected branch: $branchname\n"

# Add apt-repo: ppa:ubuntu-toolchain-r/test : Required for Linux Mint 22
sudo add-apt-repository ppa:ubuntu-toolchain-r/test

# Add gcc-13 and g++-13 : Required for Linux Mint
sudo apt-get update
sudo apt-get install gcc-13

# Install dependencies pack 1 : Required for Linux Mint 22
sudo apt-get update && sudo apt install libssl-dev libx11-dev libxext-dev libwayland-dev libfuse2 clang build-essential qt6-base-dev qt6-tools-dev

# Install dependencies pack 2 : Required for Linux Mint 22
sudo apt-get install build-essential libasound2-dev libpulse-dev libopenal-dev zlib1g-dev libedit-dev libvulkan-dev libudev-dev git libevdev-dev libsdl2-2.0 libsdl2-dev libjack-dev libsndio-dev

# Install dependencies pack 3 : Required for Linux Mint 22
sudo apt-get install qt6-multimedia-dev

# Clone ShadPS4 repository recursively.
git clone -b "$branchname" --recursive --single-branch https://github.com/shadps4-emu/shadPS4.git

# Move into the shadPS4 directory
cd shadPS4

# Generate the build directory in the shadPS4 directory with QT GUI enabled
cmake -S . -B build/ -DCMAKE_C_COMPILER="/usr/bin/gcc-13" -DCMAKE_CXX_COMPILER="/usr/bin/g++-13" -DENABLE_QT_GUI=ON

# Enter the build directory
cd build/

# Parallel build project with cmake.
cmake --build . --parallel$(nproc)

# Build shadPS4 AppImg
cd "../.github"
bash linux-appimage-qt.sh


# shadPS4 executable can be found inside the "shadPS4/build" directory.
# Shadps4-qt.AppImage can be found inside the "shadPS4/.github" directory.
echo "Build completed.\n"
echo "shadPS4 executable can be found inside the 'shadPS4/build' directory.\n"
echo "Shadps4-qt.AppImage can be found inside the 'shadPS4/.github"' directory.\n"

