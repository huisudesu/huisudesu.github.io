# 如果没有消息后缀，默认提交信息为 `:pencil: update content`
info=$1
if ["$info" = ""];
then info="update content"
fi
git pull
git add -A
git commit -m "$info"
git push origin hexo
