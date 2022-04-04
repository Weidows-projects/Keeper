'''
?: *********************************************************************
Author: Weidows
Date: 2022-03-30 15:58:40
LastEditors: Weidows
LastEditTime: 2022-04-04 13:01:21
FilePath: \Keeper\scripts\hello.py
Description:          Hello 图床多线程增量备份脚本

命令行启动示例:
    python "scripts\hello.py" "username" .\
参数说明:
    第一个参数: 你的用户名
    第二个参数: 备份路径 (注意末尾带个 '\')

注意:
    要在开了代理的终端环境下运行, 否则可能报错
    HTTPSConnectionPool(host='www.helloimg.com', port=443): Max retries exceeded
!: *********************************************************************
'''

import json
import os
import sys
import requests
import threading


class Utils:
    BASE_URL = "https://www.helloimg.com/get-user-images/"

    # D:\Repos\Weidows-projects\Keeper\Programming-Configuration\backup\Weidows
    BACKUP_PATH = ""

    # Weidows
    USER_NAME = ""

    LOCK = threading.Lock()

    DATAS = []

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
            responseData = Utils.__sendHttpGetWithHeader(url)
        elif method == "POST":
            responseData = Utils.__sendHttpPostWithHeaders(url)
        return json.loads(responseData.text)


def __init__():
    argv = sys.argv[1:]

    try:
        Utils.USER_NAME = argv[0]
        Utils.BACKUP_PATH = argv[1] + "hello"
    except IndexError:
        print("请正确输入参数中: 用户名 备份路径")

    if os.path.exists(Utils.BACKUP_PATH):
        print("备份文件夹已存在: " + Utils.BACKUP_PATH)
    else:
        os.mkdir(Utils.BACKUP_PATH)
    os.chdir(Utils.BACKUP_PATH)

    Utils.DATAS = Utils.getResponseJson(Utils.BASE_URL + Utils.USER_NAME,
                                        "GET")

    os.remove("response.json")
    with open("response.json", 'wb') as f:
        f.write(json.dumps(Utils.DATAS).encode())
        f.flush()


def multi_downloader():
    while True:
        Utils.LOCK.acquire()
        if Utils.DATAS.__len__() == 0:
            Utils.LOCK.release()
            return
        # https://www.helloimg.com/images/2022/02/26/GVROC6.png
        url = Utils.DATAS.pop()["image"]
        Utils.LOCK.release()

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
            print("Thread-" + threading.currentThread().name + ": " + path +
                  " 不存在，已下载")

        else:
            print("Thread-" + threading.currentThread().name + ": " + path +
                  " 存在,跳过")


if __name__ == '__main__':
    __init__()
    # 8 线程
    for i in range(8):
        threading.Thread(target=multi_downloader).start()
