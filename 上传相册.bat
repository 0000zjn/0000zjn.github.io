@echo 处理照片并上传至备份。。
F:
cd F:\WorkSpace\Blog-File-Back-Up
start /wait /b F:\WorkSpace\Blog-File-Back-Up\tool.py
@echo
@echo ====照片已上传！==========
@echo
@echo ====正在上传相册静态文件。。==
cd F:\WorkSpace\ZjnBlog
start /wait /b hexo d
