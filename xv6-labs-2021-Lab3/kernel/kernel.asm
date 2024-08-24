
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0d3050ef          	jal	ra,800058e8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	ff090913          	addi	s2,s2,-16 # 80009040 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	288080e7          	jalr	648(ra) # 800062e2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	328080e7          	jalr	808(ra) # 80006396 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d0e080e7          	jalr	-754(ra) # 80005d98 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f5450513          	addi	a0,a0,-172 # 80009040 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	15e080e7          	jalr	350(ra) # 80006252 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f1e48493          	addi	s1,s1,-226 # 80009040 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	1b6080e7          	jalr	438(ra) # 800062e2 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	f0650513          	addi	a0,a0,-250 # 80009040 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	252080e7          	jalr	594(ra) # 80006396 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eda50513          	addi	a0,a0,-294 # 80009040 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	228080e7          	jalr	552(ra) # 80006396 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	be4080e7          	jalr	-1052(ra) # 80000f12 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	bc8080e7          	jalr	-1080(ra) # 80000f12 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	a86080e7          	jalr	-1402(ra) # 80005de2 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	8a4080e7          	jalr	-1884(ra) # 80001c10 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	efc080e7          	jalr	-260(ra) # 80005270 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	152080e7          	jalr	338(ra) # 800014ce <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	926080e7          	jalr	-1754(ra) # 80005caa <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c3c080e7          	jalr	-964(ra) # 80005fc8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a46080e7          	jalr	-1466(ra) # 80005de2 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a36080e7          	jalr	-1482(ra) # 80005de2 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a26080e7          	jalr	-1498(ra) # 80005de2 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	a88080e7          	jalr	-1400(ra) # 80000e64 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	804080e7          	jalr	-2044(ra) # 80001be8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	824080e7          	jalr	-2012(ra) # 80001c10 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e66080e7          	jalr	-410(ra) # 8000525a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	e74080e7          	jalr	-396(ra) # 80005270 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	03e080e7          	jalr	62(ra) # 80002442 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	6ce080e7          	jalr	1742(ra) # 80002ada <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	678080e7          	jalr	1656(ra) # 80003a8c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	f76080e7          	jalr	-138(ra) # 80005392 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	e78080e7          	jalr	-392(ra) # 8000129c <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bce7b783          	ld	a5,-1074(a5) # 80009010 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	90a080e7          	jalr	-1782(ra) # 80005d98 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	812080e7          	jalr	-2030(ra) # 80005d98 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	802080e7          	jalr	-2046(ra) # 80005d98 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	788080e7          	jalr	1928(ra) # 80005d98 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	6f8080e7          	jalr	1784(ra) # 80000dd0 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b923          	sd	a0,-1774(a5) # 80009010 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	63c080e7          	jalr	1596(ra) # 80005d98 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	62c080e7          	jalr	1580(ra) # 80005d98 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	61c080e7          	jalr	1564(ra) # 80005d98 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	60c080e7          	jalr	1548(ra) # 80005d98 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	52e080e7          	jalr	1326(ra) # 80005d98 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	3ec080e7          	jalr	1004(ra) # 80005d98 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <vmprint>:

void
vmprint(pagetable_t pagetable)
{
    800009ce:	711d                	addi	sp,sp,-96
    800009d0:	ec86                	sd	ra,88(sp)
    800009d2:	e8a2                	sd	s0,80(sp)
    800009d4:	e4a6                	sd	s1,72(sp)
    800009d6:	e0ca                	sd	s2,64(sp)
    800009d8:	fc4e                	sd	s3,56(sp)
    800009da:	f852                	sd	s4,48(sp)
    800009dc:	f456                	sd	s5,40(sp)
    800009de:	f05a                	sd	s6,32(sp)
    800009e0:	ec5e                	sd	s7,24(sp)
    800009e2:	e862                	sd	s8,16(sp)
    800009e4:	e466                	sd	s9,8(sp)
    800009e6:	e06a                	sd	s10,0(sp)
    800009e8:	1080                	addi	s0,sp,96
    800009ea:	8a2a                	mv	s4,a0
  // vmprint times(0,1,2)
  static int num = 0;
  if(num == 0)
    800009ec:	00008797          	auipc	a5,0x8
    800009f0:	61c7a783          	lw	a5,1564(a5) # 80009008 <num.1608>
    800009f4:	c39d                	beqz	a5,80000a1a <vmprint+0x4c>
{
    800009f6:	4901                	li	s2,0
    printf("page table %p\n",pagetable);
  for(int i = 0;i<512;i++){
    pte_t pte =pagetable[i];
    if(pte & PTE_V){
      for(int j=0;j<=num; ++j){
    800009f8:	00008997          	auipc	s3,0x8
    800009fc:	61098993          	addi	s3,s3,1552 # 80009008 <num.1608>
        printf(" ..");
      }
      if(num!=2){
    80000a00:	4c09                	li	s8,2
        uint64 child = PTE2PA(pte);
        ++num;;
        vmprint((pagetable_t)child);
        --num;
      }else{
        printf("%d: pte %p pa %p\n",i,pte,PTE2PA(pte));
    80000a02:	00007c97          	auipc	s9,0x7
    80000a06:	71ec8c93          	addi	s9,s9,1822 # 80008120 <etext+0x120>
      for(int j=0;j<=num; ++j){
    80000a0a:	4d01                	li	s10,0
        printf(" ..");
    80000a0c:	00007b17          	auipc	s6,0x7
    80000a10:	70cb0b13          	addi	s6,s6,1804 # 80008118 <etext+0x118>
  for(int i = 0;i<512;i++){
    80000a14:	20000b93          	li	s7,512
    80000a18:	a889                	j	80000a6a <vmprint+0x9c>
    printf("page table %p\n",pagetable);
    80000a1a:	85aa                	mv	a1,a0
    80000a1c:	00007517          	auipc	a0,0x7
    80000a20:	6ec50513          	addi	a0,a0,1772 # 80008108 <etext+0x108>
    80000a24:	00005097          	auipc	ra,0x5
    80000a28:	3be080e7          	jalr	958(ra) # 80005de2 <printf>
    80000a2c:	b7e9                	j	800009f6 <vmprint+0x28>
        printf("%d: pte %p pa %p\n",i,pte,PTE2PA(pte));
    80000a2e:	00aad493          	srli	s1,s5,0xa
    80000a32:	04b2                	slli	s1,s1,0xc
    80000a34:	86a6                	mv	a3,s1
    80000a36:	8656                	mv	a2,s5
    80000a38:	85ca                	mv	a1,s2
    80000a3a:	8566                	mv	a0,s9
    80000a3c:	00005097          	auipc	ra,0x5
    80000a40:	3a6080e7          	jalr	934(ra) # 80005de2 <printf>
        ++num;;
    80000a44:	0009a783          	lw	a5,0(s3)
    80000a48:	2785                	addiw	a5,a5,1
    80000a4a:	00f9a023          	sw	a5,0(s3)
        vmprint((pagetable_t)child);
    80000a4e:	8526                	mv	a0,s1
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	f7e080e7          	jalr	-130(ra) # 800009ce <vmprint>
        --num;
    80000a58:	0009a783          	lw	a5,0(s3)
    80000a5c:	37fd                	addiw	a5,a5,-1
    80000a5e:	00f9a023          	sw	a5,0(s3)
  for(int i = 0;i<512;i++){
    80000a62:	2905                	addiw	s2,s2,1
    80000a64:	0a21                	addi	s4,s4,8
    80000a66:	05790363          	beq	s2,s7,80000aac <vmprint+0xde>
    pte_t pte =pagetable[i];
    80000a6a:	000a3a83          	ld	s5,0(s4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    if(pte & PTE_V){
    80000a6e:	001af793          	andi	a5,s5,1
    80000a72:	dbe5                	beqz	a5,80000a62 <vmprint+0x94>
      for(int j=0;j<=num; ++j){
    80000a74:	0009a783          	lw	a5,0(s3)
    80000a78:	0007cd63          	bltz	a5,80000a92 <vmprint+0xc4>
    80000a7c:	84ea                	mv	s1,s10
        printf(" ..");
    80000a7e:	855a                	mv	a0,s6
    80000a80:	00005097          	auipc	ra,0x5
    80000a84:	362080e7          	jalr	866(ra) # 80005de2 <printf>
      for(int j=0;j<=num; ++j){
    80000a88:	2485                	addiw	s1,s1,1
    80000a8a:	0009a783          	lw	a5,0(s3)
    80000a8e:	fe97d8e3          	bge	a5,s1,80000a7e <vmprint+0xb0>
      if(num!=2){
    80000a92:	f9879ee3          	bne	a5,s8,80000a2e <vmprint+0x60>
        printf("%d: pte %p pa %p\n",i,pte,PTE2PA(pte));
    80000a96:	00aad693          	srli	a3,s5,0xa
    80000a9a:	06b2                	slli	a3,a3,0xc
    80000a9c:	8656                	mv	a2,s5
    80000a9e:	85ca                	mv	a1,s2
    80000aa0:	8566                	mv	a0,s9
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	340080e7          	jalr	832(ra) # 80005de2 <printf>
    80000aaa:	bf65                	j	80000a62 <vmprint+0x94>
      }
    }
  }
}
    80000aac:	60e6                	ld	ra,88(sp)
    80000aae:	6446                	ld	s0,80(sp)
    80000ab0:	64a6                	ld	s1,72(sp)
    80000ab2:	6906                	ld	s2,64(sp)
    80000ab4:	79e2                	ld	s3,56(sp)
    80000ab6:	7a42                	ld	s4,48(sp)
    80000ab8:	7aa2                	ld	s5,40(sp)
    80000aba:	7b02                	ld	s6,32(sp)
    80000abc:	6be2                	ld	s7,24(sp)
    80000abe:	6c42                	ld	s8,16(sp)
    80000ac0:	6ca2                	ld	s9,8(sp)
    80000ac2:	6d02                	ld	s10,0(sp)
    80000ac4:	6125                	addi	sp,sp,96
    80000ac6:	8082                	ret

0000000080000ac8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ac8:	1101                	addi	sp,sp,-32
    80000aca:	ec06                	sd	ra,24(sp)
    80000acc:	e822                	sd	s0,16(sp)
    80000ace:	e426                	sd	s1,8(sp)
    80000ad0:	1000                	addi	s0,sp,32
    80000ad2:	84aa                	mv	s1,a0
  if(sz > 0)
    80000ad4:	e999                	bnez	a1,80000aea <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000ad6:	8526                	mv	a0,s1
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	e8c080e7          	jalr	-372(ra) # 80000964 <freewalk>
}
    80000ae0:	60e2                	ld	ra,24(sp)
    80000ae2:	6442                	ld	s0,16(sp)
    80000ae4:	64a2                	ld	s1,8(sp)
    80000ae6:	6105                	addi	sp,sp,32
    80000ae8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000aea:	6605                	lui	a2,0x1
    80000aec:	167d                	addi	a2,a2,-1
    80000aee:	962e                	add	a2,a2,a1
    80000af0:	4685                	li	a3,1
    80000af2:	8231                	srli	a2,a2,0xc
    80000af4:	4581                	li	a1,0
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	c18080e7          	jalr	-1000(ra) # 8000070e <uvmunmap>
    80000afe:	bfe1                	j	80000ad6 <uvmfree+0xe>

0000000080000b00 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b00:	c679                	beqz	a2,80000bce <uvmcopy+0xce>
{
    80000b02:	715d                	addi	sp,sp,-80
    80000b04:	e486                	sd	ra,72(sp)
    80000b06:	e0a2                	sd	s0,64(sp)
    80000b08:	fc26                	sd	s1,56(sp)
    80000b0a:	f84a                	sd	s2,48(sp)
    80000b0c:	f44e                	sd	s3,40(sp)
    80000b0e:	f052                	sd	s4,32(sp)
    80000b10:	ec56                	sd	s5,24(sp)
    80000b12:	e85a                	sd	s6,16(sp)
    80000b14:	e45e                	sd	s7,8(sp)
    80000b16:	0880                	addi	s0,sp,80
    80000b18:	8b2a                	mv	s6,a0
    80000b1a:	8aae                	mv	s5,a1
    80000b1c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b1e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b20:	4601                	li	a2,0
    80000b22:	85ce                	mv	a1,s3
    80000b24:	855a                	mv	a0,s6
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	93a080e7          	jalr	-1734(ra) # 80000460 <walk>
    80000b2e:	c531                	beqz	a0,80000b7a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b30:	6118                	ld	a4,0(a0)
    80000b32:	00177793          	andi	a5,a4,1
    80000b36:	cbb1                	beqz	a5,80000b8a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b38:	00a75593          	srli	a1,a4,0xa
    80000b3c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b40:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b44:	fffff097          	auipc	ra,0xfffff
    80000b48:	5d4080e7          	jalr	1492(ra) # 80000118 <kalloc>
    80000b4c:	892a                	mv	s2,a0
    80000b4e:	c939                	beqz	a0,80000ba4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b50:	6605                	lui	a2,0x1
    80000b52:	85de                	mv	a1,s7
    80000b54:	fffff097          	auipc	ra,0xfffff
    80000b58:	684080e7          	jalr	1668(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b5c:	8726                	mv	a4,s1
    80000b5e:	86ca                	mv	a3,s2
    80000b60:	6605                	lui	a2,0x1
    80000b62:	85ce                	mv	a1,s3
    80000b64:	8556                	mv	a0,s5
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	9e2080e7          	jalr	-1566(ra) # 80000548 <mappages>
    80000b6e:	e515                	bnez	a0,80000b9a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b70:	6785                	lui	a5,0x1
    80000b72:	99be                	add	s3,s3,a5
    80000b74:	fb49e6e3          	bltu	s3,s4,80000b20 <uvmcopy+0x20>
    80000b78:	a081                	j	80000bb8 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b7a:	00007517          	auipc	a0,0x7
    80000b7e:	5be50513          	addi	a0,a0,1470 # 80008138 <etext+0x138>
    80000b82:	00005097          	auipc	ra,0x5
    80000b86:	216080e7          	jalr	534(ra) # 80005d98 <panic>
      panic("uvmcopy: page not present");
    80000b8a:	00007517          	auipc	a0,0x7
    80000b8e:	5ce50513          	addi	a0,a0,1486 # 80008158 <etext+0x158>
    80000b92:	00005097          	auipc	ra,0x5
    80000b96:	206080e7          	jalr	518(ra) # 80005d98 <panic>
      kfree(mem);
    80000b9a:	854a                	mv	a0,s2
    80000b9c:	fffff097          	auipc	ra,0xfffff
    80000ba0:	480080e7          	jalr	1152(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ba4:	4685                	li	a3,1
    80000ba6:	00c9d613          	srli	a2,s3,0xc
    80000baa:	4581                	li	a1,0
    80000bac:	8556                	mv	a0,s5
    80000bae:	00000097          	auipc	ra,0x0
    80000bb2:	b60080e7          	jalr	-1184(ra) # 8000070e <uvmunmap>
  return -1;
    80000bb6:	557d                	li	a0,-1
}
    80000bb8:	60a6                	ld	ra,72(sp)
    80000bba:	6406                	ld	s0,64(sp)
    80000bbc:	74e2                	ld	s1,56(sp)
    80000bbe:	7942                	ld	s2,48(sp)
    80000bc0:	79a2                	ld	s3,40(sp)
    80000bc2:	7a02                	ld	s4,32(sp)
    80000bc4:	6ae2                	ld	s5,24(sp)
    80000bc6:	6b42                	ld	s6,16(sp)
    80000bc8:	6ba2                	ld	s7,8(sp)
    80000bca:	6161                	addi	sp,sp,80
    80000bcc:	8082                	ret
  return 0;
    80000bce:	4501                	li	a0,0
}
    80000bd0:	8082                	ret

0000000080000bd2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bd2:	1141                	addi	sp,sp,-16
    80000bd4:	e406                	sd	ra,8(sp)
    80000bd6:	e022                	sd	s0,0(sp)
    80000bd8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bda:	4601                	li	a2,0
    80000bdc:	00000097          	auipc	ra,0x0
    80000be0:	884080e7          	jalr	-1916(ra) # 80000460 <walk>
  if(pte == 0)
    80000be4:	c901                	beqz	a0,80000bf4 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000be6:	611c                	ld	a5,0(a0)
    80000be8:	9bbd                	andi	a5,a5,-17
    80000bea:	e11c                	sd	a5,0(a0)
}
    80000bec:	60a2                	ld	ra,8(sp)
    80000bee:	6402                	ld	s0,0(sp)
    80000bf0:	0141                	addi	sp,sp,16
    80000bf2:	8082                	ret
    panic("uvmclear");
    80000bf4:	00007517          	auipc	a0,0x7
    80000bf8:	58450513          	addi	a0,a0,1412 # 80008178 <etext+0x178>
    80000bfc:	00005097          	auipc	ra,0x5
    80000c00:	19c080e7          	jalr	412(ra) # 80005d98 <panic>

0000000080000c04 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c04:	c6bd                	beqz	a3,80000c72 <copyout+0x6e>
{
    80000c06:	715d                	addi	sp,sp,-80
    80000c08:	e486                	sd	ra,72(sp)
    80000c0a:	e0a2                	sd	s0,64(sp)
    80000c0c:	fc26                	sd	s1,56(sp)
    80000c0e:	f84a                	sd	s2,48(sp)
    80000c10:	f44e                	sd	s3,40(sp)
    80000c12:	f052                	sd	s4,32(sp)
    80000c14:	ec56                	sd	s5,24(sp)
    80000c16:	e85a                	sd	s6,16(sp)
    80000c18:	e45e                	sd	s7,8(sp)
    80000c1a:	e062                	sd	s8,0(sp)
    80000c1c:	0880                	addi	s0,sp,80
    80000c1e:	8b2a                	mv	s6,a0
    80000c20:	8c2e                	mv	s8,a1
    80000c22:	8a32                	mv	s4,a2
    80000c24:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c26:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c28:	6a85                	lui	s5,0x1
    80000c2a:	a015                	j	80000c4e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c2c:	9562                	add	a0,a0,s8
    80000c2e:	0004861b          	sext.w	a2,s1
    80000c32:	85d2                	mv	a1,s4
    80000c34:	41250533          	sub	a0,a0,s2
    80000c38:	fffff097          	auipc	ra,0xfffff
    80000c3c:	5a0080e7          	jalr	1440(ra) # 800001d8 <memmove>

    len -= n;
    80000c40:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c44:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c46:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c4a:	02098263          	beqz	s3,80000c6e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c4e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c52:	85ca                	mv	a1,s2
    80000c54:	855a                	mv	a0,s6
    80000c56:	00000097          	auipc	ra,0x0
    80000c5a:	8b0080e7          	jalr	-1872(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c5e:	cd01                	beqz	a0,80000c76 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c60:	418904b3          	sub	s1,s2,s8
    80000c64:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c66:	fc99f3e3          	bgeu	s3,s1,80000c2c <copyout+0x28>
    80000c6a:	84ce                	mv	s1,s3
    80000c6c:	b7c1                	j	80000c2c <copyout+0x28>
  }
  return 0;
    80000c6e:	4501                	li	a0,0
    80000c70:	a021                	j	80000c78 <copyout+0x74>
    80000c72:	4501                	li	a0,0
}
    80000c74:	8082                	ret
      return -1;
    80000c76:	557d                	li	a0,-1
}
    80000c78:	60a6                	ld	ra,72(sp)
    80000c7a:	6406                	ld	s0,64(sp)
    80000c7c:	74e2                	ld	s1,56(sp)
    80000c7e:	7942                	ld	s2,48(sp)
    80000c80:	79a2                	ld	s3,40(sp)
    80000c82:	7a02                	ld	s4,32(sp)
    80000c84:	6ae2                	ld	s5,24(sp)
    80000c86:	6b42                	ld	s6,16(sp)
    80000c88:	6ba2                	ld	s7,8(sp)
    80000c8a:	6c02                	ld	s8,0(sp)
    80000c8c:	6161                	addi	sp,sp,80
    80000c8e:	8082                	ret

0000000080000c90 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c90:	c6bd                	beqz	a3,80000cfe <copyin+0x6e>
{
    80000c92:	715d                	addi	sp,sp,-80
    80000c94:	e486                	sd	ra,72(sp)
    80000c96:	e0a2                	sd	s0,64(sp)
    80000c98:	fc26                	sd	s1,56(sp)
    80000c9a:	f84a                	sd	s2,48(sp)
    80000c9c:	f44e                	sd	s3,40(sp)
    80000c9e:	f052                	sd	s4,32(sp)
    80000ca0:	ec56                	sd	s5,24(sp)
    80000ca2:	e85a                	sd	s6,16(sp)
    80000ca4:	e45e                	sd	s7,8(sp)
    80000ca6:	e062                	sd	s8,0(sp)
    80000ca8:	0880                	addi	s0,sp,80
    80000caa:	8b2a                	mv	s6,a0
    80000cac:	8a2e                	mv	s4,a1
    80000cae:	8c32                	mv	s8,a2
    80000cb0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cb2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cb4:	6a85                	lui	s5,0x1
    80000cb6:	a015                	j	80000cda <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cb8:	9562                	add	a0,a0,s8
    80000cba:	0004861b          	sext.w	a2,s1
    80000cbe:	412505b3          	sub	a1,a0,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	fffff097          	auipc	ra,0xfffff
    80000cc8:	514080e7          	jalr	1300(ra) # 800001d8 <memmove>

    len -= n;
    80000ccc:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cd0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cd2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cd6:	02098263          	beqz	s3,80000cfa <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000cda:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cde:	85ca                	mv	a1,s2
    80000ce0:	855a                	mv	a0,s6
    80000ce2:	00000097          	auipc	ra,0x0
    80000ce6:	824080e7          	jalr	-2012(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000cea:	cd01                	beqz	a0,80000d02 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000cec:	418904b3          	sub	s1,s2,s8
    80000cf0:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cf2:	fc99f3e3          	bgeu	s3,s1,80000cb8 <copyin+0x28>
    80000cf6:	84ce                	mv	s1,s3
    80000cf8:	b7c1                	j	80000cb8 <copyin+0x28>
  }
  return 0;
    80000cfa:	4501                	li	a0,0
    80000cfc:	a021                	j	80000d04 <copyin+0x74>
    80000cfe:	4501                	li	a0,0
}
    80000d00:	8082                	ret
      return -1;
    80000d02:	557d                	li	a0,-1
}
    80000d04:	60a6                	ld	ra,72(sp)
    80000d06:	6406                	ld	s0,64(sp)
    80000d08:	74e2                	ld	s1,56(sp)
    80000d0a:	7942                	ld	s2,48(sp)
    80000d0c:	79a2                	ld	s3,40(sp)
    80000d0e:	7a02                	ld	s4,32(sp)
    80000d10:	6ae2                	ld	s5,24(sp)
    80000d12:	6b42                	ld	s6,16(sp)
    80000d14:	6ba2                	ld	s7,8(sp)
    80000d16:	6c02                	ld	s8,0(sp)
    80000d18:	6161                	addi	sp,sp,80
    80000d1a:	8082                	ret

0000000080000d1c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d1c:	c6c5                	beqz	a3,80000dc4 <copyinstr+0xa8>
{
    80000d1e:	715d                	addi	sp,sp,-80
    80000d20:	e486                	sd	ra,72(sp)
    80000d22:	e0a2                	sd	s0,64(sp)
    80000d24:	fc26                	sd	s1,56(sp)
    80000d26:	f84a                	sd	s2,48(sp)
    80000d28:	f44e                	sd	s3,40(sp)
    80000d2a:	f052                	sd	s4,32(sp)
    80000d2c:	ec56                	sd	s5,24(sp)
    80000d2e:	e85a                	sd	s6,16(sp)
    80000d30:	e45e                	sd	s7,8(sp)
    80000d32:	0880                	addi	s0,sp,80
    80000d34:	8a2a                	mv	s4,a0
    80000d36:	8b2e                	mv	s6,a1
    80000d38:	8bb2                	mv	s7,a2
    80000d3a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d3c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d3e:	6985                	lui	s3,0x1
    80000d40:	a035                	j	80000d6c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d42:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d46:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d48:	0017b793          	seqz	a5,a5
    80000d4c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d50:	60a6                	ld	ra,72(sp)
    80000d52:	6406                	ld	s0,64(sp)
    80000d54:	74e2                	ld	s1,56(sp)
    80000d56:	7942                	ld	s2,48(sp)
    80000d58:	79a2                	ld	s3,40(sp)
    80000d5a:	7a02                	ld	s4,32(sp)
    80000d5c:	6ae2                	ld	s5,24(sp)
    80000d5e:	6b42                	ld	s6,16(sp)
    80000d60:	6ba2                	ld	s7,8(sp)
    80000d62:	6161                	addi	sp,sp,80
    80000d64:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d66:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d6a:	c8a9                	beqz	s1,80000dbc <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d6c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d70:	85ca                	mv	a1,s2
    80000d72:	8552                	mv	a0,s4
    80000d74:	fffff097          	auipc	ra,0xfffff
    80000d78:	792080e7          	jalr	1938(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000d7c:	c131                	beqz	a0,80000dc0 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d7e:	41790833          	sub	a6,s2,s7
    80000d82:	984e                	add	a6,a6,s3
    if(n > max)
    80000d84:	0104f363          	bgeu	s1,a6,80000d8a <copyinstr+0x6e>
    80000d88:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d8a:	955e                	add	a0,a0,s7
    80000d8c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d90:	fc080be3          	beqz	a6,80000d66 <copyinstr+0x4a>
    80000d94:	985a                	add	a6,a6,s6
    80000d96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d98:	41650633          	sub	a2,a0,s6
    80000d9c:	14fd                	addi	s1,s1,-1
    80000d9e:	9b26                	add	s6,s6,s1
    80000da0:	00f60733          	add	a4,a2,a5
    80000da4:	00074703          	lbu	a4,0(a4)
    80000da8:	df49                	beqz	a4,80000d42 <copyinstr+0x26>
        *dst = *p;
    80000daa:	00e78023          	sb	a4,0(a5)
      --max;
    80000dae:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000db2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000db4:	ff0796e3          	bne	a5,a6,80000da0 <copyinstr+0x84>
      dst++;
    80000db8:	8b42                	mv	s6,a6
    80000dba:	b775                	j	80000d66 <copyinstr+0x4a>
    80000dbc:	4781                	li	a5,0
    80000dbe:	b769                	j	80000d48 <copyinstr+0x2c>
      return -1;
    80000dc0:	557d                	li	a0,-1
    80000dc2:	b779                	j	80000d50 <copyinstr+0x34>
  int got_null = 0;
    80000dc4:	4781                	li	a5,0
  if(got_null){
    80000dc6:	0017b793          	seqz	a5,a5
    80000dca:	40f00533          	neg	a0,a5
}
    80000dce:	8082                	ret

0000000080000dd0 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dd0:	7139                	addi	sp,sp,-64
    80000dd2:	fc06                	sd	ra,56(sp)
    80000dd4:	f822                	sd	s0,48(sp)
    80000dd6:	f426                	sd	s1,40(sp)
    80000dd8:	f04a                	sd	s2,32(sp)
    80000dda:	ec4e                	sd	s3,24(sp)
    80000ddc:	e852                	sd	s4,16(sp)
    80000dde:	e456                	sd	s5,8(sp)
    80000de0:	e05a                	sd	s6,0(sp)
    80000de2:	0080                	addi	s0,sp,64
    80000de4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de6:	00008497          	auipc	s1,0x8
    80000dea:	6aa48493          	addi	s1,s1,1706 # 80009490 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dee:	8b26                	mv	s6,s1
    80000df0:	00007a97          	auipc	s5,0x7
    80000df4:	210a8a93          	addi	s5,s5,528 # 80008000 <etext>
    80000df8:	01000937          	lui	s2,0x1000
    80000dfc:	197d                	addi	s2,s2,-1
    80000dfe:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	0000ea17          	auipc	s4,0xe
    80000e04:	290a0a13          	addi	s4,s4,656 # 8000f090 <tickslock>
    char *pa = kalloc();
    80000e08:	fffff097          	auipc	ra,0xfffff
    80000e0c:	310080e7          	jalr	784(ra) # 80000118 <kalloc>
    80000e10:	862a                	mv	a2,a0
    if(pa == 0)
    80000e12:	c129                	beqz	a0,80000e54 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e14:	416485b3          	sub	a1,s1,s6
    80000e18:	8591                	srai	a1,a1,0x4
    80000e1a:	000ab783          	ld	a5,0(s5)
    80000e1e:	02f585b3          	mul	a1,a1,a5
    80000e22:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e26:	4719                	li	a4,6
    80000e28:	6685                	lui	a3,0x1
    80000e2a:	40b905b3          	sub	a1,s2,a1
    80000e2e:	854e                	mv	a0,s3
    80000e30:	fffff097          	auipc	ra,0xfffff
    80000e34:	7b8080e7          	jalr	1976(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e38:	17048493          	addi	s1,s1,368
    80000e3c:	fd4496e3          	bne	s1,s4,80000e08 <proc_mapstacks+0x38>
  }
}
    80000e40:	70e2                	ld	ra,56(sp)
    80000e42:	7442                	ld	s0,48(sp)
    80000e44:	74a2                	ld	s1,40(sp)
    80000e46:	7902                	ld	s2,32(sp)
    80000e48:	69e2                	ld	s3,24(sp)
    80000e4a:	6a42                	ld	s4,16(sp)
    80000e4c:	6aa2                	ld	s5,8(sp)
    80000e4e:	6b02                	ld	s6,0(sp)
    80000e50:	6121                	addi	sp,sp,64
    80000e52:	8082                	ret
      panic("kalloc");
    80000e54:	00007517          	auipc	a0,0x7
    80000e58:	33450513          	addi	a0,a0,820 # 80008188 <etext+0x188>
    80000e5c:	00005097          	auipc	ra,0x5
    80000e60:	f3c080e7          	jalr	-196(ra) # 80005d98 <panic>

0000000080000e64 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e64:	7139                	addi	sp,sp,-64
    80000e66:	fc06                	sd	ra,56(sp)
    80000e68:	f822                	sd	s0,48(sp)
    80000e6a:	f426                	sd	s1,40(sp)
    80000e6c:	f04a                	sd	s2,32(sp)
    80000e6e:	ec4e                	sd	s3,24(sp)
    80000e70:	e852                	sd	s4,16(sp)
    80000e72:	e456                	sd	s5,8(sp)
    80000e74:	e05a                	sd	s6,0(sp)
    80000e76:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e78:	00007597          	auipc	a1,0x7
    80000e7c:	31858593          	addi	a1,a1,792 # 80008190 <etext+0x190>
    80000e80:	00008517          	auipc	a0,0x8
    80000e84:	1e050513          	addi	a0,a0,480 # 80009060 <pid_lock>
    80000e88:	00005097          	auipc	ra,0x5
    80000e8c:	3ca080e7          	jalr	970(ra) # 80006252 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e90:	00007597          	auipc	a1,0x7
    80000e94:	30858593          	addi	a1,a1,776 # 80008198 <etext+0x198>
    80000e98:	00008517          	auipc	a0,0x8
    80000e9c:	1e050513          	addi	a0,a0,480 # 80009078 <wait_lock>
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	3b2080e7          	jalr	946(ra) # 80006252 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea8:	00008497          	auipc	s1,0x8
    80000eac:	5e848493          	addi	s1,s1,1512 # 80009490 <proc>
      initlock(&p->lock, "proc");
    80000eb0:	00007b17          	auipc	s6,0x7
    80000eb4:	2f8b0b13          	addi	s6,s6,760 # 800081a8 <etext+0x1a8>
      p->kstack = KSTACK((int) (p - proc));
    80000eb8:	8aa6                	mv	s5,s1
    80000eba:	00007a17          	auipc	s4,0x7
    80000ebe:	146a0a13          	addi	s4,s4,326 # 80008000 <etext>
    80000ec2:	01000937          	lui	s2,0x1000
    80000ec6:	197d                	addi	s2,s2,-1
    80000ec8:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eca:	0000e997          	auipc	s3,0xe
    80000ece:	1c698993          	addi	s3,s3,454 # 8000f090 <tickslock>
      initlock(&p->lock, "proc");
    80000ed2:	85da                	mv	a1,s6
    80000ed4:	8526                	mv	a0,s1
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	37c080e7          	jalr	892(ra) # 80006252 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ede:	415487b3          	sub	a5,s1,s5
    80000ee2:	8791                	srai	a5,a5,0x4
    80000ee4:	000a3703          	ld	a4,0(s4)
    80000ee8:	02e787b3          	mul	a5,a5,a4
    80000eec:	00d7979b          	slliw	a5,a5,0xd
    80000ef0:	40f907b3          	sub	a5,s2,a5
    80000ef4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef6:	17048493          	addi	s1,s1,368
    80000efa:	fd349ce3          	bne	s1,s3,80000ed2 <procinit+0x6e>
  }
}
    80000efe:	70e2                	ld	ra,56(sp)
    80000f00:	7442                	ld	s0,48(sp)
    80000f02:	74a2                	ld	s1,40(sp)
    80000f04:	7902                	ld	s2,32(sp)
    80000f06:	69e2                	ld	s3,24(sp)
    80000f08:	6a42                	ld	s4,16(sp)
    80000f0a:	6aa2                	ld	s5,8(sp)
    80000f0c:	6b02                	ld	s6,0(sp)
    80000f0e:	6121                	addi	sp,sp,64
    80000f10:	8082                	ret

0000000080000f12 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f18:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f1a:	2501                	sext.w	a0,a0
    80000f1c:	6422                	ld	s0,8(sp)
    80000f1e:	0141                	addi	sp,sp,16
    80000f20:	8082                	ret

0000000080000f22 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
    80000f28:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f2a:	2781                	sext.w	a5,a5
    80000f2c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f2e:	00008517          	auipc	a0,0x8
    80000f32:	16250513          	addi	a0,a0,354 # 80009090 <cpus>
    80000f36:	953e                	add	a0,a0,a5
    80000f38:	6422                	ld	s0,8(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f3e:	1101                	addi	sp,sp,-32
    80000f40:	ec06                	sd	ra,24(sp)
    80000f42:	e822                	sd	s0,16(sp)
    80000f44:	e426                	sd	s1,8(sp)
    80000f46:	1000                	addi	s0,sp,32
  push_off();
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	34e080e7          	jalr	846(ra) # 80006296 <push_off>
    80000f50:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	slli	a5,a5,0x7
    80000f56:	00008717          	auipc	a4,0x8
    80000f5a:	10a70713          	addi	a4,a4,266 # 80009060 <pid_lock>
    80000f5e:	97ba                	add	a5,a5,a4
    80000f60:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	3d4080e7          	jalr	980(ra) # 80006336 <pop_off>
  return p;
}
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	60e2                	ld	ra,24(sp)
    80000f6e:	6442                	ld	s0,16(sp)
    80000f70:	64a2                	ld	s1,8(sp)
    80000f72:	6105                	addi	sp,sp,32
    80000f74:	8082                	ret

0000000080000f76 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f76:	1141                	addi	sp,sp,-16
    80000f78:	e406                	sd	ra,8(sp)
    80000f7a:	e022                	sd	s0,0(sp)
    80000f7c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	fc0080e7          	jalr	-64(ra) # 80000f3e <myproc>
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	410080e7          	jalr	1040(ra) # 80006396 <release>

  if (first) {
    80000f8e:	00008797          	auipc	a5,0x8
    80000f92:	9327a783          	lw	a5,-1742(a5) # 800088c0 <first.1681>
    80000f96:	eb89                	bnez	a5,80000fa8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f98:	00001097          	auipc	ra,0x1
    80000f9c:	c90080e7          	jalr	-880(ra) # 80001c28 <usertrapret>
}
    80000fa0:	60a2                	ld	ra,8(sp)
    80000fa2:	6402                	ld	s0,0(sp)
    80000fa4:	0141                	addi	sp,sp,16
    80000fa6:	8082                	ret
    first = 0;
    80000fa8:	00008797          	auipc	a5,0x8
    80000fac:	9007ac23          	sw	zero,-1768(a5) # 800088c0 <first.1681>
    fsinit(ROOTDEV);
    80000fb0:	4505                	li	a0,1
    80000fb2:	00002097          	auipc	ra,0x2
    80000fb6:	aa8080e7          	jalr	-1368(ra) # 80002a5a <fsinit>
    80000fba:	bff9                	j	80000f98 <forkret+0x22>

0000000080000fbc <allocpid>:
allocpid() {
    80000fbc:	1101                	addi	sp,sp,-32
    80000fbe:	ec06                	sd	ra,24(sp)
    80000fc0:	e822                	sd	s0,16(sp)
    80000fc2:	e426                	sd	s1,8(sp)
    80000fc4:	e04a                	sd	s2,0(sp)
    80000fc6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fc8:	00008917          	auipc	s2,0x8
    80000fcc:	09890913          	addi	s2,s2,152 # 80009060 <pid_lock>
    80000fd0:	854a                	mv	a0,s2
    80000fd2:	00005097          	auipc	ra,0x5
    80000fd6:	310080e7          	jalr	784(ra) # 800062e2 <acquire>
  pid = nextpid;
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	8ea78793          	addi	a5,a5,-1814 # 800088c4 <nextpid>
    80000fe2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fe4:	0014871b          	addiw	a4,s1,1
    80000fe8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fea:	854a                	mv	a0,s2
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	3aa080e7          	jalr	938(ra) # 80006396 <release>
}
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	60e2                	ld	ra,24(sp)
    80000ff8:	6442                	ld	s0,16(sp)
    80000ffa:	64a2                	ld	s1,8(sp)
    80000ffc:	6902                	ld	s2,0(sp)
    80000ffe:	6105                	addi	sp,sp,32
    80001000:	8082                	ret

0000000080001002 <proc_pagetable>:
{
    80001002:	1101                	addi	sp,sp,-32
    80001004:	ec06                	sd	ra,24(sp)
    80001006:	e822                	sd	s0,16(sp)
    80001008:	e426                	sd	s1,8(sp)
    8000100a:	e04a                	sd	s2,0(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	7c2080e7          	jalr	1986(ra) # 800007d2 <uvmcreate>
    80001018:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000101a:	cd39                	beqz	a0,80001078 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000101c:	4729                	li	a4,10
    8000101e:	00006697          	auipc	a3,0x6
    80001022:	fe268693          	addi	a3,a3,-30 # 80007000 <_trampoline>
    80001026:	6605                	lui	a2,0x1
    80001028:	040005b7          	lui	a1,0x4000
    8000102c:	15fd                	addi	a1,a1,-1
    8000102e:	05b2                	slli	a1,a1,0xc
    80001030:	fffff097          	auipc	ra,0xfffff
    80001034:	518080e7          	jalr	1304(ra) # 80000548 <mappages>
    80001038:	04054763          	bltz	a0,80001086 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000103c:	4719                	li	a4,6
    8000103e:	05893683          	ld	a3,88(s2)
    80001042:	6605                	lui	a2,0x1
    80001044:	020005b7          	lui	a1,0x2000
    80001048:	15fd                	addi	a1,a1,-1
    8000104a:	05b6                	slli	a1,a1,0xd
    8000104c:	8526                	mv	a0,s1
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	4fa080e7          	jalr	1274(ra) # 80000548 <mappages>
    80001056:	04054063          	bltz	a0,80001096 <proc_pagetable+0x94>
      if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usyscallpage), PTE_R | PTE_U) < 0) {
    8000105a:	4749                	li	a4,18
    8000105c:	16893683          	ld	a3,360(s2)
    80001060:	6605                	lui	a2,0x1
    80001062:	040005b7          	lui	a1,0x4000
    80001066:	15f5                	addi	a1,a1,-3
    80001068:	05b2                	slli	a1,a1,0xc
    8000106a:	8526                	mv	a0,s1
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	4dc080e7          	jalr	1244(ra) # 80000548 <mappages>
    80001074:	04054463          	bltz	a0,800010bc <proc_pagetable+0xba>
}
    80001078:	8526                	mv	a0,s1
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6902                	ld	s2,0(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret
    uvmfree(pagetable, 0);
    80001086:	4581                	li	a1,0
    80001088:	8526                	mv	a0,s1
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	a3e080e7          	jalr	-1474(ra) # 80000ac8 <uvmfree>
    return 0;
    80001092:	4481                	li	s1,0
    80001094:	b7d5                	j	80001078 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001096:	4681                	li	a3,0
    80001098:	4605                	li	a2,1
    8000109a:	040005b7          	lui	a1,0x4000
    8000109e:	15fd                	addi	a1,a1,-1
    800010a0:	05b2                	slli	a1,a1,0xc
    800010a2:	8526                	mv	a0,s1
    800010a4:	fffff097          	auipc	ra,0xfffff
    800010a8:	66a080e7          	jalr	1642(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    800010ac:	4581                	li	a1,0
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	a18080e7          	jalr	-1512(ra) # 80000ac8 <uvmfree>
    return 0;
    800010b8:	4481                	li	s1,0
    800010ba:	bf7d                	j	80001078 <proc_pagetable+0x76>
    uvmfree(pagetable, 0);
    800010bc:	4581                	li	a1,0
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	a08080e7          	jalr	-1528(ra) # 80000ac8 <uvmfree>
    return 0;
    800010c8:	4481                	li	s1,0
    800010ca:	b77d                	j	80001078 <proc_pagetable+0x76>

00000000800010cc <proc_freepagetable>:
{
    800010cc:	7179                	addi	sp,sp,-48
    800010ce:	f406                	sd	ra,40(sp)
    800010d0:	f022                	sd	s0,32(sp)
    800010d2:	ec26                	sd	s1,24(sp)
    800010d4:	e84a                	sd	s2,16(sp)
    800010d6:	e44e                	sd	s3,8(sp)
    800010d8:	1800                	addi	s0,sp,48
    800010da:	84aa                	mv	s1,a0
    800010dc:	89ae                	mv	s3,a1
  uvmunmap(pagetable, USYSCALL, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	04000937          	lui	s2,0x4000
    800010e6:	ffd90593          	addi	a1,s2,-3 # 3fffffd <_entry-0x7c000003>
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	622080e7          	jalr	1570(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f4:	4681                	li	a3,0
    800010f6:	4605                	li	a2,1
    800010f8:	197d                	addi	s2,s2,-1
    800010fa:	00c91593          	slli	a1,s2,0xc
    800010fe:	8526                	mv	a0,s1
    80001100:	fffff097          	auipc	ra,0xfffff
    80001104:	60e080e7          	jalr	1550(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001108:	4681                	li	a3,0
    8000110a:	4605                	li	a2,1
    8000110c:	020005b7          	lui	a1,0x2000
    80001110:	15fd                	addi	a1,a1,-1
    80001112:	05b6                	slli	a1,a1,0xd
    80001114:	8526                	mv	a0,s1
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	5f8080e7          	jalr	1528(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    8000111e:	85ce                	mv	a1,s3
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	9a6080e7          	jalr	-1626(ra) # 80000ac8 <uvmfree>
}
    8000112a:	70a2                	ld	ra,40(sp)
    8000112c:	7402                	ld	s0,32(sp)
    8000112e:	64e2                	ld	s1,24(sp)
    80001130:	6942                	ld	s2,16(sp)
    80001132:	69a2                	ld	s3,8(sp)
    80001134:	6145                	addi	sp,sp,48
    80001136:	8082                	ret

0000000080001138 <freeproc>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	1000                	addi	s0,sp,32
    80001142:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001144:	6d28                	ld	a0,88(a0)
    80001146:	c509                	beqz	a0,80001150 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	ed4080e7          	jalr	-300(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001150:	0404bc23          	sd	zero,88(s1)
  if(p->usyscallpage)
    80001154:	1684b503          	ld	a0,360(s1)
    80001158:	c509                	beqz	a0,80001162 <freeproc+0x2a>
     kfree((void*)p->usyscallpage);
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	ec2080e7          	jalr	-318(ra) # 8000001c <kfree>
  p->usyscallpage = 0;
    80001162:	1604b423          	sd	zero,360(s1)
  if(p->pagetable)
    80001166:	68a8                	ld	a0,80(s1)
    80001168:	c511                	beqz	a0,80001174 <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    8000116a:	64ac                	ld	a1,72(s1)
    8000116c:	00000097          	auipc	ra,0x0
    80001170:	f60080e7          	jalr	-160(ra) # 800010cc <proc_freepagetable>
  p->pagetable = 0;
    80001174:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001178:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000117c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001180:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001184:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001188:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000118c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001190:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001194:	0004ac23          	sw	zero,24(s1)
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <allocproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	e04a                	sd	s2,0(sp)
    800011ac:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011ae:	00008497          	auipc	s1,0x8
    800011b2:	2e248493          	addi	s1,s1,738 # 80009490 <proc>
    800011b6:	0000e917          	auipc	s2,0xe
    800011ba:	eda90913          	addi	s2,s2,-294 # 8000f090 <tickslock>
    acquire(&p->lock);
    800011be:	8526                	mv	a0,s1
    800011c0:	00005097          	auipc	ra,0x5
    800011c4:	122080e7          	jalr	290(ra) # 800062e2 <acquire>
    if(p->state == UNUSED) {
    800011c8:	4c9c                	lw	a5,24(s1)
    800011ca:	cf81                	beqz	a5,800011e2 <allocproc+0x40>
      release(&p->lock);
    800011cc:	8526                	mv	a0,s1
    800011ce:	00005097          	auipc	ra,0x5
    800011d2:	1c8080e7          	jalr	456(ra) # 80006396 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d6:	17048493          	addi	s1,s1,368
    800011da:	ff2492e3          	bne	s1,s2,800011be <allocproc+0x1c>
  return 0;
    800011de:	4481                	li	s1,0
    800011e0:	a09d                	j	80001246 <allocproc+0xa4>
  p->pid = allocpid();
    800011e2:	00000097          	auipc	ra,0x0
    800011e6:	dda080e7          	jalr	-550(ra) # 80000fbc <allocpid>
    800011ea:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011ec:	4785                	li	a5,1
    800011ee:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	f28080e7          	jalr	-216(ra) # 80000118 <kalloc>
    800011f8:	892a                	mv	s2,a0
    800011fa:	eca8                	sd	a0,88(s1)
    800011fc:	cd21                	beqz	a0,80001254 <allocproc+0xb2>
    if((p->usyscallpage = (struct usyscall *)kalloc()) == 0){
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	f1a080e7          	jalr	-230(ra) # 80000118 <kalloc>
    80001206:	892a                	mv	s2,a0
    80001208:	16a4b423          	sd	a0,360(s1)
    8000120c:	c125                	beqz	a0,8000126c <allocproc+0xca>
    p->usyscallpage->pid = p->pid;
    8000120e:	589c                	lw	a5,48(s1)
    80001210:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001212:	8526                	mv	a0,s1
    80001214:	00000097          	auipc	ra,0x0
    80001218:	dee080e7          	jalr	-530(ra) # 80001002 <proc_pagetable>
    8000121c:	892a                	mv	s2,a0
    8000121e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001220:	c135                	beqz	a0,80001284 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    80001222:	07000613          	li	a2,112
    80001226:	4581                	li	a1,0
    80001228:	06048513          	addi	a0,s1,96
    8000122c:	fffff097          	auipc	ra,0xfffff
    80001230:	f4c080e7          	jalr	-180(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001234:	00000797          	auipc	a5,0x0
    80001238:	d4278793          	addi	a5,a5,-702 # 80000f76 <forkret>
    8000123c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000123e:	60bc                	ld	a5,64(s1)
    80001240:	6705                	lui	a4,0x1
    80001242:	97ba                	add	a5,a5,a4
    80001244:	f4bc                	sd	a5,104(s1)
}
    80001246:	8526                	mv	a0,s1
    80001248:	60e2                	ld	ra,24(sp)
    8000124a:	6442                	ld	s0,16(sp)
    8000124c:	64a2                	ld	s1,8(sp)
    8000124e:	6902                	ld	s2,0(sp)
    80001250:	6105                	addi	sp,sp,32
    80001252:	8082                	ret
    freeproc(p);
    80001254:	8526                	mv	a0,s1
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	ee2080e7          	jalr	-286(ra) # 80001138 <freeproc>
    release(&p->lock);
    8000125e:	8526                	mv	a0,s1
    80001260:	00005097          	auipc	ra,0x5
    80001264:	136080e7          	jalr	310(ra) # 80006396 <release>
    return 0;
    80001268:	84ca                	mv	s1,s2
    8000126a:	bff1                	j	80001246 <allocproc+0xa4>
    freeproc(p);
    8000126c:	8526                	mv	a0,s1
    8000126e:	00000097          	auipc	ra,0x0
    80001272:	eca080e7          	jalr	-310(ra) # 80001138 <freeproc>
    release(&p->lock);
    80001276:	8526                	mv	a0,s1
    80001278:	00005097          	auipc	ra,0x5
    8000127c:	11e080e7          	jalr	286(ra) # 80006396 <release>
    return 0;
    80001280:	84ca                	mv	s1,s2
    80001282:	b7d1                	j	80001246 <allocproc+0xa4>
    freeproc(p);
    80001284:	8526                	mv	a0,s1
    80001286:	00000097          	auipc	ra,0x0
    8000128a:	eb2080e7          	jalr	-334(ra) # 80001138 <freeproc>
    release(&p->lock);
    8000128e:	8526                	mv	a0,s1
    80001290:	00005097          	auipc	ra,0x5
    80001294:	106080e7          	jalr	262(ra) # 80006396 <release>
    return 0;
    80001298:	84ca                	mv	s1,s2
    8000129a:	b775                	j	80001246 <allocproc+0xa4>

000000008000129c <userinit>:
{
    8000129c:	1101                	addi	sp,sp,-32
    8000129e:	ec06                	sd	ra,24(sp)
    800012a0:	e822                	sd	s0,16(sp)
    800012a2:	e426                	sd	s1,8(sp)
    800012a4:	1000                	addi	s0,sp,32
  p = allocproc();
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	efc080e7          	jalr	-260(ra) # 800011a2 <allocproc>
    800012ae:	84aa                	mv	s1,a0
  initproc = p;
    800012b0:	00008797          	auipc	a5,0x8
    800012b4:	d6a7b423          	sd	a0,-664(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012b8:	03400613          	li	a2,52
    800012bc:	00007597          	auipc	a1,0x7
    800012c0:	61458593          	addi	a1,a1,1556 # 800088d0 <initcode>
    800012c4:	6928                	ld	a0,80(a0)
    800012c6:	fffff097          	auipc	ra,0xfffff
    800012ca:	53a080e7          	jalr	1338(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    800012ce:	6785                	lui	a5,0x1
    800012d0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012d2:	6cb8                	ld	a4,88(s1)
    800012d4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012d8:	6cb8                	ld	a4,88(s1)
    800012da:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012dc:	4641                	li	a2,16
    800012de:	00007597          	auipc	a1,0x7
    800012e2:	ed258593          	addi	a1,a1,-302 # 800081b0 <etext+0x1b0>
    800012e6:	15848513          	addi	a0,s1,344
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	fe0080e7          	jalr	-32(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800012f2:	00007517          	auipc	a0,0x7
    800012f6:	ece50513          	addi	a0,a0,-306 # 800081c0 <etext+0x1c0>
    800012fa:	00002097          	auipc	ra,0x2
    800012fe:	18e080e7          	jalr	398(ra) # 80003488 <namei>
    80001302:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001306:	478d                	li	a5,3
    80001308:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	08a080e7          	jalr	138(ra) # 80006396 <release>
}
    80001314:	60e2                	ld	ra,24(sp)
    80001316:	6442                	ld	s0,16(sp)
    80001318:	64a2                	ld	s1,8(sp)
    8000131a:	6105                	addi	sp,sp,32
    8000131c:	8082                	ret

000000008000131e <growproc>:
{
    8000131e:	1101                	addi	sp,sp,-32
    80001320:	ec06                	sd	ra,24(sp)
    80001322:	e822                	sd	s0,16(sp)
    80001324:	e426                	sd	s1,8(sp)
    80001326:	e04a                	sd	s2,0(sp)
    80001328:	1000                	addi	s0,sp,32
    8000132a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	c12080e7          	jalr	-1006(ra) # 80000f3e <myproc>
    80001334:	892a                	mv	s2,a0
  sz = p->sz;
    80001336:	652c                	ld	a1,72(a0)
    80001338:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000133c:	00904f63          	bgtz	s1,8000135a <growproc+0x3c>
  } else if(n < 0){
    80001340:	0204cc63          	bltz	s1,80001378 <growproc+0x5a>
  p->sz = sz;
    80001344:	1602                	slli	a2,a2,0x20
    80001346:	9201                	srli	a2,a2,0x20
    80001348:	04c93423          	sd	a2,72(s2)
  return 0;
    8000134c:	4501                	li	a0,0
}
    8000134e:	60e2                	ld	ra,24(sp)
    80001350:	6442                	ld	s0,16(sp)
    80001352:	64a2                	ld	s1,8(sp)
    80001354:	6902                	ld	s2,0(sp)
    80001356:	6105                	addi	sp,sp,32
    80001358:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000135a:	9e25                	addw	a2,a2,s1
    8000135c:	1602                	slli	a2,a2,0x20
    8000135e:	9201                	srli	a2,a2,0x20
    80001360:	1582                	slli	a1,a1,0x20
    80001362:	9181                	srli	a1,a1,0x20
    80001364:	6928                	ld	a0,80(a0)
    80001366:	fffff097          	auipc	ra,0xfffff
    8000136a:	554080e7          	jalr	1364(ra) # 800008ba <uvmalloc>
    8000136e:	0005061b          	sext.w	a2,a0
    80001372:	fa69                	bnez	a2,80001344 <growproc+0x26>
      return -1;
    80001374:	557d                	li	a0,-1
    80001376:	bfe1                	j	8000134e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001378:	9e25                	addw	a2,a2,s1
    8000137a:	1602                	slli	a2,a2,0x20
    8000137c:	9201                	srli	a2,a2,0x20
    8000137e:	1582                	slli	a1,a1,0x20
    80001380:	9181                	srli	a1,a1,0x20
    80001382:	6928                	ld	a0,80(a0)
    80001384:	fffff097          	auipc	ra,0xfffff
    80001388:	4ee080e7          	jalr	1262(ra) # 80000872 <uvmdealloc>
    8000138c:	0005061b          	sext.w	a2,a0
    80001390:	bf55                	j	80001344 <growproc+0x26>

0000000080001392 <fork>:
{
    80001392:	7179                	addi	sp,sp,-48
    80001394:	f406                	sd	ra,40(sp)
    80001396:	f022                	sd	s0,32(sp)
    80001398:	ec26                	sd	s1,24(sp)
    8000139a:	e84a                	sd	s2,16(sp)
    8000139c:	e44e                	sd	s3,8(sp)
    8000139e:	e052                	sd	s4,0(sp)
    800013a0:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013a2:	00000097          	auipc	ra,0x0
    800013a6:	b9c080e7          	jalr	-1124(ra) # 80000f3e <myproc>
    800013aa:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	df6080e7          	jalr	-522(ra) # 800011a2 <allocproc>
    800013b4:	10050b63          	beqz	a0,800014ca <fork+0x138>
    800013b8:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013ba:	04893603          	ld	a2,72(s2)
    800013be:	692c                	ld	a1,80(a0)
    800013c0:	05093503          	ld	a0,80(s2)
    800013c4:	fffff097          	auipc	ra,0xfffff
    800013c8:	73c080e7          	jalr	1852(ra) # 80000b00 <uvmcopy>
    800013cc:	04054663          	bltz	a0,80001418 <fork+0x86>
  np->sz = p->sz;
    800013d0:	04893783          	ld	a5,72(s2)
    800013d4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013d8:	05893683          	ld	a3,88(s2)
    800013dc:	87b6                	mv	a5,a3
    800013de:	0589b703          	ld	a4,88(s3)
    800013e2:	12068693          	addi	a3,a3,288
    800013e6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013ea:	6788                	ld	a0,8(a5)
    800013ec:	6b8c                	ld	a1,16(a5)
    800013ee:	6f90                	ld	a2,24(a5)
    800013f0:	01073023          	sd	a6,0(a4)
    800013f4:	e708                	sd	a0,8(a4)
    800013f6:	eb0c                	sd	a1,16(a4)
    800013f8:	ef10                	sd	a2,24(a4)
    800013fa:	02078793          	addi	a5,a5,32
    800013fe:	02070713          	addi	a4,a4,32
    80001402:	fed792e3          	bne	a5,a3,800013e6 <fork+0x54>
  np->trapframe->a0 = 0;
    80001406:	0589b783          	ld	a5,88(s3)
    8000140a:	0607b823          	sd	zero,112(a5)
    8000140e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001412:	15000a13          	li	s4,336
    80001416:	a03d                	j	80001444 <fork+0xb2>
    freeproc(np);
    80001418:	854e                	mv	a0,s3
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	d1e080e7          	jalr	-738(ra) # 80001138 <freeproc>
    release(&np->lock);
    80001422:	854e                	mv	a0,s3
    80001424:	00005097          	auipc	ra,0x5
    80001428:	f72080e7          	jalr	-142(ra) # 80006396 <release>
    return -1;
    8000142c:	5a7d                	li	s4,-1
    8000142e:	a069                	j	800014b8 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001430:	00002097          	auipc	ra,0x2
    80001434:	6ee080e7          	jalr	1774(ra) # 80003b1e <filedup>
    80001438:	009987b3          	add	a5,s3,s1
    8000143c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000143e:	04a1                	addi	s1,s1,8
    80001440:	01448763          	beq	s1,s4,8000144e <fork+0xbc>
    if(p->ofile[i])
    80001444:	009907b3          	add	a5,s2,s1
    80001448:	6388                	ld	a0,0(a5)
    8000144a:	f17d                	bnez	a0,80001430 <fork+0x9e>
    8000144c:	bfcd                	j	8000143e <fork+0xac>
  np->cwd = idup(p->cwd);
    8000144e:	15093503          	ld	a0,336(s2)
    80001452:	00002097          	auipc	ra,0x2
    80001456:	842080e7          	jalr	-1982(ra) # 80002c94 <idup>
    8000145a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000145e:	4641                	li	a2,16
    80001460:	15890593          	addi	a1,s2,344
    80001464:	15898513          	addi	a0,s3,344
    80001468:	fffff097          	auipc	ra,0xfffff
    8000146c:	e62080e7          	jalr	-414(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001470:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001474:	854e                	mv	a0,s3
    80001476:	00005097          	auipc	ra,0x5
    8000147a:	f20080e7          	jalr	-224(ra) # 80006396 <release>
  acquire(&wait_lock);
    8000147e:	00008497          	auipc	s1,0x8
    80001482:	bfa48493          	addi	s1,s1,-1030 # 80009078 <wait_lock>
    80001486:	8526                	mv	a0,s1
    80001488:	00005097          	auipc	ra,0x5
    8000148c:	e5a080e7          	jalr	-422(ra) # 800062e2 <acquire>
  np->parent = p;
    80001490:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001494:	8526                	mv	a0,s1
    80001496:	00005097          	auipc	ra,0x5
    8000149a:	f00080e7          	jalr	-256(ra) # 80006396 <release>
  acquire(&np->lock);
    8000149e:	854e                	mv	a0,s3
    800014a0:	00005097          	auipc	ra,0x5
    800014a4:	e42080e7          	jalr	-446(ra) # 800062e2 <acquire>
  np->state = RUNNABLE;
    800014a8:	478d                	li	a5,3
    800014aa:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014ae:	854e                	mv	a0,s3
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	ee6080e7          	jalr	-282(ra) # 80006396 <release>
}
    800014b8:	8552                	mv	a0,s4
    800014ba:	70a2                	ld	ra,40(sp)
    800014bc:	7402                	ld	s0,32(sp)
    800014be:	64e2                	ld	s1,24(sp)
    800014c0:	6942                	ld	s2,16(sp)
    800014c2:	69a2                	ld	s3,8(sp)
    800014c4:	6a02                	ld	s4,0(sp)
    800014c6:	6145                	addi	sp,sp,48
    800014c8:	8082                	ret
    return -1;
    800014ca:	5a7d                	li	s4,-1
    800014cc:	b7f5                	j	800014b8 <fork+0x126>

00000000800014ce <scheduler>:
{
    800014ce:	7139                	addi	sp,sp,-64
    800014d0:	fc06                	sd	ra,56(sp)
    800014d2:	f822                	sd	s0,48(sp)
    800014d4:	f426                	sd	s1,40(sp)
    800014d6:	f04a                	sd	s2,32(sp)
    800014d8:	ec4e                	sd	s3,24(sp)
    800014da:	e852                	sd	s4,16(sp)
    800014dc:	e456                	sd	s5,8(sp)
    800014de:	e05a                	sd	s6,0(sp)
    800014e0:	0080                	addi	s0,sp,64
    800014e2:	8792                	mv	a5,tp
  int id = r_tp();
    800014e4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014e6:	00779a93          	slli	s5,a5,0x7
    800014ea:	00008717          	auipc	a4,0x8
    800014ee:	b7670713          	addi	a4,a4,-1162 # 80009060 <pid_lock>
    800014f2:	9756                	add	a4,a4,s5
    800014f4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014f8:	00008717          	auipc	a4,0x8
    800014fc:	ba070713          	addi	a4,a4,-1120 # 80009098 <cpus+0x8>
    80001500:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001502:	498d                	li	s3,3
        p->state = RUNNING;
    80001504:	4b11                	li	s6,4
        c->proc = p;
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	00008a17          	auipc	s4,0x8
    8000150c:	b58a0a13          	addi	s4,s4,-1192 # 80009060 <pid_lock>
    80001510:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001512:	0000e917          	auipc	s2,0xe
    80001516:	b7e90913          	addi	s2,s2,-1154 # 8000f090 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000151a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000151e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001522:	10079073          	csrw	sstatus,a5
    80001526:	00008497          	auipc	s1,0x8
    8000152a:	f6a48493          	addi	s1,s1,-150 # 80009490 <proc>
    8000152e:	a03d                	j	8000155c <scheduler+0x8e>
        p->state = RUNNING;
    80001530:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001534:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001538:	06048593          	addi	a1,s1,96
    8000153c:	8556                	mv	a0,s5
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	640080e7          	jalr	1600(ra) # 80001b7e <swtch>
        c->proc = 0;
    80001546:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	e4a080e7          	jalr	-438(ra) # 80006396 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001554:	17048493          	addi	s1,s1,368
    80001558:	fd2481e3          	beq	s1,s2,8000151a <scheduler+0x4c>
      acquire(&p->lock);
    8000155c:	8526                	mv	a0,s1
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	d84080e7          	jalr	-636(ra) # 800062e2 <acquire>
      if(p->state == RUNNABLE) {
    80001566:	4c9c                	lw	a5,24(s1)
    80001568:	ff3791e3          	bne	a5,s3,8000154a <scheduler+0x7c>
    8000156c:	b7d1                	j	80001530 <scheduler+0x62>

000000008000156e <sched>:
{
    8000156e:	7179                	addi	sp,sp,-48
    80001570:	f406                	sd	ra,40(sp)
    80001572:	f022                	sd	s0,32(sp)
    80001574:	ec26                	sd	s1,24(sp)
    80001576:	e84a                	sd	s2,16(sp)
    80001578:	e44e                	sd	s3,8(sp)
    8000157a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	9c2080e7          	jalr	-1598(ra) # 80000f3e <myproc>
    80001584:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	ce2080e7          	jalr	-798(ra) # 80006268 <holding>
    8000158e:	c93d                	beqz	a0,80001604 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001590:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001592:	2781                	sext.w	a5,a5
    80001594:	079e                	slli	a5,a5,0x7
    80001596:	00008717          	auipc	a4,0x8
    8000159a:	aca70713          	addi	a4,a4,-1334 # 80009060 <pid_lock>
    8000159e:	97ba                	add	a5,a5,a4
    800015a0:	0a87a703          	lw	a4,168(a5)
    800015a4:	4785                	li	a5,1
    800015a6:	06f71763          	bne	a4,a5,80001614 <sched+0xa6>
  if(p->state == RUNNING)
    800015aa:	4c98                	lw	a4,24(s1)
    800015ac:	4791                	li	a5,4
    800015ae:	06f70b63          	beq	a4,a5,80001624 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015b2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015b6:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015b8:	efb5                	bnez	a5,80001634 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ba:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015bc:	00008917          	auipc	s2,0x8
    800015c0:	aa490913          	addi	s2,s2,-1372 # 80009060 <pid_lock>
    800015c4:	2781                	sext.w	a5,a5
    800015c6:	079e                	slli	a5,a5,0x7
    800015c8:	97ca                	add	a5,a5,s2
    800015ca:	0ac7a983          	lw	s3,172(a5)
    800015ce:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015d0:	2781                	sext.w	a5,a5
    800015d2:	079e                	slli	a5,a5,0x7
    800015d4:	00008597          	auipc	a1,0x8
    800015d8:	ac458593          	addi	a1,a1,-1340 # 80009098 <cpus+0x8>
    800015dc:	95be                	add	a1,a1,a5
    800015de:	06048513          	addi	a0,s1,96
    800015e2:	00000097          	auipc	ra,0x0
    800015e6:	59c080e7          	jalr	1436(ra) # 80001b7e <swtch>
    800015ea:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015ec:	2781                	sext.w	a5,a5
    800015ee:	079e                	slli	a5,a5,0x7
    800015f0:	97ca                	add	a5,a5,s2
    800015f2:	0b37a623          	sw	s3,172(a5)
}
    800015f6:	70a2                	ld	ra,40(sp)
    800015f8:	7402                	ld	s0,32(sp)
    800015fa:	64e2                	ld	s1,24(sp)
    800015fc:	6942                	ld	s2,16(sp)
    800015fe:	69a2                	ld	s3,8(sp)
    80001600:	6145                	addi	sp,sp,48
    80001602:	8082                	ret
    panic("sched p->lock");
    80001604:	00007517          	auipc	a0,0x7
    80001608:	bc450513          	addi	a0,a0,-1084 # 800081c8 <etext+0x1c8>
    8000160c:	00004097          	auipc	ra,0x4
    80001610:	78c080e7          	jalr	1932(ra) # 80005d98 <panic>
    panic("sched locks");
    80001614:	00007517          	auipc	a0,0x7
    80001618:	bc450513          	addi	a0,a0,-1084 # 800081d8 <etext+0x1d8>
    8000161c:	00004097          	auipc	ra,0x4
    80001620:	77c080e7          	jalr	1916(ra) # 80005d98 <panic>
    panic("sched running");
    80001624:	00007517          	auipc	a0,0x7
    80001628:	bc450513          	addi	a0,a0,-1084 # 800081e8 <etext+0x1e8>
    8000162c:	00004097          	auipc	ra,0x4
    80001630:	76c080e7          	jalr	1900(ra) # 80005d98 <panic>
    panic("sched interruptible");
    80001634:	00007517          	auipc	a0,0x7
    80001638:	bc450513          	addi	a0,a0,-1084 # 800081f8 <etext+0x1f8>
    8000163c:	00004097          	auipc	ra,0x4
    80001640:	75c080e7          	jalr	1884(ra) # 80005d98 <panic>

0000000080001644 <yield>:
{
    80001644:	1101                	addi	sp,sp,-32
    80001646:	ec06                	sd	ra,24(sp)
    80001648:	e822                	sd	s0,16(sp)
    8000164a:	e426                	sd	s1,8(sp)
    8000164c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000164e:	00000097          	auipc	ra,0x0
    80001652:	8f0080e7          	jalr	-1808(ra) # 80000f3e <myproc>
    80001656:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	c8a080e7          	jalr	-886(ra) # 800062e2 <acquire>
  p->state = RUNNABLE;
    80001660:	478d                	li	a5,3
    80001662:	cc9c                	sw	a5,24(s1)
  sched();
    80001664:	00000097          	auipc	ra,0x0
    80001668:	f0a080e7          	jalr	-246(ra) # 8000156e <sched>
  release(&p->lock);
    8000166c:	8526                	mv	a0,s1
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	d28080e7          	jalr	-728(ra) # 80006396 <release>
}
    80001676:	60e2                	ld	ra,24(sp)
    80001678:	6442                	ld	s0,16(sp)
    8000167a:	64a2                	ld	s1,8(sp)
    8000167c:	6105                	addi	sp,sp,32
    8000167e:	8082                	ret

0000000080001680 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001680:	7179                	addi	sp,sp,-48
    80001682:	f406                	sd	ra,40(sp)
    80001684:	f022                	sd	s0,32(sp)
    80001686:	ec26                	sd	s1,24(sp)
    80001688:	e84a                	sd	s2,16(sp)
    8000168a:	e44e                	sd	s3,8(sp)
    8000168c:	1800                	addi	s0,sp,48
    8000168e:	89aa                	mv	s3,a0
    80001690:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001692:	00000097          	auipc	ra,0x0
    80001696:	8ac080e7          	jalr	-1876(ra) # 80000f3e <myproc>
    8000169a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	c46080e7          	jalr	-954(ra) # 800062e2 <acquire>
  release(lk);
    800016a4:	854a                	mv	a0,s2
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	cf0080e7          	jalr	-784(ra) # 80006396 <release>

  // Go to sleep.
  p->chan = chan;
    800016ae:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016b2:	4789                	li	a5,2
    800016b4:	cc9c                	sw	a5,24(s1)

  sched();
    800016b6:	00000097          	auipc	ra,0x0
    800016ba:	eb8080e7          	jalr	-328(ra) # 8000156e <sched>

  // Tidy up.
  p->chan = 0;
    800016be:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016c2:	8526                	mv	a0,s1
    800016c4:	00005097          	auipc	ra,0x5
    800016c8:	cd2080e7          	jalr	-814(ra) # 80006396 <release>
  acquire(lk);
    800016cc:	854a                	mv	a0,s2
    800016ce:	00005097          	auipc	ra,0x5
    800016d2:	c14080e7          	jalr	-1004(ra) # 800062e2 <acquire>
}
    800016d6:	70a2                	ld	ra,40(sp)
    800016d8:	7402                	ld	s0,32(sp)
    800016da:	64e2                	ld	s1,24(sp)
    800016dc:	6942                	ld	s2,16(sp)
    800016de:	69a2                	ld	s3,8(sp)
    800016e0:	6145                	addi	sp,sp,48
    800016e2:	8082                	ret

00000000800016e4 <wait>:
{
    800016e4:	715d                	addi	sp,sp,-80
    800016e6:	e486                	sd	ra,72(sp)
    800016e8:	e0a2                	sd	s0,64(sp)
    800016ea:	fc26                	sd	s1,56(sp)
    800016ec:	f84a                	sd	s2,48(sp)
    800016ee:	f44e                	sd	s3,40(sp)
    800016f0:	f052                	sd	s4,32(sp)
    800016f2:	ec56                	sd	s5,24(sp)
    800016f4:	e85a                	sd	s6,16(sp)
    800016f6:	e45e                	sd	s7,8(sp)
    800016f8:	e062                	sd	s8,0(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	840080e7          	jalr	-1984(ra) # 80000f3e <myproc>
    80001706:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001708:	00008517          	auipc	a0,0x8
    8000170c:	97050513          	addi	a0,a0,-1680 # 80009078 <wait_lock>
    80001710:	00005097          	auipc	ra,0x5
    80001714:	bd2080e7          	jalr	-1070(ra) # 800062e2 <acquire>
    havekids = 0;
    80001718:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000171a:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000171c:	0000e997          	auipc	s3,0xe
    80001720:	97498993          	addi	s3,s3,-1676 # 8000f090 <tickslock>
        havekids = 1;
    80001724:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001726:	00008c17          	auipc	s8,0x8
    8000172a:	952c0c13          	addi	s8,s8,-1710 # 80009078 <wait_lock>
    havekids = 0;
    8000172e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001730:	00008497          	auipc	s1,0x8
    80001734:	d6048493          	addi	s1,s1,-672 # 80009490 <proc>
    80001738:	a0bd                	j	800017a6 <wait+0xc2>
          pid = np->pid;
    8000173a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000173e:	000b0e63          	beqz	s6,8000175a <wait+0x76>
    80001742:	4691                	li	a3,4
    80001744:	02c48613          	addi	a2,s1,44
    80001748:	85da                	mv	a1,s6
    8000174a:	05093503          	ld	a0,80(s2)
    8000174e:	fffff097          	auipc	ra,0xfffff
    80001752:	4b6080e7          	jalr	1206(ra) # 80000c04 <copyout>
    80001756:	02054563          	bltz	a0,80001780 <wait+0x9c>
          freeproc(np);
    8000175a:	8526                	mv	a0,s1
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	9dc080e7          	jalr	-1572(ra) # 80001138 <freeproc>
          release(&np->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	c30080e7          	jalr	-976(ra) # 80006396 <release>
          release(&wait_lock);
    8000176e:	00008517          	auipc	a0,0x8
    80001772:	90a50513          	addi	a0,a0,-1782 # 80009078 <wait_lock>
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	c20080e7          	jalr	-992(ra) # 80006396 <release>
          return pid;
    8000177e:	a09d                	j	800017e4 <wait+0x100>
            release(&np->lock);
    80001780:	8526                	mv	a0,s1
    80001782:	00005097          	auipc	ra,0x5
    80001786:	c14080e7          	jalr	-1004(ra) # 80006396 <release>
            release(&wait_lock);
    8000178a:	00008517          	auipc	a0,0x8
    8000178e:	8ee50513          	addi	a0,a0,-1810 # 80009078 <wait_lock>
    80001792:	00005097          	auipc	ra,0x5
    80001796:	c04080e7          	jalr	-1020(ra) # 80006396 <release>
            return -1;
    8000179a:	59fd                	li	s3,-1
    8000179c:	a0a1                	j	800017e4 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000179e:	17048493          	addi	s1,s1,368
    800017a2:	03348463          	beq	s1,s3,800017ca <wait+0xe6>
      if(np->parent == p){
    800017a6:	7c9c                	ld	a5,56(s1)
    800017a8:	ff279be3          	bne	a5,s2,8000179e <wait+0xba>
        acquire(&np->lock);
    800017ac:	8526                	mv	a0,s1
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	b34080e7          	jalr	-1228(ra) # 800062e2 <acquire>
        if(np->state == ZOMBIE){
    800017b6:	4c9c                	lw	a5,24(s1)
    800017b8:	f94781e3          	beq	a5,s4,8000173a <wait+0x56>
        release(&np->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	bd8080e7          	jalr	-1064(ra) # 80006396 <release>
        havekids = 1;
    800017c6:	8756                	mv	a4,s5
    800017c8:	bfd9                	j	8000179e <wait+0xba>
    if(!havekids || p->killed){
    800017ca:	c701                	beqz	a4,800017d2 <wait+0xee>
    800017cc:	02892783          	lw	a5,40(s2)
    800017d0:	c79d                	beqz	a5,800017fe <wait+0x11a>
      release(&wait_lock);
    800017d2:	00008517          	auipc	a0,0x8
    800017d6:	8a650513          	addi	a0,a0,-1882 # 80009078 <wait_lock>
    800017da:	00005097          	auipc	ra,0x5
    800017de:	bbc080e7          	jalr	-1092(ra) # 80006396 <release>
      return -1;
    800017e2:	59fd                	li	s3,-1
}
    800017e4:	854e                	mv	a0,s3
    800017e6:	60a6                	ld	ra,72(sp)
    800017e8:	6406                	ld	s0,64(sp)
    800017ea:	74e2                	ld	s1,56(sp)
    800017ec:	7942                	ld	s2,48(sp)
    800017ee:	79a2                	ld	s3,40(sp)
    800017f0:	7a02                	ld	s4,32(sp)
    800017f2:	6ae2                	ld	s5,24(sp)
    800017f4:	6b42                	ld	s6,16(sp)
    800017f6:	6ba2                	ld	s7,8(sp)
    800017f8:	6c02                	ld	s8,0(sp)
    800017fa:	6161                	addi	sp,sp,80
    800017fc:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fe:	85e2                	mv	a1,s8
    80001800:	854a                	mv	a0,s2
    80001802:	00000097          	auipc	ra,0x0
    80001806:	e7e080e7          	jalr	-386(ra) # 80001680 <sleep>
    havekids = 0;
    8000180a:	b715                	j	8000172e <wait+0x4a>

000000008000180c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000180c:	7139                	addi	sp,sp,-64
    8000180e:	fc06                	sd	ra,56(sp)
    80001810:	f822                	sd	s0,48(sp)
    80001812:	f426                	sd	s1,40(sp)
    80001814:	f04a                	sd	s2,32(sp)
    80001816:	ec4e                	sd	s3,24(sp)
    80001818:	e852                	sd	s4,16(sp)
    8000181a:	e456                	sd	s5,8(sp)
    8000181c:	0080                	addi	s0,sp,64
    8000181e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001820:	00008497          	auipc	s1,0x8
    80001824:	c7048493          	addi	s1,s1,-912 # 80009490 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001828:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000182a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000182c:	0000e917          	auipc	s2,0xe
    80001830:	86490913          	addi	s2,s2,-1948 # 8000f090 <tickslock>
    80001834:	a821                	j	8000184c <wakeup+0x40>
        p->state = RUNNABLE;
    80001836:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000183a:	8526                	mv	a0,s1
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	b5a080e7          	jalr	-1190(ra) # 80006396 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001844:	17048493          	addi	s1,s1,368
    80001848:	03248463          	beq	s1,s2,80001870 <wakeup+0x64>
    if(p != myproc()){
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	6f2080e7          	jalr	1778(ra) # 80000f3e <myproc>
    80001854:	fea488e3          	beq	s1,a0,80001844 <wakeup+0x38>
      acquire(&p->lock);
    80001858:	8526                	mv	a0,s1
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	a88080e7          	jalr	-1400(ra) # 800062e2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001862:	4c9c                	lw	a5,24(s1)
    80001864:	fd379be3          	bne	a5,s3,8000183a <wakeup+0x2e>
    80001868:	709c                	ld	a5,32(s1)
    8000186a:	fd4798e3          	bne	a5,s4,8000183a <wakeup+0x2e>
    8000186e:	b7e1                	j	80001836 <wakeup+0x2a>
    }
  }
}
    80001870:	70e2                	ld	ra,56(sp)
    80001872:	7442                	ld	s0,48(sp)
    80001874:	74a2                	ld	s1,40(sp)
    80001876:	7902                	ld	s2,32(sp)
    80001878:	69e2                	ld	s3,24(sp)
    8000187a:	6a42                	ld	s4,16(sp)
    8000187c:	6aa2                	ld	s5,8(sp)
    8000187e:	6121                	addi	sp,sp,64
    80001880:	8082                	ret

0000000080001882 <reparent>:
{
    80001882:	7179                	addi	sp,sp,-48
    80001884:	f406                	sd	ra,40(sp)
    80001886:	f022                	sd	s0,32(sp)
    80001888:	ec26                	sd	s1,24(sp)
    8000188a:	e84a                	sd	s2,16(sp)
    8000188c:	e44e                	sd	s3,8(sp)
    8000188e:	e052                	sd	s4,0(sp)
    80001890:	1800                	addi	s0,sp,48
    80001892:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001894:	00008497          	auipc	s1,0x8
    80001898:	bfc48493          	addi	s1,s1,-1028 # 80009490 <proc>
      pp->parent = initproc;
    8000189c:	00007a17          	auipc	s4,0x7
    800018a0:	77ca0a13          	addi	s4,s4,1916 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018a4:	0000d997          	auipc	s3,0xd
    800018a8:	7ec98993          	addi	s3,s3,2028 # 8000f090 <tickslock>
    800018ac:	a029                	j	800018b6 <reparent+0x34>
    800018ae:	17048493          	addi	s1,s1,368
    800018b2:	01348d63          	beq	s1,s3,800018cc <reparent+0x4a>
    if(pp->parent == p){
    800018b6:	7c9c                	ld	a5,56(s1)
    800018b8:	ff279be3          	bne	a5,s2,800018ae <reparent+0x2c>
      pp->parent = initproc;
    800018bc:	000a3503          	ld	a0,0(s4)
    800018c0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018c2:	00000097          	auipc	ra,0x0
    800018c6:	f4a080e7          	jalr	-182(ra) # 8000180c <wakeup>
    800018ca:	b7d5                	j	800018ae <reparent+0x2c>
}
    800018cc:	70a2                	ld	ra,40(sp)
    800018ce:	7402                	ld	s0,32(sp)
    800018d0:	64e2                	ld	s1,24(sp)
    800018d2:	6942                	ld	s2,16(sp)
    800018d4:	69a2                	ld	s3,8(sp)
    800018d6:	6a02                	ld	s4,0(sp)
    800018d8:	6145                	addi	sp,sp,48
    800018da:	8082                	ret

00000000800018dc <exit>:
{
    800018dc:	7179                	addi	sp,sp,-48
    800018de:	f406                	sd	ra,40(sp)
    800018e0:	f022                	sd	s0,32(sp)
    800018e2:	ec26                	sd	s1,24(sp)
    800018e4:	e84a                	sd	s2,16(sp)
    800018e6:	e44e                	sd	s3,8(sp)
    800018e8:	e052                	sd	s4,0(sp)
    800018ea:	1800                	addi	s0,sp,48
    800018ec:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	650080e7          	jalr	1616(ra) # 80000f3e <myproc>
    800018f6:	89aa                	mv	s3,a0
  if(p == initproc)
    800018f8:	00007797          	auipc	a5,0x7
    800018fc:	7207b783          	ld	a5,1824(a5) # 80009018 <initproc>
    80001900:	0d050493          	addi	s1,a0,208
    80001904:	15050913          	addi	s2,a0,336
    80001908:	02a79363          	bne	a5,a0,8000192e <exit+0x52>
    panic("init exiting");
    8000190c:	00007517          	auipc	a0,0x7
    80001910:	90450513          	addi	a0,a0,-1788 # 80008210 <etext+0x210>
    80001914:	00004097          	auipc	ra,0x4
    80001918:	484080e7          	jalr	1156(ra) # 80005d98 <panic>
      fileclose(f);
    8000191c:	00002097          	auipc	ra,0x2
    80001920:	254080e7          	jalr	596(ra) # 80003b70 <fileclose>
      p->ofile[fd] = 0;
    80001924:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001928:	04a1                	addi	s1,s1,8
    8000192a:	01248563          	beq	s1,s2,80001934 <exit+0x58>
    if(p->ofile[fd]){
    8000192e:	6088                	ld	a0,0(s1)
    80001930:	f575                	bnez	a0,8000191c <exit+0x40>
    80001932:	bfdd                	j	80001928 <exit+0x4c>
  begin_op();
    80001934:	00002097          	auipc	ra,0x2
    80001938:	d70080e7          	jalr	-656(ra) # 800036a4 <begin_op>
  iput(p->cwd);
    8000193c:	1509b503          	ld	a0,336(s3)
    80001940:	00001097          	auipc	ra,0x1
    80001944:	54c080e7          	jalr	1356(ra) # 80002e8c <iput>
  end_op();
    80001948:	00002097          	auipc	ra,0x2
    8000194c:	ddc080e7          	jalr	-548(ra) # 80003724 <end_op>
  p->cwd = 0;
    80001950:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001954:	00007497          	auipc	s1,0x7
    80001958:	72448493          	addi	s1,s1,1828 # 80009078 <wait_lock>
    8000195c:	8526                	mv	a0,s1
    8000195e:	00005097          	auipc	ra,0x5
    80001962:	984080e7          	jalr	-1660(ra) # 800062e2 <acquire>
  reparent(p);
    80001966:	854e                	mv	a0,s3
    80001968:	00000097          	auipc	ra,0x0
    8000196c:	f1a080e7          	jalr	-230(ra) # 80001882 <reparent>
  wakeup(p->parent);
    80001970:	0389b503          	ld	a0,56(s3)
    80001974:	00000097          	auipc	ra,0x0
    80001978:	e98080e7          	jalr	-360(ra) # 8000180c <wakeup>
  acquire(&p->lock);
    8000197c:	854e                	mv	a0,s3
    8000197e:	00005097          	auipc	ra,0x5
    80001982:	964080e7          	jalr	-1692(ra) # 800062e2 <acquire>
  p->xstate = status;
    80001986:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000198a:	4795                	li	a5,5
    8000198c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001990:	8526                	mv	a0,s1
    80001992:	00005097          	auipc	ra,0x5
    80001996:	a04080e7          	jalr	-1532(ra) # 80006396 <release>
  sched();
    8000199a:	00000097          	auipc	ra,0x0
    8000199e:	bd4080e7          	jalr	-1068(ra) # 8000156e <sched>
  panic("zombie exit");
    800019a2:	00007517          	auipc	a0,0x7
    800019a6:	87e50513          	addi	a0,a0,-1922 # 80008220 <etext+0x220>
    800019aa:	00004097          	auipc	ra,0x4
    800019ae:	3ee080e7          	jalr	1006(ra) # 80005d98 <panic>

00000000800019b2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019b2:	7179                	addi	sp,sp,-48
    800019b4:	f406                	sd	ra,40(sp)
    800019b6:	f022                	sd	s0,32(sp)
    800019b8:	ec26                	sd	s1,24(sp)
    800019ba:	e84a                	sd	s2,16(sp)
    800019bc:	e44e                	sd	s3,8(sp)
    800019be:	1800                	addi	s0,sp,48
    800019c0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019c2:	00008497          	auipc	s1,0x8
    800019c6:	ace48493          	addi	s1,s1,-1330 # 80009490 <proc>
    800019ca:	0000d997          	auipc	s3,0xd
    800019ce:	6c698993          	addi	s3,s3,1734 # 8000f090 <tickslock>
    acquire(&p->lock);
    800019d2:	8526                	mv	a0,s1
    800019d4:	00005097          	auipc	ra,0x5
    800019d8:	90e080e7          	jalr	-1778(ra) # 800062e2 <acquire>
    if(p->pid == pid){
    800019dc:	589c                	lw	a5,48(s1)
    800019de:	01278d63          	beq	a5,s2,800019f8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019e2:	8526                	mv	a0,s1
    800019e4:	00005097          	auipc	ra,0x5
    800019e8:	9b2080e7          	jalr	-1614(ra) # 80006396 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ec:	17048493          	addi	s1,s1,368
    800019f0:	ff3491e3          	bne	s1,s3,800019d2 <kill+0x20>
  }
  return -1;
    800019f4:	557d                	li	a0,-1
    800019f6:	a829                	j	80001a10 <kill+0x5e>
      p->killed = 1;
    800019f8:	4785                	li	a5,1
    800019fa:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019fc:	4c98                	lw	a4,24(s1)
    800019fe:	4789                	li	a5,2
    80001a00:	00f70f63          	beq	a4,a5,80001a1e <kill+0x6c>
      release(&p->lock);
    80001a04:	8526                	mv	a0,s1
    80001a06:	00005097          	auipc	ra,0x5
    80001a0a:	990080e7          	jalr	-1648(ra) # 80006396 <release>
      return 0;
    80001a0e:	4501                	li	a0,0
}
    80001a10:	70a2                	ld	ra,40(sp)
    80001a12:	7402                	ld	s0,32(sp)
    80001a14:	64e2                	ld	s1,24(sp)
    80001a16:	6942                	ld	s2,16(sp)
    80001a18:	69a2                	ld	s3,8(sp)
    80001a1a:	6145                	addi	sp,sp,48
    80001a1c:	8082                	ret
        p->state = RUNNABLE;
    80001a1e:	478d                	li	a5,3
    80001a20:	cc9c                	sw	a5,24(s1)
    80001a22:	b7cd                	j	80001a04 <kill+0x52>

0000000080001a24 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a24:	7179                	addi	sp,sp,-48
    80001a26:	f406                	sd	ra,40(sp)
    80001a28:	f022                	sd	s0,32(sp)
    80001a2a:	ec26                	sd	s1,24(sp)
    80001a2c:	e84a                	sd	s2,16(sp)
    80001a2e:	e44e                	sd	s3,8(sp)
    80001a30:	e052                	sd	s4,0(sp)
    80001a32:	1800                	addi	s0,sp,48
    80001a34:	84aa                	mv	s1,a0
    80001a36:	892e                	mv	s2,a1
    80001a38:	89b2                	mv	s3,a2
    80001a3a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	502080e7          	jalr	1282(ra) # 80000f3e <myproc>
  if(user_dst){
    80001a44:	c08d                	beqz	s1,80001a66 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a46:	86d2                	mv	a3,s4
    80001a48:	864e                	mv	a2,s3
    80001a4a:	85ca                	mv	a1,s2
    80001a4c:	6928                	ld	a0,80(a0)
    80001a4e:	fffff097          	auipc	ra,0xfffff
    80001a52:	1b6080e7          	jalr	438(ra) # 80000c04 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a56:	70a2                	ld	ra,40(sp)
    80001a58:	7402                	ld	s0,32(sp)
    80001a5a:	64e2                	ld	s1,24(sp)
    80001a5c:	6942                	ld	s2,16(sp)
    80001a5e:	69a2                	ld	s3,8(sp)
    80001a60:	6a02                	ld	s4,0(sp)
    80001a62:	6145                	addi	sp,sp,48
    80001a64:	8082                	ret
    memmove((char *)dst, src, len);
    80001a66:	000a061b          	sext.w	a2,s4
    80001a6a:	85ce                	mv	a1,s3
    80001a6c:	854a                	mv	a0,s2
    80001a6e:	ffffe097          	auipc	ra,0xffffe
    80001a72:	76a080e7          	jalr	1898(ra) # 800001d8 <memmove>
    return 0;
    80001a76:	8526                	mv	a0,s1
    80001a78:	bff9                	j	80001a56 <either_copyout+0x32>

0000000080001a7a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a7a:	7179                	addi	sp,sp,-48
    80001a7c:	f406                	sd	ra,40(sp)
    80001a7e:	f022                	sd	s0,32(sp)
    80001a80:	ec26                	sd	s1,24(sp)
    80001a82:	e84a                	sd	s2,16(sp)
    80001a84:	e44e                	sd	s3,8(sp)
    80001a86:	e052                	sd	s4,0(sp)
    80001a88:	1800                	addi	s0,sp,48
    80001a8a:	892a                	mv	s2,a0
    80001a8c:	84ae                	mv	s1,a1
    80001a8e:	89b2                	mv	s3,a2
    80001a90:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a92:	fffff097          	auipc	ra,0xfffff
    80001a96:	4ac080e7          	jalr	1196(ra) # 80000f3e <myproc>
  if(user_src){
    80001a9a:	c08d                	beqz	s1,80001abc <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a9c:	86d2                	mv	a3,s4
    80001a9e:	864e                	mv	a2,s3
    80001aa0:	85ca                	mv	a1,s2
    80001aa2:	6928                	ld	a0,80(a0)
    80001aa4:	fffff097          	auipc	ra,0xfffff
    80001aa8:	1ec080e7          	jalr	492(ra) # 80000c90 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001aac:	70a2                	ld	ra,40(sp)
    80001aae:	7402                	ld	s0,32(sp)
    80001ab0:	64e2                	ld	s1,24(sp)
    80001ab2:	6942                	ld	s2,16(sp)
    80001ab4:	69a2                	ld	s3,8(sp)
    80001ab6:	6a02                	ld	s4,0(sp)
    80001ab8:	6145                	addi	sp,sp,48
    80001aba:	8082                	ret
    memmove(dst, (char*)src, len);
    80001abc:	000a061b          	sext.w	a2,s4
    80001ac0:	85ce                	mv	a1,s3
    80001ac2:	854a                	mv	a0,s2
    80001ac4:	ffffe097          	auipc	ra,0xffffe
    80001ac8:	714080e7          	jalr	1812(ra) # 800001d8 <memmove>
    return 0;
    80001acc:	8526                	mv	a0,s1
    80001ace:	bff9                	j	80001aac <either_copyin+0x32>

0000000080001ad0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ad0:	715d                	addi	sp,sp,-80
    80001ad2:	e486                	sd	ra,72(sp)
    80001ad4:	e0a2                	sd	s0,64(sp)
    80001ad6:	fc26                	sd	s1,56(sp)
    80001ad8:	f84a                	sd	s2,48(sp)
    80001ada:	f44e                	sd	s3,40(sp)
    80001adc:	f052                	sd	s4,32(sp)
    80001ade:	ec56                	sd	s5,24(sp)
    80001ae0:	e85a                	sd	s6,16(sp)
    80001ae2:	e45e                	sd	s7,8(sp)
    80001ae4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ae6:	00006517          	auipc	a0,0x6
    80001aea:	56250513          	addi	a0,a0,1378 # 80008048 <etext+0x48>
    80001aee:	00004097          	auipc	ra,0x4
    80001af2:	2f4080e7          	jalr	756(ra) # 80005de2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001af6:	00008497          	auipc	s1,0x8
    80001afa:	af248493          	addi	s1,s1,-1294 # 800095e8 <proc+0x158>
    80001afe:	0000d917          	auipc	s2,0xd
    80001b02:	6ea90913          	addi	s2,s2,1770 # 8000f1e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b06:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b08:	00006997          	auipc	s3,0x6
    80001b0c:	72898993          	addi	s3,s3,1832 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001b10:	00006a97          	auipc	s5,0x6
    80001b14:	728a8a93          	addi	s5,s5,1832 # 80008238 <etext+0x238>
    printf("\n");
    80001b18:	00006a17          	auipc	s4,0x6
    80001b1c:	530a0a13          	addi	s4,s4,1328 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b20:	00006b97          	auipc	s7,0x6
    80001b24:	750b8b93          	addi	s7,s7,1872 # 80008270 <states.1718>
    80001b28:	a00d                	j	80001b4a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b2a:	ed86a583          	lw	a1,-296(a3)
    80001b2e:	8556                	mv	a0,s5
    80001b30:	00004097          	auipc	ra,0x4
    80001b34:	2b2080e7          	jalr	690(ra) # 80005de2 <printf>
    printf("\n");
    80001b38:	8552                	mv	a0,s4
    80001b3a:	00004097          	auipc	ra,0x4
    80001b3e:	2a8080e7          	jalr	680(ra) # 80005de2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b42:	17048493          	addi	s1,s1,368
    80001b46:	03248163          	beq	s1,s2,80001b68 <procdump+0x98>
    if(p->state == UNUSED)
    80001b4a:	86a6                	mv	a3,s1
    80001b4c:	ec04a783          	lw	a5,-320(s1)
    80001b50:	dbed                	beqz	a5,80001b42 <procdump+0x72>
      state = "???";
    80001b52:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b54:	fcfb6be3          	bltu	s6,a5,80001b2a <procdump+0x5a>
    80001b58:	1782                	slli	a5,a5,0x20
    80001b5a:	9381                	srli	a5,a5,0x20
    80001b5c:	078e                	slli	a5,a5,0x3
    80001b5e:	97de                	add	a5,a5,s7
    80001b60:	6390                	ld	a2,0(a5)
    80001b62:	f661                	bnez	a2,80001b2a <procdump+0x5a>
      state = "???";
    80001b64:	864e                	mv	a2,s3
    80001b66:	b7d1                	j	80001b2a <procdump+0x5a>
  }
}
    80001b68:	60a6                	ld	ra,72(sp)
    80001b6a:	6406                	ld	s0,64(sp)
    80001b6c:	74e2                	ld	s1,56(sp)
    80001b6e:	7942                	ld	s2,48(sp)
    80001b70:	79a2                	ld	s3,40(sp)
    80001b72:	7a02                	ld	s4,32(sp)
    80001b74:	6ae2                	ld	s5,24(sp)
    80001b76:	6b42                	ld	s6,16(sp)
    80001b78:	6ba2                	ld	s7,8(sp)
    80001b7a:	6161                	addi	sp,sp,80
    80001b7c:	8082                	ret

0000000080001b7e <swtch>:
    80001b7e:	00153023          	sd	ra,0(a0)
    80001b82:	00253423          	sd	sp,8(a0)
    80001b86:	e900                	sd	s0,16(a0)
    80001b88:	ed04                	sd	s1,24(a0)
    80001b8a:	03253023          	sd	s2,32(a0)
    80001b8e:	03353423          	sd	s3,40(a0)
    80001b92:	03453823          	sd	s4,48(a0)
    80001b96:	03553c23          	sd	s5,56(a0)
    80001b9a:	05653023          	sd	s6,64(a0)
    80001b9e:	05753423          	sd	s7,72(a0)
    80001ba2:	05853823          	sd	s8,80(a0)
    80001ba6:	05953c23          	sd	s9,88(a0)
    80001baa:	07a53023          	sd	s10,96(a0)
    80001bae:	07b53423          	sd	s11,104(a0)
    80001bb2:	0005b083          	ld	ra,0(a1)
    80001bb6:	0085b103          	ld	sp,8(a1)
    80001bba:	6980                	ld	s0,16(a1)
    80001bbc:	6d84                	ld	s1,24(a1)
    80001bbe:	0205b903          	ld	s2,32(a1)
    80001bc2:	0285b983          	ld	s3,40(a1)
    80001bc6:	0305ba03          	ld	s4,48(a1)
    80001bca:	0385ba83          	ld	s5,56(a1)
    80001bce:	0405bb03          	ld	s6,64(a1)
    80001bd2:	0485bb83          	ld	s7,72(a1)
    80001bd6:	0505bc03          	ld	s8,80(a1)
    80001bda:	0585bc83          	ld	s9,88(a1)
    80001bde:	0605bd03          	ld	s10,96(a1)
    80001be2:	0685bd83          	ld	s11,104(a1)
    80001be6:	8082                	ret

0000000080001be8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001be8:	1141                	addi	sp,sp,-16
    80001bea:	e406                	sd	ra,8(sp)
    80001bec:	e022                	sd	s0,0(sp)
    80001bee:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bf0:	00006597          	auipc	a1,0x6
    80001bf4:	6b058593          	addi	a1,a1,1712 # 800082a0 <states.1718+0x30>
    80001bf8:	0000d517          	auipc	a0,0xd
    80001bfc:	49850513          	addi	a0,a0,1176 # 8000f090 <tickslock>
    80001c00:	00004097          	auipc	ra,0x4
    80001c04:	652080e7          	jalr	1618(ra) # 80006252 <initlock>
}
    80001c08:	60a2                	ld	ra,8(sp)
    80001c0a:	6402                	ld	s0,0(sp)
    80001c0c:	0141                	addi	sp,sp,16
    80001c0e:	8082                	ret

0000000080001c10 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c10:	1141                	addi	sp,sp,-16
    80001c12:	e422                	sd	s0,8(sp)
    80001c14:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c16:	00003797          	auipc	a5,0x3
    80001c1a:	58a78793          	addi	a5,a5,1418 # 800051a0 <kernelvec>
    80001c1e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c22:	6422                	ld	s0,8(sp)
    80001c24:	0141                	addi	sp,sp,16
    80001c26:	8082                	ret

0000000080001c28 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c28:	1141                	addi	sp,sp,-16
    80001c2a:	e406                	sd	ra,8(sp)
    80001c2c:	e022                	sd	s0,0(sp)
    80001c2e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c30:	fffff097          	auipc	ra,0xfffff
    80001c34:	30e080e7          	jalr	782(ra) # 80000f3e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c38:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c3c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c3e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c42:	00005617          	auipc	a2,0x5
    80001c46:	3be60613          	addi	a2,a2,958 # 80007000 <_trampoline>
    80001c4a:	00005697          	auipc	a3,0x5
    80001c4e:	3b668693          	addi	a3,a3,950 # 80007000 <_trampoline>
    80001c52:	8e91                	sub	a3,a3,a2
    80001c54:	040007b7          	lui	a5,0x4000
    80001c58:	17fd                	addi	a5,a5,-1
    80001c5a:	07b2                	slli	a5,a5,0xc
    80001c5c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c5e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c62:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c64:	180026f3          	csrr	a3,satp
    80001c68:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c6a:	6d38                	ld	a4,88(a0)
    80001c6c:	6134                	ld	a3,64(a0)
    80001c6e:	6585                	lui	a1,0x1
    80001c70:	96ae                	add	a3,a3,a1
    80001c72:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c74:	6d38                	ld	a4,88(a0)
    80001c76:	00000697          	auipc	a3,0x0
    80001c7a:	13868693          	addi	a3,a3,312 # 80001dae <usertrap>
    80001c7e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c80:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c82:	8692                	mv	a3,tp
    80001c84:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c86:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c8a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c8e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c92:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c96:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c98:	6f18                	ld	a4,24(a4)
    80001c9a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c9e:	692c                	ld	a1,80(a0)
    80001ca0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001ca2:	00005717          	auipc	a4,0x5
    80001ca6:	3ee70713          	addi	a4,a4,1006 # 80007090 <userret>
    80001caa:	8f11                	sub	a4,a4,a2
    80001cac:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cae:	577d                	li	a4,-1
    80001cb0:	177e                	slli	a4,a4,0x3f
    80001cb2:	8dd9                	or	a1,a1,a4
    80001cb4:	02000537          	lui	a0,0x2000
    80001cb8:	157d                	addi	a0,a0,-1
    80001cba:	0536                	slli	a0,a0,0xd
    80001cbc:	9782                	jalr	a5
}
    80001cbe:	60a2                	ld	ra,8(sp)
    80001cc0:	6402                	ld	s0,0(sp)
    80001cc2:	0141                	addi	sp,sp,16
    80001cc4:	8082                	ret

0000000080001cc6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cc6:	1101                	addi	sp,sp,-32
    80001cc8:	ec06                	sd	ra,24(sp)
    80001cca:	e822                	sd	s0,16(sp)
    80001ccc:	e426                	sd	s1,8(sp)
    80001cce:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cd0:	0000d497          	auipc	s1,0xd
    80001cd4:	3c048493          	addi	s1,s1,960 # 8000f090 <tickslock>
    80001cd8:	8526                	mv	a0,s1
    80001cda:	00004097          	auipc	ra,0x4
    80001cde:	608080e7          	jalr	1544(ra) # 800062e2 <acquire>
  ticks++;
    80001ce2:	00007517          	auipc	a0,0x7
    80001ce6:	33e50513          	addi	a0,a0,830 # 80009020 <ticks>
    80001cea:	411c                	lw	a5,0(a0)
    80001cec:	2785                	addiw	a5,a5,1
    80001cee:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	b1c080e7          	jalr	-1252(ra) # 8000180c <wakeup>
  release(&tickslock);
    80001cf8:	8526                	mv	a0,s1
    80001cfa:	00004097          	auipc	ra,0x4
    80001cfe:	69c080e7          	jalr	1692(ra) # 80006396 <release>
}
    80001d02:	60e2                	ld	ra,24(sp)
    80001d04:	6442                	ld	s0,16(sp)
    80001d06:	64a2                	ld	s1,8(sp)
    80001d08:	6105                	addi	sp,sp,32
    80001d0a:	8082                	ret

0000000080001d0c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d0c:	1101                	addi	sp,sp,-32
    80001d0e:	ec06                	sd	ra,24(sp)
    80001d10:	e822                	sd	s0,16(sp)
    80001d12:	e426                	sd	s1,8(sp)
    80001d14:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d16:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d1a:	00074d63          	bltz	a4,80001d34 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d1e:	57fd                	li	a5,-1
    80001d20:	17fe                	slli	a5,a5,0x3f
    80001d22:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d24:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d26:	06f70363          	beq	a4,a5,80001d8c <devintr+0x80>
  }
}
    80001d2a:	60e2                	ld	ra,24(sp)
    80001d2c:	6442                	ld	s0,16(sp)
    80001d2e:	64a2                	ld	s1,8(sp)
    80001d30:	6105                	addi	sp,sp,32
    80001d32:	8082                	ret
     (scause & 0xff) == 9){
    80001d34:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d38:	46a5                	li	a3,9
    80001d3a:	fed792e3          	bne	a5,a3,80001d1e <devintr+0x12>
    int irq = plic_claim();
    80001d3e:	00003097          	auipc	ra,0x3
    80001d42:	56a080e7          	jalr	1386(ra) # 800052a8 <plic_claim>
    80001d46:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d48:	47a9                	li	a5,10
    80001d4a:	02f50763          	beq	a0,a5,80001d78 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d4e:	4785                	li	a5,1
    80001d50:	02f50963          	beq	a0,a5,80001d82 <devintr+0x76>
    return 1;
    80001d54:	4505                	li	a0,1
    } else if(irq){
    80001d56:	d8f1                	beqz	s1,80001d2a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d58:	85a6                	mv	a1,s1
    80001d5a:	00006517          	auipc	a0,0x6
    80001d5e:	54e50513          	addi	a0,a0,1358 # 800082a8 <states.1718+0x38>
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	080080e7          	jalr	128(ra) # 80005de2 <printf>
      plic_complete(irq);
    80001d6a:	8526                	mv	a0,s1
    80001d6c:	00003097          	auipc	ra,0x3
    80001d70:	560080e7          	jalr	1376(ra) # 800052cc <plic_complete>
    return 1;
    80001d74:	4505                	li	a0,1
    80001d76:	bf55                	j	80001d2a <devintr+0x1e>
      uartintr();
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	48a080e7          	jalr	1162(ra) # 80006202 <uartintr>
    80001d80:	b7ed                	j	80001d6a <devintr+0x5e>
      virtio_disk_intr();
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	a2a080e7          	jalr	-1494(ra) # 800057ac <virtio_disk_intr>
    80001d8a:	b7c5                	j	80001d6a <devintr+0x5e>
    if(cpuid() == 0){
    80001d8c:	fffff097          	auipc	ra,0xfffff
    80001d90:	186080e7          	jalr	390(ra) # 80000f12 <cpuid>
    80001d94:	c901                	beqz	a0,80001da4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d96:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d9a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d9c:	14479073          	csrw	sip,a5
    return 2;
    80001da0:	4509                	li	a0,2
    80001da2:	b761                	j	80001d2a <devintr+0x1e>
      clockintr();
    80001da4:	00000097          	auipc	ra,0x0
    80001da8:	f22080e7          	jalr	-222(ra) # 80001cc6 <clockintr>
    80001dac:	b7ed                	j	80001d96 <devintr+0x8a>

0000000080001dae <usertrap>:
{
    80001dae:	1101                	addi	sp,sp,-32
    80001db0:	ec06                	sd	ra,24(sp)
    80001db2:	e822                	sd	s0,16(sp)
    80001db4:	e426                	sd	s1,8(sp)
    80001db6:	e04a                	sd	s2,0(sp)
    80001db8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dba:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dbe:	1007f793          	andi	a5,a5,256
    80001dc2:	e3ad                	bnez	a5,80001e24 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dc4:	00003797          	auipc	a5,0x3
    80001dc8:	3dc78793          	addi	a5,a5,988 # 800051a0 <kernelvec>
    80001dcc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	16e080e7          	jalr	366(ra) # 80000f3e <myproc>
    80001dd8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001dda:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ddc:	14102773          	csrr	a4,sepc
    80001de0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001de6:	47a1                	li	a5,8
    80001de8:	04f71c63          	bne	a4,a5,80001e40 <usertrap+0x92>
    if(p->killed)
    80001dec:	551c                	lw	a5,40(a0)
    80001dee:	e3b9                	bnez	a5,80001e34 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001df0:	6cb8                	ld	a4,88(s1)
    80001df2:	6f1c                	ld	a5,24(a4)
    80001df4:	0791                	addi	a5,a5,4
    80001df6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dfc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e00:	10079073          	csrw	sstatus,a5
    syscall();
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	2e0080e7          	jalr	736(ra) # 800020e4 <syscall>
  if(p->killed)
    80001e0c:	549c                	lw	a5,40(s1)
    80001e0e:	ebc1                	bnez	a5,80001e9e <usertrap+0xf0>
  usertrapret();
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	e18080e7          	jalr	-488(ra) # 80001c28 <usertrapret>
}
    80001e18:	60e2                	ld	ra,24(sp)
    80001e1a:	6442                	ld	s0,16(sp)
    80001e1c:	64a2                	ld	s1,8(sp)
    80001e1e:	6902                	ld	s2,0(sp)
    80001e20:	6105                	addi	sp,sp,32
    80001e22:	8082                	ret
    panic("usertrap: not from user mode");
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	4a450513          	addi	a0,a0,1188 # 800082c8 <states.1718+0x58>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	f6c080e7          	jalr	-148(ra) # 80005d98 <panic>
      exit(-1);
    80001e34:	557d                	li	a0,-1
    80001e36:	00000097          	auipc	ra,0x0
    80001e3a:	aa6080e7          	jalr	-1370(ra) # 800018dc <exit>
    80001e3e:	bf4d                	j	80001df0 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	ecc080e7          	jalr	-308(ra) # 80001d0c <devintr>
    80001e48:	892a                	mv	s2,a0
    80001e4a:	c501                	beqz	a0,80001e52 <usertrap+0xa4>
  if(p->killed)
    80001e4c:	549c                	lw	a5,40(s1)
    80001e4e:	c3a1                	beqz	a5,80001e8e <usertrap+0xe0>
    80001e50:	a815                	j	80001e84 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e52:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e56:	5890                	lw	a2,48(s1)
    80001e58:	00006517          	auipc	a0,0x6
    80001e5c:	49050513          	addi	a0,a0,1168 # 800082e8 <states.1718+0x78>
    80001e60:	00004097          	auipc	ra,0x4
    80001e64:	f82080e7          	jalr	-126(ra) # 80005de2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e68:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e6c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e70:	00006517          	auipc	a0,0x6
    80001e74:	4a850513          	addi	a0,a0,1192 # 80008318 <states.1718+0xa8>
    80001e78:	00004097          	auipc	ra,0x4
    80001e7c:	f6a080e7          	jalr	-150(ra) # 80005de2 <printf>
    p->killed = 1;
    80001e80:	4785                	li	a5,1
    80001e82:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001e84:	557d                	li	a0,-1
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	a56080e7          	jalr	-1450(ra) # 800018dc <exit>
  if(which_dev == 2)
    80001e8e:	4789                	li	a5,2
    80001e90:	f8f910e3          	bne	s2,a5,80001e10 <usertrap+0x62>
    yield();
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	7b0080e7          	jalr	1968(ra) # 80001644 <yield>
    80001e9c:	bf95                	j	80001e10 <usertrap+0x62>
  int which_dev = 0;
    80001e9e:	4901                	li	s2,0
    80001ea0:	b7d5                	j	80001e84 <usertrap+0xd6>

0000000080001ea2 <kerneltrap>:
{
    80001ea2:	7179                	addi	sp,sp,-48
    80001ea4:	f406                	sd	ra,40(sp)
    80001ea6:	f022                	sd	s0,32(sp)
    80001ea8:	ec26                	sd	s1,24(sp)
    80001eaa:	e84a                	sd	s2,16(sp)
    80001eac:	e44e                	sd	s3,8(sp)
    80001eae:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eb0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eb4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eb8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ebc:	1004f793          	andi	a5,s1,256
    80001ec0:	cb85                	beqz	a5,80001ef0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ec6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ec8:	ef85                	bnez	a5,80001f00 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	e42080e7          	jalr	-446(ra) # 80001d0c <devintr>
    80001ed2:	cd1d                	beqz	a0,80001f10 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ed4:	4789                	li	a5,2
    80001ed6:	06f50a63          	beq	a0,a5,80001f4a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eda:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ede:	10049073          	csrw	sstatus,s1
}
    80001ee2:	70a2                	ld	ra,40(sp)
    80001ee4:	7402                	ld	s0,32(sp)
    80001ee6:	64e2                	ld	s1,24(sp)
    80001ee8:	6942                	ld	s2,16(sp)
    80001eea:	69a2                	ld	s3,8(sp)
    80001eec:	6145                	addi	sp,sp,48
    80001eee:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	44850513          	addi	a0,a0,1096 # 80008338 <states.1718+0xc8>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	ea0080e7          	jalr	-352(ra) # 80005d98 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	46050513          	addi	a0,a0,1120 # 80008360 <states.1718+0xf0>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	e90080e7          	jalr	-368(ra) # 80005d98 <panic>
    printf("scause %p\n", scause);
    80001f10:	85ce                	mv	a1,s3
    80001f12:	00006517          	auipc	a0,0x6
    80001f16:	46e50513          	addi	a0,a0,1134 # 80008380 <states.1718+0x110>
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	ec8080e7          	jalr	-312(ra) # 80005de2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f22:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f26:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f2a:	00006517          	auipc	a0,0x6
    80001f2e:	46650513          	addi	a0,a0,1126 # 80008390 <states.1718+0x120>
    80001f32:	00004097          	auipc	ra,0x4
    80001f36:	eb0080e7          	jalr	-336(ra) # 80005de2 <printf>
    panic("kerneltrap");
    80001f3a:	00006517          	auipc	a0,0x6
    80001f3e:	46e50513          	addi	a0,a0,1134 # 800083a8 <states.1718+0x138>
    80001f42:	00004097          	auipc	ra,0x4
    80001f46:	e56080e7          	jalr	-426(ra) # 80005d98 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f4a:	fffff097          	auipc	ra,0xfffff
    80001f4e:	ff4080e7          	jalr	-12(ra) # 80000f3e <myproc>
    80001f52:	d541                	beqz	a0,80001eda <kerneltrap+0x38>
    80001f54:	fffff097          	auipc	ra,0xfffff
    80001f58:	fea080e7          	jalr	-22(ra) # 80000f3e <myproc>
    80001f5c:	4d18                	lw	a4,24(a0)
    80001f5e:	4791                	li	a5,4
    80001f60:	f6f71de3          	bne	a4,a5,80001eda <kerneltrap+0x38>
    yield();
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	6e0080e7          	jalr	1760(ra) # 80001644 <yield>
    80001f6c:	b7bd                	j	80001eda <kerneltrap+0x38>

0000000080001f6e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f6e:	1101                	addi	sp,sp,-32
    80001f70:	ec06                	sd	ra,24(sp)
    80001f72:	e822                	sd	s0,16(sp)
    80001f74:	e426                	sd	s1,8(sp)
    80001f76:	1000                	addi	s0,sp,32
    80001f78:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	fc4080e7          	jalr	-60(ra) # 80000f3e <myproc>
  switch (n) {
    80001f82:	4795                	li	a5,5
    80001f84:	0497e163          	bltu	a5,s1,80001fc6 <argraw+0x58>
    80001f88:	048a                	slli	s1,s1,0x2
    80001f8a:	00006717          	auipc	a4,0x6
    80001f8e:	45670713          	addi	a4,a4,1110 # 800083e0 <states.1718+0x170>
    80001f92:	94ba                	add	s1,s1,a4
    80001f94:	409c                	lw	a5,0(s1)
    80001f96:	97ba                	add	a5,a5,a4
    80001f98:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f9a:	6d3c                	ld	a5,88(a0)
    80001f9c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	64a2                	ld	s1,8(sp)
    80001fa4:	6105                	addi	sp,sp,32
    80001fa6:	8082                	ret
    return p->trapframe->a1;
    80001fa8:	6d3c                	ld	a5,88(a0)
    80001faa:	7fa8                	ld	a0,120(a5)
    80001fac:	bfcd                	j	80001f9e <argraw+0x30>
    return p->trapframe->a2;
    80001fae:	6d3c                	ld	a5,88(a0)
    80001fb0:	63c8                	ld	a0,128(a5)
    80001fb2:	b7f5                	j	80001f9e <argraw+0x30>
    return p->trapframe->a3;
    80001fb4:	6d3c                	ld	a5,88(a0)
    80001fb6:	67c8                	ld	a0,136(a5)
    80001fb8:	b7dd                	j	80001f9e <argraw+0x30>
    return p->trapframe->a4;
    80001fba:	6d3c                	ld	a5,88(a0)
    80001fbc:	6bc8                	ld	a0,144(a5)
    80001fbe:	b7c5                	j	80001f9e <argraw+0x30>
    return p->trapframe->a5;
    80001fc0:	6d3c                	ld	a5,88(a0)
    80001fc2:	6fc8                	ld	a0,152(a5)
    80001fc4:	bfe9                	j	80001f9e <argraw+0x30>
  panic("argraw");
    80001fc6:	00006517          	auipc	a0,0x6
    80001fca:	3f250513          	addi	a0,a0,1010 # 800083b8 <states.1718+0x148>
    80001fce:	00004097          	auipc	ra,0x4
    80001fd2:	dca080e7          	jalr	-566(ra) # 80005d98 <panic>

0000000080001fd6 <fetchaddr>:
{
    80001fd6:	1101                	addi	sp,sp,-32
    80001fd8:	ec06                	sd	ra,24(sp)
    80001fda:	e822                	sd	s0,16(sp)
    80001fdc:	e426                	sd	s1,8(sp)
    80001fde:	e04a                	sd	s2,0(sp)
    80001fe0:	1000                	addi	s0,sp,32
    80001fe2:	84aa                	mv	s1,a0
    80001fe4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	f58080e7          	jalr	-168(ra) # 80000f3e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fee:	653c                	ld	a5,72(a0)
    80001ff0:	02f4f863          	bgeu	s1,a5,80002020 <fetchaddr+0x4a>
    80001ff4:	00848713          	addi	a4,s1,8
    80001ff8:	02e7e663          	bltu	a5,a4,80002024 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ffc:	46a1                	li	a3,8
    80001ffe:	8626                	mv	a2,s1
    80002000:	85ca                	mv	a1,s2
    80002002:	6928                	ld	a0,80(a0)
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	c8c080e7          	jalr	-884(ra) # 80000c90 <copyin>
    8000200c:	00a03533          	snez	a0,a0
    80002010:	40a00533          	neg	a0,a0
}
    80002014:	60e2                	ld	ra,24(sp)
    80002016:	6442                	ld	s0,16(sp)
    80002018:	64a2                	ld	s1,8(sp)
    8000201a:	6902                	ld	s2,0(sp)
    8000201c:	6105                	addi	sp,sp,32
    8000201e:	8082                	ret
    return -1;
    80002020:	557d                	li	a0,-1
    80002022:	bfcd                	j	80002014 <fetchaddr+0x3e>
    80002024:	557d                	li	a0,-1
    80002026:	b7fd                	j	80002014 <fetchaddr+0x3e>

0000000080002028 <fetchstr>:
{
    80002028:	7179                	addi	sp,sp,-48
    8000202a:	f406                	sd	ra,40(sp)
    8000202c:	f022                	sd	s0,32(sp)
    8000202e:	ec26                	sd	s1,24(sp)
    80002030:	e84a                	sd	s2,16(sp)
    80002032:	e44e                	sd	s3,8(sp)
    80002034:	1800                	addi	s0,sp,48
    80002036:	892a                	mv	s2,a0
    80002038:	84ae                	mv	s1,a1
    8000203a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	f02080e7          	jalr	-254(ra) # 80000f3e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002044:	86ce                	mv	a3,s3
    80002046:	864a                	mv	a2,s2
    80002048:	85a6                	mv	a1,s1
    8000204a:	6928                	ld	a0,80(a0)
    8000204c:	fffff097          	auipc	ra,0xfffff
    80002050:	cd0080e7          	jalr	-816(ra) # 80000d1c <copyinstr>
  if(err < 0)
    80002054:	00054763          	bltz	a0,80002062 <fetchstr+0x3a>
  return strlen(buf);
    80002058:	8526                	mv	a0,s1
    8000205a:	ffffe097          	auipc	ra,0xffffe
    8000205e:	2a2080e7          	jalr	674(ra) # 800002fc <strlen>
}
    80002062:	70a2                	ld	ra,40(sp)
    80002064:	7402                	ld	s0,32(sp)
    80002066:	64e2                	ld	s1,24(sp)
    80002068:	6942                	ld	s2,16(sp)
    8000206a:	69a2                	ld	s3,8(sp)
    8000206c:	6145                	addi	sp,sp,48
    8000206e:	8082                	ret

0000000080002070 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002070:	1101                	addi	sp,sp,-32
    80002072:	ec06                	sd	ra,24(sp)
    80002074:	e822                	sd	s0,16(sp)
    80002076:	e426                	sd	s1,8(sp)
    80002078:	1000                	addi	s0,sp,32
    8000207a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	ef2080e7          	jalr	-270(ra) # 80001f6e <argraw>
    80002084:	c088                	sw	a0,0(s1)
  return 0;
}
    80002086:	4501                	li	a0,0
    80002088:	60e2                	ld	ra,24(sp)
    8000208a:	6442                	ld	s0,16(sp)
    8000208c:	64a2                	ld	s1,8(sp)
    8000208e:	6105                	addi	sp,sp,32
    80002090:	8082                	ret

0000000080002092 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002092:	1101                	addi	sp,sp,-32
    80002094:	ec06                	sd	ra,24(sp)
    80002096:	e822                	sd	s0,16(sp)
    80002098:	e426                	sd	s1,8(sp)
    8000209a:	1000                	addi	s0,sp,32
    8000209c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	ed0080e7          	jalr	-304(ra) # 80001f6e <argraw>
    800020a6:	e088                	sd	a0,0(s1)
  return 0;
}
    800020a8:	4501                	li	a0,0
    800020aa:	60e2                	ld	ra,24(sp)
    800020ac:	6442                	ld	s0,16(sp)
    800020ae:	64a2                	ld	s1,8(sp)
    800020b0:	6105                	addi	sp,sp,32
    800020b2:	8082                	ret

00000000800020b4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020b4:	1101                	addi	sp,sp,-32
    800020b6:	ec06                	sd	ra,24(sp)
    800020b8:	e822                	sd	s0,16(sp)
    800020ba:	e426                	sd	s1,8(sp)
    800020bc:	e04a                	sd	s2,0(sp)
    800020be:	1000                	addi	s0,sp,32
    800020c0:	84ae                	mv	s1,a1
    800020c2:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020c4:	00000097          	auipc	ra,0x0
    800020c8:	eaa080e7          	jalr	-342(ra) # 80001f6e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020cc:	864a                	mv	a2,s2
    800020ce:	85a6                	mv	a1,s1
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	f58080e7          	jalr	-168(ra) # 80002028 <fetchstr>
}
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6902                	ld	s2,0(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret

00000000800020e4 <syscall>:



void
syscall(void)
{
    800020e4:	1101                	addi	sp,sp,-32
    800020e6:	ec06                	sd	ra,24(sp)
    800020e8:	e822                	sd	s0,16(sp)
    800020ea:	e426                	sd	s1,8(sp)
    800020ec:	e04a                	sd	s2,0(sp)
    800020ee:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	e4e080e7          	jalr	-434(ra) # 80000f3e <myproc>
    800020f8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020fa:	05853903          	ld	s2,88(a0)
    800020fe:	0a893783          	ld	a5,168(s2)
    80002102:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002106:	37fd                	addiw	a5,a5,-1
    80002108:	4775                	li	a4,29
    8000210a:	00f76f63          	bltu	a4,a5,80002128 <syscall+0x44>
    8000210e:	00369713          	slli	a4,a3,0x3
    80002112:	00006797          	auipc	a5,0x6
    80002116:	2e678793          	addi	a5,a5,742 # 800083f8 <syscalls>
    8000211a:	97ba                	add	a5,a5,a4
    8000211c:	639c                	ld	a5,0(a5)
    8000211e:	c789                	beqz	a5,80002128 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002120:	9782                	jalr	a5
    80002122:	06a93823          	sd	a0,112(s2)
    80002126:	a839                	j	80002144 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002128:	15848613          	addi	a2,s1,344
    8000212c:	588c                	lw	a1,48(s1)
    8000212e:	00006517          	auipc	a0,0x6
    80002132:	29250513          	addi	a0,a0,658 # 800083c0 <states.1718+0x150>
    80002136:	00004097          	auipc	ra,0x4
    8000213a:	cac080e7          	jalr	-852(ra) # 80005de2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000213e:	6cbc                	ld	a5,88(s1)
    80002140:	577d                	li	a4,-1
    80002142:	fbb8                	sd	a4,112(a5)
  }
}
    80002144:	60e2                	ld	ra,24(sp)
    80002146:	6442                	ld	s0,16(sp)
    80002148:	64a2                	ld	s1,8(sp)
    8000214a:	6902                	ld	s2,0(sp)
    8000214c:	6105                	addi	sp,sp,32
    8000214e:	8082                	ret

0000000080002150 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002150:	1101                	addi	sp,sp,-32
    80002152:	ec06                	sd	ra,24(sp)
    80002154:	e822                	sd	s0,16(sp)
    80002156:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002158:	fec40593          	addi	a1,s0,-20
    8000215c:	4501                	li	a0,0
    8000215e:	00000097          	auipc	ra,0x0
    80002162:	f12080e7          	jalr	-238(ra) # 80002070 <argint>
    return -1;
    80002166:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002168:	00054963          	bltz	a0,8000217a <sys_exit+0x2a>
  exit(n);
    8000216c:	fec42503          	lw	a0,-20(s0)
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	76c080e7          	jalr	1900(ra) # 800018dc <exit>
  return 0;  // not reached
    80002178:	4781                	li	a5,0
}
    8000217a:	853e                	mv	a0,a5
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	6105                	addi	sp,sp,32
    80002182:	8082                	ret

0000000080002184 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002184:	1141                	addi	sp,sp,-16
    80002186:	e406                	sd	ra,8(sp)
    80002188:	e022                	sd	s0,0(sp)
    8000218a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	db2080e7          	jalr	-590(ra) # 80000f3e <myproc>
}
    80002194:	5908                	lw	a0,48(a0)
    80002196:	60a2                	ld	ra,8(sp)
    80002198:	6402                	ld	s0,0(sp)
    8000219a:	0141                	addi	sp,sp,16
    8000219c:	8082                	ret

000000008000219e <sys_fork>:

uint64
sys_fork(void)
{
    8000219e:	1141                	addi	sp,sp,-16
    800021a0:	e406                	sd	ra,8(sp)
    800021a2:	e022                	sd	s0,0(sp)
    800021a4:	0800                	addi	s0,sp,16
  return fork();
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	1ec080e7          	jalr	492(ra) # 80001392 <fork>
}
    800021ae:	60a2                	ld	ra,8(sp)
    800021b0:	6402                	ld	s0,0(sp)
    800021b2:	0141                	addi	sp,sp,16
    800021b4:	8082                	ret

00000000800021b6 <sys_wait>:

uint64
sys_wait(void)
{
    800021b6:	1101                	addi	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021be:	fe840593          	addi	a1,s0,-24
    800021c2:	4501                	li	a0,0
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	ece080e7          	jalr	-306(ra) # 80002092 <argaddr>
    800021cc:	87aa                	mv	a5,a0
    return -1;
    800021ce:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021d0:	0007c863          	bltz	a5,800021e0 <sys_wait+0x2a>
  return wait(p);
    800021d4:	fe843503          	ld	a0,-24(s0)
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	50c080e7          	jalr	1292(ra) # 800016e4 <wait>
}
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret

00000000800021e8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021e8:	7179                	addi	sp,sp,-48
    800021ea:	f406                	sd	ra,40(sp)
    800021ec:	f022                	sd	s0,32(sp)
    800021ee:	ec26                	sd	s1,24(sp)
    800021f0:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021f2:	fdc40593          	addi	a1,s0,-36
    800021f6:	4501                	li	a0,0
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	e78080e7          	jalr	-392(ra) # 80002070 <argint>
    80002200:	87aa                	mv	a5,a0
    return -1;
    80002202:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002204:	0207c063          	bltz	a5,80002224 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002208:	fffff097          	auipc	ra,0xfffff
    8000220c:	d36080e7          	jalr	-714(ra) # 80000f3e <myproc>
    80002210:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002212:	fdc42503          	lw	a0,-36(s0)
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	108080e7          	jalr	264(ra) # 8000131e <growproc>
    8000221e:	00054863          	bltz	a0,8000222e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002222:	8526                	mv	a0,s1
}
    80002224:	70a2                	ld	ra,40(sp)
    80002226:	7402                	ld	s0,32(sp)
    80002228:	64e2                	ld	s1,24(sp)
    8000222a:	6145                	addi	sp,sp,48
    8000222c:	8082                	ret
    return -1;
    8000222e:	557d                	li	a0,-1
    80002230:	bfd5                	j	80002224 <sys_sbrk+0x3c>

0000000080002232 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002232:	7139                	addi	sp,sp,-64
    80002234:	fc06                	sd	ra,56(sp)
    80002236:	f822                	sd	s0,48(sp)
    80002238:	f426                	sd	s1,40(sp)
    8000223a:	f04a                	sd	s2,32(sp)
    8000223c:	ec4e                	sd	s3,24(sp)
    8000223e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002240:	fcc40593          	addi	a1,s0,-52
    80002244:	4501                	li	a0,0
    80002246:	00000097          	auipc	ra,0x0
    8000224a:	e2a080e7          	jalr	-470(ra) # 80002070 <argint>
    return -1;
    8000224e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002250:	06054563          	bltz	a0,800022ba <sys_sleep+0x88>
  acquire(&tickslock);
    80002254:	0000d517          	auipc	a0,0xd
    80002258:	e3c50513          	addi	a0,a0,-452 # 8000f090 <tickslock>
    8000225c:	00004097          	auipc	ra,0x4
    80002260:	086080e7          	jalr	134(ra) # 800062e2 <acquire>
  ticks0 = ticks;
    80002264:	00007917          	auipc	s2,0x7
    80002268:	dbc92903          	lw	s2,-580(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    8000226c:	fcc42783          	lw	a5,-52(s0)
    80002270:	cf85                	beqz	a5,800022a8 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002272:	0000d997          	auipc	s3,0xd
    80002276:	e1e98993          	addi	s3,s3,-482 # 8000f090 <tickslock>
    8000227a:	00007497          	auipc	s1,0x7
    8000227e:	da648493          	addi	s1,s1,-602 # 80009020 <ticks>
    if(myproc()->killed){
    80002282:	fffff097          	auipc	ra,0xfffff
    80002286:	cbc080e7          	jalr	-836(ra) # 80000f3e <myproc>
    8000228a:	551c                	lw	a5,40(a0)
    8000228c:	ef9d                	bnez	a5,800022ca <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000228e:	85ce                	mv	a1,s3
    80002290:	8526                	mv	a0,s1
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	3ee080e7          	jalr	1006(ra) # 80001680 <sleep>
  while(ticks - ticks0 < n){
    8000229a:	409c                	lw	a5,0(s1)
    8000229c:	412787bb          	subw	a5,a5,s2
    800022a0:	fcc42703          	lw	a4,-52(s0)
    800022a4:	fce7efe3          	bltu	a5,a4,80002282 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022a8:	0000d517          	auipc	a0,0xd
    800022ac:	de850513          	addi	a0,a0,-536 # 8000f090 <tickslock>
    800022b0:	00004097          	auipc	ra,0x4
    800022b4:	0e6080e7          	jalr	230(ra) # 80006396 <release>
  return 0;
    800022b8:	4781                	li	a5,0
}
    800022ba:	853e                	mv	a0,a5
    800022bc:	70e2                	ld	ra,56(sp)
    800022be:	7442                	ld	s0,48(sp)
    800022c0:	74a2                	ld	s1,40(sp)
    800022c2:	7902                	ld	s2,32(sp)
    800022c4:	69e2                	ld	s3,24(sp)
    800022c6:	6121                	addi	sp,sp,64
    800022c8:	8082                	ret
      release(&tickslock);
    800022ca:	0000d517          	auipc	a0,0xd
    800022ce:	dc650513          	addi	a0,a0,-570 # 8000f090 <tickslock>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	0c4080e7          	jalr	196(ra) # 80006396 <release>
      return -1;
    800022da:	57fd                	li	a5,-1
    800022dc:	bff9                	j	800022ba <sys_sleep+0x88>

00000000800022de <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    800022de:	715d                	addi	sp,sp,-80
    800022e0:	e486                	sd	ra,72(sp)
    800022e2:	e0a2                	sd	s0,64(sp)
    800022e4:	fc26                	sd	s1,56(sp)
    800022e6:	f84a                	sd	s2,48(sp)
    800022e8:	f44e                	sd	s3,40(sp)
    800022ea:	f052                	sd	s4,32(sp)
    800022ec:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
  uint64 va;
  int pagenum;
  uint64 abitsaddr;
  argaddr(0, &va);
    800022ee:	fc840593          	addi	a1,s0,-56
    800022f2:	4501                	li	a0,0
    800022f4:	00000097          	auipc	ra,0x0
    800022f8:	d9e080e7          	jalr	-610(ra) # 80002092 <argaddr>
  argint(1, &pagenum);
    800022fc:	fc440593          	addi	a1,s0,-60
    80002300:	4505                	li	a0,1
    80002302:	00000097          	auipc	ra,0x0
    80002306:	d6e080e7          	jalr	-658(ra) # 80002070 <argint>
  argaddr(2, &abitsaddr);
    8000230a:	fb840593          	addi	a1,s0,-72
    8000230e:	4509                	li	a0,2
    80002310:	00000097          	auipc	ra,0x0
    80002314:	d82080e7          	jalr	-638(ra) # 80002092 <argaddr>

  uint64 maskbits = 0;
    80002318:	fa043823          	sd	zero,-80(s0)
  struct proc *proc = myproc();
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	c22080e7          	jalr	-990(ra) # 80000f3e <myproc>
    80002324:	892a                	mv	s2,a0
  for (int i = 0; i < pagenum; i++) {
    80002326:	fc442783          	lw	a5,-60(s0)
    8000232a:	06f05463          	blez	a5,80002392 <sys_pgaccess+0xb4>
    8000232e:	4481                	li	s1,0
    pte_t *pte = walk(proc->pagetable, va+i*PGSIZE, 0);
    if (pte == 0)
      panic("page not exist.");
    if (PTE_FLAGS(*pte) & PTE_A) {
      maskbits = maskbits | (1L << i);
    80002330:	4985                	li	s3,1
    80002332:	a025                	j	8000235a <sys_pgaccess+0x7c>
      panic("page not exist.");
    80002334:	00006517          	auipc	a0,0x6
    80002338:	1bc50513          	addi	a0,a0,444 # 800084f0 <syscalls+0xf8>
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	a5c080e7          	jalr	-1444(ra) # 80005d98 <panic>
    }
    // clear PTE_A, set PTE_A bits zero
    *pte = ((*pte&PTE_A) ^ *pte) ^ 0 ;
    80002344:	611c                	ld	a5,0(a0)
    80002346:	fbf7f793          	andi	a5,a5,-65
    8000234a:	e11c                	sd	a5,0(a0)
  for (int i = 0; i < pagenum; i++) {
    8000234c:	0485                	addi	s1,s1,1
    8000234e:	fc442703          	lw	a4,-60(s0)
    80002352:	0004879b          	sext.w	a5,s1
    80002356:	02e7de63          	bge	a5,a4,80002392 <sys_pgaccess+0xb4>
    8000235a:	00048a1b          	sext.w	s4,s1
    pte_t *pte = walk(proc->pagetable, va+i*PGSIZE, 0);
    8000235e:	00c49593          	slli	a1,s1,0xc
    80002362:	4601                	li	a2,0
    80002364:	fc843783          	ld	a5,-56(s0)
    80002368:	95be                	add	a1,a1,a5
    8000236a:	05093503          	ld	a0,80(s2)
    8000236e:	ffffe097          	auipc	ra,0xffffe
    80002372:	0f2080e7          	jalr	242(ra) # 80000460 <walk>
    if (pte == 0)
    80002376:	dd5d                	beqz	a0,80002334 <sys_pgaccess+0x56>
    if (PTE_FLAGS(*pte) & PTE_A) {
    80002378:	611c                	ld	a5,0(a0)
    8000237a:	0407f793          	andi	a5,a5,64
    8000237e:	d3f9                	beqz	a5,80002344 <sys_pgaccess+0x66>
      maskbits = maskbits | (1L << i);
    80002380:	01499a33          	sll	s4,s3,s4
    80002384:	fb043783          	ld	a5,-80(s0)
    80002388:	0147ea33          	or	s4,a5,s4
    8000238c:	fb443823          	sd	s4,-80(s0)
    80002390:	bf55                	j	80002344 <sys_pgaccess+0x66>
  }
  if (copyout(proc->pagetable, abitsaddr, (char *)&maskbits, sizeof(maskbits)) < 0)
    80002392:	46a1                	li	a3,8
    80002394:	fb040613          	addi	a2,s0,-80
    80002398:	fb843583          	ld	a1,-72(s0)
    8000239c:	05093503          	ld	a0,80(s2)
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	864080e7          	jalr	-1948(ra) # 80000c04 <copyout>
    800023a8:	00054b63          	bltz	a0,800023be <sys_pgaccess+0xe0>
    panic("sys_pgacess copyout error");

  return 0;
}
    800023ac:	4501                	li	a0,0
    800023ae:	60a6                	ld	ra,72(sp)
    800023b0:	6406                	ld	s0,64(sp)
    800023b2:	74e2                	ld	s1,56(sp)
    800023b4:	7942                	ld	s2,48(sp)
    800023b6:	79a2                	ld	s3,40(sp)
    800023b8:	7a02                	ld	s4,32(sp)
    800023ba:	6161                	addi	sp,sp,80
    800023bc:	8082                	ret
    panic("sys_pgacess copyout error");
    800023be:	00006517          	auipc	a0,0x6
    800023c2:	14250513          	addi	a0,a0,322 # 80008500 <syscalls+0x108>
    800023c6:	00004097          	auipc	ra,0x4
    800023ca:	9d2080e7          	jalr	-1582(ra) # 80005d98 <panic>

00000000800023ce <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800023ce:	1101                	addi	sp,sp,-32
    800023d0:	ec06                	sd	ra,24(sp)
    800023d2:	e822                	sd	s0,16(sp)
    800023d4:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023d6:	fec40593          	addi	a1,s0,-20
    800023da:	4501                	li	a0,0
    800023dc:	00000097          	auipc	ra,0x0
    800023e0:	c94080e7          	jalr	-876(ra) # 80002070 <argint>
    800023e4:	87aa                	mv	a5,a0
    return -1;
    800023e6:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023e8:	0007c863          	bltz	a5,800023f8 <sys_kill+0x2a>
  return kill(pid);
    800023ec:	fec42503          	lw	a0,-20(s0)
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	5c2080e7          	jalr	1474(ra) # 800019b2 <kill>
}
    800023f8:	60e2                	ld	ra,24(sp)
    800023fa:	6442                	ld	s0,16(sp)
    800023fc:	6105                	addi	sp,sp,32
    800023fe:	8082                	ret

0000000080002400 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002400:	1101                	addi	sp,sp,-32
    80002402:	ec06                	sd	ra,24(sp)
    80002404:	e822                	sd	s0,16(sp)
    80002406:	e426                	sd	s1,8(sp)
    80002408:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000240a:	0000d517          	auipc	a0,0xd
    8000240e:	c8650513          	addi	a0,a0,-890 # 8000f090 <tickslock>
    80002412:	00004097          	auipc	ra,0x4
    80002416:	ed0080e7          	jalr	-304(ra) # 800062e2 <acquire>
  xticks = ticks;
    8000241a:	00007497          	auipc	s1,0x7
    8000241e:	c064a483          	lw	s1,-1018(s1) # 80009020 <ticks>
  release(&tickslock);
    80002422:	0000d517          	auipc	a0,0xd
    80002426:	c6e50513          	addi	a0,a0,-914 # 8000f090 <tickslock>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	f6c080e7          	jalr	-148(ra) # 80006396 <release>
  return xticks;
}
    80002432:	02049513          	slli	a0,s1,0x20
    80002436:	9101                	srli	a0,a0,0x20
    80002438:	60e2                	ld	ra,24(sp)
    8000243a:	6442                	ld	s0,16(sp)
    8000243c:	64a2                	ld	s1,8(sp)
    8000243e:	6105                	addi	sp,sp,32
    80002440:	8082                	ret

0000000080002442 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002442:	7179                	addi	sp,sp,-48
    80002444:	f406                	sd	ra,40(sp)
    80002446:	f022                	sd	s0,32(sp)
    80002448:	ec26                	sd	s1,24(sp)
    8000244a:	e84a                	sd	s2,16(sp)
    8000244c:	e44e                	sd	s3,8(sp)
    8000244e:	e052                	sd	s4,0(sp)
    80002450:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002452:	00006597          	auipc	a1,0x6
    80002456:	0ce58593          	addi	a1,a1,206 # 80008520 <syscalls+0x128>
    8000245a:	0000d517          	auipc	a0,0xd
    8000245e:	c4e50513          	addi	a0,a0,-946 # 8000f0a8 <bcache>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	df0080e7          	jalr	-528(ra) # 80006252 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000246a:	00015797          	auipc	a5,0x15
    8000246e:	c3e78793          	addi	a5,a5,-962 # 800170a8 <bcache+0x8000>
    80002472:	00015717          	auipc	a4,0x15
    80002476:	e9e70713          	addi	a4,a4,-354 # 80017310 <bcache+0x8268>
    8000247a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000247e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002482:	0000d497          	auipc	s1,0xd
    80002486:	c3e48493          	addi	s1,s1,-962 # 8000f0c0 <bcache+0x18>
    b->next = bcache.head.next;
    8000248a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000248c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000248e:	00006a17          	auipc	s4,0x6
    80002492:	09aa0a13          	addi	s4,s4,154 # 80008528 <syscalls+0x130>
    b->next = bcache.head.next;
    80002496:	2b893783          	ld	a5,696(s2)
    8000249a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000249c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024a0:	85d2                	mv	a1,s4
    800024a2:	01048513          	addi	a0,s1,16
    800024a6:	00001097          	auipc	ra,0x1
    800024aa:	4bc080e7          	jalr	1212(ra) # 80003962 <initsleeplock>
    bcache.head.next->prev = b;
    800024ae:	2b893783          	ld	a5,696(s2)
    800024b2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024b4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024b8:	45848493          	addi	s1,s1,1112
    800024bc:	fd349de3          	bne	s1,s3,80002496 <binit+0x54>
  }
}
    800024c0:	70a2                	ld	ra,40(sp)
    800024c2:	7402                	ld	s0,32(sp)
    800024c4:	64e2                	ld	s1,24(sp)
    800024c6:	6942                	ld	s2,16(sp)
    800024c8:	69a2                	ld	s3,8(sp)
    800024ca:	6a02                	ld	s4,0(sp)
    800024cc:	6145                	addi	sp,sp,48
    800024ce:	8082                	ret

00000000800024d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024d0:	7179                	addi	sp,sp,-48
    800024d2:	f406                	sd	ra,40(sp)
    800024d4:	f022                	sd	s0,32(sp)
    800024d6:	ec26                	sd	s1,24(sp)
    800024d8:	e84a                	sd	s2,16(sp)
    800024da:	e44e                	sd	s3,8(sp)
    800024dc:	1800                	addi	s0,sp,48
    800024de:	89aa                	mv	s3,a0
    800024e0:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024e2:	0000d517          	auipc	a0,0xd
    800024e6:	bc650513          	addi	a0,a0,-1082 # 8000f0a8 <bcache>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	df8080e7          	jalr	-520(ra) # 800062e2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024f2:	00015497          	auipc	s1,0x15
    800024f6:	e6e4b483          	ld	s1,-402(s1) # 80017360 <bcache+0x82b8>
    800024fa:	00015797          	auipc	a5,0x15
    800024fe:	e1678793          	addi	a5,a5,-490 # 80017310 <bcache+0x8268>
    80002502:	02f48f63          	beq	s1,a5,80002540 <bread+0x70>
    80002506:	873e                	mv	a4,a5
    80002508:	a021                	j	80002510 <bread+0x40>
    8000250a:	68a4                	ld	s1,80(s1)
    8000250c:	02e48a63          	beq	s1,a4,80002540 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002510:	449c                	lw	a5,8(s1)
    80002512:	ff379ce3          	bne	a5,s3,8000250a <bread+0x3a>
    80002516:	44dc                	lw	a5,12(s1)
    80002518:	ff2799e3          	bne	a5,s2,8000250a <bread+0x3a>
      b->refcnt++;
    8000251c:	40bc                	lw	a5,64(s1)
    8000251e:	2785                	addiw	a5,a5,1
    80002520:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002522:	0000d517          	auipc	a0,0xd
    80002526:	b8650513          	addi	a0,a0,-1146 # 8000f0a8 <bcache>
    8000252a:	00004097          	auipc	ra,0x4
    8000252e:	e6c080e7          	jalr	-404(ra) # 80006396 <release>
      acquiresleep(&b->lock);
    80002532:	01048513          	addi	a0,s1,16
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	466080e7          	jalr	1126(ra) # 8000399c <acquiresleep>
      return b;
    8000253e:	a8b9                	j	8000259c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002540:	00015497          	auipc	s1,0x15
    80002544:	e184b483          	ld	s1,-488(s1) # 80017358 <bcache+0x82b0>
    80002548:	00015797          	auipc	a5,0x15
    8000254c:	dc878793          	addi	a5,a5,-568 # 80017310 <bcache+0x8268>
    80002550:	00f48863          	beq	s1,a5,80002560 <bread+0x90>
    80002554:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002556:	40bc                	lw	a5,64(s1)
    80002558:	cf81                	beqz	a5,80002570 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000255a:	64a4                	ld	s1,72(s1)
    8000255c:	fee49de3          	bne	s1,a4,80002556 <bread+0x86>
  panic("bget: no buffers");
    80002560:	00006517          	auipc	a0,0x6
    80002564:	fd050513          	addi	a0,a0,-48 # 80008530 <syscalls+0x138>
    80002568:	00004097          	auipc	ra,0x4
    8000256c:	830080e7          	jalr	-2000(ra) # 80005d98 <panic>
      b->dev = dev;
    80002570:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002574:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002578:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000257c:	4785                	li	a5,1
    8000257e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002580:	0000d517          	auipc	a0,0xd
    80002584:	b2850513          	addi	a0,a0,-1240 # 8000f0a8 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	e0e080e7          	jalr	-498(ra) # 80006396 <release>
      acquiresleep(&b->lock);
    80002590:	01048513          	addi	a0,s1,16
    80002594:	00001097          	auipc	ra,0x1
    80002598:	408080e7          	jalr	1032(ra) # 8000399c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000259c:	409c                	lw	a5,0(s1)
    8000259e:	cb89                	beqz	a5,800025b0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025a0:	8526                	mv	a0,s1
    800025a2:	70a2                	ld	ra,40(sp)
    800025a4:	7402                	ld	s0,32(sp)
    800025a6:	64e2                	ld	s1,24(sp)
    800025a8:	6942                	ld	s2,16(sp)
    800025aa:	69a2                	ld	s3,8(sp)
    800025ac:	6145                	addi	sp,sp,48
    800025ae:	8082                	ret
    virtio_disk_rw(b, 0);
    800025b0:	4581                	li	a1,0
    800025b2:	8526                	mv	a0,s1
    800025b4:	00003097          	auipc	ra,0x3
    800025b8:	f22080e7          	jalr	-222(ra) # 800054d6 <virtio_disk_rw>
    b->valid = 1;
    800025bc:	4785                	li	a5,1
    800025be:	c09c                	sw	a5,0(s1)
  return b;
    800025c0:	b7c5                	j	800025a0 <bread+0xd0>

00000000800025c2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025c2:	1101                	addi	sp,sp,-32
    800025c4:	ec06                	sd	ra,24(sp)
    800025c6:	e822                	sd	s0,16(sp)
    800025c8:	e426                	sd	s1,8(sp)
    800025ca:	1000                	addi	s0,sp,32
    800025cc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025ce:	0541                	addi	a0,a0,16
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	466080e7          	jalr	1126(ra) # 80003a36 <holdingsleep>
    800025d8:	cd01                	beqz	a0,800025f0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025da:	4585                	li	a1,1
    800025dc:	8526                	mv	a0,s1
    800025de:	00003097          	auipc	ra,0x3
    800025e2:	ef8080e7          	jalr	-264(ra) # 800054d6 <virtio_disk_rw>
}
    800025e6:	60e2                	ld	ra,24(sp)
    800025e8:	6442                	ld	s0,16(sp)
    800025ea:	64a2                	ld	s1,8(sp)
    800025ec:	6105                	addi	sp,sp,32
    800025ee:	8082                	ret
    panic("bwrite");
    800025f0:	00006517          	auipc	a0,0x6
    800025f4:	f5850513          	addi	a0,a0,-168 # 80008548 <syscalls+0x150>
    800025f8:	00003097          	auipc	ra,0x3
    800025fc:	7a0080e7          	jalr	1952(ra) # 80005d98 <panic>

0000000080002600 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	e04a                	sd	s2,0(sp)
    8000260a:	1000                	addi	s0,sp,32
    8000260c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000260e:	01050913          	addi	s2,a0,16
    80002612:	854a                	mv	a0,s2
    80002614:	00001097          	auipc	ra,0x1
    80002618:	422080e7          	jalr	1058(ra) # 80003a36 <holdingsleep>
    8000261c:	c92d                	beqz	a0,8000268e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000261e:	854a                	mv	a0,s2
    80002620:	00001097          	auipc	ra,0x1
    80002624:	3d2080e7          	jalr	978(ra) # 800039f2 <releasesleep>

  acquire(&bcache.lock);
    80002628:	0000d517          	auipc	a0,0xd
    8000262c:	a8050513          	addi	a0,a0,-1408 # 8000f0a8 <bcache>
    80002630:	00004097          	auipc	ra,0x4
    80002634:	cb2080e7          	jalr	-846(ra) # 800062e2 <acquire>
  b->refcnt--;
    80002638:	40bc                	lw	a5,64(s1)
    8000263a:	37fd                	addiw	a5,a5,-1
    8000263c:	0007871b          	sext.w	a4,a5
    80002640:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002642:	eb05                	bnez	a4,80002672 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002644:	68bc                	ld	a5,80(s1)
    80002646:	64b8                	ld	a4,72(s1)
    80002648:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000264a:	64bc                	ld	a5,72(s1)
    8000264c:	68b8                	ld	a4,80(s1)
    8000264e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002650:	00015797          	auipc	a5,0x15
    80002654:	a5878793          	addi	a5,a5,-1448 # 800170a8 <bcache+0x8000>
    80002658:	2b87b703          	ld	a4,696(a5)
    8000265c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000265e:	00015717          	auipc	a4,0x15
    80002662:	cb270713          	addi	a4,a4,-846 # 80017310 <bcache+0x8268>
    80002666:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002668:	2b87b703          	ld	a4,696(a5)
    8000266c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000266e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002672:	0000d517          	auipc	a0,0xd
    80002676:	a3650513          	addi	a0,a0,-1482 # 8000f0a8 <bcache>
    8000267a:	00004097          	auipc	ra,0x4
    8000267e:	d1c080e7          	jalr	-740(ra) # 80006396 <release>
}
    80002682:	60e2                	ld	ra,24(sp)
    80002684:	6442                	ld	s0,16(sp)
    80002686:	64a2                	ld	s1,8(sp)
    80002688:	6902                	ld	s2,0(sp)
    8000268a:	6105                	addi	sp,sp,32
    8000268c:	8082                	ret
    panic("brelse");
    8000268e:	00006517          	auipc	a0,0x6
    80002692:	ec250513          	addi	a0,a0,-318 # 80008550 <syscalls+0x158>
    80002696:	00003097          	auipc	ra,0x3
    8000269a:	702080e7          	jalr	1794(ra) # 80005d98 <panic>

000000008000269e <bpin>:

void
bpin(struct buf *b) {
    8000269e:	1101                	addi	sp,sp,-32
    800026a0:	ec06                	sd	ra,24(sp)
    800026a2:	e822                	sd	s0,16(sp)
    800026a4:	e426                	sd	s1,8(sp)
    800026a6:	1000                	addi	s0,sp,32
    800026a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026aa:	0000d517          	auipc	a0,0xd
    800026ae:	9fe50513          	addi	a0,a0,-1538 # 8000f0a8 <bcache>
    800026b2:	00004097          	auipc	ra,0x4
    800026b6:	c30080e7          	jalr	-976(ra) # 800062e2 <acquire>
  b->refcnt++;
    800026ba:	40bc                	lw	a5,64(s1)
    800026bc:	2785                	addiw	a5,a5,1
    800026be:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026c0:	0000d517          	auipc	a0,0xd
    800026c4:	9e850513          	addi	a0,a0,-1560 # 8000f0a8 <bcache>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	cce080e7          	jalr	-818(ra) # 80006396 <release>
}
    800026d0:	60e2                	ld	ra,24(sp)
    800026d2:	6442                	ld	s0,16(sp)
    800026d4:	64a2                	ld	s1,8(sp)
    800026d6:	6105                	addi	sp,sp,32
    800026d8:	8082                	ret

00000000800026da <bunpin>:

void
bunpin(struct buf *b) {
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e6:	0000d517          	auipc	a0,0xd
    800026ea:	9c250513          	addi	a0,a0,-1598 # 8000f0a8 <bcache>
    800026ee:	00004097          	auipc	ra,0x4
    800026f2:	bf4080e7          	jalr	-1036(ra) # 800062e2 <acquire>
  b->refcnt--;
    800026f6:	40bc                	lw	a5,64(s1)
    800026f8:	37fd                	addiw	a5,a5,-1
    800026fa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026fc:	0000d517          	auipc	a0,0xd
    80002700:	9ac50513          	addi	a0,a0,-1620 # 8000f0a8 <bcache>
    80002704:	00004097          	auipc	ra,0x4
    80002708:	c92080e7          	jalr	-878(ra) # 80006396 <release>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6105                	addi	sp,sp,32
    80002714:	8082                	ret

0000000080002716 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002716:	1101                	addi	sp,sp,-32
    80002718:	ec06                	sd	ra,24(sp)
    8000271a:	e822                	sd	s0,16(sp)
    8000271c:	e426                	sd	s1,8(sp)
    8000271e:	e04a                	sd	s2,0(sp)
    80002720:	1000                	addi	s0,sp,32
    80002722:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002724:	00d5d59b          	srliw	a1,a1,0xd
    80002728:	00015797          	auipc	a5,0x15
    8000272c:	05c7a783          	lw	a5,92(a5) # 80017784 <sb+0x1c>
    80002730:	9dbd                	addw	a1,a1,a5
    80002732:	00000097          	auipc	ra,0x0
    80002736:	d9e080e7          	jalr	-610(ra) # 800024d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000273a:	0074f713          	andi	a4,s1,7
    8000273e:	4785                	li	a5,1
    80002740:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002744:	14ce                	slli	s1,s1,0x33
    80002746:	90d9                	srli	s1,s1,0x36
    80002748:	00950733          	add	a4,a0,s1
    8000274c:	05874703          	lbu	a4,88(a4)
    80002750:	00e7f6b3          	and	a3,a5,a4
    80002754:	c69d                	beqz	a3,80002782 <bfree+0x6c>
    80002756:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002758:	94aa                	add	s1,s1,a0
    8000275a:	fff7c793          	not	a5,a5
    8000275e:	8ff9                	and	a5,a5,a4
    80002760:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002764:	00001097          	auipc	ra,0x1
    80002768:	118080e7          	jalr	280(ra) # 8000387c <log_write>
  brelse(bp);
    8000276c:	854a                	mv	a0,s2
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	e92080e7          	jalr	-366(ra) # 80002600 <brelse>
}
    80002776:	60e2                	ld	ra,24(sp)
    80002778:	6442                	ld	s0,16(sp)
    8000277a:	64a2                	ld	s1,8(sp)
    8000277c:	6902                	ld	s2,0(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret
    panic("freeing free block");
    80002782:	00006517          	auipc	a0,0x6
    80002786:	dd650513          	addi	a0,a0,-554 # 80008558 <syscalls+0x160>
    8000278a:	00003097          	auipc	ra,0x3
    8000278e:	60e080e7          	jalr	1550(ra) # 80005d98 <panic>

0000000080002792 <balloc>:
{
    80002792:	711d                	addi	sp,sp,-96
    80002794:	ec86                	sd	ra,88(sp)
    80002796:	e8a2                	sd	s0,80(sp)
    80002798:	e4a6                	sd	s1,72(sp)
    8000279a:	e0ca                	sd	s2,64(sp)
    8000279c:	fc4e                	sd	s3,56(sp)
    8000279e:	f852                	sd	s4,48(sp)
    800027a0:	f456                	sd	s5,40(sp)
    800027a2:	f05a                	sd	s6,32(sp)
    800027a4:	ec5e                	sd	s7,24(sp)
    800027a6:	e862                	sd	s8,16(sp)
    800027a8:	e466                	sd	s9,8(sp)
    800027aa:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027ac:	00015797          	auipc	a5,0x15
    800027b0:	fc07a783          	lw	a5,-64(a5) # 8001776c <sb+0x4>
    800027b4:	cbd1                	beqz	a5,80002848 <balloc+0xb6>
    800027b6:	8baa                	mv	s7,a0
    800027b8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027ba:	00015b17          	auipc	s6,0x15
    800027be:	faeb0b13          	addi	s6,s6,-82 # 80017768 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027c4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027c8:	6c89                	lui	s9,0x2
    800027ca:	a831                	j	800027e6 <balloc+0x54>
    brelse(bp);
    800027cc:	854a                	mv	a0,s2
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	e32080e7          	jalr	-462(ra) # 80002600 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027d6:	015c87bb          	addw	a5,s9,s5
    800027da:	00078a9b          	sext.w	s5,a5
    800027de:	004b2703          	lw	a4,4(s6)
    800027e2:	06eaf363          	bgeu	s5,a4,80002848 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027e6:	41fad79b          	sraiw	a5,s5,0x1f
    800027ea:	0137d79b          	srliw	a5,a5,0x13
    800027ee:	015787bb          	addw	a5,a5,s5
    800027f2:	40d7d79b          	sraiw	a5,a5,0xd
    800027f6:	01cb2583          	lw	a1,28(s6)
    800027fa:	9dbd                	addw	a1,a1,a5
    800027fc:	855e                	mv	a0,s7
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	cd2080e7          	jalr	-814(ra) # 800024d0 <bread>
    80002806:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002808:	004b2503          	lw	a0,4(s6)
    8000280c:	000a849b          	sext.w	s1,s5
    80002810:	8662                	mv	a2,s8
    80002812:	faa4fde3          	bgeu	s1,a0,800027cc <balloc+0x3a>
      m = 1 << (bi % 8);
    80002816:	41f6579b          	sraiw	a5,a2,0x1f
    8000281a:	01d7d69b          	srliw	a3,a5,0x1d
    8000281e:	00c6873b          	addw	a4,a3,a2
    80002822:	00777793          	andi	a5,a4,7
    80002826:	9f95                	subw	a5,a5,a3
    80002828:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000282c:	4037571b          	sraiw	a4,a4,0x3
    80002830:	00e906b3          	add	a3,s2,a4
    80002834:	0586c683          	lbu	a3,88(a3)
    80002838:	00d7f5b3          	and	a1,a5,a3
    8000283c:	cd91                	beqz	a1,80002858 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000283e:	2605                	addiw	a2,a2,1
    80002840:	2485                	addiw	s1,s1,1
    80002842:	fd4618e3          	bne	a2,s4,80002812 <balloc+0x80>
    80002846:	b759                	j	800027cc <balloc+0x3a>
  panic("balloc: out of blocks");
    80002848:	00006517          	auipc	a0,0x6
    8000284c:	d2850513          	addi	a0,a0,-728 # 80008570 <syscalls+0x178>
    80002850:	00003097          	auipc	ra,0x3
    80002854:	548080e7          	jalr	1352(ra) # 80005d98 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002858:	974a                	add	a4,a4,s2
    8000285a:	8fd5                	or	a5,a5,a3
    8000285c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002860:	854a                	mv	a0,s2
    80002862:	00001097          	auipc	ra,0x1
    80002866:	01a080e7          	jalr	26(ra) # 8000387c <log_write>
        brelse(bp);
    8000286a:	854a                	mv	a0,s2
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	d94080e7          	jalr	-620(ra) # 80002600 <brelse>
  bp = bread(dev, bno);
    80002874:	85a6                	mv	a1,s1
    80002876:	855e                	mv	a0,s7
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	c58080e7          	jalr	-936(ra) # 800024d0 <bread>
    80002880:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002882:	40000613          	li	a2,1024
    80002886:	4581                	li	a1,0
    80002888:	05850513          	addi	a0,a0,88
    8000288c:	ffffe097          	auipc	ra,0xffffe
    80002890:	8ec080e7          	jalr	-1812(ra) # 80000178 <memset>
  log_write(bp);
    80002894:	854a                	mv	a0,s2
    80002896:	00001097          	auipc	ra,0x1
    8000289a:	fe6080e7          	jalr	-26(ra) # 8000387c <log_write>
  brelse(bp);
    8000289e:	854a                	mv	a0,s2
    800028a0:	00000097          	auipc	ra,0x0
    800028a4:	d60080e7          	jalr	-672(ra) # 80002600 <brelse>
}
    800028a8:	8526                	mv	a0,s1
    800028aa:	60e6                	ld	ra,88(sp)
    800028ac:	6446                	ld	s0,80(sp)
    800028ae:	64a6                	ld	s1,72(sp)
    800028b0:	6906                	ld	s2,64(sp)
    800028b2:	79e2                	ld	s3,56(sp)
    800028b4:	7a42                	ld	s4,48(sp)
    800028b6:	7aa2                	ld	s5,40(sp)
    800028b8:	7b02                	ld	s6,32(sp)
    800028ba:	6be2                	ld	s7,24(sp)
    800028bc:	6c42                	ld	s8,16(sp)
    800028be:	6ca2                	ld	s9,8(sp)
    800028c0:	6125                	addi	sp,sp,96
    800028c2:	8082                	ret

00000000800028c4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028c4:	7179                	addi	sp,sp,-48
    800028c6:	f406                	sd	ra,40(sp)
    800028c8:	f022                	sd	s0,32(sp)
    800028ca:	ec26                	sd	s1,24(sp)
    800028cc:	e84a                	sd	s2,16(sp)
    800028ce:	e44e                	sd	s3,8(sp)
    800028d0:	e052                	sd	s4,0(sp)
    800028d2:	1800                	addi	s0,sp,48
    800028d4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028d6:	47ad                	li	a5,11
    800028d8:	04b7fe63          	bgeu	a5,a1,80002934 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028dc:	ff45849b          	addiw	s1,a1,-12
    800028e0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028e4:	0ff00793          	li	a5,255
    800028e8:	0ae7e363          	bltu	a5,a4,8000298e <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028ec:	08052583          	lw	a1,128(a0)
    800028f0:	c5ad                	beqz	a1,8000295a <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028f2:	00092503          	lw	a0,0(s2)
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	bda080e7          	jalr	-1062(ra) # 800024d0 <bread>
    800028fe:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002900:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002904:	02049593          	slli	a1,s1,0x20
    80002908:	9181                	srli	a1,a1,0x20
    8000290a:	058a                	slli	a1,a1,0x2
    8000290c:	00b784b3          	add	s1,a5,a1
    80002910:	0004a983          	lw	s3,0(s1)
    80002914:	04098d63          	beqz	s3,8000296e <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002918:	8552                	mv	a0,s4
    8000291a:	00000097          	auipc	ra,0x0
    8000291e:	ce6080e7          	jalr	-794(ra) # 80002600 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002922:	854e                	mv	a0,s3
    80002924:	70a2                	ld	ra,40(sp)
    80002926:	7402                	ld	s0,32(sp)
    80002928:	64e2                	ld	s1,24(sp)
    8000292a:	6942                	ld	s2,16(sp)
    8000292c:	69a2                	ld	s3,8(sp)
    8000292e:	6a02                	ld	s4,0(sp)
    80002930:	6145                	addi	sp,sp,48
    80002932:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002934:	02059493          	slli	s1,a1,0x20
    80002938:	9081                	srli	s1,s1,0x20
    8000293a:	048a                	slli	s1,s1,0x2
    8000293c:	94aa                	add	s1,s1,a0
    8000293e:	0504a983          	lw	s3,80(s1)
    80002942:	fe0990e3          	bnez	s3,80002922 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002946:	4108                	lw	a0,0(a0)
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	e4a080e7          	jalr	-438(ra) # 80002792 <balloc>
    80002950:	0005099b          	sext.w	s3,a0
    80002954:	0534a823          	sw	s3,80(s1)
    80002958:	b7e9                	j	80002922 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000295a:	4108                	lw	a0,0(a0)
    8000295c:	00000097          	auipc	ra,0x0
    80002960:	e36080e7          	jalr	-458(ra) # 80002792 <balloc>
    80002964:	0005059b          	sext.w	a1,a0
    80002968:	08b92023          	sw	a1,128(s2)
    8000296c:	b759                	j	800028f2 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000296e:	00092503          	lw	a0,0(s2)
    80002972:	00000097          	auipc	ra,0x0
    80002976:	e20080e7          	jalr	-480(ra) # 80002792 <balloc>
    8000297a:	0005099b          	sext.w	s3,a0
    8000297e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002982:	8552                	mv	a0,s4
    80002984:	00001097          	auipc	ra,0x1
    80002988:	ef8080e7          	jalr	-264(ra) # 8000387c <log_write>
    8000298c:	b771                	j	80002918 <bmap+0x54>
  panic("bmap: out of range");
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	bfa50513          	addi	a0,a0,-1030 # 80008588 <syscalls+0x190>
    80002996:	00003097          	auipc	ra,0x3
    8000299a:	402080e7          	jalr	1026(ra) # 80005d98 <panic>

000000008000299e <iget>:
{
    8000299e:	7179                	addi	sp,sp,-48
    800029a0:	f406                	sd	ra,40(sp)
    800029a2:	f022                	sd	s0,32(sp)
    800029a4:	ec26                	sd	s1,24(sp)
    800029a6:	e84a                	sd	s2,16(sp)
    800029a8:	e44e                	sd	s3,8(sp)
    800029aa:	e052                	sd	s4,0(sp)
    800029ac:	1800                	addi	s0,sp,48
    800029ae:	89aa                	mv	s3,a0
    800029b0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029b2:	00015517          	auipc	a0,0x15
    800029b6:	dd650513          	addi	a0,a0,-554 # 80017788 <itable>
    800029ba:	00004097          	auipc	ra,0x4
    800029be:	928080e7          	jalr	-1752(ra) # 800062e2 <acquire>
  empty = 0;
    800029c2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029c4:	00015497          	auipc	s1,0x15
    800029c8:	ddc48493          	addi	s1,s1,-548 # 800177a0 <itable+0x18>
    800029cc:	00017697          	auipc	a3,0x17
    800029d0:	86468693          	addi	a3,a3,-1948 # 80019230 <log>
    800029d4:	a039                	j	800029e2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029d6:	02090b63          	beqz	s2,80002a0c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029da:	08848493          	addi	s1,s1,136
    800029de:	02d48a63          	beq	s1,a3,80002a12 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029e2:	449c                	lw	a5,8(s1)
    800029e4:	fef059e3          	blez	a5,800029d6 <iget+0x38>
    800029e8:	4098                	lw	a4,0(s1)
    800029ea:	ff3716e3          	bne	a4,s3,800029d6 <iget+0x38>
    800029ee:	40d8                	lw	a4,4(s1)
    800029f0:	ff4713e3          	bne	a4,s4,800029d6 <iget+0x38>
      ip->ref++;
    800029f4:	2785                	addiw	a5,a5,1
    800029f6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029f8:	00015517          	auipc	a0,0x15
    800029fc:	d9050513          	addi	a0,a0,-624 # 80017788 <itable>
    80002a00:	00004097          	auipc	ra,0x4
    80002a04:	996080e7          	jalr	-1642(ra) # 80006396 <release>
      return ip;
    80002a08:	8926                	mv	s2,s1
    80002a0a:	a03d                	j	80002a38 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0c:	f7f9                	bnez	a5,800029da <iget+0x3c>
    80002a0e:	8926                	mv	s2,s1
    80002a10:	b7e9                	j	800029da <iget+0x3c>
  if(empty == 0)
    80002a12:	02090c63          	beqz	s2,80002a4a <iget+0xac>
  ip->dev = dev;
    80002a16:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a1a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a1e:	4785                	li	a5,1
    80002a20:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a24:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a28:	00015517          	auipc	a0,0x15
    80002a2c:	d6050513          	addi	a0,a0,-672 # 80017788 <itable>
    80002a30:	00004097          	auipc	ra,0x4
    80002a34:	966080e7          	jalr	-1690(ra) # 80006396 <release>
}
    80002a38:	854a                	mv	a0,s2
    80002a3a:	70a2                	ld	ra,40(sp)
    80002a3c:	7402                	ld	s0,32(sp)
    80002a3e:	64e2                	ld	s1,24(sp)
    80002a40:	6942                	ld	s2,16(sp)
    80002a42:	69a2                	ld	s3,8(sp)
    80002a44:	6a02                	ld	s4,0(sp)
    80002a46:	6145                	addi	sp,sp,48
    80002a48:	8082                	ret
    panic("iget: no inodes");
    80002a4a:	00006517          	auipc	a0,0x6
    80002a4e:	b5650513          	addi	a0,a0,-1194 # 800085a0 <syscalls+0x1a8>
    80002a52:	00003097          	auipc	ra,0x3
    80002a56:	346080e7          	jalr	838(ra) # 80005d98 <panic>

0000000080002a5a <fsinit>:
fsinit(int dev) {
    80002a5a:	7179                	addi	sp,sp,-48
    80002a5c:	f406                	sd	ra,40(sp)
    80002a5e:	f022                	sd	s0,32(sp)
    80002a60:	ec26                	sd	s1,24(sp)
    80002a62:	e84a                	sd	s2,16(sp)
    80002a64:	e44e                	sd	s3,8(sp)
    80002a66:	1800                	addi	s0,sp,48
    80002a68:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a6a:	4585                	li	a1,1
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	a64080e7          	jalr	-1436(ra) # 800024d0 <bread>
    80002a74:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a76:	00015997          	auipc	s3,0x15
    80002a7a:	cf298993          	addi	s3,s3,-782 # 80017768 <sb>
    80002a7e:	02000613          	li	a2,32
    80002a82:	05850593          	addi	a1,a0,88
    80002a86:	854e                	mv	a0,s3
    80002a88:	ffffd097          	auipc	ra,0xffffd
    80002a8c:	750080e7          	jalr	1872(ra) # 800001d8 <memmove>
  brelse(bp);
    80002a90:	8526                	mv	a0,s1
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	b6e080e7          	jalr	-1170(ra) # 80002600 <brelse>
  if(sb.magic != FSMAGIC)
    80002a9a:	0009a703          	lw	a4,0(s3)
    80002a9e:	102037b7          	lui	a5,0x10203
    80002aa2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002aa6:	02f71263          	bne	a4,a5,80002aca <fsinit+0x70>
  initlog(dev, &sb);
    80002aaa:	00015597          	auipc	a1,0x15
    80002aae:	cbe58593          	addi	a1,a1,-834 # 80017768 <sb>
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	00001097          	auipc	ra,0x1
    80002ab8:	b4c080e7          	jalr	-1204(ra) # 80003600 <initlog>
}
    80002abc:	70a2                	ld	ra,40(sp)
    80002abe:	7402                	ld	s0,32(sp)
    80002ac0:	64e2                	ld	s1,24(sp)
    80002ac2:	6942                	ld	s2,16(sp)
    80002ac4:	69a2                	ld	s3,8(sp)
    80002ac6:	6145                	addi	sp,sp,48
    80002ac8:	8082                	ret
    panic("invalid file system");
    80002aca:	00006517          	auipc	a0,0x6
    80002ace:	ae650513          	addi	a0,a0,-1306 # 800085b0 <syscalls+0x1b8>
    80002ad2:	00003097          	auipc	ra,0x3
    80002ad6:	2c6080e7          	jalr	710(ra) # 80005d98 <panic>

0000000080002ada <iinit>:
{
    80002ada:	7179                	addi	sp,sp,-48
    80002adc:	f406                	sd	ra,40(sp)
    80002ade:	f022                	sd	s0,32(sp)
    80002ae0:	ec26                	sd	s1,24(sp)
    80002ae2:	e84a                	sd	s2,16(sp)
    80002ae4:	e44e                	sd	s3,8(sp)
    80002ae6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002ae8:	00006597          	auipc	a1,0x6
    80002aec:	ae058593          	addi	a1,a1,-1312 # 800085c8 <syscalls+0x1d0>
    80002af0:	00015517          	auipc	a0,0x15
    80002af4:	c9850513          	addi	a0,a0,-872 # 80017788 <itable>
    80002af8:	00003097          	auipc	ra,0x3
    80002afc:	75a080e7          	jalr	1882(ra) # 80006252 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b00:	00015497          	auipc	s1,0x15
    80002b04:	cb048493          	addi	s1,s1,-848 # 800177b0 <itable+0x28>
    80002b08:	00016997          	auipc	s3,0x16
    80002b0c:	73898993          	addi	s3,s3,1848 # 80019240 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b10:	00006917          	auipc	s2,0x6
    80002b14:	ac090913          	addi	s2,s2,-1344 # 800085d0 <syscalls+0x1d8>
    80002b18:	85ca                	mv	a1,s2
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	00001097          	auipc	ra,0x1
    80002b20:	e46080e7          	jalr	-442(ra) # 80003962 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b24:	08848493          	addi	s1,s1,136
    80002b28:	ff3498e3          	bne	s1,s3,80002b18 <iinit+0x3e>
}
    80002b2c:	70a2                	ld	ra,40(sp)
    80002b2e:	7402                	ld	s0,32(sp)
    80002b30:	64e2                	ld	s1,24(sp)
    80002b32:	6942                	ld	s2,16(sp)
    80002b34:	69a2                	ld	s3,8(sp)
    80002b36:	6145                	addi	sp,sp,48
    80002b38:	8082                	ret

0000000080002b3a <ialloc>:
{
    80002b3a:	715d                	addi	sp,sp,-80
    80002b3c:	e486                	sd	ra,72(sp)
    80002b3e:	e0a2                	sd	s0,64(sp)
    80002b40:	fc26                	sd	s1,56(sp)
    80002b42:	f84a                	sd	s2,48(sp)
    80002b44:	f44e                	sd	s3,40(sp)
    80002b46:	f052                	sd	s4,32(sp)
    80002b48:	ec56                	sd	s5,24(sp)
    80002b4a:	e85a                	sd	s6,16(sp)
    80002b4c:	e45e                	sd	s7,8(sp)
    80002b4e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b50:	00015717          	auipc	a4,0x15
    80002b54:	c2472703          	lw	a4,-988(a4) # 80017774 <sb+0xc>
    80002b58:	4785                	li	a5,1
    80002b5a:	04e7fa63          	bgeu	a5,a4,80002bae <ialloc+0x74>
    80002b5e:	8aaa                	mv	s5,a0
    80002b60:	8bae                	mv	s7,a1
    80002b62:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b64:	00015a17          	auipc	s4,0x15
    80002b68:	c04a0a13          	addi	s4,s4,-1020 # 80017768 <sb>
    80002b6c:	00048b1b          	sext.w	s6,s1
    80002b70:	0044d593          	srli	a1,s1,0x4
    80002b74:	018a2783          	lw	a5,24(s4)
    80002b78:	9dbd                	addw	a1,a1,a5
    80002b7a:	8556                	mv	a0,s5
    80002b7c:	00000097          	auipc	ra,0x0
    80002b80:	954080e7          	jalr	-1708(ra) # 800024d0 <bread>
    80002b84:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b86:	05850993          	addi	s3,a0,88
    80002b8a:	00f4f793          	andi	a5,s1,15
    80002b8e:	079a                	slli	a5,a5,0x6
    80002b90:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b92:	00099783          	lh	a5,0(s3)
    80002b96:	c785                	beqz	a5,80002bbe <ialloc+0x84>
    brelse(bp);
    80002b98:	00000097          	auipc	ra,0x0
    80002b9c:	a68080e7          	jalr	-1432(ra) # 80002600 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba0:	0485                	addi	s1,s1,1
    80002ba2:	00ca2703          	lw	a4,12(s4)
    80002ba6:	0004879b          	sext.w	a5,s1
    80002baa:	fce7e1e3          	bltu	a5,a4,80002b6c <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bae:	00006517          	auipc	a0,0x6
    80002bb2:	a2a50513          	addi	a0,a0,-1494 # 800085d8 <syscalls+0x1e0>
    80002bb6:	00003097          	auipc	ra,0x3
    80002bba:	1e2080e7          	jalr	482(ra) # 80005d98 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bbe:	04000613          	li	a2,64
    80002bc2:	4581                	li	a1,0
    80002bc4:	854e                	mv	a0,s3
    80002bc6:	ffffd097          	auipc	ra,0xffffd
    80002bca:	5b2080e7          	jalr	1458(ra) # 80000178 <memset>
      dip->type = type;
    80002bce:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	00001097          	auipc	ra,0x1
    80002bd8:	ca8080e7          	jalr	-856(ra) # 8000387c <log_write>
      brelse(bp);
    80002bdc:	854a                	mv	a0,s2
    80002bde:	00000097          	auipc	ra,0x0
    80002be2:	a22080e7          	jalr	-1502(ra) # 80002600 <brelse>
      return iget(dev, inum);
    80002be6:	85da                	mv	a1,s6
    80002be8:	8556                	mv	a0,s5
    80002bea:	00000097          	auipc	ra,0x0
    80002bee:	db4080e7          	jalr	-588(ra) # 8000299e <iget>
}
    80002bf2:	60a6                	ld	ra,72(sp)
    80002bf4:	6406                	ld	s0,64(sp)
    80002bf6:	74e2                	ld	s1,56(sp)
    80002bf8:	7942                	ld	s2,48(sp)
    80002bfa:	79a2                	ld	s3,40(sp)
    80002bfc:	7a02                	ld	s4,32(sp)
    80002bfe:	6ae2                	ld	s5,24(sp)
    80002c00:	6b42                	ld	s6,16(sp)
    80002c02:	6ba2                	ld	s7,8(sp)
    80002c04:	6161                	addi	sp,sp,80
    80002c06:	8082                	ret

0000000080002c08 <iupdate>:
{
    80002c08:	1101                	addi	sp,sp,-32
    80002c0a:	ec06                	sd	ra,24(sp)
    80002c0c:	e822                	sd	s0,16(sp)
    80002c0e:	e426                	sd	s1,8(sp)
    80002c10:	e04a                	sd	s2,0(sp)
    80002c12:	1000                	addi	s0,sp,32
    80002c14:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c16:	415c                	lw	a5,4(a0)
    80002c18:	0047d79b          	srliw	a5,a5,0x4
    80002c1c:	00015597          	auipc	a1,0x15
    80002c20:	b645a583          	lw	a1,-1180(a1) # 80017780 <sb+0x18>
    80002c24:	9dbd                	addw	a1,a1,a5
    80002c26:	4108                	lw	a0,0(a0)
    80002c28:	00000097          	auipc	ra,0x0
    80002c2c:	8a8080e7          	jalr	-1880(ra) # 800024d0 <bread>
    80002c30:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c32:	05850793          	addi	a5,a0,88
    80002c36:	40c8                	lw	a0,4(s1)
    80002c38:	893d                	andi	a0,a0,15
    80002c3a:	051a                	slli	a0,a0,0x6
    80002c3c:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c3e:	04449703          	lh	a4,68(s1)
    80002c42:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c46:	04649703          	lh	a4,70(s1)
    80002c4a:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c4e:	04849703          	lh	a4,72(s1)
    80002c52:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c56:	04a49703          	lh	a4,74(s1)
    80002c5a:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c5e:	44f8                	lw	a4,76(s1)
    80002c60:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c62:	03400613          	li	a2,52
    80002c66:	05048593          	addi	a1,s1,80
    80002c6a:	0531                	addi	a0,a0,12
    80002c6c:	ffffd097          	auipc	ra,0xffffd
    80002c70:	56c080e7          	jalr	1388(ra) # 800001d8 <memmove>
  log_write(bp);
    80002c74:	854a                	mv	a0,s2
    80002c76:	00001097          	auipc	ra,0x1
    80002c7a:	c06080e7          	jalr	-1018(ra) # 8000387c <log_write>
  brelse(bp);
    80002c7e:	854a                	mv	a0,s2
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	980080e7          	jalr	-1664(ra) # 80002600 <brelse>
}
    80002c88:	60e2                	ld	ra,24(sp)
    80002c8a:	6442                	ld	s0,16(sp)
    80002c8c:	64a2                	ld	s1,8(sp)
    80002c8e:	6902                	ld	s2,0(sp)
    80002c90:	6105                	addi	sp,sp,32
    80002c92:	8082                	ret

0000000080002c94 <idup>:
{
    80002c94:	1101                	addi	sp,sp,-32
    80002c96:	ec06                	sd	ra,24(sp)
    80002c98:	e822                	sd	s0,16(sp)
    80002c9a:	e426                	sd	s1,8(sp)
    80002c9c:	1000                	addi	s0,sp,32
    80002c9e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca0:	00015517          	auipc	a0,0x15
    80002ca4:	ae850513          	addi	a0,a0,-1304 # 80017788 <itable>
    80002ca8:	00003097          	auipc	ra,0x3
    80002cac:	63a080e7          	jalr	1594(ra) # 800062e2 <acquire>
  ip->ref++;
    80002cb0:	449c                	lw	a5,8(s1)
    80002cb2:	2785                	addiw	a5,a5,1
    80002cb4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cb6:	00015517          	auipc	a0,0x15
    80002cba:	ad250513          	addi	a0,a0,-1326 # 80017788 <itable>
    80002cbe:	00003097          	auipc	ra,0x3
    80002cc2:	6d8080e7          	jalr	1752(ra) # 80006396 <release>
}
    80002cc6:	8526                	mv	a0,s1
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6105                	addi	sp,sp,32
    80002cd0:	8082                	ret

0000000080002cd2 <ilock>:
{
    80002cd2:	1101                	addi	sp,sp,-32
    80002cd4:	ec06                	sd	ra,24(sp)
    80002cd6:	e822                	sd	s0,16(sp)
    80002cd8:	e426                	sd	s1,8(sp)
    80002cda:	e04a                	sd	s2,0(sp)
    80002cdc:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cde:	c115                	beqz	a0,80002d02 <ilock+0x30>
    80002ce0:	84aa                	mv	s1,a0
    80002ce2:	451c                	lw	a5,8(a0)
    80002ce4:	00f05f63          	blez	a5,80002d02 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ce8:	0541                	addi	a0,a0,16
    80002cea:	00001097          	auipc	ra,0x1
    80002cee:	cb2080e7          	jalr	-846(ra) # 8000399c <acquiresleep>
  if(ip->valid == 0){
    80002cf2:	40bc                	lw	a5,64(s1)
    80002cf4:	cf99                	beqz	a5,80002d12 <ilock+0x40>
}
    80002cf6:	60e2                	ld	ra,24(sp)
    80002cf8:	6442                	ld	s0,16(sp)
    80002cfa:	64a2                	ld	s1,8(sp)
    80002cfc:	6902                	ld	s2,0(sp)
    80002cfe:	6105                	addi	sp,sp,32
    80002d00:	8082                	ret
    panic("ilock");
    80002d02:	00006517          	auipc	a0,0x6
    80002d06:	8ee50513          	addi	a0,a0,-1810 # 800085f0 <syscalls+0x1f8>
    80002d0a:	00003097          	auipc	ra,0x3
    80002d0e:	08e080e7          	jalr	142(ra) # 80005d98 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d12:	40dc                	lw	a5,4(s1)
    80002d14:	0047d79b          	srliw	a5,a5,0x4
    80002d18:	00015597          	auipc	a1,0x15
    80002d1c:	a685a583          	lw	a1,-1432(a1) # 80017780 <sb+0x18>
    80002d20:	9dbd                	addw	a1,a1,a5
    80002d22:	4088                	lw	a0,0(s1)
    80002d24:	fffff097          	auipc	ra,0xfffff
    80002d28:	7ac080e7          	jalr	1964(ra) # 800024d0 <bread>
    80002d2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d2e:	05850593          	addi	a1,a0,88
    80002d32:	40dc                	lw	a5,4(s1)
    80002d34:	8bbd                	andi	a5,a5,15
    80002d36:	079a                	slli	a5,a5,0x6
    80002d38:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d3a:	00059783          	lh	a5,0(a1)
    80002d3e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d42:	00259783          	lh	a5,2(a1)
    80002d46:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d4a:	00459783          	lh	a5,4(a1)
    80002d4e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d52:	00659783          	lh	a5,6(a1)
    80002d56:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d5a:	459c                	lw	a5,8(a1)
    80002d5c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d5e:	03400613          	li	a2,52
    80002d62:	05b1                	addi	a1,a1,12
    80002d64:	05048513          	addi	a0,s1,80
    80002d68:	ffffd097          	auipc	ra,0xffffd
    80002d6c:	470080e7          	jalr	1136(ra) # 800001d8 <memmove>
    brelse(bp);
    80002d70:	854a                	mv	a0,s2
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	88e080e7          	jalr	-1906(ra) # 80002600 <brelse>
    ip->valid = 1;
    80002d7a:	4785                	li	a5,1
    80002d7c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d7e:	04449783          	lh	a5,68(s1)
    80002d82:	fbb5                	bnez	a5,80002cf6 <ilock+0x24>
      panic("ilock: no type");
    80002d84:	00006517          	auipc	a0,0x6
    80002d88:	87450513          	addi	a0,a0,-1932 # 800085f8 <syscalls+0x200>
    80002d8c:	00003097          	auipc	ra,0x3
    80002d90:	00c080e7          	jalr	12(ra) # 80005d98 <panic>

0000000080002d94 <iunlock>:
{
    80002d94:	1101                	addi	sp,sp,-32
    80002d96:	ec06                	sd	ra,24(sp)
    80002d98:	e822                	sd	s0,16(sp)
    80002d9a:	e426                	sd	s1,8(sp)
    80002d9c:	e04a                	sd	s2,0(sp)
    80002d9e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002da0:	c905                	beqz	a0,80002dd0 <iunlock+0x3c>
    80002da2:	84aa                	mv	s1,a0
    80002da4:	01050913          	addi	s2,a0,16
    80002da8:	854a                	mv	a0,s2
    80002daa:	00001097          	auipc	ra,0x1
    80002dae:	c8c080e7          	jalr	-884(ra) # 80003a36 <holdingsleep>
    80002db2:	cd19                	beqz	a0,80002dd0 <iunlock+0x3c>
    80002db4:	449c                	lw	a5,8(s1)
    80002db6:	00f05d63          	blez	a5,80002dd0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dba:	854a                	mv	a0,s2
    80002dbc:	00001097          	auipc	ra,0x1
    80002dc0:	c36080e7          	jalr	-970(ra) # 800039f2 <releasesleep>
}
    80002dc4:	60e2                	ld	ra,24(sp)
    80002dc6:	6442                	ld	s0,16(sp)
    80002dc8:	64a2                	ld	s1,8(sp)
    80002dca:	6902                	ld	s2,0(sp)
    80002dcc:	6105                	addi	sp,sp,32
    80002dce:	8082                	ret
    panic("iunlock");
    80002dd0:	00006517          	auipc	a0,0x6
    80002dd4:	83850513          	addi	a0,a0,-1992 # 80008608 <syscalls+0x210>
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	fc0080e7          	jalr	-64(ra) # 80005d98 <panic>

0000000080002de0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002de0:	7179                	addi	sp,sp,-48
    80002de2:	f406                	sd	ra,40(sp)
    80002de4:	f022                	sd	s0,32(sp)
    80002de6:	ec26                	sd	s1,24(sp)
    80002de8:	e84a                	sd	s2,16(sp)
    80002dea:	e44e                	sd	s3,8(sp)
    80002dec:	e052                	sd	s4,0(sp)
    80002dee:	1800                	addi	s0,sp,48
    80002df0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002df2:	05050493          	addi	s1,a0,80
    80002df6:	08050913          	addi	s2,a0,128
    80002dfa:	a021                	j	80002e02 <itrunc+0x22>
    80002dfc:	0491                	addi	s1,s1,4
    80002dfe:	01248d63          	beq	s1,s2,80002e18 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e02:	408c                	lw	a1,0(s1)
    80002e04:	dde5                	beqz	a1,80002dfc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e06:	0009a503          	lw	a0,0(s3)
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	90c080e7          	jalr	-1780(ra) # 80002716 <bfree>
      ip->addrs[i] = 0;
    80002e12:	0004a023          	sw	zero,0(s1)
    80002e16:	b7dd                	j	80002dfc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e18:	0809a583          	lw	a1,128(s3)
    80002e1c:	e185                	bnez	a1,80002e3c <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e1e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e22:	854e                	mv	a0,s3
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	de4080e7          	jalr	-540(ra) # 80002c08 <iupdate>
}
    80002e2c:	70a2                	ld	ra,40(sp)
    80002e2e:	7402                	ld	s0,32(sp)
    80002e30:	64e2                	ld	s1,24(sp)
    80002e32:	6942                	ld	s2,16(sp)
    80002e34:	69a2                	ld	s3,8(sp)
    80002e36:	6a02                	ld	s4,0(sp)
    80002e38:	6145                	addi	sp,sp,48
    80002e3a:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e3c:	0009a503          	lw	a0,0(s3)
    80002e40:	fffff097          	auipc	ra,0xfffff
    80002e44:	690080e7          	jalr	1680(ra) # 800024d0 <bread>
    80002e48:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e4a:	05850493          	addi	s1,a0,88
    80002e4e:	45850913          	addi	s2,a0,1112
    80002e52:	a811                	j	80002e66 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e54:	0009a503          	lw	a0,0(s3)
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	8be080e7          	jalr	-1858(ra) # 80002716 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e60:	0491                	addi	s1,s1,4
    80002e62:	01248563          	beq	s1,s2,80002e6c <itrunc+0x8c>
      if(a[j])
    80002e66:	408c                	lw	a1,0(s1)
    80002e68:	dde5                	beqz	a1,80002e60 <itrunc+0x80>
    80002e6a:	b7ed                	j	80002e54 <itrunc+0x74>
    brelse(bp);
    80002e6c:	8552                	mv	a0,s4
    80002e6e:	fffff097          	auipc	ra,0xfffff
    80002e72:	792080e7          	jalr	1938(ra) # 80002600 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e76:	0809a583          	lw	a1,128(s3)
    80002e7a:	0009a503          	lw	a0,0(s3)
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	898080e7          	jalr	-1896(ra) # 80002716 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e86:	0809a023          	sw	zero,128(s3)
    80002e8a:	bf51                	j	80002e1e <itrunc+0x3e>

0000000080002e8c <iput>:
{
    80002e8c:	1101                	addi	sp,sp,-32
    80002e8e:	ec06                	sd	ra,24(sp)
    80002e90:	e822                	sd	s0,16(sp)
    80002e92:	e426                	sd	s1,8(sp)
    80002e94:	e04a                	sd	s2,0(sp)
    80002e96:	1000                	addi	s0,sp,32
    80002e98:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e9a:	00015517          	auipc	a0,0x15
    80002e9e:	8ee50513          	addi	a0,a0,-1810 # 80017788 <itable>
    80002ea2:	00003097          	auipc	ra,0x3
    80002ea6:	440080e7          	jalr	1088(ra) # 800062e2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eaa:	4498                	lw	a4,8(s1)
    80002eac:	4785                	li	a5,1
    80002eae:	02f70363          	beq	a4,a5,80002ed4 <iput+0x48>
  ip->ref--;
    80002eb2:	449c                	lw	a5,8(s1)
    80002eb4:	37fd                	addiw	a5,a5,-1
    80002eb6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eb8:	00015517          	auipc	a0,0x15
    80002ebc:	8d050513          	addi	a0,a0,-1840 # 80017788 <itable>
    80002ec0:	00003097          	auipc	ra,0x3
    80002ec4:	4d6080e7          	jalr	1238(ra) # 80006396 <release>
}
    80002ec8:	60e2                	ld	ra,24(sp)
    80002eca:	6442                	ld	s0,16(sp)
    80002ecc:	64a2                	ld	s1,8(sp)
    80002ece:	6902                	ld	s2,0(sp)
    80002ed0:	6105                	addi	sp,sp,32
    80002ed2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ed4:	40bc                	lw	a5,64(s1)
    80002ed6:	dff1                	beqz	a5,80002eb2 <iput+0x26>
    80002ed8:	04a49783          	lh	a5,74(s1)
    80002edc:	fbf9                	bnez	a5,80002eb2 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ede:	01048913          	addi	s2,s1,16
    80002ee2:	854a                	mv	a0,s2
    80002ee4:	00001097          	auipc	ra,0x1
    80002ee8:	ab8080e7          	jalr	-1352(ra) # 8000399c <acquiresleep>
    release(&itable.lock);
    80002eec:	00015517          	auipc	a0,0x15
    80002ef0:	89c50513          	addi	a0,a0,-1892 # 80017788 <itable>
    80002ef4:	00003097          	auipc	ra,0x3
    80002ef8:	4a2080e7          	jalr	1186(ra) # 80006396 <release>
    itrunc(ip);
    80002efc:	8526                	mv	a0,s1
    80002efe:	00000097          	auipc	ra,0x0
    80002f02:	ee2080e7          	jalr	-286(ra) # 80002de0 <itrunc>
    ip->type = 0;
    80002f06:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f0a:	8526                	mv	a0,s1
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	cfc080e7          	jalr	-772(ra) # 80002c08 <iupdate>
    ip->valid = 0;
    80002f14:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f18:	854a                	mv	a0,s2
    80002f1a:	00001097          	auipc	ra,0x1
    80002f1e:	ad8080e7          	jalr	-1320(ra) # 800039f2 <releasesleep>
    acquire(&itable.lock);
    80002f22:	00015517          	auipc	a0,0x15
    80002f26:	86650513          	addi	a0,a0,-1946 # 80017788 <itable>
    80002f2a:	00003097          	auipc	ra,0x3
    80002f2e:	3b8080e7          	jalr	952(ra) # 800062e2 <acquire>
    80002f32:	b741                	j	80002eb2 <iput+0x26>

0000000080002f34 <iunlockput>:
{
    80002f34:	1101                	addi	sp,sp,-32
    80002f36:	ec06                	sd	ra,24(sp)
    80002f38:	e822                	sd	s0,16(sp)
    80002f3a:	e426                	sd	s1,8(sp)
    80002f3c:	1000                	addi	s0,sp,32
    80002f3e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f40:	00000097          	auipc	ra,0x0
    80002f44:	e54080e7          	jalr	-428(ra) # 80002d94 <iunlock>
  iput(ip);
    80002f48:	8526                	mv	a0,s1
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	f42080e7          	jalr	-190(ra) # 80002e8c <iput>
}
    80002f52:	60e2                	ld	ra,24(sp)
    80002f54:	6442                	ld	s0,16(sp)
    80002f56:	64a2                	ld	s1,8(sp)
    80002f58:	6105                	addi	sp,sp,32
    80002f5a:	8082                	ret

0000000080002f5c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f5c:	1141                	addi	sp,sp,-16
    80002f5e:	e422                	sd	s0,8(sp)
    80002f60:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f62:	411c                	lw	a5,0(a0)
    80002f64:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f66:	415c                	lw	a5,4(a0)
    80002f68:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f6a:	04451783          	lh	a5,68(a0)
    80002f6e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f72:	04a51783          	lh	a5,74(a0)
    80002f76:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f7a:	04c56783          	lwu	a5,76(a0)
    80002f7e:	e99c                	sd	a5,16(a1)
}
    80002f80:	6422                	ld	s0,8(sp)
    80002f82:	0141                	addi	sp,sp,16
    80002f84:	8082                	ret

0000000080002f86 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f86:	457c                	lw	a5,76(a0)
    80002f88:	0ed7e963          	bltu	a5,a3,8000307a <readi+0xf4>
{
    80002f8c:	7159                	addi	sp,sp,-112
    80002f8e:	f486                	sd	ra,104(sp)
    80002f90:	f0a2                	sd	s0,96(sp)
    80002f92:	eca6                	sd	s1,88(sp)
    80002f94:	e8ca                	sd	s2,80(sp)
    80002f96:	e4ce                	sd	s3,72(sp)
    80002f98:	e0d2                	sd	s4,64(sp)
    80002f9a:	fc56                	sd	s5,56(sp)
    80002f9c:	f85a                	sd	s6,48(sp)
    80002f9e:	f45e                	sd	s7,40(sp)
    80002fa0:	f062                	sd	s8,32(sp)
    80002fa2:	ec66                	sd	s9,24(sp)
    80002fa4:	e86a                	sd	s10,16(sp)
    80002fa6:	e46e                	sd	s11,8(sp)
    80002fa8:	1880                	addi	s0,sp,112
    80002faa:	8baa                	mv	s7,a0
    80002fac:	8c2e                	mv	s8,a1
    80002fae:	8ab2                	mv	s5,a2
    80002fb0:	84b6                	mv	s1,a3
    80002fb2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fb4:	9f35                	addw	a4,a4,a3
    return 0;
    80002fb6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fb8:	0ad76063          	bltu	a4,a3,80003058 <readi+0xd2>
  if(off + n > ip->size)
    80002fbc:	00e7f463          	bgeu	a5,a4,80002fc4 <readi+0x3e>
    n = ip->size - off;
    80002fc0:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc4:	0a0b0963          	beqz	s6,80003076 <readi+0xf0>
    80002fc8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fca:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fce:	5cfd                	li	s9,-1
    80002fd0:	a82d                	j	8000300a <readi+0x84>
    80002fd2:	020a1d93          	slli	s11,s4,0x20
    80002fd6:	020ddd93          	srli	s11,s11,0x20
    80002fda:	05890613          	addi	a2,s2,88
    80002fde:	86ee                	mv	a3,s11
    80002fe0:	963a                	add	a2,a2,a4
    80002fe2:	85d6                	mv	a1,s5
    80002fe4:	8562                	mv	a0,s8
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	a3e080e7          	jalr	-1474(ra) # 80001a24 <either_copyout>
    80002fee:	05950d63          	beq	a0,s9,80003048 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ff2:	854a                	mv	a0,s2
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	60c080e7          	jalr	1548(ra) # 80002600 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ffc:	013a09bb          	addw	s3,s4,s3
    80003000:	009a04bb          	addw	s1,s4,s1
    80003004:	9aee                	add	s5,s5,s11
    80003006:	0569f763          	bgeu	s3,s6,80003054 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000300a:	000ba903          	lw	s2,0(s7)
    8000300e:	00a4d59b          	srliw	a1,s1,0xa
    80003012:	855e                	mv	a0,s7
    80003014:	00000097          	auipc	ra,0x0
    80003018:	8b0080e7          	jalr	-1872(ra) # 800028c4 <bmap>
    8000301c:	0005059b          	sext.w	a1,a0
    80003020:	854a                	mv	a0,s2
    80003022:	fffff097          	auipc	ra,0xfffff
    80003026:	4ae080e7          	jalr	1198(ra) # 800024d0 <bread>
    8000302a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302c:	3ff4f713          	andi	a4,s1,1023
    80003030:	40ed07bb          	subw	a5,s10,a4
    80003034:	413b06bb          	subw	a3,s6,s3
    80003038:	8a3e                	mv	s4,a5
    8000303a:	2781                	sext.w	a5,a5
    8000303c:	0006861b          	sext.w	a2,a3
    80003040:	f8f679e3          	bgeu	a2,a5,80002fd2 <readi+0x4c>
    80003044:	8a36                	mv	s4,a3
    80003046:	b771                	j	80002fd2 <readi+0x4c>
      brelse(bp);
    80003048:	854a                	mv	a0,s2
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	5b6080e7          	jalr	1462(ra) # 80002600 <brelse>
      tot = -1;
    80003052:	59fd                	li	s3,-1
  }
  return tot;
    80003054:	0009851b          	sext.w	a0,s3
}
    80003058:	70a6                	ld	ra,104(sp)
    8000305a:	7406                	ld	s0,96(sp)
    8000305c:	64e6                	ld	s1,88(sp)
    8000305e:	6946                	ld	s2,80(sp)
    80003060:	69a6                	ld	s3,72(sp)
    80003062:	6a06                	ld	s4,64(sp)
    80003064:	7ae2                	ld	s5,56(sp)
    80003066:	7b42                	ld	s6,48(sp)
    80003068:	7ba2                	ld	s7,40(sp)
    8000306a:	7c02                	ld	s8,32(sp)
    8000306c:	6ce2                	ld	s9,24(sp)
    8000306e:	6d42                	ld	s10,16(sp)
    80003070:	6da2                	ld	s11,8(sp)
    80003072:	6165                	addi	sp,sp,112
    80003074:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003076:	89da                	mv	s3,s6
    80003078:	bff1                	j	80003054 <readi+0xce>
    return 0;
    8000307a:	4501                	li	a0,0
}
    8000307c:	8082                	ret

000000008000307e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000307e:	457c                	lw	a5,76(a0)
    80003080:	10d7e863          	bltu	a5,a3,80003190 <writei+0x112>
{
    80003084:	7159                	addi	sp,sp,-112
    80003086:	f486                	sd	ra,104(sp)
    80003088:	f0a2                	sd	s0,96(sp)
    8000308a:	eca6                	sd	s1,88(sp)
    8000308c:	e8ca                	sd	s2,80(sp)
    8000308e:	e4ce                	sd	s3,72(sp)
    80003090:	e0d2                	sd	s4,64(sp)
    80003092:	fc56                	sd	s5,56(sp)
    80003094:	f85a                	sd	s6,48(sp)
    80003096:	f45e                	sd	s7,40(sp)
    80003098:	f062                	sd	s8,32(sp)
    8000309a:	ec66                	sd	s9,24(sp)
    8000309c:	e86a                	sd	s10,16(sp)
    8000309e:	e46e                	sd	s11,8(sp)
    800030a0:	1880                	addi	s0,sp,112
    800030a2:	8b2a                	mv	s6,a0
    800030a4:	8c2e                	mv	s8,a1
    800030a6:	8ab2                	mv	s5,a2
    800030a8:	8936                	mv	s2,a3
    800030aa:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030ac:	00e687bb          	addw	a5,a3,a4
    800030b0:	0ed7e263          	bltu	a5,a3,80003194 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030b4:	00043737          	lui	a4,0x43
    800030b8:	0ef76063          	bltu	a4,a5,80003198 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030bc:	0c0b8863          	beqz	s7,8000318c <writei+0x10e>
    800030c0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030c6:	5cfd                	li	s9,-1
    800030c8:	a091                	j	8000310c <writei+0x8e>
    800030ca:	02099d93          	slli	s11,s3,0x20
    800030ce:	020ddd93          	srli	s11,s11,0x20
    800030d2:	05848513          	addi	a0,s1,88
    800030d6:	86ee                	mv	a3,s11
    800030d8:	8656                	mv	a2,s5
    800030da:	85e2                	mv	a1,s8
    800030dc:	953a                	add	a0,a0,a4
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	99c080e7          	jalr	-1636(ra) # 80001a7a <either_copyin>
    800030e6:	07950263          	beq	a0,s9,8000314a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ea:	8526                	mv	a0,s1
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	790080e7          	jalr	1936(ra) # 8000387c <log_write>
    brelse(bp);
    800030f4:	8526                	mv	a0,s1
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	50a080e7          	jalr	1290(ra) # 80002600 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030fe:	01498a3b          	addw	s4,s3,s4
    80003102:	0129893b          	addw	s2,s3,s2
    80003106:	9aee                	add	s5,s5,s11
    80003108:	057a7663          	bgeu	s4,s7,80003154 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000310c:	000b2483          	lw	s1,0(s6)
    80003110:	00a9559b          	srliw	a1,s2,0xa
    80003114:	855a                	mv	a0,s6
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	7ae080e7          	jalr	1966(ra) # 800028c4 <bmap>
    8000311e:	0005059b          	sext.w	a1,a0
    80003122:	8526                	mv	a0,s1
    80003124:	fffff097          	auipc	ra,0xfffff
    80003128:	3ac080e7          	jalr	940(ra) # 800024d0 <bread>
    8000312c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000312e:	3ff97713          	andi	a4,s2,1023
    80003132:	40ed07bb          	subw	a5,s10,a4
    80003136:	414b86bb          	subw	a3,s7,s4
    8000313a:	89be                	mv	s3,a5
    8000313c:	2781                	sext.w	a5,a5
    8000313e:	0006861b          	sext.w	a2,a3
    80003142:	f8f674e3          	bgeu	a2,a5,800030ca <writei+0x4c>
    80003146:	89b6                	mv	s3,a3
    80003148:	b749                	j	800030ca <writei+0x4c>
      brelse(bp);
    8000314a:	8526                	mv	a0,s1
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	4b4080e7          	jalr	1204(ra) # 80002600 <brelse>
  }

  if(off > ip->size)
    80003154:	04cb2783          	lw	a5,76(s6)
    80003158:	0127f463          	bgeu	a5,s2,80003160 <writei+0xe2>
    ip->size = off;
    8000315c:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003160:	855a                	mv	a0,s6
    80003162:	00000097          	auipc	ra,0x0
    80003166:	aa6080e7          	jalr	-1370(ra) # 80002c08 <iupdate>

  return tot;
    8000316a:	000a051b          	sext.w	a0,s4
}
    8000316e:	70a6                	ld	ra,104(sp)
    80003170:	7406                	ld	s0,96(sp)
    80003172:	64e6                	ld	s1,88(sp)
    80003174:	6946                	ld	s2,80(sp)
    80003176:	69a6                	ld	s3,72(sp)
    80003178:	6a06                	ld	s4,64(sp)
    8000317a:	7ae2                	ld	s5,56(sp)
    8000317c:	7b42                	ld	s6,48(sp)
    8000317e:	7ba2                	ld	s7,40(sp)
    80003180:	7c02                	ld	s8,32(sp)
    80003182:	6ce2                	ld	s9,24(sp)
    80003184:	6d42                	ld	s10,16(sp)
    80003186:	6da2                	ld	s11,8(sp)
    80003188:	6165                	addi	sp,sp,112
    8000318a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318c:	8a5e                	mv	s4,s7
    8000318e:	bfc9                	j	80003160 <writei+0xe2>
    return -1;
    80003190:	557d                	li	a0,-1
}
    80003192:	8082                	ret
    return -1;
    80003194:	557d                	li	a0,-1
    80003196:	bfe1                	j	8000316e <writei+0xf0>
    return -1;
    80003198:	557d                	li	a0,-1
    8000319a:	bfd1                	j	8000316e <writei+0xf0>

000000008000319c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000319c:	1141                	addi	sp,sp,-16
    8000319e:	e406                	sd	ra,8(sp)
    800031a0:	e022                	sd	s0,0(sp)
    800031a2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031a4:	4639                	li	a2,14
    800031a6:	ffffd097          	auipc	ra,0xffffd
    800031aa:	0aa080e7          	jalr	170(ra) # 80000250 <strncmp>
}
    800031ae:	60a2                	ld	ra,8(sp)
    800031b0:	6402                	ld	s0,0(sp)
    800031b2:	0141                	addi	sp,sp,16
    800031b4:	8082                	ret

00000000800031b6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031b6:	7139                	addi	sp,sp,-64
    800031b8:	fc06                	sd	ra,56(sp)
    800031ba:	f822                	sd	s0,48(sp)
    800031bc:	f426                	sd	s1,40(sp)
    800031be:	f04a                	sd	s2,32(sp)
    800031c0:	ec4e                	sd	s3,24(sp)
    800031c2:	e852                	sd	s4,16(sp)
    800031c4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031c6:	04451703          	lh	a4,68(a0)
    800031ca:	4785                	li	a5,1
    800031cc:	00f71a63          	bne	a4,a5,800031e0 <dirlookup+0x2a>
    800031d0:	892a                	mv	s2,a0
    800031d2:	89ae                	mv	s3,a1
    800031d4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031d6:	457c                	lw	a5,76(a0)
    800031d8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031da:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031dc:	e79d                	bnez	a5,8000320a <dirlookup+0x54>
    800031de:	a8a5                	j	80003256 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031e0:	00005517          	auipc	a0,0x5
    800031e4:	43050513          	addi	a0,a0,1072 # 80008610 <syscalls+0x218>
    800031e8:	00003097          	auipc	ra,0x3
    800031ec:	bb0080e7          	jalr	-1104(ra) # 80005d98 <panic>
      panic("dirlookup read");
    800031f0:	00005517          	auipc	a0,0x5
    800031f4:	43850513          	addi	a0,a0,1080 # 80008628 <syscalls+0x230>
    800031f8:	00003097          	auipc	ra,0x3
    800031fc:	ba0080e7          	jalr	-1120(ra) # 80005d98 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003200:	24c1                	addiw	s1,s1,16
    80003202:	04c92783          	lw	a5,76(s2)
    80003206:	04f4f763          	bgeu	s1,a5,80003254 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000320a:	4741                	li	a4,16
    8000320c:	86a6                	mv	a3,s1
    8000320e:	fc040613          	addi	a2,s0,-64
    80003212:	4581                	li	a1,0
    80003214:	854a                	mv	a0,s2
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	d70080e7          	jalr	-656(ra) # 80002f86 <readi>
    8000321e:	47c1                	li	a5,16
    80003220:	fcf518e3          	bne	a0,a5,800031f0 <dirlookup+0x3a>
    if(de.inum == 0)
    80003224:	fc045783          	lhu	a5,-64(s0)
    80003228:	dfe1                	beqz	a5,80003200 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000322a:	fc240593          	addi	a1,s0,-62
    8000322e:	854e                	mv	a0,s3
    80003230:	00000097          	auipc	ra,0x0
    80003234:	f6c080e7          	jalr	-148(ra) # 8000319c <namecmp>
    80003238:	f561                	bnez	a0,80003200 <dirlookup+0x4a>
      if(poff)
    8000323a:	000a0463          	beqz	s4,80003242 <dirlookup+0x8c>
        *poff = off;
    8000323e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003242:	fc045583          	lhu	a1,-64(s0)
    80003246:	00092503          	lw	a0,0(s2)
    8000324a:	fffff097          	auipc	ra,0xfffff
    8000324e:	754080e7          	jalr	1876(ra) # 8000299e <iget>
    80003252:	a011                	j	80003256 <dirlookup+0xa0>
  return 0;
    80003254:	4501                	li	a0,0
}
    80003256:	70e2                	ld	ra,56(sp)
    80003258:	7442                	ld	s0,48(sp)
    8000325a:	74a2                	ld	s1,40(sp)
    8000325c:	7902                	ld	s2,32(sp)
    8000325e:	69e2                	ld	s3,24(sp)
    80003260:	6a42                	ld	s4,16(sp)
    80003262:	6121                	addi	sp,sp,64
    80003264:	8082                	ret

0000000080003266 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003266:	711d                	addi	sp,sp,-96
    80003268:	ec86                	sd	ra,88(sp)
    8000326a:	e8a2                	sd	s0,80(sp)
    8000326c:	e4a6                	sd	s1,72(sp)
    8000326e:	e0ca                	sd	s2,64(sp)
    80003270:	fc4e                	sd	s3,56(sp)
    80003272:	f852                	sd	s4,48(sp)
    80003274:	f456                	sd	s5,40(sp)
    80003276:	f05a                	sd	s6,32(sp)
    80003278:	ec5e                	sd	s7,24(sp)
    8000327a:	e862                	sd	s8,16(sp)
    8000327c:	e466                	sd	s9,8(sp)
    8000327e:	1080                	addi	s0,sp,96
    80003280:	84aa                	mv	s1,a0
    80003282:	8b2e                	mv	s6,a1
    80003284:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003286:	00054703          	lbu	a4,0(a0)
    8000328a:	02f00793          	li	a5,47
    8000328e:	02f70363          	beq	a4,a5,800032b4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003292:	ffffe097          	auipc	ra,0xffffe
    80003296:	cac080e7          	jalr	-852(ra) # 80000f3e <myproc>
    8000329a:	15053503          	ld	a0,336(a0)
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	9f6080e7          	jalr	-1546(ra) # 80002c94 <idup>
    800032a6:	89aa                	mv	s3,a0
  while(*path == '/')
    800032a8:	02f00913          	li	s2,47
  len = path - s;
    800032ac:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032ae:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032b0:	4c05                	li	s8,1
    800032b2:	a865                	j	8000336a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032b4:	4585                	li	a1,1
    800032b6:	4505                	li	a0,1
    800032b8:	fffff097          	auipc	ra,0xfffff
    800032bc:	6e6080e7          	jalr	1766(ra) # 8000299e <iget>
    800032c0:	89aa                	mv	s3,a0
    800032c2:	b7dd                	j	800032a8 <namex+0x42>
      iunlockput(ip);
    800032c4:	854e                	mv	a0,s3
    800032c6:	00000097          	auipc	ra,0x0
    800032ca:	c6e080e7          	jalr	-914(ra) # 80002f34 <iunlockput>
      return 0;
    800032ce:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032d0:	854e                	mv	a0,s3
    800032d2:	60e6                	ld	ra,88(sp)
    800032d4:	6446                	ld	s0,80(sp)
    800032d6:	64a6                	ld	s1,72(sp)
    800032d8:	6906                	ld	s2,64(sp)
    800032da:	79e2                	ld	s3,56(sp)
    800032dc:	7a42                	ld	s4,48(sp)
    800032de:	7aa2                	ld	s5,40(sp)
    800032e0:	7b02                	ld	s6,32(sp)
    800032e2:	6be2                	ld	s7,24(sp)
    800032e4:	6c42                	ld	s8,16(sp)
    800032e6:	6ca2                	ld	s9,8(sp)
    800032e8:	6125                	addi	sp,sp,96
    800032ea:	8082                	ret
      iunlock(ip);
    800032ec:	854e                	mv	a0,s3
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	aa6080e7          	jalr	-1370(ra) # 80002d94 <iunlock>
      return ip;
    800032f6:	bfe9                	j	800032d0 <namex+0x6a>
      iunlockput(ip);
    800032f8:	854e                	mv	a0,s3
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	c3a080e7          	jalr	-966(ra) # 80002f34 <iunlockput>
      return 0;
    80003302:	89d2                	mv	s3,s4
    80003304:	b7f1                	j	800032d0 <namex+0x6a>
  len = path - s;
    80003306:	40b48633          	sub	a2,s1,a1
    8000330a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000330e:	094cd463          	bge	s9,s4,80003396 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003312:	4639                	li	a2,14
    80003314:	8556                	mv	a0,s5
    80003316:	ffffd097          	auipc	ra,0xffffd
    8000331a:	ec2080e7          	jalr	-318(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000331e:	0004c783          	lbu	a5,0(s1)
    80003322:	01279763          	bne	a5,s2,80003330 <namex+0xca>
    path++;
    80003326:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003328:	0004c783          	lbu	a5,0(s1)
    8000332c:	ff278de3          	beq	a5,s2,80003326 <namex+0xc0>
    ilock(ip);
    80003330:	854e                	mv	a0,s3
    80003332:	00000097          	auipc	ra,0x0
    80003336:	9a0080e7          	jalr	-1632(ra) # 80002cd2 <ilock>
    if(ip->type != T_DIR){
    8000333a:	04499783          	lh	a5,68(s3)
    8000333e:	f98793e3          	bne	a5,s8,800032c4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003342:	000b0563          	beqz	s6,8000334c <namex+0xe6>
    80003346:	0004c783          	lbu	a5,0(s1)
    8000334a:	d3cd                	beqz	a5,800032ec <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000334c:	865e                	mv	a2,s7
    8000334e:	85d6                	mv	a1,s5
    80003350:	854e                	mv	a0,s3
    80003352:	00000097          	auipc	ra,0x0
    80003356:	e64080e7          	jalr	-412(ra) # 800031b6 <dirlookup>
    8000335a:	8a2a                	mv	s4,a0
    8000335c:	dd51                	beqz	a0,800032f8 <namex+0x92>
    iunlockput(ip);
    8000335e:	854e                	mv	a0,s3
    80003360:	00000097          	auipc	ra,0x0
    80003364:	bd4080e7          	jalr	-1068(ra) # 80002f34 <iunlockput>
    ip = next;
    80003368:	89d2                	mv	s3,s4
  while(*path == '/')
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	05279763          	bne	a5,s2,800033bc <namex+0x156>
    path++;
    80003372:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003374:	0004c783          	lbu	a5,0(s1)
    80003378:	ff278de3          	beq	a5,s2,80003372 <namex+0x10c>
  if(*path == 0)
    8000337c:	c79d                	beqz	a5,800033aa <namex+0x144>
    path++;
    8000337e:	85a6                	mv	a1,s1
  len = path - s;
    80003380:	8a5e                	mv	s4,s7
    80003382:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003384:	01278963          	beq	a5,s2,80003396 <namex+0x130>
    80003388:	dfbd                	beqz	a5,80003306 <namex+0xa0>
    path++;
    8000338a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000338c:	0004c783          	lbu	a5,0(s1)
    80003390:	ff279ce3          	bne	a5,s2,80003388 <namex+0x122>
    80003394:	bf8d                	j	80003306 <namex+0xa0>
    memmove(name, s, len);
    80003396:	2601                	sext.w	a2,a2
    80003398:	8556                	mv	a0,s5
    8000339a:	ffffd097          	auipc	ra,0xffffd
    8000339e:	e3e080e7          	jalr	-450(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033a2:	9a56                	add	s4,s4,s5
    800033a4:	000a0023          	sb	zero,0(s4)
    800033a8:	bf9d                	j	8000331e <namex+0xb8>
  if(nameiparent){
    800033aa:	f20b03e3          	beqz	s6,800032d0 <namex+0x6a>
    iput(ip);
    800033ae:	854e                	mv	a0,s3
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	adc080e7          	jalr	-1316(ra) # 80002e8c <iput>
    return 0;
    800033b8:	4981                	li	s3,0
    800033ba:	bf19                	j	800032d0 <namex+0x6a>
  if(*path == 0)
    800033bc:	d7fd                	beqz	a5,800033aa <namex+0x144>
  while(*path != '/' && *path != 0)
    800033be:	0004c783          	lbu	a5,0(s1)
    800033c2:	85a6                	mv	a1,s1
    800033c4:	b7d1                	j	80003388 <namex+0x122>

00000000800033c6 <dirlink>:
{
    800033c6:	7139                	addi	sp,sp,-64
    800033c8:	fc06                	sd	ra,56(sp)
    800033ca:	f822                	sd	s0,48(sp)
    800033cc:	f426                	sd	s1,40(sp)
    800033ce:	f04a                	sd	s2,32(sp)
    800033d0:	ec4e                	sd	s3,24(sp)
    800033d2:	e852                	sd	s4,16(sp)
    800033d4:	0080                	addi	s0,sp,64
    800033d6:	892a                	mv	s2,a0
    800033d8:	8a2e                	mv	s4,a1
    800033da:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033dc:	4601                	li	a2,0
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	dd8080e7          	jalr	-552(ra) # 800031b6 <dirlookup>
    800033e6:	e93d                	bnez	a0,8000345c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033e8:	04c92483          	lw	s1,76(s2)
    800033ec:	c49d                	beqz	s1,8000341a <dirlink+0x54>
    800033ee:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033f0:	4741                	li	a4,16
    800033f2:	86a6                	mv	a3,s1
    800033f4:	fc040613          	addi	a2,s0,-64
    800033f8:	4581                	li	a1,0
    800033fa:	854a                	mv	a0,s2
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	b8a080e7          	jalr	-1142(ra) # 80002f86 <readi>
    80003404:	47c1                	li	a5,16
    80003406:	06f51163          	bne	a0,a5,80003468 <dirlink+0xa2>
    if(de.inum == 0)
    8000340a:	fc045783          	lhu	a5,-64(s0)
    8000340e:	c791                	beqz	a5,8000341a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003410:	24c1                	addiw	s1,s1,16
    80003412:	04c92783          	lw	a5,76(s2)
    80003416:	fcf4ede3          	bltu	s1,a5,800033f0 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000341a:	4639                	li	a2,14
    8000341c:	85d2                	mv	a1,s4
    8000341e:	fc240513          	addi	a0,s0,-62
    80003422:	ffffd097          	auipc	ra,0xffffd
    80003426:	e6a080e7          	jalr	-406(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000342a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000342e:	4741                	li	a4,16
    80003430:	86a6                	mv	a3,s1
    80003432:	fc040613          	addi	a2,s0,-64
    80003436:	4581                	li	a1,0
    80003438:	854a                	mv	a0,s2
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	c44080e7          	jalr	-956(ra) # 8000307e <writei>
    80003442:	872a                	mv	a4,a0
    80003444:	47c1                	li	a5,16
  return 0;
    80003446:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003448:	02f71863          	bne	a4,a5,80003478 <dirlink+0xb2>
}
    8000344c:	70e2                	ld	ra,56(sp)
    8000344e:	7442                	ld	s0,48(sp)
    80003450:	74a2                	ld	s1,40(sp)
    80003452:	7902                	ld	s2,32(sp)
    80003454:	69e2                	ld	s3,24(sp)
    80003456:	6a42                	ld	s4,16(sp)
    80003458:	6121                	addi	sp,sp,64
    8000345a:	8082                	ret
    iput(ip);
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	a30080e7          	jalr	-1488(ra) # 80002e8c <iput>
    return -1;
    80003464:	557d                	li	a0,-1
    80003466:	b7dd                	j	8000344c <dirlink+0x86>
      panic("dirlink read");
    80003468:	00005517          	auipc	a0,0x5
    8000346c:	1d050513          	addi	a0,a0,464 # 80008638 <syscalls+0x240>
    80003470:	00003097          	auipc	ra,0x3
    80003474:	928080e7          	jalr	-1752(ra) # 80005d98 <panic>
    panic("dirlink");
    80003478:	00005517          	auipc	a0,0x5
    8000347c:	2d050513          	addi	a0,a0,720 # 80008748 <syscalls+0x350>
    80003480:	00003097          	auipc	ra,0x3
    80003484:	918080e7          	jalr	-1768(ra) # 80005d98 <panic>

0000000080003488 <namei>:

struct inode*
namei(char *path)
{
    80003488:	1101                	addi	sp,sp,-32
    8000348a:	ec06                	sd	ra,24(sp)
    8000348c:	e822                	sd	s0,16(sp)
    8000348e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003490:	fe040613          	addi	a2,s0,-32
    80003494:	4581                	li	a1,0
    80003496:	00000097          	auipc	ra,0x0
    8000349a:	dd0080e7          	jalr	-560(ra) # 80003266 <namex>
}
    8000349e:	60e2                	ld	ra,24(sp)
    800034a0:	6442                	ld	s0,16(sp)
    800034a2:	6105                	addi	sp,sp,32
    800034a4:	8082                	ret

00000000800034a6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034a6:	1141                	addi	sp,sp,-16
    800034a8:	e406                	sd	ra,8(sp)
    800034aa:	e022                	sd	s0,0(sp)
    800034ac:	0800                	addi	s0,sp,16
    800034ae:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034b0:	4585                	li	a1,1
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	db4080e7          	jalr	-588(ra) # 80003266 <namex>
}
    800034ba:	60a2                	ld	ra,8(sp)
    800034bc:	6402                	ld	s0,0(sp)
    800034be:	0141                	addi	sp,sp,16
    800034c0:	8082                	ret

00000000800034c2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034c2:	1101                	addi	sp,sp,-32
    800034c4:	ec06                	sd	ra,24(sp)
    800034c6:	e822                	sd	s0,16(sp)
    800034c8:	e426                	sd	s1,8(sp)
    800034ca:	e04a                	sd	s2,0(sp)
    800034cc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034ce:	00016917          	auipc	s2,0x16
    800034d2:	d6290913          	addi	s2,s2,-670 # 80019230 <log>
    800034d6:	01892583          	lw	a1,24(s2)
    800034da:	02892503          	lw	a0,40(s2)
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	ff2080e7          	jalr	-14(ra) # 800024d0 <bread>
    800034e6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034e8:	02c92683          	lw	a3,44(s2)
    800034ec:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034ee:	02d05763          	blez	a3,8000351c <write_head+0x5a>
    800034f2:	00016797          	auipc	a5,0x16
    800034f6:	d6e78793          	addi	a5,a5,-658 # 80019260 <log+0x30>
    800034fa:	05c50713          	addi	a4,a0,92
    800034fe:	36fd                	addiw	a3,a3,-1
    80003500:	1682                	slli	a3,a3,0x20
    80003502:	9281                	srli	a3,a3,0x20
    80003504:	068a                	slli	a3,a3,0x2
    80003506:	00016617          	auipc	a2,0x16
    8000350a:	d5e60613          	addi	a2,a2,-674 # 80019264 <log+0x34>
    8000350e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003510:	4390                	lw	a2,0(a5)
    80003512:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003514:	0791                	addi	a5,a5,4
    80003516:	0711                	addi	a4,a4,4
    80003518:	fed79ce3          	bne	a5,a3,80003510 <write_head+0x4e>
  }
  bwrite(buf);
    8000351c:	8526                	mv	a0,s1
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	0a4080e7          	jalr	164(ra) # 800025c2 <bwrite>
  brelse(buf);
    80003526:	8526                	mv	a0,s1
    80003528:	fffff097          	auipc	ra,0xfffff
    8000352c:	0d8080e7          	jalr	216(ra) # 80002600 <brelse>
}
    80003530:	60e2                	ld	ra,24(sp)
    80003532:	6442                	ld	s0,16(sp)
    80003534:	64a2                	ld	s1,8(sp)
    80003536:	6902                	ld	s2,0(sp)
    80003538:	6105                	addi	sp,sp,32
    8000353a:	8082                	ret

000000008000353c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000353c:	00016797          	auipc	a5,0x16
    80003540:	d207a783          	lw	a5,-736(a5) # 8001925c <log+0x2c>
    80003544:	0af05d63          	blez	a5,800035fe <install_trans+0xc2>
{
    80003548:	7139                	addi	sp,sp,-64
    8000354a:	fc06                	sd	ra,56(sp)
    8000354c:	f822                	sd	s0,48(sp)
    8000354e:	f426                	sd	s1,40(sp)
    80003550:	f04a                	sd	s2,32(sp)
    80003552:	ec4e                	sd	s3,24(sp)
    80003554:	e852                	sd	s4,16(sp)
    80003556:	e456                	sd	s5,8(sp)
    80003558:	e05a                	sd	s6,0(sp)
    8000355a:	0080                	addi	s0,sp,64
    8000355c:	8b2a                	mv	s6,a0
    8000355e:	00016a97          	auipc	s5,0x16
    80003562:	d02a8a93          	addi	s5,s5,-766 # 80019260 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003566:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003568:	00016997          	auipc	s3,0x16
    8000356c:	cc898993          	addi	s3,s3,-824 # 80019230 <log>
    80003570:	a035                	j	8000359c <install_trans+0x60>
      bunpin(dbuf);
    80003572:	8526                	mv	a0,s1
    80003574:	fffff097          	auipc	ra,0xfffff
    80003578:	166080e7          	jalr	358(ra) # 800026da <bunpin>
    brelse(lbuf);
    8000357c:	854a                	mv	a0,s2
    8000357e:	fffff097          	auipc	ra,0xfffff
    80003582:	082080e7          	jalr	130(ra) # 80002600 <brelse>
    brelse(dbuf);
    80003586:	8526                	mv	a0,s1
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	078080e7          	jalr	120(ra) # 80002600 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003590:	2a05                	addiw	s4,s4,1
    80003592:	0a91                	addi	s5,s5,4
    80003594:	02c9a783          	lw	a5,44(s3)
    80003598:	04fa5963          	bge	s4,a5,800035ea <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000359c:	0189a583          	lw	a1,24(s3)
    800035a0:	014585bb          	addw	a1,a1,s4
    800035a4:	2585                	addiw	a1,a1,1
    800035a6:	0289a503          	lw	a0,40(s3)
    800035aa:	fffff097          	auipc	ra,0xfffff
    800035ae:	f26080e7          	jalr	-218(ra) # 800024d0 <bread>
    800035b2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035b4:	000aa583          	lw	a1,0(s5)
    800035b8:	0289a503          	lw	a0,40(s3)
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	f14080e7          	jalr	-236(ra) # 800024d0 <bread>
    800035c4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035c6:	40000613          	li	a2,1024
    800035ca:	05890593          	addi	a1,s2,88
    800035ce:	05850513          	addi	a0,a0,88
    800035d2:	ffffd097          	auipc	ra,0xffffd
    800035d6:	c06080e7          	jalr	-1018(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035da:	8526                	mv	a0,s1
    800035dc:	fffff097          	auipc	ra,0xfffff
    800035e0:	fe6080e7          	jalr	-26(ra) # 800025c2 <bwrite>
    if(recovering == 0)
    800035e4:	f80b1ce3          	bnez	s6,8000357c <install_trans+0x40>
    800035e8:	b769                	j	80003572 <install_trans+0x36>
}
    800035ea:	70e2                	ld	ra,56(sp)
    800035ec:	7442                	ld	s0,48(sp)
    800035ee:	74a2                	ld	s1,40(sp)
    800035f0:	7902                	ld	s2,32(sp)
    800035f2:	69e2                	ld	s3,24(sp)
    800035f4:	6a42                	ld	s4,16(sp)
    800035f6:	6aa2                	ld	s5,8(sp)
    800035f8:	6b02                	ld	s6,0(sp)
    800035fa:	6121                	addi	sp,sp,64
    800035fc:	8082                	ret
    800035fe:	8082                	ret

0000000080003600 <initlog>:
{
    80003600:	7179                	addi	sp,sp,-48
    80003602:	f406                	sd	ra,40(sp)
    80003604:	f022                	sd	s0,32(sp)
    80003606:	ec26                	sd	s1,24(sp)
    80003608:	e84a                	sd	s2,16(sp)
    8000360a:	e44e                	sd	s3,8(sp)
    8000360c:	1800                	addi	s0,sp,48
    8000360e:	892a                	mv	s2,a0
    80003610:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003612:	00016497          	auipc	s1,0x16
    80003616:	c1e48493          	addi	s1,s1,-994 # 80019230 <log>
    8000361a:	00005597          	auipc	a1,0x5
    8000361e:	02e58593          	addi	a1,a1,46 # 80008648 <syscalls+0x250>
    80003622:	8526                	mv	a0,s1
    80003624:	00003097          	auipc	ra,0x3
    80003628:	c2e080e7          	jalr	-978(ra) # 80006252 <initlock>
  log.start = sb->logstart;
    8000362c:	0149a583          	lw	a1,20(s3)
    80003630:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003632:	0109a783          	lw	a5,16(s3)
    80003636:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003638:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000363c:	854a                	mv	a0,s2
    8000363e:	fffff097          	auipc	ra,0xfffff
    80003642:	e92080e7          	jalr	-366(ra) # 800024d0 <bread>
  log.lh.n = lh->n;
    80003646:	4d3c                	lw	a5,88(a0)
    80003648:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000364a:	02f05563          	blez	a5,80003674 <initlog+0x74>
    8000364e:	05c50713          	addi	a4,a0,92
    80003652:	00016697          	auipc	a3,0x16
    80003656:	c0e68693          	addi	a3,a3,-1010 # 80019260 <log+0x30>
    8000365a:	37fd                	addiw	a5,a5,-1
    8000365c:	1782                	slli	a5,a5,0x20
    8000365e:	9381                	srli	a5,a5,0x20
    80003660:	078a                	slli	a5,a5,0x2
    80003662:	06050613          	addi	a2,a0,96
    80003666:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003668:	4310                	lw	a2,0(a4)
    8000366a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000366c:	0711                	addi	a4,a4,4
    8000366e:	0691                	addi	a3,a3,4
    80003670:	fef71ce3          	bne	a4,a5,80003668 <initlog+0x68>
  brelse(buf);
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	f8c080e7          	jalr	-116(ra) # 80002600 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000367c:	4505                	li	a0,1
    8000367e:	00000097          	auipc	ra,0x0
    80003682:	ebe080e7          	jalr	-322(ra) # 8000353c <install_trans>
  log.lh.n = 0;
    80003686:	00016797          	auipc	a5,0x16
    8000368a:	bc07ab23          	sw	zero,-1066(a5) # 8001925c <log+0x2c>
  write_head(); // clear the log
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	e34080e7          	jalr	-460(ra) # 800034c2 <write_head>
}
    80003696:	70a2                	ld	ra,40(sp)
    80003698:	7402                	ld	s0,32(sp)
    8000369a:	64e2                	ld	s1,24(sp)
    8000369c:	6942                	ld	s2,16(sp)
    8000369e:	69a2                	ld	s3,8(sp)
    800036a0:	6145                	addi	sp,sp,48
    800036a2:	8082                	ret

00000000800036a4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036a4:	1101                	addi	sp,sp,-32
    800036a6:	ec06                	sd	ra,24(sp)
    800036a8:	e822                	sd	s0,16(sp)
    800036aa:	e426                	sd	s1,8(sp)
    800036ac:	e04a                	sd	s2,0(sp)
    800036ae:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036b0:	00016517          	auipc	a0,0x16
    800036b4:	b8050513          	addi	a0,a0,-1152 # 80019230 <log>
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	c2a080e7          	jalr	-982(ra) # 800062e2 <acquire>
  while(1){
    if(log.committing){
    800036c0:	00016497          	auipc	s1,0x16
    800036c4:	b7048493          	addi	s1,s1,-1168 # 80019230 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036c8:	4979                	li	s2,30
    800036ca:	a039                	j	800036d8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800036cc:	85a6                	mv	a1,s1
    800036ce:	8526                	mv	a0,s1
    800036d0:	ffffe097          	auipc	ra,0xffffe
    800036d4:	fb0080e7          	jalr	-80(ra) # 80001680 <sleep>
    if(log.committing){
    800036d8:	50dc                	lw	a5,36(s1)
    800036da:	fbed                	bnez	a5,800036cc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036dc:	509c                	lw	a5,32(s1)
    800036de:	0017871b          	addiw	a4,a5,1
    800036e2:	0007069b          	sext.w	a3,a4
    800036e6:	0027179b          	slliw	a5,a4,0x2
    800036ea:	9fb9                	addw	a5,a5,a4
    800036ec:	0017979b          	slliw	a5,a5,0x1
    800036f0:	54d8                	lw	a4,44(s1)
    800036f2:	9fb9                	addw	a5,a5,a4
    800036f4:	00f95963          	bge	s2,a5,80003706 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036f8:	85a6                	mv	a1,s1
    800036fa:	8526                	mv	a0,s1
    800036fc:	ffffe097          	auipc	ra,0xffffe
    80003700:	f84080e7          	jalr	-124(ra) # 80001680 <sleep>
    80003704:	bfd1                	j	800036d8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003706:	00016517          	auipc	a0,0x16
    8000370a:	b2a50513          	addi	a0,a0,-1238 # 80019230 <log>
    8000370e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003710:	00003097          	auipc	ra,0x3
    80003714:	c86080e7          	jalr	-890(ra) # 80006396 <release>
      break;
    }
  }
}
    80003718:	60e2                	ld	ra,24(sp)
    8000371a:	6442                	ld	s0,16(sp)
    8000371c:	64a2                	ld	s1,8(sp)
    8000371e:	6902                	ld	s2,0(sp)
    80003720:	6105                	addi	sp,sp,32
    80003722:	8082                	ret

0000000080003724 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003724:	7139                	addi	sp,sp,-64
    80003726:	fc06                	sd	ra,56(sp)
    80003728:	f822                	sd	s0,48(sp)
    8000372a:	f426                	sd	s1,40(sp)
    8000372c:	f04a                	sd	s2,32(sp)
    8000372e:	ec4e                	sd	s3,24(sp)
    80003730:	e852                	sd	s4,16(sp)
    80003732:	e456                	sd	s5,8(sp)
    80003734:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003736:	00016497          	auipc	s1,0x16
    8000373a:	afa48493          	addi	s1,s1,-1286 # 80019230 <log>
    8000373e:	8526                	mv	a0,s1
    80003740:	00003097          	auipc	ra,0x3
    80003744:	ba2080e7          	jalr	-1118(ra) # 800062e2 <acquire>
  log.outstanding -= 1;
    80003748:	509c                	lw	a5,32(s1)
    8000374a:	37fd                	addiw	a5,a5,-1
    8000374c:	0007891b          	sext.w	s2,a5
    80003750:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003752:	50dc                	lw	a5,36(s1)
    80003754:	efb9                	bnez	a5,800037b2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003756:	06091663          	bnez	s2,800037c2 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000375a:	00016497          	auipc	s1,0x16
    8000375e:	ad648493          	addi	s1,s1,-1322 # 80019230 <log>
    80003762:	4785                	li	a5,1
    80003764:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003766:	8526                	mv	a0,s1
    80003768:	00003097          	auipc	ra,0x3
    8000376c:	c2e080e7          	jalr	-978(ra) # 80006396 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003770:	54dc                	lw	a5,44(s1)
    80003772:	06f04763          	bgtz	a5,800037e0 <end_op+0xbc>
    acquire(&log.lock);
    80003776:	00016497          	auipc	s1,0x16
    8000377a:	aba48493          	addi	s1,s1,-1350 # 80019230 <log>
    8000377e:	8526                	mv	a0,s1
    80003780:	00003097          	auipc	ra,0x3
    80003784:	b62080e7          	jalr	-1182(ra) # 800062e2 <acquire>
    log.committing = 0;
    80003788:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000378c:	8526                	mv	a0,s1
    8000378e:	ffffe097          	auipc	ra,0xffffe
    80003792:	07e080e7          	jalr	126(ra) # 8000180c <wakeup>
    release(&log.lock);
    80003796:	8526                	mv	a0,s1
    80003798:	00003097          	auipc	ra,0x3
    8000379c:	bfe080e7          	jalr	-1026(ra) # 80006396 <release>
}
    800037a0:	70e2                	ld	ra,56(sp)
    800037a2:	7442                	ld	s0,48(sp)
    800037a4:	74a2                	ld	s1,40(sp)
    800037a6:	7902                	ld	s2,32(sp)
    800037a8:	69e2                	ld	s3,24(sp)
    800037aa:	6a42                	ld	s4,16(sp)
    800037ac:	6aa2                	ld	s5,8(sp)
    800037ae:	6121                	addi	sp,sp,64
    800037b0:	8082                	ret
    panic("log.committing");
    800037b2:	00005517          	auipc	a0,0x5
    800037b6:	e9e50513          	addi	a0,a0,-354 # 80008650 <syscalls+0x258>
    800037ba:	00002097          	auipc	ra,0x2
    800037be:	5de080e7          	jalr	1502(ra) # 80005d98 <panic>
    wakeup(&log);
    800037c2:	00016497          	auipc	s1,0x16
    800037c6:	a6e48493          	addi	s1,s1,-1426 # 80019230 <log>
    800037ca:	8526                	mv	a0,s1
    800037cc:	ffffe097          	auipc	ra,0xffffe
    800037d0:	040080e7          	jalr	64(ra) # 8000180c <wakeup>
  release(&log.lock);
    800037d4:	8526                	mv	a0,s1
    800037d6:	00003097          	auipc	ra,0x3
    800037da:	bc0080e7          	jalr	-1088(ra) # 80006396 <release>
  if(do_commit){
    800037de:	b7c9                	j	800037a0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037e0:	00016a97          	auipc	s5,0x16
    800037e4:	a80a8a93          	addi	s5,s5,-1408 # 80019260 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037e8:	00016a17          	auipc	s4,0x16
    800037ec:	a48a0a13          	addi	s4,s4,-1464 # 80019230 <log>
    800037f0:	018a2583          	lw	a1,24(s4)
    800037f4:	012585bb          	addw	a1,a1,s2
    800037f8:	2585                	addiw	a1,a1,1
    800037fa:	028a2503          	lw	a0,40(s4)
    800037fe:	fffff097          	auipc	ra,0xfffff
    80003802:	cd2080e7          	jalr	-814(ra) # 800024d0 <bread>
    80003806:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003808:	000aa583          	lw	a1,0(s5)
    8000380c:	028a2503          	lw	a0,40(s4)
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	cc0080e7          	jalr	-832(ra) # 800024d0 <bread>
    80003818:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000381a:	40000613          	li	a2,1024
    8000381e:	05850593          	addi	a1,a0,88
    80003822:	05848513          	addi	a0,s1,88
    80003826:	ffffd097          	auipc	ra,0xffffd
    8000382a:	9b2080e7          	jalr	-1614(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000382e:	8526                	mv	a0,s1
    80003830:	fffff097          	auipc	ra,0xfffff
    80003834:	d92080e7          	jalr	-622(ra) # 800025c2 <bwrite>
    brelse(from);
    80003838:	854e                	mv	a0,s3
    8000383a:	fffff097          	auipc	ra,0xfffff
    8000383e:	dc6080e7          	jalr	-570(ra) # 80002600 <brelse>
    brelse(to);
    80003842:	8526                	mv	a0,s1
    80003844:	fffff097          	auipc	ra,0xfffff
    80003848:	dbc080e7          	jalr	-580(ra) # 80002600 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000384c:	2905                	addiw	s2,s2,1
    8000384e:	0a91                	addi	s5,s5,4
    80003850:	02ca2783          	lw	a5,44(s4)
    80003854:	f8f94ee3          	blt	s2,a5,800037f0 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003858:	00000097          	auipc	ra,0x0
    8000385c:	c6a080e7          	jalr	-918(ra) # 800034c2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003860:	4501                	li	a0,0
    80003862:	00000097          	auipc	ra,0x0
    80003866:	cda080e7          	jalr	-806(ra) # 8000353c <install_trans>
    log.lh.n = 0;
    8000386a:	00016797          	auipc	a5,0x16
    8000386e:	9e07a923          	sw	zero,-1550(a5) # 8001925c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003872:	00000097          	auipc	ra,0x0
    80003876:	c50080e7          	jalr	-944(ra) # 800034c2 <write_head>
    8000387a:	bdf5                	j	80003776 <end_op+0x52>

000000008000387c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000387c:	1101                	addi	sp,sp,-32
    8000387e:	ec06                	sd	ra,24(sp)
    80003880:	e822                	sd	s0,16(sp)
    80003882:	e426                	sd	s1,8(sp)
    80003884:	e04a                	sd	s2,0(sp)
    80003886:	1000                	addi	s0,sp,32
    80003888:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000388a:	00016917          	auipc	s2,0x16
    8000388e:	9a690913          	addi	s2,s2,-1626 # 80019230 <log>
    80003892:	854a                	mv	a0,s2
    80003894:	00003097          	auipc	ra,0x3
    80003898:	a4e080e7          	jalr	-1458(ra) # 800062e2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000389c:	02c92603          	lw	a2,44(s2)
    800038a0:	47f5                	li	a5,29
    800038a2:	06c7c563          	blt	a5,a2,8000390c <log_write+0x90>
    800038a6:	00016797          	auipc	a5,0x16
    800038aa:	9a67a783          	lw	a5,-1626(a5) # 8001924c <log+0x1c>
    800038ae:	37fd                	addiw	a5,a5,-1
    800038b0:	04f65e63          	bge	a2,a5,8000390c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038b4:	00016797          	auipc	a5,0x16
    800038b8:	99c7a783          	lw	a5,-1636(a5) # 80019250 <log+0x20>
    800038bc:	06f05063          	blez	a5,8000391c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038c0:	4781                	li	a5,0
    800038c2:	06c05563          	blez	a2,8000392c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038c6:	44cc                	lw	a1,12(s1)
    800038c8:	00016717          	auipc	a4,0x16
    800038cc:	99870713          	addi	a4,a4,-1640 # 80019260 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038d0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038d2:	4314                	lw	a3,0(a4)
    800038d4:	04b68c63          	beq	a3,a1,8000392c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038d8:	2785                	addiw	a5,a5,1
    800038da:	0711                	addi	a4,a4,4
    800038dc:	fef61be3          	bne	a2,a5,800038d2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038e0:	0621                	addi	a2,a2,8
    800038e2:	060a                	slli	a2,a2,0x2
    800038e4:	00016797          	auipc	a5,0x16
    800038e8:	94c78793          	addi	a5,a5,-1716 # 80019230 <log>
    800038ec:	963e                	add	a2,a2,a5
    800038ee:	44dc                	lw	a5,12(s1)
    800038f0:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038f2:	8526                	mv	a0,s1
    800038f4:	fffff097          	auipc	ra,0xfffff
    800038f8:	daa080e7          	jalr	-598(ra) # 8000269e <bpin>
    log.lh.n++;
    800038fc:	00016717          	auipc	a4,0x16
    80003900:	93470713          	addi	a4,a4,-1740 # 80019230 <log>
    80003904:	575c                	lw	a5,44(a4)
    80003906:	2785                	addiw	a5,a5,1
    80003908:	d75c                	sw	a5,44(a4)
    8000390a:	a835                	j	80003946 <log_write+0xca>
    panic("too big a transaction");
    8000390c:	00005517          	auipc	a0,0x5
    80003910:	d5450513          	addi	a0,a0,-684 # 80008660 <syscalls+0x268>
    80003914:	00002097          	auipc	ra,0x2
    80003918:	484080e7          	jalr	1156(ra) # 80005d98 <panic>
    panic("log_write outside of trans");
    8000391c:	00005517          	auipc	a0,0x5
    80003920:	d5c50513          	addi	a0,a0,-676 # 80008678 <syscalls+0x280>
    80003924:	00002097          	auipc	ra,0x2
    80003928:	474080e7          	jalr	1140(ra) # 80005d98 <panic>
  log.lh.block[i] = b->blockno;
    8000392c:	00878713          	addi	a4,a5,8
    80003930:	00271693          	slli	a3,a4,0x2
    80003934:	00016717          	auipc	a4,0x16
    80003938:	8fc70713          	addi	a4,a4,-1796 # 80019230 <log>
    8000393c:	9736                	add	a4,a4,a3
    8000393e:	44d4                	lw	a3,12(s1)
    80003940:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003942:	faf608e3          	beq	a2,a5,800038f2 <log_write+0x76>
  }
  release(&log.lock);
    80003946:	00016517          	auipc	a0,0x16
    8000394a:	8ea50513          	addi	a0,a0,-1814 # 80019230 <log>
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	a48080e7          	jalr	-1464(ra) # 80006396 <release>
}
    80003956:	60e2                	ld	ra,24(sp)
    80003958:	6442                	ld	s0,16(sp)
    8000395a:	64a2                	ld	s1,8(sp)
    8000395c:	6902                	ld	s2,0(sp)
    8000395e:	6105                	addi	sp,sp,32
    80003960:	8082                	ret

0000000080003962 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003962:	1101                	addi	sp,sp,-32
    80003964:	ec06                	sd	ra,24(sp)
    80003966:	e822                	sd	s0,16(sp)
    80003968:	e426                	sd	s1,8(sp)
    8000396a:	e04a                	sd	s2,0(sp)
    8000396c:	1000                	addi	s0,sp,32
    8000396e:	84aa                	mv	s1,a0
    80003970:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003972:	00005597          	auipc	a1,0x5
    80003976:	d2658593          	addi	a1,a1,-730 # 80008698 <syscalls+0x2a0>
    8000397a:	0521                	addi	a0,a0,8
    8000397c:	00003097          	auipc	ra,0x3
    80003980:	8d6080e7          	jalr	-1834(ra) # 80006252 <initlock>
  lk->name = name;
    80003984:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003988:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000398c:	0204a423          	sw	zero,40(s1)
}
    80003990:	60e2                	ld	ra,24(sp)
    80003992:	6442                	ld	s0,16(sp)
    80003994:	64a2                	ld	s1,8(sp)
    80003996:	6902                	ld	s2,0(sp)
    80003998:	6105                	addi	sp,sp,32
    8000399a:	8082                	ret

000000008000399c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000399c:	1101                	addi	sp,sp,-32
    8000399e:	ec06                	sd	ra,24(sp)
    800039a0:	e822                	sd	s0,16(sp)
    800039a2:	e426                	sd	s1,8(sp)
    800039a4:	e04a                	sd	s2,0(sp)
    800039a6:	1000                	addi	s0,sp,32
    800039a8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039aa:	00850913          	addi	s2,a0,8
    800039ae:	854a                	mv	a0,s2
    800039b0:	00003097          	auipc	ra,0x3
    800039b4:	932080e7          	jalr	-1742(ra) # 800062e2 <acquire>
  while (lk->locked) {
    800039b8:	409c                	lw	a5,0(s1)
    800039ba:	cb89                	beqz	a5,800039cc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039bc:	85ca                	mv	a1,s2
    800039be:	8526                	mv	a0,s1
    800039c0:	ffffe097          	auipc	ra,0xffffe
    800039c4:	cc0080e7          	jalr	-832(ra) # 80001680 <sleep>
  while (lk->locked) {
    800039c8:	409c                	lw	a5,0(s1)
    800039ca:	fbed                	bnez	a5,800039bc <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039cc:	4785                	li	a5,1
    800039ce:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039d0:	ffffd097          	auipc	ra,0xffffd
    800039d4:	56e080e7          	jalr	1390(ra) # 80000f3e <myproc>
    800039d8:	591c                	lw	a5,48(a0)
    800039da:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039dc:	854a                	mv	a0,s2
    800039de:	00003097          	auipc	ra,0x3
    800039e2:	9b8080e7          	jalr	-1608(ra) # 80006396 <release>
}
    800039e6:	60e2                	ld	ra,24(sp)
    800039e8:	6442                	ld	s0,16(sp)
    800039ea:	64a2                	ld	s1,8(sp)
    800039ec:	6902                	ld	s2,0(sp)
    800039ee:	6105                	addi	sp,sp,32
    800039f0:	8082                	ret

00000000800039f2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039f2:	1101                	addi	sp,sp,-32
    800039f4:	ec06                	sd	ra,24(sp)
    800039f6:	e822                	sd	s0,16(sp)
    800039f8:	e426                	sd	s1,8(sp)
    800039fa:	e04a                	sd	s2,0(sp)
    800039fc:	1000                	addi	s0,sp,32
    800039fe:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a00:	00850913          	addi	s2,a0,8
    80003a04:	854a                	mv	a0,s2
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	8dc080e7          	jalr	-1828(ra) # 800062e2 <acquire>
  lk->locked = 0;
    80003a0e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a12:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a16:	8526                	mv	a0,s1
    80003a18:	ffffe097          	auipc	ra,0xffffe
    80003a1c:	df4080e7          	jalr	-524(ra) # 8000180c <wakeup>
  release(&lk->lk);
    80003a20:	854a                	mv	a0,s2
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	974080e7          	jalr	-1676(ra) # 80006396 <release>
}
    80003a2a:	60e2                	ld	ra,24(sp)
    80003a2c:	6442                	ld	s0,16(sp)
    80003a2e:	64a2                	ld	s1,8(sp)
    80003a30:	6902                	ld	s2,0(sp)
    80003a32:	6105                	addi	sp,sp,32
    80003a34:	8082                	ret

0000000080003a36 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a36:	7179                	addi	sp,sp,-48
    80003a38:	f406                	sd	ra,40(sp)
    80003a3a:	f022                	sd	s0,32(sp)
    80003a3c:	ec26                	sd	s1,24(sp)
    80003a3e:	e84a                	sd	s2,16(sp)
    80003a40:	e44e                	sd	s3,8(sp)
    80003a42:	1800                	addi	s0,sp,48
    80003a44:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a46:	00850913          	addi	s2,a0,8
    80003a4a:	854a                	mv	a0,s2
    80003a4c:	00003097          	auipc	ra,0x3
    80003a50:	896080e7          	jalr	-1898(ra) # 800062e2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a54:	409c                	lw	a5,0(s1)
    80003a56:	ef99                	bnez	a5,80003a74 <holdingsleep+0x3e>
    80003a58:	4481                	li	s1,0
  release(&lk->lk);
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	93a080e7          	jalr	-1734(ra) # 80006396 <release>
  return r;
}
    80003a64:	8526                	mv	a0,s1
    80003a66:	70a2                	ld	ra,40(sp)
    80003a68:	7402                	ld	s0,32(sp)
    80003a6a:	64e2                	ld	s1,24(sp)
    80003a6c:	6942                	ld	s2,16(sp)
    80003a6e:	69a2                	ld	s3,8(sp)
    80003a70:	6145                	addi	sp,sp,48
    80003a72:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a74:	0284a983          	lw	s3,40(s1)
    80003a78:	ffffd097          	auipc	ra,0xffffd
    80003a7c:	4c6080e7          	jalr	1222(ra) # 80000f3e <myproc>
    80003a80:	5904                	lw	s1,48(a0)
    80003a82:	413484b3          	sub	s1,s1,s3
    80003a86:	0014b493          	seqz	s1,s1
    80003a8a:	bfc1                	j	80003a5a <holdingsleep+0x24>

0000000080003a8c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a8c:	1141                	addi	sp,sp,-16
    80003a8e:	e406                	sd	ra,8(sp)
    80003a90:	e022                	sd	s0,0(sp)
    80003a92:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a94:	00005597          	auipc	a1,0x5
    80003a98:	c1458593          	addi	a1,a1,-1004 # 800086a8 <syscalls+0x2b0>
    80003a9c:	00016517          	auipc	a0,0x16
    80003aa0:	8dc50513          	addi	a0,a0,-1828 # 80019378 <ftable>
    80003aa4:	00002097          	auipc	ra,0x2
    80003aa8:	7ae080e7          	jalr	1966(ra) # 80006252 <initlock>
}
    80003aac:	60a2                	ld	ra,8(sp)
    80003aae:	6402                	ld	s0,0(sp)
    80003ab0:	0141                	addi	sp,sp,16
    80003ab2:	8082                	ret

0000000080003ab4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ab4:	1101                	addi	sp,sp,-32
    80003ab6:	ec06                	sd	ra,24(sp)
    80003ab8:	e822                	sd	s0,16(sp)
    80003aba:	e426                	sd	s1,8(sp)
    80003abc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003abe:	00016517          	auipc	a0,0x16
    80003ac2:	8ba50513          	addi	a0,a0,-1862 # 80019378 <ftable>
    80003ac6:	00003097          	auipc	ra,0x3
    80003aca:	81c080e7          	jalr	-2020(ra) # 800062e2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ace:	00016497          	auipc	s1,0x16
    80003ad2:	8c248493          	addi	s1,s1,-1854 # 80019390 <ftable+0x18>
    80003ad6:	00017717          	auipc	a4,0x17
    80003ada:	85a70713          	addi	a4,a4,-1958 # 8001a330 <ftable+0xfb8>
    if(f->ref == 0){
    80003ade:	40dc                	lw	a5,4(s1)
    80003ae0:	cf99                	beqz	a5,80003afe <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ae2:	02848493          	addi	s1,s1,40
    80003ae6:	fee49ce3          	bne	s1,a4,80003ade <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003aea:	00016517          	auipc	a0,0x16
    80003aee:	88e50513          	addi	a0,a0,-1906 # 80019378 <ftable>
    80003af2:	00003097          	auipc	ra,0x3
    80003af6:	8a4080e7          	jalr	-1884(ra) # 80006396 <release>
  return 0;
    80003afa:	4481                	li	s1,0
    80003afc:	a819                	j	80003b12 <filealloc+0x5e>
      f->ref = 1;
    80003afe:	4785                	li	a5,1
    80003b00:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b02:	00016517          	auipc	a0,0x16
    80003b06:	87650513          	addi	a0,a0,-1930 # 80019378 <ftable>
    80003b0a:	00003097          	auipc	ra,0x3
    80003b0e:	88c080e7          	jalr	-1908(ra) # 80006396 <release>
}
    80003b12:	8526                	mv	a0,s1
    80003b14:	60e2                	ld	ra,24(sp)
    80003b16:	6442                	ld	s0,16(sp)
    80003b18:	64a2                	ld	s1,8(sp)
    80003b1a:	6105                	addi	sp,sp,32
    80003b1c:	8082                	ret

0000000080003b1e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b1e:	1101                	addi	sp,sp,-32
    80003b20:	ec06                	sd	ra,24(sp)
    80003b22:	e822                	sd	s0,16(sp)
    80003b24:	e426                	sd	s1,8(sp)
    80003b26:	1000                	addi	s0,sp,32
    80003b28:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b2a:	00016517          	auipc	a0,0x16
    80003b2e:	84e50513          	addi	a0,a0,-1970 # 80019378 <ftable>
    80003b32:	00002097          	auipc	ra,0x2
    80003b36:	7b0080e7          	jalr	1968(ra) # 800062e2 <acquire>
  if(f->ref < 1)
    80003b3a:	40dc                	lw	a5,4(s1)
    80003b3c:	02f05263          	blez	a5,80003b60 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b40:	2785                	addiw	a5,a5,1
    80003b42:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b44:	00016517          	auipc	a0,0x16
    80003b48:	83450513          	addi	a0,a0,-1996 # 80019378 <ftable>
    80003b4c:	00003097          	auipc	ra,0x3
    80003b50:	84a080e7          	jalr	-1974(ra) # 80006396 <release>
  return f;
}
    80003b54:	8526                	mv	a0,s1
    80003b56:	60e2                	ld	ra,24(sp)
    80003b58:	6442                	ld	s0,16(sp)
    80003b5a:	64a2                	ld	s1,8(sp)
    80003b5c:	6105                	addi	sp,sp,32
    80003b5e:	8082                	ret
    panic("filedup");
    80003b60:	00005517          	auipc	a0,0x5
    80003b64:	b5050513          	addi	a0,a0,-1200 # 800086b0 <syscalls+0x2b8>
    80003b68:	00002097          	auipc	ra,0x2
    80003b6c:	230080e7          	jalr	560(ra) # 80005d98 <panic>

0000000080003b70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b70:	7139                	addi	sp,sp,-64
    80003b72:	fc06                	sd	ra,56(sp)
    80003b74:	f822                	sd	s0,48(sp)
    80003b76:	f426                	sd	s1,40(sp)
    80003b78:	f04a                	sd	s2,32(sp)
    80003b7a:	ec4e                	sd	s3,24(sp)
    80003b7c:	e852                	sd	s4,16(sp)
    80003b7e:	e456                	sd	s5,8(sp)
    80003b80:	0080                	addi	s0,sp,64
    80003b82:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b84:	00015517          	auipc	a0,0x15
    80003b88:	7f450513          	addi	a0,a0,2036 # 80019378 <ftable>
    80003b8c:	00002097          	auipc	ra,0x2
    80003b90:	756080e7          	jalr	1878(ra) # 800062e2 <acquire>
  if(f->ref < 1)
    80003b94:	40dc                	lw	a5,4(s1)
    80003b96:	06f05163          	blez	a5,80003bf8 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b9a:	37fd                	addiw	a5,a5,-1
    80003b9c:	0007871b          	sext.w	a4,a5
    80003ba0:	c0dc                	sw	a5,4(s1)
    80003ba2:	06e04363          	bgtz	a4,80003c08 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ba6:	0004a903          	lw	s2,0(s1)
    80003baa:	0094ca83          	lbu	s5,9(s1)
    80003bae:	0104ba03          	ld	s4,16(s1)
    80003bb2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bb6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bba:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bbe:	00015517          	auipc	a0,0x15
    80003bc2:	7ba50513          	addi	a0,a0,1978 # 80019378 <ftable>
    80003bc6:	00002097          	auipc	ra,0x2
    80003bca:	7d0080e7          	jalr	2000(ra) # 80006396 <release>

  if(ff.type == FD_PIPE){
    80003bce:	4785                	li	a5,1
    80003bd0:	04f90d63          	beq	s2,a5,80003c2a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bd4:	3979                	addiw	s2,s2,-2
    80003bd6:	4785                	li	a5,1
    80003bd8:	0527e063          	bltu	a5,s2,80003c18 <fileclose+0xa8>
    begin_op();
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	ac8080e7          	jalr	-1336(ra) # 800036a4 <begin_op>
    iput(ff.ip);
    80003be4:	854e                	mv	a0,s3
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	2a6080e7          	jalr	678(ra) # 80002e8c <iput>
    end_op();
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	b36080e7          	jalr	-1226(ra) # 80003724 <end_op>
    80003bf6:	a00d                	j	80003c18 <fileclose+0xa8>
    panic("fileclose");
    80003bf8:	00005517          	auipc	a0,0x5
    80003bfc:	ac050513          	addi	a0,a0,-1344 # 800086b8 <syscalls+0x2c0>
    80003c00:	00002097          	auipc	ra,0x2
    80003c04:	198080e7          	jalr	408(ra) # 80005d98 <panic>
    release(&ftable.lock);
    80003c08:	00015517          	auipc	a0,0x15
    80003c0c:	77050513          	addi	a0,a0,1904 # 80019378 <ftable>
    80003c10:	00002097          	auipc	ra,0x2
    80003c14:	786080e7          	jalr	1926(ra) # 80006396 <release>
  }
}
    80003c18:	70e2                	ld	ra,56(sp)
    80003c1a:	7442                	ld	s0,48(sp)
    80003c1c:	74a2                	ld	s1,40(sp)
    80003c1e:	7902                	ld	s2,32(sp)
    80003c20:	69e2                	ld	s3,24(sp)
    80003c22:	6a42                	ld	s4,16(sp)
    80003c24:	6aa2                	ld	s5,8(sp)
    80003c26:	6121                	addi	sp,sp,64
    80003c28:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c2a:	85d6                	mv	a1,s5
    80003c2c:	8552                	mv	a0,s4
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	34c080e7          	jalr	844(ra) # 80003f7a <pipeclose>
    80003c36:	b7cd                	j	80003c18 <fileclose+0xa8>

0000000080003c38 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c38:	715d                	addi	sp,sp,-80
    80003c3a:	e486                	sd	ra,72(sp)
    80003c3c:	e0a2                	sd	s0,64(sp)
    80003c3e:	fc26                	sd	s1,56(sp)
    80003c40:	f84a                	sd	s2,48(sp)
    80003c42:	f44e                	sd	s3,40(sp)
    80003c44:	0880                	addi	s0,sp,80
    80003c46:	84aa                	mv	s1,a0
    80003c48:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c4a:	ffffd097          	auipc	ra,0xffffd
    80003c4e:	2f4080e7          	jalr	756(ra) # 80000f3e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c52:	409c                	lw	a5,0(s1)
    80003c54:	37f9                	addiw	a5,a5,-2
    80003c56:	4705                	li	a4,1
    80003c58:	04f76763          	bltu	a4,a5,80003ca6 <filestat+0x6e>
    80003c5c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c5e:	6c88                	ld	a0,24(s1)
    80003c60:	fffff097          	auipc	ra,0xfffff
    80003c64:	072080e7          	jalr	114(ra) # 80002cd2 <ilock>
    stati(f->ip, &st);
    80003c68:	fb840593          	addi	a1,s0,-72
    80003c6c:	6c88                	ld	a0,24(s1)
    80003c6e:	fffff097          	auipc	ra,0xfffff
    80003c72:	2ee080e7          	jalr	750(ra) # 80002f5c <stati>
    iunlock(f->ip);
    80003c76:	6c88                	ld	a0,24(s1)
    80003c78:	fffff097          	auipc	ra,0xfffff
    80003c7c:	11c080e7          	jalr	284(ra) # 80002d94 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c80:	46e1                	li	a3,24
    80003c82:	fb840613          	addi	a2,s0,-72
    80003c86:	85ce                	mv	a1,s3
    80003c88:	05093503          	ld	a0,80(s2)
    80003c8c:	ffffd097          	auipc	ra,0xffffd
    80003c90:	f78080e7          	jalr	-136(ra) # 80000c04 <copyout>
    80003c94:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c98:	60a6                	ld	ra,72(sp)
    80003c9a:	6406                	ld	s0,64(sp)
    80003c9c:	74e2                	ld	s1,56(sp)
    80003c9e:	7942                	ld	s2,48(sp)
    80003ca0:	79a2                	ld	s3,40(sp)
    80003ca2:	6161                	addi	sp,sp,80
    80003ca4:	8082                	ret
  return -1;
    80003ca6:	557d                	li	a0,-1
    80003ca8:	bfc5                	j	80003c98 <filestat+0x60>

0000000080003caa <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003caa:	7179                	addi	sp,sp,-48
    80003cac:	f406                	sd	ra,40(sp)
    80003cae:	f022                	sd	s0,32(sp)
    80003cb0:	ec26                	sd	s1,24(sp)
    80003cb2:	e84a                	sd	s2,16(sp)
    80003cb4:	e44e                	sd	s3,8(sp)
    80003cb6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cb8:	00854783          	lbu	a5,8(a0)
    80003cbc:	c3d5                	beqz	a5,80003d60 <fileread+0xb6>
    80003cbe:	84aa                	mv	s1,a0
    80003cc0:	89ae                	mv	s3,a1
    80003cc2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cc4:	411c                	lw	a5,0(a0)
    80003cc6:	4705                	li	a4,1
    80003cc8:	04e78963          	beq	a5,a4,80003d1a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ccc:	470d                	li	a4,3
    80003cce:	04e78d63          	beq	a5,a4,80003d28 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cd2:	4709                	li	a4,2
    80003cd4:	06e79e63          	bne	a5,a4,80003d50 <fileread+0xa6>
    ilock(f->ip);
    80003cd8:	6d08                	ld	a0,24(a0)
    80003cda:	fffff097          	auipc	ra,0xfffff
    80003cde:	ff8080e7          	jalr	-8(ra) # 80002cd2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ce2:	874a                	mv	a4,s2
    80003ce4:	5094                	lw	a3,32(s1)
    80003ce6:	864e                	mv	a2,s3
    80003ce8:	4585                	li	a1,1
    80003cea:	6c88                	ld	a0,24(s1)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	29a080e7          	jalr	666(ra) # 80002f86 <readi>
    80003cf4:	892a                	mv	s2,a0
    80003cf6:	00a05563          	blez	a0,80003d00 <fileread+0x56>
      f->off += r;
    80003cfa:	509c                	lw	a5,32(s1)
    80003cfc:	9fa9                	addw	a5,a5,a0
    80003cfe:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d00:	6c88                	ld	a0,24(s1)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	092080e7          	jalr	146(ra) # 80002d94 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d0a:	854a                	mv	a0,s2
    80003d0c:	70a2                	ld	ra,40(sp)
    80003d0e:	7402                	ld	s0,32(sp)
    80003d10:	64e2                	ld	s1,24(sp)
    80003d12:	6942                	ld	s2,16(sp)
    80003d14:	69a2                	ld	s3,8(sp)
    80003d16:	6145                	addi	sp,sp,48
    80003d18:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d1a:	6908                	ld	a0,16(a0)
    80003d1c:	00000097          	auipc	ra,0x0
    80003d20:	3c8080e7          	jalr	968(ra) # 800040e4 <piperead>
    80003d24:	892a                	mv	s2,a0
    80003d26:	b7d5                	j	80003d0a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d28:	02451783          	lh	a5,36(a0)
    80003d2c:	03079693          	slli	a3,a5,0x30
    80003d30:	92c1                	srli	a3,a3,0x30
    80003d32:	4725                	li	a4,9
    80003d34:	02d76863          	bltu	a4,a3,80003d64 <fileread+0xba>
    80003d38:	0792                	slli	a5,a5,0x4
    80003d3a:	00015717          	auipc	a4,0x15
    80003d3e:	59e70713          	addi	a4,a4,1438 # 800192d8 <devsw>
    80003d42:	97ba                	add	a5,a5,a4
    80003d44:	639c                	ld	a5,0(a5)
    80003d46:	c38d                	beqz	a5,80003d68 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d48:	4505                	li	a0,1
    80003d4a:	9782                	jalr	a5
    80003d4c:	892a                	mv	s2,a0
    80003d4e:	bf75                	j	80003d0a <fileread+0x60>
    panic("fileread");
    80003d50:	00005517          	auipc	a0,0x5
    80003d54:	97850513          	addi	a0,a0,-1672 # 800086c8 <syscalls+0x2d0>
    80003d58:	00002097          	auipc	ra,0x2
    80003d5c:	040080e7          	jalr	64(ra) # 80005d98 <panic>
    return -1;
    80003d60:	597d                	li	s2,-1
    80003d62:	b765                	j	80003d0a <fileread+0x60>
      return -1;
    80003d64:	597d                	li	s2,-1
    80003d66:	b755                	j	80003d0a <fileread+0x60>
    80003d68:	597d                	li	s2,-1
    80003d6a:	b745                	j	80003d0a <fileread+0x60>

0000000080003d6c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d6c:	715d                	addi	sp,sp,-80
    80003d6e:	e486                	sd	ra,72(sp)
    80003d70:	e0a2                	sd	s0,64(sp)
    80003d72:	fc26                	sd	s1,56(sp)
    80003d74:	f84a                	sd	s2,48(sp)
    80003d76:	f44e                	sd	s3,40(sp)
    80003d78:	f052                	sd	s4,32(sp)
    80003d7a:	ec56                	sd	s5,24(sp)
    80003d7c:	e85a                	sd	s6,16(sp)
    80003d7e:	e45e                	sd	s7,8(sp)
    80003d80:	e062                	sd	s8,0(sp)
    80003d82:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d84:	00954783          	lbu	a5,9(a0)
    80003d88:	10078663          	beqz	a5,80003e94 <filewrite+0x128>
    80003d8c:	892a                	mv	s2,a0
    80003d8e:	8aae                	mv	s5,a1
    80003d90:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d92:	411c                	lw	a5,0(a0)
    80003d94:	4705                	li	a4,1
    80003d96:	02e78263          	beq	a5,a4,80003dba <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d9a:	470d                	li	a4,3
    80003d9c:	02e78663          	beq	a5,a4,80003dc8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003da0:	4709                	li	a4,2
    80003da2:	0ee79163          	bne	a5,a4,80003e84 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003da6:	0ac05d63          	blez	a2,80003e60 <filewrite+0xf4>
    int i = 0;
    80003daa:	4981                	li	s3,0
    80003dac:	6b05                	lui	s6,0x1
    80003dae:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003db2:	6b85                	lui	s7,0x1
    80003db4:	c00b8b9b          	addiw	s7,s7,-1024
    80003db8:	a861                	j	80003e50 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dba:	6908                	ld	a0,16(a0)
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	22e080e7          	jalr	558(ra) # 80003fea <pipewrite>
    80003dc4:	8a2a                	mv	s4,a0
    80003dc6:	a045                	j	80003e66 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dc8:	02451783          	lh	a5,36(a0)
    80003dcc:	03079693          	slli	a3,a5,0x30
    80003dd0:	92c1                	srli	a3,a3,0x30
    80003dd2:	4725                	li	a4,9
    80003dd4:	0cd76263          	bltu	a4,a3,80003e98 <filewrite+0x12c>
    80003dd8:	0792                	slli	a5,a5,0x4
    80003dda:	00015717          	auipc	a4,0x15
    80003dde:	4fe70713          	addi	a4,a4,1278 # 800192d8 <devsw>
    80003de2:	97ba                	add	a5,a5,a4
    80003de4:	679c                	ld	a5,8(a5)
    80003de6:	cbdd                	beqz	a5,80003e9c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003de8:	4505                	li	a0,1
    80003dea:	9782                	jalr	a5
    80003dec:	8a2a                	mv	s4,a0
    80003dee:	a8a5                	j	80003e66 <filewrite+0xfa>
    80003df0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003df4:	00000097          	auipc	ra,0x0
    80003df8:	8b0080e7          	jalr	-1872(ra) # 800036a4 <begin_op>
      ilock(f->ip);
    80003dfc:	01893503          	ld	a0,24(s2)
    80003e00:	fffff097          	auipc	ra,0xfffff
    80003e04:	ed2080e7          	jalr	-302(ra) # 80002cd2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e08:	8762                	mv	a4,s8
    80003e0a:	02092683          	lw	a3,32(s2)
    80003e0e:	01598633          	add	a2,s3,s5
    80003e12:	4585                	li	a1,1
    80003e14:	01893503          	ld	a0,24(s2)
    80003e18:	fffff097          	auipc	ra,0xfffff
    80003e1c:	266080e7          	jalr	614(ra) # 8000307e <writei>
    80003e20:	84aa                	mv	s1,a0
    80003e22:	00a05763          	blez	a0,80003e30 <filewrite+0xc4>
        f->off += r;
    80003e26:	02092783          	lw	a5,32(s2)
    80003e2a:	9fa9                	addw	a5,a5,a0
    80003e2c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e30:	01893503          	ld	a0,24(s2)
    80003e34:	fffff097          	auipc	ra,0xfffff
    80003e38:	f60080e7          	jalr	-160(ra) # 80002d94 <iunlock>
      end_op();
    80003e3c:	00000097          	auipc	ra,0x0
    80003e40:	8e8080e7          	jalr	-1816(ra) # 80003724 <end_op>

      if(r != n1){
    80003e44:	009c1f63          	bne	s8,s1,80003e62 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e48:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e4c:	0149db63          	bge	s3,s4,80003e62 <filewrite+0xf6>
      int n1 = n - i;
    80003e50:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e54:	84be                	mv	s1,a5
    80003e56:	2781                	sext.w	a5,a5
    80003e58:	f8fb5ce3          	bge	s6,a5,80003df0 <filewrite+0x84>
    80003e5c:	84de                	mv	s1,s7
    80003e5e:	bf49                	j	80003df0 <filewrite+0x84>
    int i = 0;
    80003e60:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e62:	013a1f63          	bne	s4,s3,80003e80 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e66:	8552                	mv	a0,s4
    80003e68:	60a6                	ld	ra,72(sp)
    80003e6a:	6406                	ld	s0,64(sp)
    80003e6c:	74e2                	ld	s1,56(sp)
    80003e6e:	7942                	ld	s2,48(sp)
    80003e70:	79a2                	ld	s3,40(sp)
    80003e72:	7a02                	ld	s4,32(sp)
    80003e74:	6ae2                	ld	s5,24(sp)
    80003e76:	6b42                	ld	s6,16(sp)
    80003e78:	6ba2                	ld	s7,8(sp)
    80003e7a:	6c02                	ld	s8,0(sp)
    80003e7c:	6161                	addi	sp,sp,80
    80003e7e:	8082                	ret
    ret = (i == n ? n : -1);
    80003e80:	5a7d                	li	s4,-1
    80003e82:	b7d5                	j	80003e66 <filewrite+0xfa>
    panic("filewrite");
    80003e84:	00005517          	auipc	a0,0x5
    80003e88:	85450513          	addi	a0,a0,-1964 # 800086d8 <syscalls+0x2e0>
    80003e8c:	00002097          	auipc	ra,0x2
    80003e90:	f0c080e7          	jalr	-244(ra) # 80005d98 <panic>
    return -1;
    80003e94:	5a7d                	li	s4,-1
    80003e96:	bfc1                	j	80003e66 <filewrite+0xfa>
      return -1;
    80003e98:	5a7d                	li	s4,-1
    80003e9a:	b7f1                	j	80003e66 <filewrite+0xfa>
    80003e9c:	5a7d                	li	s4,-1
    80003e9e:	b7e1                	j	80003e66 <filewrite+0xfa>

0000000080003ea0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ea0:	7179                	addi	sp,sp,-48
    80003ea2:	f406                	sd	ra,40(sp)
    80003ea4:	f022                	sd	s0,32(sp)
    80003ea6:	ec26                	sd	s1,24(sp)
    80003ea8:	e84a                	sd	s2,16(sp)
    80003eaa:	e44e                	sd	s3,8(sp)
    80003eac:	e052                	sd	s4,0(sp)
    80003eae:	1800                	addi	s0,sp,48
    80003eb0:	84aa                	mv	s1,a0
    80003eb2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003eb4:	0005b023          	sd	zero,0(a1)
    80003eb8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ebc:	00000097          	auipc	ra,0x0
    80003ec0:	bf8080e7          	jalr	-1032(ra) # 80003ab4 <filealloc>
    80003ec4:	e088                	sd	a0,0(s1)
    80003ec6:	c551                	beqz	a0,80003f52 <pipealloc+0xb2>
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	bec080e7          	jalr	-1044(ra) # 80003ab4 <filealloc>
    80003ed0:	00aa3023          	sd	a0,0(s4)
    80003ed4:	c92d                	beqz	a0,80003f46 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ed6:	ffffc097          	auipc	ra,0xffffc
    80003eda:	242080e7          	jalr	578(ra) # 80000118 <kalloc>
    80003ede:	892a                	mv	s2,a0
    80003ee0:	c125                	beqz	a0,80003f40 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ee2:	4985                	li	s3,1
    80003ee4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ee8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003eec:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ef0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ef4:	00004597          	auipc	a1,0x4
    80003ef8:	7f458593          	addi	a1,a1,2036 # 800086e8 <syscalls+0x2f0>
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	356080e7          	jalr	854(ra) # 80006252 <initlock>
  (*f0)->type = FD_PIPE;
    80003f04:	609c                	ld	a5,0(s1)
    80003f06:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f0a:	609c                	ld	a5,0(s1)
    80003f0c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f10:	609c                	ld	a5,0(s1)
    80003f12:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f16:	609c                	ld	a5,0(s1)
    80003f18:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f1c:	000a3783          	ld	a5,0(s4)
    80003f20:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f24:	000a3783          	ld	a5,0(s4)
    80003f28:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f2c:	000a3783          	ld	a5,0(s4)
    80003f30:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f34:	000a3783          	ld	a5,0(s4)
    80003f38:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f3c:	4501                	li	a0,0
    80003f3e:	a025                	j	80003f66 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f40:	6088                	ld	a0,0(s1)
    80003f42:	e501                	bnez	a0,80003f4a <pipealloc+0xaa>
    80003f44:	a039                	j	80003f52 <pipealloc+0xb2>
    80003f46:	6088                	ld	a0,0(s1)
    80003f48:	c51d                	beqz	a0,80003f76 <pipealloc+0xd6>
    fileclose(*f0);
    80003f4a:	00000097          	auipc	ra,0x0
    80003f4e:	c26080e7          	jalr	-986(ra) # 80003b70 <fileclose>
  if(*f1)
    80003f52:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f56:	557d                	li	a0,-1
  if(*f1)
    80003f58:	c799                	beqz	a5,80003f66 <pipealloc+0xc6>
    fileclose(*f1);
    80003f5a:	853e                	mv	a0,a5
    80003f5c:	00000097          	auipc	ra,0x0
    80003f60:	c14080e7          	jalr	-1004(ra) # 80003b70 <fileclose>
  return -1;
    80003f64:	557d                	li	a0,-1
}
    80003f66:	70a2                	ld	ra,40(sp)
    80003f68:	7402                	ld	s0,32(sp)
    80003f6a:	64e2                	ld	s1,24(sp)
    80003f6c:	6942                	ld	s2,16(sp)
    80003f6e:	69a2                	ld	s3,8(sp)
    80003f70:	6a02                	ld	s4,0(sp)
    80003f72:	6145                	addi	sp,sp,48
    80003f74:	8082                	ret
  return -1;
    80003f76:	557d                	li	a0,-1
    80003f78:	b7fd                	j	80003f66 <pipealloc+0xc6>

0000000080003f7a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f7a:	1101                	addi	sp,sp,-32
    80003f7c:	ec06                	sd	ra,24(sp)
    80003f7e:	e822                	sd	s0,16(sp)
    80003f80:	e426                	sd	s1,8(sp)
    80003f82:	e04a                	sd	s2,0(sp)
    80003f84:	1000                	addi	s0,sp,32
    80003f86:	84aa                	mv	s1,a0
    80003f88:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f8a:	00002097          	auipc	ra,0x2
    80003f8e:	358080e7          	jalr	856(ra) # 800062e2 <acquire>
  if(writable){
    80003f92:	02090d63          	beqz	s2,80003fcc <pipeclose+0x52>
    pi->writeopen = 0;
    80003f96:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f9a:	21848513          	addi	a0,s1,536
    80003f9e:	ffffe097          	auipc	ra,0xffffe
    80003fa2:	86e080e7          	jalr	-1938(ra) # 8000180c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fa6:	2204b783          	ld	a5,544(s1)
    80003faa:	eb95                	bnez	a5,80003fde <pipeclose+0x64>
    release(&pi->lock);
    80003fac:	8526                	mv	a0,s1
    80003fae:	00002097          	auipc	ra,0x2
    80003fb2:	3e8080e7          	jalr	1000(ra) # 80006396 <release>
    kfree((char*)pi);
    80003fb6:	8526                	mv	a0,s1
    80003fb8:	ffffc097          	auipc	ra,0xffffc
    80003fbc:	064080e7          	jalr	100(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fc0:	60e2                	ld	ra,24(sp)
    80003fc2:	6442                	ld	s0,16(sp)
    80003fc4:	64a2                	ld	s1,8(sp)
    80003fc6:	6902                	ld	s2,0(sp)
    80003fc8:	6105                	addi	sp,sp,32
    80003fca:	8082                	ret
    pi->readopen = 0;
    80003fcc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fd0:	21c48513          	addi	a0,s1,540
    80003fd4:	ffffe097          	auipc	ra,0xffffe
    80003fd8:	838080e7          	jalr	-1992(ra) # 8000180c <wakeup>
    80003fdc:	b7e9                	j	80003fa6 <pipeclose+0x2c>
    release(&pi->lock);
    80003fde:	8526                	mv	a0,s1
    80003fe0:	00002097          	auipc	ra,0x2
    80003fe4:	3b6080e7          	jalr	950(ra) # 80006396 <release>
}
    80003fe8:	bfe1                	j	80003fc0 <pipeclose+0x46>

0000000080003fea <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fea:	7159                	addi	sp,sp,-112
    80003fec:	f486                	sd	ra,104(sp)
    80003fee:	f0a2                	sd	s0,96(sp)
    80003ff0:	eca6                	sd	s1,88(sp)
    80003ff2:	e8ca                	sd	s2,80(sp)
    80003ff4:	e4ce                	sd	s3,72(sp)
    80003ff6:	e0d2                	sd	s4,64(sp)
    80003ff8:	fc56                	sd	s5,56(sp)
    80003ffa:	f85a                	sd	s6,48(sp)
    80003ffc:	f45e                	sd	s7,40(sp)
    80003ffe:	f062                	sd	s8,32(sp)
    80004000:	ec66                	sd	s9,24(sp)
    80004002:	1880                	addi	s0,sp,112
    80004004:	84aa                	mv	s1,a0
    80004006:	8aae                	mv	s5,a1
    80004008:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	f34080e7          	jalr	-204(ra) # 80000f3e <myproc>
    80004012:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004014:	8526                	mv	a0,s1
    80004016:	00002097          	auipc	ra,0x2
    8000401a:	2cc080e7          	jalr	716(ra) # 800062e2 <acquire>
  while(i < n){
    8000401e:	0d405163          	blez	s4,800040e0 <pipewrite+0xf6>
    80004022:	8ba6                	mv	s7,s1
  int i = 0;
    80004024:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004026:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004028:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000402c:	21c48c13          	addi	s8,s1,540
    80004030:	a08d                	j	80004092 <pipewrite+0xa8>
      release(&pi->lock);
    80004032:	8526                	mv	a0,s1
    80004034:	00002097          	auipc	ra,0x2
    80004038:	362080e7          	jalr	866(ra) # 80006396 <release>
      return -1;
    8000403c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000403e:	854a                	mv	a0,s2
    80004040:	70a6                	ld	ra,104(sp)
    80004042:	7406                	ld	s0,96(sp)
    80004044:	64e6                	ld	s1,88(sp)
    80004046:	6946                	ld	s2,80(sp)
    80004048:	69a6                	ld	s3,72(sp)
    8000404a:	6a06                	ld	s4,64(sp)
    8000404c:	7ae2                	ld	s5,56(sp)
    8000404e:	7b42                	ld	s6,48(sp)
    80004050:	7ba2                	ld	s7,40(sp)
    80004052:	7c02                	ld	s8,32(sp)
    80004054:	6ce2                	ld	s9,24(sp)
    80004056:	6165                	addi	sp,sp,112
    80004058:	8082                	ret
      wakeup(&pi->nread);
    8000405a:	8566                	mv	a0,s9
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	7b0080e7          	jalr	1968(ra) # 8000180c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004064:	85de                	mv	a1,s7
    80004066:	8562                	mv	a0,s8
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	618080e7          	jalr	1560(ra) # 80001680 <sleep>
    80004070:	a839                	j	8000408e <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004072:	21c4a783          	lw	a5,540(s1)
    80004076:	0017871b          	addiw	a4,a5,1
    8000407a:	20e4ae23          	sw	a4,540(s1)
    8000407e:	1ff7f793          	andi	a5,a5,511
    80004082:	97a6                	add	a5,a5,s1
    80004084:	f9f44703          	lbu	a4,-97(s0)
    80004088:	00e78c23          	sb	a4,24(a5)
      i++;
    8000408c:	2905                	addiw	s2,s2,1
  while(i < n){
    8000408e:	03495d63          	bge	s2,s4,800040c8 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004092:	2204a783          	lw	a5,544(s1)
    80004096:	dfd1                	beqz	a5,80004032 <pipewrite+0x48>
    80004098:	0289a783          	lw	a5,40(s3)
    8000409c:	fbd9                	bnez	a5,80004032 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000409e:	2184a783          	lw	a5,536(s1)
    800040a2:	21c4a703          	lw	a4,540(s1)
    800040a6:	2007879b          	addiw	a5,a5,512
    800040aa:	faf708e3          	beq	a4,a5,8000405a <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ae:	4685                	li	a3,1
    800040b0:	01590633          	add	a2,s2,s5
    800040b4:	f9f40593          	addi	a1,s0,-97
    800040b8:	0509b503          	ld	a0,80(s3)
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	bd4080e7          	jalr	-1068(ra) # 80000c90 <copyin>
    800040c4:	fb6517e3          	bne	a0,s6,80004072 <pipewrite+0x88>
  wakeup(&pi->nread);
    800040c8:	21848513          	addi	a0,s1,536
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	740080e7          	jalr	1856(ra) # 8000180c <wakeup>
  release(&pi->lock);
    800040d4:	8526                	mv	a0,s1
    800040d6:	00002097          	auipc	ra,0x2
    800040da:	2c0080e7          	jalr	704(ra) # 80006396 <release>
  return i;
    800040de:	b785                	j	8000403e <pipewrite+0x54>
  int i = 0;
    800040e0:	4901                	li	s2,0
    800040e2:	b7dd                	j	800040c8 <pipewrite+0xde>

00000000800040e4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040e4:	715d                	addi	sp,sp,-80
    800040e6:	e486                	sd	ra,72(sp)
    800040e8:	e0a2                	sd	s0,64(sp)
    800040ea:	fc26                	sd	s1,56(sp)
    800040ec:	f84a                	sd	s2,48(sp)
    800040ee:	f44e                	sd	s3,40(sp)
    800040f0:	f052                	sd	s4,32(sp)
    800040f2:	ec56                	sd	s5,24(sp)
    800040f4:	e85a                	sd	s6,16(sp)
    800040f6:	0880                	addi	s0,sp,80
    800040f8:	84aa                	mv	s1,a0
    800040fa:	892e                	mv	s2,a1
    800040fc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040fe:	ffffd097          	auipc	ra,0xffffd
    80004102:	e40080e7          	jalr	-448(ra) # 80000f3e <myproc>
    80004106:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004108:	8b26                	mv	s6,s1
    8000410a:	8526                	mv	a0,s1
    8000410c:	00002097          	auipc	ra,0x2
    80004110:	1d6080e7          	jalr	470(ra) # 800062e2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004114:	2184a703          	lw	a4,536(s1)
    80004118:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000411c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004120:	02f71463          	bne	a4,a5,80004148 <piperead+0x64>
    80004124:	2244a783          	lw	a5,548(s1)
    80004128:	c385                	beqz	a5,80004148 <piperead+0x64>
    if(pr->killed){
    8000412a:	028a2783          	lw	a5,40(s4)
    8000412e:	ebc1                	bnez	a5,800041be <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004130:	85da                	mv	a1,s6
    80004132:	854e                	mv	a0,s3
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	54c080e7          	jalr	1356(ra) # 80001680 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000413c:	2184a703          	lw	a4,536(s1)
    80004140:	21c4a783          	lw	a5,540(s1)
    80004144:	fef700e3          	beq	a4,a5,80004124 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004148:	09505263          	blez	s5,800041cc <piperead+0xe8>
    8000414c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000414e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004150:	2184a783          	lw	a5,536(s1)
    80004154:	21c4a703          	lw	a4,540(s1)
    80004158:	02f70d63          	beq	a4,a5,80004192 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000415c:	0017871b          	addiw	a4,a5,1
    80004160:	20e4ac23          	sw	a4,536(s1)
    80004164:	1ff7f793          	andi	a5,a5,511
    80004168:	97a6                	add	a5,a5,s1
    8000416a:	0187c783          	lbu	a5,24(a5)
    8000416e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004172:	4685                	li	a3,1
    80004174:	fbf40613          	addi	a2,s0,-65
    80004178:	85ca                	mv	a1,s2
    8000417a:	050a3503          	ld	a0,80(s4)
    8000417e:	ffffd097          	auipc	ra,0xffffd
    80004182:	a86080e7          	jalr	-1402(ra) # 80000c04 <copyout>
    80004186:	01650663          	beq	a0,s6,80004192 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000418a:	2985                	addiw	s3,s3,1
    8000418c:	0905                	addi	s2,s2,1
    8000418e:	fd3a91e3          	bne	s5,s3,80004150 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004192:	21c48513          	addi	a0,s1,540
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	676080e7          	jalr	1654(ra) # 8000180c <wakeup>
  release(&pi->lock);
    8000419e:	8526                	mv	a0,s1
    800041a0:	00002097          	auipc	ra,0x2
    800041a4:	1f6080e7          	jalr	502(ra) # 80006396 <release>
  return i;
}
    800041a8:	854e                	mv	a0,s3
    800041aa:	60a6                	ld	ra,72(sp)
    800041ac:	6406                	ld	s0,64(sp)
    800041ae:	74e2                	ld	s1,56(sp)
    800041b0:	7942                	ld	s2,48(sp)
    800041b2:	79a2                	ld	s3,40(sp)
    800041b4:	7a02                	ld	s4,32(sp)
    800041b6:	6ae2                	ld	s5,24(sp)
    800041b8:	6b42                	ld	s6,16(sp)
    800041ba:	6161                	addi	sp,sp,80
    800041bc:	8082                	ret
      release(&pi->lock);
    800041be:	8526                	mv	a0,s1
    800041c0:	00002097          	auipc	ra,0x2
    800041c4:	1d6080e7          	jalr	470(ra) # 80006396 <release>
      return -1;
    800041c8:	59fd                	li	s3,-1
    800041ca:	bff9                	j	800041a8 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041cc:	4981                	li	s3,0
    800041ce:	b7d1                	j	80004192 <piperead+0xae>

00000000800041d0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041d0:	df010113          	addi	sp,sp,-528
    800041d4:	20113423          	sd	ra,520(sp)
    800041d8:	20813023          	sd	s0,512(sp)
    800041dc:	ffa6                	sd	s1,504(sp)
    800041de:	fbca                	sd	s2,496(sp)
    800041e0:	f7ce                	sd	s3,488(sp)
    800041e2:	f3d2                	sd	s4,480(sp)
    800041e4:	efd6                	sd	s5,472(sp)
    800041e6:	ebda                	sd	s6,464(sp)
    800041e8:	e7de                	sd	s7,456(sp)
    800041ea:	e3e2                	sd	s8,448(sp)
    800041ec:	ff66                	sd	s9,440(sp)
    800041ee:	fb6a                	sd	s10,432(sp)
    800041f0:	f76e                	sd	s11,424(sp)
    800041f2:	0c00                	addi	s0,sp,528
    800041f4:	84aa                	mv	s1,a0
    800041f6:	dea43c23          	sd	a0,-520(s0)
    800041fa:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	d40080e7          	jalr	-704(ra) # 80000f3e <myproc>
    80004206:	892a                	mv	s2,a0

  begin_op();
    80004208:	fffff097          	auipc	ra,0xfffff
    8000420c:	49c080e7          	jalr	1180(ra) # 800036a4 <begin_op>

  if((ip = namei(path)) == 0){
    80004210:	8526                	mv	a0,s1
    80004212:	fffff097          	auipc	ra,0xfffff
    80004216:	276080e7          	jalr	630(ra) # 80003488 <namei>
    8000421a:	c92d                	beqz	a0,8000428c <exec+0xbc>
    8000421c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	ab4080e7          	jalr	-1356(ra) # 80002cd2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004226:	04000713          	li	a4,64
    8000422a:	4681                	li	a3,0
    8000422c:	e5040613          	addi	a2,s0,-432
    80004230:	4581                	li	a1,0
    80004232:	8526                	mv	a0,s1
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	d52080e7          	jalr	-686(ra) # 80002f86 <readi>
    8000423c:	04000793          	li	a5,64
    80004240:	00f51a63          	bne	a0,a5,80004254 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004244:	e5042703          	lw	a4,-432(s0)
    80004248:	464c47b7          	lui	a5,0x464c4
    8000424c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004250:	04f70463          	beq	a4,a5,80004298 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004254:	8526                	mv	a0,s1
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	cde080e7          	jalr	-802(ra) # 80002f34 <iunlockput>
    end_op();
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	4c6080e7          	jalr	1222(ra) # 80003724 <end_op>
  }
  return -1;
    80004266:	557d                	li	a0,-1
}
    80004268:	20813083          	ld	ra,520(sp)
    8000426c:	20013403          	ld	s0,512(sp)
    80004270:	74fe                	ld	s1,504(sp)
    80004272:	795e                	ld	s2,496(sp)
    80004274:	79be                	ld	s3,488(sp)
    80004276:	7a1e                	ld	s4,480(sp)
    80004278:	6afe                	ld	s5,472(sp)
    8000427a:	6b5e                	ld	s6,464(sp)
    8000427c:	6bbe                	ld	s7,456(sp)
    8000427e:	6c1e                	ld	s8,448(sp)
    80004280:	7cfa                	ld	s9,440(sp)
    80004282:	7d5a                	ld	s10,432(sp)
    80004284:	7dba                	ld	s11,424(sp)
    80004286:	21010113          	addi	sp,sp,528
    8000428a:	8082                	ret
    end_op();
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	498080e7          	jalr	1176(ra) # 80003724 <end_op>
    return -1;
    80004294:	557d                	li	a0,-1
    80004296:	bfc9                	j	80004268 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004298:	854a                	mv	a0,s2
    8000429a:	ffffd097          	auipc	ra,0xffffd
    8000429e:	d68080e7          	jalr	-664(ra) # 80001002 <proc_pagetable>
    800042a2:	8baa                	mv	s7,a0
    800042a4:	d945                	beqz	a0,80004254 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042a6:	e7042983          	lw	s3,-400(s0)
    800042aa:	e8845783          	lhu	a5,-376(s0)
    800042ae:	c7ad                	beqz	a5,80004318 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042b0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b2:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042b4:	6c85                	lui	s9,0x1
    800042b6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042ba:	def43823          	sd	a5,-528(s0)
    800042be:	a489                	j	80004500 <exec+0x330>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042c0:	00004517          	auipc	a0,0x4
    800042c4:	43050513          	addi	a0,a0,1072 # 800086f0 <syscalls+0x2f8>
    800042c8:	00002097          	auipc	ra,0x2
    800042cc:	ad0080e7          	jalr	-1328(ra) # 80005d98 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042d0:	8756                	mv	a4,s5
    800042d2:	012d86bb          	addw	a3,s11,s2
    800042d6:	4581                	li	a1,0
    800042d8:	8526                	mv	a0,s1
    800042da:	fffff097          	auipc	ra,0xfffff
    800042de:	cac080e7          	jalr	-852(ra) # 80002f86 <readi>
    800042e2:	2501                	sext.w	a0,a0
    800042e4:	1caa9563          	bne	s5,a0,800044ae <exec+0x2de>
  for(i = 0; i < sz; i += PGSIZE){
    800042e8:	6785                	lui	a5,0x1
    800042ea:	0127893b          	addw	s2,a5,s2
    800042ee:	77fd                	lui	a5,0xfffff
    800042f0:	01478a3b          	addw	s4,a5,s4
    800042f4:	1f897d63          	bgeu	s2,s8,800044ee <exec+0x31e>
    pa = walkaddr(pagetable, va + i);
    800042f8:	02091593          	slli	a1,s2,0x20
    800042fc:	9181                	srli	a1,a1,0x20
    800042fe:	95ea                	add	a1,a1,s10
    80004300:	855e                	mv	a0,s7
    80004302:	ffffc097          	auipc	ra,0xffffc
    80004306:	204080e7          	jalr	516(ra) # 80000506 <walkaddr>
    8000430a:	862a                	mv	a2,a0
    if(pa == 0)
    8000430c:	d955                	beqz	a0,800042c0 <exec+0xf0>
      n = PGSIZE;
    8000430e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004310:	fd9a70e3          	bgeu	s4,s9,800042d0 <exec+0x100>
      n = sz - i;
    80004314:	8ad2                	mv	s5,s4
    80004316:	bf6d                	j	800042d0 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004318:	4901                	li	s2,0
  iunlockput(ip);
    8000431a:	8526                	mv	a0,s1
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	c18080e7          	jalr	-1000(ra) # 80002f34 <iunlockput>
  end_op();
    80004324:	fffff097          	auipc	ra,0xfffff
    80004328:	400080e7          	jalr	1024(ra) # 80003724 <end_op>
  p = myproc();
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	c12080e7          	jalr	-1006(ra) # 80000f3e <myproc>
    80004334:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004336:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000433a:	6785                	lui	a5,0x1
    8000433c:	17fd                	addi	a5,a5,-1
    8000433e:	993e                	add	s2,s2,a5
    80004340:	757d                	lui	a0,0xfffff
    80004342:	00a977b3          	and	a5,s2,a0
    80004346:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000434a:	6609                	lui	a2,0x2
    8000434c:	963e                	add	a2,a2,a5
    8000434e:	85be                	mv	a1,a5
    80004350:	855e                	mv	a0,s7
    80004352:	ffffc097          	auipc	ra,0xffffc
    80004356:	568080e7          	jalr	1384(ra) # 800008ba <uvmalloc>
    8000435a:	8b2a                	mv	s6,a0
  ip = 0;
    8000435c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000435e:	14050863          	beqz	a0,800044ae <exec+0x2de>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004362:	75f9                	lui	a1,0xffffe
    80004364:	95aa                	add	a1,a1,a0
    80004366:	855e                	mv	a0,s7
    80004368:	ffffd097          	auipc	ra,0xffffd
    8000436c:	86a080e7          	jalr	-1942(ra) # 80000bd2 <uvmclear>
  stackbase = sp - PGSIZE;
    80004370:	7c7d                	lui	s8,0xfffff
    80004372:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004374:	e0043783          	ld	a5,-512(s0)
    80004378:	6388                	ld	a0,0(a5)
    8000437a:	c535                	beqz	a0,800043e6 <exec+0x216>
    8000437c:	e9040993          	addi	s3,s0,-368
    80004380:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004384:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	f76080e7          	jalr	-138(ra) # 800002fc <strlen>
    8000438e:	2505                	addiw	a0,a0,1
    80004390:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004394:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004398:	13896f63          	bltu	s2,s8,800044d6 <exec+0x306>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000439c:	e0043d83          	ld	s11,-512(s0)
    800043a0:	000dba03          	ld	s4,0(s11)
    800043a4:	8552                	mv	a0,s4
    800043a6:	ffffc097          	auipc	ra,0xffffc
    800043aa:	f56080e7          	jalr	-170(ra) # 800002fc <strlen>
    800043ae:	0015069b          	addiw	a3,a0,1
    800043b2:	8652                	mv	a2,s4
    800043b4:	85ca                	mv	a1,s2
    800043b6:	855e                	mv	a0,s7
    800043b8:	ffffd097          	auipc	ra,0xffffd
    800043bc:	84c080e7          	jalr	-1972(ra) # 80000c04 <copyout>
    800043c0:	10054f63          	bltz	a0,800044de <exec+0x30e>
    ustack[argc] = sp;
    800043c4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043c8:	0485                	addi	s1,s1,1
    800043ca:	008d8793          	addi	a5,s11,8
    800043ce:	e0f43023          	sd	a5,-512(s0)
    800043d2:	008db503          	ld	a0,8(s11)
    800043d6:	c911                	beqz	a0,800043ea <exec+0x21a>
    if(argc >= MAXARG)
    800043d8:	09a1                	addi	s3,s3,8
    800043da:	fb3c96e3          	bne	s9,s3,80004386 <exec+0x1b6>
  sz = sz1;
    800043de:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e2:	4481                	li	s1,0
    800043e4:	a0e9                	j	800044ae <exec+0x2de>
  sp = sz;
    800043e6:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043e8:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ea:	00349793          	slli	a5,s1,0x3
    800043ee:	f9040713          	addi	a4,s0,-112
    800043f2:	97ba                	add	a5,a5,a4
    800043f4:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043f8:	00148693          	addi	a3,s1,1
    800043fc:	068e                	slli	a3,a3,0x3
    800043fe:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004402:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004406:	01897663          	bgeu	s2,s8,80004412 <exec+0x242>
  sz = sz1;
    8000440a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000440e:	4481                	li	s1,0
    80004410:	a879                	j	800044ae <exec+0x2de>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004412:	e9040613          	addi	a2,s0,-368
    80004416:	85ca                	mv	a1,s2
    80004418:	855e                	mv	a0,s7
    8000441a:	ffffc097          	auipc	ra,0xffffc
    8000441e:	7ea080e7          	jalr	2026(ra) # 80000c04 <copyout>
    80004422:	0c054263          	bltz	a0,800044e6 <exec+0x316>
  p->trapframe->a1 = sp;
    80004426:	058ab783          	ld	a5,88(s5)
    8000442a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000442e:	df843783          	ld	a5,-520(s0)
    80004432:	0007c703          	lbu	a4,0(a5)
    80004436:	cf11                	beqz	a4,80004452 <exec+0x282>
    80004438:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000443a:	02f00693          	li	a3,47
    8000443e:	a039                	j	8000444c <exec+0x27c>
      last = s+1;
    80004440:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004444:	0785                	addi	a5,a5,1
    80004446:	fff7c703          	lbu	a4,-1(a5)
    8000444a:	c701                	beqz	a4,80004452 <exec+0x282>
    if(*s == '/')
    8000444c:	fed71ce3          	bne	a4,a3,80004444 <exec+0x274>
    80004450:	bfc5                	j	80004440 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004452:	4641                	li	a2,16
    80004454:	df843583          	ld	a1,-520(s0)
    80004458:	158a8513          	addi	a0,s5,344
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	e6e080e7          	jalr	-402(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004464:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004468:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000446c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004470:	058ab783          	ld	a5,88(s5)
    80004474:	e6843703          	ld	a4,-408(s0)
    80004478:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000447a:	058ab783          	ld	a5,88(s5)
    8000447e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004482:	85ea                	mv	a1,s10
    80004484:	ffffd097          	auipc	ra,0xffffd
    80004488:	c48080e7          	jalr	-952(ra) # 800010cc <proc_freepagetable>
 if(p->pid==1) 
    8000448c:	030aa703          	lw	a4,48(s5)
    80004490:	4785                	li	a5,1
    80004492:	00f70563          	beq	a4,a5,8000449c <exec+0x2cc>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004496:	0004851b          	sext.w	a0,s1
    8000449a:	b3f9                	j	80004268 <exec+0x98>
   vmprint(p->pagetable);
    8000449c:	050ab503          	ld	a0,80(s5)
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	52e080e7          	jalr	1326(ra) # 800009ce <vmprint>
    800044a8:	b7fd                	j	80004496 <exec+0x2c6>
    800044aa:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044ae:	e0843583          	ld	a1,-504(s0)
    800044b2:	855e                	mv	a0,s7
    800044b4:	ffffd097          	auipc	ra,0xffffd
    800044b8:	c18080e7          	jalr	-1000(ra) # 800010cc <proc_freepagetable>
  if(ip){
    800044bc:	d8049ce3          	bnez	s1,80004254 <exec+0x84>
  return -1;
    800044c0:	557d                	li	a0,-1
    800044c2:	b35d                	j	80004268 <exec+0x98>
    800044c4:	e1243423          	sd	s2,-504(s0)
    800044c8:	b7dd                	j	800044ae <exec+0x2de>
    800044ca:	e1243423          	sd	s2,-504(s0)
    800044ce:	b7c5                	j	800044ae <exec+0x2de>
    800044d0:	e1243423          	sd	s2,-504(s0)
    800044d4:	bfe9                	j	800044ae <exec+0x2de>
  sz = sz1;
    800044d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044da:	4481                	li	s1,0
    800044dc:	bfc9                	j	800044ae <exec+0x2de>
  sz = sz1;
    800044de:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044e2:	4481                	li	s1,0
    800044e4:	b7e9                	j	800044ae <exec+0x2de>
  sz = sz1;
    800044e6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ea:	4481                	li	s1,0
    800044ec:	b7c9                	j	800044ae <exec+0x2de>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044ee:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044f2:	2b05                	addiw	s6,s6,1
    800044f4:	0389899b          	addiw	s3,s3,56
    800044f8:	e8845783          	lhu	a5,-376(s0)
    800044fc:	e0fb5fe3          	bge	s6,a5,8000431a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004500:	2981                	sext.w	s3,s3
    80004502:	03800713          	li	a4,56
    80004506:	86ce                	mv	a3,s3
    80004508:	e1840613          	addi	a2,s0,-488
    8000450c:	4581                	li	a1,0
    8000450e:	8526                	mv	a0,s1
    80004510:	fffff097          	auipc	ra,0xfffff
    80004514:	a76080e7          	jalr	-1418(ra) # 80002f86 <readi>
    80004518:	03800793          	li	a5,56
    8000451c:	f8f517e3          	bne	a0,a5,800044aa <exec+0x2da>
    if(ph.type != ELF_PROG_LOAD)
    80004520:	e1842783          	lw	a5,-488(s0)
    80004524:	4705                	li	a4,1
    80004526:	fce796e3          	bne	a5,a4,800044f2 <exec+0x322>
    if(ph.memsz < ph.filesz)
    8000452a:	e4043603          	ld	a2,-448(s0)
    8000452e:	e3843783          	ld	a5,-456(s0)
    80004532:	f8f669e3          	bltu	a2,a5,800044c4 <exec+0x2f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004536:	e2843783          	ld	a5,-472(s0)
    8000453a:	963e                	add	a2,a2,a5
    8000453c:	f8f667e3          	bltu	a2,a5,800044ca <exec+0x2fa>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004540:	85ca                	mv	a1,s2
    80004542:	855e                	mv	a0,s7
    80004544:	ffffc097          	auipc	ra,0xffffc
    80004548:	376080e7          	jalr	886(ra) # 800008ba <uvmalloc>
    8000454c:	e0a43423          	sd	a0,-504(s0)
    80004550:	d141                	beqz	a0,800044d0 <exec+0x300>
    if((ph.vaddr % PGSIZE) != 0)
    80004552:	e2843d03          	ld	s10,-472(s0)
    80004556:	df043783          	ld	a5,-528(s0)
    8000455a:	00fd77b3          	and	a5,s10,a5
    8000455e:	fba1                	bnez	a5,800044ae <exec+0x2de>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004560:	e2042d83          	lw	s11,-480(s0)
    80004564:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004568:	f80c03e3          	beqz	s8,800044ee <exec+0x31e>
    8000456c:	8a62                	mv	s4,s8
    8000456e:	4901                	li	s2,0
    80004570:	b361                	j	800042f8 <exec+0x128>

0000000080004572 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004572:	7179                	addi	sp,sp,-48
    80004574:	f406                	sd	ra,40(sp)
    80004576:	f022                	sd	s0,32(sp)
    80004578:	ec26                	sd	s1,24(sp)
    8000457a:	e84a                	sd	s2,16(sp)
    8000457c:	1800                	addi	s0,sp,48
    8000457e:	892e                	mv	s2,a1
    80004580:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004582:	fdc40593          	addi	a1,s0,-36
    80004586:	ffffe097          	auipc	ra,0xffffe
    8000458a:	aea080e7          	jalr	-1302(ra) # 80002070 <argint>
    8000458e:	04054063          	bltz	a0,800045ce <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004592:	fdc42703          	lw	a4,-36(s0)
    80004596:	47bd                	li	a5,15
    80004598:	02e7ed63          	bltu	a5,a4,800045d2 <argfd+0x60>
    8000459c:	ffffd097          	auipc	ra,0xffffd
    800045a0:	9a2080e7          	jalr	-1630(ra) # 80000f3e <myproc>
    800045a4:	fdc42703          	lw	a4,-36(s0)
    800045a8:	01a70793          	addi	a5,a4,26
    800045ac:	078e                	slli	a5,a5,0x3
    800045ae:	953e                	add	a0,a0,a5
    800045b0:	611c                	ld	a5,0(a0)
    800045b2:	c395                	beqz	a5,800045d6 <argfd+0x64>
    return -1;
  if(pfd)
    800045b4:	00090463          	beqz	s2,800045bc <argfd+0x4a>
    *pfd = fd;
    800045b8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045bc:	4501                	li	a0,0
  if(pf)
    800045be:	c091                	beqz	s1,800045c2 <argfd+0x50>
    *pf = f;
    800045c0:	e09c                	sd	a5,0(s1)
}
    800045c2:	70a2                	ld	ra,40(sp)
    800045c4:	7402                	ld	s0,32(sp)
    800045c6:	64e2                	ld	s1,24(sp)
    800045c8:	6942                	ld	s2,16(sp)
    800045ca:	6145                	addi	sp,sp,48
    800045cc:	8082                	ret
    return -1;
    800045ce:	557d                	li	a0,-1
    800045d0:	bfcd                	j	800045c2 <argfd+0x50>
    return -1;
    800045d2:	557d                	li	a0,-1
    800045d4:	b7fd                	j	800045c2 <argfd+0x50>
    800045d6:	557d                	li	a0,-1
    800045d8:	b7ed                	j	800045c2 <argfd+0x50>

00000000800045da <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045da:	1101                	addi	sp,sp,-32
    800045dc:	ec06                	sd	ra,24(sp)
    800045de:	e822                	sd	s0,16(sp)
    800045e0:	e426                	sd	s1,8(sp)
    800045e2:	1000                	addi	s0,sp,32
    800045e4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045e6:	ffffd097          	auipc	ra,0xffffd
    800045ea:	958080e7          	jalr	-1704(ra) # 80000f3e <myproc>
    800045ee:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045f0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800045f4:	4501                	li	a0,0
    800045f6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045f8:	6398                	ld	a4,0(a5)
    800045fa:	cb19                	beqz	a4,80004610 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045fc:	2505                	addiw	a0,a0,1
    800045fe:	07a1                	addi	a5,a5,8
    80004600:	fed51ce3          	bne	a0,a3,800045f8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004604:	557d                	li	a0,-1
}
    80004606:	60e2                	ld	ra,24(sp)
    80004608:	6442                	ld	s0,16(sp)
    8000460a:	64a2                	ld	s1,8(sp)
    8000460c:	6105                	addi	sp,sp,32
    8000460e:	8082                	ret
      p->ofile[fd] = f;
    80004610:	01a50793          	addi	a5,a0,26
    80004614:	078e                	slli	a5,a5,0x3
    80004616:	963e                	add	a2,a2,a5
    80004618:	e204                	sd	s1,0(a2)
      return fd;
    8000461a:	b7f5                	j	80004606 <fdalloc+0x2c>

000000008000461c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000461c:	715d                	addi	sp,sp,-80
    8000461e:	e486                	sd	ra,72(sp)
    80004620:	e0a2                	sd	s0,64(sp)
    80004622:	fc26                	sd	s1,56(sp)
    80004624:	f84a                	sd	s2,48(sp)
    80004626:	f44e                	sd	s3,40(sp)
    80004628:	f052                	sd	s4,32(sp)
    8000462a:	ec56                	sd	s5,24(sp)
    8000462c:	0880                	addi	s0,sp,80
    8000462e:	89ae                	mv	s3,a1
    80004630:	8ab2                	mv	s5,a2
    80004632:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004634:	fb040593          	addi	a1,s0,-80
    80004638:	fffff097          	auipc	ra,0xfffff
    8000463c:	e6e080e7          	jalr	-402(ra) # 800034a6 <nameiparent>
    80004640:	892a                	mv	s2,a0
    80004642:	12050f63          	beqz	a0,80004780 <create+0x164>
    return 0;

  ilock(dp);
    80004646:	ffffe097          	auipc	ra,0xffffe
    8000464a:	68c080e7          	jalr	1676(ra) # 80002cd2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000464e:	4601                	li	a2,0
    80004650:	fb040593          	addi	a1,s0,-80
    80004654:	854a                	mv	a0,s2
    80004656:	fffff097          	auipc	ra,0xfffff
    8000465a:	b60080e7          	jalr	-1184(ra) # 800031b6 <dirlookup>
    8000465e:	84aa                	mv	s1,a0
    80004660:	c921                	beqz	a0,800046b0 <create+0x94>
    iunlockput(dp);
    80004662:	854a                	mv	a0,s2
    80004664:	fffff097          	auipc	ra,0xfffff
    80004668:	8d0080e7          	jalr	-1840(ra) # 80002f34 <iunlockput>
    ilock(ip);
    8000466c:	8526                	mv	a0,s1
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	664080e7          	jalr	1636(ra) # 80002cd2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004676:	2981                	sext.w	s3,s3
    80004678:	4789                	li	a5,2
    8000467a:	02f99463          	bne	s3,a5,800046a2 <create+0x86>
    8000467e:	0444d783          	lhu	a5,68(s1)
    80004682:	37f9                	addiw	a5,a5,-2
    80004684:	17c2                	slli	a5,a5,0x30
    80004686:	93c1                	srli	a5,a5,0x30
    80004688:	4705                	li	a4,1
    8000468a:	00f76c63          	bltu	a4,a5,800046a2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000468e:	8526                	mv	a0,s1
    80004690:	60a6                	ld	ra,72(sp)
    80004692:	6406                	ld	s0,64(sp)
    80004694:	74e2                	ld	s1,56(sp)
    80004696:	7942                	ld	s2,48(sp)
    80004698:	79a2                	ld	s3,40(sp)
    8000469a:	7a02                	ld	s4,32(sp)
    8000469c:	6ae2                	ld	s5,24(sp)
    8000469e:	6161                	addi	sp,sp,80
    800046a0:	8082                	ret
    iunlockput(ip);
    800046a2:	8526                	mv	a0,s1
    800046a4:	fffff097          	auipc	ra,0xfffff
    800046a8:	890080e7          	jalr	-1904(ra) # 80002f34 <iunlockput>
    return 0;
    800046ac:	4481                	li	s1,0
    800046ae:	b7c5                	j	8000468e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046b0:	85ce                	mv	a1,s3
    800046b2:	00092503          	lw	a0,0(s2)
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	484080e7          	jalr	1156(ra) # 80002b3a <ialloc>
    800046be:	84aa                	mv	s1,a0
    800046c0:	c529                	beqz	a0,8000470a <create+0xee>
  ilock(ip);
    800046c2:	ffffe097          	auipc	ra,0xffffe
    800046c6:	610080e7          	jalr	1552(ra) # 80002cd2 <ilock>
  ip->major = major;
    800046ca:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046ce:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046d2:	4785                	li	a5,1
    800046d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800046d8:	8526                	mv	a0,s1
    800046da:	ffffe097          	auipc	ra,0xffffe
    800046de:	52e080e7          	jalr	1326(ra) # 80002c08 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046e2:	2981                	sext.w	s3,s3
    800046e4:	4785                	li	a5,1
    800046e6:	02f98a63          	beq	s3,a5,8000471a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046ea:	40d0                	lw	a2,4(s1)
    800046ec:	fb040593          	addi	a1,s0,-80
    800046f0:	854a                	mv	a0,s2
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	cd4080e7          	jalr	-812(ra) # 800033c6 <dirlink>
    800046fa:	06054b63          	bltz	a0,80004770 <create+0x154>
  iunlockput(dp);
    800046fe:	854a                	mv	a0,s2
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	834080e7          	jalr	-1996(ra) # 80002f34 <iunlockput>
  return ip;
    80004708:	b759                	j	8000468e <create+0x72>
    panic("create: ialloc");
    8000470a:	00004517          	auipc	a0,0x4
    8000470e:	00650513          	addi	a0,a0,6 # 80008710 <syscalls+0x318>
    80004712:	00001097          	auipc	ra,0x1
    80004716:	686080e7          	jalr	1670(ra) # 80005d98 <panic>
    dp->nlink++;  // for ".."
    8000471a:	04a95783          	lhu	a5,74(s2)
    8000471e:	2785                	addiw	a5,a5,1
    80004720:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004724:	854a                	mv	a0,s2
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	4e2080e7          	jalr	1250(ra) # 80002c08 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000472e:	40d0                	lw	a2,4(s1)
    80004730:	00004597          	auipc	a1,0x4
    80004734:	ff058593          	addi	a1,a1,-16 # 80008720 <syscalls+0x328>
    80004738:	8526                	mv	a0,s1
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	c8c080e7          	jalr	-884(ra) # 800033c6 <dirlink>
    80004742:	00054f63          	bltz	a0,80004760 <create+0x144>
    80004746:	00492603          	lw	a2,4(s2)
    8000474a:	00004597          	auipc	a1,0x4
    8000474e:	fde58593          	addi	a1,a1,-34 # 80008728 <syscalls+0x330>
    80004752:	8526                	mv	a0,s1
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	c72080e7          	jalr	-910(ra) # 800033c6 <dirlink>
    8000475c:	f80557e3          	bgez	a0,800046ea <create+0xce>
      panic("create dots");
    80004760:	00004517          	auipc	a0,0x4
    80004764:	fd050513          	addi	a0,a0,-48 # 80008730 <syscalls+0x338>
    80004768:	00001097          	auipc	ra,0x1
    8000476c:	630080e7          	jalr	1584(ra) # 80005d98 <panic>
    panic("create: dirlink");
    80004770:	00004517          	auipc	a0,0x4
    80004774:	fd050513          	addi	a0,a0,-48 # 80008740 <syscalls+0x348>
    80004778:	00001097          	auipc	ra,0x1
    8000477c:	620080e7          	jalr	1568(ra) # 80005d98 <panic>
    return 0;
    80004780:	84aa                	mv	s1,a0
    80004782:	b731                	j	8000468e <create+0x72>

0000000080004784 <sys_dup>:
{
    80004784:	7179                	addi	sp,sp,-48
    80004786:	f406                	sd	ra,40(sp)
    80004788:	f022                	sd	s0,32(sp)
    8000478a:	ec26                	sd	s1,24(sp)
    8000478c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000478e:	fd840613          	addi	a2,s0,-40
    80004792:	4581                	li	a1,0
    80004794:	4501                	li	a0,0
    80004796:	00000097          	auipc	ra,0x0
    8000479a:	ddc080e7          	jalr	-548(ra) # 80004572 <argfd>
    return -1;
    8000479e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047a0:	02054363          	bltz	a0,800047c6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047a4:	fd843503          	ld	a0,-40(s0)
    800047a8:	00000097          	auipc	ra,0x0
    800047ac:	e32080e7          	jalr	-462(ra) # 800045da <fdalloc>
    800047b0:	84aa                	mv	s1,a0
    return -1;
    800047b2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047b4:	00054963          	bltz	a0,800047c6 <sys_dup+0x42>
  filedup(f);
    800047b8:	fd843503          	ld	a0,-40(s0)
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	362080e7          	jalr	866(ra) # 80003b1e <filedup>
  return fd;
    800047c4:	87a6                	mv	a5,s1
}
    800047c6:	853e                	mv	a0,a5
    800047c8:	70a2                	ld	ra,40(sp)
    800047ca:	7402                	ld	s0,32(sp)
    800047cc:	64e2                	ld	s1,24(sp)
    800047ce:	6145                	addi	sp,sp,48
    800047d0:	8082                	ret

00000000800047d2 <sys_read>:
{
    800047d2:	7179                	addi	sp,sp,-48
    800047d4:	f406                	sd	ra,40(sp)
    800047d6:	f022                	sd	s0,32(sp)
    800047d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047da:	fe840613          	addi	a2,s0,-24
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	d90080e7          	jalr	-624(ra) # 80004572 <argfd>
    return -1;
    800047ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ec:	04054163          	bltz	a0,8000482e <sys_read+0x5c>
    800047f0:	fe440593          	addi	a1,s0,-28
    800047f4:	4509                	li	a0,2
    800047f6:	ffffe097          	auipc	ra,0xffffe
    800047fa:	87a080e7          	jalr	-1926(ra) # 80002070 <argint>
    return -1;
    800047fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004800:	02054763          	bltz	a0,8000482e <sys_read+0x5c>
    80004804:	fd840593          	addi	a1,s0,-40
    80004808:	4505                	li	a0,1
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	888080e7          	jalr	-1912(ra) # 80002092 <argaddr>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004814:	00054d63          	bltz	a0,8000482e <sys_read+0x5c>
  return fileread(f, p, n);
    80004818:	fe442603          	lw	a2,-28(s0)
    8000481c:	fd843583          	ld	a1,-40(s0)
    80004820:	fe843503          	ld	a0,-24(s0)
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	486080e7          	jalr	1158(ra) # 80003caa <fileread>
    8000482c:	87aa                	mv	a5,a0
}
    8000482e:	853e                	mv	a0,a5
    80004830:	70a2                	ld	ra,40(sp)
    80004832:	7402                	ld	s0,32(sp)
    80004834:	6145                	addi	sp,sp,48
    80004836:	8082                	ret

0000000080004838 <sys_write>:
{
    80004838:	7179                	addi	sp,sp,-48
    8000483a:	f406                	sd	ra,40(sp)
    8000483c:	f022                	sd	s0,32(sp)
    8000483e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004840:	fe840613          	addi	a2,s0,-24
    80004844:	4581                	li	a1,0
    80004846:	4501                	li	a0,0
    80004848:	00000097          	auipc	ra,0x0
    8000484c:	d2a080e7          	jalr	-726(ra) # 80004572 <argfd>
    return -1;
    80004850:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004852:	04054163          	bltz	a0,80004894 <sys_write+0x5c>
    80004856:	fe440593          	addi	a1,s0,-28
    8000485a:	4509                	li	a0,2
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	814080e7          	jalr	-2028(ra) # 80002070 <argint>
    return -1;
    80004864:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004866:	02054763          	bltz	a0,80004894 <sys_write+0x5c>
    8000486a:	fd840593          	addi	a1,s0,-40
    8000486e:	4505                	li	a0,1
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	822080e7          	jalr	-2014(ra) # 80002092 <argaddr>
    return -1;
    80004878:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487a:	00054d63          	bltz	a0,80004894 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000487e:	fe442603          	lw	a2,-28(s0)
    80004882:	fd843583          	ld	a1,-40(s0)
    80004886:	fe843503          	ld	a0,-24(s0)
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	4e2080e7          	jalr	1250(ra) # 80003d6c <filewrite>
    80004892:	87aa                	mv	a5,a0
}
    80004894:	853e                	mv	a0,a5
    80004896:	70a2                	ld	ra,40(sp)
    80004898:	7402                	ld	s0,32(sp)
    8000489a:	6145                	addi	sp,sp,48
    8000489c:	8082                	ret

000000008000489e <sys_close>:
{
    8000489e:	1101                	addi	sp,sp,-32
    800048a0:	ec06                	sd	ra,24(sp)
    800048a2:	e822                	sd	s0,16(sp)
    800048a4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048a6:	fe040613          	addi	a2,s0,-32
    800048aa:	fec40593          	addi	a1,s0,-20
    800048ae:	4501                	li	a0,0
    800048b0:	00000097          	auipc	ra,0x0
    800048b4:	cc2080e7          	jalr	-830(ra) # 80004572 <argfd>
    return -1;
    800048b8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048ba:	02054463          	bltz	a0,800048e2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048be:	ffffc097          	auipc	ra,0xffffc
    800048c2:	680080e7          	jalr	1664(ra) # 80000f3e <myproc>
    800048c6:	fec42783          	lw	a5,-20(s0)
    800048ca:	07e9                	addi	a5,a5,26
    800048cc:	078e                	slli	a5,a5,0x3
    800048ce:	97aa                	add	a5,a5,a0
    800048d0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048d4:	fe043503          	ld	a0,-32(s0)
    800048d8:	fffff097          	auipc	ra,0xfffff
    800048dc:	298080e7          	jalr	664(ra) # 80003b70 <fileclose>
  return 0;
    800048e0:	4781                	li	a5,0
}
    800048e2:	853e                	mv	a0,a5
    800048e4:	60e2                	ld	ra,24(sp)
    800048e6:	6442                	ld	s0,16(sp)
    800048e8:	6105                	addi	sp,sp,32
    800048ea:	8082                	ret

00000000800048ec <sys_fstat>:
{
    800048ec:	1101                	addi	sp,sp,-32
    800048ee:	ec06                	sd	ra,24(sp)
    800048f0:	e822                	sd	s0,16(sp)
    800048f2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048f4:	fe840613          	addi	a2,s0,-24
    800048f8:	4581                	li	a1,0
    800048fa:	4501                	li	a0,0
    800048fc:	00000097          	auipc	ra,0x0
    80004900:	c76080e7          	jalr	-906(ra) # 80004572 <argfd>
    return -1;
    80004904:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004906:	02054563          	bltz	a0,80004930 <sys_fstat+0x44>
    8000490a:	fe040593          	addi	a1,s0,-32
    8000490e:	4505                	li	a0,1
    80004910:	ffffd097          	auipc	ra,0xffffd
    80004914:	782080e7          	jalr	1922(ra) # 80002092 <argaddr>
    return -1;
    80004918:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000491a:	00054b63          	bltz	a0,80004930 <sys_fstat+0x44>
  return filestat(f, st);
    8000491e:	fe043583          	ld	a1,-32(s0)
    80004922:	fe843503          	ld	a0,-24(s0)
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	312080e7          	jalr	786(ra) # 80003c38 <filestat>
    8000492e:	87aa                	mv	a5,a0
}
    80004930:	853e                	mv	a0,a5
    80004932:	60e2                	ld	ra,24(sp)
    80004934:	6442                	ld	s0,16(sp)
    80004936:	6105                	addi	sp,sp,32
    80004938:	8082                	ret

000000008000493a <sys_link>:
{
    8000493a:	7169                	addi	sp,sp,-304
    8000493c:	f606                	sd	ra,296(sp)
    8000493e:	f222                	sd	s0,288(sp)
    80004940:	ee26                	sd	s1,280(sp)
    80004942:	ea4a                	sd	s2,272(sp)
    80004944:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004946:	08000613          	li	a2,128
    8000494a:	ed040593          	addi	a1,s0,-304
    8000494e:	4501                	li	a0,0
    80004950:	ffffd097          	auipc	ra,0xffffd
    80004954:	764080e7          	jalr	1892(ra) # 800020b4 <argstr>
    return -1;
    80004958:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000495a:	10054e63          	bltz	a0,80004a76 <sys_link+0x13c>
    8000495e:	08000613          	li	a2,128
    80004962:	f5040593          	addi	a1,s0,-176
    80004966:	4505                	li	a0,1
    80004968:	ffffd097          	auipc	ra,0xffffd
    8000496c:	74c080e7          	jalr	1868(ra) # 800020b4 <argstr>
    return -1;
    80004970:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004972:	10054263          	bltz	a0,80004a76 <sys_link+0x13c>
  begin_op();
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	d2e080e7          	jalr	-722(ra) # 800036a4 <begin_op>
  if((ip = namei(old)) == 0){
    8000497e:	ed040513          	addi	a0,s0,-304
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	b06080e7          	jalr	-1274(ra) # 80003488 <namei>
    8000498a:	84aa                	mv	s1,a0
    8000498c:	c551                	beqz	a0,80004a18 <sys_link+0xde>
  ilock(ip);
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	344080e7          	jalr	836(ra) # 80002cd2 <ilock>
  if(ip->type == T_DIR){
    80004996:	04449703          	lh	a4,68(s1)
    8000499a:	4785                	li	a5,1
    8000499c:	08f70463          	beq	a4,a5,80004a24 <sys_link+0xea>
  ip->nlink++;
    800049a0:	04a4d783          	lhu	a5,74(s1)
    800049a4:	2785                	addiw	a5,a5,1
    800049a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049aa:	8526                	mv	a0,s1
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	25c080e7          	jalr	604(ra) # 80002c08 <iupdate>
  iunlock(ip);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	3de080e7          	jalr	990(ra) # 80002d94 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049be:	fd040593          	addi	a1,s0,-48
    800049c2:	f5040513          	addi	a0,s0,-176
    800049c6:	fffff097          	auipc	ra,0xfffff
    800049ca:	ae0080e7          	jalr	-1312(ra) # 800034a6 <nameiparent>
    800049ce:	892a                	mv	s2,a0
    800049d0:	c935                	beqz	a0,80004a44 <sys_link+0x10a>
  ilock(dp);
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	300080e7          	jalr	768(ra) # 80002cd2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049da:	00092703          	lw	a4,0(s2)
    800049de:	409c                	lw	a5,0(s1)
    800049e0:	04f71d63          	bne	a4,a5,80004a3a <sys_link+0x100>
    800049e4:	40d0                	lw	a2,4(s1)
    800049e6:	fd040593          	addi	a1,s0,-48
    800049ea:	854a                	mv	a0,s2
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	9da080e7          	jalr	-1574(ra) # 800033c6 <dirlink>
    800049f4:	04054363          	bltz	a0,80004a3a <sys_link+0x100>
  iunlockput(dp);
    800049f8:	854a                	mv	a0,s2
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	53a080e7          	jalr	1338(ra) # 80002f34 <iunlockput>
  iput(ip);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	488080e7          	jalr	1160(ra) # 80002e8c <iput>
  end_op();
    80004a0c:	fffff097          	auipc	ra,0xfffff
    80004a10:	d18080e7          	jalr	-744(ra) # 80003724 <end_op>
  return 0;
    80004a14:	4781                	li	a5,0
    80004a16:	a085                	j	80004a76 <sys_link+0x13c>
    end_op();
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	d0c080e7          	jalr	-756(ra) # 80003724 <end_op>
    return -1;
    80004a20:	57fd                	li	a5,-1
    80004a22:	a891                	j	80004a76 <sys_link+0x13c>
    iunlockput(ip);
    80004a24:	8526                	mv	a0,s1
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	50e080e7          	jalr	1294(ra) # 80002f34 <iunlockput>
    end_op();
    80004a2e:	fffff097          	auipc	ra,0xfffff
    80004a32:	cf6080e7          	jalr	-778(ra) # 80003724 <end_op>
    return -1;
    80004a36:	57fd                	li	a5,-1
    80004a38:	a83d                	j	80004a76 <sys_link+0x13c>
    iunlockput(dp);
    80004a3a:	854a                	mv	a0,s2
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	4f8080e7          	jalr	1272(ra) # 80002f34 <iunlockput>
  ilock(ip);
    80004a44:	8526                	mv	a0,s1
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	28c080e7          	jalr	652(ra) # 80002cd2 <ilock>
  ip->nlink--;
    80004a4e:	04a4d783          	lhu	a5,74(s1)
    80004a52:	37fd                	addiw	a5,a5,-1
    80004a54:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	1ae080e7          	jalr	430(ra) # 80002c08 <iupdate>
  iunlockput(ip);
    80004a62:	8526                	mv	a0,s1
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	4d0080e7          	jalr	1232(ra) # 80002f34 <iunlockput>
  end_op();
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	cb8080e7          	jalr	-840(ra) # 80003724 <end_op>
  return -1;
    80004a74:	57fd                	li	a5,-1
}
    80004a76:	853e                	mv	a0,a5
    80004a78:	70b2                	ld	ra,296(sp)
    80004a7a:	7412                	ld	s0,288(sp)
    80004a7c:	64f2                	ld	s1,280(sp)
    80004a7e:	6952                	ld	s2,272(sp)
    80004a80:	6155                	addi	sp,sp,304
    80004a82:	8082                	ret

0000000080004a84 <sys_unlink>:
{
    80004a84:	7151                	addi	sp,sp,-240
    80004a86:	f586                	sd	ra,232(sp)
    80004a88:	f1a2                	sd	s0,224(sp)
    80004a8a:	eda6                	sd	s1,216(sp)
    80004a8c:	e9ca                	sd	s2,208(sp)
    80004a8e:	e5ce                	sd	s3,200(sp)
    80004a90:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a92:	08000613          	li	a2,128
    80004a96:	f3040593          	addi	a1,s0,-208
    80004a9a:	4501                	li	a0,0
    80004a9c:	ffffd097          	auipc	ra,0xffffd
    80004aa0:	618080e7          	jalr	1560(ra) # 800020b4 <argstr>
    80004aa4:	18054163          	bltz	a0,80004c26 <sys_unlink+0x1a2>
  begin_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	bfc080e7          	jalr	-1028(ra) # 800036a4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ab0:	fb040593          	addi	a1,s0,-80
    80004ab4:	f3040513          	addi	a0,s0,-208
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	9ee080e7          	jalr	-1554(ra) # 800034a6 <nameiparent>
    80004ac0:	84aa                	mv	s1,a0
    80004ac2:	c979                	beqz	a0,80004b98 <sys_unlink+0x114>
  ilock(dp);
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	20e080e7          	jalr	526(ra) # 80002cd2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004acc:	00004597          	auipc	a1,0x4
    80004ad0:	c5458593          	addi	a1,a1,-940 # 80008720 <syscalls+0x328>
    80004ad4:	fb040513          	addi	a0,s0,-80
    80004ad8:	ffffe097          	auipc	ra,0xffffe
    80004adc:	6c4080e7          	jalr	1732(ra) # 8000319c <namecmp>
    80004ae0:	14050a63          	beqz	a0,80004c34 <sys_unlink+0x1b0>
    80004ae4:	00004597          	auipc	a1,0x4
    80004ae8:	c4458593          	addi	a1,a1,-956 # 80008728 <syscalls+0x330>
    80004aec:	fb040513          	addi	a0,s0,-80
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	6ac080e7          	jalr	1708(ra) # 8000319c <namecmp>
    80004af8:	12050e63          	beqz	a0,80004c34 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004afc:	f2c40613          	addi	a2,s0,-212
    80004b00:	fb040593          	addi	a1,s0,-80
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	6b0080e7          	jalr	1712(ra) # 800031b6 <dirlookup>
    80004b0e:	892a                	mv	s2,a0
    80004b10:	12050263          	beqz	a0,80004c34 <sys_unlink+0x1b0>
  ilock(ip);
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	1be080e7          	jalr	446(ra) # 80002cd2 <ilock>
  if(ip->nlink < 1)
    80004b1c:	04a91783          	lh	a5,74(s2)
    80004b20:	08f05263          	blez	a5,80004ba4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b24:	04491703          	lh	a4,68(s2)
    80004b28:	4785                	li	a5,1
    80004b2a:	08f70563          	beq	a4,a5,80004bb4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b2e:	4641                	li	a2,16
    80004b30:	4581                	li	a1,0
    80004b32:	fc040513          	addi	a0,s0,-64
    80004b36:	ffffb097          	auipc	ra,0xffffb
    80004b3a:	642080e7          	jalr	1602(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b3e:	4741                	li	a4,16
    80004b40:	f2c42683          	lw	a3,-212(s0)
    80004b44:	fc040613          	addi	a2,s0,-64
    80004b48:	4581                	li	a1,0
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	532080e7          	jalr	1330(ra) # 8000307e <writei>
    80004b54:	47c1                	li	a5,16
    80004b56:	0af51563          	bne	a0,a5,80004c00 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b5a:	04491703          	lh	a4,68(s2)
    80004b5e:	4785                	li	a5,1
    80004b60:	0af70863          	beq	a4,a5,80004c10 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b64:	8526                	mv	a0,s1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	3ce080e7          	jalr	974(ra) # 80002f34 <iunlockput>
  ip->nlink--;
    80004b6e:	04a95783          	lhu	a5,74(s2)
    80004b72:	37fd                	addiw	a5,a5,-1
    80004b74:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b78:	854a                	mv	a0,s2
    80004b7a:	ffffe097          	auipc	ra,0xffffe
    80004b7e:	08e080e7          	jalr	142(ra) # 80002c08 <iupdate>
  iunlockput(ip);
    80004b82:	854a                	mv	a0,s2
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	3b0080e7          	jalr	944(ra) # 80002f34 <iunlockput>
  end_op();
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	b98080e7          	jalr	-1128(ra) # 80003724 <end_op>
  return 0;
    80004b94:	4501                	li	a0,0
    80004b96:	a84d                	j	80004c48 <sys_unlink+0x1c4>
    end_op();
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	b8c080e7          	jalr	-1140(ra) # 80003724 <end_op>
    return -1;
    80004ba0:	557d                	li	a0,-1
    80004ba2:	a05d                	j	80004c48 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ba4:	00004517          	auipc	a0,0x4
    80004ba8:	bac50513          	addi	a0,a0,-1108 # 80008750 <syscalls+0x358>
    80004bac:	00001097          	auipc	ra,0x1
    80004bb0:	1ec080e7          	jalr	492(ra) # 80005d98 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bb4:	04c92703          	lw	a4,76(s2)
    80004bb8:	02000793          	li	a5,32
    80004bbc:	f6e7f9e3          	bgeu	a5,a4,80004b2e <sys_unlink+0xaa>
    80004bc0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bc4:	4741                	li	a4,16
    80004bc6:	86ce                	mv	a3,s3
    80004bc8:	f1840613          	addi	a2,s0,-232
    80004bcc:	4581                	li	a1,0
    80004bce:	854a                	mv	a0,s2
    80004bd0:	ffffe097          	auipc	ra,0xffffe
    80004bd4:	3b6080e7          	jalr	950(ra) # 80002f86 <readi>
    80004bd8:	47c1                	li	a5,16
    80004bda:	00f51b63          	bne	a0,a5,80004bf0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bde:	f1845783          	lhu	a5,-232(s0)
    80004be2:	e7a1                	bnez	a5,80004c2a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004be4:	29c1                	addiw	s3,s3,16
    80004be6:	04c92783          	lw	a5,76(s2)
    80004bea:	fcf9ede3          	bltu	s3,a5,80004bc4 <sys_unlink+0x140>
    80004bee:	b781                	j	80004b2e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bf0:	00004517          	auipc	a0,0x4
    80004bf4:	b7850513          	addi	a0,a0,-1160 # 80008768 <syscalls+0x370>
    80004bf8:	00001097          	auipc	ra,0x1
    80004bfc:	1a0080e7          	jalr	416(ra) # 80005d98 <panic>
    panic("unlink: writei");
    80004c00:	00004517          	auipc	a0,0x4
    80004c04:	b8050513          	addi	a0,a0,-1152 # 80008780 <syscalls+0x388>
    80004c08:	00001097          	auipc	ra,0x1
    80004c0c:	190080e7          	jalr	400(ra) # 80005d98 <panic>
    dp->nlink--;
    80004c10:	04a4d783          	lhu	a5,74(s1)
    80004c14:	37fd                	addiw	a5,a5,-1
    80004c16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	fec080e7          	jalr	-20(ra) # 80002c08 <iupdate>
    80004c24:	b781                	j	80004b64 <sys_unlink+0xe0>
    return -1;
    80004c26:	557d                	li	a0,-1
    80004c28:	a005                	j	80004c48 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	308080e7          	jalr	776(ra) # 80002f34 <iunlockput>
  iunlockput(dp);
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	2fe080e7          	jalr	766(ra) # 80002f34 <iunlockput>
  end_op();
    80004c3e:	fffff097          	auipc	ra,0xfffff
    80004c42:	ae6080e7          	jalr	-1306(ra) # 80003724 <end_op>
  return -1;
    80004c46:	557d                	li	a0,-1
}
    80004c48:	70ae                	ld	ra,232(sp)
    80004c4a:	740e                	ld	s0,224(sp)
    80004c4c:	64ee                	ld	s1,216(sp)
    80004c4e:	694e                	ld	s2,208(sp)
    80004c50:	69ae                	ld	s3,200(sp)
    80004c52:	616d                	addi	sp,sp,240
    80004c54:	8082                	ret

0000000080004c56 <sys_open>:

uint64
sys_open(void)
{
    80004c56:	7131                	addi	sp,sp,-192
    80004c58:	fd06                	sd	ra,184(sp)
    80004c5a:	f922                	sd	s0,176(sp)
    80004c5c:	f526                	sd	s1,168(sp)
    80004c5e:	f14a                	sd	s2,160(sp)
    80004c60:	ed4e                	sd	s3,152(sp)
    80004c62:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c64:	08000613          	li	a2,128
    80004c68:	f5040593          	addi	a1,s0,-176
    80004c6c:	4501                	li	a0,0
    80004c6e:	ffffd097          	auipc	ra,0xffffd
    80004c72:	446080e7          	jalr	1094(ra) # 800020b4 <argstr>
    return -1;
    80004c76:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c78:	0c054163          	bltz	a0,80004d3a <sys_open+0xe4>
    80004c7c:	f4c40593          	addi	a1,s0,-180
    80004c80:	4505                	li	a0,1
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	3ee080e7          	jalr	1006(ra) # 80002070 <argint>
    80004c8a:	0a054863          	bltz	a0,80004d3a <sys_open+0xe4>

  begin_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	a16080e7          	jalr	-1514(ra) # 800036a4 <begin_op>

  if(omode & O_CREATE){
    80004c96:	f4c42783          	lw	a5,-180(s0)
    80004c9a:	2007f793          	andi	a5,a5,512
    80004c9e:	cbdd                	beqz	a5,80004d54 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ca0:	4681                	li	a3,0
    80004ca2:	4601                	li	a2,0
    80004ca4:	4589                	li	a1,2
    80004ca6:	f5040513          	addi	a0,s0,-176
    80004caa:	00000097          	auipc	ra,0x0
    80004cae:	972080e7          	jalr	-1678(ra) # 8000461c <create>
    80004cb2:	892a                	mv	s2,a0
    if(ip == 0){
    80004cb4:	c959                	beqz	a0,80004d4a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cb6:	04491703          	lh	a4,68(s2)
    80004cba:	478d                	li	a5,3
    80004cbc:	00f71763          	bne	a4,a5,80004cca <sys_open+0x74>
    80004cc0:	04695703          	lhu	a4,70(s2)
    80004cc4:	47a5                	li	a5,9
    80004cc6:	0ce7ec63          	bltu	a5,a4,80004d9e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	dea080e7          	jalr	-534(ra) # 80003ab4 <filealloc>
    80004cd2:	89aa                	mv	s3,a0
    80004cd4:	10050263          	beqz	a0,80004dd8 <sys_open+0x182>
    80004cd8:	00000097          	auipc	ra,0x0
    80004cdc:	902080e7          	jalr	-1790(ra) # 800045da <fdalloc>
    80004ce0:	84aa                	mv	s1,a0
    80004ce2:	0e054663          	bltz	a0,80004dce <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ce6:	04491703          	lh	a4,68(s2)
    80004cea:	478d                	li	a5,3
    80004cec:	0cf70463          	beq	a4,a5,80004db4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cf0:	4789                	li	a5,2
    80004cf2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cf6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cfa:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cfe:	f4c42783          	lw	a5,-180(s0)
    80004d02:	0017c713          	xori	a4,a5,1
    80004d06:	8b05                	andi	a4,a4,1
    80004d08:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d0c:	0037f713          	andi	a4,a5,3
    80004d10:	00e03733          	snez	a4,a4
    80004d14:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d18:	4007f793          	andi	a5,a5,1024
    80004d1c:	c791                	beqz	a5,80004d28 <sys_open+0xd2>
    80004d1e:	04491703          	lh	a4,68(s2)
    80004d22:	4789                	li	a5,2
    80004d24:	08f70f63          	beq	a4,a5,80004dc2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d28:	854a                	mv	a0,s2
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	06a080e7          	jalr	106(ra) # 80002d94 <iunlock>
  end_op();
    80004d32:	fffff097          	auipc	ra,0xfffff
    80004d36:	9f2080e7          	jalr	-1550(ra) # 80003724 <end_op>

  return fd;
}
    80004d3a:	8526                	mv	a0,s1
    80004d3c:	70ea                	ld	ra,184(sp)
    80004d3e:	744a                	ld	s0,176(sp)
    80004d40:	74aa                	ld	s1,168(sp)
    80004d42:	790a                	ld	s2,160(sp)
    80004d44:	69ea                	ld	s3,152(sp)
    80004d46:	6129                	addi	sp,sp,192
    80004d48:	8082                	ret
      end_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	9da080e7          	jalr	-1574(ra) # 80003724 <end_op>
      return -1;
    80004d52:	b7e5                	j	80004d3a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d54:	f5040513          	addi	a0,s0,-176
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	730080e7          	jalr	1840(ra) # 80003488 <namei>
    80004d60:	892a                	mv	s2,a0
    80004d62:	c905                	beqz	a0,80004d92 <sys_open+0x13c>
    ilock(ip);
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	f6e080e7          	jalr	-146(ra) # 80002cd2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d6c:	04491703          	lh	a4,68(s2)
    80004d70:	4785                	li	a5,1
    80004d72:	f4f712e3          	bne	a4,a5,80004cb6 <sys_open+0x60>
    80004d76:	f4c42783          	lw	a5,-180(s0)
    80004d7a:	dba1                	beqz	a5,80004cca <sys_open+0x74>
      iunlockput(ip);
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	1b6080e7          	jalr	438(ra) # 80002f34 <iunlockput>
      end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	99e080e7          	jalr	-1634(ra) # 80003724 <end_op>
      return -1;
    80004d8e:	54fd                	li	s1,-1
    80004d90:	b76d                	j	80004d3a <sys_open+0xe4>
      end_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	992080e7          	jalr	-1646(ra) # 80003724 <end_op>
      return -1;
    80004d9a:	54fd                	li	s1,-1
    80004d9c:	bf79                	j	80004d3a <sys_open+0xe4>
    iunlockput(ip);
    80004d9e:	854a                	mv	a0,s2
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	194080e7          	jalr	404(ra) # 80002f34 <iunlockput>
    end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	97c080e7          	jalr	-1668(ra) # 80003724 <end_op>
    return -1;
    80004db0:	54fd                	li	s1,-1
    80004db2:	b761                	j	80004d3a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004db4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004db8:	04691783          	lh	a5,70(s2)
    80004dbc:	02f99223          	sh	a5,36(s3)
    80004dc0:	bf2d                	j	80004cfa <sys_open+0xa4>
    itrunc(ip);
    80004dc2:	854a                	mv	a0,s2
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	01c080e7          	jalr	28(ra) # 80002de0 <itrunc>
    80004dcc:	bfb1                	j	80004d28 <sys_open+0xd2>
      fileclose(f);
    80004dce:	854e                	mv	a0,s3
    80004dd0:	fffff097          	auipc	ra,0xfffff
    80004dd4:	da0080e7          	jalr	-608(ra) # 80003b70 <fileclose>
    iunlockput(ip);
    80004dd8:	854a                	mv	a0,s2
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	15a080e7          	jalr	346(ra) # 80002f34 <iunlockput>
    end_op();
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	942080e7          	jalr	-1726(ra) # 80003724 <end_op>
    return -1;
    80004dea:	54fd                	li	s1,-1
    80004dec:	b7b9                	j	80004d3a <sys_open+0xe4>

0000000080004dee <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dee:	7175                	addi	sp,sp,-144
    80004df0:	e506                	sd	ra,136(sp)
    80004df2:	e122                	sd	s0,128(sp)
    80004df4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	8ae080e7          	jalr	-1874(ra) # 800036a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dfe:	08000613          	li	a2,128
    80004e02:	f7040593          	addi	a1,s0,-144
    80004e06:	4501                	li	a0,0
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	2ac080e7          	jalr	684(ra) # 800020b4 <argstr>
    80004e10:	02054963          	bltz	a0,80004e42 <sys_mkdir+0x54>
    80004e14:	4681                	li	a3,0
    80004e16:	4601                	li	a2,0
    80004e18:	4585                	li	a1,1
    80004e1a:	f7040513          	addi	a0,s0,-144
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	7fe080e7          	jalr	2046(ra) # 8000461c <create>
    80004e26:	cd11                	beqz	a0,80004e42 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	10c080e7          	jalr	268(ra) # 80002f34 <iunlockput>
  end_op();
    80004e30:	fffff097          	auipc	ra,0xfffff
    80004e34:	8f4080e7          	jalr	-1804(ra) # 80003724 <end_op>
  return 0;
    80004e38:	4501                	li	a0,0
}
    80004e3a:	60aa                	ld	ra,136(sp)
    80004e3c:	640a                	ld	s0,128(sp)
    80004e3e:	6149                	addi	sp,sp,144
    80004e40:	8082                	ret
    end_op();
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	8e2080e7          	jalr	-1822(ra) # 80003724 <end_op>
    return -1;
    80004e4a:	557d                	li	a0,-1
    80004e4c:	b7fd                	j	80004e3a <sys_mkdir+0x4c>

0000000080004e4e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e4e:	7135                	addi	sp,sp,-160
    80004e50:	ed06                	sd	ra,152(sp)
    80004e52:	e922                	sd	s0,144(sp)
    80004e54:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	84e080e7          	jalr	-1970(ra) # 800036a4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e5e:	08000613          	li	a2,128
    80004e62:	f7040593          	addi	a1,s0,-144
    80004e66:	4501                	li	a0,0
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	24c080e7          	jalr	588(ra) # 800020b4 <argstr>
    80004e70:	04054a63          	bltz	a0,80004ec4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e74:	f6c40593          	addi	a1,s0,-148
    80004e78:	4505                	li	a0,1
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	1f6080e7          	jalr	502(ra) # 80002070 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e82:	04054163          	bltz	a0,80004ec4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e86:	f6840593          	addi	a1,s0,-152
    80004e8a:	4509                	li	a0,2
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	1e4080e7          	jalr	484(ra) # 80002070 <argint>
     argint(1, &major) < 0 ||
    80004e94:	02054863          	bltz	a0,80004ec4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e98:	f6841683          	lh	a3,-152(s0)
    80004e9c:	f6c41603          	lh	a2,-148(s0)
    80004ea0:	458d                	li	a1,3
    80004ea2:	f7040513          	addi	a0,s0,-144
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	776080e7          	jalr	1910(ra) # 8000461c <create>
     argint(2, &minor) < 0 ||
    80004eae:	c919                	beqz	a0,80004ec4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	084080e7          	jalr	132(ra) # 80002f34 <iunlockput>
  end_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	86c080e7          	jalr	-1940(ra) # 80003724 <end_op>
  return 0;
    80004ec0:	4501                	li	a0,0
    80004ec2:	a031                	j	80004ece <sys_mknod+0x80>
    end_op();
    80004ec4:	fffff097          	auipc	ra,0xfffff
    80004ec8:	860080e7          	jalr	-1952(ra) # 80003724 <end_op>
    return -1;
    80004ecc:	557d                	li	a0,-1
}
    80004ece:	60ea                	ld	ra,152(sp)
    80004ed0:	644a                	ld	s0,144(sp)
    80004ed2:	610d                	addi	sp,sp,160
    80004ed4:	8082                	ret

0000000080004ed6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ed6:	7135                	addi	sp,sp,-160
    80004ed8:	ed06                	sd	ra,152(sp)
    80004eda:	e922                	sd	s0,144(sp)
    80004edc:	e526                	sd	s1,136(sp)
    80004ede:	e14a                	sd	s2,128(sp)
    80004ee0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ee2:	ffffc097          	auipc	ra,0xffffc
    80004ee6:	05c080e7          	jalr	92(ra) # 80000f3e <myproc>
    80004eea:	892a                	mv	s2,a0
  
  begin_op();
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	7b8080e7          	jalr	1976(ra) # 800036a4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ef4:	08000613          	li	a2,128
    80004ef8:	f6040593          	addi	a1,s0,-160
    80004efc:	4501                	li	a0,0
    80004efe:	ffffd097          	auipc	ra,0xffffd
    80004f02:	1b6080e7          	jalr	438(ra) # 800020b4 <argstr>
    80004f06:	04054b63          	bltz	a0,80004f5c <sys_chdir+0x86>
    80004f0a:	f6040513          	addi	a0,s0,-160
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	57a080e7          	jalr	1402(ra) # 80003488 <namei>
    80004f16:	84aa                	mv	s1,a0
    80004f18:	c131                	beqz	a0,80004f5c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	db8080e7          	jalr	-584(ra) # 80002cd2 <ilock>
  if(ip->type != T_DIR){
    80004f22:	04449703          	lh	a4,68(s1)
    80004f26:	4785                	li	a5,1
    80004f28:	04f71063          	bne	a4,a5,80004f68 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f2c:	8526                	mv	a0,s1
    80004f2e:	ffffe097          	auipc	ra,0xffffe
    80004f32:	e66080e7          	jalr	-410(ra) # 80002d94 <iunlock>
  iput(p->cwd);
    80004f36:	15093503          	ld	a0,336(s2)
    80004f3a:	ffffe097          	auipc	ra,0xffffe
    80004f3e:	f52080e7          	jalr	-174(ra) # 80002e8c <iput>
  end_op();
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	7e2080e7          	jalr	2018(ra) # 80003724 <end_op>
  p->cwd = ip;
    80004f4a:	14993823          	sd	s1,336(s2)
  return 0;
    80004f4e:	4501                	li	a0,0
}
    80004f50:	60ea                	ld	ra,152(sp)
    80004f52:	644a                	ld	s0,144(sp)
    80004f54:	64aa                	ld	s1,136(sp)
    80004f56:	690a                	ld	s2,128(sp)
    80004f58:	610d                	addi	sp,sp,160
    80004f5a:	8082                	ret
    end_op();
    80004f5c:	ffffe097          	auipc	ra,0xffffe
    80004f60:	7c8080e7          	jalr	1992(ra) # 80003724 <end_op>
    return -1;
    80004f64:	557d                	li	a0,-1
    80004f66:	b7ed                	j	80004f50 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f68:	8526                	mv	a0,s1
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	fca080e7          	jalr	-54(ra) # 80002f34 <iunlockput>
    end_op();
    80004f72:	ffffe097          	auipc	ra,0xffffe
    80004f76:	7b2080e7          	jalr	1970(ra) # 80003724 <end_op>
    return -1;
    80004f7a:	557d                	li	a0,-1
    80004f7c:	bfd1                	j	80004f50 <sys_chdir+0x7a>

0000000080004f7e <sys_exec>:

uint64
sys_exec(void)
{
    80004f7e:	7145                	addi	sp,sp,-464
    80004f80:	e786                	sd	ra,456(sp)
    80004f82:	e3a2                	sd	s0,448(sp)
    80004f84:	ff26                	sd	s1,440(sp)
    80004f86:	fb4a                	sd	s2,432(sp)
    80004f88:	f74e                	sd	s3,424(sp)
    80004f8a:	f352                	sd	s4,416(sp)
    80004f8c:	ef56                	sd	s5,408(sp)
    80004f8e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f90:	08000613          	li	a2,128
    80004f94:	f4040593          	addi	a1,s0,-192
    80004f98:	4501                	li	a0,0
    80004f9a:	ffffd097          	auipc	ra,0xffffd
    80004f9e:	11a080e7          	jalr	282(ra) # 800020b4 <argstr>
    return -1;
    80004fa2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fa4:	0c054a63          	bltz	a0,80005078 <sys_exec+0xfa>
    80004fa8:	e3840593          	addi	a1,s0,-456
    80004fac:	4505                	li	a0,1
    80004fae:	ffffd097          	auipc	ra,0xffffd
    80004fb2:	0e4080e7          	jalr	228(ra) # 80002092 <argaddr>
    80004fb6:	0c054163          	bltz	a0,80005078 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fba:	10000613          	li	a2,256
    80004fbe:	4581                	li	a1,0
    80004fc0:	e4040513          	addi	a0,s0,-448
    80004fc4:	ffffb097          	auipc	ra,0xffffb
    80004fc8:	1b4080e7          	jalr	436(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fcc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fd0:	89a6                	mv	s3,s1
    80004fd2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fd4:	02000a13          	li	s4,32
    80004fd8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fdc:	00391513          	slli	a0,s2,0x3
    80004fe0:	e3040593          	addi	a1,s0,-464
    80004fe4:	e3843783          	ld	a5,-456(s0)
    80004fe8:	953e                	add	a0,a0,a5
    80004fea:	ffffd097          	auipc	ra,0xffffd
    80004fee:	fec080e7          	jalr	-20(ra) # 80001fd6 <fetchaddr>
    80004ff2:	02054a63          	bltz	a0,80005026 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ff6:	e3043783          	ld	a5,-464(s0)
    80004ffa:	c3b9                	beqz	a5,80005040 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ffc:	ffffb097          	auipc	ra,0xffffb
    80005000:	11c080e7          	jalr	284(ra) # 80000118 <kalloc>
    80005004:	85aa                	mv	a1,a0
    80005006:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000500a:	cd11                	beqz	a0,80005026 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000500c:	6605                	lui	a2,0x1
    8000500e:	e3043503          	ld	a0,-464(s0)
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	016080e7          	jalr	22(ra) # 80002028 <fetchstr>
    8000501a:	00054663          	bltz	a0,80005026 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    8000501e:	0905                	addi	s2,s2,1
    80005020:	09a1                	addi	s3,s3,8
    80005022:	fb491be3          	bne	s2,s4,80004fd8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005026:	10048913          	addi	s2,s1,256
    8000502a:	6088                	ld	a0,0(s1)
    8000502c:	c529                	beqz	a0,80005076 <sys_exec+0xf8>
    kfree(argv[i]);
    8000502e:	ffffb097          	auipc	ra,0xffffb
    80005032:	fee080e7          	jalr	-18(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005036:	04a1                	addi	s1,s1,8
    80005038:	ff2499e3          	bne	s1,s2,8000502a <sys_exec+0xac>
  return -1;
    8000503c:	597d                	li	s2,-1
    8000503e:	a82d                	j	80005078 <sys_exec+0xfa>
      argv[i] = 0;
    80005040:	0a8e                	slli	s5,s5,0x3
    80005042:	fc040793          	addi	a5,s0,-64
    80005046:	9abe                	add	s5,s5,a5
    80005048:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000504c:	e4040593          	addi	a1,s0,-448
    80005050:	f4040513          	addi	a0,s0,-192
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	17c080e7          	jalr	380(ra) # 800041d0 <exec>
    8000505c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505e:	10048993          	addi	s3,s1,256
    80005062:	6088                	ld	a0,0(s1)
    80005064:	c911                	beqz	a0,80005078 <sys_exec+0xfa>
    kfree(argv[i]);
    80005066:	ffffb097          	auipc	ra,0xffffb
    8000506a:	fb6080e7          	jalr	-74(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000506e:	04a1                	addi	s1,s1,8
    80005070:	ff3499e3          	bne	s1,s3,80005062 <sys_exec+0xe4>
    80005074:	a011                	j	80005078 <sys_exec+0xfa>
  return -1;
    80005076:	597d                	li	s2,-1
}
    80005078:	854a                	mv	a0,s2
    8000507a:	60be                	ld	ra,456(sp)
    8000507c:	641e                	ld	s0,448(sp)
    8000507e:	74fa                	ld	s1,440(sp)
    80005080:	795a                	ld	s2,432(sp)
    80005082:	79ba                	ld	s3,424(sp)
    80005084:	7a1a                	ld	s4,416(sp)
    80005086:	6afa                	ld	s5,408(sp)
    80005088:	6179                	addi	sp,sp,464
    8000508a:	8082                	ret

000000008000508c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000508c:	7139                	addi	sp,sp,-64
    8000508e:	fc06                	sd	ra,56(sp)
    80005090:	f822                	sd	s0,48(sp)
    80005092:	f426                	sd	s1,40(sp)
    80005094:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005096:	ffffc097          	auipc	ra,0xffffc
    8000509a:	ea8080e7          	jalr	-344(ra) # 80000f3e <myproc>
    8000509e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050a0:	fd840593          	addi	a1,s0,-40
    800050a4:	4501                	li	a0,0
    800050a6:	ffffd097          	auipc	ra,0xffffd
    800050aa:	fec080e7          	jalr	-20(ra) # 80002092 <argaddr>
    return -1;
    800050ae:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050b0:	0e054063          	bltz	a0,80005190 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050b4:	fc840593          	addi	a1,s0,-56
    800050b8:	fd040513          	addi	a0,s0,-48
    800050bc:	fffff097          	auipc	ra,0xfffff
    800050c0:	de4080e7          	jalr	-540(ra) # 80003ea0 <pipealloc>
    return -1;
    800050c4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050c6:	0c054563          	bltz	a0,80005190 <sys_pipe+0x104>
  fd0 = -1;
    800050ca:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050ce:	fd043503          	ld	a0,-48(s0)
    800050d2:	fffff097          	auipc	ra,0xfffff
    800050d6:	508080e7          	jalr	1288(ra) # 800045da <fdalloc>
    800050da:	fca42223          	sw	a0,-60(s0)
    800050de:	08054c63          	bltz	a0,80005176 <sys_pipe+0xea>
    800050e2:	fc843503          	ld	a0,-56(s0)
    800050e6:	fffff097          	auipc	ra,0xfffff
    800050ea:	4f4080e7          	jalr	1268(ra) # 800045da <fdalloc>
    800050ee:	fca42023          	sw	a0,-64(s0)
    800050f2:	06054863          	bltz	a0,80005162 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050f6:	4691                	li	a3,4
    800050f8:	fc440613          	addi	a2,s0,-60
    800050fc:	fd843583          	ld	a1,-40(s0)
    80005100:	68a8                	ld	a0,80(s1)
    80005102:	ffffc097          	auipc	ra,0xffffc
    80005106:	b02080e7          	jalr	-1278(ra) # 80000c04 <copyout>
    8000510a:	02054063          	bltz	a0,8000512a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000510e:	4691                	li	a3,4
    80005110:	fc040613          	addi	a2,s0,-64
    80005114:	fd843583          	ld	a1,-40(s0)
    80005118:	0591                	addi	a1,a1,4
    8000511a:	68a8                	ld	a0,80(s1)
    8000511c:	ffffc097          	auipc	ra,0xffffc
    80005120:	ae8080e7          	jalr	-1304(ra) # 80000c04 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005124:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005126:	06055563          	bgez	a0,80005190 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000512a:	fc442783          	lw	a5,-60(s0)
    8000512e:	07e9                	addi	a5,a5,26
    80005130:	078e                	slli	a5,a5,0x3
    80005132:	97a6                	add	a5,a5,s1
    80005134:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005138:	fc042503          	lw	a0,-64(s0)
    8000513c:	0569                	addi	a0,a0,26
    8000513e:	050e                	slli	a0,a0,0x3
    80005140:	9526                	add	a0,a0,s1
    80005142:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005146:	fd043503          	ld	a0,-48(s0)
    8000514a:	fffff097          	auipc	ra,0xfffff
    8000514e:	a26080e7          	jalr	-1498(ra) # 80003b70 <fileclose>
    fileclose(wf);
    80005152:	fc843503          	ld	a0,-56(s0)
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	a1a080e7          	jalr	-1510(ra) # 80003b70 <fileclose>
    return -1;
    8000515e:	57fd                	li	a5,-1
    80005160:	a805                	j	80005190 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005162:	fc442783          	lw	a5,-60(s0)
    80005166:	0007c863          	bltz	a5,80005176 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000516a:	01a78513          	addi	a0,a5,26
    8000516e:	050e                	slli	a0,a0,0x3
    80005170:	9526                	add	a0,a0,s1
    80005172:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005176:	fd043503          	ld	a0,-48(s0)
    8000517a:	fffff097          	auipc	ra,0xfffff
    8000517e:	9f6080e7          	jalr	-1546(ra) # 80003b70 <fileclose>
    fileclose(wf);
    80005182:	fc843503          	ld	a0,-56(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	9ea080e7          	jalr	-1558(ra) # 80003b70 <fileclose>
    return -1;
    8000518e:	57fd                	li	a5,-1
}
    80005190:	853e                	mv	a0,a5
    80005192:	70e2                	ld	ra,56(sp)
    80005194:	7442                	ld	s0,48(sp)
    80005196:	74a2                	ld	s1,40(sp)
    80005198:	6121                	addi	sp,sp,64
    8000519a:	8082                	ret
    8000519c:	0000                	unimp
	...

00000000800051a0 <kernelvec>:
    800051a0:	7111                	addi	sp,sp,-256
    800051a2:	e006                	sd	ra,0(sp)
    800051a4:	e40a                	sd	sp,8(sp)
    800051a6:	e80e                	sd	gp,16(sp)
    800051a8:	ec12                	sd	tp,24(sp)
    800051aa:	f016                	sd	t0,32(sp)
    800051ac:	f41a                	sd	t1,40(sp)
    800051ae:	f81e                	sd	t2,48(sp)
    800051b0:	fc22                	sd	s0,56(sp)
    800051b2:	e0a6                	sd	s1,64(sp)
    800051b4:	e4aa                	sd	a0,72(sp)
    800051b6:	e8ae                	sd	a1,80(sp)
    800051b8:	ecb2                	sd	a2,88(sp)
    800051ba:	f0b6                	sd	a3,96(sp)
    800051bc:	f4ba                	sd	a4,104(sp)
    800051be:	f8be                	sd	a5,112(sp)
    800051c0:	fcc2                	sd	a6,120(sp)
    800051c2:	e146                	sd	a7,128(sp)
    800051c4:	e54a                	sd	s2,136(sp)
    800051c6:	e94e                	sd	s3,144(sp)
    800051c8:	ed52                	sd	s4,152(sp)
    800051ca:	f156                	sd	s5,160(sp)
    800051cc:	f55a                	sd	s6,168(sp)
    800051ce:	f95e                	sd	s7,176(sp)
    800051d0:	fd62                	sd	s8,184(sp)
    800051d2:	e1e6                	sd	s9,192(sp)
    800051d4:	e5ea                	sd	s10,200(sp)
    800051d6:	e9ee                	sd	s11,208(sp)
    800051d8:	edf2                	sd	t3,216(sp)
    800051da:	f1f6                	sd	t4,224(sp)
    800051dc:	f5fa                	sd	t5,232(sp)
    800051de:	f9fe                	sd	t6,240(sp)
    800051e0:	cc3fc0ef          	jal	ra,80001ea2 <kerneltrap>
    800051e4:	6082                	ld	ra,0(sp)
    800051e6:	6122                	ld	sp,8(sp)
    800051e8:	61c2                	ld	gp,16(sp)
    800051ea:	7282                	ld	t0,32(sp)
    800051ec:	7322                	ld	t1,40(sp)
    800051ee:	73c2                	ld	t2,48(sp)
    800051f0:	7462                	ld	s0,56(sp)
    800051f2:	6486                	ld	s1,64(sp)
    800051f4:	6526                	ld	a0,72(sp)
    800051f6:	65c6                	ld	a1,80(sp)
    800051f8:	6666                	ld	a2,88(sp)
    800051fa:	7686                	ld	a3,96(sp)
    800051fc:	7726                	ld	a4,104(sp)
    800051fe:	77c6                	ld	a5,112(sp)
    80005200:	7866                	ld	a6,120(sp)
    80005202:	688a                	ld	a7,128(sp)
    80005204:	692a                	ld	s2,136(sp)
    80005206:	69ca                	ld	s3,144(sp)
    80005208:	6a6a                	ld	s4,152(sp)
    8000520a:	7a8a                	ld	s5,160(sp)
    8000520c:	7b2a                	ld	s6,168(sp)
    8000520e:	7bca                	ld	s7,176(sp)
    80005210:	7c6a                	ld	s8,184(sp)
    80005212:	6c8e                	ld	s9,192(sp)
    80005214:	6d2e                	ld	s10,200(sp)
    80005216:	6dce                	ld	s11,208(sp)
    80005218:	6e6e                	ld	t3,216(sp)
    8000521a:	7e8e                	ld	t4,224(sp)
    8000521c:	7f2e                	ld	t5,232(sp)
    8000521e:	7fce                	ld	t6,240(sp)
    80005220:	6111                	addi	sp,sp,256
    80005222:	10200073          	sret
    80005226:	00000013          	nop
    8000522a:	00000013          	nop
    8000522e:	0001                	nop

0000000080005230 <timervec>:
    80005230:	34051573          	csrrw	a0,mscratch,a0
    80005234:	e10c                	sd	a1,0(a0)
    80005236:	e510                	sd	a2,8(a0)
    80005238:	e914                	sd	a3,16(a0)
    8000523a:	6d0c                	ld	a1,24(a0)
    8000523c:	7110                	ld	a2,32(a0)
    8000523e:	6194                	ld	a3,0(a1)
    80005240:	96b2                	add	a3,a3,a2
    80005242:	e194                	sd	a3,0(a1)
    80005244:	4589                	li	a1,2
    80005246:	14459073          	csrw	sip,a1
    8000524a:	6914                	ld	a3,16(a0)
    8000524c:	6510                	ld	a2,8(a0)
    8000524e:	610c                	ld	a1,0(a0)
    80005250:	34051573          	csrrw	a0,mscratch,a0
    80005254:	30200073          	mret
	...

000000008000525a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000525a:	1141                	addi	sp,sp,-16
    8000525c:	e422                	sd	s0,8(sp)
    8000525e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005260:	0c0007b7          	lui	a5,0xc000
    80005264:	4705                	li	a4,1
    80005266:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005268:	c3d8                	sw	a4,4(a5)
}
    8000526a:	6422                	ld	s0,8(sp)
    8000526c:	0141                	addi	sp,sp,16
    8000526e:	8082                	ret

0000000080005270 <plicinithart>:

void
plicinithart(void)
{
    80005270:	1141                	addi	sp,sp,-16
    80005272:	e406                	sd	ra,8(sp)
    80005274:	e022                	sd	s0,0(sp)
    80005276:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	c9a080e7          	jalr	-870(ra) # 80000f12 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005280:	0085171b          	slliw	a4,a0,0x8
    80005284:	0c0027b7          	lui	a5,0xc002
    80005288:	97ba                	add	a5,a5,a4
    8000528a:	40200713          	li	a4,1026
    8000528e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005292:	00d5151b          	slliw	a0,a0,0xd
    80005296:	0c2017b7          	lui	a5,0xc201
    8000529a:	953e                	add	a0,a0,a5
    8000529c:	00052023          	sw	zero,0(a0)
}
    800052a0:	60a2                	ld	ra,8(sp)
    800052a2:	6402                	ld	s0,0(sp)
    800052a4:	0141                	addi	sp,sp,16
    800052a6:	8082                	ret

00000000800052a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052a8:	1141                	addi	sp,sp,-16
    800052aa:	e406                	sd	ra,8(sp)
    800052ac:	e022                	sd	s0,0(sp)
    800052ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052b0:	ffffc097          	auipc	ra,0xffffc
    800052b4:	c62080e7          	jalr	-926(ra) # 80000f12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052b8:	00d5179b          	slliw	a5,a0,0xd
    800052bc:	0c201537          	lui	a0,0xc201
    800052c0:	953e                	add	a0,a0,a5
  return irq;
}
    800052c2:	4148                	lw	a0,4(a0)
    800052c4:	60a2                	ld	ra,8(sp)
    800052c6:	6402                	ld	s0,0(sp)
    800052c8:	0141                	addi	sp,sp,16
    800052ca:	8082                	ret

00000000800052cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052cc:	1101                	addi	sp,sp,-32
    800052ce:	ec06                	sd	ra,24(sp)
    800052d0:	e822                	sd	s0,16(sp)
    800052d2:	e426                	sd	s1,8(sp)
    800052d4:	1000                	addi	s0,sp,32
    800052d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	c3a080e7          	jalr	-966(ra) # 80000f12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052e0:	00d5151b          	slliw	a0,a0,0xd
    800052e4:	0c2017b7          	lui	a5,0xc201
    800052e8:	97aa                	add	a5,a5,a0
    800052ea:	c3c4                	sw	s1,4(a5)
}
    800052ec:	60e2                	ld	ra,24(sp)
    800052ee:	6442                	ld	s0,16(sp)
    800052f0:	64a2                	ld	s1,8(sp)
    800052f2:	6105                	addi	sp,sp,32
    800052f4:	8082                	ret

00000000800052f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052f6:	1141                	addi	sp,sp,-16
    800052f8:	e406                	sd	ra,8(sp)
    800052fa:	e022                	sd	s0,0(sp)
    800052fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052fe:	479d                	li	a5,7
    80005300:	06a7c963          	blt	a5,a0,80005372 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005304:	00016797          	auipc	a5,0x16
    80005308:	cfc78793          	addi	a5,a5,-772 # 8001b000 <disk>
    8000530c:	00a78733          	add	a4,a5,a0
    80005310:	6789                	lui	a5,0x2
    80005312:	97ba                	add	a5,a5,a4
    80005314:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005318:	e7ad                	bnez	a5,80005382 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000531a:	00451793          	slli	a5,a0,0x4
    8000531e:	00018717          	auipc	a4,0x18
    80005322:	ce270713          	addi	a4,a4,-798 # 8001d000 <disk+0x2000>
    80005326:	6314                	ld	a3,0(a4)
    80005328:	96be                	add	a3,a3,a5
    8000532a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000532e:	6314                	ld	a3,0(a4)
    80005330:	96be                	add	a3,a3,a5
    80005332:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005336:	6314                	ld	a3,0(a4)
    80005338:	96be                	add	a3,a3,a5
    8000533a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000533e:	6318                	ld	a4,0(a4)
    80005340:	97ba                	add	a5,a5,a4
    80005342:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005346:	00016797          	auipc	a5,0x16
    8000534a:	cba78793          	addi	a5,a5,-838 # 8001b000 <disk>
    8000534e:	97aa                	add	a5,a5,a0
    80005350:	6509                	lui	a0,0x2
    80005352:	953e                	add	a0,a0,a5
    80005354:	4785                	li	a5,1
    80005356:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000535a:	00018517          	auipc	a0,0x18
    8000535e:	cbe50513          	addi	a0,a0,-834 # 8001d018 <disk+0x2018>
    80005362:	ffffc097          	auipc	ra,0xffffc
    80005366:	4aa080e7          	jalr	1194(ra) # 8000180c <wakeup>
}
    8000536a:	60a2                	ld	ra,8(sp)
    8000536c:	6402                	ld	s0,0(sp)
    8000536e:	0141                	addi	sp,sp,16
    80005370:	8082                	ret
    panic("free_desc 1");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	41e50513          	addi	a0,a0,1054 # 80008790 <syscalls+0x398>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	a1e080e7          	jalr	-1506(ra) # 80005d98 <panic>
    panic("free_desc 2");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	41e50513          	addi	a0,a0,1054 # 800087a0 <syscalls+0x3a8>
    8000538a:	00001097          	auipc	ra,0x1
    8000538e:	a0e080e7          	jalr	-1522(ra) # 80005d98 <panic>

0000000080005392 <virtio_disk_init>:
{
    80005392:	1101                	addi	sp,sp,-32
    80005394:	ec06                	sd	ra,24(sp)
    80005396:	e822                	sd	s0,16(sp)
    80005398:	e426                	sd	s1,8(sp)
    8000539a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000539c:	00003597          	auipc	a1,0x3
    800053a0:	41458593          	addi	a1,a1,1044 # 800087b0 <syscalls+0x3b8>
    800053a4:	00018517          	auipc	a0,0x18
    800053a8:	d8450513          	addi	a0,a0,-636 # 8001d128 <disk+0x2128>
    800053ac:	00001097          	auipc	ra,0x1
    800053b0:	ea6080e7          	jalr	-346(ra) # 80006252 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053b4:	100017b7          	lui	a5,0x10001
    800053b8:	4398                	lw	a4,0(a5)
    800053ba:	2701                	sext.w	a4,a4
    800053bc:	747277b7          	lui	a5,0x74727
    800053c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053c4:	0ef71163          	bne	a4,a5,800054a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053c8:	100017b7          	lui	a5,0x10001
    800053cc:	43dc                	lw	a5,4(a5)
    800053ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053d0:	4705                	li	a4,1
    800053d2:	0ce79a63          	bne	a5,a4,800054a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053d6:	100017b7          	lui	a5,0x10001
    800053da:	479c                	lw	a5,8(a5)
    800053dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053de:	4709                	li	a4,2
    800053e0:	0ce79363          	bne	a5,a4,800054a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053e4:	100017b7          	lui	a5,0x10001
    800053e8:	47d8                	lw	a4,12(a5)
    800053ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053ec:	554d47b7          	lui	a5,0x554d4
    800053f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053f4:	0af71963          	bne	a4,a5,800054a6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	4705                	li	a4,1
    800053fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005400:	470d                	li	a4,3
    80005402:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005404:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005406:	c7ffe737          	lui	a4,0xc7ffe
    8000540a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000540e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005410:	2701                	sext.w	a4,a4
    80005412:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005414:	472d                	li	a4,11
    80005416:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005418:	473d                	li	a4,15
    8000541a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000541c:	6705                	lui	a4,0x1
    8000541e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005420:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005424:	5bdc                	lw	a5,52(a5)
    80005426:	2781                	sext.w	a5,a5
  if(max == 0)
    80005428:	c7d9                	beqz	a5,800054b6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000542a:	471d                	li	a4,7
    8000542c:	08f77d63          	bgeu	a4,a5,800054c6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005430:	100014b7          	lui	s1,0x10001
    80005434:	47a1                	li	a5,8
    80005436:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005438:	6609                	lui	a2,0x2
    8000543a:	4581                	li	a1,0
    8000543c:	00016517          	auipc	a0,0x16
    80005440:	bc450513          	addi	a0,a0,-1084 # 8001b000 <disk>
    80005444:	ffffb097          	auipc	ra,0xffffb
    80005448:	d34080e7          	jalr	-716(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000544c:	00016717          	auipc	a4,0x16
    80005450:	bb470713          	addi	a4,a4,-1100 # 8001b000 <disk>
    80005454:	00c75793          	srli	a5,a4,0xc
    80005458:	2781                	sext.w	a5,a5
    8000545a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000545c:	00018797          	auipc	a5,0x18
    80005460:	ba478793          	addi	a5,a5,-1116 # 8001d000 <disk+0x2000>
    80005464:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005466:	00016717          	auipc	a4,0x16
    8000546a:	c1a70713          	addi	a4,a4,-998 # 8001b080 <disk+0x80>
    8000546e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005470:	00017717          	auipc	a4,0x17
    80005474:	b9070713          	addi	a4,a4,-1136 # 8001c000 <disk+0x1000>
    80005478:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000547a:	4705                	li	a4,1
    8000547c:	00e78c23          	sb	a4,24(a5)
    80005480:	00e78ca3          	sb	a4,25(a5)
    80005484:	00e78d23          	sb	a4,26(a5)
    80005488:	00e78da3          	sb	a4,27(a5)
    8000548c:	00e78e23          	sb	a4,28(a5)
    80005490:	00e78ea3          	sb	a4,29(a5)
    80005494:	00e78f23          	sb	a4,30(a5)
    80005498:	00e78fa3          	sb	a4,31(a5)
}
    8000549c:	60e2                	ld	ra,24(sp)
    8000549e:	6442                	ld	s0,16(sp)
    800054a0:	64a2                	ld	s1,8(sp)
    800054a2:	6105                	addi	sp,sp,32
    800054a4:	8082                	ret
    panic("could not find virtio disk");
    800054a6:	00003517          	auipc	a0,0x3
    800054aa:	31a50513          	addi	a0,a0,794 # 800087c0 <syscalls+0x3c8>
    800054ae:	00001097          	auipc	ra,0x1
    800054b2:	8ea080e7          	jalr	-1814(ra) # 80005d98 <panic>
    panic("virtio disk has no queue 0");
    800054b6:	00003517          	auipc	a0,0x3
    800054ba:	32a50513          	addi	a0,a0,810 # 800087e0 <syscalls+0x3e8>
    800054be:	00001097          	auipc	ra,0x1
    800054c2:	8da080e7          	jalr	-1830(ra) # 80005d98 <panic>
    panic("virtio disk max queue too short");
    800054c6:	00003517          	auipc	a0,0x3
    800054ca:	33a50513          	addi	a0,a0,826 # 80008800 <syscalls+0x408>
    800054ce:	00001097          	auipc	ra,0x1
    800054d2:	8ca080e7          	jalr	-1846(ra) # 80005d98 <panic>

00000000800054d6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054d6:	7159                	addi	sp,sp,-112
    800054d8:	f486                	sd	ra,104(sp)
    800054da:	f0a2                	sd	s0,96(sp)
    800054dc:	eca6                	sd	s1,88(sp)
    800054de:	e8ca                	sd	s2,80(sp)
    800054e0:	e4ce                	sd	s3,72(sp)
    800054e2:	e0d2                	sd	s4,64(sp)
    800054e4:	fc56                	sd	s5,56(sp)
    800054e6:	f85a                	sd	s6,48(sp)
    800054e8:	f45e                	sd	s7,40(sp)
    800054ea:	f062                	sd	s8,32(sp)
    800054ec:	ec66                	sd	s9,24(sp)
    800054ee:	e86a                	sd	s10,16(sp)
    800054f0:	1880                	addi	s0,sp,112
    800054f2:	892a                	mv	s2,a0
    800054f4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054f6:	00c52c83          	lw	s9,12(a0)
    800054fa:	001c9c9b          	slliw	s9,s9,0x1
    800054fe:	1c82                	slli	s9,s9,0x20
    80005500:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005504:	00018517          	auipc	a0,0x18
    80005508:	c2450513          	addi	a0,a0,-988 # 8001d128 <disk+0x2128>
    8000550c:	00001097          	auipc	ra,0x1
    80005510:	dd6080e7          	jalr	-554(ra) # 800062e2 <acquire>
  for(int i = 0; i < 3; i++){
    80005514:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005516:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005518:	00016b97          	auipc	s7,0x16
    8000551c:	ae8b8b93          	addi	s7,s7,-1304 # 8001b000 <disk>
    80005520:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005522:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005524:	8a4e                	mv	s4,s3
    80005526:	a051                	j	800055aa <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005528:	00fb86b3          	add	a3,s7,a5
    8000552c:	96da                	add	a3,a3,s6
    8000552e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005532:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005534:	0207c563          	bltz	a5,8000555e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005538:	2485                	addiw	s1,s1,1
    8000553a:	0711                	addi	a4,a4,4
    8000553c:	25548063          	beq	s1,s5,8000577c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005540:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005542:	00018697          	auipc	a3,0x18
    80005546:	ad668693          	addi	a3,a3,-1322 # 8001d018 <disk+0x2018>
    8000554a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000554c:	0006c583          	lbu	a1,0(a3)
    80005550:	fde1                	bnez	a1,80005528 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005552:	2785                	addiw	a5,a5,1
    80005554:	0685                	addi	a3,a3,1
    80005556:	ff879be3          	bne	a5,s8,8000554c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000555a:	57fd                	li	a5,-1
    8000555c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000555e:	02905a63          	blez	s1,80005592 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005562:	f9042503          	lw	a0,-112(s0)
    80005566:	00000097          	auipc	ra,0x0
    8000556a:	d90080e7          	jalr	-624(ra) # 800052f6 <free_desc>
      for(int j = 0; j < i; j++)
    8000556e:	4785                	li	a5,1
    80005570:	0297d163          	bge	a5,s1,80005592 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005574:	f9442503          	lw	a0,-108(s0)
    80005578:	00000097          	auipc	ra,0x0
    8000557c:	d7e080e7          	jalr	-642(ra) # 800052f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005580:	4789                	li	a5,2
    80005582:	0097d863          	bge	a5,s1,80005592 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005586:	f9842503          	lw	a0,-104(s0)
    8000558a:	00000097          	auipc	ra,0x0
    8000558e:	d6c080e7          	jalr	-660(ra) # 800052f6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005592:	00018597          	auipc	a1,0x18
    80005596:	b9658593          	addi	a1,a1,-1130 # 8001d128 <disk+0x2128>
    8000559a:	00018517          	auipc	a0,0x18
    8000559e:	a7e50513          	addi	a0,a0,-1410 # 8001d018 <disk+0x2018>
    800055a2:	ffffc097          	auipc	ra,0xffffc
    800055a6:	0de080e7          	jalr	222(ra) # 80001680 <sleep>
  for(int i = 0; i < 3; i++){
    800055aa:	f9040713          	addi	a4,s0,-112
    800055ae:	84ce                	mv	s1,s3
    800055b0:	bf41                	j	80005540 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055b2:	20058713          	addi	a4,a1,512
    800055b6:	00471693          	slli	a3,a4,0x4
    800055ba:	00016717          	auipc	a4,0x16
    800055be:	a4670713          	addi	a4,a4,-1466 # 8001b000 <disk>
    800055c2:	9736                	add	a4,a4,a3
    800055c4:	4685                	li	a3,1
    800055c6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055ca:	20058713          	addi	a4,a1,512
    800055ce:	00471693          	slli	a3,a4,0x4
    800055d2:	00016717          	auipc	a4,0x16
    800055d6:	a2e70713          	addi	a4,a4,-1490 # 8001b000 <disk>
    800055da:	9736                	add	a4,a4,a3
    800055dc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055e0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055e4:	7679                	lui	a2,0xffffe
    800055e6:	963e                	add	a2,a2,a5
    800055e8:	00018697          	auipc	a3,0x18
    800055ec:	a1868693          	addi	a3,a3,-1512 # 8001d000 <disk+0x2000>
    800055f0:	6298                	ld	a4,0(a3)
    800055f2:	9732                	add	a4,a4,a2
    800055f4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055f6:	6298                	ld	a4,0(a3)
    800055f8:	9732                	add	a4,a4,a2
    800055fa:	4541                	li	a0,16
    800055fc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055fe:	6298                	ld	a4,0(a3)
    80005600:	9732                	add	a4,a4,a2
    80005602:	4505                	li	a0,1
    80005604:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005608:	f9442703          	lw	a4,-108(s0)
    8000560c:	6288                	ld	a0,0(a3)
    8000560e:	962a                	add	a2,a2,a0
    80005610:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005614:	0712                	slli	a4,a4,0x4
    80005616:	6290                	ld	a2,0(a3)
    80005618:	963a                	add	a2,a2,a4
    8000561a:	05890513          	addi	a0,s2,88
    8000561e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005620:	6294                	ld	a3,0(a3)
    80005622:	96ba                	add	a3,a3,a4
    80005624:	40000613          	li	a2,1024
    80005628:	c690                	sw	a2,8(a3)
  if(write)
    8000562a:	140d0063          	beqz	s10,8000576a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000562e:	00018697          	auipc	a3,0x18
    80005632:	9d26b683          	ld	a3,-1582(a3) # 8001d000 <disk+0x2000>
    80005636:	96ba                	add	a3,a3,a4
    80005638:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000563c:	00016817          	auipc	a6,0x16
    80005640:	9c480813          	addi	a6,a6,-1596 # 8001b000 <disk>
    80005644:	00018517          	auipc	a0,0x18
    80005648:	9bc50513          	addi	a0,a0,-1604 # 8001d000 <disk+0x2000>
    8000564c:	6114                	ld	a3,0(a0)
    8000564e:	96ba                	add	a3,a3,a4
    80005650:	00c6d603          	lhu	a2,12(a3)
    80005654:	00166613          	ori	a2,a2,1
    80005658:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000565c:	f9842683          	lw	a3,-104(s0)
    80005660:	6110                	ld	a2,0(a0)
    80005662:	9732                	add	a4,a4,a2
    80005664:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005668:	20058613          	addi	a2,a1,512
    8000566c:	0612                	slli	a2,a2,0x4
    8000566e:	9642                	add	a2,a2,a6
    80005670:	577d                	li	a4,-1
    80005672:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005676:	00469713          	slli	a4,a3,0x4
    8000567a:	6114                	ld	a3,0(a0)
    8000567c:	96ba                	add	a3,a3,a4
    8000567e:	03078793          	addi	a5,a5,48
    80005682:	97c2                	add	a5,a5,a6
    80005684:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005686:	611c                	ld	a5,0(a0)
    80005688:	97ba                	add	a5,a5,a4
    8000568a:	4685                	li	a3,1
    8000568c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000568e:	611c                	ld	a5,0(a0)
    80005690:	97ba                	add	a5,a5,a4
    80005692:	4809                	li	a6,2
    80005694:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005698:	611c                	ld	a5,0(a0)
    8000569a:	973e                	add	a4,a4,a5
    8000569c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056a0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056a4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056a8:	6518                	ld	a4,8(a0)
    800056aa:	00275783          	lhu	a5,2(a4)
    800056ae:	8b9d                	andi	a5,a5,7
    800056b0:	0786                	slli	a5,a5,0x1
    800056b2:	97ba                	add	a5,a5,a4
    800056b4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056b8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056bc:	6518                	ld	a4,8(a0)
    800056be:	00275783          	lhu	a5,2(a4)
    800056c2:	2785                	addiw	a5,a5,1
    800056c4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056c8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056cc:	100017b7          	lui	a5,0x10001
    800056d0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056d4:	00492703          	lw	a4,4(s2)
    800056d8:	4785                	li	a5,1
    800056da:	02f71163          	bne	a4,a5,800056fc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800056de:	00018997          	auipc	s3,0x18
    800056e2:	a4a98993          	addi	s3,s3,-1462 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056e6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056e8:	85ce                	mv	a1,s3
    800056ea:	854a                	mv	a0,s2
    800056ec:	ffffc097          	auipc	ra,0xffffc
    800056f0:	f94080e7          	jalr	-108(ra) # 80001680 <sleep>
  while(b->disk == 1) {
    800056f4:	00492783          	lw	a5,4(s2)
    800056f8:	fe9788e3          	beq	a5,s1,800056e8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056fc:	f9042903          	lw	s2,-112(s0)
    80005700:	20090793          	addi	a5,s2,512
    80005704:	00479713          	slli	a4,a5,0x4
    80005708:	00016797          	auipc	a5,0x16
    8000570c:	8f878793          	addi	a5,a5,-1800 # 8001b000 <disk>
    80005710:	97ba                	add	a5,a5,a4
    80005712:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005716:	00018997          	auipc	s3,0x18
    8000571a:	8ea98993          	addi	s3,s3,-1814 # 8001d000 <disk+0x2000>
    8000571e:	00491713          	slli	a4,s2,0x4
    80005722:	0009b783          	ld	a5,0(s3)
    80005726:	97ba                	add	a5,a5,a4
    80005728:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000572c:	854a                	mv	a0,s2
    8000572e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005732:	00000097          	auipc	ra,0x0
    80005736:	bc4080e7          	jalr	-1084(ra) # 800052f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000573a:	8885                	andi	s1,s1,1
    8000573c:	f0ed                	bnez	s1,8000571e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000573e:	00018517          	auipc	a0,0x18
    80005742:	9ea50513          	addi	a0,a0,-1558 # 8001d128 <disk+0x2128>
    80005746:	00001097          	auipc	ra,0x1
    8000574a:	c50080e7          	jalr	-944(ra) # 80006396 <release>
}
    8000574e:	70a6                	ld	ra,104(sp)
    80005750:	7406                	ld	s0,96(sp)
    80005752:	64e6                	ld	s1,88(sp)
    80005754:	6946                	ld	s2,80(sp)
    80005756:	69a6                	ld	s3,72(sp)
    80005758:	6a06                	ld	s4,64(sp)
    8000575a:	7ae2                	ld	s5,56(sp)
    8000575c:	7b42                	ld	s6,48(sp)
    8000575e:	7ba2                	ld	s7,40(sp)
    80005760:	7c02                	ld	s8,32(sp)
    80005762:	6ce2                	ld	s9,24(sp)
    80005764:	6d42                	ld	s10,16(sp)
    80005766:	6165                	addi	sp,sp,112
    80005768:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000576a:	00018697          	auipc	a3,0x18
    8000576e:	8966b683          	ld	a3,-1898(a3) # 8001d000 <disk+0x2000>
    80005772:	96ba                	add	a3,a3,a4
    80005774:	4609                	li	a2,2
    80005776:	00c69623          	sh	a2,12(a3)
    8000577a:	b5c9                	j	8000563c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000577c:	f9042583          	lw	a1,-112(s0)
    80005780:	20058793          	addi	a5,a1,512
    80005784:	0792                	slli	a5,a5,0x4
    80005786:	00016517          	auipc	a0,0x16
    8000578a:	92250513          	addi	a0,a0,-1758 # 8001b0a8 <disk+0xa8>
    8000578e:	953e                	add	a0,a0,a5
  if(write)
    80005790:	e20d11e3          	bnez	s10,800055b2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005794:	20058713          	addi	a4,a1,512
    80005798:	00471693          	slli	a3,a4,0x4
    8000579c:	00016717          	auipc	a4,0x16
    800057a0:	86470713          	addi	a4,a4,-1948 # 8001b000 <disk>
    800057a4:	9736                	add	a4,a4,a3
    800057a6:	0a072423          	sw	zero,168(a4)
    800057aa:	b505                	j	800055ca <virtio_disk_rw+0xf4>

00000000800057ac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057ac:	1101                	addi	sp,sp,-32
    800057ae:	ec06                	sd	ra,24(sp)
    800057b0:	e822                	sd	s0,16(sp)
    800057b2:	e426                	sd	s1,8(sp)
    800057b4:	e04a                	sd	s2,0(sp)
    800057b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057b8:	00018517          	auipc	a0,0x18
    800057bc:	97050513          	addi	a0,a0,-1680 # 8001d128 <disk+0x2128>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	b22080e7          	jalr	-1246(ra) # 800062e2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057c8:	10001737          	lui	a4,0x10001
    800057cc:	533c                	lw	a5,96(a4)
    800057ce:	8b8d                	andi	a5,a5,3
    800057d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057d6:	00018797          	auipc	a5,0x18
    800057da:	82a78793          	addi	a5,a5,-2006 # 8001d000 <disk+0x2000>
    800057de:	6b94                	ld	a3,16(a5)
    800057e0:	0207d703          	lhu	a4,32(a5)
    800057e4:	0026d783          	lhu	a5,2(a3)
    800057e8:	06f70163          	beq	a4,a5,8000584a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ec:	00016917          	auipc	s2,0x16
    800057f0:	81490913          	addi	s2,s2,-2028 # 8001b000 <disk>
    800057f4:	00018497          	auipc	s1,0x18
    800057f8:	80c48493          	addi	s1,s1,-2036 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057fc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005800:	6898                	ld	a4,16(s1)
    80005802:	0204d783          	lhu	a5,32(s1)
    80005806:	8b9d                	andi	a5,a5,7
    80005808:	078e                	slli	a5,a5,0x3
    8000580a:	97ba                	add	a5,a5,a4
    8000580c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000580e:	20078713          	addi	a4,a5,512
    80005812:	0712                	slli	a4,a4,0x4
    80005814:	974a                	add	a4,a4,s2
    80005816:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000581a:	e731                	bnez	a4,80005866 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000581c:	20078793          	addi	a5,a5,512
    80005820:	0792                	slli	a5,a5,0x4
    80005822:	97ca                	add	a5,a5,s2
    80005824:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005826:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000582a:	ffffc097          	auipc	ra,0xffffc
    8000582e:	fe2080e7          	jalr	-30(ra) # 8000180c <wakeup>

    disk.used_idx += 1;
    80005832:	0204d783          	lhu	a5,32(s1)
    80005836:	2785                	addiw	a5,a5,1
    80005838:	17c2                	slli	a5,a5,0x30
    8000583a:	93c1                	srli	a5,a5,0x30
    8000583c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005840:	6898                	ld	a4,16(s1)
    80005842:	00275703          	lhu	a4,2(a4)
    80005846:	faf71be3          	bne	a4,a5,800057fc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000584a:	00018517          	auipc	a0,0x18
    8000584e:	8de50513          	addi	a0,a0,-1826 # 8001d128 <disk+0x2128>
    80005852:	00001097          	auipc	ra,0x1
    80005856:	b44080e7          	jalr	-1212(ra) # 80006396 <release>
}
    8000585a:	60e2                	ld	ra,24(sp)
    8000585c:	6442                	ld	s0,16(sp)
    8000585e:	64a2                	ld	s1,8(sp)
    80005860:	6902                	ld	s2,0(sp)
    80005862:	6105                	addi	sp,sp,32
    80005864:	8082                	ret
      panic("virtio_disk_intr status");
    80005866:	00003517          	auipc	a0,0x3
    8000586a:	fba50513          	addi	a0,a0,-70 # 80008820 <syscalls+0x428>
    8000586e:	00000097          	auipc	ra,0x0
    80005872:	52a080e7          	jalr	1322(ra) # 80005d98 <panic>

0000000080005876 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005876:	1141                	addi	sp,sp,-16
    80005878:	e422                	sd	s0,8(sp)
    8000587a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000587c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005880:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005884:	0037979b          	slliw	a5,a5,0x3
    80005888:	02004737          	lui	a4,0x2004
    8000588c:	97ba                	add	a5,a5,a4
    8000588e:	0200c737          	lui	a4,0x200c
    80005892:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005896:	000f4637          	lui	a2,0xf4
    8000589a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000589e:	95b2                	add	a1,a1,a2
    800058a0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058a2:	00269713          	slli	a4,a3,0x2
    800058a6:	9736                	add	a4,a4,a3
    800058a8:	00371693          	slli	a3,a4,0x3
    800058ac:	00018717          	auipc	a4,0x18
    800058b0:	75470713          	addi	a4,a4,1876 # 8001e000 <timer_scratch>
    800058b4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058b6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058b8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058be:	00000797          	auipc	a5,0x0
    800058c2:	97278793          	addi	a5,a5,-1678 # 80005230 <timervec>
    800058c6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058ca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058ce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058d6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058da:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058de:	30479073          	csrw	mie,a5
}
    800058e2:	6422                	ld	s0,8(sp)
    800058e4:	0141                	addi	sp,sp,16
    800058e6:	8082                	ret

00000000800058e8 <start>:
{
    800058e8:	1141                	addi	sp,sp,-16
    800058ea:	e406                	sd	ra,8(sp)
    800058ec:	e022                	sd	s0,0(sp)
    800058ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058f0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058f4:	7779                	lui	a4,0xffffe
    800058f6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058fa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058fc:	6705                	lui	a4,0x1
    800058fe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005902:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005904:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005908:	ffffb797          	auipc	a5,0xffffb
    8000590c:	a1e78793          	addi	a5,a5,-1506 # 80000326 <main>
    80005910:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005914:	4781                	li	a5,0
    80005916:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000591a:	67c1                	lui	a5,0x10
    8000591c:	17fd                	addi	a5,a5,-1
    8000591e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005922:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005926:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000592a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000592e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005932:	57fd                	li	a5,-1
    80005934:	83a9                	srli	a5,a5,0xa
    80005936:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000593a:	47bd                	li	a5,15
    8000593c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005940:	00000097          	auipc	ra,0x0
    80005944:	f36080e7          	jalr	-202(ra) # 80005876 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005948:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000594c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000594e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005950:	30200073          	mret
}
    80005954:	60a2                	ld	ra,8(sp)
    80005956:	6402                	ld	s0,0(sp)
    80005958:	0141                	addi	sp,sp,16
    8000595a:	8082                	ret

000000008000595c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000595c:	715d                	addi	sp,sp,-80
    8000595e:	e486                	sd	ra,72(sp)
    80005960:	e0a2                	sd	s0,64(sp)
    80005962:	fc26                	sd	s1,56(sp)
    80005964:	f84a                	sd	s2,48(sp)
    80005966:	f44e                	sd	s3,40(sp)
    80005968:	f052                	sd	s4,32(sp)
    8000596a:	ec56                	sd	s5,24(sp)
    8000596c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000596e:	04c05663          	blez	a2,800059ba <consolewrite+0x5e>
    80005972:	8a2a                	mv	s4,a0
    80005974:	84ae                	mv	s1,a1
    80005976:	89b2                	mv	s3,a2
    80005978:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000597a:	5afd                	li	s5,-1
    8000597c:	4685                	li	a3,1
    8000597e:	8626                	mv	a2,s1
    80005980:	85d2                	mv	a1,s4
    80005982:	fbf40513          	addi	a0,s0,-65
    80005986:	ffffc097          	auipc	ra,0xffffc
    8000598a:	0f4080e7          	jalr	244(ra) # 80001a7a <either_copyin>
    8000598e:	01550c63          	beq	a0,s5,800059a6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005992:	fbf44503          	lbu	a0,-65(s0)
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	78e080e7          	jalr	1934(ra) # 80006124 <uartputc>
  for(i = 0; i < n; i++){
    8000599e:	2905                	addiw	s2,s2,1
    800059a0:	0485                	addi	s1,s1,1
    800059a2:	fd299de3          	bne	s3,s2,8000597c <consolewrite+0x20>
  }

  return i;
}
    800059a6:	854a                	mv	a0,s2
    800059a8:	60a6                	ld	ra,72(sp)
    800059aa:	6406                	ld	s0,64(sp)
    800059ac:	74e2                	ld	s1,56(sp)
    800059ae:	7942                	ld	s2,48(sp)
    800059b0:	79a2                	ld	s3,40(sp)
    800059b2:	7a02                	ld	s4,32(sp)
    800059b4:	6ae2                	ld	s5,24(sp)
    800059b6:	6161                	addi	sp,sp,80
    800059b8:	8082                	ret
  for(i = 0; i < n; i++){
    800059ba:	4901                	li	s2,0
    800059bc:	b7ed                	j	800059a6 <consolewrite+0x4a>

00000000800059be <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059be:	7119                	addi	sp,sp,-128
    800059c0:	fc86                	sd	ra,120(sp)
    800059c2:	f8a2                	sd	s0,112(sp)
    800059c4:	f4a6                	sd	s1,104(sp)
    800059c6:	f0ca                	sd	s2,96(sp)
    800059c8:	ecce                	sd	s3,88(sp)
    800059ca:	e8d2                	sd	s4,80(sp)
    800059cc:	e4d6                	sd	s5,72(sp)
    800059ce:	e0da                	sd	s6,64(sp)
    800059d0:	fc5e                	sd	s7,56(sp)
    800059d2:	f862                	sd	s8,48(sp)
    800059d4:	f466                	sd	s9,40(sp)
    800059d6:	f06a                	sd	s10,32(sp)
    800059d8:	ec6e                	sd	s11,24(sp)
    800059da:	0100                	addi	s0,sp,128
    800059dc:	8b2a                	mv	s6,a0
    800059de:	8aae                	mv	s5,a1
    800059e0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059e2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059e6:	00020517          	auipc	a0,0x20
    800059ea:	75a50513          	addi	a0,a0,1882 # 80026140 <cons>
    800059ee:	00001097          	auipc	ra,0x1
    800059f2:	8f4080e7          	jalr	-1804(ra) # 800062e2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059f6:	00020497          	auipc	s1,0x20
    800059fa:	74a48493          	addi	s1,s1,1866 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059fe:	89a6                	mv	s3,s1
    80005a00:	00020917          	auipc	s2,0x20
    80005a04:	7d890913          	addi	s2,s2,2008 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a08:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a0a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a0c:	4da9                	li	s11,10
  while(n > 0){
    80005a0e:	07405863          	blez	s4,80005a7e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a12:	0984a783          	lw	a5,152(s1)
    80005a16:	09c4a703          	lw	a4,156(s1)
    80005a1a:	02f71463          	bne	a4,a5,80005a42 <consoleread+0x84>
      if(myproc()->killed){
    80005a1e:	ffffb097          	auipc	ra,0xffffb
    80005a22:	520080e7          	jalr	1312(ra) # 80000f3e <myproc>
    80005a26:	551c                	lw	a5,40(a0)
    80005a28:	e7b5                	bnez	a5,80005a94 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a2a:	85ce                	mv	a1,s3
    80005a2c:	854a                	mv	a0,s2
    80005a2e:	ffffc097          	auipc	ra,0xffffc
    80005a32:	c52080e7          	jalr	-942(ra) # 80001680 <sleep>
    while(cons.r == cons.w){
    80005a36:	0984a783          	lw	a5,152(s1)
    80005a3a:	09c4a703          	lw	a4,156(s1)
    80005a3e:	fef700e3          	beq	a4,a5,80005a1e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a42:	0017871b          	addiw	a4,a5,1
    80005a46:	08e4ac23          	sw	a4,152(s1)
    80005a4a:	07f7f713          	andi	a4,a5,127
    80005a4e:	9726                	add	a4,a4,s1
    80005a50:	01874703          	lbu	a4,24(a4)
    80005a54:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a58:	079c0663          	beq	s8,s9,80005ac4 <consoleread+0x106>
    cbuf = c;
    80005a5c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a60:	4685                	li	a3,1
    80005a62:	f8f40613          	addi	a2,s0,-113
    80005a66:	85d6                	mv	a1,s5
    80005a68:	855a                	mv	a0,s6
    80005a6a:	ffffc097          	auipc	ra,0xffffc
    80005a6e:	fba080e7          	jalr	-70(ra) # 80001a24 <either_copyout>
    80005a72:	01a50663          	beq	a0,s10,80005a7e <consoleread+0xc0>
    dst++;
    80005a76:	0a85                	addi	s5,s5,1
    --n;
    80005a78:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a7a:	f9bc1ae3          	bne	s8,s11,80005a0e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a7e:	00020517          	auipc	a0,0x20
    80005a82:	6c250513          	addi	a0,a0,1730 # 80026140 <cons>
    80005a86:	00001097          	auipc	ra,0x1
    80005a8a:	910080e7          	jalr	-1776(ra) # 80006396 <release>

  return target - n;
    80005a8e:	414b853b          	subw	a0,s7,s4
    80005a92:	a811                	j	80005aa6 <consoleread+0xe8>
        release(&cons.lock);
    80005a94:	00020517          	auipc	a0,0x20
    80005a98:	6ac50513          	addi	a0,a0,1708 # 80026140 <cons>
    80005a9c:	00001097          	auipc	ra,0x1
    80005aa0:	8fa080e7          	jalr	-1798(ra) # 80006396 <release>
        return -1;
    80005aa4:	557d                	li	a0,-1
}
    80005aa6:	70e6                	ld	ra,120(sp)
    80005aa8:	7446                	ld	s0,112(sp)
    80005aaa:	74a6                	ld	s1,104(sp)
    80005aac:	7906                	ld	s2,96(sp)
    80005aae:	69e6                	ld	s3,88(sp)
    80005ab0:	6a46                	ld	s4,80(sp)
    80005ab2:	6aa6                	ld	s5,72(sp)
    80005ab4:	6b06                	ld	s6,64(sp)
    80005ab6:	7be2                	ld	s7,56(sp)
    80005ab8:	7c42                	ld	s8,48(sp)
    80005aba:	7ca2                	ld	s9,40(sp)
    80005abc:	7d02                	ld	s10,32(sp)
    80005abe:	6de2                	ld	s11,24(sp)
    80005ac0:	6109                	addi	sp,sp,128
    80005ac2:	8082                	ret
      if(n < target){
    80005ac4:	000a071b          	sext.w	a4,s4
    80005ac8:	fb777be3          	bgeu	a4,s7,80005a7e <consoleread+0xc0>
        cons.r--;
    80005acc:	00020717          	auipc	a4,0x20
    80005ad0:	70f72623          	sw	a5,1804(a4) # 800261d8 <cons+0x98>
    80005ad4:	b76d                	j	80005a7e <consoleread+0xc0>

0000000080005ad6 <consputc>:
{
    80005ad6:	1141                	addi	sp,sp,-16
    80005ad8:	e406                	sd	ra,8(sp)
    80005ada:	e022                	sd	s0,0(sp)
    80005adc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ade:	10000793          	li	a5,256
    80005ae2:	00f50a63          	beq	a0,a5,80005af6 <consputc+0x20>
    uartputc_sync(c);
    80005ae6:	00000097          	auipc	ra,0x0
    80005aea:	564080e7          	jalr	1380(ra) # 8000604a <uartputc_sync>
}
    80005aee:	60a2                	ld	ra,8(sp)
    80005af0:	6402                	ld	s0,0(sp)
    80005af2:	0141                	addi	sp,sp,16
    80005af4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005af6:	4521                	li	a0,8
    80005af8:	00000097          	auipc	ra,0x0
    80005afc:	552080e7          	jalr	1362(ra) # 8000604a <uartputc_sync>
    80005b00:	02000513          	li	a0,32
    80005b04:	00000097          	auipc	ra,0x0
    80005b08:	546080e7          	jalr	1350(ra) # 8000604a <uartputc_sync>
    80005b0c:	4521                	li	a0,8
    80005b0e:	00000097          	auipc	ra,0x0
    80005b12:	53c080e7          	jalr	1340(ra) # 8000604a <uartputc_sync>
    80005b16:	bfe1                	j	80005aee <consputc+0x18>

0000000080005b18 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b18:	1101                	addi	sp,sp,-32
    80005b1a:	ec06                	sd	ra,24(sp)
    80005b1c:	e822                	sd	s0,16(sp)
    80005b1e:	e426                	sd	s1,8(sp)
    80005b20:	e04a                	sd	s2,0(sp)
    80005b22:	1000                	addi	s0,sp,32
    80005b24:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b26:	00020517          	auipc	a0,0x20
    80005b2a:	61a50513          	addi	a0,a0,1562 # 80026140 <cons>
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	7b4080e7          	jalr	1972(ra) # 800062e2 <acquire>

  switch(c){
    80005b36:	47d5                	li	a5,21
    80005b38:	0af48663          	beq	s1,a5,80005be4 <consoleintr+0xcc>
    80005b3c:	0297ca63          	blt	a5,s1,80005b70 <consoleintr+0x58>
    80005b40:	47a1                	li	a5,8
    80005b42:	0ef48763          	beq	s1,a5,80005c30 <consoleintr+0x118>
    80005b46:	47c1                	li	a5,16
    80005b48:	10f49a63          	bne	s1,a5,80005c5c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b4c:	ffffc097          	auipc	ra,0xffffc
    80005b50:	f84080e7          	jalr	-124(ra) # 80001ad0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b54:	00020517          	auipc	a0,0x20
    80005b58:	5ec50513          	addi	a0,a0,1516 # 80026140 <cons>
    80005b5c:	00001097          	auipc	ra,0x1
    80005b60:	83a080e7          	jalr	-1990(ra) # 80006396 <release>
}
    80005b64:	60e2                	ld	ra,24(sp)
    80005b66:	6442                	ld	s0,16(sp)
    80005b68:	64a2                	ld	s1,8(sp)
    80005b6a:	6902                	ld	s2,0(sp)
    80005b6c:	6105                	addi	sp,sp,32
    80005b6e:	8082                	ret
  switch(c){
    80005b70:	07f00793          	li	a5,127
    80005b74:	0af48e63          	beq	s1,a5,80005c30 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b78:	00020717          	auipc	a4,0x20
    80005b7c:	5c870713          	addi	a4,a4,1480 # 80026140 <cons>
    80005b80:	0a072783          	lw	a5,160(a4)
    80005b84:	09872703          	lw	a4,152(a4)
    80005b88:	9f99                	subw	a5,a5,a4
    80005b8a:	07f00713          	li	a4,127
    80005b8e:	fcf763e3          	bltu	a4,a5,80005b54 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b92:	47b5                	li	a5,13
    80005b94:	0cf48763          	beq	s1,a5,80005c62 <consoleintr+0x14a>
      consputc(c);
    80005b98:	8526                	mv	a0,s1
    80005b9a:	00000097          	auipc	ra,0x0
    80005b9e:	f3c080e7          	jalr	-196(ra) # 80005ad6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ba2:	00020797          	auipc	a5,0x20
    80005ba6:	59e78793          	addi	a5,a5,1438 # 80026140 <cons>
    80005baa:	0a07a703          	lw	a4,160(a5)
    80005bae:	0017069b          	addiw	a3,a4,1
    80005bb2:	0006861b          	sext.w	a2,a3
    80005bb6:	0ad7a023          	sw	a3,160(a5)
    80005bba:	07f77713          	andi	a4,a4,127
    80005bbe:	97ba                	add	a5,a5,a4
    80005bc0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bc4:	47a9                	li	a5,10
    80005bc6:	0cf48563          	beq	s1,a5,80005c90 <consoleintr+0x178>
    80005bca:	4791                	li	a5,4
    80005bcc:	0cf48263          	beq	s1,a5,80005c90 <consoleintr+0x178>
    80005bd0:	00020797          	auipc	a5,0x20
    80005bd4:	6087a783          	lw	a5,1544(a5) # 800261d8 <cons+0x98>
    80005bd8:	0807879b          	addiw	a5,a5,128
    80005bdc:	f6f61ce3          	bne	a2,a5,80005b54 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005be0:	863e                	mv	a2,a5
    80005be2:	a07d                	j	80005c90 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005be4:	00020717          	auipc	a4,0x20
    80005be8:	55c70713          	addi	a4,a4,1372 # 80026140 <cons>
    80005bec:	0a072783          	lw	a5,160(a4)
    80005bf0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bf4:	00020497          	auipc	s1,0x20
    80005bf8:	54c48493          	addi	s1,s1,1356 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005bfc:	4929                	li	s2,10
    80005bfe:	f4f70be3          	beq	a4,a5,80005b54 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c02:	37fd                	addiw	a5,a5,-1
    80005c04:	07f7f713          	andi	a4,a5,127
    80005c08:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c0a:	01874703          	lbu	a4,24(a4)
    80005c0e:	f52703e3          	beq	a4,s2,80005b54 <consoleintr+0x3c>
      cons.e--;
    80005c12:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c16:	10000513          	li	a0,256
    80005c1a:	00000097          	auipc	ra,0x0
    80005c1e:	ebc080e7          	jalr	-324(ra) # 80005ad6 <consputc>
    while(cons.e != cons.w &&
    80005c22:	0a04a783          	lw	a5,160(s1)
    80005c26:	09c4a703          	lw	a4,156(s1)
    80005c2a:	fcf71ce3          	bne	a4,a5,80005c02 <consoleintr+0xea>
    80005c2e:	b71d                	j	80005b54 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c30:	00020717          	auipc	a4,0x20
    80005c34:	51070713          	addi	a4,a4,1296 # 80026140 <cons>
    80005c38:	0a072783          	lw	a5,160(a4)
    80005c3c:	09c72703          	lw	a4,156(a4)
    80005c40:	f0f70ae3          	beq	a4,a5,80005b54 <consoleintr+0x3c>
      cons.e--;
    80005c44:	37fd                	addiw	a5,a5,-1
    80005c46:	00020717          	auipc	a4,0x20
    80005c4a:	58f72d23          	sw	a5,1434(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c4e:	10000513          	li	a0,256
    80005c52:	00000097          	auipc	ra,0x0
    80005c56:	e84080e7          	jalr	-380(ra) # 80005ad6 <consputc>
    80005c5a:	bded                	j	80005b54 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c5c:	ee048ce3          	beqz	s1,80005b54 <consoleintr+0x3c>
    80005c60:	bf21                	j	80005b78 <consoleintr+0x60>
      consputc(c);
    80005c62:	4529                	li	a0,10
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	e72080e7          	jalr	-398(ra) # 80005ad6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c6c:	00020797          	auipc	a5,0x20
    80005c70:	4d478793          	addi	a5,a5,1236 # 80026140 <cons>
    80005c74:	0a07a703          	lw	a4,160(a5)
    80005c78:	0017069b          	addiw	a3,a4,1
    80005c7c:	0006861b          	sext.w	a2,a3
    80005c80:	0ad7a023          	sw	a3,160(a5)
    80005c84:	07f77713          	andi	a4,a4,127
    80005c88:	97ba                	add	a5,a5,a4
    80005c8a:	4729                	li	a4,10
    80005c8c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c90:	00020797          	auipc	a5,0x20
    80005c94:	54c7a623          	sw	a2,1356(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c98:	00020517          	auipc	a0,0x20
    80005c9c:	54050513          	addi	a0,a0,1344 # 800261d8 <cons+0x98>
    80005ca0:	ffffc097          	auipc	ra,0xffffc
    80005ca4:	b6c080e7          	jalr	-1172(ra) # 8000180c <wakeup>
    80005ca8:	b575                	j	80005b54 <consoleintr+0x3c>

0000000080005caa <consoleinit>:

void
consoleinit(void)
{
    80005caa:	1141                	addi	sp,sp,-16
    80005cac:	e406                	sd	ra,8(sp)
    80005cae:	e022                	sd	s0,0(sp)
    80005cb0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cb2:	00003597          	auipc	a1,0x3
    80005cb6:	b8658593          	addi	a1,a1,-1146 # 80008838 <syscalls+0x440>
    80005cba:	00020517          	auipc	a0,0x20
    80005cbe:	48650513          	addi	a0,a0,1158 # 80026140 <cons>
    80005cc2:	00000097          	auipc	ra,0x0
    80005cc6:	590080e7          	jalr	1424(ra) # 80006252 <initlock>

  uartinit();
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	330080e7          	jalr	816(ra) # 80005ffa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cd2:	00013797          	auipc	a5,0x13
    80005cd6:	60678793          	addi	a5,a5,1542 # 800192d8 <devsw>
    80005cda:	00000717          	auipc	a4,0x0
    80005cde:	ce470713          	addi	a4,a4,-796 # 800059be <consoleread>
    80005ce2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ce4:	00000717          	auipc	a4,0x0
    80005ce8:	c7870713          	addi	a4,a4,-904 # 8000595c <consolewrite>
    80005cec:	ef98                	sd	a4,24(a5)
}
    80005cee:	60a2                	ld	ra,8(sp)
    80005cf0:	6402                	ld	s0,0(sp)
    80005cf2:	0141                	addi	sp,sp,16
    80005cf4:	8082                	ret

0000000080005cf6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cf6:	7179                	addi	sp,sp,-48
    80005cf8:	f406                	sd	ra,40(sp)
    80005cfa:	f022                	sd	s0,32(sp)
    80005cfc:	ec26                	sd	s1,24(sp)
    80005cfe:	e84a                	sd	s2,16(sp)
    80005d00:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d02:	c219                	beqz	a2,80005d08 <printint+0x12>
    80005d04:	08054663          	bltz	a0,80005d90 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d08:	2501                	sext.w	a0,a0
    80005d0a:	4881                	li	a7,0
    80005d0c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d10:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d12:	2581                	sext.w	a1,a1
    80005d14:	00003617          	auipc	a2,0x3
    80005d18:	b5460613          	addi	a2,a2,-1196 # 80008868 <digits>
    80005d1c:	883a                	mv	a6,a4
    80005d1e:	2705                	addiw	a4,a4,1
    80005d20:	02b577bb          	remuw	a5,a0,a1
    80005d24:	1782                	slli	a5,a5,0x20
    80005d26:	9381                	srli	a5,a5,0x20
    80005d28:	97b2                	add	a5,a5,a2
    80005d2a:	0007c783          	lbu	a5,0(a5)
    80005d2e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d32:	0005079b          	sext.w	a5,a0
    80005d36:	02b5553b          	divuw	a0,a0,a1
    80005d3a:	0685                	addi	a3,a3,1
    80005d3c:	feb7f0e3          	bgeu	a5,a1,80005d1c <printint+0x26>

  if(sign)
    80005d40:	00088b63          	beqz	a7,80005d56 <printint+0x60>
    buf[i++] = '-';
    80005d44:	fe040793          	addi	a5,s0,-32
    80005d48:	973e                	add	a4,a4,a5
    80005d4a:	02d00793          	li	a5,45
    80005d4e:	fef70823          	sb	a5,-16(a4)
    80005d52:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d56:	02e05763          	blez	a4,80005d84 <printint+0x8e>
    80005d5a:	fd040793          	addi	a5,s0,-48
    80005d5e:	00e784b3          	add	s1,a5,a4
    80005d62:	fff78913          	addi	s2,a5,-1
    80005d66:	993a                	add	s2,s2,a4
    80005d68:	377d                	addiw	a4,a4,-1
    80005d6a:	1702                	slli	a4,a4,0x20
    80005d6c:	9301                	srli	a4,a4,0x20
    80005d6e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d72:	fff4c503          	lbu	a0,-1(s1)
    80005d76:	00000097          	auipc	ra,0x0
    80005d7a:	d60080e7          	jalr	-672(ra) # 80005ad6 <consputc>
  while(--i >= 0)
    80005d7e:	14fd                	addi	s1,s1,-1
    80005d80:	ff2499e3          	bne	s1,s2,80005d72 <printint+0x7c>
}
    80005d84:	70a2                	ld	ra,40(sp)
    80005d86:	7402                	ld	s0,32(sp)
    80005d88:	64e2                	ld	s1,24(sp)
    80005d8a:	6942                	ld	s2,16(sp)
    80005d8c:	6145                	addi	sp,sp,48
    80005d8e:	8082                	ret
    x = -xx;
    80005d90:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d94:	4885                	li	a7,1
    x = -xx;
    80005d96:	bf9d                	j	80005d0c <printint+0x16>

0000000080005d98 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d98:	1101                	addi	sp,sp,-32
    80005d9a:	ec06                	sd	ra,24(sp)
    80005d9c:	e822                	sd	s0,16(sp)
    80005d9e:	e426                	sd	s1,8(sp)
    80005da0:	1000                	addi	s0,sp,32
    80005da2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005da4:	00020797          	auipc	a5,0x20
    80005da8:	4407ae23          	sw	zero,1116(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005dac:	00003517          	auipc	a0,0x3
    80005db0:	a9450513          	addi	a0,a0,-1388 # 80008840 <syscalls+0x448>
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	02e080e7          	jalr	46(ra) # 80005de2 <printf>
  printf(s);
    80005dbc:	8526                	mv	a0,s1
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	024080e7          	jalr	36(ra) # 80005de2 <printf>
  printf("\n");
    80005dc6:	00002517          	auipc	a0,0x2
    80005dca:	28250513          	addi	a0,a0,642 # 80008048 <etext+0x48>
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	014080e7          	jalr	20(ra) # 80005de2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dd6:	4785                	li	a5,1
    80005dd8:	00003717          	auipc	a4,0x3
    80005ddc:	24f72623          	sw	a5,588(a4) # 80009024 <panicked>
  for(;;)
    80005de0:	a001                	j	80005de0 <panic+0x48>

0000000080005de2 <printf>:
{
    80005de2:	7131                	addi	sp,sp,-192
    80005de4:	fc86                	sd	ra,120(sp)
    80005de6:	f8a2                	sd	s0,112(sp)
    80005de8:	f4a6                	sd	s1,104(sp)
    80005dea:	f0ca                	sd	s2,96(sp)
    80005dec:	ecce                	sd	s3,88(sp)
    80005dee:	e8d2                	sd	s4,80(sp)
    80005df0:	e4d6                	sd	s5,72(sp)
    80005df2:	e0da                	sd	s6,64(sp)
    80005df4:	fc5e                	sd	s7,56(sp)
    80005df6:	f862                	sd	s8,48(sp)
    80005df8:	f466                	sd	s9,40(sp)
    80005dfa:	f06a                	sd	s10,32(sp)
    80005dfc:	ec6e                	sd	s11,24(sp)
    80005dfe:	0100                	addi	s0,sp,128
    80005e00:	8a2a                	mv	s4,a0
    80005e02:	e40c                	sd	a1,8(s0)
    80005e04:	e810                	sd	a2,16(s0)
    80005e06:	ec14                	sd	a3,24(s0)
    80005e08:	f018                	sd	a4,32(s0)
    80005e0a:	f41c                	sd	a5,40(s0)
    80005e0c:	03043823          	sd	a6,48(s0)
    80005e10:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e14:	00020d97          	auipc	s11,0x20
    80005e18:	3ecdad83          	lw	s11,1004(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e1c:	020d9b63          	bnez	s11,80005e52 <printf+0x70>
  if (fmt == 0)
    80005e20:	040a0263          	beqz	s4,80005e64 <printf+0x82>
  va_start(ap, fmt);
    80005e24:	00840793          	addi	a5,s0,8
    80005e28:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e2c:	000a4503          	lbu	a0,0(s4)
    80005e30:	16050263          	beqz	a0,80005f94 <printf+0x1b2>
    80005e34:	4481                	li	s1,0
    if(c != '%'){
    80005e36:	02500a93          	li	s5,37
    switch(c){
    80005e3a:	07000b13          	li	s6,112
  consputc('x');
    80005e3e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e40:	00003b97          	auipc	s7,0x3
    80005e44:	a28b8b93          	addi	s7,s7,-1496 # 80008868 <digits>
    switch(c){
    80005e48:	07300c93          	li	s9,115
    80005e4c:	06400c13          	li	s8,100
    80005e50:	a82d                	j	80005e8a <printf+0xa8>
    acquire(&pr.lock);
    80005e52:	00020517          	auipc	a0,0x20
    80005e56:	39650513          	addi	a0,a0,918 # 800261e8 <pr>
    80005e5a:	00000097          	auipc	ra,0x0
    80005e5e:	488080e7          	jalr	1160(ra) # 800062e2 <acquire>
    80005e62:	bf7d                	j	80005e20 <printf+0x3e>
    panic("null fmt");
    80005e64:	00003517          	auipc	a0,0x3
    80005e68:	9ec50513          	addi	a0,a0,-1556 # 80008850 <syscalls+0x458>
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	f2c080e7          	jalr	-212(ra) # 80005d98 <panic>
      consputc(c);
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	c62080e7          	jalr	-926(ra) # 80005ad6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e7c:	2485                	addiw	s1,s1,1
    80005e7e:	009a07b3          	add	a5,s4,s1
    80005e82:	0007c503          	lbu	a0,0(a5)
    80005e86:	10050763          	beqz	a0,80005f94 <printf+0x1b2>
    if(c != '%'){
    80005e8a:	ff5515e3          	bne	a0,s5,80005e74 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e8e:	2485                	addiw	s1,s1,1
    80005e90:	009a07b3          	add	a5,s4,s1
    80005e94:	0007c783          	lbu	a5,0(a5)
    80005e98:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e9c:	cfe5                	beqz	a5,80005f94 <printf+0x1b2>
    switch(c){
    80005e9e:	05678a63          	beq	a5,s6,80005ef2 <printf+0x110>
    80005ea2:	02fb7663          	bgeu	s6,a5,80005ece <printf+0xec>
    80005ea6:	09978963          	beq	a5,s9,80005f38 <printf+0x156>
    80005eaa:	07800713          	li	a4,120
    80005eae:	0ce79863          	bne	a5,a4,80005f7e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005eb2:	f8843783          	ld	a5,-120(s0)
    80005eb6:	00878713          	addi	a4,a5,8
    80005eba:	f8e43423          	sd	a4,-120(s0)
    80005ebe:	4605                	li	a2,1
    80005ec0:	85ea                	mv	a1,s10
    80005ec2:	4388                	lw	a0,0(a5)
    80005ec4:	00000097          	auipc	ra,0x0
    80005ec8:	e32080e7          	jalr	-462(ra) # 80005cf6 <printint>
      break;
    80005ecc:	bf45                	j	80005e7c <printf+0x9a>
    switch(c){
    80005ece:	0b578263          	beq	a5,s5,80005f72 <printf+0x190>
    80005ed2:	0b879663          	bne	a5,s8,80005f7e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ed6:	f8843783          	ld	a5,-120(s0)
    80005eda:	00878713          	addi	a4,a5,8
    80005ede:	f8e43423          	sd	a4,-120(s0)
    80005ee2:	4605                	li	a2,1
    80005ee4:	45a9                	li	a1,10
    80005ee6:	4388                	lw	a0,0(a5)
    80005ee8:	00000097          	auipc	ra,0x0
    80005eec:	e0e080e7          	jalr	-498(ra) # 80005cf6 <printint>
      break;
    80005ef0:	b771                	j	80005e7c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ef2:	f8843783          	ld	a5,-120(s0)
    80005ef6:	00878713          	addi	a4,a5,8
    80005efa:	f8e43423          	sd	a4,-120(s0)
    80005efe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f02:	03000513          	li	a0,48
    80005f06:	00000097          	auipc	ra,0x0
    80005f0a:	bd0080e7          	jalr	-1072(ra) # 80005ad6 <consputc>
  consputc('x');
    80005f0e:	07800513          	li	a0,120
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	bc4080e7          	jalr	-1084(ra) # 80005ad6 <consputc>
    80005f1a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f1c:	03c9d793          	srli	a5,s3,0x3c
    80005f20:	97de                	add	a5,a5,s7
    80005f22:	0007c503          	lbu	a0,0(a5)
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	bb0080e7          	jalr	-1104(ra) # 80005ad6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f2e:	0992                	slli	s3,s3,0x4
    80005f30:	397d                	addiw	s2,s2,-1
    80005f32:	fe0915e3          	bnez	s2,80005f1c <printf+0x13a>
    80005f36:	b799                	j	80005e7c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f38:	f8843783          	ld	a5,-120(s0)
    80005f3c:	00878713          	addi	a4,a5,8
    80005f40:	f8e43423          	sd	a4,-120(s0)
    80005f44:	0007b903          	ld	s2,0(a5)
    80005f48:	00090e63          	beqz	s2,80005f64 <printf+0x182>
      for(; *s; s++)
    80005f4c:	00094503          	lbu	a0,0(s2)
    80005f50:	d515                	beqz	a0,80005e7c <printf+0x9a>
        consputc(*s);
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	b84080e7          	jalr	-1148(ra) # 80005ad6 <consputc>
      for(; *s; s++)
    80005f5a:	0905                	addi	s2,s2,1
    80005f5c:	00094503          	lbu	a0,0(s2)
    80005f60:	f96d                	bnez	a0,80005f52 <printf+0x170>
    80005f62:	bf29                	j	80005e7c <printf+0x9a>
        s = "(null)";
    80005f64:	00003917          	auipc	s2,0x3
    80005f68:	8e490913          	addi	s2,s2,-1820 # 80008848 <syscalls+0x450>
      for(; *s; s++)
    80005f6c:	02800513          	li	a0,40
    80005f70:	b7cd                	j	80005f52 <printf+0x170>
      consputc('%');
    80005f72:	8556                	mv	a0,s5
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	b62080e7          	jalr	-1182(ra) # 80005ad6 <consputc>
      break;
    80005f7c:	b701                	j	80005e7c <printf+0x9a>
      consputc('%');
    80005f7e:	8556                	mv	a0,s5
    80005f80:	00000097          	auipc	ra,0x0
    80005f84:	b56080e7          	jalr	-1194(ra) # 80005ad6 <consputc>
      consputc(c);
    80005f88:	854a                	mv	a0,s2
    80005f8a:	00000097          	auipc	ra,0x0
    80005f8e:	b4c080e7          	jalr	-1204(ra) # 80005ad6 <consputc>
      break;
    80005f92:	b5ed                	j	80005e7c <printf+0x9a>
  if(locking)
    80005f94:	020d9163          	bnez	s11,80005fb6 <printf+0x1d4>
}
    80005f98:	70e6                	ld	ra,120(sp)
    80005f9a:	7446                	ld	s0,112(sp)
    80005f9c:	74a6                	ld	s1,104(sp)
    80005f9e:	7906                	ld	s2,96(sp)
    80005fa0:	69e6                	ld	s3,88(sp)
    80005fa2:	6a46                	ld	s4,80(sp)
    80005fa4:	6aa6                	ld	s5,72(sp)
    80005fa6:	6b06                	ld	s6,64(sp)
    80005fa8:	7be2                	ld	s7,56(sp)
    80005faa:	7c42                	ld	s8,48(sp)
    80005fac:	7ca2                	ld	s9,40(sp)
    80005fae:	7d02                	ld	s10,32(sp)
    80005fb0:	6de2                	ld	s11,24(sp)
    80005fb2:	6129                	addi	sp,sp,192
    80005fb4:	8082                	ret
    release(&pr.lock);
    80005fb6:	00020517          	auipc	a0,0x20
    80005fba:	23250513          	addi	a0,a0,562 # 800261e8 <pr>
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	3d8080e7          	jalr	984(ra) # 80006396 <release>
}
    80005fc6:	bfc9                	j	80005f98 <printf+0x1b6>

0000000080005fc8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fc8:	1101                	addi	sp,sp,-32
    80005fca:	ec06                	sd	ra,24(sp)
    80005fcc:	e822                	sd	s0,16(sp)
    80005fce:	e426                	sd	s1,8(sp)
    80005fd0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fd2:	00020497          	auipc	s1,0x20
    80005fd6:	21648493          	addi	s1,s1,534 # 800261e8 <pr>
    80005fda:	00003597          	auipc	a1,0x3
    80005fde:	88658593          	addi	a1,a1,-1914 # 80008860 <syscalls+0x468>
    80005fe2:	8526                	mv	a0,s1
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	26e080e7          	jalr	622(ra) # 80006252 <initlock>
  pr.locking = 1;
    80005fec:	4785                	li	a5,1
    80005fee:	cc9c                	sw	a5,24(s1)
}
    80005ff0:	60e2                	ld	ra,24(sp)
    80005ff2:	6442                	ld	s0,16(sp)
    80005ff4:	64a2                	ld	s1,8(sp)
    80005ff6:	6105                	addi	sp,sp,32
    80005ff8:	8082                	ret

0000000080005ffa <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ffa:	1141                	addi	sp,sp,-16
    80005ffc:	e406                	sd	ra,8(sp)
    80005ffe:	e022                	sd	s0,0(sp)
    80006000:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006002:	100007b7          	lui	a5,0x10000
    80006006:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000600a:	f8000713          	li	a4,-128
    8000600e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006012:	470d                	li	a4,3
    80006014:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006018:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000601c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006020:	469d                	li	a3,7
    80006022:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006026:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000602a:	00003597          	auipc	a1,0x3
    8000602e:	85658593          	addi	a1,a1,-1962 # 80008880 <digits+0x18>
    80006032:	00020517          	auipc	a0,0x20
    80006036:	1d650513          	addi	a0,a0,470 # 80026208 <uart_tx_lock>
    8000603a:	00000097          	auipc	ra,0x0
    8000603e:	218080e7          	jalr	536(ra) # 80006252 <initlock>
}
    80006042:	60a2                	ld	ra,8(sp)
    80006044:	6402                	ld	s0,0(sp)
    80006046:	0141                	addi	sp,sp,16
    80006048:	8082                	ret

000000008000604a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000604a:	1101                	addi	sp,sp,-32
    8000604c:	ec06                	sd	ra,24(sp)
    8000604e:	e822                	sd	s0,16(sp)
    80006050:	e426                	sd	s1,8(sp)
    80006052:	1000                	addi	s0,sp,32
    80006054:	84aa                	mv	s1,a0
  push_off();
    80006056:	00000097          	auipc	ra,0x0
    8000605a:	240080e7          	jalr	576(ra) # 80006296 <push_off>

  if(panicked){
    8000605e:	00003797          	auipc	a5,0x3
    80006062:	fc67a783          	lw	a5,-58(a5) # 80009024 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006066:	10000737          	lui	a4,0x10000
  if(panicked){
    8000606a:	c391                	beqz	a5,8000606e <uartputc_sync+0x24>
    for(;;)
    8000606c:	a001                	j	8000606c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000606e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006072:	0ff7f793          	andi	a5,a5,255
    80006076:	0207f793          	andi	a5,a5,32
    8000607a:	dbf5                	beqz	a5,8000606e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000607c:	0ff4f793          	andi	a5,s1,255
    80006080:	10000737          	lui	a4,0x10000
    80006084:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	2ae080e7          	jalr	686(ra) # 80006336 <pop_off>
}
    80006090:	60e2                	ld	ra,24(sp)
    80006092:	6442                	ld	s0,16(sp)
    80006094:	64a2                	ld	s1,8(sp)
    80006096:	6105                	addi	sp,sp,32
    80006098:	8082                	ret

000000008000609a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000609a:	00003717          	auipc	a4,0x3
    8000609e:	f8e73703          	ld	a4,-114(a4) # 80009028 <uart_tx_r>
    800060a2:	00003797          	auipc	a5,0x3
    800060a6:	f8e7b783          	ld	a5,-114(a5) # 80009030 <uart_tx_w>
    800060aa:	06e78c63          	beq	a5,a4,80006122 <uartstart+0x88>
{
    800060ae:	7139                	addi	sp,sp,-64
    800060b0:	fc06                	sd	ra,56(sp)
    800060b2:	f822                	sd	s0,48(sp)
    800060b4:	f426                	sd	s1,40(sp)
    800060b6:	f04a                	sd	s2,32(sp)
    800060b8:	ec4e                	sd	s3,24(sp)
    800060ba:	e852                	sd	s4,16(sp)
    800060bc:	e456                	sd	s5,8(sp)
    800060be:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060c0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c4:	00020a17          	auipc	s4,0x20
    800060c8:	144a0a13          	addi	s4,s4,324 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060cc:	00003497          	auipc	s1,0x3
    800060d0:	f5c48493          	addi	s1,s1,-164 # 80009028 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060d4:	00003997          	auipc	s3,0x3
    800060d8:	f5c98993          	addi	s3,s3,-164 # 80009030 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060dc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060e0:	0ff7f793          	andi	a5,a5,255
    800060e4:	0207f793          	andi	a5,a5,32
    800060e8:	c785                	beqz	a5,80006110 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ea:	01f77793          	andi	a5,a4,31
    800060ee:	97d2                	add	a5,a5,s4
    800060f0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060f4:	0705                	addi	a4,a4,1
    800060f6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060f8:	8526                	mv	a0,s1
    800060fa:	ffffb097          	auipc	ra,0xffffb
    800060fe:	712080e7          	jalr	1810(ra) # 8000180c <wakeup>
    
    WriteReg(THR, c);
    80006102:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006106:	6098                	ld	a4,0(s1)
    80006108:	0009b783          	ld	a5,0(s3)
    8000610c:	fce798e3          	bne	a5,a4,800060dc <uartstart+0x42>
  }
}
    80006110:	70e2                	ld	ra,56(sp)
    80006112:	7442                	ld	s0,48(sp)
    80006114:	74a2                	ld	s1,40(sp)
    80006116:	7902                	ld	s2,32(sp)
    80006118:	69e2                	ld	s3,24(sp)
    8000611a:	6a42                	ld	s4,16(sp)
    8000611c:	6aa2                	ld	s5,8(sp)
    8000611e:	6121                	addi	sp,sp,64
    80006120:	8082                	ret
    80006122:	8082                	ret

0000000080006124 <uartputc>:
{
    80006124:	7179                	addi	sp,sp,-48
    80006126:	f406                	sd	ra,40(sp)
    80006128:	f022                	sd	s0,32(sp)
    8000612a:	ec26                	sd	s1,24(sp)
    8000612c:	e84a                	sd	s2,16(sp)
    8000612e:	e44e                	sd	s3,8(sp)
    80006130:	e052                	sd	s4,0(sp)
    80006132:	1800                	addi	s0,sp,48
    80006134:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006136:	00020517          	auipc	a0,0x20
    8000613a:	0d250513          	addi	a0,a0,210 # 80026208 <uart_tx_lock>
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	1a4080e7          	jalr	420(ra) # 800062e2 <acquire>
  if(panicked){
    80006146:	00003797          	auipc	a5,0x3
    8000614a:	ede7a783          	lw	a5,-290(a5) # 80009024 <panicked>
    8000614e:	c391                	beqz	a5,80006152 <uartputc+0x2e>
    for(;;)
    80006150:	a001                	j	80006150 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006152:	00003797          	auipc	a5,0x3
    80006156:	ede7b783          	ld	a5,-290(a5) # 80009030 <uart_tx_w>
    8000615a:	00003717          	auipc	a4,0x3
    8000615e:	ece73703          	ld	a4,-306(a4) # 80009028 <uart_tx_r>
    80006162:	02070713          	addi	a4,a4,32
    80006166:	02f71b63          	bne	a4,a5,8000619c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000616a:	00020a17          	auipc	s4,0x20
    8000616e:	09ea0a13          	addi	s4,s4,158 # 80026208 <uart_tx_lock>
    80006172:	00003497          	auipc	s1,0x3
    80006176:	eb648493          	addi	s1,s1,-330 # 80009028 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000617a:	00003917          	auipc	s2,0x3
    8000617e:	eb690913          	addi	s2,s2,-330 # 80009030 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006182:	85d2                	mv	a1,s4
    80006184:	8526                	mv	a0,s1
    80006186:	ffffb097          	auipc	ra,0xffffb
    8000618a:	4fa080e7          	jalr	1274(ra) # 80001680 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000618e:	00093783          	ld	a5,0(s2)
    80006192:	6098                	ld	a4,0(s1)
    80006194:	02070713          	addi	a4,a4,32
    80006198:	fef705e3          	beq	a4,a5,80006182 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000619c:	00020497          	auipc	s1,0x20
    800061a0:	06c48493          	addi	s1,s1,108 # 80026208 <uart_tx_lock>
    800061a4:	01f7f713          	andi	a4,a5,31
    800061a8:	9726                	add	a4,a4,s1
    800061aa:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800061ae:	0785                	addi	a5,a5,1
    800061b0:	00003717          	auipc	a4,0x3
    800061b4:	e8f73023          	sd	a5,-384(a4) # 80009030 <uart_tx_w>
      uartstart();
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	ee2080e7          	jalr	-286(ra) # 8000609a <uartstart>
      release(&uart_tx_lock);
    800061c0:	8526                	mv	a0,s1
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	1d4080e7          	jalr	468(ra) # 80006396 <release>
}
    800061ca:	70a2                	ld	ra,40(sp)
    800061cc:	7402                	ld	s0,32(sp)
    800061ce:	64e2                	ld	s1,24(sp)
    800061d0:	6942                	ld	s2,16(sp)
    800061d2:	69a2                	ld	s3,8(sp)
    800061d4:	6a02                	ld	s4,0(sp)
    800061d6:	6145                	addi	sp,sp,48
    800061d8:	8082                	ret

00000000800061da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061da:	1141                	addi	sp,sp,-16
    800061dc:	e422                	sd	s0,8(sp)
    800061de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061e0:	100007b7          	lui	a5,0x10000
    800061e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061e8:	8b85                	andi	a5,a5,1
    800061ea:	cb91                	beqz	a5,800061fe <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061ec:	100007b7          	lui	a5,0x10000
    800061f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061f4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061f8:	6422                	ld	s0,8(sp)
    800061fa:	0141                	addi	sp,sp,16
    800061fc:	8082                	ret
    return -1;
    800061fe:	557d                	li	a0,-1
    80006200:	bfe5                	j	800061f8 <uartgetc+0x1e>

0000000080006202 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006202:	1101                	addi	sp,sp,-32
    80006204:	ec06                	sd	ra,24(sp)
    80006206:	e822                	sd	s0,16(sp)
    80006208:	e426                	sd	s1,8(sp)
    8000620a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000620c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	fcc080e7          	jalr	-52(ra) # 800061da <uartgetc>
    if(c == -1)
    80006216:	00950763          	beq	a0,s1,80006224 <uartintr+0x22>
      break;
    consoleintr(c);
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	8fe080e7          	jalr	-1794(ra) # 80005b18 <consoleintr>
  while(1){
    80006222:	b7f5                	j	8000620e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006224:	00020497          	auipc	s1,0x20
    80006228:	fe448493          	addi	s1,s1,-28 # 80026208 <uart_tx_lock>
    8000622c:	8526                	mv	a0,s1
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	0b4080e7          	jalr	180(ra) # 800062e2 <acquire>
  uartstart();
    80006236:	00000097          	auipc	ra,0x0
    8000623a:	e64080e7          	jalr	-412(ra) # 8000609a <uartstart>
  release(&uart_tx_lock);
    8000623e:	8526                	mv	a0,s1
    80006240:	00000097          	auipc	ra,0x0
    80006244:	156080e7          	jalr	342(ra) # 80006396 <release>
}
    80006248:	60e2                	ld	ra,24(sp)
    8000624a:	6442                	ld	s0,16(sp)
    8000624c:	64a2                	ld	s1,8(sp)
    8000624e:	6105                	addi	sp,sp,32
    80006250:	8082                	ret

0000000080006252 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006252:	1141                	addi	sp,sp,-16
    80006254:	e422                	sd	s0,8(sp)
    80006256:	0800                	addi	s0,sp,16
  lk->name = name;
    80006258:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000625a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000625e:	00053823          	sd	zero,16(a0)
}
    80006262:	6422                	ld	s0,8(sp)
    80006264:	0141                	addi	sp,sp,16
    80006266:	8082                	ret

0000000080006268 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006268:	411c                	lw	a5,0(a0)
    8000626a:	e399                	bnez	a5,80006270 <holding+0x8>
    8000626c:	4501                	li	a0,0
  return r;
}
    8000626e:	8082                	ret
{
    80006270:	1101                	addi	sp,sp,-32
    80006272:	ec06                	sd	ra,24(sp)
    80006274:	e822                	sd	s0,16(sp)
    80006276:	e426                	sd	s1,8(sp)
    80006278:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000627a:	6904                	ld	s1,16(a0)
    8000627c:	ffffb097          	auipc	ra,0xffffb
    80006280:	ca6080e7          	jalr	-858(ra) # 80000f22 <mycpu>
    80006284:	40a48533          	sub	a0,s1,a0
    80006288:	00153513          	seqz	a0,a0
}
    8000628c:	60e2                	ld	ra,24(sp)
    8000628e:	6442                	ld	s0,16(sp)
    80006290:	64a2                	ld	s1,8(sp)
    80006292:	6105                	addi	sp,sp,32
    80006294:	8082                	ret

0000000080006296 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006296:	1101                	addi	sp,sp,-32
    80006298:	ec06                	sd	ra,24(sp)
    8000629a:	e822                	sd	s0,16(sp)
    8000629c:	e426                	sd	s1,8(sp)
    8000629e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062a0:	100024f3          	csrr	s1,sstatus
    800062a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062a8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062aa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062ae:	ffffb097          	auipc	ra,0xffffb
    800062b2:	c74080e7          	jalr	-908(ra) # 80000f22 <mycpu>
    800062b6:	5d3c                	lw	a5,120(a0)
    800062b8:	cf89                	beqz	a5,800062d2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062ba:	ffffb097          	auipc	ra,0xffffb
    800062be:	c68080e7          	jalr	-920(ra) # 80000f22 <mycpu>
    800062c2:	5d3c                	lw	a5,120(a0)
    800062c4:	2785                	addiw	a5,a5,1
    800062c6:	dd3c                	sw	a5,120(a0)
}
    800062c8:	60e2                	ld	ra,24(sp)
    800062ca:	6442                	ld	s0,16(sp)
    800062cc:	64a2                	ld	s1,8(sp)
    800062ce:	6105                	addi	sp,sp,32
    800062d0:	8082                	ret
    mycpu()->intena = old;
    800062d2:	ffffb097          	auipc	ra,0xffffb
    800062d6:	c50080e7          	jalr	-944(ra) # 80000f22 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062da:	8085                	srli	s1,s1,0x1
    800062dc:	8885                	andi	s1,s1,1
    800062de:	dd64                	sw	s1,124(a0)
    800062e0:	bfe9                	j	800062ba <push_off+0x24>

00000000800062e2 <acquire>:
{
    800062e2:	1101                	addi	sp,sp,-32
    800062e4:	ec06                	sd	ra,24(sp)
    800062e6:	e822                	sd	s0,16(sp)
    800062e8:	e426                	sd	s1,8(sp)
    800062ea:	1000                	addi	s0,sp,32
    800062ec:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	fa8080e7          	jalr	-88(ra) # 80006296 <push_off>
  if(holding(lk))
    800062f6:	8526                	mv	a0,s1
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	f70080e7          	jalr	-144(ra) # 80006268 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006300:	4705                	li	a4,1
  if(holding(lk))
    80006302:	e115                	bnez	a0,80006326 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006304:	87ba                	mv	a5,a4
    80006306:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000630a:	2781                	sext.w	a5,a5
    8000630c:	ffe5                	bnez	a5,80006304 <acquire+0x22>
  __sync_synchronize();
    8000630e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006312:	ffffb097          	auipc	ra,0xffffb
    80006316:	c10080e7          	jalr	-1008(ra) # 80000f22 <mycpu>
    8000631a:	e888                	sd	a0,16(s1)
}
    8000631c:	60e2                	ld	ra,24(sp)
    8000631e:	6442                	ld	s0,16(sp)
    80006320:	64a2                	ld	s1,8(sp)
    80006322:	6105                	addi	sp,sp,32
    80006324:	8082                	ret
    panic("acquire");
    80006326:	00002517          	auipc	a0,0x2
    8000632a:	56250513          	addi	a0,a0,1378 # 80008888 <digits+0x20>
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	a6a080e7          	jalr	-1430(ra) # 80005d98 <panic>

0000000080006336 <pop_off>:

void
pop_off(void)
{
    80006336:	1141                	addi	sp,sp,-16
    80006338:	e406                	sd	ra,8(sp)
    8000633a:	e022                	sd	s0,0(sp)
    8000633c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000633e:	ffffb097          	auipc	ra,0xffffb
    80006342:	be4080e7          	jalr	-1052(ra) # 80000f22 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006346:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000634a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000634c:	e78d                	bnez	a5,80006376 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000634e:	5d3c                	lw	a5,120(a0)
    80006350:	02f05b63          	blez	a5,80006386 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006354:	37fd                	addiw	a5,a5,-1
    80006356:	0007871b          	sext.w	a4,a5
    8000635a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000635c:	eb09                	bnez	a4,8000636e <pop_off+0x38>
    8000635e:	5d7c                	lw	a5,124(a0)
    80006360:	c799                	beqz	a5,8000636e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006362:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006366:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000636a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000636e:	60a2                	ld	ra,8(sp)
    80006370:	6402                	ld	s0,0(sp)
    80006372:	0141                	addi	sp,sp,16
    80006374:	8082                	ret
    panic("pop_off - interruptible");
    80006376:	00002517          	auipc	a0,0x2
    8000637a:	51a50513          	addi	a0,a0,1306 # 80008890 <digits+0x28>
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	a1a080e7          	jalr	-1510(ra) # 80005d98 <panic>
    panic("pop_off");
    80006386:	00002517          	auipc	a0,0x2
    8000638a:	52250513          	addi	a0,a0,1314 # 800088a8 <digits+0x40>
    8000638e:	00000097          	auipc	ra,0x0
    80006392:	a0a080e7          	jalr	-1526(ra) # 80005d98 <panic>

0000000080006396 <release>:
{
    80006396:	1101                	addi	sp,sp,-32
    80006398:	ec06                	sd	ra,24(sp)
    8000639a:	e822                	sd	s0,16(sp)
    8000639c:	e426                	sd	s1,8(sp)
    8000639e:	1000                	addi	s0,sp,32
    800063a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063a2:	00000097          	auipc	ra,0x0
    800063a6:	ec6080e7          	jalr	-314(ra) # 80006268 <holding>
    800063aa:	c115                	beqz	a0,800063ce <release+0x38>
  lk->cpu = 0;
    800063ac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063b0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063b4:	0f50000f          	fence	iorw,ow
    800063b8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063bc:	00000097          	auipc	ra,0x0
    800063c0:	f7a080e7          	jalr	-134(ra) # 80006336 <pop_off>
}
    800063c4:	60e2                	ld	ra,24(sp)
    800063c6:	6442                	ld	s0,16(sp)
    800063c8:	64a2                	ld	s1,8(sp)
    800063ca:	6105                	addi	sp,sp,32
    800063cc:	8082                	ret
    panic("release");
    800063ce:	00002517          	auipc	a0,0x2
    800063d2:	4e250513          	addi	a0,a0,1250 # 800088b0 <digits+0x48>
    800063d6:	00000097          	auipc	ra,0x0
    800063da:	9c2080e7          	jalr	-1598(ra) # 80005d98 <panic>
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
