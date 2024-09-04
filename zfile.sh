docker run -d --name=zfile --restart=always \
	-p 8084:8080 \
	-v /home/cliff/workspace/storage_workspace/zfile/db:/root/.zfile-v4/db \
	-v /home/cliff/workspace/storage_workspace/zfile/logs:/root/.zfile-v4/logs \
	-v /home/cliff/workspace/storage_workspace/zfile/file:/data/file \
	zhaojun1998/zfile
