import wave

# 打开WAV文件
with wave.open('example.wav', 'rb') as wav_file:
    # 获取音频参数
    params = wav_file.getparams()
    n_channels, sampwidth, framerate, n_frames = params[:4]

    # 读取音频数据
    frames = wav_file.readframes(n_frames)

# 将音频数据写入TXT文件
with open('audio.txt', 'w') as txt_file:
    # 写入音频帧数据
    for i in range(0, len(frames), sampwidth):
        frame_data = frames[i:i+sampwidth]
        result = frame_data.hex()
        txt_file.write(f'{result}\n')
