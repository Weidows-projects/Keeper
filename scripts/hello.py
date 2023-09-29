'''
?: *********************************************************************
Author: Weidows
Date: 2022-03-30 15:58:40
LastEditors: Weidows
LastEditTime: 2023-07-14 01:04:15
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

from concurrent.futures import ThreadPoolExecutor
import json
import os
import sys
import requests
import threading
import multiprocessing


class Utils:
    BASE_URL = "https://www.helloimg.com/get-user-images/"

    # D:\Repos\Weidows-projects\Keeper\Programming-Configuration\backup\Weidows
    BACKUP_PATH = ""

    # Weidows
    USER_NAME = ""

    # 不带 agent 的话会被防火墙拦截: <h1><span>拒绝非浏览器请求</span></h1>
    HEADER = {
        'User-Agent': 'Apifox/1.0.0 (https://www.apifox.cn)',
        'Accept': '*/*',
        'Host': 'www.helloimg.com',
        'Connection': 'keep-alive'
    }

    LOCK = threading.Lock()

    DATAS = []

    CPU_COUNT = multiprocessing.cpu_count()

    @staticmethod
    def getResponseJson(url, method):
        try:
            if method == "GET":
                # url, headers=Utils.HEADER, verify=False)
                responseData = requests.get(url, headers=Utils.HEADER)
            elif method == "POST":
                responseData = requests.post(url, headers=Utils.HEADER)
            return json.loads(responseData.text)
        except Exception as e:
            print(e)
            return None


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

        is_exists = False
        if not os.path.exists(path):
            if not os.path.exists(date):
                os.mkdir(date)
            pic = requests.get(url, headers=Utils.HEADER)
            with open(path, 'wb') as f:
                f.write(pic.content)
                f.flush()
        else:
            is_exists = True

        Utils.LOCK.acquire()
        print(
            f"{path} is_exists:{is_exists} {threading.current_thread().name} backuped"
        )
        Utils.LOCK.release()


if __name__ == '__main__':
    argv = sys.argv[1:]
    # argv = [
    #     "Weidows", "D:/Repos/Weidows-projects/Keeper/Programming-Configuration/backup/"
    # ]

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

    try:
        os.remove("response.json")
    except FileNotFoundError:
        pass

    with open("response.json", 'wb') as f:
        f.write(json.dumps(Utils.DATAS).encode())
        f.flush()

    with ThreadPoolExecutor(max_workers=Utils.CPU_COUNT) as executor:
        for i in range(Utils.CPU_COUNT):
            executor.submit(multi_downloader)
