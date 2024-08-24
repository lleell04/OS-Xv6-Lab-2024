
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char* fmtname(char* path) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
    // 格式化文件名，如果长度小于DIRSIZ则用空格填充
    static char buf[DIRSIZ + 1];
    char* p;
    
    // 查找最后一个 '/' 后的第一个字符
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
  10:	00000097          	auipc	ra,0x0
  14:	352080e7          	jalr	850(ra) # 362 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    p++;
  36:	00178493          	addi	s1,a5,1
    
    // 如果文件名长度大于或等于DIRSIZ，直接返回文件名
    if (strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	326080e7          	jalr	806(ra) # 362 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    
    // 否则，将文件名拷贝到缓冲区buf，并用空格填充
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
    return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
    memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	304080e7          	jalr	772(ra) # 362 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	aea98993          	addi	s3,s3,-1302 # b50 <buf.1109>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	464080e7          	jalr	1124(ra) # 4da <memmove>
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2e2080e7          	jalr	738(ra) # 362 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2d4080e7          	jalr	724(ra) # 362 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2e4080e7          	jalr	740(ra) # 38c <memset>
    return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <match>:

int match(char* path, char* name) {
  b4:	1101                	addi	sp,sp,-32
  b6:	ec06                	sd	ra,24(sp)
  b8:	e822                	sd	s0,16(sp)
  ba:	e426                	sd	s1,8(sp)
  bc:	e04a                	sd	s2,0(sp)
  be:	1000                	addi	s0,sp,32
  c0:	84aa                	mv	s1,a0
  c2:	892e                	mv	s2,a1
    char* p;
    
    // 查找最后一个 '/' 后的第一个字符
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
  c4:	00000097          	auipc	ra,0x0
  c8:	29e080e7          	jalr	670(ra) # 362 <strlen>
  cc:	1502                	slli	a0,a0,0x20
  ce:	9101                	srli	a0,a0,0x20
  d0:	9526                	add	a0,a0,s1
  d2:	02f00713          	li	a4,47
  d6:	00956963          	bltu	a0,s1,e8 <match+0x34>
  da:	00054783          	lbu	a5,0(a0)
  de:	00e78563          	beq	a5,a4,e8 <match+0x34>
  e2:	157d                	addi	a0,a0,-1
  e4:	fe957be3          	bgeu	a0,s1,da <match+0x26>
    p++;
    
    // 比较文件名是否匹配
    if (strcmp(p, name) == 0)
  e8:	85ca                	mv	a1,s2
  ea:	0505                	addi	a0,a0,1
  ec:	00000097          	auipc	ra,0x0
  f0:	24a080e7          	jalr	586(ra) # 336 <strcmp>
        return 1;
    else
        return 0;
}
  f4:	00153513          	seqz	a0,a0
  f8:	60e2                	ld	ra,24(sp)
  fa:	6442                	ld	s0,16(sp)
  fc:	64a2                	ld	s1,8(sp)
  fe:	6902                	ld	s2,0(sp)
 100:	6105                	addi	sp,sp,32
 102:	8082                	ret

0000000000000104 <find>:

void find(char* path, char* name) {
 104:	d9010113          	addi	sp,sp,-624
 108:	26113423          	sd	ra,616(sp)
 10c:	26813023          	sd	s0,608(sp)
 110:	24913c23          	sd	s1,600(sp)
 114:	25213823          	sd	s2,592(sp)
 118:	25313423          	sd	s3,584(sp)
 11c:	25413023          	sd	s4,576(sp)
 120:	23513c23          	sd	s5,568(sp)
 124:	23613823          	sd	s6,560(sp)
 128:	1c80                	addi	s0,sp,624
 12a:	892a                	mv	s2,a0
 12c:	89ae                	mv	s3,a1
    int fd;
    struct dirent de;
    struct stat st;

    // 打开目录
    if ((fd = open(path, 0)) < 0) {
 12e:	4581                	li	a1,0
 130:	00000097          	auipc	ra,0x0
 134:	4a0080e7          	jalr	1184(ra) # 5d0 <open>
 138:	04054e63          	bltz	a0,194 <find+0x90>
 13c:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }

    // 获取文件状态
    if (fstat(fd, &st) < 0) {
 13e:	d9840593          	addi	a1,s0,-616
 142:	00000097          	auipc	ra,0x0
 146:	4a6080e7          	jalr	1190(ra) # 5e8 <fstat>
 14a:	06054063          	bltz	a0,1aa <find+0xa6>
        close(fd);
        return;
    }

    // 判断文件类型
    if (st.type == T_FILE) {
 14e:	da041783          	lh	a5,-608(s0)
 152:	0007869b          	sext.w	a3,a5
 156:	4709                	li	a4,2
 158:	06e68963          	beq	a3,a4,1ca <find+0xc6>
        // 文件类型直接匹配
        if (match(path, name)) {
            printf("%s\n", path);
        }
    } else if (st.type == T_DIR) {
 15c:	2781                	sext.w	a5,a5
 15e:	4705                	li	a4,1
 160:	08e78663          	beq	a5,a4,1ec <find+0xe8>

            // 递归查找子目录
            find(buf, name);
        }
    }
    close(fd);
 164:	8526                	mv	a0,s1
 166:	00000097          	auipc	ra,0x0
 16a:	452080e7          	jalr	1106(ra) # 5b8 <close>
}
 16e:	26813083          	ld	ra,616(sp)
 172:	26013403          	ld	s0,608(sp)
 176:	25813483          	ld	s1,600(sp)
 17a:	25013903          	ld	s2,592(sp)
 17e:	24813983          	ld	s3,584(sp)
 182:	24013a03          	ld	s4,576(sp)
 186:	23813a83          	ld	s5,568(sp)
 18a:	23013b03          	ld	s6,560(sp)
 18e:	27010113          	addi	sp,sp,624
 192:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
 194:	864a                	mv	a2,s2
 196:	00001597          	auipc	a1,0x1
 19a:	92258593          	addi	a1,a1,-1758 # ab8 <malloc+0xea>
 19e:	4509                	li	a0,2
 1a0:	00000097          	auipc	ra,0x0
 1a4:	742080e7          	jalr	1858(ra) # 8e2 <fprintf>
        return;
 1a8:	b7d9                	j	16e <find+0x6a>
        fprintf(2, "find: cannot stat %s\n", path);
 1aa:	864a                	mv	a2,s2
 1ac:	00001597          	auipc	a1,0x1
 1b0:	92458593          	addi	a1,a1,-1756 # ad0 <malloc+0x102>
 1b4:	4509                	li	a0,2
 1b6:	00000097          	auipc	ra,0x0
 1ba:	72c080e7          	jalr	1836(ra) # 8e2 <fprintf>
        close(fd);
 1be:	8526                	mv	a0,s1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	3f8080e7          	jalr	1016(ra) # 5b8 <close>
        return;
 1c8:	b75d                	j	16e <find+0x6a>
        if (match(path, name)) {
 1ca:	85ce                	mv	a1,s3
 1cc:	854a                	mv	a0,s2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	ee6080e7          	jalr	-282(ra) # b4 <match>
 1d6:	d559                	beqz	a0,164 <find+0x60>
            printf("%s\n", path);
 1d8:	85ca                	mv	a1,s2
 1da:	00001517          	auipc	a0,0x1
 1de:	90e50513          	addi	a0,a0,-1778 # ae8 <malloc+0x11a>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	72e080e7          	jalr	1838(ra) # 910 <printf>
 1ea:	bfad                	j	164 <find+0x60>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {
 1ec:	854a                	mv	a0,s2
 1ee:	00000097          	auipc	ra,0x0
 1f2:	174080e7          	jalr	372(ra) # 362 <strlen>
 1f6:	2541                	addiw	a0,a0,16
 1f8:	20000793          	li	a5,512
 1fc:	04a7e363          	bltu	a5,a0,242 <find+0x13e>
        strcpy(buf, path);
 200:	85ca                	mv	a1,s2
 202:	dc040513          	addi	a0,s0,-576
 206:	00000097          	auipc	ra,0x0
 20a:	114080e7          	jalr	276(ra) # 31a <strcpy>
        p = buf + strlen(buf);
 20e:	dc040513          	addi	a0,s0,-576
 212:	00000097          	auipc	ra,0x0
 216:	150080e7          	jalr	336(ra) # 362 <strlen>
 21a:	02051913          	slli	s2,a0,0x20
 21e:	02095913          	srli	s2,s2,0x20
 222:	dc040793          	addi	a5,s0,-576
 226:	993e                	add	s2,s2,a5
        *p++ = '/';
 228:	00190a93          	addi	s5,s2,1
 22c:	02f00793          	li	a5,47
 230:	00f90023          	sb	a5,0(s2)
            if (de.name[0] == '.' && (de.name[1] == '\0' || (de.name[1] == '.' && de.name[2] == '\0'))) continue;
 234:	02e00a13          	li	s4,46
                printf("find: cannot stat %s\n", buf);
 238:	00001b17          	auipc	s6,0x1
 23c:	898b0b13          	addi	s6,s6,-1896 # ad0 <malloc+0x102>
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 240:	a891                	j	294 <find+0x190>
            printf("find: path too long\n");
 242:	00001517          	auipc	a0,0x1
 246:	8ae50513          	addi	a0,a0,-1874 # af0 <malloc+0x122>
 24a:	00000097          	auipc	ra,0x0
 24e:	6c6080e7          	jalr	1734(ra) # 910 <printf>
            close(fd);
 252:	8526                	mv	a0,s1
 254:	00000097          	auipc	ra,0x0
 258:	364080e7          	jalr	868(ra) # 5b8 <close>
            return;
 25c:	bf09                	j	16e <find+0x6a>
            memmove(p, de.name, DIRSIZ);
 25e:	4639                	li	a2,14
 260:	db240593          	addi	a1,s0,-590
 264:	8556                	mv	a0,s5
 266:	00000097          	auipc	ra,0x0
 26a:	274080e7          	jalr	628(ra) # 4da <memmove>
            p[DIRSIZ] = '\0';
 26e:	000907a3          	sb	zero,15(s2)
            if (stat(buf, &st) < 0) {
 272:	d9840593          	addi	a1,s0,-616
 276:	dc040513          	addi	a0,s0,-576
 27a:	00000097          	auipc	ra,0x0
 27e:	1d0080e7          	jalr	464(ra) # 44a <stat>
 282:	04054463          	bltz	a0,2ca <find+0x1c6>
            find(buf, name);
 286:	85ce                	mv	a1,s3
 288:	dc040513          	addi	a0,s0,-576
 28c:	00000097          	auipc	ra,0x0
 290:	e78080e7          	jalr	-392(ra) # 104 <find>
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 294:	4641                	li	a2,16
 296:	db040593          	addi	a1,s0,-592
 29a:	8526                	mv	a0,s1
 29c:	00000097          	auipc	ra,0x0
 2a0:	30c080e7          	jalr	780(ra) # 5a8 <read>
 2a4:	47c1                	li	a5,16
 2a6:	eaf51fe3          	bne	a0,a5,164 <find+0x60>
            if (de.inum == 0) continue;
 2aa:	db045783          	lhu	a5,-592(s0)
 2ae:	d3fd                	beqz	a5,294 <find+0x190>
            if (de.name[0] == '.' && (de.name[1] == '\0' || (de.name[1] == '.' && de.name[2] == '\0'))) continue;
 2b0:	db244783          	lbu	a5,-590(s0)
 2b4:	fb4795e3          	bne	a5,s4,25e <find+0x15a>
 2b8:	db344783          	lbu	a5,-589(s0)
 2bc:	dfe1                	beqz	a5,294 <find+0x190>
 2be:	fb4790e3          	bne	a5,s4,25e <find+0x15a>
 2c2:	db444783          	lbu	a5,-588(s0)
 2c6:	ffc1                	bnez	a5,25e <find+0x15a>
 2c8:	b7f1                	j	294 <find+0x190>
                printf("find: cannot stat %s\n", buf);
 2ca:	dc040593          	addi	a1,s0,-576
 2ce:	855a                	mv	a0,s6
 2d0:	00000097          	auipc	ra,0x0
 2d4:	640080e7          	jalr	1600(ra) # 910 <printf>
                continue;
 2d8:	bf75                	j	294 <find+0x190>

00000000000002da <main>:

int main(int argc, char* argv[]) {
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
    if (argc < 3) {
 2e2:	4709                	li	a4,2
 2e4:	00a74f63          	blt	a4,a0,302 <main+0x28>
        // 检查参数数量
        printf("Usage: find [path] [filename]\n");
 2e8:	00001517          	auipc	a0,0x1
 2ec:	82050513          	addi	a0,a0,-2016 # b08 <malloc+0x13a>
 2f0:	00000097          	auipc	ra,0x0
 2f4:	620080e7          	jalr	1568(ra) # 910 <printf>
        exit(-1);
 2f8:	557d                	li	a0,-1
 2fa:	00000097          	auipc	ra,0x0
 2fe:	296080e7          	jalr	662(ra) # 590 <exit>
 302:	87ae                	mv	a5,a1
    }
    // 调用find函数开始查找
    find(argv[1], argv[2]);
 304:	698c                	ld	a1,16(a1)
 306:	6788                	ld	a0,8(a5)
 308:	00000097          	auipc	ra,0x0
 30c:	dfc080e7          	jalr	-516(ra) # 104 <find>
    exit(0);
 310:	4501                	li	a0,0
 312:	00000097          	auipc	ra,0x0
 316:	27e080e7          	jalr	638(ra) # 590 <exit>

000000000000031a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 320:	87aa                	mv	a5,a0
 322:	0585                	addi	a1,a1,1
 324:	0785                	addi	a5,a5,1
 326:	fff5c703          	lbu	a4,-1(a1)
 32a:	fee78fa3          	sb	a4,-1(a5)
 32e:	fb75                	bnez	a4,322 <strcpy+0x8>
    ;
  return os;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 336:	1141                	addi	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 33c:	00054783          	lbu	a5,0(a0)
 340:	cb91                	beqz	a5,354 <strcmp+0x1e>
 342:	0005c703          	lbu	a4,0(a1)
 346:	00f71763          	bne	a4,a5,354 <strcmp+0x1e>
    p++, q++;
 34a:	0505                	addi	a0,a0,1
 34c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 34e:	00054783          	lbu	a5,0(a0)
 352:	fbe5                	bnez	a5,342 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 354:	0005c503          	lbu	a0,0(a1)
}
 358:	40a7853b          	subw	a0,a5,a0
 35c:	6422                	ld	s0,8(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret

0000000000000362 <strlen>:

uint
strlen(const char *s)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 368:	00054783          	lbu	a5,0(a0)
 36c:	cf91                	beqz	a5,388 <strlen+0x26>
 36e:	0505                	addi	a0,a0,1
 370:	87aa                	mv	a5,a0
 372:	4685                	li	a3,1
 374:	9e89                	subw	a3,a3,a0
 376:	00f6853b          	addw	a0,a3,a5
 37a:	0785                	addi	a5,a5,1
 37c:	fff7c703          	lbu	a4,-1(a5)
 380:	fb7d                	bnez	a4,376 <strlen+0x14>
    ;
  return n;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
  for(n = 0; s[n]; n++)
 388:	4501                	li	a0,0
 38a:	bfe5                	j	382 <strlen+0x20>

000000000000038c <memset>:

void*
memset(void *dst, int c, uint n)
{
 38c:	1141                	addi	sp,sp,-16
 38e:	e422                	sd	s0,8(sp)
 390:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 392:	ce09                	beqz	a2,3ac <memset+0x20>
 394:	87aa                	mv	a5,a0
 396:	fff6071b          	addiw	a4,a2,-1
 39a:	1702                	slli	a4,a4,0x20
 39c:	9301                	srli	a4,a4,0x20
 39e:	0705                	addi	a4,a4,1
 3a0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a6:	0785                	addi	a5,a5,1
 3a8:	fee79de3          	bne	a5,a4,3a2 <memset+0x16>
  }
  return dst;
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret

00000000000003b2 <strchr>:

char*
strchr(const char *s, char c)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	cb99                	beqz	a5,3d2 <strchr+0x20>
    if(*s == c)
 3be:	00f58763          	beq	a1,a5,3cc <strchr+0x1a>
  for(; *s; s++)
 3c2:	0505                	addi	a0,a0,1
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	fbfd                	bnez	a5,3be <strchr+0xc>
      return (char*)s;
  return 0;
 3ca:	4501                	li	a0,0
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret
  return 0;
 3d2:	4501                	li	a0,0
 3d4:	bfe5                	j	3cc <strchr+0x1a>

00000000000003d6 <gets>:

char*
gets(char *buf, int max)
{
 3d6:	711d                	addi	sp,sp,-96
 3d8:	ec86                	sd	ra,88(sp)
 3da:	e8a2                	sd	s0,80(sp)
 3dc:	e4a6                	sd	s1,72(sp)
 3de:	e0ca                	sd	s2,64(sp)
 3e0:	fc4e                	sd	s3,56(sp)
 3e2:	f852                	sd	s4,48(sp)
 3e4:	f456                	sd	s5,40(sp)
 3e6:	f05a                	sd	s6,32(sp)
 3e8:	ec5e                	sd	s7,24(sp)
 3ea:	1080                	addi	s0,sp,96
 3ec:	8baa                	mv	s7,a0
 3ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f0:	892a                	mv	s2,a0
 3f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f4:	4aa9                	li	s5,10
 3f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3f8:	89a6                	mv	s3,s1
 3fa:	2485                	addiw	s1,s1,1
 3fc:	0344d863          	bge	s1,s4,42c <gets+0x56>
    cc = read(0, &c, 1);
 400:	4605                	li	a2,1
 402:	faf40593          	addi	a1,s0,-81
 406:	4501                	li	a0,0
 408:	00000097          	auipc	ra,0x0
 40c:	1a0080e7          	jalr	416(ra) # 5a8 <read>
    if(cc < 1)
 410:	00a05e63          	blez	a0,42c <gets+0x56>
    buf[i++] = c;
 414:	faf44783          	lbu	a5,-81(s0)
 418:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 41c:	01578763          	beq	a5,s5,42a <gets+0x54>
 420:	0905                	addi	s2,s2,1
 422:	fd679be3          	bne	a5,s6,3f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 426:	89a6                	mv	s3,s1
 428:	a011                	j	42c <gets+0x56>
 42a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 42c:	99de                	add	s3,s3,s7
 42e:	00098023          	sb	zero,0(s3)
  return buf;
}
 432:	855e                	mv	a0,s7
 434:	60e6                	ld	ra,88(sp)
 436:	6446                	ld	s0,80(sp)
 438:	64a6                	ld	s1,72(sp)
 43a:	6906                	ld	s2,64(sp)
 43c:	79e2                	ld	s3,56(sp)
 43e:	7a42                	ld	s4,48(sp)
 440:	7aa2                	ld	s5,40(sp)
 442:	7b02                	ld	s6,32(sp)
 444:	6be2                	ld	s7,24(sp)
 446:	6125                	addi	sp,sp,96
 448:	8082                	ret

000000000000044a <stat>:

int
stat(const char *n, struct stat *st)
{
 44a:	1101                	addi	sp,sp,-32
 44c:	ec06                	sd	ra,24(sp)
 44e:	e822                	sd	s0,16(sp)
 450:	e426                	sd	s1,8(sp)
 452:	e04a                	sd	s2,0(sp)
 454:	1000                	addi	s0,sp,32
 456:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 458:	4581                	li	a1,0
 45a:	00000097          	auipc	ra,0x0
 45e:	176080e7          	jalr	374(ra) # 5d0 <open>
  if(fd < 0)
 462:	02054563          	bltz	a0,48c <stat+0x42>
 466:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 468:	85ca                	mv	a1,s2
 46a:	00000097          	auipc	ra,0x0
 46e:	17e080e7          	jalr	382(ra) # 5e8 <fstat>
 472:	892a                	mv	s2,a0
  close(fd);
 474:	8526                	mv	a0,s1
 476:	00000097          	auipc	ra,0x0
 47a:	142080e7          	jalr	322(ra) # 5b8 <close>
  return r;
}
 47e:	854a                	mv	a0,s2
 480:	60e2                	ld	ra,24(sp)
 482:	6442                	ld	s0,16(sp)
 484:	64a2                	ld	s1,8(sp)
 486:	6902                	ld	s2,0(sp)
 488:	6105                	addi	sp,sp,32
 48a:	8082                	ret
    return -1;
 48c:	597d                	li	s2,-1
 48e:	bfc5                	j	47e <stat+0x34>

0000000000000490 <atoi>:

int
atoi(const char *s)
{
 490:	1141                	addi	sp,sp,-16
 492:	e422                	sd	s0,8(sp)
 494:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 496:	00054603          	lbu	a2,0(a0)
 49a:	fd06079b          	addiw	a5,a2,-48
 49e:	0ff7f793          	andi	a5,a5,255
 4a2:	4725                	li	a4,9
 4a4:	02f76963          	bltu	a4,a5,4d6 <atoi+0x46>
 4a8:	86aa                	mv	a3,a0
  n = 0;
 4aa:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4ac:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ae:	0685                	addi	a3,a3,1
 4b0:	0025179b          	slliw	a5,a0,0x2
 4b4:	9fa9                	addw	a5,a5,a0
 4b6:	0017979b          	slliw	a5,a5,0x1
 4ba:	9fb1                	addw	a5,a5,a2
 4bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4c0:	0006c603          	lbu	a2,0(a3)
 4c4:	fd06071b          	addiw	a4,a2,-48
 4c8:	0ff77713          	andi	a4,a4,255
 4cc:	fee5f1e3          	bgeu	a1,a4,4ae <atoi+0x1e>
  return n;
}
 4d0:	6422                	ld	s0,8(sp)
 4d2:	0141                	addi	sp,sp,16
 4d4:	8082                	ret
  n = 0;
 4d6:	4501                	li	a0,0
 4d8:	bfe5                	j	4d0 <atoi+0x40>

00000000000004da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e422                	sd	s0,8(sp)
 4de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4e0:	02b57663          	bgeu	a0,a1,50c <memmove+0x32>
    while(n-- > 0)
 4e4:	02c05163          	blez	a2,506 <memmove+0x2c>
 4e8:	fff6079b          	addiw	a5,a2,-1
 4ec:	1782                	slli	a5,a5,0x20
 4ee:	9381                	srli	a5,a5,0x20
 4f0:	0785                	addi	a5,a5,1
 4f2:	97aa                	add	a5,a5,a0
  dst = vdst;
 4f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 4f6:	0585                	addi	a1,a1,1
 4f8:	0705                	addi	a4,a4,1
 4fa:	fff5c683          	lbu	a3,-1(a1)
 4fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 502:	fee79ae3          	bne	a5,a4,4f6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 506:	6422                	ld	s0,8(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret
    dst += n;
 50c:	00c50733          	add	a4,a0,a2
    src += n;
 510:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 512:	fec05ae3          	blez	a2,506 <memmove+0x2c>
 516:	fff6079b          	addiw	a5,a2,-1
 51a:	1782                	slli	a5,a5,0x20
 51c:	9381                	srli	a5,a5,0x20
 51e:	fff7c793          	not	a5,a5
 522:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 524:	15fd                	addi	a1,a1,-1
 526:	177d                	addi	a4,a4,-1
 528:	0005c683          	lbu	a3,0(a1)
 52c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 530:	fee79ae3          	bne	a5,a4,524 <memmove+0x4a>
 534:	bfc9                	j	506 <memmove+0x2c>

0000000000000536 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 536:	1141                	addi	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 53c:	ca05                	beqz	a2,56c <memcmp+0x36>
 53e:	fff6069b          	addiw	a3,a2,-1
 542:	1682                	slli	a3,a3,0x20
 544:	9281                	srli	a3,a3,0x20
 546:	0685                	addi	a3,a3,1
 548:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 54a:	00054783          	lbu	a5,0(a0)
 54e:	0005c703          	lbu	a4,0(a1)
 552:	00e79863          	bne	a5,a4,562 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 556:	0505                	addi	a0,a0,1
    p2++;
 558:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 55a:	fed518e3          	bne	a0,a3,54a <memcmp+0x14>
  }
  return 0;
 55e:	4501                	li	a0,0
 560:	a019                	j	566 <memcmp+0x30>
      return *p1 - *p2;
 562:	40e7853b          	subw	a0,a5,a4
}
 566:	6422                	ld	s0,8(sp)
 568:	0141                	addi	sp,sp,16
 56a:	8082                	ret
  return 0;
 56c:	4501                	li	a0,0
 56e:	bfe5                	j	566 <memcmp+0x30>

0000000000000570 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 570:	1141                	addi	sp,sp,-16
 572:	e406                	sd	ra,8(sp)
 574:	e022                	sd	s0,0(sp)
 576:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 578:	00000097          	auipc	ra,0x0
 57c:	f62080e7          	jalr	-158(ra) # 4da <memmove>
}
 580:	60a2                	ld	ra,8(sp)
 582:	6402                	ld	s0,0(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret

0000000000000588 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 588:	4885                	li	a7,1
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <exit>:
.global exit
exit:
 li a7, SYS_exit
 590:	4889                	li	a7,2
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <wait>:
.global wait
wait:
 li a7, SYS_wait
 598:	488d                	li	a7,3
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5a0:	4891                	li	a7,4
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <read>:
.global read
read:
 li a7, SYS_read
 5a8:	4895                	li	a7,5
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <write>:
.global write
write:
 li a7, SYS_write
 5b0:	48c1                	li	a7,16
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <close>:
.global close
close:
 li a7, SYS_close
 5b8:	48d5                	li	a7,21
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5c0:	4899                	li	a7,6
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5c8:	489d                	li	a7,7
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <open>:
.global open
open:
 li a7, SYS_open
 5d0:	48bd                	li	a7,15
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5d8:	48c5                	li	a7,17
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5e0:	48c9                	li	a7,18
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5e8:	48a1                	li	a7,8
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <link>:
.global link
link:
 li a7, SYS_link
 5f0:	48cd                	li	a7,19
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5f8:	48d1                	li	a7,20
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 600:	48a5                	li	a7,9
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <dup>:
.global dup
dup:
 li a7, SYS_dup
 608:	48a9                	li	a7,10
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 610:	48ad                	li	a7,11
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 618:	48b1                	li	a7,12
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 620:	48b5                	li	a7,13
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 628:	48b9                	li	a7,14
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <trace>:
.global trace
trace:
 li a7, SYS_trace
 630:	48d9                	li	a7,22
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 638:	1101                	addi	sp,sp,-32
 63a:	ec06                	sd	ra,24(sp)
 63c:	e822                	sd	s0,16(sp)
 63e:	1000                	addi	s0,sp,32
 640:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 644:	4605                	li	a2,1
 646:	fef40593          	addi	a1,s0,-17
 64a:	00000097          	auipc	ra,0x0
 64e:	f66080e7          	jalr	-154(ra) # 5b0 <write>
}
 652:	60e2                	ld	ra,24(sp)
 654:	6442                	ld	s0,16(sp)
 656:	6105                	addi	sp,sp,32
 658:	8082                	ret

000000000000065a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65a:	7139                	addi	sp,sp,-64
 65c:	fc06                	sd	ra,56(sp)
 65e:	f822                	sd	s0,48(sp)
 660:	f426                	sd	s1,40(sp)
 662:	f04a                	sd	s2,32(sp)
 664:	ec4e                	sd	s3,24(sp)
 666:	0080                	addi	s0,sp,64
 668:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66a:	c299                	beqz	a3,670 <printint+0x16>
 66c:	0805c863          	bltz	a1,6fc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 670:	2581                	sext.w	a1,a1
  neg = 0;
 672:	4881                	li	a7,0
 674:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 678:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67a:	2601                	sext.w	a2,a2
 67c:	00000517          	auipc	a0,0x0
 680:	4b450513          	addi	a0,a0,1204 # b30 <digits>
 684:	883a                	mv	a6,a4
 686:	2705                	addiw	a4,a4,1
 688:	02c5f7bb          	remuw	a5,a1,a2
 68c:	1782                	slli	a5,a5,0x20
 68e:	9381                	srli	a5,a5,0x20
 690:	97aa                	add	a5,a5,a0
 692:	0007c783          	lbu	a5,0(a5)
 696:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69a:	0005879b          	sext.w	a5,a1
 69e:	02c5d5bb          	divuw	a1,a1,a2
 6a2:	0685                	addi	a3,a3,1
 6a4:	fec7f0e3          	bgeu	a5,a2,684 <printint+0x2a>
  if(neg)
 6a8:	00088b63          	beqz	a7,6be <printint+0x64>
    buf[i++] = '-';
 6ac:	fd040793          	addi	a5,s0,-48
 6b0:	973e                	add	a4,a4,a5
 6b2:	02d00793          	li	a5,45
 6b6:	fef70823          	sb	a5,-16(a4)
 6ba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6be:	02e05863          	blez	a4,6ee <printint+0x94>
 6c2:	fc040793          	addi	a5,s0,-64
 6c6:	00e78933          	add	s2,a5,a4
 6ca:	fff78993          	addi	s3,a5,-1
 6ce:	99ba                	add	s3,s3,a4
 6d0:	377d                	addiw	a4,a4,-1
 6d2:	1702                	slli	a4,a4,0x20
 6d4:	9301                	srli	a4,a4,0x20
 6d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6da:	fff94583          	lbu	a1,-1(s2)
 6de:	8526                	mv	a0,s1
 6e0:	00000097          	auipc	ra,0x0
 6e4:	f58080e7          	jalr	-168(ra) # 638 <putc>
  while(--i >= 0)
 6e8:	197d                	addi	s2,s2,-1
 6ea:	ff3918e3          	bne	s2,s3,6da <printint+0x80>
}
 6ee:	70e2                	ld	ra,56(sp)
 6f0:	7442                	ld	s0,48(sp)
 6f2:	74a2                	ld	s1,40(sp)
 6f4:	7902                	ld	s2,32(sp)
 6f6:	69e2                	ld	s3,24(sp)
 6f8:	6121                	addi	sp,sp,64
 6fa:	8082                	ret
    x = -xx;
 6fc:	40b005bb          	negw	a1,a1
    neg = 1;
 700:	4885                	li	a7,1
    x = -xx;
 702:	bf8d                	j	674 <printint+0x1a>

0000000000000704 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 704:	7119                	addi	sp,sp,-128
 706:	fc86                	sd	ra,120(sp)
 708:	f8a2                	sd	s0,112(sp)
 70a:	f4a6                	sd	s1,104(sp)
 70c:	f0ca                	sd	s2,96(sp)
 70e:	ecce                	sd	s3,88(sp)
 710:	e8d2                	sd	s4,80(sp)
 712:	e4d6                	sd	s5,72(sp)
 714:	e0da                	sd	s6,64(sp)
 716:	fc5e                	sd	s7,56(sp)
 718:	f862                	sd	s8,48(sp)
 71a:	f466                	sd	s9,40(sp)
 71c:	f06a                	sd	s10,32(sp)
 71e:	ec6e                	sd	s11,24(sp)
 720:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 722:	0005c903          	lbu	s2,0(a1)
 726:	18090f63          	beqz	s2,8c4 <vprintf+0x1c0>
 72a:	8aaa                	mv	s5,a0
 72c:	8b32                	mv	s6,a2
 72e:	00158493          	addi	s1,a1,1
  state = 0;
 732:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 734:	02500a13          	li	s4,37
      if(c == 'd'){
 738:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 73c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 740:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 744:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 748:	00000b97          	auipc	s7,0x0
 74c:	3e8b8b93          	addi	s7,s7,1000 # b30 <digits>
 750:	a839                	j	76e <vprintf+0x6a>
        putc(fd, c);
 752:	85ca                	mv	a1,s2
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	ee2080e7          	jalr	-286(ra) # 638 <putc>
 75e:	a019                	j	764 <vprintf+0x60>
    } else if(state == '%'){
 760:	01498f63          	beq	s3,s4,77e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 764:	0485                	addi	s1,s1,1
 766:	fff4c903          	lbu	s2,-1(s1)
 76a:	14090d63          	beqz	s2,8c4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 76e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 772:	fe0997e3          	bnez	s3,760 <vprintf+0x5c>
      if(c == '%'){
 776:	fd479ee3          	bne	a5,s4,752 <vprintf+0x4e>
        state = '%';
 77a:	89be                	mv	s3,a5
 77c:	b7e5                	j	764 <vprintf+0x60>
      if(c == 'd'){
 77e:	05878063          	beq	a5,s8,7be <vprintf+0xba>
      } else if(c == 'l') {
 782:	05978c63          	beq	a5,s9,7da <vprintf+0xd6>
      } else if(c == 'x') {
 786:	07a78863          	beq	a5,s10,7f6 <vprintf+0xf2>
      } else if(c == 'p') {
 78a:	09b78463          	beq	a5,s11,812 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 78e:	07300713          	li	a4,115
 792:	0ce78663          	beq	a5,a4,85e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 796:	06300713          	li	a4,99
 79a:	0ee78e63          	beq	a5,a4,896 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 79e:	11478863          	beq	a5,s4,8ae <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a2:	85d2                	mv	a1,s4
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e92080e7          	jalr	-366(ra) # 638 <putc>
        putc(fd, c);
 7ae:	85ca                	mv	a1,s2
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	e86080e7          	jalr	-378(ra) # 638 <putc>
      }
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b765                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7be:	008b0913          	addi	s2,s6,8
 7c2:	4685                	li	a3,1
 7c4:	4629                	li	a2,10
 7c6:	000b2583          	lw	a1,0(s6)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e8e080e7          	jalr	-370(ra) # 65a <printint>
 7d4:	8b4a                	mv	s6,s2
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b771                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7da:	008b0913          	addi	s2,s6,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000b2583          	lw	a1,0(s6)
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	e72080e7          	jalr	-398(ra) # 65a <printint>
 7f0:	8b4a                	mv	s6,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bf85                	j	764 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7f6:	008b0913          	addi	s2,s6,8
 7fa:	4681                	li	a3,0
 7fc:	4641                	li	a2,16
 7fe:	000b2583          	lw	a1,0(s6)
 802:	8556                	mv	a0,s5
 804:	00000097          	auipc	ra,0x0
 808:	e56080e7          	jalr	-426(ra) # 65a <printint>
 80c:	8b4a                	mv	s6,s2
      state = 0;
 80e:	4981                	li	s3,0
 810:	bf91                	j	764 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 812:	008b0793          	addi	a5,s6,8
 816:	f8f43423          	sd	a5,-120(s0)
 81a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 81e:	03000593          	li	a1,48
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e14080e7          	jalr	-492(ra) # 638 <putc>
  putc(fd, 'x');
 82c:	85ea                	mv	a1,s10
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	e08080e7          	jalr	-504(ra) # 638 <putc>
 838:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83a:	03c9d793          	srli	a5,s3,0x3c
 83e:	97de                	add	a5,a5,s7
 840:	0007c583          	lbu	a1,0(a5)
 844:	8556                	mv	a0,s5
 846:	00000097          	auipc	ra,0x0
 84a:	df2080e7          	jalr	-526(ra) # 638 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 84e:	0992                	slli	s3,s3,0x4
 850:	397d                	addiw	s2,s2,-1
 852:	fe0914e3          	bnez	s2,83a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 856:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 85a:	4981                	li	s3,0
 85c:	b721                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 85e:	008b0993          	addi	s3,s6,8
 862:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 866:	02090163          	beqz	s2,888 <vprintf+0x184>
        while(*s != 0){
 86a:	00094583          	lbu	a1,0(s2)
 86e:	c9a1                	beqz	a1,8be <vprintf+0x1ba>
          putc(fd, *s);
 870:	8556                	mv	a0,s5
 872:	00000097          	auipc	ra,0x0
 876:	dc6080e7          	jalr	-570(ra) # 638 <putc>
          s++;
 87a:	0905                	addi	s2,s2,1
        while(*s != 0){
 87c:	00094583          	lbu	a1,0(s2)
 880:	f9e5                	bnez	a1,870 <vprintf+0x16c>
        s = va_arg(ap, char*);
 882:	8b4e                	mv	s6,s3
      state = 0;
 884:	4981                	li	s3,0
 886:	bdf9                	j	764 <vprintf+0x60>
          s = "(null)";
 888:	00000917          	auipc	s2,0x0
 88c:	2a090913          	addi	s2,s2,672 # b28 <malloc+0x15a>
        while(*s != 0){
 890:	02800593          	li	a1,40
 894:	bff1                	j	870 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 896:	008b0913          	addi	s2,s6,8
 89a:	000b4583          	lbu	a1,0(s6)
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d98080e7          	jalr	-616(ra) # 638 <putc>
 8a8:	8b4a                	mv	s6,s2
      state = 0;
 8aa:	4981                	li	s3,0
 8ac:	bd65                	j	764 <vprintf+0x60>
        putc(fd, c);
 8ae:	85d2                	mv	a1,s4
 8b0:	8556                	mv	a0,s5
 8b2:	00000097          	auipc	ra,0x0
 8b6:	d86080e7          	jalr	-634(ra) # 638 <putc>
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b565                	j	764 <vprintf+0x60>
        s = va_arg(ap, char*);
 8be:	8b4e                	mv	s6,s3
      state = 0;
 8c0:	4981                	li	s3,0
 8c2:	b54d                	j	764 <vprintf+0x60>
    }
  }
}
 8c4:	70e6                	ld	ra,120(sp)
 8c6:	7446                	ld	s0,112(sp)
 8c8:	74a6                	ld	s1,104(sp)
 8ca:	7906                	ld	s2,96(sp)
 8cc:	69e6                	ld	s3,88(sp)
 8ce:	6a46                	ld	s4,80(sp)
 8d0:	6aa6                	ld	s5,72(sp)
 8d2:	6b06                	ld	s6,64(sp)
 8d4:	7be2                	ld	s7,56(sp)
 8d6:	7c42                	ld	s8,48(sp)
 8d8:	7ca2                	ld	s9,40(sp)
 8da:	7d02                	ld	s10,32(sp)
 8dc:	6de2                	ld	s11,24(sp)
 8de:	6109                	addi	sp,sp,128
 8e0:	8082                	ret

00000000000008e2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e2:	715d                	addi	sp,sp,-80
 8e4:	ec06                	sd	ra,24(sp)
 8e6:	e822                	sd	s0,16(sp)
 8e8:	1000                	addi	s0,sp,32
 8ea:	e010                	sd	a2,0(s0)
 8ec:	e414                	sd	a3,8(s0)
 8ee:	e818                	sd	a4,16(s0)
 8f0:	ec1c                	sd	a5,24(s0)
 8f2:	03043023          	sd	a6,32(s0)
 8f6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8fe:	8622                	mv	a2,s0
 900:	00000097          	auipc	ra,0x0
 904:	e04080e7          	jalr	-508(ra) # 704 <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6161                	addi	sp,sp,80
 90e:	8082                	ret

0000000000000910 <printf>:

void
printf(const char *fmt, ...)
{
 910:	711d                	addi	sp,sp,-96
 912:	ec06                	sd	ra,24(sp)
 914:	e822                	sd	s0,16(sp)
 916:	1000                	addi	s0,sp,32
 918:	e40c                	sd	a1,8(s0)
 91a:	e810                	sd	a2,16(s0)
 91c:	ec14                	sd	a3,24(s0)
 91e:	f018                	sd	a4,32(s0)
 920:	f41c                	sd	a5,40(s0)
 922:	03043823          	sd	a6,48(s0)
 926:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92a:	00840613          	addi	a2,s0,8
 92e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 932:	85aa                	mv	a1,a0
 934:	4505                	li	a0,1
 936:	00000097          	auipc	ra,0x0
 93a:	dce080e7          	jalr	-562(ra) # 704 <vprintf>
}
 93e:	60e2                	ld	ra,24(sp)
 940:	6442                	ld	s0,16(sp)
 942:	6125                	addi	sp,sp,96
 944:	8082                	ret

0000000000000946 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 946:	1141                	addi	sp,sp,-16
 948:	e422                	sd	s0,8(sp)
 94a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 94c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 950:	00000797          	auipc	a5,0x0
 954:	1f87b783          	ld	a5,504(a5) # b48 <freep>
 958:	a805                	j	988 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95a:	4618                	lw	a4,8(a2)
 95c:	9db9                	addw	a1,a1,a4
 95e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 962:	6398                	ld	a4,0(a5)
 964:	6318                	ld	a4,0(a4)
 966:	fee53823          	sd	a4,-16(a0)
 96a:	a091                	j	9ae <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 96c:	ff852703          	lw	a4,-8(a0)
 970:	9e39                	addw	a2,a2,a4
 972:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 974:	ff053703          	ld	a4,-16(a0)
 978:	e398                	sd	a4,0(a5)
 97a:	a099                	j	9c0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	6398                	ld	a4,0(a5)
 97e:	00e7e463          	bltu	a5,a4,986 <free+0x40>
 982:	00e6ea63          	bltu	a3,a4,996 <free+0x50>
{
 986:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 988:	fed7fae3          	bgeu	a5,a3,97c <free+0x36>
 98c:	6398                	ld	a4,0(a5)
 98e:	00e6e463          	bltu	a3,a4,996 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 992:	fee7eae3          	bltu	a5,a4,986 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 996:	ff852583          	lw	a1,-8(a0)
 99a:	6390                	ld	a2,0(a5)
 99c:	02059713          	slli	a4,a1,0x20
 9a0:	9301                	srli	a4,a4,0x20
 9a2:	0712                	slli	a4,a4,0x4
 9a4:	9736                	add	a4,a4,a3
 9a6:	fae60ae3          	beq	a2,a4,95a <free+0x14>
    bp->s.ptr = p->s.ptr;
 9aa:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9ae:	4790                	lw	a2,8(a5)
 9b0:	02061713          	slli	a4,a2,0x20
 9b4:	9301                	srli	a4,a4,0x20
 9b6:	0712                	slli	a4,a4,0x4
 9b8:	973e                	add	a4,a4,a5
 9ba:	fae689e3          	beq	a3,a4,96c <free+0x26>
  } else
    p->s.ptr = bp;
 9be:	e394                	sd	a3,0(a5)
  freep = p;
 9c0:	00000717          	auipc	a4,0x0
 9c4:	18f73423          	sd	a5,392(a4) # b48 <freep>
}
 9c8:	6422                	ld	s0,8(sp)
 9ca:	0141                	addi	sp,sp,16
 9cc:	8082                	ret

00000000000009ce <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ce:	7139                	addi	sp,sp,-64
 9d0:	fc06                	sd	ra,56(sp)
 9d2:	f822                	sd	s0,48(sp)
 9d4:	f426                	sd	s1,40(sp)
 9d6:	f04a                	sd	s2,32(sp)
 9d8:	ec4e                	sd	s3,24(sp)
 9da:	e852                	sd	s4,16(sp)
 9dc:	e456                	sd	s5,8(sp)
 9de:	e05a                	sd	s6,0(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	slli	s1,a0,0x20
 9e6:	9081                	srli	s1,s1,0x20
 9e8:	04bd                	addi	s1,s1,15
 9ea:	8091                	srli	s1,s1,0x4
 9ec:	0014899b          	addiw	s3,s1,1
 9f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00000517          	auipc	a0,0x0
 9f6:	15653503          	ld	a0,342(a0) # b48 <freep>
 9fa:	c515                	beqz	a0,a26 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	02977f63          	bgeu	a4,s1,a3e <malloc+0x70>
 a04:	8a4e                	mv	s4,s3
 a06:	0009871b          	sext.w	a4,s3
 a0a:	6685                	lui	a3,0x1
 a0c:	00d77363          	bgeu	a4,a3,a12 <malloc+0x44>
 a10:	6a05                	lui	s4,0x1
 a12:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a16:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1a:	00000917          	auipc	s2,0x0
 a1e:	12e90913          	addi	s2,s2,302 # b48 <freep>
  if(p == (char*)-1)
 a22:	5afd                	li	s5,-1
 a24:	a88d                	j	a96 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a26:	00000797          	auipc	a5,0x0
 a2a:	13a78793          	addi	a5,a5,314 # b60 <base>
 a2e:	00000717          	auipc	a4,0x0
 a32:	10f73d23          	sd	a5,282(a4) # b48 <freep>
 a36:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a38:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a3c:	b7e1                	j	a04 <malloc+0x36>
      if(p->s.size == nunits)
 a3e:	02e48b63          	beq	s1,a4,a74 <malloc+0xa6>
        p->s.size -= nunits;
 a42:	4137073b          	subw	a4,a4,s3
 a46:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a48:	1702                	slli	a4,a4,0x20
 a4a:	9301                	srli	a4,a4,0x20
 a4c:	0712                	slli	a4,a4,0x4
 a4e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a50:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a54:	00000717          	auipc	a4,0x0
 a58:	0ea73a23          	sd	a0,244(a4) # b48 <freep>
      return (void*)(p + 1);
 a5c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a60:	70e2                	ld	ra,56(sp)
 a62:	7442                	ld	s0,48(sp)
 a64:	74a2                	ld	s1,40(sp)
 a66:	7902                	ld	s2,32(sp)
 a68:	69e2                	ld	s3,24(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
 a70:	6121                	addi	sp,sp,64
 a72:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a74:	6398                	ld	a4,0(a5)
 a76:	e118                	sd	a4,0(a0)
 a78:	bff1                	j	a54 <malloc+0x86>
  hp->s.size = nu;
 a7a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a7e:	0541                	addi	a0,a0,16
 a80:	00000097          	auipc	ra,0x0
 a84:	ec6080e7          	jalr	-314(ra) # 946 <free>
  return freep;
 a88:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a8c:	d971                	beqz	a0,a60 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a90:	4798                	lw	a4,8(a5)
 a92:	fa9776e3          	bgeu	a4,s1,a3e <malloc+0x70>
    if(p == freep)
 a96:	00093703          	ld	a4,0(s2)
 a9a:	853e                	mv	a0,a5
 a9c:	fef719e3          	bne	a4,a5,a8e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aa0:	8552                	mv	a0,s4
 aa2:	00000097          	auipc	ra,0x0
 aa6:	b76080e7          	jalr	-1162(ra) # 618 <sbrk>
  if(p == (char*)-1)
 aaa:	fd5518e3          	bne	a0,s5,a7a <malloc+0xac>
        return 0;
 aae:	4501                	li	a0,0
 ab0:	bf45                	j	a60 <malloc+0x92>
