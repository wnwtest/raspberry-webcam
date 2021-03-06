# 获取绝对路径，保证其他目录执行此脚本依然正确
{
cd $(dirname "$0")
script_path=$(pwd)
cd -
} &> /dev/null # disable output

# 设置当前目录，cd的目录影响接下来执行程序的工作目录
old_cd=$(pwd)
cd $(dirname "$0")

ffmpeg_version=4.2.1
ffmpeg_bz=ffmpeg-$ffmpeg_version.tar.bz2
ffmpeg_dir=$script_path/ffmpeg-$ffmpeg_version

echo
echo ---------------------------------------------------------------
echo install depends
echo ---------------------------------------------------------------

sudo apt-get -y install libomxil-bellagio-dev

if [ $? -ne 0 ]; then
    echo install libomxil-bellagio-dev failed
    exit 1
fi

echo
echo ---------------------------------------------------------------
echo download $ffmpeg_bz
echo ---------------------------------------------------------------

if [ ! -f $ffmpeg_bz ];then
    wget https://ffmpeg.org/releases/$ffmpeg_bz
else
    echo $ffmpeg_bz exist
fi

if [ $? -ne 0 ]; then
    echo download $ffmpeg_bz failed
    exit 1
fi

echo
echo ---------------------------------------------------------------
echo tar $ffmpeg_bz
echo ---------------------------------------------------------------

if [ ! -d $ffmpeg_dir ];then
    tar jxvf $ffmpeg_bz
else
    echo $ffmpeg_dir exist
fi

if [ $? -ne 0 ]; then
    echo tar $ffmpeg_bz failed
    exit 1
fi

echo
echo ---------------------------------------------------------------
echo config $ffmpeg_dir
echo ---------------------------------------------------------------

cd $ffmpeg_dir
cp ../config_ffmpeg_rpi.sh ./
chmod +x config_ffmpeg_rpi.sh
./config_ffmpeg_rpi.sh

if [ $? -ne 0 ]; then
    echo config $ffmpeg_dir failed
    exit 1
fi

echo
echo ---------------------------------------------------------------
echo make $ffmpeg_dir
echo ---------------------------------------------------------------

make -j4

if [ $? -ne 0 ]; then
    echo make $ffmpeg_dir failed
    exit 1
fi

echo
echo ---------------------------------------------------------------
echo install $ffmpeg_dir
echo ---------------------------------------------------------------

sudo make install

if [ $? -ne 0 ]; then
    echo install $ffmpeg_dir failed
    exit 1
fi

# 恢复工作目录
cd $old_cd

echo install $ffmpeg_dir success