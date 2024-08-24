
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <prime>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void prime(int rd) {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	0880                	addi	s0,sp,80
   e:	892a                	mv	s2,a0
    int n;
    read(rd, &n, 4); // 把读取的内容放进n
  10:	4611                	li	a2,4
  12:	fcc40593          	addi	a1,s0,-52
  16:	00000097          	auipc	ra,0x0
  1a:	3f8080e7          	jalr	1016(ra) # 40e <read>
    printf("prime %d\n", n); // 输出当前的n
  1e:	fcc42583          	lw	a1,-52(s0)
  22:	00001517          	auipc	a0,0x1
  26:	8f650513          	addi	a0,a0,-1802 # 918 <malloc+0xe4>
  2a:	00000097          	auipc	ra,0x0
  2e:	74c080e7          	jalr	1868(ra) # 776 <printf>
    int created = 0; // 是否已创建管道
  32:	4481                	li	s1,0
void prime(int rd) {
  34:	4985                	li	s3,1
    int p[2];
    int num;

    while (read(rd, &num, 4) != 0) { // 用num存管道里在n之后的数
  36:	a891                	j	8a <prime+0x8a>
        if (created == 0) {
            pipe(p); // 创建对应于n的管道
  38:	fc040513          	addi	a0,s0,-64
  3c:	00000097          	auipc	ra,0x0
  40:	3ca080e7          	jalr	970(ra) # 406 <pipe>
            created = 1;
            int pid = fork(); // 创建子进程
  44:	00000097          	auipc	ra,0x0
  48:	3aa080e7          	jalr	938(ra) # 3ee <fork>
            if (pid == 0) { // 子进程
  4c:	c901                	beqz	a0,5c <prime+0x5c>
                close(p[1]);
                prime(p[0]); // 递归，判断子管道里的内容是不是质数
                return;
            } else { // 当前进程
                close(p[0]); // 关闭读取，允许写入
  4e:	fc042503          	lw	a0,-64(s0)
  52:	00000097          	auipc	ra,0x0
  56:	3cc080e7          	jalr	972(ra) # 41e <close>
  5a:	a091                	j	9e <prime+0x9e>
                close(p[1]);
  5c:	fc442503          	lw	a0,-60(s0)
  60:	00000097          	auipc	ra,0x0
  64:	3be080e7          	jalr	958(ra) # 41e <close>
                prime(p[0]); // 递归，判断子管道里的内容是不是质数
  68:	fc042503          	lw	a0,-64(s0)
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <prime>
                return;
  74:	a099                	j	ba <prime+0xba>
            }
        }
        if (num % n != 0) { // 如果num不是n的倍数，则它有可能是质数
            write(p[1], &num, 4); // 把它写入子管道
  76:	4611                	li	a2,4
  78:	fbc40593          	addi	a1,s0,-68
  7c:	fc442503          	lw	a0,-60(s0)
  80:	00000097          	auipc	ra,0x0
  84:	396080e7          	jalr	918(ra) # 416 <write>
void prime(int rd) {
  88:	84ce                	mv	s1,s3
    while (read(rd, &num, 4) != 0) { // 用num存管道里在n之后的数
  8a:	4611                	li	a2,4
  8c:	fbc40593          	addi	a1,s0,-68
  90:	854a                	mv	a0,s2
  92:	00000097          	auipc	ra,0x0
  96:	37c080e7          	jalr	892(ra) # 40e <read>
  9a:	c911                	beqz	a0,ae <prime+0xae>
        if (created == 0) {
  9c:	dcd1                	beqz	s1,38 <prime+0x38>
        if (num % n != 0) { // 如果num不是n的倍数，则它有可能是质数
  9e:	fbc42783          	lw	a5,-68(s0)
  a2:	fcc42703          	lw	a4,-52(s0)
  a6:	02e7e7bb          	remw	a5,a5,a4
  aa:	dff9                	beqz	a5,88 <prime+0x88>
  ac:	b7e9                	j	76 <prime+0x76>
        }
    }
    close(rd);
  ae:	854a                	mv	a0,s2
  b0:	00000097          	auipc	ra,0x0
  b4:	36e080e7          	jalr	878(ra) # 41e <close>
    if (created) {
  b8:	e881                	bnez	s1,c8 <prime+0xc8>
        close(p[1]);
        wait(0); // 等待子进程结束
    }
}
  ba:	60a6                	ld	ra,72(sp)
  bc:	6406                	ld	s0,64(sp)
  be:	74e2                	ld	s1,56(sp)
  c0:	7942                	ld	s2,48(sp)
  c2:	79a2                	ld	s3,40(sp)
  c4:	6161                	addi	sp,sp,80
  c6:	8082                	ret
        close(p[1]);
  c8:	fc442503          	lw	a0,-60(s0)
  cc:	00000097          	auipc	ra,0x0
  d0:	352080e7          	jalr	850(ra) # 41e <close>
        wait(0); // 等待子进程结束
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	328080e7          	jalr	808(ra) # 3fe <wait>
  de:	bff1                	j	ba <prime+0xba>

00000000000000e0 <main>:

int main(int argc, char *argv[]) {
  e0:	7179                	addi	sp,sp,-48
  e2:	f406                	sd	ra,40(sp)
  e4:	f022                	sd	s0,32(sp)
  e6:	ec26                	sd	s1,24(sp)
  e8:	1800                	addi	s0,sp,48
    int p[2];
    pipe(p); // 创建管道p
  ea:	fd840513          	addi	a0,s0,-40
  ee:	00000097          	auipc	ra,0x0
  f2:	318080e7          	jalr	792(ra) # 406 <pipe>
    int pid = fork();
  f6:	00000097          	auipc	ra,0x0
  fa:	2f8080e7          	jalr	760(ra) # 3ee <fork>
    if (pid != 0) { // 父进程
  fe:	cd31                	beqz	a0,15a <main+0x7a>
        close(p[0]); // 关闭p的读取。只有读取端关闭，才能进行写入
 100:	fd842503          	lw	a0,-40(s0)
 104:	00000097          	auipc	ra,0x0
 108:	31a080e7          	jalr	794(ra) # 41e <close>
        for (int i = 2; i <= 35; i++) {
 10c:	4789                	li	a5,2
 10e:	fcf42a23          	sw	a5,-44(s0)
 112:	02300493          	li	s1,35
            write(p[1], &i, 4); // 写入
 116:	4611                	li	a2,4
 118:	fd440593          	addi	a1,s0,-44
 11c:	fdc42503          	lw	a0,-36(s0)
 120:	00000097          	auipc	ra,0x0
 124:	2f6080e7          	jalr	758(ra) # 416 <write>
        for (int i = 2; i <= 35; i++) {
 128:	fd442783          	lw	a5,-44(s0)
 12c:	2785                	addiw	a5,a5,1
 12e:	0007871b          	sext.w	a4,a5
 132:	fcf42a23          	sw	a5,-44(s0)
 136:	fee4d0e3          	bge	s1,a4,116 <main+0x36>
        }
        close(p[1]); // 关闭p的写入
 13a:	fdc42503          	lw	a0,-36(s0)
 13e:	00000097          	auipc	ra,0x0
 142:	2e0080e7          	jalr	736(ra) # 41e <close>
        wait(0); // 等待子进程结束
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2b6080e7          	jalr	694(ra) # 3fe <wait>
    } else { // 子进程
        close(p[1]);
        prime(p[0]);
        close(p[0]);
    }
    exit(0);
 150:	4501                	li	a0,0
 152:	00000097          	auipc	ra,0x0
 156:	2a4080e7          	jalr	676(ra) # 3f6 <exit>
        close(p[1]);
 15a:	fdc42503          	lw	a0,-36(s0)
 15e:	00000097          	auipc	ra,0x0
 162:	2c0080e7          	jalr	704(ra) # 41e <close>
        prime(p[0]);
 166:	fd842503          	lw	a0,-40(s0)
 16a:	00000097          	auipc	ra,0x0
 16e:	e96080e7          	jalr	-362(ra) # 0 <prime>
        close(p[0]);
 172:	fd842503          	lw	a0,-40(s0)
 176:	00000097          	auipc	ra,0x0
 17a:	2a8080e7          	jalr	680(ra) # 41e <close>
 17e:	bfc9                	j	150 <main+0x70>

0000000000000180 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 186:	87aa                	mv	a5,a0
 188:	0585                	addi	a1,a1,1
 18a:	0785                	addi	a5,a5,1
 18c:	fff5c703          	lbu	a4,-1(a1)
 190:	fee78fa3          	sb	a4,-1(a5)
 194:	fb75                	bnez	a4,188 <strcpy+0x8>
    ;
  return os;
}
 196:	6422                	ld	s0,8(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cb91                	beqz	a5,1ba <strcmp+0x1e>
 1a8:	0005c703          	lbu	a4,0(a1)
 1ac:	00f71763          	bne	a4,a5,1ba <strcmp+0x1e>
    p++, q++;
 1b0:	0505                	addi	a0,a0,1
 1b2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b4:	00054783          	lbu	a5,0(a0)
 1b8:	fbe5                	bnez	a5,1a8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ba:	0005c503          	lbu	a0,0(a1)
}
 1be:	40a7853b          	subw	a0,a5,a0
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret

00000000000001c8 <strlen>:

uint
strlen(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cf91                	beqz	a5,1ee <strlen+0x26>
 1d4:	0505                	addi	a0,a0,1
 1d6:	87aa                	mv	a5,a0
 1d8:	4685                	li	a3,1
 1da:	9e89                	subw	a3,a3,a0
 1dc:	00f6853b          	addw	a0,a3,a5
 1e0:	0785                	addi	a5,a5,1
 1e2:	fff7c703          	lbu	a4,-1(a5)
 1e6:	fb7d                	bnez	a4,1dc <strlen+0x14>
    ;
  return n;
}
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret
  for(n = 0; s[n]; n++)
 1ee:	4501                	li	a0,0
 1f0:	bfe5                	j	1e8 <strlen+0x20>

00000000000001f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f8:	ce09                	beqz	a2,212 <memset+0x20>
 1fa:	87aa                	mv	a5,a0
 1fc:	fff6071b          	addiw	a4,a2,-1
 200:	1702                	slli	a4,a4,0x20
 202:	9301                	srli	a4,a4,0x20
 204:	0705                	addi	a4,a4,1
 206:	972a                	add	a4,a4,a0
    cdst[i] = c;
 208:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 20c:	0785                	addi	a5,a5,1
 20e:	fee79de3          	bne	a5,a4,208 <memset+0x16>
  }
  return dst;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret

0000000000000218 <strchr>:

char*
strchr(const char *s, char c)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e422                	sd	s0,8(sp)
 21c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 21e:	00054783          	lbu	a5,0(a0)
 222:	cb99                	beqz	a5,238 <strchr+0x20>
    if(*s == c)
 224:	00f58763          	beq	a1,a5,232 <strchr+0x1a>
  for(; *s; s++)
 228:	0505                	addi	a0,a0,1
 22a:	00054783          	lbu	a5,0(a0)
 22e:	fbfd                	bnez	a5,224 <strchr+0xc>
      return (char*)s;
  return 0;
 230:	4501                	li	a0,0
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
  return 0;
 238:	4501                	li	a0,0
 23a:	bfe5                	j	232 <strchr+0x1a>

000000000000023c <gets>:

char*
gets(char *buf, int max)
{
 23c:	711d                	addi	sp,sp,-96
 23e:	ec86                	sd	ra,88(sp)
 240:	e8a2                	sd	s0,80(sp)
 242:	e4a6                	sd	s1,72(sp)
 244:	e0ca                	sd	s2,64(sp)
 246:	fc4e                	sd	s3,56(sp)
 248:	f852                	sd	s4,48(sp)
 24a:	f456                	sd	s5,40(sp)
 24c:	f05a                	sd	s6,32(sp)
 24e:	ec5e                	sd	s7,24(sp)
 250:	1080                	addi	s0,sp,96
 252:	8baa                	mv	s7,a0
 254:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	892a                	mv	s2,a0
 258:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 25a:	4aa9                	li	s5,10
 25c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 25e:	89a6                	mv	s3,s1
 260:	2485                	addiw	s1,s1,1
 262:	0344d863          	bge	s1,s4,292 <gets+0x56>
    cc = read(0, &c, 1);
 266:	4605                	li	a2,1
 268:	faf40593          	addi	a1,s0,-81
 26c:	4501                	li	a0,0
 26e:	00000097          	auipc	ra,0x0
 272:	1a0080e7          	jalr	416(ra) # 40e <read>
    if(cc < 1)
 276:	00a05e63          	blez	a0,292 <gets+0x56>
    buf[i++] = c;
 27a:	faf44783          	lbu	a5,-81(s0)
 27e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 282:	01578763          	beq	a5,s5,290 <gets+0x54>
 286:	0905                	addi	s2,s2,1
 288:	fd679be3          	bne	a5,s6,25e <gets+0x22>
  for(i=0; i+1 < max; ){
 28c:	89a6                	mv	s3,s1
 28e:	a011                	j	292 <gets+0x56>
 290:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 292:	99de                	add	s3,s3,s7
 294:	00098023          	sb	zero,0(s3)
  return buf;
}
 298:	855e                	mv	a0,s7
 29a:	60e6                	ld	ra,88(sp)
 29c:	6446                	ld	s0,80(sp)
 29e:	64a6                	ld	s1,72(sp)
 2a0:	6906                	ld	s2,64(sp)
 2a2:	79e2                	ld	s3,56(sp)
 2a4:	7a42                	ld	s4,48(sp)
 2a6:	7aa2                	ld	s5,40(sp)
 2a8:	7b02                	ld	s6,32(sp)
 2aa:	6be2                	ld	s7,24(sp)
 2ac:	6125                	addi	sp,sp,96
 2ae:	8082                	ret

00000000000002b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b0:	1101                	addi	sp,sp,-32
 2b2:	ec06                	sd	ra,24(sp)
 2b4:	e822                	sd	s0,16(sp)
 2b6:	e426                	sd	s1,8(sp)
 2b8:	e04a                	sd	s2,0(sp)
 2ba:	1000                	addi	s0,sp,32
 2bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2be:	4581                	li	a1,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	176080e7          	jalr	374(ra) # 436 <open>
  if(fd < 0)
 2c8:	02054563          	bltz	a0,2f2 <stat+0x42>
 2cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ce:	85ca                	mv	a1,s2
 2d0:	00000097          	auipc	ra,0x0
 2d4:	17e080e7          	jalr	382(ra) # 44e <fstat>
 2d8:	892a                	mv	s2,a0
  close(fd);
 2da:	8526                	mv	a0,s1
 2dc:	00000097          	auipc	ra,0x0
 2e0:	142080e7          	jalr	322(ra) # 41e <close>
  return r;
}
 2e4:	854a                	mv	a0,s2
 2e6:	60e2                	ld	ra,24(sp)
 2e8:	6442                	ld	s0,16(sp)
 2ea:	64a2                	ld	s1,8(sp)
 2ec:	6902                	ld	s2,0(sp)
 2ee:	6105                	addi	sp,sp,32
 2f0:	8082                	ret
    return -1;
 2f2:	597d                	li	s2,-1
 2f4:	bfc5                	j	2e4 <stat+0x34>

00000000000002f6 <atoi>:

int
atoi(const char *s)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fc:	00054603          	lbu	a2,0(a0)
 300:	fd06079b          	addiw	a5,a2,-48
 304:	0ff7f793          	andi	a5,a5,255
 308:	4725                	li	a4,9
 30a:	02f76963          	bltu	a4,a5,33c <atoi+0x46>
 30e:	86aa                	mv	a3,a0
  n = 0;
 310:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 312:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 314:	0685                	addi	a3,a3,1
 316:	0025179b          	slliw	a5,a0,0x2
 31a:	9fa9                	addw	a5,a5,a0
 31c:	0017979b          	slliw	a5,a5,0x1
 320:	9fb1                	addw	a5,a5,a2
 322:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 326:	0006c603          	lbu	a2,0(a3)
 32a:	fd06071b          	addiw	a4,a2,-48
 32e:	0ff77713          	andi	a4,a4,255
 332:	fee5f1e3          	bgeu	a1,a4,314 <atoi+0x1e>
  return n;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  n = 0;
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <atoi+0x40>

0000000000000340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 346:	02b57663          	bgeu	a0,a1,372 <memmove+0x32>
    while(n-- > 0)
 34a:	02c05163          	blez	a2,36c <memmove+0x2c>
 34e:	fff6079b          	addiw	a5,a2,-1
 352:	1782                	slli	a5,a5,0x20
 354:	9381                	srli	a5,a5,0x20
 356:	0785                	addi	a5,a5,1
 358:	97aa                	add	a5,a5,a0
  dst = vdst;
 35a:	872a                	mv	a4,a0
      *dst++ = *src++;
 35c:	0585                	addi	a1,a1,1
 35e:	0705                	addi	a4,a4,1
 360:	fff5c683          	lbu	a3,-1(a1)
 364:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 368:	fee79ae3          	bne	a5,a4,35c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
    dst += n;
 372:	00c50733          	add	a4,a0,a2
    src += n;
 376:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 378:	fec05ae3          	blez	a2,36c <memmove+0x2c>
 37c:	fff6079b          	addiw	a5,a2,-1
 380:	1782                	slli	a5,a5,0x20
 382:	9381                	srli	a5,a5,0x20
 384:	fff7c793          	not	a5,a5
 388:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38a:	15fd                	addi	a1,a1,-1
 38c:	177d                	addi	a4,a4,-1
 38e:	0005c683          	lbu	a3,0(a1)
 392:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 396:	fee79ae3          	bne	a5,a4,38a <memmove+0x4a>
 39a:	bfc9                	j	36c <memmove+0x2c>

000000000000039c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e422                	sd	s0,8(sp)
 3a0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a2:	ca05                	beqz	a2,3d2 <memcmp+0x36>
 3a4:	fff6069b          	addiw	a3,a2,-1
 3a8:	1682                	slli	a3,a3,0x20
 3aa:	9281                	srli	a3,a3,0x20
 3ac:	0685                	addi	a3,a3,1
 3ae:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b0:	00054783          	lbu	a5,0(a0)
 3b4:	0005c703          	lbu	a4,0(a1)
 3b8:	00e79863          	bne	a5,a4,3c8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3bc:	0505                	addi	a0,a0,1
    p2++;
 3be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c0:	fed518e3          	bne	a0,a3,3b0 <memcmp+0x14>
  }
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	a019                	j	3cc <memcmp+0x30>
      return *p1 - *p2;
 3c8:	40e7853b          	subw	a0,a5,a4
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret
  return 0;
 3d2:	4501                	li	a0,0
 3d4:	bfe5                	j	3cc <memcmp+0x30>

00000000000003d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d6:	1141                	addi	sp,sp,-16
 3d8:	e406                	sd	ra,8(sp)
 3da:	e022                	sd	s0,0(sp)
 3dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3de:	00000097          	auipc	ra,0x0
 3e2:	f62080e7          	jalr	-158(ra) # 340 <memmove>
}
 3e6:	60a2                	ld	ra,8(sp)
 3e8:	6402                	ld	s0,0(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret

00000000000003ee <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ee:	4885                	li	a7,1
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f6:	4889                	li	a7,2
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fe:	488d                	li	a7,3
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 406:	4891                	li	a7,4
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <read>:
.global read
read:
 li a7, SYS_read
 40e:	4895                	li	a7,5
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <write>:
.global write
write:
 li a7, SYS_write
 416:	48c1                	li	a7,16
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <close>:
.global close
close:
 li a7, SYS_close
 41e:	48d5                	li	a7,21
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <kill>:
.global kill
kill:
 li a7, SYS_kill
 426:	4899                	li	a7,6
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <exec>:
.global exec
exec:
 li a7, SYS_exec
 42e:	489d                	li	a7,7
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <open>:
.global open
open:
 li a7, SYS_open
 436:	48bd                	li	a7,15
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43e:	48c5                	li	a7,17
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 446:	48c9                	li	a7,18
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44e:	48a1                	li	a7,8
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <link>:
.global link
link:
 li a7, SYS_link
 456:	48cd                	li	a7,19
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45e:	48d1                	li	a7,20
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 466:	48a5                	li	a7,9
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <dup>:
.global dup
dup:
 li a7, SYS_dup
 46e:	48a9                	li	a7,10
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 476:	48ad                	li	a7,11
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47e:	48b1                	li	a7,12
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 486:	48b5                	li	a7,13
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48e:	48b9                	li	a7,14
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <trace>:
.global trace
trace:
 li a7, SYS_trace
 496:	48d9                	li	a7,22
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49e:	1101                	addi	sp,sp,-32
 4a0:	ec06                	sd	ra,24(sp)
 4a2:	e822                	sd	s0,16(sp)
 4a4:	1000                	addi	s0,sp,32
 4a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4aa:	4605                	li	a2,1
 4ac:	fef40593          	addi	a1,s0,-17
 4b0:	00000097          	auipc	ra,0x0
 4b4:	f66080e7          	jalr	-154(ra) # 416 <write>
}
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	6105                	addi	sp,sp,32
 4be:	8082                	ret

00000000000004c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	7139                	addi	sp,sp,-64
 4c2:	fc06                	sd	ra,56(sp)
 4c4:	f822                	sd	s0,48(sp)
 4c6:	f426                	sd	s1,40(sp)
 4c8:	f04a                	sd	s2,32(sp)
 4ca:	ec4e                	sd	s3,24(sp)
 4cc:	0080                	addi	s0,sp,64
 4ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d0:	c299                	beqz	a3,4d6 <printint+0x16>
 4d2:	0805c863          	bltz	a1,562 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d6:	2581                	sext.w	a1,a1
  neg = 0;
 4d8:	4881                	li	a7,0
 4da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e0:	2601                	sext.w	a2,a2
 4e2:	00000517          	auipc	a0,0x0
 4e6:	44e50513          	addi	a0,a0,1102 # 930 <digits>
 4ea:	883a                	mv	a6,a4
 4ec:	2705                	addiw	a4,a4,1
 4ee:	02c5f7bb          	remuw	a5,a1,a2
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	97aa                	add	a5,a5,a0
 4f8:	0007c783          	lbu	a5,0(a5)
 4fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 500:	0005879b          	sext.w	a5,a1
 504:	02c5d5bb          	divuw	a1,a1,a2
 508:	0685                	addi	a3,a3,1
 50a:	fec7f0e3          	bgeu	a5,a2,4ea <printint+0x2a>
  if(neg)
 50e:	00088b63          	beqz	a7,524 <printint+0x64>
    buf[i++] = '-';
 512:	fd040793          	addi	a5,s0,-48
 516:	973e                	add	a4,a4,a5
 518:	02d00793          	li	a5,45
 51c:	fef70823          	sb	a5,-16(a4)
 520:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 524:	02e05863          	blez	a4,554 <printint+0x94>
 528:	fc040793          	addi	a5,s0,-64
 52c:	00e78933          	add	s2,a5,a4
 530:	fff78993          	addi	s3,a5,-1
 534:	99ba                	add	s3,s3,a4
 536:	377d                	addiw	a4,a4,-1
 538:	1702                	slli	a4,a4,0x20
 53a:	9301                	srli	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 540:	fff94583          	lbu	a1,-1(s2)
 544:	8526                	mv	a0,s1
 546:	00000097          	auipc	ra,0x0
 54a:	f58080e7          	jalr	-168(ra) # 49e <putc>
  while(--i >= 0)
 54e:	197d                	addi	s2,s2,-1
 550:	ff3918e3          	bne	s2,s3,540 <printint+0x80>
}
 554:	70e2                	ld	ra,56(sp)
 556:	7442                	ld	s0,48(sp)
 558:	74a2                	ld	s1,40(sp)
 55a:	7902                	ld	s2,32(sp)
 55c:	69e2                	ld	s3,24(sp)
 55e:	6121                	addi	sp,sp,64
 560:	8082                	ret
    x = -xx;
 562:	40b005bb          	negw	a1,a1
    neg = 1;
 566:	4885                	li	a7,1
    x = -xx;
 568:	bf8d                	j	4da <printint+0x1a>

000000000000056a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 56a:	7119                	addi	sp,sp,-128
 56c:	fc86                	sd	ra,120(sp)
 56e:	f8a2                	sd	s0,112(sp)
 570:	f4a6                	sd	s1,104(sp)
 572:	f0ca                	sd	s2,96(sp)
 574:	ecce                	sd	s3,88(sp)
 576:	e8d2                	sd	s4,80(sp)
 578:	e4d6                	sd	s5,72(sp)
 57a:	e0da                	sd	s6,64(sp)
 57c:	fc5e                	sd	s7,56(sp)
 57e:	f862                	sd	s8,48(sp)
 580:	f466                	sd	s9,40(sp)
 582:	f06a                	sd	s10,32(sp)
 584:	ec6e                	sd	s11,24(sp)
 586:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 588:	0005c903          	lbu	s2,0(a1)
 58c:	18090f63          	beqz	s2,72a <vprintf+0x1c0>
 590:	8aaa                	mv	s5,a0
 592:	8b32                	mv	s6,a2
 594:	00158493          	addi	s1,a1,1
  state = 0;
 598:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 59a:	02500a13          	li	s4,37
      if(c == 'd'){
 59e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5a2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5a6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5aa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ae:	00000b97          	auipc	s7,0x0
 5b2:	382b8b93          	addi	s7,s7,898 # 930 <digits>
 5b6:	a839                	j	5d4 <vprintf+0x6a>
        putc(fd, c);
 5b8:	85ca                	mv	a1,s2
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	ee2080e7          	jalr	-286(ra) # 49e <putc>
 5c4:	a019                	j	5ca <vprintf+0x60>
    } else if(state == '%'){
 5c6:	01498f63          	beq	s3,s4,5e4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5ca:	0485                	addi	s1,s1,1
 5cc:	fff4c903          	lbu	s2,-1(s1)
 5d0:	14090d63          	beqz	s2,72a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5d4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d8:	fe0997e3          	bnez	s3,5c6 <vprintf+0x5c>
      if(c == '%'){
 5dc:	fd479ee3          	bne	a5,s4,5b8 <vprintf+0x4e>
        state = '%';
 5e0:	89be                	mv	s3,a5
 5e2:	b7e5                	j	5ca <vprintf+0x60>
      if(c == 'd'){
 5e4:	05878063          	beq	a5,s8,624 <vprintf+0xba>
      } else if(c == 'l') {
 5e8:	05978c63          	beq	a5,s9,640 <vprintf+0xd6>
      } else if(c == 'x') {
 5ec:	07a78863          	beq	a5,s10,65c <vprintf+0xf2>
      } else if(c == 'p') {
 5f0:	09b78463          	beq	a5,s11,678 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5f4:	07300713          	li	a4,115
 5f8:	0ce78663          	beq	a5,a4,6c4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fc:	06300713          	li	a4,99
 600:	0ee78e63          	beq	a5,a4,6fc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 604:	11478863          	beq	a5,s4,714 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 608:	85d2                	mv	a1,s4
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e92080e7          	jalr	-366(ra) # 49e <putc>
        putc(fd, c);
 614:	85ca                	mv	a1,s2
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e86080e7          	jalr	-378(ra) # 49e <putc>
      }
      state = 0;
 620:	4981                	li	s3,0
 622:	b765                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 624:	008b0913          	addi	s2,s6,8
 628:	4685                	li	a3,1
 62a:	4629                	li	a2,10
 62c:	000b2583          	lw	a1,0(s6)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e8e080e7          	jalr	-370(ra) # 4c0 <printint>
 63a:	8b4a                	mv	s6,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b771                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b0913          	addi	s2,s6,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000b2583          	lw	a1,0(s6)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e72080e7          	jalr	-398(ra) # 4c0 <printint>
 656:	8b4a                	mv	s6,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bf85                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 65c:	008b0913          	addi	s2,s6,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000b2583          	lw	a1,0(s6)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e56080e7          	jalr	-426(ra) # 4c0 <printint>
 672:	8b4a                	mv	s6,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	bf91                	j	5ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 678:	008b0793          	addi	a5,s6,8
 67c:	f8f43423          	sd	a5,-120(s0)
 680:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 684:	03000593          	li	a1,48
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e14080e7          	jalr	-492(ra) # 49e <putc>
  putc(fd, 'x');
 692:	85ea                	mv	a1,s10
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e08080e7          	jalr	-504(ra) # 49e <putc>
 69e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a0:	03c9d793          	srli	a5,s3,0x3c
 6a4:	97de                	add	a5,a5,s7
 6a6:	0007c583          	lbu	a1,0(a5)
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	df2080e7          	jalr	-526(ra) # 49e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b4:	0992                	slli	s3,s3,0x4
 6b6:	397d                	addiw	s2,s2,-1
 6b8:	fe0914e3          	bnez	s2,6a0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6bc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b721                	j	5ca <vprintf+0x60>
        s = va_arg(ap, char*);
 6c4:	008b0993          	addi	s3,s6,8
 6c8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6cc:	02090163          	beqz	s2,6ee <vprintf+0x184>
        while(*s != 0){
 6d0:	00094583          	lbu	a1,0(s2)
 6d4:	c9a1                	beqz	a1,724 <vprintf+0x1ba>
          putc(fd, *s);
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	dc6080e7          	jalr	-570(ra) # 49e <putc>
          s++;
 6e0:	0905                	addi	s2,s2,1
        while(*s != 0){
 6e2:	00094583          	lbu	a1,0(s2)
 6e6:	f9e5                	bnez	a1,6d6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6e8:	8b4e                	mv	s6,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bdf9                	j	5ca <vprintf+0x60>
          s = "(null)";
 6ee:	00000917          	auipc	s2,0x0
 6f2:	23a90913          	addi	s2,s2,570 # 928 <malloc+0xf4>
        while(*s != 0){
 6f6:	02800593          	li	a1,40
 6fa:	bff1                	j	6d6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6fc:	008b0913          	addi	s2,s6,8
 700:	000b4583          	lbu	a1,0(s6)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d98080e7          	jalr	-616(ra) # 49e <putc>
 70e:	8b4a                	mv	s6,s2
      state = 0;
 710:	4981                	li	s3,0
 712:	bd65                	j	5ca <vprintf+0x60>
        putc(fd, c);
 714:	85d2                	mv	a1,s4
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	d86080e7          	jalr	-634(ra) # 49e <putc>
      state = 0;
 720:	4981                	li	s3,0
 722:	b565                	j	5ca <vprintf+0x60>
        s = va_arg(ap, char*);
 724:	8b4e                	mv	s6,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	b54d                	j	5ca <vprintf+0x60>
    }
  }
}
 72a:	70e6                	ld	ra,120(sp)
 72c:	7446                	ld	s0,112(sp)
 72e:	74a6                	ld	s1,104(sp)
 730:	7906                	ld	s2,96(sp)
 732:	69e6                	ld	s3,88(sp)
 734:	6a46                	ld	s4,80(sp)
 736:	6aa6                	ld	s5,72(sp)
 738:	6b06                	ld	s6,64(sp)
 73a:	7be2                	ld	s7,56(sp)
 73c:	7c42                	ld	s8,48(sp)
 73e:	7ca2                	ld	s9,40(sp)
 740:	7d02                	ld	s10,32(sp)
 742:	6de2                	ld	s11,24(sp)
 744:	6109                	addi	sp,sp,128
 746:	8082                	ret

0000000000000748 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 748:	715d                	addi	sp,sp,-80
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e010                	sd	a2,0(s0)
 752:	e414                	sd	a3,8(s0)
 754:	e818                	sd	a4,16(s0)
 756:	ec1c                	sd	a5,24(s0)
 758:	03043023          	sd	a6,32(s0)
 75c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	8622                	mv	a2,s0
 766:	00000097          	auipc	ra,0x0
 76a:	e04080e7          	jalr	-508(ra) # 56a <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <printf>:

void
printf(const char *fmt, ...)
{
 776:	711d                	addi	sp,sp,-96
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e40c                	sd	a1,8(s0)
 780:	e810                	sd	a2,16(s0)
 782:	ec14                	sd	a3,24(s0)
 784:	f018                	sd	a4,32(s0)
 786:	f41c                	sd	a5,40(s0)
 788:	03043823          	sd	a6,48(s0)
 78c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 798:	85aa                	mv	a1,a0
 79a:	4505                	li	a0,1
 79c:	00000097          	auipc	ra,0x0
 7a0:	dce080e7          	jalr	-562(ra) # 56a <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ac:	1141                	addi	sp,sp,-16
 7ae:	e422                	sd	s0,8(sp)
 7b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	00000797          	auipc	a5,0x0
 7ba:	1927b783          	ld	a5,402(a5) # 948 <freep>
 7be:	a805                	j	7ee <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c0:	4618                	lw	a4,8(a2)
 7c2:	9db9                	addw	a1,a1,a4
 7c4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	6318                	ld	a4,0(a4)
 7cc:	fee53823          	sd	a4,-16(a0)
 7d0:	a091                	j	814 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d2:	ff852703          	lw	a4,-8(a0)
 7d6:	9e39                	addw	a2,a2,a4
 7d8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7da:	ff053703          	ld	a4,-16(a0)
 7de:	e398                	sd	a4,0(a5)
 7e0:	a099                	j	826 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x40>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x50>
{
 7ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x36>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059713          	slli	a4,a1,0x20
 806:	9301                	srli	a4,a4,0x20
 808:	0712                	slli	a4,a4,0x4
 80a:	9736                	add	a4,a4,a3
 80c:	fae60ae3          	beq	a2,a4,7c0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 814:	4790                	lw	a2,8(a5)
 816:	02061713          	slli	a4,a2,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	0712                	slli	a4,a4,0x4
 81e:	973e                	add	a4,a4,a5
 820:	fae689e3          	beq	a3,a4,7d2 <free+0x26>
  } else
    p->s.ptr = bp;
 824:	e394                	sd	a3,0(a5)
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	12f73123          	sd	a5,290(a4) # 948 <freep>
}
 82e:	6422                	ld	s0,8(sp)
 830:	0141                	addi	sp,sp,16
 832:	8082                	ret

0000000000000834 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 834:	7139                	addi	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f426                	sd	s1,40(sp)
 83c:	f04a                	sd	s2,32(sp)
 83e:	ec4e                	sd	s3,24(sp)
 840:	e852                	sd	s4,16(sp)
 842:	e456                	sd	s5,8(sp)
 844:	e05a                	sd	s6,0(sp)
 846:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	02051493          	slli	s1,a0,0x20
 84c:	9081                	srli	s1,s1,0x20
 84e:	04bd                	addi	s1,s1,15
 850:	8091                	srli	s1,s1,0x4
 852:	0014899b          	addiw	s3,s1,1
 856:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 858:	00000517          	auipc	a0,0x0
 85c:	0f053503          	ld	a0,240(a0) # 948 <freep>
 860:	c515                	beqz	a0,88c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	02977f63          	bgeu	a4,s1,8a4 <malloc+0x70>
 86a:	8a4e                	mv	s4,s3
 86c:	0009871b          	sext.w	a4,s3
 870:	6685                	lui	a3,0x1
 872:	00d77363          	bgeu	a4,a3,878 <malloc+0x44>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 880:	00000917          	auipc	s2,0x0
 884:	0c890913          	addi	s2,s2,200 # 948 <freep>
  if(p == (char*)-1)
 888:	5afd                	li	s5,-1
 88a:	a88d                	j	8fc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 88c:	00000797          	auipc	a5,0x0
 890:	0c478793          	addi	a5,a5,196 # 950 <base>
 894:	00000717          	auipc	a4,0x0
 898:	0af73a23          	sd	a5,180(a4) # 948 <freep>
 89c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a2:	b7e1                	j	86a <malloc+0x36>
      if(p->s.size == nunits)
 8a4:	02e48b63          	beq	s1,a4,8da <malloc+0xa6>
        p->s.size -= nunits;
 8a8:	4137073b          	subw	a4,a4,s3
 8ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ae:	1702                	slli	a4,a4,0x20
 8b0:	9301                	srli	a4,a4,0x20
 8b2:	0712                	slli	a4,a4,0x4
 8b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ba:	00000717          	auipc	a4,0x0
 8be:	08a73723          	sd	a0,142(a4) # 948 <freep>
      return (void*)(p + 1);
 8c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c6:	70e2                	ld	ra,56(sp)
 8c8:	7442                	ld	s0,48(sp)
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	7902                	ld	s2,32(sp)
 8ce:	69e2                	ld	s3,24(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	6121                	addi	sp,sp,64
 8d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8da:	6398                	ld	a4,0(a5)
 8dc:	e118                	sd	a4,0(a0)
 8de:	bff1                	j	8ba <malloc+0x86>
  hp->s.size = nu;
 8e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e4:	0541                	addi	a0,a0,16
 8e6:	00000097          	auipc	ra,0x0
 8ea:	ec6080e7          	jalr	-314(ra) # 7ac <free>
  return freep;
 8ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f2:	d971                	beqz	a0,8c6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f6:	4798                	lw	a4,8(a5)
 8f8:	fa9776e3          	bgeu	a4,s1,8a4 <malloc+0x70>
    if(p == freep)
 8fc:	00093703          	ld	a4,0(s2)
 900:	853e                	mv	a0,a5
 902:	fef719e3          	bne	a4,a5,8f4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 906:	8552                	mv	a0,s4
 908:	00000097          	auipc	ra,0x0
 90c:	b76080e7          	jalr	-1162(ra) # 47e <sbrk>
  if(p == (char*)-1)
 910:	fd5518e3          	bne	a0,s5,8e0 <malloc+0xac>
        return 0;
 914:	4501                	li	a0,0
 916:	bf45                	j	8c6 <malloc+0x92>
