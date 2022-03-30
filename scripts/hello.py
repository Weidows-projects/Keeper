'''
?: *********************************************************************
Author: Weidows
Date: 2022-03-30 15:58:40
LastEditors: Weidows
LastEditTime: 2022-03-30 22:28:06
FilePath: \Keeper\scripts\hello.py
Description:          hello 图床备份脚本

命令行启动示例:
    python "scripts\hello.py" "username" .\
参数说明:
    第一个参数: 你的用户名
    第二个参数: 备份路径 (注意末尾带个 '\')

!: *********************************************************************
'''

import json
import os
import sys
import requests


class HttpUtils:
    def __sendHttpGetWithHeader(url):
        try:
            return requests.get(url)
        except Exception as e:
            print(e)
            return None

    def __sendHttpPostWithHeaders(url):
        try:
            return requests.post(url)
        except Exception as e:
            print(e)
            return None

    @staticmethod
    def getResponseJson(url, method):
        if method == "GET":
            responseData = HttpUtils.__sendHttpGetWithHeader(url)
        elif method == "POST":
            responseData = HttpUtils.__sendHttpPostWithHeaders(url)
        return json.loads(responseData.text)


class Config:
    BASE_URL = "https://www.helloimg.com/get-user-images/"

    # D:\Repos\Weidows-projects\Keeper\Programming-Configuration\backup\Weidows
    BACKUP_PATH = ""

    # Weidows
    USER_NAME = ""


def __init__():
    argv = sys.argv[1:]

    try:
        Config.USER_NAME = argv[0]
        Config.BACKUP_PATH = argv[1] + "hello"
    except IndexError:
        print("请正确输入参数中: 用户名 备份路径")

    if os.path.exists(Config.BACKUP_PATH):
        print("备份文件夹已存在: " + Config.BACKUP_PATH)
    else:
        os.mkdir(Config.BACKUP_PATH)
    os.chdir(Config.BACKUP_PATH)

    resJson = HttpUtils.getResponseJson(Config.BASE_URL + Config.USER_NAME,
                                        "GET")

    os.remove("response.json")
    with open("response.json", 'wb') as f:
        f.write(json.dumps(resJson).encode())
        f.flush()

    return resJson


def main():
    datas = __init__()
    for data in datas:
        # https://www.helloimg.com/images/2022/02/26/GVROC6.png
        url = data["image"]

        # 2022-02
        date = url[32:39].replace("/", "-")
        # GVROC6.png
        # 2022-02/GVROC6.png
        path = date + '/' + url[43:]

        if not os.path.exists(path):
            if not os.path.exists(date):
                os.mkdir(date)
            pic = requests.get(url)
            with open(path, 'wb') as f:
                f.write(pic.content)
                f.flush()
            print(url + " 不存在，已下载")
        else:
            print(url + " 存在,跳过")


if __name__ == '__main__':
    main()
