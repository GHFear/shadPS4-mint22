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

# Add gcc-14 and g++-14 : Required for Linux Mint 22
sudo add-apt-repository ppa:ubuntu-toolchain-r/ppa
sudo apt update
sudo apt-get install gcc-14
sudo apt install build-essential clang git cmake libasound2-dev \
    libpulse-dev libopenal-dev libssl-dev zlib1g-dev libedit-dev \
    libudev-dev libevdev-dev libsdl2-dev libjack-dev libsndio-dev \
    qt6-base-dev qt6-tools-dev qt6-multimedia-dev libvulkan-dev \
    vulkan-validationlayers libpng-dev libx11-dev libxext-dev libwayland-dev libfuse2 \
    libstdc++-14-dev qt6-l10n-tools

# Install Clang for Mint 22
sudo wget -qO- https://apt.llvm.org/llvm.sh | sudo bash -s -- 18

# Clone ShadPS4 repository recursively.
git clone -b "$branchname" --recursive --single-branch https://github.com/shadps4-emu/shadPS4.git

# Move into the shadPS4 directory
cd shadPS4

# Generate the build directory in the shadPS4 directory with QT GUI enabled
cmake -S . -B build/ -DENABLE_QT_GUI=ON -DCMAKE_C_COMPILER=clang-18 -DCMAKE_CXX_COMPILER=clang++-18

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
echo "Shadps4-qt.AppImage can be found inside the 'shadPS4/.github' directory.\n"
