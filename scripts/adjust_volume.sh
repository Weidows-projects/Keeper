# 定义一个函数，接受一个音频文件名和一个音量调整参数（分贝值）
adjust_volume() {
  # 使用ffmpeg的volume滤镜来改变音频文件的音量
  ffmpeg -i "$1" -filter:a "volume=$2dB" "adjusted/$1"
}

mkdir adjusted

# 遍历当前目录下的所有mp3和wav文件
for file in *.mp3 *.wav; do
  # 调用函数，将音量降低5分贝
  adjust_volume "$file" -5
done
