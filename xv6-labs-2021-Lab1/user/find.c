#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char* path) {
    // 格式化文件名，如果长度小于DIRSIZ则用空格填充
    static char buf[DIRSIZ + 1];
    char* p;
    
    // 查找最后一个 '/' 后的第一个字符
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
    p++;
    
    // 如果文件名长度大于或等于DIRSIZ，直接返回文件名
    if (strlen(p) >= DIRSIZ)
        return p;
    
    // 否则，将文件名拷贝到缓冲区buf，并用空格填充
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
    return buf;
}

int match(char* path, char* name) {
    char* p;
    
    // 查找最后一个 '/' 后的第一个字符
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
    p++;
    
    // 比较文件名是否匹配
    if (strcmp(p, name) == 0)
        return 1;
    else
        return 0;
}

void find(char* path, char* name) {
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    // 打开目录
    if ((fd = open(path, 0)) < 0) {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    // 获取文件状态
    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }

    // 判断文件类型
    if (st.type == T_FILE) {
        // 文件类型直接匹配
        if (match(path, name)) {
            printf("%s\n", path);
        }
    } else if (st.type == T_DIR) {
        // 目录类型进行递归查找
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {
            printf("find: path too long\n");
            close(fd);
            return;
        }
        strcpy(buf, path);
        p = buf + strlen(buf);
        *p++ = '/';

        // 读取目录内容
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
            // 跳过无效目录项
            if (de.inum == 0) continue;

            // 跳过"."和".."目录
            if (de.name[0] == '.' && (de.name[1] == '\0' || (de.name[1] == '.' && de.name[2] == '\0'))) continue;

            // 构造新的路径
            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = '\0';

            // 获取新路径的状态信息
            if (stat(buf, &st) < 0) {
                printf("find: cannot stat %s\n", buf);
                continue;
            }

            // 递归查找子目录
            find(buf, name);
        }
    }
    close(fd);
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        // 检查参数数量
        printf("Usage: find [path] [filename]\n");
        exit(-1);
    }
    // 调用find函数开始查找
    find(argv[1], argv[2]);
    exit(0);
}

