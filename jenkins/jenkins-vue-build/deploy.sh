#!/bin/bash
##
## 自动化构建部署脚本
##
## Started on 2019/10/28 Leo <xinlichao2016@gmail.com>
## Last update 2019/10/28 Leo <xinlichao2016@gmail.com>
##

version="1.0.0"

# Colours
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
magenta="\033[95m"
cyan="\033[96m"
none="\033[0m"

# # 项目名称
project_name=""

# # 环境：development, testing, production
# profile_name=$2
profile_name=development

# # 构建版本：2.0.0
# project_version=$3
project_version=1.0.0

# # 强制安装依赖
# install_dependencies=$4
install_dependencies=0

usage() {
  echo -e "$red Usage:`basename $0` -p [Project Name] -e [development | testing | production] -v [Build Version] | -i [install]$none"

  exit 1
}

# 获取输入参数
while getopts "hp:e:v:i:" opt; do
  case $opt in
  h)
    usage
    ;;
  p)
    project_name=$OPTARG
    ;;
  e)
    profile_name=$OPTARG
    ;;
  v)
    project_version=$OPTARG
    ;;
  i)
    install_dependencies=$OPTARG
    ;;
  ?)
    usage
    ;;
  esac
done

# 检查输入参数
# if test "$#" -ne 4; then
#   echo -e "$red 请输入正确参数：[Project Name] [development | testing | production] [Build Version] | [install]$none"
#   exit 1
# fi

# 检查输入参数
echo $*
if [ $# == 0 ]; then
  usage
fi

if [ -z $project_name ]; then
  usage
fi

# 脚本执行工作路径
work_path=$(
  cd "$(dirname "$0")"
  pwd
)
project_path=$(
  cd "$work_path"
  cd ../
  pwd
)

# docker 镜像仓库地址
docker_registry_uri="registry-vpc.cn-beijing.aliyuncs.com/hst"
docker_file_path="${project_path}/Dockerfile"

# 定义环境和镜像 tag 后缀映射
declare -A image_tag_suffix_map=(["development"]="dev" ["testing"]="staging" ["production"]="release")
declare -A profile_map=(["development"]="stage" ["testing"]="stage" ["production"]="prod")

# 镜像tag
image_tag="${project_version}-${image_tag_suffix_map[$profile_name]}"

# 执行环境
profile="${profile_map[$profile_name]}"

# 镜像地址
image_path="${docker_registry_uri}/${project_name}:${image_tag}"

# package 签名
package_lock="${project_path}/package-lock.json"
package_md5_file="${work_path}/package-md5"
package_md5=$(head -n 1 ${package_md5_file})

# 校验 package 版本
check_version() {
  echo -e "$cyan ==========比较依赖版本========== $none"

  current_package_md5=$(md5sum ${package_lock} | cut -d" " -f 1)

  echo -e "$cyan prev: ${package_md5} current: ${current_package_md5}  $none"

  if [ "$current_package_md5" != "$package_md5" ]; then
    echo -e "$cyan ==========依赖有变化========== $none"
    echo $current_package_md5 >${package_md5_file}
    return 0
  fi
  echo -e "$cyan ==========依赖无变化========== $none"
  return 1
}

deploy() {
  echo "=============================="
  echo -e "$yellow 即将部署 $none"
  echo
  echo -e "$cyan ${image_path} $none"
  echo
  echo "=============================="

  check_version

  if [[ $? -eq 0 || $install_dependencies -eq 1 ]]; then
    echo -e "$cyan ==========安装依赖========== $none"
    # 安装依赖
    npm install --registry=https://registry.npm.taobao.org
  fi

  echo -e "$cyan ==========开始构建========== $none"
  # 打包
  npm run build:${profile}

  echo -e "$cyan ==========开始构建镜像文件========== $none"
  # 构建镜像
  docker build -t "${image_path}" -f ${docker_file_path} ${project_path}

  echo -e "$cyan ==========发布镜像========== $none"
  # 发布镜像
  docker push ${image_path}

  echo
  echo -e "${green}===============部署成功===============${none}"
  echo

}

# 开始执行
deploy
