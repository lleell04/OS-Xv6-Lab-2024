
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a0013103          	ld	sp,-1536(sp) # 80008a00 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	198080e7          	jalr	408(ra) # 800061f2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	238080e7          	jalr	568(ra) # 800062a6 <release>
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
    8000008e:	c1e080e7          	jalr	-994(ra) # 80005ca8 <panic>

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
    800000f8:	06e080e7          	jalr	110(ra) # 80006162 <initlock>
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
    80000130:	0c6080e7          	jalr	198(ra) # 800061f2 <acquire>
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
    80000148:	162080e7          	jalr	354(ra) # 800062a6 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
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
    80000172:	138080e7          	jalr	312(ra) # 800062a6 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <free_mem>:

uint64 free_mem(void){
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 num=0;
  acquire(&kmem.lock);
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	066080e7          	jalr	102(ra) # 800061f2 <acquire>
  r=kmem.freelist;
    80000194:	6c9c                	ld	a5,24(s1)
  while(r){
    80000196:	c785                	beqz	a5,800001be <free_mem+0x46>
  uint64 num=0;
    80000198:	4481                	li	s1,0
    num++;
    8000019a:	0485                	addi	s1,s1,1
    r = r->next;
    8000019c:	639c                	ld	a5,0(a5)
  while(r){
    8000019e:	fff5                	bnez	a5,8000019a <free_mem+0x22>
  }
  release(&kmem.lock);
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	e9050513          	addi	a0,a0,-368 # 80009030 <kmem>
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	0fe080e7          	jalr	254(ra) # 800062a6 <release>
  return num * PGSIZE;
}
    800001b0:	00c49513          	slli	a0,s1,0xc
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
  uint64 num=0;
    800001be:	4481                	li	s1,0
    800001c0:	b7c5                	j	800001a0 <free_mem+0x28>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ce09                	beqz	a2,800001e2 <memset+0x20>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	fff6071b          	addiw	a4,a2,-1
    800001d0:	1702                	slli	a4,a4,0x20
    800001d2:	9301                	srli	a4,a4,0x20
    800001d4:	0705                	addi	a4,a4,1
    800001d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x16>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	ca0d                	beqz	a2,8000025a <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	00a5f963          	bgeu	a1,a0,8000023c <memmove+0x1a>
    8000022e:	02061693          	slli	a3,a2,0x20
    80000232:	9281                	srli	a3,a3,0x20
    80000234:	00d58733          	add	a4,a1,a3
    80000238:	02e56463          	bltu	a0,a4,80000260 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	0785                	addi	a5,a5,1
    80000246:	97ae                	add	a5,a5,a1
    80000248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024a:	0585                	addi	a1,a1,1
    8000024c:	0705                	addi	a4,a4,1
    8000024e:	fff5c683          	lbu	a3,-1(a1)
    80000252:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000256:	fef59ae3          	bne	a1,a5,8000024a <memmove+0x28>

  return dst;
}
    8000025a:	6422                	ld	s0,8(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fef71ae3          	bne	a4,a5,80000270 <memmove+0x4e>
    80000280:	bfe9                	j	8000025a <memmove+0x38>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f98080e7          	jalr	-104(ra) # 80000222 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	00c05d63          	blez	a2,8000030e <strncpy+0x38>
    800002f8:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	aee080e7          	jalr	-1298(ra) # 80000e66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad2080e7          	jalr	-1326(ra) # 80000e66 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	94c080e7          	jalr	-1716(ra) # 80005cf2 <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	784080e7          	jalr	1924(ra) # 80001b3a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	dc2080e7          	jalr	-574(ra) # 80005180 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fde080e7          	jalr	-34(ra) # 800013a4 <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	7ec080e7          	jalr	2028(ra) # 80005bba <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	b02080e7          	jalr	-1278(ra) # 80005ed8 <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	90c080e7          	jalr	-1780(ra) # 80005cf2 <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	8fc080e7          	jalr	-1796(ra) # 80005cf2 <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	8ec080e7          	jalr	-1812(ra) # 80005cf2 <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	990080e7          	jalr	-1648(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6e4080e7          	jalr	1764(ra) # 80001b12 <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	704080e7          	jalr	1796(ra) # 80001b3a <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d2c080e7          	jalr	-724(ra) # 8000516a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	d3a080e7          	jalr	-710(ra) # 80005180 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	f1a080e7          	jalr	-230(ra) # 80002368 <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	5aa080e7          	jalr	1450(ra) # 80002a00 <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	554080e7          	jalr	1364(ra) # 800039b2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	e3c080e7          	jalr	-452(ra) # 800052a2 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	cfc080e7          	jalr	-772(ra) # 8000116a <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000049c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	7d0080e7          	jalr	2000(ra) # 80005ca8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cce080e7          	jalr	-818(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c205                	beqz	a2,800005c8 <mappages+0x36>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	a015                	j	800005ea <mappages+0x58>
    panic("mappages: size");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9050513          	addi	a0,a0,-1392 # 80008058 <etext+0x58>
    800005d0:	00005097          	auipc	ra,0x5
    800005d4:	6d8080e7          	jalr	1752(ra) # 80005ca8 <panic>
      panic("mappages: remap");
    800005d8:	00008517          	auipc	a0,0x8
    800005dc:	a9050513          	addi	a0,a0,-1392 # 80008068 <etext+0x68>
    800005e0:	00005097          	auipc	ra,0x5
    800005e4:	6c8080e7          	jalr	1736(ra) # 80005ca8 <panic>
    a += PGSIZE;
    800005e8:	995e                	add	s2,s2,s7
  for(;;){
    800005ea:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	4605                	li	a2,1
    800005f0:	85ca                	mv	a1,s2
    800005f2:	8556                	mv	a0,s5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	eb6080e7          	jalr	-330(ra) # 800004aa <walk>
    800005fc:	cd19                	beqz	a0,8000061a <mappages+0x88>
    if(*pte & PTE_V)
    800005fe:	611c                	ld	a5,0(a0)
    80000600:	8b85                	andi	a5,a5,1
    80000602:	fbf9                	bnez	a5,800005d8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000604:	80b1                	srli	s1,s1,0xc
    80000606:	04aa                	slli	s1,s1,0xa
    80000608:	0164e4b3          	or	s1,s1,s6
    8000060c:	0014e493          	ori	s1,s1,1
    80000610:	e104                	sd	s1,0(a0)
    if(a == last)
    80000612:	fd391be3          	bne	s2,s3,800005e8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	a011                	j	8000061c <mappages+0x8a>
      return -1;
    8000061a:	557d                	li	a0,-1
}
    8000061c:	60a6                	ld	ra,72(sp)
    8000061e:	6406                	ld	s0,64(sp)
    80000620:	74e2                	ld	s1,56(sp)
    80000622:	7942                	ld	s2,48(sp)
    80000624:	79a2                	ld	s3,40(sp)
    80000626:	7a02                	ld	s4,32(sp)
    80000628:	6ae2                	ld	s5,24(sp)
    8000062a:	6b42                	ld	s6,16(sp)
    8000062c:	6ba2                	ld	s7,8(sp)
    8000062e:	6161                	addi	sp,sp,80
    80000630:	8082                	ret

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	64e080e7          	jalr	1614(ra) # 80005ca8 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b46080e7          	jalr	-1210(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	5fe080e7          	jalr	1534(ra) # 80000d20 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e863          	bltu	a1,s3,800007f4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	502080e7          	jalr	1282(ra) # 80005ca8 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	4f2080e7          	jalr	1266(ra) # 80005ca8 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	4e2080e7          	jalr	1250(ra) # 80005ca8 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	4d2080e7          	jalr	1234(ra) # 80005ca8 <panic>
      uint64 pa = PTE2PA(*pte);
    800007de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e0:	0532                	slli	a0,a0,0xc
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	83a080e7          	jalr	-1990(ra) # 8000001c <kfree>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f9397ce3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	cb0080e7          	jalr	-848(ra) # 800004aa <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d54d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000806:	6108                	ld	a0,0(a0)
    80000808:	00157793          	andi	a5,a0,1
    8000080c:	dbcd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff57793          	andi	a5,a0,1023
    80000812:	fb778ee3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x92>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	98c080e7          	jalr	-1652(ra) # 800001c2 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	94e080e7          	jalr	-1714(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	3f4080e7          	jalr	1012(ra) # 80005ca8 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	882080e7          	jalr	-1918(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	2b2080e7          	jalr	690(ra) # 80005ca8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	77e080e7          	jalr	1918(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	1d6080e7          	jalr	470(ra) # 80005ca8 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	1c6080e7          	jalr	454(ra) # 80005ca8 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	15c080e7          	jalr	348(ra) # 80005ca8 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69a080e7          	jalr	1690(ra) # 80000222 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	c6bd                	beqz	a3,80000c4e <copyin+0x6e>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a015                	j	80000c2a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	9562                	add	a0,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412505b3          	sub	a1,a0,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60e080e7          	jalr	1550(ra) # 80000222 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	91e080e7          	jalr	-1762(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c42:	fc99f3e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	b7c1                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x74>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c6c5                	beqz	a3,80000d14 <copyinstr+0xa8>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a035                	j	80000cbc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	0017b793          	seqz	a5,a5
    80000c9c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cba:	c8a9                	beqz	s1,80000d0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	88c080e7          	jalr	-1908(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000ccc:	c131                	beqz	a0,80000d10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cce:	41790833          	sub	a6,s2,s7
    80000cd2:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd4:	0104f363          	bgeu	s1,a6,80000cda <copyinstr+0x6e>
    80000cd8:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cda:	955e                	add	a0,a0,s7
    80000cdc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce0:	fc080be3          	beqz	a6,80000cb6 <copyinstr+0x4a>
    80000ce4:	985a                	add	a6,a6,s6
    80000ce6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce8:	41650633          	sub	a2,a0,s6
    80000cec:	14fd                	addi	s1,s1,-1
    80000cee:	9b26                	add	s6,s6,s1
    80000cf0:	00f60733          	add	a4,a2,a5
    80000cf4:	00074703          	lbu	a4,0(a4)
    80000cf8:	df49                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d02:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d04:	ff0796e3          	bne	a5,a6,80000cf0 <copyinstr+0x84>
      dst++;
    80000d08:	8b42                	mv	s6,a6
    80000d0a:	b775                	j	80000cb6 <copyinstr+0x4a>
    80000d0c:	4781                	li	a5,0
    80000d0e:	b769                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d10:	557d                	li	a0,-1
    80000d12:	b779                	j	80000ca0 <copyinstr+0x34>
  int got_null = 0;
    80000d14:	4781                	li	a5,0
  if(got_null){
    80000d16:	0017b793          	seqz	a5,a5
    80000d1a:	40f00533          	neg	a0,a5
}
    80000d1e:	8082                	ret

0000000080000d20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d20:	7139                	addi	sp,sp,-64
    80000d22:	fc06                	sd	ra,56(sp)
    80000d24:	f822                	sd	s0,48(sp)
    80000d26:	f426                	sd	s1,40(sp)
    80000d28:	f04a                	sd	s2,32(sp)
    80000d2a:	ec4e                	sd	s3,24(sp)
    80000d2c:	e852                	sd	s4,16(sp)
    80000d2e:	e456                	sd	s5,8(sp)
    80000d30:	e05a                	sd	s6,0(sp)
    80000d32:	0080                	addi	s0,sp,64
    80000d34:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	74a48493          	addi	s1,s1,1866 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3e:	8b26                	mv	s6,s1
    80000d40:	00007a97          	auipc	s5,0x7
    80000d44:	2c0a8a93          	addi	s5,s5,704 # 80008000 <etext>
    80000d48:	04000937          	lui	s2,0x4000
    80000d4c:	197d                	addi	s2,s2,-1
    80000d4e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000ea17          	auipc	s4,0xe
    80000d54:	330a0a13          	addi	s4,s4,816 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c0080e7          	jalr	960(ra) # 80000118 <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	8591                	srai	a1,a1,0x4
    80000d6a:	000ab783          	ld	a5,0(s5)
    80000d6e:	02f585b3          	mul	a1,a1,a5
    80000d72:	2585                	addiw	a1,a1,1
    80000d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d78:	4719                	li	a4,6
    80000d7a:	6685                	lui	a3,0x1
    80000d7c:	40b905b3          	sub	a1,s2,a1
    80000d80:	854e                	mv	a0,s3
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	8b0080e7          	jalr	-1872(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	17048493          	addi	s1,s1,368
    80000d8e:	fd4495e3          	bne	s1,s4,80000d58 <proc_mapstacks+0x38>
  }
}
    80000d92:	70e2                	ld	ra,56(sp)
    80000d94:	7442                	ld	s0,48(sp)
    80000d96:	74a2                	ld	s1,40(sp)
    80000d98:	7902                	ld	s2,32(sp)
    80000d9a:	69e2                	ld	s3,24(sp)
    80000d9c:	6a42                	ld	s4,16(sp)
    80000d9e:	6aa2                	ld	s5,8(sp)
    80000da0:	6b02                	ld	s6,0(sp)
    80000da2:	6121                	addi	sp,sp,64
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	efa080e7          	jalr	-262(ra) # 80005ca8 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	388080e7          	jalr	904(ra) # 80006162 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	370080e7          	jalr	880(ra) # 80006162 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	00007a17          	auipc	s4,0x7
    80000e10:	1f4a0a13          	addi	s4,s4,500 # 80008000 <etext>
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1
    80000e1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	0000e997          	auipc	s3,0xe
    80000e20:	26498993          	addi	s3,s3,612 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	33a080e7          	jalr	826(ra) # 80006162 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	8791                	srai	a5,a5,0x4
    80000e36:	000a3703          	ld	a4,0(s4)
    80000e3a:	02e787b3          	mul	a5,a5,a4
    80000e3e:	2785                	addiw	a5,a5,1
    80000e40:	00d7979b          	slliw	a5,a5,0xd
    80000e44:	40f907b3          	sub	a5,s2,a5
    80000e48:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4a:	17048493          	addi	s1,s1,368
    80000e4e:	fd349be3          	bne	s1,s3,80000e24 <procinit+0x6e>
  }
}
    80000e52:	70e2                	ld	ra,56(sp)
    80000e54:	7442                	ld	s0,48(sp)
    80000e56:	74a2                	ld	s1,40(sp)
    80000e58:	7902                	ld	s2,32(sp)
    80000e5a:	69e2                	ld	s3,24(sp)
    80000e5c:	6a42                	ld	s4,16(sp)
    80000e5e:	6aa2                	ld	s5,8(sp)
    80000e60:	6b02                	ld	s6,0(sp)
    80000e62:	6121                	addi	sp,sp,64
    80000e64:	8082                	ret

0000000080000e66 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6e:	2501                	sext.w	a0,a0
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
    80000e7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e82:	00008517          	auipc	a0,0x8
    80000e86:	1fe50513          	addi	a0,a0,510 # 80009080 <cpus>
    80000e8a:	953e                	add	a0,a0,a5
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
  push_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	30a080e7          	jalr	778(ra) # 800061a6 <push_off>
    80000ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea6:	2781                	sext.w	a5,a5
    80000ea8:	079e                	slli	a5,a5,0x7
    80000eaa:	00008717          	auipc	a4,0x8
    80000eae:	1a670713          	addi	a4,a4,422 # 80009050 <pid_lock>
    80000eb2:	97ba                	add	a5,a5,a4
    80000eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	390080e7          	jalr	912(ra) # 80006246 <pop_off>
  return p;
}
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eca:	1141                	addi	sp,sp,-16
    80000ecc:	e406                	sd	ra,8(sp)
    80000ece:	e022                	sd	s0,0(sp)
    80000ed0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	fc0080e7          	jalr	-64(ra) # 80000e92 <myproc>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	3cc080e7          	jalr	972(ra) # 800062a6 <release>

  if (first) {
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	ace7a783          	lw	a5,-1330(a5) # 800089b0 <first.1677>
    80000eea:	eb89                	bnez	a5,80000efc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	c66080e7          	jalr	-922(ra) # 80001b52 <usertrapret>
}
    80000ef4:	60a2                	ld	ra,8(sp)
    80000ef6:	6402                	ld	s0,0(sp)
    80000ef8:	0141                	addi	sp,sp,16
    80000efa:	8082                	ret
    first = 0;
    80000efc:	00008797          	auipc	a5,0x8
    80000f00:	aa07aa23          	sw	zero,-1356(a5) # 800089b0 <first.1677>
    fsinit(ROOTDEV);
    80000f04:	4505                	li	a0,1
    80000f06:	00002097          	auipc	ra,0x2
    80000f0a:	a7a080e7          	jalr	-1414(ra) # 80002980 <fsinit>
    80000f0e:	bff9                	j	80000eec <forkret+0x22>

0000000080000f10 <allocpid>:
allocpid() {
    80000f10:	1101                	addi	sp,sp,-32
    80000f12:	ec06                	sd	ra,24(sp)
    80000f14:	e822                	sd	s0,16(sp)
    80000f16:	e426                	sd	s1,8(sp)
    80000f18:	e04a                	sd	s2,0(sp)
    80000f1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1c:	00008917          	auipc	s2,0x8
    80000f20:	13490913          	addi	s2,s2,308 # 80009050 <pid_lock>
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	2cc080e7          	jalr	716(ra) # 800061f2 <acquire>
  pid = nextpid;
    80000f2e:	00008797          	auipc	a5,0x8
    80000f32:	a8678793          	addi	a5,a5,-1402 # 800089b4 <nextpid>
    80000f36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f38:	0014871b          	addiw	a4,s1,1
    80000f3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	366080e7          	jalr	870(ra) # 800062a6 <release>
}
    80000f48:	8526                	mv	a0,s1
    80000f4a:	60e2                	ld	ra,24(sp)
    80000f4c:	6442                	ld	s0,16(sp)
    80000f4e:	64a2                	ld	s1,8(sp)
    80000f50:	6902                	ld	s2,0(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <proc_pagetable>:
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
    80000f62:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	8b8080e7          	jalr	-1864(ra) # 8000081c <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6e:	c121                	beqz	a0,80000fae <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	60e080e7          	jalr	1550(ra) # 80000592 <mappages>
    80000f8c:	02054863          	bltz	a0,80000fbc <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f90:	4719                	li	a4,6
    80000f92:	05893683          	ld	a3,88(s2)
    80000f96:	6605                	lui	a2,0x1
    80000f98:	020005b7          	lui	a1,0x2000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b6                	slli	a1,a1,0xd
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5f0080e7          	jalr	1520(ra) # 80000592 <mappages>
    80000faa:	02054163          	bltz	a0,80000fcc <proc_pagetable+0x76>
}
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a58080e7          	jalr	-1448(ra) # 80000a18 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	b7d5                	j	80000fae <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	77e080e7          	jalr	1918(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	a32080e7          	jalr	-1486(ra) # 80000a18 <uvmfree>
    return 0;
    80000fee:	4481                	li	s1,0
    80000ff0:	bf7d                	j	80000fae <proc_pagetable+0x58>

0000000080000ff2 <proc_freepagetable>:
{
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
    80001000:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	040005b7          	lui	a1,0x4000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b2                	slli	a1,a1,0xc
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	74a080e7          	jalr	1866(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	020005b7          	lui	a1,0x2000
    8000101e:	15fd                	addi	a1,a1,-1
    80001020:	05b6                	slli	a1,a1,0xd
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	734080e7          	jalr	1844(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	9e8080e7          	jalr	-1560(ra) # 80000a18 <uvmfree>
}
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <freeproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001050:	6d28                	ld	a0,88(a0)
    80001052:	c509                	beqz	a0,8000105c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	fc8080e7          	jalr	-56(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000105c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001060:	68a8                	ld	a0,80(s1)
    80001062:	c511                	beqz	a0,8000106e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001064:	64ac                	ld	a1,72(s1)
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	f8c080e7          	jalr	-116(ra) # 80000ff2 <proc_freepagetable>
  p->pagetable = 0;
    8000106e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001072:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001076:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001082:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001086:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108e:	0004ac23          	sw	zero,24(s1)
}
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6105                	addi	sp,sp,32
    8000109a:	8082                	ret

000000008000109c <allocproc>:
{
    8000109c:	1101                	addi	sp,sp,-32
    8000109e:	ec06                	sd	ra,24(sp)
    800010a0:	e822                	sd	s0,16(sp)
    800010a2:	e426                	sd	s1,8(sp)
    800010a4:	e04a                	sd	s2,0(sp)
    800010a6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a8:	00008497          	auipc	s1,0x8
    800010ac:	3d848493          	addi	s1,s1,984 # 80009480 <proc>
    800010b0:	0000e917          	auipc	s2,0xe
    800010b4:	fd090913          	addi	s2,s2,-48 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010b8:	8526                	mv	a0,s1
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	138080e7          	jalr	312(ra) # 800061f2 <acquire>
    if(p->state == UNUSED) {
    800010c2:	4c9c                	lw	a5,24(s1)
    800010c4:	cf81                	beqz	a5,800010dc <allocproc+0x40>
      release(&p->lock);
    800010c6:	8526                	mv	a0,s1
    800010c8:	00005097          	auipc	ra,0x5
    800010cc:	1de080e7          	jalr	478(ra) # 800062a6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d0:	17048493          	addi	s1,s1,368
    800010d4:	ff2492e3          	bne	s1,s2,800010b8 <allocproc+0x1c>
  return 0;
    800010d8:	4481                	li	s1,0
    800010da:	a889                	j	8000112c <allocproc+0x90>
  p->pid = allocpid();
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	e34080e7          	jalr	-460(ra) # 80000f10 <allocpid>
    800010e4:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e6:	4785                	li	a5,1
    800010e8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ea:	fffff097          	auipc	ra,0xfffff
    800010ee:	02e080e7          	jalr	46(ra) # 80000118 <kalloc>
    800010f2:	892a                	mv	s2,a0
    800010f4:	eca8                	sd	a0,88(s1)
    800010f6:	c131                	beqz	a0,8000113a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00000097          	auipc	ra,0x0
    800010fe:	e5c080e7          	jalr	-420(ra) # 80000f56 <proc_pagetable>
    80001102:	892a                	mv	s2,a0
    80001104:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001106:	c531                	beqz	a0,80001152 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001108:	07000613          	li	a2,112
    8000110c:	4581                	li	a1,0
    8000110e:	06048513          	addi	a0,s1,96
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	0b0080e7          	jalr	176(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    8000111a:	00000797          	auipc	a5,0x0
    8000111e:	db078793          	addi	a5,a5,-592 # 80000eca <forkret>
    80001122:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001124:	60bc                	ld	a5,64(s1)
    80001126:	6705                	lui	a4,0x1
    80001128:	97ba                	add	a5,a5,a4
    8000112a:	f4bc                	sd	a5,104(s1)
}
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6902                	ld	s2,0(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
    freeproc(p);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	f08080e7          	jalr	-248(ra) # 80001044 <freeproc>
    release(&p->lock);
    80001144:	8526                	mv	a0,s1
    80001146:	00005097          	auipc	ra,0x5
    8000114a:	160080e7          	jalr	352(ra) # 800062a6 <release>
    return 0;
    8000114e:	84ca                	mv	s1,s2
    80001150:	bff1                	j	8000112c <allocproc+0x90>
    freeproc(p);
    80001152:	8526                	mv	a0,s1
    80001154:	00000097          	auipc	ra,0x0
    80001158:	ef0080e7          	jalr	-272(ra) # 80001044 <freeproc>
    release(&p->lock);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00005097          	auipc	ra,0x5
    80001162:	148080e7          	jalr	328(ra) # 800062a6 <release>
    return 0;
    80001166:	84ca                	mv	s1,s2
    80001168:	b7d1                	j	8000112c <allocproc+0x90>

000000008000116a <userinit>:
{
    8000116a:	1101                	addi	sp,sp,-32
    8000116c:	ec06                	sd	ra,24(sp)
    8000116e:	e822                	sd	s0,16(sp)
    80001170:	e426                	sd	s1,8(sp)
    80001172:	1000                	addi	s0,sp,32
  p = allocproc();
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f28080e7          	jalr	-216(ra) # 8000109c <allocproc>
    8000117c:	84aa                	mv	s1,a0
  initproc = p;
    8000117e:	00008797          	auipc	a5,0x8
    80001182:	e8a7b923          	sd	a0,-366(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001186:	03400613          	li	a2,52
    8000118a:	00008597          	auipc	a1,0x8
    8000118e:	83658593          	addi	a1,a1,-1994 # 800089c0 <initcode>
    80001192:	6928                	ld	a0,80(a0)
    80001194:	fffff097          	auipc	ra,0xfffff
    80001198:	6b6080e7          	jalr	1718(ra) # 8000084a <uvminit>
  p->sz = PGSIZE;
    8000119c:	6785                	lui	a5,0x1
    8000119e:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a0:	6cb8                	ld	a4,88(s1)
    800011a2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a6:	6cb8                	ld	a4,88(s1)
    800011a8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011aa:	4641                	li	a2,16
    800011ac:	00007597          	auipc	a1,0x7
    800011b0:	fd458593          	addi	a1,a1,-44 # 80008180 <etext+0x180>
    800011b4:	15848513          	addi	a0,s1,344
    800011b8:	fffff097          	auipc	ra,0xfffff
    800011bc:	15c080e7          	jalr	348(ra) # 80000314 <safestrcpy>
  p->cwd = namei("/");
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	fd050513          	addi	a0,a0,-48 # 80008190 <etext+0x190>
    800011c8:	00002097          	auipc	ra,0x2
    800011cc:	1e6080e7          	jalr	486(ra) # 800033ae <namei>
    800011d0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	00005097          	auipc	ra,0x5
    800011de:	0cc080e7          	jalr	204(ra) # 800062a6 <release>
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <growproc>:
{
    800011ec:	1101                	addi	sp,sp,-32
    800011ee:	ec06                	sd	ra,24(sp)
    800011f0:	e822                	sd	s0,16(sp)
    800011f2:	e426                	sd	s1,8(sp)
    800011f4:	e04a                	sd	s2,0(sp)
    800011f6:	1000                	addi	s0,sp,32
    800011f8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011fa:	00000097          	auipc	ra,0x0
    800011fe:	c98080e7          	jalr	-872(ra) # 80000e92 <myproc>
    80001202:	892a                	mv	s2,a0
  sz = p->sz;
    80001204:	652c                	ld	a1,72(a0)
    80001206:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000120a:	00904f63          	bgtz	s1,80001228 <growproc+0x3c>
  } else if(n < 0){
    8000120e:	0204cc63          	bltz	s1,80001246 <growproc+0x5a>
  p->sz = sz;
    80001212:	1602                	slli	a2,a2,0x20
    80001214:	9201                	srli	a2,a2,0x20
    80001216:	04c93423          	sd	a2,72(s2)
  return 0;
    8000121a:	4501                	li	a0,0
}
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	addi	sp,sp,32
    80001226:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001228:	9e25                	addw	a2,a2,s1
    8000122a:	1602                	slli	a2,a2,0x20
    8000122c:	9201                	srli	a2,a2,0x20
    8000122e:	1582                	slli	a1,a1,0x20
    80001230:	9181                	srli	a1,a1,0x20
    80001232:	6928                	ld	a0,80(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	6d0080e7          	jalr	1744(ra) # 80000904 <uvmalloc>
    8000123c:	0005061b          	sext.w	a2,a0
    80001240:	fa69                	bnez	a2,80001212 <growproc+0x26>
      return -1;
    80001242:	557d                	li	a0,-1
    80001244:	bfe1                	j	8000121c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001246:	9e25                	addw	a2,a2,s1
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	66a080e7          	jalr	1642(ra) # 800008bc <uvmdealloc>
    8000125a:	0005061b          	sext.w	a2,a0
    8000125e:	bf55                	j	80001212 <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7179                	addi	sp,sp,-48
    80001262:	f406                	sd	ra,40(sp)
    80001264:	f022                	sd	s0,32(sp)
    80001266:	ec26                	sd	s1,24(sp)
    80001268:	e84a                	sd	s2,16(sp)
    8000126a:	e44e                	sd	s3,8(sp)
    8000126c:	e052                	sd	s4,0(sp)
    8000126e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001270:	00000097          	auipc	ra,0x0
    80001274:	c22080e7          	jalr	-990(ra) # 80000e92 <myproc>
    80001278:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000127a:	00000097          	auipc	ra,0x0
    8000127e:	e22080e7          	jalr	-478(ra) # 8000109c <allocproc>
    80001282:	10050f63          	beqz	a0,800013a0 <fork+0x140>
    80001286:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001288:	04893603          	ld	a2,72(s2)
    8000128c:	692c                	ld	a1,80(a0)
    8000128e:	05093503          	ld	a0,80(s2)
    80001292:	fffff097          	auipc	ra,0xfffff
    80001296:	7be080e7          	jalr	1982(ra) # 80000a50 <uvmcopy>
    8000129a:	04054663          	bltz	a0,800012e6 <fork+0x86>
  np->sz = p->sz;
    8000129e:	04893783          	ld	a5,72(s2)
    800012a2:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012a6:	05893683          	ld	a3,88(s2)
    800012aa:	87b6                	mv	a5,a3
    800012ac:	0589b703          	ld	a4,88(s3)
    800012b0:	12068693          	addi	a3,a3,288
    800012b4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012b8:	6788                	ld	a0,8(a5)
    800012ba:	6b8c                	ld	a1,16(a5)
    800012bc:	6f90                	ld	a2,24(a5)
    800012be:	01073023          	sd	a6,0(a4)
    800012c2:	e708                	sd	a0,8(a4)
    800012c4:	eb0c                	sd	a1,16(a4)
    800012c6:	ef10                	sd	a2,24(a4)
    800012c8:	02078793          	addi	a5,a5,32
    800012cc:	02070713          	addi	a4,a4,32
    800012d0:	fed792e3          	bne	a5,a3,800012b4 <fork+0x54>
  np->trapframe->a0 = 0;
    800012d4:	0589b783          	ld	a5,88(s3)
    800012d8:	0607b823          	sd	zero,112(a5)
    800012dc:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012e0:	15000a13          	li	s4,336
    800012e4:	a03d                	j	80001312 <fork+0xb2>
    freeproc(np);
    800012e6:	854e                	mv	a0,s3
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	d5c080e7          	jalr	-676(ra) # 80001044 <freeproc>
    release(&np->lock);
    800012f0:	854e                	mv	a0,s3
    800012f2:	00005097          	auipc	ra,0x5
    800012f6:	fb4080e7          	jalr	-76(ra) # 800062a6 <release>
    return -1;
    800012fa:	5a7d                	li	s4,-1
    800012fc:	a849                	j	8000138e <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012fe:	00002097          	auipc	ra,0x2
    80001302:	746080e7          	jalr	1862(ra) # 80003a44 <filedup>
    80001306:	009987b3          	add	a5,s3,s1
    8000130a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000130c:	04a1                	addi	s1,s1,8
    8000130e:	01448763          	beq	s1,s4,8000131c <fork+0xbc>
    if(p->ofile[i])
    80001312:	009907b3          	add	a5,s2,s1
    80001316:	6388                	ld	a0,0(a5)
    80001318:	f17d                	bnez	a0,800012fe <fork+0x9e>
    8000131a:	bfcd                	j	8000130c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000131c:	15093503          	ld	a0,336(s2)
    80001320:	00002097          	auipc	ra,0x2
    80001324:	89a080e7          	jalr	-1894(ra) # 80002bba <idup>
    80001328:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000132c:	4641                	li	a2,16
    8000132e:	15890593          	addi	a1,s2,344
    80001332:	15898513          	addi	a0,s3,344
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	fde080e7          	jalr	-34(ra) # 80000314 <safestrcpy>
  pid = np->pid;
    8000133e:	0309aa03          	lw	s4,48(s3)
  np->trace_mask=p->trace_mask;
    80001342:	16892783          	lw	a5,360(s2)
    80001346:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    8000134a:	854e                	mv	a0,s3
    8000134c:	00005097          	auipc	ra,0x5
    80001350:	f5a080e7          	jalr	-166(ra) # 800062a6 <release>
  acquire(&wait_lock);
    80001354:	00008497          	auipc	s1,0x8
    80001358:	d1448493          	addi	s1,s1,-748 # 80009068 <wait_lock>
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	e94080e7          	jalr	-364(ra) # 800061f2 <acquire>
  np->parent = p;
    80001366:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000136a:	8526                	mv	a0,s1
    8000136c:	00005097          	auipc	ra,0x5
    80001370:	f3a080e7          	jalr	-198(ra) # 800062a6 <release>
  acquire(&np->lock);
    80001374:	854e                	mv	a0,s3
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	e7c080e7          	jalr	-388(ra) # 800061f2 <acquire>
  np->state = RUNNABLE;
    8000137e:	478d                	li	a5,3
    80001380:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001384:	854e                	mv	a0,s3
    80001386:	00005097          	auipc	ra,0x5
    8000138a:	f20080e7          	jalr	-224(ra) # 800062a6 <release>
}
    8000138e:	8552                	mv	a0,s4
    80001390:	70a2                	ld	ra,40(sp)
    80001392:	7402                	ld	s0,32(sp)
    80001394:	64e2                	ld	s1,24(sp)
    80001396:	6942                	ld	s2,16(sp)
    80001398:	69a2                	ld	s3,8(sp)
    8000139a:	6a02                	ld	s4,0(sp)
    8000139c:	6145                	addi	sp,sp,48
    8000139e:	8082                	ret
    return -1;
    800013a0:	5a7d                	li	s4,-1
    800013a2:	b7f5                	j	8000138e <fork+0x12e>

00000000800013a4 <scheduler>:
{
    800013a4:	7139                	addi	sp,sp,-64
    800013a6:	fc06                	sd	ra,56(sp)
    800013a8:	f822                	sd	s0,48(sp)
    800013aa:	f426                	sd	s1,40(sp)
    800013ac:	f04a                	sd	s2,32(sp)
    800013ae:	ec4e                	sd	s3,24(sp)
    800013b0:	e852                	sd	s4,16(sp)
    800013b2:	e456                	sd	s5,8(sp)
    800013b4:	e05a                	sd	s6,0(sp)
    800013b6:	0080                	addi	s0,sp,64
    800013b8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ba:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013bc:	00779a93          	slli	s5,a5,0x7
    800013c0:	00008717          	auipc	a4,0x8
    800013c4:	c9070713          	addi	a4,a4,-880 # 80009050 <pid_lock>
    800013c8:	9756                	add	a4,a4,s5
    800013ca:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ce:	00008717          	auipc	a4,0x8
    800013d2:	cba70713          	addi	a4,a4,-838 # 80009088 <cpus+0x8>
    800013d6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013d8:	498d                	li	s3,3
        p->state = RUNNING;
    800013da:	4b11                	li	s6,4
        c->proc = p;
    800013dc:	079e                	slli	a5,a5,0x7
    800013de:	00008a17          	auipc	s4,0x8
    800013e2:	c72a0a13          	addi	s4,s4,-910 # 80009050 <pid_lock>
    800013e6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	0000e917          	auipc	s2,0xe
    800013ec:	c9890913          	addi	s2,s2,-872 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013f8:	10079073          	csrw	sstatus,a5
    800013fc:	00008497          	auipc	s1,0x8
    80001400:	08448493          	addi	s1,s1,132 # 80009480 <proc>
    80001404:	a03d                	j	80001432 <scheduler+0x8e>
        p->state = RUNNING;
    80001406:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000140a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000140e:	06048593          	addi	a1,s1,96
    80001412:	8556                	mv	a0,s5
    80001414:	00000097          	auipc	ra,0x0
    80001418:	694080e7          	jalr	1684(ra) # 80001aa8 <swtch>
        c->proc = 0;
    8000141c:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	e84080e7          	jalr	-380(ra) # 800062a6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	17048493          	addi	s1,s1,368
    8000142e:	fd2481e3          	beq	s1,s2,800013f0 <scheduler+0x4c>
      acquire(&p->lock);
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	dbe080e7          	jalr	-578(ra) # 800061f2 <acquire>
      if(p->state == RUNNABLE) {
    8000143c:	4c9c                	lw	a5,24(s1)
    8000143e:	ff3791e3          	bne	a5,s3,80001420 <scheduler+0x7c>
    80001442:	b7d1                	j	80001406 <scheduler+0x62>

0000000080001444 <sched>:
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001452:	00000097          	auipc	ra,0x0
    80001456:	a40080e7          	jalr	-1472(ra) # 80000e92 <myproc>
    8000145a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	d1c080e7          	jalr	-740(ra) # 80006178 <holding>
    80001464:	c93d                	beqz	a0,800014da <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001468:	2781                	sext.w	a5,a5
    8000146a:	079e                	slli	a5,a5,0x7
    8000146c:	00008717          	auipc	a4,0x8
    80001470:	be470713          	addi	a4,a4,-1052 # 80009050 <pid_lock>
    80001474:	97ba                	add	a5,a5,a4
    80001476:	0a87a703          	lw	a4,168(a5)
    8000147a:	4785                	li	a5,1
    8000147c:	06f71763          	bne	a4,a5,800014ea <sched+0xa6>
  if(p->state == RUNNING)
    80001480:	4c98                	lw	a4,24(s1)
    80001482:	4791                	li	a5,4
    80001484:	06f70b63          	beq	a4,a5,800014fa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001488:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000148c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000148e:	efb5                	bnez	a5,8000150a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001490:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001492:	00008917          	auipc	s2,0x8
    80001496:	bbe90913          	addi	s2,s2,-1090 # 80009050 <pid_lock>
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	97ca                	add	a5,a5,s2
    800014a0:	0ac7a983          	lw	s3,172(a5)
    800014a4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	00008597          	auipc	a1,0x8
    800014ae:	bde58593          	addi	a1,a1,-1058 # 80009088 <cpus+0x8>
    800014b2:	95be                	add	a1,a1,a5
    800014b4:	06048513          	addi	a0,s1,96
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	5f0080e7          	jalr	1520(ra) # 80001aa8 <swtch>
    800014c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c2:	2781                	sext.w	a5,a5
    800014c4:	079e                	slli	a5,a5,0x7
    800014c6:	97ca                	add	a5,a5,s2
    800014c8:	0b37a623          	sw	s3,172(a5)
}
    800014cc:	70a2                	ld	ra,40(sp)
    800014ce:	7402                	ld	s0,32(sp)
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	6145                	addi	sp,sp,48
    800014d8:	8082                	ret
    panic("sched p->lock");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cbe50513          	addi	a0,a0,-834 # 80008198 <etext+0x198>
    800014e2:	00004097          	auipc	ra,0x4
    800014e6:	7c6080e7          	jalr	1990(ra) # 80005ca8 <panic>
    panic("sched locks");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cbe50513          	addi	a0,a0,-834 # 800081a8 <etext+0x1a8>
    800014f2:	00004097          	auipc	ra,0x4
    800014f6:	7b6080e7          	jalr	1974(ra) # 80005ca8 <panic>
    panic("sched running");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cbe50513          	addi	a0,a0,-834 # 800081b8 <etext+0x1b8>
    80001502:	00004097          	auipc	ra,0x4
    80001506:	7a6080e7          	jalr	1958(ra) # 80005ca8 <panic>
    panic("sched interruptible");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	cbe50513          	addi	a0,a0,-834 # 800081c8 <etext+0x1c8>
    80001512:	00004097          	auipc	ra,0x4
    80001516:	796080e7          	jalr	1942(ra) # 80005ca8 <panic>

000000008000151a <yield>:
{
    8000151a:	1101                	addi	sp,sp,-32
    8000151c:	ec06                	sd	ra,24(sp)
    8000151e:	e822                	sd	s0,16(sp)
    80001520:	e426                	sd	s1,8(sp)
    80001522:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	96e080e7          	jalr	-1682(ra) # 80000e92 <myproc>
    8000152c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	cc4080e7          	jalr	-828(ra) # 800061f2 <acquire>
  p->state = RUNNABLE;
    80001536:	478d                	li	a5,3
    80001538:	cc9c                	sw	a5,24(s1)
  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	f0a080e7          	jalr	-246(ra) # 80001444 <sched>
  release(&p->lock);
    80001542:	8526                	mv	a0,s1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	d62080e7          	jalr	-670(ra) # 800062a6 <release>
}
    8000154c:	60e2                	ld	ra,24(sp)
    8000154e:	6442                	ld	s0,16(sp)
    80001550:	64a2                	ld	s1,8(sp)
    80001552:	6105                	addi	sp,sp,32
    80001554:	8082                	ret

0000000080001556 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	1800                	addi	s0,sp,48
    80001564:	89aa                	mv	s3,a0
    80001566:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001568:	00000097          	auipc	ra,0x0
    8000156c:	92a080e7          	jalr	-1750(ra) # 80000e92 <myproc>
    80001570:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	c80080e7          	jalr	-896(ra) # 800061f2 <acquire>
  release(lk);
    8000157a:	854a                	mv	a0,s2
    8000157c:	00005097          	auipc	ra,0x5
    80001580:	d2a080e7          	jalr	-726(ra) # 800062a6 <release>

  // Go to sleep.
  p->chan = chan;
    80001584:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001588:	4789                	li	a5,2
    8000158a:	cc9c                	sw	a5,24(s1)

  sched();
    8000158c:	00000097          	auipc	ra,0x0
    80001590:	eb8080e7          	jalr	-328(ra) # 80001444 <sched>

  // Tidy up.
  p->chan = 0;
    80001594:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	d0c080e7          	jalr	-756(ra) # 800062a6 <release>
  acquire(lk);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	c4e080e7          	jalr	-946(ra) # 800061f2 <acquire>
}
    800015ac:	70a2                	ld	ra,40(sp)
    800015ae:	7402                	ld	s0,32(sp)
    800015b0:	64e2                	ld	s1,24(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	69a2                	ld	s3,8(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret

00000000800015ba <wait>:
{
    800015ba:	715d                	addi	sp,sp,-80
    800015bc:	e486                	sd	ra,72(sp)
    800015be:	e0a2                	sd	s0,64(sp)
    800015c0:	fc26                	sd	s1,56(sp)
    800015c2:	f84a                	sd	s2,48(sp)
    800015c4:	f44e                	sd	s3,40(sp)
    800015c6:	f052                	sd	s4,32(sp)
    800015c8:	ec56                	sd	s5,24(sp)
    800015ca:	e85a                	sd	s6,16(sp)
    800015cc:	e45e                	sd	s7,8(sp)
    800015ce:	e062                	sd	s8,0(sp)
    800015d0:	0880                	addi	s0,sp,80
    800015d2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	8be080e7          	jalr	-1858(ra) # 80000e92 <myproc>
    800015dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015de:	00008517          	auipc	a0,0x8
    800015e2:	a8a50513          	addi	a0,a0,-1398 # 80009068 <wait_lock>
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	c0c080e7          	jalr	-1012(ra) # 800061f2 <acquire>
    havekids = 0;
    800015ee:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f0:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015f2:	0000e997          	auipc	s3,0xe
    800015f6:	a8e98993          	addi	s3,s3,-1394 # 8000f080 <tickslock>
        havekids = 1;
    800015fa:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015fc:	00008c17          	auipc	s8,0x8
    80001600:	a6cc0c13          	addi	s8,s8,-1428 # 80009068 <wait_lock>
    havekids = 0;
    80001604:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001606:	00008497          	auipc	s1,0x8
    8000160a:	e7a48493          	addi	s1,s1,-390 # 80009480 <proc>
    8000160e:	a0bd                	j	8000167c <wait+0xc2>
          pid = np->pid;
    80001610:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001614:	000b0e63          	beqz	s6,80001630 <wait+0x76>
    80001618:	4691                	li	a3,4
    8000161a:	02c48613          	addi	a2,s1,44
    8000161e:	85da                	mv	a1,s6
    80001620:	05093503          	ld	a0,80(s2)
    80001624:	fffff097          	auipc	ra,0xfffff
    80001628:	530080e7          	jalr	1328(ra) # 80000b54 <copyout>
    8000162c:	02054563          	bltz	a0,80001656 <wait+0x9c>
          freeproc(np);
    80001630:	8526                	mv	a0,s1
    80001632:	00000097          	auipc	ra,0x0
    80001636:	a12080e7          	jalr	-1518(ra) # 80001044 <freeproc>
          release(&np->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	c6a080e7          	jalr	-918(ra) # 800062a6 <release>
          release(&wait_lock);
    80001644:	00008517          	auipc	a0,0x8
    80001648:	a2450513          	addi	a0,a0,-1500 # 80009068 <wait_lock>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	c5a080e7          	jalr	-934(ra) # 800062a6 <release>
          return pid;
    80001654:	a09d                	j	800016ba <wait+0x100>
            release(&np->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	c4e080e7          	jalr	-946(ra) # 800062a6 <release>
            release(&wait_lock);
    80001660:	00008517          	auipc	a0,0x8
    80001664:	a0850513          	addi	a0,a0,-1528 # 80009068 <wait_lock>
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	c3e080e7          	jalr	-962(ra) # 800062a6 <release>
            return -1;
    80001670:	59fd                	li	s3,-1
    80001672:	a0a1                	j	800016ba <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001674:	17048493          	addi	s1,s1,368
    80001678:	03348463          	beq	s1,s3,800016a0 <wait+0xe6>
      if(np->parent == p){
    8000167c:	7c9c                	ld	a5,56(s1)
    8000167e:	ff279be3          	bne	a5,s2,80001674 <wait+0xba>
        acquire(&np->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	00005097          	auipc	ra,0x5
    80001688:	b6e080e7          	jalr	-1170(ra) # 800061f2 <acquire>
        if(np->state == ZOMBIE){
    8000168c:	4c9c                	lw	a5,24(s1)
    8000168e:	f94781e3          	beq	a5,s4,80001610 <wait+0x56>
        release(&np->lock);
    80001692:	8526                	mv	a0,s1
    80001694:	00005097          	auipc	ra,0x5
    80001698:	c12080e7          	jalr	-1006(ra) # 800062a6 <release>
        havekids = 1;
    8000169c:	8756                	mv	a4,s5
    8000169e:	bfd9                	j	80001674 <wait+0xba>
    if(!havekids || p->killed){
    800016a0:	c701                	beqz	a4,800016a8 <wait+0xee>
    800016a2:	02892783          	lw	a5,40(s2)
    800016a6:	c79d                	beqz	a5,800016d4 <wait+0x11a>
      release(&wait_lock);
    800016a8:	00008517          	auipc	a0,0x8
    800016ac:	9c050513          	addi	a0,a0,-1600 # 80009068 <wait_lock>
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	bf6080e7          	jalr	-1034(ra) # 800062a6 <release>
      return -1;
    800016b8:	59fd                	li	s3,-1
}
    800016ba:	854e                	mv	a0,s3
    800016bc:	60a6                	ld	ra,72(sp)
    800016be:	6406                	ld	s0,64(sp)
    800016c0:	74e2                	ld	s1,56(sp)
    800016c2:	7942                	ld	s2,48(sp)
    800016c4:	79a2                	ld	s3,40(sp)
    800016c6:	7a02                	ld	s4,32(sp)
    800016c8:	6ae2                	ld	s5,24(sp)
    800016ca:	6b42                	ld	s6,16(sp)
    800016cc:	6ba2                	ld	s7,8(sp)
    800016ce:	6c02                	ld	s8,0(sp)
    800016d0:	6161                	addi	sp,sp,80
    800016d2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d4:	85e2                	mv	a1,s8
    800016d6:	854a                	mv	a0,s2
    800016d8:	00000097          	auipc	ra,0x0
    800016dc:	e7e080e7          	jalr	-386(ra) # 80001556 <sleep>
    havekids = 0;
    800016e0:	b715                	j	80001604 <wait+0x4a>

00000000800016e2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e2:	7139                	addi	sp,sp,-64
    800016e4:	fc06                	sd	ra,56(sp)
    800016e6:	f822                	sd	s0,48(sp)
    800016e8:	f426                	sd	s1,40(sp)
    800016ea:	f04a                	sd	s2,32(sp)
    800016ec:	ec4e                	sd	s3,24(sp)
    800016ee:	e852                	sd	s4,16(sp)
    800016f0:	e456                	sd	s5,8(sp)
    800016f2:	0080                	addi	s0,sp,64
    800016f4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016f6:	00008497          	auipc	s1,0x8
    800016fa:	d8a48493          	addi	s1,s1,-630 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016fe:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001700:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	0000e917          	auipc	s2,0xe
    80001706:	97e90913          	addi	s2,s2,-1666 # 8000f080 <tickslock>
    8000170a:	a821                	j	80001722 <wakeup+0x40>
        p->state = RUNNABLE;
    8000170c:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b94080e7          	jalr	-1132(ra) # 800062a6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	17048493          	addi	s1,s1,368
    8000171e:	03248463          	beq	s1,s2,80001746 <wakeup+0x64>
    if(p != myproc()){
    80001722:	fffff097          	auipc	ra,0xfffff
    80001726:	770080e7          	jalr	1904(ra) # 80000e92 <myproc>
    8000172a:	fea488e3          	beq	s1,a0,8000171a <wakeup+0x38>
      acquire(&p->lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	ac2080e7          	jalr	-1342(ra) # 800061f2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001738:	4c9c                	lw	a5,24(s1)
    8000173a:	fd379be3          	bne	a5,s3,80001710 <wakeup+0x2e>
    8000173e:	709c                	ld	a5,32(s1)
    80001740:	fd4798e3          	bne	a5,s4,80001710 <wakeup+0x2e>
    80001744:	b7e1                	j	8000170c <wakeup+0x2a>
    }
  }
}
    80001746:	70e2                	ld	ra,56(sp)
    80001748:	7442                	ld	s0,48(sp)
    8000174a:	74a2                	ld	s1,40(sp)
    8000174c:	7902                	ld	s2,32(sp)
    8000174e:	69e2                	ld	s3,24(sp)
    80001750:	6a42                	ld	s4,16(sp)
    80001752:	6aa2                	ld	s5,8(sp)
    80001754:	6121                	addi	sp,sp,64
    80001756:	8082                	ret

0000000080001758 <reparent>:
{
    80001758:	7179                	addi	sp,sp,-48
    8000175a:	f406                	sd	ra,40(sp)
    8000175c:	f022                	sd	s0,32(sp)
    8000175e:	ec26                	sd	s1,24(sp)
    80001760:	e84a                	sd	s2,16(sp)
    80001762:	e44e                	sd	s3,8(sp)
    80001764:	e052                	sd	s4,0(sp)
    80001766:	1800                	addi	s0,sp,48
    80001768:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176a:	00008497          	auipc	s1,0x8
    8000176e:	d1648493          	addi	s1,s1,-746 # 80009480 <proc>
      pp->parent = initproc;
    80001772:	00008a17          	auipc	s4,0x8
    80001776:	89ea0a13          	addi	s4,s4,-1890 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177a:	0000e997          	auipc	s3,0xe
    8000177e:	90698993          	addi	s3,s3,-1786 # 8000f080 <tickslock>
    80001782:	a029                	j	8000178c <reparent+0x34>
    80001784:	17048493          	addi	s1,s1,368
    80001788:	01348d63          	beq	s1,s3,800017a2 <reparent+0x4a>
    if(pp->parent == p){
    8000178c:	7c9c                	ld	a5,56(s1)
    8000178e:	ff279be3          	bne	a5,s2,80001784 <reparent+0x2c>
      pp->parent = initproc;
    80001792:	000a3503          	ld	a0,0(s4)
    80001796:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	f4a080e7          	jalr	-182(ra) # 800016e2 <wakeup>
    800017a0:	b7d5                	j	80001784 <reparent+0x2c>
}
    800017a2:	70a2                	ld	ra,40(sp)
    800017a4:	7402                	ld	s0,32(sp)
    800017a6:	64e2                	ld	s1,24(sp)
    800017a8:	6942                	ld	s2,16(sp)
    800017aa:	69a2                	ld	s3,8(sp)
    800017ac:	6a02                	ld	s4,0(sp)
    800017ae:	6145                	addi	sp,sp,48
    800017b0:	8082                	ret

00000000800017b2 <exit>:
{
    800017b2:	7179                	addi	sp,sp,-48
    800017b4:	f406                	sd	ra,40(sp)
    800017b6:	f022                	sd	s0,32(sp)
    800017b8:	ec26                	sd	s1,24(sp)
    800017ba:	e84a                	sd	s2,16(sp)
    800017bc:	e44e                	sd	s3,8(sp)
    800017be:	e052                	sd	s4,0(sp)
    800017c0:	1800                	addi	s0,sp,48
    800017c2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c4:	fffff097          	auipc	ra,0xfffff
    800017c8:	6ce080e7          	jalr	1742(ra) # 80000e92 <myproc>
    800017cc:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ce:	00008797          	auipc	a5,0x8
    800017d2:	8427b783          	ld	a5,-1982(a5) # 80009010 <initproc>
    800017d6:	0d050493          	addi	s1,a0,208
    800017da:	15050913          	addi	s2,a0,336
    800017de:	02a79363          	bne	a5,a0,80001804 <exit+0x52>
    panic("init exiting");
    800017e2:	00007517          	auipc	a0,0x7
    800017e6:	9fe50513          	addi	a0,a0,-1538 # 800081e0 <etext+0x1e0>
    800017ea:	00004097          	auipc	ra,0x4
    800017ee:	4be080e7          	jalr	1214(ra) # 80005ca8 <panic>
      fileclose(f);
    800017f2:	00002097          	auipc	ra,0x2
    800017f6:	2a4080e7          	jalr	676(ra) # 80003a96 <fileclose>
      p->ofile[fd] = 0;
    800017fa:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017fe:	04a1                	addi	s1,s1,8
    80001800:	01248563          	beq	s1,s2,8000180a <exit+0x58>
    if(p->ofile[fd]){
    80001804:	6088                	ld	a0,0(s1)
    80001806:	f575                	bnez	a0,800017f2 <exit+0x40>
    80001808:	bfdd                	j	800017fe <exit+0x4c>
  begin_op();
    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	dc0080e7          	jalr	-576(ra) # 800035ca <begin_op>
  iput(p->cwd);
    80001812:	1509b503          	ld	a0,336(s3)
    80001816:	00001097          	auipc	ra,0x1
    8000181a:	59c080e7          	jalr	1436(ra) # 80002db2 <iput>
  end_op();
    8000181e:	00002097          	auipc	ra,0x2
    80001822:	e2c080e7          	jalr	-468(ra) # 8000364a <end_op>
  p->cwd = 0;
    80001826:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182a:	00008497          	auipc	s1,0x8
    8000182e:	83e48493          	addi	s1,s1,-1986 # 80009068 <wait_lock>
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	9be080e7          	jalr	-1602(ra) # 800061f2 <acquire>
  reparent(p);
    8000183c:	854e                	mv	a0,s3
    8000183e:	00000097          	auipc	ra,0x0
    80001842:	f1a080e7          	jalr	-230(ra) # 80001758 <reparent>
  wakeup(p->parent);
    80001846:	0389b503          	ld	a0,56(s3)
    8000184a:	00000097          	auipc	ra,0x0
    8000184e:	e98080e7          	jalr	-360(ra) # 800016e2 <wakeup>
  acquire(&p->lock);
    80001852:	854e                	mv	a0,s3
    80001854:	00005097          	auipc	ra,0x5
    80001858:	99e080e7          	jalr	-1634(ra) # 800061f2 <acquire>
  p->xstate = status;
    8000185c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001860:	4795                	li	a5,5
    80001862:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	a3e080e7          	jalr	-1474(ra) # 800062a6 <release>
  sched();
    80001870:	00000097          	auipc	ra,0x0
    80001874:	bd4080e7          	jalr	-1068(ra) # 80001444 <sched>
  panic("zombie exit");
    80001878:	00007517          	auipc	a0,0x7
    8000187c:	97850513          	addi	a0,a0,-1672 # 800081f0 <etext+0x1f0>
    80001880:	00004097          	auipc	ra,0x4
    80001884:	428080e7          	jalr	1064(ra) # 80005ca8 <panic>

0000000080001888 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001888:	7179                	addi	sp,sp,-48
    8000188a:	f406                	sd	ra,40(sp)
    8000188c:	f022                	sd	s0,32(sp)
    8000188e:	ec26                	sd	s1,24(sp)
    80001890:	e84a                	sd	s2,16(sp)
    80001892:	e44e                	sd	s3,8(sp)
    80001894:	1800                	addi	s0,sp,48
    80001896:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001898:	00008497          	auipc	s1,0x8
    8000189c:	be848493          	addi	s1,s1,-1048 # 80009480 <proc>
    800018a0:	0000d997          	auipc	s3,0xd
    800018a4:	7e098993          	addi	s3,s3,2016 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	948080e7          	jalr	-1720(ra) # 800061f2 <acquire>
    if(p->pid == pid){
    800018b2:	589c                	lw	a5,48(s1)
    800018b4:	01278d63          	beq	a5,s2,800018ce <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	9ec080e7          	jalr	-1556(ra) # 800062a6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c2:	17048493          	addi	s1,s1,368
    800018c6:	ff3491e3          	bne	s1,s3,800018a8 <kill+0x20>
  }
  return -1;
    800018ca:	557d                	li	a0,-1
    800018cc:	a829                	j	800018e6 <kill+0x5e>
      p->killed = 1;
    800018ce:	4785                	li	a5,1
    800018d0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d2:	4c98                	lw	a4,24(s1)
    800018d4:	4789                	li	a5,2
    800018d6:	00f70f63          	beq	a4,a5,800018f4 <kill+0x6c>
      release(&p->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	9ca080e7          	jalr	-1590(ra) # 800062a6 <release>
      return 0;
    800018e4:	4501                	li	a0,0
}
    800018e6:	70a2                	ld	ra,40(sp)
    800018e8:	7402                	ld	s0,32(sp)
    800018ea:	64e2                	ld	s1,24(sp)
    800018ec:	6942                	ld	s2,16(sp)
    800018ee:	69a2                	ld	s3,8(sp)
    800018f0:	6145                	addi	sp,sp,48
    800018f2:	8082                	ret
        p->state = RUNNABLE;
    800018f4:	478d                	li	a5,3
    800018f6:	cc9c                	sw	a5,24(s1)
    800018f8:	b7cd                	j	800018da <kill+0x52>

00000000800018fa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fa:	7179                	addi	sp,sp,-48
    800018fc:	f406                	sd	ra,40(sp)
    800018fe:	f022                	sd	s0,32(sp)
    80001900:	ec26                	sd	s1,24(sp)
    80001902:	e84a                	sd	s2,16(sp)
    80001904:	e44e                	sd	s3,8(sp)
    80001906:	e052                	sd	s4,0(sp)
    80001908:	1800                	addi	s0,sp,48
    8000190a:	84aa                	mv	s1,a0
    8000190c:	892e                	mv	s2,a1
    8000190e:	89b2                	mv	s3,a2
    80001910:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001912:	fffff097          	auipc	ra,0xfffff
    80001916:	580080e7          	jalr	1408(ra) # 80000e92 <myproc>
  if(user_dst){
    8000191a:	c08d                	beqz	s1,8000193c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000191c:	86d2                	mv	a3,s4
    8000191e:	864e                	mv	a2,s3
    80001920:	85ca                	mv	a1,s2
    80001922:	6928                	ld	a0,80(a0)
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	230080e7          	jalr	560(ra) # 80000b54 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000192c:	70a2                	ld	ra,40(sp)
    8000192e:	7402                	ld	s0,32(sp)
    80001930:	64e2                	ld	s1,24(sp)
    80001932:	6942                	ld	s2,16(sp)
    80001934:	69a2                	ld	s3,8(sp)
    80001936:	6a02                	ld	s4,0(sp)
    80001938:	6145                	addi	sp,sp,48
    8000193a:	8082                	ret
    memmove((char *)dst, src, len);
    8000193c:	000a061b          	sext.w	a2,s4
    80001940:	85ce                	mv	a1,s3
    80001942:	854a                	mv	a0,s2
    80001944:	fffff097          	auipc	ra,0xfffff
    80001948:	8de080e7          	jalr	-1826(ra) # 80000222 <memmove>
    return 0;
    8000194c:	8526                	mv	a0,s1
    8000194e:	bff9                	j	8000192c <either_copyout+0x32>

0000000080001950 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001950:	7179                	addi	sp,sp,-48
    80001952:	f406                	sd	ra,40(sp)
    80001954:	f022                	sd	s0,32(sp)
    80001956:	ec26                	sd	s1,24(sp)
    80001958:	e84a                	sd	s2,16(sp)
    8000195a:	e44e                	sd	s3,8(sp)
    8000195c:	e052                	sd	s4,0(sp)
    8000195e:	1800                	addi	s0,sp,48
    80001960:	892a                	mv	s2,a0
    80001962:	84ae                	mv	s1,a1
    80001964:	89b2                	mv	s3,a2
    80001966:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001968:	fffff097          	auipc	ra,0xfffff
    8000196c:	52a080e7          	jalr	1322(ra) # 80000e92 <myproc>
  if(user_src){
    80001970:	c08d                	beqz	s1,80001992 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001972:	86d2                	mv	a3,s4
    80001974:	864e                	mv	a2,s3
    80001976:	85ca                	mv	a1,s2
    80001978:	6928                	ld	a0,80(a0)
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	266080e7          	jalr	614(ra) # 80000be0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6a02                	ld	s4,0(sp)
    8000198e:	6145                	addi	sp,sp,48
    80001990:	8082                	ret
    memmove(dst, (char*)src, len);
    80001992:	000a061b          	sext.w	a2,s4
    80001996:	85ce                	mv	a1,s3
    80001998:	854a                	mv	a0,s2
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	888080e7          	jalr	-1912(ra) # 80000222 <memmove>
    return 0;
    800019a2:	8526                	mv	a0,s1
    800019a4:	bff9                	j	80001982 <either_copyin+0x32>

00000000800019a6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019a6:	715d                	addi	sp,sp,-80
    800019a8:	e486                	sd	ra,72(sp)
    800019aa:	e0a2                	sd	s0,64(sp)
    800019ac:	fc26                	sd	s1,56(sp)
    800019ae:	f84a                	sd	s2,48(sp)
    800019b0:	f44e                	sd	s3,40(sp)
    800019b2:	f052                	sd	s4,32(sp)
    800019b4:	ec56                	sd	s5,24(sp)
    800019b6:	e85a                	sd	s6,16(sp)
    800019b8:	e45e                	sd	s7,8(sp)
    800019ba:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019bc:	00006517          	auipc	a0,0x6
    800019c0:	68c50513          	addi	a0,a0,1676 # 80008048 <etext+0x48>
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	32e080e7          	jalr	814(ra) # 80005cf2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019cc:	00008497          	auipc	s1,0x8
    800019d0:	c0c48493          	addi	s1,s1,-1012 # 800095d8 <proc+0x158>
    800019d4:	0000e917          	auipc	s2,0xe
    800019d8:	80490913          	addi	s2,s2,-2044 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019de:	00007997          	auipc	s3,0x7
    800019e2:	82298993          	addi	s3,s3,-2014 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019e6:	00007a97          	auipc	s5,0x7
    800019ea:	822a8a93          	addi	s5,s5,-2014 # 80008208 <etext+0x208>
    printf("\n");
    800019ee:	00006a17          	auipc	s4,0x6
    800019f2:	65aa0a13          	addi	s4,s4,1626 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f6:	00007b97          	auipc	s7,0x7
    800019fa:	84ab8b93          	addi	s7,s7,-1974 # 80008240 <states.1714>
    800019fe:	a00d                	j	80001a20 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a00:	ed86a583          	lw	a1,-296(a3)
    80001a04:	8556                	mv	a0,s5
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	2ec080e7          	jalr	748(ra) # 80005cf2 <printf>
    printf("\n");
    80001a0e:	8552                	mv	a0,s4
    80001a10:	00004097          	auipc	ra,0x4
    80001a14:	2e2080e7          	jalr	738(ra) # 80005cf2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a18:	17048493          	addi	s1,s1,368
    80001a1c:	03248163          	beq	s1,s2,80001a3e <procdump+0x98>
    if(p->state == UNUSED)
    80001a20:	86a6                	mv	a3,s1
    80001a22:	ec04a783          	lw	a5,-320(s1)
    80001a26:	dbed                	beqz	a5,80001a18 <procdump+0x72>
      state = "???";
    80001a28:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2a:	fcfb6be3          	bltu	s6,a5,80001a00 <procdump+0x5a>
    80001a2e:	1782                	slli	a5,a5,0x20
    80001a30:	9381                	srli	a5,a5,0x20
    80001a32:	078e                	slli	a5,a5,0x3
    80001a34:	97de                	add	a5,a5,s7
    80001a36:	6390                	ld	a2,0(a5)
    80001a38:	f661                	bnez	a2,80001a00 <procdump+0x5a>
      state = "???";
    80001a3a:	864e                	mv	a2,s3
    80001a3c:	b7d1                	j	80001a00 <procdump+0x5a>
  }
}
    80001a3e:	60a6                	ld	ra,72(sp)
    80001a40:	6406                	ld	s0,64(sp)
    80001a42:	74e2                	ld	s1,56(sp)
    80001a44:	7942                	ld	s2,48(sp)
    80001a46:	79a2                	ld	s3,40(sp)
    80001a48:	7a02                	ld	s4,32(sp)
    80001a4a:	6ae2                	ld	s5,24(sp)
    80001a4c:	6b42                	ld	s6,16(sp)
    80001a4e:	6ba2                	ld	s7,8(sp)
    80001a50:	6161                	addi	sp,sp,80
    80001a52:	8082                	ret

0000000080001a54 <nproc>:


uint64 nproc(void){
    80001a54:	7179                	addi	sp,sp,-48
    80001a56:	f406                	sd	ra,40(sp)
    80001a58:	f022                	sd	s0,32(sp)
    80001a5a:	ec26                	sd	s1,24(sp)
    80001a5c:	e84a                	sd	s2,16(sp)
    80001a5e:	e44e                	sd	s3,8(sp)
    80001a60:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 num = 0;
    80001a62:	4901                	li	s2,0
  for(p = proc; p<&proc[NPROC];p++){
    80001a64:	00008497          	auipc	s1,0x8
    80001a68:	a1c48493          	addi	s1,s1,-1508 # 80009480 <proc>
    80001a6c:	0000d997          	auipc	s3,0xd
    80001a70:	61498993          	addi	s3,s3,1556 # 8000f080 <tickslock>
  acquire(&p->lock);
    80001a74:	8526                	mv	a0,s1
    80001a76:	00004097          	auipc	ra,0x4
    80001a7a:	77c080e7          	jalr	1916(ra) # 800061f2 <acquire>
    if(p->state != UNUSED){
    80001a7e:	4c9c                	lw	a5,24(s1)
      num++;
    80001a80:	00f037b3          	snez	a5,a5
    80001a84:	993e                	add	s2,s2,a5
    }
    release(&p->lock);
    80001a86:	8526                	mv	a0,s1
    80001a88:	00005097          	auipc	ra,0x5
    80001a8c:	81e080e7          	jalr	-2018(ra) # 800062a6 <release>
  for(p = proc; p<&proc[NPROC];p++){
    80001a90:	17048493          	addi	s1,s1,368
    80001a94:	ff3490e3          	bne	s1,s3,80001a74 <nproc+0x20>
  }
  return num;
}
    80001a98:	854a                	mv	a0,s2
    80001a9a:	70a2                	ld	ra,40(sp)
    80001a9c:	7402                	ld	s0,32(sp)
    80001a9e:	64e2                	ld	s1,24(sp)
    80001aa0:	6942                	ld	s2,16(sp)
    80001aa2:	69a2                	ld	s3,8(sp)
    80001aa4:	6145                	addi	sp,sp,48
    80001aa6:	8082                	ret

0000000080001aa8 <swtch>:
    80001aa8:	00153023          	sd	ra,0(a0)
    80001aac:	00253423          	sd	sp,8(a0)
    80001ab0:	e900                	sd	s0,16(a0)
    80001ab2:	ed04                	sd	s1,24(a0)
    80001ab4:	03253023          	sd	s2,32(a0)
    80001ab8:	03353423          	sd	s3,40(a0)
    80001abc:	03453823          	sd	s4,48(a0)
    80001ac0:	03553c23          	sd	s5,56(a0)
    80001ac4:	05653023          	sd	s6,64(a0)
    80001ac8:	05753423          	sd	s7,72(a0)
    80001acc:	05853823          	sd	s8,80(a0)
    80001ad0:	05953c23          	sd	s9,88(a0)
    80001ad4:	07a53023          	sd	s10,96(a0)
    80001ad8:	07b53423          	sd	s11,104(a0)
    80001adc:	0005b083          	ld	ra,0(a1)
    80001ae0:	0085b103          	ld	sp,8(a1)
    80001ae4:	6980                	ld	s0,16(a1)
    80001ae6:	6d84                	ld	s1,24(a1)
    80001ae8:	0205b903          	ld	s2,32(a1)
    80001aec:	0285b983          	ld	s3,40(a1)
    80001af0:	0305ba03          	ld	s4,48(a1)
    80001af4:	0385ba83          	ld	s5,56(a1)
    80001af8:	0405bb03          	ld	s6,64(a1)
    80001afc:	0485bb83          	ld	s7,72(a1)
    80001b00:	0505bc03          	ld	s8,80(a1)
    80001b04:	0585bc83          	ld	s9,88(a1)
    80001b08:	0605bd03          	ld	s10,96(a1)
    80001b0c:	0685bd83          	ld	s11,104(a1)
    80001b10:	8082                	ret

0000000080001b12 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b1a:	00006597          	auipc	a1,0x6
    80001b1e:	75658593          	addi	a1,a1,1878 # 80008270 <states.1714+0x30>
    80001b22:	0000d517          	auipc	a0,0xd
    80001b26:	55e50513          	addi	a0,a0,1374 # 8000f080 <tickslock>
    80001b2a:	00004097          	auipc	ra,0x4
    80001b2e:	638080e7          	jalr	1592(ra) # 80006162 <initlock>
}
    80001b32:	60a2                	ld	ra,8(sp)
    80001b34:	6402                	ld	s0,0(sp)
    80001b36:	0141                	addi	sp,sp,16
    80001b38:	8082                	ret

0000000080001b3a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e422                	sd	s0,8(sp)
    80001b3e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b40:	00003797          	auipc	a5,0x3
    80001b44:	57078793          	addi	a5,a5,1392 # 800050b0 <kernelvec>
    80001b48:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b4c:	6422                	ld	s0,8(sp)
    80001b4e:	0141                	addi	sp,sp,16
    80001b50:	8082                	ret

0000000080001b52 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b52:	1141                	addi	sp,sp,-16
    80001b54:	e406                	sd	ra,8(sp)
    80001b56:	e022                	sd	s0,0(sp)
    80001b58:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	338080e7          	jalr	824(ra) # 80000e92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b68:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b6c:	00005617          	auipc	a2,0x5
    80001b70:	49460613          	addi	a2,a2,1172 # 80007000 <_trampoline>
    80001b74:	00005697          	auipc	a3,0x5
    80001b78:	48c68693          	addi	a3,a3,1164 # 80007000 <_trampoline>
    80001b7c:	8e91                	sub	a3,a3,a2
    80001b7e:	040007b7          	lui	a5,0x4000
    80001b82:	17fd                	addi	a5,a5,-1
    80001b84:	07b2                	slli	a5,a5,0xc
    80001b86:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b88:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b8c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b8e:	180026f3          	csrr	a3,satp
    80001b92:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b94:	6d38                	ld	a4,88(a0)
    80001b96:	6134                	ld	a3,64(a0)
    80001b98:	6585                	lui	a1,0x1
    80001b9a:	96ae                	add	a3,a3,a1
    80001b9c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b9e:	6d38                	ld	a4,88(a0)
    80001ba0:	00000697          	auipc	a3,0x0
    80001ba4:	13868693          	addi	a3,a3,312 # 80001cd8 <usertrap>
    80001ba8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001baa:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bac:	8692                	mv	a3,tp
    80001bae:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bb8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bbc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bc0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc2:	6f18                	ld	a4,24(a4)
    80001bc4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bc8:	692c                	ld	a1,80(a0)
    80001bca:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bcc:	00005717          	auipc	a4,0x5
    80001bd0:	4c470713          	addi	a4,a4,1220 # 80007090 <userret>
    80001bd4:	8f11                	sub	a4,a4,a2
    80001bd6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bd8:	577d                	li	a4,-1
    80001bda:	177e                	slli	a4,a4,0x3f
    80001bdc:	8dd9                	or	a1,a1,a4
    80001bde:	02000537          	lui	a0,0x2000
    80001be2:	157d                	addi	a0,a0,-1
    80001be4:	0536                	slli	a0,a0,0xd
    80001be6:	9782                	jalr	a5
}
    80001be8:	60a2                	ld	ra,8(sp)
    80001bea:	6402                	ld	s0,0(sp)
    80001bec:	0141                	addi	sp,sp,16
    80001bee:	8082                	ret

0000000080001bf0 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bfa:	0000d497          	auipc	s1,0xd
    80001bfe:	48648493          	addi	s1,s1,1158 # 8000f080 <tickslock>
    80001c02:	8526                	mv	a0,s1
    80001c04:	00004097          	auipc	ra,0x4
    80001c08:	5ee080e7          	jalr	1518(ra) # 800061f2 <acquire>
  ticks++;
    80001c0c:	00007517          	auipc	a0,0x7
    80001c10:	40c50513          	addi	a0,a0,1036 # 80009018 <ticks>
    80001c14:	411c                	lw	a5,0(a0)
    80001c16:	2785                	addiw	a5,a5,1
    80001c18:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c1a:	00000097          	auipc	ra,0x0
    80001c1e:	ac8080e7          	jalr	-1336(ra) # 800016e2 <wakeup>
  release(&tickslock);
    80001c22:	8526                	mv	a0,s1
    80001c24:	00004097          	auipc	ra,0x4
    80001c28:	682080e7          	jalr	1666(ra) # 800062a6 <release>
}
    80001c2c:	60e2                	ld	ra,24(sp)
    80001c2e:	6442                	ld	s0,16(sp)
    80001c30:	64a2                	ld	s1,8(sp)
    80001c32:	6105                	addi	sp,sp,32
    80001c34:	8082                	ret

0000000080001c36 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c36:	1101                	addi	sp,sp,-32
    80001c38:	ec06                	sd	ra,24(sp)
    80001c3a:	e822                	sd	s0,16(sp)
    80001c3c:	e426                	sd	s1,8(sp)
    80001c3e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c40:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c44:	00074d63          	bltz	a4,80001c5e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c48:	57fd                	li	a5,-1
    80001c4a:	17fe                	slli	a5,a5,0x3f
    80001c4c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c4e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c50:	06f70363          	beq	a4,a5,80001cb6 <devintr+0x80>
  }
}
    80001c54:	60e2                	ld	ra,24(sp)
    80001c56:	6442                	ld	s0,16(sp)
    80001c58:	64a2                	ld	s1,8(sp)
    80001c5a:	6105                	addi	sp,sp,32
    80001c5c:	8082                	ret
     (scause & 0xff) == 9){
    80001c5e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c62:	46a5                	li	a3,9
    80001c64:	fed792e3          	bne	a5,a3,80001c48 <devintr+0x12>
    int irq = plic_claim();
    80001c68:	00003097          	auipc	ra,0x3
    80001c6c:	550080e7          	jalr	1360(ra) # 800051b8 <plic_claim>
    80001c70:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c72:	47a9                	li	a5,10
    80001c74:	02f50763          	beq	a0,a5,80001ca2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c78:	4785                	li	a5,1
    80001c7a:	02f50963          	beq	a0,a5,80001cac <devintr+0x76>
    return 1;
    80001c7e:	4505                	li	a0,1
    } else if(irq){
    80001c80:	d8f1                	beqz	s1,80001c54 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c82:	85a6                	mv	a1,s1
    80001c84:	00006517          	auipc	a0,0x6
    80001c88:	5f450513          	addi	a0,a0,1524 # 80008278 <states.1714+0x38>
    80001c8c:	00004097          	auipc	ra,0x4
    80001c90:	066080e7          	jalr	102(ra) # 80005cf2 <printf>
      plic_complete(irq);
    80001c94:	8526                	mv	a0,s1
    80001c96:	00003097          	auipc	ra,0x3
    80001c9a:	546080e7          	jalr	1350(ra) # 800051dc <plic_complete>
    return 1;
    80001c9e:	4505                	li	a0,1
    80001ca0:	bf55                	j	80001c54 <devintr+0x1e>
      uartintr();
    80001ca2:	00004097          	auipc	ra,0x4
    80001ca6:	470080e7          	jalr	1136(ra) # 80006112 <uartintr>
    80001caa:	b7ed                	j	80001c94 <devintr+0x5e>
      virtio_disk_intr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	a10080e7          	jalr	-1520(ra) # 800056bc <virtio_disk_intr>
    80001cb4:	b7c5                	j	80001c94 <devintr+0x5e>
    if(cpuid() == 0){
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	1b0080e7          	jalr	432(ra) # 80000e66 <cpuid>
    80001cbe:	c901                	beqz	a0,80001cce <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cc4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cc6:	14479073          	csrw	sip,a5
    return 2;
    80001cca:	4509                	li	a0,2
    80001ccc:	b761                	j	80001c54 <devintr+0x1e>
      clockintr();
    80001cce:	00000097          	auipc	ra,0x0
    80001cd2:	f22080e7          	jalr	-222(ra) # 80001bf0 <clockintr>
    80001cd6:	b7ed                	j	80001cc0 <devintr+0x8a>

0000000080001cd8 <usertrap>:
{
    80001cd8:	1101                	addi	sp,sp,-32
    80001cda:	ec06                	sd	ra,24(sp)
    80001cdc:	e822                	sd	s0,16(sp)
    80001cde:	e426                	sd	s1,8(sp)
    80001ce0:	e04a                	sd	s2,0(sp)
    80001ce2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ce8:	1007f793          	andi	a5,a5,256
    80001cec:	e3ad                	bnez	a5,80001d4e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cee:	00003797          	auipc	a5,0x3
    80001cf2:	3c278793          	addi	a5,a5,962 # 800050b0 <kernelvec>
    80001cf6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	198080e7          	jalr	408(ra) # 80000e92 <myproc>
    80001d02:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d04:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d06:	14102773          	csrr	a4,sepc
    80001d0a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d0c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d10:	47a1                	li	a5,8
    80001d12:	04f71c63          	bne	a4,a5,80001d6a <usertrap+0x92>
    if(p->killed)
    80001d16:	551c                	lw	a5,40(a0)
    80001d18:	e3b9                	bnez	a5,80001d5e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d1a:	6cb8                	ld	a4,88(s1)
    80001d1c:	6f1c                	ld	a5,24(a4)
    80001d1e:	0791                	addi	a5,a5,4
    80001d20:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d26:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2a:	10079073          	csrw	sstatus,a5
    syscall();
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	2e0080e7          	jalr	736(ra) # 8000200e <syscall>
  if(p->killed)
    80001d36:	549c                	lw	a5,40(s1)
    80001d38:	ebc1                	bnez	a5,80001dc8 <usertrap+0xf0>
  usertrapret();
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	e18080e7          	jalr	-488(ra) # 80001b52 <usertrapret>
}
    80001d42:	60e2                	ld	ra,24(sp)
    80001d44:	6442                	ld	s0,16(sp)
    80001d46:	64a2                	ld	s1,8(sp)
    80001d48:	6902                	ld	s2,0(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret
    panic("usertrap: not from user mode");
    80001d4e:	00006517          	auipc	a0,0x6
    80001d52:	54a50513          	addi	a0,a0,1354 # 80008298 <states.1714+0x58>
    80001d56:	00004097          	auipc	ra,0x4
    80001d5a:	f52080e7          	jalr	-174(ra) # 80005ca8 <panic>
      exit(-1);
    80001d5e:	557d                	li	a0,-1
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	a52080e7          	jalr	-1454(ra) # 800017b2 <exit>
    80001d68:	bf4d                	j	80001d1a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	ecc080e7          	jalr	-308(ra) # 80001c36 <devintr>
    80001d72:	892a                	mv	s2,a0
    80001d74:	c501                	beqz	a0,80001d7c <usertrap+0xa4>
  if(p->killed)
    80001d76:	549c                	lw	a5,40(s1)
    80001d78:	c3a1                	beqz	a5,80001db8 <usertrap+0xe0>
    80001d7a:	a815                	j	80001dae <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d80:	5890                	lw	a2,48(s1)
    80001d82:	00006517          	auipc	a0,0x6
    80001d86:	53650513          	addi	a0,a0,1334 # 800082b8 <states.1714+0x78>
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	f68080e7          	jalr	-152(ra) # 80005cf2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d92:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d96:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d9a:	00006517          	auipc	a0,0x6
    80001d9e:	54e50513          	addi	a0,a0,1358 # 800082e8 <states.1714+0xa8>
    80001da2:	00004097          	auipc	ra,0x4
    80001da6:	f50080e7          	jalr	-176(ra) # 80005cf2 <printf>
    p->killed = 1;
    80001daa:	4785                	li	a5,1
    80001dac:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dae:	557d                	li	a0,-1
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	a02080e7          	jalr	-1534(ra) # 800017b2 <exit>
  if(which_dev == 2)
    80001db8:	4789                	li	a5,2
    80001dba:	f8f910e3          	bne	s2,a5,80001d3a <usertrap+0x62>
    yield();
    80001dbe:	fffff097          	auipc	ra,0xfffff
    80001dc2:	75c080e7          	jalr	1884(ra) # 8000151a <yield>
    80001dc6:	bf95                	j	80001d3a <usertrap+0x62>
  int which_dev = 0;
    80001dc8:	4901                	li	s2,0
    80001dca:	b7d5                	j	80001dae <usertrap+0xd6>

0000000080001dcc <kerneltrap>:
{
    80001dcc:	7179                	addi	sp,sp,-48
    80001dce:	f406                	sd	ra,40(sp)
    80001dd0:	f022                	sd	s0,32(sp)
    80001dd2:	ec26                	sd	s1,24(sp)
    80001dd4:	e84a                	sd	s2,16(sp)
    80001dd6:	e44e                	sd	s3,8(sp)
    80001dd8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dda:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dde:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001de6:	1004f793          	andi	a5,s1,256
    80001dea:	cb85                	beqz	a5,80001e1a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001df0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001df2:	ef85                	bnez	a5,80001e2a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	e42080e7          	jalr	-446(ra) # 80001c36 <devintr>
    80001dfc:	cd1d                	beqz	a0,80001e3a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dfe:	4789                	li	a5,2
    80001e00:	06f50a63          	beq	a0,a5,80001e74 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e04:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e08:	10049073          	csrw	sstatus,s1
}
    80001e0c:	70a2                	ld	ra,40(sp)
    80001e0e:	7402                	ld	s0,32(sp)
    80001e10:	64e2                	ld	s1,24(sp)
    80001e12:	6942                	ld	s2,16(sp)
    80001e14:	69a2                	ld	s3,8(sp)
    80001e16:	6145                	addi	sp,sp,48
    80001e18:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	4ee50513          	addi	a0,a0,1262 # 80008308 <states.1714+0xc8>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	e86080e7          	jalr	-378(ra) # 80005ca8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	50650513          	addi	a0,a0,1286 # 80008330 <states.1714+0xf0>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	e76080e7          	jalr	-394(ra) # 80005ca8 <panic>
    printf("scause %p\n", scause);
    80001e3a:	85ce                	mv	a1,s3
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	51450513          	addi	a0,a0,1300 # 80008350 <states.1714+0x110>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	eae080e7          	jalr	-338(ra) # 80005cf2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e50:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e54:	00006517          	auipc	a0,0x6
    80001e58:	50c50513          	addi	a0,a0,1292 # 80008360 <states.1714+0x120>
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	e96080e7          	jalr	-362(ra) # 80005cf2 <printf>
    panic("kerneltrap");
    80001e64:	00006517          	auipc	a0,0x6
    80001e68:	51450513          	addi	a0,a0,1300 # 80008378 <states.1714+0x138>
    80001e6c:	00004097          	auipc	ra,0x4
    80001e70:	e3c080e7          	jalr	-452(ra) # 80005ca8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	01e080e7          	jalr	30(ra) # 80000e92 <myproc>
    80001e7c:	d541                	beqz	a0,80001e04 <kerneltrap+0x38>
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	014080e7          	jalr	20(ra) # 80000e92 <myproc>
    80001e86:	4d18                	lw	a4,24(a0)
    80001e88:	4791                	li	a5,4
    80001e8a:	f6f71de3          	bne	a4,a5,80001e04 <kerneltrap+0x38>
    yield();
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	68c080e7          	jalr	1676(ra) # 8000151a <yield>
    80001e96:	b7bd                	j	80001e04 <kerneltrap+0x38>

0000000080001e98 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e98:	1101                	addi	sp,sp,-32
    80001e9a:	ec06                	sd	ra,24(sp)
    80001e9c:	e822                	sd	s0,16(sp)
    80001e9e:	e426                	sd	s1,8(sp)
    80001ea0:	1000                	addi	s0,sp,32
    80001ea2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	fee080e7          	jalr	-18(ra) # 80000e92 <myproc>
  switch (n) {
    80001eac:	4795                	li	a5,5
    80001eae:	0497e163          	bltu	a5,s1,80001ef0 <argraw+0x58>
    80001eb2:	048a                	slli	s1,s1,0x2
    80001eb4:	00006717          	auipc	a4,0x6
    80001eb8:	5c470713          	addi	a4,a4,1476 # 80008478 <states.1714+0x238>
    80001ebc:	94ba                	add	s1,s1,a4
    80001ebe:	409c                	lw	a5,0(s1)
    80001ec0:	97ba                	add	a5,a5,a4
    80001ec2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ec4:	6d3c                	ld	a5,88(a0)
    80001ec6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6105                	addi	sp,sp,32
    80001ed0:	8082                	ret
    return p->trapframe->a1;
    80001ed2:	6d3c                	ld	a5,88(a0)
    80001ed4:	7fa8                	ld	a0,120(a5)
    80001ed6:	bfcd                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a2;
    80001ed8:	6d3c                	ld	a5,88(a0)
    80001eda:	63c8                	ld	a0,128(a5)
    80001edc:	b7f5                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a3;
    80001ede:	6d3c                	ld	a5,88(a0)
    80001ee0:	67c8                	ld	a0,136(a5)
    80001ee2:	b7dd                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a4;
    80001ee4:	6d3c                	ld	a5,88(a0)
    80001ee6:	6bc8                	ld	a0,144(a5)
    80001ee8:	b7c5                	j	80001ec8 <argraw+0x30>
    return p->trapframe->a5;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	6fc8                	ld	a0,152(a5)
    80001eee:	bfe9                	j	80001ec8 <argraw+0x30>
  panic("argraw");
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	49850513          	addi	a0,a0,1176 # 80008388 <states.1714+0x148>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	db0080e7          	jalr	-592(ra) # 80005ca8 <panic>

0000000080001f00 <fetchaddr>:
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	e04a                	sd	s2,0(sp)
    80001f0a:	1000                	addi	s0,sp,32
    80001f0c:	84aa                	mv	s1,a0
    80001f0e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	f82080e7          	jalr	-126(ra) # 80000e92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f18:	653c                	ld	a5,72(a0)
    80001f1a:	02f4f863          	bgeu	s1,a5,80001f4a <fetchaddr+0x4a>
    80001f1e:	00848713          	addi	a4,s1,8
    80001f22:	02e7e663          	bltu	a5,a4,80001f4e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f26:	46a1                	li	a3,8
    80001f28:	8626                	mv	a2,s1
    80001f2a:	85ca                	mv	a1,s2
    80001f2c:	6928                	ld	a0,80(a0)
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	cb2080e7          	jalr	-846(ra) # 80000be0 <copyin>
    80001f36:	00a03533          	snez	a0,a0
    80001f3a:	40a00533          	neg	a0,a0
}
    80001f3e:	60e2                	ld	ra,24(sp)
    80001f40:	6442                	ld	s0,16(sp)
    80001f42:	64a2                	ld	s1,8(sp)
    80001f44:	6902                	ld	s2,0(sp)
    80001f46:	6105                	addi	sp,sp,32
    80001f48:	8082                	ret
    return -1;
    80001f4a:	557d                	li	a0,-1
    80001f4c:	bfcd                	j	80001f3e <fetchaddr+0x3e>
    80001f4e:	557d                	li	a0,-1
    80001f50:	b7fd                	j	80001f3e <fetchaddr+0x3e>

0000000080001f52 <fetchstr>:
{
    80001f52:	7179                	addi	sp,sp,-48
    80001f54:	f406                	sd	ra,40(sp)
    80001f56:	f022                	sd	s0,32(sp)
    80001f58:	ec26                	sd	s1,24(sp)
    80001f5a:	e84a                	sd	s2,16(sp)
    80001f5c:	e44e                	sd	s3,8(sp)
    80001f5e:	1800                	addi	s0,sp,48
    80001f60:	892a                	mv	s2,a0
    80001f62:	84ae                	mv	s1,a1
    80001f64:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	f2c080e7          	jalr	-212(ra) # 80000e92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f6e:	86ce                	mv	a3,s3
    80001f70:	864a                	mv	a2,s2
    80001f72:	85a6                	mv	a1,s1
    80001f74:	6928                	ld	a0,80(a0)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	cf6080e7          	jalr	-778(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f7e:	00054763          	bltz	a0,80001f8c <fetchstr+0x3a>
  return strlen(buf);
    80001f82:	8526                	mv	a0,s1
    80001f84:	ffffe097          	auipc	ra,0xffffe
    80001f88:	3c2080e7          	jalr	962(ra) # 80000346 <strlen>
}
    80001f8c:	70a2                	ld	ra,40(sp)
    80001f8e:	7402                	ld	s0,32(sp)
    80001f90:	64e2                	ld	s1,24(sp)
    80001f92:	6942                	ld	s2,16(sp)
    80001f94:	69a2                	ld	s3,8(sp)
    80001f96:	6145                	addi	sp,sp,48
    80001f98:	8082                	ret

0000000080001f9a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	1000                	addi	s0,sp,32
    80001fa4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa6:	00000097          	auipc	ra,0x0
    80001faa:	ef2080e7          	jalr	-270(ra) # 80001e98 <argraw>
    80001fae:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fb0:	4501                	li	a0,0
    80001fb2:	60e2                	ld	ra,24(sp)
    80001fb4:	6442                	ld	s0,16(sp)
    80001fb6:	64a2                	ld	s1,8(sp)
    80001fb8:	6105                	addi	sp,sp,32
    80001fba:	8082                	ret

0000000080001fbc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fbc:	1101                	addi	sp,sp,-32
    80001fbe:	ec06                	sd	ra,24(sp)
    80001fc0:	e822                	sd	s0,16(sp)
    80001fc2:	e426                	sd	s1,8(sp)
    80001fc4:	1000                	addi	s0,sp,32
    80001fc6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	ed0080e7          	jalr	-304(ra) # 80001e98 <argraw>
    80001fd0:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fd2:	4501                	li	a0,0
    80001fd4:	60e2                	ld	ra,24(sp)
    80001fd6:	6442                	ld	s0,16(sp)
    80001fd8:	64a2                	ld	s1,8(sp)
    80001fda:	6105                	addi	sp,sp,32
    80001fdc:	8082                	ret

0000000080001fde <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	e04a                	sd	s2,0(sp)
    80001fe8:	1000                	addi	s0,sp,32
    80001fea:	84ae                	mv	s1,a1
    80001fec:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	eaa080e7          	jalr	-342(ra) # 80001e98 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001ff6:	864a                	mv	a2,s2
    80001ff8:	85a6                	mv	a1,s1
    80001ffa:	00000097          	auipc	ra,0x0
    80001ffe:	f58080e7          	jalr	-168(ra) # 80001f52 <fetchstr>
}
    80002002:	60e2                	ld	ra,24(sp)
    80002004:	6442                	ld	s0,16(sp)
    80002006:	64a2                	ld	s1,8(sp)
    80002008:	6902                	ld	s2,0(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret

000000008000200e <syscall>:

static char *syscall_name[]={"", "fork", "exit", "wait", "pipe", "read", "kill", "exec","fstat", "chdir", "dup", "getpid", "sbrk", "sleep", "uptime","open", "write", "mknod", "unlink", "link", "mkdir", "close","trace","sysinfo"};

void
syscall(void)
{
    8000200e:	7179                	addi	sp,sp,-48
    80002010:	f406                	sd	ra,40(sp)
    80002012:	f022                	sd	s0,32(sp)
    80002014:	ec26                	sd	s1,24(sp)
    80002016:	e84a                	sd	s2,16(sp)
    80002018:	e44e                	sd	s3,8(sp)
    8000201a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000201c:	fffff097          	auipc	ra,0xfffff
    80002020:	e76080e7          	jalr	-394(ra) # 80000e92 <myproc>
    80002024:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002026:	05853903          	ld	s2,88(a0)
    8000202a:	0a893783          	ld	a5,168(s2)
    8000202e:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002032:	37fd                	addiw	a5,a5,-1
    80002034:	4759                	li	a4,22
    80002036:	04f76863          	bltu	a4,a5,80002086 <syscall+0x78>
    8000203a:	00399713          	slli	a4,s3,0x3
    8000203e:	00006797          	auipc	a5,0x6
    80002042:	45278793          	addi	a5,a5,1106 # 80008490 <syscalls>
    80002046:	97ba                	add	a5,a5,a4
    80002048:	639c                	ld	a5,0(a5)
    8000204a:	cf95                	beqz	a5,80002086 <syscall+0x78>
    p->trapframe->a0 = syscalls[num]();
    8000204c:	9782                	jalr	a5
    8000204e:	06a93823          	sd	a0,112(s2)

    if(p->trace_mask & (1 << num)){
    80002052:	1684a783          	lw	a5,360(s1)
    80002056:	4137d7bb          	sraw	a5,a5,s3
    8000205a:	8b85                	andi	a5,a5,1
    8000205c:	c7a1                	beqz	a5,800020a4 <syscall+0x96>
    printf("%d: syscall %s -> %d\n",p->pid,syscall_name[num],p->trapframe->a0);
    8000205e:	6cb8                	ld	a4,88(s1)
    80002060:	098e                	slli	s3,s3,0x3
    80002062:	00006797          	auipc	a5,0x6
    80002066:	42e78793          	addi	a5,a5,1070 # 80008490 <syscalls>
    8000206a:	99be                	add	s3,s3,a5
    8000206c:	7b34                	ld	a3,112(a4)
    8000206e:	0c09b603          	ld	a2,192(s3)
    80002072:	588c                	lw	a1,48(s1)
    80002074:	00006517          	auipc	a0,0x6
    80002078:	31c50513          	addi	a0,a0,796 # 80008390 <states.1714+0x150>
    8000207c:	00004097          	auipc	ra,0x4
    80002080:	c76080e7          	jalr	-906(ra) # 80005cf2 <printf>
    80002084:	a005                	j	800020a4 <syscall+0x96>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002086:	86ce                	mv	a3,s3
    80002088:	15848613          	addi	a2,s1,344
    8000208c:	588c                	lw	a1,48(s1)
    8000208e:	00006517          	auipc	a0,0x6
    80002092:	31a50513          	addi	a0,a0,794 # 800083a8 <states.1714+0x168>
    80002096:	00004097          	auipc	ra,0x4
    8000209a:	c5c080e7          	jalr	-932(ra) # 80005cf2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000209e:	6cbc                	ld	a5,88(s1)
    800020a0:	577d                	li	a4,-1
    800020a2:	fbb8                	sd	a4,112(a5)
  }
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6942                	ld	s2,16(sp)
    800020ac:	69a2                	ld	s3,8(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret

00000000800020b2 <sys_exit>:
#include "sysinfo.h"


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
    800020c4:	eda080e7          	jalr	-294(ra) # 80001f9a <argint>
    return -1;
    800020c8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ca:	00054963          	bltz	a0,800020dc <sys_exit+0x2a>
  exit(n);
    800020ce:	fec42503          	lw	a0,-20(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	6e0080e7          	jalr	1760(ra) # 800017b2 <exit>
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
    800020f2:	da4080e7          	jalr	-604(ra) # 80000e92 <myproc>
}
    800020f6:	5908                	lw	a0,48(a0)
    800020f8:	60a2                	ld	ra,8(sp)
    800020fa:	6402                	ld	s0,0(sp)
    800020fc:	0141                	addi	sp,sp,16
    800020fe:	8082                	ret

0000000080002100 <sys_fork>:

uint64
sys_fork(void)
{
    80002100:	1141                	addi	sp,sp,-16
    80002102:	e406                	sd	ra,8(sp)
    80002104:	e022                	sd	s0,0(sp)
    80002106:	0800                	addi	s0,sp,16
  return fork();
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	158080e7          	jalr	344(ra) # 80001260 <fork>
}
    80002110:	60a2                	ld	ra,8(sp)
    80002112:	6402                	ld	s0,0(sp)
    80002114:	0141                	addi	sp,sp,16
    80002116:	8082                	ret

0000000080002118 <sys_wait>:

uint64
sys_wait(void)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002120:	fe840593          	addi	a1,s0,-24
    80002124:	4501                	li	a0,0
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	e96080e7          	jalr	-362(ra) # 80001fbc <argaddr>
    8000212e:	87aa                	mv	a5,a0
    return -1;
    80002130:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002132:	0007c863          	bltz	a5,80002142 <sys_wait+0x2a>
  return wait(p);
    80002136:	fe843503          	ld	a0,-24(s0)
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	480080e7          	jalr	1152(ra) # 800015ba <wait>
}
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000214a:	7179                	addi	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	ec26                	sd	s1,24(sp)
    80002152:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002154:	fdc40593          	addi	a1,s0,-36
    80002158:	4501                	li	a0,0
    8000215a:	00000097          	auipc	ra,0x0
    8000215e:	e40080e7          	jalr	-448(ra) # 80001f9a <argint>
    80002162:	87aa                	mv	a5,a0
    return -1;
    80002164:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002166:	0207c063          	bltz	a5,80002186 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000216a:	fffff097          	auipc	ra,0xfffff
    8000216e:	d28080e7          	jalr	-728(ra) # 80000e92 <myproc>
    80002172:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002174:	fdc42503          	lw	a0,-36(s0)
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	074080e7          	jalr	116(ra) # 800011ec <growproc>
    80002180:	00054863          	bltz	a0,80002190 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002184:	8526                	mv	a0,s1
}
    80002186:	70a2                	ld	ra,40(sp)
    80002188:	7402                	ld	s0,32(sp)
    8000218a:	64e2                	ld	s1,24(sp)
    8000218c:	6145                	addi	sp,sp,48
    8000218e:	8082                	ret
    return -1;
    80002190:	557d                	li	a0,-1
    80002192:	bfd5                	j	80002186 <sys_sbrk+0x3c>

0000000080002194 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002194:	7139                	addi	sp,sp,-64
    80002196:	fc06                	sd	ra,56(sp)
    80002198:	f822                	sd	s0,48(sp)
    8000219a:	f426                	sd	s1,40(sp)
    8000219c:	f04a                	sd	s2,32(sp)
    8000219e:	ec4e                	sd	s3,24(sp)
    800021a0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021a2:	fcc40593          	addi	a1,s0,-52
    800021a6:	4501                	li	a0,0
    800021a8:	00000097          	auipc	ra,0x0
    800021ac:	df2080e7          	jalr	-526(ra) # 80001f9a <argint>
    return -1;
    800021b0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021b2:	06054563          	bltz	a0,8000221c <sys_sleep+0x88>
  acquire(&tickslock);
    800021b6:	0000d517          	auipc	a0,0xd
    800021ba:	eca50513          	addi	a0,a0,-310 # 8000f080 <tickslock>
    800021be:	00004097          	auipc	ra,0x4
    800021c2:	034080e7          	jalr	52(ra) # 800061f2 <acquire>
  ticks0 = ticks;
    800021c6:	00007917          	auipc	s2,0x7
    800021ca:	e5292903          	lw	s2,-430(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021ce:	fcc42783          	lw	a5,-52(s0)
    800021d2:	cf85                	beqz	a5,8000220a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021d4:	0000d997          	auipc	s3,0xd
    800021d8:	eac98993          	addi	s3,s3,-340 # 8000f080 <tickslock>
    800021dc:	00007497          	auipc	s1,0x7
    800021e0:	e3c48493          	addi	s1,s1,-452 # 80009018 <ticks>
    if(myproc()->killed){
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	cae080e7          	jalr	-850(ra) # 80000e92 <myproc>
    800021ec:	551c                	lw	a5,40(a0)
    800021ee:	ef9d                	bnez	a5,8000222c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021f0:	85ce                	mv	a1,s3
    800021f2:	8526                	mv	a0,s1
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	362080e7          	jalr	866(ra) # 80001556 <sleep>
  while(ticks - ticks0 < n){
    800021fc:	409c                	lw	a5,0(s1)
    800021fe:	412787bb          	subw	a5,a5,s2
    80002202:	fcc42703          	lw	a4,-52(s0)
    80002206:	fce7efe3          	bltu	a5,a4,800021e4 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000220a:	0000d517          	auipc	a0,0xd
    8000220e:	e7650513          	addi	a0,a0,-394 # 8000f080 <tickslock>
    80002212:	00004097          	auipc	ra,0x4
    80002216:	094080e7          	jalr	148(ra) # 800062a6 <release>
  return 0;
    8000221a:	4781                	li	a5,0
}
    8000221c:	853e                	mv	a0,a5
    8000221e:	70e2                	ld	ra,56(sp)
    80002220:	7442                	ld	s0,48(sp)
    80002222:	74a2                	ld	s1,40(sp)
    80002224:	7902                	ld	s2,32(sp)
    80002226:	69e2                	ld	s3,24(sp)
    80002228:	6121                	addi	sp,sp,64
    8000222a:	8082                	ret
      release(&tickslock);
    8000222c:	0000d517          	auipc	a0,0xd
    80002230:	e5450513          	addi	a0,a0,-428 # 8000f080 <tickslock>
    80002234:	00004097          	auipc	ra,0x4
    80002238:	072080e7          	jalr	114(ra) # 800062a6 <release>
      return -1;
    8000223c:	57fd                	li	a5,-1
    8000223e:	bff9                	j	8000221c <sys_sleep+0x88>

0000000080002240 <sys_kill>:

uint64
sys_kill(void)
{
    80002240:	1101                	addi	sp,sp,-32
    80002242:	ec06                	sd	ra,24(sp)
    80002244:	e822                	sd	s0,16(sp)
    80002246:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002248:	fec40593          	addi	a1,s0,-20
    8000224c:	4501                	li	a0,0
    8000224e:	00000097          	auipc	ra,0x0
    80002252:	d4c080e7          	jalr	-692(ra) # 80001f9a <argint>
    80002256:	87aa                	mv	a5,a0
    return -1;
    80002258:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000225a:	0007c863          	bltz	a5,8000226a <sys_kill+0x2a>
  return kill(pid);
    8000225e:	fec42503          	lw	a0,-20(s0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	626080e7          	jalr	1574(ra) # 80001888 <kill>
}
    8000226a:	60e2                	ld	ra,24(sp)
    8000226c:	6442                	ld	s0,16(sp)
    8000226e:	6105                	addi	sp,sp,32
    80002270:	8082                	ret

0000000080002272 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002272:	1101                	addi	sp,sp,-32
    80002274:	ec06                	sd	ra,24(sp)
    80002276:	e822                	sd	s0,16(sp)
    80002278:	e426                	sd	s1,8(sp)
    8000227a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	e0450513          	addi	a0,a0,-508 # 8000f080 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	f6e080e7          	jalr	-146(ra) # 800061f2 <acquire>
  xticks = ticks;
    8000228c:	00007497          	auipc	s1,0x7
    80002290:	d8c4a483          	lw	s1,-628(s1) # 80009018 <ticks>
  release(&tickslock);
    80002294:	0000d517          	auipc	a0,0xd
    80002298:	dec50513          	addi	a0,a0,-532 # 8000f080 <tickslock>
    8000229c:	00004097          	auipc	ra,0x4
    800022a0:	00a080e7          	jalr	10(ra) # 800062a6 <release>
  return xticks;
}
    800022a4:	02049513          	slli	a0,s1,0x20
    800022a8:	9101                	srli	a0,a0,0x20
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	64a2                	ld	s1,8(sp)
    800022b0:	6105                	addi	sp,sp,32
    800022b2:	8082                	ret

00000000800022b4 <sys_trace>:

uint64 sys_trace(void) {
    800022b4:	7179                	addi	sp,sp,-48
    800022b6:	f406                	sd	ra,40(sp)
    800022b8:	f022                	sd	s0,32(sp)
    800022ba:	ec26                	sd	s1,24(sp)
    800022bc:	1800                	addi	s0,sp,48
    int n;
    // 获取整数类型的系统调用参数
    if(argint(0, &n) < 0){
    800022be:	fdc40593          	addi	a1,s0,-36
    800022c2:	4501                	li	a0,0
    800022c4:	00000097          	auipc	ra,0x0
    800022c8:	cd6080e7          	jalr	-810(ra) # 80001f9a <argint>
      return -1;
    800022cc:	57fd                	li	a5,-1
    if(argint(0, &n) < 0){
    800022ce:	02054563          	bltz	a0,800022f8 <sys_trace+0x44>
    }
    struct proc *pro =myproc();
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	bc0080e7          	jalr	-1088(ra) # 80000e92 <myproc>
    800022da:	84aa                	mv	s1,a0
    printf("trace pid: %d\n", pro->pid);
    800022dc:	590c                	lw	a1,48(a0)
    800022de:	00006517          	auipc	a0,0x6
    800022e2:	33250513          	addi	a0,a0,818 # 80008610 <syscall_name+0xc0>
    800022e6:	00004097          	auipc	ra,0x4
    800022ea:	a0c080e7          	jalr	-1524(ra) # 80005cf2 <printf>
    pro->trace_mask = n;
    800022ee:	fdc42783          	lw	a5,-36(s0)
    800022f2:	16f4a423          	sw	a5,360(s1)
    return 0;
    800022f6:	4781                	li	a5,0
}
    800022f8:	853e                	mv	a0,a5
    800022fa:	70a2                	ld	ra,40(sp)
    800022fc:	7402                	ld	s0,32(sp)
    800022fe:	64e2                	ld	s1,24(sp)
    80002300:	6145                	addi	sp,sp,48
    80002302:	8082                	ret

0000000080002304 <sys_sysinfo>:

uint64 
sys_sysinfo(void) {
    80002304:	7139                	addi	sp,sp,-64
    80002306:	fc06                	sd	ra,56(sp)
    80002308:	f822                	sd	s0,48(sp)
    8000230a:	f426                	sd	s1,40(sp)
    8000230c:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 addr;
  struct proc *p = myproc();
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	b84080e7          	jalr	-1148(ra) # 80000e92 <myproc>
    80002316:	84aa                	mv	s1,a0

  if(argaddr(0,&addr) < 0){
    80002318:	fc840593          	addi	a1,s0,-56
    8000231c:	4501                	li	a0,0
    8000231e:	00000097          	auipc	ra,0x0
    80002322:	c9e080e7          	jalr	-866(ra) # 80001fbc <argaddr>
    return -1;
    80002326:	57fd                	li	a5,-1
  if(argaddr(0,&addr) < 0){
    80002328:	02054a63          	bltz	a0,8000235c <sys_sysinfo+0x58>
    }
   info.freemem = free_mem();
    8000232c:	ffffe097          	auipc	ra,0xffffe
    80002330:	e4c080e7          	jalr	-436(ra) # 80000178 <free_mem>
    80002334:	fca43823          	sd	a0,-48(s0)
   info.nproc = nproc();
    80002338:	fffff097          	auipc	ra,0xfffff
    8000233c:	71c080e7          	jalr	1820(ra) # 80001a54 <nproc>
    80002340:	fca43c23          	sd	a0,-40(s0)

   if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0){
    80002344:	46c1                	li	a3,16
    80002346:	fd040613          	addi	a2,s0,-48
    8000234a:	fc843583          	ld	a1,-56(s0)
    8000234e:	68a8                	ld	a0,80(s1)
    80002350:	fffff097          	auipc	ra,0xfffff
    80002354:	804080e7          	jalr	-2044(ra) # 80000b54 <copyout>
    80002358:	43f55793          	srai	a5,a0,0x3f
     return -1;
     }
   return 0;
}
    8000235c:	853e                	mv	a0,a5
    8000235e:	70e2                	ld	ra,56(sp)
    80002360:	7442                	ld	s0,48(sp)
    80002362:	74a2                	ld	s1,40(sp)
    80002364:	6121                	addi	sp,sp,64
    80002366:	8082                	ret

0000000080002368 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002368:	7179                	addi	sp,sp,-48
    8000236a:	f406                	sd	ra,40(sp)
    8000236c:	f022                	sd	s0,32(sp)
    8000236e:	ec26                	sd	s1,24(sp)
    80002370:	e84a                	sd	s2,16(sp)
    80002372:	e44e                	sd	s3,8(sp)
    80002374:	e052                	sd	s4,0(sp)
    80002376:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002378:	00006597          	auipc	a1,0x6
    8000237c:	2a858593          	addi	a1,a1,680 # 80008620 <syscall_name+0xd0>
    80002380:	0000d517          	auipc	a0,0xd
    80002384:	d1850513          	addi	a0,a0,-744 # 8000f098 <bcache>
    80002388:	00004097          	auipc	ra,0x4
    8000238c:	dda080e7          	jalr	-550(ra) # 80006162 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002390:	00015797          	auipc	a5,0x15
    80002394:	d0878793          	addi	a5,a5,-760 # 80017098 <bcache+0x8000>
    80002398:	00015717          	auipc	a4,0x15
    8000239c:	f6870713          	addi	a4,a4,-152 # 80017300 <bcache+0x8268>
    800023a0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023a4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a8:	0000d497          	auipc	s1,0xd
    800023ac:	d0848493          	addi	s1,s1,-760 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023b0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023b2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023b4:	00006a17          	auipc	s4,0x6
    800023b8:	274a0a13          	addi	s4,s4,628 # 80008628 <syscall_name+0xd8>
    b->next = bcache.head.next;
    800023bc:	2b893783          	ld	a5,696(s2)
    800023c0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023c2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023c6:	85d2                	mv	a1,s4
    800023c8:	01048513          	addi	a0,s1,16
    800023cc:	00001097          	auipc	ra,0x1
    800023d0:	4bc080e7          	jalr	1212(ra) # 80003888 <initsleeplock>
    bcache.head.next->prev = b;
    800023d4:	2b893783          	ld	a5,696(s2)
    800023d8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023da:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023de:	45848493          	addi	s1,s1,1112
    800023e2:	fd349de3          	bne	s1,s3,800023bc <binit+0x54>
  }
}
    800023e6:	70a2                	ld	ra,40(sp)
    800023e8:	7402                	ld	s0,32(sp)
    800023ea:	64e2                	ld	s1,24(sp)
    800023ec:	6942                	ld	s2,16(sp)
    800023ee:	69a2                	ld	s3,8(sp)
    800023f0:	6a02                	ld	s4,0(sp)
    800023f2:	6145                	addi	sp,sp,48
    800023f4:	8082                	ret

00000000800023f6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023f6:	7179                	addi	sp,sp,-48
    800023f8:	f406                	sd	ra,40(sp)
    800023fa:	f022                	sd	s0,32(sp)
    800023fc:	ec26                	sd	s1,24(sp)
    800023fe:	e84a                	sd	s2,16(sp)
    80002400:	e44e                	sd	s3,8(sp)
    80002402:	1800                	addi	s0,sp,48
    80002404:	89aa                	mv	s3,a0
    80002406:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002408:	0000d517          	auipc	a0,0xd
    8000240c:	c9050513          	addi	a0,a0,-880 # 8000f098 <bcache>
    80002410:	00004097          	auipc	ra,0x4
    80002414:	de2080e7          	jalr	-542(ra) # 800061f2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002418:	00015497          	auipc	s1,0x15
    8000241c:	f384b483          	ld	s1,-200(s1) # 80017350 <bcache+0x82b8>
    80002420:	00015797          	auipc	a5,0x15
    80002424:	ee078793          	addi	a5,a5,-288 # 80017300 <bcache+0x8268>
    80002428:	02f48f63          	beq	s1,a5,80002466 <bread+0x70>
    8000242c:	873e                	mv	a4,a5
    8000242e:	a021                	j	80002436 <bread+0x40>
    80002430:	68a4                	ld	s1,80(s1)
    80002432:	02e48a63          	beq	s1,a4,80002466 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002436:	449c                	lw	a5,8(s1)
    80002438:	ff379ce3          	bne	a5,s3,80002430 <bread+0x3a>
    8000243c:	44dc                	lw	a5,12(s1)
    8000243e:	ff2799e3          	bne	a5,s2,80002430 <bread+0x3a>
      b->refcnt++;
    80002442:	40bc                	lw	a5,64(s1)
    80002444:	2785                	addiw	a5,a5,1
    80002446:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002448:	0000d517          	auipc	a0,0xd
    8000244c:	c5050513          	addi	a0,a0,-944 # 8000f098 <bcache>
    80002450:	00004097          	auipc	ra,0x4
    80002454:	e56080e7          	jalr	-426(ra) # 800062a6 <release>
      acquiresleep(&b->lock);
    80002458:	01048513          	addi	a0,s1,16
    8000245c:	00001097          	auipc	ra,0x1
    80002460:	466080e7          	jalr	1126(ra) # 800038c2 <acquiresleep>
      return b;
    80002464:	a8b9                	j	800024c2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002466:	00015497          	auipc	s1,0x15
    8000246a:	ee24b483          	ld	s1,-286(s1) # 80017348 <bcache+0x82b0>
    8000246e:	00015797          	auipc	a5,0x15
    80002472:	e9278793          	addi	a5,a5,-366 # 80017300 <bcache+0x8268>
    80002476:	00f48863          	beq	s1,a5,80002486 <bread+0x90>
    8000247a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000247c:	40bc                	lw	a5,64(s1)
    8000247e:	cf81                	beqz	a5,80002496 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002480:	64a4                	ld	s1,72(s1)
    80002482:	fee49de3          	bne	s1,a4,8000247c <bread+0x86>
  panic("bget: no buffers");
    80002486:	00006517          	auipc	a0,0x6
    8000248a:	1aa50513          	addi	a0,a0,426 # 80008630 <syscall_name+0xe0>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	81a080e7          	jalr	-2022(ra) # 80005ca8 <panic>
      b->dev = dev;
    80002496:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000249a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000249e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024a2:	4785                	li	a5,1
    800024a4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024a6:	0000d517          	auipc	a0,0xd
    800024aa:	bf250513          	addi	a0,a0,-1038 # 8000f098 <bcache>
    800024ae:	00004097          	auipc	ra,0x4
    800024b2:	df8080e7          	jalr	-520(ra) # 800062a6 <release>
      acquiresleep(&b->lock);
    800024b6:	01048513          	addi	a0,s1,16
    800024ba:	00001097          	auipc	ra,0x1
    800024be:	408080e7          	jalr	1032(ra) # 800038c2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024c2:	409c                	lw	a5,0(s1)
    800024c4:	cb89                	beqz	a5,800024d6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024c6:	8526                	mv	a0,s1
    800024c8:	70a2                	ld	ra,40(sp)
    800024ca:	7402                	ld	s0,32(sp)
    800024cc:	64e2                	ld	s1,24(sp)
    800024ce:	6942                	ld	s2,16(sp)
    800024d0:	69a2                	ld	s3,8(sp)
    800024d2:	6145                	addi	sp,sp,48
    800024d4:	8082                	ret
    virtio_disk_rw(b, 0);
    800024d6:	4581                	li	a1,0
    800024d8:	8526                	mv	a0,s1
    800024da:	00003097          	auipc	ra,0x3
    800024de:	f0c080e7          	jalr	-244(ra) # 800053e6 <virtio_disk_rw>
    b->valid = 1;
    800024e2:	4785                	li	a5,1
    800024e4:	c09c                	sw	a5,0(s1)
  return b;
    800024e6:	b7c5                	j	800024c6 <bread+0xd0>

00000000800024e8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024e8:	1101                	addi	sp,sp,-32
    800024ea:	ec06                	sd	ra,24(sp)
    800024ec:	e822                	sd	s0,16(sp)
    800024ee:	e426                	sd	s1,8(sp)
    800024f0:	1000                	addi	s0,sp,32
    800024f2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f4:	0541                	addi	a0,a0,16
    800024f6:	00001097          	auipc	ra,0x1
    800024fa:	466080e7          	jalr	1126(ra) # 8000395c <holdingsleep>
    800024fe:	cd01                	beqz	a0,80002516 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002500:	4585                	li	a1,1
    80002502:	8526                	mv	a0,s1
    80002504:	00003097          	auipc	ra,0x3
    80002508:	ee2080e7          	jalr	-286(ra) # 800053e6 <virtio_disk_rw>
}
    8000250c:	60e2                	ld	ra,24(sp)
    8000250e:	6442                	ld	s0,16(sp)
    80002510:	64a2                	ld	s1,8(sp)
    80002512:	6105                	addi	sp,sp,32
    80002514:	8082                	ret
    panic("bwrite");
    80002516:	00006517          	auipc	a0,0x6
    8000251a:	13250513          	addi	a0,a0,306 # 80008648 <syscall_name+0xf8>
    8000251e:	00003097          	auipc	ra,0x3
    80002522:	78a080e7          	jalr	1930(ra) # 80005ca8 <panic>

0000000080002526 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002526:	1101                	addi	sp,sp,-32
    80002528:	ec06                	sd	ra,24(sp)
    8000252a:	e822                	sd	s0,16(sp)
    8000252c:	e426                	sd	s1,8(sp)
    8000252e:	e04a                	sd	s2,0(sp)
    80002530:	1000                	addi	s0,sp,32
    80002532:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002534:	01050913          	addi	s2,a0,16
    80002538:	854a                	mv	a0,s2
    8000253a:	00001097          	auipc	ra,0x1
    8000253e:	422080e7          	jalr	1058(ra) # 8000395c <holdingsleep>
    80002542:	c92d                	beqz	a0,800025b4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002544:	854a                	mv	a0,s2
    80002546:	00001097          	auipc	ra,0x1
    8000254a:	3d2080e7          	jalr	978(ra) # 80003918 <releasesleep>

  acquire(&bcache.lock);
    8000254e:	0000d517          	auipc	a0,0xd
    80002552:	b4a50513          	addi	a0,a0,-1206 # 8000f098 <bcache>
    80002556:	00004097          	auipc	ra,0x4
    8000255a:	c9c080e7          	jalr	-868(ra) # 800061f2 <acquire>
  b->refcnt--;
    8000255e:	40bc                	lw	a5,64(s1)
    80002560:	37fd                	addiw	a5,a5,-1
    80002562:	0007871b          	sext.w	a4,a5
    80002566:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002568:	eb05                	bnez	a4,80002598 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000256a:	68bc                	ld	a5,80(s1)
    8000256c:	64b8                	ld	a4,72(s1)
    8000256e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002570:	64bc                	ld	a5,72(s1)
    80002572:	68b8                	ld	a4,80(s1)
    80002574:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002576:	00015797          	auipc	a5,0x15
    8000257a:	b2278793          	addi	a5,a5,-1246 # 80017098 <bcache+0x8000>
    8000257e:	2b87b703          	ld	a4,696(a5)
    80002582:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002584:	00015717          	auipc	a4,0x15
    80002588:	d7c70713          	addi	a4,a4,-644 # 80017300 <bcache+0x8268>
    8000258c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000258e:	2b87b703          	ld	a4,696(a5)
    80002592:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002594:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002598:	0000d517          	auipc	a0,0xd
    8000259c:	b0050513          	addi	a0,a0,-1280 # 8000f098 <bcache>
    800025a0:	00004097          	auipc	ra,0x4
    800025a4:	d06080e7          	jalr	-762(ra) # 800062a6 <release>
}
    800025a8:	60e2                	ld	ra,24(sp)
    800025aa:	6442                	ld	s0,16(sp)
    800025ac:	64a2                	ld	s1,8(sp)
    800025ae:	6902                	ld	s2,0(sp)
    800025b0:	6105                	addi	sp,sp,32
    800025b2:	8082                	ret
    panic("brelse");
    800025b4:	00006517          	auipc	a0,0x6
    800025b8:	09c50513          	addi	a0,a0,156 # 80008650 <syscall_name+0x100>
    800025bc:	00003097          	auipc	ra,0x3
    800025c0:	6ec080e7          	jalr	1772(ra) # 80005ca8 <panic>

00000000800025c4 <bpin>:

void
bpin(struct buf *b) {
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	1000                	addi	s0,sp,32
    800025ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d0:	0000d517          	auipc	a0,0xd
    800025d4:	ac850513          	addi	a0,a0,-1336 # 8000f098 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	c1a080e7          	jalr	-998(ra) # 800061f2 <acquire>
  b->refcnt++;
    800025e0:	40bc                	lw	a5,64(s1)
    800025e2:	2785                	addiw	a5,a5,1
    800025e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e6:	0000d517          	auipc	a0,0xd
    800025ea:	ab250513          	addi	a0,a0,-1358 # 8000f098 <bcache>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	cb8080e7          	jalr	-840(ra) # 800062a6 <release>
}
    800025f6:	60e2                	ld	ra,24(sp)
    800025f8:	6442                	ld	s0,16(sp)
    800025fa:	64a2                	ld	s1,8(sp)
    800025fc:	6105                	addi	sp,sp,32
    800025fe:	8082                	ret

0000000080002600 <bunpin>:

void
bunpin(struct buf *b) {
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	1000                	addi	s0,sp,32
    8000260a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000260c:	0000d517          	auipc	a0,0xd
    80002610:	a8c50513          	addi	a0,a0,-1396 # 8000f098 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	bde080e7          	jalr	-1058(ra) # 800061f2 <acquire>
  b->refcnt--;
    8000261c:	40bc                	lw	a5,64(s1)
    8000261e:	37fd                	addiw	a5,a5,-1
    80002620:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002622:	0000d517          	auipc	a0,0xd
    80002626:	a7650513          	addi	a0,a0,-1418 # 8000f098 <bcache>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	c7c080e7          	jalr	-900(ra) # 800062a6 <release>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret

000000008000263c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	e04a                	sd	s2,0(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000264a:	00d5d59b          	srliw	a1,a1,0xd
    8000264e:	00015797          	auipc	a5,0x15
    80002652:	1267a783          	lw	a5,294(a5) # 80017774 <sb+0x1c>
    80002656:	9dbd                	addw	a1,a1,a5
    80002658:	00000097          	auipc	ra,0x0
    8000265c:	d9e080e7          	jalr	-610(ra) # 800023f6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002660:	0074f713          	andi	a4,s1,7
    80002664:	4785                	li	a5,1
    80002666:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000266a:	14ce                	slli	s1,s1,0x33
    8000266c:	90d9                	srli	s1,s1,0x36
    8000266e:	00950733          	add	a4,a0,s1
    80002672:	05874703          	lbu	a4,88(a4)
    80002676:	00e7f6b3          	and	a3,a5,a4
    8000267a:	c69d                	beqz	a3,800026a8 <bfree+0x6c>
    8000267c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000267e:	94aa                	add	s1,s1,a0
    80002680:	fff7c793          	not	a5,a5
    80002684:	8ff9                	and	a5,a5,a4
    80002686:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000268a:	00001097          	auipc	ra,0x1
    8000268e:	118080e7          	jalr	280(ra) # 800037a2 <log_write>
  brelse(bp);
    80002692:	854a                	mv	a0,s2
    80002694:	00000097          	auipc	ra,0x0
    80002698:	e92080e7          	jalr	-366(ra) # 80002526 <brelse>
}
    8000269c:	60e2                	ld	ra,24(sp)
    8000269e:	6442                	ld	s0,16(sp)
    800026a0:	64a2                	ld	s1,8(sp)
    800026a2:	6902                	ld	s2,0(sp)
    800026a4:	6105                	addi	sp,sp,32
    800026a6:	8082                	ret
    panic("freeing free block");
    800026a8:	00006517          	auipc	a0,0x6
    800026ac:	fb050513          	addi	a0,a0,-80 # 80008658 <syscall_name+0x108>
    800026b0:	00003097          	auipc	ra,0x3
    800026b4:	5f8080e7          	jalr	1528(ra) # 80005ca8 <panic>

00000000800026b8 <balloc>:
{
    800026b8:	711d                	addi	sp,sp,-96
    800026ba:	ec86                	sd	ra,88(sp)
    800026bc:	e8a2                	sd	s0,80(sp)
    800026be:	e4a6                	sd	s1,72(sp)
    800026c0:	e0ca                	sd	s2,64(sp)
    800026c2:	fc4e                	sd	s3,56(sp)
    800026c4:	f852                	sd	s4,48(sp)
    800026c6:	f456                	sd	s5,40(sp)
    800026c8:	f05a                	sd	s6,32(sp)
    800026ca:	ec5e                	sd	s7,24(sp)
    800026cc:	e862                	sd	s8,16(sp)
    800026ce:	e466                	sd	s9,8(sp)
    800026d0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026d2:	00015797          	auipc	a5,0x15
    800026d6:	08a7a783          	lw	a5,138(a5) # 8001775c <sb+0x4>
    800026da:	cbd1                	beqz	a5,8000276e <balloc+0xb6>
    800026dc:	8baa                	mv	s7,a0
    800026de:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026e0:	00015b17          	auipc	s6,0x15
    800026e4:	078b0b13          	addi	s6,s6,120 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026e8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026ea:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ec:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026ee:	6c89                	lui	s9,0x2
    800026f0:	a831                	j	8000270c <balloc+0x54>
    brelse(bp);
    800026f2:	854a                	mv	a0,s2
    800026f4:	00000097          	auipc	ra,0x0
    800026f8:	e32080e7          	jalr	-462(ra) # 80002526 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026fc:	015c87bb          	addw	a5,s9,s5
    80002700:	00078a9b          	sext.w	s5,a5
    80002704:	004b2703          	lw	a4,4(s6)
    80002708:	06eaf363          	bgeu	s5,a4,8000276e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000270c:	41fad79b          	sraiw	a5,s5,0x1f
    80002710:	0137d79b          	srliw	a5,a5,0x13
    80002714:	015787bb          	addw	a5,a5,s5
    80002718:	40d7d79b          	sraiw	a5,a5,0xd
    8000271c:	01cb2583          	lw	a1,28(s6)
    80002720:	9dbd                	addw	a1,a1,a5
    80002722:	855e                	mv	a0,s7
    80002724:	00000097          	auipc	ra,0x0
    80002728:	cd2080e7          	jalr	-814(ra) # 800023f6 <bread>
    8000272c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000272e:	004b2503          	lw	a0,4(s6)
    80002732:	000a849b          	sext.w	s1,s5
    80002736:	8662                	mv	a2,s8
    80002738:	faa4fde3          	bgeu	s1,a0,800026f2 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000273c:	41f6579b          	sraiw	a5,a2,0x1f
    80002740:	01d7d69b          	srliw	a3,a5,0x1d
    80002744:	00c6873b          	addw	a4,a3,a2
    80002748:	00777793          	andi	a5,a4,7
    8000274c:	9f95                	subw	a5,a5,a3
    8000274e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002752:	4037571b          	sraiw	a4,a4,0x3
    80002756:	00e906b3          	add	a3,s2,a4
    8000275a:	0586c683          	lbu	a3,88(a3)
    8000275e:	00d7f5b3          	and	a1,a5,a3
    80002762:	cd91                	beqz	a1,8000277e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002764:	2605                	addiw	a2,a2,1
    80002766:	2485                	addiw	s1,s1,1
    80002768:	fd4618e3          	bne	a2,s4,80002738 <balloc+0x80>
    8000276c:	b759                	j	800026f2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000276e:	00006517          	auipc	a0,0x6
    80002772:	f0250513          	addi	a0,a0,-254 # 80008670 <syscall_name+0x120>
    80002776:	00003097          	auipc	ra,0x3
    8000277a:	532080e7          	jalr	1330(ra) # 80005ca8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000277e:	974a                	add	a4,a4,s2
    80002780:	8fd5                	or	a5,a5,a3
    80002782:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00001097          	auipc	ra,0x1
    8000278c:	01a080e7          	jalr	26(ra) # 800037a2 <log_write>
        brelse(bp);
    80002790:	854a                	mv	a0,s2
    80002792:	00000097          	auipc	ra,0x0
    80002796:	d94080e7          	jalr	-620(ra) # 80002526 <brelse>
  bp = bread(dev, bno);
    8000279a:	85a6                	mv	a1,s1
    8000279c:	855e                	mv	a0,s7
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	c58080e7          	jalr	-936(ra) # 800023f6 <bread>
    800027a6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027a8:	40000613          	li	a2,1024
    800027ac:	4581                	li	a1,0
    800027ae:	05850513          	addi	a0,a0,88
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	a10080e7          	jalr	-1520(ra) # 800001c2 <memset>
  log_write(bp);
    800027ba:	854a                	mv	a0,s2
    800027bc:	00001097          	auipc	ra,0x1
    800027c0:	fe6080e7          	jalr	-26(ra) # 800037a2 <log_write>
  brelse(bp);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00000097          	auipc	ra,0x0
    800027ca:	d60080e7          	jalr	-672(ra) # 80002526 <brelse>
}
    800027ce:	8526                	mv	a0,s1
    800027d0:	60e6                	ld	ra,88(sp)
    800027d2:	6446                	ld	s0,80(sp)
    800027d4:	64a6                	ld	s1,72(sp)
    800027d6:	6906                	ld	s2,64(sp)
    800027d8:	79e2                	ld	s3,56(sp)
    800027da:	7a42                	ld	s4,48(sp)
    800027dc:	7aa2                	ld	s5,40(sp)
    800027de:	7b02                	ld	s6,32(sp)
    800027e0:	6be2                	ld	s7,24(sp)
    800027e2:	6c42                	ld	s8,16(sp)
    800027e4:	6ca2                	ld	s9,8(sp)
    800027e6:	6125                	addi	sp,sp,96
    800027e8:	8082                	ret

00000000800027ea <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ea:	7179                	addi	sp,sp,-48
    800027ec:	f406                	sd	ra,40(sp)
    800027ee:	f022                	sd	s0,32(sp)
    800027f0:	ec26                	sd	s1,24(sp)
    800027f2:	e84a                	sd	s2,16(sp)
    800027f4:	e44e                	sd	s3,8(sp)
    800027f6:	e052                	sd	s4,0(sp)
    800027f8:	1800                	addi	s0,sp,48
    800027fa:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027fc:	47ad                	li	a5,11
    800027fe:	04b7fe63          	bgeu	a5,a1,8000285a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002802:	ff45849b          	addiw	s1,a1,-12
    80002806:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000280a:	0ff00793          	li	a5,255
    8000280e:	0ae7e363          	bltu	a5,a4,800028b4 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002812:	08052583          	lw	a1,128(a0)
    80002816:	c5ad                	beqz	a1,80002880 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002818:	00092503          	lw	a0,0(s2)
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	bda080e7          	jalr	-1062(ra) # 800023f6 <bread>
    80002824:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002826:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000282a:	02049593          	slli	a1,s1,0x20
    8000282e:	9181                	srli	a1,a1,0x20
    80002830:	058a                	slli	a1,a1,0x2
    80002832:	00b784b3          	add	s1,a5,a1
    80002836:	0004a983          	lw	s3,0(s1)
    8000283a:	04098d63          	beqz	s3,80002894 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000283e:	8552                	mv	a0,s4
    80002840:	00000097          	auipc	ra,0x0
    80002844:	ce6080e7          	jalr	-794(ra) # 80002526 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002848:	854e                	mv	a0,s3
    8000284a:	70a2                	ld	ra,40(sp)
    8000284c:	7402                	ld	s0,32(sp)
    8000284e:	64e2                	ld	s1,24(sp)
    80002850:	6942                	ld	s2,16(sp)
    80002852:	69a2                	ld	s3,8(sp)
    80002854:	6a02                	ld	s4,0(sp)
    80002856:	6145                	addi	sp,sp,48
    80002858:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000285a:	02059493          	slli	s1,a1,0x20
    8000285e:	9081                	srli	s1,s1,0x20
    80002860:	048a                	slli	s1,s1,0x2
    80002862:	94aa                	add	s1,s1,a0
    80002864:	0504a983          	lw	s3,80(s1)
    80002868:	fe0990e3          	bnez	s3,80002848 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000286c:	4108                	lw	a0,0(a0)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	e4a080e7          	jalr	-438(ra) # 800026b8 <balloc>
    80002876:	0005099b          	sext.w	s3,a0
    8000287a:	0534a823          	sw	s3,80(s1)
    8000287e:	b7e9                	j	80002848 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002880:	4108                	lw	a0,0(a0)
    80002882:	00000097          	auipc	ra,0x0
    80002886:	e36080e7          	jalr	-458(ra) # 800026b8 <balloc>
    8000288a:	0005059b          	sext.w	a1,a0
    8000288e:	08b92023          	sw	a1,128(s2)
    80002892:	b759                	j	80002818 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002894:	00092503          	lw	a0,0(s2)
    80002898:	00000097          	auipc	ra,0x0
    8000289c:	e20080e7          	jalr	-480(ra) # 800026b8 <balloc>
    800028a0:	0005099b          	sext.w	s3,a0
    800028a4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028a8:	8552                	mv	a0,s4
    800028aa:	00001097          	auipc	ra,0x1
    800028ae:	ef8080e7          	jalr	-264(ra) # 800037a2 <log_write>
    800028b2:	b771                	j	8000283e <bmap+0x54>
  panic("bmap: out of range");
    800028b4:	00006517          	auipc	a0,0x6
    800028b8:	dd450513          	addi	a0,a0,-556 # 80008688 <syscall_name+0x138>
    800028bc:	00003097          	auipc	ra,0x3
    800028c0:	3ec080e7          	jalr	1004(ra) # 80005ca8 <panic>

00000000800028c4 <iget>:
{
    800028c4:	7179                	addi	sp,sp,-48
    800028c6:	f406                	sd	ra,40(sp)
    800028c8:	f022                	sd	s0,32(sp)
    800028ca:	ec26                	sd	s1,24(sp)
    800028cc:	e84a                	sd	s2,16(sp)
    800028ce:	e44e                	sd	s3,8(sp)
    800028d0:	e052                	sd	s4,0(sp)
    800028d2:	1800                	addi	s0,sp,48
    800028d4:	89aa                	mv	s3,a0
    800028d6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028d8:	00015517          	auipc	a0,0x15
    800028dc:	ea050513          	addi	a0,a0,-352 # 80017778 <itable>
    800028e0:	00004097          	auipc	ra,0x4
    800028e4:	912080e7          	jalr	-1774(ra) # 800061f2 <acquire>
  empty = 0;
    800028e8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ea:	00015497          	auipc	s1,0x15
    800028ee:	ea648493          	addi	s1,s1,-346 # 80017790 <itable+0x18>
    800028f2:	00017697          	auipc	a3,0x17
    800028f6:	92e68693          	addi	a3,a3,-1746 # 80019220 <log>
    800028fa:	a039                	j	80002908 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fc:	02090b63          	beqz	s2,80002932 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002900:	08848493          	addi	s1,s1,136
    80002904:	02d48a63          	beq	s1,a3,80002938 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002908:	449c                	lw	a5,8(s1)
    8000290a:	fef059e3          	blez	a5,800028fc <iget+0x38>
    8000290e:	4098                	lw	a4,0(s1)
    80002910:	ff3716e3          	bne	a4,s3,800028fc <iget+0x38>
    80002914:	40d8                	lw	a4,4(s1)
    80002916:	ff4713e3          	bne	a4,s4,800028fc <iget+0x38>
      ip->ref++;
    8000291a:	2785                	addiw	a5,a5,1
    8000291c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000291e:	00015517          	auipc	a0,0x15
    80002922:	e5a50513          	addi	a0,a0,-422 # 80017778 <itable>
    80002926:	00004097          	auipc	ra,0x4
    8000292a:	980080e7          	jalr	-1664(ra) # 800062a6 <release>
      return ip;
    8000292e:	8926                	mv	s2,s1
    80002930:	a03d                	j	8000295e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002932:	f7f9                	bnez	a5,80002900 <iget+0x3c>
    80002934:	8926                	mv	s2,s1
    80002936:	b7e9                	j	80002900 <iget+0x3c>
  if(empty == 0)
    80002938:	02090c63          	beqz	s2,80002970 <iget+0xac>
  ip->dev = dev;
    8000293c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002940:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002944:	4785                	li	a5,1
    80002946:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000294a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000294e:	00015517          	auipc	a0,0x15
    80002952:	e2a50513          	addi	a0,a0,-470 # 80017778 <itable>
    80002956:	00004097          	auipc	ra,0x4
    8000295a:	950080e7          	jalr	-1712(ra) # 800062a6 <release>
}
    8000295e:	854a                	mv	a0,s2
    80002960:	70a2                	ld	ra,40(sp)
    80002962:	7402                	ld	s0,32(sp)
    80002964:	64e2                	ld	s1,24(sp)
    80002966:	6942                	ld	s2,16(sp)
    80002968:	69a2                	ld	s3,8(sp)
    8000296a:	6a02                	ld	s4,0(sp)
    8000296c:	6145                	addi	sp,sp,48
    8000296e:	8082                	ret
    panic("iget: no inodes");
    80002970:	00006517          	auipc	a0,0x6
    80002974:	d3050513          	addi	a0,a0,-720 # 800086a0 <syscall_name+0x150>
    80002978:	00003097          	auipc	ra,0x3
    8000297c:	330080e7          	jalr	816(ra) # 80005ca8 <panic>

0000000080002980 <fsinit>:
fsinit(int dev) {
    80002980:	7179                	addi	sp,sp,-48
    80002982:	f406                	sd	ra,40(sp)
    80002984:	f022                	sd	s0,32(sp)
    80002986:	ec26                	sd	s1,24(sp)
    80002988:	e84a                	sd	s2,16(sp)
    8000298a:	e44e                	sd	s3,8(sp)
    8000298c:	1800                	addi	s0,sp,48
    8000298e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002990:	4585                	li	a1,1
    80002992:	00000097          	auipc	ra,0x0
    80002996:	a64080e7          	jalr	-1436(ra) # 800023f6 <bread>
    8000299a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000299c:	00015997          	auipc	s3,0x15
    800029a0:	dbc98993          	addi	s3,s3,-580 # 80017758 <sb>
    800029a4:	02000613          	li	a2,32
    800029a8:	05850593          	addi	a1,a0,88
    800029ac:	854e                	mv	a0,s3
    800029ae:	ffffe097          	auipc	ra,0xffffe
    800029b2:	874080e7          	jalr	-1932(ra) # 80000222 <memmove>
  brelse(bp);
    800029b6:	8526                	mv	a0,s1
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	b6e080e7          	jalr	-1170(ra) # 80002526 <brelse>
  if(sb.magic != FSMAGIC)
    800029c0:	0009a703          	lw	a4,0(s3)
    800029c4:	102037b7          	lui	a5,0x10203
    800029c8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029cc:	02f71263          	bne	a4,a5,800029f0 <fsinit+0x70>
  initlog(dev, &sb);
    800029d0:	00015597          	auipc	a1,0x15
    800029d4:	d8858593          	addi	a1,a1,-632 # 80017758 <sb>
    800029d8:	854a                	mv	a0,s2
    800029da:	00001097          	auipc	ra,0x1
    800029de:	b4c080e7          	jalr	-1204(ra) # 80003526 <initlog>
}
    800029e2:	70a2                	ld	ra,40(sp)
    800029e4:	7402                	ld	s0,32(sp)
    800029e6:	64e2                	ld	s1,24(sp)
    800029e8:	6942                	ld	s2,16(sp)
    800029ea:	69a2                	ld	s3,8(sp)
    800029ec:	6145                	addi	sp,sp,48
    800029ee:	8082                	ret
    panic("invalid file system");
    800029f0:	00006517          	auipc	a0,0x6
    800029f4:	cc050513          	addi	a0,a0,-832 # 800086b0 <syscall_name+0x160>
    800029f8:	00003097          	auipc	ra,0x3
    800029fc:	2b0080e7          	jalr	688(ra) # 80005ca8 <panic>

0000000080002a00 <iinit>:
{
    80002a00:	7179                	addi	sp,sp,-48
    80002a02:	f406                	sd	ra,40(sp)
    80002a04:	f022                	sd	s0,32(sp)
    80002a06:	ec26                	sd	s1,24(sp)
    80002a08:	e84a                	sd	s2,16(sp)
    80002a0a:	e44e                	sd	s3,8(sp)
    80002a0c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a0e:	00006597          	auipc	a1,0x6
    80002a12:	cba58593          	addi	a1,a1,-838 # 800086c8 <syscall_name+0x178>
    80002a16:	00015517          	auipc	a0,0x15
    80002a1a:	d6250513          	addi	a0,a0,-670 # 80017778 <itable>
    80002a1e:	00003097          	auipc	ra,0x3
    80002a22:	744080e7          	jalr	1860(ra) # 80006162 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a26:	00015497          	auipc	s1,0x15
    80002a2a:	d7a48493          	addi	s1,s1,-646 # 800177a0 <itable+0x28>
    80002a2e:	00017997          	auipc	s3,0x17
    80002a32:	80298993          	addi	s3,s3,-2046 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a36:	00006917          	auipc	s2,0x6
    80002a3a:	c9a90913          	addi	s2,s2,-870 # 800086d0 <syscall_name+0x180>
    80002a3e:	85ca                	mv	a1,s2
    80002a40:	8526                	mv	a0,s1
    80002a42:	00001097          	auipc	ra,0x1
    80002a46:	e46080e7          	jalr	-442(ra) # 80003888 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a4a:	08848493          	addi	s1,s1,136
    80002a4e:	ff3498e3          	bne	s1,s3,80002a3e <iinit+0x3e>
}
    80002a52:	70a2                	ld	ra,40(sp)
    80002a54:	7402                	ld	s0,32(sp)
    80002a56:	64e2                	ld	s1,24(sp)
    80002a58:	6942                	ld	s2,16(sp)
    80002a5a:	69a2                	ld	s3,8(sp)
    80002a5c:	6145                	addi	sp,sp,48
    80002a5e:	8082                	ret

0000000080002a60 <ialloc>:
{
    80002a60:	715d                	addi	sp,sp,-80
    80002a62:	e486                	sd	ra,72(sp)
    80002a64:	e0a2                	sd	s0,64(sp)
    80002a66:	fc26                	sd	s1,56(sp)
    80002a68:	f84a                	sd	s2,48(sp)
    80002a6a:	f44e                	sd	s3,40(sp)
    80002a6c:	f052                	sd	s4,32(sp)
    80002a6e:	ec56                	sd	s5,24(sp)
    80002a70:	e85a                	sd	s6,16(sp)
    80002a72:	e45e                	sd	s7,8(sp)
    80002a74:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a76:	00015717          	auipc	a4,0x15
    80002a7a:	cee72703          	lw	a4,-786(a4) # 80017764 <sb+0xc>
    80002a7e:	4785                	li	a5,1
    80002a80:	04e7fa63          	bgeu	a5,a4,80002ad4 <ialloc+0x74>
    80002a84:	8aaa                	mv	s5,a0
    80002a86:	8bae                	mv	s7,a1
    80002a88:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a8a:	00015a17          	auipc	s4,0x15
    80002a8e:	ccea0a13          	addi	s4,s4,-818 # 80017758 <sb>
    80002a92:	00048b1b          	sext.w	s6,s1
    80002a96:	0044d593          	srli	a1,s1,0x4
    80002a9a:	018a2783          	lw	a5,24(s4)
    80002a9e:	9dbd                	addw	a1,a1,a5
    80002aa0:	8556                	mv	a0,s5
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	954080e7          	jalr	-1708(ra) # 800023f6 <bread>
    80002aaa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aac:	05850993          	addi	s3,a0,88
    80002ab0:	00f4f793          	andi	a5,s1,15
    80002ab4:	079a                	slli	a5,a5,0x6
    80002ab6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ab8:	00099783          	lh	a5,0(s3)
    80002abc:	c785                	beqz	a5,80002ae4 <ialloc+0x84>
    brelse(bp);
    80002abe:	00000097          	auipc	ra,0x0
    80002ac2:	a68080e7          	jalr	-1432(ra) # 80002526 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ac6:	0485                	addi	s1,s1,1
    80002ac8:	00ca2703          	lw	a4,12(s4)
    80002acc:	0004879b          	sext.w	a5,s1
    80002ad0:	fce7e1e3          	bltu	a5,a4,80002a92 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ad4:	00006517          	auipc	a0,0x6
    80002ad8:	c0450513          	addi	a0,a0,-1020 # 800086d8 <syscall_name+0x188>
    80002adc:	00003097          	auipc	ra,0x3
    80002ae0:	1cc080e7          	jalr	460(ra) # 80005ca8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ae4:	04000613          	li	a2,64
    80002ae8:	4581                	li	a1,0
    80002aea:	854e                	mv	a0,s3
    80002aec:	ffffd097          	auipc	ra,0xffffd
    80002af0:	6d6080e7          	jalr	1750(ra) # 800001c2 <memset>
      dip->type = type;
    80002af4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002af8:	854a                	mv	a0,s2
    80002afa:	00001097          	auipc	ra,0x1
    80002afe:	ca8080e7          	jalr	-856(ra) # 800037a2 <log_write>
      brelse(bp);
    80002b02:	854a                	mv	a0,s2
    80002b04:	00000097          	auipc	ra,0x0
    80002b08:	a22080e7          	jalr	-1502(ra) # 80002526 <brelse>
      return iget(dev, inum);
    80002b0c:	85da                	mv	a1,s6
    80002b0e:	8556                	mv	a0,s5
    80002b10:	00000097          	auipc	ra,0x0
    80002b14:	db4080e7          	jalr	-588(ra) # 800028c4 <iget>
}
    80002b18:	60a6                	ld	ra,72(sp)
    80002b1a:	6406                	ld	s0,64(sp)
    80002b1c:	74e2                	ld	s1,56(sp)
    80002b1e:	7942                	ld	s2,48(sp)
    80002b20:	79a2                	ld	s3,40(sp)
    80002b22:	7a02                	ld	s4,32(sp)
    80002b24:	6ae2                	ld	s5,24(sp)
    80002b26:	6b42                	ld	s6,16(sp)
    80002b28:	6ba2                	ld	s7,8(sp)
    80002b2a:	6161                	addi	sp,sp,80
    80002b2c:	8082                	ret

0000000080002b2e <iupdate>:
{
    80002b2e:	1101                	addi	sp,sp,-32
    80002b30:	ec06                	sd	ra,24(sp)
    80002b32:	e822                	sd	s0,16(sp)
    80002b34:	e426                	sd	s1,8(sp)
    80002b36:	e04a                	sd	s2,0(sp)
    80002b38:	1000                	addi	s0,sp,32
    80002b3a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b3c:	415c                	lw	a5,4(a0)
    80002b3e:	0047d79b          	srliw	a5,a5,0x4
    80002b42:	00015597          	auipc	a1,0x15
    80002b46:	c2e5a583          	lw	a1,-978(a1) # 80017770 <sb+0x18>
    80002b4a:	9dbd                	addw	a1,a1,a5
    80002b4c:	4108                	lw	a0,0(a0)
    80002b4e:	00000097          	auipc	ra,0x0
    80002b52:	8a8080e7          	jalr	-1880(ra) # 800023f6 <bread>
    80002b56:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b58:	05850793          	addi	a5,a0,88
    80002b5c:	40c8                	lw	a0,4(s1)
    80002b5e:	893d                	andi	a0,a0,15
    80002b60:	051a                	slli	a0,a0,0x6
    80002b62:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b64:	04449703          	lh	a4,68(s1)
    80002b68:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b6c:	04649703          	lh	a4,70(s1)
    80002b70:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b74:	04849703          	lh	a4,72(s1)
    80002b78:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b7c:	04a49703          	lh	a4,74(s1)
    80002b80:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b84:	44f8                	lw	a4,76(s1)
    80002b86:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b88:	03400613          	li	a2,52
    80002b8c:	05048593          	addi	a1,s1,80
    80002b90:	0531                	addi	a0,a0,12
    80002b92:	ffffd097          	auipc	ra,0xffffd
    80002b96:	690080e7          	jalr	1680(ra) # 80000222 <memmove>
  log_write(bp);
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	00001097          	auipc	ra,0x1
    80002ba0:	c06080e7          	jalr	-1018(ra) # 800037a2 <log_write>
  brelse(bp);
    80002ba4:	854a                	mv	a0,s2
    80002ba6:	00000097          	auipc	ra,0x0
    80002baa:	980080e7          	jalr	-1664(ra) # 80002526 <brelse>
}
    80002bae:	60e2                	ld	ra,24(sp)
    80002bb0:	6442                	ld	s0,16(sp)
    80002bb2:	64a2                	ld	s1,8(sp)
    80002bb4:	6902                	ld	s2,0(sp)
    80002bb6:	6105                	addi	sp,sp,32
    80002bb8:	8082                	ret

0000000080002bba <idup>:
{
    80002bba:	1101                	addi	sp,sp,-32
    80002bbc:	ec06                	sd	ra,24(sp)
    80002bbe:	e822                	sd	s0,16(sp)
    80002bc0:	e426                	sd	s1,8(sp)
    80002bc2:	1000                	addi	s0,sp,32
    80002bc4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bc6:	00015517          	auipc	a0,0x15
    80002bca:	bb250513          	addi	a0,a0,-1102 # 80017778 <itable>
    80002bce:	00003097          	auipc	ra,0x3
    80002bd2:	624080e7          	jalr	1572(ra) # 800061f2 <acquire>
  ip->ref++;
    80002bd6:	449c                	lw	a5,8(s1)
    80002bd8:	2785                	addiw	a5,a5,1
    80002bda:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bdc:	00015517          	auipc	a0,0x15
    80002be0:	b9c50513          	addi	a0,a0,-1124 # 80017778 <itable>
    80002be4:	00003097          	auipc	ra,0x3
    80002be8:	6c2080e7          	jalr	1730(ra) # 800062a6 <release>
}
    80002bec:	8526                	mv	a0,s1
    80002bee:	60e2                	ld	ra,24(sp)
    80002bf0:	6442                	ld	s0,16(sp)
    80002bf2:	64a2                	ld	s1,8(sp)
    80002bf4:	6105                	addi	sp,sp,32
    80002bf6:	8082                	ret

0000000080002bf8 <ilock>:
{
    80002bf8:	1101                	addi	sp,sp,-32
    80002bfa:	ec06                	sd	ra,24(sp)
    80002bfc:	e822                	sd	s0,16(sp)
    80002bfe:	e426                	sd	s1,8(sp)
    80002c00:	e04a                	sd	s2,0(sp)
    80002c02:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c04:	c115                	beqz	a0,80002c28 <ilock+0x30>
    80002c06:	84aa                	mv	s1,a0
    80002c08:	451c                	lw	a5,8(a0)
    80002c0a:	00f05f63          	blez	a5,80002c28 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c0e:	0541                	addi	a0,a0,16
    80002c10:	00001097          	auipc	ra,0x1
    80002c14:	cb2080e7          	jalr	-846(ra) # 800038c2 <acquiresleep>
  if(ip->valid == 0){
    80002c18:	40bc                	lw	a5,64(s1)
    80002c1a:	cf99                	beqz	a5,80002c38 <ilock+0x40>
}
    80002c1c:	60e2                	ld	ra,24(sp)
    80002c1e:	6442                	ld	s0,16(sp)
    80002c20:	64a2                	ld	s1,8(sp)
    80002c22:	6902                	ld	s2,0(sp)
    80002c24:	6105                	addi	sp,sp,32
    80002c26:	8082                	ret
    panic("ilock");
    80002c28:	00006517          	auipc	a0,0x6
    80002c2c:	ac850513          	addi	a0,a0,-1336 # 800086f0 <syscall_name+0x1a0>
    80002c30:	00003097          	auipc	ra,0x3
    80002c34:	078080e7          	jalr	120(ra) # 80005ca8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c38:	40dc                	lw	a5,4(s1)
    80002c3a:	0047d79b          	srliw	a5,a5,0x4
    80002c3e:	00015597          	auipc	a1,0x15
    80002c42:	b325a583          	lw	a1,-1230(a1) # 80017770 <sb+0x18>
    80002c46:	9dbd                	addw	a1,a1,a5
    80002c48:	4088                	lw	a0,0(s1)
    80002c4a:	fffff097          	auipc	ra,0xfffff
    80002c4e:	7ac080e7          	jalr	1964(ra) # 800023f6 <bread>
    80002c52:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c54:	05850593          	addi	a1,a0,88
    80002c58:	40dc                	lw	a5,4(s1)
    80002c5a:	8bbd                	andi	a5,a5,15
    80002c5c:	079a                	slli	a5,a5,0x6
    80002c5e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c60:	00059783          	lh	a5,0(a1)
    80002c64:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c68:	00259783          	lh	a5,2(a1)
    80002c6c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c70:	00459783          	lh	a5,4(a1)
    80002c74:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c78:	00659783          	lh	a5,6(a1)
    80002c7c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c80:	459c                	lw	a5,8(a1)
    80002c82:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c84:	03400613          	li	a2,52
    80002c88:	05b1                	addi	a1,a1,12
    80002c8a:	05048513          	addi	a0,s1,80
    80002c8e:	ffffd097          	auipc	ra,0xffffd
    80002c92:	594080e7          	jalr	1428(ra) # 80000222 <memmove>
    brelse(bp);
    80002c96:	854a                	mv	a0,s2
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	88e080e7          	jalr	-1906(ra) # 80002526 <brelse>
    ip->valid = 1;
    80002ca0:	4785                	li	a5,1
    80002ca2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ca4:	04449783          	lh	a5,68(s1)
    80002ca8:	fbb5                	bnez	a5,80002c1c <ilock+0x24>
      panic("ilock: no type");
    80002caa:	00006517          	auipc	a0,0x6
    80002cae:	a4e50513          	addi	a0,a0,-1458 # 800086f8 <syscall_name+0x1a8>
    80002cb2:	00003097          	auipc	ra,0x3
    80002cb6:	ff6080e7          	jalr	-10(ra) # 80005ca8 <panic>

0000000080002cba <iunlock>:
{
    80002cba:	1101                	addi	sp,sp,-32
    80002cbc:	ec06                	sd	ra,24(sp)
    80002cbe:	e822                	sd	s0,16(sp)
    80002cc0:	e426                	sd	s1,8(sp)
    80002cc2:	e04a                	sd	s2,0(sp)
    80002cc4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cc6:	c905                	beqz	a0,80002cf6 <iunlock+0x3c>
    80002cc8:	84aa                	mv	s1,a0
    80002cca:	01050913          	addi	s2,a0,16
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	c8c080e7          	jalr	-884(ra) # 8000395c <holdingsleep>
    80002cd8:	cd19                	beqz	a0,80002cf6 <iunlock+0x3c>
    80002cda:	449c                	lw	a5,8(s1)
    80002cdc:	00f05d63          	blez	a5,80002cf6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ce0:	854a                	mv	a0,s2
    80002ce2:	00001097          	auipc	ra,0x1
    80002ce6:	c36080e7          	jalr	-970(ra) # 80003918 <releasesleep>
}
    80002cea:	60e2                	ld	ra,24(sp)
    80002cec:	6442                	ld	s0,16(sp)
    80002cee:	64a2                	ld	s1,8(sp)
    80002cf0:	6902                	ld	s2,0(sp)
    80002cf2:	6105                	addi	sp,sp,32
    80002cf4:	8082                	ret
    panic("iunlock");
    80002cf6:	00006517          	auipc	a0,0x6
    80002cfa:	a1250513          	addi	a0,a0,-1518 # 80008708 <syscall_name+0x1b8>
    80002cfe:	00003097          	auipc	ra,0x3
    80002d02:	faa080e7          	jalr	-86(ra) # 80005ca8 <panic>

0000000080002d06 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d06:	7179                	addi	sp,sp,-48
    80002d08:	f406                	sd	ra,40(sp)
    80002d0a:	f022                	sd	s0,32(sp)
    80002d0c:	ec26                	sd	s1,24(sp)
    80002d0e:	e84a                	sd	s2,16(sp)
    80002d10:	e44e                	sd	s3,8(sp)
    80002d12:	e052                	sd	s4,0(sp)
    80002d14:	1800                	addi	s0,sp,48
    80002d16:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d18:	05050493          	addi	s1,a0,80
    80002d1c:	08050913          	addi	s2,a0,128
    80002d20:	a021                	j	80002d28 <itrunc+0x22>
    80002d22:	0491                	addi	s1,s1,4
    80002d24:	01248d63          	beq	s1,s2,80002d3e <itrunc+0x38>
    if(ip->addrs[i]){
    80002d28:	408c                	lw	a1,0(s1)
    80002d2a:	dde5                	beqz	a1,80002d22 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d2c:	0009a503          	lw	a0,0(s3)
    80002d30:	00000097          	auipc	ra,0x0
    80002d34:	90c080e7          	jalr	-1780(ra) # 8000263c <bfree>
      ip->addrs[i] = 0;
    80002d38:	0004a023          	sw	zero,0(s1)
    80002d3c:	b7dd                	j	80002d22 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d3e:	0809a583          	lw	a1,128(s3)
    80002d42:	e185                	bnez	a1,80002d62 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d44:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d48:	854e                	mv	a0,s3
    80002d4a:	00000097          	auipc	ra,0x0
    80002d4e:	de4080e7          	jalr	-540(ra) # 80002b2e <iupdate>
}
    80002d52:	70a2                	ld	ra,40(sp)
    80002d54:	7402                	ld	s0,32(sp)
    80002d56:	64e2                	ld	s1,24(sp)
    80002d58:	6942                	ld	s2,16(sp)
    80002d5a:	69a2                	ld	s3,8(sp)
    80002d5c:	6a02                	ld	s4,0(sp)
    80002d5e:	6145                	addi	sp,sp,48
    80002d60:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d62:	0009a503          	lw	a0,0(s3)
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	690080e7          	jalr	1680(ra) # 800023f6 <bread>
    80002d6e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d70:	05850493          	addi	s1,a0,88
    80002d74:	45850913          	addi	s2,a0,1112
    80002d78:	a811                	j	80002d8c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d7a:	0009a503          	lw	a0,0(s3)
    80002d7e:	00000097          	auipc	ra,0x0
    80002d82:	8be080e7          	jalr	-1858(ra) # 8000263c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d86:	0491                	addi	s1,s1,4
    80002d88:	01248563          	beq	s1,s2,80002d92 <itrunc+0x8c>
      if(a[j])
    80002d8c:	408c                	lw	a1,0(s1)
    80002d8e:	dde5                	beqz	a1,80002d86 <itrunc+0x80>
    80002d90:	b7ed                	j	80002d7a <itrunc+0x74>
    brelse(bp);
    80002d92:	8552                	mv	a0,s4
    80002d94:	fffff097          	auipc	ra,0xfffff
    80002d98:	792080e7          	jalr	1938(ra) # 80002526 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d9c:	0809a583          	lw	a1,128(s3)
    80002da0:	0009a503          	lw	a0,0(s3)
    80002da4:	00000097          	auipc	ra,0x0
    80002da8:	898080e7          	jalr	-1896(ra) # 8000263c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dac:	0809a023          	sw	zero,128(s3)
    80002db0:	bf51                	j	80002d44 <itrunc+0x3e>

0000000080002db2 <iput>:
{
    80002db2:	1101                	addi	sp,sp,-32
    80002db4:	ec06                	sd	ra,24(sp)
    80002db6:	e822                	sd	s0,16(sp)
    80002db8:	e426                	sd	s1,8(sp)
    80002dba:	e04a                	sd	s2,0(sp)
    80002dbc:	1000                	addi	s0,sp,32
    80002dbe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dc0:	00015517          	auipc	a0,0x15
    80002dc4:	9b850513          	addi	a0,a0,-1608 # 80017778 <itable>
    80002dc8:	00003097          	auipc	ra,0x3
    80002dcc:	42a080e7          	jalr	1066(ra) # 800061f2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd0:	4498                	lw	a4,8(s1)
    80002dd2:	4785                	li	a5,1
    80002dd4:	02f70363          	beq	a4,a5,80002dfa <iput+0x48>
  ip->ref--;
    80002dd8:	449c                	lw	a5,8(s1)
    80002dda:	37fd                	addiw	a5,a5,-1
    80002ddc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dde:	00015517          	auipc	a0,0x15
    80002de2:	99a50513          	addi	a0,a0,-1638 # 80017778 <itable>
    80002de6:	00003097          	auipc	ra,0x3
    80002dea:	4c0080e7          	jalr	1216(ra) # 800062a6 <release>
}
    80002dee:	60e2                	ld	ra,24(sp)
    80002df0:	6442                	ld	s0,16(sp)
    80002df2:	64a2                	ld	s1,8(sp)
    80002df4:	6902                	ld	s2,0(sp)
    80002df6:	6105                	addi	sp,sp,32
    80002df8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfa:	40bc                	lw	a5,64(s1)
    80002dfc:	dff1                	beqz	a5,80002dd8 <iput+0x26>
    80002dfe:	04a49783          	lh	a5,74(s1)
    80002e02:	fbf9                	bnez	a5,80002dd8 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e04:	01048913          	addi	s2,s1,16
    80002e08:	854a                	mv	a0,s2
    80002e0a:	00001097          	auipc	ra,0x1
    80002e0e:	ab8080e7          	jalr	-1352(ra) # 800038c2 <acquiresleep>
    release(&itable.lock);
    80002e12:	00015517          	auipc	a0,0x15
    80002e16:	96650513          	addi	a0,a0,-1690 # 80017778 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	48c080e7          	jalr	1164(ra) # 800062a6 <release>
    itrunc(ip);
    80002e22:	8526                	mv	a0,s1
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	ee2080e7          	jalr	-286(ra) # 80002d06 <itrunc>
    ip->type = 0;
    80002e2c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e30:	8526                	mv	a0,s1
    80002e32:	00000097          	auipc	ra,0x0
    80002e36:	cfc080e7          	jalr	-772(ra) # 80002b2e <iupdate>
    ip->valid = 0;
    80002e3a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e3e:	854a                	mv	a0,s2
    80002e40:	00001097          	auipc	ra,0x1
    80002e44:	ad8080e7          	jalr	-1320(ra) # 80003918 <releasesleep>
    acquire(&itable.lock);
    80002e48:	00015517          	auipc	a0,0x15
    80002e4c:	93050513          	addi	a0,a0,-1744 # 80017778 <itable>
    80002e50:	00003097          	auipc	ra,0x3
    80002e54:	3a2080e7          	jalr	930(ra) # 800061f2 <acquire>
    80002e58:	b741                	j	80002dd8 <iput+0x26>

0000000080002e5a <iunlockput>:
{
    80002e5a:	1101                	addi	sp,sp,-32
    80002e5c:	ec06                	sd	ra,24(sp)
    80002e5e:	e822                	sd	s0,16(sp)
    80002e60:	e426                	sd	s1,8(sp)
    80002e62:	1000                	addi	s0,sp,32
    80002e64:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e66:	00000097          	auipc	ra,0x0
    80002e6a:	e54080e7          	jalr	-428(ra) # 80002cba <iunlock>
  iput(ip);
    80002e6e:	8526                	mv	a0,s1
    80002e70:	00000097          	auipc	ra,0x0
    80002e74:	f42080e7          	jalr	-190(ra) # 80002db2 <iput>
}
    80002e78:	60e2                	ld	ra,24(sp)
    80002e7a:	6442                	ld	s0,16(sp)
    80002e7c:	64a2                	ld	s1,8(sp)
    80002e7e:	6105                	addi	sp,sp,32
    80002e80:	8082                	ret

0000000080002e82 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e82:	1141                	addi	sp,sp,-16
    80002e84:	e422                	sd	s0,8(sp)
    80002e86:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e88:	411c                	lw	a5,0(a0)
    80002e8a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e8c:	415c                	lw	a5,4(a0)
    80002e8e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e90:	04451783          	lh	a5,68(a0)
    80002e94:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e98:	04a51783          	lh	a5,74(a0)
    80002e9c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ea0:	04c56783          	lwu	a5,76(a0)
    80002ea4:	e99c                	sd	a5,16(a1)
}
    80002ea6:	6422                	ld	s0,8(sp)
    80002ea8:	0141                	addi	sp,sp,16
    80002eaa:	8082                	ret

0000000080002eac <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eac:	457c                	lw	a5,76(a0)
    80002eae:	0ed7e963          	bltu	a5,a3,80002fa0 <readi+0xf4>
{
    80002eb2:	7159                	addi	sp,sp,-112
    80002eb4:	f486                	sd	ra,104(sp)
    80002eb6:	f0a2                	sd	s0,96(sp)
    80002eb8:	eca6                	sd	s1,88(sp)
    80002eba:	e8ca                	sd	s2,80(sp)
    80002ebc:	e4ce                	sd	s3,72(sp)
    80002ebe:	e0d2                	sd	s4,64(sp)
    80002ec0:	fc56                	sd	s5,56(sp)
    80002ec2:	f85a                	sd	s6,48(sp)
    80002ec4:	f45e                	sd	s7,40(sp)
    80002ec6:	f062                	sd	s8,32(sp)
    80002ec8:	ec66                	sd	s9,24(sp)
    80002eca:	e86a                	sd	s10,16(sp)
    80002ecc:	e46e                	sd	s11,8(sp)
    80002ece:	1880                	addi	s0,sp,112
    80002ed0:	8baa                	mv	s7,a0
    80002ed2:	8c2e                	mv	s8,a1
    80002ed4:	8ab2                	mv	s5,a2
    80002ed6:	84b6                	mv	s1,a3
    80002ed8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eda:	9f35                	addw	a4,a4,a3
    return 0;
    80002edc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ede:	0ad76063          	bltu	a4,a3,80002f7e <readi+0xd2>
  if(off + n > ip->size)
    80002ee2:	00e7f463          	bgeu	a5,a4,80002eea <readi+0x3e>
    n = ip->size - off;
    80002ee6:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eea:	0a0b0963          	beqz	s6,80002f9c <readi+0xf0>
    80002eee:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef0:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ef4:	5cfd                	li	s9,-1
    80002ef6:	a82d                	j	80002f30 <readi+0x84>
    80002ef8:	020a1d93          	slli	s11,s4,0x20
    80002efc:	020ddd93          	srli	s11,s11,0x20
    80002f00:	05890613          	addi	a2,s2,88
    80002f04:	86ee                	mv	a3,s11
    80002f06:	963a                	add	a2,a2,a4
    80002f08:	85d6                	mv	a1,s5
    80002f0a:	8562                	mv	a0,s8
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	9ee080e7          	jalr	-1554(ra) # 800018fa <either_copyout>
    80002f14:	05950d63          	beq	a0,s9,80002f6e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f18:	854a                	mv	a0,s2
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	60c080e7          	jalr	1548(ra) # 80002526 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f22:	013a09bb          	addw	s3,s4,s3
    80002f26:	009a04bb          	addw	s1,s4,s1
    80002f2a:	9aee                	add	s5,s5,s11
    80002f2c:	0569f763          	bgeu	s3,s6,80002f7a <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f30:	000ba903          	lw	s2,0(s7)
    80002f34:	00a4d59b          	srliw	a1,s1,0xa
    80002f38:	855e                	mv	a0,s7
    80002f3a:	00000097          	auipc	ra,0x0
    80002f3e:	8b0080e7          	jalr	-1872(ra) # 800027ea <bmap>
    80002f42:	0005059b          	sext.w	a1,a0
    80002f46:	854a                	mv	a0,s2
    80002f48:	fffff097          	auipc	ra,0xfffff
    80002f4c:	4ae080e7          	jalr	1198(ra) # 800023f6 <bread>
    80002f50:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f52:	3ff4f713          	andi	a4,s1,1023
    80002f56:	40ed07bb          	subw	a5,s10,a4
    80002f5a:	413b06bb          	subw	a3,s6,s3
    80002f5e:	8a3e                	mv	s4,a5
    80002f60:	2781                	sext.w	a5,a5
    80002f62:	0006861b          	sext.w	a2,a3
    80002f66:	f8f679e3          	bgeu	a2,a5,80002ef8 <readi+0x4c>
    80002f6a:	8a36                	mv	s4,a3
    80002f6c:	b771                	j	80002ef8 <readi+0x4c>
      brelse(bp);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	5b6080e7          	jalr	1462(ra) # 80002526 <brelse>
      tot = -1;
    80002f78:	59fd                	li	s3,-1
  }
  return tot;
    80002f7a:	0009851b          	sext.w	a0,s3
}
    80002f7e:	70a6                	ld	ra,104(sp)
    80002f80:	7406                	ld	s0,96(sp)
    80002f82:	64e6                	ld	s1,88(sp)
    80002f84:	6946                	ld	s2,80(sp)
    80002f86:	69a6                	ld	s3,72(sp)
    80002f88:	6a06                	ld	s4,64(sp)
    80002f8a:	7ae2                	ld	s5,56(sp)
    80002f8c:	7b42                	ld	s6,48(sp)
    80002f8e:	7ba2                	ld	s7,40(sp)
    80002f90:	7c02                	ld	s8,32(sp)
    80002f92:	6ce2                	ld	s9,24(sp)
    80002f94:	6d42                	ld	s10,16(sp)
    80002f96:	6da2                	ld	s11,8(sp)
    80002f98:	6165                	addi	sp,sp,112
    80002f9a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f9c:	89da                	mv	s3,s6
    80002f9e:	bff1                	j	80002f7a <readi+0xce>
    return 0;
    80002fa0:	4501                	li	a0,0
}
    80002fa2:	8082                	ret

0000000080002fa4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa4:	457c                	lw	a5,76(a0)
    80002fa6:	10d7e863          	bltu	a5,a3,800030b6 <writei+0x112>
{
    80002faa:	7159                	addi	sp,sp,-112
    80002fac:	f486                	sd	ra,104(sp)
    80002fae:	f0a2                	sd	s0,96(sp)
    80002fb0:	eca6                	sd	s1,88(sp)
    80002fb2:	e8ca                	sd	s2,80(sp)
    80002fb4:	e4ce                	sd	s3,72(sp)
    80002fb6:	e0d2                	sd	s4,64(sp)
    80002fb8:	fc56                	sd	s5,56(sp)
    80002fba:	f85a                	sd	s6,48(sp)
    80002fbc:	f45e                	sd	s7,40(sp)
    80002fbe:	f062                	sd	s8,32(sp)
    80002fc0:	ec66                	sd	s9,24(sp)
    80002fc2:	e86a                	sd	s10,16(sp)
    80002fc4:	e46e                	sd	s11,8(sp)
    80002fc6:	1880                	addi	s0,sp,112
    80002fc8:	8b2a                	mv	s6,a0
    80002fca:	8c2e                	mv	s8,a1
    80002fcc:	8ab2                	mv	s5,a2
    80002fce:	8936                	mv	s2,a3
    80002fd0:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fd2:	00e687bb          	addw	a5,a3,a4
    80002fd6:	0ed7e263          	bltu	a5,a3,800030ba <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fda:	00043737          	lui	a4,0x43
    80002fde:	0ef76063          	bltu	a4,a5,800030be <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe2:	0c0b8863          	beqz	s7,800030b2 <writei+0x10e>
    80002fe6:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe8:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fec:	5cfd                	li	s9,-1
    80002fee:	a091                	j	80003032 <writei+0x8e>
    80002ff0:	02099d93          	slli	s11,s3,0x20
    80002ff4:	020ddd93          	srli	s11,s11,0x20
    80002ff8:	05848513          	addi	a0,s1,88
    80002ffc:	86ee                	mv	a3,s11
    80002ffe:	8656                	mv	a2,s5
    80003000:	85e2                	mv	a1,s8
    80003002:	953a                	add	a0,a0,a4
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	94c080e7          	jalr	-1716(ra) # 80001950 <either_copyin>
    8000300c:	07950263          	beq	a0,s9,80003070 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003010:	8526                	mv	a0,s1
    80003012:	00000097          	auipc	ra,0x0
    80003016:	790080e7          	jalr	1936(ra) # 800037a2 <log_write>
    brelse(bp);
    8000301a:	8526                	mv	a0,s1
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	50a080e7          	jalr	1290(ra) # 80002526 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003024:	01498a3b          	addw	s4,s3,s4
    80003028:	0129893b          	addw	s2,s3,s2
    8000302c:	9aee                	add	s5,s5,s11
    8000302e:	057a7663          	bgeu	s4,s7,8000307a <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003032:	000b2483          	lw	s1,0(s6)
    80003036:	00a9559b          	srliw	a1,s2,0xa
    8000303a:	855a                	mv	a0,s6
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	7ae080e7          	jalr	1966(ra) # 800027ea <bmap>
    80003044:	0005059b          	sext.w	a1,a0
    80003048:	8526                	mv	a0,s1
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	3ac080e7          	jalr	940(ra) # 800023f6 <bread>
    80003052:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003054:	3ff97713          	andi	a4,s2,1023
    80003058:	40ed07bb          	subw	a5,s10,a4
    8000305c:	414b86bb          	subw	a3,s7,s4
    80003060:	89be                	mv	s3,a5
    80003062:	2781                	sext.w	a5,a5
    80003064:	0006861b          	sext.w	a2,a3
    80003068:	f8f674e3          	bgeu	a2,a5,80002ff0 <writei+0x4c>
    8000306c:	89b6                	mv	s3,a3
    8000306e:	b749                	j	80002ff0 <writei+0x4c>
      brelse(bp);
    80003070:	8526                	mv	a0,s1
    80003072:	fffff097          	auipc	ra,0xfffff
    80003076:	4b4080e7          	jalr	1204(ra) # 80002526 <brelse>
  }

  if(off > ip->size)
    8000307a:	04cb2783          	lw	a5,76(s6)
    8000307e:	0127f463          	bgeu	a5,s2,80003086 <writei+0xe2>
    ip->size = off;
    80003082:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003086:	855a                	mv	a0,s6
    80003088:	00000097          	auipc	ra,0x0
    8000308c:	aa6080e7          	jalr	-1370(ra) # 80002b2e <iupdate>

  return tot;
    80003090:	000a051b          	sext.w	a0,s4
}
    80003094:	70a6                	ld	ra,104(sp)
    80003096:	7406                	ld	s0,96(sp)
    80003098:	64e6                	ld	s1,88(sp)
    8000309a:	6946                	ld	s2,80(sp)
    8000309c:	69a6                	ld	s3,72(sp)
    8000309e:	6a06                	ld	s4,64(sp)
    800030a0:	7ae2                	ld	s5,56(sp)
    800030a2:	7b42                	ld	s6,48(sp)
    800030a4:	7ba2                	ld	s7,40(sp)
    800030a6:	7c02                	ld	s8,32(sp)
    800030a8:	6ce2                	ld	s9,24(sp)
    800030aa:	6d42                	ld	s10,16(sp)
    800030ac:	6da2                	ld	s11,8(sp)
    800030ae:	6165                	addi	sp,sp,112
    800030b0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b2:	8a5e                	mv	s4,s7
    800030b4:	bfc9                	j	80003086 <writei+0xe2>
    return -1;
    800030b6:	557d                	li	a0,-1
}
    800030b8:	8082                	ret
    return -1;
    800030ba:	557d                	li	a0,-1
    800030bc:	bfe1                	j	80003094 <writei+0xf0>
    return -1;
    800030be:	557d                	li	a0,-1
    800030c0:	bfd1                	j	80003094 <writei+0xf0>

00000000800030c2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030c2:	1141                	addi	sp,sp,-16
    800030c4:	e406                	sd	ra,8(sp)
    800030c6:	e022                	sd	s0,0(sp)
    800030c8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030ca:	4639                	li	a2,14
    800030cc:	ffffd097          	auipc	ra,0xffffd
    800030d0:	1ce080e7          	jalr	462(ra) # 8000029a <strncmp>
}
    800030d4:	60a2                	ld	ra,8(sp)
    800030d6:	6402                	ld	s0,0(sp)
    800030d8:	0141                	addi	sp,sp,16
    800030da:	8082                	ret

00000000800030dc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030dc:	7139                	addi	sp,sp,-64
    800030de:	fc06                	sd	ra,56(sp)
    800030e0:	f822                	sd	s0,48(sp)
    800030e2:	f426                	sd	s1,40(sp)
    800030e4:	f04a                	sd	s2,32(sp)
    800030e6:	ec4e                	sd	s3,24(sp)
    800030e8:	e852                	sd	s4,16(sp)
    800030ea:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030ec:	04451703          	lh	a4,68(a0)
    800030f0:	4785                	li	a5,1
    800030f2:	00f71a63          	bne	a4,a5,80003106 <dirlookup+0x2a>
    800030f6:	892a                	mv	s2,a0
    800030f8:	89ae                	mv	s3,a1
    800030fa:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fc:	457c                	lw	a5,76(a0)
    800030fe:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003100:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003102:	e79d                	bnez	a5,80003130 <dirlookup+0x54>
    80003104:	a8a5                	j	8000317c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003106:	00005517          	auipc	a0,0x5
    8000310a:	60a50513          	addi	a0,a0,1546 # 80008710 <syscall_name+0x1c0>
    8000310e:	00003097          	auipc	ra,0x3
    80003112:	b9a080e7          	jalr	-1126(ra) # 80005ca8 <panic>
      panic("dirlookup read");
    80003116:	00005517          	auipc	a0,0x5
    8000311a:	61250513          	addi	a0,a0,1554 # 80008728 <syscall_name+0x1d8>
    8000311e:	00003097          	auipc	ra,0x3
    80003122:	b8a080e7          	jalr	-1142(ra) # 80005ca8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003126:	24c1                	addiw	s1,s1,16
    80003128:	04c92783          	lw	a5,76(s2)
    8000312c:	04f4f763          	bgeu	s1,a5,8000317a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003130:	4741                	li	a4,16
    80003132:	86a6                	mv	a3,s1
    80003134:	fc040613          	addi	a2,s0,-64
    80003138:	4581                	li	a1,0
    8000313a:	854a                	mv	a0,s2
    8000313c:	00000097          	auipc	ra,0x0
    80003140:	d70080e7          	jalr	-656(ra) # 80002eac <readi>
    80003144:	47c1                	li	a5,16
    80003146:	fcf518e3          	bne	a0,a5,80003116 <dirlookup+0x3a>
    if(de.inum == 0)
    8000314a:	fc045783          	lhu	a5,-64(s0)
    8000314e:	dfe1                	beqz	a5,80003126 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003150:	fc240593          	addi	a1,s0,-62
    80003154:	854e                	mv	a0,s3
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	f6c080e7          	jalr	-148(ra) # 800030c2 <namecmp>
    8000315e:	f561                	bnez	a0,80003126 <dirlookup+0x4a>
      if(poff)
    80003160:	000a0463          	beqz	s4,80003168 <dirlookup+0x8c>
        *poff = off;
    80003164:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003168:	fc045583          	lhu	a1,-64(s0)
    8000316c:	00092503          	lw	a0,0(s2)
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	754080e7          	jalr	1876(ra) # 800028c4 <iget>
    80003178:	a011                	j	8000317c <dirlookup+0xa0>
  return 0;
    8000317a:	4501                	li	a0,0
}
    8000317c:	70e2                	ld	ra,56(sp)
    8000317e:	7442                	ld	s0,48(sp)
    80003180:	74a2                	ld	s1,40(sp)
    80003182:	7902                	ld	s2,32(sp)
    80003184:	69e2                	ld	s3,24(sp)
    80003186:	6a42                	ld	s4,16(sp)
    80003188:	6121                	addi	sp,sp,64
    8000318a:	8082                	ret

000000008000318c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000318c:	711d                	addi	sp,sp,-96
    8000318e:	ec86                	sd	ra,88(sp)
    80003190:	e8a2                	sd	s0,80(sp)
    80003192:	e4a6                	sd	s1,72(sp)
    80003194:	e0ca                	sd	s2,64(sp)
    80003196:	fc4e                	sd	s3,56(sp)
    80003198:	f852                	sd	s4,48(sp)
    8000319a:	f456                	sd	s5,40(sp)
    8000319c:	f05a                	sd	s6,32(sp)
    8000319e:	ec5e                	sd	s7,24(sp)
    800031a0:	e862                	sd	s8,16(sp)
    800031a2:	e466                	sd	s9,8(sp)
    800031a4:	1080                	addi	s0,sp,96
    800031a6:	84aa                	mv	s1,a0
    800031a8:	8b2e                	mv	s6,a1
    800031aa:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031ac:	00054703          	lbu	a4,0(a0)
    800031b0:	02f00793          	li	a5,47
    800031b4:	02f70363          	beq	a4,a5,800031da <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031b8:	ffffe097          	auipc	ra,0xffffe
    800031bc:	cda080e7          	jalr	-806(ra) # 80000e92 <myproc>
    800031c0:	15053503          	ld	a0,336(a0)
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	9f6080e7          	jalr	-1546(ra) # 80002bba <idup>
    800031cc:	89aa                	mv	s3,a0
  while(*path == '/')
    800031ce:	02f00913          	li	s2,47
  len = path - s;
    800031d2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031d4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031d6:	4c05                	li	s8,1
    800031d8:	a865                	j	80003290 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031da:	4585                	li	a1,1
    800031dc:	4505                	li	a0,1
    800031de:	fffff097          	auipc	ra,0xfffff
    800031e2:	6e6080e7          	jalr	1766(ra) # 800028c4 <iget>
    800031e6:	89aa                	mv	s3,a0
    800031e8:	b7dd                	j	800031ce <namex+0x42>
      iunlockput(ip);
    800031ea:	854e                	mv	a0,s3
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	c6e080e7          	jalr	-914(ra) # 80002e5a <iunlockput>
      return 0;
    800031f4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031f6:	854e                	mv	a0,s3
    800031f8:	60e6                	ld	ra,88(sp)
    800031fa:	6446                	ld	s0,80(sp)
    800031fc:	64a6                	ld	s1,72(sp)
    800031fe:	6906                	ld	s2,64(sp)
    80003200:	79e2                	ld	s3,56(sp)
    80003202:	7a42                	ld	s4,48(sp)
    80003204:	7aa2                	ld	s5,40(sp)
    80003206:	7b02                	ld	s6,32(sp)
    80003208:	6be2                	ld	s7,24(sp)
    8000320a:	6c42                	ld	s8,16(sp)
    8000320c:	6ca2                	ld	s9,8(sp)
    8000320e:	6125                	addi	sp,sp,96
    80003210:	8082                	ret
      iunlock(ip);
    80003212:	854e                	mv	a0,s3
    80003214:	00000097          	auipc	ra,0x0
    80003218:	aa6080e7          	jalr	-1370(ra) # 80002cba <iunlock>
      return ip;
    8000321c:	bfe9                	j	800031f6 <namex+0x6a>
      iunlockput(ip);
    8000321e:	854e                	mv	a0,s3
    80003220:	00000097          	auipc	ra,0x0
    80003224:	c3a080e7          	jalr	-966(ra) # 80002e5a <iunlockput>
      return 0;
    80003228:	89d2                	mv	s3,s4
    8000322a:	b7f1                	j	800031f6 <namex+0x6a>
  len = path - s;
    8000322c:	40b48633          	sub	a2,s1,a1
    80003230:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003234:	094cd463          	bge	s9,s4,800032bc <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003238:	4639                	li	a2,14
    8000323a:	8556                	mv	a0,s5
    8000323c:	ffffd097          	auipc	ra,0xffffd
    80003240:	fe6080e7          	jalr	-26(ra) # 80000222 <memmove>
  while(*path == '/')
    80003244:	0004c783          	lbu	a5,0(s1)
    80003248:	01279763          	bne	a5,s2,80003256 <namex+0xca>
    path++;
    8000324c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000324e:	0004c783          	lbu	a5,0(s1)
    80003252:	ff278de3          	beq	a5,s2,8000324c <namex+0xc0>
    ilock(ip);
    80003256:	854e                	mv	a0,s3
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	9a0080e7          	jalr	-1632(ra) # 80002bf8 <ilock>
    if(ip->type != T_DIR){
    80003260:	04499783          	lh	a5,68(s3)
    80003264:	f98793e3          	bne	a5,s8,800031ea <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003268:	000b0563          	beqz	s6,80003272 <namex+0xe6>
    8000326c:	0004c783          	lbu	a5,0(s1)
    80003270:	d3cd                	beqz	a5,80003212 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003272:	865e                	mv	a2,s7
    80003274:	85d6                	mv	a1,s5
    80003276:	854e                	mv	a0,s3
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	e64080e7          	jalr	-412(ra) # 800030dc <dirlookup>
    80003280:	8a2a                	mv	s4,a0
    80003282:	dd51                	beqz	a0,8000321e <namex+0x92>
    iunlockput(ip);
    80003284:	854e                	mv	a0,s3
    80003286:	00000097          	auipc	ra,0x0
    8000328a:	bd4080e7          	jalr	-1068(ra) # 80002e5a <iunlockput>
    ip = next;
    8000328e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	05279763          	bne	a5,s2,800032e2 <namex+0x156>
    path++;
    80003298:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000329a:	0004c783          	lbu	a5,0(s1)
    8000329e:	ff278de3          	beq	a5,s2,80003298 <namex+0x10c>
  if(*path == 0)
    800032a2:	c79d                	beqz	a5,800032d0 <namex+0x144>
    path++;
    800032a4:	85a6                	mv	a1,s1
  len = path - s;
    800032a6:	8a5e                	mv	s4,s7
    800032a8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032aa:	01278963          	beq	a5,s2,800032bc <namex+0x130>
    800032ae:	dfbd                	beqz	a5,8000322c <namex+0xa0>
    path++;
    800032b0:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032b2:	0004c783          	lbu	a5,0(s1)
    800032b6:	ff279ce3          	bne	a5,s2,800032ae <namex+0x122>
    800032ba:	bf8d                	j	8000322c <namex+0xa0>
    memmove(name, s, len);
    800032bc:	2601                	sext.w	a2,a2
    800032be:	8556                	mv	a0,s5
    800032c0:	ffffd097          	auipc	ra,0xffffd
    800032c4:	f62080e7          	jalr	-158(ra) # 80000222 <memmove>
    name[len] = 0;
    800032c8:	9a56                	add	s4,s4,s5
    800032ca:	000a0023          	sb	zero,0(s4)
    800032ce:	bf9d                	j	80003244 <namex+0xb8>
  if(nameiparent){
    800032d0:	f20b03e3          	beqz	s6,800031f6 <namex+0x6a>
    iput(ip);
    800032d4:	854e                	mv	a0,s3
    800032d6:	00000097          	auipc	ra,0x0
    800032da:	adc080e7          	jalr	-1316(ra) # 80002db2 <iput>
    return 0;
    800032de:	4981                	li	s3,0
    800032e0:	bf19                	j	800031f6 <namex+0x6a>
  if(*path == 0)
    800032e2:	d7fd                	beqz	a5,800032d0 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032e4:	0004c783          	lbu	a5,0(s1)
    800032e8:	85a6                	mv	a1,s1
    800032ea:	b7d1                	j	800032ae <namex+0x122>

00000000800032ec <dirlink>:
{
    800032ec:	7139                	addi	sp,sp,-64
    800032ee:	fc06                	sd	ra,56(sp)
    800032f0:	f822                	sd	s0,48(sp)
    800032f2:	f426                	sd	s1,40(sp)
    800032f4:	f04a                	sd	s2,32(sp)
    800032f6:	ec4e                	sd	s3,24(sp)
    800032f8:	e852                	sd	s4,16(sp)
    800032fa:	0080                	addi	s0,sp,64
    800032fc:	892a                	mv	s2,a0
    800032fe:	8a2e                	mv	s4,a1
    80003300:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003302:	4601                	li	a2,0
    80003304:	00000097          	auipc	ra,0x0
    80003308:	dd8080e7          	jalr	-552(ra) # 800030dc <dirlookup>
    8000330c:	e93d                	bnez	a0,80003382 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000330e:	04c92483          	lw	s1,76(s2)
    80003312:	c49d                	beqz	s1,80003340 <dirlink+0x54>
    80003314:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003316:	4741                	li	a4,16
    80003318:	86a6                	mv	a3,s1
    8000331a:	fc040613          	addi	a2,s0,-64
    8000331e:	4581                	li	a1,0
    80003320:	854a                	mv	a0,s2
    80003322:	00000097          	auipc	ra,0x0
    80003326:	b8a080e7          	jalr	-1142(ra) # 80002eac <readi>
    8000332a:	47c1                	li	a5,16
    8000332c:	06f51163          	bne	a0,a5,8000338e <dirlink+0xa2>
    if(de.inum == 0)
    80003330:	fc045783          	lhu	a5,-64(s0)
    80003334:	c791                	beqz	a5,80003340 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003336:	24c1                	addiw	s1,s1,16
    80003338:	04c92783          	lw	a5,76(s2)
    8000333c:	fcf4ede3          	bltu	s1,a5,80003316 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003340:	4639                	li	a2,14
    80003342:	85d2                	mv	a1,s4
    80003344:	fc240513          	addi	a0,s0,-62
    80003348:	ffffd097          	auipc	ra,0xffffd
    8000334c:	f8e080e7          	jalr	-114(ra) # 800002d6 <strncpy>
  de.inum = inum;
    80003350:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003354:	4741                	li	a4,16
    80003356:	86a6                	mv	a3,s1
    80003358:	fc040613          	addi	a2,s0,-64
    8000335c:	4581                	li	a1,0
    8000335e:	854a                	mv	a0,s2
    80003360:	00000097          	auipc	ra,0x0
    80003364:	c44080e7          	jalr	-956(ra) # 80002fa4 <writei>
    80003368:	872a                	mv	a4,a0
    8000336a:	47c1                	li	a5,16
  return 0;
    8000336c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000336e:	02f71863          	bne	a4,a5,8000339e <dirlink+0xb2>
}
    80003372:	70e2                	ld	ra,56(sp)
    80003374:	7442                	ld	s0,48(sp)
    80003376:	74a2                	ld	s1,40(sp)
    80003378:	7902                	ld	s2,32(sp)
    8000337a:	69e2                	ld	s3,24(sp)
    8000337c:	6a42                	ld	s4,16(sp)
    8000337e:	6121                	addi	sp,sp,64
    80003380:	8082                	ret
    iput(ip);
    80003382:	00000097          	auipc	ra,0x0
    80003386:	a30080e7          	jalr	-1488(ra) # 80002db2 <iput>
    return -1;
    8000338a:	557d                	li	a0,-1
    8000338c:	b7dd                	j	80003372 <dirlink+0x86>
      panic("dirlink read");
    8000338e:	00005517          	auipc	a0,0x5
    80003392:	3aa50513          	addi	a0,a0,938 # 80008738 <syscall_name+0x1e8>
    80003396:	00003097          	auipc	ra,0x3
    8000339a:	912080e7          	jalr	-1774(ra) # 80005ca8 <panic>
    panic("dirlink");
    8000339e:	00005517          	auipc	a0,0x5
    800033a2:	4a250513          	addi	a0,a0,1186 # 80008840 <syscall_name+0x2f0>
    800033a6:	00003097          	auipc	ra,0x3
    800033aa:	902080e7          	jalr	-1790(ra) # 80005ca8 <panic>

00000000800033ae <namei>:

struct inode*
namei(char *path)
{
    800033ae:	1101                	addi	sp,sp,-32
    800033b0:	ec06                	sd	ra,24(sp)
    800033b2:	e822                	sd	s0,16(sp)
    800033b4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033b6:	fe040613          	addi	a2,s0,-32
    800033ba:	4581                	li	a1,0
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	dd0080e7          	jalr	-560(ra) # 8000318c <namex>
}
    800033c4:	60e2                	ld	ra,24(sp)
    800033c6:	6442                	ld	s0,16(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret

00000000800033cc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033cc:	1141                	addi	sp,sp,-16
    800033ce:	e406                	sd	ra,8(sp)
    800033d0:	e022                	sd	s0,0(sp)
    800033d2:	0800                	addi	s0,sp,16
    800033d4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033d6:	4585                	li	a1,1
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	db4080e7          	jalr	-588(ra) # 8000318c <namex>
}
    800033e0:	60a2                	ld	ra,8(sp)
    800033e2:	6402                	ld	s0,0(sp)
    800033e4:	0141                	addi	sp,sp,16
    800033e6:	8082                	ret

00000000800033e8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	e04a                	sd	s2,0(sp)
    800033f2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033f4:	00016917          	auipc	s2,0x16
    800033f8:	e2c90913          	addi	s2,s2,-468 # 80019220 <log>
    800033fc:	01892583          	lw	a1,24(s2)
    80003400:	02892503          	lw	a0,40(s2)
    80003404:	fffff097          	auipc	ra,0xfffff
    80003408:	ff2080e7          	jalr	-14(ra) # 800023f6 <bread>
    8000340c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000340e:	02c92683          	lw	a3,44(s2)
    80003412:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003414:	02d05763          	blez	a3,80003442 <write_head+0x5a>
    80003418:	00016797          	auipc	a5,0x16
    8000341c:	e3878793          	addi	a5,a5,-456 # 80019250 <log+0x30>
    80003420:	05c50713          	addi	a4,a0,92
    80003424:	36fd                	addiw	a3,a3,-1
    80003426:	1682                	slli	a3,a3,0x20
    80003428:	9281                	srli	a3,a3,0x20
    8000342a:	068a                	slli	a3,a3,0x2
    8000342c:	00016617          	auipc	a2,0x16
    80003430:	e2860613          	addi	a2,a2,-472 # 80019254 <log+0x34>
    80003434:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003436:	4390                	lw	a2,0(a5)
    80003438:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000343a:	0791                	addi	a5,a5,4
    8000343c:	0711                	addi	a4,a4,4
    8000343e:	fed79ce3          	bne	a5,a3,80003436 <write_head+0x4e>
  }
  bwrite(buf);
    80003442:	8526                	mv	a0,s1
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	0a4080e7          	jalr	164(ra) # 800024e8 <bwrite>
  brelse(buf);
    8000344c:	8526                	mv	a0,s1
    8000344e:	fffff097          	auipc	ra,0xfffff
    80003452:	0d8080e7          	jalr	216(ra) # 80002526 <brelse>
}
    80003456:	60e2                	ld	ra,24(sp)
    80003458:	6442                	ld	s0,16(sp)
    8000345a:	64a2                	ld	s1,8(sp)
    8000345c:	6902                	ld	s2,0(sp)
    8000345e:	6105                	addi	sp,sp,32
    80003460:	8082                	ret

0000000080003462 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003462:	00016797          	auipc	a5,0x16
    80003466:	dea7a783          	lw	a5,-534(a5) # 8001924c <log+0x2c>
    8000346a:	0af05d63          	blez	a5,80003524 <install_trans+0xc2>
{
    8000346e:	7139                	addi	sp,sp,-64
    80003470:	fc06                	sd	ra,56(sp)
    80003472:	f822                	sd	s0,48(sp)
    80003474:	f426                	sd	s1,40(sp)
    80003476:	f04a                	sd	s2,32(sp)
    80003478:	ec4e                	sd	s3,24(sp)
    8000347a:	e852                	sd	s4,16(sp)
    8000347c:	e456                	sd	s5,8(sp)
    8000347e:	e05a                	sd	s6,0(sp)
    80003480:	0080                	addi	s0,sp,64
    80003482:	8b2a                	mv	s6,a0
    80003484:	00016a97          	auipc	s5,0x16
    80003488:	dcca8a93          	addi	s5,s5,-564 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000348c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000348e:	00016997          	auipc	s3,0x16
    80003492:	d9298993          	addi	s3,s3,-622 # 80019220 <log>
    80003496:	a035                	j	800034c2 <install_trans+0x60>
      bunpin(dbuf);
    80003498:	8526                	mv	a0,s1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	166080e7          	jalr	358(ra) # 80002600 <bunpin>
    brelse(lbuf);
    800034a2:	854a                	mv	a0,s2
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	082080e7          	jalr	130(ra) # 80002526 <brelse>
    brelse(dbuf);
    800034ac:	8526                	mv	a0,s1
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	078080e7          	jalr	120(ra) # 80002526 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b6:	2a05                	addiw	s4,s4,1
    800034b8:	0a91                	addi	s5,s5,4
    800034ba:	02c9a783          	lw	a5,44(s3)
    800034be:	04fa5963          	bge	s4,a5,80003510 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c2:	0189a583          	lw	a1,24(s3)
    800034c6:	014585bb          	addw	a1,a1,s4
    800034ca:	2585                	addiw	a1,a1,1
    800034cc:	0289a503          	lw	a0,40(s3)
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	f26080e7          	jalr	-218(ra) # 800023f6 <bread>
    800034d8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034da:	000aa583          	lw	a1,0(s5)
    800034de:	0289a503          	lw	a0,40(s3)
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	f14080e7          	jalr	-236(ra) # 800023f6 <bread>
    800034ea:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ec:	40000613          	li	a2,1024
    800034f0:	05890593          	addi	a1,s2,88
    800034f4:	05850513          	addi	a0,a0,88
    800034f8:	ffffd097          	auipc	ra,0xffffd
    800034fc:	d2a080e7          	jalr	-726(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003500:	8526                	mv	a0,s1
    80003502:	fffff097          	auipc	ra,0xfffff
    80003506:	fe6080e7          	jalr	-26(ra) # 800024e8 <bwrite>
    if(recovering == 0)
    8000350a:	f80b1ce3          	bnez	s6,800034a2 <install_trans+0x40>
    8000350e:	b769                	j	80003498 <install_trans+0x36>
}
    80003510:	70e2                	ld	ra,56(sp)
    80003512:	7442                	ld	s0,48(sp)
    80003514:	74a2                	ld	s1,40(sp)
    80003516:	7902                	ld	s2,32(sp)
    80003518:	69e2                	ld	s3,24(sp)
    8000351a:	6a42                	ld	s4,16(sp)
    8000351c:	6aa2                	ld	s5,8(sp)
    8000351e:	6b02                	ld	s6,0(sp)
    80003520:	6121                	addi	sp,sp,64
    80003522:	8082                	ret
    80003524:	8082                	ret

0000000080003526 <initlog>:
{
    80003526:	7179                	addi	sp,sp,-48
    80003528:	f406                	sd	ra,40(sp)
    8000352a:	f022                	sd	s0,32(sp)
    8000352c:	ec26                	sd	s1,24(sp)
    8000352e:	e84a                	sd	s2,16(sp)
    80003530:	e44e                	sd	s3,8(sp)
    80003532:	1800                	addi	s0,sp,48
    80003534:	892a                	mv	s2,a0
    80003536:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003538:	00016497          	auipc	s1,0x16
    8000353c:	ce848493          	addi	s1,s1,-792 # 80019220 <log>
    80003540:	00005597          	auipc	a1,0x5
    80003544:	20858593          	addi	a1,a1,520 # 80008748 <syscall_name+0x1f8>
    80003548:	8526                	mv	a0,s1
    8000354a:	00003097          	auipc	ra,0x3
    8000354e:	c18080e7          	jalr	-1000(ra) # 80006162 <initlock>
  log.start = sb->logstart;
    80003552:	0149a583          	lw	a1,20(s3)
    80003556:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003558:	0109a783          	lw	a5,16(s3)
    8000355c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000355e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003562:	854a                	mv	a0,s2
    80003564:	fffff097          	auipc	ra,0xfffff
    80003568:	e92080e7          	jalr	-366(ra) # 800023f6 <bread>
  log.lh.n = lh->n;
    8000356c:	4d3c                	lw	a5,88(a0)
    8000356e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003570:	02f05563          	blez	a5,8000359a <initlog+0x74>
    80003574:	05c50713          	addi	a4,a0,92
    80003578:	00016697          	auipc	a3,0x16
    8000357c:	cd868693          	addi	a3,a3,-808 # 80019250 <log+0x30>
    80003580:	37fd                	addiw	a5,a5,-1
    80003582:	1782                	slli	a5,a5,0x20
    80003584:	9381                	srli	a5,a5,0x20
    80003586:	078a                	slli	a5,a5,0x2
    80003588:	06050613          	addi	a2,a0,96
    8000358c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000358e:	4310                	lw	a2,0(a4)
    80003590:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003592:	0711                	addi	a4,a4,4
    80003594:	0691                	addi	a3,a3,4
    80003596:	fef71ce3          	bne	a4,a5,8000358e <initlog+0x68>
  brelse(buf);
    8000359a:	fffff097          	auipc	ra,0xfffff
    8000359e:	f8c080e7          	jalr	-116(ra) # 80002526 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035a2:	4505                	li	a0,1
    800035a4:	00000097          	auipc	ra,0x0
    800035a8:	ebe080e7          	jalr	-322(ra) # 80003462 <install_trans>
  log.lh.n = 0;
    800035ac:	00016797          	auipc	a5,0x16
    800035b0:	ca07a023          	sw	zero,-864(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035b4:	00000097          	auipc	ra,0x0
    800035b8:	e34080e7          	jalr	-460(ra) # 800033e8 <write_head>
}
    800035bc:	70a2                	ld	ra,40(sp)
    800035be:	7402                	ld	s0,32(sp)
    800035c0:	64e2                	ld	s1,24(sp)
    800035c2:	6942                	ld	s2,16(sp)
    800035c4:	69a2                	ld	s3,8(sp)
    800035c6:	6145                	addi	sp,sp,48
    800035c8:	8082                	ret

00000000800035ca <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035ca:	1101                	addi	sp,sp,-32
    800035cc:	ec06                	sd	ra,24(sp)
    800035ce:	e822                	sd	s0,16(sp)
    800035d0:	e426                	sd	s1,8(sp)
    800035d2:	e04a                	sd	s2,0(sp)
    800035d4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035d6:	00016517          	auipc	a0,0x16
    800035da:	c4a50513          	addi	a0,a0,-950 # 80019220 <log>
    800035de:	00003097          	auipc	ra,0x3
    800035e2:	c14080e7          	jalr	-1004(ra) # 800061f2 <acquire>
  while(1){
    if(log.committing){
    800035e6:	00016497          	auipc	s1,0x16
    800035ea:	c3a48493          	addi	s1,s1,-966 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ee:	4979                	li	s2,30
    800035f0:	a039                	j	800035fe <begin_op+0x34>
      sleep(&log, &log.lock);
    800035f2:	85a6                	mv	a1,s1
    800035f4:	8526                	mv	a0,s1
    800035f6:	ffffe097          	auipc	ra,0xffffe
    800035fa:	f60080e7          	jalr	-160(ra) # 80001556 <sleep>
    if(log.committing){
    800035fe:	50dc                	lw	a5,36(s1)
    80003600:	fbed                	bnez	a5,800035f2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003602:	509c                	lw	a5,32(s1)
    80003604:	0017871b          	addiw	a4,a5,1
    80003608:	0007069b          	sext.w	a3,a4
    8000360c:	0027179b          	slliw	a5,a4,0x2
    80003610:	9fb9                	addw	a5,a5,a4
    80003612:	0017979b          	slliw	a5,a5,0x1
    80003616:	54d8                	lw	a4,44(s1)
    80003618:	9fb9                	addw	a5,a5,a4
    8000361a:	00f95963          	bge	s2,a5,8000362c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000361e:	85a6                	mv	a1,s1
    80003620:	8526                	mv	a0,s1
    80003622:	ffffe097          	auipc	ra,0xffffe
    80003626:	f34080e7          	jalr	-204(ra) # 80001556 <sleep>
    8000362a:	bfd1                	j	800035fe <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000362c:	00016517          	auipc	a0,0x16
    80003630:	bf450513          	addi	a0,a0,-1036 # 80019220 <log>
    80003634:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003636:	00003097          	auipc	ra,0x3
    8000363a:	c70080e7          	jalr	-912(ra) # 800062a6 <release>
      break;
    }
  }
}
    8000363e:	60e2                	ld	ra,24(sp)
    80003640:	6442                	ld	s0,16(sp)
    80003642:	64a2                	ld	s1,8(sp)
    80003644:	6902                	ld	s2,0(sp)
    80003646:	6105                	addi	sp,sp,32
    80003648:	8082                	ret

000000008000364a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000364a:	7139                	addi	sp,sp,-64
    8000364c:	fc06                	sd	ra,56(sp)
    8000364e:	f822                	sd	s0,48(sp)
    80003650:	f426                	sd	s1,40(sp)
    80003652:	f04a                	sd	s2,32(sp)
    80003654:	ec4e                	sd	s3,24(sp)
    80003656:	e852                	sd	s4,16(sp)
    80003658:	e456                	sd	s5,8(sp)
    8000365a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000365c:	00016497          	auipc	s1,0x16
    80003660:	bc448493          	addi	s1,s1,-1084 # 80019220 <log>
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	b8c080e7          	jalr	-1140(ra) # 800061f2 <acquire>
  log.outstanding -= 1;
    8000366e:	509c                	lw	a5,32(s1)
    80003670:	37fd                	addiw	a5,a5,-1
    80003672:	0007891b          	sext.w	s2,a5
    80003676:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003678:	50dc                	lw	a5,36(s1)
    8000367a:	efb9                	bnez	a5,800036d8 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000367c:	06091663          	bnez	s2,800036e8 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003680:	00016497          	auipc	s1,0x16
    80003684:	ba048493          	addi	s1,s1,-1120 # 80019220 <log>
    80003688:	4785                	li	a5,1
    8000368a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000368c:	8526                	mv	a0,s1
    8000368e:	00003097          	auipc	ra,0x3
    80003692:	c18080e7          	jalr	-1000(ra) # 800062a6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003696:	54dc                	lw	a5,44(s1)
    80003698:	06f04763          	bgtz	a5,80003706 <end_op+0xbc>
    acquire(&log.lock);
    8000369c:	00016497          	auipc	s1,0x16
    800036a0:	b8448493          	addi	s1,s1,-1148 # 80019220 <log>
    800036a4:	8526                	mv	a0,s1
    800036a6:	00003097          	auipc	ra,0x3
    800036aa:	b4c080e7          	jalr	-1204(ra) # 800061f2 <acquire>
    log.committing = 0;
    800036ae:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036b2:	8526                	mv	a0,s1
    800036b4:	ffffe097          	auipc	ra,0xffffe
    800036b8:	02e080e7          	jalr	46(ra) # 800016e2 <wakeup>
    release(&log.lock);
    800036bc:	8526                	mv	a0,s1
    800036be:	00003097          	auipc	ra,0x3
    800036c2:	be8080e7          	jalr	-1048(ra) # 800062a6 <release>
}
    800036c6:	70e2                	ld	ra,56(sp)
    800036c8:	7442                	ld	s0,48(sp)
    800036ca:	74a2                	ld	s1,40(sp)
    800036cc:	7902                	ld	s2,32(sp)
    800036ce:	69e2                	ld	s3,24(sp)
    800036d0:	6a42                	ld	s4,16(sp)
    800036d2:	6aa2                	ld	s5,8(sp)
    800036d4:	6121                	addi	sp,sp,64
    800036d6:	8082                	ret
    panic("log.committing");
    800036d8:	00005517          	auipc	a0,0x5
    800036dc:	07850513          	addi	a0,a0,120 # 80008750 <syscall_name+0x200>
    800036e0:	00002097          	auipc	ra,0x2
    800036e4:	5c8080e7          	jalr	1480(ra) # 80005ca8 <panic>
    wakeup(&log);
    800036e8:	00016497          	auipc	s1,0x16
    800036ec:	b3848493          	addi	s1,s1,-1224 # 80019220 <log>
    800036f0:	8526                	mv	a0,s1
    800036f2:	ffffe097          	auipc	ra,0xffffe
    800036f6:	ff0080e7          	jalr	-16(ra) # 800016e2 <wakeup>
  release(&log.lock);
    800036fa:	8526                	mv	a0,s1
    800036fc:	00003097          	auipc	ra,0x3
    80003700:	baa080e7          	jalr	-1110(ra) # 800062a6 <release>
  if(do_commit){
    80003704:	b7c9                	j	800036c6 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003706:	00016a97          	auipc	s5,0x16
    8000370a:	b4aa8a93          	addi	s5,s5,-1206 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000370e:	00016a17          	auipc	s4,0x16
    80003712:	b12a0a13          	addi	s4,s4,-1262 # 80019220 <log>
    80003716:	018a2583          	lw	a1,24(s4)
    8000371a:	012585bb          	addw	a1,a1,s2
    8000371e:	2585                	addiw	a1,a1,1
    80003720:	028a2503          	lw	a0,40(s4)
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	cd2080e7          	jalr	-814(ra) # 800023f6 <bread>
    8000372c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000372e:	000aa583          	lw	a1,0(s5)
    80003732:	028a2503          	lw	a0,40(s4)
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	cc0080e7          	jalr	-832(ra) # 800023f6 <bread>
    8000373e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003740:	40000613          	li	a2,1024
    80003744:	05850593          	addi	a1,a0,88
    80003748:	05848513          	addi	a0,s1,88
    8000374c:	ffffd097          	auipc	ra,0xffffd
    80003750:	ad6080e7          	jalr	-1322(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    80003754:	8526                	mv	a0,s1
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	d92080e7          	jalr	-622(ra) # 800024e8 <bwrite>
    brelse(from);
    8000375e:	854e                	mv	a0,s3
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	dc6080e7          	jalr	-570(ra) # 80002526 <brelse>
    brelse(to);
    80003768:	8526                	mv	a0,s1
    8000376a:	fffff097          	auipc	ra,0xfffff
    8000376e:	dbc080e7          	jalr	-580(ra) # 80002526 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003772:	2905                	addiw	s2,s2,1
    80003774:	0a91                	addi	s5,s5,4
    80003776:	02ca2783          	lw	a5,44(s4)
    8000377a:	f8f94ee3          	blt	s2,a5,80003716 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	c6a080e7          	jalr	-918(ra) # 800033e8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003786:	4501                	li	a0,0
    80003788:	00000097          	auipc	ra,0x0
    8000378c:	cda080e7          	jalr	-806(ra) # 80003462 <install_trans>
    log.lh.n = 0;
    80003790:	00016797          	auipc	a5,0x16
    80003794:	aa07ae23          	sw	zero,-1348(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003798:	00000097          	auipc	ra,0x0
    8000379c:	c50080e7          	jalr	-944(ra) # 800033e8 <write_head>
    800037a0:	bdf5                	j	8000369c <end_op+0x52>

00000000800037a2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037a2:	1101                	addi	sp,sp,-32
    800037a4:	ec06                	sd	ra,24(sp)
    800037a6:	e822                	sd	s0,16(sp)
    800037a8:	e426                	sd	s1,8(sp)
    800037aa:	e04a                	sd	s2,0(sp)
    800037ac:	1000                	addi	s0,sp,32
    800037ae:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037b0:	00016917          	auipc	s2,0x16
    800037b4:	a7090913          	addi	s2,s2,-1424 # 80019220 <log>
    800037b8:	854a                	mv	a0,s2
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	a38080e7          	jalr	-1480(ra) # 800061f2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037c2:	02c92603          	lw	a2,44(s2)
    800037c6:	47f5                	li	a5,29
    800037c8:	06c7c563          	blt	a5,a2,80003832 <log_write+0x90>
    800037cc:	00016797          	auipc	a5,0x16
    800037d0:	a707a783          	lw	a5,-1424(a5) # 8001923c <log+0x1c>
    800037d4:	37fd                	addiw	a5,a5,-1
    800037d6:	04f65e63          	bge	a2,a5,80003832 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037da:	00016797          	auipc	a5,0x16
    800037de:	a667a783          	lw	a5,-1434(a5) # 80019240 <log+0x20>
    800037e2:	06f05063          	blez	a5,80003842 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037e6:	4781                	li	a5,0
    800037e8:	06c05563          	blez	a2,80003852 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ec:	44cc                	lw	a1,12(s1)
    800037ee:	00016717          	auipc	a4,0x16
    800037f2:	a6270713          	addi	a4,a4,-1438 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037f6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f8:	4314                	lw	a3,0(a4)
    800037fa:	04b68c63          	beq	a3,a1,80003852 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037fe:	2785                	addiw	a5,a5,1
    80003800:	0711                	addi	a4,a4,4
    80003802:	fef61be3          	bne	a2,a5,800037f8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003806:	0621                	addi	a2,a2,8
    80003808:	060a                	slli	a2,a2,0x2
    8000380a:	00016797          	auipc	a5,0x16
    8000380e:	a1678793          	addi	a5,a5,-1514 # 80019220 <log>
    80003812:	963e                	add	a2,a2,a5
    80003814:	44dc                	lw	a5,12(s1)
    80003816:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003818:	8526                	mv	a0,s1
    8000381a:	fffff097          	auipc	ra,0xfffff
    8000381e:	daa080e7          	jalr	-598(ra) # 800025c4 <bpin>
    log.lh.n++;
    80003822:	00016717          	auipc	a4,0x16
    80003826:	9fe70713          	addi	a4,a4,-1538 # 80019220 <log>
    8000382a:	575c                	lw	a5,44(a4)
    8000382c:	2785                	addiw	a5,a5,1
    8000382e:	d75c                	sw	a5,44(a4)
    80003830:	a835                	j	8000386c <log_write+0xca>
    panic("too big a transaction");
    80003832:	00005517          	auipc	a0,0x5
    80003836:	f2e50513          	addi	a0,a0,-210 # 80008760 <syscall_name+0x210>
    8000383a:	00002097          	auipc	ra,0x2
    8000383e:	46e080e7          	jalr	1134(ra) # 80005ca8 <panic>
    panic("log_write outside of trans");
    80003842:	00005517          	auipc	a0,0x5
    80003846:	f3650513          	addi	a0,a0,-202 # 80008778 <syscall_name+0x228>
    8000384a:	00002097          	auipc	ra,0x2
    8000384e:	45e080e7          	jalr	1118(ra) # 80005ca8 <panic>
  log.lh.block[i] = b->blockno;
    80003852:	00878713          	addi	a4,a5,8
    80003856:	00271693          	slli	a3,a4,0x2
    8000385a:	00016717          	auipc	a4,0x16
    8000385e:	9c670713          	addi	a4,a4,-1594 # 80019220 <log>
    80003862:	9736                	add	a4,a4,a3
    80003864:	44d4                	lw	a3,12(s1)
    80003866:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003868:	faf608e3          	beq	a2,a5,80003818 <log_write+0x76>
  }
  release(&log.lock);
    8000386c:	00016517          	auipc	a0,0x16
    80003870:	9b450513          	addi	a0,a0,-1612 # 80019220 <log>
    80003874:	00003097          	auipc	ra,0x3
    80003878:	a32080e7          	jalr	-1486(ra) # 800062a6 <release>
}
    8000387c:	60e2                	ld	ra,24(sp)
    8000387e:	6442                	ld	s0,16(sp)
    80003880:	64a2                	ld	s1,8(sp)
    80003882:	6902                	ld	s2,0(sp)
    80003884:	6105                	addi	sp,sp,32
    80003886:	8082                	ret

0000000080003888 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003888:	1101                	addi	sp,sp,-32
    8000388a:	ec06                	sd	ra,24(sp)
    8000388c:	e822                	sd	s0,16(sp)
    8000388e:	e426                	sd	s1,8(sp)
    80003890:	e04a                	sd	s2,0(sp)
    80003892:	1000                	addi	s0,sp,32
    80003894:	84aa                	mv	s1,a0
    80003896:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003898:	00005597          	auipc	a1,0x5
    8000389c:	f0058593          	addi	a1,a1,-256 # 80008798 <syscall_name+0x248>
    800038a0:	0521                	addi	a0,a0,8
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	8c0080e7          	jalr	-1856(ra) # 80006162 <initlock>
  lk->name = name;
    800038aa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038ae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b2:	0204a423          	sw	zero,40(s1)
}
    800038b6:	60e2                	ld	ra,24(sp)
    800038b8:	6442                	ld	s0,16(sp)
    800038ba:	64a2                	ld	s1,8(sp)
    800038bc:	6902                	ld	s2,0(sp)
    800038be:	6105                	addi	sp,sp,32
    800038c0:	8082                	ret

00000000800038c2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038c2:	1101                	addi	sp,sp,-32
    800038c4:	ec06                	sd	ra,24(sp)
    800038c6:	e822                	sd	s0,16(sp)
    800038c8:	e426                	sd	s1,8(sp)
    800038ca:	e04a                	sd	s2,0(sp)
    800038cc:	1000                	addi	s0,sp,32
    800038ce:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d0:	00850913          	addi	s2,a0,8
    800038d4:	854a                	mv	a0,s2
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	91c080e7          	jalr	-1764(ra) # 800061f2 <acquire>
  while (lk->locked) {
    800038de:	409c                	lw	a5,0(s1)
    800038e0:	cb89                	beqz	a5,800038f2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038e2:	85ca                	mv	a1,s2
    800038e4:	8526                	mv	a0,s1
    800038e6:	ffffe097          	auipc	ra,0xffffe
    800038ea:	c70080e7          	jalr	-912(ra) # 80001556 <sleep>
  while (lk->locked) {
    800038ee:	409c                	lw	a5,0(s1)
    800038f0:	fbed                	bnez	a5,800038e2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038f2:	4785                	li	a5,1
    800038f4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038f6:	ffffd097          	auipc	ra,0xffffd
    800038fa:	59c080e7          	jalr	1436(ra) # 80000e92 <myproc>
    800038fe:	591c                	lw	a5,48(a0)
    80003900:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003902:	854a                	mv	a0,s2
    80003904:	00003097          	auipc	ra,0x3
    80003908:	9a2080e7          	jalr	-1630(ra) # 800062a6 <release>
}
    8000390c:	60e2                	ld	ra,24(sp)
    8000390e:	6442                	ld	s0,16(sp)
    80003910:	64a2                	ld	s1,8(sp)
    80003912:	6902                	ld	s2,0(sp)
    80003914:	6105                	addi	sp,sp,32
    80003916:	8082                	ret

0000000080003918 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003918:	1101                	addi	sp,sp,-32
    8000391a:	ec06                	sd	ra,24(sp)
    8000391c:	e822                	sd	s0,16(sp)
    8000391e:	e426                	sd	s1,8(sp)
    80003920:	e04a                	sd	s2,0(sp)
    80003922:	1000                	addi	s0,sp,32
    80003924:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003926:	00850913          	addi	s2,a0,8
    8000392a:	854a                	mv	a0,s2
    8000392c:	00003097          	auipc	ra,0x3
    80003930:	8c6080e7          	jalr	-1850(ra) # 800061f2 <acquire>
  lk->locked = 0;
    80003934:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003938:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000393c:	8526                	mv	a0,s1
    8000393e:	ffffe097          	auipc	ra,0xffffe
    80003942:	da4080e7          	jalr	-604(ra) # 800016e2 <wakeup>
  release(&lk->lk);
    80003946:	854a                	mv	a0,s2
    80003948:	00003097          	auipc	ra,0x3
    8000394c:	95e080e7          	jalr	-1698(ra) # 800062a6 <release>
}
    80003950:	60e2                	ld	ra,24(sp)
    80003952:	6442                	ld	s0,16(sp)
    80003954:	64a2                	ld	s1,8(sp)
    80003956:	6902                	ld	s2,0(sp)
    80003958:	6105                	addi	sp,sp,32
    8000395a:	8082                	ret

000000008000395c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000395c:	7179                	addi	sp,sp,-48
    8000395e:	f406                	sd	ra,40(sp)
    80003960:	f022                	sd	s0,32(sp)
    80003962:	ec26                	sd	s1,24(sp)
    80003964:	e84a                	sd	s2,16(sp)
    80003966:	e44e                	sd	s3,8(sp)
    80003968:	1800                	addi	s0,sp,48
    8000396a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000396c:	00850913          	addi	s2,a0,8
    80003970:	854a                	mv	a0,s2
    80003972:	00003097          	auipc	ra,0x3
    80003976:	880080e7          	jalr	-1920(ra) # 800061f2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397a:	409c                	lw	a5,0(s1)
    8000397c:	ef99                	bnez	a5,8000399a <holdingsleep+0x3e>
    8000397e:	4481                	li	s1,0
  release(&lk->lk);
    80003980:	854a                	mv	a0,s2
    80003982:	00003097          	auipc	ra,0x3
    80003986:	924080e7          	jalr	-1756(ra) # 800062a6 <release>
  return r;
}
    8000398a:	8526                	mv	a0,s1
    8000398c:	70a2                	ld	ra,40(sp)
    8000398e:	7402                	ld	s0,32(sp)
    80003990:	64e2                	ld	s1,24(sp)
    80003992:	6942                	ld	s2,16(sp)
    80003994:	69a2                	ld	s3,8(sp)
    80003996:	6145                	addi	sp,sp,48
    80003998:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399a:	0284a983          	lw	s3,40(s1)
    8000399e:	ffffd097          	auipc	ra,0xffffd
    800039a2:	4f4080e7          	jalr	1268(ra) # 80000e92 <myproc>
    800039a6:	5904                	lw	s1,48(a0)
    800039a8:	413484b3          	sub	s1,s1,s3
    800039ac:	0014b493          	seqz	s1,s1
    800039b0:	bfc1                	j	80003980 <holdingsleep+0x24>

00000000800039b2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039b2:	1141                	addi	sp,sp,-16
    800039b4:	e406                	sd	ra,8(sp)
    800039b6:	e022                	sd	s0,0(sp)
    800039b8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039ba:	00005597          	auipc	a1,0x5
    800039be:	dee58593          	addi	a1,a1,-530 # 800087a8 <syscall_name+0x258>
    800039c2:	00016517          	auipc	a0,0x16
    800039c6:	9a650513          	addi	a0,a0,-1626 # 80019368 <ftable>
    800039ca:	00002097          	auipc	ra,0x2
    800039ce:	798080e7          	jalr	1944(ra) # 80006162 <initlock>
}
    800039d2:	60a2                	ld	ra,8(sp)
    800039d4:	6402                	ld	s0,0(sp)
    800039d6:	0141                	addi	sp,sp,16
    800039d8:	8082                	ret

00000000800039da <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039da:	1101                	addi	sp,sp,-32
    800039dc:	ec06                	sd	ra,24(sp)
    800039de:	e822                	sd	s0,16(sp)
    800039e0:	e426                	sd	s1,8(sp)
    800039e2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039e4:	00016517          	auipc	a0,0x16
    800039e8:	98450513          	addi	a0,a0,-1660 # 80019368 <ftable>
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	806080e7          	jalr	-2042(ra) # 800061f2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f4:	00016497          	auipc	s1,0x16
    800039f8:	98c48493          	addi	s1,s1,-1652 # 80019380 <ftable+0x18>
    800039fc:	00017717          	auipc	a4,0x17
    80003a00:	92470713          	addi	a4,a4,-1756 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003a04:	40dc                	lw	a5,4(s1)
    80003a06:	cf99                	beqz	a5,80003a24 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a08:	02848493          	addi	s1,s1,40
    80003a0c:	fee49ce3          	bne	s1,a4,80003a04 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a10:	00016517          	auipc	a0,0x16
    80003a14:	95850513          	addi	a0,a0,-1704 # 80019368 <ftable>
    80003a18:	00003097          	auipc	ra,0x3
    80003a1c:	88e080e7          	jalr	-1906(ra) # 800062a6 <release>
  return 0;
    80003a20:	4481                	li	s1,0
    80003a22:	a819                	j	80003a38 <filealloc+0x5e>
      f->ref = 1;
    80003a24:	4785                	li	a5,1
    80003a26:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a28:	00016517          	auipc	a0,0x16
    80003a2c:	94050513          	addi	a0,a0,-1728 # 80019368 <ftable>
    80003a30:	00003097          	auipc	ra,0x3
    80003a34:	876080e7          	jalr	-1930(ra) # 800062a6 <release>
}
    80003a38:	8526                	mv	a0,s1
    80003a3a:	60e2                	ld	ra,24(sp)
    80003a3c:	6442                	ld	s0,16(sp)
    80003a3e:	64a2                	ld	s1,8(sp)
    80003a40:	6105                	addi	sp,sp,32
    80003a42:	8082                	ret

0000000080003a44 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a44:	1101                	addi	sp,sp,-32
    80003a46:	ec06                	sd	ra,24(sp)
    80003a48:	e822                	sd	s0,16(sp)
    80003a4a:	e426                	sd	s1,8(sp)
    80003a4c:	1000                	addi	s0,sp,32
    80003a4e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a50:	00016517          	auipc	a0,0x16
    80003a54:	91850513          	addi	a0,a0,-1768 # 80019368 <ftable>
    80003a58:	00002097          	auipc	ra,0x2
    80003a5c:	79a080e7          	jalr	1946(ra) # 800061f2 <acquire>
  if(f->ref < 1)
    80003a60:	40dc                	lw	a5,4(s1)
    80003a62:	02f05263          	blez	a5,80003a86 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a66:	2785                	addiw	a5,a5,1
    80003a68:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a6a:	00016517          	auipc	a0,0x16
    80003a6e:	8fe50513          	addi	a0,a0,-1794 # 80019368 <ftable>
    80003a72:	00003097          	auipc	ra,0x3
    80003a76:	834080e7          	jalr	-1996(ra) # 800062a6 <release>
  return f;
}
    80003a7a:	8526                	mv	a0,s1
    80003a7c:	60e2                	ld	ra,24(sp)
    80003a7e:	6442                	ld	s0,16(sp)
    80003a80:	64a2                	ld	s1,8(sp)
    80003a82:	6105                	addi	sp,sp,32
    80003a84:	8082                	ret
    panic("filedup");
    80003a86:	00005517          	auipc	a0,0x5
    80003a8a:	d2a50513          	addi	a0,a0,-726 # 800087b0 <syscall_name+0x260>
    80003a8e:	00002097          	auipc	ra,0x2
    80003a92:	21a080e7          	jalr	538(ra) # 80005ca8 <panic>

0000000080003a96 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a96:	7139                	addi	sp,sp,-64
    80003a98:	fc06                	sd	ra,56(sp)
    80003a9a:	f822                	sd	s0,48(sp)
    80003a9c:	f426                	sd	s1,40(sp)
    80003a9e:	f04a                	sd	s2,32(sp)
    80003aa0:	ec4e                	sd	s3,24(sp)
    80003aa2:	e852                	sd	s4,16(sp)
    80003aa4:	e456                	sd	s5,8(sp)
    80003aa6:	0080                	addi	s0,sp,64
    80003aa8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aaa:	00016517          	auipc	a0,0x16
    80003aae:	8be50513          	addi	a0,a0,-1858 # 80019368 <ftable>
    80003ab2:	00002097          	auipc	ra,0x2
    80003ab6:	740080e7          	jalr	1856(ra) # 800061f2 <acquire>
  if(f->ref < 1)
    80003aba:	40dc                	lw	a5,4(s1)
    80003abc:	06f05163          	blez	a5,80003b1e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ac0:	37fd                	addiw	a5,a5,-1
    80003ac2:	0007871b          	sext.w	a4,a5
    80003ac6:	c0dc                	sw	a5,4(s1)
    80003ac8:	06e04363          	bgtz	a4,80003b2e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003acc:	0004a903          	lw	s2,0(s1)
    80003ad0:	0094ca83          	lbu	s5,9(s1)
    80003ad4:	0104ba03          	ld	s4,16(s1)
    80003ad8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003adc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ae0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ae4:	00016517          	auipc	a0,0x16
    80003ae8:	88450513          	addi	a0,a0,-1916 # 80019368 <ftable>
    80003aec:	00002097          	auipc	ra,0x2
    80003af0:	7ba080e7          	jalr	1978(ra) # 800062a6 <release>

  if(ff.type == FD_PIPE){
    80003af4:	4785                	li	a5,1
    80003af6:	04f90d63          	beq	s2,a5,80003b50 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003afa:	3979                	addiw	s2,s2,-2
    80003afc:	4785                	li	a5,1
    80003afe:	0527e063          	bltu	a5,s2,80003b3e <fileclose+0xa8>
    begin_op();
    80003b02:	00000097          	auipc	ra,0x0
    80003b06:	ac8080e7          	jalr	-1336(ra) # 800035ca <begin_op>
    iput(ff.ip);
    80003b0a:	854e                	mv	a0,s3
    80003b0c:	fffff097          	auipc	ra,0xfffff
    80003b10:	2a6080e7          	jalr	678(ra) # 80002db2 <iput>
    end_op();
    80003b14:	00000097          	auipc	ra,0x0
    80003b18:	b36080e7          	jalr	-1226(ra) # 8000364a <end_op>
    80003b1c:	a00d                	j	80003b3e <fileclose+0xa8>
    panic("fileclose");
    80003b1e:	00005517          	auipc	a0,0x5
    80003b22:	c9a50513          	addi	a0,a0,-870 # 800087b8 <syscall_name+0x268>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	182080e7          	jalr	386(ra) # 80005ca8 <panic>
    release(&ftable.lock);
    80003b2e:	00016517          	auipc	a0,0x16
    80003b32:	83a50513          	addi	a0,a0,-1990 # 80019368 <ftable>
    80003b36:	00002097          	auipc	ra,0x2
    80003b3a:	770080e7          	jalr	1904(ra) # 800062a6 <release>
  }
}
    80003b3e:	70e2                	ld	ra,56(sp)
    80003b40:	7442                	ld	s0,48(sp)
    80003b42:	74a2                	ld	s1,40(sp)
    80003b44:	7902                	ld	s2,32(sp)
    80003b46:	69e2                	ld	s3,24(sp)
    80003b48:	6a42                	ld	s4,16(sp)
    80003b4a:	6aa2                	ld	s5,8(sp)
    80003b4c:	6121                	addi	sp,sp,64
    80003b4e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b50:	85d6                	mv	a1,s5
    80003b52:	8552                	mv	a0,s4
    80003b54:	00000097          	auipc	ra,0x0
    80003b58:	34c080e7          	jalr	844(ra) # 80003ea0 <pipeclose>
    80003b5c:	b7cd                	j	80003b3e <fileclose+0xa8>

0000000080003b5e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b5e:	715d                	addi	sp,sp,-80
    80003b60:	e486                	sd	ra,72(sp)
    80003b62:	e0a2                	sd	s0,64(sp)
    80003b64:	fc26                	sd	s1,56(sp)
    80003b66:	f84a                	sd	s2,48(sp)
    80003b68:	f44e                	sd	s3,40(sp)
    80003b6a:	0880                	addi	s0,sp,80
    80003b6c:	84aa                	mv	s1,a0
    80003b6e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b70:	ffffd097          	auipc	ra,0xffffd
    80003b74:	322080e7          	jalr	802(ra) # 80000e92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b78:	409c                	lw	a5,0(s1)
    80003b7a:	37f9                	addiw	a5,a5,-2
    80003b7c:	4705                	li	a4,1
    80003b7e:	04f76763          	bltu	a4,a5,80003bcc <filestat+0x6e>
    80003b82:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b84:	6c88                	ld	a0,24(s1)
    80003b86:	fffff097          	auipc	ra,0xfffff
    80003b8a:	072080e7          	jalr	114(ra) # 80002bf8 <ilock>
    stati(f->ip, &st);
    80003b8e:	fb840593          	addi	a1,s0,-72
    80003b92:	6c88                	ld	a0,24(s1)
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	2ee080e7          	jalr	750(ra) # 80002e82 <stati>
    iunlock(f->ip);
    80003b9c:	6c88                	ld	a0,24(s1)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	11c080e7          	jalr	284(ra) # 80002cba <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ba6:	46e1                	li	a3,24
    80003ba8:	fb840613          	addi	a2,s0,-72
    80003bac:	85ce                	mv	a1,s3
    80003bae:	05093503          	ld	a0,80(s2)
    80003bb2:	ffffd097          	auipc	ra,0xffffd
    80003bb6:	fa2080e7          	jalr	-94(ra) # 80000b54 <copyout>
    80003bba:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bbe:	60a6                	ld	ra,72(sp)
    80003bc0:	6406                	ld	s0,64(sp)
    80003bc2:	74e2                	ld	s1,56(sp)
    80003bc4:	7942                	ld	s2,48(sp)
    80003bc6:	79a2                	ld	s3,40(sp)
    80003bc8:	6161                	addi	sp,sp,80
    80003bca:	8082                	ret
  return -1;
    80003bcc:	557d                	li	a0,-1
    80003bce:	bfc5                	j	80003bbe <filestat+0x60>

0000000080003bd0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bd0:	7179                	addi	sp,sp,-48
    80003bd2:	f406                	sd	ra,40(sp)
    80003bd4:	f022                	sd	s0,32(sp)
    80003bd6:	ec26                	sd	s1,24(sp)
    80003bd8:	e84a                	sd	s2,16(sp)
    80003bda:	e44e                	sd	s3,8(sp)
    80003bdc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bde:	00854783          	lbu	a5,8(a0)
    80003be2:	c3d5                	beqz	a5,80003c86 <fileread+0xb6>
    80003be4:	84aa                	mv	s1,a0
    80003be6:	89ae                	mv	s3,a1
    80003be8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bea:	411c                	lw	a5,0(a0)
    80003bec:	4705                	li	a4,1
    80003bee:	04e78963          	beq	a5,a4,80003c40 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf2:	470d                	li	a4,3
    80003bf4:	04e78d63          	beq	a5,a4,80003c4e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bf8:	4709                	li	a4,2
    80003bfa:	06e79e63          	bne	a5,a4,80003c76 <fileread+0xa6>
    ilock(f->ip);
    80003bfe:	6d08                	ld	a0,24(a0)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	ff8080e7          	jalr	-8(ra) # 80002bf8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c08:	874a                	mv	a4,s2
    80003c0a:	5094                	lw	a3,32(s1)
    80003c0c:	864e                	mv	a2,s3
    80003c0e:	4585                	li	a1,1
    80003c10:	6c88                	ld	a0,24(s1)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	29a080e7          	jalr	666(ra) # 80002eac <readi>
    80003c1a:	892a                	mv	s2,a0
    80003c1c:	00a05563          	blez	a0,80003c26 <fileread+0x56>
      f->off += r;
    80003c20:	509c                	lw	a5,32(s1)
    80003c22:	9fa9                	addw	a5,a5,a0
    80003c24:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c26:	6c88                	ld	a0,24(s1)
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	092080e7          	jalr	146(ra) # 80002cba <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c30:	854a                	mv	a0,s2
    80003c32:	70a2                	ld	ra,40(sp)
    80003c34:	7402                	ld	s0,32(sp)
    80003c36:	64e2                	ld	s1,24(sp)
    80003c38:	6942                	ld	s2,16(sp)
    80003c3a:	69a2                	ld	s3,8(sp)
    80003c3c:	6145                	addi	sp,sp,48
    80003c3e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c40:	6908                	ld	a0,16(a0)
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	3c8080e7          	jalr	968(ra) # 8000400a <piperead>
    80003c4a:	892a                	mv	s2,a0
    80003c4c:	b7d5                	j	80003c30 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c4e:	02451783          	lh	a5,36(a0)
    80003c52:	03079693          	slli	a3,a5,0x30
    80003c56:	92c1                	srli	a3,a3,0x30
    80003c58:	4725                	li	a4,9
    80003c5a:	02d76863          	bltu	a4,a3,80003c8a <fileread+0xba>
    80003c5e:	0792                	slli	a5,a5,0x4
    80003c60:	00015717          	auipc	a4,0x15
    80003c64:	66870713          	addi	a4,a4,1640 # 800192c8 <devsw>
    80003c68:	97ba                	add	a5,a5,a4
    80003c6a:	639c                	ld	a5,0(a5)
    80003c6c:	c38d                	beqz	a5,80003c8e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c6e:	4505                	li	a0,1
    80003c70:	9782                	jalr	a5
    80003c72:	892a                	mv	s2,a0
    80003c74:	bf75                	j	80003c30 <fileread+0x60>
    panic("fileread");
    80003c76:	00005517          	auipc	a0,0x5
    80003c7a:	b5250513          	addi	a0,a0,-1198 # 800087c8 <syscall_name+0x278>
    80003c7e:	00002097          	auipc	ra,0x2
    80003c82:	02a080e7          	jalr	42(ra) # 80005ca8 <panic>
    return -1;
    80003c86:	597d                	li	s2,-1
    80003c88:	b765                	j	80003c30 <fileread+0x60>
      return -1;
    80003c8a:	597d                	li	s2,-1
    80003c8c:	b755                	j	80003c30 <fileread+0x60>
    80003c8e:	597d                	li	s2,-1
    80003c90:	b745                	j	80003c30 <fileread+0x60>

0000000080003c92 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c92:	715d                	addi	sp,sp,-80
    80003c94:	e486                	sd	ra,72(sp)
    80003c96:	e0a2                	sd	s0,64(sp)
    80003c98:	fc26                	sd	s1,56(sp)
    80003c9a:	f84a                	sd	s2,48(sp)
    80003c9c:	f44e                	sd	s3,40(sp)
    80003c9e:	f052                	sd	s4,32(sp)
    80003ca0:	ec56                	sd	s5,24(sp)
    80003ca2:	e85a                	sd	s6,16(sp)
    80003ca4:	e45e                	sd	s7,8(sp)
    80003ca6:	e062                	sd	s8,0(sp)
    80003ca8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003caa:	00954783          	lbu	a5,9(a0)
    80003cae:	10078663          	beqz	a5,80003dba <filewrite+0x128>
    80003cb2:	892a                	mv	s2,a0
    80003cb4:	8aae                	mv	s5,a1
    80003cb6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cb8:	411c                	lw	a5,0(a0)
    80003cba:	4705                	li	a4,1
    80003cbc:	02e78263          	beq	a5,a4,80003ce0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cc0:	470d                	li	a4,3
    80003cc2:	02e78663          	beq	a5,a4,80003cee <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cc6:	4709                	li	a4,2
    80003cc8:	0ee79163          	bne	a5,a4,80003daa <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ccc:	0ac05d63          	blez	a2,80003d86 <filewrite+0xf4>
    int i = 0;
    80003cd0:	4981                	li	s3,0
    80003cd2:	6b05                	lui	s6,0x1
    80003cd4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cd8:	6b85                	lui	s7,0x1
    80003cda:	c00b8b9b          	addiw	s7,s7,-1024
    80003cde:	a861                	j	80003d76 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ce0:	6908                	ld	a0,16(a0)
    80003ce2:	00000097          	auipc	ra,0x0
    80003ce6:	22e080e7          	jalr	558(ra) # 80003f10 <pipewrite>
    80003cea:	8a2a                	mv	s4,a0
    80003cec:	a045                	j	80003d8c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cee:	02451783          	lh	a5,36(a0)
    80003cf2:	03079693          	slli	a3,a5,0x30
    80003cf6:	92c1                	srli	a3,a3,0x30
    80003cf8:	4725                	li	a4,9
    80003cfa:	0cd76263          	bltu	a4,a3,80003dbe <filewrite+0x12c>
    80003cfe:	0792                	slli	a5,a5,0x4
    80003d00:	00015717          	auipc	a4,0x15
    80003d04:	5c870713          	addi	a4,a4,1480 # 800192c8 <devsw>
    80003d08:	97ba                	add	a5,a5,a4
    80003d0a:	679c                	ld	a5,8(a5)
    80003d0c:	cbdd                	beqz	a5,80003dc2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d0e:	4505                	li	a0,1
    80003d10:	9782                	jalr	a5
    80003d12:	8a2a                	mv	s4,a0
    80003d14:	a8a5                	j	80003d8c <filewrite+0xfa>
    80003d16:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	8b0080e7          	jalr	-1872(ra) # 800035ca <begin_op>
      ilock(f->ip);
    80003d22:	01893503          	ld	a0,24(s2)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	ed2080e7          	jalr	-302(ra) # 80002bf8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d2e:	8762                	mv	a4,s8
    80003d30:	02092683          	lw	a3,32(s2)
    80003d34:	01598633          	add	a2,s3,s5
    80003d38:	4585                	li	a1,1
    80003d3a:	01893503          	ld	a0,24(s2)
    80003d3e:	fffff097          	auipc	ra,0xfffff
    80003d42:	266080e7          	jalr	614(ra) # 80002fa4 <writei>
    80003d46:	84aa                	mv	s1,a0
    80003d48:	00a05763          	blez	a0,80003d56 <filewrite+0xc4>
        f->off += r;
    80003d4c:	02092783          	lw	a5,32(s2)
    80003d50:	9fa9                	addw	a5,a5,a0
    80003d52:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d56:	01893503          	ld	a0,24(s2)
    80003d5a:	fffff097          	auipc	ra,0xfffff
    80003d5e:	f60080e7          	jalr	-160(ra) # 80002cba <iunlock>
      end_op();
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	8e8080e7          	jalr	-1816(ra) # 8000364a <end_op>

      if(r != n1){
    80003d6a:	009c1f63          	bne	s8,s1,80003d88 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d6e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d72:	0149db63          	bge	s3,s4,80003d88 <filewrite+0xf6>
      int n1 = n - i;
    80003d76:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d7a:	84be                	mv	s1,a5
    80003d7c:	2781                	sext.w	a5,a5
    80003d7e:	f8fb5ce3          	bge	s6,a5,80003d16 <filewrite+0x84>
    80003d82:	84de                	mv	s1,s7
    80003d84:	bf49                	j	80003d16 <filewrite+0x84>
    int i = 0;
    80003d86:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d88:	013a1f63          	bne	s4,s3,80003da6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d8c:	8552                	mv	a0,s4
    80003d8e:	60a6                	ld	ra,72(sp)
    80003d90:	6406                	ld	s0,64(sp)
    80003d92:	74e2                	ld	s1,56(sp)
    80003d94:	7942                	ld	s2,48(sp)
    80003d96:	79a2                	ld	s3,40(sp)
    80003d98:	7a02                	ld	s4,32(sp)
    80003d9a:	6ae2                	ld	s5,24(sp)
    80003d9c:	6b42                	ld	s6,16(sp)
    80003d9e:	6ba2                	ld	s7,8(sp)
    80003da0:	6c02                	ld	s8,0(sp)
    80003da2:	6161                	addi	sp,sp,80
    80003da4:	8082                	ret
    ret = (i == n ? n : -1);
    80003da6:	5a7d                	li	s4,-1
    80003da8:	b7d5                	j	80003d8c <filewrite+0xfa>
    panic("filewrite");
    80003daa:	00005517          	auipc	a0,0x5
    80003dae:	a2e50513          	addi	a0,a0,-1490 # 800087d8 <syscall_name+0x288>
    80003db2:	00002097          	auipc	ra,0x2
    80003db6:	ef6080e7          	jalr	-266(ra) # 80005ca8 <panic>
    return -1;
    80003dba:	5a7d                	li	s4,-1
    80003dbc:	bfc1                	j	80003d8c <filewrite+0xfa>
      return -1;
    80003dbe:	5a7d                	li	s4,-1
    80003dc0:	b7f1                	j	80003d8c <filewrite+0xfa>
    80003dc2:	5a7d                	li	s4,-1
    80003dc4:	b7e1                	j	80003d8c <filewrite+0xfa>

0000000080003dc6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dc6:	7179                	addi	sp,sp,-48
    80003dc8:	f406                	sd	ra,40(sp)
    80003dca:	f022                	sd	s0,32(sp)
    80003dcc:	ec26                	sd	s1,24(sp)
    80003dce:	e84a                	sd	s2,16(sp)
    80003dd0:	e44e                	sd	s3,8(sp)
    80003dd2:	e052                	sd	s4,0(sp)
    80003dd4:	1800                	addi	s0,sp,48
    80003dd6:	84aa                	mv	s1,a0
    80003dd8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dda:	0005b023          	sd	zero,0(a1)
    80003dde:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	bf8080e7          	jalr	-1032(ra) # 800039da <filealloc>
    80003dea:	e088                	sd	a0,0(s1)
    80003dec:	c551                	beqz	a0,80003e78 <pipealloc+0xb2>
    80003dee:	00000097          	auipc	ra,0x0
    80003df2:	bec080e7          	jalr	-1044(ra) # 800039da <filealloc>
    80003df6:	00aa3023          	sd	a0,0(s4)
    80003dfa:	c92d                	beqz	a0,80003e6c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dfc:	ffffc097          	auipc	ra,0xffffc
    80003e00:	31c080e7          	jalr	796(ra) # 80000118 <kalloc>
    80003e04:	892a                	mv	s2,a0
    80003e06:	c125                	beqz	a0,80003e66 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e08:	4985                	li	s3,1
    80003e0a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e0e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e12:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e16:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e1a:	00004597          	auipc	a1,0x4
    80003e1e:	5c658593          	addi	a1,a1,1478 # 800083e0 <states.1714+0x1a0>
    80003e22:	00002097          	auipc	ra,0x2
    80003e26:	340080e7          	jalr	832(ra) # 80006162 <initlock>
  (*f0)->type = FD_PIPE;
    80003e2a:	609c                	ld	a5,0(s1)
    80003e2c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e30:	609c                	ld	a5,0(s1)
    80003e32:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e36:	609c                	ld	a5,0(s1)
    80003e38:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e3c:	609c                	ld	a5,0(s1)
    80003e3e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e42:	000a3783          	ld	a5,0(s4)
    80003e46:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e4a:	000a3783          	ld	a5,0(s4)
    80003e4e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e52:	000a3783          	ld	a5,0(s4)
    80003e56:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e5a:	000a3783          	ld	a5,0(s4)
    80003e5e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e62:	4501                	li	a0,0
    80003e64:	a025                	j	80003e8c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e66:	6088                	ld	a0,0(s1)
    80003e68:	e501                	bnez	a0,80003e70 <pipealloc+0xaa>
    80003e6a:	a039                	j	80003e78 <pipealloc+0xb2>
    80003e6c:	6088                	ld	a0,0(s1)
    80003e6e:	c51d                	beqz	a0,80003e9c <pipealloc+0xd6>
    fileclose(*f0);
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	c26080e7          	jalr	-986(ra) # 80003a96 <fileclose>
  if(*f1)
    80003e78:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e7c:	557d                	li	a0,-1
  if(*f1)
    80003e7e:	c799                	beqz	a5,80003e8c <pipealloc+0xc6>
    fileclose(*f1);
    80003e80:	853e                	mv	a0,a5
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	c14080e7          	jalr	-1004(ra) # 80003a96 <fileclose>
  return -1;
    80003e8a:	557d                	li	a0,-1
}
    80003e8c:	70a2                	ld	ra,40(sp)
    80003e8e:	7402                	ld	s0,32(sp)
    80003e90:	64e2                	ld	s1,24(sp)
    80003e92:	6942                	ld	s2,16(sp)
    80003e94:	69a2                	ld	s3,8(sp)
    80003e96:	6a02                	ld	s4,0(sp)
    80003e98:	6145                	addi	sp,sp,48
    80003e9a:	8082                	ret
  return -1;
    80003e9c:	557d                	li	a0,-1
    80003e9e:	b7fd                	j	80003e8c <pipealloc+0xc6>

0000000080003ea0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ea0:	1101                	addi	sp,sp,-32
    80003ea2:	ec06                	sd	ra,24(sp)
    80003ea4:	e822                	sd	s0,16(sp)
    80003ea6:	e426                	sd	s1,8(sp)
    80003ea8:	e04a                	sd	s2,0(sp)
    80003eaa:	1000                	addi	s0,sp,32
    80003eac:	84aa                	mv	s1,a0
    80003eae:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eb0:	00002097          	auipc	ra,0x2
    80003eb4:	342080e7          	jalr	834(ra) # 800061f2 <acquire>
  if(writable){
    80003eb8:	02090d63          	beqz	s2,80003ef2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003ebc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ec0:	21848513          	addi	a0,s1,536
    80003ec4:	ffffe097          	auipc	ra,0xffffe
    80003ec8:	81e080e7          	jalr	-2018(ra) # 800016e2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ecc:	2204b783          	ld	a5,544(s1)
    80003ed0:	eb95                	bnez	a5,80003f04 <pipeclose+0x64>
    release(&pi->lock);
    80003ed2:	8526                	mv	a0,s1
    80003ed4:	00002097          	auipc	ra,0x2
    80003ed8:	3d2080e7          	jalr	978(ra) # 800062a6 <release>
    kfree((char*)pi);
    80003edc:	8526                	mv	a0,s1
    80003ede:	ffffc097          	auipc	ra,0xffffc
    80003ee2:	13e080e7          	jalr	318(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ee6:	60e2                	ld	ra,24(sp)
    80003ee8:	6442                	ld	s0,16(sp)
    80003eea:	64a2                	ld	s1,8(sp)
    80003eec:	6902                	ld	s2,0(sp)
    80003eee:	6105                	addi	sp,sp,32
    80003ef0:	8082                	ret
    pi->readopen = 0;
    80003ef2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ef6:	21c48513          	addi	a0,s1,540
    80003efa:	ffffd097          	auipc	ra,0xffffd
    80003efe:	7e8080e7          	jalr	2024(ra) # 800016e2 <wakeup>
    80003f02:	b7e9                	j	80003ecc <pipeclose+0x2c>
    release(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	3a0080e7          	jalr	928(ra) # 800062a6 <release>
}
    80003f0e:	bfe1                	j	80003ee6 <pipeclose+0x46>

0000000080003f10 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f10:	7159                	addi	sp,sp,-112
    80003f12:	f486                	sd	ra,104(sp)
    80003f14:	f0a2                	sd	s0,96(sp)
    80003f16:	eca6                	sd	s1,88(sp)
    80003f18:	e8ca                	sd	s2,80(sp)
    80003f1a:	e4ce                	sd	s3,72(sp)
    80003f1c:	e0d2                	sd	s4,64(sp)
    80003f1e:	fc56                	sd	s5,56(sp)
    80003f20:	f85a                	sd	s6,48(sp)
    80003f22:	f45e                	sd	s7,40(sp)
    80003f24:	f062                	sd	s8,32(sp)
    80003f26:	ec66                	sd	s9,24(sp)
    80003f28:	1880                	addi	s0,sp,112
    80003f2a:	84aa                	mv	s1,a0
    80003f2c:	8aae                	mv	s5,a1
    80003f2e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	f62080e7          	jalr	-158(ra) # 80000e92 <myproc>
    80003f38:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	00002097          	auipc	ra,0x2
    80003f40:	2b6080e7          	jalr	694(ra) # 800061f2 <acquire>
  while(i < n){
    80003f44:	0d405163          	blez	s4,80004006 <pipewrite+0xf6>
    80003f48:	8ba6                	mv	s7,s1
  int i = 0;
    80003f4a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f4c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f4e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f52:	21c48c13          	addi	s8,s1,540
    80003f56:	a08d                	j	80003fb8 <pipewrite+0xa8>
      release(&pi->lock);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	00002097          	auipc	ra,0x2
    80003f5e:	34c080e7          	jalr	844(ra) # 800062a6 <release>
      return -1;
    80003f62:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f64:	854a                	mv	a0,s2
    80003f66:	70a6                	ld	ra,104(sp)
    80003f68:	7406                	ld	s0,96(sp)
    80003f6a:	64e6                	ld	s1,88(sp)
    80003f6c:	6946                	ld	s2,80(sp)
    80003f6e:	69a6                	ld	s3,72(sp)
    80003f70:	6a06                	ld	s4,64(sp)
    80003f72:	7ae2                	ld	s5,56(sp)
    80003f74:	7b42                	ld	s6,48(sp)
    80003f76:	7ba2                	ld	s7,40(sp)
    80003f78:	7c02                	ld	s8,32(sp)
    80003f7a:	6ce2                	ld	s9,24(sp)
    80003f7c:	6165                	addi	sp,sp,112
    80003f7e:	8082                	ret
      wakeup(&pi->nread);
    80003f80:	8566                	mv	a0,s9
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	760080e7          	jalr	1888(ra) # 800016e2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f8a:	85de                	mv	a1,s7
    80003f8c:	8562                	mv	a0,s8
    80003f8e:	ffffd097          	auipc	ra,0xffffd
    80003f92:	5c8080e7          	jalr	1480(ra) # 80001556 <sleep>
    80003f96:	a839                	j	80003fb4 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f98:	21c4a783          	lw	a5,540(s1)
    80003f9c:	0017871b          	addiw	a4,a5,1
    80003fa0:	20e4ae23          	sw	a4,540(s1)
    80003fa4:	1ff7f793          	andi	a5,a5,511
    80003fa8:	97a6                	add	a5,a5,s1
    80003faa:	f9f44703          	lbu	a4,-97(s0)
    80003fae:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fb2:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fb4:	03495d63          	bge	s2,s4,80003fee <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003fb8:	2204a783          	lw	a5,544(s1)
    80003fbc:	dfd1                	beqz	a5,80003f58 <pipewrite+0x48>
    80003fbe:	0289a783          	lw	a5,40(s3)
    80003fc2:	fbd9                	bnez	a5,80003f58 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fc4:	2184a783          	lw	a5,536(s1)
    80003fc8:	21c4a703          	lw	a4,540(s1)
    80003fcc:	2007879b          	addiw	a5,a5,512
    80003fd0:	faf708e3          	beq	a4,a5,80003f80 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fd4:	4685                	li	a3,1
    80003fd6:	01590633          	add	a2,s2,s5
    80003fda:	f9f40593          	addi	a1,s0,-97
    80003fde:	0509b503          	ld	a0,80(s3)
    80003fe2:	ffffd097          	auipc	ra,0xffffd
    80003fe6:	bfe080e7          	jalr	-1026(ra) # 80000be0 <copyin>
    80003fea:	fb6517e3          	bne	a0,s6,80003f98 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fee:	21848513          	addi	a0,s1,536
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	6f0080e7          	jalr	1776(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	00002097          	auipc	ra,0x2
    80004000:	2aa080e7          	jalr	682(ra) # 800062a6 <release>
  return i;
    80004004:	b785                	j	80003f64 <pipewrite+0x54>
  int i = 0;
    80004006:	4901                	li	s2,0
    80004008:	b7dd                	j	80003fee <pipewrite+0xde>

000000008000400a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000400a:	715d                	addi	sp,sp,-80
    8000400c:	e486                	sd	ra,72(sp)
    8000400e:	e0a2                	sd	s0,64(sp)
    80004010:	fc26                	sd	s1,56(sp)
    80004012:	f84a                	sd	s2,48(sp)
    80004014:	f44e                	sd	s3,40(sp)
    80004016:	f052                	sd	s4,32(sp)
    80004018:	ec56                	sd	s5,24(sp)
    8000401a:	e85a                	sd	s6,16(sp)
    8000401c:	0880                	addi	s0,sp,80
    8000401e:	84aa                	mv	s1,a0
    80004020:	892e                	mv	s2,a1
    80004022:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	e6e080e7          	jalr	-402(ra) # 80000e92 <myproc>
    8000402c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000402e:	8b26                	mv	s6,s1
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	1c0080e7          	jalr	448(ra) # 800061f2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403a:	2184a703          	lw	a4,536(s1)
    8000403e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004042:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004046:	02f71463          	bne	a4,a5,8000406e <piperead+0x64>
    8000404a:	2244a783          	lw	a5,548(s1)
    8000404e:	c385                	beqz	a5,8000406e <piperead+0x64>
    if(pr->killed){
    80004050:	028a2783          	lw	a5,40(s4)
    80004054:	ebc1                	bnez	a5,800040e4 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004056:	85da                	mv	a1,s6
    80004058:	854e                	mv	a0,s3
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	4fc080e7          	jalr	1276(ra) # 80001556 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004062:	2184a703          	lw	a4,536(s1)
    80004066:	21c4a783          	lw	a5,540(s1)
    8000406a:	fef700e3          	beq	a4,a5,8000404a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000406e:	09505263          	blez	s5,800040f2 <piperead+0xe8>
    80004072:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004074:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004076:	2184a783          	lw	a5,536(s1)
    8000407a:	21c4a703          	lw	a4,540(s1)
    8000407e:	02f70d63          	beq	a4,a5,800040b8 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004082:	0017871b          	addiw	a4,a5,1
    80004086:	20e4ac23          	sw	a4,536(s1)
    8000408a:	1ff7f793          	andi	a5,a5,511
    8000408e:	97a6                	add	a5,a5,s1
    80004090:	0187c783          	lbu	a5,24(a5)
    80004094:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004098:	4685                	li	a3,1
    8000409a:	fbf40613          	addi	a2,s0,-65
    8000409e:	85ca                	mv	a1,s2
    800040a0:	050a3503          	ld	a0,80(s4)
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	ab0080e7          	jalr	-1360(ra) # 80000b54 <copyout>
    800040ac:	01650663          	beq	a0,s6,800040b8 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b0:	2985                	addiw	s3,s3,1
    800040b2:	0905                	addi	s2,s2,1
    800040b4:	fd3a91e3          	bne	s5,s3,80004076 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040b8:	21c48513          	addi	a0,s1,540
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	626080e7          	jalr	1574(ra) # 800016e2 <wakeup>
  release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	1e0080e7          	jalr	480(ra) # 800062a6 <release>
  return i;
}
    800040ce:	854e                	mv	a0,s3
    800040d0:	60a6                	ld	ra,72(sp)
    800040d2:	6406                	ld	s0,64(sp)
    800040d4:	74e2                	ld	s1,56(sp)
    800040d6:	7942                	ld	s2,48(sp)
    800040d8:	79a2                	ld	s3,40(sp)
    800040da:	7a02                	ld	s4,32(sp)
    800040dc:	6ae2                	ld	s5,24(sp)
    800040de:	6b42                	ld	s6,16(sp)
    800040e0:	6161                	addi	sp,sp,80
    800040e2:	8082                	ret
      release(&pi->lock);
    800040e4:	8526                	mv	a0,s1
    800040e6:	00002097          	auipc	ra,0x2
    800040ea:	1c0080e7          	jalr	448(ra) # 800062a6 <release>
      return -1;
    800040ee:	59fd                	li	s3,-1
    800040f0:	bff9                	j	800040ce <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f2:	4981                	li	s3,0
    800040f4:	b7d1                	j	800040b8 <piperead+0xae>

00000000800040f6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040f6:	df010113          	addi	sp,sp,-528
    800040fa:	20113423          	sd	ra,520(sp)
    800040fe:	20813023          	sd	s0,512(sp)
    80004102:	ffa6                	sd	s1,504(sp)
    80004104:	fbca                	sd	s2,496(sp)
    80004106:	f7ce                	sd	s3,488(sp)
    80004108:	f3d2                	sd	s4,480(sp)
    8000410a:	efd6                	sd	s5,472(sp)
    8000410c:	ebda                	sd	s6,464(sp)
    8000410e:	e7de                	sd	s7,456(sp)
    80004110:	e3e2                	sd	s8,448(sp)
    80004112:	ff66                	sd	s9,440(sp)
    80004114:	fb6a                	sd	s10,432(sp)
    80004116:	f76e                	sd	s11,424(sp)
    80004118:	0c00                	addi	s0,sp,528
    8000411a:	84aa                	mv	s1,a0
    8000411c:	dea43c23          	sd	a0,-520(s0)
    80004120:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	d6e080e7          	jalr	-658(ra) # 80000e92 <myproc>
    8000412c:	892a                	mv	s2,a0

  begin_op();
    8000412e:	fffff097          	auipc	ra,0xfffff
    80004132:	49c080e7          	jalr	1180(ra) # 800035ca <begin_op>

  if((ip = namei(path)) == 0){
    80004136:	8526                	mv	a0,s1
    80004138:	fffff097          	auipc	ra,0xfffff
    8000413c:	276080e7          	jalr	630(ra) # 800033ae <namei>
    80004140:	c92d                	beqz	a0,800041b2 <exec+0xbc>
    80004142:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004144:	fffff097          	auipc	ra,0xfffff
    80004148:	ab4080e7          	jalr	-1356(ra) # 80002bf8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000414c:	04000713          	li	a4,64
    80004150:	4681                	li	a3,0
    80004152:	e5040613          	addi	a2,s0,-432
    80004156:	4581                	li	a1,0
    80004158:	8526                	mv	a0,s1
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	d52080e7          	jalr	-686(ra) # 80002eac <readi>
    80004162:	04000793          	li	a5,64
    80004166:	00f51a63          	bne	a0,a5,8000417a <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000416a:	e5042703          	lw	a4,-432(s0)
    8000416e:	464c47b7          	lui	a5,0x464c4
    80004172:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004176:	04f70463          	beq	a4,a5,800041be <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000417a:	8526                	mv	a0,s1
    8000417c:	fffff097          	auipc	ra,0xfffff
    80004180:	cde080e7          	jalr	-802(ra) # 80002e5a <iunlockput>
    end_op();
    80004184:	fffff097          	auipc	ra,0xfffff
    80004188:	4c6080e7          	jalr	1222(ra) # 8000364a <end_op>
  }
  return -1;
    8000418c:	557d                	li	a0,-1
}
    8000418e:	20813083          	ld	ra,520(sp)
    80004192:	20013403          	ld	s0,512(sp)
    80004196:	74fe                	ld	s1,504(sp)
    80004198:	795e                	ld	s2,496(sp)
    8000419a:	79be                	ld	s3,488(sp)
    8000419c:	7a1e                	ld	s4,480(sp)
    8000419e:	6afe                	ld	s5,472(sp)
    800041a0:	6b5e                	ld	s6,464(sp)
    800041a2:	6bbe                	ld	s7,456(sp)
    800041a4:	6c1e                	ld	s8,448(sp)
    800041a6:	7cfa                	ld	s9,440(sp)
    800041a8:	7d5a                	ld	s10,432(sp)
    800041aa:	7dba                	ld	s11,424(sp)
    800041ac:	21010113          	addi	sp,sp,528
    800041b0:	8082                	ret
    end_op();
    800041b2:	fffff097          	auipc	ra,0xfffff
    800041b6:	498080e7          	jalr	1176(ra) # 8000364a <end_op>
    return -1;
    800041ba:	557d                	li	a0,-1
    800041bc:	bfc9                	j	8000418e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041be:	854a                	mv	a0,s2
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	d96080e7          	jalr	-618(ra) # 80000f56 <proc_pagetable>
    800041c8:	8baa                	mv	s7,a0
    800041ca:	d945                	beqz	a0,8000417a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041cc:	e7042983          	lw	s3,-400(s0)
    800041d0:	e8845783          	lhu	a5,-376(s0)
    800041d4:	c7ad                	beqz	a5,8000423e <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041d6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041d8:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041da:	6c85                	lui	s9,0x1
    800041dc:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041e0:	def43823          	sd	a5,-528(s0)
    800041e4:	a42d                	j	8000440e <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041e6:	00004517          	auipc	a0,0x4
    800041ea:	60250513          	addi	a0,a0,1538 # 800087e8 <syscall_name+0x298>
    800041ee:	00002097          	auipc	ra,0x2
    800041f2:	aba080e7          	jalr	-1350(ra) # 80005ca8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041f6:	8756                	mv	a4,s5
    800041f8:	012d86bb          	addw	a3,s11,s2
    800041fc:	4581                	li	a1,0
    800041fe:	8526                	mv	a0,s1
    80004200:	fffff097          	auipc	ra,0xfffff
    80004204:	cac080e7          	jalr	-852(ra) # 80002eac <readi>
    80004208:	2501                	sext.w	a0,a0
    8000420a:	1aaa9963          	bne	s5,a0,800043bc <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000420e:	6785                	lui	a5,0x1
    80004210:	0127893b          	addw	s2,a5,s2
    80004214:	77fd                	lui	a5,0xfffff
    80004216:	01478a3b          	addw	s4,a5,s4
    8000421a:	1f897163          	bgeu	s2,s8,800043fc <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000421e:	02091593          	slli	a1,s2,0x20
    80004222:	9181                	srli	a1,a1,0x20
    80004224:	95ea                	add	a1,a1,s10
    80004226:	855e                	mv	a0,s7
    80004228:	ffffc097          	auipc	ra,0xffffc
    8000422c:	328080e7          	jalr	808(ra) # 80000550 <walkaddr>
    80004230:	862a                	mv	a2,a0
    if(pa == 0)
    80004232:	d955                	beqz	a0,800041e6 <exec+0xf0>
      n = PGSIZE;
    80004234:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004236:	fd9a70e3          	bgeu	s4,s9,800041f6 <exec+0x100>
      n = sz - i;
    8000423a:	8ad2                	mv	s5,s4
    8000423c:	bf6d                	j	800041f6 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000423e:	4901                	li	s2,0
  iunlockput(ip);
    80004240:	8526                	mv	a0,s1
    80004242:	fffff097          	auipc	ra,0xfffff
    80004246:	c18080e7          	jalr	-1000(ra) # 80002e5a <iunlockput>
  end_op();
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	400080e7          	jalr	1024(ra) # 8000364a <end_op>
  p = myproc();
    80004252:	ffffd097          	auipc	ra,0xffffd
    80004256:	c40080e7          	jalr	-960(ra) # 80000e92 <myproc>
    8000425a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000425c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004260:	6785                	lui	a5,0x1
    80004262:	17fd                	addi	a5,a5,-1
    80004264:	993e                	add	s2,s2,a5
    80004266:	757d                	lui	a0,0xfffff
    80004268:	00a977b3          	and	a5,s2,a0
    8000426c:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004270:	6609                	lui	a2,0x2
    80004272:	963e                	add	a2,a2,a5
    80004274:	85be                	mv	a1,a5
    80004276:	855e                	mv	a0,s7
    80004278:	ffffc097          	auipc	ra,0xffffc
    8000427c:	68c080e7          	jalr	1676(ra) # 80000904 <uvmalloc>
    80004280:	8b2a                	mv	s6,a0
  ip = 0;
    80004282:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004284:	12050c63          	beqz	a0,800043bc <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004288:	75f9                	lui	a1,0xffffe
    8000428a:	95aa                	add	a1,a1,a0
    8000428c:	855e                	mv	a0,s7
    8000428e:	ffffd097          	auipc	ra,0xffffd
    80004292:	894080e7          	jalr	-1900(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    80004296:	7c7d                	lui	s8,0xfffff
    80004298:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000429a:	e0043783          	ld	a5,-512(s0)
    8000429e:	6388                	ld	a0,0(a5)
    800042a0:	c535                	beqz	a0,8000430c <exec+0x216>
    800042a2:	e9040993          	addi	s3,s0,-368
    800042a6:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042aa:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042ac:	ffffc097          	auipc	ra,0xffffc
    800042b0:	09a080e7          	jalr	154(ra) # 80000346 <strlen>
    800042b4:	2505                	addiw	a0,a0,1
    800042b6:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042ba:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042be:	13896363          	bltu	s2,s8,800043e4 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042c2:	e0043d83          	ld	s11,-512(s0)
    800042c6:	000dba03          	ld	s4,0(s11)
    800042ca:	8552                	mv	a0,s4
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	07a080e7          	jalr	122(ra) # 80000346 <strlen>
    800042d4:	0015069b          	addiw	a3,a0,1
    800042d8:	8652                	mv	a2,s4
    800042da:	85ca                	mv	a1,s2
    800042dc:	855e                	mv	a0,s7
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	876080e7          	jalr	-1930(ra) # 80000b54 <copyout>
    800042e6:	10054363          	bltz	a0,800043ec <exec+0x2f6>
    ustack[argc] = sp;
    800042ea:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042ee:	0485                	addi	s1,s1,1
    800042f0:	008d8793          	addi	a5,s11,8
    800042f4:	e0f43023          	sd	a5,-512(s0)
    800042f8:	008db503          	ld	a0,8(s11)
    800042fc:	c911                	beqz	a0,80004310 <exec+0x21a>
    if(argc >= MAXARG)
    800042fe:	09a1                	addi	s3,s3,8
    80004300:	fb3c96e3          	bne	s9,s3,800042ac <exec+0x1b6>
  sz = sz1;
    80004304:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004308:	4481                	li	s1,0
    8000430a:	a84d                	j	800043bc <exec+0x2c6>
  sp = sz;
    8000430c:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000430e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004310:	00349793          	slli	a5,s1,0x3
    80004314:	f9040713          	addi	a4,s0,-112
    80004318:	97ba                	add	a5,a5,a4
    8000431a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000431e:	00148693          	addi	a3,s1,1
    80004322:	068e                	slli	a3,a3,0x3
    80004324:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004328:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000432c:	01897663          	bgeu	s2,s8,80004338 <exec+0x242>
  sz = sz1;
    80004330:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004334:	4481                	li	s1,0
    80004336:	a059                	j	800043bc <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004338:	e9040613          	addi	a2,s0,-368
    8000433c:	85ca                	mv	a1,s2
    8000433e:	855e                	mv	a0,s7
    80004340:	ffffd097          	auipc	ra,0xffffd
    80004344:	814080e7          	jalr	-2028(ra) # 80000b54 <copyout>
    80004348:	0a054663          	bltz	a0,800043f4 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000434c:	058ab783          	ld	a5,88(s5)
    80004350:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004354:	df843783          	ld	a5,-520(s0)
    80004358:	0007c703          	lbu	a4,0(a5)
    8000435c:	cf11                	beqz	a4,80004378 <exec+0x282>
    8000435e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004360:	02f00693          	li	a3,47
    80004364:	a039                	j	80004372 <exec+0x27c>
      last = s+1;
    80004366:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000436a:	0785                	addi	a5,a5,1
    8000436c:	fff7c703          	lbu	a4,-1(a5)
    80004370:	c701                	beqz	a4,80004378 <exec+0x282>
    if(*s == '/')
    80004372:	fed71ce3          	bne	a4,a3,8000436a <exec+0x274>
    80004376:	bfc5                	j	80004366 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004378:	4641                	li	a2,16
    8000437a:	df843583          	ld	a1,-520(s0)
    8000437e:	158a8513          	addi	a0,s5,344
    80004382:	ffffc097          	auipc	ra,0xffffc
    80004386:	f92080e7          	jalr	-110(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    8000438a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000438e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004392:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004396:	058ab783          	ld	a5,88(s5)
    8000439a:	e6843703          	ld	a4,-408(s0)
    8000439e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043a0:	058ab783          	ld	a5,88(s5)
    800043a4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043a8:	85ea                	mv	a1,s10
    800043aa:	ffffd097          	auipc	ra,0xffffd
    800043ae:	c48080e7          	jalr	-952(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043b2:	0004851b          	sext.w	a0,s1
    800043b6:	bbe1                	j	8000418e <exec+0x98>
    800043b8:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043bc:	e0843583          	ld	a1,-504(s0)
    800043c0:	855e                	mv	a0,s7
    800043c2:	ffffd097          	auipc	ra,0xffffd
    800043c6:	c30080e7          	jalr	-976(ra) # 80000ff2 <proc_freepagetable>
  if(ip){
    800043ca:	da0498e3          	bnez	s1,8000417a <exec+0x84>
  return -1;
    800043ce:	557d                	li	a0,-1
    800043d0:	bb7d                	j	8000418e <exec+0x98>
    800043d2:	e1243423          	sd	s2,-504(s0)
    800043d6:	b7dd                	j	800043bc <exec+0x2c6>
    800043d8:	e1243423          	sd	s2,-504(s0)
    800043dc:	b7c5                	j	800043bc <exec+0x2c6>
    800043de:	e1243423          	sd	s2,-504(s0)
    800043e2:	bfe9                	j	800043bc <exec+0x2c6>
  sz = sz1;
    800043e4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e8:	4481                	li	s1,0
    800043ea:	bfc9                	j	800043bc <exec+0x2c6>
  sz = sz1;
    800043ec:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043f0:	4481                	li	s1,0
    800043f2:	b7e9                	j	800043bc <exec+0x2c6>
  sz = sz1;
    800043f4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043f8:	4481                	li	s1,0
    800043fa:	b7c9                	j	800043bc <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043fc:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004400:	2b05                	addiw	s6,s6,1
    80004402:	0389899b          	addiw	s3,s3,56
    80004406:	e8845783          	lhu	a5,-376(s0)
    8000440a:	e2fb5be3          	bge	s6,a5,80004240 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000440e:	2981                	sext.w	s3,s3
    80004410:	03800713          	li	a4,56
    80004414:	86ce                	mv	a3,s3
    80004416:	e1840613          	addi	a2,s0,-488
    8000441a:	4581                	li	a1,0
    8000441c:	8526                	mv	a0,s1
    8000441e:	fffff097          	auipc	ra,0xfffff
    80004422:	a8e080e7          	jalr	-1394(ra) # 80002eac <readi>
    80004426:	03800793          	li	a5,56
    8000442a:	f8f517e3          	bne	a0,a5,800043b8 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000442e:	e1842783          	lw	a5,-488(s0)
    80004432:	4705                	li	a4,1
    80004434:	fce796e3          	bne	a5,a4,80004400 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004438:	e4043603          	ld	a2,-448(s0)
    8000443c:	e3843783          	ld	a5,-456(s0)
    80004440:	f8f669e3          	bltu	a2,a5,800043d2 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004444:	e2843783          	ld	a5,-472(s0)
    80004448:	963e                	add	a2,a2,a5
    8000444a:	f8f667e3          	bltu	a2,a5,800043d8 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000444e:	85ca                	mv	a1,s2
    80004450:	855e                	mv	a0,s7
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	4b2080e7          	jalr	1202(ra) # 80000904 <uvmalloc>
    8000445a:	e0a43423          	sd	a0,-504(s0)
    8000445e:	d141                	beqz	a0,800043de <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004460:	e2843d03          	ld	s10,-472(s0)
    80004464:	df043783          	ld	a5,-528(s0)
    80004468:	00fd77b3          	and	a5,s10,a5
    8000446c:	fba1                	bnez	a5,800043bc <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000446e:	e2042d83          	lw	s11,-480(s0)
    80004472:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004476:	f80c03e3          	beqz	s8,800043fc <exec+0x306>
    8000447a:	8a62                	mv	s4,s8
    8000447c:	4901                	li	s2,0
    8000447e:	b345                	j	8000421e <exec+0x128>

0000000080004480 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004480:	7179                	addi	sp,sp,-48
    80004482:	f406                	sd	ra,40(sp)
    80004484:	f022                	sd	s0,32(sp)
    80004486:	ec26                	sd	s1,24(sp)
    80004488:	e84a                	sd	s2,16(sp)
    8000448a:	1800                	addi	s0,sp,48
    8000448c:	892e                	mv	s2,a1
    8000448e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004490:	fdc40593          	addi	a1,s0,-36
    80004494:	ffffe097          	auipc	ra,0xffffe
    80004498:	b06080e7          	jalr	-1274(ra) # 80001f9a <argint>
    8000449c:	04054063          	bltz	a0,800044dc <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044a0:	fdc42703          	lw	a4,-36(s0)
    800044a4:	47bd                	li	a5,15
    800044a6:	02e7ed63          	bltu	a5,a4,800044e0 <argfd+0x60>
    800044aa:	ffffd097          	auipc	ra,0xffffd
    800044ae:	9e8080e7          	jalr	-1560(ra) # 80000e92 <myproc>
    800044b2:	fdc42703          	lw	a4,-36(s0)
    800044b6:	01a70793          	addi	a5,a4,26
    800044ba:	078e                	slli	a5,a5,0x3
    800044bc:	953e                	add	a0,a0,a5
    800044be:	611c                	ld	a5,0(a0)
    800044c0:	c395                	beqz	a5,800044e4 <argfd+0x64>
    return -1;
  if(pfd)
    800044c2:	00090463          	beqz	s2,800044ca <argfd+0x4a>
    *pfd = fd;
    800044c6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044ca:	4501                	li	a0,0
  if(pf)
    800044cc:	c091                	beqz	s1,800044d0 <argfd+0x50>
    *pf = f;
    800044ce:	e09c                	sd	a5,0(s1)
}
    800044d0:	70a2                	ld	ra,40(sp)
    800044d2:	7402                	ld	s0,32(sp)
    800044d4:	64e2                	ld	s1,24(sp)
    800044d6:	6942                	ld	s2,16(sp)
    800044d8:	6145                	addi	sp,sp,48
    800044da:	8082                	ret
    return -1;
    800044dc:	557d                	li	a0,-1
    800044de:	bfcd                	j	800044d0 <argfd+0x50>
    return -1;
    800044e0:	557d                	li	a0,-1
    800044e2:	b7fd                	j	800044d0 <argfd+0x50>
    800044e4:	557d                	li	a0,-1
    800044e6:	b7ed                	j	800044d0 <argfd+0x50>

00000000800044e8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044e8:	1101                	addi	sp,sp,-32
    800044ea:	ec06                	sd	ra,24(sp)
    800044ec:	e822                	sd	s0,16(sp)
    800044ee:	e426                	sd	s1,8(sp)
    800044f0:	1000                	addi	s0,sp,32
    800044f2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044f4:	ffffd097          	auipc	ra,0xffffd
    800044f8:	99e080e7          	jalr	-1634(ra) # 80000e92 <myproc>
    800044fc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044fe:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    80004502:	4501                	li	a0,0
    80004504:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004506:	6398                	ld	a4,0(a5)
    80004508:	cb19                	beqz	a4,8000451e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000450a:	2505                	addiw	a0,a0,1
    8000450c:	07a1                	addi	a5,a5,8
    8000450e:	fed51ce3          	bne	a0,a3,80004506 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004512:	557d                	li	a0,-1
}
    80004514:	60e2                	ld	ra,24(sp)
    80004516:	6442                	ld	s0,16(sp)
    80004518:	64a2                	ld	s1,8(sp)
    8000451a:	6105                	addi	sp,sp,32
    8000451c:	8082                	ret
      p->ofile[fd] = f;
    8000451e:	01a50793          	addi	a5,a0,26
    80004522:	078e                	slli	a5,a5,0x3
    80004524:	963e                	add	a2,a2,a5
    80004526:	e204                	sd	s1,0(a2)
      return fd;
    80004528:	b7f5                	j	80004514 <fdalloc+0x2c>

000000008000452a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000452a:	715d                	addi	sp,sp,-80
    8000452c:	e486                	sd	ra,72(sp)
    8000452e:	e0a2                	sd	s0,64(sp)
    80004530:	fc26                	sd	s1,56(sp)
    80004532:	f84a                	sd	s2,48(sp)
    80004534:	f44e                	sd	s3,40(sp)
    80004536:	f052                	sd	s4,32(sp)
    80004538:	ec56                	sd	s5,24(sp)
    8000453a:	0880                	addi	s0,sp,80
    8000453c:	89ae                	mv	s3,a1
    8000453e:	8ab2                	mv	s5,a2
    80004540:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004542:	fb040593          	addi	a1,s0,-80
    80004546:	fffff097          	auipc	ra,0xfffff
    8000454a:	e86080e7          	jalr	-378(ra) # 800033cc <nameiparent>
    8000454e:	892a                	mv	s2,a0
    80004550:	12050f63          	beqz	a0,8000468e <create+0x164>
    return 0;

  ilock(dp);
    80004554:	ffffe097          	auipc	ra,0xffffe
    80004558:	6a4080e7          	jalr	1700(ra) # 80002bf8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000455c:	4601                	li	a2,0
    8000455e:	fb040593          	addi	a1,s0,-80
    80004562:	854a                	mv	a0,s2
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	b78080e7          	jalr	-1160(ra) # 800030dc <dirlookup>
    8000456c:	84aa                	mv	s1,a0
    8000456e:	c921                	beqz	a0,800045be <create+0x94>
    iunlockput(dp);
    80004570:	854a                	mv	a0,s2
    80004572:	fffff097          	auipc	ra,0xfffff
    80004576:	8e8080e7          	jalr	-1816(ra) # 80002e5a <iunlockput>
    ilock(ip);
    8000457a:	8526                	mv	a0,s1
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	67c080e7          	jalr	1660(ra) # 80002bf8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004584:	2981                	sext.w	s3,s3
    80004586:	4789                	li	a5,2
    80004588:	02f99463          	bne	s3,a5,800045b0 <create+0x86>
    8000458c:	0444d783          	lhu	a5,68(s1)
    80004590:	37f9                	addiw	a5,a5,-2
    80004592:	17c2                	slli	a5,a5,0x30
    80004594:	93c1                	srli	a5,a5,0x30
    80004596:	4705                	li	a4,1
    80004598:	00f76c63          	bltu	a4,a5,800045b0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000459c:	8526                	mv	a0,s1
    8000459e:	60a6                	ld	ra,72(sp)
    800045a0:	6406                	ld	s0,64(sp)
    800045a2:	74e2                	ld	s1,56(sp)
    800045a4:	7942                	ld	s2,48(sp)
    800045a6:	79a2                	ld	s3,40(sp)
    800045a8:	7a02                	ld	s4,32(sp)
    800045aa:	6ae2                	ld	s5,24(sp)
    800045ac:	6161                	addi	sp,sp,80
    800045ae:	8082                	ret
    iunlockput(ip);
    800045b0:	8526                	mv	a0,s1
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	8a8080e7          	jalr	-1880(ra) # 80002e5a <iunlockput>
    return 0;
    800045ba:	4481                	li	s1,0
    800045bc:	b7c5                	j	8000459c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045be:	85ce                	mv	a1,s3
    800045c0:	00092503          	lw	a0,0(s2)
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	49c080e7          	jalr	1180(ra) # 80002a60 <ialloc>
    800045cc:	84aa                	mv	s1,a0
    800045ce:	c529                	beqz	a0,80004618 <create+0xee>
  ilock(ip);
    800045d0:	ffffe097          	auipc	ra,0xffffe
    800045d4:	628080e7          	jalr	1576(ra) # 80002bf8 <ilock>
  ip->major = major;
    800045d8:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045dc:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045e0:	4785                	li	a5,1
    800045e2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045e6:	8526                	mv	a0,s1
    800045e8:	ffffe097          	auipc	ra,0xffffe
    800045ec:	546080e7          	jalr	1350(ra) # 80002b2e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045f0:	2981                	sext.w	s3,s3
    800045f2:	4785                	li	a5,1
    800045f4:	02f98a63          	beq	s3,a5,80004628 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045f8:	40d0                	lw	a2,4(s1)
    800045fa:	fb040593          	addi	a1,s0,-80
    800045fe:	854a                	mv	a0,s2
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	cec080e7          	jalr	-788(ra) # 800032ec <dirlink>
    80004608:	06054b63          	bltz	a0,8000467e <create+0x154>
  iunlockput(dp);
    8000460c:	854a                	mv	a0,s2
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	84c080e7          	jalr	-1972(ra) # 80002e5a <iunlockput>
  return ip;
    80004616:	b759                	j	8000459c <create+0x72>
    panic("create: ialloc");
    80004618:	00004517          	auipc	a0,0x4
    8000461c:	1f050513          	addi	a0,a0,496 # 80008808 <syscall_name+0x2b8>
    80004620:	00001097          	auipc	ra,0x1
    80004624:	688080e7          	jalr	1672(ra) # 80005ca8 <panic>
    dp->nlink++;  // for ".."
    80004628:	04a95783          	lhu	a5,74(s2)
    8000462c:	2785                	addiw	a5,a5,1
    8000462e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004632:	854a                	mv	a0,s2
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	4fa080e7          	jalr	1274(ra) # 80002b2e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000463c:	40d0                	lw	a2,4(s1)
    8000463e:	00004597          	auipc	a1,0x4
    80004642:	1da58593          	addi	a1,a1,474 # 80008818 <syscall_name+0x2c8>
    80004646:	8526                	mv	a0,s1
    80004648:	fffff097          	auipc	ra,0xfffff
    8000464c:	ca4080e7          	jalr	-860(ra) # 800032ec <dirlink>
    80004650:	00054f63          	bltz	a0,8000466e <create+0x144>
    80004654:	00492603          	lw	a2,4(s2)
    80004658:	00004597          	auipc	a1,0x4
    8000465c:	1c858593          	addi	a1,a1,456 # 80008820 <syscall_name+0x2d0>
    80004660:	8526                	mv	a0,s1
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	c8a080e7          	jalr	-886(ra) # 800032ec <dirlink>
    8000466a:	f80557e3          	bgez	a0,800045f8 <create+0xce>
      panic("create dots");
    8000466e:	00004517          	auipc	a0,0x4
    80004672:	1ba50513          	addi	a0,a0,442 # 80008828 <syscall_name+0x2d8>
    80004676:	00001097          	auipc	ra,0x1
    8000467a:	632080e7          	jalr	1586(ra) # 80005ca8 <panic>
    panic("create: dirlink");
    8000467e:	00004517          	auipc	a0,0x4
    80004682:	1ba50513          	addi	a0,a0,442 # 80008838 <syscall_name+0x2e8>
    80004686:	00001097          	auipc	ra,0x1
    8000468a:	622080e7          	jalr	1570(ra) # 80005ca8 <panic>
    return 0;
    8000468e:	84aa                	mv	s1,a0
    80004690:	b731                	j	8000459c <create+0x72>

0000000080004692 <sys_dup>:
{
    80004692:	7179                	addi	sp,sp,-48
    80004694:	f406                	sd	ra,40(sp)
    80004696:	f022                	sd	s0,32(sp)
    80004698:	ec26                	sd	s1,24(sp)
    8000469a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000469c:	fd840613          	addi	a2,s0,-40
    800046a0:	4581                	li	a1,0
    800046a2:	4501                	li	a0,0
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	ddc080e7          	jalr	-548(ra) # 80004480 <argfd>
    return -1;
    800046ac:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046ae:	02054363          	bltz	a0,800046d4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046b2:	fd843503          	ld	a0,-40(s0)
    800046b6:	00000097          	auipc	ra,0x0
    800046ba:	e32080e7          	jalr	-462(ra) # 800044e8 <fdalloc>
    800046be:	84aa                	mv	s1,a0
    return -1;
    800046c0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046c2:	00054963          	bltz	a0,800046d4 <sys_dup+0x42>
  filedup(f);
    800046c6:	fd843503          	ld	a0,-40(s0)
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	37a080e7          	jalr	890(ra) # 80003a44 <filedup>
  return fd;
    800046d2:	87a6                	mv	a5,s1
}
    800046d4:	853e                	mv	a0,a5
    800046d6:	70a2                	ld	ra,40(sp)
    800046d8:	7402                	ld	s0,32(sp)
    800046da:	64e2                	ld	s1,24(sp)
    800046dc:	6145                	addi	sp,sp,48
    800046de:	8082                	ret

00000000800046e0 <sys_read>:
{
    800046e0:	7179                	addi	sp,sp,-48
    800046e2:	f406                	sd	ra,40(sp)
    800046e4:	f022                	sd	s0,32(sp)
    800046e6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e8:	fe840613          	addi	a2,s0,-24
    800046ec:	4581                	li	a1,0
    800046ee:	4501                	li	a0,0
    800046f0:	00000097          	auipc	ra,0x0
    800046f4:	d90080e7          	jalr	-624(ra) # 80004480 <argfd>
    return -1;
    800046f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fa:	04054163          	bltz	a0,8000473c <sys_read+0x5c>
    800046fe:	fe440593          	addi	a1,s0,-28
    80004702:	4509                	li	a0,2
    80004704:	ffffe097          	auipc	ra,0xffffe
    80004708:	896080e7          	jalr	-1898(ra) # 80001f9a <argint>
    return -1;
    8000470c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000470e:	02054763          	bltz	a0,8000473c <sys_read+0x5c>
    80004712:	fd840593          	addi	a1,s0,-40
    80004716:	4505                	li	a0,1
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	8a4080e7          	jalr	-1884(ra) # 80001fbc <argaddr>
    return -1;
    80004720:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004722:	00054d63          	bltz	a0,8000473c <sys_read+0x5c>
  return fileread(f, p, n);
    80004726:	fe442603          	lw	a2,-28(s0)
    8000472a:	fd843583          	ld	a1,-40(s0)
    8000472e:	fe843503          	ld	a0,-24(s0)
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	49e080e7          	jalr	1182(ra) # 80003bd0 <fileread>
    8000473a:	87aa                	mv	a5,a0
}
    8000473c:	853e                	mv	a0,a5
    8000473e:	70a2                	ld	ra,40(sp)
    80004740:	7402                	ld	s0,32(sp)
    80004742:	6145                	addi	sp,sp,48
    80004744:	8082                	ret

0000000080004746 <sys_write>:
{
    80004746:	7179                	addi	sp,sp,-48
    80004748:	f406                	sd	ra,40(sp)
    8000474a:	f022                	sd	s0,32(sp)
    8000474c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474e:	fe840613          	addi	a2,s0,-24
    80004752:	4581                	li	a1,0
    80004754:	4501                	li	a0,0
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	d2a080e7          	jalr	-726(ra) # 80004480 <argfd>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004760:	04054163          	bltz	a0,800047a2 <sys_write+0x5c>
    80004764:	fe440593          	addi	a1,s0,-28
    80004768:	4509                	li	a0,2
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	830080e7          	jalr	-2000(ra) # 80001f9a <argint>
    return -1;
    80004772:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004774:	02054763          	bltz	a0,800047a2 <sys_write+0x5c>
    80004778:	fd840593          	addi	a1,s0,-40
    8000477c:	4505                	li	a0,1
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	83e080e7          	jalr	-1986(ra) # 80001fbc <argaddr>
    return -1;
    80004786:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004788:	00054d63          	bltz	a0,800047a2 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000478c:	fe442603          	lw	a2,-28(s0)
    80004790:	fd843583          	ld	a1,-40(s0)
    80004794:	fe843503          	ld	a0,-24(s0)
    80004798:	fffff097          	auipc	ra,0xfffff
    8000479c:	4fa080e7          	jalr	1274(ra) # 80003c92 <filewrite>
    800047a0:	87aa                	mv	a5,a0
}
    800047a2:	853e                	mv	a0,a5
    800047a4:	70a2                	ld	ra,40(sp)
    800047a6:	7402                	ld	s0,32(sp)
    800047a8:	6145                	addi	sp,sp,48
    800047aa:	8082                	ret

00000000800047ac <sys_close>:
{
    800047ac:	1101                	addi	sp,sp,-32
    800047ae:	ec06                	sd	ra,24(sp)
    800047b0:	e822                	sd	s0,16(sp)
    800047b2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047b4:	fe040613          	addi	a2,s0,-32
    800047b8:	fec40593          	addi	a1,s0,-20
    800047bc:	4501                	li	a0,0
    800047be:	00000097          	auipc	ra,0x0
    800047c2:	cc2080e7          	jalr	-830(ra) # 80004480 <argfd>
    return -1;
    800047c6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047c8:	02054463          	bltz	a0,800047f0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047cc:	ffffc097          	auipc	ra,0xffffc
    800047d0:	6c6080e7          	jalr	1734(ra) # 80000e92 <myproc>
    800047d4:	fec42783          	lw	a5,-20(s0)
    800047d8:	07e9                	addi	a5,a5,26
    800047da:	078e                	slli	a5,a5,0x3
    800047dc:	97aa                	add	a5,a5,a0
    800047de:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047e2:	fe043503          	ld	a0,-32(s0)
    800047e6:	fffff097          	auipc	ra,0xfffff
    800047ea:	2b0080e7          	jalr	688(ra) # 80003a96 <fileclose>
  return 0;
    800047ee:	4781                	li	a5,0
}
    800047f0:	853e                	mv	a0,a5
    800047f2:	60e2                	ld	ra,24(sp)
    800047f4:	6442                	ld	s0,16(sp)
    800047f6:	6105                	addi	sp,sp,32
    800047f8:	8082                	ret

00000000800047fa <sys_fstat>:
{
    800047fa:	1101                	addi	sp,sp,-32
    800047fc:	ec06                	sd	ra,24(sp)
    800047fe:	e822                	sd	s0,16(sp)
    80004800:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004802:	fe840613          	addi	a2,s0,-24
    80004806:	4581                	li	a1,0
    80004808:	4501                	li	a0,0
    8000480a:	00000097          	auipc	ra,0x0
    8000480e:	c76080e7          	jalr	-906(ra) # 80004480 <argfd>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004814:	02054563          	bltz	a0,8000483e <sys_fstat+0x44>
    80004818:	fe040593          	addi	a1,s0,-32
    8000481c:	4505                	li	a0,1
    8000481e:	ffffd097          	auipc	ra,0xffffd
    80004822:	79e080e7          	jalr	1950(ra) # 80001fbc <argaddr>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004828:	00054b63          	bltz	a0,8000483e <sys_fstat+0x44>
  return filestat(f, st);
    8000482c:	fe043583          	ld	a1,-32(s0)
    80004830:	fe843503          	ld	a0,-24(s0)
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	32a080e7          	jalr	810(ra) # 80003b5e <filestat>
    8000483c:	87aa                	mv	a5,a0
}
    8000483e:	853e                	mv	a0,a5
    80004840:	60e2                	ld	ra,24(sp)
    80004842:	6442                	ld	s0,16(sp)
    80004844:	6105                	addi	sp,sp,32
    80004846:	8082                	ret

0000000080004848 <sys_link>:
{
    80004848:	7169                	addi	sp,sp,-304
    8000484a:	f606                	sd	ra,296(sp)
    8000484c:	f222                	sd	s0,288(sp)
    8000484e:	ee26                	sd	s1,280(sp)
    80004850:	ea4a                	sd	s2,272(sp)
    80004852:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004854:	08000613          	li	a2,128
    80004858:	ed040593          	addi	a1,s0,-304
    8000485c:	4501                	li	a0,0
    8000485e:	ffffd097          	auipc	ra,0xffffd
    80004862:	780080e7          	jalr	1920(ra) # 80001fde <argstr>
    return -1;
    80004866:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004868:	10054e63          	bltz	a0,80004984 <sys_link+0x13c>
    8000486c:	08000613          	li	a2,128
    80004870:	f5040593          	addi	a1,s0,-176
    80004874:	4505                	li	a0,1
    80004876:	ffffd097          	auipc	ra,0xffffd
    8000487a:	768080e7          	jalr	1896(ra) # 80001fde <argstr>
    return -1;
    8000487e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004880:	10054263          	bltz	a0,80004984 <sys_link+0x13c>
  begin_op();
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	d46080e7          	jalr	-698(ra) # 800035ca <begin_op>
  if((ip = namei(old)) == 0){
    8000488c:	ed040513          	addi	a0,s0,-304
    80004890:	fffff097          	auipc	ra,0xfffff
    80004894:	b1e080e7          	jalr	-1250(ra) # 800033ae <namei>
    80004898:	84aa                	mv	s1,a0
    8000489a:	c551                	beqz	a0,80004926 <sys_link+0xde>
  ilock(ip);
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	35c080e7          	jalr	860(ra) # 80002bf8 <ilock>
  if(ip->type == T_DIR){
    800048a4:	04449703          	lh	a4,68(s1)
    800048a8:	4785                	li	a5,1
    800048aa:	08f70463          	beq	a4,a5,80004932 <sys_link+0xea>
  ip->nlink++;
    800048ae:	04a4d783          	lhu	a5,74(s1)
    800048b2:	2785                	addiw	a5,a5,1
    800048b4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	274080e7          	jalr	628(ra) # 80002b2e <iupdate>
  iunlock(ip);
    800048c2:	8526                	mv	a0,s1
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	3f6080e7          	jalr	1014(ra) # 80002cba <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048cc:	fd040593          	addi	a1,s0,-48
    800048d0:	f5040513          	addi	a0,s0,-176
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	af8080e7          	jalr	-1288(ra) # 800033cc <nameiparent>
    800048dc:	892a                	mv	s2,a0
    800048de:	c935                	beqz	a0,80004952 <sys_link+0x10a>
  ilock(dp);
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	318080e7          	jalr	792(ra) # 80002bf8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048e8:	00092703          	lw	a4,0(s2)
    800048ec:	409c                	lw	a5,0(s1)
    800048ee:	04f71d63          	bne	a4,a5,80004948 <sys_link+0x100>
    800048f2:	40d0                	lw	a2,4(s1)
    800048f4:	fd040593          	addi	a1,s0,-48
    800048f8:	854a                	mv	a0,s2
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	9f2080e7          	jalr	-1550(ra) # 800032ec <dirlink>
    80004902:	04054363          	bltz	a0,80004948 <sys_link+0x100>
  iunlockput(dp);
    80004906:	854a                	mv	a0,s2
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	552080e7          	jalr	1362(ra) # 80002e5a <iunlockput>
  iput(ip);
    80004910:	8526                	mv	a0,s1
    80004912:	ffffe097          	auipc	ra,0xffffe
    80004916:	4a0080e7          	jalr	1184(ra) # 80002db2 <iput>
  end_op();
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	d30080e7          	jalr	-720(ra) # 8000364a <end_op>
  return 0;
    80004922:	4781                	li	a5,0
    80004924:	a085                	j	80004984 <sys_link+0x13c>
    end_op();
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	d24080e7          	jalr	-732(ra) # 8000364a <end_op>
    return -1;
    8000492e:	57fd                	li	a5,-1
    80004930:	a891                	j	80004984 <sys_link+0x13c>
    iunlockput(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	526080e7          	jalr	1318(ra) # 80002e5a <iunlockput>
    end_op();
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	d0e080e7          	jalr	-754(ra) # 8000364a <end_op>
    return -1;
    80004944:	57fd                	li	a5,-1
    80004946:	a83d                	j	80004984 <sys_link+0x13c>
    iunlockput(dp);
    80004948:	854a                	mv	a0,s2
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	510080e7          	jalr	1296(ra) # 80002e5a <iunlockput>
  ilock(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	2a4080e7          	jalr	676(ra) # 80002bf8 <ilock>
  ip->nlink--;
    8000495c:	04a4d783          	lhu	a5,74(s1)
    80004960:	37fd                	addiw	a5,a5,-1
    80004962:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	1c6080e7          	jalr	454(ra) # 80002b2e <iupdate>
  iunlockput(ip);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	4e8080e7          	jalr	1256(ra) # 80002e5a <iunlockput>
  end_op();
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	cd0080e7          	jalr	-816(ra) # 8000364a <end_op>
  return -1;
    80004982:	57fd                	li	a5,-1
}
    80004984:	853e                	mv	a0,a5
    80004986:	70b2                	ld	ra,296(sp)
    80004988:	7412                	ld	s0,288(sp)
    8000498a:	64f2                	ld	s1,280(sp)
    8000498c:	6952                	ld	s2,272(sp)
    8000498e:	6155                	addi	sp,sp,304
    80004990:	8082                	ret

0000000080004992 <sys_unlink>:
{
    80004992:	7151                	addi	sp,sp,-240
    80004994:	f586                	sd	ra,232(sp)
    80004996:	f1a2                	sd	s0,224(sp)
    80004998:	eda6                	sd	s1,216(sp)
    8000499a:	e9ca                	sd	s2,208(sp)
    8000499c:	e5ce                	sd	s3,200(sp)
    8000499e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049a0:	08000613          	li	a2,128
    800049a4:	f3040593          	addi	a1,s0,-208
    800049a8:	4501                	li	a0,0
    800049aa:	ffffd097          	auipc	ra,0xffffd
    800049ae:	634080e7          	jalr	1588(ra) # 80001fde <argstr>
    800049b2:	18054163          	bltz	a0,80004b34 <sys_unlink+0x1a2>
  begin_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	c14080e7          	jalr	-1004(ra) # 800035ca <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049be:	fb040593          	addi	a1,s0,-80
    800049c2:	f3040513          	addi	a0,s0,-208
    800049c6:	fffff097          	auipc	ra,0xfffff
    800049ca:	a06080e7          	jalr	-1530(ra) # 800033cc <nameiparent>
    800049ce:	84aa                	mv	s1,a0
    800049d0:	c979                	beqz	a0,80004aa6 <sys_unlink+0x114>
  ilock(dp);
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	226080e7          	jalr	550(ra) # 80002bf8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049da:	00004597          	auipc	a1,0x4
    800049de:	e3e58593          	addi	a1,a1,-450 # 80008818 <syscall_name+0x2c8>
    800049e2:	fb040513          	addi	a0,s0,-80
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	6dc080e7          	jalr	1756(ra) # 800030c2 <namecmp>
    800049ee:	14050a63          	beqz	a0,80004b42 <sys_unlink+0x1b0>
    800049f2:	00004597          	auipc	a1,0x4
    800049f6:	e2e58593          	addi	a1,a1,-466 # 80008820 <syscall_name+0x2d0>
    800049fa:	fb040513          	addi	a0,s0,-80
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	6c4080e7          	jalr	1732(ra) # 800030c2 <namecmp>
    80004a06:	12050e63          	beqz	a0,80004b42 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a0a:	f2c40613          	addi	a2,s0,-212
    80004a0e:	fb040593          	addi	a1,s0,-80
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	6c8080e7          	jalr	1736(ra) # 800030dc <dirlookup>
    80004a1c:	892a                	mv	s2,a0
    80004a1e:	12050263          	beqz	a0,80004b42 <sys_unlink+0x1b0>
  ilock(ip);
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	1d6080e7          	jalr	470(ra) # 80002bf8 <ilock>
  if(ip->nlink < 1)
    80004a2a:	04a91783          	lh	a5,74(s2)
    80004a2e:	08f05263          	blez	a5,80004ab2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a32:	04491703          	lh	a4,68(s2)
    80004a36:	4785                	li	a5,1
    80004a38:	08f70563          	beq	a4,a5,80004ac2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a3c:	4641                	li	a2,16
    80004a3e:	4581                	li	a1,0
    80004a40:	fc040513          	addi	a0,s0,-64
    80004a44:	ffffb097          	auipc	ra,0xffffb
    80004a48:	77e080e7          	jalr	1918(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a4c:	4741                	li	a4,16
    80004a4e:	f2c42683          	lw	a3,-212(s0)
    80004a52:	fc040613          	addi	a2,s0,-64
    80004a56:	4581                	li	a1,0
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	54a080e7          	jalr	1354(ra) # 80002fa4 <writei>
    80004a62:	47c1                	li	a5,16
    80004a64:	0af51563          	bne	a0,a5,80004b0e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a68:	04491703          	lh	a4,68(s2)
    80004a6c:	4785                	li	a5,1
    80004a6e:	0af70863          	beq	a4,a5,80004b1e <sys_unlink+0x18c>
  iunlockput(dp);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	3e6080e7          	jalr	998(ra) # 80002e5a <iunlockput>
  ip->nlink--;
    80004a7c:	04a95783          	lhu	a5,74(s2)
    80004a80:	37fd                	addiw	a5,a5,-1
    80004a82:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	0a6080e7          	jalr	166(ra) # 80002b2e <iupdate>
  iunlockput(ip);
    80004a90:	854a                	mv	a0,s2
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	3c8080e7          	jalr	968(ra) # 80002e5a <iunlockput>
  end_op();
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	bb0080e7          	jalr	-1104(ra) # 8000364a <end_op>
  return 0;
    80004aa2:	4501                	li	a0,0
    80004aa4:	a84d                	j	80004b56 <sys_unlink+0x1c4>
    end_op();
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	ba4080e7          	jalr	-1116(ra) # 8000364a <end_op>
    return -1;
    80004aae:	557d                	li	a0,-1
    80004ab0:	a05d                	j	80004b56 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ab2:	00004517          	auipc	a0,0x4
    80004ab6:	d9650513          	addi	a0,a0,-618 # 80008848 <syscall_name+0x2f8>
    80004aba:	00001097          	auipc	ra,0x1
    80004abe:	1ee080e7          	jalr	494(ra) # 80005ca8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ac2:	04c92703          	lw	a4,76(s2)
    80004ac6:	02000793          	li	a5,32
    80004aca:	f6e7f9e3          	bgeu	a5,a4,80004a3c <sys_unlink+0xaa>
    80004ace:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ad2:	4741                	li	a4,16
    80004ad4:	86ce                	mv	a3,s3
    80004ad6:	f1840613          	addi	a2,s0,-232
    80004ada:	4581                	li	a1,0
    80004adc:	854a                	mv	a0,s2
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	3ce080e7          	jalr	974(ra) # 80002eac <readi>
    80004ae6:	47c1                	li	a5,16
    80004ae8:	00f51b63          	bne	a0,a5,80004afe <sys_unlink+0x16c>
    if(de.inum != 0)
    80004aec:	f1845783          	lhu	a5,-232(s0)
    80004af0:	e7a1                	bnez	a5,80004b38 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004af2:	29c1                	addiw	s3,s3,16
    80004af4:	04c92783          	lw	a5,76(s2)
    80004af8:	fcf9ede3          	bltu	s3,a5,80004ad2 <sys_unlink+0x140>
    80004afc:	b781                	j	80004a3c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004afe:	00004517          	auipc	a0,0x4
    80004b02:	d6250513          	addi	a0,a0,-670 # 80008860 <syscall_name+0x310>
    80004b06:	00001097          	auipc	ra,0x1
    80004b0a:	1a2080e7          	jalr	418(ra) # 80005ca8 <panic>
    panic("unlink: writei");
    80004b0e:	00004517          	auipc	a0,0x4
    80004b12:	d6a50513          	addi	a0,a0,-662 # 80008878 <syscall_name+0x328>
    80004b16:	00001097          	auipc	ra,0x1
    80004b1a:	192080e7          	jalr	402(ra) # 80005ca8 <panic>
    dp->nlink--;
    80004b1e:	04a4d783          	lhu	a5,74(s1)
    80004b22:	37fd                	addiw	a5,a5,-1
    80004b24:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	004080e7          	jalr	4(ra) # 80002b2e <iupdate>
    80004b32:	b781                	j	80004a72 <sys_unlink+0xe0>
    return -1;
    80004b34:	557d                	li	a0,-1
    80004b36:	a005                	j	80004b56 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	320080e7          	jalr	800(ra) # 80002e5a <iunlockput>
  iunlockput(dp);
    80004b42:	8526                	mv	a0,s1
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	316080e7          	jalr	790(ra) # 80002e5a <iunlockput>
  end_op();
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	afe080e7          	jalr	-1282(ra) # 8000364a <end_op>
  return -1;
    80004b54:	557d                	li	a0,-1
}
    80004b56:	70ae                	ld	ra,232(sp)
    80004b58:	740e                	ld	s0,224(sp)
    80004b5a:	64ee                	ld	s1,216(sp)
    80004b5c:	694e                	ld	s2,208(sp)
    80004b5e:	69ae                	ld	s3,200(sp)
    80004b60:	616d                	addi	sp,sp,240
    80004b62:	8082                	ret

0000000080004b64 <sys_open>:

uint64
sys_open(void)
{
    80004b64:	7131                	addi	sp,sp,-192
    80004b66:	fd06                	sd	ra,184(sp)
    80004b68:	f922                	sd	s0,176(sp)
    80004b6a:	f526                	sd	s1,168(sp)
    80004b6c:	f14a                	sd	s2,160(sp)
    80004b6e:	ed4e                	sd	s3,152(sp)
    80004b70:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b72:	08000613          	li	a2,128
    80004b76:	f5040593          	addi	a1,s0,-176
    80004b7a:	4501                	li	a0,0
    80004b7c:	ffffd097          	auipc	ra,0xffffd
    80004b80:	462080e7          	jalr	1122(ra) # 80001fde <argstr>
    return -1;
    80004b84:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b86:	0c054163          	bltz	a0,80004c48 <sys_open+0xe4>
    80004b8a:	f4c40593          	addi	a1,s0,-180
    80004b8e:	4505                	li	a0,1
    80004b90:	ffffd097          	auipc	ra,0xffffd
    80004b94:	40a080e7          	jalr	1034(ra) # 80001f9a <argint>
    80004b98:	0a054863          	bltz	a0,80004c48 <sys_open+0xe4>

  begin_op();
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	a2e080e7          	jalr	-1490(ra) # 800035ca <begin_op>

  if(omode & O_CREATE){
    80004ba4:	f4c42783          	lw	a5,-180(s0)
    80004ba8:	2007f793          	andi	a5,a5,512
    80004bac:	cbdd                	beqz	a5,80004c62 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bae:	4681                	li	a3,0
    80004bb0:	4601                	li	a2,0
    80004bb2:	4589                	li	a1,2
    80004bb4:	f5040513          	addi	a0,s0,-176
    80004bb8:	00000097          	auipc	ra,0x0
    80004bbc:	972080e7          	jalr	-1678(ra) # 8000452a <create>
    80004bc0:	892a                	mv	s2,a0
    if(ip == 0){
    80004bc2:	c959                	beqz	a0,80004c58 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bc4:	04491703          	lh	a4,68(s2)
    80004bc8:	478d                	li	a5,3
    80004bca:	00f71763          	bne	a4,a5,80004bd8 <sys_open+0x74>
    80004bce:	04695703          	lhu	a4,70(s2)
    80004bd2:	47a5                	li	a5,9
    80004bd4:	0ce7ec63          	bltu	a5,a4,80004cac <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	e02080e7          	jalr	-510(ra) # 800039da <filealloc>
    80004be0:	89aa                	mv	s3,a0
    80004be2:	10050263          	beqz	a0,80004ce6 <sys_open+0x182>
    80004be6:	00000097          	auipc	ra,0x0
    80004bea:	902080e7          	jalr	-1790(ra) # 800044e8 <fdalloc>
    80004bee:	84aa                	mv	s1,a0
    80004bf0:	0e054663          	bltz	a0,80004cdc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bf4:	04491703          	lh	a4,68(s2)
    80004bf8:	478d                	li	a5,3
    80004bfa:	0cf70463          	beq	a4,a5,80004cc2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bfe:	4789                	li	a5,2
    80004c00:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c04:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c08:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c0c:	f4c42783          	lw	a5,-180(s0)
    80004c10:	0017c713          	xori	a4,a5,1
    80004c14:	8b05                	andi	a4,a4,1
    80004c16:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c1a:	0037f713          	andi	a4,a5,3
    80004c1e:	00e03733          	snez	a4,a4
    80004c22:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c26:	4007f793          	andi	a5,a5,1024
    80004c2a:	c791                	beqz	a5,80004c36 <sys_open+0xd2>
    80004c2c:	04491703          	lh	a4,68(s2)
    80004c30:	4789                	li	a5,2
    80004c32:	08f70f63          	beq	a4,a5,80004cd0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c36:	854a                	mv	a0,s2
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	082080e7          	jalr	130(ra) # 80002cba <iunlock>
  end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	a0a080e7          	jalr	-1526(ra) # 8000364a <end_op>

  return fd;
}
    80004c48:	8526                	mv	a0,s1
    80004c4a:	70ea                	ld	ra,184(sp)
    80004c4c:	744a                	ld	s0,176(sp)
    80004c4e:	74aa                	ld	s1,168(sp)
    80004c50:	790a                	ld	s2,160(sp)
    80004c52:	69ea                	ld	s3,152(sp)
    80004c54:	6129                	addi	sp,sp,192
    80004c56:	8082                	ret
      end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	9f2080e7          	jalr	-1550(ra) # 8000364a <end_op>
      return -1;
    80004c60:	b7e5                	j	80004c48 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c62:	f5040513          	addi	a0,s0,-176
    80004c66:	ffffe097          	auipc	ra,0xffffe
    80004c6a:	748080e7          	jalr	1864(ra) # 800033ae <namei>
    80004c6e:	892a                	mv	s2,a0
    80004c70:	c905                	beqz	a0,80004ca0 <sys_open+0x13c>
    ilock(ip);
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	f86080e7          	jalr	-122(ra) # 80002bf8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c7a:	04491703          	lh	a4,68(s2)
    80004c7e:	4785                	li	a5,1
    80004c80:	f4f712e3          	bne	a4,a5,80004bc4 <sys_open+0x60>
    80004c84:	f4c42783          	lw	a5,-180(s0)
    80004c88:	dba1                	beqz	a5,80004bd8 <sys_open+0x74>
      iunlockput(ip);
    80004c8a:	854a                	mv	a0,s2
    80004c8c:	ffffe097          	auipc	ra,0xffffe
    80004c90:	1ce080e7          	jalr	462(ra) # 80002e5a <iunlockput>
      end_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	9b6080e7          	jalr	-1610(ra) # 8000364a <end_op>
      return -1;
    80004c9c:	54fd                	li	s1,-1
    80004c9e:	b76d                	j	80004c48 <sys_open+0xe4>
      end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	9aa080e7          	jalr	-1622(ra) # 8000364a <end_op>
      return -1;
    80004ca8:	54fd                	li	s1,-1
    80004caa:	bf79                	j	80004c48 <sys_open+0xe4>
    iunlockput(ip);
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	1ac080e7          	jalr	428(ra) # 80002e5a <iunlockput>
    end_op();
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	994080e7          	jalr	-1644(ra) # 8000364a <end_op>
    return -1;
    80004cbe:	54fd                	li	s1,-1
    80004cc0:	b761                	j	80004c48 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cc2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cc6:	04691783          	lh	a5,70(s2)
    80004cca:	02f99223          	sh	a5,36(s3)
    80004cce:	bf2d                	j	80004c08 <sys_open+0xa4>
    itrunc(ip);
    80004cd0:	854a                	mv	a0,s2
    80004cd2:	ffffe097          	auipc	ra,0xffffe
    80004cd6:	034080e7          	jalr	52(ra) # 80002d06 <itrunc>
    80004cda:	bfb1                	j	80004c36 <sys_open+0xd2>
      fileclose(f);
    80004cdc:	854e                	mv	a0,s3
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	db8080e7          	jalr	-584(ra) # 80003a96 <fileclose>
    iunlockput(ip);
    80004ce6:	854a                	mv	a0,s2
    80004ce8:	ffffe097          	auipc	ra,0xffffe
    80004cec:	172080e7          	jalr	370(ra) # 80002e5a <iunlockput>
    end_op();
    80004cf0:	fffff097          	auipc	ra,0xfffff
    80004cf4:	95a080e7          	jalr	-1702(ra) # 8000364a <end_op>
    return -1;
    80004cf8:	54fd                	li	s1,-1
    80004cfa:	b7b9                	j	80004c48 <sys_open+0xe4>

0000000080004cfc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cfc:	7175                	addi	sp,sp,-144
    80004cfe:	e506                	sd	ra,136(sp)
    80004d00:	e122                	sd	s0,128(sp)
    80004d02:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	8c6080e7          	jalr	-1850(ra) # 800035ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d0c:	08000613          	li	a2,128
    80004d10:	f7040593          	addi	a1,s0,-144
    80004d14:	4501                	li	a0,0
    80004d16:	ffffd097          	auipc	ra,0xffffd
    80004d1a:	2c8080e7          	jalr	712(ra) # 80001fde <argstr>
    80004d1e:	02054963          	bltz	a0,80004d50 <sys_mkdir+0x54>
    80004d22:	4681                	li	a3,0
    80004d24:	4601                	li	a2,0
    80004d26:	4585                	li	a1,1
    80004d28:	f7040513          	addi	a0,s0,-144
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	7fe080e7          	jalr	2046(ra) # 8000452a <create>
    80004d34:	cd11                	beqz	a0,80004d50 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	124080e7          	jalr	292(ra) # 80002e5a <iunlockput>
  end_op();
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	90c080e7          	jalr	-1780(ra) # 8000364a <end_op>
  return 0;
    80004d46:	4501                	li	a0,0
}
    80004d48:	60aa                	ld	ra,136(sp)
    80004d4a:	640a                	ld	s0,128(sp)
    80004d4c:	6149                	addi	sp,sp,144
    80004d4e:	8082                	ret
    end_op();
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	8fa080e7          	jalr	-1798(ra) # 8000364a <end_op>
    return -1;
    80004d58:	557d                	li	a0,-1
    80004d5a:	b7fd                	j	80004d48 <sys_mkdir+0x4c>

0000000080004d5c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d5c:	7135                	addi	sp,sp,-160
    80004d5e:	ed06                	sd	ra,152(sp)
    80004d60:	e922                	sd	s0,144(sp)
    80004d62:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	866080e7          	jalr	-1946(ra) # 800035ca <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d6c:	08000613          	li	a2,128
    80004d70:	f7040593          	addi	a1,s0,-144
    80004d74:	4501                	li	a0,0
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	268080e7          	jalr	616(ra) # 80001fde <argstr>
    80004d7e:	04054a63          	bltz	a0,80004dd2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d82:	f6c40593          	addi	a1,s0,-148
    80004d86:	4505                	li	a0,1
    80004d88:	ffffd097          	auipc	ra,0xffffd
    80004d8c:	212080e7          	jalr	530(ra) # 80001f9a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d90:	04054163          	bltz	a0,80004dd2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d94:	f6840593          	addi	a1,s0,-152
    80004d98:	4509                	li	a0,2
    80004d9a:	ffffd097          	auipc	ra,0xffffd
    80004d9e:	200080e7          	jalr	512(ra) # 80001f9a <argint>
     argint(1, &major) < 0 ||
    80004da2:	02054863          	bltz	a0,80004dd2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004da6:	f6841683          	lh	a3,-152(s0)
    80004daa:	f6c41603          	lh	a2,-148(s0)
    80004dae:	458d                	li	a1,3
    80004db0:	f7040513          	addi	a0,s0,-144
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	776080e7          	jalr	1910(ra) # 8000452a <create>
     argint(2, &minor) < 0 ||
    80004dbc:	c919                	beqz	a0,80004dd2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	09c080e7          	jalr	156(ra) # 80002e5a <iunlockput>
  end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	884080e7          	jalr	-1916(ra) # 8000364a <end_op>
  return 0;
    80004dce:	4501                	li	a0,0
    80004dd0:	a031                	j	80004ddc <sys_mknod+0x80>
    end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	878080e7          	jalr	-1928(ra) # 8000364a <end_op>
    return -1;
    80004dda:	557d                	li	a0,-1
}
    80004ddc:	60ea                	ld	ra,152(sp)
    80004dde:	644a                	ld	s0,144(sp)
    80004de0:	610d                	addi	sp,sp,160
    80004de2:	8082                	ret

0000000080004de4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004de4:	7135                	addi	sp,sp,-160
    80004de6:	ed06                	sd	ra,152(sp)
    80004de8:	e922                	sd	s0,144(sp)
    80004dea:	e526                	sd	s1,136(sp)
    80004dec:	e14a                	sd	s2,128(sp)
    80004dee:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004df0:	ffffc097          	auipc	ra,0xffffc
    80004df4:	0a2080e7          	jalr	162(ra) # 80000e92 <myproc>
    80004df8:	892a                	mv	s2,a0
  
  begin_op();
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	7d0080e7          	jalr	2000(ra) # 800035ca <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e02:	08000613          	li	a2,128
    80004e06:	f6040593          	addi	a1,s0,-160
    80004e0a:	4501                	li	a0,0
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	1d2080e7          	jalr	466(ra) # 80001fde <argstr>
    80004e14:	04054b63          	bltz	a0,80004e6a <sys_chdir+0x86>
    80004e18:	f6040513          	addi	a0,s0,-160
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	592080e7          	jalr	1426(ra) # 800033ae <namei>
    80004e24:	84aa                	mv	s1,a0
    80004e26:	c131                	beqz	a0,80004e6a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	dd0080e7          	jalr	-560(ra) # 80002bf8 <ilock>
  if(ip->type != T_DIR){
    80004e30:	04449703          	lh	a4,68(s1)
    80004e34:	4785                	li	a5,1
    80004e36:	04f71063          	bne	a4,a5,80004e76 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e3a:	8526                	mv	a0,s1
    80004e3c:	ffffe097          	auipc	ra,0xffffe
    80004e40:	e7e080e7          	jalr	-386(ra) # 80002cba <iunlock>
  iput(p->cwd);
    80004e44:	15093503          	ld	a0,336(s2)
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	f6a080e7          	jalr	-150(ra) # 80002db2 <iput>
  end_op();
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	7fa080e7          	jalr	2042(ra) # 8000364a <end_op>
  p->cwd = ip;
    80004e58:	14993823          	sd	s1,336(s2)
  return 0;
    80004e5c:	4501                	li	a0,0
}
    80004e5e:	60ea                	ld	ra,152(sp)
    80004e60:	644a                	ld	s0,144(sp)
    80004e62:	64aa                	ld	s1,136(sp)
    80004e64:	690a                	ld	s2,128(sp)
    80004e66:	610d                	addi	sp,sp,160
    80004e68:	8082                	ret
    end_op();
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	7e0080e7          	jalr	2016(ra) # 8000364a <end_op>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	b7ed                	j	80004e5e <sys_chdir+0x7a>
    iunlockput(ip);
    80004e76:	8526                	mv	a0,s1
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	fe2080e7          	jalr	-30(ra) # 80002e5a <iunlockput>
    end_op();
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	7ca080e7          	jalr	1994(ra) # 8000364a <end_op>
    return -1;
    80004e88:	557d                	li	a0,-1
    80004e8a:	bfd1                	j	80004e5e <sys_chdir+0x7a>

0000000080004e8c <sys_exec>:

uint64
sys_exec(void)
{
    80004e8c:	7145                	addi	sp,sp,-464
    80004e8e:	e786                	sd	ra,456(sp)
    80004e90:	e3a2                	sd	s0,448(sp)
    80004e92:	ff26                	sd	s1,440(sp)
    80004e94:	fb4a                	sd	s2,432(sp)
    80004e96:	f74e                	sd	s3,424(sp)
    80004e98:	f352                	sd	s4,416(sp)
    80004e9a:	ef56                	sd	s5,408(sp)
    80004e9c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e9e:	08000613          	li	a2,128
    80004ea2:	f4040593          	addi	a1,s0,-192
    80004ea6:	4501                	li	a0,0
    80004ea8:	ffffd097          	auipc	ra,0xffffd
    80004eac:	136080e7          	jalr	310(ra) # 80001fde <argstr>
    return -1;
    80004eb0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eb2:	0c054a63          	bltz	a0,80004f86 <sys_exec+0xfa>
    80004eb6:	e3840593          	addi	a1,s0,-456
    80004eba:	4505                	li	a0,1
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	100080e7          	jalr	256(ra) # 80001fbc <argaddr>
    80004ec4:	0c054163          	bltz	a0,80004f86 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ec8:	10000613          	li	a2,256
    80004ecc:	4581                	li	a1,0
    80004ece:	e4040513          	addi	a0,s0,-448
    80004ed2:	ffffb097          	auipc	ra,0xffffb
    80004ed6:	2f0080e7          	jalr	752(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eda:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ede:	89a6                	mv	s3,s1
    80004ee0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ee2:	02000a13          	li	s4,32
    80004ee6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eea:	00391513          	slli	a0,s2,0x3
    80004eee:	e3040593          	addi	a1,s0,-464
    80004ef2:	e3843783          	ld	a5,-456(s0)
    80004ef6:	953e                	add	a0,a0,a5
    80004ef8:	ffffd097          	auipc	ra,0xffffd
    80004efc:	008080e7          	jalr	8(ra) # 80001f00 <fetchaddr>
    80004f00:	02054a63          	bltz	a0,80004f34 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f04:	e3043783          	ld	a5,-464(s0)
    80004f08:	c3b9                	beqz	a5,80004f4e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f0a:	ffffb097          	auipc	ra,0xffffb
    80004f0e:	20e080e7          	jalr	526(ra) # 80000118 <kalloc>
    80004f12:	85aa                	mv	a1,a0
    80004f14:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f18:	cd11                	beqz	a0,80004f34 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f1a:	6605                	lui	a2,0x1
    80004f1c:	e3043503          	ld	a0,-464(s0)
    80004f20:	ffffd097          	auipc	ra,0xffffd
    80004f24:	032080e7          	jalr	50(ra) # 80001f52 <fetchstr>
    80004f28:	00054663          	bltz	a0,80004f34 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f2c:	0905                	addi	s2,s2,1
    80004f2e:	09a1                	addi	s3,s3,8
    80004f30:	fb491be3          	bne	s2,s4,80004ee6 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f34:	10048913          	addi	s2,s1,256
    80004f38:	6088                	ld	a0,0(s1)
    80004f3a:	c529                	beqz	a0,80004f84 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f3c:	ffffb097          	auipc	ra,0xffffb
    80004f40:	0e0080e7          	jalr	224(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f44:	04a1                	addi	s1,s1,8
    80004f46:	ff2499e3          	bne	s1,s2,80004f38 <sys_exec+0xac>
  return -1;
    80004f4a:	597d                	li	s2,-1
    80004f4c:	a82d                	j	80004f86 <sys_exec+0xfa>
      argv[i] = 0;
    80004f4e:	0a8e                	slli	s5,s5,0x3
    80004f50:	fc040793          	addi	a5,s0,-64
    80004f54:	9abe                	add	s5,s5,a5
    80004f56:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f5a:	e4040593          	addi	a1,s0,-448
    80004f5e:	f4040513          	addi	a0,s0,-192
    80004f62:	fffff097          	auipc	ra,0xfffff
    80004f66:	194080e7          	jalr	404(ra) # 800040f6 <exec>
    80004f6a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6c:	10048993          	addi	s3,s1,256
    80004f70:	6088                	ld	a0,0(s1)
    80004f72:	c911                	beqz	a0,80004f86 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f74:	ffffb097          	auipc	ra,0xffffb
    80004f78:	0a8080e7          	jalr	168(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7c:	04a1                	addi	s1,s1,8
    80004f7e:	ff3499e3          	bne	s1,s3,80004f70 <sys_exec+0xe4>
    80004f82:	a011                	j	80004f86 <sys_exec+0xfa>
  return -1;
    80004f84:	597d                	li	s2,-1
}
    80004f86:	854a                	mv	a0,s2
    80004f88:	60be                	ld	ra,456(sp)
    80004f8a:	641e                	ld	s0,448(sp)
    80004f8c:	74fa                	ld	s1,440(sp)
    80004f8e:	795a                	ld	s2,432(sp)
    80004f90:	79ba                	ld	s3,424(sp)
    80004f92:	7a1a                	ld	s4,416(sp)
    80004f94:	6afa                	ld	s5,408(sp)
    80004f96:	6179                	addi	sp,sp,464
    80004f98:	8082                	ret

0000000080004f9a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f9a:	7139                	addi	sp,sp,-64
    80004f9c:	fc06                	sd	ra,56(sp)
    80004f9e:	f822                	sd	s0,48(sp)
    80004fa0:	f426                	sd	s1,40(sp)
    80004fa2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fa4:	ffffc097          	auipc	ra,0xffffc
    80004fa8:	eee080e7          	jalr	-274(ra) # 80000e92 <myproc>
    80004fac:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fae:	fd840593          	addi	a1,s0,-40
    80004fb2:	4501                	li	a0,0
    80004fb4:	ffffd097          	auipc	ra,0xffffd
    80004fb8:	008080e7          	jalr	8(ra) # 80001fbc <argaddr>
    return -1;
    80004fbc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fbe:	0e054063          	bltz	a0,8000509e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fc2:	fc840593          	addi	a1,s0,-56
    80004fc6:	fd040513          	addi	a0,s0,-48
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	dfc080e7          	jalr	-516(ra) # 80003dc6 <pipealloc>
    return -1;
    80004fd2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fd4:	0c054563          	bltz	a0,8000509e <sys_pipe+0x104>
  fd0 = -1;
    80004fd8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fdc:	fd043503          	ld	a0,-48(s0)
    80004fe0:	fffff097          	auipc	ra,0xfffff
    80004fe4:	508080e7          	jalr	1288(ra) # 800044e8 <fdalloc>
    80004fe8:	fca42223          	sw	a0,-60(s0)
    80004fec:	08054c63          	bltz	a0,80005084 <sys_pipe+0xea>
    80004ff0:	fc843503          	ld	a0,-56(s0)
    80004ff4:	fffff097          	auipc	ra,0xfffff
    80004ff8:	4f4080e7          	jalr	1268(ra) # 800044e8 <fdalloc>
    80004ffc:	fca42023          	sw	a0,-64(s0)
    80005000:	06054863          	bltz	a0,80005070 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005004:	4691                	li	a3,4
    80005006:	fc440613          	addi	a2,s0,-60
    8000500a:	fd843583          	ld	a1,-40(s0)
    8000500e:	68a8                	ld	a0,80(s1)
    80005010:	ffffc097          	auipc	ra,0xffffc
    80005014:	b44080e7          	jalr	-1212(ra) # 80000b54 <copyout>
    80005018:	02054063          	bltz	a0,80005038 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000501c:	4691                	li	a3,4
    8000501e:	fc040613          	addi	a2,s0,-64
    80005022:	fd843583          	ld	a1,-40(s0)
    80005026:	0591                	addi	a1,a1,4
    80005028:	68a8                	ld	a0,80(s1)
    8000502a:	ffffc097          	auipc	ra,0xffffc
    8000502e:	b2a080e7          	jalr	-1238(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005032:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005034:	06055563          	bgez	a0,8000509e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005038:	fc442783          	lw	a5,-60(s0)
    8000503c:	07e9                	addi	a5,a5,26
    8000503e:	078e                	slli	a5,a5,0x3
    80005040:	97a6                	add	a5,a5,s1
    80005042:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005046:	fc042503          	lw	a0,-64(s0)
    8000504a:	0569                	addi	a0,a0,26
    8000504c:	050e                	slli	a0,a0,0x3
    8000504e:	9526                	add	a0,a0,s1
    80005050:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005054:	fd043503          	ld	a0,-48(s0)
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	a3e080e7          	jalr	-1474(ra) # 80003a96 <fileclose>
    fileclose(wf);
    80005060:	fc843503          	ld	a0,-56(s0)
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	a32080e7          	jalr	-1486(ra) # 80003a96 <fileclose>
    return -1;
    8000506c:	57fd                	li	a5,-1
    8000506e:	a805                	j	8000509e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005070:	fc442783          	lw	a5,-60(s0)
    80005074:	0007c863          	bltz	a5,80005084 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005078:	01a78513          	addi	a0,a5,26
    8000507c:	050e                	slli	a0,a0,0x3
    8000507e:	9526                	add	a0,a0,s1
    80005080:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005084:	fd043503          	ld	a0,-48(s0)
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	a0e080e7          	jalr	-1522(ra) # 80003a96 <fileclose>
    fileclose(wf);
    80005090:	fc843503          	ld	a0,-56(s0)
    80005094:	fffff097          	auipc	ra,0xfffff
    80005098:	a02080e7          	jalr	-1534(ra) # 80003a96 <fileclose>
    return -1;
    8000509c:	57fd                	li	a5,-1
}
    8000509e:	853e                	mv	a0,a5
    800050a0:	70e2                	ld	ra,56(sp)
    800050a2:	7442                	ld	s0,48(sp)
    800050a4:	74a2                	ld	s1,40(sp)
    800050a6:	6121                	addi	sp,sp,64
    800050a8:	8082                	ret
    800050aa:	0000                	unimp
    800050ac:	0000                	unimp
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
    800050f0:	cddfc0ef          	jal	ra,80001dcc <kerneltrap>
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
    8000518c:	cde080e7          	jalr	-802(ra) # 80000e66 <cpuid>
  
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
    800051c4:	ca6080e7          	jalr	-858(ra) # 80000e66 <cpuid>
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
    800051ec:	c7e080e7          	jalr	-898(ra) # 80000e66 <cpuid>
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
    80005214:	00016797          	auipc	a5,0x16
    80005218:	dec78793          	addi	a5,a5,-532 # 8001b000 <disk>
    8000521c:	00a78733          	add	a4,a5,a0
    80005220:	6789                	lui	a5,0x2
    80005222:	97ba                	add	a5,a5,a4
    80005224:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005228:	e7ad                	bnez	a5,80005292 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000522a:	00451793          	slli	a5,a0,0x4
    8000522e:	00018717          	auipc	a4,0x18
    80005232:	dd270713          	addi	a4,a4,-558 # 8001d000 <disk+0x2000>
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
    80005256:	00016797          	auipc	a5,0x16
    8000525a:	daa78793          	addi	a5,a5,-598 # 8001b000 <disk>
    8000525e:	97aa                	add	a5,a5,a0
    80005260:	6509                	lui	a0,0x2
    80005262:	953e                	add	a0,a0,a5
    80005264:	4785                	li	a5,1
    80005266:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000526a:	00018517          	auipc	a0,0x18
    8000526e:	dae50513          	addi	a0,a0,-594 # 8001d018 <disk+0x2018>
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	470080e7          	jalr	1136(ra) # 800016e2 <wakeup>
}
    8000527a:	60a2                	ld	ra,8(sp)
    8000527c:	6402                	ld	s0,0(sp)
    8000527e:	0141                	addi	sp,sp,16
    80005280:	8082                	ret
    panic("free_desc 1");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	60650513          	addi	a0,a0,1542 # 80008888 <syscall_name+0x338>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	a1e080e7          	jalr	-1506(ra) # 80005ca8 <panic>
    panic("free_desc 2");
    80005292:	00003517          	auipc	a0,0x3
    80005296:	60650513          	addi	a0,a0,1542 # 80008898 <syscall_name+0x348>
    8000529a:	00001097          	auipc	ra,0x1
    8000529e:	a0e080e7          	jalr	-1522(ra) # 80005ca8 <panic>

00000000800052a2 <virtio_disk_init>:
{
    800052a2:	1101                	addi	sp,sp,-32
    800052a4:	ec06                	sd	ra,24(sp)
    800052a6:	e822                	sd	s0,16(sp)
    800052a8:	e426                	sd	s1,8(sp)
    800052aa:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052ac:	00003597          	auipc	a1,0x3
    800052b0:	5fc58593          	addi	a1,a1,1532 # 800088a8 <syscall_name+0x358>
    800052b4:	00018517          	auipc	a0,0x18
    800052b8:	e7450513          	addi	a0,a0,-396 # 8001d128 <disk+0x2128>
    800052bc:	00001097          	auipc	ra,0x1
    800052c0:	ea6080e7          	jalr	-346(ra) # 80006162 <initlock>
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
    8000531a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
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
    8000534c:	00016517          	auipc	a0,0x16
    80005350:	cb450513          	addi	a0,a0,-844 # 8001b000 <disk>
    80005354:	ffffb097          	auipc	ra,0xffffb
    80005358:	e6e080e7          	jalr	-402(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000535c:	00016717          	auipc	a4,0x16
    80005360:	ca470713          	addi	a4,a4,-860 # 8001b000 <disk>
    80005364:	00c75793          	srli	a5,a4,0xc
    80005368:	2781                	sext.w	a5,a5
    8000536a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000536c:	00018797          	auipc	a5,0x18
    80005370:	c9478793          	addi	a5,a5,-876 # 8001d000 <disk+0x2000>
    80005374:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005376:	00016717          	auipc	a4,0x16
    8000537a:	d0a70713          	addi	a4,a4,-758 # 8001b080 <disk+0x80>
    8000537e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005380:	00017717          	auipc	a4,0x17
    80005384:	c8070713          	addi	a4,a4,-896 # 8001c000 <disk+0x1000>
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
    800053ba:	50250513          	addi	a0,a0,1282 # 800088b8 <syscall_name+0x368>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	8ea080e7          	jalr	-1814(ra) # 80005ca8 <panic>
    panic("virtio disk has no queue 0");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	51250513          	addi	a0,a0,1298 # 800088d8 <syscall_name+0x388>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	8da080e7          	jalr	-1830(ra) # 80005ca8 <panic>
    panic("virtio disk max queue too short");
    800053d6:	00003517          	auipc	a0,0x3
    800053da:	52250513          	addi	a0,a0,1314 # 800088f8 <syscall_name+0x3a8>
    800053de:	00001097          	auipc	ra,0x1
    800053e2:	8ca080e7          	jalr	-1846(ra) # 80005ca8 <panic>

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
    80005414:	00018517          	auipc	a0,0x18
    80005418:	d1450513          	addi	a0,a0,-748 # 8001d128 <disk+0x2128>
    8000541c:	00001097          	auipc	ra,0x1
    80005420:	dd6080e7          	jalr	-554(ra) # 800061f2 <acquire>
  for(int i = 0; i < 3; i++){
    80005424:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005426:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005428:	00016b97          	auipc	s7,0x16
    8000542c:	bd8b8b93          	addi	s7,s7,-1064 # 8001b000 <disk>
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
    80005452:	00018697          	auipc	a3,0x18
    80005456:	bc668693          	addi	a3,a3,-1082 # 8001d018 <disk+0x2018>
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
    800054a2:	00018597          	auipc	a1,0x18
    800054a6:	c8658593          	addi	a1,a1,-890 # 8001d128 <disk+0x2128>
    800054aa:	00018517          	auipc	a0,0x18
    800054ae:	b6e50513          	addi	a0,a0,-1170 # 8001d018 <disk+0x2018>
    800054b2:	ffffc097          	auipc	ra,0xffffc
    800054b6:	0a4080e7          	jalr	164(ra) # 80001556 <sleep>
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
    800054ca:	00016717          	auipc	a4,0x16
    800054ce:	b3670713          	addi	a4,a4,-1226 # 8001b000 <disk>
    800054d2:	9736                	add	a4,a4,a3
    800054d4:	4685                	li	a3,1
    800054d6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054da:	20058713          	addi	a4,a1,512
    800054de:	00471693          	slli	a3,a4,0x4
    800054e2:	00016717          	auipc	a4,0x16
    800054e6:	b1e70713          	addi	a4,a4,-1250 # 8001b000 <disk>
    800054ea:	9736                	add	a4,a4,a3
    800054ec:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054f0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054f4:	7679                	lui	a2,0xffffe
    800054f6:	963e                	add	a2,a2,a5
    800054f8:	00018697          	auipc	a3,0x18
    800054fc:	b0868693          	addi	a3,a3,-1272 # 8001d000 <disk+0x2000>
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
    80005520:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

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
    8000553e:	00018697          	auipc	a3,0x18
    80005542:	ac26b683          	ld	a3,-1342(a3) # 8001d000 <disk+0x2000>
    80005546:	96ba                	add	a3,a3,a4
    80005548:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000554c:	00016817          	auipc	a6,0x16
    80005550:	ab480813          	addi	a6,a6,-1356 # 8001b000 <disk>
    80005554:	00018517          	auipc	a0,0x18
    80005558:	aac50513          	addi	a0,a0,-1364 # 8001d000 <disk+0x2000>
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
    800055ee:	00018997          	auipc	s3,0x18
    800055f2:	b3a98993          	addi	s3,s3,-1222 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055f6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055f8:	85ce                	mv	a1,s3
    800055fa:	854a                	mv	a0,s2
    800055fc:	ffffc097          	auipc	ra,0xffffc
    80005600:	f5a080e7          	jalr	-166(ra) # 80001556 <sleep>
  while(b->disk == 1) {
    80005604:	00492783          	lw	a5,4(s2)
    80005608:	fe9788e3          	beq	a5,s1,800055f8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000560c:	f9042903          	lw	s2,-112(s0)
    80005610:	20090793          	addi	a5,s2,512
    80005614:	00479713          	slli	a4,a5,0x4
    80005618:	00016797          	auipc	a5,0x16
    8000561c:	9e878793          	addi	a5,a5,-1560 # 8001b000 <disk>
    80005620:	97ba                	add	a5,a5,a4
    80005622:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005626:	00018997          	auipc	s3,0x18
    8000562a:	9da98993          	addi	s3,s3,-1574 # 8001d000 <disk+0x2000>
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
    8000564e:	00018517          	auipc	a0,0x18
    80005652:	ada50513          	addi	a0,a0,-1318 # 8001d128 <disk+0x2128>
    80005656:	00001097          	auipc	ra,0x1
    8000565a:	c50080e7          	jalr	-944(ra) # 800062a6 <release>
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
    8000567a:	00018697          	auipc	a3,0x18
    8000567e:	9866b683          	ld	a3,-1658(a3) # 8001d000 <disk+0x2000>
    80005682:	96ba                	add	a3,a3,a4
    80005684:	4609                	li	a2,2
    80005686:	00c69623          	sh	a2,12(a3)
    8000568a:	b5c9                	j	8000554c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000568c:	f9042583          	lw	a1,-112(s0)
    80005690:	20058793          	addi	a5,a1,512
    80005694:	0792                	slli	a5,a5,0x4
    80005696:	00016517          	auipc	a0,0x16
    8000569a:	a1250513          	addi	a0,a0,-1518 # 8001b0a8 <disk+0xa8>
    8000569e:	953e                	add	a0,a0,a5
  if(write)
    800056a0:	e20d11e3          	bnez	s10,800054c2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056a4:	20058713          	addi	a4,a1,512
    800056a8:	00471693          	slli	a3,a4,0x4
    800056ac:	00016717          	auipc	a4,0x16
    800056b0:	95470713          	addi	a4,a4,-1708 # 8001b000 <disk>
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
    800056c8:	00018517          	auipc	a0,0x18
    800056cc:	a6050513          	addi	a0,a0,-1440 # 8001d128 <disk+0x2128>
    800056d0:	00001097          	auipc	ra,0x1
    800056d4:	b22080e7          	jalr	-1246(ra) # 800061f2 <acquire>
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
    800056e6:	00018797          	auipc	a5,0x18
    800056ea:	91a78793          	addi	a5,a5,-1766 # 8001d000 <disk+0x2000>
    800056ee:	6b94                	ld	a3,16(a5)
    800056f0:	0207d703          	lhu	a4,32(a5)
    800056f4:	0026d783          	lhu	a5,2(a3)
    800056f8:	06f70163          	beq	a4,a5,8000575a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056fc:	00016917          	auipc	s2,0x16
    80005700:	90490913          	addi	s2,s2,-1788 # 8001b000 <disk>
    80005704:	00018497          	auipc	s1,0x18
    80005708:	8fc48493          	addi	s1,s1,-1796 # 8001d000 <disk+0x2000>
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
    8000573e:	fa8080e7          	jalr	-88(ra) # 800016e2 <wakeup>

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
    8000575a:	00018517          	auipc	a0,0x18
    8000575e:	9ce50513          	addi	a0,a0,-1586 # 8001d128 <disk+0x2128>
    80005762:	00001097          	auipc	ra,0x1
    80005766:	b44080e7          	jalr	-1212(ra) # 800062a6 <release>
}
    8000576a:	60e2                	ld	ra,24(sp)
    8000576c:	6442                	ld	s0,16(sp)
    8000576e:	64a2                	ld	s1,8(sp)
    80005770:	6902                	ld	s2,0(sp)
    80005772:	6105                	addi	sp,sp,32
    80005774:	8082                	ret
      panic("virtio_disk_intr status");
    80005776:	00003517          	auipc	a0,0x3
    8000577a:	1a250513          	addi	a0,a0,418 # 80008918 <syscall_name+0x3c8>
    8000577e:	00000097          	auipc	ra,0x0
    80005782:	52a080e7          	jalr	1322(ra) # 80005ca8 <panic>

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
    800057bc:	00019717          	auipc	a4,0x19
    800057c0:	84470713          	addi	a4,a4,-1980 # 8001e000 <timer_scratch>
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
    80005806:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000580a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000580c:	6705                	lui	a4,0x1
    8000580e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005812:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005814:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005818:	ffffb797          	auipc	a5,0xffffb
    8000581c:	b5878793          	addi	a5,a5,-1192 # 80000370 <main>
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
    8000589a:	0ba080e7          	jalr	186(ra) # 80001950 <either_copyin>
    8000589e:	01550c63          	beq	a0,s5,800058b6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800058a2:	fbf44503          	lbu	a0,-65(s0)
    800058a6:	00000097          	auipc	ra,0x0
    800058aa:	78e080e7          	jalr	1934(ra) # 80006034 <uartputc>
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
    800058f6:	00021517          	auipc	a0,0x21
    800058fa:	84a50513          	addi	a0,a0,-1974 # 80026140 <cons>
    800058fe:	00001097          	auipc	ra,0x1
    80005902:	8f4080e7          	jalr	-1804(ra) # 800061f2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005906:	00021497          	auipc	s1,0x21
    8000590a:	83a48493          	addi	s1,s1,-1990 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000590e:	89a6                	mv	s3,s1
    80005910:	00021917          	auipc	s2,0x21
    80005914:	8c890913          	addi	s2,s2,-1848 # 800261d8 <cons+0x98>
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
    8000591e:	07405863          	blez	s4,8000598e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005922:	0984a783          	lw	a5,152(s1)
    80005926:	09c4a703          	lw	a4,156(s1)
    8000592a:	02f71463          	bne	a4,a5,80005952 <consoleread+0x84>
      if(myproc()->killed){
    8000592e:	ffffb097          	auipc	ra,0xffffb
    80005932:	564080e7          	jalr	1380(ra) # 80000e92 <myproc>
    80005936:	551c                	lw	a5,40(a0)
    80005938:	e7b5                	bnez	a5,800059a4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000593a:	85ce                	mv	a1,s3
    8000593c:	854a                	mv	a0,s2
    8000593e:	ffffc097          	auipc	ra,0xffffc
    80005942:	c18080e7          	jalr	-1000(ra) # 80001556 <sleep>
    while(cons.r == cons.w){
    80005946:	0984a783          	lw	a5,152(s1)
    8000594a:	09c4a703          	lw	a4,156(s1)
    8000594e:	fef700e3          	beq	a4,a5,8000592e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005952:	0017871b          	addiw	a4,a5,1
    80005956:	08e4ac23          	sw	a4,152(s1)
    8000595a:	07f7f713          	andi	a4,a5,127
    8000595e:	9726                	add	a4,a4,s1
    80005960:	01874703          	lbu	a4,24(a4)
    80005964:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005968:	079c0663          	beq	s8,s9,800059d4 <consoleread+0x106>
    cbuf = c;
    8000596c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005970:	4685                	li	a3,1
    80005972:	f8f40613          	addi	a2,s0,-113
    80005976:	85d6                	mv	a1,s5
    80005978:	855a                	mv	a0,s6
    8000597a:	ffffc097          	auipc	ra,0xffffc
    8000597e:	f80080e7          	jalr	-128(ra) # 800018fa <either_copyout>
    80005982:	01a50663          	beq	a0,s10,8000598e <consoleread+0xc0>
    dst++;
    80005986:	0a85                	addi	s5,s5,1
    --n;
    80005988:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000598a:	f9bc1ae3          	bne	s8,s11,8000591e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000598e:	00020517          	auipc	a0,0x20
    80005992:	7b250513          	addi	a0,a0,1970 # 80026140 <cons>
    80005996:	00001097          	auipc	ra,0x1
    8000599a:	910080e7          	jalr	-1776(ra) # 800062a6 <release>

  return target - n;
    8000599e:	414b853b          	subw	a0,s7,s4
    800059a2:	a811                	j	800059b6 <consoleread+0xe8>
        release(&cons.lock);
    800059a4:	00020517          	auipc	a0,0x20
    800059a8:	79c50513          	addi	a0,a0,1948 # 80026140 <cons>
    800059ac:	00001097          	auipc	ra,0x1
    800059b0:	8fa080e7          	jalr	-1798(ra) # 800062a6 <release>
        return -1;
    800059b4:	557d                	li	a0,-1
}
    800059b6:	70e6                	ld	ra,120(sp)
    800059b8:	7446                	ld	s0,112(sp)
    800059ba:	74a6                	ld	s1,104(sp)
    800059bc:	7906                	ld	s2,96(sp)
    800059be:	69e6                	ld	s3,88(sp)
    800059c0:	6a46                	ld	s4,80(sp)
    800059c2:	6aa6                	ld	s5,72(sp)
    800059c4:	6b06                	ld	s6,64(sp)
    800059c6:	7be2                	ld	s7,56(sp)
    800059c8:	7c42                	ld	s8,48(sp)
    800059ca:	7ca2                	ld	s9,40(sp)
    800059cc:	7d02                	ld	s10,32(sp)
    800059ce:	6de2                	ld	s11,24(sp)
    800059d0:	6109                	addi	sp,sp,128
    800059d2:	8082                	ret
      if(n < target){
    800059d4:	000a071b          	sext.w	a4,s4
    800059d8:	fb777be3          	bgeu	a4,s7,8000598e <consoleread+0xc0>
        cons.r--;
    800059dc:	00020717          	auipc	a4,0x20
    800059e0:	7ef72e23          	sw	a5,2044(a4) # 800261d8 <cons+0x98>
    800059e4:	b76d                	j	8000598e <consoleread+0xc0>

00000000800059e6 <consputc>:
{
    800059e6:	1141                	addi	sp,sp,-16
    800059e8:	e406                	sd	ra,8(sp)
    800059ea:	e022                	sd	s0,0(sp)
    800059ec:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ee:	10000793          	li	a5,256
    800059f2:	00f50a63          	beq	a0,a5,80005a06 <consputc+0x20>
    uartputc_sync(c);
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	564080e7          	jalr	1380(ra) # 80005f5a <uartputc_sync>
}
    800059fe:	60a2                	ld	ra,8(sp)
    80005a00:	6402                	ld	s0,0(sp)
    80005a02:	0141                	addi	sp,sp,16
    80005a04:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a06:	4521                	li	a0,8
    80005a08:	00000097          	auipc	ra,0x0
    80005a0c:	552080e7          	jalr	1362(ra) # 80005f5a <uartputc_sync>
    80005a10:	02000513          	li	a0,32
    80005a14:	00000097          	auipc	ra,0x0
    80005a18:	546080e7          	jalr	1350(ra) # 80005f5a <uartputc_sync>
    80005a1c:	4521                	li	a0,8
    80005a1e:	00000097          	auipc	ra,0x0
    80005a22:	53c080e7          	jalr	1340(ra) # 80005f5a <uartputc_sync>
    80005a26:	bfe1                	j	800059fe <consputc+0x18>

0000000080005a28 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a28:	1101                	addi	sp,sp,-32
    80005a2a:	ec06                	sd	ra,24(sp)
    80005a2c:	e822                	sd	s0,16(sp)
    80005a2e:	e426                	sd	s1,8(sp)
    80005a30:	e04a                	sd	s2,0(sp)
    80005a32:	1000                	addi	s0,sp,32
    80005a34:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a36:	00020517          	auipc	a0,0x20
    80005a3a:	70a50513          	addi	a0,a0,1802 # 80026140 <cons>
    80005a3e:	00000097          	auipc	ra,0x0
    80005a42:	7b4080e7          	jalr	1972(ra) # 800061f2 <acquire>

  switch(c){
    80005a46:	47d5                	li	a5,21
    80005a48:	0af48663          	beq	s1,a5,80005af4 <consoleintr+0xcc>
    80005a4c:	0297ca63          	blt	a5,s1,80005a80 <consoleintr+0x58>
    80005a50:	47a1                	li	a5,8
    80005a52:	0ef48763          	beq	s1,a5,80005b40 <consoleintr+0x118>
    80005a56:	47c1                	li	a5,16
    80005a58:	10f49a63          	bne	s1,a5,80005b6c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a5c:	ffffc097          	auipc	ra,0xffffc
    80005a60:	f4a080e7          	jalr	-182(ra) # 800019a6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a64:	00020517          	auipc	a0,0x20
    80005a68:	6dc50513          	addi	a0,a0,1756 # 80026140 <cons>
    80005a6c:	00001097          	auipc	ra,0x1
    80005a70:	83a080e7          	jalr	-1990(ra) # 800062a6 <release>
}
    80005a74:	60e2                	ld	ra,24(sp)
    80005a76:	6442                	ld	s0,16(sp)
    80005a78:	64a2                	ld	s1,8(sp)
    80005a7a:	6902                	ld	s2,0(sp)
    80005a7c:	6105                	addi	sp,sp,32
    80005a7e:	8082                	ret
  switch(c){
    80005a80:	07f00793          	li	a5,127
    80005a84:	0af48e63          	beq	s1,a5,80005b40 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a88:	00020717          	auipc	a4,0x20
    80005a8c:	6b870713          	addi	a4,a4,1720 # 80026140 <cons>
    80005a90:	0a072783          	lw	a5,160(a4)
    80005a94:	09872703          	lw	a4,152(a4)
    80005a98:	9f99                	subw	a5,a5,a4
    80005a9a:	07f00713          	li	a4,127
    80005a9e:	fcf763e3          	bltu	a4,a5,80005a64 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005aa2:	47b5                	li	a5,13
    80005aa4:	0cf48763          	beq	s1,a5,80005b72 <consoleintr+0x14a>
      consputc(c);
    80005aa8:	8526                	mv	a0,s1
    80005aaa:	00000097          	auipc	ra,0x0
    80005aae:	f3c080e7          	jalr	-196(ra) # 800059e6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ab2:	00020797          	auipc	a5,0x20
    80005ab6:	68e78793          	addi	a5,a5,1678 # 80026140 <cons>
    80005aba:	0a07a703          	lw	a4,160(a5)
    80005abe:	0017069b          	addiw	a3,a4,1
    80005ac2:	0006861b          	sext.w	a2,a3
    80005ac6:	0ad7a023          	sw	a3,160(a5)
    80005aca:	07f77713          	andi	a4,a4,127
    80005ace:	97ba                	add	a5,a5,a4
    80005ad0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ad4:	47a9                	li	a5,10
    80005ad6:	0cf48563          	beq	s1,a5,80005ba0 <consoleintr+0x178>
    80005ada:	4791                	li	a5,4
    80005adc:	0cf48263          	beq	s1,a5,80005ba0 <consoleintr+0x178>
    80005ae0:	00020797          	auipc	a5,0x20
    80005ae4:	6f87a783          	lw	a5,1784(a5) # 800261d8 <cons+0x98>
    80005ae8:	0807879b          	addiw	a5,a5,128
    80005aec:	f6f61ce3          	bne	a2,a5,80005a64 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005af0:	863e                	mv	a2,a5
    80005af2:	a07d                	j	80005ba0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005af4:	00020717          	auipc	a4,0x20
    80005af8:	64c70713          	addi	a4,a4,1612 # 80026140 <cons>
    80005afc:	0a072783          	lw	a5,160(a4)
    80005b00:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b04:	00020497          	auipc	s1,0x20
    80005b08:	63c48493          	addi	s1,s1,1596 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005b0c:	4929                	li	s2,10
    80005b0e:	f4f70be3          	beq	a4,a5,80005a64 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b12:	37fd                	addiw	a5,a5,-1
    80005b14:	07f7f713          	andi	a4,a5,127
    80005b18:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b1a:	01874703          	lbu	a4,24(a4)
    80005b1e:	f52703e3          	beq	a4,s2,80005a64 <consoleintr+0x3c>
      cons.e--;
    80005b22:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b26:	10000513          	li	a0,256
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	ebc080e7          	jalr	-324(ra) # 800059e6 <consputc>
    while(cons.e != cons.w &&
    80005b32:	0a04a783          	lw	a5,160(s1)
    80005b36:	09c4a703          	lw	a4,156(s1)
    80005b3a:	fcf71ce3          	bne	a4,a5,80005b12 <consoleintr+0xea>
    80005b3e:	b71d                	j	80005a64 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b40:	00020717          	auipc	a4,0x20
    80005b44:	60070713          	addi	a4,a4,1536 # 80026140 <cons>
    80005b48:	0a072783          	lw	a5,160(a4)
    80005b4c:	09c72703          	lw	a4,156(a4)
    80005b50:	f0f70ae3          	beq	a4,a5,80005a64 <consoleintr+0x3c>
      cons.e--;
    80005b54:	37fd                	addiw	a5,a5,-1
    80005b56:	00020717          	auipc	a4,0x20
    80005b5a:	68f72523          	sw	a5,1674(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b5e:	10000513          	li	a0,256
    80005b62:	00000097          	auipc	ra,0x0
    80005b66:	e84080e7          	jalr	-380(ra) # 800059e6 <consputc>
    80005b6a:	bded                	j	80005a64 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b6c:	ee048ce3          	beqz	s1,80005a64 <consoleintr+0x3c>
    80005b70:	bf21                	j	80005a88 <consoleintr+0x60>
      consputc(c);
    80005b72:	4529                	li	a0,10
    80005b74:	00000097          	auipc	ra,0x0
    80005b78:	e72080e7          	jalr	-398(ra) # 800059e6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b7c:	00020797          	auipc	a5,0x20
    80005b80:	5c478793          	addi	a5,a5,1476 # 80026140 <cons>
    80005b84:	0a07a703          	lw	a4,160(a5)
    80005b88:	0017069b          	addiw	a3,a4,1
    80005b8c:	0006861b          	sext.w	a2,a3
    80005b90:	0ad7a023          	sw	a3,160(a5)
    80005b94:	07f77713          	andi	a4,a4,127
    80005b98:	97ba                	add	a5,a5,a4
    80005b9a:	4729                	li	a4,10
    80005b9c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ba0:	00020797          	auipc	a5,0x20
    80005ba4:	62c7ae23          	sw	a2,1596(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005ba8:	00020517          	auipc	a0,0x20
    80005bac:	63050513          	addi	a0,a0,1584 # 800261d8 <cons+0x98>
    80005bb0:	ffffc097          	auipc	ra,0xffffc
    80005bb4:	b32080e7          	jalr	-1230(ra) # 800016e2 <wakeup>
    80005bb8:	b575                	j	80005a64 <consoleintr+0x3c>

0000000080005bba <consoleinit>:

void
consoleinit(void)
{
    80005bba:	1141                	addi	sp,sp,-16
    80005bbc:	e406                	sd	ra,8(sp)
    80005bbe:	e022                	sd	s0,0(sp)
    80005bc0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bc2:	00003597          	auipc	a1,0x3
    80005bc6:	d6e58593          	addi	a1,a1,-658 # 80008930 <syscall_name+0x3e0>
    80005bca:	00020517          	auipc	a0,0x20
    80005bce:	57650513          	addi	a0,a0,1398 # 80026140 <cons>
    80005bd2:	00000097          	auipc	ra,0x0
    80005bd6:	590080e7          	jalr	1424(ra) # 80006162 <initlock>

  uartinit();
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	330080e7          	jalr	816(ra) # 80005f0a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005be2:	00013797          	auipc	a5,0x13
    80005be6:	6e678793          	addi	a5,a5,1766 # 800192c8 <devsw>
    80005bea:	00000717          	auipc	a4,0x0
    80005bee:	ce470713          	addi	a4,a4,-796 # 800058ce <consoleread>
    80005bf2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bf4:	00000717          	auipc	a4,0x0
    80005bf8:	c7870713          	addi	a4,a4,-904 # 8000586c <consolewrite>
    80005bfc:	ef98                	sd	a4,24(a5)
}
    80005bfe:	60a2                	ld	ra,8(sp)
    80005c00:	6402                	ld	s0,0(sp)
    80005c02:	0141                	addi	sp,sp,16
    80005c04:	8082                	ret

0000000080005c06 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c06:	7179                	addi	sp,sp,-48
    80005c08:	f406                	sd	ra,40(sp)
    80005c0a:	f022                	sd	s0,32(sp)
    80005c0c:	ec26                	sd	s1,24(sp)
    80005c0e:	e84a                	sd	s2,16(sp)
    80005c10:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c12:	c219                	beqz	a2,80005c18 <printint+0x12>
    80005c14:	08054663          	bltz	a0,80005ca0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c18:	2501                	sext.w	a0,a0
    80005c1a:	4881                	li	a7,0
    80005c1c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c20:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c22:	2581                	sext.w	a1,a1
    80005c24:	00003617          	auipc	a2,0x3
    80005c28:	d3c60613          	addi	a2,a2,-708 # 80008960 <digits>
    80005c2c:	883a                	mv	a6,a4
    80005c2e:	2705                	addiw	a4,a4,1
    80005c30:	02b577bb          	remuw	a5,a0,a1
    80005c34:	1782                	slli	a5,a5,0x20
    80005c36:	9381                	srli	a5,a5,0x20
    80005c38:	97b2                	add	a5,a5,a2
    80005c3a:	0007c783          	lbu	a5,0(a5)
    80005c3e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c42:	0005079b          	sext.w	a5,a0
    80005c46:	02b5553b          	divuw	a0,a0,a1
    80005c4a:	0685                	addi	a3,a3,1
    80005c4c:	feb7f0e3          	bgeu	a5,a1,80005c2c <printint+0x26>

  if(sign)
    80005c50:	00088b63          	beqz	a7,80005c66 <printint+0x60>
    buf[i++] = '-';
    80005c54:	fe040793          	addi	a5,s0,-32
    80005c58:	973e                	add	a4,a4,a5
    80005c5a:	02d00793          	li	a5,45
    80005c5e:	fef70823          	sb	a5,-16(a4)
    80005c62:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c66:	02e05763          	blez	a4,80005c94 <printint+0x8e>
    80005c6a:	fd040793          	addi	a5,s0,-48
    80005c6e:	00e784b3          	add	s1,a5,a4
    80005c72:	fff78913          	addi	s2,a5,-1
    80005c76:	993a                	add	s2,s2,a4
    80005c78:	377d                	addiw	a4,a4,-1
    80005c7a:	1702                	slli	a4,a4,0x20
    80005c7c:	9301                	srli	a4,a4,0x20
    80005c7e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c82:	fff4c503          	lbu	a0,-1(s1)
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	d60080e7          	jalr	-672(ra) # 800059e6 <consputc>
  while(--i >= 0)
    80005c8e:	14fd                	addi	s1,s1,-1
    80005c90:	ff2499e3          	bne	s1,s2,80005c82 <printint+0x7c>
}
    80005c94:	70a2                	ld	ra,40(sp)
    80005c96:	7402                	ld	s0,32(sp)
    80005c98:	64e2                	ld	s1,24(sp)
    80005c9a:	6942                	ld	s2,16(sp)
    80005c9c:	6145                	addi	sp,sp,48
    80005c9e:	8082                	ret
    x = -xx;
    80005ca0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ca4:	4885                	li	a7,1
    x = -xx;
    80005ca6:	bf9d                	j	80005c1c <printint+0x16>

0000000080005ca8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ca8:	1101                	addi	sp,sp,-32
    80005caa:	ec06                	sd	ra,24(sp)
    80005cac:	e822                	sd	s0,16(sp)
    80005cae:	e426                	sd	s1,8(sp)
    80005cb0:	1000                	addi	s0,sp,32
    80005cb2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cb4:	00020797          	auipc	a5,0x20
    80005cb8:	5407a623          	sw	zero,1356(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cbc:	00003517          	auipc	a0,0x3
    80005cc0:	c7c50513          	addi	a0,a0,-900 # 80008938 <syscall_name+0x3e8>
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	02e080e7          	jalr	46(ra) # 80005cf2 <printf>
  printf(s);
    80005ccc:	8526                	mv	a0,s1
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	024080e7          	jalr	36(ra) # 80005cf2 <printf>
  printf("\n");
    80005cd6:	00002517          	auipc	a0,0x2
    80005cda:	37250513          	addi	a0,a0,882 # 80008048 <etext+0x48>
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	014080e7          	jalr	20(ra) # 80005cf2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ce6:	4785                	li	a5,1
    80005ce8:	00003717          	auipc	a4,0x3
    80005cec:	32f72a23          	sw	a5,820(a4) # 8000901c <panicked>
  for(;;)
    80005cf0:	a001                	j	80005cf0 <panic+0x48>

0000000080005cf2 <printf>:
{
    80005cf2:	7131                	addi	sp,sp,-192
    80005cf4:	fc86                	sd	ra,120(sp)
    80005cf6:	f8a2                	sd	s0,112(sp)
    80005cf8:	f4a6                	sd	s1,104(sp)
    80005cfa:	f0ca                	sd	s2,96(sp)
    80005cfc:	ecce                	sd	s3,88(sp)
    80005cfe:	e8d2                	sd	s4,80(sp)
    80005d00:	e4d6                	sd	s5,72(sp)
    80005d02:	e0da                	sd	s6,64(sp)
    80005d04:	fc5e                	sd	s7,56(sp)
    80005d06:	f862                	sd	s8,48(sp)
    80005d08:	f466                	sd	s9,40(sp)
    80005d0a:	f06a                	sd	s10,32(sp)
    80005d0c:	ec6e                	sd	s11,24(sp)
    80005d0e:	0100                	addi	s0,sp,128
    80005d10:	8a2a                	mv	s4,a0
    80005d12:	e40c                	sd	a1,8(s0)
    80005d14:	e810                	sd	a2,16(s0)
    80005d16:	ec14                	sd	a3,24(s0)
    80005d18:	f018                	sd	a4,32(s0)
    80005d1a:	f41c                	sd	a5,40(s0)
    80005d1c:	03043823          	sd	a6,48(s0)
    80005d20:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d24:	00020d97          	auipc	s11,0x20
    80005d28:	4dcdad83          	lw	s11,1244(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d2c:	020d9b63          	bnez	s11,80005d62 <printf+0x70>
  if (fmt == 0)
    80005d30:	040a0263          	beqz	s4,80005d74 <printf+0x82>
  va_start(ap, fmt);
    80005d34:	00840793          	addi	a5,s0,8
    80005d38:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3c:	000a4503          	lbu	a0,0(s4)
    80005d40:	16050263          	beqz	a0,80005ea4 <printf+0x1b2>
    80005d44:	4481                	li	s1,0
    if(c != '%'){
    80005d46:	02500a93          	li	s5,37
    switch(c){
    80005d4a:	07000b13          	li	s6,112
  consputc('x');
    80005d4e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d50:	00003b97          	auipc	s7,0x3
    80005d54:	c10b8b93          	addi	s7,s7,-1008 # 80008960 <digits>
    switch(c){
    80005d58:	07300c93          	li	s9,115
    80005d5c:	06400c13          	li	s8,100
    80005d60:	a82d                	j	80005d9a <printf+0xa8>
    acquire(&pr.lock);
    80005d62:	00020517          	auipc	a0,0x20
    80005d66:	48650513          	addi	a0,a0,1158 # 800261e8 <pr>
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	488080e7          	jalr	1160(ra) # 800061f2 <acquire>
    80005d72:	bf7d                	j	80005d30 <printf+0x3e>
    panic("null fmt");
    80005d74:	00003517          	auipc	a0,0x3
    80005d78:	bd450513          	addi	a0,a0,-1068 # 80008948 <syscall_name+0x3f8>
    80005d7c:	00000097          	auipc	ra,0x0
    80005d80:	f2c080e7          	jalr	-212(ra) # 80005ca8 <panic>
      consputc(c);
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	c62080e7          	jalr	-926(ra) # 800059e6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d8c:	2485                	addiw	s1,s1,1
    80005d8e:	009a07b3          	add	a5,s4,s1
    80005d92:	0007c503          	lbu	a0,0(a5)
    80005d96:	10050763          	beqz	a0,80005ea4 <printf+0x1b2>
    if(c != '%'){
    80005d9a:	ff5515e3          	bne	a0,s5,80005d84 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d9e:	2485                	addiw	s1,s1,1
    80005da0:	009a07b3          	add	a5,s4,s1
    80005da4:	0007c783          	lbu	a5,0(a5)
    80005da8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dac:	cfe5                	beqz	a5,80005ea4 <printf+0x1b2>
    switch(c){
    80005dae:	05678a63          	beq	a5,s6,80005e02 <printf+0x110>
    80005db2:	02fb7663          	bgeu	s6,a5,80005dde <printf+0xec>
    80005db6:	09978963          	beq	a5,s9,80005e48 <printf+0x156>
    80005dba:	07800713          	li	a4,120
    80005dbe:	0ce79863          	bne	a5,a4,80005e8e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005dc2:	f8843783          	ld	a5,-120(s0)
    80005dc6:	00878713          	addi	a4,a5,8
    80005dca:	f8e43423          	sd	a4,-120(s0)
    80005dce:	4605                	li	a2,1
    80005dd0:	85ea                	mv	a1,s10
    80005dd2:	4388                	lw	a0,0(a5)
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	e32080e7          	jalr	-462(ra) # 80005c06 <printint>
      break;
    80005ddc:	bf45                	j	80005d8c <printf+0x9a>
    switch(c){
    80005dde:	0b578263          	beq	a5,s5,80005e82 <printf+0x190>
    80005de2:	0b879663          	bne	a5,s8,80005e8e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005de6:	f8843783          	ld	a5,-120(s0)
    80005dea:	00878713          	addi	a4,a5,8
    80005dee:	f8e43423          	sd	a4,-120(s0)
    80005df2:	4605                	li	a2,1
    80005df4:	45a9                	li	a1,10
    80005df6:	4388                	lw	a0,0(a5)
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	e0e080e7          	jalr	-498(ra) # 80005c06 <printint>
      break;
    80005e00:	b771                	j	80005d8c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e02:	f8843783          	ld	a5,-120(s0)
    80005e06:	00878713          	addi	a4,a5,8
    80005e0a:	f8e43423          	sd	a4,-120(s0)
    80005e0e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e12:	03000513          	li	a0,48
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	bd0080e7          	jalr	-1072(ra) # 800059e6 <consputc>
  consputc('x');
    80005e1e:	07800513          	li	a0,120
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	bc4080e7          	jalr	-1084(ra) # 800059e6 <consputc>
    80005e2a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e2c:	03c9d793          	srli	a5,s3,0x3c
    80005e30:	97de                	add	a5,a5,s7
    80005e32:	0007c503          	lbu	a0,0(a5)
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	bb0080e7          	jalr	-1104(ra) # 800059e6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e3e:	0992                	slli	s3,s3,0x4
    80005e40:	397d                	addiw	s2,s2,-1
    80005e42:	fe0915e3          	bnez	s2,80005e2c <printf+0x13a>
    80005e46:	b799                	j	80005d8c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e48:	f8843783          	ld	a5,-120(s0)
    80005e4c:	00878713          	addi	a4,a5,8
    80005e50:	f8e43423          	sd	a4,-120(s0)
    80005e54:	0007b903          	ld	s2,0(a5)
    80005e58:	00090e63          	beqz	s2,80005e74 <printf+0x182>
      for(; *s; s++)
    80005e5c:	00094503          	lbu	a0,0(s2)
    80005e60:	d515                	beqz	a0,80005d8c <printf+0x9a>
        consputc(*s);
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	b84080e7          	jalr	-1148(ra) # 800059e6 <consputc>
      for(; *s; s++)
    80005e6a:	0905                	addi	s2,s2,1
    80005e6c:	00094503          	lbu	a0,0(s2)
    80005e70:	f96d                	bnez	a0,80005e62 <printf+0x170>
    80005e72:	bf29                	j	80005d8c <printf+0x9a>
        s = "(null)";
    80005e74:	00003917          	auipc	s2,0x3
    80005e78:	acc90913          	addi	s2,s2,-1332 # 80008940 <syscall_name+0x3f0>
      for(; *s; s++)
    80005e7c:	02800513          	li	a0,40
    80005e80:	b7cd                	j	80005e62 <printf+0x170>
      consputc('%');
    80005e82:	8556                	mv	a0,s5
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	b62080e7          	jalr	-1182(ra) # 800059e6 <consputc>
      break;
    80005e8c:	b701                	j	80005d8c <printf+0x9a>
      consputc('%');
    80005e8e:	8556                	mv	a0,s5
    80005e90:	00000097          	auipc	ra,0x0
    80005e94:	b56080e7          	jalr	-1194(ra) # 800059e6 <consputc>
      consputc(c);
    80005e98:	854a                	mv	a0,s2
    80005e9a:	00000097          	auipc	ra,0x0
    80005e9e:	b4c080e7          	jalr	-1204(ra) # 800059e6 <consputc>
      break;
    80005ea2:	b5ed                	j	80005d8c <printf+0x9a>
  if(locking)
    80005ea4:	020d9163          	bnez	s11,80005ec6 <printf+0x1d4>
}
    80005ea8:	70e6                	ld	ra,120(sp)
    80005eaa:	7446                	ld	s0,112(sp)
    80005eac:	74a6                	ld	s1,104(sp)
    80005eae:	7906                	ld	s2,96(sp)
    80005eb0:	69e6                	ld	s3,88(sp)
    80005eb2:	6a46                	ld	s4,80(sp)
    80005eb4:	6aa6                	ld	s5,72(sp)
    80005eb6:	6b06                	ld	s6,64(sp)
    80005eb8:	7be2                	ld	s7,56(sp)
    80005eba:	7c42                	ld	s8,48(sp)
    80005ebc:	7ca2                	ld	s9,40(sp)
    80005ebe:	7d02                	ld	s10,32(sp)
    80005ec0:	6de2                	ld	s11,24(sp)
    80005ec2:	6129                	addi	sp,sp,192
    80005ec4:	8082                	ret
    release(&pr.lock);
    80005ec6:	00020517          	auipc	a0,0x20
    80005eca:	32250513          	addi	a0,a0,802 # 800261e8 <pr>
    80005ece:	00000097          	auipc	ra,0x0
    80005ed2:	3d8080e7          	jalr	984(ra) # 800062a6 <release>
}
    80005ed6:	bfc9                	j	80005ea8 <printf+0x1b6>

0000000080005ed8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ed8:	1101                	addi	sp,sp,-32
    80005eda:	ec06                	sd	ra,24(sp)
    80005edc:	e822                	sd	s0,16(sp)
    80005ede:	e426                	sd	s1,8(sp)
    80005ee0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ee2:	00020497          	auipc	s1,0x20
    80005ee6:	30648493          	addi	s1,s1,774 # 800261e8 <pr>
    80005eea:	00003597          	auipc	a1,0x3
    80005eee:	a6e58593          	addi	a1,a1,-1426 # 80008958 <syscall_name+0x408>
    80005ef2:	8526                	mv	a0,s1
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	26e080e7          	jalr	622(ra) # 80006162 <initlock>
  pr.locking = 1;
    80005efc:	4785                	li	a5,1
    80005efe:	cc9c                	sw	a5,24(s1)
}
    80005f00:	60e2                	ld	ra,24(sp)
    80005f02:	6442                	ld	s0,16(sp)
    80005f04:	64a2                	ld	s1,8(sp)
    80005f06:	6105                	addi	sp,sp,32
    80005f08:	8082                	ret

0000000080005f0a <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f0a:	1141                	addi	sp,sp,-16
    80005f0c:	e406                	sd	ra,8(sp)
    80005f0e:	e022                	sd	s0,0(sp)
    80005f10:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f12:	100007b7          	lui	a5,0x10000
    80005f16:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f1a:	f8000713          	li	a4,-128
    80005f1e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f22:	470d                	li	a4,3
    80005f24:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f28:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f2c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f30:	469d                	li	a3,7
    80005f32:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f36:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f3a:	00003597          	auipc	a1,0x3
    80005f3e:	a3e58593          	addi	a1,a1,-1474 # 80008978 <digits+0x18>
    80005f42:	00020517          	auipc	a0,0x20
    80005f46:	2c650513          	addi	a0,a0,710 # 80026208 <uart_tx_lock>
    80005f4a:	00000097          	auipc	ra,0x0
    80005f4e:	218080e7          	jalr	536(ra) # 80006162 <initlock>
}
    80005f52:	60a2                	ld	ra,8(sp)
    80005f54:	6402                	ld	s0,0(sp)
    80005f56:	0141                	addi	sp,sp,16
    80005f58:	8082                	ret

0000000080005f5a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f5a:	1101                	addi	sp,sp,-32
    80005f5c:	ec06                	sd	ra,24(sp)
    80005f5e:	e822                	sd	s0,16(sp)
    80005f60:	e426                	sd	s1,8(sp)
    80005f62:	1000                	addi	s0,sp,32
    80005f64:	84aa                	mv	s1,a0
  push_off();
    80005f66:	00000097          	auipc	ra,0x0
    80005f6a:	240080e7          	jalr	576(ra) # 800061a6 <push_off>

  if(panicked){
    80005f6e:	00003797          	auipc	a5,0x3
    80005f72:	0ae7a783          	lw	a5,174(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f76:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f7a:	c391                	beqz	a5,80005f7e <uartputc_sync+0x24>
    for(;;)
    80005f7c:	a001                	j	80005f7c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f7e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f82:	0ff7f793          	andi	a5,a5,255
    80005f86:	0207f793          	andi	a5,a5,32
    80005f8a:	dbf5                	beqz	a5,80005f7e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f8c:	0ff4f793          	andi	a5,s1,255
    80005f90:	10000737          	lui	a4,0x10000
    80005f94:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	2ae080e7          	jalr	686(ra) # 80006246 <pop_off>
}
    80005fa0:	60e2                	ld	ra,24(sp)
    80005fa2:	6442                	ld	s0,16(sp)
    80005fa4:	64a2                	ld	s1,8(sp)
    80005fa6:	6105                	addi	sp,sp,32
    80005fa8:	8082                	ret

0000000080005faa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005faa:	00003717          	auipc	a4,0x3
    80005fae:	07673703          	ld	a4,118(a4) # 80009020 <uart_tx_r>
    80005fb2:	00003797          	auipc	a5,0x3
    80005fb6:	0767b783          	ld	a5,118(a5) # 80009028 <uart_tx_w>
    80005fba:	06e78c63          	beq	a5,a4,80006032 <uartstart+0x88>
{
    80005fbe:	7139                	addi	sp,sp,-64
    80005fc0:	fc06                	sd	ra,56(sp)
    80005fc2:	f822                	sd	s0,48(sp)
    80005fc4:	f426                	sd	s1,40(sp)
    80005fc6:	f04a                	sd	s2,32(sp)
    80005fc8:	ec4e                	sd	s3,24(sp)
    80005fca:	e852                	sd	s4,16(sp)
    80005fcc:	e456                	sd	s5,8(sp)
    80005fce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fd0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fd4:	00020a17          	auipc	s4,0x20
    80005fd8:	234a0a13          	addi	s4,s4,564 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fdc:	00003497          	auipc	s1,0x3
    80005fe0:	04448493          	addi	s1,s1,68 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fe4:	00003997          	auipc	s3,0x3
    80005fe8:	04498993          	addi	s3,s3,68 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fec:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005ff0:	0ff7f793          	andi	a5,a5,255
    80005ff4:	0207f793          	andi	a5,a5,32
    80005ff8:	c785                	beqz	a5,80006020 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ffa:	01f77793          	andi	a5,a4,31
    80005ffe:	97d2                	add	a5,a5,s4
    80006000:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006004:	0705                	addi	a4,a4,1
    80006006:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006008:	8526                	mv	a0,s1
    8000600a:	ffffb097          	auipc	ra,0xffffb
    8000600e:	6d8080e7          	jalr	1752(ra) # 800016e2 <wakeup>
    
    WriteReg(THR, c);
    80006012:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006016:	6098                	ld	a4,0(s1)
    80006018:	0009b783          	ld	a5,0(s3)
    8000601c:	fce798e3          	bne	a5,a4,80005fec <uartstart+0x42>
  }
}
    80006020:	70e2                	ld	ra,56(sp)
    80006022:	7442                	ld	s0,48(sp)
    80006024:	74a2                	ld	s1,40(sp)
    80006026:	7902                	ld	s2,32(sp)
    80006028:	69e2                	ld	s3,24(sp)
    8000602a:	6a42                	ld	s4,16(sp)
    8000602c:	6aa2                	ld	s5,8(sp)
    8000602e:	6121                	addi	sp,sp,64
    80006030:	8082                	ret
    80006032:	8082                	ret

0000000080006034 <uartputc>:
{
    80006034:	7179                	addi	sp,sp,-48
    80006036:	f406                	sd	ra,40(sp)
    80006038:	f022                	sd	s0,32(sp)
    8000603a:	ec26                	sd	s1,24(sp)
    8000603c:	e84a                	sd	s2,16(sp)
    8000603e:	e44e                	sd	s3,8(sp)
    80006040:	e052                	sd	s4,0(sp)
    80006042:	1800                	addi	s0,sp,48
    80006044:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006046:	00020517          	auipc	a0,0x20
    8000604a:	1c250513          	addi	a0,a0,450 # 80026208 <uart_tx_lock>
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	1a4080e7          	jalr	420(ra) # 800061f2 <acquire>
  if(panicked){
    80006056:	00003797          	auipc	a5,0x3
    8000605a:	fc67a783          	lw	a5,-58(a5) # 8000901c <panicked>
    8000605e:	c391                	beqz	a5,80006062 <uartputc+0x2e>
    for(;;)
    80006060:	a001                	j	80006060 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006062:	00003797          	auipc	a5,0x3
    80006066:	fc67b783          	ld	a5,-58(a5) # 80009028 <uart_tx_w>
    8000606a:	00003717          	auipc	a4,0x3
    8000606e:	fb673703          	ld	a4,-74(a4) # 80009020 <uart_tx_r>
    80006072:	02070713          	addi	a4,a4,32
    80006076:	02f71b63          	bne	a4,a5,800060ac <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000607a:	00020a17          	auipc	s4,0x20
    8000607e:	18ea0a13          	addi	s4,s4,398 # 80026208 <uart_tx_lock>
    80006082:	00003497          	auipc	s1,0x3
    80006086:	f9e48493          	addi	s1,s1,-98 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000608a:	00003917          	auipc	s2,0x3
    8000608e:	f9e90913          	addi	s2,s2,-98 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006092:	85d2                	mv	a1,s4
    80006094:	8526                	mv	a0,s1
    80006096:	ffffb097          	auipc	ra,0xffffb
    8000609a:	4c0080e7          	jalr	1216(ra) # 80001556 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000609e:	00093783          	ld	a5,0(s2)
    800060a2:	6098                	ld	a4,0(s1)
    800060a4:	02070713          	addi	a4,a4,32
    800060a8:	fef705e3          	beq	a4,a5,80006092 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060ac:	00020497          	auipc	s1,0x20
    800060b0:	15c48493          	addi	s1,s1,348 # 80026208 <uart_tx_lock>
    800060b4:	01f7f713          	andi	a4,a5,31
    800060b8:	9726                	add	a4,a4,s1
    800060ba:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060be:	0785                	addi	a5,a5,1
    800060c0:	00003717          	auipc	a4,0x3
    800060c4:	f6f73423          	sd	a5,-152(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	ee2080e7          	jalr	-286(ra) # 80005faa <uartstart>
      release(&uart_tx_lock);
    800060d0:	8526                	mv	a0,s1
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	1d4080e7          	jalr	468(ra) # 800062a6 <release>
}
    800060da:	70a2                	ld	ra,40(sp)
    800060dc:	7402                	ld	s0,32(sp)
    800060de:	64e2                	ld	s1,24(sp)
    800060e0:	6942                	ld	s2,16(sp)
    800060e2:	69a2                	ld	s3,8(sp)
    800060e4:	6a02                	ld	s4,0(sp)
    800060e6:	6145                	addi	sp,sp,48
    800060e8:	8082                	ret

00000000800060ea <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060ea:	1141                	addi	sp,sp,-16
    800060ec:	e422                	sd	s0,8(sp)
    800060ee:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060f0:	100007b7          	lui	a5,0x10000
    800060f4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060f8:	8b85                	andi	a5,a5,1
    800060fa:	cb91                	beqz	a5,8000610e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060fc:	100007b7          	lui	a5,0x10000
    80006100:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006104:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006108:	6422                	ld	s0,8(sp)
    8000610a:	0141                	addi	sp,sp,16
    8000610c:	8082                	ret
    return -1;
    8000610e:	557d                	li	a0,-1
    80006110:	bfe5                	j	80006108 <uartgetc+0x1e>

0000000080006112 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006112:	1101                	addi	sp,sp,-32
    80006114:	ec06                	sd	ra,24(sp)
    80006116:	e822                	sd	s0,16(sp)
    80006118:	e426                	sd	s1,8(sp)
    8000611a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000611c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	fcc080e7          	jalr	-52(ra) # 800060ea <uartgetc>
    if(c == -1)
    80006126:	00950763          	beq	a0,s1,80006134 <uartintr+0x22>
      break;
    consoleintr(c);
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	8fe080e7          	jalr	-1794(ra) # 80005a28 <consoleintr>
  while(1){
    80006132:	b7f5                	j	8000611e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006134:	00020497          	auipc	s1,0x20
    80006138:	0d448493          	addi	s1,s1,212 # 80026208 <uart_tx_lock>
    8000613c:	8526                	mv	a0,s1
    8000613e:	00000097          	auipc	ra,0x0
    80006142:	0b4080e7          	jalr	180(ra) # 800061f2 <acquire>
  uartstart();
    80006146:	00000097          	auipc	ra,0x0
    8000614a:	e64080e7          	jalr	-412(ra) # 80005faa <uartstart>
  release(&uart_tx_lock);
    8000614e:	8526                	mv	a0,s1
    80006150:	00000097          	auipc	ra,0x0
    80006154:	156080e7          	jalr	342(ra) # 800062a6 <release>
}
    80006158:	60e2                	ld	ra,24(sp)
    8000615a:	6442                	ld	s0,16(sp)
    8000615c:	64a2                	ld	s1,8(sp)
    8000615e:	6105                	addi	sp,sp,32
    80006160:	8082                	ret

0000000080006162 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006162:	1141                	addi	sp,sp,-16
    80006164:	e422                	sd	s0,8(sp)
    80006166:	0800                	addi	s0,sp,16
  lk->name = name;
    80006168:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000616a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000616e:	00053823          	sd	zero,16(a0)
}
    80006172:	6422                	ld	s0,8(sp)
    80006174:	0141                	addi	sp,sp,16
    80006176:	8082                	ret

0000000080006178 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006178:	411c                	lw	a5,0(a0)
    8000617a:	e399                	bnez	a5,80006180 <holding+0x8>
    8000617c:	4501                	li	a0,0
  return r;
}
    8000617e:	8082                	ret
{
    80006180:	1101                	addi	sp,sp,-32
    80006182:	ec06                	sd	ra,24(sp)
    80006184:	e822                	sd	s0,16(sp)
    80006186:	e426                	sd	s1,8(sp)
    80006188:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000618a:	6904                	ld	s1,16(a0)
    8000618c:	ffffb097          	auipc	ra,0xffffb
    80006190:	cea080e7          	jalr	-790(ra) # 80000e76 <mycpu>
    80006194:	40a48533          	sub	a0,s1,a0
    80006198:	00153513          	seqz	a0,a0
}
    8000619c:	60e2                	ld	ra,24(sp)
    8000619e:	6442                	ld	s0,16(sp)
    800061a0:	64a2                	ld	s1,8(sp)
    800061a2:	6105                	addi	sp,sp,32
    800061a4:	8082                	ret

00000000800061a6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061a6:	1101                	addi	sp,sp,-32
    800061a8:	ec06                	sd	ra,24(sp)
    800061aa:	e822                	sd	s0,16(sp)
    800061ac:	e426                	sd	s1,8(sp)
    800061ae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061b0:	100024f3          	csrr	s1,sstatus
    800061b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061b8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ba:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	cb8080e7          	jalr	-840(ra) # 80000e76 <mycpu>
    800061c6:	5d3c                	lw	a5,120(a0)
    800061c8:	cf89                	beqz	a5,800061e2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ca:	ffffb097          	auipc	ra,0xffffb
    800061ce:	cac080e7          	jalr	-852(ra) # 80000e76 <mycpu>
    800061d2:	5d3c                	lw	a5,120(a0)
    800061d4:	2785                	addiw	a5,a5,1
    800061d6:	dd3c                	sw	a5,120(a0)
}
    800061d8:	60e2                	ld	ra,24(sp)
    800061da:	6442                	ld	s0,16(sp)
    800061dc:	64a2                	ld	s1,8(sp)
    800061de:	6105                	addi	sp,sp,32
    800061e0:	8082                	ret
    mycpu()->intena = old;
    800061e2:	ffffb097          	auipc	ra,0xffffb
    800061e6:	c94080e7          	jalr	-876(ra) # 80000e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061ea:	8085                	srli	s1,s1,0x1
    800061ec:	8885                	andi	s1,s1,1
    800061ee:	dd64                	sw	s1,124(a0)
    800061f0:	bfe9                	j	800061ca <push_off+0x24>

00000000800061f2 <acquire>:
{
    800061f2:	1101                	addi	sp,sp,-32
    800061f4:	ec06                	sd	ra,24(sp)
    800061f6:	e822                	sd	s0,16(sp)
    800061f8:	e426                	sd	s1,8(sp)
    800061fa:	1000                	addi	s0,sp,32
    800061fc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	fa8080e7          	jalr	-88(ra) # 800061a6 <push_off>
  if(holding(lk))
    80006206:	8526                	mv	a0,s1
    80006208:	00000097          	auipc	ra,0x0
    8000620c:	f70080e7          	jalr	-144(ra) # 80006178 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006210:	4705                	li	a4,1
  if(holding(lk))
    80006212:	e115                	bnez	a0,80006236 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006214:	87ba                	mv	a5,a4
    80006216:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000621a:	2781                	sext.w	a5,a5
    8000621c:	ffe5                	bnez	a5,80006214 <acquire+0x22>
  __sync_synchronize();
    8000621e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006222:	ffffb097          	auipc	ra,0xffffb
    80006226:	c54080e7          	jalr	-940(ra) # 80000e76 <mycpu>
    8000622a:	e888                	sd	a0,16(s1)
}
    8000622c:	60e2                	ld	ra,24(sp)
    8000622e:	6442                	ld	s0,16(sp)
    80006230:	64a2                	ld	s1,8(sp)
    80006232:	6105                	addi	sp,sp,32
    80006234:	8082                	ret
    panic("acquire");
    80006236:	00002517          	auipc	a0,0x2
    8000623a:	74a50513          	addi	a0,a0,1866 # 80008980 <digits+0x20>
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	a6a080e7          	jalr	-1430(ra) # 80005ca8 <panic>

0000000080006246 <pop_off>:

void
pop_off(void)
{
    80006246:	1141                	addi	sp,sp,-16
    80006248:	e406                	sd	ra,8(sp)
    8000624a:	e022                	sd	s0,0(sp)
    8000624c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000624e:	ffffb097          	auipc	ra,0xffffb
    80006252:	c28080e7          	jalr	-984(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006256:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000625a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000625c:	e78d                	bnez	a5,80006286 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000625e:	5d3c                	lw	a5,120(a0)
    80006260:	02f05b63          	blez	a5,80006296 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006264:	37fd                	addiw	a5,a5,-1
    80006266:	0007871b          	sext.w	a4,a5
    8000626a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000626c:	eb09                	bnez	a4,8000627e <pop_off+0x38>
    8000626e:	5d7c                	lw	a5,124(a0)
    80006270:	c799                	beqz	a5,8000627e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006272:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006276:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000627a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000627e:	60a2                	ld	ra,8(sp)
    80006280:	6402                	ld	s0,0(sp)
    80006282:	0141                	addi	sp,sp,16
    80006284:	8082                	ret
    panic("pop_off - interruptible");
    80006286:	00002517          	auipc	a0,0x2
    8000628a:	70250513          	addi	a0,a0,1794 # 80008988 <digits+0x28>
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	a1a080e7          	jalr	-1510(ra) # 80005ca8 <panic>
    panic("pop_off");
    80006296:	00002517          	auipc	a0,0x2
    8000629a:	70a50513          	addi	a0,a0,1802 # 800089a0 <digits+0x40>
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	a0a080e7          	jalr	-1526(ra) # 80005ca8 <panic>

00000000800062a6 <release>:
{
    800062a6:	1101                	addi	sp,sp,-32
    800062a8:	ec06                	sd	ra,24(sp)
    800062aa:	e822                	sd	s0,16(sp)
    800062ac:	e426                	sd	s1,8(sp)
    800062ae:	1000                	addi	s0,sp,32
    800062b0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	ec6080e7          	jalr	-314(ra) # 80006178 <holding>
    800062ba:	c115                	beqz	a0,800062de <release+0x38>
  lk->cpu = 0;
    800062bc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062c0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062c4:	0f50000f          	fence	iorw,ow
    800062c8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062cc:	00000097          	auipc	ra,0x0
    800062d0:	f7a080e7          	jalr	-134(ra) # 80006246 <pop_off>
}
    800062d4:	60e2                	ld	ra,24(sp)
    800062d6:	6442                	ld	s0,16(sp)
    800062d8:	64a2                	ld	s1,8(sp)
    800062da:	6105                	addi	sp,sp,32
    800062dc:	8082                	ret
    panic("release");
    800062de:	00002517          	auipc	a0,0x2
    800062e2:	6ca50513          	addi	a0,a0,1738 # 800089a8 <digits+0x48>
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	9c2080e7          	jalr	-1598(ra) # 80005ca8 <panic>
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
