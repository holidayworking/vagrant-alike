#
# Cookbook Name:: vagrant-alike
# Recipe:: opencv
#
# Copyright (C) 2013 Hidekazu Tanaka
#
# All rights reserved - Do Not Redistribute
#

%w(
libopencv-dev
build-essential
checkinstall
cmake
pkg-config
yasm
libtiff4-dev
libjpeg-dev
libjasper-dev
libavcodec-dev
libavformat-dev
libswscale-dev
libdc1394-22-dev
libxine-dev
libgstreamer0.10-dev
libgstreamer-plugins-base0.10-dev
libv4l-dev
python-dev
python-numpy
libtbb-dev
libqt4-dev
libgtk2.0-dev
libfaac-dev
libmp3lame-dev
libopencore-amrnb-dev
libopencore-amrwb-dev
libtheora-dev
libvorbis-dev
libxvidcore-dev
x264
v4l-utils
ffmpeg).each do |pkg|
  package pkg do
    action :install
  end
end

remote_file '/usr/local/src/OpenCV-2.4.5.tar.gz' do
  source 'http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.5/opencv-2.4.5.tar.gz/download'
  mode 00644
  action :create_if_missing
end

directory '/usr/local/src/opencv' do
  owner 'root'
  group 'root'
  mode 00755
  action :create
  recursive true

  not_if { File.exists?('/usr/local/src/opencv') }
end

execute 'untar-opencv' do
  cwd '/usr/local/src/opencv'
  command 'tar --strip-components 1 -xzf /usr/local/src/OpenCV-2.4.5.tar.gz'

  not_if { File.exists?('/usr/local/src/opencv/README') }
end

bash 'install-opencv' do
  user 'root'
  group 'root'
  cwd '/usr/local/src/opencv'

  code <<-EOC
    mkdir build
    cd build
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
    make
    make install
  EOC

  not_if { File.exists?('/usr/local/bin/opencv_createsamples') }
end

cookbook_file '/etc/ld.so.conf.d/opencv.conf' do
  source 'opencv.ld.so.conf'
  owner 'root'
  group 'root'
  mode 00644

  not_if { File.exists?('/etc/ld.so.conf.d/opencv.conf') }
end

execute 'ldconfig' do
  command '/sbin/ldconfig'
end
