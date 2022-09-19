###
 # @?: *********************************************************************
 # @Author: Weidows
 # @Date: 2022-08-12 18:53:31
 # @LastEditors: Weidows
 # @LastEditTime: 2022-09-19 16:26:12
 # @FilePath: /Keeper/utils.sh
 # @Description:
 #    此文件换行符需要用LF, CRLF是Windows下的
 #    TODO 迁移 bat 到 sh
 # @!: *********************************************************************
###

# ==================================================================
# Initialization
# ==================================================================
  BACKUP_DIR=
    # dirname $0 脚本所在路径
    if [ ! $BACKUP_DIR ]; then BACKUP_DIR=`dirname $0`/Programming-Configuration; fi

    # if [ -d "$HOME/backup" ]; then
    #   BACKUP_DIR="$HOME/backup"
    # else
    #   BACKUP_DIR="$HOME/backup"
    # fi
    # if [ ! -d "${BACKUP_DIR}" ]; then
      # mkdir -p ${BACKUP_DIR}
      # cd ${BACKUP_DIR}






# ==================================================================
# 备份
# ==================================================================
backup (){
  mkdir -p ${BACKUP_DIR} && cd ${BACKUP_DIR}

  # lists
    mkdir lists & cd lists

    # Homebrew
    brew list > scoop/brew-list.bak

    cd ..


  # 其他
    mkdir others & cd others

    cp /etc/hosts hosts/hosts.mac

    cd ..


  # ~/
    mkdir user-config & cd user-config

    # 会覆盖掉之前的
    cp ~/.zshrc .
}






# ==================================================================
# main入口, shell 函数只能定义后调用, 且不调用不执行
# ==================================================================
  # backup（） 加括号调用会报错
  backup
