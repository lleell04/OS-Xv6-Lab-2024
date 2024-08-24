
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9d013103          	ld	sp,-1584(sp) # 800089d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6c2050ef          	jal	ra,800056d8 <start>

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
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	078080e7          	jalr	120(ra) # 800060d2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	118080e7          	jalr	280(ra) # 80006186 <release>
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
    8000008e:	afe080e7          	jalr	-1282(ra) # 80005b88 <panic>

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
    800000f8:	f4e080e7          	jalr	-178(ra) # 80006042 <initlock>
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
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	fa6080e7          	jalr	-90(ra) # 800060d2 <acquire>
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
    80000148:	042080e7          	jalr	66(ra) # 80006186 <release>

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
    80000172:	018080e7          	jalr	24(ra) # 80006186 <release>
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
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
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
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	876080e7          	jalr	-1930(ra) # 80005bd2 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	730080e7          	jalr	1840(ra) # 80001a9c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	cec080e7          	jalr	-788(ra) # 80005060 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fde080e7          	jalr	-34(ra) # 8000135a <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	716080e7          	jalr	1814(ra) # 80005a9a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	a2c080e7          	jalr	-1492(ra) # 80005db8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	836080e7          	jalr	-1994(ra) # 80005bd2 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	826080e7          	jalr	-2010(ra) # 80005bd2 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	816080e7          	jalr	-2026(ra) # 80005bd2 <printf>
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
    800003e8:	690080e7          	jalr	1680(ra) # 80001a74 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6b0080e7          	jalr	1712(ra) # 80001a9c <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	c56080e7          	jalr	-938(ra) # 8000504a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	c64080e7          	jalr	-924(ra) # 80005060 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	e42080e7          	jalr	-446(ra) # 80002246 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	4d2080e7          	jalr	1234(ra) # 800028de <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	47c080e7          	jalr	1148(ra) # 80003890 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	d66080e7          	jalr	-666(ra) # 80005182 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfc080e7          	jalr	-772(ra) # 80001120 <userinit>
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
    8000048e:	00005097          	auipc	ra,0x5
    80000492:	6fa080e7          	jalr	1786(ra) # 80005b88 <panic>
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
    8000058a:	602080e7          	jalr	1538(ra) # 80005b88 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	5f2080e7          	jalr	1522(ra) # 80005b88 <panic>
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
    80000614:	578080e7          	jalr	1400(ra) # 80005b88 <panic>

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
    80000760:	42c080e7          	jalr	1068(ra) # 80005b88 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	41c080e7          	jalr	1052(ra) # 80005b88 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	40c080e7          	jalr	1036(ra) # 80005b88 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	3fc080e7          	jalr	1020(ra) # 80005b88 <panic>
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
    8000086e:	31e080e7          	jalr	798(ra) # 80005b88 <panic>

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
    800009b0:	1dc080e7          	jalr	476(ra) # 80005b88 <panic>
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
    80000a8c:	100080e7          	jalr	256(ra) # 80005b88 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	0f0080e7          	jalr	240(ra) # 80005b88 <panic>
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
    80000b06:	086080e7          	jalr	134(ra) # 80005b88 <panic>

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
    80000d06:	0000ea17          	auipc	s4,0xe
    80000d0a:	37aa0a13          	addi	s4,s4,890 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	8591                	srai	a1,a1,0x4
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
    80000d40:	17048493          	addi	s1,s1,368
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
    80000d68:	e24080e7          	jalr	-476(ra) # 80005b88 <panic>

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
    80000d94:	2b2080e7          	jalr	690(ra) # 80006042 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	29a080e7          	jalr	666(ra) # 80006042 <initlock>
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
    80000dd2:	0000e997          	auipc	s3,0xe
    80000dd6:	2ae98993          	addi	s3,s3,686 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	264080e7          	jalr	612(ra) # 80006042 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	8791                	srai	a5,a5,0x4
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	17048493          	addi	s1,s1,368
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	234080e7          	jalr	564(ra) # 80006086 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	2ba080e7          	jalr	698(ra) # 80006126 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	2f6080e7          	jalr	758(ra) # 80006186 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	ae87a783          	lw	a5,-1304(a5) # 80008980 <first.1673>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c12080e7          	jalr	-1006(ra) # 80001ab4 <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	ac07a723          	sw	zero,-1330(a5) # 80008980 <first.1673>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	9a2080e7          	jalr	-1630(ra) # 8000285e <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	1f6080e7          	jalr	502(ra) # 800060d2 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	aa078793          	addi	a5,a5,-1376 # 80008984 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	290080e7          	jalr	656(ra) # 80006186 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	0000e917          	auipc	s2,0xe
    8000106a:	01a90913          	addi	s2,s2,26 # 8000f080 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	062080e7          	jalr	98(ra) # 800060d2 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	108080e7          	jalr	264(ra) # 80006186 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	17048493          	addi	s1,s1,368
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a889                	j	800010e2 <allocproc+0x90>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a0:	fffff097          	auipc	ra,0xfffff
    800010a4:	078080e7          	jalr	120(ra) # 80000118 <kalloc>
    800010a8:	892a                	mv	s2,a0
    800010aa:	eca8                	sd	a0,88(s1)
    800010ac:	c131                	beqz	a0,800010f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ae:	8526                	mv	a0,s1
    800010b0:	00000097          	auipc	ra,0x0
    800010b4:	e5c080e7          	jalr	-420(ra) # 80000f0c <proc_pagetable>
    800010b8:	892a                	mv	s2,a0
    800010ba:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010bc:	c531                	beqz	a0,80001108 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010be:	07000613          	li	a2,112
    800010c2:	4581                	li	a1,0
    800010c4:	06048513          	addi	a0,s1,96
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	0b0080e7          	jalr	176(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d0:	00000797          	auipc	a5,0x0
    800010d4:	db078793          	addi	a5,a5,-592 # 80000e80 <forkret>
    800010d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010da:	60bc                	ld	a5,64(s1)
    800010dc:	6705                	lui	a4,0x1
    800010de:	97ba                	add	a5,a5,a4
    800010e0:	f4bc                	sd	a5,104(s1)
}
    800010e2:	8526                	mv	a0,s1
    800010e4:	60e2                	ld	ra,24(sp)
    800010e6:	6442                	ld	s0,16(sp)
    800010e8:	64a2                	ld	s1,8(sp)
    800010ea:	6902                	ld	s2,0(sp)
    800010ec:	6105                	addi	sp,sp,32
    800010ee:	8082                	ret
    freeproc(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f08080e7          	jalr	-248(ra) # 80000ffa <freeproc>
    release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	08a080e7          	jalr	138(ra) # 80006186 <release>
    return 0;
    80001104:	84ca                	mv	s1,s2
    80001106:	bff1                	j	800010e2 <allocproc+0x90>
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef0080e7          	jalr	-272(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	072080e7          	jalr	114(ra) # 80006186 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	b7d1                	j	800010e2 <allocproc+0x90>

0000000080001120 <userinit>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	1000                	addi	s0,sp,32
  p = allocproc();
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f28080e7          	jalr	-216(ra) # 80001052 <allocproc>
    80001132:	84aa                	mv	s1,a0
  initproc = p;
    80001134:	00008797          	auipc	a5,0x8
    80001138:	eca7be23          	sd	a0,-292(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113c:	03400613          	li	a2,52
    80001140:	00008597          	auipc	a1,0x8
    80001144:	85058593          	addi	a1,a1,-1968 # 80008990 <initcode>
    80001148:	6928                	ld	a0,80(a0)
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	6b6080e7          	jalr	1718(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001152:	6785                	lui	a5,0x1
    80001154:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115c:	6cb8                	ld	a4,88(s1)
    8000115e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001160:	4641                	li	a2,16
    80001162:	00007597          	auipc	a1,0x7
    80001166:	01e58593          	addi	a1,a1,30 # 80008180 <etext+0x180>
    8000116a:	15848513          	addi	a0,s1,344
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	15c080e7          	jalr	348(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001176:	00007517          	auipc	a0,0x7
    8000117a:	01a50513          	addi	a0,a0,26 # 80008190 <etext+0x190>
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	10e080e7          	jalr	270(ra) # 8000328c <namei>
    80001186:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000118a:	478d                	li	a5,3
    8000118c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	ff6080e7          	jalr	-10(ra) # 80006186 <release>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <growproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	e04a                	sd	s2,0(sp)
    800011ac:	1000                	addi	s0,sp,32
    800011ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	c98080e7          	jalr	-872(ra) # 80000e48 <myproc>
    800011b8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ba:	652c                	ld	a1,72(a0)
    800011bc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c0:	00904f63          	bgtz	s1,800011de <growproc+0x3c>
  } else if(n < 0){
    800011c4:	0204cc63          	bltz	s1,800011fc <growproc+0x5a>
  p->sz = sz;
    800011c8:	1602                	slli	a2,a2,0x20
    800011ca:	9201                	srli	a2,a2,0x20
    800011cc:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011de:	9e25                	addw	a2,a2,s1
    800011e0:	1602                	slli	a2,a2,0x20
    800011e2:	9201                	srli	a2,a2,0x20
    800011e4:	1582                	slli	a1,a1,0x20
    800011e6:	9181                	srli	a1,a1,0x20
    800011e8:	6928                	ld	a0,80(a0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	6d0080e7          	jalr	1744(ra) # 800008ba <uvmalloc>
    800011f2:	0005061b          	sext.w	a2,a0
    800011f6:	fa69                	bnez	a2,800011c8 <growproc+0x26>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bfe1                	j	800011d2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	9e25                	addw	a2,a2,s1
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	66a080e7          	jalr	1642(ra) # 80000872 <uvmdealloc>
    80001210:	0005061b          	sext.w	a2,a0
    80001214:	bf55                	j	800011c8 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7179                	addi	sp,sp,-48
    80001218:	f406                	sd	ra,40(sp)
    8000121a:	f022                	sd	s0,32(sp)
    8000121c:	ec26                	sd	s1,24(sp)
    8000121e:	e84a                	sd	s2,16(sp)
    80001220:	e44e                	sd	s3,8(sp)
    80001222:	e052                	sd	s4,0(sp)
    80001224:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	c22080e7          	jalr	-990(ra) # 80000e48 <myproc>
    8000122e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001230:	00000097          	auipc	ra,0x0
    80001234:	e22080e7          	jalr	-478(ra) # 80001052 <allocproc>
    80001238:	10050f63          	beqz	a0,80001356 <fork+0x140>
    8000123c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123e:	04893603          	ld	a2,72(s2)
    80001242:	692c                	ld	a1,80(a0)
    80001244:	05093503          	ld	a0,80(s2)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	7be080e7          	jalr	1982(ra) # 80000a06 <uvmcopy>
    80001250:	04054a63          	bltz	a0,800012a4 <fork+0x8e>
  np->sz = p->sz;
    80001254:	04893783          	ld	a5,72(s2)
    80001258:	04f9b423          	sd	a5,72(s3)
  np->tracemask = p->tracemask;
    8000125c:	16892783          	lw	a5,360(s2)
    80001260:	16f9a423          	sw	a5,360(s3)
  *(np->trapframe) = *(p->trapframe);
    80001264:	05893683          	ld	a3,88(s2)
    80001268:	87b6                	mv	a5,a3
    8000126a:	0589b703          	ld	a4,88(s3)
    8000126e:	12068693          	addi	a3,a3,288
    80001272:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001276:	6788                	ld	a0,8(a5)
    80001278:	6b8c                	ld	a1,16(a5)
    8000127a:	6f90                	ld	a2,24(a5)
    8000127c:	01073023          	sd	a6,0(a4)
    80001280:	e708                	sd	a0,8(a4)
    80001282:	eb0c                	sd	a1,16(a4)
    80001284:	ef10                	sd	a2,24(a4)
    80001286:	02078793          	addi	a5,a5,32
    8000128a:	02070713          	addi	a4,a4,32
    8000128e:	fed792e3          	bne	a5,a3,80001272 <fork+0x5c>
  np->trapframe->a0 = 0;
    80001292:	0589b783          	ld	a5,88(s3)
    80001296:	0607b823          	sd	zero,112(a5)
    8000129a:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000129e:	15000a13          	li	s4,336
    800012a2:	a03d                	j	800012d0 <fork+0xba>
    freeproc(np);
    800012a4:	854e                	mv	a0,s3
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	d54080e7          	jalr	-684(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012ae:	854e                	mv	a0,s3
    800012b0:	00005097          	auipc	ra,0x5
    800012b4:	ed6080e7          	jalr	-298(ra) # 80006186 <release>
    return -1;
    800012b8:	5a7d                	li	s4,-1
    800012ba:	a069                	j	80001344 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012bc:	00002097          	auipc	ra,0x2
    800012c0:	666080e7          	jalr	1638(ra) # 80003922 <filedup>
    800012c4:	009987b3          	add	a5,s3,s1
    800012c8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012ca:	04a1                	addi	s1,s1,8
    800012cc:	01448763          	beq	s1,s4,800012da <fork+0xc4>
    if(p->ofile[i])
    800012d0:	009907b3          	add	a5,s2,s1
    800012d4:	6388                	ld	a0,0(a5)
    800012d6:	f17d                	bnez	a0,800012bc <fork+0xa6>
    800012d8:	bfcd                	j	800012ca <fork+0xb4>
  np->cwd = idup(p->cwd);
    800012da:	15093503          	ld	a0,336(s2)
    800012de:	00001097          	auipc	ra,0x1
    800012e2:	7ba080e7          	jalr	1978(ra) # 80002a98 <idup>
    800012e6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012ea:	4641                	li	a2,16
    800012ec:	15890593          	addi	a1,s2,344
    800012f0:	15898513          	addi	a0,s3,344
    800012f4:	fffff097          	auipc	ra,0xfffff
    800012f8:	fd6080e7          	jalr	-42(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012fc:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001300:	854e                	mv	a0,s3
    80001302:	00005097          	auipc	ra,0x5
    80001306:	e84080e7          	jalr	-380(ra) # 80006186 <release>
  acquire(&wait_lock);
    8000130a:	00008497          	auipc	s1,0x8
    8000130e:	d5e48493          	addi	s1,s1,-674 # 80009068 <wait_lock>
    80001312:	8526                	mv	a0,s1
    80001314:	00005097          	auipc	ra,0x5
    80001318:	dbe080e7          	jalr	-578(ra) # 800060d2 <acquire>
  np->parent = p;
    8000131c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001320:	8526                	mv	a0,s1
    80001322:	00005097          	auipc	ra,0x5
    80001326:	e64080e7          	jalr	-412(ra) # 80006186 <release>
  acquire(&np->lock);
    8000132a:	854e                	mv	a0,s3
    8000132c:	00005097          	auipc	ra,0x5
    80001330:	da6080e7          	jalr	-602(ra) # 800060d2 <acquire>
  np->state = RUNNABLE;
    80001334:	478d                	li	a5,3
    80001336:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000133a:	854e                	mv	a0,s3
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	e4a080e7          	jalr	-438(ra) # 80006186 <release>
}
    80001344:	8552                	mv	a0,s4
    80001346:	70a2                	ld	ra,40(sp)
    80001348:	7402                	ld	s0,32(sp)
    8000134a:	64e2                	ld	s1,24(sp)
    8000134c:	6942                	ld	s2,16(sp)
    8000134e:	69a2                	ld	s3,8(sp)
    80001350:	6a02                	ld	s4,0(sp)
    80001352:	6145                	addi	sp,sp,48
    80001354:	8082                	ret
    return -1;
    80001356:	5a7d                	li	s4,-1
    80001358:	b7f5                	j	80001344 <fork+0x12e>

000000008000135a <scheduler>:
{
    8000135a:	7139                	addi	sp,sp,-64
    8000135c:	fc06                	sd	ra,56(sp)
    8000135e:	f822                	sd	s0,48(sp)
    80001360:	f426                	sd	s1,40(sp)
    80001362:	f04a                	sd	s2,32(sp)
    80001364:	ec4e                	sd	s3,24(sp)
    80001366:	e852                	sd	s4,16(sp)
    80001368:	e456                	sd	s5,8(sp)
    8000136a:	e05a                	sd	s6,0(sp)
    8000136c:	0080                	addi	s0,sp,64
    8000136e:	8792                	mv	a5,tp
  int id = r_tp();
    80001370:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001372:	00779a93          	slli	s5,a5,0x7
    80001376:	00008717          	auipc	a4,0x8
    8000137a:	cda70713          	addi	a4,a4,-806 # 80009050 <pid_lock>
    8000137e:	9756                	add	a4,a4,s5
    80001380:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001384:	00008717          	auipc	a4,0x8
    80001388:	d0470713          	addi	a4,a4,-764 # 80009088 <cpus+0x8>
    8000138c:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000138e:	498d                	li	s3,3
        p->state = RUNNING;
    80001390:	4b11                	li	s6,4
        c->proc = p;
    80001392:	079e                	slli	a5,a5,0x7
    80001394:	00008a17          	auipc	s4,0x8
    80001398:	cbca0a13          	addi	s4,s4,-836 # 80009050 <pid_lock>
    8000139c:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139e:	0000e917          	auipc	s2,0xe
    800013a2:	ce290913          	addi	s2,s2,-798 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ae:	10079073          	csrw	sstatus,a5
    800013b2:	00008497          	auipc	s1,0x8
    800013b6:	0ce48493          	addi	s1,s1,206 # 80009480 <proc>
    800013ba:	a03d                	j	800013e8 <scheduler+0x8e>
        p->state = RUNNING;
    800013bc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013c0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013c4:	06048593          	addi	a1,s1,96
    800013c8:	8556                	mv	a0,s5
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	640080e7          	jalr	1600(ra) # 80001a0a <swtch>
        c->proc = 0;
    800013d2:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013d6:	8526                	mv	a0,s1
    800013d8:	00005097          	auipc	ra,0x5
    800013dc:	dae080e7          	jalr	-594(ra) # 80006186 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e0:	17048493          	addi	s1,s1,368
    800013e4:	fd2481e3          	beq	s1,s2,800013a6 <scheduler+0x4c>
      acquire(&p->lock);
    800013e8:	8526                	mv	a0,s1
    800013ea:	00005097          	auipc	ra,0x5
    800013ee:	ce8080e7          	jalr	-792(ra) # 800060d2 <acquire>
      if(p->state == RUNNABLE) {
    800013f2:	4c9c                	lw	a5,24(s1)
    800013f4:	ff3791e3          	bne	a5,s3,800013d6 <scheduler+0x7c>
    800013f8:	b7d1                	j	800013bc <scheduler+0x62>

00000000800013fa <sched>:
{
    800013fa:	7179                	addi	sp,sp,-48
    800013fc:	f406                	sd	ra,40(sp)
    800013fe:	f022                	sd	s0,32(sp)
    80001400:	ec26                	sd	s1,24(sp)
    80001402:	e84a                	sd	s2,16(sp)
    80001404:	e44e                	sd	s3,8(sp)
    80001406:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	a40080e7          	jalr	-1472(ra) # 80000e48 <myproc>
    80001410:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001412:	00005097          	auipc	ra,0x5
    80001416:	c46080e7          	jalr	-954(ra) # 80006058 <holding>
    8000141a:	c93d                	beqz	a0,80001490 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000141c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000141e:	2781                	sext.w	a5,a5
    80001420:	079e                	slli	a5,a5,0x7
    80001422:	00008717          	auipc	a4,0x8
    80001426:	c2e70713          	addi	a4,a4,-978 # 80009050 <pid_lock>
    8000142a:	97ba                	add	a5,a5,a4
    8000142c:	0a87a703          	lw	a4,168(a5)
    80001430:	4785                	li	a5,1
    80001432:	06f71763          	bne	a4,a5,800014a0 <sched+0xa6>
  if(p->state == RUNNING)
    80001436:	4c98                	lw	a4,24(s1)
    80001438:	4791                	li	a5,4
    8000143a:	06f70b63          	beq	a4,a5,800014b0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000143e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001442:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001444:	efb5                	bnez	a5,800014c0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001446:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001448:	00008917          	auipc	s2,0x8
    8000144c:	c0890913          	addi	s2,s2,-1016 # 80009050 <pid_lock>
    80001450:	2781                	sext.w	a5,a5
    80001452:	079e                	slli	a5,a5,0x7
    80001454:	97ca                	add	a5,a5,s2
    80001456:	0ac7a983          	lw	s3,172(a5)
    8000145a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000145c:	2781                	sext.w	a5,a5
    8000145e:	079e                	slli	a5,a5,0x7
    80001460:	00008597          	auipc	a1,0x8
    80001464:	c2858593          	addi	a1,a1,-984 # 80009088 <cpus+0x8>
    80001468:	95be                	add	a1,a1,a5
    8000146a:	06048513          	addi	a0,s1,96
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	59c080e7          	jalr	1436(ra) # 80001a0a <swtch>
    80001476:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001478:	2781                	sext.w	a5,a5
    8000147a:	079e                	slli	a5,a5,0x7
    8000147c:	97ca                	add	a5,a5,s2
    8000147e:	0b37a623          	sw	s3,172(a5)
}
    80001482:	70a2                	ld	ra,40(sp)
    80001484:	7402                	ld	s0,32(sp)
    80001486:	64e2                	ld	s1,24(sp)
    80001488:	6942                	ld	s2,16(sp)
    8000148a:	69a2                	ld	s3,8(sp)
    8000148c:	6145                	addi	sp,sp,48
    8000148e:	8082                	ret
    panic("sched p->lock");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	d0850513          	addi	a0,a0,-760 # 80008198 <etext+0x198>
    80001498:	00004097          	auipc	ra,0x4
    8000149c:	6f0080e7          	jalr	1776(ra) # 80005b88 <panic>
    panic("sched locks");
    800014a0:	00007517          	auipc	a0,0x7
    800014a4:	d0850513          	addi	a0,a0,-760 # 800081a8 <etext+0x1a8>
    800014a8:	00004097          	auipc	ra,0x4
    800014ac:	6e0080e7          	jalr	1760(ra) # 80005b88 <panic>
    panic("sched running");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	d0850513          	addi	a0,a0,-760 # 800081b8 <etext+0x1b8>
    800014b8:	00004097          	auipc	ra,0x4
    800014bc:	6d0080e7          	jalr	1744(ra) # 80005b88 <panic>
    panic("sched interruptible");
    800014c0:	00007517          	auipc	a0,0x7
    800014c4:	d0850513          	addi	a0,a0,-760 # 800081c8 <etext+0x1c8>
    800014c8:	00004097          	auipc	ra,0x4
    800014cc:	6c0080e7          	jalr	1728(ra) # 80005b88 <panic>

00000000800014d0 <yield>:
{
    800014d0:	1101                	addi	sp,sp,-32
    800014d2:	ec06                	sd	ra,24(sp)
    800014d4:	e822                	sd	s0,16(sp)
    800014d6:	e426                	sd	s1,8(sp)
    800014d8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014da:	00000097          	auipc	ra,0x0
    800014de:	96e080e7          	jalr	-1682(ra) # 80000e48 <myproc>
    800014e2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e4:	00005097          	auipc	ra,0x5
    800014e8:	bee080e7          	jalr	-1042(ra) # 800060d2 <acquire>
  p->state = RUNNABLE;
    800014ec:	478d                	li	a5,3
    800014ee:	cc9c                	sw	a5,24(s1)
  sched();
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f0a080e7          	jalr	-246(ra) # 800013fa <sched>
  release(&p->lock);
    800014f8:	8526                	mv	a0,s1
    800014fa:	00005097          	auipc	ra,0x5
    800014fe:	c8c080e7          	jalr	-884(ra) # 80006186 <release>
}
    80001502:	60e2                	ld	ra,24(sp)
    80001504:	6442                	ld	s0,16(sp)
    80001506:	64a2                	ld	s1,8(sp)
    80001508:	6105                	addi	sp,sp,32
    8000150a:	8082                	ret

000000008000150c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000150c:	7179                	addi	sp,sp,-48
    8000150e:	f406                	sd	ra,40(sp)
    80001510:	f022                	sd	s0,32(sp)
    80001512:	ec26                	sd	s1,24(sp)
    80001514:	e84a                	sd	s2,16(sp)
    80001516:	e44e                	sd	s3,8(sp)
    80001518:	1800                	addi	s0,sp,48
    8000151a:	89aa                	mv	s3,a0
    8000151c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	92a080e7          	jalr	-1750(ra) # 80000e48 <myproc>
    80001526:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	baa080e7          	jalr	-1110(ra) # 800060d2 <acquire>
  release(lk);
    80001530:	854a                	mv	a0,s2
    80001532:	00005097          	auipc	ra,0x5
    80001536:	c54080e7          	jalr	-940(ra) # 80006186 <release>

  // Go to sleep.
  p->chan = chan;
    8000153a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000153e:	4789                	li	a5,2
    80001540:	cc9c                	sw	a5,24(s1)

  sched();
    80001542:	00000097          	auipc	ra,0x0
    80001546:	eb8080e7          	jalr	-328(ra) # 800013fa <sched>

  // Tidy up.
  p->chan = 0;
    8000154a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000154e:	8526                	mv	a0,s1
    80001550:	00005097          	auipc	ra,0x5
    80001554:	c36080e7          	jalr	-970(ra) # 80006186 <release>
  acquire(lk);
    80001558:	854a                	mv	a0,s2
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	b78080e7          	jalr	-1160(ra) # 800060d2 <acquire>
}
    80001562:	70a2                	ld	ra,40(sp)
    80001564:	7402                	ld	s0,32(sp)
    80001566:	64e2                	ld	s1,24(sp)
    80001568:	6942                	ld	s2,16(sp)
    8000156a:	69a2                	ld	s3,8(sp)
    8000156c:	6145                	addi	sp,sp,48
    8000156e:	8082                	ret

0000000080001570 <wait>:
{
    80001570:	715d                	addi	sp,sp,-80
    80001572:	e486                	sd	ra,72(sp)
    80001574:	e0a2                	sd	s0,64(sp)
    80001576:	fc26                	sd	s1,56(sp)
    80001578:	f84a                	sd	s2,48(sp)
    8000157a:	f44e                	sd	s3,40(sp)
    8000157c:	f052                	sd	s4,32(sp)
    8000157e:	ec56                	sd	s5,24(sp)
    80001580:	e85a                	sd	s6,16(sp)
    80001582:	e45e                	sd	s7,8(sp)
    80001584:	e062                	sd	s8,0(sp)
    80001586:	0880                	addi	s0,sp,80
    80001588:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	8be080e7          	jalr	-1858(ra) # 80000e48 <myproc>
    80001592:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001594:	00008517          	auipc	a0,0x8
    80001598:	ad450513          	addi	a0,a0,-1324 # 80009068 <wait_lock>
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	b36080e7          	jalr	-1226(ra) # 800060d2 <acquire>
    havekids = 0;
    800015a4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015a6:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015a8:	0000e997          	auipc	s3,0xe
    800015ac:	ad898993          	addi	s3,s3,-1320 # 8000f080 <tickslock>
        havekids = 1;
    800015b0:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b2:	00008c17          	auipc	s8,0x8
    800015b6:	ab6c0c13          	addi	s8,s8,-1354 # 80009068 <wait_lock>
    havekids = 0;
    800015ba:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015bc:	00008497          	auipc	s1,0x8
    800015c0:	ec448493          	addi	s1,s1,-316 # 80009480 <proc>
    800015c4:	a0bd                	j	80001632 <wait+0xc2>
          pid = np->pid;
    800015c6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ca:	000b0e63          	beqz	s6,800015e6 <wait+0x76>
    800015ce:	4691                	li	a3,4
    800015d0:	02c48613          	addi	a2,s1,44
    800015d4:	85da                	mv	a1,s6
    800015d6:	05093503          	ld	a0,80(s2)
    800015da:	fffff097          	auipc	ra,0xfffff
    800015de:	530080e7          	jalr	1328(ra) # 80000b0a <copyout>
    800015e2:	02054563          	bltz	a0,8000160c <wait+0x9c>
          freeproc(np);
    800015e6:	8526                	mv	a0,s1
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	a12080e7          	jalr	-1518(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015f0:	8526                	mv	a0,s1
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	b94080e7          	jalr	-1132(ra) # 80006186 <release>
          release(&wait_lock);
    800015fa:	00008517          	auipc	a0,0x8
    800015fe:	a6e50513          	addi	a0,a0,-1426 # 80009068 <wait_lock>
    80001602:	00005097          	auipc	ra,0x5
    80001606:	b84080e7          	jalr	-1148(ra) # 80006186 <release>
          return pid;
    8000160a:	a09d                	j	80001670 <wait+0x100>
            release(&np->lock);
    8000160c:	8526                	mv	a0,s1
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	b78080e7          	jalr	-1160(ra) # 80006186 <release>
            release(&wait_lock);
    80001616:	00008517          	auipc	a0,0x8
    8000161a:	a5250513          	addi	a0,a0,-1454 # 80009068 <wait_lock>
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	b68080e7          	jalr	-1176(ra) # 80006186 <release>
            return -1;
    80001626:	59fd                	li	s3,-1
    80001628:	a0a1                	j	80001670 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000162a:	17048493          	addi	s1,s1,368
    8000162e:	03348463          	beq	s1,s3,80001656 <wait+0xe6>
      if(np->parent == p){
    80001632:	7c9c                	ld	a5,56(s1)
    80001634:	ff279be3          	bne	a5,s2,8000162a <wait+0xba>
        acquire(&np->lock);
    80001638:	8526                	mv	a0,s1
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	a98080e7          	jalr	-1384(ra) # 800060d2 <acquire>
        if(np->state == ZOMBIE){
    80001642:	4c9c                	lw	a5,24(s1)
    80001644:	f94781e3          	beq	a5,s4,800015c6 <wait+0x56>
        release(&np->lock);
    80001648:	8526                	mv	a0,s1
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	b3c080e7          	jalr	-1220(ra) # 80006186 <release>
        havekids = 1;
    80001652:	8756                	mv	a4,s5
    80001654:	bfd9                	j	8000162a <wait+0xba>
    if(!havekids || p->killed){
    80001656:	c701                	beqz	a4,8000165e <wait+0xee>
    80001658:	02892783          	lw	a5,40(s2)
    8000165c:	c79d                	beqz	a5,8000168a <wait+0x11a>
      release(&wait_lock);
    8000165e:	00008517          	auipc	a0,0x8
    80001662:	a0a50513          	addi	a0,a0,-1526 # 80009068 <wait_lock>
    80001666:	00005097          	auipc	ra,0x5
    8000166a:	b20080e7          	jalr	-1248(ra) # 80006186 <release>
      return -1;
    8000166e:	59fd                	li	s3,-1
}
    80001670:	854e                	mv	a0,s3
    80001672:	60a6                	ld	ra,72(sp)
    80001674:	6406                	ld	s0,64(sp)
    80001676:	74e2                	ld	s1,56(sp)
    80001678:	7942                	ld	s2,48(sp)
    8000167a:	79a2                	ld	s3,40(sp)
    8000167c:	7a02                	ld	s4,32(sp)
    8000167e:	6ae2                	ld	s5,24(sp)
    80001680:	6b42                	ld	s6,16(sp)
    80001682:	6ba2                	ld	s7,8(sp)
    80001684:	6c02                	ld	s8,0(sp)
    80001686:	6161                	addi	sp,sp,80
    80001688:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000168a:	85e2                	mv	a1,s8
    8000168c:	854a                	mv	a0,s2
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	e7e080e7          	jalr	-386(ra) # 8000150c <sleep>
    havekids = 0;
    80001696:	b715                	j	800015ba <wait+0x4a>

0000000080001698 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001698:	7139                	addi	sp,sp,-64
    8000169a:	fc06                	sd	ra,56(sp)
    8000169c:	f822                	sd	s0,48(sp)
    8000169e:	f426                	sd	s1,40(sp)
    800016a0:	f04a                	sd	s2,32(sp)
    800016a2:	ec4e                	sd	s3,24(sp)
    800016a4:	e852                	sd	s4,16(sp)
    800016a6:	e456                	sd	s5,8(sp)
    800016a8:	0080                	addi	s0,sp,64
    800016aa:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ac:	00008497          	auipc	s1,0x8
    800016b0:	dd448493          	addi	s1,s1,-556 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016b4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016b6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b8:	0000e917          	auipc	s2,0xe
    800016bc:	9c890913          	addi	s2,s2,-1592 # 8000f080 <tickslock>
    800016c0:	a821                	j	800016d8 <wakeup+0x40>
        p->state = RUNNABLE;
    800016c2:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016c6:	8526                	mv	a0,s1
    800016c8:	00005097          	auipc	ra,0x5
    800016cc:	abe080e7          	jalr	-1346(ra) # 80006186 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d0:	17048493          	addi	s1,s1,368
    800016d4:	03248463          	beq	s1,s2,800016fc <wakeup+0x64>
    if(p != myproc()){
    800016d8:	fffff097          	auipc	ra,0xfffff
    800016dc:	770080e7          	jalr	1904(ra) # 80000e48 <myproc>
    800016e0:	fea488e3          	beq	s1,a0,800016d0 <wakeup+0x38>
      acquire(&p->lock);
    800016e4:	8526                	mv	a0,s1
    800016e6:	00005097          	auipc	ra,0x5
    800016ea:	9ec080e7          	jalr	-1556(ra) # 800060d2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016ee:	4c9c                	lw	a5,24(s1)
    800016f0:	fd379be3          	bne	a5,s3,800016c6 <wakeup+0x2e>
    800016f4:	709c                	ld	a5,32(s1)
    800016f6:	fd4798e3          	bne	a5,s4,800016c6 <wakeup+0x2e>
    800016fa:	b7e1                	j	800016c2 <wakeup+0x2a>
    }
  }
}
    800016fc:	70e2                	ld	ra,56(sp)
    800016fe:	7442                	ld	s0,48(sp)
    80001700:	74a2                	ld	s1,40(sp)
    80001702:	7902                	ld	s2,32(sp)
    80001704:	69e2                	ld	s3,24(sp)
    80001706:	6a42                	ld	s4,16(sp)
    80001708:	6aa2                	ld	s5,8(sp)
    8000170a:	6121                	addi	sp,sp,64
    8000170c:	8082                	ret

000000008000170e <reparent>:
{
    8000170e:	7179                	addi	sp,sp,-48
    80001710:	f406                	sd	ra,40(sp)
    80001712:	f022                	sd	s0,32(sp)
    80001714:	ec26                	sd	s1,24(sp)
    80001716:	e84a                	sd	s2,16(sp)
    80001718:	e44e                	sd	s3,8(sp)
    8000171a:	e052                	sd	s4,0(sp)
    8000171c:	1800                	addi	s0,sp,48
    8000171e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001720:	00008497          	auipc	s1,0x8
    80001724:	d6048493          	addi	s1,s1,-672 # 80009480 <proc>
      pp->parent = initproc;
    80001728:	00008a17          	auipc	s4,0x8
    8000172c:	8e8a0a13          	addi	s4,s4,-1816 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001730:	0000e997          	auipc	s3,0xe
    80001734:	95098993          	addi	s3,s3,-1712 # 8000f080 <tickslock>
    80001738:	a029                	j	80001742 <reparent+0x34>
    8000173a:	17048493          	addi	s1,s1,368
    8000173e:	01348d63          	beq	s1,s3,80001758 <reparent+0x4a>
    if(pp->parent == p){
    80001742:	7c9c                	ld	a5,56(s1)
    80001744:	ff279be3          	bne	a5,s2,8000173a <reparent+0x2c>
      pp->parent = initproc;
    80001748:	000a3503          	ld	a0,0(s4)
    8000174c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000174e:	00000097          	auipc	ra,0x0
    80001752:	f4a080e7          	jalr	-182(ra) # 80001698 <wakeup>
    80001756:	b7d5                	j	8000173a <reparent+0x2c>
}
    80001758:	70a2                	ld	ra,40(sp)
    8000175a:	7402                	ld	s0,32(sp)
    8000175c:	64e2                	ld	s1,24(sp)
    8000175e:	6942                	ld	s2,16(sp)
    80001760:	69a2                	ld	s3,8(sp)
    80001762:	6a02                	ld	s4,0(sp)
    80001764:	6145                	addi	sp,sp,48
    80001766:	8082                	ret

0000000080001768 <exit>:
{
    80001768:	7179                	addi	sp,sp,-48
    8000176a:	f406                	sd	ra,40(sp)
    8000176c:	f022                	sd	s0,32(sp)
    8000176e:	ec26                	sd	s1,24(sp)
    80001770:	e84a                	sd	s2,16(sp)
    80001772:	e44e                	sd	s3,8(sp)
    80001774:	e052                	sd	s4,0(sp)
    80001776:	1800                	addi	s0,sp,48
    80001778:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000177a:	fffff097          	auipc	ra,0xfffff
    8000177e:	6ce080e7          	jalr	1742(ra) # 80000e48 <myproc>
    80001782:	89aa                	mv	s3,a0
  if(p == initproc)
    80001784:	00008797          	auipc	a5,0x8
    80001788:	88c7b783          	ld	a5,-1908(a5) # 80009010 <initproc>
    8000178c:	0d050493          	addi	s1,a0,208
    80001790:	15050913          	addi	s2,a0,336
    80001794:	02a79363          	bne	a5,a0,800017ba <exit+0x52>
    panic("init exiting");
    80001798:	00007517          	auipc	a0,0x7
    8000179c:	a4850513          	addi	a0,a0,-1464 # 800081e0 <etext+0x1e0>
    800017a0:	00004097          	auipc	ra,0x4
    800017a4:	3e8080e7          	jalr	1000(ra) # 80005b88 <panic>
      fileclose(f);
    800017a8:	00002097          	auipc	ra,0x2
    800017ac:	1cc080e7          	jalr	460(ra) # 80003974 <fileclose>
      p->ofile[fd] = 0;
    800017b0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017b4:	04a1                	addi	s1,s1,8
    800017b6:	01248563          	beq	s1,s2,800017c0 <exit+0x58>
    if(p->ofile[fd]){
    800017ba:	6088                	ld	a0,0(s1)
    800017bc:	f575                	bnez	a0,800017a8 <exit+0x40>
    800017be:	bfdd                	j	800017b4 <exit+0x4c>
  begin_op();
    800017c0:	00002097          	auipc	ra,0x2
    800017c4:	ce8080e7          	jalr	-792(ra) # 800034a8 <begin_op>
  iput(p->cwd);
    800017c8:	1509b503          	ld	a0,336(s3)
    800017cc:	00001097          	auipc	ra,0x1
    800017d0:	4c4080e7          	jalr	1220(ra) # 80002c90 <iput>
  end_op();
    800017d4:	00002097          	auipc	ra,0x2
    800017d8:	d54080e7          	jalr	-684(ra) # 80003528 <end_op>
  p->cwd = 0;
    800017dc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017e0:	00008497          	auipc	s1,0x8
    800017e4:	88848493          	addi	s1,s1,-1912 # 80009068 <wait_lock>
    800017e8:	8526                	mv	a0,s1
    800017ea:	00005097          	auipc	ra,0x5
    800017ee:	8e8080e7          	jalr	-1816(ra) # 800060d2 <acquire>
  reparent(p);
    800017f2:	854e                	mv	a0,s3
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	f1a080e7          	jalr	-230(ra) # 8000170e <reparent>
  wakeup(p->parent);
    800017fc:	0389b503          	ld	a0,56(s3)
    80001800:	00000097          	auipc	ra,0x0
    80001804:	e98080e7          	jalr	-360(ra) # 80001698 <wakeup>
  acquire(&p->lock);
    80001808:	854e                	mv	a0,s3
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	8c8080e7          	jalr	-1848(ra) # 800060d2 <acquire>
  p->xstate = status;
    80001812:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001816:	4795                	li	a5,5
    80001818:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000181c:	8526                	mv	a0,s1
    8000181e:	00005097          	auipc	ra,0x5
    80001822:	968080e7          	jalr	-1688(ra) # 80006186 <release>
  sched();
    80001826:	00000097          	auipc	ra,0x0
    8000182a:	bd4080e7          	jalr	-1068(ra) # 800013fa <sched>
  panic("zombie exit");
    8000182e:	00007517          	auipc	a0,0x7
    80001832:	9c250513          	addi	a0,a0,-1598 # 800081f0 <etext+0x1f0>
    80001836:	00004097          	auipc	ra,0x4
    8000183a:	352080e7          	jalr	850(ra) # 80005b88 <panic>

000000008000183e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000183e:	7179                	addi	sp,sp,-48
    80001840:	f406                	sd	ra,40(sp)
    80001842:	f022                	sd	s0,32(sp)
    80001844:	ec26                	sd	s1,24(sp)
    80001846:	e84a                	sd	s2,16(sp)
    80001848:	e44e                	sd	s3,8(sp)
    8000184a:	1800                	addi	s0,sp,48
    8000184c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000184e:	00008497          	auipc	s1,0x8
    80001852:	c3248493          	addi	s1,s1,-974 # 80009480 <proc>
    80001856:	0000e997          	auipc	s3,0xe
    8000185a:	82a98993          	addi	s3,s3,-2006 # 8000f080 <tickslock>
    acquire(&p->lock);
    8000185e:	8526                	mv	a0,s1
    80001860:	00005097          	auipc	ra,0x5
    80001864:	872080e7          	jalr	-1934(ra) # 800060d2 <acquire>
    if(p->pid == pid){
    80001868:	589c                	lw	a5,48(s1)
    8000186a:	01278d63          	beq	a5,s2,80001884 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000186e:	8526                	mv	a0,s1
    80001870:	00005097          	auipc	ra,0x5
    80001874:	916080e7          	jalr	-1770(ra) # 80006186 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001878:	17048493          	addi	s1,s1,368
    8000187c:	ff3491e3          	bne	s1,s3,8000185e <kill+0x20>
  }
  return -1;
    80001880:	557d                	li	a0,-1
    80001882:	a829                	j	8000189c <kill+0x5e>
      p->killed = 1;
    80001884:	4785                	li	a5,1
    80001886:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001888:	4c98                	lw	a4,24(s1)
    8000188a:	4789                	li	a5,2
    8000188c:	00f70f63          	beq	a4,a5,800018aa <kill+0x6c>
      release(&p->lock);
    80001890:	8526                	mv	a0,s1
    80001892:	00005097          	auipc	ra,0x5
    80001896:	8f4080e7          	jalr	-1804(ra) # 80006186 <release>
      return 0;
    8000189a:	4501                	li	a0,0
}
    8000189c:	70a2                	ld	ra,40(sp)
    8000189e:	7402                	ld	s0,32(sp)
    800018a0:	64e2                	ld	s1,24(sp)
    800018a2:	6942                	ld	s2,16(sp)
    800018a4:	69a2                	ld	s3,8(sp)
    800018a6:	6145                	addi	sp,sp,48
    800018a8:	8082                	ret
        p->state = RUNNABLE;
    800018aa:	478d                	li	a5,3
    800018ac:	cc9c                	sw	a5,24(s1)
    800018ae:	b7cd                	j	80001890 <kill+0x52>

00000000800018b0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b0:	7179                	addi	sp,sp,-48
    800018b2:	f406                	sd	ra,40(sp)
    800018b4:	f022                	sd	s0,32(sp)
    800018b6:	ec26                	sd	s1,24(sp)
    800018b8:	e84a                	sd	s2,16(sp)
    800018ba:	e44e                	sd	s3,8(sp)
    800018bc:	e052                	sd	s4,0(sp)
    800018be:	1800                	addi	s0,sp,48
    800018c0:	84aa                	mv	s1,a0
    800018c2:	892e                	mv	s2,a1
    800018c4:	89b2                	mv	s3,a2
    800018c6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	580080e7          	jalr	1408(ra) # 80000e48 <myproc>
  if(user_dst){
    800018d0:	c08d                	beqz	s1,800018f2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018d2:	86d2                	mv	a3,s4
    800018d4:	864e                	mv	a2,s3
    800018d6:	85ca                	mv	a1,s2
    800018d8:	6928                	ld	a0,80(a0)
    800018da:	fffff097          	auipc	ra,0xfffff
    800018de:	230080e7          	jalr	560(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018e2:	70a2                	ld	ra,40(sp)
    800018e4:	7402                	ld	s0,32(sp)
    800018e6:	64e2                	ld	s1,24(sp)
    800018e8:	6942                	ld	s2,16(sp)
    800018ea:	69a2                	ld	s3,8(sp)
    800018ec:	6a02                	ld	s4,0(sp)
    800018ee:	6145                	addi	sp,sp,48
    800018f0:	8082                	ret
    memmove((char *)dst, src, len);
    800018f2:	000a061b          	sext.w	a2,s4
    800018f6:	85ce                	mv	a1,s3
    800018f8:	854a                	mv	a0,s2
    800018fa:	fffff097          	auipc	ra,0xfffff
    800018fe:	8de080e7          	jalr	-1826(ra) # 800001d8 <memmove>
    return 0;
    80001902:	8526                	mv	a0,s1
    80001904:	bff9                	j	800018e2 <either_copyout+0x32>

0000000080001906 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001906:	7179                	addi	sp,sp,-48
    80001908:	f406                	sd	ra,40(sp)
    8000190a:	f022                	sd	s0,32(sp)
    8000190c:	ec26                	sd	s1,24(sp)
    8000190e:	e84a                	sd	s2,16(sp)
    80001910:	e44e                	sd	s3,8(sp)
    80001912:	e052                	sd	s4,0(sp)
    80001914:	1800                	addi	s0,sp,48
    80001916:	892a                	mv	s2,a0
    80001918:	84ae                	mv	s1,a1
    8000191a:	89b2                	mv	s3,a2
    8000191c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191e:	fffff097          	auipc	ra,0xfffff
    80001922:	52a080e7          	jalr	1322(ra) # 80000e48 <myproc>
  if(user_src){
    80001926:	c08d                	beqz	s1,80001948 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001928:	86d2                	mv	a3,s4
    8000192a:	864e                	mv	a2,s3
    8000192c:	85ca                	mv	a1,s2
    8000192e:	6928                	ld	a0,80(a0)
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	266080e7          	jalr	614(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001938:	70a2                	ld	ra,40(sp)
    8000193a:	7402                	ld	s0,32(sp)
    8000193c:	64e2                	ld	s1,24(sp)
    8000193e:	6942                	ld	s2,16(sp)
    80001940:	69a2                	ld	s3,8(sp)
    80001942:	6a02                	ld	s4,0(sp)
    80001944:	6145                	addi	sp,sp,48
    80001946:	8082                	ret
    memmove(dst, (char*)src, len);
    80001948:	000a061b          	sext.w	a2,s4
    8000194c:	85ce                	mv	a1,s3
    8000194e:	854a                	mv	a0,s2
    80001950:	fffff097          	auipc	ra,0xfffff
    80001954:	888080e7          	jalr	-1912(ra) # 800001d8 <memmove>
    return 0;
    80001958:	8526                	mv	a0,s1
    8000195a:	bff9                	j	80001938 <either_copyin+0x32>

000000008000195c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000195c:	715d                	addi	sp,sp,-80
    8000195e:	e486                	sd	ra,72(sp)
    80001960:	e0a2                	sd	s0,64(sp)
    80001962:	fc26                	sd	s1,56(sp)
    80001964:	f84a                	sd	s2,48(sp)
    80001966:	f44e                	sd	s3,40(sp)
    80001968:	f052                	sd	s4,32(sp)
    8000196a:	ec56                	sd	s5,24(sp)
    8000196c:	e85a                	sd	s6,16(sp)
    8000196e:	e45e                	sd	s7,8(sp)
    80001970:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001972:	00006517          	auipc	a0,0x6
    80001976:	6d650513          	addi	a0,a0,1750 # 80008048 <etext+0x48>
    8000197a:	00004097          	auipc	ra,0x4
    8000197e:	258080e7          	jalr	600(ra) # 80005bd2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001982:	00008497          	auipc	s1,0x8
    80001986:	c5648493          	addi	s1,s1,-938 # 800095d8 <proc+0x158>
    8000198a:	0000e917          	auipc	s2,0xe
    8000198e:	84e90913          	addi	s2,s2,-1970 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001992:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001994:	00007997          	auipc	s3,0x7
    80001998:	86c98993          	addi	s3,s3,-1940 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    8000199c:	00007a97          	auipc	s5,0x7
    800019a0:	86ca8a93          	addi	s5,s5,-1940 # 80008208 <etext+0x208>
    printf("\n");
    800019a4:	00006a17          	auipc	s4,0x6
    800019a8:	6a4a0a13          	addi	s4,s4,1700 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ac:	00007b97          	auipc	s7,0x7
    800019b0:	894b8b93          	addi	s7,s7,-1900 # 80008240 <states.1710>
    800019b4:	a00d                	j	800019d6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019b6:	ed86a583          	lw	a1,-296(a3)
    800019ba:	8556                	mv	a0,s5
    800019bc:	00004097          	auipc	ra,0x4
    800019c0:	216080e7          	jalr	534(ra) # 80005bd2 <printf>
    printf("\n");
    800019c4:	8552                	mv	a0,s4
    800019c6:	00004097          	auipc	ra,0x4
    800019ca:	20c080e7          	jalr	524(ra) # 80005bd2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ce:	17048493          	addi	s1,s1,368
    800019d2:	03248163          	beq	s1,s2,800019f4 <procdump+0x98>
    if(p->state == UNUSED)
    800019d6:	86a6                	mv	a3,s1
    800019d8:	ec04a783          	lw	a5,-320(s1)
    800019dc:	dbed                	beqz	a5,800019ce <procdump+0x72>
      state = "???";
    800019de:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e0:	fcfb6be3          	bltu	s6,a5,800019b6 <procdump+0x5a>
    800019e4:	1782                	slli	a5,a5,0x20
    800019e6:	9381                	srli	a5,a5,0x20
    800019e8:	078e                	slli	a5,a5,0x3
    800019ea:	97de                	add	a5,a5,s7
    800019ec:	6390                	ld	a2,0(a5)
    800019ee:	f661                	bnez	a2,800019b6 <procdump+0x5a>
      state = "???";
    800019f0:	864e                	mv	a2,s3
    800019f2:	b7d1                	j	800019b6 <procdump+0x5a>
  }
}
    800019f4:	60a6                	ld	ra,72(sp)
    800019f6:	6406                	ld	s0,64(sp)
    800019f8:	74e2                	ld	s1,56(sp)
    800019fa:	7942                	ld	s2,48(sp)
    800019fc:	79a2                	ld	s3,40(sp)
    800019fe:	7a02                	ld	s4,32(sp)
    80001a00:	6ae2                	ld	s5,24(sp)
    80001a02:	6b42                	ld	s6,16(sp)
    80001a04:	6ba2                	ld	s7,8(sp)
    80001a06:	6161                	addi	sp,sp,80
    80001a08:	8082                	ret

0000000080001a0a <swtch>:
    80001a0a:	00153023          	sd	ra,0(a0)
    80001a0e:	00253423          	sd	sp,8(a0)
    80001a12:	e900                	sd	s0,16(a0)
    80001a14:	ed04                	sd	s1,24(a0)
    80001a16:	03253023          	sd	s2,32(a0)
    80001a1a:	03353423          	sd	s3,40(a0)
    80001a1e:	03453823          	sd	s4,48(a0)
    80001a22:	03553c23          	sd	s5,56(a0)
    80001a26:	05653023          	sd	s6,64(a0)
    80001a2a:	05753423          	sd	s7,72(a0)
    80001a2e:	05853823          	sd	s8,80(a0)
    80001a32:	05953c23          	sd	s9,88(a0)
    80001a36:	07a53023          	sd	s10,96(a0)
    80001a3a:	07b53423          	sd	s11,104(a0)
    80001a3e:	0005b083          	ld	ra,0(a1)
    80001a42:	0085b103          	ld	sp,8(a1)
    80001a46:	6980                	ld	s0,16(a1)
    80001a48:	6d84                	ld	s1,24(a1)
    80001a4a:	0205b903          	ld	s2,32(a1)
    80001a4e:	0285b983          	ld	s3,40(a1)
    80001a52:	0305ba03          	ld	s4,48(a1)
    80001a56:	0385ba83          	ld	s5,56(a1)
    80001a5a:	0405bb03          	ld	s6,64(a1)
    80001a5e:	0485bb83          	ld	s7,72(a1)
    80001a62:	0505bc03          	ld	s8,80(a1)
    80001a66:	0585bc83          	ld	s9,88(a1)
    80001a6a:	0605bd03          	ld	s10,96(a1)
    80001a6e:	0685bd83          	ld	s11,104(a1)
    80001a72:	8082                	ret

0000000080001a74 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a74:	1141                	addi	sp,sp,-16
    80001a76:	e406                	sd	ra,8(sp)
    80001a78:	e022                	sd	s0,0(sp)
    80001a7a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a7c:	00006597          	auipc	a1,0x6
    80001a80:	7f458593          	addi	a1,a1,2036 # 80008270 <states.1710+0x30>
    80001a84:	0000d517          	auipc	a0,0xd
    80001a88:	5fc50513          	addi	a0,a0,1532 # 8000f080 <tickslock>
    80001a8c:	00004097          	auipc	ra,0x4
    80001a90:	5b6080e7          	jalr	1462(ra) # 80006042 <initlock>
}
    80001a94:	60a2                	ld	ra,8(sp)
    80001a96:	6402                	ld	s0,0(sp)
    80001a98:	0141                	addi	sp,sp,16
    80001a9a:	8082                	ret

0000000080001a9c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a9c:	1141                	addi	sp,sp,-16
    80001a9e:	e422                	sd	s0,8(sp)
    80001aa0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa2:	00003797          	auipc	a5,0x3
    80001aa6:	4ee78793          	addi	a5,a5,1262 # 80004f90 <kernelvec>
    80001aaa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aae:	6422                	ld	s0,8(sp)
    80001ab0:	0141                	addi	sp,sp,16
    80001ab2:	8082                	ret

0000000080001ab4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ab4:	1141                	addi	sp,sp,-16
    80001ab6:	e406                	sd	ra,8(sp)
    80001ab8:	e022                	sd	s0,0(sp)
    80001aba:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	38c080e7          	jalr	908(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aca:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ace:	00005617          	auipc	a2,0x5
    80001ad2:	53260613          	addi	a2,a2,1330 # 80007000 <_trampoline>
    80001ad6:	00005697          	auipc	a3,0x5
    80001ada:	52a68693          	addi	a3,a3,1322 # 80007000 <_trampoline>
    80001ade:	8e91                	sub	a3,a3,a2
    80001ae0:	040007b7          	lui	a5,0x4000
    80001ae4:	17fd                	addi	a5,a5,-1
    80001ae6:	07b2                	slli	a5,a5,0xc
    80001ae8:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aea:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001aee:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af0:	180026f3          	csrr	a3,satp
    80001af4:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001af6:	6d38                	ld	a4,88(a0)
    80001af8:	6134                	ld	a3,64(a0)
    80001afa:	6585                	lui	a1,0x1
    80001afc:	96ae                	add	a3,a3,a1
    80001afe:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b00:	6d38                	ld	a4,88(a0)
    80001b02:	00000697          	auipc	a3,0x0
    80001b06:	13868693          	addi	a3,a3,312 # 80001c3a <usertrap>
    80001b0a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b0c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b0e:	8692                	mv	a3,tp
    80001b10:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b12:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b16:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b1a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b22:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b24:	6f18                	ld	a4,24(a4)
    80001b26:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b2a:	692c                	ld	a1,80(a0)
    80001b2c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b2e:	00005717          	auipc	a4,0x5
    80001b32:	56270713          	addi	a4,a4,1378 # 80007090 <userret>
    80001b36:	8f11                	sub	a4,a4,a2
    80001b38:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b3a:	577d                	li	a4,-1
    80001b3c:	177e                	slli	a4,a4,0x3f
    80001b3e:	8dd9                	or	a1,a1,a4
    80001b40:	02000537          	lui	a0,0x2000
    80001b44:	157d                	addi	a0,a0,-1
    80001b46:	0536                	slli	a0,a0,0xd
    80001b48:	9782                	jalr	a5
}
    80001b4a:	60a2                	ld	ra,8(sp)
    80001b4c:	6402                	ld	s0,0(sp)
    80001b4e:	0141                	addi	sp,sp,16
    80001b50:	8082                	ret

0000000080001b52 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b52:	1101                	addi	sp,sp,-32
    80001b54:	ec06                	sd	ra,24(sp)
    80001b56:	e822                	sd	s0,16(sp)
    80001b58:	e426                	sd	s1,8(sp)
    80001b5a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b5c:	0000d497          	auipc	s1,0xd
    80001b60:	52448493          	addi	s1,s1,1316 # 8000f080 <tickslock>
    80001b64:	8526                	mv	a0,s1
    80001b66:	00004097          	auipc	ra,0x4
    80001b6a:	56c080e7          	jalr	1388(ra) # 800060d2 <acquire>
  ticks++;
    80001b6e:	00007517          	auipc	a0,0x7
    80001b72:	4aa50513          	addi	a0,a0,1194 # 80009018 <ticks>
    80001b76:	411c                	lw	a5,0(a0)
    80001b78:	2785                	addiw	a5,a5,1
    80001b7a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b7c:	00000097          	auipc	ra,0x0
    80001b80:	b1c080e7          	jalr	-1252(ra) # 80001698 <wakeup>
  release(&tickslock);
    80001b84:	8526                	mv	a0,s1
    80001b86:	00004097          	auipc	ra,0x4
    80001b8a:	600080e7          	jalr	1536(ra) # 80006186 <release>
}
    80001b8e:	60e2                	ld	ra,24(sp)
    80001b90:	6442                	ld	s0,16(sp)
    80001b92:	64a2                	ld	s1,8(sp)
    80001b94:	6105                	addi	sp,sp,32
    80001b96:	8082                	ret

0000000080001b98 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b98:	1101                	addi	sp,sp,-32
    80001b9a:	ec06                	sd	ra,24(sp)
    80001b9c:	e822                	sd	s0,16(sp)
    80001b9e:	e426                	sd	s1,8(sp)
    80001ba0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001ba6:	00074d63          	bltz	a4,80001bc0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001baa:	57fd                	li	a5,-1
    80001bac:	17fe                	slli	a5,a5,0x3f
    80001bae:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb2:	06f70363          	beq	a4,a5,80001c18 <devintr+0x80>
  }
}
    80001bb6:	60e2                	ld	ra,24(sp)
    80001bb8:	6442                	ld	s0,16(sp)
    80001bba:	64a2                	ld	s1,8(sp)
    80001bbc:	6105                	addi	sp,sp,32
    80001bbe:	8082                	ret
     (scause & 0xff) == 9){
    80001bc0:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bc4:	46a5                	li	a3,9
    80001bc6:	fed792e3          	bne	a5,a3,80001baa <devintr+0x12>
    int irq = plic_claim();
    80001bca:	00003097          	auipc	ra,0x3
    80001bce:	4ce080e7          	jalr	1230(ra) # 80005098 <plic_claim>
    80001bd2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bd4:	47a9                	li	a5,10
    80001bd6:	02f50763          	beq	a0,a5,80001c04 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bda:	4785                	li	a5,1
    80001bdc:	02f50963          	beq	a0,a5,80001c0e <devintr+0x76>
    return 1;
    80001be0:	4505                	li	a0,1
    } else if(irq){
    80001be2:	d8f1                	beqz	s1,80001bb6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001be4:	85a6                	mv	a1,s1
    80001be6:	00006517          	auipc	a0,0x6
    80001bea:	69250513          	addi	a0,a0,1682 # 80008278 <states.1710+0x38>
    80001bee:	00004097          	auipc	ra,0x4
    80001bf2:	fe4080e7          	jalr	-28(ra) # 80005bd2 <printf>
      plic_complete(irq);
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	00003097          	auipc	ra,0x3
    80001bfc:	4c4080e7          	jalr	1220(ra) # 800050bc <plic_complete>
    return 1;
    80001c00:	4505                	li	a0,1
    80001c02:	bf55                	j	80001bb6 <devintr+0x1e>
      uartintr();
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	3ee080e7          	jalr	1006(ra) # 80005ff2 <uartintr>
    80001c0c:	b7ed                	j	80001bf6 <devintr+0x5e>
      virtio_disk_intr();
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	98e080e7          	jalr	-1650(ra) # 8000559c <virtio_disk_intr>
    80001c16:	b7c5                	j	80001bf6 <devintr+0x5e>
    if(cpuid() == 0){
    80001c18:	fffff097          	auipc	ra,0xfffff
    80001c1c:	204080e7          	jalr	516(ra) # 80000e1c <cpuid>
    80001c20:	c901                	beqz	a0,80001c30 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c22:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c28:	14479073          	csrw	sip,a5
    return 2;
    80001c2c:	4509                	li	a0,2
    80001c2e:	b761                	j	80001bb6 <devintr+0x1e>
      clockintr();
    80001c30:	00000097          	auipc	ra,0x0
    80001c34:	f22080e7          	jalr	-222(ra) # 80001b52 <clockintr>
    80001c38:	b7ed                	j	80001c22 <devintr+0x8a>

0000000080001c3a <usertrap>:
{
    80001c3a:	1101                	addi	sp,sp,-32
    80001c3c:	ec06                	sd	ra,24(sp)
    80001c3e:	e822                	sd	s0,16(sp)
    80001c40:	e426                	sd	s1,8(sp)
    80001c42:	e04a                	sd	s2,0(sp)
    80001c44:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c46:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c4a:	1007f793          	andi	a5,a5,256
    80001c4e:	e3ad                	bnez	a5,80001cb0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c50:	00003797          	auipc	a5,0x3
    80001c54:	34078793          	addi	a5,a5,832 # 80004f90 <kernelvec>
    80001c58:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	1ec080e7          	jalr	492(ra) # 80000e48 <myproc>
    80001c64:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c66:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c68:	14102773          	csrr	a4,sepc
    80001c6c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c72:	47a1                	li	a5,8
    80001c74:	04f71c63          	bne	a4,a5,80001ccc <usertrap+0x92>
    if(p->killed)
    80001c78:	551c                	lw	a5,40(a0)
    80001c7a:	e3b9                	bnez	a5,80001cc0 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c7c:	6cb8                	ld	a4,88(s1)
    80001c7e:	6f1c                	ld	a5,24(a4)
    80001c80:	0791                	addi	a5,a5,4
    80001c82:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c8c:	10079073          	csrw	sstatus,a5
    syscall();
    80001c90:	00000097          	auipc	ra,0x0
    80001c94:	2e0080e7          	jalr	736(ra) # 80001f70 <syscall>
  if(p->killed)
    80001c98:	549c                	lw	a5,40(s1)
    80001c9a:	ebc1                	bnez	a5,80001d2a <usertrap+0xf0>
  usertrapret();
    80001c9c:	00000097          	auipc	ra,0x0
    80001ca0:	e18080e7          	jalr	-488(ra) # 80001ab4 <usertrapret>
}
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	64a2                	ld	s1,8(sp)
    80001caa:	6902                	ld	s2,0(sp)
    80001cac:	6105                	addi	sp,sp,32
    80001cae:	8082                	ret
    panic("usertrap: not from user mode");
    80001cb0:	00006517          	auipc	a0,0x6
    80001cb4:	5e850513          	addi	a0,a0,1512 # 80008298 <states.1710+0x58>
    80001cb8:	00004097          	auipc	ra,0x4
    80001cbc:	ed0080e7          	jalr	-304(ra) # 80005b88 <panic>
      exit(-1);
    80001cc0:	557d                	li	a0,-1
    80001cc2:	00000097          	auipc	ra,0x0
    80001cc6:	aa6080e7          	jalr	-1370(ra) # 80001768 <exit>
    80001cca:	bf4d                	j	80001c7c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	ecc080e7          	jalr	-308(ra) # 80001b98 <devintr>
    80001cd4:	892a                	mv	s2,a0
    80001cd6:	c501                	beqz	a0,80001cde <usertrap+0xa4>
  if(p->killed)
    80001cd8:	549c                	lw	a5,40(s1)
    80001cda:	c3a1                	beqz	a5,80001d1a <usertrap+0xe0>
    80001cdc:	a815                	j	80001d10 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cde:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ce2:	5890                	lw	a2,48(s1)
    80001ce4:	00006517          	auipc	a0,0x6
    80001ce8:	5d450513          	addi	a0,a0,1492 # 800082b8 <states.1710+0x78>
    80001cec:	00004097          	auipc	ra,0x4
    80001cf0:	ee6080e7          	jalr	-282(ra) # 80005bd2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cf4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cfc:	00006517          	auipc	a0,0x6
    80001d00:	5ec50513          	addi	a0,a0,1516 # 800082e8 <states.1710+0xa8>
    80001d04:	00004097          	auipc	ra,0x4
    80001d08:	ece080e7          	jalr	-306(ra) # 80005bd2 <printf>
    p->killed = 1;
    80001d0c:	4785                	li	a5,1
    80001d0e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d10:	557d                	li	a0,-1
    80001d12:	00000097          	auipc	ra,0x0
    80001d16:	a56080e7          	jalr	-1450(ra) # 80001768 <exit>
  if(which_dev == 2)
    80001d1a:	4789                	li	a5,2
    80001d1c:	f8f910e3          	bne	s2,a5,80001c9c <usertrap+0x62>
    yield();
    80001d20:	fffff097          	auipc	ra,0xfffff
    80001d24:	7b0080e7          	jalr	1968(ra) # 800014d0 <yield>
    80001d28:	bf95                	j	80001c9c <usertrap+0x62>
  int which_dev = 0;
    80001d2a:	4901                	li	s2,0
    80001d2c:	b7d5                	j	80001d10 <usertrap+0xd6>

0000000080001d2e <kerneltrap>:
{
    80001d2e:	7179                	addi	sp,sp,-48
    80001d30:	f406                	sd	ra,40(sp)
    80001d32:	f022                	sd	s0,32(sp)
    80001d34:	ec26                	sd	s1,24(sp)
    80001d36:	e84a                	sd	s2,16(sp)
    80001d38:	e44e                	sd	s3,8(sp)
    80001d3a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d40:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d44:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d48:	1004f793          	andi	a5,s1,256
    80001d4c:	cb85                	beqz	a5,80001d7c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d52:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d54:	ef85                	bnez	a5,80001d8c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	e42080e7          	jalr	-446(ra) # 80001b98 <devintr>
    80001d5e:	cd1d                	beqz	a0,80001d9c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d60:	4789                	li	a5,2
    80001d62:	06f50a63          	beq	a0,a5,80001dd6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d66:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d6a:	10049073          	csrw	sstatus,s1
}
    80001d6e:	70a2                	ld	ra,40(sp)
    80001d70:	7402                	ld	s0,32(sp)
    80001d72:	64e2                	ld	s1,24(sp)
    80001d74:	6942                	ld	s2,16(sp)
    80001d76:	69a2                	ld	s3,8(sp)
    80001d78:	6145                	addi	sp,sp,48
    80001d7a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d7c:	00006517          	auipc	a0,0x6
    80001d80:	58c50513          	addi	a0,a0,1420 # 80008308 <states.1710+0xc8>
    80001d84:	00004097          	auipc	ra,0x4
    80001d88:	e04080e7          	jalr	-508(ra) # 80005b88 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d8c:	00006517          	auipc	a0,0x6
    80001d90:	5a450513          	addi	a0,a0,1444 # 80008330 <states.1710+0xf0>
    80001d94:	00004097          	auipc	ra,0x4
    80001d98:	df4080e7          	jalr	-524(ra) # 80005b88 <panic>
    printf("scause %p\n", scause);
    80001d9c:	85ce                	mv	a1,s3
    80001d9e:	00006517          	auipc	a0,0x6
    80001da2:	5b250513          	addi	a0,a0,1458 # 80008350 <states.1710+0x110>
    80001da6:	00004097          	auipc	ra,0x4
    80001daa:	e2c080e7          	jalr	-468(ra) # 80005bd2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dae:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001db6:	00006517          	auipc	a0,0x6
    80001dba:	5aa50513          	addi	a0,a0,1450 # 80008360 <states.1710+0x120>
    80001dbe:	00004097          	auipc	ra,0x4
    80001dc2:	e14080e7          	jalr	-492(ra) # 80005bd2 <printf>
    panic("kerneltrap");
    80001dc6:	00006517          	auipc	a0,0x6
    80001dca:	5b250513          	addi	a0,a0,1458 # 80008378 <states.1710+0x138>
    80001dce:	00004097          	auipc	ra,0x4
    80001dd2:	dba080e7          	jalr	-582(ra) # 80005b88 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd6:	fffff097          	auipc	ra,0xfffff
    80001dda:	072080e7          	jalr	114(ra) # 80000e48 <myproc>
    80001dde:	d541                	beqz	a0,80001d66 <kerneltrap+0x38>
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	068080e7          	jalr	104(ra) # 80000e48 <myproc>
    80001de8:	4d18                	lw	a4,24(a0)
    80001dea:	4791                	li	a5,4
    80001dec:	f6f71de3          	bne	a4,a5,80001d66 <kerneltrap+0x38>
    yield();
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	6e0080e7          	jalr	1760(ra) # 800014d0 <yield>
    80001df8:	b7bd                	j	80001d66 <kerneltrap+0x38>

0000000080001dfa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001dfa:	1101                	addi	sp,sp,-32
    80001dfc:	ec06                	sd	ra,24(sp)
    80001dfe:	e822                	sd	s0,16(sp)
    80001e00:	e426                	sd	s1,8(sp)
    80001e02:	1000                	addi	s0,sp,32
    80001e04:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e06:	fffff097          	auipc	ra,0xfffff
    80001e0a:	042080e7          	jalr	66(ra) # 80000e48 <myproc>
  switch (n) {
    80001e0e:	4795                	li	a5,5
    80001e10:	0497e163          	bltu	a5,s1,80001e52 <argraw+0x58>
    80001e14:	048a                	slli	s1,s1,0x2
    80001e16:	00006717          	auipc	a4,0x6
    80001e1a:	65a70713          	addi	a4,a4,1626 # 80008470 <states.1710+0x230>
    80001e1e:	94ba                	add	s1,s1,a4
    80001e20:	409c                	lw	a5,0(s1)
    80001e22:	97ba                	add	a5,a5,a4
    80001e24:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e26:	6d3c                	ld	a5,88(a0)
    80001e28:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e2a:	60e2                	ld	ra,24(sp)
    80001e2c:	6442                	ld	s0,16(sp)
    80001e2e:	64a2                	ld	s1,8(sp)
    80001e30:	6105                	addi	sp,sp,32
    80001e32:	8082                	ret
    return p->trapframe->a1;
    80001e34:	6d3c                	ld	a5,88(a0)
    80001e36:	7fa8                	ld	a0,120(a5)
    80001e38:	bfcd                	j	80001e2a <argraw+0x30>
    return p->trapframe->a2;
    80001e3a:	6d3c                	ld	a5,88(a0)
    80001e3c:	63c8                	ld	a0,128(a5)
    80001e3e:	b7f5                	j	80001e2a <argraw+0x30>
    return p->trapframe->a3;
    80001e40:	6d3c                	ld	a5,88(a0)
    80001e42:	67c8                	ld	a0,136(a5)
    80001e44:	b7dd                	j	80001e2a <argraw+0x30>
    return p->trapframe->a4;
    80001e46:	6d3c                	ld	a5,88(a0)
    80001e48:	6bc8                	ld	a0,144(a5)
    80001e4a:	b7c5                	j	80001e2a <argraw+0x30>
    return p->trapframe->a5;
    80001e4c:	6d3c                	ld	a5,88(a0)
    80001e4e:	6fc8                	ld	a0,152(a5)
    80001e50:	bfe9                	j	80001e2a <argraw+0x30>
  panic("argraw");
    80001e52:	00006517          	auipc	a0,0x6
    80001e56:	53650513          	addi	a0,a0,1334 # 80008388 <states.1710+0x148>
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	d2e080e7          	jalr	-722(ra) # 80005b88 <panic>

0000000080001e62 <fetchaddr>:
{
    80001e62:	1101                	addi	sp,sp,-32
    80001e64:	ec06                	sd	ra,24(sp)
    80001e66:	e822                	sd	s0,16(sp)
    80001e68:	e426                	sd	s1,8(sp)
    80001e6a:	e04a                	sd	s2,0(sp)
    80001e6c:	1000                	addi	s0,sp,32
    80001e6e:	84aa                	mv	s1,a0
    80001e70:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	fd6080e7          	jalr	-42(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e7a:	653c                	ld	a5,72(a0)
    80001e7c:	02f4f863          	bgeu	s1,a5,80001eac <fetchaddr+0x4a>
    80001e80:	00848713          	addi	a4,s1,8
    80001e84:	02e7e663          	bltu	a5,a4,80001eb0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e88:	46a1                	li	a3,8
    80001e8a:	8626                	mv	a2,s1
    80001e8c:	85ca                	mv	a1,s2
    80001e8e:	6928                	ld	a0,80(a0)
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	d06080e7          	jalr	-762(ra) # 80000b96 <copyin>
    80001e98:	00a03533          	snez	a0,a0
    80001e9c:	40a00533          	neg	a0,a0
}
    80001ea0:	60e2                	ld	ra,24(sp)
    80001ea2:	6442                	ld	s0,16(sp)
    80001ea4:	64a2                	ld	s1,8(sp)
    80001ea6:	6902                	ld	s2,0(sp)
    80001ea8:	6105                	addi	sp,sp,32
    80001eaa:	8082                	ret
    return -1;
    80001eac:	557d                	li	a0,-1
    80001eae:	bfcd                	j	80001ea0 <fetchaddr+0x3e>
    80001eb0:	557d                	li	a0,-1
    80001eb2:	b7fd                	j	80001ea0 <fetchaddr+0x3e>

0000000080001eb4 <fetchstr>:
{
    80001eb4:	7179                	addi	sp,sp,-48
    80001eb6:	f406                	sd	ra,40(sp)
    80001eb8:	f022                	sd	s0,32(sp)
    80001eba:	ec26                	sd	s1,24(sp)
    80001ebc:	e84a                	sd	s2,16(sp)
    80001ebe:	e44e                	sd	s3,8(sp)
    80001ec0:	1800                	addi	s0,sp,48
    80001ec2:	892a                	mv	s2,a0
    80001ec4:	84ae                	mv	s1,a1
    80001ec6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	f80080e7          	jalr	-128(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ed0:	86ce                	mv	a3,s3
    80001ed2:	864a                	mv	a2,s2
    80001ed4:	85a6                	mv	a1,s1
    80001ed6:	6928                	ld	a0,80(a0)
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	d4a080e7          	jalr	-694(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ee0:	00054763          	bltz	a0,80001eee <fetchstr+0x3a>
  return strlen(buf);
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	ffffe097          	auipc	ra,0xffffe
    80001eea:	416080e7          	jalr	1046(ra) # 800002fc <strlen>
}
    80001eee:	70a2                	ld	ra,40(sp)
    80001ef0:	7402                	ld	s0,32(sp)
    80001ef2:	64e2                	ld	s1,24(sp)
    80001ef4:	6942                	ld	s2,16(sp)
    80001ef6:	69a2                	ld	s3,8(sp)
    80001ef8:	6145                	addi	sp,sp,48
    80001efa:	8082                	ret

0000000080001efc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001efc:	1101                	addi	sp,sp,-32
    80001efe:	ec06                	sd	ra,24(sp)
    80001f00:	e822                	sd	s0,16(sp)
    80001f02:	e426                	sd	s1,8(sp)
    80001f04:	1000                	addi	s0,sp,32
    80001f06:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f08:	00000097          	auipc	ra,0x0
    80001f0c:	ef2080e7          	jalr	-270(ra) # 80001dfa <argraw>
    80001f10:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f12:	4501                	li	a0,0
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6105                	addi	sp,sp,32
    80001f1c:	8082                	ret

0000000080001f1e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f1e:	1101                	addi	sp,sp,-32
    80001f20:	ec06                	sd	ra,24(sp)
    80001f22:	e822                	sd	s0,16(sp)
    80001f24:	e426                	sd	s1,8(sp)
    80001f26:	1000                	addi	s0,sp,32
    80001f28:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	ed0080e7          	jalr	-304(ra) # 80001dfa <argraw>
    80001f32:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f34:	4501                	li	a0,0
    80001f36:	60e2                	ld	ra,24(sp)
    80001f38:	6442                	ld	s0,16(sp)
    80001f3a:	64a2                	ld	s1,8(sp)
    80001f3c:	6105                	addi	sp,sp,32
    80001f3e:	8082                	ret

0000000080001f40 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f40:	1101                	addi	sp,sp,-32
    80001f42:	ec06                	sd	ra,24(sp)
    80001f44:	e822                	sd	s0,16(sp)
    80001f46:	e426                	sd	s1,8(sp)
    80001f48:	e04a                	sd	s2,0(sp)
    80001f4a:	1000                	addi	s0,sp,32
    80001f4c:	84ae                	mv	s1,a1
    80001f4e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	eaa080e7          	jalr	-342(ra) # 80001dfa <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f58:	864a                	mv	a2,s2
    80001f5a:	85a6                	mv	a1,s1
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	f58080e7          	jalr	-168(ra) # 80001eb4 <fetchstr>
}
    80001f64:	60e2                	ld	ra,24(sp)
    80001f66:	6442                	ld	s0,16(sp)
    80001f68:	64a2                	ld	s1,8(sp)
    80001f6a:	6902                	ld	s2,0(sp)
    80001f6c:	6105                	addi	sp,sp,32
    80001f6e:	8082                	ret

0000000080001f70 <syscall>:

static char *syscall_names[]={"", "fork", "exit", "wait", "pipe", "read", "kill", "exec","fstat", "chdir", "dup", "getpid", "sbrk", "sleep", "uptime","open", "write", "mknod", "unlink", "link", "mkdir", "close","trace"};
  
void
syscall(void)
{
    80001f70:	7179                	addi	sp,sp,-48
    80001f72:	f406                	sd	ra,40(sp)
    80001f74:	f022                	sd	s0,32(sp)
    80001f76:	ec26                	sd	s1,24(sp)
    80001f78:	e84a                	sd	s2,16(sp)
    80001f7a:	e44e                	sd	s3,8(sp)
    80001f7c:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	eca080e7          	jalr	-310(ra) # 80000e48 <myproc>
    80001f86:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f88:	05853903          	ld	s2,88(a0)
    80001f8c:	0a893783          	ld	a5,168(s2)
    80001f90:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f94:	37fd                	addiw	a5,a5,-1
    80001f96:	4751                	li	a4,20
    80001f98:	04f76863          	bltu	a4,a5,80001fe8 <syscall+0x78>
    80001f9c:	00399713          	slli	a4,s3,0x3
    80001fa0:	00006797          	auipc	a5,0x6
    80001fa4:	4e878793          	addi	a5,a5,1256 # 80008488 <syscalls>
    80001fa8:	97ba                	add	a5,a5,a4
    80001faa:	639c                	ld	a5,0(a5)
    80001fac:	cf95                	beqz	a5,80001fe8 <syscall+0x78>
    p->trapframe->a0 = syscalls[num]();
    80001fae:	9782                	jalr	a5
    80001fb0:	06a93823          	sd	a0,112(s2)
    if(p->tracemask&(1<<num)){
    80001fb4:	1684a783          	lw	a5,360(s1)
    80001fb8:	4137d7bb          	sraw	a5,a5,s3
    80001fbc:	8b85                	andi	a5,a5,1
    80001fbe:	c7a1                	beqz	a5,80002006 <syscall+0x96>
    printf("%d: syscall %s -> %d\n",p->pid,syscall_names[num],p->trapframe->a0);
    80001fc0:	6cb8                	ld	a4,88(s1)
    80001fc2:	098e                	slli	s3,s3,0x3
    80001fc4:	00006797          	auipc	a5,0x6
    80001fc8:	4c478793          	addi	a5,a5,1220 # 80008488 <syscalls>
    80001fcc:	99be                	add	s3,s3,a5
    80001fce:	7b34                	ld	a3,112(a4)
    80001fd0:	0b09b603          	ld	a2,176(s3)
    80001fd4:	588c                	lw	a1,48(s1)
    80001fd6:	00006517          	auipc	a0,0x6
    80001fda:	3ba50513          	addi	a0,a0,954 # 80008390 <states.1710+0x150>
    80001fde:	00004097          	auipc	ra,0x4
    80001fe2:	bf4080e7          	jalr	-1036(ra) # 80005bd2 <printf>
    80001fe6:	a005                	j	80002006 <syscall+0x96>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fe8:	86ce                	mv	a3,s3
    80001fea:	15848613          	addi	a2,s1,344
    80001fee:	588c                	lw	a1,48(s1)
    80001ff0:	00006517          	auipc	a0,0x6
    80001ff4:	3b850513          	addi	a0,a0,952 # 800083a8 <states.1710+0x168>
    80001ff8:	00004097          	auipc	ra,0x4
    80001ffc:	bda080e7          	jalr	-1062(ra) # 80005bd2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002000:	6cbc                	ld	a5,88(s1)
    80002002:	577d                	li	a4,-1
    80002004:	fbb8                	sd	a4,112(a5)
  }
}
    80002006:	70a2                	ld	ra,40(sp)
    80002008:	7402                	ld	s0,32(sp)
    8000200a:	64e2                	ld	s1,24(sp)
    8000200c:	6942                	ld	s2,16(sp)
    8000200e:	69a2                	ld	s3,8(sp)
    80002010:	6145                	addi	sp,sp,48
    80002012:	8082                	ret

0000000080002014 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002014:	1101                	addi	sp,sp,-32
    80002016:	ec06                	sd	ra,24(sp)
    80002018:	e822                	sd	s0,16(sp)
    8000201a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000201c:	fec40593          	addi	a1,s0,-20
    80002020:	4501                	li	a0,0
    80002022:	00000097          	auipc	ra,0x0
    80002026:	eda080e7          	jalr	-294(ra) # 80001efc <argint>
    return -1;
    8000202a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000202c:	00054963          	bltz	a0,8000203e <sys_exit+0x2a>
  exit(n);
    80002030:	fec42503          	lw	a0,-20(s0)
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	734080e7          	jalr	1844(ra) # 80001768 <exit>
  return 0;  // not reached
    8000203c:	4781                	li	a5,0
}
    8000203e:	853e                	mv	a0,a5
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	6105                	addi	sp,sp,32
    80002046:	8082                	ret

0000000080002048 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002048:	1141                	addi	sp,sp,-16
    8000204a:	e406                	sd	ra,8(sp)
    8000204c:	e022                	sd	s0,0(sp)
    8000204e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	df8080e7          	jalr	-520(ra) # 80000e48 <myproc>
}
    80002058:	5908                	lw	a0,48(a0)
    8000205a:	60a2                	ld	ra,8(sp)
    8000205c:	6402                	ld	s0,0(sp)
    8000205e:	0141                	addi	sp,sp,16
    80002060:	8082                	ret

0000000080002062 <sys_fork>:

uint64
sys_fork(void)
{
    80002062:	1141                	addi	sp,sp,-16
    80002064:	e406                	sd	ra,8(sp)
    80002066:	e022                	sd	s0,0(sp)
    80002068:	0800                	addi	s0,sp,16
  return fork();
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	1ac080e7          	jalr	428(ra) # 80001216 <fork>
}
    80002072:	60a2                	ld	ra,8(sp)
    80002074:	6402                	ld	s0,0(sp)
    80002076:	0141                	addi	sp,sp,16
    80002078:	8082                	ret

000000008000207a <sys_wait>:

uint64
sys_wait(void)
{
    8000207a:	1101                	addi	sp,sp,-32
    8000207c:	ec06                	sd	ra,24(sp)
    8000207e:	e822                	sd	s0,16(sp)
    80002080:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002082:	fe840593          	addi	a1,s0,-24
    80002086:	4501                	li	a0,0
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	e96080e7          	jalr	-362(ra) # 80001f1e <argaddr>
    80002090:	87aa                	mv	a5,a0
    return -1;
    80002092:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002094:	0007c863          	bltz	a5,800020a4 <sys_wait+0x2a>
  return wait(p);
    80002098:	fe843503          	ld	a0,-24(s0)
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	4d4080e7          	jalr	1236(ra) # 80001570 <wait>
}
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	6105                	addi	sp,sp,32
    800020aa:	8082                	ret

00000000800020ac <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020ac:	7179                	addi	sp,sp,-48
    800020ae:	f406                	sd	ra,40(sp)
    800020b0:	f022                	sd	s0,32(sp)
    800020b2:	ec26                	sd	s1,24(sp)
    800020b4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020b6:	fdc40593          	addi	a1,s0,-36
    800020ba:	4501                	li	a0,0
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	e40080e7          	jalr	-448(ra) # 80001efc <argint>
    800020c4:	87aa                	mv	a5,a0
    return -1;
    800020c6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020c8:	0207c063          	bltz	a5,800020e8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	d7c080e7          	jalr	-644(ra) # 80000e48 <myproc>
    800020d4:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020d6:	fdc42503          	lw	a0,-36(s0)
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	0c8080e7          	jalr	200(ra) # 800011a2 <growproc>
    800020e2:	00054863          	bltz	a0,800020f2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020e6:	8526                	mv	a0,s1
}
    800020e8:	70a2                	ld	ra,40(sp)
    800020ea:	7402                	ld	s0,32(sp)
    800020ec:	64e2                	ld	s1,24(sp)
    800020ee:	6145                	addi	sp,sp,48
    800020f0:	8082                	ret
    return -1;
    800020f2:	557d                	li	a0,-1
    800020f4:	bfd5                	j	800020e8 <sys_sbrk+0x3c>

00000000800020f6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020f6:	7139                	addi	sp,sp,-64
    800020f8:	fc06                	sd	ra,56(sp)
    800020fa:	f822                	sd	s0,48(sp)
    800020fc:	f426                	sd	s1,40(sp)
    800020fe:	f04a                	sd	s2,32(sp)
    80002100:	ec4e                	sd	s3,24(sp)
    80002102:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002104:	fcc40593          	addi	a1,s0,-52
    80002108:	4501                	li	a0,0
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	df2080e7          	jalr	-526(ra) # 80001efc <argint>
    return -1;
    80002112:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002114:	06054563          	bltz	a0,8000217e <sys_sleep+0x88>
  acquire(&tickslock);
    80002118:	0000d517          	auipc	a0,0xd
    8000211c:	f6850513          	addi	a0,a0,-152 # 8000f080 <tickslock>
    80002120:	00004097          	auipc	ra,0x4
    80002124:	fb2080e7          	jalr	-78(ra) # 800060d2 <acquire>
  ticks0 = ticks;
    80002128:	00007917          	auipc	s2,0x7
    8000212c:	ef092903          	lw	s2,-272(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002130:	fcc42783          	lw	a5,-52(s0)
    80002134:	cf85                	beqz	a5,8000216c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002136:	0000d997          	auipc	s3,0xd
    8000213a:	f4a98993          	addi	s3,s3,-182 # 8000f080 <tickslock>
    8000213e:	00007497          	auipc	s1,0x7
    80002142:	eda48493          	addi	s1,s1,-294 # 80009018 <ticks>
    if(myproc()->killed){
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	d02080e7          	jalr	-766(ra) # 80000e48 <myproc>
    8000214e:	551c                	lw	a5,40(a0)
    80002150:	ef9d                	bnez	a5,8000218e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002152:	85ce                	mv	a1,s3
    80002154:	8526                	mv	a0,s1
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	3b6080e7          	jalr	950(ra) # 8000150c <sleep>
  while(ticks - ticks0 < n){
    8000215e:	409c                	lw	a5,0(s1)
    80002160:	412787bb          	subw	a5,a5,s2
    80002164:	fcc42703          	lw	a4,-52(s0)
    80002168:	fce7efe3          	bltu	a5,a4,80002146 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000216c:	0000d517          	auipc	a0,0xd
    80002170:	f1450513          	addi	a0,a0,-236 # 8000f080 <tickslock>
    80002174:	00004097          	auipc	ra,0x4
    80002178:	012080e7          	jalr	18(ra) # 80006186 <release>
  return 0;
    8000217c:	4781                	li	a5,0
}
    8000217e:	853e                	mv	a0,a5
    80002180:	70e2                	ld	ra,56(sp)
    80002182:	7442                	ld	s0,48(sp)
    80002184:	74a2                	ld	s1,40(sp)
    80002186:	7902                	ld	s2,32(sp)
    80002188:	69e2                	ld	s3,24(sp)
    8000218a:	6121                	addi	sp,sp,64
    8000218c:	8082                	ret
      release(&tickslock);
    8000218e:	0000d517          	auipc	a0,0xd
    80002192:	ef250513          	addi	a0,a0,-270 # 8000f080 <tickslock>
    80002196:	00004097          	auipc	ra,0x4
    8000219a:	ff0080e7          	jalr	-16(ra) # 80006186 <release>
      return -1;
    8000219e:	57fd                	li	a5,-1
    800021a0:	bff9                	j	8000217e <sys_sleep+0x88>

00000000800021a2 <sys_kill>:

uint64
sys_kill(void)
{
    800021a2:	1101                	addi	sp,sp,-32
    800021a4:	ec06                	sd	ra,24(sp)
    800021a6:	e822                	sd	s0,16(sp)
    800021a8:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021aa:	fec40593          	addi	a1,s0,-20
    800021ae:	4501                	li	a0,0
    800021b0:	00000097          	auipc	ra,0x0
    800021b4:	d4c080e7          	jalr	-692(ra) # 80001efc <argint>
    800021b8:	87aa                	mv	a5,a0
    return -1;
    800021ba:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021bc:	0007c863          	bltz	a5,800021cc <sys_kill+0x2a>
  return kill(pid);
    800021c0:	fec42503          	lw	a0,-20(s0)
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	67a080e7          	jalr	1658(ra) # 8000183e <kill>
}
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	6105                	addi	sp,sp,32
    800021d2:	8082                	ret

00000000800021d4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021d4:	1101                	addi	sp,sp,-32
    800021d6:	ec06                	sd	ra,24(sp)
    800021d8:	e822                	sd	s0,16(sp)
    800021da:	e426                	sd	s1,8(sp)
    800021dc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021de:	0000d517          	auipc	a0,0xd
    800021e2:	ea250513          	addi	a0,a0,-350 # 8000f080 <tickslock>
    800021e6:	00004097          	auipc	ra,0x4
    800021ea:	eec080e7          	jalr	-276(ra) # 800060d2 <acquire>
  xticks = ticks;
    800021ee:	00007497          	auipc	s1,0x7
    800021f2:	e2a4a483          	lw	s1,-470(s1) # 80009018 <ticks>
  release(&tickslock);
    800021f6:	0000d517          	auipc	a0,0xd
    800021fa:	e8a50513          	addi	a0,a0,-374 # 8000f080 <tickslock>
    800021fe:	00004097          	auipc	ra,0x4
    80002202:	f88080e7          	jalr	-120(ra) # 80006186 <release>
  return xticks;
}
    80002206:	02049513          	slli	a0,s1,0x20
    8000220a:	9101                	srli	a0,a0,0x20
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	64a2                	ld	s1,8(sp)
    80002212:	6105                	addi	sp,sp,32
    80002214:	8082                	ret

0000000080002216 <sys_trace>:

uint64 sys_trace(void) {
    80002216:	1101                	addi	sp,sp,-32
    80002218:	ec06                	sd	ra,24(sp)
    8000221a:	e822                	sd	s0,16(sp)
    8000221c:	1000                	addi	s0,sp,32
    int mask;
    // 获取整数类型的系统调用参数
    argint(0, &mask);
    8000221e:	fec40593          	addi	a1,s0,-20
    80002222:	4501                	li	a0,0
    80002224:	00000097          	auipc	ra,0x0
    80002228:	cd8080e7          	jalr	-808(ra) # 80001efc <argint>
    // 存入proc 结构体的 mask 变量中
    myproc()->tracemask = mask;
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	c1c080e7          	jalr	-996(ra) # 80000e48 <myproc>
    80002234:	fec42783          	lw	a5,-20(s0)
    80002238:	16f52423          	sw	a5,360(a0)
    return 0;
}
    8000223c:	4501                	li	a0,0
    8000223e:	60e2                	ld	ra,24(sp)
    80002240:	6442                	ld	s0,16(sp)
    80002242:	6105                	addi	sp,sp,32
    80002244:	8082                	ret

0000000080002246 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002246:	7179                	addi	sp,sp,-48
    80002248:	f406                	sd	ra,40(sp)
    8000224a:	f022                	sd	s0,32(sp)
    8000224c:	ec26                	sd	s1,24(sp)
    8000224e:	e84a                	sd	s2,16(sp)
    80002250:	e44e                	sd	s3,8(sp)
    80002252:	e052                	sd	s4,0(sp)
    80002254:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002256:	00006597          	auipc	a1,0x6
    8000225a:	39a58593          	addi	a1,a1,922 # 800085f0 <syscall_names+0xb8>
    8000225e:	0000d517          	auipc	a0,0xd
    80002262:	e3a50513          	addi	a0,a0,-454 # 8000f098 <bcache>
    80002266:	00004097          	auipc	ra,0x4
    8000226a:	ddc080e7          	jalr	-548(ra) # 80006042 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000226e:	00015797          	auipc	a5,0x15
    80002272:	e2a78793          	addi	a5,a5,-470 # 80017098 <bcache+0x8000>
    80002276:	00015717          	auipc	a4,0x15
    8000227a:	08a70713          	addi	a4,a4,138 # 80017300 <bcache+0x8268>
    8000227e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002282:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002286:	0000d497          	auipc	s1,0xd
    8000228a:	e2a48493          	addi	s1,s1,-470 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000228e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002290:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002292:	00006a17          	auipc	s4,0x6
    80002296:	366a0a13          	addi	s4,s4,870 # 800085f8 <syscall_names+0xc0>
    b->next = bcache.head.next;
    8000229a:	2b893783          	ld	a5,696(s2)
    8000229e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022a0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022a4:	85d2                	mv	a1,s4
    800022a6:	01048513          	addi	a0,s1,16
    800022aa:	00001097          	auipc	ra,0x1
    800022ae:	4bc080e7          	jalr	1212(ra) # 80003766 <initsleeplock>
    bcache.head.next->prev = b;
    800022b2:	2b893783          	ld	a5,696(s2)
    800022b6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022b8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022bc:	45848493          	addi	s1,s1,1112
    800022c0:	fd349de3          	bne	s1,s3,8000229a <binit+0x54>
  }
}
    800022c4:	70a2                	ld	ra,40(sp)
    800022c6:	7402                	ld	s0,32(sp)
    800022c8:	64e2                	ld	s1,24(sp)
    800022ca:	6942                	ld	s2,16(sp)
    800022cc:	69a2                	ld	s3,8(sp)
    800022ce:	6a02                	ld	s4,0(sp)
    800022d0:	6145                	addi	sp,sp,48
    800022d2:	8082                	ret

00000000800022d4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022d4:	7179                	addi	sp,sp,-48
    800022d6:	f406                	sd	ra,40(sp)
    800022d8:	f022                	sd	s0,32(sp)
    800022da:	ec26                	sd	s1,24(sp)
    800022dc:	e84a                	sd	s2,16(sp)
    800022de:	e44e                	sd	s3,8(sp)
    800022e0:	1800                	addi	s0,sp,48
    800022e2:	89aa                	mv	s3,a0
    800022e4:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800022e6:	0000d517          	auipc	a0,0xd
    800022ea:	db250513          	addi	a0,a0,-590 # 8000f098 <bcache>
    800022ee:	00004097          	auipc	ra,0x4
    800022f2:	de4080e7          	jalr	-540(ra) # 800060d2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022f6:	00015497          	auipc	s1,0x15
    800022fa:	05a4b483          	ld	s1,90(s1) # 80017350 <bcache+0x82b8>
    800022fe:	00015797          	auipc	a5,0x15
    80002302:	00278793          	addi	a5,a5,2 # 80017300 <bcache+0x8268>
    80002306:	02f48f63          	beq	s1,a5,80002344 <bread+0x70>
    8000230a:	873e                	mv	a4,a5
    8000230c:	a021                	j	80002314 <bread+0x40>
    8000230e:	68a4                	ld	s1,80(s1)
    80002310:	02e48a63          	beq	s1,a4,80002344 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002314:	449c                	lw	a5,8(s1)
    80002316:	ff379ce3          	bne	a5,s3,8000230e <bread+0x3a>
    8000231a:	44dc                	lw	a5,12(s1)
    8000231c:	ff2799e3          	bne	a5,s2,8000230e <bread+0x3a>
      b->refcnt++;
    80002320:	40bc                	lw	a5,64(s1)
    80002322:	2785                	addiw	a5,a5,1
    80002324:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002326:	0000d517          	auipc	a0,0xd
    8000232a:	d7250513          	addi	a0,a0,-654 # 8000f098 <bcache>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	e58080e7          	jalr	-424(ra) # 80006186 <release>
      acquiresleep(&b->lock);
    80002336:	01048513          	addi	a0,s1,16
    8000233a:	00001097          	auipc	ra,0x1
    8000233e:	466080e7          	jalr	1126(ra) # 800037a0 <acquiresleep>
      return b;
    80002342:	a8b9                	j	800023a0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002344:	00015497          	auipc	s1,0x15
    80002348:	0044b483          	ld	s1,4(s1) # 80017348 <bcache+0x82b0>
    8000234c:	00015797          	auipc	a5,0x15
    80002350:	fb478793          	addi	a5,a5,-76 # 80017300 <bcache+0x8268>
    80002354:	00f48863          	beq	s1,a5,80002364 <bread+0x90>
    80002358:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000235a:	40bc                	lw	a5,64(s1)
    8000235c:	cf81                	beqz	a5,80002374 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000235e:	64a4                	ld	s1,72(s1)
    80002360:	fee49de3          	bne	s1,a4,8000235a <bread+0x86>
  panic("bget: no buffers");
    80002364:	00006517          	auipc	a0,0x6
    80002368:	29c50513          	addi	a0,a0,668 # 80008600 <syscall_names+0xc8>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	81c080e7          	jalr	-2020(ra) # 80005b88 <panic>
      b->dev = dev;
    80002374:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002378:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000237c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002380:	4785                	li	a5,1
    80002382:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002384:	0000d517          	auipc	a0,0xd
    80002388:	d1450513          	addi	a0,a0,-748 # 8000f098 <bcache>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	dfa080e7          	jalr	-518(ra) # 80006186 <release>
      acquiresleep(&b->lock);
    80002394:	01048513          	addi	a0,s1,16
    80002398:	00001097          	auipc	ra,0x1
    8000239c:	408080e7          	jalr	1032(ra) # 800037a0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023a0:	409c                	lw	a5,0(s1)
    800023a2:	cb89                	beqz	a5,800023b4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023a4:	8526                	mv	a0,s1
    800023a6:	70a2                	ld	ra,40(sp)
    800023a8:	7402                	ld	s0,32(sp)
    800023aa:	64e2                	ld	s1,24(sp)
    800023ac:	6942                	ld	s2,16(sp)
    800023ae:	69a2                	ld	s3,8(sp)
    800023b0:	6145                	addi	sp,sp,48
    800023b2:	8082                	ret
    virtio_disk_rw(b, 0);
    800023b4:	4581                	li	a1,0
    800023b6:	8526                	mv	a0,s1
    800023b8:	00003097          	auipc	ra,0x3
    800023bc:	f0e080e7          	jalr	-242(ra) # 800052c6 <virtio_disk_rw>
    b->valid = 1;
    800023c0:	4785                	li	a5,1
    800023c2:	c09c                	sw	a5,0(s1)
  return b;
    800023c4:	b7c5                	j	800023a4 <bread+0xd0>

00000000800023c6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023c6:	1101                	addi	sp,sp,-32
    800023c8:	ec06                	sd	ra,24(sp)
    800023ca:	e822                	sd	s0,16(sp)
    800023cc:	e426                	sd	s1,8(sp)
    800023ce:	1000                	addi	s0,sp,32
    800023d0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023d2:	0541                	addi	a0,a0,16
    800023d4:	00001097          	auipc	ra,0x1
    800023d8:	466080e7          	jalr	1126(ra) # 8000383a <holdingsleep>
    800023dc:	cd01                	beqz	a0,800023f4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023de:	4585                	li	a1,1
    800023e0:	8526                	mv	a0,s1
    800023e2:	00003097          	auipc	ra,0x3
    800023e6:	ee4080e7          	jalr	-284(ra) # 800052c6 <virtio_disk_rw>
}
    800023ea:	60e2                	ld	ra,24(sp)
    800023ec:	6442                	ld	s0,16(sp)
    800023ee:	64a2                	ld	s1,8(sp)
    800023f0:	6105                	addi	sp,sp,32
    800023f2:	8082                	ret
    panic("bwrite");
    800023f4:	00006517          	auipc	a0,0x6
    800023f8:	22450513          	addi	a0,a0,548 # 80008618 <syscall_names+0xe0>
    800023fc:	00003097          	auipc	ra,0x3
    80002400:	78c080e7          	jalr	1932(ra) # 80005b88 <panic>

0000000080002404 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002404:	1101                	addi	sp,sp,-32
    80002406:	ec06                	sd	ra,24(sp)
    80002408:	e822                	sd	s0,16(sp)
    8000240a:	e426                	sd	s1,8(sp)
    8000240c:	e04a                	sd	s2,0(sp)
    8000240e:	1000                	addi	s0,sp,32
    80002410:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002412:	01050913          	addi	s2,a0,16
    80002416:	854a                	mv	a0,s2
    80002418:	00001097          	auipc	ra,0x1
    8000241c:	422080e7          	jalr	1058(ra) # 8000383a <holdingsleep>
    80002420:	c92d                	beqz	a0,80002492 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002422:	854a                	mv	a0,s2
    80002424:	00001097          	auipc	ra,0x1
    80002428:	3d2080e7          	jalr	978(ra) # 800037f6 <releasesleep>

  acquire(&bcache.lock);
    8000242c:	0000d517          	auipc	a0,0xd
    80002430:	c6c50513          	addi	a0,a0,-916 # 8000f098 <bcache>
    80002434:	00004097          	auipc	ra,0x4
    80002438:	c9e080e7          	jalr	-866(ra) # 800060d2 <acquire>
  b->refcnt--;
    8000243c:	40bc                	lw	a5,64(s1)
    8000243e:	37fd                	addiw	a5,a5,-1
    80002440:	0007871b          	sext.w	a4,a5
    80002444:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002446:	eb05                	bnez	a4,80002476 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002448:	68bc                	ld	a5,80(s1)
    8000244a:	64b8                	ld	a4,72(s1)
    8000244c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000244e:	64bc                	ld	a5,72(s1)
    80002450:	68b8                	ld	a4,80(s1)
    80002452:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002454:	00015797          	auipc	a5,0x15
    80002458:	c4478793          	addi	a5,a5,-956 # 80017098 <bcache+0x8000>
    8000245c:	2b87b703          	ld	a4,696(a5)
    80002460:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002462:	00015717          	auipc	a4,0x15
    80002466:	e9e70713          	addi	a4,a4,-354 # 80017300 <bcache+0x8268>
    8000246a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000246c:	2b87b703          	ld	a4,696(a5)
    80002470:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002472:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002476:	0000d517          	auipc	a0,0xd
    8000247a:	c2250513          	addi	a0,a0,-990 # 8000f098 <bcache>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	d08080e7          	jalr	-760(ra) # 80006186 <release>
}
    80002486:	60e2                	ld	ra,24(sp)
    80002488:	6442                	ld	s0,16(sp)
    8000248a:	64a2                	ld	s1,8(sp)
    8000248c:	6902                	ld	s2,0(sp)
    8000248e:	6105                	addi	sp,sp,32
    80002490:	8082                	ret
    panic("brelse");
    80002492:	00006517          	auipc	a0,0x6
    80002496:	18e50513          	addi	a0,a0,398 # 80008620 <syscall_names+0xe8>
    8000249a:	00003097          	auipc	ra,0x3
    8000249e:	6ee080e7          	jalr	1774(ra) # 80005b88 <panic>

00000000800024a2 <bpin>:

void
bpin(struct buf *b) {
    800024a2:	1101                	addi	sp,sp,-32
    800024a4:	ec06                	sd	ra,24(sp)
    800024a6:	e822                	sd	s0,16(sp)
    800024a8:	e426                	sd	s1,8(sp)
    800024aa:	1000                	addi	s0,sp,32
    800024ac:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ae:	0000d517          	auipc	a0,0xd
    800024b2:	bea50513          	addi	a0,a0,-1046 # 8000f098 <bcache>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	c1c080e7          	jalr	-996(ra) # 800060d2 <acquire>
  b->refcnt++;
    800024be:	40bc                	lw	a5,64(s1)
    800024c0:	2785                	addiw	a5,a5,1
    800024c2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024c4:	0000d517          	auipc	a0,0xd
    800024c8:	bd450513          	addi	a0,a0,-1068 # 8000f098 <bcache>
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	cba080e7          	jalr	-838(ra) # 80006186 <release>
}
    800024d4:	60e2                	ld	ra,24(sp)
    800024d6:	6442                	ld	s0,16(sp)
    800024d8:	64a2                	ld	s1,8(sp)
    800024da:	6105                	addi	sp,sp,32
    800024dc:	8082                	ret

00000000800024de <bunpin>:

void
bunpin(struct buf *b) {
    800024de:	1101                	addi	sp,sp,-32
    800024e0:	ec06                	sd	ra,24(sp)
    800024e2:	e822                	sd	s0,16(sp)
    800024e4:	e426                	sd	s1,8(sp)
    800024e6:	1000                	addi	s0,sp,32
    800024e8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024ea:	0000d517          	auipc	a0,0xd
    800024ee:	bae50513          	addi	a0,a0,-1106 # 8000f098 <bcache>
    800024f2:	00004097          	auipc	ra,0x4
    800024f6:	be0080e7          	jalr	-1056(ra) # 800060d2 <acquire>
  b->refcnt--;
    800024fa:	40bc                	lw	a5,64(s1)
    800024fc:	37fd                	addiw	a5,a5,-1
    800024fe:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002500:	0000d517          	auipc	a0,0xd
    80002504:	b9850513          	addi	a0,a0,-1128 # 8000f098 <bcache>
    80002508:	00004097          	auipc	ra,0x4
    8000250c:	c7e080e7          	jalr	-898(ra) # 80006186 <release>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret

000000008000251a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000251a:	1101                	addi	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	e426                	sd	s1,8(sp)
    80002522:	e04a                	sd	s2,0(sp)
    80002524:	1000                	addi	s0,sp,32
    80002526:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002528:	00d5d59b          	srliw	a1,a1,0xd
    8000252c:	00015797          	auipc	a5,0x15
    80002530:	2487a783          	lw	a5,584(a5) # 80017774 <sb+0x1c>
    80002534:	9dbd                	addw	a1,a1,a5
    80002536:	00000097          	auipc	ra,0x0
    8000253a:	d9e080e7          	jalr	-610(ra) # 800022d4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000253e:	0074f713          	andi	a4,s1,7
    80002542:	4785                	li	a5,1
    80002544:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002548:	14ce                	slli	s1,s1,0x33
    8000254a:	90d9                	srli	s1,s1,0x36
    8000254c:	00950733          	add	a4,a0,s1
    80002550:	05874703          	lbu	a4,88(a4)
    80002554:	00e7f6b3          	and	a3,a5,a4
    80002558:	c69d                	beqz	a3,80002586 <bfree+0x6c>
    8000255a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000255c:	94aa                	add	s1,s1,a0
    8000255e:	fff7c793          	not	a5,a5
    80002562:	8ff9                	and	a5,a5,a4
    80002564:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002568:	00001097          	auipc	ra,0x1
    8000256c:	118080e7          	jalr	280(ra) # 80003680 <log_write>
  brelse(bp);
    80002570:	854a                	mv	a0,s2
    80002572:	00000097          	auipc	ra,0x0
    80002576:	e92080e7          	jalr	-366(ra) # 80002404 <brelse>
}
    8000257a:	60e2                	ld	ra,24(sp)
    8000257c:	6442                	ld	s0,16(sp)
    8000257e:	64a2                	ld	s1,8(sp)
    80002580:	6902                	ld	s2,0(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
    panic("freeing free block");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	0a250513          	addi	a0,a0,162 # 80008628 <syscall_names+0xf0>
    8000258e:	00003097          	auipc	ra,0x3
    80002592:	5fa080e7          	jalr	1530(ra) # 80005b88 <panic>

0000000080002596 <balloc>:
{
    80002596:	711d                	addi	sp,sp,-96
    80002598:	ec86                	sd	ra,88(sp)
    8000259a:	e8a2                	sd	s0,80(sp)
    8000259c:	e4a6                	sd	s1,72(sp)
    8000259e:	e0ca                	sd	s2,64(sp)
    800025a0:	fc4e                	sd	s3,56(sp)
    800025a2:	f852                	sd	s4,48(sp)
    800025a4:	f456                	sd	s5,40(sp)
    800025a6:	f05a                	sd	s6,32(sp)
    800025a8:	ec5e                	sd	s7,24(sp)
    800025aa:	e862                	sd	s8,16(sp)
    800025ac:	e466                	sd	s9,8(sp)
    800025ae:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025b0:	00015797          	auipc	a5,0x15
    800025b4:	1ac7a783          	lw	a5,428(a5) # 8001775c <sb+0x4>
    800025b8:	cbd1                	beqz	a5,8000264c <balloc+0xb6>
    800025ba:	8baa                	mv	s7,a0
    800025bc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025be:	00015b17          	auipc	s6,0x15
    800025c2:	19ab0b13          	addi	s6,s6,410 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025c6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025c8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ca:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025cc:	6c89                	lui	s9,0x2
    800025ce:	a831                	j	800025ea <balloc+0x54>
    brelse(bp);
    800025d0:	854a                	mv	a0,s2
    800025d2:	00000097          	auipc	ra,0x0
    800025d6:	e32080e7          	jalr	-462(ra) # 80002404 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025da:	015c87bb          	addw	a5,s9,s5
    800025de:	00078a9b          	sext.w	s5,a5
    800025e2:	004b2703          	lw	a4,4(s6)
    800025e6:	06eaf363          	bgeu	s5,a4,8000264c <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800025ea:	41fad79b          	sraiw	a5,s5,0x1f
    800025ee:	0137d79b          	srliw	a5,a5,0x13
    800025f2:	015787bb          	addw	a5,a5,s5
    800025f6:	40d7d79b          	sraiw	a5,a5,0xd
    800025fa:	01cb2583          	lw	a1,28(s6)
    800025fe:	9dbd                	addw	a1,a1,a5
    80002600:	855e                	mv	a0,s7
    80002602:	00000097          	auipc	ra,0x0
    80002606:	cd2080e7          	jalr	-814(ra) # 800022d4 <bread>
    8000260a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000260c:	004b2503          	lw	a0,4(s6)
    80002610:	000a849b          	sext.w	s1,s5
    80002614:	8662                	mv	a2,s8
    80002616:	faa4fde3          	bgeu	s1,a0,800025d0 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000261a:	41f6579b          	sraiw	a5,a2,0x1f
    8000261e:	01d7d69b          	srliw	a3,a5,0x1d
    80002622:	00c6873b          	addw	a4,a3,a2
    80002626:	00777793          	andi	a5,a4,7
    8000262a:	9f95                	subw	a5,a5,a3
    8000262c:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002630:	4037571b          	sraiw	a4,a4,0x3
    80002634:	00e906b3          	add	a3,s2,a4
    80002638:	0586c683          	lbu	a3,88(a3)
    8000263c:	00d7f5b3          	and	a1,a5,a3
    80002640:	cd91                	beqz	a1,8000265c <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002642:	2605                	addiw	a2,a2,1
    80002644:	2485                	addiw	s1,s1,1
    80002646:	fd4618e3          	bne	a2,s4,80002616 <balloc+0x80>
    8000264a:	b759                	j	800025d0 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000264c:	00006517          	auipc	a0,0x6
    80002650:	ff450513          	addi	a0,a0,-12 # 80008640 <syscall_names+0x108>
    80002654:	00003097          	auipc	ra,0x3
    80002658:	534080e7          	jalr	1332(ra) # 80005b88 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000265c:	974a                	add	a4,a4,s2
    8000265e:	8fd5                	or	a5,a5,a3
    80002660:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002664:	854a                	mv	a0,s2
    80002666:	00001097          	auipc	ra,0x1
    8000266a:	01a080e7          	jalr	26(ra) # 80003680 <log_write>
        brelse(bp);
    8000266e:	854a                	mv	a0,s2
    80002670:	00000097          	auipc	ra,0x0
    80002674:	d94080e7          	jalr	-620(ra) # 80002404 <brelse>
  bp = bread(dev, bno);
    80002678:	85a6                	mv	a1,s1
    8000267a:	855e                	mv	a0,s7
    8000267c:	00000097          	auipc	ra,0x0
    80002680:	c58080e7          	jalr	-936(ra) # 800022d4 <bread>
    80002684:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002686:	40000613          	li	a2,1024
    8000268a:	4581                	li	a1,0
    8000268c:	05850513          	addi	a0,a0,88
    80002690:	ffffe097          	auipc	ra,0xffffe
    80002694:	ae8080e7          	jalr	-1304(ra) # 80000178 <memset>
  log_write(bp);
    80002698:	854a                	mv	a0,s2
    8000269a:	00001097          	auipc	ra,0x1
    8000269e:	fe6080e7          	jalr	-26(ra) # 80003680 <log_write>
  brelse(bp);
    800026a2:	854a                	mv	a0,s2
    800026a4:	00000097          	auipc	ra,0x0
    800026a8:	d60080e7          	jalr	-672(ra) # 80002404 <brelse>
}
    800026ac:	8526                	mv	a0,s1
    800026ae:	60e6                	ld	ra,88(sp)
    800026b0:	6446                	ld	s0,80(sp)
    800026b2:	64a6                	ld	s1,72(sp)
    800026b4:	6906                	ld	s2,64(sp)
    800026b6:	79e2                	ld	s3,56(sp)
    800026b8:	7a42                	ld	s4,48(sp)
    800026ba:	7aa2                	ld	s5,40(sp)
    800026bc:	7b02                	ld	s6,32(sp)
    800026be:	6be2                	ld	s7,24(sp)
    800026c0:	6c42                	ld	s8,16(sp)
    800026c2:	6ca2                	ld	s9,8(sp)
    800026c4:	6125                	addi	sp,sp,96
    800026c6:	8082                	ret

00000000800026c8 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026c8:	7179                	addi	sp,sp,-48
    800026ca:	f406                	sd	ra,40(sp)
    800026cc:	f022                	sd	s0,32(sp)
    800026ce:	ec26                	sd	s1,24(sp)
    800026d0:	e84a                	sd	s2,16(sp)
    800026d2:	e44e                	sd	s3,8(sp)
    800026d4:	e052                	sd	s4,0(sp)
    800026d6:	1800                	addi	s0,sp,48
    800026d8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026da:	47ad                	li	a5,11
    800026dc:	04b7fe63          	bgeu	a5,a1,80002738 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026e0:	ff45849b          	addiw	s1,a1,-12
    800026e4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026e8:	0ff00793          	li	a5,255
    800026ec:	0ae7e363          	bltu	a5,a4,80002792 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800026f0:	08052583          	lw	a1,128(a0)
    800026f4:	c5ad                	beqz	a1,8000275e <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800026f6:	00092503          	lw	a0,0(s2)
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	bda080e7          	jalr	-1062(ra) # 800022d4 <bread>
    80002702:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002704:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002708:	02049593          	slli	a1,s1,0x20
    8000270c:	9181                	srli	a1,a1,0x20
    8000270e:	058a                	slli	a1,a1,0x2
    80002710:	00b784b3          	add	s1,a5,a1
    80002714:	0004a983          	lw	s3,0(s1)
    80002718:	04098d63          	beqz	s3,80002772 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000271c:	8552                	mv	a0,s4
    8000271e:	00000097          	auipc	ra,0x0
    80002722:	ce6080e7          	jalr	-794(ra) # 80002404 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002726:	854e                	mv	a0,s3
    80002728:	70a2                	ld	ra,40(sp)
    8000272a:	7402                	ld	s0,32(sp)
    8000272c:	64e2                	ld	s1,24(sp)
    8000272e:	6942                	ld	s2,16(sp)
    80002730:	69a2                	ld	s3,8(sp)
    80002732:	6a02                	ld	s4,0(sp)
    80002734:	6145                	addi	sp,sp,48
    80002736:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002738:	02059493          	slli	s1,a1,0x20
    8000273c:	9081                	srli	s1,s1,0x20
    8000273e:	048a                	slli	s1,s1,0x2
    80002740:	94aa                	add	s1,s1,a0
    80002742:	0504a983          	lw	s3,80(s1)
    80002746:	fe0990e3          	bnez	s3,80002726 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000274a:	4108                	lw	a0,0(a0)
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	e4a080e7          	jalr	-438(ra) # 80002596 <balloc>
    80002754:	0005099b          	sext.w	s3,a0
    80002758:	0534a823          	sw	s3,80(s1)
    8000275c:	b7e9                	j	80002726 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000275e:	4108                	lw	a0,0(a0)
    80002760:	00000097          	auipc	ra,0x0
    80002764:	e36080e7          	jalr	-458(ra) # 80002596 <balloc>
    80002768:	0005059b          	sext.w	a1,a0
    8000276c:	08b92023          	sw	a1,128(s2)
    80002770:	b759                	j	800026f6 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002772:	00092503          	lw	a0,0(s2)
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	e20080e7          	jalr	-480(ra) # 80002596 <balloc>
    8000277e:	0005099b          	sext.w	s3,a0
    80002782:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002786:	8552                	mv	a0,s4
    80002788:	00001097          	auipc	ra,0x1
    8000278c:	ef8080e7          	jalr	-264(ra) # 80003680 <log_write>
    80002790:	b771                	j	8000271c <bmap+0x54>
  panic("bmap: out of range");
    80002792:	00006517          	auipc	a0,0x6
    80002796:	ec650513          	addi	a0,a0,-314 # 80008658 <syscall_names+0x120>
    8000279a:	00003097          	auipc	ra,0x3
    8000279e:	3ee080e7          	jalr	1006(ra) # 80005b88 <panic>

00000000800027a2 <iget>:
{
    800027a2:	7179                	addi	sp,sp,-48
    800027a4:	f406                	sd	ra,40(sp)
    800027a6:	f022                	sd	s0,32(sp)
    800027a8:	ec26                	sd	s1,24(sp)
    800027aa:	e84a                	sd	s2,16(sp)
    800027ac:	e44e                	sd	s3,8(sp)
    800027ae:	e052                	sd	s4,0(sp)
    800027b0:	1800                	addi	s0,sp,48
    800027b2:	89aa                	mv	s3,a0
    800027b4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027b6:	00015517          	auipc	a0,0x15
    800027ba:	fc250513          	addi	a0,a0,-62 # 80017778 <itable>
    800027be:	00004097          	auipc	ra,0x4
    800027c2:	914080e7          	jalr	-1772(ra) # 800060d2 <acquire>
  empty = 0;
    800027c6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027c8:	00015497          	auipc	s1,0x15
    800027cc:	fc848493          	addi	s1,s1,-56 # 80017790 <itable+0x18>
    800027d0:	00017697          	auipc	a3,0x17
    800027d4:	a5068693          	addi	a3,a3,-1456 # 80019220 <log>
    800027d8:	a039                	j	800027e6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027da:	02090b63          	beqz	s2,80002810 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027de:	08848493          	addi	s1,s1,136
    800027e2:	02d48a63          	beq	s1,a3,80002816 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027e6:	449c                	lw	a5,8(s1)
    800027e8:	fef059e3          	blez	a5,800027da <iget+0x38>
    800027ec:	4098                	lw	a4,0(s1)
    800027ee:	ff3716e3          	bne	a4,s3,800027da <iget+0x38>
    800027f2:	40d8                	lw	a4,4(s1)
    800027f4:	ff4713e3          	bne	a4,s4,800027da <iget+0x38>
      ip->ref++;
    800027f8:	2785                	addiw	a5,a5,1
    800027fa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027fc:	00015517          	auipc	a0,0x15
    80002800:	f7c50513          	addi	a0,a0,-132 # 80017778 <itable>
    80002804:	00004097          	auipc	ra,0x4
    80002808:	982080e7          	jalr	-1662(ra) # 80006186 <release>
      return ip;
    8000280c:	8926                	mv	s2,s1
    8000280e:	a03d                	j	8000283c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002810:	f7f9                	bnez	a5,800027de <iget+0x3c>
    80002812:	8926                	mv	s2,s1
    80002814:	b7e9                	j	800027de <iget+0x3c>
  if(empty == 0)
    80002816:	02090c63          	beqz	s2,8000284e <iget+0xac>
  ip->dev = dev;
    8000281a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000281e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002822:	4785                	li	a5,1
    80002824:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002828:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000282c:	00015517          	auipc	a0,0x15
    80002830:	f4c50513          	addi	a0,a0,-180 # 80017778 <itable>
    80002834:	00004097          	auipc	ra,0x4
    80002838:	952080e7          	jalr	-1710(ra) # 80006186 <release>
}
    8000283c:	854a                	mv	a0,s2
    8000283e:	70a2                	ld	ra,40(sp)
    80002840:	7402                	ld	s0,32(sp)
    80002842:	64e2                	ld	s1,24(sp)
    80002844:	6942                	ld	s2,16(sp)
    80002846:	69a2                	ld	s3,8(sp)
    80002848:	6a02                	ld	s4,0(sp)
    8000284a:	6145                	addi	sp,sp,48
    8000284c:	8082                	ret
    panic("iget: no inodes");
    8000284e:	00006517          	auipc	a0,0x6
    80002852:	e2250513          	addi	a0,a0,-478 # 80008670 <syscall_names+0x138>
    80002856:	00003097          	auipc	ra,0x3
    8000285a:	332080e7          	jalr	818(ra) # 80005b88 <panic>

000000008000285e <fsinit>:
fsinit(int dev) {
    8000285e:	7179                	addi	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	1800                	addi	s0,sp,48
    8000286c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000286e:	4585                	li	a1,1
    80002870:	00000097          	auipc	ra,0x0
    80002874:	a64080e7          	jalr	-1436(ra) # 800022d4 <bread>
    80002878:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000287a:	00015997          	auipc	s3,0x15
    8000287e:	ede98993          	addi	s3,s3,-290 # 80017758 <sb>
    80002882:	02000613          	li	a2,32
    80002886:	05850593          	addi	a1,a0,88
    8000288a:	854e                	mv	a0,s3
    8000288c:	ffffe097          	auipc	ra,0xffffe
    80002890:	94c080e7          	jalr	-1716(ra) # 800001d8 <memmove>
  brelse(bp);
    80002894:	8526                	mv	a0,s1
    80002896:	00000097          	auipc	ra,0x0
    8000289a:	b6e080e7          	jalr	-1170(ra) # 80002404 <brelse>
  if(sb.magic != FSMAGIC)
    8000289e:	0009a703          	lw	a4,0(s3)
    800028a2:	102037b7          	lui	a5,0x10203
    800028a6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028aa:	02f71263          	bne	a4,a5,800028ce <fsinit+0x70>
  initlog(dev, &sb);
    800028ae:	00015597          	auipc	a1,0x15
    800028b2:	eaa58593          	addi	a1,a1,-342 # 80017758 <sb>
    800028b6:	854a                	mv	a0,s2
    800028b8:	00001097          	auipc	ra,0x1
    800028bc:	b4c080e7          	jalr	-1204(ra) # 80003404 <initlog>
}
    800028c0:	70a2                	ld	ra,40(sp)
    800028c2:	7402                	ld	s0,32(sp)
    800028c4:	64e2                	ld	s1,24(sp)
    800028c6:	6942                	ld	s2,16(sp)
    800028c8:	69a2                	ld	s3,8(sp)
    800028ca:	6145                	addi	sp,sp,48
    800028cc:	8082                	ret
    panic("invalid file system");
    800028ce:	00006517          	auipc	a0,0x6
    800028d2:	db250513          	addi	a0,a0,-590 # 80008680 <syscall_names+0x148>
    800028d6:	00003097          	auipc	ra,0x3
    800028da:	2b2080e7          	jalr	690(ra) # 80005b88 <panic>

00000000800028de <iinit>:
{
    800028de:	7179                	addi	sp,sp,-48
    800028e0:	f406                	sd	ra,40(sp)
    800028e2:	f022                	sd	s0,32(sp)
    800028e4:	ec26                	sd	s1,24(sp)
    800028e6:	e84a                	sd	s2,16(sp)
    800028e8:	e44e                	sd	s3,8(sp)
    800028ea:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028ec:	00006597          	auipc	a1,0x6
    800028f0:	dac58593          	addi	a1,a1,-596 # 80008698 <syscall_names+0x160>
    800028f4:	00015517          	auipc	a0,0x15
    800028f8:	e8450513          	addi	a0,a0,-380 # 80017778 <itable>
    800028fc:	00003097          	auipc	ra,0x3
    80002900:	746080e7          	jalr	1862(ra) # 80006042 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002904:	00015497          	auipc	s1,0x15
    80002908:	e9c48493          	addi	s1,s1,-356 # 800177a0 <itable+0x28>
    8000290c:	00017997          	auipc	s3,0x17
    80002910:	92498993          	addi	s3,s3,-1756 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002914:	00006917          	auipc	s2,0x6
    80002918:	d8c90913          	addi	s2,s2,-628 # 800086a0 <syscall_names+0x168>
    8000291c:	85ca                	mv	a1,s2
    8000291e:	8526                	mv	a0,s1
    80002920:	00001097          	auipc	ra,0x1
    80002924:	e46080e7          	jalr	-442(ra) # 80003766 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002928:	08848493          	addi	s1,s1,136
    8000292c:	ff3498e3          	bne	s1,s3,8000291c <iinit+0x3e>
}
    80002930:	70a2                	ld	ra,40(sp)
    80002932:	7402                	ld	s0,32(sp)
    80002934:	64e2                	ld	s1,24(sp)
    80002936:	6942                	ld	s2,16(sp)
    80002938:	69a2                	ld	s3,8(sp)
    8000293a:	6145                	addi	sp,sp,48
    8000293c:	8082                	ret

000000008000293e <ialloc>:
{
    8000293e:	715d                	addi	sp,sp,-80
    80002940:	e486                	sd	ra,72(sp)
    80002942:	e0a2                	sd	s0,64(sp)
    80002944:	fc26                	sd	s1,56(sp)
    80002946:	f84a                	sd	s2,48(sp)
    80002948:	f44e                	sd	s3,40(sp)
    8000294a:	f052                	sd	s4,32(sp)
    8000294c:	ec56                	sd	s5,24(sp)
    8000294e:	e85a                	sd	s6,16(sp)
    80002950:	e45e                	sd	s7,8(sp)
    80002952:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002954:	00015717          	auipc	a4,0x15
    80002958:	e1072703          	lw	a4,-496(a4) # 80017764 <sb+0xc>
    8000295c:	4785                	li	a5,1
    8000295e:	04e7fa63          	bgeu	a5,a4,800029b2 <ialloc+0x74>
    80002962:	8aaa                	mv	s5,a0
    80002964:	8bae                	mv	s7,a1
    80002966:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002968:	00015a17          	auipc	s4,0x15
    8000296c:	df0a0a13          	addi	s4,s4,-528 # 80017758 <sb>
    80002970:	00048b1b          	sext.w	s6,s1
    80002974:	0044d593          	srli	a1,s1,0x4
    80002978:	018a2783          	lw	a5,24(s4)
    8000297c:	9dbd                	addw	a1,a1,a5
    8000297e:	8556                	mv	a0,s5
    80002980:	00000097          	auipc	ra,0x0
    80002984:	954080e7          	jalr	-1708(ra) # 800022d4 <bread>
    80002988:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000298a:	05850993          	addi	s3,a0,88
    8000298e:	00f4f793          	andi	a5,s1,15
    80002992:	079a                	slli	a5,a5,0x6
    80002994:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002996:	00099783          	lh	a5,0(s3)
    8000299a:	c785                	beqz	a5,800029c2 <ialloc+0x84>
    brelse(bp);
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	a68080e7          	jalr	-1432(ra) # 80002404 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029a4:	0485                	addi	s1,s1,1
    800029a6:	00ca2703          	lw	a4,12(s4)
    800029aa:	0004879b          	sext.w	a5,s1
    800029ae:	fce7e1e3          	bltu	a5,a4,80002970 <ialloc+0x32>
  panic("ialloc: no inodes");
    800029b2:	00006517          	auipc	a0,0x6
    800029b6:	cf650513          	addi	a0,a0,-778 # 800086a8 <syscall_names+0x170>
    800029ba:	00003097          	auipc	ra,0x3
    800029be:	1ce080e7          	jalr	462(ra) # 80005b88 <panic>
      memset(dip, 0, sizeof(*dip));
    800029c2:	04000613          	li	a2,64
    800029c6:	4581                	li	a1,0
    800029c8:	854e                	mv	a0,s3
    800029ca:	ffffd097          	auipc	ra,0xffffd
    800029ce:	7ae080e7          	jalr	1966(ra) # 80000178 <memset>
      dip->type = type;
    800029d2:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029d6:	854a                	mv	a0,s2
    800029d8:	00001097          	auipc	ra,0x1
    800029dc:	ca8080e7          	jalr	-856(ra) # 80003680 <log_write>
      brelse(bp);
    800029e0:	854a                	mv	a0,s2
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	a22080e7          	jalr	-1502(ra) # 80002404 <brelse>
      return iget(dev, inum);
    800029ea:	85da                	mv	a1,s6
    800029ec:	8556                	mv	a0,s5
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	db4080e7          	jalr	-588(ra) # 800027a2 <iget>
}
    800029f6:	60a6                	ld	ra,72(sp)
    800029f8:	6406                	ld	s0,64(sp)
    800029fa:	74e2                	ld	s1,56(sp)
    800029fc:	7942                	ld	s2,48(sp)
    800029fe:	79a2                	ld	s3,40(sp)
    80002a00:	7a02                	ld	s4,32(sp)
    80002a02:	6ae2                	ld	s5,24(sp)
    80002a04:	6b42                	ld	s6,16(sp)
    80002a06:	6ba2                	ld	s7,8(sp)
    80002a08:	6161                	addi	sp,sp,80
    80002a0a:	8082                	ret

0000000080002a0c <iupdate>:
{
    80002a0c:	1101                	addi	sp,sp,-32
    80002a0e:	ec06                	sd	ra,24(sp)
    80002a10:	e822                	sd	s0,16(sp)
    80002a12:	e426                	sd	s1,8(sp)
    80002a14:	e04a                	sd	s2,0(sp)
    80002a16:	1000                	addi	s0,sp,32
    80002a18:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a1a:	415c                	lw	a5,4(a0)
    80002a1c:	0047d79b          	srliw	a5,a5,0x4
    80002a20:	00015597          	auipc	a1,0x15
    80002a24:	d505a583          	lw	a1,-688(a1) # 80017770 <sb+0x18>
    80002a28:	9dbd                	addw	a1,a1,a5
    80002a2a:	4108                	lw	a0,0(a0)
    80002a2c:	00000097          	auipc	ra,0x0
    80002a30:	8a8080e7          	jalr	-1880(ra) # 800022d4 <bread>
    80002a34:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a36:	05850793          	addi	a5,a0,88
    80002a3a:	40c8                	lw	a0,4(s1)
    80002a3c:	893d                	andi	a0,a0,15
    80002a3e:	051a                	slli	a0,a0,0x6
    80002a40:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a42:	04449703          	lh	a4,68(s1)
    80002a46:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002a4a:	04649703          	lh	a4,70(s1)
    80002a4e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002a52:	04849703          	lh	a4,72(s1)
    80002a56:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002a5a:	04a49703          	lh	a4,74(s1)
    80002a5e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002a62:	44f8                	lw	a4,76(s1)
    80002a64:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a66:	03400613          	li	a2,52
    80002a6a:	05048593          	addi	a1,s1,80
    80002a6e:	0531                	addi	a0,a0,12
    80002a70:	ffffd097          	auipc	ra,0xffffd
    80002a74:	768080e7          	jalr	1896(ra) # 800001d8 <memmove>
  log_write(bp);
    80002a78:	854a                	mv	a0,s2
    80002a7a:	00001097          	auipc	ra,0x1
    80002a7e:	c06080e7          	jalr	-1018(ra) # 80003680 <log_write>
  brelse(bp);
    80002a82:	854a                	mv	a0,s2
    80002a84:	00000097          	auipc	ra,0x0
    80002a88:	980080e7          	jalr	-1664(ra) # 80002404 <brelse>
}
    80002a8c:	60e2                	ld	ra,24(sp)
    80002a8e:	6442                	ld	s0,16(sp)
    80002a90:	64a2                	ld	s1,8(sp)
    80002a92:	6902                	ld	s2,0(sp)
    80002a94:	6105                	addi	sp,sp,32
    80002a96:	8082                	ret

0000000080002a98 <idup>:
{
    80002a98:	1101                	addi	sp,sp,-32
    80002a9a:	ec06                	sd	ra,24(sp)
    80002a9c:	e822                	sd	s0,16(sp)
    80002a9e:	e426                	sd	s1,8(sp)
    80002aa0:	1000                	addi	s0,sp,32
    80002aa2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002aa4:	00015517          	auipc	a0,0x15
    80002aa8:	cd450513          	addi	a0,a0,-812 # 80017778 <itable>
    80002aac:	00003097          	auipc	ra,0x3
    80002ab0:	626080e7          	jalr	1574(ra) # 800060d2 <acquire>
  ip->ref++;
    80002ab4:	449c                	lw	a5,8(s1)
    80002ab6:	2785                	addiw	a5,a5,1
    80002ab8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002aba:	00015517          	auipc	a0,0x15
    80002abe:	cbe50513          	addi	a0,a0,-834 # 80017778 <itable>
    80002ac2:	00003097          	auipc	ra,0x3
    80002ac6:	6c4080e7          	jalr	1732(ra) # 80006186 <release>
}
    80002aca:	8526                	mv	a0,s1
    80002acc:	60e2                	ld	ra,24(sp)
    80002ace:	6442                	ld	s0,16(sp)
    80002ad0:	64a2                	ld	s1,8(sp)
    80002ad2:	6105                	addi	sp,sp,32
    80002ad4:	8082                	ret

0000000080002ad6 <ilock>:
{
    80002ad6:	1101                	addi	sp,sp,-32
    80002ad8:	ec06                	sd	ra,24(sp)
    80002ada:	e822                	sd	s0,16(sp)
    80002adc:	e426                	sd	s1,8(sp)
    80002ade:	e04a                	sd	s2,0(sp)
    80002ae0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ae2:	c115                	beqz	a0,80002b06 <ilock+0x30>
    80002ae4:	84aa                	mv	s1,a0
    80002ae6:	451c                	lw	a5,8(a0)
    80002ae8:	00f05f63          	blez	a5,80002b06 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002aec:	0541                	addi	a0,a0,16
    80002aee:	00001097          	auipc	ra,0x1
    80002af2:	cb2080e7          	jalr	-846(ra) # 800037a0 <acquiresleep>
  if(ip->valid == 0){
    80002af6:	40bc                	lw	a5,64(s1)
    80002af8:	cf99                	beqz	a5,80002b16 <ilock+0x40>
}
    80002afa:	60e2                	ld	ra,24(sp)
    80002afc:	6442                	ld	s0,16(sp)
    80002afe:	64a2                	ld	s1,8(sp)
    80002b00:	6902                	ld	s2,0(sp)
    80002b02:	6105                	addi	sp,sp,32
    80002b04:	8082                	ret
    panic("ilock");
    80002b06:	00006517          	auipc	a0,0x6
    80002b0a:	bba50513          	addi	a0,a0,-1094 # 800086c0 <syscall_names+0x188>
    80002b0e:	00003097          	auipc	ra,0x3
    80002b12:	07a080e7          	jalr	122(ra) # 80005b88 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b16:	40dc                	lw	a5,4(s1)
    80002b18:	0047d79b          	srliw	a5,a5,0x4
    80002b1c:	00015597          	auipc	a1,0x15
    80002b20:	c545a583          	lw	a1,-940(a1) # 80017770 <sb+0x18>
    80002b24:	9dbd                	addw	a1,a1,a5
    80002b26:	4088                	lw	a0,0(s1)
    80002b28:	fffff097          	auipc	ra,0xfffff
    80002b2c:	7ac080e7          	jalr	1964(ra) # 800022d4 <bread>
    80002b30:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b32:	05850593          	addi	a1,a0,88
    80002b36:	40dc                	lw	a5,4(s1)
    80002b38:	8bbd                	andi	a5,a5,15
    80002b3a:	079a                	slli	a5,a5,0x6
    80002b3c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b3e:	00059783          	lh	a5,0(a1)
    80002b42:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b46:	00259783          	lh	a5,2(a1)
    80002b4a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b4e:	00459783          	lh	a5,4(a1)
    80002b52:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b56:	00659783          	lh	a5,6(a1)
    80002b5a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b5e:	459c                	lw	a5,8(a1)
    80002b60:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b62:	03400613          	li	a2,52
    80002b66:	05b1                	addi	a1,a1,12
    80002b68:	05048513          	addi	a0,s1,80
    80002b6c:	ffffd097          	auipc	ra,0xffffd
    80002b70:	66c080e7          	jalr	1644(ra) # 800001d8 <memmove>
    brelse(bp);
    80002b74:	854a                	mv	a0,s2
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	88e080e7          	jalr	-1906(ra) # 80002404 <brelse>
    ip->valid = 1;
    80002b7e:	4785                	li	a5,1
    80002b80:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b82:	04449783          	lh	a5,68(s1)
    80002b86:	fbb5                	bnez	a5,80002afa <ilock+0x24>
      panic("ilock: no type");
    80002b88:	00006517          	auipc	a0,0x6
    80002b8c:	b4050513          	addi	a0,a0,-1216 # 800086c8 <syscall_names+0x190>
    80002b90:	00003097          	auipc	ra,0x3
    80002b94:	ff8080e7          	jalr	-8(ra) # 80005b88 <panic>

0000000080002b98 <iunlock>:
{
    80002b98:	1101                	addi	sp,sp,-32
    80002b9a:	ec06                	sd	ra,24(sp)
    80002b9c:	e822                	sd	s0,16(sp)
    80002b9e:	e426                	sd	s1,8(sp)
    80002ba0:	e04a                	sd	s2,0(sp)
    80002ba2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ba4:	c905                	beqz	a0,80002bd4 <iunlock+0x3c>
    80002ba6:	84aa                	mv	s1,a0
    80002ba8:	01050913          	addi	s2,a0,16
    80002bac:	854a                	mv	a0,s2
    80002bae:	00001097          	auipc	ra,0x1
    80002bb2:	c8c080e7          	jalr	-884(ra) # 8000383a <holdingsleep>
    80002bb6:	cd19                	beqz	a0,80002bd4 <iunlock+0x3c>
    80002bb8:	449c                	lw	a5,8(s1)
    80002bba:	00f05d63          	blez	a5,80002bd4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bbe:	854a                	mv	a0,s2
    80002bc0:	00001097          	auipc	ra,0x1
    80002bc4:	c36080e7          	jalr	-970(ra) # 800037f6 <releasesleep>
}
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	64a2                	ld	s1,8(sp)
    80002bce:	6902                	ld	s2,0(sp)
    80002bd0:	6105                	addi	sp,sp,32
    80002bd2:	8082                	ret
    panic("iunlock");
    80002bd4:	00006517          	auipc	a0,0x6
    80002bd8:	b0450513          	addi	a0,a0,-1276 # 800086d8 <syscall_names+0x1a0>
    80002bdc:	00003097          	auipc	ra,0x3
    80002be0:	fac080e7          	jalr	-84(ra) # 80005b88 <panic>

0000000080002be4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002be4:	7179                	addi	sp,sp,-48
    80002be6:	f406                	sd	ra,40(sp)
    80002be8:	f022                	sd	s0,32(sp)
    80002bea:	ec26                	sd	s1,24(sp)
    80002bec:	e84a                	sd	s2,16(sp)
    80002bee:	e44e                	sd	s3,8(sp)
    80002bf0:	e052                	sd	s4,0(sp)
    80002bf2:	1800                	addi	s0,sp,48
    80002bf4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bf6:	05050493          	addi	s1,a0,80
    80002bfa:	08050913          	addi	s2,a0,128
    80002bfe:	a021                	j	80002c06 <itrunc+0x22>
    80002c00:	0491                	addi	s1,s1,4
    80002c02:	01248d63          	beq	s1,s2,80002c1c <itrunc+0x38>
    if(ip->addrs[i]){
    80002c06:	408c                	lw	a1,0(s1)
    80002c08:	dde5                	beqz	a1,80002c00 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c0a:	0009a503          	lw	a0,0(s3)
    80002c0e:	00000097          	auipc	ra,0x0
    80002c12:	90c080e7          	jalr	-1780(ra) # 8000251a <bfree>
      ip->addrs[i] = 0;
    80002c16:	0004a023          	sw	zero,0(s1)
    80002c1a:	b7dd                	j	80002c00 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c1c:	0809a583          	lw	a1,128(s3)
    80002c20:	e185                	bnez	a1,80002c40 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c22:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c26:	854e                	mv	a0,s3
    80002c28:	00000097          	auipc	ra,0x0
    80002c2c:	de4080e7          	jalr	-540(ra) # 80002a0c <iupdate>
}
    80002c30:	70a2                	ld	ra,40(sp)
    80002c32:	7402                	ld	s0,32(sp)
    80002c34:	64e2                	ld	s1,24(sp)
    80002c36:	6942                	ld	s2,16(sp)
    80002c38:	69a2                	ld	s3,8(sp)
    80002c3a:	6a02                	ld	s4,0(sp)
    80002c3c:	6145                	addi	sp,sp,48
    80002c3e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c40:	0009a503          	lw	a0,0(s3)
    80002c44:	fffff097          	auipc	ra,0xfffff
    80002c48:	690080e7          	jalr	1680(ra) # 800022d4 <bread>
    80002c4c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c4e:	05850493          	addi	s1,a0,88
    80002c52:	45850913          	addi	s2,a0,1112
    80002c56:	a811                	j	80002c6a <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002c58:	0009a503          	lw	a0,0(s3)
    80002c5c:	00000097          	auipc	ra,0x0
    80002c60:	8be080e7          	jalr	-1858(ra) # 8000251a <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002c64:	0491                	addi	s1,s1,4
    80002c66:	01248563          	beq	s1,s2,80002c70 <itrunc+0x8c>
      if(a[j])
    80002c6a:	408c                	lw	a1,0(s1)
    80002c6c:	dde5                	beqz	a1,80002c64 <itrunc+0x80>
    80002c6e:	b7ed                	j	80002c58 <itrunc+0x74>
    brelse(bp);
    80002c70:	8552                	mv	a0,s4
    80002c72:	fffff097          	auipc	ra,0xfffff
    80002c76:	792080e7          	jalr	1938(ra) # 80002404 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c7a:	0809a583          	lw	a1,128(s3)
    80002c7e:	0009a503          	lw	a0,0(s3)
    80002c82:	00000097          	auipc	ra,0x0
    80002c86:	898080e7          	jalr	-1896(ra) # 8000251a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c8a:	0809a023          	sw	zero,128(s3)
    80002c8e:	bf51                	j	80002c22 <itrunc+0x3e>

0000000080002c90 <iput>:
{
    80002c90:	1101                	addi	sp,sp,-32
    80002c92:	ec06                	sd	ra,24(sp)
    80002c94:	e822                	sd	s0,16(sp)
    80002c96:	e426                	sd	s1,8(sp)
    80002c98:	e04a                	sd	s2,0(sp)
    80002c9a:	1000                	addi	s0,sp,32
    80002c9c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c9e:	00015517          	auipc	a0,0x15
    80002ca2:	ada50513          	addi	a0,a0,-1318 # 80017778 <itable>
    80002ca6:	00003097          	auipc	ra,0x3
    80002caa:	42c080e7          	jalr	1068(ra) # 800060d2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cae:	4498                	lw	a4,8(s1)
    80002cb0:	4785                	li	a5,1
    80002cb2:	02f70363          	beq	a4,a5,80002cd8 <iput+0x48>
  ip->ref--;
    80002cb6:	449c                	lw	a5,8(s1)
    80002cb8:	37fd                	addiw	a5,a5,-1
    80002cba:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cbc:	00015517          	auipc	a0,0x15
    80002cc0:	abc50513          	addi	a0,a0,-1348 # 80017778 <itable>
    80002cc4:	00003097          	auipc	ra,0x3
    80002cc8:	4c2080e7          	jalr	1218(ra) # 80006186 <release>
}
    80002ccc:	60e2                	ld	ra,24(sp)
    80002cce:	6442                	ld	s0,16(sp)
    80002cd0:	64a2                	ld	s1,8(sp)
    80002cd2:	6902                	ld	s2,0(sp)
    80002cd4:	6105                	addi	sp,sp,32
    80002cd6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cd8:	40bc                	lw	a5,64(s1)
    80002cda:	dff1                	beqz	a5,80002cb6 <iput+0x26>
    80002cdc:	04a49783          	lh	a5,74(s1)
    80002ce0:	fbf9                	bnez	a5,80002cb6 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ce2:	01048913          	addi	s2,s1,16
    80002ce6:	854a                	mv	a0,s2
    80002ce8:	00001097          	auipc	ra,0x1
    80002cec:	ab8080e7          	jalr	-1352(ra) # 800037a0 <acquiresleep>
    release(&itable.lock);
    80002cf0:	00015517          	auipc	a0,0x15
    80002cf4:	a8850513          	addi	a0,a0,-1400 # 80017778 <itable>
    80002cf8:	00003097          	auipc	ra,0x3
    80002cfc:	48e080e7          	jalr	1166(ra) # 80006186 <release>
    itrunc(ip);
    80002d00:	8526                	mv	a0,s1
    80002d02:	00000097          	auipc	ra,0x0
    80002d06:	ee2080e7          	jalr	-286(ra) # 80002be4 <itrunc>
    ip->type = 0;
    80002d0a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d0e:	8526                	mv	a0,s1
    80002d10:	00000097          	auipc	ra,0x0
    80002d14:	cfc080e7          	jalr	-772(ra) # 80002a0c <iupdate>
    ip->valid = 0;
    80002d18:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	00001097          	auipc	ra,0x1
    80002d22:	ad8080e7          	jalr	-1320(ra) # 800037f6 <releasesleep>
    acquire(&itable.lock);
    80002d26:	00015517          	auipc	a0,0x15
    80002d2a:	a5250513          	addi	a0,a0,-1454 # 80017778 <itable>
    80002d2e:	00003097          	auipc	ra,0x3
    80002d32:	3a4080e7          	jalr	932(ra) # 800060d2 <acquire>
    80002d36:	b741                	j	80002cb6 <iput+0x26>

0000000080002d38 <iunlockput>:
{
    80002d38:	1101                	addi	sp,sp,-32
    80002d3a:	ec06                	sd	ra,24(sp)
    80002d3c:	e822                	sd	s0,16(sp)
    80002d3e:	e426                	sd	s1,8(sp)
    80002d40:	1000                	addi	s0,sp,32
    80002d42:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d44:	00000097          	auipc	ra,0x0
    80002d48:	e54080e7          	jalr	-428(ra) # 80002b98 <iunlock>
  iput(ip);
    80002d4c:	8526                	mv	a0,s1
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	f42080e7          	jalr	-190(ra) # 80002c90 <iput>
}
    80002d56:	60e2                	ld	ra,24(sp)
    80002d58:	6442                	ld	s0,16(sp)
    80002d5a:	64a2                	ld	s1,8(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret

0000000080002d60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d60:	1141                	addi	sp,sp,-16
    80002d62:	e422                	sd	s0,8(sp)
    80002d64:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d66:	411c                	lw	a5,0(a0)
    80002d68:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d6a:	415c                	lw	a5,4(a0)
    80002d6c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d6e:	04451783          	lh	a5,68(a0)
    80002d72:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d76:	04a51783          	lh	a5,74(a0)
    80002d7a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d7e:	04c56783          	lwu	a5,76(a0)
    80002d82:	e99c                	sd	a5,16(a1)
}
    80002d84:	6422                	ld	s0,8(sp)
    80002d86:	0141                	addi	sp,sp,16
    80002d88:	8082                	ret

0000000080002d8a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d8a:	457c                	lw	a5,76(a0)
    80002d8c:	0ed7e963          	bltu	a5,a3,80002e7e <readi+0xf4>
{
    80002d90:	7159                	addi	sp,sp,-112
    80002d92:	f486                	sd	ra,104(sp)
    80002d94:	f0a2                	sd	s0,96(sp)
    80002d96:	eca6                	sd	s1,88(sp)
    80002d98:	e8ca                	sd	s2,80(sp)
    80002d9a:	e4ce                	sd	s3,72(sp)
    80002d9c:	e0d2                	sd	s4,64(sp)
    80002d9e:	fc56                	sd	s5,56(sp)
    80002da0:	f85a                	sd	s6,48(sp)
    80002da2:	f45e                	sd	s7,40(sp)
    80002da4:	f062                	sd	s8,32(sp)
    80002da6:	ec66                	sd	s9,24(sp)
    80002da8:	e86a                	sd	s10,16(sp)
    80002daa:	e46e                	sd	s11,8(sp)
    80002dac:	1880                	addi	s0,sp,112
    80002dae:	8baa                	mv	s7,a0
    80002db0:	8c2e                	mv	s8,a1
    80002db2:	8ab2                	mv	s5,a2
    80002db4:	84b6                	mv	s1,a3
    80002db6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002db8:	9f35                	addw	a4,a4,a3
    return 0;
    80002dba:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dbc:	0ad76063          	bltu	a4,a3,80002e5c <readi+0xd2>
  if(off + n > ip->size)
    80002dc0:	00e7f463          	bgeu	a5,a4,80002dc8 <readi+0x3e>
    n = ip->size - off;
    80002dc4:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dc8:	0a0b0963          	beqz	s6,80002e7a <readi+0xf0>
    80002dcc:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dce:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dd2:	5cfd                	li	s9,-1
    80002dd4:	a82d                	j	80002e0e <readi+0x84>
    80002dd6:	020a1d93          	slli	s11,s4,0x20
    80002dda:	020ddd93          	srli	s11,s11,0x20
    80002dde:	05890613          	addi	a2,s2,88
    80002de2:	86ee                	mv	a3,s11
    80002de4:	963a                	add	a2,a2,a4
    80002de6:	85d6                	mv	a1,s5
    80002de8:	8562                	mv	a0,s8
    80002dea:	fffff097          	auipc	ra,0xfffff
    80002dee:	ac6080e7          	jalr	-1338(ra) # 800018b0 <either_copyout>
    80002df2:	05950d63          	beq	a0,s9,80002e4c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002df6:	854a                	mv	a0,s2
    80002df8:	fffff097          	auipc	ra,0xfffff
    80002dfc:	60c080e7          	jalr	1548(ra) # 80002404 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e00:	013a09bb          	addw	s3,s4,s3
    80002e04:	009a04bb          	addw	s1,s4,s1
    80002e08:	9aee                	add	s5,s5,s11
    80002e0a:	0569f763          	bgeu	s3,s6,80002e58 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e0e:	000ba903          	lw	s2,0(s7)
    80002e12:	00a4d59b          	srliw	a1,s1,0xa
    80002e16:	855e                	mv	a0,s7
    80002e18:	00000097          	auipc	ra,0x0
    80002e1c:	8b0080e7          	jalr	-1872(ra) # 800026c8 <bmap>
    80002e20:	0005059b          	sext.w	a1,a0
    80002e24:	854a                	mv	a0,s2
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	4ae080e7          	jalr	1198(ra) # 800022d4 <bread>
    80002e2e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e30:	3ff4f713          	andi	a4,s1,1023
    80002e34:	40ed07bb          	subw	a5,s10,a4
    80002e38:	413b06bb          	subw	a3,s6,s3
    80002e3c:	8a3e                	mv	s4,a5
    80002e3e:	2781                	sext.w	a5,a5
    80002e40:	0006861b          	sext.w	a2,a3
    80002e44:	f8f679e3          	bgeu	a2,a5,80002dd6 <readi+0x4c>
    80002e48:	8a36                	mv	s4,a3
    80002e4a:	b771                	j	80002dd6 <readi+0x4c>
      brelse(bp);
    80002e4c:	854a                	mv	a0,s2
    80002e4e:	fffff097          	auipc	ra,0xfffff
    80002e52:	5b6080e7          	jalr	1462(ra) # 80002404 <brelse>
      tot = -1;
    80002e56:	59fd                	li	s3,-1
  }
  return tot;
    80002e58:	0009851b          	sext.w	a0,s3
}
    80002e5c:	70a6                	ld	ra,104(sp)
    80002e5e:	7406                	ld	s0,96(sp)
    80002e60:	64e6                	ld	s1,88(sp)
    80002e62:	6946                	ld	s2,80(sp)
    80002e64:	69a6                	ld	s3,72(sp)
    80002e66:	6a06                	ld	s4,64(sp)
    80002e68:	7ae2                	ld	s5,56(sp)
    80002e6a:	7b42                	ld	s6,48(sp)
    80002e6c:	7ba2                	ld	s7,40(sp)
    80002e6e:	7c02                	ld	s8,32(sp)
    80002e70:	6ce2                	ld	s9,24(sp)
    80002e72:	6d42                	ld	s10,16(sp)
    80002e74:	6da2                	ld	s11,8(sp)
    80002e76:	6165                	addi	sp,sp,112
    80002e78:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e7a:	89da                	mv	s3,s6
    80002e7c:	bff1                	j	80002e58 <readi+0xce>
    return 0;
    80002e7e:	4501                	li	a0,0
}
    80002e80:	8082                	ret

0000000080002e82 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e82:	457c                	lw	a5,76(a0)
    80002e84:	10d7e863          	bltu	a5,a3,80002f94 <writei+0x112>
{
    80002e88:	7159                	addi	sp,sp,-112
    80002e8a:	f486                	sd	ra,104(sp)
    80002e8c:	f0a2                	sd	s0,96(sp)
    80002e8e:	eca6                	sd	s1,88(sp)
    80002e90:	e8ca                	sd	s2,80(sp)
    80002e92:	e4ce                	sd	s3,72(sp)
    80002e94:	e0d2                	sd	s4,64(sp)
    80002e96:	fc56                	sd	s5,56(sp)
    80002e98:	f85a                	sd	s6,48(sp)
    80002e9a:	f45e                	sd	s7,40(sp)
    80002e9c:	f062                	sd	s8,32(sp)
    80002e9e:	ec66                	sd	s9,24(sp)
    80002ea0:	e86a                	sd	s10,16(sp)
    80002ea2:	e46e                	sd	s11,8(sp)
    80002ea4:	1880                	addi	s0,sp,112
    80002ea6:	8b2a                	mv	s6,a0
    80002ea8:	8c2e                	mv	s8,a1
    80002eaa:	8ab2                	mv	s5,a2
    80002eac:	8936                	mv	s2,a3
    80002eae:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002eb0:	00e687bb          	addw	a5,a3,a4
    80002eb4:	0ed7e263          	bltu	a5,a3,80002f98 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002eb8:	00043737          	lui	a4,0x43
    80002ebc:	0ef76063          	bltu	a4,a5,80002f9c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ec0:	0c0b8863          	beqz	s7,80002f90 <writei+0x10e>
    80002ec4:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec6:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002eca:	5cfd                	li	s9,-1
    80002ecc:	a091                	j	80002f10 <writei+0x8e>
    80002ece:	02099d93          	slli	s11,s3,0x20
    80002ed2:	020ddd93          	srli	s11,s11,0x20
    80002ed6:	05848513          	addi	a0,s1,88
    80002eda:	86ee                	mv	a3,s11
    80002edc:	8656                	mv	a2,s5
    80002ede:	85e2                	mv	a1,s8
    80002ee0:	953a                	add	a0,a0,a4
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	a24080e7          	jalr	-1500(ra) # 80001906 <either_copyin>
    80002eea:	07950263          	beq	a0,s9,80002f4e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002eee:	8526                	mv	a0,s1
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	790080e7          	jalr	1936(ra) # 80003680 <log_write>
    brelse(bp);
    80002ef8:	8526                	mv	a0,s1
    80002efa:	fffff097          	auipc	ra,0xfffff
    80002efe:	50a080e7          	jalr	1290(ra) # 80002404 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f02:	01498a3b          	addw	s4,s3,s4
    80002f06:	0129893b          	addw	s2,s3,s2
    80002f0a:	9aee                	add	s5,s5,s11
    80002f0c:	057a7663          	bgeu	s4,s7,80002f58 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f10:	000b2483          	lw	s1,0(s6)
    80002f14:	00a9559b          	srliw	a1,s2,0xa
    80002f18:	855a                	mv	a0,s6
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	7ae080e7          	jalr	1966(ra) # 800026c8 <bmap>
    80002f22:	0005059b          	sext.w	a1,a0
    80002f26:	8526                	mv	a0,s1
    80002f28:	fffff097          	auipc	ra,0xfffff
    80002f2c:	3ac080e7          	jalr	940(ra) # 800022d4 <bread>
    80002f30:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f32:	3ff97713          	andi	a4,s2,1023
    80002f36:	40ed07bb          	subw	a5,s10,a4
    80002f3a:	414b86bb          	subw	a3,s7,s4
    80002f3e:	89be                	mv	s3,a5
    80002f40:	2781                	sext.w	a5,a5
    80002f42:	0006861b          	sext.w	a2,a3
    80002f46:	f8f674e3          	bgeu	a2,a5,80002ece <writei+0x4c>
    80002f4a:	89b6                	mv	s3,a3
    80002f4c:	b749                	j	80002ece <writei+0x4c>
      brelse(bp);
    80002f4e:	8526                	mv	a0,s1
    80002f50:	fffff097          	auipc	ra,0xfffff
    80002f54:	4b4080e7          	jalr	1204(ra) # 80002404 <brelse>
  }

  if(off > ip->size)
    80002f58:	04cb2783          	lw	a5,76(s6)
    80002f5c:	0127f463          	bgeu	a5,s2,80002f64 <writei+0xe2>
    ip->size = off;
    80002f60:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f64:	855a                	mv	a0,s6
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	aa6080e7          	jalr	-1370(ra) # 80002a0c <iupdate>

  return tot;
    80002f6e:	000a051b          	sext.w	a0,s4
}
    80002f72:	70a6                	ld	ra,104(sp)
    80002f74:	7406                	ld	s0,96(sp)
    80002f76:	64e6                	ld	s1,88(sp)
    80002f78:	6946                	ld	s2,80(sp)
    80002f7a:	69a6                	ld	s3,72(sp)
    80002f7c:	6a06                	ld	s4,64(sp)
    80002f7e:	7ae2                	ld	s5,56(sp)
    80002f80:	7b42                	ld	s6,48(sp)
    80002f82:	7ba2                	ld	s7,40(sp)
    80002f84:	7c02                	ld	s8,32(sp)
    80002f86:	6ce2                	ld	s9,24(sp)
    80002f88:	6d42                	ld	s10,16(sp)
    80002f8a:	6da2                	ld	s11,8(sp)
    80002f8c:	6165                	addi	sp,sp,112
    80002f8e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f90:	8a5e                	mv	s4,s7
    80002f92:	bfc9                	j	80002f64 <writei+0xe2>
    return -1;
    80002f94:	557d                	li	a0,-1
}
    80002f96:	8082                	ret
    return -1;
    80002f98:	557d                	li	a0,-1
    80002f9a:	bfe1                	j	80002f72 <writei+0xf0>
    return -1;
    80002f9c:	557d                	li	a0,-1
    80002f9e:	bfd1                	j	80002f72 <writei+0xf0>

0000000080002fa0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fa0:	1141                	addi	sp,sp,-16
    80002fa2:	e406                	sd	ra,8(sp)
    80002fa4:	e022                	sd	s0,0(sp)
    80002fa6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fa8:	4639                	li	a2,14
    80002faa:	ffffd097          	auipc	ra,0xffffd
    80002fae:	2a6080e7          	jalr	678(ra) # 80000250 <strncmp>
}
    80002fb2:	60a2                	ld	ra,8(sp)
    80002fb4:	6402                	ld	s0,0(sp)
    80002fb6:	0141                	addi	sp,sp,16
    80002fb8:	8082                	ret

0000000080002fba <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fba:	7139                	addi	sp,sp,-64
    80002fbc:	fc06                	sd	ra,56(sp)
    80002fbe:	f822                	sd	s0,48(sp)
    80002fc0:	f426                	sd	s1,40(sp)
    80002fc2:	f04a                	sd	s2,32(sp)
    80002fc4:	ec4e                	sd	s3,24(sp)
    80002fc6:	e852                	sd	s4,16(sp)
    80002fc8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fca:	04451703          	lh	a4,68(a0)
    80002fce:	4785                	li	a5,1
    80002fd0:	00f71a63          	bne	a4,a5,80002fe4 <dirlookup+0x2a>
    80002fd4:	892a                	mv	s2,a0
    80002fd6:	89ae                	mv	s3,a1
    80002fd8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fda:	457c                	lw	a5,76(a0)
    80002fdc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fde:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fe0:	e79d                	bnez	a5,8000300e <dirlookup+0x54>
    80002fe2:	a8a5                	j	8000305a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fe4:	00005517          	auipc	a0,0x5
    80002fe8:	6fc50513          	addi	a0,a0,1788 # 800086e0 <syscall_names+0x1a8>
    80002fec:	00003097          	auipc	ra,0x3
    80002ff0:	b9c080e7          	jalr	-1124(ra) # 80005b88 <panic>
      panic("dirlookup read");
    80002ff4:	00005517          	auipc	a0,0x5
    80002ff8:	70450513          	addi	a0,a0,1796 # 800086f8 <syscall_names+0x1c0>
    80002ffc:	00003097          	auipc	ra,0x3
    80003000:	b8c080e7          	jalr	-1140(ra) # 80005b88 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003004:	24c1                	addiw	s1,s1,16
    80003006:	04c92783          	lw	a5,76(s2)
    8000300a:	04f4f763          	bgeu	s1,a5,80003058 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000300e:	4741                	li	a4,16
    80003010:	86a6                	mv	a3,s1
    80003012:	fc040613          	addi	a2,s0,-64
    80003016:	4581                	li	a1,0
    80003018:	854a                	mv	a0,s2
    8000301a:	00000097          	auipc	ra,0x0
    8000301e:	d70080e7          	jalr	-656(ra) # 80002d8a <readi>
    80003022:	47c1                	li	a5,16
    80003024:	fcf518e3          	bne	a0,a5,80002ff4 <dirlookup+0x3a>
    if(de.inum == 0)
    80003028:	fc045783          	lhu	a5,-64(s0)
    8000302c:	dfe1                	beqz	a5,80003004 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000302e:	fc240593          	addi	a1,s0,-62
    80003032:	854e                	mv	a0,s3
    80003034:	00000097          	auipc	ra,0x0
    80003038:	f6c080e7          	jalr	-148(ra) # 80002fa0 <namecmp>
    8000303c:	f561                	bnez	a0,80003004 <dirlookup+0x4a>
      if(poff)
    8000303e:	000a0463          	beqz	s4,80003046 <dirlookup+0x8c>
        *poff = off;
    80003042:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003046:	fc045583          	lhu	a1,-64(s0)
    8000304a:	00092503          	lw	a0,0(s2)
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	754080e7          	jalr	1876(ra) # 800027a2 <iget>
    80003056:	a011                	j	8000305a <dirlookup+0xa0>
  return 0;
    80003058:	4501                	li	a0,0
}
    8000305a:	70e2                	ld	ra,56(sp)
    8000305c:	7442                	ld	s0,48(sp)
    8000305e:	74a2                	ld	s1,40(sp)
    80003060:	7902                	ld	s2,32(sp)
    80003062:	69e2                	ld	s3,24(sp)
    80003064:	6a42                	ld	s4,16(sp)
    80003066:	6121                	addi	sp,sp,64
    80003068:	8082                	ret

000000008000306a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000306a:	711d                	addi	sp,sp,-96
    8000306c:	ec86                	sd	ra,88(sp)
    8000306e:	e8a2                	sd	s0,80(sp)
    80003070:	e4a6                	sd	s1,72(sp)
    80003072:	e0ca                	sd	s2,64(sp)
    80003074:	fc4e                	sd	s3,56(sp)
    80003076:	f852                	sd	s4,48(sp)
    80003078:	f456                	sd	s5,40(sp)
    8000307a:	f05a                	sd	s6,32(sp)
    8000307c:	ec5e                	sd	s7,24(sp)
    8000307e:	e862                	sd	s8,16(sp)
    80003080:	e466                	sd	s9,8(sp)
    80003082:	1080                	addi	s0,sp,96
    80003084:	84aa                	mv	s1,a0
    80003086:	8b2e                	mv	s6,a1
    80003088:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000308a:	00054703          	lbu	a4,0(a0)
    8000308e:	02f00793          	li	a5,47
    80003092:	02f70363          	beq	a4,a5,800030b8 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003096:	ffffe097          	auipc	ra,0xffffe
    8000309a:	db2080e7          	jalr	-590(ra) # 80000e48 <myproc>
    8000309e:	15053503          	ld	a0,336(a0)
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	9f6080e7          	jalr	-1546(ra) # 80002a98 <idup>
    800030aa:	89aa                	mv	s3,a0
  while(*path == '/')
    800030ac:	02f00913          	li	s2,47
  len = path - s;
    800030b0:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800030b2:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030b4:	4c05                	li	s8,1
    800030b6:	a865                	j	8000316e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800030b8:	4585                	li	a1,1
    800030ba:	4505                	li	a0,1
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	6e6080e7          	jalr	1766(ra) # 800027a2 <iget>
    800030c4:	89aa                	mv	s3,a0
    800030c6:	b7dd                	j	800030ac <namex+0x42>
      iunlockput(ip);
    800030c8:	854e                	mv	a0,s3
    800030ca:	00000097          	auipc	ra,0x0
    800030ce:	c6e080e7          	jalr	-914(ra) # 80002d38 <iunlockput>
      return 0;
    800030d2:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030d4:	854e                	mv	a0,s3
    800030d6:	60e6                	ld	ra,88(sp)
    800030d8:	6446                	ld	s0,80(sp)
    800030da:	64a6                	ld	s1,72(sp)
    800030dc:	6906                	ld	s2,64(sp)
    800030de:	79e2                	ld	s3,56(sp)
    800030e0:	7a42                	ld	s4,48(sp)
    800030e2:	7aa2                	ld	s5,40(sp)
    800030e4:	7b02                	ld	s6,32(sp)
    800030e6:	6be2                	ld	s7,24(sp)
    800030e8:	6c42                	ld	s8,16(sp)
    800030ea:	6ca2                	ld	s9,8(sp)
    800030ec:	6125                	addi	sp,sp,96
    800030ee:	8082                	ret
      iunlock(ip);
    800030f0:	854e                	mv	a0,s3
    800030f2:	00000097          	auipc	ra,0x0
    800030f6:	aa6080e7          	jalr	-1370(ra) # 80002b98 <iunlock>
      return ip;
    800030fa:	bfe9                	j	800030d4 <namex+0x6a>
      iunlockput(ip);
    800030fc:	854e                	mv	a0,s3
    800030fe:	00000097          	auipc	ra,0x0
    80003102:	c3a080e7          	jalr	-966(ra) # 80002d38 <iunlockput>
      return 0;
    80003106:	89d2                	mv	s3,s4
    80003108:	b7f1                	j	800030d4 <namex+0x6a>
  len = path - s;
    8000310a:	40b48633          	sub	a2,s1,a1
    8000310e:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003112:	094cd463          	bge	s9,s4,8000319a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003116:	4639                	li	a2,14
    80003118:	8556                	mv	a0,s5
    8000311a:	ffffd097          	auipc	ra,0xffffd
    8000311e:	0be080e7          	jalr	190(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003122:	0004c783          	lbu	a5,0(s1)
    80003126:	01279763          	bne	a5,s2,80003134 <namex+0xca>
    path++;
    8000312a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000312c:	0004c783          	lbu	a5,0(s1)
    80003130:	ff278de3          	beq	a5,s2,8000312a <namex+0xc0>
    ilock(ip);
    80003134:	854e                	mv	a0,s3
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	9a0080e7          	jalr	-1632(ra) # 80002ad6 <ilock>
    if(ip->type != T_DIR){
    8000313e:	04499783          	lh	a5,68(s3)
    80003142:	f98793e3          	bne	a5,s8,800030c8 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003146:	000b0563          	beqz	s6,80003150 <namex+0xe6>
    8000314a:	0004c783          	lbu	a5,0(s1)
    8000314e:	d3cd                	beqz	a5,800030f0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003150:	865e                	mv	a2,s7
    80003152:	85d6                	mv	a1,s5
    80003154:	854e                	mv	a0,s3
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	e64080e7          	jalr	-412(ra) # 80002fba <dirlookup>
    8000315e:	8a2a                	mv	s4,a0
    80003160:	dd51                	beqz	a0,800030fc <namex+0x92>
    iunlockput(ip);
    80003162:	854e                	mv	a0,s3
    80003164:	00000097          	auipc	ra,0x0
    80003168:	bd4080e7          	jalr	-1068(ra) # 80002d38 <iunlockput>
    ip = next;
    8000316c:	89d2                	mv	s3,s4
  while(*path == '/')
    8000316e:	0004c783          	lbu	a5,0(s1)
    80003172:	05279763          	bne	a5,s2,800031c0 <namex+0x156>
    path++;
    80003176:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003178:	0004c783          	lbu	a5,0(s1)
    8000317c:	ff278de3          	beq	a5,s2,80003176 <namex+0x10c>
  if(*path == 0)
    80003180:	c79d                	beqz	a5,800031ae <namex+0x144>
    path++;
    80003182:	85a6                	mv	a1,s1
  len = path - s;
    80003184:	8a5e                	mv	s4,s7
    80003186:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003188:	01278963          	beq	a5,s2,8000319a <namex+0x130>
    8000318c:	dfbd                	beqz	a5,8000310a <namex+0xa0>
    path++;
    8000318e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003190:	0004c783          	lbu	a5,0(s1)
    80003194:	ff279ce3          	bne	a5,s2,8000318c <namex+0x122>
    80003198:	bf8d                	j	8000310a <namex+0xa0>
    memmove(name, s, len);
    8000319a:	2601                	sext.w	a2,a2
    8000319c:	8556                	mv	a0,s5
    8000319e:	ffffd097          	auipc	ra,0xffffd
    800031a2:	03a080e7          	jalr	58(ra) # 800001d8 <memmove>
    name[len] = 0;
    800031a6:	9a56                	add	s4,s4,s5
    800031a8:	000a0023          	sb	zero,0(s4)
    800031ac:	bf9d                	j	80003122 <namex+0xb8>
  if(nameiparent){
    800031ae:	f20b03e3          	beqz	s6,800030d4 <namex+0x6a>
    iput(ip);
    800031b2:	854e                	mv	a0,s3
    800031b4:	00000097          	auipc	ra,0x0
    800031b8:	adc080e7          	jalr	-1316(ra) # 80002c90 <iput>
    return 0;
    800031bc:	4981                	li	s3,0
    800031be:	bf19                	j	800030d4 <namex+0x6a>
  if(*path == 0)
    800031c0:	d7fd                	beqz	a5,800031ae <namex+0x144>
  while(*path != '/' && *path != 0)
    800031c2:	0004c783          	lbu	a5,0(s1)
    800031c6:	85a6                	mv	a1,s1
    800031c8:	b7d1                	j	8000318c <namex+0x122>

00000000800031ca <dirlink>:
{
    800031ca:	7139                	addi	sp,sp,-64
    800031cc:	fc06                	sd	ra,56(sp)
    800031ce:	f822                	sd	s0,48(sp)
    800031d0:	f426                	sd	s1,40(sp)
    800031d2:	f04a                	sd	s2,32(sp)
    800031d4:	ec4e                	sd	s3,24(sp)
    800031d6:	e852                	sd	s4,16(sp)
    800031d8:	0080                	addi	s0,sp,64
    800031da:	892a                	mv	s2,a0
    800031dc:	8a2e                	mv	s4,a1
    800031de:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031e0:	4601                	li	a2,0
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	dd8080e7          	jalr	-552(ra) # 80002fba <dirlookup>
    800031ea:	e93d                	bnez	a0,80003260 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031ec:	04c92483          	lw	s1,76(s2)
    800031f0:	c49d                	beqz	s1,8000321e <dirlink+0x54>
    800031f2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031f4:	4741                	li	a4,16
    800031f6:	86a6                	mv	a3,s1
    800031f8:	fc040613          	addi	a2,s0,-64
    800031fc:	4581                	li	a1,0
    800031fe:	854a                	mv	a0,s2
    80003200:	00000097          	auipc	ra,0x0
    80003204:	b8a080e7          	jalr	-1142(ra) # 80002d8a <readi>
    80003208:	47c1                	li	a5,16
    8000320a:	06f51163          	bne	a0,a5,8000326c <dirlink+0xa2>
    if(de.inum == 0)
    8000320e:	fc045783          	lhu	a5,-64(s0)
    80003212:	c791                	beqz	a5,8000321e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003214:	24c1                	addiw	s1,s1,16
    80003216:	04c92783          	lw	a5,76(s2)
    8000321a:	fcf4ede3          	bltu	s1,a5,800031f4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000321e:	4639                	li	a2,14
    80003220:	85d2                	mv	a1,s4
    80003222:	fc240513          	addi	a0,s0,-62
    80003226:	ffffd097          	auipc	ra,0xffffd
    8000322a:	066080e7          	jalr	102(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000322e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003232:	4741                	li	a4,16
    80003234:	86a6                	mv	a3,s1
    80003236:	fc040613          	addi	a2,s0,-64
    8000323a:	4581                	li	a1,0
    8000323c:	854a                	mv	a0,s2
    8000323e:	00000097          	auipc	ra,0x0
    80003242:	c44080e7          	jalr	-956(ra) # 80002e82 <writei>
    80003246:	872a                	mv	a4,a0
    80003248:	47c1                	li	a5,16
  return 0;
    8000324a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324c:	02f71863          	bne	a4,a5,8000327c <dirlink+0xb2>
}
    80003250:	70e2                	ld	ra,56(sp)
    80003252:	7442                	ld	s0,48(sp)
    80003254:	74a2                	ld	s1,40(sp)
    80003256:	7902                	ld	s2,32(sp)
    80003258:	69e2                	ld	s3,24(sp)
    8000325a:	6a42                	ld	s4,16(sp)
    8000325c:	6121                	addi	sp,sp,64
    8000325e:	8082                	ret
    iput(ip);
    80003260:	00000097          	auipc	ra,0x0
    80003264:	a30080e7          	jalr	-1488(ra) # 80002c90 <iput>
    return -1;
    80003268:	557d                	li	a0,-1
    8000326a:	b7dd                	j	80003250 <dirlink+0x86>
      panic("dirlink read");
    8000326c:	00005517          	auipc	a0,0x5
    80003270:	49c50513          	addi	a0,a0,1180 # 80008708 <syscall_names+0x1d0>
    80003274:	00003097          	auipc	ra,0x3
    80003278:	914080e7          	jalr	-1772(ra) # 80005b88 <panic>
    panic("dirlink");
    8000327c:	00005517          	auipc	a0,0x5
    80003280:	59450513          	addi	a0,a0,1428 # 80008810 <syscall_names+0x2d8>
    80003284:	00003097          	auipc	ra,0x3
    80003288:	904080e7          	jalr	-1788(ra) # 80005b88 <panic>

000000008000328c <namei>:

struct inode*
namei(char *path)
{
    8000328c:	1101                	addi	sp,sp,-32
    8000328e:	ec06                	sd	ra,24(sp)
    80003290:	e822                	sd	s0,16(sp)
    80003292:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003294:	fe040613          	addi	a2,s0,-32
    80003298:	4581                	li	a1,0
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	dd0080e7          	jalr	-560(ra) # 8000306a <namex>
}
    800032a2:	60e2                	ld	ra,24(sp)
    800032a4:	6442                	ld	s0,16(sp)
    800032a6:	6105                	addi	sp,sp,32
    800032a8:	8082                	ret

00000000800032aa <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032aa:	1141                	addi	sp,sp,-16
    800032ac:	e406                	sd	ra,8(sp)
    800032ae:	e022                	sd	s0,0(sp)
    800032b0:	0800                	addi	s0,sp,16
    800032b2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032b4:	4585                	li	a1,1
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	db4080e7          	jalr	-588(ra) # 8000306a <namex>
}
    800032be:	60a2                	ld	ra,8(sp)
    800032c0:	6402                	ld	s0,0(sp)
    800032c2:	0141                	addi	sp,sp,16
    800032c4:	8082                	ret

00000000800032c6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032c6:	1101                	addi	sp,sp,-32
    800032c8:	ec06                	sd	ra,24(sp)
    800032ca:	e822                	sd	s0,16(sp)
    800032cc:	e426                	sd	s1,8(sp)
    800032ce:	e04a                	sd	s2,0(sp)
    800032d0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032d2:	00016917          	auipc	s2,0x16
    800032d6:	f4e90913          	addi	s2,s2,-178 # 80019220 <log>
    800032da:	01892583          	lw	a1,24(s2)
    800032de:	02892503          	lw	a0,40(s2)
    800032e2:	fffff097          	auipc	ra,0xfffff
    800032e6:	ff2080e7          	jalr	-14(ra) # 800022d4 <bread>
    800032ea:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032ec:	02c92683          	lw	a3,44(s2)
    800032f0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032f2:	02d05763          	blez	a3,80003320 <write_head+0x5a>
    800032f6:	00016797          	auipc	a5,0x16
    800032fa:	f5a78793          	addi	a5,a5,-166 # 80019250 <log+0x30>
    800032fe:	05c50713          	addi	a4,a0,92
    80003302:	36fd                	addiw	a3,a3,-1
    80003304:	1682                	slli	a3,a3,0x20
    80003306:	9281                	srli	a3,a3,0x20
    80003308:	068a                	slli	a3,a3,0x2
    8000330a:	00016617          	auipc	a2,0x16
    8000330e:	f4a60613          	addi	a2,a2,-182 # 80019254 <log+0x34>
    80003312:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003314:	4390                	lw	a2,0(a5)
    80003316:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003318:	0791                	addi	a5,a5,4
    8000331a:	0711                	addi	a4,a4,4
    8000331c:	fed79ce3          	bne	a5,a3,80003314 <write_head+0x4e>
  }
  bwrite(buf);
    80003320:	8526                	mv	a0,s1
    80003322:	fffff097          	auipc	ra,0xfffff
    80003326:	0a4080e7          	jalr	164(ra) # 800023c6 <bwrite>
  brelse(buf);
    8000332a:	8526                	mv	a0,s1
    8000332c:	fffff097          	auipc	ra,0xfffff
    80003330:	0d8080e7          	jalr	216(ra) # 80002404 <brelse>
}
    80003334:	60e2                	ld	ra,24(sp)
    80003336:	6442                	ld	s0,16(sp)
    80003338:	64a2                	ld	s1,8(sp)
    8000333a:	6902                	ld	s2,0(sp)
    8000333c:	6105                	addi	sp,sp,32
    8000333e:	8082                	ret

0000000080003340 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003340:	00016797          	auipc	a5,0x16
    80003344:	f0c7a783          	lw	a5,-244(a5) # 8001924c <log+0x2c>
    80003348:	0af05d63          	blez	a5,80003402 <install_trans+0xc2>
{
    8000334c:	7139                	addi	sp,sp,-64
    8000334e:	fc06                	sd	ra,56(sp)
    80003350:	f822                	sd	s0,48(sp)
    80003352:	f426                	sd	s1,40(sp)
    80003354:	f04a                	sd	s2,32(sp)
    80003356:	ec4e                	sd	s3,24(sp)
    80003358:	e852                	sd	s4,16(sp)
    8000335a:	e456                	sd	s5,8(sp)
    8000335c:	e05a                	sd	s6,0(sp)
    8000335e:	0080                	addi	s0,sp,64
    80003360:	8b2a                	mv	s6,a0
    80003362:	00016a97          	auipc	s5,0x16
    80003366:	eeea8a93          	addi	s5,s5,-274 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000336a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000336c:	00016997          	auipc	s3,0x16
    80003370:	eb498993          	addi	s3,s3,-332 # 80019220 <log>
    80003374:	a035                	j	800033a0 <install_trans+0x60>
      bunpin(dbuf);
    80003376:	8526                	mv	a0,s1
    80003378:	fffff097          	auipc	ra,0xfffff
    8000337c:	166080e7          	jalr	358(ra) # 800024de <bunpin>
    brelse(lbuf);
    80003380:	854a                	mv	a0,s2
    80003382:	fffff097          	auipc	ra,0xfffff
    80003386:	082080e7          	jalr	130(ra) # 80002404 <brelse>
    brelse(dbuf);
    8000338a:	8526                	mv	a0,s1
    8000338c:	fffff097          	auipc	ra,0xfffff
    80003390:	078080e7          	jalr	120(ra) # 80002404 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003394:	2a05                	addiw	s4,s4,1
    80003396:	0a91                	addi	s5,s5,4
    80003398:	02c9a783          	lw	a5,44(s3)
    8000339c:	04fa5963          	bge	s4,a5,800033ee <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033a0:	0189a583          	lw	a1,24(s3)
    800033a4:	014585bb          	addw	a1,a1,s4
    800033a8:	2585                	addiw	a1,a1,1
    800033aa:	0289a503          	lw	a0,40(s3)
    800033ae:	fffff097          	auipc	ra,0xfffff
    800033b2:	f26080e7          	jalr	-218(ra) # 800022d4 <bread>
    800033b6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033b8:	000aa583          	lw	a1,0(s5)
    800033bc:	0289a503          	lw	a0,40(s3)
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	f14080e7          	jalr	-236(ra) # 800022d4 <bread>
    800033c8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033ca:	40000613          	li	a2,1024
    800033ce:	05890593          	addi	a1,s2,88
    800033d2:	05850513          	addi	a0,a0,88
    800033d6:	ffffd097          	auipc	ra,0xffffd
    800033da:	e02080e7          	jalr	-510(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033de:	8526                	mv	a0,s1
    800033e0:	fffff097          	auipc	ra,0xfffff
    800033e4:	fe6080e7          	jalr	-26(ra) # 800023c6 <bwrite>
    if(recovering == 0)
    800033e8:	f80b1ce3          	bnez	s6,80003380 <install_trans+0x40>
    800033ec:	b769                	j	80003376 <install_trans+0x36>
}
    800033ee:	70e2                	ld	ra,56(sp)
    800033f0:	7442                	ld	s0,48(sp)
    800033f2:	74a2                	ld	s1,40(sp)
    800033f4:	7902                	ld	s2,32(sp)
    800033f6:	69e2                	ld	s3,24(sp)
    800033f8:	6a42                	ld	s4,16(sp)
    800033fa:	6aa2                	ld	s5,8(sp)
    800033fc:	6b02                	ld	s6,0(sp)
    800033fe:	6121                	addi	sp,sp,64
    80003400:	8082                	ret
    80003402:	8082                	ret

0000000080003404 <initlog>:
{
    80003404:	7179                	addi	sp,sp,-48
    80003406:	f406                	sd	ra,40(sp)
    80003408:	f022                	sd	s0,32(sp)
    8000340a:	ec26                	sd	s1,24(sp)
    8000340c:	e84a                	sd	s2,16(sp)
    8000340e:	e44e                	sd	s3,8(sp)
    80003410:	1800                	addi	s0,sp,48
    80003412:	892a                	mv	s2,a0
    80003414:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003416:	00016497          	auipc	s1,0x16
    8000341a:	e0a48493          	addi	s1,s1,-502 # 80019220 <log>
    8000341e:	00005597          	auipc	a1,0x5
    80003422:	2fa58593          	addi	a1,a1,762 # 80008718 <syscall_names+0x1e0>
    80003426:	8526                	mv	a0,s1
    80003428:	00003097          	auipc	ra,0x3
    8000342c:	c1a080e7          	jalr	-998(ra) # 80006042 <initlock>
  log.start = sb->logstart;
    80003430:	0149a583          	lw	a1,20(s3)
    80003434:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003436:	0109a783          	lw	a5,16(s3)
    8000343a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000343c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003440:	854a                	mv	a0,s2
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	e92080e7          	jalr	-366(ra) # 800022d4 <bread>
  log.lh.n = lh->n;
    8000344a:	4d3c                	lw	a5,88(a0)
    8000344c:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000344e:	02f05563          	blez	a5,80003478 <initlog+0x74>
    80003452:	05c50713          	addi	a4,a0,92
    80003456:	00016697          	auipc	a3,0x16
    8000345a:	dfa68693          	addi	a3,a3,-518 # 80019250 <log+0x30>
    8000345e:	37fd                	addiw	a5,a5,-1
    80003460:	1782                	slli	a5,a5,0x20
    80003462:	9381                	srli	a5,a5,0x20
    80003464:	078a                	slli	a5,a5,0x2
    80003466:	06050613          	addi	a2,a0,96
    8000346a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000346c:	4310                	lw	a2,0(a4)
    8000346e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003470:	0711                	addi	a4,a4,4
    80003472:	0691                	addi	a3,a3,4
    80003474:	fef71ce3          	bne	a4,a5,8000346c <initlog+0x68>
  brelse(buf);
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	f8c080e7          	jalr	-116(ra) # 80002404 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003480:	4505                	li	a0,1
    80003482:	00000097          	auipc	ra,0x0
    80003486:	ebe080e7          	jalr	-322(ra) # 80003340 <install_trans>
  log.lh.n = 0;
    8000348a:	00016797          	auipc	a5,0x16
    8000348e:	dc07a123          	sw	zero,-574(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    80003492:	00000097          	auipc	ra,0x0
    80003496:	e34080e7          	jalr	-460(ra) # 800032c6 <write_head>
}
    8000349a:	70a2                	ld	ra,40(sp)
    8000349c:	7402                	ld	s0,32(sp)
    8000349e:	64e2                	ld	s1,24(sp)
    800034a0:	6942                	ld	s2,16(sp)
    800034a2:	69a2                	ld	s3,8(sp)
    800034a4:	6145                	addi	sp,sp,48
    800034a6:	8082                	ret

00000000800034a8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034a8:	1101                	addi	sp,sp,-32
    800034aa:	ec06                	sd	ra,24(sp)
    800034ac:	e822                	sd	s0,16(sp)
    800034ae:	e426                	sd	s1,8(sp)
    800034b0:	e04a                	sd	s2,0(sp)
    800034b2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034b4:	00016517          	auipc	a0,0x16
    800034b8:	d6c50513          	addi	a0,a0,-660 # 80019220 <log>
    800034bc:	00003097          	auipc	ra,0x3
    800034c0:	c16080e7          	jalr	-1002(ra) # 800060d2 <acquire>
  while(1){
    if(log.committing){
    800034c4:	00016497          	auipc	s1,0x16
    800034c8:	d5c48493          	addi	s1,s1,-676 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034cc:	4979                	li	s2,30
    800034ce:	a039                	j	800034dc <begin_op+0x34>
      sleep(&log, &log.lock);
    800034d0:	85a6                	mv	a1,s1
    800034d2:	8526                	mv	a0,s1
    800034d4:	ffffe097          	auipc	ra,0xffffe
    800034d8:	038080e7          	jalr	56(ra) # 8000150c <sleep>
    if(log.committing){
    800034dc:	50dc                	lw	a5,36(s1)
    800034de:	fbed                	bnez	a5,800034d0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034e0:	509c                	lw	a5,32(s1)
    800034e2:	0017871b          	addiw	a4,a5,1
    800034e6:	0007069b          	sext.w	a3,a4
    800034ea:	0027179b          	slliw	a5,a4,0x2
    800034ee:	9fb9                	addw	a5,a5,a4
    800034f0:	0017979b          	slliw	a5,a5,0x1
    800034f4:	54d8                	lw	a4,44(s1)
    800034f6:	9fb9                	addw	a5,a5,a4
    800034f8:	00f95963          	bge	s2,a5,8000350a <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034fc:	85a6                	mv	a1,s1
    800034fe:	8526                	mv	a0,s1
    80003500:	ffffe097          	auipc	ra,0xffffe
    80003504:	00c080e7          	jalr	12(ra) # 8000150c <sleep>
    80003508:	bfd1                	j	800034dc <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000350a:	00016517          	auipc	a0,0x16
    8000350e:	d1650513          	addi	a0,a0,-746 # 80019220 <log>
    80003512:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003514:	00003097          	auipc	ra,0x3
    80003518:	c72080e7          	jalr	-910(ra) # 80006186 <release>
      break;
    }
  }
}
    8000351c:	60e2                	ld	ra,24(sp)
    8000351e:	6442                	ld	s0,16(sp)
    80003520:	64a2                	ld	s1,8(sp)
    80003522:	6902                	ld	s2,0(sp)
    80003524:	6105                	addi	sp,sp,32
    80003526:	8082                	ret

0000000080003528 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003528:	7139                	addi	sp,sp,-64
    8000352a:	fc06                	sd	ra,56(sp)
    8000352c:	f822                	sd	s0,48(sp)
    8000352e:	f426                	sd	s1,40(sp)
    80003530:	f04a                	sd	s2,32(sp)
    80003532:	ec4e                	sd	s3,24(sp)
    80003534:	e852                	sd	s4,16(sp)
    80003536:	e456                	sd	s5,8(sp)
    80003538:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000353a:	00016497          	auipc	s1,0x16
    8000353e:	ce648493          	addi	s1,s1,-794 # 80019220 <log>
    80003542:	8526                	mv	a0,s1
    80003544:	00003097          	auipc	ra,0x3
    80003548:	b8e080e7          	jalr	-1138(ra) # 800060d2 <acquire>
  log.outstanding -= 1;
    8000354c:	509c                	lw	a5,32(s1)
    8000354e:	37fd                	addiw	a5,a5,-1
    80003550:	0007891b          	sext.w	s2,a5
    80003554:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003556:	50dc                	lw	a5,36(s1)
    80003558:	efb9                	bnez	a5,800035b6 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000355a:	06091663          	bnez	s2,800035c6 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000355e:	00016497          	auipc	s1,0x16
    80003562:	cc248493          	addi	s1,s1,-830 # 80019220 <log>
    80003566:	4785                	li	a5,1
    80003568:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000356a:	8526                	mv	a0,s1
    8000356c:	00003097          	auipc	ra,0x3
    80003570:	c1a080e7          	jalr	-998(ra) # 80006186 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003574:	54dc                	lw	a5,44(s1)
    80003576:	06f04763          	bgtz	a5,800035e4 <end_op+0xbc>
    acquire(&log.lock);
    8000357a:	00016497          	auipc	s1,0x16
    8000357e:	ca648493          	addi	s1,s1,-858 # 80019220 <log>
    80003582:	8526                	mv	a0,s1
    80003584:	00003097          	auipc	ra,0x3
    80003588:	b4e080e7          	jalr	-1202(ra) # 800060d2 <acquire>
    log.committing = 0;
    8000358c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003590:	8526                	mv	a0,s1
    80003592:	ffffe097          	auipc	ra,0xffffe
    80003596:	106080e7          	jalr	262(ra) # 80001698 <wakeup>
    release(&log.lock);
    8000359a:	8526                	mv	a0,s1
    8000359c:	00003097          	auipc	ra,0x3
    800035a0:	bea080e7          	jalr	-1046(ra) # 80006186 <release>
}
    800035a4:	70e2                	ld	ra,56(sp)
    800035a6:	7442                	ld	s0,48(sp)
    800035a8:	74a2                	ld	s1,40(sp)
    800035aa:	7902                	ld	s2,32(sp)
    800035ac:	69e2                	ld	s3,24(sp)
    800035ae:	6a42                	ld	s4,16(sp)
    800035b0:	6aa2                	ld	s5,8(sp)
    800035b2:	6121                	addi	sp,sp,64
    800035b4:	8082                	ret
    panic("log.committing");
    800035b6:	00005517          	auipc	a0,0x5
    800035ba:	16a50513          	addi	a0,a0,362 # 80008720 <syscall_names+0x1e8>
    800035be:	00002097          	auipc	ra,0x2
    800035c2:	5ca080e7          	jalr	1482(ra) # 80005b88 <panic>
    wakeup(&log);
    800035c6:	00016497          	auipc	s1,0x16
    800035ca:	c5a48493          	addi	s1,s1,-934 # 80019220 <log>
    800035ce:	8526                	mv	a0,s1
    800035d0:	ffffe097          	auipc	ra,0xffffe
    800035d4:	0c8080e7          	jalr	200(ra) # 80001698 <wakeup>
  release(&log.lock);
    800035d8:	8526                	mv	a0,s1
    800035da:	00003097          	auipc	ra,0x3
    800035de:	bac080e7          	jalr	-1108(ra) # 80006186 <release>
  if(do_commit){
    800035e2:	b7c9                	j	800035a4 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e4:	00016a97          	auipc	s5,0x16
    800035e8:	c6ca8a93          	addi	s5,s5,-916 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035ec:	00016a17          	auipc	s4,0x16
    800035f0:	c34a0a13          	addi	s4,s4,-972 # 80019220 <log>
    800035f4:	018a2583          	lw	a1,24(s4)
    800035f8:	012585bb          	addw	a1,a1,s2
    800035fc:	2585                	addiw	a1,a1,1
    800035fe:	028a2503          	lw	a0,40(s4)
    80003602:	fffff097          	auipc	ra,0xfffff
    80003606:	cd2080e7          	jalr	-814(ra) # 800022d4 <bread>
    8000360a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000360c:	000aa583          	lw	a1,0(s5)
    80003610:	028a2503          	lw	a0,40(s4)
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	cc0080e7          	jalr	-832(ra) # 800022d4 <bread>
    8000361c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000361e:	40000613          	li	a2,1024
    80003622:	05850593          	addi	a1,a0,88
    80003626:	05848513          	addi	a0,s1,88
    8000362a:	ffffd097          	auipc	ra,0xffffd
    8000362e:	bae080e7          	jalr	-1106(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003632:	8526                	mv	a0,s1
    80003634:	fffff097          	auipc	ra,0xfffff
    80003638:	d92080e7          	jalr	-622(ra) # 800023c6 <bwrite>
    brelse(from);
    8000363c:	854e                	mv	a0,s3
    8000363e:	fffff097          	auipc	ra,0xfffff
    80003642:	dc6080e7          	jalr	-570(ra) # 80002404 <brelse>
    brelse(to);
    80003646:	8526                	mv	a0,s1
    80003648:	fffff097          	auipc	ra,0xfffff
    8000364c:	dbc080e7          	jalr	-580(ra) # 80002404 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003650:	2905                	addiw	s2,s2,1
    80003652:	0a91                	addi	s5,s5,4
    80003654:	02ca2783          	lw	a5,44(s4)
    80003658:	f8f94ee3          	blt	s2,a5,800035f4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000365c:	00000097          	auipc	ra,0x0
    80003660:	c6a080e7          	jalr	-918(ra) # 800032c6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003664:	4501                	li	a0,0
    80003666:	00000097          	auipc	ra,0x0
    8000366a:	cda080e7          	jalr	-806(ra) # 80003340 <install_trans>
    log.lh.n = 0;
    8000366e:	00016797          	auipc	a5,0x16
    80003672:	bc07af23          	sw	zero,-1058(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003676:	00000097          	auipc	ra,0x0
    8000367a:	c50080e7          	jalr	-944(ra) # 800032c6 <write_head>
    8000367e:	bdf5                	j	8000357a <end_op+0x52>

0000000080003680 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003680:	1101                	addi	sp,sp,-32
    80003682:	ec06                	sd	ra,24(sp)
    80003684:	e822                	sd	s0,16(sp)
    80003686:	e426                	sd	s1,8(sp)
    80003688:	e04a                	sd	s2,0(sp)
    8000368a:	1000                	addi	s0,sp,32
    8000368c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000368e:	00016917          	auipc	s2,0x16
    80003692:	b9290913          	addi	s2,s2,-1134 # 80019220 <log>
    80003696:	854a                	mv	a0,s2
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	a3a080e7          	jalr	-1478(ra) # 800060d2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036a0:	02c92603          	lw	a2,44(s2)
    800036a4:	47f5                	li	a5,29
    800036a6:	06c7c563          	blt	a5,a2,80003710 <log_write+0x90>
    800036aa:	00016797          	auipc	a5,0x16
    800036ae:	b927a783          	lw	a5,-1134(a5) # 8001923c <log+0x1c>
    800036b2:	37fd                	addiw	a5,a5,-1
    800036b4:	04f65e63          	bge	a2,a5,80003710 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036b8:	00016797          	auipc	a5,0x16
    800036bc:	b887a783          	lw	a5,-1144(a5) # 80019240 <log+0x20>
    800036c0:	06f05063          	blez	a5,80003720 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036c4:	4781                	li	a5,0
    800036c6:	06c05563          	blez	a2,80003730 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ca:	44cc                	lw	a1,12(s1)
    800036cc:	00016717          	auipc	a4,0x16
    800036d0:	b8470713          	addi	a4,a4,-1148 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036d4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036d6:	4314                	lw	a3,0(a4)
    800036d8:	04b68c63          	beq	a3,a1,80003730 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036dc:	2785                	addiw	a5,a5,1
    800036de:	0711                	addi	a4,a4,4
    800036e0:	fef61be3          	bne	a2,a5,800036d6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036e4:	0621                	addi	a2,a2,8
    800036e6:	060a                	slli	a2,a2,0x2
    800036e8:	00016797          	auipc	a5,0x16
    800036ec:	b3878793          	addi	a5,a5,-1224 # 80019220 <log>
    800036f0:	963e                	add	a2,a2,a5
    800036f2:	44dc                	lw	a5,12(s1)
    800036f4:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036f6:	8526                	mv	a0,s1
    800036f8:	fffff097          	auipc	ra,0xfffff
    800036fc:	daa080e7          	jalr	-598(ra) # 800024a2 <bpin>
    log.lh.n++;
    80003700:	00016717          	auipc	a4,0x16
    80003704:	b2070713          	addi	a4,a4,-1248 # 80019220 <log>
    80003708:	575c                	lw	a5,44(a4)
    8000370a:	2785                	addiw	a5,a5,1
    8000370c:	d75c                	sw	a5,44(a4)
    8000370e:	a835                	j	8000374a <log_write+0xca>
    panic("too big a transaction");
    80003710:	00005517          	auipc	a0,0x5
    80003714:	02050513          	addi	a0,a0,32 # 80008730 <syscall_names+0x1f8>
    80003718:	00002097          	auipc	ra,0x2
    8000371c:	470080e7          	jalr	1136(ra) # 80005b88 <panic>
    panic("log_write outside of trans");
    80003720:	00005517          	auipc	a0,0x5
    80003724:	02850513          	addi	a0,a0,40 # 80008748 <syscall_names+0x210>
    80003728:	00002097          	auipc	ra,0x2
    8000372c:	460080e7          	jalr	1120(ra) # 80005b88 <panic>
  log.lh.block[i] = b->blockno;
    80003730:	00878713          	addi	a4,a5,8
    80003734:	00271693          	slli	a3,a4,0x2
    80003738:	00016717          	auipc	a4,0x16
    8000373c:	ae870713          	addi	a4,a4,-1304 # 80019220 <log>
    80003740:	9736                	add	a4,a4,a3
    80003742:	44d4                	lw	a3,12(s1)
    80003744:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003746:	faf608e3          	beq	a2,a5,800036f6 <log_write+0x76>
  }
  release(&log.lock);
    8000374a:	00016517          	auipc	a0,0x16
    8000374e:	ad650513          	addi	a0,a0,-1322 # 80019220 <log>
    80003752:	00003097          	auipc	ra,0x3
    80003756:	a34080e7          	jalr	-1484(ra) # 80006186 <release>
}
    8000375a:	60e2                	ld	ra,24(sp)
    8000375c:	6442                	ld	s0,16(sp)
    8000375e:	64a2                	ld	s1,8(sp)
    80003760:	6902                	ld	s2,0(sp)
    80003762:	6105                	addi	sp,sp,32
    80003764:	8082                	ret

0000000080003766 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003766:	1101                	addi	sp,sp,-32
    80003768:	ec06                	sd	ra,24(sp)
    8000376a:	e822                	sd	s0,16(sp)
    8000376c:	e426                	sd	s1,8(sp)
    8000376e:	e04a                	sd	s2,0(sp)
    80003770:	1000                	addi	s0,sp,32
    80003772:	84aa                	mv	s1,a0
    80003774:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003776:	00005597          	auipc	a1,0x5
    8000377a:	ff258593          	addi	a1,a1,-14 # 80008768 <syscall_names+0x230>
    8000377e:	0521                	addi	a0,a0,8
    80003780:	00003097          	auipc	ra,0x3
    80003784:	8c2080e7          	jalr	-1854(ra) # 80006042 <initlock>
  lk->name = name;
    80003788:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000378c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003790:	0204a423          	sw	zero,40(s1)
}
    80003794:	60e2                	ld	ra,24(sp)
    80003796:	6442                	ld	s0,16(sp)
    80003798:	64a2                	ld	s1,8(sp)
    8000379a:	6902                	ld	s2,0(sp)
    8000379c:	6105                	addi	sp,sp,32
    8000379e:	8082                	ret

00000000800037a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037a0:	1101                	addi	sp,sp,-32
    800037a2:	ec06                	sd	ra,24(sp)
    800037a4:	e822                	sd	s0,16(sp)
    800037a6:	e426                	sd	s1,8(sp)
    800037a8:	e04a                	sd	s2,0(sp)
    800037aa:	1000                	addi	s0,sp,32
    800037ac:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037ae:	00850913          	addi	s2,a0,8
    800037b2:	854a                	mv	a0,s2
    800037b4:	00003097          	auipc	ra,0x3
    800037b8:	91e080e7          	jalr	-1762(ra) # 800060d2 <acquire>
  while (lk->locked) {
    800037bc:	409c                	lw	a5,0(s1)
    800037be:	cb89                	beqz	a5,800037d0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037c0:	85ca                	mv	a1,s2
    800037c2:	8526                	mv	a0,s1
    800037c4:	ffffe097          	auipc	ra,0xffffe
    800037c8:	d48080e7          	jalr	-696(ra) # 8000150c <sleep>
  while (lk->locked) {
    800037cc:	409c                	lw	a5,0(s1)
    800037ce:	fbed                	bnez	a5,800037c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037d0:	4785                	li	a5,1
    800037d2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037d4:	ffffd097          	auipc	ra,0xffffd
    800037d8:	674080e7          	jalr	1652(ra) # 80000e48 <myproc>
    800037dc:	591c                	lw	a5,48(a0)
    800037de:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037e0:	854a                	mv	a0,s2
    800037e2:	00003097          	auipc	ra,0x3
    800037e6:	9a4080e7          	jalr	-1628(ra) # 80006186 <release>
}
    800037ea:	60e2                	ld	ra,24(sp)
    800037ec:	6442                	ld	s0,16(sp)
    800037ee:	64a2                	ld	s1,8(sp)
    800037f0:	6902                	ld	s2,0(sp)
    800037f2:	6105                	addi	sp,sp,32
    800037f4:	8082                	ret

00000000800037f6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037f6:	1101                	addi	sp,sp,-32
    800037f8:	ec06                	sd	ra,24(sp)
    800037fa:	e822                	sd	s0,16(sp)
    800037fc:	e426                	sd	s1,8(sp)
    800037fe:	e04a                	sd	s2,0(sp)
    80003800:	1000                	addi	s0,sp,32
    80003802:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003804:	00850913          	addi	s2,a0,8
    80003808:	854a                	mv	a0,s2
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	8c8080e7          	jalr	-1848(ra) # 800060d2 <acquire>
  lk->locked = 0;
    80003812:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003816:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000381a:	8526                	mv	a0,s1
    8000381c:	ffffe097          	auipc	ra,0xffffe
    80003820:	e7c080e7          	jalr	-388(ra) # 80001698 <wakeup>
  release(&lk->lk);
    80003824:	854a                	mv	a0,s2
    80003826:	00003097          	auipc	ra,0x3
    8000382a:	960080e7          	jalr	-1696(ra) # 80006186 <release>
}
    8000382e:	60e2                	ld	ra,24(sp)
    80003830:	6442                	ld	s0,16(sp)
    80003832:	64a2                	ld	s1,8(sp)
    80003834:	6902                	ld	s2,0(sp)
    80003836:	6105                	addi	sp,sp,32
    80003838:	8082                	ret

000000008000383a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000383a:	7179                	addi	sp,sp,-48
    8000383c:	f406                	sd	ra,40(sp)
    8000383e:	f022                	sd	s0,32(sp)
    80003840:	ec26                	sd	s1,24(sp)
    80003842:	e84a                	sd	s2,16(sp)
    80003844:	e44e                	sd	s3,8(sp)
    80003846:	1800                	addi	s0,sp,48
    80003848:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000384a:	00850913          	addi	s2,a0,8
    8000384e:	854a                	mv	a0,s2
    80003850:	00003097          	auipc	ra,0x3
    80003854:	882080e7          	jalr	-1918(ra) # 800060d2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003858:	409c                	lw	a5,0(s1)
    8000385a:	ef99                	bnez	a5,80003878 <holdingsleep+0x3e>
    8000385c:	4481                	li	s1,0
  release(&lk->lk);
    8000385e:	854a                	mv	a0,s2
    80003860:	00003097          	auipc	ra,0x3
    80003864:	926080e7          	jalr	-1754(ra) # 80006186 <release>
  return r;
}
    80003868:	8526                	mv	a0,s1
    8000386a:	70a2                	ld	ra,40(sp)
    8000386c:	7402                	ld	s0,32(sp)
    8000386e:	64e2                	ld	s1,24(sp)
    80003870:	6942                	ld	s2,16(sp)
    80003872:	69a2                	ld	s3,8(sp)
    80003874:	6145                	addi	sp,sp,48
    80003876:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003878:	0284a983          	lw	s3,40(s1)
    8000387c:	ffffd097          	auipc	ra,0xffffd
    80003880:	5cc080e7          	jalr	1484(ra) # 80000e48 <myproc>
    80003884:	5904                	lw	s1,48(a0)
    80003886:	413484b3          	sub	s1,s1,s3
    8000388a:	0014b493          	seqz	s1,s1
    8000388e:	bfc1                	j	8000385e <holdingsleep+0x24>

0000000080003890 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003890:	1141                	addi	sp,sp,-16
    80003892:	e406                	sd	ra,8(sp)
    80003894:	e022                	sd	s0,0(sp)
    80003896:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003898:	00005597          	auipc	a1,0x5
    8000389c:	ee058593          	addi	a1,a1,-288 # 80008778 <syscall_names+0x240>
    800038a0:	00016517          	auipc	a0,0x16
    800038a4:	ac850513          	addi	a0,a0,-1336 # 80019368 <ftable>
    800038a8:	00002097          	auipc	ra,0x2
    800038ac:	79a080e7          	jalr	1946(ra) # 80006042 <initlock>
}
    800038b0:	60a2                	ld	ra,8(sp)
    800038b2:	6402                	ld	s0,0(sp)
    800038b4:	0141                	addi	sp,sp,16
    800038b6:	8082                	ret

00000000800038b8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038b8:	1101                	addi	sp,sp,-32
    800038ba:	ec06                	sd	ra,24(sp)
    800038bc:	e822                	sd	s0,16(sp)
    800038be:	e426                	sd	s1,8(sp)
    800038c0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038c2:	00016517          	auipc	a0,0x16
    800038c6:	aa650513          	addi	a0,a0,-1370 # 80019368 <ftable>
    800038ca:	00003097          	auipc	ra,0x3
    800038ce:	808080e7          	jalr	-2040(ra) # 800060d2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038d2:	00016497          	auipc	s1,0x16
    800038d6:	aae48493          	addi	s1,s1,-1362 # 80019380 <ftable+0x18>
    800038da:	00017717          	auipc	a4,0x17
    800038de:	a4670713          	addi	a4,a4,-1466 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800038e2:	40dc                	lw	a5,4(s1)
    800038e4:	cf99                	beqz	a5,80003902 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038e6:	02848493          	addi	s1,s1,40
    800038ea:	fee49ce3          	bne	s1,a4,800038e2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038ee:	00016517          	auipc	a0,0x16
    800038f2:	a7a50513          	addi	a0,a0,-1414 # 80019368 <ftable>
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	890080e7          	jalr	-1904(ra) # 80006186 <release>
  return 0;
    800038fe:	4481                	li	s1,0
    80003900:	a819                	j	80003916 <filealloc+0x5e>
      f->ref = 1;
    80003902:	4785                	li	a5,1
    80003904:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003906:	00016517          	auipc	a0,0x16
    8000390a:	a6250513          	addi	a0,a0,-1438 # 80019368 <ftable>
    8000390e:	00003097          	auipc	ra,0x3
    80003912:	878080e7          	jalr	-1928(ra) # 80006186 <release>
}
    80003916:	8526                	mv	a0,s1
    80003918:	60e2                	ld	ra,24(sp)
    8000391a:	6442                	ld	s0,16(sp)
    8000391c:	64a2                	ld	s1,8(sp)
    8000391e:	6105                	addi	sp,sp,32
    80003920:	8082                	ret

0000000080003922 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003922:	1101                	addi	sp,sp,-32
    80003924:	ec06                	sd	ra,24(sp)
    80003926:	e822                	sd	s0,16(sp)
    80003928:	e426                	sd	s1,8(sp)
    8000392a:	1000                	addi	s0,sp,32
    8000392c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000392e:	00016517          	auipc	a0,0x16
    80003932:	a3a50513          	addi	a0,a0,-1478 # 80019368 <ftable>
    80003936:	00002097          	auipc	ra,0x2
    8000393a:	79c080e7          	jalr	1948(ra) # 800060d2 <acquire>
  if(f->ref < 1)
    8000393e:	40dc                	lw	a5,4(s1)
    80003940:	02f05263          	blez	a5,80003964 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003944:	2785                	addiw	a5,a5,1
    80003946:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003948:	00016517          	auipc	a0,0x16
    8000394c:	a2050513          	addi	a0,a0,-1504 # 80019368 <ftable>
    80003950:	00003097          	auipc	ra,0x3
    80003954:	836080e7          	jalr	-1994(ra) # 80006186 <release>
  return f;
}
    80003958:	8526                	mv	a0,s1
    8000395a:	60e2                	ld	ra,24(sp)
    8000395c:	6442                	ld	s0,16(sp)
    8000395e:	64a2                	ld	s1,8(sp)
    80003960:	6105                	addi	sp,sp,32
    80003962:	8082                	ret
    panic("filedup");
    80003964:	00005517          	auipc	a0,0x5
    80003968:	e1c50513          	addi	a0,a0,-484 # 80008780 <syscall_names+0x248>
    8000396c:	00002097          	auipc	ra,0x2
    80003970:	21c080e7          	jalr	540(ra) # 80005b88 <panic>

0000000080003974 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003974:	7139                	addi	sp,sp,-64
    80003976:	fc06                	sd	ra,56(sp)
    80003978:	f822                	sd	s0,48(sp)
    8000397a:	f426                	sd	s1,40(sp)
    8000397c:	f04a                	sd	s2,32(sp)
    8000397e:	ec4e                	sd	s3,24(sp)
    80003980:	e852                	sd	s4,16(sp)
    80003982:	e456                	sd	s5,8(sp)
    80003984:	0080                	addi	s0,sp,64
    80003986:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003988:	00016517          	auipc	a0,0x16
    8000398c:	9e050513          	addi	a0,a0,-1568 # 80019368 <ftable>
    80003990:	00002097          	auipc	ra,0x2
    80003994:	742080e7          	jalr	1858(ra) # 800060d2 <acquire>
  if(f->ref < 1)
    80003998:	40dc                	lw	a5,4(s1)
    8000399a:	06f05163          	blez	a5,800039fc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000399e:	37fd                	addiw	a5,a5,-1
    800039a0:	0007871b          	sext.w	a4,a5
    800039a4:	c0dc                	sw	a5,4(s1)
    800039a6:	06e04363          	bgtz	a4,80003a0c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039aa:	0004a903          	lw	s2,0(s1)
    800039ae:	0094ca83          	lbu	s5,9(s1)
    800039b2:	0104ba03          	ld	s4,16(s1)
    800039b6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039ba:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039be:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039c2:	00016517          	auipc	a0,0x16
    800039c6:	9a650513          	addi	a0,a0,-1626 # 80019368 <ftable>
    800039ca:	00002097          	auipc	ra,0x2
    800039ce:	7bc080e7          	jalr	1980(ra) # 80006186 <release>

  if(ff.type == FD_PIPE){
    800039d2:	4785                	li	a5,1
    800039d4:	04f90d63          	beq	s2,a5,80003a2e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039d8:	3979                	addiw	s2,s2,-2
    800039da:	4785                	li	a5,1
    800039dc:	0527e063          	bltu	a5,s2,80003a1c <fileclose+0xa8>
    begin_op();
    800039e0:	00000097          	auipc	ra,0x0
    800039e4:	ac8080e7          	jalr	-1336(ra) # 800034a8 <begin_op>
    iput(ff.ip);
    800039e8:	854e                	mv	a0,s3
    800039ea:	fffff097          	auipc	ra,0xfffff
    800039ee:	2a6080e7          	jalr	678(ra) # 80002c90 <iput>
    end_op();
    800039f2:	00000097          	auipc	ra,0x0
    800039f6:	b36080e7          	jalr	-1226(ra) # 80003528 <end_op>
    800039fa:	a00d                	j	80003a1c <fileclose+0xa8>
    panic("fileclose");
    800039fc:	00005517          	auipc	a0,0x5
    80003a00:	d8c50513          	addi	a0,a0,-628 # 80008788 <syscall_names+0x250>
    80003a04:	00002097          	auipc	ra,0x2
    80003a08:	184080e7          	jalr	388(ra) # 80005b88 <panic>
    release(&ftable.lock);
    80003a0c:	00016517          	auipc	a0,0x16
    80003a10:	95c50513          	addi	a0,a0,-1700 # 80019368 <ftable>
    80003a14:	00002097          	auipc	ra,0x2
    80003a18:	772080e7          	jalr	1906(ra) # 80006186 <release>
  }
}
    80003a1c:	70e2                	ld	ra,56(sp)
    80003a1e:	7442                	ld	s0,48(sp)
    80003a20:	74a2                	ld	s1,40(sp)
    80003a22:	7902                	ld	s2,32(sp)
    80003a24:	69e2                	ld	s3,24(sp)
    80003a26:	6a42                	ld	s4,16(sp)
    80003a28:	6aa2                	ld	s5,8(sp)
    80003a2a:	6121                	addi	sp,sp,64
    80003a2c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a2e:	85d6                	mv	a1,s5
    80003a30:	8552                	mv	a0,s4
    80003a32:	00000097          	auipc	ra,0x0
    80003a36:	34c080e7          	jalr	844(ra) # 80003d7e <pipeclose>
    80003a3a:	b7cd                	j	80003a1c <fileclose+0xa8>

0000000080003a3c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a3c:	715d                	addi	sp,sp,-80
    80003a3e:	e486                	sd	ra,72(sp)
    80003a40:	e0a2                	sd	s0,64(sp)
    80003a42:	fc26                	sd	s1,56(sp)
    80003a44:	f84a                	sd	s2,48(sp)
    80003a46:	f44e                	sd	s3,40(sp)
    80003a48:	0880                	addi	s0,sp,80
    80003a4a:	84aa                	mv	s1,a0
    80003a4c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a4e:	ffffd097          	auipc	ra,0xffffd
    80003a52:	3fa080e7          	jalr	1018(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a56:	409c                	lw	a5,0(s1)
    80003a58:	37f9                	addiw	a5,a5,-2
    80003a5a:	4705                	li	a4,1
    80003a5c:	04f76763          	bltu	a4,a5,80003aaa <filestat+0x6e>
    80003a60:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a62:	6c88                	ld	a0,24(s1)
    80003a64:	fffff097          	auipc	ra,0xfffff
    80003a68:	072080e7          	jalr	114(ra) # 80002ad6 <ilock>
    stati(f->ip, &st);
    80003a6c:	fb840593          	addi	a1,s0,-72
    80003a70:	6c88                	ld	a0,24(s1)
    80003a72:	fffff097          	auipc	ra,0xfffff
    80003a76:	2ee080e7          	jalr	750(ra) # 80002d60 <stati>
    iunlock(f->ip);
    80003a7a:	6c88                	ld	a0,24(s1)
    80003a7c:	fffff097          	auipc	ra,0xfffff
    80003a80:	11c080e7          	jalr	284(ra) # 80002b98 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a84:	46e1                	li	a3,24
    80003a86:	fb840613          	addi	a2,s0,-72
    80003a8a:	85ce                	mv	a1,s3
    80003a8c:	05093503          	ld	a0,80(s2)
    80003a90:	ffffd097          	auipc	ra,0xffffd
    80003a94:	07a080e7          	jalr	122(ra) # 80000b0a <copyout>
    80003a98:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003a9c:	60a6                	ld	ra,72(sp)
    80003a9e:	6406                	ld	s0,64(sp)
    80003aa0:	74e2                	ld	s1,56(sp)
    80003aa2:	7942                	ld	s2,48(sp)
    80003aa4:	79a2                	ld	s3,40(sp)
    80003aa6:	6161                	addi	sp,sp,80
    80003aa8:	8082                	ret
  return -1;
    80003aaa:	557d                	li	a0,-1
    80003aac:	bfc5                	j	80003a9c <filestat+0x60>

0000000080003aae <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aae:	7179                	addi	sp,sp,-48
    80003ab0:	f406                	sd	ra,40(sp)
    80003ab2:	f022                	sd	s0,32(sp)
    80003ab4:	ec26                	sd	s1,24(sp)
    80003ab6:	e84a                	sd	s2,16(sp)
    80003ab8:	e44e                	sd	s3,8(sp)
    80003aba:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003abc:	00854783          	lbu	a5,8(a0)
    80003ac0:	c3d5                	beqz	a5,80003b64 <fileread+0xb6>
    80003ac2:	84aa                	mv	s1,a0
    80003ac4:	89ae                	mv	s3,a1
    80003ac6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ac8:	411c                	lw	a5,0(a0)
    80003aca:	4705                	li	a4,1
    80003acc:	04e78963          	beq	a5,a4,80003b1e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ad0:	470d                	li	a4,3
    80003ad2:	04e78d63          	beq	a5,a4,80003b2c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ad6:	4709                	li	a4,2
    80003ad8:	06e79e63          	bne	a5,a4,80003b54 <fileread+0xa6>
    ilock(f->ip);
    80003adc:	6d08                	ld	a0,24(a0)
    80003ade:	fffff097          	auipc	ra,0xfffff
    80003ae2:	ff8080e7          	jalr	-8(ra) # 80002ad6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ae6:	874a                	mv	a4,s2
    80003ae8:	5094                	lw	a3,32(s1)
    80003aea:	864e                	mv	a2,s3
    80003aec:	4585                	li	a1,1
    80003aee:	6c88                	ld	a0,24(s1)
    80003af0:	fffff097          	auipc	ra,0xfffff
    80003af4:	29a080e7          	jalr	666(ra) # 80002d8a <readi>
    80003af8:	892a                	mv	s2,a0
    80003afa:	00a05563          	blez	a0,80003b04 <fileread+0x56>
      f->off += r;
    80003afe:	509c                	lw	a5,32(s1)
    80003b00:	9fa9                	addw	a5,a5,a0
    80003b02:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b04:	6c88                	ld	a0,24(s1)
    80003b06:	fffff097          	auipc	ra,0xfffff
    80003b0a:	092080e7          	jalr	146(ra) # 80002b98 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b0e:	854a                	mv	a0,s2
    80003b10:	70a2                	ld	ra,40(sp)
    80003b12:	7402                	ld	s0,32(sp)
    80003b14:	64e2                	ld	s1,24(sp)
    80003b16:	6942                	ld	s2,16(sp)
    80003b18:	69a2                	ld	s3,8(sp)
    80003b1a:	6145                	addi	sp,sp,48
    80003b1c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b1e:	6908                	ld	a0,16(a0)
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	3c8080e7          	jalr	968(ra) # 80003ee8 <piperead>
    80003b28:	892a                	mv	s2,a0
    80003b2a:	b7d5                	j	80003b0e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b2c:	02451783          	lh	a5,36(a0)
    80003b30:	03079693          	slli	a3,a5,0x30
    80003b34:	92c1                	srli	a3,a3,0x30
    80003b36:	4725                	li	a4,9
    80003b38:	02d76863          	bltu	a4,a3,80003b68 <fileread+0xba>
    80003b3c:	0792                	slli	a5,a5,0x4
    80003b3e:	00015717          	auipc	a4,0x15
    80003b42:	78a70713          	addi	a4,a4,1930 # 800192c8 <devsw>
    80003b46:	97ba                	add	a5,a5,a4
    80003b48:	639c                	ld	a5,0(a5)
    80003b4a:	c38d                	beqz	a5,80003b6c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003b4c:	4505                	li	a0,1
    80003b4e:	9782                	jalr	a5
    80003b50:	892a                	mv	s2,a0
    80003b52:	bf75                	j	80003b0e <fileread+0x60>
    panic("fileread");
    80003b54:	00005517          	auipc	a0,0x5
    80003b58:	c4450513          	addi	a0,a0,-956 # 80008798 <syscall_names+0x260>
    80003b5c:	00002097          	auipc	ra,0x2
    80003b60:	02c080e7          	jalr	44(ra) # 80005b88 <panic>
    return -1;
    80003b64:	597d                	li	s2,-1
    80003b66:	b765                	j	80003b0e <fileread+0x60>
      return -1;
    80003b68:	597d                	li	s2,-1
    80003b6a:	b755                	j	80003b0e <fileread+0x60>
    80003b6c:	597d                	li	s2,-1
    80003b6e:	b745                	j	80003b0e <fileread+0x60>

0000000080003b70 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003b70:	715d                	addi	sp,sp,-80
    80003b72:	e486                	sd	ra,72(sp)
    80003b74:	e0a2                	sd	s0,64(sp)
    80003b76:	fc26                	sd	s1,56(sp)
    80003b78:	f84a                	sd	s2,48(sp)
    80003b7a:	f44e                	sd	s3,40(sp)
    80003b7c:	f052                	sd	s4,32(sp)
    80003b7e:	ec56                	sd	s5,24(sp)
    80003b80:	e85a                	sd	s6,16(sp)
    80003b82:	e45e                	sd	s7,8(sp)
    80003b84:	e062                	sd	s8,0(sp)
    80003b86:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003b88:	00954783          	lbu	a5,9(a0)
    80003b8c:	10078663          	beqz	a5,80003c98 <filewrite+0x128>
    80003b90:	892a                	mv	s2,a0
    80003b92:	8aae                	mv	s5,a1
    80003b94:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b96:	411c                	lw	a5,0(a0)
    80003b98:	4705                	li	a4,1
    80003b9a:	02e78263          	beq	a5,a4,80003bbe <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b9e:	470d                	li	a4,3
    80003ba0:	02e78663          	beq	a5,a4,80003bcc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba4:	4709                	li	a4,2
    80003ba6:	0ee79163          	bne	a5,a4,80003c88 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003baa:	0ac05d63          	blez	a2,80003c64 <filewrite+0xf4>
    int i = 0;
    80003bae:	4981                	li	s3,0
    80003bb0:	6b05                	lui	s6,0x1
    80003bb2:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003bb6:	6b85                	lui	s7,0x1
    80003bb8:	c00b8b9b          	addiw	s7,s7,-1024
    80003bbc:	a861                	j	80003c54 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003bbe:	6908                	ld	a0,16(a0)
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	22e080e7          	jalr	558(ra) # 80003dee <pipewrite>
    80003bc8:	8a2a                	mv	s4,a0
    80003bca:	a045                	j	80003c6a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bcc:	02451783          	lh	a5,36(a0)
    80003bd0:	03079693          	slli	a3,a5,0x30
    80003bd4:	92c1                	srli	a3,a3,0x30
    80003bd6:	4725                	li	a4,9
    80003bd8:	0cd76263          	bltu	a4,a3,80003c9c <filewrite+0x12c>
    80003bdc:	0792                	slli	a5,a5,0x4
    80003bde:	00015717          	auipc	a4,0x15
    80003be2:	6ea70713          	addi	a4,a4,1770 # 800192c8 <devsw>
    80003be6:	97ba                	add	a5,a5,a4
    80003be8:	679c                	ld	a5,8(a5)
    80003bea:	cbdd                	beqz	a5,80003ca0 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003bec:	4505                	li	a0,1
    80003bee:	9782                	jalr	a5
    80003bf0:	8a2a                	mv	s4,a0
    80003bf2:	a8a5                	j	80003c6a <filewrite+0xfa>
    80003bf4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003bf8:	00000097          	auipc	ra,0x0
    80003bfc:	8b0080e7          	jalr	-1872(ra) # 800034a8 <begin_op>
      ilock(f->ip);
    80003c00:	01893503          	ld	a0,24(s2)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	ed2080e7          	jalr	-302(ra) # 80002ad6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c0c:	8762                	mv	a4,s8
    80003c0e:	02092683          	lw	a3,32(s2)
    80003c12:	01598633          	add	a2,s3,s5
    80003c16:	4585                	li	a1,1
    80003c18:	01893503          	ld	a0,24(s2)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	266080e7          	jalr	614(ra) # 80002e82 <writei>
    80003c24:	84aa                	mv	s1,a0
    80003c26:	00a05763          	blez	a0,80003c34 <filewrite+0xc4>
        f->off += r;
    80003c2a:	02092783          	lw	a5,32(s2)
    80003c2e:	9fa9                	addw	a5,a5,a0
    80003c30:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c34:	01893503          	ld	a0,24(s2)
    80003c38:	fffff097          	auipc	ra,0xfffff
    80003c3c:	f60080e7          	jalr	-160(ra) # 80002b98 <iunlock>
      end_op();
    80003c40:	00000097          	auipc	ra,0x0
    80003c44:	8e8080e7          	jalr	-1816(ra) # 80003528 <end_op>

      if(r != n1){
    80003c48:	009c1f63          	bne	s8,s1,80003c66 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003c4c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c50:	0149db63          	bge	s3,s4,80003c66 <filewrite+0xf6>
      int n1 = n - i;
    80003c54:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003c58:	84be                	mv	s1,a5
    80003c5a:	2781                	sext.w	a5,a5
    80003c5c:	f8fb5ce3          	bge	s6,a5,80003bf4 <filewrite+0x84>
    80003c60:	84de                	mv	s1,s7
    80003c62:	bf49                	j	80003bf4 <filewrite+0x84>
    int i = 0;
    80003c64:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003c66:	013a1f63          	bne	s4,s3,80003c84 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c6a:	8552                	mv	a0,s4
    80003c6c:	60a6                	ld	ra,72(sp)
    80003c6e:	6406                	ld	s0,64(sp)
    80003c70:	74e2                	ld	s1,56(sp)
    80003c72:	7942                	ld	s2,48(sp)
    80003c74:	79a2                	ld	s3,40(sp)
    80003c76:	7a02                	ld	s4,32(sp)
    80003c78:	6ae2                	ld	s5,24(sp)
    80003c7a:	6b42                	ld	s6,16(sp)
    80003c7c:	6ba2                	ld	s7,8(sp)
    80003c7e:	6c02                	ld	s8,0(sp)
    80003c80:	6161                	addi	sp,sp,80
    80003c82:	8082                	ret
    ret = (i == n ? n : -1);
    80003c84:	5a7d                	li	s4,-1
    80003c86:	b7d5                	j	80003c6a <filewrite+0xfa>
    panic("filewrite");
    80003c88:	00005517          	auipc	a0,0x5
    80003c8c:	b2050513          	addi	a0,a0,-1248 # 800087a8 <syscall_names+0x270>
    80003c90:	00002097          	auipc	ra,0x2
    80003c94:	ef8080e7          	jalr	-264(ra) # 80005b88 <panic>
    return -1;
    80003c98:	5a7d                	li	s4,-1
    80003c9a:	bfc1                	j	80003c6a <filewrite+0xfa>
      return -1;
    80003c9c:	5a7d                	li	s4,-1
    80003c9e:	b7f1                	j	80003c6a <filewrite+0xfa>
    80003ca0:	5a7d                	li	s4,-1
    80003ca2:	b7e1                	j	80003c6a <filewrite+0xfa>

0000000080003ca4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ca4:	7179                	addi	sp,sp,-48
    80003ca6:	f406                	sd	ra,40(sp)
    80003ca8:	f022                	sd	s0,32(sp)
    80003caa:	ec26                	sd	s1,24(sp)
    80003cac:	e84a                	sd	s2,16(sp)
    80003cae:	e44e                	sd	s3,8(sp)
    80003cb0:	e052                	sd	s4,0(sp)
    80003cb2:	1800                	addi	s0,sp,48
    80003cb4:	84aa                	mv	s1,a0
    80003cb6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cb8:	0005b023          	sd	zero,0(a1)
    80003cbc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cc0:	00000097          	auipc	ra,0x0
    80003cc4:	bf8080e7          	jalr	-1032(ra) # 800038b8 <filealloc>
    80003cc8:	e088                	sd	a0,0(s1)
    80003cca:	c551                	beqz	a0,80003d56 <pipealloc+0xb2>
    80003ccc:	00000097          	auipc	ra,0x0
    80003cd0:	bec080e7          	jalr	-1044(ra) # 800038b8 <filealloc>
    80003cd4:	00aa3023          	sd	a0,0(s4)
    80003cd8:	c92d                	beqz	a0,80003d4a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cda:	ffffc097          	auipc	ra,0xffffc
    80003cde:	43e080e7          	jalr	1086(ra) # 80000118 <kalloc>
    80003ce2:	892a                	mv	s2,a0
    80003ce4:	c125                	beqz	a0,80003d44 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ce6:	4985                	li	s3,1
    80003ce8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003cec:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003cf0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003cf4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003cf8:	00004597          	auipc	a1,0x4
    80003cfc:	6e858593          	addi	a1,a1,1768 # 800083e0 <states.1710+0x1a0>
    80003d00:	00002097          	auipc	ra,0x2
    80003d04:	342080e7          	jalr	834(ra) # 80006042 <initlock>
  (*f0)->type = FD_PIPE;
    80003d08:	609c                	ld	a5,0(s1)
    80003d0a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d0e:	609c                	ld	a5,0(s1)
    80003d10:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d14:	609c                	ld	a5,0(s1)
    80003d16:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d1a:	609c                	ld	a5,0(s1)
    80003d1c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d20:	000a3783          	ld	a5,0(s4)
    80003d24:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d28:	000a3783          	ld	a5,0(s4)
    80003d2c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d30:	000a3783          	ld	a5,0(s4)
    80003d34:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d38:	000a3783          	ld	a5,0(s4)
    80003d3c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d40:	4501                	li	a0,0
    80003d42:	a025                	j	80003d6a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d44:	6088                	ld	a0,0(s1)
    80003d46:	e501                	bnez	a0,80003d4e <pipealloc+0xaa>
    80003d48:	a039                	j	80003d56 <pipealloc+0xb2>
    80003d4a:	6088                	ld	a0,0(s1)
    80003d4c:	c51d                	beqz	a0,80003d7a <pipealloc+0xd6>
    fileclose(*f0);
    80003d4e:	00000097          	auipc	ra,0x0
    80003d52:	c26080e7          	jalr	-986(ra) # 80003974 <fileclose>
  if(*f1)
    80003d56:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d5a:	557d                	li	a0,-1
  if(*f1)
    80003d5c:	c799                	beqz	a5,80003d6a <pipealloc+0xc6>
    fileclose(*f1);
    80003d5e:	853e                	mv	a0,a5
    80003d60:	00000097          	auipc	ra,0x0
    80003d64:	c14080e7          	jalr	-1004(ra) # 80003974 <fileclose>
  return -1;
    80003d68:	557d                	li	a0,-1
}
    80003d6a:	70a2                	ld	ra,40(sp)
    80003d6c:	7402                	ld	s0,32(sp)
    80003d6e:	64e2                	ld	s1,24(sp)
    80003d70:	6942                	ld	s2,16(sp)
    80003d72:	69a2                	ld	s3,8(sp)
    80003d74:	6a02                	ld	s4,0(sp)
    80003d76:	6145                	addi	sp,sp,48
    80003d78:	8082                	ret
  return -1;
    80003d7a:	557d                	li	a0,-1
    80003d7c:	b7fd                	j	80003d6a <pipealloc+0xc6>

0000000080003d7e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d7e:	1101                	addi	sp,sp,-32
    80003d80:	ec06                	sd	ra,24(sp)
    80003d82:	e822                	sd	s0,16(sp)
    80003d84:	e426                	sd	s1,8(sp)
    80003d86:	e04a                	sd	s2,0(sp)
    80003d88:	1000                	addi	s0,sp,32
    80003d8a:	84aa                	mv	s1,a0
    80003d8c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003d8e:	00002097          	auipc	ra,0x2
    80003d92:	344080e7          	jalr	836(ra) # 800060d2 <acquire>
  if(writable){
    80003d96:	02090d63          	beqz	s2,80003dd0 <pipeclose+0x52>
    pi->writeopen = 0;
    80003d9a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003d9e:	21848513          	addi	a0,s1,536
    80003da2:	ffffe097          	auipc	ra,0xffffe
    80003da6:	8f6080e7          	jalr	-1802(ra) # 80001698 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003daa:	2204b783          	ld	a5,544(s1)
    80003dae:	eb95                	bnez	a5,80003de2 <pipeclose+0x64>
    release(&pi->lock);
    80003db0:	8526                	mv	a0,s1
    80003db2:	00002097          	auipc	ra,0x2
    80003db6:	3d4080e7          	jalr	980(ra) # 80006186 <release>
    kfree((char*)pi);
    80003dba:	8526                	mv	a0,s1
    80003dbc:	ffffc097          	auipc	ra,0xffffc
    80003dc0:	260080e7          	jalr	608(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dc4:	60e2                	ld	ra,24(sp)
    80003dc6:	6442                	ld	s0,16(sp)
    80003dc8:	64a2                	ld	s1,8(sp)
    80003dca:	6902                	ld	s2,0(sp)
    80003dcc:	6105                	addi	sp,sp,32
    80003dce:	8082                	ret
    pi->readopen = 0;
    80003dd0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dd4:	21c48513          	addi	a0,s1,540
    80003dd8:	ffffe097          	auipc	ra,0xffffe
    80003ddc:	8c0080e7          	jalr	-1856(ra) # 80001698 <wakeup>
    80003de0:	b7e9                	j	80003daa <pipeclose+0x2c>
    release(&pi->lock);
    80003de2:	8526                	mv	a0,s1
    80003de4:	00002097          	auipc	ra,0x2
    80003de8:	3a2080e7          	jalr	930(ra) # 80006186 <release>
}
    80003dec:	bfe1                	j	80003dc4 <pipeclose+0x46>

0000000080003dee <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003dee:	7159                	addi	sp,sp,-112
    80003df0:	f486                	sd	ra,104(sp)
    80003df2:	f0a2                	sd	s0,96(sp)
    80003df4:	eca6                	sd	s1,88(sp)
    80003df6:	e8ca                	sd	s2,80(sp)
    80003df8:	e4ce                	sd	s3,72(sp)
    80003dfa:	e0d2                	sd	s4,64(sp)
    80003dfc:	fc56                	sd	s5,56(sp)
    80003dfe:	f85a                	sd	s6,48(sp)
    80003e00:	f45e                	sd	s7,40(sp)
    80003e02:	f062                	sd	s8,32(sp)
    80003e04:	ec66                	sd	s9,24(sp)
    80003e06:	1880                	addi	s0,sp,112
    80003e08:	84aa                	mv	s1,a0
    80003e0a:	8aae                	mv	s5,a1
    80003e0c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e0e:	ffffd097          	auipc	ra,0xffffd
    80003e12:	03a080e7          	jalr	58(ra) # 80000e48 <myproc>
    80003e16:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	00002097          	auipc	ra,0x2
    80003e1e:	2b8080e7          	jalr	696(ra) # 800060d2 <acquire>
  while(i < n){
    80003e22:	0d405163          	blez	s4,80003ee4 <pipewrite+0xf6>
    80003e26:	8ba6                	mv	s7,s1
  int i = 0;
    80003e28:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e2a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e2c:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e30:	21c48c13          	addi	s8,s1,540
    80003e34:	a08d                	j	80003e96 <pipewrite+0xa8>
      release(&pi->lock);
    80003e36:	8526                	mv	a0,s1
    80003e38:	00002097          	auipc	ra,0x2
    80003e3c:	34e080e7          	jalr	846(ra) # 80006186 <release>
      return -1;
    80003e40:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e42:	854a                	mv	a0,s2
    80003e44:	70a6                	ld	ra,104(sp)
    80003e46:	7406                	ld	s0,96(sp)
    80003e48:	64e6                	ld	s1,88(sp)
    80003e4a:	6946                	ld	s2,80(sp)
    80003e4c:	69a6                	ld	s3,72(sp)
    80003e4e:	6a06                	ld	s4,64(sp)
    80003e50:	7ae2                	ld	s5,56(sp)
    80003e52:	7b42                	ld	s6,48(sp)
    80003e54:	7ba2                	ld	s7,40(sp)
    80003e56:	7c02                	ld	s8,32(sp)
    80003e58:	6ce2                	ld	s9,24(sp)
    80003e5a:	6165                	addi	sp,sp,112
    80003e5c:	8082                	ret
      wakeup(&pi->nread);
    80003e5e:	8566                	mv	a0,s9
    80003e60:	ffffe097          	auipc	ra,0xffffe
    80003e64:	838080e7          	jalr	-1992(ra) # 80001698 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e68:	85de                	mv	a1,s7
    80003e6a:	8562                	mv	a0,s8
    80003e6c:	ffffd097          	auipc	ra,0xffffd
    80003e70:	6a0080e7          	jalr	1696(ra) # 8000150c <sleep>
    80003e74:	a839                	j	80003e92 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003e76:	21c4a783          	lw	a5,540(s1)
    80003e7a:	0017871b          	addiw	a4,a5,1
    80003e7e:	20e4ae23          	sw	a4,540(s1)
    80003e82:	1ff7f793          	andi	a5,a5,511
    80003e86:	97a6                	add	a5,a5,s1
    80003e88:	f9f44703          	lbu	a4,-97(s0)
    80003e8c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003e90:	2905                	addiw	s2,s2,1
  while(i < n){
    80003e92:	03495d63          	bge	s2,s4,80003ecc <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003e96:	2204a783          	lw	a5,544(s1)
    80003e9a:	dfd1                	beqz	a5,80003e36 <pipewrite+0x48>
    80003e9c:	0289a783          	lw	a5,40(s3)
    80003ea0:	fbd9                	bnez	a5,80003e36 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ea2:	2184a783          	lw	a5,536(s1)
    80003ea6:	21c4a703          	lw	a4,540(s1)
    80003eaa:	2007879b          	addiw	a5,a5,512
    80003eae:	faf708e3          	beq	a4,a5,80003e5e <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003eb2:	4685                	li	a3,1
    80003eb4:	01590633          	add	a2,s2,s5
    80003eb8:	f9f40593          	addi	a1,s0,-97
    80003ebc:	0509b503          	ld	a0,80(s3)
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	cd6080e7          	jalr	-810(ra) # 80000b96 <copyin>
    80003ec8:	fb6517e3          	bne	a0,s6,80003e76 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003ecc:	21848513          	addi	a0,s1,536
    80003ed0:	ffffd097          	auipc	ra,0xffffd
    80003ed4:	7c8080e7          	jalr	1992(ra) # 80001698 <wakeup>
  release(&pi->lock);
    80003ed8:	8526                	mv	a0,s1
    80003eda:	00002097          	auipc	ra,0x2
    80003ede:	2ac080e7          	jalr	684(ra) # 80006186 <release>
  return i;
    80003ee2:	b785                	j	80003e42 <pipewrite+0x54>
  int i = 0;
    80003ee4:	4901                	li	s2,0
    80003ee6:	b7dd                	j	80003ecc <pipewrite+0xde>

0000000080003ee8 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ee8:	715d                	addi	sp,sp,-80
    80003eea:	e486                	sd	ra,72(sp)
    80003eec:	e0a2                	sd	s0,64(sp)
    80003eee:	fc26                	sd	s1,56(sp)
    80003ef0:	f84a                	sd	s2,48(sp)
    80003ef2:	f44e                	sd	s3,40(sp)
    80003ef4:	f052                	sd	s4,32(sp)
    80003ef6:	ec56                	sd	s5,24(sp)
    80003ef8:	e85a                	sd	s6,16(sp)
    80003efa:	0880                	addi	s0,sp,80
    80003efc:	84aa                	mv	s1,a0
    80003efe:	892e                	mv	s2,a1
    80003f00:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	f46080e7          	jalr	-186(ra) # 80000e48 <myproc>
    80003f0a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f0c:	8b26                	mv	s6,s1
    80003f0e:	8526                	mv	a0,s1
    80003f10:	00002097          	auipc	ra,0x2
    80003f14:	1c2080e7          	jalr	450(ra) # 800060d2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f18:	2184a703          	lw	a4,536(s1)
    80003f1c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f20:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f24:	02f71463          	bne	a4,a5,80003f4c <piperead+0x64>
    80003f28:	2244a783          	lw	a5,548(s1)
    80003f2c:	c385                	beqz	a5,80003f4c <piperead+0x64>
    if(pr->killed){
    80003f2e:	028a2783          	lw	a5,40(s4)
    80003f32:	ebc1                	bnez	a5,80003fc2 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f34:	85da                	mv	a1,s6
    80003f36:	854e                	mv	a0,s3
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	5d4080e7          	jalr	1492(ra) # 8000150c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f40:	2184a703          	lw	a4,536(s1)
    80003f44:	21c4a783          	lw	a5,540(s1)
    80003f48:	fef700e3          	beq	a4,a5,80003f28 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f4c:	09505263          	blez	s5,80003fd0 <piperead+0xe8>
    80003f50:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f52:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003f54:	2184a783          	lw	a5,536(s1)
    80003f58:	21c4a703          	lw	a4,540(s1)
    80003f5c:	02f70d63          	beq	a4,a5,80003f96 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f60:	0017871b          	addiw	a4,a5,1
    80003f64:	20e4ac23          	sw	a4,536(s1)
    80003f68:	1ff7f793          	andi	a5,a5,511
    80003f6c:	97a6                	add	a5,a5,s1
    80003f6e:	0187c783          	lbu	a5,24(a5)
    80003f72:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f76:	4685                	li	a3,1
    80003f78:	fbf40613          	addi	a2,s0,-65
    80003f7c:	85ca                	mv	a1,s2
    80003f7e:	050a3503          	ld	a0,80(s4)
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	b88080e7          	jalr	-1144(ra) # 80000b0a <copyout>
    80003f8a:	01650663          	beq	a0,s6,80003f96 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f8e:	2985                	addiw	s3,s3,1
    80003f90:	0905                	addi	s2,s2,1
    80003f92:	fd3a91e3          	bne	s5,s3,80003f54 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003f96:	21c48513          	addi	a0,s1,540
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	6fe080e7          	jalr	1790(ra) # 80001698 <wakeup>
  release(&pi->lock);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	1e2080e7          	jalr	482(ra) # 80006186 <release>
  return i;
}
    80003fac:	854e                	mv	a0,s3
    80003fae:	60a6                	ld	ra,72(sp)
    80003fb0:	6406                	ld	s0,64(sp)
    80003fb2:	74e2                	ld	s1,56(sp)
    80003fb4:	7942                	ld	s2,48(sp)
    80003fb6:	79a2                	ld	s3,40(sp)
    80003fb8:	7a02                	ld	s4,32(sp)
    80003fba:	6ae2                	ld	s5,24(sp)
    80003fbc:	6b42                	ld	s6,16(sp)
    80003fbe:	6161                	addi	sp,sp,80
    80003fc0:	8082                	ret
      release(&pi->lock);
    80003fc2:	8526                	mv	a0,s1
    80003fc4:	00002097          	auipc	ra,0x2
    80003fc8:	1c2080e7          	jalr	450(ra) # 80006186 <release>
      return -1;
    80003fcc:	59fd                	li	s3,-1
    80003fce:	bff9                	j	80003fac <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd0:	4981                	li	s3,0
    80003fd2:	b7d1                	j	80003f96 <piperead+0xae>

0000000080003fd4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003fd4:	df010113          	addi	sp,sp,-528
    80003fd8:	20113423          	sd	ra,520(sp)
    80003fdc:	20813023          	sd	s0,512(sp)
    80003fe0:	ffa6                	sd	s1,504(sp)
    80003fe2:	fbca                	sd	s2,496(sp)
    80003fe4:	f7ce                	sd	s3,488(sp)
    80003fe6:	f3d2                	sd	s4,480(sp)
    80003fe8:	efd6                	sd	s5,472(sp)
    80003fea:	ebda                	sd	s6,464(sp)
    80003fec:	e7de                	sd	s7,456(sp)
    80003fee:	e3e2                	sd	s8,448(sp)
    80003ff0:	ff66                	sd	s9,440(sp)
    80003ff2:	fb6a                	sd	s10,432(sp)
    80003ff4:	f76e                	sd	s11,424(sp)
    80003ff6:	0c00                	addi	s0,sp,528
    80003ff8:	84aa                	mv	s1,a0
    80003ffa:	dea43c23          	sd	a0,-520(s0)
    80003ffe:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	e46080e7          	jalr	-442(ra) # 80000e48 <myproc>
    8000400a:	892a                	mv	s2,a0

  begin_op();
    8000400c:	fffff097          	auipc	ra,0xfffff
    80004010:	49c080e7          	jalr	1180(ra) # 800034a8 <begin_op>

  if((ip = namei(path)) == 0){
    80004014:	8526                	mv	a0,s1
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	276080e7          	jalr	630(ra) # 8000328c <namei>
    8000401e:	c92d                	beqz	a0,80004090 <exec+0xbc>
    80004020:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004022:	fffff097          	auipc	ra,0xfffff
    80004026:	ab4080e7          	jalr	-1356(ra) # 80002ad6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000402a:	04000713          	li	a4,64
    8000402e:	4681                	li	a3,0
    80004030:	e5040613          	addi	a2,s0,-432
    80004034:	4581                	li	a1,0
    80004036:	8526                	mv	a0,s1
    80004038:	fffff097          	auipc	ra,0xfffff
    8000403c:	d52080e7          	jalr	-686(ra) # 80002d8a <readi>
    80004040:	04000793          	li	a5,64
    80004044:	00f51a63          	bne	a0,a5,80004058 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004048:	e5042703          	lw	a4,-432(s0)
    8000404c:	464c47b7          	lui	a5,0x464c4
    80004050:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004054:	04f70463          	beq	a4,a5,8000409c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004058:	8526                	mv	a0,s1
    8000405a:	fffff097          	auipc	ra,0xfffff
    8000405e:	cde080e7          	jalr	-802(ra) # 80002d38 <iunlockput>
    end_op();
    80004062:	fffff097          	auipc	ra,0xfffff
    80004066:	4c6080e7          	jalr	1222(ra) # 80003528 <end_op>
  }
  return -1;
    8000406a:	557d                	li	a0,-1
}
    8000406c:	20813083          	ld	ra,520(sp)
    80004070:	20013403          	ld	s0,512(sp)
    80004074:	74fe                	ld	s1,504(sp)
    80004076:	795e                	ld	s2,496(sp)
    80004078:	79be                	ld	s3,488(sp)
    8000407a:	7a1e                	ld	s4,480(sp)
    8000407c:	6afe                	ld	s5,472(sp)
    8000407e:	6b5e                	ld	s6,464(sp)
    80004080:	6bbe                	ld	s7,456(sp)
    80004082:	6c1e                	ld	s8,448(sp)
    80004084:	7cfa                	ld	s9,440(sp)
    80004086:	7d5a                	ld	s10,432(sp)
    80004088:	7dba                	ld	s11,424(sp)
    8000408a:	21010113          	addi	sp,sp,528
    8000408e:	8082                	ret
    end_op();
    80004090:	fffff097          	auipc	ra,0xfffff
    80004094:	498080e7          	jalr	1176(ra) # 80003528 <end_op>
    return -1;
    80004098:	557d                	li	a0,-1
    8000409a:	bfc9                	j	8000406c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000409c:	854a                	mv	a0,s2
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	e6e080e7          	jalr	-402(ra) # 80000f0c <proc_pagetable>
    800040a6:	8baa                	mv	s7,a0
    800040a8:	d945                	beqz	a0,80004058 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040aa:	e7042983          	lw	s3,-400(s0)
    800040ae:	e8845783          	lhu	a5,-376(s0)
    800040b2:	c7ad                	beqz	a5,8000411c <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040b4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040b6:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800040b8:	6c85                	lui	s9,0x1
    800040ba:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800040be:	def43823          	sd	a5,-528(s0)
    800040c2:	a42d                	j	800042ec <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800040c4:	00004517          	auipc	a0,0x4
    800040c8:	6f450513          	addi	a0,a0,1780 # 800087b8 <syscall_names+0x280>
    800040cc:	00002097          	auipc	ra,0x2
    800040d0:	abc080e7          	jalr	-1348(ra) # 80005b88 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040d4:	8756                	mv	a4,s5
    800040d6:	012d86bb          	addw	a3,s11,s2
    800040da:	4581                	li	a1,0
    800040dc:	8526                	mv	a0,s1
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	cac080e7          	jalr	-852(ra) # 80002d8a <readi>
    800040e6:	2501                	sext.w	a0,a0
    800040e8:	1aaa9963          	bne	s5,a0,8000429a <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800040ec:	6785                	lui	a5,0x1
    800040ee:	0127893b          	addw	s2,a5,s2
    800040f2:	77fd                	lui	a5,0xfffff
    800040f4:	01478a3b          	addw	s4,a5,s4
    800040f8:	1f897163          	bgeu	s2,s8,800042da <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800040fc:	02091593          	slli	a1,s2,0x20
    80004100:	9181                	srli	a1,a1,0x20
    80004102:	95ea                	add	a1,a1,s10
    80004104:	855e                	mv	a0,s7
    80004106:	ffffc097          	auipc	ra,0xffffc
    8000410a:	400080e7          	jalr	1024(ra) # 80000506 <walkaddr>
    8000410e:	862a                	mv	a2,a0
    if(pa == 0)
    80004110:	d955                	beqz	a0,800040c4 <exec+0xf0>
      n = PGSIZE;
    80004112:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004114:	fd9a70e3          	bgeu	s4,s9,800040d4 <exec+0x100>
      n = sz - i;
    80004118:	8ad2                	mv	s5,s4
    8000411a:	bf6d                	j	800040d4 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000411c:	4901                	li	s2,0
  iunlockput(ip);
    8000411e:	8526                	mv	a0,s1
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	c18080e7          	jalr	-1000(ra) # 80002d38 <iunlockput>
  end_op();
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	400080e7          	jalr	1024(ra) # 80003528 <end_op>
  p = myproc();
    80004130:	ffffd097          	auipc	ra,0xffffd
    80004134:	d18080e7          	jalr	-744(ra) # 80000e48 <myproc>
    80004138:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000413a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000413e:	6785                	lui	a5,0x1
    80004140:	17fd                	addi	a5,a5,-1
    80004142:	993e                	add	s2,s2,a5
    80004144:	757d                	lui	a0,0xfffff
    80004146:	00a977b3          	and	a5,s2,a0
    8000414a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000414e:	6609                	lui	a2,0x2
    80004150:	963e                	add	a2,a2,a5
    80004152:	85be                	mv	a1,a5
    80004154:	855e                	mv	a0,s7
    80004156:	ffffc097          	auipc	ra,0xffffc
    8000415a:	764080e7          	jalr	1892(ra) # 800008ba <uvmalloc>
    8000415e:	8b2a                	mv	s6,a0
  ip = 0;
    80004160:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004162:	12050c63          	beqz	a0,8000429a <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004166:	75f9                	lui	a1,0xffffe
    80004168:	95aa                	add	a1,a1,a0
    8000416a:	855e                	mv	a0,s7
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	96c080e7          	jalr	-1684(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004174:	7c7d                	lui	s8,0xfffff
    80004176:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004178:	e0043783          	ld	a5,-512(s0)
    8000417c:	6388                	ld	a0,0(a5)
    8000417e:	c535                	beqz	a0,800041ea <exec+0x216>
    80004180:	e9040993          	addi	s3,s0,-368
    80004184:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004188:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000418a:	ffffc097          	auipc	ra,0xffffc
    8000418e:	172080e7          	jalr	370(ra) # 800002fc <strlen>
    80004192:	2505                	addiw	a0,a0,1
    80004194:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004198:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000419c:	13896363          	bltu	s2,s8,800042c2 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041a0:	e0043d83          	ld	s11,-512(s0)
    800041a4:	000dba03          	ld	s4,0(s11)
    800041a8:	8552                	mv	a0,s4
    800041aa:	ffffc097          	auipc	ra,0xffffc
    800041ae:	152080e7          	jalr	338(ra) # 800002fc <strlen>
    800041b2:	0015069b          	addiw	a3,a0,1
    800041b6:	8652                	mv	a2,s4
    800041b8:	85ca                	mv	a1,s2
    800041ba:	855e                	mv	a0,s7
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	94e080e7          	jalr	-1714(ra) # 80000b0a <copyout>
    800041c4:	10054363          	bltz	a0,800042ca <exec+0x2f6>
    ustack[argc] = sp;
    800041c8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800041cc:	0485                	addi	s1,s1,1
    800041ce:	008d8793          	addi	a5,s11,8
    800041d2:	e0f43023          	sd	a5,-512(s0)
    800041d6:	008db503          	ld	a0,8(s11)
    800041da:	c911                	beqz	a0,800041ee <exec+0x21a>
    if(argc >= MAXARG)
    800041dc:	09a1                	addi	s3,s3,8
    800041de:	fb3c96e3          	bne	s9,s3,8000418a <exec+0x1b6>
  sz = sz1;
    800041e2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800041e6:	4481                	li	s1,0
    800041e8:	a84d                	j	8000429a <exec+0x2c6>
  sp = sz;
    800041ea:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800041ec:	4481                	li	s1,0
  ustack[argc] = 0;
    800041ee:	00349793          	slli	a5,s1,0x3
    800041f2:	f9040713          	addi	a4,s0,-112
    800041f6:	97ba                	add	a5,a5,a4
    800041f8:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800041fc:	00148693          	addi	a3,s1,1
    80004200:	068e                	slli	a3,a3,0x3
    80004202:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004206:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000420a:	01897663          	bgeu	s2,s8,80004216 <exec+0x242>
  sz = sz1;
    8000420e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004212:	4481                	li	s1,0
    80004214:	a059                	j	8000429a <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004216:	e9040613          	addi	a2,s0,-368
    8000421a:	85ca                	mv	a1,s2
    8000421c:	855e                	mv	a0,s7
    8000421e:	ffffd097          	auipc	ra,0xffffd
    80004222:	8ec080e7          	jalr	-1812(ra) # 80000b0a <copyout>
    80004226:	0a054663          	bltz	a0,800042d2 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000422a:	058ab783          	ld	a5,88(s5)
    8000422e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004232:	df843783          	ld	a5,-520(s0)
    80004236:	0007c703          	lbu	a4,0(a5)
    8000423a:	cf11                	beqz	a4,80004256 <exec+0x282>
    8000423c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000423e:	02f00693          	li	a3,47
    80004242:	a039                	j	80004250 <exec+0x27c>
      last = s+1;
    80004244:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004248:	0785                	addi	a5,a5,1
    8000424a:	fff7c703          	lbu	a4,-1(a5)
    8000424e:	c701                	beqz	a4,80004256 <exec+0x282>
    if(*s == '/')
    80004250:	fed71ce3          	bne	a4,a3,80004248 <exec+0x274>
    80004254:	bfc5                	j	80004244 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004256:	4641                	li	a2,16
    80004258:	df843583          	ld	a1,-520(s0)
    8000425c:	158a8513          	addi	a0,s5,344
    80004260:	ffffc097          	auipc	ra,0xffffc
    80004264:	06a080e7          	jalr	106(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004268:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000426c:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004270:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004274:	058ab783          	ld	a5,88(s5)
    80004278:	e6843703          	ld	a4,-408(s0)
    8000427c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000427e:	058ab783          	ld	a5,88(s5)
    80004282:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004286:	85ea                	mv	a1,s10
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	d20080e7          	jalr	-736(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004290:	0004851b          	sext.w	a0,s1
    80004294:	bbe1                	j	8000406c <exec+0x98>
    80004296:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000429a:	e0843583          	ld	a1,-504(s0)
    8000429e:	855e                	mv	a0,s7
    800042a0:	ffffd097          	auipc	ra,0xffffd
    800042a4:	d08080e7          	jalr	-760(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    800042a8:	da0498e3          	bnez	s1,80004058 <exec+0x84>
  return -1;
    800042ac:	557d                	li	a0,-1
    800042ae:	bb7d                	j	8000406c <exec+0x98>
    800042b0:	e1243423          	sd	s2,-504(s0)
    800042b4:	b7dd                	j	8000429a <exec+0x2c6>
    800042b6:	e1243423          	sd	s2,-504(s0)
    800042ba:	b7c5                	j	8000429a <exec+0x2c6>
    800042bc:	e1243423          	sd	s2,-504(s0)
    800042c0:	bfe9                	j	8000429a <exec+0x2c6>
  sz = sz1;
    800042c2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042c6:	4481                	li	s1,0
    800042c8:	bfc9                	j	8000429a <exec+0x2c6>
  sz = sz1;
    800042ca:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042ce:	4481                	li	s1,0
    800042d0:	b7e9                	j	8000429a <exec+0x2c6>
  sz = sz1;
    800042d2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042d6:	4481                	li	s1,0
    800042d8:	b7c9                	j	8000429a <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042da:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042de:	2b05                	addiw	s6,s6,1
    800042e0:	0389899b          	addiw	s3,s3,56
    800042e4:	e8845783          	lhu	a5,-376(s0)
    800042e8:	e2fb5be3          	bge	s6,a5,8000411e <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042ec:	2981                	sext.w	s3,s3
    800042ee:	03800713          	li	a4,56
    800042f2:	86ce                	mv	a3,s3
    800042f4:	e1840613          	addi	a2,s0,-488
    800042f8:	4581                	li	a1,0
    800042fa:	8526                	mv	a0,s1
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	a8e080e7          	jalr	-1394(ra) # 80002d8a <readi>
    80004304:	03800793          	li	a5,56
    80004308:	f8f517e3          	bne	a0,a5,80004296 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000430c:	e1842783          	lw	a5,-488(s0)
    80004310:	4705                	li	a4,1
    80004312:	fce796e3          	bne	a5,a4,800042de <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004316:	e4043603          	ld	a2,-448(s0)
    8000431a:	e3843783          	ld	a5,-456(s0)
    8000431e:	f8f669e3          	bltu	a2,a5,800042b0 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004322:	e2843783          	ld	a5,-472(s0)
    80004326:	963e                	add	a2,a2,a5
    80004328:	f8f667e3          	bltu	a2,a5,800042b6 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000432c:	85ca                	mv	a1,s2
    8000432e:	855e                	mv	a0,s7
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	58a080e7          	jalr	1418(ra) # 800008ba <uvmalloc>
    80004338:	e0a43423          	sd	a0,-504(s0)
    8000433c:	d141                	beqz	a0,800042bc <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000433e:	e2843d03          	ld	s10,-472(s0)
    80004342:	df043783          	ld	a5,-528(s0)
    80004346:	00fd77b3          	and	a5,s10,a5
    8000434a:	fba1                	bnez	a5,8000429a <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000434c:	e2042d83          	lw	s11,-480(s0)
    80004350:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004354:	f80c03e3          	beqz	s8,800042da <exec+0x306>
    80004358:	8a62                	mv	s4,s8
    8000435a:	4901                	li	s2,0
    8000435c:	b345                	j	800040fc <exec+0x128>

000000008000435e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000435e:	7179                	addi	sp,sp,-48
    80004360:	f406                	sd	ra,40(sp)
    80004362:	f022                	sd	s0,32(sp)
    80004364:	ec26                	sd	s1,24(sp)
    80004366:	e84a                	sd	s2,16(sp)
    80004368:	1800                	addi	s0,sp,48
    8000436a:	892e                	mv	s2,a1
    8000436c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000436e:	fdc40593          	addi	a1,s0,-36
    80004372:	ffffe097          	auipc	ra,0xffffe
    80004376:	b8a080e7          	jalr	-1142(ra) # 80001efc <argint>
    8000437a:	04054063          	bltz	a0,800043ba <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000437e:	fdc42703          	lw	a4,-36(s0)
    80004382:	47bd                	li	a5,15
    80004384:	02e7ed63          	bltu	a5,a4,800043be <argfd+0x60>
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	ac0080e7          	jalr	-1344(ra) # 80000e48 <myproc>
    80004390:	fdc42703          	lw	a4,-36(s0)
    80004394:	01a70793          	addi	a5,a4,26
    80004398:	078e                	slli	a5,a5,0x3
    8000439a:	953e                	add	a0,a0,a5
    8000439c:	611c                	ld	a5,0(a0)
    8000439e:	c395                	beqz	a5,800043c2 <argfd+0x64>
    return -1;
  if(pfd)
    800043a0:	00090463          	beqz	s2,800043a8 <argfd+0x4a>
    *pfd = fd;
    800043a4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800043a8:	4501                	li	a0,0
  if(pf)
    800043aa:	c091                	beqz	s1,800043ae <argfd+0x50>
    *pf = f;
    800043ac:	e09c                	sd	a5,0(s1)
}
    800043ae:	70a2                	ld	ra,40(sp)
    800043b0:	7402                	ld	s0,32(sp)
    800043b2:	64e2                	ld	s1,24(sp)
    800043b4:	6942                	ld	s2,16(sp)
    800043b6:	6145                	addi	sp,sp,48
    800043b8:	8082                	ret
    return -1;
    800043ba:	557d                	li	a0,-1
    800043bc:	bfcd                	j	800043ae <argfd+0x50>
    return -1;
    800043be:	557d                	li	a0,-1
    800043c0:	b7fd                	j	800043ae <argfd+0x50>
    800043c2:	557d                	li	a0,-1
    800043c4:	b7ed                	j	800043ae <argfd+0x50>

00000000800043c6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800043c6:	1101                	addi	sp,sp,-32
    800043c8:	ec06                	sd	ra,24(sp)
    800043ca:	e822                	sd	s0,16(sp)
    800043cc:	e426                	sd	s1,8(sp)
    800043ce:	1000                	addi	s0,sp,32
    800043d0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800043d2:	ffffd097          	auipc	ra,0xffffd
    800043d6:	a76080e7          	jalr	-1418(ra) # 80000e48 <myproc>
    800043da:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800043dc:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800043e0:	4501                	li	a0,0
    800043e2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800043e4:	6398                	ld	a4,0(a5)
    800043e6:	cb19                	beqz	a4,800043fc <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800043e8:	2505                	addiw	a0,a0,1
    800043ea:	07a1                	addi	a5,a5,8
    800043ec:	fed51ce3          	bne	a0,a3,800043e4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800043f0:	557d                	li	a0,-1
}
    800043f2:	60e2                	ld	ra,24(sp)
    800043f4:	6442                	ld	s0,16(sp)
    800043f6:	64a2                	ld	s1,8(sp)
    800043f8:	6105                	addi	sp,sp,32
    800043fa:	8082                	ret
      p->ofile[fd] = f;
    800043fc:	01a50793          	addi	a5,a0,26
    80004400:	078e                	slli	a5,a5,0x3
    80004402:	963e                	add	a2,a2,a5
    80004404:	e204                	sd	s1,0(a2)
      return fd;
    80004406:	b7f5                	j	800043f2 <fdalloc+0x2c>

0000000080004408 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004408:	715d                	addi	sp,sp,-80
    8000440a:	e486                	sd	ra,72(sp)
    8000440c:	e0a2                	sd	s0,64(sp)
    8000440e:	fc26                	sd	s1,56(sp)
    80004410:	f84a                	sd	s2,48(sp)
    80004412:	f44e                	sd	s3,40(sp)
    80004414:	f052                	sd	s4,32(sp)
    80004416:	ec56                	sd	s5,24(sp)
    80004418:	0880                	addi	s0,sp,80
    8000441a:	89ae                	mv	s3,a1
    8000441c:	8ab2                	mv	s5,a2
    8000441e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004420:	fb040593          	addi	a1,s0,-80
    80004424:	fffff097          	auipc	ra,0xfffff
    80004428:	e86080e7          	jalr	-378(ra) # 800032aa <nameiparent>
    8000442c:	892a                	mv	s2,a0
    8000442e:	12050f63          	beqz	a0,8000456c <create+0x164>
    return 0;

  ilock(dp);
    80004432:	ffffe097          	auipc	ra,0xffffe
    80004436:	6a4080e7          	jalr	1700(ra) # 80002ad6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000443a:	4601                	li	a2,0
    8000443c:	fb040593          	addi	a1,s0,-80
    80004440:	854a                	mv	a0,s2
    80004442:	fffff097          	auipc	ra,0xfffff
    80004446:	b78080e7          	jalr	-1160(ra) # 80002fba <dirlookup>
    8000444a:	84aa                	mv	s1,a0
    8000444c:	c921                	beqz	a0,8000449c <create+0x94>
    iunlockput(dp);
    8000444e:	854a                	mv	a0,s2
    80004450:	fffff097          	auipc	ra,0xfffff
    80004454:	8e8080e7          	jalr	-1816(ra) # 80002d38 <iunlockput>
    ilock(ip);
    80004458:	8526                	mv	a0,s1
    8000445a:	ffffe097          	auipc	ra,0xffffe
    8000445e:	67c080e7          	jalr	1660(ra) # 80002ad6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004462:	2981                	sext.w	s3,s3
    80004464:	4789                	li	a5,2
    80004466:	02f99463          	bne	s3,a5,8000448e <create+0x86>
    8000446a:	0444d783          	lhu	a5,68(s1)
    8000446e:	37f9                	addiw	a5,a5,-2
    80004470:	17c2                	slli	a5,a5,0x30
    80004472:	93c1                	srli	a5,a5,0x30
    80004474:	4705                	li	a4,1
    80004476:	00f76c63          	bltu	a4,a5,8000448e <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000447a:	8526                	mv	a0,s1
    8000447c:	60a6                	ld	ra,72(sp)
    8000447e:	6406                	ld	s0,64(sp)
    80004480:	74e2                	ld	s1,56(sp)
    80004482:	7942                	ld	s2,48(sp)
    80004484:	79a2                	ld	s3,40(sp)
    80004486:	7a02                	ld	s4,32(sp)
    80004488:	6ae2                	ld	s5,24(sp)
    8000448a:	6161                	addi	sp,sp,80
    8000448c:	8082                	ret
    iunlockput(ip);
    8000448e:	8526                	mv	a0,s1
    80004490:	fffff097          	auipc	ra,0xfffff
    80004494:	8a8080e7          	jalr	-1880(ra) # 80002d38 <iunlockput>
    return 0;
    80004498:	4481                	li	s1,0
    8000449a:	b7c5                	j	8000447a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000449c:	85ce                	mv	a1,s3
    8000449e:	00092503          	lw	a0,0(s2)
    800044a2:	ffffe097          	auipc	ra,0xffffe
    800044a6:	49c080e7          	jalr	1180(ra) # 8000293e <ialloc>
    800044aa:	84aa                	mv	s1,a0
    800044ac:	c529                	beqz	a0,800044f6 <create+0xee>
  ilock(ip);
    800044ae:	ffffe097          	auipc	ra,0xffffe
    800044b2:	628080e7          	jalr	1576(ra) # 80002ad6 <ilock>
  ip->major = major;
    800044b6:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800044ba:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800044be:	4785                	li	a5,1
    800044c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800044c4:	8526                	mv	a0,s1
    800044c6:	ffffe097          	auipc	ra,0xffffe
    800044ca:	546080e7          	jalr	1350(ra) # 80002a0c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800044ce:	2981                	sext.w	s3,s3
    800044d0:	4785                	li	a5,1
    800044d2:	02f98a63          	beq	s3,a5,80004506 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800044d6:	40d0                	lw	a2,4(s1)
    800044d8:	fb040593          	addi	a1,s0,-80
    800044dc:	854a                	mv	a0,s2
    800044de:	fffff097          	auipc	ra,0xfffff
    800044e2:	cec080e7          	jalr	-788(ra) # 800031ca <dirlink>
    800044e6:	06054b63          	bltz	a0,8000455c <create+0x154>
  iunlockput(dp);
    800044ea:	854a                	mv	a0,s2
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	84c080e7          	jalr	-1972(ra) # 80002d38 <iunlockput>
  return ip;
    800044f4:	b759                	j	8000447a <create+0x72>
    panic("create: ialloc");
    800044f6:	00004517          	auipc	a0,0x4
    800044fa:	2e250513          	addi	a0,a0,738 # 800087d8 <syscall_names+0x2a0>
    800044fe:	00001097          	auipc	ra,0x1
    80004502:	68a080e7          	jalr	1674(ra) # 80005b88 <panic>
    dp->nlink++;  // for ".."
    80004506:	04a95783          	lhu	a5,74(s2)
    8000450a:	2785                	addiw	a5,a5,1
    8000450c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004510:	854a                	mv	a0,s2
    80004512:	ffffe097          	auipc	ra,0xffffe
    80004516:	4fa080e7          	jalr	1274(ra) # 80002a0c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000451a:	40d0                	lw	a2,4(s1)
    8000451c:	00004597          	auipc	a1,0x4
    80004520:	2cc58593          	addi	a1,a1,716 # 800087e8 <syscall_names+0x2b0>
    80004524:	8526                	mv	a0,s1
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	ca4080e7          	jalr	-860(ra) # 800031ca <dirlink>
    8000452e:	00054f63          	bltz	a0,8000454c <create+0x144>
    80004532:	00492603          	lw	a2,4(s2)
    80004536:	00004597          	auipc	a1,0x4
    8000453a:	2ba58593          	addi	a1,a1,698 # 800087f0 <syscall_names+0x2b8>
    8000453e:	8526                	mv	a0,s1
    80004540:	fffff097          	auipc	ra,0xfffff
    80004544:	c8a080e7          	jalr	-886(ra) # 800031ca <dirlink>
    80004548:	f80557e3          	bgez	a0,800044d6 <create+0xce>
      panic("create dots");
    8000454c:	00004517          	auipc	a0,0x4
    80004550:	2ac50513          	addi	a0,a0,684 # 800087f8 <syscall_names+0x2c0>
    80004554:	00001097          	auipc	ra,0x1
    80004558:	634080e7          	jalr	1588(ra) # 80005b88 <panic>
    panic("create: dirlink");
    8000455c:	00004517          	auipc	a0,0x4
    80004560:	2ac50513          	addi	a0,a0,684 # 80008808 <syscall_names+0x2d0>
    80004564:	00001097          	auipc	ra,0x1
    80004568:	624080e7          	jalr	1572(ra) # 80005b88 <panic>
    return 0;
    8000456c:	84aa                	mv	s1,a0
    8000456e:	b731                	j	8000447a <create+0x72>

0000000080004570 <sys_dup>:
{
    80004570:	7179                	addi	sp,sp,-48
    80004572:	f406                	sd	ra,40(sp)
    80004574:	f022                	sd	s0,32(sp)
    80004576:	ec26                	sd	s1,24(sp)
    80004578:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000457a:	fd840613          	addi	a2,s0,-40
    8000457e:	4581                	li	a1,0
    80004580:	4501                	li	a0,0
    80004582:	00000097          	auipc	ra,0x0
    80004586:	ddc080e7          	jalr	-548(ra) # 8000435e <argfd>
    return -1;
    8000458a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000458c:	02054363          	bltz	a0,800045b2 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004590:	fd843503          	ld	a0,-40(s0)
    80004594:	00000097          	auipc	ra,0x0
    80004598:	e32080e7          	jalr	-462(ra) # 800043c6 <fdalloc>
    8000459c:	84aa                	mv	s1,a0
    return -1;
    8000459e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800045a0:	00054963          	bltz	a0,800045b2 <sys_dup+0x42>
  filedup(f);
    800045a4:	fd843503          	ld	a0,-40(s0)
    800045a8:	fffff097          	auipc	ra,0xfffff
    800045ac:	37a080e7          	jalr	890(ra) # 80003922 <filedup>
  return fd;
    800045b0:	87a6                	mv	a5,s1
}
    800045b2:	853e                	mv	a0,a5
    800045b4:	70a2                	ld	ra,40(sp)
    800045b6:	7402                	ld	s0,32(sp)
    800045b8:	64e2                	ld	s1,24(sp)
    800045ba:	6145                	addi	sp,sp,48
    800045bc:	8082                	ret

00000000800045be <sys_read>:
{
    800045be:	7179                	addi	sp,sp,-48
    800045c0:	f406                	sd	ra,40(sp)
    800045c2:	f022                	sd	s0,32(sp)
    800045c4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045c6:	fe840613          	addi	a2,s0,-24
    800045ca:	4581                	li	a1,0
    800045cc:	4501                	li	a0,0
    800045ce:	00000097          	auipc	ra,0x0
    800045d2:	d90080e7          	jalr	-624(ra) # 8000435e <argfd>
    return -1;
    800045d6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045d8:	04054163          	bltz	a0,8000461a <sys_read+0x5c>
    800045dc:	fe440593          	addi	a1,s0,-28
    800045e0:	4509                	li	a0,2
    800045e2:	ffffe097          	auipc	ra,0xffffe
    800045e6:	91a080e7          	jalr	-1766(ra) # 80001efc <argint>
    return -1;
    800045ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800045ec:	02054763          	bltz	a0,8000461a <sys_read+0x5c>
    800045f0:	fd840593          	addi	a1,s0,-40
    800045f4:	4505                	li	a0,1
    800045f6:	ffffe097          	auipc	ra,0xffffe
    800045fa:	928080e7          	jalr	-1752(ra) # 80001f1e <argaddr>
    return -1;
    800045fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004600:	00054d63          	bltz	a0,8000461a <sys_read+0x5c>
  return fileread(f, p, n);
    80004604:	fe442603          	lw	a2,-28(s0)
    80004608:	fd843583          	ld	a1,-40(s0)
    8000460c:	fe843503          	ld	a0,-24(s0)
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	49e080e7          	jalr	1182(ra) # 80003aae <fileread>
    80004618:	87aa                	mv	a5,a0
}
    8000461a:	853e                	mv	a0,a5
    8000461c:	70a2                	ld	ra,40(sp)
    8000461e:	7402                	ld	s0,32(sp)
    80004620:	6145                	addi	sp,sp,48
    80004622:	8082                	ret

0000000080004624 <sys_write>:
{
    80004624:	7179                	addi	sp,sp,-48
    80004626:	f406                	sd	ra,40(sp)
    80004628:	f022                	sd	s0,32(sp)
    8000462a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000462c:	fe840613          	addi	a2,s0,-24
    80004630:	4581                	li	a1,0
    80004632:	4501                	li	a0,0
    80004634:	00000097          	auipc	ra,0x0
    80004638:	d2a080e7          	jalr	-726(ra) # 8000435e <argfd>
    return -1;
    8000463c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000463e:	04054163          	bltz	a0,80004680 <sys_write+0x5c>
    80004642:	fe440593          	addi	a1,s0,-28
    80004646:	4509                	li	a0,2
    80004648:	ffffe097          	auipc	ra,0xffffe
    8000464c:	8b4080e7          	jalr	-1868(ra) # 80001efc <argint>
    return -1;
    80004650:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004652:	02054763          	bltz	a0,80004680 <sys_write+0x5c>
    80004656:	fd840593          	addi	a1,s0,-40
    8000465a:	4505                	li	a0,1
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	8c2080e7          	jalr	-1854(ra) # 80001f1e <argaddr>
    return -1;
    80004664:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004666:	00054d63          	bltz	a0,80004680 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000466a:	fe442603          	lw	a2,-28(s0)
    8000466e:	fd843583          	ld	a1,-40(s0)
    80004672:	fe843503          	ld	a0,-24(s0)
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	4fa080e7          	jalr	1274(ra) # 80003b70 <filewrite>
    8000467e:	87aa                	mv	a5,a0
}
    80004680:	853e                	mv	a0,a5
    80004682:	70a2                	ld	ra,40(sp)
    80004684:	7402                	ld	s0,32(sp)
    80004686:	6145                	addi	sp,sp,48
    80004688:	8082                	ret

000000008000468a <sys_close>:
{
    8000468a:	1101                	addi	sp,sp,-32
    8000468c:	ec06                	sd	ra,24(sp)
    8000468e:	e822                	sd	s0,16(sp)
    80004690:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004692:	fe040613          	addi	a2,s0,-32
    80004696:	fec40593          	addi	a1,s0,-20
    8000469a:	4501                	li	a0,0
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	cc2080e7          	jalr	-830(ra) # 8000435e <argfd>
    return -1;
    800046a4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046a6:	02054463          	bltz	a0,800046ce <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800046aa:	ffffc097          	auipc	ra,0xffffc
    800046ae:	79e080e7          	jalr	1950(ra) # 80000e48 <myproc>
    800046b2:	fec42783          	lw	a5,-20(s0)
    800046b6:	07e9                	addi	a5,a5,26
    800046b8:	078e                	slli	a5,a5,0x3
    800046ba:	97aa                	add	a5,a5,a0
    800046bc:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800046c0:	fe043503          	ld	a0,-32(s0)
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	2b0080e7          	jalr	688(ra) # 80003974 <fileclose>
  return 0;
    800046cc:	4781                	li	a5,0
}
    800046ce:	853e                	mv	a0,a5
    800046d0:	60e2                	ld	ra,24(sp)
    800046d2:	6442                	ld	s0,16(sp)
    800046d4:	6105                	addi	sp,sp,32
    800046d6:	8082                	ret

00000000800046d8 <sys_fstat>:
{
    800046d8:	1101                	addi	sp,sp,-32
    800046da:	ec06                	sd	ra,24(sp)
    800046dc:	e822                	sd	s0,16(sp)
    800046de:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800046e0:	fe840613          	addi	a2,s0,-24
    800046e4:	4581                	li	a1,0
    800046e6:	4501                	li	a0,0
    800046e8:	00000097          	auipc	ra,0x0
    800046ec:	c76080e7          	jalr	-906(ra) # 8000435e <argfd>
    return -1;
    800046f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800046f2:	02054563          	bltz	a0,8000471c <sys_fstat+0x44>
    800046f6:	fe040593          	addi	a1,s0,-32
    800046fa:	4505                	li	a0,1
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	822080e7          	jalr	-2014(ra) # 80001f1e <argaddr>
    return -1;
    80004704:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004706:	00054b63          	bltz	a0,8000471c <sys_fstat+0x44>
  return filestat(f, st);
    8000470a:	fe043583          	ld	a1,-32(s0)
    8000470e:	fe843503          	ld	a0,-24(s0)
    80004712:	fffff097          	auipc	ra,0xfffff
    80004716:	32a080e7          	jalr	810(ra) # 80003a3c <filestat>
    8000471a:	87aa                	mv	a5,a0
}
    8000471c:	853e                	mv	a0,a5
    8000471e:	60e2                	ld	ra,24(sp)
    80004720:	6442                	ld	s0,16(sp)
    80004722:	6105                	addi	sp,sp,32
    80004724:	8082                	ret

0000000080004726 <sys_link>:
{
    80004726:	7169                	addi	sp,sp,-304
    80004728:	f606                	sd	ra,296(sp)
    8000472a:	f222                	sd	s0,288(sp)
    8000472c:	ee26                	sd	s1,280(sp)
    8000472e:	ea4a                	sd	s2,272(sp)
    80004730:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004732:	08000613          	li	a2,128
    80004736:	ed040593          	addi	a1,s0,-304
    8000473a:	4501                	li	a0,0
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	804080e7          	jalr	-2044(ra) # 80001f40 <argstr>
    return -1;
    80004744:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004746:	10054e63          	bltz	a0,80004862 <sys_link+0x13c>
    8000474a:	08000613          	li	a2,128
    8000474e:	f5040593          	addi	a1,s0,-176
    80004752:	4505                	li	a0,1
    80004754:	ffffd097          	auipc	ra,0xffffd
    80004758:	7ec080e7          	jalr	2028(ra) # 80001f40 <argstr>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000475e:	10054263          	bltz	a0,80004862 <sys_link+0x13c>
  begin_op();
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	d46080e7          	jalr	-698(ra) # 800034a8 <begin_op>
  if((ip = namei(old)) == 0){
    8000476a:	ed040513          	addi	a0,s0,-304
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	b1e080e7          	jalr	-1250(ra) # 8000328c <namei>
    80004776:	84aa                	mv	s1,a0
    80004778:	c551                	beqz	a0,80004804 <sys_link+0xde>
  ilock(ip);
    8000477a:	ffffe097          	auipc	ra,0xffffe
    8000477e:	35c080e7          	jalr	860(ra) # 80002ad6 <ilock>
  if(ip->type == T_DIR){
    80004782:	04449703          	lh	a4,68(s1)
    80004786:	4785                	li	a5,1
    80004788:	08f70463          	beq	a4,a5,80004810 <sys_link+0xea>
  ip->nlink++;
    8000478c:	04a4d783          	lhu	a5,74(s1)
    80004790:	2785                	addiw	a5,a5,1
    80004792:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004796:	8526                	mv	a0,s1
    80004798:	ffffe097          	auipc	ra,0xffffe
    8000479c:	274080e7          	jalr	628(ra) # 80002a0c <iupdate>
  iunlock(ip);
    800047a0:	8526                	mv	a0,s1
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	3f6080e7          	jalr	1014(ra) # 80002b98 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047aa:	fd040593          	addi	a1,s0,-48
    800047ae:	f5040513          	addi	a0,s0,-176
    800047b2:	fffff097          	auipc	ra,0xfffff
    800047b6:	af8080e7          	jalr	-1288(ra) # 800032aa <nameiparent>
    800047ba:	892a                	mv	s2,a0
    800047bc:	c935                	beqz	a0,80004830 <sys_link+0x10a>
  ilock(dp);
    800047be:	ffffe097          	auipc	ra,0xffffe
    800047c2:	318080e7          	jalr	792(ra) # 80002ad6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047c6:	00092703          	lw	a4,0(s2)
    800047ca:	409c                	lw	a5,0(s1)
    800047cc:	04f71d63          	bne	a4,a5,80004826 <sys_link+0x100>
    800047d0:	40d0                	lw	a2,4(s1)
    800047d2:	fd040593          	addi	a1,s0,-48
    800047d6:	854a                	mv	a0,s2
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	9f2080e7          	jalr	-1550(ra) # 800031ca <dirlink>
    800047e0:	04054363          	bltz	a0,80004826 <sys_link+0x100>
  iunlockput(dp);
    800047e4:	854a                	mv	a0,s2
    800047e6:	ffffe097          	auipc	ra,0xffffe
    800047ea:	552080e7          	jalr	1362(ra) # 80002d38 <iunlockput>
  iput(ip);
    800047ee:	8526                	mv	a0,s1
    800047f0:	ffffe097          	auipc	ra,0xffffe
    800047f4:	4a0080e7          	jalr	1184(ra) # 80002c90 <iput>
  end_op();
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	d30080e7          	jalr	-720(ra) # 80003528 <end_op>
  return 0;
    80004800:	4781                	li	a5,0
    80004802:	a085                	j	80004862 <sys_link+0x13c>
    end_op();
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	d24080e7          	jalr	-732(ra) # 80003528 <end_op>
    return -1;
    8000480c:	57fd                	li	a5,-1
    8000480e:	a891                	j	80004862 <sys_link+0x13c>
    iunlockput(ip);
    80004810:	8526                	mv	a0,s1
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	526080e7          	jalr	1318(ra) # 80002d38 <iunlockput>
    end_op();
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	d0e080e7          	jalr	-754(ra) # 80003528 <end_op>
    return -1;
    80004822:	57fd                	li	a5,-1
    80004824:	a83d                	j	80004862 <sys_link+0x13c>
    iunlockput(dp);
    80004826:	854a                	mv	a0,s2
    80004828:	ffffe097          	auipc	ra,0xffffe
    8000482c:	510080e7          	jalr	1296(ra) # 80002d38 <iunlockput>
  ilock(ip);
    80004830:	8526                	mv	a0,s1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	2a4080e7          	jalr	676(ra) # 80002ad6 <ilock>
  ip->nlink--;
    8000483a:	04a4d783          	lhu	a5,74(s1)
    8000483e:	37fd                	addiw	a5,a5,-1
    80004840:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004844:	8526                	mv	a0,s1
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	1c6080e7          	jalr	454(ra) # 80002a0c <iupdate>
  iunlockput(ip);
    8000484e:	8526                	mv	a0,s1
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	4e8080e7          	jalr	1256(ra) # 80002d38 <iunlockput>
  end_op();
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	cd0080e7          	jalr	-816(ra) # 80003528 <end_op>
  return -1;
    80004860:	57fd                	li	a5,-1
}
    80004862:	853e                	mv	a0,a5
    80004864:	70b2                	ld	ra,296(sp)
    80004866:	7412                	ld	s0,288(sp)
    80004868:	64f2                	ld	s1,280(sp)
    8000486a:	6952                	ld	s2,272(sp)
    8000486c:	6155                	addi	sp,sp,304
    8000486e:	8082                	ret

0000000080004870 <sys_unlink>:
{
    80004870:	7151                	addi	sp,sp,-240
    80004872:	f586                	sd	ra,232(sp)
    80004874:	f1a2                	sd	s0,224(sp)
    80004876:	eda6                	sd	s1,216(sp)
    80004878:	e9ca                	sd	s2,208(sp)
    8000487a:	e5ce                	sd	s3,200(sp)
    8000487c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000487e:	08000613          	li	a2,128
    80004882:	f3040593          	addi	a1,s0,-208
    80004886:	4501                	li	a0,0
    80004888:	ffffd097          	auipc	ra,0xffffd
    8000488c:	6b8080e7          	jalr	1720(ra) # 80001f40 <argstr>
    80004890:	18054163          	bltz	a0,80004a12 <sys_unlink+0x1a2>
  begin_op();
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	c14080e7          	jalr	-1004(ra) # 800034a8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000489c:	fb040593          	addi	a1,s0,-80
    800048a0:	f3040513          	addi	a0,s0,-208
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	a06080e7          	jalr	-1530(ra) # 800032aa <nameiparent>
    800048ac:	84aa                	mv	s1,a0
    800048ae:	c979                	beqz	a0,80004984 <sys_unlink+0x114>
  ilock(dp);
    800048b0:	ffffe097          	auipc	ra,0xffffe
    800048b4:	226080e7          	jalr	550(ra) # 80002ad6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048b8:	00004597          	auipc	a1,0x4
    800048bc:	f3058593          	addi	a1,a1,-208 # 800087e8 <syscall_names+0x2b0>
    800048c0:	fb040513          	addi	a0,s0,-80
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	6dc080e7          	jalr	1756(ra) # 80002fa0 <namecmp>
    800048cc:	14050a63          	beqz	a0,80004a20 <sys_unlink+0x1b0>
    800048d0:	00004597          	auipc	a1,0x4
    800048d4:	f2058593          	addi	a1,a1,-224 # 800087f0 <syscall_names+0x2b8>
    800048d8:	fb040513          	addi	a0,s0,-80
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	6c4080e7          	jalr	1732(ra) # 80002fa0 <namecmp>
    800048e4:	12050e63          	beqz	a0,80004a20 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800048e8:	f2c40613          	addi	a2,s0,-212
    800048ec:	fb040593          	addi	a1,s0,-80
    800048f0:	8526                	mv	a0,s1
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	6c8080e7          	jalr	1736(ra) # 80002fba <dirlookup>
    800048fa:	892a                	mv	s2,a0
    800048fc:	12050263          	beqz	a0,80004a20 <sys_unlink+0x1b0>
  ilock(ip);
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	1d6080e7          	jalr	470(ra) # 80002ad6 <ilock>
  if(ip->nlink < 1)
    80004908:	04a91783          	lh	a5,74(s2)
    8000490c:	08f05263          	blez	a5,80004990 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004910:	04491703          	lh	a4,68(s2)
    80004914:	4785                	li	a5,1
    80004916:	08f70563          	beq	a4,a5,800049a0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    8000491a:	4641                	li	a2,16
    8000491c:	4581                	li	a1,0
    8000491e:	fc040513          	addi	a0,s0,-64
    80004922:	ffffc097          	auipc	ra,0xffffc
    80004926:	856080e7          	jalr	-1962(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000492a:	4741                	li	a4,16
    8000492c:	f2c42683          	lw	a3,-212(s0)
    80004930:	fc040613          	addi	a2,s0,-64
    80004934:	4581                	li	a1,0
    80004936:	8526                	mv	a0,s1
    80004938:	ffffe097          	auipc	ra,0xffffe
    8000493c:	54a080e7          	jalr	1354(ra) # 80002e82 <writei>
    80004940:	47c1                	li	a5,16
    80004942:	0af51563          	bne	a0,a5,800049ec <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004946:	04491703          	lh	a4,68(s2)
    8000494a:	4785                	li	a5,1
    8000494c:	0af70863          	beq	a4,a5,800049fc <sys_unlink+0x18c>
  iunlockput(dp);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	3e6080e7          	jalr	998(ra) # 80002d38 <iunlockput>
  ip->nlink--;
    8000495a:	04a95783          	lhu	a5,74(s2)
    8000495e:	37fd                	addiw	a5,a5,-1
    80004960:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004964:	854a                	mv	a0,s2
    80004966:	ffffe097          	auipc	ra,0xffffe
    8000496a:	0a6080e7          	jalr	166(ra) # 80002a0c <iupdate>
  iunlockput(ip);
    8000496e:	854a                	mv	a0,s2
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	3c8080e7          	jalr	968(ra) # 80002d38 <iunlockput>
  end_op();
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	bb0080e7          	jalr	-1104(ra) # 80003528 <end_op>
  return 0;
    80004980:	4501                	li	a0,0
    80004982:	a84d                	j	80004a34 <sys_unlink+0x1c4>
    end_op();
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	ba4080e7          	jalr	-1116(ra) # 80003528 <end_op>
    return -1;
    8000498c:	557d                	li	a0,-1
    8000498e:	a05d                	j	80004a34 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004990:	00004517          	auipc	a0,0x4
    80004994:	e8850513          	addi	a0,a0,-376 # 80008818 <syscall_names+0x2e0>
    80004998:	00001097          	auipc	ra,0x1
    8000499c:	1f0080e7          	jalr	496(ra) # 80005b88 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049a0:	04c92703          	lw	a4,76(s2)
    800049a4:	02000793          	li	a5,32
    800049a8:	f6e7f9e3          	bgeu	a5,a4,8000491a <sys_unlink+0xaa>
    800049ac:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049b0:	4741                	li	a4,16
    800049b2:	86ce                	mv	a3,s3
    800049b4:	f1840613          	addi	a2,s0,-232
    800049b8:	4581                	li	a1,0
    800049ba:	854a                	mv	a0,s2
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	3ce080e7          	jalr	974(ra) # 80002d8a <readi>
    800049c4:	47c1                	li	a5,16
    800049c6:	00f51b63          	bne	a0,a5,800049dc <sys_unlink+0x16c>
    if(de.inum != 0)
    800049ca:	f1845783          	lhu	a5,-232(s0)
    800049ce:	e7a1                	bnez	a5,80004a16 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049d0:	29c1                	addiw	s3,s3,16
    800049d2:	04c92783          	lw	a5,76(s2)
    800049d6:	fcf9ede3          	bltu	s3,a5,800049b0 <sys_unlink+0x140>
    800049da:	b781                	j	8000491a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    800049dc:	00004517          	auipc	a0,0x4
    800049e0:	e5450513          	addi	a0,a0,-428 # 80008830 <syscall_names+0x2f8>
    800049e4:	00001097          	auipc	ra,0x1
    800049e8:	1a4080e7          	jalr	420(ra) # 80005b88 <panic>
    panic("unlink: writei");
    800049ec:	00004517          	auipc	a0,0x4
    800049f0:	e5c50513          	addi	a0,a0,-420 # 80008848 <syscall_names+0x310>
    800049f4:	00001097          	auipc	ra,0x1
    800049f8:	194080e7          	jalr	404(ra) # 80005b88 <panic>
    dp->nlink--;
    800049fc:	04a4d783          	lhu	a5,74(s1)
    80004a00:	37fd                	addiw	a5,a5,-1
    80004a02:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	004080e7          	jalr	4(ra) # 80002a0c <iupdate>
    80004a10:	b781                	j	80004950 <sys_unlink+0xe0>
    return -1;
    80004a12:	557d                	li	a0,-1
    80004a14:	a005                	j	80004a34 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a16:	854a                	mv	a0,s2
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	320080e7          	jalr	800(ra) # 80002d38 <iunlockput>
  iunlockput(dp);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	316080e7          	jalr	790(ra) # 80002d38 <iunlockput>
  end_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	afe080e7          	jalr	-1282(ra) # 80003528 <end_op>
  return -1;
    80004a32:	557d                	li	a0,-1
}
    80004a34:	70ae                	ld	ra,232(sp)
    80004a36:	740e                	ld	s0,224(sp)
    80004a38:	64ee                	ld	s1,216(sp)
    80004a3a:	694e                	ld	s2,208(sp)
    80004a3c:	69ae                	ld	s3,200(sp)
    80004a3e:	616d                	addi	sp,sp,240
    80004a40:	8082                	ret

0000000080004a42 <sys_open>:

uint64
sys_open(void)
{
    80004a42:	7131                	addi	sp,sp,-192
    80004a44:	fd06                	sd	ra,184(sp)
    80004a46:	f922                	sd	s0,176(sp)
    80004a48:	f526                	sd	s1,168(sp)
    80004a4a:	f14a                	sd	s2,160(sp)
    80004a4c:	ed4e                	sd	s3,152(sp)
    80004a4e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a50:	08000613          	li	a2,128
    80004a54:	f5040593          	addi	a1,s0,-176
    80004a58:	4501                	li	a0,0
    80004a5a:	ffffd097          	auipc	ra,0xffffd
    80004a5e:	4e6080e7          	jalr	1254(ra) # 80001f40 <argstr>
    return -1;
    80004a62:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004a64:	0c054163          	bltz	a0,80004b26 <sys_open+0xe4>
    80004a68:	f4c40593          	addi	a1,s0,-180
    80004a6c:	4505                	li	a0,1
    80004a6e:	ffffd097          	auipc	ra,0xffffd
    80004a72:	48e080e7          	jalr	1166(ra) # 80001efc <argint>
    80004a76:	0a054863          	bltz	a0,80004b26 <sys_open+0xe4>

  begin_op();
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	a2e080e7          	jalr	-1490(ra) # 800034a8 <begin_op>

  if(omode & O_CREATE){
    80004a82:	f4c42783          	lw	a5,-180(s0)
    80004a86:	2007f793          	andi	a5,a5,512
    80004a8a:	cbdd                	beqz	a5,80004b40 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004a8c:	4681                	li	a3,0
    80004a8e:	4601                	li	a2,0
    80004a90:	4589                	li	a1,2
    80004a92:	f5040513          	addi	a0,s0,-176
    80004a96:	00000097          	auipc	ra,0x0
    80004a9a:	972080e7          	jalr	-1678(ra) # 80004408 <create>
    80004a9e:	892a                	mv	s2,a0
    if(ip == 0){
    80004aa0:	c959                	beqz	a0,80004b36 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004aa2:	04491703          	lh	a4,68(s2)
    80004aa6:	478d                	li	a5,3
    80004aa8:	00f71763          	bne	a4,a5,80004ab6 <sys_open+0x74>
    80004aac:	04695703          	lhu	a4,70(s2)
    80004ab0:	47a5                	li	a5,9
    80004ab2:	0ce7ec63          	bltu	a5,a4,80004b8a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ab6:	fffff097          	auipc	ra,0xfffff
    80004aba:	e02080e7          	jalr	-510(ra) # 800038b8 <filealloc>
    80004abe:	89aa                	mv	s3,a0
    80004ac0:	10050263          	beqz	a0,80004bc4 <sys_open+0x182>
    80004ac4:	00000097          	auipc	ra,0x0
    80004ac8:	902080e7          	jalr	-1790(ra) # 800043c6 <fdalloc>
    80004acc:	84aa                	mv	s1,a0
    80004ace:	0e054663          	bltz	a0,80004bba <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ad2:	04491703          	lh	a4,68(s2)
    80004ad6:	478d                	li	a5,3
    80004ad8:	0cf70463          	beq	a4,a5,80004ba0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004adc:	4789                	li	a5,2
    80004ade:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ae2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ae6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004aea:	f4c42783          	lw	a5,-180(s0)
    80004aee:	0017c713          	xori	a4,a5,1
    80004af2:	8b05                	andi	a4,a4,1
    80004af4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004af8:	0037f713          	andi	a4,a5,3
    80004afc:	00e03733          	snez	a4,a4
    80004b00:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b04:	4007f793          	andi	a5,a5,1024
    80004b08:	c791                	beqz	a5,80004b14 <sys_open+0xd2>
    80004b0a:	04491703          	lh	a4,68(s2)
    80004b0e:	4789                	li	a5,2
    80004b10:	08f70f63          	beq	a4,a5,80004bae <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b14:	854a                	mv	a0,s2
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	082080e7          	jalr	130(ra) # 80002b98 <iunlock>
  end_op();
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	a0a080e7          	jalr	-1526(ra) # 80003528 <end_op>

  return fd;
}
    80004b26:	8526                	mv	a0,s1
    80004b28:	70ea                	ld	ra,184(sp)
    80004b2a:	744a                	ld	s0,176(sp)
    80004b2c:	74aa                	ld	s1,168(sp)
    80004b2e:	790a                	ld	s2,160(sp)
    80004b30:	69ea                	ld	s3,152(sp)
    80004b32:	6129                	addi	sp,sp,192
    80004b34:	8082                	ret
      end_op();
    80004b36:	fffff097          	auipc	ra,0xfffff
    80004b3a:	9f2080e7          	jalr	-1550(ra) # 80003528 <end_op>
      return -1;
    80004b3e:	b7e5                	j	80004b26 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004b40:	f5040513          	addi	a0,s0,-176
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	748080e7          	jalr	1864(ra) # 8000328c <namei>
    80004b4c:	892a                	mv	s2,a0
    80004b4e:	c905                	beqz	a0,80004b7e <sys_open+0x13c>
    ilock(ip);
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	f86080e7          	jalr	-122(ra) # 80002ad6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b58:	04491703          	lh	a4,68(s2)
    80004b5c:	4785                	li	a5,1
    80004b5e:	f4f712e3          	bne	a4,a5,80004aa2 <sys_open+0x60>
    80004b62:	f4c42783          	lw	a5,-180(s0)
    80004b66:	dba1                	beqz	a5,80004ab6 <sys_open+0x74>
      iunlockput(ip);
    80004b68:	854a                	mv	a0,s2
    80004b6a:	ffffe097          	auipc	ra,0xffffe
    80004b6e:	1ce080e7          	jalr	462(ra) # 80002d38 <iunlockput>
      end_op();
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	9b6080e7          	jalr	-1610(ra) # 80003528 <end_op>
      return -1;
    80004b7a:	54fd                	li	s1,-1
    80004b7c:	b76d                	j	80004b26 <sys_open+0xe4>
      end_op();
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	9aa080e7          	jalr	-1622(ra) # 80003528 <end_op>
      return -1;
    80004b86:	54fd                	li	s1,-1
    80004b88:	bf79                	j	80004b26 <sys_open+0xe4>
    iunlockput(ip);
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	1ac080e7          	jalr	428(ra) # 80002d38 <iunlockput>
    end_op();
    80004b94:	fffff097          	auipc	ra,0xfffff
    80004b98:	994080e7          	jalr	-1644(ra) # 80003528 <end_op>
    return -1;
    80004b9c:	54fd                	li	s1,-1
    80004b9e:	b761                	j	80004b26 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ba0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ba4:	04691783          	lh	a5,70(s2)
    80004ba8:	02f99223          	sh	a5,36(s3)
    80004bac:	bf2d                	j	80004ae6 <sys_open+0xa4>
    itrunc(ip);
    80004bae:	854a                	mv	a0,s2
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	034080e7          	jalr	52(ra) # 80002be4 <itrunc>
    80004bb8:	bfb1                	j	80004b14 <sys_open+0xd2>
      fileclose(f);
    80004bba:	854e                	mv	a0,s3
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	db8080e7          	jalr	-584(ra) # 80003974 <fileclose>
    iunlockput(ip);
    80004bc4:	854a                	mv	a0,s2
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	172080e7          	jalr	370(ra) # 80002d38 <iunlockput>
    end_op();
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	95a080e7          	jalr	-1702(ra) # 80003528 <end_op>
    return -1;
    80004bd6:	54fd                	li	s1,-1
    80004bd8:	b7b9                	j	80004b26 <sys_open+0xe4>

0000000080004bda <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004bda:	7175                	addi	sp,sp,-144
    80004bdc:	e506                	sd	ra,136(sp)
    80004bde:	e122                	sd	s0,128(sp)
    80004be0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	8c6080e7          	jalr	-1850(ra) # 800034a8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004bea:	08000613          	li	a2,128
    80004bee:	f7040593          	addi	a1,s0,-144
    80004bf2:	4501                	li	a0,0
    80004bf4:	ffffd097          	auipc	ra,0xffffd
    80004bf8:	34c080e7          	jalr	844(ra) # 80001f40 <argstr>
    80004bfc:	02054963          	bltz	a0,80004c2e <sys_mkdir+0x54>
    80004c00:	4681                	li	a3,0
    80004c02:	4601                	li	a2,0
    80004c04:	4585                	li	a1,1
    80004c06:	f7040513          	addi	a0,s0,-144
    80004c0a:	fffff097          	auipc	ra,0xfffff
    80004c0e:	7fe080e7          	jalr	2046(ra) # 80004408 <create>
    80004c12:	cd11                	beqz	a0,80004c2e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	124080e7          	jalr	292(ra) # 80002d38 <iunlockput>
  end_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	90c080e7          	jalr	-1780(ra) # 80003528 <end_op>
  return 0;
    80004c24:	4501                	li	a0,0
}
    80004c26:	60aa                	ld	ra,136(sp)
    80004c28:	640a                	ld	s0,128(sp)
    80004c2a:	6149                	addi	sp,sp,144
    80004c2c:	8082                	ret
    end_op();
    80004c2e:	fffff097          	auipc	ra,0xfffff
    80004c32:	8fa080e7          	jalr	-1798(ra) # 80003528 <end_op>
    return -1;
    80004c36:	557d                	li	a0,-1
    80004c38:	b7fd                	j	80004c26 <sys_mkdir+0x4c>

0000000080004c3a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004c3a:	7135                	addi	sp,sp,-160
    80004c3c:	ed06                	sd	ra,152(sp)
    80004c3e:	e922                	sd	s0,144(sp)
    80004c40:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	866080e7          	jalr	-1946(ra) # 800034a8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c4a:	08000613          	li	a2,128
    80004c4e:	f7040593          	addi	a1,s0,-144
    80004c52:	4501                	li	a0,0
    80004c54:	ffffd097          	auipc	ra,0xffffd
    80004c58:	2ec080e7          	jalr	748(ra) # 80001f40 <argstr>
    80004c5c:	04054a63          	bltz	a0,80004cb0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004c60:	f6c40593          	addi	a1,s0,-148
    80004c64:	4505                	li	a0,1
    80004c66:	ffffd097          	auipc	ra,0xffffd
    80004c6a:	296080e7          	jalr	662(ra) # 80001efc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c6e:	04054163          	bltz	a0,80004cb0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004c72:	f6840593          	addi	a1,s0,-152
    80004c76:	4509                	li	a0,2
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	284080e7          	jalr	644(ra) # 80001efc <argint>
     argint(1, &major) < 0 ||
    80004c80:	02054863          	bltz	a0,80004cb0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c84:	f6841683          	lh	a3,-152(s0)
    80004c88:	f6c41603          	lh	a2,-148(s0)
    80004c8c:	458d                	li	a1,3
    80004c8e:	f7040513          	addi	a0,s0,-144
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	776080e7          	jalr	1910(ra) # 80004408 <create>
     argint(2, &minor) < 0 ||
    80004c9a:	c919                	beqz	a0,80004cb0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c9c:	ffffe097          	auipc	ra,0xffffe
    80004ca0:	09c080e7          	jalr	156(ra) # 80002d38 <iunlockput>
  end_op();
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	884080e7          	jalr	-1916(ra) # 80003528 <end_op>
  return 0;
    80004cac:	4501                	li	a0,0
    80004cae:	a031                	j	80004cba <sys_mknod+0x80>
    end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	878080e7          	jalr	-1928(ra) # 80003528 <end_op>
    return -1;
    80004cb8:	557d                	li	a0,-1
}
    80004cba:	60ea                	ld	ra,152(sp)
    80004cbc:	644a                	ld	s0,144(sp)
    80004cbe:	610d                	addi	sp,sp,160
    80004cc0:	8082                	ret

0000000080004cc2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004cc2:	7135                	addi	sp,sp,-160
    80004cc4:	ed06                	sd	ra,152(sp)
    80004cc6:	e922                	sd	s0,144(sp)
    80004cc8:	e526                	sd	s1,136(sp)
    80004cca:	e14a                	sd	s2,128(sp)
    80004ccc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004cce:	ffffc097          	auipc	ra,0xffffc
    80004cd2:	17a080e7          	jalr	378(ra) # 80000e48 <myproc>
    80004cd6:	892a                	mv	s2,a0
  
  begin_op();
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	7d0080e7          	jalr	2000(ra) # 800034a8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ce0:	08000613          	li	a2,128
    80004ce4:	f6040593          	addi	a1,s0,-160
    80004ce8:	4501                	li	a0,0
    80004cea:	ffffd097          	auipc	ra,0xffffd
    80004cee:	256080e7          	jalr	598(ra) # 80001f40 <argstr>
    80004cf2:	04054b63          	bltz	a0,80004d48 <sys_chdir+0x86>
    80004cf6:	f6040513          	addi	a0,s0,-160
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	592080e7          	jalr	1426(ra) # 8000328c <namei>
    80004d02:	84aa                	mv	s1,a0
    80004d04:	c131                	beqz	a0,80004d48 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	dd0080e7          	jalr	-560(ra) # 80002ad6 <ilock>
  if(ip->type != T_DIR){
    80004d0e:	04449703          	lh	a4,68(s1)
    80004d12:	4785                	li	a5,1
    80004d14:	04f71063          	bne	a4,a5,80004d54 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d18:	8526                	mv	a0,s1
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	e7e080e7          	jalr	-386(ra) # 80002b98 <iunlock>
  iput(p->cwd);
    80004d22:	15093503          	ld	a0,336(s2)
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	f6a080e7          	jalr	-150(ra) # 80002c90 <iput>
  end_op();
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	7fa080e7          	jalr	2042(ra) # 80003528 <end_op>
  p->cwd = ip;
    80004d36:	14993823          	sd	s1,336(s2)
  return 0;
    80004d3a:	4501                	li	a0,0
}
    80004d3c:	60ea                	ld	ra,152(sp)
    80004d3e:	644a                	ld	s0,144(sp)
    80004d40:	64aa                	ld	s1,136(sp)
    80004d42:	690a                	ld	s2,128(sp)
    80004d44:	610d                	addi	sp,sp,160
    80004d46:	8082                	ret
    end_op();
    80004d48:	ffffe097          	auipc	ra,0xffffe
    80004d4c:	7e0080e7          	jalr	2016(ra) # 80003528 <end_op>
    return -1;
    80004d50:	557d                	li	a0,-1
    80004d52:	b7ed                	j	80004d3c <sys_chdir+0x7a>
    iunlockput(ip);
    80004d54:	8526                	mv	a0,s1
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	fe2080e7          	jalr	-30(ra) # 80002d38 <iunlockput>
    end_op();
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	7ca080e7          	jalr	1994(ra) # 80003528 <end_op>
    return -1;
    80004d66:	557d                	li	a0,-1
    80004d68:	bfd1                	j	80004d3c <sys_chdir+0x7a>

0000000080004d6a <sys_exec>:

uint64
sys_exec(void)
{
    80004d6a:	7145                	addi	sp,sp,-464
    80004d6c:	e786                	sd	ra,456(sp)
    80004d6e:	e3a2                	sd	s0,448(sp)
    80004d70:	ff26                	sd	s1,440(sp)
    80004d72:	fb4a                	sd	s2,432(sp)
    80004d74:	f74e                	sd	s3,424(sp)
    80004d76:	f352                	sd	s4,416(sp)
    80004d78:	ef56                	sd	s5,408(sp)
    80004d7a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d7c:	08000613          	li	a2,128
    80004d80:	f4040593          	addi	a1,s0,-192
    80004d84:	4501                	li	a0,0
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	1ba080e7          	jalr	442(ra) # 80001f40 <argstr>
    return -1;
    80004d8e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004d90:	0c054a63          	bltz	a0,80004e64 <sys_exec+0xfa>
    80004d94:	e3840593          	addi	a1,s0,-456
    80004d98:	4505                	li	a0,1
    80004d9a:	ffffd097          	auipc	ra,0xffffd
    80004d9e:	184080e7          	jalr	388(ra) # 80001f1e <argaddr>
    80004da2:	0c054163          	bltz	a0,80004e64 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004da6:	10000613          	li	a2,256
    80004daa:	4581                	li	a1,0
    80004dac:	e4040513          	addi	a0,s0,-448
    80004db0:	ffffb097          	auipc	ra,0xffffb
    80004db4:	3c8080e7          	jalr	968(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004db8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004dbc:	89a6                	mv	s3,s1
    80004dbe:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004dc0:	02000a13          	li	s4,32
    80004dc4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004dc8:	00391513          	slli	a0,s2,0x3
    80004dcc:	e3040593          	addi	a1,s0,-464
    80004dd0:	e3843783          	ld	a5,-456(s0)
    80004dd4:	953e                	add	a0,a0,a5
    80004dd6:	ffffd097          	auipc	ra,0xffffd
    80004dda:	08c080e7          	jalr	140(ra) # 80001e62 <fetchaddr>
    80004dde:	02054a63          	bltz	a0,80004e12 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004de2:	e3043783          	ld	a5,-464(s0)
    80004de6:	c3b9                	beqz	a5,80004e2c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004de8:	ffffb097          	auipc	ra,0xffffb
    80004dec:	330080e7          	jalr	816(ra) # 80000118 <kalloc>
    80004df0:	85aa                	mv	a1,a0
    80004df2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004df6:	cd11                	beqz	a0,80004e12 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004df8:	6605                	lui	a2,0x1
    80004dfa:	e3043503          	ld	a0,-464(s0)
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	0b6080e7          	jalr	182(ra) # 80001eb4 <fetchstr>
    80004e06:	00054663          	bltz	a0,80004e12 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e0a:	0905                	addi	s2,s2,1
    80004e0c:	09a1                	addi	s3,s3,8
    80004e0e:	fb491be3          	bne	s2,s4,80004dc4 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e12:	10048913          	addi	s2,s1,256
    80004e16:	6088                	ld	a0,0(s1)
    80004e18:	c529                	beqz	a0,80004e62 <sys_exec+0xf8>
    kfree(argv[i]);
    80004e1a:	ffffb097          	auipc	ra,0xffffb
    80004e1e:	202080e7          	jalr	514(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e22:	04a1                	addi	s1,s1,8
    80004e24:	ff2499e3          	bne	s1,s2,80004e16 <sys_exec+0xac>
  return -1;
    80004e28:	597d                	li	s2,-1
    80004e2a:	a82d                	j	80004e64 <sys_exec+0xfa>
      argv[i] = 0;
    80004e2c:	0a8e                	slli	s5,s5,0x3
    80004e2e:	fc040793          	addi	a5,s0,-64
    80004e32:	9abe                	add	s5,s5,a5
    80004e34:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004e38:	e4040593          	addi	a1,s0,-448
    80004e3c:	f4040513          	addi	a0,s0,-192
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	194080e7          	jalr	404(ra) # 80003fd4 <exec>
    80004e48:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e4a:	10048993          	addi	s3,s1,256
    80004e4e:	6088                	ld	a0,0(s1)
    80004e50:	c911                	beqz	a0,80004e64 <sys_exec+0xfa>
    kfree(argv[i]);
    80004e52:	ffffb097          	auipc	ra,0xffffb
    80004e56:	1ca080e7          	jalr	458(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e5a:	04a1                	addi	s1,s1,8
    80004e5c:	ff3499e3          	bne	s1,s3,80004e4e <sys_exec+0xe4>
    80004e60:	a011                	j	80004e64 <sys_exec+0xfa>
  return -1;
    80004e62:	597d                	li	s2,-1
}
    80004e64:	854a                	mv	a0,s2
    80004e66:	60be                	ld	ra,456(sp)
    80004e68:	641e                	ld	s0,448(sp)
    80004e6a:	74fa                	ld	s1,440(sp)
    80004e6c:	795a                	ld	s2,432(sp)
    80004e6e:	79ba                	ld	s3,424(sp)
    80004e70:	7a1a                	ld	s4,416(sp)
    80004e72:	6afa                	ld	s5,408(sp)
    80004e74:	6179                	addi	sp,sp,464
    80004e76:	8082                	ret

0000000080004e78 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004e78:	7139                	addi	sp,sp,-64
    80004e7a:	fc06                	sd	ra,56(sp)
    80004e7c:	f822                	sd	s0,48(sp)
    80004e7e:	f426                	sd	s1,40(sp)
    80004e80:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004e82:	ffffc097          	auipc	ra,0xffffc
    80004e86:	fc6080e7          	jalr	-58(ra) # 80000e48 <myproc>
    80004e8a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004e8c:	fd840593          	addi	a1,s0,-40
    80004e90:	4501                	li	a0,0
    80004e92:	ffffd097          	auipc	ra,0xffffd
    80004e96:	08c080e7          	jalr	140(ra) # 80001f1e <argaddr>
    return -1;
    80004e9a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004e9c:	0e054063          	bltz	a0,80004f7c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004ea0:	fc840593          	addi	a1,s0,-56
    80004ea4:	fd040513          	addi	a0,s0,-48
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	dfc080e7          	jalr	-516(ra) # 80003ca4 <pipealloc>
    return -1;
    80004eb0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004eb2:	0c054563          	bltz	a0,80004f7c <sys_pipe+0x104>
  fd0 = -1;
    80004eb6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004eba:	fd043503          	ld	a0,-48(s0)
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	508080e7          	jalr	1288(ra) # 800043c6 <fdalloc>
    80004ec6:	fca42223          	sw	a0,-60(s0)
    80004eca:	08054c63          	bltz	a0,80004f62 <sys_pipe+0xea>
    80004ece:	fc843503          	ld	a0,-56(s0)
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	4f4080e7          	jalr	1268(ra) # 800043c6 <fdalloc>
    80004eda:	fca42023          	sw	a0,-64(s0)
    80004ede:	06054863          	bltz	a0,80004f4e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ee2:	4691                	li	a3,4
    80004ee4:	fc440613          	addi	a2,s0,-60
    80004ee8:	fd843583          	ld	a1,-40(s0)
    80004eec:	68a8                	ld	a0,80(s1)
    80004eee:	ffffc097          	auipc	ra,0xffffc
    80004ef2:	c1c080e7          	jalr	-996(ra) # 80000b0a <copyout>
    80004ef6:	02054063          	bltz	a0,80004f16 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004efa:	4691                	li	a3,4
    80004efc:	fc040613          	addi	a2,s0,-64
    80004f00:	fd843583          	ld	a1,-40(s0)
    80004f04:	0591                	addi	a1,a1,4
    80004f06:	68a8                	ld	a0,80(s1)
    80004f08:	ffffc097          	auipc	ra,0xffffc
    80004f0c:	c02080e7          	jalr	-1022(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f10:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f12:	06055563          	bgez	a0,80004f7c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f16:	fc442783          	lw	a5,-60(s0)
    80004f1a:	07e9                	addi	a5,a5,26
    80004f1c:	078e                	slli	a5,a5,0x3
    80004f1e:	97a6                	add	a5,a5,s1
    80004f20:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f24:	fc042503          	lw	a0,-64(s0)
    80004f28:	0569                	addi	a0,a0,26
    80004f2a:	050e                	slli	a0,a0,0x3
    80004f2c:	9526                	add	a0,a0,s1
    80004f2e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004f32:	fd043503          	ld	a0,-48(s0)
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	a3e080e7          	jalr	-1474(ra) # 80003974 <fileclose>
    fileclose(wf);
    80004f3e:	fc843503          	ld	a0,-56(s0)
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	a32080e7          	jalr	-1486(ra) # 80003974 <fileclose>
    return -1;
    80004f4a:	57fd                	li	a5,-1
    80004f4c:	a805                	j	80004f7c <sys_pipe+0x104>
    if(fd0 >= 0)
    80004f4e:	fc442783          	lw	a5,-60(s0)
    80004f52:	0007c863          	bltz	a5,80004f62 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004f56:	01a78513          	addi	a0,a5,26
    80004f5a:	050e                	slli	a0,a0,0x3
    80004f5c:	9526                	add	a0,a0,s1
    80004f5e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004f62:	fd043503          	ld	a0,-48(s0)
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	a0e080e7          	jalr	-1522(ra) # 80003974 <fileclose>
    fileclose(wf);
    80004f6e:	fc843503          	ld	a0,-56(s0)
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	a02080e7          	jalr	-1534(ra) # 80003974 <fileclose>
    return -1;
    80004f7a:	57fd                	li	a5,-1
}
    80004f7c:	853e                	mv	a0,a5
    80004f7e:	70e2                	ld	ra,56(sp)
    80004f80:	7442                	ld	s0,48(sp)
    80004f82:	74a2                	ld	s1,40(sp)
    80004f84:	6121                	addi	sp,sp,64
    80004f86:	8082                	ret
	...

0000000080004f90 <kernelvec>:
    80004f90:	7111                	addi	sp,sp,-256
    80004f92:	e006                	sd	ra,0(sp)
    80004f94:	e40a                	sd	sp,8(sp)
    80004f96:	e80e                	sd	gp,16(sp)
    80004f98:	ec12                	sd	tp,24(sp)
    80004f9a:	f016                	sd	t0,32(sp)
    80004f9c:	f41a                	sd	t1,40(sp)
    80004f9e:	f81e                	sd	t2,48(sp)
    80004fa0:	fc22                	sd	s0,56(sp)
    80004fa2:	e0a6                	sd	s1,64(sp)
    80004fa4:	e4aa                	sd	a0,72(sp)
    80004fa6:	e8ae                	sd	a1,80(sp)
    80004fa8:	ecb2                	sd	a2,88(sp)
    80004faa:	f0b6                	sd	a3,96(sp)
    80004fac:	f4ba                	sd	a4,104(sp)
    80004fae:	f8be                	sd	a5,112(sp)
    80004fb0:	fcc2                	sd	a6,120(sp)
    80004fb2:	e146                	sd	a7,128(sp)
    80004fb4:	e54a                	sd	s2,136(sp)
    80004fb6:	e94e                	sd	s3,144(sp)
    80004fb8:	ed52                	sd	s4,152(sp)
    80004fba:	f156                	sd	s5,160(sp)
    80004fbc:	f55a                	sd	s6,168(sp)
    80004fbe:	f95e                	sd	s7,176(sp)
    80004fc0:	fd62                	sd	s8,184(sp)
    80004fc2:	e1e6                	sd	s9,192(sp)
    80004fc4:	e5ea                	sd	s10,200(sp)
    80004fc6:	e9ee                	sd	s11,208(sp)
    80004fc8:	edf2                	sd	t3,216(sp)
    80004fca:	f1f6                	sd	t4,224(sp)
    80004fcc:	f5fa                	sd	t5,232(sp)
    80004fce:	f9fe                	sd	t6,240(sp)
    80004fd0:	d5ffc0ef          	jal	ra,80001d2e <kerneltrap>
    80004fd4:	6082                	ld	ra,0(sp)
    80004fd6:	6122                	ld	sp,8(sp)
    80004fd8:	61c2                	ld	gp,16(sp)
    80004fda:	7282                	ld	t0,32(sp)
    80004fdc:	7322                	ld	t1,40(sp)
    80004fde:	73c2                	ld	t2,48(sp)
    80004fe0:	7462                	ld	s0,56(sp)
    80004fe2:	6486                	ld	s1,64(sp)
    80004fe4:	6526                	ld	a0,72(sp)
    80004fe6:	65c6                	ld	a1,80(sp)
    80004fe8:	6666                	ld	a2,88(sp)
    80004fea:	7686                	ld	a3,96(sp)
    80004fec:	7726                	ld	a4,104(sp)
    80004fee:	77c6                	ld	a5,112(sp)
    80004ff0:	7866                	ld	a6,120(sp)
    80004ff2:	688a                	ld	a7,128(sp)
    80004ff4:	692a                	ld	s2,136(sp)
    80004ff6:	69ca                	ld	s3,144(sp)
    80004ff8:	6a6a                	ld	s4,152(sp)
    80004ffa:	7a8a                	ld	s5,160(sp)
    80004ffc:	7b2a                	ld	s6,168(sp)
    80004ffe:	7bca                	ld	s7,176(sp)
    80005000:	7c6a                	ld	s8,184(sp)
    80005002:	6c8e                	ld	s9,192(sp)
    80005004:	6d2e                	ld	s10,200(sp)
    80005006:	6dce                	ld	s11,208(sp)
    80005008:	6e6e                	ld	t3,216(sp)
    8000500a:	7e8e                	ld	t4,224(sp)
    8000500c:	7f2e                	ld	t5,232(sp)
    8000500e:	7fce                	ld	t6,240(sp)
    80005010:	6111                	addi	sp,sp,256
    80005012:	10200073          	sret
    80005016:	00000013          	nop
    8000501a:	00000013          	nop
    8000501e:	0001                	nop

0000000080005020 <timervec>:
    80005020:	34051573          	csrrw	a0,mscratch,a0
    80005024:	e10c                	sd	a1,0(a0)
    80005026:	e510                	sd	a2,8(a0)
    80005028:	e914                	sd	a3,16(a0)
    8000502a:	6d0c                	ld	a1,24(a0)
    8000502c:	7110                	ld	a2,32(a0)
    8000502e:	6194                	ld	a3,0(a1)
    80005030:	96b2                	add	a3,a3,a2
    80005032:	e194                	sd	a3,0(a1)
    80005034:	4589                	li	a1,2
    80005036:	14459073          	csrw	sip,a1
    8000503a:	6914                	ld	a3,16(a0)
    8000503c:	6510                	ld	a2,8(a0)
    8000503e:	610c                	ld	a1,0(a0)
    80005040:	34051573          	csrrw	a0,mscratch,a0
    80005044:	30200073          	mret
	...

000000008000504a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000504a:	1141                	addi	sp,sp,-16
    8000504c:	e422                	sd	s0,8(sp)
    8000504e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005050:	0c0007b7          	lui	a5,0xc000
    80005054:	4705                	li	a4,1
    80005056:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005058:	c3d8                	sw	a4,4(a5)
}
    8000505a:	6422                	ld	s0,8(sp)
    8000505c:	0141                	addi	sp,sp,16
    8000505e:	8082                	ret

0000000080005060 <plicinithart>:

void
plicinithart(void)
{
    80005060:	1141                	addi	sp,sp,-16
    80005062:	e406                	sd	ra,8(sp)
    80005064:	e022                	sd	s0,0(sp)
    80005066:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005068:	ffffc097          	auipc	ra,0xffffc
    8000506c:	db4080e7          	jalr	-588(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005070:	0085171b          	slliw	a4,a0,0x8
    80005074:	0c0027b7          	lui	a5,0xc002
    80005078:	97ba                	add	a5,a5,a4
    8000507a:	40200713          	li	a4,1026
    8000507e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005082:	00d5151b          	slliw	a0,a0,0xd
    80005086:	0c2017b7          	lui	a5,0xc201
    8000508a:	953e                	add	a0,a0,a5
    8000508c:	00052023          	sw	zero,0(a0)
}
    80005090:	60a2                	ld	ra,8(sp)
    80005092:	6402                	ld	s0,0(sp)
    80005094:	0141                	addi	sp,sp,16
    80005096:	8082                	ret

0000000080005098 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005098:	1141                	addi	sp,sp,-16
    8000509a:	e406                	sd	ra,8(sp)
    8000509c:	e022                	sd	s0,0(sp)
    8000509e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050a0:	ffffc097          	auipc	ra,0xffffc
    800050a4:	d7c080e7          	jalr	-644(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800050a8:	00d5179b          	slliw	a5,a0,0xd
    800050ac:	0c201537          	lui	a0,0xc201
    800050b0:	953e                	add	a0,a0,a5
  return irq;
}
    800050b2:	4148                	lw	a0,4(a0)
    800050b4:	60a2                	ld	ra,8(sp)
    800050b6:	6402                	ld	s0,0(sp)
    800050b8:	0141                	addi	sp,sp,16
    800050ba:	8082                	ret

00000000800050bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800050bc:	1101                	addi	sp,sp,-32
    800050be:	ec06                	sd	ra,24(sp)
    800050c0:	e822                	sd	s0,16(sp)
    800050c2:	e426                	sd	s1,8(sp)
    800050c4:	1000                	addi	s0,sp,32
    800050c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800050c8:	ffffc097          	auipc	ra,0xffffc
    800050cc:	d54080e7          	jalr	-684(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800050d0:	00d5151b          	slliw	a0,a0,0xd
    800050d4:	0c2017b7          	lui	a5,0xc201
    800050d8:	97aa                	add	a5,a5,a0
    800050da:	c3c4                	sw	s1,4(a5)
}
    800050dc:	60e2                	ld	ra,24(sp)
    800050de:	6442                	ld	s0,16(sp)
    800050e0:	64a2                	ld	s1,8(sp)
    800050e2:	6105                	addi	sp,sp,32
    800050e4:	8082                	ret

00000000800050e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800050e6:	1141                	addi	sp,sp,-16
    800050e8:	e406                	sd	ra,8(sp)
    800050ea:	e022                	sd	s0,0(sp)
    800050ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800050ee:	479d                	li	a5,7
    800050f0:	06a7c963          	blt	a5,a0,80005162 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800050f4:	00016797          	auipc	a5,0x16
    800050f8:	f0c78793          	addi	a5,a5,-244 # 8001b000 <disk>
    800050fc:	00a78733          	add	a4,a5,a0
    80005100:	6789                	lui	a5,0x2
    80005102:	97ba                	add	a5,a5,a4
    80005104:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005108:	e7ad                	bnez	a5,80005172 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000510a:	00451793          	slli	a5,a0,0x4
    8000510e:	00018717          	auipc	a4,0x18
    80005112:	ef270713          	addi	a4,a4,-270 # 8001d000 <disk+0x2000>
    80005116:	6314                	ld	a3,0(a4)
    80005118:	96be                	add	a3,a3,a5
    8000511a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000511e:	6314                	ld	a3,0(a4)
    80005120:	96be                	add	a3,a3,a5
    80005122:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005126:	6314                	ld	a3,0(a4)
    80005128:	96be                	add	a3,a3,a5
    8000512a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000512e:	6318                	ld	a4,0(a4)
    80005130:	97ba                	add	a5,a5,a4
    80005132:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005136:	00016797          	auipc	a5,0x16
    8000513a:	eca78793          	addi	a5,a5,-310 # 8001b000 <disk>
    8000513e:	97aa                	add	a5,a5,a0
    80005140:	6509                	lui	a0,0x2
    80005142:	953e                	add	a0,a0,a5
    80005144:	4785                	li	a5,1
    80005146:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000514a:	00018517          	auipc	a0,0x18
    8000514e:	ece50513          	addi	a0,a0,-306 # 8001d018 <disk+0x2018>
    80005152:	ffffc097          	auipc	ra,0xffffc
    80005156:	546080e7          	jalr	1350(ra) # 80001698 <wakeup>
}
    8000515a:	60a2                	ld	ra,8(sp)
    8000515c:	6402                	ld	s0,0(sp)
    8000515e:	0141                	addi	sp,sp,16
    80005160:	8082                	ret
    panic("free_desc 1");
    80005162:	00003517          	auipc	a0,0x3
    80005166:	6f650513          	addi	a0,a0,1782 # 80008858 <syscall_names+0x320>
    8000516a:	00001097          	auipc	ra,0x1
    8000516e:	a1e080e7          	jalr	-1506(ra) # 80005b88 <panic>
    panic("free_desc 2");
    80005172:	00003517          	auipc	a0,0x3
    80005176:	6f650513          	addi	a0,a0,1782 # 80008868 <syscall_names+0x330>
    8000517a:	00001097          	auipc	ra,0x1
    8000517e:	a0e080e7          	jalr	-1522(ra) # 80005b88 <panic>

0000000080005182 <virtio_disk_init>:
{
    80005182:	1101                	addi	sp,sp,-32
    80005184:	ec06                	sd	ra,24(sp)
    80005186:	e822                	sd	s0,16(sp)
    80005188:	e426                	sd	s1,8(sp)
    8000518a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000518c:	00003597          	auipc	a1,0x3
    80005190:	6ec58593          	addi	a1,a1,1772 # 80008878 <syscall_names+0x340>
    80005194:	00018517          	auipc	a0,0x18
    80005198:	f9450513          	addi	a0,a0,-108 # 8001d128 <disk+0x2128>
    8000519c:	00001097          	auipc	ra,0x1
    800051a0:	ea6080e7          	jalr	-346(ra) # 80006042 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051a4:	100017b7          	lui	a5,0x10001
    800051a8:	4398                	lw	a4,0(a5)
    800051aa:	2701                	sext.w	a4,a4
    800051ac:	747277b7          	lui	a5,0x74727
    800051b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800051b4:	0ef71163          	bne	a4,a5,80005296 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800051b8:	100017b7          	lui	a5,0x10001
    800051bc:	43dc                	lw	a5,4(a5)
    800051be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800051c0:	4705                	li	a4,1
    800051c2:	0ce79a63          	bne	a5,a4,80005296 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051c6:	100017b7          	lui	a5,0x10001
    800051ca:	479c                	lw	a5,8(a5)
    800051cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800051ce:	4709                	li	a4,2
    800051d0:	0ce79363          	bne	a5,a4,80005296 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800051d4:	100017b7          	lui	a5,0x10001
    800051d8:	47d8                	lw	a4,12(a5)
    800051da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800051dc:	554d47b7          	lui	a5,0x554d4
    800051e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800051e4:	0af71963          	bne	a4,a5,80005296 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800051e8:	100017b7          	lui	a5,0x10001
    800051ec:	4705                	li	a4,1
    800051ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800051f0:	470d                	li	a4,3
    800051f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800051f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800051f6:	c7ffe737          	lui	a4,0xc7ffe
    800051fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800051fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005200:	2701                	sext.w	a4,a4
    80005202:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005204:	472d                	li	a4,11
    80005206:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005208:	473d                	li	a4,15
    8000520a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000520c:	6705                	lui	a4,0x1
    8000520e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005210:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005214:	5bdc                	lw	a5,52(a5)
    80005216:	2781                	sext.w	a5,a5
  if(max == 0)
    80005218:	c7d9                	beqz	a5,800052a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000521a:	471d                	li	a4,7
    8000521c:	08f77d63          	bgeu	a4,a5,800052b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005220:	100014b7          	lui	s1,0x10001
    80005224:	47a1                	li	a5,8
    80005226:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005228:	6609                	lui	a2,0x2
    8000522a:	4581                	li	a1,0
    8000522c:	00016517          	auipc	a0,0x16
    80005230:	dd450513          	addi	a0,a0,-556 # 8001b000 <disk>
    80005234:	ffffb097          	auipc	ra,0xffffb
    80005238:	f44080e7          	jalr	-188(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000523c:	00016717          	auipc	a4,0x16
    80005240:	dc470713          	addi	a4,a4,-572 # 8001b000 <disk>
    80005244:	00c75793          	srli	a5,a4,0xc
    80005248:	2781                	sext.w	a5,a5
    8000524a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000524c:	00018797          	auipc	a5,0x18
    80005250:	db478793          	addi	a5,a5,-588 # 8001d000 <disk+0x2000>
    80005254:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005256:	00016717          	auipc	a4,0x16
    8000525a:	e2a70713          	addi	a4,a4,-470 # 8001b080 <disk+0x80>
    8000525e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005260:	00017717          	auipc	a4,0x17
    80005264:	da070713          	addi	a4,a4,-608 # 8001c000 <disk+0x1000>
    80005268:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000526a:	4705                	li	a4,1
    8000526c:	00e78c23          	sb	a4,24(a5)
    80005270:	00e78ca3          	sb	a4,25(a5)
    80005274:	00e78d23          	sb	a4,26(a5)
    80005278:	00e78da3          	sb	a4,27(a5)
    8000527c:	00e78e23          	sb	a4,28(a5)
    80005280:	00e78ea3          	sb	a4,29(a5)
    80005284:	00e78f23          	sb	a4,30(a5)
    80005288:	00e78fa3          	sb	a4,31(a5)
}
    8000528c:	60e2                	ld	ra,24(sp)
    8000528e:	6442                	ld	s0,16(sp)
    80005290:	64a2                	ld	s1,8(sp)
    80005292:	6105                	addi	sp,sp,32
    80005294:	8082                	ret
    panic("could not find virtio disk");
    80005296:	00003517          	auipc	a0,0x3
    8000529a:	5f250513          	addi	a0,a0,1522 # 80008888 <syscall_names+0x350>
    8000529e:	00001097          	auipc	ra,0x1
    800052a2:	8ea080e7          	jalr	-1814(ra) # 80005b88 <panic>
    panic("virtio disk has no queue 0");
    800052a6:	00003517          	auipc	a0,0x3
    800052aa:	60250513          	addi	a0,a0,1538 # 800088a8 <syscall_names+0x370>
    800052ae:	00001097          	auipc	ra,0x1
    800052b2:	8da080e7          	jalr	-1830(ra) # 80005b88 <panic>
    panic("virtio disk max queue too short");
    800052b6:	00003517          	auipc	a0,0x3
    800052ba:	61250513          	addi	a0,a0,1554 # 800088c8 <syscall_names+0x390>
    800052be:	00001097          	auipc	ra,0x1
    800052c2:	8ca080e7          	jalr	-1846(ra) # 80005b88 <panic>

00000000800052c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800052c6:	7159                	addi	sp,sp,-112
    800052c8:	f486                	sd	ra,104(sp)
    800052ca:	f0a2                	sd	s0,96(sp)
    800052cc:	eca6                	sd	s1,88(sp)
    800052ce:	e8ca                	sd	s2,80(sp)
    800052d0:	e4ce                	sd	s3,72(sp)
    800052d2:	e0d2                	sd	s4,64(sp)
    800052d4:	fc56                	sd	s5,56(sp)
    800052d6:	f85a                	sd	s6,48(sp)
    800052d8:	f45e                	sd	s7,40(sp)
    800052da:	f062                	sd	s8,32(sp)
    800052dc:	ec66                	sd	s9,24(sp)
    800052de:	e86a                	sd	s10,16(sp)
    800052e0:	1880                	addi	s0,sp,112
    800052e2:	892a                	mv	s2,a0
    800052e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800052e6:	00c52c83          	lw	s9,12(a0)
    800052ea:	001c9c9b          	slliw	s9,s9,0x1
    800052ee:	1c82                	slli	s9,s9,0x20
    800052f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800052f4:	00018517          	auipc	a0,0x18
    800052f8:	e3450513          	addi	a0,a0,-460 # 8001d128 <disk+0x2128>
    800052fc:	00001097          	auipc	ra,0x1
    80005300:	dd6080e7          	jalr	-554(ra) # 800060d2 <acquire>
  for(int i = 0; i < 3; i++){
    80005304:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005306:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005308:	00016b97          	auipc	s7,0x16
    8000530c:	cf8b8b93          	addi	s7,s7,-776 # 8001b000 <disk>
    80005310:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005312:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005314:	8a4e                	mv	s4,s3
    80005316:	a051                	j	8000539a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005318:	00fb86b3          	add	a3,s7,a5
    8000531c:	96da                	add	a3,a3,s6
    8000531e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005322:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005324:	0207c563          	bltz	a5,8000534e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005328:	2485                	addiw	s1,s1,1
    8000532a:	0711                	addi	a4,a4,4
    8000532c:	25548063          	beq	s1,s5,8000556c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005330:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005332:	00018697          	auipc	a3,0x18
    80005336:	ce668693          	addi	a3,a3,-794 # 8001d018 <disk+0x2018>
    8000533a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000533c:	0006c583          	lbu	a1,0(a3)
    80005340:	fde1                	bnez	a1,80005318 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005342:	2785                	addiw	a5,a5,1
    80005344:	0685                	addi	a3,a3,1
    80005346:	ff879be3          	bne	a5,s8,8000533c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000534a:	57fd                	li	a5,-1
    8000534c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000534e:	02905a63          	blez	s1,80005382 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005352:	f9042503          	lw	a0,-112(s0)
    80005356:	00000097          	auipc	ra,0x0
    8000535a:	d90080e7          	jalr	-624(ra) # 800050e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000535e:	4785                	li	a5,1
    80005360:	0297d163          	bge	a5,s1,80005382 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005364:	f9442503          	lw	a0,-108(s0)
    80005368:	00000097          	auipc	ra,0x0
    8000536c:	d7e080e7          	jalr	-642(ra) # 800050e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005370:	4789                	li	a5,2
    80005372:	0097d863          	bge	a5,s1,80005382 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005376:	f9842503          	lw	a0,-104(s0)
    8000537a:	00000097          	auipc	ra,0x0
    8000537e:	d6c080e7          	jalr	-660(ra) # 800050e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005382:	00018597          	auipc	a1,0x18
    80005386:	da658593          	addi	a1,a1,-602 # 8001d128 <disk+0x2128>
    8000538a:	00018517          	auipc	a0,0x18
    8000538e:	c8e50513          	addi	a0,a0,-882 # 8001d018 <disk+0x2018>
    80005392:	ffffc097          	auipc	ra,0xffffc
    80005396:	17a080e7          	jalr	378(ra) # 8000150c <sleep>
  for(int i = 0; i < 3; i++){
    8000539a:	f9040713          	addi	a4,s0,-112
    8000539e:	84ce                	mv	s1,s3
    800053a0:	bf41                	j	80005330 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800053a2:	20058713          	addi	a4,a1,512
    800053a6:	00471693          	slli	a3,a4,0x4
    800053aa:	00016717          	auipc	a4,0x16
    800053ae:	c5670713          	addi	a4,a4,-938 # 8001b000 <disk>
    800053b2:	9736                	add	a4,a4,a3
    800053b4:	4685                	li	a3,1
    800053b6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800053ba:	20058713          	addi	a4,a1,512
    800053be:	00471693          	slli	a3,a4,0x4
    800053c2:	00016717          	auipc	a4,0x16
    800053c6:	c3e70713          	addi	a4,a4,-962 # 8001b000 <disk>
    800053ca:	9736                	add	a4,a4,a3
    800053cc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800053d0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800053d4:	7679                	lui	a2,0xffffe
    800053d6:	963e                	add	a2,a2,a5
    800053d8:	00018697          	auipc	a3,0x18
    800053dc:	c2868693          	addi	a3,a3,-984 # 8001d000 <disk+0x2000>
    800053e0:	6298                	ld	a4,0(a3)
    800053e2:	9732                	add	a4,a4,a2
    800053e4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800053e6:	6298                	ld	a4,0(a3)
    800053e8:	9732                	add	a4,a4,a2
    800053ea:	4541                	li	a0,16
    800053ec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800053ee:	6298                	ld	a4,0(a3)
    800053f0:	9732                	add	a4,a4,a2
    800053f2:	4505                	li	a0,1
    800053f4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800053f8:	f9442703          	lw	a4,-108(s0)
    800053fc:	6288                	ld	a0,0(a3)
    800053fe:	962a                	add	a2,a2,a0
    80005400:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005404:	0712                	slli	a4,a4,0x4
    80005406:	6290                	ld	a2,0(a3)
    80005408:	963a                	add	a2,a2,a4
    8000540a:	05890513          	addi	a0,s2,88
    8000540e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005410:	6294                	ld	a3,0(a3)
    80005412:	96ba                	add	a3,a3,a4
    80005414:	40000613          	li	a2,1024
    80005418:	c690                	sw	a2,8(a3)
  if(write)
    8000541a:	140d0063          	beqz	s10,8000555a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000541e:	00018697          	auipc	a3,0x18
    80005422:	be26b683          	ld	a3,-1054(a3) # 8001d000 <disk+0x2000>
    80005426:	96ba                	add	a3,a3,a4
    80005428:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000542c:	00016817          	auipc	a6,0x16
    80005430:	bd480813          	addi	a6,a6,-1068 # 8001b000 <disk>
    80005434:	00018517          	auipc	a0,0x18
    80005438:	bcc50513          	addi	a0,a0,-1076 # 8001d000 <disk+0x2000>
    8000543c:	6114                	ld	a3,0(a0)
    8000543e:	96ba                	add	a3,a3,a4
    80005440:	00c6d603          	lhu	a2,12(a3)
    80005444:	00166613          	ori	a2,a2,1
    80005448:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000544c:	f9842683          	lw	a3,-104(s0)
    80005450:	6110                	ld	a2,0(a0)
    80005452:	9732                	add	a4,a4,a2
    80005454:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005458:	20058613          	addi	a2,a1,512
    8000545c:	0612                	slli	a2,a2,0x4
    8000545e:	9642                	add	a2,a2,a6
    80005460:	577d                	li	a4,-1
    80005462:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005466:	00469713          	slli	a4,a3,0x4
    8000546a:	6114                	ld	a3,0(a0)
    8000546c:	96ba                	add	a3,a3,a4
    8000546e:	03078793          	addi	a5,a5,48
    80005472:	97c2                	add	a5,a5,a6
    80005474:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005476:	611c                	ld	a5,0(a0)
    80005478:	97ba                	add	a5,a5,a4
    8000547a:	4685                	li	a3,1
    8000547c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000547e:	611c                	ld	a5,0(a0)
    80005480:	97ba                	add	a5,a5,a4
    80005482:	4809                	li	a6,2
    80005484:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005488:	611c                	ld	a5,0(a0)
    8000548a:	973e                	add	a4,a4,a5
    8000548c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005490:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005494:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005498:	6518                	ld	a4,8(a0)
    8000549a:	00275783          	lhu	a5,2(a4)
    8000549e:	8b9d                	andi	a5,a5,7
    800054a0:	0786                	slli	a5,a5,0x1
    800054a2:	97ba                	add	a5,a5,a4
    800054a4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800054a8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054ac:	6518                	ld	a4,8(a0)
    800054ae:	00275783          	lhu	a5,2(a4)
    800054b2:	2785                	addiw	a5,a5,1
    800054b4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054b8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054bc:	100017b7          	lui	a5,0x10001
    800054c0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054c4:	00492703          	lw	a4,4(s2)
    800054c8:	4785                	li	a5,1
    800054ca:	02f71163          	bne	a4,a5,800054ec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800054ce:	00018997          	auipc	s3,0x18
    800054d2:	c5a98993          	addi	s3,s3,-934 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800054d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800054d8:	85ce                	mv	a1,s3
    800054da:	854a                	mv	a0,s2
    800054dc:	ffffc097          	auipc	ra,0xffffc
    800054e0:	030080e7          	jalr	48(ra) # 8000150c <sleep>
  while(b->disk == 1) {
    800054e4:	00492783          	lw	a5,4(s2)
    800054e8:	fe9788e3          	beq	a5,s1,800054d8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800054ec:	f9042903          	lw	s2,-112(s0)
    800054f0:	20090793          	addi	a5,s2,512
    800054f4:	00479713          	slli	a4,a5,0x4
    800054f8:	00016797          	auipc	a5,0x16
    800054fc:	b0878793          	addi	a5,a5,-1272 # 8001b000 <disk>
    80005500:	97ba                	add	a5,a5,a4
    80005502:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005506:	00018997          	auipc	s3,0x18
    8000550a:	afa98993          	addi	s3,s3,-1286 # 8001d000 <disk+0x2000>
    8000550e:	00491713          	slli	a4,s2,0x4
    80005512:	0009b783          	ld	a5,0(s3)
    80005516:	97ba                	add	a5,a5,a4
    80005518:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000551c:	854a                	mv	a0,s2
    8000551e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005522:	00000097          	auipc	ra,0x0
    80005526:	bc4080e7          	jalr	-1084(ra) # 800050e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000552a:	8885                	andi	s1,s1,1
    8000552c:	f0ed                	bnez	s1,8000550e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000552e:	00018517          	auipc	a0,0x18
    80005532:	bfa50513          	addi	a0,a0,-1030 # 8001d128 <disk+0x2128>
    80005536:	00001097          	auipc	ra,0x1
    8000553a:	c50080e7          	jalr	-944(ra) # 80006186 <release>
}
    8000553e:	70a6                	ld	ra,104(sp)
    80005540:	7406                	ld	s0,96(sp)
    80005542:	64e6                	ld	s1,88(sp)
    80005544:	6946                	ld	s2,80(sp)
    80005546:	69a6                	ld	s3,72(sp)
    80005548:	6a06                	ld	s4,64(sp)
    8000554a:	7ae2                	ld	s5,56(sp)
    8000554c:	7b42                	ld	s6,48(sp)
    8000554e:	7ba2                	ld	s7,40(sp)
    80005550:	7c02                	ld	s8,32(sp)
    80005552:	6ce2                	ld	s9,24(sp)
    80005554:	6d42                	ld	s10,16(sp)
    80005556:	6165                	addi	sp,sp,112
    80005558:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000555a:	00018697          	auipc	a3,0x18
    8000555e:	aa66b683          	ld	a3,-1370(a3) # 8001d000 <disk+0x2000>
    80005562:	96ba                	add	a3,a3,a4
    80005564:	4609                	li	a2,2
    80005566:	00c69623          	sh	a2,12(a3)
    8000556a:	b5c9                	j	8000542c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000556c:	f9042583          	lw	a1,-112(s0)
    80005570:	20058793          	addi	a5,a1,512
    80005574:	0792                	slli	a5,a5,0x4
    80005576:	00016517          	auipc	a0,0x16
    8000557a:	b3250513          	addi	a0,a0,-1230 # 8001b0a8 <disk+0xa8>
    8000557e:	953e                	add	a0,a0,a5
  if(write)
    80005580:	e20d11e3          	bnez	s10,800053a2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005584:	20058713          	addi	a4,a1,512
    80005588:	00471693          	slli	a3,a4,0x4
    8000558c:	00016717          	auipc	a4,0x16
    80005590:	a7470713          	addi	a4,a4,-1420 # 8001b000 <disk>
    80005594:	9736                	add	a4,a4,a3
    80005596:	0a072423          	sw	zero,168(a4)
    8000559a:	b505                	j	800053ba <virtio_disk_rw+0xf4>

000000008000559c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000559c:	1101                	addi	sp,sp,-32
    8000559e:	ec06                	sd	ra,24(sp)
    800055a0:	e822                	sd	s0,16(sp)
    800055a2:	e426                	sd	s1,8(sp)
    800055a4:	e04a                	sd	s2,0(sp)
    800055a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055a8:	00018517          	auipc	a0,0x18
    800055ac:	b8050513          	addi	a0,a0,-1152 # 8001d128 <disk+0x2128>
    800055b0:	00001097          	auipc	ra,0x1
    800055b4:	b22080e7          	jalr	-1246(ra) # 800060d2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055b8:	10001737          	lui	a4,0x10001
    800055bc:	533c                	lw	a5,96(a4)
    800055be:	8b8d                	andi	a5,a5,3
    800055c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055c6:	00018797          	auipc	a5,0x18
    800055ca:	a3a78793          	addi	a5,a5,-1478 # 8001d000 <disk+0x2000>
    800055ce:	6b94                	ld	a3,16(a5)
    800055d0:	0207d703          	lhu	a4,32(a5)
    800055d4:	0026d783          	lhu	a5,2(a3)
    800055d8:	06f70163          	beq	a4,a5,8000563a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055dc:	00016917          	auipc	s2,0x16
    800055e0:	a2490913          	addi	s2,s2,-1500 # 8001b000 <disk>
    800055e4:	00018497          	auipc	s1,0x18
    800055e8:	a1c48493          	addi	s1,s1,-1508 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800055ec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800055f0:	6898                	ld	a4,16(s1)
    800055f2:	0204d783          	lhu	a5,32(s1)
    800055f6:	8b9d                	andi	a5,a5,7
    800055f8:	078e                	slli	a5,a5,0x3
    800055fa:	97ba                	add	a5,a5,a4
    800055fc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800055fe:	20078713          	addi	a4,a5,512
    80005602:	0712                	slli	a4,a4,0x4
    80005604:	974a                	add	a4,a4,s2
    80005606:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000560a:	e731                	bnez	a4,80005656 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000560c:	20078793          	addi	a5,a5,512
    80005610:	0792                	slli	a5,a5,0x4
    80005612:	97ca                	add	a5,a5,s2
    80005614:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005616:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000561a:	ffffc097          	auipc	ra,0xffffc
    8000561e:	07e080e7          	jalr	126(ra) # 80001698 <wakeup>

    disk.used_idx += 1;
    80005622:	0204d783          	lhu	a5,32(s1)
    80005626:	2785                	addiw	a5,a5,1
    80005628:	17c2                	slli	a5,a5,0x30
    8000562a:	93c1                	srli	a5,a5,0x30
    8000562c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005630:	6898                	ld	a4,16(s1)
    80005632:	00275703          	lhu	a4,2(a4)
    80005636:	faf71be3          	bne	a4,a5,800055ec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000563a:	00018517          	auipc	a0,0x18
    8000563e:	aee50513          	addi	a0,a0,-1298 # 8001d128 <disk+0x2128>
    80005642:	00001097          	auipc	ra,0x1
    80005646:	b44080e7          	jalr	-1212(ra) # 80006186 <release>
}
    8000564a:	60e2                	ld	ra,24(sp)
    8000564c:	6442                	ld	s0,16(sp)
    8000564e:	64a2                	ld	s1,8(sp)
    80005650:	6902                	ld	s2,0(sp)
    80005652:	6105                	addi	sp,sp,32
    80005654:	8082                	ret
      panic("virtio_disk_intr status");
    80005656:	00003517          	auipc	a0,0x3
    8000565a:	29250513          	addi	a0,a0,658 # 800088e8 <syscall_names+0x3b0>
    8000565e:	00000097          	auipc	ra,0x0
    80005662:	52a080e7          	jalr	1322(ra) # 80005b88 <panic>

0000000080005666 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005666:	1141                	addi	sp,sp,-16
    80005668:	e422                	sd	s0,8(sp)
    8000566a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000566c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005670:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005674:	0037979b          	slliw	a5,a5,0x3
    80005678:	02004737          	lui	a4,0x2004
    8000567c:	97ba                	add	a5,a5,a4
    8000567e:	0200c737          	lui	a4,0x200c
    80005682:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005686:	000f4637          	lui	a2,0xf4
    8000568a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000568e:	95b2                	add	a1,a1,a2
    80005690:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005692:	00269713          	slli	a4,a3,0x2
    80005696:	9736                	add	a4,a4,a3
    80005698:	00371693          	slli	a3,a4,0x3
    8000569c:	00019717          	auipc	a4,0x19
    800056a0:	96470713          	addi	a4,a4,-1692 # 8001e000 <timer_scratch>
    800056a4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056a6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056a8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056aa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056ae:	00000797          	auipc	a5,0x0
    800056b2:	97278793          	addi	a5,a5,-1678 # 80005020 <timervec>
    800056b6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056ba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056be:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056c6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056ca:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056ce:	30479073          	csrw	mie,a5
}
    800056d2:	6422                	ld	s0,8(sp)
    800056d4:	0141                	addi	sp,sp,16
    800056d6:	8082                	ret

00000000800056d8 <start>:
{
    800056d8:	1141                	addi	sp,sp,-16
    800056da:	e406                	sd	ra,8(sp)
    800056dc:	e022                	sd	s0,0(sp)
    800056de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056e0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800056e4:	7779                	lui	a4,0xffffe
    800056e6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800056ea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800056ec:	6705                	lui	a4,0x1
    800056ee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800056f2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056f4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800056f8:	ffffb797          	auipc	a5,0xffffb
    800056fc:	c2e78793          	addi	a5,a5,-978 # 80000326 <main>
    80005700:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005704:	4781                	li	a5,0
    80005706:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000570a:	67c1                	lui	a5,0x10
    8000570c:	17fd                	addi	a5,a5,-1
    8000570e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005712:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005716:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000571a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000571e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005722:	57fd                	li	a5,-1
    80005724:	83a9                	srli	a5,a5,0xa
    80005726:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000572a:	47bd                	li	a5,15
    8000572c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005730:	00000097          	auipc	ra,0x0
    80005734:	f36080e7          	jalr	-202(ra) # 80005666 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005738:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000573c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000573e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005740:	30200073          	mret
}
    80005744:	60a2                	ld	ra,8(sp)
    80005746:	6402                	ld	s0,0(sp)
    80005748:	0141                	addi	sp,sp,16
    8000574a:	8082                	ret

000000008000574c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000574c:	715d                	addi	sp,sp,-80
    8000574e:	e486                	sd	ra,72(sp)
    80005750:	e0a2                	sd	s0,64(sp)
    80005752:	fc26                	sd	s1,56(sp)
    80005754:	f84a                	sd	s2,48(sp)
    80005756:	f44e                	sd	s3,40(sp)
    80005758:	f052                	sd	s4,32(sp)
    8000575a:	ec56                	sd	s5,24(sp)
    8000575c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000575e:	04c05663          	blez	a2,800057aa <consolewrite+0x5e>
    80005762:	8a2a                	mv	s4,a0
    80005764:	84ae                	mv	s1,a1
    80005766:	89b2                	mv	s3,a2
    80005768:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000576a:	5afd                	li	s5,-1
    8000576c:	4685                	li	a3,1
    8000576e:	8626                	mv	a2,s1
    80005770:	85d2                	mv	a1,s4
    80005772:	fbf40513          	addi	a0,s0,-65
    80005776:	ffffc097          	auipc	ra,0xffffc
    8000577a:	190080e7          	jalr	400(ra) # 80001906 <either_copyin>
    8000577e:	01550c63          	beq	a0,s5,80005796 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005782:	fbf44503          	lbu	a0,-65(s0)
    80005786:	00000097          	auipc	ra,0x0
    8000578a:	78e080e7          	jalr	1934(ra) # 80005f14 <uartputc>
  for(i = 0; i < n; i++){
    8000578e:	2905                	addiw	s2,s2,1
    80005790:	0485                	addi	s1,s1,1
    80005792:	fd299de3          	bne	s3,s2,8000576c <consolewrite+0x20>
  }

  return i;
}
    80005796:	854a                	mv	a0,s2
    80005798:	60a6                	ld	ra,72(sp)
    8000579a:	6406                	ld	s0,64(sp)
    8000579c:	74e2                	ld	s1,56(sp)
    8000579e:	7942                	ld	s2,48(sp)
    800057a0:	79a2                	ld	s3,40(sp)
    800057a2:	7a02                	ld	s4,32(sp)
    800057a4:	6ae2                	ld	s5,24(sp)
    800057a6:	6161                	addi	sp,sp,80
    800057a8:	8082                	ret
  for(i = 0; i < n; i++){
    800057aa:	4901                	li	s2,0
    800057ac:	b7ed                	j	80005796 <consolewrite+0x4a>

00000000800057ae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057ae:	7119                	addi	sp,sp,-128
    800057b0:	fc86                	sd	ra,120(sp)
    800057b2:	f8a2                	sd	s0,112(sp)
    800057b4:	f4a6                	sd	s1,104(sp)
    800057b6:	f0ca                	sd	s2,96(sp)
    800057b8:	ecce                	sd	s3,88(sp)
    800057ba:	e8d2                	sd	s4,80(sp)
    800057bc:	e4d6                	sd	s5,72(sp)
    800057be:	e0da                	sd	s6,64(sp)
    800057c0:	fc5e                	sd	s7,56(sp)
    800057c2:	f862                	sd	s8,48(sp)
    800057c4:	f466                	sd	s9,40(sp)
    800057c6:	f06a                	sd	s10,32(sp)
    800057c8:	ec6e                	sd	s11,24(sp)
    800057ca:	0100                	addi	s0,sp,128
    800057cc:	8b2a                	mv	s6,a0
    800057ce:	8aae                	mv	s5,a1
    800057d0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057d2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800057d6:	00021517          	auipc	a0,0x21
    800057da:	96a50513          	addi	a0,a0,-1686 # 80026140 <cons>
    800057de:	00001097          	auipc	ra,0x1
    800057e2:	8f4080e7          	jalr	-1804(ra) # 800060d2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800057e6:	00021497          	auipc	s1,0x21
    800057ea:	95a48493          	addi	s1,s1,-1702 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800057ee:	89a6                	mv	s3,s1
    800057f0:	00021917          	auipc	s2,0x21
    800057f4:	9e890913          	addi	s2,s2,-1560 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800057f8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800057fa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800057fc:	4da9                	li	s11,10
  while(n > 0){
    800057fe:	07405863          	blez	s4,8000586e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005802:	0984a783          	lw	a5,152(s1)
    80005806:	09c4a703          	lw	a4,156(s1)
    8000580a:	02f71463          	bne	a4,a5,80005832 <consoleread+0x84>
      if(myproc()->killed){
    8000580e:	ffffb097          	auipc	ra,0xffffb
    80005812:	63a080e7          	jalr	1594(ra) # 80000e48 <myproc>
    80005816:	551c                	lw	a5,40(a0)
    80005818:	e7b5                	bnez	a5,80005884 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000581a:	85ce                	mv	a1,s3
    8000581c:	854a                	mv	a0,s2
    8000581e:	ffffc097          	auipc	ra,0xffffc
    80005822:	cee080e7          	jalr	-786(ra) # 8000150c <sleep>
    while(cons.r == cons.w){
    80005826:	0984a783          	lw	a5,152(s1)
    8000582a:	09c4a703          	lw	a4,156(s1)
    8000582e:	fef700e3          	beq	a4,a5,8000580e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005832:	0017871b          	addiw	a4,a5,1
    80005836:	08e4ac23          	sw	a4,152(s1)
    8000583a:	07f7f713          	andi	a4,a5,127
    8000583e:	9726                	add	a4,a4,s1
    80005840:	01874703          	lbu	a4,24(a4)
    80005844:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005848:	079c0663          	beq	s8,s9,800058b4 <consoleread+0x106>
    cbuf = c;
    8000584c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005850:	4685                	li	a3,1
    80005852:	f8f40613          	addi	a2,s0,-113
    80005856:	85d6                	mv	a1,s5
    80005858:	855a                	mv	a0,s6
    8000585a:	ffffc097          	auipc	ra,0xffffc
    8000585e:	056080e7          	jalr	86(ra) # 800018b0 <either_copyout>
    80005862:	01a50663          	beq	a0,s10,8000586e <consoleread+0xc0>
    dst++;
    80005866:	0a85                	addi	s5,s5,1
    --n;
    80005868:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000586a:	f9bc1ae3          	bne	s8,s11,800057fe <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000586e:	00021517          	auipc	a0,0x21
    80005872:	8d250513          	addi	a0,a0,-1838 # 80026140 <cons>
    80005876:	00001097          	auipc	ra,0x1
    8000587a:	910080e7          	jalr	-1776(ra) # 80006186 <release>

  return target - n;
    8000587e:	414b853b          	subw	a0,s7,s4
    80005882:	a811                	j	80005896 <consoleread+0xe8>
        release(&cons.lock);
    80005884:	00021517          	auipc	a0,0x21
    80005888:	8bc50513          	addi	a0,a0,-1860 # 80026140 <cons>
    8000588c:	00001097          	auipc	ra,0x1
    80005890:	8fa080e7          	jalr	-1798(ra) # 80006186 <release>
        return -1;
    80005894:	557d                	li	a0,-1
}
    80005896:	70e6                	ld	ra,120(sp)
    80005898:	7446                	ld	s0,112(sp)
    8000589a:	74a6                	ld	s1,104(sp)
    8000589c:	7906                	ld	s2,96(sp)
    8000589e:	69e6                	ld	s3,88(sp)
    800058a0:	6a46                	ld	s4,80(sp)
    800058a2:	6aa6                	ld	s5,72(sp)
    800058a4:	6b06                	ld	s6,64(sp)
    800058a6:	7be2                	ld	s7,56(sp)
    800058a8:	7c42                	ld	s8,48(sp)
    800058aa:	7ca2                	ld	s9,40(sp)
    800058ac:	7d02                	ld	s10,32(sp)
    800058ae:	6de2                	ld	s11,24(sp)
    800058b0:	6109                	addi	sp,sp,128
    800058b2:	8082                	ret
      if(n < target){
    800058b4:	000a071b          	sext.w	a4,s4
    800058b8:	fb777be3          	bgeu	a4,s7,8000586e <consoleread+0xc0>
        cons.r--;
    800058bc:	00021717          	auipc	a4,0x21
    800058c0:	90f72e23          	sw	a5,-1764(a4) # 800261d8 <cons+0x98>
    800058c4:	b76d                	j	8000586e <consoleread+0xc0>

00000000800058c6 <consputc>:
{
    800058c6:	1141                	addi	sp,sp,-16
    800058c8:	e406                	sd	ra,8(sp)
    800058ca:	e022                	sd	s0,0(sp)
    800058cc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800058ce:	10000793          	li	a5,256
    800058d2:	00f50a63          	beq	a0,a5,800058e6 <consputc+0x20>
    uartputc_sync(c);
    800058d6:	00000097          	auipc	ra,0x0
    800058da:	564080e7          	jalr	1380(ra) # 80005e3a <uartputc_sync>
}
    800058de:	60a2                	ld	ra,8(sp)
    800058e0:	6402                	ld	s0,0(sp)
    800058e2:	0141                	addi	sp,sp,16
    800058e4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800058e6:	4521                	li	a0,8
    800058e8:	00000097          	auipc	ra,0x0
    800058ec:	552080e7          	jalr	1362(ra) # 80005e3a <uartputc_sync>
    800058f0:	02000513          	li	a0,32
    800058f4:	00000097          	auipc	ra,0x0
    800058f8:	546080e7          	jalr	1350(ra) # 80005e3a <uartputc_sync>
    800058fc:	4521                	li	a0,8
    800058fe:	00000097          	auipc	ra,0x0
    80005902:	53c080e7          	jalr	1340(ra) # 80005e3a <uartputc_sync>
    80005906:	bfe1                	j	800058de <consputc+0x18>

0000000080005908 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005908:	1101                	addi	sp,sp,-32
    8000590a:	ec06                	sd	ra,24(sp)
    8000590c:	e822                	sd	s0,16(sp)
    8000590e:	e426                	sd	s1,8(sp)
    80005910:	e04a                	sd	s2,0(sp)
    80005912:	1000                	addi	s0,sp,32
    80005914:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005916:	00021517          	auipc	a0,0x21
    8000591a:	82a50513          	addi	a0,a0,-2006 # 80026140 <cons>
    8000591e:	00000097          	auipc	ra,0x0
    80005922:	7b4080e7          	jalr	1972(ra) # 800060d2 <acquire>

  switch(c){
    80005926:	47d5                	li	a5,21
    80005928:	0af48663          	beq	s1,a5,800059d4 <consoleintr+0xcc>
    8000592c:	0297ca63          	blt	a5,s1,80005960 <consoleintr+0x58>
    80005930:	47a1                	li	a5,8
    80005932:	0ef48763          	beq	s1,a5,80005a20 <consoleintr+0x118>
    80005936:	47c1                	li	a5,16
    80005938:	10f49a63          	bne	s1,a5,80005a4c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000593c:	ffffc097          	auipc	ra,0xffffc
    80005940:	020080e7          	jalr	32(ra) # 8000195c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005944:	00020517          	auipc	a0,0x20
    80005948:	7fc50513          	addi	a0,a0,2044 # 80026140 <cons>
    8000594c:	00001097          	auipc	ra,0x1
    80005950:	83a080e7          	jalr	-1990(ra) # 80006186 <release>
}
    80005954:	60e2                	ld	ra,24(sp)
    80005956:	6442                	ld	s0,16(sp)
    80005958:	64a2                	ld	s1,8(sp)
    8000595a:	6902                	ld	s2,0(sp)
    8000595c:	6105                	addi	sp,sp,32
    8000595e:	8082                	ret
  switch(c){
    80005960:	07f00793          	li	a5,127
    80005964:	0af48e63          	beq	s1,a5,80005a20 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005968:	00020717          	auipc	a4,0x20
    8000596c:	7d870713          	addi	a4,a4,2008 # 80026140 <cons>
    80005970:	0a072783          	lw	a5,160(a4)
    80005974:	09872703          	lw	a4,152(a4)
    80005978:	9f99                	subw	a5,a5,a4
    8000597a:	07f00713          	li	a4,127
    8000597e:	fcf763e3          	bltu	a4,a5,80005944 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005982:	47b5                	li	a5,13
    80005984:	0cf48763          	beq	s1,a5,80005a52 <consoleintr+0x14a>
      consputc(c);
    80005988:	8526                	mv	a0,s1
    8000598a:	00000097          	auipc	ra,0x0
    8000598e:	f3c080e7          	jalr	-196(ra) # 800058c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005992:	00020797          	auipc	a5,0x20
    80005996:	7ae78793          	addi	a5,a5,1966 # 80026140 <cons>
    8000599a:	0a07a703          	lw	a4,160(a5)
    8000599e:	0017069b          	addiw	a3,a4,1
    800059a2:	0006861b          	sext.w	a2,a3
    800059a6:	0ad7a023          	sw	a3,160(a5)
    800059aa:	07f77713          	andi	a4,a4,127
    800059ae:	97ba                	add	a5,a5,a4
    800059b0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    800059b4:	47a9                	li	a5,10
    800059b6:	0cf48563          	beq	s1,a5,80005a80 <consoleintr+0x178>
    800059ba:	4791                	li	a5,4
    800059bc:	0cf48263          	beq	s1,a5,80005a80 <consoleintr+0x178>
    800059c0:	00021797          	auipc	a5,0x21
    800059c4:	8187a783          	lw	a5,-2024(a5) # 800261d8 <cons+0x98>
    800059c8:	0807879b          	addiw	a5,a5,128
    800059cc:	f6f61ce3          	bne	a2,a5,80005944 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059d0:	863e                	mv	a2,a5
    800059d2:	a07d                	j	80005a80 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059d4:	00020717          	auipc	a4,0x20
    800059d8:	76c70713          	addi	a4,a4,1900 # 80026140 <cons>
    800059dc:	0a072783          	lw	a5,160(a4)
    800059e0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800059e4:	00020497          	auipc	s1,0x20
    800059e8:	75c48493          	addi	s1,s1,1884 # 80026140 <cons>
    while(cons.e != cons.w &&
    800059ec:	4929                	li	s2,10
    800059ee:	f4f70be3          	beq	a4,a5,80005944 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800059f2:	37fd                	addiw	a5,a5,-1
    800059f4:	07f7f713          	andi	a4,a5,127
    800059f8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800059fa:	01874703          	lbu	a4,24(a4)
    800059fe:	f52703e3          	beq	a4,s2,80005944 <consoleintr+0x3c>
      cons.e--;
    80005a02:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a06:	10000513          	li	a0,256
    80005a0a:	00000097          	auipc	ra,0x0
    80005a0e:	ebc080e7          	jalr	-324(ra) # 800058c6 <consputc>
    while(cons.e != cons.w &&
    80005a12:	0a04a783          	lw	a5,160(s1)
    80005a16:	09c4a703          	lw	a4,156(s1)
    80005a1a:	fcf71ce3          	bne	a4,a5,800059f2 <consoleintr+0xea>
    80005a1e:	b71d                	j	80005944 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a20:	00020717          	auipc	a4,0x20
    80005a24:	72070713          	addi	a4,a4,1824 # 80026140 <cons>
    80005a28:	0a072783          	lw	a5,160(a4)
    80005a2c:	09c72703          	lw	a4,156(a4)
    80005a30:	f0f70ae3          	beq	a4,a5,80005944 <consoleintr+0x3c>
      cons.e--;
    80005a34:	37fd                	addiw	a5,a5,-1
    80005a36:	00020717          	auipc	a4,0x20
    80005a3a:	7af72523          	sw	a5,1962(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a3e:	10000513          	li	a0,256
    80005a42:	00000097          	auipc	ra,0x0
    80005a46:	e84080e7          	jalr	-380(ra) # 800058c6 <consputc>
    80005a4a:	bded                	j	80005944 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a4c:	ee048ce3          	beqz	s1,80005944 <consoleintr+0x3c>
    80005a50:	bf21                	j	80005968 <consoleintr+0x60>
      consputc(c);
    80005a52:	4529                	li	a0,10
    80005a54:	00000097          	auipc	ra,0x0
    80005a58:	e72080e7          	jalr	-398(ra) # 800058c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a5c:	00020797          	auipc	a5,0x20
    80005a60:	6e478793          	addi	a5,a5,1764 # 80026140 <cons>
    80005a64:	0a07a703          	lw	a4,160(a5)
    80005a68:	0017069b          	addiw	a3,a4,1
    80005a6c:	0006861b          	sext.w	a2,a3
    80005a70:	0ad7a023          	sw	a3,160(a5)
    80005a74:	07f77713          	andi	a4,a4,127
    80005a78:	97ba                	add	a5,a5,a4
    80005a7a:	4729                	li	a4,10
    80005a7c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005a80:	00020797          	auipc	a5,0x20
    80005a84:	74c7ae23          	sw	a2,1884(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005a88:	00020517          	auipc	a0,0x20
    80005a8c:	75050513          	addi	a0,a0,1872 # 800261d8 <cons+0x98>
    80005a90:	ffffc097          	auipc	ra,0xffffc
    80005a94:	c08080e7          	jalr	-1016(ra) # 80001698 <wakeup>
    80005a98:	b575                	j	80005944 <consoleintr+0x3c>

0000000080005a9a <consoleinit>:

void
consoleinit(void)
{
    80005a9a:	1141                	addi	sp,sp,-16
    80005a9c:	e406                	sd	ra,8(sp)
    80005a9e:	e022                	sd	s0,0(sp)
    80005aa0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005aa2:	00003597          	auipc	a1,0x3
    80005aa6:	e5e58593          	addi	a1,a1,-418 # 80008900 <syscall_names+0x3c8>
    80005aaa:	00020517          	auipc	a0,0x20
    80005aae:	69650513          	addi	a0,a0,1686 # 80026140 <cons>
    80005ab2:	00000097          	auipc	ra,0x0
    80005ab6:	590080e7          	jalr	1424(ra) # 80006042 <initlock>

  uartinit();
    80005aba:	00000097          	auipc	ra,0x0
    80005abe:	330080e7          	jalr	816(ra) # 80005dea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ac2:	00014797          	auipc	a5,0x14
    80005ac6:	80678793          	addi	a5,a5,-2042 # 800192c8 <devsw>
    80005aca:	00000717          	auipc	a4,0x0
    80005ace:	ce470713          	addi	a4,a4,-796 # 800057ae <consoleread>
    80005ad2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ad4:	00000717          	auipc	a4,0x0
    80005ad8:	c7870713          	addi	a4,a4,-904 # 8000574c <consolewrite>
    80005adc:	ef98                	sd	a4,24(a5)
}
    80005ade:	60a2                	ld	ra,8(sp)
    80005ae0:	6402                	ld	s0,0(sp)
    80005ae2:	0141                	addi	sp,sp,16
    80005ae4:	8082                	ret

0000000080005ae6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ae6:	7179                	addi	sp,sp,-48
    80005ae8:	f406                	sd	ra,40(sp)
    80005aea:	f022                	sd	s0,32(sp)
    80005aec:	ec26                	sd	s1,24(sp)
    80005aee:	e84a                	sd	s2,16(sp)
    80005af0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005af2:	c219                	beqz	a2,80005af8 <printint+0x12>
    80005af4:	08054663          	bltz	a0,80005b80 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005af8:	2501                	sext.w	a0,a0
    80005afa:	4881                	li	a7,0
    80005afc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b00:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b02:	2581                	sext.w	a1,a1
    80005b04:	00003617          	auipc	a2,0x3
    80005b08:	e2c60613          	addi	a2,a2,-468 # 80008930 <digits>
    80005b0c:	883a                	mv	a6,a4
    80005b0e:	2705                	addiw	a4,a4,1
    80005b10:	02b577bb          	remuw	a5,a0,a1
    80005b14:	1782                	slli	a5,a5,0x20
    80005b16:	9381                	srli	a5,a5,0x20
    80005b18:	97b2                	add	a5,a5,a2
    80005b1a:	0007c783          	lbu	a5,0(a5)
    80005b1e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b22:	0005079b          	sext.w	a5,a0
    80005b26:	02b5553b          	divuw	a0,a0,a1
    80005b2a:	0685                	addi	a3,a3,1
    80005b2c:	feb7f0e3          	bgeu	a5,a1,80005b0c <printint+0x26>

  if(sign)
    80005b30:	00088b63          	beqz	a7,80005b46 <printint+0x60>
    buf[i++] = '-';
    80005b34:	fe040793          	addi	a5,s0,-32
    80005b38:	973e                	add	a4,a4,a5
    80005b3a:	02d00793          	li	a5,45
    80005b3e:	fef70823          	sb	a5,-16(a4)
    80005b42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b46:	02e05763          	blez	a4,80005b74 <printint+0x8e>
    80005b4a:	fd040793          	addi	a5,s0,-48
    80005b4e:	00e784b3          	add	s1,a5,a4
    80005b52:	fff78913          	addi	s2,a5,-1
    80005b56:	993a                	add	s2,s2,a4
    80005b58:	377d                	addiw	a4,a4,-1
    80005b5a:	1702                	slli	a4,a4,0x20
    80005b5c:	9301                	srli	a4,a4,0x20
    80005b5e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b62:	fff4c503          	lbu	a0,-1(s1)
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	d60080e7          	jalr	-672(ra) # 800058c6 <consputc>
  while(--i >= 0)
    80005b6e:	14fd                	addi	s1,s1,-1
    80005b70:	ff2499e3          	bne	s1,s2,80005b62 <printint+0x7c>
}
    80005b74:	70a2                	ld	ra,40(sp)
    80005b76:	7402                	ld	s0,32(sp)
    80005b78:	64e2                	ld	s1,24(sp)
    80005b7a:	6942                	ld	s2,16(sp)
    80005b7c:	6145                	addi	sp,sp,48
    80005b7e:	8082                	ret
    x = -xx;
    80005b80:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005b84:	4885                	li	a7,1
    x = -xx;
    80005b86:	bf9d                	j	80005afc <printint+0x16>

0000000080005b88 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005b88:	1101                	addi	sp,sp,-32
    80005b8a:	ec06                	sd	ra,24(sp)
    80005b8c:	e822                	sd	s0,16(sp)
    80005b8e:	e426                	sd	s1,8(sp)
    80005b90:	1000                	addi	s0,sp,32
    80005b92:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005b94:	00020797          	auipc	a5,0x20
    80005b98:	6607a623          	sw	zero,1644(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005b9c:	00003517          	auipc	a0,0x3
    80005ba0:	d6c50513          	addi	a0,a0,-660 # 80008908 <syscall_names+0x3d0>
    80005ba4:	00000097          	auipc	ra,0x0
    80005ba8:	02e080e7          	jalr	46(ra) # 80005bd2 <printf>
  printf(s);
    80005bac:	8526                	mv	a0,s1
    80005bae:	00000097          	auipc	ra,0x0
    80005bb2:	024080e7          	jalr	36(ra) # 80005bd2 <printf>
  printf("\n");
    80005bb6:	00002517          	auipc	a0,0x2
    80005bba:	49250513          	addi	a0,a0,1170 # 80008048 <etext+0x48>
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	014080e7          	jalr	20(ra) # 80005bd2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bc6:	4785                	li	a5,1
    80005bc8:	00003717          	auipc	a4,0x3
    80005bcc:	44f72a23          	sw	a5,1108(a4) # 8000901c <panicked>
  for(;;)
    80005bd0:	a001                	j	80005bd0 <panic+0x48>

0000000080005bd2 <printf>:
{
    80005bd2:	7131                	addi	sp,sp,-192
    80005bd4:	fc86                	sd	ra,120(sp)
    80005bd6:	f8a2                	sd	s0,112(sp)
    80005bd8:	f4a6                	sd	s1,104(sp)
    80005bda:	f0ca                	sd	s2,96(sp)
    80005bdc:	ecce                	sd	s3,88(sp)
    80005bde:	e8d2                	sd	s4,80(sp)
    80005be0:	e4d6                	sd	s5,72(sp)
    80005be2:	e0da                	sd	s6,64(sp)
    80005be4:	fc5e                	sd	s7,56(sp)
    80005be6:	f862                	sd	s8,48(sp)
    80005be8:	f466                	sd	s9,40(sp)
    80005bea:	f06a                	sd	s10,32(sp)
    80005bec:	ec6e                	sd	s11,24(sp)
    80005bee:	0100                	addi	s0,sp,128
    80005bf0:	8a2a                	mv	s4,a0
    80005bf2:	e40c                	sd	a1,8(s0)
    80005bf4:	e810                	sd	a2,16(s0)
    80005bf6:	ec14                	sd	a3,24(s0)
    80005bf8:	f018                	sd	a4,32(s0)
    80005bfa:	f41c                	sd	a5,40(s0)
    80005bfc:	03043823          	sd	a6,48(s0)
    80005c00:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c04:	00020d97          	auipc	s11,0x20
    80005c08:	5fcdad83          	lw	s11,1532(s11) # 80026200 <pr+0x18>
  if(locking)
    80005c0c:	020d9b63          	bnez	s11,80005c42 <printf+0x70>
  if (fmt == 0)
    80005c10:	040a0263          	beqz	s4,80005c54 <printf+0x82>
  va_start(ap, fmt);
    80005c14:	00840793          	addi	a5,s0,8
    80005c18:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c1c:	000a4503          	lbu	a0,0(s4)
    80005c20:	16050263          	beqz	a0,80005d84 <printf+0x1b2>
    80005c24:	4481                	li	s1,0
    if(c != '%'){
    80005c26:	02500a93          	li	s5,37
    switch(c){
    80005c2a:	07000b13          	li	s6,112
  consputc('x');
    80005c2e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c30:	00003b97          	auipc	s7,0x3
    80005c34:	d00b8b93          	addi	s7,s7,-768 # 80008930 <digits>
    switch(c){
    80005c38:	07300c93          	li	s9,115
    80005c3c:	06400c13          	li	s8,100
    80005c40:	a82d                	j	80005c7a <printf+0xa8>
    acquire(&pr.lock);
    80005c42:	00020517          	auipc	a0,0x20
    80005c46:	5a650513          	addi	a0,a0,1446 # 800261e8 <pr>
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	488080e7          	jalr	1160(ra) # 800060d2 <acquire>
    80005c52:	bf7d                	j	80005c10 <printf+0x3e>
    panic("null fmt");
    80005c54:	00003517          	auipc	a0,0x3
    80005c58:	cc450513          	addi	a0,a0,-828 # 80008918 <syscall_names+0x3e0>
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	f2c080e7          	jalr	-212(ra) # 80005b88 <panic>
      consputc(c);
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	c62080e7          	jalr	-926(ra) # 800058c6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c6c:	2485                	addiw	s1,s1,1
    80005c6e:	009a07b3          	add	a5,s4,s1
    80005c72:	0007c503          	lbu	a0,0(a5)
    80005c76:	10050763          	beqz	a0,80005d84 <printf+0x1b2>
    if(c != '%'){
    80005c7a:	ff5515e3          	bne	a0,s5,80005c64 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005c7e:	2485                	addiw	s1,s1,1
    80005c80:	009a07b3          	add	a5,s4,s1
    80005c84:	0007c783          	lbu	a5,0(a5)
    80005c88:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005c8c:	cfe5                	beqz	a5,80005d84 <printf+0x1b2>
    switch(c){
    80005c8e:	05678a63          	beq	a5,s6,80005ce2 <printf+0x110>
    80005c92:	02fb7663          	bgeu	s6,a5,80005cbe <printf+0xec>
    80005c96:	09978963          	beq	a5,s9,80005d28 <printf+0x156>
    80005c9a:	07800713          	li	a4,120
    80005c9e:	0ce79863          	bne	a5,a4,80005d6e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ca2:	f8843783          	ld	a5,-120(s0)
    80005ca6:	00878713          	addi	a4,a5,8
    80005caa:	f8e43423          	sd	a4,-120(s0)
    80005cae:	4605                	li	a2,1
    80005cb0:	85ea                	mv	a1,s10
    80005cb2:	4388                	lw	a0,0(a5)
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	e32080e7          	jalr	-462(ra) # 80005ae6 <printint>
      break;
    80005cbc:	bf45                	j	80005c6c <printf+0x9a>
    switch(c){
    80005cbe:	0b578263          	beq	a5,s5,80005d62 <printf+0x190>
    80005cc2:	0b879663          	bne	a5,s8,80005d6e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005cc6:	f8843783          	ld	a5,-120(s0)
    80005cca:	00878713          	addi	a4,a5,8
    80005cce:	f8e43423          	sd	a4,-120(s0)
    80005cd2:	4605                	li	a2,1
    80005cd4:	45a9                	li	a1,10
    80005cd6:	4388                	lw	a0,0(a5)
    80005cd8:	00000097          	auipc	ra,0x0
    80005cdc:	e0e080e7          	jalr	-498(ra) # 80005ae6 <printint>
      break;
    80005ce0:	b771                	j	80005c6c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ce2:	f8843783          	ld	a5,-120(s0)
    80005ce6:	00878713          	addi	a4,a5,8
    80005cea:	f8e43423          	sd	a4,-120(s0)
    80005cee:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005cf2:	03000513          	li	a0,48
    80005cf6:	00000097          	auipc	ra,0x0
    80005cfa:	bd0080e7          	jalr	-1072(ra) # 800058c6 <consputc>
  consputc('x');
    80005cfe:	07800513          	li	a0,120
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	bc4080e7          	jalr	-1084(ra) # 800058c6 <consputc>
    80005d0a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d0c:	03c9d793          	srli	a5,s3,0x3c
    80005d10:	97de                	add	a5,a5,s7
    80005d12:	0007c503          	lbu	a0,0(a5)
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	bb0080e7          	jalr	-1104(ra) # 800058c6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d1e:	0992                	slli	s3,s3,0x4
    80005d20:	397d                	addiw	s2,s2,-1
    80005d22:	fe0915e3          	bnez	s2,80005d0c <printf+0x13a>
    80005d26:	b799                	j	80005c6c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d28:	f8843783          	ld	a5,-120(s0)
    80005d2c:	00878713          	addi	a4,a5,8
    80005d30:	f8e43423          	sd	a4,-120(s0)
    80005d34:	0007b903          	ld	s2,0(a5)
    80005d38:	00090e63          	beqz	s2,80005d54 <printf+0x182>
      for(; *s; s++)
    80005d3c:	00094503          	lbu	a0,0(s2)
    80005d40:	d515                	beqz	a0,80005c6c <printf+0x9a>
        consputc(*s);
    80005d42:	00000097          	auipc	ra,0x0
    80005d46:	b84080e7          	jalr	-1148(ra) # 800058c6 <consputc>
      for(; *s; s++)
    80005d4a:	0905                	addi	s2,s2,1
    80005d4c:	00094503          	lbu	a0,0(s2)
    80005d50:	f96d                	bnez	a0,80005d42 <printf+0x170>
    80005d52:	bf29                	j	80005c6c <printf+0x9a>
        s = "(null)";
    80005d54:	00003917          	auipc	s2,0x3
    80005d58:	bbc90913          	addi	s2,s2,-1092 # 80008910 <syscall_names+0x3d8>
      for(; *s; s++)
    80005d5c:	02800513          	li	a0,40
    80005d60:	b7cd                	j	80005d42 <printf+0x170>
      consputc('%');
    80005d62:	8556                	mv	a0,s5
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	b62080e7          	jalr	-1182(ra) # 800058c6 <consputc>
      break;
    80005d6c:	b701                	j	80005c6c <printf+0x9a>
      consputc('%');
    80005d6e:	8556                	mv	a0,s5
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	b56080e7          	jalr	-1194(ra) # 800058c6 <consputc>
      consputc(c);
    80005d78:	854a                	mv	a0,s2
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	b4c080e7          	jalr	-1204(ra) # 800058c6 <consputc>
      break;
    80005d82:	b5ed                	j	80005c6c <printf+0x9a>
  if(locking)
    80005d84:	020d9163          	bnez	s11,80005da6 <printf+0x1d4>
}
    80005d88:	70e6                	ld	ra,120(sp)
    80005d8a:	7446                	ld	s0,112(sp)
    80005d8c:	74a6                	ld	s1,104(sp)
    80005d8e:	7906                	ld	s2,96(sp)
    80005d90:	69e6                	ld	s3,88(sp)
    80005d92:	6a46                	ld	s4,80(sp)
    80005d94:	6aa6                	ld	s5,72(sp)
    80005d96:	6b06                	ld	s6,64(sp)
    80005d98:	7be2                	ld	s7,56(sp)
    80005d9a:	7c42                	ld	s8,48(sp)
    80005d9c:	7ca2                	ld	s9,40(sp)
    80005d9e:	7d02                	ld	s10,32(sp)
    80005da0:	6de2                	ld	s11,24(sp)
    80005da2:	6129                	addi	sp,sp,192
    80005da4:	8082                	ret
    release(&pr.lock);
    80005da6:	00020517          	auipc	a0,0x20
    80005daa:	44250513          	addi	a0,a0,1090 # 800261e8 <pr>
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	3d8080e7          	jalr	984(ra) # 80006186 <release>
}
    80005db6:	bfc9                	j	80005d88 <printf+0x1b6>

0000000080005db8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005db8:	1101                	addi	sp,sp,-32
    80005dba:	ec06                	sd	ra,24(sp)
    80005dbc:	e822                	sd	s0,16(sp)
    80005dbe:	e426                	sd	s1,8(sp)
    80005dc0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005dc2:	00020497          	auipc	s1,0x20
    80005dc6:	42648493          	addi	s1,s1,1062 # 800261e8 <pr>
    80005dca:	00003597          	auipc	a1,0x3
    80005dce:	b5e58593          	addi	a1,a1,-1186 # 80008928 <syscall_names+0x3f0>
    80005dd2:	8526                	mv	a0,s1
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	26e080e7          	jalr	622(ra) # 80006042 <initlock>
  pr.locking = 1;
    80005ddc:	4785                	li	a5,1
    80005dde:	cc9c                	sw	a5,24(s1)
}
    80005de0:	60e2                	ld	ra,24(sp)
    80005de2:	6442                	ld	s0,16(sp)
    80005de4:	64a2                	ld	s1,8(sp)
    80005de6:	6105                	addi	sp,sp,32
    80005de8:	8082                	ret

0000000080005dea <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005dea:	1141                	addi	sp,sp,-16
    80005dec:	e406                	sd	ra,8(sp)
    80005dee:	e022                	sd	s0,0(sp)
    80005df0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005df2:	100007b7          	lui	a5,0x10000
    80005df6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005dfa:	f8000713          	li	a4,-128
    80005dfe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e02:	470d                	li	a4,3
    80005e04:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e08:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e0c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e10:	469d                	li	a3,7
    80005e12:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e16:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e1a:	00003597          	auipc	a1,0x3
    80005e1e:	b2e58593          	addi	a1,a1,-1234 # 80008948 <digits+0x18>
    80005e22:	00020517          	auipc	a0,0x20
    80005e26:	3e650513          	addi	a0,a0,998 # 80026208 <uart_tx_lock>
    80005e2a:	00000097          	auipc	ra,0x0
    80005e2e:	218080e7          	jalr	536(ra) # 80006042 <initlock>
}
    80005e32:	60a2                	ld	ra,8(sp)
    80005e34:	6402                	ld	s0,0(sp)
    80005e36:	0141                	addi	sp,sp,16
    80005e38:	8082                	ret

0000000080005e3a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e3a:	1101                	addi	sp,sp,-32
    80005e3c:	ec06                	sd	ra,24(sp)
    80005e3e:	e822                	sd	s0,16(sp)
    80005e40:	e426                	sd	s1,8(sp)
    80005e42:	1000                	addi	s0,sp,32
    80005e44:	84aa                	mv	s1,a0
  push_off();
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	240080e7          	jalr	576(ra) # 80006086 <push_off>

  if(panicked){
    80005e4e:	00003797          	auipc	a5,0x3
    80005e52:	1ce7a783          	lw	a5,462(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e56:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e5a:	c391                	beqz	a5,80005e5e <uartputc_sync+0x24>
    for(;;)
    80005e5c:	a001                	j	80005e5c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e5e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e62:	0ff7f793          	andi	a5,a5,255
    80005e66:	0207f793          	andi	a5,a5,32
    80005e6a:	dbf5                	beqz	a5,80005e5e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e6c:	0ff4f793          	andi	a5,s1,255
    80005e70:	10000737          	lui	a4,0x10000
    80005e74:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	2ae080e7          	jalr	686(ra) # 80006126 <pop_off>
}
    80005e80:	60e2                	ld	ra,24(sp)
    80005e82:	6442                	ld	s0,16(sp)
    80005e84:	64a2                	ld	s1,8(sp)
    80005e86:	6105                	addi	sp,sp,32
    80005e88:	8082                	ret

0000000080005e8a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005e8a:	00003717          	auipc	a4,0x3
    80005e8e:	19673703          	ld	a4,406(a4) # 80009020 <uart_tx_r>
    80005e92:	00003797          	auipc	a5,0x3
    80005e96:	1967b783          	ld	a5,406(a5) # 80009028 <uart_tx_w>
    80005e9a:	06e78c63          	beq	a5,a4,80005f12 <uartstart+0x88>
{
    80005e9e:	7139                	addi	sp,sp,-64
    80005ea0:	fc06                	sd	ra,56(sp)
    80005ea2:	f822                	sd	s0,48(sp)
    80005ea4:	f426                	sd	s1,40(sp)
    80005ea6:	f04a                	sd	s2,32(sp)
    80005ea8:	ec4e                	sd	s3,24(sp)
    80005eaa:	e852                	sd	s4,16(sp)
    80005eac:	e456                	sd	s5,8(sp)
    80005eae:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005eb0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005eb4:	00020a17          	auipc	s4,0x20
    80005eb8:	354a0a13          	addi	s4,s4,852 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005ebc:	00003497          	auipc	s1,0x3
    80005ec0:	16448493          	addi	s1,s1,356 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ec4:	00003997          	auipc	s3,0x3
    80005ec8:	16498993          	addi	s3,s3,356 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ecc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ed0:	0ff7f793          	andi	a5,a5,255
    80005ed4:	0207f793          	andi	a5,a5,32
    80005ed8:	c785                	beqz	a5,80005f00 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005eda:	01f77793          	andi	a5,a4,31
    80005ede:	97d2                	add	a5,a5,s4
    80005ee0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005ee4:	0705                	addi	a4,a4,1
    80005ee6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ee8:	8526                	mv	a0,s1
    80005eea:	ffffb097          	auipc	ra,0xffffb
    80005eee:	7ae080e7          	jalr	1966(ra) # 80001698 <wakeup>
    
    WriteReg(THR, c);
    80005ef2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ef6:	6098                	ld	a4,0(s1)
    80005ef8:	0009b783          	ld	a5,0(s3)
    80005efc:	fce798e3          	bne	a5,a4,80005ecc <uartstart+0x42>
  }
}
    80005f00:	70e2                	ld	ra,56(sp)
    80005f02:	7442                	ld	s0,48(sp)
    80005f04:	74a2                	ld	s1,40(sp)
    80005f06:	7902                	ld	s2,32(sp)
    80005f08:	69e2                	ld	s3,24(sp)
    80005f0a:	6a42                	ld	s4,16(sp)
    80005f0c:	6aa2                	ld	s5,8(sp)
    80005f0e:	6121                	addi	sp,sp,64
    80005f10:	8082                	ret
    80005f12:	8082                	ret

0000000080005f14 <uartputc>:
{
    80005f14:	7179                	addi	sp,sp,-48
    80005f16:	f406                	sd	ra,40(sp)
    80005f18:	f022                	sd	s0,32(sp)
    80005f1a:	ec26                	sd	s1,24(sp)
    80005f1c:	e84a                	sd	s2,16(sp)
    80005f1e:	e44e                	sd	s3,8(sp)
    80005f20:	e052                	sd	s4,0(sp)
    80005f22:	1800                	addi	s0,sp,48
    80005f24:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005f26:	00020517          	auipc	a0,0x20
    80005f2a:	2e250513          	addi	a0,a0,738 # 80026208 <uart_tx_lock>
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	1a4080e7          	jalr	420(ra) # 800060d2 <acquire>
  if(panicked){
    80005f36:	00003797          	auipc	a5,0x3
    80005f3a:	0e67a783          	lw	a5,230(a5) # 8000901c <panicked>
    80005f3e:	c391                	beqz	a5,80005f42 <uartputc+0x2e>
    for(;;)
    80005f40:	a001                	j	80005f40 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f42:	00003797          	auipc	a5,0x3
    80005f46:	0e67b783          	ld	a5,230(a5) # 80009028 <uart_tx_w>
    80005f4a:	00003717          	auipc	a4,0x3
    80005f4e:	0d673703          	ld	a4,214(a4) # 80009020 <uart_tx_r>
    80005f52:	02070713          	addi	a4,a4,32
    80005f56:	02f71b63          	bne	a4,a5,80005f8c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f5a:	00020a17          	auipc	s4,0x20
    80005f5e:	2aea0a13          	addi	s4,s4,686 # 80026208 <uart_tx_lock>
    80005f62:	00003497          	auipc	s1,0x3
    80005f66:	0be48493          	addi	s1,s1,190 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f6a:	00003917          	auipc	s2,0x3
    80005f6e:	0be90913          	addi	s2,s2,190 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f72:	85d2                	mv	a1,s4
    80005f74:	8526                	mv	a0,s1
    80005f76:	ffffb097          	auipc	ra,0xffffb
    80005f7a:	596080e7          	jalr	1430(ra) # 8000150c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f7e:	00093783          	ld	a5,0(s2)
    80005f82:	6098                	ld	a4,0(s1)
    80005f84:	02070713          	addi	a4,a4,32
    80005f88:	fef705e3          	beq	a4,a5,80005f72 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005f8c:	00020497          	auipc	s1,0x20
    80005f90:	27c48493          	addi	s1,s1,636 # 80026208 <uart_tx_lock>
    80005f94:	01f7f713          	andi	a4,a5,31
    80005f98:	9726                	add	a4,a4,s1
    80005f9a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    80005f9e:	0785                	addi	a5,a5,1
    80005fa0:	00003717          	auipc	a4,0x3
    80005fa4:	08f73423          	sd	a5,136(a4) # 80009028 <uart_tx_w>
      uartstart();
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	ee2080e7          	jalr	-286(ra) # 80005e8a <uartstart>
      release(&uart_tx_lock);
    80005fb0:	8526                	mv	a0,s1
    80005fb2:	00000097          	auipc	ra,0x0
    80005fb6:	1d4080e7          	jalr	468(ra) # 80006186 <release>
}
    80005fba:	70a2                	ld	ra,40(sp)
    80005fbc:	7402                	ld	s0,32(sp)
    80005fbe:	64e2                	ld	s1,24(sp)
    80005fc0:	6942                	ld	s2,16(sp)
    80005fc2:	69a2                	ld	s3,8(sp)
    80005fc4:	6a02                	ld	s4,0(sp)
    80005fc6:	6145                	addi	sp,sp,48
    80005fc8:	8082                	ret

0000000080005fca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fca:	1141                	addi	sp,sp,-16
    80005fcc:	e422                	sd	s0,8(sp)
    80005fce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fd0:	100007b7          	lui	a5,0x10000
    80005fd4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005fd8:	8b85                	andi	a5,a5,1
    80005fda:	cb91                	beqz	a5,80005fee <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005fdc:	100007b7          	lui	a5,0x10000
    80005fe0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80005fe4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80005fe8:	6422                	ld	s0,8(sp)
    80005fea:	0141                	addi	sp,sp,16
    80005fec:	8082                	ret
    return -1;
    80005fee:	557d                	li	a0,-1
    80005ff0:	bfe5                	j	80005fe8 <uartgetc+0x1e>

0000000080005ff2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80005ff2:	1101                	addi	sp,sp,-32
    80005ff4:	ec06                	sd	ra,24(sp)
    80005ff6:	e822                	sd	s0,16(sp)
    80005ff8:	e426                	sd	s1,8(sp)
    80005ffa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005ffc:	54fd                	li	s1,-1
    int c = uartgetc();
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	fcc080e7          	jalr	-52(ra) # 80005fca <uartgetc>
    if(c == -1)
    80006006:	00950763          	beq	a0,s1,80006014 <uartintr+0x22>
      break;
    consoleintr(c);
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	8fe080e7          	jalr	-1794(ra) # 80005908 <consoleintr>
  while(1){
    80006012:	b7f5                	j	80005ffe <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006014:	00020497          	auipc	s1,0x20
    80006018:	1f448493          	addi	s1,s1,500 # 80026208 <uart_tx_lock>
    8000601c:	8526                	mv	a0,s1
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	0b4080e7          	jalr	180(ra) # 800060d2 <acquire>
  uartstart();
    80006026:	00000097          	auipc	ra,0x0
    8000602a:	e64080e7          	jalr	-412(ra) # 80005e8a <uartstart>
  release(&uart_tx_lock);
    8000602e:	8526                	mv	a0,s1
    80006030:	00000097          	auipc	ra,0x0
    80006034:	156080e7          	jalr	342(ra) # 80006186 <release>
}
    80006038:	60e2                	ld	ra,24(sp)
    8000603a:	6442                	ld	s0,16(sp)
    8000603c:	64a2                	ld	s1,8(sp)
    8000603e:	6105                	addi	sp,sp,32
    80006040:	8082                	ret

0000000080006042 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006042:	1141                	addi	sp,sp,-16
    80006044:	e422                	sd	s0,8(sp)
    80006046:	0800                	addi	s0,sp,16
  lk->name = name;
    80006048:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000604a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000604e:	00053823          	sd	zero,16(a0)
}
    80006052:	6422                	ld	s0,8(sp)
    80006054:	0141                	addi	sp,sp,16
    80006056:	8082                	ret

0000000080006058 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006058:	411c                	lw	a5,0(a0)
    8000605a:	e399                	bnez	a5,80006060 <holding+0x8>
    8000605c:	4501                	li	a0,0
  return r;
}
    8000605e:	8082                	ret
{
    80006060:	1101                	addi	sp,sp,-32
    80006062:	ec06                	sd	ra,24(sp)
    80006064:	e822                	sd	s0,16(sp)
    80006066:	e426                	sd	s1,8(sp)
    80006068:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000606a:	6904                	ld	s1,16(a0)
    8000606c:	ffffb097          	auipc	ra,0xffffb
    80006070:	dc0080e7          	jalr	-576(ra) # 80000e2c <mycpu>
    80006074:	40a48533          	sub	a0,s1,a0
    80006078:	00153513          	seqz	a0,a0
}
    8000607c:	60e2                	ld	ra,24(sp)
    8000607e:	6442                	ld	s0,16(sp)
    80006080:	64a2                	ld	s1,8(sp)
    80006082:	6105                	addi	sp,sp,32
    80006084:	8082                	ret

0000000080006086 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006086:	1101                	addi	sp,sp,-32
    80006088:	ec06                	sd	ra,24(sp)
    8000608a:	e822                	sd	s0,16(sp)
    8000608c:	e426                	sd	s1,8(sp)
    8000608e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006090:	100024f3          	csrr	s1,sstatus
    80006094:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006098:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000609a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000609e:	ffffb097          	auipc	ra,0xffffb
    800060a2:	d8e080e7          	jalr	-626(ra) # 80000e2c <mycpu>
    800060a6:	5d3c                	lw	a5,120(a0)
    800060a8:	cf89                	beqz	a5,800060c2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800060aa:	ffffb097          	auipc	ra,0xffffb
    800060ae:	d82080e7          	jalr	-638(ra) # 80000e2c <mycpu>
    800060b2:	5d3c                	lw	a5,120(a0)
    800060b4:	2785                	addiw	a5,a5,1
    800060b6:	dd3c                	sw	a5,120(a0)
}
    800060b8:	60e2                	ld	ra,24(sp)
    800060ba:	6442                	ld	s0,16(sp)
    800060bc:	64a2                	ld	s1,8(sp)
    800060be:	6105                	addi	sp,sp,32
    800060c0:	8082                	ret
    mycpu()->intena = old;
    800060c2:	ffffb097          	auipc	ra,0xffffb
    800060c6:	d6a080e7          	jalr	-662(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060ca:	8085                	srli	s1,s1,0x1
    800060cc:	8885                	andi	s1,s1,1
    800060ce:	dd64                	sw	s1,124(a0)
    800060d0:	bfe9                	j	800060aa <push_off+0x24>

00000000800060d2 <acquire>:
{
    800060d2:	1101                	addi	sp,sp,-32
    800060d4:	ec06                	sd	ra,24(sp)
    800060d6:	e822                	sd	s0,16(sp)
    800060d8:	e426                	sd	s1,8(sp)
    800060da:	1000                	addi	s0,sp,32
    800060dc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	fa8080e7          	jalr	-88(ra) # 80006086 <push_off>
  if(holding(lk))
    800060e6:	8526                	mv	a0,s1
    800060e8:	00000097          	auipc	ra,0x0
    800060ec:	f70080e7          	jalr	-144(ra) # 80006058 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060f0:	4705                	li	a4,1
  if(holding(lk))
    800060f2:	e115                	bnez	a0,80006116 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800060f4:	87ba                	mv	a5,a4
    800060f6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800060fa:	2781                	sext.w	a5,a5
    800060fc:	ffe5                	bnez	a5,800060f4 <acquire+0x22>
  __sync_synchronize();
    800060fe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006102:	ffffb097          	auipc	ra,0xffffb
    80006106:	d2a080e7          	jalr	-726(ra) # 80000e2c <mycpu>
    8000610a:	e888                	sd	a0,16(s1)
}
    8000610c:	60e2                	ld	ra,24(sp)
    8000610e:	6442                	ld	s0,16(sp)
    80006110:	64a2                	ld	s1,8(sp)
    80006112:	6105                	addi	sp,sp,32
    80006114:	8082                	ret
    panic("acquire");
    80006116:	00003517          	auipc	a0,0x3
    8000611a:	83a50513          	addi	a0,a0,-1990 # 80008950 <digits+0x20>
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	a6a080e7          	jalr	-1430(ra) # 80005b88 <panic>

0000000080006126 <pop_off>:

void
pop_off(void)
{
    80006126:	1141                	addi	sp,sp,-16
    80006128:	e406                	sd	ra,8(sp)
    8000612a:	e022                	sd	s0,0(sp)
    8000612c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000612e:	ffffb097          	auipc	ra,0xffffb
    80006132:	cfe080e7          	jalr	-770(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006136:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000613a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000613c:	e78d                	bnez	a5,80006166 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000613e:	5d3c                	lw	a5,120(a0)
    80006140:	02f05b63          	blez	a5,80006176 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006144:	37fd                	addiw	a5,a5,-1
    80006146:	0007871b          	sext.w	a4,a5
    8000614a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000614c:	eb09                	bnez	a4,8000615e <pop_off+0x38>
    8000614e:	5d7c                	lw	a5,124(a0)
    80006150:	c799                	beqz	a5,8000615e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006152:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006156:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000615a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000615e:	60a2                	ld	ra,8(sp)
    80006160:	6402                	ld	s0,0(sp)
    80006162:	0141                	addi	sp,sp,16
    80006164:	8082                	ret
    panic("pop_off - interruptible");
    80006166:	00002517          	auipc	a0,0x2
    8000616a:	7f250513          	addi	a0,a0,2034 # 80008958 <digits+0x28>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	a1a080e7          	jalr	-1510(ra) # 80005b88 <panic>
    panic("pop_off");
    80006176:	00002517          	auipc	a0,0x2
    8000617a:	7fa50513          	addi	a0,a0,2042 # 80008970 <digits+0x40>
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	a0a080e7          	jalr	-1526(ra) # 80005b88 <panic>

0000000080006186 <release>:
{
    80006186:	1101                	addi	sp,sp,-32
    80006188:	ec06                	sd	ra,24(sp)
    8000618a:	e822                	sd	s0,16(sp)
    8000618c:	e426                	sd	s1,8(sp)
    8000618e:	1000                	addi	s0,sp,32
    80006190:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006192:	00000097          	auipc	ra,0x0
    80006196:	ec6080e7          	jalr	-314(ra) # 80006058 <holding>
    8000619a:	c115                	beqz	a0,800061be <release+0x38>
  lk->cpu = 0;
    8000619c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061a0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061a4:	0f50000f          	fence	iorw,ow
    800061a8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	f7a080e7          	jalr	-134(ra) # 80006126 <pop_off>
}
    800061b4:	60e2                	ld	ra,24(sp)
    800061b6:	6442                	ld	s0,16(sp)
    800061b8:	64a2                	ld	s1,8(sp)
    800061ba:	6105                	addi	sp,sp,32
    800061bc:	8082                	ret
    panic("release");
    800061be:	00002517          	auipc	a0,0x2
    800061c2:	7ba50513          	addi	a0,a0,1978 # 80008978 <digits+0x48>
    800061c6:	00000097          	auipc	ra,0x0
    800061ca:	9c2080e7          	jalr	-1598(ra) # 80005b88 <panic>
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
