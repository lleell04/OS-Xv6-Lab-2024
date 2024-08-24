
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	95013103          	ld	sp,-1712(sp) # 80008950 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	093050ef          	jal	ra,800058a8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	e44e                	sd	s3,8(sp)
    80000028:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002a:	03451793          	slli	a5,a0,0x34
    8000002e:	e3ad                	bnez	a5,80000090 <kfree+0x74>
    80000030:	84aa                	mv	s1,a0
    80000032:	00246797          	auipc	a5,0x246
    80000036:	20e78793          	addi	a5,a5,526 # 80246240 <end>
    8000003a:	04f56b63          	bltu	a0,a5,80000090 <kfree+0x74>
    8000003e:	47c5                	li	a5,17
    80000040:	07ee                	slli	a5,a5,0x1b
    80000042:	04f57763          	bgeu	a0,a5,80000090 <kfree+0x74>
    panic("kfree");

    // 需要加锁保证原子性
  acquire(&kmem.lock);
    80000046:	00009917          	auipc	s2,0x9
    8000004a:	fea90913          	addi	s2,s2,-22 # 80009030 <kmem>
    8000004e:	854a                	mv	a0,s2
    80000050:	00006097          	auipc	ra,0x6
    80000054:	252080e7          	jalr	594(ra) # 800062a2 <acquire>
  int remain = --cowcount[PA2INDEX(pa)];
    80000058:	00c4d793          	srli	a5,s1,0xc
    8000005c:	00279713          	slli	a4,a5,0x2
    80000060:	00009797          	auipc	a5,0x9
    80000064:	ff078793          	addi	a5,a5,-16 # 80009050 <cowcount>
    80000068:	97ba                	add	a5,a5,a4
    8000006a:	4398                	lw	a4,0(a5)
    8000006c:	377d                	addiw	a4,a4,-1
    8000006e:	0007099b          	sext.w	s3,a4
    80000072:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    80000074:	854a                	mv	a0,s2
    80000076:	00006097          	auipc	ra,0x6
    8000007a:	2e0080e7          	jalr	736(ra) # 80006356 <release>

  if (remain > 0) {
    8000007e:	03305163          	blez	s3,800000a0 <kfree+0x84>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000082:	70a2                	ld	ra,40(sp)
    80000084:	7402                	ld	s0,32(sp)
    80000086:	64e2                	ld	s1,24(sp)
    80000088:	6942                	ld	s2,16(sp)
    8000008a:	69a2                	ld	s3,8(sp)
    8000008c:	6145                	addi	sp,sp,48
    8000008e:	8082                	ret
    panic("kfree");
    80000090:	00008517          	auipc	a0,0x8
    80000094:	f8050513          	addi	a0,a0,-128 # 80008010 <etext+0x10>
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	cc0080e7          	jalr	-832(ra) # 80005d58 <panic>
  memset(pa, 1, PGSIZE);
    800000a0:	6605                	lui	a2,0x1
    800000a2:	4585                	li	a1,1
    800000a4:	8526                	mv	a0,s1
    800000a6:	00000097          	auipc	ra,0x0
    800000aa:	1d0080e7          	jalr	464(ra) # 80000276 <memset>
  acquire(&kmem.lock);
    800000ae:	854a                	mv	a0,s2
    800000b0:	00006097          	auipc	ra,0x6
    800000b4:	1f2080e7          	jalr	498(ra) # 800062a2 <acquire>
  r->next = kmem.freelist;
    800000b8:	01893783          	ld	a5,24(s2)
    800000bc:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000be:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000c2:	854a                	mv	a0,s2
    800000c4:	00006097          	auipc	ra,0x6
    800000c8:	292080e7          	jalr	658(ra) # 80006356 <release>
    800000cc:	bf5d                	j	80000082 <kfree+0x66>

00000000800000ce <freerange>:
{
    800000ce:	7139                	addi	sp,sp,-64
    800000d0:	fc06                	sd	ra,56(sp)
    800000d2:	f822                	sd	s0,48(sp)
    800000d4:	f426                	sd	s1,40(sp)
    800000d6:	f04a                	sd	s2,32(sp)
    800000d8:	ec4e                	sd	s3,24(sp)
    800000da:	e852                	sd	s4,16(sp)
    800000dc:	e456                	sd	s5,8(sp)
    800000de:	e05a                	sd	s6,0(sp)
    800000e0:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000e2:	6785                	lui	a5,0x1
    800000e4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000e8:	9526                	add	a0,a0,s1
    800000ea:	74fd                	lui	s1,0xfffff
    800000ec:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    800000ee:	97a6                	add	a5,a5,s1
    800000f0:	02f5ea63          	bltu	a1,a5,80000124 <freerange+0x56>
    800000f4:	892e                	mv	s2,a1
    cowcount[PA2INDEX(p)] = 1; // 初始化的时候把每个物理页都加入freelist
    800000f6:	00009b17          	auipc	s6,0x9
    800000fa:	f5ab0b13          	addi	s6,s6,-166 # 80009050 <cowcount>
    800000fe:	4a85                	li	s5,1
    80000100:	6a05                	lui	s4,0x1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    80000102:	6989                	lui	s3,0x2
    cowcount[PA2INDEX(p)] = 1; // 初始化的时候把每个物理页都加入freelist
    80000104:	00c4d793          	srli	a5,s1,0xc
    80000108:	078a                	slli	a5,a5,0x2
    8000010a:	97da                	add	a5,a5,s6
    8000010c:	0157a023          	sw	s5,0(a5)
    kfree(p);
    80000110:	8526                	mv	a0,s1
    80000112:	00000097          	auipc	ra,0x0
    80000116:	f0a080e7          	jalr	-246(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    8000011a:	87a6                	mv	a5,s1
    8000011c:	94d2                	add	s1,s1,s4
    8000011e:	97ce                	add	a5,a5,s3
    80000120:	fef972e3          	bgeu	s2,a5,80000104 <freerange+0x36>
}
    80000124:	70e2                	ld	ra,56(sp)
    80000126:	7442                	ld	s0,48(sp)
    80000128:	74a2                	ld	s1,40(sp)
    8000012a:	7902                	ld	s2,32(sp)
    8000012c:	69e2                	ld	s3,24(sp)
    8000012e:	6a42                	ld	s4,16(sp)
    80000130:	6aa2                	ld	s5,8(sp)
    80000132:	6b02                	ld	s6,0(sp)
    80000134:	6121                	addi	sp,sp,64
    80000136:	8082                	ret

0000000080000138 <kinit>:
{
    80000138:	1141                	addi	sp,sp,-16
    8000013a:	e406                	sd	ra,8(sp)
    8000013c:	e022                	sd	s0,0(sp)
    8000013e:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000140:	00008597          	auipc	a1,0x8
    80000144:	ed858593          	addi	a1,a1,-296 # 80008018 <etext+0x18>
    80000148:	00009517          	auipc	a0,0x9
    8000014c:	ee850513          	addi	a0,a0,-280 # 80009030 <kmem>
    80000150:	00006097          	auipc	ra,0x6
    80000154:	0c2080e7          	jalr	194(ra) # 80006212 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000158:	45c5                	li	a1,17
    8000015a:	05ee                	slli	a1,a1,0x1b
    8000015c:	00246517          	auipc	a0,0x246
    80000160:	0e450513          	addi	a0,a0,228 # 80246240 <end>
    80000164:	00000097          	auipc	ra,0x0
    80000168:	f6a080e7          	jalr	-150(ra) # 800000ce <freerange>
}
    8000016c:	60a2                	ld	ra,8(sp)
    8000016e:	6402                	ld	s0,0(sp)
    80000170:	0141                	addi	sp,sp,16
    80000172:	8082                	ret

0000000080000174 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000174:	1101                	addi	sp,sp,-32
    80000176:	ec06                	sd	ra,24(sp)
    80000178:	e822                	sd	s0,16(sp)
    8000017a:	e426                	sd	s1,8(sp)
    8000017c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000017e:	00009497          	auipc	s1,0x9
    80000182:	eb248493          	addi	s1,s1,-334 # 80009030 <kmem>
    80000186:	8526                	mv	a0,s1
    80000188:	00006097          	auipc	ra,0x6
    8000018c:	11a080e7          	jalr	282(ra) # 800062a2 <acquire>
  r = kmem.freelist;
    80000190:	6c84                	ld	s1,24(s1)
  if(r)
    80000192:	c4a5                	beqz	s1,800001fa <kalloc+0x86>
    kmem.freelist = r->next;
    80000194:	609c                	ld	a5,0(s1)
    80000196:	00009517          	auipc	a0,0x9
    8000019a:	e9a50513          	addi	a0,a0,-358 # 80009030 <kmem>
    8000019e:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800001a0:	00006097          	auipc	ra,0x6
    800001a4:	1b6080e7          	jalr	438(ra) # 80006356 <release>

  if(r)
  {
    memset((char *)r, 5, PGSIZE); // fill with junk
    800001a8:	6605                	lui	a2,0x1
    800001aa:	4595                	li	a1,5
    800001ac:	8526                	mv	a0,s1
    800001ae:	00000097          	auipc	ra,0x0
    800001b2:	0c8080e7          	jalr	200(ra) # 80000276 <memset>
    int idx = PA2INDEX(r);
    800001b6:	00c4d793          	srli	a5,s1,0xc
    800001ba:	2781                	sext.w	a5,a5
    if (cowcount[idx] != 0) {
    800001bc:	00279693          	slli	a3,a5,0x2
    800001c0:	00009717          	auipc	a4,0x9
    800001c4:	e9070713          	addi	a4,a4,-368 # 80009050 <cowcount>
    800001c8:	9736                	add	a4,a4,a3
    800001ca:	4318                	lw	a4,0(a4)
    800001cc:	ef19                	bnez	a4,800001ea <kalloc+0x76>
      panic("kalloc: cowcount[idx] != 0");
    }
    cowcount[idx] = 1; // 新allocate的物理页的计数器为1
    800001ce:	078a                	slli	a5,a5,0x2
    800001d0:	00009717          	auipc	a4,0x9
    800001d4:	e8070713          	addi	a4,a4,-384 # 80009050 <cowcount>
    800001d8:	97ba                	add	a5,a5,a4
    800001da:	4705                	li	a4,1
    800001dc:	c398                	sw	a4,0(a5)
  }
  return (void*)r;
}
    800001de:	8526                	mv	a0,s1
    800001e0:	60e2                	ld	ra,24(sp)
    800001e2:	6442                	ld	s0,16(sp)
    800001e4:	64a2                	ld	s1,8(sp)
    800001e6:	6105                	addi	sp,sp,32
    800001e8:	8082                	ret
      panic("kalloc: cowcount[idx] != 0");
    800001ea:	00008517          	auipc	a0,0x8
    800001ee:	e3650513          	addi	a0,a0,-458 # 80008020 <etext+0x20>
    800001f2:	00006097          	auipc	ra,0x6
    800001f6:	b66080e7          	jalr	-1178(ra) # 80005d58 <panic>
  release(&kmem.lock);
    800001fa:	00009517          	auipc	a0,0x9
    800001fe:	e3650513          	addi	a0,a0,-458 # 80009030 <kmem>
    80000202:	00006097          	auipc	ra,0x6
    80000206:	154080e7          	jalr	340(ra) # 80006356 <release>
  if(r)
    8000020a:	bfd1                	j	800001de <kalloc+0x6a>

000000008000020c <adjustref>:

void adjustref(uint64 pa, int num) {
    8000020c:	7179                	addi	sp,sp,-48
    8000020e:	f406                	sd	ra,40(sp)
    80000210:	f022                	sd	s0,32(sp)
    80000212:	ec26                	sd	s1,24(sp)
    80000214:	e84a                	sd	s2,16(sp)
    80000216:	e44e                	sd	s3,8(sp)
    80000218:	1800                	addi	s0,sp,48
    if (pa >= PHYSTOP) {
    8000021a:	47c5                	li	a5,17
    8000021c:	07ee                	slli	a5,a5,0x1b
    8000021e:	04f57463          	bgeu	a0,a5,80000266 <adjustref+0x5a>
    80000222:	84aa                	mv	s1,a0
    80000224:	892e                	mv	s2,a1
        panic("addref: pa too big");
    }
    acquire(&kmem.lock);
    80000226:	00009997          	auipc	s3,0x9
    8000022a:	e0a98993          	addi	s3,s3,-502 # 80009030 <kmem>
    8000022e:	854e                	mv	a0,s3
    80000230:	00006097          	auipc	ra,0x6
    80000234:	072080e7          	jalr	114(ra) # 800062a2 <acquire>
    cowcount[PA2INDEX(pa)] += num;
    80000238:	80b1                	srli	s1,s1,0xc
    8000023a:	048a                	slli	s1,s1,0x2
    8000023c:	00009797          	auipc	a5,0x9
    80000240:	e1478793          	addi	a5,a5,-492 # 80009050 <cowcount>
    80000244:	94be                	add	s1,s1,a5
    80000246:	408c                	lw	a1,0(s1)
    80000248:	012585bb          	addw	a1,a1,s2
    8000024c:	c08c                	sw	a1,0(s1)
    release(&kmem.lock);
    8000024e:	854e                	mv	a0,s3
    80000250:	00006097          	auipc	ra,0x6
    80000254:	106080e7          	jalr	262(ra) # 80006356 <release>
}
    80000258:	70a2                	ld	ra,40(sp)
    8000025a:	7402                	ld	s0,32(sp)
    8000025c:	64e2                	ld	s1,24(sp)
    8000025e:	6942                	ld	s2,16(sp)
    80000260:	69a2                	ld	s3,8(sp)
    80000262:	6145                	addi	sp,sp,48
    80000264:	8082                	ret
        panic("addref: pa too big");
    80000266:	00008517          	auipc	a0,0x8
    8000026a:	dda50513          	addi	a0,a0,-550 # 80008040 <etext+0x40>
    8000026e:	00006097          	auipc	ra,0x6
    80000272:	aea080e7          	jalr	-1302(ra) # 80005d58 <panic>

0000000080000276 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e422                	sd	s0,8(sp)
    8000027a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000027c:	ce09                	beqz	a2,80000296 <memset+0x20>
    8000027e:	87aa                	mv	a5,a0
    80000280:	fff6071b          	addiw	a4,a2,-1
    80000284:	1702                	slli	a4,a4,0x20
    80000286:	9301                	srli	a4,a4,0x20
    80000288:	0705                	addi	a4,a4,1
    8000028a:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000028c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000290:	0785                	addi	a5,a5,1
    80000292:	fee79de3          	bne	a5,a4,8000028c <memset+0x16>
  }
  return dst;
}
    80000296:	6422                	ld	s0,8(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret

000000008000029c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000029c:	1141                	addi	sp,sp,-16
    8000029e:	e422                	sd	s0,8(sp)
    800002a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002a2:	ca05                	beqz	a2,800002d2 <memcmp+0x36>
    800002a4:	fff6069b          	addiw	a3,a2,-1
    800002a8:	1682                	slli	a3,a3,0x20
    800002aa:	9281                	srli	a3,a3,0x20
    800002ac:	0685                	addi	a3,a3,1
    800002ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002b0:	00054783          	lbu	a5,0(a0)
    800002b4:	0005c703          	lbu	a4,0(a1)
    800002b8:	00e79863          	bne	a5,a4,800002c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002bc:	0505                	addi	a0,a0,1
    800002be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002c0:	fed518e3          	bne	a0,a3,800002b0 <memcmp+0x14>
  }

  return 0;
    800002c4:	4501                	li	a0,0
    800002c6:	a019                	j	800002cc <memcmp+0x30>
      return *s1 - *s2;
    800002c8:	40e7853b          	subw	a0,a5,a4
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
  return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <memcmp+0x30>

00000000800002d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002dc:	ca0d                	beqz	a2,8000030e <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002de:	00a5f963          	bgeu	a1,a0,800002f0 <memmove+0x1a>
    800002e2:	02061693          	slli	a3,a2,0x20
    800002e6:	9281                	srli	a3,a3,0x20
    800002e8:	00d58733          	add	a4,a1,a3
    800002ec:	02e56463          	bltu	a0,a4,80000314 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002f0:	fff6079b          	addiw	a5,a2,-1
    800002f4:	1782                	slli	a5,a5,0x20
    800002f6:	9381                	srli	a5,a5,0x20
    800002f8:	0785                	addi	a5,a5,1
    800002fa:	97ae                	add	a5,a5,a1
    800002fc:	872a                	mv	a4,a0
      *d++ = *s++;
    800002fe:	0585                	addi	a1,a1,1
    80000300:	0705                	addi	a4,a4,1
    80000302:	fff5c683          	lbu	a3,-1(a1)
    80000306:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000030a:	fef59ae3          	bne	a1,a5,800002fe <memmove+0x28>

  return dst;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
    d += n;
    80000314:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000316:	fff6079b          	addiw	a5,a2,-1
    8000031a:	1782                	slli	a5,a5,0x20
    8000031c:	9381                	srli	a5,a5,0x20
    8000031e:	fff7c793          	not	a5,a5
    80000322:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000324:	177d                	addi	a4,a4,-1
    80000326:	16fd                	addi	a3,a3,-1
    80000328:	00074603          	lbu	a2,0(a4)
    8000032c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000330:	fef71ae3          	bne	a4,a5,80000324 <memmove+0x4e>
    80000334:	bfe9                	j	8000030e <memmove+0x38>

0000000080000336 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000336:	1141                	addi	sp,sp,-16
    80000338:	e406                	sd	ra,8(sp)
    8000033a:	e022                	sd	s0,0(sp)
    8000033c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000033e:	00000097          	auipc	ra,0x0
    80000342:	f98080e7          	jalr	-104(ra) # 800002d6 <memmove>
}
    80000346:	60a2                	ld	ra,8(sp)
    80000348:	6402                	ld	s0,0(sp)
    8000034a:	0141                	addi	sp,sp,16
    8000034c:	8082                	ret

000000008000034e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000034e:	1141                	addi	sp,sp,-16
    80000350:	e422                	sd	s0,8(sp)
    80000352:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000354:	ce11                	beqz	a2,80000370 <strncmp+0x22>
    80000356:	00054783          	lbu	a5,0(a0)
    8000035a:	cf89                	beqz	a5,80000374 <strncmp+0x26>
    8000035c:	0005c703          	lbu	a4,0(a1)
    80000360:	00f71a63          	bne	a4,a5,80000374 <strncmp+0x26>
    n--, p++, q++;
    80000364:	367d                	addiw	a2,a2,-1
    80000366:	0505                	addi	a0,a0,1
    80000368:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000036a:	f675                	bnez	a2,80000356 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000036c:	4501                	li	a0,0
    8000036e:	a809                	j	80000380 <strncmp+0x32>
    80000370:	4501                	li	a0,0
    80000372:	a039                	j	80000380 <strncmp+0x32>
  if(n == 0)
    80000374:	ca09                	beqz	a2,80000386 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000376:	00054503          	lbu	a0,0(a0)
    8000037a:	0005c783          	lbu	a5,0(a1)
    8000037e:	9d1d                	subw	a0,a0,a5
}
    80000380:	6422                	ld	s0,8(sp)
    80000382:	0141                	addi	sp,sp,16
    80000384:	8082                	ret
    return 0;
    80000386:	4501                	li	a0,0
    80000388:	bfe5                	j	80000380 <strncmp+0x32>

000000008000038a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000038a:	1141                	addi	sp,sp,-16
    8000038c:	e422                	sd	s0,8(sp)
    8000038e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000390:	872a                	mv	a4,a0
    80000392:	8832                	mv	a6,a2
    80000394:	367d                	addiw	a2,a2,-1
    80000396:	01005963          	blez	a6,800003a8 <strncpy+0x1e>
    8000039a:	0705                	addi	a4,a4,1
    8000039c:	0005c783          	lbu	a5,0(a1)
    800003a0:	fef70fa3          	sb	a5,-1(a4)
    800003a4:	0585                	addi	a1,a1,1
    800003a6:	f7f5                	bnez	a5,80000392 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003a8:	00c05d63          	blez	a2,800003c2 <strncpy+0x38>
    800003ac:	86ba                	mv	a3,a4
    *s++ = 0;
    800003ae:	0685                	addi	a3,a3,1
    800003b0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003b4:	fff6c793          	not	a5,a3
    800003b8:	9fb9                	addw	a5,a5,a4
    800003ba:	010787bb          	addw	a5,a5,a6
    800003be:	fef048e3          	bgtz	a5,800003ae <strncpy+0x24>
  return os;
}
    800003c2:	6422                	ld	s0,8(sp)
    800003c4:	0141                	addi	sp,sp,16
    800003c6:	8082                	ret

00000000800003c8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003c8:	1141                	addi	sp,sp,-16
    800003ca:	e422                	sd	s0,8(sp)
    800003cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003ce:	02c05363          	blez	a2,800003f4 <safestrcpy+0x2c>
    800003d2:	fff6069b          	addiw	a3,a2,-1
    800003d6:	1682                	slli	a3,a3,0x20
    800003d8:	9281                	srli	a3,a3,0x20
    800003da:	96ae                	add	a3,a3,a1
    800003dc:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003de:	00d58963          	beq	a1,a3,800003f0 <safestrcpy+0x28>
    800003e2:	0585                	addi	a1,a1,1
    800003e4:	0785                	addi	a5,a5,1
    800003e6:	fff5c703          	lbu	a4,-1(a1)
    800003ea:	fee78fa3          	sb	a4,-1(a5)
    800003ee:	fb65                	bnez	a4,800003de <safestrcpy+0x16>
    ;
  *s = 0;
    800003f0:	00078023          	sb	zero,0(a5)
  return os;
}
    800003f4:	6422                	ld	s0,8(sp)
    800003f6:	0141                	addi	sp,sp,16
    800003f8:	8082                	ret

00000000800003fa <strlen>:

int
strlen(const char *s)
{
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e422                	sd	s0,8(sp)
    800003fe:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000400:	00054783          	lbu	a5,0(a0)
    80000404:	cf91                	beqz	a5,80000420 <strlen+0x26>
    80000406:	0505                	addi	a0,a0,1
    80000408:	87aa                	mv	a5,a0
    8000040a:	4685                	li	a3,1
    8000040c:	9e89                	subw	a3,a3,a0
    8000040e:	00f6853b          	addw	a0,a3,a5
    80000412:	0785                	addi	a5,a5,1
    80000414:	fff7c703          	lbu	a4,-1(a5)
    80000418:	fb7d                	bnez	a4,8000040e <strlen+0x14>
    ;
  return n;
}
    8000041a:	6422                	ld	s0,8(sp)
    8000041c:	0141                	addi	sp,sp,16
    8000041e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000420:	4501                	li	a0,0
    80000422:	bfe5                	j	8000041a <strlen+0x20>

0000000080000424 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000424:	1141                	addi	sp,sp,-16
    80000426:	e406                	sd	ra,8(sp)
    80000428:	e022                	sd	s0,0(sp)
    8000042a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000042c:	00001097          	auipc	ra,0x1
    80000430:	c12080e7          	jalr	-1006(ra) # 8000103e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000434:	00009717          	auipc	a4,0x9
    80000438:	bcc70713          	addi	a4,a4,-1076 # 80009000 <started>
  if(cpuid() == 0){
    8000043c:	c139                	beqz	a0,80000482 <main+0x5e>
    while(started == 0)
    8000043e:	431c                	lw	a5,0(a4)
    80000440:	2781                	sext.w	a5,a5
    80000442:	dff5                	beqz	a5,8000043e <main+0x1a>
      ;
    __sync_synchronize();
    80000444:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000448:	00001097          	auipc	ra,0x1
    8000044c:	bf6080e7          	jalr	-1034(ra) # 8000103e <cpuid>
    80000450:	85aa                	mv	a1,a0
    80000452:	00008517          	auipc	a0,0x8
    80000456:	c1e50513          	addi	a0,a0,-994 # 80008070 <etext+0x70>
    8000045a:	00006097          	auipc	ra,0x6
    8000045e:	948080e7          	jalr	-1720(ra) # 80005da2 <printf>
    kvminithart();    // turn on paging
    80000462:	00000097          	auipc	ra,0x0
    80000466:	0d8080e7          	jalr	216(ra) # 8000053a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000046a:	00002097          	auipc	ra,0x2
    8000046e:	84c080e7          	jalr	-1972(ra) # 80001cb6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000472:	00005097          	auipc	ra,0x5
    80000476:	dbe080e7          	jalr	-578(ra) # 80005230 <plicinithart>
  }

  scheduler();        
    8000047a:	00001097          	auipc	ra,0x1
    8000047e:	0fa080e7          	jalr	250(ra) # 80001574 <scheduler>
    consoleinit();
    80000482:	00005097          	auipc	ra,0x5
    80000486:	7e8080e7          	jalr	2024(ra) # 80005c6a <consoleinit>
    printfinit();
    8000048a:	00006097          	auipc	ra,0x6
    8000048e:	afe080e7          	jalr	-1282(ra) # 80005f88 <printfinit>
    printf("\n");
    80000492:	00008517          	auipc	a0,0x8
    80000496:	bee50513          	addi	a0,a0,-1042 # 80008080 <etext+0x80>
    8000049a:	00006097          	auipc	ra,0x6
    8000049e:	908080e7          	jalr	-1784(ra) # 80005da2 <printf>
    printf("xv6 kernel is booting\n");
    800004a2:	00008517          	auipc	a0,0x8
    800004a6:	bb650513          	addi	a0,a0,-1098 # 80008058 <etext+0x58>
    800004aa:	00006097          	auipc	ra,0x6
    800004ae:	8f8080e7          	jalr	-1800(ra) # 80005da2 <printf>
    printf("\n");
    800004b2:	00008517          	auipc	a0,0x8
    800004b6:	bce50513          	addi	a0,a0,-1074 # 80008080 <etext+0x80>
    800004ba:	00006097          	auipc	ra,0x6
    800004be:	8e8080e7          	jalr	-1816(ra) # 80005da2 <printf>
    kinit();         // physical page allocator
    800004c2:	00000097          	auipc	ra,0x0
    800004c6:	c76080e7          	jalr	-906(ra) # 80000138 <kinit>
    kvminit();       // create kernel page table
    800004ca:	00000097          	auipc	ra,0x0
    800004ce:	322080e7          	jalr	802(ra) # 800007ec <kvminit>
    kvminithart();   // turn on paging
    800004d2:	00000097          	auipc	ra,0x0
    800004d6:	068080e7          	jalr	104(ra) # 8000053a <kvminithart>
    procinit();      // process table
    800004da:	00001097          	auipc	ra,0x1
    800004de:	ab4080e7          	jalr	-1356(ra) # 80000f8e <procinit>
    trapinit();      // trap vectors
    800004e2:	00001097          	auipc	ra,0x1
    800004e6:	7ac080e7          	jalr	1964(ra) # 80001c8e <trapinit>
    trapinithart();  // install kernel trap vector
    800004ea:	00001097          	auipc	ra,0x1
    800004ee:	7cc080e7          	jalr	1996(ra) # 80001cb6 <trapinithart>
    plicinit();      // set up interrupt controller
    800004f2:	00005097          	auipc	ra,0x5
    800004f6:	d28080e7          	jalr	-728(ra) # 8000521a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004fa:	00005097          	auipc	ra,0x5
    800004fe:	d36080e7          	jalr	-714(ra) # 80005230 <plicinithart>
    binit();         // buffer cache
    80000502:	00002097          	auipc	ra,0x2
    80000506:	f1a080e7          	jalr	-230(ra) # 8000241c <binit>
    iinit();         // inode table
    8000050a:	00002097          	auipc	ra,0x2
    8000050e:	5aa080e7          	jalr	1450(ra) # 80002ab4 <iinit>
    fileinit();      // file table
    80000512:	00003097          	auipc	ra,0x3
    80000516:	554080e7          	jalr	1364(ra) # 80003a66 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000051a:	00005097          	auipc	ra,0x5
    8000051e:	e38080e7          	jalr	-456(ra) # 80005352 <virtio_disk_init>
    userinit();      // first user process
    80000522:	00001097          	auipc	ra,0x1
    80000526:	e20080e7          	jalr	-480(ra) # 80001342 <userinit>
    __sync_synchronize();
    8000052a:	0ff0000f          	fence
    started = 1;
    8000052e:	4785                	li	a5,1
    80000530:	00009717          	auipc	a4,0x9
    80000534:	acf72823          	sw	a5,-1328(a4) # 80009000 <started>
    80000538:	b789                	j	8000047a <main+0x56>

000000008000053a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000053a:	1141                	addi	sp,sp,-16
    8000053c:	e422                	sd	s0,8(sp)
    8000053e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000540:	00009797          	auipc	a5,0x9
    80000544:	ac87b783          	ld	a5,-1336(a5) # 80009008 <kernel_pagetable>
    80000548:	83b1                	srli	a5,a5,0xc
    8000054a:	577d                	li	a4,-1
    8000054c:	177e                	slli	a4,a4,0x3f
    8000054e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000550:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000554:	12000073          	sfence.vma
  sfence_vma();
}
    80000558:	6422                	ld	s0,8(sp)
    8000055a:	0141                	addi	sp,sp,16
    8000055c:	8082                	ret

000000008000055e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000055e:	7139                	addi	sp,sp,-64
    80000560:	fc06                	sd	ra,56(sp)
    80000562:	f822                	sd	s0,48(sp)
    80000564:	f426                	sd	s1,40(sp)
    80000566:	f04a                	sd	s2,32(sp)
    80000568:	ec4e                	sd	s3,24(sp)
    8000056a:	e852                	sd	s4,16(sp)
    8000056c:	e456                	sd	s5,8(sp)
    8000056e:	e05a                	sd	s6,0(sp)
    80000570:	0080                	addi	s0,sp,64
    80000572:	84aa                	mv	s1,a0
    80000574:	89ae                	mv	s3,a1
    80000576:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000578:	57fd                	li	a5,-1
    8000057a:	83e9                	srli	a5,a5,0x1a
    8000057c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000057e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000580:	04b7f263          	bgeu	a5,a1,800005c4 <walk+0x66>
    panic("walk");
    80000584:	00008517          	auipc	a0,0x8
    80000588:	b0450513          	addi	a0,a0,-1276 # 80008088 <etext+0x88>
    8000058c:	00005097          	auipc	ra,0x5
    80000590:	7cc080e7          	jalr	1996(ra) # 80005d58 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000594:	060a8663          	beqz	s5,80000600 <walk+0xa2>
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	bdc080e7          	jalr	-1060(ra) # 80000174 <kalloc>
    800005a0:	84aa                	mv	s1,a0
    800005a2:	c529                	beqz	a0,800005ec <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005a4:	6605                	lui	a2,0x1
    800005a6:	4581                	li	a1,0
    800005a8:	00000097          	auipc	ra,0x0
    800005ac:	cce080e7          	jalr	-818(ra) # 80000276 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005b0:	00c4d793          	srli	a5,s1,0xc
    800005b4:	07aa                	slli	a5,a5,0xa
    800005b6:	0017e793          	ori	a5,a5,1
    800005ba:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005be:	3a5d                	addiw	s4,s4,-9
    800005c0:	036a0063          	beq	s4,s6,800005e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005c4:	0149d933          	srl	s2,s3,s4
    800005c8:	1ff97913          	andi	s2,s2,511
    800005cc:	090e                	slli	s2,s2,0x3
    800005ce:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005d0:	00093483          	ld	s1,0(s2)
    800005d4:	0014f793          	andi	a5,s1,1
    800005d8:	dfd5                	beqz	a5,80000594 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005da:	80a9                	srli	s1,s1,0xa
    800005dc:	04b2                	slli	s1,s1,0xc
    800005de:	b7c5                	j	800005be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005e0:	00c9d513          	srli	a0,s3,0xc
    800005e4:	1ff57513          	andi	a0,a0,511
    800005e8:	050e                	slli	a0,a0,0x3
    800005ea:	9526                	add	a0,a0,s1
}
    800005ec:	70e2                	ld	ra,56(sp)
    800005ee:	7442                	ld	s0,48(sp)
    800005f0:	74a2                	ld	s1,40(sp)
    800005f2:	7902                	ld	s2,32(sp)
    800005f4:	69e2                	ld	s3,24(sp)
    800005f6:	6a42                	ld	s4,16(sp)
    800005f8:	6aa2                	ld	s5,8(sp)
    800005fa:	6b02                	ld	s6,0(sp)
    800005fc:	6121                	addi	sp,sp,64
    800005fe:	8082                	ret
        return 0;
    80000600:	4501                	li	a0,0
    80000602:	b7ed                	j	800005ec <walk+0x8e>

0000000080000604 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000604:	57fd                	li	a5,-1
    80000606:	83e9                	srli	a5,a5,0x1a
    80000608:	00b7f463          	bgeu	a5,a1,80000610 <walkaddr+0xc>
    return 0;
    8000060c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000060e:	8082                	ret
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000618:	4601                	li	a2,0
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	f44080e7          	jalr	-188(ra) # 8000055e <walk>
  if(pte == 0)
    80000622:	c105                	beqz	a0,80000642 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000624:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000626:	0117f693          	andi	a3,a5,17
    8000062a:	4745                	li	a4,17
    return 0;
    8000062c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000062e:	00e68663          	beq	a3,a4,8000063a <walkaddr+0x36>
}
    80000632:	60a2                	ld	ra,8(sp)
    80000634:	6402                	ld	s0,0(sp)
    80000636:	0141                	addi	sp,sp,16
    80000638:	8082                	ret
  pa = PTE2PA(*pte);
    8000063a:	00a7d513          	srli	a0,a5,0xa
    8000063e:	0532                	slli	a0,a0,0xc
  return pa;
    80000640:	bfcd                	j	80000632 <walkaddr+0x2e>
    return 0;
    80000642:	4501                	li	a0,0
    80000644:	b7fd                	j	80000632 <walkaddr+0x2e>

0000000080000646 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000646:	715d                	addi	sp,sp,-80
    80000648:	e486                	sd	ra,72(sp)
    8000064a:	e0a2                	sd	s0,64(sp)
    8000064c:	fc26                	sd	s1,56(sp)
    8000064e:	f84a                	sd	s2,48(sp)
    80000650:	f44e                	sd	s3,40(sp)
    80000652:	f052                	sd	s4,32(sp)
    80000654:	ec56                	sd	s5,24(sp)
    80000656:	e85a                	sd	s6,16(sp)
    80000658:	e45e                	sd	s7,8(sp)
    8000065a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000065c:	c205                	beqz	a2,8000067c <mappages+0x36>
    8000065e:	8aaa                	mv	s5,a0
    80000660:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000662:	77fd                	lui	a5,0xfffff
    80000664:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000668:	15fd                	addi	a1,a1,-1
    8000066a:	00c589b3          	add	s3,a1,a2
    8000066e:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000672:	8952                	mv	s2,s4
    80000674:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000678:	6b85                	lui	s7,0x1
    8000067a:	a015                	j	8000069e <mappages+0x58>
    panic("mappages: size");
    8000067c:	00008517          	auipc	a0,0x8
    80000680:	a1450513          	addi	a0,a0,-1516 # 80008090 <etext+0x90>
    80000684:	00005097          	auipc	ra,0x5
    80000688:	6d4080e7          	jalr	1748(ra) # 80005d58 <panic>
      panic("mappages: remap");
    8000068c:	00008517          	auipc	a0,0x8
    80000690:	a1450513          	addi	a0,a0,-1516 # 800080a0 <etext+0xa0>
    80000694:	00005097          	auipc	ra,0x5
    80000698:	6c4080e7          	jalr	1732(ra) # 80005d58 <panic>
    a += PGSIZE;
    8000069c:	995e                	add	s2,s2,s7
  for(;;){
    8000069e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800006a2:	4605                	li	a2,1
    800006a4:	85ca                	mv	a1,s2
    800006a6:	8556                	mv	a0,s5
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	eb6080e7          	jalr	-330(ra) # 8000055e <walk>
    800006b0:	cd19                	beqz	a0,800006ce <mappages+0x88>
    if(*pte & PTE_V)
    800006b2:	611c                	ld	a5,0(a0)
    800006b4:	8b85                	andi	a5,a5,1
    800006b6:	fbf9                	bnez	a5,8000068c <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006b8:	80b1                	srli	s1,s1,0xc
    800006ba:	04aa                	slli	s1,s1,0xa
    800006bc:	0164e4b3          	or	s1,s1,s6
    800006c0:	0014e493          	ori	s1,s1,1
    800006c4:	e104                	sd	s1,0(a0)
    if(a == last)
    800006c6:	fd391be3          	bne	s2,s3,8000069c <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800006ca:	4501                	li	a0,0
    800006cc:	a011                	j	800006d0 <mappages+0x8a>
      return -1;
    800006ce:	557d                	li	a0,-1
}
    800006d0:	60a6                	ld	ra,72(sp)
    800006d2:	6406                	ld	s0,64(sp)
    800006d4:	74e2                	ld	s1,56(sp)
    800006d6:	7942                	ld	s2,48(sp)
    800006d8:	79a2                	ld	s3,40(sp)
    800006da:	7a02                	ld	s4,32(sp)
    800006dc:	6ae2                	ld	s5,24(sp)
    800006de:	6b42                	ld	s6,16(sp)
    800006e0:	6ba2                	ld	s7,8(sp)
    800006e2:	6161                	addi	sp,sp,80
    800006e4:	8082                	ret

00000000800006e6 <kvmmap>:
{
    800006e6:	1141                	addi	sp,sp,-16
    800006e8:	e406                	sd	ra,8(sp)
    800006ea:	e022                	sd	s0,0(sp)
    800006ec:	0800                	addi	s0,sp,16
    800006ee:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006f0:	86b2                	mv	a3,a2
    800006f2:	863e                	mv	a2,a5
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f52080e7          	jalr	-174(ra) # 80000646 <mappages>
    800006fc:	e509                	bnez	a0,80000706 <kvmmap+0x20>
}
    800006fe:	60a2                	ld	ra,8(sp)
    80000700:	6402                	ld	s0,0(sp)
    80000702:	0141                	addi	sp,sp,16
    80000704:	8082                	ret
    panic("kvmmap");
    80000706:	00008517          	auipc	a0,0x8
    8000070a:	9aa50513          	addi	a0,a0,-1622 # 800080b0 <etext+0xb0>
    8000070e:	00005097          	auipc	ra,0x5
    80000712:	64a080e7          	jalr	1610(ra) # 80005d58 <panic>

0000000080000716 <kvmmake>:
{
    80000716:	1101                	addi	sp,sp,-32
    80000718:	ec06                	sd	ra,24(sp)
    8000071a:	e822                	sd	s0,16(sp)
    8000071c:	e426                	sd	s1,8(sp)
    8000071e:	e04a                	sd	s2,0(sp)
    80000720:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000722:	00000097          	auipc	ra,0x0
    80000726:	a52080e7          	jalr	-1454(ra) # 80000174 <kalloc>
    8000072a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000072c:	6605                	lui	a2,0x1
    8000072e:	4581                	li	a1,0
    80000730:	00000097          	auipc	ra,0x0
    80000734:	b46080e7          	jalr	-1210(ra) # 80000276 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000738:	4719                	li	a4,6
    8000073a:	6685                	lui	a3,0x1
    8000073c:	10000637          	lui	a2,0x10000
    80000740:	100005b7          	lui	a1,0x10000
    80000744:	8526                	mv	a0,s1
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	fa0080e7          	jalr	-96(ra) # 800006e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000074e:	4719                	li	a4,6
    80000750:	6685                	lui	a3,0x1
    80000752:	10001637          	lui	a2,0x10001
    80000756:	100015b7          	lui	a1,0x10001
    8000075a:	8526                	mv	a0,s1
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	f8a080e7          	jalr	-118(ra) # 800006e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000764:	4719                	li	a4,6
    80000766:	004006b7          	lui	a3,0x400
    8000076a:	0c000637          	lui	a2,0xc000
    8000076e:	0c0005b7          	lui	a1,0xc000
    80000772:	8526                	mv	a0,s1
    80000774:	00000097          	auipc	ra,0x0
    80000778:	f72080e7          	jalr	-142(ra) # 800006e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000077c:	00008917          	auipc	s2,0x8
    80000780:	88490913          	addi	s2,s2,-1916 # 80008000 <etext>
    80000784:	4729                	li	a4,10
    80000786:	80008697          	auipc	a3,0x80008
    8000078a:	87a68693          	addi	a3,a3,-1926 # 8000 <_entry-0x7fff8000>
    8000078e:	4605                	li	a2,1
    80000790:	067e                	slli	a2,a2,0x1f
    80000792:	85b2                	mv	a1,a2
    80000794:	8526                	mv	a0,s1
    80000796:	00000097          	auipc	ra,0x0
    8000079a:	f50080e7          	jalr	-176(ra) # 800006e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000079e:	4719                	li	a4,6
    800007a0:	46c5                	li	a3,17
    800007a2:	06ee                	slli	a3,a3,0x1b
    800007a4:	412686b3          	sub	a3,a3,s2
    800007a8:	864a                	mv	a2,s2
    800007aa:	85ca                	mv	a1,s2
    800007ac:	8526                	mv	a0,s1
    800007ae:	00000097          	auipc	ra,0x0
    800007b2:	f38080e7          	jalr	-200(ra) # 800006e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007b6:	4729                	li	a4,10
    800007b8:	6685                	lui	a3,0x1
    800007ba:	00007617          	auipc	a2,0x7
    800007be:	84660613          	addi	a2,a2,-1978 # 80007000 <_trampoline>
    800007c2:	040005b7          	lui	a1,0x4000
    800007c6:	15fd                	addi	a1,a1,-1
    800007c8:	05b2                	slli	a1,a1,0xc
    800007ca:	8526                	mv	a0,s1
    800007cc:	00000097          	auipc	ra,0x0
    800007d0:	f1a080e7          	jalr	-230(ra) # 800006e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007d4:	8526                	mv	a0,s1
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	722080e7          	jalr	1826(ra) # 80000ef8 <proc_mapstacks>
}
    800007de:	8526                	mv	a0,s1
    800007e0:	60e2                	ld	ra,24(sp)
    800007e2:	6442                	ld	s0,16(sp)
    800007e4:	64a2                	ld	s1,8(sp)
    800007e6:	6902                	ld	s2,0(sp)
    800007e8:	6105                	addi	sp,sp,32
    800007ea:	8082                	ret

00000000800007ec <kvminit>:
{
    800007ec:	1141                	addi	sp,sp,-16
    800007ee:	e406                	sd	ra,8(sp)
    800007f0:	e022                	sd	s0,0(sp)
    800007f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007f4:	00000097          	auipc	ra,0x0
    800007f8:	f22080e7          	jalr	-222(ra) # 80000716 <kvmmake>
    800007fc:	00009797          	auipc	a5,0x9
    80000800:	80a7b623          	sd	a0,-2036(a5) # 80009008 <kernel_pagetable>
}
    80000804:	60a2                	ld	ra,8(sp)
    80000806:	6402                	ld	s0,0(sp)
    80000808:	0141                	addi	sp,sp,16
    8000080a:	8082                	ret

000000008000080c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000080c:	715d                	addi	sp,sp,-80
    8000080e:	e486                	sd	ra,72(sp)
    80000810:	e0a2                	sd	s0,64(sp)
    80000812:	fc26                	sd	s1,56(sp)
    80000814:	f84a                	sd	s2,48(sp)
    80000816:	f44e                	sd	s3,40(sp)
    80000818:	f052                	sd	s4,32(sp)
    8000081a:	ec56                	sd	s5,24(sp)
    8000081c:	e85a                	sd	s6,16(sp)
    8000081e:	e45e                	sd	s7,8(sp)
    80000820:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000822:	03459793          	slli	a5,a1,0x34
    80000826:	e795                	bnez	a5,80000852 <uvmunmap+0x46>
    80000828:	8a2a                	mv	s4,a0
    8000082a:	892e                	mv	s2,a1
    8000082c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000082e:	0632                	slli	a2,a2,0xc
    80000830:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000834:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000836:	6b05                	lui	s6,0x1
    80000838:	0735e863          	bltu	a1,s3,800008a8 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000083c:	60a6                	ld	ra,72(sp)
    8000083e:	6406                	ld	s0,64(sp)
    80000840:	74e2                	ld	s1,56(sp)
    80000842:	7942                	ld	s2,48(sp)
    80000844:	79a2                	ld	s3,40(sp)
    80000846:	7a02                	ld	s4,32(sp)
    80000848:	6ae2                	ld	s5,24(sp)
    8000084a:	6b42                	ld	s6,16(sp)
    8000084c:	6ba2                	ld	s7,8(sp)
    8000084e:	6161                	addi	sp,sp,80
    80000850:	8082                	ret
    panic("uvmunmap: not aligned");
    80000852:	00008517          	auipc	a0,0x8
    80000856:	86650513          	addi	a0,a0,-1946 # 800080b8 <etext+0xb8>
    8000085a:	00005097          	auipc	ra,0x5
    8000085e:	4fe080e7          	jalr	1278(ra) # 80005d58 <panic>
      panic("uvmunmap: walk");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	86e50513          	addi	a0,a0,-1938 # 800080d0 <etext+0xd0>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	4ee080e7          	jalr	1262(ra) # 80005d58 <panic>
      panic("uvmunmap: not mapped");
    80000872:	00008517          	auipc	a0,0x8
    80000876:	86e50513          	addi	a0,a0,-1938 # 800080e0 <etext+0xe0>
    8000087a:	00005097          	auipc	ra,0x5
    8000087e:	4de080e7          	jalr	1246(ra) # 80005d58 <panic>
      panic("uvmunmap: not a leaf");
    80000882:	00008517          	auipc	a0,0x8
    80000886:	87650513          	addi	a0,a0,-1930 # 800080f8 <etext+0xf8>
    8000088a:	00005097          	auipc	ra,0x5
    8000088e:	4ce080e7          	jalr	1230(ra) # 80005d58 <panic>
      uint64 pa = PTE2PA(*pte);
    80000892:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000894:	0532                	slli	a0,a0,0xc
    80000896:	fffff097          	auipc	ra,0xfffff
    8000089a:	786080e7          	jalr	1926(ra) # 8000001c <kfree>
    *pte = 0;
    8000089e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008a2:	995a                	add	s2,s2,s6
    800008a4:	f9397ce3          	bgeu	s2,s3,8000083c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008a8:	4601                	li	a2,0
    800008aa:	85ca                	mv	a1,s2
    800008ac:	8552                	mv	a0,s4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	cb0080e7          	jalr	-848(ra) # 8000055e <walk>
    800008b6:	84aa                	mv	s1,a0
    800008b8:	d54d                	beqz	a0,80000862 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008ba:	6108                	ld	a0,0(a0)
    800008bc:	00157793          	andi	a5,a0,1
    800008c0:	dbcd                	beqz	a5,80000872 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008c2:	3ff57793          	andi	a5,a0,1023
    800008c6:	fb778ee3          	beq	a5,s7,80000882 <uvmunmap+0x76>
    if(do_free){
    800008ca:	fc0a8ae3          	beqz	s5,8000089e <uvmunmap+0x92>
    800008ce:	b7d1                	j	80000892 <uvmunmap+0x86>

00000000800008d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008d0:	1101                	addi	sp,sp,-32
    800008d2:	ec06                	sd	ra,24(sp)
    800008d4:	e822                	sd	s0,16(sp)
    800008d6:	e426                	sd	s1,8(sp)
    800008d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008da:	00000097          	auipc	ra,0x0
    800008de:	89a080e7          	jalr	-1894(ra) # 80000174 <kalloc>
    800008e2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008e4:	c519                	beqz	a0,800008f2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008e6:	6605                	lui	a2,0x1
    800008e8:	4581                	li	a1,0
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	98c080e7          	jalr	-1652(ra) # 80000276 <memset>
  return pagetable;
}
    800008f2:	8526                	mv	a0,s1
    800008f4:	60e2                	ld	ra,24(sp)
    800008f6:	6442                	ld	s0,16(sp)
    800008f8:	64a2                	ld	s1,8(sp)
    800008fa:	6105                	addi	sp,sp,32
    800008fc:	8082                	ret

00000000800008fe <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008fe:	7179                	addi	sp,sp,-48
    80000900:	f406                	sd	ra,40(sp)
    80000902:	f022                	sd	s0,32(sp)
    80000904:	ec26                	sd	s1,24(sp)
    80000906:	e84a                	sd	s2,16(sp)
    80000908:	e44e                	sd	s3,8(sp)
    8000090a:	e052                	sd	s4,0(sp)
    8000090c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000090e:	6785                	lui	a5,0x1
    80000910:	04f67863          	bgeu	a2,a5,80000960 <uvminit+0x62>
    80000914:	8a2a                	mv	s4,a0
    80000916:	89ae                	mv	s3,a1
    80000918:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	85a080e7          	jalr	-1958(ra) # 80000174 <kalloc>
    80000922:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000924:	6605                	lui	a2,0x1
    80000926:	4581                	li	a1,0
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	94e080e7          	jalr	-1714(ra) # 80000276 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000930:	4779                	li	a4,30
    80000932:	86ca                	mv	a3,s2
    80000934:	6605                	lui	a2,0x1
    80000936:	4581                	li	a1,0
    80000938:	8552                	mv	a0,s4
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	d0c080e7          	jalr	-756(ra) # 80000646 <mappages>
  memmove(mem, src, sz);
    80000942:	8626                	mv	a2,s1
    80000944:	85ce                	mv	a1,s3
    80000946:	854a                	mv	a0,s2
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	98e080e7          	jalr	-1650(ra) # 800002d6 <memmove>
}
    80000950:	70a2                	ld	ra,40(sp)
    80000952:	7402                	ld	s0,32(sp)
    80000954:	64e2                	ld	s1,24(sp)
    80000956:	6942                	ld	s2,16(sp)
    80000958:	69a2                	ld	s3,8(sp)
    8000095a:	6a02                	ld	s4,0(sp)
    8000095c:	6145                	addi	sp,sp,48
    8000095e:	8082                	ret
    panic("inituvm: more than a page");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	7b050513          	addi	a0,a0,1968 # 80008110 <etext+0x110>
    80000968:	00005097          	auipc	ra,0x5
    8000096c:	3f0080e7          	jalr	1008(ra) # 80005d58 <panic>

0000000080000970 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000970:	1101                	addi	sp,sp,-32
    80000972:	ec06                	sd	ra,24(sp)
    80000974:	e822                	sd	s0,16(sp)
    80000976:	e426                	sd	s1,8(sp)
    80000978:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000097a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000097c:	00b67d63          	bgeu	a2,a1,80000996 <uvmdealloc+0x26>
    80000980:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000982:	6785                	lui	a5,0x1
    80000984:	17fd                	addi	a5,a5,-1
    80000986:	00f60733          	add	a4,a2,a5
    8000098a:	767d                	lui	a2,0xfffff
    8000098c:	8f71                	and	a4,a4,a2
    8000098e:	97ae                	add	a5,a5,a1
    80000990:	8ff1                	and	a5,a5,a2
    80000992:	00f76863          	bltu	a4,a5,800009a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000996:	8526                	mv	a0,s1
    80000998:	60e2                	ld	ra,24(sp)
    8000099a:	6442                	ld	s0,16(sp)
    8000099c:	64a2                	ld	s1,8(sp)
    8000099e:	6105                	addi	sp,sp,32
    800009a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009a2:	8f99                	sub	a5,a5,a4
    800009a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009a6:	4685                	li	a3,1
    800009a8:	0007861b          	sext.w	a2,a5
    800009ac:	85ba                	mv	a1,a4
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	e5e080e7          	jalr	-418(ra) # 8000080c <uvmunmap>
    800009b6:	b7c5                	j	80000996 <uvmdealloc+0x26>

00000000800009b8 <uvmalloc>:
  if(newsz < oldsz)
    800009b8:	0ab66163          	bltu	a2,a1,80000a5a <uvmalloc+0xa2>
{
    800009bc:	7139                	addi	sp,sp,-64
    800009be:	fc06                	sd	ra,56(sp)
    800009c0:	f822                	sd	s0,48(sp)
    800009c2:	f426                	sd	s1,40(sp)
    800009c4:	f04a                	sd	s2,32(sp)
    800009c6:	ec4e                	sd	s3,24(sp)
    800009c8:	e852                	sd	s4,16(sp)
    800009ca:	e456                	sd	s5,8(sp)
    800009cc:	0080                	addi	s0,sp,64
    800009ce:	8aaa                	mv	s5,a0
    800009d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009d2:	6985                	lui	s3,0x1
    800009d4:	19fd                	addi	s3,s3,-1
    800009d6:	95ce                	add	a1,a1,s3
    800009d8:	79fd                	lui	s3,0xfffff
    800009da:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009de:	08c9f063          	bgeu	s3,a2,80000a5e <uvmalloc+0xa6>
    800009e2:	894e                	mv	s2,s3
    mem = kalloc();
    800009e4:	fffff097          	auipc	ra,0xfffff
    800009e8:	790080e7          	jalr	1936(ra) # 80000174 <kalloc>
    800009ec:	84aa                	mv	s1,a0
    if(mem == 0){
    800009ee:	c51d                	beqz	a0,80000a1c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	4581                	li	a1,0
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	882080e7          	jalr	-1918(ra) # 80000276 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009fc:	4779                	li	a4,30
    800009fe:	86a6                	mv	a3,s1
    80000a00:	6605                	lui	a2,0x1
    80000a02:	85ca                	mv	a1,s2
    80000a04:	8556                	mv	a0,s5
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	c40080e7          	jalr	-960(ra) # 80000646 <mappages>
    80000a0e:	e905                	bnez	a0,80000a3e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a10:	6785                	lui	a5,0x1
    80000a12:	993e                	add	s2,s2,a5
    80000a14:	fd4968e3          	bltu	s2,s4,800009e4 <uvmalloc+0x2c>
  return newsz;
    80000a18:	8552                	mv	a0,s4
    80000a1a:	a809                	j	80000a2c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a1c:	864e                	mv	a2,s3
    80000a1e:	85ca                	mv	a1,s2
    80000a20:	8556                	mv	a0,s5
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	f4e080e7          	jalr	-178(ra) # 80000970 <uvmdealloc>
      return 0;
    80000a2a:	4501                	li	a0,0
}
    80000a2c:	70e2                	ld	ra,56(sp)
    80000a2e:	7442                	ld	s0,48(sp)
    80000a30:	74a2                	ld	s1,40(sp)
    80000a32:	7902                	ld	s2,32(sp)
    80000a34:	69e2                	ld	s3,24(sp)
    80000a36:	6a42                	ld	s4,16(sp)
    80000a38:	6aa2                	ld	s5,8(sp)
    80000a3a:	6121                	addi	sp,sp,64
    80000a3c:	8082                	ret
      kfree(mem);
    80000a3e:	8526                	mv	a0,s1
    80000a40:	fffff097          	auipc	ra,0xfffff
    80000a44:	5dc080e7          	jalr	1500(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a48:	864e                	mv	a2,s3
    80000a4a:	85ca                	mv	a1,s2
    80000a4c:	8556                	mv	a0,s5
    80000a4e:	00000097          	auipc	ra,0x0
    80000a52:	f22080e7          	jalr	-222(ra) # 80000970 <uvmdealloc>
      return 0;
    80000a56:	4501                	li	a0,0
    80000a58:	bfd1                	j	80000a2c <uvmalloc+0x74>
    return oldsz;
    80000a5a:	852e                	mv	a0,a1
}
    80000a5c:	8082                	ret
  return newsz;
    80000a5e:	8532                	mv	a0,a2
    80000a60:	b7f1                	j	80000a2c <uvmalloc+0x74>

0000000080000a62 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a62:	7179                	addi	sp,sp,-48
    80000a64:	f406                	sd	ra,40(sp)
    80000a66:	f022                	sd	s0,32(sp)
    80000a68:	ec26                	sd	s1,24(sp)
    80000a6a:	e84a                	sd	s2,16(sp)
    80000a6c:	e44e                	sd	s3,8(sp)
    80000a6e:	e052                	sd	s4,0(sp)
    80000a70:	1800                	addi	s0,sp,48
    80000a72:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a74:	84aa                	mv	s1,a0
    80000a76:	6905                	lui	s2,0x1
    80000a78:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a7a:	4985                	li	s3,1
    80000a7c:	a821                	j	80000a94 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a7e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000a80:	0532                	slli	a0,a0,0xc
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	fe0080e7          	jalr	-32(ra) # 80000a62 <freewalk>
      pagetable[i] = 0;
    80000a8a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a8e:	04a1                	addi	s1,s1,8
    80000a90:	03248163          	beq	s1,s2,80000ab2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000a94:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a96:	00f57793          	andi	a5,a0,15
    80000a9a:	ff3782e3          	beq	a5,s3,80000a7e <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a9e:	8905                	andi	a0,a0,1
    80000aa0:	d57d                	beqz	a0,80000a8e <freewalk+0x2c>
      panic("freewalk: leaf");
    80000aa2:	00007517          	auipc	a0,0x7
    80000aa6:	68e50513          	addi	a0,a0,1678 # 80008130 <etext+0x130>
    80000aaa:	00005097          	auipc	ra,0x5
    80000aae:	2ae080e7          	jalr	686(ra) # 80005d58 <panic>
    }
  }
  kfree((void*)pagetable);
    80000ab2:	8552                	mv	a0,s4
    80000ab4:	fffff097          	auipc	ra,0xfffff
    80000ab8:	568080e7          	jalr	1384(ra) # 8000001c <kfree>
}
    80000abc:	70a2                	ld	ra,40(sp)
    80000abe:	7402                	ld	s0,32(sp)
    80000ac0:	64e2                	ld	s1,24(sp)
    80000ac2:	6942                	ld	s2,16(sp)
    80000ac4:	69a2                	ld	s3,8(sp)
    80000ac6:	6a02                	ld	s4,0(sp)
    80000ac8:	6145                	addi	sp,sp,48
    80000aca:	8082                	ret

0000000080000acc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000acc:	1101                	addi	sp,sp,-32
    80000ace:	ec06                	sd	ra,24(sp)
    80000ad0:	e822                	sd	s0,16(sp)
    80000ad2:	e426                	sd	s1,8(sp)
    80000ad4:	1000                	addi	s0,sp,32
    80000ad6:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ad8:	e999                	bnez	a1,80000aee <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ada:	8526                	mv	a0,s1
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	f86080e7          	jalr	-122(ra) # 80000a62 <freewalk>
}
    80000ae4:	60e2                	ld	ra,24(sp)
    80000ae6:	6442                	ld	s0,16(sp)
    80000ae8:	64a2                	ld	s1,8(sp)
    80000aea:	6105                	addi	sp,sp,32
    80000aec:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000aee:	6605                	lui	a2,0x1
    80000af0:	167d                	addi	a2,a2,-1
    80000af2:	962e                	add	a2,a2,a1
    80000af4:	4685                	li	a3,1
    80000af6:	8231                	srli	a2,a2,0xc
    80000af8:	4581                	li	a1,0
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	d12080e7          	jalr	-750(ra) # 8000080c <uvmunmap>
    80000b02:	bfe1                	j	80000ada <uvmfree+0xe>

0000000080000b04 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b04:	7139                	addi	sp,sp,-64
    80000b06:	fc06                	sd	ra,56(sp)
    80000b08:	f822                	sd	s0,48(sp)
    80000b0a:	f426                	sd	s1,40(sp)
    80000b0c:	f04a                	sd	s2,32(sp)
    80000b0e:	ec4e                	sd	s3,24(sp)
    80000b10:	e852                	sd	s4,16(sp)
    80000b12:	e456                	sd	s5,8(sp)
    80000b14:	e05a                	sd	s6,0(sp)
    80000b16:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    80000b18:	c255                	beqz	a2,80000bbc <uvmcopy+0xb8>
    80000b1a:	8b2a                	mv	s6,a0
    80000b1c:	8aae                	mv	s5,a1
    80000b1e:	8a32                	mv	s4,a2
    80000b20:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000b22:	4601                	li	a2,0
    80000b24:	85a6                	mv	a1,s1
    80000b26:	855a                	mv	a0,s6
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	a36080e7          	jalr	-1482(ra) # 8000055e <walk>
    80000b30:	c129                	beqz	a0,80000b72 <uvmcopy+0x6e>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b32:	6118                	ld	a4,0(a0)
    80000b34:	00177793          	andi	a5,a4,1
    80000b38:	c7a9                	beqz	a5,80000b82 <uvmcopy+0x7e>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b3a:	00a75913          	srli	s2,a4,0xa
    80000b3e:	0932                	slli	s2,s2,0xc
    *pte &= ~PTE_W;  // 变为只读页面, 不允许写. 一旦试图写, 会触发num=15的trap
    80000b40:	9b6d                	andi	a4,a4,-5
    80000b42:	e118                	sd	a4,0(a0)
    flags = PTE_FLAGS(*pte);
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80000b44:	3fb77713          	andi	a4,a4,1019
    80000b48:	86ca                	mv	a3,s2
    80000b4a:	6605                	lui	a2,0x1
    80000b4c:	85a6                	mv	a1,s1
    80000b4e:	8556                	mv	a0,s5
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	af6080e7          	jalr	-1290(ra) # 80000646 <mappages>
    80000b58:	89aa                	mv	s3,a0
    80000b5a:	ed05                	bnez	a0,80000b92 <uvmcopy+0x8e>
      goto err;
    }
    adjustref(pa, 1); // 增加计数器
    80000b5c:	4585                	li	a1,1
    80000b5e:	854a                	mv	a0,s2
    80000b60:	fffff097          	auipc	ra,0xfffff
    80000b64:	6ac080e7          	jalr	1708(ra) # 8000020c <adjustref>
  for(i = 0; i < sz; i += PGSIZE){
    80000b68:	6785                	lui	a5,0x1
    80000b6a:	94be                	add	s1,s1,a5
    80000b6c:	fb44ebe3          	bltu	s1,s4,80000b22 <uvmcopy+0x1e>
    80000b70:	a81d                	j	80000ba6 <uvmcopy+0xa2>
      panic("uvmcopy: pte should exist");
    80000b72:	00007517          	auipc	a0,0x7
    80000b76:	5ce50513          	addi	a0,a0,1486 # 80008140 <etext+0x140>
    80000b7a:	00005097          	auipc	ra,0x5
    80000b7e:	1de080e7          	jalr	478(ra) # 80005d58 <panic>
      panic("uvmcopy: page not present");
    80000b82:	00007517          	auipc	a0,0x7
    80000b86:	5de50513          	addi	a0,a0,1502 # 80008160 <etext+0x160>
    80000b8a:	00005097          	auipc	ra,0x5
    80000b8e:	1ce080e7          	jalr	462(ra) # 80005d58 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b92:	4685                	li	a3,1
    80000b94:	00c4d613          	srli	a2,s1,0xc
    80000b98:	4581                	li	a1,0
    80000b9a:	8556                	mv	a0,s5
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	c70080e7          	jalr	-912(ra) # 8000080c <uvmunmap>
  return -1;
    80000ba4:	59fd                	li	s3,-1
}
    80000ba6:	854e                	mv	a0,s3
    80000ba8:	70e2                	ld	ra,56(sp)
    80000baa:	7442                	ld	s0,48(sp)
    80000bac:	74a2                	ld	s1,40(sp)
    80000bae:	7902                	ld	s2,32(sp)
    80000bb0:	69e2                	ld	s3,24(sp)
    80000bb2:	6a42                	ld	s4,16(sp)
    80000bb4:	6aa2                	ld	s5,8(sp)
    80000bb6:	6b02                	ld	s6,0(sp)
    80000bb8:	6121                	addi	sp,sp,64
    80000bba:	8082                	ret
  return 0;
    80000bbc:	4981                	li	s3,0
    80000bbe:	b7e5                	j	80000ba6 <uvmcopy+0xa2>

0000000080000bc0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bc0:	1141                	addi	sp,sp,-16
    80000bc2:	e406                	sd	ra,8(sp)
    80000bc4:	e022                	sd	s0,0(sp)
    80000bc6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bc8:	4601                	li	a2,0
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	994080e7          	jalr	-1644(ra) # 8000055e <walk>
  if(pte == 0)
    80000bd2:	c901                	beqz	a0,80000be2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bd4:	611c                	ld	a5,0(a0)
    80000bd6:	9bbd                	andi	a5,a5,-17
    80000bd8:	e11c                	sd	a5,0(a0)
}
    80000bda:	60a2                	ld	ra,8(sp)
    80000bdc:	6402                	ld	s0,0(sp)
    80000bde:	0141                	addi	sp,sp,16
    80000be0:	8082                	ret
    panic("uvmclear");
    80000be2:	00007517          	auipc	a0,0x7
    80000be6:	59e50513          	addi	a0,a0,1438 # 80008180 <etext+0x180>
    80000bea:	00005097          	auipc	ra,0x5
    80000bee:	16e080e7          	jalr	366(ra) # 80005d58 <panic>

0000000080000bf2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bf2:	c6bd                	beqz	a3,80000c60 <copyin+0x6e>
{
    80000bf4:	715d                	addi	sp,sp,-80
    80000bf6:	e486                	sd	ra,72(sp)
    80000bf8:	e0a2                	sd	s0,64(sp)
    80000bfa:	fc26                	sd	s1,56(sp)
    80000bfc:	f84a                	sd	s2,48(sp)
    80000bfe:	f44e                	sd	s3,40(sp)
    80000c00:	f052                	sd	s4,32(sp)
    80000c02:	ec56                	sd	s5,24(sp)
    80000c04:	e85a                	sd	s6,16(sp)
    80000c06:	e45e                	sd	s7,8(sp)
    80000c08:	e062                	sd	s8,0(sp)
    80000c0a:	0880                	addi	s0,sp,80
    80000c0c:	8b2a                	mv	s6,a0
    80000c0e:	8a2e                	mv	s4,a1
    80000c10:	8c32                	mv	s8,a2
    80000c12:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c14:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c16:	6a85                	lui	s5,0x1
    80000c18:	a015                	j	80000c3c <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c1a:	9562                	add	a0,a0,s8
    80000c1c:	0004861b          	sext.w	a2,s1
    80000c20:	412505b3          	sub	a1,a0,s2
    80000c24:	8552                	mv	a0,s4
    80000c26:	fffff097          	auipc	ra,0xfffff
    80000c2a:	6b0080e7          	jalr	1712(ra) # 800002d6 <memmove>

    len -= n;
    80000c2e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c32:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c34:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c38:	02098263          	beqz	s3,80000c5c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c40:	85ca                	mv	a1,s2
    80000c42:	855a                	mv	a0,s6
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	9c0080e7          	jalr	-1600(ra) # 80000604 <walkaddr>
    if(pa0 == 0)
    80000c4c:	cd01                	beqz	a0,80000c64 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c4e:	418904b3          	sub	s1,s2,s8
    80000c52:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c54:	fc99f3e3          	bgeu	s3,s1,80000c1a <copyin+0x28>
    80000c58:	84ce                	mv	s1,s3
    80000c5a:	b7c1                	j	80000c1a <copyin+0x28>
  }
  return 0;
    80000c5c:	4501                	li	a0,0
    80000c5e:	a021                	j	80000c66 <copyin+0x74>
    80000c60:	4501                	li	a0,0
}
    80000c62:	8082                	ret
      return -1;
    80000c64:	557d                	li	a0,-1
}
    80000c66:	60a6                	ld	ra,72(sp)
    80000c68:	6406                	ld	s0,64(sp)
    80000c6a:	74e2                	ld	s1,56(sp)
    80000c6c:	7942                	ld	s2,48(sp)
    80000c6e:	79a2                	ld	s3,40(sp)
    80000c70:	7a02                	ld	s4,32(sp)
    80000c72:	6ae2                	ld	s5,24(sp)
    80000c74:	6b42                	ld	s6,16(sp)
    80000c76:	6ba2                	ld	s7,8(sp)
    80000c78:	6c02                	ld	s8,0(sp)
    80000c7a:	6161                	addi	sp,sp,80
    80000c7c:	8082                	ret

0000000080000c7e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7e:	c6c5                	beqz	a3,80000d26 <copyinstr+0xa8>
{
    80000c80:	715d                	addi	sp,sp,-80
    80000c82:	e486                	sd	ra,72(sp)
    80000c84:	e0a2                	sd	s0,64(sp)
    80000c86:	fc26                	sd	s1,56(sp)
    80000c88:	f84a                	sd	s2,48(sp)
    80000c8a:	f44e                	sd	s3,40(sp)
    80000c8c:	f052                	sd	s4,32(sp)
    80000c8e:	ec56                	sd	s5,24(sp)
    80000c90:	e85a                	sd	s6,16(sp)
    80000c92:	e45e                	sd	s7,8(sp)
    80000c94:	0880                	addi	s0,sp,80
    80000c96:	8a2a                	mv	s4,a0
    80000c98:	8b2e                	mv	s6,a1
    80000c9a:	8bb2                	mv	s7,a2
    80000c9c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca0:	6985                	lui	s3,0x1
    80000ca2:	a035                	j	80000cce <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000caa:	0017b793          	seqz	a5,a5
    80000cae:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cb2:	60a6                	ld	ra,72(sp)
    80000cb4:	6406                	ld	s0,64(sp)
    80000cb6:	74e2                	ld	s1,56(sp)
    80000cb8:	7942                	ld	s2,48(sp)
    80000cba:	79a2                	ld	s3,40(sp)
    80000cbc:	7a02                	ld	s4,32(sp)
    80000cbe:	6ae2                	ld	s5,24(sp)
    80000cc0:	6b42                	ld	s6,16(sp)
    80000cc2:	6ba2                	ld	s7,8(sp)
    80000cc4:	6161                	addi	sp,sp,80
    80000cc6:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cc8:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000ccc:	c8a9                	beqz	s1,80000d1e <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cce:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cd2:	85ca                	mv	a1,s2
    80000cd4:	8552                	mv	a0,s4
    80000cd6:	00000097          	auipc	ra,0x0
    80000cda:	92e080e7          	jalr	-1746(ra) # 80000604 <walkaddr>
    if(pa0 == 0)
    80000cde:	c131                	beqz	a0,80000d22 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ce0:	41790833          	sub	a6,s2,s7
    80000ce4:	984e                	add	a6,a6,s3
    if(n > max)
    80000ce6:	0104f363          	bgeu	s1,a6,80000cec <copyinstr+0x6e>
    80000cea:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cec:	955e                	add	a0,a0,s7
    80000cee:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cf2:	fc080be3          	beqz	a6,80000cc8 <copyinstr+0x4a>
    80000cf6:	985a                	add	a6,a6,s6
    80000cf8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cfa:	41650633          	sub	a2,a0,s6
    80000cfe:	14fd                	addi	s1,s1,-1
    80000d00:	9b26                	add	s6,s6,s1
    80000d02:	00f60733          	add	a4,a2,a5
    80000d06:	00074703          	lbu	a4,0(a4)
    80000d0a:	df49                	beqz	a4,80000ca4 <copyinstr+0x26>
        *dst = *p;
    80000d0c:	00e78023          	sb	a4,0(a5)
      --max;
    80000d10:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d14:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d16:	ff0796e3          	bne	a5,a6,80000d02 <copyinstr+0x84>
      dst++;
    80000d1a:	8b42                	mv	s6,a6
    80000d1c:	b775                	j	80000cc8 <copyinstr+0x4a>
    80000d1e:	4781                	li	a5,0
    80000d20:	b769                	j	80000caa <copyinstr+0x2c>
      return -1;
    80000d22:	557d                	li	a0,-1
    80000d24:	b779                	j	80000cb2 <copyinstr+0x34>
  int got_null = 0;
    80000d26:	4781                	li	a5,0
  if(got_null){
    80000d28:	0017b793          	seqz	a5,a5
    80000d2c:	40f00533          	neg	a0,a5
}
    80000d30:	8082                	ret

0000000080000d32 <cowalloc>:

int
cowalloc(pagetable_t pagetable, uint64 va) {
    80000d32:	7179                	addi	sp,sp,-48
    80000d34:	f406                	sd	ra,40(sp)
    80000d36:	f022                	sd	s0,32(sp)
    80000d38:	ec26                	sd	s1,24(sp)
    80000d3a:	e84a                	sd	s2,16(sp)
    80000d3c:	e44e                	sd	s3,8(sp)
    80000d3e:	1800                	addi	s0,sp,48
  if (va >= MAXVA) {
    80000d40:	57fd                	li	a5,-1
    80000d42:	83e9                	srli	a5,a5,0x1a
    80000d44:	06b7e763          	bltu	a5,a1,80000db2 <cowalloc+0x80>
    printf("cowalloc: exceeds MAXVA\n");
    return -1;
  }

  pte_t* pte = walk(pagetable, va, 0); // should refer to a shared PA
    80000d48:	4601                	li	a2,0
    80000d4a:	00000097          	auipc	ra,0x0
    80000d4e:	814080e7          	jalr	-2028(ra) # 8000055e <walk>
    80000d52:	892a                	mv	s2,a0
  if (pte == 0) {
    80000d54:	c92d                	beqz	a0,80000dc6 <cowalloc+0x94>
    panic("cowalloc: pte not exists");
  }
  if ((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) {
    80000d56:	611c                	ld	a5,0(a0)
    80000d58:	8bc5                	andi	a5,a5,17
    80000d5a:	4745                	li	a4,17
    80000d5c:	06e79d63          	bne	a5,a4,80000dd6 <cowalloc+0xa4>
    panic("cowalloc: pte permission err");
  }
  uint64 pa_new = (uint64)kalloc();
    80000d60:	fffff097          	auipc	ra,0xfffff
    80000d64:	414080e7          	jalr	1044(ra) # 80000174 <kalloc>
    80000d68:	84aa                	mv	s1,a0
  if (pa_new == 0) {
    80000d6a:	cd35                	beqz	a0,80000de6 <cowalloc+0xb4>
    printf("cowalloc: kalloc fails\n");
    return -1;
  }
  uint64 pa_old = PTE2PA(*pte);
    80000d6c:	00093983          	ld	s3,0(s2) # 1000 <_entry-0x7ffff000>
    80000d70:	00a9d993          	srli	s3,s3,0xa
    80000d74:	09b2                	slli	s3,s3,0xc
  memmove((void *)pa_new, (const void *)pa_old, PGSIZE);
    80000d76:	6605                	lui	a2,0x1
    80000d78:	85ce                	mv	a1,s3
    80000d7a:	fffff097          	auipc	ra,0xfffff
    80000d7e:	55c080e7          	jalr	1372(ra) # 800002d6 <memmove>
  kfree((void *)pa_old); // 减少COW页面的reference count
    80000d82:	854e                	mv	a0,s3
    80000d84:	fffff097          	auipc	ra,0xfffff
    80000d88:	298080e7          	jalr	664(ra) # 8000001c <kfree>
  *pte = PA2PTE(pa_new) | PTE_FLAGS(*pte) | PTE_W;
    80000d8c:	80b1                	srli	s1,s1,0xc
    80000d8e:	04aa                	slli	s1,s1,0xa
    80000d90:	00093783          	ld	a5,0(s2)
    80000d94:	3ff7f793          	andi	a5,a5,1023
    80000d98:	8cdd                	or	s1,s1,a5
    80000d9a:	0044e493          	ori	s1,s1,4
    80000d9e:	00993023          	sd	s1,0(s2)
  return 0;
    80000da2:	4501                	li	a0,0
}
    80000da4:	70a2                	ld	ra,40(sp)
    80000da6:	7402                	ld	s0,32(sp)
    80000da8:	64e2                	ld	s1,24(sp)
    80000daa:	6942                	ld	s2,16(sp)
    80000dac:	69a2                	ld	s3,8(sp)
    80000dae:	6145                	addi	sp,sp,48
    80000db0:	8082                	ret
    printf("cowalloc: exceeds MAXVA\n");
    80000db2:	00007517          	auipc	a0,0x7
    80000db6:	3de50513          	addi	a0,a0,990 # 80008190 <etext+0x190>
    80000dba:	00005097          	auipc	ra,0x5
    80000dbe:	fe8080e7          	jalr	-24(ra) # 80005da2 <printf>
    return -1;
    80000dc2:	557d                	li	a0,-1
    80000dc4:	b7c5                	j	80000da4 <cowalloc+0x72>
    panic("cowalloc: pte not exists");
    80000dc6:	00007517          	auipc	a0,0x7
    80000dca:	3ea50513          	addi	a0,a0,1002 # 800081b0 <etext+0x1b0>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	f8a080e7          	jalr	-118(ra) # 80005d58 <panic>
    panic("cowalloc: pte permission err");
    80000dd6:	00007517          	auipc	a0,0x7
    80000dda:	3fa50513          	addi	a0,a0,1018 # 800081d0 <etext+0x1d0>
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	f7a080e7          	jalr	-134(ra) # 80005d58 <panic>
    printf("cowalloc: kalloc fails\n");
    80000de6:	00007517          	auipc	a0,0x7
    80000dea:	40a50513          	addi	a0,a0,1034 # 800081f0 <etext+0x1f0>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	fb4080e7          	jalr	-76(ra) # 80005da2 <printf>
    return -1;
    80000df6:	557d                	li	a0,-1
    80000df8:	b775                	j	80000da4 <cowalloc+0x72>

0000000080000dfa <copyout>:
  while(len > 0){
    80000dfa:	caed                	beqz	a3,80000eec <copyout+0xf2>
{
    80000dfc:	711d                	addi	sp,sp,-96
    80000dfe:	ec86                	sd	ra,88(sp)
    80000e00:	e8a2                	sd	s0,80(sp)
    80000e02:	e4a6                	sd	s1,72(sp)
    80000e04:	e0ca                	sd	s2,64(sp)
    80000e06:	fc4e                	sd	s3,56(sp)
    80000e08:	f852                	sd	s4,48(sp)
    80000e0a:	f456                	sd	s5,40(sp)
    80000e0c:	f05a                	sd	s6,32(sp)
    80000e0e:	ec5e                	sd	s7,24(sp)
    80000e10:	e862                	sd	s8,16(sp)
    80000e12:	e466                	sd	s9,8(sp)
    80000e14:	e06a                	sd	s10,0(sp)
    80000e16:	1080                	addi	s0,sp,96
    80000e18:	8b2a                	mv	s6,a0
    80000e1a:	8a2e                	mv	s4,a1
    80000e1c:	8ab2                	mv	s5,a2
    80000e1e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000e20:	74fd                	lui	s1,0xfffff
    80000e22:	8ced                	and	s1,s1,a1
    if (va0 >= MAXVA) {
    80000e24:	57fd                	li	a5,-1
    80000e26:	83e9                	srli	a5,a5,0x1a
    80000e28:	0097e663          	bltu	a5,s1,80000e34 <copyout+0x3a>
    if (pte == 0 || (*pte & PTE_U) == 0 || (*pte & PTE_V) == 0) {
    80000e2c:	4c45                	li	s8,17
    80000e2e:	6c85                	lui	s9,0x1
    if (va0 >= MAXVA) {
    80000e30:	8bbe                	mv	s7,a5
    80000e32:	a0ad                	j	80000e9c <copyout+0xa2>
      printf("copyout: va exceeds MAXVA\n");
    80000e34:	00007517          	auipc	a0,0x7
    80000e38:	3d450513          	addi	a0,a0,980 # 80008208 <etext+0x208>
    80000e3c:	00005097          	auipc	ra,0x5
    80000e40:	f66080e7          	jalr	-154(ra) # 80005da2 <printf>
      return -1;
    80000e44:	557d                	li	a0,-1
    80000e46:	a811                	j	80000e5a <copyout+0x60>
      printf("copyout: invalid pte\n");
    80000e48:	00007517          	auipc	a0,0x7
    80000e4c:	3e050513          	addi	a0,a0,992 # 80008228 <etext+0x228>
    80000e50:	00005097          	auipc	ra,0x5
    80000e54:	f52080e7          	jalr	-174(ra) # 80005da2 <printf>
      return -1;
    80000e58:	557d                	li	a0,-1
}
    80000e5a:	60e6                	ld	ra,88(sp)
    80000e5c:	6446                	ld	s0,80(sp)
    80000e5e:	64a6                	ld	s1,72(sp)
    80000e60:	6906                	ld	s2,64(sp)
    80000e62:	79e2                	ld	s3,56(sp)
    80000e64:	7a42                	ld	s4,48(sp)
    80000e66:	7aa2                	ld	s5,40(sp)
    80000e68:	7b02                	ld	s6,32(sp)
    80000e6a:	6be2                	ld	s7,24(sp)
    80000e6c:	6c42                	ld	s8,16(sp)
    80000e6e:	6ca2                	ld	s9,8(sp)
    80000e70:	6d02                	ld	s10,0(sp)
    80000e72:	6125                	addi	sp,sp,96
    80000e74:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000e76:	409a04b3          	sub	s1,s4,s1
    80000e7a:	0009061b          	sext.w	a2,s2
    80000e7e:	85d6                	mv	a1,s5
    80000e80:	9526                	add	a0,a0,s1
    80000e82:	fffff097          	auipc	ra,0xfffff
    80000e86:	454080e7          	jalr	1108(ra) # 800002d6 <memmove>
    len -= n;
    80000e8a:	412989b3          	sub	s3,s3,s2
    src += n;
    80000e8e:	9aca                	add	s5,s5,s2
  while(len > 0){
    80000e90:	04098c63          	beqz	s3,80000ee8 <copyout+0xee>
    if (va0 >= MAXVA) {
    80000e94:	fbabe0e3          	bltu	s7,s10,80000e34 <copyout+0x3a>
    va0 = PGROUNDDOWN(dstva);
    80000e98:	84ea                	mv	s1,s10
    dstva = va0 + PGSIZE;
    80000e9a:	8a6a                	mv	s4,s10
    pte_t *pte = walk(pagetable, va0, 0);
    80000e9c:	4601                	li	a2,0
    80000e9e:	85a6                	mv	a1,s1
    80000ea0:	855a                	mv	a0,s6
    80000ea2:	fffff097          	auipc	ra,0xfffff
    80000ea6:	6bc080e7          	jalr	1724(ra) # 8000055e <walk>
    if (pte == 0 || (*pte & PTE_U) == 0 || (*pte & PTE_V) == 0) {
    80000eaa:	dd59                	beqz	a0,80000e48 <copyout+0x4e>
    80000eac:	611c                	ld	a5,0(a0)
    80000eae:	0117f713          	andi	a4,a5,17
    80000eb2:	f9871be3          	bne	a4,s8,80000e48 <copyout+0x4e>
    if ((*pte & PTE_W) == 0) {
    80000eb6:	8b91                	andi	a5,a5,4
    80000eb8:	eb89                	bnez	a5,80000eca <copyout+0xd0>
      if (cowalloc(pagetable, va0) < 0) {
    80000eba:	85a6                	mv	a1,s1
    80000ebc:	855a                	mv	a0,s6
    80000ebe:	00000097          	auipc	ra,0x0
    80000ec2:	e74080e7          	jalr	-396(ra) # 80000d32 <cowalloc>
    80000ec6:	02054563          	bltz	a0,80000ef0 <copyout+0xf6>
    pa0 = walkaddr(pagetable, va0);
    80000eca:	85a6                	mv	a1,s1
    80000ecc:	855a                	mv	a0,s6
    80000ece:	fffff097          	auipc	ra,0xfffff
    80000ed2:	736080e7          	jalr	1846(ra) # 80000604 <walkaddr>
    if(pa0 == 0)
    80000ed6:	cd19                	beqz	a0,80000ef4 <copyout+0xfa>
    n = PGSIZE - (dstva - va0);
    80000ed8:	01948d33          	add	s10,s1,s9
    80000edc:	414d0933          	sub	s2,s10,s4
    if(n > len)
    80000ee0:	f929fbe3          	bgeu	s3,s2,80000e76 <copyout+0x7c>
    80000ee4:	894e                	mv	s2,s3
    80000ee6:	bf41                	j	80000e76 <copyout+0x7c>
  return 0;
    80000ee8:	4501                	li	a0,0
    80000eea:	bf85                	j	80000e5a <copyout+0x60>
    80000eec:	4501                	li	a0,0
}
    80000eee:	8082                	ret
        return -1;
    80000ef0:	557d                	li	a0,-1
    80000ef2:	b7a5                	j	80000e5a <copyout+0x60>
      return -1;
    80000ef4:	557d                	li	a0,-1
    80000ef6:	b795                	j	80000e5a <copyout+0x60>

0000000080000ef8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000ef8:	7139                	addi	sp,sp,-64
    80000efa:	fc06                	sd	ra,56(sp)
    80000efc:	f822                	sd	s0,48(sp)
    80000efe:	f426                	sd	s1,40(sp)
    80000f00:	f04a                	sd	s2,32(sp)
    80000f02:	ec4e                	sd	s3,24(sp)
    80000f04:	e852                	sd	s4,16(sp)
    80000f06:	e456                	sd	s5,8(sp)
    80000f08:	e05a                	sd	s6,0(sp)
    80000f0a:	0080                	addi	s0,sp,64
    80000f0c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0e:	00228497          	auipc	s1,0x228
    80000f12:	57248493          	addi	s1,s1,1394 # 80229480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f16:	8b26                	mv	s6,s1
    80000f18:	00007a97          	auipc	s5,0x7
    80000f1c:	0e8a8a93          	addi	s5,s5,232 # 80008000 <etext>
    80000f20:	04000937          	lui	s2,0x4000
    80000f24:	197d                	addi	s2,s2,-1
    80000f26:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f28:	0022ea17          	auipc	s4,0x22e
    80000f2c:	f58a0a13          	addi	s4,s4,-168 # 8022ee80 <tickslock>
    char *pa = kalloc();
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	244080e7          	jalr	580(ra) # 80000174 <kalloc>
    80000f38:	862a                	mv	a2,a0
    if(pa == 0)
    80000f3a:	c131                	beqz	a0,80000f7e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f3c:	416485b3          	sub	a1,s1,s6
    80000f40:	858d                	srai	a1,a1,0x3
    80000f42:	000ab783          	ld	a5,0(s5)
    80000f46:	02f585b3          	mul	a1,a1,a5
    80000f4a:	2585                	addiw	a1,a1,1
    80000f4c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f50:	4719                	li	a4,6
    80000f52:	6685                	lui	a3,0x1
    80000f54:	40b905b3          	sub	a1,s2,a1
    80000f58:	854e                	mv	a0,s3
    80000f5a:	fffff097          	auipc	ra,0xfffff
    80000f5e:	78c080e7          	jalr	1932(ra) # 800006e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f62:	16848493          	addi	s1,s1,360
    80000f66:	fd4495e3          	bne	s1,s4,80000f30 <proc_mapstacks+0x38>
  }
}
    80000f6a:	70e2                	ld	ra,56(sp)
    80000f6c:	7442                	ld	s0,48(sp)
    80000f6e:	74a2                	ld	s1,40(sp)
    80000f70:	7902                	ld	s2,32(sp)
    80000f72:	69e2                	ld	s3,24(sp)
    80000f74:	6a42                	ld	s4,16(sp)
    80000f76:	6aa2                	ld	s5,8(sp)
    80000f78:	6b02                	ld	s6,0(sp)
    80000f7a:	6121                	addi	sp,sp,64
    80000f7c:	8082                	ret
      panic("kalloc");
    80000f7e:	00007517          	auipc	a0,0x7
    80000f82:	2c250513          	addi	a0,a0,706 # 80008240 <etext+0x240>
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	dd2080e7          	jalr	-558(ra) # 80005d58 <panic>

0000000080000f8e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f8e:	7139                	addi	sp,sp,-64
    80000f90:	fc06                	sd	ra,56(sp)
    80000f92:	f822                	sd	s0,48(sp)
    80000f94:	f426                	sd	s1,40(sp)
    80000f96:	f04a                	sd	s2,32(sp)
    80000f98:	ec4e                	sd	s3,24(sp)
    80000f9a:	e852                	sd	s4,16(sp)
    80000f9c:	e456                	sd	s5,8(sp)
    80000f9e:	e05a                	sd	s6,0(sp)
    80000fa0:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000fa2:	00007597          	auipc	a1,0x7
    80000fa6:	2a658593          	addi	a1,a1,678 # 80008248 <etext+0x248>
    80000faa:	00228517          	auipc	a0,0x228
    80000fae:	0a650513          	addi	a0,a0,166 # 80229050 <pid_lock>
    80000fb2:	00005097          	auipc	ra,0x5
    80000fb6:	260080e7          	jalr	608(ra) # 80006212 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fba:	00007597          	auipc	a1,0x7
    80000fbe:	29658593          	addi	a1,a1,662 # 80008250 <etext+0x250>
    80000fc2:	00228517          	auipc	a0,0x228
    80000fc6:	0a650513          	addi	a0,a0,166 # 80229068 <wait_lock>
    80000fca:	00005097          	auipc	ra,0x5
    80000fce:	248080e7          	jalr	584(ra) # 80006212 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd2:	00228497          	auipc	s1,0x228
    80000fd6:	4ae48493          	addi	s1,s1,1198 # 80229480 <proc>
      initlock(&p->lock, "proc");
    80000fda:	00007b17          	auipc	s6,0x7
    80000fde:	286b0b13          	addi	s6,s6,646 # 80008260 <etext+0x260>
      p->kstack = KSTACK((int) (p - proc));
    80000fe2:	8aa6                	mv	s5,s1
    80000fe4:	00007a17          	auipc	s4,0x7
    80000fe8:	01ca0a13          	addi	s4,s4,28 # 80008000 <etext>
    80000fec:	04000937          	lui	s2,0x4000
    80000ff0:	197d                	addi	s2,s2,-1
    80000ff2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff4:	0022e997          	auipc	s3,0x22e
    80000ff8:	e8c98993          	addi	s3,s3,-372 # 8022ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000ffc:	85da                	mv	a1,s6
    80000ffe:	8526                	mv	a0,s1
    80001000:	00005097          	auipc	ra,0x5
    80001004:	212080e7          	jalr	530(ra) # 80006212 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001008:	415487b3          	sub	a5,s1,s5
    8000100c:	878d                	srai	a5,a5,0x3
    8000100e:	000a3703          	ld	a4,0(s4)
    80001012:	02e787b3          	mul	a5,a5,a4
    80001016:	2785                	addiw	a5,a5,1
    80001018:	00d7979b          	slliw	a5,a5,0xd
    8000101c:	40f907b3          	sub	a5,s2,a5
    80001020:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001022:	16848493          	addi	s1,s1,360
    80001026:	fd349be3          	bne	s1,s3,80000ffc <procinit+0x6e>
  }
}
    8000102a:	70e2                	ld	ra,56(sp)
    8000102c:	7442                	ld	s0,48(sp)
    8000102e:	74a2                	ld	s1,40(sp)
    80001030:	7902                	ld	s2,32(sp)
    80001032:	69e2                	ld	s3,24(sp)
    80001034:	6a42                	ld	s4,16(sp)
    80001036:	6aa2                	ld	s5,8(sp)
    80001038:	6b02                	ld	s6,0(sp)
    8000103a:	6121                	addi	sp,sp,64
    8000103c:	8082                	ret

000000008000103e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000103e:	1141                	addi	sp,sp,-16
    80001040:	e422                	sd	s0,8(sp)
    80001042:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001044:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001046:	2501                	sext.w	a0,a0
    80001048:	6422                	ld	s0,8(sp)
    8000104a:	0141                	addi	sp,sp,16
    8000104c:	8082                	ret

000000008000104e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000104e:	1141                	addi	sp,sp,-16
    80001050:	e422                	sd	s0,8(sp)
    80001052:	0800                	addi	s0,sp,16
    80001054:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001056:	2781                	sext.w	a5,a5
    80001058:	079e                	slli	a5,a5,0x7
  return c;
}
    8000105a:	00228517          	auipc	a0,0x228
    8000105e:	02650513          	addi	a0,a0,38 # 80229080 <cpus>
    80001062:	953e                	add	a0,a0,a5
    80001064:	6422                	ld	s0,8(sp)
    80001066:	0141                	addi	sp,sp,16
    80001068:	8082                	ret

000000008000106a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000106a:	1101                	addi	sp,sp,-32
    8000106c:	ec06                	sd	ra,24(sp)
    8000106e:	e822                	sd	s0,16(sp)
    80001070:	e426                	sd	s1,8(sp)
    80001072:	1000                	addi	s0,sp,32
  push_off();
    80001074:	00005097          	auipc	ra,0x5
    80001078:	1e2080e7          	jalr	482(ra) # 80006256 <push_off>
    8000107c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000107e:	2781                	sext.w	a5,a5
    80001080:	079e                	slli	a5,a5,0x7
    80001082:	00228717          	auipc	a4,0x228
    80001086:	fce70713          	addi	a4,a4,-50 # 80229050 <pid_lock>
    8000108a:	97ba                	add	a5,a5,a4
    8000108c:	7b84                	ld	s1,48(a5)
  pop_off();
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	268080e7          	jalr	616(ra) # 800062f6 <pop_off>
  return p;
}
    80001096:	8526                	mv	a0,s1
    80001098:	60e2                	ld	ra,24(sp)
    8000109a:	6442                	ld	s0,16(sp)
    8000109c:	64a2                	ld	s1,8(sp)
    8000109e:	6105                	addi	sp,sp,32
    800010a0:	8082                	ret

00000000800010a2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010a2:	1141                	addi	sp,sp,-16
    800010a4:	e406                	sd	ra,8(sp)
    800010a6:	e022                	sd	s0,0(sp)
    800010a8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010aa:	00000097          	auipc	ra,0x0
    800010ae:	fc0080e7          	jalr	-64(ra) # 8000106a <myproc>
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	2a4080e7          	jalr	676(ra) # 80006356 <release>

  if (first) {
    800010ba:	00008797          	auipc	a5,0x8
    800010be:	8467a783          	lw	a5,-1978(a5) # 80008900 <first.1678>
    800010c2:	eb89                	bnez	a5,800010d4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010c4:	00001097          	auipc	ra,0x1
    800010c8:	c0a080e7          	jalr	-1014(ra) # 80001cce <usertrapret>
}
    800010cc:	60a2                	ld	ra,8(sp)
    800010ce:	6402                	ld	s0,0(sp)
    800010d0:	0141                	addi	sp,sp,16
    800010d2:	8082                	ret
    first = 0;
    800010d4:	00008797          	auipc	a5,0x8
    800010d8:	8207a623          	sw	zero,-2004(a5) # 80008900 <first.1678>
    fsinit(ROOTDEV);
    800010dc:	4505                	li	a0,1
    800010de:	00002097          	auipc	ra,0x2
    800010e2:	956080e7          	jalr	-1706(ra) # 80002a34 <fsinit>
    800010e6:	bff9                	j	800010c4 <forkret+0x22>

00000000800010e8 <allocpid>:
allocpid() {
    800010e8:	1101                	addi	sp,sp,-32
    800010ea:	ec06                	sd	ra,24(sp)
    800010ec:	e822                	sd	s0,16(sp)
    800010ee:	e426                	sd	s1,8(sp)
    800010f0:	e04a                	sd	s2,0(sp)
    800010f2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010f4:	00228917          	auipc	s2,0x228
    800010f8:	f5c90913          	addi	s2,s2,-164 # 80229050 <pid_lock>
    800010fc:	854a                	mv	a0,s2
    800010fe:	00005097          	auipc	ra,0x5
    80001102:	1a4080e7          	jalr	420(ra) # 800062a2 <acquire>
  pid = nextpid;
    80001106:	00007797          	auipc	a5,0x7
    8000110a:	7fe78793          	addi	a5,a5,2046 # 80008904 <nextpid>
    8000110e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001110:	0014871b          	addiw	a4,s1,1
    80001114:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001116:	854a                	mv	a0,s2
    80001118:	00005097          	auipc	ra,0x5
    8000111c:	23e080e7          	jalr	574(ra) # 80006356 <release>
}
    80001120:	8526                	mv	a0,s1
    80001122:	60e2                	ld	ra,24(sp)
    80001124:	6442                	ld	s0,16(sp)
    80001126:	64a2                	ld	s1,8(sp)
    80001128:	6902                	ld	s2,0(sp)
    8000112a:	6105                	addi	sp,sp,32
    8000112c:	8082                	ret

000000008000112e <proc_pagetable>:
{
    8000112e:	1101                	addi	sp,sp,-32
    80001130:	ec06                	sd	ra,24(sp)
    80001132:	e822                	sd	s0,16(sp)
    80001134:	e426                	sd	s1,8(sp)
    80001136:	e04a                	sd	s2,0(sp)
    80001138:	1000                	addi	s0,sp,32
    8000113a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000113c:	fffff097          	auipc	ra,0xfffff
    80001140:	794080e7          	jalr	1940(ra) # 800008d0 <uvmcreate>
    80001144:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001146:	c121                	beqz	a0,80001186 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001148:	4729                	li	a4,10
    8000114a:	00006697          	auipc	a3,0x6
    8000114e:	eb668693          	addi	a3,a3,-330 # 80007000 <_trampoline>
    80001152:	6605                	lui	a2,0x1
    80001154:	040005b7          	lui	a1,0x4000
    80001158:	15fd                	addi	a1,a1,-1
    8000115a:	05b2                	slli	a1,a1,0xc
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	4ea080e7          	jalr	1258(ra) # 80000646 <mappages>
    80001164:	02054863          	bltz	a0,80001194 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001168:	4719                	li	a4,6
    8000116a:	05893683          	ld	a3,88(s2)
    8000116e:	6605                	lui	a2,0x1
    80001170:	020005b7          	lui	a1,0x2000
    80001174:	15fd                	addi	a1,a1,-1
    80001176:	05b6                	slli	a1,a1,0xd
    80001178:	8526                	mv	a0,s1
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	4cc080e7          	jalr	1228(ra) # 80000646 <mappages>
    80001182:	02054163          	bltz	a0,800011a4 <proc_pagetable+0x76>
}
    80001186:	8526                	mv	a0,s1
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6902                	ld	s2,0(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret
    uvmfree(pagetable, 0);
    80001194:	4581                	li	a1,0
    80001196:	8526                	mv	a0,s1
    80001198:	00000097          	auipc	ra,0x0
    8000119c:	934080e7          	jalr	-1740(ra) # 80000acc <uvmfree>
    return 0;
    800011a0:	4481                	li	s1,0
    800011a2:	b7d5                	j	80001186 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011a4:	4681                	li	a3,0
    800011a6:	4605                	li	a2,1
    800011a8:	040005b7          	lui	a1,0x4000
    800011ac:	15fd                	addi	a1,a1,-1
    800011ae:	05b2                	slli	a1,a1,0xc
    800011b0:	8526                	mv	a0,s1
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	65a080e7          	jalr	1626(ra) # 8000080c <uvmunmap>
    uvmfree(pagetable, 0);
    800011ba:	4581                	li	a1,0
    800011bc:	8526                	mv	a0,s1
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	90e080e7          	jalr	-1778(ra) # 80000acc <uvmfree>
    return 0;
    800011c6:	4481                	li	s1,0
    800011c8:	bf7d                	j	80001186 <proc_pagetable+0x58>

00000000800011ca <proc_freepagetable>:
{
    800011ca:	1101                	addi	sp,sp,-32
    800011cc:	ec06                	sd	ra,24(sp)
    800011ce:	e822                	sd	s0,16(sp)
    800011d0:	e426                	sd	s1,8(sp)
    800011d2:	e04a                	sd	s2,0(sp)
    800011d4:	1000                	addi	s0,sp,32
    800011d6:	84aa                	mv	s1,a0
    800011d8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011da:	4681                	li	a3,0
    800011dc:	4605                	li	a2,1
    800011de:	040005b7          	lui	a1,0x4000
    800011e2:	15fd                	addi	a1,a1,-1
    800011e4:	05b2                	slli	a1,a1,0xc
    800011e6:	fffff097          	auipc	ra,0xfffff
    800011ea:	626080e7          	jalr	1574(ra) # 8000080c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011ee:	4681                	li	a3,0
    800011f0:	4605                	li	a2,1
    800011f2:	020005b7          	lui	a1,0x2000
    800011f6:	15fd                	addi	a1,a1,-1
    800011f8:	05b6                	slli	a1,a1,0xd
    800011fa:	8526                	mv	a0,s1
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	610080e7          	jalr	1552(ra) # 8000080c <uvmunmap>
  uvmfree(pagetable, sz);
    80001204:	85ca                	mv	a1,s2
    80001206:	8526                	mv	a0,s1
    80001208:	00000097          	auipc	ra,0x0
    8000120c:	8c4080e7          	jalr	-1852(ra) # 80000acc <uvmfree>
}
    80001210:	60e2                	ld	ra,24(sp)
    80001212:	6442                	ld	s0,16(sp)
    80001214:	64a2                	ld	s1,8(sp)
    80001216:	6902                	ld	s2,0(sp)
    80001218:	6105                	addi	sp,sp,32
    8000121a:	8082                	ret

000000008000121c <freeproc>:
{
    8000121c:	1101                	addi	sp,sp,-32
    8000121e:	ec06                	sd	ra,24(sp)
    80001220:	e822                	sd	s0,16(sp)
    80001222:	e426                	sd	s1,8(sp)
    80001224:	1000                	addi	s0,sp,32
    80001226:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001228:	6d28                	ld	a0,88(a0)
    8000122a:	c509                	beqz	a0,80001234 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	df0080e7          	jalr	-528(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001234:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001238:	68a8                	ld	a0,80(s1)
    8000123a:	c511                	beqz	a0,80001246 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000123c:	64ac                	ld	a1,72(s1)
    8000123e:	00000097          	auipc	ra,0x0
    80001242:	f8c080e7          	jalr	-116(ra) # 800011ca <proc_freepagetable>
  p->pagetable = 0;
    80001246:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000124a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000124e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001252:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001256:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000125a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000125e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001262:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001266:	0004ac23          	sw	zero,24(s1)
}
    8000126a:	60e2                	ld	ra,24(sp)
    8000126c:	6442                	ld	s0,16(sp)
    8000126e:	64a2                	ld	s1,8(sp)
    80001270:	6105                	addi	sp,sp,32
    80001272:	8082                	ret

0000000080001274 <allocproc>:
{
    80001274:	1101                	addi	sp,sp,-32
    80001276:	ec06                	sd	ra,24(sp)
    80001278:	e822                	sd	s0,16(sp)
    8000127a:	e426                	sd	s1,8(sp)
    8000127c:	e04a                	sd	s2,0(sp)
    8000127e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001280:	00228497          	auipc	s1,0x228
    80001284:	20048493          	addi	s1,s1,512 # 80229480 <proc>
    80001288:	0022e917          	auipc	s2,0x22e
    8000128c:	bf890913          	addi	s2,s2,-1032 # 8022ee80 <tickslock>
    acquire(&p->lock);
    80001290:	8526                	mv	a0,s1
    80001292:	00005097          	auipc	ra,0x5
    80001296:	010080e7          	jalr	16(ra) # 800062a2 <acquire>
    if(p->state == UNUSED) {
    8000129a:	4c9c                	lw	a5,24(s1)
    8000129c:	cf81                	beqz	a5,800012b4 <allocproc+0x40>
      release(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	00005097          	auipc	ra,0x5
    800012a4:	0b6080e7          	jalr	182(ra) # 80006356 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012a8:	16848493          	addi	s1,s1,360
    800012ac:	ff2492e3          	bne	s1,s2,80001290 <allocproc+0x1c>
  return 0;
    800012b0:	4481                	li	s1,0
    800012b2:	a889                	j	80001304 <allocproc+0x90>
  p->pid = allocpid();
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	e34080e7          	jalr	-460(ra) # 800010e8 <allocpid>
    800012bc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012be:	4785                	li	a5,1
    800012c0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	eb2080e7          	jalr	-334(ra) # 80000174 <kalloc>
    800012ca:	892a                	mv	s2,a0
    800012cc:	eca8                	sd	a0,88(s1)
    800012ce:	c131                	beqz	a0,80001312 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012d0:	8526                	mv	a0,s1
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	e5c080e7          	jalr	-420(ra) # 8000112e <proc_pagetable>
    800012da:	892a                	mv	s2,a0
    800012dc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012de:	c531                	beqz	a0,8000132a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012e0:	07000613          	li	a2,112
    800012e4:	4581                	li	a1,0
    800012e6:	06048513          	addi	a0,s1,96
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	f8c080e7          	jalr	-116(ra) # 80000276 <memset>
  p->context.ra = (uint64)forkret;
    800012f2:	00000797          	auipc	a5,0x0
    800012f6:	db078793          	addi	a5,a5,-592 # 800010a2 <forkret>
    800012fa:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012fc:	60bc                	ld	a5,64(s1)
    800012fe:	6705                	lui	a4,0x1
    80001300:	97ba                	add	a5,a5,a4
    80001302:	f4bc                	sd	a5,104(s1)
}
    80001304:	8526                	mv	a0,s1
    80001306:	60e2                	ld	ra,24(sp)
    80001308:	6442                	ld	s0,16(sp)
    8000130a:	64a2                	ld	s1,8(sp)
    8000130c:	6902                	ld	s2,0(sp)
    8000130e:	6105                	addi	sp,sp,32
    80001310:	8082                	ret
    freeproc(p);
    80001312:	8526                	mv	a0,s1
    80001314:	00000097          	auipc	ra,0x0
    80001318:	f08080e7          	jalr	-248(ra) # 8000121c <freeproc>
    release(&p->lock);
    8000131c:	8526                	mv	a0,s1
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	038080e7          	jalr	56(ra) # 80006356 <release>
    return 0;
    80001326:	84ca                	mv	s1,s2
    80001328:	bff1                	j	80001304 <allocproc+0x90>
    freeproc(p);
    8000132a:	8526                	mv	a0,s1
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	ef0080e7          	jalr	-272(ra) # 8000121c <freeproc>
    release(&p->lock);
    80001334:	8526                	mv	a0,s1
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	020080e7          	jalr	32(ra) # 80006356 <release>
    return 0;
    8000133e:	84ca                	mv	s1,s2
    80001340:	b7d1                	j	80001304 <allocproc+0x90>

0000000080001342 <userinit>:
{
    80001342:	1101                	addi	sp,sp,-32
    80001344:	ec06                	sd	ra,24(sp)
    80001346:	e822                	sd	s0,16(sp)
    80001348:	e426                	sd	s1,8(sp)
    8000134a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000134c:	00000097          	auipc	ra,0x0
    80001350:	f28080e7          	jalr	-216(ra) # 80001274 <allocproc>
    80001354:	84aa                	mv	s1,a0
  initproc = p;
    80001356:	00008797          	auipc	a5,0x8
    8000135a:	caa7bd23          	sd	a0,-838(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000135e:	03400613          	li	a2,52
    80001362:	00007597          	auipc	a1,0x7
    80001366:	5ae58593          	addi	a1,a1,1454 # 80008910 <initcode>
    8000136a:	6928                	ld	a0,80(a0)
    8000136c:	fffff097          	auipc	ra,0xfffff
    80001370:	592080e7          	jalr	1426(ra) # 800008fe <uvminit>
  p->sz = PGSIZE;
    80001374:	6785                	lui	a5,0x1
    80001376:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001378:	6cb8                	ld	a4,88(s1)
    8000137a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000137e:	6cb8                	ld	a4,88(s1)
    80001380:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001382:	4641                	li	a2,16
    80001384:	00007597          	auipc	a1,0x7
    80001388:	ee458593          	addi	a1,a1,-284 # 80008268 <etext+0x268>
    8000138c:	15848513          	addi	a0,s1,344
    80001390:	fffff097          	auipc	ra,0xfffff
    80001394:	038080e7          	jalr	56(ra) # 800003c8 <safestrcpy>
  p->cwd = namei("/");
    80001398:	00007517          	auipc	a0,0x7
    8000139c:	ee050513          	addi	a0,a0,-288 # 80008278 <etext+0x278>
    800013a0:	00002097          	auipc	ra,0x2
    800013a4:	0c2080e7          	jalr	194(ra) # 80003462 <namei>
    800013a8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013ac:	478d                	li	a5,3
    800013ae:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	00005097          	auipc	ra,0x5
    800013b6:	fa4080e7          	jalr	-92(ra) # 80006356 <release>
}
    800013ba:	60e2                	ld	ra,24(sp)
    800013bc:	6442                	ld	s0,16(sp)
    800013be:	64a2                	ld	s1,8(sp)
    800013c0:	6105                	addi	sp,sp,32
    800013c2:	8082                	ret

00000000800013c4 <growproc>:
{
    800013c4:	1101                	addi	sp,sp,-32
    800013c6:	ec06                	sd	ra,24(sp)
    800013c8:	e822                	sd	s0,16(sp)
    800013ca:	e426                	sd	s1,8(sp)
    800013cc:	e04a                	sd	s2,0(sp)
    800013ce:	1000                	addi	s0,sp,32
    800013d0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	c98080e7          	jalr	-872(ra) # 8000106a <myproc>
    800013da:	892a                	mv	s2,a0
  sz = p->sz;
    800013dc:	652c                	ld	a1,72(a0)
    800013de:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800013e2:	00904f63          	bgtz	s1,80001400 <growproc+0x3c>
  } else if(n < 0){
    800013e6:	0204cc63          	bltz	s1,8000141e <growproc+0x5a>
  p->sz = sz;
    800013ea:	1602                	slli	a2,a2,0x20
    800013ec:	9201                	srli	a2,a2,0x20
    800013ee:	04c93423          	sd	a2,72(s2)
  return 0;
    800013f2:	4501                	li	a0,0
}
    800013f4:	60e2                	ld	ra,24(sp)
    800013f6:	6442                	ld	s0,16(sp)
    800013f8:	64a2                	ld	s1,8(sp)
    800013fa:	6902                	ld	s2,0(sp)
    800013fc:	6105                	addi	sp,sp,32
    800013fe:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001400:	9e25                	addw	a2,a2,s1
    80001402:	1602                	slli	a2,a2,0x20
    80001404:	9201                	srli	a2,a2,0x20
    80001406:	1582                	slli	a1,a1,0x20
    80001408:	9181                	srli	a1,a1,0x20
    8000140a:	6928                	ld	a0,80(a0)
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	5ac080e7          	jalr	1452(ra) # 800009b8 <uvmalloc>
    80001414:	0005061b          	sext.w	a2,a0
    80001418:	fa69                	bnez	a2,800013ea <growproc+0x26>
      return -1;
    8000141a:	557d                	li	a0,-1
    8000141c:	bfe1                	j	800013f4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000141e:	9e25                	addw	a2,a2,s1
    80001420:	1602                	slli	a2,a2,0x20
    80001422:	9201                	srli	a2,a2,0x20
    80001424:	1582                	slli	a1,a1,0x20
    80001426:	9181                	srli	a1,a1,0x20
    80001428:	6928                	ld	a0,80(a0)
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	546080e7          	jalr	1350(ra) # 80000970 <uvmdealloc>
    80001432:	0005061b          	sext.w	a2,a0
    80001436:	bf55                	j	800013ea <growproc+0x26>

0000000080001438 <fork>:
{
    80001438:	7179                	addi	sp,sp,-48
    8000143a:	f406                	sd	ra,40(sp)
    8000143c:	f022                	sd	s0,32(sp)
    8000143e:	ec26                	sd	s1,24(sp)
    80001440:	e84a                	sd	s2,16(sp)
    80001442:	e44e                	sd	s3,8(sp)
    80001444:	e052                	sd	s4,0(sp)
    80001446:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	c22080e7          	jalr	-990(ra) # 8000106a <myproc>
    80001450:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001452:	00000097          	auipc	ra,0x0
    80001456:	e22080e7          	jalr	-478(ra) # 80001274 <allocproc>
    8000145a:	10050b63          	beqz	a0,80001570 <fork+0x138>
    8000145e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001460:	04893603          	ld	a2,72(s2)
    80001464:	692c                	ld	a1,80(a0)
    80001466:	05093503          	ld	a0,80(s2)
    8000146a:	fffff097          	auipc	ra,0xfffff
    8000146e:	69a080e7          	jalr	1690(ra) # 80000b04 <uvmcopy>
    80001472:	04054663          	bltz	a0,800014be <fork+0x86>
  np->sz = p->sz;
    80001476:	04893783          	ld	a5,72(s2)
    8000147a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000147e:	05893683          	ld	a3,88(s2)
    80001482:	87b6                	mv	a5,a3
    80001484:	0589b703          	ld	a4,88(s3)
    80001488:	12068693          	addi	a3,a3,288
    8000148c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001490:	6788                	ld	a0,8(a5)
    80001492:	6b8c                	ld	a1,16(a5)
    80001494:	6f90                	ld	a2,24(a5)
    80001496:	01073023          	sd	a6,0(a4)
    8000149a:	e708                	sd	a0,8(a4)
    8000149c:	eb0c                	sd	a1,16(a4)
    8000149e:	ef10                	sd	a2,24(a4)
    800014a0:	02078793          	addi	a5,a5,32
    800014a4:	02070713          	addi	a4,a4,32
    800014a8:	fed792e3          	bne	a5,a3,8000148c <fork+0x54>
  np->trapframe->a0 = 0;
    800014ac:	0589b783          	ld	a5,88(s3)
    800014b0:	0607b823          	sd	zero,112(a5)
    800014b4:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800014b8:	15000a13          	li	s4,336
    800014bc:	a03d                	j	800014ea <fork+0xb2>
    freeproc(np);
    800014be:	854e                	mv	a0,s3
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	d5c080e7          	jalr	-676(ra) # 8000121c <freeproc>
    release(&np->lock);
    800014c8:	854e                	mv	a0,s3
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	e8c080e7          	jalr	-372(ra) # 80006356 <release>
    return -1;
    800014d2:	5a7d                	li	s4,-1
    800014d4:	a069                	j	8000155e <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800014d6:	00002097          	auipc	ra,0x2
    800014da:	622080e7          	jalr	1570(ra) # 80003af8 <filedup>
    800014de:	009987b3          	add	a5,s3,s1
    800014e2:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800014e4:	04a1                	addi	s1,s1,8
    800014e6:	01448763          	beq	s1,s4,800014f4 <fork+0xbc>
    if(p->ofile[i])
    800014ea:	009907b3          	add	a5,s2,s1
    800014ee:	6388                	ld	a0,0(a5)
    800014f0:	f17d                	bnez	a0,800014d6 <fork+0x9e>
    800014f2:	bfcd                	j	800014e4 <fork+0xac>
  np->cwd = idup(p->cwd);
    800014f4:	15093503          	ld	a0,336(s2)
    800014f8:	00001097          	auipc	ra,0x1
    800014fc:	776080e7          	jalr	1910(ra) # 80002c6e <idup>
    80001500:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001504:	4641                	li	a2,16
    80001506:	15890593          	addi	a1,s2,344
    8000150a:	15898513          	addi	a0,s3,344
    8000150e:	fffff097          	auipc	ra,0xfffff
    80001512:	eba080e7          	jalr	-326(ra) # 800003c8 <safestrcpy>
  pid = np->pid;
    80001516:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000151a:	854e                	mv	a0,s3
    8000151c:	00005097          	auipc	ra,0x5
    80001520:	e3a080e7          	jalr	-454(ra) # 80006356 <release>
  acquire(&wait_lock);
    80001524:	00228497          	auipc	s1,0x228
    80001528:	b4448493          	addi	s1,s1,-1212 # 80229068 <wait_lock>
    8000152c:	8526                	mv	a0,s1
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	d74080e7          	jalr	-652(ra) # 800062a2 <acquire>
  np->parent = p;
    80001536:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000153a:	8526                	mv	a0,s1
    8000153c:	00005097          	auipc	ra,0x5
    80001540:	e1a080e7          	jalr	-486(ra) # 80006356 <release>
  acquire(&np->lock);
    80001544:	854e                	mv	a0,s3
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	d5c080e7          	jalr	-676(ra) # 800062a2 <acquire>
  np->state = RUNNABLE;
    8000154e:	478d                	li	a5,3
    80001550:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001554:	854e                	mv	a0,s3
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	e00080e7          	jalr	-512(ra) # 80006356 <release>
}
    8000155e:	8552                	mv	a0,s4
    80001560:	70a2                	ld	ra,40(sp)
    80001562:	7402                	ld	s0,32(sp)
    80001564:	64e2                	ld	s1,24(sp)
    80001566:	6942                	ld	s2,16(sp)
    80001568:	69a2                	ld	s3,8(sp)
    8000156a:	6a02                	ld	s4,0(sp)
    8000156c:	6145                	addi	sp,sp,48
    8000156e:	8082                	ret
    return -1;
    80001570:	5a7d                	li	s4,-1
    80001572:	b7f5                	j	8000155e <fork+0x126>

0000000080001574 <scheduler>:
{
    80001574:	7139                	addi	sp,sp,-64
    80001576:	fc06                	sd	ra,56(sp)
    80001578:	f822                	sd	s0,48(sp)
    8000157a:	f426                	sd	s1,40(sp)
    8000157c:	f04a                	sd	s2,32(sp)
    8000157e:	ec4e                	sd	s3,24(sp)
    80001580:	e852                	sd	s4,16(sp)
    80001582:	e456                	sd	s5,8(sp)
    80001584:	e05a                	sd	s6,0(sp)
    80001586:	0080                	addi	s0,sp,64
    80001588:	8792                	mv	a5,tp
  int id = r_tp();
    8000158a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000158c:	00779a93          	slli	s5,a5,0x7
    80001590:	00228717          	auipc	a4,0x228
    80001594:	ac070713          	addi	a4,a4,-1344 # 80229050 <pid_lock>
    80001598:	9756                	add	a4,a4,s5
    8000159a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000159e:	00228717          	auipc	a4,0x228
    800015a2:	aea70713          	addi	a4,a4,-1302 # 80229088 <cpus+0x8>
    800015a6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015a8:	498d                	li	s3,3
        p->state = RUNNING;
    800015aa:	4b11                	li	s6,4
        c->proc = p;
    800015ac:	079e                	slli	a5,a5,0x7
    800015ae:	00228a17          	auipc	s4,0x228
    800015b2:	aa2a0a13          	addi	s4,s4,-1374 # 80229050 <pid_lock>
    800015b6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015b8:	0022e917          	auipc	s2,0x22e
    800015bc:	8c890913          	addi	s2,s2,-1848 # 8022ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015c0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015c4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015c8:	10079073          	csrw	sstatus,a5
    800015cc:	00228497          	auipc	s1,0x228
    800015d0:	eb448493          	addi	s1,s1,-332 # 80229480 <proc>
    800015d4:	a03d                	j	80001602 <scheduler+0x8e>
        p->state = RUNNING;
    800015d6:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015da:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015de:	06048593          	addi	a1,s1,96
    800015e2:	8556                	mv	a0,s5
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	640080e7          	jalr	1600(ra) # 80001c24 <swtch>
        c->proc = 0;
    800015ec:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800015f0:	8526                	mv	a0,s1
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	d64080e7          	jalr	-668(ra) # 80006356 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015fa:	16848493          	addi	s1,s1,360
    800015fe:	fd2481e3          	beq	s1,s2,800015c0 <scheduler+0x4c>
      acquire(&p->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	00005097          	auipc	ra,0x5
    80001608:	c9e080e7          	jalr	-866(ra) # 800062a2 <acquire>
      if(p->state == RUNNABLE) {
    8000160c:	4c9c                	lw	a5,24(s1)
    8000160e:	ff3791e3          	bne	a5,s3,800015f0 <scheduler+0x7c>
    80001612:	b7d1                	j	800015d6 <scheduler+0x62>

0000000080001614 <sched>:
{
    80001614:	7179                	addi	sp,sp,-48
    80001616:	f406                	sd	ra,40(sp)
    80001618:	f022                	sd	s0,32(sp)
    8000161a:	ec26                	sd	s1,24(sp)
    8000161c:	e84a                	sd	s2,16(sp)
    8000161e:	e44e                	sd	s3,8(sp)
    80001620:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001622:	00000097          	auipc	ra,0x0
    80001626:	a48080e7          	jalr	-1464(ra) # 8000106a <myproc>
    8000162a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	bfc080e7          	jalr	-1028(ra) # 80006228 <holding>
    80001634:	c93d                	beqz	a0,800016aa <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001636:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001638:	2781                	sext.w	a5,a5
    8000163a:	079e                	slli	a5,a5,0x7
    8000163c:	00228717          	auipc	a4,0x228
    80001640:	a1470713          	addi	a4,a4,-1516 # 80229050 <pid_lock>
    80001644:	97ba                	add	a5,a5,a4
    80001646:	0a87a703          	lw	a4,168(a5)
    8000164a:	4785                	li	a5,1
    8000164c:	06f71763          	bne	a4,a5,800016ba <sched+0xa6>
  if(p->state == RUNNING)
    80001650:	4c98                	lw	a4,24(s1)
    80001652:	4791                	li	a5,4
    80001654:	06f70b63          	beq	a4,a5,800016ca <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001658:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000165c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000165e:	efb5                	bnez	a5,800016da <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001660:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001662:	00228917          	auipc	s2,0x228
    80001666:	9ee90913          	addi	s2,s2,-1554 # 80229050 <pid_lock>
    8000166a:	2781                	sext.w	a5,a5
    8000166c:	079e                	slli	a5,a5,0x7
    8000166e:	97ca                	add	a5,a5,s2
    80001670:	0ac7a983          	lw	s3,172(a5)
    80001674:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001676:	2781                	sext.w	a5,a5
    80001678:	079e                	slli	a5,a5,0x7
    8000167a:	00228597          	auipc	a1,0x228
    8000167e:	a0e58593          	addi	a1,a1,-1522 # 80229088 <cpus+0x8>
    80001682:	95be                	add	a1,a1,a5
    80001684:	06048513          	addi	a0,s1,96
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	59c080e7          	jalr	1436(ra) # 80001c24 <swtch>
    80001690:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001692:	2781                	sext.w	a5,a5
    80001694:	079e                	slli	a5,a5,0x7
    80001696:	97ca                	add	a5,a5,s2
    80001698:	0b37a623          	sw	s3,172(a5)
}
    8000169c:	70a2                	ld	ra,40(sp)
    8000169e:	7402                	ld	s0,32(sp)
    800016a0:	64e2                	ld	s1,24(sp)
    800016a2:	6942                	ld	s2,16(sp)
    800016a4:	69a2                	ld	s3,8(sp)
    800016a6:	6145                	addi	sp,sp,48
    800016a8:	8082                	ret
    panic("sched p->lock");
    800016aa:	00007517          	auipc	a0,0x7
    800016ae:	bd650513          	addi	a0,a0,-1066 # 80008280 <etext+0x280>
    800016b2:	00004097          	auipc	ra,0x4
    800016b6:	6a6080e7          	jalr	1702(ra) # 80005d58 <panic>
    panic("sched locks");
    800016ba:	00007517          	auipc	a0,0x7
    800016be:	bd650513          	addi	a0,a0,-1066 # 80008290 <etext+0x290>
    800016c2:	00004097          	auipc	ra,0x4
    800016c6:	696080e7          	jalr	1686(ra) # 80005d58 <panic>
    panic("sched running");
    800016ca:	00007517          	auipc	a0,0x7
    800016ce:	bd650513          	addi	a0,a0,-1066 # 800082a0 <etext+0x2a0>
    800016d2:	00004097          	auipc	ra,0x4
    800016d6:	686080e7          	jalr	1670(ra) # 80005d58 <panic>
    panic("sched interruptible");
    800016da:	00007517          	auipc	a0,0x7
    800016de:	bd650513          	addi	a0,a0,-1066 # 800082b0 <etext+0x2b0>
    800016e2:	00004097          	auipc	ra,0x4
    800016e6:	676080e7          	jalr	1654(ra) # 80005d58 <panic>

00000000800016ea <yield>:
{
    800016ea:	1101                	addi	sp,sp,-32
    800016ec:	ec06                	sd	ra,24(sp)
    800016ee:	e822                	sd	s0,16(sp)
    800016f0:	e426                	sd	s1,8(sp)
    800016f2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	976080e7          	jalr	-1674(ra) # 8000106a <myproc>
    800016fc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	ba4080e7          	jalr	-1116(ra) # 800062a2 <acquire>
  p->state = RUNNABLE;
    80001706:	478d                	li	a5,3
    80001708:	cc9c                	sw	a5,24(s1)
  sched();
    8000170a:	00000097          	auipc	ra,0x0
    8000170e:	f0a080e7          	jalr	-246(ra) # 80001614 <sched>
  release(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	c42080e7          	jalr	-958(ra) # 80006356 <release>
}
    8000171c:	60e2                	ld	ra,24(sp)
    8000171e:	6442                	ld	s0,16(sp)
    80001720:	64a2                	ld	s1,8(sp)
    80001722:	6105                	addi	sp,sp,32
    80001724:	8082                	ret

0000000080001726 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001726:	7179                	addi	sp,sp,-48
    80001728:	f406                	sd	ra,40(sp)
    8000172a:	f022                	sd	s0,32(sp)
    8000172c:	ec26                	sd	s1,24(sp)
    8000172e:	e84a                	sd	s2,16(sp)
    80001730:	e44e                	sd	s3,8(sp)
    80001732:	1800                	addi	s0,sp,48
    80001734:	89aa                	mv	s3,a0
    80001736:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	932080e7          	jalr	-1742(ra) # 8000106a <myproc>
    80001740:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	b60080e7          	jalr	-1184(ra) # 800062a2 <acquire>
  release(lk);
    8000174a:	854a                	mv	a0,s2
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	c0a080e7          	jalr	-1014(ra) # 80006356 <release>

  // Go to sleep.
  p->chan = chan;
    80001754:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001758:	4789                	li	a5,2
    8000175a:	cc9c                	sw	a5,24(s1)

  sched();
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	eb8080e7          	jalr	-328(ra) # 80001614 <sched>

  // Tidy up.
  p->chan = 0;
    80001764:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	bec080e7          	jalr	-1044(ra) # 80006356 <release>
  acquire(lk);
    80001772:	854a                	mv	a0,s2
    80001774:	00005097          	auipc	ra,0x5
    80001778:	b2e080e7          	jalr	-1234(ra) # 800062a2 <acquire>
}
    8000177c:	70a2                	ld	ra,40(sp)
    8000177e:	7402                	ld	s0,32(sp)
    80001780:	64e2                	ld	s1,24(sp)
    80001782:	6942                	ld	s2,16(sp)
    80001784:	69a2                	ld	s3,8(sp)
    80001786:	6145                	addi	sp,sp,48
    80001788:	8082                	ret

000000008000178a <wait>:
{
    8000178a:	715d                	addi	sp,sp,-80
    8000178c:	e486                	sd	ra,72(sp)
    8000178e:	e0a2                	sd	s0,64(sp)
    80001790:	fc26                	sd	s1,56(sp)
    80001792:	f84a                	sd	s2,48(sp)
    80001794:	f44e                	sd	s3,40(sp)
    80001796:	f052                	sd	s4,32(sp)
    80001798:	ec56                	sd	s5,24(sp)
    8000179a:	e85a                	sd	s6,16(sp)
    8000179c:	e45e                	sd	s7,8(sp)
    8000179e:	e062                	sd	s8,0(sp)
    800017a0:	0880                	addi	s0,sp,80
    800017a2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	8c6080e7          	jalr	-1850(ra) # 8000106a <myproc>
    800017ac:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017ae:	00228517          	auipc	a0,0x228
    800017b2:	8ba50513          	addi	a0,a0,-1862 # 80229068 <wait_lock>
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	aec080e7          	jalr	-1300(ra) # 800062a2 <acquire>
    havekids = 0;
    800017be:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800017c0:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800017c2:	0022d997          	auipc	s3,0x22d
    800017c6:	6be98993          	addi	s3,s3,1726 # 8022ee80 <tickslock>
        havekids = 1;
    800017ca:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017cc:	00228c17          	auipc	s8,0x228
    800017d0:	89cc0c13          	addi	s8,s8,-1892 # 80229068 <wait_lock>
    havekids = 0;
    800017d4:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800017d6:	00228497          	auipc	s1,0x228
    800017da:	caa48493          	addi	s1,s1,-854 # 80229480 <proc>
    800017de:	a0bd                	j	8000184c <wait+0xc2>
          pid = np->pid;
    800017e0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017e4:	000b0e63          	beqz	s6,80001800 <wait+0x76>
    800017e8:	4691                	li	a3,4
    800017ea:	02c48613          	addi	a2,s1,44
    800017ee:	85da                	mv	a1,s6
    800017f0:	05093503          	ld	a0,80(s2)
    800017f4:	fffff097          	auipc	ra,0xfffff
    800017f8:	606080e7          	jalr	1542(ra) # 80000dfa <copyout>
    800017fc:	02054563          	bltz	a0,80001826 <wait+0x9c>
          freeproc(np);
    80001800:	8526                	mv	a0,s1
    80001802:	00000097          	auipc	ra,0x0
    80001806:	a1a080e7          	jalr	-1510(ra) # 8000121c <freeproc>
          release(&np->lock);
    8000180a:	8526                	mv	a0,s1
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	b4a080e7          	jalr	-1206(ra) # 80006356 <release>
          release(&wait_lock);
    80001814:	00228517          	auipc	a0,0x228
    80001818:	85450513          	addi	a0,a0,-1964 # 80229068 <wait_lock>
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	b3a080e7          	jalr	-1222(ra) # 80006356 <release>
          return pid;
    80001824:	a09d                	j	8000188a <wait+0x100>
            release(&np->lock);
    80001826:	8526                	mv	a0,s1
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	b2e080e7          	jalr	-1234(ra) # 80006356 <release>
            release(&wait_lock);
    80001830:	00228517          	auipc	a0,0x228
    80001834:	83850513          	addi	a0,a0,-1992 # 80229068 <wait_lock>
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	b1e080e7          	jalr	-1250(ra) # 80006356 <release>
            return -1;
    80001840:	59fd                	li	s3,-1
    80001842:	a0a1                	j	8000188a <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001844:	16848493          	addi	s1,s1,360
    80001848:	03348463          	beq	s1,s3,80001870 <wait+0xe6>
      if(np->parent == p){
    8000184c:	7c9c                	ld	a5,56(s1)
    8000184e:	ff279be3          	bne	a5,s2,80001844 <wait+0xba>
        acquire(&np->lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	a4e080e7          	jalr	-1458(ra) # 800062a2 <acquire>
        if(np->state == ZOMBIE){
    8000185c:	4c9c                	lw	a5,24(s1)
    8000185e:	f94781e3          	beq	a5,s4,800017e0 <wait+0x56>
        release(&np->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	af2080e7          	jalr	-1294(ra) # 80006356 <release>
        havekids = 1;
    8000186c:	8756                	mv	a4,s5
    8000186e:	bfd9                	j	80001844 <wait+0xba>
    if(!havekids || p->killed){
    80001870:	c701                	beqz	a4,80001878 <wait+0xee>
    80001872:	02892783          	lw	a5,40(s2)
    80001876:	c79d                	beqz	a5,800018a4 <wait+0x11a>
      release(&wait_lock);
    80001878:	00227517          	auipc	a0,0x227
    8000187c:	7f050513          	addi	a0,a0,2032 # 80229068 <wait_lock>
    80001880:	00005097          	auipc	ra,0x5
    80001884:	ad6080e7          	jalr	-1322(ra) # 80006356 <release>
      return -1;
    80001888:	59fd                	li	s3,-1
}
    8000188a:	854e                	mv	a0,s3
    8000188c:	60a6                	ld	ra,72(sp)
    8000188e:	6406                	ld	s0,64(sp)
    80001890:	74e2                	ld	s1,56(sp)
    80001892:	7942                	ld	s2,48(sp)
    80001894:	79a2                	ld	s3,40(sp)
    80001896:	7a02                	ld	s4,32(sp)
    80001898:	6ae2                	ld	s5,24(sp)
    8000189a:	6b42                	ld	s6,16(sp)
    8000189c:	6ba2                	ld	s7,8(sp)
    8000189e:	6c02                	ld	s8,0(sp)
    800018a0:	6161                	addi	sp,sp,80
    800018a2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018a4:	85e2                	mv	a1,s8
    800018a6:	854a                	mv	a0,s2
    800018a8:	00000097          	auipc	ra,0x0
    800018ac:	e7e080e7          	jalr	-386(ra) # 80001726 <sleep>
    havekids = 0;
    800018b0:	b715                	j	800017d4 <wait+0x4a>

00000000800018b2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018b2:	7139                	addi	sp,sp,-64
    800018b4:	fc06                	sd	ra,56(sp)
    800018b6:	f822                	sd	s0,48(sp)
    800018b8:	f426                	sd	s1,40(sp)
    800018ba:	f04a                	sd	s2,32(sp)
    800018bc:	ec4e                	sd	s3,24(sp)
    800018be:	e852                	sd	s4,16(sp)
    800018c0:	e456                	sd	s5,8(sp)
    800018c2:	0080                	addi	s0,sp,64
    800018c4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018c6:	00228497          	auipc	s1,0x228
    800018ca:	bba48493          	addi	s1,s1,-1094 # 80229480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018ce:	4989                	li	s3,2
        p->state = RUNNABLE;
    800018d0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800018d2:	0022d917          	auipc	s2,0x22d
    800018d6:	5ae90913          	addi	s2,s2,1454 # 8022ee80 <tickslock>
    800018da:	a821                	j	800018f2 <wakeup+0x40>
        p->state = RUNNABLE;
    800018dc:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800018e0:	8526                	mv	a0,s1
    800018e2:	00005097          	auipc	ra,0x5
    800018e6:	a74080e7          	jalr	-1420(ra) # 80006356 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ea:	16848493          	addi	s1,s1,360
    800018ee:	03248463          	beq	s1,s2,80001916 <wakeup+0x64>
    if(p != myproc()){
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	778080e7          	jalr	1912(ra) # 8000106a <myproc>
    800018fa:	fea488e3          	beq	s1,a0,800018ea <wakeup+0x38>
      acquire(&p->lock);
    800018fe:	8526                	mv	a0,s1
    80001900:	00005097          	auipc	ra,0x5
    80001904:	9a2080e7          	jalr	-1630(ra) # 800062a2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001908:	4c9c                	lw	a5,24(s1)
    8000190a:	fd379be3          	bne	a5,s3,800018e0 <wakeup+0x2e>
    8000190e:	709c                	ld	a5,32(s1)
    80001910:	fd4798e3          	bne	a5,s4,800018e0 <wakeup+0x2e>
    80001914:	b7e1                	j	800018dc <wakeup+0x2a>
    }
  }
}
    80001916:	70e2                	ld	ra,56(sp)
    80001918:	7442                	ld	s0,48(sp)
    8000191a:	74a2                	ld	s1,40(sp)
    8000191c:	7902                	ld	s2,32(sp)
    8000191e:	69e2                	ld	s3,24(sp)
    80001920:	6a42                	ld	s4,16(sp)
    80001922:	6aa2                	ld	s5,8(sp)
    80001924:	6121                	addi	sp,sp,64
    80001926:	8082                	ret

0000000080001928 <reparent>:
{
    80001928:	7179                	addi	sp,sp,-48
    8000192a:	f406                	sd	ra,40(sp)
    8000192c:	f022                	sd	s0,32(sp)
    8000192e:	ec26                	sd	s1,24(sp)
    80001930:	e84a                	sd	s2,16(sp)
    80001932:	e44e                	sd	s3,8(sp)
    80001934:	e052                	sd	s4,0(sp)
    80001936:	1800                	addi	s0,sp,48
    80001938:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193a:	00228497          	auipc	s1,0x228
    8000193e:	b4648493          	addi	s1,s1,-1210 # 80229480 <proc>
      pp->parent = initproc;
    80001942:	00007a17          	auipc	s4,0x7
    80001946:	6cea0a13          	addi	s4,s4,1742 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000194a:	0022d997          	auipc	s3,0x22d
    8000194e:	53698993          	addi	s3,s3,1334 # 8022ee80 <tickslock>
    80001952:	a029                	j	8000195c <reparent+0x34>
    80001954:	16848493          	addi	s1,s1,360
    80001958:	01348d63          	beq	s1,s3,80001972 <reparent+0x4a>
    if(pp->parent == p){
    8000195c:	7c9c                	ld	a5,56(s1)
    8000195e:	ff279be3          	bne	a5,s2,80001954 <reparent+0x2c>
      pp->parent = initproc;
    80001962:	000a3503          	ld	a0,0(s4)
    80001966:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001968:	00000097          	auipc	ra,0x0
    8000196c:	f4a080e7          	jalr	-182(ra) # 800018b2 <wakeup>
    80001970:	b7d5                	j	80001954 <reparent+0x2c>
}
    80001972:	70a2                	ld	ra,40(sp)
    80001974:	7402                	ld	s0,32(sp)
    80001976:	64e2                	ld	s1,24(sp)
    80001978:	6942                	ld	s2,16(sp)
    8000197a:	69a2                	ld	s3,8(sp)
    8000197c:	6a02                	ld	s4,0(sp)
    8000197e:	6145                	addi	sp,sp,48
    80001980:	8082                	ret

0000000080001982 <exit>:
{
    80001982:	7179                	addi	sp,sp,-48
    80001984:	f406                	sd	ra,40(sp)
    80001986:	f022                	sd	s0,32(sp)
    80001988:	ec26                	sd	s1,24(sp)
    8000198a:	e84a                	sd	s2,16(sp)
    8000198c:	e44e                	sd	s3,8(sp)
    8000198e:	e052                	sd	s4,0(sp)
    80001990:	1800                	addi	s0,sp,48
    80001992:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001994:	fffff097          	auipc	ra,0xfffff
    80001998:	6d6080e7          	jalr	1750(ra) # 8000106a <myproc>
    8000199c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000199e:	00007797          	auipc	a5,0x7
    800019a2:	6727b783          	ld	a5,1650(a5) # 80009010 <initproc>
    800019a6:	0d050493          	addi	s1,a0,208
    800019aa:	15050913          	addi	s2,a0,336
    800019ae:	02a79363          	bne	a5,a0,800019d4 <exit+0x52>
    panic("init exiting");
    800019b2:	00007517          	auipc	a0,0x7
    800019b6:	91650513          	addi	a0,a0,-1770 # 800082c8 <etext+0x2c8>
    800019ba:	00004097          	auipc	ra,0x4
    800019be:	39e080e7          	jalr	926(ra) # 80005d58 <panic>
      fileclose(f);
    800019c2:	00002097          	auipc	ra,0x2
    800019c6:	188080e7          	jalr	392(ra) # 80003b4a <fileclose>
      p->ofile[fd] = 0;
    800019ca:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800019ce:	04a1                	addi	s1,s1,8
    800019d0:	01248563          	beq	s1,s2,800019da <exit+0x58>
    if(p->ofile[fd]){
    800019d4:	6088                	ld	a0,0(s1)
    800019d6:	f575                	bnez	a0,800019c2 <exit+0x40>
    800019d8:	bfdd                	j	800019ce <exit+0x4c>
  begin_op();
    800019da:	00002097          	auipc	ra,0x2
    800019de:	ca4080e7          	jalr	-860(ra) # 8000367e <begin_op>
  iput(p->cwd);
    800019e2:	1509b503          	ld	a0,336(s3)
    800019e6:	00001097          	auipc	ra,0x1
    800019ea:	480080e7          	jalr	1152(ra) # 80002e66 <iput>
  end_op();
    800019ee:	00002097          	auipc	ra,0x2
    800019f2:	d10080e7          	jalr	-752(ra) # 800036fe <end_op>
  p->cwd = 0;
    800019f6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800019fa:	00227497          	auipc	s1,0x227
    800019fe:	66e48493          	addi	s1,s1,1646 # 80229068 <wait_lock>
    80001a02:	8526                	mv	a0,s1
    80001a04:	00005097          	auipc	ra,0x5
    80001a08:	89e080e7          	jalr	-1890(ra) # 800062a2 <acquire>
  reparent(p);
    80001a0c:	854e                	mv	a0,s3
    80001a0e:	00000097          	auipc	ra,0x0
    80001a12:	f1a080e7          	jalr	-230(ra) # 80001928 <reparent>
  wakeup(p->parent);
    80001a16:	0389b503          	ld	a0,56(s3)
    80001a1a:	00000097          	auipc	ra,0x0
    80001a1e:	e98080e7          	jalr	-360(ra) # 800018b2 <wakeup>
  acquire(&p->lock);
    80001a22:	854e                	mv	a0,s3
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	87e080e7          	jalr	-1922(ra) # 800062a2 <acquire>
  p->xstate = status;
    80001a2c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a30:	4795                	li	a5,5
    80001a32:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a36:	8526                	mv	a0,s1
    80001a38:	00005097          	auipc	ra,0x5
    80001a3c:	91e080e7          	jalr	-1762(ra) # 80006356 <release>
  sched();
    80001a40:	00000097          	auipc	ra,0x0
    80001a44:	bd4080e7          	jalr	-1068(ra) # 80001614 <sched>
  panic("zombie exit");
    80001a48:	00007517          	auipc	a0,0x7
    80001a4c:	89050513          	addi	a0,a0,-1904 # 800082d8 <etext+0x2d8>
    80001a50:	00004097          	auipc	ra,0x4
    80001a54:	308080e7          	jalr	776(ra) # 80005d58 <panic>

0000000080001a58 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a58:	7179                	addi	sp,sp,-48
    80001a5a:	f406                	sd	ra,40(sp)
    80001a5c:	f022                	sd	s0,32(sp)
    80001a5e:	ec26                	sd	s1,24(sp)
    80001a60:	e84a                	sd	s2,16(sp)
    80001a62:	e44e                	sd	s3,8(sp)
    80001a64:	1800                	addi	s0,sp,48
    80001a66:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a68:	00228497          	auipc	s1,0x228
    80001a6c:	a1848493          	addi	s1,s1,-1512 # 80229480 <proc>
    80001a70:	0022d997          	auipc	s3,0x22d
    80001a74:	41098993          	addi	s3,s3,1040 # 8022ee80 <tickslock>
    acquire(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00005097          	auipc	ra,0x5
    80001a7e:	828080e7          	jalr	-2008(ra) # 800062a2 <acquire>
    if(p->pid == pid){
    80001a82:	589c                	lw	a5,48(s1)
    80001a84:	01278d63          	beq	a5,s2,80001a9e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	00005097          	auipc	ra,0x5
    80001a8e:	8cc080e7          	jalr	-1844(ra) # 80006356 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a92:	16848493          	addi	s1,s1,360
    80001a96:	ff3491e3          	bne	s1,s3,80001a78 <kill+0x20>
  }
  return -1;
    80001a9a:	557d                	li	a0,-1
    80001a9c:	a829                	j	80001ab6 <kill+0x5e>
      p->killed = 1;
    80001a9e:	4785                	li	a5,1
    80001aa0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001aa2:	4c98                	lw	a4,24(s1)
    80001aa4:	4789                	li	a5,2
    80001aa6:	00f70f63          	beq	a4,a5,80001ac4 <kill+0x6c>
      release(&p->lock);
    80001aaa:	8526                	mv	a0,s1
    80001aac:	00005097          	auipc	ra,0x5
    80001ab0:	8aa080e7          	jalr	-1878(ra) # 80006356 <release>
      return 0;
    80001ab4:	4501                	li	a0,0
}
    80001ab6:	70a2                	ld	ra,40(sp)
    80001ab8:	7402                	ld	s0,32(sp)
    80001aba:	64e2                	ld	s1,24(sp)
    80001abc:	6942                	ld	s2,16(sp)
    80001abe:	69a2                	ld	s3,8(sp)
    80001ac0:	6145                	addi	sp,sp,48
    80001ac2:	8082                	ret
        p->state = RUNNABLE;
    80001ac4:	478d                	li	a5,3
    80001ac6:	cc9c                	sw	a5,24(s1)
    80001ac8:	b7cd                	j	80001aaa <kill+0x52>

0000000080001aca <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aca:	7179                	addi	sp,sp,-48
    80001acc:	f406                	sd	ra,40(sp)
    80001ace:	f022                	sd	s0,32(sp)
    80001ad0:	ec26                	sd	s1,24(sp)
    80001ad2:	e84a                	sd	s2,16(sp)
    80001ad4:	e44e                	sd	s3,8(sp)
    80001ad6:	e052                	sd	s4,0(sp)
    80001ad8:	1800                	addi	s0,sp,48
    80001ada:	84aa                	mv	s1,a0
    80001adc:	892e                	mv	s2,a1
    80001ade:	89b2                	mv	s3,a2
    80001ae0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	588080e7          	jalr	1416(ra) # 8000106a <myproc>
  if(user_dst){
    80001aea:	c08d                	beqz	s1,80001b0c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001aec:	86d2                	mv	a3,s4
    80001aee:	864e                	mv	a2,s3
    80001af0:	85ca                	mv	a1,s2
    80001af2:	6928                	ld	a0,80(a0)
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	306080e7          	jalr	774(ra) # 80000dfa <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001afc:	70a2                	ld	ra,40(sp)
    80001afe:	7402                	ld	s0,32(sp)
    80001b00:	64e2                	ld	s1,24(sp)
    80001b02:	6942                	ld	s2,16(sp)
    80001b04:	69a2                	ld	s3,8(sp)
    80001b06:	6a02                	ld	s4,0(sp)
    80001b08:	6145                	addi	sp,sp,48
    80001b0a:	8082                	ret
    memmove((char *)dst, src, len);
    80001b0c:	000a061b          	sext.w	a2,s4
    80001b10:	85ce                	mv	a1,s3
    80001b12:	854a                	mv	a0,s2
    80001b14:	ffffe097          	auipc	ra,0xffffe
    80001b18:	7c2080e7          	jalr	1986(ra) # 800002d6 <memmove>
    return 0;
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	bff9                	j	80001afc <either_copyout+0x32>

0000000080001b20 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b20:	7179                	addi	sp,sp,-48
    80001b22:	f406                	sd	ra,40(sp)
    80001b24:	f022                	sd	s0,32(sp)
    80001b26:	ec26                	sd	s1,24(sp)
    80001b28:	e84a                	sd	s2,16(sp)
    80001b2a:	e44e                	sd	s3,8(sp)
    80001b2c:	e052                	sd	s4,0(sp)
    80001b2e:	1800                	addi	s0,sp,48
    80001b30:	892a                	mv	s2,a0
    80001b32:	84ae                	mv	s1,a1
    80001b34:	89b2                	mv	s3,a2
    80001b36:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	532080e7          	jalr	1330(ra) # 8000106a <myproc>
  if(user_src){
    80001b40:	c08d                	beqz	s1,80001b62 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b42:	86d2                	mv	a3,s4
    80001b44:	864e                	mv	a2,s3
    80001b46:	85ca                	mv	a1,s2
    80001b48:	6928                	ld	a0,80(a0)
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	0a8080e7          	jalr	168(ra) # 80000bf2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b52:	70a2                	ld	ra,40(sp)
    80001b54:	7402                	ld	s0,32(sp)
    80001b56:	64e2                	ld	s1,24(sp)
    80001b58:	6942                	ld	s2,16(sp)
    80001b5a:	69a2                	ld	s3,8(sp)
    80001b5c:	6a02                	ld	s4,0(sp)
    80001b5e:	6145                	addi	sp,sp,48
    80001b60:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b62:	000a061b          	sext.w	a2,s4
    80001b66:	85ce                	mv	a1,s3
    80001b68:	854a                	mv	a0,s2
    80001b6a:	ffffe097          	auipc	ra,0xffffe
    80001b6e:	76c080e7          	jalr	1900(ra) # 800002d6 <memmove>
    return 0;
    80001b72:	8526                	mv	a0,s1
    80001b74:	bff9                	j	80001b52 <either_copyin+0x32>

0000000080001b76 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b76:	715d                	addi	sp,sp,-80
    80001b78:	e486                	sd	ra,72(sp)
    80001b7a:	e0a2                	sd	s0,64(sp)
    80001b7c:	fc26                	sd	s1,56(sp)
    80001b7e:	f84a                	sd	s2,48(sp)
    80001b80:	f44e                	sd	s3,40(sp)
    80001b82:	f052                	sd	s4,32(sp)
    80001b84:	ec56                	sd	s5,24(sp)
    80001b86:	e85a                	sd	s6,16(sp)
    80001b88:	e45e                	sd	s7,8(sp)
    80001b8a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b8c:	00006517          	auipc	a0,0x6
    80001b90:	4f450513          	addi	a0,a0,1268 # 80008080 <etext+0x80>
    80001b94:	00004097          	auipc	ra,0x4
    80001b98:	20e080e7          	jalr	526(ra) # 80005da2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b9c:	00228497          	auipc	s1,0x228
    80001ba0:	a3c48493          	addi	s1,s1,-1476 # 802295d8 <proc+0x158>
    80001ba4:	0022d917          	auipc	s2,0x22d
    80001ba8:	43490913          	addi	s2,s2,1076 # 8022efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bac:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bae:	00006997          	auipc	s3,0x6
    80001bb2:	73a98993          	addi	s3,s3,1850 # 800082e8 <etext+0x2e8>
    printf("%d %s %s", p->pid, state, p->name);
    80001bb6:	00006a97          	auipc	s5,0x6
    80001bba:	73aa8a93          	addi	s5,s5,1850 # 800082f0 <etext+0x2f0>
    printf("\n");
    80001bbe:	00006a17          	auipc	s4,0x6
    80001bc2:	4c2a0a13          	addi	s4,s4,1218 # 80008080 <etext+0x80>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bc6:	00006b97          	auipc	s7,0x6
    80001bca:	762b8b93          	addi	s7,s7,1890 # 80008328 <states.1715>
    80001bce:	a00d                	j	80001bf0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bd0:	ed86a583          	lw	a1,-296(a3)
    80001bd4:	8556                	mv	a0,s5
    80001bd6:	00004097          	auipc	ra,0x4
    80001bda:	1cc080e7          	jalr	460(ra) # 80005da2 <printf>
    printf("\n");
    80001bde:	8552                	mv	a0,s4
    80001be0:	00004097          	auipc	ra,0x4
    80001be4:	1c2080e7          	jalr	450(ra) # 80005da2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001be8:	16848493          	addi	s1,s1,360
    80001bec:	03248163          	beq	s1,s2,80001c0e <procdump+0x98>
    if(p->state == UNUSED)
    80001bf0:	86a6                	mv	a3,s1
    80001bf2:	ec04a783          	lw	a5,-320(s1)
    80001bf6:	dbed                	beqz	a5,80001be8 <procdump+0x72>
      state = "???";
    80001bf8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bfa:	fcfb6be3          	bltu	s6,a5,80001bd0 <procdump+0x5a>
    80001bfe:	1782                	slli	a5,a5,0x20
    80001c00:	9381                	srli	a5,a5,0x20
    80001c02:	078e                	slli	a5,a5,0x3
    80001c04:	97de                	add	a5,a5,s7
    80001c06:	6390                	ld	a2,0(a5)
    80001c08:	f661                	bnez	a2,80001bd0 <procdump+0x5a>
      state = "???";
    80001c0a:	864e                	mv	a2,s3
    80001c0c:	b7d1                	j	80001bd0 <procdump+0x5a>
  }
}
    80001c0e:	60a6                	ld	ra,72(sp)
    80001c10:	6406                	ld	s0,64(sp)
    80001c12:	74e2                	ld	s1,56(sp)
    80001c14:	7942                	ld	s2,48(sp)
    80001c16:	79a2                	ld	s3,40(sp)
    80001c18:	7a02                	ld	s4,32(sp)
    80001c1a:	6ae2                	ld	s5,24(sp)
    80001c1c:	6b42                	ld	s6,16(sp)
    80001c1e:	6ba2                	ld	s7,8(sp)
    80001c20:	6161                	addi	sp,sp,80
    80001c22:	8082                	ret

0000000080001c24 <swtch>:
    80001c24:	00153023          	sd	ra,0(a0)
    80001c28:	00253423          	sd	sp,8(a0)
    80001c2c:	e900                	sd	s0,16(a0)
    80001c2e:	ed04                	sd	s1,24(a0)
    80001c30:	03253023          	sd	s2,32(a0)
    80001c34:	03353423          	sd	s3,40(a0)
    80001c38:	03453823          	sd	s4,48(a0)
    80001c3c:	03553c23          	sd	s5,56(a0)
    80001c40:	05653023          	sd	s6,64(a0)
    80001c44:	05753423          	sd	s7,72(a0)
    80001c48:	05853823          	sd	s8,80(a0)
    80001c4c:	05953c23          	sd	s9,88(a0)
    80001c50:	07a53023          	sd	s10,96(a0)
    80001c54:	07b53423          	sd	s11,104(a0)
    80001c58:	0005b083          	ld	ra,0(a1)
    80001c5c:	0085b103          	ld	sp,8(a1)
    80001c60:	6980                	ld	s0,16(a1)
    80001c62:	6d84                	ld	s1,24(a1)
    80001c64:	0205b903          	ld	s2,32(a1)
    80001c68:	0285b983          	ld	s3,40(a1)
    80001c6c:	0305ba03          	ld	s4,48(a1)
    80001c70:	0385ba83          	ld	s5,56(a1)
    80001c74:	0405bb03          	ld	s6,64(a1)
    80001c78:	0485bb83          	ld	s7,72(a1)
    80001c7c:	0505bc03          	ld	s8,80(a1)
    80001c80:	0585bc83          	ld	s9,88(a1)
    80001c84:	0605bd03          	ld	s10,96(a1)
    80001c88:	0685bd83          	ld	s11,104(a1)
    80001c8c:	8082                	ret

0000000080001c8e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c8e:	1141                	addi	sp,sp,-16
    80001c90:	e406                	sd	ra,8(sp)
    80001c92:	e022                	sd	s0,0(sp)
    80001c94:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c96:	00006597          	auipc	a1,0x6
    80001c9a:	6c258593          	addi	a1,a1,1730 # 80008358 <states.1715+0x30>
    80001c9e:	0022d517          	auipc	a0,0x22d
    80001ca2:	1e250513          	addi	a0,a0,482 # 8022ee80 <tickslock>
    80001ca6:	00004097          	auipc	ra,0x4
    80001caa:	56c080e7          	jalr	1388(ra) # 80006212 <initlock>
}
    80001cae:	60a2                	ld	ra,8(sp)
    80001cb0:	6402                	ld	s0,0(sp)
    80001cb2:	0141                	addi	sp,sp,16
    80001cb4:	8082                	ret

0000000080001cb6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cb6:	1141                	addi	sp,sp,-16
    80001cb8:	e422                	sd	s0,8(sp)
    80001cba:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cbc:	00003797          	auipc	a5,0x3
    80001cc0:	4a478793          	addi	a5,a5,1188 # 80005160 <kernelvec>
    80001cc4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cc8:	6422                	ld	s0,8(sp)
    80001cca:	0141                	addi	sp,sp,16
    80001ccc:	8082                	ret

0000000080001cce <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cce:	1141                	addi	sp,sp,-16
    80001cd0:	e406                	sd	ra,8(sp)
    80001cd2:	e022                	sd	s0,0(sp)
    80001cd4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	394080e7          	jalr	916(ra) # 8000106a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ce2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ce8:	00005617          	auipc	a2,0x5
    80001cec:	31860613          	addi	a2,a2,792 # 80007000 <_trampoline>
    80001cf0:	00005697          	auipc	a3,0x5
    80001cf4:	31068693          	addi	a3,a3,784 # 80007000 <_trampoline>
    80001cf8:	8e91                	sub	a3,a3,a2
    80001cfa:	040007b7          	lui	a5,0x4000
    80001cfe:	17fd                	addi	a5,a5,-1
    80001d00:	07b2                	slli	a5,a5,0xc
    80001d02:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d04:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d08:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d0a:	180026f3          	csrr	a3,satp
    80001d0e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d10:	6d38                	ld	a4,88(a0)
    80001d12:	6134                	ld	a3,64(a0)
    80001d14:	6585                	lui	a1,0x1
    80001d16:	96ae                	add	a3,a3,a1
    80001d18:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d1a:	6d38                	ld	a4,88(a0)
    80001d1c:	00000697          	auipc	a3,0x0
    80001d20:	13868693          	addi	a3,a3,312 # 80001e54 <usertrap>
    80001d24:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d26:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d28:	8692                	mv	a3,tp
    80001d2a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d30:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d34:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d38:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d3c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d3e:	6f18                	ld	a4,24(a4)
    80001d40:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d44:	692c                	ld	a1,80(a0)
    80001d46:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d48:	00005717          	auipc	a4,0x5
    80001d4c:	34870713          	addi	a4,a4,840 # 80007090 <userret>
    80001d50:	8f11                	sub	a4,a4,a2
    80001d52:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d54:	577d                	li	a4,-1
    80001d56:	177e                	slli	a4,a4,0x3f
    80001d58:	8dd9                	or	a1,a1,a4
    80001d5a:	02000537          	lui	a0,0x2000
    80001d5e:	157d                	addi	a0,a0,-1
    80001d60:	0536                	slli	a0,a0,0xd
    80001d62:	9782                	jalr	a5
}
    80001d64:	60a2                	ld	ra,8(sp)
    80001d66:	6402                	ld	s0,0(sp)
    80001d68:	0141                	addi	sp,sp,16
    80001d6a:	8082                	ret

0000000080001d6c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d6c:	1101                	addi	sp,sp,-32
    80001d6e:	ec06                	sd	ra,24(sp)
    80001d70:	e822                	sd	s0,16(sp)
    80001d72:	e426                	sd	s1,8(sp)
    80001d74:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d76:	0022d497          	auipc	s1,0x22d
    80001d7a:	10a48493          	addi	s1,s1,266 # 8022ee80 <tickslock>
    80001d7e:	8526                	mv	a0,s1
    80001d80:	00004097          	auipc	ra,0x4
    80001d84:	522080e7          	jalr	1314(ra) # 800062a2 <acquire>
  ticks++;
    80001d88:	00007517          	auipc	a0,0x7
    80001d8c:	29050513          	addi	a0,a0,656 # 80009018 <ticks>
    80001d90:	411c                	lw	a5,0(a0)
    80001d92:	2785                	addiw	a5,a5,1
    80001d94:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	b1c080e7          	jalr	-1252(ra) # 800018b2 <wakeup>
  release(&tickslock);
    80001d9e:	8526                	mv	a0,s1
    80001da0:	00004097          	auipc	ra,0x4
    80001da4:	5b6080e7          	jalr	1462(ra) # 80006356 <release>
}
    80001da8:	60e2                	ld	ra,24(sp)
    80001daa:	6442                	ld	s0,16(sp)
    80001dac:	64a2                	ld	s1,8(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret

0000000080001db2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001db2:	1101                	addi	sp,sp,-32
    80001db4:	ec06                	sd	ra,24(sp)
    80001db6:	e822                	sd	s0,16(sp)
    80001db8:	e426                	sd	s1,8(sp)
    80001dba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001dc0:	00074d63          	bltz	a4,80001dda <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001dc4:	57fd                	li	a5,-1
    80001dc6:	17fe                	slli	a5,a5,0x3f
    80001dc8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dca:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dcc:	06f70363          	beq	a4,a5,80001e32 <devintr+0x80>
  }
}
    80001dd0:	60e2                	ld	ra,24(sp)
    80001dd2:	6442                	ld	s0,16(sp)
    80001dd4:	64a2                	ld	s1,8(sp)
    80001dd6:	6105                	addi	sp,sp,32
    80001dd8:	8082                	ret
     (scause & 0xff) == 9){
    80001dda:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001dde:	46a5                	li	a3,9
    80001de0:	fed792e3          	bne	a5,a3,80001dc4 <devintr+0x12>
    int irq = plic_claim();
    80001de4:	00003097          	auipc	ra,0x3
    80001de8:	484080e7          	jalr	1156(ra) # 80005268 <plic_claim>
    80001dec:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dee:	47a9                	li	a5,10
    80001df0:	02f50763          	beq	a0,a5,80001e1e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001df4:	4785                	li	a5,1
    80001df6:	02f50963          	beq	a0,a5,80001e28 <devintr+0x76>
    return 1;
    80001dfa:	4505                	li	a0,1
    } else if(irq){
    80001dfc:	d8f1                	beqz	s1,80001dd0 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dfe:	85a6                	mv	a1,s1
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	56050513          	addi	a0,a0,1376 # 80008360 <states.1715+0x38>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	f9a080e7          	jalr	-102(ra) # 80005da2 <printf>
      plic_complete(irq);
    80001e10:	8526                	mv	a0,s1
    80001e12:	00003097          	auipc	ra,0x3
    80001e16:	47a080e7          	jalr	1146(ra) # 8000528c <plic_complete>
    return 1;
    80001e1a:	4505                	li	a0,1
    80001e1c:	bf55                	j	80001dd0 <devintr+0x1e>
      uartintr();
    80001e1e:	00004097          	auipc	ra,0x4
    80001e22:	3a4080e7          	jalr	932(ra) # 800061c2 <uartintr>
    80001e26:	b7ed                	j	80001e10 <devintr+0x5e>
      virtio_disk_intr();
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	944080e7          	jalr	-1724(ra) # 8000576c <virtio_disk_intr>
    80001e30:	b7c5                	j	80001e10 <devintr+0x5e>
    if(cpuid() == 0){
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	20c080e7          	jalr	524(ra) # 8000103e <cpuid>
    80001e3a:	c901                	beqz	a0,80001e4a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e3c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e40:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e42:	14479073          	csrw	sip,a5
    return 2;
    80001e46:	4509                	li	a0,2
    80001e48:	b761                	j	80001dd0 <devintr+0x1e>
      clockintr();
    80001e4a:	00000097          	auipc	ra,0x0
    80001e4e:	f22080e7          	jalr	-222(ra) # 80001d6c <clockintr>
    80001e52:	b7ed                	j	80001e3c <devintr+0x8a>

0000000080001e54 <usertrap>:
{
    80001e54:	1101                	addi	sp,sp,-32
    80001e56:	ec06                	sd	ra,24(sp)
    80001e58:	e822                	sd	s0,16(sp)
    80001e5a:	e426                	sd	s1,8(sp)
    80001e5c:	e04a                	sd	s2,0(sp)
    80001e5e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e60:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e64:	1007f793          	andi	a5,a5,256
    80001e68:	e3b9                	bnez	a5,80001eae <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e6a:	00003797          	auipc	a5,0x3
    80001e6e:	2f678793          	addi	a5,a5,758 # 80005160 <kernelvec>
    80001e72:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	1f4080e7          	jalr	500(ra) # 8000106a <myproc>
    80001e7e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e80:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e82:	14102773          	csrr	a4,sepc
    80001e86:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e88:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e8c:	47a1                	li	a5,8
    80001e8e:	02f70863          	beq	a4,a5,80001ebe <usertrap+0x6a>
    80001e92:	14202773          	csrr	a4,scause
  } else if (r_scause() == 15) {
    80001e96:	47bd                	li	a5,15
    80001e98:	06f70563          	beq	a4,a5,80001f02 <usertrap+0xae>
  } else if((which_dev = devintr()) != 0){
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	f16080e7          	jalr	-234(ra) # 80001db2 <devintr>
    80001ea4:	892a                	mv	s2,a0
    80001ea6:	c935                	beqz	a0,80001f1a <usertrap+0xc6>
  if(p->killed)
    80001ea8:	549c                	lw	a5,40(s1)
    80001eaa:	c7dd                	beqz	a5,80001f58 <usertrap+0x104>
    80001eac:	a04d                	j	80001f4e <usertrap+0xfa>
    panic("usertrap: not from user mode");
    80001eae:	00006517          	auipc	a0,0x6
    80001eb2:	4d250513          	addi	a0,a0,1234 # 80008380 <states.1715+0x58>
    80001eb6:	00004097          	auipc	ra,0x4
    80001eba:	ea2080e7          	jalr	-350(ra) # 80005d58 <panic>
    if(p->killed)
    80001ebe:	551c                	lw	a5,40(a0)
    80001ec0:	eb9d                	bnez	a5,80001ef6 <usertrap+0xa2>
    p->trapframe->epc += 4;
    80001ec2:	6cb8                	ld	a4,88(s1)
    80001ec4:	6f1c                	ld	a5,24(a4)
    80001ec6:	0791                	addi	a5,a5,4
    80001ec8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ece:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ed2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ed6:	00000097          	auipc	ra,0x0
    80001eda:	2d8080e7          	jalr	728(ra) # 800021ae <syscall>
  if(p->killed)
    80001ede:	549c                	lw	a5,40(s1)
    80001ee0:	e7c1                	bnez	a5,80001f68 <usertrap+0x114>
  usertrapret();
    80001ee2:	00000097          	auipc	ra,0x0
    80001ee6:	dec080e7          	jalr	-532(ra) # 80001cce <usertrapret>
}
    80001eea:	60e2                	ld	ra,24(sp)
    80001eec:	6442                	ld	s0,16(sp)
    80001eee:	64a2                	ld	s1,8(sp)
    80001ef0:	6902                	ld	s2,0(sp)
    80001ef2:	6105                	addi	sp,sp,32
    80001ef4:	8082                	ret
      exit(-1);
    80001ef6:	557d                	li	a0,-1
    80001ef8:	00000097          	auipc	ra,0x0
    80001efc:	a8a080e7          	jalr	-1398(ra) # 80001982 <exit>
    80001f00:	b7c9                	j	80001ec2 <usertrap+0x6e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f02:	143025f3          	csrr	a1,stval
    if (cowalloc(p->pagetable, r_stval()) < 0) {
    80001f06:	6928                	ld	a0,80(a0)
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	e2a080e7          	jalr	-470(ra) # 80000d32 <cowalloc>
    80001f10:	fc0557e3          	bgez	a0,80001ede <usertrap+0x8a>
      p->killed = 1;
    80001f14:	4785                	li	a5,1
    80001f16:	d49c                	sw	a5,40(s1)
    80001f18:	a815                	j	80001f4c <usertrap+0xf8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f1a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f1e:	5890                	lw	a2,48(s1)
    80001f20:	00006517          	auipc	a0,0x6
    80001f24:	48050513          	addi	a0,a0,1152 # 800083a0 <states.1715+0x78>
    80001f28:	00004097          	auipc	ra,0x4
    80001f2c:	e7a080e7          	jalr	-390(ra) # 80005da2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f30:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f34:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f38:	00006517          	auipc	a0,0x6
    80001f3c:	49850513          	addi	a0,a0,1176 # 800083d0 <states.1715+0xa8>
    80001f40:	00004097          	auipc	ra,0x4
    80001f44:	e62080e7          	jalr	-414(ra) # 80005da2 <printf>
    p->killed = 1;
    80001f48:	4785                	li	a5,1
    80001f4a:	d49c                	sw	a5,40(s1)
{
    80001f4c:	4901                	li	s2,0
    exit(-1);
    80001f4e:	557d                	li	a0,-1
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	a32080e7          	jalr	-1486(ra) # 80001982 <exit>
  if(which_dev == 2)
    80001f58:	4789                	li	a5,2
    80001f5a:	f8f914e3          	bne	s2,a5,80001ee2 <usertrap+0x8e>
    yield();
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	78c080e7          	jalr	1932(ra) # 800016ea <yield>
    80001f66:	bfb5                	j	80001ee2 <usertrap+0x8e>
  if(p->killed)
    80001f68:	4901                	li	s2,0
    80001f6a:	b7d5                	j	80001f4e <usertrap+0xfa>

0000000080001f6c <kerneltrap>:
{
    80001f6c:	7179                	addi	sp,sp,-48
    80001f6e:	f406                	sd	ra,40(sp)
    80001f70:	f022                	sd	s0,32(sp)
    80001f72:	ec26                	sd	s1,24(sp)
    80001f74:	e84a                	sd	s2,16(sp)
    80001f76:	e44e                	sd	s3,8(sp)
    80001f78:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f7a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f7e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f82:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f86:	1004f793          	andi	a5,s1,256
    80001f8a:	cb85                	beqz	a5,80001fba <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f8c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f90:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f92:	ef85                	bnez	a5,80001fca <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f94:	00000097          	auipc	ra,0x0
    80001f98:	e1e080e7          	jalr	-482(ra) # 80001db2 <devintr>
    80001f9c:	cd1d                	beqz	a0,80001fda <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f9e:	4789                	li	a5,2
    80001fa0:	06f50a63          	beq	a0,a5,80002014 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fa4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fa8:	10049073          	csrw	sstatus,s1
}
    80001fac:	70a2                	ld	ra,40(sp)
    80001fae:	7402                	ld	s0,32(sp)
    80001fb0:	64e2                	ld	s1,24(sp)
    80001fb2:	6942                	ld	s2,16(sp)
    80001fb4:	69a2                	ld	s3,8(sp)
    80001fb6:	6145                	addi	sp,sp,48
    80001fb8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fba:	00006517          	auipc	a0,0x6
    80001fbe:	43650513          	addi	a0,a0,1078 # 800083f0 <states.1715+0xc8>
    80001fc2:	00004097          	auipc	ra,0x4
    80001fc6:	d96080e7          	jalr	-618(ra) # 80005d58 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fca:	00006517          	auipc	a0,0x6
    80001fce:	44e50513          	addi	a0,a0,1102 # 80008418 <states.1715+0xf0>
    80001fd2:	00004097          	auipc	ra,0x4
    80001fd6:	d86080e7          	jalr	-634(ra) # 80005d58 <panic>
    printf("scause %p\n", scause);
    80001fda:	85ce                	mv	a1,s3
    80001fdc:	00006517          	auipc	a0,0x6
    80001fe0:	45c50513          	addi	a0,a0,1116 # 80008438 <states.1715+0x110>
    80001fe4:	00004097          	auipc	ra,0x4
    80001fe8:	dbe080e7          	jalr	-578(ra) # 80005da2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ff0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ff4:	00006517          	auipc	a0,0x6
    80001ff8:	45450513          	addi	a0,a0,1108 # 80008448 <states.1715+0x120>
    80001ffc:	00004097          	auipc	ra,0x4
    80002000:	da6080e7          	jalr	-602(ra) # 80005da2 <printf>
    panic("kerneltrap");
    80002004:	00006517          	auipc	a0,0x6
    80002008:	45c50513          	addi	a0,a0,1116 # 80008460 <states.1715+0x138>
    8000200c:	00004097          	auipc	ra,0x4
    80002010:	d4c080e7          	jalr	-692(ra) # 80005d58 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	056080e7          	jalr	86(ra) # 8000106a <myproc>
    8000201c:	d541                	beqz	a0,80001fa4 <kerneltrap+0x38>
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	04c080e7          	jalr	76(ra) # 8000106a <myproc>
    80002026:	4d18                	lw	a4,24(a0)
    80002028:	4791                	li	a5,4
    8000202a:	f6f71de3          	bne	a4,a5,80001fa4 <kerneltrap+0x38>
    yield();
    8000202e:	fffff097          	auipc	ra,0xfffff
    80002032:	6bc080e7          	jalr	1724(ra) # 800016ea <yield>
    80002036:	b7bd                	j	80001fa4 <kerneltrap+0x38>

0000000080002038 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	e426                	sd	s1,8(sp)
    80002040:	1000                	addi	s0,sp,32
    80002042:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	026080e7          	jalr	38(ra) # 8000106a <myproc>
  switch (n) {
    8000204c:	4795                	li	a5,5
    8000204e:	0497e163          	bltu	a5,s1,80002090 <argraw+0x58>
    80002052:	048a                	slli	s1,s1,0x2
    80002054:	00006717          	auipc	a4,0x6
    80002058:	44470713          	addi	a4,a4,1092 # 80008498 <states.1715+0x170>
    8000205c:	94ba                	add	s1,s1,a4
    8000205e:	409c                	lw	a5,0(s1)
    80002060:	97ba                	add	a5,a5,a4
    80002062:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002064:	6d3c                	ld	a5,88(a0)
    80002066:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002068:	60e2                	ld	ra,24(sp)
    8000206a:	6442                	ld	s0,16(sp)
    8000206c:	64a2                	ld	s1,8(sp)
    8000206e:	6105                	addi	sp,sp,32
    80002070:	8082                	ret
    return p->trapframe->a1;
    80002072:	6d3c                	ld	a5,88(a0)
    80002074:	7fa8                	ld	a0,120(a5)
    80002076:	bfcd                	j	80002068 <argraw+0x30>
    return p->trapframe->a2;
    80002078:	6d3c                	ld	a5,88(a0)
    8000207a:	63c8                	ld	a0,128(a5)
    8000207c:	b7f5                	j	80002068 <argraw+0x30>
    return p->trapframe->a3;
    8000207e:	6d3c                	ld	a5,88(a0)
    80002080:	67c8                	ld	a0,136(a5)
    80002082:	b7dd                	j	80002068 <argraw+0x30>
    return p->trapframe->a4;
    80002084:	6d3c                	ld	a5,88(a0)
    80002086:	6bc8                	ld	a0,144(a5)
    80002088:	b7c5                	j	80002068 <argraw+0x30>
    return p->trapframe->a5;
    8000208a:	6d3c                	ld	a5,88(a0)
    8000208c:	6fc8                	ld	a0,152(a5)
    8000208e:	bfe9                	j	80002068 <argraw+0x30>
  panic("argraw");
    80002090:	00006517          	auipc	a0,0x6
    80002094:	3e050513          	addi	a0,a0,992 # 80008470 <states.1715+0x148>
    80002098:	00004097          	auipc	ra,0x4
    8000209c:	cc0080e7          	jalr	-832(ra) # 80005d58 <panic>

00000000800020a0 <fetchaddr>:
{
    800020a0:	1101                	addi	sp,sp,-32
    800020a2:	ec06                	sd	ra,24(sp)
    800020a4:	e822                	sd	s0,16(sp)
    800020a6:	e426                	sd	s1,8(sp)
    800020a8:	e04a                	sd	s2,0(sp)
    800020aa:	1000                	addi	s0,sp,32
    800020ac:	84aa                	mv	s1,a0
    800020ae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020b0:	fffff097          	auipc	ra,0xfffff
    800020b4:	fba080e7          	jalr	-70(ra) # 8000106a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020b8:	653c                	ld	a5,72(a0)
    800020ba:	02f4f863          	bgeu	s1,a5,800020ea <fetchaddr+0x4a>
    800020be:	00848713          	addi	a4,s1,8
    800020c2:	02e7e663          	bltu	a5,a4,800020ee <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020c6:	46a1                	li	a3,8
    800020c8:	8626                	mv	a2,s1
    800020ca:	85ca                	mv	a1,s2
    800020cc:	6928                	ld	a0,80(a0)
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	b24080e7          	jalr	-1244(ra) # 80000bf2 <copyin>
    800020d6:	00a03533          	snez	a0,a0
    800020da:	40a00533          	neg	a0,a0
}
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	64a2                	ld	s1,8(sp)
    800020e4:	6902                	ld	s2,0(sp)
    800020e6:	6105                	addi	sp,sp,32
    800020e8:	8082                	ret
    return -1;
    800020ea:	557d                	li	a0,-1
    800020ec:	bfcd                	j	800020de <fetchaddr+0x3e>
    800020ee:	557d                	li	a0,-1
    800020f0:	b7fd                	j	800020de <fetchaddr+0x3e>

00000000800020f2 <fetchstr>:
{
    800020f2:	7179                	addi	sp,sp,-48
    800020f4:	f406                	sd	ra,40(sp)
    800020f6:	f022                	sd	s0,32(sp)
    800020f8:	ec26                	sd	s1,24(sp)
    800020fa:	e84a                	sd	s2,16(sp)
    800020fc:	e44e                	sd	s3,8(sp)
    800020fe:	1800                	addi	s0,sp,48
    80002100:	892a                	mv	s2,a0
    80002102:	84ae                	mv	s1,a1
    80002104:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	f64080e7          	jalr	-156(ra) # 8000106a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000210e:	86ce                	mv	a3,s3
    80002110:	864a                	mv	a2,s2
    80002112:	85a6                	mv	a1,s1
    80002114:	6928                	ld	a0,80(a0)
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	b68080e7          	jalr	-1176(ra) # 80000c7e <copyinstr>
  if(err < 0)
    8000211e:	00054763          	bltz	a0,8000212c <fetchstr+0x3a>
  return strlen(buf);
    80002122:	8526                	mv	a0,s1
    80002124:	ffffe097          	auipc	ra,0xffffe
    80002128:	2d6080e7          	jalr	726(ra) # 800003fa <strlen>
}
    8000212c:	70a2                	ld	ra,40(sp)
    8000212e:	7402                	ld	s0,32(sp)
    80002130:	64e2                	ld	s1,24(sp)
    80002132:	6942                	ld	s2,16(sp)
    80002134:	69a2                	ld	s3,8(sp)
    80002136:	6145                	addi	sp,sp,48
    80002138:	8082                	ret

000000008000213a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	e426                	sd	s1,8(sp)
    80002142:	1000                	addi	s0,sp,32
    80002144:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	ef2080e7          	jalr	-270(ra) # 80002038 <argraw>
    8000214e:	c088                	sw	a0,0(s1)
  return 0;
}
    80002150:	4501                	li	a0,0
    80002152:	60e2                	ld	ra,24(sp)
    80002154:	6442                	ld	s0,16(sp)
    80002156:	64a2                	ld	s1,8(sp)
    80002158:	6105                	addi	sp,sp,32
    8000215a:	8082                	ret

000000008000215c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	e426                	sd	s1,8(sp)
    80002164:	1000                	addi	s0,sp,32
    80002166:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002168:	00000097          	auipc	ra,0x0
    8000216c:	ed0080e7          	jalr	-304(ra) # 80002038 <argraw>
    80002170:	e088                	sd	a0,0(s1)
  return 0;
}
    80002172:	4501                	li	a0,0
    80002174:	60e2                	ld	ra,24(sp)
    80002176:	6442                	ld	s0,16(sp)
    80002178:	64a2                	ld	s1,8(sp)
    8000217a:	6105                	addi	sp,sp,32
    8000217c:	8082                	ret

000000008000217e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000217e:	1101                	addi	sp,sp,-32
    80002180:	ec06                	sd	ra,24(sp)
    80002182:	e822                	sd	s0,16(sp)
    80002184:	e426                	sd	s1,8(sp)
    80002186:	e04a                	sd	s2,0(sp)
    80002188:	1000                	addi	s0,sp,32
    8000218a:	84ae                	mv	s1,a1
    8000218c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000218e:	00000097          	auipc	ra,0x0
    80002192:	eaa080e7          	jalr	-342(ra) # 80002038 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002196:	864a                	mv	a2,s2
    80002198:	85a6                	mv	a1,s1
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	f58080e7          	jalr	-168(ra) # 800020f2 <fetchstr>
}
    800021a2:	60e2                	ld	ra,24(sp)
    800021a4:	6442                	ld	s0,16(sp)
    800021a6:	64a2                	ld	s1,8(sp)
    800021a8:	6902                	ld	s2,0(sp)
    800021aa:	6105                	addi	sp,sp,32
    800021ac:	8082                	ret

00000000800021ae <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800021ae:	1101                	addi	sp,sp,-32
    800021b0:	ec06                	sd	ra,24(sp)
    800021b2:	e822                	sd	s0,16(sp)
    800021b4:	e426                	sd	s1,8(sp)
    800021b6:	e04a                	sd	s2,0(sp)
    800021b8:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	eb0080e7          	jalr	-336(ra) # 8000106a <myproc>
    800021c2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021c4:	05853903          	ld	s2,88(a0)
    800021c8:	0a893783          	ld	a5,168(s2)
    800021cc:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021d0:	37fd                	addiw	a5,a5,-1
    800021d2:	4751                	li	a4,20
    800021d4:	00f76f63          	bltu	a4,a5,800021f2 <syscall+0x44>
    800021d8:	00369713          	slli	a4,a3,0x3
    800021dc:	00006797          	auipc	a5,0x6
    800021e0:	2d478793          	addi	a5,a5,724 # 800084b0 <syscalls>
    800021e4:	97ba                	add	a5,a5,a4
    800021e6:	639c                	ld	a5,0(a5)
    800021e8:	c789                	beqz	a5,800021f2 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021ea:	9782                	jalr	a5
    800021ec:	06a93823          	sd	a0,112(s2)
    800021f0:	a839                	j	8000220e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021f2:	15848613          	addi	a2,s1,344
    800021f6:	588c                	lw	a1,48(s1)
    800021f8:	00006517          	auipc	a0,0x6
    800021fc:	28050513          	addi	a0,a0,640 # 80008478 <states.1715+0x150>
    80002200:	00004097          	auipc	ra,0x4
    80002204:	ba2080e7          	jalr	-1118(ra) # 80005da2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002208:	6cbc                	ld	a5,88(s1)
    8000220a:	577d                	li	a4,-1
    8000220c:	fbb8                	sd	a4,112(a5)
  }
}
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6902                	ld	s2,0(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret

000000008000221a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000221a:	1101                	addi	sp,sp,-32
    8000221c:	ec06                	sd	ra,24(sp)
    8000221e:	e822                	sd	s0,16(sp)
    80002220:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002222:	fec40593          	addi	a1,s0,-20
    80002226:	4501                	li	a0,0
    80002228:	00000097          	auipc	ra,0x0
    8000222c:	f12080e7          	jalr	-238(ra) # 8000213a <argint>
    return -1;
    80002230:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002232:	00054963          	bltz	a0,80002244 <sys_exit+0x2a>
  exit(n);
    80002236:	fec42503          	lw	a0,-20(s0)
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	748080e7          	jalr	1864(ra) # 80001982 <exit>
  return 0;  // not reached
    80002242:	4781                	li	a5,0
}
    80002244:	853e                	mv	a0,a5
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000224e:	1141                	addi	sp,sp,-16
    80002250:	e406                	sd	ra,8(sp)
    80002252:	e022                	sd	s0,0(sp)
    80002254:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	e14080e7          	jalr	-492(ra) # 8000106a <myproc>
}
    8000225e:	5908                	lw	a0,48(a0)
    80002260:	60a2                	ld	ra,8(sp)
    80002262:	6402                	ld	s0,0(sp)
    80002264:	0141                	addi	sp,sp,16
    80002266:	8082                	ret

0000000080002268 <sys_fork>:

uint64
sys_fork(void)
{
    80002268:	1141                	addi	sp,sp,-16
    8000226a:	e406                	sd	ra,8(sp)
    8000226c:	e022                	sd	s0,0(sp)
    8000226e:	0800                	addi	s0,sp,16
  return fork();
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	1c8080e7          	jalr	456(ra) # 80001438 <fork>
}
    80002278:	60a2                	ld	ra,8(sp)
    8000227a:	6402                	ld	s0,0(sp)
    8000227c:	0141                	addi	sp,sp,16
    8000227e:	8082                	ret

0000000080002280 <sys_wait>:

uint64
sys_wait(void)
{
    80002280:	1101                	addi	sp,sp,-32
    80002282:	ec06                	sd	ra,24(sp)
    80002284:	e822                	sd	s0,16(sp)
    80002286:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002288:	fe840593          	addi	a1,s0,-24
    8000228c:	4501                	li	a0,0
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	ece080e7          	jalr	-306(ra) # 8000215c <argaddr>
    80002296:	87aa                	mv	a5,a0
    return -1;
    80002298:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000229a:	0007c863          	bltz	a5,800022aa <sys_wait+0x2a>
  return wait(p);
    8000229e:	fe843503          	ld	a0,-24(s0)
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	4e8080e7          	jalr	1256(ra) # 8000178a <wait>
}
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	6105                	addi	sp,sp,32
    800022b0:	8082                	ret

00000000800022b2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022b2:	7179                	addi	sp,sp,-48
    800022b4:	f406                	sd	ra,40(sp)
    800022b6:	f022                	sd	s0,32(sp)
    800022b8:	ec26                	sd	s1,24(sp)
    800022ba:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022bc:	fdc40593          	addi	a1,s0,-36
    800022c0:	4501                	li	a0,0
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	e78080e7          	jalr	-392(ra) # 8000213a <argint>
    800022ca:	87aa                	mv	a5,a0
    return -1;
    800022cc:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022ce:	0207c063          	bltz	a5,800022ee <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	d98080e7          	jalr	-616(ra) # 8000106a <myproc>
    800022da:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022dc:	fdc42503          	lw	a0,-36(s0)
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	0e4080e7          	jalr	228(ra) # 800013c4 <growproc>
    800022e8:	00054863          	bltz	a0,800022f8 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022ec:	8526                	mv	a0,s1
}
    800022ee:	70a2                	ld	ra,40(sp)
    800022f0:	7402                	ld	s0,32(sp)
    800022f2:	64e2                	ld	s1,24(sp)
    800022f4:	6145                	addi	sp,sp,48
    800022f6:	8082                	ret
    return -1;
    800022f8:	557d                	li	a0,-1
    800022fa:	bfd5                	j	800022ee <sys_sbrk+0x3c>

00000000800022fc <sys_sleep>:

uint64
sys_sleep(void)
{
    800022fc:	7139                	addi	sp,sp,-64
    800022fe:	fc06                	sd	ra,56(sp)
    80002300:	f822                	sd	s0,48(sp)
    80002302:	f426                	sd	s1,40(sp)
    80002304:	f04a                	sd	s2,32(sp)
    80002306:	ec4e                	sd	s3,24(sp)
    80002308:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000230a:	fcc40593          	addi	a1,s0,-52
    8000230e:	4501                	li	a0,0
    80002310:	00000097          	auipc	ra,0x0
    80002314:	e2a080e7          	jalr	-470(ra) # 8000213a <argint>
    return -1;
    80002318:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000231a:	06054563          	bltz	a0,80002384 <sys_sleep+0x88>
  acquire(&tickslock);
    8000231e:	0022d517          	auipc	a0,0x22d
    80002322:	b6250513          	addi	a0,a0,-1182 # 8022ee80 <tickslock>
    80002326:	00004097          	auipc	ra,0x4
    8000232a:	f7c080e7          	jalr	-132(ra) # 800062a2 <acquire>
  ticks0 = ticks;
    8000232e:	00007917          	auipc	s2,0x7
    80002332:	cea92903          	lw	s2,-790(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002336:	fcc42783          	lw	a5,-52(s0)
    8000233a:	cf85                	beqz	a5,80002372 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000233c:	0022d997          	auipc	s3,0x22d
    80002340:	b4498993          	addi	s3,s3,-1212 # 8022ee80 <tickslock>
    80002344:	00007497          	auipc	s1,0x7
    80002348:	cd448493          	addi	s1,s1,-812 # 80009018 <ticks>
    if(myproc()->killed){
    8000234c:	fffff097          	auipc	ra,0xfffff
    80002350:	d1e080e7          	jalr	-738(ra) # 8000106a <myproc>
    80002354:	551c                	lw	a5,40(a0)
    80002356:	ef9d                	bnez	a5,80002394 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002358:	85ce                	mv	a1,s3
    8000235a:	8526                	mv	a0,s1
    8000235c:	fffff097          	auipc	ra,0xfffff
    80002360:	3ca080e7          	jalr	970(ra) # 80001726 <sleep>
  while(ticks - ticks0 < n){
    80002364:	409c                	lw	a5,0(s1)
    80002366:	412787bb          	subw	a5,a5,s2
    8000236a:	fcc42703          	lw	a4,-52(s0)
    8000236e:	fce7efe3          	bltu	a5,a4,8000234c <sys_sleep+0x50>
  }
  release(&tickslock);
    80002372:	0022d517          	auipc	a0,0x22d
    80002376:	b0e50513          	addi	a0,a0,-1266 # 8022ee80 <tickslock>
    8000237a:	00004097          	auipc	ra,0x4
    8000237e:	fdc080e7          	jalr	-36(ra) # 80006356 <release>
  return 0;
    80002382:	4781                	li	a5,0
}
    80002384:	853e                	mv	a0,a5
    80002386:	70e2                	ld	ra,56(sp)
    80002388:	7442                	ld	s0,48(sp)
    8000238a:	74a2                	ld	s1,40(sp)
    8000238c:	7902                	ld	s2,32(sp)
    8000238e:	69e2                	ld	s3,24(sp)
    80002390:	6121                	addi	sp,sp,64
    80002392:	8082                	ret
      release(&tickslock);
    80002394:	0022d517          	auipc	a0,0x22d
    80002398:	aec50513          	addi	a0,a0,-1300 # 8022ee80 <tickslock>
    8000239c:	00004097          	auipc	ra,0x4
    800023a0:	fba080e7          	jalr	-70(ra) # 80006356 <release>
      return -1;
    800023a4:	57fd                	li	a5,-1
    800023a6:	bff9                	j	80002384 <sys_sleep+0x88>

00000000800023a8 <sys_kill>:

uint64
sys_kill(void)
{
    800023a8:	1101                	addi	sp,sp,-32
    800023aa:	ec06                	sd	ra,24(sp)
    800023ac:	e822                	sd	s0,16(sp)
    800023ae:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023b0:	fec40593          	addi	a1,s0,-20
    800023b4:	4501                	li	a0,0
    800023b6:	00000097          	auipc	ra,0x0
    800023ba:	d84080e7          	jalr	-636(ra) # 8000213a <argint>
    800023be:	87aa                	mv	a5,a0
    return -1;
    800023c0:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023c2:	0007c863          	bltz	a5,800023d2 <sys_kill+0x2a>
  return kill(pid);
    800023c6:	fec42503          	lw	a0,-20(s0)
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	68e080e7          	jalr	1678(ra) # 80001a58 <kill>
}
    800023d2:	60e2                	ld	ra,24(sp)
    800023d4:	6442                	ld	s0,16(sp)
    800023d6:	6105                	addi	sp,sp,32
    800023d8:	8082                	ret

00000000800023da <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800023da:	1101                	addi	sp,sp,-32
    800023dc:	ec06                	sd	ra,24(sp)
    800023de:	e822                	sd	s0,16(sp)
    800023e0:	e426                	sd	s1,8(sp)
    800023e2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023e4:	0022d517          	auipc	a0,0x22d
    800023e8:	a9c50513          	addi	a0,a0,-1380 # 8022ee80 <tickslock>
    800023ec:	00004097          	auipc	ra,0x4
    800023f0:	eb6080e7          	jalr	-330(ra) # 800062a2 <acquire>
  xticks = ticks;
    800023f4:	00007497          	auipc	s1,0x7
    800023f8:	c244a483          	lw	s1,-988(s1) # 80009018 <ticks>
  release(&tickslock);
    800023fc:	0022d517          	auipc	a0,0x22d
    80002400:	a8450513          	addi	a0,a0,-1404 # 8022ee80 <tickslock>
    80002404:	00004097          	auipc	ra,0x4
    80002408:	f52080e7          	jalr	-174(ra) # 80006356 <release>
  return xticks;
}
    8000240c:	02049513          	slli	a0,s1,0x20
    80002410:	9101                	srli	a0,a0,0x20
    80002412:	60e2                	ld	ra,24(sp)
    80002414:	6442                	ld	s0,16(sp)
    80002416:	64a2                	ld	s1,8(sp)
    80002418:	6105                	addi	sp,sp,32
    8000241a:	8082                	ret

000000008000241c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000241c:	7179                	addi	sp,sp,-48
    8000241e:	f406                	sd	ra,40(sp)
    80002420:	f022                	sd	s0,32(sp)
    80002422:	ec26                	sd	s1,24(sp)
    80002424:	e84a                	sd	s2,16(sp)
    80002426:	e44e                	sd	s3,8(sp)
    80002428:	e052                	sd	s4,0(sp)
    8000242a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000242c:	00006597          	auipc	a1,0x6
    80002430:	13458593          	addi	a1,a1,308 # 80008560 <syscalls+0xb0>
    80002434:	0022d517          	auipc	a0,0x22d
    80002438:	a6450513          	addi	a0,a0,-1436 # 8022ee98 <bcache>
    8000243c:	00004097          	auipc	ra,0x4
    80002440:	dd6080e7          	jalr	-554(ra) # 80006212 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002444:	00235797          	auipc	a5,0x235
    80002448:	a5478793          	addi	a5,a5,-1452 # 80236e98 <bcache+0x8000>
    8000244c:	00235717          	auipc	a4,0x235
    80002450:	cb470713          	addi	a4,a4,-844 # 80237100 <bcache+0x8268>
    80002454:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002458:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000245c:	0022d497          	auipc	s1,0x22d
    80002460:	a5448493          	addi	s1,s1,-1452 # 8022eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002464:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002466:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002468:	00006a17          	auipc	s4,0x6
    8000246c:	100a0a13          	addi	s4,s4,256 # 80008568 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002470:	2b893783          	ld	a5,696(s2)
    80002474:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002476:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000247a:	85d2                	mv	a1,s4
    8000247c:	01048513          	addi	a0,s1,16
    80002480:	00001097          	auipc	ra,0x1
    80002484:	4bc080e7          	jalr	1212(ra) # 8000393c <initsleeplock>
    bcache.head.next->prev = b;
    80002488:	2b893783          	ld	a5,696(s2)
    8000248c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000248e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002492:	45848493          	addi	s1,s1,1112
    80002496:	fd349de3          	bne	s1,s3,80002470 <binit+0x54>
  }
}
    8000249a:	70a2                	ld	ra,40(sp)
    8000249c:	7402                	ld	s0,32(sp)
    8000249e:	64e2                	ld	s1,24(sp)
    800024a0:	6942                	ld	s2,16(sp)
    800024a2:	69a2                	ld	s3,8(sp)
    800024a4:	6a02                	ld	s4,0(sp)
    800024a6:	6145                	addi	sp,sp,48
    800024a8:	8082                	ret

00000000800024aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024aa:	7179                	addi	sp,sp,-48
    800024ac:	f406                	sd	ra,40(sp)
    800024ae:	f022                	sd	s0,32(sp)
    800024b0:	ec26                	sd	s1,24(sp)
    800024b2:	e84a                	sd	s2,16(sp)
    800024b4:	e44e                	sd	s3,8(sp)
    800024b6:	1800                	addi	s0,sp,48
    800024b8:	89aa                	mv	s3,a0
    800024ba:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024bc:	0022d517          	auipc	a0,0x22d
    800024c0:	9dc50513          	addi	a0,a0,-1572 # 8022ee98 <bcache>
    800024c4:	00004097          	auipc	ra,0x4
    800024c8:	dde080e7          	jalr	-546(ra) # 800062a2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024cc:	00235497          	auipc	s1,0x235
    800024d0:	c844b483          	ld	s1,-892(s1) # 80237150 <bcache+0x82b8>
    800024d4:	00235797          	auipc	a5,0x235
    800024d8:	c2c78793          	addi	a5,a5,-980 # 80237100 <bcache+0x8268>
    800024dc:	02f48f63          	beq	s1,a5,8000251a <bread+0x70>
    800024e0:	873e                	mv	a4,a5
    800024e2:	a021                	j	800024ea <bread+0x40>
    800024e4:	68a4                	ld	s1,80(s1)
    800024e6:	02e48a63          	beq	s1,a4,8000251a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024ea:	449c                	lw	a5,8(s1)
    800024ec:	ff379ce3          	bne	a5,s3,800024e4 <bread+0x3a>
    800024f0:	44dc                	lw	a5,12(s1)
    800024f2:	ff2799e3          	bne	a5,s2,800024e4 <bread+0x3a>
      b->refcnt++;
    800024f6:	40bc                	lw	a5,64(s1)
    800024f8:	2785                	addiw	a5,a5,1
    800024fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024fc:	0022d517          	auipc	a0,0x22d
    80002500:	99c50513          	addi	a0,a0,-1636 # 8022ee98 <bcache>
    80002504:	00004097          	auipc	ra,0x4
    80002508:	e52080e7          	jalr	-430(ra) # 80006356 <release>
      acquiresleep(&b->lock);
    8000250c:	01048513          	addi	a0,s1,16
    80002510:	00001097          	auipc	ra,0x1
    80002514:	466080e7          	jalr	1126(ra) # 80003976 <acquiresleep>
      return b;
    80002518:	a8b9                	j	80002576 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000251a:	00235497          	auipc	s1,0x235
    8000251e:	c2e4b483          	ld	s1,-978(s1) # 80237148 <bcache+0x82b0>
    80002522:	00235797          	auipc	a5,0x235
    80002526:	bde78793          	addi	a5,a5,-1058 # 80237100 <bcache+0x8268>
    8000252a:	00f48863          	beq	s1,a5,8000253a <bread+0x90>
    8000252e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002530:	40bc                	lw	a5,64(s1)
    80002532:	cf81                	beqz	a5,8000254a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002534:	64a4                	ld	s1,72(s1)
    80002536:	fee49de3          	bne	s1,a4,80002530 <bread+0x86>
  panic("bget: no buffers");
    8000253a:	00006517          	auipc	a0,0x6
    8000253e:	03650513          	addi	a0,a0,54 # 80008570 <syscalls+0xc0>
    80002542:	00004097          	auipc	ra,0x4
    80002546:	816080e7          	jalr	-2026(ra) # 80005d58 <panic>
      b->dev = dev;
    8000254a:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000254e:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002552:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002556:	4785                	li	a5,1
    80002558:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000255a:	0022d517          	auipc	a0,0x22d
    8000255e:	93e50513          	addi	a0,a0,-1730 # 8022ee98 <bcache>
    80002562:	00004097          	auipc	ra,0x4
    80002566:	df4080e7          	jalr	-524(ra) # 80006356 <release>
      acquiresleep(&b->lock);
    8000256a:	01048513          	addi	a0,s1,16
    8000256e:	00001097          	auipc	ra,0x1
    80002572:	408080e7          	jalr	1032(ra) # 80003976 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002576:	409c                	lw	a5,0(s1)
    80002578:	cb89                	beqz	a5,8000258a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000257a:	8526                	mv	a0,s1
    8000257c:	70a2                	ld	ra,40(sp)
    8000257e:	7402                	ld	s0,32(sp)
    80002580:	64e2                	ld	s1,24(sp)
    80002582:	6942                	ld	s2,16(sp)
    80002584:	69a2                	ld	s3,8(sp)
    80002586:	6145                	addi	sp,sp,48
    80002588:	8082                	ret
    virtio_disk_rw(b, 0);
    8000258a:	4581                	li	a1,0
    8000258c:	8526                	mv	a0,s1
    8000258e:	00003097          	auipc	ra,0x3
    80002592:	f08080e7          	jalr	-248(ra) # 80005496 <virtio_disk_rw>
    b->valid = 1;
    80002596:	4785                	li	a5,1
    80002598:	c09c                	sw	a5,0(s1)
  return b;
    8000259a:	b7c5                	j	8000257a <bread+0xd0>

000000008000259c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000259c:	1101                	addi	sp,sp,-32
    8000259e:	ec06                	sd	ra,24(sp)
    800025a0:	e822                	sd	s0,16(sp)
    800025a2:	e426                	sd	s1,8(sp)
    800025a4:	1000                	addi	s0,sp,32
    800025a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a8:	0541                	addi	a0,a0,16
    800025aa:	00001097          	auipc	ra,0x1
    800025ae:	466080e7          	jalr	1126(ra) # 80003a10 <holdingsleep>
    800025b2:	cd01                	beqz	a0,800025ca <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025b4:	4585                	li	a1,1
    800025b6:	8526                	mv	a0,s1
    800025b8:	00003097          	auipc	ra,0x3
    800025bc:	ede080e7          	jalr	-290(ra) # 80005496 <virtio_disk_rw>
}
    800025c0:	60e2                	ld	ra,24(sp)
    800025c2:	6442                	ld	s0,16(sp)
    800025c4:	64a2                	ld	s1,8(sp)
    800025c6:	6105                	addi	sp,sp,32
    800025c8:	8082                	ret
    panic("bwrite");
    800025ca:	00006517          	auipc	a0,0x6
    800025ce:	fbe50513          	addi	a0,a0,-66 # 80008588 <syscalls+0xd8>
    800025d2:	00003097          	auipc	ra,0x3
    800025d6:	786080e7          	jalr	1926(ra) # 80005d58 <panic>

00000000800025da <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800025da:	1101                	addi	sp,sp,-32
    800025dc:	ec06                	sd	ra,24(sp)
    800025de:	e822                	sd	s0,16(sp)
    800025e0:	e426                	sd	s1,8(sp)
    800025e2:	e04a                	sd	s2,0(sp)
    800025e4:	1000                	addi	s0,sp,32
    800025e6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025e8:	01050913          	addi	s2,a0,16
    800025ec:	854a                	mv	a0,s2
    800025ee:	00001097          	auipc	ra,0x1
    800025f2:	422080e7          	jalr	1058(ra) # 80003a10 <holdingsleep>
    800025f6:	c92d                	beqz	a0,80002668 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025f8:	854a                	mv	a0,s2
    800025fa:	00001097          	auipc	ra,0x1
    800025fe:	3d2080e7          	jalr	978(ra) # 800039cc <releasesleep>

  acquire(&bcache.lock);
    80002602:	0022d517          	auipc	a0,0x22d
    80002606:	89650513          	addi	a0,a0,-1898 # 8022ee98 <bcache>
    8000260a:	00004097          	auipc	ra,0x4
    8000260e:	c98080e7          	jalr	-872(ra) # 800062a2 <acquire>
  b->refcnt--;
    80002612:	40bc                	lw	a5,64(s1)
    80002614:	37fd                	addiw	a5,a5,-1
    80002616:	0007871b          	sext.w	a4,a5
    8000261a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000261c:	eb05                	bnez	a4,8000264c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000261e:	68bc                	ld	a5,80(s1)
    80002620:	64b8                	ld	a4,72(s1)
    80002622:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002624:	64bc                	ld	a5,72(s1)
    80002626:	68b8                	ld	a4,80(s1)
    80002628:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000262a:	00235797          	auipc	a5,0x235
    8000262e:	86e78793          	addi	a5,a5,-1938 # 80236e98 <bcache+0x8000>
    80002632:	2b87b703          	ld	a4,696(a5)
    80002636:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002638:	00235717          	auipc	a4,0x235
    8000263c:	ac870713          	addi	a4,a4,-1336 # 80237100 <bcache+0x8268>
    80002640:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002642:	2b87b703          	ld	a4,696(a5)
    80002646:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002648:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000264c:	0022d517          	auipc	a0,0x22d
    80002650:	84c50513          	addi	a0,a0,-1972 # 8022ee98 <bcache>
    80002654:	00004097          	auipc	ra,0x4
    80002658:	d02080e7          	jalr	-766(ra) # 80006356 <release>
}
    8000265c:	60e2                	ld	ra,24(sp)
    8000265e:	6442                	ld	s0,16(sp)
    80002660:	64a2                	ld	s1,8(sp)
    80002662:	6902                	ld	s2,0(sp)
    80002664:	6105                	addi	sp,sp,32
    80002666:	8082                	ret
    panic("brelse");
    80002668:	00006517          	auipc	a0,0x6
    8000266c:	f2850513          	addi	a0,a0,-216 # 80008590 <syscalls+0xe0>
    80002670:	00003097          	auipc	ra,0x3
    80002674:	6e8080e7          	jalr	1768(ra) # 80005d58 <panic>

0000000080002678 <bpin>:

void
bpin(struct buf *b) {
    80002678:	1101                	addi	sp,sp,-32
    8000267a:	ec06                	sd	ra,24(sp)
    8000267c:	e822                	sd	s0,16(sp)
    8000267e:	e426                	sd	s1,8(sp)
    80002680:	1000                	addi	s0,sp,32
    80002682:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002684:	0022d517          	auipc	a0,0x22d
    80002688:	81450513          	addi	a0,a0,-2028 # 8022ee98 <bcache>
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	c16080e7          	jalr	-1002(ra) # 800062a2 <acquire>
  b->refcnt++;
    80002694:	40bc                	lw	a5,64(s1)
    80002696:	2785                	addiw	a5,a5,1
    80002698:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000269a:	0022c517          	auipc	a0,0x22c
    8000269e:	7fe50513          	addi	a0,a0,2046 # 8022ee98 <bcache>
    800026a2:	00004097          	auipc	ra,0x4
    800026a6:	cb4080e7          	jalr	-844(ra) # 80006356 <release>
}
    800026aa:	60e2                	ld	ra,24(sp)
    800026ac:	6442                	ld	s0,16(sp)
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	6105                	addi	sp,sp,32
    800026b2:	8082                	ret

00000000800026b4 <bunpin>:

void
bunpin(struct buf *b) {
    800026b4:	1101                	addi	sp,sp,-32
    800026b6:	ec06                	sd	ra,24(sp)
    800026b8:	e822                	sd	s0,16(sp)
    800026ba:	e426                	sd	s1,8(sp)
    800026bc:	1000                	addi	s0,sp,32
    800026be:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026c0:	0022c517          	auipc	a0,0x22c
    800026c4:	7d850513          	addi	a0,a0,2008 # 8022ee98 <bcache>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	bda080e7          	jalr	-1062(ra) # 800062a2 <acquire>
  b->refcnt--;
    800026d0:	40bc                	lw	a5,64(s1)
    800026d2:	37fd                	addiw	a5,a5,-1
    800026d4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026d6:	0022c517          	auipc	a0,0x22c
    800026da:	7c250513          	addi	a0,a0,1986 # 8022ee98 <bcache>
    800026de:	00004097          	auipc	ra,0x4
    800026e2:	c78080e7          	jalr	-904(ra) # 80006356 <release>
}
    800026e6:	60e2                	ld	ra,24(sp)
    800026e8:	6442                	ld	s0,16(sp)
    800026ea:	64a2                	ld	s1,8(sp)
    800026ec:	6105                	addi	sp,sp,32
    800026ee:	8082                	ret

00000000800026f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026f0:	1101                	addi	sp,sp,-32
    800026f2:	ec06                	sd	ra,24(sp)
    800026f4:	e822                	sd	s0,16(sp)
    800026f6:	e426                	sd	s1,8(sp)
    800026f8:	e04a                	sd	s2,0(sp)
    800026fa:	1000                	addi	s0,sp,32
    800026fc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026fe:	00d5d59b          	srliw	a1,a1,0xd
    80002702:	00235797          	auipc	a5,0x235
    80002706:	e727a783          	lw	a5,-398(a5) # 80237574 <sb+0x1c>
    8000270a:	9dbd                	addw	a1,a1,a5
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	d9e080e7          	jalr	-610(ra) # 800024aa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002714:	0074f713          	andi	a4,s1,7
    80002718:	4785                	li	a5,1
    8000271a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000271e:	14ce                	slli	s1,s1,0x33
    80002720:	90d9                	srli	s1,s1,0x36
    80002722:	00950733          	add	a4,a0,s1
    80002726:	05874703          	lbu	a4,88(a4)
    8000272a:	00e7f6b3          	and	a3,a5,a4
    8000272e:	c69d                	beqz	a3,8000275c <bfree+0x6c>
    80002730:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002732:	94aa                	add	s1,s1,a0
    80002734:	fff7c793          	not	a5,a5
    80002738:	8ff9                	and	a5,a5,a4
    8000273a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000273e:	00001097          	auipc	ra,0x1
    80002742:	118080e7          	jalr	280(ra) # 80003856 <log_write>
  brelse(bp);
    80002746:	854a                	mv	a0,s2
    80002748:	00000097          	auipc	ra,0x0
    8000274c:	e92080e7          	jalr	-366(ra) # 800025da <brelse>
}
    80002750:	60e2                	ld	ra,24(sp)
    80002752:	6442                	ld	s0,16(sp)
    80002754:	64a2                	ld	s1,8(sp)
    80002756:	6902                	ld	s2,0(sp)
    80002758:	6105                	addi	sp,sp,32
    8000275a:	8082                	ret
    panic("freeing free block");
    8000275c:	00006517          	auipc	a0,0x6
    80002760:	e3c50513          	addi	a0,a0,-452 # 80008598 <syscalls+0xe8>
    80002764:	00003097          	auipc	ra,0x3
    80002768:	5f4080e7          	jalr	1524(ra) # 80005d58 <panic>

000000008000276c <balloc>:
{
    8000276c:	711d                	addi	sp,sp,-96
    8000276e:	ec86                	sd	ra,88(sp)
    80002770:	e8a2                	sd	s0,80(sp)
    80002772:	e4a6                	sd	s1,72(sp)
    80002774:	e0ca                	sd	s2,64(sp)
    80002776:	fc4e                	sd	s3,56(sp)
    80002778:	f852                	sd	s4,48(sp)
    8000277a:	f456                	sd	s5,40(sp)
    8000277c:	f05a                	sd	s6,32(sp)
    8000277e:	ec5e                	sd	s7,24(sp)
    80002780:	e862                	sd	s8,16(sp)
    80002782:	e466                	sd	s9,8(sp)
    80002784:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002786:	00235797          	auipc	a5,0x235
    8000278a:	dd67a783          	lw	a5,-554(a5) # 8023755c <sb+0x4>
    8000278e:	cbd1                	beqz	a5,80002822 <balloc+0xb6>
    80002790:	8baa                	mv	s7,a0
    80002792:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002794:	00235b17          	auipc	s6,0x235
    80002798:	dc4b0b13          	addi	s6,s6,-572 # 80237558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000279c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000279e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027a0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027a2:	6c89                	lui	s9,0x2
    800027a4:	a831                	j	800027c0 <balloc+0x54>
    brelse(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	e32080e7          	jalr	-462(ra) # 800025da <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027b0:	015c87bb          	addw	a5,s9,s5
    800027b4:	00078a9b          	sext.w	s5,a5
    800027b8:	004b2703          	lw	a4,4(s6)
    800027bc:	06eaf363          	bgeu	s5,a4,80002822 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027c0:	41fad79b          	sraiw	a5,s5,0x1f
    800027c4:	0137d79b          	srliw	a5,a5,0x13
    800027c8:	015787bb          	addw	a5,a5,s5
    800027cc:	40d7d79b          	sraiw	a5,a5,0xd
    800027d0:	01cb2583          	lw	a1,28(s6)
    800027d4:	9dbd                	addw	a1,a1,a5
    800027d6:	855e                	mv	a0,s7
    800027d8:	00000097          	auipc	ra,0x0
    800027dc:	cd2080e7          	jalr	-814(ra) # 800024aa <bread>
    800027e0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e2:	004b2503          	lw	a0,4(s6)
    800027e6:	000a849b          	sext.w	s1,s5
    800027ea:	8662                	mv	a2,s8
    800027ec:	faa4fde3          	bgeu	s1,a0,800027a6 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027f0:	41f6579b          	sraiw	a5,a2,0x1f
    800027f4:	01d7d69b          	srliw	a3,a5,0x1d
    800027f8:	00c6873b          	addw	a4,a3,a2
    800027fc:	00777793          	andi	a5,a4,7
    80002800:	9f95                	subw	a5,a5,a3
    80002802:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002806:	4037571b          	sraiw	a4,a4,0x3
    8000280a:	00e906b3          	add	a3,s2,a4
    8000280e:	0586c683          	lbu	a3,88(a3)
    80002812:	00d7f5b3          	and	a1,a5,a3
    80002816:	cd91                	beqz	a1,80002832 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002818:	2605                	addiw	a2,a2,1
    8000281a:	2485                	addiw	s1,s1,1
    8000281c:	fd4618e3          	bne	a2,s4,800027ec <balloc+0x80>
    80002820:	b759                	j	800027a6 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002822:	00006517          	auipc	a0,0x6
    80002826:	d8e50513          	addi	a0,a0,-626 # 800085b0 <syscalls+0x100>
    8000282a:	00003097          	auipc	ra,0x3
    8000282e:	52e080e7          	jalr	1326(ra) # 80005d58 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002832:	974a                	add	a4,a4,s2
    80002834:	8fd5                	or	a5,a5,a3
    80002836:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000283a:	854a                	mv	a0,s2
    8000283c:	00001097          	auipc	ra,0x1
    80002840:	01a080e7          	jalr	26(ra) # 80003856 <log_write>
        brelse(bp);
    80002844:	854a                	mv	a0,s2
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	d94080e7          	jalr	-620(ra) # 800025da <brelse>
  bp = bread(dev, bno);
    8000284e:	85a6                	mv	a1,s1
    80002850:	855e                	mv	a0,s7
    80002852:	00000097          	auipc	ra,0x0
    80002856:	c58080e7          	jalr	-936(ra) # 800024aa <bread>
    8000285a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000285c:	40000613          	li	a2,1024
    80002860:	4581                	li	a1,0
    80002862:	05850513          	addi	a0,a0,88
    80002866:	ffffe097          	auipc	ra,0xffffe
    8000286a:	a10080e7          	jalr	-1520(ra) # 80000276 <memset>
  log_write(bp);
    8000286e:	854a                	mv	a0,s2
    80002870:	00001097          	auipc	ra,0x1
    80002874:	fe6080e7          	jalr	-26(ra) # 80003856 <log_write>
  brelse(bp);
    80002878:	854a                	mv	a0,s2
    8000287a:	00000097          	auipc	ra,0x0
    8000287e:	d60080e7          	jalr	-672(ra) # 800025da <brelse>
}
    80002882:	8526                	mv	a0,s1
    80002884:	60e6                	ld	ra,88(sp)
    80002886:	6446                	ld	s0,80(sp)
    80002888:	64a6                	ld	s1,72(sp)
    8000288a:	6906                	ld	s2,64(sp)
    8000288c:	79e2                	ld	s3,56(sp)
    8000288e:	7a42                	ld	s4,48(sp)
    80002890:	7aa2                	ld	s5,40(sp)
    80002892:	7b02                	ld	s6,32(sp)
    80002894:	6be2                	ld	s7,24(sp)
    80002896:	6c42                	ld	s8,16(sp)
    80002898:	6ca2                	ld	s9,8(sp)
    8000289a:	6125                	addi	sp,sp,96
    8000289c:	8082                	ret

000000008000289e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000289e:	7179                	addi	sp,sp,-48
    800028a0:	f406                	sd	ra,40(sp)
    800028a2:	f022                	sd	s0,32(sp)
    800028a4:	ec26                	sd	s1,24(sp)
    800028a6:	e84a                	sd	s2,16(sp)
    800028a8:	e44e                	sd	s3,8(sp)
    800028aa:	e052                	sd	s4,0(sp)
    800028ac:	1800                	addi	s0,sp,48
    800028ae:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028b0:	47ad                	li	a5,11
    800028b2:	04b7fe63          	bgeu	a5,a1,8000290e <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028b6:	ff45849b          	addiw	s1,a1,-12
    800028ba:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028be:	0ff00793          	li	a5,255
    800028c2:	0ae7e363          	bltu	a5,a4,80002968 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028c6:	08052583          	lw	a1,128(a0)
    800028ca:	c5ad                	beqz	a1,80002934 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028cc:	00092503          	lw	a0,0(s2)
    800028d0:	00000097          	auipc	ra,0x0
    800028d4:	bda080e7          	jalr	-1062(ra) # 800024aa <bread>
    800028d8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028da:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028de:	02049593          	slli	a1,s1,0x20
    800028e2:	9181                	srli	a1,a1,0x20
    800028e4:	058a                	slli	a1,a1,0x2
    800028e6:	00b784b3          	add	s1,a5,a1
    800028ea:	0004a983          	lw	s3,0(s1)
    800028ee:	04098d63          	beqz	s3,80002948 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028f2:	8552                	mv	a0,s4
    800028f4:	00000097          	auipc	ra,0x0
    800028f8:	ce6080e7          	jalr	-794(ra) # 800025da <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028fc:	854e                	mv	a0,s3
    800028fe:	70a2                	ld	ra,40(sp)
    80002900:	7402                	ld	s0,32(sp)
    80002902:	64e2                	ld	s1,24(sp)
    80002904:	6942                	ld	s2,16(sp)
    80002906:	69a2                	ld	s3,8(sp)
    80002908:	6a02                	ld	s4,0(sp)
    8000290a:	6145                	addi	sp,sp,48
    8000290c:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000290e:	02059493          	slli	s1,a1,0x20
    80002912:	9081                	srli	s1,s1,0x20
    80002914:	048a                	slli	s1,s1,0x2
    80002916:	94aa                	add	s1,s1,a0
    80002918:	0504a983          	lw	s3,80(s1)
    8000291c:	fe0990e3          	bnez	s3,800028fc <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002920:	4108                	lw	a0,0(a0)
    80002922:	00000097          	auipc	ra,0x0
    80002926:	e4a080e7          	jalr	-438(ra) # 8000276c <balloc>
    8000292a:	0005099b          	sext.w	s3,a0
    8000292e:	0534a823          	sw	s3,80(s1)
    80002932:	b7e9                	j	800028fc <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002934:	4108                	lw	a0,0(a0)
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	e36080e7          	jalr	-458(ra) # 8000276c <balloc>
    8000293e:	0005059b          	sext.w	a1,a0
    80002942:	08b92023          	sw	a1,128(s2)
    80002946:	b759                	j	800028cc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002948:	00092503          	lw	a0,0(s2)
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	e20080e7          	jalr	-480(ra) # 8000276c <balloc>
    80002954:	0005099b          	sext.w	s3,a0
    80002958:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000295c:	8552                	mv	a0,s4
    8000295e:	00001097          	auipc	ra,0x1
    80002962:	ef8080e7          	jalr	-264(ra) # 80003856 <log_write>
    80002966:	b771                	j	800028f2 <bmap+0x54>
  panic("bmap: out of range");
    80002968:	00006517          	auipc	a0,0x6
    8000296c:	c6050513          	addi	a0,a0,-928 # 800085c8 <syscalls+0x118>
    80002970:	00003097          	auipc	ra,0x3
    80002974:	3e8080e7          	jalr	1000(ra) # 80005d58 <panic>

0000000080002978 <iget>:
{
    80002978:	7179                	addi	sp,sp,-48
    8000297a:	f406                	sd	ra,40(sp)
    8000297c:	f022                	sd	s0,32(sp)
    8000297e:	ec26                	sd	s1,24(sp)
    80002980:	e84a                	sd	s2,16(sp)
    80002982:	e44e                	sd	s3,8(sp)
    80002984:	e052                	sd	s4,0(sp)
    80002986:	1800                	addi	s0,sp,48
    80002988:	89aa                	mv	s3,a0
    8000298a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000298c:	00235517          	auipc	a0,0x235
    80002990:	bec50513          	addi	a0,a0,-1044 # 80237578 <itable>
    80002994:	00004097          	auipc	ra,0x4
    80002998:	90e080e7          	jalr	-1778(ra) # 800062a2 <acquire>
  empty = 0;
    8000299c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000299e:	00235497          	auipc	s1,0x235
    800029a2:	bf248493          	addi	s1,s1,-1038 # 80237590 <itable+0x18>
    800029a6:	00236697          	auipc	a3,0x236
    800029aa:	67a68693          	addi	a3,a3,1658 # 80239020 <log>
    800029ae:	a039                	j	800029bc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b0:	02090b63          	beqz	s2,800029e6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029b4:	08848493          	addi	s1,s1,136
    800029b8:	02d48a63          	beq	s1,a3,800029ec <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029bc:	449c                	lw	a5,8(s1)
    800029be:	fef059e3          	blez	a5,800029b0 <iget+0x38>
    800029c2:	4098                	lw	a4,0(s1)
    800029c4:	ff3716e3          	bne	a4,s3,800029b0 <iget+0x38>
    800029c8:	40d8                	lw	a4,4(s1)
    800029ca:	ff4713e3          	bne	a4,s4,800029b0 <iget+0x38>
      ip->ref++;
    800029ce:	2785                	addiw	a5,a5,1
    800029d0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029d2:	00235517          	auipc	a0,0x235
    800029d6:	ba650513          	addi	a0,a0,-1114 # 80237578 <itable>
    800029da:	00004097          	auipc	ra,0x4
    800029de:	97c080e7          	jalr	-1668(ra) # 80006356 <release>
      return ip;
    800029e2:	8926                	mv	s2,s1
    800029e4:	a03d                	j	80002a12 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029e6:	f7f9                	bnez	a5,800029b4 <iget+0x3c>
    800029e8:	8926                	mv	s2,s1
    800029ea:	b7e9                	j	800029b4 <iget+0x3c>
  if(empty == 0)
    800029ec:	02090c63          	beqz	s2,80002a24 <iget+0xac>
  ip->dev = dev;
    800029f0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029f4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029f8:	4785                	li	a5,1
    800029fa:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029fe:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a02:	00235517          	auipc	a0,0x235
    80002a06:	b7650513          	addi	a0,a0,-1162 # 80237578 <itable>
    80002a0a:	00004097          	auipc	ra,0x4
    80002a0e:	94c080e7          	jalr	-1716(ra) # 80006356 <release>
}
    80002a12:	854a                	mv	a0,s2
    80002a14:	70a2                	ld	ra,40(sp)
    80002a16:	7402                	ld	s0,32(sp)
    80002a18:	64e2                	ld	s1,24(sp)
    80002a1a:	6942                	ld	s2,16(sp)
    80002a1c:	69a2                	ld	s3,8(sp)
    80002a1e:	6a02                	ld	s4,0(sp)
    80002a20:	6145                	addi	sp,sp,48
    80002a22:	8082                	ret
    panic("iget: no inodes");
    80002a24:	00006517          	auipc	a0,0x6
    80002a28:	bbc50513          	addi	a0,a0,-1092 # 800085e0 <syscalls+0x130>
    80002a2c:	00003097          	auipc	ra,0x3
    80002a30:	32c080e7          	jalr	812(ra) # 80005d58 <panic>

0000000080002a34 <fsinit>:
fsinit(int dev) {
    80002a34:	7179                	addi	sp,sp,-48
    80002a36:	f406                	sd	ra,40(sp)
    80002a38:	f022                	sd	s0,32(sp)
    80002a3a:	ec26                	sd	s1,24(sp)
    80002a3c:	e84a                	sd	s2,16(sp)
    80002a3e:	e44e                	sd	s3,8(sp)
    80002a40:	1800                	addi	s0,sp,48
    80002a42:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a44:	4585                	li	a1,1
    80002a46:	00000097          	auipc	ra,0x0
    80002a4a:	a64080e7          	jalr	-1436(ra) # 800024aa <bread>
    80002a4e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a50:	00235997          	auipc	s3,0x235
    80002a54:	b0898993          	addi	s3,s3,-1272 # 80237558 <sb>
    80002a58:	02000613          	li	a2,32
    80002a5c:	05850593          	addi	a1,a0,88
    80002a60:	854e                	mv	a0,s3
    80002a62:	ffffe097          	auipc	ra,0xffffe
    80002a66:	874080e7          	jalr	-1932(ra) # 800002d6 <memmove>
  brelse(bp);
    80002a6a:	8526                	mv	a0,s1
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	b6e080e7          	jalr	-1170(ra) # 800025da <brelse>
  if(sb.magic != FSMAGIC)
    80002a74:	0009a703          	lw	a4,0(s3)
    80002a78:	102037b7          	lui	a5,0x10203
    80002a7c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a80:	02f71263          	bne	a4,a5,80002aa4 <fsinit+0x70>
  initlog(dev, &sb);
    80002a84:	00235597          	auipc	a1,0x235
    80002a88:	ad458593          	addi	a1,a1,-1324 # 80237558 <sb>
    80002a8c:	854a                	mv	a0,s2
    80002a8e:	00001097          	auipc	ra,0x1
    80002a92:	b4c080e7          	jalr	-1204(ra) # 800035da <initlog>
}
    80002a96:	70a2                	ld	ra,40(sp)
    80002a98:	7402                	ld	s0,32(sp)
    80002a9a:	64e2                	ld	s1,24(sp)
    80002a9c:	6942                	ld	s2,16(sp)
    80002a9e:	69a2                	ld	s3,8(sp)
    80002aa0:	6145                	addi	sp,sp,48
    80002aa2:	8082                	ret
    panic("invalid file system");
    80002aa4:	00006517          	auipc	a0,0x6
    80002aa8:	b4c50513          	addi	a0,a0,-1204 # 800085f0 <syscalls+0x140>
    80002aac:	00003097          	auipc	ra,0x3
    80002ab0:	2ac080e7          	jalr	684(ra) # 80005d58 <panic>

0000000080002ab4 <iinit>:
{
    80002ab4:	7179                	addi	sp,sp,-48
    80002ab6:	f406                	sd	ra,40(sp)
    80002ab8:	f022                	sd	s0,32(sp)
    80002aba:	ec26                	sd	s1,24(sp)
    80002abc:	e84a                	sd	s2,16(sp)
    80002abe:	e44e                	sd	s3,8(sp)
    80002ac0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ac2:	00006597          	auipc	a1,0x6
    80002ac6:	b4658593          	addi	a1,a1,-1210 # 80008608 <syscalls+0x158>
    80002aca:	00235517          	auipc	a0,0x235
    80002ace:	aae50513          	addi	a0,a0,-1362 # 80237578 <itable>
    80002ad2:	00003097          	auipc	ra,0x3
    80002ad6:	740080e7          	jalr	1856(ra) # 80006212 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ada:	00235497          	auipc	s1,0x235
    80002ade:	ac648493          	addi	s1,s1,-1338 # 802375a0 <itable+0x28>
    80002ae2:	00236997          	auipc	s3,0x236
    80002ae6:	54e98993          	addi	s3,s3,1358 # 80239030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aea:	00006917          	auipc	s2,0x6
    80002aee:	b2690913          	addi	s2,s2,-1242 # 80008610 <syscalls+0x160>
    80002af2:	85ca                	mv	a1,s2
    80002af4:	8526                	mv	a0,s1
    80002af6:	00001097          	auipc	ra,0x1
    80002afa:	e46080e7          	jalr	-442(ra) # 8000393c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002afe:	08848493          	addi	s1,s1,136
    80002b02:	ff3498e3          	bne	s1,s3,80002af2 <iinit+0x3e>
}
    80002b06:	70a2                	ld	ra,40(sp)
    80002b08:	7402                	ld	s0,32(sp)
    80002b0a:	64e2                	ld	s1,24(sp)
    80002b0c:	6942                	ld	s2,16(sp)
    80002b0e:	69a2                	ld	s3,8(sp)
    80002b10:	6145                	addi	sp,sp,48
    80002b12:	8082                	ret

0000000080002b14 <ialloc>:
{
    80002b14:	715d                	addi	sp,sp,-80
    80002b16:	e486                	sd	ra,72(sp)
    80002b18:	e0a2                	sd	s0,64(sp)
    80002b1a:	fc26                	sd	s1,56(sp)
    80002b1c:	f84a                	sd	s2,48(sp)
    80002b1e:	f44e                	sd	s3,40(sp)
    80002b20:	f052                	sd	s4,32(sp)
    80002b22:	ec56                	sd	s5,24(sp)
    80002b24:	e85a                	sd	s6,16(sp)
    80002b26:	e45e                	sd	s7,8(sp)
    80002b28:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b2a:	00235717          	auipc	a4,0x235
    80002b2e:	a3a72703          	lw	a4,-1478(a4) # 80237564 <sb+0xc>
    80002b32:	4785                	li	a5,1
    80002b34:	04e7fa63          	bgeu	a5,a4,80002b88 <ialloc+0x74>
    80002b38:	8aaa                	mv	s5,a0
    80002b3a:	8bae                	mv	s7,a1
    80002b3c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b3e:	00235a17          	auipc	s4,0x235
    80002b42:	a1aa0a13          	addi	s4,s4,-1510 # 80237558 <sb>
    80002b46:	00048b1b          	sext.w	s6,s1
    80002b4a:	0044d593          	srli	a1,s1,0x4
    80002b4e:	018a2783          	lw	a5,24(s4)
    80002b52:	9dbd                	addw	a1,a1,a5
    80002b54:	8556                	mv	a0,s5
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	954080e7          	jalr	-1708(ra) # 800024aa <bread>
    80002b5e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b60:	05850993          	addi	s3,a0,88
    80002b64:	00f4f793          	andi	a5,s1,15
    80002b68:	079a                	slli	a5,a5,0x6
    80002b6a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b6c:	00099783          	lh	a5,0(s3)
    80002b70:	c785                	beqz	a5,80002b98 <ialloc+0x84>
    brelse(bp);
    80002b72:	00000097          	auipc	ra,0x0
    80002b76:	a68080e7          	jalr	-1432(ra) # 800025da <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b7a:	0485                	addi	s1,s1,1
    80002b7c:	00ca2703          	lw	a4,12(s4)
    80002b80:	0004879b          	sext.w	a5,s1
    80002b84:	fce7e1e3          	bltu	a5,a4,80002b46 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b88:	00006517          	auipc	a0,0x6
    80002b8c:	a9050513          	addi	a0,a0,-1392 # 80008618 <syscalls+0x168>
    80002b90:	00003097          	auipc	ra,0x3
    80002b94:	1c8080e7          	jalr	456(ra) # 80005d58 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b98:	04000613          	li	a2,64
    80002b9c:	4581                	li	a1,0
    80002b9e:	854e                	mv	a0,s3
    80002ba0:	ffffd097          	auipc	ra,0xffffd
    80002ba4:	6d6080e7          	jalr	1750(ra) # 80000276 <memset>
      dip->type = type;
    80002ba8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bac:	854a                	mv	a0,s2
    80002bae:	00001097          	auipc	ra,0x1
    80002bb2:	ca8080e7          	jalr	-856(ra) # 80003856 <log_write>
      brelse(bp);
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	00000097          	auipc	ra,0x0
    80002bbc:	a22080e7          	jalr	-1502(ra) # 800025da <brelse>
      return iget(dev, inum);
    80002bc0:	85da                	mv	a1,s6
    80002bc2:	8556                	mv	a0,s5
    80002bc4:	00000097          	auipc	ra,0x0
    80002bc8:	db4080e7          	jalr	-588(ra) # 80002978 <iget>
}
    80002bcc:	60a6                	ld	ra,72(sp)
    80002bce:	6406                	ld	s0,64(sp)
    80002bd0:	74e2                	ld	s1,56(sp)
    80002bd2:	7942                	ld	s2,48(sp)
    80002bd4:	79a2                	ld	s3,40(sp)
    80002bd6:	7a02                	ld	s4,32(sp)
    80002bd8:	6ae2                	ld	s5,24(sp)
    80002bda:	6b42                	ld	s6,16(sp)
    80002bdc:	6ba2                	ld	s7,8(sp)
    80002bde:	6161                	addi	sp,sp,80
    80002be0:	8082                	ret

0000000080002be2 <iupdate>:
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	e04a                	sd	s2,0(sp)
    80002bec:	1000                	addi	s0,sp,32
    80002bee:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bf0:	415c                	lw	a5,4(a0)
    80002bf2:	0047d79b          	srliw	a5,a5,0x4
    80002bf6:	00235597          	auipc	a1,0x235
    80002bfa:	97a5a583          	lw	a1,-1670(a1) # 80237570 <sb+0x18>
    80002bfe:	9dbd                	addw	a1,a1,a5
    80002c00:	4108                	lw	a0,0(a0)
    80002c02:	00000097          	auipc	ra,0x0
    80002c06:	8a8080e7          	jalr	-1880(ra) # 800024aa <bread>
    80002c0a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c0c:	05850793          	addi	a5,a0,88
    80002c10:	40c8                	lw	a0,4(s1)
    80002c12:	893d                	andi	a0,a0,15
    80002c14:	051a                	slli	a0,a0,0x6
    80002c16:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c18:	04449703          	lh	a4,68(s1)
    80002c1c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c20:	04649703          	lh	a4,70(s1)
    80002c24:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c28:	04849703          	lh	a4,72(s1)
    80002c2c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c30:	04a49703          	lh	a4,74(s1)
    80002c34:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c38:	44f8                	lw	a4,76(s1)
    80002c3a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c3c:	03400613          	li	a2,52
    80002c40:	05048593          	addi	a1,s1,80
    80002c44:	0531                	addi	a0,a0,12
    80002c46:	ffffd097          	auipc	ra,0xffffd
    80002c4a:	690080e7          	jalr	1680(ra) # 800002d6 <memmove>
  log_write(bp);
    80002c4e:	854a                	mv	a0,s2
    80002c50:	00001097          	auipc	ra,0x1
    80002c54:	c06080e7          	jalr	-1018(ra) # 80003856 <log_write>
  brelse(bp);
    80002c58:	854a                	mv	a0,s2
    80002c5a:	00000097          	auipc	ra,0x0
    80002c5e:	980080e7          	jalr	-1664(ra) # 800025da <brelse>
}
    80002c62:	60e2                	ld	ra,24(sp)
    80002c64:	6442                	ld	s0,16(sp)
    80002c66:	64a2                	ld	s1,8(sp)
    80002c68:	6902                	ld	s2,0(sp)
    80002c6a:	6105                	addi	sp,sp,32
    80002c6c:	8082                	ret

0000000080002c6e <idup>:
{
    80002c6e:	1101                	addi	sp,sp,-32
    80002c70:	ec06                	sd	ra,24(sp)
    80002c72:	e822                	sd	s0,16(sp)
    80002c74:	e426                	sd	s1,8(sp)
    80002c76:	1000                	addi	s0,sp,32
    80002c78:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c7a:	00235517          	auipc	a0,0x235
    80002c7e:	8fe50513          	addi	a0,a0,-1794 # 80237578 <itable>
    80002c82:	00003097          	auipc	ra,0x3
    80002c86:	620080e7          	jalr	1568(ra) # 800062a2 <acquire>
  ip->ref++;
    80002c8a:	449c                	lw	a5,8(s1)
    80002c8c:	2785                	addiw	a5,a5,1
    80002c8e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c90:	00235517          	auipc	a0,0x235
    80002c94:	8e850513          	addi	a0,a0,-1816 # 80237578 <itable>
    80002c98:	00003097          	auipc	ra,0x3
    80002c9c:	6be080e7          	jalr	1726(ra) # 80006356 <release>
}
    80002ca0:	8526                	mv	a0,s1
    80002ca2:	60e2                	ld	ra,24(sp)
    80002ca4:	6442                	ld	s0,16(sp)
    80002ca6:	64a2                	ld	s1,8(sp)
    80002ca8:	6105                	addi	sp,sp,32
    80002caa:	8082                	ret

0000000080002cac <ilock>:
{
    80002cac:	1101                	addi	sp,sp,-32
    80002cae:	ec06                	sd	ra,24(sp)
    80002cb0:	e822                	sd	s0,16(sp)
    80002cb2:	e426                	sd	s1,8(sp)
    80002cb4:	e04a                	sd	s2,0(sp)
    80002cb6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cb8:	c115                	beqz	a0,80002cdc <ilock+0x30>
    80002cba:	84aa                	mv	s1,a0
    80002cbc:	451c                	lw	a5,8(a0)
    80002cbe:	00f05f63          	blez	a5,80002cdc <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cc2:	0541                	addi	a0,a0,16
    80002cc4:	00001097          	auipc	ra,0x1
    80002cc8:	cb2080e7          	jalr	-846(ra) # 80003976 <acquiresleep>
  if(ip->valid == 0){
    80002ccc:	40bc                	lw	a5,64(s1)
    80002cce:	cf99                	beqz	a5,80002cec <ilock+0x40>
}
    80002cd0:	60e2                	ld	ra,24(sp)
    80002cd2:	6442                	ld	s0,16(sp)
    80002cd4:	64a2                	ld	s1,8(sp)
    80002cd6:	6902                	ld	s2,0(sp)
    80002cd8:	6105                	addi	sp,sp,32
    80002cda:	8082                	ret
    panic("ilock");
    80002cdc:	00006517          	auipc	a0,0x6
    80002ce0:	95450513          	addi	a0,a0,-1708 # 80008630 <syscalls+0x180>
    80002ce4:	00003097          	auipc	ra,0x3
    80002ce8:	074080e7          	jalr	116(ra) # 80005d58 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cec:	40dc                	lw	a5,4(s1)
    80002cee:	0047d79b          	srliw	a5,a5,0x4
    80002cf2:	00235597          	auipc	a1,0x235
    80002cf6:	87e5a583          	lw	a1,-1922(a1) # 80237570 <sb+0x18>
    80002cfa:	9dbd                	addw	a1,a1,a5
    80002cfc:	4088                	lw	a0,0(s1)
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	7ac080e7          	jalr	1964(ra) # 800024aa <bread>
    80002d06:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d08:	05850593          	addi	a1,a0,88
    80002d0c:	40dc                	lw	a5,4(s1)
    80002d0e:	8bbd                	andi	a5,a5,15
    80002d10:	079a                	slli	a5,a5,0x6
    80002d12:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d14:	00059783          	lh	a5,0(a1)
    80002d18:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d1c:	00259783          	lh	a5,2(a1)
    80002d20:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d24:	00459783          	lh	a5,4(a1)
    80002d28:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d2c:	00659783          	lh	a5,6(a1)
    80002d30:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d34:	459c                	lw	a5,8(a1)
    80002d36:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d38:	03400613          	li	a2,52
    80002d3c:	05b1                	addi	a1,a1,12
    80002d3e:	05048513          	addi	a0,s1,80
    80002d42:	ffffd097          	auipc	ra,0xffffd
    80002d46:	594080e7          	jalr	1428(ra) # 800002d6 <memmove>
    brelse(bp);
    80002d4a:	854a                	mv	a0,s2
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	88e080e7          	jalr	-1906(ra) # 800025da <brelse>
    ip->valid = 1;
    80002d54:	4785                	li	a5,1
    80002d56:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d58:	04449783          	lh	a5,68(s1)
    80002d5c:	fbb5                	bnez	a5,80002cd0 <ilock+0x24>
      panic("ilock: no type");
    80002d5e:	00006517          	auipc	a0,0x6
    80002d62:	8da50513          	addi	a0,a0,-1830 # 80008638 <syscalls+0x188>
    80002d66:	00003097          	auipc	ra,0x3
    80002d6a:	ff2080e7          	jalr	-14(ra) # 80005d58 <panic>

0000000080002d6e <iunlock>:
{
    80002d6e:	1101                	addi	sp,sp,-32
    80002d70:	ec06                	sd	ra,24(sp)
    80002d72:	e822                	sd	s0,16(sp)
    80002d74:	e426                	sd	s1,8(sp)
    80002d76:	e04a                	sd	s2,0(sp)
    80002d78:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d7a:	c905                	beqz	a0,80002daa <iunlock+0x3c>
    80002d7c:	84aa                	mv	s1,a0
    80002d7e:	01050913          	addi	s2,a0,16
    80002d82:	854a                	mv	a0,s2
    80002d84:	00001097          	auipc	ra,0x1
    80002d88:	c8c080e7          	jalr	-884(ra) # 80003a10 <holdingsleep>
    80002d8c:	cd19                	beqz	a0,80002daa <iunlock+0x3c>
    80002d8e:	449c                	lw	a5,8(s1)
    80002d90:	00f05d63          	blez	a5,80002daa <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d94:	854a                	mv	a0,s2
    80002d96:	00001097          	auipc	ra,0x1
    80002d9a:	c36080e7          	jalr	-970(ra) # 800039cc <releasesleep>
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6902                	ld	s2,0(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret
    panic("iunlock");
    80002daa:	00006517          	auipc	a0,0x6
    80002dae:	89e50513          	addi	a0,a0,-1890 # 80008648 <syscalls+0x198>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	fa6080e7          	jalr	-90(ra) # 80005d58 <panic>

0000000080002dba <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dba:	7179                	addi	sp,sp,-48
    80002dbc:	f406                	sd	ra,40(sp)
    80002dbe:	f022                	sd	s0,32(sp)
    80002dc0:	ec26                	sd	s1,24(sp)
    80002dc2:	e84a                	sd	s2,16(sp)
    80002dc4:	e44e                	sd	s3,8(sp)
    80002dc6:	e052                	sd	s4,0(sp)
    80002dc8:	1800                	addi	s0,sp,48
    80002dca:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dcc:	05050493          	addi	s1,a0,80
    80002dd0:	08050913          	addi	s2,a0,128
    80002dd4:	a021                	j	80002ddc <itrunc+0x22>
    80002dd6:	0491                	addi	s1,s1,4
    80002dd8:	01248d63          	beq	s1,s2,80002df2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ddc:	408c                	lw	a1,0(s1)
    80002dde:	dde5                	beqz	a1,80002dd6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002de0:	0009a503          	lw	a0,0(s3)
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	90c080e7          	jalr	-1780(ra) # 800026f0 <bfree>
      ip->addrs[i] = 0;
    80002dec:	0004a023          	sw	zero,0(s1)
    80002df0:	b7dd                	j	80002dd6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002df2:	0809a583          	lw	a1,128(s3)
    80002df6:	e185                	bnez	a1,80002e16 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002df8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dfc:	854e                	mv	a0,s3
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	de4080e7          	jalr	-540(ra) # 80002be2 <iupdate>
}
    80002e06:	70a2                	ld	ra,40(sp)
    80002e08:	7402                	ld	s0,32(sp)
    80002e0a:	64e2                	ld	s1,24(sp)
    80002e0c:	6942                	ld	s2,16(sp)
    80002e0e:	69a2                	ld	s3,8(sp)
    80002e10:	6a02                	ld	s4,0(sp)
    80002e12:	6145                	addi	sp,sp,48
    80002e14:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e16:	0009a503          	lw	a0,0(s3)
    80002e1a:	fffff097          	auipc	ra,0xfffff
    80002e1e:	690080e7          	jalr	1680(ra) # 800024aa <bread>
    80002e22:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e24:	05850493          	addi	s1,a0,88
    80002e28:	45850913          	addi	s2,a0,1112
    80002e2c:	a811                	j	80002e40 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e2e:	0009a503          	lw	a0,0(s3)
    80002e32:	00000097          	auipc	ra,0x0
    80002e36:	8be080e7          	jalr	-1858(ra) # 800026f0 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e3a:	0491                	addi	s1,s1,4
    80002e3c:	01248563          	beq	s1,s2,80002e46 <itrunc+0x8c>
      if(a[j])
    80002e40:	408c                	lw	a1,0(s1)
    80002e42:	dde5                	beqz	a1,80002e3a <itrunc+0x80>
    80002e44:	b7ed                	j	80002e2e <itrunc+0x74>
    brelse(bp);
    80002e46:	8552                	mv	a0,s4
    80002e48:	fffff097          	auipc	ra,0xfffff
    80002e4c:	792080e7          	jalr	1938(ra) # 800025da <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e50:	0809a583          	lw	a1,128(s3)
    80002e54:	0009a503          	lw	a0,0(s3)
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	898080e7          	jalr	-1896(ra) # 800026f0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e60:	0809a023          	sw	zero,128(s3)
    80002e64:	bf51                	j	80002df8 <itrunc+0x3e>

0000000080002e66 <iput>:
{
    80002e66:	1101                	addi	sp,sp,-32
    80002e68:	ec06                	sd	ra,24(sp)
    80002e6a:	e822                	sd	s0,16(sp)
    80002e6c:	e426                	sd	s1,8(sp)
    80002e6e:	e04a                	sd	s2,0(sp)
    80002e70:	1000                	addi	s0,sp,32
    80002e72:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e74:	00234517          	auipc	a0,0x234
    80002e78:	70450513          	addi	a0,a0,1796 # 80237578 <itable>
    80002e7c:	00003097          	auipc	ra,0x3
    80002e80:	426080e7          	jalr	1062(ra) # 800062a2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e84:	4498                	lw	a4,8(s1)
    80002e86:	4785                	li	a5,1
    80002e88:	02f70363          	beq	a4,a5,80002eae <iput+0x48>
  ip->ref--;
    80002e8c:	449c                	lw	a5,8(s1)
    80002e8e:	37fd                	addiw	a5,a5,-1
    80002e90:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e92:	00234517          	auipc	a0,0x234
    80002e96:	6e650513          	addi	a0,a0,1766 # 80237578 <itable>
    80002e9a:	00003097          	auipc	ra,0x3
    80002e9e:	4bc080e7          	jalr	1212(ra) # 80006356 <release>
}
    80002ea2:	60e2                	ld	ra,24(sp)
    80002ea4:	6442                	ld	s0,16(sp)
    80002ea6:	64a2                	ld	s1,8(sp)
    80002ea8:	6902                	ld	s2,0(sp)
    80002eaa:	6105                	addi	sp,sp,32
    80002eac:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eae:	40bc                	lw	a5,64(s1)
    80002eb0:	dff1                	beqz	a5,80002e8c <iput+0x26>
    80002eb2:	04a49783          	lh	a5,74(s1)
    80002eb6:	fbf9                	bnez	a5,80002e8c <iput+0x26>
    acquiresleep(&ip->lock);
    80002eb8:	01048913          	addi	s2,s1,16
    80002ebc:	854a                	mv	a0,s2
    80002ebe:	00001097          	auipc	ra,0x1
    80002ec2:	ab8080e7          	jalr	-1352(ra) # 80003976 <acquiresleep>
    release(&itable.lock);
    80002ec6:	00234517          	auipc	a0,0x234
    80002eca:	6b250513          	addi	a0,a0,1714 # 80237578 <itable>
    80002ece:	00003097          	auipc	ra,0x3
    80002ed2:	488080e7          	jalr	1160(ra) # 80006356 <release>
    itrunc(ip);
    80002ed6:	8526                	mv	a0,s1
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	ee2080e7          	jalr	-286(ra) # 80002dba <itrunc>
    ip->type = 0;
    80002ee0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ee4:	8526                	mv	a0,s1
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	cfc080e7          	jalr	-772(ra) # 80002be2 <iupdate>
    ip->valid = 0;
    80002eee:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ef2:	854a                	mv	a0,s2
    80002ef4:	00001097          	auipc	ra,0x1
    80002ef8:	ad8080e7          	jalr	-1320(ra) # 800039cc <releasesleep>
    acquire(&itable.lock);
    80002efc:	00234517          	auipc	a0,0x234
    80002f00:	67c50513          	addi	a0,a0,1660 # 80237578 <itable>
    80002f04:	00003097          	auipc	ra,0x3
    80002f08:	39e080e7          	jalr	926(ra) # 800062a2 <acquire>
    80002f0c:	b741                	j	80002e8c <iput+0x26>

0000000080002f0e <iunlockput>:
{
    80002f0e:	1101                	addi	sp,sp,-32
    80002f10:	ec06                	sd	ra,24(sp)
    80002f12:	e822                	sd	s0,16(sp)
    80002f14:	e426                	sd	s1,8(sp)
    80002f16:	1000                	addi	s0,sp,32
    80002f18:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f1a:	00000097          	auipc	ra,0x0
    80002f1e:	e54080e7          	jalr	-428(ra) # 80002d6e <iunlock>
  iput(ip);
    80002f22:	8526                	mv	a0,s1
    80002f24:	00000097          	auipc	ra,0x0
    80002f28:	f42080e7          	jalr	-190(ra) # 80002e66 <iput>
}
    80002f2c:	60e2                	ld	ra,24(sp)
    80002f2e:	6442                	ld	s0,16(sp)
    80002f30:	64a2                	ld	s1,8(sp)
    80002f32:	6105                	addi	sp,sp,32
    80002f34:	8082                	ret

0000000080002f36 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f36:	1141                	addi	sp,sp,-16
    80002f38:	e422                	sd	s0,8(sp)
    80002f3a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f3c:	411c                	lw	a5,0(a0)
    80002f3e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f40:	415c                	lw	a5,4(a0)
    80002f42:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f44:	04451783          	lh	a5,68(a0)
    80002f48:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f4c:	04a51783          	lh	a5,74(a0)
    80002f50:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f54:	04c56783          	lwu	a5,76(a0)
    80002f58:	e99c                	sd	a5,16(a1)
}
    80002f5a:	6422                	ld	s0,8(sp)
    80002f5c:	0141                	addi	sp,sp,16
    80002f5e:	8082                	ret

0000000080002f60 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f60:	457c                	lw	a5,76(a0)
    80002f62:	0ed7e963          	bltu	a5,a3,80003054 <readi+0xf4>
{
    80002f66:	7159                	addi	sp,sp,-112
    80002f68:	f486                	sd	ra,104(sp)
    80002f6a:	f0a2                	sd	s0,96(sp)
    80002f6c:	eca6                	sd	s1,88(sp)
    80002f6e:	e8ca                	sd	s2,80(sp)
    80002f70:	e4ce                	sd	s3,72(sp)
    80002f72:	e0d2                	sd	s4,64(sp)
    80002f74:	fc56                	sd	s5,56(sp)
    80002f76:	f85a                	sd	s6,48(sp)
    80002f78:	f45e                	sd	s7,40(sp)
    80002f7a:	f062                	sd	s8,32(sp)
    80002f7c:	ec66                	sd	s9,24(sp)
    80002f7e:	e86a                	sd	s10,16(sp)
    80002f80:	e46e                	sd	s11,8(sp)
    80002f82:	1880                	addi	s0,sp,112
    80002f84:	8baa                	mv	s7,a0
    80002f86:	8c2e                	mv	s8,a1
    80002f88:	8ab2                	mv	s5,a2
    80002f8a:	84b6                	mv	s1,a3
    80002f8c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f8e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f90:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f92:	0ad76063          	bltu	a4,a3,80003032 <readi+0xd2>
  if(off + n > ip->size)
    80002f96:	00e7f463          	bgeu	a5,a4,80002f9e <readi+0x3e>
    n = ip->size - off;
    80002f9a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f9e:	0a0b0963          	beqz	s6,80003050 <readi+0xf0>
    80002fa2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fa8:	5cfd                	li	s9,-1
    80002faa:	a82d                	j	80002fe4 <readi+0x84>
    80002fac:	020a1d93          	slli	s11,s4,0x20
    80002fb0:	020ddd93          	srli	s11,s11,0x20
    80002fb4:	05890613          	addi	a2,s2,88
    80002fb8:	86ee                	mv	a3,s11
    80002fba:	963a                	add	a2,a2,a4
    80002fbc:	85d6                	mv	a1,s5
    80002fbe:	8562                	mv	a0,s8
    80002fc0:	fffff097          	auipc	ra,0xfffff
    80002fc4:	b0a080e7          	jalr	-1270(ra) # 80001aca <either_copyout>
    80002fc8:	05950d63          	beq	a0,s9,80003022 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fcc:	854a                	mv	a0,s2
    80002fce:	fffff097          	auipc	ra,0xfffff
    80002fd2:	60c080e7          	jalr	1548(ra) # 800025da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fd6:	013a09bb          	addw	s3,s4,s3
    80002fda:	009a04bb          	addw	s1,s4,s1
    80002fde:	9aee                	add	s5,s5,s11
    80002fe0:	0569f763          	bgeu	s3,s6,8000302e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fe4:	000ba903          	lw	s2,0(s7)
    80002fe8:	00a4d59b          	srliw	a1,s1,0xa
    80002fec:	855e                	mv	a0,s7
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	8b0080e7          	jalr	-1872(ra) # 8000289e <bmap>
    80002ff6:	0005059b          	sext.w	a1,a0
    80002ffa:	854a                	mv	a0,s2
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	4ae080e7          	jalr	1198(ra) # 800024aa <bread>
    80003004:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003006:	3ff4f713          	andi	a4,s1,1023
    8000300a:	40ed07bb          	subw	a5,s10,a4
    8000300e:	413b06bb          	subw	a3,s6,s3
    80003012:	8a3e                	mv	s4,a5
    80003014:	2781                	sext.w	a5,a5
    80003016:	0006861b          	sext.w	a2,a3
    8000301a:	f8f679e3          	bgeu	a2,a5,80002fac <readi+0x4c>
    8000301e:	8a36                	mv	s4,a3
    80003020:	b771                	j	80002fac <readi+0x4c>
      brelse(bp);
    80003022:	854a                	mv	a0,s2
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	5b6080e7          	jalr	1462(ra) # 800025da <brelse>
      tot = -1;
    8000302c:	59fd                	li	s3,-1
  }
  return tot;
    8000302e:	0009851b          	sext.w	a0,s3
}
    80003032:	70a6                	ld	ra,104(sp)
    80003034:	7406                	ld	s0,96(sp)
    80003036:	64e6                	ld	s1,88(sp)
    80003038:	6946                	ld	s2,80(sp)
    8000303a:	69a6                	ld	s3,72(sp)
    8000303c:	6a06                	ld	s4,64(sp)
    8000303e:	7ae2                	ld	s5,56(sp)
    80003040:	7b42                	ld	s6,48(sp)
    80003042:	7ba2                	ld	s7,40(sp)
    80003044:	7c02                	ld	s8,32(sp)
    80003046:	6ce2                	ld	s9,24(sp)
    80003048:	6d42                	ld	s10,16(sp)
    8000304a:	6da2                	ld	s11,8(sp)
    8000304c:	6165                	addi	sp,sp,112
    8000304e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003050:	89da                	mv	s3,s6
    80003052:	bff1                	j	8000302e <readi+0xce>
    return 0;
    80003054:	4501                	li	a0,0
}
    80003056:	8082                	ret

0000000080003058 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003058:	457c                	lw	a5,76(a0)
    8000305a:	10d7e863          	bltu	a5,a3,8000316a <writei+0x112>
{
    8000305e:	7159                	addi	sp,sp,-112
    80003060:	f486                	sd	ra,104(sp)
    80003062:	f0a2                	sd	s0,96(sp)
    80003064:	eca6                	sd	s1,88(sp)
    80003066:	e8ca                	sd	s2,80(sp)
    80003068:	e4ce                	sd	s3,72(sp)
    8000306a:	e0d2                	sd	s4,64(sp)
    8000306c:	fc56                	sd	s5,56(sp)
    8000306e:	f85a                	sd	s6,48(sp)
    80003070:	f45e                	sd	s7,40(sp)
    80003072:	f062                	sd	s8,32(sp)
    80003074:	ec66                	sd	s9,24(sp)
    80003076:	e86a                	sd	s10,16(sp)
    80003078:	e46e                	sd	s11,8(sp)
    8000307a:	1880                	addi	s0,sp,112
    8000307c:	8b2a                	mv	s6,a0
    8000307e:	8c2e                	mv	s8,a1
    80003080:	8ab2                	mv	s5,a2
    80003082:	8936                	mv	s2,a3
    80003084:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003086:	00e687bb          	addw	a5,a3,a4
    8000308a:	0ed7e263          	bltu	a5,a3,8000316e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000308e:	00043737          	lui	a4,0x43
    80003092:	0ef76063          	bltu	a4,a5,80003172 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003096:	0c0b8863          	beqz	s7,80003166 <writei+0x10e>
    8000309a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000309c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030a0:	5cfd                	li	s9,-1
    800030a2:	a091                	j	800030e6 <writei+0x8e>
    800030a4:	02099d93          	slli	s11,s3,0x20
    800030a8:	020ddd93          	srli	s11,s11,0x20
    800030ac:	05848513          	addi	a0,s1,88
    800030b0:	86ee                	mv	a3,s11
    800030b2:	8656                	mv	a2,s5
    800030b4:	85e2                	mv	a1,s8
    800030b6:	953a                	add	a0,a0,a4
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	a68080e7          	jalr	-1432(ra) # 80001b20 <either_copyin>
    800030c0:	07950263          	beq	a0,s9,80003124 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030c4:	8526                	mv	a0,s1
    800030c6:	00000097          	auipc	ra,0x0
    800030ca:	790080e7          	jalr	1936(ra) # 80003856 <log_write>
    brelse(bp);
    800030ce:	8526                	mv	a0,s1
    800030d0:	fffff097          	auipc	ra,0xfffff
    800030d4:	50a080e7          	jalr	1290(ra) # 800025da <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030d8:	01498a3b          	addw	s4,s3,s4
    800030dc:	0129893b          	addw	s2,s3,s2
    800030e0:	9aee                	add	s5,s5,s11
    800030e2:	057a7663          	bgeu	s4,s7,8000312e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030e6:	000b2483          	lw	s1,0(s6)
    800030ea:	00a9559b          	srliw	a1,s2,0xa
    800030ee:	855a                	mv	a0,s6
    800030f0:	fffff097          	auipc	ra,0xfffff
    800030f4:	7ae080e7          	jalr	1966(ra) # 8000289e <bmap>
    800030f8:	0005059b          	sext.w	a1,a0
    800030fc:	8526                	mv	a0,s1
    800030fe:	fffff097          	auipc	ra,0xfffff
    80003102:	3ac080e7          	jalr	940(ra) # 800024aa <bread>
    80003106:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003108:	3ff97713          	andi	a4,s2,1023
    8000310c:	40ed07bb          	subw	a5,s10,a4
    80003110:	414b86bb          	subw	a3,s7,s4
    80003114:	89be                	mv	s3,a5
    80003116:	2781                	sext.w	a5,a5
    80003118:	0006861b          	sext.w	a2,a3
    8000311c:	f8f674e3          	bgeu	a2,a5,800030a4 <writei+0x4c>
    80003120:	89b6                	mv	s3,a3
    80003122:	b749                	j	800030a4 <writei+0x4c>
      brelse(bp);
    80003124:	8526                	mv	a0,s1
    80003126:	fffff097          	auipc	ra,0xfffff
    8000312a:	4b4080e7          	jalr	1204(ra) # 800025da <brelse>
  }

  if(off > ip->size)
    8000312e:	04cb2783          	lw	a5,76(s6)
    80003132:	0127f463          	bgeu	a5,s2,8000313a <writei+0xe2>
    ip->size = off;
    80003136:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000313a:	855a                	mv	a0,s6
    8000313c:	00000097          	auipc	ra,0x0
    80003140:	aa6080e7          	jalr	-1370(ra) # 80002be2 <iupdate>

  return tot;
    80003144:	000a051b          	sext.w	a0,s4
}
    80003148:	70a6                	ld	ra,104(sp)
    8000314a:	7406                	ld	s0,96(sp)
    8000314c:	64e6                	ld	s1,88(sp)
    8000314e:	6946                	ld	s2,80(sp)
    80003150:	69a6                	ld	s3,72(sp)
    80003152:	6a06                	ld	s4,64(sp)
    80003154:	7ae2                	ld	s5,56(sp)
    80003156:	7b42                	ld	s6,48(sp)
    80003158:	7ba2                	ld	s7,40(sp)
    8000315a:	7c02                	ld	s8,32(sp)
    8000315c:	6ce2                	ld	s9,24(sp)
    8000315e:	6d42                	ld	s10,16(sp)
    80003160:	6da2                	ld	s11,8(sp)
    80003162:	6165                	addi	sp,sp,112
    80003164:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003166:	8a5e                	mv	s4,s7
    80003168:	bfc9                	j	8000313a <writei+0xe2>
    return -1;
    8000316a:	557d                	li	a0,-1
}
    8000316c:	8082                	ret
    return -1;
    8000316e:	557d                	li	a0,-1
    80003170:	bfe1                	j	80003148 <writei+0xf0>
    return -1;
    80003172:	557d                	li	a0,-1
    80003174:	bfd1                	j	80003148 <writei+0xf0>

0000000080003176 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003176:	1141                	addi	sp,sp,-16
    80003178:	e406                	sd	ra,8(sp)
    8000317a:	e022                	sd	s0,0(sp)
    8000317c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000317e:	4639                	li	a2,14
    80003180:	ffffd097          	auipc	ra,0xffffd
    80003184:	1ce080e7          	jalr	462(ra) # 8000034e <strncmp>
}
    80003188:	60a2                	ld	ra,8(sp)
    8000318a:	6402                	ld	s0,0(sp)
    8000318c:	0141                	addi	sp,sp,16
    8000318e:	8082                	ret

0000000080003190 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003190:	7139                	addi	sp,sp,-64
    80003192:	fc06                	sd	ra,56(sp)
    80003194:	f822                	sd	s0,48(sp)
    80003196:	f426                	sd	s1,40(sp)
    80003198:	f04a                	sd	s2,32(sp)
    8000319a:	ec4e                	sd	s3,24(sp)
    8000319c:	e852                	sd	s4,16(sp)
    8000319e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031a0:	04451703          	lh	a4,68(a0)
    800031a4:	4785                	li	a5,1
    800031a6:	00f71a63          	bne	a4,a5,800031ba <dirlookup+0x2a>
    800031aa:	892a                	mv	s2,a0
    800031ac:	89ae                	mv	s3,a1
    800031ae:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b0:	457c                	lw	a5,76(a0)
    800031b2:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031b4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b6:	e79d                	bnez	a5,800031e4 <dirlookup+0x54>
    800031b8:	a8a5                	j	80003230 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031ba:	00005517          	auipc	a0,0x5
    800031be:	49650513          	addi	a0,a0,1174 # 80008650 <syscalls+0x1a0>
    800031c2:	00003097          	auipc	ra,0x3
    800031c6:	b96080e7          	jalr	-1130(ra) # 80005d58 <panic>
      panic("dirlookup read");
    800031ca:	00005517          	auipc	a0,0x5
    800031ce:	49e50513          	addi	a0,a0,1182 # 80008668 <syscalls+0x1b8>
    800031d2:	00003097          	auipc	ra,0x3
    800031d6:	b86080e7          	jalr	-1146(ra) # 80005d58 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031da:	24c1                	addiw	s1,s1,16
    800031dc:	04c92783          	lw	a5,76(s2)
    800031e0:	04f4f763          	bgeu	s1,a5,8000322e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031e4:	4741                	li	a4,16
    800031e6:	86a6                	mv	a3,s1
    800031e8:	fc040613          	addi	a2,s0,-64
    800031ec:	4581                	li	a1,0
    800031ee:	854a                	mv	a0,s2
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	d70080e7          	jalr	-656(ra) # 80002f60 <readi>
    800031f8:	47c1                	li	a5,16
    800031fa:	fcf518e3          	bne	a0,a5,800031ca <dirlookup+0x3a>
    if(de.inum == 0)
    800031fe:	fc045783          	lhu	a5,-64(s0)
    80003202:	dfe1                	beqz	a5,800031da <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003204:	fc240593          	addi	a1,s0,-62
    80003208:	854e                	mv	a0,s3
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	f6c080e7          	jalr	-148(ra) # 80003176 <namecmp>
    80003212:	f561                	bnez	a0,800031da <dirlookup+0x4a>
      if(poff)
    80003214:	000a0463          	beqz	s4,8000321c <dirlookup+0x8c>
        *poff = off;
    80003218:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000321c:	fc045583          	lhu	a1,-64(s0)
    80003220:	00092503          	lw	a0,0(s2)
    80003224:	fffff097          	auipc	ra,0xfffff
    80003228:	754080e7          	jalr	1876(ra) # 80002978 <iget>
    8000322c:	a011                	j	80003230 <dirlookup+0xa0>
  return 0;
    8000322e:	4501                	li	a0,0
}
    80003230:	70e2                	ld	ra,56(sp)
    80003232:	7442                	ld	s0,48(sp)
    80003234:	74a2                	ld	s1,40(sp)
    80003236:	7902                	ld	s2,32(sp)
    80003238:	69e2                	ld	s3,24(sp)
    8000323a:	6a42                	ld	s4,16(sp)
    8000323c:	6121                	addi	sp,sp,64
    8000323e:	8082                	ret

0000000080003240 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003240:	711d                	addi	sp,sp,-96
    80003242:	ec86                	sd	ra,88(sp)
    80003244:	e8a2                	sd	s0,80(sp)
    80003246:	e4a6                	sd	s1,72(sp)
    80003248:	e0ca                	sd	s2,64(sp)
    8000324a:	fc4e                	sd	s3,56(sp)
    8000324c:	f852                	sd	s4,48(sp)
    8000324e:	f456                	sd	s5,40(sp)
    80003250:	f05a                	sd	s6,32(sp)
    80003252:	ec5e                	sd	s7,24(sp)
    80003254:	e862                	sd	s8,16(sp)
    80003256:	e466                	sd	s9,8(sp)
    80003258:	1080                	addi	s0,sp,96
    8000325a:	84aa                	mv	s1,a0
    8000325c:	8b2e                	mv	s6,a1
    8000325e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003260:	00054703          	lbu	a4,0(a0)
    80003264:	02f00793          	li	a5,47
    80003268:	02f70363          	beq	a4,a5,8000328e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000326c:	ffffe097          	auipc	ra,0xffffe
    80003270:	dfe080e7          	jalr	-514(ra) # 8000106a <myproc>
    80003274:	15053503          	ld	a0,336(a0)
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	9f6080e7          	jalr	-1546(ra) # 80002c6e <idup>
    80003280:	89aa                	mv	s3,a0
  while(*path == '/')
    80003282:	02f00913          	li	s2,47
  len = path - s;
    80003286:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003288:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000328a:	4c05                	li	s8,1
    8000328c:	a865                	j	80003344 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000328e:	4585                	li	a1,1
    80003290:	4505                	li	a0,1
    80003292:	fffff097          	auipc	ra,0xfffff
    80003296:	6e6080e7          	jalr	1766(ra) # 80002978 <iget>
    8000329a:	89aa                	mv	s3,a0
    8000329c:	b7dd                	j	80003282 <namex+0x42>
      iunlockput(ip);
    8000329e:	854e                	mv	a0,s3
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	c6e080e7          	jalr	-914(ra) # 80002f0e <iunlockput>
      return 0;
    800032a8:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032aa:	854e                	mv	a0,s3
    800032ac:	60e6                	ld	ra,88(sp)
    800032ae:	6446                	ld	s0,80(sp)
    800032b0:	64a6                	ld	s1,72(sp)
    800032b2:	6906                	ld	s2,64(sp)
    800032b4:	79e2                	ld	s3,56(sp)
    800032b6:	7a42                	ld	s4,48(sp)
    800032b8:	7aa2                	ld	s5,40(sp)
    800032ba:	7b02                	ld	s6,32(sp)
    800032bc:	6be2                	ld	s7,24(sp)
    800032be:	6c42                	ld	s8,16(sp)
    800032c0:	6ca2                	ld	s9,8(sp)
    800032c2:	6125                	addi	sp,sp,96
    800032c4:	8082                	ret
      iunlock(ip);
    800032c6:	854e                	mv	a0,s3
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	aa6080e7          	jalr	-1370(ra) # 80002d6e <iunlock>
      return ip;
    800032d0:	bfe9                	j	800032aa <namex+0x6a>
      iunlockput(ip);
    800032d2:	854e                	mv	a0,s3
    800032d4:	00000097          	auipc	ra,0x0
    800032d8:	c3a080e7          	jalr	-966(ra) # 80002f0e <iunlockput>
      return 0;
    800032dc:	89d2                	mv	s3,s4
    800032de:	b7f1                	j	800032aa <namex+0x6a>
  len = path - s;
    800032e0:	40b48633          	sub	a2,s1,a1
    800032e4:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032e8:	094cd463          	bge	s9,s4,80003370 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032ec:	4639                	li	a2,14
    800032ee:	8556                	mv	a0,s5
    800032f0:	ffffd097          	auipc	ra,0xffffd
    800032f4:	fe6080e7          	jalr	-26(ra) # 800002d6 <memmove>
  while(*path == '/')
    800032f8:	0004c783          	lbu	a5,0(s1)
    800032fc:	01279763          	bne	a5,s2,8000330a <namex+0xca>
    path++;
    80003300:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003302:	0004c783          	lbu	a5,0(s1)
    80003306:	ff278de3          	beq	a5,s2,80003300 <namex+0xc0>
    ilock(ip);
    8000330a:	854e                	mv	a0,s3
    8000330c:	00000097          	auipc	ra,0x0
    80003310:	9a0080e7          	jalr	-1632(ra) # 80002cac <ilock>
    if(ip->type != T_DIR){
    80003314:	04499783          	lh	a5,68(s3)
    80003318:	f98793e3          	bne	a5,s8,8000329e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000331c:	000b0563          	beqz	s6,80003326 <namex+0xe6>
    80003320:	0004c783          	lbu	a5,0(s1)
    80003324:	d3cd                	beqz	a5,800032c6 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003326:	865e                	mv	a2,s7
    80003328:	85d6                	mv	a1,s5
    8000332a:	854e                	mv	a0,s3
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	e64080e7          	jalr	-412(ra) # 80003190 <dirlookup>
    80003334:	8a2a                	mv	s4,a0
    80003336:	dd51                	beqz	a0,800032d2 <namex+0x92>
    iunlockput(ip);
    80003338:	854e                	mv	a0,s3
    8000333a:	00000097          	auipc	ra,0x0
    8000333e:	bd4080e7          	jalr	-1068(ra) # 80002f0e <iunlockput>
    ip = next;
    80003342:	89d2                	mv	s3,s4
  while(*path == '/')
    80003344:	0004c783          	lbu	a5,0(s1)
    80003348:	05279763          	bne	a5,s2,80003396 <namex+0x156>
    path++;
    8000334c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000334e:	0004c783          	lbu	a5,0(s1)
    80003352:	ff278de3          	beq	a5,s2,8000334c <namex+0x10c>
  if(*path == 0)
    80003356:	c79d                	beqz	a5,80003384 <namex+0x144>
    path++;
    80003358:	85a6                	mv	a1,s1
  len = path - s;
    8000335a:	8a5e                	mv	s4,s7
    8000335c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000335e:	01278963          	beq	a5,s2,80003370 <namex+0x130>
    80003362:	dfbd                	beqz	a5,800032e0 <namex+0xa0>
    path++;
    80003364:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003366:	0004c783          	lbu	a5,0(s1)
    8000336a:	ff279ce3          	bne	a5,s2,80003362 <namex+0x122>
    8000336e:	bf8d                	j	800032e0 <namex+0xa0>
    memmove(name, s, len);
    80003370:	2601                	sext.w	a2,a2
    80003372:	8556                	mv	a0,s5
    80003374:	ffffd097          	auipc	ra,0xffffd
    80003378:	f62080e7          	jalr	-158(ra) # 800002d6 <memmove>
    name[len] = 0;
    8000337c:	9a56                	add	s4,s4,s5
    8000337e:	000a0023          	sb	zero,0(s4)
    80003382:	bf9d                	j	800032f8 <namex+0xb8>
  if(nameiparent){
    80003384:	f20b03e3          	beqz	s6,800032aa <namex+0x6a>
    iput(ip);
    80003388:	854e                	mv	a0,s3
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	adc080e7          	jalr	-1316(ra) # 80002e66 <iput>
    return 0;
    80003392:	4981                	li	s3,0
    80003394:	bf19                	j	800032aa <namex+0x6a>
  if(*path == 0)
    80003396:	d7fd                	beqz	a5,80003384 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003398:	0004c783          	lbu	a5,0(s1)
    8000339c:	85a6                	mv	a1,s1
    8000339e:	b7d1                	j	80003362 <namex+0x122>

00000000800033a0 <dirlink>:
{
    800033a0:	7139                	addi	sp,sp,-64
    800033a2:	fc06                	sd	ra,56(sp)
    800033a4:	f822                	sd	s0,48(sp)
    800033a6:	f426                	sd	s1,40(sp)
    800033a8:	f04a                	sd	s2,32(sp)
    800033aa:	ec4e                	sd	s3,24(sp)
    800033ac:	e852                	sd	s4,16(sp)
    800033ae:	0080                	addi	s0,sp,64
    800033b0:	892a                	mv	s2,a0
    800033b2:	8a2e                	mv	s4,a1
    800033b4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033b6:	4601                	li	a2,0
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	dd8080e7          	jalr	-552(ra) # 80003190 <dirlookup>
    800033c0:	e93d                	bnez	a0,80003436 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033c2:	04c92483          	lw	s1,76(s2)
    800033c6:	c49d                	beqz	s1,800033f4 <dirlink+0x54>
    800033c8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ca:	4741                	li	a4,16
    800033cc:	86a6                	mv	a3,s1
    800033ce:	fc040613          	addi	a2,s0,-64
    800033d2:	4581                	li	a1,0
    800033d4:	854a                	mv	a0,s2
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	b8a080e7          	jalr	-1142(ra) # 80002f60 <readi>
    800033de:	47c1                	li	a5,16
    800033e0:	06f51163          	bne	a0,a5,80003442 <dirlink+0xa2>
    if(de.inum == 0)
    800033e4:	fc045783          	lhu	a5,-64(s0)
    800033e8:	c791                	beqz	a5,800033f4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ea:	24c1                	addiw	s1,s1,16
    800033ec:	04c92783          	lw	a5,76(s2)
    800033f0:	fcf4ede3          	bltu	s1,a5,800033ca <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033f4:	4639                	li	a2,14
    800033f6:	85d2                	mv	a1,s4
    800033f8:	fc240513          	addi	a0,s0,-62
    800033fc:	ffffd097          	auipc	ra,0xffffd
    80003400:	f8e080e7          	jalr	-114(ra) # 8000038a <strncpy>
  de.inum = inum;
    80003404:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003408:	4741                	li	a4,16
    8000340a:	86a6                	mv	a3,s1
    8000340c:	fc040613          	addi	a2,s0,-64
    80003410:	4581                	li	a1,0
    80003412:	854a                	mv	a0,s2
    80003414:	00000097          	auipc	ra,0x0
    80003418:	c44080e7          	jalr	-956(ra) # 80003058 <writei>
    8000341c:	872a                	mv	a4,a0
    8000341e:	47c1                	li	a5,16
  return 0;
    80003420:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003422:	02f71863          	bne	a4,a5,80003452 <dirlink+0xb2>
}
    80003426:	70e2                	ld	ra,56(sp)
    80003428:	7442                	ld	s0,48(sp)
    8000342a:	74a2                	ld	s1,40(sp)
    8000342c:	7902                	ld	s2,32(sp)
    8000342e:	69e2                	ld	s3,24(sp)
    80003430:	6a42                	ld	s4,16(sp)
    80003432:	6121                	addi	sp,sp,64
    80003434:	8082                	ret
    iput(ip);
    80003436:	00000097          	auipc	ra,0x0
    8000343a:	a30080e7          	jalr	-1488(ra) # 80002e66 <iput>
    return -1;
    8000343e:	557d                	li	a0,-1
    80003440:	b7dd                	j	80003426 <dirlink+0x86>
      panic("dirlink read");
    80003442:	00005517          	auipc	a0,0x5
    80003446:	23650513          	addi	a0,a0,566 # 80008678 <syscalls+0x1c8>
    8000344a:	00003097          	auipc	ra,0x3
    8000344e:	90e080e7          	jalr	-1778(ra) # 80005d58 <panic>
    panic("dirlink");
    80003452:	00005517          	auipc	a0,0x5
    80003456:	33650513          	addi	a0,a0,822 # 80008788 <syscalls+0x2d8>
    8000345a:	00003097          	auipc	ra,0x3
    8000345e:	8fe080e7          	jalr	-1794(ra) # 80005d58 <panic>

0000000080003462 <namei>:

struct inode*
namei(char *path)
{
    80003462:	1101                	addi	sp,sp,-32
    80003464:	ec06                	sd	ra,24(sp)
    80003466:	e822                	sd	s0,16(sp)
    80003468:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000346a:	fe040613          	addi	a2,s0,-32
    8000346e:	4581                	li	a1,0
    80003470:	00000097          	auipc	ra,0x0
    80003474:	dd0080e7          	jalr	-560(ra) # 80003240 <namex>
}
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret

0000000080003480 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003480:	1141                	addi	sp,sp,-16
    80003482:	e406                	sd	ra,8(sp)
    80003484:	e022                	sd	s0,0(sp)
    80003486:	0800                	addi	s0,sp,16
    80003488:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000348a:	4585                	li	a1,1
    8000348c:	00000097          	auipc	ra,0x0
    80003490:	db4080e7          	jalr	-588(ra) # 80003240 <namex>
}
    80003494:	60a2                	ld	ra,8(sp)
    80003496:	6402                	ld	s0,0(sp)
    80003498:	0141                	addi	sp,sp,16
    8000349a:	8082                	ret

000000008000349c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000349c:	1101                	addi	sp,sp,-32
    8000349e:	ec06                	sd	ra,24(sp)
    800034a0:	e822                	sd	s0,16(sp)
    800034a2:	e426                	sd	s1,8(sp)
    800034a4:	e04a                	sd	s2,0(sp)
    800034a6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034a8:	00236917          	auipc	s2,0x236
    800034ac:	b7890913          	addi	s2,s2,-1160 # 80239020 <log>
    800034b0:	01892583          	lw	a1,24(s2)
    800034b4:	02892503          	lw	a0,40(s2)
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	ff2080e7          	jalr	-14(ra) # 800024aa <bread>
    800034c0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034c2:	02c92683          	lw	a3,44(s2)
    800034c6:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034c8:	02d05763          	blez	a3,800034f6 <write_head+0x5a>
    800034cc:	00236797          	auipc	a5,0x236
    800034d0:	b8478793          	addi	a5,a5,-1148 # 80239050 <log+0x30>
    800034d4:	05c50713          	addi	a4,a0,92
    800034d8:	36fd                	addiw	a3,a3,-1
    800034da:	1682                	slli	a3,a3,0x20
    800034dc:	9281                	srli	a3,a3,0x20
    800034de:	068a                	slli	a3,a3,0x2
    800034e0:	00236617          	auipc	a2,0x236
    800034e4:	b7460613          	addi	a2,a2,-1164 # 80239054 <log+0x34>
    800034e8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034ea:	4390                	lw	a2,0(a5)
    800034ec:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034ee:	0791                	addi	a5,a5,4
    800034f0:	0711                	addi	a4,a4,4
    800034f2:	fed79ce3          	bne	a5,a3,800034ea <write_head+0x4e>
  }
  bwrite(buf);
    800034f6:	8526                	mv	a0,s1
    800034f8:	fffff097          	auipc	ra,0xfffff
    800034fc:	0a4080e7          	jalr	164(ra) # 8000259c <bwrite>
  brelse(buf);
    80003500:	8526                	mv	a0,s1
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	0d8080e7          	jalr	216(ra) # 800025da <brelse>
}
    8000350a:	60e2                	ld	ra,24(sp)
    8000350c:	6442                	ld	s0,16(sp)
    8000350e:	64a2                	ld	s1,8(sp)
    80003510:	6902                	ld	s2,0(sp)
    80003512:	6105                	addi	sp,sp,32
    80003514:	8082                	ret

0000000080003516 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003516:	00236797          	auipc	a5,0x236
    8000351a:	b367a783          	lw	a5,-1226(a5) # 8023904c <log+0x2c>
    8000351e:	0af05d63          	blez	a5,800035d8 <install_trans+0xc2>
{
    80003522:	7139                	addi	sp,sp,-64
    80003524:	fc06                	sd	ra,56(sp)
    80003526:	f822                	sd	s0,48(sp)
    80003528:	f426                	sd	s1,40(sp)
    8000352a:	f04a                	sd	s2,32(sp)
    8000352c:	ec4e                	sd	s3,24(sp)
    8000352e:	e852                	sd	s4,16(sp)
    80003530:	e456                	sd	s5,8(sp)
    80003532:	e05a                	sd	s6,0(sp)
    80003534:	0080                	addi	s0,sp,64
    80003536:	8b2a                	mv	s6,a0
    80003538:	00236a97          	auipc	s5,0x236
    8000353c:	b18a8a93          	addi	s5,s5,-1256 # 80239050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003540:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003542:	00236997          	auipc	s3,0x236
    80003546:	ade98993          	addi	s3,s3,-1314 # 80239020 <log>
    8000354a:	a035                	j	80003576 <install_trans+0x60>
      bunpin(dbuf);
    8000354c:	8526                	mv	a0,s1
    8000354e:	fffff097          	auipc	ra,0xfffff
    80003552:	166080e7          	jalr	358(ra) # 800026b4 <bunpin>
    brelse(lbuf);
    80003556:	854a                	mv	a0,s2
    80003558:	fffff097          	auipc	ra,0xfffff
    8000355c:	082080e7          	jalr	130(ra) # 800025da <brelse>
    brelse(dbuf);
    80003560:	8526                	mv	a0,s1
    80003562:	fffff097          	auipc	ra,0xfffff
    80003566:	078080e7          	jalr	120(ra) # 800025da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000356a:	2a05                	addiw	s4,s4,1
    8000356c:	0a91                	addi	s5,s5,4
    8000356e:	02c9a783          	lw	a5,44(s3)
    80003572:	04fa5963          	bge	s4,a5,800035c4 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003576:	0189a583          	lw	a1,24(s3)
    8000357a:	014585bb          	addw	a1,a1,s4
    8000357e:	2585                	addiw	a1,a1,1
    80003580:	0289a503          	lw	a0,40(s3)
    80003584:	fffff097          	auipc	ra,0xfffff
    80003588:	f26080e7          	jalr	-218(ra) # 800024aa <bread>
    8000358c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000358e:	000aa583          	lw	a1,0(s5)
    80003592:	0289a503          	lw	a0,40(s3)
    80003596:	fffff097          	auipc	ra,0xfffff
    8000359a:	f14080e7          	jalr	-236(ra) # 800024aa <bread>
    8000359e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035a0:	40000613          	li	a2,1024
    800035a4:	05890593          	addi	a1,s2,88
    800035a8:	05850513          	addi	a0,a0,88
    800035ac:	ffffd097          	auipc	ra,0xffffd
    800035b0:	d2a080e7          	jalr	-726(ra) # 800002d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035b4:	8526                	mv	a0,s1
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	fe6080e7          	jalr	-26(ra) # 8000259c <bwrite>
    if(recovering == 0)
    800035be:	f80b1ce3          	bnez	s6,80003556 <install_trans+0x40>
    800035c2:	b769                	j	8000354c <install_trans+0x36>
}
    800035c4:	70e2                	ld	ra,56(sp)
    800035c6:	7442                	ld	s0,48(sp)
    800035c8:	74a2                	ld	s1,40(sp)
    800035ca:	7902                	ld	s2,32(sp)
    800035cc:	69e2                	ld	s3,24(sp)
    800035ce:	6a42                	ld	s4,16(sp)
    800035d0:	6aa2                	ld	s5,8(sp)
    800035d2:	6b02                	ld	s6,0(sp)
    800035d4:	6121                	addi	sp,sp,64
    800035d6:	8082                	ret
    800035d8:	8082                	ret

00000000800035da <initlog>:
{
    800035da:	7179                	addi	sp,sp,-48
    800035dc:	f406                	sd	ra,40(sp)
    800035de:	f022                	sd	s0,32(sp)
    800035e0:	ec26                	sd	s1,24(sp)
    800035e2:	e84a                	sd	s2,16(sp)
    800035e4:	e44e                	sd	s3,8(sp)
    800035e6:	1800                	addi	s0,sp,48
    800035e8:	892a                	mv	s2,a0
    800035ea:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035ec:	00236497          	auipc	s1,0x236
    800035f0:	a3448493          	addi	s1,s1,-1484 # 80239020 <log>
    800035f4:	00005597          	auipc	a1,0x5
    800035f8:	09458593          	addi	a1,a1,148 # 80008688 <syscalls+0x1d8>
    800035fc:	8526                	mv	a0,s1
    800035fe:	00003097          	auipc	ra,0x3
    80003602:	c14080e7          	jalr	-1004(ra) # 80006212 <initlock>
  log.start = sb->logstart;
    80003606:	0149a583          	lw	a1,20(s3)
    8000360a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000360c:	0109a783          	lw	a5,16(s3)
    80003610:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003612:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003616:	854a                	mv	a0,s2
    80003618:	fffff097          	auipc	ra,0xfffff
    8000361c:	e92080e7          	jalr	-366(ra) # 800024aa <bread>
  log.lh.n = lh->n;
    80003620:	4d3c                	lw	a5,88(a0)
    80003622:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003624:	02f05563          	blez	a5,8000364e <initlog+0x74>
    80003628:	05c50713          	addi	a4,a0,92
    8000362c:	00236697          	auipc	a3,0x236
    80003630:	a2468693          	addi	a3,a3,-1500 # 80239050 <log+0x30>
    80003634:	37fd                	addiw	a5,a5,-1
    80003636:	1782                	slli	a5,a5,0x20
    80003638:	9381                	srli	a5,a5,0x20
    8000363a:	078a                	slli	a5,a5,0x2
    8000363c:	06050613          	addi	a2,a0,96
    80003640:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003642:	4310                	lw	a2,0(a4)
    80003644:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003646:	0711                	addi	a4,a4,4
    80003648:	0691                	addi	a3,a3,4
    8000364a:	fef71ce3          	bne	a4,a5,80003642 <initlog+0x68>
  brelse(buf);
    8000364e:	fffff097          	auipc	ra,0xfffff
    80003652:	f8c080e7          	jalr	-116(ra) # 800025da <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003656:	4505                	li	a0,1
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	ebe080e7          	jalr	-322(ra) # 80003516 <install_trans>
  log.lh.n = 0;
    80003660:	00236797          	auipc	a5,0x236
    80003664:	9e07a623          	sw	zero,-1556(a5) # 8023904c <log+0x2c>
  write_head(); // clear the log
    80003668:	00000097          	auipc	ra,0x0
    8000366c:	e34080e7          	jalr	-460(ra) # 8000349c <write_head>
}
    80003670:	70a2                	ld	ra,40(sp)
    80003672:	7402                	ld	s0,32(sp)
    80003674:	64e2                	ld	s1,24(sp)
    80003676:	6942                	ld	s2,16(sp)
    80003678:	69a2                	ld	s3,8(sp)
    8000367a:	6145                	addi	sp,sp,48
    8000367c:	8082                	ret

000000008000367e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000367e:	1101                	addi	sp,sp,-32
    80003680:	ec06                	sd	ra,24(sp)
    80003682:	e822                	sd	s0,16(sp)
    80003684:	e426                	sd	s1,8(sp)
    80003686:	e04a                	sd	s2,0(sp)
    80003688:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000368a:	00236517          	auipc	a0,0x236
    8000368e:	99650513          	addi	a0,a0,-1642 # 80239020 <log>
    80003692:	00003097          	auipc	ra,0x3
    80003696:	c10080e7          	jalr	-1008(ra) # 800062a2 <acquire>
  while(1){
    if(log.committing){
    8000369a:	00236497          	auipc	s1,0x236
    8000369e:	98648493          	addi	s1,s1,-1658 # 80239020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036a2:	4979                	li	s2,30
    800036a4:	a039                	j	800036b2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036a6:	85a6                	mv	a1,s1
    800036a8:	8526                	mv	a0,s1
    800036aa:	ffffe097          	auipc	ra,0xffffe
    800036ae:	07c080e7          	jalr	124(ra) # 80001726 <sleep>
    if(log.committing){
    800036b2:	50dc                	lw	a5,36(s1)
    800036b4:	fbed                	bnez	a5,800036a6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036b6:	509c                	lw	a5,32(s1)
    800036b8:	0017871b          	addiw	a4,a5,1
    800036bc:	0007069b          	sext.w	a3,a4
    800036c0:	0027179b          	slliw	a5,a4,0x2
    800036c4:	9fb9                	addw	a5,a5,a4
    800036c6:	0017979b          	slliw	a5,a5,0x1
    800036ca:	54d8                	lw	a4,44(s1)
    800036cc:	9fb9                	addw	a5,a5,a4
    800036ce:	00f95963          	bge	s2,a5,800036e0 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036d2:	85a6                	mv	a1,s1
    800036d4:	8526                	mv	a0,s1
    800036d6:	ffffe097          	auipc	ra,0xffffe
    800036da:	050080e7          	jalr	80(ra) # 80001726 <sleep>
    800036de:	bfd1                	j	800036b2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036e0:	00236517          	auipc	a0,0x236
    800036e4:	94050513          	addi	a0,a0,-1728 # 80239020 <log>
    800036e8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036ea:	00003097          	auipc	ra,0x3
    800036ee:	c6c080e7          	jalr	-916(ra) # 80006356 <release>
      break;
    }
  }
}
    800036f2:	60e2                	ld	ra,24(sp)
    800036f4:	6442                	ld	s0,16(sp)
    800036f6:	64a2                	ld	s1,8(sp)
    800036f8:	6902                	ld	s2,0(sp)
    800036fa:	6105                	addi	sp,sp,32
    800036fc:	8082                	ret

00000000800036fe <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036fe:	7139                	addi	sp,sp,-64
    80003700:	fc06                	sd	ra,56(sp)
    80003702:	f822                	sd	s0,48(sp)
    80003704:	f426                	sd	s1,40(sp)
    80003706:	f04a                	sd	s2,32(sp)
    80003708:	ec4e                	sd	s3,24(sp)
    8000370a:	e852                	sd	s4,16(sp)
    8000370c:	e456                	sd	s5,8(sp)
    8000370e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003710:	00236497          	auipc	s1,0x236
    80003714:	91048493          	addi	s1,s1,-1776 # 80239020 <log>
    80003718:	8526                	mv	a0,s1
    8000371a:	00003097          	auipc	ra,0x3
    8000371e:	b88080e7          	jalr	-1144(ra) # 800062a2 <acquire>
  log.outstanding -= 1;
    80003722:	509c                	lw	a5,32(s1)
    80003724:	37fd                	addiw	a5,a5,-1
    80003726:	0007891b          	sext.w	s2,a5
    8000372a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000372c:	50dc                	lw	a5,36(s1)
    8000372e:	efb9                	bnez	a5,8000378c <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003730:	06091663          	bnez	s2,8000379c <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003734:	00236497          	auipc	s1,0x236
    80003738:	8ec48493          	addi	s1,s1,-1812 # 80239020 <log>
    8000373c:	4785                	li	a5,1
    8000373e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003740:	8526                	mv	a0,s1
    80003742:	00003097          	auipc	ra,0x3
    80003746:	c14080e7          	jalr	-1004(ra) # 80006356 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000374a:	54dc                	lw	a5,44(s1)
    8000374c:	06f04763          	bgtz	a5,800037ba <end_op+0xbc>
    acquire(&log.lock);
    80003750:	00236497          	auipc	s1,0x236
    80003754:	8d048493          	addi	s1,s1,-1840 # 80239020 <log>
    80003758:	8526                	mv	a0,s1
    8000375a:	00003097          	auipc	ra,0x3
    8000375e:	b48080e7          	jalr	-1208(ra) # 800062a2 <acquire>
    log.committing = 0;
    80003762:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003766:	8526                	mv	a0,s1
    80003768:	ffffe097          	auipc	ra,0xffffe
    8000376c:	14a080e7          	jalr	330(ra) # 800018b2 <wakeup>
    release(&log.lock);
    80003770:	8526                	mv	a0,s1
    80003772:	00003097          	auipc	ra,0x3
    80003776:	be4080e7          	jalr	-1052(ra) # 80006356 <release>
}
    8000377a:	70e2                	ld	ra,56(sp)
    8000377c:	7442                	ld	s0,48(sp)
    8000377e:	74a2                	ld	s1,40(sp)
    80003780:	7902                	ld	s2,32(sp)
    80003782:	69e2                	ld	s3,24(sp)
    80003784:	6a42                	ld	s4,16(sp)
    80003786:	6aa2                	ld	s5,8(sp)
    80003788:	6121                	addi	sp,sp,64
    8000378a:	8082                	ret
    panic("log.committing");
    8000378c:	00005517          	auipc	a0,0x5
    80003790:	f0450513          	addi	a0,a0,-252 # 80008690 <syscalls+0x1e0>
    80003794:	00002097          	auipc	ra,0x2
    80003798:	5c4080e7          	jalr	1476(ra) # 80005d58 <panic>
    wakeup(&log);
    8000379c:	00236497          	auipc	s1,0x236
    800037a0:	88448493          	addi	s1,s1,-1916 # 80239020 <log>
    800037a4:	8526                	mv	a0,s1
    800037a6:	ffffe097          	auipc	ra,0xffffe
    800037aa:	10c080e7          	jalr	268(ra) # 800018b2 <wakeup>
  release(&log.lock);
    800037ae:	8526                	mv	a0,s1
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	ba6080e7          	jalr	-1114(ra) # 80006356 <release>
  if(do_commit){
    800037b8:	b7c9                	j	8000377a <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ba:	00236a97          	auipc	s5,0x236
    800037be:	896a8a93          	addi	s5,s5,-1898 # 80239050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037c2:	00236a17          	auipc	s4,0x236
    800037c6:	85ea0a13          	addi	s4,s4,-1954 # 80239020 <log>
    800037ca:	018a2583          	lw	a1,24(s4)
    800037ce:	012585bb          	addw	a1,a1,s2
    800037d2:	2585                	addiw	a1,a1,1
    800037d4:	028a2503          	lw	a0,40(s4)
    800037d8:	fffff097          	auipc	ra,0xfffff
    800037dc:	cd2080e7          	jalr	-814(ra) # 800024aa <bread>
    800037e0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037e2:	000aa583          	lw	a1,0(s5)
    800037e6:	028a2503          	lw	a0,40(s4)
    800037ea:	fffff097          	auipc	ra,0xfffff
    800037ee:	cc0080e7          	jalr	-832(ra) # 800024aa <bread>
    800037f2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037f4:	40000613          	li	a2,1024
    800037f8:	05850593          	addi	a1,a0,88
    800037fc:	05848513          	addi	a0,s1,88
    80003800:	ffffd097          	auipc	ra,0xffffd
    80003804:	ad6080e7          	jalr	-1322(ra) # 800002d6 <memmove>
    bwrite(to);  // write the log
    80003808:	8526                	mv	a0,s1
    8000380a:	fffff097          	auipc	ra,0xfffff
    8000380e:	d92080e7          	jalr	-622(ra) # 8000259c <bwrite>
    brelse(from);
    80003812:	854e                	mv	a0,s3
    80003814:	fffff097          	auipc	ra,0xfffff
    80003818:	dc6080e7          	jalr	-570(ra) # 800025da <brelse>
    brelse(to);
    8000381c:	8526                	mv	a0,s1
    8000381e:	fffff097          	auipc	ra,0xfffff
    80003822:	dbc080e7          	jalr	-580(ra) # 800025da <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003826:	2905                	addiw	s2,s2,1
    80003828:	0a91                	addi	s5,s5,4
    8000382a:	02ca2783          	lw	a5,44(s4)
    8000382e:	f8f94ee3          	blt	s2,a5,800037ca <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003832:	00000097          	auipc	ra,0x0
    80003836:	c6a080e7          	jalr	-918(ra) # 8000349c <write_head>
    install_trans(0); // Now install writes to home locations
    8000383a:	4501                	li	a0,0
    8000383c:	00000097          	auipc	ra,0x0
    80003840:	cda080e7          	jalr	-806(ra) # 80003516 <install_trans>
    log.lh.n = 0;
    80003844:	00236797          	auipc	a5,0x236
    80003848:	8007a423          	sw	zero,-2040(a5) # 8023904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000384c:	00000097          	auipc	ra,0x0
    80003850:	c50080e7          	jalr	-944(ra) # 8000349c <write_head>
    80003854:	bdf5                	j	80003750 <end_op+0x52>

0000000080003856 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003856:	1101                	addi	sp,sp,-32
    80003858:	ec06                	sd	ra,24(sp)
    8000385a:	e822                	sd	s0,16(sp)
    8000385c:	e426                	sd	s1,8(sp)
    8000385e:	e04a                	sd	s2,0(sp)
    80003860:	1000                	addi	s0,sp,32
    80003862:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003864:	00235917          	auipc	s2,0x235
    80003868:	7bc90913          	addi	s2,s2,1980 # 80239020 <log>
    8000386c:	854a                	mv	a0,s2
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	a34080e7          	jalr	-1484(ra) # 800062a2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003876:	02c92603          	lw	a2,44(s2)
    8000387a:	47f5                	li	a5,29
    8000387c:	06c7c563          	blt	a5,a2,800038e6 <log_write+0x90>
    80003880:	00235797          	auipc	a5,0x235
    80003884:	7bc7a783          	lw	a5,1980(a5) # 8023903c <log+0x1c>
    80003888:	37fd                	addiw	a5,a5,-1
    8000388a:	04f65e63          	bge	a2,a5,800038e6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000388e:	00235797          	auipc	a5,0x235
    80003892:	7b27a783          	lw	a5,1970(a5) # 80239040 <log+0x20>
    80003896:	06f05063          	blez	a5,800038f6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000389a:	4781                	li	a5,0
    8000389c:	06c05563          	blez	a2,80003906 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038a0:	44cc                	lw	a1,12(s1)
    800038a2:	00235717          	auipc	a4,0x235
    800038a6:	7ae70713          	addi	a4,a4,1966 # 80239050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038aa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038ac:	4314                	lw	a3,0(a4)
    800038ae:	04b68c63          	beq	a3,a1,80003906 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038b2:	2785                	addiw	a5,a5,1
    800038b4:	0711                	addi	a4,a4,4
    800038b6:	fef61be3          	bne	a2,a5,800038ac <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038ba:	0621                	addi	a2,a2,8
    800038bc:	060a                	slli	a2,a2,0x2
    800038be:	00235797          	auipc	a5,0x235
    800038c2:	76278793          	addi	a5,a5,1890 # 80239020 <log>
    800038c6:	963e                	add	a2,a2,a5
    800038c8:	44dc                	lw	a5,12(s1)
    800038ca:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038cc:	8526                	mv	a0,s1
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	daa080e7          	jalr	-598(ra) # 80002678 <bpin>
    log.lh.n++;
    800038d6:	00235717          	auipc	a4,0x235
    800038da:	74a70713          	addi	a4,a4,1866 # 80239020 <log>
    800038de:	575c                	lw	a5,44(a4)
    800038e0:	2785                	addiw	a5,a5,1
    800038e2:	d75c                	sw	a5,44(a4)
    800038e4:	a835                	j	80003920 <log_write+0xca>
    panic("too big a transaction");
    800038e6:	00005517          	auipc	a0,0x5
    800038ea:	dba50513          	addi	a0,a0,-582 # 800086a0 <syscalls+0x1f0>
    800038ee:	00002097          	auipc	ra,0x2
    800038f2:	46a080e7          	jalr	1130(ra) # 80005d58 <panic>
    panic("log_write outside of trans");
    800038f6:	00005517          	auipc	a0,0x5
    800038fa:	dc250513          	addi	a0,a0,-574 # 800086b8 <syscalls+0x208>
    800038fe:	00002097          	auipc	ra,0x2
    80003902:	45a080e7          	jalr	1114(ra) # 80005d58 <panic>
  log.lh.block[i] = b->blockno;
    80003906:	00878713          	addi	a4,a5,8
    8000390a:	00271693          	slli	a3,a4,0x2
    8000390e:	00235717          	auipc	a4,0x235
    80003912:	71270713          	addi	a4,a4,1810 # 80239020 <log>
    80003916:	9736                	add	a4,a4,a3
    80003918:	44d4                	lw	a3,12(s1)
    8000391a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000391c:	faf608e3          	beq	a2,a5,800038cc <log_write+0x76>
  }
  release(&log.lock);
    80003920:	00235517          	auipc	a0,0x235
    80003924:	70050513          	addi	a0,a0,1792 # 80239020 <log>
    80003928:	00003097          	auipc	ra,0x3
    8000392c:	a2e080e7          	jalr	-1490(ra) # 80006356 <release>
}
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	64a2                	ld	s1,8(sp)
    80003936:	6902                	ld	s2,0(sp)
    80003938:	6105                	addi	sp,sp,32
    8000393a:	8082                	ret

000000008000393c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000393c:	1101                	addi	sp,sp,-32
    8000393e:	ec06                	sd	ra,24(sp)
    80003940:	e822                	sd	s0,16(sp)
    80003942:	e426                	sd	s1,8(sp)
    80003944:	e04a                	sd	s2,0(sp)
    80003946:	1000                	addi	s0,sp,32
    80003948:	84aa                	mv	s1,a0
    8000394a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000394c:	00005597          	auipc	a1,0x5
    80003950:	d8c58593          	addi	a1,a1,-628 # 800086d8 <syscalls+0x228>
    80003954:	0521                	addi	a0,a0,8
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	8bc080e7          	jalr	-1860(ra) # 80006212 <initlock>
  lk->name = name;
    8000395e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003962:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003966:	0204a423          	sw	zero,40(s1)
}
    8000396a:	60e2                	ld	ra,24(sp)
    8000396c:	6442                	ld	s0,16(sp)
    8000396e:	64a2                	ld	s1,8(sp)
    80003970:	6902                	ld	s2,0(sp)
    80003972:	6105                	addi	sp,sp,32
    80003974:	8082                	ret

0000000080003976 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003976:	1101                	addi	sp,sp,-32
    80003978:	ec06                	sd	ra,24(sp)
    8000397a:	e822                	sd	s0,16(sp)
    8000397c:	e426                	sd	s1,8(sp)
    8000397e:	e04a                	sd	s2,0(sp)
    80003980:	1000                	addi	s0,sp,32
    80003982:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003984:	00850913          	addi	s2,a0,8
    80003988:	854a                	mv	a0,s2
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	918080e7          	jalr	-1768(ra) # 800062a2 <acquire>
  while (lk->locked) {
    80003992:	409c                	lw	a5,0(s1)
    80003994:	cb89                	beqz	a5,800039a6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003996:	85ca                	mv	a1,s2
    80003998:	8526                	mv	a0,s1
    8000399a:	ffffe097          	auipc	ra,0xffffe
    8000399e:	d8c080e7          	jalr	-628(ra) # 80001726 <sleep>
  while (lk->locked) {
    800039a2:	409c                	lw	a5,0(s1)
    800039a4:	fbed                	bnez	a5,80003996 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039a6:	4785                	li	a5,1
    800039a8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039aa:	ffffd097          	auipc	ra,0xffffd
    800039ae:	6c0080e7          	jalr	1728(ra) # 8000106a <myproc>
    800039b2:	591c                	lw	a5,48(a0)
    800039b4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039b6:	854a                	mv	a0,s2
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	99e080e7          	jalr	-1634(ra) # 80006356 <release>
}
    800039c0:	60e2                	ld	ra,24(sp)
    800039c2:	6442                	ld	s0,16(sp)
    800039c4:	64a2                	ld	s1,8(sp)
    800039c6:	6902                	ld	s2,0(sp)
    800039c8:	6105                	addi	sp,sp,32
    800039ca:	8082                	ret

00000000800039cc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039cc:	1101                	addi	sp,sp,-32
    800039ce:	ec06                	sd	ra,24(sp)
    800039d0:	e822                	sd	s0,16(sp)
    800039d2:	e426                	sd	s1,8(sp)
    800039d4:	e04a                	sd	s2,0(sp)
    800039d6:	1000                	addi	s0,sp,32
    800039d8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039da:	00850913          	addi	s2,a0,8
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	8c2080e7          	jalr	-1854(ra) # 800062a2 <acquire>
  lk->locked = 0;
    800039e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ec:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039f0:	8526                	mv	a0,s1
    800039f2:	ffffe097          	auipc	ra,0xffffe
    800039f6:	ec0080e7          	jalr	-320(ra) # 800018b2 <wakeup>
  release(&lk->lk);
    800039fa:	854a                	mv	a0,s2
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	95a080e7          	jalr	-1702(ra) # 80006356 <release>
}
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	64a2                	ld	s1,8(sp)
    80003a0a:	6902                	ld	s2,0(sp)
    80003a0c:	6105                	addi	sp,sp,32
    80003a0e:	8082                	ret

0000000080003a10 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a10:	7179                	addi	sp,sp,-48
    80003a12:	f406                	sd	ra,40(sp)
    80003a14:	f022                	sd	s0,32(sp)
    80003a16:	ec26                	sd	s1,24(sp)
    80003a18:	e84a                	sd	s2,16(sp)
    80003a1a:	e44e                	sd	s3,8(sp)
    80003a1c:	1800                	addi	s0,sp,48
    80003a1e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a20:	00850913          	addi	s2,a0,8
    80003a24:	854a                	mv	a0,s2
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	87c080e7          	jalr	-1924(ra) # 800062a2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a2e:	409c                	lw	a5,0(s1)
    80003a30:	ef99                	bnez	a5,80003a4e <holdingsleep+0x3e>
    80003a32:	4481                	li	s1,0
  release(&lk->lk);
    80003a34:	854a                	mv	a0,s2
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	920080e7          	jalr	-1760(ra) # 80006356 <release>
  return r;
}
    80003a3e:	8526                	mv	a0,s1
    80003a40:	70a2                	ld	ra,40(sp)
    80003a42:	7402                	ld	s0,32(sp)
    80003a44:	64e2                	ld	s1,24(sp)
    80003a46:	6942                	ld	s2,16(sp)
    80003a48:	69a2                	ld	s3,8(sp)
    80003a4a:	6145                	addi	sp,sp,48
    80003a4c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a4e:	0284a983          	lw	s3,40(s1)
    80003a52:	ffffd097          	auipc	ra,0xffffd
    80003a56:	618080e7          	jalr	1560(ra) # 8000106a <myproc>
    80003a5a:	5904                	lw	s1,48(a0)
    80003a5c:	413484b3          	sub	s1,s1,s3
    80003a60:	0014b493          	seqz	s1,s1
    80003a64:	bfc1                	j	80003a34 <holdingsleep+0x24>

0000000080003a66 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a66:	1141                	addi	sp,sp,-16
    80003a68:	e406                	sd	ra,8(sp)
    80003a6a:	e022                	sd	s0,0(sp)
    80003a6c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a6e:	00005597          	auipc	a1,0x5
    80003a72:	c7a58593          	addi	a1,a1,-902 # 800086e8 <syscalls+0x238>
    80003a76:	00235517          	auipc	a0,0x235
    80003a7a:	6f250513          	addi	a0,a0,1778 # 80239168 <ftable>
    80003a7e:	00002097          	auipc	ra,0x2
    80003a82:	794080e7          	jalr	1940(ra) # 80006212 <initlock>
}
    80003a86:	60a2                	ld	ra,8(sp)
    80003a88:	6402                	ld	s0,0(sp)
    80003a8a:	0141                	addi	sp,sp,16
    80003a8c:	8082                	ret

0000000080003a8e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a8e:	1101                	addi	sp,sp,-32
    80003a90:	ec06                	sd	ra,24(sp)
    80003a92:	e822                	sd	s0,16(sp)
    80003a94:	e426                	sd	s1,8(sp)
    80003a96:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a98:	00235517          	auipc	a0,0x235
    80003a9c:	6d050513          	addi	a0,a0,1744 # 80239168 <ftable>
    80003aa0:	00003097          	auipc	ra,0x3
    80003aa4:	802080e7          	jalr	-2046(ra) # 800062a2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003aa8:	00235497          	auipc	s1,0x235
    80003aac:	6d848493          	addi	s1,s1,1752 # 80239180 <ftable+0x18>
    80003ab0:	00236717          	auipc	a4,0x236
    80003ab4:	67070713          	addi	a4,a4,1648 # 8023a120 <ftable+0xfb8>
    if(f->ref == 0){
    80003ab8:	40dc                	lw	a5,4(s1)
    80003aba:	cf99                	beqz	a5,80003ad8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003abc:	02848493          	addi	s1,s1,40
    80003ac0:	fee49ce3          	bne	s1,a4,80003ab8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003ac4:	00235517          	auipc	a0,0x235
    80003ac8:	6a450513          	addi	a0,a0,1700 # 80239168 <ftable>
    80003acc:	00003097          	auipc	ra,0x3
    80003ad0:	88a080e7          	jalr	-1910(ra) # 80006356 <release>
  return 0;
    80003ad4:	4481                	li	s1,0
    80003ad6:	a819                	j	80003aec <filealloc+0x5e>
      f->ref = 1;
    80003ad8:	4785                	li	a5,1
    80003ada:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003adc:	00235517          	auipc	a0,0x235
    80003ae0:	68c50513          	addi	a0,a0,1676 # 80239168 <ftable>
    80003ae4:	00003097          	auipc	ra,0x3
    80003ae8:	872080e7          	jalr	-1934(ra) # 80006356 <release>
}
    80003aec:	8526                	mv	a0,s1
    80003aee:	60e2                	ld	ra,24(sp)
    80003af0:	6442                	ld	s0,16(sp)
    80003af2:	64a2                	ld	s1,8(sp)
    80003af4:	6105                	addi	sp,sp,32
    80003af6:	8082                	ret

0000000080003af8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003af8:	1101                	addi	sp,sp,-32
    80003afa:	ec06                	sd	ra,24(sp)
    80003afc:	e822                	sd	s0,16(sp)
    80003afe:	e426                	sd	s1,8(sp)
    80003b00:	1000                	addi	s0,sp,32
    80003b02:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b04:	00235517          	auipc	a0,0x235
    80003b08:	66450513          	addi	a0,a0,1636 # 80239168 <ftable>
    80003b0c:	00002097          	auipc	ra,0x2
    80003b10:	796080e7          	jalr	1942(ra) # 800062a2 <acquire>
  if(f->ref < 1)
    80003b14:	40dc                	lw	a5,4(s1)
    80003b16:	02f05263          	blez	a5,80003b3a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b1a:	2785                	addiw	a5,a5,1
    80003b1c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b1e:	00235517          	auipc	a0,0x235
    80003b22:	64a50513          	addi	a0,a0,1610 # 80239168 <ftable>
    80003b26:	00003097          	auipc	ra,0x3
    80003b2a:	830080e7          	jalr	-2000(ra) # 80006356 <release>
  return f;
}
    80003b2e:	8526                	mv	a0,s1
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6105                	addi	sp,sp,32
    80003b38:	8082                	ret
    panic("filedup");
    80003b3a:	00005517          	auipc	a0,0x5
    80003b3e:	bb650513          	addi	a0,a0,-1098 # 800086f0 <syscalls+0x240>
    80003b42:	00002097          	auipc	ra,0x2
    80003b46:	216080e7          	jalr	534(ra) # 80005d58 <panic>

0000000080003b4a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b4a:	7139                	addi	sp,sp,-64
    80003b4c:	fc06                	sd	ra,56(sp)
    80003b4e:	f822                	sd	s0,48(sp)
    80003b50:	f426                	sd	s1,40(sp)
    80003b52:	f04a                	sd	s2,32(sp)
    80003b54:	ec4e                	sd	s3,24(sp)
    80003b56:	e852                	sd	s4,16(sp)
    80003b58:	e456                	sd	s5,8(sp)
    80003b5a:	0080                	addi	s0,sp,64
    80003b5c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b5e:	00235517          	auipc	a0,0x235
    80003b62:	60a50513          	addi	a0,a0,1546 # 80239168 <ftable>
    80003b66:	00002097          	auipc	ra,0x2
    80003b6a:	73c080e7          	jalr	1852(ra) # 800062a2 <acquire>
  if(f->ref < 1)
    80003b6e:	40dc                	lw	a5,4(s1)
    80003b70:	06f05163          	blez	a5,80003bd2 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b74:	37fd                	addiw	a5,a5,-1
    80003b76:	0007871b          	sext.w	a4,a5
    80003b7a:	c0dc                	sw	a5,4(s1)
    80003b7c:	06e04363          	bgtz	a4,80003be2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b80:	0004a903          	lw	s2,0(s1)
    80003b84:	0094ca83          	lbu	s5,9(s1)
    80003b88:	0104ba03          	ld	s4,16(s1)
    80003b8c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b90:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b94:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b98:	00235517          	auipc	a0,0x235
    80003b9c:	5d050513          	addi	a0,a0,1488 # 80239168 <ftable>
    80003ba0:	00002097          	auipc	ra,0x2
    80003ba4:	7b6080e7          	jalr	1974(ra) # 80006356 <release>

  if(ff.type == FD_PIPE){
    80003ba8:	4785                	li	a5,1
    80003baa:	04f90d63          	beq	s2,a5,80003c04 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bae:	3979                	addiw	s2,s2,-2
    80003bb0:	4785                	li	a5,1
    80003bb2:	0527e063          	bltu	a5,s2,80003bf2 <fileclose+0xa8>
    begin_op();
    80003bb6:	00000097          	auipc	ra,0x0
    80003bba:	ac8080e7          	jalr	-1336(ra) # 8000367e <begin_op>
    iput(ff.ip);
    80003bbe:	854e                	mv	a0,s3
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	2a6080e7          	jalr	678(ra) # 80002e66 <iput>
    end_op();
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	b36080e7          	jalr	-1226(ra) # 800036fe <end_op>
    80003bd0:	a00d                	j	80003bf2 <fileclose+0xa8>
    panic("fileclose");
    80003bd2:	00005517          	auipc	a0,0x5
    80003bd6:	b2650513          	addi	a0,a0,-1242 # 800086f8 <syscalls+0x248>
    80003bda:	00002097          	auipc	ra,0x2
    80003bde:	17e080e7          	jalr	382(ra) # 80005d58 <panic>
    release(&ftable.lock);
    80003be2:	00235517          	auipc	a0,0x235
    80003be6:	58650513          	addi	a0,a0,1414 # 80239168 <ftable>
    80003bea:	00002097          	auipc	ra,0x2
    80003bee:	76c080e7          	jalr	1900(ra) # 80006356 <release>
  }
}
    80003bf2:	70e2                	ld	ra,56(sp)
    80003bf4:	7442                	ld	s0,48(sp)
    80003bf6:	74a2                	ld	s1,40(sp)
    80003bf8:	7902                	ld	s2,32(sp)
    80003bfa:	69e2                	ld	s3,24(sp)
    80003bfc:	6a42                	ld	s4,16(sp)
    80003bfe:	6aa2                	ld	s5,8(sp)
    80003c00:	6121                	addi	sp,sp,64
    80003c02:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c04:	85d6                	mv	a1,s5
    80003c06:	8552                	mv	a0,s4
    80003c08:	00000097          	auipc	ra,0x0
    80003c0c:	34c080e7          	jalr	844(ra) # 80003f54 <pipeclose>
    80003c10:	b7cd                	j	80003bf2 <fileclose+0xa8>

0000000080003c12 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c12:	715d                	addi	sp,sp,-80
    80003c14:	e486                	sd	ra,72(sp)
    80003c16:	e0a2                	sd	s0,64(sp)
    80003c18:	fc26                	sd	s1,56(sp)
    80003c1a:	f84a                	sd	s2,48(sp)
    80003c1c:	f44e                	sd	s3,40(sp)
    80003c1e:	0880                	addi	s0,sp,80
    80003c20:	84aa                	mv	s1,a0
    80003c22:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c24:	ffffd097          	auipc	ra,0xffffd
    80003c28:	446080e7          	jalr	1094(ra) # 8000106a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c2c:	409c                	lw	a5,0(s1)
    80003c2e:	37f9                	addiw	a5,a5,-2
    80003c30:	4705                	li	a4,1
    80003c32:	04f76763          	bltu	a4,a5,80003c80 <filestat+0x6e>
    80003c36:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c38:	6c88                	ld	a0,24(s1)
    80003c3a:	fffff097          	auipc	ra,0xfffff
    80003c3e:	072080e7          	jalr	114(ra) # 80002cac <ilock>
    stati(f->ip, &st);
    80003c42:	fb840593          	addi	a1,s0,-72
    80003c46:	6c88                	ld	a0,24(s1)
    80003c48:	fffff097          	auipc	ra,0xfffff
    80003c4c:	2ee080e7          	jalr	750(ra) # 80002f36 <stati>
    iunlock(f->ip);
    80003c50:	6c88                	ld	a0,24(s1)
    80003c52:	fffff097          	auipc	ra,0xfffff
    80003c56:	11c080e7          	jalr	284(ra) # 80002d6e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c5a:	46e1                	li	a3,24
    80003c5c:	fb840613          	addi	a2,s0,-72
    80003c60:	85ce                	mv	a1,s3
    80003c62:	05093503          	ld	a0,80(s2)
    80003c66:	ffffd097          	auipc	ra,0xffffd
    80003c6a:	194080e7          	jalr	404(ra) # 80000dfa <copyout>
    80003c6e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c72:	60a6                	ld	ra,72(sp)
    80003c74:	6406                	ld	s0,64(sp)
    80003c76:	74e2                	ld	s1,56(sp)
    80003c78:	7942                	ld	s2,48(sp)
    80003c7a:	79a2                	ld	s3,40(sp)
    80003c7c:	6161                	addi	sp,sp,80
    80003c7e:	8082                	ret
  return -1;
    80003c80:	557d                	li	a0,-1
    80003c82:	bfc5                	j	80003c72 <filestat+0x60>

0000000080003c84 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c84:	7179                	addi	sp,sp,-48
    80003c86:	f406                	sd	ra,40(sp)
    80003c88:	f022                	sd	s0,32(sp)
    80003c8a:	ec26                	sd	s1,24(sp)
    80003c8c:	e84a                	sd	s2,16(sp)
    80003c8e:	e44e                	sd	s3,8(sp)
    80003c90:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c92:	00854783          	lbu	a5,8(a0)
    80003c96:	c3d5                	beqz	a5,80003d3a <fileread+0xb6>
    80003c98:	84aa                	mv	s1,a0
    80003c9a:	89ae                	mv	s3,a1
    80003c9c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c9e:	411c                	lw	a5,0(a0)
    80003ca0:	4705                	li	a4,1
    80003ca2:	04e78963          	beq	a5,a4,80003cf4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ca6:	470d                	li	a4,3
    80003ca8:	04e78d63          	beq	a5,a4,80003d02 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cac:	4709                	li	a4,2
    80003cae:	06e79e63          	bne	a5,a4,80003d2a <fileread+0xa6>
    ilock(f->ip);
    80003cb2:	6d08                	ld	a0,24(a0)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	ff8080e7          	jalr	-8(ra) # 80002cac <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003cbc:	874a                	mv	a4,s2
    80003cbe:	5094                	lw	a3,32(s1)
    80003cc0:	864e                	mv	a2,s3
    80003cc2:	4585                	li	a1,1
    80003cc4:	6c88                	ld	a0,24(s1)
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	29a080e7          	jalr	666(ra) # 80002f60 <readi>
    80003cce:	892a                	mv	s2,a0
    80003cd0:	00a05563          	blez	a0,80003cda <fileread+0x56>
      f->off += r;
    80003cd4:	509c                	lw	a5,32(s1)
    80003cd6:	9fa9                	addw	a5,a5,a0
    80003cd8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003cda:	6c88                	ld	a0,24(s1)
    80003cdc:	fffff097          	auipc	ra,0xfffff
    80003ce0:	092080e7          	jalr	146(ra) # 80002d6e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ce4:	854a                	mv	a0,s2
    80003ce6:	70a2                	ld	ra,40(sp)
    80003ce8:	7402                	ld	s0,32(sp)
    80003cea:	64e2                	ld	s1,24(sp)
    80003cec:	6942                	ld	s2,16(sp)
    80003cee:	69a2                	ld	s3,8(sp)
    80003cf0:	6145                	addi	sp,sp,48
    80003cf2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cf4:	6908                	ld	a0,16(a0)
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	3c8080e7          	jalr	968(ra) # 800040be <piperead>
    80003cfe:	892a                	mv	s2,a0
    80003d00:	b7d5                	j	80003ce4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d02:	02451783          	lh	a5,36(a0)
    80003d06:	03079693          	slli	a3,a5,0x30
    80003d0a:	92c1                	srli	a3,a3,0x30
    80003d0c:	4725                	li	a4,9
    80003d0e:	02d76863          	bltu	a4,a3,80003d3e <fileread+0xba>
    80003d12:	0792                	slli	a5,a5,0x4
    80003d14:	00235717          	auipc	a4,0x235
    80003d18:	3b470713          	addi	a4,a4,948 # 802390c8 <devsw>
    80003d1c:	97ba                	add	a5,a5,a4
    80003d1e:	639c                	ld	a5,0(a5)
    80003d20:	c38d                	beqz	a5,80003d42 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d22:	4505                	li	a0,1
    80003d24:	9782                	jalr	a5
    80003d26:	892a                	mv	s2,a0
    80003d28:	bf75                	j	80003ce4 <fileread+0x60>
    panic("fileread");
    80003d2a:	00005517          	auipc	a0,0x5
    80003d2e:	9de50513          	addi	a0,a0,-1570 # 80008708 <syscalls+0x258>
    80003d32:	00002097          	auipc	ra,0x2
    80003d36:	026080e7          	jalr	38(ra) # 80005d58 <panic>
    return -1;
    80003d3a:	597d                	li	s2,-1
    80003d3c:	b765                	j	80003ce4 <fileread+0x60>
      return -1;
    80003d3e:	597d                	li	s2,-1
    80003d40:	b755                	j	80003ce4 <fileread+0x60>
    80003d42:	597d                	li	s2,-1
    80003d44:	b745                	j	80003ce4 <fileread+0x60>

0000000080003d46 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d46:	715d                	addi	sp,sp,-80
    80003d48:	e486                	sd	ra,72(sp)
    80003d4a:	e0a2                	sd	s0,64(sp)
    80003d4c:	fc26                	sd	s1,56(sp)
    80003d4e:	f84a                	sd	s2,48(sp)
    80003d50:	f44e                	sd	s3,40(sp)
    80003d52:	f052                	sd	s4,32(sp)
    80003d54:	ec56                	sd	s5,24(sp)
    80003d56:	e85a                	sd	s6,16(sp)
    80003d58:	e45e                	sd	s7,8(sp)
    80003d5a:	e062                	sd	s8,0(sp)
    80003d5c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d5e:	00954783          	lbu	a5,9(a0)
    80003d62:	10078663          	beqz	a5,80003e6e <filewrite+0x128>
    80003d66:	892a                	mv	s2,a0
    80003d68:	8aae                	mv	s5,a1
    80003d6a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d6c:	411c                	lw	a5,0(a0)
    80003d6e:	4705                	li	a4,1
    80003d70:	02e78263          	beq	a5,a4,80003d94 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d74:	470d                	li	a4,3
    80003d76:	02e78663          	beq	a5,a4,80003da2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d7a:	4709                	li	a4,2
    80003d7c:	0ee79163          	bne	a5,a4,80003e5e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d80:	0ac05d63          	blez	a2,80003e3a <filewrite+0xf4>
    int i = 0;
    80003d84:	4981                	li	s3,0
    80003d86:	6b05                	lui	s6,0x1
    80003d88:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d8c:	6b85                	lui	s7,0x1
    80003d8e:	c00b8b9b          	addiw	s7,s7,-1024
    80003d92:	a861                	j	80003e2a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d94:	6908                	ld	a0,16(a0)
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	22e080e7          	jalr	558(ra) # 80003fc4 <pipewrite>
    80003d9e:	8a2a                	mv	s4,a0
    80003da0:	a045                	j	80003e40 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003da2:	02451783          	lh	a5,36(a0)
    80003da6:	03079693          	slli	a3,a5,0x30
    80003daa:	92c1                	srli	a3,a3,0x30
    80003dac:	4725                	li	a4,9
    80003dae:	0cd76263          	bltu	a4,a3,80003e72 <filewrite+0x12c>
    80003db2:	0792                	slli	a5,a5,0x4
    80003db4:	00235717          	auipc	a4,0x235
    80003db8:	31470713          	addi	a4,a4,788 # 802390c8 <devsw>
    80003dbc:	97ba                	add	a5,a5,a4
    80003dbe:	679c                	ld	a5,8(a5)
    80003dc0:	cbdd                	beqz	a5,80003e76 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dc2:	4505                	li	a0,1
    80003dc4:	9782                	jalr	a5
    80003dc6:	8a2a                	mv	s4,a0
    80003dc8:	a8a5                	j	80003e40 <filewrite+0xfa>
    80003dca:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	8b0080e7          	jalr	-1872(ra) # 8000367e <begin_op>
      ilock(f->ip);
    80003dd6:	01893503          	ld	a0,24(s2)
    80003dda:	fffff097          	auipc	ra,0xfffff
    80003dde:	ed2080e7          	jalr	-302(ra) # 80002cac <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003de2:	8762                	mv	a4,s8
    80003de4:	02092683          	lw	a3,32(s2)
    80003de8:	01598633          	add	a2,s3,s5
    80003dec:	4585                	li	a1,1
    80003dee:	01893503          	ld	a0,24(s2)
    80003df2:	fffff097          	auipc	ra,0xfffff
    80003df6:	266080e7          	jalr	614(ra) # 80003058 <writei>
    80003dfa:	84aa                	mv	s1,a0
    80003dfc:	00a05763          	blez	a0,80003e0a <filewrite+0xc4>
        f->off += r;
    80003e00:	02092783          	lw	a5,32(s2)
    80003e04:	9fa9                	addw	a5,a5,a0
    80003e06:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e0a:	01893503          	ld	a0,24(s2)
    80003e0e:	fffff097          	auipc	ra,0xfffff
    80003e12:	f60080e7          	jalr	-160(ra) # 80002d6e <iunlock>
      end_op();
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	8e8080e7          	jalr	-1816(ra) # 800036fe <end_op>

      if(r != n1){
    80003e1e:	009c1f63          	bne	s8,s1,80003e3c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e22:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e26:	0149db63          	bge	s3,s4,80003e3c <filewrite+0xf6>
      int n1 = n - i;
    80003e2a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e2e:	84be                	mv	s1,a5
    80003e30:	2781                	sext.w	a5,a5
    80003e32:	f8fb5ce3          	bge	s6,a5,80003dca <filewrite+0x84>
    80003e36:	84de                	mv	s1,s7
    80003e38:	bf49                	j	80003dca <filewrite+0x84>
    int i = 0;
    80003e3a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e3c:	013a1f63          	bne	s4,s3,80003e5a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e40:	8552                	mv	a0,s4
    80003e42:	60a6                	ld	ra,72(sp)
    80003e44:	6406                	ld	s0,64(sp)
    80003e46:	74e2                	ld	s1,56(sp)
    80003e48:	7942                	ld	s2,48(sp)
    80003e4a:	79a2                	ld	s3,40(sp)
    80003e4c:	7a02                	ld	s4,32(sp)
    80003e4e:	6ae2                	ld	s5,24(sp)
    80003e50:	6b42                	ld	s6,16(sp)
    80003e52:	6ba2                	ld	s7,8(sp)
    80003e54:	6c02                	ld	s8,0(sp)
    80003e56:	6161                	addi	sp,sp,80
    80003e58:	8082                	ret
    ret = (i == n ? n : -1);
    80003e5a:	5a7d                	li	s4,-1
    80003e5c:	b7d5                	j	80003e40 <filewrite+0xfa>
    panic("filewrite");
    80003e5e:	00005517          	auipc	a0,0x5
    80003e62:	8ba50513          	addi	a0,a0,-1862 # 80008718 <syscalls+0x268>
    80003e66:	00002097          	auipc	ra,0x2
    80003e6a:	ef2080e7          	jalr	-270(ra) # 80005d58 <panic>
    return -1;
    80003e6e:	5a7d                	li	s4,-1
    80003e70:	bfc1                	j	80003e40 <filewrite+0xfa>
      return -1;
    80003e72:	5a7d                	li	s4,-1
    80003e74:	b7f1                	j	80003e40 <filewrite+0xfa>
    80003e76:	5a7d                	li	s4,-1
    80003e78:	b7e1                	j	80003e40 <filewrite+0xfa>

0000000080003e7a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e7a:	7179                	addi	sp,sp,-48
    80003e7c:	f406                	sd	ra,40(sp)
    80003e7e:	f022                	sd	s0,32(sp)
    80003e80:	ec26                	sd	s1,24(sp)
    80003e82:	e84a                	sd	s2,16(sp)
    80003e84:	e44e                	sd	s3,8(sp)
    80003e86:	e052                	sd	s4,0(sp)
    80003e88:	1800                	addi	s0,sp,48
    80003e8a:	84aa                	mv	s1,a0
    80003e8c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e8e:	0005b023          	sd	zero,0(a1)
    80003e92:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e96:	00000097          	auipc	ra,0x0
    80003e9a:	bf8080e7          	jalr	-1032(ra) # 80003a8e <filealloc>
    80003e9e:	e088                	sd	a0,0(s1)
    80003ea0:	c551                	beqz	a0,80003f2c <pipealloc+0xb2>
    80003ea2:	00000097          	auipc	ra,0x0
    80003ea6:	bec080e7          	jalr	-1044(ra) # 80003a8e <filealloc>
    80003eaa:	00aa3023          	sd	a0,0(s4)
    80003eae:	c92d                	beqz	a0,80003f20 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003eb0:	ffffc097          	auipc	ra,0xffffc
    80003eb4:	2c4080e7          	jalr	708(ra) # 80000174 <kalloc>
    80003eb8:	892a                	mv	s2,a0
    80003eba:	c125                	beqz	a0,80003f1a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ebc:	4985                	li	s3,1
    80003ebe:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ec2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ec6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003eca:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ece:	00005597          	auipc	a1,0x5
    80003ed2:	85a58593          	addi	a1,a1,-1958 # 80008728 <syscalls+0x278>
    80003ed6:	00002097          	auipc	ra,0x2
    80003eda:	33c080e7          	jalr	828(ra) # 80006212 <initlock>
  (*f0)->type = FD_PIPE;
    80003ede:	609c                	ld	a5,0(s1)
    80003ee0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ee4:	609c                	ld	a5,0(s1)
    80003ee6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eea:	609c                	ld	a5,0(s1)
    80003eec:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ef0:	609c                	ld	a5,0(s1)
    80003ef2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ef6:	000a3783          	ld	a5,0(s4)
    80003efa:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003efe:	000a3783          	ld	a5,0(s4)
    80003f02:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f06:	000a3783          	ld	a5,0(s4)
    80003f0a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f0e:	000a3783          	ld	a5,0(s4)
    80003f12:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f16:	4501                	li	a0,0
    80003f18:	a025                	j	80003f40 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f1a:	6088                	ld	a0,0(s1)
    80003f1c:	e501                	bnez	a0,80003f24 <pipealloc+0xaa>
    80003f1e:	a039                	j	80003f2c <pipealloc+0xb2>
    80003f20:	6088                	ld	a0,0(s1)
    80003f22:	c51d                	beqz	a0,80003f50 <pipealloc+0xd6>
    fileclose(*f0);
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	c26080e7          	jalr	-986(ra) # 80003b4a <fileclose>
  if(*f1)
    80003f2c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f30:	557d                	li	a0,-1
  if(*f1)
    80003f32:	c799                	beqz	a5,80003f40 <pipealloc+0xc6>
    fileclose(*f1);
    80003f34:	853e                	mv	a0,a5
    80003f36:	00000097          	auipc	ra,0x0
    80003f3a:	c14080e7          	jalr	-1004(ra) # 80003b4a <fileclose>
  return -1;
    80003f3e:	557d                	li	a0,-1
}
    80003f40:	70a2                	ld	ra,40(sp)
    80003f42:	7402                	ld	s0,32(sp)
    80003f44:	64e2                	ld	s1,24(sp)
    80003f46:	6942                	ld	s2,16(sp)
    80003f48:	69a2                	ld	s3,8(sp)
    80003f4a:	6a02                	ld	s4,0(sp)
    80003f4c:	6145                	addi	sp,sp,48
    80003f4e:	8082                	ret
  return -1;
    80003f50:	557d                	li	a0,-1
    80003f52:	b7fd                	j	80003f40 <pipealloc+0xc6>

0000000080003f54 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f54:	1101                	addi	sp,sp,-32
    80003f56:	ec06                	sd	ra,24(sp)
    80003f58:	e822                	sd	s0,16(sp)
    80003f5a:	e426                	sd	s1,8(sp)
    80003f5c:	e04a                	sd	s2,0(sp)
    80003f5e:	1000                	addi	s0,sp,32
    80003f60:	84aa                	mv	s1,a0
    80003f62:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	33e080e7          	jalr	830(ra) # 800062a2 <acquire>
  if(writable){
    80003f6c:	02090d63          	beqz	s2,80003fa6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f70:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f74:	21848513          	addi	a0,s1,536
    80003f78:	ffffe097          	auipc	ra,0xffffe
    80003f7c:	93a080e7          	jalr	-1734(ra) # 800018b2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f80:	2204b783          	ld	a5,544(s1)
    80003f84:	eb95                	bnez	a5,80003fb8 <pipeclose+0x64>
    release(&pi->lock);
    80003f86:	8526                	mv	a0,s1
    80003f88:	00002097          	auipc	ra,0x2
    80003f8c:	3ce080e7          	jalr	974(ra) # 80006356 <release>
    kfree((char*)pi);
    80003f90:	8526                	mv	a0,s1
    80003f92:	ffffc097          	auipc	ra,0xffffc
    80003f96:	08a080e7          	jalr	138(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f9a:	60e2                	ld	ra,24(sp)
    80003f9c:	6442                	ld	s0,16(sp)
    80003f9e:	64a2                	ld	s1,8(sp)
    80003fa0:	6902                	ld	s2,0(sp)
    80003fa2:	6105                	addi	sp,sp,32
    80003fa4:	8082                	ret
    pi->readopen = 0;
    80003fa6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003faa:	21c48513          	addi	a0,s1,540
    80003fae:	ffffe097          	auipc	ra,0xffffe
    80003fb2:	904080e7          	jalr	-1788(ra) # 800018b2 <wakeup>
    80003fb6:	b7e9                	j	80003f80 <pipeclose+0x2c>
    release(&pi->lock);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	00002097          	auipc	ra,0x2
    80003fbe:	39c080e7          	jalr	924(ra) # 80006356 <release>
}
    80003fc2:	bfe1                	j	80003f9a <pipeclose+0x46>

0000000080003fc4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fc4:	7159                	addi	sp,sp,-112
    80003fc6:	f486                	sd	ra,104(sp)
    80003fc8:	f0a2                	sd	s0,96(sp)
    80003fca:	eca6                	sd	s1,88(sp)
    80003fcc:	e8ca                	sd	s2,80(sp)
    80003fce:	e4ce                	sd	s3,72(sp)
    80003fd0:	e0d2                	sd	s4,64(sp)
    80003fd2:	fc56                	sd	s5,56(sp)
    80003fd4:	f85a                	sd	s6,48(sp)
    80003fd6:	f45e                	sd	s7,40(sp)
    80003fd8:	f062                	sd	s8,32(sp)
    80003fda:	ec66                	sd	s9,24(sp)
    80003fdc:	1880                	addi	s0,sp,112
    80003fde:	84aa                	mv	s1,a0
    80003fe0:	8aae                	mv	s5,a1
    80003fe2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	086080e7          	jalr	134(ra) # 8000106a <myproc>
    80003fec:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	00002097          	auipc	ra,0x2
    80003ff4:	2b2080e7          	jalr	690(ra) # 800062a2 <acquire>
  while(i < n){
    80003ff8:	0d405163          	blez	s4,800040ba <pipewrite+0xf6>
    80003ffc:	8ba6                	mv	s7,s1
  int i = 0;
    80003ffe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004000:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004002:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004006:	21c48c13          	addi	s8,s1,540
    8000400a:	a08d                	j	8000406c <pipewrite+0xa8>
      release(&pi->lock);
    8000400c:	8526                	mv	a0,s1
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	348080e7          	jalr	840(ra) # 80006356 <release>
      return -1;
    80004016:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004018:	854a                	mv	a0,s2
    8000401a:	70a6                	ld	ra,104(sp)
    8000401c:	7406                	ld	s0,96(sp)
    8000401e:	64e6                	ld	s1,88(sp)
    80004020:	6946                	ld	s2,80(sp)
    80004022:	69a6                	ld	s3,72(sp)
    80004024:	6a06                	ld	s4,64(sp)
    80004026:	7ae2                	ld	s5,56(sp)
    80004028:	7b42                	ld	s6,48(sp)
    8000402a:	7ba2                	ld	s7,40(sp)
    8000402c:	7c02                	ld	s8,32(sp)
    8000402e:	6ce2                	ld	s9,24(sp)
    80004030:	6165                	addi	sp,sp,112
    80004032:	8082                	ret
      wakeup(&pi->nread);
    80004034:	8566                	mv	a0,s9
    80004036:	ffffe097          	auipc	ra,0xffffe
    8000403a:	87c080e7          	jalr	-1924(ra) # 800018b2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000403e:	85de                	mv	a1,s7
    80004040:	8562                	mv	a0,s8
    80004042:	ffffd097          	auipc	ra,0xffffd
    80004046:	6e4080e7          	jalr	1764(ra) # 80001726 <sleep>
    8000404a:	a839                	j	80004068 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000404c:	21c4a783          	lw	a5,540(s1)
    80004050:	0017871b          	addiw	a4,a5,1
    80004054:	20e4ae23          	sw	a4,540(s1)
    80004058:	1ff7f793          	andi	a5,a5,511
    8000405c:	97a6                	add	a5,a5,s1
    8000405e:	f9f44703          	lbu	a4,-97(s0)
    80004062:	00e78c23          	sb	a4,24(a5)
      i++;
    80004066:	2905                	addiw	s2,s2,1
  while(i < n){
    80004068:	03495d63          	bge	s2,s4,800040a2 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000406c:	2204a783          	lw	a5,544(s1)
    80004070:	dfd1                	beqz	a5,8000400c <pipewrite+0x48>
    80004072:	0289a783          	lw	a5,40(s3)
    80004076:	fbd9                	bnez	a5,8000400c <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004078:	2184a783          	lw	a5,536(s1)
    8000407c:	21c4a703          	lw	a4,540(s1)
    80004080:	2007879b          	addiw	a5,a5,512
    80004084:	faf708e3          	beq	a4,a5,80004034 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004088:	4685                	li	a3,1
    8000408a:	01590633          	add	a2,s2,s5
    8000408e:	f9f40593          	addi	a1,s0,-97
    80004092:	0509b503          	ld	a0,80(s3)
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	b5c080e7          	jalr	-1188(ra) # 80000bf2 <copyin>
    8000409e:	fb6517e3          	bne	a0,s6,8000404c <pipewrite+0x88>
  wakeup(&pi->nread);
    800040a2:	21848513          	addi	a0,s1,536
    800040a6:	ffffe097          	auipc	ra,0xffffe
    800040aa:	80c080e7          	jalr	-2036(ra) # 800018b2 <wakeup>
  release(&pi->lock);
    800040ae:	8526                	mv	a0,s1
    800040b0:	00002097          	auipc	ra,0x2
    800040b4:	2a6080e7          	jalr	678(ra) # 80006356 <release>
  return i;
    800040b8:	b785                	j	80004018 <pipewrite+0x54>
  int i = 0;
    800040ba:	4901                	li	s2,0
    800040bc:	b7dd                	j	800040a2 <pipewrite+0xde>

00000000800040be <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040be:	715d                	addi	sp,sp,-80
    800040c0:	e486                	sd	ra,72(sp)
    800040c2:	e0a2                	sd	s0,64(sp)
    800040c4:	fc26                	sd	s1,56(sp)
    800040c6:	f84a                	sd	s2,48(sp)
    800040c8:	f44e                	sd	s3,40(sp)
    800040ca:	f052                	sd	s4,32(sp)
    800040cc:	ec56                	sd	s5,24(sp)
    800040ce:	e85a                	sd	s6,16(sp)
    800040d0:	0880                	addi	s0,sp,80
    800040d2:	84aa                	mv	s1,a0
    800040d4:	892e                	mv	s2,a1
    800040d6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	f92080e7          	jalr	-110(ra) # 8000106a <myproc>
    800040e0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040e2:	8b26                	mv	s6,s1
    800040e4:	8526                	mv	a0,s1
    800040e6:	00002097          	auipc	ra,0x2
    800040ea:	1bc080e7          	jalr	444(ra) # 800062a2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ee:	2184a703          	lw	a4,536(s1)
    800040f2:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040f6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040fa:	02f71463          	bne	a4,a5,80004122 <piperead+0x64>
    800040fe:	2244a783          	lw	a5,548(s1)
    80004102:	c385                	beqz	a5,80004122 <piperead+0x64>
    if(pr->killed){
    80004104:	028a2783          	lw	a5,40(s4)
    80004108:	ebc1                	bnez	a5,80004198 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000410a:	85da                	mv	a1,s6
    8000410c:	854e                	mv	a0,s3
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	618080e7          	jalr	1560(ra) # 80001726 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004116:	2184a703          	lw	a4,536(s1)
    8000411a:	21c4a783          	lw	a5,540(s1)
    8000411e:	fef700e3          	beq	a4,a5,800040fe <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004122:	09505263          	blez	s5,800041a6 <piperead+0xe8>
    80004126:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004128:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000412a:	2184a783          	lw	a5,536(s1)
    8000412e:	21c4a703          	lw	a4,540(s1)
    80004132:	02f70d63          	beq	a4,a5,8000416c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004136:	0017871b          	addiw	a4,a5,1
    8000413a:	20e4ac23          	sw	a4,536(s1)
    8000413e:	1ff7f793          	andi	a5,a5,511
    80004142:	97a6                	add	a5,a5,s1
    80004144:	0187c783          	lbu	a5,24(a5)
    80004148:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000414c:	4685                	li	a3,1
    8000414e:	fbf40613          	addi	a2,s0,-65
    80004152:	85ca                	mv	a1,s2
    80004154:	050a3503          	ld	a0,80(s4)
    80004158:	ffffd097          	auipc	ra,0xffffd
    8000415c:	ca2080e7          	jalr	-862(ra) # 80000dfa <copyout>
    80004160:	01650663          	beq	a0,s6,8000416c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004164:	2985                	addiw	s3,s3,1
    80004166:	0905                	addi	s2,s2,1
    80004168:	fd3a91e3          	bne	s5,s3,8000412a <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000416c:	21c48513          	addi	a0,s1,540
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	742080e7          	jalr	1858(ra) # 800018b2 <wakeup>
  release(&pi->lock);
    80004178:	8526                	mv	a0,s1
    8000417a:	00002097          	auipc	ra,0x2
    8000417e:	1dc080e7          	jalr	476(ra) # 80006356 <release>
  return i;
}
    80004182:	854e                	mv	a0,s3
    80004184:	60a6                	ld	ra,72(sp)
    80004186:	6406                	ld	s0,64(sp)
    80004188:	74e2                	ld	s1,56(sp)
    8000418a:	7942                	ld	s2,48(sp)
    8000418c:	79a2                	ld	s3,40(sp)
    8000418e:	7a02                	ld	s4,32(sp)
    80004190:	6ae2                	ld	s5,24(sp)
    80004192:	6b42                	ld	s6,16(sp)
    80004194:	6161                	addi	sp,sp,80
    80004196:	8082                	ret
      release(&pi->lock);
    80004198:	8526                	mv	a0,s1
    8000419a:	00002097          	auipc	ra,0x2
    8000419e:	1bc080e7          	jalr	444(ra) # 80006356 <release>
      return -1;
    800041a2:	59fd                	li	s3,-1
    800041a4:	bff9                	j	80004182 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041a6:	4981                	li	s3,0
    800041a8:	b7d1                	j	8000416c <piperead+0xae>

00000000800041aa <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041aa:	df010113          	addi	sp,sp,-528
    800041ae:	20113423          	sd	ra,520(sp)
    800041b2:	20813023          	sd	s0,512(sp)
    800041b6:	ffa6                	sd	s1,504(sp)
    800041b8:	fbca                	sd	s2,496(sp)
    800041ba:	f7ce                	sd	s3,488(sp)
    800041bc:	f3d2                	sd	s4,480(sp)
    800041be:	efd6                	sd	s5,472(sp)
    800041c0:	ebda                	sd	s6,464(sp)
    800041c2:	e7de                	sd	s7,456(sp)
    800041c4:	e3e2                	sd	s8,448(sp)
    800041c6:	ff66                	sd	s9,440(sp)
    800041c8:	fb6a                	sd	s10,432(sp)
    800041ca:	f76e                	sd	s11,424(sp)
    800041cc:	0c00                	addi	s0,sp,528
    800041ce:	84aa                	mv	s1,a0
    800041d0:	dea43c23          	sd	a0,-520(s0)
    800041d4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	e92080e7          	jalr	-366(ra) # 8000106a <myproc>
    800041e0:	892a                	mv	s2,a0

  begin_op();
    800041e2:	fffff097          	auipc	ra,0xfffff
    800041e6:	49c080e7          	jalr	1180(ra) # 8000367e <begin_op>

  if((ip = namei(path)) == 0){
    800041ea:	8526                	mv	a0,s1
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	276080e7          	jalr	630(ra) # 80003462 <namei>
    800041f4:	c92d                	beqz	a0,80004266 <exec+0xbc>
    800041f6:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	ab4080e7          	jalr	-1356(ra) # 80002cac <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004200:	04000713          	li	a4,64
    80004204:	4681                	li	a3,0
    80004206:	e5040613          	addi	a2,s0,-432
    8000420a:	4581                	li	a1,0
    8000420c:	8526                	mv	a0,s1
    8000420e:	fffff097          	auipc	ra,0xfffff
    80004212:	d52080e7          	jalr	-686(ra) # 80002f60 <readi>
    80004216:	04000793          	li	a5,64
    8000421a:	00f51a63          	bne	a0,a5,8000422e <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000421e:	e5042703          	lw	a4,-432(s0)
    80004222:	464c47b7          	lui	a5,0x464c4
    80004226:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000422a:	04f70463          	beq	a4,a5,80004272 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000422e:	8526                	mv	a0,s1
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	cde080e7          	jalr	-802(ra) # 80002f0e <iunlockput>
    end_op();
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	4c6080e7          	jalr	1222(ra) # 800036fe <end_op>
  }
  return -1;
    80004240:	557d                	li	a0,-1
}
    80004242:	20813083          	ld	ra,520(sp)
    80004246:	20013403          	ld	s0,512(sp)
    8000424a:	74fe                	ld	s1,504(sp)
    8000424c:	795e                	ld	s2,496(sp)
    8000424e:	79be                	ld	s3,488(sp)
    80004250:	7a1e                	ld	s4,480(sp)
    80004252:	6afe                	ld	s5,472(sp)
    80004254:	6b5e                	ld	s6,464(sp)
    80004256:	6bbe                	ld	s7,456(sp)
    80004258:	6c1e                	ld	s8,448(sp)
    8000425a:	7cfa                	ld	s9,440(sp)
    8000425c:	7d5a                	ld	s10,432(sp)
    8000425e:	7dba                	ld	s11,424(sp)
    80004260:	21010113          	addi	sp,sp,528
    80004264:	8082                	ret
    end_op();
    80004266:	fffff097          	auipc	ra,0xfffff
    8000426a:	498080e7          	jalr	1176(ra) # 800036fe <end_op>
    return -1;
    8000426e:	557d                	li	a0,-1
    80004270:	bfc9                	j	80004242 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004272:	854a                	mv	a0,s2
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	eba080e7          	jalr	-326(ra) # 8000112e <proc_pagetable>
    8000427c:	8baa                	mv	s7,a0
    8000427e:	d945                	beqz	a0,8000422e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004280:	e7042983          	lw	s3,-400(s0)
    80004284:	e8845783          	lhu	a5,-376(s0)
    80004288:	c7ad                	beqz	a5,800042f2 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000428a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000428c:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000428e:	6c85                	lui	s9,0x1
    80004290:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004294:	def43823          	sd	a5,-528(s0)
    80004298:	a42d                	j	800044c2 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000429a:	00004517          	auipc	a0,0x4
    8000429e:	49650513          	addi	a0,a0,1174 # 80008730 <syscalls+0x280>
    800042a2:	00002097          	auipc	ra,0x2
    800042a6:	ab6080e7          	jalr	-1354(ra) # 80005d58 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042aa:	8756                	mv	a4,s5
    800042ac:	012d86bb          	addw	a3,s11,s2
    800042b0:	4581                	li	a1,0
    800042b2:	8526                	mv	a0,s1
    800042b4:	fffff097          	auipc	ra,0xfffff
    800042b8:	cac080e7          	jalr	-852(ra) # 80002f60 <readi>
    800042bc:	2501                	sext.w	a0,a0
    800042be:	1aaa9963          	bne	s5,a0,80004470 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800042c2:	6785                	lui	a5,0x1
    800042c4:	0127893b          	addw	s2,a5,s2
    800042c8:	77fd                	lui	a5,0xfffff
    800042ca:	01478a3b          	addw	s4,a5,s4
    800042ce:	1f897163          	bgeu	s2,s8,800044b0 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800042d2:	02091593          	slli	a1,s2,0x20
    800042d6:	9181                	srli	a1,a1,0x20
    800042d8:	95ea                	add	a1,a1,s10
    800042da:	855e                	mv	a0,s7
    800042dc:	ffffc097          	auipc	ra,0xffffc
    800042e0:	328080e7          	jalr	808(ra) # 80000604 <walkaddr>
    800042e4:	862a                	mv	a2,a0
    if(pa == 0)
    800042e6:	d955                	beqz	a0,8000429a <exec+0xf0>
      n = PGSIZE;
    800042e8:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042ea:	fd9a70e3          	bgeu	s4,s9,800042aa <exec+0x100>
      n = sz - i;
    800042ee:	8ad2                	mv	s5,s4
    800042f0:	bf6d                	j	800042aa <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042f2:	4901                	li	s2,0
  iunlockput(ip);
    800042f4:	8526                	mv	a0,s1
    800042f6:	fffff097          	auipc	ra,0xfffff
    800042fa:	c18080e7          	jalr	-1000(ra) # 80002f0e <iunlockput>
  end_op();
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	400080e7          	jalr	1024(ra) # 800036fe <end_op>
  p = myproc();
    80004306:	ffffd097          	auipc	ra,0xffffd
    8000430a:	d64080e7          	jalr	-668(ra) # 8000106a <myproc>
    8000430e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004310:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004314:	6785                	lui	a5,0x1
    80004316:	17fd                	addi	a5,a5,-1
    80004318:	993e                	add	s2,s2,a5
    8000431a:	757d                	lui	a0,0xfffff
    8000431c:	00a977b3          	and	a5,s2,a0
    80004320:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004324:	6609                	lui	a2,0x2
    80004326:	963e                	add	a2,a2,a5
    80004328:	85be                	mv	a1,a5
    8000432a:	855e                	mv	a0,s7
    8000432c:	ffffc097          	auipc	ra,0xffffc
    80004330:	68c080e7          	jalr	1676(ra) # 800009b8 <uvmalloc>
    80004334:	8b2a                	mv	s6,a0
  ip = 0;
    80004336:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004338:	12050c63          	beqz	a0,80004470 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000433c:	75f9                	lui	a1,0xffffe
    8000433e:	95aa                	add	a1,a1,a0
    80004340:	855e                	mv	a0,s7
    80004342:	ffffd097          	auipc	ra,0xffffd
    80004346:	87e080e7          	jalr	-1922(ra) # 80000bc0 <uvmclear>
  stackbase = sp - PGSIZE;
    8000434a:	7c7d                	lui	s8,0xfffff
    8000434c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000434e:	e0043783          	ld	a5,-512(s0)
    80004352:	6388                	ld	a0,0(a5)
    80004354:	c535                	beqz	a0,800043c0 <exec+0x216>
    80004356:	e9040993          	addi	s3,s0,-368
    8000435a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000435e:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	09a080e7          	jalr	154(ra) # 800003fa <strlen>
    80004368:	2505                	addiw	a0,a0,1
    8000436a:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000436e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004372:	13896363          	bltu	s2,s8,80004498 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004376:	e0043d83          	ld	s11,-512(s0)
    8000437a:	000dba03          	ld	s4,0(s11)
    8000437e:	8552                	mv	a0,s4
    80004380:	ffffc097          	auipc	ra,0xffffc
    80004384:	07a080e7          	jalr	122(ra) # 800003fa <strlen>
    80004388:	0015069b          	addiw	a3,a0,1
    8000438c:	8652                	mv	a2,s4
    8000438e:	85ca                	mv	a1,s2
    80004390:	855e                	mv	a0,s7
    80004392:	ffffd097          	auipc	ra,0xffffd
    80004396:	a68080e7          	jalr	-1432(ra) # 80000dfa <copyout>
    8000439a:	10054363          	bltz	a0,800044a0 <exec+0x2f6>
    ustack[argc] = sp;
    8000439e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043a2:	0485                	addi	s1,s1,1
    800043a4:	008d8793          	addi	a5,s11,8
    800043a8:	e0f43023          	sd	a5,-512(s0)
    800043ac:	008db503          	ld	a0,8(s11)
    800043b0:	c911                	beqz	a0,800043c4 <exec+0x21a>
    if(argc >= MAXARG)
    800043b2:	09a1                	addi	s3,s3,8
    800043b4:	fb3c96e3          	bne	s9,s3,80004360 <exec+0x1b6>
  sz = sz1;
    800043b8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043bc:	4481                	li	s1,0
    800043be:	a84d                	j	80004470 <exec+0x2c6>
  sp = sz;
    800043c0:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043c2:	4481                	li	s1,0
  ustack[argc] = 0;
    800043c4:	00349793          	slli	a5,s1,0x3
    800043c8:	f9040713          	addi	a4,s0,-112
    800043cc:	97ba                	add	a5,a5,a4
    800043ce:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043d2:	00148693          	addi	a3,s1,1
    800043d6:	068e                	slli	a3,a3,0x3
    800043d8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043dc:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043e0:	01897663          	bgeu	s2,s8,800043ec <exec+0x242>
  sz = sz1;
    800043e4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e8:	4481                	li	s1,0
    800043ea:	a059                	j	80004470 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ec:	e9040613          	addi	a2,s0,-368
    800043f0:	85ca                	mv	a1,s2
    800043f2:	855e                	mv	a0,s7
    800043f4:	ffffd097          	auipc	ra,0xffffd
    800043f8:	a06080e7          	jalr	-1530(ra) # 80000dfa <copyout>
    800043fc:	0a054663          	bltz	a0,800044a8 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004400:	058ab783          	ld	a5,88(s5)
    80004404:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004408:	df843783          	ld	a5,-520(s0)
    8000440c:	0007c703          	lbu	a4,0(a5)
    80004410:	cf11                	beqz	a4,8000442c <exec+0x282>
    80004412:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004414:	02f00693          	li	a3,47
    80004418:	a039                	j	80004426 <exec+0x27c>
      last = s+1;
    8000441a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000441e:	0785                	addi	a5,a5,1
    80004420:	fff7c703          	lbu	a4,-1(a5)
    80004424:	c701                	beqz	a4,8000442c <exec+0x282>
    if(*s == '/')
    80004426:	fed71ce3          	bne	a4,a3,8000441e <exec+0x274>
    8000442a:	bfc5                	j	8000441a <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000442c:	4641                	li	a2,16
    8000442e:	df843583          	ld	a1,-520(s0)
    80004432:	158a8513          	addi	a0,s5,344
    80004436:	ffffc097          	auipc	ra,0xffffc
    8000443a:	f92080e7          	jalr	-110(ra) # 800003c8 <safestrcpy>
  oldpagetable = p->pagetable;
    8000443e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004442:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004446:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000444a:	058ab783          	ld	a5,88(s5)
    8000444e:	e6843703          	ld	a4,-408(s0)
    80004452:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004454:	058ab783          	ld	a5,88(s5)
    80004458:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000445c:	85ea                	mv	a1,s10
    8000445e:	ffffd097          	auipc	ra,0xffffd
    80004462:	d6c080e7          	jalr	-660(ra) # 800011ca <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004466:	0004851b          	sext.w	a0,s1
    8000446a:	bbe1                	j	80004242 <exec+0x98>
    8000446c:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004470:	e0843583          	ld	a1,-504(s0)
    80004474:	855e                	mv	a0,s7
    80004476:	ffffd097          	auipc	ra,0xffffd
    8000447a:	d54080e7          	jalr	-684(ra) # 800011ca <proc_freepagetable>
  if(ip){
    8000447e:	da0498e3          	bnez	s1,8000422e <exec+0x84>
  return -1;
    80004482:	557d                	li	a0,-1
    80004484:	bb7d                	j	80004242 <exec+0x98>
    80004486:	e1243423          	sd	s2,-504(s0)
    8000448a:	b7dd                	j	80004470 <exec+0x2c6>
    8000448c:	e1243423          	sd	s2,-504(s0)
    80004490:	b7c5                	j	80004470 <exec+0x2c6>
    80004492:	e1243423          	sd	s2,-504(s0)
    80004496:	bfe9                	j	80004470 <exec+0x2c6>
  sz = sz1;
    80004498:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000449c:	4481                	li	s1,0
    8000449e:	bfc9                	j	80004470 <exec+0x2c6>
  sz = sz1;
    800044a0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044a4:	4481                	li	s1,0
    800044a6:	b7e9                	j	80004470 <exec+0x2c6>
  sz = sz1;
    800044a8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ac:	4481                	li	s1,0
    800044ae:	b7c9                	j	80004470 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044b0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044b4:	2b05                	addiw	s6,s6,1
    800044b6:	0389899b          	addiw	s3,s3,56
    800044ba:	e8845783          	lhu	a5,-376(s0)
    800044be:	e2fb5be3          	bge	s6,a5,800042f4 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044c2:	2981                	sext.w	s3,s3
    800044c4:	03800713          	li	a4,56
    800044c8:	86ce                	mv	a3,s3
    800044ca:	e1840613          	addi	a2,s0,-488
    800044ce:	4581                	li	a1,0
    800044d0:	8526                	mv	a0,s1
    800044d2:	fffff097          	auipc	ra,0xfffff
    800044d6:	a8e080e7          	jalr	-1394(ra) # 80002f60 <readi>
    800044da:	03800793          	li	a5,56
    800044de:	f8f517e3          	bne	a0,a5,8000446c <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800044e2:	e1842783          	lw	a5,-488(s0)
    800044e6:	4705                	li	a4,1
    800044e8:	fce796e3          	bne	a5,a4,800044b4 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800044ec:	e4043603          	ld	a2,-448(s0)
    800044f0:	e3843783          	ld	a5,-456(s0)
    800044f4:	f8f669e3          	bltu	a2,a5,80004486 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044f8:	e2843783          	ld	a5,-472(s0)
    800044fc:	963e                	add	a2,a2,a5
    800044fe:	f8f667e3          	bltu	a2,a5,8000448c <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004502:	85ca                	mv	a1,s2
    80004504:	855e                	mv	a0,s7
    80004506:	ffffc097          	auipc	ra,0xffffc
    8000450a:	4b2080e7          	jalr	1202(ra) # 800009b8 <uvmalloc>
    8000450e:	e0a43423          	sd	a0,-504(s0)
    80004512:	d141                	beqz	a0,80004492 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004514:	e2843d03          	ld	s10,-472(s0)
    80004518:	df043783          	ld	a5,-528(s0)
    8000451c:	00fd77b3          	and	a5,s10,a5
    80004520:	fba1                	bnez	a5,80004470 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004522:	e2042d83          	lw	s11,-480(s0)
    80004526:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000452a:	f80c03e3          	beqz	s8,800044b0 <exec+0x306>
    8000452e:	8a62                	mv	s4,s8
    80004530:	4901                	li	s2,0
    80004532:	b345                	j	800042d2 <exec+0x128>

0000000080004534 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004534:	7179                	addi	sp,sp,-48
    80004536:	f406                	sd	ra,40(sp)
    80004538:	f022                	sd	s0,32(sp)
    8000453a:	ec26                	sd	s1,24(sp)
    8000453c:	e84a                	sd	s2,16(sp)
    8000453e:	1800                	addi	s0,sp,48
    80004540:	892e                	mv	s2,a1
    80004542:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004544:	fdc40593          	addi	a1,s0,-36
    80004548:	ffffe097          	auipc	ra,0xffffe
    8000454c:	bf2080e7          	jalr	-1038(ra) # 8000213a <argint>
    80004550:	04054063          	bltz	a0,80004590 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004554:	fdc42703          	lw	a4,-36(s0)
    80004558:	47bd                	li	a5,15
    8000455a:	02e7ed63          	bltu	a5,a4,80004594 <argfd+0x60>
    8000455e:	ffffd097          	auipc	ra,0xffffd
    80004562:	b0c080e7          	jalr	-1268(ra) # 8000106a <myproc>
    80004566:	fdc42703          	lw	a4,-36(s0)
    8000456a:	01a70793          	addi	a5,a4,26
    8000456e:	078e                	slli	a5,a5,0x3
    80004570:	953e                	add	a0,a0,a5
    80004572:	611c                	ld	a5,0(a0)
    80004574:	c395                	beqz	a5,80004598 <argfd+0x64>
    return -1;
  if(pfd)
    80004576:	00090463          	beqz	s2,8000457e <argfd+0x4a>
    *pfd = fd;
    8000457a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000457e:	4501                	li	a0,0
  if(pf)
    80004580:	c091                	beqz	s1,80004584 <argfd+0x50>
    *pf = f;
    80004582:	e09c                	sd	a5,0(s1)
}
    80004584:	70a2                	ld	ra,40(sp)
    80004586:	7402                	ld	s0,32(sp)
    80004588:	64e2                	ld	s1,24(sp)
    8000458a:	6942                	ld	s2,16(sp)
    8000458c:	6145                	addi	sp,sp,48
    8000458e:	8082                	ret
    return -1;
    80004590:	557d                	li	a0,-1
    80004592:	bfcd                	j	80004584 <argfd+0x50>
    return -1;
    80004594:	557d                	li	a0,-1
    80004596:	b7fd                	j	80004584 <argfd+0x50>
    80004598:	557d                	li	a0,-1
    8000459a:	b7ed                	j	80004584 <argfd+0x50>

000000008000459c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000459c:	1101                	addi	sp,sp,-32
    8000459e:	ec06                	sd	ra,24(sp)
    800045a0:	e822                	sd	s0,16(sp)
    800045a2:	e426                	sd	s1,8(sp)
    800045a4:	1000                	addi	s0,sp,32
    800045a6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045a8:	ffffd097          	auipc	ra,0xffffd
    800045ac:	ac2080e7          	jalr	-1342(ra) # 8000106a <myproc>
    800045b0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045b2:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fdb8e90>
    800045b6:	4501                	li	a0,0
    800045b8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045ba:	6398                	ld	a4,0(a5)
    800045bc:	cb19                	beqz	a4,800045d2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045be:	2505                	addiw	a0,a0,1
    800045c0:	07a1                	addi	a5,a5,8
    800045c2:	fed51ce3          	bne	a0,a3,800045ba <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045c6:	557d                	li	a0,-1
}
    800045c8:	60e2                	ld	ra,24(sp)
    800045ca:	6442                	ld	s0,16(sp)
    800045cc:	64a2                	ld	s1,8(sp)
    800045ce:	6105                	addi	sp,sp,32
    800045d0:	8082                	ret
      p->ofile[fd] = f;
    800045d2:	01a50793          	addi	a5,a0,26
    800045d6:	078e                	slli	a5,a5,0x3
    800045d8:	963e                	add	a2,a2,a5
    800045da:	e204                	sd	s1,0(a2)
      return fd;
    800045dc:	b7f5                	j	800045c8 <fdalloc+0x2c>

00000000800045de <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045de:	715d                	addi	sp,sp,-80
    800045e0:	e486                	sd	ra,72(sp)
    800045e2:	e0a2                	sd	s0,64(sp)
    800045e4:	fc26                	sd	s1,56(sp)
    800045e6:	f84a                	sd	s2,48(sp)
    800045e8:	f44e                	sd	s3,40(sp)
    800045ea:	f052                	sd	s4,32(sp)
    800045ec:	ec56                	sd	s5,24(sp)
    800045ee:	0880                	addi	s0,sp,80
    800045f0:	89ae                	mv	s3,a1
    800045f2:	8ab2                	mv	s5,a2
    800045f4:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045f6:	fb040593          	addi	a1,s0,-80
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	e86080e7          	jalr	-378(ra) # 80003480 <nameiparent>
    80004602:	892a                	mv	s2,a0
    80004604:	12050f63          	beqz	a0,80004742 <create+0x164>
    return 0;

  ilock(dp);
    80004608:	ffffe097          	auipc	ra,0xffffe
    8000460c:	6a4080e7          	jalr	1700(ra) # 80002cac <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004610:	4601                	li	a2,0
    80004612:	fb040593          	addi	a1,s0,-80
    80004616:	854a                	mv	a0,s2
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	b78080e7          	jalr	-1160(ra) # 80003190 <dirlookup>
    80004620:	84aa                	mv	s1,a0
    80004622:	c921                	beqz	a0,80004672 <create+0x94>
    iunlockput(dp);
    80004624:	854a                	mv	a0,s2
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	8e8080e7          	jalr	-1816(ra) # 80002f0e <iunlockput>
    ilock(ip);
    8000462e:	8526                	mv	a0,s1
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	67c080e7          	jalr	1660(ra) # 80002cac <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004638:	2981                	sext.w	s3,s3
    8000463a:	4789                	li	a5,2
    8000463c:	02f99463          	bne	s3,a5,80004664 <create+0x86>
    80004640:	0444d783          	lhu	a5,68(s1)
    80004644:	37f9                	addiw	a5,a5,-2
    80004646:	17c2                	slli	a5,a5,0x30
    80004648:	93c1                	srli	a5,a5,0x30
    8000464a:	4705                	li	a4,1
    8000464c:	00f76c63          	bltu	a4,a5,80004664 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004650:	8526                	mv	a0,s1
    80004652:	60a6                	ld	ra,72(sp)
    80004654:	6406                	ld	s0,64(sp)
    80004656:	74e2                	ld	s1,56(sp)
    80004658:	7942                	ld	s2,48(sp)
    8000465a:	79a2                	ld	s3,40(sp)
    8000465c:	7a02                	ld	s4,32(sp)
    8000465e:	6ae2                	ld	s5,24(sp)
    80004660:	6161                	addi	sp,sp,80
    80004662:	8082                	ret
    iunlockput(ip);
    80004664:	8526                	mv	a0,s1
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	8a8080e7          	jalr	-1880(ra) # 80002f0e <iunlockput>
    return 0;
    8000466e:	4481                	li	s1,0
    80004670:	b7c5                	j	80004650 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004672:	85ce                	mv	a1,s3
    80004674:	00092503          	lw	a0,0(s2)
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	49c080e7          	jalr	1180(ra) # 80002b14 <ialloc>
    80004680:	84aa                	mv	s1,a0
    80004682:	c529                	beqz	a0,800046cc <create+0xee>
  ilock(ip);
    80004684:	ffffe097          	auipc	ra,0xffffe
    80004688:	628080e7          	jalr	1576(ra) # 80002cac <ilock>
  ip->major = major;
    8000468c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004690:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004694:	4785                	li	a5,1
    80004696:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000469a:	8526                	mv	a0,s1
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	546080e7          	jalr	1350(ra) # 80002be2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046a4:	2981                	sext.w	s3,s3
    800046a6:	4785                	li	a5,1
    800046a8:	02f98a63          	beq	s3,a5,800046dc <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046ac:	40d0                	lw	a2,4(s1)
    800046ae:	fb040593          	addi	a1,s0,-80
    800046b2:	854a                	mv	a0,s2
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	cec080e7          	jalr	-788(ra) # 800033a0 <dirlink>
    800046bc:	06054b63          	bltz	a0,80004732 <create+0x154>
  iunlockput(dp);
    800046c0:	854a                	mv	a0,s2
    800046c2:	fffff097          	auipc	ra,0xfffff
    800046c6:	84c080e7          	jalr	-1972(ra) # 80002f0e <iunlockput>
  return ip;
    800046ca:	b759                	j	80004650 <create+0x72>
    panic("create: ialloc");
    800046cc:	00004517          	auipc	a0,0x4
    800046d0:	08450513          	addi	a0,a0,132 # 80008750 <syscalls+0x2a0>
    800046d4:	00001097          	auipc	ra,0x1
    800046d8:	684080e7          	jalr	1668(ra) # 80005d58 <panic>
    dp->nlink++;  // for ".."
    800046dc:	04a95783          	lhu	a5,74(s2)
    800046e0:	2785                	addiw	a5,a5,1
    800046e2:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046e6:	854a                	mv	a0,s2
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	4fa080e7          	jalr	1274(ra) # 80002be2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046f0:	40d0                	lw	a2,4(s1)
    800046f2:	00004597          	auipc	a1,0x4
    800046f6:	06e58593          	addi	a1,a1,110 # 80008760 <syscalls+0x2b0>
    800046fa:	8526                	mv	a0,s1
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	ca4080e7          	jalr	-860(ra) # 800033a0 <dirlink>
    80004704:	00054f63          	bltz	a0,80004722 <create+0x144>
    80004708:	00492603          	lw	a2,4(s2)
    8000470c:	00004597          	auipc	a1,0x4
    80004710:	05c58593          	addi	a1,a1,92 # 80008768 <syscalls+0x2b8>
    80004714:	8526                	mv	a0,s1
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	c8a080e7          	jalr	-886(ra) # 800033a0 <dirlink>
    8000471e:	f80557e3          	bgez	a0,800046ac <create+0xce>
      panic("create dots");
    80004722:	00004517          	auipc	a0,0x4
    80004726:	04e50513          	addi	a0,a0,78 # 80008770 <syscalls+0x2c0>
    8000472a:	00001097          	auipc	ra,0x1
    8000472e:	62e080e7          	jalr	1582(ra) # 80005d58 <panic>
    panic("create: dirlink");
    80004732:	00004517          	auipc	a0,0x4
    80004736:	04e50513          	addi	a0,a0,78 # 80008780 <syscalls+0x2d0>
    8000473a:	00001097          	auipc	ra,0x1
    8000473e:	61e080e7          	jalr	1566(ra) # 80005d58 <panic>
    return 0;
    80004742:	84aa                	mv	s1,a0
    80004744:	b731                	j	80004650 <create+0x72>

0000000080004746 <sys_dup>:
{
    80004746:	7179                	addi	sp,sp,-48
    80004748:	f406                	sd	ra,40(sp)
    8000474a:	f022                	sd	s0,32(sp)
    8000474c:	ec26                	sd	s1,24(sp)
    8000474e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004750:	fd840613          	addi	a2,s0,-40
    80004754:	4581                	li	a1,0
    80004756:	4501                	li	a0,0
    80004758:	00000097          	auipc	ra,0x0
    8000475c:	ddc080e7          	jalr	-548(ra) # 80004534 <argfd>
    return -1;
    80004760:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004762:	02054363          	bltz	a0,80004788 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004766:	fd843503          	ld	a0,-40(s0)
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	e32080e7          	jalr	-462(ra) # 8000459c <fdalloc>
    80004772:	84aa                	mv	s1,a0
    return -1;
    80004774:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004776:	00054963          	bltz	a0,80004788 <sys_dup+0x42>
  filedup(f);
    8000477a:	fd843503          	ld	a0,-40(s0)
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	37a080e7          	jalr	890(ra) # 80003af8 <filedup>
  return fd;
    80004786:	87a6                	mv	a5,s1
}
    80004788:	853e                	mv	a0,a5
    8000478a:	70a2                	ld	ra,40(sp)
    8000478c:	7402                	ld	s0,32(sp)
    8000478e:	64e2                	ld	s1,24(sp)
    80004790:	6145                	addi	sp,sp,48
    80004792:	8082                	ret

0000000080004794 <sys_read>:
{
    80004794:	7179                	addi	sp,sp,-48
    80004796:	f406                	sd	ra,40(sp)
    80004798:	f022                	sd	s0,32(sp)
    8000479a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000479c:	fe840613          	addi	a2,s0,-24
    800047a0:	4581                	li	a1,0
    800047a2:	4501                	li	a0,0
    800047a4:	00000097          	auipc	ra,0x0
    800047a8:	d90080e7          	jalr	-624(ra) # 80004534 <argfd>
    return -1;
    800047ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ae:	04054163          	bltz	a0,800047f0 <sys_read+0x5c>
    800047b2:	fe440593          	addi	a1,s0,-28
    800047b6:	4509                	li	a0,2
    800047b8:	ffffe097          	auipc	ra,0xffffe
    800047bc:	982080e7          	jalr	-1662(ra) # 8000213a <argint>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047c2:	02054763          	bltz	a0,800047f0 <sys_read+0x5c>
    800047c6:	fd840593          	addi	a1,s0,-40
    800047ca:	4505                	li	a0,1
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	990080e7          	jalr	-1648(ra) # 8000215c <argaddr>
    return -1;
    800047d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d6:	00054d63          	bltz	a0,800047f0 <sys_read+0x5c>
  return fileread(f, p, n);
    800047da:	fe442603          	lw	a2,-28(s0)
    800047de:	fd843583          	ld	a1,-40(s0)
    800047e2:	fe843503          	ld	a0,-24(s0)
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	49e080e7          	jalr	1182(ra) # 80003c84 <fileread>
    800047ee:	87aa                	mv	a5,a0
}
    800047f0:	853e                	mv	a0,a5
    800047f2:	70a2                	ld	ra,40(sp)
    800047f4:	7402                	ld	s0,32(sp)
    800047f6:	6145                	addi	sp,sp,48
    800047f8:	8082                	ret

00000000800047fa <sys_write>:
{
    800047fa:	7179                	addi	sp,sp,-48
    800047fc:	f406                	sd	ra,40(sp)
    800047fe:	f022                	sd	s0,32(sp)
    80004800:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004802:	fe840613          	addi	a2,s0,-24
    80004806:	4581                	li	a1,0
    80004808:	4501                	li	a0,0
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	d2a080e7          	jalr	-726(ra) # 80004534 <argfd>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004814:	04054163          	bltz	a0,80004856 <sys_write+0x5c>
    80004818:	fe440593          	addi	a1,s0,-28
    8000481c:	4509                	li	a0,2
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	91c080e7          	jalr	-1764(ra) # 8000213a <argint>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004828:	02054763          	bltz	a0,80004856 <sys_write+0x5c>
    8000482c:	fd840593          	addi	a1,s0,-40
    80004830:	4505                	li	a0,1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	92a080e7          	jalr	-1750(ra) # 8000215c <argaddr>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	00054d63          	bltz	a0,80004856 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004840:	fe442603          	lw	a2,-28(s0)
    80004844:	fd843583          	ld	a1,-40(s0)
    80004848:	fe843503          	ld	a0,-24(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	4fa080e7          	jalr	1274(ra) # 80003d46 <filewrite>
    80004854:	87aa                	mv	a5,a0
}
    80004856:	853e                	mv	a0,a5
    80004858:	70a2                	ld	ra,40(sp)
    8000485a:	7402                	ld	s0,32(sp)
    8000485c:	6145                	addi	sp,sp,48
    8000485e:	8082                	ret

0000000080004860 <sys_close>:
{
    80004860:	1101                	addi	sp,sp,-32
    80004862:	ec06                	sd	ra,24(sp)
    80004864:	e822                	sd	s0,16(sp)
    80004866:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004868:	fe040613          	addi	a2,s0,-32
    8000486c:	fec40593          	addi	a1,s0,-20
    80004870:	4501                	li	a0,0
    80004872:	00000097          	auipc	ra,0x0
    80004876:	cc2080e7          	jalr	-830(ra) # 80004534 <argfd>
    return -1;
    8000487a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000487c:	02054463          	bltz	a0,800048a4 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004880:	ffffc097          	auipc	ra,0xffffc
    80004884:	7ea080e7          	jalr	2026(ra) # 8000106a <myproc>
    80004888:	fec42783          	lw	a5,-20(s0)
    8000488c:	07e9                	addi	a5,a5,26
    8000488e:	078e                	slli	a5,a5,0x3
    80004890:	97aa                	add	a5,a5,a0
    80004892:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004896:	fe043503          	ld	a0,-32(s0)
    8000489a:	fffff097          	auipc	ra,0xfffff
    8000489e:	2b0080e7          	jalr	688(ra) # 80003b4a <fileclose>
  return 0;
    800048a2:	4781                	li	a5,0
}
    800048a4:	853e                	mv	a0,a5
    800048a6:	60e2                	ld	ra,24(sp)
    800048a8:	6442                	ld	s0,16(sp)
    800048aa:	6105                	addi	sp,sp,32
    800048ac:	8082                	ret

00000000800048ae <sys_fstat>:
{
    800048ae:	1101                	addi	sp,sp,-32
    800048b0:	ec06                	sd	ra,24(sp)
    800048b2:	e822                	sd	s0,16(sp)
    800048b4:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048b6:	fe840613          	addi	a2,s0,-24
    800048ba:	4581                	li	a1,0
    800048bc:	4501                	li	a0,0
    800048be:	00000097          	auipc	ra,0x0
    800048c2:	c76080e7          	jalr	-906(ra) # 80004534 <argfd>
    return -1;
    800048c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048c8:	02054563          	bltz	a0,800048f2 <sys_fstat+0x44>
    800048cc:	fe040593          	addi	a1,s0,-32
    800048d0:	4505                	li	a0,1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	88a080e7          	jalr	-1910(ra) # 8000215c <argaddr>
    return -1;
    800048da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048dc:	00054b63          	bltz	a0,800048f2 <sys_fstat+0x44>
  return filestat(f, st);
    800048e0:	fe043583          	ld	a1,-32(s0)
    800048e4:	fe843503          	ld	a0,-24(s0)
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	32a080e7          	jalr	810(ra) # 80003c12 <filestat>
    800048f0:	87aa                	mv	a5,a0
}
    800048f2:	853e                	mv	a0,a5
    800048f4:	60e2                	ld	ra,24(sp)
    800048f6:	6442                	ld	s0,16(sp)
    800048f8:	6105                	addi	sp,sp,32
    800048fa:	8082                	ret

00000000800048fc <sys_link>:
{
    800048fc:	7169                	addi	sp,sp,-304
    800048fe:	f606                	sd	ra,296(sp)
    80004900:	f222                	sd	s0,288(sp)
    80004902:	ee26                	sd	s1,280(sp)
    80004904:	ea4a                	sd	s2,272(sp)
    80004906:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004908:	08000613          	li	a2,128
    8000490c:	ed040593          	addi	a1,s0,-304
    80004910:	4501                	li	a0,0
    80004912:	ffffe097          	auipc	ra,0xffffe
    80004916:	86c080e7          	jalr	-1940(ra) # 8000217e <argstr>
    return -1;
    8000491a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000491c:	10054e63          	bltz	a0,80004a38 <sys_link+0x13c>
    80004920:	08000613          	li	a2,128
    80004924:	f5040593          	addi	a1,s0,-176
    80004928:	4505                	li	a0,1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	854080e7          	jalr	-1964(ra) # 8000217e <argstr>
    return -1;
    80004932:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004934:	10054263          	bltz	a0,80004a38 <sys_link+0x13c>
  begin_op();
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	d46080e7          	jalr	-698(ra) # 8000367e <begin_op>
  if((ip = namei(old)) == 0){
    80004940:	ed040513          	addi	a0,s0,-304
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	b1e080e7          	jalr	-1250(ra) # 80003462 <namei>
    8000494c:	84aa                	mv	s1,a0
    8000494e:	c551                	beqz	a0,800049da <sys_link+0xde>
  ilock(ip);
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	35c080e7          	jalr	860(ra) # 80002cac <ilock>
  if(ip->type == T_DIR){
    80004958:	04449703          	lh	a4,68(s1)
    8000495c:	4785                	li	a5,1
    8000495e:	08f70463          	beq	a4,a5,800049e6 <sys_link+0xea>
  ip->nlink++;
    80004962:	04a4d783          	lhu	a5,74(s1)
    80004966:	2785                	addiw	a5,a5,1
    80004968:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	274080e7          	jalr	628(ra) # 80002be2 <iupdate>
  iunlock(ip);
    80004976:	8526                	mv	a0,s1
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	3f6080e7          	jalr	1014(ra) # 80002d6e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004980:	fd040593          	addi	a1,s0,-48
    80004984:	f5040513          	addi	a0,s0,-176
    80004988:	fffff097          	auipc	ra,0xfffff
    8000498c:	af8080e7          	jalr	-1288(ra) # 80003480 <nameiparent>
    80004990:	892a                	mv	s2,a0
    80004992:	c935                	beqz	a0,80004a06 <sys_link+0x10a>
  ilock(dp);
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	318080e7          	jalr	792(ra) # 80002cac <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000499c:	00092703          	lw	a4,0(s2)
    800049a0:	409c                	lw	a5,0(s1)
    800049a2:	04f71d63          	bne	a4,a5,800049fc <sys_link+0x100>
    800049a6:	40d0                	lw	a2,4(s1)
    800049a8:	fd040593          	addi	a1,s0,-48
    800049ac:	854a                	mv	a0,s2
    800049ae:	fffff097          	auipc	ra,0xfffff
    800049b2:	9f2080e7          	jalr	-1550(ra) # 800033a0 <dirlink>
    800049b6:	04054363          	bltz	a0,800049fc <sys_link+0x100>
  iunlockput(dp);
    800049ba:	854a                	mv	a0,s2
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	552080e7          	jalr	1362(ra) # 80002f0e <iunlockput>
  iput(ip);
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	4a0080e7          	jalr	1184(ra) # 80002e66 <iput>
  end_op();
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	d30080e7          	jalr	-720(ra) # 800036fe <end_op>
  return 0;
    800049d6:	4781                	li	a5,0
    800049d8:	a085                	j	80004a38 <sys_link+0x13c>
    end_op();
    800049da:	fffff097          	auipc	ra,0xfffff
    800049de:	d24080e7          	jalr	-732(ra) # 800036fe <end_op>
    return -1;
    800049e2:	57fd                	li	a5,-1
    800049e4:	a891                	j	80004a38 <sys_link+0x13c>
    iunlockput(ip);
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	526080e7          	jalr	1318(ra) # 80002f0e <iunlockput>
    end_op();
    800049f0:	fffff097          	auipc	ra,0xfffff
    800049f4:	d0e080e7          	jalr	-754(ra) # 800036fe <end_op>
    return -1;
    800049f8:	57fd                	li	a5,-1
    800049fa:	a83d                	j	80004a38 <sys_link+0x13c>
    iunlockput(dp);
    800049fc:	854a                	mv	a0,s2
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	510080e7          	jalr	1296(ra) # 80002f0e <iunlockput>
  ilock(ip);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	2a4080e7          	jalr	676(ra) # 80002cac <ilock>
  ip->nlink--;
    80004a10:	04a4d783          	lhu	a5,74(s1)
    80004a14:	37fd                	addiw	a5,a5,-1
    80004a16:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	1c6080e7          	jalr	454(ra) # 80002be2 <iupdate>
  iunlockput(ip);
    80004a24:	8526                	mv	a0,s1
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	4e8080e7          	jalr	1256(ra) # 80002f0e <iunlockput>
  end_op();
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	cd0080e7          	jalr	-816(ra) # 800036fe <end_op>
  return -1;
    80004a36:	57fd                	li	a5,-1
}
    80004a38:	853e                	mv	a0,a5
    80004a3a:	70b2                	ld	ra,296(sp)
    80004a3c:	7412                	ld	s0,288(sp)
    80004a3e:	64f2                	ld	s1,280(sp)
    80004a40:	6952                	ld	s2,272(sp)
    80004a42:	6155                	addi	sp,sp,304
    80004a44:	8082                	ret

0000000080004a46 <sys_unlink>:
{
    80004a46:	7151                	addi	sp,sp,-240
    80004a48:	f586                	sd	ra,232(sp)
    80004a4a:	f1a2                	sd	s0,224(sp)
    80004a4c:	eda6                	sd	s1,216(sp)
    80004a4e:	e9ca                	sd	s2,208(sp)
    80004a50:	e5ce                	sd	s3,200(sp)
    80004a52:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a54:	08000613          	li	a2,128
    80004a58:	f3040593          	addi	a1,s0,-208
    80004a5c:	4501                	li	a0,0
    80004a5e:	ffffd097          	auipc	ra,0xffffd
    80004a62:	720080e7          	jalr	1824(ra) # 8000217e <argstr>
    80004a66:	18054163          	bltz	a0,80004be8 <sys_unlink+0x1a2>
  begin_op();
    80004a6a:	fffff097          	auipc	ra,0xfffff
    80004a6e:	c14080e7          	jalr	-1004(ra) # 8000367e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a72:	fb040593          	addi	a1,s0,-80
    80004a76:	f3040513          	addi	a0,s0,-208
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	a06080e7          	jalr	-1530(ra) # 80003480 <nameiparent>
    80004a82:	84aa                	mv	s1,a0
    80004a84:	c979                	beqz	a0,80004b5a <sys_unlink+0x114>
  ilock(dp);
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	226080e7          	jalr	550(ra) # 80002cac <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a8e:	00004597          	auipc	a1,0x4
    80004a92:	cd258593          	addi	a1,a1,-814 # 80008760 <syscalls+0x2b0>
    80004a96:	fb040513          	addi	a0,s0,-80
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	6dc080e7          	jalr	1756(ra) # 80003176 <namecmp>
    80004aa2:	14050a63          	beqz	a0,80004bf6 <sys_unlink+0x1b0>
    80004aa6:	00004597          	auipc	a1,0x4
    80004aaa:	cc258593          	addi	a1,a1,-830 # 80008768 <syscalls+0x2b8>
    80004aae:	fb040513          	addi	a0,s0,-80
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	6c4080e7          	jalr	1732(ra) # 80003176 <namecmp>
    80004aba:	12050e63          	beqz	a0,80004bf6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004abe:	f2c40613          	addi	a2,s0,-212
    80004ac2:	fb040593          	addi	a1,s0,-80
    80004ac6:	8526                	mv	a0,s1
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	6c8080e7          	jalr	1736(ra) # 80003190 <dirlookup>
    80004ad0:	892a                	mv	s2,a0
    80004ad2:	12050263          	beqz	a0,80004bf6 <sys_unlink+0x1b0>
  ilock(ip);
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	1d6080e7          	jalr	470(ra) # 80002cac <ilock>
  if(ip->nlink < 1)
    80004ade:	04a91783          	lh	a5,74(s2)
    80004ae2:	08f05263          	blez	a5,80004b66 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ae6:	04491703          	lh	a4,68(s2)
    80004aea:	4785                	li	a5,1
    80004aec:	08f70563          	beq	a4,a5,80004b76 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004af0:	4641                	li	a2,16
    80004af2:	4581                	li	a1,0
    80004af4:	fc040513          	addi	a0,s0,-64
    80004af8:	ffffb097          	auipc	ra,0xffffb
    80004afc:	77e080e7          	jalr	1918(ra) # 80000276 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b00:	4741                	li	a4,16
    80004b02:	f2c42683          	lw	a3,-212(s0)
    80004b06:	fc040613          	addi	a2,s0,-64
    80004b0a:	4581                	li	a1,0
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	54a080e7          	jalr	1354(ra) # 80003058 <writei>
    80004b16:	47c1                	li	a5,16
    80004b18:	0af51563          	bne	a0,a5,80004bc2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b1c:	04491703          	lh	a4,68(s2)
    80004b20:	4785                	li	a5,1
    80004b22:	0af70863          	beq	a4,a5,80004bd2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b26:	8526                	mv	a0,s1
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	3e6080e7          	jalr	998(ra) # 80002f0e <iunlockput>
  ip->nlink--;
    80004b30:	04a95783          	lhu	a5,74(s2)
    80004b34:	37fd                	addiw	a5,a5,-1
    80004b36:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	0a6080e7          	jalr	166(ra) # 80002be2 <iupdate>
  iunlockput(ip);
    80004b44:	854a                	mv	a0,s2
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	3c8080e7          	jalr	968(ra) # 80002f0e <iunlockput>
  end_op();
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	bb0080e7          	jalr	-1104(ra) # 800036fe <end_op>
  return 0;
    80004b56:	4501                	li	a0,0
    80004b58:	a84d                	j	80004c0a <sys_unlink+0x1c4>
    end_op();
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	ba4080e7          	jalr	-1116(ra) # 800036fe <end_op>
    return -1;
    80004b62:	557d                	li	a0,-1
    80004b64:	a05d                	j	80004c0a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b66:	00004517          	auipc	a0,0x4
    80004b6a:	c2a50513          	addi	a0,a0,-982 # 80008790 <syscalls+0x2e0>
    80004b6e:	00001097          	auipc	ra,0x1
    80004b72:	1ea080e7          	jalr	490(ra) # 80005d58 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b76:	04c92703          	lw	a4,76(s2)
    80004b7a:	02000793          	li	a5,32
    80004b7e:	f6e7f9e3          	bgeu	a5,a4,80004af0 <sys_unlink+0xaa>
    80004b82:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b86:	4741                	li	a4,16
    80004b88:	86ce                	mv	a3,s3
    80004b8a:	f1840613          	addi	a2,s0,-232
    80004b8e:	4581                	li	a1,0
    80004b90:	854a                	mv	a0,s2
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	3ce080e7          	jalr	974(ra) # 80002f60 <readi>
    80004b9a:	47c1                	li	a5,16
    80004b9c:	00f51b63          	bne	a0,a5,80004bb2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ba0:	f1845783          	lhu	a5,-232(s0)
    80004ba4:	e7a1                	bnez	a5,80004bec <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ba6:	29c1                	addiw	s3,s3,16
    80004ba8:	04c92783          	lw	a5,76(s2)
    80004bac:	fcf9ede3          	bltu	s3,a5,80004b86 <sys_unlink+0x140>
    80004bb0:	b781                	j	80004af0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bb2:	00004517          	auipc	a0,0x4
    80004bb6:	bf650513          	addi	a0,a0,-1034 # 800087a8 <syscalls+0x2f8>
    80004bba:	00001097          	auipc	ra,0x1
    80004bbe:	19e080e7          	jalr	414(ra) # 80005d58 <panic>
    panic("unlink: writei");
    80004bc2:	00004517          	auipc	a0,0x4
    80004bc6:	bfe50513          	addi	a0,a0,-1026 # 800087c0 <syscalls+0x310>
    80004bca:	00001097          	auipc	ra,0x1
    80004bce:	18e080e7          	jalr	398(ra) # 80005d58 <panic>
    dp->nlink--;
    80004bd2:	04a4d783          	lhu	a5,74(s1)
    80004bd6:	37fd                	addiw	a5,a5,-1
    80004bd8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bdc:	8526                	mv	a0,s1
    80004bde:	ffffe097          	auipc	ra,0xffffe
    80004be2:	004080e7          	jalr	4(ra) # 80002be2 <iupdate>
    80004be6:	b781                	j	80004b26 <sys_unlink+0xe0>
    return -1;
    80004be8:	557d                	li	a0,-1
    80004bea:	a005                	j	80004c0a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004bec:	854a                	mv	a0,s2
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	320080e7          	jalr	800(ra) # 80002f0e <iunlockput>
  iunlockput(dp);
    80004bf6:	8526                	mv	a0,s1
    80004bf8:	ffffe097          	auipc	ra,0xffffe
    80004bfc:	316080e7          	jalr	790(ra) # 80002f0e <iunlockput>
  end_op();
    80004c00:	fffff097          	auipc	ra,0xfffff
    80004c04:	afe080e7          	jalr	-1282(ra) # 800036fe <end_op>
  return -1;
    80004c08:	557d                	li	a0,-1
}
    80004c0a:	70ae                	ld	ra,232(sp)
    80004c0c:	740e                	ld	s0,224(sp)
    80004c0e:	64ee                	ld	s1,216(sp)
    80004c10:	694e                	ld	s2,208(sp)
    80004c12:	69ae                	ld	s3,200(sp)
    80004c14:	616d                	addi	sp,sp,240
    80004c16:	8082                	ret

0000000080004c18 <sys_open>:

uint64
sys_open(void)
{
    80004c18:	7131                	addi	sp,sp,-192
    80004c1a:	fd06                	sd	ra,184(sp)
    80004c1c:	f922                	sd	s0,176(sp)
    80004c1e:	f526                	sd	s1,168(sp)
    80004c20:	f14a                	sd	s2,160(sp)
    80004c22:	ed4e                	sd	s3,152(sp)
    80004c24:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c26:	08000613          	li	a2,128
    80004c2a:	f5040593          	addi	a1,s0,-176
    80004c2e:	4501                	li	a0,0
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	54e080e7          	jalr	1358(ra) # 8000217e <argstr>
    return -1;
    80004c38:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c3a:	0c054163          	bltz	a0,80004cfc <sys_open+0xe4>
    80004c3e:	f4c40593          	addi	a1,s0,-180
    80004c42:	4505                	li	a0,1
    80004c44:	ffffd097          	auipc	ra,0xffffd
    80004c48:	4f6080e7          	jalr	1270(ra) # 8000213a <argint>
    80004c4c:	0a054863          	bltz	a0,80004cfc <sys_open+0xe4>

  begin_op();
    80004c50:	fffff097          	auipc	ra,0xfffff
    80004c54:	a2e080e7          	jalr	-1490(ra) # 8000367e <begin_op>

  if(omode & O_CREATE){
    80004c58:	f4c42783          	lw	a5,-180(s0)
    80004c5c:	2007f793          	andi	a5,a5,512
    80004c60:	cbdd                	beqz	a5,80004d16 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c62:	4681                	li	a3,0
    80004c64:	4601                	li	a2,0
    80004c66:	4589                	li	a1,2
    80004c68:	f5040513          	addi	a0,s0,-176
    80004c6c:	00000097          	auipc	ra,0x0
    80004c70:	972080e7          	jalr	-1678(ra) # 800045de <create>
    80004c74:	892a                	mv	s2,a0
    if(ip == 0){
    80004c76:	c959                	beqz	a0,80004d0c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c78:	04491703          	lh	a4,68(s2)
    80004c7c:	478d                	li	a5,3
    80004c7e:	00f71763          	bne	a4,a5,80004c8c <sys_open+0x74>
    80004c82:	04695703          	lhu	a4,70(s2)
    80004c86:	47a5                	li	a5,9
    80004c88:	0ce7ec63          	bltu	a5,a4,80004d60 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c8c:	fffff097          	auipc	ra,0xfffff
    80004c90:	e02080e7          	jalr	-510(ra) # 80003a8e <filealloc>
    80004c94:	89aa                	mv	s3,a0
    80004c96:	10050263          	beqz	a0,80004d9a <sys_open+0x182>
    80004c9a:	00000097          	auipc	ra,0x0
    80004c9e:	902080e7          	jalr	-1790(ra) # 8000459c <fdalloc>
    80004ca2:	84aa                	mv	s1,a0
    80004ca4:	0e054663          	bltz	a0,80004d90 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ca8:	04491703          	lh	a4,68(s2)
    80004cac:	478d                	li	a5,3
    80004cae:	0cf70463          	beq	a4,a5,80004d76 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cb2:	4789                	li	a5,2
    80004cb4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cb8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cbc:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cc0:	f4c42783          	lw	a5,-180(s0)
    80004cc4:	0017c713          	xori	a4,a5,1
    80004cc8:	8b05                	andi	a4,a4,1
    80004cca:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cce:	0037f713          	andi	a4,a5,3
    80004cd2:	00e03733          	snez	a4,a4
    80004cd6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cda:	4007f793          	andi	a5,a5,1024
    80004cde:	c791                	beqz	a5,80004cea <sys_open+0xd2>
    80004ce0:	04491703          	lh	a4,68(s2)
    80004ce4:	4789                	li	a5,2
    80004ce6:	08f70f63          	beq	a4,a5,80004d84 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cea:	854a                	mv	a0,s2
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	082080e7          	jalr	130(ra) # 80002d6e <iunlock>
  end_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	a0a080e7          	jalr	-1526(ra) # 800036fe <end_op>

  return fd;
}
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	70ea                	ld	ra,184(sp)
    80004d00:	744a                	ld	s0,176(sp)
    80004d02:	74aa                	ld	s1,168(sp)
    80004d04:	790a                	ld	s2,160(sp)
    80004d06:	69ea                	ld	s3,152(sp)
    80004d08:	6129                	addi	sp,sp,192
    80004d0a:	8082                	ret
      end_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	9f2080e7          	jalr	-1550(ra) # 800036fe <end_op>
      return -1;
    80004d14:	b7e5                	j	80004cfc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d16:	f5040513          	addi	a0,s0,-176
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	748080e7          	jalr	1864(ra) # 80003462 <namei>
    80004d22:	892a                	mv	s2,a0
    80004d24:	c905                	beqz	a0,80004d54 <sys_open+0x13c>
    ilock(ip);
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	f86080e7          	jalr	-122(ra) # 80002cac <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d2e:	04491703          	lh	a4,68(s2)
    80004d32:	4785                	li	a5,1
    80004d34:	f4f712e3          	bne	a4,a5,80004c78 <sys_open+0x60>
    80004d38:	f4c42783          	lw	a5,-180(s0)
    80004d3c:	dba1                	beqz	a5,80004c8c <sys_open+0x74>
      iunlockput(ip);
    80004d3e:	854a                	mv	a0,s2
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	1ce080e7          	jalr	462(ra) # 80002f0e <iunlockput>
      end_op();
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	9b6080e7          	jalr	-1610(ra) # 800036fe <end_op>
      return -1;
    80004d50:	54fd                	li	s1,-1
    80004d52:	b76d                	j	80004cfc <sys_open+0xe4>
      end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	9aa080e7          	jalr	-1622(ra) # 800036fe <end_op>
      return -1;
    80004d5c:	54fd                	li	s1,-1
    80004d5e:	bf79                	j	80004cfc <sys_open+0xe4>
    iunlockput(ip);
    80004d60:	854a                	mv	a0,s2
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	1ac080e7          	jalr	428(ra) # 80002f0e <iunlockput>
    end_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	994080e7          	jalr	-1644(ra) # 800036fe <end_op>
    return -1;
    80004d72:	54fd                	li	s1,-1
    80004d74:	b761                	j	80004cfc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d76:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d7a:	04691783          	lh	a5,70(s2)
    80004d7e:	02f99223          	sh	a5,36(s3)
    80004d82:	bf2d                	j	80004cbc <sys_open+0xa4>
    itrunc(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	034080e7          	jalr	52(ra) # 80002dba <itrunc>
    80004d8e:	bfb1                	j	80004cea <sys_open+0xd2>
      fileclose(f);
    80004d90:	854e                	mv	a0,s3
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	db8080e7          	jalr	-584(ra) # 80003b4a <fileclose>
    iunlockput(ip);
    80004d9a:	854a                	mv	a0,s2
    80004d9c:	ffffe097          	auipc	ra,0xffffe
    80004da0:	172080e7          	jalr	370(ra) # 80002f0e <iunlockput>
    end_op();
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	95a080e7          	jalr	-1702(ra) # 800036fe <end_op>
    return -1;
    80004dac:	54fd                	li	s1,-1
    80004dae:	b7b9                	j	80004cfc <sys_open+0xe4>

0000000080004db0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004db0:	7175                	addi	sp,sp,-144
    80004db2:	e506                	sd	ra,136(sp)
    80004db4:	e122                	sd	s0,128(sp)
    80004db6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	8c6080e7          	jalr	-1850(ra) # 8000367e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dc0:	08000613          	li	a2,128
    80004dc4:	f7040593          	addi	a1,s0,-144
    80004dc8:	4501                	li	a0,0
    80004dca:	ffffd097          	auipc	ra,0xffffd
    80004dce:	3b4080e7          	jalr	948(ra) # 8000217e <argstr>
    80004dd2:	02054963          	bltz	a0,80004e04 <sys_mkdir+0x54>
    80004dd6:	4681                	li	a3,0
    80004dd8:	4601                	li	a2,0
    80004dda:	4585                	li	a1,1
    80004ddc:	f7040513          	addi	a0,s0,-144
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	7fe080e7          	jalr	2046(ra) # 800045de <create>
    80004de8:	cd11                	beqz	a0,80004e04 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	124080e7          	jalr	292(ra) # 80002f0e <iunlockput>
  end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	90c080e7          	jalr	-1780(ra) # 800036fe <end_op>
  return 0;
    80004dfa:	4501                	li	a0,0
}
    80004dfc:	60aa                	ld	ra,136(sp)
    80004dfe:	640a                	ld	s0,128(sp)
    80004e00:	6149                	addi	sp,sp,144
    80004e02:	8082                	ret
    end_op();
    80004e04:	fffff097          	auipc	ra,0xfffff
    80004e08:	8fa080e7          	jalr	-1798(ra) # 800036fe <end_op>
    return -1;
    80004e0c:	557d                	li	a0,-1
    80004e0e:	b7fd                	j	80004dfc <sys_mkdir+0x4c>

0000000080004e10 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e10:	7135                	addi	sp,sp,-160
    80004e12:	ed06                	sd	ra,152(sp)
    80004e14:	e922                	sd	s0,144(sp)
    80004e16:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	866080e7          	jalr	-1946(ra) # 8000367e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e20:	08000613          	li	a2,128
    80004e24:	f7040593          	addi	a1,s0,-144
    80004e28:	4501                	li	a0,0
    80004e2a:	ffffd097          	auipc	ra,0xffffd
    80004e2e:	354080e7          	jalr	852(ra) # 8000217e <argstr>
    80004e32:	04054a63          	bltz	a0,80004e86 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e36:	f6c40593          	addi	a1,s0,-148
    80004e3a:	4505                	li	a0,1
    80004e3c:	ffffd097          	auipc	ra,0xffffd
    80004e40:	2fe080e7          	jalr	766(ra) # 8000213a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e44:	04054163          	bltz	a0,80004e86 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e48:	f6840593          	addi	a1,s0,-152
    80004e4c:	4509                	li	a0,2
    80004e4e:	ffffd097          	auipc	ra,0xffffd
    80004e52:	2ec080e7          	jalr	748(ra) # 8000213a <argint>
     argint(1, &major) < 0 ||
    80004e56:	02054863          	bltz	a0,80004e86 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e5a:	f6841683          	lh	a3,-152(s0)
    80004e5e:	f6c41603          	lh	a2,-148(s0)
    80004e62:	458d                	li	a1,3
    80004e64:	f7040513          	addi	a0,s0,-144
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	776080e7          	jalr	1910(ra) # 800045de <create>
     argint(2, &minor) < 0 ||
    80004e70:	c919                	beqz	a0,80004e86 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	09c080e7          	jalr	156(ra) # 80002f0e <iunlockput>
  end_op();
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	884080e7          	jalr	-1916(ra) # 800036fe <end_op>
  return 0;
    80004e82:	4501                	li	a0,0
    80004e84:	a031                	j	80004e90 <sys_mknod+0x80>
    end_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	878080e7          	jalr	-1928(ra) # 800036fe <end_op>
    return -1;
    80004e8e:	557d                	li	a0,-1
}
    80004e90:	60ea                	ld	ra,152(sp)
    80004e92:	644a                	ld	s0,144(sp)
    80004e94:	610d                	addi	sp,sp,160
    80004e96:	8082                	ret

0000000080004e98 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e98:	7135                	addi	sp,sp,-160
    80004e9a:	ed06                	sd	ra,152(sp)
    80004e9c:	e922                	sd	s0,144(sp)
    80004e9e:	e526                	sd	s1,136(sp)
    80004ea0:	e14a                	sd	s2,128(sp)
    80004ea2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ea4:	ffffc097          	auipc	ra,0xffffc
    80004ea8:	1c6080e7          	jalr	454(ra) # 8000106a <myproc>
    80004eac:	892a                	mv	s2,a0
  
  begin_op();
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	7d0080e7          	jalr	2000(ra) # 8000367e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eb6:	08000613          	li	a2,128
    80004eba:	f6040593          	addi	a1,s0,-160
    80004ebe:	4501                	li	a0,0
    80004ec0:	ffffd097          	auipc	ra,0xffffd
    80004ec4:	2be080e7          	jalr	702(ra) # 8000217e <argstr>
    80004ec8:	04054b63          	bltz	a0,80004f1e <sys_chdir+0x86>
    80004ecc:	f6040513          	addi	a0,s0,-160
    80004ed0:	ffffe097          	auipc	ra,0xffffe
    80004ed4:	592080e7          	jalr	1426(ra) # 80003462 <namei>
    80004ed8:	84aa                	mv	s1,a0
    80004eda:	c131                	beqz	a0,80004f1e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	dd0080e7          	jalr	-560(ra) # 80002cac <ilock>
  if(ip->type != T_DIR){
    80004ee4:	04449703          	lh	a4,68(s1)
    80004ee8:	4785                	li	a5,1
    80004eea:	04f71063          	bne	a4,a5,80004f2a <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eee:	8526                	mv	a0,s1
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	e7e080e7          	jalr	-386(ra) # 80002d6e <iunlock>
  iput(p->cwd);
    80004ef8:	15093503          	ld	a0,336(s2)
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	f6a080e7          	jalr	-150(ra) # 80002e66 <iput>
  end_op();
    80004f04:	ffffe097          	auipc	ra,0xffffe
    80004f08:	7fa080e7          	jalr	2042(ra) # 800036fe <end_op>
  p->cwd = ip;
    80004f0c:	14993823          	sd	s1,336(s2)
  return 0;
    80004f10:	4501                	li	a0,0
}
    80004f12:	60ea                	ld	ra,152(sp)
    80004f14:	644a                	ld	s0,144(sp)
    80004f16:	64aa                	ld	s1,136(sp)
    80004f18:	690a                	ld	s2,128(sp)
    80004f1a:	610d                	addi	sp,sp,160
    80004f1c:	8082                	ret
    end_op();
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	7e0080e7          	jalr	2016(ra) # 800036fe <end_op>
    return -1;
    80004f26:	557d                	li	a0,-1
    80004f28:	b7ed                	j	80004f12 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f2a:	8526                	mv	a0,s1
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	fe2080e7          	jalr	-30(ra) # 80002f0e <iunlockput>
    end_op();
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	7ca080e7          	jalr	1994(ra) # 800036fe <end_op>
    return -1;
    80004f3c:	557d                	li	a0,-1
    80004f3e:	bfd1                	j	80004f12 <sys_chdir+0x7a>

0000000080004f40 <sys_exec>:

uint64
sys_exec(void)
{
    80004f40:	7145                	addi	sp,sp,-464
    80004f42:	e786                	sd	ra,456(sp)
    80004f44:	e3a2                	sd	s0,448(sp)
    80004f46:	ff26                	sd	s1,440(sp)
    80004f48:	fb4a                	sd	s2,432(sp)
    80004f4a:	f74e                	sd	s3,424(sp)
    80004f4c:	f352                	sd	s4,416(sp)
    80004f4e:	ef56                	sd	s5,408(sp)
    80004f50:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f52:	08000613          	li	a2,128
    80004f56:	f4040593          	addi	a1,s0,-192
    80004f5a:	4501                	li	a0,0
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	222080e7          	jalr	546(ra) # 8000217e <argstr>
    return -1;
    80004f64:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f66:	0c054a63          	bltz	a0,8000503a <sys_exec+0xfa>
    80004f6a:	e3840593          	addi	a1,s0,-456
    80004f6e:	4505                	li	a0,1
    80004f70:	ffffd097          	auipc	ra,0xffffd
    80004f74:	1ec080e7          	jalr	492(ra) # 8000215c <argaddr>
    80004f78:	0c054163          	bltz	a0,8000503a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f7c:	10000613          	li	a2,256
    80004f80:	4581                	li	a1,0
    80004f82:	e4040513          	addi	a0,s0,-448
    80004f86:	ffffb097          	auipc	ra,0xffffb
    80004f8a:	2f0080e7          	jalr	752(ra) # 80000276 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f8e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f92:	89a6                	mv	s3,s1
    80004f94:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f96:	02000a13          	li	s4,32
    80004f9a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f9e:	00391513          	slli	a0,s2,0x3
    80004fa2:	e3040593          	addi	a1,s0,-464
    80004fa6:	e3843783          	ld	a5,-456(s0)
    80004faa:	953e                	add	a0,a0,a5
    80004fac:	ffffd097          	auipc	ra,0xffffd
    80004fb0:	0f4080e7          	jalr	244(ra) # 800020a0 <fetchaddr>
    80004fb4:	02054a63          	bltz	a0,80004fe8 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fb8:	e3043783          	ld	a5,-464(s0)
    80004fbc:	c3b9                	beqz	a5,80005002 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fbe:	ffffb097          	auipc	ra,0xffffb
    80004fc2:	1b6080e7          	jalr	438(ra) # 80000174 <kalloc>
    80004fc6:	85aa                	mv	a1,a0
    80004fc8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fcc:	cd11                	beqz	a0,80004fe8 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fce:	6605                	lui	a2,0x1
    80004fd0:	e3043503          	ld	a0,-464(s0)
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	11e080e7          	jalr	286(ra) # 800020f2 <fetchstr>
    80004fdc:	00054663          	bltz	a0,80004fe8 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004fe0:	0905                	addi	s2,s2,1
    80004fe2:	09a1                	addi	s3,s3,8
    80004fe4:	fb491be3          	bne	s2,s4,80004f9a <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe8:	10048913          	addi	s2,s1,256
    80004fec:	6088                	ld	a0,0(s1)
    80004fee:	c529                	beqz	a0,80005038 <sys_exec+0xf8>
    kfree(argv[i]);
    80004ff0:	ffffb097          	auipc	ra,0xffffb
    80004ff4:	02c080e7          	jalr	44(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff8:	04a1                	addi	s1,s1,8
    80004ffa:	ff2499e3          	bne	s1,s2,80004fec <sys_exec+0xac>
  return -1;
    80004ffe:	597d                	li	s2,-1
    80005000:	a82d                	j	8000503a <sys_exec+0xfa>
      argv[i] = 0;
    80005002:	0a8e                	slli	s5,s5,0x3
    80005004:	fc040793          	addi	a5,s0,-64
    80005008:	9abe                	add	s5,s5,a5
    8000500a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000500e:	e4040593          	addi	a1,s0,-448
    80005012:	f4040513          	addi	a0,s0,-192
    80005016:	fffff097          	auipc	ra,0xfffff
    8000501a:	194080e7          	jalr	404(ra) # 800041aa <exec>
    8000501e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005020:	10048993          	addi	s3,s1,256
    80005024:	6088                	ld	a0,0(s1)
    80005026:	c911                	beqz	a0,8000503a <sys_exec+0xfa>
    kfree(argv[i]);
    80005028:	ffffb097          	auipc	ra,0xffffb
    8000502c:	ff4080e7          	jalr	-12(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005030:	04a1                	addi	s1,s1,8
    80005032:	ff3499e3          	bne	s1,s3,80005024 <sys_exec+0xe4>
    80005036:	a011                	j	8000503a <sys_exec+0xfa>
  return -1;
    80005038:	597d                	li	s2,-1
}
    8000503a:	854a                	mv	a0,s2
    8000503c:	60be                	ld	ra,456(sp)
    8000503e:	641e                	ld	s0,448(sp)
    80005040:	74fa                	ld	s1,440(sp)
    80005042:	795a                	ld	s2,432(sp)
    80005044:	79ba                	ld	s3,424(sp)
    80005046:	7a1a                	ld	s4,416(sp)
    80005048:	6afa                	ld	s5,408(sp)
    8000504a:	6179                	addi	sp,sp,464
    8000504c:	8082                	ret

000000008000504e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000504e:	7139                	addi	sp,sp,-64
    80005050:	fc06                	sd	ra,56(sp)
    80005052:	f822                	sd	s0,48(sp)
    80005054:	f426                	sd	s1,40(sp)
    80005056:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005058:	ffffc097          	auipc	ra,0xffffc
    8000505c:	012080e7          	jalr	18(ra) # 8000106a <myproc>
    80005060:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005062:	fd840593          	addi	a1,s0,-40
    80005066:	4501                	li	a0,0
    80005068:	ffffd097          	auipc	ra,0xffffd
    8000506c:	0f4080e7          	jalr	244(ra) # 8000215c <argaddr>
    return -1;
    80005070:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005072:	0e054063          	bltz	a0,80005152 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005076:	fc840593          	addi	a1,s0,-56
    8000507a:	fd040513          	addi	a0,s0,-48
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	dfc080e7          	jalr	-516(ra) # 80003e7a <pipealloc>
    return -1;
    80005086:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005088:	0c054563          	bltz	a0,80005152 <sys_pipe+0x104>
  fd0 = -1;
    8000508c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005090:	fd043503          	ld	a0,-48(s0)
    80005094:	fffff097          	auipc	ra,0xfffff
    80005098:	508080e7          	jalr	1288(ra) # 8000459c <fdalloc>
    8000509c:	fca42223          	sw	a0,-60(s0)
    800050a0:	08054c63          	bltz	a0,80005138 <sys_pipe+0xea>
    800050a4:	fc843503          	ld	a0,-56(s0)
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	4f4080e7          	jalr	1268(ra) # 8000459c <fdalloc>
    800050b0:	fca42023          	sw	a0,-64(s0)
    800050b4:	06054863          	bltz	a0,80005124 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050b8:	4691                	li	a3,4
    800050ba:	fc440613          	addi	a2,s0,-60
    800050be:	fd843583          	ld	a1,-40(s0)
    800050c2:	68a8                	ld	a0,80(s1)
    800050c4:	ffffc097          	auipc	ra,0xffffc
    800050c8:	d36080e7          	jalr	-714(ra) # 80000dfa <copyout>
    800050cc:	02054063          	bltz	a0,800050ec <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050d0:	4691                	li	a3,4
    800050d2:	fc040613          	addi	a2,s0,-64
    800050d6:	fd843583          	ld	a1,-40(s0)
    800050da:	0591                	addi	a1,a1,4
    800050dc:	68a8                	ld	a0,80(s1)
    800050de:	ffffc097          	auipc	ra,0xffffc
    800050e2:	d1c080e7          	jalr	-740(ra) # 80000dfa <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050e6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050e8:	06055563          	bgez	a0,80005152 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050ec:	fc442783          	lw	a5,-60(s0)
    800050f0:	07e9                	addi	a5,a5,26
    800050f2:	078e                	slli	a5,a5,0x3
    800050f4:	97a6                	add	a5,a5,s1
    800050f6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050fa:	fc042503          	lw	a0,-64(s0)
    800050fe:	0569                	addi	a0,a0,26
    80005100:	050e                	slli	a0,a0,0x3
    80005102:	9526                	add	a0,a0,s1
    80005104:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005108:	fd043503          	ld	a0,-48(s0)
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	a3e080e7          	jalr	-1474(ra) # 80003b4a <fileclose>
    fileclose(wf);
    80005114:	fc843503          	ld	a0,-56(s0)
    80005118:	fffff097          	auipc	ra,0xfffff
    8000511c:	a32080e7          	jalr	-1486(ra) # 80003b4a <fileclose>
    return -1;
    80005120:	57fd                	li	a5,-1
    80005122:	a805                	j	80005152 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005124:	fc442783          	lw	a5,-60(s0)
    80005128:	0007c863          	bltz	a5,80005138 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000512c:	01a78513          	addi	a0,a5,26
    80005130:	050e                	slli	a0,a0,0x3
    80005132:	9526                	add	a0,a0,s1
    80005134:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005138:	fd043503          	ld	a0,-48(s0)
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	a0e080e7          	jalr	-1522(ra) # 80003b4a <fileclose>
    fileclose(wf);
    80005144:	fc843503          	ld	a0,-56(s0)
    80005148:	fffff097          	auipc	ra,0xfffff
    8000514c:	a02080e7          	jalr	-1534(ra) # 80003b4a <fileclose>
    return -1;
    80005150:	57fd                	li	a5,-1
}
    80005152:	853e                	mv	a0,a5
    80005154:	70e2                	ld	ra,56(sp)
    80005156:	7442                	ld	s0,48(sp)
    80005158:	74a2                	ld	s1,40(sp)
    8000515a:	6121                	addi	sp,sp,64
    8000515c:	8082                	ret
	...

0000000080005160 <kernelvec>:
    80005160:	7111                	addi	sp,sp,-256
    80005162:	e006                	sd	ra,0(sp)
    80005164:	e40a                	sd	sp,8(sp)
    80005166:	e80e                	sd	gp,16(sp)
    80005168:	ec12                	sd	tp,24(sp)
    8000516a:	f016                	sd	t0,32(sp)
    8000516c:	f41a                	sd	t1,40(sp)
    8000516e:	f81e                	sd	t2,48(sp)
    80005170:	fc22                	sd	s0,56(sp)
    80005172:	e0a6                	sd	s1,64(sp)
    80005174:	e4aa                	sd	a0,72(sp)
    80005176:	e8ae                	sd	a1,80(sp)
    80005178:	ecb2                	sd	a2,88(sp)
    8000517a:	f0b6                	sd	a3,96(sp)
    8000517c:	f4ba                	sd	a4,104(sp)
    8000517e:	f8be                	sd	a5,112(sp)
    80005180:	fcc2                	sd	a6,120(sp)
    80005182:	e146                	sd	a7,128(sp)
    80005184:	e54a                	sd	s2,136(sp)
    80005186:	e94e                	sd	s3,144(sp)
    80005188:	ed52                	sd	s4,152(sp)
    8000518a:	f156                	sd	s5,160(sp)
    8000518c:	f55a                	sd	s6,168(sp)
    8000518e:	f95e                	sd	s7,176(sp)
    80005190:	fd62                	sd	s8,184(sp)
    80005192:	e1e6                	sd	s9,192(sp)
    80005194:	e5ea                	sd	s10,200(sp)
    80005196:	e9ee                	sd	s11,208(sp)
    80005198:	edf2                	sd	t3,216(sp)
    8000519a:	f1f6                	sd	t4,224(sp)
    8000519c:	f5fa                	sd	t5,232(sp)
    8000519e:	f9fe                	sd	t6,240(sp)
    800051a0:	dcdfc0ef          	jal	ra,80001f6c <kerneltrap>
    800051a4:	6082                	ld	ra,0(sp)
    800051a6:	6122                	ld	sp,8(sp)
    800051a8:	61c2                	ld	gp,16(sp)
    800051aa:	7282                	ld	t0,32(sp)
    800051ac:	7322                	ld	t1,40(sp)
    800051ae:	73c2                	ld	t2,48(sp)
    800051b0:	7462                	ld	s0,56(sp)
    800051b2:	6486                	ld	s1,64(sp)
    800051b4:	6526                	ld	a0,72(sp)
    800051b6:	65c6                	ld	a1,80(sp)
    800051b8:	6666                	ld	a2,88(sp)
    800051ba:	7686                	ld	a3,96(sp)
    800051bc:	7726                	ld	a4,104(sp)
    800051be:	77c6                	ld	a5,112(sp)
    800051c0:	7866                	ld	a6,120(sp)
    800051c2:	688a                	ld	a7,128(sp)
    800051c4:	692a                	ld	s2,136(sp)
    800051c6:	69ca                	ld	s3,144(sp)
    800051c8:	6a6a                	ld	s4,152(sp)
    800051ca:	7a8a                	ld	s5,160(sp)
    800051cc:	7b2a                	ld	s6,168(sp)
    800051ce:	7bca                	ld	s7,176(sp)
    800051d0:	7c6a                	ld	s8,184(sp)
    800051d2:	6c8e                	ld	s9,192(sp)
    800051d4:	6d2e                	ld	s10,200(sp)
    800051d6:	6dce                	ld	s11,208(sp)
    800051d8:	6e6e                	ld	t3,216(sp)
    800051da:	7e8e                	ld	t4,224(sp)
    800051dc:	7f2e                	ld	t5,232(sp)
    800051de:	7fce                	ld	t6,240(sp)
    800051e0:	6111                	addi	sp,sp,256
    800051e2:	10200073          	sret
    800051e6:	00000013          	nop
    800051ea:	00000013          	nop
    800051ee:	0001                	nop

00000000800051f0 <timervec>:
    800051f0:	34051573          	csrrw	a0,mscratch,a0
    800051f4:	e10c                	sd	a1,0(a0)
    800051f6:	e510                	sd	a2,8(a0)
    800051f8:	e914                	sd	a3,16(a0)
    800051fa:	6d0c                	ld	a1,24(a0)
    800051fc:	7110                	ld	a2,32(a0)
    800051fe:	6194                	ld	a3,0(a1)
    80005200:	96b2                	add	a3,a3,a2
    80005202:	e194                	sd	a3,0(a1)
    80005204:	4589                	li	a1,2
    80005206:	14459073          	csrw	sip,a1
    8000520a:	6914                	ld	a3,16(a0)
    8000520c:	6510                	ld	a2,8(a0)
    8000520e:	610c                	ld	a1,0(a0)
    80005210:	34051573          	csrrw	a0,mscratch,a0
    80005214:	30200073          	mret
	...

000000008000521a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000521a:	1141                	addi	sp,sp,-16
    8000521c:	e422                	sd	s0,8(sp)
    8000521e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005220:	0c0007b7          	lui	a5,0xc000
    80005224:	4705                	li	a4,1
    80005226:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005228:	c3d8                	sw	a4,4(a5)
}
    8000522a:	6422                	ld	s0,8(sp)
    8000522c:	0141                	addi	sp,sp,16
    8000522e:	8082                	ret

0000000080005230 <plicinithart>:

void
plicinithart(void)
{
    80005230:	1141                	addi	sp,sp,-16
    80005232:	e406                	sd	ra,8(sp)
    80005234:	e022                	sd	s0,0(sp)
    80005236:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	e06080e7          	jalr	-506(ra) # 8000103e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005240:	0085171b          	slliw	a4,a0,0x8
    80005244:	0c0027b7          	lui	a5,0xc002
    80005248:	97ba                	add	a5,a5,a4
    8000524a:	40200713          	li	a4,1026
    8000524e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005252:	00d5151b          	slliw	a0,a0,0xd
    80005256:	0c2017b7          	lui	a5,0xc201
    8000525a:	953e                	add	a0,a0,a5
    8000525c:	00052023          	sw	zero,0(a0)
}
    80005260:	60a2                	ld	ra,8(sp)
    80005262:	6402                	ld	s0,0(sp)
    80005264:	0141                	addi	sp,sp,16
    80005266:	8082                	ret

0000000080005268 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005268:	1141                	addi	sp,sp,-16
    8000526a:	e406                	sd	ra,8(sp)
    8000526c:	e022                	sd	s0,0(sp)
    8000526e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005270:	ffffc097          	auipc	ra,0xffffc
    80005274:	dce080e7          	jalr	-562(ra) # 8000103e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005278:	00d5179b          	slliw	a5,a0,0xd
    8000527c:	0c201537          	lui	a0,0xc201
    80005280:	953e                	add	a0,a0,a5
  return irq;
}
    80005282:	4148                	lw	a0,4(a0)
    80005284:	60a2                	ld	ra,8(sp)
    80005286:	6402                	ld	s0,0(sp)
    80005288:	0141                	addi	sp,sp,16
    8000528a:	8082                	ret

000000008000528c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000528c:	1101                	addi	sp,sp,-32
    8000528e:	ec06                	sd	ra,24(sp)
    80005290:	e822                	sd	s0,16(sp)
    80005292:	e426                	sd	s1,8(sp)
    80005294:	1000                	addi	s0,sp,32
    80005296:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005298:	ffffc097          	auipc	ra,0xffffc
    8000529c:	da6080e7          	jalr	-602(ra) # 8000103e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052a0:	00d5151b          	slliw	a0,a0,0xd
    800052a4:	0c2017b7          	lui	a5,0xc201
    800052a8:	97aa                	add	a5,a5,a0
    800052aa:	c3c4                	sw	s1,4(a5)
}
    800052ac:	60e2                	ld	ra,24(sp)
    800052ae:	6442                	ld	s0,16(sp)
    800052b0:	64a2                	ld	s1,8(sp)
    800052b2:	6105                	addi	sp,sp,32
    800052b4:	8082                	ret

00000000800052b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052b6:	1141                	addi	sp,sp,-16
    800052b8:	e406                	sd	ra,8(sp)
    800052ba:	e022                	sd	s0,0(sp)
    800052bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052be:	479d                	li	a5,7
    800052c0:	06a7c963          	blt	a5,a0,80005332 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052c4:	00236797          	auipc	a5,0x236
    800052c8:	d3c78793          	addi	a5,a5,-708 # 8023b000 <disk>
    800052cc:	00a78733          	add	a4,a5,a0
    800052d0:	6789                	lui	a5,0x2
    800052d2:	97ba                	add	a5,a5,a4
    800052d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800052d8:	e7ad                	bnez	a5,80005342 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052da:	00451793          	slli	a5,a0,0x4
    800052de:	00238717          	auipc	a4,0x238
    800052e2:	d2270713          	addi	a4,a4,-734 # 8023d000 <disk+0x2000>
    800052e6:	6314                	ld	a3,0(a4)
    800052e8:	96be                	add	a3,a3,a5
    800052ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052ee:	6314                	ld	a3,0(a4)
    800052f0:	96be                	add	a3,a3,a5
    800052f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800052f6:	6314                	ld	a3,0(a4)
    800052f8:	96be                	add	a3,a3,a5
    800052fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800052fe:	6318                	ld	a4,0(a4)
    80005300:	97ba                	add	a5,a5,a4
    80005302:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005306:	00236797          	auipc	a5,0x236
    8000530a:	cfa78793          	addi	a5,a5,-774 # 8023b000 <disk>
    8000530e:	97aa                	add	a5,a5,a0
    80005310:	6509                	lui	a0,0x2
    80005312:	953e                	add	a0,a0,a5
    80005314:	4785                	li	a5,1
    80005316:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000531a:	00238517          	auipc	a0,0x238
    8000531e:	cfe50513          	addi	a0,a0,-770 # 8023d018 <disk+0x2018>
    80005322:	ffffc097          	auipc	ra,0xffffc
    80005326:	590080e7          	jalr	1424(ra) # 800018b2 <wakeup>
}
    8000532a:	60a2                	ld	ra,8(sp)
    8000532c:	6402                	ld	s0,0(sp)
    8000532e:	0141                	addi	sp,sp,16
    80005330:	8082                	ret
    panic("free_desc 1");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	49e50513          	addi	a0,a0,1182 # 800087d0 <syscalls+0x320>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	a1e080e7          	jalr	-1506(ra) # 80005d58 <panic>
    panic("free_desc 2");
    80005342:	00003517          	auipc	a0,0x3
    80005346:	49e50513          	addi	a0,a0,1182 # 800087e0 <syscalls+0x330>
    8000534a:	00001097          	auipc	ra,0x1
    8000534e:	a0e080e7          	jalr	-1522(ra) # 80005d58 <panic>

0000000080005352 <virtio_disk_init>:
{
    80005352:	1101                	addi	sp,sp,-32
    80005354:	ec06                	sd	ra,24(sp)
    80005356:	e822                	sd	s0,16(sp)
    80005358:	e426                	sd	s1,8(sp)
    8000535a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000535c:	00003597          	auipc	a1,0x3
    80005360:	49458593          	addi	a1,a1,1172 # 800087f0 <syscalls+0x340>
    80005364:	00238517          	auipc	a0,0x238
    80005368:	dc450513          	addi	a0,a0,-572 # 8023d128 <disk+0x2128>
    8000536c:	00001097          	auipc	ra,0x1
    80005370:	ea6080e7          	jalr	-346(ra) # 80006212 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005374:	100017b7          	lui	a5,0x10001
    80005378:	4398                	lw	a4,0(a5)
    8000537a:	2701                	sext.w	a4,a4
    8000537c:	747277b7          	lui	a5,0x74727
    80005380:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005384:	0ef71163          	bne	a4,a5,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005388:	100017b7          	lui	a5,0x10001
    8000538c:	43dc                	lw	a5,4(a5)
    8000538e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005390:	4705                	li	a4,1
    80005392:	0ce79a63          	bne	a5,a4,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005396:	100017b7          	lui	a5,0x10001
    8000539a:	479c                	lw	a5,8(a5)
    8000539c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000539e:	4709                	li	a4,2
    800053a0:	0ce79363          	bne	a5,a4,80005466 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053a4:	100017b7          	lui	a5,0x10001
    800053a8:	47d8                	lw	a4,12(a5)
    800053aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ac:	554d47b7          	lui	a5,0x554d4
    800053b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053b4:	0af71963          	bne	a4,a5,80005466 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	4705                	li	a4,1
    800053be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053c0:	470d                	li	a4,3
    800053c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053c6:	c7ffe737          	lui	a4,0xc7ffe
    800053ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    800053ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053d0:	2701                	sext.w	a4,a4
    800053d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d4:	472d                	li	a4,11
    800053d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053d8:	473d                	li	a4,15
    800053da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800053dc:	6705                	lui	a4,0x1
    800053de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053e4:	5bdc                	lw	a5,52(a5)
    800053e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053e8:	c7d9                	beqz	a5,80005476 <virtio_disk_init+0x124>
  if(max < NUM)
    800053ea:	471d                	li	a4,7
    800053ec:	08f77d63          	bgeu	a4,a5,80005486 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053f0:	100014b7          	lui	s1,0x10001
    800053f4:	47a1                	li	a5,8
    800053f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800053f8:	6609                	lui	a2,0x2
    800053fa:	4581                	li	a1,0
    800053fc:	00236517          	auipc	a0,0x236
    80005400:	c0450513          	addi	a0,a0,-1020 # 8023b000 <disk>
    80005404:	ffffb097          	auipc	ra,0xffffb
    80005408:	e72080e7          	jalr	-398(ra) # 80000276 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000540c:	00236717          	auipc	a4,0x236
    80005410:	bf470713          	addi	a4,a4,-1036 # 8023b000 <disk>
    80005414:	00c75793          	srli	a5,a4,0xc
    80005418:	2781                	sext.w	a5,a5
    8000541a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000541c:	00238797          	auipc	a5,0x238
    80005420:	be478793          	addi	a5,a5,-1052 # 8023d000 <disk+0x2000>
    80005424:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005426:	00236717          	auipc	a4,0x236
    8000542a:	c5a70713          	addi	a4,a4,-934 # 8023b080 <disk+0x80>
    8000542e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005430:	00237717          	auipc	a4,0x237
    80005434:	bd070713          	addi	a4,a4,-1072 # 8023c000 <disk+0x1000>
    80005438:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000543a:	4705                	li	a4,1
    8000543c:	00e78c23          	sb	a4,24(a5)
    80005440:	00e78ca3          	sb	a4,25(a5)
    80005444:	00e78d23          	sb	a4,26(a5)
    80005448:	00e78da3          	sb	a4,27(a5)
    8000544c:	00e78e23          	sb	a4,28(a5)
    80005450:	00e78ea3          	sb	a4,29(a5)
    80005454:	00e78f23          	sb	a4,30(a5)
    80005458:	00e78fa3          	sb	a4,31(a5)
}
    8000545c:	60e2                	ld	ra,24(sp)
    8000545e:	6442                	ld	s0,16(sp)
    80005460:	64a2                	ld	s1,8(sp)
    80005462:	6105                	addi	sp,sp,32
    80005464:	8082                	ret
    panic("could not find virtio disk");
    80005466:	00003517          	auipc	a0,0x3
    8000546a:	39a50513          	addi	a0,a0,922 # 80008800 <syscalls+0x350>
    8000546e:	00001097          	auipc	ra,0x1
    80005472:	8ea080e7          	jalr	-1814(ra) # 80005d58 <panic>
    panic("virtio disk has no queue 0");
    80005476:	00003517          	auipc	a0,0x3
    8000547a:	3aa50513          	addi	a0,a0,938 # 80008820 <syscalls+0x370>
    8000547e:	00001097          	auipc	ra,0x1
    80005482:	8da080e7          	jalr	-1830(ra) # 80005d58 <panic>
    panic("virtio disk max queue too short");
    80005486:	00003517          	auipc	a0,0x3
    8000548a:	3ba50513          	addi	a0,a0,954 # 80008840 <syscalls+0x390>
    8000548e:	00001097          	auipc	ra,0x1
    80005492:	8ca080e7          	jalr	-1846(ra) # 80005d58 <panic>

0000000080005496 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005496:	7159                	addi	sp,sp,-112
    80005498:	f486                	sd	ra,104(sp)
    8000549a:	f0a2                	sd	s0,96(sp)
    8000549c:	eca6                	sd	s1,88(sp)
    8000549e:	e8ca                	sd	s2,80(sp)
    800054a0:	e4ce                	sd	s3,72(sp)
    800054a2:	e0d2                	sd	s4,64(sp)
    800054a4:	fc56                	sd	s5,56(sp)
    800054a6:	f85a                	sd	s6,48(sp)
    800054a8:	f45e                	sd	s7,40(sp)
    800054aa:	f062                	sd	s8,32(sp)
    800054ac:	ec66                	sd	s9,24(sp)
    800054ae:	e86a                	sd	s10,16(sp)
    800054b0:	1880                	addi	s0,sp,112
    800054b2:	892a                	mv	s2,a0
    800054b4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054b6:	00c52c83          	lw	s9,12(a0)
    800054ba:	001c9c9b          	slliw	s9,s9,0x1
    800054be:	1c82                	slli	s9,s9,0x20
    800054c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054c4:	00238517          	auipc	a0,0x238
    800054c8:	c6450513          	addi	a0,a0,-924 # 8023d128 <disk+0x2128>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	dd6080e7          	jalr	-554(ra) # 800062a2 <acquire>
  for(int i = 0; i < 3; i++){
    800054d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054d6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800054d8:	00236b97          	auipc	s7,0x236
    800054dc:	b28b8b93          	addi	s7,s7,-1240 # 8023b000 <disk>
    800054e0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800054e2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054e4:	8a4e                	mv	s4,s3
    800054e6:	a051                	j	8000556a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800054e8:	00fb86b3          	add	a3,s7,a5
    800054ec:	96da                	add	a3,a3,s6
    800054ee:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054f2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054f4:	0207c563          	bltz	a5,8000551e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800054f8:	2485                	addiw	s1,s1,1
    800054fa:	0711                	addi	a4,a4,4
    800054fc:	25548063          	beq	s1,s5,8000573c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005500:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005502:	00238697          	auipc	a3,0x238
    80005506:	b1668693          	addi	a3,a3,-1258 # 8023d018 <disk+0x2018>
    8000550a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000550c:	0006c583          	lbu	a1,0(a3)
    80005510:	fde1                	bnez	a1,800054e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005512:	2785                	addiw	a5,a5,1
    80005514:	0685                	addi	a3,a3,1
    80005516:	ff879be3          	bne	a5,s8,8000550c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000551a:	57fd                	li	a5,-1
    8000551c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000551e:	02905a63          	blez	s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005522:	f9042503          	lw	a0,-112(s0)
    80005526:	00000097          	auipc	ra,0x0
    8000552a:	d90080e7          	jalr	-624(ra) # 800052b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000552e:	4785                	li	a5,1
    80005530:	0297d163          	bge	a5,s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005534:	f9442503          	lw	a0,-108(s0)
    80005538:	00000097          	auipc	ra,0x0
    8000553c:	d7e080e7          	jalr	-642(ra) # 800052b6 <free_desc>
      for(int j = 0; j < i; j++)
    80005540:	4789                	li	a5,2
    80005542:	0097d863          	bge	a5,s1,80005552 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005546:	f9842503          	lw	a0,-104(s0)
    8000554a:	00000097          	auipc	ra,0x0
    8000554e:	d6c080e7          	jalr	-660(ra) # 800052b6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005552:	00238597          	auipc	a1,0x238
    80005556:	bd658593          	addi	a1,a1,-1066 # 8023d128 <disk+0x2128>
    8000555a:	00238517          	auipc	a0,0x238
    8000555e:	abe50513          	addi	a0,a0,-1346 # 8023d018 <disk+0x2018>
    80005562:	ffffc097          	auipc	ra,0xffffc
    80005566:	1c4080e7          	jalr	452(ra) # 80001726 <sleep>
  for(int i = 0; i < 3; i++){
    8000556a:	f9040713          	addi	a4,s0,-112
    8000556e:	84ce                	mv	s1,s3
    80005570:	bf41                	j	80005500 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005572:	20058713          	addi	a4,a1,512
    80005576:	00471693          	slli	a3,a4,0x4
    8000557a:	00236717          	auipc	a4,0x236
    8000557e:	a8670713          	addi	a4,a4,-1402 # 8023b000 <disk>
    80005582:	9736                	add	a4,a4,a3
    80005584:	4685                	li	a3,1
    80005586:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000558a:	20058713          	addi	a4,a1,512
    8000558e:	00471693          	slli	a3,a4,0x4
    80005592:	00236717          	auipc	a4,0x236
    80005596:	a6e70713          	addi	a4,a4,-1426 # 8023b000 <disk>
    8000559a:	9736                	add	a4,a4,a3
    8000559c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055a0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055a4:	7679                	lui	a2,0xffffe
    800055a6:	963e                	add	a2,a2,a5
    800055a8:	00238697          	auipc	a3,0x238
    800055ac:	a5868693          	addi	a3,a3,-1448 # 8023d000 <disk+0x2000>
    800055b0:	6298                	ld	a4,0(a3)
    800055b2:	9732                	add	a4,a4,a2
    800055b4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055b6:	6298                	ld	a4,0(a3)
    800055b8:	9732                	add	a4,a4,a2
    800055ba:	4541                	li	a0,16
    800055bc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055be:	6298                	ld	a4,0(a3)
    800055c0:	9732                	add	a4,a4,a2
    800055c2:	4505                	li	a0,1
    800055c4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055c8:	f9442703          	lw	a4,-108(s0)
    800055cc:	6288                	ld	a0,0(a3)
    800055ce:	962a                	add	a2,a2,a0
    800055d0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055d4:	0712                	slli	a4,a4,0x4
    800055d6:	6290                	ld	a2,0(a3)
    800055d8:	963a                	add	a2,a2,a4
    800055da:	05890513          	addi	a0,s2,88
    800055de:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055e0:	6294                	ld	a3,0(a3)
    800055e2:	96ba                	add	a3,a3,a4
    800055e4:	40000613          	li	a2,1024
    800055e8:	c690                	sw	a2,8(a3)
  if(write)
    800055ea:	140d0063          	beqz	s10,8000572a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055ee:	00238697          	auipc	a3,0x238
    800055f2:	a126b683          	ld	a3,-1518(a3) # 8023d000 <disk+0x2000>
    800055f6:	96ba                	add	a3,a3,a4
    800055f8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055fc:	00236817          	auipc	a6,0x236
    80005600:	a0480813          	addi	a6,a6,-1532 # 8023b000 <disk>
    80005604:	00238517          	auipc	a0,0x238
    80005608:	9fc50513          	addi	a0,a0,-1540 # 8023d000 <disk+0x2000>
    8000560c:	6114                	ld	a3,0(a0)
    8000560e:	96ba                	add	a3,a3,a4
    80005610:	00c6d603          	lhu	a2,12(a3)
    80005614:	00166613          	ori	a2,a2,1
    80005618:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000561c:	f9842683          	lw	a3,-104(s0)
    80005620:	6110                	ld	a2,0(a0)
    80005622:	9732                	add	a4,a4,a2
    80005624:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005628:	20058613          	addi	a2,a1,512
    8000562c:	0612                	slli	a2,a2,0x4
    8000562e:	9642                	add	a2,a2,a6
    80005630:	577d                	li	a4,-1
    80005632:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005636:	00469713          	slli	a4,a3,0x4
    8000563a:	6114                	ld	a3,0(a0)
    8000563c:	96ba                	add	a3,a3,a4
    8000563e:	03078793          	addi	a5,a5,48
    80005642:	97c2                	add	a5,a5,a6
    80005644:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005646:	611c                	ld	a5,0(a0)
    80005648:	97ba                	add	a5,a5,a4
    8000564a:	4685                	li	a3,1
    8000564c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000564e:	611c                	ld	a5,0(a0)
    80005650:	97ba                	add	a5,a5,a4
    80005652:	4809                	li	a6,2
    80005654:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005658:	611c                	ld	a5,0(a0)
    8000565a:	973e                	add	a4,a4,a5
    8000565c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005660:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005664:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005668:	6518                	ld	a4,8(a0)
    8000566a:	00275783          	lhu	a5,2(a4)
    8000566e:	8b9d                	andi	a5,a5,7
    80005670:	0786                	slli	a5,a5,0x1
    80005672:	97ba                	add	a5,a5,a4
    80005674:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005678:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000567c:	6518                	ld	a4,8(a0)
    8000567e:	00275783          	lhu	a5,2(a4)
    80005682:	2785                	addiw	a5,a5,1
    80005684:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005688:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000568c:	100017b7          	lui	a5,0x10001
    80005690:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005694:	00492703          	lw	a4,4(s2)
    80005698:	4785                	li	a5,1
    8000569a:	02f71163          	bne	a4,a5,800056bc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000569e:	00238997          	auipc	s3,0x238
    800056a2:	a8a98993          	addi	s3,s3,-1398 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    800056a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056a8:	85ce                	mv	a1,s3
    800056aa:	854a                	mv	a0,s2
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	07a080e7          	jalr	122(ra) # 80001726 <sleep>
  while(b->disk == 1) {
    800056b4:	00492783          	lw	a5,4(s2)
    800056b8:	fe9788e3          	beq	a5,s1,800056a8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056bc:	f9042903          	lw	s2,-112(s0)
    800056c0:	20090793          	addi	a5,s2,512
    800056c4:	00479713          	slli	a4,a5,0x4
    800056c8:	00236797          	auipc	a5,0x236
    800056cc:	93878793          	addi	a5,a5,-1736 # 8023b000 <disk>
    800056d0:	97ba                	add	a5,a5,a4
    800056d2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056d6:	00238997          	auipc	s3,0x238
    800056da:	92a98993          	addi	s3,s3,-1750 # 8023d000 <disk+0x2000>
    800056de:	00491713          	slli	a4,s2,0x4
    800056e2:	0009b783          	ld	a5,0(s3)
    800056e6:	97ba                	add	a5,a5,a4
    800056e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ec:	854a                	mv	a0,s2
    800056ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056f2:	00000097          	auipc	ra,0x0
    800056f6:	bc4080e7          	jalr	-1084(ra) # 800052b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056fa:	8885                	andi	s1,s1,1
    800056fc:	f0ed                	bnez	s1,800056de <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056fe:	00238517          	auipc	a0,0x238
    80005702:	a2a50513          	addi	a0,a0,-1494 # 8023d128 <disk+0x2128>
    80005706:	00001097          	auipc	ra,0x1
    8000570a:	c50080e7          	jalr	-944(ra) # 80006356 <release>
}
    8000570e:	70a6                	ld	ra,104(sp)
    80005710:	7406                	ld	s0,96(sp)
    80005712:	64e6                	ld	s1,88(sp)
    80005714:	6946                	ld	s2,80(sp)
    80005716:	69a6                	ld	s3,72(sp)
    80005718:	6a06                	ld	s4,64(sp)
    8000571a:	7ae2                	ld	s5,56(sp)
    8000571c:	7b42                	ld	s6,48(sp)
    8000571e:	7ba2                	ld	s7,40(sp)
    80005720:	7c02                	ld	s8,32(sp)
    80005722:	6ce2                	ld	s9,24(sp)
    80005724:	6d42                	ld	s10,16(sp)
    80005726:	6165                	addi	sp,sp,112
    80005728:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000572a:	00238697          	auipc	a3,0x238
    8000572e:	8d66b683          	ld	a3,-1834(a3) # 8023d000 <disk+0x2000>
    80005732:	96ba                	add	a3,a3,a4
    80005734:	4609                	li	a2,2
    80005736:	00c69623          	sh	a2,12(a3)
    8000573a:	b5c9                	j	800055fc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000573c:	f9042583          	lw	a1,-112(s0)
    80005740:	20058793          	addi	a5,a1,512
    80005744:	0792                	slli	a5,a5,0x4
    80005746:	00236517          	auipc	a0,0x236
    8000574a:	96250513          	addi	a0,a0,-1694 # 8023b0a8 <disk+0xa8>
    8000574e:	953e                	add	a0,a0,a5
  if(write)
    80005750:	e20d11e3          	bnez	s10,80005572 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005754:	20058713          	addi	a4,a1,512
    80005758:	00471693          	slli	a3,a4,0x4
    8000575c:	00236717          	auipc	a4,0x236
    80005760:	8a470713          	addi	a4,a4,-1884 # 8023b000 <disk>
    80005764:	9736                	add	a4,a4,a3
    80005766:	0a072423          	sw	zero,168(a4)
    8000576a:	b505                	j	8000558a <virtio_disk_rw+0xf4>

000000008000576c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000576c:	1101                	addi	sp,sp,-32
    8000576e:	ec06                	sd	ra,24(sp)
    80005770:	e822                	sd	s0,16(sp)
    80005772:	e426                	sd	s1,8(sp)
    80005774:	e04a                	sd	s2,0(sp)
    80005776:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005778:	00238517          	auipc	a0,0x238
    8000577c:	9b050513          	addi	a0,a0,-1616 # 8023d128 <disk+0x2128>
    80005780:	00001097          	auipc	ra,0x1
    80005784:	b22080e7          	jalr	-1246(ra) # 800062a2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005788:	10001737          	lui	a4,0x10001
    8000578c:	533c                	lw	a5,96(a4)
    8000578e:	8b8d                	andi	a5,a5,3
    80005790:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005792:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005796:	00238797          	auipc	a5,0x238
    8000579a:	86a78793          	addi	a5,a5,-1942 # 8023d000 <disk+0x2000>
    8000579e:	6b94                	ld	a3,16(a5)
    800057a0:	0207d703          	lhu	a4,32(a5)
    800057a4:	0026d783          	lhu	a5,2(a3)
    800057a8:	06f70163          	beq	a4,a5,8000580a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ac:	00236917          	auipc	s2,0x236
    800057b0:	85490913          	addi	s2,s2,-1964 # 8023b000 <disk>
    800057b4:	00238497          	auipc	s1,0x238
    800057b8:	84c48493          	addi	s1,s1,-1972 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    800057bc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057c0:	6898                	ld	a4,16(s1)
    800057c2:	0204d783          	lhu	a5,32(s1)
    800057c6:	8b9d                	andi	a5,a5,7
    800057c8:	078e                	slli	a5,a5,0x3
    800057ca:	97ba                	add	a5,a5,a4
    800057cc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057ce:	20078713          	addi	a4,a5,512
    800057d2:	0712                	slli	a4,a4,0x4
    800057d4:	974a                	add	a4,a4,s2
    800057d6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057da:	e731                	bnez	a4,80005826 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057dc:	20078793          	addi	a5,a5,512
    800057e0:	0792                	slli	a5,a5,0x4
    800057e2:	97ca                	add	a5,a5,s2
    800057e4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057ea:	ffffc097          	auipc	ra,0xffffc
    800057ee:	0c8080e7          	jalr	200(ra) # 800018b2 <wakeup>

    disk.used_idx += 1;
    800057f2:	0204d783          	lhu	a5,32(s1)
    800057f6:	2785                	addiw	a5,a5,1
    800057f8:	17c2                	slli	a5,a5,0x30
    800057fa:	93c1                	srli	a5,a5,0x30
    800057fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005800:	6898                	ld	a4,16(s1)
    80005802:	00275703          	lhu	a4,2(a4)
    80005806:	faf71be3          	bne	a4,a5,800057bc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000580a:	00238517          	auipc	a0,0x238
    8000580e:	91e50513          	addi	a0,a0,-1762 # 8023d128 <disk+0x2128>
    80005812:	00001097          	auipc	ra,0x1
    80005816:	b44080e7          	jalr	-1212(ra) # 80006356 <release>
}
    8000581a:	60e2                	ld	ra,24(sp)
    8000581c:	6442                	ld	s0,16(sp)
    8000581e:	64a2                	ld	s1,8(sp)
    80005820:	6902                	ld	s2,0(sp)
    80005822:	6105                	addi	sp,sp,32
    80005824:	8082                	ret
      panic("virtio_disk_intr status");
    80005826:	00003517          	auipc	a0,0x3
    8000582a:	03a50513          	addi	a0,a0,58 # 80008860 <syscalls+0x3b0>
    8000582e:	00000097          	auipc	ra,0x0
    80005832:	52a080e7          	jalr	1322(ra) # 80005d58 <panic>

0000000080005836 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005836:	1141                	addi	sp,sp,-16
    80005838:	e422                	sd	s0,8(sp)
    8000583a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000583c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005840:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005844:	0037979b          	slliw	a5,a5,0x3
    80005848:	02004737          	lui	a4,0x2004
    8000584c:	97ba                	add	a5,a5,a4
    8000584e:	0200c737          	lui	a4,0x200c
    80005852:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005856:	000f4637          	lui	a2,0xf4
    8000585a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000585e:	95b2                	add	a1,a1,a2
    80005860:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005862:	00269713          	slli	a4,a3,0x2
    80005866:	9736                	add	a4,a4,a3
    80005868:	00371693          	slli	a3,a4,0x3
    8000586c:	00238717          	auipc	a4,0x238
    80005870:	79470713          	addi	a4,a4,1940 # 8023e000 <timer_scratch>
    80005874:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005876:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005878:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000587a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000587e:	00000797          	auipc	a5,0x0
    80005882:	97278793          	addi	a5,a5,-1678 # 800051f0 <timervec>
    80005886:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000588a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000588e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005892:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005896:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000589a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000589e:	30479073          	csrw	mie,a5
}
    800058a2:	6422                	ld	s0,8(sp)
    800058a4:	0141                	addi	sp,sp,16
    800058a6:	8082                	ret

00000000800058a8 <start>:
{
    800058a8:	1141                	addi	sp,sp,-16
    800058aa:	e406                	sd	ra,8(sp)
    800058ac:	e022                	sd	s0,0(sp)
    800058ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058b4:	7779                	lui	a4,0xffffe
    800058b6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    800058ba:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058bc:	6705                	lui	a4,0x1
    800058be:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058c2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058c4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058c8:	ffffb797          	auipc	a5,0xffffb
    800058cc:	b5c78793          	addi	a5,a5,-1188 # 80000424 <main>
    800058d0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058d4:	4781                	li	a5,0
    800058d6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058da:	67c1                	lui	a5,0x10
    800058dc:	17fd                	addi	a5,a5,-1
    800058de:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058e2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058e6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058ea:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058ee:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058f2:	57fd                	li	a5,-1
    800058f4:	83a9                	srli	a5,a5,0xa
    800058f6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058fa:	47bd                	li	a5,15
    800058fc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005900:	00000097          	auipc	ra,0x0
    80005904:	f36080e7          	jalr	-202(ra) # 80005836 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005908:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000590c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000590e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005910:	30200073          	mret
}
    80005914:	60a2                	ld	ra,8(sp)
    80005916:	6402                	ld	s0,0(sp)
    80005918:	0141                	addi	sp,sp,16
    8000591a:	8082                	ret

000000008000591c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000591c:	715d                	addi	sp,sp,-80
    8000591e:	e486                	sd	ra,72(sp)
    80005920:	e0a2                	sd	s0,64(sp)
    80005922:	fc26                	sd	s1,56(sp)
    80005924:	f84a                	sd	s2,48(sp)
    80005926:	f44e                	sd	s3,40(sp)
    80005928:	f052                	sd	s4,32(sp)
    8000592a:	ec56                	sd	s5,24(sp)
    8000592c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000592e:	04c05663          	blez	a2,8000597a <consolewrite+0x5e>
    80005932:	8a2a                	mv	s4,a0
    80005934:	84ae                	mv	s1,a1
    80005936:	89b2                	mv	s3,a2
    80005938:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000593a:	5afd                	li	s5,-1
    8000593c:	4685                	li	a3,1
    8000593e:	8626                	mv	a2,s1
    80005940:	85d2                	mv	a1,s4
    80005942:	fbf40513          	addi	a0,s0,-65
    80005946:	ffffc097          	auipc	ra,0xffffc
    8000594a:	1da080e7          	jalr	474(ra) # 80001b20 <either_copyin>
    8000594e:	01550c63          	beq	a0,s5,80005966 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005952:	fbf44503          	lbu	a0,-65(s0)
    80005956:	00000097          	auipc	ra,0x0
    8000595a:	78e080e7          	jalr	1934(ra) # 800060e4 <uartputc>
  for(i = 0; i < n; i++){
    8000595e:	2905                	addiw	s2,s2,1
    80005960:	0485                	addi	s1,s1,1
    80005962:	fd299de3          	bne	s3,s2,8000593c <consolewrite+0x20>
  }

  return i;
}
    80005966:	854a                	mv	a0,s2
    80005968:	60a6                	ld	ra,72(sp)
    8000596a:	6406                	ld	s0,64(sp)
    8000596c:	74e2                	ld	s1,56(sp)
    8000596e:	7942                	ld	s2,48(sp)
    80005970:	79a2                	ld	s3,40(sp)
    80005972:	7a02                	ld	s4,32(sp)
    80005974:	6ae2                	ld	s5,24(sp)
    80005976:	6161                	addi	sp,sp,80
    80005978:	8082                	ret
  for(i = 0; i < n; i++){
    8000597a:	4901                	li	s2,0
    8000597c:	b7ed                	j	80005966 <consolewrite+0x4a>

000000008000597e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000597e:	7119                	addi	sp,sp,-128
    80005980:	fc86                	sd	ra,120(sp)
    80005982:	f8a2                	sd	s0,112(sp)
    80005984:	f4a6                	sd	s1,104(sp)
    80005986:	f0ca                	sd	s2,96(sp)
    80005988:	ecce                	sd	s3,88(sp)
    8000598a:	e8d2                	sd	s4,80(sp)
    8000598c:	e4d6                	sd	s5,72(sp)
    8000598e:	e0da                	sd	s6,64(sp)
    80005990:	fc5e                	sd	s7,56(sp)
    80005992:	f862                	sd	s8,48(sp)
    80005994:	f466                	sd	s9,40(sp)
    80005996:	f06a                	sd	s10,32(sp)
    80005998:	ec6e                	sd	s11,24(sp)
    8000599a:	0100                	addi	s0,sp,128
    8000599c:	8b2a                	mv	s6,a0
    8000599e:	8aae                	mv	s5,a1
    800059a0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059a2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059a6:	00240517          	auipc	a0,0x240
    800059aa:	79a50513          	addi	a0,a0,1946 # 80246140 <cons>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	8f4080e7          	jalr	-1804(ra) # 800062a2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059b6:	00240497          	auipc	s1,0x240
    800059ba:	78a48493          	addi	s1,s1,1930 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059be:	89a6                	mv	s3,s1
    800059c0:	00241917          	auipc	s2,0x241
    800059c4:	81890913          	addi	s2,s2,-2024 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059c8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ca:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059cc:	4da9                	li	s11,10
  while(n > 0){
    800059ce:	07405863          	blez	s4,80005a3e <consoleread+0xc0>
    while(cons.r == cons.w){
    800059d2:	0984a783          	lw	a5,152(s1)
    800059d6:	09c4a703          	lw	a4,156(s1)
    800059da:	02f71463          	bne	a4,a5,80005a02 <consoleread+0x84>
      if(myproc()->killed){
    800059de:	ffffb097          	auipc	ra,0xffffb
    800059e2:	68c080e7          	jalr	1676(ra) # 8000106a <myproc>
    800059e6:	551c                	lw	a5,40(a0)
    800059e8:	e7b5                	bnez	a5,80005a54 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800059ea:	85ce                	mv	a1,s3
    800059ec:	854a                	mv	a0,s2
    800059ee:	ffffc097          	auipc	ra,0xffffc
    800059f2:	d38080e7          	jalr	-712(ra) # 80001726 <sleep>
    while(cons.r == cons.w){
    800059f6:	0984a783          	lw	a5,152(s1)
    800059fa:	09c4a703          	lw	a4,156(s1)
    800059fe:	fef700e3          	beq	a4,a5,800059de <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a02:	0017871b          	addiw	a4,a5,1
    80005a06:	08e4ac23          	sw	a4,152(s1)
    80005a0a:	07f7f713          	andi	a4,a5,127
    80005a0e:	9726                	add	a4,a4,s1
    80005a10:	01874703          	lbu	a4,24(a4)
    80005a14:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a18:	079c0663          	beq	s8,s9,80005a84 <consoleread+0x106>
    cbuf = c;
    80005a1c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a20:	4685                	li	a3,1
    80005a22:	f8f40613          	addi	a2,s0,-113
    80005a26:	85d6                	mv	a1,s5
    80005a28:	855a                	mv	a0,s6
    80005a2a:	ffffc097          	auipc	ra,0xffffc
    80005a2e:	0a0080e7          	jalr	160(ra) # 80001aca <either_copyout>
    80005a32:	01a50663          	beq	a0,s10,80005a3e <consoleread+0xc0>
    dst++;
    80005a36:	0a85                	addi	s5,s5,1
    --n;
    80005a38:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a3a:	f9bc1ae3          	bne	s8,s11,800059ce <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a3e:	00240517          	auipc	a0,0x240
    80005a42:	70250513          	addi	a0,a0,1794 # 80246140 <cons>
    80005a46:	00001097          	auipc	ra,0x1
    80005a4a:	910080e7          	jalr	-1776(ra) # 80006356 <release>

  return target - n;
    80005a4e:	414b853b          	subw	a0,s7,s4
    80005a52:	a811                	j	80005a66 <consoleread+0xe8>
        release(&cons.lock);
    80005a54:	00240517          	auipc	a0,0x240
    80005a58:	6ec50513          	addi	a0,a0,1772 # 80246140 <cons>
    80005a5c:	00001097          	auipc	ra,0x1
    80005a60:	8fa080e7          	jalr	-1798(ra) # 80006356 <release>
        return -1;
    80005a64:	557d                	li	a0,-1
}
    80005a66:	70e6                	ld	ra,120(sp)
    80005a68:	7446                	ld	s0,112(sp)
    80005a6a:	74a6                	ld	s1,104(sp)
    80005a6c:	7906                	ld	s2,96(sp)
    80005a6e:	69e6                	ld	s3,88(sp)
    80005a70:	6a46                	ld	s4,80(sp)
    80005a72:	6aa6                	ld	s5,72(sp)
    80005a74:	6b06                	ld	s6,64(sp)
    80005a76:	7be2                	ld	s7,56(sp)
    80005a78:	7c42                	ld	s8,48(sp)
    80005a7a:	7ca2                	ld	s9,40(sp)
    80005a7c:	7d02                	ld	s10,32(sp)
    80005a7e:	6de2                	ld	s11,24(sp)
    80005a80:	6109                	addi	sp,sp,128
    80005a82:	8082                	ret
      if(n < target){
    80005a84:	000a071b          	sext.w	a4,s4
    80005a88:	fb777be3          	bgeu	a4,s7,80005a3e <consoleread+0xc0>
        cons.r--;
    80005a8c:	00240717          	auipc	a4,0x240
    80005a90:	74f72623          	sw	a5,1868(a4) # 802461d8 <cons+0x98>
    80005a94:	b76d                	j	80005a3e <consoleread+0xc0>

0000000080005a96 <consputc>:
{
    80005a96:	1141                	addi	sp,sp,-16
    80005a98:	e406                	sd	ra,8(sp)
    80005a9a:	e022                	sd	s0,0(sp)
    80005a9c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a9e:	10000793          	li	a5,256
    80005aa2:	00f50a63          	beq	a0,a5,80005ab6 <consputc+0x20>
    uartputc_sync(c);
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	564080e7          	jalr	1380(ra) # 8000600a <uartputc_sync>
}
    80005aae:	60a2                	ld	ra,8(sp)
    80005ab0:	6402                	ld	s0,0(sp)
    80005ab2:	0141                	addi	sp,sp,16
    80005ab4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ab6:	4521                	li	a0,8
    80005ab8:	00000097          	auipc	ra,0x0
    80005abc:	552080e7          	jalr	1362(ra) # 8000600a <uartputc_sync>
    80005ac0:	02000513          	li	a0,32
    80005ac4:	00000097          	auipc	ra,0x0
    80005ac8:	546080e7          	jalr	1350(ra) # 8000600a <uartputc_sync>
    80005acc:	4521                	li	a0,8
    80005ace:	00000097          	auipc	ra,0x0
    80005ad2:	53c080e7          	jalr	1340(ra) # 8000600a <uartputc_sync>
    80005ad6:	bfe1                	j	80005aae <consputc+0x18>

0000000080005ad8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ad8:	1101                	addi	sp,sp,-32
    80005ada:	ec06                	sd	ra,24(sp)
    80005adc:	e822                	sd	s0,16(sp)
    80005ade:	e426                	sd	s1,8(sp)
    80005ae0:	e04a                	sd	s2,0(sp)
    80005ae2:	1000                	addi	s0,sp,32
    80005ae4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ae6:	00240517          	auipc	a0,0x240
    80005aea:	65a50513          	addi	a0,a0,1626 # 80246140 <cons>
    80005aee:	00000097          	auipc	ra,0x0
    80005af2:	7b4080e7          	jalr	1972(ra) # 800062a2 <acquire>

  switch(c){
    80005af6:	47d5                	li	a5,21
    80005af8:	0af48663          	beq	s1,a5,80005ba4 <consoleintr+0xcc>
    80005afc:	0297ca63          	blt	a5,s1,80005b30 <consoleintr+0x58>
    80005b00:	47a1                	li	a5,8
    80005b02:	0ef48763          	beq	s1,a5,80005bf0 <consoleintr+0x118>
    80005b06:	47c1                	li	a5,16
    80005b08:	10f49a63          	bne	s1,a5,80005c1c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b0c:	ffffc097          	auipc	ra,0xffffc
    80005b10:	06a080e7          	jalr	106(ra) # 80001b76 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b14:	00240517          	auipc	a0,0x240
    80005b18:	62c50513          	addi	a0,a0,1580 # 80246140 <cons>
    80005b1c:	00001097          	auipc	ra,0x1
    80005b20:	83a080e7          	jalr	-1990(ra) # 80006356 <release>
}
    80005b24:	60e2                	ld	ra,24(sp)
    80005b26:	6442                	ld	s0,16(sp)
    80005b28:	64a2                	ld	s1,8(sp)
    80005b2a:	6902                	ld	s2,0(sp)
    80005b2c:	6105                	addi	sp,sp,32
    80005b2e:	8082                	ret
  switch(c){
    80005b30:	07f00793          	li	a5,127
    80005b34:	0af48e63          	beq	s1,a5,80005bf0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b38:	00240717          	auipc	a4,0x240
    80005b3c:	60870713          	addi	a4,a4,1544 # 80246140 <cons>
    80005b40:	0a072783          	lw	a5,160(a4)
    80005b44:	09872703          	lw	a4,152(a4)
    80005b48:	9f99                	subw	a5,a5,a4
    80005b4a:	07f00713          	li	a4,127
    80005b4e:	fcf763e3          	bltu	a4,a5,80005b14 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b52:	47b5                	li	a5,13
    80005b54:	0cf48763          	beq	s1,a5,80005c22 <consoleintr+0x14a>
      consputc(c);
    80005b58:	8526                	mv	a0,s1
    80005b5a:	00000097          	auipc	ra,0x0
    80005b5e:	f3c080e7          	jalr	-196(ra) # 80005a96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b62:	00240797          	auipc	a5,0x240
    80005b66:	5de78793          	addi	a5,a5,1502 # 80246140 <cons>
    80005b6a:	0a07a703          	lw	a4,160(a5)
    80005b6e:	0017069b          	addiw	a3,a4,1
    80005b72:	0006861b          	sext.w	a2,a3
    80005b76:	0ad7a023          	sw	a3,160(a5)
    80005b7a:	07f77713          	andi	a4,a4,127
    80005b7e:	97ba                	add	a5,a5,a4
    80005b80:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005b84:	47a9                	li	a5,10
    80005b86:	0cf48563          	beq	s1,a5,80005c50 <consoleintr+0x178>
    80005b8a:	4791                	li	a5,4
    80005b8c:	0cf48263          	beq	s1,a5,80005c50 <consoleintr+0x178>
    80005b90:	00240797          	auipc	a5,0x240
    80005b94:	6487a783          	lw	a5,1608(a5) # 802461d8 <cons+0x98>
    80005b98:	0807879b          	addiw	a5,a5,128
    80005b9c:	f6f61ce3          	bne	a2,a5,80005b14 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ba0:	863e                	mv	a2,a5
    80005ba2:	a07d                	j	80005c50 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ba4:	00240717          	auipc	a4,0x240
    80005ba8:	59c70713          	addi	a4,a4,1436 # 80246140 <cons>
    80005bac:	0a072783          	lw	a5,160(a4)
    80005bb0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bb4:	00240497          	auipc	s1,0x240
    80005bb8:	58c48493          	addi	s1,s1,1420 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005bbc:	4929                	li	s2,10
    80005bbe:	f4f70be3          	beq	a4,a5,80005b14 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bc2:	37fd                	addiw	a5,a5,-1
    80005bc4:	07f7f713          	andi	a4,a5,127
    80005bc8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bca:	01874703          	lbu	a4,24(a4)
    80005bce:	f52703e3          	beq	a4,s2,80005b14 <consoleintr+0x3c>
      cons.e--;
    80005bd2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bd6:	10000513          	li	a0,256
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	ebc080e7          	jalr	-324(ra) # 80005a96 <consputc>
    while(cons.e != cons.w &&
    80005be2:	0a04a783          	lw	a5,160(s1)
    80005be6:	09c4a703          	lw	a4,156(s1)
    80005bea:	fcf71ce3          	bne	a4,a5,80005bc2 <consoleintr+0xea>
    80005bee:	b71d                	j	80005b14 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bf0:	00240717          	auipc	a4,0x240
    80005bf4:	55070713          	addi	a4,a4,1360 # 80246140 <cons>
    80005bf8:	0a072783          	lw	a5,160(a4)
    80005bfc:	09c72703          	lw	a4,156(a4)
    80005c00:	f0f70ae3          	beq	a4,a5,80005b14 <consoleintr+0x3c>
      cons.e--;
    80005c04:	37fd                	addiw	a5,a5,-1
    80005c06:	00240717          	auipc	a4,0x240
    80005c0a:	5cf72d23          	sw	a5,1498(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c0e:	10000513          	li	a0,256
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	e84080e7          	jalr	-380(ra) # 80005a96 <consputc>
    80005c1a:	bded                	j	80005b14 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c1c:	ee048ce3          	beqz	s1,80005b14 <consoleintr+0x3c>
    80005c20:	bf21                	j	80005b38 <consoleintr+0x60>
      consputc(c);
    80005c22:	4529                	li	a0,10
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	e72080e7          	jalr	-398(ra) # 80005a96 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c2c:	00240797          	auipc	a5,0x240
    80005c30:	51478793          	addi	a5,a5,1300 # 80246140 <cons>
    80005c34:	0a07a703          	lw	a4,160(a5)
    80005c38:	0017069b          	addiw	a3,a4,1
    80005c3c:	0006861b          	sext.w	a2,a3
    80005c40:	0ad7a023          	sw	a3,160(a5)
    80005c44:	07f77713          	andi	a4,a4,127
    80005c48:	97ba                	add	a5,a5,a4
    80005c4a:	4729                	li	a4,10
    80005c4c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c50:	00240797          	auipc	a5,0x240
    80005c54:	58c7a623          	sw	a2,1420(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c58:	00240517          	auipc	a0,0x240
    80005c5c:	58050513          	addi	a0,a0,1408 # 802461d8 <cons+0x98>
    80005c60:	ffffc097          	auipc	ra,0xffffc
    80005c64:	c52080e7          	jalr	-942(ra) # 800018b2 <wakeup>
    80005c68:	b575                	j	80005b14 <consoleintr+0x3c>

0000000080005c6a <consoleinit>:

void
consoleinit(void)
{
    80005c6a:	1141                	addi	sp,sp,-16
    80005c6c:	e406                	sd	ra,8(sp)
    80005c6e:	e022                	sd	s0,0(sp)
    80005c70:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c72:	00003597          	auipc	a1,0x3
    80005c76:	c0658593          	addi	a1,a1,-1018 # 80008878 <syscalls+0x3c8>
    80005c7a:	00240517          	auipc	a0,0x240
    80005c7e:	4c650513          	addi	a0,a0,1222 # 80246140 <cons>
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	590080e7          	jalr	1424(ra) # 80006212 <initlock>

  uartinit();
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	330080e7          	jalr	816(ra) # 80005fba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c92:	00233797          	auipc	a5,0x233
    80005c96:	43678793          	addi	a5,a5,1078 # 802390c8 <devsw>
    80005c9a:	00000717          	auipc	a4,0x0
    80005c9e:	ce470713          	addi	a4,a4,-796 # 8000597e <consoleread>
    80005ca2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ca4:	00000717          	auipc	a4,0x0
    80005ca8:	c7870713          	addi	a4,a4,-904 # 8000591c <consolewrite>
    80005cac:	ef98                	sd	a4,24(a5)
}
    80005cae:	60a2                	ld	ra,8(sp)
    80005cb0:	6402                	ld	s0,0(sp)
    80005cb2:	0141                	addi	sp,sp,16
    80005cb4:	8082                	ret

0000000080005cb6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cb6:	7179                	addi	sp,sp,-48
    80005cb8:	f406                	sd	ra,40(sp)
    80005cba:	f022                	sd	s0,32(sp)
    80005cbc:	ec26                	sd	s1,24(sp)
    80005cbe:	e84a                	sd	s2,16(sp)
    80005cc0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cc2:	c219                	beqz	a2,80005cc8 <printint+0x12>
    80005cc4:	08054663          	bltz	a0,80005d50 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cc8:	2501                	sext.w	a0,a0
    80005cca:	4881                	li	a7,0
    80005ccc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cd0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cd2:	2581                	sext.w	a1,a1
    80005cd4:	00003617          	auipc	a2,0x3
    80005cd8:	bd460613          	addi	a2,a2,-1068 # 800088a8 <digits>
    80005cdc:	883a                	mv	a6,a4
    80005cde:	2705                	addiw	a4,a4,1
    80005ce0:	02b577bb          	remuw	a5,a0,a1
    80005ce4:	1782                	slli	a5,a5,0x20
    80005ce6:	9381                	srli	a5,a5,0x20
    80005ce8:	97b2                	add	a5,a5,a2
    80005cea:	0007c783          	lbu	a5,0(a5)
    80005cee:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cf2:	0005079b          	sext.w	a5,a0
    80005cf6:	02b5553b          	divuw	a0,a0,a1
    80005cfa:	0685                	addi	a3,a3,1
    80005cfc:	feb7f0e3          	bgeu	a5,a1,80005cdc <printint+0x26>

  if(sign)
    80005d00:	00088b63          	beqz	a7,80005d16 <printint+0x60>
    buf[i++] = '-';
    80005d04:	fe040793          	addi	a5,s0,-32
    80005d08:	973e                	add	a4,a4,a5
    80005d0a:	02d00793          	li	a5,45
    80005d0e:	fef70823          	sb	a5,-16(a4)
    80005d12:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d16:	02e05763          	blez	a4,80005d44 <printint+0x8e>
    80005d1a:	fd040793          	addi	a5,s0,-48
    80005d1e:	00e784b3          	add	s1,a5,a4
    80005d22:	fff78913          	addi	s2,a5,-1
    80005d26:	993a                	add	s2,s2,a4
    80005d28:	377d                	addiw	a4,a4,-1
    80005d2a:	1702                	slli	a4,a4,0x20
    80005d2c:	9301                	srli	a4,a4,0x20
    80005d2e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d32:	fff4c503          	lbu	a0,-1(s1)
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	d60080e7          	jalr	-672(ra) # 80005a96 <consputc>
  while(--i >= 0)
    80005d3e:	14fd                	addi	s1,s1,-1
    80005d40:	ff2499e3          	bne	s1,s2,80005d32 <printint+0x7c>
}
    80005d44:	70a2                	ld	ra,40(sp)
    80005d46:	7402                	ld	s0,32(sp)
    80005d48:	64e2                	ld	s1,24(sp)
    80005d4a:	6942                	ld	s2,16(sp)
    80005d4c:	6145                	addi	sp,sp,48
    80005d4e:	8082                	ret
    x = -xx;
    80005d50:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d54:	4885                	li	a7,1
    x = -xx;
    80005d56:	bf9d                	j	80005ccc <printint+0x16>

0000000080005d58 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d58:	1101                	addi	sp,sp,-32
    80005d5a:	ec06                	sd	ra,24(sp)
    80005d5c:	e822                	sd	s0,16(sp)
    80005d5e:	e426                	sd	s1,8(sp)
    80005d60:	1000                	addi	s0,sp,32
    80005d62:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d64:	00240797          	auipc	a5,0x240
    80005d68:	4807ae23          	sw	zero,1180(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005d6c:	00003517          	auipc	a0,0x3
    80005d70:	b1450513          	addi	a0,a0,-1260 # 80008880 <syscalls+0x3d0>
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	02e080e7          	jalr	46(ra) # 80005da2 <printf>
  printf(s);
    80005d7c:	8526                	mv	a0,s1
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	024080e7          	jalr	36(ra) # 80005da2 <printf>
  printf("\n");
    80005d86:	00002517          	auipc	a0,0x2
    80005d8a:	2fa50513          	addi	a0,a0,762 # 80008080 <etext+0x80>
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	014080e7          	jalr	20(ra) # 80005da2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d96:	4785                	li	a5,1
    80005d98:	00003717          	auipc	a4,0x3
    80005d9c:	28f72223          	sw	a5,644(a4) # 8000901c <panicked>
  for(;;)
    80005da0:	a001                	j	80005da0 <panic+0x48>

0000000080005da2 <printf>:
{
    80005da2:	7131                	addi	sp,sp,-192
    80005da4:	fc86                	sd	ra,120(sp)
    80005da6:	f8a2                	sd	s0,112(sp)
    80005da8:	f4a6                	sd	s1,104(sp)
    80005daa:	f0ca                	sd	s2,96(sp)
    80005dac:	ecce                	sd	s3,88(sp)
    80005dae:	e8d2                	sd	s4,80(sp)
    80005db0:	e4d6                	sd	s5,72(sp)
    80005db2:	e0da                	sd	s6,64(sp)
    80005db4:	fc5e                	sd	s7,56(sp)
    80005db6:	f862                	sd	s8,48(sp)
    80005db8:	f466                	sd	s9,40(sp)
    80005dba:	f06a                	sd	s10,32(sp)
    80005dbc:	ec6e                	sd	s11,24(sp)
    80005dbe:	0100                	addi	s0,sp,128
    80005dc0:	8a2a                	mv	s4,a0
    80005dc2:	e40c                	sd	a1,8(s0)
    80005dc4:	e810                	sd	a2,16(s0)
    80005dc6:	ec14                	sd	a3,24(s0)
    80005dc8:	f018                	sd	a4,32(s0)
    80005dca:	f41c                	sd	a5,40(s0)
    80005dcc:	03043823          	sd	a6,48(s0)
    80005dd0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dd4:	00240d97          	auipc	s11,0x240
    80005dd8:	42cdad83          	lw	s11,1068(s11) # 80246200 <pr+0x18>
  if(locking)
    80005ddc:	020d9b63          	bnez	s11,80005e12 <printf+0x70>
  if (fmt == 0)
    80005de0:	040a0263          	beqz	s4,80005e24 <printf+0x82>
  va_start(ap, fmt);
    80005de4:	00840793          	addi	a5,s0,8
    80005de8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dec:	000a4503          	lbu	a0,0(s4)
    80005df0:	16050263          	beqz	a0,80005f54 <printf+0x1b2>
    80005df4:	4481                	li	s1,0
    if(c != '%'){
    80005df6:	02500a93          	li	s5,37
    switch(c){
    80005dfa:	07000b13          	li	s6,112
  consputc('x');
    80005dfe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e00:	00003b97          	auipc	s7,0x3
    80005e04:	aa8b8b93          	addi	s7,s7,-1368 # 800088a8 <digits>
    switch(c){
    80005e08:	07300c93          	li	s9,115
    80005e0c:	06400c13          	li	s8,100
    80005e10:	a82d                	j	80005e4a <printf+0xa8>
    acquire(&pr.lock);
    80005e12:	00240517          	auipc	a0,0x240
    80005e16:	3d650513          	addi	a0,a0,982 # 802461e8 <pr>
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	488080e7          	jalr	1160(ra) # 800062a2 <acquire>
    80005e22:	bf7d                	j	80005de0 <printf+0x3e>
    panic("null fmt");
    80005e24:	00003517          	auipc	a0,0x3
    80005e28:	a6c50513          	addi	a0,a0,-1428 # 80008890 <syscalls+0x3e0>
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	f2c080e7          	jalr	-212(ra) # 80005d58 <panic>
      consputc(c);
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	c62080e7          	jalr	-926(ra) # 80005a96 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e3c:	2485                	addiw	s1,s1,1
    80005e3e:	009a07b3          	add	a5,s4,s1
    80005e42:	0007c503          	lbu	a0,0(a5)
    80005e46:	10050763          	beqz	a0,80005f54 <printf+0x1b2>
    if(c != '%'){
    80005e4a:	ff5515e3          	bne	a0,s5,80005e34 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e4e:	2485                	addiw	s1,s1,1
    80005e50:	009a07b3          	add	a5,s4,s1
    80005e54:	0007c783          	lbu	a5,0(a5)
    80005e58:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e5c:	cfe5                	beqz	a5,80005f54 <printf+0x1b2>
    switch(c){
    80005e5e:	05678a63          	beq	a5,s6,80005eb2 <printf+0x110>
    80005e62:	02fb7663          	bgeu	s6,a5,80005e8e <printf+0xec>
    80005e66:	09978963          	beq	a5,s9,80005ef8 <printf+0x156>
    80005e6a:	07800713          	li	a4,120
    80005e6e:	0ce79863          	bne	a5,a4,80005f3e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e72:	f8843783          	ld	a5,-120(s0)
    80005e76:	00878713          	addi	a4,a5,8
    80005e7a:	f8e43423          	sd	a4,-120(s0)
    80005e7e:	4605                	li	a2,1
    80005e80:	85ea                	mv	a1,s10
    80005e82:	4388                	lw	a0,0(a5)
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	e32080e7          	jalr	-462(ra) # 80005cb6 <printint>
      break;
    80005e8c:	bf45                	j	80005e3c <printf+0x9a>
    switch(c){
    80005e8e:	0b578263          	beq	a5,s5,80005f32 <printf+0x190>
    80005e92:	0b879663          	bne	a5,s8,80005f3e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e96:	f8843783          	ld	a5,-120(s0)
    80005e9a:	00878713          	addi	a4,a5,8
    80005e9e:	f8e43423          	sd	a4,-120(s0)
    80005ea2:	4605                	li	a2,1
    80005ea4:	45a9                	li	a1,10
    80005ea6:	4388                	lw	a0,0(a5)
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	e0e080e7          	jalr	-498(ra) # 80005cb6 <printint>
      break;
    80005eb0:	b771                	j	80005e3c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005eb2:	f8843783          	ld	a5,-120(s0)
    80005eb6:	00878713          	addi	a4,a5,8
    80005eba:	f8e43423          	sd	a4,-120(s0)
    80005ebe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ec2:	03000513          	li	a0,48
    80005ec6:	00000097          	auipc	ra,0x0
    80005eca:	bd0080e7          	jalr	-1072(ra) # 80005a96 <consputc>
  consputc('x');
    80005ece:	07800513          	li	a0,120
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	bc4080e7          	jalr	-1084(ra) # 80005a96 <consputc>
    80005eda:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005edc:	03c9d793          	srli	a5,s3,0x3c
    80005ee0:	97de                	add	a5,a5,s7
    80005ee2:	0007c503          	lbu	a0,0(a5)
    80005ee6:	00000097          	auipc	ra,0x0
    80005eea:	bb0080e7          	jalr	-1104(ra) # 80005a96 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005eee:	0992                	slli	s3,s3,0x4
    80005ef0:	397d                	addiw	s2,s2,-1
    80005ef2:	fe0915e3          	bnez	s2,80005edc <printf+0x13a>
    80005ef6:	b799                	j	80005e3c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005ef8:	f8843783          	ld	a5,-120(s0)
    80005efc:	00878713          	addi	a4,a5,8
    80005f00:	f8e43423          	sd	a4,-120(s0)
    80005f04:	0007b903          	ld	s2,0(a5)
    80005f08:	00090e63          	beqz	s2,80005f24 <printf+0x182>
      for(; *s; s++)
    80005f0c:	00094503          	lbu	a0,0(s2)
    80005f10:	d515                	beqz	a0,80005e3c <printf+0x9a>
        consputc(*s);
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	b84080e7          	jalr	-1148(ra) # 80005a96 <consputc>
      for(; *s; s++)
    80005f1a:	0905                	addi	s2,s2,1
    80005f1c:	00094503          	lbu	a0,0(s2)
    80005f20:	f96d                	bnez	a0,80005f12 <printf+0x170>
    80005f22:	bf29                	j	80005e3c <printf+0x9a>
        s = "(null)";
    80005f24:	00003917          	auipc	s2,0x3
    80005f28:	96490913          	addi	s2,s2,-1692 # 80008888 <syscalls+0x3d8>
      for(; *s; s++)
    80005f2c:	02800513          	li	a0,40
    80005f30:	b7cd                	j	80005f12 <printf+0x170>
      consputc('%');
    80005f32:	8556                	mv	a0,s5
    80005f34:	00000097          	auipc	ra,0x0
    80005f38:	b62080e7          	jalr	-1182(ra) # 80005a96 <consputc>
      break;
    80005f3c:	b701                	j	80005e3c <printf+0x9a>
      consputc('%');
    80005f3e:	8556                	mv	a0,s5
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	b56080e7          	jalr	-1194(ra) # 80005a96 <consputc>
      consputc(c);
    80005f48:	854a                	mv	a0,s2
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	b4c080e7          	jalr	-1204(ra) # 80005a96 <consputc>
      break;
    80005f52:	b5ed                	j	80005e3c <printf+0x9a>
  if(locking)
    80005f54:	020d9163          	bnez	s11,80005f76 <printf+0x1d4>
}
    80005f58:	70e6                	ld	ra,120(sp)
    80005f5a:	7446                	ld	s0,112(sp)
    80005f5c:	74a6                	ld	s1,104(sp)
    80005f5e:	7906                	ld	s2,96(sp)
    80005f60:	69e6                	ld	s3,88(sp)
    80005f62:	6a46                	ld	s4,80(sp)
    80005f64:	6aa6                	ld	s5,72(sp)
    80005f66:	6b06                	ld	s6,64(sp)
    80005f68:	7be2                	ld	s7,56(sp)
    80005f6a:	7c42                	ld	s8,48(sp)
    80005f6c:	7ca2                	ld	s9,40(sp)
    80005f6e:	7d02                	ld	s10,32(sp)
    80005f70:	6de2                	ld	s11,24(sp)
    80005f72:	6129                	addi	sp,sp,192
    80005f74:	8082                	ret
    release(&pr.lock);
    80005f76:	00240517          	auipc	a0,0x240
    80005f7a:	27250513          	addi	a0,a0,626 # 802461e8 <pr>
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	3d8080e7          	jalr	984(ra) # 80006356 <release>
}
    80005f86:	bfc9                	j	80005f58 <printf+0x1b6>

0000000080005f88 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f88:	1101                	addi	sp,sp,-32
    80005f8a:	ec06                	sd	ra,24(sp)
    80005f8c:	e822                	sd	s0,16(sp)
    80005f8e:	e426                	sd	s1,8(sp)
    80005f90:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f92:	00240497          	auipc	s1,0x240
    80005f96:	25648493          	addi	s1,s1,598 # 802461e8 <pr>
    80005f9a:	00003597          	auipc	a1,0x3
    80005f9e:	90658593          	addi	a1,a1,-1786 # 800088a0 <syscalls+0x3f0>
    80005fa2:	8526                	mv	a0,s1
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	26e080e7          	jalr	622(ra) # 80006212 <initlock>
  pr.locking = 1;
    80005fac:	4785                	li	a5,1
    80005fae:	cc9c                	sw	a5,24(s1)
}
    80005fb0:	60e2                	ld	ra,24(sp)
    80005fb2:	6442                	ld	s0,16(sp)
    80005fb4:	64a2                	ld	s1,8(sp)
    80005fb6:	6105                	addi	sp,sp,32
    80005fb8:	8082                	ret

0000000080005fba <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fba:	1141                	addi	sp,sp,-16
    80005fbc:	e406                	sd	ra,8(sp)
    80005fbe:	e022                	sd	s0,0(sp)
    80005fc0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fc2:	100007b7          	lui	a5,0x10000
    80005fc6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fca:	f8000713          	li	a4,-128
    80005fce:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fd2:	470d                	li	a4,3
    80005fd4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fd8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fdc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fe0:	469d                	li	a3,7
    80005fe2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fe6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fea:	00003597          	auipc	a1,0x3
    80005fee:	8d658593          	addi	a1,a1,-1834 # 800088c0 <digits+0x18>
    80005ff2:	00240517          	auipc	a0,0x240
    80005ff6:	21650513          	addi	a0,a0,534 # 80246208 <uart_tx_lock>
    80005ffa:	00000097          	auipc	ra,0x0
    80005ffe:	218080e7          	jalr	536(ra) # 80006212 <initlock>
}
    80006002:	60a2                	ld	ra,8(sp)
    80006004:	6402                	ld	s0,0(sp)
    80006006:	0141                	addi	sp,sp,16
    80006008:	8082                	ret

000000008000600a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000600a:	1101                	addi	sp,sp,-32
    8000600c:	ec06                	sd	ra,24(sp)
    8000600e:	e822                	sd	s0,16(sp)
    80006010:	e426                	sd	s1,8(sp)
    80006012:	1000                	addi	s0,sp,32
    80006014:	84aa                	mv	s1,a0
  push_off();
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	240080e7          	jalr	576(ra) # 80006256 <push_off>

  if(panicked){
    8000601e:	00003797          	auipc	a5,0x3
    80006022:	ffe7a783          	lw	a5,-2(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006026:	10000737          	lui	a4,0x10000
  if(panicked){
    8000602a:	c391                	beqz	a5,8000602e <uartputc_sync+0x24>
    for(;;)
    8000602c:	a001                	j	8000602c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000602e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006032:	0ff7f793          	andi	a5,a5,255
    80006036:	0207f793          	andi	a5,a5,32
    8000603a:	dbf5                	beqz	a5,8000602e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000603c:	0ff4f793          	andi	a5,s1,255
    80006040:	10000737          	lui	a4,0x10000
    80006044:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006048:	00000097          	auipc	ra,0x0
    8000604c:	2ae080e7          	jalr	686(ra) # 800062f6 <pop_off>
}
    80006050:	60e2                	ld	ra,24(sp)
    80006052:	6442                	ld	s0,16(sp)
    80006054:	64a2                	ld	s1,8(sp)
    80006056:	6105                	addi	sp,sp,32
    80006058:	8082                	ret

000000008000605a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000605a:	00003717          	auipc	a4,0x3
    8000605e:	fc673703          	ld	a4,-58(a4) # 80009020 <uart_tx_r>
    80006062:	00003797          	auipc	a5,0x3
    80006066:	fc67b783          	ld	a5,-58(a5) # 80009028 <uart_tx_w>
    8000606a:	06e78c63          	beq	a5,a4,800060e2 <uartstart+0x88>
{
    8000606e:	7139                	addi	sp,sp,-64
    80006070:	fc06                	sd	ra,56(sp)
    80006072:	f822                	sd	s0,48(sp)
    80006074:	f426                	sd	s1,40(sp)
    80006076:	f04a                	sd	s2,32(sp)
    80006078:	ec4e                	sd	s3,24(sp)
    8000607a:	e852                	sd	s4,16(sp)
    8000607c:	e456                	sd	s5,8(sp)
    8000607e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006080:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006084:	00240a17          	auipc	s4,0x240
    80006088:	184a0a13          	addi	s4,s4,388 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    8000608c:	00003497          	auipc	s1,0x3
    80006090:	f9448493          	addi	s1,s1,-108 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006094:	00003997          	auipc	s3,0x3
    80006098:	f9498993          	addi	s3,s3,-108 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000609c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060a0:	0ff7f793          	andi	a5,a5,255
    800060a4:	0207f793          	andi	a5,a5,32
    800060a8:	c785                	beqz	a5,800060d0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060aa:	01f77793          	andi	a5,a4,31
    800060ae:	97d2                	add	a5,a5,s4
    800060b0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060b4:	0705                	addi	a4,a4,1
    800060b6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060b8:	8526                	mv	a0,s1
    800060ba:	ffffb097          	auipc	ra,0xffffb
    800060be:	7f8080e7          	jalr	2040(ra) # 800018b2 <wakeup>
    
    WriteReg(THR, c);
    800060c2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060c6:	6098                	ld	a4,0(s1)
    800060c8:	0009b783          	ld	a5,0(s3)
    800060cc:	fce798e3          	bne	a5,a4,8000609c <uartstart+0x42>
  }
}
    800060d0:	70e2                	ld	ra,56(sp)
    800060d2:	7442                	ld	s0,48(sp)
    800060d4:	74a2                	ld	s1,40(sp)
    800060d6:	7902                	ld	s2,32(sp)
    800060d8:	69e2                	ld	s3,24(sp)
    800060da:	6a42                	ld	s4,16(sp)
    800060dc:	6aa2                	ld	s5,8(sp)
    800060de:	6121                	addi	sp,sp,64
    800060e0:	8082                	ret
    800060e2:	8082                	ret

00000000800060e4 <uartputc>:
{
    800060e4:	7179                	addi	sp,sp,-48
    800060e6:	f406                	sd	ra,40(sp)
    800060e8:	f022                	sd	s0,32(sp)
    800060ea:	ec26                	sd	s1,24(sp)
    800060ec:	e84a                	sd	s2,16(sp)
    800060ee:	e44e                	sd	s3,8(sp)
    800060f0:	e052                	sd	s4,0(sp)
    800060f2:	1800                	addi	s0,sp,48
    800060f4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060f6:	00240517          	auipc	a0,0x240
    800060fa:	11250513          	addi	a0,a0,274 # 80246208 <uart_tx_lock>
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	1a4080e7          	jalr	420(ra) # 800062a2 <acquire>
  if(panicked){
    80006106:	00003797          	auipc	a5,0x3
    8000610a:	f167a783          	lw	a5,-234(a5) # 8000901c <panicked>
    8000610e:	c391                	beqz	a5,80006112 <uartputc+0x2e>
    for(;;)
    80006110:	a001                	j	80006110 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006112:	00003797          	auipc	a5,0x3
    80006116:	f167b783          	ld	a5,-234(a5) # 80009028 <uart_tx_w>
    8000611a:	00003717          	auipc	a4,0x3
    8000611e:	f0673703          	ld	a4,-250(a4) # 80009020 <uart_tx_r>
    80006122:	02070713          	addi	a4,a4,32
    80006126:	02f71b63          	bne	a4,a5,8000615c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000612a:	00240a17          	auipc	s4,0x240
    8000612e:	0dea0a13          	addi	s4,s4,222 # 80246208 <uart_tx_lock>
    80006132:	00003497          	auipc	s1,0x3
    80006136:	eee48493          	addi	s1,s1,-274 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000613a:	00003917          	auipc	s2,0x3
    8000613e:	eee90913          	addi	s2,s2,-274 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006142:	85d2                	mv	a1,s4
    80006144:	8526                	mv	a0,s1
    80006146:	ffffb097          	auipc	ra,0xffffb
    8000614a:	5e0080e7          	jalr	1504(ra) # 80001726 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000614e:	00093783          	ld	a5,0(s2)
    80006152:	6098                	ld	a4,0(s1)
    80006154:	02070713          	addi	a4,a4,32
    80006158:	fef705e3          	beq	a4,a5,80006142 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000615c:	00240497          	auipc	s1,0x240
    80006160:	0ac48493          	addi	s1,s1,172 # 80246208 <uart_tx_lock>
    80006164:	01f7f713          	andi	a4,a5,31
    80006168:	9726                	add	a4,a4,s1
    8000616a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000616e:	0785                	addi	a5,a5,1
    80006170:	00003717          	auipc	a4,0x3
    80006174:	eaf73c23          	sd	a5,-328(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	ee2080e7          	jalr	-286(ra) # 8000605a <uartstart>
      release(&uart_tx_lock);
    80006180:	8526                	mv	a0,s1
    80006182:	00000097          	auipc	ra,0x0
    80006186:	1d4080e7          	jalr	468(ra) # 80006356 <release>
}
    8000618a:	70a2                	ld	ra,40(sp)
    8000618c:	7402                	ld	s0,32(sp)
    8000618e:	64e2                	ld	s1,24(sp)
    80006190:	6942                	ld	s2,16(sp)
    80006192:	69a2                	ld	s3,8(sp)
    80006194:	6a02                	ld	s4,0(sp)
    80006196:	6145                	addi	sp,sp,48
    80006198:	8082                	ret

000000008000619a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000619a:	1141                	addi	sp,sp,-16
    8000619c:	e422                	sd	s0,8(sp)
    8000619e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061a0:	100007b7          	lui	a5,0x10000
    800061a4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061a8:	8b85                	andi	a5,a5,1
    800061aa:	cb91                	beqz	a5,800061be <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061ac:	100007b7          	lui	a5,0x10000
    800061b0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061b4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061b8:	6422                	ld	s0,8(sp)
    800061ba:	0141                	addi	sp,sp,16
    800061bc:	8082                	ret
    return -1;
    800061be:	557d                	li	a0,-1
    800061c0:	bfe5                	j	800061b8 <uartgetc+0x1e>

00000000800061c2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061c2:	1101                	addi	sp,sp,-32
    800061c4:	ec06                	sd	ra,24(sp)
    800061c6:	e822                	sd	s0,16(sp)
    800061c8:	e426                	sd	s1,8(sp)
    800061ca:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061cc:	54fd                	li	s1,-1
    int c = uartgetc();
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	fcc080e7          	jalr	-52(ra) # 8000619a <uartgetc>
    if(c == -1)
    800061d6:	00950763          	beq	a0,s1,800061e4 <uartintr+0x22>
      break;
    consoleintr(c);
    800061da:	00000097          	auipc	ra,0x0
    800061de:	8fe080e7          	jalr	-1794(ra) # 80005ad8 <consoleintr>
  while(1){
    800061e2:	b7f5                	j	800061ce <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061e4:	00240497          	auipc	s1,0x240
    800061e8:	02448493          	addi	s1,s1,36 # 80246208 <uart_tx_lock>
    800061ec:	8526                	mv	a0,s1
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	0b4080e7          	jalr	180(ra) # 800062a2 <acquire>
  uartstart();
    800061f6:	00000097          	auipc	ra,0x0
    800061fa:	e64080e7          	jalr	-412(ra) # 8000605a <uartstart>
  release(&uart_tx_lock);
    800061fe:	8526                	mv	a0,s1
    80006200:	00000097          	auipc	ra,0x0
    80006204:	156080e7          	jalr	342(ra) # 80006356 <release>
}
    80006208:	60e2                	ld	ra,24(sp)
    8000620a:	6442                	ld	s0,16(sp)
    8000620c:	64a2                	ld	s1,8(sp)
    8000620e:	6105                	addi	sp,sp,32
    80006210:	8082                	ret

0000000080006212 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006212:	1141                	addi	sp,sp,-16
    80006214:	e422                	sd	s0,8(sp)
    80006216:	0800                	addi	s0,sp,16
  lk->name = name;
    80006218:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000621a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000621e:	00053823          	sd	zero,16(a0)
}
    80006222:	6422                	ld	s0,8(sp)
    80006224:	0141                	addi	sp,sp,16
    80006226:	8082                	ret

0000000080006228 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006228:	411c                	lw	a5,0(a0)
    8000622a:	e399                	bnez	a5,80006230 <holding+0x8>
    8000622c:	4501                	li	a0,0
  return r;
}
    8000622e:	8082                	ret
{
    80006230:	1101                	addi	sp,sp,-32
    80006232:	ec06                	sd	ra,24(sp)
    80006234:	e822                	sd	s0,16(sp)
    80006236:	e426                	sd	s1,8(sp)
    80006238:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000623a:	6904                	ld	s1,16(a0)
    8000623c:	ffffb097          	auipc	ra,0xffffb
    80006240:	e12080e7          	jalr	-494(ra) # 8000104e <mycpu>
    80006244:	40a48533          	sub	a0,s1,a0
    80006248:	00153513          	seqz	a0,a0
}
    8000624c:	60e2                	ld	ra,24(sp)
    8000624e:	6442                	ld	s0,16(sp)
    80006250:	64a2                	ld	s1,8(sp)
    80006252:	6105                	addi	sp,sp,32
    80006254:	8082                	ret

0000000080006256 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006256:	1101                	addi	sp,sp,-32
    80006258:	ec06                	sd	ra,24(sp)
    8000625a:	e822                	sd	s0,16(sp)
    8000625c:	e426                	sd	s1,8(sp)
    8000625e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006260:	100024f3          	csrr	s1,sstatus
    80006264:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006268:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	de0080e7          	jalr	-544(ra) # 8000104e <mycpu>
    80006276:	5d3c                	lw	a5,120(a0)
    80006278:	cf89                	beqz	a5,80006292 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000627a:	ffffb097          	auipc	ra,0xffffb
    8000627e:	dd4080e7          	jalr	-556(ra) # 8000104e <mycpu>
    80006282:	5d3c                	lw	a5,120(a0)
    80006284:	2785                	addiw	a5,a5,1
    80006286:	dd3c                	sw	a5,120(a0)
}
    80006288:	60e2                	ld	ra,24(sp)
    8000628a:	6442                	ld	s0,16(sp)
    8000628c:	64a2                	ld	s1,8(sp)
    8000628e:	6105                	addi	sp,sp,32
    80006290:	8082                	ret
    mycpu()->intena = old;
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	dbc080e7          	jalr	-580(ra) # 8000104e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000629a:	8085                	srli	s1,s1,0x1
    8000629c:	8885                	andi	s1,s1,1
    8000629e:	dd64                	sw	s1,124(a0)
    800062a0:	bfe9                	j	8000627a <push_off+0x24>

00000000800062a2 <acquire>:
{
    800062a2:	1101                	addi	sp,sp,-32
    800062a4:	ec06                	sd	ra,24(sp)
    800062a6:	e822                	sd	s0,16(sp)
    800062a8:	e426                	sd	s1,8(sp)
    800062aa:	1000                	addi	s0,sp,32
    800062ac:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	fa8080e7          	jalr	-88(ra) # 80006256 <push_off>
  if(holding(lk))
    800062b6:	8526                	mv	a0,s1
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	f70080e7          	jalr	-144(ra) # 80006228 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062c0:	4705                	li	a4,1
  if(holding(lk))
    800062c2:	e115                	bnez	a0,800062e6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062c4:	87ba                	mv	a5,a4
    800062c6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062ca:	2781                	sext.w	a5,a5
    800062cc:	ffe5                	bnez	a5,800062c4 <acquire+0x22>
  __sync_synchronize();
    800062ce:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062d2:	ffffb097          	auipc	ra,0xffffb
    800062d6:	d7c080e7          	jalr	-644(ra) # 8000104e <mycpu>
    800062da:	e888                	sd	a0,16(s1)
}
    800062dc:	60e2                	ld	ra,24(sp)
    800062de:	6442                	ld	s0,16(sp)
    800062e0:	64a2                	ld	s1,8(sp)
    800062e2:	6105                	addi	sp,sp,32
    800062e4:	8082                	ret
    panic("acquire");
    800062e6:	00002517          	auipc	a0,0x2
    800062ea:	5e250513          	addi	a0,a0,1506 # 800088c8 <digits+0x20>
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	a6a080e7          	jalr	-1430(ra) # 80005d58 <panic>

00000000800062f6 <pop_off>:

void
pop_off(void)
{
    800062f6:	1141                	addi	sp,sp,-16
    800062f8:	e406                	sd	ra,8(sp)
    800062fa:	e022                	sd	s0,0(sp)
    800062fc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062fe:	ffffb097          	auipc	ra,0xffffb
    80006302:	d50080e7          	jalr	-688(ra) # 8000104e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006306:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000630a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000630c:	e78d                	bnez	a5,80006336 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000630e:	5d3c                	lw	a5,120(a0)
    80006310:	02f05b63          	blez	a5,80006346 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006314:	37fd                	addiw	a5,a5,-1
    80006316:	0007871b          	sext.w	a4,a5
    8000631a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000631c:	eb09                	bnez	a4,8000632e <pop_off+0x38>
    8000631e:	5d7c                	lw	a5,124(a0)
    80006320:	c799                	beqz	a5,8000632e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006322:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006326:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000632a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000632e:	60a2                	ld	ra,8(sp)
    80006330:	6402                	ld	s0,0(sp)
    80006332:	0141                	addi	sp,sp,16
    80006334:	8082                	ret
    panic("pop_off - interruptible");
    80006336:	00002517          	auipc	a0,0x2
    8000633a:	59a50513          	addi	a0,a0,1434 # 800088d0 <digits+0x28>
    8000633e:	00000097          	auipc	ra,0x0
    80006342:	a1a080e7          	jalr	-1510(ra) # 80005d58 <panic>
    panic("pop_off");
    80006346:	00002517          	auipc	a0,0x2
    8000634a:	5a250513          	addi	a0,a0,1442 # 800088e8 <digits+0x40>
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	a0a080e7          	jalr	-1526(ra) # 80005d58 <panic>

0000000080006356 <release>:
{
    80006356:	1101                	addi	sp,sp,-32
    80006358:	ec06                	sd	ra,24(sp)
    8000635a:	e822                	sd	s0,16(sp)
    8000635c:	e426                	sd	s1,8(sp)
    8000635e:	1000                	addi	s0,sp,32
    80006360:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006362:	00000097          	auipc	ra,0x0
    80006366:	ec6080e7          	jalr	-314(ra) # 80006228 <holding>
    8000636a:	c115                	beqz	a0,8000638e <release+0x38>
  lk->cpu = 0;
    8000636c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006370:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006374:	0f50000f          	fence	iorw,ow
    80006378:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	f7a080e7          	jalr	-134(ra) # 800062f6 <pop_off>
}
    80006384:	60e2                	ld	ra,24(sp)
    80006386:	6442                	ld	s0,16(sp)
    80006388:	64a2                	ld	s1,8(sp)
    8000638a:	6105                	addi	sp,sp,32
    8000638c:	8082                	ret
    panic("release");
    8000638e:	00002517          	auipc	a0,0x2
    80006392:	56250513          	addi	a0,a0,1378 # 800088f0 <digits+0x48>
    80006396:	00000097          	auipc	ra,0x0
    8000639a:	9c2080e7          	jalr	-1598(ra) # 80005d58 <panic>
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
