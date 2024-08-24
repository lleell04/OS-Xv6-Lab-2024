
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	89013103          	ld	sp,-1904(sp) # 80008890 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7e2050ef          	jal	ra,800057f8 <start>

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
    80000030:	0002a797          	auipc	a5,0x2a
    80000034:	21078793          	addi	a5,a5,528 # 8002a240 <end>
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
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1ea080e7          	jalr	490(ra) # 80006244 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	28a080e7          	jalr	650(ra) # 800062f8 <release>
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
    8000008e:	c20080e7          	jalr	-992(ra) # 80005caa <panic>

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
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	0c0080e7          	jalr	192(ra) # 800061b4 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002a517          	auipc	a0,0x2a
    80000104:	14050513          	addi	a0,a0,320 # 8002a240 <end>
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
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	118080e7          	jalr	280(ra) # 80006244 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	1b4080e7          	jalr	436(ra) # 800062f8 <release>

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
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	18a080e7          	jalr	394(ra) # 800062f8 <release>
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
    80000332:	af0080e7          	jalr	-1296(ra) # 80000e1e <cpuid>
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
    8000034e:	ad4080e7          	jalr	-1324(ra) # 80000e1e <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	998080e7          	jalr	-1640(ra) # 80005cf4 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	772080e7          	jalr	1906(ra) # 80001ade <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	e0c080e7          	jalr	-500(ra) # 80005180 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	000080e7          	jalr	ra # 8000137c <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	838080e7          	jalr	-1992(ra) # 80005bbc <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	b4e080e7          	jalr	-1202(ra) # 80005eda <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	958080e7          	jalr	-1704(ra) # 80005cf4 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	948080e7          	jalr	-1720(ra) # 80005cf4 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	938080e7          	jalr	-1736(ra) # 80005cf4 <printf>
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
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6d2080e7          	jalr	1746(ra) # 80001ab6 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6f2080e7          	jalr	1778(ra) # 80001ade <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d76080e7          	jalr	-650(ra) # 8000516a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d84080e7          	jalr	-636(ra) # 80005180 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f5a080e7          	jalr	-166(ra) # 8000235e <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5ea080e7          	jalr	1514(ra) # 800029f6 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	598080e7          	jalr	1432(ra) # 800039ac <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e86080e7          	jalr	-378(ra) # 800052a2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d14080e7          	jalr	-748(ra) # 80001138 <userinit>
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
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
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
    80000492:	81c080e7          	jalr	-2020(ra) # 80005caa <panic>
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
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	724080e7          	jalr	1828(ra) # 80005caa <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	714080e7          	jalr	1812(ra) # 80005caa <panic>
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
    80000614:	69a080e7          	jalr	1690(ra) # 80005caa <panic>

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
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
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
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
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
    80000760:	54e080e7          	jalr	1358(ra) # 80005caa <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	53e080e7          	jalr	1342(ra) # 80005caa <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	52e080e7          	jalr	1326(ra) # 80005caa <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	51e080e7          	jalr	1310(ra) # 80005caa <panic>
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
    8000086e:	440080e7          	jalr	1088(ra) # 80005caa <panic>

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
    800009b0:	2fe080e7          	jalr	766(ra) # 80005caa <panic>
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

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	222080e7          	jalr	546(ra) # 80005caa <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	212080e7          	jalr	530(ra) # 80005caa <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	1a8080e7          	jalr	424(ra) # 80005caa <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00013a17          	auipc	s4,0x13
    80000d0a:	d7aa0a13          	addi	s4,s4,-646 # 80013a80 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	29848493          	addi	s1,s1,664
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	f46080e7          	jalr	-186(ra) # 80005caa <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	424080e7          	jalr	1060(ra) # 800061b4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	40c080e7          	jalr	1036(ra) # 800061b4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00013997          	auipc	s3,0x13
    80000dd6:	cae98993          	addi	s3,s3,-850 # 80013a80 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	3d6080e7          	jalr	982(ra) # 800061b4 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	16f4b823          	sd	a5,368(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e02:	29848493          	addi	s1,s1,664
    80000e06:	fd349ae3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e0a:	70e2                	ld	ra,56(sp)
    80000e0c:	7442                	ld	s0,48(sp)
    80000e0e:	74a2                	ld	s1,40(sp)
    80000e10:	7902                	ld	s2,32(sp)
    80000e12:	69e2                	ld	s3,24(sp)
    80000e14:	6a42                	ld	s4,16(sp)
    80000e16:	6aa2                	ld	s5,8(sp)
    80000e18:	6b02                	ld	s6,0(sp)
    80000e1a:	6121                	addi	sp,sp,64
    80000e1c:	8082                	ret

0000000080000e1e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e422                	sd	s0,8(sp)
    80000e22:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e24:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e26:	2501                	sext.w	a0,a0
    80000e28:	6422                	ld	s0,8(sp)
    80000e2a:	0141                	addi	sp,sp,16
    80000e2c:	8082                	ret

0000000080000e2e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2e:	1141                	addi	sp,sp,-16
    80000e30:	e422                	sd	s0,8(sp)
    80000e32:	0800                	addi	s0,sp,16
    80000e34:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e36:	2781                	sext.w	a5,a5
    80000e38:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e3a:	00008517          	auipc	a0,0x8
    80000e3e:	24650513          	addi	a0,a0,582 # 80009080 <cpus>
    80000e42:	953e                	add	a0,a0,a5
    80000e44:	6422                	ld	s0,8(sp)
    80000e46:	0141                	addi	sp,sp,16
    80000e48:	8082                	ret

0000000080000e4a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e4a:	1101                	addi	sp,sp,-32
    80000e4c:	ec06                	sd	ra,24(sp)
    80000e4e:	e822                	sd	s0,16(sp)
    80000e50:	e426                	sd	s1,8(sp)
    80000e52:	1000                	addi	s0,sp,32
  push_off();
    80000e54:	00005097          	auipc	ra,0x5
    80000e58:	3a4080e7          	jalr	932(ra) # 800061f8 <push_off>
    80000e5c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5e:	2781                	sext.w	a5,a5
    80000e60:	079e                	slli	a5,a5,0x7
    80000e62:	00008717          	auipc	a4,0x8
    80000e66:	1ee70713          	addi	a4,a4,494 # 80009050 <pid_lock>
    80000e6a:	97ba                	add	a5,a5,a4
    80000e6c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6e:	00005097          	auipc	ra,0x5
    80000e72:	42a080e7          	jalr	1066(ra) # 80006298 <pop_off>
  return p;
}
    80000e76:	8526                	mv	a0,s1
    80000e78:	60e2                	ld	ra,24(sp)
    80000e7a:	6442                	ld	s0,16(sp)
    80000e7c:	64a2                	ld	s1,8(sp)
    80000e7e:	6105                	addi	sp,sp,32
    80000e80:	8082                	ret

0000000080000e82 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e8a:	00000097          	auipc	ra,0x0
    80000e8e:	fc0080e7          	jalr	-64(ra) # 80000e4a <myproc>
    80000e92:	00005097          	auipc	ra,0x5
    80000e96:	466080e7          	jalr	1126(ra) # 800062f8 <release>

  if (first) {
    80000e9a:	00008797          	auipc	a5,0x8
    80000e9e:	9a67a783          	lw	a5,-1626(a5) # 80008840 <first.1682>
    80000ea2:	eb89                	bnez	a5,80000eb4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea4:	00001097          	auipc	ra,0x1
    80000ea8:	c52080e7          	jalr	-942(ra) # 80001af6 <usertrapret>
}
    80000eac:	60a2                	ld	ra,8(sp)
    80000eae:	6402                	ld	s0,0(sp)
    80000eb0:	0141                	addi	sp,sp,16
    80000eb2:	8082                	ret
    first = 0;
    80000eb4:	00008797          	auipc	a5,0x8
    80000eb8:	9807a623          	sw	zero,-1652(a5) # 80008840 <first.1682>
    fsinit(ROOTDEV);
    80000ebc:	4505                	li	a0,1
    80000ebe:	00002097          	auipc	ra,0x2
    80000ec2:	ab8080e7          	jalr	-1352(ra) # 80002976 <fsinit>
    80000ec6:	bff9                	j	80000ea4 <forkret+0x22>

0000000080000ec8 <allocpid>:
allocpid() {
    80000ec8:	1101                	addi	sp,sp,-32
    80000eca:	ec06                	sd	ra,24(sp)
    80000ecc:	e822                	sd	s0,16(sp)
    80000ece:	e426                	sd	s1,8(sp)
    80000ed0:	e04a                	sd	s2,0(sp)
    80000ed2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed4:	00008917          	auipc	s2,0x8
    80000ed8:	17c90913          	addi	s2,s2,380 # 80009050 <pid_lock>
    80000edc:	854a                	mv	a0,s2
    80000ede:	00005097          	auipc	ra,0x5
    80000ee2:	366080e7          	jalr	870(ra) # 80006244 <acquire>
  pid = nextpid;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	95e78793          	addi	a5,a5,-1698 # 80008844 <nextpid>
    80000eee:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef0:	0014871b          	addiw	a4,s1,1
    80000ef4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef6:	854a                	mv	a0,s2
    80000ef8:	00005097          	auipc	ra,0x5
    80000efc:	400080e7          	jalr	1024(ra) # 800062f8 <release>
}
    80000f00:	8526                	mv	a0,s1
    80000f02:	60e2                	ld	ra,24(sp)
    80000f04:	6442                	ld	s0,16(sp)
    80000f06:	64a2                	ld	s1,8(sp)
    80000f08:	6902                	ld	s2,0(sp)
    80000f0a:	6105                	addi	sp,sp,32
    80000f0c:	8082                	ret

0000000080000f0e <proc_pagetable>:
{
    80000f0e:	1101                	addi	sp,sp,-32
    80000f10:	ec06                	sd	ra,24(sp)
    80000f12:	e822                	sd	s0,16(sp)
    80000f14:	e426                	sd	s1,8(sp)
    80000f16:	e04a                	sd	s2,0(sp)
    80000f18:	1000                	addi	s0,sp,32
    80000f1a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1c:	00000097          	auipc	ra,0x0
    80000f20:	8b6080e7          	jalr	-1866(ra) # 800007d2 <uvmcreate>
    80000f24:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f26:	c121                	beqz	a0,80000f66 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f28:	4729                	li	a4,10
    80000f2a:	00006697          	auipc	a3,0x6
    80000f2e:	0d668693          	addi	a3,a3,214 # 80007000 <_trampoline>
    80000f32:	6605                	lui	a2,0x1
    80000f34:	040005b7          	lui	a1,0x4000
    80000f38:	15fd                	addi	a1,a1,-1
    80000f3a:	05b2                	slli	a1,a1,0xc
    80000f3c:	fffff097          	auipc	ra,0xfffff
    80000f40:	60c080e7          	jalr	1548(ra) # 80000548 <mappages>
    80000f44:	02054863          	bltz	a0,80000f74 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f48:	4719                	li	a4,6
    80000f4a:	18893683          	ld	a3,392(s2)
    80000f4e:	6605                	lui	a2,0x1
    80000f50:	020005b7          	lui	a1,0x2000
    80000f54:	15fd                	addi	a1,a1,-1
    80000f56:	05b6                	slli	a1,a1,0xd
    80000f58:	8526                	mv	a0,s1
    80000f5a:	fffff097          	auipc	ra,0xfffff
    80000f5e:	5ee080e7          	jalr	1518(ra) # 80000548 <mappages>
    80000f62:	02054163          	bltz	a0,80000f84 <proc_pagetable+0x76>
}
    80000f66:	8526                	mv	a0,s1
    80000f68:	60e2                	ld	ra,24(sp)
    80000f6a:	6442                	ld	s0,16(sp)
    80000f6c:	64a2                	ld	s1,8(sp)
    80000f6e:	6902                	ld	s2,0(sp)
    80000f70:	6105                	addi	sp,sp,32
    80000f72:	8082                	ret
    uvmfree(pagetable, 0);
    80000f74:	4581                	li	a1,0
    80000f76:	8526                	mv	a0,s1
    80000f78:	00000097          	auipc	ra,0x0
    80000f7c:	a56080e7          	jalr	-1450(ra) # 800009ce <uvmfree>
    return 0;
    80000f80:	4481                	li	s1,0
    80000f82:	b7d5                	j	80000f66 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f84:	4681                	li	a3,0
    80000f86:	4605                	li	a2,1
    80000f88:	040005b7          	lui	a1,0x4000
    80000f8c:	15fd                	addi	a1,a1,-1
    80000f8e:	05b2                	slli	a1,a1,0xc
    80000f90:	8526                	mv	a0,s1
    80000f92:	fffff097          	auipc	ra,0xfffff
    80000f96:	77c080e7          	jalr	1916(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f9a:	4581                	li	a1,0
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	00000097          	auipc	ra,0x0
    80000fa2:	a30080e7          	jalr	-1488(ra) # 800009ce <uvmfree>
    return 0;
    80000fa6:	4481                	li	s1,0
    80000fa8:	bf7d                	j	80000f66 <proc_pagetable+0x58>

0000000080000faa <proc_freepagetable>:
{
    80000faa:	1101                	addi	sp,sp,-32
    80000fac:	ec06                	sd	ra,24(sp)
    80000fae:	e822                	sd	s0,16(sp)
    80000fb0:	e426                	sd	s1,8(sp)
    80000fb2:	e04a                	sd	s2,0(sp)
    80000fb4:	1000                	addi	s0,sp,32
    80000fb6:	84aa                	mv	s1,a0
    80000fb8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fba:	4681                	li	a3,0
    80000fbc:	4605                	li	a2,1
    80000fbe:	040005b7          	lui	a1,0x4000
    80000fc2:	15fd                	addi	a1,a1,-1
    80000fc4:	05b2                	slli	a1,a1,0xc
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	748080e7          	jalr	1864(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fce:	4681                	li	a3,0
    80000fd0:	4605                	li	a2,1
    80000fd2:	020005b7          	lui	a1,0x2000
    80000fd6:	15fd                	addi	a1,a1,-1
    80000fd8:	05b6                	slli	a1,a1,0xd
    80000fda:	8526                	mv	a0,s1
    80000fdc:	fffff097          	auipc	ra,0xfffff
    80000fe0:	732080e7          	jalr	1842(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe4:	85ca                	mv	a1,s2
    80000fe6:	8526                	mv	a0,s1
    80000fe8:	00000097          	auipc	ra,0x0
    80000fec:	9e6080e7          	jalr	-1562(ra) # 800009ce <uvmfree>
}
    80000ff0:	60e2                	ld	ra,24(sp)
    80000ff2:	6442                	ld	s0,16(sp)
    80000ff4:	64a2                	ld	s1,8(sp)
    80000ff6:	6902                	ld	s2,0(sp)
    80000ff8:	6105                	addi	sp,sp,32
    80000ffa:	8082                	ret

0000000080000ffc <freeproc>:
{
    80000ffc:	1101                	addi	sp,sp,-32
    80000ffe:	ec06                	sd	ra,24(sp)
    80001000:	e822                	sd	s0,16(sp)
    80001002:	e426                	sd	s1,8(sp)
    80001004:	1000                	addi	s0,sp,32
    80001006:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001008:	18853503          	ld	a0,392(a0)
    8000100c:	c509                	beqz	a0,80001016 <freeproc+0x1a>
    kfree((void*)p->trapframe);
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	00e080e7          	jalr	14(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001016:	1804b423          	sd	zero,392(s1)
  if(p->pagetable)
    8000101a:	1804b503          	ld	a0,384(s1)
    8000101e:	c519                	beqz	a0,8000102c <freeproc+0x30>
    proc_freepagetable(p->pagetable, p->sz);
    80001020:	1784b583          	ld	a1,376(s1)
    80001024:	00000097          	auipc	ra,0x0
    80001028:	f86080e7          	jalr	-122(ra) # 80000faa <proc_freepagetable>
  p->pagetable = 0;
    8000102c:	1804b023          	sd	zero,384(s1)
  p->sz = 0;
    80001030:	1604bc23          	sd	zero,376(s1)
  p->pid = 0;
    80001034:	1604a023          	sw	zero,352(s1)
  p->parent = 0;
    80001038:	1604b423          	sd	zero,360(s1)
  p->name[0] = 0;
    8000103c:	28048423          	sb	zero,648(s1)
  p->chan = 0;
    80001040:	1404b823          	sd	zero,336(s1)
  p->killed = 0;
    80001044:	1404ac23          	sw	zero,344(s1)
  p->xstate = 0;
    80001048:	1404ae23          	sw	zero,348(s1)
  p->state = UNUSED;
    8000104c:	1404a623          	sw	zero,332(s1)
}
    80001050:	60e2                	ld	ra,24(sp)
    80001052:	6442                	ld	s0,16(sp)
    80001054:	64a2                	ld	s1,8(sp)
    80001056:	6105                	addi	sp,sp,32
    80001058:	8082                	ret

000000008000105a <allocproc>:
{
    8000105a:	1101                	addi	sp,sp,-32
    8000105c:	ec06                	sd	ra,24(sp)
    8000105e:	e822                	sd	s0,16(sp)
    80001060:	e426                	sd	s1,8(sp)
    80001062:	e04a                	sd	s2,0(sp)
    80001064:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001066:	00008497          	auipc	s1,0x8
    8000106a:	41a48493          	addi	s1,s1,1050 # 80009480 <proc>
    8000106e:	00013917          	auipc	s2,0x13
    80001072:	a1290913          	addi	s2,s2,-1518 # 80013a80 <tickslock>
    acquire(&p->lock);
    80001076:	8526                	mv	a0,s1
    80001078:	00005097          	auipc	ra,0x5
    8000107c:	1cc080e7          	jalr	460(ra) # 80006244 <acquire>
    if(p->state == UNUSED) {
    80001080:	14c4a783          	lw	a5,332(s1)
    80001084:	cf81                	beqz	a5,8000109c <allocproc+0x42>
      release(&p->lock);
    80001086:	8526                	mv	a0,s1
    80001088:	00005097          	auipc	ra,0x5
    8000108c:	270080e7          	jalr	624(ra) # 800062f8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001090:	29848493          	addi	s1,s1,664
    80001094:	ff2491e3          	bne	s1,s2,80001076 <allocproc+0x1c>
  return 0;
    80001098:	4481                	li	s1,0
    8000109a:	a085                	j	800010fa <allocproc+0xa0>
  p->pid = allocpid();
    8000109c:	00000097          	auipc	ra,0x0
    800010a0:	e2c080e7          	jalr	-468(ra) # 80000ec8 <allocpid>
    800010a4:	16a4a023          	sw	a0,352(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	14f4a623          	sw	a5,332(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	06a080e7          	jalr	106(ra) # 80000118 <kalloc>
    800010b6:	892a                	mv	s2,a0
    800010b8:	18a4b423          	sd	a0,392(s1)
    800010bc:	c531                	beqz	a0,80001108 <allocproc+0xae>
  p->pagetable = proc_pagetable(p);
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	e4e080e7          	jalr	-434(ra) # 80000f0e <proc_pagetable>
    800010c8:	892a                	mv	s2,a0
    800010ca:	18a4b023          	sd	a0,384(s1)
  if(p->pagetable == 0){
    800010ce:	c929                	beqz	a0,80001120 <allocproc+0xc6>
  memset(&p->context, 0, sizeof(p->context));
    800010d0:	07000613          	li	a2,112
    800010d4:	4581                	li	a1,0
    800010d6:	19048513          	addi	a0,s1,400
    800010da:	fffff097          	auipc	ra,0xfffff
    800010de:	09e080e7          	jalr	158(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010e2:	00000797          	auipc	a5,0x0
    800010e6:	da078793          	addi	a5,a5,-608 # 80000e82 <forkret>
    800010ea:	18f4b823          	sd	a5,400(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ee:	1704b783          	ld	a5,368(s1)
    800010f2:	6705                	lui	a4,0x1
    800010f4:	97ba                	add	a5,a5,a4
    800010f6:	18f4bc23          	sd	a5,408(s1)
}
    800010fa:	8526                	mv	a0,s1
    800010fc:	60e2                	ld	ra,24(sp)
    800010fe:	6442                	ld	s0,16(sp)
    80001100:	64a2                	ld	s1,8(sp)
    80001102:	6902                	ld	s2,0(sp)
    80001104:	6105                	addi	sp,sp,32
    80001106:	8082                	ret
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef2080e7          	jalr	-270(ra) # 80000ffc <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	1e4080e7          	jalr	484(ra) # 800062f8 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	bff1                	j	800010fa <allocproc+0xa0>
    freeproc(p);
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	eda080e7          	jalr	-294(ra) # 80000ffc <freeproc>
    release(&p->lock);
    8000112a:	8526                	mv	a0,s1
    8000112c:	00005097          	auipc	ra,0x5
    80001130:	1cc080e7          	jalr	460(ra) # 800062f8 <release>
    return 0;
    80001134:	84ca                	mv	s1,s2
    80001136:	b7d1                	j	800010fa <allocproc+0xa0>

0000000080001138 <userinit>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	1000                	addi	s0,sp,32
  p = allocproc();
    80001142:	00000097          	auipc	ra,0x0
    80001146:	f18080e7          	jalr	-232(ra) # 8000105a <allocproc>
    8000114a:	84aa                	mv	s1,a0
  initproc = p;
    8000114c:	00008797          	auipc	a5,0x8
    80001150:	eca7b223          	sd	a0,-316(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001154:	03400613          	li	a2,52
    80001158:	00007597          	auipc	a1,0x7
    8000115c:	6f858593          	addi	a1,a1,1784 # 80008850 <initcode>
    80001160:	18053503          	ld	a0,384(a0)
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	69c080e7          	jalr	1692(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    8000116c:	6785                	lui	a5,0x1
    8000116e:	16f4bc23          	sd	a5,376(s1)
  p->trapframe->epc = 0;      // user program counter
    80001172:	1884b703          	ld	a4,392(s1)
    80001176:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000117a:	1884b703          	ld	a4,392(s1)
    8000117e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001180:	4641                	li	a2,16
    80001182:	00007597          	auipc	a1,0x7
    80001186:	ffe58593          	addi	a1,a1,-2 # 80008180 <etext+0x180>
    8000118a:	28848513          	addi	a0,s1,648
    8000118e:	fffff097          	auipc	ra,0xfffff
    80001192:	13c080e7          	jalr	316(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001196:	00007517          	auipc	a0,0x7
    8000119a:	ffa50513          	addi	a0,a0,-6 # 80008190 <etext+0x190>
    8000119e:	00002097          	auipc	ra,0x2
    800011a2:	206080e7          	jalr	518(ra) # 800033a4 <namei>
    800011a6:	28a4b023          	sd	a0,640(s1)
  p->state = RUNNABLE;
    800011aa:	478d                	li	a5,3
    800011ac:	14f4a623          	sw	a5,332(s1)
  release(&p->lock);
    800011b0:	8526                	mv	a0,s1
    800011b2:	00005097          	auipc	ra,0x5
    800011b6:	146080e7          	jalr	326(ra) # 800062f8 <release>
}
    800011ba:	60e2                	ld	ra,24(sp)
    800011bc:	6442                	ld	s0,16(sp)
    800011be:	64a2                	ld	s1,8(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <growproc>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	e04a                	sd	s2,0(sp)
    800011ce:	1000                	addi	s0,sp,32
    800011d0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011d2:	00000097          	auipc	ra,0x0
    800011d6:	c78080e7          	jalr	-904(ra) # 80000e4a <myproc>
    800011da:	892a                	mv	s2,a0
  sz = p->sz;
    800011dc:	17853583          	ld	a1,376(a0)
    800011e0:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011e4:	00904f63          	bgtz	s1,80001202 <growproc+0x3e>
  } else if(n < 0){
    800011e8:	0204cd63          	bltz	s1,80001222 <growproc+0x5e>
  p->sz = sz;
    800011ec:	1602                	slli	a2,a2,0x20
    800011ee:	9201                	srli	a2,a2,0x20
    800011f0:	16c93c23          	sd	a2,376(s2)
  return 0;
    800011f4:	4501                	li	a0,0
}
    800011f6:	60e2                	ld	ra,24(sp)
    800011f8:	6442                	ld	s0,16(sp)
    800011fa:	64a2                	ld	s1,8(sp)
    800011fc:	6902                	ld	s2,0(sp)
    800011fe:	6105                	addi	sp,sp,32
    80001200:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001202:	9e25                	addw	a2,a2,s1
    80001204:	1602                	slli	a2,a2,0x20
    80001206:	9201                	srli	a2,a2,0x20
    80001208:	1582                	slli	a1,a1,0x20
    8000120a:	9181                	srli	a1,a1,0x20
    8000120c:	18053503          	ld	a0,384(a0)
    80001210:	fffff097          	auipc	ra,0xfffff
    80001214:	6aa080e7          	jalr	1706(ra) # 800008ba <uvmalloc>
    80001218:	0005061b          	sext.w	a2,a0
    8000121c:	fa61                	bnez	a2,800011ec <growproc+0x28>
      return -1;
    8000121e:	557d                	li	a0,-1
    80001220:	bfd9                	j	800011f6 <growproc+0x32>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001222:	9e25                	addw	a2,a2,s1
    80001224:	1602                	slli	a2,a2,0x20
    80001226:	9201                	srli	a2,a2,0x20
    80001228:	1582                	slli	a1,a1,0x20
    8000122a:	9181                	srli	a1,a1,0x20
    8000122c:	18053503          	ld	a0,384(a0)
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	642080e7          	jalr	1602(ra) # 80000872 <uvmdealloc>
    80001238:	0005061b          	sext.w	a2,a0
    8000123c:	bf45                	j	800011ec <growproc+0x28>

000000008000123e <fork>:
{
    8000123e:	7179                	addi	sp,sp,-48
    80001240:	f406                	sd	ra,40(sp)
    80001242:	f022                	sd	s0,32(sp)
    80001244:	ec26                	sd	s1,24(sp)
    80001246:	e84a                	sd	s2,16(sp)
    80001248:	e44e                	sd	s3,8(sp)
    8000124a:	e052                	sd	s4,0(sp)
    8000124c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	bfc080e7          	jalr	-1028(ra) # 80000e4a <myproc>
    80001256:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	e02080e7          	jalr	-510(ra) # 8000105a <allocproc>
    80001260:	10050c63          	beqz	a0,80001378 <fork+0x13a>
    80001264:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001266:	17893603          	ld	a2,376(s2)
    8000126a:	18053583          	ld	a1,384(a0)
    8000126e:	18093503          	ld	a0,384(s2)
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	794080e7          	jalr	1940(ra) # 80000a06 <uvmcopy>
    8000127a:	04054663          	bltz	a0,800012c6 <fork+0x88>
  np->sz = p->sz;
    8000127e:	17893783          	ld	a5,376(s2)
    80001282:	16f9bc23          	sd	a5,376(s3)
  *(np->trapframe) = *(p->trapframe);
    80001286:	18893683          	ld	a3,392(s2)
    8000128a:	87b6                	mv	a5,a3
    8000128c:	1889b703          	ld	a4,392(s3)
    80001290:	12068693          	addi	a3,a3,288
    80001294:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001298:	6788                	ld	a0,8(a5)
    8000129a:	6b8c                	ld	a1,16(a5)
    8000129c:	6f90                	ld	a2,24(a5)
    8000129e:	01073023          	sd	a6,0(a4)
    800012a2:	e708                	sd	a0,8(a4)
    800012a4:	eb0c                	sd	a1,16(a4)
    800012a6:	ef10                	sd	a2,24(a4)
    800012a8:	02078793          	addi	a5,a5,32
    800012ac:	02070713          	addi	a4,a4,32
    800012b0:	fed792e3          	bne	a5,a3,80001294 <fork+0x56>
  np->trapframe->a0 = 0;
    800012b4:	1889b783          	ld	a5,392(s3)
    800012b8:	0607b823          	sd	zero,112(a5)
    800012bc:	20000493          	li	s1,512
  for(i = 0; i < NOFILE; i++)
    800012c0:	28000a13          	li	s4,640
    800012c4:	a03d                	j	800012f2 <fork+0xb4>
    freeproc(np);
    800012c6:	854e                	mv	a0,s3
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	d34080e7          	jalr	-716(ra) # 80000ffc <freeproc>
    release(&np->lock);
    800012d0:	854e                	mv	a0,s3
    800012d2:	00005097          	auipc	ra,0x5
    800012d6:	026080e7          	jalr	38(ra) # 800062f8 <release>
    return -1;
    800012da:	5a7d                	li	s4,-1
    800012dc:	a069                	j	80001366 <fork+0x128>
      np->ofile[i] = filedup(p->ofile[i]);
    800012de:	00002097          	auipc	ra,0x2
    800012e2:	760080e7          	jalr	1888(ra) # 80003a3e <filedup>
    800012e6:	009987b3          	add	a5,s3,s1
    800012ea:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012ec:	04a1                	addi	s1,s1,8
    800012ee:	01448763          	beq	s1,s4,800012fc <fork+0xbe>
    if(p->ofile[i])
    800012f2:	009907b3          	add	a5,s2,s1
    800012f6:	6388                	ld	a0,0(a5)
    800012f8:	f17d                	bnez	a0,800012de <fork+0xa0>
    800012fa:	bfcd                	j	800012ec <fork+0xae>
  np->cwd = idup(p->cwd);
    800012fc:	28093503          	ld	a0,640(s2)
    80001300:	00002097          	auipc	ra,0x2
    80001304:	8b0080e7          	jalr	-1872(ra) # 80002bb0 <idup>
    80001308:	28a9b023          	sd	a0,640(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000130c:	4641                	li	a2,16
    8000130e:	28890593          	addi	a1,s2,648
    80001312:	28898513          	addi	a0,s3,648
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	fb4080e7          	jalr	-76(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000131e:	1609aa03          	lw	s4,352(s3)
  release(&np->lock);
    80001322:	854e                	mv	a0,s3
    80001324:	00005097          	auipc	ra,0x5
    80001328:	fd4080e7          	jalr	-44(ra) # 800062f8 <release>
  acquire(&wait_lock);
    8000132c:	00008497          	auipc	s1,0x8
    80001330:	d3c48493          	addi	s1,s1,-708 # 80009068 <wait_lock>
    80001334:	8526                	mv	a0,s1
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	f0e080e7          	jalr	-242(ra) # 80006244 <acquire>
  np->parent = p;
    8000133e:	1729b423          	sd	s2,360(s3)
  release(&wait_lock);
    80001342:	8526                	mv	a0,s1
    80001344:	00005097          	auipc	ra,0x5
    80001348:	fb4080e7          	jalr	-76(ra) # 800062f8 <release>
  acquire(&np->lock);
    8000134c:	854e                	mv	a0,s3
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	ef6080e7          	jalr	-266(ra) # 80006244 <acquire>
  np->state = RUNNABLE;
    80001356:	478d                	li	a5,3
    80001358:	14f9a623          	sw	a5,332(s3)
  release(&np->lock);
    8000135c:	854e                	mv	a0,s3
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	f9a080e7          	jalr	-102(ra) # 800062f8 <release>
}
    80001366:	8552                	mv	a0,s4
    80001368:	70a2                	ld	ra,40(sp)
    8000136a:	7402                	ld	s0,32(sp)
    8000136c:	64e2                	ld	s1,24(sp)
    8000136e:	6942                	ld	s2,16(sp)
    80001370:	69a2                	ld	s3,8(sp)
    80001372:	6a02                	ld	s4,0(sp)
    80001374:	6145                	addi	sp,sp,48
    80001376:	8082                	ret
    return -1;
    80001378:	5a7d                	li	s4,-1
    8000137a:	b7f5                	j	80001366 <fork+0x128>

000000008000137c <scheduler>:
{
    8000137c:	7139                	addi	sp,sp,-64
    8000137e:	fc06                	sd	ra,56(sp)
    80001380:	f822                	sd	s0,48(sp)
    80001382:	f426                	sd	s1,40(sp)
    80001384:	f04a                	sd	s2,32(sp)
    80001386:	ec4e                	sd	s3,24(sp)
    80001388:	e852                	sd	s4,16(sp)
    8000138a:	e456                	sd	s5,8(sp)
    8000138c:	e05a                	sd	s6,0(sp)
    8000138e:	0080                	addi	s0,sp,64
    80001390:	8792                	mv	a5,tp
  int id = r_tp();
    80001392:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001394:	00779a93          	slli	s5,a5,0x7
    80001398:	00008717          	auipc	a4,0x8
    8000139c:	cb870713          	addi	a4,a4,-840 # 80009050 <pid_lock>
    800013a0:	9756                	add	a4,a4,s5
    800013a2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013a6:	00008717          	auipc	a4,0x8
    800013aa:	ce270713          	addi	a4,a4,-798 # 80009088 <cpus+0x8>
    800013ae:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013b0:	498d                	li	s3,3
        p->state = RUNNING;
    800013b2:	4b11                	li	s6,4
        c->proc = p;
    800013b4:	079e                	slli	a5,a5,0x7
    800013b6:	00008a17          	auipc	s4,0x8
    800013ba:	c9aa0a13          	addi	s4,s4,-870 # 80009050 <pid_lock>
    800013be:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c0:	00012917          	auipc	s2,0x12
    800013c4:	6c090913          	addi	s2,s2,1728 # 80013a80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013d0:	10079073          	csrw	sstatus,a5
    800013d4:	00008497          	auipc	s1,0x8
    800013d8:	0ac48493          	addi	s1,s1,172 # 80009480 <proc>
    800013dc:	a03d                	j	8000140a <scheduler+0x8e>
        p->state = RUNNING;
    800013de:	1564a623          	sw	s6,332(s1)
        c->proc = p;
    800013e2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013e6:	19048593          	addi	a1,s1,400
    800013ea:	8556                	mv	a0,s5
    800013ec:	00000097          	auipc	ra,0x0
    800013f0:	660080e7          	jalr	1632(ra) # 80001a4c <swtch>
        c->proc = 0;
    800013f4:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013f8:	8526                	mv	a0,s1
    800013fa:	00005097          	auipc	ra,0x5
    800013fe:	efe080e7          	jalr	-258(ra) # 800062f8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001402:	29848493          	addi	s1,s1,664
    80001406:	fd2481e3          	beq	s1,s2,800013c8 <scheduler+0x4c>
      acquire(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	e38080e7          	jalr	-456(ra) # 80006244 <acquire>
      if(p->state == RUNNABLE) {
    80001414:	14c4a783          	lw	a5,332(s1)
    80001418:	ff3790e3          	bne	a5,s3,800013f8 <scheduler+0x7c>
    8000141c:	b7c9                	j	800013de <scheduler+0x62>

000000008000141e <sched>:
{
    8000141e:	7179                	addi	sp,sp,-48
    80001420:	f406                	sd	ra,40(sp)
    80001422:	f022                	sd	s0,32(sp)
    80001424:	ec26                	sd	s1,24(sp)
    80001426:	e84a                	sd	s2,16(sp)
    80001428:	e44e                	sd	s3,8(sp)
    8000142a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000142c:	00000097          	auipc	ra,0x0
    80001430:	a1e080e7          	jalr	-1506(ra) # 80000e4a <myproc>
    80001434:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	d94080e7          	jalr	-620(ra) # 800061ca <holding>
    8000143e:	cd25                	beqz	a0,800014b6 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001440:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001442:	2781                	sext.w	a5,a5
    80001444:	079e                	slli	a5,a5,0x7
    80001446:	00008717          	auipc	a4,0x8
    8000144a:	c0a70713          	addi	a4,a4,-1014 # 80009050 <pid_lock>
    8000144e:	97ba                	add	a5,a5,a4
    80001450:	0a87a703          	lw	a4,168(a5)
    80001454:	4785                	li	a5,1
    80001456:	06f71863          	bne	a4,a5,800014c6 <sched+0xa8>
  if(p->state == RUNNING)
    8000145a:	14c4a703          	lw	a4,332(s1)
    8000145e:	4791                	li	a5,4
    80001460:	06f70b63          	beq	a4,a5,800014d6 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001464:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001468:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000146a:	efb5                	bnez	a5,800014e6 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000146e:	00008917          	auipc	s2,0x8
    80001472:	be290913          	addi	s2,s2,-1054 # 80009050 <pid_lock>
    80001476:	2781                	sext.w	a5,a5
    80001478:	079e                	slli	a5,a5,0x7
    8000147a:	97ca                	add	a5,a5,s2
    8000147c:	0ac7a983          	lw	s3,172(a5)
    80001480:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001482:	2781                	sext.w	a5,a5
    80001484:	079e                	slli	a5,a5,0x7
    80001486:	00008597          	auipc	a1,0x8
    8000148a:	c0258593          	addi	a1,a1,-1022 # 80009088 <cpus+0x8>
    8000148e:	95be                	add	a1,a1,a5
    80001490:	19048513          	addi	a0,s1,400
    80001494:	00000097          	auipc	ra,0x0
    80001498:	5b8080e7          	jalr	1464(ra) # 80001a4c <swtch>
    8000149c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000149e:	2781                	sext.w	a5,a5
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	97ca                	add	a5,a5,s2
    800014a4:	0b37a623          	sw	s3,172(a5)
}
    800014a8:	70a2                	ld	ra,40(sp)
    800014aa:	7402                	ld	s0,32(sp)
    800014ac:	64e2                	ld	s1,24(sp)
    800014ae:	6942                	ld	s2,16(sp)
    800014b0:	69a2                	ld	s3,8(sp)
    800014b2:	6145                	addi	sp,sp,48
    800014b4:	8082                	ret
    panic("sched p->lock");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	ce250513          	addi	a0,a0,-798 # 80008198 <etext+0x198>
    800014be:	00004097          	auipc	ra,0x4
    800014c2:	7ec080e7          	jalr	2028(ra) # 80005caa <panic>
    panic("sched locks");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	ce250513          	addi	a0,a0,-798 # 800081a8 <etext+0x1a8>
    800014ce:	00004097          	auipc	ra,0x4
    800014d2:	7dc080e7          	jalr	2012(ra) # 80005caa <panic>
    panic("sched running");
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	ce250513          	addi	a0,a0,-798 # 800081b8 <etext+0x1b8>
    800014de:	00004097          	auipc	ra,0x4
    800014e2:	7cc080e7          	jalr	1996(ra) # 80005caa <panic>
    panic("sched interruptible");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	ce250513          	addi	a0,a0,-798 # 800081c8 <etext+0x1c8>
    800014ee:	00004097          	auipc	ra,0x4
    800014f2:	7bc080e7          	jalr	1980(ra) # 80005caa <panic>

00000000800014f6 <yield>:
{
    800014f6:	1101                	addi	sp,sp,-32
    800014f8:	ec06                	sd	ra,24(sp)
    800014fa:	e822                	sd	s0,16(sp)
    800014fc:	e426                	sd	s1,8(sp)
    800014fe:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001500:	00000097          	auipc	ra,0x0
    80001504:	94a080e7          	jalr	-1718(ra) # 80000e4a <myproc>
    80001508:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	d3a080e7          	jalr	-710(ra) # 80006244 <acquire>
  p->state = RUNNABLE;
    80001512:	478d                	li	a5,3
    80001514:	14f4a623          	sw	a5,332(s1)
  sched();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	f06080e7          	jalr	-250(ra) # 8000141e <sched>
  release(&p->lock);
    80001520:	8526                	mv	a0,s1
    80001522:	00005097          	auipc	ra,0x5
    80001526:	dd6080e7          	jalr	-554(ra) # 800062f8 <release>
}
    8000152a:	60e2                	ld	ra,24(sp)
    8000152c:	6442                	ld	s0,16(sp)
    8000152e:	64a2                	ld	s1,8(sp)
    80001530:	6105                	addi	sp,sp,32
    80001532:	8082                	ret

0000000080001534 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001534:	7179                	addi	sp,sp,-48
    80001536:	f406                	sd	ra,40(sp)
    80001538:	f022                	sd	s0,32(sp)
    8000153a:	ec26                	sd	s1,24(sp)
    8000153c:	e84a                	sd	s2,16(sp)
    8000153e:	e44e                	sd	s3,8(sp)
    80001540:	1800                	addi	s0,sp,48
    80001542:	89aa                	mv	s3,a0
    80001544:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	904080e7          	jalr	-1788(ra) # 80000e4a <myproc>
    8000154e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001550:	00005097          	auipc	ra,0x5
    80001554:	cf4080e7          	jalr	-780(ra) # 80006244 <acquire>
  release(lk);
    80001558:	854a                	mv	a0,s2
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	d9e080e7          	jalr	-610(ra) # 800062f8 <release>

  // Go to sleep.
  p->chan = chan;
    80001562:	1534b823          	sd	s3,336(s1)
  p->state = SLEEPING;
    80001566:	4789                	li	a5,2
    80001568:	14f4a623          	sw	a5,332(s1)

  sched();
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	eb2080e7          	jalr	-334(ra) # 8000141e <sched>

  // Tidy up.
  p->chan = 0;
    80001574:	1404b823          	sd	zero,336(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	d7e080e7          	jalr	-642(ra) # 800062f8 <release>
  acquire(lk);
    80001582:	854a                	mv	a0,s2
    80001584:	00005097          	auipc	ra,0x5
    80001588:	cc0080e7          	jalr	-832(ra) # 80006244 <acquire>
}
    8000158c:	70a2                	ld	ra,40(sp)
    8000158e:	7402                	ld	s0,32(sp)
    80001590:	64e2                	ld	s1,24(sp)
    80001592:	6942                	ld	s2,16(sp)
    80001594:	69a2                	ld	s3,8(sp)
    80001596:	6145                	addi	sp,sp,48
    80001598:	8082                	ret

000000008000159a <wait>:
{
    8000159a:	715d                	addi	sp,sp,-80
    8000159c:	e486                	sd	ra,72(sp)
    8000159e:	e0a2                	sd	s0,64(sp)
    800015a0:	fc26                	sd	s1,56(sp)
    800015a2:	f84a                	sd	s2,48(sp)
    800015a4:	f44e                	sd	s3,40(sp)
    800015a6:	f052                	sd	s4,32(sp)
    800015a8:	ec56                	sd	s5,24(sp)
    800015aa:	e85a                	sd	s6,16(sp)
    800015ac:	e45e                	sd	s7,8(sp)
    800015ae:	e062                	sd	s8,0(sp)
    800015b0:	0880                	addi	s0,sp,80
    800015b2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	896080e7          	jalr	-1898(ra) # 80000e4a <myproc>
    800015bc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015be:	00008517          	auipc	a0,0x8
    800015c2:	aaa50513          	addi	a0,a0,-1366 # 80009068 <wait_lock>
    800015c6:	00005097          	auipc	ra,0x5
    800015ca:	c7e080e7          	jalr	-898(ra) # 80006244 <acquire>
    havekids = 0;
    800015ce:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015d0:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015d2:	00012997          	auipc	s3,0x12
    800015d6:	4ae98993          	addi	s3,s3,1198 # 80013a80 <tickslock>
        havekids = 1;
    800015da:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015dc:	00008c17          	auipc	s8,0x8
    800015e0:	a8cc0c13          	addi	s8,s8,-1396 # 80009068 <wait_lock>
    havekids = 0;
    800015e4:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015e6:	00008497          	auipc	s1,0x8
    800015ea:	e9a48493          	addi	s1,s1,-358 # 80009480 <proc>
    800015ee:	a0bd                	j	8000165c <wait+0xc2>
          pid = np->pid;
    800015f0:	1604a983          	lw	s3,352(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f4:	000b0e63          	beqz	s6,80001610 <wait+0x76>
    800015f8:	4691                	li	a3,4
    800015fa:	15c48613          	addi	a2,s1,348
    800015fe:	85da                	mv	a1,s6
    80001600:	18093503          	ld	a0,384(s2)
    80001604:	fffff097          	auipc	ra,0xfffff
    80001608:	506080e7          	jalr	1286(ra) # 80000b0a <copyout>
    8000160c:	02054563          	bltz	a0,80001636 <wait+0x9c>
          freeproc(np);
    80001610:	8526                	mv	a0,s1
    80001612:	00000097          	auipc	ra,0x0
    80001616:	9ea080e7          	jalr	-1558(ra) # 80000ffc <freeproc>
          release(&np->lock);
    8000161a:	8526                	mv	a0,s1
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	cdc080e7          	jalr	-804(ra) # 800062f8 <release>
          release(&wait_lock);
    80001624:	00008517          	auipc	a0,0x8
    80001628:	a4450513          	addi	a0,a0,-1468 # 80009068 <wait_lock>
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	ccc080e7          	jalr	-820(ra) # 800062f8 <release>
          return pid;
    80001634:	a0ad                	j	8000169e <wait+0x104>
            release(&np->lock);
    80001636:	8526                	mv	a0,s1
    80001638:	00005097          	auipc	ra,0x5
    8000163c:	cc0080e7          	jalr	-832(ra) # 800062f8 <release>
            release(&wait_lock);
    80001640:	00008517          	auipc	a0,0x8
    80001644:	a2850513          	addi	a0,a0,-1496 # 80009068 <wait_lock>
    80001648:	00005097          	auipc	ra,0x5
    8000164c:	cb0080e7          	jalr	-848(ra) # 800062f8 <release>
            return -1;
    80001650:	59fd                	li	s3,-1
    80001652:	a0b1                	j	8000169e <wait+0x104>
    for(np = proc; np < &proc[NPROC]; np++){
    80001654:	29848493          	addi	s1,s1,664
    80001658:	03348663          	beq	s1,s3,80001684 <wait+0xea>
      if(np->parent == p){
    8000165c:	1684b783          	ld	a5,360(s1)
    80001660:	ff279ae3          	bne	a5,s2,80001654 <wait+0xba>
        acquire(&np->lock);
    80001664:	8526                	mv	a0,s1
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	bde080e7          	jalr	-1058(ra) # 80006244 <acquire>
        if(np->state == ZOMBIE){
    8000166e:	14c4a783          	lw	a5,332(s1)
    80001672:	f7478fe3          	beq	a5,s4,800015f0 <wait+0x56>
        release(&np->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	c80080e7          	jalr	-896(ra) # 800062f8 <release>
        havekids = 1;
    80001680:	8756                	mv	a4,s5
    80001682:	bfc9                	j	80001654 <wait+0xba>
    if(!havekids || p->killed){
    80001684:	c701                	beqz	a4,8000168c <wait+0xf2>
    80001686:	15892783          	lw	a5,344(s2)
    8000168a:	c79d                	beqz	a5,800016b8 <wait+0x11e>
      release(&wait_lock);
    8000168c:	00008517          	auipc	a0,0x8
    80001690:	9dc50513          	addi	a0,a0,-1572 # 80009068 <wait_lock>
    80001694:	00005097          	auipc	ra,0x5
    80001698:	c64080e7          	jalr	-924(ra) # 800062f8 <release>
      return -1;
    8000169c:	59fd                	li	s3,-1
}
    8000169e:	854e                	mv	a0,s3
    800016a0:	60a6                	ld	ra,72(sp)
    800016a2:	6406                	ld	s0,64(sp)
    800016a4:	74e2                	ld	s1,56(sp)
    800016a6:	7942                	ld	s2,48(sp)
    800016a8:	79a2                	ld	s3,40(sp)
    800016aa:	7a02                	ld	s4,32(sp)
    800016ac:	6ae2                	ld	s5,24(sp)
    800016ae:	6b42                	ld	s6,16(sp)
    800016b0:	6ba2                	ld	s7,8(sp)
    800016b2:	6c02                	ld	s8,0(sp)
    800016b4:	6161                	addi	sp,sp,80
    800016b6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b8:	85e2                	mv	a1,s8
    800016ba:	854a                	mv	a0,s2
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	e78080e7          	jalr	-392(ra) # 80001534 <sleep>
    havekids = 0;
    800016c4:	b705                	j	800015e4 <wait+0x4a>

00000000800016c6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016c6:	7139                	addi	sp,sp,-64
    800016c8:	fc06                	sd	ra,56(sp)
    800016ca:	f822                	sd	s0,48(sp)
    800016cc:	f426                	sd	s1,40(sp)
    800016ce:	f04a                	sd	s2,32(sp)
    800016d0:	ec4e                	sd	s3,24(sp)
    800016d2:	e852                	sd	s4,16(sp)
    800016d4:	e456                	sd	s5,8(sp)
    800016d6:	0080                	addi	s0,sp,64
    800016d8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016da:	00008497          	auipc	s1,0x8
    800016de:	da648493          	addi	s1,s1,-602 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016e4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e6:	00012917          	auipc	s2,0x12
    800016ea:	39a90913          	addi	s2,s2,922 # 80013a80 <tickslock>
    800016ee:	a821                	j	80001706 <wakeup+0x40>
        p->state = RUNNABLE;
    800016f0:	1554a623          	sw	s5,332(s1)
      }
      release(&p->lock);
    800016f4:	8526                	mv	a0,s1
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	c02080e7          	jalr	-1022(ra) # 800062f8 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016fe:	29848493          	addi	s1,s1,664
    80001702:	03248663          	beq	s1,s2,8000172e <wakeup+0x68>
    if(p != myproc()){
    80001706:	fffff097          	auipc	ra,0xfffff
    8000170a:	744080e7          	jalr	1860(ra) # 80000e4a <myproc>
    8000170e:	fea488e3          	beq	s1,a0,800016fe <wakeup+0x38>
      acquire(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	b30080e7          	jalr	-1232(ra) # 80006244 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000171c:	14c4a783          	lw	a5,332(s1)
    80001720:	fd379ae3          	bne	a5,s3,800016f4 <wakeup+0x2e>
    80001724:	1504b783          	ld	a5,336(s1)
    80001728:	fd4796e3          	bne	a5,s4,800016f4 <wakeup+0x2e>
    8000172c:	b7d1                	j	800016f0 <wakeup+0x2a>
    }
  }
}
    8000172e:	70e2                	ld	ra,56(sp)
    80001730:	7442                	ld	s0,48(sp)
    80001732:	74a2                	ld	s1,40(sp)
    80001734:	7902                	ld	s2,32(sp)
    80001736:	69e2                	ld	s3,24(sp)
    80001738:	6a42                	ld	s4,16(sp)
    8000173a:	6aa2                	ld	s5,8(sp)
    8000173c:	6121                	addi	sp,sp,64
    8000173e:	8082                	ret

0000000080001740 <reparent>:
{
    80001740:	7179                	addi	sp,sp,-48
    80001742:	f406                	sd	ra,40(sp)
    80001744:	f022                	sd	s0,32(sp)
    80001746:	ec26                	sd	s1,24(sp)
    80001748:	e84a                	sd	s2,16(sp)
    8000174a:	e44e                	sd	s3,8(sp)
    8000174c:	e052                	sd	s4,0(sp)
    8000174e:	1800                	addi	s0,sp,48
    80001750:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001752:	00008497          	auipc	s1,0x8
    80001756:	d2e48493          	addi	s1,s1,-722 # 80009480 <proc>
      pp->parent = initproc;
    8000175a:	00008a17          	auipc	s4,0x8
    8000175e:	8b6a0a13          	addi	s4,s4,-1866 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001762:	00012997          	auipc	s3,0x12
    80001766:	31e98993          	addi	s3,s3,798 # 80013a80 <tickslock>
    8000176a:	a029                	j	80001774 <reparent+0x34>
    8000176c:	29848493          	addi	s1,s1,664
    80001770:	01348f63          	beq	s1,s3,8000178e <reparent+0x4e>
    if(pp->parent == p){
    80001774:	1684b783          	ld	a5,360(s1)
    80001778:	ff279ae3          	bne	a5,s2,8000176c <reparent+0x2c>
      pp->parent = initproc;
    8000177c:	000a3503          	ld	a0,0(s4)
    80001780:	16a4b423          	sd	a0,360(s1)
      wakeup(initproc);
    80001784:	00000097          	auipc	ra,0x0
    80001788:	f42080e7          	jalr	-190(ra) # 800016c6 <wakeup>
    8000178c:	b7c5                	j	8000176c <reparent+0x2c>
}
    8000178e:	70a2                	ld	ra,40(sp)
    80001790:	7402                	ld	s0,32(sp)
    80001792:	64e2                	ld	s1,24(sp)
    80001794:	6942                	ld	s2,16(sp)
    80001796:	69a2                	ld	s3,8(sp)
    80001798:	6a02                	ld	s4,0(sp)
    8000179a:	6145                	addi	sp,sp,48
    8000179c:	8082                	ret

000000008000179e <exit>:
{
    8000179e:	7179                	addi	sp,sp,-48
    800017a0:	f406                	sd	ra,40(sp)
    800017a2:	f022                	sd	s0,32(sp)
    800017a4:	ec26                	sd	s1,24(sp)
    800017a6:	e84a                	sd	s2,16(sp)
    800017a8:	e44e                	sd	s3,8(sp)
    800017aa:	e052                	sd	s4,0(sp)
    800017ac:	1800                	addi	s0,sp,48
    800017ae:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017b0:	fffff097          	auipc	ra,0xfffff
    800017b4:	69a080e7          	jalr	1690(ra) # 80000e4a <myproc>
    800017b8:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ba:	00008797          	auipc	a5,0x8
    800017be:	8567b783          	ld	a5,-1962(a5) # 80009010 <initproc>
    800017c2:	20050493          	addi	s1,a0,512
    800017c6:	28050913          	addi	s2,a0,640
    800017ca:	02a79363          	bne	a5,a0,800017f0 <exit+0x52>
    panic("init exiting");
    800017ce:	00007517          	auipc	a0,0x7
    800017d2:	a1250513          	addi	a0,a0,-1518 # 800081e0 <etext+0x1e0>
    800017d6:	00004097          	auipc	ra,0x4
    800017da:	4d4080e7          	jalr	1236(ra) # 80005caa <panic>
      fileclose(f);
    800017de:	00002097          	auipc	ra,0x2
    800017e2:	2b2080e7          	jalr	690(ra) # 80003a90 <fileclose>
      p->ofile[fd] = 0;
    800017e6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ea:	04a1                	addi	s1,s1,8
    800017ec:	01248563          	beq	s1,s2,800017f6 <exit+0x58>
    if(p->ofile[fd]){
    800017f0:	6088                	ld	a0,0(s1)
    800017f2:	f575                	bnez	a0,800017de <exit+0x40>
    800017f4:	bfdd                	j	800017ea <exit+0x4c>
  begin_op();
    800017f6:	00002097          	auipc	ra,0x2
    800017fa:	dca080e7          	jalr	-566(ra) # 800035c0 <begin_op>
  iput(p->cwd);
    800017fe:	2809b503          	ld	a0,640(s3)
    80001802:	00001097          	auipc	ra,0x1
    80001806:	5a6080e7          	jalr	1446(ra) # 80002da8 <iput>
  end_op();
    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	e36080e7          	jalr	-458(ra) # 80003640 <end_op>
  p->cwd = 0;
    80001812:	2809b023          	sd	zero,640(s3)
  acquire(&wait_lock);
    80001816:	00008497          	auipc	s1,0x8
    8000181a:	85248493          	addi	s1,s1,-1966 # 80009068 <wait_lock>
    8000181e:	8526                	mv	a0,s1
    80001820:	00005097          	auipc	ra,0x5
    80001824:	a24080e7          	jalr	-1500(ra) # 80006244 <acquire>
  reparent(p);
    80001828:	854e                	mv	a0,s3
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	f16080e7          	jalr	-234(ra) # 80001740 <reparent>
  wakeup(p->parent);
    80001832:	1689b503          	ld	a0,360(s3)
    80001836:	00000097          	auipc	ra,0x0
    8000183a:	e90080e7          	jalr	-368(ra) # 800016c6 <wakeup>
  acquire(&p->lock);
    8000183e:	854e                	mv	a0,s3
    80001840:	00005097          	auipc	ra,0x5
    80001844:	a04080e7          	jalr	-1532(ra) # 80006244 <acquire>
  p->xstate = status;
    80001848:	1549ae23          	sw	s4,348(s3)
  p->state = ZOMBIE;
    8000184c:	4795                	li	a5,5
    8000184e:	14f9a623          	sw	a5,332(s3)
  release(&wait_lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	aa4080e7          	jalr	-1372(ra) # 800062f8 <release>
  sched();
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	bc2080e7          	jalr	-1086(ra) # 8000141e <sched>
  panic("zombie exit");
    80001864:	00007517          	auipc	a0,0x7
    80001868:	98c50513          	addi	a0,a0,-1652 # 800081f0 <etext+0x1f0>
    8000186c:	00004097          	auipc	ra,0x4
    80001870:	43e080e7          	jalr	1086(ra) # 80005caa <panic>

0000000080001874 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001874:	7179                	addi	sp,sp,-48
    80001876:	f406                	sd	ra,40(sp)
    80001878:	f022                	sd	s0,32(sp)
    8000187a:	ec26                	sd	s1,24(sp)
    8000187c:	e84a                	sd	s2,16(sp)
    8000187e:	e44e                	sd	s3,8(sp)
    80001880:	1800                	addi	s0,sp,48
    80001882:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001884:	00008497          	auipc	s1,0x8
    80001888:	bfc48493          	addi	s1,s1,-1028 # 80009480 <proc>
    8000188c:	00012997          	auipc	s3,0x12
    80001890:	1f498993          	addi	s3,s3,500 # 80013a80 <tickslock>
    acquire(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	9ae080e7          	jalr	-1618(ra) # 80006244 <acquire>
    if(p->pid == pid){
    8000189e:	1604a783          	lw	a5,352(s1)
    800018a2:	01278d63          	beq	a5,s2,800018bc <kill+0x48>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018a6:	8526                	mv	a0,s1
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	a50080e7          	jalr	-1456(ra) # 800062f8 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018b0:	29848493          	addi	s1,s1,664
    800018b4:	ff3490e3          	bne	s1,s3,80001894 <kill+0x20>
  }
  return -1;
    800018b8:	557d                	li	a0,-1
    800018ba:	a839                	j	800018d8 <kill+0x64>
      p->killed = 1;
    800018bc:	4785                	li	a5,1
    800018be:	14f4ac23          	sw	a5,344(s1)
      if(p->state == SLEEPING){
    800018c2:	14c4a703          	lw	a4,332(s1)
    800018c6:	4789                	li	a5,2
    800018c8:	00f70f63          	beq	a4,a5,800018e6 <kill+0x72>
      release(&p->lock);
    800018cc:	8526                	mv	a0,s1
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	a2a080e7          	jalr	-1494(ra) # 800062f8 <release>
      return 0;
    800018d6:	4501                	li	a0,0
}
    800018d8:	70a2                	ld	ra,40(sp)
    800018da:	7402                	ld	s0,32(sp)
    800018dc:	64e2                	ld	s1,24(sp)
    800018de:	6942                	ld	s2,16(sp)
    800018e0:	69a2                	ld	s3,8(sp)
    800018e2:	6145                	addi	sp,sp,48
    800018e4:	8082                	ret
        p->state = RUNNABLE;
    800018e6:	478d                	li	a5,3
    800018e8:	14f4a623          	sw	a5,332(s1)
    800018ec:	b7c5                	j	800018cc <kill+0x58>

00000000800018ee <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018ee:	7179                	addi	sp,sp,-48
    800018f0:	f406                	sd	ra,40(sp)
    800018f2:	f022                	sd	s0,32(sp)
    800018f4:	ec26                	sd	s1,24(sp)
    800018f6:	e84a                	sd	s2,16(sp)
    800018f8:	e44e                	sd	s3,8(sp)
    800018fa:	e052                	sd	s4,0(sp)
    800018fc:	1800                	addi	s0,sp,48
    800018fe:	84aa                	mv	s1,a0
    80001900:	892e                	mv	s2,a1
    80001902:	89b2                	mv	s3,a2
    80001904:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	544080e7          	jalr	1348(ra) # 80000e4a <myproc>
  if(user_dst){
    8000190e:	c095                	beqz	s1,80001932 <either_copyout+0x44>
    return copyout(p->pagetable, dst, src, len);
    80001910:	86d2                	mv	a3,s4
    80001912:	864e                	mv	a2,s3
    80001914:	85ca                	mv	a1,s2
    80001916:	18053503          	ld	a0,384(a0)
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	1f0080e7          	jalr	496(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001922:	70a2                	ld	ra,40(sp)
    80001924:	7402                	ld	s0,32(sp)
    80001926:	64e2                	ld	s1,24(sp)
    80001928:	6942                	ld	s2,16(sp)
    8000192a:	69a2                	ld	s3,8(sp)
    8000192c:	6a02                	ld	s4,0(sp)
    8000192e:	6145                	addi	sp,sp,48
    80001930:	8082                	ret
    memmove((char *)dst, src, len);
    80001932:	000a061b          	sext.w	a2,s4
    80001936:	85ce                	mv	a1,s3
    80001938:	854a                	mv	a0,s2
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	89e080e7          	jalr	-1890(ra) # 800001d8 <memmove>
    return 0;
    80001942:	8526                	mv	a0,s1
    80001944:	bff9                	j	80001922 <either_copyout+0x34>

0000000080001946 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001946:	7179                	addi	sp,sp,-48
    80001948:	f406                	sd	ra,40(sp)
    8000194a:	f022                	sd	s0,32(sp)
    8000194c:	ec26                	sd	s1,24(sp)
    8000194e:	e84a                	sd	s2,16(sp)
    80001950:	e44e                	sd	s3,8(sp)
    80001952:	e052                	sd	s4,0(sp)
    80001954:	1800                	addi	s0,sp,48
    80001956:	892a                	mv	s2,a0
    80001958:	84ae                	mv	s1,a1
    8000195a:	89b2                	mv	s3,a2
    8000195c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	4ec080e7          	jalr	1260(ra) # 80000e4a <myproc>
  if(user_src){
    80001966:	c095                	beqz	s1,8000198a <either_copyin+0x44>
    return copyin(p->pagetable, dst, src, len);
    80001968:	86d2                	mv	a3,s4
    8000196a:	864e                	mv	a2,s3
    8000196c:	85ca                	mv	a1,s2
    8000196e:	18053503          	ld	a0,384(a0)
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	224080e7          	jalr	548(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000197a:	70a2                	ld	ra,40(sp)
    8000197c:	7402                	ld	s0,32(sp)
    8000197e:	64e2                	ld	s1,24(sp)
    80001980:	6942                	ld	s2,16(sp)
    80001982:	69a2                	ld	s3,8(sp)
    80001984:	6a02                	ld	s4,0(sp)
    80001986:	6145                	addi	sp,sp,48
    80001988:	8082                	ret
    memmove(dst, (char*)src, len);
    8000198a:	000a061b          	sext.w	a2,s4
    8000198e:	85ce                	mv	a1,s3
    80001990:	854a                	mv	a0,s2
    80001992:	fffff097          	auipc	ra,0xfffff
    80001996:	846080e7          	jalr	-1978(ra) # 800001d8 <memmove>
    return 0;
    8000199a:	8526                	mv	a0,s1
    8000199c:	bff9                	j	8000197a <either_copyin+0x34>

000000008000199e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000199e:	715d                	addi	sp,sp,-80
    800019a0:	e486                	sd	ra,72(sp)
    800019a2:	e0a2                	sd	s0,64(sp)
    800019a4:	fc26                	sd	s1,56(sp)
    800019a6:	f84a                	sd	s2,48(sp)
    800019a8:	f44e                	sd	s3,40(sp)
    800019aa:	f052                	sd	s4,32(sp)
    800019ac:	ec56                	sd	s5,24(sp)
    800019ae:	e85a                	sd	s6,16(sp)
    800019b0:	e45e                	sd	s7,8(sp)
    800019b2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019b4:	00006517          	auipc	a0,0x6
    800019b8:	69450513          	addi	a0,a0,1684 # 80008048 <etext+0x48>
    800019bc:	00004097          	auipc	ra,0x4
    800019c0:	338080e7          	jalr	824(ra) # 80005cf4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c4:	00008497          	auipc	s1,0x8
    800019c8:	d4448493          	addi	s1,s1,-700 # 80009708 <proc+0x288>
    800019cc:	00012917          	auipc	s2,0x12
    800019d0:	33c90913          	addi	s2,s2,828 # 80013d08 <bcache+0x270>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019d6:	00007997          	auipc	s3,0x7
    800019da:	82a98993          	addi	s3,s3,-2006 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019de:	00007a97          	auipc	s5,0x7
    800019e2:	82aa8a93          	addi	s5,s5,-2006 # 80008208 <etext+0x208>
    printf("\n");
    800019e6:	00006a17          	auipc	s4,0x6
    800019ea:	662a0a13          	addi	s4,s4,1634 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ee:	00007b97          	auipc	s7,0x7
    800019f2:	852b8b93          	addi	s7,s7,-1966 # 80008240 <states.1719>
    800019f6:	a00d                	j	80001a18 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019f8:	ed86a583          	lw	a1,-296(a3)
    800019fc:	8556                	mv	a0,s5
    800019fe:	00004097          	auipc	ra,0x4
    80001a02:	2f6080e7          	jalr	758(ra) # 80005cf4 <printf>
    printf("\n");
    80001a06:	8552                	mv	a0,s4
    80001a08:	00004097          	auipc	ra,0x4
    80001a0c:	2ec080e7          	jalr	748(ra) # 80005cf4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a10:	29848493          	addi	s1,s1,664
    80001a14:	03248163          	beq	s1,s2,80001a36 <procdump+0x98>
    if(p->state == UNUSED)
    80001a18:	86a6                	mv	a3,s1
    80001a1a:	ec44a783          	lw	a5,-316(s1)
    80001a1e:	dbed                	beqz	a5,80001a10 <procdump+0x72>
      state = "???";
    80001a20:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a22:	fcfb6be3          	bltu	s6,a5,800019f8 <procdump+0x5a>
    80001a26:	1782                	slli	a5,a5,0x20
    80001a28:	9381                	srli	a5,a5,0x20
    80001a2a:	078e                	slli	a5,a5,0x3
    80001a2c:	97de                	add	a5,a5,s7
    80001a2e:	6390                	ld	a2,0(a5)
    80001a30:	f661                	bnez	a2,800019f8 <procdump+0x5a>
      state = "???";
    80001a32:	864e                	mv	a2,s3
    80001a34:	b7d1                	j	800019f8 <procdump+0x5a>
  }
}
    80001a36:	60a6                	ld	ra,72(sp)
    80001a38:	6406                	ld	s0,64(sp)
    80001a3a:	74e2                	ld	s1,56(sp)
    80001a3c:	7942                	ld	s2,48(sp)
    80001a3e:	79a2                	ld	s3,40(sp)
    80001a40:	7a02                	ld	s4,32(sp)
    80001a42:	6ae2                	ld	s5,24(sp)
    80001a44:	6b42                	ld	s6,16(sp)
    80001a46:	6ba2                	ld	s7,8(sp)
    80001a48:	6161                	addi	sp,sp,80
    80001a4a:	8082                	ret

0000000080001a4c <swtch>:
    80001a4c:	00153023          	sd	ra,0(a0)
    80001a50:	00253423          	sd	sp,8(a0)
    80001a54:	e900                	sd	s0,16(a0)
    80001a56:	ed04                	sd	s1,24(a0)
    80001a58:	03253023          	sd	s2,32(a0)
    80001a5c:	03353423          	sd	s3,40(a0)
    80001a60:	03453823          	sd	s4,48(a0)
    80001a64:	03553c23          	sd	s5,56(a0)
    80001a68:	05653023          	sd	s6,64(a0)
    80001a6c:	05753423          	sd	s7,72(a0)
    80001a70:	05853823          	sd	s8,80(a0)
    80001a74:	05953c23          	sd	s9,88(a0)
    80001a78:	07a53023          	sd	s10,96(a0)
    80001a7c:	07b53423          	sd	s11,104(a0)
    80001a80:	0005b083          	ld	ra,0(a1)
    80001a84:	0085b103          	ld	sp,8(a1)
    80001a88:	6980                	ld	s0,16(a1)
    80001a8a:	6d84                	ld	s1,24(a1)
    80001a8c:	0205b903          	ld	s2,32(a1)
    80001a90:	0285b983          	ld	s3,40(a1)
    80001a94:	0305ba03          	ld	s4,48(a1)
    80001a98:	0385ba83          	ld	s5,56(a1)
    80001a9c:	0405bb03          	ld	s6,64(a1)
    80001aa0:	0485bb83          	ld	s7,72(a1)
    80001aa4:	0505bc03          	ld	s8,80(a1)
    80001aa8:	0585bc83          	ld	s9,88(a1)
    80001aac:	0605bd03          	ld	s10,96(a1)
    80001ab0:	0685bd83          	ld	s11,104(a1)
    80001ab4:	8082                	ret

0000000080001ab6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ab6:	1141                	addi	sp,sp,-16
    80001ab8:	e406                	sd	ra,8(sp)
    80001aba:	e022                	sd	s0,0(sp)
    80001abc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001abe:	00006597          	auipc	a1,0x6
    80001ac2:	7b258593          	addi	a1,a1,1970 # 80008270 <states.1719+0x30>
    80001ac6:	00012517          	auipc	a0,0x12
    80001aca:	fba50513          	addi	a0,a0,-70 # 80013a80 <tickslock>
    80001ace:	00004097          	auipc	ra,0x4
    80001ad2:	6e6080e7          	jalr	1766(ra) # 800061b4 <initlock>
}
    80001ad6:	60a2                	ld	ra,8(sp)
    80001ad8:	6402                	ld	s0,0(sp)
    80001ada:	0141                	addi	sp,sp,16
    80001adc:	8082                	ret

0000000080001ade <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ade:	1141                	addi	sp,sp,-16
    80001ae0:	e422                	sd	s0,8(sp)
    80001ae2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae4:	00003797          	auipc	a5,0x3
    80001ae8:	5cc78793          	addi	a5,a5,1484 # 800050b0 <kernelvec>
    80001aec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001af0:	6422                	ld	s0,8(sp)
    80001af2:	0141                	addi	sp,sp,16
    80001af4:	8082                	ret

0000000080001af6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001af6:	1141                	addi	sp,sp,-16
    80001af8:	e406                	sd	ra,8(sp)
    80001afa:	e022                	sd	s0,0(sp)
    80001afc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001afe:	fffff097          	auipc	ra,0xfffff
    80001b02:	34c080e7          	jalr	844(ra) # 80000e4a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b0a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b0c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b10:	00005617          	auipc	a2,0x5
    80001b14:	4f060613          	addi	a2,a2,1264 # 80007000 <_trampoline>
    80001b18:	00005697          	auipc	a3,0x5
    80001b1c:	4e868693          	addi	a3,a3,1256 # 80007000 <_trampoline>
    80001b20:	8e91                	sub	a3,a3,a2
    80001b22:	040007b7          	lui	a5,0x4000
    80001b26:	17fd                	addi	a5,a5,-1
    80001b28:	07b2                	slli	a5,a5,0xc
    80001b2a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b2c:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b30:	18853703          	ld	a4,392(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b34:	180026f3          	csrr	a3,satp
    80001b38:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b3a:	18853703          	ld	a4,392(a0)
    80001b3e:	17053683          	ld	a3,368(a0)
    80001b42:	6585                	lui	a1,0x1
    80001b44:	96ae                	add	a3,a3,a1
    80001b46:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b48:	18853703          	ld	a4,392(a0)
    80001b4c:	00000697          	auipc	a3,0x0
    80001b50:	13e68693          	addi	a3,a3,318 # 80001c8a <usertrap>
    80001b54:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b56:	18853703          	ld	a4,392(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b5a:	8692                	mv	a3,tp
    80001b5c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b5e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b62:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b66:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b6e:	18853703          	ld	a4,392(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b72:	6f18                	ld	a4,24(a4)
    80001b74:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b78:	18053583          	ld	a1,384(a0)
    80001b7c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b7e:	00005717          	auipc	a4,0x5
    80001b82:	51270713          	addi	a4,a4,1298 # 80007090 <userret>
    80001b86:	8f11                	sub	a4,a4,a2
    80001b88:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b8a:	577d                	li	a4,-1
    80001b8c:	177e                	slli	a4,a4,0x3f
    80001b8e:	8dd9                	or	a1,a1,a4
    80001b90:	02000537          	lui	a0,0x2000
    80001b94:	157d                	addi	a0,a0,-1
    80001b96:	0536                	slli	a0,a0,0xd
    80001b98:	9782                	jalr	a5
}
    80001b9a:	60a2                	ld	ra,8(sp)
    80001b9c:	6402                	ld	s0,0(sp)
    80001b9e:	0141                	addi	sp,sp,16
    80001ba0:	8082                	ret

0000000080001ba2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ba2:	1101                	addi	sp,sp,-32
    80001ba4:	ec06                	sd	ra,24(sp)
    80001ba6:	e822                	sd	s0,16(sp)
    80001ba8:	e426                	sd	s1,8(sp)
    80001baa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bac:	00012497          	auipc	s1,0x12
    80001bb0:	ed448493          	addi	s1,s1,-300 # 80013a80 <tickslock>
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	00004097          	auipc	ra,0x4
    80001bba:	68e080e7          	jalr	1678(ra) # 80006244 <acquire>
  ticks++;
    80001bbe:	00007517          	auipc	a0,0x7
    80001bc2:	45a50513          	addi	a0,a0,1114 # 80009018 <ticks>
    80001bc6:	411c                	lw	a5,0(a0)
    80001bc8:	2785                	addiw	a5,a5,1
    80001bca:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bcc:	00000097          	auipc	ra,0x0
    80001bd0:	afa080e7          	jalr	-1286(ra) # 800016c6 <wakeup>
  release(&tickslock);
    80001bd4:	8526                	mv	a0,s1
    80001bd6:	00004097          	auipc	ra,0x4
    80001bda:	722080e7          	jalr	1826(ra) # 800062f8 <release>
}
    80001bde:	60e2                	ld	ra,24(sp)
    80001be0:	6442                	ld	s0,16(sp)
    80001be2:	64a2                	ld	s1,8(sp)
    80001be4:	6105                	addi	sp,sp,32
    80001be6:	8082                	ret

0000000080001be8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bf6:	00074d63          	bltz	a4,80001c10 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bfa:	57fd                	li	a5,-1
    80001bfc:	17fe                	slli	a5,a5,0x3f
    80001bfe:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c00:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c02:	06f70363          	beq	a4,a5,80001c68 <devintr+0x80>
  }
}
    80001c06:	60e2                	ld	ra,24(sp)
    80001c08:	6442                	ld	s0,16(sp)
    80001c0a:	64a2                	ld	s1,8(sp)
    80001c0c:	6105                	addi	sp,sp,32
    80001c0e:	8082                	ret
     (scause & 0xff) == 9){
    80001c10:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c14:	46a5                	li	a3,9
    80001c16:	fed792e3          	bne	a5,a3,80001bfa <devintr+0x12>
    int irq = plic_claim();
    80001c1a:	00003097          	auipc	ra,0x3
    80001c1e:	59e080e7          	jalr	1438(ra) # 800051b8 <plic_claim>
    80001c22:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c24:	47a9                	li	a5,10
    80001c26:	02f50763          	beq	a0,a5,80001c54 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c2a:	4785                	li	a5,1
    80001c2c:	02f50963          	beq	a0,a5,80001c5e <devintr+0x76>
    return 1;
    80001c30:	4505                	li	a0,1
    } else if(irq){
    80001c32:	d8f1                	beqz	s1,80001c06 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c34:	85a6                	mv	a1,s1
    80001c36:	00006517          	auipc	a0,0x6
    80001c3a:	64250513          	addi	a0,a0,1602 # 80008278 <states.1719+0x38>
    80001c3e:	00004097          	auipc	ra,0x4
    80001c42:	0b6080e7          	jalr	182(ra) # 80005cf4 <printf>
      plic_complete(irq);
    80001c46:	8526                	mv	a0,s1
    80001c48:	00003097          	auipc	ra,0x3
    80001c4c:	594080e7          	jalr	1428(ra) # 800051dc <plic_complete>
    return 1;
    80001c50:	4505                	li	a0,1
    80001c52:	bf55                	j	80001c06 <devintr+0x1e>
      uartintr();
    80001c54:	00004097          	auipc	ra,0x4
    80001c58:	510080e7          	jalr	1296(ra) # 80006164 <uartintr>
    80001c5c:	b7ed                	j	80001c46 <devintr+0x5e>
      virtio_disk_intr();
    80001c5e:	00004097          	auipc	ra,0x4
    80001c62:	a5e080e7          	jalr	-1442(ra) # 800056bc <virtio_disk_intr>
    80001c66:	b7c5                	j	80001c46 <devintr+0x5e>
    if(cpuid() == 0){
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	1b6080e7          	jalr	438(ra) # 80000e1e <cpuid>
    80001c70:	c901                	beqz	a0,80001c80 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c72:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c78:	14479073          	csrw	sip,a5
    return 2;
    80001c7c:	4509                	li	a0,2
    80001c7e:	b761                	j	80001c06 <devintr+0x1e>
      clockintr();
    80001c80:	00000097          	auipc	ra,0x0
    80001c84:	f22080e7          	jalr	-222(ra) # 80001ba2 <clockintr>
    80001c88:	b7ed                	j	80001c72 <devintr+0x8a>

0000000080001c8a <usertrap>:
{
    80001c8a:	1101                	addi	sp,sp,-32
    80001c8c:	ec06                	sd	ra,24(sp)
    80001c8e:	e822                	sd	s0,16(sp)
    80001c90:	e426                	sd	s1,8(sp)
    80001c92:	e04a                	sd	s2,0(sp)
    80001c94:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c96:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c9a:	1007f793          	andi	a5,a5,256
    80001c9e:	e7ad                	bnez	a5,80001d08 <usertrap+0x7e>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca0:	00003797          	auipc	a5,0x3
    80001ca4:	41078793          	addi	a5,a5,1040 # 800050b0 <kernelvec>
    80001ca8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cac:	fffff097          	auipc	ra,0xfffff
    80001cb0:	19e080e7          	jalr	414(ra) # 80000e4a <myproc>
    80001cb4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cb6:	18853783          	ld	a5,392(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cba:	14102773          	csrr	a4,sepc
    80001cbe:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cc4:	47a1                	li	a5,8
    80001cc6:	04f71f63          	bne	a4,a5,80001d24 <usertrap+0x9a>
    if(p->killed)
    80001cca:	15852783          	lw	a5,344(a0)
    80001cce:	e7a9                	bnez	a5,80001d18 <usertrap+0x8e>
    p->trapframe->epc += 4;
    80001cd0:	1884b703          	ld	a4,392(s1)
    80001cd4:	6f1c                	ld	a5,24(a4)
    80001cd6:	0791                	addi	a5,a5,4
    80001cd8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cda:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cde:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	35c080e7          	jalr	860(ra) # 80002042 <syscall>
  if(p->killed)
    80001cee:	1584a783          	lw	a5,344(s1)
    80001cf2:	efc5                	bnez	a5,80001daa <usertrap+0x120>
  usertrapret();
    80001cf4:	00000097          	auipc	ra,0x0
    80001cf8:	e02080e7          	jalr	-510(ra) # 80001af6 <usertrapret>
}
    80001cfc:	60e2                	ld	ra,24(sp)
    80001cfe:	6442                	ld	s0,16(sp)
    80001d00:	64a2                	ld	s1,8(sp)
    80001d02:	6902                	ld	s2,0(sp)
    80001d04:	6105                	addi	sp,sp,32
    80001d06:	8082                	ret
    panic("usertrap: not from user mode");
    80001d08:	00006517          	auipc	a0,0x6
    80001d0c:	59050513          	addi	a0,a0,1424 # 80008298 <states.1719+0x58>
    80001d10:	00004097          	auipc	ra,0x4
    80001d14:	f9a080e7          	jalr	-102(ra) # 80005caa <panic>
      exit(-1);
    80001d18:	557d                	li	a0,-1
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	a84080e7          	jalr	-1404(ra) # 8000179e <exit>
    80001d22:	b77d                	j	80001cd0 <usertrap+0x46>
  } else if((which_dev = devintr()) != 0){
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	ec4080e7          	jalr	-316(ra) # 80001be8 <devintr>
    80001d2c:	892a                	mv	s2,a0
    80001d2e:	c509                	beqz	a0,80001d38 <usertrap+0xae>
  if(p->killed)
    80001d30:	1584a783          	lw	a5,344(s1)
    80001d34:	c3b1                	beqz	a5,80001d78 <usertrap+0xee>
    80001d36:	a825                	j	80001d6e <usertrap+0xe4>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d38:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d3c:	1604a603          	lw	a2,352(s1)
    80001d40:	00006517          	auipc	a0,0x6
    80001d44:	57850513          	addi	a0,a0,1400 # 800082b8 <states.1719+0x78>
    80001d48:	00004097          	auipc	ra,0x4
    80001d4c:	fac080e7          	jalr	-84(ra) # 80005cf4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d50:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d54:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d58:	00006517          	auipc	a0,0x6
    80001d5c:	59050513          	addi	a0,a0,1424 # 800082e8 <states.1719+0xa8>
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	f94080e7          	jalr	-108(ra) # 80005cf4 <printf>
    p->killed = 1;
    80001d68:	4785                	li	a5,1
    80001d6a:	14f4ac23          	sw	a5,344(s1)
    exit(-1);
    80001d6e:	557d                	li	a0,-1
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	a2e080e7          	jalr	-1490(ra) # 8000179e <exit>
  if(which_dev == 2) {
    80001d78:	4789                	li	a5,2
    80001d7a:	f6f91de3          	bne	s2,a5,80001cf4 <usertrap+0x6a>
    struct proc *proc = myproc();
    80001d7e:	fffff097          	auipc	ra,0xfffff
    80001d82:	0cc080e7          	jalr	204(ra) # 80000e4a <myproc>
    if (proc->alarm_interval && proc->have_return) {
    80001d86:	511c                	lw	a5,32(a0)
    80001d88:	cf81                	beqz	a5,80001da0 <usertrap+0x116>
    80001d8a:	14852783          	lw	a5,328(a0)
    80001d8e:	cb89                	beqz	a5,80001da0 <usertrap+0x116>
      if (++proc->passed_ticks == 2) {
    80001d90:	515c                	lw	a5,36(a0)
    80001d92:	2785                	addiw	a5,a5,1
    80001d94:	0007871b          	sext.w	a4,a5
    80001d98:	d15c                	sw	a5,36(a0)
    80001d9a:	4789                	li	a5,2
    80001d9c:	00f70963          	beq	a4,a5,80001dae <usertrap+0x124>
    yield();
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	756080e7          	jalr	1878(ra) # 800014f6 <yield>
    80001da8:	b7b1                	j	80001cf4 <usertrap+0x6a>
  int which_dev = 0;
    80001daa:	4901                	li	s2,0
    80001dac:	b7c9                	j	80001d6e <usertrap+0xe4>
        proc->saved_trapframe = *p->trapframe;
    80001dae:	1884b783          	ld	a5,392(s1)
    80001db2:	02850713          	addi	a4,a0,40
    80001db6:	12078893          	addi	a7,a5,288
    80001dba:	0007b803          	ld	a6,0(a5)
    80001dbe:	678c                	ld	a1,8(a5)
    80001dc0:	6b90                	ld	a2,16(a5)
    80001dc2:	6f94                	ld	a3,24(a5)
    80001dc4:	01073023          	sd	a6,0(a4)
    80001dc8:	e70c                	sd	a1,8(a4)
    80001dca:	eb10                	sd	a2,16(a4)
    80001dcc:	ef14                	sd	a3,24(a4)
    80001dce:	02078793          	addi	a5,a5,32
    80001dd2:	02070713          	addi	a4,a4,32
    80001dd6:	ff1792e3          	bne	a5,a7,80001dba <usertrap+0x130>
        proc->trapframe->epc = proc->handler_va;
    80001dda:	18853783          	ld	a5,392(a0)
    80001dde:	6d18                	ld	a4,24(a0)
    80001de0:	ef98                	sd	a4,24(a5)
        proc->passed_ticks = 0;
    80001de2:	02052223          	sw	zero,36(a0)
        proc->have_return = 0;
    80001de6:	14052423          	sw	zero,328(a0)
    80001dea:	bf5d                	j	80001da0 <usertrap+0x116>

0000000080001dec <kerneltrap>:
{
    80001dec:	7179                	addi	sp,sp,-48
    80001dee:	f406                	sd	ra,40(sp)
    80001df0:	f022                	sd	s0,32(sp)
    80001df2:	ec26                	sd	s1,24(sp)
    80001df4:	e84a                	sd	s2,16(sp)
    80001df6:	e44e                	sd	s3,8(sp)
    80001df8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dfa:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e02:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e06:	1004f793          	andi	a5,s1,256
    80001e0a:	cb85                	beqz	a5,80001e3a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e10:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e12:	ef85                	bnez	a5,80001e4a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	dd4080e7          	jalr	-556(ra) # 80001be8 <devintr>
    80001e1c:	cd1d                	beqz	a0,80001e5a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e1e:	4789                	li	a5,2
    80001e20:	06f50a63          	beq	a0,a5,80001e94 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e24:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e28:	10049073          	csrw	sstatus,s1
}
    80001e2c:	70a2                	ld	ra,40(sp)
    80001e2e:	7402                	ld	s0,32(sp)
    80001e30:	64e2                	ld	s1,24(sp)
    80001e32:	6942                	ld	s2,16(sp)
    80001e34:	69a2                	ld	s3,8(sp)
    80001e36:	6145                	addi	sp,sp,48
    80001e38:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e3a:	00006517          	auipc	a0,0x6
    80001e3e:	4ce50513          	addi	a0,a0,1230 # 80008308 <states.1719+0xc8>
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	e68080e7          	jalr	-408(ra) # 80005caa <panic>
    panic("kerneltrap: interrupts enabled");
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	4e650513          	addi	a0,a0,1254 # 80008330 <states.1719+0xf0>
    80001e52:	00004097          	auipc	ra,0x4
    80001e56:	e58080e7          	jalr	-424(ra) # 80005caa <panic>
    printf("scause %p\n", scause);
    80001e5a:	85ce                	mv	a1,s3
    80001e5c:	00006517          	auipc	a0,0x6
    80001e60:	4f450513          	addi	a0,a0,1268 # 80008350 <states.1719+0x110>
    80001e64:	00004097          	auipc	ra,0x4
    80001e68:	e90080e7          	jalr	-368(ra) # 80005cf4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e70:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e74:	00006517          	auipc	a0,0x6
    80001e78:	4ec50513          	addi	a0,a0,1260 # 80008360 <states.1719+0x120>
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	e78080e7          	jalr	-392(ra) # 80005cf4 <printf>
    panic("kerneltrap");
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	4f450513          	addi	a0,a0,1268 # 80008378 <states.1719+0x138>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	e1e080e7          	jalr	-482(ra) # 80005caa <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	fb6080e7          	jalr	-74(ra) # 80000e4a <myproc>
    80001e9c:	d541                	beqz	a0,80001e24 <kerneltrap+0x38>
    80001e9e:	fffff097          	auipc	ra,0xfffff
    80001ea2:	fac080e7          	jalr	-84(ra) # 80000e4a <myproc>
    80001ea6:	14c52703          	lw	a4,332(a0)
    80001eaa:	4791                	li	a5,4
    80001eac:	f6f71ce3          	bne	a4,a5,80001e24 <kerneltrap+0x38>
    yield();
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	646080e7          	jalr	1606(ra) # 800014f6 <yield>
    80001eb8:	b7b5                	j	80001e24 <kerneltrap+0x38>

0000000080001eba <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eba:	1101                	addi	sp,sp,-32
    80001ebc:	ec06                	sd	ra,24(sp)
    80001ebe:	e822                	sd	s0,16(sp)
    80001ec0:	e426                	sd	s1,8(sp)
    80001ec2:	1000                	addi	s0,sp,32
    80001ec4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	f84080e7          	jalr	-124(ra) # 80000e4a <myproc>
  switch (n) {
    80001ece:	4795                	li	a5,5
    80001ed0:	0497e763          	bltu	a5,s1,80001f1e <argraw+0x64>
    80001ed4:	048a                	slli	s1,s1,0x2
    80001ed6:	00006717          	auipc	a4,0x6
    80001eda:	4da70713          	addi	a4,a4,1242 # 800083b0 <states.1719+0x170>
    80001ede:	94ba                	add	s1,s1,a4
    80001ee0:	409c                	lw	a5,0(s1)
    80001ee2:	97ba                	add	a5,a5,a4
    80001ee4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ee6:	18853783          	ld	a5,392(a0)
    80001eea:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eec:	60e2                	ld	ra,24(sp)
    80001eee:	6442                	ld	s0,16(sp)
    80001ef0:	64a2                	ld	s1,8(sp)
    80001ef2:	6105                	addi	sp,sp,32
    80001ef4:	8082                	ret
    return p->trapframe->a1;
    80001ef6:	18853783          	ld	a5,392(a0)
    80001efa:	7fa8                	ld	a0,120(a5)
    80001efc:	bfc5                	j	80001eec <argraw+0x32>
    return p->trapframe->a2;
    80001efe:	18853783          	ld	a5,392(a0)
    80001f02:	63c8                	ld	a0,128(a5)
    80001f04:	b7e5                	j	80001eec <argraw+0x32>
    return p->trapframe->a3;
    80001f06:	18853783          	ld	a5,392(a0)
    80001f0a:	67c8                	ld	a0,136(a5)
    80001f0c:	b7c5                	j	80001eec <argraw+0x32>
    return p->trapframe->a4;
    80001f0e:	18853783          	ld	a5,392(a0)
    80001f12:	6bc8                	ld	a0,144(a5)
    80001f14:	bfe1                	j	80001eec <argraw+0x32>
    return p->trapframe->a5;
    80001f16:	18853783          	ld	a5,392(a0)
    80001f1a:	6fc8                	ld	a0,152(a5)
    80001f1c:	bfc1                	j	80001eec <argraw+0x32>
  panic("argraw");
    80001f1e:	00006517          	auipc	a0,0x6
    80001f22:	46a50513          	addi	a0,a0,1130 # 80008388 <states.1719+0x148>
    80001f26:	00004097          	auipc	ra,0x4
    80001f2a:	d84080e7          	jalr	-636(ra) # 80005caa <panic>

0000000080001f2e <fetchaddr>:
{
    80001f2e:	1101                	addi	sp,sp,-32
    80001f30:	ec06                	sd	ra,24(sp)
    80001f32:	e822                	sd	s0,16(sp)
    80001f34:	e426                	sd	s1,8(sp)
    80001f36:	e04a                	sd	s2,0(sp)
    80001f38:	1000                	addi	s0,sp,32
    80001f3a:	84aa                	mv	s1,a0
    80001f3c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f3e:	fffff097          	auipc	ra,0xfffff
    80001f42:	f0c080e7          	jalr	-244(ra) # 80000e4a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f46:	17853783          	ld	a5,376(a0)
    80001f4a:	02f4f963          	bgeu	s1,a5,80001f7c <fetchaddr+0x4e>
    80001f4e:	00848713          	addi	a4,s1,8
    80001f52:	02e7e763          	bltu	a5,a4,80001f80 <fetchaddr+0x52>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f56:	46a1                	li	a3,8
    80001f58:	8626                	mv	a2,s1
    80001f5a:	85ca                	mv	a1,s2
    80001f5c:	18053503          	ld	a0,384(a0)
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	c36080e7          	jalr	-970(ra) # 80000b96 <copyin>
    80001f68:	00a03533          	snez	a0,a0
    80001f6c:	40a00533          	neg	a0,a0
}
    80001f70:	60e2                	ld	ra,24(sp)
    80001f72:	6442                	ld	s0,16(sp)
    80001f74:	64a2                	ld	s1,8(sp)
    80001f76:	6902                	ld	s2,0(sp)
    80001f78:	6105                	addi	sp,sp,32
    80001f7a:	8082                	ret
    return -1;
    80001f7c:	557d                	li	a0,-1
    80001f7e:	bfcd                	j	80001f70 <fetchaddr+0x42>
    80001f80:	557d                	li	a0,-1
    80001f82:	b7fd                	j	80001f70 <fetchaddr+0x42>

0000000080001f84 <fetchstr>:
{
    80001f84:	7179                	addi	sp,sp,-48
    80001f86:	f406                	sd	ra,40(sp)
    80001f88:	f022                	sd	s0,32(sp)
    80001f8a:	ec26                	sd	s1,24(sp)
    80001f8c:	e84a                	sd	s2,16(sp)
    80001f8e:	e44e                	sd	s3,8(sp)
    80001f90:	1800                	addi	s0,sp,48
    80001f92:	892a                	mv	s2,a0
    80001f94:	84ae                	mv	s1,a1
    80001f96:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	eb2080e7          	jalr	-334(ra) # 80000e4a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fa0:	86ce                	mv	a3,s3
    80001fa2:	864a                	mv	a2,s2
    80001fa4:	85a6                	mv	a1,s1
    80001fa6:	18053503          	ld	a0,384(a0)
    80001faa:	fffff097          	auipc	ra,0xfffff
    80001fae:	c78080e7          	jalr	-904(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001fb2:	00054763          	bltz	a0,80001fc0 <fetchstr+0x3c>
  return strlen(buf);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	ffffe097          	auipc	ra,0xffffe
    80001fbc:	344080e7          	jalr	836(ra) # 800002fc <strlen>
}
    80001fc0:	70a2                	ld	ra,40(sp)
    80001fc2:	7402                	ld	s0,32(sp)
    80001fc4:	64e2                	ld	s1,24(sp)
    80001fc6:	6942                	ld	s2,16(sp)
    80001fc8:	69a2                	ld	s3,8(sp)
    80001fca:	6145                	addi	sp,sp,48
    80001fcc:	8082                	ret

0000000080001fce <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fce:	1101                	addi	sp,sp,-32
    80001fd0:	ec06                	sd	ra,24(sp)
    80001fd2:	e822                	sd	s0,16(sp)
    80001fd4:	e426                	sd	s1,8(sp)
    80001fd6:	1000                	addi	s0,sp,32
    80001fd8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	ee0080e7          	jalr	-288(ra) # 80001eba <argraw>
    80001fe2:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fe4:	4501                	li	a0,0
    80001fe6:	60e2                	ld	ra,24(sp)
    80001fe8:	6442                	ld	s0,16(sp)
    80001fea:	64a2                	ld	s1,8(sp)
    80001fec:	6105                	addi	sp,sp,32
    80001fee:	8082                	ret

0000000080001ff0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	1000                	addi	s0,sp,32
    80001ffa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ffc:	00000097          	auipc	ra,0x0
    80002000:	ebe080e7          	jalr	-322(ra) # 80001eba <argraw>
    80002004:	e088                	sd	a0,0(s1)
  return 0;
}
    80002006:	4501                	li	a0,0
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6105                	addi	sp,sp,32
    80002010:	8082                	ret

0000000080002012 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002012:	1101                	addi	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	e04a                	sd	s2,0(sp)
    8000201c:	1000                	addi	s0,sp,32
    8000201e:	84ae                	mv	s1,a1
    80002020:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002022:	00000097          	auipc	ra,0x0
    80002026:	e98080e7          	jalr	-360(ra) # 80001eba <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000202a:	864a                	mv	a2,s2
    8000202c:	85a6                	mv	a1,s1
    8000202e:	00000097          	auipc	ra,0x0
    80002032:	f56080e7          	jalr	-170(ra) # 80001f84 <fetchstr>
}
    80002036:	60e2                	ld	ra,24(sp)
    80002038:	6442                	ld	s0,16(sp)
    8000203a:	64a2                	ld	s1,8(sp)
    8000203c:	6902                	ld	s2,0(sp)
    8000203e:	6105                	addi	sp,sp,32
    80002040:	8082                	ret

0000000080002042 <syscall>:
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    80002042:	1101                	addi	sp,sp,-32
    80002044:	ec06                	sd	ra,24(sp)
    80002046:	e822                	sd	s0,16(sp)
    80002048:	e426                	sd	s1,8(sp)
    8000204a:	e04a                	sd	s2,0(sp)
    8000204c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	dfc080e7          	jalr	-516(ra) # 80000e4a <myproc>
    80002056:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002058:	18853903          	ld	s2,392(a0)
    8000205c:	0a893783          	ld	a5,168(s2)
    80002060:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002064:	37fd                	addiw	a5,a5,-1
    80002066:	4759                	li	a4,22
    80002068:	00f76f63          	bltu	a4,a5,80002086 <syscall+0x44>
    8000206c:	00369713          	slli	a4,a3,0x3
    80002070:	00006797          	auipc	a5,0x6
    80002074:	35878793          	addi	a5,a5,856 # 800083c8 <syscalls>
    80002078:	97ba                	add	a5,a5,a4
    8000207a:	639c                	ld	a5,0(a5)
    8000207c:	c789                	beqz	a5,80002086 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000207e:	9782                	jalr	a5
    80002080:	06a93823          	sd	a0,112(s2)
    80002084:	a00d                	j	800020a6 <syscall+0x64>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002086:	28848613          	addi	a2,s1,648
    8000208a:	1604a583          	lw	a1,352(s1)
    8000208e:	00006517          	auipc	a0,0x6
    80002092:	30250513          	addi	a0,a0,770 # 80008390 <states.1719+0x150>
    80002096:	00004097          	auipc	ra,0x4
    8000209a:	c5e080e7          	jalr	-930(ra) # 80005cf4 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000209e:	1884b783          	ld	a5,392(s1)
    800020a2:	577d                	li	a4,-1
    800020a4:	fbb8                	sd	a4,112(a5)
  }
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6902                	ld	s2,0(sp)
    800020ae:	6105                	addi	sp,sp,32
    800020b0:	8082                	ret

00000000800020b2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020b2:	1101                	addi	sp,sp,-32
    800020b4:	ec06                	sd	ra,24(sp)
    800020b6:	e822                	sd	s0,16(sp)
    800020b8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020ba:	fec40593          	addi	a1,s0,-20
    800020be:	4501                	li	a0,0
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	f0e080e7          	jalr	-242(ra) # 80001fce <argint>
    return -1;
    800020c8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ca:	00054963          	bltz	a0,800020dc <sys_exit+0x2a>
  exit(n);
    800020ce:	fec42503          	lw	a0,-20(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	6cc080e7          	jalr	1740(ra) # 8000179e <exit>
  return 0;  // not reached
    800020da:	4781                	li	a5,0
}
    800020dc:	853e                	mv	a0,a5
    800020de:	60e2                	ld	ra,24(sp)
    800020e0:	6442                	ld	s0,16(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e6:	1141                	addi	sp,sp,-16
    800020e8:	e406                	sd	ra,8(sp)
    800020ea:	e022                	sd	s0,0(sp)
    800020ec:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	d5c080e7          	jalr	-676(ra) # 80000e4a <myproc>
}
    800020f6:	16052503          	lw	a0,352(a0)
    800020fa:	60a2                	ld	ra,8(sp)
    800020fc:	6402                	ld	s0,0(sp)
    800020fe:	0141                	addi	sp,sp,16
    80002100:	8082                	ret

0000000080002102 <sys_fork>:

uint64
sys_fork(void)
{
    80002102:	1141                	addi	sp,sp,-16
    80002104:	e406                	sd	ra,8(sp)
    80002106:	e022                	sd	s0,0(sp)
    80002108:	0800                	addi	s0,sp,16
  return fork();
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	134080e7          	jalr	308(ra) # 8000123e <fork>
}
    80002112:	60a2                	ld	ra,8(sp)
    80002114:	6402                	ld	s0,0(sp)
    80002116:	0141                	addi	sp,sp,16
    80002118:	8082                	ret

000000008000211a <sys_wait>:

uint64
sys_wait(void)
{
    8000211a:	1101                	addi	sp,sp,-32
    8000211c:	ec06                	sd	ra,24(sp)
    8000211e:	e822                	sd	s0,16(sp)
    80002120:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002122:	fe840593          	addi	a1,s0,-24
    80002126:	4501                	li	a0,0
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	ec8080e7          	jalr	-312(ra) # 80001ff0 <argaddr>
    80002130:	87aa                	mv	a5,a0
    return -1;
    80002132:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002134:	0007c863          	bltz	a5,80002144 <sys_wait+0x2a>
  return wait(p);
    80002138:	fe843503          	ld	a0,-24(s0)
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	45e080e7          	jalr	1118(ra) # 8000159a <wait>
}
    80002144:	60e2                	ld	ra,24(sp)
    80002146:	6442                	ld	s0,16(sp)
    80002148:	6105                	addi	sp,sp,32
    8000214a:	8082                	ret

000000008000214c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000214c:	7179                	addi	sp,sp,-48
    8000214e:	f406                	sd	ra,40(sp)
    80002150:	f022                	sd	s0,32(sp)
    80002152:	ec26                	sd	s1,24(sp)
    80002154:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002156:	fdc40593          	addi	a1,s0,-36
    8000215a:	4501                	li	a0,0
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	e72080e7          	jalr	-398(ra) # 80001fce <argint>
    80002164:	87aa                	mv	a5,a0
    return -1;
    80002166:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002168:	0207c163          	bltz	a5,8000218a <sys_sbrk+0x3e>
  addr = myproc()->sz;
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	cde080e7          	jalr	-802(ra) # 80000e4a <myproc>
    80002174:	17852483          	lw	s1,376(a0)
  if(growproc(n) < 0)
    80002178:	fdc42503          	lw	a0,-36(s0)
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	048080e7          	jalr	72(ra) # 800011c4 <growproc>
    80002184:	00054863          	bltz	a0,80002194 <sys_sbrk+0x48>
    return -1;
  return addr;
    80002188:	8526                	mv	a0,s1
}
    8000218a:	70a2                	ld	ra,40(sp)
    8000218c:	7402                	ld	s0,32(sp)
    8000218e:	64e2                	ld	s1,24(sp)
    80002190:	6145                	addi	sp,sp,48
    80002192:	8082                	ret
    return -1;
    80002194:	557d                	li	a0,-1
    80002196:	bfd5                	j	8000218a <sys_sbrk+0x3e>

0000000080002198 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002198:	7139                	addi	sp,sp,-64
    8000219a:	fc06                	sd	ra,56(sp)
    8000219c:	f822                	sd	s0,48(sp)
    8000219e:	f426                	sd	s1,40(sp)
    800021a0:	f04a                	sd	s2,32(sp)
    800021a2:	ec4e                	sd	s3,24(sp)
    800021a4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  backtrace();
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	d66080e7          	jalr	-666(ra) # 80005f0c <backtrace>

  if(argint(0, &n) < 0)
    800021ae:	fcc40593          	addi	a1,s0,-52
    800021b2:	4501                	li	a0,0
    800021b4:	00000097          	auipc	ra,0x0
    800021b8:	e1a080e7          	jalr	-486(ra) # 80001fce <argint>
    return -1;
    800021bc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021be:	06054663          	bltz	a0,8000222a <sys_sleep+0x92>
  acquire(&tickslock);
    800021c2:	00012517          	auipc	a0,0x12
    800021c6:	8be50513          	addi	a0,a0,-1858 # 80013a80 <tickslock>
    800021ca:	00004097          	auipc	ra,0x4
    800021ce:	07a080e7          	jalr	122(ra) # 80006244 <acquire>
  ticks0 = ticks;
    800021d2:	00007917          	auipc	s2,0x7
    800021d6:	e4692903          	lw	s2,-442(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021da:	fcc42783          	lw	a5,-52(s0)
    800021de:	cf8d                	beqz	a5,80002218 <sys_sleep+0x80>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021e0:	00012997          	auipc	s3,0x12
    800021e4:	8a098993          	addi	s3,s3,-1888 # 80013a80 <tickslock>
    800021e8:	00007497          	auipc	s1,0x7
    800021ec:	e3048493          	addi	s1,s1,-464 # 80009018 <ticks>
    if(myproc()->killed){
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	c5a080e7          	jalr	-934(ra) # 80000e4a <myproc>
    800021f8:	15852783          	lw	a5,344(a0)
    800021fc:	ef9d                	bnez	a5,8000223a <sys_sleep+0xa2>
    sleep(&ticks, &tickslock);
    800021fe:	85ce                	mv	a1,s3
    80002200:	8526                	mv	a0,s1
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	332080e7          	jalr	818(ra) # 80001534 <sleep>
  while(ticks - ticks0 < n){
    8000220a:	409c                	lw	a5,0(s1)
    8000220c:	412787bb          	subw	a5,a5,s2
    80002210:	fcc42703          	lw	a4,-52(s0)
    80002214:	fce7eee3          	bltu	a5,a4,800021f0 <sys_sleep+0x58>
  }
  release(&tickslock);
    80002218:	00012517          	auipc	a0,0x12
    8000221c:	86850513          	addi	a0,a0,-1944 # 80013a80 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	0d8080e7          	jalr	216(ra) # 800062f8 <release>
  return 0;
    80002228:	4781                	li	a5,0
}
    8000222a:	853e                	mv	a0,a5
    8000222c:	70e2                	ld	ra,56(sp)
    8000222e:	7442                	ld	s0,48(sp)
    80002230:	74a2                	ld	s1,40(sp)
    80002232:	7902                	ld	s2,32(sp)
    80002234:	69e2                	ld	s3,24(sp)
    80002236:	6121                	addi	sp,sp,64
    80002238:	8082                	ret
      release(&tickslock);
    8000223a:	00012517          	auipc	a0,0x12
    8000223e:	84650513          	addi	a0,a0,-1978 # 80013a80 <tickslock>
    80002242:	00004097          	auipc	ra,0x4
    80002246:	0b6080e7          	jalr	182(ra) # 800062f8 <release>
      return -1;
    8000224a:	57fd                	li	a5,-1
    8000224c:	bff9                	j	8000222a <sys_sleep+0x92>

000000008000224e <sys_kill>:

uint64
sys_kill(void)
{
    8000224e:	1101                	addi	sp,sp,-32
    80002250:	ec06                	sd	ra,24(sp)
    80002252:	e822                	sd	s0,16(sp)
    80002254:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002256:	fec40593          	addi	a1,s0,-20
    8000225a:	4501                	li	a0,0
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	d72080e7          	jalr	-654(ra) # 80001fce <argint>
    80002264:	87aa                	mv	a5,a0
    return -1;
    80002266:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002268:	0007c863          	bltz	a5,80002278 <sys_kill+0x2a>
  return kill(pid);
    8000226c:	fec42503          	lw	a0,-20(s0)
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	604080e7          	jalr	1540(ra) # 80001874 <kill>
}
    80002278:	60e2                	ld	ra,24(sp)
    8000227a:	6442                	ld	s0,16(sp)
    8000227c:	6105                	addi	sp,sp,32
    8000227e:	8082                	ret

0000000080002280 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002280:	1101                	addi	sp,sp,-32
    80002282:	ec06                	sd	ra,24(sp)
    80002284:	e822                	sd	s0,16(sp)
    80002286:	e426                	sd	s1,8(sp)
    80002288:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000228a:	00011517          	auipc	a0,0x11
    8000228e:	7f650513          	addi	a0,a0,2038 # 80013a80 <tickslock>
    80002292:	00004097          	auipc	ra,0x4
    80002296:	fb2080e7          	jalr	-78(ra) # 80006244 <acquire>
  xticks = ticks;
    8000229a:	00007497          	auipc	s1,0x7
    8000229e:	d7e4a483          	lw	s1,-642(s1) # 80009018 <ticks>
  release(&tickslock);
    800022a2:	00011517          	auipc	a0,0x11
    800022a6:	7de50513          	addi	a0,a0,2014 # 80013a80 <tickslock>
    800022aa:	00004097          	auipc	ra,0x4
    800022ae:	04e080e7          	jalr	78(ra) # 800062f8 <release>
  return xticks;
}
    800022b2:	02049513          	slli	a0,s1,0x20
    800022b6:	9101                	srli	a0,a0,0x20
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	64a2                	ld	s1,8(sp)
    800022be:	6105                	addi	sp,sp,32
    800022c0:	8082                	ret

00000000800022c2 <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    800022c2:	1141                	addi	sp,sp,-16
    800022c4:	e406                	sd	ra,8(sp)
    800022c6:	e022                	sd	s0,0(sp)
    800022c8:	0800                	addi	s0,sp,16
  struct proc* proc = myproc();
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	b80080e7          	jalr	-1152(ra) # 80000e4a <myproc>
  // re-store trapframe so that it can return to the interrupt code before.
  *proc->trapframe = proc->saved_trapframe;
    800022d2:	02850793          	addi	a5,a0,40
    800022d6:	18853703          	ld	a4,392(a0)
    800022da:	14850693          	addi	a3,a0,328
    800022de:	0007b883          	ld	a7,0(a5)
    800022e2:	0087b803          	ld	a6,8(a5)
    800022e6:	6b8c                	ld	a1,16(a5)
    800022e8:	6f90                	ld	a2,24(a5)
    800022ea:	01173023          	sd	a7,0(a4)
    800022ee:	01073423          	sd	a6,8(a4)
    800022f2:	eb0c                	sd	a1,16(a4)
    800022f4:	ef10                	sd	a2,24(a4)
    800022f6:	02078793          	addi	a5,a5,32
    800022fa:	02070713          	addi	a4,a4,32
    800022fe:	fed790e3          	bne	a5,a3,800022de <sys_sigreturn+0x1c>
  proc->have_return = 1; // true
    80002302:	4785                	li	a5,1
    80002304:	14f52423          	sw	a5,328(a0)
  return proc->trapframe->a0;
    80002308:	18853783          	ld	a5,392(a0)
}
    8000230c:	7ba8                	ld	a0,112(a5)
    8000230e:	60a2                	ld	ra,8(sp)
    80002310:	6402                	ld	s0,0(sp)
    80002312:	0141                	addi	sp,sp,16
    80002314:	8082                	ret

0000000080002316 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    80002316:	1101                	addi	sp,sp,-32
    80002318:	ec06                	sd	ra,24(sp)
    8000231a:	e822                	sd	s0,16(sp)
    8000231c:	1000                	addi	s0,sp,32
  int ticks;
  uint64 handler_va;

  argint(0, &ticks);
    8000231e:	fec40593          	addi	a1,s0,-20
    80002322:	4501                	li	a0,0
    80002324:	00000097          	auipc	ra,0x0
    80002328:	caa080e7          	jalr	-854(ra) # 80001fce <argint>
  argaddr(1, &handler_va);
    8000232c:	fe040593          	addi	a1,s0,-32
    80002330:	4505                	li	a0,1
    80002332:	00000097          	auipc	ra,0x0
    80002336:	cbe080e7          	jalr	-834(ra) # 80001ff0 <argaddr>
  struct proc* proc = myproc();
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	b10080e7          	jalr	-1264(ra) # 80000e4a <myproc>
  proc->alarm_interval = ticks;
    80002342:	fec42783          	lw	a5,-20(s0)
    80002346:	d11c                	sw	a5,32(a0)
  proc->handler_va = handler_va;
    80002348:	fe043783          	ld	a5,-32(s0)
    8000234c:	ed1c                	sd	a5,24(a0)
  proc->have_return = 1; // true
    8000234e:	4785                	li	a5,1
    80002350:	14f52423          	sw	a5,328(a0)
  return 0;
}
    80002354:	4501                	li	a0,0
    80002356:	60e2                	ld	ra,24(sp)
    80002358:	6442                	ld	s0,16(sp)
    8000235a:	6105                	addi	sp,sp,32
    8000235c:	8082                	ret

000000008000235e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000235e:	7179                	addi	sp,sp,-48
    80002360:	f406                	sd	ra,40(sp)
    80002362:	f022                	sd	s0,32(sp)
    80002364:	ec26                	sd	s1,24(sp)
    80002366:	e84a                	sd	s2,16(sp)
    80002368:	e44e                	sd	s3,8(sp)
    8000236a:	e052                	sd	s4,0(sp)
    8000236c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000236e:	00006597          	auipc	a1,0x6
    80002372:	11a58593          	addi	a1,a1,282 # 80008488 <syscalls+0xc0>
    80002376:	00011517          	auipc	a0,0x11
    8000237a:	72250513          	addi	a0,a0,1826 # 80013a98 <bcache>
    8000237e:	00004097          	auipc	ra,0x4
    80002382:	e36080e7          	jalr	-458(ra) # 800061b4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002386:	00019797          	auipc	a5,0x19
    8000238a:	71278793          	addi	a5,a5,1810 # 8001ba98 <bcache+0x8000>
    8000238e:	0001a717          	auipc	a4,0x1a
    80002392:	97270713          	addi	a4,a4,-1678 # 8001bd00 <bcache+0x8268>
    80002396:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000239a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000239e:	00011497          	auipc	s1,0x11
    800023a2:	71248493          	addi	s1,s1,1810 # 80013ab0 <bcache+0x18>
    b->next = bcache.head.next;
    800023a6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023a8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023aa:	00006a17          	auipc	s4,0x6
    800023ae:	0e6a0a13          	addi	s4,s4,230 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023b2:	2b893783          	ld	a5,696(s2)
    800023b6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023b8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023bc:	85d2                	mv	a1,s4
    800023be:	01048513          	addi	a0,s1,16
    800023c2:	00001097          	auipc	ra,0x1
    800023c6:	4bc080e7          	jalr	1212(ra) # 8000387e <initsleeplock>
    bcache.head.next->prev = b;
    800023ca:	2b893783          	ld	a5,696(s2)
    800023ce:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023d0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023d4:	45848493          	addi	s1,s1,1112
    800023d8:	fd349de3          	bne	s1,s3,800023b2 <binit+0x54>
  }
}
    800023dc:	70a2                	ld	ra,40(sp)
    800023de:	7402                	ld	s0,32(sp)
    800023e0:	64e2                	ld	s1,24(sp)
    800023e2:	6942                	ld	s2,16(sp)
    800023e4:	69a2                	ld	s3,8(sp)
    800023e6:	6a02                	ld	s4,0(sp)
    800023e8:	6145                	addi	sp,sp,48
    800023ea:	8082                	ret

00000000800023ec <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023ec:	7179                	addi	sp,sp,-48
    800023ee:	f406                	sd	ra,40(sp)
    800023f0:	f022                	sd	s0,32(sp)
    800023f2:	ec26                	sd	s1,24(sp)
    800023f4:	e84a                	sd	s2,16(sp)
    800023f6:	e44e                	sd	s3,8(sp)
    800023f8:	1800                	addi	s0,sp,48
    800023fa:	89aa                	mv	s3,a0
    800023fc:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023fe:	00011517          	auipc	a0,0x11
    80002402:	69a50513          	addi	a0,a0,1690 # 80013a98 <bcache>
    80002406:	00004097          	auipc	ra,0x4
    8000240a:	e3e080e7          	jalr	-450(ra) # 80006244 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000240e:	0001a497          	auipc	s1,0x1a
    80002412:	9424b483          	ld	s1,-1726(s1) # 8001bd50 <bcache+0x82b8>
    80002416:	0001a797          	auipc	a5,0x1a
    8000241a:	8ea78793          	addi	a5,a5,-1814 # 8001bd00 <bcache+0x8268>
    8000241e:	02f48f63          	beq	s1,a5,8000245c <bread+0x70>
    80002422:	873e                	mv	a4,a5
    80002424:	a021                	j	8000242c <bread+0x40>
    80002426:	68a4                	ld	s1,80(s1)
    80002428:	02e48a63          	beq	s1,a4,8000245c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000242c:	449c                	lw	a5,8(s1)
    8000242e:	ff379ce3          	bne	a5,s3,80002426 <bread+0x3a>
    80002432:	44dc                	lw	a5,12(s1)
    80002434:	ff2799e3          	bne	a5,s2,80002426 <bread+0x3a>
      b->refcnt++;
    80002438:	40bc                	lw	a5,64(s1)
    8000243a:	2785                	addiw	a5,a5,1
    8000243c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000243e:	00011517          	auipc	a0,0x11
    80002442:	65a50513          	addi	a0,a0,1626 # 80013a98 <bcache>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	eb2080e7          	jalr	-334(ra) # 800062f8 <release>
      acquiresleep(&b->lock);
    8000244e:	01048513          	addi	a0,s1,16
    80002452:	00001097          	auipc	ra,0x1
    80002456:	466080e7          	jalr	1126(ra) # 800038b8 <acquiresleep>
      return b;
    8000245a:	a8b9                	j	800024b8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000245c:	0001a497          	auipc	s1,0x1a
    80002460:	8ec4b483          	ld	s1,-1812(s1) # 8001bd48 <bcache+0x82b0>
    80002464:	0001a797          	auipc	a5,0x1a
    80002468:	89c78793          	addi	a5,a5,-1892 # 8001bd00 <bcache+0x8268>
    8000246c:	00f48863          	beq	s1,a5,8000247c <bread+0x90>
    80002470:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002472:	40bc                	lw	a5,64(s1)
    80002474:	cf81                	beqz	a5,8000248c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002476:	64a4                	ld	s1,72(s1)
    80002478:	fee49de3          	bne	s1,a4,80002472 <bread+0x86>
  panic("bget: no buffers");
    8000247c:	00006517          	auipc	a0,0x6
    80002480:	01c50513          	addi	a0,a0,28 # 80008498 <syscalls+0xd0>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	826080e7          	jalr	-2010(ra) # 80005caa <panic>
      b->dev = dev;
    8000248c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002490:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002494:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002498:	4785                	li	a5,1
    8000249a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000249c:	00011517          	auipc	a0,0x11
    800024a0:	5fc50513          	addi	a0,a0,1532 # 80013a98 <bcache>
    800024a4:	00004097          	auipc	ra,0x4
    800024a8:	e54080e7          	jalr	-428(ra) # 800062f8 <release>
      acquiresleep(&b->lock);
    800024ac:	01048513          	addi	a0,s1,16
    800024b0:	00001097          	auipc	ra,0x1
    800024b4:	408080e7          	jalr	1032(ra) # 800038b8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024b8:	409c                	lw	a5,0(s1)
    800024ba:	cb89                	beqz	a5,800024cc <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024bc:	8526                	mv	a0,s1
    800024be:	70a2                	ld	ra,40(sp)
    800024c0:	7402                	ld	s0,32(sp)
    800024c2:	64e2                	ld	s1,24(sp)
    800024c4:	6942                	ld	s2,16(sp)
    800024c6:	69a2                	ld	s3,8(sp)
    800024c8:	6145                	addi	sp,sp,48
    800024ca:	8082                	ret
    virtio_disk_rw(b, 0);
    800024cc:	4581                	li	a1,0
    800024ce:	8526                	mv	a0,s1
    800024d0:	00003097          	auipc	ra,0x3
    800024d4:	f16080e7          	jalr	-234(ra) # 800053e6 <virtio_disk_rw>
    b->valid = 1;
    800024d8:	4785                	li	a5,1
    800024da:	c09c                	sw	a5,0(s1)
  return b;
    800024dc:	b7c5                	j	800024bc <bread+0xd0>

00000000800024de <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	1000                	addi	s0,sp,32
    800024e8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ea:	0541                	addi	a0,a0,16
    800024ec:	00001097          	auipc	ra,0x1
    800024f0:	468080e7          	jalr	1128(ra) # 80003954 <holdingsleep>
    800024f4:	cd01                	beqz	a0,8000250c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024f6:	4585                	li	a1,1
    800024f8:	8526                	mv	a0,s1
    800024fa:	00003097          	auipc	ra,0x3
    800024fe:	eec080e7          	jalr	-276(ra) # 800053e6 <virtio_disk_rw>
}
    80002502:	60e2                	ld	ra,24(sp)
    80002504:	6442                	ld	s0,16(sp)
    80002506:	64a2                	ld	s1,8(sp)
    80002508:	6105                	addi	sp,sp,32
    8000250a:	8082                	ret
    panic("bwrite");
    8000250c:	00006517          	auipc	a0,0x6
    80002510:	fa450513          	addi	a0,a0,-92 # 800084b0 <syscalls+0xe8>
    80002514:	00003097          	auipc	ra,0x3
    80002518:	796080e7          	jalr	1942(ra) # 80005caa <panic>

000000008000251c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000251c:	1101                	addi	sp,sp,-32
    8000251e:	ec06                	sd	ra,24(sp)
    80002520:	e822                	sd	s0,16(sp)
    80002522:	e426                	sd	s1,8(sp)
    80002524:	e04a                	sd	s2,0(sp)
    80002526:	1000                	addi	s0,sp,32
    80002528:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000252a:	01050913          	addi	s2,a0,16
    8000252e:	854a                	mv	a0,s2
    80002530:	00001097          	auipc	ra,0x1
    80002534:	424080e7          	jalr	1060(ra) # 80003954 <holdingsleep>
    80002538:	c92d                	beqz	a0,800025aa <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000253a:	854a                	mv	a0,s2
    8000253c:	00001097          	auipc	ra,0x1
    80002540:	3d4080e7          	jalr	980(ra) # 80003910 <releasesleep>

  acquire(&bcache.lock);
    80002544:	00011517          	auipc	a0,0x11
    80002548:	55450513          	addi	a0,a0,1364 # 80013a98 <bcache>
    8000254c:	00004097          	auipc	ra,0x4
    80002550:	cf8080e7          	jalr	-776(ra) # 80006244 <acquire>
  b->refcnt--;
    80002554:	40bc                	lw	a5,64(s1)
    80002556:	37fd                	addiw	a5,a5,-1
    80002558:	0007871b          	sext.w	a4,a5
    8000255c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000255e:	eb05                	bnez	a4,8000258e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002560:	68bc                	ld	a5,80(s1)
    80002562:	64b8                	ld	a4,72(s1)
    80002564:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002566:	64bc                	ld	a5,72(s1)
    80002568:	68b8                	ld	a4,80(s1)
    8000256a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000256c:	00019797          	auipc	a5,0x19
    80002570:	52c78793          	addi	a5,a5,1324 # 8001ba98 <bcache+0x8000>
    80002574:	2b87b703          	ld	a4,696(a5)
    80002578:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000257a:	00019717          	auipc	a4,0x19
    8000257e:	78670713          	addi	a4,a4,1926 # 8001bd00 <bcache+0x8268>
    80002582:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002584:	2b87b703          	ld	a4,696(a5)
    80002588:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000258a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000258e:	00011517          	auipc	a0,0x11
    80002592:	50a50513          	addi	a0,a0,1290 # 80013a98 <bcache>
    80002596:	00004097          	auipc	ra,0x4
    8000259a:	d62080e7          	jalr	-670(ra) # 800062f8 <release>
}
    8000259e:	60e2                	ld	ra,24(sp)
    800025a0:	6442                	ld	s0,16(sp)
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	6902                	ld	s2,0(sp)
    800025a6:	6105                	addi	sp,sp,32
    800025a8:	8082                	ret
    panic("brelse");
    800025aa:	00006517          	auipc	a0,0x6
    800025ae:	f0e50513          	addi	a0,a0,-242 # 800084b8 <syscalls+0xf0>
    800025b2:	00003097          	auipc	ra,0x3
    800025b6:	6f8080e7          	jalr	1784(ra) # 80005caa <panic>

00000000800025ba <bpin>:

void
bpin(struct buf *b) {
    800025ba:	1101                	addi	sp,sp,-32
    800025bc:	ec06                	sd	ra,24(sp)
    800025be:	e822                	sd	s0,16(sp)
    800025c0:	e426                	sd	s1,8(sp)
    800025c2:	1000                	addi	s0,sp,32
    800025c4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c6:	00011517          	auipc	a0,0x11
    800025ca:	4d250513          	addi	a0,a0,1234 # 80013a98 <bcache>
    800025ce:	00004097          	auipc	ra,0x4
    800025d2:	c76080e7          	jalr	-906(ra) # 80006244 <acquire>
  b->refcnt++;
    800025d6:	40bc                	lw	a5,64(s1)
    800025d8:	2785                	addiw	a5,a5,1
    800025da:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025dc:	00011517          	auipc	a0,0x11
    800025e0:	4bc50513          	addi	a0,a0,1212 # 80013a98 <bcache>
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	d14080e7          	jalr	-748(ra) # 800062f8 <release>
}
    800025ec:	60e2                	ld	ra,24(sp)
    800025ee:	6442                	ld	s0,16(sp)
    800025f0:	64a2                	ld	s1,8(sp)
    800025f2:	6105                	addi	sp,sp,32
    800025f4:	8082                	ret

00000000800025f6 <bunpin>:

void
bunpin(struct buf *b) {
    800025f6:	1101                	addi	sp,sp,-32
    800025f8:	ec06                	sd	ra,24(sp)
    800025fa:	e822                	sd	s0,16(sp)
    800025fc:	e426                	sd	s1,8(sp)
    800025fe:	1000                	addi	s0,sp,32
    80002600:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002602:	00011517          	auipc	a0,0x11
    80002606:	49650513          	addi	a0,a0,1174 # 80013a98 <bcache>
    8000260a:	00004097          	auipc	ra,0x4
    8000260e:	c3a080e7          	jalr	-966(ra) # 80006244 <acquire>
  b->refcnt--;
    80002612:	40bc                	lw	a5,64(s1)
    80002614:	37fd                	addiw	a5,a5,-1
    80002616:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002618:	00011517          	auipc	a0,0x11
    8000261c:	48050513          	addi	a0,a0,1152 # 80013a98 <bcache>
    80002620:	00004097          	auipc	ra,0x4
    80002624:	cd8080e7          	jalr	-808(ra) # 800062f8 <release>
}
    80002628:	60e2                	ld	ra,24(sp)
    8000262a:	6442                	ld	s0,16(sp)
    8000262c:	64a2                	ld	s1,8(sp)
    8000262e:	6105                	addi	sp,sp,32
    80002630:	8082                	ret

0000000080002632 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002632:	1101                	addi	sp,sp,-32
    80002634:	ec06                	sd	ra,24(sp)
    80002636:	e822                	sd	s0,16(sp)
    80002638:	e426                	sd	s1,8(sp)
    8000263a:	e04a                	sd	s2,0(sp)
    8000263c:	1000                	addi	s0,sp,32
    8000263e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002640:	00d5d59b          	srliw	a1,a1,0xd
    80002644:	0001a797          	auipc	a5,0x1a
    80002648:	b307a783          	lw	a5,-1232(a5) # 8001c174 <sb+0x1c>
    8000264c:	9dbd                	addw	a1,a1,a5
    8000264e:	00000097          	auipc	ra,0x0
    80002652:	d9e080e7          	jalr	-610(ra) # 800023ec <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002656:	0074f713          	andi	a4,s1,7
    8000265a:	4785                	li	a5,1
    8000265c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002660:	14ce                	slli	s1,s1,0x33
    80002662:	90d9                	srli	s1,s1,0x36
    80002664:	00950733          	add	a4,a0,s1
    80002668:	05874703          	lbu	a4,88(a4)
    8000266c:	00e7f6b3          	and	a3,a5,a4
    80002670:	c69d                	beqz	a3,8000269e <bfree+0x6c>
    80002672:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002674:	94aa                	add	s1,s1,a0
    80002676:	fff7c793          	not	a5,a5
    8000267a:	8ff9                	and	a5,a5,a4
    8000267c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002680:	00001097          	auipc	ra,0x1
    80002684:	118080e7          	jalr	280(ra) # 80003798 <log_write>
  brelse(bp);
    80002688:	854a                	mv	a0,s2
    8000268a:	00000097          	auipc	ra,0x0
    8000268e:	e92080e7          	jalr	-366(ra) # 8000251c <brelse>
}
    80002692:	60e2                	ld	ra,24(sp)
    80002694:	6442                	ld	s0,16(sp)
    80002696:	64a2                	ld	s1,8(sp)
    80002698:	6902                	ld	s2,0(sp)
    8000269a:	6105                	addi	sp,sp,32
    8000269c:	8082                	ret
    panic("freeing free block");
    8000269e:	00006517          	auipc	a0,0x6
    800026a2:	e2250513          	addi	a0,a0,-478 # 800084c0 <syscalls+0xf8>
    800026a6:	00003097          	auipc	ra,0x3
    800026aa:	604080e7          	jalr	1540(ra) # 80005caa <panic>

00000000800026ae <balloc>:
{
    800026ae:	711d                	addi	sp,sp,-96
    800026b0:	ec86                	sd	ra,88(sp)
    800026b2:	e8a2                	sd	s0,80(sp)
    800026b4:	e4a6                	sd	s1,72(sp)
    800026b6:	e0ca                	sd	s2,64(sp)
    800026b8:	fc4e                	sd	s3,56(sp)
    800026ba:	f852                	sd	s4,48(sp)
    800026bc:	f456                	sd	s5,40(sp)
    800026be:	f05a                	sd	s6,32(sp)
    800026c0:	ec5e                	sd	s7,24(sp)
    800026c2:	e862                	sd	s8,16(sp)
    800026c4:	e466                	sd	s9,8(sp)
    800026c6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026c8:	0001a797          	auipc	a5,0x1a
    800026cc:	a947a783          	lw	a5,-1388(a5) # 8001c15c <sb+0x4>
    800026d0:	cbd1                	beqz	a5,80002764 <balloc+0xb6>
    800026d2:	8baa                	mv	s7,a0
    800026d4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026d6:	0001ab17          	auipc	s6,0x1a
    800026da:	a82b0b13          	addi	s6,s6,-1406 # 8001c158 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026de:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026e0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026e2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026e4:	6c89                	lui	s9,0x2
    800026e6:	a831                	j	80002702 <balloc+0x54>
    brelse(bp);
    800026e8:	854a                	mv	a0,s2
    800026ea:	00000097          	auipc	ra,0x0
    800026ee:	e32080e7          	jalr	-462(ra) # 8000251c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026f2:	015c87bb          	addw	a5,s9,s5
    800026f6:	00078a9b          	sext.w	s5,a5
    800026fa:	004b2703          	lw	a4,4(s6)
    800026fe:	06eaf363          	bgeu	s5,a4,80002764 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002702:	41fad79b          	sraiw	a5,s5,0x1f
    80002706:	0137d79b          	srliw	a5,a5,0x13
    8000270a:	015787bb          	addw	a5,a5,s5
    8000270e:	40d7d79b          	sraiw	a5,a5,0xd
    80002712:	01cb2583          	lw	a1,28(s6)
    80002716:	9dbd                	addw	a1,a1,a5
    80002718:	855e                	mv	a0,s7
    8000271a:	00000097          	auipc	ra,0x0
    8000271e:	cd2080e7          	jalr	-814(ra) # 800023ec <bread>
    80002722:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002724:	004b2503          	lw	a0,4(s6)
    80002728:	000a849b          	sext.w	s1,s5
    8000272c:	8662                	mv	a2,s8
    8000272e:	faa4fde3          	bgeu	s1,a0,800026e8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002732:	41f6579b          	sraiw	a5,a2,0x1f
    80002736:	01d7d69b          	srliw	a3,a5,0x1d
    8000273a:	00c6873b          	addw	a4,a3,a2
    8000273e:	00777793          	andi	a5,a4,7
    80002742:	9f95                	subw	a5,a5,a3
    80002744:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002748:	4037571b          	sraiw	a4,a4,0x3
    8000274c:	00e906b3          	add	a3,s2,a4
    80002750:	0586c683          	lbu	a3,88(a3)
    80002754:	00d7f5b3          	and	a1,a5,a3
    80002758:	cd91                	beqz	a1,80002774 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275a:	2605                	addiw	a2,a2,1
    8000275c:	2485                	addiw	s1,s1,1
    8000275e:	fd4618e3          	bne	a2,s4,8000272e <balloc+0x80>
    80002762:	b759                	j	800026e8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002764:	00006517          	auipc	a0,0x6
    80002768:	d7450513          	addi	a0,a0,-652 # 800084d8 <syscalls+0x110>
    8000276c:	00003097          	auipc	ra,0x3
    80002770:	53e080e7          	jalr	1342(ra) # 80005caa <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002774:	974a                	add	a4,a4,s2
    80002776:	8fd5                	or	a5,a5,a3
    80002778:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000277c:	854a                	mv	a0,s2
    8000277e:	00001097          	auipc	ra,0x1
    80002782:	01a080e7          	jalr	26(ra) # 80003798 <log_write>
        brelse(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00000097          	auipc	ra,0x0
    8000278c:	d94080e7          	jalr	-620(ra) # 8000251c <brelse>
  bp = bread(dev, bno);
    80002790:	85a6                	mv	a1,s1
    80002792:	855e                	mv	a0,s7
    80002794:	00000097          	auipc	ra,0x0
    80002798:	c58080e7          	jalr	-936(ra) # 800023ec <bread>
    8000279c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000279e:	40000613          	li	a2,1024
    800027a2:	4581                	li	a1,0
    800027a4:	05850513          	addi	a0,a0,88
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	9d0080e7          	jalr	-1584(ra) # 80000178 <memset>
  log_write(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	00001097          	auipc	ra,0x1
    800027b6:	fe6080e7          	jalr	-26(ra) # 80003798 <log_write>
  brelse(bp);
    800027ba:	854a                	mv	a0,s2
    800027bc:	00000097          	auipc	ra,0x0
    800027c0:	d60080e7          	jalr	-672(ra) # 8000251c <brelse>
}
    800027c4:	8526                	mv	a0,s1
    800027c6:	60e6                	ld	ra,88(sp)
    800027c8:	6446                	ld	s0,80(sp)
    800027ca:	64a6                	ld	s1,72(sp)
    800027cc:	6906                	ld	s2,64(sp)
    800027ce:	79e2                	ld	s3,56(sp)
    800027d0:	7a42                	ld	s4,48(sp)
    800027d2:	7aa2                	ld	s5,40(sp)
    800027d4:	7b02                	ld	s6,32(sp)
    800027d6:	6be2                	ld	s7,24(sp)
    800027d8:	6c42                	ld	s8,16(sp)
    800027da:	6ca2                	ld	s9,8(sp)
    800027dc:	6125                	addi	sp,sp,96
    800027de:	8082                	ret

00000000800027e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027e0:	7179                	addi	sp,sp,-48
    800027e2:	f406                	sd	ra,40(sp)
    800027e4:	f022                	sd	s0,32(sp)
    800027e6:	ec26                	sd	s1,24(sp)
    800027e8:	e84a                	sd	s2,16(sp)
    800027ea:	e44e                	sd	s3,8(sp)
    800027ec:	e052                	sd	s4,0(sp)
    800027ee:	1800                	addi	s0,sp,48
    800027f0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027f2:	47ad                	li	a5,11
    800027f4:	04b7fe63          	bgeu	a5,a1,80002850 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027f8:	ff45849b          	addiw	s1,a1,-12
    800027fc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002800:	0ff00793          	li	a5,255
    80002804:	0ae7e363          	bltu	a5,a4,800028aa <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002808:	08052583          	lw	a1,128(a0)
    8000280c:	c5ad                	beqz	a1,80002876 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000280e:	00092503          	lw	a0,0(s2)
    80002812:	00000097          	auipc	ra,0x0
    80002816:	bda080e7          	jalr	-1062(ra) # 800023ec <bread>
    8000281a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000281c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002820:	02049593          	slli	a1,s1,0x20
    80002824:	9181                	srli	a1,a1,0x20
    80002826:	058a                	slli	a1,a1,0x2
    80002828:	00b784b3          	add	s1,a5,a1
    8000282c:	0004a983          	lw	s3,0(s1)
    80002830:	04098d63          	beqz	s3,8000288a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002834:	8552                	mv	a0,s4
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	ce6080e7          	jalr	-794(ra) # 8000251c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000283e:	854e                	mv	a0,s3
    80002840:	70a2                	ld	ra,40(sp)
    80002842:	7402                	ld	s0,32(sp)
    80002844:	64e2                	ld	s1,24(sp)
    80002846:	6942                	ld	s2,16(sp)
    80002848:	69a2                	ld	s3,8(sp)
    8000284a:	6a02                	ld	s4,0(sp)
    8000284c:	6145                	addi	sp,sp,48
    8000284e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002850:	02059493          	slli	s1,a1,0x20
    80002854:	9081                	srli	s1,s1,0x20
    80002856:	048a                	slli	s1,s1,0x2
    80002858:	94aa                	add	s1,s1,a0
    8000285a:	0504a983          	lw	s3,80(s1)
    8000285e:	fe0990e3          	bnez	s3,8000283e <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002862:	4108                	lw	a0,0(a0)
    80002864:	00000097          	auipc	ra,0x0
    80002868:	e4a080e7          	jalr	-438(ra) # 800026ae <balloc>
    8000286c:	0005099b          	sext.w	s3,a0
    80002870:	0534a823          	sw	s3,80(s1)
    80002874:	b7e9                	j	8000283e <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002876:	4108                	lw	a0,0(a0)
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	e36080e7          	jalr	-458(ra) # 800026ae <balloc>
    80002880:	0005059b          	sext.w	a1,a0
    80002884:	08b92023          	sw	a1,128(s2)
    80002888:	b759                	j	8000280e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000288a:	00092503          	lw	a0,0(s2)
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	e20080e7          	jalr	-480(ra) # 800026ae <balloc>
    80002896:	0005099b          	sext.w	s3,a0
    8000289a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000289e:	8552                	mv	a0,s4
    800028a0:	00001097          	auipc	ra,0x1
    800028a4:	ef8080e7          	jalr	-264(ra) # 80003798 <log_write>
    800028a8:	b771                	j	80002834 <bmap+0x54>
  panic("bmap: out of range");
    800028aa:	00006517          	auipc	a0,0x6
    800028ae:	c4650513          	addi	a0,a0,-954 # 800084f0 <syscalls+0x128>
    800028b2:	00003097          	auipc	ra,0x3
    800028b6:	3f8080e7          	jalr	1016(ra) # 80005caa <panic>

00000000800028ba <iget>:
{
    800028ba:	7179                	addi	sp,sp,-48
    800028bc:	f406                	sd	ra,40(sp)
    800028be:	f022                	sd	s0,32(sp)
    800028c0:	ec26                	sd	s1,24(sp)
    800028c2:	e84a                	sd	s2,16(sp)
    800028c4:	e44e                	sd	s3,8(sp)
    800028c6:	e052                	sd	s4,0(sp)
    800028c8:	1800                	addi	s0,sp,48
    800028ca:	89aa                	mv	s3,a0
    800028cc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028ce:	0001a517          	auipc	a0,0x1a
    800028d2:	8aa50513          	addi	a0,a0,-1878 # 8001c178 <itable>
    800028d6:	00004097          	auipc	ra,0x4
    800028da:	96e080e7          	jalr	-1682(ra) # 80006244 <acquire>
  empty = 0;
    800028de:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028e0:	0001a497          	auipc	s1,0x1a
    800028e4:	8b048493          	addi	s1,s1,-1872 # 8001c190 <itable+0x18>
    800028e8:	0001b697          	auipc	a3,0x1b
    800028ec:	33868693          	addi	a3,a3,824 # 8001dc20 <log>
    800028f0:	a039                	j	800028fe <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028f2:	02090b63          	beqz	s2,80002928 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028f6:	08848493          	addi	s1,s1,136
    800028fa:	02d48a63          	beq	s1,a3,8000292e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028fe:	449c                	lw	a5,8(s1)
    80002900:	fef059e3          	blez	a5,800028f2 <iget+0x38>
    80002904:	4098                	lw	a4,0(s1)
    80002906:	ff3716e3          	bne	a4,s3,800028f2 <iget+0x38>
    8000290a:	40d8                	lw	a4,4(s1)
    8000290c:	ff4713e3          	bne	a4,s4,800028f2 <iget+0x38>
      ip->ref++;
    80002910:	2785                	addiw	a5,a5,1
    80002912:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002914:	0001a517          	auipc	a0,0x1a
    80002918:	86450513          	addi	a0,a0,-1948 # 8001c178 <itable>
    8000291c:	00004097          	auipc	ra,0x4
    80002920:	9dc080e7          	jalr	-1572(ra) # 800062f8 <release>
      return ip;
    80002924:	8926                	mv	s2,s1
    80002926:	a03d                	j	80002954 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002928:	f7f9                	bnez	a5,800028f6 <iget+0x3c>
    8000292a:	8926                	mv	s2,s1
    8000292c:	b7e9                	j	800028f6 <iget+0x3c>
  if(empty == 0)
    8000292e:	02090c63          	beqz	s2,80002966 <iget+0xac>
  ip->dev = dev;
    80002932:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002936:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000293a:	4785                	li	a5,1
    8000293c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002940:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002944:	0001a517          	auipc	a0,0x1a
    80002948:	83450513          	addi	a0,a0,-1996 # 8001c178 <itable>
    8000294c:	00004097          	auipc	ra,0x4
    80002950:	9ac080e7          	jalr	-1620(ra) # 800062f8 <release>
}
    80002954:	854a                	mv	a0,s2
    80002956:	70a2                	ld	ra,40(sp)
    80002958:	7402                	ld	s0,32(sp)
    8000295a:	64e2                	ld	s1,24(sp)
    8000295c:	6942                	ld	s2,16(sp)
    8000295e:	69a2                	ld	s3,8(sp)
    80002960:	6a02                	ld	s4,0(sp)
    80002962:	6145                	addi	sp,sp,48
    80002964:	8082                	ret
    panic("iget: no inodes");
    80002966:	00006517          	auipc	a0,0x6
    8000296a:	ba250513          	addi	a0,a0,-1118 # 80008508 <syscalls+0x140>
    8000296e:	00003097          	auipc	ra,0x3
    80002972:	33c080e7          	jalr	828(ra) # 80005caa <panic>

0000000080002976 <fsinit>:
fsinit(int dev) {
    80002976:	7179                	addi	sp,sp,-48
    80002978:	f406                	sd	ra,40(sp)
    8000297a:	f022                	sd	s0,32(sp)
    8000297c:	ec26                	sd	s1,24(sp)
    8000297e:	e84a                	sd	s2,16(sp)
    80002980:	e44e                	sd	s3,8(sp)
    80002982:	1800                	addi	s0,sp,48
    80002984:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002986:	4585                	li	a1,1
    80002988:	00000097          	auipc	ra,0x0
    8000298c:	a64080e7          	jalr	-1436(ra) # 800023ec <bread>
    80002990:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002992:	00019997          	auipc	s3,0x19
    80002996:	7c698993          	addi	s3,s3,1990 # 8001c158 <sb>
    8000299a:	02000613          	li	a2,32
    8000299e:	05850593          	addi	a1,a0,88
    800029a2:	854e                	mv	a0,s3
    800029a4:	ffffe097          	auipc	ra,0xffffe
    800029a8:	834080e7          	jalr	-1996(ra) # 800001d8 <memmove>
  brelse(bp);
    800029ac:	8526                	mv	a0,s1
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	b6e080e7          	jalr	-1170(ra) # 8000251c <brelse>
  if(sb.magic != FSMAGIC)
    800029b6:	0009a703          	lw	a4,0(s3)
    800029ba:	102037b7          	lui	a5,0x10203
    800029be:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029c2:	02f71263          	bne	a4,a5,800029e6 <fsinit+0x70>
  initlog(dev, &sb);
    800029c6:	00019597          	auipc	a1,0x19
    800029ca:	79258593          	addi	a1,a1,1938 # 8001c158 <sb>
    800029ce:	854a                	mv	a0,s2
    800029d0:	00001097          	auipc	ra,0x1
    800029d4:	b4c080e7          	jalr	-1204(ra) # 8000351c <initlog>
}
    800029d8:	70a2                	ld	ra,40(sp)
    800029da:	7402                	ld	s0,32(sp)
    800029dc:	64e2                	ld	s1,24(sp)
    800029de:	6942                	ld	s2,16(sp)
    800029e0:	69a2                	ld	s3,8(sp)
    800029e2:	6145                	addi	sp,sp,48
    800029e4:	8082                	ret
    panic("invalid file system");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	b3250513          	addi	a0,a0,-1230 # 80008518 <syscalls+0x150>
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	2bc080e7          	jalr	700(ra) # 80005caa <panic>

00000000800029f6 <iinit>:
{
    800029f6:	7179                	addi	sp,sp,-48
    800029f8:	f406                	sd	ra,40(sp)
    800029fa:	f022                	sd	s0,32(sp)
    800029fc:	ec26                	sd	s1,24(sp)
    800029fe:	e84a                	sd	s2,16(sp)
    80002a00:	e44e                	sd	s3,8(sp)
    80002a02:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a04:	00006597          	auipc	a1,0x6
    80002a08:	b2c58593          	addi	a1,a1,-1236 # 80008530 <syscalls+0x168>
    80002a0c:	00019517          	auipc	a0,0x19
    80002a10:	76c50513          	addi	a0,a0,1900 # 8001c178 <itable>
    80002a14:	00003097          	auipc	ra,0x3
    80002a18:	7a0080e7          	jalr	1952(ra) # 800061b4 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a1c:	00019497          	auipc	s1,0x19
    80002a20:	78448493          	addi	s1,s1,1924 # 8001c1a0 <itable+0x28>
    80002a24:	0001b997          	auipc	s3,0x1b
    80002a28:	20c98993          	addi	s3,s3,524 # 8001dc30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a2c:	00006917          	auipc	s2,0x6
    80002a30:	b0c90913          	addi	s2,s2,-1268 # 80008538 <syscalls+0x170>
    80002a34:	85ca                	mv	a1,s2
    80002a36:	8526                	mv	a0,s1
    80002a38:	00001097          	auipc	ra,0x1
    80002a3c:	e46080e7          	jalr	-442(ra) # 8000387e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a40:	08848493          	addi	s1,s1,136
    80002a44:	ff3498e3          	bne	s1,s3,80002a34 <iinit+0x3e>
}
    80002a48:	70a2                	ld	ra,40(sp)
    80002a4a:	7402                	ld	s0,32(sp)
    80002a4c:	64e2                	ld	s1,24(sp)
    80002a4e:	6942                	ld	s2,16(sp)
    80002a50:	69a2                	ld	s3,8(sp)
    80002a52:	6145                	addi	sp,sp,48
    80002a54:	8082                	ret

0000000080002a56 <ialloc>:
{
    80002a56:	715d                	addi	sp,sp,-80
    80002a58:	e486                	sd	ra,72(sp)
    80002a5a:	e0a2                	sd	s0,64(sp)
    80002a5c:	fc26                	sd	s1,56(sp)
    80002a5e:	f84a                	sd	s2,48(sp)
    80002a60:	f44e                	sd	s3,40(sp)
    80002a62:	f052                	sd	s4,32(sp)
    80002a64:	ec56                	sd	s5,24(sp)
    80002a66:	e85a                	sd	s6,16(sp)
    80002a68:	e45e                	sd	s7,8(sp)
    80002a6a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a6c:	00019717          	auipc	a4,0x19
    80002a70:	6f872703          	lw	a4,1784(a4) # 8001c164 <sb+0xc>
    80002a74:	4785                	li	a5,1
    80002a76:	04e7fa63          	bgeu	a5,a4,80002aca <ialloc+0x74>
    80002a7a:	8aaa                	mv	s5,a0
    80002a7c:	8bae                	mv	s7,a1
    80002a7e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a80:	00019a17          	auipc	s4,0x19
    80002a84:	6d8a0a13          	addi	s4,s4,1752 # 8001c158 <sb>
    80002a88:	00048b1b          	sext.w	s6,s1
    80002a8c:	0044d593          	srli	a1,s1,0x4
    80002a90:	018a2783          	lw	a5,24(s4)
    80002a94:	9dbd                	addw	a1,a1,a5
    80002a96:	8556                	mv	a0,s5
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	954080e7          	jalr	-1708(ra) # 800023ec <bread>
    80002aa0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aa2:	05850993          	addi	s3,a0,88
    80002aa6:	00f4f793          	andi	a5,s1,15
    80002aaa:	079a                	slli	a5,a5,0x6
    80002aac:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aae:	00099783          	lh	a5,0(s3)
    80002ab2:	c785                	beqz	a5,80002ada <ialloc+0x84>
    brelse(bp);
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	a68080e7          	jalr	-1432(ra) # 8000251c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002abc:	0485                	addi	s1,s1,1
    80002abe:	00ca2703          	lw	a4,12(s4)
    80002ac2:	0004879b          	sext.w	a5,s1
    80002ac6:	fce7e1e3          	bltu	a5,a4,80002a88 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002aca:	00006517          	auipc	a0,0x6
    80002ace:	a7650513          	addi	a0,a0,-1418 # 80008540 <syscalls+0x178>
    80002ad2:	00003097          	auipc	ra,0x3
    80002ad6:	1d8080e7          	jalr	472(ra) # 80005caa <panic>
      memset(dip, 0, sizeof(*dip));
    80002ada:	04000613          	li	a2,64
    80002ade:	4581                	li	a1,0
    80002ae0:	854e                	mv	a0,s3
    80002ae2:	ffffd097          	auipc	ra,0xffffd
    80002ae6:	696080e7          	jalr	1686(ra) # 80000178 <memset>
      dip->type = type;
    80002aea:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002aee:	854a                	mv	a0,s2
    80002af0:	00001097          	auipc	ra,0x1
    80002af4:	ca8080e7          	jalr	-856(ra) # 80003798 <log_write>
      brelse(bp);
    80002af8:	854a                	mv	a0,s2
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	a22080e7          	jalr	-1502(ra) # 8000251c <brelse>
      return iget(dev, inum);
    80002b02:	85da                	mv	a1,s6
    80002b04:	8556                	mv	a0,s5
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	db4080e7          	jalr	-588(ra) # 800028ba <iget>
}
    80002b0e:	60a6                	ld	ra,72(sp)
    80002b10:	6406                	ld	s0,64(sp)
    80002b12:	74e2                	ld	s1,56(sp)
    80002b14:	7942                	ld	s2,48(sp)
    80002b16:	79a2                	ld	s3,40(sp)
    80002b18:	7a02                	ld	s4,32(sp)
    80002b1a:	6ae2                	ld	s5,24(sp)
    80002b1c:	6b42                	ld	s6,16(sp)
    80002b1e:	6ba2                	ld	s7,8(sp)
    80002b20:	6161                	addi	sp,sp,80
    80002b22:	8082                	ret

0000000080002b24 <iupdate>:
{
    80002b24:	1101                	addi	sp,sp,-32
    80002b26:	ec06                	sd	ra,24(sp)
    80002b28:	e822                	sd	s0,16(sp)
    80002b2a:	e426                	sd	s1,8(sp)
    80002b2c:	e04a                	sd	s2,0(sp)
    80002b2e:	1000                	addi	s0,sp,32
    80002b30:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b32:	415c                	lw	a5,4(a0)
    80002b34:	0047d79b          	srliw	a5,a5,0x4
    80002b38:	00019597          	auipc	a1,0x19
    80002b3c:	6385a583          	lw	a1,1592(a1) # 8001c170 <sb+0x18>
    80002b40:	9dbd                	addw	a1,a1,a5
    80002b42:	4108                	lw	a0,0(a0)
    80002b44:	00000097          	auipc	ra,0x0
    80002b48:	8a8080e7          	jalr	-1880(ra) # 800023ec <bread>
    80002b4c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b4e:	05850793          	addi	a5,a0,88
    80002b52:	40c8                	lw	a0,4(s1)
    80002b54:	893d                	andi	a0,a0,15
    80002b56:	051a                	slli	a0,a0,0x6
    80002b58:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b5a:	04449703          	lh	a4,68(s1)
    80002b5e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b62:	04649703          	lh	a4,70(s1)
    80002b66:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b6a:	04849703          	lh	a4,72(s1)
    80002b6e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b72:	04a49703          	lh	a4,74(s1)
    80002b76:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b7a:	44f8                	lw	a4,76(s1)
    80002b7c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b7e:	03400613          	li	a2,52
    80002b82:	05048593          	addi	a1,s1,80
    80002b86:	0531                	addi	a0,a0,12
    80002b88:	ffffd097          	auipc	ra,0xffffd
    80002b8c:	650080e7          	jalr	1616(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b90:	854a                	mv	a0,s2
    80002b92:	00001097          	auipc	ra,0x1
    80002b96:	c06080e7          	jalr	-1018(ra) # 80003798 <log_write>
  brelse(bp);
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	980080e7          	jalr	-1664(ra) # 8000251c <brelse>
}
    80002ba4:	60e2                	ld	ra,24(sp)
    80002ba6:	6442                	ld	s0,16(sp)
    80002ba8:	64a2                	ld	s1,8(sp)
    80002baa:	6902                	ld	s2,0(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <idup>:
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	1000                	addi	s0,sp,32
    80002bba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bbc:	00019517          	auipc	a0,0x19
    80002bc0:	5bc50513          	addi	a0,a0,1468 # 8001c178 <itable>
    80002bc4:	00003097          	auipc	ra,0x3
    80002bc8:	680080e7          	jalr	1664(ra) # 80006244 <acquire>
  ip->ref++;
    80002bcc:	449c                	lw	a5,8(s1)
    80002bce:	2785                	addiw	a5,a5,1
    80002bd0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bd2:	00019517          	auipc	a0,0x19
    80002bd6:	5a650513          	addi	a0,a0,1446 # 8001c178 <itable>
    80002bda:	00003097          	auipc	ra,0x3
    80002bde:	71e080e7          	jalr	1822(ra) # 800062f8 <release>
}
    80002be2:	8526                	mv	a0,s1
    80002be4:	60e2                	ld	ra,24(sp)
    80002be6:	6442                	ld	s0,16(sp)
    80002be8:	64a2                	ld	s1,8(sp)
    80002bea:	6105                	addi	sp,sp,32
    80002bec:	8082                	ret

0000000080002bee <ilock>:
{
    80002bee:	1101                	addi	sp,sp,-32
    80002bf0:	ec06                	sd	ra,24(sp)
    80002bf2:	e822                	sd	s0,16(sp)
    80002bf4:	e426                	sd	s1,8(sp)
    80002bf6:	e04a                	sd	s2,0(sp)
    80002bf8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bfa:	c115                	beqz	a0,80002c1e <ilock+0x30>
    80002bfc:	84aa                	mv	s1,a0
    80002bfe:	451c                	lw	a5,8(a0)
    80002c00:	00f05f63          	blez	a5,80002c1e <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c04:	0541                	addi	a0,a0,16
    80002c06:	00001097          	auipc	ra,0x1
    80002c0a:	cb2080e7          	jalr	-846(ra) # 800038b8 <acquiresleep>
  if(ip->valid == 0){
    80002c0e:	40bc                	lw	a5,64(s1)
    80002c10:	cf99                	beqz	a5,80002c2e <ilock+0x40>
}
    80002c12:	60e2                	ld	ra,24(sp)
    80002c14:	6442                	ld	s0,16(sp)
    80002c16:	64a2                	ld	s1,8(sp)
    80002c18:	6902                	ld	s2,0(sp)
    80002c1a:	6105                	addi	sp,sp,32
    80002c1c:	8082                	ret
    panic("ilock");
    80002c1e:	00006517          	auipc	a0,0x6
    80002c22:	93a50513          	addi	a0,a0,-1734 # 80008558 <syscalls+0x190>
    80002c26:	00003097          	auipc	ra,0x3
    80002c2a:	084080e7          	jalr	132(ra) # 80005caa <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c2e:	40dc                	lw	a5,4(s1)
    80002c30:	0047d79b          	srliw	a5,a5,0x4
    80002c34:	00019597          	auipc	a1,0x19
    80002c38:	53c5a583          	lw	a1,1340(a1) # 8001c170 <sb+0x18>
    80002c3c:	9dbd                	addw	a1,a1,a5
    80002c3e:	4088                	lw	a0,0(s1)
    80002c40:	fffff097          	auipc	ra,0xfffff
    80002c44:	7ac080e7          	jalr	1964(ra) # 800023ec <bread>
    80002c48:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c4a:	05850593          	addi	a1,a0,88
    80002c4e:	40dc                	lw	a5,4(s1)
    80002c50:	8bbd                	andi	a5,a5,15
    80002c52:	079a                	slli	a5,a5,0x6
    80002c54:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c56:	00059783          	lh	a5,0(a1)
    80002c5a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c5e:	00259783          	lh	a5,2(a1)
    80002c62:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c66:	00459783          	lh	a5,4(a1)
    80002c6a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c6e:	00659783          	lh	a5,6(a1)
    80002c72:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c76:	459c                	lw	a5,8(a1)
    80002c78:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c7a:	03400613          	li	a2,52
    80002c7e:	05b1                	addi	a1,a1,12
    80002c80:	05048513          	addi	a0,s1,80
    80002c84:	ffffd097          	auipc	ra,0xffffd
    80002c88:	554080e7          	jalr	1364(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c8c:	854a                	mv	a0,s2
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	88e080e7          	jalr	-1906(ra) # 8000251c <brelse>
    ip->valid = 1;
    80002c96:	4785                	li	a5,1
    80002c98:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c9a:	04449783          	lh	a5,68(s1)
    80002c9e:	fbb5                	bnez	a5,80002c12 <ilock+0x24>
      panic("ilock: no type");
    80002ca0:	00006517          	auipc	a0,0x6
    80002ca4:	8c050513          	addi	a0,a0,-1856 # 80008560 <syscalls+0x198>
    80002ca8:	00003097          	auipc	ra,0x3
    80002cac:	002080e7          	jalr	2(ra) # 80005caa <panic>

0000000080002cb0 <iunlock>:
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	e04a                	sd	s2,0(sp)
    80002cba:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cbc:	c905                	beqz	a0,80002cec <iunlock+0x3c>
    80002cbe:	84aa                	mv	s1,a0
    80002cc0:	01050913          	addi	s2,a0,16
    80002cc4:	854a                	mv	a0,s2
    80002cc6:	00001097          	auipc	ra,0x1
    80002cca:	c8e080e7          	jalr	-882(ra) # 80003954 <holdingsleep>
    80002cce:	cd19                	beqz	a0,80002cec <iunlock+0x3c>
    80002cd0:	449c                	lw	a5,8(s1)
    80002cd2:	00f05d63          	blez	a5,80002cec <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cd6:	854a                	mv	a0,s2
    80002cd8:	00001097          	auipc	ra,0x1
    80002cdc:	c38080e7          	jalr	-968(ra) # 80003910 <releasesleep>
}
    80002ce0:	60e2                	ld	ra,24(sp)
    80002ce2:	6442                	ld	s0,16(sp)
    80002ce4:	64a2                	ld	s1,8(sp)
    80002ce6:	6902                	ld	s2,0(sp)
    80002ce8:	6105                	addi	sp,sp,32
    80002cea:	8082                	ret
    panic("iunlock");
    80002cec:	00006517          	auipc	a0,0x6
    80002cf0:	88450513          	addi	a0,a0,-1916 # 80008570 <syscalls+0x1a8>
    80002cf4:	00003097          	auipc	ra,0x3
    80002cf8:	fb6080e7          	jalr	-74(ra) # 80005caa <panic>

0000000080002cfc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cfc:	7179                	addi	sp,sp,-48
    80002cfe:	f406                	sd	ra,40(sp)
    80002d00:	f022                	sd	s0,32(sp)
    80002d02:	ec26                	sd	s1,24(sp)
    80002d04:	e84a                	sd	s2,16(sp)
    80002d06:	e44e                	sd	s3,8(sp)
    80002d08:	e052                	sd	s4,0(sp)
    80002d0a:	1800                	addi	s0,sp,48
    80002d0c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d0e:	05050493          	addi	s1,a0,80
    80002d12:	08050913          	addi	s2,a0,128
    80002d16:	a021                	j	80002d1e <itrunc+0x22>
    80002d18:	0491                	addi	s1,s1,4
    80002d1a:	01248d63          	beq	s1,s2,80002d34 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d1e:	408c                	lw	a1,0(s1)
    80002d20:	dde5                	beqz	a1,80002d18 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d22:	0009a503          	lw	a0,0(s3)
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	90c080e7          	jalr	-1780(ra) # 80002632 <bfree>
      ip->addrs[i] = 0;
    80002d2e:	0004a023          	sw	zero,0(s1)
    80002d32:	b7dd                	j	80002d18 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d34:	0809a583          	lw	a1,128(s3)
    80002d38:	e185                	bnez	a1,80002d58 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d3a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d3e:	854e                	mv	a0,s3
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	de4080e7          	jalr	-540(ra) # 80002b24 <iupdate>
}
    80002d48:	70a2                	ld	ra,40(sp)
    80002d4a:	7402                	ld	s0,32(sp)
    80002d4c:	64e2                	ld	s1,24(sp)
    80002d4e:	6942                	ld	s2,16(sp)
    80002d50:	69a2                	ld	s3,8(sp)
    80002d52:	6a02                	ld	s4,0(sp)
    80002d54:	6145                	addi	sp,sp,48
    80002d56:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d58:	0009a503          	lw	a0,0(s3)
    80002d5c:	fffff097          	auipc	ra,0xfffff
    80002d60:	690080e7          	jalr	1680(ra) # 800023ec <bread>
    80002d64:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d66:	05850493          	addi	s1,a0,88
    80002d6a:	45850913          	addi	s2,a0,1112
    80002d6e:	a811                	j	80002d82 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d70:	0009a503          	lw	a0,0(s3)
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	8be080e7          	jalr	-1858(ra) # 80002632 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d7c:	0491                	addi	s1,s1,4
    80002d7e:	01248563          	beq	s1,s2,80002d88 <itrunc+0x8c>
      if(a[j])
    80002d82:	408c                	lw	a1,0(s1)
    80002d84:	dde5                	beqz	a1,80002d7c <itrunc+0x80>
    80002d86:	b7ed                	j	80002d70 <itrunc+0x74>
    brelse(bp);
    80002d88:	8552                	mv	a0,s4
    80002d8a:	fffff097          	auipc	ra,0xfffff
    80002d8e:	792080e7          	jalr	1938(ra) # 8000251c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d92:	0809a583          	lw	a1,128(s3)
    80002d96:	0009a503          	lw	a0,0(s3)
    80002d9a:	00000097          	auipc	ra,0x0
    80002d9e:	898080e7          	jalr	-1896(ra) # 80002632 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002da2:	0809a023          	sw	zero,128(s3)
    80002da6:	bf51                	j	80002d3a <itrunc+0x3e>

0000000080002da8 <iput>:
{
    80002da8:	1101                	addi	sp,sp,-32
    80002daa:	ec06                	sd	ra,24(sp)
    80002dac:	e822                	sd	s0,16(sp)
    80002dae:	e426                	sd	s1,8(sp)
    80002db0:	e04a                	sd	s2,0(sp)
    80002db2:	1000                	addi	s0,sp,32
    80002db4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002db6:	00019517          	auipc	a0,0x19
    80002dba:	3c250513          	addi	a0,a0,962 # 8001c178 <itable>
    80002dbe:	00003097          	auipc	ra,0x3
    80002dc2:	486080e7          	jalr	1158(ra) # 80006244 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc6:	4498                	lw	a4,8(s1)
    80002dc8:	4785                	li	a5,1
    80002dca:	02f70363          	beq	a4,a5,80002df0 <iput+0x48>
  ip->ref--;
    80002dce:	449c                	lw	a5,8(s1)
    80002dd0:	37fd                	addiw	a5,a5,-1
    80002dd2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dd4:	00019517          	auipc	a0,0x19
    80002dd8:	3a450513          	addi	a0,a0,932 # 8001c178 <itable>
    80002ddc:	00003097          	auipc	ra,0x3
    80002de0:	51c080e7          	jalr	1308(ra) # 800062f8 <release>
}
    80002de4:	60e2                	ld	ra,24(sp)
    80002de6:	6442                	ld	s0,16(sp)
    80002de8:	64a2                	ld	s1,8(sp)
    80002dea:	6902                	ld	s2,0(sp)
    80002dec:	6105                	addi	sp,sp,32
    80002dee:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002df0:	40bc                	lw	a5,64(s1)
    80002df2:	dff1                	beqz	a5,80002dce <iput+0x26>
    80002df4:	04a49783          	lh	a5,74(s1)
    80002df8:	fbf9                	bnez	a5,80002dce <iput+0x26>
    acquiresleep(&ip->lock);
    80002dfa:	01048913          	addi	s2,s1,16
    80002dfe:	854a                	mv	a0,s2
    80002e00:	00001097          	auipc	ra,0x1
    80002e04:	ab8080e7          	jalr	-1352(ra) # 800038b8 <acquiresleep>
    release(&itable.lock);
    80002e08:	00019517          	auipc	a0,0x19
    80002e0c:	37050513          	addi	a0,a0,880 # 8001c178 <itable>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	4e8080e7          	jalr	1256(ra) # 800062f8 <release>
    itrunc(ip);
    80002e18:	8526                	mv	a0,s1
    80002e1a:	00000097          	auipc	ra,0x0
    80002e1e:	ee2080e7          	jalr	-286(ra) # 80002cfc <itrunc>
    ip->type = 0;
    80002e22:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e26:	8526                	mv	a0,s1
    80002e28:	00000097          	auipc	ra,0x0
    80002e2c:	cfc080e7          	jalr	-772(ra) # 80002b24 <iupdate>
    ip->valid = 0;
    80002e30:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e34:	854a                	mv	a0,s2
    80002e36:	00001097          	auipc	ra,0x1
    80002e3a:	ada080e7          	jalr	-1318(ra) # 80003910 <releasesleep>
    acquire(&itable.lock);
    80002e3e:	00019517          	auipc	a0,0x19
    80002e42:	33a50513          	addi	a0,a0,826 # 8001c178 <itable>
    80002e46:	00003097          	auipc	ra,0x3
    80002e4a:	3fe080e7          	jalr	1022(ra) # 80006244 <acquire>
    80002e4e:	b741                	j	80002dce <iput+0x26>

0000000080002e50 <iunlockput>:
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	e426                	sd	s1,8(sp)
    80002e58:	1000                	addi	s0,sp,32
    80002e5a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	e54080e7          	jalr	-428(ra) # 80002cb0 <iunlock>
  iput(ip);
    80002e64:	8526                	mv	a0,s1
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	f42080e7          	jalr	-190(ra) # 80002da8 <iput>
}
    80002e6e:	60e2                	ld	ra,24(sp)
    80002e70:	6442                	ld	s0,16(sp)
    80002e72:	64a2                	ld	s1,8(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret

0000000080002e78 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e78:	1141                	addi	sp,sp,-16
    80002e7a:	e422                	sd	s0,8(sp)
    80002e7c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e7e:	411c                	lw	a5,0(a0)
    80002e80:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e82:	415c                	lw	a5,4(a0)
    80002e84:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e86:	04451783          	lh	a5,68(a0)
    80002e8a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e8e:	04a51783          	lh	a5,74(a0)
    80002e92:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e96:	04c56783          	lwu	a5,76(a0)
    80002e9a:	e99c                	sd	a5,16(a1)
}
    80002e9c:	6422                	ld	s0,8(sp)
    80002e9e:	0141                	addi	sp,sp,16
    80002ea0:	8082                	ret

0000000080002ea2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ea2:	457c                	lw	a5,76(a0)
    80002ea4:	0ed7e963          	bltu	a5,a3,80002f96 <readi+0xf4>
{
    80002ea8:	7159                	addi	sp,sp,-112
    80002eaa:	f486                	sd	ra,104(sp)
    80002eac:	f0a2                	sd	s0,96(sp)
    80002eae:	eca6                	sd	s1,88(sp)
    80002eb0:	e8ca                	sd	s2,80(sp)
    80002eb2:	e4ce                	sd	s3,72(sp)
    80002eb4:	e0d2                	sd	s4,64(sp)
    80002eb6:	fc56                	sd	s5,56(sp)
    80002eb8:	f85a                	sd	s6,48(sp)
    80002eba:	f45e                	sd	s7,40(sp)
    80002ebc:	f062                	sd	s8,32(sp)
    80002ebe:	ec66                	sd	s9,24(sp)
    80002ec0:	e86a                	sd	s10,16(sp)
    80002ec2:	e46e                	sd	s11,8(sp)
    80002ec4:	1880                	addi	s0,sp,112
    80002ec6:	8baa                	mv	s7,a0
    80002ec8:	8c2e                	mv	s8,a1
    80002eca:	8ab2                	mv	s5,a2
    80002ecc:	84b6                	mv	s1,a3
    80002ece:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ed0:	9f35                	addw	a4,a4,a3
    return 0;
    80002ed2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ed4:	0ad76063          	bltu	a4,a3,80002f74 <readi+0xd2>
  if(off + n > ip->size)
    80002ed8:	00e7f463          	bgeu	a5,a4,80002ee0 <readi+0x3e>
    n = ip->size - off;
    80002edc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee0:	0a0b0963          	beqz	s6,80002f92 <readi+0xf0>
    80002ee4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ee6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eea:	5cfd                	li	s9,-1
    80002eec:	a82d                	j	80002f26 <readi+0x84>
    80002eee:	020a1d93          	slli	s11,s4,0x20
    80002ef2:	020ddd93          	srli	s11,s11,0x20
    80002ef6:	05890613          	addi	a2,s2,88
    80002efa:	86ee                	mv	a3,s11
    80002efc:	963a                	add	a2,a2,a4
    80002efe:	85d6                	mv	a1,s5
    80002f00:	8562                	mv	a0,s8
    80002f02:	fffff097          	auipc	ra,0xfffff
    80002f06:	9ec080e7          	jalr	-1556(ra) # 800018ee <either_copyout>
    80002f0a:	05950d63          	beq	a0,s9,80002f64 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f0e:	854a                	mv	a0,s2
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	60c080e7          	jalr	1548(ra) # 8000251c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f18:	013a09bb          	addw	s3,s4,s3
    80002f1c:	009a04bb          	addw	s1,s4,s1
    80002f20:	9aee                	add	s5,s5,s11
    80002f22:	0569f763          	bgeu	s3,s6,80002f70 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f26:	000ba903          	lw	s2,0(s7)
    80002f2a:	00a4d59b          	srliw	a1,s1,0xa
    80002f2e:	855e                	mv	a0,s7
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	8b0080e7          	jalr	-1872(ra) # 800027e0 <bmap>
    80002f38:	0005059b          	sext.w	a1,a0
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	4ae080e7          	jalr	1198(ra) # 800023ec <bread>
    80002f46:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f48:	3ff4f713          	andi	a4,s1,1023
    80002f4c:	40ed07bb          	subw	a5,s10,a4
    80002f50:	413b06bb          	subw	a3,s6,s3
    80002f54:	8a3e                	mv	s4,a5
    80002f56:	2781                	sext.w	a5,a5
    80002f58:	0006861b          	sext.w	a2,a3
    80002f5c:	f8f679e3          	bgeu	a2,a5,80002eee <readi+0x4c>
    80002f60:	8a36                	mv	s4,a3
    80002f62:	b771                	j	80002eee <readi+0x4c>
      brelse(bp);
    80002f64:	854a                	mv	a0,s2
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	5b6080e7          	jalr	1462(ra) # 8000251c <brelse>
      tot = -1;
    80002f6e:	59fd                	li	s3,-1
  }
  return tot;
    80002f70:	0009851b          	sext.w	a0,s3
}
    80002f74:	70a6                	ld	ra,104(sp)
    80002f76:	7406                	ld	s0,96(sp)
    80002f78:	64e6                	ld	s1,88(sp)
    80002f7a:	6946                	ld	s2,80(sp)
    80002f7c:	69a6                	ld	s3,72(sp)
    80002f7e:	6a06                	ld	s4,64(sp)
    80002f80:	7ae2                	ld	s5,56(sp)
    80002f82:	7b42                	ld	s6,48(sp)
    80002f84:	7ba2                	ld	s7,40(sp)
    80002f86:	7c02                	ld	s8,32(sp)
    80002f88:	6ce2                	ld	s9,24(sp)
    80002f8a:	6d42                	ld	s10,16(sp)
    80002f8c:	6da2                	ld	s11,8(sp)
    80002f8e:	6165                	addi	sp,sp,112
    80002f90:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f92:	89da                	mv	s3,s6
    80002f94:	bff1                	j	80002f70 <readi+0xce>
    return 0;
    80002f96:	4501                	li	a0,0
}
    80002f98:	8082                	ret

0000000080002f9a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f9a:	457c                	lw	a5,76(a0)
    80002f9c:	10d7e863          	bltu	a5,a3,800030ac <writei+0x112>
{
    80002fa0:	7159                	addi	sp,sp,-112
    80002fa2:	f486                	sd	ra,104(sp)
    80002fa4:	f0a2                	sd	s0,96(sp)
    80002fa6:	eca6                	sd	s1,88(sp)
    80002fa8:	e8ca                	sd	s2,80(sp)
    80002faa:	e4ce                	sd	s3,72(sp)
    80002fac:	e0d2                	sd	s4,64(sp)
    80002fae:	fc56                	sd	s5,56(sp)
    80002fb0:	f85a                	sd	s6,48(sp)
    80002fb2:	f45e                	sd	s7,40(sp)
    80002fb4:	f062                	sd	s8,32(sp)
    80002fb6:	ec66                	sd	s9,24(sp)
    80002fb8:	e86a                	sd	s10,16(sp)
    80002fba:	e46e                	sd	s11,8(sp)
    80002fbc:	1880                	addi	s0,sp,112
    80002fbe:	8b2a                	mv	s6,a0
    80002fc0:	8c2e                	mv	s8,a1
    80002fc2:	8ab2                	mv	s5,a2
    80002fc4:	8936                	mv	s2,a3
    80002fc6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fc8:	00e687bb          	addw	a5,a3,a4
    80002fcc:	0ed7e263          	bltu	a5,a3,800030b0 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fd0:	00043737          	lui	a4,0x43
    80002fd4:	0ef76063          	bltu	a4,a5,800030b4 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd8:	0c0b8863          	beqz	s7,800030a8 <writei+0x10e>
    80002fdc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fde:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fe2:	5cfd                	li	s9,-1
    80002fe4:	a091                	j	80003028 <writei+0x8e>
    80002fe6:	02099d93          	slli	s11,s3,0x20
    80002fea:	020ddd93          	srli	s11,s11,0x20
    80002fee:	05848513          	addi	a0,s1,88
    80002ff2:	86ee                	mv	a3,s11
    80002ff4:	8656                	mv	a2,s5
    80002ff6:	85e2                	mv	a1,s8
    80002ff8:	953a                	add	a0,a0,a4
    80002ffa:	fffff097          	auipc	ra,0xfffff
    80002ffe:	94c080e7          	jalr	-1716(ra) # 80001946 <either_copyin>
    80003002:	07950263          	beq	a0,s9,80003066 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003006:	8526                	mv	a0,s1
    80003008:	00000097          	auipc	ra,0x0
    8000300c:	790080e7          	jalr	1936(ra) # 80003798 <log_write>
    brelse(bp);
    80003010:	8526                	mv	a0,s1
    80003012:	fffff097          	auipc	ra,0xfffff
    80003016:	50a080e7          	jalr	1290(ra) # 8000251c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000301a:	01498a3b          	addw	s4,s3,s4
    8000301e:	0129893b          	addw	s2,s3,s2
    80003022:	9aee                	add	s5,s5,s11
    80003024:	057a7663          	bgeu	s4,s7,80003070 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003028:	000b2483          	lw	s1,0(s6)
    8000302c:	00a9559b          	srliw	a1,s2,0xa
    80003030:	855a                	mv	a0,s6
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	7ae080e7          	jalr	1966(ra) # 800027e0 <bmap>
    8000303a:	0005059b          	sext.w	a1,a0
    8000303e:	8526                	mv	a0,s1
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	3ac080e7          	jalr	940(ra) # 800023ec <bread>
    80003048:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000304a:	3ff97713          	andi	a4,s2,1023
    8000304e:	40ed07bb          	subw	a5,s10,a4
    80003052:	414b86bb          	subw	a3,s7,s4
    80003056:	89be                	mv	s3,a5
    80003058:	2781                	sext.w	a5,a5
    8000305a:	0006861b          	sext.w	a2,a3
    8000305e:	f8f674e3          	bgeu	a2,a5,80002fe6 <writei+0x4c>
    80003062:	89b6                	mv	s3,a3
    80003064:	b749                	j	80002fe6 <writei+0x4c>
      brelse(bp);
    80003066:	8526                	mv	a0,s1
    80003068:	fffff097          	auipc	ra,0xfffff
    8000306c:	4b4080e7          	jalr	1204(ra) # 8000251c <brelse>
  }

  if(off > ip->size)
    80003070:	04cb2783          	lw	a5,76(s6)
    80003074:	0127f463          	bgeu	a5,s2,8000307c <writei+0xe2>
    ip->size = off;
    80003078:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000307c:	855a                	mv	a0,s6
    8000307e:	00000097          	auipc	ra,0x0
    80003082:	aa6080e7          	jalr	-1370(ra) # 80002b24 <iupdate>

  return tot;
    80003086:	000a051b          	sext.w	a0,s4
}
    8000308a:	70a6                	ld	ra,104(sp)
    8000308c:	7406                	ld	s0,96(sp)
    8000308e:	64e6                	ld	s1,88(sp)
    80003090:	6946                	ld	s2,80(sp)
    80003092:	69a6                	ld	s3,72(sp)
    80003094:	6a06                	ld	s4,64(sp)
    80003096:	7ae2                	ld	s5,56(sp)
    80003098:	7b42                	ld	s6,48(sp)
    8000309a:	7ba2                	ld	s7,40(sp)
    8000309c:	7c02                	ld	s8,32(sp)
    8000309e:	6ce2                	ld	s9,24(sp)
    800030a0:	6d42                	ld	s10,16(sp)
    800030a2:	6da2                	ld	s11,8(sp)
    800030a4:	6165                	addi	sp,sp,112
    800030a6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a8:	8a5e                	mv	s4,s7
    800030aa:	bfc9                	j	8000307c <writei+0xe2>
    return -1;
    800030ac:	557d                	li	a0,-1
}
    800030ae:	8082                	ret
    return -1;
    800030b0:	557d                	li	a0,-1
    800030b2:	bfe1                	j	8000308a <writei+0xf0>
    return -1;
    800030b4:	557d                	li	a0,-1
    800030b6:	bfd1                	j	8000308a <writei+0xf0>

00000000800030b8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030b8:	1141                	addi	sp,sp,-16
    800030ba:	e406                	sd	ra,8(sp)
    800030bc:	e022                	sd	s0,0(sp)
    800030be:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030c0:	4639                	li	a2,14
    800030c2:	ffffd097          	auipc	ra,0xffffd
    800030c6:	18e080e7          	jalr	398(ra) # 80000250 <strncmp>
}
    800030ca:	60a2                	ld	ra,8(sp)
    800030cc:	6402                	ld	s0,0(sp)
    800030ce:	0141                	addi	sp,sp,16
    800030d0:	8082                	ret

00000000800030d2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030d2:	7139                	addi	sp,sp,-64
    800030d4:	fc06                	sd	ra,56(sp)
    800030d6:	f822                	sd	s0,48(sp)
    800030d8:	f426                	sd	s1,40(sp)
    800030da:	f04a                	sd	s2,32(sp)
    800030dc:	ec4e                	sd	s3,24(sp)
    800030de:	e852                	sd	s4,16(sp)
    800030e0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030e2:	04451703          	lh	a4,68(a0)
    800030e6:	4785                	li	a5,1
    800030e8:	00f71a63          	bne	a4,a5,800030fc <dirlookup+0x2a>
    800030ec:	892a                	mv	s2,a0
    800030ee:	89ae                	mv	s3,a1
    800030f0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f2:	457c                	lw	a5,76(a0)
    800030f4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030f6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f8:	e79d                	bnez	a5,80003126 <dirlookup+0x54>
    800030fa:	a8a5                	j	80003172 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	47c50513          	addi	a0,a0,1148 # 80008578 <syscalls+0x1b0>
    80003104:	00003097          	auipc	ra,0x3
    80003108:	ba6080e7          	jalr	-1114(ra) # 80005caa <panic>
      panic("dirlookup read");
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	48450513          	addi	a0,a0,1156 # 80008590 <syscalls+0x1c8>
    80003114:	00003097          	auipc	ra,0x3
    80003118:	b96080e7          	jalr	-1130(ra) # 80005caa <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000311c:	24c1                	addiw	s1,s1,16
    8000311e:	04c92783          	lw	a5,76(s2)
    80003122:	04f4f763          	bgeu	s1,a5,80003170 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003126:	4741                	li	a4,16
    80003128:	86a6                	mv	a3,s1
    8000312a:	fc040613          	addi	a2,s0,-64
    8000312e:	4581                	li	a1,0
    80003130:	854a                	mv	a0,s2
    80003132:	00000097          	auipc	ra,0x0
    80003136:	d70080e7          	jalr	-656(ra) # 80002ea2 <readi>
    8000313a:	47c1                	li	a5,16
    8000313c:	fcf518e3          	bne	a0,a5,8000310c <dirlookup+0x3a>
    if(de.inum == 0)
    80003140:	fc045783          	lhu	a5,-64(s0)
    80003144:	dfe1                	beqz	a5,8000311c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003146:	fc240593          	addi	a1,s0,-62
    8000314a:	854e                	mv	a0,s3
    8000314c:	00000097          	auipc	ra,0x0
    80003150:	f6c080e7          	jalr	-148(ra) # 800030b8 <namecmp>
    80003154:	f561                	bnez	a0,8000311c <dirlookup+0x4a>
      if(poff)
    80003156:	000a0463          	beqz	s4,8000315e <dirlookup+0x8c>
        *poff = off;
    8000315a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000315e:	fc045583          	lhu	a1,-64(s0)
    80003162:	00092503          	lw	a0,0(s2)
    80003166:	fffff097          	auipc	ra,0xfffff
    8000316a:	754080e7          	jalr	1876(ra) # 800028ba <iget>
    8000316e:	a011                	j	80003172 <dirlookup+0xa0>
  return 0;
    80003170:	4501                	li	a0,0
}
    80003172:	70e2                	ld	ra,56(sp)
    80003174:	7442                	ld	s0,48(sp)
    80003176:	74a2                	ld	s1,40(sp)
    80003178:	7902                	ld	s2,32(sp)
    8000317a:	69e2                	ld	s3,24(sp)
    8000317c:	6a42                	ld	s4,16(sp)
    8000317e:	6121                	addi	sp,sp,64
    80003180:	8082                	ret

0000000080003182 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003182:	711d                	addi	sp,sp,-96
    80003184:	ec86                	sd	ra,88(sp)
    80003186:	e8a2                	sd	s0,80(sp)
    80003188:	e4a6                	sd	s1,72(sp)
    8000318a:	e0ca                	sd	s2,64(sp)
    8000318c:	fc4e                	sd	s3,56(sp)
    8000318e:	f852                	sd	s4,48(sp)
    80003190:	f456                	sd	s5,40(sp)
    80003192:	f05a                	sd	s6,32(sp)
    80003194:	ec5e                	sd	s7,24(sp)
    80003196:	e862                	sd	s8,16(sp)
    80003198:	e466                	sd	s9,8(sp)
    8000319a:	1080                	addi	s0,sp,96
    8000319c:	84aa                	mv	s1,a0
    8000319e:	8b2e                	mv	s6,a1
    800031a0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031a2:	00054703          	lbu	a4,0(a0)
    800031a6:	02f00793          	li	a5,47
    800031aa:	02f70363          	beq	a4,a5,800031d0 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031ae:	ffffe097          	auipc	ra,0xffffe
    800031b2:	c9c080e7          	jalr	-868(ra) # 80000e4a <myproc>
    800031b6:	28053503          	ld	a0,640(a0)
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	9f6080e7          	jalr	-1546(ra) # 80002bb0 <idup>
    800031c2:	89aa                	mv	s3,a0
  while(*path == '/')
    800031c4:	02f00913          	li	s2,47
  len = path - s;
    800031c8:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031ca:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031cc:	4c05                	li	s8,1
    800031ce:	a865                	j	80003286 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031d0:	4585                	li	a1,1
    800031d2:	4505                	li	a0,1
    800031d4:	fffff097          	auipc	ra,0xfffff
    800031d8:	6e6080e7          	jalr	1766(ra) # 800028ba <iget>
    800031dc:	89aa                	mv	s3,a0
    800031de:	b7dd                	j	800031c4 <namex+0x42>
      iunlockput(ip);
    800031e0:	854e                	mv	a0,s3
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	c6e080e7          	jalr	-914(ra) # 80002e50 <iunlockput>
      return 0;
    800031ea:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ec:	854e                	mv	a0,s3
    800031ee:	60e6                	ld	ra,88(sp)
    800031f0:	6446                	ld	s0,80(sp)
    800031f2:	64a6                	ld	s1,72(sp)
    800031f4:	6906                	ld	s2,64(sp)
    800031f6:	79e2                	ld	s3,56(sp)
    800031f8:	7a42                	ld	s4,48(sp)
    800031fa:	7aa2                	ld	s5,40(sp)
    800031fc:	7b02                	ld	s6,32(sp)
    800031fe:	6be2                	ld	s7,24(sp)
    80003200:	6c42                	ld	s8,16(sp)
    80003202:	6ca2                	ld	s9,8(sp)
    80003204:	6125                	addi	sp,sp,96
    80003206:	8082                	ret
      iunlock(ip);
    80003208:	854e                	mv	a0,s3
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	aa6080e7          	jalr	-1370(ra) # 80002cb0 <iunlock>
      return ip;
    80003212:	bfe9                	j	800031ec <namex+0x6a>
      iunlockput(ip);
    80003214:	854e                	mv	a0,s3
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	c3a080e7          	jalr	-966(ra) # 80002e50 <iunlockput>
      return 0;
    8000321e:	89d2                	mv	s3,s4
    80003220:	b7f1                	j	800031ec <namex+0x6a>
  len = path - s;
    80003222:	40b48633          	sub	a2,s1,a1
    80003226:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000322a:	094cd463          	bge	s9,s4,800032b2 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000322e:	4639                	li	a2,14
    80003230:	8556                	mv	a0,s5
    80003232:	ffffd097          	auipc	ra,0xffffd
    80003236:	fa6080e7          	jalr	-90(ra) # 800001d8 <memmove>
  while(*path == '/')
    8000323a:	0004c783          	lbu	a5,0(s1)
    8000323e:	01279763          	bne	a5,s2,8000324c <namex+0xca>
    path++;
    80003242:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003244:	0004c783          	lbu	a5,0(s1)
    80003248:	ff278de3          	beq	a5,s2,80003242 <namex+0xc0>
    ilock(ip);
    8000324c:	854e                	mv	a0,s3
    8000324e:	00000097          	auipc	ra,0x0
    80003252:	9a0080e7          	jalr	-1632(ra) # 80002bee <ilock>
    if(ip->type != T_DIR){
    80003256:	04499783          	lh	a5,68(s3)
    8000325a:	f98793e3          	bne	a5,s8,800031e0 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000325e:	000b0563          	beqz	s6,80003268 <namex+0xe6>
    80003262:	0004c783          	lbu	a5,0(s1)
    80003266:	d3cd                	beqz	a5,80003208 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003268:	865e                	mv	a2,s7
    8000326a:	85d6                	mv	a1,s5
    8000326c:	854e                	mv	a0,s3
    8000326e:	00000097          	auipc	ra,0x0
    80003272:	e64080e7          	jalr	-412(ra) # 800030d2 <dirlookup>
    80003276:	8a2a                	mv	s4,a0
    80003278:	dd51                	beqz	a0,80003214 <namex+0x92>
    iunlockput(ip);
    8000327a:	854e                	mv	a0,s3
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	bd4080e7          	jalr	-1068(ra) # 80002e50 <iunlockput>
    ip = next;
    80003284:	89d2                	mv	s3,s4
  while(*path == '/')
    80003286:	0004c783          	lbu	a5,0(s1)
    8000328a:	05279763          	bne	a5,s2,800032d8 <namex+0x156>
    path++;
    8000328e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	ff278de3          	beq	a5,s2,8000328e <namex+0x10c>
  if(*path == 0)
    80003298:	c79d                	beqz	a5,800032c6 <namex+0x144>
    path++;
    8000329a:	85a6                	mv	a1,s1
  len = path - s;
    8000329c:	8a5e                	mv	s4,s7
    8000329e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032a0:	01278963          	beq	a5,s2,800032b2 <namex+0x130>
    800032a4:	dfbd                	beqz	a5,80003222 <namex+0xa0>
    path++;
    800032a6:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032a8:	0004c783          	lbu	a5,0(s1)
    800032ac:	ff279ce3          	bne	a5,s2,800032a4 <namex+0x122>
    800032b0:	bf8d                	j	80003222 <namex+0xa0>
    memmove(name, s, len);
    800032b2:	2601                	sext.w	a2,a2
    800032b4:	8556                	mv	a0,s5
    800032b6:	ffffd097          	auipc	ra,0xffffd
    800032ba:	f22080e7          	jalr	-222(ra) # 800001d8 <memmove>
    name[len] = 0;
    800032be:	9a56                	add	s4,s4,s5
    800032c0:	000a0023          	sb	zero,0(s4)
    800032c4:	bf9d                	j	8000323a <namex+0xb8>
  if(nameiparent){
    800032c6:	f20b03e3          	beqz	s6,800031ec <namex+0x6a>
    iput(ip);
    800032ca:	854e                	mv	a0,s3
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	adc080e7          	jalr	-1316(ra) # 80002da8 <iput>
    return 0;
    800032d4:	4981                	li	s3,0
    800032d6:	bf19                	j	800031ec <namex+0x6a>
  if(*path == 0)
    800032d8:	d7fd                	beqz	a5,800032c6 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	85a6                	mv	a1,s1
    800032e0:	b7d1                	j	800032a4 <namex+0x122>

00000000800032e2 <dirlink>:
{
    800032e2:	7139                	addi	sp,sp,-64
    800032e4:	fc06                	sd	ra,56(sp)
    800032e6:	f822                	sd	s0,48(sp)
    800032e8:	f426                	sd	s1,40(sp)
    800032ea:	f04a                	sd	s2,32(sp)
    800032ec:	ec4e                	sd	s3,24(sp)
    800032ee:	e852                	sd	s4,16(sp)
    800032f0:	0080                	addi	s0,sp,64
    800032f2:	892a                	mv	s2,a0
    800032f4:	8a2e                	mv	s4,a1
    800032f6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032f8:	4601                	li	a2,0
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	dd8080e7          	jalr	-552(ra) # 800030d2 <dirlookup>
    80003302:	e93d                	bnez	a0,80003378 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003304:	04c92483          	lw	s1,76(s2)
    80003308:	c49d                	beqz	s1,80003336 <dirlink+0x54>
    8000330a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000330c:	4741                	li	a4,16
    8000330e:	86a6                	mv	a3,s1
    80003310:	fc040613          	addi	a2,s0,-64
    80003314:	4581                	li	a1,0
    80003316:	854a                	mv	a0,s2
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	b8a080e7          	jalr	-1142(ra) # 80002ea2 <readi>
    80003320:	47c1                	li	a5,16
    80003322:	06f51163          	bne	a0,a5,80003384 <dirlink+0xa2>
    if(de.inum == 0)
    80003326:	fc045783          	lhu	a5,-64(s0)
    8000332a:	c791                	beqz	a5,80003336 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000332c:	24c1                	addiw	s1,s1,16
    8000332e:	04c92783          	lw	a5,76(s2)
    80003332:	fcf4ede3          	bltu	s1,a5,8000330c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003336:	4639                	li	a2,14
    80003338:	85d2                	mv	a1,s4
    8000333a:	fc240513          	addi	a0,s0,-62
    8000333e:	ffffd097          	auipc	ra,0xffffd
    80003342:	f4e080e7          	jalr	-178(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003346:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334a:	4741                	li	a4,16
    8000334c:	86a6                	mv	a3,s1
    8000334e:	fc040613          	addi	a2,s0,-64
    80003352:	4581                	li	a1,0
    80003354:	854a                	mv	a0,s2
    80003356:	00000097          	auipc	ra,0x0
    8000335a:	c44080e7          	jalr	-956(ra) # 80002f9a <writei>
    8000335e:	872a                	mv	a4,a0
    80003360:	47c1                	li	a5,16
  return 0;
    80003362:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003364:	02f71863          	bne	a4,a5,80003394 <dirlink+0xb2>
}
    80003368:	70e2                	ld	ra,56(sp)
    8000336a:	7442                	ld	s0,48(sp)
    8000336c:	74a2                	ld	s1,40(sp)
    8000336e:	7902                	ld	s2,32(sp)
    80003370:	69e2                	ld	s3,24(sp)
    80003372:	6a42                	ld	s4,16(sp)
    80003374:	6121                	addi	sp,sp,64
    80003376:	8082                	ret
    iput(ip);
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	a30080e7          	jalr	-1488(ra) # 80002da8 <iput>
    return -1;
    80003380:	557d                	li	a0,-1
    80003382:	b7dd                	j	80003368 <dirlink+0x86>
      panic("dirlink read");
    80003384:	00005517          	auipc	a0,0x5
    80003388:	21c50513          	addi	a0,a0,540 # 800085a0 <syscalls+0x1d8>
    8000338c:	00003097          	auipc	ra,0x3
    80003390:	91e080e7          	jalr	-1762(ra) # 80005caa <panic>
    panic("dirlink");
    80003394:	00005517          	auipc	a0,0x5
    80003398:	31c50513          	addi	a0,a0,796 # 800086b0 <syscalls+0x2e8>
    8000339c:	00003097          	auipc	ra,0x3
    800033a0:	90e080e7          	jalr	-1778(ra) # 80005caa <panic>

00000000800033a4 <namei>:

struct inode*
namei(char *path)
{
    800033a4:	1101                	addi	sp,sp,-32
    800033a6:	ec06                	sd	ra,24(sp)
    800033a8:	e822                	sd	s0,16(sp)
    800033aa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ac:	fe040613          	addi	a2,s0,-32
    800033b0:	4581                	li	a1,0
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	dd0080e7          	jalr	-560(ra) # 80003182 <namex>
}
    800033ba:	60e2                	ld	ra,24(sp)
    800033bc:	6442                	ld	s0,16(sp)
    800033be:	6105                	addi	sp,sp,32
    800033c0:	8082                	ret

00000000800033c2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033c2:	1141                	addi	sp,sp,-16
    800033c4:	e406                	sd	ra,8(sp)
    800033c6:	e022                	sd	s0,0(sp)
    800033c8:	0800                	addi	s0,sp,16
    800033ca:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033cc:	4585                	li	a1,1
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	db4080e7          	jalr	-588(ra) # 80003182 <namex>
}
    800033d6:	60a2                	ld	ra,8(sp)
    800033d8:	6402                	ld	s0,0(sp)
    800033da:	0141                	addi	sp,sp,16
    800033dc:	8082                	ret

00000000800033de <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033de:	1101                	addi	sp,sp,-32
    800033e0:	ec06                	sd	ra,24(sp)
    800033e2:	e822                	sd	s0,16(sp)
    800033e4:	e426                	sd	s1,8(sp)
    800033e6:	e04a                	sd	s2,0(sp)
    800033e8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033ea:	0001b917          	auipc	s2,0x1b
    800033ee:	83690913          	addi	s2,s2,-1994 # 8001dc20 <log>
    800033f2:	01892583          	lw	a1,24(s2)
    800033f6:	02892503          	lw	a0,40(s2)
    800033fa:	fffff097          	auipc	ra,0xfffff
    800033fe:	ff2080e7          	jalr	-14(ra) # 800023ec <bread>
    80003402:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003404:	02c92683          	lw	a3,44(s2)
    80003408:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000340a:	02d05763          	blez	a3,80003438 <write_head+0x5a>
    8000340e:	0001b797          	auipc	a5,0x1b
    80003412:	84278793          	addi	a5,a5,-1982 # 8001dc50 <log+0x30>
    80003416:	05c50713          	addi	a4,a0,92
    8000341a:	36fd                	addiw	a3,a3,-1
    8000341c:	1682                	slli	a3,a3,0x20
    8000341e:	9281                	srli	a3,a3,0x20
    80003420:	068a                	slli	a3,a3,0x2
    80003422:	0001b617          	auipc	a2,0x1b
    80003426:	83260613          	addi	a2,a2,-1998 # 8001dc54 <log+0x34>
    8000342a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000342c:	4390                	lw	a2,0(a5)
    8000342e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003430:	0791                	addi	a5,a5,4
    80003432:	0711                	addi	a4,a4,4
    80003434:	fed79ce3          	bne	a5,a3,8000342c <write_head+0x4e>
  }
  bwrite(buf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	0a4080e7          	jalr	164(ra) # 800024de <bwrite>
  brelse(buf);
    80003442:	8526                	mv	a0,s1
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	0d8080e7          	jalr	216(ra) # 8000251c <brelse>
}
    8000344c:	60e2                	ld	ra,24(sp)
    8000344e:	6442                	ld	s0,16(sp)
    80003450:	64a2                	ld	s1,8(sp)
    80003452:	6902                	ld	s2,0(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret

0000000080003458 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003458:	0001a797          	auipc	a5,0x1a
    8000345c:	7f47a783          	lw	a5,2036(a5) # 8001dc4c <log+0x2c>
    80003460:	0af05d63          	blez	a5,8000351a <install_trans+0xc2>
{
    80003464:	7139                	addi	sp,sp,-64
    80003466:	fc06                	sd	ra,56(sp)
    80003468:	f822                	sd	s0,48(sp)
    8000346a:	f426                	sd	s1,40(sp)
    8000346c:	f04a                	sd	s2,32(sp)
    8000346e:	ec4e                	sd	s3,24(sp)
    80003470:	e852                	sd	s4,16(sp)
    80003472:	e456                	sd	s5,8(sp)
    80003474:	e05a                	sd	s6,0(sp)
    80003476:	0080                	addi	s0,sp,64
    80003478:	8b2a                	mv	s6,a0
    8000347a:	0001aa97          	auipc	s5,0x1a
    8000347e:	7d6a8a93          	addi	s5,s5,2006 # 8001dc50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003482:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003484:	0001a997          	auipc	s3,0x1a
    80003488:	79c98993          	addi	s3,s3,1948 # 8001dc20 <log>
    8000348c:	a035                	j	800034b8 <install_trans+0x60>
      bunpin(dbuf);
    8000348e:	8526                	mv	a0,s1
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	166080e7          	jalr	358(ra) # 800025f6 <bunpin>
    brelse(lbuf);
    80003498:	854a                	mv	a0,s2
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	082080e7          	jalr	130(ra) # 8000251c <brelse>
    brelse(dbuf);
    800034a2:	8526                	mv	a0,s1
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	078080e7          	jalr	120(ra) # 8000251c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ac:	2a05                	addiw	s4,s4,1
    800034ae:	0a91                	addi	s5,s5,4
    800034b0:	02c9a783          	lw	a5,44(s3)
    800034b4:	04fa5963          	bge	s4,a5,80003506 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b8:	0189a583          	lw	a1,24(s3)
    800034bc:	014585bb          	addw	a1,a1,s4
    800034c0:	2585                	addiw	a1,a1,1
    800034c2:	0289a503          	lw	a0,40(s3)
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	f26080e7          	jalr	-218(ra) # 800023ec <bread>
    800034ce:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034d0:	000aa583          	lw	a1,0(s5)
    800034d4:	0289a503          	lw	a0,40(s3)
    800034d8:	fffff097          	auipc	ra,0xfffff
    800034dc:	f14080e7          	jalr	-236(ra) # 800023ec <bread>
    800034e0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034e2:	40000613          	li	a2,1024
    800034e6:	05890593          	addi	a1,s2,88
    800034ea:	05850513          	addi	a0,a0,88
    800034ee:	ffffd097          	auipc	ra,0xffffd
    800034f2:	cea080e7          	jalr	-790(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034f6:	8526                	mv	a0,s1
    800034f8:	fffff097          	auipc	ra,0xfffff
    800034fc:	fe6080e7          	jalr	-26(ra) # 800024de <bwrite>
    if(recovering == 0)
    80003500:	f80b1ce3          	bnez	s6,80003498 <install_trans+0x40>
    80003504:	b769                	j	8000348e <install_trans+0x36>
}
    80003506:	70e2                	ld	ra,56(sp)
    80003508:	7442                	ld	s0,48(sp)
    8000350a:	74a2                	ld	s1,40(sp)
    8000350c:	7902                	ld	s2,32(sp)
    8000350e:	69e2                	ld	s3,24(sp)
    80003510:	6a42                	ld	s4,16(sp)
    80003512:	6aa2                	ld	s5,8(sp)
    80003514:	6b02                	ld	s6,0(sp)
    80003516:	6121                	addi	sp,sp,64
    80003518:	8082                	ret
    8000351a:	8082                	ret

000000008000351c <initlog>:
{
    8000351c:	7179                	addi	sp,sp,-48
    8000351e:	f406                	sd	ra,40(sp)
    80003520:	f022                	sd	s0,32(sp)
    80003522:	ec26                	sd	s1,24(sp)
    80003524:	e84a                	sd	s2,16(sp)
    80003526:	e44e                	sd	s3,8(sp)
    80003528:	1800                	addi	s0,sp,48
    8000352a:	892a                	mv	s2,a0
    8000352c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000352e:	0001a497          	auipc	s1,0x1a
    80003532:	6f248493          	addi	s1,s1,1778 # 8001dc20 <log>
    80003536:	00005597          	auipc	a1,0x5
    8000353a:	07a58593          	addi	a1,a1,122 # 800085b0 <syscalls+0x1e8>
    8000353e:	8526                	mv	a0,s1
    80003540:	00003097          	auipc	ra,0x3
    80003544:	c74080e7          	jalr	-908(ra) # 800061b4 <initlock>
  log.start = sb->logstart;
    80003548:	0149a583          	lw	a1,20(s3)
    8000354c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000354e:	0109a783          	lw	a5,16(s3)
    80003552:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003554:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003558:	854a                	mv	a0,s2
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	e92080e7          	jalr	-366(ra) # 800023ec <bread>
  log.lh.n = lh->n;
    80003562:	4d3c                	lw	a5,88(a0)
    80003564:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	02f05563          	blez	a5,80003590 <initlog+0x74>
    8000356a:	05c50713          	addi	a4,a0,92
    8000356e:	0001a697          	auipc	a3,0x1a
    80003572:	6e268693          	addi	a3,a3,1762 # 8001dc50 <log+0x30>
    80003576:	37fd                	addiw	a5,a5,-1
    80003578:	1782                	slli	a5,a5,0x20
    8000357a:	9381                	srli	a5,a5,0x20
    8000357c:	078a                	slli	a5,a5,0x2
    8000357e:	06050613          	addi	a2,a0,96
    80003582:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003584:	4310                	lw	a2,0(a4)
    80003586:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003588:	0711                	addi	a4,a4,4
    8000358a:	0691                	addi	a3,a3,4
    8000358c:	fef71ce3          	bne	a4,a5,80003584 <initlog+0x68>
  brelse(buf);
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	f8c080e7          	jalr	-116(ra) # 8000251c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003598:	4505                	li	a0,1
    8000359a:	00000097          	auipc	ra,0x0
    8000359e:	ebe080e7          	jalr	-322(ra) # 80003458 <install_trans>
  log.lh.n = 0;
    800035a2:	0001a797          	auipc	a5,0x1a
    800035a6:	6a07a523          	sw	zero,1706(a5) # 8001dc4c <log+0x2c>
  write_head(); // clear the log
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	e34080e7          	jalr	-460(ra) # 800033de <write_head>
}
    800035b2:	70a2                	ld	ra,40(sp)
    800035b4:	7402                	ld	s0,32(sp)
    800035b6:	64e2                	ld	s1,24(sp)
    800035b8:	6942                	ld	s2,16(sp)
    800035ba:	69a2                	ld	s3,8(sp)
    800035bc:	6145                	addi	sp,sp,48
    800035be:	8082                	ret

00000000800035c0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035c0:	1101                	addi	sp,sp,-32
    800035c2:	ec06                	sd	ra,24(sp)
    800035c4:	e822                	sd	s0,16(sp)
    800035c6:	e426                	sd	s1,8(sp)
    800035c8:	e04a                	sd	s2,0(sp)
    800035ca:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035cc:	0001a517          	auipc	a0,0x1a
    800035d0:	65450513          	addi	a0,a0,1620 # 8001dc20 <log>
    800035d4:	00003097          	auipc	ra,0x3
    800035d8:	c70080e7          	jalr	-912(ra) # 80006244 <acquire>
  while(1){
    if(log.committing){
    800035dc:	0001a497          	auipc	s1,0x1a
    800035e0:	64448493          	addi	s1,s1,1604 # 8001dc20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e4:	4979                	li	s2,30
    800035e6:	a039                	j	800035f4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035e8:	85a6                	mv	a1,s1
    800035ea:	8526                	mv	a0,s1
    800035ec:	ffffe097          	auipc	ra,0xffffe
    800035f0:	f48080e7          	jalr	-184(ra) # 80001534 <sleep>
    if(log.committing){
    800035f4:	50dc                	lw	a5,36(s1)
    800035f6:	fbed                	bnez	a5,800035e8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f8:	509c                	lw	a5,32(s1)
    800035fa:	0017871b          	addiw	a4,a5,1
    800035fe:	0007069b          	sext.w	a3,a4
    80003602:	0027179b          	slliw	a5,a4,0x2
    80003606:	9fb9                	addw	a5,a5,a4
    80003608:	0017979b          	slliw	a5,a5,0x1
    8000360c:	54d8                	lw	a4,44(s1)
    8000360e:	9fb9                	addw	a5,a5,a4
    80003610:	00f95963          	bge	s2,a5,80003622 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003614:	85a6                	mv	a1,s1
    80003616:	8526                	mv	a0,s1
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	f1c080e7          	jalr	-228(ra) # 80001534 <sleep>
    80003620:	bfd1                	j	800035f4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003622:	0001a517          	auipc	a0,0x1a
    80003626:	5fe50513          	addi	a0,a0,1534 # 8001dc20 <log>
    8000362a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	ccc080e7          	jalr	-820(ra) # 800062f8 <release>
      break;
    }
  }
}
    80003634:	60e2                	ld	ra,24(sp)
    80003636:	6442                	ld	s0,16(sp)
    80003638:	64a2                	ld	s1,8(sp)
    8000363a:	6902                	ld	s2,0(sp)
    8000363c:	6105                	addi	sp,sp,32
    8000363e:	8082                	ret

0000000080003640 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003640:	7139                	addi	sp,sp,-64
    80003642:	fc06                	sd	ra,56(sp)
    80003644:	f822                	sd	s0,48(sp)
    80003646:	f426                	sd	s1,40(sp)
    80003648:	f04a                	sd	s2,32(sp)
    8000364a:	ec4e                	sd	s3,24(sp)
    8000364c:	e852                	sd	s4,16(sp)
    8000364e:	e456                	sd	s5,8(sp)
    80003650:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003652:	0001a497          	auipc	s1,0x1a
    80003656:	5ce48493          	addi	s1,s1,1486 # 8001dc20 <log>
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	be8080e7          	jalr	-1048(ra) # 80006244 <acquire>
  log.outstanding -= 1;
    80003664:	509c                	lw	a5,32(s1)
    80003666:	37fd                	addiw	a5,a5,-1
    80003668:	0007891b          	sext.w	s2,a5
    8000366c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000366e:	50dc                	lw	a5,36(s1)
    80003670:	efb9                	bnez	a5,800036ce <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003672:	06091663          	bnez	s2,800036de <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003676:	0001a497          	auipc	s1,0x1a
    8000367a:	5aa48493          	addi	s1,s1,1450 # 8001dc20 <log>
    8000367e:	4785                	li	a5,1
    80003680:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003682:	8526                	mv	a0,s1
    80003684:	00003097          	auipc	ra,0x3
    80003688:	c74080e7          	jalr	-908(ra) # 800062f8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000368c:	54dc                	lw	a5,44(s1)
    8000368e:	06f04763          	bgtz	a5,800036fc <end_op+0xbc>
    acquire(&log.lock);
    80003692:	0001a497          	auipc	s1,0x1a
    80003696:	58e48493          	addi	s1,s1,1422 # 8001dc20 <log>
    8000369a:	8526                	mv	a0,s1
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	ba8080e7          	jalr	-1112(ra) # 80006244 <acquire>
    log.committing = 0;
    800036a4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036a8:	8526                	mv	a0,s1
    800036aa:	ffffe097          	auipc	ra,0xffffe
    800036ae:	01c080e7          	jalr	28(ra) # 800016c6 <wakeup>
    release(&log.lock);
    800036b2:	8526                	mv	a0,s1
    800036b4:	00003097          	auipc	ra,0x3
    800036b8:	c44080e7          	jalr	-956(ra) # 800062f8 <release>
}
    800036bc:	70e2                	ld	ra,56(sp)
    800036be:	7442                	ld	s0,48(sp)
    800036c0:	74a2                	ld	s1,40(sp)
    800036c2:	7902                	ld	s2,32(sp)
    800036c4:	69e2                	ld	s3,24(sp)
    800036c6:	6a42                	ld	s4,16(sp)
    800036c8:	6aa2                	ld	s5,8(sp)
    800036ca:	6121                	addi	sp,sp,64
    800036cc:	8082                	ret
    panic("log.committing");
    800036ce:	00005517          	auipc	a0,0x5
    800036d2:	eea50513          	addi	a0,a0,-278 # 800085b8 <syscalls+0x1f0>
    800036d6:	00002097          	auipc	ra,0x2
    800036da:	5d4080e7          	jalr	1492(ra) # 80005caa <panic>
    wakeup(&log);
    800036de:	0001a497          	auipc	s1,0x1a
    800036e2:	54248493          	addi	s1,s1,1346 # 8001dc20 <log>
    800036e6:	8526                	mv	a0,s1
    800036e8:	ffffe097          	auipc	ra,0xffffe
    800036ec:	fde080e7          	jalr	-34(ra) # 800016c6 <wakeup>
  release(&log.lock);
    800036f0:	8526                	mv	a0,s1
    800036f2:	00003097          	auipc	ra,0x3
    800036f6:	c06080e7          	jalr	-1018(ra) # 800062f8 <release>
  if(do_commit){
    800036fa:	b7c9                	j	800036bc <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036fc:	0001aa97          	auipc	s5,0x1a
    80003700:	554a8a93          	addi	s5,s5,1364 # 8001dc50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003704:	0001aa17          	auipc	s4,0x1a
    80003708:	51ca0a13          	addi	s4,s4,1308 # 8001dc20 <log>
    8000370c:	018a2583          	lw	a1,24(s4)
    80003710:	012585bb          	addw	a1,a1,s2
    80003714:	2585                	addiw	a1,a1,1
    80003716:	028a2503          	lw	a0,40(s4)
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	cd2080e7          	jalr	-814(ra) # 800023ec <bread>
    80003722:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003724:	000aa583          	lw	a1,0(s5)
    80003728:	028a2503          	lw	a0,40(s4)
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	cc0080e7          	jalr	-832(ra) # 800023ec <bread>
    80003734:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003736:	40000613          	li	a2,1024
    8000373a:	05850593          	addi	a1,a0,88
    8000373e:	05848513          	addi	a0,s1,88
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	a96080e7          	jalr	-1386(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000374a:	8526                	mv	a0,s1
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	d92080e7          	jalr	-622(ra) # 800024de <bwrite>
    brelse(from);
    80003754:	854e                	mv	a0,s3
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	dc6080e7          	jalr	-570(ra) # 8000251c <brelse>
    brelse(to);
    8000375e:	8526                	mv	a0,s1
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	dbc080e7          	jalr	-580(ra) # 8000251c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003768:	2905                	addiw	s2,s2,1
    8000376a:	0a91                	addi	s5,s5,4
    8000376c:	02ca2783          	lw	a5,44(s4)
    80003770:	f8f94ee3          	blt	s2,a5,8000370c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c6a080e7          	jalr	-918(ra) # 800033de <write_head>
    install_trans(0); // Now install writes to home locations
    8000377c:	4501                	li	a0,0
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	cda080e7          	jalr	-806(ra) # 80003458 <install_trans>
    log.lh.n = 0;
    80003786:	0001a797          	auipc	a5,0x1a
    8000378a:	4c07a323          	sw	zero,1222(a5) # 8001dc4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	c50080e7          	jalr	-944(ra) # 800033de <write_head>
    80003796:	bdf5                	j	80003692 <end_op+0x52>

0000000080003798 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003798:	1101                	addi	sp,sp,-32
    8000379a:	ec06                	sd	ra,24(sp)
    8000379c:	e822                	sd	s0,16(sp)
    8000379e:	e426                	sd	s1,8(sp)
    800037a0:	e04a                	sd	s2,0(sp)
    800037a2:	1000                	addi	s0,sp,32
    800037a4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037a6:	0001a917          	auipc	s2,0x1a
    800037aa:	47a90913          	addi	s2,s2,1146 # 8001dc20 <log>
    800037ae:	854a                	mv	a0,s2
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	a94080e7          	jalr	-1388(ra) # 80006244 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037b8:	02c92603          	lw	a2,44(s2)
    800037bc:	47f5                	li	a5,29
    800037be:	06c7c563          	blt	a5,a2,80003828 <log_write+0x90>
    800037c2:	0001a797          	auipc	a5,0x1a
    800037c6:	47a7a783          	lw	a5,1146(a5) # 8001dc3c <log+0x1c>
    800037ca:	37fd                	addiw	a5,a5,-1
    800037cc:	04f65e63          	bge	a2,a5,80003828 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037d0:	0001a797          	auipc	a5,0x1a
    800037d4:	4707a783          	lw	a5,1136(a5) # 8001dc40 <log+0x20>
    800037d8:	06f05063          	blez	a5,80003838 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037dc:	4781                	li	a5,0
    800037de:	06c05563          	blez	a2,80003848 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e2:	44cc                	lw	a1,12(s1)
    800037e4:	0001a717          	auipc	a4,0x1a
    800037e8:	46c70713          	addi	a4,a4,1132 # 8001dc50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037ec:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ee:	4314                	lw	a3,0(a4)
    800037f0:	04b68c63          	beq	a3,a1,80003848 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037f4:	2785                	addiw	a5,a5,1
    800037f6:	0711                	addi	a4,a4,4
    800037f8:	fef61be3          	bne	a2,a5,800037ee <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037fc:	0621                	addi	a2,a2,8
    800037fe:	060a                	slli	a2,a2,0x2
    80003800:	0001a797          	auipc	a5,0x1a
    80003804:	42078793          	addi	a5,a5,1056 # 8001dc20 <log>
    80003808:	963e                	add	a2,a2,a5
    8000380a:	44dc                	lw	a5,12(s1)
    8000380c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000380e:	8526                	mv	a0,s1
    80003810:	fffff097          	auipc	ra,0xfffff
    80003814:	daa080e7          	jalr	-598(ra) # 800025ba <bpin>
    log.lh.n++;
    80003818:	0001a717          	auipc	a4,0x1a
    8000381c:	40870713          	addi	a4,a4,1032 # 8001dc20 <log>
    80003820:	575c                	lw	a5,44(a4)
    80003822:	2785                	addiw	a5,a5,1
    80003824:	d75c                	sw	a5,44(a4)
    80003826:	a835                	j	80003862 <log_write+0xca>
    panic("too big a transaction");
    80003828:	00005517          	auipc	a0,0x5
    8000382c:	da050513          	addi	a0,a0,-608 # 800085c8 <syscalls+0x200>
    80003830:	00002097          	auipc	ra,0x2
    80003834:	47a080e7          	jalr	1146(ra) # 80005caa <panic>
    panic("log_write outside of trans");
    80003838:	00005517          	auipc	a0,0x5
    8000383c:	da850513          	addi	a0,a0,-600 # 800085e0 <syscalls+0x218>
    80003840:	00002097          	auipc	ra,0x2
    80003844:	46a080e7          	jalr	1130(ra) # 80005caa <panic>
  log.lh.block[i] = b->blockno;
    80003848:	00878713          	addi	a4,a5,8
    8000384c:	00271693          	slli	a3,a4,0x2
    80003850:	0001a717          	auipc	a4,0x1a
    80003854:	3d070713          	addi	a4,a4,976 # 8001dc20 <log>
    80003858:	9736                	add	a4,a4,a3
    8000385a:	44d4                	lw	a3,12(s1)
    8000385c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000385e:	faf608e3          	beq	a2,a5,8000380e <log_write+0x76>
  }
  release(&log.lock);
    80003862:	0001a517          	auipc	a0,0x1a
    80003866:	3be50513          	addi	a0,a0,958 # 8001dc20 <log>
    8000386a:	00003097          	auipc	ra,0x3
    8000386e:	a8e080e7          	jalr	-1394(ra) # 800062f8 <release>
}
    80003872:	60e2                	ld	ra,24(sp)
    80003874:	6442                	ld	s0,16(sp)
    80003876:	64a2                	ld	s1,8(sp)
    80003878:	6902                	ld	s2,0(sp)
    8000387a:	6105                	addi	sp,sp,32
    8000387c:	8082                	ret

000000008000387e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000387e:	1101                	addi	sp,sp,-32
    80003880:	ec06                	sd	ra,24(sp)
    80003882:	e822                	sd	s0,16(sp)
    80003884:	e426                	sd	s1,8(sp)
    80003886:	e04a                	sd	s2,0(sp)
    80003888:	1000                	addi	s0,sp,32
    8000388a:	84aa                	mv	s1,a0
    8000388c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000388e:	00005597          	auipc	a1,0x5
    80003892:	d7258593          	addi	a1,a1,-654 # 80008600 <syscalls+0x238>
    80003896:	0521                	addi	a0,a0,8
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	91c080e7          	jalr	-1764(ra) # 800061b4 <initlock>
  lk->name = name;
    800038a0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038a8:	0204a423          	sw	zero,40(s1)
}
    800038ac:	60e2                	ld	ra,24(sp)
    800038ae:	6442                	ld	s0,16(sp)
    800038b0:	64a2                	ld	s1,8(sp)
    800038b2:	6902                	ld	s2,0(sp)
    800038b4:	6105                	addi	sp,sp,32
    800038b6:	8082                	ret

00000000800038b8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	e04a                	sd	s2,0(sp)
    800038c2:	1000                	addi	s0,sp,32
    800038c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c6:	00850913          	addi	s2,a0,8
    800038ca:	854a                	mv	a0,s2
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	978080e7          	jalr	-1672(ra) # 80006244 <acquire>
  while (lk->locked) {
    800038d4:	409c                	lw	a5,0(s1)
    800038d6:	cb89                	beqz	a5,800038e8 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038d8:	85ca                	mv	a1,s2
    800038da:	8526                	mv	a0,s1
    800038dc:	ffffe097          	auipc	ra,0xffffe
    800038e0:	c58080e7          	jalr	-936(ra) # 80001534 <sleep>
  while (lk->locked) {
    800038e4:	409c                	lw	a5,0(s1)
    800038e6:	fbed                	bnez	a5,800038d8 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038e8:	4785                	li	a5,1
    800038ea:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ec:	ffffd097          	auipc	ra,0xffffd
    800038f0:	55e080e7          	jalr	1374(ra) # 80000e4a <myproc>
    800038f4:	16052783          	lw	a5,352(a0)
    800038f8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038fa:	854a                	mv	a0,s2
    800038fc:	00003097          	auipc	ra,0x3
    80003900:	9fc080e7          	jalr	-1540(ra) # 800062f8 <release>
}
    80003904:	60e2                	ld	ra,24(sp)
    80003906:	6442                	ld	s0,16(sp)
    80003908:	64a2                	ld	s1,8(sp)
    8000390a:	6902                	ld	s2,0(sp)
    8000390c:	6105                	addi	sp,sp,32
    8000390e:	8082                	ret

0000000080003910 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003910:	1101                	addi	sp,sp,-32
    80003912:	ec06                	sd	ra,24(sp)
    80003914:	e822                	sd	s0,16(sp)
    80003916:	e426                	sd	s1,8(sp)
    80003918:	e04a                	sd	s2,0(sp)
    8000391a:	1000                	addi	s0,sp,32
    8000391c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000391e:	00850913          	addi	s2,a0,8
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	920080e7          	jalr	-1760(ra) # 80006244 <acquire>
  lk->locked = 0;
    8000392c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003930:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003934:	8526                	mv	a0,s1
    80003936:	ffffe097          	auipc	ra,0xffffe
    8000393a:	d90080e7          	jalr	-624(ra) # 800016c6 <wakeup>
  release(&lk->lk);
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	9b8080e7          	jalr	-1608(ra) # 800062f8 <release>
}
    80003948:	60e2                	ld	ra,24(sp)
    8000394a:	6442                	ld	s0,16(sp)
    8000394c:	64a2                	ld	s1,8(sp)
    8000394e:	6902                	ld	s2,0(sp)
    80003950:	6105                	addi	sp,sp,32
    80003952:	8082                	ret

0000000080003954 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003954:	7179                	addi	sp,sp,-48
    80003956:	f406                	sd	ra,40(sp)
    80003958:	f022                	sd	s0,32(sp)
    8000395a:	ec26                	sd	s1,24(sp)
    8000395c:	e84a                	sd	s2,16(sp)
    8000395e:	e44e                	sd	s3,8(sp)
    80003960:	1800                	addi	s0,sp,48
    80003962:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003964:	00850913          	addi	s2,a0,8
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	8da080e7          	jalr	-1830(ra) # 80006244 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003972:	409c                	lw	a5,0(s1)
    80003974:	ef99                	bnez	a5,80003992 <holdingsleep+0x3e>
    80003976:	4481                	li	s1,0
  release(&lk->lk);
    80003978:	854a                	mv	a0,s2
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	97e080e7          	jalr	-1666(ra) # 800062f8 <release>
  return r;
}
    80003982:	8526                	mv	a0,s1
    80003984:	70a2                	ld	ra,40(sp)
    80003986:	7402                	ld	s0,32(sp)
    80003988:	64e2                	ld	s1,24(sp)
    8000398a:	6942                	ld	s2,16(sp)
    8000398c:	69a2                	ld	s3,8(sp)
    8000398e:	6145                	addi	sp,sp,48
    80003990:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003992:	0284a983          	lw	s3,40(s1)
    80003996:	ffffd097          	auipc	ra,0xffffd
    8000399a:	4b4080e7          	jalr	1204(ra) # 80000e4a <myproc>
    8000399e:	16052483          	lw	s1,352(a0)
    800039a2:	413484b3          	sub	s1,s1,s3
    800039a6:	0014b493          	seqz	s1,s1
    800039aa:	b7f9                	j	80003978 <holdingsleep+0x24>

00000000800039ac <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039ac:	1141                	addi	sp,sp,-16
    800039ae:	e406                	sd	ra,8(sp)
    800039b0:	e022                	sd	s0,0(sp)
    800039b2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039b4:	00005597          	auipc	a1,0x5
    800039b8:	c5c58593          	addi	a1,a1,-932 # 80008610 <syscalls+0x248>
    800039bc:	0001a517          	auipc	a0,0x1a
    800039c0:	3ac50513          	addi	a0,a0,940 # 8001dd68 <ftable>
    800039c4:	00002097          	auipc	ra,0x2
    800039c8:	7f0080e7          	jalr	2032(ra) # 800061b4 <initlock>
}
    800039cc:	60a2                	ld	ra,8(sp)
    800039ce:	6402                	ld	s0,0(sp)
    800039d0:	0141                	addi	sp,sp,16
    800039d2:	8082                	ret

00000000800039d4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039d4:	1101                	addi	sp,sp,-32
    800039d6:	ec06                	sd	ra,24(sp)
    800039d8:	e822                	sd	s0,16(sp)
    800039da:	e426                	sd	s1,8(sp)
    800039dc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039de:	0001a517          	auipc	a0,0x1a
    800039e2:	38a50513          	addi	a0,a0,906 # 8001dd68 <ftable>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	85e080e7          	jalr	-1954(ra) # 80006244 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039ee:	0001a497          	auipc	s1,0x1a
    800039f2:	39248493          	addi	s1,s1,914 # 8001dd80 <ftable+0x18>
    800039f6:	0001b717          	auipc	a4,0x1b
    800039fa:	32a70713          	addi	a4,a4,810 # 8001ed20 <ftable+0xfb8>
    if(f->ref == 0){
    800039fe:	40dc                	lw	a5,4(s1)
    80003a00:	cf99                	beqz	a5,80003a1e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a02:	02848493          	addi	s1,s1,40
    80003a06:	fee49ce3          	bne	s1,a4,800039fe <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a0a:	0001a517          	auipc	a0,0x1a
    80003a0e:	35e50513          	addi	a0,a0,862 # 8001dd68 <ftable>
    80003a12:	00003097          	auipc	ra,0x3
    80003a16:	8e6080e7          	jalr	-1818(ra) # 800062f8 <release>
  return 0;
    80003a1a:	4481                	li	s1,0
    80003a1c:	a819                	j	80003a32 <filealloc+0x5e>
      f->ref = 1;
    80003a1e:	4785                	li	a5,1
    80003a20:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a22:	0001a517          	auipc	a0,0x1a
    80003a26:	34650513          	addi	a0,a0,838 # 8001dd68 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	8ce080e7          	jalr	-1842(ra) # 800062f8 <release>
}
    80003a32:	8526                	mv	a0,s1
    80003a34:	60e2                	ld	ra,24(sp)
    80003a36:	6442                	ld	s0,16(sp)
    80003a38:	64a2                	ld	s1,8(sp)
    80003a3a:	6105                	addi	sp,sp,32
    80003a3c:	8082                	ret

0000000080003a3e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a3e:	1101                	addi	sp,sp,-32
    80003a40:	ec06                	sd	ra,24(sp)
    80003a42:	e822                	sd	s0,16(sp)
    80003a44:	e426                	sd	s1,8(sp)
    80003a46:	1000                	addi	s0,sp,32
    80003a48:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a4a:	0001a517          	auipc	a0,0x1a
    80003a4e:	31e50513          	addi	a0,a0,798 # 8001dd68 <ftable>
    80003a52:	00002097          	auipc	ra,0x2
    80003a56:	7f2080e7          	jalr	2034(ra) # 80006244 <acquire>
  if(f->ref < 1)
    80003a5a:	40dc                	lw	a5,4(s1)
    80003a5c:	02f05263          	blez	a5,80003a80 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a60:	2785                	addiw	a5,a5,1
    80003a62:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a64:	0001a517          	auipc	a0,0x1a
    80003a68:	30450513          	addi	a0,a0,772 # 8001dd68 <ftable>
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	88c080e7          	jalr	-1908(ra) # 800062f8 <release>
  return f;
}
    80003a74:	8526                	mv	a0,s1
    80003a76:	60e2                	ld	ra,24(sp)
    80003a78:	6442                	ld	s0,16(sp)
    80003a7a:	64a2                	ld	s1,8(sp)
    80003a7c:	6105                	addi	sp,sp,32
    80003a7e:	8082                	ret
    panic("filedup");
    80003a80:	00005517          	auipc	a0,0x5
    80003a84:	b9850513          	addi	a0,a0,-1128 # 80008618 <syscalls+0x250>
    80003a88:	00002097          	auipc	ra,0x2
    80003a8c:	222080e7          	jalr	546(ra) # 80005caa <panic>

0000000080003a90 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a90:	7139                	addi	sp,sp,-64
    80003a92:	fc06                	sd	ra,56(sp)
    80003a94:	f822                	sd	s0,48(sp)
    80003a96:	f426                	sd	s1,40(sp)
    80003a98:	f04a                	sd	s2,32(sp)
    80003a9a:	ec4e                	sd	s3,24(sp)
    80003a9c:	e852                	sd	s4,16(sp)
    80003a9e:	e456                	sd	s5,8(sp)
    80003aa0:	0080                	addi	s0,sp,64
    80003aa2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aa4:	0001a517          	auipc	a0,0x1a
    80003aa8:	2c450513          	addi	a0,a0,708 # 8001dd68 <ftable>
    80003aac:	00002097          	auipc	ra,0x2
    80003ab0:	798080e7          	jalr	1944(ra) # 80006244 <acquire>
  if(f->ref < 1)
    80003ab4:	40dc                	lw	a5,4(s1)
    80003ab6:	06f05163          	blez	a5,80003b18 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aba:	37fd                	addiw	a5,a5,-1
    80003abc:	0007871b          	sext.w	a4,a5
    80003ac0:	c0dc                	sw	a5,4(s1)
    80003ac2:	06e04363          	bgtz	a4,80003b28 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ac6:	0004a903          	lw	s2,0(s1)
    80003aca:	0094ca83          	lbu	s5,9(s1)
    80003ace:	0104ba03          	ld	s4,16(s1)
    80003ad2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ad6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ada:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ade:	0001a517          	auipc	a0,0x1a
    80003ae2:	28a50513          	addi	a0,a0,650 # 8001dd68 <ftable>
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	812080e7          	jalr	-2030(ra) # 800062f8 <release>

  if(ff.type == FD_PIPE){
    80003aee:	4785                	li	a5,1
    80003af0:	04f90d63          	beq	s2,a5,80003b4a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003af4:	3979                	addiw	s2,s2,-2
    80003af6:	4785                	li	a5,1
    80003af8:	0527e063          	bltu	a5,s2,80003b38 <fileclose+0xa8>
    begin_op();
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	ac4080e7          	jalr	-1340(ra) # 800035c0 <begin_op>
    iput(ff.ip);
    80003b04:	854e                	mv	a0,s3
    80003b06:	fffff097          	auipc	ra,0xfffff
    80003b0a:	2a2080e7          	jalr	674(ra) # 80002da8 <iput>
    end_op();
    80003b0e:	00000097          	auipc	ra,0x0
    80003b12:	b32080e7          	jalr	-1230(ra) # 80003640 <end_op>
    80003b16:	a00d                	j	80003b38 <fileclose+0xa8>
    panic("fileclose");
    80003b18:	00005517          	auipc	a0,0x5
    80003b1c:	b0850513          	addi	a0,a0,-1272 # 80008620 <syscalls+0x258>
    80003b20:	00002097          	auipc	ra,0x2
    80003b24:	18a080e7          	jalr	394(ra) # 80005caa <panic>
    release(&ftable.lock);
    80003b28:	0001a517          	auipc	a0,0x1a
    80003b2c:	24050513          	addi	a0,a0,576 # 8001dd68 <ftable>
    80003b30:	00002097          	auipc	ra,0x2
    80003b34:	7c8080e7          	jalr	1992(ra) # 800062f8 <release>
  }
}
    80003b38:	70e2                	ld	ra,56(sp)
    80003b3a:	7442                	ld	s0,48(sp)
    80003b3c:	74a2                	ld	s1,40(sp)
    80003b3e:	7902                	ld	s2,32(sp)
    80003b40:	69e2                	ld	s3,24(sp)
    80003b42:	6a42                	ld	s4,16(sp)
    80003b44:	6aa2                	ld	s5,8(sp)
    80003b46:	6121                	addi	sp,sp,64
    80003b48:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b4a:	85d6                	mv	a1,s5
    80003b4c:	8552                	mv	a0,s4
    80003b4e:	00000097          	auipc	ra,0x0
    80003b52:	34c080e7          	jalr	844(ra) # 80003e9a <pipeclose>
    80003b56:	b7cd                	j	80003b38 <fileclose+0xa8>

0000000080003b58 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b58:	715d                	addi	sp,sp,-80
    80003b5a:	e486                	sd	ra,72(sp)
    80003b5c:	e0a2                	sd	s0,64(sp)
    80003b5e:	fc26                	sd	s1,56(sp)
    80003b60:	f84a                	sd	s2,48(sp)
    80003b62:	f44e                	sd	s3,40(sp)
    80003b64:	0880                	addi	s0,sp,80
    80003b66:	84aa                	mv	s1,a0
    80003b68:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b6a:	ffffd097          	auipc	ra,0xffffd
    80003b6e:	2e0080e7          	jalr	736(ra) # 80000e4a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b72:	409c                	lw	a5,0(s1)
    80003b74:	37f9                	addiw	a5,a5,-2
    80003b76:	4705                	li	a4,1
    80003b78:	04f76763          	bltu	a4,a5,80003bc6 <filestat+0x6e>
    80003b7c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b7e:	6c88                	ld	a0,24(s1)
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	06e080e7          	jalr	110(ra) # 80002bee <ilock>
    stati(f->ip, &st);
    80003b88:	fb840593          	addi	a1,s0,-72
    80003b8c:	6c88                	ld	a0,24(s1)
    80003b8e:	fffff097          	auipc	ra,0xfffff
    80003b92:	2ea080e7          	jalr	746(ra) # 80002e78 <stati>
    iunlock(f->ip);
    80003b96:	6c88                	ld	a0,24(s1)
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	118080e7          	jalr	280(ra) # 80002cb0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ba0:	46e1                	li	a3,24
    80003ba2:	fb840613          	addi	a2,s0,-72
    80003ba6:	85ce                	mv	a1,s3
    80003ba8:	18093503          	ld	a0,384(s2)
    80003bac:	ffffd097          	auipc	ra,0xffffd
    80003bb0:	f5e080e7          	jalr	-162(ra) # 80000b0a <copyout>
    80003bb4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bb8:	60a6                	ld	ra,72(sp)
    80003bba:	6406                	ld	s0,64(sp)
    80003bbc:	74e2                	ld	s1,56(sp)
    80003bbe:	7942                	ld	s2,48(sp)
    80003bc0:	79a2                	ld	s3,40(sp)
    80003bc2:	6161                	addi	sp,sp,80
    80003bc4:	8082                	ret
  return -1;
    80003bc6:	557d                	li	a0,-1
    80003bc8:	bfc5                	j	80003bb8 <filestat+0x60>

0000000080003bca <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bca:	7179                	addi	sp,sp,-48
    80003bcc:	f406                	sd	ra,40(sp)
    80003bce:	f022                	sd	s0,32(sp)
    80003bd0:	ec26                	sd	s1,24(sp)
    80003bd2:	e84a                	sd	s2,16(sp)
    80003bd4:	e44e                	sd	s3,8(sp)
    80003bd6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bd8:	00854783          	lbu	a5,8(a0)
    80003bdc:	c3d5                	beqz	a5,80003c80 <fileread+0xb6>
    80003bde:	84aa                	mv	s1,a0
    80003be0:	89ae                	mv	s3,a1
    80003be2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003be4:	411c                	lw	a5,0(a0)
    80003be6:	4705                	li	a4,1
    80003be8:	04e78963          	beq	a5,a4,80003c3a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bec:	470d                	li	a4,3
    80003bee:	04e78d63          	beq	a5,a4,80003c48 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bf2:	4709                	li	a4,2
    80003bf4:	06e79e63          	bne	a5,a4,80003c70 <fileread+0xa6>
    ilock(f->ip);
    80003bf8:	6d08                	ld	a0,24(a0)
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	ff4080e7          	jalr	-12(ra) # 80002bee <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c02:	874a                	mv	a4,s2
    80003c04:	5094                	lw	a3,32(s1)
    80003c06:	864e                	mv	a2,s3
    80003c08:	4585                	li	a1,1
    80003c0a:	6c88                	ld	a0,24(s1)
    80003c0c:	fffff097          	auipc	ra,0xfffff
    80003c10:	296080e7          	jalr	662(ra) # 80002ea2 <readi>
    80003c14:	892a                	mv	s2,a0
    80003c16:	00a05563          	blez	a0,80003c20 <fileread+0x56>
      f->off += r;
    80003c1a:	509c                	lw	a5,32(s1)
    80003c1c:	9fa9                	addw	a5,a5,a0
    80003c1e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c20:	6c88                	ld	a0,24(s1)
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	08e080e7          	jalr	142(ra) # 80002cb0 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c2a:	854a                	mv	a0,s2
    80003c2c:	70a2                	ld	ra,40(sp)
    80003c2e:	7402                	ld	s0,32(sp)
    80003c30:	64e2                	ld	s1,24(sp)
    80003c32:	6942                	ld	s2,16(sp)
    80003c34:	69a2                	ld	s3,8(sp)
    80003c36:	6145                	addi	sp,sp,48
    80003c38:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c3a:	6908                	ld	a0,16(a0)
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	3c8080e7          	jalr	968(ra) # 80004004 <piperead>
    80003c44:	892a                	mv	s2,a0
    80003c46:	b7d5                	j	80003c2a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c48:	02451783          	lh	a5,36(a0)
    80003c4c:	03079693          	slli	a3,a5,0x30
    80003c50:	92c1                	srli	a3,a3,0x30
    80003c52:	4725                	li	a4,9
    80003c54:	02d76863          	bltu	a4,a3,80003c84 <fileread+0xba>
    80003c58:	0792                	slli	a5,a5,0x4
    80003c5a:	0001a717          	auipc	a4,0x1a
    80003c5e:	06e70713          	addi	a4,a4,110 # 8001dcc8 <devsw>
    80003c62:	97ba                	add	a5,a5,a4
    80003c64:	639c                	ld	a5,0(a5)
    80003c66:	c38d                	beqz	a5,80003c88 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c68:	4505                	li	a0,1
    80003c6a:	9782                	jalr	a5
    80003c6c:	892a                	mv	s2,a0
    80003c6e:	bf75                	j	80003c2a <fileread+0x60>
    panic("fileread");
    80003c70:	00005517          	auipc	a0,0x5
    80003c74:	9c050513          	addi	a0,a0,-1600 # 80008630 <syscalls+0x268>
    80003c78:	00002097          	auipc	ra,0x2
    80003c7c:	032080e7          	jalr	50(ra) # 80005caa <panic>
    return -1;
    80003c80:	597d                	li	s2,-1
    80003c82:	b765                	j	80003c2a <fileread+0x60>
      return -1;
    80003c84:	597d                	li	s2,-1
    80003c86:	b755                	j	80003c2a <fileread+0x60>
    80003c88:	597d                	li	s2,-1
    80003c8a:	b745                	j	80003c2a <fileread+0x60>

0000000080003c8c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c8c:	715d                	addi	sp,sp,-80
    80003c8e:	e486                	sd	ra,72(sp)
    80003c90:	e0a2                	sd	s0,64(sp)
    80003c92:	fc26                	sd	s1,56(sp)
    80003c94:	f84a                	sd	s2,48(sp)
    80003c96:	f44e                	sd	s3,40(sp)
    80003c98:	f052                	sd	s4,32(sp)
    80003c9a:	ec56                	sd	s5,24(sp)
    80003c9c:	e85a                	sd	s6,16(sp)
    80003c9e:	e45e                	sd	s7,8(sp)
    80003ca0:	e062                	sd	s8,0(sp)
    80003ca2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003ca4:	00954783          	lbu	a5,9(a0)
    80003ca8:	10078663          	beqz	a5,80003db4 <filewrite+0x128>
    80003cac:	892a                	mv	s2,a0
    80003cae:	8aae                	mv	s5,a1
    80003cb0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cb2:	411c                	lw	a5,0(a0)
    80003cb4:	4705                	li	a4,1
    80003cb6:	02e78263          	beq	a5,a4,80003cda <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cba:	470d                	li	a4,3
    80003cbc:	02e78663          	beq	a5,a4,80003ce8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cc0:	4709                	li	a4,2
    80003cc2:	0ee79163          	bne	a5,a4,80003da4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cc6:	0ac05d63          	blez	a2,80003d80 <filewrite+0xf4>
    int i = 0;
    80003cca:	4981                	li	s3,0
    80003ccc:	6b05                	lui	s6,0x1
    80003cce:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cd2:	6b85                	lui	s7,0x1
    80003cd4:	c00b8b9b          	addiw	s7,s7,-1024
    80003cd8:	a861                	j	80003d70 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cda:	6908                	ld	a0,16(a0)
    80003cdc:	00000097          	auipc	ra,0x0
    80003ce0:	22e080e7          	jalr	558(ra) # 80003f0a <pipewrite>
    80003ce4:	8a2a                	mv	s4,a0
    80003ce6:	a045                	j	80003d86 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce8:	02451783          	lh	a5,36(a0)
    80003cec:	03079693          	slli	a3,a5,0x30
    80003cf0:	92c1                	srli	a3,a3,0x30
    80003cf2:	4725                	li	a4,9
    80003cf4:	0cd76263          	bltu	a4,a3,80003db8 <filewrite+0x12c>
    80003cf8:	0792                	slli	a5,a5,0x4
    80003cfa:	0001a717          	auipc	a4,0x1a
    80003cfe:	fce70713          	addi	a4,a4,-50 # 8001dcc8 <devsw>
    80003d02:	97ba                	add	a5,a5,a4
    80003d04:	679c                	ld	a5,8(a5)
    80003d06:	cbdd                	beqz	a5,80003dbc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d08:	4505                	li	a0,1
    80003d0a:	9782                	jalr	a5
    80003d0c:	8a2a                	mv	s4,a0
    80003d0e:	a8a5                	j	80003d86 <filewrite+0xfa>
    80003d10:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	8ac080e7          	jalr	-1876(ra) # 800035c0 <begin_op>
      ilock(f->ip);
    80003d1c:	01893503          	ld	a0,24(s2)
    80003d20:	fffff097          	auipc	ra,0xfffff
    80003d24:	ece080e7          	jalr	-306(ra) # 80002bee <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d28:	8762                	mv	a4,s8
    80003d2a:	02092683          	lw	a3,32(s2)
    80003d2e:	01598633          	add	a2,s3,s5
    80003d32:	4585                	li	a1,1
    80003d34:	01893503          	ld	a0,24(s2)
    80003d38:	fffff097          	auipc	ra,0xfffff
    80003d3c:	262080e7          	jalr	610(ra) # 80002f9a <writei>
    80003d40:	84aa                	mv	s1,a0
    80003d42:	00a05763          	blez	a0,80003d50 <filewrite+0xc4>
        f->off += r;
    80003d46:	02092783          	lw	a5,32(s2)
    80003d4a:	9fa9                	addw	a5,a5,a0
    80003d4c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d50:	01893503          	ld	a0,24(s2)
    80003d54:	fffff097          	auipc	ra,0xfffff
    80003d58:	f5c080e7          	jalr	-164(ra) # 80002cb0 <iunlock>
      end_op();
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	8e4080e7          	jalr	-1820(ra) # 80003640 <end_op>

      if(r != n1){
    80003d64:	009c1f63          	bne	s8,s1,80003d82 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d68:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d6c:	0149db63          	bge	s3,s4,80003d82 <filewrite+0xf6>
      int n1 = n - i;
    80003d70:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d74:	84be                	mv	s1,a5
    80003d76:	2781                	sext.w	a5,a5
    80003d78:	f8fb5ce3          	bge	s6,a5,80003d10 <filewrite+0x84>
    80003d7c:	84de                	mv	s1,s7
    80003d7e:	bf49                	j	80003d10 <filewrite+0x84>
    int i = 0;
    80003d80:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d82:	013a1f63          	bne	s4,s3,80003da0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d86:	8552                	mv	a0,s4
    80003d88:	60a6                	ld	ra,72(sp)
    80003d8a:	6406                	ld	s0,64(sp)
    80003d8c:	74e2                	ld	s1,56(sp)
    80003d8e:	7942                	ld	s2,48(sp)
    80003d90:	79a2                	ld	s3,40(sp)
    80003d92:	7a02                	ld	s4,32(sp)
    80003d94:	6ae2                	ld	s5,24(sp)
    80003d96:	6b42                	ld	s6,16(sp)
    80003d98:	6ba2                	ld	s7,8(sp)
    80003d9a:	6c02                	ld	s8,0(sp)
    80003d9c:	6161                	addi	sp,sp,80
    80003d9e:	8082                	ret
    ret = (i == n ? n : -1);
    80003da0:	5a7d                	li	s4,-1
    80003da2:	b7d5                	j	80003d86 <filewrite+0xfa>
    panic("filewrite");
    80003da4:	00005517          	auipc	a0,0x5
    80003da8:	89c50513          	addi	a0,a0,-1892 # 80008640 <syscalls+0x278>
    80003dac:	00002097          	auipc	ra,0x2
    80003db0:	efe080e7          	jalr	-258(ra) # 80005caa <panic>
    return -1;
    80003db4:	5a7d                	li	s4,-1
    80003db6:	bfc1                	j	80003d86 <filewrite+0xfa>
      return -1;
    80003db8:	5a7d                	li	s4,-1
    80003dba:	b7f1                	j	80003d86 <filewrite+0xfa>
    80003dbc:	5a7d                	li	s4,-1
    80003dbe:	b7e1                	j	80003d86 <filewrite+0xfa>

0000000080003dc0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dc0:	7179                	addi	sp,sp,-48
    80003dc2:	f406                	sd	ra,40(sp)
    80003dc4:	f022                	sd	s0,32(sp)
    80003dc6:	ec26                	sd	s1,24(sp)
    80003dc8:	e84a                	sd	s2,16(sp)
    80003dca:	e44e                	sd	s3,8(sp)
    80003dcc:	e052                	sd	s4,0(sp)
    80003dce:	1800                	addi	s0,sp,48
    80003dd0:	84aa                	mv	s1,a0
    80003dd2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dd4:	0005b023          	sd	zero,0(a1)
    80003dd8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	bf8080e7          	jalr	-1032(ra) # 800039d4 <filealloc>
    80003de4:	e088                	sd	a0,0(s1)
    80003de6:	c551                	beqz	a0,80003e72 <pipealloc+0xb2>
    80003de8:	00000097          	auipc	ra,0x0
    80003dec:	bec080e7          	jalr	-1044(ra) # 800039d4 <filealloc>
    80003df0:	00aa3023          	sd	a0,0(s4)
    80003df4:	c92d                	beqz	a0,80003e66 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003df6:	ffffc097          	auipc	ra,0xffffc
    80003dfa:	322080e7          	jalr	802(ra) # 80000118 <kalloc>
    80003dfe:	892a                	mv	s2,a0
    80003e00:	c125                	beqz	a0,80003e60 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e02:	4985                	li	s3,1
    80003e04:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e08:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e0c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e10:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e14:	00005597          	auipc	a1,0x5
    80003e18:	83c58593          	addi	a1,a1,-1988 # 80008650 <syscalls+0x288>
    80003e1c:	00002097          	auipc	ra,0x2
    80003e20:	398080e7          	jalr	920(ra) # 800061b4 <initlock>
  (*f0)->type = FD_PIPE;
    80003e24:	609c                	ld	a5,0(s1)
    80003e26:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e2a:	609c                	ld	a5,0(s1)
    80003e2c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e30:	609c                	ld	a5,0(s1)
    80003e32:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e36:	609c                	ld	a5,0(s1)
    80003e38:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e3c:	000a3783          	ld	a5,0(s4)
    80003e40:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e44:	000a3783          	ld	a5,0(s4)
    80003e48:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e4c:	000a3783          	ld	a5,0(s4)
    80003e50:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e54:	000a3783          	ld	a5,0(s4)
    80003e58:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e5c:	4501                	li	a0,0
    80003e5e:	a025                	j	80003e86 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e60:	6088                	ld	a0,0(s1)
    80003e62:	e501                	bnez	a0,80003e6a <pipealloc+0xaa>
    80003e64:	a039                	j	80003e72 <pipealloc+0xb2>
    80003e66:	6088                	ld	a0,0(s1)
    80003e68:	c51d                	beqz	a0,80003e96 <pipealloc+0xd6>
    fileclose(*f0);
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	c26080e7          	jalr	-986(ra) # 80003a90 <fileclose>
  if(*f1)
    80003e72:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e76:	557d                	li	a0,-1
  if(*f1)
    80003e78:	c799                	beqz	a5,80003e86 <pipealloc+0xc6>
    fileclose(*f1);
    80003e7a:	853e                	mv	a0,a5
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	c14080e7          	jalr	-1004(ra) # 80003a90 <fileclose>
  return -1;
    80003e84:	557d                	li	a0,-1
}
    80003e86:	70a2                	ld	ra,40(sp)
    80003e88:	7402                	ld	s0,32(sp)
    80003e8a:	64e2                	ld	s1,24(sp)
    80003e8c:	6942                	ld	s2,16(sp)
    80003e8e:	69a2                	ld	s3,8(sp)
    80003e90:	6a02                	ld	s4,0(sp)
    80003e92:	6145                	addi	sp,sp,48
    80003e94:	8082                	ret
  return -1;
    80003e96:	557d                	li	a0,-1
    80003e98:	b7fd                	j	80003e86 <pipealloc+0xc6>

0000000080003e9a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e9a:	1101                	addi	sp,sp,-32
    80003e9c:	ec06                	sd	ra,24(sp)
    80003e9e:	e822                	sd	s0,16(sp)
    80003ea0:	e426                	sd	s1,8(sp)
    80003ea2:	e04a                	sd	s2,0(sp)
    80003ea4:	1000                	addi	s0,sp,32
    80003ea6:	84aa                	mv	s1,a0
    80003ea8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eaa:	00002097          	auipc	ra,0x2
    80003eae:	39a080e7          	jalr	922(ra) # 80006244 <acquire>
  if(writable){
    80003eb2:	02090d63          	beqz	s2,80003eec <pipeclose+0x52>
    pi->writeopen = 0;
    80003eb6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eba:	21848513          	addi	a0,s1,536
    80003ebe:	ffffe097          	auipc	ra,0xffffe
    80003ec2:	808080e7          	jalr	-2040(ra) # 800016c6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ec6:	2204b783          	ld	a5,544(s1)
    80003eca:	eb95                	bnez	a5,80003efe <pipeclose+0x64>
    release(&pi->lock);
    80003ecc:	8526                	mv	a0,s1
    80003ece:	00002097          	auipc	ra,0x2
    80003ed2:	42a080e7          	jalr	1066(ra) # 800062f8 <release>
    kfree((char*)pi);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	ffffc097          	auipc	ra,0xffffc
    80003edc:	144080e7          	jalr	324(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ee0:	60e2                	ld	ra,24(sp)
    80003ee2:	6442                	ld	s0,16(sp)
    80003ee4:	64a2                	ld	s1,8(sp)
    80003ee6:	6902                	ld	s2,0(sp)
    80003ee8:	6105                	addi	sp,sp,32
    80003eea:	8082                	ret
    pi->readopen = 0;
    80003eec:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ef0:	21c48513          	addi	a0,s1,540
    80003ef4:	ffffd097          	auipc	ra,0xffffd
    80003ef8:	7d2080e7          	jalr	2002(ra) # 800016c6 <wakeup>
    80003efc:	b7e9                	j	80003ec6 <pipeclose+0x2c>
    release(&pi->lock);
    80003efe:	8526                	mv	a0,s1
    80003f00:	00002097          	auipc	ra,0x2
    80003f04:	3f8080e7          	jalr	1016(ra) # 800062f8 <release>
}
    80003f08:	bfe1                	j	80003ee0 <pipeclose+0x46>

0000000080003f0a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f0a:	7159                	addi	sp,sp,-112
    80003f0c:	f486                	sd	ra,104(sp)
    80003f0e:	f0a2                	sd	s0,96(sp)
    80003f10:	eca6                	sd	s1,88(sp)
    80003f12:	e8ca                	sd	s2,80(sp)
    80003f14:	e4ce                	sd	s3,72(sp)
    80003f16:	e0d2                	sd	s4,64(sp)
    80003f18:	fc56                	sd	s5,56(sp)
    80003f1a:	f85a                	sd	s6,48(sp)
    80003f1c:	f45e                	sd	s7,40(sp)
    80003f1e:	f062                	sd	s8,32(sp)
    80003f20:	ec66                	sd	s9,24(sp)
    80003f22:	1880                	addi	s0,sp,112
    80003f24:	84aa                	mv	s1,a0
    80003f26:	8aae                	mv	s5,a1
    80003f28:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f2a:	ffffd097          	auipc	ra,0xffffd
    80003f2e:	f20080e7          	jalr	-224(ra) # 80000e4a <myproc>
    80003f32:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f34:	8526                	mv	a0,s1
    80003f36:	00002097          	auipc	ra,0x2
    80003f3a:	30e080e7          	jalr	782(ra) # 80006244 <acquire>
  while(i < n){
    80003f3e:	0d405163          	blez	s4,80004000 <pipewrite+0xf6>
    80003f42:	8ba6                	mv	s7,s1
  int i = 0;
    80003f44:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f46:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f48:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f4c:	21c48c13          	addi	s8,s1,540
    80003f50:	a08d                	j	80003fb2 <pipewrite+0xa8>
      release(&pi->lock);
    80003f52:	8526                	mv	a0,s1
    80003f54:	00002097          	auipc	ra,0x2
    80003f58:	3a4080e7          	jalr	932(ra) # 800062f8 <release>
      return -1;
    80003f5c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f5e:	854a                	mv	a0,s2
    80003f60:	70a6                	ld	ra,104(sp)
    80003f62:	7406                	ld	s0,96(sp)
    80003f64:	64e6                	ld	s1,88(sp)
    80003f66:	6946                	ld	s2,80(sp)
    80003f68:	69a6                	ld	s3,72(sp)
    80003f6a:	6a06                	ld	s4,64(sp)
    80003f6c:	7ae2                	ld	s5,56(sp)
    80003f6e:	7b42                	ld	s6,48(sp)
    80003f70:	7ba2                	ld	s7,40(sp)
    80003f72:	7c02                	ld	s8,32(sp)
    80003f74:	6ce2                	ld	s9,24(sp)
    80003f76:	6165                	addi	sp,sp,112
    80003f78:	8082                	ret
      wakeup(&pi->nread);
    80003f7a:	8566                	mv	a0,s9
    80003f7c:	ffffd097          	auipc	ra,0xffffd
    80003f80:	74a080e7          	jalr	1866(ra) # 800016c6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f84:	85de                	mv	a1,s7
    80003f86:	8562                	mv	a0,s8
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	5ac080e7          	jalr	1452(ra) # 80001534 <sleep>
    80003f90:	a839                	j	80003fae <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f92:	21c4a783          	lw	a5,540(s1)
    80003f96:	0017871b          	addiw	a4,a5,1
    80003f9a:	20e4ae23          	sw	a4,540(s1)
    80003f9e:	1ff7f793          	andi	a5,a5,511
    80003fa2:	97a6                	add	a5,a5,s1
    80003fa4:	f9f44703          	lbu	a4,-97(s0)
    80003fa8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fac:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fae:	03495d63          	bge	s2,s4,80003fe8 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003fb2:	2204a783          	lw	a5,544(s1)
    80003fb6:	dfd1                	beqz	a5,80003f52 <pipewrite+0x48>
    80003fb8:	1589a783          	lw	a5,344(s3)
    80003fbc:	fbd9                	bnez	a5,80003f52 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fbe:	2184a783          	lw	a5,536(s1)
    80003fc2:	21c4a703          	lw	a4,540(s1)
    80003fc6:	2007879b          	addiw	a5,a5,512
    80003fca:	faf708e3          	beq	a4,a5,80003f7a <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fce:	4685                	li	a3,1
    80003fd0:	01590633          	add	a2,s2,s5
    80003fd4:	f9f40593          	addi	a1,s0,-97
    80003fd8:	1809b503          	ld	a0,384(s3)
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	bba080e7          	jalr	-1094(ra) # 80000b96 <copyin>
    80003fe4:	fb6517e3          	bne	a0,s6,80003f92 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fe8:	21848513          	addi	a0,s1,536
    80003fec:	ffffd097          	auipc	ra,0xffffd
    80003ff0:	6da080e7          	jalr	1754(ra) # 800016c6 <wakeup>
  release(&pi->lock);
    80003ff4:	8526                	mv	a0,s1
    80003ff6:	00002097          	auipc	ra,0x2
    80003ffa:	302080e7          	jalr	770(ra) # 800062f8 <release>
  return i;
    80003ffe:	b785                	j	80003f5e <pipewrite+0x54>
  int i = 0;
    80004000:	4901                	li	s2,0
    80004002:	b7dd                	j	80003fe8 <pipewrite+0xde>

0000000080004004 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004004:	715d                	addi	sp,sp,-80
    80004006:	e486                	sd	ra,72(sp)
    80004008:	e0a2                	sd	s0,64(sp)
    8000400a:	fc26                	sd	s1,56(sp)
    8000400c:	f84a                	sd	s2,48(sp)
    8000400e:	f44e                	sd	s3,40(sp)
    80004010:	f052                	sd	s4,32(sp)
    80004012:	ec56                	sd	s5,24(sp)
    80004014:	e85a                	sd	s6,16(sp)
    80004016:	0880                	addi	s0,sp,80
    80004018:	84aa                	mv	s1,a0
    8000401a:	892e                	mv	s2,a1
    8000401c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	e2c080e7          	jalr	-468(ra) # 80000e4a <myproc>
    80004026:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004028:	8b26                	mv	s6,s1
    8000402a:	8526                	mv	a0,s1
    8000402c:	00002097          	auipc	ra,0x2
    80004030:	218080e7          	jalr	536(ra) # 80006244 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004034:	2184a703          	lw	a4,536(s1)
    80004038:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000403c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004040:	02f71463          	bne	a4,a5,80004068 <piperead+0x64>
    80004044:	2244a783          	lw	a5,548(s1)
    80004048:	c385                	beqz	a5,80004068 <piperead+0x64>
    if(pr->killed){
    8000404a:	158a2783          	lw	a5,344(s4)
    8000404e:	ebc1                	bnez	a5,800040de <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004050:	85da                	mv	a1,s6
    80004052:	854e                	mv	a0,s3
    80004054:	ffffd097          	auipc	ra,0xffffd
    80004058:	4e0080e7          	jalr	1248(ra) # 80001534 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000405c:	2184a703          	lw	a4,536(s1)
    80004060:	21c4a783          	lw	a5,540(s1)
    80004064:	fef700e3          	beq	a4,a5,80004044 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004068:	09505263          	blez	s5,800040ec <piperead+0xe8>
    8000406c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000406e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004070:	2184a783          	lw	a5,536(s1)
    80004074:	21c4a703          	lw	a4,540(s1)
    80004078:	02f70d63          	beq	a4,a5,800040b2 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000407c:	0017871b          	addiw	a4,a5,1
    80004080:	20e4ac23          	sw	a4,536(s1)
    80004084:	1ff7f793          	andi	a5,a5,511
    80004088:	97a6                	add	a5,a5,s1
    8000408a:	0187c783          	lbu	a5,24(a5)
    8000408e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004092:	4685                	li	a3,1
    80004094:	fbf40613          	addi	a2,s0,-65
    80004098:	85ca                	mv	a1,s2
    8000409a:	180a3503          	ld	a0,384(s4)
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	a6c080e7          	jalr	-1428(ra) # 80000b0a <copyout>
    800040a6:	01650663          	beq	a0,s6,800040b2 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040aa:	2985                	addiw	s3,s3,1
    800040ac:	0905                	addi	s2,s2,1
    800040ae:	fd3a91e3          	bne	s5,s3,80004070 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040b2:	21c48513          	addi	a0,s1,540
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	610080e7          	jalr	1552(ra) # 800016c6 <wakeup>
  release(&pi->lock);
    800040be:	8526                	mv	a0,s1
    800040c0:	00002097          	auipc	ra,0x2
    800040c4:	238080e7          	jalr	568(ra) # 800062f8 <release>
  return i;
}
    800040c8:	854e                	mv	a0,s3
    800040ca:	60a6                	ld	ra,72(sp)
    800040cc:	6406                	ld	s0,64(sp)
    800040ce:	74e2                	ld	s1,56(sp)
    800040d0:	7942                	ld	s2,48(sp)
    800040d2:	79a2                	ld	s3,40(sp)
    800040d4:	7a02                	ld	s4,32(sp)
    800040d6:	6ae2                	ld	s5,24(sp)
    800040d8:	6b42                	ld	s6,16(sp)
    800040da:	6161                	addi	sp,sp,80
    800040dc:	8082                	ret
      release(&pi->lock);
    800040de:	8526                	mv	a0,s1
    800040e0:	00002097          	auipc	ra,0x2
    800040e4:	218080e7          	jalr	536(ra) # 800062f8 <release>
      return -1;
    800040e8:	59fd                	li	s3,-1
    800040ea:	bff9                	j	800040c8 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ec:	4981                	li	s3,0
    800040ee:	b7d1                	j	800040b2 <piperead+0xae>

00000000800040f0 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040f0:	df010113          	addi	sp,sp,-528
    800040f4:	20113423          	sd	ra,520(sp)
    800040f8:	20813023          	sd	s0,512(sp)
    800040fc:	ffa6                	sd	s1,504(sp)
    800040fe:	fbca                	sd	s2,496(sp)
    80004100:	f7ce                	sd	s3,488(sp)
    80004102:	f3d2                	sd	s4,480(sp)
    80004104:	efd6                	sd	s5,472(sp)
    80004106:	ebda                	sd	s6,464(sp)
    80004108:	e7de                	sd	s7,456(sp)
    8000410a:	e3e2                	sd	s8,448(sp)
    8000410c:	ff66                	sd	s9,440(sp)
    8000410e:	fb6a                	sd	s10,432(sp)
    80004110:	f76e                	sd	s11,424(sp)
    80004112:	0c00                	addi	s0,sp,528
    80004114:	84aa                	mv	s1,a0
    80004116:	dea43c23          	sd	a0,-520(s0)
    8000411a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000411e:	ffffd097          	auipc	ra,0xffffd
    80004122:	d2c080e7          	jalr	-724(ra) # 80000e4a <myproc>
    80004126:	892a                	mv	s2,a0

  begin_op();
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	498080e7          	jalr	1176(ra) # 800035c0 <begin_op>

  if((ip = namei(path)) == 0){
    80004130:	8526                	mv	a0,s1
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	272080e7          	jalr	626(ra) # 800033a4 <namei>
    8000413a:	c92d                	beqz	a0,800041ac <exec+0xbc>
    8000413c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	ab0080e7          	jalr	-1360(ra) # 80002bee <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004146:	04000713          	li	a4,64
    8000414a:	4681                	li	a3,0
    8000414c:	e5040613          	addi	a2,s0,-432
    80004150:	4581                	li	a1,0
    80004152:	8526                	mv	a0,s1
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	d4e080e7          	jalr	-690(ra) # 80002ea2 <readi>
    8000415c:	04000793          	li	a5,64
    80004160:	00f51a63          	bne	a0,a5,80004174 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004164:	e5042703          	lw	a4,-432(s0)
    80004168:	464c47b7          	lui	a5,0x464c4
    8000416c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004170:	04f70463          	beq	a4,a5,800041b8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004174:	8526                	mv	a0,s1
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	cda080e7          	jalr	-806(ra) # 80002e50 <iunlockput>
    end_op();
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	4c2080e7          	jalr	1218(ra) # 80003640 <end_op>
  }
  return -1;
    80004186:	557d                	li	a0,-1
}
    80004188:	20813083          	ld	ra,520(sp)
    8000418c:	20013403          	ld	s0,512(sp)
    80004190:	74fe                	ld	s1,504(sp)
    80004192:	795e                	ld	s2,496(sp)
    80004194:	79be                	ld	s3,488(sp)
    80004196:	7a1e                	ld	s4,480(sp)
    80004198:	6afe                	ld	s5,472(sp)
    8000419a:	6b5e                	ld	s6,464(sp)
    8000419c:	6bbe                	ld	s7,456(sp)
    8000419e:	6c1e                	ld	s8,448(sp)
    800041a0:	7cfa                	ld	s9,440(sp)
    800041a2:	7d5a                	ld	s10,432(sp)
    800041a4:	7dba                	ld	s11,424(sp)
    800041a6:	21010113          	addi	sp,sp,528
    800041aa:	8082                	ret
    end_op();
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	494080e7          	jalr	1172(ra) # 80003640 <end_op>
    return -1;
    800041b4:	557d                	li	a0,-1
    800041b6:	bfc9                	j	80004188 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041b8:	854a                	mv	a0,s2
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	d54080e7          	jalr	-684(ra) # 80000f0e <proc_pagetable>
    800041c2:	8baa                	mv	s7,a0
    800041c4:	d945                	beqz	a0,80004174 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c6:	e7042983          	lw	s3,-400(s0)
    800041ca:	e8845783          	lhu	a5,-376(s0)
    800041ce:	c7ad                	beqz	a5,80004238 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041d0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041d2:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041d4:	6c85                	lui	s9,0x1
    800041d6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041da:	def43823          	sd	a5,-528(s0)
    800041de:	a42d                	j	80004408 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041e0:	00004517          	auipc	a0,0x4
    800041e4:	47850513          	addi	a0,a0,1144 # 80008658 <syscalls+0x290>
    800041e8:	00002097          	auipc	ra,0x2
    800041ec:	ac2080e7          	jalr	-1342(ra) # 80005caa <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041f0:	8756                	mv	a4,s5
    800041f2:	012d86bb          	addw	a3,s11,s2
    800041f6:	4581                	li	a1,0
    800041f8:	8526                	mv	a0,s1
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	ca8080e7          	jalr	-856(ra) # 80002ea2 <readi>
    80004202:	2501                	sext.w	a0,a0
    80004204:	1aaa9963          	bne	s5,a0,800043b6 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004208:	6785                	lui	a5,0x1
    8000420a:	0127893b          	addw	s2,a5,s2
    8000420e:	77fd                	lui	a5,0xfffff
    80004210:	01478a3b          	addw	s4,a5,s4
    80004214:	1f897163          	bgeu	s2,s8,800043f6 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004218:	02091593          	slli	a1,s2,0x20
    8000421c:	9181                	srli	a1,a1,0x20
    8000421e:	95ea                	add	a1,a1,s10
    80004220:	855e                	mv	a0,s7
    80004222:	ffffc097          	auipc	ra,0xffffc
    80004226:	2e4080e7          	jalr	740(ra) # 80000506 <walkaddr>
    8000422a:	862a                	mv	a2,a0
    if(pa == 0)
    8000422c:	d955                	beqz	a0,800041e0 <exec+0xf0>
      n = PGSIZE;
    8000422e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004230:	fd9a70e3          	bgeu	s4,s9,800041f0 <exec+0x100>
      n = sz - i;
    80004234:	8ad2                	mv	s5,s4
    80004236:	bf6d                	j	800041f0 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004238:	4901                	li	s2,0
  iunlockput(ip);
    8000423a:	8526                	mv	a0,s1
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	c14080e7          	jalr	-1004(ra) # 80002e50 <iunlockput>
  end_op();
    80004244:	fffff097          	auipc	ra,0xfffff
    80004248:	3fc080e7          	jalr	1020(ra) # 80003640 <end_op>
  p = myproc();
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	bfe080e7          	jalr	-1026(ra) # 80000e4a <myproc>
    80004254:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004256:	17853d03          	ld	s10,376(a0)
  sz = PGROUNDUP(sz);
    8000425a:	6785                	lui	a5,0x1
    8000425c:	17fd                	addi	a5,a5,-1
    8000425e:	993e                	add	s2,s2,a5
    80004260:	757d                	lui	a0,0xfffff
    80004262:	00a977b3          	and	a5,s2,a0
    80004266:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000426a:	6609                	lui	a2,0x2
    8000426c:	963e                	add	a2,a2,a5
    8000426e:	85be                	mv	a1,a5
    80004270:	855e                	mv	a0,s7
    80004272:	ffffc097          	auipc	ra,0xffffc
    80004276:	648080e7          	jalr	1608(ra) # 800008ba <uvmalloc>
    8000427a:	8b2a                	mv	s6,a0
  ip = 0;
    8000427c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000427e:	12050c63          	beqz	a0,800043b6 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004282:	75f9                	lui	a1,0xffffe
    80004284:	95aa                	add	a1,a1,a0
    80004286:	855e                	mv	a0,s7
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	850080e7          	jalr	-1968(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004290:	7c7d                	lui	s8,0xfffff
    80004292:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004294:	e0043783          	ld	a5,-512(s0)
    80004298:	6388                	ld	a0,0(a5)
    8000429a:	c535                	beqz	a0,80004306 <exec+0x216>
    8000429c:	e9040993          	addi	s3,s0,-368
    800042a0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042a4:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042a6:	ffffc097          	auipc	ra,0xffffc
    800042aa:	056080e7          	jalr	86(ra) # 800002fc <strlen>
    800042ae:	2505                	addiw	a0,a0,1
    800042b0:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042b4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042b8:	13896363          	bltu	s2,s8,800043de <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042bc:	e0043d83          	ld	s11,-512(s0)
    800042c0:	000dba03          	ld	s4,0(s11)
    800042c4:	8552                	mv	a0,s4
    800042c6:	ffffc097          	auipc	ra,0xffffc
    800042ca:	036080e7          	jalr	54(ra) # 800002fc <strlen>
    800042ce:	0015069b          	addiw	a3,a0,1
    800042d2:	8652                	mv	a2,s4
    800042d4:	85ca                	mv	a1,s2
    800042d6:	855e                	mv	a0,s7
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	832080e7          	jalr	-1998(ra) # 80000b0a <copyout>
    800042e0:	10054363          	bltz	a0,800043e6 <exec+0x2f6>
    ustack[argc] = sp;
    800042e4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042e8:	0485                	addi	s1,s1,1
    800042ea:	008d8793          	addi	a5,s11,8
    800042ee:	e0f43023          	sd	a5,-512(s0)
    800042f2:	008db503          	ld	a0,8(s11)
    800042f6:	c911                	beqz	a0,8000430a <exec+0x21a>
    if(argc >= MAXARG)
    800042f8:	09a1                	addi	s3,s3,8
    800042fa:	fb3c96e3          	bne	s9,s3,800042a6 <exec+0x1b6>
  sz = sz1;
    800042fe:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004302:	4481                	li	s1,0
    80004304:	a84d                	j	800043b6 <exec+0x2c6>
  sp = sz;
    80004306:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004308:	4481                	li	s1,0
  ustack[argc] = 0;
    8000430a:	00349793          	slli	a5,s1,0x3
    8000430e:	f9040713          	addi	a4,s0,-112
    80004312:	97ba                	add	a5,a5,a4
    80004314:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004318:	00148693          	addi	a3,s1,1
    8000431c:	068e                	slli	a3,a3,0x3
    8000431e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004322:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004326:	01897663          	bgeu	s2,s8,80004332 <exec+0x242>
  sz = sz1;
    8000432a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000432e:	4481                	li	s1,0
    80004330:	a059                	j	800043b6 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004332:	e9040613          	addi	a2,s0,-368
    80004336:	85ca                	mv	a1,s2
    80004338:	855e                	mv	a0,s7
    8000433a:	ffffc097          	auipc	ra,0xffffc
    8000433e:	7d0080e7          	jalr	2000(ra) # 80000b0a <copyout>
    80004342:	0a054663          	bltz	a0,800043ee <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004346:	188ab783          	ld	a5,392(s5)
    8000434a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000434e:	df843783          	ld	a5,-520(s0)
    80004352:	0007c703          	lbu	a4,0(a5)
    80004356:	cf11                	beqz	a4,80004372 <exec+0x282>
    80004358:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000435a:	02f00693          	li	a3,47
    8000435e:	a039                	j	8000436c <exec+0x27c>
      last = s+1;
    80004360:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004364:	0785                	addi	a5,a5,1
    80004366:	fff7c703          	lbu	a4,-1(a5)
    8000436a:	c701                	beqz	a4,80004372 <exec+0x282>
    if(*s == '/')
    8000436c:	fed71ce3          	bne	a4,a3,80004364 <exec+0x274>
    80004370:	bfc5                	j	80004360 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004372:	4641                	li	a2,16
    80004374:	df843583          	ld	a1,-520(s0)
    80004378:	288a8513          	addi	a0,s5,648
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	f4e080e7          	jalr	-178(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004384:	180ab503          	ld	a0,384(s5)
  p->pagetable = pagetable;
    80004388:	197ab023          	sd	s7,384(s5)
  p->sz = sz;
    8000438c:	176abc23          	sd	s6,376(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004390:	188ab783          	ld	a5,392(s5)
    80004394:	e6843703          	ld	a4,-408(s0)
    80004398:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000439a:	188ab783          	ld	a5,392(s5)
    8000439e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043a2:	85ea                	mv	a1,s10
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	c06080e7          	jalr	-1018(ra) # 80000faa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043ac:	0004851b          	sext.w	a0,s1
    800043b0:	bbe1                	j	80004188 <exec+0x98>
    800043b2:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043b6:	e0843583          	ld	a1,-504(s0)
    800043ba:	855e                	mv	a0,s7
    800043bc:	ffffd097          	auipc	ra,0xffffd
    800043c0:	bee080e7          	jalr	-1042(ra) # 80000faa <proc_freepagetable>
  if(ip){
    800043c4:	da0498e3          	bnez	s1,80004174 <exec+0x84>
  return -1;
    800043c8:	557d                	li	a0,-1
    800043ca:	bb7d                	j	80004188 <exec+0x98>
    800043cc:	e1243423          	sd	s2,-504(s0)
    800043d0:	b7dd                	j	800043b6 <exec+0x2c6>
    800043d2:	e1243423          	sd	s2,-504(s0)
    800043d6:	b7c5                	j	800043b6 <exec+0x2c6>
    800043d8:	e1243423          	sd	s2,-504(s0)
    800043dc:	bfe9                	j	800043b6 <exec+0x2c6>
  sz = sz1;
    800043de:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e2:	4481                	li	s1,0
    800043e4:	bfc9                	j	800043b6 <exec+0x2c6>
  sz = sz1;
    800043e6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ea:	4481                	li	s1,0
    800043ec:	b7e9                	j	800043b6 <exec+0x2c6>
  sz = sz1;
    800043ee:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043f2:	4481                	li	s1,0
    800043f4:	b7c9                	j	800043b6 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043f6:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043fa:	2b05                	addiw	s6,s6,1
    800043fc:	0389899b          	addiw	s3,s3,56
    80004400:	e8845783          	lhu	a5,-376(s0)
    80004404:	e2fb5be3          	bge	s6,a5,8000423a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004408:	2981                	sext.w	s3,s3
    8000440a:	03800713          	li	a4,56
    8000440e:	86ce                	mv	a3,s3
    80004410:	e1840613          	addi	a2,s0,-488
    80004414:	4581                	li	a1,0
    80004416:	8526                	mv	a0,s1
    80004418:	fffff097          	auipc	ra,0xfffff
    8000441c:	a8a080e7          	jalr	-1398(ra) # 80002ea2 <readi>
    80004420:	03800793          	li	a5,56
    80004424:	f8f517e3          	bne	a0,a5,800043b2 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004428:	e1842783          	lw	a5,-488(s0)
    8000442c:	4705                	li	a4,1
    8000442e:	fce796e3          	bne	a5,a4,800043fa <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004432:	e4043603          	ld	a2,-448(s0)
    80004436:	e3843783          	ld	a5,-456(s0)
    8000443a:	f8f669e3          	bltu	a2,a5,800043cc <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000443e:	e2843783          	ld	a5,-472(s0)
    80004442:	963e                	add	a2,a2,a5
    80004444:	f8f667e3          	bltu	a2,a5,800043d2 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004448:	85ca                	mv	a1,s2
    8000444a:	855e                	mv	a0,s7
    8000444c:	ffffc097          	auipc	ra,0xffffc
    80004450:	46e080e7          	jalr	1134(ra) # 800008ba <uvmalloc>
    80004454:	e0a43423          	sd	a0,-504(s0)
    80004458:	d141                	beqz	a0,800043d8 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000445a:	e2843d03          	ld	s10,-472(s0)
    8000445e:	df043783          	ld	a5,-528(s0)
    80004462:	00fd77b3          	and	a5,s10,a5
    80004466:	fba1                	bnez	a5,800043b6 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004468:	e2042d83          	lw	s11,-480(s0)
    8000446c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004470:	f80c03e3          	beqz	s8,800043f6 <exec+0x306>
    80004474:	8a62                	mv	s4,s8
    80004476:	4901                	li	s2,0
    80004478:	b345                	j	80004218 <exec+0x128>

000000008000447a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000447a:	7179                	addi	sp,sp,-48
    8000447c:	f406                	sd	ra,40(sp)
    8000447e:	f022                	sd	s0,32(sp)
    80004480:	ec26                	sd	s1,24(sp)
    80004482:	e84a                	sd	s2,16(sp)
    80004484:	1800                	addi	s0,sp,48
    80004486:	892e                	mv	s2,a1
    80004488:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000448a:	fdc40593          	addi	a1,s0,-36
    8000448e:	ffffe097          	auipc	ra,0xffffe
    80004492:	b40080e7          	jalr	-1216(ra) # 80001fce <argint>
    80004496:	04054063          	bltz	a0,800044d6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000449a:	fdc42703          	lw	a4,-36(s0)
    8000449e:	47bd                	li	a5,15
    800044a0:	02e7ed63          	bltu	a5,a4,800044da <argfd+0x60>
    800044a4:	ffffd097          	auipc	ra,0xffffd
    800044a8:	9a6080e7          	jalr	-1626(ra) # 80000e4a <myproc>
    800044ac:	fdc42703          	lw	a4,-36(s0)
    800044b0:	04070793          	addi	a5,a4,64
    800044b4:	078e                	slli	a5,a5,0x3
    800044b6:	953e                	add	a0,a0,a5
    800044b8:	611c                	ld	a5,0(a0)
    800044ba:	c395                	beqz	a5,800044de <argfd+0x64>
    return -1;
  if(pfd)
    800044bc:	00090463          	beqz	s2,800044c4 <argfd+0x4a>
    *pfd = fd;
    800044c0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044c4:	4501                	li	a0,0
  if(pf)
    800044c6:	c091                	beqz	s1,800044ca <argfd+0x50>
    *pf = f;
    800044c8:	e09c                	sd	a5,0(s1)
}
    800044ca:	70a2                	ld	ra,40(sp)
    800044cc:	7402                	ld	s0,32(sp)
    800044ce:	64e2                	ld	s1,24(sp)
    800044d0:	6942                	ld	s2,16(sp)
    800044d2:	6145                	addi	sp,sp,48
    800044d4:	8082                	ret
    return -1;
    800044d6:	557d                	li	a0,-1
    800044d8:	bfcd                	j	800044ca <argfd+0x50>
    return -1;
    800044da:	557d                	li	a0,-1
    800044dc:	b7fd                	j	800044ca <argfd+0x50>
    800044de:	557d                	li	a0,-1
    800044e0:	b7ed                	j	800044ca <argfd+0x50>

00000000800044e2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044e2:	1101                	addi	sp,sp,-32
    800044e4:	ec06                	sd	ra,24(sp)
    800044e6:	e822                	sd	s0,16(sp)
    800044e8:	e426                	sd	s1,8(sp)
    800044ea:	1000                	addi	s0,sp,32
    800044ec:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ee:	ffffd097          	auipc	ra,0xffffd
    800044f2:	95c080e7          	jalr	-1700(ra) # 80000e4a <myproc>
    800044f6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f8:	20050793          	addi	a5,a0,512 # fffffffffffff200 <end+0xffffffff7ffd4fc0>
    800044fc:	4501                	li	a0,0
    800044fe:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004500:	6398                	ld	a4,0(a5)
    80004502:	cb19                	beqz	a4,80004518 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004504:	2505                	addiw	a0,a0,1
    80004506:	07a1                	addi	a5,a5,8
    80004508:	fed51ce3          	bne	a0,a3,80004500 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000450c:	557d                	li	a0,-1
}
    8000450e:	60e2                	ld	ra,24(sp)
    80004510:	6442                	ld	s0,16(sp)
    80004512:	64a2                	ld	s1,8(sp)
    80004514:	6105                	addi	sp,sp,32
    80004516:	8082                	ret
      p->ofile[fd] = f;
    80004518:	04050793          	addi	a5,a0,64
    8000451c:	078e                	slli	a5,a5,0x3
    8000451e:	963e                	add	a2,a2,a5
    80004520:	e204                	sd	s1,0(a2)
      return fd;
    80004522:	b7f5                	j	8000450e <fdalloc+0x2c>

0000000080004524 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004524:	715d                	addi	sp,sp,-80
    80004526:	e486                	sd	ra,72(sp)
    80004528:	e0a2                	sd	s0,64(sp)
    8000452a:	fc26                	sd	s1,56(sp)
    8000452c:	f84a                	sd	s2,48(sp)
    8000452e:	f44e                	sd	s3,40(sp)
    80004530:	f052                	sd	s4,32(sp)
    80004532:	ec56                	sd	s5,24(sp)
    80004534:	0880                	addi	s0,sp,80
    80004536:	89ae                	mv	s3,a1
    80004538:	8ab2                	mv	s5,a2
    8000453a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000453c:	fb040593          	addi	a1,s0,-80
    80004540:	fffff097          	auipc	ra,0xfffff
    80004544:	e82080e7          	jalr	-382(ra) # 800033c2 <nameiparent>
    80004548:	892a                	mv	s2,a0
    8000454a:	12050f63          	beqz	a0,80004688 <create+0x164>
    return 0;

  ilock(dp);
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	6a0080e7          	jalr	1696(ra) # 80002bee <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004556:	4601                	li	a2,0
    80004558:	fb040593          	addi	a1,s0,-80
    8000455c:	854a                	mv	a0,s2
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	b74080e7          	jalr	-1164(ra) # 800030d2 <dirlookup>
    80004566:	84aa                	mv	s1,a0
    80004568:	c921                	beqz	a0,800045b8 <create+0x94>
    iunlockput(dp);
    8000456a:	854a                	mv	a0,s2
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	8e4080e7          	jalr	-1820(ra) # 80002e50 <iunlockput>
    ilock(ip);
    80004574:	8526                	mv	a0,s1
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	678080e7          	jalr	1656(ra) # 80002bee <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000457e:	2981                	sext.w	s3,s3
    80004580:	4789                	li	a5,2
    80004582:	02f99463          	bne	s3,a5,800045aa <create+0x86>
    80004586:	0444d783          	lhu	a5,68(s1)
    8000458a:	37f9                	addiw	a5,a5,-2
    8000458c:	17c2                	slli	a5,a5,0x30
    8000458e:	93c1                	srli	a5,a5,0x30
    80004590:	4705                	li	a4,1
    80004592:	00f76c63          	bltu	a4,a5,800045aa <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004596:	8526                	mv	a0,s1
    80004598:	60a6                	ld	ra,72(sp)
    8000459a:	6406                	ld	s0,64(sp)
    8000459c:	74e2                	ld	s1,56(sp)
    8000459e:	7942                	ld	s2,48(sp)
    800045a0:	79a2                	ld	s3,40(sp)
    800045a2:	7a02                	ld	s4,32(sp)
    800045a4:	6ae2                	ld	s5,24(sp)
    800045a6:	6161                	addi	sp,sp,80
    800045a8:	8082                	ret
    iunlockput(ip);
    800045aa:	8526                	mv	a0,s1
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	8a4080e7          	jalr	-1884(ra) # 80002e50 <iunlockput>
    return 0;
    800045b4:	4481                	li	s1,0
    800045b6:	b7c5                	j	80004596 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045b8:	85ce                	mv	a1,s3
    800045ba:	00092503          	lw	a0,0(s2)
    800045be:	ffffe097          	auipc	ra,0xffffe
    800045c2:	498080e7          	jalr	1176(ra) # 80002a56 <ialloc>
    800045c6:	84aa                	mv	s1,a0
    800045c8:	c529                	beqz	a0,80004612 <create+0xee>
  ilock(ip);
    800045ca:	ffffe097          	auipc	ra,0xffffe
    800045ce:	624080e7          	jalr	1572(ra) # 80002bee <ilock>
  ip->major = major;
    800045d2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045d6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045da:	4785                	li	a5,1
    800045dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045e0:	8526                	mv	a0,s1
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	542080e7          	jalr	1346(ra) # 80002b24 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045ea:	2981                	sext.w	s3,s3
    800045ec:	4785                	li	a5,1
    800045ee:	02f98a63          	beq	s3,a5,80004622 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045f2:	40d0                	lw	a2,4(s1)
    800045f4:	fb040593          	addi	a1,s0,-80
    800045f8:	854a                	mv	a0,s2
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	ce8080e7          	jalr	-792(ra) # 800032e2 <dirlink>
    80004602:	06054b63          	bltz	a0,80004678 <create+0x154>
  iunlockput(dp);
    80004606:	854a                	mv	a0,s2
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	848080e7          	jalr	-1976(ra) # 80002e50 <iunlockput>
  return ip;
    80004610:	b759                	j	80004596 <create+0x72>
    panic("create: ialloc");
    80004612:	00004517          	auipc	a0,0x4
    80004616:	06650513          	addi	a0,a0,102 # 80008678 <syscalls+0x2b0>
    8000461a:	00001097          	auipc	ra,0x1
    8000461e:	690080e7          	jalr	1680(ra) # 80005caa <panic>
    dp->nlink++;  // for ".."
    80004622:	04a95783          	lhu	a5,74(s2)
    80004626:	2785                	addiw	a5,a5,1
    80004628:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000462c:	854a                	mv	a0,s2
    8000462e:	ffffe097          	auipc	ra,0xffffe
    80004632:	4f6080e7          	jalr	1270(ra) # 80002b24 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004636:	40d0                	lw	a2,4(s1)
    80004638:	00004597          	auipc	a1,0x4
    8000463c:	05058593          	addi	a1,a1,80 # 80008688 <syscalls+0x2c0>
    80004640:	8526                	mv	a0,s1
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	ca0080e7          	jalr	-864(ra) # 800032e2 <dirlink>
    8000464a:	00054f63          	bltz	a0,80004668 <create+0x144>
    8000464e:	00492603          	lw	a2,4(s2)
    80004652:	00004597          	auipc	a1,0x4
    80004656:	03e58593          	addi	a1,a1,62 # 80008690 <syscalls+0x2c8>
    8000465a:	8526                	mv	a0,s1
    8000465c:	fffff097          	auipc	ra,0xfffff
    80004660:	c86080e7          	jalr	-890(ra) # 800032e2 <dirlink>
    80004664:	f80557e3          	bgez	a0,800045f2 <create+0xce>
      panic("create dots");
    80004668:	00004517          	auipc	a0,0x4
    8000466c:	03050513          	addi	a0,a0,48 # 80008698 <syscalls+0x2d0>
    80004670:	00001097          	auipc	ra,0x1
    80004674:	63a080e7          	jalr	1594(ra) # 80005caa <panic>
    panic("create: dirlink");
    80004678:	00004517          	auipc	a0,0x4
    8000467c:	03050513          	addi	a0,a0,48 # 800086a8 <syscalls+0x2e0>
    80004680:	00001097          	auipc	ra,0x1
    80004684:	62a080e7          	jalr	1578(ra) # 80005caa <panic>
    return 0;
    80004688:	84aa                	mv	s1,a0
    8000468a:	b731                	j	80004596 <create+0x72>

000000008000468c <sys_dup>:
{
    8000468c:	7179                	addi	sp,sp,-48
    8000468e:	f406                	sd	ra,40(sp)
    80004690:	f022                	sd	s0,32(sp)
    80004692:	ec26                	sd	s1,24(sp)
    80004694:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004696:	fd840613          	addi	a2,s0,-40
    8000469a:	4581                	li	a1,0
    8000469c:	4501                	li	a0,0
    8000469e:	00000097          	auipc	ra,0x0
    800046a2:	ddc080e7          	jalr	-548(ra) # 8000447a <argfd>
    return -1;
    800046a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046a8:	02054363          	bltz	a0,800046ce <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046ac:	fd843503          	ld	a0,-40(s0)
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	e32080e7          	jalr	-462(ra) # 800044e2 <fdalloc>
    800046b8:	84aa                	mv	s1,a0
    return -1;
    800046ba:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046bc:	00054963          	bltz	a0,800046ce <sys_dup+0x42>
  filedup(f);
    800046c0:	fd843503          	ld	a0,-40(s0)
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	37a080e7          	jalr	890(ra) # 80003a3e <filedup>
  return fd;
    800046cc:	87a6                	mv	a5,s1
}
    800046ce:	853e                	mv	a0,a5
    800046d0:	70a2                	ld	ra,40(sp)
    800046d2:	7402                	ld	s0,32(sp)
    800046d4:	64e2                	ld	s1,24(sp)
    800046d6:	6145                	addi	sp,sp,48
    800046d8:	8082                	ret

00000000800046da <sys_read>:
{
    800046da:	7179                	addi	sp,sp,-48
    800046dc:	f406                	sd	ra,40(sp)
    800046de:	f022                	sd	s0,32(sp)
    800046e0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e2:	fe840613          	addi	a2,s0,-24
    800046e6:	4581                	li	a1,0
    800046e8:	4501                	li	a0,0
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	d90080e7          	jalr	-624(ra) # 8000447a <argfd>
    return -1;
    800046f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f4:	04054163          	bltz	a0,80004736 <sys_read+0x5c>
    800046f8:	fe440593          	addi	a1,s0,-28
    800046fc:	4509                	li	a0,2
    800046fe:	ffffe097          	auipc	ra,0xffffe
    80004702:	8d0080e7          	jalr	-1840(ra) # 80001fce <argint>
    return -1;
    80004706:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004708:	02054763          	bltz	a0,80004736 <sys_read+0x5c>
    8000470c:	fd840593          	addi	a1,s0,-40
    80004710:	4505                	li	a0,1
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	8de080e7          	jalr	-1826(ra) # 80001ff0 <argaddr>
    return -1;
    8000471a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471c:	00054d63          	bltz	a0,80004736 <sys_read+0x5c>
  return fileread(f, p, n);
    80004720:	fe442603          	lw	a2,-28(s0)
    80004724:	fd843583          	ld	a1,-40(s0)
    80004728:	fe843503          	ld	a0,-24(s0)
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	49e080e7          	jalr	1182(ra) # 80003bca <fileread>
    80004734:	87aa                	mv	a5,a0
}
    80004736:	853e                	mv	a0,a5
    80004738:	70a2                	ld	ra,40(sp)
    8000473a:	7402                	ld	s0,32(sp)
    8000473c:	6145                	addi	sp,sp,48
    8000473e:	8082                	ret

0000000080004740 <sys_write>:
{
    80004740:	7179                	addi	sp,sp,-48
    80004742:	f406                	sd	ra,40(sp)
    80004744:	f022                	sd	s0,32(sp)
    80004746:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004748:	fe840613          	addi	a2,s0,-24
    8000474c:	4581                	li	a1,0
    8000474e:	4501                	li	a0,0
    80004750:	00000097          	auipc	ra,0x0
    80004754:	d2a080e7          	jalr	-726(ra) # 8000447a <argfd>
    return -1;
    80004758:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475a:	04054163          	bltz	a0,8000479c <sys_write+0x5c>
    8000475e:	fe440593          	addi	a1,s0,-28
    80004762:	4509                	li	a0,2
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	86a080e7          	jalr	-1942(ra) # 80001fce <argint>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476e:	02054763          	bltz	a0,8000479c <sys_write+0x5c>
    80004772:	fd840593          	addi	a1,s0,-40
    80004776:	4505                	li	a0,1
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	878080e7          	jalr	-1928(ra) # 80001ff0 <argaddr>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004782:	00054d63          	bltz	a0,8000479c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004786:	fe442603          	lw	a2,-28(s0)
    8000478a:	fd843583          	ld	a1,-40(s0)
    8000478e:	fe843503          	ld	a0,-24(s0)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	4fa080e7          	jalr	1274(ra) # 80003c8c <filewrite>
    8000479a:	87aa                	mv	a5,a0
}
    8000479c:	853e                	mv	a0,a5
    8000479e:	70a2                	ld	ra,40(sp)
    800047a0:	7402                	ld	s0,32(sp)
    800047a2:	6145                	addi	sp,sp,48
    800047a4:	8082                	ret

00000000800047a6 <sys_close>:
{
    800047a6:	1101                	addi	sp,sp,-32
    800047a8:	ec06                	sd	ra,24(sp)
    800047aa:	e822                	sd	s0,16(sp)
    800047ac:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047ae:	fe040613          	addi	a2,s0,-32
    800047b2:	fec40593          	addi	a1,s0,-20
    800047b6:	4501                	li	a0,0
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	cc2080e7          	jalr	-830(ra) # 8000447a <argfd>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c2:	02054563          	bltz	a0,800047ec <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    800047c6:	ffffc097          	auipc	ra,0xffffc
    800047ca:	684080e7          	jalr	1668(ra) # 80000e4a <myproc>
    800047ce:	fec42783          	lw	a5,-20(s0)
    800047d2:	04078793          	addi	a5,a5,64
    800047d6:	078e                	slli	a5,a5,0x3
    800047d8:	97aa                	add	a5,a5,a0
    800047da:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047de:	fe043503          	ld	a0,-32(s0)
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	2ae080e7          	jalr	686(ra) # 80003a90 <fileclose>
  return 0;
    800047ea:	4781                	li	a5,0
}
    800047ec:	853e                	mv	a0,a5
    800047ee:	60e2                	ld	ra,24(sp)
    800047f0:	6442                	ld	s0,16(sp)
    800047f2:	6105                	addi	sp,sp,32
    800047f4:	8082                	ret

00000000800047f6 <sys_fstat>:
{
    800047f6:	1101                	addi	sp,sp,-32
    800047f8:	ec06                	sd	ra,24(sp)
    800047fa:	e822                	sd	s0,16(sp)
    800047fc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047fe:	fe840613          	addi	a2,s0,-24
    80004802:	4581                	li	a1,0
    80004804:	4501                	li	a0,0
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	c74080e7          	jalr	-908(ra) # 8000447a <argfd>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004810:	02054563          	bltz	a0,8000483a <sys_fstat+0x44>
    80004814:	fe040593          	addi	a1,s0,-32
    80004818:	4505                	li	a0,1
    8000481a:	ffffd097          	auipc	ra,0xffffd
    8000481e:	7d6080e7          	jalr	2006(ra) # 80001ff0 <argaddr>
    return -1;
    80004822:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004824:	00054b63          	bltz	a0,8000483a <sys_fstat+0x44>
  return filestat(f, st);
    80004828:	fe043583          	ld	a1,-32(s0)
    8000482c:	fe843503          	ld	a0,-24(s0)
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	328080e7          	jalr	808(ra) # 80003b58 <filestat>
    80004838:	87aa                	mv	a5,a0
}
    8000483a:	853e                	mv	a0,a5
    8000483c:	60e2                	ld	ra,24(sp)
    8000483e:	6442                	ld	s0,16(sp)
    80004840:	6105                	addi	sp,sp,32
    80004842:	8082                	ret

0000000080004844 <sys_link>:
{
    80004844:	7169                	addi	sp,sp,-304
    80004846:	f606                	sd	ra,296(sp)
    80004848:	f222                	sd	s0,288(sp)
    8000484a:	ee26                	sd	s1,280(sp)
    8000484c:	ea4a                	sd	s2,272(sp)
    8000484e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004850:	08000613          	li	a2,128
    80004854:	ed040593          	addi	a1,s0,-304
    80004858:	4501                	li	a0,0
    8000485a:	ffffd097          	auipc	ra,0xffffd
    8000485e:	7b8080e7          	jalr	1976(ra) # 80002012 <argstr>
    return -1;
    80004862:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004864:	10054e63          	bltz	a0,80004980 <sys_link+0x13c>
    80004868:	08000613          	li	a2,128
    8000486c:	f5040593          	addi	a1,s0,-176
    80004870:	4505                	li	a0,1
    80004872:	ffffd097          	auipc	ra,0xffffd
    80004876:	7a0080e7          	jalr	1952(ra) # 80002012 <argstr>
    return -1;
    8000487a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000487c:	10054263          	bltz	a0,80004980 <sys_link+0x13c>
  begin_op();
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	d40080e7          	jalr	-704(ra) # 800035c0 <begin_op>
  if((ip = namei(old)) == 0){
    80004888:	ed040513          	addi	a0,s0,-304
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	b18080e7          	jalr	-1256(ra) # 800033a4 <namei>
    80004894:	84aa                	mv	s1,a0
    80004896:	c551                	beqz	a0,80004922 <sys_link+0xde>
  ilock(ip);
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	356080e7          	jalr	854(ra) # 80002bee <ilock>
  if(ip->type == T_DIR){
    800048a0:	04449703          	lh	a4,68(s1)
    800048a4:	4785                	li	a5,1
    800048a6:	08f70463          	beq	a4,a5,8000492e <sys_link+0xea>
  ip->nlink++;
    800048aa:	04a4d783          	lhu	a5,74(s1)
    800048ae:	2785                	addiw	a5,a5,1
    800048b0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b4:	8526                	mv	a0,s1
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	26e080e7          	jalr	622(ra) # 80002b24 <iupdate>
  iunlock(ip);
    800048be:	8526                	mv	a0,s1
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	3f0080e7          	jalr	1008(ra) # 80002cb0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048c8:	fd040593          	addi	a1,s0,-48
    800048cc:	f5040513          	addi	a0,s0,-176
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	af2080e7          	jalr	-1294(ra) # 800033c2 <nameiparent>
    800048d8:	892a                	mv	s2,a0
    800048da:	c935                	beqz	a0,8000494e <sys_link+0x10a>
  ilock(dp);
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	312080e7          	jalr	786(ra) # 80002bee <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048e4:	00092703          	lw	a4,0(s2)
    800048e8:	409c                	lw	a5,0(s1)
    800048ea:	04f71d63          	bne	a4,a5,80004944 <sys_link+0x100>
    800048ee:	40d0                	lw	a2,4(s1)
    800048f0:	fd040593          	addi	a1,s0,-48
    800048f4:	854a                	mv	a0,s2
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	9ec080e7          	jalr	-1556(ra) # 800032e2 <dirlink>
    800048fe:	04054363          	bltz	a0,80004944 <sys_link+0x100>
  iunlockput(dp);
    80004902:	854a                	mv	a0,s2
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	54c080e7          	jalr	1356(ra) # 80002e50 <iunlockput>
  iput(ip);
    8000490c:	8526                	mv	a0,s1
    8000490e:	ffffe097          	auipc	ra,0xffffe
    80004912:	49a080e7          	jalr	1178(ra) # 80002da8 <iput>
  end_op();
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	d2a080e7          	jalr	-726(ra) # 80003640 <end_op>
  return 0;
    8000491e:	4781                	li	a5,0
    80004920:	a085                	j	80004980 <sys_link+0x13c>
    end_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	d1e080e7          	jalr	-738(ra) # 80003640 <end_op>
    return -1;
    8000492a:	57fd                	li	a5,-1
    8000492c:	a891                	j	80004980 <sys_link+0x13c>
    iunlockput(ip);
    8000492e:	8526                	mv	a0,s1
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	520080e7          	jalr	1312(ra) # 80002e50 <iunlockput>
    end_op();
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	d08080e7          	jalr	-760(ra) # 80003640 <end_op>
    return -1;
    80004940:	57fd                	li	a5,-1
    80004942:	a83d                	j	80004980 <sys_link+0x13c>
    iunlockput(dp);
    80004944:	854a                	mv	a0,s2
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	50a080e7          	jalr	1290(ra) # 80002e50 <iunlockput>
  ilock(ip);
    8000494e:	8526                	mv	a0,s1
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	29e080e7          	jalr	670(ra) # 80002bee <ilock>
  ip->nlink--;
    80004958:	04a4d783          	lhu	a5,74(s1)
    8000495c:	37fd                	addiw	a5,a5,-1
    8000495e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004962:	8526                	mv	a0,s1
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	1c0080e7          	jalr	448(ra) # 80002b24 <iupdate>
  iunlockput(ip);
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	4e2080e7          	jalr	1250(ra) # 80002e50 <iunlockput>
  end_op();
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	cca080e7          	jalr	-822(ra) # 80003640 <end_op>
  return -1;
    8000497e:	57fd                	li	a5,-1
}
    80004980:	853e                	mv	a0,a5
    80004982:	70b2                	ld	ra,296(sp)
    80004984:	7412                	ld	s0,288(sp)
    80004986:	64f2                	ld	s1,280(sp)
    80004988:	6952                	ld	s2,272(sp)
    8000498a:	6155                	addi	sp,sp,304
    8000498c:	8082                	ret

000000008000498e <sys_unlink>:
{
    8000498e:	7151                	addi	sp,sp,-240
    80004990:	f586                	sd	ra,232(sp)
    80004992:	f1a2                	sd	s0,224(sp)
    80004994:	eda6                	sd	s1,216(sp)
    80004996:	e9ca                	sd	s2,208(sp)
    80004998:	e5ce                	sd	s3,200(sp)
    8000499a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000499c:	08000613          	li	a2,128
    800049a0:	f3040593          	addi	a1,s0,-208
    800049a4:	4501                	li	a0,0
    800049a6:	ffffd097          	auipc	ra,0xffffd
    800049aa:	66c080e7          	jalr	1644(ra) # 80002012 <argstr>
    800049ae:	18054163          	bltz	a0,80004b30 <sys_unlink+0x1a2>
  begin_op();
    800049b2:	fffff097          	auipc	ra,0xfffff
    800049b6:	c0e080e7          	jalr	-1010(ra) # 800035c0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049ba:	fb040593          	addi	a1,s0,-80
    800049be:	f3040513          	addi	a0,s0,-208
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	a00080e7          	jalr	-1536(ra) # 800033c2 <nameiparent>
    800049ca:	84aa                	mv	s1,a0
    800049cc:	c979                	beqz	a0,80004aa2 <sys_unlink+0x114>
  ilock(dp);
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	220080e7          	jalr	544(ra) # 80002bee <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049d6:	00004597          	auipc	a1,0x4
    800049da:	cb258593          	addi	a1,a1,-846 # 80008688 <syscalls+0x2c0>
    800049de:	fb040513          	addi	a0,s0,-80
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	6d6080e7          	jalr	1750(ra) # 800030b8 <namecmp>
    800049ea:	14050a63          	beqz	a0,80004b3e <sys_unlink+0x1b0>
    800049ee:	00004597          	auipc	a1,0x4
    800049f2:	ca258593          	addi	a1,a1,-862 # 80008690 <syscalls+0x2c8>
    800049f6:	fb040513          	addi	a0,s0,-80
    800049fa:	ffffe097          	auipc	ra,0xffffe
    800049fe:	6be080e7          	jalr	1726(ra) # 800030b8 <namecmp>
    80004a02:	12050e63          	beqz	a0,80004b3e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a06:	f2c40613          	addi	a2,s0,-212
    80004a0a:	fb040593          	addi	a1,s0,-80
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	6c2080e7          	jalr	1730(ra) # 800030d2 <dirlookup>
    80004a18:	892a                	mv	s2,a0
    80004a1a:	12050263          	beqz	a0,80004b3e <sys_unlink+0x1b0>
  ilock(ip);
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	1d0080e7          	jalr	464(ra) # 80002bee <ilock>
  if(ip->nlink < 1)
    80004a26:	04a91783          	lh	a5,74(s2)
    80004a2a:	08f05263          	blez	a5,80004aae <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a2e:	04491703          	lh	a4,68(s2)
    80004a32:	4785                	li	a5,1
    80004a34:	08f70563          	beq	a4,a5,80004abe <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a38:	4641                	li	a2,16
    80004a3a:	4581                	li	a1,0
    80004a3c:	fc040513          	addi	a0,s0,-64
    80004a40:	ffffb097          	auipc	ra,0xffffb
    80004a44:	738080e7          	jalr	1848(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a48:	4741                	li	a4,16
    80004a4a:	f2c42683          	lw	a3,-212(s0)
    80004a4e:	fc040613          	addi	a2,s0,-64
    80004a52:	4581                	li	a1,0
    80004a54:	8526                	mv	a0,s1
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	544080e7          	jalr	1348(ra) # 80002f9a <writei>
    80004a5e:	47c1                	li	a5,16
    80004a60:	0af51563          	bne	a0,a5,80004b0a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a64:	04491703          	lh	a4,68(s2)
    80004a68:	4785                	li	a5,1
    80004a6a:	0af70863          	beq	a4,a5,80004b1a <sys_unlink+0x18c>
  iunlockput(dp);
    80004a6e:	8526                	mv	a0,s1
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	3e0080e7          	jalr	992(ra) # 80002e50 <iunlockput>
  ip->nlink--;
    80004a78:	04a95783          	lhu	a5,74(s2)
    80004a7c:	37fd                	addiw	a5,a5,-1
    80004a7e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a82:	854a                	mv	a0,s2
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	0a0080e7          	jalr	160(ra) # 80002b24 <iupdate>
  iunlockput(ip);
    80004a8c:	854a                	mv	a0,s2
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	3c2080e7          	jalr	962(ra) # 80002e50 <iunlockput>
  end_op();
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	baa080e7          	jalr	-1110(ra) # 80003640 <end_op>
  return 0;
    80004a9e:	4501                	li	a0,0
    80004aa0:	a84d                	j	80004b52 <sys_unlink+0x1c4>
    end_op();
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	b9e080e7          	jalr	-1122(ra) # 80003640 <end_op>
    return -1;
    80004aaa:	557d                	li	a0,-1
    80004aac:	a05d                	j	80004b52 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aae:	00004517          	auipc	a0,0x4
    80004ab2:	c0a50513          	addi	a0,a0,-1014 # 800086b8 <syscalls+0x2f0>
    80004ab6:	00001097          	auipc	ra,0x1
    80004aba:	1f4080e7          	jalr	500(ra) # 80005caa <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004abe:	04c92703          	lw	a4,76(s2)
    80004ac2:	02000793          	li	a5,32
    80004ac6:	f6e7f9e3          	bgeu	a5,a4,80004a38 <sys_unlink+0xaa>
    80004aca:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ace:	4741                	li	a4,16
    80004ad0:	86ce                	mv	a3,s3
    80004ad2:	f1840613          	addi	a2,s0,-232
    80004ad6:	4581                	li	a1,0
    80004ad8:	854a                	mv	a0,s2
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	3c8080e7          	jalr	968(ra) # 80002ea2 <readi>
    80004ae2:	47c1                	li	a5,16
    80004ae4:	00f51b63          	bne	a0,a5,80004afa <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ae8:	f1845783          	lhu	a5,-232(s0)
    80004aec:	e7a1                	bnez	a5,80004b34 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aee:	29c1                	addiw	s3,s3,16
    80004af0:	04c92783          	lw	a5,76(s2)
    80004af4:	fcf9ede3          	bltu	s3,a5,80004ace <sys_unlink+0x140>
    80004af8:	b781                	j	80004a38 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004afa:	00004517          	auipc	a0,0x4
    80004afe:	bd650513          	addi	a0,a0,-1066 # 800086d0 <syscalls+0x308>
    80004b02:	00001097          	auipc	ra,0x1
    80004b06:	1a8080e7          	jalr	424(ra) # 80005caa <panic>
    panic("unlink: writei");
    80004b0a:	00004517          	auipc	a0,0x4
    80004b0e:	bde50513          	addi	a0,a0,-1058 # 800086e8 <syscalls+0x320>
    80004b12:	00001097          	auipc	ra,0x1
    80004b16:	198080e7          	jalr	408(ra) # 80005caa <panic>
    dp->nlink--;
    80004b1a:	04a4d783          	lhu	a5,74(s1)
    80004b1e:	37fd                	addiw	a5,a5,-1
    80004b20:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	ffe080e7          	jalr	-2(ra) # 80002b24 <iupdate>
    80004b2e:	b781                	j	80004a6e <sys_unlink+0xe0>
    return -1;
    80004b30:	557d                	li	a0,-1
    80004b32:	a005                	j	80004b52 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b34:	854a                	mv	a0,s2
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	31a080e7          	jalr	794(ra) # 80002e50 <iunlockput>
  iunlockput(dp);
    80004b3e:	8526                	mv	a0,s1
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	310080e7          	jalr	784(ra) # 80002e50 <iunlockput>
  end_op();
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	af8080e7          	jalr	-1288(ra) # 80003640 <end_op>
  return -1;
    80004b50:	557d                	li	a0,-1
}
    80004b52:	70ae                	ld	ra,232(sp)
    80004b54:	740e                	ld	s0,224(sp)
    80004b56:	64ee                	ld	s1,216(sp)
    80004b58:	694e                	ld	s2,208(sp)
    80004b5a:	69ae                	ld	s3,200(sp)
    80004b5c:	616d                	addi	sp,sp,240
    80004b5e:	8082                	ret

0000000080004b60 <sys_open>:

uint64
sys_open(void)
{
    80004b60:	7131                	addi	sp,sp,-192
    80004b62:	fd06                	sd	ra,184(sp)
    80004b64:	f922                	sd	s0,176(sp)
    80004b66:	f526                	sd	s1,168(sp)
    80004b68:	f14a                	sd	s2,160(sp)
    80004b6a:	ed4e                	sd	s3,152(sp)
    80004b6c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b6e:	08000613          	li	a2,128
    80004b72:	f5040593          	addi	a1,s0,-176
    80004b76:	4501                	li	a0,0
    80004b78:	ffffd097          	auipc	ra,0xffffd
    80004b7c:	49a080e7          	jalr	1178(ra) # 80002012 <argstr>
    return -1;
    80004b80:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b82:	0c054163          	bltz	a0,80004c44 <sys_open+0xe4>
    80004b86:	f4c40593          	addi	a1,s0,-180
    80004b8a:	4505                	li	a0,1
    80004b8c:	ffffd097          	auipc	ra,0xffffd
    80004b90:	442080e7          	jalr	1090(ra) # 80001fce <argint>
    80004b94:	0a054863          	bltz	a0,80004c44 <sys_open+0xe4>

  begin_op();
    80004b98:	fffff097          	auipc	ra,0xfffff
    80004b9c:	a28080e7          	jalr	-1496(ra) # 800035c0 <begin_op>

  if(omode & O_CREATE){
    80004ba0:	f4c42783          	lw	a5,-180(s0)
    80004ba4:	2007f793          	andi	a5,a5,512
    80004ba8:	cbdd                	beqz	a5,80004c5e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004baa:	4681                	li	a3,0
    80004bac:	4601                	li	a2,0
    80004bae:	4589                	li	a1,2
    80004bb0:	f5040513          	addi	a0,s0,-176
    80004bb4:	00000097          	auipc	ra,0x0
    80004bb8:	970080e7          	jalr	-1680(ra) # 80004524 <create>
    80004bbc:	892a                	mv	s2,a0
    if(ip == 0){
    80004bbe:	c959                	beqz	a0,80004c54 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bc0:	04491703          	lh	a4,68(s2)
    80004bc4:	478d                	li	a5,3
    80004bc6:	00f71763          	bne	a4,a5,80004bd4 <sys_open+0x74>
    80004bca:	04695703          	lhu	a4,70(s2)
    80004bce:	47a5                	li	a5,9
    80004bd0:	0ce7ec63          	bltu	a5,a4,80004ca8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bd4:	fffff097          	auipc	ra,0xfffff
    80004bd8:	e00080e7          	jalr	-512(ra) # 800039d4 <filealloc>
    80004bdc:	89aa                	mv	s3,a0
    80004bde:	10050263          	beqz	a0,80004ce2 <sys_open+0x182>
    80004be2:	00000097          	auipc	ra,0x0
    80004be6:	900080e7          	jalr	-1792(ra) # 800044e2 <fdalloc>
    80004bea:	84aa                	mv	s1,a0
    80004bec:	0e054663          	bltz	a0,80004cd8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bf0:	04491703          	lh	a4,68(s2)
    80004bf4:	478d                	li	a5,3
    80004bf6:	0cf70463          	beq	a4,a5,80004cbe <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bfa:	4789                	li	a5,2
    80004bfc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c00:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c04:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c08:	f4c42783          	lw	a5,-180(s0)
    80004c0c:	0017c713          	xori	a4,a5,1
    80004c10:	8b05                	andi	a4,a4,1
    80004c12:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c16:	0037f713          	andi	a4,a5,3
    80004c1a:	00e03733          	snez	a4,a4
    80004c1e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c22:	4007f793          	andi	a5,a5,1024
    80004c26:	c791                	beqz	a5,80004c32 <sys_open+0xd2>
    80004c28:	04491703          	lh	a4,68(s2)
    80004c2c:	4789                	li	a5,2
    80004c2e:	08f70f63          	beq	a4,a5,80004ccc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c32:	854a                	mv	a0,s2
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	07c080e7          	jalr	124(ra) # 80002cb0 <iunlock>
  end_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	a04080e7          	jalr	-1532(ra) # 80003640 <end_op>

  return fd;
}
    80004c44:	8526                	mv	a0,s1
    80004c46:	70ea                	ld	ra,184(sp)
    80004c48:	744a                	ld	s0,176(sp)
    80004c4a:	74aa                	ld	s1,168(sp)
    80004c4c:	790a                	ld	s2,160(sp)
    80004c4e:	69ea                	ld	s3,152(sp)
    80004c50:	6129                	addi	sp,sp,192
    80004c52:	8082                	ret
      end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	9ec080e7          	jalr	-1556(ra) # 80003640 <end_op>
      return -1;
    80004c5c:	b7e5                	j	80004c44 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c5e:	f5040513          	addi	a0,s0,-176
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	742080e7          	jalr	1858(ra) # 800033a4 <namei>
    80004c6a:	892a                	mv	s2,a0
    80004c6c:	c905                	beqz	a0,80004c9c <sys_open+0x13c>
    ilock(ip);
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	f80080e7          	jalr	-128(ra) # 80002bee <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c76:	04491703          	lh	a4,68(s2)
    80004c7a:	4785                	li	a5,1
    80004c7c:	f4f712e3          	bne	a4,a5,80004bc0 <sys_open+0x60>
    80004c80:	f4c42783          	lw	a5,-180(s0)
    80004c84:	dba1                	beqz	a5,80004bd4 <sys_open+0x74>
      iunlockput(ip);
    80004c86:	854a                	mv	a0,s2
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	1c8080e7          	jalr	456(ra) # 80002e50 <iunlockput>
      end_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	9b0080e7          	jalr	-1616(ra) # 80003640 <end_op>
      return -1;
    80004c98:	54fd                	li	s1,-1
    80004c9a:	b76d                	j	80004c44 <sys_open+0xe4>
      end_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	9a4080e7          	jalr	-1628(ra) # 80003640 <end_op>
      return -1;
    80004ca4:	54fd                	li	s1,-1
    80004ca6:	bf79                	j	80004c44 <sys_open+0xe4>
    iunlockput(ip);
    80004ca8:	854a                	mv	a0,s2
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	1a6080e7          	jalr	422(ra) # 80002e50 <iunlockput>
    end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	98e080e7          	jalr	-1650(ra) # 80003640 <end_op>
    return -1;
    80004cba:	54fd                	li	s1,-1
    80004cbc:	b761                	j	80004c44 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cbe:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cc2:	04691783          	lh	a5,70(s2)
    80004cc6:	02f99223          	sh	a5,36(s3)
    80004cca:	bf2d                	j	80004c04 <sys_open+0xa4>
    itrunc(ip);
    80004ccc:	854a                	mv	a0,s2
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	02e080e7          	jalr	46(ra) # 80002cfc <itrunc>
    80004cd6:	bfb1                	j	80004c32 <sys_open+0xd2>
      fileclose(f);
    80004cd8:	854e                	mv	a0,s3
    80004cda:	fffff097          	auipc	ra,0xfffff
    80004cde:	db6080e7          	jalr	-586(ra) # 80003a90 <fileclose>
    iunlockput(ip);
    80004ce2:	854a                	mv	a0,s2
    80004ce4:	ffffe097          	auipc	ra,0xffffe
    80004ce8:	16c080e7          	jalr	364(ra) # 80002e50 <iunlockput>
    end_op();
    80004cec:	fffff097          	auipc	ra,0xfffff
    80004cf0:	954080e7          	jalr	-1708(ra) # 80003640 <end_op>
    return -1;
    80004cf4:	54fd                	li	s1,-1
    80004cf6:	b7b9                	j	80004c44 <sys_open+0xe4>

0000000080004cf8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cf8:	7175                	addi	sp,sp,-144
    80004cfa:	e506                	sd	ra,136(sp)
    80004cfc:	e122                	sd	s0,128(sp)
    80004cfe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	8c0080e7          	jalr	-1856(ra) # 800035c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d08:	08000613          	li	a2,128
    80004d0c:	f7040593          	addi	a1,s0,-144
    80004d10:	4501                	li	a0,0
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	300080e7          	jalr	768(ra) # 80002012 <argstr>
    80004d1a:	02054963          	bltz	a0,80004d4c <sys_mkdir+0x54>
    80004d1e:	4681                	li	a3,0
    80004d20:	4601                	li	a2,0
    80004d22:	4585                	li	a1,1
    80004d24:	f7040513          	addi	a0,s0,-144
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	7fc080e7          	jalr	2044(ra) # 80004524 <create>
    80004d30:	cd11                	beqz	a0,80004d4c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	11e080e7          	jalr	286(ra) # 80002e50 <iunlockput>
  end_op();
    80004d3a:	fffff097          	auipc	ra,0xfffff
    80004d3e:	906080e7          	jalr	-1786(ra) # 80003640 <end_op>
  return 0;
    80004d42:	4501                	li	a0,0
}
    80004d44:	60aa                	ld	ra,136(sp)
    80004d46:	640a                	ld	s0,128(sp)
    80004d48:	6149                	addi	sp,sp,144
    80004d4a:	8082                	ret
    end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	8f4080e7          	jalr	-1804(ra) # 80003640 <end_op>
    return -1;
    80004d54:	557d                	li	a0,-1
    80004d56:	b7fd                	j	80004d44 <sys_mkdir+0x4c>

0000000080004d58 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d58:	7135                	addi	sp,sp,-160
    80004d5a:	ed06                	sd	ra,152(sp)
    80004d5c:	e922                	sd	s0,144(sp)
    80004d5e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	860080e7          	jalr	-1952(ra) # 800035c0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d68:	08000613          	li	a2,128
    80004d6c:	f7040593          	addi	a1,s0,-144
    80004d70:	4501                	li	a0,0
    80004d72:	ffffd097          	auipc	ra,0xffffd
    80004d76:	2a0080e7          	jalr	672(ra) # 80002012 <argstr>
    80004d7a:	04054a63          	bltz	a0,80004dce <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d7e:	f6c40593          	addi	a1,s0,-148
    80004d82:	4505                	li	a0,1
    80004d84:	ffffd097          	auipc	ra,0xffffd
    80004d88:	24a080e7          	jalr	586(ra) # 80001fce <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d8c:	04054163          	bltz	a0,80004dce <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d90:	f6840593          	addi	a1,s0,-152
    80004d94:	4509                	li	a0,2
    80004d96:	ffffd097          	auipc	ra,0xffffd
    80004d9a:	238080e7          	jalr	568(ra) # 80001fce <argint>
     argint(1, &major) < 0 ||
    80004d9e:	02054863          	bltz	a0,80004dce <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004da2:	f6841683          	lh	a3,-152(s0)
    80004da6:	f6c41603          	lh	a2,-148(s0)
    80004daa:	458d                	li	a1,3
    80004dac:	f7040513          	addi	a0,s0,-144
    80004db0:	fffff097          	auipc	ra,0xfffff
    80004db4:	774080e7          	jalr	1908(ra) # 80004524 <create>
     argint(2, &minor) < 0 ||
    80004db8:	c919                	beqz	a0,80004dce <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	096080e7          	jalr	150(ra) # 80002e50 <iunlockput>
  end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	87e080e7          	jalr	-1922(ra) # 80003640 <end_op>
  return 0;
    80004dca:	4501                	li	a0,0
    80004dcc:	a031                	j	80004dd8 <sys_mknod+0x80>
    end_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	872080e7          	jalr	-1934(ra) # 80003640 <end_op>
    return -1;
    80004dd6:	557d                	li	a0,-1
}
    80004dd8:	60ea                	ld	ra,152(sp)
    80004dda:	644a                	ld	s0,144(sp)
    80004ddc:	610d                	addi	sp,sp,160
    80004dde:	8082                	ret

0000000080004de0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004de0:	7135                	addi	sp,sp,-160
    80004de2:	ed06                	sd	ra,152(sp)
    80004de4:	e922                	sd	s0,144(sp)
    80004de6:	e526                	sd	s1,136(sp)
    80004de8:	e14a                	sd	s2,128(sp)
    80004dea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dec:	ffffc097          	auipc	ra,0xffffc
    80004df0:	05e080e7          	jalr	94(ra) # 80000e4a <myproc>
    80004df4:	892a                	mv	s2,a0
  
  begin_op();
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	7ca080e7          	jalr	1994(ra) # 800035c0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dfe:	08000613          	li	a2,128
    80004e02:	f6040593          	addi	a1,s0,-160
    80004e06:	4501                	li	a0,0
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	20a080e7          	jalr	522(ra) # 80002012 <argstr>
    80004e10:	04054b63          	bltz	a0,80004e66 <sys_chdir+0x86>
    80004e14:	f6040513          	addi	a0,s0,-160
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	58c080e7          	jalr	1420(ra) # 800033a4 <namei>
    80004e20:	84aa                	mv	s1,a0
    80004e22:	c131                	beqz	a0,80004e66 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	dca080e7          	jalr	-566(ra) # 80002bee <ilock>
  if(ip->type != T_DIR){
    80004e2c:	04449703          	lh	a4,68(s1)
    80004e30:	4785                	li	a5,1
    80004e32:	04f71063          	bne	a4,a5,80004e72 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e36:	8526                	mv	a0,s1
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	e78080e7          	jalr	-392(ra) # 80002cb0 <iunlock>
  iput(p->cwd);
    80004e40:	28093503          	ld	a0,640(s2)
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	f64080e7          	jalr	-156(ra) # 80002da8 <iput>
  end_op();
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	7f4080e7          	jalr	2036(ra) # 80003640 <end_op>
  p->cwd = ip;
    80004e54:	28993023          	sd	s1,640(s2)
  return 0;
    80004e58:	4501                	li	a0,0
}
    80004e5a:	60ea                	ld	ra,152(sp)
    80004e5c:	644a                	ld	s0,144(sp)
    80004e5e:	64aa                	ld	s1,136(sp)
    80004e60:	690a                	ld	s2,128(sp)
    80004e62:	610d                	addi	sp,sp,160
    80004e64:	8082                	ret
    end_op();
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	7da080e7          	jalr	2010(ra) # 80003640 <end_op>
    return -1;
    80004e6e:	557d                	li	a0,-1
    80004e70:	b7ed                	j	80004e5a <sys_chdir+0x7a>
    iunlockput(ip);
    80004e72:	8526                	mv	a0,s1
    80004e74:	ffffe097          	auipc	ra,0xffffe
    80004e78:	fdc080e7          	jalr	-36(ra) # 80002e50 <iunlockput>
    end_op();
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	7c4080e7          	jalr	1988(ra) # 80003640 <end_op>
    return -1;
    80004e84:	557d                	li	a0,-1
    80004e86:	bfd1                	j	80004e5a <sys_chdir+0x7a>

0000000080004e88 <sys_exec>:

uint64
sys_exec(void)
{
    80004e88:	7145                	addi	sp,sp,-464
    80004e8a:	e786                	sd	ra,456(sp)
    80004e8c:	e3a2                	sd	s0,448(sp)
    80004e8e:	ff26                	sd	s1,440(sp)
    80004e90:	fb4a                	sd	s2,432(sp)
    80004e92:	f74e                	sd	s3,424(sp)
    80004e94:	f352                	sd	s4,416(sp)
    80004e96:	ef56                	sd	s5,408(sp)
    80004e98:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e9a:	08000613          	li	a2,128
    80004e9e:	f4040593          	addi	a1,s0,-192
    80004ea2:	4501                	li	a0,0
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	16e080e7          	jalr	366(ra) # 80002012 <argstr>
    return -1;
    80004eac:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eae:	0c054a63          	bltz	a0,80004f82 <sys_exec+0xfa>
    80004eb2:	e3840593          	addi	a1,s0,-456
    80004eb6:	4505                	li	a0,1
    80004eb8:	ffffd097          	auipc	ra,0xffffd
    80004ebc:	138080e7          	jalr	312(ra) # 80001ff0 <argaddr>
    80004ec0:	0c054163          	bltz	a0,80004f82 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ec4:	10000613          	li	a2,256
    80004ec8:	4581                	li	a1,0
    80004eca:	e4040513          	addi	a0,s0,-448
    80004ece:	ffffb097          	auipc	ra,0xffffb
    80004ed2:	2aa080e7          	jalr	682(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ed6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eda:	89a6                	mv	s3,s1
    80004edc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ede:	02000a13          	li	s4,32
    80004ee2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ee6:	00391513          	slli	a0,s2,0x3
    80004eea:	e3040593          	addi	a1,s0,-464
    80004eee:	e3843783          	ld	a5,-456(s0)
    80004ef2:	953e                	add	a0,a0,a5
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	03a080e7          	jalr	58(ra) # 80001f2e <fetchaddr>
    80004efc:	02054a63          	bltz	a0,80004f30 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f00:	e3043783          	ld	a5,-464(s0)
    80004f04:	c3b9                	beqz	a5,80004f4a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f06:	ffffb097          	auipc	ra,0xffffb
    80004f0a:	212080e7          	jalr	530(ra) # 80000118 <kalloc>
    80004f0e:	85aa                	mv	a1,a0
    80004f10:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f14:	cd11                	beqz	a0,80004f30 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f16:	6605                	lui	a2,0x1
    80004f18:	e3043503          	ld	a0,-464(s0)
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	068080e7          	jalr	104(ra) # 80001f84 <fetchstr>
    80004f24:	00054663          	bltz	a0,80004f30 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f28:	0905                	addi	s2,s2,1
    80004f2a:	09a1                	addi	s3,s3,8
    80004f2c:	fb491be3          	bne	s2,s4,80004ee2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f30:	10048913          	addi	s2,s1,256
    80004f34:	6088                	ld	a0,0(s1)
    80004f36:	c529                	beqz	a0,80004f80 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f38:	ffffb097          	auipc	ra,0xffffb
    80004f3c:	0e4080e7          	jalr	228(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f40:	04a1                	addi	s1,s1,8
    80004f42:	ff2499e3          	bne	s1,s2,80004f34 <sys_exec+0xac>
  return -1;
    80004f46:	597d                	li	s2,-1
    80004f48:	a82d                	j	80004f82 <sys_exec+0xfa>
      argv[i] = 0;
    80004f4a:	0a8e                	slli	s5,s5,0x3
    80004f4c:	fc040793          	addi	a5,s0,-64
    80004f50:	9abe                	add	s5,s5,a5
    80004f52:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f56:	e4040593          	addi	a1,s0,-448
    80004f5a:	f4040513          	addi	a0,s0,-192
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	192080e7          	jalr	402(ra) # 800040f0 <exec>
    80004f66:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f68:	10048993          	addi	s3,s1,256
    80004f6c:	6088                	ld	a0,0(s1)
    80004f6e:	c911                	beqz	a0,80004f82 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f70:	ffffb097          	auipc	ra,0xffffb
    80004f74:	0ac080e7          	jalr	172(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f78:	04a1                	addi	s1,s1,8
    80004f7a:	ff3499e3          	bne	s1,s3,80004f6c <sys_exec+0xe4>
    80004f7e:	a011                	j	80004f82 <sys_exec+0xfa>
  return -1;
    80004f80:	597d                	li	s2,-1
}
    80004f82:	854a                	mv	a0,s2
    80004f84:	60be                	ld	ra,456(sp)
    80004f86:	641e                	ld	s0,448(sp)
    80004f88:	74fa                	ld	s1,440(sp)
    80004f8a:	795a                	ld	s2,432(sp)
    80004f8c:	79ba                	ld	s3,424(sp)
    80004f8e:	7a1a                	ld	s4,416(sp)
    80004f90:	6afa                	ld	s5,408(sp)
    80004f92:	6179                	addi	sp,sp,464
    80004f94:	8082                	ret

0000000080004f96 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f96:	7139                	addi	sp,sp,-64
    80004f98:	fc06                	sd	ra,56(sp)
    80004f9a:	f822                	sd	s0,48(sp)
    80004f9c:	f426                	sd	s1,40(sp)
    80004f9e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fa0:	ffffc097          	auipc	ra,0xffffc
    80004fa4:	eaa080e7          	jalr	-342(ra) # 80000e4a <myproc>
    80004fa8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004faa:	fd840593          	addi	a1,s0,-40
    80004fae:	4501                	li	a0,0
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	040080e7          	jalr	64(ra) # 80001ff0 <argaddr>
    return -1;
    80004fb8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fba:	0e054463          	bltz	a0,800050a2 <sys_pipe+0x10c>
  if(pipealloc(&rf, &wf) < 0)
    80004fbe:	fc840593          	addi	a1,s0,-56
    80004fc2:	fd040513          	addi	a0,s0,-48
    80004fc6:	fffff097          	auipc	ra,0xfffff
    80004fca:	dfa080e7          	jalr	-518(ra) # 80003dc0 <pipealloc>
    return -1;
    80004fce:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fd0:	0c054963          	bltz	a0,800050a2 <sys_pipe+0x10c>
  fd0 = -1;
    80004fd4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fd8:	fd043503          	ld	a0,-48(s0)
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	506080e7          	jalr	1286(ra) # 800044e2 <fdalloc>
    80004fe4:	fca42223          	sw	a0,-60(s0)
    80004fe8:	0a054063          	bltz	a0,80005088 <sys_pipe+0xf2>
    80004fec:	fc843503          	ld	a0,-56(s0)
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	4f2080e7          	jalr	1266(ra) # 800044e2 <fdalloc>
    80004ff8:	fca42023          	sw	a0,-64(s0)
    80004ffc:	06054c63          	bltz	a0,80005074 <sys_pipe+0xde>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005000:	4691                	li	a3,4
    80005002:	fc440613          	addi	a2,s0,-60
    80005006:	fd843583          	ld	a1,-40(s0)
    8000500a:	1804b503          	ld	a0,384(s1)
    8000500e:	ffffc097          	auipc	ra,0xffffc
    80005012:	afc080e7          	jalr	-1284(ra) # 80000b0a <copyout>
    80005016:	02054163          	bltz	a0,80005038 <sys_pipe+0xa2>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000501a:	4691                	li	a3,4
    8000501c:	fc040613          	addi	a2,s0,-64
    80005020:	fd843583          	ld	a1,-40(s0)
    80005024:	0591                	addi	a1,a1,4
    80005026:	1804b503          	ld	a0,384(s1)
    8000502a:	ffffc097          	auipc	ra,0xffffc
    8000502e:	ae0080e7          	jalr	-1312(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005032:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005034:	06055763          	bgez	a0,800050a2 <sys_pipe+0x10c>
    p->ofile[fd0] = 0;
    80005038:	fc442783          	lw	a5,-60(s0)
    8000503c:	04078793          	addi	a5,a5,64
    80005040:	078e                	slli	a5,a5,0x3
    80005042:	97a6                	add	a5,a5,s1
    80005044:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005048:	fc042503          	lw	a0,-64(s0)
    8000504c:	04050513          	addi	a0,a0,64
    80005050:	050e                	slli	a0,a0,0x3
    80005052:	9526                	add	a0,a0,s1
    80005054:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005058:	fd043503          	ld	a0,-48(s0)
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	a34080e7          	jalr	-1484(ra) # 80003a90 <fileclose>
    fileclose(wf);
    80005064:	fc843503          	ld	a0,-56(s0)
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	a28080e7          	jalr	-1496(ra) # 80003a90 <fileclose>
    return -1;
    80005070:	57fd                	li	a5,-1
    80005072:	a805                	j	800050a2 <sys_pipe+0x10c>
    if(fd0 >= 0)
    80005074:	fc442783          	lw	a5,-60(s0)
    80005078:	0007c863          	bltz	a5,80005088 <sys_pipe+0xf2>
      p->ofile[fd0] = 0;
    8000507c:	04078513          	addi	a0,a5,64
    80005080:	050e                	slli	a0,a0,0x3
    80005082:	9526                	add	a0,a0,s1
    80005084:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005088:	fd043503          	ld	a0,-48(s0)
    8000508c:	fffff097          	auipc	ra,0xfffff
    80005090:	a04080e7          	jalr	-1532(ra) # 80003a90 <fileclose>
    fileclose(wf);
    80005094:	fc843503          	ld	a0,-56(s0)
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	9f8080e7          	jalr	-1544(ra) # 80003a90 <fileclose>
    return -1;
    800050a0:	57fd                	li	a5,-1
}
    800050a2:	853e                	mv	a0,a5
    800050a4:	70e2                	ld	ra,56(sp)
    800050a6:	7442                	ld	s0,48(sp)
    800050a8:	74a2                	ld	s1,40(sp)
    800050aa:	6121                	addi	sp,sp,64
    800050ac:	8082                	ret
	...

00000000800050b0 <kernelvec>:
    800050b0:	7111                	addi	sp,sp,-256
    800050b2:	e006                	sd	ra,0(sp)
    800050b4:	e40a                	sd	sp,8(sp)
    800050b6:	e80e                	sd	gp,16(sp)
    800050b8:	ec12                	sd	tp,24(sp)
    800050ba:	f016                	sd	t0,32(sp)
    800050bc:	f41a                	sd	t1,40(sp)
    800050be:	f81e                	sd	t2,48(sp)
    800050c0:	fc22                	sd	s0,56(sp)
    800050c2:	e0a6                	sd	s1,64(sp)
    800050c4:	e4aa                	sd	a0,72(sp)
    800050c6:	e8ae                	sd	a1,80(sp)
    800050c8:	ecb2                	sd	a2,88(sp)
    800050ca:	f0b6                	sd	a3,96(sp)
    800050cc:	f4ba                	sd	a4,104(sp)
    800050ce:	f8be                	sd	a5,112(sp)
    800050d0:	fcc2                	sd	a6,120(sp)
    800050d2:	e146                	sd	a7,128(sp)
    800050d4:	e54a                	sd	s2,136(sp)
    800050d6:	e94e                	sd	s3,144(sp)
    800050d8:	ed52                	sd	s4,152(sp)
    800050da:	f156                	sd	s5,160(sp)
    800050dc:	f55a                	sd	s6,168(sp)
    800050de:	f95e                	sd	s7,176(sp)
    800050e0:	fd62                	sd	s8,184(sp)
    800050e2:	e1e6                	sd	s9,192(sp)
    800050e4:	e5ea                	sd	s10,200(sp)
    800050e6:	e9ee                	sd	s11,208(sp)
    800050e8:	edf2                	sd	t3,216(sp)
    800050ea:	f1f6                	sd	t4,224(sp)
    800050ec:	f5fa                	sd	t5,232(sp)
    800050ee:	f9fe                	sd	t6,240(sp)
    800050f0:	cfdfc0ef          	jal	ra,80001dec <kerneltrap>
    800050f4:	6082                	ld	ra,0(sp)
    800050f6:	6122                	ld	sp,8(sp)
    800050f8:	61c2                	ld	gp,16(sp)
    800050fa:	7282                	ld	t0,32(sp)
    800050fc:	7322                	ld	t1,40(sp)
    800050fe:	73c2                	ld	t2,48(sp)
    80005100:	7462                	ld	s0,56(sp)
    80005102:	6486                	ld	s1,64(sp)
    80005104:	6526                	ld	a0,72(sp)
    80005106:	65c6                	ld	a1,80(sp)
    80005108:	6666                	ld	a2,88(sp)
    8000510a:	7686                	ld	a3,96(sp)
    8000510c:	7726                	ld	a4,104(sp)
    8000510e:	77c6                	ld	a5,112(sp)
    80005110:	7866                	ld	a6,120(sp)
    80005112:	688a                	ld	a7,128(sp)
    80005114:	692a                	ld	s2,136(sp)
    80005116:	69ca                	ld	s3,144(sp)
    80005118:	6a6a                	ld	s4,152(sp)
    8000511a:	7a8a                	ld	s5,160(sp)
    8000511c:	7b2a                	ld	s6,168(sp)
    8000511e:	7bca                	ld	s7,176(sp)
    80005120:	7c6a                	ld	s8,184(sp)
    80005122:	6c8e                	ld	s9,192(sp)
    80005124:	6d2e                	ld	s10,200(sp)
    80005126:	6dce                	ld	s11,208(sp)
    80005128:	6e6e                	ld	t3,216(sp)
    8000512a:	7e8e                	ld	t4,224(sp)
    8000512c:	7f2e                	ld	t5,232(sp)
    8000512e:	7fce                	ld	t6,240(sp)
    80005130:	6111                	addi	sp,sp,256
    80005132:	10200073          	sret
    80005136:	00000013          	nop
    8000513a:	00000013          	nop
    8000513e:	0001                	nop

0000000080005140 <timervec>:
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	e10c                	sd	a1,0(a0)
    80005146:	e510                	sd	a2,8(a0)
    80005148:	e914                	sd	a3,16(a0)
    8000514a:	6d0c                	ld	a1,24(a0)
    8000514c:	7110                	ld	a2,32(a0)
    8000514e:	6194                	ld	a3,0(a1)
    80005150:	96b2                	add	a3,a3,a2
    80005152:	e194                	sd	a3,0(a1)
    80005154:	4589                	li	a1,2
    80005156:	14459073          	csrw	sip,a1
    8000515a:	6914                	ld	a3,16(a0)
    8000515c:	6510                	ld	a2,8(a0)
    8000515e:	610c                	ld	a1,0(a0)
    80005160:	34051573          	csrrw	a0,mscratch,a0
    80005164:	30200073          	mret
	...

000000008000516a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000516a:	1141                	addi	sp,sp,-16
    8000516c:	e422                	sd	s0,8(sp)
    8000516e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005170:	0c0007b7          	lui	a5,0xc000
    80005174:	4705                	li	a4,1
    80005176:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005178:	c3d8                	sw	a4,4(a5)
}
    8000517a:	6422                	ld	s0,8(sp)
    8000517c:	0141                	addi	sp,sp,16
    8000517e:	8082                	ret

0000000080005180 <plicinithart>:

void
plicinithart(void)
{
    80005180:	1141                	addi	sp,sp,-16
    80005182:	e406                	sd	ra,8(sp)
    80005184:	e022                	sd	s0,0(sp)
    80005186:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	c96080e7          	jalr	-874(ra) # 80000e1e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005190:	0085171b          	slliw	a4,a0,0x8
    80005194:	0c0027b7          	lui	a5,0xc002
    80005198:	97ba                	add	a5,a5,a4
    8000519a:	40200713          	li	a4,1026
    8000519e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051a2:	00d5151b          	slliw	a0,a0,0xd
    800051a6:	0c2017b7          	lui	a5,0xc201
    800051aa:	953e                	add	a0,a0,a5
    800051ac:	00052023          	sw	zero,0(a0)
}
    800051b0:	60a2                	ld	ra,8(sp)
    800051b2:	6402                	ld	s0,0(sp)
    800051b4:	0141                	addi	sp,sp,16
    800051b6:	8082                	ret

00000000800051b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051b8:	1141                	addi	sp,sp,-16
    800051ba:	e406                	sd	ra,8(sp)
    800051bc:	e022                	sd	s0,0(sp)
    800051be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051c0:	ffffc097          	auipc	ra,0xffffc
    800051c4:	c5e080e7          	jalr	-930(ra) # 80000e1e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051c8:	00d5179b          	slliw	a5,a0,0xd
    800051cc:	0c201537          	lui	a0,0xc201
    800051d0:	953e                	add	a0,a0,a5
  return irq;
}
    800051d2:	4148                	lw	a0,4(a0)
    800051d4:	60a2                	ld	ra,8(sp)
    800051d6:	6402                	ld	s0,0(sp)
    800051d8:	0141                	addi	sp,sp,16
    800051da:	8082                	ret

00000000800051dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051dc:	1101                	addi	sp,sp,-32
    800051de:	ec06                	sd	ra,24(sp)
    800051e0:	e822                	sd	s0,16(sp)
    800051e2:	e426                	sd	s1,8(sp)
    800051e4:	1000                	addi	s0,sp,32
    800051e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051e8:	ffffc097          	auipc	ra,0xffffc
    800051ec:	c36080e7          	jalr	-970(ra) # 80000e1e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051f0:	00d5151b          	slliw	a0,a0,0xd
    800051f4:	0c2017b7          	lui	a5,0xc201
    800051f8:	97aa                	add	a5,a5,a0
    800051fa:	c3c4                	sw	s1,4(a5)
}
    800051fc:	60e2                	ld	ra,24(sp)
    800051fe:	6442                	ld	s0,16(sp)
    80005200:	64a2                	ld	s1,8(sp)
    80005202:	6105                	addi	sp,sp,32
    80005204:	8082                	ret

0000000080005206 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005206:	1141                	addi	sp,sp,-16
    80005208:	e406                	sd	ra,8(sp)
    8000520a:	e022                	sd	s0,0(sp)
    8000520c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000520e:	479d                	li	a5,7
    80005210:	06a7c963          	blt	a5,a0,80005282 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005214:	0001a797          	auipc	a5,0x1a
    80005218:	dec78793          	addi	a5,a5,-532 # 8001f000 <disk>
    8000521c:	00a78733          	add	a4,a5,a0
    80005220:	6789                	lui	a5,0x2
    80005222:	97ba                	add	a5,a5,a4
    80005224:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005228:	e7ad                	bnez	a5,80005292 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000522a:	00451793          	slli	a5,a0,0x4
    8000522e:	0001c717          	auipc	a4,0x1c
    80005232:	dd270713          	addi	a4,a4,-558 # 80021000 <disk+0x2000>
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000523e:	6314                	ld	a3,0(a4)
    80005240:	96be                	add	a3,a3,a5
    80005242:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005246:	6314                	ld	a3,0(a4)
    80005248:	96be                	add	a3,a3,a5
    8000524a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000524e:	6318                	ld	a4,0(a4)
    80005250:	97ba                	add	a5,a5,a4
    80005252:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005256:	0001a797          	auipc	a5,0x1a
    8000525a:	daa78793          	addi	a5,a5,-598 # 8001f000 <disk>
    8000525e:	97aa                	add	a5,a5,a0
    80005260:	6509                	lui	a0,0x2
    80005262:	953e                	add	a0,a0,a5
    80005264:	4785                	li	a5,1
    80005266:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000526a:	0001c517          	auipc	a0,0x1c
    8000526e:	dae50513          	addi	a0,a0,-594 # 80021018 <disk+0x2018>
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	454080e7          	jalr	1108(ra) # 800016c6 <wakeup>
}
    8000527a:	60a2                	ld	ra,8(sp)
    8000527c:	6402                	ld	s0,0(sp)
    8000527e:	0141                	addi	sp,sp,16
    80005280:	8082                	ret
    panic("free_desc 1");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	47650513          	addi	a0,a0,1142 # 800086f8 <syscalls+0x330>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	a20080e7          	jalr	-1504(ra) # 80005caa <panic>
    panic("free_desc 2");
    80005292:	00003517          	auipc	a0,0x3
    80005296:	47650513          	addi	a0,a0,1142 # 80008708 <syscalls+0x340>
    8000529a:	00001097          	auipc	ra,0x1
    8000529e:	a10080e7          	jalr	-1520(ra) # 80005caa <panic>

00000000800052a2 <virtio_disk_init>:
{
    800052a2:	1101                	addi	sp,sp,-32
    800052a4:	ec06                	sd	ra,24(sp)
    800052a6:	e822                	sd	s0,16(sp)
    800052a8:	e426                	sd	s1,8(sp)
    800052aa:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052ac:	00003597          	auipc	a1,0x3
    800052b0:	46c58593          	addi	a1,a1,1132 # 80008718 <syscalls+0x350>
    800052b4:	0001c517          	auipc	a0,0x1c
    800052b8:	e7450513          	addi	a0,a0,-396 # 80021128 <disk+0x2128>
    800052bc:	00001097          	auipc	ra,0x1
    800052c0:	ef8080e7          	jalr	-264(ra) # 800061b4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052c4:	100017b7          	lui	a5,0x10001
    800052c8:	4398                	lw	a4,0(a5)
    800052ca:	2701                	sext.w	a4,a4
    800052cc:	747277b7          	lui	a5,0x74727
    800052d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052d4:	0ef71163          	bne	a4,a5,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052d8:	100017b7          	lui	a5,0x10001
    800052dc:	43dc                	lw	a5,4(a5)
    800052de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052e0:	4705                	li	a4,1
    800052e2:	0ce79a63          	bne	a5,a4,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052e6:	100017b7          	lui	a5,0x10001
    800052ea:	479c                	lw	a5,8(a5)
    800052ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ee:	4709                	li	a4,2
    800052f0:	0ce79363          	bne	a5,a4,800053b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052f4:	100017b7          	lui	a5,0x10001
    800052f8:	47d8                	lw	a4,12(a5)
    800052fa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052fc:	554d47b7          	lui	a5,0x554d4
    80005300:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005304:	0af71963          	bne	a4,a5,800053b6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	100017b7          	lui	a5,0x10001
    8000530c:	4705                	li	a4,1
    8000530e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005310:	470d                	li	a4,3
    80005312:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005314:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005316:	c7ffe737          	lui	a4,0xc7ffe
    8000531a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd451f>
    8000531e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005320:	2701                	sext.w	a4,a4
    80005322:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005324:	472d                	li	a4,11
    80005326:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005328:	473d                	li	a4,15
    8000532a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000532c:	6705                	lui	a4,0x1
    8000532e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005330:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005334:	5bdc                	lw	a5,52(a5)
    80005336:	2781                	sext.w	a5,a5
  if(max == 0)
    80005338:	c7d9                	beqz	a5,800053c6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000533a:	471d                	li	a4,7
    8000533c:	08f77d63          	bgeu	a4,a5,800053d6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005340:	100014b7          	lui	s1,0x10001
    80005344:	47a1                	li	a5,8
    80005346:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005348:	6609                	lui	a2,0x2
    8000534a:	4581                	li	a1,0
    8000534c:	0001a517          	auipc	a0,0x1a
    80005350:	cb450513          	addi	a0,a0,-844 # 8001f000 <disk>
    80005354:	ffffb097          	auipc	ra,0xffffb
    80005358:	e24080e7          	jalr	-476(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000535c:	0001a717          	auipc	a4,0x1a
    80005360:	ca470713          	addi	a4,a4,-860 # 8001f000 <disk>
    80005364:	00c75793          	srli	a5,a4,0xc
    80005368:	2781                	sext.w	a5,a5
    8000536a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000536c:	0001c797          	auipc	a5,0x1c
    80005370:	c9478793          	addi	a5,a5,-876 # 80021000 <disk+0x2000>
    80005374:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005376:	0001a717          	auipc	a4,0x1a
    8000537a:	d0a70713          	addi	a4,a4,-758 # 8001f080 <disk+0x80>
    8000537e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005380:	0001b717          	auipc	a4,0x1b
    80005384:	c8070713          	addi	a4,a4,-896 # 80020000 <disk+0x1000>
    80005388:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000538a:	4705                	li	a4,1
    8000538c:	00e78c23          	sb	a4,24(a5)
    80005390:	00e78ca3          	sb	a4,25(a5)
    80005394:	00e78d23          	sb	a4,26(a5)
    80005398:	00e78da3          	sb	a4,27(a5)
    8000539c:	00e78e23          	sb	a4,28(a5)
    800053a0:	00e78ea3          	sb	a4,29(a5)
    800053a4:	00e78f23          	sb	a4,30(a5)
    800053a8:	00e78fa3          	sb	a4,31(a5)
}
    800053ac:	60e2                	ld	ra,24(sp)
    800053ae:	6442                	ld	s0,16(sp)
    800053b0:	64a2                	ld	s1,8(sp)
    800053b2:	6105                	addi	sp,sp,32
    800053b4:	8082                	ret
    panic("could not find virtio disk");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	37250513          	addi	a0,a0,882 # 80008728 <syscalls+0x360>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	8ec080e7          	jalr	-1812(ra) # 80005caa <panic>
    panic("virtio disk has no queue 0");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	38250513          	addi	a0,a0,898 # 80008748 <syscalls+0x380>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	8dc080e7          	jalr	-1828(ra) # 80005caa <panic>
    panic("virtio disk max queue too short");
    800053d6:	00003517          	auipc	a0,0x3
    800053da:	39250513          	addi	a0,a0,914 # 80008768 <syscalls+0x3a0>
    800053de:	00001097          	auipc	ra,0x1
    800053e2:	8cc080e7          	jalr	-1844(ra) # 80005caa <panic>

00000000800053e6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053e6:	7159                	addi	sp,sp,-112
    800053e8:	f486                	sd	ra,104(sp)
    800053ea:	f0a2                	sd	s0,96(sp)
    800053ec:	eca6                	sd	s1,88(sp)
    800053ee:	e8ca                	sd	s2,80(sp)
    800053f0:	e4ce                	sd	s3,72(sp)
    800053f2:	e0d2                	sd	s4,64(sp)
    800053f4:	fc56                	sd	s5,56(sp)
    800053f6:	f85a                	sd	s6,48(sp)
    800053f8:	f45e                	sd	s7,40(sp)
    800053fa:	f062                	sd	s8,32(sp)
    800053fc:	ec66                	sd	s9,24(sp)
    800053fe:	e86a                	sd	s10,16(sp)
    80005400:	1880                	addi	s0,sp,112
    80005402:	892a                	mv	s2,a0
    80005404:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005406:	00c52c83          	lw	s9,12(a0)
    8000540a:	001c9c9b          	slliw	s9,s9,0x1
    8000540e:	1c82                	slli	s9,s9,0x20
    80005410:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005414:	0001c517          	auipc	a0,0x1c
    80005418:	d1450513          	addi	a0,a0,-748 # 80021128 <disk+0x2128>
    8000541c:	00001097          	auipc	ra,0x1
    80005420:	e28080e7          	jalr	-472(ra) # 80006244 <acquire>
  for(int i = 0; i < 3; i++){
    80005424:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005426:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005428:	0001ab97          	auipc	s7,0x1a
    8000542c:	bd8b8b93          	addi	s7,s7,-1064 # 8001f000 <disk>
    80005430:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005432:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005434:	8a4e                	mv	s4,s3
    80005436:	a051                	j	800054ba <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005438:	00fb86b3          	add	a3,s7,a5
    8000543c:	96da                	add	a3,a3,s6
    8000543e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005442:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005444:	0207c563          	bltz	a5,8000546e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005448:	2485                	addiw	s1,s1,1
    8000544a:	0711                	addi	a4,a4,4
    8000544c:	25548063          	beq	s1,s5,8000568c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005450:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005452:	0001c697          	auipc	a3,0x1c
    80005456:	bc668693          	addi	a3,a3,-1082 # 80021018 <disk+0x2018>
    8000545a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000545c:	0006c583          	lbu	a1,0(a3)
    80005460:	fde1                	bnez	a1,80005438 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005462:	2785                	addiw	a5,a5,1
    80005464:	0685                	addi	a3,a3,1
    80005466:	ff879be3          	bne	a5,s8,8000545c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000546a:	57fd                	li	a5,-1
    8000546c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000546e:	02905a63          	blez	s1,800054a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005472:	f9042503          	lw	a0,-112(s0)
    80005476:	00000097          	auipc	ra,0x0
    8000547a:	d90080e7          	jalr	-624(ra) # 80005206 <free_desc>
      for(int j = 0; j < i; j++)
    8000547e:	4785                	li	a5,1
    80005480:	0297d163          	bge	a5,s1,800054a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005484:	f9442503          	lw	a0,-108(s0)
    80005488:	00000097          	auipc	ra,0x0
    8000548c:	d7e080e7          	jalr	-642(ra) # 80005206 <free_desc>
      for(int j = 0; j < i; j++)
    80005490:	4789                	li	a5,2
    80005492:	0097d863          	bge	a5,s1,800054a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005496:	f9842503          	lw	a0,-104(s0)
    8000549a:	00000097          	auipc	ra,0x0
    8000549e:	d6c080e7          	jalr	-660(ra) # 80005206 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054a2:	0001c597          	auipc	a1,0x1c
    800054a6:	c8658593          	addi	a1,a1,-890 # 80021128 <disk+0x2128>
    800054aa:	0001c517          	auipc	a0,0x1c
    800054ae:	b6e50513          	addi	a0,a0,-1170 # 80021018 <disk+0x2018>
    800054b2:	ffffc097          	auipc	ra,0xffffc
    800054b6:	082080e7          	jalr	130(ra) # 80001534 <sleep>
  for(int i = 0; i < 3; i++){
    800054ba:	f9040713          	addi	a4,s0,-112
    800054be:	84ce                	mv	s1,s3
    800054c0:	bf41                	j	80005450 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054c2:	20058713          	addi	a4,a1,512
    800054c6:	00471693          	slli	a3,a4,0x4
    800054ca:	0001a717          	auipc	a4,0x1a
    800054ce:	b3670713          	addi	a4,a4,-1226 # 8001f000 <disk>
    800054d2:	9736                	add	a4,a4,a3
    800054d4:	4685                	li	a3,1
    800054d6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054da:	20058713          	addi	a4,a1,512
    800054de:	00471693          	slli	a3,a4,0x4
    800054e2:	0001a717          	auipc	a4,0x1a
    800054e6:	b1e70713          	addi	a4,a4,-1250 # 8001f000 <disk>
    800054ea:	9736                	add	a4,a4,a3
    800054ec:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054f0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054f4:	7679                	lui	a2,0xffffe
    800054f6:	963e                	add	a2,a2,a5
    800054f8:	0001c697          	auipc	a3,0x1c
    800054fc:	b0868693          	addi	a3,a3,-1272 # 80021000 <disk+0x2000>
    80005500:	6298                	ld	a4,0(a3)
    80005502:	9732                	add	a4,a4,a2
    80005504:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005506:	6298                	ld	a4,0(a3)
    80005508:	9732                	add	a4,a4,a2
    8000550a:	4541                	li	a0,16
    8000550c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000550e:	6298                	ld	a4,0(a3)
    80005510:	9732                	add	a4,a4,a2
    80005512:	4505                	li	a0,1
    80005514:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005518:	f9442703          	lw	a4,-108(s0)
    8000551c:	6288                	ld	a0,0(a3)
    8000551e:	962a                	add	a2,a2,a0
    80005520:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd3dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005524:	0712                	slli	a4,a4,0x4
    80005526:	6290                	ld	a2,0(a3)
    80005528:	963a                	add	a2,a2,a4
    8000552a:	05890513          	addi	a0,s2,88
    8000552e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005530:	6294                	ld	a3,0(a3)
    80005532:	96ba                	add	a3,a3,a4
    80005534:	40000613          	li	a2,1024
    80005538:	c690                	sw	a2,8(a3)
  if(write)
    8000553a:	140d0063          	beqz	s10,8000567a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000553e:	0001c697          	auipc	a3,0x1c
    80005542:	ac26b683          	ld	a3,-1342(a3) # 80021000 <disk+0x2000>
    80005546:	96ba                	add	a3,a3,a4
    80005548:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000554c:	0001a817          	auipc	a6,0x1a
    80005550:	ab480813          	addi	a6,a6,-1356 # 8001f000 <disk>
    80005554:	0001c517          	auipc	a0,0x1c
    80005558:	aac50513          	addi	a0,a0,-1364 # 80021000 <disk+0x2000>
    8000555c:	6114                	ld	a3,0(a0)
    8000555e:	96ba                	add	a3,a3,a4
    80005560:	00c6d603          	lhu	a2,12(a3)
    80005564:	00166613          	ori	a2,a2,1
    80005568:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000556c:	f9842683          	lw	a3,-104(s0)
    80005570:	6110                	ld	a2,0(a0)
    80005572:	9732                	add	a4,a4,a2
    80005574:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005578:	20058613          	addi	a2,a1,512
    8000557c:	0612                	slli	a2,a2,0x4
    8000557e:	9642                	add	a2,a2,a6
    80005580:	577d                	li	a4,-1
    80005582:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005586:	00469713          	slli	a4,a3,0x4
    8000558a:	6114                	ld	a3,0(a0)
    8000558c:	96ba                	add	a3,a3,a4
    8000558e:	03078793          	addi	a5,a5,48
    80005592:	97c2                	add	a5,a5,a6
    80005594:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005596:	611c                	ld	a5,0(a0)
    80005598:	97ba                	add	a5,a5,a4
    8000559a:	4685                	li	a3,1
    8000559c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000559e:	611c                	ld	a5,0(a0)
    800055a0:	97ba                	add	a5,a5,a4
    800055a2:	4809                	li	a6,2
    800055a4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800055a8:	611c                	ld	a5,0(a0)
    800055aa:	973e                	add	a4,a4,a5
    800055ac:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055b0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800055b4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055b8:	6518                	ld	a4,8(a0)
    800055ba:	00275783          	lhu	a5,2(a4)
    800055be:	8b9d                	andi	a5,a5,7
    800055c0:	0786                	slli	a5,a5,0x1
    800055c2:	97ba                	add	a5,a5,a4
    800055c4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055c8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055cc:	6518                	ld	a4,8(a0)
    800055ce:	00275783          	lhu	a5,2(a4)
    800055d2:	2785                	addiw	a5,a5,1
    800055d4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055d8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055dc:	100017b7          	lui	a5,0x10001
    800055e0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055e4:	00492703          	lw	a4,4(s2)
    800055e8:	4785                	li	a5,1
    800055ea:	02f71163          	bne	a4,a5,8000560c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055ee:	0001c997          	auipc	s3,0x1c
    800055f2:	b3a98993          	addi	s3,s3,-1222 # 80021128 <disk+0x2128>
  while(b->disk == 1) {
    800055f6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055f8:	85ce                	mv	a1,s3
    800055fa:	854a                	mv	a0,s2
    800055fc:	ffffc097          	auipc	ra,0xffffc
    80005600:	f38080e7          	jalr	-200(ra) # 80001534 <sleep>
  while(b->disk == 1) {
    80005604:	00492783          	lw	a5,4(s2)
    80005608:	fe9788e3          	beq	a5,s1,800055f8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000560c:	f9042903          	lw	s2,-112(s0)
    80005610:	20090793          	addi	a5,s2,512
    80005614:	00479713          	slli	a4,a5,0x4
    80005618:	0001a797          	auipc	a5,0x1a
    8000561c:	9e878793          	addi	a5,a5,-1560 # 8001f000 <disk>
    80005620:	97ba                	add	a5,a5,a4
    80005622:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005626:	0001c997          	auipc	s3,0x1c
    8000562a:	9da98993          	addi	s3,s3,-1574 # 80021000 <disk+0x2000>
    8000562e:	00491713          	slli	a4,s2,0x4
    80005632:	0009b783          	ld	a5,0(s3)
    80005636:	97ba                	add	a5,a5,a4
    80005638:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000563c:	854a                	mv	a0,s2
    8000563e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005642:	00000097          	auipc	ra,0x0
    80005646:	bc4080e7          	jalr	-1084(ra) # 80005206 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000564a:	8885                	andi	s1,s1,1
    8000564c:	f0ed                	bnez	s1,8000562e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000564e:	0001c517          	auipc	a0,0x1c
    80005652:	ada50513          	addi	a0,a0,-1318 # 80021128 <disk+0x2128>
    80005656:	00001097          	auipc	ra,0x1
    8000565a:	ca2080e7          	jalr	-862(ra) # 800062f8 <release>
}
    8000565e:	70a6                	ld	ra,104(sp)
    80005660:	7406                	ld	s0,96(sp)
    80005662:	64e6                	ld	s1,88(sp)
    80005664:	6946                	ld	s2,80(sp)
    80005666:	69a6                	ld	s3,72(sp)
    80005668:	6a06                	ld	s4,64(sp)
    8000566a:	7ae2                	ld	s5,56(sp)
    8000566c:	7b42                	ld	s6,48(sp)
    8000566e:	7ba2                	ld	s7,40(sp)
    80005670:	7c02                	ld	s8,32(sp)
    80005672:	6ce2                	ld	s9,24(sp)
    80005674:	6d42                	ld	s10,16(sp)
    80005676:	6165                	addi	sp,sp,112
    80005678:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000567a:	0001c697          	auipc	a3,0x1c
    8000567e:	9866b683          	ld	a3,-1658(a3) # 80021000 <disk+0x2000>
    80005682:	96ba                	add	a3,a3,a4
    80005684:	4609                	li	a2,2
    80005686:	00c69623          	sh	a2,12(a3)
    8000568a:	b5c9                	j	8000554c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000568c:	f9042583          	lw	a1,-112(s0)
    80005690:	20058793          	addi	a5,a1,512
    80005694:	0792                	slli	a5,a5,0x4
    80005696:	0001a517          	auipc	a0,0x1a
    8000569a:	a1250513          	addi	a0,a0,-1518 # 8001f0a8 <disk+0xa8>
    8000569e:	953e                	add	a0,a0,a5
  if(write)
    800056a0:	e20d11e3          	bnez	s10,800054c2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056a4:	20058713          	addi	a4,a1,512
    800056a8:	00471693          	slli	a3,a4,0x4
    800056ac:	0001a717          	auipc	a4,0x1a
    800056b0:	95470713          	addi	a4,a4,-1708 # 8001f000 <disk>
    800056b4:	9736                	add	a4,a4,a3
    800056b6:	0a072423          	sw	zero,168(a4)
    800056ba:	b505                	j	800054da <virtio_disk_rw+0xf4>

00000000800056bc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056bc:	1101                	addi	sp,sp,-32
    800056be:	ec06                	sd	ra,24(sp)
    800056c0:	e822                	sd	s0,16(sp)
    800056c2:	e426                	sd	s1,8(sp)
    800056c4:	e04a                	sd	s2,0(sp)
    800056c6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056c8:	0001c517          	auipc	a0,0x1c
    800056cc:	a6050513          	addi	a0,a0,-1440 # 80021128 <disk+0x2128>
    800056d0:	00001097          	auipc	ra,0x1
    800056d4:	b74080e7          	jalr	-1164(ra) # 80006244 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056d8:	10001737          	lui	a4,0x10001
    800056dc:	533c                	lw	a5,96(a4)
    800056de:	8b8d                	andi	a5,a5,3
    800056e0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056e2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056e6:	0001c797          	auipc	a5,0x1c
    800056ea:	91a78793          	addi	a5,a5,-1766 # 80021000 <disk+0x2000>
    800056ee:	6b94                	ld	a3,16(a5)
    800056f0:	0207d703          	lhu	a4,32(a5)
    800056f4:	0026d783          	lhu	a5,2(a3)
    800056f8:	06f70163          	beq	a4,a5,8000575a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056fc:	0001a917          	auipc	s2,0x1a
    80005700:	90490913          	addi	s2,s2,-1788 # 8001f000 <disk>
    80005704:	0001c497          	auipc	s1,0x1c
    80005708:	8fc48493          	addi	s1,s1,-1796 # 80021000 <disk+0x2000>
    __sync_synchronize();
    8000570c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005710:	6898                	ld	a4,16(s1)
    80005712:	0204d783          	lhu	a5,32(s1)
    80005716:	8b9d                	andi	a5,a5,7
    80005718:	078e                	slli	a5,a5,0x3
    8000571a:	97ba                	add	a5,a5,a4
    8000571c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000571e:	20078713          	addi	a4,a5,512
    80005722:	0712                	slli	a4,a4,0x4
    80005724:	974a                	add	a4,a4,s2
    80005726:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000572a:	e731                	bnez	a4,80005776 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000572c:	20078793          	addi	a5,a5,512
    80005730:	0792                	slli	a5,a5,0x4
    80005732:	97ca                	add	a5,a5,s2
    80005734:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005736:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000573a:	ffffc097          	auipc	ra,0xffffc
    8000573e:	f8c080e7          	jalr	-116(ra) # 800016c6 <wakeup>

    disk.used_idx += 1;
    80005742:	0204d783          	lhu	a5,32(s1)
    80005746:	2785                	addiw	a5,a5,1
    80005748:	17c2                	slli	a5,a5,0x30
    8000574a:	93c1                	srli	a5,a5,0x30
    8000574c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005750:	6898                	ld	a4,16(s1)
    80005752:	00275703          	lhu	a4,2(a4)
    80005756:	faf71be3          	bne	a4,a5,8000570c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000575a:	0001c517          	auipc	a0,0x1c
    8000575e:	9ce50513          	addi	a0,a0,-1586 # 80021128 <disk+0x2128>
    80005762:	00001097          	auipc	ra,0x1
    80005766:	b96080e7          	jalr	-1130(ra) # 800062f8 <release>
}
    8000576a:	60e2                	ld	ra,24(sp)
    8000576c:	6442                	ld	s0,16(sp)
    8000576e:	64a2                	ld	s1,8(sp)
    80005770:	6902                	ld	s2,0(sp)
    80005772:	6105                	addi	sp,sp,32
    80005774:	8082                	ret
      panic("virtio_disk_intr status");
    80005776:	00003517          	auipc	a0,0x3
    8000577a:	01250513          	addi	a0,a0,18 # 80008788 <syscalls+0x3c0>
    8000577e:	00000097          	auipc	ra,0x0
    80005782:	52c080e7          	jalr	1324(ra) # 80005caa <panic>

0000000080005786 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005786:	1141                	addi	sp,sp,-16
    80005788:	e422                	sd	s0,8(sp)
    8000578a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000578c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005790:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005794:	0037979b          	slliw	a5,a5,0x3
    80005798:	02004737          	lui	a4,0x2004
    8000579c:	97ba                	add	a5,a5,a4
    8000579e:	0200c737          	lui	a4,0x200c
    800057a2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057a6:	000f4637          	lui	a2,0xf4
    800057aa:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057ae:	95b2                	add	a1,a1,a2
    800057b0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057b2:	00269713          	slli	a4,a3,0x2
    800057b6:	9736                	add	a4,a4,a3
    800057b8:	00371693          	slli	a3,a4,0x3
    800057bc:	0001d717          	auipc	a4,0x1d
    800057c0:	84470713          	addi	a4,a4,-1980 # 80022000 <timer_scratch>
    800057c4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057c6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057c8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ca:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ce:	00000797          	auipc	a5,0x0
    800057d2:	97278793          	addi	a5,a5,-1678 # 80005140 <timervec>
    800057d6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057da:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057de:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057e2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057e6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057ea:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057ee:	30479073          	csrw	mie,a5
}
    800057f2:	6422                	ld	s0,8(sp)
    800057f4:	0141                	addi	sp,sp,16
    800057f6:	8082                	ret

00000000800057f8 <start>:
{
    800057f8:	1141                	addi	sp,sp,-16
    800057fa:	e406                	sd	ra,8(sp)
    800057fc:	e022                	sd	s0,0(sp)
    800057fe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005800:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005804:	7779                	lui	a4,0xffffe
    80005806:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd45bf>
    8000580a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000580c:	6705                	lui	a4,0x1
    8000580e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005812:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005814:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005818:	ffffb797          	auipc	a5,0xffffb
    8000581c:	b0e78793          	addi	a5,a5,-1266 # 80000326 <main>
    80005820:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005824:	4781                	li	a5,0
    80005826:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000582a:	67c1                	lui	a5,0x10
    8000582c:	17fd                	addi	a5,a5,-1
    8000582e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005832:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005836:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000583a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000583e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005842:	57fd                	li	a5,-1
    80005844:	83a9                	srli	a5,a5,0xa
    80005846:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000584a:	47bd                	li	a5,15
    8000584c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005850:	00000097          	auipc	ra,0x0
    80005854:	f36080e7          	jalr	-202(ra) # 80005786 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005858:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000585c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000585e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005860:	30200073          	mret
}
    80005864:	60a2                	ld	ra,8(sp)
    80005866:	6402                	ld	s0,0(sp)
    80005868:	0141                	addi	sp,sp,16
    8000586a:	8082                	ret

000000008000586c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000586c:	715d                	addi	sp,sp,-80
    8000586e:	e486                	sd	ra,72(sp)
    80005870:	e0a2                	sd	s0,64(sp)
    80005872:	fc26                	sd	s1,56(sp)
    80005874:	f84a                	sd	s2,48(sp)
    80005876:	f44e                	sd	s3,40(sp)
    80005878:	f052                	sd	s4,32(sp)
    8000587a:	ec56                	sd	s5,24(sp)
    8000587c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000587e:	04c05663          	blez	a2,800058ca <consolewrite+0x5e>
    80005882:	8a2a                	mv	s4,a0
    80005884:	84ae                	mv	s1,a1
    80005886:	89b2                	mv	s3,a2
    80005888:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000588a:	5afd                	li	s5,-1
    8000588c:	4685                	li	a3,1
    8000588e:	8626                	mv	a2,s1
    80005890:	85d2                	mv	a1,s4
    80005892:	fbf40513          	addi	a0,s0,-65
    80005896:	ffffc097          	auipc	ra,0xffffc
    8000589a:	0b0080e7          	jalr	176(ra) # 80001946 <either_copyin>
    8000589e:	01550c63          	beq	a0,s5,800058b6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800058a2:	fbf44503          	lbu	a0,-65(s0)
    800058a6:	00000097          	auipc	ra,0x0
    800058aa:	7e0080e7          	jalr	2016(ra) # 80006086 <uartputc>
  for(i = 0; i < n; i++){
    800058ae:	2905                	addiw	s2,s2,1
    800058b0:	0485                	addi	s1,s1,1
    800058b2:	fd299de3          	bne	s3,s2,8000588c <consolewrite+0x20>
  }

  return i;
}
    800058b6:	854a                	mv	a0,s2
    800058b8:	60a6                	ld	ra,72(sp)
    800058ba:	6406                	ld	s0,64(sp)
    800058bc:	74e2                	ld	s1,56(sp)
    800058be:	7942                	ld	s2,48(sp)
    800058c0:	79a2                	ld	s3,40(sp)
    800058c2:	7a02                	ld	s4,32(sp)
    800058c4:	6ae2                	ld	s5,24(sp)
    800058c6:	6161                	addi	sp,sp,80
    800058c8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ca:	4901                	li	s2,0
    800058cc:	b7ed                	j	800058b6 <consolewrite+0x4a>

00000000800058ce <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058ce:	7119                	addi	sp,sp,-128
    800058d0:	fc86                	sd	ra,120(sp)
    800058d2:	f8a2                	sd	s0,112(sp)
    800058d4:	f4a6                	sd	s1,104(sp)
    800058d6:	f0ca                	sd	s2,96(sp)
    800058d8:	ecce                	sd	s3,88(sp)
    800058da:	e8d2                	sd	s4,80(sp)
    800058dc:	e4d6                	sd	s5,72(sp)
    800058de:	e0da                	sd	s6,64(sp)
    800058e0:	fc5e                	sd	s7,56(sp)
    800058e2:	f862                	sd	s8,48(sp)
    800058e4:	f466                	sd	s9,40(sp)
    800058e6:	f06a                	sd	s10,32(sp)
    800058e8:	ec6e                	sd	s11,24(sp)
    800058ea:	0100                	addi	s0,sp,128
    800058ec:	8b2a                	mv	s6,a0
    800058ee:	8aae                	mv	s5,a1
    800058f0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058f2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058f6:	00025517          	auipc	a0,0x25
    800058fa:	84a50513          	addi	a0,a0,-1974 # 8002a140 <cons>
    800058fe:	00001097          	auipc	ra,0x1
    80005902:	946080e7          	jalr	-1722(ra) # 80006244 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005906:	00025497          	auipc	s1,0x25
    8000590a:	83a48493          	addi	s1,s1,-1990 # 8002a140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000590e:	89a6                	mv	s3,s1
    80005910:	00025917          	auipc	s2,0x25
    80005914:	8c890913          	addi	s2,s2,-1848 # 8002a1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005918:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000591a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000591c:	4da9                	li	s11,10
  while(n > 0){
    8000591e:	07405963          	blez	s4,80005990 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005922:	0984a783          	lw	a5,152(s1)
    80005926:	09c4a703          	lw	a4,156(s1)
    8000592a:	02f71563          	bne	a4,a5,80005954 <consoleread+0x86>
      if(myproc()->killed){
    8000592e:	ffffb097          	auipc	ra,0xffffb
    80005932:	51c080e7          	jalr	1308(ra) # 80000e4a <myproc>
    80005936:	15852783          	lw	a5,344(a0)
    8000593a:	e7b5                	bnez	a5,800059a6 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    8000593c:	85ce                	mv	a1,s3
    8000593e:	854a                	mv	a0,s2
    80005940:	ffffc097          	auipc	ra,0xffffc
    80005944:	bf4080e7          	jalr	-1036(ra) # 80001534 <sleep>
    while(cons.r == cons.w){
    80005948:	0984a783          	lw	a5,152(s1)
    8000594c:	09c4a703          	lw	a4,156(s1)
    80005950:	fcf70fe3          	beq	a4,a5,8000592e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005954:	0017871b          	addiw	a4,a5,1
    80005958:	08e4ac23          	sw	a4,152(s1)
    8000595c:	07f7f713          	andi	a4,a5,127
    80005960:	9726                	add	a4,a4,s1
    80005962:	01874703          	lbu	a4,24(a4)
    80005966:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    8000596a:	079c0663          	beq	s8,s9,800059d6 <consoleread+0x108>
    cbuf = c;
    8000596e:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005972:	4685                	li	a3,1
    80005974:	f8f40613          	addi	a2,s0,-113
    80005978:	85d6                	mv	a1,s5
    8000597a:	855a                	mv	a0,s6
    8000597c:	ffffc097          	auipc	ra,0xffffc
    80005980:	f72080e7          	jalr	-142(ra) # 800018ee <either_copyout>
    80005984:	01a50663          	beq	a0,s10,80005990 <consoleread+0xc2>
    dst++;
    80005988:	0a85                	addi	s5,s5,1
    --n;
    8000598a:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000598c:	f9bc19e3          	bne	s8,s11,8000591e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005990:	00024517          	auipc	a0,0x24
    80005994:	7b050513          	addi	a0,a0,1968 # 8002a140 <cons>
    80005998:	00001097          	auipc	ra,0x1
    8000599c:	960080e7          	jalr	-1696(ra) # 800062f8 <release>

  return target - n;
    800059a0:	414b853b          	subw	a0,s7,s4
    800059a4:	a811                	j	800059b8 <consoleread+0xea>
        release(&cons.lock);
    800059a6:	00024517          	auipc	a0,0x24
    800059aa:	79a50513          	addi	a0,a0,1946 # 8002a140 <cons>
    800059ae:	00001097          	auipc	ra,0x1
    800059b2:	94a080e7          	jalr	-1718(ra) # 800062f8 <release>
        return -1;
    800059b6:	557d                	li	a0,-1
}
    800059b8:	70e6                	ld	ra,120(sp)
    800059ba:	7446                	ld	s0,112(sp)
    800059bc:	74a6                	ld	s1,104(sp)
    800059be:	7906                	ld	s2,96(sp)
    800059c0:	69e6                	ld	s3,88(sp)
    800059c2:	6a46                	ld	s4,80(sp)
    800059c4:	6aa6                	ld	s5,72(sp)
    800059c6:	6b06                	ld	s6,64(sp)
    800059c8:	7be2                	ld	s7,56(sp)
    800059ca:	7c42                	ld	s8,48(sp)
    800059cc:	7ca2                	ld	s9,40(sp)
    800059ce:	7d02                	ld	s10,32(sp)
    800059d0:	6de2                	ld	s11,24(sp)
    800059d2:	6109                	addi	sp,sp,128
    800059d4:	8082                	ret
      if(n < target){
    800059d6:	000a071b          	sext.w	a4,s4
    800059da:	fb777be3          	bgeu	a4,s7,80005990 <consoleread+0xc2>
        cons.r--;
    800059de:	00024717          	auipc	a4,0x24
    800059e2:	7ef72d23          	sw	a5,2042(a4) # 8002a1d8 <cons+0x98>
    800059e6:	b76d                	j	80005990 <consoleread+0xc2>

00000000800059e8 <consputc>:
{
    800059e8:	1141                	addi	sp,sp,-16
    800059ea:	e406                	sd	ra,8(sp)
    800059ec:	e022                	sd	s0,0(sp)
    800059ee:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059f0:	10000793          	li	a5,256
    800059f4:	00f50a63          	beq	a0,a5,80005a08 <consputc+0x20>
    uartputc_sync(c);
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	5b4080e7          	jalr	1460(ra) # 80005fac <uartputc_sync>
}
    80005a00:	60a2                	ld	ra,8(sp)
    80005a02:	6402                	ld	s0,0(sp)
    80005a04:	0141                	addi	sp,sp,16
    80005a06:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a08:	4521                	li	a0,8
    80005a0a:	00000097          	auipc	ra,0x0
    80005a0e:	5a2080e7          	jalr	1442(ra) # 80005fac <uartputc_sync>
    80005a12:	02000513          	li	a0,32
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	596080e7          	jalr	1430(ra) # 80005fac <uartputc_sync>
    80005a1e:	4521                	li	a0,8
    80005a20:	00000097          	auipc	ra,0x0
    80005a24:	58c080e7          	jalr	1420(ra) # 80005fac <uartputc_sync>
    80005a28:	bfe1                	j	80005a00 <consputc+0x18>

0000000080005a2a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a2a:	1101                	addi	sp,sp,-32
    80005a2c:	ec06                	sd	ra,24(sp)
    80005a2e:	e822                	sd	s0,16(sp)
    80005a30:	e426                	sd	s1,8(sp)
    80005a32:	e04a                	sd	s2,0(sp)
    80005a34:	1000                	addi	s0,sp,32
    80005a36:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a38:	00024517          	auipc	a0,0x24
    80005a3c:	70850513          	addi	a0,a0,1800 # 8002a140 <cons>
    80005a40:	00001097          	auipc	ra,0x1
    80005a44:	804080e7          	jalr	-2044(ra) # 80006244 <acquire>

  switch(c){
    80005a48:	47d5                	li	a5,21
    80005a4a:	0af48663          	beq	s1,a5,80005af6 <consoleintr+0xcc>
    80005a4e:	0297ca63          	blt	a5,s1,80005a82 <consoleintr+0x58>
    80005a52:	47a1                	li	a5,8
    80005a54:	0ef48763          	beq	s1,a5,80005b42 <consoleintr+0x118>
    80005a58:	47c1                	li	a5,16
    80005a5a:	10f49a63          	bne	s1,a5,80005b6e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a5e:	ffffc097          	auipc	ra,0xffffc
    80005a62:	f40080e7          	jalr	-192(ra) # 8000199e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a66:	00024517          	auipc	a0,0x24
    80005a6a:	6da50513          	addi	a0,a0,1754 # 8002a140 <cons>
    80005a6e:	00001097          	auipc	ra,0x1
    80005a72:	88a080e7          	jalr	-1910(ra) # 800062f8 <release>
}
    80005a76:	60e2                	ld	ra,24(sp)
    80005a78:	6442                	ld	s0,16(sp)
    80005a7a:	64a2                	ld	s1,8(sp)
    80005a7c:	6902                	ld	s2,0(sp)
    80005a7e:	6105                	addi	sp,sp,32
    80005a80:	8082                	ret
  switch(c){
    80005a82:	07f00793          	li	a5,127
    80005a86:	0af48e63          	beq	s1,a5,80005b42 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a8a:	00024717          	auipc	a4,0x24
    80005a8e:	6b670713          	addi	a4,a4,1718 # 8002a140 <cons>
    80005a92:	0a072783          	lw	a5,160(a4)
    80005a96:	09872703          	lw	a4,152(a4)
    80005a9a:	9f99                	subw	a5,a5,a4
    80005a9c:	07f00713          	li	a4,127
    80005aa0:	fcf763e3          	bltu	a4,a5,80005a66 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005aa4:	47b5                	li	a5,13
    80005aa6:	0cf48763          	beq	s1,a5,80005b74 <consoleintr+0x14a>
      consputc(c);
    80005aaa:	8526                	mv	a0,s1
    80005aac:	00000097          	auipc	ra,0x0
    80005ab0:	f3c080e7          	jalr	-196(ra) # 800059e8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ab4:	00024797          	auipc	a5,0x24
    80005ab8:	68c78793          	addi	a5,a5,1676 # 8002a140 <cons>
    80005abc:	0a07a703          	lw	a4,160(a5)
    80005ac0:	0017069b          	addiw	a3,a4,1
    80005ac4:	0006861b          	sext.w	a2,a3
    80005ac8:	0ad7a023          	sw	a3,160(a5)
    80005acc:	07f77713          	andi	a4,a4,127
    80005ad0:	97ba                	add	a5,a5,a4
    80005ad2:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ad6:	47a9                	li	a5,10
    80005ad8:	0cf48563          	beq	s1,a5,80005ba2 <consoleintr+0x178>
    80005adc:	4791                	li	a5,4
    80005ade:	0cf48263          	beq	s1,a5,80005ba2 <consoleintr+0x178>
    80005ae2:	00024797          	auipc	a5,0x24
    80005ae6:	6f67a783          	lw	a5,1782(a5) # 8002a1d8 <cons+0x98>
    80005aea:	0807879b          	addiw	a5,a5,128
    80005aee:	f6f61ce3          	bne	a2,a5,80005a66 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005af2:	863e                	mv	a2,a5
    80005af4:	a07d                	j	80005ba2 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005af6:	00024717          	auipc	a4,0x24
    80005afa:	64a70713          	addi	a4,a4,1610 # 8002a140 <cons>
    80005afe:	0a072783          	lw	a5,160(a4)
    80005b02:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b06:	00024497          	auipc	s1,0x24
    80005b0a:	63a48493          	addi	s1,s1,1594 # 8002a140 <cons>
    while(cons.e != cons.w &&
    80005b0e:	4929                	li	s2,10
    80005b10:	f4f70be3          	beq	a4,a5,80005a66 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b14:	37fd                	addiw	a5,a5,-1
    80005b16:	07f7f713          	andi	a4,a5,127
    80005b1a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b1c:	01874703          	lbu	a4,24(a4)
    80005b20:	f52703e3          	beq	a4,s2,80005a66 <consoleintr+0x3c>
      cons.e--;
    80005b24:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b28:	10000513          	li	a0,256
    80005b2c:	00000097          	auipc	ra,0x0
    80005b30:	ebc080e7          	jalr	-324(ra) # 800059e8 <consputc>
    while(cons.e != cons.w &&
    80005b34:	0a04a783          	lw	a5,160(s1)
    80005b38:	09c4a703          	lw	a4,156(s1)
    80005b3c:	fcf71ce3          	bne	a4,a5,80005b14 <consoleintr+0xea>
    80005b40:	b71d                	j	80005a66 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b42:	00024717          	auipc	a4,0x24
    80005b46:	5fe70713          	addi	a4,a4,1534 # 8002a140 <cons>
    80005b4a:	0a072783          	lw	a5,160(a4)
    80005b4e:	09c72703          	lw	a4,156(a4)
    80005b52:	f0f70ae3          	beq	a4,a5,80005a66 <consoleintr+0x3c>
      cons.e--;
    80005b56:	37fd                	addiw	a5,a5,-1
    80005b58:	00024717          	auipc	a4,0x24
    80005b5c:	68f72423          	sw	a5,1672(a4) # 8002a1e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b60:	10000513          	li	a0,256
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	e84080e7          	jalr	-380(ra) # 800059e8 <consputc>
    80005b6c:	bded                	j	80005a66 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b6e:	ee048ce3          	beqz	s1,80005a66 <consoleintr+0x3c>
    80005b72:	bf21                	j	80005a8a <consoleintr+0x60>
      consputc(c);
    80005b74:	4529                	li	a0,10
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	e72080e7          	jalr	-398(ra) # 800059e8 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b7e:	00024797          	auipc	a5,0x24
    80005b82:	5c278793          	addi	a5,a5,1474 # 8002a140 <cons>
    80005b86:	0a07a703          	lw	a4,160(a5)
    80005b8a:	0017069b          	addiw	a3,a4,1
    80005b8e:	0006861b          	sext.w	a2,a3
    80005b92:	0ad7a023          	sw	a3,160(a5)
    80005b96:	07f77713          	andi	a4,a4,127
    80005b9a:	97ba                	add	a5,a5,a4
    80005b9c:	4729                	li	a4,10
    80005b9e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ba2:	00024797          	auipc	a5,0x24
    80005ba6:	62c7ad23          	sw	a2,1594(a5) # 8002a1dc <cons+0x9c>
        wakeup(&cons.r);
    80005baa:	00024517          	auipc	a0,0x24
    80005bae:	62e50513          	addi	a0,a0,1582 # 8002a1d8 <cons+0x98>
    80005bb2:	ffffc097          	auipc	ra,0xffffc
    80005bb6:	b14080e7          	jalr	-1260(ra) # 800016c6 <wakeup>
    80005bba:	b575                	j	80005a66 <consoleintr+0x3c>

0000000080005bbc <consoleinit>:

void
consoleinit(void)
{
    80005bbc:	1141                	addi	sp,sp,-16
    80005bbe:	e406                	sd	ra,8(sp)
    80005bc0:	e022                	sd	s0,0(sp)
    80005bc2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bc4:	00003597          	auipc	a1,0x3
    80005bc8:	bdc58593          	addi	a1,a1,-1060 # 800087a0 <syscalls+0x3d8>
    80005bcc:	00024517          	auipc	a0,0x24
    80005bd0:	57450513          	addi	a0,a0,1396 # 8002a140 <cons>
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	5e0080e7          	jalr	1504(ra) # 800061b4 <initlock>

  uartinit();
    80005bdc:	00000097          	auipc	ra,0x0
    80005be0:	380080e7          	jalr	896(ra) # 80005f5c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005be4:	00018797          	auipc	a5,0x18
    80005be8:	0e478793          	addi	a5,a5,228 # 8001dcc8 <devsw>
    80005bec:	00000717          	auipc	a4,0x0
    80005bf0:	ce270713          	addi	a4,a4,-798 # 800058ce <consoleread>
    80005bf4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bf6:	00000717          	auipc	a4,0x0
    80005bfa:	c7670713          	addi	a4,a4,-906 # 8000586c <consolewrite>
    80005bfe:	ef98                	sd	a4,24(a5)
}
    80005c00:	60a2                	ld	ra,8(sp)
    80005c02:	6402                	ld	s0,0(sp)
    80005c04:	0141                	addi	sp,sp,16
    80005c06:	8082                	ret

0000000080005c08 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c08:	7179                	addi	sp,sp,-48
    80005c0a:	f406                	sd	ra,40(sp)
    80005c0c:	f022                	sd	s0,32(sp)
    80005c0e:	ec26                	sd	s1,24(sp)
    80005c10:	e84a                	sd	s2,16(sp)
    80005c12:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c14:	c219                	beqz	a2,80005c1a <printint+0x12>
    80005c16:	08054663          	bltz	a0,80005ca2 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c1a:	2501                	sext.w	a0,a0
    80005c1c:	4881                	li	a7,0
    80005c1e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c22:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c24:	2581                	sext.w	a1,a1
    80005c26:	00003617          	auipc	a2,0x3
    80005c2a:	bc260613          	addi	a2,a2,-1086 # 800087e8 <digits>
    80005c2e:	883a                	mv	a6,a4
    80005c30:	2705                	addiw	a4,a4,1
    80005c32:	02b577bb          	remuw	a5,a0,a1
    80005c36:	1782                	slli	a5,a5,0x20
    80005c38:	9381                	srli	a5,a5,0x20
    80005c3a:	97b2                	add	a5,a5,a2
    80005c3c:	0007c783          	lbu	a5,0(a5)
    80005c40:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c44:	0005079b          	sext.w	a5,a0
    80005c48:	02b5553b          	divuw	a0,a0,a1
    80005c4c:	0685                	addi	a3,a3,1
    80005c4e:	feb7f0e3          	bgeu	a5,a1,80005c2e <printint+0x26>

  if(sign)
    80005c52:	00088b63          	beqz	a7,80005c68 <printint+0x60>
    buf[i++] = '-';
    80005c56:	fe040793          	addi	a5,s0,-32
    80005c5a:	973e                	add	a4,a4,a5
    80005c5c:	02d00793          	li	a5,45
    80005c60:	fef70823          	sb	a5,-16(a4)
    80005c64:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c68:	02e05763          	blez	a4,80005c96 <printint+0x8e>
    80005c6c:	fd040793          	addi	a5,s0,-48
    80005c70:	00e784b3          	add	s1,a5,a4
    80005c74:	fff78913          	addi	s2,a5,-1
    80005c78:	993a                	add	s2,s2,a4
    80005c7a:	377d                	addiw	a4,a4,-1
    80005c7c:	1702                	slli	a4,a4,0x20
    80005c7e:	9301                	srli	a4,a4,0x20
    80005c80:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c84:	fff4c503          	lbu	a0,-1(s1)
    80005c88:	00000097          	auipc	ra,0x0
    80005c8c:	d60080e7          	jalr	-672(ra) # 800059e8 <consputc>
  while(--i >= 0)
    80005c90:	14fd                	addi	s1,s1,-1
    80005c92:	ff2499e3          	bne	s1,s2,80005c84 <printint+0x7c>
}
    80005c96:	70a2                	ld	ra,40(sp)
    80005c98:	7402                	ld	s0,32(sp)
    80005c9a:	64e2                	ld	s1,24(sp)
    80005c9c:	6942                	ld	s2,16(sp)
    80005c9e:	6145                	addi	sp,sp,48
    80005ca0:	8082                	ret
    x = -xx;
    80005ca2:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ca6:	4885                	li	a7,1
    x = -xx;
    80005ca8:	bf9d                	j	80005c1e <printint+0x16>

0000000080005caa <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005caa:	1101                	addi	sp,sp,-32
    80005cac:	ec06                	sd	ra,24(sp)
    80005cae:	e822                	sd	s0,16(sp)
    80005cb0:	e426                	sd	s1,8(sp)
    80005cb2:	1000                	addi	s0,sp,32
    80005cb4:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cb6:	00024797          	auipc	a5,0x24
    80005cba:	5407a523          	sw	zero,1354(a5) # 8002a200 <pr+0x18>
  printf("panic: ");
    80005cbe:	00003517          	auipc	a0,0x3
    80005cc2:	aea50513          	addi	a0,a0,-1302 # 800087a8 <syscalls+0x3e0>
    80005cc6:	00000097          	auipc	ra,0x0
    80005cca:	02e080e7          	jalr	46(ra) # 80005cf4 <printf>
  printf(s);
    80005cce:	8526                	mv	a0,s1
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	024080e7          	jalr	36(ra) # 80005cf4 <printf>
  printf("\n");
    80005cd8:	00002517          	auipc	a0,0x2
    80005cdc:	37050513          	addi	a0,a0,880 # 80008048 <etext+0x48>
    80005ce0:	00000097          	auipc	ra,0x0
    80005ce4:	014080e7          	jalr	20(ra) # 80005cf4 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ce8:	4785                	li	a5,1
    80005cea:	00003717          	auipc	a4,0x3
    80005cee:	32f72923          	sw	a5,818(a4) # 8000901c <panicked>
  for(;;)
    80005cf2:	a001                	j	80005cf2 <panic+0x48>

0000000080005cf4 <printf>:
{
    80005cf4:	7131                	addi	sp,sp,-192
    80005cf6:	fc86                	sd	ra,120(sp)
    80005cf8:	f8a2                	sd	s0,112(sp)
    80005cfa:	f4a6                	sd	s1,104(sp)
    80005cfc:	f0ca                	sd	s2,96(sp)
    80005cfe:	ecce                	sd	s3,88(sp)
    80005d00:	e8d2                	sd	s4,80(sp)
    80005d02:	e4d6                	sd	s5,72(sp)
    80005d04:	e0da                	sd	s6,64(sp)
    80005d06:	fc5e                	sd	s7,56(sp)
    80005d08:	f862                	sd	s8,48(sp)
    80005d0a:	f466                	sd	s9,40(sp)
    80005d0c:	f06a                	sd	s10,32(sp)
    80005d0e:	ec6e                	sd	s11,24(sp)
    80005d10:	0100                	addi	s0,sp,128
    80005d12:	8a2a                	mv	s4,a0
    80005d14:	e40c                	sd	a1,8(s0)
    80005d16:	e810                	sd	a2,16(s0)
    80005d18:	ec14                	sd	a3,24(s0)
    80005d1a:	f018                	sd	a4,32(s0)
    80005d1c:	f41c                	sd	a5,40(s0)
    80005d1e:	03043823          	sd	a6,48(s0)
    80005d22:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d26:	00024d97          	auipc	s11,0x24
    80005d2a:	4dadad83          	lw	s11,1242(s11) # 8002a200 <pr+0x18>
  if(locking)
    80005d2e:	020d9b63          	bnez	s11,80005d64 <printf+0x70>
  if (fmt == 0)
    80005d32:	040a0263          	beqz	s4,80005d76 <printf+0x82>
  va_start(ap, fmt);
    80005d36:	00840793          	addi	a5,s0,8
    80005d3a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3e:	000a4503          	lbu	a0,0(s4)
    80005d42:	16050263          	beqz	a0,80005ea6 <printf+0x1b2>
    80005d46:	4481                	li	s1,0
    if(c != '%'){
    80005d48:	02500a93          	li	s5,37
    switch(c){
    80005d4c:	07000b13          	li	s6,112
  consputc('x');
    80005d50:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d52:	00003b97          	auipc	s7,0x3
    80005d56:	a96b8b93          	addi	s7,s7,-1386 # 800087e8 <digits>
    switch(c){
    80005d5a:	07300c93          	li	s9,115
    80005d5e:	06400c13          	li	s8,100
    80005d62:	a82d                	j	80005d9c <printf+0xa8>
    acquire(&pr.lock);
    80005d64:	00024517          	auipc	a0,0x24
    80005d68:	48450513          	addi	a0,a0,1156 # 8002a1e8 <pr>
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	4d8080e7          	jalr	1240(ra) # 80006244 <acquire>
    80005d74:	bf7d                	j	80005d32 <printf+0x3e>
    panic("null fmt");
    80005d76:	00003517          	auipc	a0,0x3
    80005d7a:	a4250513          	addi	a0,a0,-1470 # 800087b8 <syscalls+0x3f0>
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	f2c080e7          	jalr	-212(ra) # 80005caa <panic>
      consputc(c);
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	c62080e7          	jalr	-926(ra) # 800059e8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d8e:	2485                	addiw	s1,s1,1
    80005d90:	009a07b3          	add	a5,s4,s1
    80005d94:	0007c503          	lbu	a0,0(a5)
    80005d98:	10050763          	beqz	a0,80005ea6 <printf+0x1b2>
    if(c != '%'){
    80005d9c:	ff5515e3          	bne	a0,s5,80005d86 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005da0:	2485                	addiw	s1,s1,1
    80005da2:	009a07b3          	add	a5,s4,s1
    80005da6:	0007c783          	lbu	a5,0(a5)
    80005daa:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dae:	cfe5                	beqz	a5,80005ea6 <printf+0x1b2>
    switch(c){
    80005db0:	05678a63          	beq	a5,s6,80005e04 <printf+0x110>
    80005db4:	02fb7663          	bgeu	s6,a5,80005de0 <printf+0xec>
    80005db8:	09978963          	beq	a5,s9,80005e4a <printf+0x156>
    80005dbc:	07800713          	li	a4,120
    80005dc0:	0ce79863          	bne	a5,a4,80005e90 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005dc4:	f8843783          	ld	a5,-120(s0)
    80005dc8:	00878713          	addi	a4,a5,8
    80005dcc:	f8e43423          	sd	a4,-120(s0)
    80005dd0:	4605                	li	a2,1
    80005dd2:	85ea                	mv	a1,s10
    80005dd4:	4388                	lw	a0,0(a5)
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	e32080e7          	jalr	-462(ra) # 80005c08 <printint>
      break;
    80005dde:	bf45                	j	80005d8e <printf+0x9a>
    switch(c){
    80005de0:	0b578263          	beq	a5,s5,80005e84 <printf+0x190>
    80005de4:	0b879663          	bne	a5,s8,80005e90 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005de8:	f8843783          	ld	a5,-120(s0)
    80005dec:	00878713          	addi	a4,a5,8
    80005df0:	f8e43423          	sd	a4,-120(s0)
    80005df4:	4605                	li	a2,1
    80005df6:	45a9                	li	a1,10
    80005df8:	4388                	lw	a0,0(a5)
    80005dfa:	00000097          	auipc	ra,0x0
    80005dfe:	e0e080e7          	jalr	-498(ra) # 80005c08 <printint>
      break;
    80005e02:	b771                	j	80005d8e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e04:	f8843783          	ld	a5,-120(s0)
    80005e08:	00878713          	addi	a4,a5,8
    80005e0c:	f8e43423          	sd	a4,-120(s0)
    80005e10:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e14:	03000513          	li	a0,48
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	bd0080e7          	jalr	-1072(ra) # 800059e8 <consputc>
  consputc('x');
    80005e20:	07800513          	li	a0,120
    80005e24:	00000097          	auipc	ra,0x0
    80005e28:	bc4080e7          	jalr	-1084(ra) # 800059e8 <consputc>
    80005e2c:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e2e:	03c9d793          	srli	a5,s3,0x3c
    80005e32:	97de                	add	a5,a5,s7
    80005e34:	0007c503          	lbu	a0,0(a5)
    80005e38:	00000097          	auipc	ra,0x0
    80005e3c:	bb0080e7          	jalr	-1104(ra) # 800059e8 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e40:	0992                	slli	s3,s3,0x4
    80005e42:	397d                	addiw	s2,s2,-1
    80005e44:	fe0915e3          	bnez	s2,80005e2e <printf+0x13a>
    80005e48:	b799                	j	80005d8e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e4a:	f8843783          	ld	a5,-120(s0)
    80005e4e:	00878713          	addi	a4,a5,8
    80005e52:	f8e43423          	sd	a4,-120(s0)
    80005e56:	0007b903          	ld	s2,0(a5)
    80005e5a:	00090e63          	beqz	s2,80005e76 <printf+0x182>
      for(; *s; s++)
    80005e5e:	00094503          	lbu	a0,0(s2)
    80005e62:	d515                	beqz	a0,80005d8e <printf+0x9a>
        consputc(*s);
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	b84080e7          	jalr	-1148(ra) # 800059e8 <consputc>
      for(; *s; s++)
    80005e6c:	0905                	addi	s2,s2,1
    80005e6e:	00094503          	lbu	a0,0(s2)
    80005e72:	f96d                	bnez	a0,80005e64 <printf+0x170>
    80005e74:	bf29                	j	80005d8e <printf+0x9a>
        s = "(null)";
    80005e76:	00003917          	auipc	s2,0x3
    80005e7a:	93a90913          	addi	s2,s2,-1734 # 800087b0 <syscalls+0x3e8>
      for(; *s; s++)
    80005e7e:	02800513          	li	a0,40
    80005e82:	b7cd                	j	80005e64 <printf+0x170>
      consputc('%');
    80005e84:	8556                	mv	a0,s5
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	b62080e7          	jalr	-1182(ra) # 800059e8 <consputc>
      break;
    80005e8e:	b701                	j	80005d8e <printf+0x9a>
      consputc('%');
    80005e90:	8556                	mv	a0,s5
    80005e92:	00000097          	auipc	ra,0x0
    80005e96:	b56080e7          	jalr	-1194(ra) # 800059e8 <consputc>
      consputc(c);
    80005e9a:	854a                	mv	a0,s2
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	b4c080e7          	jalr	-1204(ra) # 800059e8 <consputc>
      break;
    80005ea4:	b5ed                	j	80005d8e <printf+0x9a>
  if(locking)
    80005ea6:	020d9163          	bnez	s11,80005ec8 <printf+0x1d4>
}
    80005eaa:	70e6                	ld	ra,120(sp)
    80005eac:	7446                	ld	s0,112(sp)
    80005eae:	74a6                	ld	s1,104(sp)
    80005eb0:	7906                	ld	s2,96(sp)
    80005eb2:	69e6                	ld	s3,88(sp)
    80005eb4:	6a46                	ld	s4,80(sp)
    80005eb6:	6aa6                	ld	s5,72(sp)
    80005eb8:	6b06                	ld	s6,64(sp)
    80005eba:	7be2                	ld	s7,56(sp)
    80005ebc:	7c42                	ld	s8,48(sp)
    80005ebe:	7ca2                	ld	s9,40(sp)
    80005ec0:	7d02                	ld	s10,32(sp)
    80005ec2:	6de2                	ld	s11,24(sp)
    80005ec4:	6129                	addi	sp,sp,192
    80005ec6:	8082                	ret
    release(&pr.lock);
    80005ec8:	00024517          	auipc	a0,0x24
    80005ecc:	32050513          	addi	a0,a0,800 # 8002a1e8 <pr>
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	428080e7          	jalr	1064(ra) # 800062f8 <release>
}
    80005ed8:	bfc9                	j	80005eaa <printf+0x1b6>

0000000080005eda <printfinit>:
    ;
}

void
printfinit(void)
{
    80005eda:	1101                	addi	sp,sp,-32
    80005edc:	ec06                	sd	ra,24(sp)
    80005ede:	e822                	sd	s0,16(sp)
    80005ee0:	e426                	sd	s1,8(sp)
    80005ee2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ee4:	00024497          	auipc	s1,0x24
    80005ee8:	30448493          	addi	s1,s1,772 # 8002a1e8 <pr>
    80005eec:	00003597          	auipc	a1,0x3
    80005ef0:	8dc58593          	addi	a1,a1,-1828 # 800087c8 <syscalls+0x400>
    80005ef4:	8526                	mv	a0,s1
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	2be080e7          	jalr	702(ra) # 800061b4 <initlock>
  pr.locking = 1;
    80005efe:	4785                	li	a5,1
    80005f00:	cc9c                	sw	a5,24(s1)
}
    80005f02:	60e2                	ld	ra,24(sp)
    80005f04:	6442                	ld	s0,16(sp)
    80005f06:	64a2                	ld	s1,8(sp)
    80005f08:	6105                	addi	sp,sp,32
    80005f0a:	8082                	ret

0000000080005f0c <backtrace>:

void
backtrace(void)
{
    80005f0c:	1101                	addi	sp,sp,-32
    80005f0e:	ec06                	sd	ra,24(sp)
    80005f10:	e822                	sd	s0,16(sp)
    80005f12:	e426                	sd	s1,8(sp)
    80005f14:	e04a                	sd	s2,0(sp)
    80005f16:	1000                	addi	s0,sp,32
  printf("backtrace:\n");
    80005f18:	00003517          	auipc	a0,0x3
    80005f1c:	8b850513          	addi	a0,a0,-1864 # 800087d0 <syscalls+0x408>
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	dd4080e7          	jalr	-556(ra) # 80005cf4 <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    80005f28:	84a2                	mv	s1,s0
  uint64 fp_address = r_fp();
  while(fp_address != PGROUNDDOWN(fp_address)) {
    80005f2a:	03449793          	slli	a5,s1,0x34
    80005f2e:	c38d                	beqz	a5,80005f50 <backtrace+0x44>
    printf("%p\n", *(uint64*)(fp_address-8));
    80005f30:	00003917          	auipc	s2,0x3
    80005f34:	8b090913          	addi	s2,s2,-1872 # 800087e0 <syscalls+0x418>
    80005f38:	ff84b583          	ld	a1,-8(s1)
    80005f3c:	854a                	mv	a0,s2
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	db6080e7          	jalr	-586(ra) # 80005cf4 <printf>
    fp_address = *(uint64*)(fp_address - 16);
    80005f46:	ff04b483          	ld	s1,-16(s1)
  while(fp_address != PGROUNDDOWN(fp_address)) {
    80005f4a:	03449793          	slli	a5,s1,0x34
    80005f4e:	f7ed                	bnez	a5,80005f38 <backtrace+0x2c>
  }
}
    80005f50:	60e2                	ld	ra,24(sp)
    80005f52:	6442                	ld	s0,16(sp)
    80005f54:	64a2                	ld	s1,8(sp)
    80005f56:	6902                	ld	s2,0(sp)
    80005f58:	6105                	addi	sp,sp,32
    80005f5a:	8082                	ret

0000000080005f5c <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f5c:	1141                	addi	sp,sp,-16
    80005f5e:	e406                	sd	ra,8(sp)
    80005f60:	e022                	sd	s0,0(sp)
    80005f62:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f64:	100007b7          	lui	a5,0x10000
    80005f68:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f6c:	f8000713          	li	a4,-128
    80005f70:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f74:	470d                	li	a4,3
    80005f76:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f7a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f7e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f82:	469d                	li	a3,7
    80005f84:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f88:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f8c:	00003597          	auipc	a1,0x3
    80005f90:	87458593          	addi	a1,a1,-1932 # 80008800 <digits+0x18>
    80005f94:	00024517          	auipc	a0,0x24
    80005f98:	27450513          	addi	a0,a0,628 # 8002a208 <uart_tx_lock>
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	218080e7          	jalr	536(ra) # 800061b4 <initlock>
}
    80005fa4:	60a2                	ld	ra,8(sp)
    80005fa6:	6402                	ld	s0,0(sp)
    80005fa8:	0141                	addi	sp,sp,16
    80005faa:	8082                	ret

0000000080005fac <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fac:	1101                	addi	sp,sp,-32
    80005fae:	ec06                	sd	ra,24(sp)
    80005fb0:	e822                	sd	s0,16(sp)
    80005fb2:	e426                	sd	s1,8(sp)
    80005fb4:	1000                	addi	s0,sp,32
    80005fb6:	84aa                	mv	s1,a0
  push_off();
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	240080e7          	jalr	576(ra) # 800061f8 <push_off>

  if(panicked){
    80005fc0:	00003797          	auipc	a5,0x3
    80005fc4:	05c7a783          	lw	a5,92(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fc8:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fcc:	c391                	beqz	a5,80005fd0 <uartputc_sync+0x24>
    for(;;)
    80005fce:	a001                	j	80005fce <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fd0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fd4:	0ff7f793          	andi	a5,a5,255
    80005fd8:	0207f793          	andi	a5,a5,32
    80005fdc:	dbf5                	beqz	a5,80005fd0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fde:	0ff4f793          	andi	a5,s1,255
    80005fe2:	10000737          	lui	a4,0x10000
    80005fe6:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fea:	00000097          	auipc	ra,0x0
    80005fee:	2ae080e7          	jalr	686(ra) # 80006298 <pop_off>
}
    80005ff2:	60e2                	ld	ra,24(sp)
    80005ff4:	6442                	ld	s0,16(sp)
    80005ff6:	64a2                	ld	s1,8(sp)
    80005ff8:	6105                	addi	sp,sp,32
    80005ffa:	8082                	ret

0000000080005ffc <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ffc:	00003717          	auipc	a4,0x3
    80006000:	02473703          	ld	a4,36(a4) # 80009020 <uart_tx_r>
    80006004:	00003797          	auipc	a5,0x3
    80006008:	0247b783          	ld	a5,36(a5) # 80009028 <uart_tx_w>
    8000600c:	06e78c63          	beq	a5,a4,80006084 <uartstart+0x88>
{
    80006010:	7139                	addi	sp,sp,-64
    80006012:	fc06                	sd	ra,56(sp)
    80006014:	f822                	sd	s0,48(sp)
    80006016:	f426                	sd	s1,40(sp)
    80006018:	f04a                	sd	s2,32(sp)
    8000601a:	ec4e                	sd	s3,24(sp)
    8000601c:	e852                	sd	s4,16(sp)
    8000601e:	e456                	sd	s5,8(sp)
    80006020:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006022:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006026:	00024a17          	auipc	s4,0x24
    8000602a:	1e2a0a13          	addi	s4,s4,482 # 8002a208 <uart_tx_lock>
    uart_tx_r += 1;
    8000602e:	00003497          	auipc	s1,0x3
    80006032:	ff248493          	addi	s1,s1,-14 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006036:	00003997          	auipc	s3,0x3
    8000603a:	ff298993          	addi	s3,s3,-14 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000603e:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006042:	0ff7f793          	andi	a5,a5,255
    80006046:	0207f793          	andi	a5,a5,32
    8000604a:	c785                	beqz	a5,80006072 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000604c:	01f77793          	andi	a5,a4,31
    80006050:	97d2                	add	a5,a5,s4
    80006052:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006056:	0705                	addi	a4,a4,1
    80006058:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000605a:	8526                	mv	a0,s1
    8000605c:	ffffb097          	auipc	ra,0xffffb
    80006060:	66a080e7          	jalr	1642(ra) # 800016c6 <wakeup>
    
    WriteReg(THR, c);
    80006064:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006068:	6098                	ld	a4,0(s1)
    8000606a:	0009b783          	ld	a5,0(s3)
    8000606e:	fce798e3          	bne	a5,a4,8000603e <uartstart+0x42>
  }
}
    80006072:	70e2                	ld	ra,56(sp)
    80006074:	7442                	ld	s0,48(sp)
    80006076:	74a2                	ld	s1,40(sp)
    80006078:	7902                	ld	s2,32(sp)
    8000607a:	69e2                	ld	s3,24(sp)
    8000607c:	6a42                	ld	s4,16(sp)
    8000607e:	6aa2                	ld	s5,8(sp)
    80006080:	6121                	addi	sp,sp,64
    80006082:	8082                	ret
    80006084:	8082                	ret

0000000080006086 <uartputc>:
{
    80006086:	7179                	addi	sp,sp,-48
    80006088:	f406                	sd	ra,40(sp)
    8000608a:	f022                	sd	s0,32(sp)
    8000608c:	ec26                	sd	s1,24(sp)
    8000608e:	e84a                	sd	s2,16(sp)
    80006090:	e44e                	sd	s3,8(sp)
    80006092:	e052                	sd	s4,0(sp)
    80006094:	1800                	addi	s0,sp,48
    80006096:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006098:	00024517          	auipc	a0,0x24
    8000609c:	17050513          	addi	a0,a0,368 # 8002a208 <uart_tx_lock>
    800060a0:	00000097          	auipc	ra,0x0
    800060a4:	1a4080e7          	jalr	420(ra) # 80006244 <acquire>
  if(panicked){
    800060a8:	00003797          	auipc	a5,0x3
    800060ac:	f747a783          	lw	a5,-140(a5) # 8000901c <panicked>
    800060b0:	c391                	beqz	a5,800060b4 <uartputc+0x2e>
    for(;;)
    800060b2:	a001                	j	800060b2 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060b4:	00003797          	auipc	a5,0x3
    800060b8:	f747b783          	ld	a5,-140(a5) # 80009028 <uart_tx_w>
    800060bc:	00003717          	auipc	a4,0x3
    800060c0:	f6473703          	ld	a4,-156(a4) # 80009020 <uart_tx_r>
    800060c4:	02070713          	addi	a4,a4,32
    800060c8:	02f71b63          	bne	a4,a5,800060fe <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060cc:	00024a17          	auipc	s4,0x24
    800060d0:	13ca0a13          	addi	s4,s4,316 # 8002a208 <uart_tx_lock>
    800060d4:	00003497          	auipc	s1,0x3
    800060d8:	f4c48493          	addi	s1,s1,-180 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060dc:	00003917          	auipc	s2,0x3
    800060e0:	f4c90913          	addi	s2,s2,-180 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060e4:	85d2                	mv	a1,s4
    800060e6:	8526                	mv	a0,s1
    800060e8:	ffffb097          	auipc	ra,0xffffb
    800060ec:	44c080e7          	jalr	1100(ra) # 80001534 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060f0:	00093783          	ld	a5,0(s2)
    800060f4:	6098                	ld	a4,0(s1)
    800060f6:	02070713          	addi	a4,a4,32
    800060fa:	fef705e3          	beq	a4,a5,800060e4 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060fe:	00024497          	auipc	s1,0x24
    80006102:	10a48493          	addi	s1,s1,266 # 8002a208 <uart_tx_lock>
    80006106:	01f7f713          	andi	a4,a5,31
    8000610a:	9726                	add	a4,a4,s1
    8000610c:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80006110:	0785                	addi	a5,a5,1
    80006112:	00003717          	auipc	a4,0x3
    80006116:	f0f73b23          	sd	a5,-234(a4) # 80009028 <uart_tx_w>
      uartstart();
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	ee2080e7          	jalr	-286(ra) # 80005ffc <uartstart>
      release(&uart_tx_lock);
    80006122:	8526                	mv	a0,s1
    80006124:	00000097          	auipc	ra,0x0
    80006128:	1d4080e7          	jalr	468(ra) # 800062f8 <release>
}
    8000612c:	70a2                	ld	ra,40(sp)
    8000612e:	7402                	ld	s0,32(sp)
    80006130:	64e2                	ld	s1,24(sp)
    80006132:	6942                	ld	s2,16(sp)
    80006134:	69a2                	ld	s3,8(sp)
    80006136:	6a02                	ld	s4,0(sp)
    80006138:	6145                	addi	sp,sp,48
    8000613a:	8082                	ret

000000008000613c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000613c:	1141                	addi	sp,sp,-16
    8000613e:	e422                	sd	s0,8(sp)
    80006140:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006142:	100007b7          	lui	a5,0x10000
    80006146:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000614a:	8b85                	andi	a5,a5,1
    8000614c:	cb91                	beqz	a5,80006160 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000614e:	100007b7          	lui	a5,0x10000
    80006152:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006156:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000615a:	6422                	ld	s0,8(sp)
    8000615c:	0141                	addi	sp,sp,16
    8000615e:	8082                	ret
    return -1;
    80006160:	557d                	li	a0,-1
    80006162:	bfe5                	j	8000615a <uartgetc+0x1e>

0000000080006164 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006164:	1101                	addi	sp,sp,-32
    80006166:	ec06                	sd	ra,24(sp)
    80006168:	e822                	sd	s0,16(sp)
    8000616a:	e426                	sd	s1,8(sp)
    8000616c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000616e:	54fd                	li	s1,-1
    int c = uartgetc();
    80006170:	00000097          	auipc	ra,0x0
    80006174:	fcc080e7          	jalr	-52(ra) # 8000613c <uartgetc>
    if(c == -1)
    80006178:	00950763          	beq	a0,s1,80006186 <uartintr+0x22>
      break;
    consoleintr(c);
    8000617c:	00000097          	auipc	ra,0x0
    80006180:	8ae080e7          	jalr	-1874(ra) # 80005a2a <consoleintr>
  while(1){
    80006184:	b7f5                	j	80006170 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006186:	00024497          	auipc	s1,0x24
    8000618a:	08248493          	addi	s1,s1,130 # 8002a208 <uart_tx_lock>
    8000618e:	8526                	mv	a0,s1
    80006190:	00000097          	auipc	ra,0x0
    80006194:	0b4080e7          	jalr	180(ra) # 80006244 <acquire>
  uartstart();
    80006198:	00000097          	auipc	ra,0x0
    8000619c:	e64080e7          	jalr	-412(ra) # 80005ffc <uartstart>
  release(&uart_tx_lock);
    800061a0:	8526                	mv	a0,s1
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	156080e7          	jalr	342(ra) # 800062f8 <release>
}
    800061aa:	60e2                	ld	ra,24(sp)
    800061ac:	6442                	ld	s0,16(sp)
    800061ae:	64a2                	ld	s1,8(sp)
    800061b0:	6105                	addi	sp,sp,32
    800061b2:	8082                	ret

00000000800061b4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061b4:	1141                	addi	sp,sp,-16
    800061b6:	e422                	sd	s0,8(sp)
    800061b8:	0800                	addi	s0,sp,16
  lk->name = name;
    800061ba:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061bc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061c0:	00053823          	sd	zero,16(a0)
}
    800061c4:	6422                	ld	s0,8(sp)
    800061c6:	0141                	addi	sp,sp,16
    800061c8:	8082                	ret

00000000800061ca <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061ca:	411c                	lw	a5,0(a0)
    800061cc:	e399                	bnez	a5,800061d2 <holding+0x8>
    800061ce:	4501                	li	a0,0
  return r;
}
    800061d0:	8082                	ret
{
    800061d2:	1101                	addi	sp,sp,-32
    800061d4:	ec06                	sd	ra,24(sp)
    800061d6:	e822                	sd	s0,16(sp)
    800061d8:	e426                	sd	s1,8(sp)
    800061da:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061dc:	6904                	ld	s1,16(a0)
    800061de:	ffffb097          	auipc	ra,0xffffb
    800061e2:	c50080e7          	jalr	-944(ra) # 80000e2e <mycpu>
    800061e6:	40a48533          	sub	a0,s1,a0
    800061ea:	00153513          	seqz	a0,a0
}
    800061ee:	60e2                	ld	ra,24(sp)
    800061f0:	6442                	ld	s0,16(sp)
    800061f2:	64a2                	ld	s1,8(sp)
    800061f4:	6105                	addi	sp,sp,32
    800061f6:	8082                	ret

00000000800061f8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061f8:	1101                	addi	sp,sp,-32
    800061fa:	ec06                	sd	ra,24(sp)
    800061fc:	e822                	sd	s0,16(sp)
    800061fe:	e426                	sd	s1,8(sp)
    80006200:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006202:	100024f3          	csrr	s1,sstatus
    80006206:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000620a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000620c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006210:	ffffb097          	auipc	ra,0xffffb
    80006214:	c1e080e7          	jalr	-994(ra) # 80000e2e <mycpu>
    80006218:	5d3c                	lw	a5,120(a0)
    8000621a:	cf89                	beqz	a5,80006234 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000621c:	ffffb097          	auipc	ra,0xffffb
    80006220:	c12080e7          	jalr	-1006(ra) # 80000e2e <mycpu>
    80006224:	5d3c                	lw	a5,120(a0)
    80006226:	2785                	addiw	a5,a5,1
    80006228:	dd3c                	sw	a5,120(a0)
}
    8000622a:	60e2                	ld	ra,24(sp)
    8000622c:	6442                	ld	s0,16(sp)
    8000622e:	64a2                	ld	s1,8(sp)
    80006230:	6105                	addi	sp,sp,32
    80006232:	8082                	ret
    mycpu()->intena = old;
    80006234:	ffffb097          	auipc	ra,0xffffb
    80006238:	bfa080e7          	jalr	-1030(ra) # 80000e2e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000623c:	8085                	srli	s1,s1,0x1
    8000623e:	8885                	andi	s1,s1,1
    80006240:	dd64                	sw	s1,124(a0)
    80006242:	bfe9                	j	8000621c <push_off+0x24>

0000000080006244 <acquire>:
{
    80006244:	1101                	addi	sp,sp,-32
    80006246:	ec06                	sd	ra,24(sp)
    80006248:	e822                	sd	s0,16(sp)
    8000624a:	e426                	sd	s1,8(sp)
    8000624c:	1000                	addi	s0,sp,32
    8000624e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006250:	00000097          	auipc	ra,0x0
    80006254:	fa8080e7          	jalr	-88(ra) # 800061f8 <push_off>
  if(holding(lk))
    80006258:	8526                	mv	a0,s1
    8000625a:	00000097          	auipc	ra,0x0
    8000625e:	f70080e7          	jalr	-144(ra) # 800061ca <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006262:	4705                	li	a4,1
  if(holding(lk))
    80006264:	e115                	bnez	a0,80006288 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006266:	87ba                	mv	a5,a4
    80006268:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000626c:	2781                	sext.w	a5,a5
    8000626e:	ffe5                	bnez	a5,80006266 <acquire+0x22>
  __sync_synchronize();
    80006270:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006274:	ffffb097          	auipc	ra,0xffffb
    80006278:	bba080e7          	jalr	-1094(ra) # 80000e2e <mycpu>
    8000627c:	e888                	sd	a0,16(s1)
}
    8000627e:	60e2                	ld	ra,24(sp)
    80006280:	6442                	ld	s0,16(sp)
    80006282:	64a2                	ld	s1,8(sp)
    80006284:	6105                	addi	sp,sp,32
    80006286:	8082                	ret
    panic("acquire");
    80006288:	00002517          	auipc	a0,0x2
    8000628c:	58050513          	addi	a0,a0,1408 # 80008808 <digits+0x20>
    80006290:	00000097          	auipc	ra,0x0
    80006294:	a1a080e7          	jalr	-1510(ra) # 80005caa <panic>

0000000080006298 <pop_off>:

void
pop_off(void)
{
    80006298:	1141                	addi	sp,sp,-16
    8000629a:	e406                	sd	ra,8(sp)
    8000629c:	e022                	sd	s0,0(sp)
    8000629e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062a0:	ffffb097          	auipc	ra,0xffffb
    800062a4:	b8e080e7          	jalr	-1138(ra) # 80000e2e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062a8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062ac:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062ae:	e78d                	bnez	a5,800062d8 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062b0:	5d3c                	lw	a5,120(a0)
    800062b2:	02f05b63          	blez	a5,800062e8 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062b6:	37fd                	addiw	a5,a5,-1
    800062b8:	0007871b          	sext.w	a4,a5
    800062bc:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062be:	eb09                	bnez	a4,800062d0 <pop_off+0x38>
    800062c0:	5d7c                	lw	a5,124(a0)
    800062c2:	c799                	beqz	a5,800062d0 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062cc:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062d0:	60a2                	ld	ra,8(sp)
    800062d2:	6402                	ld	s0,0(sp)
    800062d4:	0141                	addi	sp,sp,16
    800062d6:	8082                	ret
    panic("pop_off - interruptible");
    800062d8:	00002517          	auipc	a0,0x2
    800062dc:	53850513          	addi	a0,a0,1336 # 80008810 <digits+0x28>
    800062e0:	00000097          	auipc	ra,0x0
    800062e4:	9ca080e7          	jalr	-1590(ra) # 80005caa <panic>
    panic("pop_off");
    800062e8:	00002517          	auipc	a0,0x2
    800062ec:	54050513          	addi	a0,a0,1344 # 80008828 <digits+0x40>
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	9ba080e7          	jalr	-1606(ra) # 80005caa <panic>

00000000800062f8 <release>:
{
    800062f8:	1101                	addi	sp,sp,-32
    800062fa:	ec06                	sd	ra,24(sp)
    800062fc:	e822                	sd	s0,16(sp)
    800062fe:	e426                	sd	s1,8(sp)
    80006300:	1000                	addi	s0,sp,32
    80006302:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006304:	00000097          	auipc	ra,0x0
    80006308:	ec6080e7          	jalr	-314(ra) # 800061ca <holding>
    8000630c:	c115                	beqz	a0,80006330 <release+0x38>
  lk->cpu = 0;
    8000630e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006312:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006316:	0f50000f          	fence	iorw,ow
    8000631a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	f7a080e7          	jalr	-134(ra) # 80006298 <pop_off>
}
    80006326:	60e2                	ld	ra,24(sp)
    80006328:	6442                	ld	s0,16(sp)
    8000632a:	64a2                	ld	s1,8(sp)
    8000632c:	6105                	addi	sp,sp,32
    8000632e:	8082                	ret
    panic("release");
    80006330:	00002517          	auipc	a0,0x2
    80006334:	50050513          	addi	a0,a0,1280 # 80008830 <digits+0x48>
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	972080e7          	jalr	-1678(ra) # 80005caa <panic>
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
