#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char* argv[]) {
    char buf[512]; // 缓冲区，用于存储输入的字符串
    char* xargs[32]; // 用于存储命令行参数的数组
    int i;

    // 将命令行参数复制到xargs数组中
    for (i = 1; i < argc; i++) {
        xargs[i - 1] = argv[i];
    }

    // 无限循环，直到用户输入为空
    while (1) {
        int x = argc - 1;
        // 从标准输入读取一行
        if (!gets(buf, sizeof(buf)) || buf[0] == 0)
            break;

        // 将输入的字符串作为参数添加到xargs数组中
        xargs[x++] = buf;

        // 遍历输入的字符串，处理空格和换行符
        for (char* p = buf; *p; p++) {
            if (*p == ' ') {
                *p = 0;
                xargs[x++] = p + 1;
            } else if (*p == '\n') {
                *p = 0;
            }
        }

        // 创建子进程
        if (fork() == 0) {
            // 在子进程中执行命令
            exec(argv[1], xargs);
            // 如果exec失败，输出错误信息并退出
            fprintf(2, "exec %s failed\n", argv[1]);
            exit(1);
        }

        // 等待子进程结束
        wait(0);
    }

    exit(0);
}

