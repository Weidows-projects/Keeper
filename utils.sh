###
 # @?: *********************************************************************
 # @Author: Weidows
 # @Date: 2022-08-12 18:53:31
 # @LastEditors: Weidows
 # @LastEditTime: 2023-12-20 23:08:59
 # @FilePath: \Blog-privated:\Repos\Weidows-projects\Keeper\utils.sh
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
    if [ ! "$BACKUP_DIR" ]; then BACKUP_DIR=$(dirname "$0")/Programming-Configuration; fi

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
  mkdir -p "${BACKUP_DIR}" && cd "${BACKUP_DIR}" || exit

  # lists
    mkdir lists & cd lists || exit

    # Homebrew
    brew list > pkgs/brew-list.bak

    cd ..


  # 其他
    mkdir others & cd others || exit

    cp /etc/hosts hosts/hosts.mac

    cd ..


  # ~/
    mkdir dotfiles & cd dotfiles || exit

    # 会覆盖掉之前的
    cp ~/.zshrc .
}






# ==================================================================
# main入口, shell 函数只能定义后调用, 且不调用不执行
# ==================================================================
  # backup（） 加括号调用会报错
  backup
