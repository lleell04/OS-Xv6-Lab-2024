
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	527050ef          	jal	ra,80005d3c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	238080e7          	jalr	568(ra) # 80000286 <memset>
  kmem.freelist = r;
  release(&kmem.lock);*/
  
  
  //修改后：
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	67e080e7          	jalr	1662(ra) # 800066d4 <push_off>

  int cpu = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	edc080e7          	jalr	-292(ra) # 80000f3a <cpuid>

  acquire(&kmem[cpu].lock);
    80000066:	00009a97          	auipc	s5,0x9
    8000006a:	fcaa8a93          	addi	s5,s5,-54 # 80009030 <kmem>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	6a4080e7          	jalr	1700(ra) # 80006720 <acquire>
  r->next = kmem[cpu].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
  kmem[cpu].freelist = r;
    8000008a:	02993023          	sd	s1,32(s2)
  release(&kmem[cpu].lock);
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	760080e7          	jalr	1888(ra) # 800067f0 <release>

  pop_off();
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	6f8080e7          	jalr	1784(ra) # 80006790 <pop_off>
  
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
    panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f5e50513          	addi	a0,a0,-162 # 80008010 <etext+0x10>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	132080e7          	jalr	306(ra) # 800061ec <panic>

00000000800000c2 <freerange>:
{
    800000c2:	7179                	addi	sp,sp,-48
    800000c4:	f406                	sd	ra,40(sp)
    800000c6:	f022                	sd	s0,32(sp)
    800000c8:	ec26                	sd	s1,24(sp)
    800000ca:	e84a                	sd	s2,16(sp)
    800000cc:	e44e                	sd	s3,8(sp)
    800000ce:	e052                	sd	s4,0(sp)
    800000d0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d2:	6785                	lui	a5,0x1
    800000d4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000d8:	94aa                	add	s1,s1,a0
    800000da:	757d                	lui	a0,0xfffff
    800000dc:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000de:	94be                	add	s1,s1,a5
    800000e0:	0095ee63          	bltu	a1,s1,800000fc <freerange+0x3a>
    800000e4:	892e                	mv	s2,a1
    kfree(p);
    800000e6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e8:	6985                	lui	s3,0x1
    kfree(p);
    800000ea:	01448533          	add	a0,s1,s4
    800000ee:	00000097          	auipc	ra,0x0
    800000f2:	f2e080e7          	jalr	-210(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f6:	94ce                	add	s1,s1,s3
    800000f8:	fe9979e3          	bgeu	s2,s1,800000ea <freerange+0x28>
}
    800000fc:	70a2                	ld	ra,40(sp)
    800000fe:	7402                	ld	s0,32(sp)
    80000100:	64e2                	ld	s1,24(sp)
    80000102:	6942                	ld	s2,16(sp)
    80000104:	69a2                	ld	s3,8(sp)
    80000106:	6a02                	ld	s4,0(sp)
    80000108:	6145                	addi	sp,sp,48
    8000010a:	8082                	ret

000000008000010c <kinit>:
{
    8000010c:	715d                	addi	sp,sp,-80
    8000010e:	e486                	sd	ra,72(sp)
    80000110:	e0a2                	sd	s0,64(sp)
    80000112:	fc26                	sd	s1,56(sp)
    80000114:	f84a                	sd	s2,48(sp)
    80000116:	f44e                	sd	s3,40(sp)
    80000118:	f052                	sd	s4,32(sp)
    8000011a:	0880                	addi	s0,sp,80
  for (int i = 0; i < NCPU; i++) {
    8000011c:	00009917          	auipc	s2,0x9
    80000120:	f1490913          	addi	s2,s2,-236 # 80009030 <kmem>
    80000124:	4481                	li	s1,0
      snprintf(kmem_name, 32, "kmem_%d", i);
    80000126:	00008a17          	auipc	s4,0x8
    8000012a:	ef2a0a13          	addi	s4,s4,-270 # 80008018 <etext+0x18>
  for (int i = 0; i < NCPU; i++) {
    8000012e:	49a1                	li	s3,8
      snprintf(kmem_name, 32, "kmem_%d", i);
    80000130:	86a6                	mv	a3,s1
    80000132:	8652                	mv	a2,s4
    80000134:	02000593          	li	a1,32
    80000138:	fb040513          	addi	a0,s0,-80
    8000013c:	00006097          	auipc	ra,0x6
    80000140:	a16080e7          	jalr	-1514(ra) # 80005b52 <snprintf>
      initlock(&kmem[i].lock, kmem_name); //init all locks
    80000144:	fb040593          	addi	a1,s0,-80
    80000148:	854a                	mv	a0,s2
    8000014a:	00006097          	auipc	ra,0x6
    8000014e:	752080e7          	jalr	1874(ra) # 8000689c <initlock>
  for (int i = 0; i < NCPU; i++) {
    80000152:	2485                	addiw	s1,s1,1
    80000154:	02890913          	addi	s2,s2,40
    80000158:	fd349ce3          	bne	s1,s3,80000130 <kinit+0x24>
  freerange(end, (void*)PHYSTOP);
    8000015c:	45c5                	li	a1,17
    8000015e:	05ee                	slli	a1,a1,0x1b
    80000160:	0002b517          	auipc	a0,0x2b
    80000164:	0e850513          	addi	a0,a0,232 # 8002b248 <end>
    80000168:	00000097          	auipc	ra,0x0
    8000016c:	f5a080e7          	jalr	-166(ra) # 800000c2 <freerange>
}
    80000170:	60a6                	ld	ra,72(sp)
    80000172:	6406                	ld	s0,64(sp)
    80000174:	74e2                	ld	s1,56(sp)
    80000176:	7942                	ld	s2,48(sp)
    80000178:	79a2                	ld	s3,40(sp)
    8000017a:	7a02                	ld	s4,32(sp)
    8000017c:	6161                	addi	sp,sp,80
    8000017e:	8082                	ret

0000000080000180 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000180:	715d                	addi	sp,sp,-80
    80000182:	e486                	sd	ra,72(sp)
    80000184:	e0a2                	sd	s0,64(sp)
    80000186:	fc26                	sd	s1,56(sp)
    80000188:	f84a                	sd	s2,48(sp)
    8000018a:	f44e                	sd	s3,40(sp)
    8000018c:	f052                	sd	s4,32(sp)
    8000018e:	ec56                	sd	s5,24(sp)
    80000190:	e85a                	sd	s6,16(sp)
    80000192:	e45e                	sd	s7,8(sp)
    80000194:	e062                	sd	s8,0(sp)
    80000196:	0880                	addi	s0,sp,80

  /*acquire(&kmem.lock);
  r = kmem.freelist;*/
  
  /*Added begin*/
  push_off();
    80000198:	00006097          	auipc	ra,0x6
    8000019c:	53c080e7          	jalr	1340(ra) # 800066d4 <push_off>
  int CPUID = cpuid();
    800001a0:	00001097          	auipc	ra,0x1
    800001a4:	d9a080e7          	jalr	-614(ra) # 80000f3a <cpuid>
    800001a8:	892a                	mv	s2,a0
  acquire(&kmem[CPUID].lock);
    800001aa:	00251a93          	slli	s5,a0,0x2
    800001ae:	9aaa                	add	s5,s5,a0
    800001b0:	003a9793          	slli	a5,s5,0x3
    800001b4:	00009a97          	auipc	s5,0x9
    800001b8:	e7ca8a93          	addi	s5,s5,-388 # 80009030 <kmem>
    800001bc:	9abe                	add	s5,s5,a5
    800001be:	8556                	mv	a0,s5
    800001c0:	00006097          	auipc	ra,0x6
    800001c4:	560080e7          	jalr	1376(ra) # 80006720 <acquire>
  r = kmem[CPUID].freelist;
    800001c8:	020abb03          	ld	s6,32(s5)
  /*Added end*/
    
  if(r)
    800001cc:	000b0863          	beqz	s6,800001dc <kalloc+0x5c>
    //kmem.freelist = r->next;
    kmem[CPUID].freelist = r->next; //Added
    800001d0:	000b3703          	ld	a4,0(s6)
    800001d4:	02eab023          	sd	a4,32(s5)
  r = kmem[CPUID].freelist;
    800001d8:	8a5a                	mv	s4,s6
    800001da:	a88d                	j	8000024c <kalloc+0xcc>
    800001dc:	00009997          	auipc	s3,0x9
    800001e0:	e5498993          	addi	s3,s3,-428 # 80009030 <kmem>
    
  /*Added begin*/
  if (r == 0) { // 若当前CPU上没有空闲页
        // 在其他CPU上查找空闲页
        for (int i = 0; i < NCPU; i++) {
    800001e4:	4481                	li	s1,0
    800001e6:	4c21                	li	s8,8
    800001e8:	a035                	j	80000214 <kalloc+0x94>
            release(&kmem[i].lock);
            if (r) // 已找到
                break;
        }
    }
    release(&kmem[CPUID].lock);
    800001ea:	8556                	mv	a0,s5
    800001ec:	00006097          	auipc	ra,0x6
    800001f0:	604080e7          	jalr	1540(ra) # 800067f0 <release>
    pop_off();
    800001f4:	00006097          	auipc	ra,0x6
    800001f8:	59c080e7          	jalr	1436(ra) # 80006790 <pop_off>
    /*Added end*/
  

  //release(&kmem.lock); 
    
  if(r)
    800001fc:	8a5a                	mv	s4,s6
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
    800001fe:	a0bd                	j	8000026c <kalloc+0xec>
            release(&kmem[i].lock);
    80000200:	854e                	mv	a0,s3
    80000202:	00006097          	auipc	ra,0x6
    80000206:	5ee080e7          	jalr	1518(ra) # 800067f0 <release>
        for (int i = 0; i < NCPU; i++) {
    8000020a:	2485                	addiw	s1,s1,1
    8000020c:	02898993          	addi	s3,s3,40
    80000210:	fd848de3          	beq	s1,s8,800001ea <kalloc+0x6a>
            if (i == CPUID)
    80000214:	fe990be3          	beq	s2,s1,8000020a <kalloc+0x8a>
            acquire(&kmem[i].lock);
    80000218:	854e                	mv	a0,s3
    8000021a:	00006097          	auipc	ra,0x6
    8000021e:	506080e7          	jalr	1286(ra) # 80006720 <acquire>
            r = kmem[i].freelist;
    80000222:	0209ba03          	ld	s4,32(s3)
            if (r)
    80000226:	fc0a0de3          	beqz	s4,80000200 <kalloc+0x80>
                kmem[i].freelist = r->next;
    8000022a:	000a3703          	ld	a4,0(s4)
    8000022e:	00249793          	slli	a5,s1,0x2
    80000232:	94be                	add	s1,s1,a5
    80000234:	048e                	slli	s1,s1,0x3
    80000236:	00009797          	auipc	a5,0x9
    8000023a:	dfa78793          	addi	a5,a5,-518 # 80009030 <kmem>
    8000023e:	94be                	add	s1,s1,a5
    80000240:	f098                	sd	a4,32(s1)
            release(&kmem[i].lock);
    80000242:	854e                	mv	a0,s3
    80000244:	00006097          	auipc	ra,0x6
    80000248:	5ac080e7          	jalr	1452(ra) # 800067f0 <release>
    release(&kmem[CPUID].lock);
    8000024c:	8556                	mv	a0,s5
    8000024e:	00006097          	auipc	ra,0x6
    80000252:	5a2080e7          	jalr	1442(ra) # 800067f0 <release>
    pop_off();
    80000256:	00006097          	auipc	ra,0x6
    8000025a:	53a080e7          	jalr	1338(ra) # 80006790 <pop_off>
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000025e:	6605                	lui	a2,0x1
    80000260:	4595                	li	a1,5
    80000262:	8552                	mv	a0,s4
    80000264:	00000097          	auipc	ra,0x0
    80000268:	022080e7          	jalr	34(ra) # 80000286 <memset>
}
    8000026c:	8552                	mv	a0,s4
    8000026e:	60a6                	ld	ra,72(sp)
    80000270:	6406                	ld	s0,64(sp)
    80000272:	74e2                	ld	s1,56(sp)
    80000274:	7942                	ld	s2,48(sp)
    80000276:	79a2                	ld	s3,40(sp)
    80000278:	7a02                	ld	s4,32(sp)
    8000027a:	6ae2                	ld	s5,24(sp)
    8000027c:	6b42                	ld	s6,16(sp)
    8000027e:	6ba2                	ld	s7,8(sp)
    80000280:	6c02                	ld	s8,0(sp)
    80000282:	6161                	addi	sp,sp,80
    80000284:	8082                	ret

0000000080000286 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000028c:	ce09                	beqz	a2,800002a6 <memset+0x20>
    8000028e:	87aa                	mv	a5,a0
    80000290:	fff6071b          	addiw	a4,a2,-1
    80000294:	1702                	slli	a4,a4,0x20
    80000296:	9301                	srli	a4,a4,0x20
    80000298:	0705                	addi	a4,a4,1
    8000029a:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000029c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002a0:	0785                	addi	a5,a5,1
    800002a2:	fee79de3          	bne	a5,a4,8000029c <memset+0x16>
  }
  return dst;
}
    800002a6:	6422                	ld	s0,8(sp)
    800002a8:	0141                	addi	sp,sp,16
    800002aa:	8082                	ret

00000000800002ac <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002ac:	1141                	addi	sp,sp,-16
    800002ae:	e422                	sd	s0,8(sp)
    800002b0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002b2:	ca05                	beqz	a2,800002e2 <memcmp+0x36>
    800002b4:	fff6069b          	addiw	a3,a2,-1
    800002b8:	1682                	slli	a3,a3,0x20
    800002ba:	9281                	srli	a3,a3,0x20
    800002bc:	0685                	addi	a3,a3,1
    800002be:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002c0:	00054783          	lbu	a5,0(a0)
    800002c4:	0005c703          	lbu	a4,0(a1)
    800002c8:	00e79863          	bne	a5,a4,800002d8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002cc:	0505                	addi	a0,a0,1
    800002ce:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002d0:	fed518e3          	bne	a0,a3,800002c0 <memcmp+0x14>
  }

  return 0;
    800002d4:	4501                	li	a0,0
    800002d6:	a019                	j	800002dc <memcmp+0x30>
      return *s1 - *s2;
    800002d8:	40e7853b          	subw	a0,a5,a4
}
    800002dc:	6422                	ld	s0,8(sp)
    800002de:	0141                	addi	sp,sp,16
    800002e0:	8082                	ret
  return 0;
    800002e2:	4501                	li	a0,0
    800002e4:	bfe5                	j	800002dc <memcmp+0x30>

00000000800002e6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002e6:	1141                	addi	sp,sp,-16
    800002e8:	e422                	sd	s0,8(sp)
    800002ea:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002ec:	ca0d                	beqz	a2,8000031e <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002ee:	00a5f963          	bgeu	a1,a0,80000300 <memmove+0x1a>
    800002f2:	02061693          	slli	a3,a2,0x20
    800002f6:	9281                	srli	a3,a3,0x20
    800002f8:	00d58733          	add	a4,a1,a3
    800002fc:	02e56463          	bltu	a0,a4,80000324 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000300:	fff6079b          	addiw	a5,a2,-1
    80000304:	1782                	slli	a5,a5,0x20
    80000306:	9381                	srli	a5,a5,0x20
    80000308:	0785                	addi	a5,a5,1
    8000030a:	97ae                	add	a5,a5,a1
    8000030c:	872a                	mv	a4,a0
      *d++ = *s++;
    8000030e:	0585                	addi	a1,a1,1
    80000310:	0705                	addi	a4,a4,1
    80000312:	fff5c683          	lbu	a3,-1(a1)
    80000316:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000031a:	fef59ae3          	bne	a1,a5,8000030e <memmove+0x28>

  return dst;
}
    8000031e:	6422                	ld	s0,8(sp)
    80000320:	0141                	addi	sp,sp,16
    80000322:	8082                	ret
    d += n;
    80000324:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000326:	fff6079b          	addiw	a5,a2,-1
    8000032a:	1782                	slli	a5,a5,0x20
    8000032c:	9381                	srli	a5,a5,0x20
    8000032e:	fff7c793          	not	a5,a5
    80000332:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000334:	177d                	addi	a4,a4,-1
    80000336:	16fd                	addi	a3,a3,-1
    80000338:	00074603          	lbu	a2,0(a4)
    8000033c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000340:	fef71ae3          	bne	a4,a5,80000334 <memmove+0x4e>
    80000344:	bfe9                	j	8000031e <memmove+0x38>

0000000080000346 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e406                	sd	ra,8(sp)
    8000034a:	e022                	sd	s0,0(sp)
    8000034c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000034e:	00000097          	auipc	ra,0x0
    80000352:	f98080e7          	jalr	-104(ra) # 800002e6 <memmove>
}
    80000356:	60a2                	ld	ra,8(sp)
    80000358:	6402                	ld	s0,0(sp)
    8000035a:	0141                	addi	sp,sp,16
    8000035c:	8082                	ret

000000008000035e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000035e:	1141                	addi	sp,sp,-16
    80000360:	e422                	sd	s0,8(sp)
    80000362:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000364:	ce11                	beqz	a2,80000380 <strncmp+0x22>
    80000366:	00054783          	lbu	a5,0(a0)
    8000036a:	cf89                	beqz	a5,80000384 <strncmp+0x26>
    8000036c:	0005c703          	lbu	a4,0(a1)
    80000370:	00f71a63          	bne	a4,a5,80000384 <strncmp+0x26>
    n--, p++, q++;
    80000374:	367d                	addiw	a2,a2,-1
    80000376:	0505                	addi	a0,a0,1
    80000378:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000037a:	f675                	bnez	a2,80000366 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000037c:	4501                	li	a0,0
    8000037e:	a809                	j	80000390 <strncmp+0x32>
    80000380:	4501                	li	a0,0
    80000382:	a039                	j	80000390 <strncmp+0x32>
  if(n == 0)
    80000384:	ca09                	beqz	a2,80000396 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000386:	00054503          	lbu	a0,0(a0)
    8000038a:	0005c783          	lbu	a5,0(a1)
    8000038e:	9d1d                	subw	a0,a0,a5
}
    80000390:	6422                	ld	s0,8(sp)
    80000392:	0141                	addi	sp,sp,16
    80000394:	8082                	ret
    return 0;
    80000396:	4501                	li	a0,0
    80000398:	bfe5                	j	80000390 <strncmp+0x32>

000000008000039a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000039a:	1141                	addi	sp,sp,-16
    8000039c:	e422                	sd	s0,8(sp)
    8000039e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003a0:	872a                	mv	a4,a0
    800003a2:	8832                	mv	a6,a2
    800003a4:	367d                	addiw	a2,a2,-1
    800003a6:	01005963          	blez	a6,800003b8 <strncpy+0x1e>
    800003aa:	0705                	addi	a4,a4,1
    800003ac:	0005c783          	lbu	a5,0(a1)
    800003b0:	fef70fa3          	sb	a5,-1(a4)
    800003b4:	0585                	addi	a1,a1,1
    800003b6:	f7f5                	bnez	a5,800003a2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003b8:	00c05d63          	blez	a2,800003d2 <strncpy+0x38>
    800003bc:	86ba                	mv	a3,a4
    *s++ = 0;
    800003be:	0685                	addi	a3,a3,1
    800003c0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003c4:	fff6c793          	not	a5,a3
    800003c8:	9fb9                	addw	a5,a5,a4
    800003ca:	010787bb          	addw	a5,a5,a6
    800003ce:	fef048e3          	bgtz	a5,800003be <strncpy+0x24>
  return os;
}
    800003d2:	6422                	ld	s0,8(sp)
    800003d4:	0141                	addi	sp,sp,16
    800003d6:	8082                	ret

00000000800003d8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003d8:	1141                	addi	sp,sp,-16
    800003da:	e422                	sd	s0,8(sp)
    800003dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003de:	02c05363          	blez	a2,80000404 <safestrcpy+0x2c>
    800003e2:	fff6069b          	addiw	a3,a2,-1
    800003e6:	1682                	slli	a3,a3,0x20
    800003e8:	9281                	srli	a3,a3,0x20
    800003ea:	96ae                	add	a3,a3,a1
    800003ec:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003ee:	00d58963          	beq	a1,a3,80000400 <safestrcpy+0x28>
    800003f2:	0585                	addi	a1,a1,1
    800003f4:	0785                	addi	a5,a5,1
    800003f6:	fff5c703          	lbu	a4,-1(a1)
    800003fa:	fee78fa3          	sb	a4,-1(a5)
    800003fe:	fb65                	bnez	a4,800003ee <safestrcpy+0x16>
    ;
  *s = 0;
    80000400:	00078023          	sb	zero,0(a5)
  return os;
}
    80000404:	6422                	ld	s0,8(sp)
    80000406:	0141                	addi	sp,sp,16
    80000408:	8082                	ret

000000008000040a <strlen>:

int
strlen(const char *s)
{
    8000040a:	1141                	addi	sp,sp,-16
    8000040c:	e422                	sd	s0,8(sp)
    8000040e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000410:	00054783          	lbu	a5,0(a0)
    80000414:	cf91                	beqz	a5,80000430 <strlen+0x26>
    80000416:	0505                	addi	a0,a0,1
    80000418:	87aa                	mv	a5,a0
    8000041a:	4685                	li	a3,1
    8000041c:	9e89                	subw	a3,a3,a0
    8000041e:	00f6853b          	addw	a0,a3,a5
    80000422:	0785                	addi	a5,a5,1
    80000424:	fff7c703          	lbu	a4,-1(a5)
    80000428:	fb7d                	bnez	a4,8000041e <strlen+0x14>
    ;
  return n;
}
    8000042a:	6422                	ld	s0,8(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000430:	4501                	li	a0,0
    80000432:	bfe5                	j	8000042a <strlen+0x20>

0000000080000434 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000434:	1101                	addi	sp,sp,-32
    80000436:	ec06                	sd	ra,24(sp)
    80000438:	e822                	sd	s0,16(sp)
    8000043a:	e426                	sd	s1,8(sp)
    8000043c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000043e:	00001097          	auipc	ra,0x1
    80000442:	afc080e7          	jalr	-1284(ra) # 80000f3a <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000446:	00009497          	auipc	s1,0x9
    8000044a:	bba48493          	addi	s1,s1,-1094 # 80009000 <started>
  if(cpuid() == 0){
    8000044e:	c531                	beqz	a0,8000049a <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000450:	8526                	mv	a0,s1
    80000452:	00006097          	auipc	ra,0x6
    80000456:	4e0080e7          	jalr	1248(ra) # 80006932 <lockfree_read4>
    8000045a:	d97d                	beqz	a0,80000450 <main+0x1c>
      ;
    __sync_synchronize();
    8000045c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000460:	00001097          	auipc	ra,0x1
    80000464:	ada080e7          	jalr	-1318(ra) # 80000f3a <cpuid>
    80000468:	85aa                	mv	a1,a0
    8000046a:	00008517          	auipc	a0,0x8
    8000046e:	bce50513          	addi	a0,a0,-1074 # 80008038 <etext+0x38>
    80000472:	00006097          	auipc	ra,0x6
    80000476:	dc4080e7          	jalr	-572(ra) # 80006236 <printf>
    kvminithart();    // turn on paging
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	0e0080e7          	jalr	224(ra) # 8000055a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000482:	00001097          	auipc	ra,0x1
    80000486:	730080e7          	jalr	1840(ra) # 80001bb2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000048a:	00005097          	auipc	ra,0x5
    8000048e:	f06080e7          	jalr	-250(ra) # 80005390 <plicinithart>
  }

  scheduler();        
    80000492:	00001097          	auipc	ra,0x1
    80000496:	fde080e7          	jalr	-34(ra) # 80001470 <scheduler>
    consoleinit();
    8000049a:	00006097          	auipc	ra,0x6
    8000049e:	c64080e7          	jalr	-924(ra) # 800060fe <consoleinit>
    statsinit();
    800004a2:	00005097          	auipc	ra,0x5
    800004a6:	5d4080e7          	jalr	1492(ra) # 80005a76 <statsinit>
    printfinit();
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	f72080e7          	jalr	-142(ra) # 8000641c <printfinit>
    printf("\n");
    800004b2:	00008517          	auipc	a0,0x8
    800004b6:	3ce50513          	addi	a0,a0,974 # 80008880 <digits+0x88>
    800004ba:	00006097          	auipc	ra,0x6
    800004be:	d7c080e7          	jalr	-644(ra) # 80006236 <printf>
    printf("xv6 kernel is booting\n");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	b5e50513          	addi	a0,a0,-1186 # 80008020 <etext+0x20>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	d6c080e7          	jalr	-660(ra) # 80006236 <printf>
    printf("\n");
    800004d2:	00008517          	auipc	a0,0x8
    800004d6:	3ae50513          	addi	a0,a0,942 # 80008880 <digits+0x88>
    800004da:	00006097          	auipc	ra,0x6
    800004de:	d5c080e7          	jalr	-676(ra) # 80006236 <printf>
    kinit();         // physical page allocator
    800004e2:	00000097          	auipc	ra,0x0
    800004e6:	c2a080e7          	jalr	-982(ra) # 8000010c <kinit>
    kvminit();       // create kernel page table
    800004ea:	00000097          	auipc	ra,0x0
    800004ee:	322080e7          	jalr	802(ra) # 8000080c <kvminit>
    kvminithart();   // turn on paging
    800004f2:	00000097          	auipc	ra,0x0
    800004f6:	068080e7          	jalr	104(ra) # 8000055a <kvminithart>
    procinit();      // process table
    800004fa:	00001097          	auipc	ra,0x1
    800004fe:	990080e7          	jalr	-1648(ra) # 80000e8a <procinit>
    trapinit();      // trap vectors
    80000502:	00001097          	auipc	ra,0x1
    80000506:	688080e7          	jalr	1672(ra) # 80001b8a <trapinit>
    trapinithart();  // install kernel trap vector
    8000050a:	00001097          	auipc	ra,0x1
    8000050e:	6a8080e7          	jalr	1704(ra) # 80001bb2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000512:	00005097          	auipc	ra,0x5
    80000516:	e68080e7          	jalr	-408(ra) # 8000537a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000051a:	00005097          	auipc	ra,0x5
    8000051e:	e76080e7          	jalr	-394(ra) # 80005390 <plicinithart>
    binit();         // buffer cache
    80000522:	00002097          	auipc	ra,0x2
    80000526:	de4080e7          	jalr	-540(ra) # 80002306 <binit>
    iinit();         // inode table
    8000052a:	00002097          	auipc	ra,0x2
    8000052e:	6d4080e7          	jalr	1748(ra) # 80002bfe <iinit>
    fileinit();      // file table
    80000532:	00003097          	auipc	ra,0x3
    80000536:	67e080e7          	jalr	1662(ra) # 80003bb0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000053a:	00005097          	auipc	ra,0x5
    8000053e:	f78080e7          	jalr	-136(ra) # 800054b2 <virtio_disk_init>
    userinit();      // first user process
    80000542:	00001097          	auipc	ra,0x1
    80000546:	cfc080e7          	jalr	-772(ra) # 8000123e <userinit>
    __sync_synchronize();
    8000054a:	0ff0000f          	fence
    started = 1;
    8000054e:	4785                	li	a5,1
    80000550:	00009717          	auipc	a4,0x9
    80000554:	aaf72823          	sw	a5,-1360(a4) # 80009000 <started>
    80000558:	bf2d                	j	80000492 <main+0x5e>

000000008000055a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000055a:	1141                	addi	sp,sp,-16
    8000055c:	e422                	sd	s0,8(sp)
    8000055e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000560:	00009797          	auipc	a5,0x9
    80000564:	aa87b783          	ld	a5,-1368(a5) # 80009008 <kernel_pagetable>
    80000568:	83b1                	srli	a5,a5,0xc
    8000056a:	577d                	li	a4,-1
    8000056c:	177e                	slli	a4,a4,0x3f
    8000056e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000570:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000574:	12000073          	sfence.vma
  sfence_vma();
}
    80000578:	6422                	ld	s0,8(sp)
    8000057a:	0141                	addi	sp,sp,16
    8000057c:	8082                	ret

000000008000057e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000057e:	7139                	addi	sp,sp,-64
    80000580:	fc06                	sd	ra,56(sp)
    80000582:	f822                	sd	s0,48(sp)
    80000584:	f426                	sd	s1,40(sp)
    80000586:	f04a                	sd	s2,32(sp)
    80000588:	ec4e                	sd	s3,24(sp)
    8000058a:	e852                	sd	s4,16(sp)
    8000058c:	e456                	sd	s5,8(sp)
    8000058e:	e05a                	sd	s6,0(sp)
    80000590:	0080                	addi	s0,sp,64
    80000592:	84aa                	mv	s1,a0
    80000594:	89ae                	mv	s3,a1
    80000596:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000598:	57fd                	li	a5,-1
    8000059a:	83e9                	srli	a5,a5,0x1a
    8000059c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000059e:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005a0:	04b7f263          	bgeu	a5,a1,800005e4 <walk+0x66>
    panic("walk");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	aac50513          	addi	a0,a0,-1364 # 80008050 <etext+0x50>
    800005ac:	00006097          	auipc	ra,0x6
    800005b0:	c40080e7          	jalr	-960(ra) # 800061ec <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005b4:	060a8663          	beqz	s5,80000620 <walk+0xa2>
    800005b8:	00000097          	auipc	ra,0x0
    800005bc:	bc8080e7          	jalr	-1080(ra) # 80000180 <kalloc>
    800005c0:	84aa                	mv	s1,a0
    800005c2:	c529                	beqz	a0,8000060c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005c4:	6605                	lui	a2,0x1
    800005c6:	4581                	li	a1,0
    800005c8:	00000097          	auipc	ra,0x0
    800005cc:	cbe080e7          	jalr	-834(ra) # 80000286 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005d0:	00c4d793          	srli	a5,s1,0xc
    800005d4:	07aa                	slli	a5,a5,0xa
    800005d6:	0017e793          	ori	a5,a5,1
    800005da:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005de:	3a5d                	addiw	s4,s4,-9
    800005e0:	036a0063          	beq	s4,s6,80000600 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005e4:	0149d933          	srl	s2,s3,s4
    800005e8:	1ff97913          	andi	s2,s2,511
    800005ec:	090e                	slli	s2,s2,0x3
    800005ee:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005f0:	00093483          	ld	s1,0(s2)
    800005f4:	0014f793          	andi	a5,s1,1
    800005f8:	dfd5                	beqz	a5,800005b4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005fa:	80a9                	srli	s1,s1,0xa
    800005fc:	04b2                	slli	s1,s1,0xc
    800005fe:	b7c5                	j	800005de <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000600:	00c9d513          	srli	a0,s3,0xc
    80000604:	1ff57513          	andi	a0,a0,511
    80000608:	050e                	slli	a0,a0,0x3
    8000060a:	9526                	add	a0,a0,s1
}
    8000060c:	70e2                	ld	ra,56(sp)
    8000060e:	7442                	ld	s0,48(sp)
    80000610:	74a2                	ld	s1,40(sp)
    80000612:	7902                	ld	s2,32(sp)
    80000614:	69e2                	ld	s3,24(sp)
    80000616:	6a42                	ld	s4,16(sp)
    80000618:	6aa2                	ld	s5,8(sp)
    8000061a:	6b02                	ld	s6,0(sp)
    8000061c:	6121                	addi	sp,sp,64
    8000061e:	8082                	ret
        return 0;
    80000620:	4501                	li	a0,0
    80000622:	b7ed                	j	8000060c <walk+0x8e>

0000000080000624 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000624:	57fd                	li	a5,-1
    80000626:	83e9                	srli	a5,a5,0x1a
    80000628:	00b7f463          	bgeu	a5,a1,80000630 <walkaddr+0xc>
    return 0;
    8000062c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000062e:	8082                	ret
{
    80000630:	1141                	addi	sp,sp,-16
    80000632:	e406                	sd	ra,8(sp)
    80000634:	e022                	sd	s0,0(sp)
    80000636:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000638:	4601                	li	a2,0
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	f44080e7          	jalr	-188(ra) # 8000057e <walk>
  if(pte == 0)
    80000642:	c105                	beqz	a0,80000662 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000644:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000646:	0117f693          	andi	a3,a5,17
    8000064a:	4745                	li	a4,17
    return 0;
    8000064c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000064e:	00e68663          	beq	a3,a4,8000065a <walkaddr+0x36>
}
    80000652:	60a2                	ld	ra,8(sp)
    80000654:	6402                	ld	s0,0(sp)
    80000656:	0141                	addi	sp,sp,16
    80000658:	8082                	ret
  pa = PTE2PA(*pte);
    8000065a:	00a7d513          	srli	a0,a5,0xa
    8000065e:	0532                	slli	a0,a0,0xc
  return pa;
    80000660:	bfcd                	j	80000652 <walkaddr+0x2e>
    return 0;
    80000662:	4501                	li	a0,0
    80000664:	b7fd                	j	80000652 <walkaddr+0x2e>

0000000080000666 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000666:	715d                	addi	sp,sp,-80
    80000668:	e486                	sd	ra,72(sp)
    8000066a:	e0a2                	sd	s0,64(sp)
    8000066c:	fc26                	sd	s1,56(sp)
    8000066e:	f84a                	sd	s2,48(sp)
    80000670:	f44e                	sd	s3,40(sp)
    80000672:	f052                	sd	s4,32(sp)
    80000674:	ec56                	sd	s5,24(sp)
    80000676:	e85a                	sd	s6,16(sp)
    80000678:	e45e                	sd	s7,8(sp)
    8000067a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000067c:	c205                	beqz	a2,8000069c <mappages+0x36>
    8000067e:	8aaa                	mv	s5,a0
    80000680:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000682:	77fd                	lui	a5,0xfffff
    80000684:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000688:	15fd                	addi	a1,a1,-1
    8000068a:	00c589b3          	add	s3,a1,a2
    8000068e:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000692:	8952                	mv	s2,s4
    80000694:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000698:	6b85                	lui	s7,0x1
    8000069a:	a015                	j	800006be <mappages+0x58>
    panic("mappages: size");
    8000069c:	00008517          	auipc	a0,0x8
    800006a0:	9bc50513          	addi	a0,a0,-1604 # 80008058 <etext+0x58>
    800006a4:	00006097          	auipc	ra,0x6
    800006a8:	b48080e7          	jalr	-1208(ra) # 800061ec <panic>
      panic("mappages: remap");
    800006ac:	00008517          	auipc	a0,0x8
    800006b0:	9bc50513          	addi	a0,a0,-1604 # 80008068 <etext+0x68>
    800006b4:	00006097          	auipc	ra,0x6
    800006b8:	b38080e7          	jalr	-1224(ra) # 800061ec <panic>
    a += PGSIZE;
    800006bc:	995e                	add	s2,s2,s7
  for(;;){
    800006be:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800006c2:	4605                	li	a2,1
    800006c4:	85ca                	mv	a1,s2
    800006c6:	8556                	mv	a0,s5
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	eb6080e7          	jalr	-330(ra) # 8000057e <walk>
    800006d0:	cd19                	beqz	a0,800006ee <mappages+0x88>
    if(*pte & PTE_V)
    800006d2:	611c                	ld	a5,0(a0)
    800006d4:	8b85                	andi	a5,a5,1
    800006d6:	fbf9                	bnez	a5,800006ac <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006d8:	80b1                	srli	s1,s1,0xc
    800006da:	04aa                	slli	s1,s1,0xa
    800006dc:	0164e4b3          	or	s1,s1,s6
    800006e0:	0014e493          	ori	s1,s1,1
    800006e4:	e104                	sd	s1,0(a0)
    if(a == last)
    800006e6:	fd391be3          	bne	s2,s3,800006bc <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800006ea:	4501                	li	a0,0
    800006ec:	a011                	j	800006f0 <mappages+0x8a>
      return -1;
    800006ee:	557d                	li	a0,-1
}
    800006f0:	60a6                	ld	ra,72(sp)
    800006f2:	6406                	ld	s0,64(sp)
    800006f4:	74e2                	ld	s1,56(sp)
    800006f6:	7942                	ld	s2,48(sp)
    800006f8:	79a2                	ld	s3,40(sp)
    800006fa:	7a02                	ld	s4,32(sp)
    800006fc:	6ae2                	ld	s5,24(sp)
    800006fe:	6b42                	ld	s6,16(sp)
    80000700:	6ba2                	ld	s7,8(sp)
    80000702:	6161                	addi	sp,sp,80
    80000704:	8082                	ret

0000000080000706 <kvmmap>:
{
    80000706:	1141                	addi	sp,sp,-16
    80000708:	e406                	sd	ra,8(sp)
    8000070a:	e022                	sd	s0,0(sp)
    8000070c:	0800                	addi	s0,sp,16
    8000070e:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000710:	86b2                	mv	a3,a2
    80000712:	863e                	mv	a2,a5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	f52080e7          	jalr	-174(ra) # 80000666 <mappages>
    8000071c:	e509                	bnez	a0,80000726 <kvmmap+0x20>
}
    8000071e:	60a2                	ld	ra,8(sp)
    80000720:	6402                	ld	s0,0(sp)
    80000722:	0141                	addi	sp,sp,16
    80000724:	8082                	ret
    panic("kvmmap");
    80000726:	00008517          	auipc	a0,0x8
    8000072a:	95250513          	addi	a0,a0,-1710 # 80008078 <etext+0x78>
    8000072e:	00006097          	auipc	ra,0x6
    80000732:	abe080e7          	jalr	-1346(ra) # 800061ec <panic>

0000000080000736 <kvmmake>:
{
    80000736:	1101                	addi	sp,sp,-32
    80000738:	ec06                	sd	ra,24(sp)
    8000073a:	e822                	sd	s0,16(sp)
    8000073c:	e426                	sd	s1,8(sp)
    8000073e:	e04a                	sd	s2,0(sp)
    80000740:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000742:	00000097          	auipc	ra,0x0
    80000746:	a3e080e7          	jalr	-1474(ra) # 80000180 <kalloc>
    8000074a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000074c:	6605                	lui	a2,0x1
    8000074e:	4581                	li	a1,0
    80000750:	00000097          	auipc	ra,0x0
    80000754:	b36080e7          	jalr	-1226(ra) # 80000286 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000758:	4719                	li	a4,6
    8000075a:	6685                	lui	a3,0x1
    8000075c:	10000637          	lui	a2,0x10000
    80000760:	100005b7          	lui	a1,0x10000
    80000764:	8526                	mv	a0,s1
    80000766:	00000097          	auipc	ra,0x0
    8000076a:	fa0080e7          	jalr	-96(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000076e:	4719                	li	a4,6
    80000770:	6685                	lui	a3,0x1
    80000772:	10001637          	lui	a2,0x10001
    80000776:	100015b7          	lui	a1,0x10001
    8000077a:	8526                	mv	a0,s1
    8000077c:	00000097          	auipc	ra,0x0
    80000780:	f8a080e7          	jalr	-118(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000784:	4719                	li	a4,6
    80000786:	004006b7          	lui	a3,0x400
    8000078a:	0c000637          	lui	a2,0xc000
    8000078e:	0c0005b7          	lui	a1,0xc000
    80000792:	8526                	mv	a0,s1
    80000794:	00000097          	auipc	ra,0x0
    80000798:	f72080e7          	jalr	-142(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000079c:	00008917          	auipc	s2,0x8
    800007a0:	86490913          	addi	s2,s2,-1948 # 80008000 <etext>
    800007a4:	4729                	li	a4,10
    800007a6:	80008697          	auipc	a3,0x80008
    800007aa:	85a68693          	addi	a3,a3,-1958 # 8000 <_entry-0x7fff8000>
    800007ae:	4605                	li	a2,1
    800007b0:	067e                	slli	a2,a2,0x1f
    800007b2:	85b2                	mv	a1,a2
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	f50080e7          	jalr	-176(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007be:	4719                	li	a4,6
    800007c0:	46c5                	li	a3,17
    800007c2:	06ee                	slli	a3,a3,0x1b
    800007c4:	412686b3          	sub	a3,a3,s2
    800007c8:	864a                	mv	a2,s2
    800007ca:	85ca                	mv	a1,s2
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	f38080e7          	jalr	-200(ra) # 80000706 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007d6:	4729                	li	a4,10
    800007d8:	6685                	lui	a3,0x1
    800007da:	00007617          	auipc	a2,0x7
    800007de:	82660613          	addi	a2,a2,-2010 # 80007000 <_trampoline>
    800007e2:	040005b7          	lui	a1,0x4000
    800007e6:	15fd                	addi	a1,a1,-1
    800007e8:	05b2                	slli	a1,a1,0xc
    800007ea:	8526                	mv	a0,s1
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	f1a080e7          	jalr	-230(ra) # 80000706 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007f4:	8526                	mv	a0,s1
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	5fe080e7          	jalr	1534(ra) # 80000df4 <proc_mapstacks>
}
    800007fe:	8526                	mv	a0,s1
    80000800:	60e2                	ld	ra,24(sp)
    80000802:	6442                	ld	s0,16(sp)
    80000804:	64a2                	ld	s1,8(sp)
    80000806:	6902                	ld	s2,0(sp)
    80000808:	6105                	addi	sp,sp,32
    8000080a:	8082                	ret

000000008000080c <kvminit>:
{
    8000080c:	1141                	addi	sp,sp,-16
    8000080e:	e406                	sd	ra,8(sp)
    80000810:	e022                	sd	s0,0(sp)
    80000812:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000814:	00000097          	auipc	ra,0x0
    80000818:	f22080e7          	jalr	-222(ra) # 80000736 <kvmmake>
    8000081c:	00008797          	auipc	a5,0x8
    80000820:	7ea7b623          	sd	a0,2028(a5) # 80009008 <kernel_pagetable>
}
    80000824:	60a2                	ld	ra,8(sp)
    80000826:	6402                	ld	s0,0(sp)
    80000828:	0141                	addi	sp,sp,16
    8000082a:	8082                	ret

000000008000082c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000082c:	715d                	addi	sp,sp,-80
    8000082e:	e486                	sd	ra,72(sp)
    80000830:	e0a2                	sd	s0,64(sp)
    80000832:	fc26                	sd	s1,56(sp)
    80000834:	f84a                	sd	s2,48(sp)
    80000836:	f44e                	sd	s3,40(sp)
    80000838:	f052                	sd	s4,32(sp)
    8000083a:	ec56                	sd	s5,24(sp)
    8000083c:	e85a                	sd	s6,16(sp)
    8000083e:	e45e                	sd	s7,8(sp)
    80000840:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000842:	03459793          	slli	a5,a1,0x34
    80000846:	e795                	bnez	a5,80000872 <uvmunmap+0x46>
    80000848:	8a2a                	mv	s4,a0
    8000084a:	892e                	mv	s2,a1
    8000084c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000084e:	0632                	slli	a2,a2,0xc
    80000850:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000854:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000856:	6b05                	lui	s6,0x1
    80000858:	0735e863          	bltu	a1,s3,800008c8 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000085c:	60a6                	ld	ra,72(sp)
    8000085e:	6406                	ld	s0,64(sp)
    80000860:	74e2                	ld	s1,56(sp)
    80000862:	7942                	ld	s2,48(sp)
    80000864:	79a2                	ld	s3,40(sp)
    80000866:	7a02                	ld	s4,32(sp)
    80000868:	6ae2                	ld	s5,24(sp)
    8000086a:	6b42                	ld	s6,16(sp)
    8000086c:	6ba2                	ld	s7,8(sp)
    8000086e:	6161                	addi	sp,sp,80
    80000870:	8082                	ret
    panic("uvmunmap: not aligned");
    80000872:	00008517          	auipc	a0,0x8
    80000876:	80e50513          	addi	a0,a0,-2034 # 80008080 <etext+0x80>
    8000087a:	00006097          	auipc	ra,0x6
    8000087e:	972080e7          	jalr	-1678(ra) # 800061ec <panic>
      panic("uvmunmap: walk");
    80000882:	00008517          	auipc	a0,0x8
    80000886:	81650513          	addi	a0,a0,-2026 # 80008098 <etext+0x98>
    8000088a:	00006097          	auipc	ra,0x6
    8000088e:	962080e7          	jalr	-1694(ra) # 800061ec <panic>
      panic("uvmunmap: not mapped");
    80000892:	00008517          	auipc	a0,0x8
    80000896:	81650513          	addi	a0,a0,-2026 # 800080a8 <etext+0xa8>
    8000089a:	00006097          	auipc	ra,0x6
    8000089e:	952080e7          	jalr	-1710(ra) # 800061ec <panic>
      panic("uvmunmap: not a leaf");
    800008a2:	00008517          	auipc	a0,0x8
    800008a6:	81e50513          	addi	a0,a0,-2018 # 800080c0 <etext+0xc0>
    800008aa:	00006097          	auipc	ra,0x6
    800008ae:	942080e7          	jalr	-1726(ra) # 800061ec <panic>
      uint64 pa = PTE2PA(*pte);
    800008b2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008b4:	0532                	slli	a0,a0,0xc
    800008b6:	fffff097          	auipc	ra,0xfffff
    800008ba:	766080e7          	jalr	1894(ra) # 8000001c <kfree>
    *pte = 0;
    800008be:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008c2:	995a                	add	s2,s2,s6
    800008c4:	f9397ce3          	bgeu	s2,s3,8000085c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008c8:	4601                	li	a2,0
    800008ca:	85ca                	mv	a1,s2
    800008cc:	8552                	mv	a0,s4
    800008ce:	00000097          	auipc	ra,0x0
    800008d2:	cb0080e7          	jalr	-848(ra) # 8000057e <walk>
    800008d6:	84aa                	mv	s1,a0
    800008d8:	d54d                	beqz	a0,80000882 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008da:	6108                	ld	a0,0(a0)
    800008dc:	00157793          	andi	a5,a0,1
    800008e0:	dbcd                	beqz	a5,80000892 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008e2:	3ff57793          	andi	a5,a0,1023
    800008e6:	fb778ee3          	beq	a5,s7,800008a2 <uvmunmap+0x76>
    if(do_free){
    800008ea:	fc0a8ae3          	beqz	s5,800008be <uvmunmap+0x92>
    800008ee:	b7d1                	j	800008b2 <uvmunmap+0x86>

00000000800008f0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008f0:	1101                	addi	sp,sp,-32
    800008f2:	ec06                	sd	ra,24(sp)
    800008f4:	e822                	sd	s0,16(sp)
    800008f6:	e426                	sd	s1,8(sp)
    800008f8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	886080e7          	jalr	-1914(ra) # 80000180 <kalloc>
    80000902:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000904:	c519                	beqz	a0,80000912 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000906:	6605                	lui	a2,0x1
    80000908:	4581                	li	a1,0
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	97c080e7          	jalr	-1668(ra) # 80000286 <memset>
  return pagetable;
}
    80000912:	8526                	mv	a0,s1
    80000914:	60e2                	ld	ra,24(sp)
    80000916:	6442                	ld	s0,16(sp)
    80000918:	64a2                	ld	s1,8(sp)
    8000091a:	6105                	addi	sp,sp,32
    8000091c:	8082                	ret

000000008000091e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000092e:	6785                	lui	a5,0x1
    80000930:	04f67863          	bgeu	a2,a5,80000980 <uvminit+0x62>
    80000934:	8a2a                	mv	s4,a0
    80000936:	89ae                	mv	s3,a1
    80000938:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	846080e7          	jalr	-1978(ra) # 80000180 <kalloc>
    80000942:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000944:	6605                	lui	a2,0x1
    80000946:	4581                	li	a1,0
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	93e080e7          	jalr	-1730(ra) # 80000286 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000950:	4779                	li	a4,30
    80000952:	86ca                	mv	a3,s2
    80000954:	6605                	lui	a2,0x1
    80000956:	4581                	li	a1,0
    80000958:	8552                	mv	a0,s4
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	d0c080e7          	jalr	-756(ra) # 80000666 <mappages>
  memmove(mem, src, sz);
    80000962:	8626                	mv	a2,s1
    80000964:	85ce                	mv	a1,s3
    80000966:	854a                	mv	a0,s2
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	97e080e7          	jalr	-1666(ra) # 800002e6 <memmove>
}
    80000970:	70a2                	ld	ra,40(sp)
    80000972:	7402                	ld	s0,32(sp)
    80000974:	64e2                	ld	s1,24(sp)
    80000976:	6942                	ld	s2,16(sp)
    80000978:	69a2                	ld	s3,8(sp)
    8000097a:	6a02                	ld	s4,0(sp)
    8000097c:	6145                	addi	sp,sp,48
    8000097e:	8082                	ret
    panic("inituvm: more than a page");
    80000980:	00007517          	auipc	a0,0x7
    80000984:	75850513          	addi	a0,a0,1880 # 800080d8 <etext+0xd8>
    80000988:	00006097          	auipc	ra,0x6
    8000098c:	864080e7          	jalr	-1948(ra) # 800061ec <panic>

0000000080000990 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000990:	1101                	addi	sp,sp,-32
    80000992:	ec06                	sd	ra,24(sp)
    80000994:	e822                	sd	s0,16(sp)
    80000996:	e426                	sd	s1,8(sp)
    80000998:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000099a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000099c:	00b67d63          	bgeu	a2,a1,800009b6 <uvmdealloc+0x26>
    800009a0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009a2:	6785                	lui	a5,0x1
    800009a4:	17fd                	addi	a5,a5,-1
    800009a6:	00f60733          	add	a4,a2,a5
    800009aa:	767d                	lui	a2,0xfffff
    800009ac:	8f71                	and	a4,a4,a2
    800009ae:	97ae                	add	a5,a5,a1
    800009b0:	8ff1                	and	a5,a5,a2
    800009b2:	00f76863          	bltu	a4,a5,800009c2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009b6:	8526                	mv	a0,s1
    800009b8:	60e2                	ld	ra,24(sp)
    800009ba:	6442                	ld	s0,16(sp)
    800009bc:	64a2                	ld	s1,8(sp)
    800009be:	6105                	addi	sp,sp,32
    800009c0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009c2:	8f99                	sub	a5,a5,a4
    800009c4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009c6:	4685                	li	a3,1
    800009c8:	0007861b          	sext.w	a2,a5
    800009cc:	85ba                	mv	a1,a4
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e5e080e7          	jalr	-418(ra) # 8000082c <uvmunmap>
    800009d6:	b7c5                	j	800009b6 <uvmdealloc+0x26>

00000000800009d8 <uvmalloc>:
  if(newsz < oldsz)
    800009d8:	0ab66163          	bltu	a2,a1,80000a7a <uvmalloc+0xa2>
{
    800009dc:	7139                	addi	sp,sp,-64
    800009de:	fc06                	sd	ra,56(sp)
    800009e0:	f822                	sd	s0,48(sp)
    800009e2:	f426                	sd	s1,40(sp)
    800009e4:	f04a                	sd	s2,32(sp)
    800009e6:	ec4e                	sd	s3,24(sp)
    800009e8:	e852                	sd	s4,16(sp)
    800009ea:	e456                	sd	s5,8(sp)
    800009ec:	0080                	addi	s0,sp,64
    800009ee:	8aaa                	mv	s5,a0
    800009f0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009f2:	6985                	lui	s3,0x1
    800009f4:	19fd                	addi	s3,s3,-1
    800009f6:	95ce                	add	a1,a1,s3
    800009f8:	79fd                	lui	s3,0xfffff
    800009fa:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009fe:	08c9f063          	bgeu	s3,a2,80000a7e <uvmalloc+0xa6>
    80000a02:	894e                	mv	s2,s3
    mem = kalloc();
    80000a04:	fffff097          	auipc	ra,0xfffff
    80000a08:	77c080e7          	jalr	1916(ra) # 80000180 <kalloc>
    80000a0c:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a0e:	c51d                	beqz	a0,80000a3c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a10:	6605                	lui	a2,0x1
    80000a12:	4581                	li	a1,0
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	872080e7          	jalr	-1934(ra) # 80000286 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a1c:	4779                	li	a4,30
    80000a1e:	86a6                	mv	a3,s1
    80000a20:	6605                	lui	a2,0x1
    80000a22:	85ca                	mv	a1,s2
    80000a24:	8556                	mv	a0,s5
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	c40080e7          	jalr	-960(ra) # 80000666 <mappages>
    80000a2e:	e905                	bnez	a0,80000a5e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a30:	6785                	lui	a5,0x1
    80000a32:	993e                	add	s2,s2,a5
    80000a34:	fd4968e3          	bltu	s2,s4,80000a04 <uvmalloc+0x2c>
  return newsz;
    80000a38:	8552                	mv	a0,s4
    80000a3a:	a809                	j	80000a4c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a3c:	864e                	mv	a2,s3
    80000a3e:	85ca                	mv	a1,s2
    80000a40:	8556                	mv	a0,s5
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	f4e080e7          	jalr	-178(ra) # 80000990 <uvmdealloc>
      return 0;
    80000a4a:	4501                	li	a0,0
}
    80000a4c:	70e2                	ld	ra,56(sp)
    80000a4e:	7442                	ld	s0,48(sp)
    80000a50:	74a2                	ld	s1,40(sp)
    80000a52:	7902                	ld	s2,32(sp)
    80000a54:	69e2                	ld	s3,24(sp)
    80000a56:	6a42                	ld	s4,16(sp)
    80000a58:	6aa2                	ld	s5,8(sp)
    80000a5a:	6121                	addi	sp,sp,64
    80000a5c:	8082                	ret
      kfree(mem);
    80000a5e:	8526                	mv	a0,s1
    80000a60:	fffff097          	auipc	ra,0xfffff
    80000a64:	5bc080e7          	jalr	1468(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a68:	864e                	mv	a2,s3
    80000a6a:	85ca                	mv	a1,s2
    80000a6c:	8556                	mv	a0,s5
    80000a6e:	00000097          	auipc	ra,0x0
    80000a72:	f22080e7          	jalr	-222(ra) # 80000990 <uvmdealloc>
      return 0;
    80000a76:	4501                	li	a0,0
    80000a78:	bfd1                	j	80000a4c <uvmalloc+0x74>
    return oldsz;
    80000a7a:	852e                	mv	a0,a1
}
    80000a7c:	8082                	ret
  return newsz;
    80000a7e:	8532                	mv	a0,a2
    80000a80:	b7f1                	j	80000a4c <uvmalloc+0x74>

0000000080000a82 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a82:	7179                	addi	sp,sp,-48
    80000a84:	f406                	sd	ra,40(sp)
    80000a86:	f022                	sd	s0,32(sp)
    80000a88:	ec26                	sd	s1,24(sp)
    80000a8a:	e84a                	sd	s2,16(sp)
    80000a8c:	e44e                	sd	s3,8(sp)
    80000a8e:	e052                	sd	s4,0(sp)
    80000a90:	1800                	addi	s0,sp,48
    80000a92:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a94:	84aa                	mv	s1,a0
    80000a96:	6905                	lui	s2,0x1
    80000a98:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a9a:	4985                	li	s3,1
    80000a9c:	a821                	j	80000ab4 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a9e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000aa0:	0532                	slli	a0,a0,0xc
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	fe0080e7          	jalr	-32(ra) # 80000a82 <freewalk>
      pagetable[i] = 0;
    80000aaa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000aae:	04a1                	addi	s1,s1,8
    80000ab0:	03248163          	beq	s1,s2,80000ad2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000ab4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ab6:	00f57793          	andi	a5,a0,15
    80000aba:	ff3782e3          	beq	a5,s3,80000a9e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000abe:	8905                	andi	a0,a0,1
    80000ac0:	d57d                	beqz	a0,80000aae <freewalk+0x2c>
      panic("freewalk: leaf");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	63650513          	addi	a0,a0,1590 # 800080f8 <etext+0xf8>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	722080e7          	jalr	1826(ra) # 800061ec <panic>
    }
  }
  kfree((void*)pagetable);
    80000ad2:	8552                	mv	a0,s4
    80000ad4:	fffff097          	auipc	ra,0xfffff
    80000ad8:	548080e7          	jalr	1352(ra) # 8000001c <kfree>
}
    80000adc:	70a2                	ld	ra,40(sp)
    80000ade:	7402                	ld	s0,32(sp)
    80000ae0:	64e2                	ld	s1,24(sp)
    80000ae2:	6942                	ld	s2,16(sp)
    80000ae4:	69a2                	ld	s3,8(sp)
    80000ae6:	6a02                	ld	s4,0(sp)
    80000ae8:	6145                	addi	sp,sp,48
    80000aea:	8082                	ret

0000000080000aec <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000aec:	1101                	addi	sp,sp,-32
    80000aee:	ec06                	sd	ra,24(sp)
    80000af0:	e822                	sd	s0,16(sp)
    80000af2:	e426                	sd	s1,8(sp)
    80000af4:	1000                	addi	s0,sp,32
    80000af6:	84aa                	mv	s1,a0
  if(sz > 0)
    80000af8:	e999                	bnez	a1,80000b0e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000afa:	8526                	mv	a0,s1
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	f86080e7          	jalr	-122(ra) # 80000a82 <freewalk>
}
    80000b04:	60e2                	ld	ra,24(sp)
    80000b06:	6442                	ld	s0,16(sp)
    80000b08:	64a2                	ld	s1,8(sp)
    80000b0a:	6105                	addi	sp,sp,32
    80000b0c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b0e:	6605                	lui	a2,0x1
    80000b10:	167d                	addi	a2,a2,-1
    80000b12:	962e                	add	a2,a2,a1
    80000b14:	4685                	li	a3,1
    80000b16:	8231                	srli	a2,a2,0xc
    80000b18:	4581                	li	a1,0
    80000b1a:	00000097          	auipc	ra,0x0
    80000b1e:	d12080e7          	jalr	-750(ra) # 8000082c <uvmunmap>
    80000b22:	bfe1                	j	80000afa <uvmfree+0xe>

0000000080000b24 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b24:	c679                	beqz	a2,80000bf2 <uvmcopy+0xce>
{
    80000b26:	715d                	addi	sp,sp,-80
    80000b28:	e486                	sd	ra,72(sp)
    80000b2a:	e0a2                	sd	s0,64(sp)
    80000b2c:	fc26                	sd	s1,56(sp)
    80000b2e:	f84a                	sd	s2,48(sp)
    80000b30:	f44e                	sd	s3,40(sp)
    80000b32:	f052                	sd	s4,32(sp)
    80000b34:	ec56                	sd	s5,24(sp)
    80000b36:	e85a                	sd	s6,16(sp)
    80000b38:	e45e                	sd	s7,8(sp)
    80000b3a:	0880                	addi	s0,sp,80
    80000b3c:	8b2a                	mv	s6,a0
    80000b3e:	8aae                	mv	s5,a1
    80000b40:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b42:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b44:	4601                	li	a2,0
    80000b46:	85ce                	mv	a1,s3
    80000b48:	855a                	mv	a0,s6
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	a34080e7          	jalr	-1484(ra) # 8000057e <walk>
    80000b52:	c531                	beqz	a0,80000b9e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b54:	6118                	ld	a4,0(a0)
    80000b56:	00177793          	andi	a5,a4,1
    80000b5a:	cbb1                	beqz	a5,80000bae <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b5c:	00a75593          	srli	a1,a4,0xa
    80000b60:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b64:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b68:	fffff097          	auipc	ra,0xfffff
    80000b6c:	618080e7          	jalr	1560(ra) # 80000180 <kalloc>
    80000b70:	892a                	mv	s2,a0
    80000b72:	c939                	beqz	a0,80000bc8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b74:	6605                	lui	a2,0x1
    80000b76:	85de                	mv	a1,s7
    80000b78:	fffff097          	auipc	ra,0xfffff
    80000b7c:	76e080e7          	jalr	1902(ra) # 800002e6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b80:	8726                	mv	a4,s1
    80000b82:	86ca                	mv	a3,s2
    80000b84:	6605                	lui	a2,0x1
    80000b86:	85ce                	mv	a1,s3
    80000b88:	8556                	mv	a0,s5
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	adc080e7          	jalr	-1316(ra) # 80000666 <mappages>
    80000b92:	e515                	bnez	a0,80000bbe <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b94:	6785                	lui	a5,0x1
    80000b96:	99be                	add	s3,s3,a5
    80000b98:	fb49e6e3          	bltu	s3,s4,80000b44 <uvmcopy+0x20>
    80000b9c:	a081                	j	80000bdc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b9e:	00007517          	auipc	a0,0x7
    80000ba2:	56a50513          	addi	a0,a0,1386 # 80008108 <etext+0x108>
    80000ba6:	00005097          	auipc	ra,0x5
    80000baa:	646080e7          	jalr	1606(ra) # 800061ec <panic>
      panic("uvmcopy: page not present");
    80000bae:	00007517          	auipc	a0,0x7
    80000bb2:	57a50513          	addi	a0,a0,1402 # 80008128 <etext+0x128>
    80000bb6:	00005097          	auipc	ra,0x5
    80000bba:	636080e7          	jalr	1590(ra) # 800061ec <panic>
      kfree(mem);
    80000bbe:	854a                	mv	a0,s2
    80000bc0:	fffff097          	auipc	ra,0xfffff
    80000bc4:	45c080e7          	jalr	1116(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bc8:	4685                	li	a3,1
    80000bca:	00c9d613          	srli	a2,s3,0xc
    80000bce:	4581                	li	a1,0
    80000bd0:	8556                	mv	a0,s5
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	c5a080e7          	jalr	-934(ra) # 8000082c <uvmunmap>
  return -1;
    80000bda:	557d                	li	a0,-1
}
    80000bdc:	60a6                	ld	ra,72(sp)
    80000bde:	6406                	ld	s0,64(sp)
    80000be0:	74e2                	ld	s1,56(sp)
    80000be2:	7942                	ld	s2,48(sp)
    80000be4:	79a2                	ld	s3,40(sp)
    80000be6:	7a02                	ld	s4,32(sp)
    80000be8:	6ae2                	ld	s5,24(sp)
    80000bea:	6b42                	ld	s6,16(sp)
    80000bec:	6ba2                	ld	s7,8(sp)
    80000bee:	6161                	addi	sp,sp,80
    80000bf0:	8082                	ret
  return 0;
    80000bf2:	4501                	li	a0,0
}
    80000bf4:	8082                	ret

0000000080000bf6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bf6:	1141                	addi	sp,sp,-16
    80000bf8:	e406                	sd	ra,8(sp)
    80000bfa:	e022                	sd	s0,0(sp)
    80000bfc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bfe:	4601                	li	a2,0
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	97e080e7          	jalr	-1666(ra) # 8000057e <walk>
  if(pte == 0)
    80000c08:	c901                	beqz	a0,80000c18 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c0a:	611c                	ld	a5,0(a0)
    80000c0c:	9bbd                	andi	a5,a5,-17
    80000c0e:	e11c                	sd	a5,0(a0)
}
    80000c10:	60a2                	ld	ra,8(sp)
    80000c12:	6402                	ld	s0,0(sp)
    80000c14:	0141                	addi	sp,sp,16
    80000c16:	8082                	ret
    panic("uvmclear");
    80000c18:	00007517          	auipc	a0,0x7
    80000c1c:	53050513          	addi	a0,a0,1328 # 80008148 <etext+0x148>
    80000c20:	00005097          	auipc	ra,0x5
    80000c24:	5cc080e7          	jalr	1484(ra) # 800061ec <panic>

0000000080000c28 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c28:	c6bd                	beqz	a3,80000c96 <copyout+0x6e>
{
    80000c2a:	715d                	addi	sp,sp,-80
    80000c2c:	e486                	sd	ra,72(sp)
    80000c2e:	e0a2                	sd	s0,64(sp)
    80000c30:	fc26                	sd	s1,56(sp)
    80000c32:	f84a                	sd	s2,48(sp)
    80000c34:	f44e                	sd	s3,40(sp)
    80000c36:	f052                	sd	s4,32(sp)
    80000c38:	ec56                	sd	s5,24(sp)
    80000c3a:	e85a                	sd	s6,16(sp)
    80000c3c:	e45e                	sd	s7,8(sp)
    80000c3e:	e062                	sd	s8,0(sp)
    80000c40:	0880                	addi	s0,sp,80
    80000c42:	8b2a                	mv	s6,a0
    80000c44:	8c2e                	mv	s8,a1
    80000c46:	8a32                	mv	s4,a2
    80000c48:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c4a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c4c:	6a85                	lui	s5,0x1
    80000c4e:	a015                	j	80000c72 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c50:	9562                	add	a0,a0,s8
    80000c52:	0004861b          	sext.w	a2,s1
    80000c56:	85d2                	mv	a1,s4
    80000c58:	41250533          	sub	a0,a0,s2
    80000c5c:	fffff097          	auipc	ra,0xfffff
    80000c60:	68a080e7          	jalr	1674(ra) # 800002e6 <memmove>

    len -= n;
    80000c64:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c68:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c6a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c6e:	02098263          	beqz	s3,80000c92 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c72:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	855a                	mv	a0,s6
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	9aa080e7          	jalr	-1622(ra) # 80000624 <walkaddr>
    if(pa0 == 0)
    80000c82:	cd01                	beqz	a0,80000c9a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c84:	418904b3          	sub	s1,s2,s8
    80000c88:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c8a:	fc99f3e3          	bgeu	s3,s1,80000c50 <copyout+0x28>
    80000c8e:	84ce                	mv	s1,s3
    80000c90:	b7c1                	j	80000c50 <copyout+0x28>
  }
  return 0;
    80000c92:	4501                	li	a0,0
    80000c94:	a021                	j	80000c9c <copyout+0x74>
    80000c96:	4501                	li	a0,0
}
    80000c98:	8082                	ret
      return -1;
    80000c9a:	557d                	li	a0,-1
}
    80000c9c:	60a6                	ld	ra,72(sp)
    80000c9e:	6406                	ld	s0,64(sp)
    80000ca0:	74e2                	ld	s1,56(sp)
    80000ca2:	7942                	ld	s2,48(sp)
    80000ca4:	79a2                	ld	s3,40(sp)
    80000ca6:	7a02                	ld	s4,32(sp)
    80000ca8:	6ae2                	ld	s5,24(sp)
    80000caa:	6b42                	ld	s6,16(sp)
    80000cac:	6ba2                	ld	s7,8(sp)
    80000cae:	6c02                	ld	s8,0(sp)
    80000cb0:	6161                	addi	sp,sp,80
    80000cb2:	8082                	ret

0000000080000cb4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cb4:	c6bd                	beqz	a3,80000d22 <copyin+0x6e>
{
    80000cb6:	715d                	addi	sp,sp,-80
    80000cb8:	e486                	sd	ra,72(sp)
    80000cba:	e0a2                	sd	s0,64(sp)
    80000cbc:	fc26                	sd	s1,56(sp)
    80000cbe:	f84a                	sd	s2,48(sp)
    80000cc0:	f44e                	sd	s3,40(sp)
    80000cc2:	f052                	sd	s4,32(sp)
    80000cc4:	ec56                	sd	s5,24(sp)
    80000cc6:	e85a                	sd	s6,16(sp)
    80000cc8:	e45e                	sd	s7,8(sp)
    80000cca:	e062                	sd	s8,0(sp)
    80000ccc:	0880                	addi	s0,sp,80
    80000cce:	8b2a                	mv	s6,a0
    80000cd0:	8a2e                	mv	s4,a1
    80000cd2:	8c32                	mv	s8,a2
    80000cd4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cd8:	6a85                	lui	s5,0x1
    80000cda:	a015                	j	80000cfe <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cdc:	9562                	add	a0,a0,s8
    80000cde:	0004861b          	sext.w	a2,s1
    80000ce2:	412505b3          	sub	a1,a0,s2
    80000ce6:	8552                	mv	a0,s4
    80000ce8:	fffff097          	auipc	ra,0xfffff
    80000cec:	5fe080e7          	jalr	1534(ra) # 800002e6 <memmove>

    len -= n;
    80000cf0:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cf4:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cf6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cfa:	02098263          	beqz	s3,80000d1e <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000cfe:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d02:	85ca                	mv	a1,s2
    80000d04:	855a                	mv	a0,s6
    80000d06:	00000097          	auipc	ra,0x0
    80000d0a:	91e080e7          	jalr	-1762(ra) # 80000624 <walkaddr>
    if(pa0 == 0)
    80000d0e:	cd01                	beqz	a0,80000d26 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d10:	418904b3          	sub	s1,s2,s8
    80000d14:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d16:	fc99f3e3          	bgeu	s3,s1,80000cdc <copyin+0x28>
    80000d1a:	84ce                	mv	s1,s3
    80000d1c:	b7c1                	j	80000cdc <copyin+0x28>
  }
  return 0;
    80000d1e:	4501                	li	a0,0
    80000d20:	a021                	j	80000d28 <copyin+0x74>
    80000d22:	4501                	li	a0,0
}
    80000d24:	8082                	ret
      return -1;
    80000d26:	557d                	li	a0,-1
}
    80000d28:	60a6                	ld	ra,72(sp)
    80000d2a:	6406                	ld	s0,64(sp)
    80000d2c:	74e2                	ld	s1,56(sp)
    80000d2e:	7942                	ld	s2,48(sp)
    80000d30:	79a2                	ld	s3,40(sp)
    80000d32:	7a02                	ld	s4,32(sp)
    80000d34:	6ae2                	ld	s5,24(sp)
    80000d36:	6b42                	ld	s6,16(sp)
    80000d38:	6ba2                	ld	s7,8(sp)
    80000d3a:	6c02                	ld	s8,0(sp)
    80000d3c:	6161                	addi	sp,sp,80
    80000d3e:	8082                	ret

0000000080000d40 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d40:	c6c5                	beqz	a3,80000de8 <copyinstr+0xa8>
{
    80000d42:	715d                	addi	sp,sp,-80
    80000d44:	e486                	sd	ra,72(sp)
    80000d46:	e0a2                	sd	s0,64(sp)
    80000d48:	fc26                	sd	s1,56(sp)
    80000d4a:	f84a                	sd	s2,48(sp)
    80000d4c:	f44e                	sd	s3,40(sp)
    80000d4e:	f052                	sd	s4,32(sp)
    80000d50:	ec56                	sd	s5,24(sp)
    80000d52:	e85a                	sd	s6,16(sp)
    80000d54:	e45e                	sd	s7,8(sp)
    80000d56:	0880                	addi	s0,sp,80
    80000d58:	8a2a                	mv	s4,a0
    80000d5a:	8b2e                	mv	s6,a1
    80000d5c:	8bb2                	mv	s7,a2
    80000d5e:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d60:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d62:	6985                	lui	s3,0x1
    80000d64:	a035                	j	80000d90 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d66:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d6a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d6c:	0017b793          	seqz	a5,a5
    80000d70:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d74:	60a6                	ld	ra,72(sp)
    80000d76:	6406                	ld	s0,64(sp)
    80000d78:	74e2                	ld	s1,56(sp)
    80000d7a:	7942                	ld	s2,48(sp)
    80000d7c:	79a2                	ld	s3,40(sp)
    80000d7e:	7a02                	ld	s4,32(sp)
    80000d80:	6ae2                	ld	s5,24(sp)
    80000d82:	6b42                	ld	s6,16(sp)
    80000d84:	6ba2                	ld	s7,8(sp)
    80000d86:	6161                	addi	sp,sp,80
    80000d88:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d8a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d8e:	c8a9                	beqz	s1,80000de0 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d90:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d94:	85ca                	mv	a1,s2
    80000d96:	8552                	mv	a0,s4
    80000d98:	00000097          	auipc	ra,0x0
    80000d9c:	88c080e7          	jalr	-1908(ra) # 80000624 <walkaddr>
    if(pa0 == 0)
    80000da0:	c131                	beqz	a0,80000de4 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000da2:	41790833          	sub	a6,s2,s7
    80000da6:	984e                	add	a6,a6,s3
    if(n > max)
    80000da8:	0104f363          	bgeu	s1,a6,80000dae <copyinstr+0x6e>
    80000dac:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000dae:	955e                	add	a0,a0,s7
    80000db0:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000db4:	fc080be3          	beqz	a6,80000d8a <copyinstr+0x4a>
    80000db8:	985a                	add	a6,a6,s6
    80000dba:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000dbc:	41650633          	sub	a2,a0,s6
    80000dc0:	14fd                	addi	s1,s1,-1
    80000dc2:	9b26                	add	s6,s6,s1
    80000dc4:	00f60733          	add	a4,a2,a5
    80000dc8:	00074703          	lbu	a4,0(a4)
    80000dcc:	df49                	beqz	a4,80000d66 <copyinstr+0x26>
        *dst = *p;
    80000dce:	00e78023          	sb	a4,0(a5)
      --max;
    80000dd2:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000dd6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000dd8:	ff0796e3          	bne	a5,a6,80000dc4 <copyinstr+0x84>
      dst++;
    80000ddc:	8b42                	mv	s6,a6
    80000dde:	b775                	j	80000d8a <copyinstr+0x4a>
    80000de0:	4781                	li	a5,0
    80000de2:	b769                	j	80000d6c <copyinstr+0x2c>
      return -1;
    80000de4:	557d                	li	a0,-1
    80000de6:	b779                	j	80000d74 <copyinstr+0x34>
  int got_null = 0;
    80000de8:	4781                	li	a5,0
  if(got_null){
    80000dea:	0017b793          	seqz	a5,a5
    80000dee:	40f00533          	neg	a0,a5
}
    80000df2:	8082                	ret

0000000080000df4 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000df4:	7139                	addi	sp,sp,-64
    80000df6:	fc06                	sd	ra,56(sp)
    80000df8:	f822                	sd	s0,48(sp)
    80000dfa:	f426                	sd	s1,40(sp)
    80000dfc:	f04a                	sd	s2,32(sp)
    80000dfe:	ec4e                	sd	s3,24(sp)
    80000e00:	e852                	sd	s4,16(sp)
    80000e02:	e456                	sd	s5,8(sp)
    80000e04:	e05a                	sd	s6,0(sp)
    80000e06:	0080                	addi	s0,sp,64
    80000e08:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	00008497          	auipc	s1,0x8
    80000e0e:	7a648493          	addi	s1,s1,1958 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e12:	8b26                	mv	s6,s1
    80000e14:	00007a97          	auipc	s5,0x7
    80000e18:	1eca8a93          	addi	s5,s5,492 # 80008000 <etext>
    80000e1c:	04000937          	lui	s2,0x4000
    80000e20:	197d                	addi	s2,s2,-1
    80000e22:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	0000ea17          	auipc	s4,0xe
    80000e28:	38ca0a13          	addi	s4,s4,908 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000e2c:	fffff097          	auipc	ra,0xfffff
    80000e30:	354080e7          	jalr	852(ra) # 80000180 <kalloc>
    80000e34:	862a                	mv	a2,a0
    if(pa == 0)
    80000e36:	c131                	beqz	a0,80000e7a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e38:	416485b3          	sub	a1,s1,s6
    80000e3c:	8591                	srai	a1,a1,0x4
    80000e3e:	000ab783          	ld	a5,0(s5)
    80000e42:	02f585b3          	mul	a1,a1,a5
    80000e46:	2585                	addiw	a1,a1,1
    80000e48:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e4c:	4719                	li	a4,6
    80000e4e:	6685                	lui	a3,0x1
    80000e50:	40b905b3          	sub	a1,s2,a1
    80000e54:	854e                	mv	a0,s3
    80000e56:	00000097          	auipc	ra,0x0
    80000e5a:	8b0080e7          	jalr	-1872(ra) # 80000706 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5e:	17048493          	addi	s1,s1,368
    80000e62:	fd4495e3          	bne	s1,s4,80000e2c <proc_mapstacks+0x38>
  }
}
    80000e66:	70e2                	ld	ra,56(sp)
    80000e68:	7442                	ld	s0,48(sp)
    80000e6a:	74a2                	ld	s1,40(sp)
    80000e6c:	7902                	ld	s2,32(sp)
    80000e6e:	69e2                	ld	s3,24(sp)
    80000e70:	6a42                	ld	s4,16(sp)
    80000e72:	6aa2                	ld	s5,8(sp)
    80000e74:	6b02                	ld	s6,0(sp)
    80000e76:	6121                	addi	sp,sp,64
    80000e78:	8082                	ret
      panic("kalloc");
    80000e7a:	00007517          	auipc	a0,0x7
    80000e7e:	2de50513          	addi	a0,a0,734 # 80008158 <etext+0x158>
    80000e82:	00005097          	auipc	ra,0x5
    80000e86:	36a080e7          	jalr	874(ra) # 800061ec <panic>

0000000080000e8a <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e8a:	7139                	addi	sp,sp,-64
    80000e8c:	fc06                	sd	ra,56(sp)
    80000e8e:	f822                	sd	s0,48(sp)
    80000e90:	f426                	sd	s1,40(sp)
    80000e92:	f04a                	sd	s2,32(sp)
    80000e94:	ec4e                	sd	s3,24(sp)
    80000e96:	e852                	sd	s4,16(sp)
    80000e98:	e456                	sd	s5,8(sp)
    80000e9a:	e05a                	sd	s6,0(sp)
    80000e9c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e9e:	00007597          	auipc	a1,0x7
    80000ea2:	2c258593          	addi	a1,a1,706 # 80008160 <etext+0x160>
    80000ea6:	00008517          	auipc	a0,0x8
    80000eaa:	2ca50513          	addi	a0,a0,714 # 80009170 <pid_lock>
    80000eae:	00006097          	auipc	ra,0x6
    80000eb2:	9ee080e7          	jalr	-1554(ra) # 8000689c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000eb6:	00007597          	auipc	a1,0x7
    80000eba:	2b258593          	addi	a1,a1,690 # 80008168 <etext+0x168>
    80000ebe:	00008517          	auipc	a0,0x8
    80000ec2:	2d250513          	addi	a0,a0,722 # 80009190 <wait_lock>
    80000ec6:	00006097          	auipc	ra,0x6
    80000eca:	9d6080e7          	jalr	-1578(ra) # 8000689c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ece:	00008497          	auipc	s1,0x8
    80000ed2:	6e248493          	addi	s1,s1,1762 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000ed6:	00007b17          	auipc	s6,0x7
    80000eda:	2a2b0b13          	addi	s6,s6,674 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000ede:	8aa6                	mv	s5,s1
    80000ee0:	00007a17          	auipc	s4,0x7
    80000ee4:	120a0a13          	addi	s4,s4,288 # 80008000 <etext>
    80000ee8:	04000937          	lui	s2,0x4000
    80000eec:	197d                	addi	s2,s2,-1
    80000eee:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef0:	0000e997          	auipc	s3,0xe
    80000ef4:	2c098993          	addi	s3,s3,704 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000ef8:	85da                	mv	a1,s6
    80000efa:	8526                	mv	a0,s1
    80000efc:	00006097          	auipc	ra,0x6
    80000f00:	9a0080e7          	jalr	-1632(ra) # 8000689c <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f04:	415487b3          	sub	a5,s1,s5
    80000f08:	8791                	srai	a5,a5,0x4
    80000f0a:	000a3703          	ld	a4,0(s4)
    80000f0e:	02e787b3          	mul	a5,a5,a4
    80000f12:	2785                	addiw	a5,a5,1
    80000f14:	00d7979b          	slliw	a5,a5,0xd
    80000f18:	40f907b3          	sub	a5,s2,a5
    80000f1c:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f1e:	17048493          	addi	s1,s1,368
    80000f22:	fd349be3          	bne	s1,s3,80000ef8 <procinit+0x6e>
  }
}
    80000f26:	70e2                	ld	ra,56(sp)
    80000f28:	7442                	ld	s0,48(sp)
    80000f2a:	74a2                	ld	s1,40(sp)
    80000f2c:	7902                	ld	s2,32(sp)
    80000f2e:	69e2                	ld	s3,24(sp)
    80000f30:	6a42                	ld	s4,16(sp)
    80000f32:	6aa2                	ld	s5,8(sp)
    80000f34:	6b02                	ld	s6,0(sp)
    80000f36:	6121                	addi	sp,sp,64
    80000f38:	8082                	ret

0000000080000f3a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f3a:	1141                	addi	sp,sp,-16
    80000f3c:	e422                	sd	s0,8(sp)
    80000f3e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f40:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f42:	2501                	sext.w	a0,a0
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f4a:	1141                	addi	sp,sp,-16
    80000f4c:	e422                	sd	s0,8(sp)
    80000f4e:	0800                	addi	s0,sp,16
    80000f50:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f56:	00008517          	auipc	a0,0x8
    80000f5a:	25a50513          	addi	a0,a0,602 # 800091b0 <cpus>
    80000f5e:	953e                	add	a0,a0,a5
    80000f60:	6422                	ld	s0,8(sp)
    80000f62:	0141                	addi	sp,sp,16
    80000f64:	8082                	ret

0000000080000f66 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f66:	1101                	addi	sp,sp,-32
    80000f68:	ec06                	sd	ra,24(sp)
    80000f6a:	e822                	sd	s0,16(sp)
    80000f6c:	e426                	sd	s1,8(sp)
    80000f6e:	1000                	addi	s0,sp,32
  push_off();
    80000f70:	00005097          	auipc	ra,0x5
    80000f74:	764080e7          	jalr	1892(ra) # 800066d4 <push_off>
    80000f78:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f7a:	2781                	sext.w	a5,a5
    80000f7c:	079e                	slli	a5,a5,0x7
    80000f7e:	00008717          	auipc	a4,0x8
    80000f82:	1f270713          	addi	a4,a4,498 # 80009170 <pid_lock>
    80000f86:	97ba                	add	a5,a5,a4
    80000f88:	63a4                	ld	s1,64(a5)
  pop_off();
    80000f8a:	00006097          	auipc	ra,0x6
    80000f8e:	806080e7          	jalr	-2042(ra) # 80006790 <pop_off>
  return p;
}
    80000f92:	8526                	mv	a0,s1
    80000f94:	60e2                	ld	ra,24(sp)
    80000f96:	6442                	ld	s0,16(sp)
    80000f98:	64a2                	ld	s1,8(sp)
    80000f9a:	6105                	addi	sp,sp,32
    80000f9c:	8082                	ret

0000000080000f9e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f9e:	1141                	addi	sp,sp,-16
    80000fa0:	e406                	sd	ra,8(sp)
    80000fa2:	e022                	sd	s0,0(sp)
    80000fa4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fa6:	00000097          	auipc	ra,0x0
    80000faa:	fc0080e7          	jalr	-64(ra) # 80000f66 <myproc>
    80000fae:	00006097          	auipc	ra,0x6
    80000fb2:	842080e7          	jalr	-1982(ra) # 800067f0 <release>

  if (first) {
    80000fb6:	00008797          	auipc	a5,0x8
    80000fba:	93a7a783          	lw	a5,-1734(a5) # 800088f0 <first.1688>
    80000fbe:	eb89                	bnez	a5,80000fd0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fc0:	00001097          	auipc	ra,0x1
    80000fc4:	c0a080e7          	jalr	-1014(ra) # 80001bca <usertrapret>
}
    80000fc8:	60a2                	ld	ra,8(sp)
    80000fca:	6402                	ld	s0,0(sp)
    80000fcc:	0141                	addi	sp,sp,16
    80000fce:	8082                	ret
    first = 0;
    80000fd0:	00008797          	auipc	a5,0x8
    80000fd4:	9207a023          	sw	zero,-1760(a5) # 800088f0 <first.1688>
    fsinit(ROOTDEV);
    80000fd8:	4505                	li	a0,1
    80000fda:	00002097          	auipc	ra,0x2
    80000fde:	ba4080e7          	jalr	-1116(ra) # 80002b7e <fsinit>
    80000fe2:	bff9                	j	80000fc0 <forkret+0x22>

0000000080000fe4 <allocpid>:
allocpid() {
    80000fe4:	1101                	addi	sp,sp,-32
    80000fe6:	ec06                	sd	ra,24(sp)
    80000fe8:	e822                	sd	s0,16(sp)
    80000fea:	e426                	sd	s1,8(sp)
    80000fec:	e04a                	sd	s2,0(sp)
    80000fee:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ff0:	00008917          	auipc	s2,0x8
    80000ff4:	18090913          	addi	s2,s2,384 # 80009170 <pid_lock>
    80000ff8:	854a                	mv	a0,s2
    80000ffa:	00005097          	auipc	ra,0x5
    80000ffe:	726080e7          	jalr	1830(ra) # 80006720 <acquire>
  pid = nextpid;
    80001002:	00008797          	auipc	a5,0x8
    80001006:	8f278793          	addi	a5,a5,-1806 # 800088f4 <nextpid>
    8000100a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000100c:	0014871b          	addiw	a4,s1,1
    80001010:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001012:	854a                	mv	a0,s2
    80001014:	00005097          	auipc	ra,0x5
    80001018:	7dc080e7          	jalr	2012(ra) # 800067f0 <release>
}
    8000101c:	8526                	mv	a0,s1
    8000101e:	60e2                	ld	ra,24(sp)
    80001020:	6442                	ld	s0,16(sp)
    80001022:	64a2                	ld	s1,8(sp)
    80001024:	6902                	ld	s2,0(sp)
    80001026:	6105                	addi	sp,sp,32
    80001028:	8082                	ret

000000008000102a <proc_pagetable>:
{
    8000102a:	1101                	addi	sp,sp,-32
    8000102c:	ec06                	sd	ra,24(sp)
    8000102e:	e822                	sd	s0,16(sp)
    80001030:	e426                	sd	s1,8(sp)
    80001032:	e04a                	sd	s2,0(sp)
    80001034:	1000                	addi	s0,sp,32
    80001036:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	8b8080e7          	jalr	-1864(ra) # 800008f0 <uvmcreate>
    80001040:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001042:	c121                	beqz	a0,80001082 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001044:	4729                	li	a4,10
    80001046:	00006697          	auipc	a3,0x6
    8000104a:	fba68693          	addi	a3,a3,-70 # 80007000 <_trampoline>
    8000104e:	6605                	lui	a2,0x1
    80001050:	040005b7          	lui	a1,0x4000
    80001054:	15fd                	addi	a1,a1,-1
    80001056:	05b2                	slli	a1,a1,0xc
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	60e080e7          	jalr	1550(ra) # 80000666 <mappages>
    80001060:	02054863          	bltz	a0,80001090 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001064:	4719                	li	a4,6
    80001066:	06093683          	ld	a3,96(s2)
    8000106a:	6605                	lui	a2,0x1
    8000106c:	020005b7          	lui	a1,0x2000
    80001070:	15fd                	addi	a1,a1,-1
    80001072:	05b6                	slli	a1,a1,0xd
    80001074:	8526                	mv	a0,s1
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	5f0080e7          	jalr	1520(ra) # 80000666 <mappages>
    8000107e:	02054163          	bltz	a0,800010a0 <proc_pagetable+0x76>
}
    80001082:	8526                	mv	a0,s1
    80001084:	60e2                	ld	ra,24(sp)
    80001086:	6442                	ld	s0,16(sp)
    80001088:	64a2                	ld	s1,8(sp)
    8000108a:	6902                	ld	s2,0(sp)
    8000108c:	6105                	addi	sp,sp,32
    8000108e:	8082                	ret
    uvmfree(pagetable, 0);
    80001090:	4581                	li	a1,0
    80001092:	8526                	mv	a0,s1
    80001094:	00000097          	auipc	ra,0x0
    80001098:	a58080e7          	jalr	-1448(ra) # 80000aec <uvmfree>
    return 0;
    8000109c:	4481                	li	s1,0
    8000109e:	b7d5                	j	80001082 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010a0:	4681                	li	a3,0
    800010a2:	4605                	li	a2,1
    800010a4:	040005b7          	lui	a1,0x4000
    800010a8:	15fd                	addi	a1,a1,-1
    800010aa:	05b2                	slli	a1,a1,0xc
    800010ac:	8526                	mv	a0,s1
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	77e080e7          	jalr	1918(ra) # 8000082c <uvmunmap>
    uvmfree(pagetable, 0);
    800010b6:	4581                	li	a1,0
    800010b8:	8526                	mv	a0,s1
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	a32080e7          	jalr	-1486(ra) # 80000aec <uvmfree>
    return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	bf7d                	j	80001082 <proc_pagetable+0x58>

00000000800010c6 <proc_freepagetable>:
{
    800010c6:	1101                	addi	sp,sp,-32
    800010c8:	ec06                	sd	ra,24(sp)
    800010ca:	e822                	sd	s0,16(sp)
    800010cc:	e426                	sd	s1,8(sp)
    800010ce:	e04a                	sd	s2,0(sp)
    800010d0:	1000                	addi	s0,sp,32
    800010d2:	84aa                	mv	s1,a0
    800010d4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010d6:	4681                	li	a3,0
    800010d8:	4605                	li	a2,1
    800010da:	040005b7          	lui	a1,0x4000
    800010de:	15fd                	addi	a1,a1,-1
    800010e0:	05b2                	slli	a1,a1,0xc
    800010e2:	fffff097          	auipc	ra,0xfffff
    800010e6:	74a080e7          	jalr	1866(ra) # 8000082c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010ea:	4681                	li	a3,0
    800010ec:	4605                	li	a2,1
    800010ee:	020005b7          	lui	a1,0x2000
    800010f2:	15fd                	addi	a1,a1,-1
    800010f4:	05b6                	slli	a1,a1,0xd
    800010f6:	8526                	mv	a0,s1
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	734080e7          	jalr	1844(ra) # 8000082c <uvmunmap>
  uvmfree(pagetable, sz);
    80001100:	85ca                	mv	a1,s2
    80001102:	8526                	mv	a0,s1
    80001104:	00000097          	auipc	ra,0x0
    80001108:	9e8080e7          	jalr	-1560(ra) # 80000aec <uvmfree>
}
    8000110c:	60e2                	ld	ra,24(sp)
    8000110e:	6442                	ld	s0,16(sp)
    80001110:	64a2                	ld	s1,8(sp)
    80001112:	6902                	ld	s2,0(sp)
    80001114:	6105                	addi	sp,sp,32
    80001116:	8082                	ret

0000000080001118 <freeproc>:
{
    80001118:	1101                	addi	sp,sp,-32
    8000111a:	ec06                	sd	ra,24(sp)
    8000111c:	e822                	sd	s0,16(sp)
    8000111e:	e426                	sd	s1,8(sp)
    80001120:	1000                	addi	s0,sp,32
    80001122:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001124:	7128                	ld	a0,96(a0)
    80001126:	c509                	beqz	a0,80001130 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001128:	fffff097          	auipc	ra,0xfffff
    8000112c:	ef4080e7          	jalr	-268(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001130:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001134:	6ca8                	ld	a0,88(s1)
    80001136:	c511                	beqz	a0,80001142 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001138:	68ac                	ld	a1,80(s1)
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	f8c080e7          	jalr	-116(ra) # 800010c6 <proc_freepagetable>
  p->pagetable = 0;
    80001142:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001146:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000114a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000114e:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001152:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001156:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000115a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000115e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001162:	0204a023          	sw	zero,32(s1)
}
    80001166:	60e2                	ld	ra,24(sp)
    80001168:	6442                	ld	s0,16(sp)
    8000116a:	64a2                	ld	s1,8(sp)
    8000116c:	6105                	addi	sp,sp,32
    8000116e:	8082                	ret

0000000080001170 <allocproc>:
{
    80001170:	1101                	addi	sp,sp,-32
    80001172:	ec06                	sd	ra,24(sp)
    80001174:	e822                	sd	s0,16(sp)
    80001176:	e426                	sd	s1,8(sp)
    80001178:	e04a                	sd	s2,0(sp)
    8000117a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000117c:	00008497          	auipc	s1,0x8
    80001180:	43448493          	addi	s1,s1,1076 # 800095b0 <proc>
    80001184:	0000e917          	auipc	s2,0xe
    80001188:	02c90913          	addi	s2,s2,44 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    8000118c:	8526                	mv	a0,s1
    8000118e:	00005097          	auipc	ra,0x5
    80001192:	592080e7          	jalr	1426(ra) # 80006720 <acquire>
    if(p->state == UNUSED) {
    80001196:	509c                	lw	a5,32(s1)
    80001198:	cf81                	beqz	a5,800011b0 <allocproc+0x40>
      release(&p->lock);
    8000119a:	8526                	mv	a0,s1
    8000119c:	00005097          	auipc	ra,0x5
    800011a0:	654080e7          	jalr	1620(ra) # 800067f0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011a4:	17048493          	addi	s1,s1,368
    800011a8:	ff2492e3          	bne	s1,s2,8000118c <allocproc+0x1c>
  return 0;
    800011ac:	4481                	li	s1,0
    800011ae:	a889                	j	80001200 <allocproc+0x90>
  p->pid = allocpid();
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	e34080e7          	jalr	-460(ra) # 80000fe4 <allocpid>
    800011b8:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011ba:	4785                	li	a5,1
    800011bc:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011be:	fffff097          	auipc	ra,0xfffff
    800011c2:	fc2080e7          	jalr	-62(ra) # 80000180 <kalloc>
    800011c6:	892a                	mv	s2,a0
    800011c8:	f0a8                	sd	a0,96(s1)
    800011ca:	c131                	beqz	a0,8000120e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011cc:	8526                	mv	a0,s1
    800011ce:	00000097          	auipc	ra,0x0
    800011d2:	e5c080e7          	jalr	-420(ra) # 8000102a <proc_pagetable>
    800011d6:	892a                	mv	s2,a0
    800011d8:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011da:	c531                	beqz	a0,80001226 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011dc:	07000613          	li	a2,112
    800011e0:	4581                	li	a1,0
    800011e2:	06848513          	addi	a0,s1,104
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	0a0080e7          	jalr	160(ra) # 80000286 <memset>
  p->context.ra = (uint64)forkret;
    800011ee:	00000797          	auipc	a5,0x0
    800011f2:	db078793          	addi	a5,a5,-592 # 80000f9e <forkret>
    800011f6:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800011f8:	64bc                	ld	a5,72(s1)
    800011fa:	6705                	lui	a4,0x1
    800011fc:	97ba                	add	a5,a5,a4
    800011fe:	f8bc                	sd	a5,112(s1)
}
    80001200:	8526                	mv	a0,s1
    80001202:	60e2                	ld	ra,24(sp)
    80001204:	6442                	ld	s0,16(sp)
    80001206:	64a2                	ld	s1,8(sp)
    80001208:	6902                	ld	s2,0(sp)
    8000120a:	6105                	addi	sp,sp,32
    8000120c:	8082                	ret
    freeproc(p);
    8000120e:	8526                	mv	a0,s1
    80001210:	00000097          	auipc	ra,0x0
    80001214:	f08080e7          	jalr	-248(ra) # 80001118 <freeproc>
    release(&p->lock);
    80001218:	8526                	mv	a0,s1
    8000121a:	00005097          	auipc	ra,0x5
    8000121e:	5d6080e7          	jalr	1494(ra) # 800067f0 <release>
    return 0;
    80001222:	84ca                	mv	s1,s2
    80001224:	bff1                	j	80001200 <allocproc+0x90>
    freeproc(p);
    80001226:	8526                	mv	a0,s1
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	ef0080e7          	jalr	-272(ra) # 80001118 <freeproc>
    release(&p->lock);
    80001230:	8526                	mv	a0,s1
    80001232:	00005097          	auipc	ra,0x5
    80001236:	5be080e7          	jalr	1470(ra) # 800067f0 <release>
    return 0;
    8000123a:	84ca                	mv	s1,s2
    8000123c:	b7d1                	j	80001200 <allocproc+0x90>

000000008000123e <userinit>:
{
    8000123e:	1101                	addi	sp,sp,-32
    80001240:	ec06                	sd	ra,24(sp)
    80001242:	e822                	sd	s0,16(sp)
    80001244:	e426                	sd	s1,8(sp)
    80001246:	1000                	addi	s0,sp,32
  p = allocproc();
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f28080e7          	jalr	-216(ra) # 80001170 <allocproc>
    80001250:	84aa                	mv	s1,a0
  initproc = p;
    80001252:	00008797          	auipc	a5,0x8
    80001256:	daa7bf23          	sd	a0,-578(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000125a:	03400613          	li	a2,52
    8000125e:	00007597          	auipc	a1,0x7
    80001262:	6a258593          	addi	a1,a1,1698 # 80008900 <initcode>
    80001266:	6d28                	ld	a0,88(a0)
    80001268:	fffff097          	auipc	ra,0xfffff
    8000126c:	6b6080e7          	jalr	1718(ra) # 8000091e <uvminit>
  p->sz = PGSIZE;
    80001270:	6785                	lui	a5,0x1
    80001272:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001274:	70b8                	ld	a4,96(s1)
    80001276:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000127a:	70b8                	ld	a4,96(s1)
    8000127c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000127e:	4641                	li	a2,16
    80001280:	00007597          	auipc	a1,0x7
    80001284:	f0058593          	addi	a1,a1,-256 # 80008180 <etext+0x180>
    80001288:	16048513          	addi	a0,s1,352
    8000128c:	fffff097          	auipc	ra,0xfffff
    80001290:	14c080e7          	jalr	332(ra) # 800003d8 <safestrcpy>
  p->cwd = namei("/");
    80001294:	00007517          	auipc	a0,0x7
    80001298:	efc50513          	addi	a0,a0,-260 # 80008190 <etext+0x190>
    8000129c:	00002097          	auipc	ra,0x2
    800012a0:	310080e7          	jalr	784(ra) # 800035ac <namei>
    800012a4:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012a8:	478d                	li	a5,3
    800012aa:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800012ac:	8526                	mv	a0,s1
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	542080e7          	jalr	1346(ra) # 800067f0 <release>
}
    800012b6:	60e2                	ld	ra,24(sp)
    800012b8:	6442                	ld	s0,16(sp)
    800012ba:	64a2                	ld	s1,8(sp)
    800012bc:	6105                	addi	sp,sp,32
    800012be:	8082                	ret

00000000800012c0 <growproc>:
{
    800012c0:	1101                	addi	sp,sp,-32
    800012c2:	ec06                	sd	ra,24(sp)
    800012c4:	e822                	sd	s0,16(sp)
    800012c6:	e426                	sd	s1,8(sp)
    800012c8:	e04a                	sd	s2,0(sp)
    800012ca:	1000                	addi	s0,sp,32
    800012cc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	c98080e7          	jalr	-872(ra) # 80000f66 <myproc>
    800012d6:	892a                	mv	s2,a0
  sz = p->sz;
    800012d8:	692c                	ld	a1,80(a0)
    800012da:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800012de:	00904f63          	bgtz	s1,800012fc <growproc+0x3c>
  } else if(n < 0){
    800012e2:	0204cc63          	bltz	s1,8000131a <growproc+0x5a>
  p->sz = sz;
    800012e6:	1602                	slli	a2,a2,0x20
    800012e8:	9201                	srli	a2,a2,0x20
    800012ea:	04c93823          	sd	a2,80(s2)
  return 0;
    800012ee:	4501                	li	a0,0
}
    800012f0:	60e2                	ld	ra,24(sp)
    800012f2:	6442                	ld	s0,16(sp)
    800012f4:	64a2                	ld	s1,8(sp)
    800012f6:	6902                	ld	s2,0(sp)
    800012f8:	6105                	addi	sp,sp,32
    800012fa:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800012fc:	9e25                	addw	a2,a2,s1
    800012fe:	1602                	slli	a2,a2,0x20
    80001300:	9201                	srli	a2,a2,0x20
    80001302:	1582                	slli	a1,a1,0x20
    80001304:	9181                	srli	a1,a1,0x20
    80001306:	6d28                	ld	a0,88(a0)
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	6d0080e7          	jalr	1744(ra) # 800009d8 <uvmalloc>
    80001310:	0005061b          	sext.w	a2,a0
    80001314:	fa69                	bnez	a2,800012e6 <growproc+0x26>
      return -1;
    80001316:	557d                	li	a0,-1
    80001318:	bfe1                	j	800012f0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000131a:	9e25                	addw	a2,a2,s1
    8000131c:	1602                	slli	a2,a2,0x20
    8000131e:	9201                	srli	a2,a2,0x20
    80001320:	1582                	slli	a1,a1,0x20
    80001322:	9181                	srli	a1,a1,0x20
    80001324:	6d28                	ld	a0,88(a0)
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	66a080e7          	jalr	1642(ra) # 80000990 <uvmdealloc>
    8000132e:	0005061b          	sext.w	a2,a0
    80001332:	bf55                	j	800012e6 <growproc+0x26>

0000000080001334 <fork>:
{
    80001334:	7179                	addi	sp,sp,-48
    80001336:	f406                	sd	ra,40(sp)
    80001338:	f022                	sd	s0,32(sp)
    8000133a:	ec26                	sd	s1,24(sp)
    8000133c:	e84a                	sd	s2,16(sp)
    8000133e:	e44e                	sd	s3,8(sp)
    80001340:	e052                	sd	s4,0(sp)
    80001342:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001344:	00000097          	auipc	ra,0x0
    80001348:	c22080e7          	jalr	-990(ra) # 80000f66 <myproc>
    8000134c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	e22080e7          	jalr	-478(ra) # 80001170 <allocproc>
    80001356:	10050b63          	beqz	a0,8000146c <fork+0x138>
    8000135a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000135c:	05093603          	ld	a2,80(s2)
    80001360:	6d2c                	ld	a1,88(a0)
    80001362:	05893503          	ld	a0,88(s2)
    80001366:	fffff097          	auipc	ra,0xfffff
    8000136a:	7be080e7          	jalr	1982(ra) # 80000b24 <uvmcopy>
    8000136e:	04054663          	bltz	a0,800013ba <fork+0x86>
  np->sz = p->sz;
    80001372:	05093783          	ld	a5,80(s2)
    80001376:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    8000137a:	06093683          	ld	a3,96(s2)
    8000137e:	87b6                	mv	a5,a3
    80001380:	0609b703          	ld	a4,96(s3)
    80001384:	12068693          	addi	a3,a3,288
    80001388:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000138c:	6788                	ld	a0,8(a5)
    8000138e:	6b8c                	ld	a1,16(a5)
    80001390:	6f90                	ld	a2,24(a5)
    80001392:	01073023          	sd	a6,0(a4)
    80001396:	e708                	sd	a0,8(a4)
    80001398:	eb0c                	sd	a1,16(a4)
    8000139a:	ef10                	sd	a2,24(a4)
    8000139c:	02078793          	addi	a5,a5,32
    800013a0:	02070713          	addi	a4,a4,32
    800013a4:	fed792e3          	bne	a5,a3,80001388 <fork+0x54>
  np->trapframe->a0 = 0;
    800013a8:	0609b783          	ld	a5,96(s3)
    800013ac:	0607b823          	sd	zero,112(a5)
    800013b0:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    800013b4:	15800a13          	li	s4,344
    800013b8:	a03d                	j	800013e6 <fork+0xb2>
    freeproc(np);
    800013ba:	854e                	mv	a0,s3
    800013bc:	00000097          	auipc	ra,0x0
    800013c0:	d5c080e7          	jalr	-676(ra) # 80001118 <freeproc>
    release(&np->lock);
    800013c4:	854e                	mv	a0,s3
    800013c6:	00005097          	auipc	ra,0x5
    800013ca:	42a080e7          	jalr	1066(ra) # 800067f0 <release>
    return -1;
    800013ce:	5a7d                	li	s4,-1
    800013d0:	a069                	j	8000145a <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800013d2:	00003097          	auipc	ra,0x3
    800013d6:	870080e7          	jalr	-1936(ra) # 80003c42 <filedup>
    800013da:	009987b3          	add	a5,s3,s1
    800013de:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800013e0:	04a1                	addi	s1,s1,8
    800013e2:	01448763          	beq	s1,s4,800013f0 <fork+0xbc>
    if(p->ofile[i])
    800013e6:	009907b3          	add	a5,s2,s1
    800013ea:	6388                	ld	a0,0(a5)
    800013ec:	f17d                	bnez	a0,800013d2 <fork+0x9e>
    800013ee:	bfcd                	j	800013e0 <fork+0xac>
  np->cwd = idup(p->cwd);
    800013f0:	15893503          	ld	a0,344(s2)
    800013f4:	00002097          	auipc	ra,0x2
    800013f8:	9c4080e7          	jalr	-1596(ra) # 80002db8 <idup>
    800013fc:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001400:	4641                	li	a2,16
    80001402:	16090593          	addi	a1,s2,352
    80001406:	16098513          	addi	a0,s3,352
    8000140a:	fffff097          	auipc	ra,0xfffff
    8000140e:	fce080e7          	jalr	-50(ra) # 800003d8 <safestrcpy>
  pid = np->pid;
    80001412:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    80001416:	854e                	mv	a0,s3
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	3d8080e7          	jalr	984(ra) # 800067f0 <release>
  acquire(&wait_lock);
    80001420:	00008497          	auipc	s1,0x8
    80001424:	d7048493          	addi	s1,s1,-656 # 80009190 <wait_lock>
    80001428:	8526                	mv	a0,s1
    8000142a:	00005097          	auipc	ra,0x5
    8000142e:	2f6080e7          	jalr	758(ra) # 80006720 <acquire>
  np->parent = p;
    80001432:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80001436:	8526                	mv	a0,s1
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	3b8080e7          	jalr	952(ra) # 800067f0 <release>
  acquire(&np->lock);
    80001440:	854e                	mv	a0,s3
    80001442:	00005097          	auipc	ra,0x5
    80001446:	2de080e7          	jalr	734(ra) # 80006720 <acquire>
  np->state = RUNNABLE;
    8000144a:	478d                	li	a5,3
    8000144c:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    80001450:	854e                	mv	a0,s3
    80001452:	00005097          	auipc	ra,0x5
    80001456:	39e080e7          	jalr	926(ra) # 800067f0 <release>
}
    8000145a:	8552                	mv	a0,s4
    8000145c:	70a2                	ld	ra,40(sp)
    8000145e:	7402                	ld	s0,32(sp)
    80001460:	64e2                	ld	s1,24(sp)
    80001462:	6942                	ld	s2,16(sp)
    80001464:	69a2                	ld	s3,8(sp)
    80001466:	6a02                	ld	s4,0(sp)
    80001468:	6145                	addi	sp,sp,48
    8000146a:	8082                	ret
    return -1;
    8000146c:	5a7d                	li	s4,-1
    8000146e:	b7f5                	j	8000145a <fork+0x126>

0000000080001470 <scheduler>:
{
    80001470:	7139                	addi	sp,sp,-64
    80001472:	fc06                	sd	ra,56(sp)
    80001474:	f822                	sd	s0,48(sp)
    80001476:	f426                	sd	s1,40(sp)
    80001478:	f04a                	sd	s2,32(sp)
    8000147a:	ec4e                	sd	s3,24(sp)
    8000147c:	e852                	sd	s4,16(sp)
    8000147e:	e456                	sd	s5,8(sp)
    80001480:	e05a                	sd	s6,0(sp)
    80001482:	0080                	addi	s0,sp,64
    80001484:	8792                	mv	a5,tp
  int id = r_tp();
    80001486:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001488:	00779a93          	slli	s5,a5,0x7
    8000148c:	00008717          	auipc	a4,0x8
    80001490:	ce470713          	addi	a4,a4,-796 # 80009170 <pid_lock>
    80001494:	9756                	add	a4,a4,s5
    80001496:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    8000149a:	00008717          	auipc	a4,0x8
    8000149e:	d1e70713          	addi	a4,a4,-738 # 800091b8 <cpus+0x8>
    800014a2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014a4:	498d                	li	s3,3
        p->state = RUNNING;
    800014a6:	4b11                	li	s6,4
        c->proc = p;
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00008a17          	auipc	s4,0x8
    800014ae:	cc6a0a13          	addi	s4,s4,-826 # 80009170 <pid_lock>
    800014b2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014b4:	0000e917          	auipc	s2,0xe
    800014b8:	cfc90913          	addi	s2,s2,-772 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014c4:	10079073          	csrw	sstatus,a5
    800014c8:	00008497          	auipc	s1,0x8
    800014cc:	0e848493          	addi	s1,s1,232 # 800095b0 <proc>
    800014d0:	a03d                	j	800014fe <scheduler+0x8e>
        p->state = RUNNING;
    800014d2:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    800014d6:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800014da:	06848593          	addi	a1,s1,104
    800014de:	8556                	mv	a0,s5
    800014e0:	00000097          	auipc	ra,0x0
    800014e4:	640080e7          	jalr	1600(ra) # 80001b20 <swtch>
        c->proc = 0;
    800014e8:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    800014ec:	8526                	mv	a0,s1
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	302080e7          	jalr	770(ra) # 800067f0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014f6:	17048493          	addi	s1,s1,368
    800014fa:	fd2481e3          	beq	s1,s2,800014bc <scheduler+0x4c>
      acquire(&p->lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	00005097          	auipc	ra,0x5
    80001504:	220080e7          	jalr	544(ra) # 80006720 <acquire>
      if(p->state == RUNNABLE) {
    80001508:	509c                	lw	a5,32(s1)
    8000150a:	ff3791e3          	bne	a5,s3,800014ec <scheduler+0x7c>
    8000150e:	b7d1                	j	800014d2 <scheduler+0x62>

0000000080001510 <sched>:
{
    80001510:	7179                	addi	sp,sp,-48
    80001512:	f406                	sd	ra,40(sp)
    80001514:	f022                	sd	s0,32(sp)
    80001516:	ec26                	sd	s1,24(sp)
    80001518:	e84a                	sd	s2,16(sp)
    8000151a:	e44e                	sd	s3,8(sp)
    8000151c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	a48080e7          	jalr	-1464(ra) # 80000f66 <myproc>
    80001526:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	17e080e7          	jalr	382(ra) # 800066a6 <holding>
    80001530:	c93d                	beqz	a0,800015a6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001532:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001534:	2781                	sext.w	a5,a5
    80001536:	079e                	slli	a5,a5,0x7
    80001538:	00008717          	auipc	a4,0x8
    8000153c:	c3870713          	addi	a4,a4,-968 # 80009170 <pid_lock>
    80001540:	97ba                	add	a5,a5,a4
    80001542:	0b87a703          	lw	a4,184(a5)
    80001546:	4785                	li	a5,1
    80001548:	06f71763          	bne	a4,a5,800015b6 <sched+0xa6>
  if(p->state == RUNNING)
    8000154c:	5098                	lw	a4,32(s1)
    8000154e:	4791                	li	a5,4
    80001550:	06f70b63          	beq	a4,a5,800015c6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001554:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001558:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000155a:	efb5                	bnez	a5,800015d6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000155c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000155e:	00008917          	auipc	s2,0x8
    80001562:	c1290913          	addi	s2,s2,-1006 # 80009170 <pid_lock>
    80001566:	2781                	sext.w	a5,a5
    80001568:	079e                	slli	a5,a5,0x7
    8000156a:	97ca                	add	a5,a5,s2
    8000156c:	0bc7a983          	lw	s3,188(a5)
    80001570:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001572:	2781                	sext.w	a5,a5
    80001574:	079e                	slli	a5,a5,0x7
    80001576:	00008597          	auipc	a1,0x8
    8000157a:	c4258593          	addi	a1,a1,-958 # 800091b8 <cpus+0x8>
    8000157e:	95be                	add	a1,a1,a5
    80001580:	06848513          	addi	a0,s1,104
    80001584:	00000097          	auipc	ra,0x0
    80001588:	59c080e7          	jalr	1436(ra) # 80001b20 <swtch>
    8000158c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000158e:	2781                	sext.w	a5,a5
    80001590:	079e                	slli	a5,a5,0x7
    80001592:	97ca                	add	a5,a5,s2
    80001594:	0b37ae23          	sw	s3,188(a5)
}
    80001598:	70a2                	ld	ra,40(sp)
    8000159a:	7402                	ld	s0,32(sp)
    8000159c:	64e2                	ld	s1,24(sp)
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	69a2                	ld	s3,8(sp)
    800015a2:	6145                	addi	sp,sp,48
    800015a4:	8082                	ret
    panic("sched p->lock");
    800015a6:	00007517          	auipc	a0,0x7
    800015aa:	bf250513          	addi	a0,a0,-1038 # 80008198 <etext+0x198>
    800015ae:	00005097          	auipc	ra,0x5
    800015b2:	c3e080e7          	jalr	-962(ra) # 800061ec <panic>
    panic("sched locks");
    800015b6:	00007517          	auipc	a0,0x7
    800015ba:	bf250513          	addi	a0,a0,-1038 # 800081a8 <etext+0x1a8>
    800015be:	00005097          	auipc	ra,0x5
    800015c2:	c2e080e7          	jalr	-978(ra) # 800061ec <panic>
    panic("sched running");
    800015c6:	00007517          	auipc	a0,0x7
    800015ca:	bf250513          	addi	a0,a0,-1038 # 800081b8 <etext+0x1b8>
    800015ce:	00005097          	auipc	ra,0x5
    800015d2:	c1e080e7          	jalr	-994(ra) # 800061ec <panic>
    panic("sched interruptible");
    800015d6:	00007517          	auipc	a0,0x7
    800015da:	bf250513          	addi	a0,a0,-1038 # 800081c8 <etext+0x1c8>
    800015de:	00005097          	auipc	ra,0x5
    800015e2:	c0e080e7          	jalr	-1010(ra) # 800061ec <panic>

00000000800015e6 <yield>:
{
    800015e6:	1101                	addi	sp,sp,-32
    800015e8:	ec06                	sd	ra,24(sp)
    800015ea:	e822                	sd	s0,16(sp)
    800015ec:	e426                	sd	s1,8(sp)
    800015ee:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	976080e7          	jalr	-1674(ra) # 80000f66 <myproc>
    800015f8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	126080e7          	jalr	294(ra) # 80006720 <acquire>
  p->state = RUNNABLE;
    80001602:	478d                	li	a5,3
    80001604:	d09c                	sw	a5,32(s1)
  sched();
    80001606:	00000097          	auipc	ra,0x0
    8000160a:	f0a080e7          	jalr	-246(ra) # 80001510 <sched>
  release(&p->lock);
    8000160e:	8526                	mv	a0,s1
    80001610:	00005097          	auipc	ra,0x5
    80001614:	1e0080e7          	jalr	480(ra) # 800067f0 <release>
}
    80001618:	60e2                	ld	ra,24(sp)
    8000161a:	6442                	ld	s0,16(sp)
    8000161c:	64a2                	ld	s1,8(sp)
    8000161e:	6105                	addi	sp,sp,32
    80001620:	8082                	ret

0000000080001622 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001622:	7179                	addi	sp,sp,-48
    80001624:	f406                	sd	ra,40(sp)
    80001626:	f022                	sd	s0,32(sp)
    80001628:	ec26                	sd	s1,24(sp)
    8000162a:	e84a                	sd	s2,16(sp)
    8000162c:	e44e                	sd	s3,8(sp)
    8000162e:	1800                	addi	s0,sp,48
    80001630:	89aa                	mv	s3,a0
    80001632:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001634:	00000097          	auipc	ra,0x0
    80001638:	932080e7          	jalr	-1742(ra) # 80000f66 <myproc>
    8000163c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	0e2080e7          	jalr	226(ra) # 80006720 <acquire>
  release(lk);
    80001646:	854a                	mv	a0,s2
    80001648:	00005097          	auipc	ra,0x5
    8000164c:	1a8080e7          	jalr	424(ra) # 800067f0 <release>

  // Go to sleep.
  p->chan = chan;
    80001650:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001654:	4789                	li	a5,2
    80001656:	d09c                	sw	a5,32(s1)

  sched();
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	eb8080e7          	jalr	-328(ra) # 80001510 <sched>

  // Tidy up.
  p->chan = 0;
    80001660:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001664:	8526                	mv	a0,s1
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	18a080e7          	jalr	394(ra) # 800067f0 <release>
  acquire(lk);
    8000166e:	854a                	mv	a0,s2
    80001670:	00005097          	auipc	ra,0x5
    80001674:	0b0080e7          	jalr	176(ra) # 80006720 <acquire>
}
    80001678:	70a2                	ld	ra,40(sp)
    8000167a:	7402                	ld	s0,32(sp)
    8000167c:	64e2                	ld	s1,24(sp)
    8000167e:	6942                	ld	s2,16(sp)
    80001680:	69a2                	ld	s3,8(sp)
    80001682:	6145                	addi	sp,sp,48
    80001684:	8082                	ret

0000000080001686 <wait>:
{
    80001686:	715d                	addi	sp,sp,-80
    80001688:	e486                	sd	ra,72(sp)
    8000168a:	e0a2                	sd	s0,64(sp)
    8000168c:	fc26                	sd	s1,56(sp)
    8000168e:	f84a                	sd	s2,48(sp)
    80001690:	f44e                	sd	s3,40(sp)
    80001692:	f052                	sd	s4,32(sp)
    80001694:	ec56                	sd	s5,24(sp)
    80001696:	e85a                	sd	s6,16(sp)
    80001698:	e45e                	sd	s7,8(sp)
    8000169a:	e062                	sd	s8,0(sp)
    8000169c:	0880                	addi	s0,sp,80
    8000169e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016a0:	00000097          	auipc	ra,0x0
    800016a4:	8c6080e7          	jalr	-1850(ra) # 80000f66 <myproc>
    800016a8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016aa:	00008517          	auipc	a0,0x8
    800016ae:	ae650513          	addi	a0,a0,-1306 # 80009190 <wait_lock>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	06e080e7          	jalr	110(ra) # 80006720 <acquire>
    havekids = 0;
    800016ba:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016bc:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800016be:	0000e997          	auipc	s3,0xe
    800016c2:	af298993          	addi	s3,s3,-1294 # 8000f1b0 <tickslock>
        havekids = 1;
    800016c6:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016c8:	00008c17          	auipc	s8,0x8
    800016cc:	ac8c0c13          	addi	s8,s8,-1336 # 80009190 <wait_lock>
    havekids = 0;
    800016d0:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016d2:	00008497          	auipc	s1,0x8
    800016d6:	ede48493          	addi	s1,s1,-290 # 800095b0 <proc>
    800016da:	a0bd                	j	80001748 <wait+0xc2>
          pid = np->pid;
    800016dc:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800016e0:	000b0e63          	beqz	s6,800016fc <wait+0x76>
    800016e4:	4691                	li	a3,4
    800016e6:	03448613          	addi	a2,s1,52
    800016ea:	85da                	mv	a1,s6
    800016ec:	05893503          	ld	a0,88(s2)
    800016f0:	fffff097          	auipc	ra,0xfffff
    800016f4:	538080e7          	jalr	1336(ra) # 80000c28 <copyout>
    800016f8:	02054563          	bltz	a0,80001722 <wait+0x9c>
          freeproc(np);
    800016fc:	8526                	mv	a0,s1
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	a1a080e7          	jalr	-1510(ra) # 80001118 <freeproc>
          release(&np->lock);
    80001706:	8526                	mv	a0,s1
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	0e8080e7          	jalr	232(ra) # 800067f0 <release>
          release(&wait_lock);
    80001710:	00008517          	auipc	a0,0x8
    80001714:	a8050513          	addi	a0,a0,-1408 # 80009190 <wait_lock>
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	0d8080e7          	jalr	216(ra) # 800067f0 <release>
          return pid;
    80001720:	a09d                	j	80001786 <wait+0x100>
            release(&np->lock);
    80001722:	8526                	mv	a0,s1
    80001724:	00005097          	auipc	ra,0x5
    80001728:	0cc080e7          	jalr	204(ra) # 800067f0 <release>
            release(&wait_lock);
    8000172c:	00008517          	auipc	a0,0x8
    80001730:	a6450513          	addi	a0,a0,-1436 # 80009190 <wait_lock>
    80001734:	00005097          	auipc	ra,0x5
    80001738:	0bc080e7          	jalr	188(ra) # 800067f0 <release>
            return -1;
    8000173c:	59fd                	li	s3,-1
    8000173e:	a0a1                	j	80001786 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001740:	17048493          	addi	s1,s1,368
    80001744:	03348463          	beq	s1,s3,8000176c <wait+0xe6>
      if(np->parent == p){
    80001748:	60bc                	ld	a5,64(s1)
    8000174a:	ff279be3          	bne	a5,s2,80001740 <wait+0xba>
        acquire(&np->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	00005097          	auipc	ra,0x5
    80001754:	fd0080e7          	jalr	-48(ra) # 80006720 <acquire>
        if(np->state == ZOMBIE){
    80001758:	509c                	lw	a5,32(s1)
    8000175a:	f94781e3          	beq	a5,s4,800016dc <wait+0x56>
        release(&np->lock);
    8000175e:	8526                	mv	a0,s1
    80001760:	00005097          	auipc	ra,0x5
    80001764:	090080e7          	jalr	144(ra) # 800067f0 <release>
        havekids = 1;
    80001768:	8756                	mv	a4,s5
    8000176a:	bfd9                	j	80001740 <wait+0xba>
    if(!havekids || p->killed){
    8000176c:	c701                	beqz	a4,80001774 <wait+0xee>
    8000176e:	03092783          	lw	a5,48(s2)
    80001772:	c79d                	beqz	a5,800017a0 <wait+0x11a>
      release(&wait_lock);
    80001774:	00008517          	auipc	a0,0x8
    80001778:	a1c50513          	addi	a0,a0,-1508 # 80009190 <wait_lock>
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	074080e7          	jalr	116(ra) # 800067f0 <release>
      return -1;
    80001784:	59fd                	li	s3,-1
}
    80001786:	854e                	mv	a0,s3
    80001788:	60a6                	ld	ra,72(sp)
    8000178a:	6406                	ld	s0,64(sp)
    8000178c:	74e2                	ld	s1,56(sp)
    8000178e:	7942                	ld	s2,48(sp)
    80001790:	79a2                	ld	s3,40(sp)
    80001792:	7a02                	ld	s4,32(sp)
    80001794:	6ae2                	ld	s5,24(sp)
    80001796:	6b42                	ld	s6,16(sp)
    80001798:	6ba2                	ld	s7,8(sp)
    8000179a:	6c02                	ld	s8,0(sp)
    8000179c:	6161                	addi	sp,sp,80
    8000179e:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017a0:	85e2                	mv	a1,s8
    800017a2:	854a                	mv	a0,s2
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	e7e080e7          	jalr	-386(ra) # 80001622 <sleep>
    havekids = 0;
    800017ac:	b715                	j	800016d0 <wait+0x4a>

00000000800017ae <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017ae:	7139                	addi	sp,sp,-64
    800017b0:	fc06                	sd	ra,56(sp)
    800017b2:	f822                	sd	s0,48(sp)
    800017b4:	f426                	sd	s1,40(sp)
    800017b6:	f04a                	sd	s2,32(sp)
    800017b8:	ec4e                	sd	s3,24(sp)
    800017ba:	e852                	sd	s4,16(sp)
    800017bc:	e456                	sd	s5,8(sp)
    800017be:	0080                	addi	s0,sp,64
    800017c0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017c2:	00008497          	auipc	s1,0x8
    800017c6:	dee48493          	addi	s1,s1,-530 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017ca:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017cc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ce:	0000e917          	auipc	s2,0xe
    800017d2:	9e290913          	addi	s2,s2,-1566 # 8000f1b0 <tickslock>
    800017d6:	a821                	j	800017ee <wakeup+0x40>
        p->state = RUNNABLE;
    800017d8:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    800017dc:	8526                	mv	a0,s1
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	012080e7          	jalr	18(ra) # 800067f0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017e6:	17048493          	addi	s1,s1,368
    800017ea:	03248463          	beq	s1,s2,80001812 <wakeup+0x64>
    if(p != myproc()){
    800017ee:	fffff097          	auipc	ra,0xfffff
    800017f2:	778080e7          	jalr	1912(ra) # 80000f66 <myproc>
    800017f6:	fea488e3          	beq	s1,a0,800017e6 <wakeup+0x38>
      acquire(&p->lock);
    800017fa:	8526                	mv	a0,s1
    800017fc:	00005097          	auipc	ra,0x5
    80001800:	f24080e7          	jalr	-220(ra) # 80006720 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001804:	509c                	lw	a5,32(s1)
    80001806:	fd379be3          	bne	a5,s3,800017dc <wakeup+0x2e>
    8000180a:	749c                	ld	a5,40(s1)
    8000180c:	fd4798e3          	bne	a5,s4,800017dc <wakeup+0x2e>
    80001810:	b7e1                	j	800017d8 <wakeup+0x2a>
    }
  }
}
    80001812:	70e2                	ld	ra,56(sp)
    80001814:	7442                	ld	s0,48(sp)
    80001816:	74a2                	ld	s1,40(sp)
    80001818:	7902                	ld	s2,32(sp)
    8000181a:	69e2                	ld	s3,24(sp)
    8000181c:	6a42                	ld	s4,16(sp)
    8000181e:	6aa2                	ld	s5,8(sp)
    80001820:	6121                	addi	sp,sp,64
    80001822:	8082                	ret

0000000080001824 <reparent>:
{
    80001824:	7179                	addi	sp,sp,-48
    80001826:	f406                	sd	ra,40(sp)
    80001828:	f022                	sd	s0,32(sp)
    8000182a:	ec26                	sd	s1,24(sp)
    8000182c:	e84a                	sd	s2,16(sp)
    8000182e:	e44e                	sd	s3,8(sp)
    80001830:	e052                	sd	s4,0(sp)
    80001832:	1800                	addi	s0,sp,48
    80001834:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001836:	00008497          	auipc	s1,0x8
    8000183a:	d7a48493          	addi	s1,s1,-646 # 800095b0 <proc>
      pp->parent = initproc;
    8000183e:	00007a17          	auipc	s4,0x7
    80001842:	7d2a0a13          	addi	s4,s4,2002 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001846:	0000e997          	auipc	s3,0xe
    8000184a:	96a98993          	addi	s3,s3,-1686 # 8000f1b0 <tickslock>
    8000184e:	a029                	j	80001858 <reparent+0x34>
    80001850:	17048493          	addi	s1,s1,368
    80001854:	01348d63          	beq	s1,s3,8000186e <reparent+0x4a>
    if(pp->parent == p){
    80001858:	60bc                	ld	a5,64(s1)
    8000185a:	ff279be3          	bne	a5,s2,80001850 <reparent+0x2c>
      pp->parent = initproc;
    8000185e:	000a3503          	ld	a0,0(s4)
    80001862:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001864:	00000097          	auipc	ra,0x0
    80001868:	f4a080e7          	jalr	-182(ra) # 800017ae <wakeup>
    8000186c:	b7d5                	j	80001850 <reparent+0x2c>
}
    8000186e:	70a2                	ld	ra,40(sp)
    80001870:	7402                	ld	s0,32(sp)
    80001872:	64e2                	ld	s1,24(sp)
    80001874:	6942                	ld	s2,16(sp)
    80001876:	69a2                	ld	s3,8(sp)
    80001878:	6a02                	ld	s4,0(sp)
    8000187a:	6145                	addi	sp,sp,48
    8000187c:	8082                	ret

000000008000187e <exit>:
{
    8000187e:	7179                	addi	sp,sp,-48
    80001880:	f406                	sd	ra,40(sp)
    80001882:	f022                	sd	s0,32(sp)
    80001884:	ec26                	sd	s1,24(sp)
    80001886:	e84a                	sd	s2,16(sp)
    80001888:	e44e                	sd	s3,8(sp)
    8000188a:	e052                	sd	s4,0(sp)
    8000188c:	1800                	addi	s0,sp,48
    8000188e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001890:	fffff097          	auipc	ra,0xfffff
    80001894:	6d6080e7          	jalr	1750(ra) # 80000f66 <myproc>
    80001898:	89aa                	mv	s3,a0
  if(p == initproc)
    8000189a:	00007797          	auipc	a5,0x7
    8000189e:	7767b783          	ld	a5,1910(a5) # 80009010 <initproc>
    800018a2:	0d850493          	addi	s1,a0,216
    800018a6:	15850913          	addi	s2,a0,344
    800018aa:	02a79363          	bne	a5,a0,800018d0 <exit+0x52>
    panic("init exiting");
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	93250513          	addi	a0,a0,-1742 # 800081e0 <etext+0x1e0>
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	936080e7          	jalr	-1738(ra) # 800061ec <panic>
      fileclose(f);
    800018be:	00002097          	auipc	ra,0x2
    800018c2:	3d6080e7          	jalr	982(ra) # 80003c94 <fileclose>
      p->ofile[fd] = 0;
    800018c6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018ca:	04a1                	addi	s1,s1,8
    800018cc:	01248563          	beq	s1,s2,800018d6 <exit+0x58>
    if(p->ofile[fd]){
    800018d0:	6088                	ld	a0,0(s1)
    800018d2:	f575                	bnez	a0,800018be <exit+0x40>
    800018d4:	bfdd                	j	800018ca <exit+0x4c>
  begin_op();
    800018d6:	00002097          	auipc	ra,0x2
    800018da:	ef2080e7          	jalr	-270(ra) # 800037c8 <begin_op>
  iput(p->cwd);
    800018de:	1589b503          	ld	a0,344(s3)
    800018e2:	00001097          	auipc	ra,0x1
    800018e6:	6ce080e7          	jalr	1742(ra) # 80002fb0 <iput>
  end_op();
    800018ea:	00002097          	auipc	ra,0x2
    800018ee:	f5e080e7          	jalr	-162(ra) # 80003848 <end_op>
  p->cwd = 0;
    800018f2:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800018f6:	00008497          	auipc	s1,0x8
    800018fa:	89a48493          	addi	s1,s1,-1894 # 80009190 <wait_lock>
    800018fe:	8526                	mv	a0,s1
    80001900:	00005097          	auipc	ra,0x5
    80001904:	e20080e7          	jalr	-480(ra) # 80006720 <acquire>
  reparent(p);
    80001908:	854e                	mv	a0,s3
    8000190a:	00000097          	auipc	ra,0x0
    8000190e:	f1a080e7          	jalr	-230(ra) # 80001824 <reparent>
  wakeup(p->parent);
    80001912:	0409b503          	ld	a0,64(s3)
    80001916:	00000097          	auipc	ra,0x0
    8000191a:	e98080e7          	jalr	-360(ra) # 800017ae <wakeup>
  acquire(&p->lock);
    8000191e:	854e                	mv	a0,s3
    80001920:	00005097          	auipc	ra,0x5
    80001924:	e00080e7          	jalr	-512(ra) # 80006720 <acquire>
  p->xstate = status;
    80001928:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000192c:	4795                	li	a5,5
    8000192e:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001932:	8526                	mv	a0,s1
    80001934:	00005097          	auipc	ra,0x5
    80001938:	ebc080e7          	jalr	-324(ra) # 800067f0 <release>
  sched();
    8000193c:	00000097          	auipc	ra,0x0
    80001940:	bd4080e7          	jalr	-1068(ra) # 80001510 <sched>
  panic("zombie exit");
    80001944:	00007517          	auipc	a0,0x7
    80001948:	8ac50513          	addi	a0,a0,-1876 # 800081f0 <etext+0x1f0>
    8000194c:	00005097          	auipc	ra,0x5
    80001950:	8a0080e7          	jalr	-1888(ra) # 800061ec <panic>

0000000080001954 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001954:	7179                	addi	sp,sp,-48
    80001956:	f406                	sd	ra,40(sp)
    80001958:	f022                	sd	s0,32(sp)
    8000195a:	ec26                	sd	s1,24(sp)
    8000195c:	e84a                	sd	s2,16(sp)
    8000195e:	e44e                	sd	s3,8(sp)
    80001960:	1800                	addi	s0,sp,48
    80001962:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001964:	00008497          	auipc	s1,0x8
    80001968:	c4c48493          	addi	s1,s1,-948 # 800095b0 <proc>
    8000196c:	0000e997          	auipc	s3,0xe
    80001970:	84498993          	addi	s3,s3,-1980 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    80001974:	8526                	mv	a0,s1
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	daa080e7          	jalr	-598(ra) # 80006720 <acquire>
    if(p->pid == pid){
    8000197e:	5c9c                	lw	a5,56(s1)
    80001980:	01278d63          	beq	a5,s2,8000199a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001984:	8526                	mv	a0,s1
    80001986:	00005097          	auipc	ra,0x5
    8000198a:	e6a080e7          	jalr	-406(ra) # 800067f0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000198e:	17048493          	addi	s1,s1,368
    80001992:	ff3491e3          	bne	s1,s3,80001974 <kill+0x20>
  }
  return -1;
    80001996:	557d                	li	a0,-1
    80001998:	a829                	j	800019b2 <kill+0x5e>
      p->killed = 1;
    8000199a:	4785                	li	a5,1
    8000199c:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000199e:	5098                	lw	a4,32(s1)
    800019a0:	4789                	li	a5,2
    800019a2:	00f70f63          	beq	a4,a5,800019c0 <kill+0x6c>
      release(&p->lock);
    800019a6:	8526                	mv	a0,s1
    800019a8:	00005097          	auipc	ra,0x5
    800019ac:	e48080e7          	jalr	-440(ra) # 800067f0 <release>
      return 0;
    800019b0:	4501                	li	a0,0
}
    800019b2:	70a2                	ld	ra,40(sp)
    800019b4:	7402                	ld	s0,32(sp)
    800019b6:	64e2                	ld	s1,24(sp)
    800019b8:	6942                	ld	s2,16(sp)
    800019ba:	69a2                	ld	s3,8(sp)
    800019bc:	6145                	addi	sp,sp,48
    800019be:	8082                	ret
        p->state = RUNNABLE;
    800019c0:	478d                	li	a5,3
    800019c2:	d09c                	sw	a5,32(s1)
    800019c4:	b7cd                	j	800019a6 <kill+0x52>

00000000800019c6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019c6:	7179                	addi	sp,sp,-48
    800019c8:	f406                	sd	ra,40(sp)
    800019ca:	f022                	sd	s0,32(sp)
    800019cc:	ec26                	sd	s1,24(sp)
    800019ce:	e84a                	sd	s2,16(sp)
    800019d0:	e44e                	sd	s3,8(sp)
    800019d2:	e052                	sd	s4,0(sp)
    800019d4:	1800                	addi	s0,sp,48
    800019d6:	84aa                	mv	s1,a0
    800019d8:	892e                	mv	s2,a1
    800019da:	89b2                	mv	s3,a2
    800019dc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019de:	fffff097          	auipc	ra,0xfffff
    800019e2:	588080e7          	jalr	1416(ra) # 80000f66 <myproc>
  if(user_dst){
    800019e6:	c08d                	beqz	s1,80001a08 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019e8:	86d2                	mv	a3,s4
    800019ea:	864e                	mv	a2,s3
    800019ec:	85ca                	mv	a1,s2
    800019ee:	6d28                	ld	a0,88(a0)
    800019f0:	fffff097          	auipc	ra,0xfffff
    800019f4:	238080e7          	jalr	568(ra) # 80000c28 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019f8:	70a2                	ld	ra,40(sp)
    800019fa:	7402                	ld	s0,32(sp)
    800019fc:	64e2                	ld	s1,24(sp)
    800019fe:	6942                	ld	s2,16(sp)
    80001a00:	69a2                	ld	s3,8(sp)
    80001a02:	6a02                	ld	s4,0(sp)
    80001a04:	6145                	addi	sp,sp,48
    80001a06:	8082                	ret
    memmove((char *)dst, src, len);
    80001a08:	000a061b          	sext.w	a2,s4
    80001a0c:	85ce                	mv	a1,s3
    80001a0e:	854a                	mv	a0,s2
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	8d6080e7          	jalr	-1834(ra) # 800002e6 <memmove>
    return 0;
    80001a18:	8526                	mv	a0,s1
    80001a1a:	bff9                	j	800019f8 <either_copyout+0x32>

0000000080001a1c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a1c:	7179                	addi	sp,sp,-48
    80001a1e:	f406                	sd	ra,40(sp)
    80001a20:	f022                	sd	s0,32(sp)
    80001a22:	ec26                	sd	s1,24(sp)
    80001a24:	e84a                	sd	s2,16(sp)
    80001a26:	e44e                	sd	s3,8(sp)
    80001a28:	e052                	sd	s4,0(sp)
    80001a2a:	1800                	addi	s0,sp,48
    80001a2c:	892a                	mv	s2,a0
    80001a2e:	84ae                	mv	s1,a1
    80001a30:	89b2                	mv	s3,a2
    80001a32:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a34:	fffff097          	auipc	ra,0xfffff
    80001a38:	532080e7          	jalr	1330(ra) # 80000f66 <myproc>
  if(user_src){
    80001a3c:	c08d                	beqz	s1,80001a5e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a3e:	86d2                	mv	a3,s4
    80001a40:	864e                	mv	a2,s3
    80001a42:	85ca                	mv	a1,s2
    80001a44:	6d28                	ld	a0,88(a0)
    80001a46:	fffff097          	auipc	ra,0xfffff
    80001a4a:	26e080e7          	jalr	622(ra) # 80000cb4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a4e:	70a2                	ld	ra,40(sp)
    80001a50:	7402                	ld	s0,32(sp)
    80001a52:	64e2                	ld	s1,24(sp)
    80001a54:	6942                	ld	s2,16(sp)
    80001a56:	69a2                	ld	s3,8(sp)
    80001a58:	6a02                	ld	s4,0(sp)
    80001a5a:	6145                	addi	sp,sp,48
    80001a5c:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a5e:	000a061b          	sext.w	a2,s4
    80001a62:	85ce                	mv	a1,s3
    80001a64:	854a                	mv	a0,s2
    80001a66:	fffff097          	auipc	ra,0xfffff
    80001a6a:	880080e7          	jalr	-1920(ra) # 800002e6 <memmove>
    return 0;
    80001a6e:	8526                	mv	a0,s1
    80001a70:	bff9                	j	80001a4e <either_copyin+0x32>

0000000080001a72 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a72:	715d                	addi	sp,sp,-80
    80001a74:	e486                	sd	ra,72(sp)
    80001a76:	e0a2                	sd	s0,64(sp)
    80001a78:	fc26                	sd	s1,56(sp)
    80001a7a:	f84a                	sd	s2,48(sp)
    80001a7c:	f44e                	sd	s3,40(sp)
    80001a7e:	f052                	sd	s4,32(sp)
    80001a80:	ec56                	sd	s5,24(sp)
    80001a82:	e85a                	sd	s6,16(sp)
    80001a84:	e45e                	sd	s7,8(sp)
    80001a86:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a88:	00007517          	auipc	a0,0x7
    80001a8c:	df850513          	addi	a0,a0,-520 # 80008880 <digits+0x88>
    80001a90:	00004097          	auipc	ra,0x4
    80001a94:	7a6080e7          	jalr	1958(ra) # 80006236 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a98:	00008497          	auipc	s1,0x8
    80001a9c:	c7848493          	addi	s1,s1,-904 # 80009710 <proc+0x160>
    80001aa0:	0000e917          	auipc	s2,0xe
    80001aa4:	87090913          	addi	s2,s2,-1936 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aa8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001aaa:	00006997          	auipc	s3,0x6
    80001aae:	75698993          	addi	s3,s3,1878 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001ab2:	00006a97          	auipc	s5,0x6
    80001ab6:	756a8a93          	addi	s5,s5,1878 # 80008208 <etext+0x208>
    printf("\n");
    80001aba:	00007a17          	auipc	s4,0x7
    80001abe:	dc6a0a13          	addi	s4,s4,-570 # 80008880 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ac2:	00006b97          	auipc	s7,0x6
    80001ac6:	77eb8b93          	addi	s7,s7,1918 # 80008240 <states.1725>
    80001aca:	a00d                	j	80001aec <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001acc:	ed86a583          	lw	a1,-296(a3)
    80001ad0:	8556                	mv	a0,s5
    80001ad2:	00004097          	auipc	ra,0x4
    80001ad6:	764080e7          	jalr	1892(ra) # 80006236 <printf>
    printf("\n");
    80001ada:	8552                	mv	a0,s4
    80001adc:	00004097          	auipc	ra,0x4
    80001ae0:	75a080e7          	jalr	1882(ra) # 80006236 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ae4:	17048493          	addi	s1,s1,368
    80001ae8:	03248163          	beq	s1,s2,80001b0a <procdump+0x98>
    if(p->state == UNUSED)
    80001aec:	86a6                	mv	a3,s1
    80001aee:	ec04a783          	lw	a5,-320(s1)
    80001af2:	dbed                	beqz	a5,80001ae4 <procdump+0x72>
      state = "???";
    80001af4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001af6:	fcfb6be3          	bltu	s6,a5,80001acc <procdump+0x5a>
    80001afa:	1782                	slli	a5,a5,0x20
    80001afc:	9381                	srli	a5,a5,0x20
    80001afe:	078e                	slli	a5,a5,0x3
    80001b00:	97de                	add	a5,a5,s7
    80001b02:	6390                	ld	a2,0(a5)
    80001b04:	f661                	bnez	a2,80001acc <procdump+0x5a>
      state = "???";
    80001b06:	864e                	mv	a2,s3
    80001b08:	b7d1                	j	80001acc <procdump+0x5a>
  }
}
    80001b0a:	60a6                	ld	ra,72(sp)
    80001b0c:	6406                	ld	s0,64(sp)
    80001b0e:	74e2                	ld	s1,56(sp)
    80001b10:	7942                	ld	s2,48(sp)
    80001b12:	79a2                	ld	s3,40(sp)
    80001b14:	7a02                	ld	s4,32(sp)
    80001b16:	6ae2                	ld	s5,24(sp)
    80001b18:	6b42                	ld	s6,16(sp)
    80001b1a:	6ba2                	ld	s7,8(sp)
    80001b1c:	6161                	addi	sp,sp,80
    80001b1e:	8082                	ret

0000000080001b20 <swtch>:
    80001b20:	00153023          	sd	ra,0(a0)
    80001b24:	00253423          	sd	sp,8(a0)
    80001b28:	e900                	sd	s0,16(a0)
    80001b2a:	ed04                	sd	s1,24(a0)
    80001b2c:	03253023          	sd	s2,32(a0)
    80001b30:	03353423          	sd	s3,40(a0)
    80001b34:	03453823          	sd	s4,48(a0)
    80001b38:	03553c23          	sd	s5,56(a0)
    80001b3c:	05653023          	sd	s6,64(a0)
    80001b40:	05753423          	sd	s7,72(a0)
    80001b44:	05853823          	sd	s8,80(a0)
    80001b48:	05953c23          	sd	s9,88(a0)
    80001b4c:	07a53023          	sd	s10,96(a0)
    80001b50:	07b53423          	sd	s11,104(a0)
    80001b54:	0005b083          	ld	ra,0(a1)
    80001b58:	0085b103          	ld	sp,8(a1)
    80001b5c:	6980                	ld	s0,16(a1)
    80001b5e:	6d84                	ld	s1,24(a1)
    80001b60:	0205b903          	ld	s2,32(a1)
    80001b64:	0285b983          	ld	s3,40(a1)
    80001b68:	0305ba03          	ld	s4,48(a1)
    80001b6c:	0385ba83          	ld	s5,56(a1)
    80001b70:	0405bb03          	ld	s6,64(a1)
    80001b74:	0485bb83          	ld	s7,72(a1)
    80001b78:	0505bc03          	ld	s8,80(a1)
    80001b7c:	0585bc83          	ld	s9,88(a1)
    80001b80:	0605bd03          	ld	s10,96(a1)
    80001b84:	0685bd83          	ld	s11,104(a1)
    80001b88:	8082                	ret

0000000080001b8a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b8a:	1141                	addi	sp,sp,-16
    80001b8c:	e406                	sd	ra,8(sp)
    80001b8e:	e022                	sd	s0,0(sp)
    80001b90:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b92:	00006597          	auipc	a1,0x6
    80001b96:	6de58593          	addi	a1,a1,1758 # 80008270 <states.1725+0x30>
    80001b9a:	0000d517          	auipc	a0,0xd
    80001b9e:	61650513          	addi	a0,a0,1558 # 8000f1b0 <tickslock>
    80001ba2:	00005097          	auipc	ra,0x5
    80001ba6:	cfa080e7          	jalr	-774(ra) # 8000689c <initlock>
}
    80001baa:	60a2                	ld	ra,8(sp)
    80001bac:	6402                	ld	s0,0(sp)
    80001bae:	0141                	addi	sp,sp,16
    80001bb0:	8082                	ret

0000000080001bb2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bb2:	1141                	addi	sp,sp,-16
    80001bb4:	e422                	sd	s0,8(sp)
    80001bb6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb8:	00003797          	auipc	a5,0x3
    80001bbc:	70878793          	addi	a5,a5,1800 # 800052c0 <kernelvec>
    80001bc0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bc4:	6422                	ld	s0,8(sp)
    80001bc6:	0141                	addi	sp,sp,16
    80001bc8:	8082                	ret

0000000080001bca <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bca:	1141                	addi	sp,sp,-16
    80001bcc:	e406                	sd	ra,8(sp)
    80001bce:	e022                	sd	s0,0(sp)
    80001bd0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bd2:	fffff097          	auipc	ra,0xfffff
    80001bd6:	394080e7          	jalr	916(ra) # 80000f66 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bda:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bde:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001be0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001be4:	00005617          	auipc	a2,0x5
    80001be8:	41c60613          	addi	a2,a2,1052 # 80007000 <_trampoline>
    80001bec:	00005697          	auipc	a3,0x5
    80001bf0:	41468693          	addi	a3,a3,1044 # 80007000 <_trampoline>
    80001bf4:	8e91                	sub	a3,a3,a2
    80001bf6:	040007b7          	lui	a5,0x4000
    80001bfa:	17fd                	addi	a5,a5,-1
    80001bfc:	07b2                	slli	a5,a5,0xc
    80001bfe:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c00:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c04:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c06:	180026f3          	csrr	a3,satp
    80001c0a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c0c:	7138                	ld	a4,96(a0)
    80001c0e:	6534                	ld	a3,72(a0)
    80001c10:	6585                	lui	a1,0x1
    80001c12:	96ae                	add	a3,a3,a1
    80001c14:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c16:	7138                	ld	a4,96(a0)
    80001c18:	00000697          	auipc	a3,0x0
    80001c1c:	13868693          	addi	a3,a3,312 # 80001d50 <usertrap>
    80001c20:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c22:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c24:	8692                	mv	a3,tp
    80001c26:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c28:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c2c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c30:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c34:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c38:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c3a:	6f18                	ld	a4,24(a4)
    80001c3c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c40:	6d2c                	ld	a1,88(a0)
    80001c42:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c44:	00005717          	auipc	a4,0x5
    80001c48:	44c70713          	addi	a4,a4,1100 # 80007090 <userret>
    80001c4c:	8f11                	sub	a4,a4,a2
    80001c4e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c50:	577d                	li	a4,-1
    80001c52:	177e                	slli	a4,a4,0x3f
    80001c54:	8dd9                	or	a1,a1,a4
    80001c56:	02000537          	lui	a0,0x2000
    80001c5a:	157d                	addi	a0,a0,-1
    80001c5c:	0536                	slli	a0,a0,0xd
    80001c5e:	9782                	jalr	a5
}
    80001c60:	60a2                	ld	ra,8(sp)
    80001c62:	6402                	ld	s0,0(sp)
    80001c64:	0141                	addi	sp,sp,16
    80001c66:	8082                	ret

0000000080001c68 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c68:	1101                	addi	sp,sp,-32
    80001c6a:	ec06                	sd	ra,24(sp)
    80001c6c:	e822                	sd	s0,16(sp)
    80001c6e:	e426                	sd	s1,8(sp)
    80001c70:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c72:	0000d497          	auipc	s1,0xd
    80001c76:	53e48493          	addi	s1,s1,1342 # 8000f1b0 <tickslock>
    80001c7a:	8526                	mv	a0,s1
    80001c7c:	00005097          	auipc	ra,0x5
    80001c80:	aa4080e7          	jalr	-1372(ra) # 80006720 <acquire>
  ticks++;
    80001c84:	00007517          	auipc	a0,0x7
    80001c88:	39450513          	addi	a0,a0,916 # 80009018 <ticks>
    80001c8c:	411c                	lw	a5,0(a0)
    80001c8e:	2785                	addiw	a5,a5,1
    80001c90:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	b1c080e7          	jalr	-1252(ra) # 800017ae <wakeup>
  release(&tickslock);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	00005097          	auipc	ra,0x5
    80001ca0:	b54080e7          	jalr	-1196(ra) # 800067f0 <release>
}
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	64a2                	ld	s1,8(sp)
    80001caa:	6105                	addi	sp,sp,32
    80001cac:	8082                	ret

0000000080001cae <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cae:	1101                	addi	sp,sp,-32
    80001cb0:	ec06                	sd	ra,24(sp)
    80001cb2:	e822                	sd	s0,16(sp)
    80001cb4:	e426                	sd	s1,8(sp)
    80001cb6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cbc:	00074d63          	bltz	a4,80001cd6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cc0:	57fd                	li	a5,-1
    80001cc2:	17fe                	slli	a5,a5,0x3f
    80001cc4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cc6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cc8:	06f70363          	beq	a4,a5,80001d2e <devintr+0x80>
  }
}
    80001ccc:	60e2                	ld	ra,24(sp)
    80001cce:	6442                	ld	s0,16(sp)
    80001cd0:	64a2                	ld	s1,8(sp)
    80001cd2:	6105                	addi	sp,sp,32
    80001cd4:	8082                	ret
     (scause & 0xff) == 9){
    80001cd6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001cda:	46a5                	li	a3,9
    80001cdc:	fed792e3          	bne	a5,a3,80001cc0 <devintr+0x12>
    int irq = plic_claim();
    80001ce0:	00003097          	auipc	ra,0x3
    80001ce4:	6e8080e7          	jalr	1768(ra) # 800053c8 <plic_claim>
    80001ce8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cea:	47a9                	li	a5,10
    80001cec:	02f50763          	beq	a0,a5,80001d1a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001cf0:	4785                	li	a5,1
    80001cf2:	02f50963          	beq	a0,a5,80001d24 <devintr+0x76>
    return 1;
    80001cf6:	4505                	li	a0,1
    } else if(irq){
    80001cf8:	d8f1                	beqz	s1,80001ccc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cfa:	85a6                	mv	a1,s1
    80001cfc:	00006517          	auipc	a0,0x6
    80001d00:	57c50513          	addi	a0,a0,1404 # 80008278 <states.1725+0x38>
    80001d04:	00004097          	auipc	ra,0x4
    80001d08:	532080e7          	jalr	1330(ra) # 80006236 <printf>
      plic_complete(irq);
    80001d0c:	8526                	mv	a0,s1
    80001d0e:	00003097          	auipc	ra,0x3
    80001d12:	6de080e7          	jalr	1758(ra) # 800053ec <plic_complete>
    return 1;
    80001d16:	4505                	li	a0,1
    80001d18:	bf55                	j	80001ccc <devintr+0x1e>
      uartintr();
    80001d1a:	00005097          	auipc	ra,0x5
    80001d1e:	93c080e7          	jalr	-1732(ra) # 80006656 <uartintr>
    80001d22:	b7ed                	j	80001d0c <devintr+0x5e>
      virtio_disk_intr();
    80001d24:	00004097          	auipc	ra,0x4
    80001d28:	ba8080e7          	jalr	-1112(ra) # 800058cc <virtio_disk_intr>
    80001d2c:	b7c5                	j	80001d0c <devintr+0x5e>
    if(cpuid() == 0){
    80001d2e:	fffff097          	auipc	ra,0xfffff
    80001d32:	20c080e7          	jalr	524(ra) # 80000f3a <cpuid>
    80001d36:	c901                	beqz	a0,80001d46 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d38:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d3c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d3e:	14479073          	csrw	sip,a5
    return 2;
    80001d42:	4509                	li	a0,2
    80001d44:	b761                	j	80001ccc <devintr+0x1e>
      clockintr();
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	f22080e7          	jalr	-222(ra) # 80001c68 <clockintr>
    80001d4e:	b7ed                	j	80001d38 <devintr+0x8a>

0000000080001d50 <usertrap>:
{
    80001d50:	1101                	addi	sp,sp,-32
    80001d52:	ec06                	sd	ra,24(sp)
    80001d54:	e822                	sd	s0,16(sp)
    80001d56:	e426                	sd	s1,8(sp)
    80001d58:	e04a                	sd	s2,0(sp)
    80001d5a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d60:	1007f793          	andi	a5,a5,256
    80001d64:	e3ad                	bnez	a5,80001dc6 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d66:	00003797          	auipc	a5,0x3
    80001d6a:	55a78793          	addi	a5,a5,1370 # 800052c0 <kernelvec>
    80001d6e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d72:	fffff097          	auipc	ra,0xfffff
    80001d76:	1f4080e7          	jalr	500(ra) # 80000f66 <myproc>
    80001d7a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d7c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7e:	14102773          	csrr	a4,sepc
    80001d82:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d84:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d88:	47a1                	li	a5,8
    80001d8a:	04f71c63          	bne	a4,a5,80001de2 <usertrap+0x92>
    if(p->killed)
    80001d8e:	591c                	lw	a5,48(a0)
    80001d90:	e3b9                	bnez	a5,80001dd6 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d92:	70b8                	ld	a4,96(s1)
    80001d94:	6f1c                	ld	a5,24(a4)
    80001d96:	0791                	addi	a5,a5,4
    80001d98:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d9e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da2:	10079073          	csrw	sstatus,a5
    syscall();
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	2e0080e7          	jalr	736(ra) # 80002086 <syscall>
  if(p->killed)
    80001dae:	589c                	lw	a5,48(s1)
    80001db0:	ebc1                	bnez	a5,80001e40 <usertrap+0xf0>
  usertrapret();
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	e18080e7          	jalr	-488(ra) # 80001bca <usertrapret>
}
    80001dba:	60e2                	ld	ra,24(sp)
    80001dbc:	6442                	ld	s0,16(sp)
    80001dbe:	64a2                	ld	s1,8(sp)
    80001dc0:	6902                	ld	s2,0(sp)
    80001dc2:	6105                	addi	sp,sp,32
    80001dc4:	8082                	ret
    panic("usertrap: not from user mode");
    80001dc6:	00006517          	auipc	a0,0x6
    80001dca:	4d250513          	addi	a0,a0,1234 # 80008298 <states.1725+0x58>
    80001dce:	00004097          	auipc	ra,0x4
    80001dd2:	41e080e7          	jalr	1054(ra) # 800061ec <panic>
      exit(-1);
    80001dd6:	557d                	li	a0,-1
    80001dd8:	00000097          	auipc	ra,0x0
    80001ddc:	aa6080e7          	jalr	-1370(ra) # 8000187e <exit>
    80001de0:	bf4d                	j	80001d92 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	ecc080e7          	jalr	-308(ra) # 80001cae <devintr>
    80001dea:	892a                	mv	s2,a0
    80001dec:	c501                	beqz	a0,80001df4 <usertrap+0xa4>
  if(p->killed)
    80001dee:	589c                	lw	a5,48(s1)
    80001df0:	c3a1                	beqz	a5,80001e30 <usertrap+0xe0>
    80001df2:	a815                	j	80001e26 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001df4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001df8:	5c90                	lw	a2,56(s1)
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	4be50513          	addi	a0,a0,1214 # 800082b8 <states.1725+0x78>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	434080e7          	jalr	1076(ra) # 80006236 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e0e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	4d650513          	addi	a0,a0,1238 # 800082e8 <states.1725+0xa8>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	41c080e7          	jalr	1052(ra) # 80006236 <printf>
    p->killed = 1;
    80001e22:	4785                	li	a5,1
    80001e24:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e26:	557d                	li	a0,-1
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	a56080e7          	jalr	-1450(ra) # 8000187e <exit>
  if(which_dev == 2)
    80001e30:	4789                	li	a5,2
    80001e32:	f8f910e3          	bne	s2,a5,80001db2 <usertrap+0x62>
    yield();
    80001e36:	fffff097          	auipc	ra,0xfffff
    80001e3a:	7b0080e7          	jalr	1968(ra) # 800015e6 <yield>
    80001e3e:	bf95                	j	80001db2 <usertrap+0x62>
  int which_dev = 0;
    80001e40:	4901                	li	s2,0
    80001e42:	b7d5                	j	80001e26 <usertrap+0xd6>

0000000080001e44 <kerneltrap>:
{
    80001e44:	7179                	addi	sp,sp,-48
    80001e46:	f406                	sd	ra,40(sp)
    80001e48:	f022                	sd	s0,32(sp)
    80001e4a:	ec26                	sd	s1,24(sp)
    80001e4c:	e84a                	sd	s2,16(sp)
    80001e4e:	e44e                	sd	s3,8(sp)
    80001e50:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e52:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e56:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e5a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e5e:	1004f793          	andi	a5,s1,256
    80001e62:	cb85                	beqz	a5,80001e92 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e64:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e68:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e6a:	ef85                	bnez	a5,80001ea2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	e42080e7          	jalr	-446(ra) # 80001cae <devintr>
    80001e74:	cd1d                	beqz	a0,80001eb2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e76:	4789                	li	a5,2
    80001e78:	06f50a63          	beq	a0,a5,80001eec <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e7c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e80:	10049073          	csrw	sstatus,s1
}
    80001e84:	70a2                	ld	ra,40(sp)
    80001e86:	7402                	ld	s0,32(sp)
    80001e88:	64e2                	ld	s1,24(sp)
    80001e8a:	6942                	ld	s2,16(sp)
    80001e8c:	69a2                	ld	s3,8(sp)
    80001e8e:	6145                	addi	sp,sp,48
    80001e90:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	47650513          	addi	a0,a0,1142 # 80008308 <states.1725+0xc8>
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	352080e7          	jalr	850(ra) # 800061ec <panic>
    panic("kerneltrap: interrupts enabled");
    80001ea2:	00006517          	auipc	a0,0x6
    80001ea6:	48e50513          	addi	a0,a0,1166 # 80008330 <states.1725+0xf0>
    80001eaa:	00004097          	auipc	ra,0x4
    80001eae:	342080e7          	jalr	834(ra) # 800061ec <panic>
    printf("scause %p\n", scause);
    80001eb2:	85ce                	mv	a1,s3
    80001eb4:	00006517          	auipc	a0,0x6
    80001eb8:	49c50513          	addi	a0,a0,1180 # 80008350 <states.1725+0x110>
    80001ebc:	00004097          	auipc	ra,0x4
    80001ec0:	37a080e7          	jalr	890(ra) # 80006236 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ecc:	00006517          	auipc	a0,0x6
    80001ed0:	49450513          	addi	a0,a0,1172 # 80008360 <states.1725+0x120>
    80001ed4:	00004097          	auipc	ra,0x4
    80001ed8:	362080e7          	jalr	866(ra) # 80006236 <printf>
    panic("kerneltrap");
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	49c50513          	addi	a0,a0,1180 # 80008378 <states.1725+0x138>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	308080e7          	jalr	776(ra) # 800061ec <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	07a080e7          	jalr	122(ra) # 80000f66 <myproc>
    80001ef4:	d541                	beqz	a0,80001e7c <kerneltrap+0x38>
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	070080e7          	jalr	112(ra) # 80000f66 <myproc>
    80001efe:	5118                	lw	a4,32(a0)
    80001f00:	4791                	li	a5,4
    80001f02:	f6f71de3          	bne	a4,a5,80001e7c <kerneltrap+0x38>
    yield();
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	6e0080e7          	jalr	1760(ra) # 800015e6 <yield>
    80001f0e:	b7bd                	j	80001e7c <kerneltrap+0x38>

0000000080001f10 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f10:	1101                	addi	sp,sp,-32
    80001f12:	ec06                	sd	ra,24(sp)
    80001f14:	e822                	sd	s0,16(sp)
    80001f16:	e426                	sd	s1,8(sp)
    80001f18:	1000                	addi	s0,sp,32
    80001f1a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	04a080e7          	jalr	74(ra) # 80000f66 <myproc>
  switch (n) {
    80001f24:	4795                	li	a5,5
    80001f26:	0497e163          	bltu	a5,s1,80001f68 <argraw+0x58>
    80001f2a:	048a                	slli	s1,s1,0x2
    80001f2c:	00006717          	auipc	a4,0x6
    80001f30:	48470713          	addi	a4,a4,1156 # 800083b0 <states.1725+0x170>
    80001f34:	94ba                	add	s1,s1,a4
    80001f36:	409c                	lw	a5,0(s1)
    80001f38:	97ba                	add	a5,a5,a4
    80001f3a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f3c:	713c                	ld	a5,96(a0)
    80001f3e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f40:	60e2                	ld	ra,24(sp)
    80001f42:	6442                	ld	s0,16(sp)
    80001f44:	64a2                	ld	s1,8(sp)
    80001f46:	6105                	addi	sp,sp,32
    80001f48:	8082                	ret
    return p->trapframe->a1;
    80001f4a:	713c                	ld	a5,96(a0)
    80001f4c:	7fa8                	ld	a0,120(a5)
    80001f4e:	bfcd                	j	80001f40 <argraw+0x30>
    return p->trapframe->a2;
    80001f50:	713c                	ld	a5,96(a0)
    80001f52:	63c8                	ld	a0,128(a5)
    80001f54:	b7f5                	j	80001f40 <argraw+0x30>
    return p->trapframe->a3;
    80001f56:	713c                	ld	a5,96(a0)
    80001f58:	67c8                	ld	a0,136(a5)
    80001f5a:	b7dd                	j	80001f40 <argraw+0x30>
    return p->trapframe->a4;
    80001f5c:	713c                	ld	a5,96(a0)
    80001f5e:	6bc8                	ld	a0,144(a5)
    80001f60:	b7c5                	j	80001f40 <argraw+0x30>
    return p->trapframe->a5;
    80001f62:	713c                	ld	a5,96(a0)
    80001f64:	6fc8                	ld	a0,152(a5)
    80001f66:	bfe9                	j	80001f40 <argraw+0x30>
  panic("argraw");
    80001f68:	00006517          	auipc	a0,0x6
    80001f6c:	42050513          	addi	a0,a0,1056 # 80008388 <states.1725+0x148>
    80001f70:	00004097          	auipc	ra,0x4
    80001f74:	27c080e7          	jalr	636(ra) # 800061ec <panic>

0000000080001f78 <fetchaddr>:
{
    80001f78:	1101                	addi	sp,sp,-32
    80001f7a:	ec06                	sd	ra,24(sp)
    80001f7c:	e822                	sd	s0,16(sp)
    80001f7e:	e426                	sd	s1,8(sp)
    80001f80:	e04a                	sd	s2,0(sp)
    80001f82:	1000                	addi	s0,sp,32
    80001f84:	84aa                	mv	s1,a0
    80001f86:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	fde080e7          	jalr	-34(ra) # 80000f66 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f90:	693c                	ld	a5,80(a0)
    80001f92:	02f4f863          	bgeu	s1,a5,80001fc2 <fetchaddr+0x4a>
    80001f96:	00848713          	addi	a4,s1,8
    80001f9a:	02e7e663          	bltu	a5,a4,80001fc6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f9e:	46a1                	li	a3,8
    80001fa0:	8626                	mv	a2,s1
    80001fa2:	85ca                	mv	a1,s2
    80001fa4:	6d28                	ld	a0,88(a0)
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	d0e080e7          	jalr	-754(ra) # 80000cb4 <copyin>
    80001fae:	00a03533          	snez	a0,a0
    80001fb2:	40a00533          	neg	a0,a0
}
    80001fb6:	60e2                	ld	ra,24(sp)
    80001fb8:	6442                	ld	s0,16(sp)
    80001fba:	64a2                	ld	s1,8(sp)
    80001fbc:	6902                	ld	s2,0(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret
    return -1;
    80001fc2:	557d                	li	a0,-1
    80001fc4:	bfcd                	j	80001fb6 <fetchaddr+0x3e>
    80001fc6:	557d                	li	a0,-1
    80001fc8:	b7fd                	j	80001fb6 <fetchaddr+0x3e>

0000000080001fca <fetchstr>:
{
    80001fca:	7179                	addi	sp,sp,-48
    80001fcc:	f406                	sd	ra,40(sp)
    80001fce:	f022                	sd	s0,32(sp)
    80001fd0:	ec26                	sd	s1,24(sp)
    80001fd2:	e84a                	sd	s2,16(sp)
    80001fd4:	e44e                	sd	s3,8(sp)
    80001fd6:	1800                	addi	s0,sp,48
    80001fd8:	892a                	mv	s2,a0
    80001fda:	84ae                	mv	s1,a1
    80001fdc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fde:	fffff097          	auipc	ra,0xfffff
    80001fe2:	f88080e7          	jalr	-120(ra) # 80000f66 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fe6:	86ce                	mv	a3,s3
    80001fe8:	864a                	mv	a2,s2
    80001fea:	85a6                	mv	a1,s1
    80001fec:	6d28                	ld	a0,88(a0)
    80001fee:	fffff097          	auipc	ra,0xfffff
    80001ff2:	d52080e7          	jalr	-686(ra) # 80000d40 <copyinstr>
  if(err < 0)
    80001ff6:	00054763          	bltz	a0,80002004 <fetchstr+0x3a>
  return strlen(buf);
    80001ffa:	8526                	mv	a0,s1
    80001ffc:	ffffe097          	auipc	ra,0xffffe
    80002000:	40e080e7          	jalr	1038(ra) # 8000040a <strlen>
}
    80002004:	70a2                	ld	ra,40(sp)
    80002006:	7402                	ld	s0,32(sp)
    80002008:	64e2                	ld	s1,24(sp)
    8000200a:	6942                	ld	s2,16(sp)
    8000200c:	69a2                	ld	s3,8(sp)
    8000200e:	6145                	addi	sp,sp,48
    80002010:	8082                	ret

0000000080002012 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002012:	1101                	addi	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	1000                	addi	s0,sp,32
    8000201c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000201e:	00000097          	auipc	ra,0x0
    80002022:	ef2080e7          	jalr	-270(ra) # 80001f10 <argraw>
    80002026:	c088                	sw	a0,0(s1)
  return 0;
}
    80002028:	4501                	li	a0,0
    8000202a:	60e2                	ld	ra,24(sp)
    8000202c:	6442                	ld	s0,16(sp)
    8000202e:	64a2                	ld	s1,8(sp)
    80002030:	6105                	addi	sp,sp,32
    80002032:	8082                	ret

0000000080002034 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	1000                	addi	s0,sp,32
    8000203e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002040:	00000097          	auipc	ra,0x0
    80002044:	ed0080e7          	jalr	-304(ra) # 80001f10 <argraw>
    80002048:	e088                	sd	a0,0(s1)
  return 0;
}
    8000204a:	4501                	li	a0,0
    8000204c:	60e2                	ld	ra,24(sp)
    8000204e:	6442                	ld	s0,16(sp)
    80002050:	64a2                	ld	s1,8(sp)
    80002052:	6105                	addi	sp,sp,32
    80002054:	8082                	ret

0000000080002056 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002056:	1101                	addi	sp,sp,-32
    80002058:	ec06                	sd	ra,24(sp)
    8000205a:	e822                	sd	s0,16(sp)
    8000205c:	e426                	sd	s1,8(sp)
    8000205e:	e04a                	sd	s2,0(sp)
    80002060:	1000                	addi	s0,sp,32
    80002062:	84ae                	mv	s1,a1
    80002064:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	eaa080e7          	jalr	-342(ra) # 80001f10 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000206e:	864a                	mv	a2,s2
    80002070:	85a6                	mv	a1,s1
    80002072:	00000097          	auipc	ra,0x0
    80002076:	f58080e7          	jalr	-168(ra) # 80001fca <fetchstr>
}
    8000207a:	60e2                	ld	ra,24(sp)
    8000207c:	6442                	ld	s0,16(sp)
    8000207e:	64a2                	ld	s1,8(sp)
    80002080:	6902                	ld	s2,0(sp)
    80002082:	6105                	addi	sp,sp,32
    80002084:	8082                	ret

0000000080002086 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002086:	1101                	addi	sp,sp,-32
    80002088:	ec06                	sd	ra,24(sp)
    8000208a:	e822                	sd	s0,16(sp)
    8000208c:	e426                	sd	s1,8(sp)
    8000208e:	e04a                	sd	s2,0(sp)
    80002090:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	ed4080e7          	jalr	-300(ra) # 80000f66 <myproc>
    8000209a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000209c:	06053903          	ld	s2,96(a0)
    800020a0:	0a893783          	ld	a5,168(s2)
    800020a4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020a8:	37fd                	addiw	a5,a5,-1
    800020aa:	4751                	li	a4,20
    800020ac:	00f76f63          	bltu	a4,a5,800020ca <syscall+0x44>
    800020b0:	00369713          	slli	a4,a3,0x3
    800020b4:	00006797          	auipc	a5,0x6
    800020b8:	31478793          	addi	a5,a5,788 # 800083c8 <syscalls>
    800020bc:	97ba                	add	a5,a5,a4
    800020be:	639c                	ld	a5,0(a5)
    800020c0:	c789                	beqz	a5,800020ca <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020c2:	9782                	jalr	a5
    800020c4:	06a93823          	sd	a0,112(s2)
    800020c8:	a839                	j	800020e6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020ca:	16048613          	addi	a2,s1,352
    800020ce:	5c8c                	lw	a1,56(s1)
    800020d0:	00006517          	auipc	a0,0x6
    800020d4:	2c050513          	addi	a0,a0,704 # 80008390 <states.1725+0x150>
    800020d8:	00004097          	auipc	ra,0x4
    800020dc:	15e080e7          	jalr	350(ra) # 80006236 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020e0:	70bc                	ld	a5,96(s1)
    800020e2:	577d                	li	a4,-1
    800020e4:	fbb8                	sd	a4,112(a5)
  }
}
    800020e6:	60e2                	ld	ra,24(sp)
    800020e8:	6442                	ld	s0,16(sp)
    800020ea:	64a2                	ld	s1,8(sp)
    800020ec:	6902                	ld	s2,0(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020fa:	fec40593          	addi	a1,s0,-20
    800020fe:	4501                	li	a0,0
    80002100:	00000097          	auipc	ra,0x0
    80002104:	f12080e7          	jalr	-238(ra) # 80002012 <argint>
    return -1;
    80002108:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000210a:	00054963          	bltz	a0,8000211c <sys_exit+0x2a>
  exit(n);
    8000210e:	fec42503          	lw	a0,-20(s0)
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	76c080e7          	jalr	1900(ra) # 8000187e <exit>
  return 0;  // not reached
    8000211a:	4781                	li	a5,0
}
    8000211c:	853e                	mv	a0,a5
    8000211e:	60e2                	ld	ra,24(sp)
    80002120:	6442                	ld	s0,16(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret

0000000080002126 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002126:	1141                	addi	sp,sp,-16
    80002128:	e406                	sd	ra,8(sp)
    8000212a:	e022                	sd	s0,0(sp)
    8000212c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	e38080e7          	jalr	-456(ra) # 80000f66 <myproc>
}
    80002136:	5d08                	lw	a0,56(a0)
    80002138:	60a2                	ld	ra,8(sp)
    8000213a:	6402                	ld	s0,0(sp)
    8000213c:	0141                	addi	sp,sp,16
    8000213e:	8082                	ret

0000000080002140 <sys_fork>:

uint64
sys_fork(void)
{
    80002140:	1141                	addi	sp,sp,-16
    80002142:	e406                	sd	ra,8(sp)
    80002144:	e022                	sd	s0,0(sp)
    80002146:	0800                	addi	s0,sp,16
  return fork();
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	1ec080e7          	jalr	492(ra) # 80001334 <fork>
}
    80002150:	60a2                	ld	ra,8(sp)
    80002152:	6402                	ld	s0,0(sp)
    80002154:	0141                	addi	sp,sp,16
    80002156:	8082                	ret

0000000080002158 <sys_wait>:

uint64
sys_wait(void)
{
    80002158:	1101                	addi	sp,sp,-32
    8000215a:	ec06                	sd	ra,24(sp)
    8000215c:	e822                	sd	s0,16(sp)
    8000215e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002160:	fe840593          	addi	a1,s0,-24
    80002164:	4501                	li	a0,0
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	ece080e7          	jalr	-306(ra) # 80002034 <argaddr>
    8000216e:	87aa                	mv	a5,a0
    return -1;
    80002170:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002172:	0007c863          	bltz	a5,80002182 <sys_wait+0x2a>
  return wait(p);
    80002176:	fe843503          	ld	a0,-24(s0)
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	50c080e7          	jalr	1292(ra) # 80001686 <wait>
}
    80002182:	60e2                	ld	ra,24(sp)
    80002184:	6442                	ld	s0,16(sp)
    80002186:	6105                	addi	sp,sp,32
    80002188:	8082                	ret

000000008000218a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000218a:	7179                	addi	sp,sp,-48
    8000218c:	f406                	sd	ra,40(sp)
    8000218e:	f022                	sd	s0,32(sp)
    80002190:	ec26                	sd	s1,24(sp)
    80002192:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002194:	fdc40593          	addi	a1,s0,-36
    80002198:	4501                	li	a0,0
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	e78080e7          	jalr	-392(ra) # 80002012 <argint>
    800021a2:	87aa                	mv	a5,a0
    return -1;
    800021a4:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021a6:	0207c063          	bltz	a5,800021c6 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	dbc080e7          	jalr	-580(ra) # 80000f66 <myproc>
    800021b2:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021b4:	fdc42503          	lw	a0,-36(s0)
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	108080e7          	jalr	264(ra) # 800012c0 <growproc>
    800021c0:	00054863          	bltz	a0,800021d0 <sys_sbrk+0x46>
    return -1;
  return addr;
    800021c4:	8526                	mv	a0,s1
}
    800021c6:	70a2                	ld	ra,40(sp)
    800021c8:	7402                	ld	s0,32(sp)
    800021ca:	64e2                	ld	s1,24(sp)
    800021cc:	6145                	addi	sp,sp,48
    800021ce:	8082                	ret
    return -1;
    800021d0:	557d                	li	a0,-1
    800021d2:	bfd5                	j	800021c6 <sys_sbrk+0x3c>

00000000800021d4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d4:	7139                	addi	sp,sp,-64
    800021d6:	fc06                	sd	ra,56(sp)
    800021d8:	f822                	sd	s0,48(sp)
    800021da:	f426                	sd	s1,40(sp)
    800021dc:	f04a                	sd	s2,32(sp)
    800021de:	ec4e                	sd	s3,24(sp)
    800021e0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021e2:	fcc40593          	addi	a1,s0,-52
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	e2a080e7          	jalr	-470(ra) # 80002012 <argint>
    return -1;
    800021f0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021f2:	06054563          	bltz	a0,8000225c <sys_sleep+0x88>
  acquire(&tickslock);
    800021f6:	0000d517          	auipc	a0,0xd
    800021fa:	fba50513          	addi	a0,a0,-70 # 8000f1b0 <tickslock>
    800021fe:	00004097          	auipc	ra,0x4
    80002202:	522080e7          	jalr	1314(ra) # 80006720 <acquire>
  ticks0 = ticks;
    80002206:	00007917          	auipc	s2,0x7
    8000220a:	e1292903          	lw	s2,-494(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000220e:	fcc42783          	lw	a5,-52(s0)
    80002212:	cf85                	beqz	a5,8000224a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002214:	0000d997          	auipc	s3,0xd
    80002218:	f9c98993          	addi	s3,s3,-100 # 8000f1b0 <tickslock>
    8000221c:	00007497          	auipc	s1,0x7
    80002220:	dfc48493          	addi	s1,s1,-516 # 80009018 <ticks>
    if(myproc()->killed){
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	d42080e7          	jalr	-702(ra) # 80000f66 <myproc>
    8000222c:	591c                	lw	a5,48(a0)
    8000222e:	ef9d                	bnez	a5,8000226c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002230:	85ce                	mv	a1,s3
    80002232:	8526                	mv	a0,s1
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	3ee080e7          	jalr	1006(ra) # 80001622 <sleep>
  while(ticks - ticks0 < n){
    8000223c:	409c                	lw	a5,0(s1)
    8000223e:	412787bb          	subw	a5,a5,s2
    80002242:	fcc42703          	lw	a4,-52(s0)
    80002246:	fce7efe3          	bltu	a5,a4,80002224 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000224a:	0000d517          	auipc	a0,0xd
    8000224e:	f6650513          	addi	a0,a0,-154 # 8000f1b0 <tickslock>
    80002252:	00004097          	auipc	ra,0x4
    80002256:	59e080e7          	jalr	1438(ra) # 800067f0 <release>
  return 0;
    8000225a:	4781                	li	a5,0
}
    8000225c:	853e                	mv	a0,a5
    8000225e:	70e2                	ld	ra,56(sp)
    80002260:	7442                	ld	s0,48(sp)
    80002262:	74a2                	ld	s1,40(sp)
    80002264:	7902                	ld	s2,32(sp)
    80002266:	69e2                	ld	s3,24(sp)
    80002268:	6121                	addi	sp,sp,64
    8000226a:	8082                	ret
      release(&tickslock);
    8000226c:	0000d517          	auipc	a0,0xd
    80002270:	f4450513          	addi	a0,a0,-188 # 8000f1b0 <tickslock>
    80002274:	00004097          	auipc	ra,0x4
    80002278:	57c080e7          	jalr	1404(ra) # 800067f0 <release>
      return -1;
    8000227c:	57fd                	li	a5,-1
    8000227e:	bff9                	j	8000225c <sys_sleep+0x88>

0000000080002280 <sys_kill>:

uint64
sys_kill(void)
{
    80002280:	1101                	addi	sp,sp,-32
    80002282:	ec06                	sd	ra,24(sp)
    80002284:	e822                	sd	s0,16(sp)
    80002286:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002288:	fec40593          	addi	a1,s0,-20
    8000228c:	4501                	li	a0,0
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	d84080e7          	jalr	-636(ra) # 80002012 <argint>
    80002296:	87aa                	mv	a5,a0
    return -1;
    80002298:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000229a:	0007c863          	bltz	a5,800022aa <sys_kill+0x2a>
  return kill(pid);
    8000229e:	fec42503          	lw	a0,-20(s0)
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	6b2080e7          	jalr	1714(ra) # 80001954 <kill>
}
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	6105                	addi	sp,sp,32
    800022b0:	8082                	ret

00000000800022b2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022b2:	1101                	addi	sp,sp,-32
    800022b4:	ec06                	sd	ra,24(sp)
    800022b6:	e822                	sd	s0,16(sp)
    800022b8:	e426                	sd	s1,8(sp)
    800022ba:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022bc:	0000d517          	auipc	a0,0xd
    800022c0:	ef450513          	addi	a0,a0,-268 # 8000f1b0 <tickslock>
    800022c4:	00004097          	auipc	ra,0x4
    800022c8:	45c080e7          	jalr	1116(ra) # 80006720 <acquire>
  xticks = ticks;
    800022cc:	00007497          	auipc	s1,0x7
    800022d0:	d4c4a483          	lw	s1,-692(s1) # 80009018 <ticks>
  release(&tickslock);
    800022d4:	0000d517          	auipc	a0,0xd
    800022d8:	edc50513          	addi	a0,a0,-292 # 8000f1b0 <tickslock>
    800022dc:	00004097          	auipc	ra,0x4
    800022e0:	514080e7          	jalr	1300(ra) # 800067f0 <release>
  return xticks;
}
    800022e4:	02049513          	slli	a0,s1,0x20
    800022e8:	9101                	srli	a0,a0,0x20
    800022ea:	60e2                	ld	ra,24(sp)
    800022ec:	6442                	ld	s0,16(sp)
    800022ee:	64a2                	ld	s1,8(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <hash>:
#include "fs.h"
#include "buf.h"
#define NBUCKET 13 // Upper limit of hash buckets
#define INTMAX 0x7fffffff

int hash(uint dev, uint blockno) {return ((blockno) % NBUCKET);} // Hash function
    800022f4:	1141                	addi	sp,sp,-16
    800022f6:	e422                	sd	s0,8(sp)
    800022f8:	0800                	addi	s0,sp,16
    800022fa:	4535                	li	a0,13
    800022fc:	02a5f53b          	remuw	a0,a1,a0
    80002300:	6422                	ld	s0,8(sp)
    80002302:	0141                	addi	sp,sp,16
    80002304:	8082                	ret

0000000080002306 <binit>:
  struct spinlock bucket_locks[NBUCKET];
} bcache;

void
binit(void)
{ 
    80002306:	711d                	addi	sp,sp,-96
    80002308:	ec86                	sd	ra,88(sp)
    8000230a:	e8a2                	sd	s0,80(sp)
    8000230c:	e4a6                	sd	s1,72(sp)
    8000230e:	e0ca                	sd	s2,64(sp)
    80002310:	fc4e                	sd	s3,56(sp)
    80002312:	f852                	sd	s4,48(sp)
    80002314:	f456                	sd	s5,40(sp)
    80002316:	1080                	addi	s0,sp,96
  initlock(&bcache.lock, "bcache_lock");
    80002318:	00006597          	auipc	a1,0x6
    8000231c:	16058593          	addi	a1,a1,352 # 80008478 <syscalls+0xb0>
    80002320:	0000d517          	auipc	a0,0xd
    80002324:	eb050513          	addi	a0,a0,-336 # 8000f1d0 <bcache>
    80002328:	00004097          	auipc	ra,0x4
    8000232c:	574080e7          	jalr	1396(ra) # 8000689c <initlock>

    // Initialize buckets
    char name[32];
    for (int i = 0; i < NBUCKET; i++) {
    80002330:	00019997          	auipc	s3,0x19
    80002334:	c3898993          	addi	s3,s3,-968 # 8001af68 <bcache+0xbd98>
    80002338:	00015917          	auipc	s2,0x15
    8000233c:	34090913          	addi	s2,s2,832 # 80017678 <bcache+0x84a8>
    80002340:	4481                	li	s1,0
        snprintf(name, 32, "bucket_lock_%d", i);
    80002342:	00006a97          	auipc	s5,0x6
    80002346:	146a8a93          	addi	s5,s5,326 # 80008488 <syscalls+0xc0>
    for (int i = 0; i < NBUCKET; i++) {
    8000234a:	4a35                	li	s4,13
        snprintf(name, 32, "bucket_lock_%d", i);
    8000234c:	86a6                	mv	a3,s1
    8000234e:	8656                	mv	a2,s5
    80002350:	02000593          	li	a1,32
    80002354:	fa040513          	addi	a0,s0,-96
    80002358:	00003097          	auipc	ra,0x3
    8000235c:	7fa080e7          	jalr	2042(ra) # 80005b52 <snprintf>
        initlock(&bcache.bucket_locks[i], name);
    80002360:	fa040593          	addi	a1,s0,-96
    80002364:	854e                	mv	a0,s3
    80002366:	00004097          	auipc	ra,0x4
    8000236a:	536080e7          	jalr	1334(ra) # 8000689c <initlock>
        bcache.bucket[i].next = 0;
    8000236e:	00093023          	sd	zero,0(s2)
    for (int i = 0; i < NBUCKET; i++) {
    80002372:	2485                	addiw	s1,s1,1
    80002374:	02098993          	addi	s3,s3,32
    80002378:	46890913          	addi	s2,s2,1128
    8000237c:	fd4498e3          	bne	s1,s4,8000234c <binit+0x46>
    80002380:	0000d497          	auipc	s1,0xd
    80002384:	e8048493          	addi	s1,s1,-384 # 8000f200 <bcache+0x30>
    80002388:	00015a17          	auipc	s4,0x15
    8000238c:	2a8a0a13          	addi	s4,s4,680 # 80017630 <bcache+0x8460>
    }

    // Initialize buffers
    for (int i = 0; i < NBUF; i++) {
        struct buf *b = &bcache.buf[i]; // Head pointer of the linked list
        initsleeplock(&b->lock, "buffer");
    80002390:	00006997          	auipc	s3,0x6
    80002394:	10898993          	addi	s3,s3,264 # 80008498 <syscalls+0xd0>
        b->lut = 0;
        b->refcnt = 0;
        b->curBucket = 0;

        // Insert buffer into bucket[0]
        b->next = bcache.bucket[0].next;
    80002398:	00015917          	auipc	s2,0x15
    8000239c:	e3890913          	addi	s2,s2,-456 # 800171d0 <bcache+0x8000>
        initsleeplock(&b->lock, "buffer");
    800023a0:	85ce                	mv	a1,s3
    800023a2:	8526                	mv	a0,s1
    800023a4:	00001097          	auipc	ra,0x1
    800023a8:	6e2080e7          	jalr	1762(ra) # 80003a86 <initsleeplock>
        b->lut = 0;
    800023ac:	4404a823          	sw	zero,1104(s1)
        b->refcnt = 0;
    800023b0:	0204ac23          	sw	zero,56(s1)
        b->curBucket = 0;
    800023b4:	4404aa23          	sw	zero,1108(s1)
        b->next = bcache.bucket[0].next;
    800023b8:	4a893783          	ld	a5,1192(s2)
    800023bc:	e4bc                	sd	a5,72(s1)
        bcache.bucket[0].next = b;
    800023be:	ff048793          	addi	a5,s1,-16
    800023c2:	4af93423          	sd	a5,1192(s2)
    for (int i = 0; i < NBUF; i++) {
    800023c6:	46848493          	addi	s1,s1,1128
    800023ca:	fd449be3          	bne	s1,s4,800023a0 <binit+0x9a>
    }
}
    800023ce:	60e6                	ld	ra,88(sp)
    800023d0:	6446                	ld	s0,80(sp)
    800023d2:	64a6                	ld	s1,72(sp)
    800023d4:	6906                	ld	s2,64(sp)
    800023d6:	79e2                	ld	s3,56(sp)
    800023d8:	7a42                	ld	s4,48(sp)
    800023da:	7aa2                	ld	s5,40(sp)
    800023dc:	6125                	addi	sp,sp,96
    800023de:	8082                	ret

00000000800023e0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e0:	7119                	addi	sp,sp,-128
    800023e2:	fc86                	sd	ra,120(sp)
    800023e4:	f8a2                	sd	s0,112(sp)
    800023e6:	f4a6                	sd	s1,104(sp)
    800023e8:	f0ca                	sd	s2,96(sp)
    800023ea:	ecce                	sd	s3,88(sp)
    800023ec:	e8d2                	sd	s4,80(sp)
    800023ee:	e4d6                	sd	s5,72(sp)
    800023f0:	e0da                	sd	s6,64(sp)
    800023f2:	fc5e                	sd	s7,56(sp)
    800023f4:	f862                	sd	s8,48(sp)
    800023f6:	f466                	sd	s9,40(sp)
    800023f8:	f06a                	sd	s10,32(sp)
    800023fa:	ec6e                	sd	s11,24(sp)
    800023fc:	0100                	addi	s0,sp,128
    800023fe:	8aaa                	mv	s5,a0
    80002400:	8a2e                	mv	s4,a1
int hash(uint dev, uint blockno) {return ((blockno) % NBUCKET);} // Hash function
    80002402:	49b5                	li	s3,13
    80002404:	0335f9bb          	remuw	s3,a1,s3
    80002408:	00098d9b          	sext.w	s11,s3
    acquire(&bcache.bucket_locks[index]);
    8000240c:	02099b13          	slli	s6,s3,0x20
    80002410:	020b5b13          	srli	s6,s6,0x20
    80002414:	005b1913          	slli	s2,s6,0x5
    80002418:	67b1                	lui	a5,0xc
    8000241a:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    8000241e:	993e                	add	s2,s2,a5
    80002420:	0000d497          	auipc	s1,0xd
    80002424:	db048493          	addi	s1,s1,-592 # 8000f1d0 <bcache>
    80002428:	9926                	add	s2,s2,s1
    8000242a:	854a                	mv	a0,s2
    8000242c:	00004097          	auipc	ra,0x4
    80002430:	2f4080e7          	jalr	756(ra) # 80006720 <acquire>
    struct buf *b = bcache.bucket[index].next;
    80002434:	46800793          	li	a5,1128
    80002438:	02fb0b33          	mul	s6,s6,a5
    8000243c:	94da                	add	s1,s1,s6
    8000243e:	67a1                	lui	a5,0x8
    80002440:	94be                	add	s1,s1,a5
    80002442:	4a84bb83          	ld	s7,1192(s1)
    while (b) {
    80002446:	060b9a63          	bnez	s7,800024ba <bread+0xda>
    release(&bcache.bucket_locks[index]);
    8000244a:	854a                	mv	a0,s2
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	3a4080e7          	jalr	932(ra) # 800067f0 <release>
    acquire(&bcache.lock);
    80002454:	0000d517          	auipc	a0,0xd
    80002458:	d7c50513          	addi	a0,a0,-644 # 8000f1d0 <bcache>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	2c4080e7          	jalr	708(ra) # 80006720 <acquire>
    b = bcache.bucket[index].next;
    80002464:	02099713          	slli	a4,s3,0x20
    80002468:	9301                	srli	a4,a4,0x20
    8000246a:	46800793          	li	a5,1128
    8000246e:	02f70733          	mul	a4,a4,a5
    80002472:	0000d797          	auipc	a5,0xd
    80002476:	d5e78793          	addi	a5,a5,-674 # 8000f1d0 <bcache>
    8000247a:	973e                	add	a4,a4,a5
    8000247c:	67a1                	lui	a5,0x8
    8000247e:	97ba                	add	a5,a5,a4
    80002480:	4a87bb83          	ld	s7,1192(a5) # 84a8 <_entry-0x7fff7b58>
    while (b) {
    80002484:	060b9863          	bnez	s7,800024f4 <bread+0x114>
    80002488:	00019d17          	auipc	s10,0x19
    8000248c:	ae0d0d13          	addi	s10,s10,-1312 # 8001af68 <bcache+0xbd98>
    80002490:	00015c97          	auipc	s9,0x15
    80002494:	190c8c93          	addi	s9,s9,400 # 80017620 <bcache+0x8450>
{
    80002498:	80000bb7          	lui	s7,0x80000
    8000249c:	fffbcb93          	not	s7,s7
    800024a0:	4b01                	li	s6,0
    800024a2:	54fd                	li	s1,-1
    800024a4:	4c01                	li	s8,0
                release(&bcache.bucket_locks[curBucket]);
    800024a6:	67b1                	lui	a5,0xc
    800024a8:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    800024ac:	f8f43023          	sd	a5,-128(s0)
    800024b0:	a8d1                	j	80002584 <bread+0x1a4>
        b = b->next;
    800024b2:	058bbb83          	ld	s7,88(s7) # ffffffff80000058 <end+0xfffffffefffd4e10>
    while (b) {
    800024b6:	f80b8ae3          	beqz	s7,8000244a <bread+0x6a>
        if (b->dev == dev && b->blockno == blockno) {
    800024ba:	008ba783          	lw	a5,8(s7)
    800024be:	ff579ae3          	bne	a5,s5,800024b2 <bread+0xd2>
    800024c2:	00cba783          	lw	a5,12(s7)
    800024c6:	ff4796e3          	bne	a5,s4,800024b2 <bread+0xd2>
            b->refcnt++;
    800024ca:	048ba783          	lw	a5,72(s7)
    800024ce:	2785                	addiw	a5,a5,1
    800024d0:	04fba423          	sw	a5,72(s7)
            release(&bcache.bucket_locks[index]);
    800024d4:	854a                	mv	a0,s2
    800024d6:	00004097          	auipc	ra,0x4
    800024da:	31a080e7          	jalr	794(ra) # 800067f0 <release>
            acquiresleep(&b->lock);
    800024de:	010b8513          	addi	a0,s7,16
    800024e2:	00001097          	auipc	ra,0x1
    800024e6:	5de080e7          	jalr	1502(ra) # 80003ac0 <acquiresleep>
            return b;
    800024ea:	a235                	j	80002616 <bread+0x236>
        b = b->next;
    800024ec:	058bbb83          	ld	s7,88(s7)
    while (b) {
    800024f0:	f80b8ce3          	beqz	s7,80002488 <bread+0xa8>
        if (b->dev == dev && b->blockno == blockno) {
    800024f4:	008ba783          	lw	a5,8(s7)
    800024f8:	ff579ae3          	bne	a5,s5,800024ec <bread+0x10c>
    800024fc:	00cba783          	lw	a5,12(s7)
    80002500:	ff4796e3          	bne	a5,s4,800024ec <bread+0x10c>
            acquire(&bcache.bucket_locks[index]);
    80002504:	854a                	mv	a0,s2
    80002506:	00004097          	auipc	ra,0x4
    8000250a:	21a080e7          	jalr	538(ra) # 80006720 <acquire>
            b->refcnt++;
    8000250e:	048ba783          	lw	a5,72(s7)
    80002512:	2785                	addiw	a5,a5,1
    80002514:	04fba423          	sw	a5,72(s7)
            release(&bcache.bucket_locks[index]);
    80002518:	854a                	mv	a0,s2
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	2d6080e7          	jalr	726(ra) # 800067f0 <release>
            release(&bcache.lock); // Release the bcache lock
    80002522:	0000d517          	auipc	a0,0xd
    80002526:	cae50513          	addi	a0,a0,-850 # 8000f1d0 <bcache>
    8000252a:	00004097          	auipc	ra,0x4
    8000252e:	2c6080e7          	jalr	710(ra) # 800067f0 <release>
            acquiresleep(&b->lock);
    80002532:	010b8513          	addi	a0,s7,16
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	58a080e7          	jalr	1418(ra) # 80003ac0 <acquiresleep>
            return b;
    8000253e:	a8e1                	j	80002616 <bread+0x236>
                lut = b->next->lut;
    80002540:	4607ab83          	lw	s7,1120(a5)
                found = 1;
    80002544:	8b36                	mv	s6,a3
    80002546:	4705                	li	a4,1
        while (b->next) {
    80002548:	6fb0                	ld	a2,88(a5)
    8000254a:	86be                	mv	a3,a5
    8000254c:	ce11                	beqz	a2,80002568 <bread+0x188>
    8000254e:	87b2                	mv	a5,a2
            if (b->next->refcnt == 0 && LRUb == 0) {
    80002550:	47b0                	lw	a2,72(a5)
    80002552:	fa7d                	bnez	a2,80002548 <bread+0x168>
    80002554:	fe0b06e3          	beqz	s6,80002540 <bread+0x160>
            else if (b->next->refcnt == 0 && b->next->lut < lut) {
    80002558:	4607a603          	lw	a2,1120(a5)
    8000255c:	ff7676e3          	bgeu	a2,s7,80002548 <bread+0x168>
                lut = b->next->lut;
    80002560:	8bb2                	mv	s7,a2
            else if (b->next->refcnt == 0 && b->next->lut < lut) {
    80002562:	8b36                	mv	s6,a3
                found = 1;
    80002564:	4705                	li	a4,1
    80002566:	b7cd                	j	80002548 <bread+0x168>
        if (found) {
    80002568:	cf21                	beqz	a4,800025c0 <bread+0x1e0>
            if (curBucket != -1) {
    8000256a:	57fd                	li	a5,-1
    8000256c:	02f49963          	bne	s1,a5,8000259e <bread+0x1be>
            curBucket = i;
    80002570:	000c049b          	sext.w	s1,s8
    for (int i = 0; i < NBUCKET; i++) {
    80002574:	2c05                	addiw	s8,s8,1
    80002576:	020d0d13          	addi	s10,s10,32
    8000257a:	468c8c93          	addi	s9,s9,1128
    8000257e:	47b5                	li	a5,13
    80002580:	04fc0763          	beq	s8,a5,800025ce <bread+0x1ee>
        acquire(&bcache.bucket_locks[i]);
    80002584:	f9a43423          	sd	s10,-120(s0)
    80002588:	856a                	mv	a0,s10
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	196080e7          	jalr	406(ra) # 80006720 <acquire>
        b = &bcache.bucket[i];
    80002592:	86e6                	mv	a3,s9
        while (b->next) {
    80002594:	058cb783          	ld	a5,88(s9)
    80002598:	c785                	beqz	a5,800025c0 <bread+0x1e0>
        int found = 0;
    8000259a:	4701                	li	a4,0
    8000259c:	bf55                	j	80002550 <bread+0x170>
                release(&bcache.bucket_locks[curBucket]);
    8000259e:	02049513          	slli	a0,s1,0x20
    800025a2:	9101                	srli	a0,a0,0x20
    800025a4:	0516                	slli	a0,a0,0x5
    800025a6:	f8043783          	ld	a5,-128(s0)
    800025aa:	953e                	add	a0,a0,a5
    800025ac:	0000d797          	auipc	a5,0xd
    800025b0:	c2478793          	addi	a5,a5,-988 # 8000f1d0 <bcache>
    800025b4:	953e                	add	a0,a0,a5
    800025b6:	00004097          	auipc	ra,0x4
    800025ba:	23a080e7          	jalr	570(ra) # 800067f0 <release>
    800025be:	bf4d                	j	80002570 <bread+0x190>
            release(&bcache.bucket_locks[i]);
    800025c0:	f8843503          	ld	a0,-120(s0)
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	22c080e7          	jalr	556(ra) # 800067f0 <release>
    800025cc:	b765                	j	80002574 <bread+0x194>
    if (LRUb == 0) {
    800025ce:	060b0763          	beqz	s6,8000263c <bread+0x25c>
        struct buf *p = LRUb->next;
    800025d2:	058b3b83          	ld	s7,88(s6)
        if (curBucket != index) {
    800025d6:	07b49b63          	bne	s1,s11,8000264c <bread+0x26c>
        p->dev = dev;
    800025da:	015ba423          	sw	s5,8(s7)
        p->blockno = blockno;
    800025de:	014ba623          	sw	s4,12(s7)
        p->refcnt = 1;
    800025e2:	4785                	li	a5,1
    800025e4:	04fba423          	sw	a5,72(s7)
        p->valid = 0;
    800025e8:	000ba023          	sw	zero,0(s7)
        p->curBucket = index;
    800025ec:	473ba223          	sw	s3,1124(s7)
        release(&bcache.bucket_locks[index]); // Release the bucket[index] lock
    800025f0:	854a                	mv	a0,s2
    800025f2:	00004097          	auipc	ra,0x4
    800025f6:	1fe080e7          	jalr	510(ra) # 800067f0 <release>
        release(&bcache.lock);                // Release the bcache lock
    800025fa:	0000d517          	auipc	a0,0xd
    800025fe:	bd650513          	addi	a0,a0,-1066 # 8000f1d0 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	1ee080e7          	jalr	494(ra) # 800067f0 <release>
        acquiresleep(&p->lock);               // Acquire the sleeplock of LRUb
    8000260a:	010b8513          	addi	a0,s7,16
    8000260e:	00001097          	auipc	ra,0x1
    80002612:	4b2080e7          	jalr	1202(ra) # 80003ac0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002616:	000ba783          	lw	a5,0(s7)
    8000261a:	c7c1                	beqz	a5,800026a2 <bread+0x2c2>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000261c:	855e                	mv	a0,s7
    8000261e:	70e6                	ld	ra,120(sp)
    80002620:	7446                	ld	s0,112(sp)
    80002622:	74a6                	ld	s1,104(sp)
    80002624:	7906                	ld	s2,96(sp)
    80002626:	69e6                	ld	s3,88(sp)
    80002628:	6a46                	ld	s4,80(sp)
    8000262a:	6aa6                	ld	s5,72(sp)
    8000262c:	6b06                	ld	s6,64(sp)
    8000262e:	7be2                	ld	s7,56(sp)
    80002630:	7c42                	ld	s8,48(sp)
    80002632:	7ca2                	ld	s9,40(sp)
    80002634:	7d02                	ld	s10,32(sp)
    80002636:	6de2                	ld	s11,24(sp)
    80002638:	6109                	addi	sp,sp,128
    8000263a:	8082                	ret
        panic("bget: No buffer.");
    8000263c:	00006517          	auipc	a0,0x6
    80002640:	e6450513          	addi	a0,a0,-412 # 800084a0 <syscalls+0xd8>
    80002644:	00004097          	auipc	ra,0x4
    80002648:	ba8080e7          	jalr	-1112(ra) # 800061ec <panic>
            LRUb->next = p->next;
    8000264c:	058bb783          	ld	a5,88(s7)
    80002650:	04fb3c23          	sd	a5,88(s6)
            release(&bcache.bucket_locks[curBucket]);
    80002654:	02049513          	slli	a0,s1,0x20
    80002658:	9101                	srli	a0,a0,0x20
    8000265a:	0516                	slli	a0,a0,0x5
    8000265c:	64b1                	lui	s1,0xc
    8000265e:	d9848493          	addi	s1,s1,-616 # bd98 <_entry-0x7fff4268>
    80002662:	9526                	add	a0,a0,s1
    80002664:	0000d497          	auipc	s1,0xd
    80002668:	b6c48493          	addi	s1,s1,-1172 # 8000f1d0 <bcache>
    8000266c:	9526                	add	a0,a0,s1
    8000266e:	00004097          	auipc	ra,0x4
    80002672:	182080e7          	jalr	386(ra) # 800067f0 <release>
            acquire(&bcache.bucket_locks[index]);
    80002676:	854a                	mv	a0,s2
    80002678:	00004097          	auipc	ra,0x4
    8000267c:	0a8080e7          	jalr	168(ra) # 80006720 <acquire>
            p->next = bcache.bucket[index].next;
    80002680:	02099793          	slli	a5,s3,0x20
    80002684:	9381                	srli	a5,a5,0x20
    80002686:	46800713          	li	a4,1128
    8000268a:	02e787b3          	mul	a5,a5,a4
    8000268e:	94be                	add	s1,s1,a5
    80002690:	67a1                	lui	a5,0x8
    80002692:	97a6                	add	a5,a5,s1
    80002694:	4a87b703          	ld	a4,1192(a5) # 84a8 <_entry-0x7fff7b58>
    80002698:	04ebbc23          	sd	a4,88(s7)
            bcache.bucket[index].next = p;
    8000269c:	4b77b423          	sd	s7,1192(a5)
    800026a0:	bf2d                	j	800025da <bread+0x1fa>
    virtio_disk_rw(b, 0);
    800026a2:	4581                	li	a1,0
    800026a4:	855e                	mv	a0,s7
    800026a6:	00003097          	auipc	ra,0x3
    800026aa:	f50080e7          	jalr	-176(ra) # 800055f6 <virtio_disk_rw>
    b->valid = 1;
    800026ae:	4785                	li	a5,1
    800026b0:	00fba023          	sw	a5,0(s7)
  return b;
    800026b4:	b7a5                	j	8000261c <bread+0x23c>

00000000800026b6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026b6:	1101                	addi	sp,sp,-32
    800026b8:	ec06                	sd	ra,24(sp)
    800026ba:	e822                	sd	s0,16(sp)
    800026bc:	e426                	sd	s1,8(sp)
    800026be:	1000                	addi	s0,sp,32
    800026c0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026c2:	0541                	addi	a0,a0,16
    800026c4:	00001097          	auipc	ra,0x1
    800026c8:	496080e7          	jalr	1174(ra) # 80003b5a <holdingsleep>
    800026cc:	cd01                	beqz	a0,800026e4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026ce:	4585                	li	a1,1
    800026d0:	8526                	mv	a0,s1
    800026d2:	00003097          	auipc	ra,0x3
    800026d6:	f24080e7          	jalr	-220(ra) # 800055f6 <virtio_disk_rw>
}
    800026da:	60e2                	ld	ra,24(sp)
    800026dc:	6442                	ld	s0,16(sp)
    800026de:	64a2                	ld	s1,8(sp)
    800026e0:	6105                	addi	sp,sp,32
    800026e2:	8082                	ret
    panic("bwrite");
    800026e4:	00006517          	auipc	a0,0x6
    800026e8:	dd450513          	addi	a0,a0,-556 # 800084b8 <syscalls+0xf0>
    800026ec:	00004097          	auipc	ra,0x4
    800026f0:	b00080e7          	jalr	-1280(ra) # 800061ec <panic>

00000000800026f4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026f4:	1101                	addi	sp,sp,-32
    800026f6:	ec06                	sd	ra,24(sp)
    800026f8:	e822                	sd	s0,16(sp)
    800026fa:	e426                	sd	s1,8(sp)
    800026fc:	e04a                	sd	s2,0(sp)
    800026fe:	1000                	addi	s0,sp,32
    80002700:	892a                	mv	s2,a0
  if(!holdingsleep(&b->lock))
    80002702:	01050493          	addi	s1,a0,16
    80002706:	8526                	mv	a0,s1
    80002708:	00001097          	auipc	ra,0x1
    8000270c:	452080e7          	jalr	1106(ra) # 80003b5a <holdingsleep>
    80002710:	c52d                	beqz	a0,8000277a <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
    80002712:	8526                	mv	a0,s1
    80002714:	00001097          	auipc	ra,0x1
    80002718:	402080e7          	jalr	1026(ra) # 80003b16 <releasesleep>
int hash(uint dev, uint blockno) {return ((blockno) % NBUCKET);} // Hash function
    8000271c:	00c92483          	lw	s1,12(s2)
    80002720:	47b5                	li	a5,13
    80002722:	02f4f4bb          	remuw	s1,s1,a5

  uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    80002726:	1482                	slli	s1,s1,0x20
    80002728:	9081                	srli	s1,s1,0x20
    8000272a:	0496                	slli	s1,s1,0x5
    8000272c:	67b1                	lui	a5,0xc
    8000272e:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    80002732:	94be                	add	s1,s1,a5
    80002734:	0000d797          	auipc	a5,0xd
    80002738:	a9c78793          	addi	a5,a5,-1380 # 8000f1d0 <bcache>
    8000273c:	94be                	add	s1,s1,a5
    8000273e:	8526                	mv	a0,s1
    80002740:	00004097          	auipc	ra,0x4
    80002744:	fe0080e7          	jalr	-32(ra) # 80006720 <acquire>
    b->refcnt--;
    80002748:	04892783          	lw	a5,72(s2)
    8000274c:	37fd                	addiw	a5,a5,-1
    8000274e:	0007871b          	sext.w	a4,a5
    80002752:	04f92423          	sw	a5,72(s2)
    if (b->refcnt == 0) 
    80002756:	e719                	bnez	a4,80002764 <brelse+0x70>
        b->lut = ticks;
    80002758:	00007797          	auipc	a5,0x7
    8000275c:	8c07a783          	lw	a5,-1856(a5) # 80009018 <ticks>
    80002760:	46f92023          	sw	a5,1120(s2)
    release(&bcache.bucket_locks[index]);
    80002764:	8526                	mv	a0,s1
    80002766:	00004097          	auipc	ra,0x4
    8000276a:	08a080e7          	jalr	138(ra) # 800067f0 <release>
}
    8000276e:	60e2                	ld	ra,24(sp)
    80002770:	6442                	ld	s0,16(sp)
    80002772:	64a2                	ld	s1,8(sp)
    80002774:	6902                	ld	s2,0(sp)
    80002776:	6105                	addi	sp,sp,32
    80002778:	8082                	ret
    panic("brelse");
    8000277a:	00006517          	auipc	a0,0x6
    8000277e:	d4650513          	addi	a0,a0,-698 # 800084c0 <syscalls+0xf8>
    80002782:	00004097          	auipc	ra,0x4
    80002786:	a6a080e7          	jalr	-1430(ra) # 800061ec <panic>

000000008000278a <bpin>:

void bpin(struct buf *b)
{
    8000278a:	1101                	addi	sp,sp,-32
    8000278c:	ec06                	sd	ra,24(sp)
    8000278e:	e822                	sd	s0,16(sp)
    80002790:	e426                	sd	s1,8(sp)
    80002792:	e04a                	sd	s2,0(sp)
    80002794:	1000                	addi	s0,sp,32
    80002796:	892a                	mv	s2,a0
int hash(uint dev, uint blockno) {return ((blockno) % NBUCKET);} // Hash function
    80002798:	4544                	lw	s1,12(a0)
    8000279a:	47b5                	li	a5,13
    8000279c:	02f4f4bb          	remuw	s1,s1,a5

    uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    800027a0:	1482                	slli	s1,s1,0x20
    800027a2:	9081                	srli	s1,s1,0x20
    800027a4:	0496                	slli	s1,s1,0x5
    800027a6:	67b1                	lui	a5,0xc
    800027a8:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    800027ac:	94be                	add	s1,s1,a5
    800027ae:	0000d797          	auipc	a5,0xd
    800027b2:	a2278793          	addi	a5,a5,-1502 # 8000f1d0 <bcache>
    800027b6:	94be                	add	s1,s1,a5
    800027b8:	8526                	mv	a0,s1
    800027ba:	00004097          	auipc	ra,0x4
    800027be:	f66080e7          	jalr	-154(ra) # 80006720 <acquire>
    b->refcnt++;
    800027c2:	04892783          	lw	a5,72(s2)
    800027c6:	2785                	addiw	a5,a5,1
    800027c8:	04f92423          	sw	a5,72(s2)
    release(&bcache.bucket_locks[index]);
    800027cc:	8526                	mv	a0,s1
    800027ce:	00004097          	auipc	ra,0x4
    800027d2:	022080e7          	jalr	34(ra) # 800067f0 <release>
}
    800027d6:	60e2                	ld	ra,24(sp)
    800027d8:	6442                	ld	s0,16(sp)
    800027da:	64a2                	ld	s1,8(sp)
    800027dc:	6902                	ld	s2,0(sp)
    800027de:	6105                	addi	sp,sp,32
    800027e0:	8082                	ret

00000000800027e2 <bunpin>:

void bunpin(struct buf *b)
{
    800027e2:	1101                	addi	sp,sp,-32
    800027e4:	ec06                	sd	ra,24(sp)
    800027e6:	e822                	sd	s0,16(sp)
    800027e8:	e426                	sd	s1,8(sp)
    800027ea:	e04a                	sd	s2,0(sp)
    800027ec:	1000                	addi	s0,sp,32
    800027ee:	892a                	mv	s2,a0
int hash(uint dev, uint blockno) {return ((blockno) % NBUCKET);} // Hash function
    800027f0:	4544                	lw	s1,12(a0)
    800027f2:	47b5                	li	a5,13
    800027f4:	02f4f4bb          	remuw	s1,s1,a5

    uint index = hash(b->dev, b->blockno);
    acquire(&bcache.bucket_locks[index]);
    800027f8:	1482                	slli	s1,s1,0x20
    800027fa:	9081                	srli	s1,s1,0x20
    800027fc:	0496                	slli	s1,s1,0x5
    800027fe:	67b1                	lui	a5,0xc
    80002800:	d9878793          	addi	a5,a5,-616 # bd98 <_entry-0x7fff4268>
    80002804:	94be                	add	s1,s1,a5
    80002806:	0000d797          	auipc	a5,0xd
    8000280a:	9ca78793          	addi	a5,a5,-1590 # 8000f1d0 <bcache>
    8000280e:	94be                	add	s1,s1,a5
    80002810:	8526                	mv	a0,s1
    80002812:	00004097          	auipc	ra,0x4
    80002816:	f0e080e7          	jalr	-242(ra) # 80006720 <acquire>
    b->refcnt--;
    8000281a:	04892783          	lw	a5,72(s2)
    8000281e:	37fd                	addiw	a5,a5,-1
    80002820:	04f92423          	sw	a5,72(s2)
    release(&bcache.bucket_locks[index]);
    80002824:	8526                	mv	a0,s1
    80002826:	00004097          	auipc	ra,0x4
    8000282a:	fca080e7          	jalr	-54(ra) # 800067f0 <release>
}
    8000282e:	60e2                	ld	ra,24(sp)
    80002830:	6442                	ld	s0,16(sp)
    80002832:	64a2                	ld	s1,8(sp)
    80002834:	6902                	ld	s2,0(sp)
    80002836:	6105                	addi	sp,sp,32
    80002838:	8082                	ret

000000008000283a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000283a:	1101                	addi	sp,sp,-32
    8000283c:	ec06                	sd	ra,24(sp)
    8000283e:	e822                	sd	s0,16(sp)
    80002840:	e426                	sd	s1,8(sp)
    80002842:	e04a                	sd	s2,0(sp)
    80002844:	1000                	addi	s0,sp,32
    80002846:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002848:	00d5d59b          	srliw	a1,a1,0xd
    8000284c:	00019797          	auipc	a5,0x19
    80002850:	8d87a783          	lw	a5,-1832(a5) # 8001b124 <sb+0x1c>
    80002854:	9dbd                	addw	a1,a1,a5
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	b8a080e7          	jalr	-1142(ra) # 800023e0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000285e:	0074f713          	andi	a4,s1,7
    80002862:	4785                	li	a5,1
    80002864:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002868:	14ce                	slli	s1,s1,0x33
    8000286a:	90d9                	srli	s1,s1,0x36
    8000286c:	00950733          	add	a4,a0,s1
    80002870:	06074703          	lbu	a4,96(a4)
    80002874:	00e7f6b3          	and	a3,a5,a4
    80002878:	c69d                	beqz	a3,800028a6 <bfree+0x6c>
    8000287a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000287c:	94aa                	add	s1,s1,a0
    8000287e:	fff7c793          	not	a5,a5
    80002882:	8ff9                	and	a5,a5,a4
    80002884:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80002888:	00001097          	auipc	ra,0x1
    8000288c:	118080e7          	jalr	280(ra) # 800039a0 <log_write>
  brelse(bp);
    80002890:	854a                	mv	a0,s2
    80002892:	00000097          	auipc	ra,0x0
    80002896:	e62080e7          	jalr	-414(ra) # 800026f4 <brelse>
}
    8000289a:	60e2                	ld	ra,24(sp)
    8000289c:	6442                	ld	s0,16(sp)
    8000289e:	64a2                	ld	s1,8(sp)
    800028a0:	6902                	ld	s2,0(sp)
    800028a2:	6105                	addi	sp,sp,32
    800028a4:	8082                	ret
    panic("freeing free block");
    800028a6:	00006517          	auipc	a0,0x6
    800028aa:	c2250513          	addi	a0,a0,-990 # 800084c8 <syscalls+0x100>
    800028ae:	00004097          	auipc	ra,0x4
    800028b2:	93e080e7          	jalr	-1730(ra) # 800061ec <panic>

00000000800028b6 <balloc>:
{
    800028b6:	711d                	addi	sp,sp,-96
    800028b8:	ec86                	sd	ra,88(sp)
    800028ba:	e8a2                	sd	s0,80(sp)
    800028bc:	e4a6                	sd	s1,72(sp)
    800028be:	e0ca                	sd	s2,64(sp)
    800028c0:	fc4e                	sd	s3,56(sp)
    800028c2:	f852                	sd	s4,48(sp)
    800028c4:	f456                	sd	s5,40(sp)
    800028c6:	f05a                	sd	s6,32(sp)
    800028c8:	ec5e                	sd	s7,24(sp)
    800028ca:	e862                	sd	s8,16(sp)
    800028cc:	e466                	sd	s9,8(sp)
    800028ce:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028d0:	00019797          	auipc	a5,0x19
    800028d4:	83c7a783          	lw	a5,-1988(a5) # 8001b10c <sb+0x4>
    800028d8:	cbd1                	beqz	a5,8000296c <balloc+0xb6>
    800028da:	8baa                	mv	s7,a0
    800028dc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028de:	00019b17          	auipc	s6,0x19
    800028e2:	82ab0b13          	addi	s6,s6,-2006 # 8001b108 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028e8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ea:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028ec:	6c89                	lui	s9,0x2
    800028ee:	a831                	j	8000290a <balloc+0x54>
    brelse(bp);
    800028f0:	854a                	mv	a0,s2
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	e02080e7          	jalr	-510(ra) # 800026f4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028fa:	015c87bb          	addw	a5,s9,s5
    800028fe:	00078a9b          	sext.w	s5,a5
    80002902:	004b2703          	lw	a4,4(s6)
    80002906:	06eaf363          	bgeu	s5,a4,8000296c <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000290a:	41fad79b          	sraiw	a5,s5,0x1f
    8000290e:	0137d79b          	srliw	a5,a5,0x13
    80002912:	015787bb          	addw	a5,a5,s5
    80002916:	40d7d79b          	sraiw	a5,a5,0xd
    8000291a:	01cb2583          	lw	a1,28(s6)
    8000291e:	9dbd                	addw	a1,a1,a5
    80002920:	855e                	mv	a0,s7
    80002922:	00000097          	auipc	ra,0x0
    80002926:	abe080e7          	jalr	-1346(ra) # 800023e0 <bread>
    8000292a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000292c:	004b2503          	lw	a0,4(s6)
    80002930:	000a849b          	sext.w	s1,s5
    80002934:	8662                	mv	a2,s8
    80002936:	faa4fde3          	bgeu	s1,a0,800028f0 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000293a:	41f6579b          	sraiw	a5,a2,0x1f
    8000293e:	01d7d69b          	srliw	a3,a5,0x1d
    80002942:	00c6873b          	addw	a4,a3,a2
    80002946:	00777793          	andi	a5,a4,7
    8000294a:	9f95                	subw	a5,a5,a3
    8000294c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002950:	4037571b          	sraiw	a4,a4,0x3
    80002954:	00e906b3          	add	a3,s2,a4
    80002958:	0606c683          	lbu	a3,96(a3)
    8000295c:	00d7f5b3          	and	a1,a5,a3
    80002960:	cd91                	beqz	a1,8000297c <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002962:	2605                	addiw	a2,a2,1
    80002964:	2485                	addiw	s1,s1,1
    80002966:	fd4618e3          	bne	a2,s4,80002936 <balloc+0x80>
    8000296a:	b759                	j	800028f0 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000296c:	00006517          	auipc	a0,0x6
    80002970:	b7450513          	addi	a0,a0,-1164 # 800084e0 <syscalls+0x118>
    80002974:	00004097          	auipc	ra,0x4
    80002978:	878080e7          	jalr	-1928(ra) # 800061ec <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000297c:	974a                	add	a4,a4,s2
    8000297e:	8fd5                	or	a5,a5,a3
    80002980:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80002984:	854a                	mv	a0,s2
    80002986:	00001097          	auipc	ra,0x1
    8000298a:	01a080e7          	jalr	26(ra) # 800039a0 <log_write>
        brelse(bp);
    8000298e:	854a                	mv	a0,s2
    80002990:	00000097          	auipc	ra,0x0
    80002994:	d64080e7          	jalr	-668(ra) # 800026f4 <brelse>
  bp = bread(dev, bno);
    80002998:	85a6                	mv	a1,s1
    8000299a:	855e                	mv	a0,s7
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	a44080e7          	jalr	-1468(ra) # 800023e0 <bread>
    800029a4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800029a6:	40000613          	li	a2,1024
    800029aa:	4581                	li	a1,0
    800029ac:	06050513          	addi	a0,a0,96
    800029b0:	ffffe097          	auipc	ra,0xffffe
    800029b4:	8d6080e7          	jalr	-1834(ra) # 80000286 <memset>
  log_write(bp);
    800029b8:	854a                	mv	a0,s2
    800029ba:	00001097          	auipc	ra,0x1
    800029be:	fe6080e7          	jalr	-26(ra) # 800039a0 <log_write>
  brelse(bp);
    800029c2:	854a                	mv	a0,s2
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	d30080e7          	jalr	-720(ra) # 800026f4 <brelse>
}
    800029cc:	8526                	mv	a0,s1
    800029ce:	60e6                	ld	ra,88(sp)
    800029d0:	6446                	ld	s0,80(sp)
    800029d2:	64a6                	ld	s1,72(sp)
    800029d4:	6906                	ld	s2,64(sp)
    800029d6:	79e2                	ld	s3,56(sp)
    800029d8:	7a42                	ld	s4,48(sp)
    800029da:	7aa2                	ld	s5,40(sp)
    800029dc:	7b02                	ld	s6,32(sp)
    800029de:	6be2                	ld	s7,24(sp)
    800029e0:	6c42                	ld	s8,16(sp)
    800029e2:	6ca2                	ld	s9,8(sp)
    800029e4:	6125                	addi	sp,sp,96
    800029e6:	8082                	ret

00000000800029e8 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800029e8:	7179                	addi	sp,sp,-48
    800029ea:	f406                	sd	ra,40(sp)
    800029ec:	f022                	sd	s0,32(sp)
    800029ee:	ec26                	sd	s1,24(sp)
    800029f0:	e84a                	sd	s2,16(sp)
    800029f2:	e44e                	sd	s3,8(sp)
    800029f4:	e052                	sd	s4,0(sp)
    800029f6:	1800                	addi	s0,sp,48
    800029f8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029fa:	47ad                	li	a5,11
    800029fc:	04b7fe63          	bgeu	a5,a1,80002a58 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a00:	ff45849b          	addiw	s1,a1,-12
    80002a04:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a08:	0ff00793          	li	a5,255
    80002a0c:	0ae7e363          	bltu	a5,a4,80002ab2 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a10:	08852583          	lw	a1,136(a0)
    80002a14:	c5ad                	beqz	a1,80002a7e <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a16:	00092503          	lw	a0,0(s2)
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	9c6080e7          	jalr	-1594(ra) # 800023e0 <bread>
    80002a22:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a24:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002a28:	02049593          	slli	a1,s1,0x20
    80002a2c:	9181                	srli	a1,a1,0x20
    80002a2e:	058a                	slli	a1,a1,0x2
    80002a30:	00b784b3          	add	s1,a5,a1
    80002a34:	0004a983          	lw	s3,0(s1)
    80002a38:	04098d63          	beqz	s3,80002a92 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a3c:	8552                	mv	a0,s4
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	cb6080e7          	jalr	-842(ra) # 800026f4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a46:	854e                	mv	a0,s3
    80002a48:	70a2                	ld	ra,40(sp)
    80002a4a:	7402                	ld	s0,32(sp)
    80002a4c:	64e2                	ld	s1,24(sp)
    80002a4e:	6942                	ld	s2,16(sp)
    80002a50:	69a2                	ld	s3,8(sp)
    80002a52:	6a02                	ld	s4,0(sp)
    80002a54:	6145                	addi	sp,sp,48
    80002a56:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a58:	02059493          	slli	s1,a1,0x20
    80002a5c:	9081                	srli	s1,s1,0x20
    80002a5e:	048a                	slli	s1,s1,0x2
    80002a60:	94aa                	add	s1,s1,a0
    80002a62:	0584a983          	lw	s3,88(s1)
    80002a66:	fe0990e3          	bnez	s3,80002a46 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a6a:	4108                	lw	a0,0(a0)
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	e4a080e7          	jalr	-438(ra) # 800028b6 <balloc>
    80002a74:	0005099b          	sext.w	s3,a0
    80002a78:	0534ac23          	sw	s3,88(s1)
    80002a7c:	b7e9                	j	80002a46 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a7e:	4108                	lw	a0,0(a0)
    80002a80:	00000097          	auipc	ra,0x0
    80002a84:	e36080e7          	jalr	-458(ra) # 800028b6 <balloc>
    80002a88:	0005059b          	sext.w	a1,a0
    80002a8c:	08b92423          	sw	a1,136(s2)
    80002a90:	b759                	j	80002a16 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a92:	00092503          	lw	a0,0(s2)
    80002a96:	00000097          	auipc	ra,0x0
    80002a9a:	e20080e7          	jalr	-480(ra) # 800028b6 <balloc>
    80002a9e:	0005099b          	sext.w	s3,a0
    80002aa2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002aa6:	8552                	mv	a0,s4
    80002aa8:	00001097          	auipc	ra,0x1
    80002aac:	ef8080e7          	jalr	-264(ra) # 800039a0 <log_write>
    80002ab0:	b771                	j	80002a3c <bmap+0x54>
  panic("bmap: out of range");
    80002ab2:	00006517          	auipc	a0,0x6
    80002ab6:	a4650513          	addi	a0,a0,-1466 # 800084f8 <syscalls+0x130>
    80002aba:	00003097          	auipc	ra,0x3
    80002abe:	732080e7          	jalr	1842(ra) # 800061ec <panic>

0000000080002ac2 <iget>:
{
    80002ac2:	7179                	addi	sp,sp,-48
    80002ac4:	f406                	sd	ra,40(sp)
    80002ac6:	f022                	sd	s0,32(sp)
    80002ac8:	ec26                	sd	s1,24(sp)
    80002aca:	e84a                	sd	s2,16(sp)
    80002acc:	e44e                	sd	s3,8(sp)
    80002ace:	e052                	sd	s4,0(sp)
    80002ad0:	1800                	addi	s0,sp,48
    80002ad2:	89aa                	mv	s3,a0
    80002ad4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002ad6:	00018517          	auipc	a0,0x18
    80002ada:	65250513          	addi	a0,a0,1618 # 8001b128 <itable>
    80002ade:	00004097          	auipc	ra,0x4
    80002ae2:	c42080e7          	jalr	-958(ra) # 80006720 <acquire>
  empty = 0;
    80002ae6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ae8:	00018497          	auipc	s1,0x18
    80002aec:	66048493          	addi	s1,s1,1632 # 8001b148 <itable+0x20>
    80002af0:	0001a697          	auipc	a3,0x1a
    80002af4:	27868693          	addi	a3,a3,632 # 8001cd68 <log>
    80002af8:	a039                	j	80002b06 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002afa:	02090b63          	beqz	s2,80002b30 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002afe:	09048493          	addi	s1,s1,144
    80002b02:	02d48a63          	beq	s1,a3,80002b36 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b06:	449c                	lw	a5,8(s1)
    80002b08:	fef059e3          	blez	a5,80002afa <iget+0x38>
    80002b0c:	4098                	lw	a4,0(s1)
    80002b0e:	ff3716e3          	bne	a4,s3,80002afa <iget+0x38>
    80002b12:	40d8                	lw	a4,4(s1)
    80002b14:	ff4713e3          	bne	a4,s4,80002afa <iget+0x38>
      ip->ref++;
    80002b18:	2785                	addiw	a5,a5,1
    80002b1a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b1c:	00018517          	auipc	a0,0x18
    80002b20:	60c50513          	addi	a0,a0,1548 # 8001b128 <itable>
    80002b24:	00004097          	auipc	ra,0x4
    80002b28:	ccc080e7          	jalr	-820(ra) # 800067f0 <release>
      return ip;
    80002b2c:	8926                	mv	s2,s1
    80002b2e:	a03d                	j	80002b5c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b30:	f7f9                	bnez	a5,80002afe <iget+0x3c>
    80002b32:	8926                	mv	s2,s1
    80002b34:	b7e9                	j	80002afe <iget+0x3c>
  if(empty == 0)
    80002b36:	02090c63          	beqz	s2,80002b6e <iget+0xac>
  ip->dev = dev;
    80002b3a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b3e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b42:	4785                	li	a5,1
    80002b44:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b48:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002b4c:	00018517          	auipc	a0,0x18
    80002b50:	5dc50513          	addi	a0,a0,1500 # 8001b128 <itable>
    80002b54:	00004097          	auipc	ra,0x4
    80002b58:	c9c080e7          	jalr	-868(ra) # 800067f0 <release>
}
    80002b5c:	854a                	mv	a0,s2
    80002b5e:	70a2                	ld	ra,40(sp)
    80002b60:	7402                	ld	s0,32(sp)
    80002b62:	64e2                	ld	s1,24(sp)
    80002b64:	6942                	ld	s2,16(sp)
    80002b66:	69a2                	ld	s3,8(sp)
    80002b68:	6a02                	ld	s4,0(sp)
    80002b6a:	6145                	addi	sp,sp,48
    80002b6c:	8082                	ret
    panic("iget: no inodes");
    80002b6e:	00006517          	auipc	a0,0x6
    80002b72:	9a250513          	addi	a0,a0,-1630 # 80008510 <syscalls+0x148>
    80002b76:	00003097          	auipc	ra,0x3
    80002b7a:	676080e7          	jalr	1654(ra) # 800061ec <panic>

0000000080002b7e <fsinit>:
fsinit(int dev) {
    80002b7e:	7179                	addi	sp,sp,-48
    80002b80:	f406                	sd	ra,40(sp)
    80002b82:	f022                	sd	s0,32(sp)
    80002b84:	ec26                	sd	s1,24(sp)
    80002b86:	e84a                	sd	s2,16(sp)
    80002b88:	e44e                	sd	s3,8(sp)
    80002b8a:	1800                	addi	s0,sp,48
    80002b8c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b8e:	4585                	li	a1,1
    80002b90:	00000097          	auipc	ra,0x0
    80002b94:	850080e7          	jalr	-1968(ra) # 800023e0 <bread>
    80002b98:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b9a:	00018997          	auipc	s3,0x18
    80002b9e:	56e98993          	addi	s3,s3,1390 # 8001b108 <sb>
    80002ba2:	02000613          	li	a2,32
    80002ba6:	06050593          	addi	a1,a0,96
    80002baa:	854e                	mv	a0,s3
    80002bac:	ffffd097          	auipc	ra,0xffffd
    80002bb0:	73a080e7          	jalr	1850(ra) # 800002e6 <memmove>
  brelse(bp);
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	00000097          	auipc	ra,0x0
    80002bba:	b3e080e7          	jalr	-1218(ra) # 800026f4 <brelse>
  if(sb.magic != FSMAGIC)
    80002bbe:	0009a703          	lw	a4,0(s3)
    80002bc2:	102037b7          	lui	a5,0x10203
    80002bc6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002bca:	02f71263          	bne	a4,a5,80002bee <fsinit+0x70>
  initlog(dev, &sb);
    80002bce:	00018597          	auipc	a1,0x18
    80002bd2:	53a58593          	addi	a1,a1,1338 # 8001b108 <sb>
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	b4c080e7          	jalr	-1204(ra) # 80003724 <initlog>
}
    80002be0:	70a2                	ld	ra,40(sp)
    80002be2:	7402                	ld	s0,32(sp)
    80002be4:	64e2                	ld	s1,24(sp)
    80002be6:	6942                	ld	s2,16(sp)
    80002be8:	69a2                	ld	s3,8(sp)
    80002bea:	6145                	addi	sp,sp,48
    80002bec:	8082                	ret
    panic("invalid file system");
    80002bee:	00006517          	auipc	a0,0x6
    80002bf2:	93250513          	addi	a0,a0,-1742 # 80008520 <syscalls+0x158>
    80002bf6:	00003097          	auipc	ra,0x3
    80002bfa:	5f6080e7          	jalr	1526(ra) # 800061ec <panic>

0000000080002bfe <iinit>:
{
    80002bfe:	7179                	addi	sp,sp,-48
    80002c00:	f406                	sd	ra,40(sp)
    80002c02:	f022                	sd	s0,32(sp)
    80002c04:	ec26                	sd	s1,24(sp)
    80002c06:	e84a                	sd	s2,16(sp)
    80002c08:	e44e                	sd	s3,8(sp)
    80002c0a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c0c:	00006597          	auipc	a1,0x6
    80002c10:	92c58593          	addi	a1,a1,-1748 # 80008538 <syscalls+0x170>
    80002c14:	00018517          	auipc	a0,0x18
    80002c18:	51450513          	addi	a0,a0,1300 # 8001b128 <itable>
    80002c1c:	00004097          	auipc	ra,0x4
    80002c20:	c80080e7          	jalr	-896(ra) # 8000689c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c24:	00018497          	auipc	s1,0x18
    80002c28:	53448493          	addi	s1,s1,1332 # 8001b158 <itable+0x30>
    80002c2c:	0001a997          	auipc	s3,0x1a
    80002c30:	14c98993          	addi	s3,s3,332 # 8001cd78 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c34:	00006917          	auipc	s2,0x6
    80002c38:	90c90913          	addi	s2,s2,-1780 # 80008540 <syscalls+0x178>
    80002c3c:	85ca                	mv	a1,s2
    80002c3e:	8526                	mv	a0,s1
    80002c40:	00001097          	auipc	ra,0x1
    80002c44:	e46080e7          	jalr	-442(ra) # 80003a86 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c48:	09048493          	addi	s1,s1,144
    80002c4c:	ff3498e3          	bne	s1,s3,80002c3c <iinit+0x3e>
}
    80002c50:	70a2                	ld	ra,40(sp)
    80002c52:	7402                	ld	s0,32(sp)
    80002c54:	64e2                	ld	s1,24(sp)
    80002c56:	6942                	ld	s2,16(sp)
    80002c58:	69a2                	ld	s3,8(sp)
    80002c5a:	6145                	addi	sp,sp,48
    80002c5c:	8082                	ret

0000000080002c5e <ialloc>:
{
    80002c5e:	715d                	addi	sp,sp,-80
    80002c60:	e486                	sd	ra,72(sp)
    80002c62:	e0a2                	sd	s0,64(sp)
    80002c64:	fc26                	sd	s1,56(sp)
    80002c66:	f84a                	sd	s2,48(sp)
    80002c68:	f44e                	sd	s3,40(sp)
    80002c6a:	f052                	sd	s4,32(sp)
    80002c6c:	ec56                	sd	s5,24(sp)
    80002c6e:	e85a                	sd	s6,16(sp)
    80002c70:	e45e                	sd	s7,8(sp)
    80002c72:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c74:	00018717          	auipc	a4,0x18
    80002c78:	4a072703          	lw	a4,1184(a4) # 8001b114 <sb+0xc>
    80002c7c:	4785                	li	a5,1
    80002c7e:	04e7fa63          	bgeu	a5,a4,80002cd2 <ialloc+0x74>
    80002c82:	8aaa                	mv	s5,a0
    80002c84:	8bae                	mv	s7,a1
    80002c86:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c88:	00018a17          	auipc	s4,0x18
    80002c8c:	480a0a13          	addi	s4,s4,1152 # 8001b108 <sb>
    80002c90:	00048b1b          	sext.w	s6,s1
    80002c94:	0044d593          	srli	a1,s1,0x4
    80002c98:	018a2783          	lw	a5,24(s4)
    80002c9c:	9dbd                	addw	a1,a1,a5
    80002c9e:	8556                	mv	a0,s5
    80002ca0:	fffff097          	auipc	ra,0xfffff
    80002ca4:	740080e7          	jalr	1856(ra) # 800023e0 <bread>
    80002ca8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002caa:	06050993          	addi	s3,a0,96
    80002cae:	00f4f793          	andi	a5,s1,15
    80002cb2:	079a                	slli	a5,a5,0x6
    80002cb4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cb6:	00099783          	lh	a5,0(s3)
    80002cba:	c785                	beqz	a5,80002ce2 <ialloc+0x84>
    brelse(bp);
    80002cbc:	00000097          	auipc	ra,0x0
    80002cc0:	a38080e7          	jalr	-1480(ra) # 800026f4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cc4:	0485                	addi	s1,s1,1
    80002cc6:	00ca2703          	lw	a4,12(s4)
    80002cca:	0004879b          	sext.w	a5,s1
    80002cce:	fce7e1e3          	bltu	a5,a4,80002c90 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002cd2:	00006517          	auipc	a0,0x6
    80002cd6:	87650513          	addi	a0,a0,-1930 # 80008548 <syscalls+0x180>
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	512080e7          	jalr	1298(ra) # 800061ec <panic>
      memset(dip, 0, sizeof(*dip));
    80002ce2:	04000613          	li	a2,64
    80002ce6:	4581                	li	a1,0
    80002ce8:	854e                	mv	a0,s3
    80002cea:	ffffd097          	auipc	ra,0xffffd
    80002cee:	59c080e7          	jalr	1436(ra) # 80000286 <memset>
      dip->type = type;
    80002cf2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cf6:	854a                	mv	a0,s2
    80002cf8:	00001097          	auipc	ra,0x1
    80002cfc:	ca8080e7          	jalr	-856(ra) # 800039a0 <log_write>
      brelse(bp);
    80002d00:	854a                	mv	a0,s2
    80002d02:	00000097          	auipc	ra,0x0
    80002d06:	9f2080e7          	jalr	-1550(ra) # 800026f4 <brelse>
      return iget(dev, inum);
    80002d0a:	85da                	mv	a1,s6
    80002d0c:	8556                	mv	a0,s5
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	db4080e7          	jalr	-588(ra) # 80002ac2 <iget>
}
    80002d16:	60a6                	ld	ra,72(sp)
    80002d18:	6406                	ld	s0,64(sp)
    80002d1a:	74e2                	ld	s1,56(sp)
    80002d1c:	7942                	ld	s2,48(sp)
    80002d1e:	79a2                	ld	s3,40(sp)
    80002d20:	7a02                	ld	s4,32(sp)
    80002d22:	6ae2                	ld	s5,24(sp)
    80002d24:	6b42                	ld	s6,16(sp)
    80002d26:	6ba2                	ld	s7,8(sp)
    80002d28:	6161                	addi	sp,sp,80
    80002d2a:	8082                	ret

0000000080002d2c <iupdate>:
{
    80002d2c:	1101                	addi	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	e04a                	sd	s2,0(sp)
    80002d36:	1000                	addi	s0,sp,32
    80002d38:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d3a:	415c                	lw	a5,4(a0)
    80002d3c:	0047d79b          	srliw	a5,a5,0x4
    80002d40:	00018597          	auipc	a1,0x18
    80002d44:	3e05a583          	lw	a1,992(a1) # 8001b120 <sb+0x18>
    80002d48:	9dbd                	addw	a1,a1,a5
    80002d4a:	4108                	lw	a0,0(a0)
    80002d4c:	fffff097          	auipc	ra,0xfffff
    80002d50:	694080e7          	jalr	1684(ra) # 800023e0 <bread>
    80002d54:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d56:	06050793          	addi	a5,a0,96
    80002d5a:	40c8                	lw	a0,4(s1)
    80002d5c:	893d                	andi	a0,a0,15
    80002d5e:	051a                	slli	a0,a0,0x6
    80002d60:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d62:	04c49703          	lh	a4,76(s1)
    80002d66:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d6a:	04e49703          	lh	a4,78(s1)
    80002d6e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d72:	05049703          	lh	a4,80(s1)
    80002d76:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d7a:	05249703          	lh	a4,82(s1)
    80002d7e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d82:	48f8                	lw	a4,84(s1)
    80002d84:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d86:	03400613          	li	a2,52
    80002d8a:	05848593          	addi	a1,s1,88
    80002d8e:	0531                	addi	a0,a0,12
    80002d90:	ffffd097          	auipc	ra,0xffffd
    80002d94:	556080e7          	jalr	1366(ra) # 800002e6 <memmove>
  log_write(bp);
    80002d98:	854a                	mv	a0,s2
    80002d9a:	00001097          	auipc	ra,0x1
    80002d9e:	c06080e7          	jalr	-1018(ra) # 800039a0 <log_write>
  brelse(bp);
    80002da2:	854a                	mv	a0,s2
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	950080e7          	jalr	-1712(ra) # 800026f4 <brelse>
}
    80002dac:	60e2                	ld	ra,24(sp)
    80002dae:	6442                	ld	s0,16(sp)
    80002db0:	64a2                	ld	s1,8(sp)
    80002db2:	6902                	ld	s2,0(sp)
    80002db4:	6105                	addi	sp,sp,32
    80002db6:	8082                	ret

0000000080002db8 <idup>:
{
    80002db8:	1101                	addi	sp,sp,-32
    80002dba:	ec06                	sd	ra,24(sp)
    80002dbc:	e822                	sd	s0,16(sp)
    80002dbe:	e426                	sd	s1,8(sp)
    80002dc0:	1000                	addi	s0,sp,32
    80002dc2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dc4:	00018517          	auipc	a0,0x18
    80002dc8:	36450513          	addi	a0,a0,868 # 8001b128 <itable>
    80002dcc:	00004097          	auipc	ra,0x4
    80002dd0:	954080e7          	jalr	-1708(ra) # 80006720 <acquire>
  ip->ref++;
    80002dd4:	449c                	lw	a5,8(s1)
    80002dd6:	2785                	addiw	a5,a5,1
    80002dd8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dda:	00018517          	auipc	a0,0x18
    80002dde:	34e50513          	addi	a0,a0,846 # 8001b128 <itable>
    80002de2:	00004097          	auipc	ra,0x4
    80002de6:	a0e080e7          	jalr	-1522(ra) # 800067f0 <release>
}
    80002dea:	8526                	mv	a0,s1
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	64a2                	ld	s1,8(sp)
    80002df2:	6105                	addi	sp,sp,32
    80002df4:	8082                	ret

0000000080002df6 <ilock>:
{
    80002df6:	1101                	addi	sp,sp,-32
    80002df8:	ec06                	sd	ra,24(sp)
    80002dfa:	e822                	sd	s0,16(sp)
    80002dfc:	e426                	sd	s1,8(sp)
    80002dfe:	e04a                	sd	s2,0(sp)
    80002e00:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e02:	c115                	beqz	a0,80002e26 <ilock+0x30>
    80002e04:	84aa                	mv	s1,a0
    80002e06:	451c                	lw	a5,8(a0)
    80002e08:	00f05f63          	blez	a5,80002e26 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e0c:	0541                	addi	a0,a0,16
    80002e0e:	00001097          	auipc	ra,0x1
    80002e12:	cb2080e7          	jalr	-846(ra) # 80003ac0 <acquiresleep>
  if(ip->valid == 0){
    80002e16:	44bc                	lw	a5,72(s1)
    80002e18:	cf99                	beqz	a5,80002e36 <ilock+0x40>
}
    80002e1a:	60e2                	ld	ra,24(sp)
    80002e1c:	6442                	ld	s0,16(sp)
    80002e1e:	64a2                	ld	s1,8(sp)
    80002e20:	6902                	ld	s2,0(sp)
    80002e22:	6105                	addi	sp,sp,32
    80002e24:	8082                	ret
    panic("ilock");
    80002e26:	00005517          	auipc	a0,0x5
    80002e2a:	73a50513          	addi	a0,a0,1850 # 80008560 <syscalls+0x198>
    80002e2e:	00003097          	auipc	ra,0x3
    80002e32:	3be080e7          	jalr	958(ra) # 800061ec <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e36:	40dc                	lw	a5,4(s1)
    80002e38:	0047d79b          	srliw	a5,a5,0x4
    80002e3c:	00018597          	auipc	a1,0x18
    80002e40:	2e45a583          	lw	a1,740(a1) # 8001b120 <sb+0x18>
    80002e44:	9dbd                	addw	a1,a1,a5
    80002e46:	4088                	lw	a0,0(s1)
    80002e48:	fffff097          	auipc	ra,0xfffff
    80002e4c:	598080e7          	jalr	1432(ra) # 800023e0 <bread>
    80002e50:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e52:	06050593          	addi	a1,a0,96
    80002e56:	40dc                	lw	a5,4(s1)
    80002e58:	8bbd                	andi	a5,a5,15
    80002e5a:	079a                	slli	a5,a5,0x6
    80002e5c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e5e:	00059783          	lh	a5,0(a1)
    80002e62:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002e66:	00259783          	lh	a5,2(a1)
    80002e6a:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002e6e:	00459783          	lh	a5,4(a1)
    80002e72:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002e76:	00659783          	lh	a5,6(a1)
    80002e7a:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002e7e:	459c                	lw	a5,8(a1)
    80002e80:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e82:	03400613          	li	a2,52
    80002e86:	05b1                	addi	a1,a1,12
    80002e88:	05848513          	addi	a0,s1,88
    80002e8c:	ffffd097          	auipc	ra,0xffffd
    80002e90:	45a080e7          	jalr	1114(ra) # 800002e6 <memmove>
    brelse(bp);
    80002e94:	854a                	mv	a0,s2
    80002e96:	00000097          	auipc	ra,0x0
    80002e9a:	85e080e7          	jalr	-1954(ra) # 800026f4 <brelse>
    ip->valid = 1;
    80002e9e:	4785                	li	a5,1
    80002ea0:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002ea2:	04c49783          	lh	a5,76(s1)
    80002ea6:	fbb5                	bnez	a5,80002e1a <ilock+0x24>
      panic("ilock: no type");
    80002ea8:	00005517          	auipc	a0,0x5
    80002eac:	6c050513          	addi	a0,a0,1728 # 80008568 <syscalls+0x1a0>
    80002eb0:	00003097          	auipc	ra,0x3
    80002eb4:	33c080e7          	jalr	828(ra) # 800061ec <panic>

0000000080002eb8 <iunlock>:
{
    80002eb8:	1101                	addi	sp,sp,-32
    80002eba:	ec06                	sd	ra,24(sp)
    80002ebc:	e822                	sd	s0,16(sp)
    80002ebe:	e426                	sd	s1,8(sp)
    80002ec0:	e04a                	sd	s2,0(sp)
    80002ec2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ec4:	c905                	beqz	a0,80002ef4 <iunlock+0x3c>
    80002ec6:	84aa                	mv	s1,a0
    80002ec8:	01050913          	addi	s2,a0,16
    80002ecc:	854a                	mv	a0,s2
    80002ece:	00001097          	auipc	ra,0x1
    80002ed2:	c8c080e7          	jalr	-884(ra) # 80003b5a <holdingsleep>
    80002ed6:	cd19                	beqz	a0,80002ef4 <iunlock+0x3c>
    80002ed8:	449c                	lw	a5,8(s1)
    80002eda:	00f05d63          	blez	a5,80002ef4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ede:	854a                	mv	a0,s2
    80002ee0:	00001097          	auipc	ra,0x1
    80002ee4:	c36080e7          	jalr	-970(ra) # 80003b16 <releasesleep>
}
    80002ee8:	60e2                	ld	ra,24(sp)
    80002eea:	6442                	ld	s0,16(sp)
    80002eec:	64a2                	ld	s1,8(sp)
    80002eee:	6902                	ld	s2,0(sp)
    80002ef0:	6105                	addi	sp,sp,32
    80002ef2:	8082                	ret
    panic("iunlock");
    80002ef4:	00005517          	auipc	a0,0x5
    80002ef8:	68450513          	addi	a0,a0,1668 # 80008578 <syscalls+0x1b0>
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	2f0080e7          	jalr	752(ra) # 800061ec <panic>

0000000080002f04 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f04:	7179                	addi	sp,sp,-48
    80002f06:	f406                	sd	ra,40(sp)
    80002f08:	f022                	sd	s0,32(sp)
    80002f0a:	ec26                	sd	s1,24(sp)
    80002f0c:	e84a                	sd	s2,16(sp)
    80002f0e:	e44e                	sd	s3,8(sp)
    80002f10:	e052                	sd	s4,0(sp)
    80002f12:	1800                	addi	s0,sp,48
    80002f14:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f16:	05850493          	addi	s1,a0,88
    80002f1a:	08850913          	addi	s2,a0,136
    80002f1e:	a021                	j	80002f26 <itrunc+0x22>
    80002f20:	0491                	addi	s1,s1,4
    80002f22:	01248d63          	beq	s1,s2,80002f3c <itrunc+0x38>
    if(ip->addrs[i]){
    80002f26:	408c                	lw	a1,0(s1)
    80002f28:	dde5                	beqz	a1,80002f20 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f2a:	0009a503          	lw	a0,0(s3)
    80002f2e:	00000097          	auipc	ra,0x0
    80002f32:	90c080e7          	jalr	-1780(ra) # 8000283a <bfree>
      ip->addrs[i] = 0;
    80002f36:	0004a023          	sw	zero,0(s1)
    80002f3a:	b7dd                	j	80002f20 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f3c:	0889a583          	lw	a1,136(s3)
    80002f40:	e185                	bnez	a1,80002f60 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f42:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002f46:	854e                	mv	a0,s3
    80002f48:	00000097          	auipc	ra,0x0
    80002f4c:	de4080e7          	jalr	-540(ra) # 80002d2c <iupdate>
}
    80002f50:	70a2                	ld	ra,40(sp)
    80002f52:	7402                	ld	s0,32(sp)
    80002f54:	64e2                	ld	s1,24(sp)
    80002f56:	6942                	ld	s2,16(sp)
    80002f58:	69a2                	ld	s3,8(sp)
    80002f5a:	6a02                	ld	s4,0(sp)
    80002f5c:	6145                	addi	sp,sp,48
    80002f5e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f60:	0009a503          	lw	a0,0(s3)
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	47c080e7          	jalr	1148(ra) # 800023e0 <bread>
    80002f6c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f6e:	06050493          	addi	s1,a0,96
    80002f72:	46050913          	addi	s2,a0,1120
    80002f76:	a811                	j	80002f8a <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f78:	0009a503          	lw	a0,0(s3)
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	8be080e7          	jalr	-1858(ra) # 8000283a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f84:	0491                	addi	s1,s1,4
    80002f86:	01248563          	beq	s1,s2,80002f90 <itrunc+0x8c>
      if(a[j])
    80002f8a:	408c                	lw	a1,0(s1)
    80002f8c:	dde5                	beqz	a1,80002f84 <itrunc+0x80>
    80002f8e:	b7ed                	j	80002f78 <itrunc+0x74>
    brelse(bp);
    80002f90:	8552                	mv	a0,s4
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	762080e7          	jalr	1890(ra) # 800026f4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f9a:	0889a583          	lw	a1,136(s3)
    80002f9e:	0009a503          	lw	a0,0(s3)
    80002fa2:	00000097          	auipc	ra,0x0
    80002fa6:	898080e7          	jalr	-1896(ra) # 8000283a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002faa:	0809a423          	sw	zero,136(s3)
    80002fae:	bf51                	j	80002f42 <itrunc+0x3e>

0000000080002fb0 <iput>:
{
    80002fb0:	1101                	addi	sp,sp,-32
    80002fb2:	ec06                	sd	ra,24(sp)
    80002fb4:	e822                	sd	s0,16(sp)
    80002fb6:	e426                	sd	s1,8(sp)
    80002fb8:	e04a                	sd	s2,0(sp)
    80002fba:	1000                	addi	s0,sp,32
    80002fbc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002fbe:	00018517          	auipc	a0,0x18
    80002fc2:	16a50513          	addi	a0,a0,362 # 8001b128 <itable>
    80002fc6:	00003097          	auipc	ra,0x3
    80002fca:	75a080e7          	jalr	1882(ra) # 80006720 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fce:	4498                	lw	a4,8(s1)
    80002fd0:	4785                	li	a5,1
    80002fd2:	02f70363          	beq	a4,a5,80002ff8 <iput+0x48>
  ip->ref--;
    80002fd6:	449c                	lw	a5,8(s1)
    80002fd8:	37fd                	addiw	a5,a5,-1
    80002fda:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fdc:	00018517          	auipc	a0,0x18
    80002fe0:	14c50513          	addi	a0,a0,332 # 8001b128 <itable>
    80002fe4:	00004097          	auipc	ra,0x4
    80002fe8:	80c080e7          	jalr	-2036(ra) # 800067f0 <release>
}
    80002fec:	60e2                	ld	ra,24(sp)
    80002fee:	6442                	ld	s0,16(sp)
    80002ff0:	64a2                	ld	s1,8(sp)
    80002ff2:	6902                	ld	s2,0(sp)
    80002ff4:	6105                	addi	sp,sp,32
    80002ff6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ff8:	44bc                	lw	a5,72(s1)
    80002ffa:	dff1                	beqz	a5,80002fd6 <iput+0x26>
    80002ffc:	05249783          	lh	a5,82(s1)
    80003000:	fbf9                	bnez	a5,80002fd6 <iput+0x26>
    acquiresleep(&ip->lock);
    80003002:	01048913          	addi	s2,s1,16
    80003006:	854a                	mv	a0,s2
    80003008:	00001097          	auipc	ra,0x1
    8000300c:	ab8080e7          	jalr	-1352(ra) # 80003ac0 <acquiresleep>
    release(&itable.lock);
    80003010:	00018517          	auipc	a0,0x18
    80003014:	11850513          	addi	a0,a0,280 # 8001b128 <itable>
    80003018:	00003097          	auipc	ra,0x3
    8000301c:	7d8080e7          	jalr	2008(ra) # 800067f0 <release>
    itrunc(ip);
    80003020:	8526                	mv	a0,s1
    80003022:	00000097          	auipc	ra,0x0
    80003026:	ee2080e7          	jalr	-286(ra) # 80002f04 <itrunc>
    ip->type = 0;
    8000302a:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    8000302e:	8526                	mv	a0,s1
    80003030:	00000097          	auipc	ra,0x0
    80003034:	cfc080e7          	jalr	-772(ra) # 80002d2c <iupdate>
    ip->valid = 0;
    80003038:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    8000303c:	854a                	mv	a0,s2
    8000303e:	00001097          	auipc	ra,0x1
    80003042:	ad8080e7          	jalr	-1320(ra) # 80003b16 <releasesleep>
    acquire(&itable.lock);
    80003046:	00018517          	auipc	a0,0x18
    8000304a:	0e250513          	addi	a0,a0,226 # 8001b128 <itable>
    8000304e:	00003097          	auipc	ra,0x3
    80003052:	6d2080e7          	jalr	1746(ra) # 80006720 <acquire>
    80003056:	b741                	j	80002fd6 <iput+0x26>

0000000080003058 <iunlockput>:
{
    80003058:	1101                	addi	sp,sp,-32
    8000305a:	ec06                	sd	ra,24(sp)
    8000305c:	e822                	sd	s0,16(sp)
    8000305e:	e426                	sd	s1,8(sp)
    80003060:	1000                	addi	s0,sp,32
    80003062:	84aa                	mv	s1,a0
  iunlock(ip);
    80003064:	00000097          	auipc	ra,0x0
    80003068:	e54080e7          	jalr	-428(ra) # 80002eb8 <iunlock>
  iput(ip);
    8000306c:	8526                	mv	a0,s1
    8000306e:	00000097          	auipc	ra,0x0
    80003072:	f42080e7          	jalr	-190(ra) # 80002fb0 <iput>
}
    80003076:	60e2                	ld	ra,24(sp)
    80003078:	6442                	ld	s0,16(sp)
    8000307a:	64a2                	ld	s1,8(sp)
    8000307c:	6105                	addi	sp,sp,32
    8000307e:	8082                	ret

0000000080003080 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003080:	1141                	addi	sp,sp,-16
    80003082:	e422                	sd	s0,8(sp)
    80003084:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003086:	411c                	lw	a5,0(a0)
    80003088:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000308a:	415c                	lw	a5,4(a0)
    8000308c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000308e:	04c51783          	lh	a5,76(a0)
    80003092:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003096:	05251783          	lh	a5,82(a0)
    8000309a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000309e:	05456783          	lwu	a5,84(a0)
    800030a2:	e99c                	sd	a5,16(a1)
}
    800030a4:	6422                	ld	s0,8(sp)
    800030a6:	0141                	addi	sp,sp,16
    800030a8:	8082                	ret

00000000800030aa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030aa:	497c                	lw	a5,84(a0)
    800030ac:	0ed7e963          	bltu	a5,a3,8000319e <readi+0xf4>
{
    800030b0:	7159                	addi	sp,sp,-112
    800030b2:	f486                	sd	ra,104(sp)
    800030b4:	f0a2                	sd	s0,96(sp)
    800030b6:	eca6                	sd	s1,88(sp)
    800030b8:	e8ca                	sd	s2,80(sp)
    800030ba:	e4ce                	sd	s3,72(sp)
    800030bc:	e0d2                	sd	s4,64(sp)
    800030be:	fc56                	sd	s5,56(sp)
    800030c0:	f85a                	sd	s6,48(sp)
    800030c2:	f45e                	sd	s7,40(sp)
    800030c4:	f062                	sd	s8,32(sp)
    800030c6:	ec66                	sd	s9,24(sp)
    800030c8:	e86a                	sd	s10,16(sp)
    800030ca:	e46e                	sd	s11,8(sp)
    800030cc:	1880                	addi	s0,sp,112
    800030ce:	8baa                	mv	s7,a0
    800030d0:	8c2e                	mv	s8,a1
    800030d2:	8ab2                	mv	s5,a2
    800030d4:	84b6                	mv	s1,a3
    800030d6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030d8:	9f35                	addw	a4,a4,a3
    return 0;
    800030da:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030dc:	0ad76063          	bltu	a4,a3,8000317c <readi+0xd2>
  if(off + n > ip->size)
    800030e0:	00e7f463          	bgeu	a5,a4,800030e8 <readi+0x3e>
    n = ip->size - off;
    800030e4:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030e8:	0a0b0963          	beqz	s6,8000319a <readi+0xf0>
    800030ec:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ee:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030f2:	5cfd                	li	s9,-1
    800030f4:	a82d                	j	8000312e <readi+0x84>
    800030f6:	020a1d93          	slli	s11,s4,0x20
    800030fa:	020ddd93          	srli	s11,s11,0x20
    800030fe:	06090613          	addi	a2,s2,96
    80003102:	86ee                	mv	a3,s11
    80003104:	963a                	add	a2,a2,a4
    80003106:	85d6                	mv	a1,s5
    80003108:	8562                	mv	a0,s8
    8000310a:	fffff097          	auipc	ra,0xfffff
    8000310e:	8bc080e7          	jalr	-1860(ra) # 800019c6 <either_copyout>
    80003112:	05950d63          	beq	a0,s9,8000316c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003116:	854a                	mv	a0,s2
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	5dc080e7          	jalr	1500(ra) # 800026f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003120:	013a09bb          	addw	s3,s4,s3
    80003124:	009a04bb          	addw	s1,s4,s1
    80003128:	9aee                	add	s5,s5,s11
    8000312a:	0569f763          	bgeu	s3,s6,80003178 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000312e:	000ba903          	lw	s2,0(s7)
    80003132:	00a4d59b          	srliw	a1,s1,0xa
    80003136:	855e                	mv	a0,s7
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	8b0080e7          	jalr	-1872(ra) # 800029e8 <bmap>
    80003140:	0005059b          	sext.w	a1,a0
    80003144:	854a                	mv	a0,s2
    80003146:	fffff097          	auipc	ra,0xfffff
    8000314a:	29a080e7          	jalr	666(ra) # 800023e0 <bread>
    8000314e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003150:	3ff4f713          	andi	a4,s1,1023
    80003154:	40ed07bb          	subw	a5,s10,a4
    80003158:	413b06bb          	subw	a3,s6,s3
    8000315c:	8a3e                	mv	s4,a5
    8000315e:	2781                	sext.w	a5,a5
    80003160:	0006861b          	sext.w	a2,a3
    80003164:	f8f679e3          	bgeu	a2,a5,800030f6 <readi+0x4c>
    80003168:	8a36                	mv	s4,a3
    8000316a:	b771                	j	800030f6 <readi+0x4c>
      brelse(bp);
    8000316c:	854a                	mv	a0,s2
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	586080e7          	jalr	1414(ra) # 800026f4 <brelse>
      tot = -1;
    80003176:	59fd                	li	s3,-1
  }
  return tot;
    80003178:	0009851b          	sext.w	a0,s3
}
    8000317c:	70a6                	ld	ra,104(sp)
    8000317e:	7406                	ld	s0,96(sp)
    80003180:	64e6                	ld	s1,88(sp)
    80003182:	6946                	ld	s2,80(sp)
    80003184:	69a6                	ld	s3,72(sp)
    80003186:	6a06                	ld	s4,64(sp)
    80003188:	7ae2                	ld	s5,56(sp)
    8000318a:	7b42                	ld	s6,48(sp)
    8000318c:	7ba2                	ld	s7,40(sp)
    8000318e:	7c02                	ld	s8,32(sp)
    80003190:	6ce2                	ld	s9,24(sp)
    80003192:	6d42                	ld	s10,16(sp)
    80003194:	6da2                	ld	s11,8(sp)
    80003196:	6165                	addi	sp,sp,112
    80003198:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000319a:	89da                	mv	s3,s6
    8000319c:	bff1                	j	80003178 <readi+0xce>
    return 0;
    8000319e:	4501                	li	a0,0
}
    800031a0:	8082                	ret

00000000800031a2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031a2:	497c                	lw	a5,84(a0)
    800031a4:	10d7e863          	bltu	a5,a3,800032b4 <writei+0x112>
{
    800031a8:	7159                	addi	sp,sp,-112
    800031aa:	f486                	sd	ra,104(sp)
    800031ac:	f0a2                	sd	s0,96(sp)
    800031ae:	eca6                	sd	s1,88(sp)
    800031b0:	e8ca                	sd	s2,80(sp)
    800031b2:	e4ce                	sd	s3,72(sp)
    800031b4:	e0d2                	sd	s4,64(sp)
    800031b6:	fc56                	sd	s5,56(sp)
    800031b8:	f85a                	sd	s6,48(sp)
    800031ba:	f45e                	sd	s7,40(sp)
    800031bc:	f062                	sd	s8,32(sp)
    800031be:	ec66                	sd	s9,24(sp)
    800031c0:	e86a                	sd	s10,16(sp)
    800031c2:	e46e                	sd	s11,8(sp)
    800031c4:	1880                	addi	s0,sp,112
    800031c6:	8b2a                	mv	s6,a0
    800031c8:	8c2e                	mv	s8,a1
    800031ca:	8ab2                	mv	s5,a2
    800031cc:	8936                	mv	s2,a3
    800031ce:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800031d0:	00e687bb          	addw	a5,a3,a4
    800031d4:	0ed7e263          	bltu	a5,a3,800032b8 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031d8:	00043737          	lui	a4,0x43
    800031dc:	0ef76063          	bltu	a4,a5,800032bc <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031e0:	0c0b8863          	beqz	s7,800032b0 <writei+0x10e>
    800031e4:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031e6:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031ea:	5cfd                	li	s9,-1
    800031ec:	a091                	j	80003230 <writei+0x8e>
    800031ee:	02099d93          	slli	s11,s3,0x20
    800031f2:	020ddd93          	srli	s11,s11,0x20
    800031f6:	06048513          	addi	a0,s1,96
    800031fa:	86ee                	mv	a3,s11
    800031fc:	8656                	mv	a2,s5
    800031fe:	85e2                	mv	a1,s8
    80003200:	953a                	add	a0,a0,a4
    80003202:	fffff097          	auipc	ra,0xfffff
    80003206:	81a080e7          	jalr	-2022(ra) # 80001a1c <either_copyin>
    8000320a:	07950263          	beq	a0,s9,8000326e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000320e:	8526                	mv	a0,s1
    80003210:	00000097          	auipc	ra,0x0
    80003214:	790080e7          	jalr	1936(ra) # 800039a0 <log_write>
    brelse(bp);
    80003218:	8526                	mv	a0,s1
    8000321a:	fffff097          	auipc	ra,0xfffff
    8000321e:	4da080e7          	jalr	1242(ra) # 800026f4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003222:	01498a3b          	addw	s4,s3,s4
    80003226:	0129893b          	addw	s2,s3,s2
    8000322a:	9aee                	add	s5,s5,s11
    8000322c:	057a7663          	bgeu	s4,s7,80003278 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003230:	000b2483          	lw	s1,0(s6)
    80003234:	00a9559b          	srliw	a1,s2,0xa
    80003238:	855a                	mv	a0,s6
    8000323a:	fffff097          	auipc	ra,0xfffff
    8000323e:	7ae080e7          	jalr	1966(ra) # 800029e8 <bmap>
    80003242:	0005059b          	sext.w	a1,a0
    80003246:	8526                	mv	a0,s1
    80003248:	fffff097          	auipc	ra,0xfffff
    8000324c:	198080e7          	jalr	408(ra) # 800023e0 <bread>
    80003250:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003252:	3ff97713          	andi	a4,s2,1023
    80003256:	40ed07bb          	subw	a5,s10,a4
    8000325a:	414b86bb          	subw	a3,s7,s4
    8000325e:	89be                	mv	s3,a5
    80003260:	2781                	sext.w	a5,a5
    80003262:	0006861b          	sext.w	a2,a3
    80003266:	f8f674e3          	bgeu	a2,a5,800031ee <writei+0x4c>
    8000326a:	89b6                	mv	s3,a3
    8000326c:	b749                	j	800031ee <writei+0x4c>
      brelse(bp);
    8000326e:	8526                	mv	a0,s1
    80003270:	fffff097          	auipc	ra,0xfffff
    80003274:	484080e7          	jalr	1156(ra) # 800026f4 <brelse>
  }

  if(off > ip->size)
    80003278:	054b2783          	lw	a5,84(s6)
    8000327c:	0127f463          	bgeu	a5,s2,80003284 <writei+0xe2>
    ip->size = off;
    80003280:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003284:	855a                	mv	a0,s6
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	aa6080e7          	jalr	-1370(ra) # 80002d2c <iupdate>

  return tot;
    8000328e:	000a051b          	sext.w	a0,s4
}
    80003292:	70a6                	ld	ra,104(sp)
    80003294:	7406                	ld	s0,96(sp)
    80003296:	64e6                	ld	s1,88(sp)
    80003298:	6946                	ld	s2,80(sp)
    8000329a:	69a6                	ld	s3,72(sp)
    8000329c:	6a06                	ld	s4,64(sp)
    8000329e:	7ae2                	ld	s5,56(sp)
    800032a0:	7b42                	ld	s6,48(sp)
    800032a2:	7ba2                	ld	s7,40(sp)
    800032a4:	7c02                	ld	s8,32(sp)
    800032a6:	6ce2                	ld	s9,24(sp)
    800032a8:	6d42                	ld	s10,16(sp)
    800032aa:	6da2                	ld	s11,8(sp)
    800032ac:	6165                	addi	sp,sp,112
    800032ae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032b0:	8a5e                	mv	s4,s7
    800032b2:	bfc9                	j	80003284 <writei+0xe2>
    return -1;
    800032b4:	557d                	li	a0,-1
}
    800032b6:	8082                	ret
    return -1;
    800032b8:	557d                	li	a0,-1
    800032ba:	bfe1                	j	80003292 <writei+0xf0>
    return -1;
    800032bc:	557d                	li	a0,-1
    800032be:	bfd1                	j	80003292 <writei+0xf0>

00000000800032c0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800032c0:	1141                	addi	sp,sp,-16
    800032c2:	e406                	sd	ra,8(sp)
    800032c4:	e022                	sd	s0,0(sp)
    800032c6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800032c8:	4639                	li	a2,14
    800032ca:	ffffd097          	auipc	ra,0xffffd
    800032ce:	094080e7          	jalr	148(ra) # 8000035e <strncmp>
}
    800032d2:	60a2                	ld	ra,8(sp)
    800032d4:	6402                	ld	s0,0(sp)
    800032d6:	0141                	addi	sp,sp,16
    800032d8:	8082                	ret

00000000800032da <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032da:	7139                	addi	sp,sp,-64
    800032dc:	fc06                	sd	ra,56(sp)
    800032de:	f822                	sd	s0,48(sp)
    800032e0:	f426                	sd	s1,40(sp)
    800032e2:	f04a                	sd	s2,32(sp)
    800032e4:	ec4e                	sd	s3,24(sp)
    800032e6:	e852                	sd	s4,16(sp)
    800032e8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032ea:	04c51703          	lh	a4,76(a0)
    800032ee:	4785                	li	a5,1
    800032f0:	00f71a63          	bne	a4,a5,80003304 <dirlookup+0x2a>
    800032f4:	892a                	mv	s2,a0
    800032f6:	89ae                	mv	s3,a1
    800032f8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032fa:	497c                	lw	a5,84(a0)
    800032fc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032fe:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003300:	e79d                	bnez	a5,8000332e <dirlookup+0x54>
    80003302:	a8a5                	j	8000337a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003304:	00005517          	auipc	a0,0x5
    80003308:	27c50513          	addi	a0,a0,636 # 80008580 <syscalls+0x1b8>
    8000330c:	00003097          	auipc	ra,0x3
    80003310:	ee0080e7          	jalr	-288(ra) # 800061ec <panic>
      panic("dirlookup read");
    80003314:	00005517          	auipc	a0,0x5
    80003318:	28450513          	addi	a0,a0,644 # 80008598 <syscalls+0x1d0>
    8000331c:	00003097          	auipc	ra,0x3
    80003320:	ed0080e7          	jalr	-304(ra) # 800061ec <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003324:	24c1                	addiw	s1,s1,16
    80003326:	05492783          	lw	a5,84(s2)
    8000332a:	04f4f763          	bgeu	s1,a5,80003378 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000332e:	4741                	li	a4,16
    80003330:	86a6                	mv	a3,s1
    80003332:	fc040613          	addi	a2,s0,-64
    80003336:	4581                	li	a1,0
    80003338:	854a                	mv	a0,s2
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	d70080e7          	jalr	-656(ra) # 800030aa <readi>
    80003342:	47c1                	li	a5,16
    80003344:	fcf518e3          	bne	a0,a5,80003314 <dirlookup+0x3a>
    if(de.inum == 0)
    80003348:	fc045783          	lhu	a5,-64(s0)
    8000334c:	dfe1                	beqz	a5,80003324 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000334e:	fc240593          	addi	a1,s0,-62
    80003352:	854e                	mv	a0,s3
    80003354:	00000097          	auipc	ra,0x0
    80003358:	f6c080e7          	jalr	-148(ra) # 800032c0 <namecmp>
    8000335c:	f561                	bnez	a0,80003324 <dirlookup+0x4a>
      if(poff)
    8000335e:	000a0463          	beqz	s4,80003366 <dirlookup+0x8c>
        *poff = off;
    80003362:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003366:	fc045583          	lhu	a1,-64(s0)
    8000336a:	00092503          	lw	a0,0(s2)
    8000336e:	fffff097          	auipc	ra,0xfffff
    80003372:	754080e7          	jalr	1876(ra) # 80002ac2 <iget>
    80003376:	a011                	j	8000337a <dirlookup+0xa0>
  return 0;
    80003378:	4501                	li	a0,0
}
    8000337a:	70e2                	ld	ra,56(sp)
    8000337c:	7442                	ld	s0,48(sp)
    8000337e:	74a2                	ld	s1,40(sp)
    80003380:	7902                	ld	s2,32(sp)
    80003382:	69e2                	ld	s3,24(sp)
    80003384:	6a42                	ld	s4,16(sp)
    80003386:	6121                	addi	sp,sp,64
    80003388:	8082                	ret

000000008000338a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000338a:	711d                	addi	sp,sp,-96
    8000338c:	ec86                	sd	ra,88(sp)
    8000338e:	e8a2                	sd	s0,80(sp)
    80003390:	e4a6                	sd	s1,72(sp)
    80003392:	e0ca                	sd	s2,64(sp)
    80003394:	fc4e                	sd	s3,56(sp)
    80003396:	f852                	sd	s4,48(sp)
    80003398:	f456                	sd	s5,40(sp)
    8000339a:	f05a                	sd	s6,32(sp)
    8000339c:	ec5e                	sd	s7,24(sp)
    8000339e:	e862                	sd	s8,16(sp)
    800033a0:	e466                	sd	s9,8(sp)
    800033a2:	1080                	addi	s0,sp,96
    800033a4:	84aa                	mv	s1,a0
    800033a6:	8b2e                	mv	s6,a1
    800033a8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800033aa:	00054703          	lbu	a4,0(a0)
    800033ae:	02f00793          	li	a5,47
    800033b2:	02f70363          	beq	a4,a5,800033d8 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033b6:	ffffe097          	auipc	ra,0xffffe
    800033ba:	bb0080e7          	jalr	-1104(ra) # 80000f66 <myproc>
    800033be:	15853503          	ld	a0,344(a0)
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	9f6080e7          	jalr	-1546(ra) # 80002db8 <idup>
    800033ca:	89aa                	mv	s3,a0
  while(*path == '/')
    800033cc:	02f00913          	li	s2,47
  len = path - s;
    800033d0:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800033d2:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033d4:	4c05                	li	s8,1
    800033d6:	a865                	j	8000348e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800033d8:	4585                	li	a1,1
    800033da:	4505                	li	a0,1
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	6e6080e7          	jalr	1766(ra) # 80002ac2 <iget>
    800033e4:	89aa                	mv	s3,a0
    800033e6:	b7dd                	j	800033cc <namex+0x42>
      iunlockput(ip);
    800033e8:	854e                	mv	a0,s3
    800033ea:	00000097          	auipc	ra,0x0
    800033ee:	c6e080e7          	jalr	-914(ra) # 80003058 <iunlockput>
      return 0;
    800033f2:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033f4:	854e                	mv	a0,s3
    800033f6:	60e6                	ld	ra,88(sp)
    800033f8:	6446                	ld	s0,80(sp)
    800033fa:	64a6                	ld	s1,72(sp)
    800033fc:	6906                	ld	s2,64(sp)
    800033fe:	79e2                	ld	s3,56(sp)
    80003400:	7a42                	ld	s4,48(sp)
    80003402:	7aa2                	ld	s5,40(sp)
    80003404:	7b02                	ld	s6,32(sp)
    80003406:	6be2                	ld	s7,24(sp)
    80003408:	6c42                	ld	s8,16(sp)
    8000340a:	6ca2                	ld	s9,8(sp)
    8000340c:	6125                	addi	sp,sp,96
    8000340e:	8082                	ret
      iunlock(ip);
    80003410:	854e                	mv	a0,s3
    80003412:	00000097          	auipc	ra,0x0
    80003416:	aa6080e7          	jalr	-1370(ra) # 80002eb8 <iunlock>
      return ip;
    8000341a:	bfe9                	j	800033f4 <namex+0x6a>
      iunlockput(ip);
    8000341c:	854e                	mv	a0,s3
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	c3a080e7          	jalr	-966(ra) # 80003058 <iunlockput>
      return 0;
    80003426:	89d2                	mv	s3,s4
    80003428:	b7f1                	j	800033f4 <namex+0x6a>
  len = path - s;
    8000342a:	40b48633          	sub	a2,s1,a1
    8000342e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003432:	094cd463          	bge	s9,s4,800034ba <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003436:	4639                	li	a2,14
    80003438:	8556                	mv	a0,s5
    8000343a:	ffffd097          	auipc	ra,0xffffd
    8000343e:	eac080e7          	jalr	-340(ra) # 800002e6 <memmove>
  while(*path == '/')
    80003442:	0004c783          	lbu	a5,0(s1)
    80003446:	01279763          	bne	a5,s2,80003454 <namex+0xca>
    path++;
    8000344a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000344c:	0004c783          	lbu	a5,0(s1)
    80003450:	ff278de3          	beq	a5,s2,8000344a <namex+0xc0>
    ilock(ip);
    80003454:	854e                	mv	a0,s3
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	9a0080e7          	jalr	-1632(ra) # 80002df6 <ilock>
    if(ip->type != T_DIR){
    8000345e:	04c99783          	lh	a5,76(s3)
    80003462:	f98793e3          	bne	a5,s8,800033e8 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003466:	000b0563          	beqz	s6,80003470 <namex+0xe6>
    8000346a:	0004c783          	lbu	a5,0(s1)
    8000346e:	d3cd                	beqz	a5,80003410 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003470:	865e                	mv	a2,s7
    80003472:	85d6                	mv	a1,s5
    80003474:	854e                	mv	a0,s3
    80003476:	00000097          	auipc	ra,0x0
    8000347a:	e64080e7          	jalr	-412(ra) # 800032da <dirlookup>
    8000347e:	8a2a                	mv	s4,a0
    80003480:	dd51                	beqz	a0,8000341c <namex+0x92>
    iunlockput(ip);
    80003482:	854e                	mv	a0,s3
    80003484:	00000097          	auipc	ra,0x0
    80003488:	bd4080e7          	jalr	-1068(ra) # 80003058 <iunlockput>
    ip = next;
    8000348c:	89d2                	mv	s3,s4
  while(*path == '/')
    8000348e:	0004c783          	lbu	a5,0(s1)
    80003492:	05279763          	bne	a5,s2,800034e0 <namex+0x156>
    path++;
    80003496:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003498:	0004c783          	lbu	a5,0(s1)
    8000349c:	ff278de3          	beq	a5,s2,80003496 <namex+0x10c>
  if(*path == 0)
    800034a0:	c79d                	beqz	a5,800034ce <namex+0x144>
    path++;
    800034a2:	85a6                	mv	a1,s1
  len = path - s;
    800034a4:	8a5e                	mv	s4,s7
    800034a6:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800034a8:	01278963          	beq	a5,s2,800034ba <namex+0x130>
    800034ac:	dfbd                	beqz	a5,8000342a <namex+0xa0>
    path++;
    800034ae:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800034b0:	0004c783          	lbu	a5,0(s1)
    800034b4:	ff279ce3          	bne	a5,s2,800034ac <namex+0x122>
    800034b8:	bf8d                	j	8000342a <namex+0xa0>
    memmove(name, s, len);
    800034ba:	2601                	sext.w	a2,a2
    800034bc:	8556                	mv	a0,s5
    800034be:	ffffd097          	auipc	ra,0xffffd
    800034c2:	e28080e7          	jalr	-472(ra) # 800002e6 <memmove>
    name[len] = 0;
    800034c6:	9a56                	add	s4,s4,s5
    800034c8:	000a0023          	sb	zero,0(s4)
    800034cc:	bf9d                	j	80003442 <namex+0xb8>
  if(nameiparent){
    800034ce:	f20b03e3          	beqz	s6,800033f4 <namex+0x6a>
    iput(ip);
    800034d2:	854e                	mv	a0,s3
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	adc080e7          	jalr	-1316(ra) # 80002fb0 <iput>
    return 0;
    800034dc:	4981                	li	s3,0
    800034de:	bf19                	j	800033f4 <namex+0x6a>
  if(*path == 0)
    800034e0:	d7fd                	beqz	a5,800034ce <namex+0x144>
  while(*path != '/' && *path != 0)
    800034e2:	0004c783          	lbu	a5,0(s1)
    800034e6:	85a6                	mv	a1,s1
    800034e8:	b7d1                	j	800034ac <namex+0x122>

00000000800034ea <dirlink>:
{
    800034ea:	7139                	addi	sp,sp,-64
    800034ec:	fc06                	sd	ra,56(sp)
    800034ee:	f822                	sd	s0,48(sp)
    800034f0:	f426                	sd	s1,40(sp)
    800034f2:	f04a                	sd	s2,32(sp)
    800034f4:	ec4e                	sd	s3,24(sp)
    800034f6:	e852                	sd	s4,16(sp)
    800034f8:	0080                	addi	s0,sp,64
    800034fa:	892a                	mv	s2,a0
    800034fc:	8a2e                	mv	s4,a1
    800034fe:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003500:	4601                	li	a2,0
    80003502:	00000097          	auipc	ra,0x0
    80003506:	dd8080e7          	jalr	-552(ra) # 800032da <dirlookup>
    8000350a:	e93d                	bnez	a0,80003580 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000350c:	05492483          	lw	s1,84(s2)
    80003510:	c49d                	beqz	s1,8000353e <dirlink+0x54>
    80003512:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003514:	4741                	li	a4,16
    80003516:	86a6                	mv	a3,s1
    80003518:	fc040613          	addi	a2,s0,-64
    8000351c:	4581                	li	a1,0
    8000351e:	854a                	mv	a0,s2
    80003520:	00000097          	auipc	ra,0x0
    80003524:	b8a080e7          	jalr	-1142(ra) # 800030aa <readi>
    80003528:	47c1                	li	a5,16
    8000352a:	06f51163          	bne	a0,a5,8000358c <dirlink+0xa2>
    if(de.inum == 0)
    8000352e:	fc045783          	lhu	a5,-64(s0)
    80003532:	c791                	beqz	a5,8000353e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003534:	24c1                	addiw	s1,s1,16
    80003536:	05492783          	lw	a5,84(s2)
    8000353a:	fcf4ede3          	bltu	s1,a5,80003514 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000353e:	4639                	li	a2,14
    80003540:	85d2                	mv	a1,s4
    80003542:	fc240513          	addi	a0,s0,-62
    80003546:	ffffd097          	auipc	ra,0xffffd
    8000354a:	e54080e7          	jalr	-428(ra) # 8000039a <strncpy>
  de.inum = inum;
    8000354e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003552:	4741                	li	a4,16
    80003554:	86a6                	mv	a3,s1
    80003556:	fc040613          	addi	a2,s0,-64
    8000355a:	4581                	li	a1,0
    8000355c:	854a                	mv	a0,s2
    8000355e:	00000097          	auipc	ra,0x0
    80003562:	c44080e7          	jalr	-956(ra) # 800031a2 <writei>
    80003566:	872a                	mv	a4,a0
    80003568:	47c1                	li	a5,16
  return 0;
    8000356a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000356c:	02f71863          	bne	a4,a5,8000359c <dirlink+0xb2>
}
    80003570:	70e2                	ld	ra,56(sp)
    80003572:	7442                	ld	s0,48(sp)
    80003574:	74a2                	ld	s1,40(sp)
    80003576:	7902                	ld	s2,32(sp)
    80003578:	69e2                	ld	s3,24(sp)
    8000357a:	6a42                	ld	s4,16(sp)
    8000357c:	6121                	addi	sp,sp,64
    8000357e:	8082                	ret
    iput(ip);
    80003580:	00000097          	auipc	ra,0x0
    80003584:	a30080e7          	jalr	-1488(ra) # 80002fb0 <iput>
    return -1;
    80003588:	557d                	li	a0,-1
    8000358a:	b7dd                	j	80003570 <dirlink+0x86>
      panic("dirlink read");
    8000358c:	00005517          	auipc	a0,0x5
    80003590:	01c50513          	addi	a0,a0,28 # 800085a8 <syscalls+0x1e0>
    80003594:	00003097          	auipc	ra,0x3
    80003598:	c58080e7          	jalr	-936(ra) # 800061ec <panic>
    panic("dirlink");
    8000359c:	00005517          	auipc	a0,0x5
    800035a0:	11c50513          	addi	a0,a0,284 # 800086b8 <syscalls+0x2f0>
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	c48080e7          	jalr	-952(ra) # 800061ec <panic>

00000000800035ac <namei>:

struct inode*
namei(char *path)
{
    800035ac:	1101                	addi	sp,sp,-32
    800035ae:	ec06                	sd	ra,24(sp)
    800035b0:	e822                	sd	s0,16(sp)
    800035b2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035b4:	fe040613          	addi	a2,s0,-32
    800035b8:	4581                	li	a1,0
    800035ba:	00000097          	auipc	ra,0x0
    800035be:	dd0080e7          	jalr	-560(ra) # 8000338a <namex>
}
    800035c2:	60e2                	ld	ra,24(sp)
    800035c4:	6442                	ld	s0,16(sp)
    800035c6:	6105                	addi	sp,sp,32
    800035c8:	8082                	ret

00000000800035ca <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800035ca:	1141                	addi	sp,sp,-16
    800035cc:	e406                	sd	ra,8(sp)
    800035ce:	e022                	sd	s0,0(sp)
    800035d0:	0800                	addi	s0,sp,16
    800035d2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035d4:	4585                	li	a1,1
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	db4080e7          	jalr	-588(ra) # 8000338a <namex>
}
    800035de:	60a2                	ld	ra,8(sp)
    800035e0:	6402                	ld	s0,0(sp)
    800035e2:	0141                	addi	sp,sp,16
    800035e4:	8082                	ret

00000000800035e6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035e6:	1101                	addi	sp,sp,-32
    800035e8:	ec06                	sd	ra,24(sp)
    800035ea:	e822                	sd	s0,16(sp)
    800035ec:	e426                	sd	s1,8(sp)
    800035ee:	e04a                	sd	s2,0(sp)
    800035f0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035f2:	00019917          	auipc	s2,0x19
    800035f6:	77690913          	addi	s2,s2,1910 # 8001cd68 <log>
    800035fa:	02092583          	lw	a1,32(s2)
    800035fe:	03092503          	lw	a0,48(s2)
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	dde080e7          	jalr	-546(ra) # 800023e0 <bread>
    8000360a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000360c:	03492683          	lw	a3,52(s2)
    80003610:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003612:	02d05763          	blez	a3,80003640 <write_head+0x5a>
    80003616:	00019797          	auipc	a5,0x19
    8000361a:	78a78793          	addi	a5,a5,1930 # 8001cda0 <log+0x38>
    8000361e:	06450713          	addi	a4,a0,100
    80003622:	36fd                	addiw	a3,a3,-1
    80003624:	1682                	slli	a3,a3,0x20
    80003626:	9281                	srli	a3,a3,0x20
    80003628:	068a                	slli	a3,a3,0x2
    8000362a:	00019617          	auipc	a2,0x19
    8000362e:	77a60613          	addi	a2,a2,1914 # 8001cda4 <log+0x3c>
    80003632:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003634:	4390                	lw	a2,0(a5)
    80003636:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003638:	0791                	addi	a5,a5,4
    8000363a:	0711                	addi	a4,a4,4
    8000363c:	fed79ce3          	bne	a5,a3,80003634 <write_head+0x4e>
  }
  bwrite(buf);
    80003640:	8526                	mv	a0,s1
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	074080e7          	jalr	116(ra) # 800026b6 <bwrite>
  brelse(buf);
    8000364a:	8526                	mv	a0,s1
    8000364c:	fffff097          	auipc	ra,0xfffff
    80003650:	0a8080e7          	jalr	168(ra) # 800026f4 <brelse>
}
    80003654:	60e2                	ld	ra,24(sp)
    80003656:	6442                	ld	s0,16(sp)
    80003658:	64a2                	ld	s1,8(sp)
    8000365a:	6902                	ld	s2,0(sp)
    8000365c:	6105                	addi	sp,sp,32
    8000365e:	8082                	ret

0000000080003660 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003660:	00019797          	auipc	a5,0x19
    80003664:	73c7a783          	lw	a5,1852(a5) # 8001cd9c <log+0x34>
    80003668:	0af05d63          	blez	a5,80003722 <install_trans+0xc2>
{
    8000366c:	7139                	addi	sp,sp,-64
    8000366e:	fc06                	sd	ra,56(sp)
    80003670:	f822                	sd	s0,48(sp)
    80003672:	f426                	sd	s1,40(sp)
    80003674:	f04a                	sd	s2,32(sp)
    80003676:	ec4e                	sd	s3,24(sp)
    80003678:	e852                	sd	s4,16(sp)
    8000367a:	e456                	sd	s5,8(sp)
    8000367c:	e05a                	sd	s6,0(sp)
    8000367e:	0080                	addi	s0,sp,64
    80003680:	8b2a                	mv	s6,a0
    80003682:	00019a97          	auipc	s5,0x19
    80003686:	71ea8a93          	addi	s5,s5,1822 # 8001cda0 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000368a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000368c:	00019997          	auipc	s3,0x19
    80003690:	6dc98993          	addi	s3,s3,1756 # 8001cd68 <log>
    80003694:	a035                	j	800036c0 <install_trans+0x60>
      bunpin(dbuf);
    80003696:	8526                	mv	a0,s1
    80003698:	fffff097          	auipc	ra,0xfffff
    8000369c:	14a080e7          	jalr	330(ra) # 800027e2 <bunpin>
    brelse(lbuf);
    800036a0:	854a                	mv	a0,s2
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	052080e7          	jalr	82(ra) # 800026f4 <brelse>
    brelse(dbuf);
    800036aa:	8526                	mv	a0,s1
    800036ac:	fffff097          	auipc	ra,0xfffff
    800036b0:	048080e7          	jalr	72(ra) # 800026f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b4:	2a05                	addiw	s4,s4,1
    800036b6:	0a91                	addi	s5,s5,4
    800036b8:	0349a783          	lw	a5,52(s3)
    800036bc:	04fa5963          	bge	s4,a5,8000370e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036c0:	0209a583          	lw	a1,32(s3)
    800036c4:	014585bb          	addw	a1,a1,s4
    800036c8:	2585                	addiw	a1,a1,1
    800036ca:	0309a503          	lw	a0,48(s3)
    800036ce:	fffff097          	auipc	ra,0xfffff
    800036d2:	d12080e7          	jalr	-750(ra) # 800023e0 <bread>
    800036d6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036d8:	000aa583          	lw	a1,0(s5)
    800036dc:	0309a503          	lw	a0,48(s3)
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	d00080e7          	jalr	-768(ra) # 800023e0 <bread>
    800036e8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036ea:	40000613          	li	a2,1024
    800036ee:	06090593          	addi	a1,s2,96
    800036f2:	06050513          	addi	a0,a0,96
    800036f6:	ffffd097          	auipc	ra,0xffffd
    800036fa:	bf0080e7          	jalr	-1040(ra) # 800002e6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036fe:	8526                	mv	a0,s1
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	fb6080e7          	jalr	-74(ra) # 800026b6 <bwrite>
    if(recovering == 0)
    80003708:	f80b1ce3          	bnez	s6,800036a0 <install_trans+0x40>
    8000370c:	b769                	j	80003696 <install_trans+0x36>
}
    8000370e:	70e2                	ld	ra,56(sp)
    80003710:	7442                	ld	s0,48(sp)
    80003712:	74a2                	ld	s1,40(sp)
    80003714:	7902                	ld	s2,32(sp)
    80003716:	69e2                	ld	s3,24(sp)
    80003718:	6a42                	ld	s4,16(sp)
    8000371a:	6aa2                	ld	s5,8(sp)
    8000371c:	6b02                	ld	s6,0(sp)
    8000371e:	6121                	addi	sp,sp,64
    80003720:	8082                	ret
    80003722:	8082                	ret

0000000080003724 <initlog>:
{
    80003724:	7179                	addi	sp,sp,-48
    80003726:	f406                	sd	ra,40(sp)
    80003728:	f022                	sd	s0,32(sp)
    8000372a:	ec26                	sd	s1,24(sp)
    8000372c:	e84a                	sd	s2,16(sp)
    8000372e:	e44e                	sd	s3,8(sp)
    80003730:	1800                	addi	s0,sp,48
    80003732:	892a                	mv	s2,a0
    80003734:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003736:	00019497          	auipc	s1,0x19
    8000373a:	63248493          	addi	s1,s1,1586 # 8001cd68 <log>
    8000373e:	00005597          	auipc	a1,0x5
    80003742:	e7a58593          	addi	a1,a1,-390 # 800085b8 <syscalls+0x1f0>
    80003746:	8526                	mv	a0,s1
    80003748:	00003097          	auipc	ra,0x3
    8000374c:	154080e7          	jalr	340(ra) # 8000689c <initlock>
  log.start = sb->logstart;
    80003750:	0149a583          	lw	a1,20(s3)
    80003754:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    80003756:	0109a783          	lw	a5,16(s3)
    8000375a:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    8000375c:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003760:	854a                	mv	a0,s2
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	c7e080e7          	jalr	-898(ra) # 800023e0 <bread>
  log.lh.n = lh->n;
    8000376a:	513c                	lw	a5,96(a0)
    8000376c:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000376e:	02f05563          	blez	a5,80003798 <initlog+0x74>
    80003772:	06450713          	addi	a4,a0,100
    80003776:	00019697          	auipc	a3,0x19
    8000377a:	62a68693          	addi	a3,a3,1578 # 8001cda0 <log+0x38>
    8000377e:	37fd                	addiw	a5,a5,-1
    80003780:	1782                	slli	a5,a5,0x20
    80003782:	9381                	srli	a5,a5,0x20
    80003784:	078a                	slli	a5,a5,0x2
    80003786:	06850613          	addi	a2,a0,104
    8000378a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000378c:	4310                	lw	a2,0(a4)
    8000378e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003790:	0711                	addi	a4,a4,4
    80003792:	0691                	addi	a3,a3,4
    80003794:	fef71ce3          	bne	a4,a5,8000378c <initlog+0x68>
  brelse(buf);
    80003798:	fffff097          	auipc	ra,0xfffff
    8000379c:	f5c080e7          	jalr	-164(ra) # 800026f4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037a0:	4505                	li	a0,1
    800037a2:	00000097          	auipc	ra,0x0
    800037a6:	ebe080e7          	jalr	-322(ra) # 80003660 <install_trans>
  log.lh.n = 0;
    800037aa:	00019797          	auipc	a5,0x19
    800037ae:	5e07a923          	sw	zero,1522(a5) # 8001cd9c <log+0x34>
  write_head(); // clear the log
    800037b2:	00000097          	auipc	ra,0x0
    800037b6:	e34080e7          	jalr	-460(ra) # 800035e6 <write_head>
}
    800037ba:	70a2                	ld	ra,40(sp)
    800037bc:	7402                	ld	s0,32(sp)
    800037be:	64e2                	ld	s1,24(sp)
    800037c0:	6942                	ld	s2,16(sp)
    800037c2:	69a2                	ld	s3,8(sp)
    800037c4:	6145                	addi	sp,sp,48
    800037c6:	8082                	ret

00000000800037c8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800037c8:	1101                	addi	sp,sp,-32
    800037ca:	ec06                	sd	ra,24(sp)
    800037cc:	e822                	sd	s0,16(sp)
    800037ce:	e426                	sd	s1,8(sp)
    800037d0:	e04a                	sd	s2,0(sp)
    800037d2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037d4:	00019517          	auipc	a0,0x19
    800037d8:	59450513          	addi	a0,a0,1428 # 8001cd68 <log>
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	f44080e7          	jalr	-188(ra) # 80006720 <acquire>
  while(1){
    if(log.committing){
    800037e4:	00019497          	auipc	s1,0x19
    800037e8:	58448493          	addi	s1,s1,1412 # 8001cd68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037ec:	4979                	li	s2,30
    800037ee:	a039                	j	800037fc <begin_op+0x34>
      sleep(&log, &log.lock);
    800037f0:	85a6                	mv	a1,s1
    800037f2:	8526                	mv	a0,s1
    800037f4:	ffffe097          	auipc	ra,0xffffe
    800037f8:	e2e080e7          	jalr	-466(ra) # 80001622 <sleep>
    if(log.committing){
    800037fc:	54dc                	lw	a5,44(s1)
    800037fe:	fbed                	bnez	a5,800037f0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003800:	549c                	lw	a5,40(s1)
    80003802:	0017871b          	addiw	a4,a5,1
    80003806:	0007069b          	sext.w	a3,a4
    8000380a:	0027179b          	slliw	a5,a4,0x2
    8000380e:	9fb9                	addw	a5,a5,a4
    80003810:	0017979b          	slliw	a5,a5,0x1
    80003814:	58d8                	lw	a4,52(s1)
    80003816:	9fb9                	addw	a5,a5,a4
    80003818:	00f95963          	bge	s2,a5,8000382a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000381c:	85a6                	mv	a1,s1
    8000381e:	8526                	mv	a0,s1
    80003820:	ffffe097          	auipc	ra,0xffffe
    80003824:	e02080e7          	jalr	-510(ra) # 80001622 <sleep>
    80003828:	bfd1                	j	800037fc <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000382a:	00019517          	auipc	a0,0x19
    8000382e:	53e50513          	addi	a0,a0,1342 # 8001cd68 <log>
    80003832:	d514                	sw	a3,40(a0)
      release(&log.lock);
    80003834:	00003097          	auipc	ra,0x3
    80003838:	fbc080e7          	jalr	-68(ra) # 800067f0 <release>
      break;
    }
  }
}
    8000383c:	60e2                	ld	ra,24(sp)
    8000383e:	6442                	ld	s0,16(sp)
    80003840:	64a2                	ld	s1,8(sp)
    80003842:	6902                	ld	s2,0(sp)
    80003844:	6105                	addi	sp,sp,32
    80003846:	8082                	ret

0000000080003848 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003848:	7139                	addi	sp,sp,-64
    8000384a:	fc06                	sd	ra,56(sp)
    8000384c:	f822                	sd	s0,48(sp)
    8000384e:	f426                	sd	s1,40(sp)
    80003850:	f04a                	sd	s2,32(sp)
    80003852:	ec4e                	sd	s3,24(sp)
    80003854:	e852                	sd	s4,16(sp)
    80003856:	e456                	sd	s5,8(sp)
    80003858:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000385a:	00019497          	auipc	s1,0x19
    8000385e:	50e48493          	addi	s1,s1,1294 # 8001cd68 <log>
    80003862:	8526                	mv	a0,s1
    80003864:	00003097          	auipc	ra,0x3
    80003868:	ebc080e7          	jalr	-324(ra) # 80006720 <acquire>
  log.outstanding -= 1;
    8000386c:	549c                	lw	a5,40(s1)
    8000386e:	37fd                	addiw	a5,a5,-1
    80003870:	0007891b          	sext.w	s2,a5
    80003874:	d49c                	sw	a5,40(s1)
  if(log.committing)
    80003876:	54dc                	lw	a5,44(s1)
    80003878:	efb9                	bnez	a5,800038d6 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000387a:	06091663          	bnez	s2,800038e6 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000387e:	00019497          	auipc	s1,0x19
    80003882:	4ea48493          	addi	s1,s1,1258 # 8001cd68 <log>
    80003886:	4785                	li	a5,1
    80003888:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000388a:	8526                	mv	a0,s1
    8000388c:	00003097          	auipc	ra,0x3
    80003890:	f64080e7          	jalr	-156(ra) # 800067f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003894:	58dc                	lw	a5,52(s1)
    80003896:	06f04763          	bgtz	a5,80003904 <end_op+0xbc>
    acquire(&log.lock);
    8000389a:	00019497          	auipc	s1,0x19
    8000389e:	4ce48493          	addi	s1,s1,1230 # 8001cd68 <log>
    800038a2:	8526                	mv	a0,s1
    800038a4:	00003097          	auipc	ra,0x3
    800038a8:	e7c080e7          	jalr	-388(ra) # 80006720 <acquire>
    log.committing = 0;
    800038ac:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    800038b0:	8526                	mv	a0,s1
    800038b2:	ffffe097          	auipc	ra,0xffffe
    800038b6:	efc080e7          	jalr	-260(ra) # 800017ae <wakeup>
    release(&log.lock);
    800038ba:	8526                	mv	a0,s1
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	f34080e7          	jalr	-204(ra) # 800067f0 <release>
}
    800038c4:	70e2                	ld	ra,56(sp)
    800038c6:	7442                	ld	s0,48(sp)
    800038c8:	74a2                	ld	s1,40(sp)
    800038ca:	7902                	ld	s2,32(sp)
    800038cc:	69e2                	ld	s3,24(sp)
    800038ce:	6a42                	ld	s4,16(sp)
    800038d0:	6aa2                	ld	s5,8(sp)
    800038d2:	6121                	addi	sp,sp,64
    800038d4:	8082                	ret
    panic("log.committing");
    800038d6:	00005517          	auipc	a0,0x5
    800038da:	cea50513          	addi	a0,a0,-790 # 800085c0 <syscalls+0x1f8>
    800038de:	00003097          	auipc	ra,0x3
    800038e2:	90e080e7          	jalr	-1778(ra) # 800061ec <panic>
    wakeup(&log);
    800038e6:	00019497          	auipc	s1,0x19
    800038ea:	48248493          	addi	s1,s1,1154 # 8001cd68 <log>
    800038ee:	8526                	mv	a0,s1
    800038f0:	ffffe097          	auipc	ra,0xffffe
    800038f4:	ebe080e7          	jalr	-322(ra) # 800017ae <wakeup>
  release(&log.lock);
    800038f8:	8526                	mv	a0,s1
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	ef6080e7          	jalr	-266(ra) # 800067f0 <release>
  if(do_commit){
    80003902:	b7c9                	j	800038c4 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003904:	00019a97          	auipc	s5,0x19
    80003908:	49ca8a93          	addi	s5,s5,1180 # 8001cda0 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000390c:	00019a17          	auipc	s4,0x19
    80003910:	45ca0a13          	addi	s4,s4,1116 # 8001cd68 <log>
    80003914:	020a2583          	lw	a1,32(s4)
    80003918:	012585bb          	addw	a1,a1,s2
    8000391c:	2585                	addiw	a1,a1,1
    8000391e:	030a2503          	lw	a0,48(s4)
    80003922:	fffff097          	auipc	ra,0xfffff
    80003926:	abe080e7          	jalr	-1346(ra) # 800023e0 <bread>
    8000392a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000392c:	000aa583          	lw	a1,0(s5)
    80003930:	030a2503          	lw	a0,48(s4)
    80003934:	fffff097          	auipc	ra,0xfffff
    80003938:	aac080e7          	jalr	-1364(ra) # 800023e0 <bread>
    8000393c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000393e:	40000613          	li	a2,1024
    80003942:	06050593          	addi	a1,a0,96
    80003946:	06048513          	addi	a0,s1,96
    8000394a:	ffffd097          	auipc	ra,0xffffd
    8000394e:	99c080e7          	jalr	-1636(ra) # 800002e6 <memmove>
    bwrite(to);  // write the log
    80003952:	8526                	mv	a0,s1
    80003954:	fffff097          	auipc	ra,0xfffff
    80003958:	d62080e7          	jalr	-670(ra) # 800026b6 <bwrite>
    brelse(from);
    8000395c:	854e                	mv	a0,s3
    8000395e:	fffff097          	auipc	ra,0xfffff
    80003962:	d96080e7          	jalr	-618(ra) # 800026f4 <brelse>
    brelse(to);
    80003966:	8526                	mv	a0,s1
    80003968:	fffff097          	auipc	ra,0xfffff
    8000396c:	d8c080e7          	jalr	-628(ra) # 800026f4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003970:	2905                	addiw	s2,s2,1
    80003972:	0a91                	addi	s5,s5,4
    80003974:	034a2783          	lw	a5,52(s4)
    80003978:	f8f94ee3          	blt	s2,a5,80003914 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000397c:	00000097          	auipc	ra,0x0
    80003980:	c6a080e7          	jalr	-918(ra) # 800035e6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003984:	4501                	li	a0,0
    80003986:	00000097          	auipc	ra,0x0
    8000398a:	cda080e7          	jalr	-806(ra) # 80003660 <install_trans>
    log.lh.n = 0;
    8000398e:	00019797          	auipc	a5,0x19
    80003992:	4007a723          	sw	zero,1038(a5) # 8001cd9c <log+0x34>
    write_head();    // Erase the transaction from the log
    80003996:	00000097          	auipc	ra,0x0
    8000399a:	c50080e7          	jalr	-944(ra) # 800035e6 <write_head>
    8000399e:	bdf5                	j	8000389a <end_op+0x52>

00000000800039a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039a0:	1101                	addi	sp,sp,-32
    800039a2:	ec06                	sd	ra,24(sp)
    800039a4:	e822                	sd	s0,16(sp)
    800039a6:	e426                	sd	s1,8(sp)
    800039a8:	e04a                	sd	s2,0(sp)
    800039aa:	1000                	addi	s0,sp,32
    800039ac:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039ae:	00019917          	auipc	s2,0x19
    800039b2:	3ba90913          	addi	s2,s2,954 # 8001cd68 <log>
    800039b6:	854a                	mv	a0,s2
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	d68080e7          	jalr	-664(ra) # 80006720 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800039c0:	03492603          	lw	a2,52(s2)
    800039c4:	47f5                	li	a5,29
    800039c6:	06c7c563          	blt	a5,a2,80003a30 <log_write+0x90>
    800039ca:	00019797          	auipc	a5,0x19
    800039ce:	3c27a783          	lw	a5,962(a5) # 8001cd8c <log+0x24>
    800039d2:	37fd                	addiw	a5,a5,-1
    800039d4:	04f65e63          	bge	a2,a5,80003a30 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039d8:	00019797          	auipc	a5,0x19
    800039dc:	3b87a783          	lw	a5,952(a5) # 8001cd90 <log+0x28>
    800039e0:	06f05063          	blez	a5,80003a40 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039e4:	4781                	li	a5,0
    800039e6:	06c05563          	blez	a2,80003a50 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039ea:	44cc                	lw	a1,12(s1)
    800039ec:	00019717          	auipc	a4,0x19
    800039f0:	3b470713          	addi	a4,a4,948 # 8001cda0 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    800039f4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039f6:	4314                	lw	a3,0(a4)
    800039f8:	04b68c63          	beq	a3,a1,80003a50 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039fc:	2785                	addiw	a5,a5,1
    800039fe:	0711                	addi	a4,a4,4
    80003a00:	fef61be3          	bne	a2,a5,800039f6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a04:	0631                	addi	a2,a2,12
    80003a06:	060a                	slli	a2,a2,0x2
    80003a08:	00019797          	auipc	a5,0x19
    80003a0c:	36078793          	addi	a5,a5,864 # 8001cd68 <log>
    80003a10:	963e                	add	a2,a2,a5
    80003a12:	44dc                	lw	a5,12(s1)
    80003a14:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a16:	8526                	mv	a0,s1
    80003a18:	fffff097          	auipc	ra,0xfffff
    80003a1c:	d72080e7          	jalr	-654(ra) # 8000278a <bpin>
    log.lh.n++;
    80003a20:	00019717          	auipc	a4,0x19
    80003a24:	34870713          	addi	a4,a4,840 # 8001cd68 <log>
    80003a28:	5b5c                	lw	a5,52(a4)
    80003a2a:	2785                	addiw	a5,a5,1
    80003a2c:	db5c                	sw	a5,52(a4)
    80003a2e:	a835                	j	80003a6a <log_write+0xca>
    panic("too big a transaction");
    80003a30:	00005517          	auipc	a0,0x5
    80003a34:	ba050513          	addi	a0,a0,-1120 # 800085d0 <syscalls+0x208>
    80003a38:	00002097          	auipc	ra,0x2
    80003a3c:	7b4080e7          	jalr	1972(ra) # 800061ec <panic>
    panic("log_write outside of trans");
    80003a40:	00005517          	auipc	a0,0x5
    80003a44:	ba850513          	addi	a0,a0,-1112 # 800085e8 <syscalls+0x220>
    80003a48:	00002097          	auipc	ra,0x2
    80003a4c:	7a4080e7          	jalr	1956(ra) # 800061ec <panic>
  log.lh.block[i] = b->blockno;
    80003a50:	00c78713          	addi	a4,a5,12
    80003a54:	00271693          	slli	a3,a4,0x2
    80003a58:	00019717          	auipc	a4,0x19
    80003a5c:	31070713          	addi	a4,a4,784 # 8001cd68 <log>
    80003a60:	9736                	add	a4,a4,a3
    80003a62:	44d4                	lw	a3,12(s1)
    80003a64:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a66:	faf608e3          	beq	a2,a5,80003a16 <log_write+0x76>
  }
  release(&log.lock);
    80003a6a:	00019517          	auipc	a0,0x19
    80003a6e:	2fe50513          	addi	a0,a0,766 # 8001cd68 <log>
    80003a72:	00003097          	auipc	ra,0x3
    80003a76:	d7e080e7          	jalr	-642(ra) # 800067f0 <release>
}
    80003a7a:	60e2                	ld	ra,24(sp)
    80003a7c:	6442                	ld	s0,16(sp)
    80003a7e:	64a2                	ld	s1,8(sp)
    80003a80:	6902                	ld	s2,0(sp)
    80003a82:	6105                	addi	sp,sp,32
    80003a84:	8082                	ret

0000000080003a86 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a86:	1101                	addi	sp,sp,-32
    80003a88:	ec06                	sd	ra,24(sp)
    80003a8a:	e822                	sd	s0,16(sp)
    80003a8c:	e426                	sd	s1,8(sp)
    80003a8e:	e04a                	sd	s2,0(sp)
    80003a90:	1000                	addi	s0,sp,32
    80003a92:	84aa                	mv	s1,a0
    80003a94:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a96:	00005597          	auipc	a1,0x5
    80003a9a:	b7258593          	addi	a1,a1,-1166 # 80008608 <syscalls+0x240>
    80003a9e:	0521                	addi	a0,a0,8
    80003aa0:	00003097          	auipc	ra,0x3
    80003aa4:	dfc080e7          	jalr	-516(ra) # 8000689c <initlock>
  lk->name = name;
    80003aa8:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003aac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ab0:	0204a823          	sw	zero,48(s1)
}
    80003ab4:	60e2                	ld	ra,24(sp)
    80003ab6:	6442                	ld	s0,16(sp)
    80003ab8:	64a2                	ld	s1,8(sp)
    80003aba:	6902                	ld	s2,0(sp)
    80003abc:	6105                	addi	sp,sp,32
    80003abe:	8082                	ret

0000000080003ac0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003ac0:	1101                	addi	sp,sp,-32
    80003ac2:	ec06                	sd	ra,24(sp)
    80003ac4:	e822                	sd	s0,16(sp)
    80003ac6:	e426                	sd	s1,8(sp)
    80003ac8:	e04a                	sd	s2,0(sp)
    80003aca:	1000                	addi	s0,sp,32
    80003acc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ace:	00850913          	addi	s2,a0,8
    80003ad2:	854a                	mv	a0,s2
    80003ad4:	00003097          	auipc	ra,0x3
    80003ad8:	c4c080e7          	jalr	-948(ra) # 80006720 <acquire>
  while (lk->locked) {
    80003adc:	409c                	lw	a5,0(s1)
    80003ade:	cb89                	beqz	a5,80003af0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ae0:	85ca                	mv	a1,s2
    80003ae2:	8526                	mv	a0,s1
    80003ae4:	ffffe097          	auipc	ra,0xffffe
    80003ae8:	b3e080e7          	jalr	-1218(ra) # 80001622 <sleep>
  while (lk->locked) {
    80003aec:	409c                	lw	a5,0(s1)
    80003aee:	fbed                	bnez	a5,80003ae0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003af0:	4785                	li	a5,1
    80003af2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003af4:	ffffd097          	auipc	ra,0xffffd
    80003af8:	472080e7          	jalr	1138(ra) # 80000f66 <myproc>
    80003afc:	5d1c                	lw	a5,56(a0)
    80003afe:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003b00:	854a                	mv	a0,s2
    80003b02:	00003097          	auipc	ra,0x3
    80003b06:	cee080e7          	jalr	-786(ra) # 800067f0 <release>
}
    80003b0a:	60e2                	ld	ra,24(sp)
    80003b0c:	6442                	ld	s0,16(sp)
    80003b0e:	64a2                	ld	s1,8(sp)
    80003b10:	6902                	ld	s2,0(sp)
    80003b12:	6105                	addi	sp,sp,32
    80003b14:	8082                	ret

0000000080003b16 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b16:	1101                	addi	sp,sp,-32
    80003b18:	ec06                	sd	ra,24(sp)
    80003b1a:	e822                	sd	s0,16(sp)
    80003b1c:	e426                	sd	s1,8(sp)
    80003b1e:	e04a                	sd	s2,0(sp)
    80003b20:	1000                	addi	s0,sp,32
    80003b22:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b24:	00850913          	addi	s2,a0,8
    80003b28:	854a                	mv	a0,s2
    80003b2a:	00003097          	auipc	ra,0x3
    80003b2e:	bf6080e7          	jalr	-1034(ra) # 80006720 <acquire>
  lk->locked = 0;
    80003b32:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b36:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003b3a:	8526                	mv	a0,s1
    80003b3c:	ffffe097          	auipc	ra,0xffffe
    80003b40:	c72080e7          	jalr	-910(ra) # 800017ae <wakeup>
  release(&lk->lk);
    80003b44:	854a                	mv	a0,s2
    80003b46:	00003097          	auipc	ra,0x3
    80003b4a:	caa080e7          	jalr	-854(ra) # 800067f0 <release>
}
    80003b4e:	60e2                	ld	ra,24(sp)
    80003b50:	6442                	ld	s0,16(sp)
    80003b52:	64a2                	ld	s1,8(sp)
    80003b54:	6902                	ld	s2,0(sp)
    80003b56:	6105                	addi	sp,sp,32
    80003b58:	8082                	ret

0000000080003b5a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b5a:	7179                	addi	sp,sp,-48
    80003b5c:	f406                	sd	ra,40(sp)
    80003b5e:	f022                	sd	s0,32(sp)
    80003b60:	ec26                	sd	s1,24(sp)
    80003b62:	e84a                	sd	s2,16(sp)
    80003b64:	e44e                	sd	s3,8(sp)
    80003b66:	1800                	addi	s0,sp,48
    80003b68:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b6a:	00850913          	addi	s2,a0,8
    80003b6e:	854a                	mv	a0,s2
    80003b70:	00003097          	auipc	ra,0x3
    80003b74:	bb0080e7          	jalr	-1104(ra) # 80006720 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b78:	409c                	lw	a5,0(s1)
    80003b7a:	ef99                	bnez	a5,80003b98 <holdingsleep+0x3e>
    80003b7c:	4481                	li	s1,0
  release(&lk->lk);
    80003b7e:	854a                	mv	a0,s2
    80003b80:	00003097          	auipc	ra,0x3
    80003b84:	c70080e7          	jalr	-912(ra) # 800067f0 <release>
  return r;
}
    80003b88:	8526                	mv	a0,s1
    80003b8a:	70a2                	ld	ra,40(sp)
    80003b8c:	7402                	ld	s0,32(sp)
    80003b8e:	64e2                	ld	s1,24(sp)
    80003b90:	6942                	ld	s2,16(sp)
    80003b92:	69a2                	ld	s3,8(sp)
    80003b94:	6145                	addi	sp,sp,48
    80003b96:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b98:	0304a983          	lw	s3,48(s1)
    80003b9c:	ffffd097          	auipc	ra,0xffffd
    80003ba0:	3ca080e7          	jalr	970(ra) # 80000f66 <myproc>
    80003ba4:	5d04                	lw	s1,56(a0)
    80003ba6:	413484b3          	sub	s1,s1,s3
    80003baa:	0014b493          	seqz	s1,s1
    80003bae:	bfc1                	j	80003b7e <holdingsleep+0x24>

0000000080003bb0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bb0:	1141                	addi	sp,sp,-16
    80003bb2:	e406                	sd	ra,8(sp)
    80003bb4:	e022                	sd	s0,0(sp)
    80003bb6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bb8:	00005597          	auipc	a1,0x5
    80003bbc:	a6058593          	addi	a1,a1,-1440 # 80008618 <syscalls+0x250>
    80003bc0:	00019517          	auipc	a0,0x19
    80003bc4:	2f850513          	addi	a0,a0,760 # 8001ceb8 <ftable>
    80003bc8:	00003097          	auipc	ra,0x3
    80003bcc:	cd4080e7          	jalr	-812(ra) # 8000689c <initlock>
}
    80003bd0:	60a2                	ld	ra,8(sp)
    80003bd2:	6402                	ld	s0,0(sp)
    80003bd4:	0141                	addi	sp,sp,16
    80003bd6:	8082                	ret

0000000080003bd8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bd8:	1101                	addi	sp,sp,-32
    80003bda:	ec06                	sd	ra,24(sp)
    80003bdc:	e822                	sd	s0,16(sp)
    80003bde:	e426                	sd	s1,8(sp)
    80003be0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003be2:	00019517          	auipc	a0,0x19
    80003be6:	2d650513          	addi	a0,a0,726 # 8001ceb8 <ftable>
    80003bea:	00003097          	auipc	ra,0x3
    80003bee:	b36080e7          	jalr	-1226(ra) # 80006720 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bf2:	00019497          	auipc	s1,0x19
    80003bf6:	2e648493          	addi	s1,s1,742 # 8001ced8 <ftable+0x20>
    80003bfa:	0001a717          	auipc	a4,0x1a
    80003bfe:	27e70713          	addi	a4,a4,638 # 8001de78 <ftable+0xfc0>
    if(f->ref == 0){
    80003c02:	40dc                	lw	a5,4(s1)
    80003c04:	cf99                	beqz	a5,80003c22 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c06:	02848493          	addi	s1,s1,40
    80003c0a:	fee49ce3          	bne	s1,a4,80003c02 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c0e:	00019517          	auipc	a0,0x19
    80003c12:	2aa50513          	addi	a0,a0,682 # 8001ceb8 <ftable>
    80003c16:	00003097          	auipc	ra,0x3
    80003c1a:	bda080e7          	jalr	-1062(ra) # 800067f0 <release>
  return 0;
    80003c1e:	4481                	li	s1,0
    80003c20:	a819                	j	80003c36 <filealloc+0x5e>
      f->ref = 1;
    80003c22:	4785                	li	a5,1
    80003c24:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c26:	00019517          	auipc	a0,0x19
    80003c2a:	29250513          	addi	a0,a0,658 # 8001ceb8 <ftable>
    80003c2e:	00003097          	auipc	ra,0x3
    80003c32:	bc2080e7          	jalr	-1086(ra) # 800067f0 <release>
}
    80003c36:	8526                	mv	a0,s1
    80003c38:	60e2                	ld	ra,24(sp)
    80003c3a:	6442                	ld	s0,16(sp)
    80003c3c:	64a2                	ld	s1,8(sp)
    80003c3e:	6105                	addi	sp,sp,32
    80003c40:	8082                	ret

0000000080003c42 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c42:	1101                	addi	sp,sp,-32
    80003c44:	ec06                	sd	ra,24(sp)
    80003c46:	e822                	sd	s0,16(sp)
    80003c48:	e426                	sd	s1,8(sp)
    80003c4a:	1000                	addi	s0,sp,32
    80003c4c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c4e:	00019517          	auipc	a0,0x19
    80003c52:	26a50513          	addi	a0,a0,618 # 8001ceb8 <ftable>
    80003c56:	00003097          	auipc	ra,0x3
    80003c5a:	aca080e7          	jalr	-1334(ra) # 80006720 <acquire>
  if(f->ref < 1)
    80003c5e:	40dc                	lw	a5,4(s1)
    80003c60:	02f05263          	blez	a5,80003c84 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c64:	2785                	addiw	a5,a5,1
    80003c66:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c68:	00019517          	auipc	a0,0x19
    80003c6c:	25050513          	addi	a0,a0,592 # 8001ceb8 <ftable>
    80003c70:	00003097          	auipc	ra,0x3
    80003c74:	b80080e7          	jalr	-1152(ra) # 800067f0 <release>
  return f;
}
    80003c78:	8526                	mv	a0,s1
    80003c7a:	60e2                	ld	ra,24(sp)
    80003c7c:	6442                	ld	s0,16(sp)
    80003c7e:	64a2                	ld	s1,8(sp)
    80003c80:	6105                	addi	sp,sp,32
    80003c82:	8082                	ret
    panic("filedup");
    80003c84:	00005517          	auipc	a0,0x5
    80003c88:	99c50513          	addi	a0,a0,-1636 # 80008620 <syscalls+0x258>
    80003c8c:	00002097          	auipc	ra,0x2
    80003c90:	560080e7          	jalr	1376(ra) # 800061ec <panic>

0000000080003c94 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c94:	7139                	addi	sp,sp,-64
    80003c96:	fc06                	sd	ra,56(sp)
    80003c98:	f822                	sd	s0,48(sp)
    80003c9a:	f426                	sd	s1,40(sp)
    80003c9c:	f04a                	sd	s2,32(sp)
    80003c9e:	ec4e                	sd	s3,24(sp)
    80003ca0:	e852                	sd	s4,16(sp)
    80003ca2:	e456                	sd	s5,8(sp)
    80003ca4:	0080                	addi	s0,sp,64
    80003ca6:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ca8:	00019517          	auipc	a0,0x19
    80003cac:	21050513          	addi	a0,a0,528 # 8001ceb8 <ftable>
    80003cb0:	00003097          	auipc	ra,0x3
    80003cb4:	a70080e7          	jalr	-1424(ra) # 80006720 <acquire>
  if(f->ref < 1)
    80003cb8:	40dc                	lw	a5,4(s1)
    80003cba:	06f05163          	blez	a5,80003d1c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003cbe:	37fd                	addiw	a5,a5,-1
    80003cc0:	0007871b          	sext.w	a4,a5
    80003cc4:	c0dc                	sw	a5,4(s1)
    80003cc6:	06e04363          	bgtz	a4,80003d2c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003cca:	0004a903          	lw	s2,0(s1)
    80003cce:	0094ca83          	lbu	s5,9(s1)
    80003cd2:	0104ba03          	ld	s4,16(s1)
    80003cd6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cda:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cde:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ce2:	00019517          	auipc	a0,0x19
    80003ce6:	1d650513          	addi	a0,a0,470 # 8001ceb8 <ftable>
    80003cea:	00003097          	auipc	ra,0x3
    80003cee:	b06080e7          	jalr	-1274(ra) # 800067f0 <release>

  if(ff.type == FD_PIPE){
    80003cf2:	4785                	li	a5,1
    80003cf4:	04f90d63          	beq	s2,a5,80003d4e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003cf8:	3979                	addiw	s2,s2,-2
    80003cfa:	4785                	li	a5,1
    80003cfc:	0527e063          	bltu	a5,s2,80003d3c <fileclose+0xa8>
    begin_op();
    80003d00:	00000097          	auipc	ra,0x0
    80003d04:	ac8080e7          	jalr	-1336(ra) # 800037c8 <begin_op>
    iput(ff.ip);
    80003d08:	854e                	mv	a0,s3
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	2a6080e7          	jalr	678(ra) # 80002fb0 <iput>
    end_op();
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	b36080e7          	jalr	-1226(ra) # 80003848 <end_op>
    80003d1a:	a00d                	j	80003d3c <fileclose+0xa8>
    panic("fileclose");
    80003d1c:	00005517          	auipc	a0,0x5
    80003d20:	90c50513          	addi	a0,a0,-1780 # 80008628 <syscalls+0x260>
    80003d24:	00002097          	auipc	ra,0x2
    80003d28:	4c8080e7          	jalr	1224(ra) # 800061ec <panic>
    release(&ftable.lock);
    80003d2c:	00019517          	auipc	a0,0x19
    80003d30:	18c50513          	addi	a0,a0,396 # 8001ceb8 <ftable>
    80003d34:	00003097          	auipc	ra,0x3
    80003d38:	abc080e7          	jalr	-1348(ra) # 800067f0 <release>
  }
}
    80003d3c:	70e2                	ld	ra,56(sp)
    80003d3e:	7442                	ld	s0,48(sp)
    80003d40:	74a2                	ld	s1,40(sp)
    80003d42:	7902                	ld	s2,32(sp)
    80003d44:	69e2                	ld	s3,24(sp)
    80003d46:	6a42                	ld	s4,16(sp)
    80003d48:	6aa2                	ld	s5,8(sp)
    80003d4a:	6121                	addi	sp,sp,64
    80003d4c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d4e:	85d6                	mv	a1,s5
    80003d50:	8552                	mv	a0,s4
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	34c080e7          	jalr	844(ra) # 8000409e <pipeclose>
    80003d5a:	b7cd                	j	80003d3c <fileclose+0xa8>

0000000080003d5c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d5c:	715d                	addi	sp,sp,-80
    80003d5e:	e486                	sd	ra,72(sp)
    80003d60:	e0a2                	sd	s0,64(sp)
    80003d62:	fc26                	sd	s1,56(sp)
    80003d64:	f84a                	sd	s2,48(sp)
    80003d66:	f44e                	sd	s3,40(sp)
    80003d68:	0880                	addi	s0,sp,80
    80003d6a:	84aa                	mv	s1,a0
    80003d6c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d6e:	ffffd097          	auipc	ra,0xffffd
    80003d72:	1f8080e7          	jalr	504(ra) # 80000f66 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d76:	409c                	lw	a5,0(s1)
    80003d78:	37f9                	addiw	a5,a5,-2
    80003d7a:	4705                	li	a4,1
    80003d7c:	04f76763          	bltu	a4,a5,80003dca <filestat+0x6e>
    80003d80:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d82:	6c88                	ld	a0,24(s1)
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	072080e7          	jalr	114(ra) # 80002df6 <ilock>
    stati(f->ip, &st);
    80003d8c:	fb840593          	addi	a1,s0,-72
    80003d90:	6c88                	ld	a0,24(s1)
    80003d92:	fffff097          	auipc	ra,0xfffff
    80003d96:	2ee080e7          	jalr	750(ra) # 80003080 <stati>
    iunlock(f->ip);
    80003d9a:	6c88                	ld	a0,24(s1)
    80003d9c:	fffff097          	auipc	ra,0xfffff
    80003da0:	11c080e7          	jalr	284(ra) # 80002eb8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003da4:	46e1                	li	a3,24
    80003da6:	fb840613          	addi	a2,s0,-72
    80003daa:	85ce                	mv	a1,s3
    80003dac:	05893503          	ld	a0,88(s2)
    80003db0:	ffffd097          	auipc	ra,0xffffd
    80003db4:	e78080e7          	jalr	-392(ra) # 80000c28 <copyout>
    80003db8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003dbc:	60a6                	ld	ra,72(sp)
    80003dbe:	6406                	ld	s0,64(sp)
    80003dc0:	74e2                	ld	s1,56(sp)
    80003dc2:	7942                	ld	s2,48(sp)
    80003dc4:	79a2                	ld	s3,40(sp)
    80003dc6:	6161                	addi	sp,sp,80
    80003dc8:	8082                	ret
  return -1;
    80003dca:	557d                	li	a0,-1
    80003dcc:	bfc5                	j	80003dbc <filestat+0x60>

0000000080003dce <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003dce:	7179                	addi	sp,sp,-48
    80003dd0:	f406                	sd	ra,40(sp)
    80003dd2:	f022                	sd	s0,32(sp)
    80003dd4:	ec26                	sd	s1,24(sp)
    80003dd6:	e84a                	sd	s2,16(sp)
    80003dd8:	e44e                	sd	s3,8(sp)
    80003dda:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003ddc:	00854783          	lbu	a5,8(a0)
    80003de0:	c3d5                	beqz	a5,80003e84 <fileread+0xb6>
    80003de2:	84aa                	mv	s1,a0
    80003de4:	89ae                	mv	s3,a1
    80003de6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de8:	411c                	lw	a5,0(a0)
    80003dea:	4705                	li	a4,1
    80003dec:	04e78963          	beq	a5,a4,80003e3e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003df0:	470d                	li	a4,3
    80003df2:	04e78d63          	beq	a5,a4,80003e4c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df6:	4709                	li	a4,2
    80003df8:	06e79e63          	bne	a5,a4,80003e74 <fileread+0xa6>
    ilock(f->ip);
    80003dfc:	6d08                	ld	a0,24(a0)
    80003dfe:	fffff097          	auipc	ra,0xfffff
    80003e02:	ff8080e7          	jalr	-8(ra) # 80002df6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e06:	874a                	mv	a4,s2
    80003e08:	5094                	lw	a3,32(s1)
    80003e0a:	864e                	mv	a2,s3
    80003e0c:	4585                	li	a1,1
    80003e0e:	6c88                	ld	a0,24(s1)
    80003e10:	fffff097          	auipc	ra,0xfffff
    80003e14:	29a080e7          	jalr	666(ra) # 800030aa <readi>
    80003e18:	892a                	mv	s2,a0
    80003e1a:	00a05563          	blez	a0,80003e24 <fileread+0x56>
      f->off += r;
    80003e1e:	509c                	lw	a5,32(s1)
    80003e20:	9fa9                	addw	a5,a5,a0
    80003e22:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e24:	6c88                	ld	a0,24(s1)
    80003e26:	fffff097          	auipc	ra,0xfffff
    80003e2a:	092080e7          	jalr	146(ra) # 80002eb8 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e2e:	854a                	mv	a0,s2
    80003e30:	70a2                	ld	ra,40(sp)
    80003e32:	7402                	ld	s0,32(sp)
    80003e34:	64e2                	ld	s1,24(sp)
    80003e36:	6942                	ld	s2,16(sp)
    80003e38:	69a2                	ld	s3,8(sp)
    80003e3a:	6145                	addi	sp,sp,48
    80003e3c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e3e:	6908                	ld	a0,16(a0)
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	3d2080e7          	jalr	978(ra) # 80004212 <piperead>
    80003e48:	892a                	mv	s2,a0
    80003e4a:	b7d5                	j	80003e2e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e4c:	02451783          	lh	a5,36(a0)
    80003e50:	03079693          	slli	a3,a5,0x30
    80003e54:	92c1                	srli	a3,a3,0x30
    80003e56:	4725                	li	a4,9
    80003e58:	02d76863          	bltu	a4,a3,80003e88 <fileread+0xba>
    80003e5c:	0792                	slli	a5,a5,0x4
    80003e5e:	00019717          	auipc	a4,0x19
    80003e62:	fba70713          	addi	a4,a4,-70 # 8001ce18 <devsw>
    80003e66:	97ba                	add	a5,a5,a4
    80003e68:	639c                	ld	a5,0(a5)
    80003e6a:	c38d                	beqz	a5,80003e8c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e6c:	4505                	li	a0,1
    80003e6e:	9782                	jalr	a5
    80003e70:	892a                	mv	s2,a0
    80003e72:	bf75                	j	80003e2e <fileread+0x60>
    panic("fileread");
    80003e74:	00004517          	auipc	a0,0x4
    80003e78:	7c450513          	addi	a0,a0,1988 # 80008638 <syscalls+0x270>
    80003e7c:	00002097          	auipc	ra,0x2
    80003e80:	370080e7          	jalr	880(ra) # 800061ec <panic>
    return -1;
    80003e84:	597d                	li	s2,-1
    80003e86:	b765                	j	80003e2e <fileread+0x60>
      return -1;
    80003e88:	597d                	li	s2,-1
    80003e8a:	b755                	j	80003e2e <fileread+0x60>
    80003e8c:	597d                	li	s2,-1
    80003e8e:	b745                	j	80003e2e <fileread+0x60>

0000000080003e90 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e90:	715d                	addi	sp,sp,-80
    80003e92:	e486                	sd	ra,72(sp)
    80003e94:	e0a2                	sd	s0,64(sp)
    80003e96:	fc26                	sd	s1,56(sp)
    80003e98:	f84a                	sd	s2,48(sp)
    80003e9a:	f44e                	sd	s3,40(sp)
    80003e9c:	f052                	sd	s4,32(sp)
    80003e9e:	ec56                	sd	s5,24(sp)
    80003ea0:	e85a                	sd	s6,16(sp)
    80003ea2:	e45e                	sd	s7,8(sp)
    80003ea4:	e062                	sd	s8,0(sp)
    80003ea6:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003ea8:	00954783          	lbu	a5,9(a0)
    80003eac:	10078663          	beqz	a5,80003fb8 <filewrite+0x128>
    80003eb0:	892a                	mv	s2,a0
    80003eb2:	8aae                	mv	s5,a1
    80003eb4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003eb6:	411c                	lw	a5,0(a0)
    80003eb8:	4705                	li	a4,1
    80003eba:	02e78263          	beq	a5,a4,80003ede <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ebe:	470d                	li	a4,3
    80003ec0:	02e78663          	beq	a5,a4,80003eec <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ec4:	4709                	li	a4,2
    80003ec6:	0ee79163          	bne	a5,a4,80003fa8 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003eca:	0ac05d63          	blez	a2,80003f84 <filewrite+0xf4>
    int i = 0;
    80003ece:	4981                	li	s3,0
    80003ed0:	6b05                	lui	s6,0x1
    80003ed2:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003ed6:	6b85                	lui	s7,0x1
    80003ed8:	c00b8b9b          	addiw	s7,s7,-1024
    80003edc:	a861                	j	80003f74 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ede:	6908                	ld	a0,16(a0)
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	238080e7          	jalr	568(ra) # 80004118 <pipewrite>
    80003ee8:	8a2a                	mv	s4,a0
    80003eea:	a045                	j	80003f8a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003eec:	02451783          	lh	a5,36(a0)
    80003ef0:	03079693          	slli	a3,a5,0x30
    80003ef4:	92c1                	srli	a3,a3,0x30
    80003ef6:	4725                	li	a4,9
    80003ef8:	0cd76263          	bltu	a4,a3,80003fbc <filewrite+0x12c>
    80003efc:	0792                	slli	a5,a5,0x4
    80003efe:	00019717          	auipc	a4,0x19
    80003f02:	f1a70713          	addi	a4,a4,-230 # 8001ce18 <devsw>
    80003f06:	97ba                	add	a5,a5,a4
    80003f08:	679c                	ld	a5,8(a5)
    80003f0a:	cbdd                	beqz	a5,80003fc0 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f0c:	4505                	li	a0,1
    80003f0e:	9782                	jalr	a5
    80003f10:	8a2a                	mv	s4,a0
    80003f12:	a8a5                	j	80003f8a <filewrite+0xfa>
    80003f14:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	8b0080e7          	jalr	-1872(ra) # 800037c8 <begin_op>
      ilock(f->ip);
    80003f20:	01893503          	ld	a0,24(s2)
    80003f24:	fffff097          	auipc	ra,0xfffff
    80003f28:	ed2080e7          	jalr	-302(ra) # 80002df6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f2c:	8762                	mv	a4,s8
    80003f2e:	02092683          	lw	a3,32(s2)
    80003f32:	01598633          	add	a2,s3,s5
    80003f36:	4585                	li	a1,1
    80003f38:	01893503          	ld	a0,24(s2)
    80003f3c:	fffff097          	auipc	ra,0xfffff
    80003f40:	266080e7          	jalr	614(ra) # 800031a2 <writei>
    80003f44:	84aa                	mv	s1,a0
    80003f46:	00a05763          	blez	a0,80003f54 <filewrite+0xc4>
        f->off += r;
    80003f4a:	02092783          	lw	a5,32(s2)
    80003f4e:	9fa9                	addw	a5,a5,a0
    80003f50:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f54:	01893503          	ld	a0,24(s2)
    80003f58:	fffff097          	auipc	ra,0xfffff
    80003f5c:	f60080e7          	jalr	-160(ra) # 80002eb8 <iunlock>
      end_op();
    80003f60:	00000097          	auipc	ra,0x0
    80003f64:	8e8080e7          	jalr	-1816(ra) # 80003848 <end_op>

      if(r != n1){
    80003f68:	009c1f63          	bne	s8,s1,80003f86 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f6c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f70:	0149db63          	bge	s3,s4,80003f86 <filewrite+0xf6>
      int n1 = n - i;
    80003f74:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f78:	84be                	mv	s1,a5
    80003f7a:	2781                	sext.w	a5,a5
    80003f7c:	f8fb5ce3          	bge	s6,a5,80003f14 <filewrite+0x84>
    80003f80:	84de                	mv	s1,s7
    80003f82:	bf49                	j	80003f14 <filewrite+0x84>
    int i = 0;
    80003f84:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f86:	013a1f63          	bne	s4,s3,80003fa4 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f8a:	8552                	mv	a0,s4
    80003f8c:	60a6                	ld	ra,72(sp)
    80003f8e:	6406                	ld	s0,64(sp)
    80003f90:	74e2                	ld	s1,56(sp)
    80003f92:	7942                	ld	s2,48(sp)
    80003f94:	79a2                	ld	s3,40(sp)
    80003f96:	7a02                	ld	s4,32(sp)
    80003f98:	6ae2                	ld	s5,24(sp)
    80003f9a:	6b42                	ld	s6,16(sp)
    80003f9c:	6ba2                	ld	s7,8(sp)
    80003f9e:	6c02                	ld	s8,0(sp)
    80003fa0:	6161                	addi	sp,sp,80
    80003fa2:	8082                	ret
    ret = (i == n ? n : -1);
    80003fa4:	5a7d                	li	s4,-1
    80003fa6:	b7d5                	j	80003f8a <filewrite+0xfa>
    panic("filewrite");
    80003fa8:	00004517          	auipc	a0,0x4
    80003fac:	6a050513          	addi	a0,a0,1696 # 80008648 <syscalls+0x280>
    80003fb0:	00002097          	auipc	ra,0x2
    80003fb4:	23c080e7          	jalr	572(ra) # 800061ec <panic>
    return -1;
    80003fb8:	5a7d                	li	s4,-1
    80003fba:	bfc1                	j	80003f8a <filewrite+0xfa>
      return -1;
    80003fbc:	5a7d                	li	s4,-1
    80003fbe:	b7f1                	j	80003f8a <filewrite+0xfa>
    80003fc0:	5a7d                	li	s4,-1
    80003fc2:	b7e1                	j	80003f8a <filewrite+0xfa>

0000000080003fc4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fc4:	7179                	addi	sp,sp,-48
    80003fc6:	f406                	sd	ra,40(sp)
    80003fc8:	f022                	sd	s0,32(sp)
    80003fca:	ec26                	sd	s1,24(sp)
    80003fcc:	e84a                	sd	s2,16(sp)
    80003fce:	e44e                	sd	s3,8(sp)
    80003fd0:	e052                	sd	s4,0(sp)
    80003fd2:	1800                	addi	s0,sp,48
    80003fd4:	84aa                	mv	s1,a0
    80003fd6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fd8:	0005b023          	sd	zero,0(a1)
    80003fdc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fe0:	00000097          	auipc	ra,0x0
    80003fe4:	bf8080e7          	jalr	-1032(ra) # 80003bd8 <filealloc>
    80003fe8:	e088                	sd	a0,0(s1)
    80003fea:	c551                	beqz	a0,80004076 <pipealloc+0xb2>
    80003fec:	00000097          	auipc	ra,0x0
    80003ff0:	bec080e7          	jalr	-1044(ra) # 80003bd8 <filealloc>
    80003ff4:	00aa3023          	sd	a0,0(s4)
    80003ff8:	c92d                	beqz	a0,8000406a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ffa:	ffffc097          	auipc	ra,0xffffc
    80003ffe:	186080e7          	jalr	390(ra) # 80000180 <kalloc>
    80004002:	892a                	mv	s2,a0
    80004004:	c125                	beqz	a0,80004064 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004006:	4985                	li	s3,1
    80004008:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    8000400c:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004010:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004014:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80004018:	00004597          	auipc	a1,0x4
    8000401c:	64058593          	addi	a1,a1,1600 # 80008658 <syscalls+0x290>
    80004020:	00003097          	auipc	ra,0x3
    80004024:	87c080e7          	jalr	-1924(ra) # 8000689c <initlock>
  (*f0)->type = FD_PIPE;
    80004028:	609c                	ld	a5,0(s1)
    8000402a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000402e:	609c                	ld	a5,0(s1)
    80004030:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004034:	609c                	ld	a5,0(s1)
    80004036:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000403a:	609c                	ld	a5,0(s1)
    8000403c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004040:	000a3783          	ld	a5,0(s4)
    80004044:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004048:	000a3783          	ld	a5,0(s4)
    8000404c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004050:	000a3783          	ld	a5,0(s4)
    80004054:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004058:	000a3783          	ld	a5,0(s4)
    8000405c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004060:	4501                	li	a0,0
    80004062:	a025                	j	8000408a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004064:	6088                	ld	a0,0(s1)
    80004066:	e501                	bnez	a0,8000406e <pipealloc+0xaa>
    80004068:	a039                	j	80004076 <pipealloc+0xb2>
    8000406a:	6088                	ld	a0,0(s1)
    8000406c:	c51d                	beqz	a0,8000409a <pipealloc+0xd6>
    fileclose(*f0);
    8000406e:	00000097          	auipc	ra,0x0
    80004072:	c26080e7          	jalr	-986(ra) # 80003c94 <fileclose>
  if(*f1)
    80004076:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000407a:	557d                	li	a0,-1
  if(*f1)
    8000407c:	c799                	beqz	a5,8000408a <pipealloc+0xc6>
    fileclose(*f1);
    8000407e:	853e                	mv	a0,a5
    80004080:	00000097          	auipc	ra,0x0
    80004084:	c14080e7          	jalr	-1004(ra) # 80003c94 <fileclose>
  return -1;
    80004088:	557d                	li	a0,-1
}
    8000408a:	70a2                	ld	ra,40(sp)
    8000408c:	7402                	ld	s0,32(sp)
    8000408e:	64e2                	ld	s1,24(sp)
    80004090:	6942                	ld	s2,16(sp)
    80004092:	69a2                	ld	s3,8(sp)
    80004094:	6a02                	ld	s4,0(sp)
    80004096:	6145                	addi	sp,sp,48
    80004098:	8082                	ret
  return -1;
    8000409a:	557d                	li	a0,-1
    8000409c:	b7fd                	j	8000408a <pipealloc+0xc6>

000000008000409e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000409e:	1101                	addi	sp,sp,-32
    800040a0:	ec06                	sd	ra,24(sp)
    800040a2:	e822                	sd	s0,16(sp)
    800040a4:	e426                	sd	s1,8(sp)
    800040a6:	e04a                	sd	s2,0(sp)
    800040a8:	1000                	addi	s0,sp,32
    800040aa:	84aa                	mv	s1,a0
    800040ac:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040ae:	00002097          	auipc	ra,0x2
    800040b2:	672080e7          	jalr	1650(ra) # 80006720 <acquire>
  if(writable){
    800040b6:	04090263          	beqz	s2,800040fa <pipeclose+0x5c>
    pi->writeopen = 0;
    800040ba:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    800040be:	22048513          	addi	a0,s1,544
    800040c2:	ffffd097          	auipc	ra,0xffffd
    800040c6:	6ec080e7          	jalr	1772(ra) # 800017ae <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040ca:	2284b783          	ld	a5,552(s1)
    800040ce:	ef9d                	bnez	a5,8000410c <pipeclose+0x6e>
    release(&pi->lock);
    800040d0:	8526                	mv	a0,s1
    800040d2:	00002097          	auipc	ra,0x2
    800040d6:	71e080e7          	jalr	1822(ra) # 800067f0 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    800040da:	8526                	mv	a0,s1
    800040dc:	00002097          	auipc	ra,0x2
    800040e0:	75c080e7          	jalr	1884(ra) # 80006838 <freelock>
#endif    
    kfree((char*)pi);
    800040e4:	8526                	mv	a0,s1
    800040e6:	ffffc097          	auipc	ra,0xffffc
    800040ea:	f36080e7          	jalr	-202(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040ee:	60e2                	ld	ra,24(sp)
    800040f0:	6442                	ld	s0,16(sp)
    800040f2:	64a2                	ld	s1,8(sp)
    800040f4:	6902                	ld	s2,0(sp)
    800040f6:	6105                	addi	sp,sp,32
    800040f8:	8082                	ret
    pi->readopen = 0;
    800040fa:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    800040fe:	22448513          	addi	a0,s1,548
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	6ac080e7          	jalr	1708(ra) # 800017ae <wakeup>
    8000410a:	b7c1                	j	800040ca <pipeclose+0x2c>
    release(&pi->lock);
    8000410c:	8526                	mv	a0,s1
    8000410e:	00002097          	auipc	ra,0x2
    80004112:	6e2080e7          	jalr	1762(ra) # 800067f0 <release>
}
    80004116:	bfe1                	j	800040ee <pipeclose+0x50>

0000000080004118 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004118:	7159                	addi	sp,sp,-112
    8000411a:	f486                	sd	ra,104(sp)
    8000411c:	f0a2                	sd	s0,96(sp)
    8000411e:	eca6                	sd	s1,88(sp)
    80004120:	e8ca                	sd	s2,80(sp)
    80004122:	e4ce                	sd	s3,72(sp)
    80004124:	e0d2                	sd	s4,64(sp)
    80004126:	fc56                	sd	s5,56(sp)
    80004128:	f85a                	sd	s6,48(sp)
    8000412a:	f45e                	sd	s7,40(sp)
    8000412c:	f062                	sd	s8,32(sp)
    8000412e:	ec66                	sd	s9,24(sp)
    80004130:	1880                	addi	s0,sp,112
    80004132:	84aa                	mv	s1,a0
    80004134:	8aae                	mv	s5,a1
    80004136:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	e2e080e7          	jalr	-466(ra) # 80000f66 <myproc>
    80004140:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004142:	8526                	mv	a0,s1
    80004144:	00002097          	auipc	ra,0x2
    80004148:	5dc080e7          	jalr	1500(ra) # 80006720 <acquire>
  while(i < n){
    8000414c:	0d405163          	blez	s4,8000420e <pipewrite+0xf6>
    80004150:	8ba6                	mv	s7,s1
  int i = 0;
    80004152:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004154:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004156:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    8000415a:	22448c13          	addi	s8,s1,548
    8000415e:	a08d                	j	800041c0 <pipewrite+0xa8>
      release(&pi->lock);
    80004160:	8526                	mv	a0,s1
    80004162:	00002097          	auipc	ra,0x2
    80004166:	68e080e7          	jalr	1678(ra) # 800067f0 <release>
      return -1;
    8000416a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000416c:	854a                	mv	a0,s2
    8000416e:	70a6                	ld	ra,104(sp)
    80004170:	7406                	ld	s0,96(sp)
    80004172:	64e6                	ld	s1,88(sp)
    80004174:	6946                	ld	s2,80(sp)
    80004176:	69a6                	ld	s3,72(sp)
    80004178:	6a06                	ld	s4,64(sp)
    8000417a:	7ae2                	ld	s5,56(sp)
    8000417c:	7b42                	ld	s6,48(sp)
    8000417e:	7ba2                	ld	s7,40(sp)
    80004180:	7c02                	ld	s8,32(sp)
    80004182:	6ce2                	ld	s9,24(sp)
    80004184:	6165                	addi	sp,sp,112
    80004186:	8082                	ret
      wakeup(&pi->nread);
    80004188:	8566                	mv	a0,s9
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	624080e7          	jalr	1572(ra) # 800017ae <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004192:	85de                	mv	a1,s7
    80004194:	8562                	mv	a0,s8
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	48c080e7          	jalr	1164(ra) # 80001622 <sleep>
    8000419e:	a839                	j	800041bc <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041a0:	2244a783          	lw	a5,548(s1)
    800041a4:	0017871b          	addiw	a4,a5,1
    800041a8:	22e4a223          	sw	a4,548(s1)
    800041ac:	1ff7f793          	andi	a5,a5,511
    800041b0:	97a6                	add	a5,a5,s1
    800041b2:	f9f44703          	lbu	a4,-97(s0)
    800041b6:	02e78023          	sb	a4,32(a5)
      i++;
    800041ba:	2905                	addiw	s2,s2,1
  while(i < n){
    800041bc:	03495d63          	bge	s2,s4,800041f6 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800041c0:	2284a783          	lw	a5,552(s1)
    800041c4:	dfd1                	beqz	a5,80004160 <pipewrite+0x48>
    800041c6:	0309a783          	lw	a5,48(s3)
    800041ca:	fbd9                	bnez	a5,80004160 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041cc:	2204a783          	lw	a5,544(s1)
    800041d0:	2244a703          	lw	a4,548(s1)
    800041d4:	2007879b          	addiw	a5,a5,512
    800041d8:	faf708e3          	beq	a4,a5,80004188 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041dc:	4685                	li	a3,1
    800041de:	01590633          	add	a2,s2,s5
    800041e2:	f9f40593          	addi	a1,s0,-97
    800041e6:	0589b503          	ld	a0,88(s3)
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	aca080e7          	jalr	-1334(ra) # 80000cb4 <copyin>
    800041f2:	fb6517e3          	bne	a0,s6,800041a0 <pipewrite+0x88>
  wakeup(&pi->nread);
    800041f6:	22048513          	addi	a0,s1,544
    800041fa:	ffffd097          	auipc	ra,0xffffd
    800041fe:	5b4080e7          	jalr	1460(ra) # 800017ae <wakeup>
  release(&pi->lock);
    80004202:	8526                	mv	a0,s1
    80004204:	00002097          	auipc	ra,0x2
    80004208:	5ec080e7          	jalr	1516(ra) # 800067f0 <release>
  return i;
    8000420c:	b785                	j	8000416c <pipewrite+0x54>
  int i = 0;
    8000420e:	4901                	li	s2,0
    80004210:	b7dd                	j	800041f6 <pipewrite+0xde>

0000000080004212 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004212:	715d                	addi	sp,sp,-80
    80004214:	e486                	sd	ra,72(sp)
    80004216:	e0a2                	sd	s0,64(sp)
    80004218:	fc26                	sd	s1,56(sp)
    8000421a:	f84a                	sd	s2,48(sp)
    8000421c:	f44e                	sd	s3,40(sp)
    8000421e:	f052                	sd	s4,32(sp)
    80004220:	ec56                	sd	s5,24(sp)
    80004222:	e85a                	sd	s6,16(sp)
    80004224:	0880                	addi	s0,sp,80
    80004226:	84aa                	mv	s1,a0
    80004228:	892e                	mv	s2,a1
    8000422a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	d3a080e7          	jalr	-710(ra) # 80000f66 <myproc>
    80004234:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004236:	8b26                	mv	s6,s1
    80004238:	8526                	mv	a0,s1
    8000423a:	00002097          	auipc	ra,0x2
    8000423e:	4e6080e7          	jalr	1254(ra) # 80006720 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004242:	2204a703          	lw	a4,544(s1)
    80004246:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000424a:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000424e:	02f71463          	bne	a4,a5,80004276 <piperead+0x64>
    80004252:	22c4a783          	lw	a5,556(s1)
    80004256:	c385                	beqz	a5,80004276 <piperead+0x64>
    if(pr->killed){
    80004258:	030a2783          	lw	a5,48(s4)
    8000425c:	ebc1                	bnez	a5,800042ec <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000425e:	85da                	mv	a1,s6
    80004260:	854e                	mv	a0,s3
    80004262:	ffffd097          	auipc	ra,0xffffd
    80004266:	3c0080e7          	jalr	960(ra) # 80001622 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000426a:	2204a703          	lw	a4,544(s1)
    8000426e:	2244a783          	lw	a5,548(s1)
    80004272:	fef700e3          	beq	a4,a5,80004252 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004276:	09505263          	blez	s5,800042fa <piperead+0xe8>
    8000427a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000427c:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000427e:	2204a783          	lw	a5,544(s1)
    80004282:	2244a703          	lw	a4,548(s1)
    80004286:	02f70d63          	beq	a4,a5,800042c0 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000428a:	0017871b          	addiw	a4,a5,1
    8000428e:	22e4a023          	sw	a4,544(s1)
    80004292:	1ff7f793          	andi	a5,a5,511
    80004296:	97a6                	add	a5,a5,s1
    80004298:	0207c783          	lbu	a5,32(a5)
    8000429c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042a0:	4685                	li	a3,1
    800042a2:	fbf40613          	addi	a2,s0,-65
    800042a6:	85ca                	mv	a1,s2
    800042a8:	058a3503          	ld	a0,88(s4)
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	97c080e7          	jalr	-1668(ra) # 80000c28 <copyout>
    800042b4:	01650663          	beq	a0,s6,800042c0 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042b8:	2985                	addiw	s3,s3,1
    800042ba:	0905                	addi	s2,s2,1
    800042bc:	fd3a91e3          	bne	s5,s3,8000427e <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042c0:	22448513          	addi	a0,s1,548
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	4ea080e7          	jalr	1258(ra) # 800017ae <wakeup>
  release(&pi->lock);
    800042cc:	8526                	mv	a0,s1
    800042ce:	00002097          	auipc	ra,0x2
    800042d2:	522080e7          	jalr	1314(ra) # 800067f0 <release>
  return i;
}
    800042d6:	854e                	mv	a0,s3
    800042d8:	60a6                	ld	ra,72(sp)
    800042da:	6406                	ld	s0,64(sp)
    800042dc:	74e2                	ld	s1,56(sp)
    800042de:	7942                	ld	s2,48(sp)
    800042e0:	79a2                	ld	s3,40(sp)
    800042e2:	7a02                	ld	s4,32(sp)
    800042e4:	6ae2                	ld	s5,24(sp)
    800042e6:	6b42                	ld	s6,16(sp)
    800042e8:	6161                	addi	sp,sp,80
    800042ea:	8082                	ret
      release(&pi->lock);
    800042ec:	8526                	mv	a0,s1
    800042ee:	00002097          	auipc	ra,0x2
    800042f2:	502080e7          	jalr	1282(ra) # 800067f0 <release>
      return -1;
    800042f6:	59fd                	li	s3,-1
    800042f8:	bff9                	j	800042d6 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042fa:	4981                	li	s3,0
    800042fc:	b7d1                	j	800042c0 <piperead+0xae>

00000000800042fe <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042fe:	df010113          	addi	sp,sp,-528
    80004302:	20113423          	sd	ra,520(sp)
    80004306:	20813023          	sd	s0,512(sp)
    8000430a:	ffa6                	sd	s1,504(sp)
    8000430c:	fbca                	sd	s2,496(sp)
    8000430e:	f7ce                	sd	s3,488(sp)
    80004310:	f3d2                	sd	s4,480(sp)
    80004312:	efd6                	sd	s5,472(sp)
    80004314:	ebda                	sd	s6,464(sp)
    80004316:	e7de                	sd	s7,456(sp)
    80004318:	e3e2                	sd	s8,448(sp)
    8000431a:	ff66                	sd	s9,440(sp)
    8000431c:	fb6a                	sd	s10,432(sp)
    8000431e:	f76e                	sd	s11,424(sp)
    80004320:	0c00                	addi	s0,sp,528
    80004322:	84aa                	mv	s1,a0
    80004324:	dea43c23          	sd	a0,-520(s0)
    80004328:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	c3a080e7          	jalr	-966(ra) # 80000f66 <myproc>
    80004334:	892a                	mv	s2,a0

  begin_op();
    80004336:	fffff097          	auipc	ra,0xfffff
    8000433a:	492080e7          	jalr	1170(ra) # 800037c8 <begin_op>

  if((ip = namei(path)) == 0){
    8000433e:	8526                	mv	a0,s1
    80004340:	fffff097          	auipc	ra,0xfffff
    80004344:	26c080e7          	jalr	620(ra) # 800035ac <namei>
    80004348:	c92d                	beqz	a0,800043ba <exec+0xbc>
    8000434a:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000434c:	fffff097          	auipc	ra,0xfffff
    80004350:	aaa080e7          	jalr	-1366(ra) # 80002df6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004354:	04000713          	li	a4,64
    80004358:	4681                	li	a3,0
    8000435a:	e5040613          	addi	a2,s0,-432
    8000435e:	4581                	li	a1,0
    80004360:	8526                	mv	a0,s1
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	d48080e7          	jalr	-696(ra) # 800030aa <readi>
    8000436a:	04000793          	li	a5,64
    8000436e:	00f51a63          	bne	a0,a5,80004382 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004372:	e5042703          	lw	a4,-432(s0)
    80004376:	464c47b7          	lui	a5,0x464c4
    8000437a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000437e:	04f70463          	beq	a4,a5,800043c6 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004382:	8526                	mv	a0,s1
    80004384:	fffff097          	auipc	ra,0xfffff
    80004388:	cd4080e7          	jalr	-812(ra) # 80003058 <iunlockput>
    end_op();
    8000438c:	fffff097          	auipc	ra,0xfffff
    80004390:	4bc080e7          	jalr	1212(ra) # 80003848 <end_op>
  }
  return -1;
    80004394:	557d                	li	a0,-1
}
    80004396:	20813083          	ld	ra,520(sp)
    8000439a:	20013403          	ld	s0,512(sp)
    8000439e:	74fe                	ld	s1,504(sp)
    800043a0:	795e                	ld	s2,496(sp)
    800043a2:	79be                	ld	s3,488(sp)
    800043a4:	7a1e                	ld	s4,480(sp)
    800043a6:	6afe                	ld	s5,472(sp)
    800043a8:	6b5e                	ld	s6,464(sp)
    800043aa:	6bbe                	ld	s7,456(sp)
    800043ac:	6c1e                	ld	s8,448(sp)
    800043ae:	7cfa                	ld	s9,440(sp)
    800043b0:	7d5a                	ld	s10,432(sp)
    800043b2:	7dba                	ld	s11,424(sp)
    800043b4:	21010113          	addi	sp,sp,528
    800043b8:	8082                	ret
    end_op();
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	48e080e7          	jalr	1166(ra) # 80003848 <end_op>
    return -1;
    800043c2:	557d                	li	a0,-1
    800043c4:	bfc9                	j	80004396 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800043c6:	854a                	mv	a0,s2
    800043c8:	ffffd097          	auipc	ra,0xffffd
    800043cc:	c62080e7          	jalr	-926(ra) # 8000102a <proc_pagetable>
    800043d0:	8baa                	mv	s7,a0
    800043d2:	d945                	beqz	a0,80004382 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043d4:	e7042983          	lw	s3,-400(s0)
    800043d8:	e8845783          	lhu	a5,-376(s0)
    800043dc:	c7ad                	beqz	a5,80004446 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043de:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e0:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800043e2:	6c85                	lui	s9,0x1
    800043e4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043e8:	def43823          	sd	a5,-528(s0)
    800043ec:	a42d                	j	80004616 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043ee:	00004517          	auipc	a0,0x4
    800043f2:	27250513          	addi	a0,a0,626 # 80008660 <syscalls+0x298>
    800043f6:	00002097          	auipc	ra,0x2
    800043fa:	df6080e7          	jalr	-522(ra) # 800061ec <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043fe:	8756                	mv	a4,s5
    80004400:	012d86bb          	addw	a3,s11,s2
    80004404:	4581                	li	a1,0
    80004406:	8526                	mv	a0,s1
    80004408:	fffff097          	auipc	ra,0xfffff
    8000440c:	ca2080e7          	jalr	-862(ra) # 800030aa <readi>
    80004410:	2501                	sext.w	a0,a0
    80004412:	1aaa9963          	bne	s5,a0,800045c4 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004416:	6785                	lui	a5,0x1
    80004418:	0127893b          	addw	s2,a5,s2
    8000441c:	77fd                	lui	a5,0xfffff
    8000441e:	01478a3b          	addw	s4,a5,s4
    80004422:	1f897163          	bgeu	s2,s8,80004604 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004426:	02091593          	slli	a1,s2,0x20
    8000442a:	9181                	srli	a1,a1,0x20
    8000442c:	95ea                	add	a1,a1,s10
    8000442e:	855e                	mv	a0,s7
    80004430:	ffffc097          	auipc	ra,0xffffc
    80004434:	1f4080e7          	jalr	500(ra) # 80000624 <walkaddr>
    80004438:	862a                	mv	a2,a0
    if(pa == 0)
    8000443a:	d955                	beqz	a0,800043ee <exec+0xf0>
      n = PGSIZE;
    8000443c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000443e:	fd9a70e3          	bgeu	s4,s9,800043fe <exec+0x100>
      n = sz - i;
    80004442:	8ad2                	mv	s5,s4
    80004444:	bf6d                	j	800043fe <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004446:	4901                	li	s2,0
  iunlockput(ip);
    80004448:	8526                	mv	a0,s1
    8000444a:	fffff097          	auipc	ra,0xfffff
    8000444e:	c0e080e7          	jalr	-1010(ra) # 80003058 <iunlockput>
  end_op();
    80004452:	fffff097          	auipc	ra,0xfffff
    80004456:	3f6080e7          	jalr	1014(ra) # 80003848 <end_op>
  p = myproc();
    8000445a:	ffffd097          	auipc	ra,0xffffd
    8000445e:	b0c080e7          	jalr	-1268(ra) # 80000f66 <myproc>
    80004462:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004464:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004468:	6785                	lui	a5,0x1
    8000446a:	17fd                	addi	a5,a5,-1
    8000446c:	993e                	add	s2,s2,a5
    8000446e:	757d                	lui	a0,0xfffff
    80004470:	00a977b3          	and	a5,s2,a0
    80004474:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004478:	6609                	lui	a2,0x2
    8000447a:	963e                	add	a2,a2,a5
    8000447c:	85be                	mv	a1,a5
    8000447e:	855e                	mv	a0,s7
    80004480:	ffffc097          	auipc	ra,0xffffc
    80004484:	558080e7          	jalr	1368(ra) # 800009d8 <uvmalloc>
    80004488:	8b2a                	mv	s6,a0
  ip = 0;
    8000448a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000448c:	12050c63          	beqz	a0,800045c4 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004490:	75f9                	lui	a1,0xffffe
    80004492:	95aa                	add	a1,a1,a0
    80004494:	855e                	mv	a0,s7
    80004496:	ffffc097          	auipc	ra,0xffffc
    8000449a:	760080e7          	jalr	1888(ra) # 80000bf6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000449e:	7c7d                	lui	s8,0xfffff
    800044a0:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800044a2:	e0043783          	ld	a5,-512(s0)
    800044a6:	6388                	ld	a0,0(a5)
    800044a8:	c535                	beqz	a0,80004514 <exec+0x216>
    800044aa:	e9040993          	addi	s3,s0,-368
    800044ae:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800044b2:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	f56080e7          	jalr	-170(ra) # 8000040a <strlen>
    800044bc:	2505                	addiw	a0,a0,1
    800044be:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044c2:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800044c6:	13896363          	bltu	s2,s8,800045ec <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044ca:	e0043d83          	ld	s11,-512(s0)
    800044ce:	000dba03          	ld	s4,0(s11)
    800044d2:	8552                	mv	a0,s4
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	f36080e7          	jalr	-202(ra) # 8000040a <strlen>
    800044dc:	0015069b          	addiw	a3,a0,1
    800044e0:	8652                	mv	a2,s4
    800044e2:	85ca                	mv	a1,s2
    800044e4:	855e                	mv	a0,s7
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	742080e7          	jalr	1858(ra) # 80000c28 <copyout>
    800044ee:	10054363          	bltz	a0,800045f4 <exec+0x2f6>
    ustack[argc] = sp;
    800044f2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044f6:	0485                	addi	s1,s1,1
    800044f8:	008d8793          	addi	a5,s11,8
    800044fc:	e0f43023          	sd	a5,-512(s0)
    80004500:	008db503          	ld	a0,8(s11)
    80004504:	c911                	beqz	a0,80004518 <exec+0x21a>
    if(argc >= MAXARG)
    80004506:	09a1                	addi	s3,s3,8
    80004508:	fb3c96e3          	bne	s9,s3,800044b4 <exec+0x1b6>
  sz = sz1;
    8000450c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004510:	4481                	li	s1,0
    80004512:	a84d                	j	800045c4 <exec+0x2c6>
  sp = sz;
    80004514:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004516:	4481                	li	s1,0
  ustack[argc] = 0;
    80004518:	00349793          	slli	a5,s1,0x3
    8000451c:	f9040713          	addi	a4,s0,-112
    80004520:	97ba                	add	a5,a5,a4
    80004522:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004526:	00148693          	addi	a3,s1,1
    8000452a:	068e                	slli	a3,a3,0x3
    8000452c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004530:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004534:	01897663          	bgeu	s2,s8,80004540 <exec+0x242>
  sz = sz1;
    80004538:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000453c:	4481                	li	s1,0
    8000453e:	a059                	j	800045c4 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004540:	e9040613          	addi	a2,s0,-368
    80004544:	85ca                	mv	a1,s2
    80004546:	855e                	mv	a0,s7
    80004548:	ffffc097          	auipc	ra,0xffffc
    8000454c:	6e0080e7          	jalr	1760(ra) # 80000c28 <copyout>
    80004550:	0a054663          	bltz	a0,800045fc <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004554:	060ab783          	ld	a5,96(s5)
    80004558:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000455c:	df843783          	ld	a5,-520(s0)
    80004560:	0007c703          	lbu	a4,0(a5)
    80004564:	cf11                	beqz	a4,80004580 <exec+0x282>
    80004566:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004568:	02f00693          	li	a3,47
    8000456c:	a039                	j	8000457a <exec+0x27c>
      last = s+1;
    8000456e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004572:	0785                	addi	a5,a5,1
    80004574:	fff7c703          	lbu	a4,-1(a5)
    80004578:	c701                	beqz	a4,80004580 <exec+0x282>
    if(*s == '/')
    8000457a:	fed71ce3          	bne	a4,a3,80004572 <exec+0x274>
    8000457e:	bfc5                	j	8000456e <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004580:	4641                	li	a2,16
    80004582:	df843583          	ld	a1,-520(s0)
    80004586:	160a8513          	addi	a0,s5,352
    8000458a:	ffffc097          	auipc	ra,0xffffc
    8000458e:	e4e080e7          	jalr	-434(ra) # 800003d8 <safestrcpy>
  oldpagetable = p->pagetable;
    80004592:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004596:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    8000459a:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000459e:	060ab783          	ld	a5,96(s5)
    800045a2:	e6843703          	ld	a4,-408(s0)
    800045a6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045a8:	060ab783          	ld	a5,96(s5)
    800045ac:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045b0:	85ea                	mv	a1,s10
    800045b2:	ffffd097          	auipc	ra,0xffffd
    800045b6:	b14080e7          	jalr	-1260(ra) # 800010c6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045ba:	0004851b          	sext.w	a0,s1
    800045be:	bbe1                	j	80004396 <exec+0x98>
    800045c0:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800045c4:	e0843583          	ld	a1,-504(s0)
    800045c8:	855e                	mv	a0,s7
    800045ca:	ffffd097          	auipc	ra,0xffffd
    800045ce:	afc080e7          	jalr	-1284(ra) # 800010c6 <proc_freepagetable>
  if(ip){
    800045d2:	da0498e3          	bnez	s1,80004382 <exec+0x84>
  return -1;
    800045d6:	557d                	li	a0,-1
    800045d8:	bb7d                	j	80004396 <exec+0x98>
    800045da:	e1243423          	sd	s2,-504(s0)
    800045de:	b7dd                	j	800045c4 <exec+0x2c6>
    800045e0:	e1243423          	sd	s2,-504(s0)
    800045e4:	b7c5                	j	800045c4 <exec+0x2c6>
    800045e6:	e1243423          	sd	s2,-504(s0)
    800045ea:	bfe9                	j	800045c4 <exec+0x2c6>
  sz = sz1;
    800045ec:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045f0:	4481                	li	s1,0
    800045f2:	bfc9                	j	800045c4 <exec+0x2c6>
  sz = sz1;
    800045f4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045f8:	4481                	li	s1,0
    800045fa:	b7e9                	j	800045c4 <exec+0x2c6>
  sz = sz1;
    800045fc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004600:	4481                	li	s1,0
    80004602:	b7c9                	j	800045c4 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004604:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004608:	2b05                	addiw	s6,s6,1
    8000460a:	0389899b          	addiw	s3,s3,56
    8000460e:	e8845783          	lhu	a5,-376(s0)
    80004612:	e2fb5be3          	bge	s6,a5,80004448 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004616:	2981                	sext.w	s3,s3
    80004618:	03800713          	li	a4,56
    8000461c:	86ce                	mv	a3,s3
    8000461e:	e1840613          	addi	a2,s0,-488
    80004622:	4581                	li	a1,0
    80004624:	8526                	mv	a0,s1
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	a84080e7          	jalr	-1404(ra) # 800030aa <readi>
    8000462e:	03800793          	li	a5,56
    80004632:	f8f517e3          	bne	a0,a5,800045c0 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004636:	e1842783          	lw	a5,-488(s0)
    8000463a:	4705                	li	a4,1
    8000463c:	fce796e3          	bne	a5,a4,80004608 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004640:	e4043603          	ld	a2,-448(s0)
    80004644:	e3843783          	ld	a5,-456(s0)
    80004648:	f8f669e3          	bltu	a2,a5,800045da <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000464c:	e2843783          	ld	a5,-472(s0)
    80004650:	963e                	add	a2,a2,a5
    80004652:	f8f667e3          	bltu	a2,a5,800045e0 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004656:	85ca                	mv	a1,s2
    80004658:	855e                	mv	a0,s7
    8000465a:	ffffc097          	auipc	ra,0xffffc
    8000465e:	37e080e7          	jalr	894(ra) # 800009d8 <uvmalloc>
    80004662:	e0a43423          	sd	a0,-504(s0)
    80004666:	d141                	beqz	a0,800045e6 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004668:	e2843d03          	ld	s10,-472(s0)
    8000466c:	df043783          	ld	a5,-528(s0)
    80004670:	00fd77b3          	and	a5,s10,a5
    80004674:	fba1                	bnez	a5,800045c4 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004676:	e2042d83          	lw	s11,-480(s0)
    8000467a:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000467e:	f80c03e3          	beqz	s8,80004604 <exec+0x306>
    80004682:	8a62                	mv	s4,s8
    80004684:	4901                	li	s2,0
    80004686:	b345                	j	80004426 <exec+0x128>

0000000080004688 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004688:	7179                	addi	sp,sp,-48
    8000468a:	f406                	sd	ra,40(sp)
    8000468c:	f022                	sd	s0,32(sp)
    8000468e:	ec26                	sd	s1,24(sp)
    80004690:	e84a                	sd	s2,16(sp)
    80004692:	1800                	addi	s0,sp,48
    80004694:	892e                	mv	s2,a1
    80004696:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004698:	fdc40593          	addi	a1,s0,-36
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	976080e7          	jalr	-1674(ra) # 80002012 <argint>
    800046a4:	04054063          	bltz	a0,800046e4 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046a8:	fdc42703          	lw	a4,-36(s0)
    800046ac:	47bd                	li	a5,15
    800046ae:	02e7ed63          	bltu	a5,a4,800046e8 <argfd+0x60>
    800046b2:	ffffd097          	auipc	ra,0xffffd
    800046b6:	8b4080e7          	jalr	-1868(ra) # 80000f66 <myproc>
    800046ba:	fdc42703          	lw	a4,-36(s0)
    800046be:	01a70793          	addi	a5,a4,26
    800046c2:	078e                	slli	a5,a5,0x3
    800046c4:	953e                	add	a0,a0,a5
    800046c6:	651c                	ld	a5,8(a0)
    800046c8:	c395                	beqz	a5,800046ec <argfd+0x64>
    return -1;
  if(pfd)
    800046ca:	00090463          	beqz	s2,800046d2 <argfd+0x4a>
    *pfd = fd;
    800046ce:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046d2:	4501                	li	a0,0
  if(pf)
    800046d4:	c091                	beqz	s1,800046d8 <argfd+0x50>
    *pf = f;
    800046d6:	e09c                	sd	a5,0(s1)
}
    800046d8:	70a2                	ld	ra,40(sp)
    800046da:	7402                	ld	s0,32(sp)
    800046dc:	64e2                	ld	s1,24(sp)
    800046de:	6942                	ld	s2,16(sp)
    800046e0:	6145                	addi	sp,sp,48
    800046e2:	8082                	ret
    return -1;
    800046e4:	557d                	li	a0,-1
    800046e6:	bfcd                	j	800046d8 <argfd+0x50>
    return -1;
    800046e8:	557d                	li	a0,-1
    800046ea:	b7fd                	j	800046d8 <argfd+0x50>
    800046ec:	557d                	li	a0,-1
    800046ee:	b7ed                	j	800046d8 <argfd+0x50>

00000000800046f0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046f0:	1101                	addi	sp,sp,-32
    800046f2:	ec06                	sd	ra,24(sp)
    800046f4:	e822                	sd	s0,16(sp)
    800046f6:	e426                	sd	s1,8(sp)
    800046f8:	1000                	addi	s0,sp,32
    800046fa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046fc:	ffffd097          	auipc	ra,0xffffd
    80004700:	86a080e7          	jalr	-1942(ra) # 80000f66 <myproc>
    80004704:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004706:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd3e90>
    8000470a:	4501                	li	a0,0
    8000470c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000470e:	6398                	ld	a4,0(a5)
    80004710:	cb19                	beqz	a4,80004726 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004712:	2505                	addiw	a0,a0,1
    80004714:	07a1                	addi	a5,a5,8
    80004716:	fed51ce3          	bne	a0,a3,8000470e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000471a:	557d                	li	a0,-1
}
    8000471c:	60e2                	ld	ra,24(sp)
    8000471e:	6442                	ld	s0,16(sp)
    80004720:	64a2                	ld	s1,8(sp)
    80004722:	6105                	addi	sp,sp,32
    80004724:	8082                	ret
      p->ofile[fd] = f;
    80004726:	01a50793          	addi	a5,a0,26
    8000472a:	078e                	slli	a5,a5,0x3
    8000472c:	963e                	add	a2,a2,a5
    8000472e:	e604                	sd	s1,8(a2)
      return fd;
    80004730:	b7f5                	j	8000471c <fdalloc+0x2c>

0000000080004732 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004732:	715d                	addi	sp,sp,-80
    80004734:	e486                	sd	ra,72(sp)
    80004736:	e0a2                	sd	s0,64(sp)
    80004738:	fc26                	sd	s1,56(sp)
    8000473a:	f84a                	sd	s2,48(sp)
    8000473c:	f44e                	sd	s3,40(sp)
    8000473e:	f052                	sd	s4,32(sp)
    80004740:	ec56                	sd	s5,24(sp)
    80004742:	0880                	addi	s0,sp,80
    80004744:	89ae                	mv	s3,a1
    80004746:	8ab2                	mv	s5,a2
    80004748:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000474a:	fb040593          	addi	a1,s0,-80
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	e7c080e7          	jalr	-388(ra) # 800035ca <nameiparent>
    80004756:	892a                	mv	s2,a0
    80004758:	12050f63          	beqz	a0,80004896 <create+0x164>
    return 0;

  ilock(dp);
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	69a080e7          	jalr	1690(ra) # 80002df6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004764:	4601                	li	a2,0
    80004766:	fb040593          	addi	a1,s0,-80
    8000476a:	854a                	mv	a0,s2
    8000476c:	fffff097          	auipc	ra,0xfffff
    80004770:	b6e080e7          	jalr	-1170(ra) # 800032da <dirlookup>
    80004774:	84aa                	mv	s1,a0
    80004776:	c921                	beqz	a0,800047c6 <create+0x94>
    iunlockput(dp);
    80004778:	854a                	mv	a0,s2
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	8de080e7          	jalr	-1826(ra) # 80003058 <iunlockput>
    ilock(ip);
    80004782:	8526                	mv	a0,s1
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	672080e7          	jalr	1650(ra) # 80002df6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000478c:	2981                	sext.w	s3,s3
    8000478e:	4789                	li	a5,2
    80004790:	02f99463          	bne	s3,a5,800047b8 <create+0x86>
    80004794:	04c4d783          	lhu	a5,76(s1)
    80004798:	37f9                	addiw	a5,a5,-2
    8000479a:	17c2                	slli	a5,a5,0x30
    8000479c:	93c1                	srli	a5,a5,0x30
    8000479e:	4705                	li	a4,1
    800047a0:	00f76c63          	bltu	a4,a5,800047b8 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047a4:	8526                	mv	a0,s1
    800047a6:	60a6                	ld	ra,72(sp)
    800047a8:	6406                	ld	s0,64(sp)
    800047aa:	74e2                	ld	s1,56(sp)
    800047ac:	7942                	ld	s2,48(sp)
    800047ae:	79a2                	ld	s3,40(sp)
    800047b0:	7a02                	ld	s4,32(sp)
    800047b2:	6ae2                	ld	s5,24(sp)
    800047b4:	6161                	addi	sp,sp,80
    800047b6:	8082                	ret
    iunlockput(ip);
    800047b8:	8526                	mv	a0,s1
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	89e080e7          	jalr	-1890(ra) # 80003058 <iunlockput>
    return 0;
    800047c2:	4481                	li	s1,0
    800047c4:	b7c5                	j	800047a4 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047c6:	85ce                	mv	a1,s3
    800047c8:	00092503          	lw	a0,0(s2)
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	492080e7          	jalr	1170(ra) # 80002c5e <ialloc>
    800047d4:	84aa                	mv	s1,a0
    800047d6:	c529                	beqz	a0,80004820 <create+0xee>
  ilock(ip);
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	61e080e7          	jalr	1566(ra) # 80002df6 <ilock>
  ip->major = major;
    800047e0:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    800047e4:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    800047e8:	4785                	li	a5,1
    800047ea:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    800047ee:	8526                	mv	a0,s1
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	53c080e7          	jalr	1340(ra) # 80002d2c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047f8:	2981                	sext.w	s3,s3
    800047fa:	4785                	li	a5,1
    800047fc:	02f98a63          	beq	s3,a5,80004830 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004800:	40d0                	lw	a2,4(s1)
    80004802:	fb040593          	addi	a1,s0,-80
    80004806:	854a                	mv	a0,s2
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	ce2080e7          	jalr	-798(ra) # 800034ea <dirlink>
    80004810:	06054b63          	bltz	a0,80004886 <create+0x154>
  iunlockput(dp);
    80004814:	854a                	mv	a0,s2
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	842080e7          	jalr	-1982(ra) # 80003058 <iunlockput>
  return ip;
    8000481e:	b759                	j	800047a4 <create+0x72>
    panic("create: ialloc");
    80004820:	00004517          	auipc	a0,0x4
    80004824:	e6050513          	addi	a0,a0,-416 # 80008680 <syscalls+0x2b8>
    80004828:	00002097          	auipc	ra,0x2
    8000482c:	9c4080e7          	jalr	-1596(ra) # 800061ec <panic>
    dp->nlink++;  // for ".."
    80004830:	05295783          	lhu	a5,82(s2)
    80004834:	2785                	addiw	a5,a5,1
    80004836:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    8000483a:	854a                	mv	a0,s2
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	4f0080e7          	jalr	1264(ra) # 80002d2c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004844:	40d0                	lw	a2,4(s1)
    80004846:	00004597          	auipc	a1,0x4
    8000484a:	e4a58593          	addi	a1,a1,-438 # 80008690 <syscalls+0x2c8>
    8000484e:	8526                	mv	a0,s1
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	c9a080e7          	jalr	-870(ra) # 800034ea <dirlink>
    80004858:	00054f63          	bltz	a0,80004876 <create+0x144>
    8000485c:	00492603          	lw	a2,4(s2)
    80004860:	00004597          	auipc	a1,0x4
    80004864:	e3858593          	addi	a1,a1,-456 # 80008698 <syscalls+0x2d0>
    80004868:	8526                	mv	a0,s1
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	c80080e7          	jalr	-896(ra) # 800034ea <dirlink>
    80004872:	f80557e3          	bgez	a0,80004800 <create+0xce>
      panic("create dots");
    80004876:	00004517          	auipc	a0,0x4
    8000487a:	e2a50513          	addi	a0,a0,-470 # 800086a0 <syscalls+0x2d8>
    8000487e:	00002097          	auipc	ra,0x2
    80004882:	96e080e7          	jalr	-1682(ra) # 800061ec <panic>
    panic("create: dirlink");
    80004886:	00004517          	auipc	a0,0x4
    8000488a:	e2a50513          	addi	a0,a0,-470 # 800086b0 <syscalls+0x2e8>
    8000488e:	00002097          	auipc	ra,0x2
    80004892:	95e080e7          	jalr	-1698(ra) # 800061ec <panic>
    return 0;
    80004896:	84aa                	mv	s1,a0
    80004898:	b731                	j	800047a4 <create+0x72>

000000008000489a <sys_dup>:
{
    8000489a:	7179                	addi	sp,sp,-48
    8000489c:	f406                	sd	ra,40(sp)
    8000489e:	f022                	sd	s0,32(sp)
    800048a0:	ec26                	sd	s1,24(sp)
    800048a2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048a4:	fd840613          	addi	a2,s0,-40
    800048a8:	4581                	li	a1,0
    800048aa:	4501                	li	a0,0
    800048ac:	00000097          	auipc	ra,0x0
    800048b0:	ddc080e7          	jalr	-548(ra) # 80004688 <argfd>
    return -1;
    800048b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048b6:	02054363          	bltz	a0,800048dc <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800048ba:	fd843503          	ld	a0,-40(s0)
    800048be:	00000097          	auipc	ra,0x0
    800048c2:	e32080e7          	jalr	-462(ra) # 800046f0 <fdalloc>
    800048c6:	84aa                	mv	s1,a0
    return -1;
    800048c8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048ca:	00054963          	bltz	a0,800048dc <sys_dup+0x42>
  filedup(f);
    800048ce:	fd843503          	ld	a0,-40(s0)
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	370080e7          	jalr	880(ra) # 80003c42 <filedup>
  return fd;
    800048da:	87a6                	mv	a5,s1
}
    800048dc:	853e                	mv	a0,a5
    800048de:	70a2                	ld	ra,40(sp)
    800048e0:	7402                	ld	s0,32(sp)
    800048e2:	64e2                	ld	s1,24(sp)
    800048e4:	6145                	addi	sp,sp,48
    800048e6:	8082                	ret

00000000800048e8 <sys_read>:
{
    800048e8:	7179                	addi	sp,sp,-48
    800048ea:	f406                	sd	ra,40(sp)
    800048ec:	f022                	sd	s0,32(sp)
    800048ee:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f0:	fe840613          	addi	a2,s0,-24
    800048f4:	4581                	li	a1,0
    800048f6:	4501                	li	a0,0
    800048f8:	00000097          	auipc	ra,0x0
    800048fc:	d90080e7          	jalr	-624(ra) # 80004688 <argfd>
    return -1;
    80004900:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004902:	04054163          	bltz	a0,80004944 <sys_read+0x5c>
    80004906:	fe440593          	addi	a1,s0,-28
    8000490a:	4509                	li	a0,2
    8000490c:	ffffd097          	auipc	ra,0xffffd
    80004910:	706080e7          	jalr	1798(ra) # 80002012 <argint>
    return -1;
    80004914:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004916:	02054763          	bltz	a0,80004944 <sys_read+0x5c>
    8000491a:	fd840593          	addi	a1,s0,-40
    8000491e:	4505                	li	a0,1
    80004920:	ffffd097          	auipc	ra,0xffffd
    80004924:	714080e7          	jalr	1812(ra) # 80002034 <argaddr>
    return -1;
    80004928:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000492a:	00054d63          	bltz	a0,80004944 <sys_read+0x5c>
  return fileread(f, p, n);
    8000492e:	fe442603          	lw	a2,-28(s0)
    80004932:	fd843583          	ld	a1,-40(s0)
    80004936:	fe843503          	ld	a0,-24(s0)
    8000493a:	fffff097          	auipc	ra,0xfffff
    8000493e:	494080e7          	jalr	1172(ra) # 80003dce <fileread>
    80004942:	87aa                	mv	a5,a0
}
    80004944:	853e                	mv	a0,a5
    80004946:	70a2                	ld	ra,40(sp)
    80004948:	7402                	ld	s0,32(sp)
    8000494a:	6145                	addi	sp,sp,48
    8000494c:	8082                	ret

000000008000494e <sys_write>:
{
    8000494e:	7179                	addi	sp,sp,-48
    80004950:	f406                	sd	ra,40(sp)
    80004952:	f022                	sd	s0,32(sp)
    80004954:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004956:	fe840613          	addi	a2,s0,-24
    8000495a:	4581                	li	a1,0
    8000495c:	4501                	li	a0,0
    8000495e:	00000097          	auipc	ra,0x0
    80004962:	d2a080e7          	jalr	-726(ra) # 80004688 <argfd>
    return -1;
    80004966:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004968:	04054163          	bltz	a0,800049aa <sys_write+0x5c>
    8000496c:	fe440593          	addi	a1,s0,-28
    80004970:	4509                	li	a0,2
    80004972:	ffffd097          	auipc	ra,0xffffd
    80004976:	6a0080e7          	jalr	1696(ra) # 80002012 <argint>
    return -1;
    8000497a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000497c:	02054763          	bltz	a0,800049aa <sys_write+0x5c>
    80004980:	fd840593          	addi	a1,s0,-40
    80004984:	4505                	li	a0,1
    80004986:	ffffd097          	auipc	ra,0xffffd
    8000498a:	6ae080e7          	jalr	1710(ra) # 80002034 <argaddr>
    return -1;
    8000498e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004990:	00054d63          	bltz	a0,800049aa <sys_write+0x5c>
  return filewrite(f, p, n);
    80004994:	fe442603          	lw	a2,-28(s0)
    80004998:	fd843583          	ld	a1,-40(s0)
    8000499c:	fe843503          	ld	a0,-24(s0)
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	4f0080e7          	jalr	1264(ra) # 80003e90 <filewrite>
    800049a8:	87aa                	mv	a5,a0
}
    800049aa:	853e                	mv	a0,a5
    800049ac:	70a2                	ld	ra,40(sp)
    800049ae:	7402                	ld	s0,32(sp)
    800049b0:	6145                	addi	sp,sp,48
    800049b2:	8082                	ret

00000000800049b4 <sys_close>:
{
    800049b4:	1101                	addi	sp,sp,-32
    800049b6:	ec06                	sd	ra,24(sp)
    800049b8:	e822                	sd	s0,16(sp)
    800049ba:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049bc:	fe040613          	addi	a2,s0,-32
    800049c0:	fec40593          	addi	a1,s0,-20
    800049c4:	4501                	li	a0,0
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	cc2080e7          	jalr	-830(ra) # 80004688 <argfd>
    return -1;
    800049ce:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049d0:	02054463          	bltz	a0,800049f8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049d4:	ffffc097          	auipc	ra,0xffffc
    800049d8:	592080e7          	jalr	1426(ra) # 80000f66 <myproc>
    800049dc:	fec42783          	lw	a5,-20(s0)
    800049e0:	07e9                	addi	a5,a5,26
    800049e2:	078e                	slli	a5,a5,0x3
    800049e4:	97aa                	add	a5,a5,a0
    800049e6:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800049ea:	fe043503          	ld	a0,-32(s0)
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	2a6080e7          	jalr	678(ra) # 80003c94 <fileclose>
  return 0;
    800049f6:	4781                	li	a5,0
}
    800049f8:	853e                	mv	a0,a5
    800049fa:	60e2                	ld	ra,24(sp)
    800049fc:	6442                	ld	s0,16(sp)
    800049fe:	6105                	addi	sp,sp,32
    80004a00:	8082                	ret

0000000080004a02 <sys_fstat>:
{
    80004a02:	1101                	addi	sp,sp,-32
    80004a04:	ec06                	sd	ra,24(sp)
    80004a06:	e822                	sd	s0,16(sp)
    80004a08:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a0a:	fe840613          	addi	a2,s0,-24
    80004a0e:	4581                	li	a1,0
    80004a10:	4501                	li	a0,0
    80004a12:	00000097          	auipc	ra,0x0
    80004a16:	c76080e7          	jalr	-906(ra) # 80004688 <argfd>
    return -1;
    80004a1a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a1c:	02054563          	bltz	a0,80004a46 <sys_fstat+0x44>
    80004a20:	fe040593          	addi	a1,s0,-32
    80004a24:	4505                	li	a0,1
    80004a26:	ffffd097          	auipc	ra,0xffffd
    80004a2a:	60e080e7          	jalr	1550(ra) # 80002034 <argaddr>
    return -1;
    80004a2e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a30:	00054b63          	bltz	a0,80004a46 <sys_fstat+0x44>
  return filestat(f, st);
    80004a34:	fe043583          	ld	a1,-32(s0)
    80004a38:	fe843503          	ld	a0,-24(s0)
    80004a3c:	fffff097          	auipc	ra,0xfffff
    80004a40:	320080e7          	jalr	800(ra) # 80003d5c <filestat>
    80004a44:	87aa                	mv	a5,a0
}
    80004a46:	853e                	mv	a0,a5
    80004a48:	60e2                	ld	ra,24(sp)
    80004a4a:	6442                	ld	s0,16(sp)
    80004a4c:	6105                	addi	sp,sp,32
    80004a4e:	8082                	ret

0000000080004a50 <sys_link>:
{
    80004a50:	7169                	addi	sp,sp,-304
    80004a52:	f606                	sd	ra,296(sp)
    80004a54:	f222                	sd	s0,288(sp)
    80004a56:	ee26                	sd	s1,280(sp)
    80004a58:	ea4a                	sd	s2,272(sp)
    80004a5a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a5c:	08000613          	li	a2,128
    80004a60:	ed040593          	addi	a1,s0,-304
    80004a64:	4501                	li	a0,0
    80004a66:	ffffd097          	auipc	ra,0xffffd
    80004a6a:	5f0080e7          	jalr	1520(ra) # 80002056 <argstr>
    return -1;
    80004a6e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a70:	10054e63          	bltz	a0,80004b8c <sys_link+0x13c>
    80004a74:	08000613          	li	a2,128
    80004a78:	f5040593          	addi	a1,s0,-176
    80004a7c:	4505                	li	a0,1
    80004a7e:	ffffd097          	auipc	ra,0xffffd
    80004a82:	5d8080e7          	jalr	1496(ra) # 80002056 <argstr>
    return -1;
    80004a86:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a88:	10054263          	bltz	a0,80004b8c <sys_link+0x13c>
  begin_op();
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	d3c080e7          	jalr	-708(ra) # 800037c8 <begin_op>
  if((ip = namei(old)) == 0){
    80004a94:	ed040513          	addi	a0,s0,-304
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	b14080e7          	jalr	-1260(ra) # 800035ac <namei>
    80004aa0:	84aa                	mv	s1,a0
    80004aa2:	c551                	beqz	a0,80004b2e <sys_link+0xde>
  ilock(ip);
    80004aa4:	ffffe097          	auipc	ra,0xffffe
    80004aa8:	352080e7          	jalr	850(ra) # 80002df6 <ilock>
  if(ip->type == T_DIR){
    80004aac:	04c49703          	lh	a4,76(s1)
    80004ab0:	4785                	li	a5,1
    80004ab2:	08f70463          	beq	a4,a5,80004b3a <sys_link+0xea>
  ip->nlink++;
    80004ab6:	0524d783          	lhu	a5,82(s1)
    80004aba:	2785                	addiw	a5,a5,1
    80004abc:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	26a080e7          	jalr	618(ra) # 80002d2c <iupdate>
  iunlock(ip);
    80004aca:	8526                	mv	a0,s1
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	3ec080e7          	jalr	1004(ra) # 80002eb8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ad4:	fd040593          	addi	a1,s0,-48
    80004ad8:	f5040513          	addi	a0,s0,-176
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	aee080e7          	jalr	-1298(ra) # 800035ca <nameiparent>
    80004ae4:	892a                	mv	s2,a0
    80004ae6:	c935                	beqz	a0,80004b5a <sys_link+0x10a>
  ilock(dp);
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	30e080e7          	jalr	782(ra) # 80002df6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004af0:	00092703          	lw	a4,0(s2)
    80004af4:	409c                	lw	a5,0(s1)
    80004af6:	04f71d63          	bne	a4,a5,80004b50 <sys_link+0x100>
    80004afa:	40d0                	lw	a2,4(s1)
    80004afc:	fd040593          	addi	a1,s0,-48
    80004b00:	854a                	mv	a0,s2
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	9e8080e7          	jalr	-1560(ra) # 800034ea <dirlink>
    80004b0a:	04054363          	bltz	a0,80004b50 <sys_link+0x100>
  iunlockput(dp);
    80004b0e:	854a                	mv	a0,s2
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	548080e7          	jalr	1352(ra) # 80003058 <iunlockput>
  iput(ip);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	496080e7          	jalr	1174(ra) # 80002fb0 <iput>
  end_op();
    80004b22:	fffff097          	auipc	ra,0xfffff
    80004b26:	d26080e7          	jalr	-730(ra) # 80003848 <end_op>
  return 0;
    80004b2a:	4781                	li	a5,0
    80004b2c:	a085                	j	80004b8c <sys_link+0x13c>
    end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	d1a080e7          	jalr	-742(ra) # 80003848 <end_op>
    return -1;
    80004b36:	57fd                	li	a5,-1
    80004b38:	a891                	j	80004b8c <sys_link+0x13c>
    iunlockput(ip);
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	51c080e7          	jalr	1308(ra) # 80003058 <iunlockput>
    end_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	d04080e7          	jalr	-764(ra) # 80003848 <end_op>
    return -1;
    80004b4c:	57fd                	li	a5,-1
    80004b4e:	a83d                	j	80004b8c <sys_link+0x13c>
    iunlockput(dp);
    80004b50:	854a                	mv	a0,s2
    80004b52:	ffffe097          	auipc	ra,0xffffe
    80004b56:	506080e7          	jalr	1286(ra) # 80003058 <iunlockput>
  ilock(ip);
    80004b5a:	8526                	mv	a0,s1
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	29a080e7          	jalr	666(ra) # 80002df6 <ilock>
  ip->nlink--;
    80004b64:	0524d783          	lhu	a5,82(s1)
    80004b68:	37fd                	addiw	a5,a5,-1
    80004b6a:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b6e:	8526                	mv	a0,s1
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	1bc080e7          	jalr	444(ra) # 80002d2c <iupdate>
  iunlockput(ip);
    80004b78:	8526                	mv	a0,s1
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	4de080e7          	jalr	1246(ra) # 80003058 <iunlockput>
  end_op();
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	cc6080e7          	jalr	-826(ra) # 80003848 <end_op>
  return -1;
    80004b8a:	57fd                	li	a5,-1
}
    80004b8c:	853e                	mv	a0,a5
    80004b8e:	70b2                	ld	ra,296(sp)
    80004b90:	7412                	ld	s0,288(sp)
    80004b92:	64f2                	ld	s1,280(sp)
    80004b94:	6952                	ld	s2,272(sp)
    80004b96:	6155                	addi	sp,sp,304
    80004b98:	8082                	ret

0000000080004b9a <sys_unlink>:
{
    80004b9a:	7151                	addi	sp,sp,-240
    80004b9c:	f586                	sd	ra,232(sp)
    80004b9e:	f1a2                	sd	s0,224(sp)
    80004ba0:	eda6                	sd	s1,216(sp)
    80004ba2:	e9ca                	sd	s2,208(sp)
    80004ba4:	e5ce                	sd	s3,200(sp)
    80004ba6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ba8:	08000613          	li	a2,128
    80004bac:	f3040593          	addi	a1,s0,-208
    80004bb0:	4501                	li	a0,0
    80004bb2:	ffffd097          	auipc	ra,0xffffd
    80004bb6:	4a4080e7          	jalr	1188(ra) # 80002056 <argstr>
    80004bba:	18054163          	bltz	a0,80004d3c <sys_unlink+0x1a2>
  begin_op();
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	c0a080e7          	jalr	-1014(ra) # 800037c8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bc6:	fb040593          	addi	a1,s0,-80
    80004bca:	f3040513          	addi	a0,s0,-208
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	9fc080e7          	jalr	-1540(ra) # 800035ca <nameiparent>
    80004bd6:	84aa                	mv	s1,a0
    80004bd8:	c979                	beqz	a0,80004cae <sys_unlink+0x114>
  ilock(dp);
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	21c080e7          	jalr	540(ra) # 80002df6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004be2:	00004597          	auipc	a1,0x4
    80004be6:	aae58593          	addi	a1,a1,-1362 # 80008690 <syscalls+0x2c8>
    80004bea:	fb040513          	addi	a0,s0,-80
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	6d2080e7          	jalr	1746(ra) # 800032c0 <namecmp>
    80004bf6:	14050a63          	beqz	a0,80004d4a <sys_unlink+0x1b0>
    80004bfa:	00004597          	auipc	a1,0x4
    80004bfe:	a9e58593          	addi	a1,a1,-1378 # 80008698 <syscalls+0x2d0>
    80004c02:	fb040513          	addi	a0,s0,-80
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	6ba080e7          	jalr	1722(ra) # 800032c0 <namecmp>
    80004c0e:	12050e63          	beqz	a0,80004d4a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c12:	f2c40613          	addi	a2,s0,-212
    80004c16:	fb040593          	addi	a1,s0,-80
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	6be080e7          	jalr	1726(ra) # 800032da <dirlookup>
    80004c24:	892a                	mv	s2,a0
    80004c26:	12050263          	beqz	a0,80004d4a <sys_unlink+0x1b0>
  ilock(ip);
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	1cc080e7          	jalr	460(ra) # 80002df6 <ilock>
  if(ip->nlink < 1)
    80004c32:	05291783          	lh	a5,82(s2)
    80004c36:	08f05263          	blez	a5,80004cba <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c3a:	04c91703          	lh	a4,76(s2)
    80004c3e:	4785                	li	a5,1
    80004c40:	08f70563          	beq	a4,a5,80004cca <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c44:	4641                	li	a2,16
    80004c46:	4581                	li	a1,0
    80004c48:	fc040513          	addi	a0,s0,-64
    80004c4c:	ffffb097          	auipc	ra,0xffffb
    80004c50:	63a080e7          	jalr	1594(ra) # 80000286 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c54:	4741                	li	a4,16
    80004c56:	f2c42683          	lw	a3,-212(s0)
    80004c5a:	fc040613          	addi	a2,s0,-64
    80004c5e:	4581                	li	a1,0
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	540080e7          	jalr	1344(ra) # 800031a2 <writei>
    80004c6a:	47c1                	li	a5,16
    80004c6c:	0af51563          	bne	a0,a5,80004d16 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c70:	04c91703          	lh	a4,76(s2)
    80004c74:	4785                	li	a5,1
    80004c76:	0af70863          	beq	a4,a5,80004d26 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	3dc080e7          	jalr	988(ra) # 80003058 <iunlockput>
  ip->nlink--;
    80004c84:	05295783          	lhu	a5,82(s2)
    80004c88:	37fd                	addiw	a5,a5,-1
    80004c8a:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	09c080e7          	jalr	156(ra) # 80002d2c <iupdate>
  iunlockput(ip);
    80004c98:	854a                	mv	a0,s2
    80004c9a:	ffffe097          	auipc	ra,0xffffe
    80004c9e:	3be080e7          	jalr	958(ra) # 80003058 <iunlockput>
  end_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	ba6080e7          	jalr	-1114(ra) # 80003848 <end_op>
  return 0;
    80004caa:	4501                	li	a0,0
    80004cac:	a84d                	j	80004d5e <sys_unlink+0x1c4>
    end_op();
    80004cae:	fffff097          	auipc	ra,0xfffff
    80004cb2:	b9a080e7          	jalr	-1126(ra) # 80003848 <end_op>
    return -1;
    80004cb6:	557d                	li	a0,-1
    80004cb8:	a05d                	j	80004d5e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004cba:	00004517          	auipc	a0,0x4
    80004cbe:	a0650513          	addi	a0,a0,-1530 # 800086c0 <syscalls+0x2f8>
    80004cc2:	00001097          	auipc	ra,0x1
    80004cc6:	52a080e7          	jalr	1322(ra) # 800061ec <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cca:	05492703          	lw	a4,84(s2)
    80004cce:	02000793          	li	a5,32
    80004cd2:	f6e7f9e3          	bgeu	a5,a4,80004c44 <sys_unlink+0xaa>
    80004cd6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cda:	4741                	li	a4,16
    80004cdc:	86ce                	mv	a3,s3
    80004cde:	f1840613          	addi	a2,s0,-232
    80004ce2:	4581                	li	a1,0
    80004ce4:	854a                	mv	a0,s2
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	3c4080e7          	jalr	964(ra) # 800030aa <readi>
    80004cee:	47c1                	li	a5,16
    80004cf0:	00f51b63          	bne	a0,a5,80004d06 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cf4:	f1845783          	lhu	a5,-232(s0)
    80004cf8:	e7a1                	bnez	a5,80004d40 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cfa:	29c1                	addiw	s3,s3,16
    80004cfc:	05492783          	lw	a5,84(s2)
    80004d00:	fcf9ede3          	bltu	s3,a5,80004cda <sys_unlink+0x140>
    80004d04:	b781                	j	80004c44 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d06:	00004517          	auipc	a0,0x4
    80004d0a:	9d250513          	addi	a0,a0,-1582 # 800086d8 <syscalls+0x310>
    80004d0e:	00001097          	auipc	ra,0x1
    80004d12:	4de080e7          	jalr	1246(ra) # 800061ec <panic>
    panic("unlink: writei");
    80004d16:	00004517          	auipc	a0,0x4
    80004d1a:	9da50513          	addi	a0,a0,-1574 # 800086f0 <syscalls+0x328>
    80004d1e:	00001097          	auipc	ra,0x1
    80004d22:	4ce080e7          	jalr	1230(ra) # 800061ec <panic>
    dp->nlink--;
    80004d26:	0524d783          	lhu	a5,82(s1)
    80004d2a:	37fd                	addiw	a5,a5,-1
    80004d2c:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004d30:	8526                	mv	a0,s1
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	ffa080e7          	jalr	-6(ra) # 80002d2c <iupdate>
    80004d3a:	b781                	j	80004c7a <sys_unlink+0xe0>
    return -1;
    80004d3c:	557d                	li	a0,-1
    80004d3e:	a005                	j	80004d5e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d40:	854a                	mv	a0,s2
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	316080e7          	jalr	790(ra) # 80003058 <iunlockput>
  iunlockput(dp);
    80004d4a:	8526                	mv	a0,s1
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	30c080e7          	jalr	780(ra) # 80003058 <iunlockput>
  end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	af4080e7          	jalr	-1292(ra) # 80003848 <end_op>
  return -1;
    80004d5c:	557d                	li	a0,-1
}
    80004d5e:	70ae                	ld	ra,232(sp)
    80004d60:	740e                	ld	s0,224(sp)
    80004d62:	64ee                	ld	s1,216(sp)
    80004d64:	694e                	ld	s2,208(sp)
    80004d66:	69ae                	ld	s3,200(sp)
    80004d68:	616d                	addi	sp,sp,240
    80004d6a:	8082                	ret

0000000080004d6c <sys_open>:

uint64
sys_open(void)
{
    80004d6c:	7131                	addi	sp,sp,-192
    80004d6e:	fd06                	sd	ra,184(sp)
    80004d70:	f922                	sd	s0,176(sp)
    80004d72:	f526                	sd	s1,168(sp)
    80004d74:	f14a                	sd	s2,160(sp)
    80004d76:	ed4e                	sd	s3,152(sp)
    80004d78:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d7a:	08000613          	li	a2,128
    80004d7e:	f5040593          	addi	a1,s0,-176
    80004d82:	4501                	li	a0,0
    80004d84:	ffffd097          	auipc	ra,0xffffd
    80004d88:	2d2080e7          	jalr	722(ra) # 80002056 <argstr>
    return -1;
    80004d8c:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d8e:	0c054163          	bltz	a0,80004e50 <sys_open+0xe4>
    80004d92:	f4c40593          	addi	a1,s0,-180
    80004d96:	4505                	li	a0,1
    80004d98:	ffffd097          	auipc	ra,0xffffd
    80004d9c:	27a080e7          	jalr	634(ra) # 80002012 <argint>
    80004da0:	0a054863          	bltz	a0,80004e50 <sys_open+0xe4>

  begin_op();
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	a24080e7          	jalr	-1500(ra) # 800037c8 <begin_op>

  if(omode & O_CREATE){
    80004dac:	f4c42783          	lw	a5,-180(s0)
    80004db0:	2007f793          	andi	a5,a5,512
    80004db4:	cbdd                	beqz	a5,80004e6a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004db6:	4681                	li	a3,0
    80004db8:	4601                	li	a2,0
    80004dba:	4589                	li	a1,2
    80004dbc:	f5040513          	addi	a0,s0,-176
    80004dc0:	00000097          	auipc	ra,0x0
    80004dc4:	972080e7          	jalr	-1678(ra) # 80004732 <create>
    80004dc8:	892a                	mv	s2,a0
    if(ip == 0){
    80004dca:	c959                	beqz	a0,80004e60 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004dcc:	04c91703          	lh	a4,76(s2)
    80004dd0:	478d                	li	a5,3
    80004dd2:	00f71763          	bne	a4,a5,80004de0 <sys_open+0x74>
    80004dd6:	04e95703          	lhu	a4,78(s2)
    80004dda:	47a5                	li	a5,9
    80004ddc:	0ce7ec63          	bltu	a5,a4,80004eb4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	df8080e7          	jalr	-520(ra) # 80003bd8 <filealloc>
    80004de8:	89aa                	mv	s3,a0
    80004dea:	10050263          	beqz	a0,80004eee <sys_open+0x182>
    80004dee:	00000097          	auipc	ra,0x0
    80004df2:	902080e7          	jalr	-1790(ra) # 800046f0 <fdalloc>
    80004df6:	84aa                	mv	s1,a0
    80004df8:	0e054663          	bltz	a0,80004ee4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dfc:	04c91703          	lh	a4,76(s2)
    80004e00:	478d                	li	a5,3
    80004e02:	0cf70463          	beq	a4,a5,80004eca <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e06:	4789                	li	a5,2
    80004e08:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e0c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e10:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e14:	f4c42783          	lw	a5,-180(s0)
    80004e18:	0017c713          	xori	a4,a5,1
    80004e1c:	8b05                	andi	a4,a4,1
    80004e1e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e22:	0037f713          	andi	a4,a5,3
    80004e26:	00e03733          	snez	a4,a4
    80004e2a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e2e:	4007f793          	andi	a5,a5,1024
    80004e32:	c791                	beqz	a5,80004e3e <sys_open+0xd2>
    80004e34:	04c91703          	lh	a4,76(s2)
    80004e38:	4789                	li	a5,2
    80004e3a:	08f70f63          	beq	a4,a5,80004ed8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e3e:	854a                	mv	a0,s2
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	078080e7          	jalr	120(ra) # 80002eb8 <iunlock>
  end_op();
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	a00080e7          	jalr	-1536(ra) # 80003848 <end_op>

  return fd;
}
    80004e50:	8526                	mv	a0,s1
    80004e52:	70ea                	ld	ra,184(sp)
    80004e54:	744a                	ld	s0,176(sp)
    80004e56:	74aa                	ld	s1,168(sp)
    80004e58:	790a                	ld	s2,160(sp)
    80004e5a:	69ea                	ld	s3,152(sp)
    80004e5c:	6129                	addi	sp,sp,192
    80004e5e:	8082                	ret
      end_op();
    80004e60:	fffff097          	auipc	ra,0xfffff
    80004e64:	9e8080e7          	jalr	-1560(ra) # 80003848 <end_op>
      return -1;
    80004e68:	b7e5                	j	80004e50 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e6a:	f5040513          	addi	a0,s0,-176
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	73e080e7          	jalr	1854(ra) # 800035ac <namei>
    80004e76:	892a                	mv	s2,a0
    80004e78:	c905                	beqz	a0,80004ea8 <sys_open+0x13c>
    ilock(ip);
    80004e7a:	ffffe097          	auipc	ra,0xffffe
    80004e7e:	f7c080e7          	jalr	-132(ra) # 80002df6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e82:	04c91703          	lh	a4,76(s2)
    80004e86:	4785                	li	a5,1
    80004e88:	f4f712e3          	bne	a4,a5,80004dcc <sys_open+0x60>
    80004e8c:	f4c42783          	lw	a5,-180(s0)
    80004e90:	dba1                	beqz	a5,80004de0 <sys_open+0x74>
      iunlockput(ip);
    80004e92:	854a                	mv	a0,s2
    80004e94:	ffffe097          	auipc	ra,0xffffe
    80004e98:	1c4080e7          	jalr	452(ra) # 80003058 <iunlockput>
      end_op();
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	9ac080e7          	jalr	-1620(ra) # 80003848 <end_op>
      return -1;
    80004ea4:	54fd                	li	s1,-1
    80004ea6:	b76d                	j	80004e50 <sys_open+0xe4>
      end_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	9a0080e7          	jalr	-1632(ra) # 80003848 <end_op>
      return -1;
    80004eb0:	54fd                	li	s1,-1
    80004eb2:	bf79                	j	80004e50 <sys_open+0xe4>
    iunlockput(ip);
    80004eb4:	854a                	mv	a0,s2
    80004eb6:	ffffe097          	auipc	ra,0xffffe
    80004eba:	1a2080e7          	jalr	418(ra) # 80003058 <iunlockput>
    end_op();
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	98a080e7          	jalr	-1654(ra) # 80003848 <end_op>
    return -1;
    80004ec6:	54fd                	li	s1,-1
    80004ec8:	b761                	j	80004e50 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004eca:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ece:	04e91783          	lh	a5,78(s2)
    80004ed2:	02f99223          	sh	a5,36(s3)
    80004ed6:	bf2d                	j	80004e10 <sys_open+0xa4>
    itrunc(ip);
    80004ed8:	854a                	mv	a0,s2
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	02a080e7          	jalr	42(ra) # 80002f04 <itrunc>
    80004ee2:	bfb1                	j	80004e3e <sys_open+0xd2>
      fileclose(f);
    80004ee4:	854e                	mv	a0,s3
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	dae080e7          	jalr	-594(ra) # 80003c94 <fileclose>
    iunlockput(ip);
    80004eee:	854a                	mv	a0,s2
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	168080e7          	jalr	360(ra) # 80003058 <iunlockput>
    end_op();
    80004ef8:	fffff097          	auipc	ra,0xfffff
    80004efc:	950080e7          	jalr	-1712(ra) # 80003848 <end_op>
    return -1;
    80004f00:	54fd                	li	s1,-1
    80004f02:	b7b9                	j	80004e50 <sys_open+0xe4>

0000000080004f04 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f04:	7175                	addi	sp,sp,-144
    80004f06:	e506                	sd	ra,136(sp)
    80004f08:	e122                	sd	s0,128(sp)
    80004f0a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	8bc080e7          	jalr	-1860(ra) # 800037c8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f14:	08000613          	li	a2,128
    80004f18:	f7040593          	addi	a1,s0,-144
    80004f1c:	4501                	li	a0,0
    80004f1e:	ffffd097          	auipc	ra,0xffffd
    80004f22:	138080e7          	jalr	312(ra) # 80002056 <argstr>
    80004f26:	02054963          	bltz	a0,80004f58 <sys_mkdir+0x54>
    80004f2a:	4681                	li	a3,0
    80004f2c:	4601                	li	a2,0
    80004f2e:	4585                	li	a1,1
    80004f30:	f7040513          	addi	a0,s0,-144
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	7fe080e7          	jalr	2046(ra) # 80004732 <create>
    80004f3c:	cd11                	beqz	a0,80004f58 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	11a080e7          	jalr	282(ra) # 80003058 <iunlockput>
  end_op();
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	902080e7          	jalr	-1790(ra) # 80003848 <end_op>
  return 0;
    80004f4e:	4501                	li	a0,0
}
    80004f50:	60aa                	ld	ra,136(sp)
    80004f52:	640a                	ld	s0,128(sp)
    80004f54:	6149                	addi	sp,sp,144
    80004f56:	8082                	ret
    end_op();
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	8f0080e7          	jalr	-1808(ra) # 80003848 <end_op>
    return -1;
    80004f60:	557d                	li	a0,-1
    80004f62:	b7fd                	j	80004f50 <sys_mkdir+0x4c>

0000000080004f64 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f64:	7135                	addi	sp,sp,-160
    80004f66:	ed06                	sd	ra,152(sp)
    80004f68:	e922                	sd	s0,144(sp)
    80004f6a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	85c080e7          	jalr	-1956(ra) # 800037c8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f74:	08000613          	li	a2,128
    80004f78:	f7040593          	addi	a1,s0,-144
    80004f7c:	4501                	li	a0,0
    80004f7e:	ffffd097          	auipc	ra,0xffffd
    80004f82:	0d8080e7          	jalr	216(ra) # 80002056 <argstr>
    80004f86:	04054a63          	bltz	a0,80004fda <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f8a:	f6c40593          	addi	a1,s0,-148
    80004f8e:	4505                	li	a0,1
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	082080e7          	jalr	130(ra) # 80002012 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f98:	04054163          	bltz	a0,80004fda <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f9c:	f6840593          	addi	a1,s0,-152
    80004fa0:	4509                	li	a0,2
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	070080e7          	jalr	112(ra) # 80002012 <argint>
     argint(1, &major) < 0 ||
    80004faa:	02054863          	bltz	a0,80004fda <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fae:	f6841683          	lh	a3,-152(s0)
    80004fb2:	f6c41603          	lh	a2,-148(s0)
    80004fb6:	458d                	li	a1,3
    80004fb8:	f7040513          	addi	a0,s0,-144
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	776080e7          	jalr	1910(ra) # 80004732 <create>
     argint(2, &minor) < 0 ||
    80004fc4:	c919                	beqz	a0,80004fda <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	092080e7          	jalr	146(ra) # 80003058 <iunlockput>
  end_op();
    80004fce:	fffff097          	auipc	ra,0xfffff
    80004fd2:	87a080e7          	jalr	-1926(ra) # 80003848 <end_op>
  return 0;
    80004fd6:	4501                	li	a0,0
    80004fd8:	a031                	j	80004fe4 <sys_mknod+0x80>
    end_op();
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	86e080e7          	jalr	-1938(ra) # 80003848 <end_op>
    return -1;
    80004fe2:	557d                	li	a0,-1
}
    80004fe4:	60ea                	ld	ra,152(sp)
    80004fe6:	644a                	ld	s0,144(sp)
    80004fe8:	610d                	addi	sp,sp,160
    80004fea:	8082                	ret

0000000080004fec <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fec:	7135                	addi	sp,sp,-160
    80004fee:	ed06                	sd	ra,152(sp)
    80004ff0:	e922                	sd	s0,144(sp)
    80004ff2:	e526                	sd	s1,136(sp)
    80004ff4:	e14a                	sd	s2,128(sp)
    80004ff6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ff8:	ffffc097          	auipc	ra,0xffffc
    80004ffc:	f6e080e7          	jalr	-146(ra) # 80000f66 <myproc>
    80005000:	892a                	mv	s2,a0
  
  begin_op();
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	7c6080e7          	jalr	1990(ra) # 800037c8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000500a:	08000613          	li	a2,128
    8000500e:	f6040593          	addi	a1,s0,-160
    80005012:	4501                	li	a0,0
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	042080e7          	jalr	66(ra) # 80002056 <argstr>
    8000501c:	04054b63          	bltz	a0,80005072 <sys_chdir+0x86>
    80005020:	f6040513          	addi	a0,s0,-160
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	588080e7          	jalr	1416(ra) # 800035ac <namei>
    8000502c:	84aa                	mv	s1,a0
    8000502e:	c131                	beqz	a0,80005072 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005030:	ffffe097          	auipc	ra,0xffffe
    80005034:	dc6080e7          	jalr	-570(ra) # 80002df6 <ilock>
  if(ip->type != T_DIR){
    80005038:	04c49703          	lh	a4,76(s1)
    8000503c:	4785                	li	a5,1
    8000503e:	04f71063          	bne	a4,a5,8000507e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005042:	8526                	mv	a0,s1
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	e74080e7          	jalr	-396(ra) # 80002eb8 <iunlock>
  iput(p->cwd);
    8000504c:	15893503          	ld	a0,344(s2)
    80005050:	ffffe097          	auipc	ra,0xffffe
    80005054:	f60080e7          	jalr	-160(ra) # 80002fb0 <iput>
  end_op();
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	7f0080e7          	jalr	2032(ra) # 80003848 <end_op>
  p->cwd = ip;
    80005060:	14993c23          	sd	s1,344(s2)
  return 0;
    80005064:	4501                	li	a0,0
}
    80005066:	60ea                	ld	ra,152(sp)
    80005068:	644a                	ld	s0,144(sp)
    8000506a:	64aa                	ld	s1,136(sp)
    8000506c:	690a                	ld	s2,128(sp)
    8000506e:	610d                	addi	sp,sp,160
    80005070:	8082                	ret
    end_op();
    80005072:	ffffe097          	auipc	ra,0xffffe
    80005076:	7d6080e7          	jalr	2006(ra) # 80003848 <end_op>
    return -1;
    8000507a:	557d                	li	a0,-1
    8000507c:	b7ed                	j	80005066 <sys_chdir+0x7a>
    iunlockput(ip);
    8000507e:	8526                	mv	a0,s1
    80005080:	ffffe097          	auipc	ra,0xffffe
    80005084:	fd8080e7          	jalr	-40(ra) # 80003058 <iunlockput>
    end_op();
    80005088:	ffffe097          	auipc	ra,0xffffe
    8000508c:	7c0080e7          	jalr	1984(ra) # 80003848 <end_op>
    return -1;
    80005090:	557d                	li	a0,-1
    80005092:	bfd1                	j	80005066 <sys_chdir+0x7a>

0000000080005094 <sys_exec>:

uint64
sys_exec(void)
{
    80005094:	7145                	addi	sp,sp,-464
    80005096:	e786                	sd	ra,456(sp)
    80005098:	e3a2                	sd	s0,448(sp)
    8000509a:	ff26                	sd	s1,440(sp)
    8000509c:	fb4a                	sd	s2,432(sp)
    8000509e:	f74e                	sd	s3,424(sp)
    800050a0:	f352                	sd	s4,416(sp)
    800050a2:	ef56                	sd	s5,408(sp)
    800050a4:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050a6:	08000613          	li	a2,128
    800050aa:	f4040593          	addi	a1,s0,-192
    800050ae:	4501                	li	a0,0
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	fa6080e7          	jalr	-90(ra) # 80002056 <argstr>
    return -1;
    800050b8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050ba:	0c054a63          	bltz	a0,8000518e <sys_exec+0xfa>
    800050be:	e3840593          	addi	a1,s0,-456
    800050c2:	4505                	li	a0,1
    800050c4:	ffffd097          	auipc	ra,0xffffd
    800050c8:	f70080e7          	jalr	-144(ra) # 80002034 <argaddr>
    800050cc:	0c054163          	bltz	a0,8000518e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800050d0:	10000613          	li	a2,256
    800050d4:	4581                	li	a1,0
    800050d6:	e4040513          	addi	a0,s0,-448
    800050da:	ffffb097          	auipc	ra,0xffffb
    800050de:	1ac080e7          	jalr	428(ra) # 80000286 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050e2:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050e6:	89a6                	mv	s3,s1
    800050e8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050ea:	02000a13          	li	s4,32
    800050ee:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050f2:	00391513          	slli	a0,s2,0x3
    800050f6:	e3040593          	addi	a1,s0,-464
    800050fa:	e3843783          	ld	a5,-456(s0)
    800050fe:	953e                	add	a0,a0,a5
    80005100:	ffffd097          	auipc	ra,0xffffd
    80005104:	e78080e7          	jalr	-392(ra) # 80001f78 <fetchaddr>
    80005108:	02054a63          	bltz	a0,8000513c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000510c:	e3043783          	ld	a5,-464(s0)
    80005110:	c3b9                	beqz	a5,80005156 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005112:	ffffb097          	auipc	ra,0xffffb
    80005116:	06e080e7          	jalr	110(ra) # 80000180 <kalloc>
    8000511a:	85aa                	mv	a1,a0
    8000511c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005120:	cd11                	beqz	a0,8000513c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005122:	6605                	lui	a2,0x1
    80005124:	e3043503          	ld	a0,-464(s0)
    80005128:	ffffd097          	auipc	ra,0xffffd
    8000512c:	ea2080e7          	jalr	-350(ra) # 80001fca <fetchstr>
    80005130:	00054663          	bltz	a0,8000513c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005134:	0905                	addi	s2,s2,1
    80005136:	09a1                	addi	s3,s3,8
    80005138:	fb491be3          	bne	s2,s4,800050ee <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000513c:	10048913          	addi	s2,s1,256
    80005140:	6088                	ld	a0,0(s1)
    80005142:	c529                	beqz	a0,8000518c <sys_exec+0xf8>
    kfree(argv[i]);
    80005144:	ffffb097          	auipc	ra,0xffffb
    80005148:	ed8080e7          	jalr	-296(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000514c:	04a1                	addi	s1,s1,8
    8000514e:	ff2499e3          	bne	s1,s2,80005140 <sys_exec+0xac>
  return -1;
    80005152:	597d                	li	s2,-1
    80005154:	a82d                	j	8000518e <sys_exec+0xfa>
      argv[i] = 0;
    80005156:	0a8e                	slli	s5,s5,0x3
    80005158:	fc040793          	addi	a5,s0,-64
    8000515c:	9abe                	add	s5,s5,a5
    8000515e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005162:	e4040593          	addi	a1,s0,-448
    80005166:	f4040513          	addi	a0,s0,-192
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	194080e7          	jalr	404(ra) # 800042fe <exec>
    80005172:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005174:	10048993          	addi	s3,s1,256
    80005178:	6088                	ld	a0,0(s1)
    8000517a:	c911                	beqz	a0,8000518e <sys_exec+0xfa>
    kfree(argv[i]);
    8000517c:	ffffb097          	auipc	ra,0xffffb
    80005180:	ea0080e7          	jalr	-352(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005184:	04a1                	addi	s1,s1,8
    80005186:	ff3499e3          	bne	s1,s3,80005178 <sys_exec+0xe4>
    8000518a:	a011                	j	8000518e <sys_exec+0xfa>
  return -1;
    8000518c:	597d                	li	s2,-1
}
    8000518e:	854a                	mv	a0,s2
    80005190:	60be                	ld	ra,456(sp)
    80005192:	641e                	ld	s0,448(sp)
    80005194:	74fa                	ld	s1,440(sp)
    80005196:	795a                	ld	s2,432(sp)
    80005198:	79ba                	ld	s3,424(sp)
    8000519a:	7a1a                	ld	s4,416(sp)
    8000519c:	6afa                	ld	s5,408(sp)
    8000519e:	6179                	addi	sp,sp,464
    800051a0:	8082                	ret

00000000800051a2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051a2:	7139                	addi	sp,sp,-64
    800051a4:	fc06                	sd	ra,56(sp)
    800051a6:	f822                	sd	s0,48(sp)
    800051a8:	f426                	sd	s1,40(sp)
    800051aa:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051ac:	ffffc097          	auipc	ra,0xffffc
    800051b0:	dba080e7          	jalr	-582(ra) # 80000f66 <myproc>
    800051b4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051b6:	fd840593          	addi	a1,s0,-40
    800051ba:	4501                	li	a0,0
    800051bc:	ffffd097          	auipc	ra,0xffffd
    800051c0:	e78080e7          	jalr	-392(ra) # 80002034 <argaddr>
    return -1;
    800051c4:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051c6:	0e054063          	bltz	a0,800052a6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051ca:	fc840593          	addi	a1,s0,-56
    800051ce:	fd040513          	addi	a0,s0,-48
    800051d2:	fffff097          	auipc	ra,0xfffff
    800051d6:	df2080e7          	jalr	-526(ra) # 80003fc4 <pipealloc>
    return -1;
    800051da:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051dc:	0c054563          	bltz	a0,800052a6 <sys_pipe+0x104>
  fd0 = -1;
    800051e0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051e4:	fd043503          	ld	a0,-48(s0)
    800051e8:	fffff097          	auipc	ra,0xfffff
    800051ec:	508080e7          	jalr	1288(ra) # 800046f0 <fdalloc>
    800051f0:	fca42223          	sw	a0,-60(s0)
    800051f4:	08054c63          	bltz	a0,8000528c <sys_pipe+0xea>
    800051f8:	fc843503          	ld	a0,-56(s0)
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	4f4080e7          	jalr	1268(ra) # 800046f0 <fdalloc>
    80005204:	fca42023          	sw	a0,-64(s0)
    80005208:	06054863          	bltz	a0,80005278 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000520c:	4691                	li	a3,4
    8000520e:	fc440613          	addi	a2,s0,-60
    80005212:	fd843583          	ld	a1,-40(s0)
    80005216:	6ca8                	ld	a0,88(s1)
    80005218:	ffffc097          	auipc	ra,0xffffc
    8000521c:	a10080e7          	jalr	-1520(ra) # 80000c28 <copyout>
    80005220:	02054063          	bltz	a0,80005240 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005224:	4691                	li	a3,4
    80005226:	fc040613          	addi	a2,s0,-64
    8000522a:	fd843583          	ld	a1,-40(s0)
    8000522e:	0591                	addi	a1,a1,4
    80005230:	6ca8                	ld	a0,88(s1)
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	9f6080e7          	jalr	-1546(ra) # 80000c28 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000523a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000523c:	06055563          	bgez	a0,800052a6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005240:	fc442783          	lw	a5,-60(s0)
    80005244:	07e9                	addi	a5,a5,26
    80005246:	078e                	slli	a5,a5,0x3
    80005248:	97a6                	add	a5,a5,s1
    8000524a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000524e:	fc042503          	lw	a0,-64(s0)
    80005252:	0569                	addi	a0,a0,26
    80005254:	050e                	slli	a0,a0,0x3
    80005256:	9526                	add	a0,a0,s1
    80005258:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000525c:	fd043503          	ld	a0,-48(s0)
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	a34080e7          	jalr	-1484(ra) # 80003c94 <fileclose>
    fileclose(wf);
    80005268:	fc843503          	ld	a0,-56(s0)
    8000526c:	fffff097          	auipc	ra,0xfffff
    80005270:	a28080e7          	jalr	-1496(ra) # 80003c94 <fileclose>
    return -1;
    80005274:	57fd                	li	a5,-1
    80005276:	a805                	j	800052a6 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005278:	fc442783          	lw	a5,-60(s0)
    8000527c:	0007c863          	bltz	a5,8000528c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005280:	01a78513          	addi	a0,a5,26
    80005284:	050e                	slli	a0,a0,0x3
    80005286:	9526                	add	a0,a0,s1
    80005288:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000528c:	fd043503          	ld	a0,-48(s0)
    80005290:	fffff097          	auipc	ra,0xfffff
    80005294:	a04080e7          	jalr	-1532(ra) # 80003c94 <fileclose>
    fileclose(wf);
    80005298:	fc843503          	ld	a0,-56(s0)
    8000529c:	fffff097          	auipc	ra,0xfffff
    800052a0:	9f8080e7          	jalr	-1544(ra) # 80003c94 <fileclose>
    return -1;
    800052a4:	57fd                	li	a5,-1
}
    800052a6:	853e                	mv	a0,a5
    800052a8:	70e2                	ld	ra,56(sp)
    800052aa:	7442                	ld	s0,48(sp)
    800052ac:	74a2                	ld	s1,40(sp)
    800052ae:	6121                	addi	sp,sp,64
    800052b0:	8082                	ret
	...

00000000800052c0 <kernelvec>:
    800052c0:	7111                	addi	sp,sp,-256
    800052c2:	e006                	sd	ra,0(sp)
    800052c4:	e40a                	sd	sp,8(sp)
    800052c6:	e80e                	sd	gp,16(sp)
    800052c8:	ec12                	sd	tp,24(sp)
    800052ca:	f016                	sd	t0,32(sp)
    800052cc:	f41a                	sd	t1,40(sp)
    800052ce:	f81e                	sd	t2,48(sp)
    800052d0:	fc22                	sd	s0,56(sp)
    800052d2:	e0a6                	sd	s1,64(sp)
    800052d4:	e4aa                	sd	a0,72(sp)
    800052d6:	e8ae                	sd	a1,80(sp)
    800052d8:	ecb2                	sd	a2,88(sp)
    800052da:	f0b6                	sd	a3,96(sp)
    800052dc:	f4ba                	sd	a4,104(sp)
    800052de:	f8be                	sd	a5,112(sp)
    800052e0:	fcc2                	sd	a6,120(sp)
    800052e2:	e146                	sd	a7,128(sp)
    800052e4:	e54a                	sd	s2,136(sp)
    800052e6:	e94e                	sd	s3,144(sp)
    800052e8:	ed52                	sd	s4,152(sp)
    800052ea:	f156                	sd	s5,160(sp)
    800052ec:	f55a                	sd	s6,168(sp)
    800052ee:	f95e                	sd	s7,176(sp)
    800052f0:	fd62                	sd	s8,184(sp)
    800052f2:	e1e6                	sd	s9,192(sp)
    800052f4:	e5ea                	sd	s10,200(sp)
    800052f6:	e9ee                	sd	s11,208(sp)
    800052f8:	edf2                	sd	t3,216(sp)
    800052fa:	f1f6                	sd	t4,224(sp)
    800052fc:	f5fa                	sd	t5,232(sp)
    800052fe:	f9fe                	sd	t6,240(sp)
    80005300:	b45fc0ef          	jal	ra,80001e44 <kerneltrap>
    80005304:	6082                	ld	ra,0(sp)
    80005306:	6122                	ld	sp,8(sp)
    80005308:	61c2                	ld	gp,16(sp)
    8000530a:	7282                	ld	t0,32(sp)
    8000530c:	7322                	ld	t1,40(sp)
    8000530e:	73c2                	ld	t2,48(sp)
    80005310:	7462                	ld	s0,56(sp)
    80005312:	6486                	ld	s1,64(sp)
    80005314:	6526                	ld	a0,72(sp)
    80005316:	65c6                	ld	a1,80(sp)
    80005318:	6666                	ld	a2,88(sp)
    8000531a:	7686                	ld	a3,96(sp)
    8000531c:	7726                	ld	a4,104(sp)
    8000531e:	77c6                	ld	a5,112(sp)
    80005320:	7866                	ld	a6,120(sp)
    80005322:	688a                	ld	a7,128(sp)
    80005324:	692a                	ld	s2,136(sp)
    80005326:	69ca                	ld	s3,144(sp)
    80005328:	6a6a                	ld	s4,152(sp)
    8000532a:	7a8a                	ld	s5,160(sp)
    8000532c:	7b2a                	ld	s6,168(sp)
    8000532e:	7bca                	ld	s7,176(sp)
    80005330:	7c6a                	ld	s8,184(sp)
    80005332:	6c8e                	ld	s9,192(sp)
    80005334:	6d2e                	ld	s10,200(sp)
    80005336:	6dce                	ld	s11,208(sp)
    80005338:	6e6e                	ld	t3,216(sp)
    8000533a:	7e8e                	ld	t4,224(sp)
    8000533c:	7f2e                	ld	t5,232(sp)
    8000533e:	7fce                	ld	t6,240(sp)
    80005340:	6111                	addi	sp,sp,256
    80005342:	10200073          	sret
    80005346:	00000013          	nop
    8000534a:	00000013          	nop
    8000534e:	0001                	nop

0000000080005350 <timervec>:
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	e10c                	sd	a1,0(a0)
    80005356:	e510                	sd	a2,8(a0)
    80005358:	e914                	sd	a3,16(a0)
    8000535a:	6d0c                	ld	a1,24(a0)
    8000535c:	7110                	ld	a2,32(a0)
    8000535e:	6194                	ld	a3,0(a1)
    80005360:	96b2                	add	a3,a3,a2
    80005362:	e194                	sd	a3,0(a1)
    80005364:	4589                	li	a1,2
    80005366:	14459073          	csrw	sip,a1
    8000536a:	6914                	ld	a3,16(a0)
    8000536c:	6510                	ld	a2,8(a0)
    8000536e:	610c                	ld	a1,0(a0)
    80005370:	34051573          	csrrw	a0,mscratch,a0
    80005374:	30200073          	mret
	...

000000008000537a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000537a:	1141                	addi	sp,sp,-16
    8000537c:	e422                	sd	s0,8(sp)
    8000537e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005380:	0c0007b7          	lui	a5,0xc000
    80005384:	4705                	li	a4,1
    80005386:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005388:	c3d8                	sw	a4,4(a5)
}
    8000538a:	6422                	ld	s0,8(sp)
    8000538c:	0141                	addi	sp,sp,16
    8000538e:	8082                	ret

0000000080005390 <plicinithart>:

void
plicinithart(void)
{
    80005390:	1141                	addi	sp,sp,-16
    80005392:	e406                	sd	ra,8(sp)
    80005394:	e022                	sd	s0,0(sp)
    80005396:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005398:	ffffc097          	auipc	ra,0xffffc
    8000539c:	ba2080e7          	jalr	-1118(ra) # 80000f3a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053a0:	0085171b          	slliw	a4,a0,0x8
    800053a4:	0c0027b7          	lui	a5,0xc002
    800053a8:	97ba                	add	a5,a5,a4
    800053aa:	40200713          	li	a4,1026
    800053ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053b2:	00d5151b          	slliw	a0,a0,0xd
    800053b6:	0c2017b7          	lui	a5,0xc201
    800053ba:	953e                	add	a0,a0,a5
    800053bc:	00052023          	sw	zero,0(a0)
}
    800053c0:	60a2                	ld	ra,8(sp)
    800053c2:	6402                	ld	s0,0(sp)
    800053c4:	0141                	addi	sp,sp,16
    800053c6:	8082                	ret

00000000800053c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053c8:	1141                	addi	sp,sp,-16
    800053ca:	e406                	sd	ra,8(sp)
    800053cc:	e022                	sd	s0,0(sp)
    800053ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053d0:	ffffc097          	auipc	ra,0xffffc
    800053d4:	b6a080e7          	jalr	-1174(ra) # 80000f3a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053d8:	00d5179b          	slliw	a5,a0,0xd
    800053dc:	0c201537          	lui	a0,0xc201
    800053e0:	953e                	add	a0,a0,a5
  return irq;
}
    800053e2:	4148                	lw	a0,4(a0)
    800053e4:	60a2                	ld	ra,8(sp)
    800053e6:	6402                	ld	s0,0(sp)
    800053e8:	0141                	addi	sp,sp,16
    800053ea:	8082                	ret

00000000800053ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053ec:	1101                	addi	sp,sp,-32
    800053ee:	ec06                	sd	ra,24(sp)
    800053f0:	e822                	sd	s0,16(sp)
    800053f2:	e426                	sd	s1,8(sp)
    800053f4:	1000                	addi	s0,sp,32
    800053f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	b42080e7          	jalr	-1214(ra) # 80000f3a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005400:	00d5151b          	slliw	a0,a0,0xd
    80005404:	0c2017b7          	lui	a5,0xc201
    80005408:	97aa                	add	a5,a5,a0
    8000540a:	c3c4                	sw	s1,4(a5)
}
    8000540c:	60e2                	ld	ra,24(sp)
    8000540e:	6442                	ld	s0,16(sp)
    80005410:	64a2                	ld	s1,8(sp)
    80005412:	6105                	addi	sp,sp,32
    80005414:	8082                	ret

0000000080005416 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005416:	1141                	addi	sp,sp,-16
    80005418:	e406                	sd	ra,8(sp)
    8000541a:	e022                	sd	s0,0(sp)
    8000541c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000541e:	479d                	li	a5,7
    80005420:	06a7c963          	blt	a5,a0,80005492 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005424:	00019797          	auipc	a5,0x19
    80005428:	bdc78793          	addi	a5,a5,-1060 # 8001e000 <disk>
    8000542c:	00a78733          	add	a4,a5,a0
    80005430:	6789                	lui	a5,0x2
    80005432:	97ba                	add	a5,a5,a4
    80005434:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005438:	e7ad                	bnez	a5,800054a2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000543a:	00451793          	slli	a5,a0,0x4
    8000543e:	0001b717          	auipc	a4,0x1b
    80005442:	bc270713          	addi	a4,a4,-1086 # 80020000 <disk+0x2000>
    80005446:	6314                	ld	a3,0(a4)
    80005448:	96be                	add	a3,a3,a5
    8000544a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000544e:	6314                	ld	a3,0(a4)
    80005450:	96be                	add	a3,a3,a5
    80005452:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005456:	6314                	ld	a3,0(a4)
    80005458:	96be                	add	a3,a3,a5
    8000545a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000545e:	6318                	ld	a4,0(a4)
    80005460:	97ba                	add	a5,a5,a4
    80005462:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005466:	00019797          	auipc	a5,0x19
    8000546a:	b9a78793          	addi	a5,a5,-1126 # 8001e000 <disk>
    8000546e:	97aa                	add	a5,a5,a0
    80005470:	6509                	lui	a0,0x2
    80005472:	953e                	add	a0,a0,a5
    80005474:	4785                	li	a5,1
    80005476:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000547a:	0001b517          	auipc	a0,0x1b
    8000547e:	b9e50513          	addi	a0,a0,-1122 # 80020018 <disk+0x2018>
    80005482:	ffffc097          	auipc	ra,0xffffc
    80005486:	32c080e7          	jalr	812(ra) # 800017ae <wakeup>
}
    8000548a:	60a2                	ld	ra,8(sp)
    8000548c:	6402                	ld	s0,0(sp)
    8000548e:	0141                	addi	sp,sp,16
    80005490:	8082                	ret
    panic("free_desc 1");
    80005492:	00003517          	auipc	a0,0x3
    80005496:	26e50513          	addi	a0,a0,622 # 80008700 <syscalls+0x338>
    8000549a:	00001097          	auipc	ra,0x1
    8000549e:	d52080e7          	jalr	-686(ra) # 800061ec <panic>
    panic("free_desc 2");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	26e50513          	addi	a0,a0,622 # 80008710 <syscalls+0x348>
    800054aa:	00001097          	auipc	ra,0x1
    800054ae:	d42080e7          	jalr	-702(ra) # 800061ec <panic>

00000000800054b2 <virtio_disk_init>:
{
    800054b2:	1101                	addi	sp,sp,-32
    800054b4:	ec06                	sd	ra,24(sp)
    800054b6:	e822                	sd	s0,16(sp)
    800054b8:	e426                	sd	s1,8(sp)
    800054ba:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054bc:	00003597          	auipc	a1,0x3
    800054c0:	26458593          	addi	a1,a1,612 # 80008720 <syscalls+0x358>
    800054c4:	0001b517          	auipc	a0,0x1b
    800054c8:	c6450513          	addi	a0,a0,-924 # 80020128 <disk+0x2128>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	3d0080e7          	jalr	976(ra) # 8000689c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d4:	100017b7          	lui	a5,0x10001
    800054d8:	4398                	lw	a4,0(a5)
    800054da:	2701                	sext.w	a4,a4
    800054dc:	747277b7          	lui	a5,0x74727
    800054e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054e4:	0ef71163          	bne	a4,a5,800055c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054e8:	100017b7          	lui	a5,0x10001
    800054ec:	43dc                	lw	a5,4(a5)
    800054ee:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054f0:	4705                	li	a4,1
    800054f2:	0ce79a63          	bne	a5,a4,800055c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054f6:	100017b7          	lui	a5,0x10001
    800054fa:	479c                	lw	a5,8(a5)
    800054fc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054fe:	4709                	li	a4,2
    80005500:	0ce79363          	bne	a5,a4,800055c6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005504:	100017b7          	lui	a5,0x10001
    80005508:	47d8                	lw	a4,12(a5)
    8000550a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000550c:	554d47b7          	lui	a5,0x554d4
    80005510:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005514:	0af71963          	bne	a4,a5,800055c6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005518:	100017b7          	lui	a5,0x10001
    8000551c:	4705                	li	a4,1
    8000551e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005520:	470d                	li	a4,3
    80005522:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005524:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005526:	c7ffe737          	lui	a4,0xc7ffe
    8000552a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    8000552e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005530:	2701                	sext.w	a4,a4
    80005532:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005534:	472d                	li	a4,11
    80005536:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005538:	473d                	li	a4,15
    8000553a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000553c:	6705                	lui	a4,0x1
    8000553e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005540:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005544:	5bdc                	lw	a5,52(a5)
    80005546:	2781                	sext.w	a5,a5
  if(max == 0)
    80005548:	c7d9                	beqz	a5,800055d6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000554a:	471d                	li	a4,7
    8000554c:	08f77d63          	bgeu	a4,a5,800055e6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005550:	100014b7          	lui	s1,0x10001
    80005554:	47a1                	li	a5,8
    80005556:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005558:	6609                	lui	a2,0x2
    8000555a:	4581                	li	a1,0
    8000555c:	00019517          	auipc	a0,0x19
    80005560:	aa450513          	addi	a0,a0,-1372 # 8001e000 <disk>
    80005564:	ffffb097          	auipc	ra,0xffffb
    80005568:	d22080e7          	jalr	-734(ra) # 80000286 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000556c:	00019717          	auipc	a4,0x19
    80005570:	a9470713          	addi	a4,a4,-1388 # 8001e000 <disk>
    80005574:	00c75793          	srli	a5,a4,0xc
    80005578:	2781                	sext.w	a5,a5
    8000557a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000557c:	0001b797          	auipc	a5,0x1b
    80005580:	a8478793          	addi	a5,a5,-1404 # 80020000 <disk+0x2000>
    80005584:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005586:	00019717          	auipc	a4,0x19
    8000558a:	afa70713          	addi	a4,a4,-1286 # 8001e080 <disk+0x80>
    8000558e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005590:	0001a717          	auipc	a4,0x1a
    80005594:	a7070713          	addi	a4,a4,-1424 # 8001f000 <disk+0x1000>
    80005598:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000559a:	4705                	li	a4,1
    8000559c:	00e78c23          	sb	a4,24(a5)
    800055a0:	00e78ca3          	sb	a4,25(a5)
    800055a4:	00e78d23          	sb	a4,26(a5)
    800055a8:	00e78da3          	sb	a4,27(a5)
    800055ac:	00e78e23          	sb	a4,28(a5)
    800055b0:	00e78ea3          	sb	a4,29(a5)
    800055b4:	00e78f23          	sb	a4,30(a5)
    800055b8:	00e78fa3          	sb	a4,31(a5)
}
    800055bc:	60e2                	ld	ra,24(sp)
    800055be:	6442                	ld	s0,16(sp)
    800055c0:	64a2                	ld	s1,8(sp)
    800055c2:	6105                	addi	sp,sp,32
    800055c4:	8082                	ret
    panic("could not find virtio disk");
    800055c6:	00003517          	auipc	a0,0x3
    800055ca:	16a50513          	addi	a0,a0,362 # 80008730 <syscalls+0x368>
    800055ce:	00001097          	auipc	ra,0x1
    800055d2:	c1e080e7          	jalr	-994(ra) # 800061ec <panic>
    panic("virtio disk has no queue 0");
    800055d6:	00003517          	auipc	a0,0x3
    800055da:	17a50513          	addi	a0,a0,378 # 80008750 <syscalls+0x388>
    800055de:	00001097          	auipc	ra,0x1
    800055e2:	c0e080e7          	jalr	-1010(ra) # 800061ec <panic>
    panic("virtio disk max queue too short");
    800055e6:	00003517          	auipc	a0,0x3
    800055ea:	18a50513          	addi	a0,a0,394 # 80008770 <syscalls+0x3a8>
    800055ee:	00001097          	auipc	ra,0x1
    800055f2:	bfe080e7          	jalr	-1026(ra) # 800061ec <panic>

00000000800055f6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055f6:	7159                	addi	sp,sp,-112
    800055f8:	f486                	sd	ra,104(sp)
    800055fa:	f0a2                	sd	s0,96(sp)
    800055fc:	eca6                	sd	s1,88(sp)
    800055fe:	e8ca                	sd	s2,80(sp)
    80005600:	e4ce                	sd	s3,72(sp)
    80005602:	e0d2                	sd	s4,64(sp)
    80005604:	fc56                	sd	s5,56(sp)
    80005606:	f85a                	sd	s6,48(sp)
    80005608:	f45e                	sd	s7,40(sp)
    8000560a:	f062                	sd	s8,32(sp)
    8000560c:	ec66                	sd	s9,24(sp)
    8000560e:	e86a                	sd	s10,16(sp)
    80005610:	1880                	addi	s0,sp,112
    80005612:	892a                	mv	s2,a0
    80005614:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005616:	00c52c83          	lw	s9,12(a0)
    8000561a:	001c9c9b          	slliw	s9,s9,0x1
    8000561e:	1c82                	slli	s9,s9,0x20
    80005620:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005624:	0001b517          	auipc	a0,0x1b
    80005628:	b0450513          	addi	a0,a0,-1276 # 80020128 <disk+0x2128>
    8000562c:	00001097          	auipc	ra,0x1
    80005630:	0f4080e7          	jalr	244(ra) # 80006720 <acquire>
  for(int i = 0; i < 3; i++){
    80005634:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005636:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005638:	00019b97          	auipc	s7,0x19
    8000563c:	9c8b8b93          	addi	s7,s7,-1592 # 8001e000 <disk>
    80005640:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005642:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005644:	8a4e                	mv	s4,s3
    80005646:	a051                	j	800056ca <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005648:	00fb86b3          	add	a3,s7,a5
    8000564c:	96da                	add	a3,a3,s6
    8000564e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005652:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005654:	0207c563          	bltz	a5,8000567e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005658:	2485                	addiw	s1,s1,1
    8000565a:	0711                	addi	a4,a4,4
    8000565c:	25548063          	beq	s1,s5,8000589c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005660:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005662:	0001b697          	auipc	a3,0x1b
    80005666:	9b668693          	addi	a3,a3,-1610 # 80020018 <disk+0x2018>
    8000566a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000566c:	0006c583          	lbu	a1,0(a3)
    80005670:	fde1                	bnez	a1,80005648 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005672:	2785                	addiw	a5,a5,1
    80005674:	0685                	addi	a3,a3,1
    80005676:	ff879be3          	bne	a5,s8,8000566c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000567a:	57fd                	li	a5,-1
    8000567c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000567e:	02905a63          	blez	s1,800056b2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005682:	f9042503          	lw	a0,-112(s0)
    80005686:	00000097          	auipc	ra,0x0
    8000568a:	d90080e7          	jalr	-624(ra) # 80005416 <free_desc>
      for(int j = 0; j < i; j++)
    8000568e:	4785                	li	a5,1
    80005690:	0297d163          	bge	a5,s1,800056b2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005694:	f9442503          	lw	a0,-108(s0)
    80005698:	00000097          	auipc	ra,0x0
    8000569c:	d7e080e7          	jalr	-642(ra) # 80005416 <free_desc>
      for(int j = 0; j < i; j++)
    800056a0:	4789                	li	a5,2
    800056a2:	0097d863          	bge	a5,s1,800056b2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800056a6:	f9842503          	lw	a0,-104(s0)
    800056aa:	00000097          	auipc	ra,0x0
    800056ae:	d6c080e7          	jalr	-660(ra) # 80005416 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056b2:	0001b597          	auipc	a1,0x1b
    800056b6:	a7658593          	addi	a1,a1,-1418 # 80020128 <disk+0x2128>
    800056ba:	0001b517          	auipc	a0,0x1b
    800056be:	95e50513          	addi	a0,a0,-1698 # 80020018 <disk+0x2018>
    800056c2:	ffffc097          	auipc	ra,0xffffc
    800056c6:	f60080e7          	jalr	-160(ra) # 80001622 <sleep>
  for(int i = 0; i < 3; i++){
    800056ca:	f9040713          	addi	a4,s0,-112
    800056ce:	84ce                	mv	s1,s3
    800056d0:	bf41                	j	80005660 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056d2:	20058713          	addi	a4,a1,512
    800056d6:	00471693          	slli	a3,a4,0x4
    800056da:	00019717          	auipc	a4,0x19
    800056de:	92670713          	addi	a4,a4,-1754 # 8001e000 <disk>
    800056e2:	9736                	add	a4,a4,a3
    800056e4:	4685                	li	a3,1
    800056e6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056ea:	20058713          	addi	a4,a1,512
    800056ee:	00471693          	slli	a3,a4,0x4
    800056f2:	00019717          	auipc	a4,0x19
    800056f6:	90e70713          	addi	a4,a4,-1778 # 8001e000 <disk>
    800056fa:	9736                	add	a4,a4,a3
    800056fc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005700:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005704:	7679                	lui	a2,0xffffe
    80005706:	963e                	add	a2,a2,a5
    80005708:	0001b697          	auipc	a3,0x1b
    8000570c:	8f868693          	addi	a3,a3,-1800 # 80020000 <disk+0x2000>
    80005710:	6298                	ld	a4,0(a3)
    80005712:	9732                	add	a4,a4,a2
    80005714:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005716:	6298                	ld	a4,0(a3)
    80005718:	9732                	add	a4,a4,a2
    8000571a:	4541                	li	a0,16
    8000571c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000571e:	6298                	ld	a4,0(a3)
    80005720:	9732                	add	a4,a4,a2
    80005722:	4505                	li	a0,1
    80005724:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005728:	f9442703          	lw	a4,-108(s0)
    8000572c:	6288                	ld	a0,0(a3)
    8000572e:	962a                	add	a2,a2,a0
    80005730:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005734:	0712                	slli	a4,a4,0x4
    80005736:	6290                	ld	a2,0(a3)
    80005738:	963a                	add	a2,a2,a4
    8000573a:	06090513          	addi	a0,s2,96
    8000573e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005740:	6294                	ld	a3,0(a3)
    80005742:	96ba                	add	a3,a3,a4
    80005744:	40000613          	li	a2,1024
    80005748:	c690                	sw	a2,8(a3)
  if(write)
    8000574a:	140d0063          	beqz	s10,8000588a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000574e:	0001b697          	auipc	a3,0x1b
    80005752:	8b26b683          	ld	a3,-1870(a3) # 80020000 <disk+0x2000>
    80005756:	96ba                	add	a3,a3,a4
    80005758:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000575c:	00019817          	auipc	a6,0x19
    80005760:	8a480813          	addi	a6,a6,-1884 # 8001e000 <disk>
    80005764:	0001b517          	auipc	a0,0x1b
    80005768:	89c50513          	addi	a0,a0,-1892 # 80020000 <disk+0x2000>
    8000576c:	6114                	ld	a3,0(a0)
    8000576e:	96ba                	add	a3,a3,a4
    80005770:	00c6d603          	lhu	a2,12(a3)
    80005774:	00166613          	ori	a2,a2,1
    80005778:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000577c:	f9842683          	lw	a3,-104(s0)
    80005780:	6110                	ld	a2,0(a0)
    80005782:	9732                	add	a4,a4,a2
    80005784:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005788:	20058613          	addi	a2,a1,512
    8000578c:	0612                	slli	a2,a2,0x4
    8000578e:	9642                	add	a2,a2,a6
    80005790:	577d                	li	a4,-1
    80005792:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005796:	00469713          	slli	a4,a3,0x4
    8000579a:	6114                	ld	a3,0(a0)
    8000579c:	96ba                	add	a3,a3,a4
    8000579e:	03078793          	addi	a5,a5,48
    800057a2:	97c2                	add	a5,a5,a6
    800057a4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800057a6:	611c                	ld	a5,0(a0)
    800057a8:	97ba                	add	a5,a5,a4
    800057aa:	4685                	li	a3,1
    800057ac:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057ae:	611c                	ld	a5,0(a0)
    800057b0:	97ba                	add	a5,a5,a4
    800057b2:	4809                	li	a6,2
    800057b4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800057b8:	611c                	ld	a5,0(a0)
    800057ba:	973e                	add	a4,a4,a5
    800057bc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057c0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800057c4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057c8:	6518                	ld	a4,8(a0)
    800057ca:	00275783          	lhu	a5,2(a4)
    800057ce:	8b9d                	andi	a5,a5,7
    800057d0:	0786                	slli	a5,a5,0x1
    800057d2:	97ba                	add	a5,a5,a4
    800057d4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800057d8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057dc:	6518                	ld	a4,8(a0)
    800057de:	00275783          	lhu	a5,2(a4)
    800057e2:	2785                	addiw	a5,a5,1
    800057e4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057e8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057ec:	100017b7          	lui	a5,0x10001
    800057f0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057f4:	00492703          	lw	a4,4(s2)
    800057f8:	4785                	li	a5,1
    800057fa:	02f71163          	bne	a4,a5,8000581c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800057fe:	0001b997          	auipc	s3,0x1b
    80005802:	92a98993          	addi	s3,s3,-1750 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005806:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005808:	85ce                	mv	a1,s3
    8000580a:	854a                	mv	a0,s2
    8000580c:	ffffc097          	auipc	ra,0xffffc
    80005810:	e16080e7          	jalr	-490(ra) # 80001622 <sleep>
  while(b->disk == 1) {
    80005814:	00492783          	lw	a5,4(s2)
    80005818:	fe9788e3          	beq	a5,s1,80005808 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000581c:	f9042903          	lw	s2,-112(s0)
    80005820:	20090793          	addi	a5,s2,512
    80005824:	00479713          	slli	a4,a5,0x4
    80005828:	00018797          	auipc	a5,0x18
    8000582c:	7d878793          	addi	a5,a5,2008 # 8001e000 <disk>
    80005830:	97ba                	add	a5,a5,a4
    80005832:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005836:	0001a997          	auipc	s3,0x1a
    8000583a:	7ca98993          	addi	s3,s3,1994 # 80020000 <disk+0x2000>
    8000583e:	00491713          	slli	a4,s2,0x4
    80005842:	0009b783          	ld	a5,0(s3)
    80005846:	97ba                	add	a5,a5,a4
    80005848:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000584c:	854a                	mv	a0,s2
    8000584e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005852:	00000097          	auipc	ra,0x0
    80005856:	bc4080e7          	jalr	-1084(ra) # 80005416 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000585a:	8885                	andi	s1,s1,1
    8000585c:	f0ed                	bnez	s1,8000583e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000585e:	0001b517          	auipc	a0,0x1b
    80005862:	8ca50513          	addi	a0,a0,-1846 # 80020128 <disk+0x2128>
    80005866:	00001097          	auipc	ra,0x1
    8000586a:	f8a080e7          	jalr	-118(ra) # 800067f0 <release>
}
    8000586e:	70a6                	ld	ra,104(sp)
    80005870:	7406                	ld	s0,96(sp)
    80005872:	64e6                	ld	s1,88(sp)
    80005874:	6946                	ld	s2,80(sp)
    80005876:	69a6                	ld	s3,72(sp)
    80005878:	6a06                	ld	s4,64(sp)
    8000587a:	7ae2                	ld	s5,56(sp)
    8000587c:	7b42                	ld	s6,48(sp)
    8000587e:	7ba2                	ld	s7,40(sp)
    80005880:	7c02                	ld	s8,32(sp)
    80005882:	6ce2                	ld	s9,24(sp)
    80005884:	6d42                	ld	s10,16(sp)
    80005886:	6165                	addi	sp,sp,112
    80005888:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000588a:	0001a697          	auipc	a3,0x1a
    8000588e:	7766b683          	ld	a3,1910(a3) # 80020000 <disk+0x2000>
    80005892:	96ba                	add	a3,a3,a4
    80005894:	4609                	li	a2,2
    80005896:	00c69623          	sh	a2,12(a3)
    8000589a:	b5c9                	j	8000575c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000589c:	f9042583          	lw	a1,-112(s0)
    800058a0:	20058793          	addi	a5,a1,512
    800058a4:	0792                	slli	a5,a5,0x4
    800058a6:	00019517          	auipc	a0,0x19
    800058aa:	80250513          	addi	a0,a0,-2046 # 8001e0a8 <disk+0xa8>
    800058ae:	953e                	add	a0,a0,a5
  if(write)
    800058b0:	e20d11e3          	bnez	s10,800056d2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800058b4:	20058713          	addi	a4,a1,512
    800058b8:	00471693          	slli	a3,a4,0x4
    800058bc:	00018717          	auipc	a4,0x18
    800058c0:	74470713          	addi	a4,a4,1860 # 8001e000 <disk>
    800058c4:	9736                	add	a4,a4,a3
    800058c6:	0a072423          	sw	zero,168(a4)
    800058ca:	b505                	j	800056ea <virtio_disk_rw+0xf4>

00000000800058cc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058cc:	1101                	addi	sp,sp,-32
    800058ce:	ec06                	sd	ra,24(sp)
    800058d0:	e822                	sd	s0,16(sp)
    800058d2:	e426                	sd	s1,8(sp)
    800058d4:	e04a                	sd	s2,0(sp)
    800058d6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058d8:	0001b517          	auipc	a0,0x1b
    800058dc:	85050513          	addi	a0,a0,-1968 # 80020128 <disk+0x2128>
    800058e0:	00001097          	auipc	ra,0x1
    800058e4:	e40080e7          	jalr	-448(ra) # 80006720 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058e8:	10001737          	lui	a4,0x10001
    800058ec:	533c                	lw	a5,96(a4)
    800058ee:	8b8d                	andi	a5,a5,3
    800058f0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058f2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058f6:	0001a797          	auipc	a5,0x1a
    800058fa:	70a78793          	addi	a5,a5,1802 # 80020000 <disk+0x2000>
    800058fe:	6b94                	ld	a3,16(a5)
    80005900:	0207d703          	lhu	a4,32(a5)
    80005904:	0026d783          	lhu	a5,2(a3)
    80005908:	06f70163          	beq	a4,a5,8000596a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000590c:	00018917          	auipc	s2,0x18
    80005910:	6f490913          	addi	s2,s2,1780 # 8001e000 <disk>
    80005914:	0001a497          	auipc	s1,0x1a
    80005918:	6ec48493          	addi	s1,s1,1772 # 80020000 <disk+0x2000>
    __sync_synchronize();
    8000591c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005920:	6898                	ld	a4,16(s1)
    80005922:	0204d783          	lhu	a5,32(s1)
    80005926:	8b9d                	andi	a5,a5,7
    80005928:	078e                	slli	a5,a5,0x3
    8000592a:	97ba                	add	a5,a5,a4
    8000592c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000592e:	20078713          	addi	a4,a5,512
    80005932:	0712                	slli	a4,a4,0x4
    80005934:	974a                	add	a4,a4,s2
    80005936:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000593a:	e731                	bnez	a4,80005986 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000593c:	20078793          	addi	a5,a5,512
    80005940:	0792                	slli	a5,a5,0x4
    80005942:	97ca                	add	a5,a5,s2
    80005944:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005946:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000594a:	ffffc097          	auipc	ra,0xffffc
    8000594e:	e64080e7          	jalr	-412(ra) # 800017ae <wakeup>

    disk.used_idx += 1;
    80005952:	0204d783          	lhu	a5,32(s1)
    80005956:	2785                	addiw	a5,a5,1
    80005958:	17c2                	slli	a5,a5,0x30
    8000595a:	93c1                	srli	a5,a5,0x30
    8000595c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005960:	6898                	ld	a4,16(s1)
    80005962:	00275703          	lhu	a4,2(a4)
    80005966:	faf71be3          	bne	a4,a5,8000591c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000596a:	0001a517          	auipc	a0,0x1a
    8000596e:	7be50513          	addi	a0,a0,1982 # 80020128 <disk+0x2128>
    80005972:	00001097          	auipc	ra,0x1
    80005976:	e7e080e7          	jalr	-386(ra) # 800067f0 <release>
}
    8000597a:	60e2                	ld	ra,24(sp)
    8000597c:	6442                	ld	s0,16(sp)
    8000597e:	64a2                	ld	s1,8(sp)
    80005980:	6902                	ld	s2,0(sp)
    80005982:	6105                	addi	sp,sp,32
    80005984:	8082                	ret
      panic("virtio_disk_intr status");
    80005986:	00003517          	auipc	a0,0x3
    8000598a:	e0a50513          	addi	a0,a0,-502 # 80008790 <syscalls+0x3c8>
    8000598e:	00001097          	auipc	ra,0x1
    80005992:	85e080e7          	jalr	-1954(ra) # 800061ec <panic>

0000000080005996 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005996:	1141                	addi	sp,sp,-16
    80005998:	e422                	sd	s0,8(sp)
    8000599a:	0800                	addi	s0,sp,16
  return -1;
}
    8000599c:	557d                	li	a0,-1
    8000599e:	6422                	ld	s0,8(sp)
    800059a0:	0141                	addi	sp,sp,16
    800059a2:	8082                	ret

00000000800059a4 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    800059a4:	7179                	addi	sp,sp,-48
    800059a6:	f406                	sd	ra,40(sp)
    800059a8:	f022                	sd	s0,32(sp)
    800059aa:	ec26                	sd	s1,24(sp)
    800059ac:	e84a                	sd	s2,16(sp)
    800059ae:	e44e                	sd	s3,8(sp)
    800059b0:	e052                	sd	s4,0(sp)
    800059b2:	1800                	addi	s0,sp,48
    800059b4:	892a                	mv	s2,a0
    800059b6:	89ae                	mv	s3,a1
    800059b8:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    800059ba:	0001b517          	auipc	a0,0x1b
    800059be:	64650513          	addi	a0,a0,1606 # 80021000 <stats>
    800059c2:	00001097          	auipc	ra,0x1
    800059c6:	d5e080e7          	jalr	-674(ra) # 80006720 <acquire>

  if(stats.sz == 0) {
    800059ca:	0001c797          	auipc	a5,0x1c
    800059ce:	6567a783          	lw	a5,1622(a5) # 80022020 <stats+0x1020>
    800059d2:	cbb5                	beqz	a5,80005a46 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    800059d4:	0001c797          	auipc	a5,0x1c
    800059d8:	62c78793          	addi	a5,a5,1580 # 80022000 <stats+0x1000>
    800059dc:	53d8                	lw	a4,36(a5)
    800059de:	539c                	lw	a5,32(a5)
    800059e0:	9f99                	subw	a5,a5,a4
    800059e2:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    800059e6:	06d05e63          	blez	a3,80005a62 <statsread+0xbe>
    if(m > n)
    800059ea:	8a3e                	mv	s4,a5
    800059ec:	00d4d363          	bge	s1,a3,800059f2 <statsread+0x4e>
    800059f0:	8a26                	mv	s4,s1
    800059f2:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    800059f6:	86a6                	mv	a3,s1
    800059f8:	0001b617          	auipc	a2,0x1b
    800059fc:	62860613          	addi	a2,a2,1576 # 80021020 <stats+0x20>
    80005a00:	963a                	add	a2,a2,a4
    80005a02:	85ce                	mv	a1,s3
    80005a04:	854a                	mv	a0,s2
    80005a06:	ffffc097          	auipc	ra,0xffffc
    80005a0a:	fc0080e7          	jalr	-64(ra) # 800019c6 <either_copyout>
    80005a0e:	57fd                	li	a5,-1
    80005a10:	00f50a63          	beq	a0,a5,80005a24 <statsread+0x80>
      stats.off += m;
    80005a14:	0001c717          	auipc	a4,0x1c
    80005a18:	5ec70713          	addi	a4,a4,1516 # 80022000 <stats+0x1000>
    80005a1c:	535c                	lw	a5,36(a4)
    80005a1e:	014787bb          	addw	a5,a5,s4
    80005a22:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005a24:	0001b517          	auipc	a0,0x1b
    80005a28:	5dc50513          	addi	a0,a0,1500 # 80021000 <stats>
    80005a2c:	00001097          	auipc	ra,0x1
    80005a30:	dc4080e7          	jalr	-572(ra) # 800067f0 <release>
  return m;
}
    80005a34:	8526                	mv	a0,s1
    80005a36:	70a2                	ld	ra,40(sp)
    80005a38:	7402                	ld	s0,32(sp)
    80005a3a:	64e2                	ld	s1,24(sp)
    80005a3c:	6942                	ld	s2,16(sp)
    80005a3e:	69a2                	ld	s3,8(sp)
    80005a40:	6a02                	ld	s4,0(sp)
    80005a42:	6145                	addi	sp,sp,48
    80005a44:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005a46:	6585                	lui	a1,0x1
    80005a48:	0001b517          	auipc	a0,0x1b
    80005a4c:	5d850513          	addi	a0,a0,1496 # 80021020 <stats+0x20>
    80005a50:	00001097          	auipc	ra,0x1
    80005a54:	f28080e7          	jalr	-216(ra) # 80006978 <statslock>
    80005a58:	0001c797          	auipc	a5,0x1c
    80005a5c:	5ca7a423          	sw	a0,1480(a5) # 80022020 <stats+0x1020>
    80005a60:	bf95                	j	800059d4 <statsread+0x30>
    stats.sz = 0;
    80005a62:	0001c797          	auipc	a5,0x1c
    80005a66:	59e78793          	addi	a5,a5,1438 # 80022000 <stats+0x1000>
    80005a6a:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005a6e:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005a72:	54fd                	li	s1,-1
    80005a74:	bf45                	j	80005a24 <statsread+0x80>

0000000080005a76 <statsinit>:

void
statsinit(void)
{
    80005a76:	1141                	addi	sp,sp,-16
    80005a78:	e406                	sd	ra,8(sp)
    80005a7a:	e022                	sd	s0,0(sp)
    80005a7c:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005a7e:	00003597          	auipc	a1,0x3
    80005a82:	d2a58593          	addi	a1,a1,-726 # 800087a8 <syscalls+0x3e0>
    80005a86:	0001b517          	auipc	a0,0x1b
    80005a8a:	57a50513          	addi	a0,a0,1402 # 80021000 <stats>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	e0e080e7          	jalr	-498(ra) # 8000689c <initlock>

  devsw[STATS].read = statsread;
    80005a96:	00017797          	auipc	a5,0x17
    80005a9a:	38278793          	addi	a5,a5,898 # 8001ce18 <devsw>
    80005a9e:	00000717          	auipc	a4,0x0
    80005aa2:	f0670713          	addi	a4,a4,-250 # 800059a4 <statsread>
    80005aa6:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005aa8:	00000717          	auipc	a4,0x0
    80005aac:	eee70713          	addi	a4,a4,-274 # 80005996 <statswrite>
    80005ab0:	f798                	sd	a4,40(a5)
}
    80005ab2:	60a2                	ld	ra,8(sp)
    80005ab4:	6402                	ld	s0,0(sp)
    80005ab6:	0141                	addi	sp,sp,16
    80005ab8:	8082                	ret

0000000080005aba <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005aba:	1101                	addi	sp,sp,-32
    80005abc:	ec22                	sd	s0,24(sp)
    80005abe:	1000                	addi	s0,sp,32
    80005ac0:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005ac2:	c299                	beqz	a3,80005ac8 <sprintint+0xe>
    80005ac4:	0805c163          	bltz	a1,80005b46 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005ac8:	2581                	sext.w	a1,a1
    80005aca:	4301                	li	t1,0

  i = 0;
    80005acc:	fe040713          	addi	a4,s0,-32
    80005ad0:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005ad2:	2601                	sext.w	a2,a2
    80005ad4:	00003697          	auipc	a3,0x3
    80005ad8:	cf468693          	addi	a3,a3,-780 # 800087c8 <digits>
    80005adc:	88aa                	mv	a7,a0
    80005ade:	2505                	addiw	a0,a0,1
    80005ae0:	02c5f7bb          	remuw	a5,a1,a2
    80005ae4:	1782                	slli	a5,a5,0x20
    80005ae6:	9381                	srli	a5,a5,0x20
    80005ae8:	97b6                	add	a5,a5,a3
    80005aea:	0007c783          	lbu	a5,0(a5)
    80005aee:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005af2:	0005879b          	sext.w	a5,a1
    80005af6:	02c5d5bb          	divuw	a1,a1,a2
    80005afa:	0705                	addi	a4,a4,1
    80005afc:	fec7f0e3          	bgeu	a5,a2,80005adc <sprintint+0x22>

  if(sign)
    80005b00:	00030b63          	beqz	t1,80005b16 <sprintint+0x5c>
    buf[i++] = '-';
    80005b04:	ff040793          	addi	a5,s0,-16
    80005b08:	97aa                	add	a5,a5,a0
    80005b0a:	02d00713          	li	a4,45
    80005b0e:	fee78823          	sb	a4,-16(a5)
    80005b12:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005b16:	02a05c63          	blez	a0,80005b4e <sprintint+0x94>
    80005b1a:	fe040793          	addi	a5,s0,-32
    80005b1e:	00a78733          	add	a4,a5,a0
    80005b22:	87c2                	mv	a5,a6
    80005b24:	0805                	addi	a6,a6,1
    80005b26:	fff5061b          	addiw	a2,a0,-1
    80005b2a:	1602                	slli	a2,a2,0x20
    80005b2c:	9201                	srli	a2,a2,0x20
    80005b2e:	9642                	add	a2,a2,a6
  *s = c;
    80005b30:	fff74683          	lbu	a3,-1(a4)
    80005b34:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005b38:	177d                	addi	a4,a4,-1
    80005b3a:	0785                	addi	a5,a5,1
    80005b3c:	fec79ae3          	bne	a5,a2,80005b30 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005b40:	6462                	ld	s0,24(sp)
    80005b42:	6105                	addi	sp,sp,32
    80005b44:	8082                	ret
    x = -xx;
    80005b46:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005b4a:	4305                	li	t1,1
    x = -xx;
    80005b4c:	b741                	j	80005acc <sprintint+0x12>
  while(--i >= 0)
    80005b4e:	4501                	li	a0,0
    80005b50:	bfc5                	j	80005b40 <sprintint+0x86>

0000000080005b52 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005b52:	7171                	addi	sp,sp,-176
    80005b54:	fc86                	sd	ra,120(sp)
    80005b56:	f8a2                	sd	s0,112(sp)
    80005b58:	f4a6                	sd	s1,104(sp)
    80005b5a:	f0ca                	sd	s2,96(sp)
    80005b5c:	ecce                	sd	s3,88(sp)
    80005b5e:	e8d2                	sd	s4,80(sp)
    80005b60:	e4d6                	sd	s5,72(sp)
    80005b62:	e0da                	sd	s6,64(sp)
    80005b64:	fc5e                	sd	s7,56(sp)
    80005b66:	f862                	sd	s8,48(sp)
    80005b68:	f466                	sd	s9,40(sp)
    80005b6a:	f06a                	sd	s10,32(sp)
    80005b6c:	ec6e                	sd	s11,24(sp)
    80005b6e:	0100                	addi	s0,sp,128
    80005b70:	e414                	sd	a3,8(s0)
    80005b72:	e818                	sd	a4,16(s0)
    80005b74:	ec1c                	sd	a5,24(s0)
    80005b76:	03043023          	sd	a6,32(s0)
    80005b7a:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005b7e:	ca0d                	beqz	a2,80005bb0 <snprintf+0x5e>
    80005b80:	8baa                	mv	s7,a0
    80005b82:	89ae                	mv	s3,a1
    80005b84:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005b86:	00840793          	addi	a5,s0,8
    80005b8a:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005b8e:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b90:	4901                	li	s2,0
    80005b92:	02b05763          	blez	a1,80005bc0 <snprintf+0x6e>
    if(c != '%'){
    80005b96:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005b9a:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005b9e:	02800d93          	li	s11,40
  *s = c;
    80005ba2:	02500d13          	li	s10,37
    switch(c){
    80005ba6:	07800c93          	li	s9,120
    80005baa:	06400c13          	li	s8,100
    80005bae:	a01d                	j	80005bd4 <snprintf+0x82>
    panic("null fmt");
    80005bb0:	00003517          	auipc	a0,0x3
    80005bb4:	c0850513          	addi	a0,a0,-1016 # 800087b8 <syscalls+0x3f0>
    80005bb8:	00000097          	auipc	ra,0x0
    80005bbc:	634080e7          	jalr	1588(ra) # 800061ec <panic>
  int off = 0;
    80005bc0:	4481                	li	s1,0
    80005bc2:	a86d                	j	80005c7c <snprintf+0x12a>
  *s = c;
    80005bc4:	009b8733          	add	a4,s7,s1
    80005bc8:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005bcc:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005bce:	2905                	addiw	s2,s2,1
    80005bd0:	0b34d663          	bge	s1,s3,80005c7c <snprintf+0x12a>
    80005bd4:	012a07b3          	add	a5,s4,s2
    80005bd8:	0007c783          	lbu	a5,0(a5)
    80005bdc:	0007871b          	sext.w	a4,a5
    80005be0:	cfd1                	beqz	a5,80005c7c <snprintf+0x12a>
    if(c != '%'){
    80005be2:	ff5711e3          	bne	a4,s5,80005bc4 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005be6:	2905                	addiw	s2,s2,1
    80005be8:	012a07b3          	add	a5,s4,s2
    80005bec:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005bf0:	c7d1                	beqz	a5,80005c7c <snprintf+0x12a>
    switch(c){
    80005bf2:	05678c63          	beq	a5,s6,80005c4a <snprintf+0xf8>
    80005bf6:	02fb6763          	bltu	s6,a5,80005c24 <snprintf+0xd2>
    80005bfa:	0b578763          	beq	a5,s5,80005ca8 <snprintf+0x156>
    80005bfe:	0b879b63          	bne	a5,s8,80005cb4 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005c02:	f8843783          	ld	a5,-120(s0)
    80005c06:	00878713          	addi	a4,a5,8
    80005c0a:	f8e43423          	sd	a4,-120(s0)
    80005c0e:	4685                	li	a3,1
    80005c10:	4629                	li	a2,10
    80005c12:	438c                	lw	a1,0(a5)
    80005c14:	009b8533          	add	a0,s7,s1
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	ea2080e7          	jalr	-350(ra) # 80005aba <sprintint>
    80005c20:	9ca9                	addw	s1,s1,a0
      break;
    80005c22:	b775                	j	80005bce <snprintf+0x7c>
    switch(c){
    80005c24:	09979863          	bne	a5,s9,80005cb4 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005c28:	f8843783          	ld	a5,-120(s0)
    80005c2c:	00878713          	addi	a4,a5,8
    80005c30:	f8e43423          	sd	a4,-120(s0)
    80005c34:	4685                	li	a3,1
    80005c36:	4641                	li	a2,16
    80005c38:	438c                	lw	a1,0(a5)
    80005c3a:	009b8533          	add	a0,s7,s1
    80005c3e:	00000097          	auipc	ra,0x0
    80005c42:	e7c080e7          	jalr	-388(ra) # 80005aba <sprintint>
    80005c46:	9ca9                	addw	s1,s1,a0
      break;
    80005c48:	b759                	j	80005bce <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005c4a:	f8843783          	ld	a5,-120(s0)
    80005c4e:	00878713          	addi	a4,a5,8
    80005c52:	f8e43423          	sd	a4,-120(s0)
    80005c56:	639c                	ld	a5,0(a5)
    80005c58:	c3b1                	beqz	a5,80005c9c <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005c5a:	0007c703          	lbu	a4,0(a5)
    80005c5e:	db25                	beqz	a4,80005bce <snprintf+0x7c>
    80005c60:	0134de63          	bge	s1,s3,80005c7c <snprintf+0x12a>
    80005c64:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005c68:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005c6c:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005c6e:	0785                	addi	a5,a5,1
    80005c70:	0007c703          	lbu	a4,0(a5)
    80005c74:	df29                	beqz	a4,80005bce <snprintf+0x7c>
    80005c76:	0685                	addi	a3,a3,1
    80005c78:	fe9998e3          	bne	s3,s1,80005c68 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005c7c:	8526                	mv	a0,s1
    80005c7e:	70e6                	ld	ra,120(sp)
    80005c80:	7446                	ld	s0,112(sp)
    80005c82:	74a6                	ld	s1,104(sp)
    80005c84:	7906                	ld	s2,96(sp)
    80005c86:	69e6                	ld	s3,88(sp)
    80005c88:	6a46                	ld	s4,80(sp)
    80005c8a:	6aa6                	ld	s5,72(sp)
    80005c8c:	6b06                	ld	s6,64(sp)
    80005c8e:	7be2                	ld	s7,56(sp)
    80005c90:	7c42                	ld	s8,48(sp)
    80005c92:	7ca2                	ld	s9,40(sp)
    80005c94:	7d02                	ld	s10,32(sp)
    80005c96:	6de2                	ld	s11,24(sp)
    80005c98:	614d                	addi	sp,sp,176
    80005c9a:	8082                	ret
        s = "(null)";
    80005c9c:	00003797          	auipc	a5,0x3
    80005ca0:	b1478793          	addi	a5,a5,-1260 # 800087b0 <syscalls+0x3e8>
      for(; *s && off < sz; s++)
    80005ca4:	876e                	mv	a4,s11
    80005ca6:	bf6d                	j	80005c60 <snprintf+0x10e>
  *s = c;
    80005ca8:	009b87b3          	add	a5,s7,s1
    80005cac:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005cb0:	2485                	addiw	s1,s1,1
      break;
    80005cb2:	bf31                	j	80005bce <snprintf+0x7c>
  *s = c;
    80005cb4:	009b8733          	add	a4,s7,s1
    80005cb8:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005cbc:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005cc0:	975e                	add	a4,a4,s7
    80005cc2:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005cc6:	2489                	addiw	s1,s1,2
      break;
    80005cc8:	b719                	j	80005bce <snprintf+0x7c>

0000000080005cca <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005cca:	1141                	addi	sp,sp,-16
    80005ccc:	e422                	sd	s0,8(sp)
    80005cce:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005cd0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005cd4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005cd8:	0037979b          	slliw	a5,a5,0x3
    80005cdc:	02004737          	lui	a4,0x2004
    80005ce0:	97ba                	add	a5,a5,a4
    80005ce2:	0200c737          	lui	a4,0x200c
    80005ce6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005cea:	000f4637          	lui	a2,0xf4
    80005cee:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005cf2:	95b2                	add	a1,a1,a2
    80005cf4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005cf6:	00269713          	slli	a4,a3,0x2
    80005cfa:	9736                	add	a4,a4,a3
    80005cfc:	00371693          	slli	a3,a4,0x3
    80005d00:	0001c717          	auipc	a4,0x1c
    80005d04:	33070713          	addi	a4,a4,816 # 80022030 <timer_scratch>
    80005d08:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005d0a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005d0c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005d0e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005d12:	fffff797          	auipc	a5,0xfffff
    80005d16:	63e78793          	addi	a5,a5,1598 # 80005350 <timervec>
    80005d1a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d1e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005d22:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d26:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005d2a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005d2e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005d32:	30479073          	csrw	mie,a5
}
    80005d36:	6422                	ld	s0,8(sp)
    80005d38:	0141                	addi	sp,sp,16
    80005d3a:	8082                	ret

0000000080005d3c <start>:
{
    80005d3c:	1141                	addi	sp,sp,-16
    80005d3e:	e406                	sd	ra,8(sp)
    80005d40:	e022                	sd	s0,0(sp)
    80005d42:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d44:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005d48:	7779                	lui	a4,0xffffe
    80005d4a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005d4e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005d50:	6705                	lui	a4,0x1
    80005d52:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005d56:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d58:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005d5c:	ffffa797          	auipc	a5,0xffffa
    80005d60:	6d878793          	addi	a5,a5,1752 # 80000434 <main>
    80005d64:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005d68:	4781                	li	a5,0
    80005d6a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005d6e:	67c1                	lui	a5,0x10
    80005d70:	17fd                	addi	a5,a5,-1
    80005d72:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005d76:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005d7a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005d7e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005d82:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005d86:	57fd                	li	a5,-1
    80005d88:	83a9                	srli	a5,a5,0xa
    80005d8a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005d8e:	47bd                	li	a5,15
    80005d90:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	f36080e7          	jalr	-202(ra) # 80005cca <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d9c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005da0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005da2:	823e                	mv	tp,a5
  asm volatile("mret");
    80005da4:	30200073          	mret
}
    80005da8:	60a2                	ld	ra,8(sp)
    80005daa:	6402                	ld	s0,0(sp)
    80005dac:	0141                	addi	sp,sp,16
    80005dae:	8082                	ret

0000000080005db0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005db0:	715d                	addi	sp,sp,-80
    80005db2:	e486                	sd	ra,72(sp)
    80005db4:	e0a2                	sd	s0,64(sp)
    80005db6:	fc26                	sd	s1,56(sp)
    80005db8:	f84a                	sd	s2,48(sp)
    80005dba:	f44e                	sd	s3,40(sp)
    80005dbc:	f052                	sd	s4,32(sp)
    80005dbe:	ec56                	sd	s5,24(sp)
    80005dc0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005dc2:	04c05663          	blez	a2,80005e0e <consolewrite+0x5e>
    80005dc6:	8a2a                	mv	s4,a0
    80005dc8:	84ae                	mv	s1,a1
    80005dca:	89b2                	mv	s3,a2
    80005dcc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005dce:	5afd                	li	s5,-1
    80005dd0:	4685                	li	a3,1
    80005dd2:	8626                	mv	a2,s1
    80005dd4:	85d2                	mv	a1,s4
    80005dd6:	fbf40513          	addi	a0,s0,-65
    80005dda:	ffffc097          	auipc	ra,0xffffc
    80005dde:	c42080e7          	jalr	-958(ra) # 80001a1c <either_copyin>
    80005de2:	01550c63          	beq	a0,s5,80005dfa <consolewrite+0x4a>
      break;
    uartputc(c);
    80005de6:	fbf44503          	lbu	a0,-65(s0)
    80005dea:	00000097          	auipc	ra,0x0
    80005dee:	78e080e7          	jalr	1934(ra) # 80006578 <uartputc>
  for(i = 0; i < n; i++){
    80005df2:	2905                	addiw	s2,s2,1
    80005df4:	0485                	addi	s1,s1,1
    80005df6:	fd299de3          	bne	s3,s2,80005dd0 <consolewrite+0x20>
  }

  return i;
}
    80005dfa:	854a                	mv	a0,s2
    80005dfc:	60a6                	ld	ra,72(sp)
    80005dfe:	6406                	ld	s0,64(sp)
    80005e00:	74e2                	ld	s1,56(sp)
    80005e02:	7942                	ld	s2,48(sp)
    80005e04:	79a2                	ld	s3,40(sp)
    80005e06:	7a02                	ld	s4,32(sp)
    80005e08:	6ae2                	ld	s5,24(sp)
    80005e0a:	6161                	addi	sp,sp,80
    80005e0c:	8082                	ret
  for(i = 0; i < n; i++){
    80005e0e:	4901                	li	s2,0
    80005e10:	b7ed                	j	80005dfa <consolewrite+0x4a>

0000000080005e12 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005e12:	7119                	addi	sp,sp,-128
    80005e14:	fc86                	sd	ra,120(sp)
    80005e16:	f8a2                	sd	s0,112(sp)
    80005e18:	f4a6                	sd	s1,104(sp)
    80005e1a:	f0ca                	sd	s2,96(sp)
    80005e1c:	ecce                	sd	s3,88(sp)
    80005e1e:	e8d2                	sd	s4,80(sp)
    80005e20:	e4d6                	sd	s5,72(sp)
    80005e22:	e0da                	sd	s6,64(sp)
    80005e24:	fc5e                	sd	s7,56(sp)
    80005e26:	f862                	sd	s8,48(sp)
    80005e28:	f466                	sd	s9,40(sp)
    80005e2a:	f06a                	sd	s10,32(sp)
    80005e2c:	ec6e                	sd	s11,24(sp)
    80005e2e:	0100                	addi	s0,sp,128
    80005e30:	8b2a                	mv	s6,a0
    80005e32:	8aae                	mv	s5,a1
    80005e34:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005e36:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005e3a:	00024517          	auipc	a0,0x24
    80005e3e:	33650513          	addi	a0,a0,822 # 8002a170 <cons>
    80005e42:	00001097          	auipc	ra,0x1
    80005e46:	8de080e7          	jalr	-1826(ra) # 80006720 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005e4a:	00024497          	auipc	s1,0x24
    80005e4e:	32648493          	addi	s1,s1,806 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005e52:	89a6                	mv	s3,s1
    80005e54:	00024917          	auipc	s2,0x24
    80005e58:	3bc90913          	addi	s2,s2,956 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005e5c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e5e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005e60:	4da9                	li	s11,10
  while(n > 0){
    80005e62:	07405863          	blez	s4,80005ed2 <consoleread+0xc0>
    while(cons.r == cons.w){
    80005e66:	0a04a783          	lw	a5,160(s1)
    80005e6a:	0a44a703          	lw	a4,164(s1)
    80005e6e:	02f71463          	bne	a4,a5,80005e96 <consoleread+0x84>
      if(myproc()->killed){
    80005e72:	ffffb097          	auipc	ra,0xffffb
    80005e76:	0f4080e7          	jalr	244(ra) # 80000f66 <myproc>
    80005e7a:	591c                	lw	a5,48(a0)
    80005e7c:	e7b5                	bnez	a5,80005ee8 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005e7e:	85ce                	mv	a1,s3
    80005e80:	854a                	mv	a0,s2
    80005e82:	ffffb097          	auipc	ra,0xffffb
    80005e86:	7a0080e7          	jalr	1952(ra) # 80001622 <sleep>
    while(cons.r == cons.w){
    80005e8a:	0a04a783          	lw	a5,160(s1)
    80005e8e:	0a44a703          	lw	a4,164(s1)
    80005e92:	fef700e3          	beq	a4,a5,80005e72 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005e96:	0017871b          	addiw	a4,a5,1
    80005e9a:	0ae4a023          	sw	a4,160(s1)
    80005e9e:	07f7f713          	andi	a4,a5,127
    80005ea2:	9726                	add	a4,a4,s1
    80005ea4:	02074703          	lbu	a4,32(a4)
    80005ea8:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005eac:	079c0663          	beq	s8,s9,80005f18 <consoleread+0x106>
    cbuf = c;
    80005eb0:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005eb4:	4685                	li	a3,1
    80005eb6:	f8f40613          	addi	a2,s0,-113
    80005eba:	85d6                	mv	a1,s5
    80005ebc:	855a                	mv	a0,s6
    80005ebe:	ffffc097          	auipc	ra,0xffffc
    80005ec2:	b08080e7          	jalr	-1272(ra) # 800019c6 <either_copyout>
    80005ec6:	01a50663          	beq	a0,s10,80005ed2 <consoleread+0xc0>
    dst++;
    80005eca:	0a85                	addi	s5,s5,1
    --n;
    80005ecc:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005ece:	f9bc1ae3          	bne	s8,s11,80005e62 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ed2:	00024517          	auipc	a0,0x24
    80005ed6:	29e50513          	addi	a0,a0,670 # 8002a170 <cons>
    80005eda:	00001097          	auipc	ra,0x1
    80005ede:	916080e7          	jalr	-1770(ra) # 800067f0 <release>

  return target - n;
    80005ee2:	414b853b          	subw	a0,s7,s4
    80005ee6:	a811                	j	80005efa <consoleread+0xe8>
        release(&cons.lock);
    80005ee8:	00024517          	auipc	a0,0x24
    80005eec:	28850513          	addi	a0,a0,648 # 8002a170 <cons>
    80005ef0:	00001097          	auipc	ra,0x1
    80005ef4:	900080e7          	jalr	-1792(ra) # 800067f0 <release>
        return -1;
    80005ef8:	557d                	li	a0,-1
}
    80005efa:	70e6                	ld	ra,120(sp)
    80005efc:	7446                	ld	s0,112(sp)
    80005efe:	74a6                	ld	s1,104(sp)
    80005f00:	7906                	ld	s2,96(sp)
    80005f02:	69e6                	ld	s3,88(sp)
    80005f04:	6a46                	ld	s4,80(sp)
    80005f06:	6aa6                	ld	s5,72(sp)
    80005f08:	6b06                	ld	s6,64(sp)
    80005f0a:	7be2                	ld	s7,56(sp)
    80005f0c:	7c42                	ld	s8,48(sp)
    80005f0e:	7ca2                	ld	s9,40(sp)
    80005f10:	7d02                	ld	s10,32(sp)
    80005f12:	6de2                	ld	s11,24(sp)
    80005f14:	6109                	addi	sp,sp,128
    80005f16:	8082                	ret
      if(n < target){
    80005f18:	000a071b          	sext.w	a4,s4
    80005f1c:	fb777be3          	bgeu	a4,s7,80005ed2 <consoleread+0xc0>
        cons.r--;
    80005f20:	00024717          	auipc	a4,0x24
    80005f24:	2ef72823          	sw	a5,752(a4) # 8002a210 <cons+0xa0>
    80005f28:	b76d                	j	80005ed2 <consoleread+0xc0>

0000000080005f2a <consputc>:
{
    80005f2a:	1141                	addi	sp,sp,-16
    80005f2c:	e406                	sd	ra,8(sp)
    80005f2e:	e022                	sd	s0,0(sp)
    80005f30:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005f32:	10000793          	li	a5,256
    80005f36:	00f50a63          	beq	a0,a5,80005f4a <consputc+0x20>
    uartputc_sync(c);
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	564080e7          	jalr	1380(ra) # 8000649e <uartputc_sync>
}
    80005f42:	60a2                	ld	ra,8(sp)
    80005f44:	6402                	ld	s0,0(sp)
    80005f46:	0141                	addi	sp,sp,16
    80005f48:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005f4a:	4521                	li	a0,8
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	552080e7          	jalr	1362(ra) # 8000649e <uartputc_sync>
    80005f54:	02000513          	li	a0,32
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	546080e7          	jalr	1350(ra) # 8000649e <uartputc_sync>
    80005f60:	4521                	li	a0,8
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	53c080e7          	jalr	1340(ra) # 8000649e <uartputc_sync>
    80005f6a:	bfe1                	j	80005f42 <consputc+0x18>

0000000080005f6c <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005f6c:	1101                	addi	sp,sp,-32
    80005f6e:	ec06                	sd	ra,24(sp)
    80005f70:	e822                	sd	s0,16(sp)
    80005f72:	e426                	sd	s1,8(sp)
    80005f74:	e04a                	sd	s2,0(sp)
    80005f76:	1000                	addi	s0,sp,32
    80005f78:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005f7a:	00024517          	auipc	a0,0x24
    80005f7e:	1f650513          	addi	a0,a0,502 # 8002a170 <cons>
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	79e080e7          	jalr	1950(ra) # 80006720 <acquire>

  switch(c){
    80005f8a:	47d5                	li	a5,21
    80005f8c:	0af48663          	beq	s1,a5,80006038 <consoleintr+0xcc>
    80005f90:	0297ca63          	blt	a5,s1,80005fc4 <consoleintr+0x58>
    80005f94:	47a1                	li	a5,8
    80005f96:	0ef48763          	beq	s1,a5,80006084 <consoleintr+0x118>
    80005f9a:	47c1                	li	a5,16
    80005f9c:	10f49a63          	bne	s1,a5,800060b0 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005fa0:	ffffc097          	auipc	ra,0xffffc
    80005fa4:	ad2080e7          	jalr	-1326(ra) # 80001a72 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005fa8:	00024517          	auipc	a0,0x24
    80005fac:	1c850513          	addi	a0,a0,456 # 8002a170 <cons>
    80005fb0:	00001097          	auipc	ra,0x1
    80005fb4:	840080e7          	jalr	-1984(ra) # 800067f0 <release>
}
    80005fb8:	60e2                	ld	ra,24(sp)
    80005fba:	6442                	ld	s0,16(sp)
    80005fbc:	64a2                	ld	s1,8(sp)
    80005fbe:	6902                	ld	s2,0(sp)
    80005fc0:	6105                	addi	sp,sp,32
    80005fc2:	8082                	ret
  switch(c){
    80005fc4:	07f00793          	li	a5,127
    80005fc8:	0af48e63          	beq	s1,a5,80006084 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005fcc:	00024717          	auipc	a4,0x24
    80005fd0:	1a470713          	addi	a4,a4,420 # 8002a170 <cons>
    80005fd4:	0a872783          	lw	a5,168(a4)
    80005fd8:	0a072703          	lw	a4,160(a4)
    80005fdc:	9f99                	subw	a5,a5,a4
    80005fde:	07f00713          	li	a4,127
    80005fe2:	fcf763e3          	bltu	a4,a5,80005fa8 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005fe6:	47b5                	li	a5,13
    80005fe8:	0cf48763          	beq	s1,a5,800060b6 <consoleintr+0x14a>
      consputc(c);
    80005fec:	8526                	mv	a0,s1
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	f3c080e7          	jalr	-196(ra) # 80005f2a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ff6:	00024797          	auipc	a5,0x24
    80005ffa:	17a78793          	addi	a5,a5,378 # 8002a170 <cons>
    80005ffe:	0a87a703          	lw	a4,168(a5)
    80006002:	0017069b          	addiw	a3,a4,1
    80006006:	0006861b          	sext.w	a2,a3
    8000600a:	0ad7a423          	sw	a3,168(a5)
    8000600e:	07f77713          	andi	a4,a4,127
    80006012:	97ba                	add	a5,a5,a4
    80006014:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006018:	47a9                	li	a5,10
    8000601a:	0cf48563          	beq	s1,a5,800060e4 <consoleintr+0x178>
    8000601e:	4791                	li	a5,4
    80006020:	0cf48263          	beq	s1,a5,800060e4 <consoleintr+0x178>
    80006024:	00024797          	auipc	a5,0x24
    80006028:	1ec7a783          	lw	a5,492(a5) # 8002a210 <cons+0xa0>
    8000602c:	0807879b          	addiw	a5,a5,128
    80006030:	f6f61ce3          	bne	a2,a5,80005fa8 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006034:	863e                	mv	a2,a5
    80006036:	a07d                	j	800060e4 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006038:	00024717          	auipc	a4,0x24
    8000603c:	13870713          	addi	a4,a4,312 # 8002a170 <cons>
    80006040:	0a872783          	lw	a5,168(a4)
    80006044:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006048:	00024497          	auipc	s1,0x24
    8000604c:	12848493          	addi	s1,s1,296 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80006050:	4929                	li	s2,10
    80006052:	f4f70be3          	beq	a4,a5,80005fa8 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006056:	37fd                	addiw	a5,a5,-1
    80006058:	07f7f713          	andi	a4,a5,127
    8000605c:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000605e:	02074703          	lbu	a4,32(a4)
    80006062:	f52703e3          	beq	a4,s2,80005fa8 <consoleintr+0x3c>
      cons.e--;
    80006066:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    8000606a:	10000513          	li	a0,256
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	ebc080e7          	jalr	-324(ra) # 80005f2a <consputc>
    while(cons.e != cons.w &&
    80006076:	0a84a783          	lw	a5,168(s1)
    8000607a:	0a44a703          	lw	a4,164(s1)
    8000607e:	fcf71ce3          	bne	a4,a5,80006056 <consoleintr+0xea>
    80006082:	b71d                	j	80005fa8 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006084:	00024717          	auipc	a4,0x24
    80006088:	0ec70713          	addi	a4,a4,236 # 8002a170 <cons>
    8000608c:	0a872783          	lw	a5,168(a4)
    80006090:	0a472703          	lw	a4,164(a4)
    80006094:	f0f70ae3          	beq	a4,a5,80005fa8 <consoleintr+0x3c>
      cons.e--;
    80006098:	37fd                	addiw	a5,a5,-1
    8000609a:	00024717          	auipc	a4,0x24
    8000609e:	16f72f23          	sw	a5,382(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    800060a2:	10000513          	li	a0,256
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	e84080e7          	jalr	-380(ra) # 80005f2a <consputc>
    800060ae:	bded                	j	80005fa8 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800060b0:	ee048ce3          	beqz	s1,80005fa8 <consoleintr+0x3c>
    800060b4:	bf21                	j	80005fcc <consoleintr+0x60>
      consputc(c);
    800060b6:	4529                	li	a0,10
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	e72080e7          	jalr	-398(ra) # 80005f2a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800060c0:	00024797          	auipc	a5,0x24
    800060c4:	0b078793          	addi	a5,a5,176 # 8002a170 <cons>
    800060c8:	0a87a703          	lw	a4,168(a5)
    800060cc:	0017069b          	addiw	a3,a4,1
    800060d0:	0006861b          	sext.w	a2,a3
    800060d4:	0ad7a423          	sw	a3,168(a5)
    800060d8:	07f77713          	andi	a4,a4,127
    800060dc:	97ba                	add	a5,a5,a4
    800060de:	4729                	li	a4,10
    800060e0:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    800060e4:	00024797          	auipc	a5,0x24
    800060e8:	12c7a823          	sw	a2,304(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    800060ec:	00024517          	auipc	a0,0x24
    800060f0:	12450513          	addi	a0,a0,292 # 8002a210 <cons+0xa0>
    800060f4:	ffffb097          	auipc	ra,0xffffb
    800060f8:	6ba080e7          	jalr	1722(ra) # 800017ae <wakeup>
    800060fc:	b575                	j	80005fa8 <consoleintr+0x3c>

00000000800060fe <consoleinit>:

void
consoleinit(void)
{
    800060fe:	1141                	addi	sp,sp,-16
    80006100:	e406                	sd	ra,8(sp)
    80006102:	e022                	sd	s0,0(sp)
    80006104:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006106:	00002597          	auipc	a1,0x2
    8000610a:	6da58593          	addi	a1,a1,1754 # 800087e0 <digits+0x18>
    8000610e:	00024517          	auipc	a0,0x24
    80006112:	06250513          	addi	a0,a0,98 # 8002a170 <cons>
    80006116:	00000097          	auipc	ra,0x0
    8000611a:	786080e7          	jalr	1926(ra) # 8000689c <initlock>

  uartinit();
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	330080e7          	jalr	816(ra) # 8000644e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006126:	00017797          	auipc	a5,0x17
    8000612a:	cf278793          	addi	a5,a5,-782 # 8001ce18 <devsw>
    8000612e:	00000717          	auipc	a4,0x0
    80006132:	ce470713          	addi	a4,a4,-796 # 80005e12 <consoleread>
    80006136:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006138:	00000717          	auipc	a4,0x0
    8000613c:	c7870713          	addi	a4,a4,-904 # 80005db0 <consolewrite>
    80006140:	ef98                	sd	a4,24(a5)
}
    80006142:	60a2                	ld	ra,8(sp)
    80006144:	6402                	ld	s0,0(sp)
    80006146:	0141                	addi	sp,sp,16
    80006148:	8082                	ret

000000008000614a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000614a:	7179                	addi	sp,sp,-48
    8000614c:	f406                	sd	ra,40(sp)
    8000614e:	f022                	sd	s0,32(sp)
    80006150:	ec26                	sd	s1,24(sp)
    80006152:	e84a                	sd	s2,16(sp)
    80006154:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006156:	c219                	beqz	a2,8000615c <printint+0x12>
    80006158:	08054663          	bltz	a0,800061e4 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000615c:	2501                	sext.w	a0,a0
    8000615e:	4881                	li	a7,0
    80006160:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006164:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006166:	2581                	sext.w	a1,a1
    80006168:	00002617          	auipc	a2,0x2
    8000616c:	69060613          	addi	a2,a2,1680 # 800087f8 <digits>
    80006170:	883a                	mv	a6,a4
    80006172:	2705                	addiw	a4,a4,1
    80006174:	02b577bb          	remuw	a5,a0,a1
    80006178:	1782                	slli	a5,a5,0x20
    8000617a:	9381                	srli	a5,a5,0x20
    8000617c:	97b2                	add	a5,a5,a2
    8000617e:	0007c783          	lbu	a5,0(a5)
    80006182:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006186:	0005079b          	sext.w	a5,a0
    8000618a:	02b5553b          	divuw	a0,a0,a1
    8000618e:	0685                	addi	a3,a3,1
    80006190:	feb7f0e3          	bgeu	a5,a1,80006170 <printint+0x26>

  if(sign)
    80006194:	00088b63          	beqz	a7,800061aa <printint+0x60>
    buf[i++] = '-';
    80006198:	fe040793          	addi	a5,s0,-32
    8000619c:	973e                	add	a4,a4,a5
    8000619e:	02d00793          	li	a5,45
    800061a2:	fef70823          	sb	a5,-16(a4)
    800061a6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800061aa:	02e05763          	blez	a4,800061d8 <printint+0x8e>
    800061ae:	fd040793          	addi	a5,s0,-48
    800061b2:	00e784b3          	add	s1,a5,a4
    800061b6:	fff78913          	addi	s2,a5,-1
    800061ba:	993a                	add	s2,s2,a4
    800061bc:	377d                	addiw	a4,a4,-1
    800061be:	1702                	slli	a4,a4,0x20
    800061c0:	9301                	srli	a4,a4,0x20
    800061c2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800061c6:	fff4c503          	lbu	a0,-1(s1)
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	d60080e7          	jalr	-672(ra) # 80005f2a <consputc>
  while(--i >= 0)
    800061d2:	14fd                	addi	s1,s1,-1
    800061d4:	ff2499e3          	bne	s1,s2,800061c6 <printint+0x7c>
}
    800061d8:	70a2                	ld	ra,40(sp)
    800061da:	7402                	ld	s0,32(sp)
    800061dc:	64e2                	ld	s1,24(sp)
    800061de:	6942                	ld	s2,16(sp)
    800061e0:	6145                	addi	sp,sp,48
    800061e2:	8082                	ret
    x = -xx;
    800061e4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800061e8:	4885                	li	a7,1
    x = -xx;
    800061ea:	bf9d                	j	80006160 <printint+0x16>

00000000800061ec <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
    800061f6:	84aa                	mv	s1,a0
  pr.locking = 0;
    800061f8:	00024797          	auipc	a5,0x24
    800061fc:	0407a423          	sw	zero,72(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    80006200:	00002517          	auipc	a0,0x2
    80006204:	5e850513          	addi	a0,a0,1512 # 800087e8 <digits+0x20>
    80006208:	00000097          	auipc	ra,0x0
    8000620c:	02e080e7          	jalr	46(ra) # 80006236 <printf>
  printf(s);
    80006210:	8526                	mv	a0,s1
    80006212:	00000097          	auipc	ra,0x0
    80006216:	024080e7          	jalr	36(ra) # 80006236 <printf>
  printf("\n");
    8000621a:	00002517          	auipc	a0,0x2
    8000621e:	66650513          	addi	a0,a0,1638 # 80008880 <digits+0x88>
    80006222:	00000097          	auipc	ra,0x0
    80006226:	014080e7          	jalr	20(ra) # 80006236 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000622a:	4785                	li	a5,1
    8000622c:	00003717          	auipc	a4,0x3
    80006230:	def72823          	sw	a5,-528(a4) # 8000901c <panicked>
  for(;;)
    80006234:	a001                	j	80006234 <panic+0x48>

0000000080006236 <printf>:
{
    80006236:	7131                	addi	sp,sp,-192
    80006238:	fc86                	sd	ra,120(sp)
    8000623a:	f8a2                	sd	s0,112(sp)
    8000623c:	f4a6                	sd	s1,104(sp)
    8000623e:	f0ca                	sd	s2,96(sp)
    80006240:	ecce                	sd	s3,88(sp)
    80006242:	e8d2                	sd	s4,80(sp)
    80006244:	e4d6                	sd	s5,72(sp)
    80006246:	e0da                	sd	s6,64(sp)
    80006248:	fc5e                	sd	s7,56(sp)
    8000624a:	f862                	sd	s8,48(sp)
    8000624c:	f466                	sd	s9,40(sp)
    8000624e:	f06a                	sd	s10,32(sp)
    80006250:	ec6e                	sd	s11,24(sp)
    80006252:	0100                	addi	s0,sp,128
    80006254:	8a2a                	mv	s4,a0
    80006256:	e40c                	sd	a1,8(s0)
    80006258:	e810                	sd	a2,16(s0)
    8000625a:	ec14                	sd	a3,24(s0)
    8000625c:	f018                	sd	a4,32(s0)
    8000625e:	f41c                	sd	a5,40(s0)
    80006260:	03043823          	sd	a6,48(s0)
    80006264:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006268:	00024d97          	auipc	s11,0x24
    8000626c:	fd8dad83          	lw	s11,-40(s11) # 8002a240 <pr+0x20>
  if(locking)
    80006270:	020d9b63          	bnez	s11,800062a6 <printf+0x70>
  if (fmt == 0)
    80006274:	040a0263          	beqz	s4,800062b8 <printf+0x82>
  va_start(ap, fmt);
    80006278:	00840793          	addi	a5,s0,8
    8000627c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006280:	000a4503          	lbu	a0,0(s4)
    80006284:	16050263          	beqz	a0,800063e8 <printf+0x1b2>
    80006288:	4481                	li	s1,0
    if(c != '%'){
    8000628a:	02500a93          	li	s5,37
    switch(c){
    8000628e:	07000b13          	li	s6,112
  consputc('x');
    80006292:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006294:	00002b97          	auipc	s7,0x2
    80006298:	564b8b93          	addi	s7,s7,1380 # 800087f8 <digits>
    switch(c){
    8000629c:	07300c93          	li	s9,115
    800062a0:	06400c13          	li	s8,100
    800062a4:	a82d                	j	800062de <printf+0xa8>
    acquire(&pr.lock);
    800062a6:	00024517          	auipc	a0,0x24
    800062aa:	f7a50513          	addi	a0,a0,-134 # 8002a220 <pr>
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	472080e7          	jalr	1138(ra) # 80006720 <acquire>
    800062b6:	bf7d                	j	80006274 <printf+0x3e>
    panic("null fmt");
    800062b8:	00002517          	auipc	a0,0x2
    800062bc:	50050513          	addi	a0,a0,1280 # 800087b8 <syscalls+0x3f0>
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	f2c080e7          	jalr	-212(ra) # 800061ec <panic>
      consputc(c);
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	c62080e7          	jalr	-926(ra) # 80005f2a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800062d0:	2485                	addiw	s1,s1,1
    800062d2:	009a07b3          	add	a5,s4,s1
    800062d6:	0007c503          	lbu	a0,0(a5)
    800062da:	10050763          	beqz	a0,800063e8 <printf+0x1b2>
    if(c != '%'){
    800062de:	ff5515e3          	bne	a0,s5,800062c8 <printf+0x92>
    c = fmt[++i] & 0xff;
    800062e2:	2485                	addiw	s1,s1,1
    800062e4:	009a07b3          	add	a5,s4,s1
    800062e8:	0007c783          	lbu	a5,0(a5)
    800062ec:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800062f0:	cfe5                	beqz	a5,800063e8 <printf+0x1b2>
    switch(c){
    800062f2:	05678a63          	beq	a5,s6,80006346 <printf+0x110>
    800062f6:	02fb7663          	bgeu	s6,a5,80006322 <printf+0xec>
    800062fa:	09978963          	beq	a5,s9,8000638c <printf+0x156>
    800062fe:	07800713          	li	a4,120
    80006302:	0ce79863          	bne	a5,a4,800063d2 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006306:	f8843783          	ld	a5,-120(s0)
    8000630a:	00878713          	addi	a4,a5,8
    8000630e:	f8e43423          	sd	a4,-120(s0)
    80006312:	4605                	li	a2,1
    80006314:	85ea                	mv	a1,s10
    80006316:	4388                	lw	a0,0(a5)
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	e32080e7          	jalr	-462(ra) # 8000614a <printint>
      break;
    80006320:	bf45                	j	800062d0 <printf+0x9a>
    switch(c){
    80006322:	0b578263          	beq	a5,s5,800063c6 <printf+0x190>
    80006326:	0b879663          	bne	a5,s8,800063d2 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000632a:	f8843783          	ld	a5,-120(s0)
    8000632e:	00878713          	addi	a4,a5,8
    80006332:	f8e43423          	sd	a4,-120(s0)
    80006336:	4605                	li	a2,1
    80006338:	45a9                	li	a1,10
    8000633a:	4388                	lw	a0,0(a5)
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	e0e080e7          	jalr	-498(ra) # 8000614a <printint>
      break;
    80006344:	b771                	j	800062d0 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006346:	f8843783          	ld	a5,-120(s0)
    8000634a:	00878713          	addi	a4,a5,8
    8000634e:	f8e43423          	sd	a4,-120(s0)
    80006352:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006356:	03000513          	li	a0,48
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	bd0080e7          	jalr	-1072(ra) # 80005f2a <consputc>
  consputc('x');
    80006362:	07800513          	li	a0,120
    80006366:	00000097          	auipc	ra,0x0
    8000636a:	bc4080e7          	jalr	-1084(ra) # 80005f2a <consputc>
    8000636e:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006370:	03c9d793          	srli	a5,s3,0x3c
    80006374:	97de                	add	a5,a5,s7
    80006376:	0007c503          	lbu	a0,0(a5)
    8000637a:	00000097          	auipc	ra,0x0
    8000637e:	bb0080e7          	jalr	-1104(ra) # 80005f2a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006382:	0992                	slli	s3,s3,0x4
    80006384:	397d                	addiw	s2,s2,-1
    80006386:	fe0915e3          	bnez	s2,80006370 <printf+0x13a>
    8000638a:	b799                	j	800062d0 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000638c:	f8843783          	ld	a5,-120(s0)
    80006390:	00878713          	addi	a4,a5,8
    80006394:	f8e43423          	sd	a4,-120(s0)
    80006398:	0007b903          	ld	s2,0(a5)
    8000639c:	00090e63          	beqz	s2,800063b8 <printf+0x182>
      for(; *s; s++)
    800063a0:	00094503          	lbu	a0,0(s2)
    800063a4:	d515                	beqz	a0,800062d0 <printf+0x9a>
        consputc(*s);
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	b84080e7          	jalr	-1148(ra) # 80005f2a <consputc>
      for(; *s; s++)
    800063ae:	0905                	addi	s2,s2,1
    800063b0:	00094503          	lbu	a0,0(s2)
    800063b4:	f96d                	bnez	a0,800063a6 <printf+0x170>
    800063b6:	bf29                	j	800062d0 <printf+0x9a>
        s = "(null)";
    800063b8:	00002917          	auipc	s2,0x2
    800063bc:	3f890913          	addi	s2,s2,1016 # 800087b0 <syscalls+0x3e8>
      for(; *s; s++)
    800063c0:	02800513          	li	a0,40
    800063c4:	b7cd                	j	800063a6 <printf+0x170>
      consputc('%');
    800063c6:	8556                	mv	a0,s5
    800063c8:	00000097          	auipc	ra,0x0
    800063cc:	b62080e7          	jalr	-1182(ra) # 80005f2a <consputc>
      break;
    800063d0:	b701                	j	800062d0 <printf+0x9a>
      consputc('%');
    800063d2:	8556                	mv	a0,s5
    800063d4:	00000097          	auipc	ra,0x0
    800063d8:	b56080e7          	jalr	-1194(ra) # 80005f2a <consputc>
      consputc(c);
    800063dc:	854a                	mv	a0,s2
    800063de:	00000097          	auipc	ra,0x0
    800063e2:	b4c080e7          	jalr	-1204(ra) # 80005f2a <consputc>
      break;
    800063e6:	b5ed                	j	800062d0 <printf+0x9a>
  if(locking)
    800063e8:	020d9163          	bnez	s11,8000640a <printf+0x1d4>
}
    800063ec:	70e6                	ld	ra,120(sp)
    800063ee:	7446                	ld	s0,112(sp)
    800063f0:	74a6                	ld	s1,104(sp)
    800063f2:	7906                	ld	s2,96(sp)
    800063f4:	69e6                	ld	s3,88(sp)
    800063f6:	6a46                	ld	s4,80(sp)
    800063f8:	6aa6                	ld	s5,72(sp)
    800063fa:	6b06                	ld	s6,64(sp)
    800063fc:	7be2                	ld	s7,56(sp)
    800063fe:	7c42                	ld	s8,48(sp)
    80006400:	7ca2                	ld	s9,40(sp)
    80006402:	7d02                	ld	s10,32(sp)
    80006404:	6de2                	ld	s11,24(sp)
    80006406:	6129                	addi	sp,sp,192
    80006408:	8082                	ret
    release(&pr.lock);
    8000640a:	00024517          	auipc	a0,0x24
    8000640e:	e1650513          	addi	a0,a0,-490 # 8002a220 <pr>
    80006412:	00000097          	auipc	ra,0x0
    80006416:	3de080e7          	jalr	990(ra) # 800067f0 <release>
}
    8000641a:	bfc9                	j	800063ec <printf+0x1b6>

000000008000641c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000641c:	1101                	addi	sp,sp,-32
    8000641e:	ec06                	sd	ra,24(sp)
    80006420:	e822                	sd	s0,16(sp)
    80006422:	e426                	sd	s1,8(sp)
    80006424:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006426:	00024497          	auipc	s1,0x24
    8000642a:	dfa48493          	addi	s1,s1,-518 # 8002a220 <pr>
    8000642e:	00002597          	auipc	a1,0x2
    80006432:	3c258593          	addi	a1,a1,962 # 800087f0 <digits+0x28>
    80006436:	8526                	mv	a0,s1
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	464080e7          	jalr	1124(ra) # 8000689c <initlock>
  pr.locking = 1;
    80006440:	4785                	li	a5,1
    80006442:	d09c                	sw	a5,32(s1)
}
    80006444:	60e2                	ld	ra,24(sp)
    80006446:	6442                	ld	s0,16(sp)
    80006448:	64a2                	ld	s1,8(sp)
    8000644a:	6105                	addi	sp,sp,32
    8000644c:	8082                	ret

000000008000644e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000644e:	1141                	addi	sp,sp,-16
    80006450:	e406                	sd	ra,8(sp)
    80006452:	e022                	sd	s0,0(sp)
    80006454:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006456:	100007b7          	lui	a5,0x10000
    8000645a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000645e:	f8000713          	li	a4,-128
    80006462:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006466:	470d                	li	a4,3
    80006468:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000646c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006470:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006474:	469d                	li	a3,7
    80006476:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000647a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000647e:	00002597          	auipc	a1,0x2
    80006482:	39258593          	addi	a1,a1,914 # 80008810 <digits+0x18>
    80006486:	00024517          	auipc	a0,0x24
    8000648a:	dc250513          	addi	a0,a0,-574 # 8002a248 <uart_tx_lock>
    8000648e:	00000097          	auipc	ra,0x0
    80006492:	40e080e7          	jalr	1038(ra) # 8000689c <initlock>
}
    80006496:	60a2                	ld	ra,8(sp)
    80006498:	6402                	ld	s0,0(sp)
    8000649a:	0141                	addi	sp,sp,16
    8000649c:	8082                	ret

000000008000649e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000649e:	1101                	addi	sp,sp,-32
    800064a0:	ec06                	sd	ra,24(sp)
    800064a2:	e822                	sd	s0,16(sp)
    800064a4:	e426                	sd	s1,8(sp)
    800064a6:	1000                	addi	s0,sp,32
    800064a8:	84aa                	mv	s1,a0
  push_off();
    800064aa:	00000097          	auipc	ra,0x0
    800064ae:	22a080e7          	jalr	554(ra) # 800066d4 <push_off>

  if(panicked){
    800064b2:	00003797          	auipc	a5,0x3
    800064b6:	b6a7a783          	lw	a5,-1174(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800064ba:	10000737          	lui	a4,0x10000
  if(panicked){
    800064be:	c391                	beqz	a5,800064c2 <uartputc_sync+0x24>
    for(;;)
    800064c0:	a001                	j	800064c0 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800064c2:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800064c6:	0ff7f793          	andi	a5,a5,255
    800064ca:	0207f793          	andi	a5,a5,32
    800064ce:	dbf5                	beqz	a5,800064c2 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800064d0:	0ff4f793          	andi	a5,s1,255
    800064d4:	10000737          	lui	a4,0x10000
    800064d8:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800064dc:	00000097          	auipc	ra,0x0
    800064e0:	2b4080e7          	jalr	692(ra) # 80006790 <pop_off>
}
    800064e4:	60e2                	ld	ra,24(sp)
    800064e6:	6442                	ld	s0,16(sp)
    800064e8:	64a2                	ld	s1,8(sp)
    800064ea:	6105                	addi	sp,sp,32
    800064ec:	8082                	ret

00000000800064ee <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800064ee:	00003717          	auipc	a4,0x3
    800064f2:	b3273703          	ld	a4,-1230(a4) # 80009020 <uart_tx_r>
    800064f6:	00003797          	auipc	a5,0x3
    800064fa:	b327b783          	ld	a5,-1230(a5) # 80009028 <uart_tx_w>
    800064fe:	06e78c63          	beq	a5,a4,80006576 <uartstart+0x88>
{
    80006502:	7139                	addi	sp,sp,-64
    80006504:	fc06                	sd	ra,56(sp)
    80006506:	f822                	sd	s0,48(sp)
    80006508:	f426                	sd	s1,40(sp)
    8000650a:	f04a                	sd	s2,32(sp)
    8000650c:	ec4e                	sd	s3,24(sp)
    8000650e:	e852                	sd	s4,16(sp)
    80006510:	e456                	sd	s5,8(sp)
    80006512:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006514:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006518:	00024a17          	auipc	s4,0x24
    8000651c:	d30a0a13          	addi	s4,s4,-720 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    80006520:	00003497          	auipc	s1,0x3
    80006524:	b0048493          	addi	s1,s1,-1280 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006528:	00003997          	auipc	s3,0x3
    8000652c:	b0098993          	addi	s3,s3,-1280 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006530:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006534:	0ff7f793          	andi	a5,a5,255
    80006538:	0207f793          	andi	a5,a5,32
    8000653c:	c785                	beqz	a5,80006564 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000653e:	01f77793          	andi	a5,a4,31
    80006542:	97d2                	add	a5,a5,s4
    80006544:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    80006548:	0705                	addi	a4,a4,1
    8000654a:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000654c:	8526                	mv	a0,s1
    8000654e:	ffffb097          	auipc	ra,0xffffb
    80006552:	260080e7          	jalr	608(ra) # 800017ae <wakeup>
    
    WriteReg(THR, c);
    80006556:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000655a:	6098                	ld	a4,0(s1)
    8000655c:	0009b783          	ld	a5,0(s3)
    80006560:	fce798e3          	bne	a5,a4,80006530 <uartstart+0x42>
  }
}
    80006564:	70e2                	ld	ra,56(sp)
    80006566:	7442                	ld	s0,48(sp)
    80006568:	74a2                	ld	s1,40(sp)
    8000656a:	7902                	ld	s2,32(sp)
    8000656c:	69e2                	ld	s3,24(sp)
    8000656e:	6a42                	ld	s4,16(sp)
    80006570:	6aa2                	ld	s5,8(sp)
    80006572:	6121                	addi	sp,sp,64
    80006574:	8082                	ret
    80006576:	8082                	ret

0000000080006578 <uartputc>:
{
    80006578:	7179                	addi	sp,sp,-48
    8000657a:	f406                	sd	ra,40(sp)
    8000657c:	f022                	sd	s0,32(sp)
    8000657e:	ec26                	sd	s1,24(sp)
    80006580:	e84a                	sd	s2,16(sp)
    80006582:	e44e                	sd	s3,8(sp)
    80006584:	e052                	sd	s4,0(sp)
    80006586:	1800                	addi	s0,sp,48
    80006588:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000658a:	00024517          	auipc	a0,0x24
    8000658e:	cbe50513          	addi	a0,a0,-834 # 8002a248 <uart_tx_lock>
    80006592:	00000097          	auipc	ra,0x0
    80006596:	18e080e7          	jalr	398(ra) # 80006720 <acquire>
  if(panicked){
    8000659a:	00003797          	auipc	a5,0x3
    8000659e:	a827a783          	lw	a5,-1406(a5) # 8000901c <panicked>
    800065a2:	c391                	beqz	a5,800065a6 <uartputc+0x2e>
    for(;;)
    800065a4:	a001                	j	800065a4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065a6:	00003797          	auipc	a5,0x3
    800065aa:	a827b783          	ld	a5,-1406(a5) # 80009028 <uart_tx_w>
    800065ae:	00003717          	auipc	a4,0x3
    800065b2:	a7273703          	ld	a4,-1422(a4) # 80009020 <uart_tx_r>
    800065b6:	02070713          	addi	a4,a4,32
    800065ba:	02f71b63          	bne	a4,a5,800065f0 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800065be:	00024a17          	auipc	s4,0x24
    800065c2:	c8aa0a13          	addi	s4,s4,-886 # 8002a248 <uart_tx_lock>
    800065c6:	00003497          	auipc	s1,0x3
    800065ca:	a5a48493          	addi	s1,s1,-1446 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065ce:	00003917          	auipc	s2,0x3
    800065d2:	a5a90913          	addi	s2,s2,-1446 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800065d6:	85d2                	mv	a1,s4
    800065d8:	8526                	mv	a0,s1
    800065da:	ffffb097          	auipc	ra,0xffffb
    800065de:	048080e7          	jalr	72(ra) # 80001622 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065e2:	00093783          	ld	a5,0(s2)
    800065e6:	6098                	ld	a4,0(s1)
    800065e8:	02070713          	addi	a4,a4,32
    800065ec:	fef705e3          	beq	a4,a5,800065d6 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800065f0:	00024497          	auipc	s1,0x24
    800065f4:	c5848493          	addi	s1,s1,-936 # 8002a248 <uart_tx_lock>
    800065f8:	01f7f713          	andi	a4,a5,31
    800065fc:	9726                	add	a4,a4,s1
    800065fe:	03370023          	sb	s3,32(a4)
      uart_tx_w += 1;
    80006602:	0785                	addi	a5,a5,1
    80006604:	00003717          	auipc	a4,0x3
    80006608:	a2f73223          	sd	a5,-1500(a4) # 80009028 <uart_tx_w>
      uartstart();
    8000660c:	00000097          	auipc	ra,0x0
    80006610:	ee2080e7          	jalr	-286(ra) # 800064ee <uartstart>
      release(&uart_tx_lock);
    80006614:	8526                	mv	a0,s1
    80006616:	00000097          	auipc	ra,0x0
    8000661a:	1da080e7          	jalr	474(ra) # 800067f0 <release>
}
    8000661e:	70a2                	ld	ra,40(sp)
    80006620:	7402                	ld	s0,32(sp)
    80006622:	64e2                	ld	s1,24(sp)
    80006624:	6942                	ld	s2,16(sp)
    80006626:	69a2                	ld	s3,8(sp)
    80006628:	6a02                	ld	s4,0(sp)
    8000662a:	6145                	addi	sp,sp,48
    8000662c:	8082                	ret

000000008000662e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000662e:	1141                	addi	sp,sp,-16
    80006630:	e422                	sd	s0,8(sp)
    80006632:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006634:	100007b7          	lui	a5,0x10000
    80006638:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000663c:	8b85                	andi	a5,a5,1
    8000663e:	cb91                	beqz	a5,80006652 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006640:	100007b7          	lui	a5,0x10000
    80006644:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006648:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000664c:	6422                	ld	s0,8(sp)
    8000664e:	0141                	addi	sp,sp,16
    80006650:	8082                	ret
    return -1;
    80006652:	557d                	li	a0,-1
    80006654:	bfe5                	j	8000664c <uartgetc+0x1e>

0000000080006656 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006656:	1101                	addi	sp,sp,-32
    80006658:	ec06                	sd	ra,24(sp)
    8000665a:	e822                	sd	s0,16(sp)
    8000665c:	e426                	sd	s1,8(sp)
    8000665e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006660:	54fd                	li	s1,-1
    int c = uartgetc();
    80006662:	00000097          	auipc	ra,0x0
    80006666:	fcc080e7          	jalr	-52(ra) # 8000662e <uartgetc>
    if(c == -1)
    8000666a:	00950763          	beq	a0,s1,80006678 <uartintr+0x22>
      break;
    consoleintr(c);
    8000666e:	00000097          	auipc	ra,0x0
    80006672:	8fe080e7          	jalr	-1794(ra) # 80005f6c <consoleintr>
  while(1){
    80006676:	b7f5                	j	80006662 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006678:	00024497          	auipc	s1,0x24
    8000667c:	bd048493          	addi	s1,s1,-1072 # 8002a248 <uart_tx_lock>
    80006680:	8526                	mv	a0,s1
    80006682:	00000097          	auipc	ra,0x0
    80006686:	09e080e7          	jalr	158(ra) # 80006720 <acquire>
  uartstart();
    8000668a:	00000097          	auipc	ra,0x0
    8000668e:	e64080e7          	jalr	-412(ra) # 800064ee <uartstart>
  release(&uart_tx_lock);
    80006692:	8526                	mv	a0,s1
    80006694:	00000097          	auipc	ra,0x0
    80006698:	15c080e7          	jalr	348(ra) # 800067f0 <release>
}
    8000669c:	60e2                	ld	ra,24(sp)
    8000669e:	6442                	ld	s0,16(sp)
    800066a0:	64a2                	ld	s1,8(sp)
    800066a2:	6105                	addi	sp,sp,32
    800066a4:	8082                	ret

00000000800066a6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800066a6:	411c                	lw	a5,0(a0)
    800066a8:	e399                	bnez	a5,800066ae <holding+0x8>
    800066aa:	4501                	li	a0,0
  return r;
}
    800066ac:	8082                	ret
{
    800066ae:	1101                	addi	sp,sp,-32
    800066b0:	ec06                	sd	ra,24(sp)
    800066b2:	e822                	sd	s0,16(sp)
    800066b4:	e426                	sd	s1,8(sp)
    800066b6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800066b8:	6904                	ld	s1,16(a0)
    800066ba:	ffffb097          	auipc	ra,0xffffb
    800066be:	890080e7          	jalr	-1904(ra) # 80000f4a <mycpu>
    800066c2:	40a48533          	sub	a0,s1,a0
    800066c6:	00153513          	seqz	a0,a0
}
    800066ca:	60e2                	ld	ra,24(sp)
    800066cc:	6442                	ld	s0,16(sp)
    800066ce:	64a2                	ld	s1,8(sp)
    800066d0:	6105                	addi	sp,sp,32
    800066d2:	8082                	ret

00000000800066d4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800066d4:	1101                	addi	sp,sp,-32
    800066d6:	ec06                	sd	ra,24(sp)
    800066d8:	e822                	sd	s0,16(sp)
    800066da:	e426                	sd	s1,8(sp)
    800066dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066de:	100024f3          	csrr	s1,sstatus
    800066e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800066e6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066e8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800066ec:	ffffb097          	auipc	ra,0xffffb
    800066f0:	85e080e7          	jalr	-1954(ra) # 80000f4a <mycpu>
    800066f4:	5d3c                	lw	a5,120(a0)
    800066f6:	cf89                	beqz	a5,80006710 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800066f8:	ffffb097          	auipc	ra,0xffffb
    800066fc:	852080e7          	jalr	-1966(ra) # 80000f4a <mycpu>
    80006700:	5d3c                	lw	a5,120(a0)
    80006702:	2785                	addiw	a5,a5,1
    80006704:	dd3c                	sw	a5,120(a0)
}
    80006706:	60e2                	ld	ra,24(sp)
    80006708:	6442                	ld	s0,16(sp)
    8000670a:	64a2                	ld	s1,8(sp)
    8000670c:	6105                	addi	sp,sp,32
    8000670e:	8082                	ret
    mycpu()->intena = old;
    80006710:	ffffb097          	auipc	ra,0xffffb
    80006714:	83a080e7          	jalr	-1990(ra) # 80000f4a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006718:	8085                	srli	s1,s1,0x1
    8000671a:	8885                	andi	s1,s1,1
    8000671c:	dd64                	sw	s1,124(a0)
    8000671e:	bfe9                	j	800066f8 <push_off+0x24>

0000000080006720 <acquire>:
{
    80006720:	1101                	addi	sp,sp,-32
    80006722:	ec06                	sd	ra,24(sp)
    80006724:	e822                	sd	s0,16(sp)
    80006726:	e426                	sd	s1,8(sp)
    80006728:	1000                	addi	s0,sp,32
    8000672a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000672c:	00000097          	auipc	ra,0x0
    80006730:	fa8080e7          	jalr	-88(ra) # 800066d4 <push_off>
  if(holding(lk))
    80006734:	8526                	mv	a0,s1
    80006736:	00000097          	auipc	ra,0x0
    8000673a:	f70080e7          	jalr	-144(ra) # 800066a6 <holding>
    8000673e:	e911                	bnez	a0,80006752 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    80006740:	4785                	li	a5,1
    80006742:	01c48713          	addi	a4,s1,28
    80006746:	0f50000f          	fence	iorw,ow
    8000674a:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000674e:	4705                	li	a4,1
    80006750:	a839                	j	8000676e <acquire+0x4e>
    panic("acquire");
    80006752:	00002517          	auipc	a0,0x2
    80006756:	0c650513          	addi	a0,a0,198 # 80008818 <digits+0x20>
    8000675a:	00000097          	auipc	ra,0x0
    8000675e:	a92080e7          	jalr	-1390(ra) # 800061ec <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006762:	01848793          	addi	a5,s1,24
    80006766:	0f50000f          	fence	iorw,ow
    8000676a:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000676e:	87ba                	mv	a5,a4
    80006770:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006774:	2781                	sext.w	a5,a5
    80006776:	f7f5                	bnez	a5,80006762 <acquire+0x42>
  __sync_synchronize();
    80006778:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000677c:	ffffa097          	auipc	ra,0xffffa
    80006780:	7ce080e7          	jalr	1998(ra) # 80000f4a <mycpu>
    80006784:	e888                	sd	a0,16(s1)
}
    80006786:	60e2                	ld	ra,24(sp)
    80006788:	6442                	ld	s0,16(sp)
    8000678a:	64a2                	ld	s1,8(sp)
    8000678c:	6105                	addi	sp,sp,32
    8000678e:	8082                	ret

0000000080006790 <pop_off>:

void
pop_off(void)
{
    80006790:	1141                	addi	sp,sp,-16
    80006792:	e406                	sd	ra,8(sp)
    80006794:	e022                	sd	s0,0(sp)
    80006796:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006798:	ffffa097          	auipc	ra,0xffffa
    8000679c:	7b2080e7          	jalr	1970(ra) # 80000f4a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067a0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800067a4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800067a6:	e78d                	bnez	a5,800067d0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800067a8:	5d3c                	lw	a5,120(a0)
    800067aa:	02f05b63          	blez	a5,800067e0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800067ae:	37fd                	addiw	a5,a5,-1
    800067b0:	0007871b          	sext.w	a4,a5
    800067b4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800067b6:	eb09                	bnez	a4,800067c8 <pop_off+0x38>
    800067b8:	5d7c                	lw	a5,124(a0)
    800067ba:	c799                	beqz	a5,800067c8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800067c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800067c4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800067c8:	60a2                	ld	ra,8(sp)
    800067ca:	6402                	ld	s0,0(sp)
    800067cc:	0141                	addi	sp,sp,16
    800067ce:	8082                	ret
    panic("pop_off - interruptible");
    800067d0:	00002517          	auipc	a0,0x2
    800067d4:	05050513          	addi	a0,a0,80 # 80008820 <digits+0x28>
    800067d8:	00000097          	auipc	ra,0x0
    800067dc:	a14080e7          	jalr	-1516(ra) # 800061ec <panic>
    panic("pop_off");
    800067e0:	00002517          	auipc	a0,0x2
    800067e4:	05850513          	addi	a0,a0,88 # 80008838 <digits+0x40>
    800067e8:	00000097          	auipc	ra,0x0
    800067ec:	a04080e7          	jalr	-1532(ra) # 800061ec <panic>

00000000800067f0 <release>:
{
    800067f0:	1101                	addi	sp,sp,-32
    800067f2:	ec06                	sd	ra,24(sp)
    800067f4:	e822                	sd	s0,16(sp)
    800067f6:	e426                	sd	s1,8(sp)
    800067f8:	1000                	addi	s0,sp,32
    800067fa:	84aa                	mv	s1,a0
  if(!holding(lk))
    800067fc:	00000097          	auipc	ra,0x0
    80006800:	eaa080e7          	jalr	-342(ra) # 800066a6 <holding>
    80006804:	c115                	beqz	a0,80006828 <release+0x38>
  lk->cpu = 0;
    80006806:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000680a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000680e:	0f50000f          	fence	iorw,ow
    80006812:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006816:	00000097          	auipc	ra,0x0
    8000681a:	f7a080e7          	jalr	-134(ra) # 80006790 <pop_off>
}
    8000681e:	60e2                	ld	ra,24(sp)
    80006820:	6442                	ld	s0,16(sp)
    80006822:	64a2                	ld	s1,8(sp)
    80006824:	6105                	addi	sp,sp,32
    80006826:	8082                	ret
    panic("release");
    80006828:	00002517          	auipc	a0,0x2
    8000682c:	01850513          	addi	a0,a0,24 # 80008840 <digits+0x48>
    80006830:	00000097          	auipc	ra,0x0
    80006834:	9bc080e7          	jalr	-1604(ra) # 800061ec <panic>

0000000080006838 <freelock>:
{
    80006838:	1101                	addi	sp,sp,-32
    8000683a:	ec06                	sd	ra,24(sp)
    8000683c:	e822                	sd	s0,16(sp)
    8000683e:	e426                	sd	s1,8(sp)
    80006840:	1000                	addi	s0,sp,32
    80006842:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    80006844:	00024517          	auipc	a0,0x24
    80006848:	a4450513          	addi	a0,a0,-1468 # 8002a288 <lock_locks>
    8000684c:	00000097          	auipc	ra,0x0
    80006850:	ed4080e7          	jalr	-300(ra) # 80006720 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006854:	00024717          	auipc	a4,0x24
    80006858:	a5470713          	addi	a4,a4,-1452 # 8002a2a8 <locks>
    8000685c:	4781                	li	a5,0
    8000685e:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006862:	6314                	ld	a3,0(a4)
    80006864:	00968763          	beq	a3,s1,80006872 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    80006868:	2785                	addiw	a5,a5,1
    8000686a:	0721                	addi	a4,a4,8
    8000686c:	fec79be3          	bne	a5,a2,80006862 <freelock+0x2a>
    80006870:	a809                	j	80006882 <freelock+0x4a>
      locks[i] = 0;
    80006872:	078e                	slli	a5,a5,0x3
    80006874:	00024717          	auipc	a4,0x24
    80006878:	a3470713          	addi	a4,a4,-1484 # 8002a2a8 <locks>
    8000687c:	97ba                	add	a5,a5,a4
    8000687e:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006882:	00024517          	auipc	a0,0x24
    80006886:	a0650513          	addi	a0,a0,-1530 # 8002a288 <lock_locks>
    8000688a:	00000097          	auipc	ra,0x0
    8000688e:	f66080e7          	jalr	-154(ra) # 800067f0 <release>
}
    80006892:	60e2                	ld	ra,24(sp)
    80006894:	6442                	ld	s0,16(sp)
    80006896:	64a2                	ld	s1,8(sp)
    80006898:	6105                	addi	sp,sp,32
    8000689a:	8082                	ret

000000008000689c <initlock>:
{
    8000689c:	1101                	addi	sp,sp,-32
    8000689e:	ec06                	sd	ra,24(sp)
    800068a0:	e822                	sd	s0,16(sp)
    800068a2:	e426                	sd	s1,8(sp)
    800068a4:	1000                	addi	s0,sp,32
    800068a6:	84aa                	mv	s1,a0
  lk->name = name;
    800068a8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800068aa:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800068ae:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800068b2:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    800068b6:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    800068ba:	00024517          	auipc	a0,0x24
    800068be:	9ce50513          	addi	a0,a0,-1586 # 8002a288 <lock_locks>
    800068c2:	00000097          	auipc	ra,0x0
    800068c6:	e5e080e7          	jalr	-418(ra) # 80006720 <acquire>
  for (i = 0; i < NLOCK; i++) {
    800068ca:	00024717          	auipc	a4,0x24
    800068ce:	9de70713          	addi	a4,a4,-1570 # 8002a2a8 <locks>
    800068d2:	4781                	li	a5,0
    800068d4:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    800068d8:	6310                	ld	a2,0(a4)
    800068da:	ce09                	beqz	a2,800068f4 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    800068dc:	2785                	addiw	a5,a5,1
    800068de:	0721                	addi	a4,a4,8
    800068e0:	fed79ce3          	bne	a5,a3,800068d8 <initlock+0x3c>
  panic("findslot");
    800068e4:	00002517          	auipc	a0,0x2
    800068e8:	f6450513          	addi	a0,a0,-156 # 80008848 <digits+0x50>
    800068ec:	00000097          	auipc	ra,0x0
    800068f0:	900080e7          	jalr	-1792(ra) # 800061ec <panic>
      locks[i] = lk;
    800068f4:	078e                	slli	a5,a5,0x3
    800068f6:	00024717          	auipc	a4,0x24
    800068fa:	9b270713          	addi	a4,a4,-1614 # 8002a2a8 <locks>
    800068fe:	97ba                	add	a5,a5,a4
    80006900:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006902:	00024517          	auipc	a0,0x24
    80006906:	98650513          	addi	a0,a0,-1658 # 8002a288 <lock_locks>
    8000690a:	00000097          	auipc	ra,0x0
    8000690e:	ee6080e7          	jalr	-282(ra) # 800067f0 <release>
}
    80006912:	60e2                	ld	ra,24(sp)
    80006914:	6442                	ld	s0,16(sp)
    80006916:	64a2                	ld	s1,8(sp)
    80006918:	6105                	addi	sp,sp,32
    8000691a:	8082                	ret

000000008000691c <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000691c:	1141                	addi	sp,sp,-16
    8000691e:	e422                	sd	s0,8(sp)
    80006920:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006922:	0ff0000f          	fence
    80006926:	6108                	ld	a0,0(a0)
    80006928:	0ff0000f          	fence
  return val;
}
    8000692c:	6422                	ld	s0,8(sp)
    8000692e:	0141                	addi	sp,sp,16
    80006930:	8082                	ret

0000000080006932 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006932:	1141                	addi	sp,sp,-16
    80006934:	e422                	sd	s0,8(sp)
    80006936:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006938:	0ff0000f          	fence
    8000693c:	4108                	lw	a0,0(a0)
    8000693e:	0ff0000f          	fence
  return val;
}
    80006942:	2501                	sext.w	a0,a0
    80006944:	6422                	ld	s0,8(sp)
    80006946:	0141                	addi	sp,sp,16
    80006948:	8082                	ret

000000008000694a <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000694a:	4e5c                	lw	a5,28(a2)
    8000694c:	00f04463          	bgtz	a5,80006954 <snprint_lock+0xa>
  int n = 0;
    80006950:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006952:	8082                	ret
{
    80006954:	1141                	addi	sp,sp,-16
    80006956:	e406                	sd	ra,8(sp)
    80006958:	e022                	sd	s0,0(sp)
    8000695a:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    8000695c:	4e18                	lw	a4,24(a2)
    8000695e:	6614                	ld	a3,8(a2)
    80006960:	00002617          	auipc	a2,0x2
    80006964:	ef860613          	addi	a2,a2,-264 # 80008858 <digits+0x60>
    80006968:	fffff097          	auipc	ra,0xfffff
    8000696c:	1ea080e7          	jalr	490(ra) # 80005b52 <snprintf>
}
    80006970:	60a2                	ld	ra,8(sp)
    80006972:	6402                	ld	s0,0(sp)
    80006974:	0141                	addi	sp,sp,16
    80006976:	8082                	ret

0000000080006978 <statslock>:

int
statslock(char *buf, int sz) {
    80006978:	7159                	addi	sp,sp,-112
    8000697a:	f486                	sd	ra,104(sp)
    8000697c:	f0a2                	sd	s0,96(sp)
    8000697e:	eca6                	sd	s1,88(sp)
    80006980:	e8ca                	sd	s2,80(sp)
    80006982:	e4ce                	sd	s3,72(sp)
    80006984:	e0d2                	sd	s4,64(sp)
    80006986:	fc56                	sd	s5,56(sp)
    80006988:	f85a                	sd	s6,48(sp)
    8000698a:	f45e                	sd	s7,40(sp)
    8000698c:	f062                	sd	s8,32(sp)
    8000698e:	ec66                	sd	s9,24(sp)
    80006990:	e86a                	sd	s10,16(sp)
    80006992:	e46e                	sd	s11,8(sp)
    80006994:	1880                	addi	s0,sp,112
    80006996:	8aaa                	mv	s5,a0
    80006998:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    8000699a:	00024517          	auipc	a0,0x24
    8000699e:	8ee50513          	addi	a0,a0,-1810 # 8002a288 <lock_locks>
    800069a2:	00000097          	auipc	ra,0x0
    800069a6:	d7e080e7          	jalr	-642(ra) # 80006720 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800069aa:	00002617          	auipc	a2,0x2
    800069ae:	ede60613          	addi	a2,a2,-290 # 80008888 <digits+0x90>
    800069b2:	85da                	mv	a1,s6
    800069b4:	8556                	mv	a0,s5
    800069b6:	fffff097          	auipc	ra,0xfffff
    800069ba:	19c080e7          	jalr	412(ra) # 80005b52 <snprintf>
    800069be:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    800069c0:	00024c97          	auipc	s9,0x24
    800069c4:	8e8c8c93          	addi	s9,s9,-1816 # 8002a2a8 <locks>
    800069c8:	00025c17          	auipc	s8,0x25
    800069cc:	880c0c13          	addi	s8,s8,-1920 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800069d0:	84e6                	mv	s1,s9
  int tot = 0;
    800069d2:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069d4:	00002b97          	auipc	s7,0x2
    800069d8:	ed4b8b93          	addi	s7,s7,-300 # 800088a8 <digits+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800069dc:	00002d17          	auipc	s10,0x2
    800069e0:	ed4d0d13          	addi	s10,s10,-300 # 800088b0 <digits+0xb8>
    800069e4:	a01d                	j	80006a0a <statslock+0x92>
      tot += locks[i]->nts;
    800069e6:	0009b603          	ld	a2,0(s3)
    800069ea:	4e1c                	lw	a5,24(a2)
    800069ec:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    800069f0:	412b05bb          	subw	a1,s6,s2
    800069f4:	012a8533          	add	a0,s5,s2
    800069f8:	00000097          	auipc	ra,0x0
    800069fc:	f52080e7          	jalr	-174(ra) # 8000694a <snprint_lock>
    80006a00:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006a04:	04a1                	addi	s1,s1,8
    80006a06:	05848763          	beq	s1,s8,80006a54 <statslock+0xdc>
    if(locks[i] == 0)
    80006a0a:	89a6                	mv	s3,s1
    80006a0c:	609c                	ld	a5,0(s1)
    80006a0e:	c3b9                	beqz	a5,80006a54 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a10:	0087bd83          	ld	s11,8(a5)
    80006a14:	855e                	mv	a0,s7
    80006a16:	ffffa097          	auipc	ra,0xffffa
    80006a1a:	9f4080e7          	jalr	-1548(ra) # 8000040a <strlen>
    80006a1e:	0005061b          	sext.w	a2,a0
    80006a22:	85de                	mv	a1,s7
    80006a24:	856e                	mv	a0,s11
    80006a26:	ffffa097          	auipc	ra,0xffffa
    80006a2a:	938080e7          	jalr	-1736(ra) # 8000035e <strncmp>
    80006a2e:	dd45                	beqz	a0,800069e6 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a30:	609c                	ld	a5,0(s1)
    80006a32:	0087bd83          	ld	s11,8(a5)
    80006a36:	856a                	mv	a0,s10
    80006a38:	ffffa097          	auipc	ra,0xffffa
    80006a3c:	9d2080e7          	jalr	-1582(ra) # 8000040a <strlen>
    80006a40:	0005061b          	sext.w	a2,a0
    80006a44:	85ea                	mv	a1,s10
    80006a46:	856e                	mv	a0,s11
    80006a48:	ffffa097          	auipc	ra,0xffffa
    80006a4c:	916080e7          	jalr	-1770(ra) # 8000035e <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a50:	f955                	bnez	a0,80006a04 <statslock+0x8c>
    80006a52:	bf51                	j	800069e6 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006a54:	00002617          	auipc	a2,0x2
    80006a58:	e6460613          	addi	a2,a2,-412 # 800088b8 <digits+0xc0>
    80006a5c:	412b05bb          	subw	a1,s6,s2
    80006a60:	012a8533          	add	a0,s5,s2
    80006a64:	fffff097          	auipc	ra,0xfffff
    80006a68:	0ee080e7          	jalr	238(ra) # 80005b52 <snprintf>
    80006a6c:	012509bb          	addw	s3,a0,s2
    80006a70:	4b95                	li	s7,5
  int last = 100000000;
    80006a72:	05f5e537          	lui	a0,0x5f5e
    80006a76:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006a7a:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a7c:	00024497          	auipc	s1,0x24
    80006a80:	82c48493          	addi	s1,s1,-2004 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006a84:	1f400913          	li	s2,500
    80006a88:	a881                	j	80006ad8 <statslock+0x160>
    80006a8a:	2705                	addiw	a4,a4,1
    80006a8c:	06a1                	addi	a3,a3,8
    80006a8e:	03270063          	beq	a4,s2,80006aae <statslock+0x136>
      if(locks[i] == 0)
    80006a92:	629c                	ld	a5,0(a3)
    80006a94:	cf89                	beqz	a5,80006aae <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a96:	4f90                	lw	a2,24(a5)
    80006a98:	00359793          	slli	a5,a1,0x3
    80006a9c:	97a6                	add	a5,a5,s1
    80006a9e:	639c                	ld	a5,0(a5)
    80006aa0:	4f9c                	lw	a5,24(a5)
    80006aa2:	fec7d4e3          	bge	a5,a2,80006a8a <statslock+0x112>
    80006aa6:	fea652e3          	bge	a2,a0,80006a8a <statslock+0x112>
    80006aaa:	85ba                	mv	a1,a4
    80006aac:	bff9                	j	80006a8a <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006aae:	058e                	slli	a1,a1,0x3
    80006ab0:	00b48d33          	add	s10,s1,a1
    80006ab4:	000d3603          	ld	a2,0(s10)
    80006ab8:	413b05bb          	subw	a1,s6,s3
    80006abc:	013a8533          	add	a0,s5,s3
    80006ac0:	00000097          	auipc	ra,0x0
    80006ac4:	e8a080e7          	jalr	-374(ra) # 8000694a <snprint_lock>
    80006ac8:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006acc:	000d3783          	ld	a5,0(s10)
    80006ad0:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006ad2:	3bfd                	addiw	s7,s7,-1
    80006ad4:	000b8663          	beqz	s7,80006ae0 <statslock+0x168>
  int tot = 0;
    80006ad8:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006ada:	8762                	mv	a4,s8
    int top = 0;
    80006adc:	85e2                	mv	a1,s8
    80006ade:	bf55                	j	80006a92 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006ae0:	86d2                	mv	a3,s4
    80006ae2:	00002617          	auipc	a2,0x2
    80006ae6:	df660613          	addi	a2,a2,-522 # 800088d8 <digits+0xe0>
    80006aea:	413b05bb          	subw	a1,s6,s3
    80006aee:	013a8533          	add	a0,s5,s3
    80006af2:	fffff097          	auipc	ra,0xfffff
    80006af6:	060080e7          	jalr	96(ra) # 80005b52 <snprintf>
    80006afa:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006afe:	00023517          	auipc	a0,0x23
    80006b02:	78a50513          	addi	a0,a0,1930 # 8002a288 <lock_locks>
    80006b06:	00000097          	auipc	ra,0x0
    80006b0a:	cea080e7          	jalr	-790(ra) # 800067f0 <release>
  return n;
}
    80006b0e:	854e                	mv	a0,s3
    80006b10:	70a6                	ld	ra,104(sp)
    80006b12:	7406                	ld	s0,96(sp)
    80006b14:	64e6                	ld	s1,88(sp)
    80006b16:	6946                	ld	s2,80(sp)
    80006b18:	69a6                	ld	s3,72(sp)
    80006b1a:	6a06                	ld	s4,64(sp)
    80006b1c:	7ae2                	ld	s5,56(sp)
    80006b1e:	7b42                	ld	s6,48(sp)
    80006b20:	7ba2                	ld	s7,40(sp)
    80006b22:	7c02                	ld	s8,32(sp)
    80006b24:	6ce2                	ld	s9,24(sp)
    80006b26:	6d42                	ld	s10,16(sp)
    80006b28:	6da2                	ld	s11,8(sp)
    80006b2a:	6165                	addi	sp,sp,112
    80006b2c:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
