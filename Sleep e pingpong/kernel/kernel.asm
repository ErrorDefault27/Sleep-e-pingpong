
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	b3010113          	addi	sp,sp,-1232 # 80018b30 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	371040ef          	jal	ra,80004b86 <start>

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
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	c0078793          	addi	a5,a5,-1024 # 80020c30 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	104000ef          	jal	ra,8000014c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	8b490913          	addi	s2,s2,-1868 # 80007900 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	548050ef          	jal	ra,8000559e <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	5d0050ef          	jal	ra,80005636 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f9a50513          	addi	a0,a0,-102 # 80007010 <etext+0x10>
    8000007e:	204050ef          	jal	ra,80005282 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	e84a                	sd	s2,16(sp)
    8000008c:	e44e                	sd	s3,8(sp)
    8000008e:	e052                	sd	s4,0(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	94aa                	add	s1,s1,a0
    8000009a:	757d                	lui	a0,0xfffff
    8000009c:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009e:	94be                	add	s1,s1,a5
    800000a0:	0095ec63          	bltu	a1,s1,800000b8 <freerange+0x36>
    800000a4:	892e                	mv	s2,a1
    kfree(p);
    800000a6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000a8:	6985                	lui	s3,0x1
    kfree(p);
    800000aa:	01448533          	add	a0,s1,s4
    800000ae:	f6fff0ef          	jal	ra,8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b2:	94ce                	add	s1,s1,s3
    800000b4:	fe997be3          	bgeu	s2,s1,800000aa <freerange+0x28>
}
    800000b8:	70a2                	ld	ra,40(sp)
    800000ba:	7402                	ld	s0,32(sp)
    800000bc:	64e2                	ld	s1,24(sp)
    800000be:	6942                	ld	s2,16(sp)
    800000c0:	69a2                	ld	s3,8(sp)
    800000c2:	6a02                	ld	s4,0(sp)
    800000c4:	6145                	addi	sp,sp,48
    800000c6:	8082                	ret

00000000800000c8 <kinit>:
{
    800000c8:	1141                	addi	sp,sp,-16
    800000ca:	e406                	sd	ra,8(sp)
    800000cc:	e022                	sd	s0,0(sp)
    800000ce:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d0:	00007597          	auipc	a1,0x7
    800000d4:	f4858593          	addi	a1,a1,-184 # 80007018 <etext+0x18>
    800000d8:	00008517          	auipc	a0,0x8
    800000dc:	82850513          	addi	a0,a0,-2008 # 80007900 <kmem>
    800000e0:	43e050ef          	jal	ra,8000551e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e4:	45c5                	li	a1,17
    800000e6:	05ee                	slli	a1,a1,0x1b
    800000e8:	00021517          	auipc	a0,0x21
    800000ec:	b4850513          	addi	a0,a0,-1208 # 80020c30 <end>
    800000f0:	f93ff0ef          	jal	ra,80000082 <freerange>
}
    800000f4:	60a2                	ld	ra,8(sp)
    800000f6:	6402                	ld	s0,0(sp)
    800000f8:	0141                	addi	sp,sp,16
    800000fa:	8082                	ret

00000000800000fc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fc:	1101                	addi	sp,sp,-32
    800000fe:	ec06                	sd	ra,24(sp)
    80000100:	e822                	sd	s0,16(sp)
    80000102:	e426                	sd	s1,8(sp)
    80000104:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000106:	00007497          	auipc	s1,0x7
    8000010a:	7fa48493          	addi	s1,s1,2042 # 80007900 <kmem>
    8000010e:	8526                	mv	a0,s1
    80000110:	48e050ef          	jal	ra,8000559e <acquire>
  r = kmem.freelist;
    80000114:	6c84                	ld	s1,24(s1)
  if(r)
    80000116:	c485                	beqz	s1,8000013e <kalloc+0x42>
    kmem.freelist = r->next;
    80000118:	609c                	ld	a5,0(s1)
    8000011a:	00007517          	auipc	a0,0x7
    8000011e:	7e650513          	addi	a0,a0,2022 # 80007900 <kmem>
    80000122:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000124:	512050ef          	jal	ra,80005636 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000128:	6605                	lui	a2,0x1
    8000012a:	4595                	li	a1,5
    8000012c:	8526                	mv	a0,s1
    8000012e:	01e000ef          	jal	ra,8000014c <memset>
  return (void*)r;
}
    80000132:	8526                	mv	a0,s1
    80000134:	60e2                	ld	ra,24(sp)
    80000136:	6442                	ld	s0,16(sp)
    80000138:	64a2                	ld	s1,8(sp)
    8000013a:	6105                	addi	sp,sp,32
    8000013c:	8082                	ret
  release(&kmem.lock);
    8000013e:	00007517          	auipc	a0,0x7
    80000142:	7c250513          	addi	a0,a0,1986 # 80007900 <kmem>
    80000146:	4f0050ef          	jal	ra,80005636 <release>
  if(r)
    8000014a:	b7e5                	j	80000132 <kalloc+0x36>

000000008000014c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014c:	1141                	addi	sp,sp,-16
    8000014e:	e422                	sd	s0,8(sp)
    80000150:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000152:	ce09                	beqz	a2,8000016c <memset+0x20>
    80000154:	87aa                	mv	a5,a0
    80000156:	fff6071b          	addiw	a4,a2,-1
    8000015a:	1702                	slli	a4,a4,0x20
    8000015c:	9301                	srli	a4,a4,0x20
    8000015e:	0705                	addi	a4,a4,1
    80000160:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x16>
  }
  return dst;
}
    8000016c:	6422                	ld	s0,8(sp)
    8000016e:	0141                	addi	sp,sp,16
    80000170:	8082                	ret

0000000080000172 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000172:	1141                	addi	sp,sp,-16
    80000174:	e422                	sd	s0,8(sp)
    80000176:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000178:	ca05                	beqz	a2,800001a8 <memcmp+0x36>
    8000017a:	fff6069b          	addiw	a3,a2,-1
    8000017e:	1682                	slli	a3,a3,0x20
    80000180:	9281                	srli	a3,a3,0x20
    80000182:	0685                	addi	a3,a3,1
    80000184:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000186:	00054783          	lbu	a5,0(a0)
    8000018a:	0005c703          	lbu	a4,0(a1)
    8000018e:	00e79863          	bne	a5,a4,8000019e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000192:	0505                	addi	a0,a0,1
    80000194:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000196:	fed518e3          	bne	a0,a3,80000186 <memcmp+0x14>
  }

  return 0;
    8000019a:	4501                	li	a0,0
    8000019c:	a019                	j	800001a2 <memcmp+0x30>
      return *s1 - *s2;
    8000019e:	40e7853b          	subw	a0,a5,a4
}
    800001a2:	6422                	ld	s0,8(sp)
    800001a4:	0141                	addi	sp,sp,16
    800001a6:	8082                	ret
  return 0;
    800001a8:	4501                	li	a0,0
    800001aa:	bfe5                	j	800001a2 <memcmp+0x30>

00000000800001ac <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001ac:	1141                	addi	sp,sp,-16
    800001ae:	e422                	sd	s0,8(sp)
    800001b0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001b2:	ca0d                	beqz	a2,800001e4 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001b4:	00a5f963          	bgeu	a1,a0,800001c6 <memmove+0x1a>
    800001b8:	02061693          	slli	a3,a2,0x20
    800001bc:	9281                	srli	a3,a3,0x20
    800001be:	00d58733          	add	a4,a1,a3
    800001c2:	02e56463          	bltu	a0,a4,800001ea <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c6:	fff6079b          	addiw	a5,a2,-1
    800001ca:	1782                	slli	a5,a5,0x20
    800001cc:	9381                	srli	a5,a5,0x20
    800001ce:	0785                	addi	a5,a5,1
    800001d0:	97ae                	add	a5,a5,a1
    800001d2:	872a                	mv	a4,a0
      *d++ = *s++;
    800001d4:	0585                	addi	a1,a1,1
    800001d6:	0705                	addi	a4,a4,1
    800001d8:	fff5c683          	lbu	a3,-1(a1)
    800001dc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001e0:	fef59ae3          	bne	a1,a5,800001d4 <memmove+0x28>

  return dst;
}
    800001e4:	6422                	ld	s0,8(sp)
    800001e6:	0141                	addi	sp,sp,16
    800001e8:	8082                	ret
    d += n;
    800001ea:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001ec:	fff6079b          	addiw	a5,a2,-1
    800001f0:	1782                	slli	a5,a5,0x20
    800001f2:	9381                	srli	a5,a5,0x20
    800001f4:	fff7c793          	not	a5,a5
    800001f8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001fa:	177d                	addi	a4,a4,-1
    800001fc:	16fd                	addi	a3,a3,-1
    800001fe:	00074603          	lbu	a2,0(a4)
    80000202:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000206:	fef71ae3          	bne	a4,a5,800001fa <memmove+0x4e>
    8000020a:	bfe9                	j	800001e4 <memmove+0x38>

000000008000020c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000020c:	1141                	addi	sp,sp,-16
    8000020e:	e406                	sd	ra,8(sp)
    80000210:	e022                	sd	s0,0(sp)
    80000212:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000214:	f99ff0ef          	jal	ra,800001ac <memmove>
}
    80000218:	60a2                	ld	ra,8(sp)
    8000021a:	6402                	ld	s0,0(sp)
    8000021c:	0141                	addi	sp,sp,16
    8000021e:	8082                	ret

0000000080000220 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000226:	ce11                	beqz	a2,80000242 <strncmp+0x22>
    80000228:	00054783          	lbu	a5,0(a0)
    8000022c:	cf89                	beqz	a5,80000246 <strncmp+0x26>
    8000022e:	0005c703          	lbu	a4,0(a1)
    80000232:	00f71a63          	bne	a4,a5,80000246 <strncmp+0x26>
    n--, p++, q++;
    80000236:	367d                	addiw	a2,a2,-1
    80000238:	0505                	addi	a0,a0,1
    8000023a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000023c:	f675                	bnez	a2,80000228 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000023e:	4501                	li	a0,0
    80000240:	a809                	j	80000252 <strncmp+0x32>
    80000242:	4501                	li	a0,0
    80000244:	a039                	j	80000252 <strncmp+0x32>
  if(n == 0)
    80000246:	ca09                	beqz	a2,80000258 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000248:	00054503          	lbu	a0,0(a0)
    8000024c:	0005c783          	lbu	a5,0(a1)
    80000250:	9d1d                	subw	a0,a0,a5
}
    80000252:	6422                	ld	s0,8(sp)
    80000254:	0141                	addi	sp,sp,16
    80000256:	8082                	ret
    return 0;
    80000258:	4501                	li	a0,0
    8000025a:	bfe5                	j	80000252 <strncmp+0x32>

000000008000025c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e422                	sd	s0,8(sp)
    80000260:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000262:	872a                	mv	a4,a0
    80000264:	8832                	mv	a6,a2
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	01005963          	blez	a6,8000027a <strncpy+0x1e>
    8000026c:	0705                	addi	a4,a4,1
    8000026e:	0005c783          	lbu	a5,0(a1)
    80000272:	fef70fa3          	sb	a5,-1(a4)
    80000276:	0585                	addi	a1,a1,1
    80000278:	f7f5                	bnez	a5,80000264 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000027a:	00c05d63          	blez	a2,80000294 <strncpy+0x38>
    8000027e:	86ba                	mv	a3,a4
    *s++ = 0;
    80000280:	0685                	addi	a3,a3,1
    80000282:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000286:	fff6c793          	not	a5,a3
    8000028a:	9fb9                	addw	a5,a5,a4
    8000028c:	010787bb          	addw	a5,a5,a6
    80000290:	fef048e3          	bgtz	a5,80000280 <strncpy+0x24>
  return os;
}
    80000294:	6422                	ld	s0,8(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a0:	02c05363          	blez	a2,800002c6 <safestrcpy+0x2c>
    800002a4:	fff6069b          	addiw	a3,a2,-1
    800002a8:	1682                	slli	a3,a3,0x20
    800002aa:	9281                	srli	a3,a3,0x20
    800002ac:	96ae                	add	a3,a3,a1
    800002ae:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b0:	00d58963          	beq	a1,a3,800002c2 <safestrcpy+0x28>
    800002b4:	0585                	addi	a1,a1,1
    800002b6:	0785                	addi	a5,a5,1
    800002b8:	fff5c703          	lbu	a4,-1(a1)
    800002bc:	fee78fa3          	sb	a4,-1(a5)
    800002c0:	fb65                	bnez	a4,800002b0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002c2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	addi	sp,sp,16
    800002ca:	8082                	ret

00000000800002cc <strlen>:

int
strlen(const char *s)
{
    800002cc:	1141                	addi	sp,sp,-16
    800002ce:	e422                	sd	s0,8(sp)
    800002d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002d2:	00054783          	lbu	a5,0(a0)
    800002d6:	cf91                	beqz	a5,800002f2 <strlen+0x26>
    800002d8:	0505                	addi	a0,a0,1
    800002da:	87aa                	mv	a5,a0
    800002dc:	4685                	li	a3,1
    800002de:	9e89                	subw	a3,a3,a0
    800002e0:	00f6853b          	addw	a0,a3,a5
    800002e4:	0785                	addi	a5,a5,1
    800002e6:	fff7c703          	lbu	a4,-1(a5)
    800002ea:	fb7d                	bnez	a4,800002e0 <strlen+0x14>
    ;
  return n;
}
    800002ec:	6422                	ld	s0,8(sp)
    800002ee:	0141                	addi	sp,sp,16
    800002f0:	8082                	ret
  for(n = 0; s[n]; n++)
    800002f2:	4501                	li	a0,0
    800002f4:	bfe5                	j	800002ec <strlen+0x20>

00000000800002f6 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e406                	sd	ra,8(sp)
    800002fa:	e022                	sd	s0,0(sp)
    800002fc:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002fe:	1e7000ef          	jal	ra,80000ce4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000302:	00007717          	auipc	a4,0x7
    80000306:	5ce70713          	addi	a4,a4,1486 # 800078d0 <started>
  if(cpuid() == 0){
    8000030a:	c51d                	beqz	a0,80000338 <main+0x42>
    while(started == 0)
    8000030c:	431c                	lw	a5,0(a4)
    8000030e:	2781                	sext.w	a5,a5
    80000310:	dff5                	beqz	a5,8000030c <main+0x16>
      ;
    __sync_synchronize();
    80000312:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000316:	1cf000ef          	jal	ra,80000ce4 <cpuid>
    8000031a:	85aa                	mv	a1,a0
    8000031c:	00007517          	auipc	a0,0x7
    80000320:	d1c50513          	addi	a0,a0,-740 # 80007038 <etext+0x38>
    80000324:	4ab040ef          	jal	ra,80004fce <printf>
    kvminithart();    // turn on paging
    80000328:	080000ef          	jal	ra,800003a8 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000032c:	4cc010ef          	jal	ra,800017f8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000330:	254040ef          	jal	ra,80004584 <plicinithart>
  }

  scheduler();        
    80000334:	60b000ef          	jal	ra,8000113e <scheduler>
    consoleinit();
    80000338:	3bf040ef          	jal	ra,80004ef6 <consoleinit>
    printfinit();
    8000033c:	781040ef          	jal	ra,800052bc <printfinit>
    printf("\n");
    80000340:	00007517          	auipc	a0,0x7
    80000344:	d0850513          	addi	a0,a0,-760 # 80007048 <etext+0x48>
    80000348:	487040ef          	jal	ra,80004fce <printf>
    printf("xv6 kernel is booting\n");
    8000034c:	00007517          	auipc	a0,0x7
    80000350:	cd450513          	addi	a0,a0,-812 # 80007020 <etext+0x20>
    80000354:	47b040ef          	jal	ra,80004fce <printf>
    printf("\n");
    80000358:	00007517          	auipc	a0,0x7
    8000035c:	cf050513          	addi	a0,a0,-784 # 80007048 <etext+0x48>
    80000360:	46f040ef          	jal	ra,80004fce <printf>
    kinit();         // physical page allocator
    80000364:	d65ff0ef          	jal	ra,800000c8 <kinit>
    kvminit();       // create kernel page table
    80000368:	2ca000ef          	jal	ra,80000632 <kvminit>
    kvminithart();   // turn on paging
    8000036c:	03c000ef          	jal	ra,800003a8 <kvminithart>
    procinit();      // process table
    80000370:	0cd000ef          	jal	ra,80000c3c <procinit>
    trapinit();      // trap vectors
    80000374:	460010ef          	jal	ra,800017d4 <trapinit>
    trapinithart();  // install kernel trap vector
    80000378:	480010ef          	jal	ra,800017f8 <trapinithart>
    plicinit();      // set up interrupt controller
    8000037c:	1f2040ef          	jal	ra,8000456e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000380:	204040ef          	jal	ra,80004584 <plicinithart>
    binit();         // buffer cache
    80000384:	29f010ef          	jal	ra,80001e22 <binit>
    iinit();         // inode table
    80000388:	07e020ef          	jal	ra,80002406 <iinit>
    fileinit();      // file table
    8000038c:	619020ef          	jal	ra,800031a4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000390:	2e4040ef          	jal	ra,80004674 <virtio_disk_init>
    userinit();      // first user process
    80000394:	3e5000ef          	jal	ra,80000f78 <userinit>
    __sync_synchronize();
    80000398:	0ff0000f          	fence
    started = 1;
    8000039c:	4785                	li	a5,1
    8000039e:	00007717          	auipc	a4,0x7
    800003a2:	52f72923          	sw	a5,1330(a4) # 800078d0 <started>
    800003a6:	b779                	j	80000334 <main+0x3e>

00000000800003a8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003a8:	1141                	addi	sp,sp,-16
    800003aa:	e422                	sd	s0,8(sp)
    800003ac:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003ae:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003b2:	00007797          	auipc	a5,0x7
    800003b6:	5267b783          	ld	a5,1318(a5) # 800078d8 <kernel_pagetable>
    800003ba:	83b1                	srli	a5,a5,0xc
    800003bc:	577d                	li	a4,-1
    800003be:	177e                	slli	a4,a4,0x3f
    800003c0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003c2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003c6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003ca:	6422                	ld	s0,8(sp)
    800003cc:	0141                	addi	sp,sp,16
    800003ce:	8082                	ret

00000000800003d0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003d0:	7139                	addi	sp,sp,-64
    800003d2:	fc06                	sd	ra,56(sp)
    800003d4:	f822                	sd	s0,48(sp)
    800003d6:	f426                	sd	s1,40(sp)
    800003d8:	f04a                	sd	s2,32(sp)
    800003da:	ec4e                	sd	s3,24(sp)
    800003dc:	e852                	sd	s4,16(sp)
    800003de:	e456                	sd	s5,8(sp)
    800003e0:	e05a                	sd	s6,0(sp)
    800003e2:	0080                	addi	s0,sp,64
    800003e4:	84aa                	mv	s1,a0
    800003e6:	89ae                	mv	s3,a1
    800003e8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003ea:	57fd                	li	a5,-1
    800003ec:	83e9                	srli	a5,a5,0x1a
    800003ee:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003f0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800003f2:	02b7fc63          	bgeu	a5,a1,8000042a <walk+0x5a>
    panic("walk");
    800003f6:	00007517          	auipc	a0,0x7
    800003fa:	c5a50513          	addi	a0,a0,-934 # 80007050 <etext+0x50>
    800003fe:	685040ef          	jal	ra,80005282 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000402:	060a8263          	beqz	s5,80000466 <walk+0x96>
    80000406:	cf7ff0ef          	jal	ra,800000fc <kalloc>
    8000040a:	84aa                	mv	s1,a0
    8000040c:	c139                	beqz	a0,80000452 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000040e:	6605                	lui	a2,0x1
    80000410:	4581                	li	a1,0
    80000412:	d3bff0ef          	jal	ra,8000014c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000416:	00c4d793          	srli	a5,s1,0xc
    8000041a:	07aa                	slli	a5,a5,0xa
    8000041c:	0017e793          	ori	a5,a5,1
    80000420:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000424:	3a5d                	addiw	s4,s4,-9
    80000426:	036a0063          	beq	s4,s6,80000446 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000042a:	0149d933          	srl	s2,s3,s4
    8000042e:	1ff97913          	andi	s2,s2,511
    80000432:	090e                	slli	s2,s2,0x3
    80000434:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000436:	00093483          	ld	s1,0(s2)
    8000043a:	0014f793          	andi	a5,s1,1
    8000043e:	d3f1                	beqz	a5,80000402 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000440:	80a9                	srli	s1,s1,0xa
    80000442:	04b2                	slli	s1,s1,0xc
    80000444:	b7c5                	j	80000424 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000446:	00c9d513          	srli	a0,s3,0xc
    8000044a:	1ff57513          	andi	a0,a0,511
    8000044e:	050e                	slli	a0,a0,0x3
    80000450:	9526                	add	a0,a0,s1
}
    80000452:	70e2                	ld	ra,56(sp)
    80000454:	7442                	ld	s0,48(sp)
    80000456:	74a2                	ld	s1,40(sp)
    80000458:	7902                	ld	s2,32(sp)
    8000045a:	69e2                	ld	s3,24(sp)
    8000045c:	6a42                	ld	s4,16(sp)
    8000045e:	6aa2                	ld	s5,8(sp)
    80000460:	6b02                	ld	s6,0(sp)
    80000462:	6121                	addi	sp,sp,64
    80000464:	8082                	ret
        return 0;
    80000466:	4501                	li	a0,0
    80000468:	b7ed                	j	80000452 <walk+0x82>

000000008000046a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000046a:	57fd                	li	a5,-1
    8000046c:	83e9                	srli	a5,a5,0x1a
    8000046e:	00b7f463          	bgeu	a5,a1,80000476 <walkaddr+0xc>
    return 0;
    80000472:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000474:	8082                	ret
{
    80000476:	1141                	addi	sp,sp,-16
    80000478:	e406                	sd	ra,8(sp)
    8000047a:	e022                	sd	s0,0(sp)
    8000047c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000047e:	4601                	li	a2,0
    80000480:	f51ff0ef          	jal	ra,800003d0 <walk>
  if(pte == 0)
    80000484:	c105                	beqz	a0,800004a4 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000486:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000488:	0117f693          	andi	a3,a5,17
    8000048c:	4745                	li	a4,17
    return 0;
    8000048e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000490:	00e68663          	beq	a3,a4,8000049c <walkaddr+0x32>
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret
  pa = PTE2PA(*pte);
    8000049c:	00a7d513          	srli	a0,a5,0xa
    800004a0:	0532                	slli	a0,a0,0xc
  return pa;
    800004a2:	bfcd                	j	80000494 <walkaddr+0x2a>
    return 0;
    800004a4:	4501                	li	a0,0
    800004a6:	b7fd                	j	80000494 <walkaddr+0x2a>

00000000800004a8 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a8:	715d                	addi	sp,sp,-80
    800004aa:	e486                	sd	ra,72(sp)
    800004ac:	e0a2                	sd	s0,64(sp)
    800004ae:	fc26                	sd	s1,56(sp)
    800004b0:	f84a                	sd	s2,48(sp)
    800004b2:	f44e                	sd	s3,40(sp)
    800004b4:	f052                	sd	s4,32(sp)
    800004b6:	ec56                	sd	s5,24(sp)
    800004b8:	e85a                	sd	s6,16(sp)
    800004ba:	e45e                	sd	s7,8(sp)
    800004bc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004be:	03459793          	slli	a5,a1,0x34
    800004c2:	e385                	bnez	a5,800004e2 <mappages+0x3a>
    800004c4:	8aaa                	mv	s5,a0
    800004c6:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c8:	03461793          	slli	a5,a2,0x34
    800004cc:	e38d                	bnez	a5,800004ee <mappages+0x46>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ce:	c615                	beqz	a2,800004fa <mappages+0x52>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004d0:	79fd                	lui	s3,0xfffff
    800004d2:	964e                	add	a2,a2,s3
    800004d4:	00b609b3          	add	s3,a2,a1
  a = va;
    800004d8:	892e                	mv	s2,a1
    800004da:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004de:	6b85                	lui	s7,0x1
    800004e0:	a815                	j	80000514 <mappages+0x6c>
    panic("mappages: va not aligned");
    800004e2:	00007517          	auipc	a0,0x7
    800004e6:	b7650513          	addi	a0,a0,-1162 # 80007058 <etext+0x58>
    800004ea:	599040ef          	jal	ra,80005282 <panic>
    panic("mappages: size not aligned");
    800004ee:	00007517          	auipc	a0,0x7
    800004f2:	b8a50513          	addi	a0,a0,-1142 # 80007078 <etext+0x78>
    800004f6:	58d040ef          	jal	ra,80005282 <panic>
    panic("mappages: size");
    800004fa:	00007517          	auipc	a0,0x7
    800004fe:	b9e50513          	addi	a0,a0,-1122 # 80007098 <etext+0x98>
    80000502:	581040ef          	jal	ra,80005282 <panic>
      panic("mappages: remap");
    80000506:	00007517          	auipc	a0,0x7
    8000050a:	ba250513          	addi	a0,a0,-1118 # 800070a8 <etext+0xa8>
    8000050e:	575040ef          	jal	ra,80005282 <panic>
    a += PGSIZE;
    80000512:	995e                	add	s2,s2,s7
  for(;;){
    80000514:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000518:	4605                	li	a2,1
    8000051a:	85ca                	mv	a1,s2
    8000051c:	8556                	mv	a0,s5
    8000051e:	eb3ff0ef          	jal	ra,800003d0 <walk>
    80000522:	cd19                	beqz	a0,80000540 <mappages+0x98>
    if(*pte & PTE_V)
    80000524:	611c                	ld	a5,0(a0)
    80000526:	8b85                	andi	a5,a5,1
    80000528:	fff9                	bnez	a5,80000506 <mappages+0x5e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000052a:	80b1                	srli	s1,s1,0xc
    8000052c:	04aa                	slli	s1,s1,0xa
    8000052e:	0164e4b3          	or	s1,s1,s6
    80000532:	0014e493          	ori	s1,s1,1
    80000536:	e104                	sd	s1,0(a0)
    if(a == last)
    80000538:	fd391de3          	bne	s2,s3,80000512 <mappages+0x6a>
    pa += PGSIZE;
  }
  return 0;
    8000053c:	4501                	li	a0,0
    8000053e:	a011                	j	80000542 <mappages+0x9a>
      return -1;
    80000540:	557d                	li	a0,-1
}
    80000542:	60a6                	ld	ra,72(sp)
    80000544:	6406                	ld	s0,64(sp)
    80000546:	74e2                	ld	s1,56(sp)
    80000548:	7942                	ld	s2,48(sp)
    8000054a:	79a2                	ld	s3,40(sp)
    8000054c:	7a02                	ld	s4,32(sp)
    8000054e:	6ae2                	ld	s5,24(sp)
    80000550:	6b42                	ld	s6,16(sp)
    80000552:	6ba2                	ld	s7,8(sp)
    80000554:	6161                	addi	sp,sp,80
    80000556:	8082                	ret

0000000080000558 <kvmmap>:
{
    80000558:	1141                	addi	sp,sp,-16
    8000055a:	e406                	sd	ra,8(sp)
    8000055c:	e022                	sd	s0,0(sp)
    8000055e:	0800                	addi	s0,sp,16
    80000560:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000562:	86b2                	mv	a3,a2
    80000564:	863e                	mv	a2,a5
    80000566:	f43ff0ef          	jal	ra,800004a8 <mappages>
    8000056a:	e509                	bnez	a0,80000574 <kvmmap+0x1c>
}
    8000056c:	60a2                	ld	ra,8(sp)
    8000056e:	6402                	ld	s0,0(sp)
    80000570:	0141                	addi	sp,sp,16
    80000572:	8082                	ret
    panic("kvmmap");
    80000574:	00007517          	auipc	a0,0x7
    80000578:	b4450513          	addi	a0,a0,-1212 # 800070b8 <etext+0xb8>
    8000057c:	507040ef          	jal	ra,80005282 <panic>

0000000080000580 <kvmmake>:
{
    80000580:	1101                	addi	sp,sp,-32
    80000582:	ec06                	sd	ra,24(sp)
    80000584:	e822                	sd	s0,16(sp)
    80000586:	e426                	sd	s1,8(sp)
    80000588:	e04a                	sd	s2,0(sp)
    8000058a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000058c:	b71ff0ef          	jal	ra,800000fc <kalloc>
    80000590:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000592:	6605                	lui	a2,0x1
    80000594:	4581                	li	a1,0
    80000596:	bb7ff0ef          	jal	ra,8000014c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000059a:	4719                	li	a4,6
    8000059c:	6685                	lui	a3,0x1
    8000059e:	10000637          	lui	a2,0x10000
    800005a2:	100005b7          	lui	a1,0x10000
    800005a6:	8526                	mv	a0,s1
    800005a8:	fb1ff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005ac:	4719                	li	a4,6
    800005ae:	6685                	lui	a3,0x1
    800005b0:	10001637          	lui	a2,0x10001
    800005b4:	100015b7          	lui	a1,0x10001
    800005b8:	8526                	mv	a0,s1
    800005ba:	f9fff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005be:	4719                	li	a4,6
    800005c0:	040006b7          	lui	a3,0x4000
    800005c4:	0c000637          	lui	a2,0xc000
    800005c8:	0c0005b7          	lui	a1,0xc000
    800005cc:	8526                	mv	a0,s1
    800005ce:	f8bff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005d2:	00007917          	auipc	s2,0x7
    800005d6:	a2e90913          	addi	s2,s2,-1490 # 80007000 <etext>
    800005da:	4729                	li	a4,10
    800005dc:	80007697          	auipc	a3,0x80007
    800005e0:	a2468693          	addi	a3,a3,-1500 # 7000 <_entry-0x7fff9000>
    800005e4:	4605                	li	a2,1
    800005e6:	067e                	slli	a2,a2,0x1f
    800005e8:	85b2                	mv	a1,a2
    800005ea:	8526                	mv	a0,s1
    800005ec:	f6dff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005f0:	4719                	li	a4,6
    800005f2:	46c5                	li	a3,17
    800005f4:	06ee                	slli	a3,a3,0x1b
    800005f6:	412686b3          	sub	a3,a3,s2
    800005fa:	864a                	mv	a2,s2
    800005fc:	85ca                	mv	a1,s2
    800005fe:	8526                	mv	a0,s1
    80000600:	f59ff0ef          	jal	ra,80000558 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000604:	4729                	li	a4,10
    80000606:	6685                	lui	a3,0x1
    80000608:	00006617          	auipc	a2,0x6
    8000060c:	9f860613          	addi	a2,a2,-1544 # 80006000 <_trampoline>
    80000610:	040005b7          	lui	a1,0x4000
    80000614:	15fd                	addi	a1,a1,-1
    80000616:	05b2                	slli	a1,a1,0xc
    80000618:	8526                	mv	a0,s1
    8000061a:	f3fff0ef          	jal	ra,80000558 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000061e:	8526                	mv	a0,s1
    80000620:	592000ef          	jal	ra,80000bb2 <proc_mapstacks>
}
    80000624:	8526                	mv	a0,s1
    80000626:	60e2                	ld	ra,24(sp)
    80000628:	6442                	ld	s0,16(sp)
    8000062a:	64a2                	ld	s1,8(sp)
    8000062c:	6902                	ld	s2,0(sp)
    8000062e:	6105                	addi	sp,sp,32
    80000630:	8082                	ret

0000000080000632 <kvminit>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000063a:	f47ff0ef          	jal	ra,80000580 <kvmmake>
    8000063e:	00007797          	auipc	a5,0x7
    80000642:	28a7bd23          	sd	a0,666(a5) # 800078d8 <kernel_pagetable>
}
    80000646:	60a2                	ld	ra,8(sp)
    80000648:	6402                	ld	s0,0(sp)
    8000064a:	0141                	addi	sp,sp,16
    8000064c:	8082                	ret

000000008000064e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000064e:	715d                	addi	sp,sp,-80
    80000650:	e486                	sd	ra,72(sp)
    80000652:	e0a2                	sd	s0,64(sp)
    80000654:	fc26                	sd	s1,56(sp)
    80000656:	f84a                	sd	s2,48(sp)
    80000658:	f44e                	sd	s3,40(sp)
    8000065a:	f052                	sd	s4,32(sp)
    8000065c:	ec56                	sd	s5,24(sp)
    8000065e:	e85a                	sd	s6,16(sp)
    80000660:	e45e                	sd	s7,8(sp)
    80000662:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000664:	03459793          	slli	a5,a1,0x34
    80000668:	e795                	bnez	a5,80000694 <uvmunmap+0x46>
    8000066a:	8a2a                	mv	s4,a0
    8000066c:	892e                	mv	s2,a1
    8000066e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000670:	0632                	slli	a2,a2,0xc
    80000672:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000676:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000678:	6b05                	lui	s6,0x1
    8000067a:	0535ee63          	bltu	a1,s3,800006d6 <uvmunmap+0x88>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000067e:	60a6                	ld	ra,72(sp)
    80000680:	6406                	ld	s0,64(sp)
    80000682:	74e2                	ld	s1,56(sp)
    80000684:	7942                	ld	s2,48(sp)
    80000686:	79a2                	ld	s3,40(sp)
    80000688:	7a02                	ld	s4,32(sp)
    8000068a:	6ae2                	ld	s5,24(sp)
    8000068c:	6b42                	ld	s6,16(sp)
    8000068e:	6ba2                	ld	s7,8(sp)
    80000690:	6161                	addi	sp,sp,80
    80000692:	8082                	ret
    panic("uvmunmap: not aligned");
    80000694:	00007517          	auipc	a0,0x7
    80000698:	a2c50513          	addi	a0,a0,-1492 # 800070c0 <etext+0xc0>
    8000069c:	3e7040ef          	jal	ra,80005282 <panic>
      panic("uvmunmap: walk");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a3850513          	addi	a0,a0,-1480 # 800070d8 <etext+0xd8>
    800006a8:	3db040ef          	jal	ra,80005282 <panic>
      panic("uvmunmap: not mapped");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a3c50513          	addi	a0,a0,-1476 # 800070e8 <etext+0xe8>
    800006b4:	3cf040ef          	jal	ra,80005282 <panic>
      panic("uvmunmap: not a leaf");
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a4850513          	addi	a0,a0,-1464 # 80007100 <etext+0x100>
    800006c0:	3c3040ef          	jal	ra,80005282 <panic>
      uint64 pa = PTE2PA(*pte);
    800006c4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006c6:	0532                	slli	a0,a0,0xc
    800006c8:	955ff0ef          	jal	ra,8000001c <kfree>
    *pte = 0;
    800006cc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006d0:	995a                	add	s2,s2,s6
    800006d2:	fb3976e3          	bgeu	s2,s3,8000067e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006d6:	4601                	li	a2,0
    800006d8:	85ca                	mv	a1,s2
    800006da:	8552                	mv	a0,s4
    800006dc:	cf5ff0ef          	jal	ra,800003d0 <walk>
    800006e0:	84aa                	mv	s1,a0
    800006e2:	dd5d                	beqz	a0,800006a0 <uvmunmap+0x52>
    if((*pte & PTE_V) == 0)
    800006e4:	6108                	ld	a0,0(a0)
    800006e6:	00157793          	andi	a5,a0,1
    800006ea:	d3e9                	beqz	a5,800006ac <uvmunmap+0x5e>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006ec:	3ff57793          	andi	a5,a0,1023
    800006f0:	fd7784e3          	beq	a5,s7,800006b8 <uvmunmap+0x6a>
    if(do_free){
    800006f4:	fc0a8ce3          	beqz	s5,800006cc <uvmunmap+0x7e>
    800006f8:	b7f1                	j	800006c4 <uvmunmap+0x76>

00000000800006fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800006fa:	1101                	addi	sp,sp,-32
    800006fc:	ec06                	sd	ra,24(sp)
    800006fe:	e822                	sd	s0,16(sp)
    80000700:	e426                	sd	s1,8(sp)
    80000702:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000704:	9f9ff0ef          	jal	ra,800000fc <kalloc>
    80000708:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000070a:	c509                	beqz	a0,80000714 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000070c:	6605                	lui	a2,0x1
    8000070e:	4581                	li	a1,0
    80000710:	a3dff0ef          	jal	ra,8000014c <memset>
  return pagetable;
}
    80000714:	8526                	mv	a0,s1
    80000716:	60e2                	ld	ra,24(sp)
    80000718:	6442                	ld	s0,16(sp)
    8000071a:	64a2                	ld	s1,8(sp)
    8000071c:	6105                	addi	sp,sp,32
    8000071e:	8082                	ret

0000000080000720 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000720:	7179                	addi	sp,sp,-48
    80000722:	f406                	sd	ra,40(sp)
    80000724:	f022                	sd	s0,32(sp)
    80000726:	ec26                	sd	s1,24(sp)
    80000728:	e84a                	sd	s2,16(sp)
    8000072a:	e44e                	sd	s3,8(sp)
    8000072c:	e052                	sd	s4,0(sp)
    8000072e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000730:	6785                	lui	a5,0x1
    80000732:	04f67063          	bgeu	a2,a5,80000772 <uvmfirst+0x52>
    80000736:	8a2a                	mv	s4,a0
    80000738:	89ae                	mv	s3,a1
    8000073a:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000073c:	9c1ff0ef          	jal	ra,800000fc <kalloc>
    80000740:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000742:	6605                	lui	a2,0x1
    80000744:	4581                	li	a1,0
    80000746:	a07ff0ef          	jal	ra,8000014c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000074a:	4779                	li	a4,30
    8000074c:	86ca                	mv	a3,s2
    8000074e:	6605                	lui	a2,0x1
    80000750:	4581                	li	a1,0
    80000752:	8552                	mv	a0,s4
    80000754:	d55ff0ef          	jal	ra,800004a8 <mappages>
  memmove(mem, src, sz);
    80000758:	8626                	mv	a2,s1
    8000075a:	85ce                	mv	a1,s3
    8000075c:	854a                	mv	a0,s2
    8000075e:	a4fff0ef          	jal	ra,800001ac <memmove>
}
    80000762:	70a2                	ld	ra,40(sp)
    80000764:	7402                	ld	s0,32(sp)
    80000766:	64e2                	ld	s1,24(sp)
    80000768:	6942                	ld	s2,16(sp)
    8000076a:	69a2                	ld	s3,8(sp)
    8000076c:	6a02                	ld	s4,0(sp)
    8000076e:	6145                	addi	sp,sp,48
    80000770:	8082                	ret
    panic("uvmfirst: more than a page");
    80000772:	00007517          	auipc	a0,0x7
    80000776:	9a650513          	addi	a0,a0,-1626 # 80007118 <etext+0x118>
    8000077a:	309040ef          	jal	ra,80005282 <panic>

000000008000077e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000077e:	1101                	addi	sp,sp,-32
    80000780:	ec06                	sd	ra,24(sp)
    80000782:	e822                	sd	s0,16(sp)
    80000784:	e426                	sd	s1,8(sp)
    80000786:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000788:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000078a:	00b67d63          	bgeu	a2,a1,800007a4 <uvmdealloc+0x26>
    8000078e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000790:	6785                	lui	a5,0x1
    80000792:	17fd                	addi	a5,a5,-1
    80000794:	00f60733          	add	a4,a2,a5
    80000798:	767d                	lui	a2,0xfffff
    8000079a:	8f71                	and	a4,a4,a2
    8000079c:	97ae                	add	a5,a5,a1
    8000079e:	8ff1                	and	a5,a5,a2
    800007a0:	00f76863          	bltu	a4,a5,800007b0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007a4:	8526                	mv	a0,s1
    800007a6:	60e2                	ld	ra,24(sp)
    800007a8:	6442                	ld	s0,16(sp)
    800007aa:	64a2                	ld	s1,8(sp)
    800007ac:	6105                	addi	sp,sp,32
    800007ae:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007b0:	8f99                	sub	a5,a5,a4
    800007b2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007b4:	4685                	li	a3,1
    800007b6:	0007861b          	sext.w	a2,a5
    800007ba:	85ba                	mv	a1,a4
    800007bc:	e93ff0ef          	jal	ra,8000064e <uvmunmap>
    800007c0:	b7d5                	j	800007a4 <uvmdealloc+0x26>

00000000800007c2 <uvmalloc>:
  if(newsz < oldsz)
    800007c2:	08b66963          	bltu	a2,a1,80000854 <uvmalloc+0x92>
{
    800007c6:	7139                	addi	sp,sp,-64
    800007c8:	fc06                	sd	ra,56(sp)
    800007ca:	f822                	sd	s0,48(sp)
    800007cc:	f426                	sd	s1,40(sp)
    800007ce:	f04a                	sd	s2,32(sp)
    800007d0:	ec4e                	sd	s3,24(sp)
    800007d2:	e852                	sd	s4,16(sp)
    800007d4:	e456                	sd	s5,8(sp)
    800007d6:	e05a                	sd	s6,0(sp)
    800007d8:	0080                	addi	s0,sp,64
    800007da:	8aaa                	mv	s5,a0
    800007dc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007de:	6985                	lui	s3,0x1
    800007e0:	19fd                	addi	s3,s3,-1
    800007e2:	95ce                	add	a1,a1,s3
    800007e4:	79fd                	lui	s3,0xfffff
    800007e6:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007ea:	06c9f763          	bgeu	s3,a2,80000858 <uvmalloc+0x96>
    800007ee:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f0:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007f4:	909ff0ef          	jal	ra,800000fc <kalloc>
    800007f8:	84aa                	mv	s1,a0
    if(mem == 0){
    800007fa:	c11d                	beqz	a0,80000820 <uvmalloc+0x5e>
    memset(mem, 0, PGSIZE);
    800007fc:	6605                	lui	a2,0x1
    800007fe:	4581                	li	a1,0
    80000800:	94dff0ef          	jal	ra,8000014c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000804:	875a                	mv	a4,s6
    80000806:	86a6                	mv	a3,s1
    80000808:	6605                	lui	a2,0x1
    8000080a:	85ca                	mv	a1,s2
    8000080c:	8556                	mv	a0,s5
    8000080e:	c9bff0ef          	jal	ra,800004a8 <mappages>
    80000812:	e51d                	bnez	a0,80000840 <uvmalloc+0x7e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000814:	6785                	lui	a5,0x1
    80000816:	993e                	add	s2,s2,a5
    80000818:	fd496ee3          	bltu	s2,s4,800007f4 <uvmalloc+0x32>
  return newsz;
    8000081c:	8552                	mv	a0,s4
    8000081e:	a039                	j	8000082c <uvmalloc+0x6a>
      uvmdealloc(pagetable, a, oldsz);
    80000820:	864e                	mv	a2,s3
    80000822:	85ca                	mv	a1,s2
    80000824:	8556                	mv	a0,s5
    80000826:	f59ff0ef          	jal	ra,8000077e <uvmdealloc>
      return 0;
    8000082a:	4501                	li	a0,0
}
    8000082c:	70e2                	ld	ra,56(sp)
    8000082e:	7442                	ld	s0,48(sp)
    80000830:	74a2                	ld	s1,40(sp)
    80000832:	7902                	ld	s2,32(sp)
    80000834:	69e2                	ld	s3,24(sp)
    80000836:	6a42                	ld	s4,16(sp)
    80000838:	6aa2                	ld	s5,8(sp)
    8000083a:	6b02                	ld	s6,0(sp)
    8000083c:	6121                	addi	sp,sp,64
    8000083e:	8082                	ret
      kfree(mem);
    80000840:	8526                	mv	a0,s1
    80000842:	fdaff0ef          	jal	ra,8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000846:	864e                	mv	a2,s3
    80000848:	85ca                	mv	a1,s2
    8000084a:	8556                	mv	a0,s5
    8000084c:	f33ff0ef          	jal	ra,8000077e <uvmdealloc>
      return 0;
    80000850:	4501                	li	a0,0
    80000852:	bfe9                	j	8000082c <uvmalloc+0x6a>
    return oldsz;
    80000854:	852e                	mv	a0,a1
}
    80000856:	8082                	ret
  return newsz;
    80000858:	8532                	mv	a0,a2
    8000085a:	bfc9                	j	8000082c <uvmalloc+0x6a>

000000008000085c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000085c:	7179                	addi	sp,sp,-48
    8000085e:	f406                	sd	ra,40(sp)
    80000860:	f022                	sd	s0,32(sp)
    80000862:	ec26                	sd	s1,24(sp)
    80000864:	e84a                	sd	s2,16(sp)
    80000866:	e44e                	sd	s3,8(sp)
    80000868:	e052                	sd	s4,0(sp)
    8000086a:	1800                	addi	s0,sp,48
    8000086c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000086e:	84aa                	mv	s1,a0
    80000870:	6905                	lui	s2,0x1
    80000872:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000874:	4985                	li	s3,1
    80000876:	a811                	j	8000088a <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000878:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000087a:	0532                	slli	a0,a0,0xc
    8000087c:	fe1ff0ef          	jal	ra,8000085c <freewalk>
      pagetable[i] = 0;
    80000880:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000884:	04a1                	addi	s1,s1,8
    80000886:	01248f63          	beq	s1,s2,800008a4 <freewalk+0x48>
    pte_t pte = pagetable[i];
    8000088a:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000088c:	00f57793          	andi	a5,a0,15
    80000890:	ff3784e3          	beq	a5,s3,80000878 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000894:	8905                	andi	a0,a0,1
    80000896:	d57d                	beqz	a0,80000884 <freewalk+0x28>
      panic("freewalk: leaf");
    80000898:	00007517          	auipc	a0,0x7
    8000089c:	8a050513          	addi	a0,a0,-1888 # 80007138 <etext+0x138>
    800008a0:	1e3040ef          	jal	ra,80005282 <panic>
    }
  }
  kfree((void*)pagetable);
    800008a4:	8552                	mv	a0,s4
    800008a6:	f76ff0ef          	jal	ra,8000001c <kfree>
}
    800008aa:	70a2                	ld	ra,40(sp)
    800008ac:	7402                	ld	s0,32(sp)
    800008ae:	64e2                	ld	s1,24(sp)
    800008b0:	6942                	ld	s2,16(sp)
    800008b2:	69a2                	ld	s3,8(sp)
    800008b4:	6a02                	ld	s4,0(sp)
    800008b6:	6145                	addi	sp,sp,48
    800008b8:	8082                	ret

00000000800008ba <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008ba:	1101                	addi	sp,sp,-32
    800008bc:	ec06                	sd	ra,24(sp)
    800008be:	e822                	sd	s0,16(sp)
    800008c0:	e426                	sd	s1,8(sp)
    800008c2:	1000                	addi	s0,sp,32
    800008c4:	84aa                	mv	s1,a0
  if(sz > 0)
    800008c6:	e989                	bnez	a1,800008d8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008c8:	8526                	mv	a0,s1
    800008ca:	f93ff0ef          	jal	ra,8000085c <freewalk>
}
    800008ce:	60e2                	ld	ra,24(sp)
    800008d0:	6442                	ld	s0,16(sp)
    800008d2:	64a2                	ld	s1,8(sp)
    800008d4:	6105                	addi	sp,sp,32
    800008d6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008d8:	6605                	lui	a2,0x1
    800008da:	167d                	addi	a2,a2,-1
    800008dc:	962e                	add	a2,a2,a1
    800008de:	4685                	li	a3,1
    800008e0:	8231                	srli	a2,a2,0xc
    800008e2:	4581                	li	a1,0
    800008e4:	d6bff0ef          	jal	ra,8000064e <uvmunmap>
    800008e8:	b7c5                	j	800008c8 <uvmfree+0xe>

00000000800008ea <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800008ea:	c65d                	beqz	a2,80000998 <uvmcopy+0xae>
{
    800008ec:	715d                	addi	sp,sp,-80
    800008ee:	e486                	sd	ra,72(sp)
    800008f0:	e0a2                	sd	s0,64(sp)
    800008f2:	fc26                	sd	s1,56(sp)
    800008f4:	f84a                	sd	s2,48(sp)
    800008f6:	f44e                	sd	s3,40(sp)
    800008f8:	f052                	sd	s4,32(sp)
    800008fa:	ec56                	sd	s5,24(sp)
    800008fc:	e85a                	sd	s6,16(sp)
    800008fe:	e45e                	sd	s7,8(sp)
    80000900:	0880                	addi	s0,sp,80
    80000902:	8b2a                	mv	s6,a0
    80000904:	8aae                	mv	s5,a1
    80000906:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000908:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000090a:	4601                	li	a2,0
    8000090c:	85ce                	mv	a1,s3
    8000090e:	855a                	mv	a0,s6
    80000910:	ac1ff0ef          	jal	ra,800003d0 <walk>
    80000914:	c121                	beqz	a0,80000954 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000916:	6118                	ld	a4,0(a0)
    80000918:	00177793          	andi	a5,a4,1
    8000091c:	c3b1                	beqz	a5,80000960 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000091e:	00a75593          	srli	a1,a4,0xa
    80000922:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000926:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000092a:	fd2ff0ef          	jal	ra,800000fc <kalloc>
    8000092e:	892a                	mv	s2,a0
    80000930:	c129                	beqz	a0,80000972 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000932:	6605                	lui	a2,0x1
    80000934:	85de                	mv	a1,s7
    80000936:	877ff0ef          	jal	ra,800001ac <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000093a:	8726                	mv	a4,s1
    8000093c:	86ca                	mv	a3,s2
    8000093e:	6605                	lui	a2,0x1
    80000940:	85ce                	mv	a1,s3
    80000942:	8556                	mv	a0,s5
    80000944:	b65ff0ef          	jal	ra,800004a8 <mappages>
    80000948:	e115                	bnez	a0,8000096c <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000094a:	6785                	lui	a5,0x1
    8000094c:	99be                	add	s3,s3,a5
    8000094e:	fb49eee3          	bltu	s3,s4,8000090a <uvmcopy+0x20>
    80000952:	a805                	j	80000982 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80000954:	00006517          	auipc	a0,0x6
    80000958:	7f450513          	addi	a0,a0,2036 # 80007148 <etext+0x148>
    8000095c:	127040ef          	jal	ra,80005282 <panic>
      panic("uvmcopy: page not present");
    80000960:	00007517          	auipc	a0,0x7
    80000964:	80850513          	addi	a0,a0,-2040 # 80007168 <etext+0x168>
    80000968:	11b040ef          	jal	ra,80005282 <panic>
      kfree(mem);
    8000096c:	854a                	mv	a0,s2
    8000096e:	eaeff0ef          	jal	ra,8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000972:	4685                	li	a3,1
    80000974:	00c9d613          	srli	a2,s3,0xc
    80000978:	4581                	li	a1,0
    8000097a:	8556                	mv	a0,s5
    8000097c:	cd3ff0ef          	jal	ra,8000064e <uvmunmap>
  return -1;
    80000980:	557d                	li	a0,-1
}
    80000982:	60a6                	ld	ra,72(sp)
    80000984:	6406                	ld	s0,64(sp)
    80000986:	74e2                	ld	s1,56(sp)
    80000988:	7942                	ld	s2,48(sp)
    8000098a:	79a2                	ld	s3,40(sp)
    8000098c:	7a02                	ld	s4,32(sp)
    8000098e:	6ae2                	ld	s5,24(sp)
    80000990:	6b42                	ld	s6,16(sp)
    80000992:	6ba2                	ld	s7,8(sp)
    80000994:	6161                	addi	sp,sp,80
    80000996:	8082                	ret
  return 0;
    80000998:	4501                	li	a0,0
}
    8000099a:	8082                	ret

000000008000099c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000099c:	1141                	addi	sp,sp,-16
    8000099e:	e406                	sd	ra,8(sp)
    800009a0:	e022                	sd	s0,0(sp)
    800009a2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009a4:	4601                	li	a2,0
    800009a6:	a2bff0ef          	jal	ra,800003d0 <walk>
  if(pte == 0)
    800009aa:	c901                	beqz	a0,800009ba <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ac:	611c                	ld	a5,0(a0)
    800009ae:	9bbd                	andi	a5,a5,-17
    800009b0:	e11c                	sd	a5,0(a0)
}
    800009b2:	60a2                	ld	ra,8(sp)
    800009b4:	6402                	ld	s0,0(sp)
    800009b6:	0141                	addi	sp,sp,16
    800009b8:	8082                	ret
    panic("uvmclear");
    800009ba:	00006517          	auipc	a0,0x6
    800009be:	7ce50513          	addi	a0,a0,1998 # 80007188 <etext+0x188>
    800009c2:	0c1040ef          	jal	ra,80005282 <panic>

00000000800009c6 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    800009c6:	c6c9                	beqz	a3,80000a50 <copyout+0x8a>
{
    800009c8:	711d                	addi	sp,sp,-96
    800009ca:	ec86                	sd	ra,88(sp)
    800009cc:	e8a2                	sd	s0,80(sp)
    800009ce:	e4a6                	sd	s1,72(sp)
    800009d0:	e0ca                	sd	s2,64(sp)
    800009d2:	fc4e                	sd	s3,56(sp)
    800009d4:	f852                	sd	s4,48(sp)
    800009d6:	f456                	sd	s5,40(sp)
    800009d8:	f05a                	sd	s6,32(sp)
    800009da:	ec5e                	sd	s7,24(sp)
    800009dc:	e862                	sd	s8,16(sp)
    800009de:	e466                	sd	s9,8(sp)
    800009e0:	e06a                	sd	s10,0(sp)
    800009e2:	1080                	addi	s0,sp,96
    800009e4:	8baa                	mv	s7,a0
    800009e6:	8aae                	mv	s5,a1
    800009e8:	8b32                	mv	s6,a2
    800009ea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800009ec:	74fd                	lui	s1,0xfffff
    800009ee:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800009f0:	57fd                	li	a5,-1
    800009f2:	83e9                	srli	a5,a5,0x1a
    800009f4:	0697e063          	bltu	a5,s1,80000a54 <copyout+0x8e>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800009f8:	4cd5                	li	s9,21
    800009fa:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800009fc:	8c3e                	mv	s8,a5
    800009fe:	a025                	j	80000a26 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a00:	83a9                	srli	a5,a5,0xa
    80000a02:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a04:	409a8533          	sub	a0,s5,s1
    80000a08:	0009061b          	sext.w	a2,s2
    80000a0c:	85da                	mv	a1,s6
    80000a0e:	953e                	add	a0,a0,a5
    80000a10:	f9cff0ef          	jal	ra,800001ac <memmove>

    len -= n;
    80000a14:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a18:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a1a:	02098963          	beqz	s3,80000a4c <copyout+0x86>
    if(va0 >= MAXVA)
    80000a1e:	034c6d63          	bltu	s8,s4,80000a58 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80000a22:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000a24:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a26:	4601                	li	a2,0
    80000a28:	85a6                	mv	a1,s1
    80000a2a:	855e                	mv	a0,s7
    80000a2c:	9a5ff0ef          	jal	ra,800003d0 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a30:	c515                	beqz	a0,80000a5c <copyout+0x96>
    80000a32:	611c                	ld	a5,0(a0)
    80000a34:	0157f713          	andi	a4,a5,21
    80000a38:	05971163          	bne	a4,s9,80000a7a <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80000a3c:	01a48a33          	add	s4,s1,s10
    80000a40:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a44:	fb29fee3          	bgeu	s3,s2,80000a00 <copyout+0x3a>
    80000a48:	894e                	mv	s2,s3
    80000a4a:	bf5d                	j	80000a00 <copyout+0x3a>
  }
  return 0;
    80000a4c:	4501                	li	a0,0
    80000a4e:	a801                	j	80000a5e <copyout+0x98>
    80000a50:	4501                	li	a0,0
}
    80000a52:	8082                	ret
      return -1;
    80000a54:	557d                	li	a0,-1
    80000a56:	a021                	j	80000a5e <copyout+0x98>
    80000a58:	557d                	li	a0,-1
    80000a5a:	a011                	j	80000a5e <copyout+0x98>
      return -1;
    80000a5c:	557d                	li	a0,-1
}
    80000a5e:	60e6                	ld	ra,88(sp)
    80000a60:	6446                	ld	s0,80(sp)
    80000a62:	64a6                	ld	s1,72(sp)
    80000a64:	6906                	ld	s2,64(sp)
    80000a66:	79e2                	ld	s3,56(sp)
    80000a68:	7a42                	ld	s4,48(sp)
    80000a6a:	7aa2                	ld	s5,40(sp)
    80000a6c:	7b02                	ld	s6,32(sp)
    80000a6e:	6be2                	ld	s7,24(sp)
    80000a70:	6c42                	ld	s8,16(sp)
    80000a72:	6ca2                	ld	s9,8(sp)
    80000a74:	6d02                	ld	s10,0(sp)
    80000a76:	6125                	addi	sp,sp,96
    80000a78:	8082                	ret
      return -1;
    80000a7a:	557d                	li	a0,-1
    80000a7c:	b7cd                	j	80000a5e <copyout+0x98>

0000000080000a7e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000a7e:	c2bd                	beqz	a3,80000ae4 <copyin+0x66>
{
    80000a80:	715d                	addi	sp,sp,-80
    80000a82:	e486                	sd	ra,72(sp)
    80000a84:	e0a2                	sd	s0,64(sp)
    80000a86:	fc26                	sd	s1,56(sp)
    80000a88:	f84a                	sd	s2,48(sp)
    80000a8a:	f44e                	sd	s3,40(sp)
    80000a8c:	f052                	sd	s4,32(sp)
    80000a8e:	ec56                	sd	s5,24(sp)
    80000a90:	e85a                	sd	s6,16(sp)
    80000a92:	e45e                	sd	s7,8(sp)
    80000a94:	e062                	sd	s8,0(sp)
    80000a96:	0880                	addi	s0,sp,80
    80000a98:	8b2a                	mv	s6,a0
    80000a9a:	8a2e                	mv	s4,a1
    80000a9c:	8c32                	mv	s8,a2
    80000a9e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000aa0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000aa2:	6a85                	lui	s5,0x1
    80000aa4:	a005                	j	80000ac4 <copyin+0x46>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000aa6:	9562                	add	a0,a0,s8
    80000aa8:	0004861b          	sext.w	a2,s1
    80000aac:	412505b3          	sub	a1,a0,s2
    80000ab0:	8552                	mv	a0,s4
    80000ab2:	efaff0ef          	jal	ra,800001ac <memmove>

    len -= n;
    80000ab6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000aba:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000abc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ac0:	02098063          	beqz	s3,80000ae0 <copyin+0x62>
    va0 = PGROUNDDOWN(srcva);
    80000ac4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ac8:	85ca                	mv	a1,s2
    80000aca:	855a                	mv	a0,s6
    80000acc:	99fff0ef          	jal	ra,8000046a <walkaddr>
    if(pa0 == 0)
    80000ad0:	cd01                	beqz	a0,80000ae8 <copyin+0x6a>
    n = PGSIZE - (srcva - va0);
    80000ad2:	418904b3          	sub	s1,s2,s8
    80000ad6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000ad8:	fc99f7e3          	bgeu	s3,s1,80000aa6 <copyin+0x28>
    80000adc:	84ce                	mv	s1,s3
    80000ade:	b7e1                	j	80000aa6 <copyin+0x28>
  }
  return 0;
    80000ae0:	4501                	li	a0,0
    80000ae2:	a021                	j	80000aea <copyin+0x6c>
    80000ae4:	4501                	li	a0,0
}
    80000ae6:	8082                	ret
      return -1;
    80000ae8:	557d                	li	a0,-1
}
    80000aea:	60a6                	ld	ra,72(sp)
    80000aec:	6406                	ld	s0,64(sp)
    80000aee:	74e2                	ld	s1,56(sp)
    80000af0:	7942                	ld	s2,48(sp)
    80000af2:	79a2                	ld	s3,40(sp)
    80000af4:	7a02                	ld	s4,32(sp)
    80000af6:	6ae2                	ld	s5,24(sp)
    80000af8:	6b42                	ld	s6,16(sp)
    80000afa:	6ba2                	ld	s7,8(sp)
    80000afc:	6c02                	ld	s8,0(sp)
    80000afe:	6161                	addi	sp,sp,80
    80000b00:	8082                	ret

0000000080000b02 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b02:	c2d5                	beqz	a3,80000ba6 <copyinstr+0xa4>
{
    80000b04:	715d                	addi	sp,sp,-80
    80000b06:	e486                	sd	ra,72(sp)
    80000b08:	e0a2                	sd	s0,64(sp)
    80000b0a:	fc26                	sd	s1,56(sp)
    80000b0c:	f84a                	sd	s2,48(sp)
    80000b0e:	f44e                	sd	s3,40(sp)
    80000b10:	f052                	sd	s4,32(sp)
    80000b12:	ec56                	sd	s5,24(sp)
    80000b14:	e85a                	sd	s6,16(sp)
    80000b16:	e45e                	sd	s7,8(sp)
    80000b18:	0880                	addi	s0,sp,80
    80000b1a:	8a2a                	mv	s4,a0
    80000b1c:	8b2e                	mv	s6,a1
    80000b1e:	8bb2                	mv	s7,a2
    80000b20:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000b22:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b24:	6985                	lui	s3,0x1
    80000b26:	a035                	j	80000b52 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b28:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000b2c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b2e:	0017b793          	seqz	a5,a5
    80000b32:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b36:	60a6                	ld	ra,72(sp)
    80000b38:	6406                	ld	s0,64(sp)
    80000b3a:	74e2                	ld	s1,56(sp)
    80000b3c:	7942                	ld	s2,48(sp)
    80000b3e:	79a2                	ld	s3,40(sp)
    80000b40:	7a02                	ld	s4,32(sp)
    80000b42:	6ae2                	ld	s5,24(sp)
    80000b44:	6b42                	ld	s6,16(sp)
    80000b46:	6ba2                	ld	s7,8(sp)
    80000b48:	6161                	addi	sp,sp,80
    80000b4a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b4c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000b50:	c4b9                	beqz	s1,80000b9e <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000b52:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	8552                	mv	a0,s4
    80000b5a:	911ff0ef          	jal	ra,8000046a <walkaddr>
    if(pa0 == 0)
    80000b5e:	c131                	beqz	a0,80000ba2 <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000b60:	41790833          	sub	a6,s2,s7
    80000b64:	984e                	add	a6,a6,s3
    if(n > max)
    80000b66:	0104f363          	bgeu	s1,a6,80000b6c <copyinstr+0x6a>
    80000b6a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000b6c:	955e                	add	a0,a0,s7
    80000b6e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000b72:	fc080de3          	beqz	a6,80000b4c <copyinstr+0x4a>
    80000b76:	985a                	add	a6,a6,s6
    80000b78:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000b7a:	41650633          	sub	a2,a0,s6
    80000b7e:	14fd                	addi	s1,s1,-1
    80000b80:	9b26                	add	s6,s6,s1
    80000b82:	00f60733          	add	a4,a2,a5
    80000b86:	00074703          	lbu	a4,0(a4)
    80000b8a:	df59                	beqz	a4,80000b28 <copyinstr+0x26>
        *dst = *p;
    80000b8c:	00e78023          	sb	a4,0(a5)
      --max;
    80000b90:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000b94:	0785                	addi	a5,a5,1
    while(n > 0){
    80000b96:	ff0796e3          	bne	a5,a6,80000b82 <copyinstr+0x80>
      dst++;
    80000b9a:	8b42                	mv	s6,a6
    80000b9c:	bf45                	j	80000b4c <copyinstr+0x4a>
    80000b9e:	4781                	li	a5,0
    80000ba0:	b779                	j	80000b2e <copyinstr+0x2c>
      return -1;
    80000ba2:	557d                	li	a0,-1
    80000ba4:	bf49                	j	80000b36 <copyinstr+0x34>
  int got_null = 0;
    80000ba6:	4781                	li	a5,0
  if(got_null){
    80000ba8:	0017b793          	seqz	a5,a5
    80000bac:	40f00533          	neg	a0,a5
}
    80000bb0:	8082                	ret

0000000080000bb2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bb2:	7139                	addi	sp,sp,-64
    80000bb4:	fc06                	sd	ra,56(sp)
    80000bb6:	f822                	sd	s0,48(sp)
    80000bb8:	f426                	sd	s1,40(sp)
    80000bba:	f04a                	sd	s2,32(sp)
    80000bbc:	ec4e                	sd	s3,24(sp)
    80000bbe:	e852                	sd	s4,16(sp)
    80000bc0:	e456                	sd	s5,8(sp)
    80000bc2:	e05a                	sd	s6,0(sp)
    80000bc4:	0080                	addi	s0,sp,64
    80000bc6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bc8:	00007497          	auipc	s1,0x7
    80000bcc:	18848493          	addi	s1,s1,392 # 80007d50 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bd0:	8b26                	mv	s6,s1
    80000bd2:	00006a97          	auipc	s5,0x6
    80000bd6:	42ea8a93          	addi	s5,s5,1070 # 80007000 <etext>
    80000bda:	04000937          	lui	s2,0x4000
    80000bde:	197d                	addi	s2,s2,-1
    80000be0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000be2:	0000da17          	auipc	s4,0xd
    80000be6:	b6ea0a13          	addi	s4,s4,-1170 # 8000d750 <tickslock>
    char *pa = kalloc();
    80000bea:	d12ff0ef          	jal	ra,800000fc <kalloc>
    80000bee:	862a                	mv	a2,a0
    if(pa == 0)
    80000bf0:	c121                	beqz	a0,80000c30 <proc_mapstacks+0x7e>
    uint64 va = KSTACK((int) (p - proc));
    80000bf2:	416485b3          	sub	a1,s1,s6
    80000bf6:	858d                	srai	a1,a1,0x3
    80000bf8:	000ab783          	ld	a5,0(s5)
    80000bfc:	02f585b3          	mul	a1,a1,a5
    80000c00:	2585                	addiw	a1,a1,1
    80000c02:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c06:	4719                	li	a4,6
    80000c08:	6685                	lui	a3,0x1
    80000c0a:	40b905b3          	sub	a1,s2,a1
    80000c0e:	854e                	mv	a0,s3
    80000c10:	949ff0ef          	jal	ra,80000558 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c14:	16848493          	addi	s1,s1,360
    80000c18:	fd4499e3          	bne	s1,s4,80000bea <proc_mapstacks+0x38>
  }
}
    80000c1c:	70e2                	ld	ra,56(sp)
    80000c1e:	7442                	ld	s0,48(sp)
    80000c20:	74a2                	ld	s1,40(sp)
    80000c22:	7902                	ld	s2,32(sp)
    80000c24:	69e2                	ld	s3,24(sp)
    80000c26:	6a42                	ld	s4,16(sp)
    80000c28:	6aa2                	ld	s5,8(sp)
    80000c2a:	6b02                	ld	s6,0(sp)
    80000c2c:	6121                	addi	sp,sp,64
    80000c2e:	8082                	ret
      panic("kalloc");
    80000c30:	00006517          	auipc	a0,0x6
    80000c34:	56850513          	addi	a0,a0,1384 # 80007198 <etext+0x198>
    80000c38:	64a040ef          	jal	ra,80005282 <panic>

0000000080000c3c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c3c:	7139                	addi	sp,sp,-64
    80000c3e:	fc06                	sd	ra,56(sp)
    80000c40:	f822                	sd	s0,48(sp)
    80000c42:	f426                	sd	s1,40(sp)
    80000c44:	f04a                	sd	s2,32(sp)
    80000c46:	ec4e                	sd	s3,24(sp)
    80000c48:	e852                	sd	s4,16(sp)
    80000c4a:	e456                	sd	s5,8(sp)
    80000c4c:	e05a                	sd	s6,0(sp)
    80000c4e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c50:	00006597          	auipc	a1,0x6
    80000c54:	55058593          	addi	a1,a1,1360 # 800071a0 <etext+0x1a0>
    80000c58:	00007517          	auipc	a0,0x7
    80000c5c:	cc850513          	addi	a0,a0,-824 # 80007920 <pid_lock>
    80000c60:	0bf040ef          	jal	ra,8000551e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000c64:	00006597          	auipc	a1,0x6
    80000c68:	54458593          	addi	a1,a1,1348 # 800071a8 <etext+0x1a8>
    80000c6c:	00007517          	auipc	a0,0x7
    80000c70:	ccc50513          	addi	a0,a0,-820 # 80007938 <wait_lock>
    80000c74:	0ab040ef          	jal	ra,8000551e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c78:	00007497          	auipc	s1,0x7
    80000c7c:	0d848493          	addi	s1,s1,216 # 80007d50 <proc>
      initlock(&p->lock, "proc");
    80000c80:	00006b17          	auipc	s6,0x6
    80000c84:	538b0b13          	addi	s6,s6,1336 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000c88:	8aa6                	mv	s5,s1
    80000c8a:	00006a17          	auipc	s4,0x6
    80000c8e:	376a0a13          	addi	s4,s4,886 # 80007000 <etext>
    80000c92:	04000937          	lui	s2,0x4000
    80000c96:	197d                	addi	s2,s2,-1
    80000c98:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9a:	0000d997          	auipc	s3,0xd
    80000c9e:	ab698993          	addi	s3,s3,-1354 # 8000d750 <tickslock>
      initlock(&p->lock, "proc");
    80000ca2:	85da                	mv	a1,s6
    80000ca4:	8526                	mv	a0,s1
    80000ca6:	079040ef          	jal	ra,8000551e <initlock>
      p->state = UNUSED;
    80000caa:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cae:	415487b3          	sub	a5,s1,s5
    80000cb2:	878d                	srai	a5,a5,0x3
    80000cb4:	000a3703          	ld	a4,0(s4)
    80000cb8:	02e787b3          	mul	a5,a5,a4
    80000cbc:	2785                	addiw	a5,a5,1
    80000cbe:	00d7979b          	slliw	a5,a5,0xd
    80000cc2:	40f907b3          	sub	a5,s2,a5
    80000cc6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cc8:	16848493          	addi	s1,s1,360
    80000ccc:	fd349be3          	bne	s1,s3,80000ca2 <procinit+0x66>
  }
}
    80000cd0:	70e2                	ld	ra,56(sp)
    80000cd2:	7442                	ld	s0,48(sp)
    80000cd4:	74a2                	ld	s1,40(sp)
    80000cd6:	7902                	ld	s2,32(sp)
    80000cd8:	69e2                	ld	s3,24(sp)
    80000cda:	6a42                	ld	s4,16(sp)
    80000cdc:	6aa2                	ld	s5,8(sp)
    80000cde:	6b02                	ld	s6,0(sp)
    80000ce0:	6121                	addi	sp,sp,64
    80000ce2:	8082                	ret

0000000080000ce4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ce4:	1141                	addi	sp,sp,-16
    80000ce6:	e422                	sd	s0,8(sp)
    80000ce8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000cea:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000cec:	2501                	sext.w	a0,a0
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	addi	s0,sp,16
    80000cfa:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000cfc:	2781                	sext.w	a5,a5
    80000cfe:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d00:	00007517          	auipc	a0,0x7
    80000d04:	c5050513          	addi	a0,a0,-944 # 80007950 <cpus>
    80000d08:	953e                	add	a0,a0,a5
    80000d0a:	6422                	ld	s0,8(sp)
    80000d0c:	0141                	addi	sp,sp,16
    80000d0e:	8082                	ret

0000000080000d10 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d10:	1101                	addi	sp,sp,-32
    80000d12:	ec06                	sd	ra,24(sp)
    80000d14:	e822                	sd	s0,16(sp)
    80000d16:	e426                	sd	s1,8(sp)
    80000d18:	1000                	addi	s0,sp,32
  push_off();
    80000d1a:	045040ef          	jal	ra,8000555e <push_off>
    80000d1e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d20:	2781                	sext.w	a5,a5
    80000d22:	079e                	slli	a5,a5,0x7
    80000d24:	00007717          	auipc	a4,0x7
    80000d28:	bfc70713          	addi	a4,a4,-1028 # 80007920 <pid_lock>
    80000d2c:	97ba                	add	a5,a5,a4
    80000d2e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d30:	0b3040ef          	jal	ra,800055e2 <pop_off>
  return p;
}
    80000d34:	8526                	mv	a0,s1
    80000d36:	60e2                	ld	ra,24(sp)
    80000d38:	6442                	ld	s0,16(sp)
    80000d3a:	64a2                	ld	s1,8(sp)
    80000d3c:	6105                	addi	sp,sp,32
    80000d3e:	8082                	ret

0000000080000d40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d40:	1141                	addi	sp,sp,-16
    80000d42:	e406                	sd	ra,8(sp)
    80000d44:	e022                	sd	s0,0(sp)
    80000d46:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d48:	fc9ff0ef          	jal	ra,80000d10 <myproc>
    80000d4c:	0eb040ef          	jal	ra,80005636 <release>

  if (first) {
    80000d50:	00007797          	auipc	a5,0x7
    80000d54:	b307a783          	lw	a5,-1232(a5) # 80007880 <first.2195>
    80000d58:	e799                	bnez	a5,80000d66 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000d5a:	2b7000ef          	jal	ra,80001810 <usertrapret>
}
    80000d5e:	60a2                	ld	ra,8(sp)
    80000d60:	6402                	ld	s0,0(sp)
    80000d62:	0141                	addi	sp,sp,16
    80000d64:	8082                	ret
    fsinit(ROOTDEV);
    80000d66:	4505                	li	a0,1
    80000d68:	632010ef          	jal	ra,8000239a <fsinit>
    first = 0;
    80000d6c:	00007797          	auipc	a5,0x7
    80000d70:	b007aa23          	sw	zero,-1260(a5) # 80007880 <first.2195>
    __sync_synchronize();
    80000d74:	0ff0000f          	fence
    80000d78:	b7cd                	j	80000d5a <forkret+0x1a>

0000000080000d7a <allocpid>:
{
    80000d7a:	1101                	addi	sp,sp,-32
    80000d7c:	ec06                	sd	ra,24(sp)
    80000d7e:	e822                	sd	s0,16(sp)
    80000d80:	e426                	sd	s1,8(sp)
    80000d82:	e04a                	sd	s2,0(sp)
    80000d84:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000d86:	00007917          	auipc	s2,0x7
    80000d8a:	b9a90913          	addi	s2,s2,-1126 # 80007920 <pid_lock>
    80000d8e:	854a                	mv	a0,s2
    80000d90:	00f040ef          	jal	ra,8000559e <acquire>
  pid = nextpid;
    80000d94:	00007797          	auipc	a5,0x7
    80000d98:	af078793          	addi	a5,a5,-1296 # 80007884 <nextpid>
    80000d9c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000d9e:	0014871b          	addiw	a4,s1,1
    80000da2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000da4:	854a                	mv	a0,s2
    80000da6:	091040ef          	jal	ra,80005636 <release>
}
    80000daa:	8526                	mv	a0,s1
    80000dac:	60e2                	ld	ra,24(sp)
    80000dae:	6442                	ld	s0,16(sp)
    80000db0:	64a2                	ld	s1,8(sp)
    80000db2:	6902                	ld	s2,0(sp)
    80000db4:	6105                	addi	sp,sp,32
    80000db6:	8082                	ret

0000000080000db8 <proc_pagetable>:
{
    80000db8:	1101                	addi	sp,sp,-32
    80000dba:	ec06                	sd	ra,24(sp)
    80000dbc:	e822                	sd	s0,16(sp)
    80000dbe:	e426                	sd	s1,8(sp)
    80000dc0:	e04a                	sd	s2,0(sp)
    80000dc2:	1000                	addi	s0,sp,32
    80000dc4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000dc6:	935ff0ef          	jal	ra,800006fa <uvmcreate>
    80000dca:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000dcc:	cd05                	beqz	a0,80000e04 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000dce:	4729                	li	a4,10
    80000dd0:	00005697          	auipc	a3,0x5
    80000dd4:	23068693          	addi	a3,a3,560 # 80006000 <_trampoline>
    80000dd8:	6605                	lui	a2,0x1
    80000dda:	040005b7          	lui	a1,0x4000
    80000dde:	15fd                	addi	a1,a1,-1
    80000de0:	05b2                	slli	a1,a1,0xc
    80000de2:	ec6ff0ef          	jal	ra,800004a8 <mappages>
    80000de6:	02054663          	bltz	a0,80000e12 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000dea:	4719                	li	a4,6
    80000dec:	05893683          	ld	a3,88(s2)
    80000df0:	6605                	lui	a2,0x1
    80000df2:	020005b7          	lui	a1,0x2000
    80000df6:	15fd                	addi	a1,a1,-1
    80000df8:	05b6                	slli	a1,a1,0xd
    80000dfa:	8526                	mv	a0,s1
    80000dfc:	eacff0ef          	jal	ra,800004a8 <mappages>
    80000e00:	00054f63          	bltz	a0,80000e1e <proc_pagetable+0x66>
}
    80000e04:	8526                	mv	a0,s1
    80000e06:	60e2                	ld	ra,24(sp)
    80000e08:	6442                	ld	s0,16(sp)
    80000e0a:	64a2                	ld	s1,8(sp)
    80000e0c:	6902                	ld	s2,0(sp)
    80000e0e:	6105                	addi	sp,sp,32
    80000e10:	8082                	ret
    uvmfree(pagetable, 0);
    80000e12:	4581                	li	a1,0
    80000e14:	8526                	mv	a0,s1
    80000e16:	aa5ff0ef          	jal	ra,800008ba <uvmfree>
    return 0;
    80000e1a:	4481                	li	s1,0
    80000e1c:	b7e5                	j	80000e04 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e1e:	4681                	li	a3,0
    80000e20:	4605                	li	a2,1
    80000e22:	040005b7          	lui	a1,0x4000
    80000e26:	15fd                	addi	a1,a1,-1
    80000e28:	05b2                	slli	a1,a1,0xc
    80000e2a:	8526                	mv	a0,s1
    80000e2c:	823ff0ef          	jal	ra,8000064e <uvmunmap>
    uvmfree(pagetable, 0);
    80000e30:	4581                	li	a1,0
    80000e32:	8526                	mv	a0,s1
    80000e34:	a87ff0ef          	jal	ra,800008ba <uvmfree>
    return 0;
    80000e38:	4481                	li	s1,0
    80000e3a:	b7e9                	j	80000e04 <proc_pagetable+0x4c>

0000000080000e3c <proc_freepagetable>:
{
    80000e3c:	1101                	addi	sp,sp,-32
    80000e3e:	ec06                	sd	ra,24(sp)
    80000e40:	e822                	sd	s0,16(sp)
    80000e42:	e426                	sd	s1,8(sp)
    80000e44:	e04a                	sd	s2,0(sp)
    80000e46:	1000                	addi	s0,sp,32
    80000e48:	84aa                	mv	s1,a0
    80000e4a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e4c:	4681                	li	a3,0
    80000e4e:	4605                	li	a2,1
    80000e50:	040005b7          	lui	a1,0x4000
    80000e54:	15fd                	addi	a1,a1,-1
    80000e56:	05b2                	slli	a1,a1,0xc
    80000e58:	ff6ff0ef          	jal	ra,8000064e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000e5c:	4681                	li	a3,0
    80000e5e:	4605                	li	a2,1
    80000e60:	020005b7          	lui	a1,0x2000
    80000e64:	15fd                	addi	a1,a1,-1
    80000e66:	05b6                	slli	a1,a1,0xd
    80000e68:	8526                	mv	a0,s1
    80000e6a:	fe4ff0ef          	jal	ra,8000064e <uvmunmap>
  uvmfree(pagetable, sz);
    80000e6e:	85ca                	mv	a1,s2
    80000e70:	8526                	mv	a0,s1
    80000e72:	a49ff0ef          	jal	ra,800008ba <uvmfree>
}
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6902                	ld	s2,0(sp)
    80000e7e:	6105                	addi	sp,sp,32
    80000e80:	8082                	ret

0000000080000e82 <freeproc>:
{
    80000e82:	1101                	addi	sp,sp,-32
    80000e84:	ec06                	sd	ra,24(sp)
    80000e86:	e822                	sd	s0,16(sp)
    80000e88:	e426                	sd	s1,8(sp)
    80000e8a:	1000                	addi	s0,sp,32
    80000e8c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000e8e:	6d28                	ld	a0,88(a0)
    80000e90:	c119                	beqz	a0,80000e96 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000e92:	98aff0ef          	jal	ra,8000001c <kfree>
  p->trapframe = 0;
    80000e96:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000e9a:	68a8                	ld	a0,80(s1)
    80000e9c:	c501                	beqz	a0,80000ea4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000e9e:	64ac                	ld	a1,72(s1)
    80000ea0:	f9dff0ef          	jal	ra,80000e3c <proc_freepagetable>
  p->pagetable = 0;
    80000ea4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ea8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000eac:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000eb0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000eb4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000eb8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000ebc:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000ec0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000ec4:	0004ac23          	sw	zero,24(s1)
}
    80000ec8:	60e2                	ld	ra,24(sp)
    80000eca:	6442                	ld	s0,16(sp)
    80000ecc:	64a2                	ld	s1,8(sp)
    80000ece:	6105                	addi	sp,sp,32
    80000ed0:	8082                	ret

0000000080000ed2 <allocproc>:
{
    80000ed2:	1101                	addi	sp,sp,-32
    80000ed4:	ec06                	sd	ra,24(sp)
    80000ed6:	e822                	sd	s0,16(sp)
    80000ed8:	e426                	sd	s1,8(sp)
    80000eda:	e04a                	sd	s2,0(sp)
    80000edc:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ede:	00007497          	auipc	s1,0x7
    80000ee2:	e7248493          	addi	s1,s1,-398 # 80007d50 <proc>
    80000ee6:	0000d917          	auipc	s2,0xd
    80000eea:	86a90913          	addi	s2,s2,-1942 # 8000d750 <tickslock>
    acquire(&p->lock);
    80000eee:	8526                	mv	a0,s1
    80000ef0:	6ae040ef          	jal	ra,8000559e <acquire>
    if(p->state == UNUSED) {
    80000ef4:	4c9c                	lw	a5,24(s1)
    80000ef6:	cb91                	beqz	a5,80000f0a <allocproc+0x38>
      release(&p->lock);
    80000ef8:	8526                	mv	a0,s1
    80000efa:	73c040ef          	jal	ra,80005636 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efe:	16848493          	addi	s1,s1,360
    80000f02:	ff2496e3          	bne	s1,s2,80000eee <allocproc+0x1c>
  return 0;
    80000f06:	4481                	li	s1,0
    80000f08:	a089                	j	80000f4a <allocproc+0x78>
  p->pid = allocpid();
    80000f0a:	e71ff0ef          	jal	ra,80000d7a <allocpid>
    80000f0e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f10:	4785                	li	a5,1
    80000f12:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f14:	9e8ff0ef          	jal	ra,800000fc <kalloc>
    80000f18:	892a                	mv	s2,a0
    80000f1a:	eca8                	sd	a0,88(s1)
    80000f1c:	cd15                	beqz	a0,80000f58 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f1e:	8526                	mv	a0,s1
    80000f20:	e99ff0ef          	jal	ra,80000db8 <proc_pagetable>
    80000f24:	892a                	mv	s2,a0
    80000f26:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f28:	c121                	beqz	a0,80000f68 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f2a:	07000613          	li	a2,112
    80000f2e:	4581                	li	a1,0
    80000f30:	06048513          	addi	a0,s1,96
    80000f34:	a18ff0ef          	jal	ra,8000014c <memset>
  p->context.ra = (uint64)forkret;
    80000f38:	00000797          	auipc	a5,0x0
    80000f3c:	e0878793          	addi	a5,a5,-504 # 80000d40 <forkret>
    80000f40:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f42:	60bc                	ld	a5,64(s1)
    80000f44:	6705                	lui	a4,0x1
    80000f46:	97ba                	add	a5,a5,a4
    80000f48:	f4bc                	sd	a5,104(s1)
}
    80000f4a:	8526                	mv	a0,s1
    80000f4c:	60e2                	ld	ra,24(sp)
    80000f4e:	6442                	ld	s0,16(sp)
    80000f50:	64a2                	ld	s1,8(sp)
    80000f52:	6902                	ld	s2,0(sp)
    80000f54:	6105                	addi	sp,sp,32
    80000f56:	8082                	ret
    freeproc(p);
    80000f58:	8526                	mv	a0,s1
    80000f5a:	f29ff0ef          	jal	ra,80000e82 <freeproc>
    release(&p->lock);
    80000f5e:	8526                	mv	a0,s1
    80000f60:	6d6040ef          	jal	ra,80005636 <release>
    return 0;
    80000f64:	84ca                	mv	s1,s2
    80000f66:	b7d5                	j	80000f4a <allocproc+0x78>
    freeproc(p);
    80000f68:	8526                	mv	a0,s1
    80000f6a:	f19ff0ef          	jal	ra,80000e82 <freeproc>
    release(&p->lock);
    80000f6e:	8526                	mv	a0,s1
    80000f70:	6c6040ef          	jal	ra,80005636 <release>
    return 0;
    80000f74:	84ca                	mv	s1,s2
    80000f76:	bfd1                	j	80000f4a <allocproc+0x78>

0000000080000f78 <userinit>:
{
    80000f78:	1101                	addi	sp,sp,-32
    80000f7a:	ec06                	sd	ra,24(sp)
    80000f7c:	e822                	sd	s0,16(sp)
    80000f7e:	e426                	sd	s1,8(sp)
    80000f80:	1000                	addi	s0,sp,32
  p = allocproc();
    80000f82:	f51ff0ef          	jal	ra,80000ed2 <allocproc>
    80000f86:	84aa                	mv	s1,a0
  initproc = p;
    80000f88:	00007797          	auipc	a5,0x7
    80000f8c:	94a7bc23          	sd	a0,-1704(a5) # 800078e0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000f90:	03400613          	li	a2,52
    80000f94:	00007597          	auipc	a1,0x7
    80000f98:	8fc58593          	addi	a1,a1,-1796 # 80007890 <initcode>
    80000f9c:	6928                	ld	a0,80(a0)
    80000f9e:	f82ff0ef          	jal	ra,80000720 <uvmfirst>
  p->sz = PGSIZE;
    80000fa2:	6785                	lui	a5,0x1
    80000fa4:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000fa6:	6cb8                	ld	a4,88(s1)
    80000fa8:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000fac:	6cb8                	ld	a4,88(s1)
    80000fae:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000fb0:	4641                	li	a2,16
    80000fb2:	00006597          	auipc	a1,0x6
    80000fb6:	20e58593          	addi	a1,a1,526 # 800071c0 <etext+0x1c0>
    80000fba:	15848513          	addi	a0,s1,344
    80000fbe:	adcff0ef          	jal	ra,8000029a <safestrcpy>
  p->cwd = namei("/");
    80000fc2:	00006517          	auipc	a0,0x6
    80000fc6:	20e50513          	addi	a0,a0,526 # 800071d0 <etext+0x1d0>
    80000fca:	4af010ef          	jal	ra,80002c78 <namei>
    80000fce:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80000fd2:	478d                	li	a5,3
    80000fd4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80000fd6:	8526                	mv	a0,s1
    80000fd8:	65e040ef          	jal	ra,80005636 <release>
}
    80000fdc:	60e2                	ld	ra,24(sp)
    80000fde:	6442                	ld	s0,16(sp)
    80000fe0:	64a2                	ld	s1,8(sp)
    80000fe2:	6105                	addi	sp,sp,32
    80000fe4:	8082                	ret

0000000080000fe6 <growproc>:
{
    80000fe6:	1101                	addi	sp,sp,-32
    80000fe8:	ec06                	sd	ra,24(sp)
    80000fea:	e822                	sd	s0,16(sp)
    80000fec:	e426                	sd	s1,8(sp)
    80000fee:	e04a                	sd	s2,0(sp)
    80000ff0:	1000                	addi	s0,sp,32
    80000ff2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80000ff4:	d1dff0ef          	jal	ra,80000d10 <myproc>
    80000ff8:	84aa                	mv	s1,a0
  sz = p->sz;
    80000ffa:	652c                	ld	a1,72(a0)
  if(n > 0){
    80000ffc:	01204c63          	bgtz	s2,80001014 <growproc+0x2e>
  } else if(n < 0){
    80001000:	02094463          	bltz	s2,80001028 <growproc+0x42>
  p->sz = sz;
    80001004:	e4ac                	sd	a1,72(s1)
  return 0;
    80001006:	4501                	li	a0,0
}
    80001008:	60e2                	ld	ra,24(sp)
    8000100a:	6442                	ld	s0,16(sp)
    8000100c:	64a2                	ld	s1,8(sp)
    8000100e:	6902                	ld	s2,0(sp)
    80001010:	6105                	addi	sp,sp,32
    80001012:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001014:	4691                	li	a3,4
    80001016:	00b90633          	add	a2,s2,a1
    8000101a:	6928                	ld	a0,80(a0)
    8000101c:	fa6ff0ef          	jal	ra,800007c2 <uvmalloc>
    80001020:	85aa                	mv	a1,a0
    80001022:	f16d                	bnez	a0,80001004 <growproc+0x1e>
      return -1;
    80001024:	557d                	li	a0,-1
    80001026:	b7cd                	j	80001008 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001028:	00b90633          	add	a2,s2,a1
    8000102c:	6928                	ld	a0,80(a0)
    8000102e:	f50ff0ef          	jal	ra,8000077e <uvmdealloc>
    80001032:	85aa                	mv	a1,a0
    80001034:	bfc1                	j	80001004 <growproc+0x1e>

0000000080001036 <fork>:
{
    80001036:	7179                	addi	sp,sp,-48
    80001038:	f406                	sd	ra,40(sp)
    8000103a:	f022                	sd	s0,32(sp)
    8000103c:	ec26                	sd	s1,24(sp)
    8000103e:	e84a                	sd	s2,16(sp)
    80001040:	e44e                	sd	s3,8(sp)
    80001042:	e052                	sd	s4,0(sp)
    80001044:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001046:	ccbff0ef          	jal	ra,80000d10 <myproc>
    8000104a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000104c:	e87ff0ef          	jal	ra,80000ed2 <allocproc>
    80001050:	0e050563          	beqz	a0,8000113a <fork+0x104>
    80001054:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001056:	04893603          	ld	a2,72(s2)
    8000105a:	692c                	ld	a1,80(a0)
    8000105c:	05093503          	ld	a0,80(s2)
    80001060:	88bff0ef          	jal	ra,800008ea <uvmcopy>
    80001064:	04054663          	bltz	a0,800010b0 <fork+0x7a>
  np->sz = p->sz;
    80001068:	04893783          	ld	a5,72(s2)
    8000106c:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001070:	05893683          	ld	a3,88(s2)
    80001074:	87b6                	mv	a5,a3
    80001076:	0589b703          	ld	a4,88(s3)
    8000107a:	12068693          	addi	a3,a3,288
    8000107e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001082:	6788                	ld	a0,8(a5)
    80001084:	6b8c                	ld	a1,16(a5)
    80001086:	6f90                	ld	a2,24(a5)
    80001088:	01073023          	sd	a6,0(a4)
    8000108c:	e708                	sd	a0,8(a4)
    8000108e:	eb0c                	sd	a1,16(a4)
    80001090:	ef10                	sd	a2,24(a4)
    80001092:	02078793          	addi	a5,a5,32
    80001096:	02070713          	addi	a4,a4,32
    8000109a:	fed792e3          	bne	a5,a3,8000107e <fork+0x48>
  np->trapframe->a0 = 0;
    8000109e:	0589b783          	ld	a5,88(s3)
    800010a2:	0607b823          	sd	zero,112(a5)
    800010a6:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800010aa:	15000a13          	li	s4,336
    800010ae:	a00d                	j	800010d0 <fork+0x9a>
    freeproc(np);
    800010b0:	854e                	mv	a0,s3
    800010b2:	dd1ff0ef          	jal	ra,80000e82 <freeproc>
    release(&np->lock);
    800010b6:	854e                	mv	a0,s3
    800010b8:	57e040ef          	jal	ra,80005636 <release>
    return -1;
    800010bc:	5a7d                	li	s4,-1
    800010be:	a0ad                	j	80001128 <fork+0xf2>
      np->ofile[i] = filedup(p->ofile[i]);
    800010c0:	166020ef          	jal	ra,80003226 <filedup>
    800010c4:	009987b3          	add	a5,s3,s1
    800010c8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800010ca:	04a1                	addi	s1,s1,8
    800010cc:	01448763          	beq	s1,s4,800010da <fork+0xa4>
    if(p->ofile[i])
    800010d0:	009907b3          	add	a5,s2,s1
    800010d4:	6388                	ld	a0,0(a5)
    800010d6:	f56d                	bnez	a0,800010c0 <fork+0x8a>
    800010d8:	bfcd                	j	800010ca <fork+0x94>
  np->cwd = idup(p->cwd);
    800010da:	15093503          	ld	a0,336(s2)
    800010de:	4b2010ef          	jal	ra,80002590 <idup>
    800010e2:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800010e6:	4641                	li	a2,16
    800010e8:	15890593          	addi	a1,s2,344
    800010ec:	15898513          	addi	a0,s3,344
    800010f0:	9aaff0ef          	jal	ra,8000029a <safestrcpy>
  pid = np->pid;
    800010f4:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800010f8:	854e                	mv	a0,s3
    800010fa:	53c040ef          	jal	ra,80005636 <release>
  acquire(&wait_lock);
    800010fe:	00007497          	auipc	s1,0x7
    80001102:	83a48493          	addi	s1,s1,-1990 # 80007938 <wait_lock>
    80001106:	8526                	mv	a0,s1
    80001108:	496040ef          	jal	ra,8000559e <acquire>
  np->parent = p;
    8000110c:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001110:	8526                	mv	a0,s1
    80001112:	524040ef          	jal	ra,80005636 <release>
  acquire(&np->lock);
    80001116:	854e                	mv	a0,s3
    80001118:	486040ef          	jal	ra,8000559e <acquire>
  np->state = RUNNABLE;
    8000111c:	478d                	li	a5,3
    8000111e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001122:	854e                	mv	a0,s3
    80001124:	512040ef          	jal	ra,80005636 <release>
}
    80001128:	8552                	mv	a0,s4
    8000112a:	70a2                	ld	ra,40(sp)
    8000112c:	7402                	ld	s0,32(sp)
    8000112e:	64e2                	ld	s1,24(sp)
    80001130:	6942                	ld	s2,16(sp)
    80001132:	69a2                	ld	s3,8(sp)
    80001134:	6a02                	ld	s4,0(sp)
    80001136:	6145                	addi	sp,sp,48
    80001138:	8082                	ret
    return -1;
    8000113a:	5a7d                	li	s4,-1
    8000113c:	b7f5                	j	80001128 <fork+0xf2>

000000008000113e <scheduler>:
{
    8000113e:	715d                	addi	sp,sp,-80
    80001140:	e486                	sd	ra,72(sp)
    80001142:	e0a2                	sd	s0,64(sp)
    80001144:	fc26                	sd	s1,56(sp)
    80001146:	f84a                	sd	s2,48(sp)
    80001148:	f44e                	sd	s3,40(sp)
    8000114a:	f052                	sd	s4,32(sp)
    8000114c:	ec56                	sd	s5,24(sp)
    8000114e:	e85a                	sd	s6,16(sp)
    80001150:	e45e                	sd	s7,8(sp)
    80001152:	e062                	sd	s8,0(sp)
    80001154:	0880                	addi	s0,sp,80
    80001156:	8792                	mv	a5,tp
  int id = r_tp();
    80001158:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000115a:	00779b13          	slli	s6,a5,0x7
    8000115e:	00006717          	auipc	a4,0x6
    80001162:	7c270713          	addi	a4,a4,1986 # 80007920 <pid_lock>
    80001166:	975a                	add	a4,a4,s6
    80001168:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000116c:	00006717          	auipc	a4,0x6
    80001170:	7ec70713          	addi	a4,a4,2028 # 80007958 <cpus+0x8>
    80001174:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001176:	4c11                	li	s8,4
        c->proc = p;
    80001178:	079e                	slli	a5,a5,0x7
    8000117a:	00006a17          	auipc	s4,0x6
    8000117e:	7a6a0a13          	addi	s4,s4,1958 # 80007920 <pid_lock>
    80001182:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001184:	0000c997          	auipc	s3,0xc
    80001188:	5cc98993          	addi	s3,s3,1484 # 8000d750 <tickslock>
        found = 1;
    8000118c:	4b85                	li	s7,1
    8000118e:	a0a9                	j	800011d8 <scheduler+0x9a>
        p->state = RUNNING;
    80001190:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001194:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001198:	06048593          	addi	a1,s1,96
    8000119c:	855a                	mv	a0,s6
    8000119e:	5cc000ef          	jal	ra,8000176a <swtch>
        c->proc = 0;
    800011a2:	020a3823          	sd	zero,48(s4)
        found = 1;
    800011a6:	8ade                	mv	s5,s7
      release(&p->lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	48c040ef          	jal	ra,80005636 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011ae:	16848493          	addi	s1,s1,360
    800011b2:	01348963          	beq	s1,s3,800011c4 <scheduler+0x86>
      acquire(&p->lock);
    800011b6:	8526                	mv	a0,s1
    800011b8:	3e6040ef          	jal	ra,8000559e <acquire>
      if(p->state == RUNNABLE) {
    800011bc:	4c9c                	lw	a5,24(s1)
    800011be:	ff2795e3          	bne	a5,s2,800011a8 <scheduler+0x6a>
    800011c2:	b7f9                	j	80001190 <scheduler+0x52>
    if(found == 0) {
    800011c4:	000a9a63          	bnez	s5,800011d8 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800011cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800011d0:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    800011d4:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800011d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800011dc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800011e0:	10079073          	csrw	sstatus,a5
    int found = 0;
    800011e4:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800011e6:	00007497          	auipc	s1,0x7
    800011ea:	b6a48493          	addi	s1,s1,-1174 # 80007d50 <proc>
      if(p->state == RUNNABLE) {
    800011ee:	490d                	li	s2,3
    800011f0:	b7d9                	j	800011b6 <scheduler+0x78>

00000000800011f2 <sched>:
{
    800011f2:	7179                	addi	sp,sp,-48
    800011f4:	f406                	sd	ra,40(sp)
    800011f6:	f022                	sd	s0,32(sp)
    800011f8:	ec26                	sd	s1,24(sp)
    800011fa:	e84a                	sd	s2,16(sp)
    800011fc:	e44e                	sd	s3,8(sp)
    800011fe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001200:	b11ff0ef          	jal	ra,80000d10 <myproc>
    80001204:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001206:	32e040ef          	jal	ra,80005534 <holding>
    8000120a:	c92d                	beqz	a0,8000127c <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000120c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000120e:	2781                	sext.w	a5,a5
    80001210:	079e                	slli	a5,a5,0x7
    80001212:	00006717          	auipc	a4,0x6
    80001216:	70e70713          	addi	a4,a4,1806 # 80007920 <pid_lock>
    8000121a:	97ba                	add	a5,a5,a4
    8000121c:	0a87a703          	lw	a4,168(a5)
    80001220:	4785                	li	a5,1
    80001222:	06f71363          	bne	a4,a5,80001288 <sched+0x96>
  if(p->state == RUNNING)
    80001226:	4c98                	lw	a4,24(s1)
    80001228:	4791                	li	a5,4
    8000122a:	06f70563          	beq	a4,a5,80001294 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000122e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001232:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001234:	e7b5                	bnez	a5,800012a0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001236:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001238:	00006917          	auipc	s2,0x6
    8000123c:	6e890913          	addi	s2,s2,1768 # 80007920 <pid_lock>
    80001240:	2781                	sext.w	a5,a5
    80001242:	079e                	slli	a5,a5,0x7
    80001244:	97ca                	add	a5,a5,s2
    80001246:	0ac7a983          	lw	s3,172(a5)
    8000124a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000124c:	2781                	sext.w	a5,a5
    8000124e:	079e                	slli	a5,a5,0x7
    80001250:	00006597          	auipc	a1,0x6
    80001254:	70858593          	addi	a1,a1,1800 # 80007958 <cpus+0x8>
    80001258:	95be                	add	a1,a1,a5
    8000125a:	06048513          	addi	a0,s1,96
    8000125e:	50c000ef          	jal	ra,8000176a <swtch>
    80001262:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001264:	2781                	sext.w	a5,a5
    80001266:	079e                	slli	a5,a5,0x7
    80001268:	97ca                	add	a5,a5,s2
    8000126a:	0b37a623          	sw	s3,172(a5)
}
    8000126e:	70a2                	ld	ra,40(sp)
    80001270:	7402                	ld	s0,32(sp)
    80001272:	64e2                	ld	s1,24(sp)
    80001274:	6942                	ld	s2,16(sp)
    80001276:	69a2                	ld	s3,8(sp)
    80001278:	6145                	addi	sp,sp,48
    8000127a:	8082                	ret
    panic("sched p->lock");
    8000127c:	00006517          	auipc	a0,0x6
    80001280:	f5c50513          	addi	a0,a0,-164 # 800071d8 <etext+0x1d8>
    80001284:	7ff030ef          	jal	ra,80005282 <panic>
    panic("sched locks");
    80001288:	00006517          	auipc	a0,0x6
    8000128c:	f6050513          	addi	a0,a0,-160 # 800071e8 <etext+0x1e8>
    80001290:	7f3030ef          	jal	ra,80005282 <panic>
    panic("sched running");
    80001294:	00006517          	auipc	a0,0x6
    80001298:	f6450513          	addi	a0,a0,-156 # 800071f8 <etext+0x1f8>
    8000129c:	7e7030ef          	jal	ra,80005282 <panic>
    panic("sched interruptible");
    800012a0:	00006517          	auipc	a0,0x6
    800012a4:	f6850513          	addi	a0,a0,-152 # 80007208 <etext+0x208>
    800012a8:	7db030ef          	jal	ra,80005282 <panic>

00000000800012ac <yield>:
{
    800012ac:	1101                	addi	sp,sp,-32
    800012ae:	ec06                	sd	ra,24(sp)
    800012b0:	e822                	sd	s0,16(sp)
    800012b2:	e426                	sd	s1,8(sp)
    800012b4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800012b6:	a5bff0ef          	jal	ra,80000d10 <myproc>
    800012ba:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800012bc:	2e2040ef          	jal	ra,8000559e <acquire>
  p->state = RUNNABLE;
    800012c0:	478d                	li	a5,3
    800012c2:	cc9c                	sw	a5,24(s1)
  sched();
    800012c4:	f2fff0ef          	jal	ra,800011f2 <sched>
  release(&p->lock);
    800012c8:	8526                	mv	a0,s1
    800012ca:	36c040ef          	jal	ra,80005636 <release>
}
    800012ce:	60e2                	ld	ra,24(sp)
    800012d0:	6442                	ld	s0,16(sp)
    800012d2:	64a2                	ld	s1,8(sp)
    800012d4:	6105                	addi	sp,sp,32
    800012d6:	8082                	ret

00000000800012d8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800012d8:	7179                	addi	sp,sp,-48
    800012da:	f406                	sd	ra,40(sp)
    800012dc:	f022                	sd	s0,32(sp)
    800012de:	ec26                	sd	s1,24(sp)
    800012e0:	e84a                	sd	s2,16(sp)
    800012e2:	e44e                	sd	s3,8(sp)
    800012e4:	1800                	addi	s0,sp,48
    800012e6:	89aa                	mv	s3,a0
    800012e8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800012ea:	a27ff0ef          	jal	ra,80000d10 <myproc>
    800012ee:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800012f0:	2ae040ef          	jal	ra,8000559e <acquire>
  release(lk);
    800012f4:	854a                	mv	a0,s2
    800012f6:	340040ef          	jal	ra,80005636 <release>

  // Go to sleep.
  p->chan = chan;
    800012fa:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800012fe:	4789                	li	a5,2
    80001300:	cc9c                	sw	a5,24(s1)

  sched();
    80001302:	ef1ff0ef          	jal	ra,800011f2 <sched>

  // Tidy up.
  p->chan = 0;
    80001306:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000130a:	8526                	mv	a0,s1
    8000130c:	32a040ef          	jal	ra,80005636 <release>
  acquire(lk);
    80001310:	854a                	mv	a0,s2
    80001312:	28c040ef          	jal	ra,8000559e <acquire>
}
    80001316:	70a2                	ld	ra,40(sp)
    80001318:	7402                	ld	s0,32(sp)
    8000131a:	64e2                	ld	s1,24(sp)
    8000131c:	6942                	ld	s2,16(sp)
    8000131e:	69a2                	ld	s3,8(sp)
    80001320:	6145                	addi	sp,sp,48
    80001322:	8082                	ret

0000000080001324 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001324:	7139                	addi	sp,sp,-64
    80001326:	fc06                	sd	ra,56(sp)
    80001328:	f822                	sd	s0,48(sp)
    8000132a:	f426                	sd	s1,40(sp)
    8000132c:	f04a                	sd	s2,32(sp)
    8000132e:	ec4e                	sd	s3,24(sp)
    80001330:	e852                	sd	s4,16(sp)
    80001332:	e456                	sd	s5,8(sp)
    80001334:	0080                	addi	s0,sp,64
    80001336:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001338:	00007497          	auipc	s1,0x7
    8000133c:	a1848493          	addi	s1,s1,-1512 # 80007d50 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001340:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001342:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001344:	0000c917          	auipc	s2,0xc
    80001348:	40c90913          	addi	s2,s2,1036 # 8000d750 <tickslock>
    8000134c:	a811                	j	80001360 <wakeup+0x3c>
        p->state = RUNNABLE;
    8000134e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001352:	8526                	mv	a0,s1
    80001354:	2e2040ef          	jal	ra,80005636 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001358:	16848493          	addi	s1,s1,360
    8000135c:	03248063          	beq	s1,s2,8000137c <wakeup+0x58>
    if(p != myproc()){
    80001360:	9b1ff0ef          	jal	ra,80000d10 <myproc>
    80001364:	fea48ae3          	beq	s1,a0,80001358 <wakeup+0x34>
      acquire(&p->lock);
    80001368:	8526                	mv	a0,s1
    8000136a:	234040ef          	jal	ra,8000559e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000136e:	4c9c                	lw	a5,24(s1)
    80001370:	ff3791e3          	bne	a5,s3,80001352 <wakeup+0x2e>
    80001374:	709c                	ld	a5,32(s1)
    80001376:	fd479ee3          	bne	a5,s4,80001352 <wakeup+0x2e>
    8000137a:	bfd1                	j	8000134e <wakeup+0x2a>
    }
  }
}
    8000137c:	70e2                	ld	ra,56(sp)
    8000137e:	7442                	ld	s0,48(sp)
    80001380:	74a2                	ld	s1,40(sp)
    80001382:	7902                	ld	s2,32(sp)
    80001384:	69e2                	ld	s3,24(sp)
    80001386:	6a42                	ld	s4,16(sp)
    80001388:	6aa2                	ld	s5,8(sp)
    8000138a:	6121                	addi	sp,sp,64
    8000138c:	8082                	ret

000000008000138e <reparent>:
{
    8000138e:	7179                	addi	sp,sp,-48
    80001390:	f406                	sd	ra,40(sp)
    80001392:	f022                	sd	s0,32(sp)
    80001394:	ec26                	sd	s1,24(sp)
    80001396:	e84a                	sd	s2,16(sp)
    80001398:	e44e                	sd	s3,8(sp)
    8000139a:	e052                	sd	s4,0(sp)
    8000139c:	1800                	addi	s0,sp,48
    8000139e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013a0:	00007497          	auipc	s1,0x7
    800013a4:	9b048493          	addi	s1,s1,-1616 # 80007d50 <proc>
      pp->parent = initproc;
    800013a8:	00006a17          	auipc	s4,0x6
    800013ac:	538a0a13          	addi	s4,s4,1336 # 800078e0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013b0:	0000c997          	auipc	s3,0xc
    800013b4:	3a098993          	addi	s3,s3,928 # 8000d750 <tickslock>
    800013b8:	a029                	j	800013c2 <reparent+0x34>
    800013ba:	16848493          	addi	s1,s1,360
    800013be:	01348b63          	beq	s1,s3,800013d4 <reparent+0x46>
    if(pp->parent == p){
    800013c2:	7c9c                	ld	a5,56(s1)
    800013c4:	ff279be3          	bne	a5,s2,800013ba <reparent+0x2c>
      pp->parent = initproc;
    800013c8:	000a3503          	ld	a0,0(s4)
    800013cc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800013ce:	f57ff0ef          	jal	ra,80001324 <wakeup>
    800013d2:	b7e5                	j	800013ba <reparent+0x2c>
}
    800013d4:	70a2                	ld	ra,40(sp)
    800013d6:	7402                	ld	s0,32(sp)
    800013d8:	64e2                	ld	s1,24(sp)
    800013da:	6942                	ld	s2,16(sp)
    800013dc:	69a2                	ld	s3,8(sp)
    800013de:	6a02                	ld	s4,0(sp)
    800013e0:	6145                	addi	sp,sp,48
    800013e2:	8082                	ret

00000000800013e4 <exit>:
{
    800013e4:	7179                	addi	sp,sp,-48
    800013e6:	f406                	sd	ra,40(sp)
    800013e8:	f022                	sd	s0,32(sp)
    800013ea:	ec26                	sd	s1,24(sp)
    800013ec:	e84a                	sd	s2,16(sp)
    800013ee:	e44e                	sd	s3,8(sp)
    800013f0:	e052                	sd	s4,0(sp)
    800013f2:	1800                	addi	s0,sp,48
    800013f4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800013f6:	91bff0ef          	jal	ra,80000d10 <myproc>
    800013fa:	89aa                	mv	s3,a0
  if(p == initproc)
    800013fc:	00006797          	auipc	a5,0x6
    80001400:	4e47b783          	ld	a5,1252(a5) # 800078e0 <initproc>
    80001404:	0d050493          	addi	s1,a0,208
    80001408:	15050913          	addi	s2,a0,336
    8000140c:	00a79f63          	bne	a5,a0,8000142a <exit+0x46>
    panic("init exiting");
    80001410:	00006517          	auipc	a0,0x6
    80001414:	e1050513          	addi	a0,a0,-496 # 80007220 <etext+0x220>
    80001418:	66b030ef          	jal	ra,80005282 <panic>
      fileclose(f);
    8000141c:	651010ef          	jal	ra,8000326c <fileclose>
      p->ofile[fd] = 0;
    80001420:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001424:	04a1                	addi	s1,s1,8
    80001426:	01248563          	beq	s1,s2,80001430 <exit+0x4c>
    if(p->ofile[fd]){
    8000142a:	6088                	ld	a0,0(s1)
    8000142c:	f965                	bnez	a0,8000141c <exit+0x38>
    8000142e:	bfdd                	j	80001424 <exit+0x40>
  begin_op();
    80001430:	221010ef          	jal	ra,80002e50 <begin_op>
  iput(p->cwd);
    80001434:	1509b503          	ld	a0,336(s3)
    80001438:	30c010ef          	jal	ra,80002744 <iput>
  end_op();
    8000143c:	285010ef          	jal	ra,80002ec0 <end_op>
  p->cwd = 0;
    80001440:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001444:	00006497          	auipc	s1,0x6
    80001448:	4f448493          	addi	s1,s1,1268 # 80007938 <wait_lock>
    8000144c:	8526                	mv	a0,s1
    8000144e:	150040ef          	jal	ra,8000559e <acquire>
  reparent(p);
    80001452:	854e                	mv	a0,s3
    80001454:	f3bff0ef          	jal	ra,8000138e <reparent>
  wakeup(p->parent);
    80001458:	0389b503          	ld	a0,56(s3)
    8000145c:	ec9ff0ef          	jal	ra,80001324 <wakeup>
  acquire(&p->lock);
    80001460:	854e                	mv	a0,s3
    80001462:	13c040ef          	jal	ra,8000559e <acquire>
  p->xstate = status;
    80001466:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000146a:	4795                	li	a5,5
    8000146c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001470:	8526                	mv	a0,s1
    80001472:	1c4040ef          	jal	ra,80005636 <release>
  sched();
    80001476:	d7dff0ef          	jal	ra,800011f2 <sched>
  panic("zombie exit");
    8000147a:	00006517          	auipc	a0,0x6
    8000147e:	db650513          	addi	a0,a0,-586 # 80007230 <etext+0x230>
    80001482:	601030ef          	jal	ra,80005282 <panic>

0000000080001486 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001486:	7179                	addi	sp,sp,-48
    80001488:	f406                	sd	ra,40(sp)
    8000148a:	f022                	sd	s0,32(sp)
    8000148c:	ec26                	sd	s1,24(sp)
    8000148e:	e84a                	sd	s2,16(sp)
    80001490:	e44e                	sd	s3,8(sp)
    80001492:	1800                	addi	s0,sp,48
    80001494:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001496:	00007497          	auipc	s1,0x7
    8000149a:	8ba48493          	addi	s1,s1,-1862 # 80007d50 <proc>
    8000149e:	0000c997          	auipc	s3,0xc
    800014a2:	2b298993          	addi	s3,s3,690 # 8000d750 <tickslock>
    acquire(&p->lock);
    800014a6:	8526                	mv	a0,s1
    800014a8:	0f6040ef          	jal	ra,8000559e <acquire>
    if(p->pid == pid){
    800014ac:	589c                	lw	a5,48(s1)
    800014ae:	01278b63          	beq	a5,s2,800014c4 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800014b2:	8526                	mv	a0,s1
    800014b4:	182040ef          	jal	ra,80005636 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800014b8:	16848493          	addi	s1,s1,360
    800014bc:	ff3495e3          	bne	s1,s3,800014a6 <kill+0x20>
  }
  return -1;
    800014c0:	557d                	li	a0,-1
    800014c2:	a819                	j	800014d8 <kill+0x52>
      p->killed = 1;
    800014c4:	4785                	li	a5,1
    800014c6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800014c8:	4c98                	lw	a4,24(s1)
    800014ca:	4789                	li	a5,2
    800014cc:	00f70d63          	beq	a4,a5,800014e6 <kill+0x60>
      release(&p->lock);
    800014d0:	8526                	mv	a0,s1
    800014d2:	164040ef          	jal	ra,80005636 <release>
      return 0;
    800014d6:	4501                	li	a0,0
}
    800014d8:	70a2                	ld	ra,40(sp)
    800014da:	7402                	ld	s0,32(sp)
    800014dc:	64e2                	ld	s1,24(sp)
    800014de:	6942                	ld	s2,16(sp)
    800014e0:	69a2                	ld	s3,8(sp)
    800014e2:	6145                	addi	sp,sp,48
    800014e4:	8082                	ret
        p->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	cc9c                	sw	a5,24(s1)
    800014ea:	b7dd                	j	800014d0 <kill+0x4a>

00000000800014ec <setkilled>:

void
setkilled(struct proc *p)
{
    800014ec:	1101                	addi	sp,sp,-32
    800014ee:	ec06                	sd	ra,24(sp)
    800014f0:	e822                	sd	s0,16(sp)
    800014f2:	e426                	sd	s1,8(sp)
    800014f4:	1000                	addi	s0,sp,32
    800014f6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014f8:	0a6040ef          	jal	ra,8000559e <acquire>
  p->killed = 1;
    800014fc:	4785                	li	a5,1
    800014fe:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001500:	8526                	mv	a0,s1
    80001502:	134040ef          	jal	ra,80005636 <release>
}
    80001506:	60e2                	ld	ra,24(sp)
    80001508:	6442                	ld	s0,16(sp)
    8000150a:	64a2                	ld	s1,8(sp)
    8000150c:	6105                	addi	sp,sp,32
    8000150e:	8082                	ret

0000000080001510 <killed>:

int
killed(struct proc *p)
{
    80001510:	1101                	addi	sp,sp,-32
    80001512:	ec06                	sd	ra,24(sp)
    80001514:	e822                	sd	s0,16(sp)
    80001516:	e426                	sd	s1,8(sp)
    80001518:	e04a                	sd	s2,0(sp)
    8000151a:	1000                	addi	s0,sp,32
    8000151c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000151e:	080040ef          	jal	ra,8000559e <acquire>
  k = p->killed;
    80001522:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	10e040ef          	jal	ra,80005636 <release>
  return k;
}
    8000152c:	854a                	mv	a0,s2
    8000152e:	60e2                	ld	ra,24(sp)
    80001530:	6442                	ld	s0,16(sp)
    80001532:	64a2                	ld	s1,8(sp)
    80001534:	6902                	ld	s2,0(sp)
    80001536:	6105                	addi	sp,sp,32
    80001538:	8082                	ret

000000008000153a <wait>:
{
    8000153a:	715d                	addi	sp,sp,-80
    8000153c:	e486                	sd	ra,72(sp)
    8000153e:	e0a2                	sd	s0,64(sp)
    80001540:	fc26                	sd	s1,56(sp)
    80001542:	f84a                	sd	s2,48(sp)
    80001544:	f44e                	sd	s3,40(sp)
    80001546:	f052                	sd	s4,32(sp)
    80001548:	ec56                	sd	s5,24(sp)
    8000154a:	e85a                	sd	s6,16(sp)
    8000154c:	e45e                	sd	s7,8(sp)
    8000154e:	e062                	sd	s8,0(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001554:	fbcff0ef          	jal	ra,80000d10 <myproc>
    80001558:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000155a:	00006517          	auipc	a0,0x6
    8000155e:	3de50513          	addi	a0,a0,990 # 80007938 <wait_lock>
    80001562:	03c040ef          	jal	ra,8000559e <acquire>
    havekids = 0;
    80001566:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001568:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000156a:	0000c997          	auipc	s3,0xc
    8000156e:	1e698993          	addi	s3,s3,486 # 8000d750 <tickslock>
        havekids = 1;
    80001572:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001574:	00006c17          	auipc	s8,0x6
    80001578:	3c4c0c13          	addi	s8,s8,964 # 80007938 <wait_lock>
    havekids = 0;
    8000157c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000157e:	00006497          	auipc	s1,0x6
    80001582:	7d248493          	addi	s1,s1,2002 # 80007d50 <proc>
    80001586:	a899                	j	800015dc <wait+0xa2>
          pid = pp->pid;
    80001588:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000158c:	000b0c63          	beqz	s6,800015a4 <wait+0x6a>
    80001590:	4691                	li	a3,4
    80001592:	02c48613          	addi	a2,s1,44
    80001596:	85da                	mv	a1,s6
    80001598:	05093503          	ld	a0,80(s2)
    8000159c:	c2aff0ef          	jal	ra,800009c6 <copyout>
    800015a0:	00054f63          	bltz	a0,800015be <wait+0x84>
          freeproc(pp);
    800015a4:	8526                	mv	a0,s1
    800015a6:	8ddff0ef          	jal	ra,80000e82 <freeproc>
          release(&pp->lock);
    800015aa:	8526                	mv	a0,s1
    800015ac:	08a040ef          	jal	ra,80005636 <release>
          release(&wait_lock);
    800015b0:	00006517          	auipc	a0,0x6
    800015b4:	38850513          	addi	a0,a0,904 # 80007938 <wait_lock>
    800015b8:	07e040ef          	jal	ra,80005636 <release>
          return pid;
    800015bc:	a891                	j	80001610 <wait+0xd6>
            release(&pp->lock);
    800015be:	8526                	mv	a0,s1
    800015c0:	076040ef          	jal	ra,80005636 <release>
            release(&wait_lock);
    800015c4:	00006517          	auipc	a0,0x6
    800015c8:	37450513          	addi	a0,a0,884 # 80007938 <wait_lock>
    800015cc:	06a040ef          	jal	ra,80005636 <release>
            return -1;
    800015d0:	59fd                	li	s3,-1
    800015d2:	a83d                	j	80001610 <wait+0xd6>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015d4:	16848493          	addi	s1,s1,360
    800015d8:	03348063          	beq	s1,s3,800015f8 <wait+0xbe>
      if(pp->parent == p){
    800015dc:	7c9c                	ld	a5,56(s1)
    800015de:	ff279be3          	bne	a5,s2,800015d4 <wait+0x9a>
        acquire(&pp->lock);
    800015e2:	8526                	mv	a0,s1
    800015e4:	7bb030ef          	jal	ra,8000559e <acquire>
        if(pp->state == ZOMBIE){
    800015e8:	4c9c                	lw	a5,24(s1)
    800015ea:	f9478fe3          	beq	a5,s4,80001588 <wait+0x4e>
        release(&pp->lock);
    800015ee:	8526                	mv	a0,s1
    800015f0:	046040ef          	jal	ra,80005636 <release>
        havekids = 1;
    800015f4:	8756                	mv	a4,s5
    800015f6:	bff9                	j	800015d4 <wait+0x9a>
    if(!havekids || killed(p)){
    800015f8:	c709                	beqz	a4,80001602 <wait+0xc8>
    800015fa:	854a                	mv	a0,s2
    800015fc:	f15ff0ef          	jal	ra,80001510 <killed>
    80001600:	c50d                	beqz	a0,8000162a <wait+0xf0>
      release(&wait_lock);
    80001602:	00006517          	auipc	a0,0x6
    80001606:	33650513          	addi	a0,a0,822 # 80007938 <wait_lock>
    8000160a:	02c040ef          	jal	ra,80005636 <release>
      return -1;
    8000160e:	59fd                	li	s3,-1
}
    80001610:	854e                	mv	a0,s3
    80001612:	60a6                	ld	ra,72(sp)
    80001614:	6406                	ld	s0,64(sp)
    80001616:	74e2                	ld	s1,56(sp)
    80001618:	7942                	ld	s2,48(sp)
    8000161a:	79a2                	ld	s3,40(sp)
    8000161c:	7a02                	ld	s4,32(sp)
    8000161e:	6ae2                	ld	s5,24(sp)
    80001620:	6b42                	ld	s6,16(sp)
    80001622:	6ba2                	ld	s7,8(sp)
    80001624:	6c02                	ld	s8,0(sp)
    80001626:	6161                	addi	sp,sp,80
    80001628:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000162a:	85e2                	mv	a1,s8
    8000162c:	854a                	mv	a0,s2
    8000162e:	cabff0ef          	jal	ra,800012d8 <sleep>
    havekids = 0;
    80001632:	b7a9                	j	8000157c <wait+0x42>

0000000080001634 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001634:	7179                	addi	sp,sp,-48
    80001636:	f406                	sd	ra,40(sp)
    80001638:	f022                	sd	s0,32(sp)
    8000163a:	ec26                	sd	s1,24(sp)
    8000163c:	e84a                	sd	s2,16(sp)
    8000163e:	e44e                	sd	s3,8(sp)
    80001640:	e052                	sd	s4,0(sp)
    80001642:	1800                	addi	s0,sp,48
    80001644:	84aa                	mv	s1,a0
    80001646:	892e                	mv	s2,a1
    80001648:	89b2                	mv	s3,a2
    8000164a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000164c:	ec4ff0ef          	jal	ra,80000d10 <myproc>
  if(user_dst){
    80001650:	cc99                	beqz	s1,8000166e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001652:	86d2                	mv	a3,s4
    80001654:	864e                	mv	a2,s3
    80001656:	85ca                	mv	a1,s2
    80001658:	6928                	ld	a0,80(a0)
    8000165a:	b6cff0ef          	jal	ra,800009c6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000165e:	70a2                	ld	ra,40(sp)
    80001660:	7402                	ld	s0,32(sp)
    80001662:	64e2                	ld	s1,24(sp)
    80001664:	6942                	ld	s2,16(sp)
    80001666:	69a2                	ld	s3,8(sp)
    80001668:	6a02                	ld	s4,0(sp)
    8000166a:	6145                	addi	sp,sp,48
    8000166c:	8082                	ret
    memmove((char *)dst, src, len);
    8000166e:	000a061b          	sext.w	a2,s4
    80001672:	85ce                	mv	a1,s3
    80001674:	854a                	mv	a0,s2
    80001676:	b37fe0ef          	jal	ra,800001ac <memmove>
    return 0;
    8000167a:	8526                	mv	a0,s1
    8000167c:	b7cd                	j	8000165e <either_copyout+0x2a>

000000008000167e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000167e:	7179                	addi	sp,sp,-48
    80001680:	f406                	sd	ra,40(sp)
    80001682:	f022                	sd	s0,32(sp)
    80001684:	ec26                	sd	s1,24(sp)
    80001686:	e84a                	sd	s2,16(sp)
    80001688:	e44e                	sd	s3,8(sp)
    8000168a:	e052                	sd	s4,0(sp)
    8000168c:	1800                	addi	s0,sp,48
    8000168e:	892a                	mv	s2,a0
    80001690:	84ae                	mv	s1,a1
    80001692:	89b2                	mv	s3,a2
    80001694:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001696:	e7aff0ef          	jal	ra,80000d10 <myproc>
  if(user_src){
    8000169a:	cc99                	beqz	s1,800016b8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000169c:	86d2                	mv	a3,s4
    8000169e:	864e                	mv	a2,s3
    800016a0:	85ca                	mv	a1,s2
    800016a2:	6928                	ld	a0,80(a0)
    800016a4:	bdaff0ef          	jal	ra,80000a7e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016a8:	70a2                	ld	ra,40(sp)
    800016aa:	7402                	ld	s0,32(sp)
    800016ac:	64e2                	ld	s1,24(sp)
    800016ae:	6942                	ld	s2,16(sp)
    800016b0:	69a2                	ld	s3,8(sp)
    800016b2:	6a02                	ld	s4,0(sp)
    800016b4:	6145                	addi	sp,sp,48
    800016b6:	8082                	ret
    memmove(dst, (char*)src, len);
    800016b8:	000a061b          	sext.w	a2,s4
    800016bc:	85ce                	mv	a1,s3
    800016be:	854a                	mv	a0,s2
    800016c0:	aedfe0ef          	jal	ra,800001ac <memmove>
    return 0;
    800016c4:	8526                	mv	a0,s1
    800016c6:	b7cd                	j	800016a8 <either_copyin+0x2a>

00000000800016c8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800016c8:	715d                	addi	sp,sp,-80
    800016ca:	e486                	sd	ra,72(sp)
    800016cc:	e0a2                	sd	s0,64(sp)
    800016ce:	fc26                	sd	s1,56(sp)
    800016d0:	f84a                	sd	s2,48(sp)
    800016d2:	f44e                	sd	s3,40(sp)
    800016d4:	f052                	sd	s4,32(sp)
    800016d6:	ec56                	sd	s5,24(sp)
    800016d8:	e85a                	sd	s6,16(sp)
    800016da:	e45e                	sd	s7,8(sp)
    800016dc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800016de:	00006517          	auipc	a0,0x6
    800016e2:	96a50513          	addi	a0,a0,-1686 # 80007048 <etext+0x48>
    800016e6:	0e9030ef          	jal	ra,80004fce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800016ea:	00006497          	auipc	s1,0x6
    800016ee:	7be48493          	addi	s1,s1,1982 # 80007ea8 <proc+0x158>
    800016f2:	0000c917          	auipc	s2,0xc
    800016f6:	1b690913          	addi	s2,s2,438 # 8000d8a8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800016fa:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800016fc:	00006997          	auipc	s3,0x6
    80001700:	b4498993          	addi	s3,s3,-1212 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001704:	00006a97          	auipc	s5,0x6
    80001708:	b44a8a93          	addi	s5,s5,-1212 # 80007248 <etext+0x248>
    printf("\n");
    8000170c:	00006a17          	auipc	s4,0x6
    80001710:	93ca0a13          	addi	s4,s4,-1732 # 80007048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001714:	00006b97          	auipc	s7,0x6
    80001718:	b74b8b93          	addi	s7,s7,-1164 # 80007288 <states.2239>
    8000171c:	a829                	j	80001736 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000171e:	ed86a583          	lw	a1,-296(a3)
    80001722:	8556                	mv	a0,s5
    80001724:	0ab030ef          	jal	ra,80004fce <printf>
    printf("\n");
    80001728:	8552                	mv	a0,s4
    8000172a:	0a5030ef          	jal	ra,80004fce <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000172e:	16848493          	addi	s1,s1,360
    80001732:	03248163          	beq	s1,s2,80001754 <procdump+0x8c>
    if(p->state == UNUSED)
    80001736:	86a6                	mv	a3,s1
    80001738:	ec04a783          	lw	a5,-320(s1)
    8000173c:	dbed                	beqz	a5,8000172e <procdump+0x66>
      state = "???";
    8000173e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001740:	fcfb6fe3          	bltu	s6,a5,8000171e <procdump+0x56>
    80001744:	1782                	slli	a5,a5,0x20
    80001746:	9381                	srli	a5,a5,0x20
    80001748:	078e                	slli	a5,a5,0x3
    8000174a:	97de                	add	a5,a5,s7
    8000174c:	6390                	ld	a2,0(a5)
    8000174e:	fa61                	bnez	a2,8000171e <procdump+0x56>
      state = "???";
    80001750:	864e                	mv	a2,s3
    80001752:	b7f1                	j	8000171e <procdump+0x56>
  }
}
    80001754:	60a6                	ld	ra,72(sp)
    80001756:	6406                	ld	s0,64(sp)
    80001758:	74e2                	ld	s1,56(sp)
    8000175a:	7942                	ld	s2,48(sp)
    8000175c:	79a2                	ld	s3,40(sp)
    8000175e:	7a02                	ld	s4,32(sp)
    80001760:	6ae2                	ld	s5,24(sp)
    80001762:	6b42                	ld	s6,16(sp)
    80001764:	6ba2                	ld	s7,8(sp)
    80001766:	6161                	addi	sp,sp,80
    80001768:	8082                	ret

000000008000176a <swtch>:
    8000176a:	00153023          	sd	ra,0(a0)
    8000176e:	00253423          	sd	sp,8(a0)
    80001772:	e900                	sd	s0,16(a0)
    80001774:	ed04                	sd	s1,24(a0)
    80001776:	03253023          	sd	s2,32(a0)
    8000177a:	03353423          	sd	s3,40(a0)
    8000177e:	03453823          	sd	s4,48(a0)
    80001782:	03553c23          	sd	s5,56(a0)
    80001786:	05653023          	sd	s6,64(a0)
    8000178a:	05753423          	sd	s7,72(a0)
    8000178e:	05853823          	sd	s8,80(a0)
    80001792:	05953c23          	sd	s9,88(a0)
    80001796:	07a53023          	sd	s10,96(a0)
    8000179a:	07b53423          	sd	s11,104(a0)
    8000179e:	0005b083          	ld	ra,0(a1)
    800017a2:	0085b103          	ld	sp,8(a1)
    800017a6:	6980                	ld	s0,16(a1)
    800017a8:	6d84                	ld	s1,24(a1)
    800017aa:	0205b903          	ld	s2,32(a1)
    800017ae:	0285b983          	ld	s3,40(a1)
    800017b2:	0305ba03          	ld	s4,48(a1)
    800017b6:	0385ba83          	ld	s5,56(a1)
    800017ba:	0405bb03          	ld	s6,64(a1)
    800017be:	0485bb83          	ld	s7,72(a1)
    800017c2:	0505bc03          	ld	s8,80(a1)
    800017c6:	0585bc83          	ld	s9,88(a1)
    800017ca:	0605bd03          	ld	s10,96(a1)
    800017ce:	0685bd83          	ld	s11,104(a1)
    800017d2:	8082                	ret

00000000800017d4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800017d4:	1141                	addi	sp,sp,-16
    800017d6:	e406                	sd	ra,8(sp)
    800017d8:	e022                	sd	s0,0(sp)
    800017da:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800017dc:	00006597          	auipc	a1,0x6
    800017e0:	adc58593          	addi	a1,a1,-1316 # 800072b8 <states.2239+0x30>
    800017e4:	0000c517          	auipc	a0,0xc
    800017e8:	f6c50513          	addi	a0,a0,-148 # 8000d750 <tickslock>
    800017ec:	533030ef          	jal	ra,8000551e <initlock>
}
    800017f0:	60a2                	ld	ra,8(sp)
    800017f2:	6402                	ld	s0,0(sp)
    800017f4:	0141                	addi	sp,sp,16
    800017f6:	8082                	ret

00000000800017f8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800017f8:	1141                	addi	sp,sp,-16
    800017fa:	e422                	sd	s0,8(sp)
    800017fc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800017fe:	00003797          	auipc	a5,0x3
    80001802:	d1278793          	addi	a5,a5,-750 # 80004510 <kernelvec>
    80001806:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000180a:	6422                	ld	s0,8(sp)
    8000180c:	0141                	addi	sp,sp,16
    8000180e:	8082                	ret

0000000080001810 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001810:	1141                	addi	sp,sp,-16
    80001812:	e406                	sd	ra,8(sp)
    80001814:	e022                	sd	s0,0(sp)
    80001816:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001818:	cf8ff0ef          	jal	ra,80000d10 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000181c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001820:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001822:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001826:	00004617          	auipc	a2,0x4
    8000182a:	7da60613          	addi	a2,a2,2010 # 80006000 <_trampoline>
    8000182e:	00004697          	auipc	a3,0x4
    80001832:	7d268693          	addi	a3,a3,2002 # 80006000 <_trampoline>
    80001836:	8e91                	sub	a3,a3,a2
    80001838:	040007b7          	lui	a5,0x4000
    8000183c:	17fd                	addi	a5,a5,-1
    8000183e:	07b2                	slli	a5,a5,0xc
    80001840:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001842:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001846:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001848:	180026f3          	csrr	a3,satp
    8000184c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000184e:	6d38                	ld	a4,88(a0)
    80001850:	6134                	ld	a3,64(a0)
    80001852:	6585                	lui	a1,0x1
    80001854:	96ae                	add	a3,a3,a1
    80001856:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001858:	6d38                	ld	a4,88(a0)
    8000185a:	00000697          	auipc	a3,0x0
    8000185e:	10c68693          	addi	a3,a3,268 # 80001966 <usertrap>
    80001862:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001864:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001866:	8692                	mv	a3,tp
    80001868:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000186a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000186e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001872:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001876:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000187a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000187c:	6f18                	ld	a4,24(a4)
    8000187e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001882:	6928                	ld	a0,80(a0)
    80001884:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001886:	00005717          	auipc	a4,0x5
    8000188a:	81670713          	addi	a4,a4,-2026 # 8000609c <userret>
    8000188e:	8f11                	sub	a4,a4,a2
    80001890:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001892:	577d                	li	a4,-1
    80001894:	177e                	slli	a4,a4,0x3f
    80001896:	8d59                	or	a0,a0,a4
    80001898:	9782                	jalr	a5
}
    8000189a:	60a2                	ld	ra,8(sp)
    8000189c:	6402                	ld	s0,0(sp)
    8000189e:	0141                	addi	sp,sp,16
    800018a0:	8082                	ret

00000000800018a2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018a2:	1101                	addi	sp,sp,-32
    800018a4:	ec06                	sd	ra,24(sp)
    800018a6:	e822                	sd	s0,16(sp)
    800018a8:	e426                	sd	s1,8(sp)
    800018aa:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018ac:	c38ff0ef          	jal	ra,80000ce4 <cpuid>
    800018b0:	cd19                	beqz	a0,800018ce <clockintr+0x2c>
  asm volatile("csrr %0, time" : "=r" (x) );
    800018b2:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800018b6:	000f4737          	lui	a4,0xf4
    800018ba:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800018be:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800018c0:	14d79073          	csrw	0x14d,a5
}
    800018c4:	60e2                	ld	ra,24(sp)
    800018c6:	6442                	ld	s0,16(sp)
    800018c8:	64a2                	ld	s1,8(sp)
    800018ca:	6105                	addi	sp,sp,32
    800018cc:	8082                	ret
    acquire(&tickslock);
    800018ce:	0000c497          	auipc	s1,0xc
    800018d2:	e8248493          	addi	s1,s1,-382 # 8000d750 <tickslock>
    800018d6:	8526                	mv	a0,s1
    800018d8:	4c7030ef          	jal	ra,8000559e <acquire>
    ticks++;
    800018dc:	00006517          	auipc	a0,0x6
    800018e0:	00c50513          	addi	a0,a0,12 # 800078e8 <ticks>
    800018e4:	411c                	lw	a5,0(a0)
    800018e6:	2785                	addiw	a5,a5,1
    800018e8:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800018ea:	a3bff0ef          	jal	ra,80001324 <wakeup>
    release(&tickslock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	547030ef          	jal	ra,80005636 <release>
    800018f4:	bf7d                	j	800018b2 <clockintr+0x10>

00000000800018f6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800018f6:	1101                	addi	sp,sp,-32
    800018f8:	ec06                	sd	ra,24(sp)
    800018fa:	e822                	sd	s0,16(sp)
    800018fc:	e426                	sd	s1,8(sp)
    800018fe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001900:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001904:	57fd                	li	a5,-1
    80001906:	17fe                	slli	a5,a5,0x3f
    80001908:	07a5                	addi	a5,a5,9
    8000190a:	00f70d63          	beq	a4,a5,80001924 <devintr+0x2e>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000190e:	57fd                	li	a5,-1
    80001910:	17fe                	slli	a5,a5,0x3f
    80001912:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001914:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001916:	04f70463          	beq	a4,a5,8000195e <devintr+0x68>
  }
}
    8000191a:	60e2                	ld	ra,24(sp)
    8000191c:	6442                	ld	s0,16(sp)
    8000191e:	64a2                	ld	s1,8(sp)
    80001920:	6105                	addi	sp,sp,32
    80001922:	8082                	ret
    int irq = plic_claim();
    80001924:	495020ef          	jal	ra,800045b8 <plic_claim>
    80001928:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000192a:	47a9                	li	a5,10
    8000192c:	02f50363          	beq	a0,a5,80001952 <devintr+0x5c>
    } else if(irq == VIRTIO0_IRQ){
    80001930:	4785                	li	a5,1
    80001932:	02f50363          	beq	a0,a5,80001958 <devintr+0x62>
    return 1;
    80001936:	4505                	li	a0,1
    } else if(irq){
    80001938:	d0ed                	beqz	s1,8000191a <devintr+0x24>
      printf("unexpected interrupt irq=%d\n", irq);
    8000193a:	85a6                	mv	a1,s1
    8000193c:	00006517          	auipc	a0,0x6
    80001940:	98450513          	addi	a0,a0,-1660 # 800072c0 <states.2239+0x38>
    80001944:	68a030ef          	jal	ra,80004fce <printf>
      plic_complete(irq);
    80001948:	8526                	mv	a0,s1
    8000194a:	48f020ef          	jal	ra,800045d8 <plic_complete>
    return 1;
    8000194e:	4505                	li	a0,1
    80001950:	b7e9                	j	8000191a <devintr+0x24>
      uartintr();
    80001952:	391030ef          	jal	ra,800054e2 <uartintr>
    80001956:	bfcd                	j	80001948 <devintr+0x52>
      virtio_disk_intr();
    80001958:	146030ef          	jal	ra,80004a9e <virtio_disk_intr>
    8000195c:	b7f5                	j	80001948 <devintr+0x52>
    clockintr();
    8000195e:	f45ff0ef          	jal	ra,800018a2 <clockintr>
    return 2;
    80001962:	4509                	li	a0,2
    80001964:	bf5d                	j	8000191a <devintr+0x24>

0000000080001966 <usertrap>:
{
    80001966:	1101                	addi	sp,sp,-32
    80001968:	ec06                	sd	ra,24(sp)
    8000196a:	e822                	sd	s0,16(sp)
    8000196c:	e426                	sd	s1,8(sp)
    8000196e:	e04a                	sd	s2,0(sp)
    80001970:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001972:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001976:	1007f793          	andi	a5,a5,256
    8000197a:	ef85                	bnez	a5,800019b2 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000197c:	00003797          	auipc	a5,0x3
    80001980:	b9478793          	addi	a5,a5,-1132 # 80004510 <kernelvec>
    80001984:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001988:	b88ff0ef          	jal	ra,80000d10 <myproc>
    8000198c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000198e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001990:	14102773          	csrr	a4,sepc
    80001994:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001996:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000199a:	47a1                	li	a5,8
    8000199c:	02f70163          	beq	a4,a5,800019be <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019a0:	f57ff0ef          	jal	ra,800018f6 <devintr>
    800019a4:	892a                	mv	s2,a0
    800019a6:	c135                	beqz	a0,80001a0a <usertrap+0xa4>
  if(killed(p))
    800019a8:	8526                	mv	a0,s1
    800019aa:	b67ff0ef          	jal	ra,80001510 <killed>
    800019ae:	cd1d                	beqz	a0,800019ec <usertrap+0x86>
    800019b0:	a81d                	j	800019e6 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800019b2:	00006517          	auipc	a0,0x6
    800019b6:	92e50513          	addi	a0,a0,-1746 # 800072e0 <states.2239+0x58>
    800019ba:	0c9030ef          	jal	ra,80005282 <panic>
    if(killed(p))
    800019be:	b53ff0ef          	jal	ra,80001510 <killed>
    800019c2:	e121                	bnez	a0,80001a02 <usertrap+0x9c>
    p->trapframe->epc += 4;
    800019c4:	6cb8                	ld	a4,88(s1)
    800019c6:	6f1c                	ld	a5,24(a4)
    800019c8:	0791                	addi	a5,a5,4
    800019ca:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019cc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800019d0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019d4:	10079073          	csrw	sstatus,a5
    syscall();
    800019d8:	248000ef          	jal	ra,80001c20 <syscall>
  if(killed(p))
    800019dc:	8526                	mv	a0,s1
    800019de:	b33ff0ef          	jal	ra,80001510 <killed>
    800019e2:	c901                	beqz	a0,800019f2 <usertrap+0x8c>
    800019e4:	4901                	li	s2,0
    exit(-1);
    800019e6:	557d                	li	a0,-1
    800019e8:	9fdff0ef          	jal	ra,800013e4 <exit>
  if(which_dev == 2)
    800019ec:	4789                	li	a5,2
    800019ee:	04f90563          	beq	s2,a5,80001a38 <usertrap+0xd2>
  usertrapret();
    800019f2:	e1fff0ef          	jal	ra,80001810 <usertrapret>
}
    800019f6:	60e2                	ld	ra,24(sp)
    800019f8:	6442                	ld	s0,16(sp)
    800019fa:	64a2                	ld	s1,8(sp)
    800019fc:	6902                	ld	s2,0(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret
      exit(-1);
    80001a02:	557d                	li	a0,-1
    80001a04:	9e1ff0ef          	jal	ra,800013e4 <exit>
    80001a08:	bf75                	j	800019c4 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a0a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a0e:	5890                	lw	a2,48(s1)
    80001a10:	00006517          	auipc	a0,0x6
    80001a14:	8f050513          	addi	a0,a0,-1808 # 80007300 <states.2239+0x78>
    80001a18:	5b6030ef          	jal	ra,80004fce <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a1c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a20:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a24:	00006517          	auipc	a0,0x6
    80001a28:	90c50513          	addi	a0,a0,-1780 # 80007330 <states.2239+0xa8>
    80001a2c:	5a2030ef          	jal	ra,80004fce <printf>
    setkilled(p);
    80001a30:	8526                	mv	a0,s1
    80001a32:	abbff0ef          	jal	ra,800014ec <setkilled>
    80001a36:	b75d                	j	800019dc <usertrap+0x76>
    yield();
    80001a38:	875ff0ef          	jal	ra,800012ac <yield>
    80001a3c:	bf5d                	j	800019f2 <usertrap+0x8c>

0000000080001a3e <kerneltrap>:
{
    80001a3e:	7179                	addi	sp,sp,-48
    80001a40:	f406                	sd	ra,40(sp)
    80001a42:	f022                	sd	s0,32(sp)
    80001a44:	ec26                	sd	s1,24(sp)
    80001a46:	e84a                	sd	s2,16(sp)
    80001a48:	e44e                	sd	s3,8(sp)
    80001a4a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a4c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a50:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a54:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001a58:	1004f793          	andi	a5,s1,256
    80001a5c:	c795                	beqz	a5,80001a88 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a5e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001a62:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001a64:	eb85                	bnez	a5,80001a94 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001a66:	e91ff0ef          	jal	ra,800018f6 <devintr>
    80001a6a:	c91d                	beqz	a0,80001aa0 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001a6c:	4789                	li	a5,2
    80001a6e:	04f50a63          	beq	a0,a5,80001ac2 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001a72:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a76:	10049073          	csrw	sstatus,s1
}
    80001a7a:	70a2                	ld	ra,40(sp)
    80001a7c:	7402                	ld	s0,32(sp)
    80001a7e:	64e2                	ld	s1,24(sp)
    80001a80:	6942                	ld	s2,16(sp)
    80001a82:	69a2                	ld	s3,8(sp)
    80001a84:	6145                	addi	sp,sp,48
    80001a86:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001a88:	00006517          	auipc	a0,0x6
    80001a8c:	8d050513          	addi	a0,a0,-1840 # 80007358 <states.2239+0xd0>
    80001a90:	7f2030ef          	jal	ra,80005282 <panic>
    panic("kerneltrap: interrupts enabled");
    80001a94:	00006517          	auipc	a0,0x6
    80001a98:	8ec50513          	addi	a0,a0,-1812 # 80007380 <states.2239+0xf8>
    80001a9c:	7e6030ef          	jal	ra,80005282 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aa0:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001aa4:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001aa8:	85ce                	mv	a1,s3
    80001aaa:	00006517          	auipc	a0,0x6
    80001aae:	8f650513          	addi	a0,a0,-1802 # 800073a0 <states.2239+0x118>
    80001ab2:	51c030ef          	jal	ra,80004fce <printf>
    panic("kerneltrap");
    80001ab6:	00006517          	auipc	a0,0x6
    80001aba:	91250513          	addi	a0,a0,-1774 # 800073c8 <states.2239+0x140>
    80001abe:	7c4030ef          	jal	ra,80005282 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001ac2:	a4eff0ef          	jal	ra,80000d10 <myproc>
    80001ac6:	d555                	beqz	a0,80001a72 <kerneltrap+0x34>
    yield();
    80001ac8:	fe4ff0ef          	jal	ra,800012ac <yield>
    80001acc:	b75d                	j	80001a72 <kerneltrap+0x34>

0000000080001ace <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ace:	1101                	addi	sp,sp,-32
    80001ad0:	ec06                	sd	ra,24(sp)
    80001ad2:	e822                	sd	s0,16(sp)
    80001ad4:	e426                	sd	s1,8(sp)
    80001ad6:	1000                	addi	s0,sp,32
    80001ad8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ada:	a36ff0ef          	jal	ra,80000d10 <myproc>
  switch (n) {
    80001ade:	4795                	li	a5,5
    80001ae0:	0497e163          	bltu	a5,s1,80001b22 <argraw+0x54>
    80001ae4:	048a                	slli	s1,s1,0x2
    80001ae6:	00006717          	auipc	a4,0x6
    80001aea:	91a70713          	addi	a4,a4,-1766 # 80007400 <states.2239+0x178>
    80001aee:	94ba                	add	s1,s1,a4
    80001af0:	409c                	lw	a5,0(s1)
    80001af2:	97ba                	add	a5,a5,a4
    80001af4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001af6:	6d3c                	ld	a5,88(a0)
    80001af8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001afa:	60e2                	ld	ra,24(sp)
    80001afc:	6442                	ld	s0,16(sp)
    80001afe:	64a2                	ld	s1,8(sp)
    80001b00:	6105                	addi	sp,sp,32
    80001b02:	8082                	ret
    return p->trapframe->a1;
    80001b04:	6d3c                	ld	a5,88(a0)
    80001b06:	7fa8                	ld	a0,120(a5)
    80001b08:	bfcd                	j	80001afa <argraw+0x2c>
    return p->trapframe->a2;
    80001b0a:	6d3c                	ld	a5,88(a0)
    80001b0c:	63c8                	ld	a0,128(a5)
    80001b0e:	b7f5                	j	80001afa <argraw+0x2c>
    return p->trapframe->a3;
    80001b10:	6d3c                	ld	a5,88(a0)
    80001b12:	67c8                	ld	a0,136(a5)
    80001b14:	b7dd                	j	80001afa <argraw+0x2c>
    return p->trapframe->a4;
    80001b16:	6d3c                	ld	a5,88(a0)
    80001b18:	6bc8                	ld	a0,144(a5)
    80001b1a:	b7c5                	j	80001afa <argraw+0x2c>
    return p->trapframe->a5;
    80001b1c:	6d3c                	ld	a5,88(a0)
    80001b1e:	6fc8                	ld	a0,152(a5)
    80001b20:	bfe9                	j	80001afa <argraw+0x2c>
  panic("argraw");
    80001b22:	00006517          	auipc	a0,0x6
    80001b26:	8b650513          	addi	a0,a0,-1866 # 800073d8 <states.2239+0x150>
    80001b2a:	758030ef          	jal	ra,80005282 <panic>

0000000080001b2e <fetchaddr>:
{
    80001b2e:	1101                	addi	sp,sp,-32
    80001b30:	ec06                	sd	ra,24(sp)
    80001b32:	e822                	sd	s0,16(sp)
    80001b34:	e426                	sd	s1,8(sp)
    80001b36:	e04a                	sd	s2,0(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	84aa                	mv	s1,a0
    80001b3c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b3e:	9d2ff0ef          	jal	ra,80000d10 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b42:	653c                	ld	a5,72(a0)
    80001b44:	02f4f663          	bgeu	s1,a5,80001b70 <fetchaddr+0x42>
    80001b48:	00848713          	addi	a4,s1,8
    80001b4c:	02e7e463          	bltu	a5,a4,80001b74 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001b50:	46a1                	li	a3,8
    80001b52:	8626                	mv	a2,s1
    80001b54:	85ca                	mv	a1,s2
    80001b56:	6928                	ld	a0,80(a0)
    80001b58:	f27fe0ef          	jal	ra,80000a7e <copyin>
    80001b5c:	00a03533          	snez	a0,a0
    80001b60:	40a00533          	neg	a0,a0
}
    80001b64:	60e2                	ld	ra,24(sp)
    80001b66:	6442                	ld	s0,16(sp)
    80001b68:	64a2                	ld	s1,8(sp)
    80001b6a:	6902                	ld	s2,0(sp)
    80001b6c:	6105                	addi	sp,sp,32
    80001b6e:	8082                	ret
    return -1;
    80001b70:	557d                	li	a0,-1
    80001b72:	bfcd                	j	80001b64 <fetchaddr+0x36>
    80001b74:	557d                	li	a0,-1
    80001b76:	b7fd                	j	80001b64 <fetchaddr+0x36>

0000000080001b78 <fetchstr>:
{
    80001b78:	7179                	addi	sp,sp,-48
    80001b7a:	f406                	sd	ra,40(sp)
    80001b7c:	f022                	sd	s0,32(sp)
    80001b7e:	ec26                	sd	s1,24(sp)
    80001b80:	e84a                	sd	s2,16(sp)
    80001b82:	e44e                	sd	s3,8(sp)
    80001b84:	1800                	addi	s0,sp,48
    80001b86:	892a                	mv	s2,a0
    80001b88:	84ae                	mv	s1,a1
    80001b8a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001b8c:	984ff0ef          	jal	ra,80000d10 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001b90:	86ce                	mv	a3,s3
    80001b92:	864a                	mv	a2,s2
    80001b94:	85a6                	mv	a1,s1
    80001b96:	6928                	ld	a0,80(a0)
    80001b98:	f6bfe0ef          	jal	ra,80000b02 <copyinstr>
    80001b9c:	00054c63          	bltz	a0,80001bb4 <fetchstr+0x3c>
  return strlen(buf);
    80001ba0:	8526                	mv	a0,s1
    80001ba2:	f2afe0ef          	jal	ra,800002cc <strlen>
}
    80001ba6:	70a2                	ld	ra,40(sp)
    80001ba8:	7402                	ld	s0,32(sp)
    80001baa:	64e2                	ld	s1,24(sp)
    80001bac:	6942                	ld	s2,16(sp)
    80001bae:	69a2                	ld	s3,8(sp)
    80001bb0:	6145                	addi	sp,sp,48
    80001bb2:	8082                	ret
    return -1;
    80001bb4:	557d                	li	a0,-1
    80001bb6:	bfc5                	j	80001ba6 <fetchstr+0x2e>

0000000080001bb8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001bb8:	1101                	addi	sp,sp,-32
    80001bba:	ec06                	sd	ra,24(sp)
    80001bbc:	e822                	sd	s0,16(sp)
    80001bbe:	e426                	sd	s1,8(sp)
    80001bc0:	1000                	addi	s0,sp,32
    80001bc2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001bc4:	f0bff0ef          	jal	ra,80001ace <argraw>
    80001bc8:	c088                	sw	a0,0(s1)
}
    80001bca:	60e2                	ld	ra,24(sp)
    80001bcc:	6442                	ld	s0,16(sp)
    80001bce:	64a2                	ld	s1,8(sp)
    80001bd0:	6105                	addi	sp,sp,32
    80001bd2:	8082                	ret

0000000080001bd4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	e426                	sd	s1,8(sp)
    80001bdc:	1000                	addi	s0,sp,32
    80001bde:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001be0:	eefff0ef          	jal	ra,80001ace <argraw>
    80001be4:	e088                	sd	a0,0(s1)
}
    80001be6:	60e2                	ld	ra,24(sp)
    80001be8:	6442                	ld	s0,16(sp)
    80001bea:	64a2                	ld	s1,8(sp)
    80001bec:	6105                	addi	sp,sp,32
    80001bee:	8082                	ret

0000000080001bf0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001bf0:	7179                	addi	sp,sp,-48
    80001bf2:	f406                	sd	ra,40(sp)
    80001bf4:	f022                	sd	s0,32(sp)
    80001bf6:	ec26                	sd	s1,24(sp)
    80001bf8:	e84a                	sd	s2,16(sp)
    80001bfa:	1800                	addi	s0,sp,48
    80001bfc:	84ae                	mv	s1,a1
    80001bfe:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001c00:	fd840593          	addi	a1,s0,-40
    80001c04:	fd1ff0ef          	jal	ra,80001bd4 <argaddr>
  return fetchstr(addr, buf, max);
    80001c08:	864a                	mv	a2,s2
    80001c0a:	85a6                	mv	a1,s1
    80001c0c:	fd843503          	ld	a0,-40(s0)
    80001c10:	f69ff0ef          	jal	ra,80001b78 <fetchstr>
}
    80001c14:	70a2                	ld	ra,40(sp)
    80001c16:	7402                	ld	s0,32(sp)
    80001c18:	64e2                	ld	s1,24(sp)
    80001c1a:	6942                	ld	s2,16(sp)
    80001c1c:	6145                	addi	sp,sp,48
    80001c1e:	8082                	ret

0000000080001c20 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001c20:	1101                	addi	sp,sp,-32
    80001c22:	ec06                	sd	ra,24(sp)
    80001c24:	e822                	sd	s0,16(sp)
    80001c26:	e426                	sd	s1,8(sp)
    80001c28:	e04a                	sd	s2,0(sp)
    80001c2a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c2c:	8e4ff0ef          	jal	ra,80000d10 <myproc>
    80001c30:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c32:	05853903          	ld	s2,88(a0)
    80001c36:	0a893783          	ld	a5,168(s2)
    80001c3a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c3e:	37fd                	addiw	a5,a5,-1
    80001c40:	4751                	li	a4,20
    80001c42:	00f76f63          	bltu	a4,a5,80001c60 <syscall+0x40>
    80001c46:	00369713          	slli	a4,a3,0x3
    80001c4a:	00005797          	auipc	a5,0x5
    80001c4e:	7ce78793          	addi	a5,a5,1998 # 80007418 <syscalls>
    80001c52:	97ba                	add	a5,a5,a4
    80001c54:	639c                	ld	a5,0(a5)
    80001c56:	c789                	beqz	a5,80001c60 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001c58:	9782                	jalr	a5
    80001c5a:	06a93823          	sd	a0,112(s2)
    80001c5e:	a829                	j	80001c78 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001c60:	15848613          	addi	a2,s1,344
    80001c64:	588c                	lw	a1,48(s1)
    80001c66:	00005517          	auipc	a0,0x5
    80001c6a:	77a50513          	addi	a0,a0,1914 # 800073e0 <states.2239+0x158>
    80001c6e:	360030ef          	jal	ra,80004fce <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001c72:	6cbc                	ld	a5,88(s1)
    80001c74:	577d                	li	a4,-1
    80001c76:	fbb8                	sd	a4,112(a5)
  }
}
    80001c78:	60e2                	ld	ra,24(sp)
    80001c7a:	6442                	ld	s0,16(sp)
    80001c7c:	64a2                	ld	s1,8(sp)
    80001c7e:	6902                	ld	s2,0(sp)
    80001c80:	6105                	addi	sp,sp,32
    80001c82:	8082                	ret

0000000080001c84 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001c8c:	fec40593          	addi	a1,s0,-20
    80001c90:	4501                	li	a0,0
    80001c92:	f27ff0ef          	jal	ra,80001bb8 <argint>
  exit(n);
    80001c96:	fec42503          	lw	a0,-20(s0)
    80001c9a:	f4aff0ef          	jal	ra,800013e4 <exit>
  return 0;  // not reached
}
    80001c9e:	4501                	li	a0,0
    80001ca0:	60e2                	ld	ra,24(sp)
    80001ca2:	6442                	ld	s0,16(sp)
    80001ca4:	6105                	addi	sp,sp,32
    80001ca6:	8082                	ret

0000000080001ca8 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001ca8:	1141                	addi	sp,sp,-16
    80001caa:	e406                	sd	ra,8(sp)
    80001cac:	e022                	sd	s0,0(sp)
    80001cae:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001cb0:	860ff0ef          	jal	ra,80000d10 <myproc>
}
    80001cb4:	5908                	lw	a0,48(a0)
    80001cb6:	60a2                	ld	ra,8(sp)
    80001cb8:	6402                	ld	s0,0(sp)
    80001cba:	0141                	addi	sp,sp,16
    80001cbc:	8082                	ret

0000000080001cbe <sys_fork>:

uint64
sys_fork(void)
{
    80001cbe:	1141                	addi	sp,sp,-16
    80001cc0:	e406                	sd	ra,8(sp)
    80001cc2:	e022                	sd	s0,0(sp)
    80001cc4:	0800                	addi	s0,sp,16
  return fork();
    80001cc6:	b70ff0ef          	jal	ra,80001036 <fork>
}
    80001cca:	60a2                	ld	ra,8(sp)
    80001ccc:	6402                	ld	s0,0(sp)
    80001cce:	0141                	addi	sp,sp,16
    80001cd0:	8082                	ret

0000000080001cd2 <sys_wait>:

uint64
sys_wait(void)
{
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001cda:	fe840593          	addi	a1,s0,-24
    80001cde:	4501                	li	a0,0
    80001ce0:	ef5ff0ef          	jal	ra,80001bd4 <argaddr>
  return wait(p);
    80001ce4:	fe843503          	ld	a0,-24(s0)
    80001ce8:	853ff0ef          	jal	ra,8000153a <wait>
}
    80001cec:	60e2                	ld	ra,24(sp)
    80001cee:	6442                	ld	s0,16(sp)
    80001cf0:	6105                	addi	sp,sp,32
    80001cf2:	8082                	ret

0000000080001cf4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001cf4:	7179                	addi	sp,sp,-48
    80001cf6:	f406                	sd	ra,40(sp)
    80001cf8:	f022                	sd	s0,32(sp)
    80001cfa:	ec26                	sd	s1,24(sp)
    80001cfc:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001cfe:	fdc40593          	addi	a1,s0,-36
    80001d02:	4501                	li	a0,0
    80001d04:	eb5ff0ef          	jal	ra,80001bb8 <argint>
  addr = myproc()->sz;
    80001d08:	808ff0ef          	jal	ra,80000d10 <myproc>
    80001d0c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d0e:	fdc42503          	lw	a0,-36(s0)
    80001d12:	ad4ff0ef          	jal	ra,80000fe6 <growproc>
    80001d16:	00054863          	bltz	a0,80001d26 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	70a2                	ld	ra,40(sp)
    80001d1e:	7402                	ld	s0,32(sp)
    80001d20:	64e2                	ld	s1,24(sp)
    80001d22:	6145                	addi	sp,sp,48
    80001d24:	8082                	ret
    return -1;
    80001d26:	54fd                	li	s1,-1
    80001d28:	bfcd                	j	80001d1a <sys_sbrk+0x26>

0000000080001d2a <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d2a:	7139                	addi	sp,sp,-64
    80001d2c:	fc06                	sd	ra,56(sp)
    80001d2e:	f822                	sd	s0,48(sp)
    80001d30:	f426                	sd	s1,40(sp)
    80001d32:	f04a                	sd	s2,32(sp)
    80001d34:	ec4e                	sd	s3,24(sp)
    80001d36:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d38:	fcc40593          	addi	a1,s0,-52
    80001d3c:	4501                	li	a0,0
    80001d3e:	e7bff0ef          	jal	ra,80001bb8 <argint>
  if(n < 0)
    80001d42:	fcc42783          	lw	a5,-52(s0)
    80001d46:	0607c563          	bltz	a5,80001db0 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001d4a:	0000c517          	auipc	a0,0xc
    80001d4e:	a0650513          	addi	a0,a0,-1530 # 8000d750 <tickslock>
    80001d52:	04d030ef          	jal	ra,8000559e <acquire>
  ticks0 = ticks;
    80001d56:	00006917          	auipc	s2,0x6
    80001d5a:	b9292903          	lw	s2,-1134(s2) # 800078e8 <ticks>
  while(ticks - ticks0 < n){
    80001d5e:	fcc42783          	lw	a5,-52(s0)
    80001d62:	cb8d                	beqz	a5,80001d94 <sys_sleep+0x6a>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001d64:	0000c997          	auipc	s3,0xc
    80001d68:	9ec98993          	addi	s3,s3,-1556 # 8000d750 <tickslock>
    80001d6c:	00006497          	auipc	s1,0x6
    80001d70:	b7c48493          	addi	s1,s1,-1156 # 800078e8 <ticks>
    if(killed(myproc())){
    80001d74:	f9dfe0ef          	jal	ra,80000d10 <myproc>
    80001d78:	f98ff0ef          	jal	ra,80001510 <killed>
    80001d7c:	ed0d                	bnez	a0,80001db6 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001d7e:	85ce                	mv	a1,s3
    80001d80:	8526                	mv	a0,s1
    80001d82:	d56ff0ef          	jal	ra,800012d8 <sleep>
  while(ticks - ticks0 < n){
    80001d86:	409c                	lw	a5,0(s1)
    80001d88:	412787bb          	subw	a5,a5,s2
    80001d8c:	fcc42703          	lw	a4,-52(s0)
    80001d90:	fee7e2e3          	bltu	a5,a4,80001d74 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80001d94:	0000c517          	auipc	a0,0xc
    80001d98:	9bc50513          	addi	a0,a0,-1604 # 8000d750 <tickslock>
    80001d9c:	09b030ef          	jal	ra,80005636 <release>
  return 0;
    80001da0:	4501                	li	a0,0
}
    80001da2:	70e2                	ld	ra,56(sp)
    80001da4:	7442                	ld	s0,48(sp)
    80001da6:	74a2                	ld	s1,40(sp)
    80001da8:	7902                	ld	s2,32(sp)
    80001daa:	69e2                	ld	s3,24(sp)
    80001dac:	6121                	addi	sp,sp,64
    80001dae:	8082                	ret
    n = 0;
    80001db0:	fc042623          	sw	zero,-52(s0)
    80001db4:	bf59                	j	80001d4a <sys_sleep+0x20>
      release(&tickslock);
    80001db6:	0000c517          	auipc	a0,0xc
    80001dba:	99a50513          	addi	a0,a0,-1638 # 8000d750 <tickslock>
    80001dbe:	079030ef          	jal	ra,80005636 <release>
      return -1;
    80001dc2:	557d                	li	a0,-1
    80001dc4:	bff9                	j	80001da2 <sys_sleep+0x78>

0000000080001dc6 <sys_kill>:

uint64
sys_kill(void)
{
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001dce:	fec40593          	addi	a1,s0,-20
    80001dd2:	4501                	li	a0,0
    80001dd4:	de5ff0ef          	jal	ra,80001bb8 <argint>
  return kill(pid);
    80001dd8:	fec42503          	lw	a0,-20(s0)
    80001ddc:	eaaff0ef          	jal	ra,80001486 <kill>
}
    80001de0:	60e2                	ld	ra,24(sp)
    80001de2:	6442                	ld	s0,16(sp)
    80001de4:	6105                	addi	sp,sp,32
    80001de6:	8082                	ret

0000000080001de8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001de8:	1101                	addi	sp,sp,-32
    80001dea:	ec06                	sd	ra,24(sp)
    80001dec:	e822                	sd	s0,16(sp)
    80001dee:	e426                	sd	s1,8(sp)
    80001df0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001df2:	0000c517          	auipc	a0,0xc
    80001df6:	95e50513          	addi	a0,a0,-1698 # 8000d750 <tickslock>
    80001dfa:	7a4030ef          	jal	ra,8000559e <acquire>
  xticks = ticks;
    80001dfe:	00006497          	auipc	s1,0x6
    80001e02:	aea4a483          	lw	s1,-1302(s1) # 800078e8 <ticks>
  release(&tickslock);
    80001e06:	0000c517          	auipc	a0,0xc
    80001e0a:	94a50513          	addi	a0,a0,-1718 # 8000d750 <tickslock>
    80001e0e:	029030ef          	jal	ra,80005636 <release>
  return xticks;
}
    80001e12:	02049513          	slli	a0,s1,0x20
    80001e16:	9101                	srli	a0,a0,0x20
    80001e18:	60e2                	ld	ra,24(sp)
    80001e1a:	6442                	ld	s0,16(sp)
    80001e1c:	64a2                	ld	s1,8(sp)
    80001e1e:	6105                	addi	sp,sp,32
    80001e20:	8082                	ret

0000000080001e22 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e22:	7179                	addi	sp,sp,-48
    80001e24:	f406                	sd	ra,40(sp)
    80001e26:	f022                	sd	s0,32(sp)
    80001e28:	ec26                	sd	s1,24(sp)
    80001e2a:	e84a                	sd	s2,16(sp)
    80001e2c:	e44e                	sd	s3,8(sp)
    80001e2e:	e052                	sd	s4,0(sp)
    80001e30:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e32:	00005597          	auipc	a1,0x5
    80001e36:	69658593          	addi	a1,a1,1686 # 800074c8 <syscalls+0xb0>
    80001e3a:	0000c517          	auipc	a0,0xc
    80001e3e:	92e50513          	addi	a0,a0,-1746 # 8000d768 <bcache>
    80001e42:	6dc030ef          	jal	ra,8000551e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001e46:	00014797          	auipc	a5,0x14
    80001e4a:	92278793          	addi	a5,a5,-1758 # 80015768 <bcache+0x8000>
    80001e4e:	00014717          	auipc	a4,0x14
    80001e52:	b8270713          	addi	a4,a4,-1150 # 800159d0 <bcache+0x8268>
    80001e56:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001e5a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001e5e:	0000c497          	auipc	s1,0xc
    80001e62:	92248493          	addi	s1,s1,-1758 # 8000d780 <bcache+0x18>
    b->next = bcache.head.next;
    80001e66:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001e68:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001e6a:	00005a17          	auipc	s4,0x5
    80001e6e:	666a0a13          	addi	s4,s4,1638 # 800074d0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80001e72:	2b893783          	ld	a5,696(s2)
    80001e76:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001e78:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001e7c:	85d2                	mv	a1,s4
    80001e7e:	01048513          	addi	a0,s1,16
    80001e82:	224010ef          	jal	ra,800030a6 <initsleeplock>
    bcache.head.next->prev = b;
    80001e86:	2b893783          	ld	a5,696(s2)
    80001e8a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001e8c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001e90:	45848493          	addi	s1,s1,1112
    80001e94:	fd349fe3          	bne	s1,s3,80001e72 <binit+0x50>
  }
}
    80001e98:	70a2                	ld	ra,40(sp)
    80001e9a:	7402                	ld	s0,32(sp)
    80001e9c:	64e2                	ld	s1,24(sp)
    80001e9e:	6942                	ld	s2,16(sp)
    80001ea0:	69a2                	ld	s3,8(sp)
    80001ea2:	6a02                	ld	s4,0(sp)
    80001ea4:	6145                	addi	sp,sp,48
    80001ea6:	8082                	ret

0000000080001ea8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001ea8:	7179                	addi	sp,sp,-48
    80001eaa:	f406                	sd	ra,40(sp)
    80001eac:	f022                	sd	s0,32(sp)
    80001eae:	ec26                	sd	s1,24(sp)
    80001eb0:	e84a                	sd	s2,16(sp)
    80001eb2:	e44e                	sd	s3,8(sp)
    80001eb4:	1800                	addi	s0,sp,48
    80001eb6:	89aa                	mv	s3,a0
    80001eb8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80001eba:	0000c517          	auipc	a0,0xc
    80001ebe:	8ae50513          	addi	a0,a0,-1874 # 8000d768 <bcache>
    80001ec2:	6dc030ef          	jal	ra,8000559e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001ec6:	00014497          	auipc	s1,0x14
    80001eca:	b5a4b483          	ld	s1,-1190(s1) # 80015a20 <bcache+0x82b8>
    80001ece:	00014797          	auipc	a5,0x14
    80001ed2:	b0278793          	addi	a5,a5,-1278 # 800159d0 <bcache+0x8268>
    80001ed6:	02f48b63          	beq	s1,a5,80001f0c <bread+0x64>
    80001eda:	873e                	mv	a4,a5
    80001edc:	a021                	j	80001ee4 <bread+0x3c>
    80001ede:	68a4                	ld	s1,80(s1)
    80001ee0:	02e48663          	beq	s1,a4,80001f0c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001ee4:	449c                	lw	a5,8(s1)
    80001ee6:	ff379ce3          	bne	a5,s3,80001ede <bread+0x36>
    80001eea:	44dc                	lw	a5,12(s1)
    80001eec:	ff2799e3          	bne	a5,s2,80001ede <bread+0x36>
      b->refcnt++;
    80001ef0:	40bc                	lw	a5,64(s1)
    80001ef2:	2785                	addiw	a5,a5,1
    80001ef4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001ef6:	0000c517          	auipc	a0,0xc
    80001efa:	87250513          	addi	a0,a0,-1934 # 8000d768 <bcache>
    80001efe:	738030ef          	jal	ra,80005636 <release>
      acquiresleep(&b->lock);
    80001f02:	01048513          	addi	a0,s1,16
    80001f06:	1d6010ef          	jal	ra,800030dc <acquiresleep>
      return b;
    80001f0a:	a889                	j	80001f5c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f0c:	00014497          	auipc	s1,0x14
    80001f10:	b0c4b483          	ld	s1,-1268(s1) # 80015a18 <bcache+0x82b0>
    80001f14:	00014797          	auipc	a5,0x14
    80001f18:	abc78793          	addi	a5,a5,-1348 # 800159d0 <bcache+0x8268>
    80001f1c:	00f48863          	beq	s1,a5,80001f2c <bread+0x84>
    80001f20:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f22:	40bc                	lw	a5,64(s1)
    80001f24:	cb91                	beqz	a5,80001f38 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f26:	64a4                	ld	s1,72(s1)
    80001f28:	fee49de3          	bne	s1,a4,80001f22 <bread+0x7a>
  panic("bget: no buffers");
    80001f2c:	00005517          	auipc	a0,0x5
    80001f30:	5ac50513          	addi	a0,a0,1452 # 800074d8 <syscalls+0xc0>
    80001f34:	34e030ef          	jal	ra,80005282 <panic>
      b->dev = dev;
    80001f38:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80001f3c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80001f40:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001f44:	4785                	li	a5,1
    80001f46:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f48:	0000c517          	auipc	a0,0xc
    80001f4c:	82050513          	addi	a0,a0,-2016 # 8000d768 <bcache>
    80001f50:	6e6030ef          	jal	ra,80005636 <release>
      acquiresleep(&b->lock);
    80001f54:	01048513          	addi	a0,s1,16
    80001f58:	184010ef          	jal	ra,800030dc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001f5c:	409c                	lw	a5,0(s1)
    80001f5e:	cb89                	beqz	a5,80001f70 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001f60:	8526                	mv	a0,s1
    80001f62:	70a2                	ld	ra,40(sp)
    80001f64:	7402                	ld	s0,32(sp)
    80001f66:	64e2                	ld	s1,24(sp)
    80001f68:	6942                	ld	s2,16(sp)
    80001f6a:	69a2                	ld	s3,8(sp)
    80001f6c:	6145                	addi	sp,sp,48
    80001f6e:	8082                	ret
    virtio_disk_rw(b, 0);
    80001f70:	4581                	li	a1,0
    80001f72:	8526                	mv	a0,s1
    80001f74:	0bd020ef          	jal	ra,80004830 <virtio_disk_rw>
    b->valid = 1;
    80001f78:	4785                	li	a5,1
    80001f7a:	c09c                	sw	a5,0(s1)
  return b;
    80001f7c:	b7d5                	j	80001f60 <bread+0xb8>

0000000080001f7e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001f7e:	1101                	addi	sp,sp,-32
    80001f80:	ec06                	sd	ra,24(sp)
    80001f82:	e822                	sd	s0,16(sp)
    80001f84:	e426                	sd	s1,8(sp)
    80001f86:	1000                	addi	s0,sp,32
    80001f88:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001f8a:	0541                	addi	a0,a0,16
    80001f8c:	1ce010ef          	jal	ra,8000315a <holdingsleep>
    80001f90:	c911                	beqz	a0,80001fa4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001f92:	4585                	li	a1,1
    80001f94:	8526                	mv	a0,s1
    80001f96:	09b020ef          	jal	ra,80004830 <virtio_disk_rw>
}
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6105                	addi	sp,sp,32
    80001fa2:	8082                	ret
    panic("bwrite");
    80001fa4:	00005517          	auipc	a0,0x5
    80001fa8:	54c50513          	addi	a0,a0,1356 # 800074f0 <syscalls+0xd8>
    80001fac:	2d6030ef          	jal	ra,80005282 <panic>

0000000080001fb0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	e04a                	sd	s2,0(sp)
    80001fba:	1000                	addi	s0,sp,32
    80001fbc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fbe:	01050913          	addi	s2,a0,16
    80001fc2:	854a                	mv	a0,s2
    80001fc4:	196010ef          	jal	ra,8000315a <holdingsleep>
    80001fc8:	c13d                	beqz	a0,8000202e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    80001fca:	854a                	mv	a0,s2
    80001fcc:	156010ef          	jal	ra,80003122 <releasesleep>

  acquire(&bcache.lock);
    80001fd0:	0000b517          	auipc	a0,0xb
    80001fd4:	79850513          	addi	a0,a0,1944 # 8000d768 <bcache>
    80001fd8:	5c6030ef          	jal	ra,8000559e <acquire>
  b->refcnt--;
    80001fdc:	40bc                	lw	a5,64(s1)
    80001fde:	37fd                	addiw	a5,a5,-1
    80001fe0:	0007871b          	sext.w	a4,a5
    80001fe4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80001fe6:	eb05                	bnez	a4,80002016 <brelse+0x66>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80001fe8:	68bc                	ld	a5,80(s1)
    80001fea:	64b8                	ld	a4,72(s1)
    80001fec:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80001fee:	64bc                	ld	a5,72(s1)
    80001ff0:	68b8                	ld	a4,80(s1)
    80001ff2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80001ff4:	00013797          	auipc	a5,0x13
    80001ff8:	77478793          	addi	a5,a5,1908 # 80015768 <bcache+0x8000>
    80001ffc:	2b87b703          	ld	a4,696(a5)
    80002000:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002002:	00014717          	auipc	a4,0x14
    80002006:	9ce70713          	addi	a4,a4,-1586 # 800159d0 <bcache+0x8268>
    8000200a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000200c:	2b87b703          	ld	a4,696(a5)
    80002010:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002012:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002016:	0000b517          	auipc	a0,0xb
    8000201a:	75250513          	addi	a0,a0,1874 # 8000d768 <bcache>
    8000201e:	618030ef          	jal	ra,80005636 <release>
}
    80002022:	60e2                	ld	ra,24(sp)
    80002024:	6442                	ld	s0,16(sp)
    80002026:	64a2                	ld	s1,8(sp)
    80002028:	6902                	ld	s2,0(sp)
    8000202a:	6105                	addi	sp,sp,32
    8000202c:	8082                	ret
    panic("brelse");
    8000202e:	00005517          	auipc	a0,0x5
    80002032:	4ca50513          	addi	a0,a0,1226 # 800074f8 <syscalls+0xe0>
    80002036:	24c030ef          	jal	ra,80005282 <panic>

000000008000203a <bpin>:

void
bpin(struct buf *b) {
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	e426                	sd	s1,8(sp)
    80002042:	1000                	addi	s0,sp,32
    80002044:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002046:	0000b517          	auipc	a0,0xb
    8000204a:	72250513          	addi	a0,a0,1826 # 8000d768 <bcache>
    8000204e:	550030ef          	jal	ra,8000559e <acquire>
  b->refcnt++;
    80002052:	40bc                	lw	a5,64(s1)
    80002054:	2785                	addiw	a5,a5,1
    80002056:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002058:	0000b517          	auipc	a0,0xb
    8000205c:	71050513          	addi	a0,a0,1808 # 8000d768 <bcache>
    80002060:	5d6030ef          	jal	ra,80005636 <release>
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6105                	addi	sp,sp,32
    8000206c:	8082                	ret

000000008000206e <bunpin>:

void
bunpin(struct buf *b) {
    8000206e:	1101                	addi	sp,sp,-32
    80002070:	ec06                	sd	ra,24(sp)
    80002072:	e822                	sd	s0,16(sp)
    80002074:	e426                	sd	s1,8(sp)
    80002076:	1000                	addi	s0,sp,32
    80002078:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000207a:	0000b517          	auipc	a0,0xb
    8000207e:	6ee50513          	addi	a0,a0,1774 # 8000d768 <bcache>
    80002082:	51c030ef          	jal	ra,8000559e <acquire>
  b->refcnt--;
    80002086:	40bc                	lw	a5,64(s1)
    80002088:	37fd                	addiw	a5,a5,-1
    8000208a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000208c:	0000b517          	auipc	a0,0xb
    80002090:	6dc50513          	addi	a0,a0,1756 # 8000d768 <bcache>
    80002094:	5a2030ef          	jal	ra,80005636 <release>
}
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6105                	addi	sp,sp,32
    800020a0:	8082                	ret

00000000800020a2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	e04a                	sd	s2,0(sp)
    800020ac:	1000                	addi	s0,sp,32
    800020ae:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800020b0:	00d5d59b          	srliw	a1,a1,0xd
    800020b4:	00014797          	auipc	a5,0x14
    800020b8:	d907a783          	lw	a5,-624(a5) # 80015e44 <sb+0x1c>
    800020bc:	9dbd                	addw	a1,a1,a5
    800020be:	debff0ef          	jal	ra,80001ea8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800020c2:	0074f713          	andi	a4,s1,7
    800020c6:	4785                	li	a5,1
    800020c8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800020cc:	14ce                	slli	s1,s1,0x33
    800020ce:	90d9                	srli	s1,s1,0x36
    800020d0:	00950733          	add	a4,a0,s1
    800020d4:	05874703          	lbu	a4,88(a4)
    800020d8:	00e7f6b3          	and	a3,a5,a4
    800020dc:	c29d                	beqz	a3,80002102 <bfree+0x60>
    800020de:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800020e0:	94aa                	add	s1,s1,a0
    800020e2:	fff7c793          	not	a5,a5
    800020e6:	8ff9                	and	a5,a5,a4
    800020e8:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800020ec:	6e9000ef          	jal	ra,80002fd4 <log_write>
  brelse(bp);
    800020f0:	854a                	mv	a0,s2
    800020f2:	ebfff0ef          	jal	ra,80001fb0 <brelse>
}
    800020f6:	60e2                	ld	ra,24(sp)
    800020f8:	6442                	ld	s0,16(sp)
    800020fa:	64a2                	ld	s1,8(sp)
    800020fc:	6902                	ld	s2,0(sp)
    800020fe:	6105                	addi	sp,sp,32
    80002100:	8082                	ret
    panic("freeing free block");
    80002102:	00005517          	auipc	a0,0x5
    80002106:	3fe50513          	addi	a0,a0,1022 # 80007500 <syscalls+0xe8>
    8000210a:	178030ef          	jal	ra,80005282 <panic>

000000008000210e <balloc>:
{
    8000210e:	711d                	addi	sp,sp,-96
    80002110:	ec86                	sd	ra,88(sp)
    80002112:	e8a2                	sd	s0,80(sp)
    80002114:	e4a6                	sd	s1,72(sp)
    80002116:	e0ca                	sd	s2,64(sp)
    80002118:	fc4e                	sd	s3,56(sp)
    8000211a:	f852                	sd	s4,48(sp)
    8000211c:	f456                	sd	s5,40(sp)
    8000211e:	f05a                	sd	s6,32(sp)
    80002120:	ec5e                	sd	s7,24(sp)
    80002122:	e862                	sd	s8,16(sp)
    80002124:	e466                	sd	s9,8(sp)
    80002126:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002128:	00014797          	auipc	a5,0x14
    8000212c:	d047a783          	lw	a5,-764(a5) # 80015e2c <sb+0x4>
    80002130:	0e078163          	beqz	a5,80002212 <balloc+0x104>
    80002134:	8baa                	mv	s7,a0
    80002136:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002138:	00014b17          	auipc	s6,0x14
    8000213c:	cf0b0b13          	addi	s6,s6,-784 # 80015e28 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002140:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002142:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002144:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002146:	6c89                	lui	s9,0x2
    80002148:	a0b5                	j	800021b4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000214a:	974a                	add	a4,a4,s2
    8000214c:	8fd5                	or	a5,a5,a3
    8000214e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002152:	854a                	mv	a0,s2
    80002154:	681000ef          	jal	ra,80002fd4 <log_write>
        brelse(bp);
    80002158:	854a                	mv	a0,s2
    8000215a:	e57ff0ef          	jal	ra,80001fb0 <brelse>
  bp = bread(dev, bno);
    8000215e:	85a6                	mv	a1,s1
    80002160:	855e                	mv	a0,s7
    80002162:	d47ff0ef          	jal	ra,80001ea8 <bread>
    80002166:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002168:	40000613          	li	a2,1024
    8000216c:	4581                	li	a1,0
    8000216e:	05850513          	addi	a0,a0,88
    80002172:	fdbfd0ef          	jal	ra,8000014c <memset>
  log_write(bp);
    80002176:	854a                	mv	a0,s2
    80002178:	65d000ef          	jal	ra,80002fd4 <log_write>
  brelse(bp);
    8000217c:	854a                	mv	a0,s2
    8000217e:	e33ff0ef          	jal	ra,80001fb0 <brelse>
}
    80002182:	8526                	mv	a0,s1
    80002184:	60e6                	ld	ra,88(sp)
    80002186:	6446                	ld	s0,80(sp)
    80002188:	64a6                	ld	s1,72(sp)
    8000218a:	6906                	ld	s2,64(sp)
    8000218c:	79e2                	ld	s3,56(sp)
    8000218e:	7a42                	ld	s4,48(sp)
    80002190:	7aa2                	ld	s5,40(sp)
    80002192:	7b02                	ld	s6,32(sp)
    80002194:	6be2                	ld	s7,24(sp)
    80002196:	6c42                	ld	s8,16(sp)
    80002198:	6ca2                	ld	s9,8(sp)
    8000219a:	6125                	addi	sp,sp,96
    8000219c:	8082                	ret
    brelse(bp);
    8000219e:	854a                	mv	a0,s2
    800021a0:	e11ff0ef          	jal	ra,80001fb0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800021a4:	015c87bb          	addw	a5,s9,s5
    800021a8:	00078a9b          	sext.w	s5,a5
    800021ac:	004b2703          	lw	a4,4(s6)
    800021b0:	06eaf163          	bgeu	s5,a4,80002212 <balloc+0x104>
    bp = bread(dev, BBLOCK(b, sb));
    800021b4:	41fad79b          	sraiw	a5,s5,0x1f
    800021b8:	0137d79b          	srliw	a5,a5,0x13
    800021bc:	015787bb          	addw	a5,a5,s5
    800021c0:	40d7d79b          	sraiw	a5,a5,0xd
    800021c4:	01cb2583          	lw	a1,28(s6)
    800021c8:	9dbd                	addw	a1,a1,a5
    800021ca:	855e                	mv	a0,s7
    800021cc:	cddff0ef          	jal	ra,80001ea8 <bread>
    800021d0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800021d2:	004b2503          	lw	a0,4(s6)
    800021d6:	000a849b          	sext.w	s1,s5
    800021da:	8662                	mv	a2,s8
    800021dc:	fca4f1e3          	bgeu	s1,a0,8000219e <balloc+0x90>
      m = 1 << (bi % 8);
    800021e0:	41f6579b          	sraiw	a5,a2,0x1f
    800021e4:	01d7d69b          	srliw	a3,a5,0x1d
    800021e8:	00c6873b          	addw	a4,a3,a2
    800021ec:	00777793          	andi	a5,a4,7
    800021f0:	9f95                	subw	a5,a5,a3
    800021f2:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800021f6:	4037571b          	sraiw	a4,a4,0x3
    800021fa:	00e906b3          	add	a3,s2,a4
    800021fe:	0586c683          	lbu	a3,88(a3)
    80002202:	00d7f5b3          	and	a1,a5,a3
    80002206:	d1b1                	beqz	a1,8000214a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002208:	2605                	addiw	a2,a2,1
    8000220a:	2485                	addiw	s1,s1,1
    8000220c:	fd4618e3          	bne	a2,s4,800021dc <balloc+0xce>
    80002210:	b779                	j	8000219e <balloc+0x90>
  printf("balloc: out of blocks\n");
    80002212:	00005517          	auipc	a0,0x5
    80002216:	30650513          	addi	a0,a0,774 # 80007518 <syscalls+0x100>
    8000221a:	5b5020ef          	jal	ra,80004fce <printf>
  return 0;
    8000221e:	4481                	li	s1,0
    80002220:	b78d                	j	80002182 <balloc+0x74>

0000000080002222 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002222:	7179                	addi	sp,sp,-48
    80002224:	f406                	sd	ra,40(sp)
    80002226:	f022                	sd	s0,32(sp)
    80002228:	ec26                	sd	s1,24(sp)
    8000222a:	e84a                	sd	s2,16(sp)
    8000222c:	e44e                	sd	s3,8(sp)
    8000222e:	e052                	sd	s4,0(sp)
    80002230:	1800                	addi	s0,sp,48
    80002232:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002234:	47ad                	li	a5,11
    80002236:	02b7e563          	bltu	a5,a1,80002260 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000223a:	02059493          	slli	s1,a1,0x20
    8000223e:	9081                	srli	s1,s1,0x20
    80002240:	048a                	slli	s1,s1,0x2
    80002242:	94aa                	add	s1,s1,a0
    80002244:	0504a903          	lw	s2,80(s1)
    80002248:	06091663          	bnez	s2,800022b4 <bmap+0x92>
      addr = balloc(ip->dev);
    8000224c:	4108                	lw	a0,0(a0)
    8000224e:	ec1ff0ef          	jal	ra,8000210e <balloc>
    80002252:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002256:	04090f63          	beqz	s2,800022b4 <bmap+0x92>
        return 0;
      ip->addrs[bn] = addr;
    8000225a:	0524a823          	sw	s2,80(s1)
    8000225e:	a899                	j	800022b4 <bmap+0x92>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002260:	ff45849b          	addiw	s1,a1,-12
    80002264:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002268:	0ff00793          	li	a5,255
    8000226c:	06e7eb63          	bltu	a5,a4,800022e2 <bmap+0xc0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002270:	08052903          	lw	s2,128(a0)
    80002274:	00091b63          	bnez	s2,8000228a <bmap+0x68>
      addr = balloc(ip->dev);
    80002278:	4108                	lw	a0,0(a0)
    8000227a:	e95ff0ef          	jal	ra,8000210e <balloc>
    8000227e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002282:	02090963          	beqz	s2,800022b4 <bmap+0x92>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002286:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000228a:	85ca                	mv	a1,s2
    8000228c:	0009a503          	lw	a0,0(s3)
    80002290:	c19ff0ef          	jal	ra,80001ea8 <bread>
    80002294:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002296:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000229a:	02049593          	slli	a1,s1,0x20
    8000229e:	9181                	srli	a1,a1,0x20
    800022a0:	058a                	slli	a1,a1,0x2
    800022a2:	00b784b3          	add	s1,a5,a1
    800022a6:	0004a903          	lw	s2,0(s1)
    800022aa:	00090e63          	beqz	s2,800022c6 <bmap+0xa4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800022ae:	8552                	mv	a0,s4
    800022b0:	d01ff0ef          	jal	ra,80001fb0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800022b4:	854a                	mv	a0,s2
    800022b6:	70a2                	ld	ra,40(sp)
    800022b8:	7402                	ld	s0,32(sp)
    800022ba:	64e2                	ld	s1,24(sp)
    800022bc:	6942                	ld	s2,16(sp)
    800022be:	69a2                	ld	s3,8(sp)
    800022c0:	6a02                	ld	s4,0(sp)
    800022c2:	6145                	addi	sp,sp,48
    800022c4:	8082                	ret
      addr = balloc(ip->dev);
    800022c6:	0009a503          	lw	a0,0(s3)
    800022ca:	e45ff0ef          	jal	ra,8000210e <balloc>
    800022ce:	0005091b          	sext.w	s2,a0
      if(addr){
    800022d2:	fc090ee3          	beqz	s2,800022ae <bmap+0x8c>
        a[bn] = addr;
    800022d6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800022da:	8552                	mv	a0,s4
    800022dc:	4f9000ef          	jal	ra,80002fd4 <log_write>
    800022e0:	b7f9                	j	800022ae <bmap+0x8c>
  panic("bmap: out of range");
    800022e2:	00005517          	auipc	a0,0x5
    800022e6:	24e50513          	addi	a0,a0,590 # 80007530 <syscalls+0x118>
    800022ea:	799020ef          	jal	ra,80005282 <panic>

00000000800022ee <iget>:
{
    800022ee:	7179                	addi	sp,sp,-48
    800022f0:	f406                	sd	ra,40(sp)
    800022f2:	f022                	sd	s0,32(sp)
    800022f4:	ec26                	sd	s1,24(sp)
    800022f6:	e84a                	sd	s2,16(sp)
    800022f8:	e44e                	sd	s3,8(sp)
    800022fa:	e052                	sd	s4,0(sp)
    800022fc:	1800                	addi	s0,sp,48
    800022fe:	89aa                	mv	s3,a0
    80002300:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002302:	00014517          	auipc	a0,0x14
    80002306:	b4650513          	addi	a0,a0,-1210 # 80015e48 <itable>
    8000230a:	294030ef          	jal	ra,8000559e <acquire>
  empty = 0;
    8000230e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002310:	00014497          	auipc	s1,0x14
    80002314:	b5048493          	addi	s1,s1,-1200 # 80015e60 <itable+0x18>
    80002318:	00015697          	auipc	a3,0x15
    8000231c:	5d868693          	addi	a3,a3,1496 # 800178f0 <log>
    80002320:	a039                	j	8000232e <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002322:	02090963          	beqz	s2,80002354 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002326:	08848493          	addi	s1,s1,136
    8000232a:	02d48863          	beq	s1,a3,8000235a <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000232e:	449c                	lw	a5,8(s1)
    80002330:	fef059e3          	blez	a5,80002322 <iget+0x34>
    80002334:	4098                	lw	a4,0(s1)
    80002336:	ff3716e3          	bne	a4,s3,80002322 <iget+0x34>
    8000233a:	40d8                	lw	a4,4(s1)
    8000233c:	ff4713e3          	bne	a4,s4,80002322 <iget+0x34>
      ip->ref++;
    80002340:	2785                	addiw	a5,a5,1
    80002342:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002344:	00014517          	auipc	a0,0x14
    80002348:	b0450513          	addi	a0,a0,-1276 # 80015e48 <itable>
    8000234c:	2ea030ef          	jal	ra,80005636 <release>
      return ip;
    80002350:	8926                	mv	s2,s1
    80002352:	a02d                	j	8000237c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002354:	fbe9                	bnez	a5,80002326 <iget+0x38>
    80002356:	8926                	mv	s2,s1
    80002358:	b7f9                	j	80002326 <iget+0x38>
  if(empty == 0)
    8000235a:	02090a63          	beqz	s2,8000238e <iget+0xa0>
  ip->dev = dev;
    8000235e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002362:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002366:	4785                	li	a5,1
    80002368:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000236c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002370:	00014517          	auipc	a0,0x14
    80002374:	ad850513          	addi	a0,a0,-1320 # 80015e48 <itable>
    80002378:	2be030ef          	jal	ra,80005636 <release>
}
    8000237c:	854a                	mv	a0,s2
    8000237e:	70a2                	ld	ra,40(sp)
    80002380:	7402                	ld	s0,32(sp)
    80002382:	64e2                	ld	s1,24(sp)
    80002384:	6942                	ld	s2,16(sp)
    80002386:	69a2                	ld	s3,8(sp)
    80002388:	6a02                	ld	s4,0(sp)
    8000238a:	6145                	addi	sp,sp,48
    8000238c:	8082                	ret
    panic("iget: no inodes");
    8000238e:	00005517          	auipc	a0,0x5
    80002392:	1ba50513          	addi	a0,a0,442 # 80007548 <syscalls+0x130>
    80002396:	6ed020ef          	jal	ra,80005282 <panic>

000000008000239a <fsinit>:
fsinit(int dev) {
    8000239a:	7179                	addi	sp,sp,-48
    8000239c:	f406                	sd	ra,40(sp)
    8000239e:	f022                	sd	s0,32(sp)
    800023a0:	ec26                	sd	s1,24(sp)
    800023a2:	e84a                	sd	s2,16(sp)
    800023a4:	e44e                	sd	s3,8(sp)
    800023a6:	1800                	addi	s0,sp,48
    800023a8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800023aa:	4585                	li	a1,1
    800023ac:	afdff0ef          	jal	ra,80001ea8 <bread>
    800023b0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800023b2:	00014997          	auipc	s3,0x14
    800023b6:	a7698993          	addi	s3,s3,-1418 # 80015e28 <sb>
    800023ba:	02000613          	li	a2,32
    800023be:	05850593          	addi	a1,a0,88
    800023c2:	854e                	mv	a0,s3
    800023c4:	de9fd0ef          	jal	ra,800001ac <memmove>
  brelse(bp);
    800023c8:	8526                	mv	a0,s1
    800023ca:	be7ff0ef          	jal	ra,80001fb0 <brelse>
  if(sb.magic != FSMAGIC)
    800023ce:	0009a703          	lw	a4,0(s3)
    800023d2:	102037b7          	lui	a5,0x10203
    800023d6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800023da:	02f71063          	bne	a4,a5,800023fa <fsinit+0x60>
  initlog(dev, &sb);
    800023de:	00014597          	auipc	a1,0x14
    800023e2:	a4a58593          	addi	a1,a1,-1462 # 80015e28 <sb>
    800023e6:	854a                	mv	a0,s2
    800023e8:	1d9000ef          	jal	ra,80002dc0 <initlog>
}
    800023ec:	70a2                	ld	ra,40(sp)
    800023ee:	7402                	ld	s0,32(sp)
    800023f0:	64e2                	ld	s1,24(sp)
    800023f2:	6942                	ld	s2,16(sp)
    800023f4:	69a2                	ld	s3,8(sp)
    800023f6:	6145                	addi	sp,sp,48
    800023f8:	8082                	ret
    panic("invalid file system");
    800023fa:	00005517          	auipc	a0,0x5
    800023fe:	15e50513          	addi	a0,a0,350 # 80007558 <syscalls+0x140>
    80002402:	681020ef          	jal	ra,80005282 <panic>

0000000080002406 <iinit>:
{
    80002406:	7179                	addi	sp,sp,-48
    80002408:	f406                	sd	ra,40(sp)
    8000240a:	f022                	sd	s0,32(sp)
    8000240c:	ec26                	sd	s1,24(sp)
    8000240e:	e84a                	sd	s2,16(sp)
    80002410:	e44e                	sd	s3,8(sp)
    80002412:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002414:	00005597          	auipc	a1,0x5
    80002418:	15c58593          	addi	a1,a1,348 # 80007570 <syscalls+0x158>
    8000241c:	00014517          	auipc	a0,0x14
    80002420:	a2c50513          	addi	a0,a0,-1492 # 80015e48 <itable>
    80002424:	0fa030ef          	jal	ra,8000551e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002428:	00014497          	auipc	s1,0x14
    8000242c:	a4848493          	addi	s1,s1,-1464 # 80015e70 <itable+0x28>
    80002430:	00015997          	auipc	s3,0x15
    80002434:	4d098993          	addi	s3,s3,1232 # 80017900 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002438:	00005917          	auipc	s2,0x5
    8000243c:	14090913          	addi	s2,s2,320 # 80007578 <syscalls+0x160>
    80002440:	85ca                	mv	a1,s2
    80002442:	8526                	mv	a0,s1
    80002444:	463000ef          	jal	ra,800030a6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002448:	08848493          	addi	s1,s1,136
    8000244c:	ff349ae3          	bne	s1,s3,80002440 <iinit+0x3a>
}
    80002450:	70a2                	ld	ra,40(sp)
    80002452:	7402                	ld	s0,32(sp)
    80002454:	64e2                	ld	s1,24(sp)
    80002456:	6942                	ld	s2,16(sp)
    80002458:	69a2                	ld	s3,8(sp)
    8000245a:	6145                	addi	sp,sp,48
    8000245c:	8082                	ret

000000008000245e <ialloc>:
{
    8000245e:	715d                	addi	sp,sp,-80
    80002460:	e486                	sd	ra,72(sp)
    80002462:	e0a2                	sd	s0,64(sp)
    80002464:	fc26                	sd	s1,56(sp)
    80002466:	f84a                	sd	s2,48(sp)
    80002468:	f44e                	sd	s3,40(sp)
    8000246a:	f052                	sd	s4,32(sp)
    8000246c:	ec56                	sd	s5,24(sp)
    8000246e:	e85a                	sd	s6,16(sp)
    80002470:	e45e                	sd	s7,8(sp)
    80002472:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002474:	00014717          	auipc	a4,0x14
    80002478:	9c072703          	lw	a4,-1600(a4) # 80015e34 <sb+0xc>
    8000247c:	4785                	li	a5,1
    8000247e:	04e7f663          	bgeu	a5,a4,800024ca <ialloc+0x6c>
    80002482:	8aaa                	mv	s5,a0
    80002484:	8bae                	mv	s7,a1
    80002486:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002488:	00014a17          	auipc	s4,0x14
    8000248c:	9a0a0a13          	addi	s4,s4,-1632 # 80015e28 <sb>
    80002490:	00048b1b          	sext.w	s6,s1
    80002494:	0044d593          	srli	a1,s1,0x4
    80002498:	018a2783          	lw	a5,24(s4)
    8000249c:	9dbd                	addw	a1,a1,a5
    8000249e:	8556                	mv	a0,s5
    800024a0:	a09ff0ef          	jal	ra,80001ea8 <bread>
    800024a4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800024a6:	05850993          	addi	s3,a0,88
    800024aa:	00f4f793          	andi	a5,s1,15
    800024ae:	079a                	slli	a5,a5,0x6
    800024b0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800024b2:	00099783          	lh	a5,0(s3)
    800024b6:	cf85                	beqz	a5,800024ee <ialloc+0x90>
    brelse(bp);
    800024b8:	af9ff0ef          	jal	ra,80001fb0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800024bc:	0485                	addi	s1,s1,1
    800024be:	00ca2703          	lw	a4,12(s4)
    800024c2:	0004879b          	sext.w	a5,s1
    800024c6:	fce7e5e3          	bltu	a5,a4,80002490 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800024ca:	00005517          	auipc	a0,0x5
    800024ce:	0b650513          	addi	a0,a0,182 # 80007580 <syscalls+0x168>
    800024d2:	2fd020ef          	jal	ra,80004fce <printf>
  return 0;
    800024d6:	4501                	li	a0,0
}
    800024d8:	60a6                	ld	ra,72(sp)
    800024da:	6406                	ld	s0,64(sp)
    800024dc:	74e2                	ld	s1,56(sp)
    800024de:	7942                	ld	s2,48(sp)
    800024e0:	79a2                	ld	s3,40(sp)
    800024e2:	7a02                	ld	s4,32(sp)
    800024e4:	6ae2                	ld	s5,24(sp)
    800024e6:	6b42                	ld	s6,16(sp)
    800024e8:	6ba2                	ld	s7,8(sp)
    800024ea:	6161                	addi	sp,sp,80
    800024ec:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800024ee:	04000613          	li	a2,64
    800024f2:	4581                	li	a1,0
    800024f4:	854e                	mv	a0,s3
    800024f6:	c57fd0ef          	jal	ra,8000014c <memset>
      dip->type = type;
    800024fa:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800024fe:	854a                	mv	a0,s2
    80002500:	2d5000ef          	jal	ra,80002fd4 <log_write>
      brelse(bp);
    80002504:	854a                	mv	a0,s2
    80002506:	aabff0ef          	jal	ra,80001fb0 <brelse>
      return iget(dev, inum);
    8000250a:	85da                	mv	a1,s6
    8000250c:	8556                	mv	a0,s5
    8000250e:	de1ff0ef          	jal	ra,800022ee <iget>
    80002512:	b7d9                	j	800024d8 <ialloc+0x7a>

0000000080002514 <iupdate>:
{
    80002514:	1101                	addi	sp,sp,-32
    80002516:	ec06                	sd	ra,24(sp)
    80002518:	e822                	sd	s0,16(sp)
    8000251a:	e426                	sd	s1,8(sp)
    8000251c:	e04a                	sd	s2,0(sp)
    8000251e:	1000                	addi	s0,sp,32
    80002520:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002522:	415c                	lw	a5,4(a0)
    80002524:	0047d79b          	srliw	a5,a5,0x4
    80002528:	00014597          	auipc	a1,0x14
    8000252c:	9185a583          	lw	a1,-1768(a1) # 80015e40 <sb+0x18>
    80002530:	9dbd                	addw	a1,a1,a5
    80002532:	4108                	lw	a0,0(a0)
    80002534:	975ff0ef          	jal	ra,80001ea8 <bread>
    80002538:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000253a:	05850793          	addi	a5,a0,88
    8000253e:	40c8                	lw	a0,4(s1)
    80002540:	893d                	andi	a0,a0,15
    80002542:	051a                	slli	a0,a0,0x6
    80002544:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002546:	04449703          	lh	a4,68(s1)
    8000254a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000254e:	04649703          	lh	a4,70(s1)
    80002552:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002556:	04849703          	lh	a4,72(s1)
    8000255a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000255e:	04a49703          	lh	a4,74(s1)
    80002562:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002566:	44f8                	lw	a4,76(s1)
    80002568:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000256a:	03400613          	li	a2,52
    8000256e:	05048593          	addi	a1,s1,80
    80002572:	0531                	addi	a0,a0,12
    80002574:	c39fd0ef          	jal	ra,800001ac <memmove>
  log_write(bp);
    80002578:	854a                	mv	a0,s2
    8000257a:	25b000ef          	jal	ra,80002fd4 <log_write>
  brelse(bp);
    8000257e:	854a                	mv	a0,s2
    80002580:	a31ff0ef          	jal	ra,80001fb0 <brelse>
}
    80002584:	60e2                	ld	ra,24(sp)
    80002586:	6442                	ld	s0,16(sp)
    80002588:	64a2                	ld	s1,8(sp)
    8000258a:	6902                	ld	s2,0(sp)
    8000258c:	6105                	addi	sp,sp,32
    8000258e:	8082                	ret

0000000080002590 <idup>:
{
    80002590:	1101                	addi	sp,sp,-32
    80002592:	ec06                	sd	ra,24(sp)
    80002594:	e822                	sd	s0,16(sp)
    80002596:	e426                	sd	s1,8(sp)
    80002598:	1000                	addi	s0,sp,32
    8000259a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000259c:	00014517          	auipc	a0,0x14
    800025a0:	8ac50513          	addi	a0,a0,-1876 # 80015e48 <itable>
    800025a4:	7fb020ef          	jal	ra,8000559e <acquire>
  ip->ref++;
    800025a8:	449c                	lw	a5,8(s1)
    800025aa:	2785                	addiw	a5,a5,1
    800025ac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800025ae:	00014517          	auipc	a0,0x14
    800025b2:	89a50513          	addi	a0,a0,-1894 # 80015e48 <itable>
    800025b6:	080030ef          	jal	ra,80005636 <release>
}
    800025ba:	8526                	mv	a0,s1
    800025bc:	60e2                	ld	ra,24(sp)
    800025be:	6442                	ld	s0,16(sp)
    800025c0:	64a2                	ld	s1,8(sp)
    800025c2:	6105                	addi	sp,sp,32
    800025c4:	8082                	ret

00000000800025c6 <ilock>:
{
    800025c6:	1101                	addi	sp,sp,-32
    800025c8:	ec06                	sd	ra,24(sp)
    800025ca:	e822                	sd	s0,16(sp)
    800025cc:	e426                	sd	s1,8(sp)
    800025ce:	e04a                	sd	s2,0(sp)
    800025d0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800025d2:	c105                	beqz	a0,800025f2 <ilock+0x2c>
    800025d4:	84aa                	mv	s1,a0
    800025d6:	451c                	lw	a5,8(a0)
    800025d8:	00f05d63          	blez	a5,800025f2 <ilock+0x2c>
  acquiresleep(&ip->lock);
    800025dc:	0541                	addi	a0,a0,16
    800025de:	2ff000ef          	jal	ra,800030dc <acquiresleep>
  if(ip->valid == 0){
    800025e2:	40bc                	lw	a5,64(s1)
    800025e4:	cf89                	beqz	a5,800025fe <ilock+0x38>
}
    800025e6:	60e2                	ld	ra,24(sp)
    800025e8:	6442                	ld	s0,16(sp)
    800025ea:	64a2                	ld	s1,8(sp)
    800025ec:	6902                	ld	s2,0(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret
    panic("ilock");
    800025f2:	00005517          	auipc	a0,0x5
    800025f6:	fa650513          	addi	a0,a0,-90 # 80007598 <syscalls+0x180>
    800025fa:	489020ef          	jal	ra,80005282 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025fe:	40dc                	lw	a5,4(s1)
    80002600:	0047d79b          	srliw	a5,a5,0x4
    80002604:	00014597          	auipc	a1,0x14
    80002608:	83c5a583          	lw	a1,-1988(a1) # 80015e40 <sb+0x18>
    8000260c:	9dbd                	addw	a1,a1,a5
    8000260e:	4088                	lw	a0,0(s1)
    80002610:	899ff0ef          	jal	ra,80001ea8 <bread>
    80002614:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002616:	05850593          	addi	a1,a0,88
    8000261a:	40dc                	lw	a5,4(s1)
    8000261c:	8bbd                	andi	a5,a5,15
    8000261e:	079a                	slli	a5,a5,0x6
    80002620:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002622:	00059783          	lh	a5,0(a1)
    80002626:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000262a:	00259783          	lh	a5,2(a1)
    8000262e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002632:	00459783          	lh	a5,4(a1)
    80002636:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000263a:	00659783          	lh	a5,6(a1)
    8000263e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002642:	459c                	lw	a5,8(a1)
    80002644:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002646:	03400613          	li	a2,52
    8000264a:	05b1                	addi	a1,a1,12
    8000264c:	05048513          	addi	a0,s1,80
    80002650:	b5dfd0ef          	jal	ra,800001ac <memmove>
    brelse(bp);
    80002654:	854a                	mv	a0,s2
    80002656:	95bff0ef          	jal	ra,80001fb0 <brelse>
    ip->valid = 1;
    8000265a:	4785                	li	a5,1
    8000265c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000265e:	04449783          	lh	a5,68(s1)
    80002662:	f3d1                	bnez	a5,800025e6 <ilock+0x20>
      panic("ilock: no type");
    80002664:	00005517          	auipc	a0,0x5
    80002668:	f3c50513          	addi	a0,a0,-196 # 800075a0 <syscalls+0x188>
    8000266c:	417020ef          	jal	ra,80005282 <panic>

0000000080002670 <iunlock>:
{
    80002670:	1101                	addi	sp,sp,-32
    80002672:	ec06                	sd	ra,24(sp)
    80002674:	e822                	sd	s0,16(sp)
    80002676:	e426                	sd	s1,8(sp)
    80002678:	e04a                	sd	s2,0(sp)
    8000267a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000267c:	c505                	beqz	a0,800026a4 <iunlock+0x34>
    8000267e:	84aa                	mv	s1,a0
    80002680:	01050913          	addi	s2,a0,16
    80002684:	854a                	mv	a0,s2
    80002686:	2d5000ef          	jal	ra,8000315a <holdingsleep>
    8000268a:	cd09                	beqz	a0,800026a4 <iunlock+0x34>
    8000268c:	449c                	lw	a5,8(s1)
    8000268e:	00f05b63          	blez	a5,800026a4 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002692:	854a                	mv	a0,s2
    80002694:	28f000ef          	jal	ra,80003122 <releasesleep>
}
    80002698:	60e2                	ld	ra,24(sp)
    8000269a:	6442                	ld	s0,16(sp)
    8000269c:	64a2                	ld	s1,8(sp)
    8000269e:	6902                	ld	s2,0(sp)
    800026a0:	6105                	addi	sp,sp,32
    800026a2:	8082                	ret
    panic("iunlock");
    800026a4:	00005517          	auipc	a0,0x5
    800026a8:	f0c50513          	addi	a0,a0,-244 # 800075b0 <syscalls+0x198>
    800026ac:	3d7020ef          	jal	ra,80005282 <panic>

00000000800026b0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800026b0:	7179                	addi	sp,sp,-48
    800026b2:	f406                	sd	ra,40(sp)
    800026b4:	f022                	sd	s0,32(sp)
    800026b6:	ec26                	sd	s1,24(sp)
    800026b8:	e84a                	sd	s2,16(sp)
    800026ba:	e44e                	sd	s3,8(sp)
    800026bc:	e052                	sd	s4,0(sp)
    800026be:	1800                	addi	s0,sp,48
    800026c0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800026c2:	05050493          	addi	s1,a0,80
    800026c6:	08050913          	addi	s2,a0,128
    800026ca:	a021                	j	800026d2 <itrunc+0x22>
    800026cc:	0491                	addi	s1,s1,4
    800026ce:	01248b63          	beq	s1,s2,800026e4 <itrunc+0x34>
    if(ip->addrs[i]){
    800026d2:	408c                	lw	a1,0(s1)
    800026d4:	dde5                	beqz	a1,800026cc <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800026d6:	0009a503          	lw	a0,0(s3)
    800026da:	9c9ff0ef          	jal	ra,800020a2 <bfree>
      ip->addrs[i] = 0;
    800026de:	0004a023          	sw	zero,0(s1)
    800026e2:	b7ed                	j	800026cc <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800026e4:	0809a583          	lw	a1,128(s3)
    800026e8:	ed91                	bnez	a1,80002704 <itrunc+0x54>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800026ea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800026ee:	854e                	mv	a0,s3
    800026f0:	e25ff0ef          	jal	ra,80002514 <iupdate>
}
    800026f4:	70a2                	ld	ra,40(sp)
    800026f6:	7402                	ld	s0,32(sp)
    800026f8:	64e2                	ld	s1,24(sp)
    800026fa:	6942                	ld	s2,16(sp)
    800026fc:	69a2                	ld	s3,8(sp)
    800026fe:	6a02                	ld	s4,0(sp)
    80002700:	6145                	addi	sp,sp,48
    80002702:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002704:	0009a503          	lw	a0,0(s3)
    80002708:	fa0ff0ef          	jal	ra,80001ea8 <bread>
    8000270c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000270e:	05850493          	addi	s1,a0,88
    80002712:	45850913          	addi	s2,a0,1112
    80002716:	a801                	j	80002726 <itrunc+0x76>
        bfree(ip->dev, a[j]);
    80002718:	0009a503          	lw	a0,0(s3)
    8000271c:	987ff0ef          	jal	ra,800020a2 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002720:	0491                	addi	s1,s1,4
    80002722:	01248563          	beq	s1,s2,8000272c <itrunc+0x7c>
      if(a[j])
    80002726:	408c                	lw	a1,0(s1)
    80002728:	dde5                	beqz	a1,80002720 <itrunc+0x70>
    8000272a:	b7fd                	j	80002718 <itrunc+0x68>
    brelse(bp);
    8000272c:	8552                	mv	a0,s4
    8000272e:	883ff0ef          	jal	ra,80001fb0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002732:	0809a583          	lw	a1,128(s3)
    80002736:	0009a503          	lw	a0,0(s3)
    8000273a:	969ff0ef          	jal	ra,800020a2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000273e:	0809a023          	sw	zero,128(s3)
    80002742:	b765                	j	800026ea <itrunc+0x3a>

0000000080002744 <iput>:
{
    80002744:	1101                	addi	sp,sp,-32
    80002746:	ec06                	sd	ra,24(sp)
    80002748:	e822                	sd	s0,16(sp)
    8000274a:	e426                	sd	s1,8(sp)
    8000274c:	e04a                	sd	s2,0(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002752:	00013517          	auipc	a0,0x13
    80002756:	6f650513          	addi	a0,a0,1782 # 80015e48 <itable>
    8000275a:	645020ef          	jal	ra,8000559e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000275e:	4498                	lw	a4,8(s1)
    80002760:	4785                	li	a5,1
    80002762:	02f70163          	beq	a4,a5,80002784 <iput+0x40>
  ip->ref--;
    80002766:	449c                	lw	a5,8(s1)
    80002768:	37fd                	addiw	a5,a5,-1
    8000276a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000276c:	00013517          	auipc	a0,0x13
    80002770:	6dc50513          	addi	a0,a0,1756 # 80015e48 <itable>
    80002774:	6c3020ef          	jal	ra,80005636 <release>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6902                	ld	s2,0(sp)
    80002780:	6105                	addi	sp,sp,32
    80002782:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002784:	40bc                	lw	a5,64(s1)
    80002786:	d3e5                	beqz	a5,80002766 <iput+0x22>
    80002788:	04a49783          	lh	a5,74(s1)
    8000278c:	ffe9                	bnez	a5,80002766 <iput+0x22>
    acquiresleep(&ip->lock);
    8000278e:	01048913          	addi	s2,s1,16
    80002792:	854a                	mv	a0,s2
    80002794:	149000ef          	jal	ra,800030dc <acquiresleep>
    release(&itable.lock);
    80002798:	00013517          	auipc	a0,0x13
    8000279c:	6b050513          	addi	a0,a0,1712 # 80015e48 <itable>
    800027a0:	697020ef          	jal	ra,80005636 <release>
    itrunc(ip);
    800027a4:	8526                	mv	a0,s1
    800027a6:	f0bff0ef          	jal	ra,800026b0 <itrunc>
    ip->type = 0;
    800027aa:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800027ae:	8526                	mv	a0,s1
    800027b0:	d65ff0ef          	jal	ra,80002514 <iupdate>
    ip->valid = 0;
    800027b4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800027b8:	854a                	mv	a0,s2
    800027ba:	169000ef          	jal	ra,80003122 <releasesleep>
    acquire(&itable.lock);
    800027be:	00013517          	auipc	a0,0x13
    800027c2:	68a50513          	addi	a0,a0,1674 # 80015e48 <itable>
    800027c6:	5d9020ef          	jal	ra,8000559e <acquire>
    800027ca:	bf71                	j	80002766 <iput+0x22>

00000000800027cc <iunlockput>:
{
    800027cc:	1101                	addi	sp,sp,-32
    800027ce:	ec06                	sd	ra,24(sp)
    800027d0:	e822                	sd	s0,16(sp)
    800027d2:	e426                	sd	s1,8(sp)
    800027d4:	1000                	addi	s0,sp,32
    800027d6:	84aa                	mv	s1,a0
  iunlock(ip);
    800027d8:	e99ff0ef          	jal	ra,80002670 <iunlock>
  iput(ip);
    800027dc:	8526                	mv	a0,s1
    800027de:	f67ff0ef          	jal	ra,80002744 <iput>
}
    800027e2:	60e2                	ld	ra,24(sp)
    800027e4:	6442                	ld	s0,16(sp)
    800027e6:	64a2                	ld	s1,8(sp)
    800027e8:	6105                	addi	sp,sp,32
    800027ea:	8082                	ret

00000000800027ec <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800027ec:	1141                	addi	sp,sp,-16
    800027ee:	e422                	sd	s0,8(sp)
    800027f0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800027f2:	411c                	lw	a5,0(a0)
    800027f4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800027f6:	415c                	lw	a5,4(a0)
    800027f8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800027fa:	04451783          	lh	a5,68(a0)
    800027fe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002802:	04a51783          	lh	a5,74(a0)
    80002806:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000280a:	04c56783          	lwu	a5,76(a0)
    8000280e:	e99c                	sd	a5,16(a1)
}
    80002810:	6422                	ld	s0,8(sp)
    80002812:	0141                	addi	sp,sp,16
    80002814:	8082                	ret

0000000080002816 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002816:	457c                	lw	a5,76(a0)
    80002818:	0cd7ef63          	bltu	a5,a3,800028f6 <readi+0xe0>
{
    8000281c:	7159                	addi	sp,sp,-112
    8000281e:	f486                	sd	ra,104(sp)
    80002820:	f0a2                	sd	s0,96(sp)
    80002822:	eca6                	sd	s1,88(sp)
    80002824:	e8ca                	sd	s2,80(sp)
    80002826:	e4ce                	sd	s3,72(sp)
    80002828:	e0d2                	sd	s4,64(sp)
    8000282a:	fc56                	sd	s5,56(sp)
    8000282c:	f85a                	sd	s6,48(sp)
    8000282e:	f45e                	sd	s7,40(sp)
    80002830:	f062                	sd	s8,32(sp)
    80002832:	ec66                	sd	s9,24(sp)
    80002834:	e86a                	sd	s10,16(sp)
    80002836:	e46e                	sd	s11,8(sp)
    80002838:	1880                	addi	s0,sp,112
    8000283a:	8b2a                	mv	s6,a0
    8000283c:	8bae                	mv	s7,a1
    8000283e:	8a32                	mv	s4,a2
    80002840:	84b6                	mv	s1,a3
    80002842:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002844:	9f35                	addw	a4,a4,a3
    return 0;
    80002846:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002848:	08d76663          	bltu	a4,a3,800028d4 <readi+0xbe>
  if(off + n > ip->size)
    8000284c:	00e7f463          	bgeu	a5,a4,80002854 <readi+0x3e>
    n = ip->size - off;
    80002850:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002854:	080a8f63          	beqz	s5,800028f2 <readi+0xdc>
    80002858:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000285a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000285e:	5c7d                	li	s8,-1
    80002860:	a80d                	j	80002892 <readi+0x7c>
    80002862:	020d1d93          	slli	s11,s10,0x20
    80002866:	020ddd93          	srli	s11,s11,0x20
    8000286a:	05890613          	addi	a2,s2,88
    8000286e:	86ee                	mv	a3,s11
    80002870:	963a                	add	a2,a2,a4
    80002872:	85d2                	mv	a1,s4
    80002874:	855e                	mv	a0,s7
    80002876:	dbffe0ef          	jal	ra,80001634 <either_copyout>
    8000287a:	05850763          	beq	a0,s8,800028c8 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000287e:	854a                	mv	a0,s2
    80002880:	f30ff0ef          	jal	ra,80001fb0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002884:	013d09bb          	addw	s3,s10,s3
    80002888:	009d04bb          	addw	s1,s10,s1
    8000288c:	9a6e                	add	s4,s4,s11
    8000288e:	0559f163          	bgeu	s3,s5,800028d0 <readi+0xba>
    uint addr = bmap(ip, off/BSIZE);
    80002892:	00a4d59b          	srliw	a1,s1,0xa
    80002896:	855a                	mv	a0,s6
    80002898:	98bff0ef          	jal	ra,80002222 <bmap>
    8000289c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800028a0:	c985                	beqz	a1,800028d0 <readi+0xba>
    bp = bread(ip->dev, addr);
    800028a2:	000b2503          	lw	a0,0(s6)
    800028a6:	e02ff0ef          	jal	ra,80001ea8 <bread>
    800028aa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800028ac:	3ff4f713          	andi	a4,s1,1023
    800028b0:	40ec87bb          	subw	a5,s9,a4
    800028b4:	413a86bb          	subw	a3,s5,s3
    800028b8:	8d3e                	mv	s10,a5
    800028ba:	2781                	sext.w	a5,a5
    800028bc:	0006861b          	sext.w	a2,a3
    800028c0:	faf671e3          	bgeu	a2,a5,80002862 <readi+0x4c>
    800028c4:	8d36                	mv	s10,a3
    800028c6:	bf71                	j	80002862 <readi+0x4c>
      brelse(bp);
    800028c8:	854a                	mv	a0,s2
    800028ca:	ee6ff0ef          	jal	ra,80001fb0 <brelse>
      tot = -1;
    800028ce:	59fd                	li	s3,-1
  }
  return tot;
    800028d0:	0009851b          	sext.w	a0,s3
}
    800028d4:	70a6                	ld	ra,104(sp)
    800028d6:	7406                	ld	s0,96(sp)
    800028d8:	64e6                	ld	s1,88(sp)
    800028da:	6946                	ld	s2,80(sp)
    800028dc:	69a6                	ld	s3,72(sp)
    800028de:	6a06                	ld	s4,64(sp)
    800028e0:	7ae2                	ld	s5,56(sp)
    800028e2:	7b42                	ld	s6,48(sp)
    800028e4:	7ba2                	ld	s7,40(sp)
    800028e6:	7c02                	ld	s8,32(sp)
    800028e8:	6ce2                	ld	s9,24(sp)
    800028ea:	6d42                	ld	s10,16(sp)
    800028ec:	6da2                	ld	s11,8(sp)
    800028ee:	6165                	addi	sp,sp,112
    800028f0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800028f2:	89d6                	mv	s3,s5
    800028f4:	bff1                	j	800028d0 <readi+0xba>
    return 0;
    800028f6:	4501                	li	a0,0
}
    800028f8:	8082                	ret

00000000800028fa <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800028fa:	457c                	lw	a5,76(a0)
    800028fc:	0ed7ea63          	bltu	a5,a3,800029f0 <writei+0xf6>
{
    80002900:	7159                	addi	sp,sp,-112
    80002902:	f486                	sd	ra,104(sp)
    80002904:	f0a2                	sd	s0,96(sp)
    80002906:	eca6                	sd	s1,88(sp)
    80002908:	e8ca                	sd	s2,80(sp)
    8000290a:	e4ce                	sd	s3,72(sp)
    8000290c:	e0d2                	sd	s4,64(sp)
    8000290e:	fc56                	sd	s5,56(sp)
    80002910:	f85a                	sd	s6,48(sp)
    80002912:	f45e                	sd	s7,40(sp)
    80002914:	f062                	sd	s8,32(sp)
    80002916:	ec66                	sd	s9,24(sp)
    80002918:	e86a                	sd	s10,16(sp)
    8000291a:	e46e                	sd	s11,8(sp)
    8000291c:	1880                	addi	s0,sp,112
    8000291e:	8aaa                	mv	s5,a0
    80002920:	8bae                	mv	s7,a1
    80002922:	8a32                	mv	s4,a2
    80002924:	8936                	mv	s2,a3
    80002926:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002928:	00e687bb          	addw	a5,a3,a4
    8000292c:	0cd7e463          	bltu	a5,a3,800029f4 <writei+0xfa>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002930:	00043737          	lui	a4,0x43
    80002934:	0cf76263          	bltu	a4,a5,800029f8 <writei+0xfe>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002938:	0a0b0a63          	beqz	s6,800029ec <writei+0xf2>
    8000293c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000293e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002942:	5c7d                	li	s8,-1
    80002944:	a825                	j	8000297c <writei+0x82>
    80002946:	020d1d93          	slli	s11,s10,0x20
    8000294a:	020ddd93          	srli	s11,s11,0x20
    8000294e:	05848513          	addi	a0,s1,88
    80002952:	86ee                	mv	a3,s11
    80002954:	8652                	mv	a2,s4
    80002956:	85de                	mv	a1,s7
    80002958:	953a                	add	a0,a0,a4
    8000295a:	d25fe0ef          	jal	ra,8000167e <either_copyin>
    8000295e:	05850a63          	beq	a0,s8,800029b2 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002962:	8526                	mv	a0,s1
    80002964:	670000ef          	jal	ra,80002fd4 <log_write>
    brelse(bp);
    80002968:	8526                	mv	a0,s1
    8000296a:	e46ff0ef          	jal	ra,80001fb0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000296e:	013d09bb          	addw	s3,s10,s3
    80002972:	012d093b          	addw	s2,s10,s2
    80002976:	9a6e                	add	s4,s4,s11
    80002978:	0569f063          	bgeu	s3,s6,800029b8 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000297c:	00a9559b          	srliw	a1,s2,0xa
    80002980:	8556                	mv	a0,s5
    80002982:	8a1ff0ef          	jal	ra,80002222 <bmap>
    80002986:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000298a:	c59d                	beqz	a1,800029b8 <writei+0xbe>
    bp = bread(ip->dev, addr);
    8000298c:	000aa503          	lw	a0,0(s5)
    80002990:	d18ff0ef          	jal	ra,80001ea8 <bread>
    80002994:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002996:	3ff97713          	andi	a4,s2,1023
    8000299a:	40ec87bb          	subw	a5,s9,a4
    8000299e:	413b06bb          	subw	a3,s6,s3
    800029a2:	8d3e                	mv	s10,a5
    800029a4:	2781                	sext.w	a5,a5
    800029a6:	0006861b          	sext.w	a2,a3
    800029aa:	f8f67ee3          	bgeu	a2,a5,80002946 <writei+0x4c>
    800029ae:	8d36                	mv	s10,a3
    800029b0:	bf59                	j	80002946 <writei+0x4c>
      brelse(bp);
    800029b2:	8526                	mv	a0,s1
    800029b4:	dfcff0ef          	jal	ra,80001fb0 <brelse>
  }

  if(off > ip->size)
    800029b8:	04caa783          	lw	a5,76(s5)
    800029bc:	0127f463          	bgeu	a5,s2,800029c4 <writei+0xca>
    ip->size = off;
    800029c0:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800029c4:	8556                	mv	a0,s5
    800029c6:	b4fff0ef          	jal	ra,80002514 <iupdate>

  return tot;
    800029ca:	0009851b          	sext.w	a0,s3
}
    800029ce:	70a6                	ld	ra,104(sp)
    800029d0:	7406                	ld	s0,96(sp)
    800029d2:	64e6                	ld	s1,88(sp)
    800029d4:	6946                	ld	s2,80(sp)
    800029d6:	69a6                	ld	s3,72(sp)
    800029d8:	6a06                	ld	s4,64(sp)
    800029da:	7ae2                	ld	s5,56(sp)
    800029dc:	7b42                	ld	s6,48(sp)
    800029de:	7ba2                	ld	s7,40(sp)
    800029e0:	7c02                	ld	s8,32(sp)
    800029e2:	6ce2                	ld	s9,24(sp)
    800029e4:	6d42                	ld	s10,16(sp)
    800029e6:	6da2                	ld	s11,8(sp)
    800029e8:	6165                	addi	sp,sp,112
    800029ea:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800029ec:	89da                	mv	s3,s6
    800029ee:	bfd9                	j	800029c4 <writei+0xca>
    return -1;
    800029f0:	557d                	li	a0,-1
}
    800029f2:	8082                	ret
    return -1;
    800029f4:	557d                	li	a0,-1
    800029f6:	bfe1                	j	800029ce <writei+0xd4>
    return -1;
    800029f8:	557d                	li	a0,-1
    800029fa:	bfd1                	j	800029ce <writei+0xd4>

00000000800029fc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800029fc:	1141                	addi	sp,sp,-16
    800029fe:	e406                	sd	ra,8(sp)
    80002a00:	e022                	sd	s0,0(sp)
    80002a02:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002a04:	4639                	li	a2,14
    80002a06:	81bfd0ef          	jal	ra,80000220 <strncmp>
}
    80002a0a:	60a2                	ld	ra,8(sp)
    80002a0c:	6402                	ld	s0,0(sp)
    80002a0e:	0141                	addi	sp,sp,16
    80002a10:	8082                	ret

0000000080002a12 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002a12:	7139                	addi	sp,sp,-64
    80002a14:	fc06                	sd	ra,56(sp)
    80002a16:	f822                	sd	s0,48(sp)
    80002a18:	f426                	sd	s1,40(sp)
    80002a1a:	f04a                	sd	s2,32(sp)
    80002a1c:	ec4e                	sd	s3,24(sp)
    80002a1e:	e852                	sd	s4,16(sp)
    80002a20:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002a22:	04451703          	lh	a4,68(a0)
    80002a26:	4785                	li	a5,1
    80002a28:	00f71a63          	bne	a4,a5,80002a3c <dirlookup+0x2a>
    80002a2c:	892a                	mv	s2,a0
    80002a2e:	89ae                	mv	s3,a1
    80002a30:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a32:	457c                	lw	a5,76(a0)
    80002a34:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002a36:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a38:	e39d                	bnez	a5,80002a5e <dirlookup+0x4c>
    80002a3a:	a095                	j	80002a9e <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002a3c:	00005517          	auipc	a0,0x5
    80002a40:	b7c50513          	addi	a0,a0,-1156 # 800075b8 <syscalls+0x1a0>
    80002a44:	03f020ef          	jal	ra,80005282 <panic>
      panic("dirlookup read");
    80002a48:	00005517          	auipc	a0,0x5
    80002a4c:	b8850513          	addi	a0,a0,-1144 # 800075d0 <syscalls+0x1b8>
    80002a50:	033020ef          	jal	ra,80005282 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002a54:	24c1                	addiw	s1,s1,16
    80002a56:	04c92783          	lw	a5,76(s2)
    80002a5a:	04f4f163          	bgeu	s1,a5,80002a9c <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002a5e:	4741                	li	a4,16
    80002a60:	86a6                	mv	a3,s1
    80002a62:	fc040613          	addi	a2,s0,-64
    80002a66:	4581                	li	a1,0
    80002a68:	854a                	mv	a0,s2
    80002a6a:	dadff0ef          	jal	ra,80002816 <readi>
    80002a6e:	47c1                	li	a5,16
    80002a70:	fcf51ce3          	bne	a0,a5,80002a48 <dirlookup+0x36>
    if(de.inum == 0)
    80002a74:	fc045783          	lhu	a5,-64(s0)
    80002a78:	dff1                	beqz	a5,80002a54 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002a7a:	fc240593          	addi	a1,s0,-62
    80002a7e:	854e                	mv	a0,s3
    80002a80:	f7dff0ef          	jal	ra,800029fc <namecmp>
    80002a84:	f961                	bnez	a0,80002a54 <dirlookup+0x42>
      if(poff)
    80002a86:	000a0463          	beqz	s4,80002a8e <dirlookup+0x7c>
        *poff = off;
    80002a8a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002a8e:	fc045583          	lhu	a1,-64(s0)
    80002a92:	00092503          	lw	a0,0(s2)
    80002a96:	859ff0ef          	jal	ra,800022ee <iget>
    80002a9a:	a011                	j	80002a9e <dirlookup+0x8c>
  return 0;
    80002a9c:	4501                	li	a0,0
}
    80002a9e:	70e2                	ld	ra,56(sp)
    80002aa0:	7442                	ld	s0,48(sp)
    80002aa2:	74a2                	ld	s1,40(sp)
    80002aa4:	7902                	ld	s2,32(sp)
    80002aa6:	69e2                	ld	s3,24(sp)
    80002aa8:	6a42                	ld	s4,16(sp)
    80002aaa:	6121                	addi	sp,sp,64
    80002aac:	8082                	ret

0000000080002aae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002aae:	711d                	addi	sp,sp,-96
    80002ab0:	ec86                	sd	ra,88(sp)
    80002ab2:	e8a2                	sd	s0,80(sp)
    80002ab4:	e4a6                	sd	s1,72(sp)
    80002ab6:	e0ca                	sd	s2,64(sp)
    80002ab8:	fc4e                	sd	s3,56(sp)
    80002aba:	f852                	sd	s4,48(sp)
    80002abc:	f456                	sd	s5,40(sp)
    80002abe:	f05a                	sd	s6,32(sp)
    80002ac0:	ec5e                	sd	s7,24(sp)
    80002ac2:	e862                	sd	s8,16(sp)
    80002ac4:	e466                	sd	s9,8(sp)
    80002ac6:	1080                	addi	s0,sp,96
    80002ac8:	84aa                	mv	s1,a0
    80002aca:	8b2e                	mv	s6,a1
    80002acc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002ace:	00054703          	lbu	a4,0(a0)
    80002ad2:	02f00793          	li	a5,47
    80002ad6:	00f70f63          	beq	a4,a5,80002af4 <namex+0x46>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002ada:	a36fe0ef          	jal	ra,80000d10 <myproc>
    80002ade:	15053503          	ld	a0,336(a0)
    80002ae2:	aafff0ef          	jal	ra,80002590 <idup>
    80002ae6:	89aa                	mv	s3,a0
  while(*path == '/')
    80002ae8:	02f00913          	li	s2,47
  len = path - s;
    80002aec:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80002aee:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002af0:	4c05                	li	s8,1
    80002af2:	a861                	j	80002b8a <namex+0xdc>
    ip = iget(ROOTDEV, ROOTINO);
    80002af4:	4585                	li	a1,1
    80002af6:	4505                	li	a0,1
    80002af8:	ff6ff0ef          	jal	ra,800022ee <iget>
    80002afc:	89aa                	mv	s3,a0
    80002afe:	b7ed                	j	80002ae8 <namex+0x3a>
      iunlockput(ip);
    80002b00:	854e                	mv	a0,s3
    80002b02:	ccbff0ef          	jal	ra,800027cc <iunlockput>
      return 0;
    80002b06:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002b08:	854e                	mv	a0,s3
    80002b0a:	60e6                	ld	ra,88(sp)
    80002b0c:	6446                	ld	s0,80(sp)
    80002b0e:	64a6                	ld	s1,72(sp)
    80002b10:	6906                	ld	s2,64(sp)
    80002b12:	79e2                	ld	s3,56(sp)
    80002b14:	7a42                	ld	s4,48(sp)
    80002b16:	7aa2                	ld	s5,40(sp)
    80002b18:	7b02                	ld	s6,32(sp)
    80002b1a:	6be2                	ld	s7,24(sp)
    80002b1c:	6c42                	ld	s8,16(sp)
    80002b1e:	6ca2                	ld	s9,8(sp)
    80002b20:	6125                	addi	sp,sp,96
    80002b22:	8082                	ret
      iunlock(ip);
    80002b24:	854e                	mv	a0,s3
    80002b26:	b4bff0ef          	jal	ra,80002670 <iunlock>
      return ip;
    80002b2a:	bff9                	j	80002b08 <namex+0x5a>
      iunlockput(ip);
    80002b2c:	854e                	mv	a0,s3
    80002b2e:	c9fff0ef          	jal	ra,800027cc <iunlockput>
      return 0;
    80002b32:	89d2                	mv	s3,s4
    80002b34:	bfd1                	j	80002b08 <namex+0x5a>
  len = path - s;
    80002b36:	40b48633          	sub	a2,s1,a1
    80002b3a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80002b3e:	074cdc63          	bge	s9,s4,80002bb6 <namex+0x108>
    memmove(name, s, DIRSIZ);
    80002b42:	4639                	li	a2,14
    80002b44:	8556                	mv	a0,s5
    80002b46:	e66fd0ef          	jal	ra,800001ac <memmove>
  while(*path == '/')
    80002b4a:	0004c783          	lbu	a5,0(s1)
    80002b4e:	01279763          	bne	a5,s2,80002b5c <namex+0xae>
    path++;
    80002b52:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002b54:	0004c783          	lbu	a5,0(s1)
    80002b58:	ff278de3          	beq	a5,s2,80002b52 <namex+0xa4>
    ilock(ip);
    80002b5c:	854e                	mv	a0,s3
    80002b5e:	a69ff0ef          	jal	ra,800025c6 <ilock>
    if(ip->type != T_DIR){
    80002b62:	04499783          	lh	a5,68(s3)
    80002b66:	f9879de3          	bne	a5,s8,80002b00 <namex+0x52>
    if(nameiparent && *path == '\0'){
    80002b6a:	000b0563          	beqz	s6,80002b74 <namex+0xc6>
    80002b6e:	0004c783          	lbu	a5,0(s1)
    80002b72:	dbcd                	beqz	a5,80002b24 <namex+0x76>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002b74:	865e                	mv	a2,s7
    80002b76:	85d6                	mv	a1,s5
    80002b78:	854e                	mv	a0,s3
    80002b7a:	e99ff0ef          	jal	ra,80002a12 <dirlookup>
    80002b7e:	8a2a                	mv	s4,a0
    80002b80:	d555                	beqz	a0,80002b2c <namex+0x7e>
    iunlockput(ip);
    80002b82:	854e                	mv	a0,s3
    80002b84:	c49ff0ef          	jal	ra,800027cc <iunlockput>
    ip = next;
    80002b88:	89d2                	mv	s3,s4
  while(*path == '/')
    80002b8a:	0004c783          	lbu	a5,0(s1)
    80002b8e:	05279363          	bne	a5,s2,80002bd4 <namex+0x126>
    path++;
    80002b92:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002b94:	0004c783          	lbu	a5,0(s1)
    80002b98:	ff278de3          	beq	a5,s2,80002b92 <namex+0xe4>
  if(*path == 0)
    80002b9c:	c78d                	beqz	a5,80002bc6 <namex+0x118>
    path++;
    80002b9e:	85a6                	mv	a1,s1
  len = path - s;
    80002ba0:	8a5e                	mv	s4,s7
    80002ba2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80002ba4:	01278963          	beq	a5,s2,80002bb6 <namex+0x108>
    80002ba8:	d7d9                	beqz	a5,80002b36 <namex+0x88>
    path++;
    80002baa:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80002bac:	0004c783          	lbu	a5,0(s1)
    80002bb0:	ff279ce3          	bne	a5,s2,80002ba8 <namex+0xfa>
    80002bb4:	b749                	j	80002b36 <namex+0x88>
    memmove(name, s, len);
    80002bb6:	2601                	sext.w	a2,a2
    80002bb8:	8556                	mv	a0,s5
    80002bba:	df2fd0ef          	jal	ra,800001ac <memmove>
    name[len] = 0;
    80002bbe:	9a56                	add	s4,s4,s5
    80002bc0:	000a0023          	sb	zero,0(s4)
    80002bc4:	b759                	j	80002b4a <namex+0x9c>
  if(nameiparent){
    80002bc6:	f40b01e3          	beqz	s6,80002b08 <namex+0x5a>
    iput(ip);
    80002bca:	854e                	mv	a0,s3
    80002bcc:	b79ff0ef          	jal	ra,80002744 <iput>
    return 0;
    80002bd0:	4981                	li	s3,0
    80002bd2:	bf1d                	j	80002b08 <namex+0x5a>
  if(*path == 0)
    80002bd4:	dbed                	beqz	a5,80002bc6 <namex+0x118>
  while(*path != '/' && *path != 0)
    80002bd6:	0004c783          	lbu	a5,0(s1)
    80002bda:	85a6                	mv	a1,s1
    80002bdc:	b7f1                	j	80002ba8 <namex+0xfa>

0000000080002bde <dirlink>:
{
    80002bde:	7139                	addi	sp,sp,-64
    80002be0:	fc06                	sd	ra,56(sp)
    80002be2:	f822                	sd	s0,48(sp)
    80002be4:	f426                	sd	s1,40(sp)
    80002be6:	f04a                	sd	s2,32(sp)
    80002be8:	ec4e                	sd	s3,24(sp)
    80002bea:	e852                	sd	s4,16(sp)
    80002bec:	0080                	addi	s0,sp,64
    80002bee:	892a                	mv	s2,a0
    80002bf0:	8a2e                	mv	s4,a1
    80002bf2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002bf4:	4601                	li	a2,0
    80002bf6:	e1dff0ef          	jal	ra,80002a12 <dirlookup>
    80002bfa:	e52d                	bnez	a0,80002c64 <dirlink+0x86>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bfc:	04c92483          	lw	s1,76(s2)
    80002c00:	c48d                	beqz	s1,80002c2a <dirlink+0x4c>
    80002c02:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c04:	4741                	li	a4,16
    80002c06:	86a6                	mv	a3,s1
    80002c08:	fc040613          	addi	a2,s0,-64
    80002c0c:	4581                	li	a1,0
    80002c0e:	854a                	mv	a0,s2
    80002c10:	c07ff0ef          	jal	ra,80002816 <readi>
    80002c14:	47c1                	li	a5,16
    80002c16:	04f51b63          	bne	a0,a5,80002c6c <dirlink+0x8e>
    if(de.inum == 0)
    80002c1a:	fc045783          	lhu	a5,-64(s0)
    80002c1e:	c791                	beqz	a5,80002c2a <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c20:	24c1                	addiw	s1,s1,16
    80002c22:	04c92783          	lw	a5,76(s2)
    80002c26:	fcf4efe3          	bltu	s1,a5,80002c04 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002c2a:	4639                	li	a2,14
    80002c2c:	85d2                	mv	a1,s4
    80002c2e:	fc240513          	addi	a0,s0,-62
    80002c32:	e2afd0ef          	jal	ra,8000025c <strncpy>
  de.inum = inum;
    80002c36:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c3a:	4741                	li	a4,16
    80002c3c:	86a6                	mv	a3,s1
    80002c3e:	fc040613          	addi	a2,s0,-64
    80002c42:	4581                	li	a1,0
    80002c44:	854a                	mv	a0,s2
    80002c46:	cb5ff0ef          	jal	ra,800028fa <writei>
    80002c4a:	1541                	addi	a0,a0,-16
    80002c4c:	00a03533          	snez	a0,a0
    80002c50:	40a00533          	neg	a0,a0
}
    80002c54:	70e2                	ld	ra,56(sp)
    80002c56:	7442                	ld	s0,48(sp)
    80002c58:	74a2                	ld	s1,40(sp)
    80002c5a:	7902                	ld	s2,32(sp)
    80002c5c:	69e2                	ld	s3,24(sp)
    80002c5e:	6a42                	ld	s4,16(sp)
    80002c60:	6121                	addi	sp,sp,64
    80002c62:	8082                	ret
    iput(ip);
    80002c64:	ae1ff0ef          	jal	ra,80002744 <iput>
    return -1;
    80002c68:	557d                	li	a0,-1
    80002c6a:	b7ed                	j	80002c54 <dirlink+0x76>
      panic("dirlink read");
    80002c6c:	00005517          	auipc	a0,0x5
    80002c70:	97450513          	addi	a0,a0,-1676 # 800075e0 <syscalls+0x1c8>
    80002c74:	60e020ef          	jal	ra,80005282 <panic>

0000000080002c78 <namei>:

struct inode*
namei(char *path)
{
    80002c78:	1101                	addi	sp,sp,-32
    80002c7a:	ec06                	sd	ra,24(sp)
    80002c7c:	e822                	sd	s0,16(sp)
    80002c7e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002c80:	fe040613          	addi	a2,s0,-32
    80002c84:	4581                	li	a1,0
    80002c86:	e29ff0ef          	jal	ra,80002aae <namex>
}
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	6105                	addi	sp,sp,32
    80002c90:	8082                	ret

0000000080002c92 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002c92:	1141                	addi	sp,sp,-16
    80002c94:	e406                	sd	ra,8(sp)
    80002c96:	e022                	sd	s0,0(sp)
    80002c98:	0800                	addi	s0,sp,16
    80002c9a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002c9c:	4585                	li	a1,1
    80002c9e:	e11ff0ef          	jal	ra,80002aae <namex>
}
    80002ca2:	60a2                	ld	ra,8(sp)
    80002ca4:	6402                	ld	s0,0(sp)
    80002ca6:	0141                	addi	sp,sp,16
    80002ca8:	8082                	ret

0000000080002caa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002caa:	1101                	addi	sp,sp,-32
    80002cac:	ec06                	sd	ra,24(sp)
    80002cae:	e822                	sd	s0,16(sp)
    80002cb0:	e426                	sd	s1,8(sp)
    80002cb2:	e04a                	sd	s2,0(sp)
    80002cb4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002cb6:	00015917          	auipc	s2,0x15
    80002cba:	c3a90913          	addi	s2,s2,-966 # 800178f0 <log>
    80002cbe:	01892583          	lw	a1,24(s2)
    80002cc2:	02892503          	lw	a0,40(s2)
    80002cc6:	9e2ff0ef          	jal	ra,80001ea8 <bread>
    80002cca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002ccc:	02c92683          	lw	a3,44(s2)
    80002cd0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002cd2:	02d05763          	blez	a3,80002d00 <write_head+0x56>
    80002cd6:	00015797          	auipc	a5,0x15
    80002cda:	c4a78793          	addi	a5,a5,-950 # 80017920 <log+0x30>
    80002cde:	05c50713          	addi	a4,a0,92
    80002ce2:	36fd                	addiw	a3,a3,-1
    80002ce4:	1682                	slli	a3,a3,0x20
    80002ce6:	9281                	srli	a3,a3,0x20
    80002ce8:	068a                	slli	a3,a3,0x2
    80002cea:	00015617          	auipc	a2,0x15
    80002cee:	c3a60613          	addi	a2,a2,-966 # 80017924 <log+0x34>
    80002cf2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80002cf4:	4390                	lw	a2,0(a5)
    80002cf6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002cf8:	0791                	addi	a5,a5,4
    80002cfa:	0711                	addi	a4,a4,4
    80002cfc:	fed79ce3          	bne	a5,a3,80002cf4 <write_head+0x4a>
  }
  bwrite(buf);
    80002d00:	8526                	mv	a0,s1
    80002d02:	a7cff0ef          	jal	ra,80001f7e <bwrite>
  brelse(buf);
    80002d06:	8526                	mv	a0,s1
    80002d08:	aa8ff0ef          	jal	ra,80001fb0 <brelse>
}
    80002d0c:	60e2                	ld	ra,24(sp)
    80002d0e:	6442                	ld	s0,16(sp)
    80002d10:	64a2                	ld	s1,8(sp)
    80002d12:	6902                	ld	s2,0(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret

0000000080002d18 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002d18:	00015797          	auipc	a5,0x15
    80002d1c:	c047a783          	lw	a5,-1020(a5) # 8001791c <log+0x2c>
    80002d20:	08f05f63          	blez	a5,80002dbe <install_trans+0xa6>
{
    80002d24:	7139                	addi	sp,sp,-64
    80002d26:	fc06                	sd	ra,56(sp)
    80002d28:	f822                	sd	s0,48(sp)
    80002d2a:	f426                	sd	s1,40(sp)
    80002d2c:	f04a                	sd	s2,32(sp)
    80002d2e:	ec4e                	sd	s3,24(sp)
    80002d30:	e852                	sd	s4,16(sp)
    80002d32:	e456                	sd	s5,8(sp)
    80002d34:	e05a                	sd	s6,0(sp)
    80002d36:	0080                	addi	s0,sp,64
    80002d38:	8b2a                	mv	s6,a0
    80002d3a:	00015a97          	auipc	s5,0x15
    80002d3e:	be6a8a93          	addi	s5,s5,-1050 # 80017920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002d42:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002d44:	00015997          	auipc	s3,0x15
    80002d48:	bac98993          	addi	s3,s3,-1108 # 800178f0 <log>
    80002d4c:	a005                	j	80002d6c <install_trans+0x54>
      bunpin(dbuf);
    80002d4e:	8526                	mv	a0,s1
    80002d50:	b1eff0ef          	jal	ra,8000206e <bunpin>
    brelse(lbuf);
    80002d54:	854a                	mv	a0,s2
    80002d56:	a5aff0ef          	jal	ra,80001fb0 <brelse>
    brelse(dbuf);
    80002d5a:	8526                	mv	a0,s1
    80002d5c:	a54ff0ef          	jal	ra,80001fb0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002d60:	2a05                	addiw	s4,s4,1
    80002d62:	0a91                	addi	s5,s5,4
    80002d64:	02c9a783          	lw	a5,44(s3)
    80002d68:	04fa5163          	bge	s4,a5,80002daa <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002d6c:	0189a583          	lw	a1,24(s3)
    80002d70:	014585bb          	addw	a1,a1,s4
    80002d74:	2585                	addiw	a1,a1,1
    80002d76:	0289a503          	lw	a0,40(s3)
    80002d7a:	92eff0ef          	jal	ra,80001ea8 <bread>
    80002d7e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002d80:	000aa583          	lw	a1,0(s5)
    80002d84:	0289a503          	lw	a0,40(s3)
    80002d88:	920ff0ef          	jal	ra,80001ea8 <bread>
    80002d8c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002d8e:	40000613          	li	a2,1024
    80002d92:	05890593          	addi	a1,s2,88
    80002d96:	05850513          	addi	a0,a0,88
    80002d9a:	c12fd0ef          	jal	ra,800001ac <memmove>
    bwrite(dbuf);  // write dst to disk
    80002d9e:	8526                	mv	a0,s1
    80002da0:	9deff0ef          	jal	ra,80001f7e <bwrite>
    if(recovering == 0)
    80002da4:	fa0b18e3          	bnez	s6,80002d54 <install_trans+0x3c>
    80002da8:	b75d                	j	80002d4e <install_trans+0x36>
}
    80002daa:	70e2                	ld	ra,56(sp)
    80002dac:	7442                	ld	s0,48(sp)
    80002dae:	74a2                	ld	s1,40(sp)
    80002db0:	7902                	ld	s2,32(sp)
    80002db2:	69e2                	ld	s3,24(sp)
    80002db4:	6a42                	ld	s4,16(sp)
    80002db6:	6aa2                	ld	s5,8(sp)
    80002db8:	6b02                	ld	s6,0(sp)
    80002dba:	6121                	addi	sp,sp,64
    80002dbc:	8082                	ret
    80002dbe:	8082                	ret

0000000080002dc0 <initlog>:
{
    80002dc0:	7179                	addi	sp,sp,-48
    80002dc2:	f406                	sd	ra,40(sp)
    80002dc4:	f022                	sd	s0,32(sp)
    80002dc6:	ec26                	sd	s1,24(sp)
    80002dc8:	e84a                	sd	s2,16(sp)
    80002dca:	e44e                	sd	s3,8(sp)
    80002dcc:	1800                	addi	s0,sp,48
    80002dce:	892a                	mv	s2,a0
    80002dd0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002dd2:	00015497          	auipc	s1,0x15
    80002dd6:	b1e48493          	addi	s1,s1,-1250 # 800178f0 <log>
    80002dda:	00005597          	auipc	a1,0x5
    80002dde:	81658593          	addi	a1,a1,-2026 # 800075f0 <syscalls+0x1d8>
    80002de2:	8526                	mv	a0,s1
    80002de4:	73a020ef          	jal	ra,8000551e <initlock>
  log.start = sb->logstart;
    80002de8:	0149a583          	lw	a1,20(s3)
    80002dec:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002dee:	0109a783          	lw	a5,16(s3)
    80002df2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002df4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002df8:	854a                	mv	a0,s2
    80002dfa:	8aeff0ef          	jal	ra,80001ea8 <bread>
  log.lh.n = lh->n;
    80002dfe:	4d3c                	lw	a5,88(a0)
    80002e00:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002e02:	02f05563          	blez	a5,80002e2c <initlog+0x6c>
    80002e06:	05c50713          	addi	a4,a0,92
    80002e0a:	00015697          	auipc	a3,0x15
    80002e0e:	b1668693          	addi	a3,a3,-1258 # 80017920 <log+0x30>
    80002e12:	37fd                	addiw	a5,a5,-1
    80002e14:	1782                	slli	a5,a5,0x20
    80002e16:	9381                	srli	a5,a5,0x20
    80002e18:	078a                	slli	a5,a5,0x2
    80002e1a:	06050613          	addi	a2,a0,96
    80002e1e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80002e20:	4310                	lw	a2,0(a4)
    80002e22:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80002e24:	0711                	addi	a4,a4,4
    80002e26:	0691                	addi	a3,a3,4
    80002e28:	fef71ce3          	bne	a4,a5,80002e20 <initlog+0x60>
  brelse(buf);
    80002e2c:	984ff0ef          	jal	ra,80001fb0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002e30:	4505                	li	a0,1
    80002e32:	ee7ff0ef          	jal	ra,80002d18 <install_trans>
  log.lh.n = 0;
    80002e36:	00015797          	auipc	a5,0x15
    80002e3a:	ae07a323          	sw	zero,-1306(a5) # 8001791c <log+0x2c>
  write_head(); // clear the log
    80002e3e:	e6dff0ef          	jal	ra,80002caa <write_head>
}
    80002e42:	70a2                	ld	ra,40(sp)
    80002e44:	7402                	ld	s0,32(sp)
    80002e46:	64e2                	ld	s1,24(sp)
    80002e48:	6942                	ld	s2,16(sp)
    80002e4a:	69a2                	ld	s3,8(sp)
    80002e4c:	6145                	addi	sp,sp,48
    80002e4e:	8082                	ret

0000000080002e50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002e50:	1101                	addi	sp,sp,-32
    80002e52:	ec06                	sd	ra,24(sp)
    80002e54:	e822                	sd	s0,16(sp)
    80002e56:	e426                	sd	s1,8(sp)
    80002e58:	e04a                	sd	s2,0(sp)
    80002e5a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002e5c:	00015517          	auipc	a0,0x15
    80002e60:	a9450513          	addi	a0,a0,-1388 # 800178f0 <log>
    80002e64:	73a020ef          	jal	ra,8000559e <acquire>
  while(1){
    if(log.committing){
    80002e68:	00015497          	auipc	s1,0x15
    80002e6c:	a8848493          	addi	s1,s1,-1400 # 800178f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002e70:	4979                	li	s2,30
    80002e72:	a029                	j	80002e7c <begin_op+0x2c>
      sleep(&log, &log.lock);
    80002e74:	85a6                	mv	a1,s1
    80002e76:	8526                	mv	a0,s1
    80002e78:	c60fe0ef          	jal	ra,800012d8 <sleep>
    if(log.committing){
    80002e7c:	50dc                	lw	a5,36(s1)
    80002e7e:	fbfd                	bnez	a5,80002e74 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80002e80:	509c                	lw	a5,32(s1)
    80002e82:	0017871b          	addiw	a4,a5,1
    80002e86:	0007069b          	sext.w	a3,a4
    80002e8a:	0027179b          	slliw	a5,a4,0x2
    80002e8e:	9fb9                	addw	a5,a5,a4
    80002e90:	0017979b          	slliw	a5,a5,0x1
    80002e94:	54d8                	lw	a4,44(s1)
    80002e96:	9fb9                	addw	a5,a5,a4
    80002e98:	00f95763          	bge	s2,a5,80002ea6 <begin_op+0x56>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80002e9c:	85a6                	mv	a1,s1
    80002e9e:	8526                	mv	a0,s1
    80002ea0:	c38fe0ef          	jal	ra,800012d8 <sleep>
    80002ea4:	bfe1                	j	80002e7c <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80002ea6:	00015517          	auipc	a0,0x15
    80002eaa:	a4a50513          	addi	a0,a0,-1462 # 800178f0 <log>
    80002eae:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80002eb0:	786020ef          	jal	ra,80005636 <release>
      break;
    }
  }
}
    80002eb4:	60e2                	ld	ra,24(sp)
    80002eb6:	6442                	ld	s0,16(sp)
    80002eb8:	64a2                	ld	s1,8(sp)
    80002eba:	6902                	ld	s2,0(sp)
    80002ebc:	6105                	addi	sp,sp,32
    80002ebe:	8082                	ret

0000000080002ec0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80002ec0:	7139                	addi	sp,sp,-64
    80002ec2:	fc06                	sd	ra,56(sp)
    80002ec4:	f822                	sd	s0,48(sp)
    80002ec6:	f426                	sd	s1,40(sp)
    80002ec8:	f04a                	sd	s2,32(sp)
    80002eca:	ec4e                	sd	s3,24(sp)
    80002ecc:	e852                	sd	s4,16(sp)
    80002ece:	e456                	sd	s5,8(sp)
    80002ed0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80002ed2:	00015497          	auipc	s1,0x15
    80002ed6:	a1e48493          	addi	s1,s1,-1506 # 800178f0 <log>
    80002eda:	8526                	mv	a0,s1
    80002edc:	6c2020ef          	jal	ra,8000559e <acquire>
  log.outstanding -= 1;
    80002ee0:	509c                	lw	a5,32(s1)
    80002ee2:	37fd                	addiw	a5,a5,-1
    80002ee4:	0007891b          	sext.w	s2,a5
    80002ee8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80002eea:	50dc                	lw	a5,36(s1)
    80002eec:	e7b9                	bnez	a5,80002f3a <end_op+0x7a>
    panic("log.committing");
  if(log.outstanding == 0){
    80002eee:	04091c63          	bnez	s2,80002f46 <end_op+0x86>
    do_commit = 1;
    log.committing = 1;
    80002ef2:	00015497          	auipc	s1,0x15
    80002ef6:	9fe48493          	addi	s1,s1,-1538 # 800178f0 <log>
    80002efa:	4785                	li	a5,1
    80002efc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80002efe:	8526                	mv	a0,s1
    80002f00:	736020ef          	jal	ra,80005636 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80002f04:	54dc                	lw	a5,44(s1)
    80002f06:	04f04b63          	bgtz	a5,80002f5c <end_op+0x9c>
    acquire(&log.lock);
    80002f0a:	00015497          	auipc	s1,0x15
    80002f0e:	9e648493          	addi	s1,s1,-1562 # 800178f0 <log>
    80002f12:	8526                	mv	a0,s1
    80002f14:	68a020ef          	jal	ra,8000559e <acquire>
    log.committing = 0;
    80002f18:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80002f1c:	8526                	mv	a0,s1
    80002f1e:	c06fe0ef          	jal	ra,80001324 <wakeup>
    release(&log.lock);
    80002f22:	8526                	mv	a0,s1
    80002f24:	712020ef          	jal	ra,80005636 <release>
}
    80002f28:	70e2                	ld	ra,56(sp)
    80002f2a:	7442                	ld	s0,48(sp)
    80002f2c:	74a2                	ld	s1,40(sp)
    80002f2e:	7902                	ld	s2,32(sp)
    80002f30:	69e2                	ld	s3,24(sp)
    80002f32:	6a42                	ld	s4,16(sp)
    80002f34:	6aa2                	ld	s5,8(sp)
    80002f36:	6121                	addi	sp,sp,64
    80002f38:	8082                	ret
    panic("log.committing");
    80002f3a:	00004517          	auipc	a0,0x4
    80002f3e:	6be50513          	addi	a0,a0,1726 # 800075f8 <syscalls+0x1e0>
    80002f42:	340020ef          	jal	ra,80005282 <panic>
    wakeup(&log);
    80002f46:	00015497          	auipc	s1,0x15
    80002f4a:	9aa48493          	addi	s1,s1,-1622 # 800178f0 <log>
    80002f4e:	8526                	mv	a0,s1
    80002f50:	bd4fe0ef          	jal	ra,80001324 <wakeup>
  release(&log.lock);
    80002f54:	8526                	mv	a0,s1
    80002f56:	6e0020ef          	jal	ra,80005636 <release>
  if(do_commit){
    80002f5a:	b7f9                	j	80002f28 <end_op+0x68>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f5c:	00015a97          	auipc	s5,0x15
    80002f60:	9c4a8a93          	addi	s5,s5,-1596 # 80017920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80002f64:	00015a17          	auipc	s4,0x15
    80002f68:	98ca0a13          	addi	s4,s4,-1652 # 800178f0 <log>
    80002f6c:	018a2583          	lw	a1,24(s4)
    80002f70:	012585bb          	addw	a1,a1,s2
    80002f74:	2585                	addiw	a1,a1,1
    80002f76:	028a2503          	lw	a0,40(s4)
    80002f7a:	f2ffe0ef          	jal	ra,80001ea8 <bread>
    80002f7e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80002f80:	000aa583          	lw	a1,0(s5)
    80002f84:	028a2503          	lw	a0,40(s4)
    80002f88:	f21fe0ef          	jal	ra,80001ea8 <bread>
    80002f8c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80002f8e:	40000613          	li	a2,1024
    80002f92:	05850593          	addi	a1,a0,88
    80002f96:	05848513          	addi	a0,s1,88
    80002f9a:	a12fd0ef          	jal	ra,800001ac <memmove>
    bwrite(to);  // write the log
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	fdffe0ef          	jal	ra,80001f7e <bwrite>
    brelse(from);
    80002fa4:	854e                	mv	a0,s3
    80002fa6:	80aff0ef          	jal	ra,80001fb0 <brelse>
    brelse(to);
    80002faa:	8526                	mv	a0,s1
    80002fac:	804ff0ef          	jal	ra,80001fb0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fb0:	2905                	addiw	s2,s2,1
    80002fb2:	0a91                	addi	s5,s5,4
    80002fb4:	02ca2783          	lw	a5,44(s4)
    80002fb8:	faf94ae3          	blt	s2,a5,80002f6c <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80002fbc:	cefff0ef          	jal	ra,80002caa <write_head>
    install_trans(0); // Now install writes to home locations
    80002fc0:	4501                	li	a0,0
    80002fc2:	d57ff0ef          	jal	ra,80002d18 <install_trans>
    log.lh.n = 0;
    80002fc6:	00015797          	auipc	a5,0x15
    80002fca:	9407ab23          	sw	zero,-1706(a5) # 8001791c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80002fce:	cddff0ef          	jal	ra,80002caa <write_head>
    80002fd2:	bf25                	j	80002f0a <end_op+0x4a>

0000000080002fd4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80002fd4:	1101                	addi	sp,sp,-32
    80002fd6:	ec06                	sd	ra,24(sp)
    80002fd8:	e822                	sd	s0,16(sp)
    80002fda:	e426                	sd	s1,8(sp)
    80002fdc:	e04a                	sd	s2,0(sp)
    80002fde:	1000                	addi	s0,sp,32
    80002fe0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80002fe2:	00015917          	auipc	s2,0x15
    80002fe6:	90e90913          	addi	s2,s2,-1778 # 800178f0 <log>
    80002fea:	854a                	mv	a0,s2
    80002fec:	5b2020ef          	jal	ra,8000559e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80002ff0:	02c92603          	lw	a2,44(s2)
    80002ff4:	47f5                	li	a5,29
    80002ff6:	06c7c363          	blt	a5,a2,8000305c <log_write+0x88>
    80002ffa:	00015797          	auipc	a5,0x15
    80002ffe:	9127a783          	lw	a5,-1774(a5) # 8001790c <log+0x1c>
    80003002:	37fd                	addiw	a5,a5,-1
    80003004:	04f65c63          	bge	a2,a5,8000305c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003008:	00015797          	auipc	a5,0x15
    8000300c:	9087a783          	lw	a5,-1784(a5) # 80017910 <log+0x20>
    80003010:	04f05c63          	blez	a5,80003068 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003014:	4781                	li	a5,0
    80003016:	04c05f63          	blez	a2,80003074 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000301a:	44cc                	lw	a1,12(s1)
    8000301c:	00015717          	auipc	a4,0x15
    80003020:	90470713          	addi	a4,a4,-1788 # 80017920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003024:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003026:	4314                	lw	a3,0(a4)
    80003028:	04b68663          	beq	a3,a1,80003074 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000302c:	2785                	addiw	a5,a5,1
    8000302e:	0711                	addi	a4,a4,4
    80003030:	fef61be3          	bne	a2,a5,80003026 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003034:	0621                	addi	a2,a2,8
    80003036:	060a                	slli	a2,a2,0x2
    80003038:	00015797          	auipc	a5,0x15
    8000303c:	8b878793          	addi	a5,a5,-1864 # 800178f0 <log>
    80003040:	963e                	add	a2,a2,a5
    80003042:	44dc                	lw	a5,12(s1)
    80003044:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003046:	8526                	mv	a0,s1
    80003048:	ff3fe0ef          	jal	ra,8000203a <bpin>
    log.lh.n++;
    8000304c:	00015717          	auipc	a4,0x15
    80003050:	8a470713          	addi	a4,a4,-1884 # 800178f0 <log>
    80003054:	575c                	lw	a5,44(a4)
    80003056:	2785                	addiw	a5,a5,1
    80003058:	d75c                	sw	a5,44(a4)
    8000305a:	a815                	j	8000308e <log_write+0xba>
    panic("too big a transaction");
    8000305c:	00004517          	auipc	a0,0x4
    80003060:	5ac50513          	addi	a0,a0,1452 # 80007608 <syscalls+0x1f0>
    80003064:	21e020ef          	jal	ra,80005282 <panic>
    panic("log_write outside of trans");
    80003068:	00004517          	auipc	a0,0x4
    8000306c:	5b850513          	addi	a0,a0,1464 # 80007620 <syscalls+0x208>
    80003070:	212020ef          	jal	ra,80005282 <panic>
  log.lh.block[i] = b->blockno;
    80003074:	00878713          	addi	a4,a5,8
    80003078:	00271693          	slli	a3,a4,0x2
    8000307c:	00015717          	auipc	a4,0x15
    80003080:	87470713          	addi	a4,a4,-1932 # 800178f0 <log>
    80003084:	9736                	add	a4,a4,a3
    80003086:	44d4                	lw	a3,12(s1)
    80003088:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000308a:	faf60ee3          	beq	a2,a5,80003046 <log_write+0x72>
  }
  release(&log.lock);
    8000308e:	00015517          	auipc	a0,0x15
    80003092:	86250513          	addi	a0,a0,-1950 # 800178f0 <log>
    80003096:	5a0020ef          	jal	ra,80005636 <release>
}
    8000309a:	60e2                	ld	ra,24(sp)
    8000309c:	6442                	ld	s0,16(sp)
    8000309e:	64a2                	ld	s1,8(sp)
    800030a0:	6902                	ld	s2,0(sp)
    800030a2:	6105                	addi	sp,sp,32
    800030a4:	8082                	ret

00000000800030a6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800030a6:	1101                	addi	sp,sp,-32
    800030a8:	ec06                	sd	ra,24(sp)
    800030aa:	e822                	sd	s0,16(sp)
    800030ac:	e426                	sd	s1,8(sp)
    800030ae:	e04a                	sd	s2,0(sp)
    800030b0:	1000                	addi	s0,sp,32
    800030b2:	84aa                	mv	s1,a0
    800030b4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800030b6:	00004597          	auipc	a1,0x4
    800030ba:	58a58593          	addi	a1,a1,1418 # 80007640 <syscalls+0x228>
    800030be:	0521                	addi	a0,a0,8
    800030c0:	45e020ef          	jal	ra,8000551e <initlock>
  lk->name = name;
    800030c4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800030c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800030cc:	0204a423          	sw	zero,40(s1)
}
    800030d0:	60e2                	ld	ra,24(sp)
    800030d2:	6442                	ld	s0,16(sp)
    800030d4:	64a2                	ld	s1,8(sp)
    800030d6:	6902                	ld	s2,0(sp)
    800030d8:	6105                	addi	sp,sp,32
    800030da:	8082                	ret

00000000800030dc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800030dc:	1101                	addi	sp,sp,-32
    800030de:	ec06                	sd	ra,24(sp)
    800030e0:	e822                	sd	s0,16(sp)
    800030e2:	e426                	sd	s1,8(sp)
    800030e4:	e04a                	sd	s2,0(sp)
    800030e6:	1000                	addi	s0,sp,32
    800030e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800030ea:	00850913          	addi	s2,a0,8
    800030ee:	854a                	mv	a0,s2
    800030f0:	4ae020ef          	jal	ra,8000559e <acquire>
  while (lk->locked) {
    800030f4:	409c                	lw	a5,0(s1)
    800030f6:	c799                	beqz	a5,80003104 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800030f8:	85ca                	mv	a1,s2
    800030fa:	8526                	mv	a0,s1
    800030fc:	9dcfe0ef          	jal	ra,800012d8 <sleep>
  while (lk->locked) {
    80003100:	409c                	lw	a5,0(s1)
    80003102:	fbfd                	bnez	a5,800030f8 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003104:	4785                	li	a5,1
    80003106:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003108:	c09fd0ef          	jal	ra,80000d10 <myproc>
    8000310c:	591c                	lw	a5,48(a0)
    8000310e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003110:	854a                	mv	a0,s2
    80003112:	524020ef          	jal	ra,80005636 <release>
}
    80003116:	60e2                	ld	ra,24(sp)
    80003118:	6442                	ld	s0,16(sp)
    8000311a:	64a2                	ld	s1,8(sp)
    8000311c:	6902                	ld	s2,0(sp)
    8000311e:	6105                	addi	sp,sp,32
    80003120:	8082                	ret

0000000080003122 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003122:	1101                	addi	sp,sp,-32
    80003124:	ec06                	sd	ra,24(sp)
    80003126:	e822                	sd	s0,16(sp)
    80003128:	e426                	sd	s1,8(sp)
    8000312a:	e04a                	sd	s2,0(sp)
    8000312c:	1000                	addi	s0,sp,32
    8000312e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003130:	00850913          	addi	s2,a0,8
    80003134:	854a                	mv	a0,s2
    80003136:	468020ef          	jal	ra,8000559e <acquire>
  lk->locked = 0;
    8000313a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000313e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003142:	8526                	mv	a0,s1
    80003144:	9e0fe0ef          	jal	ra,80001324 <wakeup>
  release(&lk->lk);
    80003148:	854a                	mv	a0,s2
    8000314a:	4ec020ef          	jal	ra,80005636 <release>
}
    8000314e:	60e2                	ld	ra,24(sp)
    80003150:	6442                	ld	s0,16(sp)
    80003152:	64a2                	ld	s1,8(sp)
    80003154:	6902                	ld	s2,0(sp)
    80003156:	6105                	addi	sp,sp,32
    80003158:	8082                	ret

000000008000315a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000315a:	7179                	addi	sp,sp,-48
    8000315c:	f406                	sd	ra,40(sp)
    8000315e:	f022                	sd	s0,32(sp)
    80003160:	ec26                	sd	s1,24(sp)
    80003162:	e84a                	sd	s2,16(sp)
    80003164:	e44e                	sd	s3,8(sp)
    80003166:	1800                	addi	s0,sp,48
    80003168:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000316a:	00850913          	addi	s2,a0,8
    8000316e:	854a                	mv	a0,s2
    80003170:	42e020ef          	jal	ra,8000559e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003174:	409c                	lw	a5,0(s1)
    80003176:	ef89                	bnez	a5,80003190 <holdingsleep+0x36>
    80003178:	4481                	li	s1,0
  release(&lk->lk);
    8000317a:	854a                	mv	a0,s2
    8000317c:	4ba020ef          	jal	ra,80005636 <release>
  return r;
}
    80003180:	8526                	mv	a0,s1
    80003182:	70a2                	ld	ra,40(sp)
    80003184:	7402                	ld	s0,32(sp)
    80003186:	64e2                	ld	s1,24(sp)
    80003188:	6942                	ld	s2,16(sp)
    8000318a:	69a2                	ld	s3,8(sp)
    8000318c:	6145                	addi	sp,sp,48
    8000318e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003190:	0284a983          	lw	s3,40(s1)
    80003194:	b7dfd0ef          	jal	ra,80000d10 <myproc>
    80003198:	5904                	lw	s1,48(a0)
    8000319a:	413484b3          	sub	s1,s1,s3
    8000319e:	0014b493          	seqz	s1,s1
    800031a2:	bfe1                	j	8000317a <holdingsleep+0x20>

00000000800031a4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800031a4:	1141                	addi	sp,sp,-16
    800031a6:	e406                	sd	ra,8(sp)
    800031a8:	e022                	sd	s0,0(sp)
    800031aa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800031ac:	00004597          	auipc	a1,0x4
    800031b0:	4a458593          	addi	a1,a1,1188 # 80007650 <syscalls+0x238>
    800031b4:	00015517          	auipc	a0,0x15
    800031b8:	88450513          	addi	a0,a0,-1916 # 80017a38 <ftable>
    800031bc:	362020ef          	jal	ra,8000551e <initlock>
}
    800031c0:	60a2                	ld	ra,8(sp)
    800031c2:	6402                	ld	s0,0(sp)
    800031c4:	0141                	addi	sp,sp,16
    800031c6:	8082                	ret

00000000800031c8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800031c8:	1101                	addi	sp,sp,-32
    800031ca:	ec06                	sd	ra,24(sp)
    800031cc:	e822                	sd	s0,16(sp)
    800031ce:	e426                	sd	s1,8(sp)
    800031d0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800031d2:	00015517          	auipc	a0,0x15
    800031d6:	86650513          	addi	a0,a0,-1946 # 80017a38 <ftable>
    800031da:	3c4020ef          	jal	ra,8000559e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800031de:	00015497          	auipc	s1,0x15
    800031e2:	87248493          	addi	s1,s1,-1934 # 80017a50 <ftable+0x18>
    800031e6:	00016717          	auipc	a4,0x16
    800031ea:	80a70713          	addi	a4,a4,-2038 # 800189f0 <disk>
    if(f->ref == 0){
    800031ee:	40dc                	lw	a5,4(s1)
    800031f0:	cf89                	beqz	a5,8000320a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800031f2:	02848493          	addi	s1,s1,40
    800031f6:	fee49ce3          	bne	s1,a4,800031ee <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800031fa:	00015517          	auipc	a0,0x15
    800031fe:	83e50513          	addi	a0,a0,-1986 # 80017a38 <ftable>
    80003202:	434020ef          	jal	ra,80005636 <release>
  return 0;
    80003206:	4481                	li	s1,0
    80003208:	a809                	j	8000321a <filealloc+0x52>
      f->ref = 1;
    8000320a:	4785                	li	a5,1
    8000320c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000320e:	00015517          	auipc	a0,0x15
    80003212:	82a50513          	addi	a0,a0,-2006 # 80017a38 <ftable>
    80003216:	420020ef          	jal	ra,80005636 <release>
}
    8000321a:	8526                	mv	a0,s1
    8000321c:	60e2                	ld	ra,24(sp)
    8000321e:	6442                	ld	s0,16(sp)
    80003220:	64a2                	ld	s1,8(sp)
    80003222:	6105                	addi	sp,sp,32
    80003224:	8082                	ret

0000000080003226 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003226:	1101                	addi	sp,sp,-32
    80003228:	ec06                	sd	ra,24(sp)
    8000322a:	e822                	sd	s0,16(sp)
    8000322c:	e426                	sd	s1,8(sp)
    8000322e:	1000                	addi	s0,sp,32
    80003230:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003232:	00015517          	auipc	a0,0x15
    80003236:	80650513          	addi	a0,a0,-2042 # 80017a38 <ftable>
    8000323a:	364020ef          	jal	ra,8000559e <acquire>
  if(f->ref < 1)
    8000323e:	40dc                	lw	a5,4(s1)
    80003240:	02f05063          	blez	a5,80003260 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003244:	2785                	addiw	a5,a5,1
    80003246:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003248:	00014517          	auipc	a0,0x14
    8000324c:	7f050513          	addi	a0,a0,2032 # 80017a38 <ftable>
    80003250:	3e6020ef          	jal	ra,80005636 <release>
  return f;
}
    80003254:	8526                	mv	a0,s1
    80003256:	60e2                	ld	ra,24(sp)
    80003258:	6442                	ld	s0,16(sp)
    8000325a:	64a2                	ld	s1,8(sp)
    8000325c:	6105                	addi	sp,sp,32
    8000325e:	8082                	ret
    panic("filedup");
    80003260:	00004517          	auipc	a0,0x4
    80003264:	3f850513          	addi	a0,a0,1016 # 80007658 <syscalls+0x240>
    80003268:	01a020ef          	jal	ra,80005282 <panic>

000000008000326c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000326c:	7139                	addi	sp,sp,-64
    8000326e:	fc06                	sd	ra,56(sp)
    80003270:	f822                	sd	s0,48(sp)
    80003272:	f426                	sd	s1,40(sp)
    80003274:	f04a                	sd	s2,32(sp)
    80003276:	ec4e                	sd	s3,24(sp)
    80003278:	e852                	sd	s4,16(sp)
    8000327a:	e456                	sd	s5,8(sp)
    8000327c:	0080                	addi	s0,sp,64
    8000327e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003280:	00014517          	auipc	a0,0x14
    80003284:	7b850513          	addi	a0,a0,1976 # 80017a38 <ftable>
    80003288:	316020ef          	jal	ra,8000559e <acquire>
  if(f->ref < 1)
    8000328c:	40dc                	lw	a5,4(s1)
    8000328e:	04f05963          	blez	a5,800032e0 <fileclose+0x74>
    panic("fileclose");
  if(--f->ref > 0){
    80003292:	37fd                	addiw	a5,a5,-1
    80003294:	0007871b          	sext.w	a4,a5
    80003298:	c0dc                	sw	a5,4(s1)
    8000329a:	04e04963          	bgtz	a4,800032ec <fileclose+0x80>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000329e:	0004a903          	lw	s2,0(s1)
    800032a2:	0094ca83          	lbu	s5,9(s1)
    800032a6:	0104ba03          	ld	s4,16(s1)
    800032aa:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800032ae:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800032b2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800032b6:	00014517          	auipc	a0,0x14
    800032ba:	78250513          	addi	a0,a0,1922 # 80017a38 <ftable>
    800032be:	378020ef          	jal	ra,80005636 <release>

  if(ff.type == FD_PIPE){
    800032c2:	4785                	li	a5,1
    800032c4:	04f90363          	beq	s2,a5,8000330a <fileclose+0x9e>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800032c8:	3979                	addiw	s2,s2,-2
    800032ca:	4785                	li	a5,1
    800032cc:	0327e663          	bltu	a5,s2,800032f8 <fileclose+0x8c>
    begin_op();
    800032d0:	b81ff0ef          	jal	ra,80002e50 <begin_op>
    iput(ff.ip);
    800032d4:	854e                	mv	a0,s3
    800032d6:	c6eff0ef          	jal	ra,80002744 <iput>
    end_op();
    800032da:	be7ff0ef          	jal	ra,80002ec0 <end_op>
    800032de:	a829                	j	800032f8 <fileclose+0x8c>
    panic("fileclose");
    800032e0:	00004517          	auipc	a0,0x4
    800032e4:	38050513          	addi	a0,a0,896 # 80007660 <syscalls+0x248>
    800032e8:	79b010ef          	jal	ra,80005282 <panic>
    release(&ftable.lock);
    800032ec:	00014517          	auipc	a0,0x14
    800032f0:	74c50513          	addi	a0,a0,1868 # 80017a38 <ftable>
    800032f4:	342020ef          	jal	ra,80005636 <release>
  }
}
    800032f8:	70e2                	ld	ra,56(sp)
    800032fa:	7442                	ld	s0,48(sp)
    800032fc:	74a2                	ld	s1,40(sp)
    800032fe:	7902                	ld	s2,32(sp)
    80003300:	69e2                	ld	s3,24(sp)
    80003302:	6a42                	ld	s4,16(sp)
    80003304:	6aa2                	ld	s5,8(sp)
    80003306:	6121                	addi	sp,sp,64
    80003308:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000330a:	85d6                	mv	a1,s5
    8000330c:	8552                	mv	a0,s4
    8000330e:	2ec000ef          	jal	ra,800035fa <pipeclose>
    80003312:	b7dd                	j	800032f8 <fileclose+0x8c>

0000000080003314 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003314:	715d                	addi	sp,sp,-80
    80003316:	e486                	sd	ra,72(sp)
    80003318:	e0a2                	sd	s0,64(sp)
    8000331a:	fc26                	sd	s1,56(sp)
    8000331c:	f84a                	sd	s2,48(sp)
    8000331e:	f44e                	sd	s3,40(sp)
    80003320:	0880                	addi	s0,sp,80
    80003322:	84aa                	mv	s1,a0
    80003324:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003326:	9ebfd0ef          	jal	ra,80000d10 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000332a:	409c                	lw	a5,0(s1)
    8000332c:	37f9                	addiw	a5,a5,-2
    8000332e:	4705                	li	a4,1
    80003330:	02f76f63          	bltu	a4,a5,8000336e <filestat+0x5a>
    80003334:	892a                	mv	s2,a0
    ilock(f->ip);
    80003336:	6c88                	ld	a0,24(s1)
    80003338:	a8eff0ef          	jal	ra,800025c6 <ilock>
    stati(f->ip, &st);
    8000333c:	fb840593          	addi	a1,s0,-72
    80003340:	6c88                	ld	a0,24(s1)
    80003342:	caaff0ef          	jal	ra,800027ec <stati>
    iunlock(f->ip);
    80003346:	6c88                	ld	a0,24(s1)
    80003348:	b28ff0ef          	jal	ra,80002670 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000334c:	46e1                	li	a3,24
    8000334e:	fb840613          	addi	a2,s0,-72
    80003352:	85ce                	mv	a1,s3
    80003354:	05093503          	ld	a0,80(s2)
    80003358:	e6efd0ef          	jal	ra,800009c6 <copyout>
    8000335c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003360:	60a6                	ld	ra,72(sp)
    80003362:	6406                	ld	s0,64(sp)
    80003364:	74e2                	ld	s1,56(sp)
    80003366:	7942                	ld	s2,48(sp)
    80003368:	79a2                	ld	s3,40(sp)
    8000336a:	6161                	addi	sp,sp,80
    8000336c:	8082                	ret
  return -1;
    8000336e:	557d                	li	a0,-1
    80003370:	bfc5                	j	80003360 <filestat+0x4c>

0000000080003372 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003372:	7179                	addi	sp,sp,-48
    80003374:	f406                	sd	ra,40(sp)
    80003376:	f022                	sd	s0,32(sp)
    80003378:	ec26                	sd	s1,24(sp)
    8000337a:	e84a                	sd	s2,16(sp)
    8000337c:	e44e                	sd	s3,8(sp)
    8000337e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003380:	00854783          	lbu	a5,8(a0)
    80003384:	cbc1                	beqz	a5,80003414 <fileread+0xa2>
    80003386:	84aa                	mv	s1,a0
    80003388:	89ae                	mv	s3,a1
    8000338a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000338c:	411c                	lw	a5,0(a0)
    8000338e:	4705                	li	a4,1
    80003390:	04e78363          	beq	a5,a4,800033d6 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003394:	470d                	li	a4,3
    80003396:	04e78563          	beq	a5,a4,800033e0 <fileread+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000339a:	4709                	li	a4,2
    8000339c:	06e79663          	bne	a5,a4,80003408 <fileread+0x96>
    ilock(f->ip);
    800033a0:	6d08                	ld	a0,24(a0)
    800033a2:	a24ff0ef          	jal	ra,800025c6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800033a6:	874a                	mv	a4,s2
    800033a8:	5094                	lw	a3,32(s1)
    800033aa:	864e                	mv	a2,s3
    800033ac:	4585                	li	a1,1
    800033ae:	6c88                	ld	a0,24(s1)
    800033b0:	c66ff0ef          	jal	ra,80002816 <readi>
    800033b4:	892a                	mv	s2,a0
    800033b6:	00a05563          	blez	a0,800033c0 <fileread+0x4e>
      f->off += r;
    800033ba:	509c                	lw	a5,32(s1)
    800033bc:	9fa9                	addw	a5,a5,a0
    800033be:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800033c0:	6c88                	ld	a0,24(s1)
    800033c2:	aaeff0ef          	jal	ra,80002670 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800033c6:	854a                	mv	a0,s2
    800033c8:	70a2                	ld	ra,40(sp)
    800033ca:	7402                	ld	s0,32(sp)
    800033cc:	64e2                	ld	s1,24(sp)
    800033ce:	6942                	ld	s2,16(sp)
    800033d0:	69a2                	ld	s3,8(sp)
    800033d2:	6145                	addi	sp,sp,48
    800033d4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800033d6:	6908                	ld	a0,16(a0)
    800033d8:	356000ef          	jal	ra,8000372e <piperead>
    800033dc:	892a                	mv	s2,a0
    800033de:	b7e5                	j	800033c6 <fileread+0x54>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800033e0:	02451783          	lh	a5,36(a0)
    800033e4:	03079693          	slli	a3,a5,0x30
    800033e8:	92c1                	srli	a3,a3,0x30
    800033ea:	4725                	li	a4,9
    800033ec:	02d76663          	bltu	a4,a3,80003418 <fileread+0xa6>
    800033f0:	0792                	slli	a5,a5,0x4
    800033f2:	00014717          	auipc	a4,0x14
    800033f6:	5a670713          	addi	a4,a4,1446 # 80017998 <devsw>
    800033fa:	97ba                	add	a5,a5,a4
    800033fc:	639c                	ld	a5,0(a5)
    800033fe:	cf99                	beqz	a5,8000341c <fileread+0xaa>
    r = devsw[f->major].read(1, addr, n);
    80003400:	4505                	li	a0,1
    80003402:	9782                	jalr	a5
    80003404:	892a                	mv	s2,a0
    80003406:	b7c1                	j	800033c6 <fileread+0x54>
    panic("fileread");
    80003408:	00004517          	auipc	a0,0x4
    8000340c:	26850513          	addi	a0,a0,616 # 80007670 <syscalls+0x258>
    80003410:	673010ef          	jal	ra,80005282 <panic>
    return -1;
    80003414:	597d                	li	s2,-1
    80003416:	bf45                	j	800033c6 <fileread+0x54>
      return -1;
    80003418:	597d                	li	s2,-1
    8000341a:	b775                	j	800033c6 <fileread+0x54>
    8000341c:	597d                	li	s2,-1
    8000341e:	b765                	j	800033c6 <fileread+0x54>

0000000080003420 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003420:	715d                	addi	sp,sp,-80
    80003422:	e486                	sd	ra,72(sp)
    80003424:	e0a2                	sd	s0,64(sp)
    80003426:	fc26                	sd	s1,56(sp)
    80003428:	f84a                	sd	s2,48(sp)
    8000342a:	f44e                	sd	s3,40(sp)
    8000342c:	f052                	sd	s4,32(sp)
    8000342e:	ec56                	sd	s5,24(sp)
    80003430:	e85a                	sd	s6,16(sp)
    80003432:	e45e                	sd	s7,8(sp)
    80003434:	e062                	sd	s8,0(sp)
    80003436:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003438:	00954783          	lbu	a5,9(a0)
    8000343c:	0e078863          	beqz	a5,8000352c <filewrite+0x10c>
    80003440:	892a                	mv	s2,a0
    80003442:	8aae                	mv	s5,a1
    80003444:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003446:	411c                	lw	a5,0(a0)
    80003448:	4705                	li	a4,1
    8000344a:	02e78263          	beq	a5,a4,8000346e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000344e:	470d                	li	a4,3
    80003450:	02e78463          	beq	a5,a4,80003478 <filewrite+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003454:	4709                	li	a4,2
    80003456:	0ce79563          	bne	a5,a4,80003520 <filewrite+0x100>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000345a:	0ac05163          	blez	a2,800034fc <filewrite+0xdc>
    int i = 0;
    8000345e:	4981                	li	s3,0
    80003460:	6b05                	lui	s6,0x1
    80003462:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003466:	6b85                	lui	s7,0x1
    80003468:	c00b8b9b          	addiw	s7,s7,-1024
    8000346c:	a041                	j	800034ec <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000346e:	6908                	ld	a0,16(a0)
    80003470:	1e2000ef          	jal	ra,80003652 <pipewrite>
    80003474:	8a2a                	mv	s4,a0
    80003476:	a071                	j	80003502 <filewrite+0xe2>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003478:	02451783          	lh	a5,36(a0)
    8000347c:	03079693          	slli	a3,a5,0x30
    80003480:	92c1                	srli	a3,a3,0x30
    80003482:	4725                	li	a4,9
    80003484:	0ad76663          	bltu	a4,a3,80003530 <filewrite+0x110>
    80003488:	0792                	slli	a5,a5,0x4
    8000348a:	00014717          	auipc	a4,0x14
    8000348e:	50e70713          	addi	a4,a4,1294 # 80017998 <devsw>
    80003492:	97ba                	add	a5,a5,a4
    80003494:	679c                	ld	a5,8(a5)
    80003496:	cfd9                	beqz	a5,80003534 <filewrite+0x114>
    ret = devsw[f->major].write(1, addr, n);
    80003498:	4505                	li	a0,1
    8000349a:	9782                	jalr	a5
    8000349c:	8a2a                	mv	s4,a0
    8000349e:	a095                	j	80003502 <filewrite+0xe2>
    800034a0:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800034a4:	9adff0ef          	jal	ra,80002e50 <begin_op>
      ilock(f->ip);
    800034a8:	01893503          	ld	a0,24(s2)
    800034ac:	91aff0ef          	jal	ra,800025c6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800034b0:	8762                	mv	a4,s8
    800034b2:	02092683          	lw	a3,32(s2)
    800034b6:	01598633          	add	a2,s3,s5
    800034ba:	4585                	li	a1,1
    800034bc:	01893503          	ld	a0,24(s2)
    800034c0:	c3aff0ef          	jal	ra,800028fa <writei>
    800034c4:	84aa                	mv	s1,a0
    800034c6:	00a05763          	blez	a0,800034d4 <filewrite+0xb4>
        f->off += r;
    800034ca:	02092783          	lw	a5,32(s2)
    800034ce:	9fa9                	addw	a5,a5,a0
    800034d0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800034d4:	01893503          	ld	a0,24(s2)
    800034d8:	998ff0ef          	jal	ra,80002670 <iunlock>
      end_op();
    800034dc:	9e5ff0ef          	jal	ra,80002ec0 <end_op>

      if(r != n1){
    800034e0:	009c1f63          	bne	s8,s1,800034fe <filewrite+0xde>
        // error from writei
        break;
      }
      i += r;
    800034e4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800034e8:	0149db63          	bge	s3,s4,800034fe <filewrite+0xde>
      int n1 = n - i;
    800034ec:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800034f0:	84be                	mv	s1,a5
    800034f2:	2781                	sext.w	a5,a5
    800034f4:	fafb56e3          	bge	s6,a5,800034a0 <filewrite+0x80>
    800034f8:	84de                	mv	s1,s7
    800034fa:	b75d                	j	800034a0 <filewrite+0x80>
    int i = 0;
    800034fc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800034fe:	013a1f63          	bne	s4,s3,8000351c <filewrite+0xfc>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003502:	8552                	mv	a0,s4
    80003504:	60a6                	ld	ra,72(sp)
    80003506:	6406                	ld	s0,64(sp)
    80003508:	74e2                	ld	s1,56(sp)
    8000350a:	7942                	ld	s2,48(sp)
    8000350c:	79a2                	ld	s3,40(sp)
    8000350e:	7a02                	ld	s4,32(sp)
    80003510:	6ae2                	ld	s5,24(sp)
    80003512:	6b42                	ld	s6,16(sp)
    80003514:	6ba2                	ld	s7,8(sp)
    80003516:	6c02                	ld	s8,0(sp)
    80003518:	6161                	addi	sp,sp,80
    8000351a:	8082                	ret
    ret = (i == n ? n : -1);
    8000351c:	5a7d                	li	s4,-1
    8000351e:	b7d5                	j	80003502 <filewrite+0xe2>
    panic("filewrite");
    80003520:	00004517          	auipc	a0,0x4
    80003524:	16050513          	addi	a0,a0,352 # 80007680 <syscalls+0x268>
    80003528:	55b010ef          	jal	ra,80005282 <panic>
    return -1;
    8000352c:	5a7d                	li	s4,-1
    8000352e:	bfd1                	j	80003502 <filewrite+0xe2>
      return -1;
    80003530:	5a7d                	li	s4,-1
    80003532:	bfc1                	j	80003502 <filewrite+0xe2>
    80003534:	5a7d                	li	s4,-1
    80003536:	b7f1                	j	80003502 <filewrite+0xe2>

0000000080003538 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003538:	7179                	addi	sp,sp,-48
    8000353a:	f406                	sd	ra,40(sp)
    8000353c:	f022                	sd	s0,32(sp)
    8000353e:	ec26                	sd	s1,24(sp)
    80003540:	e84a                	sd	s2,16(sp)
    80003542:	e44e                	sd	s3,8(sp)
    80003544:	e052                	sd	s4,0(sp)
    80003546:	1800                	addi	s0,sp,48
    80003548:	84aa                	mv	s1,a0
    8000354a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000354c:	0005b023          	sd	zero,0(a1)
    80003550:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003554:	c75ff0ef          	jal	ra,800031c8 <filealloc>
    80003558:	e088                	sd	a0,0(s1)
    8000355a:	cd35                	beqz	a0,800035d6 <pipealloc+0x9e>
    8000355c:	c6dff0ef          	jal	ra,800031c8 <filealloc>
    80003560:	00aa3023          	sd	a0,0(s4)
    80003564:	c52d                	beqz	a0,800035ce <pipealloc+0x96>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003566:	b97fc0ef          	jal	ra,800000fc <kalloc>
    8000356a:	892a                	mv	s2,a0
    8000356c:	cd31                	beqz	a0,800035c8 <pipealloc+0x90>
    goto bad;
  pi->readopen = 1;
    8000356e:	4985                	li	s3,1
    80003570:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003574:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003578:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000357c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003580:	00004597          	auipc	a1,0x4
    80003584:	11058593          	addi	a1,a1,272 # 80007690 <syscalls+0x278>
    80003588:	797010ef          	jal	ra,8000551e <initlock>
  (*f0)->type = FD_PIPE;
    8000358c:	609c                	ld	a5,0(s1)
    8000358e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003592:	609c                	ld	a5,0(s1)
    80003594:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003598:	609c                	ld	a5,0(s1)
    8000359a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000359e:	609c                	ld	a5,0(s1)
    800035a0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800035a4:	000a3783          	ld	a5,0(s4)
    800035a8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800035ac:	000a3783          	ld	a5,0(s4)
    800035b0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800035b4:	000a3783          	ld	a5,0(s4)
    800035b8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800035bc:	000a3783          	ld	a5,0(s4)
    800035c0:	0127b823          	sd	s2,16(a5)
  return 0;
    800035c4:	4501                	li	a0,0
    800035c6:	a005                	j	800035e6 <pipealloc+0xae>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800035c8:	6088                	ld	a0,0(s1)
    800035ca:	e501                	bnez	a0,800035d2 <pipealloc+0x9a>
    800035cc:	a029                	j	800035d6 <pipealloc+0x9e>
    800035ce:	6088                	ld	a0,0(s1)
    800035d0:	c11d                	beqz	a0,800035f6 <pipealloc+0xbe>
    fileclose(*f0);
    800035d2:	c9bff0ef          	jal	ra,8000326c <fileclose>
  if(*f1)
    800035d6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800035da:	557d                	li	a0,-1
  if(*f1)
    800035dc:	c789                	beqz	a5,800035e6 <pipealloc+0xae>
    fileclose(*f1);
    800035de:	853e                	mv	a0,a5
    800035e0:	c8dff0ef          	jal	ra,8000326c <fileclose>
  return -1;
    800035e4:	557d                	li	a0,-1
}
    800035e6:	70a2                	ld	ra,40(sp)
    800035e8:	7402                	ld	s0,32(sp)
    800035ea:	64e2                	ld	s1,24(sp)
    800035ec:	6942                	ld	s2,16(sp)
    800035ee:	69a2                	ld	s3,8(sp)
    800035f0:	6a02                	ld	s4,0(sp)
    800035f2:	6145                	addi	sp,sp,48
    800035f4:	8082                	ret
  return -1;
    800035f6:	557d                	li	a0,-1
    800035f8:	b7fd                	j	800035e6 <pipealloc+0xae>

00000000800035fa <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800035fa:	1101                	addi	sp,sp,-32
    800035fc:	ec06                	sd	ra,24(sp)
    800035fe:	e822                	sd	s0,16(sp)
    80003600:	e426                	sd	s1,8(sp)
    80003602:	e04a                	sd	s2,0(sp)
    80003604:	1000                	addi	s0,sp,32
    80003606:	84aa                	mv	s1,a0
    80003608:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000360a:	795010ef          	jal	ra,8000559e <acquire>
  if(writable){
    8000360e:	02090763          	beqz	s2,8000363c <pipeclose+0x42>
    pi->writeopen = 0;
    80003612:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003616:	21848513          	addi	a0,s1,536
    8000361a:	d0bfd0ef          	jal	ra,80001324 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000361e:	2204b783          	ld	a5,544(s1)
    80003622:	e785                	bnez	a5,8000364a <pipeclose+0x50>
    release(&pi->lock);
    80003624:	8526                	mv	a0,s1
    80003626:	010020ef          	jal	ra,80005636 <release>
    kfree((char*)pi);
    8000362a:	8526                	mv	a0,s1
    8000362c:	9f1fc0ef          	jal	ra,8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003630:	60e2                	ld	ra,24(sp)
    80003632:	6442                	ld	s0,16(sp)
    80003634:	64a2                	ld	s1,8(sp)
    80003636:	6902                	ld	s2,0(sp)
    80003638:	6105                	addi	sp,sp,32
    8000363a:	8082                	ret
    pi->readopen = 0;
    8000363c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003640:	21c48513          	addi	a0,s1,540
    80003644:	ce1fd0ef          	jal	ra,80001324 <wakeup>
    80003648:	bfd9                	j	8000361e <pipeclose+0x24>
    release(&pi->lock);
    8000364a:	8526                	mv	a0,s1
    8000364c:	7eb010ef          	jal	ra,80005636 <release>
}
    80003650:	b7c5                	j	80003630 <pipeclose+0x36>

0000000080003652 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003652:	7159                	addi	sp,sp,-112
    80003654:	f486                	sd	ra,104(sp)
    80003656:	f0a2                	sd	s0,96(sp)
    80003658:	eca6                	sd	s1,88(sp)
    8000365a:	e8ca                	sd	s2,80(sp)
    8000365c:	e4ce                	sd	s3,72(sp)
    8000365e:	e0d2                	sd	s4,64(sp)
    80003660:	fc56                	sd	s5,56(sp)
    80003662:	f85a                	sd	s6,48(sp)
    80003664:	f45e                	sd	s7,40(sp)
    80003666:	f062                	sd	s8,32(sp)
    80003668:	ec66                	sd	s9,24(sp)
    8000366a:	1880                	addi	s0,sp,112
    8000366c:	84aa                	mv	s1,a0
    8000366e:	8aae                	mv	s5,a1
    80003670:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003672:	e9efd0ef          	jal	ra,80000d10 <myproc>
    80003676:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003678:	8526                	mv	a0,s1
    8000367a:	725010ef          	jal	ra,8000559e <acquire>
  while(i < n){
    8000367e:	0b405663          	blez	s4,8000372a <pipewrite+0xd8>
    80003682:	8ba6                	mv	s7,s1
  int i = 0;
    80003684:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003686:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003688:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000368c:	21c48c13          	addi	s8,s1,540
    80003690:	a899                	j	800036e6 <pipewrite+0x94>
      release(&pi->lock);
    80003692:	8526                	mv	a0,s1
    80003694:	7a3010ef          	jal	ra,80005636 <release>
      return -1;
    80003698:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000369a:	854a                	mv	a0,s2
    8000369c:	70a6                	ld	ra,104(sp)
    8000369e:	7406                	ld	s0,96(sp)
    800036a0:	64e6                	ld	s1,88(sp)
    800036a2:	6946                	ld	s2,80(sp)
    800036a4:	69a6                	ld	s3,72(sp)
    800036a6:	6a06                	ld	s4,64(sp)
    800036a8:	7ae2                	ld	s5,56(sp)
    800036aa:	7b42                	ld	s6,48(sp)
    800036ac:	7ba2                	ld	s7,40(sp)
    800036ae:	7c02                	ld	s8,32(sp)
    800036b0:	6ce2                	ld	s9,24(sp)
    800036b2:	6165                	addi	sp,sp,112
    800036b4:	8082                	ret
      wakeup(&pi->nread);
    800036b6:	8566                	mv	a0,s9
    800036b8:	c6dfd0ef          	jal	ra,80001324 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800036bc:	85de                	mv	a1,s7
    800036be:	8562                	mv	a0,s8
    800036c0:	c19fd0ef          	jal	ra,800012d8 <sleep>
    800036c4:	a839                	j	800036e2 <pipewrite+0x90>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800036c6:	21c4a783          	lw	a5,540(s1)
    800036ca:	0017871b          	addiw	a4,a5,1
    800036ce:	20e4ae23          	sw	a4,540(s1)
    800036d2:	1ff7f793          	andi	a5,a5,511
    800036d6:	97a6                	add	a5,a5,s1
    800036d8:	f9f44703          	lbu	a4,-97(s0)
    800036dc:	00e78c23          	sb	a4,24(a5)
      i++;
    800036e0:	2905                	addiw	s2,s2,1
  while(i < n){
    800036e2:	03495c63          	bge	s2,s4,8000371a <pipewrite+0xc8>
    if(pi->readopen == 0 || killed(pr)){
    800036e6:	2204a783          	lw	a5,544(s1)
    800036ea:	d7c5                	beqz	a5,80003692 <pipewrite+0x40>
    800036ec:	854e                	mv	a0,s3
    800036ee:	e23fd0ef          	jal	ra,80001510 <killed>
    800036f2:	f145                	bnez	a0,80003692 <pipewrite+0x40>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800036f4:	2184a783          	lw	a5,536(s1)
    800036f8:	21c4a703          	lw	a4,540(s1)
    800036fc:	2007879b          	addiw	a5,a5,512
    80003700:	faf70be3          	beq	a4,a5,800036b6 <pipewrite+0x64>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003704:	4685                	li	a3,1
    80003706:	01590633          	add	a2,s2,s5
    8000370a:	f9f40593          	addi	a1,s0,-97
    8000370e:	0509b503          	ld	a0,80(s3)
    80003712:	b6cfd0ef          	jal	ra,80000a7e <copyin>
    80003716:	fb6518e3          	bne	a0,s6,800036c6 <pipewrite+0x74>
  wakeup(&pi->nread);
    8000371a:	21848513          	addi	a0,s1,536
    8000371e:	c07fd0ef          	jal	ra,80001324 <wakeup>
  release(&pi->lock);
    80003722:	8526                	mv	a0,s1
    80003724:	713010ef          	jal	ra,80005636 <release>
  return i;
    80003728:	bf8d                	j	8000369a <pipewrite+0x48>
  int i = 0;
    8000372a:	4901                	li	s2,0
    8000372c:	b7fd                	j	8000371a <pipewrite+0xc8>

000000008000372e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000372e:	715d                	addi	sp,sp,-80
    80003730:	e486                	sd	ra,72(sp)
    80003732:	e0a2                	sd	s0,64(sp)
    80003734:	fc26                	sd	s1,56(sp)
    80003736:	f84a                	sd	s2,48(sp)
    80003738:	f44e                	sd	s3,40(sp)
    8000373a:	f052                	sd	s4,32(sp)
    8000373c:	ec56                	sd	s5,24(sp)
    8000373e:	e85a                	sd	s6,16(sp)
    80003740:	0880                	addi	s0,sp,80
    80003742:	84aa                	mv	s1,a0
    80003744:	892e                	mv	s2,a1
    80003746:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003748:	dc8fd0ef          	jal	ra,80000d10 <myproc>
    8000374c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000374e:	8b26                	mv	s6,s1
    80003750:	8526                	mv	a0,s1
    80003752:	64d010ef          	jal	ra,8000559e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003756:	2184a703          	lw	a4,536(s1)
    8000375a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000375e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003762:	02f71363          	bne	a4,a5,80003788 <piperead+0x5a>
    80003766:	2244a783          	lw	a5,548(s1)
    8000376a:	cf99                	beqz	a5,80003788 <piperead+0x5a>
    if(killed(pr)){
    8000376c:	8552                	mv	a0,s4
    8000376e:	da3fd0ef          	jal	ra,80001510 <killed>
    80003772:	e141                	bnez	a0,800037f2 <piperead+0xc4>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003774:	85da                	mv	a1,s6
    80003776:	854e                	mv	a0,s3
    80003778:	b61fd0ef          	jal	ra,800012d8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000377c:	2184a703          	lw	a4,536(s1)
    80003780:	21c4a783          	lw	a5,540(s1)
    80003784:	fef701e3          	beq	a4,a5,80003766 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003788:	07505a63          	blez	s5,800037fc <piperead+0xce>
    8000378c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000378e:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003790:	2184a783          	lw	a5,536(s1)
    80003794:	21c4a703          	lw	a4,540(s1)
    80003798:	02f70b63          	beq	a4,a5,800037ce <piperead+0xa0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000379c:	0017871b          	addiw	a4,a5,1
    800037a0:	20e4ac23          	sw	a4,536(s1)
    800037a4:	1ff7f793          	andi	a5,a5,511
    800037a8:	97a6                	add	a5,a5,s1
    800037aa:	0187c783          	lbu	a5,24(a5)
    800037ae:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800037b2:	4685                	li	a3,1
    800037b4:	fbf40613          	addi	a2,s0,-65
    800037b8:	85ca                	mv	a1,s2
    800037ba:	050a3503          	ld	a0,80(s4)
    800037be:	a08fd0ef          	jal	ra,800009c6 <copyout>
    800037c2:	01650663          	beq	a0,s6,800037ce <piperead+0xa0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800037c6:	2985                	addiw	s3,s3,1
    800037c8:	0905                	addi	s2,s2,1
    800037ca:	fd3a93e3          	bne	s5,s3,80003790 <piperead+0x62>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800037ce:	21c48513          	addi	a0,s1,540
    800037d2:	b53fd0ef          	jal	ra,80001324 <wakeup>
  release(&pi->lock);
    800037d6:	8526                	mv	a0,s1
    800037d8:	65f010ef          	jal	ra,80005636 <release>
  return i;
}
    800037dc:	854e                	mv	a0,s3
    800037de:	60a6                	ld	ra,72(sp)
    800037e0:	6406                	ld	s0,64(sp)
    800037e2:	74e2                	ld	s1,56(sp)
    800037e4:	7942                	ld	s2,48(sp)
    800037e6:	79a2                	ld	s3,40(sp)
    800037e8:	7a02                	ld	s4,32(sp)
    800037ea:	6ae2                	ld	s5,24(sp)
    800037ec:	6b42                	ld	s6,16(sp)
    800037ee:	6161                	addi	sp,sp,80
    800037f0:	8082                	ret
      release(&pi->lock);
    800037f2:	8526                	mv	a0,s1
    800037f4:	643010ef          	jal	ra,80005636 <release>
      return -1;
    800037f8:	59fd                	li	s3,-1
    800037fa:	b7cd                	j	800037dc <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800037fc:	4981                	li	s3,0
    800037fe:	bfc1                	j	800037ce <piperead+0xa0>

0000000080003800 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003800:	1141                	addi	sp,sp,-16
    80003802:	e422                	sd	s0,8(sp)
    80003804:	0800                	addi	s0,sp,16
    80003806:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003808:	8905                	andi	a0,a0,1
    8000380a:	c111                	beqz	a0,8000380e <flags2perm+0xe>
      perm = PTE_X;
    8000380c:	4521                	li	a0,8
    if(flags & 0x2)
    8000380e:	8b89                	andi	a5,a5,2
    80003810:	c399                	beqz	a5,80003816 <flags2perm+0x16>
      perm |= PTE_W;
    80003812:	00456513          	ori	a0,a0,4
    return perm;
}
    80003816:	6422                	ld	s0,8(sp)
    80003818:	0141                	addi	sp,sp,16
    8000381a:	8082                	ret

000000008000381c <exec>:

int
exec(char *path, char **argv)
{
    8000381c:	df010113          	addi	sp,sp,-528
    80003820:	20113423          	sd	ra,520(sp)
    80003824:	20813023          	sd	s0,512(sp)
    80003828:	ffa6                	sd	s1,504(sp)
    8000382a:	fbca                	sd	s2,496(sp)
    8000382c:	f7ce                	sd	s3,488(sp)
    8000382e:	f3d2                	sd	s4,480(sp)
    80003830:	efd6                	sd	s5,472(sp)
    80003832:	ebda                	sd	s6,464(sp)
    80003834:	e7de                	sd	s7,456(sp)
    80003836:	e3e2                	sd	s8,448(sp)
    80003838:	ff66                	sd	s9,440(sp)
    8000383a:	fb6a                	sd	s10,432(sp)
    8000383c:	f76e                	sd	s11,424(sp)
    8000383e:	0c00                	addi	s0,sp,528
    80003840:	84aa                	mv	s1,a0
    80003842:	dea43c23          	sd	a0,-520(s0)
    80003846:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000384a:	cc6fd0ef          	jal	ra,80000d10 <myproc>
    8000384e:	892a                	mv	s2,a0

  begin_op();
    80003850:	e00ff0ef          	jal	ra,80002e50 <begin_op>

  if((ip = namei(path)) == 0){
    80003854:	8526                	mv	a0,s1
    80003856:	c22ff0ef          	jal	ra,80002c78 <namei>
    8000385a:	c12d                	beqz	a0,800038bc <exec+0xa0>
    8000385c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000385e:	d69fe0ef          	jal	ra,800025c6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003862:	04000713          	li	a4,64
    80003866:	4681                	li	a3,0
    80003868:	e5040613          	addi	a2,s0,-432
    8000386c:	4581                	li	a1,0
    8000386e:	8526                	mv	a0,s1
    80003870:	fa7fe0ef          	jal	ra,80002816 <readi>
    80003874:	04000793          	li	a5,64
    80003878:	00f51a63          	bne	a0,a5,8000388c <exec+0x70>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000387c:	e5042703          	lw	a4,-432(s0)
    80003880:	464c47b7          	lui	a5,0x464c4
    80003884:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003888:	02f70e63          	beq	a4,a5,800038c4 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000388c:	8526                	mv	a0,s1
    8000388e:	f3ffe0ef          	jal	ra,800027cc <iunlockput>
    end_op();
    80003892:	e2eff0ef          	jal	ra,80002ec0 <end_op>
  }
  return -1;
    80003896:	557d                	li	a0,-1
}
    80003898:	20813083          	ld	ra,520(sp)
    8000389c:	20013403          	ld	s0,512(sp)
    800038a0:	74fe                	ld	s1,504(sp)
    800038a2:	795e                	ld	s2,496(sp)
    800038a4:	79be                	ld	s3,488(sp)
    800038a6:	7a1e                	ld	s4,480(sp)
    800038a8:	6afe                	ld	s5,472(sp)
    800038aa:	6b5e                	ld	s6,464(sp)
    800038ac:	6bbe                	ld	s7,456(sp)
    800038ae:	6c1e                	ld	s8,448(sp)
    800038b0:	7cfa                	ld	s9,440(sp)
    800038b2:	7d5a                	ld	s10,432(sp)
    800038b4:	7dba                	ld	s11,424(sp)
    800038b6:	21010113          	addi	sp,sp,528
    800038ba:	8082                	ret
    end_op();
    800038bc:	e04ff0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    800038c0:	557d                	li	a0,-1
    800038c2:	bfd9                	j	80003898 <exec+0x7c>
  if((pagetable = proc_pagetable(p)) == 0)
    800038c4:	854a                	mv	a0,s2
    800038c6:	cf2fd0ef          	jal	ra,80000db8 <proc_pagetable>
    800038ca:	8baa                	mv	s7,a0
    800038cc:	d161                	beqz	a0,8000388c <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800038ce:	e7042983          	lw	s3,-400(s0)
    800038d2:	e8845783          	lhu	a5,-376(s0)
    800038d6:	cfb9                	beqz	a5,80003934 <exec+0x118>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800038d8:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800038da:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800038dc:	6c85                	lui	s9,0x1
    800038de:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800038e2:	def43823          	sd	a5,-528(s0)
    800038e6:	aadd                	j	80003adc <exec+0x2c0>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800038e8:	00004517          	auipc	a0,0x4
    800038ec:	db050513          	addi	a0,a0,-592 # 80007698 <syscalls+0x280>
    800038f0:	193010ef          	jal	ra,80005282 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800038f4:	8756                	mv	a4,s5
    800038f6:	012d86bb          	addw	a3,s11,s2
    800038fa:	4581                	li	a1,0
    800038fc:	8526                	mv	a0,s1
    800038fe:	f19fe0ef          	jal	ra,80002816 <readi>
    80003902:	2501                	sext.w	a0,a0
    80003904:	18aa9263          	bne	s5,a0,80003a88 <exec+0x26c>
  for(i = 0; i < sz; i += PGSIZE){
    80003908:	6785                	lui	a5,0x1
    8000390a:	0127893b          	addw	s2,a5,s2
    8000390e:	77fd                	lui	a5,0xfffff
    80003910:	01478a3b          	addw	s4,a5,s4
    80003914:	1b897b63          	bgeu	s2,s8,80003aca <exec+0x2ae>
    pa = walkaddr(pagetable, va + i);
    80003918:	02091593          	slli	a1,s2,0x20
    8000391c:	9181                	srli	a1,a1,0x20
    8000391e:	95ea                	add	a1,a1,s10
    80003920:	855e                	mv	a0,s7
    80003922:	b49fc0ef          	jal	ra,8000046a <walkaddr>
    80003926:	862a                	mv	a2,a0
    if(pa == 0)
    80003928:	d161                	beqz	a0,800038e8 <exec+0xcc>
      n = PGSIZE;
    8000392a:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000392c:	fd9a74e3          	bgeu	s4,s9,800038f4 <exec+0xd8>
      n = sz - i;
    80003930:	8ad2                	mv	s5,s4
    80003932:	b7c9                	j	800038f4 <exec+0xd8>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003934:	4a01                	li	s4,0
  iunlockput(ip);
    80003936:	8526                	mv	a0,s1
    80003938:	e95fe0ef          	jal	ra,800027cc <iunlockput>
  end_op();
    8000393c:	d84ff0ef          	jal	ra,80002ec0 <end_op>
  p = myproc();
    80003940:	bd0fd0ef          	jal	ra,80000d10 <myproc>
    80003944:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003946:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000394a:	6785                	lui	a5,0x1
    8000394c:	17fd                	addi	a5,a5,-1
    8000394e:	9a3e                	add	s4,s4,a5
    80003950:	757d                	lui	a0,0xfffff
    80003952:	00aa77b3          	and	a5,s4,a0
    80003956:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000395a:	4691                	li	a3,4
    8000395c:	660d                	lui	a2,0x3
    8000395e:	963e                	add	a2,a2,a5
    80003960:	85be                	mv	a1,a5
    80003962:	855e                	mv	a0,s7
    80003964:	e5ffc0ef          	jal	ra,800007c2 <uvmalloc>
    80003968:	8b2a                	mv	s6,a0
  ip = 0;
    8000396a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000396c:	10050e63          	beqz	a0,80003a88 <exec+0x26c>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003970:	75f5                	lui	a1,0xffffd
    80003972:	95aa                	add	a1,a1,a0
    80003974:	855e                	mv	a0,s7
    80003976:	826fd0ef          	jal	ra,8000099c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000397a:	7c79                	lui	s8,0xffffe
    8000397c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000397e:	e0043783          	ld	a5,-512(s0)
    80003982:	6388                	ld	a0,0(a5)
    80003984:	c125                	beqz	a0,800039e4 <exec+0x1c8>
    80003986:	e9040993          	addi	s3,s0,-368
    8000398a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000398e:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80003990:	93dfc0ef          	jal	ra,800002cc <strlen>
    80003994:	2505                	addiw	a0,a0,1
    80003996:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000399a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000399e:	11896a63          	bltu	s2,s8,80003ab2 <exec+0x296>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800039a2:	e0043d83          	ld	s11,-512(s0)
    800039a6:	000dba03          	ld	s4,0(s11)
    800039aa:	8552                	mv	a0,s4
    800039ac:	921fc0ef          	jal	ra,800002cc <strlen>
    800039b0:	0015069b          	addiw	a3,a0,1
    800039b4:	8652                	mv	a2,s4
    800039b6:	85ca                	mv	a1,s2
    800039b8:	855e                	mv	a0,s7
    800039ba:	80cfd0ef          	jal	ra,800009c6 <copyout>
    800039be:	0e054e63          	bltz	a0,80003aba <exec+0x29e>
    ustack[argc] = sp;
    800039c2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800039c6:	0485                	addi	s1,s1,1
    800039c8:	008d8793          	addi	a5,s11,8
    800039cc:	e0f43023          	sd	a5,-512(s0)
    800039d0:	008db503          	ld	a0,8(s11)
    800039d4:	c911                	beqz	a0,800039e8 <exec+0x1cc>
    if(argc >= MAXARG)
    800039d6:	09a1                	addi	s3,s3,8
    800039d8:	fb3c9ce3          	bne	s9,s3,80003990 <exec+0x174>
  sz = sz1;
    800039dc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800039e0:	4481                	li	s1,0
    800039e2:	a05d                	j	80003a88 <exec+0x26c>
  sp = sz;
    800039e4:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800039e6:	4481                	li	s1,0
  ustack[argc] = 0;
    800039e8:	00349793          	slli	a5,s1,0x3
    800039ec:	f9040713          	addi	a4,s0,-112
    800039f0:	97ba                	add	a5,a5,a4
    800039f2:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800039f6:	00148693          	addi	a3,s1,1
    800039fa:	068e                	slli	a3,a3,0x3
    800039fc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003a00:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80003a04:	01897663          	bgeu	s2,s8,80003a10 <exec+0x1f4>
  sz = sz1;
    80003a08:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003a0c:	4481                	li	s1,0
    80003a0e:	a8ad                	j	80003a88 <exec+0x26c>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003a10:	e9040613          	addi	a2,s0,-368
    80003a14:	85ca                	mv	a1,s2
    80003a16:	855e                	mv	a0,s7
    80003a18:	faffc0ef          	jal	ra,800009c6 <copyout>
    80003a1c:	0a054363          	bltz	a0,80003ac2 <exec+0x2a6>
  p->trapframe->a1 = sp;
    80003a20:	058ab783          	ld	a5,88(s5)
    80003a24:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003a28:	df843783          	ld	a5,-520(s0)
    80003a2c:	0007c703          	lbu	a4,0(a5)
    80003a30:	cf11                	beqz	a4,80003a4c <exec+0x230>
    80003a32:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003a34:	02f00693          	li	a3,47
    80003a38:	a039                	j	80003a46 <exec+0x22a>
      last = s+1;
    80003a3a:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003a3e:	0785                	addi	a5,a5,1
    80003a40:	fff7c703          	lbu	a4,-1(a5)
    80003a44:	c701                	beqz	a4,80003a4c <exec+0x230>
    if(*s == '/')
    80003a46:	fed71ce3          	bne	a4,a3,80003a3e <exec+0x222>
    80003a4a:	bfc5                	j	80003a3a <exec+0x21e>
  safestrcpy(p->name, last, sizeof(p->name));
    80003a4c:	4641                	li	a2,16
    80003a4e:	df843583          	ld	a1,-520(s0)
    80003a52:	158a8513          	addi	a0,s5,344
    80003a56:	845fc0ef          	jal	ra,8000029a <safestrcpy>
  oldpagetable = p->pagetable;
    80003a5a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003a5e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80003a62:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003a66:	058ab783          	ld	a5,88(s5)
    80003a6a:	e6843703          	ld	a4,-408(s0)
    80003a6e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003a70:	058ab783          	ld	a5,88(s5)
    80003a74:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003a78:	85ea                	mv	a1,s10
    80003a7a:	bc2fd0ef          	jal	ra,80000e3c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003a7e:	0004851b          	sext.w	a0,s1
    80003a82:	bd19                	j	80003898 <exec+0x7c>
    80003a84:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80003a88:	e0843583          	ld	a1,-504(s0)
    80003a8c:	855e                	mv	a0,s7
    80003a8e:	baefd0ef          	jal	ra,80000e3c <proc_freepagetable>
  if(ip){
    80003a92:	de049de3          	bnez	s1,8000388c <exec+0x70>
  return -1;
    80003a96:	557d                	li	a0,-1
    80003a98:	b501                	j	80003898 <exec+0x7c>
    80003a9a:	e1443423          	sd	s4,-504(s0)
    80003a9e:	b7ed                	j	80003a88 <exec+0x26c>
    80003aa0:	e1443423          	sd	s4,-504(s0)
    80003aa4:	b7d5                	j	80003a88 <exec+0x26c>
    80003aa6:	e1443423          	sd	s4,-504(s0)
    80003aaa:	bff9                	j	80003a88 <exec+0x26c>
    80003aac:	e1443423          	sd	s4,-504(s0)
    80003ab0:	bfe1                	j	80003a88 <exec+0x26c>
  sz = sz1;
    80003ab2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003ab6:	4481                	li	s1,0
    80003ab8:	bfc1                	j	80003a88 <exec+0x26c>
  sz = sz1;
    80003aba:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003abe:	4481                	li	s1,0
    80003ac0:	b7e1                	j	80003a88 <exec+0x26c>
  sz = sz1;
    80003ac2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80003ac6:	4481                	li	s1,0
    80003ac8:	b7c1                	j	80003a88 <exec+0x26c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003aca:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ace:	2b05                	addiw	s6,s6,1
    80003ad0:	0389899b          	addiw	s3,s3,56
    80003ad4:	e8845783          	lhu	a5,-376(s0)
    80003ad8:	e4fb5fe3          	bge	s6,a5,80003936 <exec+0x11a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003adc:	2981                	sext.w	s3,s3
    80003ade:	03800713          	li	a4,56
    80003ae2:	86ce                	mv	a3,s3
    80003ae4:	e1840613          	addi	a2,s0,-488
    80003ae8:	4581                	li	a1,0
    80003aea:	8526                	mv	a0,s1
    80003aec:	d2bfe0ef          	jal	ra,80002816 <readi>
    80003af0:	03800793          	li	a5,56
    80003af4:	f8f518e3          	bne	a0,a5,80003a84 <exec+0x268>
    if(ph.type != ELF_PROG_LOAD)
    80003af8:	e1842783          	lw	a5,-488(s0)
    80003afc:	4705                	li	a4,1
    80003afe:	fce798e3          	bne	a5,a4,80003ace <exec+0x2b2>
    if(ph.memsz < ph.filesz)
    80003b02:	e4043903          	ld	s2,-448(s0)
    80003b06:	e3843783          	ld	a5,-456(s0)
    80003b0a:	f8f968e3          	bltu	s2,a5,80003a9a <exec+0x27e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b0e:	e2843783          	ld	a5,-472(s0)
    80003b12:	993e                	add	s2,s2,a5
    80003b14:	f8f966e3          	bltu	s2,a5,80003aa0 <exec+0x284>
    if(ph.vaddr % PGSIZE != 0)
    80003b18:	df043703          	ld	a4,-528(s0)
    80003b1c:	8ff9                	and	a5,a5,a4
    80003b1e:	f7c1                	bnez	a5,80003aa6 <exec+0x28a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003b20:	e1c42503          	lw	a0,-484(s0)
    80003b24:	cddff0ef          	jal	ra,80003800 <flags2perm>
    80003b28:	86aa                	mv	a3,a0
    80003b2a:	864a                	mv	a2,s2
    80003b2c:	85d2                	mv	a1,s4
    80003b2e:	855e                	mv	a0,s7
    80003b30:	c93fc0ef          	jal	ra,800007c2 <uvmalloc>
    80003b34:	e0a43423          	sd	a0,-504(s0)
    80003b38:	d935                	beqz	a0,80003aac <exec+0x290>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003b3a:	e2843d03          	ld	s10,-472(s0)
    80003b3e:	e2042d83          	lw	s11,-480(s0)
    80003b42:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003b46:	f80c02e3          	beqz	s8,80003aca <exec+0x2ae>
    80003b4a:	8a62                	mv	s4,s8
    80003b4c:	4901                	li	s2,0
    80003b4e:	b3e9                	j	80003918 <exec+0xfc>

0000000080003b50 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003b50:	7179                	addi	sp,sp,-48
    80003b52:	f406                	sd	ra,40(sp)
    80003b54:	f022                	sd	s0,32(sp)
    80003b56:	ec26                	sd	s1,24(sp)
    80003b58:	e84a                	sd	s2,16(sp)
    80003b5a:	1800                	addi	s0,sp,48
    80003b5c:	892e                	mv	s2,a1
    80003b5e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003b60:	fdc40593          	addi	a1,s0,-36
    80003b64:	854fe0ef          	jal	ra,80001bb8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003b68:	fdc42703          	lw	a4,-36(s0)
    80003b6c:	47bd                	li	a5,15
    80003b6e:	02e7e963          	bltu	a5,a4,80003ba0 <argfd+0x50>
    80003b72:	99efd0ef          	jal	ra,80000d10 <myproc>
    80003b76:	fdc42703          	lw	a4,-36(s0)
    80003b7a:	01a70793          	addi	a5,a4,26
    80003b7e:	078e                	slli	a5,a5,0x3
    80003b80:	953e                	add	a0,a0,a5
    80003b82:	611c                	ld	a5,0(a0)
    80003b84:	c385                	beqz	a5,80003ba4 <argfd+0x54>
    return -1;
  if(pfd)
    80003b86:	00090463          	beqz	s2,80003b8e <argfd+0x3e>
    *pfd = fd;
    80003b8a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003b8e:	4501                	li	a0,0
  if(pf)
    80003b90:	c091                	beqz	s1,80003b94 <argfd+0x44>
    *pf = f;
    80003b92:	e09c                	sd	a5,0(s1)
}
    80003b94:	70a2                	ld	ra,40(sp)
    80003b96:	7402                	ld	s0,32(sp)
    80003b98:	64e2                	ld	s1,24(sp)
    80003b9a:	6942                	ld	s2,16(sp)
    80003b9c:	6145                	addi	sp,sp,48
    80003b9e:	8082                	ret
    return -1;
    80003ba0:	557d                	li	a0,-1
    80003ba2:	bfcd                	j	80003b94 <argfd+0x44>
    80003ba4:	557d                	li	a0,-1
    80003ba6:	b7fd                	j	80003b94 <argfd+0x44>

0000000080003ba8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003ba8:	1101                	addi	sp,sp,-32
    80003baa:	ec06                	sd	ra,24(sp)
    80003bac:	e822                	sd	s0,16(sp)
    80003bae:	e426                	sd	s1,8(sp)
    80003bb0:	1000                	addi	s0,sp,32
    80003bb2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003bb4:	95cfd0ef          	jal	ra,80000d10 <myproc>
    80003bb8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003bba:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffde4a0>
    80003bbe:	4501                	li	a0,0
    80003bc0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003bc2:	6398                	ld	a4,0(a5)
    80003bc4:	cb19                	beqz	a4,80003bda <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003bc6:	2505                	addiw	a0,a0,1
    80003bc8:	07a1                	addi	a5,a5,8
    80003bca:	fed51ce3          	bne	a0,a3,80003bc2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003bce:	557d                	li	a0,-1
}
    80003bd0:	60e2                	ld	ra,24(sp)
    80003bd2:	6442                	ld	s0,16(sp)
    80003bd4:	64a2                	ld	s1,8(sp)
    80003bd6:	6105                	addi	sp,sp,32
    80003bd8:	8082                	ret
      p->ofile[fd] = f;
    80003bda:	01a50793          	addi	a5,a0,26
    80003bde:	078e                	slli	a5,a5,0x3
    80003be0:	963e                	add	a2,a2,a5
    80003be2:	e204                	sd	s1,0(a2)
      return fd;
    80003be4:	b7f5                	j	80003bd0 <fdalloc+0x28>

0000000080003be6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003be6:	715d                	addi	sp,sp,-80
    80003be8:	e486                	sd	ra,72(sp)
    80003bea:	e0a2                	sd	s0,64(sp)
    80003bec:	fc26                	sd	s1,56(sp)
    80003bee:	f84a                	sd	s2,48(sp)
    80003bf0:	f44e                	sd	s3,40(sp)
    80003bf2:	f052                	sd	s4,32(sp)
    80003bf4:	ec56                	sd	s5,24(sp)
    80003bf6:	e85a                	sd	s6,16(sp)
    80003bf8:	0880                	addi	s0,sp,80
    80003bfa:	8b2e                	mv	s6,a1
    80003bfc:	89b2                	mv	s3,a2
    80003bfe:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003c00:	fb040593          	addi	a1,s0,-80
    80003c04:	88eff0ef          	jal	ra,80002c92 <nameiparent>
    80003c08:	84aa                	mv	s1,a0
    80003c0a:	10050c63          	beqz	a0,80003d22 <create+0x13c>
    return 0;

  ilock(dp);
    80003c0e:	9b9fe0ef          	jal	ra,800025c6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003c12:	4601                	li	a2,0
    80003c14:	fb040593          	addi	a1,s0,-80
    80003c18:	8526                	mv	a0,s1
    80003c1a:	df9fe0ef          	jal	ra,80002a12 <dirlookup>
    80003c1e:	8aaa                	mv	s5,a0
    80003c20:	c521                	beqz	a0,80003c68 <create+0x82>
    iunlockput(dp);
    80003c22:	8526                	mv	a0,s1
    80003c24:	ba9fe0ef          	jal	ra,800027cc <iunlockput>
    ilock(ip);
    80003c28:	8556                	mv	a0,s5
    80003c2a:	99dfe0ef          	jal	ra,800025c6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003c2e:	000b059b          	sext.w	a1,s6
    80003c32:	4789                	li	a5,2
    80003c34:	02f59563          	bne	a1,a5,80003c5e <create+0x78>
    80003c38:	044ad783          	lhu	a5,68(s5)
    80003c3c:	37f9                	addiw	a5,a5,-2
    80003c3e:	17c2                	slli	a5,a5,0x30
    80003c40:	93c1                	srli	a5,a5,0x30
    80003c42:	4705                	li	a4,1
    80003c44:	00f76d63          	bltu	a4,a5,80003c5e <create+0x78>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003c48:	8556                	mv	a0,s5
    80003c4a:	60a6                	ld	ra,72(sp)
    80003c4c:	6406                	ld	s0,64(sp)
    80003c4e:	74e2                	ld	s1,56(sp)
    80003c50:	7942                	ld	s2,48(sp)
    80003c52:	79a2                	ld	s3,40(sp)
    80003c54:	7a02                	ld	s4,32(sp)
    80003c56:	6ae2                	ld	s5,24(sp)
    80003c58:	6b42                	ld	s6,16(sp)
    80003c5a:	6161                	addi	sp,sp,80
    80003c5c:	8082                	ret
    iunlockput(ip);
    80003c5e:	8556                	mv	a0,s5
    80003c60:	b6dfe0ef          	jal	ra,800027cc <iunlockput>
    return 0;
    80003c64:	4a81                	li	s5,0
    80003c66:	b7cd                	j	80003c48 <create+0x62>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003c68:	85da                	mv	a1,s6
    80003c6a:	4088                	lw	a0,0(s1)
    80003c6c:	ff2fe0ef          	jal	ra,8000245e <ialloc>
    80003c70:	8a2a                	mv	s4,a0
    80003c72:	c121                	beqz	a0,80003cb2 <create+0xcc>
  ilock(ip);
    80003c74:	953fe0ef          	jal	ra,800025c6 <ilock>
  ip->major = major;
    80003c78:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003c7c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003c80:	4785                	li	a5,1
    80003c82:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80003c86:	8552                	mv	a0,s4
    80003c88:	88dfe0ef          	jal	ra,80002514 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003c8c:	000b059b          	sext.w	a1,s6
    80003c90:	4785                	li	a5,1
    80003c92:	02f58563          	beq	a1,a5,80003cbc <create+0xd6>
  if(dirlink(dp, name, ip->inum) < 0)
    80003c96:	004a2603          	lw	a2,4(s4)
    80003c9a:	fb040593          	addi	a1,s0,-80
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	f3ffe0ef          	jal	ra,80002bde <dirlink>
    80003ca4:	06054363          	bltz	a0,80003d0a <create+0x124>
  iunlockput(dp);
    80003ca8:	8526                	mv	a0,s1
    80003caa:	b23fe0ef          	jal	ra,800027cc <iunlockput>
  return ip;
    80003cae:	8ad2                	mv	s5,s4
    80003cb0:	bf61                	j	80003c48 <create+0x62>
    iunlockput(dp);
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	b19fe0ef          	jal	ra,800027cc <iunlockput>
    return 0;
    80003cb8:	8ad2                	mv	s5,s4
    80003cba:	b779                	j	80003c48 <create+0x62>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003cbc:	004a2603          	lw	a2,4(s4)
    80003cc0:	00004597          	auipc	a1,0x4
    80003cc4:	9f858593          	addi	a1,a1,-1544 # 800076b8 <syscalls+0x2a0>
    80003cc8:	8552                	mv	a0,s4
    80003cca:	f15fe0ef          	jal	ra,80002bde <dirlink>
    80003cce:	02054e63          	bltz	a0,80003d0a <create+0x124>
    80003cd2:	40d0                	lw	a2,4(s1)
    80003cd4:	00004597          	auipc	a1,0x4
    80003cd8:	9ec58593          	addi	a1,a1,-1556 # 800076c0 <syscalls+0x2a8>
    80003cdc:	8552                	mv	a0,s4
    80003cde:	f01fe0ef          	jal	ra,80002bde <dirlink>
    80003ce2:	02054463          	bltz	a0,80003d0a <create+0x124>
  if(dirlink(dp, name, ip->inum) < 0)
    80003ce6:	004a2603          	lw	a2,4(s4)
    80003cea:	fb040593          	addi	a1,s0,-80
    80003cee:	8526                	mv	a0,s1
    80003cf0:	eeffe0ef          	jal	ra,80002bde <dirlink>
    80003cf4:	00054b63          	bltz	a0,80003d0a <create+0x124>
    dp->nlink++;  // for ".."
    80003cf8:	04a4d783          	lhu	a5,74(s1)
    80003cfc:	2785                	addiw	a5,a5,1
    80003cfe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003d02:	8526                	mv	a0,s1
    80003d04:	811fe0ef          	jal	ra,80002514 <iupdate>
    80003d08:	b745                	j	80003ca8 <create+0xc2>
  ip->nlink = 0;
    80003d0a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003d0e:	8552                	mv	a0,s4
    80003d10:	805fe0ef          	jal	ra,80002514 <iupdate>
  iunlockput(ip);
    80003d14:	8552                	mv	a0,s4
    80003d16:	ab7fe0ef          	jal	ra,800027cc <iunlockput>
  iunlockput(dp);
    80003d1a:	8526                	mv	a0,s1
    80003d1c:	ab1fe0ef          	jal	ra,800027cc <iunlockput>
  return 0;
    80003d20:	b725                	j	80003c48 <create+0x62>
    return 0;
    80003d22:	8aaa                	mv	s5,a0
    80003d24:	b715                	j	80003c48 <create+0x62>

0000000080003d26 <sys_dup>:
{
    80003d26:	7179                	addi	sp,sp,-48
    80003d28:	f406                	sd	ra,40(sp)
    80003d2a:	f022                	sd	s0,32(sp)
    80003d2c:	ec26                	sd	s1,24(sp)
    80003d2e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003d30:	fd840613          	addi	a2,s0,-40
    80003d34:	4581                	li	a1,0
    80003d36:	4501                	li	a0,0
    80003d38:	e19ff0ef          	jal	ra,80003b50 <argfd>
    return -1;
    80003d3c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003d3e:	00054f63          	bltz	a0,80003d5c <sys_dup+0x36>
  if((fd=fdalloc(f)) < 0)
    80003d42:	fd843503          	ld	a0,-40(s0)
    80003d46:	e63ff0ef          	jal	ra,80003ba8 <fdalloc>
    80003d4a:	84aa                	mv	s1,a0
    return -1;
    80003d4c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003d4e:	00054763          	bltz	a0,80003d5c <sys_dup+0x36>
  filedup(f);
    80003d52:	fd843503          	ld	a0,-40(s0)
    80003d56:	cd0ff0ef          	jal	ra,80003226 <filedup>
  return fd;
    80003d5a:	87a6                	mv	a5,s1
}
    80003d5c:	853e                	mv	a0,a5
    80003d5e:	70a2                	ld	ra,40(sp)
    80003d60:	7402                	ld	s0,32(sp)
    80003d62:	64e2                	ld	s1,24(sp)
    80003d64:	6145                	addi	sp,sp,48
    80003d66:	8082                	ret

0000000080003d68 <sys_read>:
{
    80003d68:	7179                	addi	sp,sp,-48
    80003d6a:	f406                	sd	ra,40(sp)
    80003d6c:	f022                	sd	s0,32(sp)
    80003d6e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003d70:	fd840593          	addi	a1,s0,-40
    80003d74:	4505                	li	a0,1
    80003d76:	e5ffd0ef          	jal	ra,80001bd4 <argaddr>
  argint(2, &n);
    80003d7a:	fe440593          	addi	a1,s0,-28
    80003d7e:	4509                	li	a0,2
    80003d80:	e39fd0ef          	jal	ra,80001bb8 <argint>
  if(argfd(0, 0, &f) < 0)
    80003d84:	fe840613          	addi	a2,s0,-24
    80003d88:	4581                	li	a1,0
    80003d8a:	4501                	li	a0,0
    80003d8c:	dc5ff0ef          	jal	ra,80003b50 <argfd>
    80003d90:	87aa                	mv	a5,a0
    return -1;
    80003d92:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003d94:	0007ca63          	bltz	a5,80003da8 <sys_read+0x40>
  return fileread(f, p, n);
    80003d98:	fe442603          	lw	a2,-28(s0)
    80003d9c:	fd843583          	ld	a1,-40(s0)
    80003da0:	fe843503          	ld	a0,-24(s0)
    80003da4:	dceff0ef          	jal	ra,80003372 <fileread>
}
    80003da8:	70a2                	ld	ra,40(sp)
    80003daa:	7402                	ld	s0,32(sp)
    80003dac:	6145                	addi	sp,sp,48
    80003dae:	8082                	ret

0000000080003db0 <sys_write>:
{
    80003db0:	7179                	addi	sp,sp,-48
    80003db2:	f406                	sd	ra,40(sp)
    80003db4:	f022                	sd	s0,32(sp)
    80003db6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003db8:	fd840593          	addi	a1,s0,-40
    80003dbc:	4505                	li	a0,1
    80003dbe:	e17fd0ef          	jal	ra,80001bd4 <argaddr>
  argint(2, &n);
    80003dc2:	fe440593          	addi	a1,s0,-28
    80003dc6:	4509                	li	a0,2
    80003dc8:	df1fd0ef          	jal	ra,80001bb8 <argint>
  if(argfd(0, 0, &f) < 0)
    80003dcc:	fe840613          	addi	a2,s0,-24
    80003dd0:	4581                	li	a1,0
    80003dd2:	4501                	li	a0,0
    80003dd4:	d7dff0ef          	jal	ra,80003b50 <argfd>
    80003dd8:	87aa                	mv	a5,a0
    return -1;
    80003dda:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003ddc:	0007ca63          	bltz	a5,80003df0 <sys_write+0x40>
  return filewrite(f, p, n);
    80003de0:	fe442603          	lw	a2,-28(s0)
    80003de4:	fd843583          	ld	a1,-40(s0)
    80003de8:	fe843503          	ld	a0,-24(s0)
    80003dec:	e34ff0ef          	jal	ra,80003420 <filewrite>
}
    80003df0:	70a2                	ld	ra,40(sp)
    80003df2:	7402                	ld	s0,32(sp)
    80003df4:	6145                	addi	sp,sp,48
    80003df6:	8082                	ret

0000000080003df8 <sys_close>:
{
    80003df8:	1101                	addi	sp,sp,-32
    80003dfa:	ec06                	sd	ra,24(sp)
    80003dfc:	e822                	sd	s0,16(sp)
    80003dfe:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80003e00:	fe040613          	addi	a2,s0,-32
    80003e04:	fec40593          	addi	a1,s0,-20
    80003e08:	4501                	li	a0,0
    80003e0a:	d47ff0ef          	jal	ra,80003b50 <argfd>
    return -1;
    80003e0e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80003e10:	02054063          	bltz	a0,80003e30 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80003e14:	efdfc0ef          	jal	ra,80000d10 <myproc>
    80003e18:	fec42783          	lw	a5,-20(s0)
    80003e1c:	07e9                	addi	a5,a5,26
    80003e1e:	078e                	slli	a5,a5,0x3
    80003e20:	97aa                	add	a5,a5,a0
    80003e22:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80003e26:	fe043503          	ld	a0,-32(s0)
    80003e2a:	c42ff0ef          	jal	ra,8000326c <fileclose>
  return 0;
    80003e2e:	4781                	li	a5,0
}
    80003e30:	853e                	mv	a0,a5
    80003e32:	60e2                	ld	ra,24(sp)
    80003e34:	6442                	ld	s0,16(sp)
    80003e36:	6105                	addi	sp,sp,32
    80003e38:	8082                	ret

0000000080003e3a <sys_fstat>:
{
    80003e3a:	1101                	addi	sp,sp,-32
    80003e3c:	ec06                	sd	ra,24(sp)
    80003e3e:	e822                	sd	s0,16(sp)
    80003e40:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80003e42:	fe040593          	addi	a1,s0,-32
    80003e46:	4505                	li	a0,1
    80003e48:	d8dfd0ef          	jal	ra,80001bd4 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80003e4c:	fe840613          	addi	a2,s0,-24
    80003e50:	4581                	li	a1,0
    80003e52:	4501                	li	a0,0
    80003e54:	cfdff0ef          	jal	ra,80003b50 <argfd>
    80003e58:	87aa                	mv	a5,a0
    return -1;
    80003e5a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003e5c:	0007c863          	bltz	a5,80003e6c <sys_fstat+0x32>
  return filestat(f, st);
    80003e60:	fe043583          	ld	a1,-32(s0)
    80003e64:	fe843503          	ld	a0,-24(s0)
    80003e68:	cacff0ef          	jal	ra,80003314 <filestat>
}
    80003e6c:	60e2                	ld	ra,24(sp)
    80003e6e:	6442                	ld	s0,16(sp)
    80003e70:	6105                	addi	sp,sp,32
    80003e72:	8082                	ret

0000000080003e74 <sys_link>:
{
    80003e74:	7169                	addi	sp,sp,-304
    80003e76:	f606                	sd	ra,296(sp)
    80003e78:	f222                	sd	s0,288(sp)
    80003e7a:	ee26                	sd	s1,280(sp)
    80003e7c:	ea4a                	sd	s2,272(sp)
    80003e7e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003e80:	08000613          	li	a2,128
    80003e84:	ed040593          	addi	a1,s0,-304
    80003e88:	4501                	li	a0,0
    80003e8a:	d67fd0ef          	jal	ra,80001bf0 <argstr>
    return -1;
    80003e8e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003e90:	0c054663          	bltz	a0,80003f5c <sys_link+0xe8>
    80003e94:	08000613          	li	a2,128
    80003e98:	f5040593          	addi	a1,s0,-176
    80003e9c:	4505                	li	a0,1
    80003e9e:	d53fd0ef          	jal	ra,80001bf0 <argstr>
    return -1;
    80003ea2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80003ea4:	0a054c63          	bltz	a0,80003f5c <sys_link+0xe8>
  begin_op();
    80003ea8:	fa9fe0ef          	jal	ra,80002e50 <begin_op>
  if((ip = namei(old)) == 0){
    80003eac:	ed040513          	addi	a0,s0,-304
    80003eb0:	dc9fe0ef          	jal	ra,80002c78 <namei>
    80003eb4:	84aa                	mv	s1,a0
    80003eb6:	c525                	beqz	a0,80003f1e <sys_link+0xaa>
  ilock(ip);
    80003eb8:	f0efe0ef          	jal	ra,800025c6 <ilock>
  if(ip->type == T_DIR){
    80003ebc:	04449703          	lh	a4,68(s1)
    80003ec0:	4785                	li	a5,1
    80003ec2:	06f70263          	beq	a4,a5,80003f26 <sys_link+0xb2>
  ip->nlink++;
    80003ec6:	04a4d783          	lhu	a5,74(s1)
    80003eca:	2785                	addiw	a5,a5,1
    80003ecc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	e42fe0ef          	jal	ra,80002514 <iupdate>
  iunlock(ip);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	f98fe0ef          	jal	ra,80002670 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80003edc:	fd040593          	addi	a1,s0,-48
    80003ee0:	f5040513          	addi	a0,s0,-176
    80003ee4:	daffe0ef          	jal	ra,80002c92 <nameiparent>
    80003ee8:	892a                	mv	s2,a0
    80003eea:	c921                	beqz	a0,80003f3a <sys_link+0xc6>
  ilock(dp);
    80003eec:	edafe0ef          	jal	ra,800025c6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80003ef0:	00092703          	lw	a4,0(s2)
    80003ef4:	409c                	lw	a5,0(s1)
    80003ef6:	02f71f63          	bne	a4,a5,80003f34 <sys_link+0xc0>
    80003efa:	40d0                	lw	a2,4(s1)
    80003efc:	fd040593          	addi	a1,s0,-48
    80003f00:	854a                	mv	a0,s2
    80003f02:	cddfe0ef          	jal	ra,80002bde <dirlink>
    80003f06:	02054763          	bltz	a0,80003f34 <sys_link+0xc0>
  iunlockput(dp);
    80003f0a:	854a                	mv	a0,s2
    80003f0c:	8c1fe0ef          	jal	ra,800027cc <iunlockput>
  iput(ip);
    80003f10:	8526                	mv	a0,s1
    80003f12:	833fe0ef          	jal	ra,80002744 <iput>
  end_op();
    80003f16:	fabfe0ef          	jal	ra,80002ec0 <end_op>
  return 0;
    80003f1a:	4781                	li	a5,0
    80003f1c:	a081                	j	80003f5c <sys_link+0xe8>
    end_op();
    80003f1e:	fa3fe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    80003f22:	57fd                	li	a5,-1
    80003f24:	a825                	j	80003f5c <sys_link+0xe8>
    iunlockput(ip);
    80003f26:	8526                	mv	a0,s1
    80003f28:	8a5fe0ef          	jal	ra,800027cc <iunlockput>
    end_op();
    80003f2c:	f95fe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    80003f30:	57fd                	li	a5,-1
    80003f32:	a02d                	j	80003f5c <sys_link+0xe8>
    iunlockput(dp);
    80003f34:	854a                	mv	a0,s2
    80003f36:	897fe0ef          	jal	ra,800027cc <iunlockput>
  ilock(ip);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	e8afe0ef          	jal	ra,800025c6 <ilock>
  ip->nlink--;
    80003f40:	04a4d783          	lhu	a5,74(s1)
    80003f44:	37fd                	addiw	a5,a5,-1
    80003f46:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	dc8fe0ef          	jal	ra,80002514 <iupdate>
  iunlockput(ip);
    80003f50:	8526                	mv	a0,s1
    80003f52:	87bfe0ef          	jal	ra,800027cc <iunlockput>
  end_op();
    80003f56:	f6bfe0ef          	jal	ra,80002ec0 <end_op>
  return -1;
    80003f5a:	57fd                	li	a5,-1
}
    80003f5c:	853e                	mv	a0,a5
    80003f5e:	70b2                	ld	ra,296(sp)
    80003f60:	7412                	ld	s0,288(sp)
    80003f62:	64f2                	ld	s1,280(sp)
    80003f64:	6952                	ld	s2,272(sp)
    80003f66:	6155                	addi	sp,sp,304
    80003f68:	8082                	ret

0000000080003f6a <sys_unlink>:
{
    80003f6a:	7151                	addi	sp,sp,-240
    80003f6c:	f586                	sd	ra,232(sp)
    80003f6e:	f1a2                	sd	s0,224(sp)
    80003f70:	eda6                	sd	s1,216(sp)
    80003f72:	e9ca                	sd	s2,208(sp)
    80003f74:	e5ce                	sd	s3,200(sp)
    80003f76:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80003f78:	08000613          	li	a2,128
    80003f7c:	f3040593          	addi	a1,s0,-208
    80003f80:	4501                	li	a0,0
    80003f82:	c6ffd0ef          	jal	ra,80001bf0 <argstr>
    80003f86:	12054b63          	bltz	a0,800040bc <sys_unlink+0x152>
  begin_op();
    80003f8a:	ec7fe0ef          	jal	ra,80002e50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80003f8e:	fb040593          	addi	a1,s0,-80
    80003f92:	f3040513          	addi	a0,s0,-208
    80003f96:	cfdfe0ef          	jal	ra,80002c92 <nameiparent>
    80003f9a:	84aa                	mv	s1,a0
    80003f9c:	c54d                	beqz	a0,80004046 <sys_unlink+0xdc>
  ilock(dp);
    80003f9e:	e28fe0ef          	jal	ra,800025c6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80003fa2:	00003597          	auipc	a1,0x3
    80003fa6:	71658593          	addi	a1,a1,1814 # 800076b8 <syscalls+0x2a0>
    80003faa:	fb040513          	addi	a0,s0,-80
    80003fae:	a4ffe0ef          	jal	ra,800029fc <namecmp>
    80003fb2:	10050a63          	beqz	a0,800040c6 <sys_unlink+0x15c>
    80003fb6:	00003597          	auipc	a1,0x3
    80003fba:	70a58593          	addi	a1,a1,1802 # 800076c0 <syscalls+0x2a8>
    80003fbe:	fb040513          	addi	a0,s0,-80
    80003fc2:	a3bfe0ef          	jal	ra,800029fc <namecmp>
    80003fc6:	10050063          	beqz	a0,800040c6 <sys_unlink+0x15c>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80003fca:	f2c40613          	addi	a2,s0,-212
    80003fce:	fb040593          	addi	a1,s0,-80
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	a3ffe0ef          	jal	ra,80002a12 <dirlookup>
    80003fd8:	892a                	mv	s2,a0
    80003fda:	0e050663          	beqz	a0,800040c6 <sys_unlink+0x15c>
  ilock(ip);
    80003fde:	de8fe0ef          	jal	ra,800025c6 <ilock>
  if(ip->nlink < 1)
    80003fe2:	04a91783          	lh	a5,74(s2)
    80003fe6:	06f05463          	blez	a5,8000404e <sys_unlink+0xe4>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80003fea:	04491703          	lh	a4,68(s2)
    80003fee:	4785                	li	a5,1
    80003ff0:	06f70563          	beq	a4,a5,8000405a <sys_unlink+0xf0>
  memset(&de, 0, sizeof(de));
    80003ff4:	4641                	li	a2,16
    80003ff6:	4581                	li	a1,0
    80003ff8:	fc040513          	addi	a0,s0,-64
    80003ffc:	950fc0ef          	jal	ra,8000014c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004000:	4741                	li	a4,16
    80004002:	f2c42683          	lw	a3,-212(s0)
    80004006:	fc040613          	addi	a2,s0,-64
    8000400a:	4581                	li	a1,0
    8000400c:	8526                	mv	a0,s1
    8000400e:	8edfe0ef          	jal	ra,800028fa <writei>
    80004012:	47c1                	li	a5,16
    80004014:	08f51563          	bne	a0,a5,8000409e <sys_unlink+0x134>
  if(ip->type == T_DIR){
    80004018:	04491703          	lh	a4,68(s2)
    8000401c:	4785                	li	a5,1
    8000401e:	08f70663          	beq	a4,a5,800040aa <sys_unlink+0x140>
  iunlockput(dp);
    80004022:	8526                	mv	a0,s1
    80004024:	fa8fe0ef          	jal	ra,800027cc <iunlockput>
  ip->nlink--;
    80004028:	04a95783          	lhu	a5,74(s2)
    8000402c:	37fd                	addiw	a5,a5,-1
    8000402e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004032:	854a                	mv	a0,s2
    80004034:	ce0fe0ef          	jal	ra,80002514 <iupdate>
  iunlockput(ip);
    80004038:	854a                	mv	a0,s2
    8000403a:	f92fe0ef          	jal	ra,800027cc <iunlockput>
  end_op();
    8000403e:	e83fe0ef          	jal	ra,80002ec0 <end_op>
  return 0;
    80004042:	4501                	li	a0,0
    80004044:	a079                	j	800040d2 <sys_unlink+0x168>
    end_op();
    80004046:	e7bfe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    8000404a:	557d                	li	a0,-1
    8000404c:	a059                	j	800040d2 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000404e:	00003517          	auipc	a0,0x3
    80004052:	67a50513          	addi	a0,a0,1658 # 800076c8 <syscalls+0x2b0>
    80004056:	22c010ef          	jal	ra,80005282 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000405a:	04c92703          	lw	a4,76(s2)
    8000405e:	02000793          	li	a5,32
    80004062:	f8e7f9e3          	bgeu	a5,a4,80003ff4 <sys_unlink+0x8a>
    80004066:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000406a:	4741                	li	a4,16
    8000406c:	86ce                	mv	a3,s3
    8000406e:	f1840613          	addi	a2,s0,-232
    80004072:	4581                	li	a1,0
    80004074:	854a                	mv	a0,s2
    80004076:	fa0fe0ef          	jal	ra,80002816 <readi>
    8000407a:	47c1                	li	a5,16
    8000407c:	00f51b63          	bne	a0,a5,80004092 <sys_unlink+0x128>
    if(de.inum != 0)
    80004080:	f1845783          	lhu	a5,-232(s0)
    80004084:	ef95                	bnez	a5,800040c0 <sys_unlink+0x156>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004086:	29c1                	addiw	s3,s3,16
    80004088:	04c92783          	lw	a5,76(s2)
    8000408c:	fcf9efe3          	bltu	s3,a5,8000406a <sys_unlink+0x100>
    80004090:	b795                	j	80003ff4 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004092:	00003517          	auipc	a0,0x3
    80004096:	64e50513          	addi	a0,a0,1614 # 800076e0 <syscalls+0x2c8>
    8000409a:	1e8010ef          	jal	ra,80005282 <panic>
    panic("unlink: writei");
    8000409e:	00003517          	auipc	a0,0x3
    800040a2:	65a50513          	addi	a0,a0,1626 # 800076f8 <syscalls+0x2e0>
    800040a6:	1dc010ef          	jal	ra,80005282 <panic>
    dp->nlink--;
    800040aa:	04a4d783          	lhu	a5,74(s1)
    800040ae:	37fd                	addiw	a5,a5,-1
    800040b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800040b4:	8526                	mv	a0,s1
    800040b6:	c5efe0ef          	jal	ra,80002514 <iupdate>
    800040ba:	b7a5                	j	80004022 <sys_unlink+0xb8>
    return -1;
    800040bc:	557d                	li	a0,-1
    800040be:	a811                	j	800040d2 <sys_unlink+0x168>
    iunlockput(ip);
    800040c0:	854a                	mv	a0,s2
    800040c2:	f0afe0ef          	jal	ra,800027cc <iunlockput>
  iunlockput(dp);
    800040c6:	8526                	mv	a0,s1
    800040c8:	f04fe0ef          	jal	ra,800027cc <iunlockput>
  end_op();
    800040cc:	df5fe0ef          	jal	ra,80002ec0 <end_op>
  return -1;
    800040d0:	557d                	li	a0,-1
}
    800040d2:	70ae                	ld	ra,232(sp)
    800040d4:	740e                	ld	s0,224(sp)
    800040d6:	64ee                	ld	s1,216(sp)
    800040d8:	694e                	ld	s2,208(sp)
    800040da:	69ae                	ld	s3,200(sp)
    800040dc:	616d                	addi	sp,sp,240
    800040de:	8082                	ret

00000000800040e0 <sys_open>:

uint64
sys_open(void)
{
    800040e0:	7131                	addi	sp,sp,-192
    800040e2:	fd06                	sd	ra,184(sp)
    800040e4:	f922                	sd	s0,176(sp)
    800040e6:	f526                	sd	s1,168(sp)
    800040e8:	f14a                	sd	s2,160(sp)
    800040ea:	ed4e                	sd	s3,152(sp)
    800040ec:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800040ee:	f4c40593          	addi	a1,s0,-180
    800040f2:	4505                	li	a0,1
    800040f4:	ac5fd0ef          	jal	ra,80001bb8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800040f8:	08000613          	li	a2,128
    800040fc:	f5040593          	addi	a1,s0,-176
    80004100:	4501                	li	a0,0
    80004102:	aeffd0ef          	jal	ra,80001bf0 <argstr>
    80004106:	87aa                	mv	a5,a0
    return -1;
    80004108:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000410a:	0807cd63          	bltz	a5,800041a4 <sys_open+0xc4>

  begin_op();
    8000410e:	d43fe0ef          	jal	ra,80002e50 <begin_op>

  if(omode & O_CREATE){
    80004112:	f4c42783          	lw	a5,-180(s0)
    80004116:	2007f793          	andi	a5,a5,512
    8000411a:	c3c5                	beqz	a5,800041ba <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000411c:	4681                	li	a3,0
    8000411e:	4601                	li	a2,0
    80004120:	4589                	li	a1,2
    80004122:	f5040513          	addi	a0,s0,-176
    80004126:	ac1ff0ef          	jal	ra,80003be6 <create>
    8000412a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000412c:	c159                	beqz	a0,800041b2 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000412e:	04449703          	lh	a4,68(s1)
    80004132:	478d                	li	a5,3
    80004134:	00f71763          	bne	a4,a5,80004142 <sys_open+0x62>
    80004138:	0464d703          	lhu	a4,70(s1)
    8000413c:	47a5                	li	a5,9
    8000413e:	0ae7e963          	bltu	a5,a4,800041f0 <sys_open+0x110>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004142:	886ff0ef          	jal	ra,800031c8 <filealloc>
    80004146:	89aa                	mv	s3,a0
    80004148:	0c050963          	beqz	a0,8000421a <sys_open+0x13a>
    8000414c:	a5dff0ef          	jal	ra,80003ba8 <fdalloc>
    80004150:	892a                	mv	s2,a0
    80004152:	0c054163          	bltz	a0,80004214 <sys_open+0x134>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004156:	04449703          	lh	a4,68(s1)
    8000415a:	478d                	li	a5,3
    8000415c:	0af70163          	beq	a4,a5,800041fe <sys_open+0x11e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004160:	4789                	li	a5,2
    80004162:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004166:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000416a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000416e:	f4c42783          	lw	a5,-180(s0)
    80004172:	0017c713          	xori	a4,a5,1
    80004176:	8b05                	andi	a4,a4,1
    80004178:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000417c:	0037f713          	andi	a4,a5,3
    80004180:	00e03733          	snez	a4,a4
    80004184:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004188:	4007f793          	andi	a5,a5,1024
    8000418c:	c791                	beqz	a5,80004198 <sys_open+0xb8>
    8000418e:	04449703          	lh	a4,68(s1)
    80004192:	4789                	li	a5,2
    80004194:	06f70c63          	beq	a4,a5,8000420c <sys_open+0x12c>
    itrunc(ip);
  }

  iunlock(ip);
    80004198:	8526                	mv	a0,s1
    8000419a:	cd6fe0ef          	jal	ra,80002670 <iunlock>
  end_op();
    8000419e:	d23fe0ef          	jal	ra,80002ec0 <end_op>

  return fd;
    800041a2:	854a                	mv	a0,s2
}
    800041a4:	70ea                	ld	ra,184(sp)
    800041a6:	744a                	ld	s0,176(sp)
    800041a8:	74aa                	ld	s1,168(sp)
    800041aa:	790a                	ld	s2,160(sp)
    800041ac:	69ea                	ld	s3,152(sp)
    800041ae:	6129                	addi	sp,sp,192
    800041b0:	8082                	ret
      end_op();
    800041b2:	d0ffe0ef          	jal	ra,80002ec0 <end_op>
      return -1;
    800041b6:	557d                	li	a0,-1
    800041b8:	b7f5                	j	800041a4 <sys_open+0xc4>
    if((ip = namei(path)) == 0){
    800041ba:	f5040513          	addi	a0,s0,-176
    800041be:	abbfe0ef          	jal	ra,80002c78 <namei>
    800041c2:	84aa                	mv	s1,a0
    800041c4:	c115                	beqz	a0,800041e8 <sys_open+0x108>
    ilock(ip);
    800041c6:	c00fe0ef          	jal	ra,800025c6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800041ca:	04449703          	lh	a4,68(s1)
    800041ce:	4785                	li	a5,1
    800041d0:	f4f71fe3          	bne	a4,a5,8000412e <sys_open+0x4e>
    800041d4:	f4c42783          	lw	a5,-180(s0)
    800041d8:	d7ad                	beqz	a5,80004142 <sys_open+0x62>
      iunlockput(ip);
    800041da:	8526                	mv	a0,s1
    800041dc:	df0fe0ef          	jal	ra,800027cc <iunlockput>
      end_op();
    800041e0:	ce1fe0ef          	jal	ra,80002ec0 <end_op>
      return -1;
    800041e4:	557d                	li	a0,-1
    800041e6:	bf7d                	j	800041a4 <sys_open+0xc4>
      end_op();
    800041e8:	cd9fe0ef          	jal	ra,80002ec0 <end_op>
      return -1;
    800041ec:	557d                	li	a0,-1
    800041ee:	bf5d                	j	800041a4 <sys_open+0xc4>
    iunlockput(ip);
    800041f0:	8526                	mv	a0,s1
    800041f2:	ddafe0ef          	jal	ra,800027cc <iunlockput>
    end_op();
    800041f6:	ccbfe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    800041fa:	557d                	li	a0,-1
    800041fc:	b765                	j	800041a4 <sys_open+0xc4>
    f->type = FD_DEVICE;
    800041fe:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004202:	04649783          	lh	a5,70(s1)
    80004206:	02f99223          	sh	a5,36(s3)
    8000420a:	b785                	j	8000416a <sys_open+0x8a>
    itrunc(ip);
    8000420c:	8526                	mv	a0,s1
    8000420e:	ca2fe0ef          	jal	ra,800026b0 <itrunc>
    80004212:	b759                	j	80004198 <sys_open+0xb8>
      fileclose(f);
    80004214:	854e                	mv	a0,s3
    80004216:	856ff0ef          	jal	ra,8000326c <fileclose>
    iunlockput(ip);
    8000421a:	8526                	mv	a0,s1
    8000421c:	db0fe0ef          	jal	ra,800027cc <iunlockput>
    end_op();
    80004220:	ca1fe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    80004224:	557d                	li	a0,-1
    80004226:	bfbd                	j	800041a4 <sys_open+0xc4>

0000000080004228 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004228:	7175                	addi	sp,sp,-144
    8000422a:	e506                	sd	ra,136(sp)
    8000422c:	e122                	sd	s0,128(sp)
    8000422e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004230:	c21fe0ef          	jal	ra,80002e50 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004234:	08000613          	li	a2,128
    80004238:	f7040593          	addi	a1,s0,-144
    8000423c:	4501                	li	a0,0
    8000423e:	9b3fd0ef          	jal	ra,80001bf0 <argstr>
    80004242:	02054363          	bltz	a0,80004268 <sys_mkdir+0x40>
    80004246:	4681                	li	a3,0
    80004248:	4601                	li	a2,0
    8000424a:	4585                	li	a1,1
    8000424c:	f7040513          	addi	a0,s0,-144
    80004250:	997ff0ef          	jal	ra,80003be6 <create>
    80004254:	c911                	beqz	a0,80004268 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004256:	d76fe0ef          	jal	ra,800027cc <iunlockput>
  end_op();
    8000425a:	c67fe0ef          	jal	ra,80002ec0 <end_op>
  return 0;
    8000425e:	4501                	li	a0,0
}
    80004260:	60aa                	ld	ra,136(sp)
    80004262:	640a                	ld	s0,128(sp)
    80004264:	6149                	addi	sp,sp,144
    80004266:	8082                	ret
    end_op();
    80004268:	c59fe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    8000426c:	557d                	li	a0,-1
    8000426e:	bfcd                	j	80004260 <sys_mkdir+0x38>

0000000080004270 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004270:	7135                	addi	sp,sp,-160
    80004272:	ed06                	sd	ra,152(sp)
    80004274:	e922                	sd	s0,144(sp)
    80004276:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004278:	bd9fe0ef          	jal	ra,80002e50 <begin_op>
  argint(1, &major);
    8000427c:	f6c40593          	addi	a1,s0,-148
    80004280:	4505                	li	a0,1
    80004282:	937fd0ef          	jal	ra,80001bb8 <argint>
  argint(2, &minor);
    80004286:	f6840593          	addi	a1,s0,-152
    8000428a:	4509                	li	a0,2
    8000428c:	92dfd0ef          	jal	ra,80001bb8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004290:	08000613          	li	a2,128
    80004294:	f7040593          	addi	a1,s0,-144
    80004298:	4501                	li	a0,0
    8000429a:	957fd0ef          	jal	ra,80001bf0 <argstr>
    8000429e:	02054563          	bltz	a0,800042c8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800042a2:	f6841683          	lh	a3,-152(s0)
    800042a6:	f6c41603          	lh	a2,-148(s0)
    800042aa:	458d                	li	a1,3
    800042ac:	f7040513          	addi	a0,s0,-144
    800042b0:	937ff0ef          	jal	ra,80003be6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800042b4:	c911                	beqz	a0,800042c8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800042b6:	d16fe0ef          	jal	ra,800027cc <iunlockput>
  end_op();
    800042ba:	c07fe0ef          	jal	ra,80002ec0 <end_op>
  return 0;
    800042be:	4501                	li	a0,0
}
    800042c0:	60ea                	ld	ra,152(sp)
    800042c2:	644a                	ld	s0,144(sp)
    800042c4:	610d                	addi	sp,sp,160
    800042c6:	8082                	ret
    end_op();
    800042c8:	bf9fe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    800042cc:	557d                	li	a0,-1
    800042ce:	bfcd                	j	800042c0 <sys_mknod+0x50>

00000000800042d0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800042d0:	7135                	addi	sp,sp,-160
    800042d2:	ed06                	sd	ra,152(sp)
    800042d4:	e922                	sd	s0,144(sp)
    800042d6:	e526                	sd	s1,136(sp)
    800042d8:	e14a                	sd	s2,128(sp)
    800042da:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800042dc:	a35fc0ef          	jal	ra,80000d10 <myproc>
    800042e0:	892a                	mv	s2,a0
  
  begin_op();
    800042e2:	b6ffe0ef          	jal	ra,80002e50 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800042e6:	08000613          	li	a2,128
    800042ea:	f6040593          	addi	a1,s0,-160
    800042ee:	4501                	li	a0,0
    800042f0:	901fd0ef          	jal	ra,80001bf0 <argstr>
    800042f4:	04054163          	bltz	a0,80004336 <sys_chdir+0x66>
    800042f8:	f6040513          	addi	a0,s0,-160
    800042fc:	97dfe0ef          	jal	ra,80002c78 <namei>
    80004300:	84aa                	mv	s1,a0
    80004302:	c915                	beqz	a0,80004336 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004304:	ac2fe0ef          	jal	ra,800025c6 <ilock>
  if(ip->type != T_DIR){
    80004308:	04449703          	lh	a4,68(s1)
    8000430c:	4785                	li	a5,1
    8000430e:	02f71863          	bne	a4,a5,8000433e <sys_chdir+0x6e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004312:	8526                	mv	a0,s1
    80004314:	b5cfe0ef          	jal	ra,80002670 <iunlock>
  iput(p->cwd);
    80004318:	15093503          	ld	a0,336(s2)
    8000431c:	c28fe0ef          	jal	ra,80002744 <iput>
  end_op();
    80004320:	ba1fe0ef          	jal	ra,80002ec0 <end_op>
  p->cwd = ip;
    80004324:	14993823          	sd	s1,336(s2)
  return 0;
    80004328:	4501                	li	a0,0
}
    8000432a:	60ea                	ld	ra,152(sp)
    8000432c:	644a                	ld	s0,144(sp)
    8000432e:	64aa                	ld	s1,136(sp)
    80004330:	690a                	ld	s2,128(sp)
    80004332:	610d                	addi	sp,sp,160
    80004334:	8082                	ret
    end_op();
    80004336:	b8bfe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    8000433a:	557d                	li	a0,-1
    8000433c:	b7fd                	j	8000432a <sys_chdir+0x5a>
    iunlockput(ip);
    8000433e:	8526                	mv	a0,s1
    80004340:	c8cfe0ef          	jal	ra,800027cc <iunlockput>
    end_op();
    80004344:	b7dfe0ef          	jal	ra,80002ec0 <end_op>
    return -1;
    80004348:	557d                	li	a0,-1
    8000434a:	b7c5                	j	8000432a <sys_chdir+0x5a>

000000008000434c <sys_exec>:

uint64
sys_exec(void)
{
    8000434c:	7145                	addi	sp,sp,-464
    8000434e:	e786                	sd	ra,456(sp)
    80004350:	e3a2                	sd	s0,448(sp)
    80004352:	ff26                	sd	s1,440(sp)
    80004354:	fb4a                	sd	s2,432(sp)
    80004356:	f74e                	sd	s3,424(sp)
    80004358:	f352                	sd	s4,416(sp)
    8000435a:	ef56                	sd	s5,408(sp)
    8000435c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000435e:	e3840593          	addi	a1,s0,-456
    80004362:	4505                	li	a0,1
    80004364:	871fd0ef          	jal	ra,80001bd4 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004368:	08000613          	li	a2,128
    8000436c:	f4040593          	addi	a1,s0,-192
    80004370:	4501                	li	a0,0
    80004372:	87ffd0ef          	jal	ra,80001bf0 <argstr>
    80004376:	87aa                	mv	a5,a0
    return -1;
    80004378:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000437a:	0a07c463          	bltz	a5,80004422 <sys_exec+0xd6>
  }
  memset(argv, 0, sizeof(argv));
    8000437e:	10000613          	li	a2,256
    80004382:	4581                	li	a1,0
    80004384:	e4040513          	addi	a0,s0,-448
    80004388:	dc5fb0ef          	jal	ra,8000014c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000438c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004390:	89a6                	mv	s3,s1
    80004392:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004394:	02000a13          	li	s4,32
    80004398:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000439c:	00391513          	slli	a0,s2,0x3
    800043a0:	e3040593          	addi	a1,s0,-464
    800043a4:	e3843783          	ld	a5,-456(s0)
    800043a8:	953e                	add	a0,a0,a5
    800043aa:	f84fd0ef          	jal	ra,80001b2e <fetchaddr>
    800043ae:	02054663          	bltz	a0,800043da <sys_exec+0x8e>
      goto bad;
    }
    if(uarg == 0){
    800043b2:	e3043783          	ld	a5,-464(s0)
    800043b6:	cf8d                	beqz	a5,800043f0 <sys_exec+0xa4>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800043b8:	d45fb0ef          	jal	ra,800000fc <kalloc>
    800043bc:	85aa                	mv	a1,a0
    800043be:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800043c2:	cd01                	beqz	a0,800043da <sys_exec+0x8e>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800043c4:	6605                	lui	a2,0x1
    800043c6:	e3043503          	ld	a0,-464(s0)
    800043ca:	faefd0ef          	jal	ra,80001b78 <fetchstr>
    800043ce:	00054663          	bltz	a0,800043da <sys_exec+0x8e>
    if(i >= NELEM(argv)){
    800043d2:	0905                	addi	s2,s2,1
    800043d4:	09a1                	addi	s3,s3,8
    800043d6:	fd4911e3          	bne	s2,s4,80004398 <sys_exec+0x4c>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800043da:	10048913          	addi	s2,s1,256
    800043de:	6088                	ld	a0,0(s1)
    800043e0:	c121                	beqz	a0,80004420 <sys_exec+0xd4>
    kfree(argv[i]);
    800043e2:	c3bfb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800043e6:	04a1                	addi	s1,s1,8
    800043e8:	ff249be3          	bne	s1,s2,800043de <sys_exec+0x92>
  return -1;
    800043ec:	557d                	li	a0,-1
    800043ee:	a815                	j	80004422 <sys_exec+0xd6>
      argv[i] = 0;
    800043f0:	0a8e                	slli	s5,s5,0x3
    800043f2:	fc040793          	addi	a5,s0,-64
    800043f6:	9abe                	add	s5,s5,a5
    800043f8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800043fc:	e4040593          	addi	a1,s0,-448
    80004400:	f4040513          	addi	a0,s0,-192
    80004404:	c18ff0ef          	jal	ra,8000381c <exec>
    80004408:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000440a:	10048993          	addi	s3,s1,256
    8000440e:	6088                	ld	a0,0(s1)
    80004410:	c511                	beqz	a0,8000441c <sys_exec+0xd0>
    kfree(argv[i]);
    80004412:	c0bfb0ef          	jal	ra,8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004416:	04a1                	addi	s1,s1,8
    80004418:	ff349be3          	bne	s1,s3,8000440e <sys_exec+0xc2>
  return ret;
    8000441c:	854a                	mv	a0,s2
    8000441e:	a011                	j	80004422 <sys_exec+0xd6>
  return -1;
    80004420:	557d                	li	a0,-1
}
    80004422:	60be                	ld	ra,456(sp)
    80004424:	641e                	ld	s0,448(sp)
    80004426:	74fa                	ld	s1,440(sp)
    80004428:	795a                	ld	s2,432(sp)
    8000442a:	79ba                	ld	s3,424(sp)
    8000442c:	7a1a                	ld	s4,416(sp)
    8000442e:	6afa                	ld	s5,408(sp)
    80004430:	6179                	addi	sp,sp,464
    80004432:	8082                	ret

0000000080004434 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004434:	7139                	addi	sp,sp,-64
    80004436:	fc06                	sd	ra,56(sp)
    80004438:	f822                	sd	s0,48(sp)
    8000443a:	f426                	sd	s1,40(sp)
    8000443c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000443e:	8d3fc0ef          	jal	ra,80000d10 <myproc>
    80004442:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004444:	fd840593          	addi	a1,s0,-40
    80004448:	4501                	li	a0,0
    8000444a:	f8afd0ef          	jal	ra,80001bd4 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000444e:	fc840593          	addi	a1,s0,-56
    80004452:	fd040513          	addi	a0,s0,-48
    80004456:	8e2ff0ef          	jal	ra,80003538 <pipealloc>
    return -1;
    8000445a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000445c:	0a054463          	bltz	a0,80004504 <sys_pipe+0xd0>
  fd0 = -1;
    80004460:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004464:	fd043503          	ld	a0,-48(s0)
    80004468:	f40ff0ef          	jal	ra,80003ba8 <fdalloc>
    8000446c:	fca42223          	sw	a0,-60(s0)
    80004470:	08054163          	bltz	a0,800044f2 <sys_pipe+0xbe>
    80004474:	fc843503          	ld	a0,-56(s0)
    80004478:	f30ff0ef          	jal	ra,80003ba8 <fdalloc>
    8000447c:	fca42023          	sw	a0,-64(s0)
    80004480:	06054063          	bltz	a0,800044e0 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004484:	4691                	li	a3,4
    80004486:	fc440613          	addi	a2,s0,-60
    8000448a:	fd843583          	ld	a1,-40(s0)
    8000448e:	68a8                	ld	a0,80(s1)
    80004490:	d36fc0ef          	jal	ra,800009c6 <copyout>
    80004494:	00054e63          	bltz	a0,800044b0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004498:	4691                	li	a3,4
    8000449a:	fc040613          	addi	a2,s0,-64
    8000449e:	fd843583          	ld	a1,-40(s0)
    800044a2:	0591                	addi	a1,a1,4
    800044a4:	68a8                	ld	a0,80(s1)
    800044a6:	d20fc0ef          	jal	ra,800009c6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800044aa:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800044ac:	04055c63          	bgez	a0,80004504 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800044b0:	fc442783          	lw	a5,-60(s0)
    800044b4:	07e9                	addi	a5,a5,26
    800044b6:	078e                	slli	a5,a5,0x3
    800044b8:	97a6                	add	a5,a5,s1
    800044ba:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800044be:	fc042503          	lw	a0,-64(s0)
    800044c2:	0569                	addi	a0,a0,26
    800044c4:	050e                	slli	a0,a0,0x3
    800044c6:	94aa                	add	s1,s1,a0
    800044c8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800044cc:	fd043503          	ld	a0,-48(s0)
    800044d0:	d9dfe0ef          	jal	ra,8000326c <fileclose>
    fileclose(wf);
    800044d4:	fc843503          	ld	a0,-56(s0)
    800044d8:	d95fe0ef          	jal	ra,8000326c <fileclose>
    return -1;
    800044dc:	57fd                	li	a5,-1
    800044de:	a01d                	j	80004504 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800044e0:	fc442783          	lw	a5,-60(s0)
    800044e4:	0007c763          	bltz	a5,800044f2 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800044e8:	07e9                	addi	a5,a5,26
    800044ea:	078e                	slli	a5,a5,0x3
    800044ec:	94be                	add	s1,s1,a5
    800044ee:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800044f2:	fd043503          	ld	a0,-48(s0)
    800044f6:	d77fe0ef          	jal	ra,8000326c <fileclose>
    fileclose(wf);
    800044fa:	fc843503          	ld	a0,-56(s0)
    800044fe:	d6ffe0ef          	jal	ra,8000326c <fileclose>
    return -1;
    80004502:	57fd                	li	a5,-1
}
    80004504:	853e                	mv	a0,a5
    80004506:	70e2                	ld	ra,56(sp)
    80004508:	7442                	ld	s0,48(sp)
    8000450a:	74a2                	ld	s1,40(sp)
    8000450c:	6121                	addi	sp,sp,64
    8000450e:	8082                	ret

0000000080004510 <kernelvec>:
    80004510:	7111                	addi	sp,sp,-256
    80004512:	e006                	sd	ra,0(sp)
    80004514:	e40a                	sd	sp,8(sp)
    80004516:	e80e                	sd	gp,16(sp)
    80004518:	ec12                	sd	tp,24(sp)
    8000451a:	f016                	sd	t0,32(sp)
    8000451c:	f41a                	sd	t1,40(sp)
    8000451e:	f81e                	sd	t2,48(sp)
    80004520:	e4aa                	sd	a0,72(sp)
    80004522:	e8ae                	sd	a1,80(sp)
    80004524:	ecb2                	sd	a2,88(sp)
    80004526:	f0b6                	sd	a3,96(sp)
    80004528:	f4ba                	sd	a4,104(sp)
    8000452a:	f8be                	sd	a5,112(sp)
    8000452c:	fcc2                	sd	a6,120(sp)
    8000452e:	e146                	sd	a7,128(sp)
    80004530:	edf2                	sd	t3,216(sp)
    80004532:	f1f6                	sd	t4,224(sp)
    80004534:	f5fa                	sd	t5,232(sp)
    80004536:	f9fe                	sd	t6,240(sp)
    80004538:	d06fd0ef          	jal	ra,80001a3e <kerneltrap>
    8000453c:	6082                	ld	ra,0(sp)
    8000453e:	6122                	ld	sp,8(sp)
    80004540:	61c2                	ld	gp,16(sp)
    80004542:	7282                	ld	t0,32(sp)
    80004544:	7322                	ld	t1,40(sp)
    80004546:	73c2                	ld	t2,48(sp)
    80004548:	6526                	ld	a0,72(sp)
    8000454a:	65c6                	ld	a1,80(sp)
    8000454c:	6666                	ld	a2,88(sp)
    8000454e:	7686                	ld	a3,96(sp)
    80004550:	7726                	ld	a4,104(sp)
    80004552:	77c6                	ld	a5,112(sp)
    80004554:	7866                	ld	a6,120(sp)
    80004556:	688a                	ld	a7,128(sp)
    80004558:	6e6e                	ld	t3,216(sp)
    8000455a:	7e8e                	ld	t4,224(sp)
    8000455c:	7f2e                	ld	t5,232(sp)
    8000455e:	7fce                	ld	t6,240(sp)
    80004560:	6111                	addi	sp,sp,256
    80004562:	10200073          	sret
	...

000000008000456e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000456e:	1141                	addi	sp,sp,-16
    80004570:	e422                	sd	s0,8(sp)
    80004572:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004574:	0c0007b7          	lui	a5,0xc000
    80004578:	4705                	li	a4,1
    8000457a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000457c:	c3d8                	sw	a4,4(a5)
}
    8000457e:	6422                	ld	s0,8(sp)
    80004580:	0141                	addi	sp,sp,16
    80004582:	8082                	ret

0000000080004584 <plicinithart>:

void
plicinithart(void)
{
    80004584:	1141                	addi	sp,sp,-16
    80004586:	e406                	sd	ra,8(sp)
    80004588:	e022                	sd	s0,0(sp)
    8000458a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000458c:	f58fc0ef          	jal	ra,80000ce4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004590:	0085171b          	slliw	a4,a0,0x8
    80004594:	0c0027b7          	lui	a5,0xc002
    80004598:	97ba                	add	a5,a5,a4
    8000459a:	40200713          	li	a4,1026
    8000459e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800045a2:	00d5151b          	slliw	a0,a0,0xd
    800045a6:	0c2017b7          	lui	a5,0xc201
    800045aa:	953e                	add	a0,a0,a5
    800045ac:	00052023          	sw	zero,0(a0)
}
    800045b0:	60a2                	ld	ra,8(sp)
    800045b2:	6402                	ld	s0,0(sp)
    800045b4:	0141                	addi	sp,sp,16
    800045b6:	8082                	ret

00000000800045b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800045b8:	1141                	addi	sp,sp,-16
    800045ba:	e406                	sd	ra,8(sp)
    800045bc:	e022                	sd	s0,0(sp)
    800045be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800045c0:	f24fc0ef          	jal	ra,80000ce4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800045c4:	00d5179b          	slliw	a5,a0,0xd
    800045c8:	0c201537          	lui	a0,0xc201
    800045cc:	953e                	add	a0,a0,a5
  return irq;
}
    800045ce:	4148                	lw	a0,4(a0)
    800045d0:	60a2                	ld	ra,8(sp)
    800045d2:	6402                	ld	s0,0(sp)
    800045d4:	0141                	addi	sp,sp,16
    800045d6:	8082                	ret

00000000800045d8 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800045d8:	1101                	addi	sp,sp,-32
    800045da:	ec06                	sd	ra,24(sp)
    800045dc:	e822                	sd	s0,16(sp)
    800045de:	e426                	sd	s1,8(sp)
    800045e0:	1000                	addi	s0,sp,32
    800045e2:	84aa                	mv	s1,a0
  int hart = cpuid();
    800045e4:	f00fc0ef          	jal	ra,80000ce4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800045e8:	00d5151b          	slliw	a0,a0,0xd
    800045ec:	0c2017b7          	lui	a5,0xc201
    800045f0:	97aa                	add	a5,a5,a0
    800045f2:	c3c4                	sw	s1,4(a5)
}
    800045f4:	60e2                	ld	ra,24(sp)
    800045f6:	6442                	ld	s0,16(sp)
    800045f8:	64a2                	ld	s1,8(sp)
    800045fa:	6105                	addi	sp,sp,32
    800045fc:	8082                	ret

00000000800045fe <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800045fe:	1141                	addi	sp,sp,-16
    80004600:	e406                	sd	ra,8(sp)
    80004602:	e022                	sd	s0,0(sp)
    80004604:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004606:	479d                	li	a5,7
    80004608:	04a7ca63          	blt	a5,a0,8000465c <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    8000460c:	00014797          	auipc	a5,0x14
    80004610:	3e478793          	addi	a5,a5,996 # 800189f0 <disk>
    80004614:	97aa                	add	a5,a5,a0
    80004616:	0187c783          	lbu	a5,24(a5)
    8000461a:	e7b9                	bnez	a5,80004668 <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000461c:	00451613          	slli	a2,a0,0x4
    80004620:	00014797          	auipc	a5,0x14
    80004624:	3d078793          	addi	a5,a5,976 # 800189f0 <disk>
    80004628:	6394                	ld	a3,0(a5)
    8000462a:	96b2                	add	a3,a3,a2
    8000462c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80004630:	6398                	ld	a4,0(a5)
    80004632:	9732                	add	a4,a4,a2
    80004634:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004638:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    8000463c:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004640:	953e                	add	a0,a0,a5
    80004642:	4785                	li	a5,1
    80004644:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80004648:	00014517          	auipc	a0,0x14
    8000464c:	3c050513          	addi	a0,a0,960 # 80018a08 <disk+0x18>
    80004650:	cd5fc0ef          	jal	ra,80001324 <wakeup>
}
    80004654:	60a2                	ld	ra,8(sp)
    80004656:	6402                	ld	s0,0(sp)
    80004658:	0141                	addi	sp,sp,16
    8000465a:	8082                	ret
    panic("free_desc 1");
    8000465c:	00003517          	auipc	a0,0x3
    80004660:	0ac50513          	addi	a0,a0,172 # 80007708 <syscalls+0x2f0>
    80004664:	41f000ef          	jal	ra,80005282 <panic>
    panic("free_desc 2");
    80004668:	00003517          	auipc	a0,0x3
    8000466c:	0b050513          	addi	a0,a0,176 # 80007718 <syscalls+0x300>
    80004670:	413000ef          	jal	ra,80005282 <panic>

0000000080004674 <virtio_disk_init>:
{
    80004674:	1101                	addi	sp,sp,-32
    80004676:	ec06                	sd	ra,24(sp)
    80004678:	e822                	sd	s0,16(sp)
    8000467a:	e426                	sd	s1,8(sp)
    8000467c:	e04a                	sd	s2,0(sp)
    8000467e:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004680:	00003597          	auipc	a1,0x3
    80004684:	0a858593          	addi	a1,a1,168 # 80007728 <syscalls+0x310>
    80004688:	00014517          	auipc	a0,0x14
    8000468c:	49050513          	addi	a0,a0,1168 # 80018b18 <disk+0x128>
    80004690:	68f000ef          	jal	ra,8000551e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004694:	100017b7          	lui	a5,0x10001
    80004698:	4398                	lw	a4,0(a5)
    8000469a:	2701                	sext.w	a4,a4
    8000469c:	747277b7          	lui	a5,0x74727
    800046a0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800046a4:	14f71263          	bne	a4,a5,800047e8 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800046a8:	100017b7          	lui	a5,0x10001
    800046ac:	43dc                	lw	a5,4(a5)
    800046ae:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800046b0:	4709                	li	a4,2
    800046b2:	12e79b63          	bne	a5,a4,800047e8 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800046b6:	100017b7          	lui	a5,0x10001
    800046ba:	479c                	lw	a5,8(a5)
    800046bc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800046be:	12e79563          	bne	a5,a4,800047e8 <virtio_disk_init+0x174>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800046c2:	100017b7          	lui	a5,0x10001
    800046c6:	47d8                	lw	a4,12(a5)
    800046c8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800046ca:	554d47b7          	lui	a5,0x554d4
    800046ce:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800046d2:	10f71b63          	bne	a4,a5,800047e8 <virtio_disk_init+0x174>
  *R(VIRTIO_MMIO_STATUS) = status;
    800046d6:	100017b7          	lui	a5,0x10001
    800046da:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800046de:	4705                	li	a4,1
    800046e0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800046e2:	470d                	li	a4,3
    800046e4:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800046e6:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800046e8:	c7ffe737          	lui	a4,0xc7ffe
    800046ec:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fddb2f>
    800046f0:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800046f2:	2701                	sext.w	a4,a4
    800046f4:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800046f6:	472d                	li	a4,11
    800046f8:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800046fa:	0707a903          	lw	s2,112(a5)
    800046fe:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004700:	00897793          	andi	a5,s2,8
    80004704:	0e078863          	beqz	a5,800047f4 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004708:	100017b7          	lui	a5,0x10001
    8000470c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004710:	43fc                	lw	a5,68(a5)
    80004712:	2781                	sext.w	a5,a5
    80004714:	0e079663          	bnez	a5,80004800 <virtio_disk_init+0x18c>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004718:	100017b7          	lui	a5,0x10001
    8000471c:	5bdc                	lw	a5,52(a5)
    8000471e:	2781                	sext.w	a5,a5
  if(max == 0)
    80004720:	0e078663          	beqz	a5,8000480c <virtio_disk_init+0x198>
  if(max < NUM)
    80004724:	471d                	li	a4,7
    80004726:	0ef77963          	bgeu	a4,a5,80004818 <virtio_disk_init+0x1a4>
  disk.desc = kalloc();
    8000472a:	9d3fb0ef          	jal	ra,800000fc <kalloc>
    8000472e:	00014497          	auipc	s1,0x14
    80004732:	2c248493          	addi	s1,s1,706 # 800189f0 <disk>
    80004736:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004738:	9c5fb0ef          	jal	ra,800000fc <kalloc>
    8000473c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000473e:	9bffb0ef          	jal	ra,800000fc <kalloc>
    80004742:	87aa                	mv	a5,a0
    80004744:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004746:	6088                	ld	a0,0(s1)
    80004748:	cd71                	beqz	a0,80004824 <virtio_disk_init+0x1b0>
    8000474a:	00014717          	auipc	a4,0x14
    8000474e:	2ae73703          	ld	a4,686(a4) # 800189f8 <disk+0x8>
    80004752:	cb69                	beqz	a4,80004824 <virtio_disk_init+0x1b0>
    80004754:	cbe1                	beqz	a5,80004824 <virtio_disk_init+0x1b0>
  memset(disk.desc, 0, PGSIZE);
    80004756:	6605                	lui	a2,0x1
    80004758:	4581                	li	a1,0
    8000475a:	9f3fb0ef          	jal	ra,8000014c <memset>
  memset(disk.avail, 0, PGSIZE);
    8000475e:	00014497          	auipc	s1,0x14
    80004762:	29248493          	addi	s1,s1,658 # 800189f0 <disk>
    80004766:	6605                	lui	a2,0x1
    80004768:	4581                	li	a1,0
    8000476a:	6488                	ld	a0,8(s1)
    8000476c:	9e1fb0ef          	jal	ra,8000014c <memset>
  memset(disk.used, 0, PGSIZE);
    80004770:	6605                	lui	a2,0x1
    80004772:	4581                	li	a1,0
    80004774:	6888                	ld	a0,16(s1)
    80004776:	9d7fb0ef          	jal	ra,8000014c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000477a:	100017b7          	lui	a5,0x10001
    8000477e:	4721                	li	a4,8
    80004780:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004782:	4098                	lw	a4,0(s1)
    80004784:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004788:	40d8                	lw	a4,4(s1)
    8000478a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000478e:	6498                	ld	a4,8(s1)
    80004790:	0007069b          	sext.w	a3,a4
    80004794:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004798:	9701                	srai	a4,a4,0x20
    8000479a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000479e:	6898                	ld	a4,16(s1)
    800047a0:	0007069b          	sext.w	a3,a4
    800047a4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800047a8:	9701                	srai	a4,a4,0x20
    800047aa:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800047ae:	4685                	li	a3,1
    800047b0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800047b2:	4705                	li	a4,1
    800047b4:	00d48c23          	sb	a3,24(s1)
    800047b8:	00e48ca3          	sb	a4,25(s1)
    800047bc:	00e48d23          	sb	a4,26(s1)
    800047c0:	00e48da3          	sb	a4,27(s1)
    800047c4:	00e48e23          	sb	a4,28(s1)
    800047c8:	00e48ea3          	sb	a4,29(s1)
    800047cc:	00e48f23          	sb	a4,30(s1)
    800047d0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800047d4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800047d8:	0727a823          	sw	s2,112(a5)
}
    800047dc:	60e2                	ld	ra,24(sp)
    800047de:	6442                	ld	s0,16(sp)
    800047e0:	64a2                	ld	s1,8(sp)
    800047e2:	6902                	ld	s2,0(sp)
    800047e4:	6105                	addi	sp,sp,32
    800047e6:	8082                	ret
    panic("could not find virtio disk");
    800047e8:	00003517          	auipc	a0,0x3
    800047ec:	f5050513          	addi	a0,a0,-176 # 80007738 <syscalls+0x320>
    800047f0:	293000ef          	jal	ra,80005282 <panic>
    panic("virtio disk FEATURES_OK unset");
    800047f4:	00003517          	auipc	a0,0x3
    800047f8:	f6450513          	addi	a0,a0,-156 # 80007758 <syscalls+0x340>
    800047fc:	287000ef          	jal	ra,80005282 <panic>
    panic("virtio disk should not be ready");
    80004800:	00003517          	auipc	a0,0x3
    80004804:	f7850513          	addi	a0,a0,-136 # 80007778 <syscalls+0x360>
    80004808:	27b000ef          	jal	ra,80005282 <panic>
    panic("virtio disk has no queue 0");
    8000480c:	00003517          	auipc	a0,0x3
    80004810:	f8c50513          	addi	a0,a0,-116 # 80007798 <syscalls+0x380>
    80004814:	26f000ef          	jal	ra,80005282 <panic>
    panic("virtio disk max queue too short");
    80004818:	00003517          	auipc	a0,0x3
    8000481c:	fa050513          	addi	a0,a0,-96 # 800077b8 <syscalls+0x3a0>
    80004820:	263000ef          	jal	ra,80005282 <panic>
    panic("virtio disk kalloc");
    80004824:	00003517          	auipc	a0,0x3
    80004828:	fb450513          	addi	a0,a0,-76 # 800077d8 <syscalls+0x3c0>
    8000482c:	257000ef          	jal	ra,80005282 <panic>

0000000080004830 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004830:	7159                	addi	sp,sp,-112
    80004832:	f486                	sd	ra,104(sp)
    80004834:	f0a2                	sd	s0,96(sp)
    80004836:	eca6                	sd	s1,88(sp)
    80004838:	e8ca                	sd	s2,80(sp)
    8000483a:	e4ce                	sd	s3,72(sp)
    8000483c:	e0d2                	sd	s4,64(sp)
    8000483e:	fc56                	sd	s5,56(sp)
    80004840:	f85a                	sd	s6,48(sp)
    80004842:	f45e                	sd	s7,40(sp)
    80004844:	f062                	sd	s8,32(sp)
    80004846:	ec66                	sd	s9,24(sp)
    80004848:	e86a                	sd	s10,16(sp)
    8000484a:	1880                	addi	s0,sp,112
    8000484c:	892a                	mv	s2,a0
    8000484e:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004850:	00c52c83          	lw	s9,12(a0)
    80004854:	001c9c9b          	slliw	s9,s9,0x1
    80004858:	1c82                	slli	s9,s9,0x20
    8000485a:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000485e:	00014517          	auipc	a0,0x14
    80004862:	2ba50513          	addi	a0,a0,698 # 80018b18 <disk+0x128>
    80004866:	539000ef          	jal	ra,8000559e <acquire>
  for(int i = 0; i < 3; i++){
    8000486a:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000486c:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000486e:	00014b17          	auipc	s6,0x14
    80004872:	182b0b13          	addi	s6,s6,386 # 800189f0 <disk>
  for(int i = 0; i < 3; i++){
    80004876:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80004878:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000487a:	00014c17          	auipc	s8,0x14
    8000487e:	29ec0c13          	addi	s8,s8,670 # 80018b18 <disk+0x128>
    80004882:	a0b5                	j	800048ee <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80004884:	00fb06b3          	add	a3,s6,a5
    80004888:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    8000488c:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000488e:	0207c563          	bltz	a5,800048b8 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80004892:	2485                	addiw	s1,s1,1
    80004894:	0711                	addi	a4,a4,4
    80004896:	1d548c63          	beq	s1,s5,80004a6e <virtio_disk_rw+0x23e>
    idx[i] = alloc_desc();
    8000489a:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    8000489c:	00014697          	auipc	a3,0x14
    800048a0:	15468693          	addi	a3,a3,340 # 800189f0 <disk>
    800048a4:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800048a6:	0186c583          	lbu	a1,24(a3)
    800048aa:	fde9                	bnez	a1,80004884 <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    800048ac:	2785                	addiw	a5,a5,1
    800048ae:	0685                	addi	a3,a3,1
    800048b0:	ff779be3          	bne	a5,s7,800048a6 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800048b4:	57fd                	li	a5,-1
    800048b6:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800048b8:	02905463          	blez	s1,800048e0 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    800048bc:	f9042503          	lw	a0,-112(s0)
    800048c0:	d3fff0ef          	jal	ra,800045fe <free_desc>
      for(int j = 0; j < i; j++)
    800048c4:	4785                	li	a5,1
    800048c6:	0097dd63          	bge	a5,s1,800048e0 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    800048ca:	f9442503          	lw	a0,-108(s0)
    800048ce:	d31ff0ef          	jal	ra,800045fe <free_desc>
      for(int j = 0; j < i; j++)
    800048d2:	4789                	li	a5,2
    800048d4:	0097d663          	bge	a5,s1,800048e0 <virtio_disk_rw+0xb0>
        free_desc(idx[j]);
    800048d8:	f9842503          	lw	a0,-104(s0)
    800048dc:	d23ff0ef          	jal	ra,800045fe <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800048e0:	85e2                	mv	a1,s8
    800048e2:	00014517          	auipc	a0,0x14
    800048e6:	12650513          	addi	a0,a0,294 # 80018a08 <disk+0x18>
    800048ea:	9effc0ef          	jal	ra,800012d8 <sleep>
  for(int i = 0; i < 3; i++){
    800048ee:	f9040713          	addi	a4,s0,-112
    800048f2:	84ce                	mv	s1,s3
    800048f4:	b75d                	j	8000489a <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800048f6:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800048fa:	00479693          	slli	a3,a5,0x4
    800048fe:	00014797          	auipc	a5,0x14
    80004902:	0f278793          	addi	a5,a5,242 # 800189f0 <disk>
    80004906:	97b6                	add	a5,a5,a3
    80004908:	4685                	li	a3,1
    8000490a:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000490c:	00014597          	auipc	a1,0x14
    80004910:	0e458593          	addi	a1,a1,228 # 800189f0 <disk>
    80004914:	00a60793          	addi	a5,a2,10
    80004918:	0792                	slli	a5,a5,0x4
    8000491a:	97ae                	add	a5,a5,a1
    8000491c:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    80004920:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004924:	f6070693          	addi	a3,a4,-160
    80004928:	619c                	ld	a5,0(a1)
    8000492a:	97b6                	add	a5,a5,a3
    8000492c:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000492e:	6188                	ld	a0,0(a1)
    80004930:	96aa                	add	a3,a3,a0
    80004932:	47c1                	li	a5,16
    80004934:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004936:	4785                	li	a5,1
    80004938:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    8000493c:	f9442783          	lw	a5,-108(s0)
    80004940:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004944:	0792                	slli	a5,a5,0x4
    80004946:	953e                	add	a0,a0,a5
    80004948:	05890693          	addi	a3,s2,88
    8000494c:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000494e:	6188                	ld	a0,0(a1)
    80004950:	97aa                	add	a5,a5,a0
    80004952:	40000693          	li	a3,1024
    80004956:	c794                	sw	a3,8(a5)
  if(write)
    80004958:	100d0763          	beqz	s10,80004a66 <virtio_disk_rw+0x236>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000495c:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004960:	00c7d683          	lhu	a3,12(a5)
    80004964:	0016e693          	ori	a3,a3,1
    80004968:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    8000496c:	f9842583          	lw	a1,-104(s0)
    80004970:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004974:	00014697          	auipc	a3,0x14
    80004978:	07c68693          	addi	a3,a3,124 # 800189f0 <disk>
    8000497c:	00260793          	addi	a5,a2,2
    80004980:	0792                	slli	a5,a5,0x4
    80004982:	97b6                	add	a5,a5,a3
    80004984:	587d                	li	a6,-1
    80004986:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000498a:	0592                	slli	a1,a1,0x4
    8000498c:	952e                	add	a0,a0,a1
    8000498e:	f9070713          	addi	a4,a4,-112
    80004992:	9736                	add	a4,a4,a3
    80004994:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80004996:	6298                	ld	a4,0(a3)
    80004998:	972e                	add	a4,a4,a1
    8000499a:	4585                	li	a1,1
    8000499c:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000499e:	4509                	li	a0,2
    800049a0:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800049a4:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800049a8:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800049ac:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800049b0:	6698                	ld	a4,8(a3)
    800049b2:	00275783          	lhu	a5,2(a4)
    800049b6:	8b9d                	andi	a5,a5,7
    800049b8:	0786                	slli	a5,a5,0x1
    800049ba:	97ba                	add	a5,a5,a4
    800049bc:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800049c0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800049c4:	6698                	ld	a4,8(a3)
    800049c6:	00275783          	lhu	a5,2(a4)
    800049ca:	2785                	addiw	a5,a5,1
    800049cc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800049d0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800049d4:	100017b7          	lui	a5,0x10001
    800049d8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800049dc:	00492703          	lw	a4,4(s2)
    800049e0:	4785                	li	a5,1
    800049e2:	00f71f63          	bne	a4,a5,80004a00 <virtio_disk_rw+0x1d0>
    sleep(b, &disk.vdisk_lock);
    800049e6:	00014997          	auipc	s3,0x14
    800049ea:	13298993          	addi	s3,s3,306 # 80018b18 <disk+0x128>
  while(b->disk == 1) {
    800049ee:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800049f0:	85ce                	mv	a1,s3
    800049f2:	854a                	mv	a0,s2
    800049f4:	8e5fc0ef          	jal	ra,800012d8 <sleep>
  while(b->disk == 1) {
    800049f8:	00492783          	lw	a5,4(s2)
    800049fc:	fe978ae3          	beq	a5,s1,800049f0 <virtio_disk_rw+0x1c0>
  }

  disk.info[idx[0]].b = 0;
    80004a00:	f9042903          	lw	s2,-112(s0)
    80004a04:	00290793          	addi	a5,s2,2
    80004a08:	00479713          	slli	a4,a5,0x4
    80004a0c:	00014797          	auipc	a5,0x14
    80004a10:	fe478793          	addi	a5,a5,-28 # 800189f0 <disk>
    80004a14:	97ba                	add	a5,a5,a4
    80004a16:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004a1a:	00014997          	auipc	s3,0x14
    80004a1e:	fd698993          	addi	s3,s3,-42 # 800189f0 <disk>
    80004a22:	00491713          	slli	a4,s2,0x4
    80004a26:	0009b783          	ld	a5,0(s3)
    80004a2a:	97ba                	add	a5,a5,a4
    80004a2c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004a30:	854a                	mv	a0,s2
    80004a32:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004a36:	bc9ff0ef          	jal	ra,800045fe <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004a3a:	8885                	andi	s1,s1,1
    80004a3c:	f0fd                	bnez	s1,80004a22 <virtio_disk_rw+0x1f2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004a3e:	00014517          	auipc	a0,0x14
    80004a42:	0da50513          	addi	a0,a0,218 # 80018b18 <disk+0x128>
    80004a46:	3f1000ef          	jal	ra,80005636 <release>
}
    80004a4a:	70a6                	ld	ra,104(sp)
    80004a4c:	7406                	ld	s0,96(sp)
    80004a4e:	64e6                	ld	s1,88(sp)
    80004a50:	6946                	ld	s2,80(sp)
    80004a52:	69a6                	ld	s3,72(sp)
    80004a54:	6a06                	ld	s4,64(sp)
    80004a56:	7ae2                	ld	s5,56(sp)
    80004a58:	7b42                	ld	s6,48(sp)
    80004a5a:	7ba2                	ld	s7,40(sp)
    80004a5c:	7c02                	ld	s8,32(sp)
    80004a5e:	6ce2                	ld	s9,24(sp)
    80004a60:	6d42                	ld	s10,16(sp)
    80004a62:	6165                	addi	sp,sp,112
    80004a64:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80004a66:	4689                	li	a3,2
    80004a68:	00d79623          	sh	a3,12(a5)
    80004a6c:	bdd5                	j	80004960 <virtio_disk_rw+0x130>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004a6e:	f9042603          	lw	a2,-112(s0)
    80004a72:	00a60713          	addi	a4,a2,10
    80004a76:	0712                	slli	a4,a4,0x4
    80004a78:	00014517          	auipc	a0,0x14
    80004a7c:	f8050513          	addi	a0,a0,-128 # 800189f8 <disk+0x8>
    80004a80:	953a                	add	a0,a0,a4
  if(write)
    80004a82:	e60d1ae3          	bnez	s10,800048f6 <virtio_disk_rw+0xc6>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80004a86:	00a60793          	addi	a5,a2,10
    80004a8a:	00479693          	slli	a3,a5,0x4
    80004a8e:	00014797          	auipc	a5,0x14
    80004a92:	f6278793          	addi	a5,a5,-158 # 800189f0 <disk>
    80004a96:	97b6                	add	a5,a5,a3
    80004a98:	0007a423          	sw	zero,8(a5)
    80004a9c:	bd85                	j	8000490c <virtio_disk_rw+0xdc>

0000000080004a9e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004a9e:	1101                	addi	sp,sp,-32
    80004aa0:	ec06                	sd	ra,24(sp)
    80004aa2:	e822                	sd	s0,16(sp)
    80004aa4:	e426                	sd	s1,8(sp)
    80004aa6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004aa8:	00014497          	auipc	s1,0x14
    80004aac:	f4848493          	addi	s1,s1,-184 # 800189f0 <disk>
    80004ab0:	00014517          	auipc	a0,0x14
    80004ab4:	06850513          	addi	a0,a0,104 # 80018b18 <disk+0x128>
    80004ab8:	2e7000ef          	jal	ra,8000559e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004abc:	10001737          	lui	a4,0x10001
    80004ac0:	533c                	lw	a5,96(a4)
    80004ac2:	8b8d                	andi	a5,a5,3
    80004ac4:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004ac6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004aca:	689c                	ld	a5,16(s1)
    80004acc:	0204d703          	lhu	a4,32(s1)
    80004ad0:	0027d783          	lhu	a5,2(a5)
    80004ad4:	04f70663          	beq	a4,a5,80004b20 <virtio_disk_intr+0x82>
    __sync_synchronize();
    80004ad8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004adc:	6898                	ld	a4,16(s1)
    80004ade:	0204d783          	lhu	a5,32(s1)
    80004ae2:	8b9d                	andi	a5,a5,7
    80004ae4:	078e                	slli	a5,a5,0x3
    80004ae6:	97ba                	add	a5,a5,a4
    80004ae8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004aea:	00278713          	addi	a4,a5,2
    80004aee:	0712                	slli	a4,a4,0x4
    80004af0:	9726                	add	a4,a4,s1
    80004af2:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004af6:	e321                	bnez	a4,80004b36 <virtio_disk_intr+0x98>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004af8:	0789                	addi	a5,a5,2
    80004afa:	0792                	slli	a5,a5,0x4
    80004afc:	97a6                	add	a5,a5,s1
    80004afe:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004b00:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004b04:	821fc0ef          	jal	ra,80001324 <wakeup>

    disk.used_idx += 1;
    80004b08:	0204d783          	lhu	a5,32(s1)
    80004b0c:	2785                	addiw	a5,a5,1
    80004b0e:	17c2                	slli	a5,a5,0x30
    80004b10:	93c1                	srli	a5,a5,0x30
    80004b12:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004b16:	6898                	ld	a4,16(s1)
    80004b18:	00275703          	lhu	a4,2(a4)
    80004b1c:	faf71ee3          	bne	a4,a5,80004ad8 <virtio_disk_intr+0x3a>
  }

  release(&disk.vdisk_lock);
    80004b20:	00014517          	auipc	a0,0x14
    80004b24:	ff850513          	addi	a0,a0,-8 # 80018b18 <disk+0x128>
    80004b28:	30f000ef          	jal	ra,80005636 <release>
}
    80004b2c:	60e2                	ld	ra,24(sp)
    80004b2e:	6442                	ld	s0,16(sp)
    80004b30:	64a2                	ld	s1,8(sp)
    80004b32:	6105                	addi	sp,sp,32
    80004b34:	8082                	ret
      panic("virtio_disk_intr status");
    80004b36:	00003517          	auipc	a0,0x3
    80004b3a:	cba50513          	addi	a0,a0,-838 # 800077f0 <syscalls+0x3d8>
    80004b3e:	744000ef          	jal	ra,80005282 <panic>

0000000080004b42 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004b42:	1141                	addi	sp,sp,-16
    80004b44:	e422                	sd	s0,8(sp)
    80004b46:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004b48:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004b4c:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004b50:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004b54:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004b58:	577d                	li	a4,-1
    80004b5a:	177e                	slli	a4,a4,0x3f
    80004b5c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004b5e:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004b62:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004b66:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004b6a:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004b6e:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004b72:	000f4737          	lui	a4,0xf4
    80004b76:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004b7a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004b7c:	14d79073          	csrw	0x14d,a5
}
    80004b80:	6422                	ld	s0,8(sp)
    80004b82:	0141                	addi	sp,sp,16
    80004b84:	8082                	ret

0000000080004b86 <start>:
{
    80004b86:	1141                	addi	sp,sp,-16
    80004b88:	e406                	sd	ra,8(sp)
    80004b8a:	e022                	sd	s0,0(sp)
    80004b8c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004b8e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004b92:	7779                	lui	a4,0xffffe
    80004b94:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddbcf>
    80004b98:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004b9a:	6705                	lui	a4,0x1
    80004b9c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004ba0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004ba2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004ba6:	ffffb797          	auipc	a5,0xffffb
    80004baa:	75078793          	addi	a5,a5,1872 # 800002f6 <main>
    80004bae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004bb2:	4781                	li	a5,0
    80004bb4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004bb8:	67c1                	lui	a5,0x10
    80004bba:	17fd                	addi	a5,a5,-1
    80004bbc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004bc0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004bc4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004bc8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004bcc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004bd0:	57fd                	li	a5,-1
    80004bd2:	83a9                	srli	a5,a5,0xa
    80004bd4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004bd8:	47bd                	li	a5,15
    80004bda:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004bde:	f65ff0ef          	jal	ra,80004b42 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004be2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004be6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004be8:	823e                	mv	tp,a5
  asm volatile("mret");
    80004bea:	30200073          	mret
}
    80004bee:	60a2                	ld	ra,8(sp)
    80004bf0:	6402                	ld	s0,0(sp)
    80004bf2:	0141                	addi	sp,sp,16
    80004bf4:	8082                	ret

0000000080004bf6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004bf6:	715d                	addi	sp,sp,-80
    80004bf8:	e486                	sd	ra,72(sp)
    80004bfa:	e0a2                	sd	s0,64(sp)
    80004bfc:	fc26                	sd	s1,56(sp)
    80004bfe:	f84a                	sd	s2,48(sp)
    80004c00:	f44e                	sd	s3,40(sp)
    80004c02:	f052                	sd	s4,32(sp)
    80004c04:	ec56                	sd	s5,24(sp)
    80004c06:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004c08:	04c05263          	blez	a2,80004c4c <consolewrite+0x56>
    80004c0c:	8a2a                	mv	s4,a0
    80004c0e:	84ae                	mv	s1,a1
    80004c10:	89b2                	mv	s3,a2
    80004c12:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004c14:	5afd                	li	s5,-1
    80004c16:	4685                	li	a3,1
    80004c18:	8626                	mv	a2,s1
    80004c1a:	85d2                	mv	a1,s4
    80004c1c:	fbf40513          	addi	a0,s0,-65
    80004c20:	a5ffc0ef          	jal	ra,8000167e <either_copyin>
    80004c24:	01550a63          	beq	a0,s5,80004c38 <consolewrite+0x42>
      break;
    uartputc(c);
    80004c28:	fbf44503          	lbu	a0,-65(s0)
    80004c2c:	7e8000ef          	jal	ra,80005414 <uartputc>
  for(i = 0; i < n; i++){
    80004c30:	2905                	addiw	s2,s2,1
    80004c32:	0485                	addi	s1,s1,1
    80004c34:	ff2991e3          	bne	s3,s2,80004c16 <consolewrite+0x20>
  }

  return i;
}
    80004c38:	854a                	mv	a0,s2
    80004c3a:	60a6                	ld	ra,72(sp)
    80004c3c:	6406                	ld	s0,64(sp)
    80004c3e:	74e2                	ld	s1,56(sp)
    80004c40:	7942                	ld	s2,48(sp)
    80004c42:	79a2                	ld	s3,40(sp)
    80004c44:	7a02                	ld	s4,32(sp)
    80004c46:	6ae2                	ld	s5,24(sp)
    80004c48:	6161                	addi	sp,sp,80
    80004c4a:	8082                	ret
  for(i = 0; i < n; i++){
    80004c4c:	4901                	li	s2,0
    80004c4e:	b7ed                	j	80004c38 <consolewrite+0x42>

0000000080004c50 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004c50:	7119                	addi	sp,sp,-128
    80004c52:	fc86                	sd	ra,120(sp)
    80004c54:	f8a2                	sd	s0,112(sp)
    80004c56:	f4a6                	sd	s1,104(sp)
    80004c58:	f0ca                	sd	s2,96(sp)
    80004c5a:	ecce                	sd	s3,88(sp)
    80004c5c:	e8d2                	sd	s4,80(sp)
    80004c5e:	e4d6                	sd	s5,72(sp)
    80004c60:	e0da                	sd	s6,64(sp)
    80004c62:	fc5e                	sd	s7,56(sp)
    80004c64:	f862                	sd	s8,48(sp)
    80004c66:	f466                	sd	s9,40(sp)
    80004c68:	f06a                	sd	s10,32(sp)
    80004c6a:	ec6e                	sd	s11,24(sp)
    80004c6c:	0100                	addi	s0,sp,128
    80004c6e:	8b2a                	mv	s6,a0
    80004c70:	8aae                	mv	s5,a1
    80004c72:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004c74:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80004c78:	0001c517          	auipc	a0,0x1c
    80004c7c:	eb850513          	addi	a0,a0,-328 # 80020b30 <cons>
    80004c80:	11f000ef          	jal	ra,8000559e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004c84:	0001c497          	auipc	s1,0x1c
    80004c88:	eac48493          	addi	s1,s1,-340 # 80020b30 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004c8c:	89a6                	mv	s3,s1
    80004c8e:	0001c917          	auipc	s2,0x1c
    80004c92:	f3a90913          	addi	s2,s2,-198 # 80020bc8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80004c96:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004c98:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80004c9a:	4da9                	li	s11,10
  while(n > 0){
    80004c9c:	07405363          	blez	s4,80004d02 <consoleread+0xb2>
    while(cons.r == cons.w){
    80004ca0:	0984a783          	lw	a5,152(s1)
    80004ca4:	09c4a703          	lw	a4,156(s1)
    80004ca8:	02f71163          	bne	a4,a5,80004cca <consoleread+0x7a>
      if(killed(myproc())){
    80004cac:	864fc0ef          	jal	ra,80000d10 <myproc>
    80004cb0:	861fc0ef          	jal	ra,80001510 <killed>
    80004cb4:	e125                	bnez	a0,80004d14 <consoleread+0xc4>
      sleep(&cons.r, &cons.lock);
    80004cb6:	85ce                	mv	a1,s3
    80004cb8:	854a                	mv	a0,s2
    80004cba:	e1efc0ef          	jal	ra,800012d8 <sleep>
    while(cons.r == cons.w){
    80004cbe:	0984a783          	lw	a5,152(s1)
    80004cc2:	09c4a703          	lw	a4,156(s1)
    80004cc6:	fef703e3          	beq	a4,a5,80004cac <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004cca:	0017871b          	addiw	a4,a5,1
    80004cce:	08e4ac23          	sw	a4,152(s1)
    80004cd2:	07f7f713          	andi	a4,a5,127
    80004cd6:	9726                	add	a4,a4,s1
    80004cd8:	01874703          	lbu	a4,24(a4)
    80004cdc:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80004ce0:	079c0063          	beq	s8,s9,80004d40 <consoleread+0xf0>
    cbuf = c;
    80004ce4:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004ce8:	4685                	li	a3,1
    80004cea:	f8f40613          	addi	a2,s0,-113
    80004cee:	85d6                	mv	a1,s5
    80004cf0:	855a                	mv	a0,s6
    80004cf2:	943fc0ef          	jal	ra,80001634 <either_copyout>
    80004cf6:	01a50663          	beq	a0,s10,80004d02 <consoleread+0xb2>
    dst++;
    80004cfa:	0a85                	addi	s5,s5,1
    --n;
    80004cfc:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80004cfe:	f9bc1fe3          	bne	s8,s11,80004c9c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80004d02:	0001c517          	auipc	a0,0x1c
    80004d06:	e2e50513          	addi	a0,a0,-466 # 80020b30 <cons>
    80004d0a:	12d000ef          	jal	ra,80005636 <release>

  return target - n;
    80004d0e:	414b853b          	subw	a0,s7,s4
    80004d12:	a801                	j	80004d22 <consoleread+0xd2>
        release(&cons.lock);
    80004d14:	0001c517          	auipc	a0,0x1c
    80004d18:	e1c50513          	addi	a0,a0,-484 # 80020b30 <cons>
    80004d1c:	11b000ef          	jal	ra,80005636 <release>
        return -1;
    80004d20:	557d                	li	a0,-1
}
    80004d22:	70e6                	ld	ra,120(sp)
    80004d24:	7446                	ld	s0,112(sp)
    80004d26:	74a6                	ld	s1,104(sp)
    80004d28:	7906                	ld	s2,96(sp)
    80004d2a:	69e6                	ld	s3,88(sp)
    80004d2c:	6a46                	ld	s4,80(sp)
    80004d2e:	6aa6                	ld	s5,72(sp)
    80004d30:	6b06                	ld	s6,64(sp)
    80004d32:	7be2                	ld	s7,56(sp)
    80004d34:	7c42                	ld	s8,48(sp)
    80004d36:	7ca2                	ld	s9,40(sp)
    80004d38:	7d02                	ld	s10,32(sp)
    80004d3a:	6de2                	ld	s11,24(sp)
    80004d3c:	6109                	addi	sp,sp,128
    80004d3e:	8082                	ret
      if(n < target){
    80004d40:	000a071b          	sext.w	a4,s4
    80004d44:	fb777fe3          	bgeu	a4,s7,80004d02 <consoleread+0xb2>
        cons.r--;
    80004d48:	0001c717          	auipc	a4,0x1c
    80004d4c:	e8f72023          	sw	a5,-384(a4) # 80020bc8 <cons+0x98>
    80004d50:	bf4d                	j	80004d02 <consoleread+0xb2>

0000000080004d52 <consputc>:
{
    80004d52:	1141                	addi	sp,sp,-16
    80004d54:	e406                	sd	ra,8(sp)
    80004d56:	e022                	sd	s0,0(sp)
    80004d58:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80004d5a:	10000793          	li	a5,256
    80004d5e:	00f50863          	beq	a0,a5,80004d6e <consputc+0x1c>
    uartputc_sync(c);
    80004d62:	5d4000ef          	jal	ra,80005336 <uartputc_sync>
}
    80004d66:	60a2                	ld	ra,8(sp)
    80004d68:	6402                	ld	s0,0(sp)
    80004d6a:	0141                	addi	sp,sp,16
    80004d6c:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80004d6e:	4521                	li	a0,8
    80004d70:	5c6000ef          	jal	ra,80005336 <uartputc_sync>
    80004d74:	02000513          	li	a0,32
    80004d78:	5be000ef          	jal	ra,80005336 <uartputc_sync>
    80004d7c:	4521                	li	a0,8
    80004d7e:	5b8000ef          	jal	ra,80005336 <uartputc_sync>
    80004d82:	b7d5                	j	80004d66 <consputc+0x14>

0000000080004d84 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80004d84:	1101                	addi	sp,sp,-32
    80004d86:	ec06                	sd	ra,24(sp)
    80004d88:	e822                	sd	s0,16(sp)
    80004d8a:	e426                	sd	s1,8(sp)
    80004d8c:	e04a                	sd	s2,0(sp)
    80004d8e:	1000                	addi	s0,sp,32
    80004d90:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80004d92:	0001c517          	auipc	a0,0x1c
    80004d96:	d9e50513          	addi	a0,a0,-610 # 80020b30 <cons>
    80004d9a:	005000ef          	jal	ra,8000559e <acquire>

  switch(c){
    80004d9e:	47d5                	li	a5,21
    80004da0:	0af48063          	beq	s1,a5,80004e40 <consoleintr+0xbc>
    80004da4:	0297c663          	blt	a5,s1,80004dd0 <consoleintr+0x4c>
    80004da8:	47a1                	li	a5,8
    80004daa:	0cf48f63          	beq	s1,a5,80004e88 <consoleintr+0x104>
    80004dae:	47c1                	li	a5,16
    80004db0:	10f49063          	bne	s1,a5,80004eb0 <consoleintr+0x12c>
  case C('P'):  // Print process list.
    procdump();
    80004db4:	915fc0ef          	jal	ra,800016c8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80004db8:	0001c517          	auipc	a0,0x1c
    80004dbc:	d7850513          	addi	a0,a0,-648 # 80020b30 <cons>
    80004dc0:	077000ef          	jal	ra,80005636 <release>
}
    80004dc4:	60e2                	ld	ra,24(sp)
    80004dc6:	6442                	ld	s0,16(sp)
    80004dc8:	64a2                	ld	s1,8(sp)
    80004dca:	6902                	ld	s2,0(sp)
    80004dcc:	6105                	addi	sp,sp,32
    80004dce:	8082                	ret
  switch(c){
    80004dd0:	07f00793          	li	a5,127
    80004dd4:	0af48a63          	beq	s1,a5,80004e88 <consoleintr+0x104>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004dd8:	0001c717          	auipc	a4,0x1c
    80004ddc:	d5870713          	addi	a4,a4,-680 # 80020b30 <cons>
    80004de0:	0a072783          	lw	a5,160(a4)
    80004de4:	09872703          	lw	a4,152(a4)
    80004de8:	9f99                	subw	a5,a5,a4
    80004dea:	07f00713          	li	a4,127
    80004dee:	fcf765e3          	bltu	a4,a5,80004db8 <consoleintr+0x34>
      c = (c == '\r') ? '\n' : c;
    80004df2:	47b5                	li	a5,13
    80004df4:	0cf48163          	beq	s1,a5,80004eb6 <consoleintr+0x132>
      consputc(c);
    80004df8:	8526                	mv	a0,s1
    80004dfa:	f59ff0ef          	jal	ra,80004d52 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004dfe:	0001c797          	auipc	a5,0x1c
    80004e02:	d3278793          	addi	a5,a5,-718 # 80020b30 <cons>
    80004e06:	0a07a683          	lw	a3,160(a5)
    80004e0a:	0016871b          	addiw	a4,a3,1
    80004e0e:	0007061b          	sext.w	a2,a4
    80004e12:	0ae7a023          	sw	a4,160(a5)
    80004e16:	07f6f693          	andi	a3,a3,127
    80004e1a:	97b6                	add	a5,a5,a3
    80004e1c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80004e20:	47a9                	li	a5,10
    80004e22:	0af48f63          	beq	s1,a5,80004ee0 <consoleintr+0x15c>
    80004e26:	4791                	li	a5,4
    80004e28:	0af48c63          	beq	s1,a5,80004ee0 <consoleintr+0x15c>
    80004e2c:	0001c797          	auipc	a5,0x1c
    80004e30:	d9c7a783          	lw	a5,-612(a5) # 80020bc8 <cons+0x98>
    80004e34:	9f1d                	subw	a4,a4,a5
    80004e36:	08000793          	li	a5,128
    80004e3a:	f6f71fe3          	bne	a4,a5,80004db8 <consoleintr+0x34>
    80004e3e:	a04d                	j	80004ee0 <consoleintr+0x15c>
    while(cons.e != cons.w &&
    80004e40:	0001c717          	auipc	a4,0x1c
    80004e44:	cf070713          	addi	a4,a4,-784 # 80020b30 <cons>
    80004e48:	0a072783          	lw	a5,160(a4)
    80004e4c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004e50:	0001c497          	auipc	s1,0x1c
    80004e54:	ce048493          	addi	s1,s1,-800 # 80020b30 <cons>
    while(cons.e != cons.w &&
    80004e58:	4929                	li	s2,10
    80004e5a:	f4f70fe3          	beq	a4,a5,80004db8 <consoleintr+0x34>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80004e5e:	37fd                	addiw	a5,a5,-1
    80004e60:	07f7f713          	andi	a4,a5,127
    80004e64:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80004e66:	01874703          	lbu	a4,24(a4)
    80004e6a:	f52707e3          	beq	a4,s2,80004db8 <consoleintr+0x34>
      cons.e--;
    80004e6e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80004e72:	10000513          	li	a0,256
    80004e76:	eddff0ef          	jal	ra,80004d52 <consputc>
    while(cons.e != cons.w &&
    80004e7a:	0a04a783          	lw	a5,160(s1)
    80004e7e:	09c4a703          	lw	a4,156(s1)
    80004e82:	fcf71ee3          	bne	a4,a5,80004e5e <consoleintr+0xda>
    80004e86:	bf0d                	j	80004db8 <consoleintr+0x34>
    if(cons.e != cons.w){
    80004e88:	0001c717          	auipc	a4,0x1c
    80004e8c:	ca870713          	addi	a4,a4,-856 # 80020b30 <cons>
    80004e90:	0a072783          	lw	a5,160(a4)
    80004e94:	09c72703          	lw	a4,156(a4)
    80004e98:	f2f700e3          	beq	a4,a5,80004db8 <consoleintr+0x34>
      cons.e--;
    80004e9c:	37fd                	addiw	a5,a5,-1
    80004e9e:	0001c717          	auipc	a4,0x1c
    80004ea2:	d2f72923          	sw	a5,-718(a4) # 80020bd0 <cons+0xa0>
      consputc(BACKSPACE);
    80004ea6:	10000513          	li	a0,256
    80004eaa:	ea9ff0ef          	jal	ra,80004d52 <consputc>
    80004eae:	b729                	j	80004db8 <consoleintr+0x34>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80004eb0:	f00484e3          	beqz	s1,80004db8 <consoleintr+0x34>
    80004eb4:	b715                	j	80004dd8 <consoleintr+0x54>
      consputc(c);
    80004eb6:	4529                	li	a0,10
    80004eb8:	e9bff0ef          	jal	ra,80004d52 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80004ebc:	0001c797          	auipc	a5,0x1c
    80004ec0:	c7478793          	addi	a5,a5,-908 # 80020b30 <cons>
    80004ec4:	0a07a703          	lw	a4,160(a5)
    80004ec8:	0017069b          	addiw	a3,a4,1
    80004ecc:	0006861b          	sext.w	a2,a3
    80004ed0:	0ad7a023          	sw	a3,160(a5)
    80004ed4:	07f77713          	andi	a4,a4,127
    80004ed8:	97ba                	add	a5,a5,a4
    80004eda:	4729                	li	a4,10
    80004edc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80004ee0:	0001c797          	auipc	a5,0x1c
    80004ee4:	cec7a623          	sw	a2,-788(a5) # 80020bcc <cons+0x9c>
        wakeup(&cons.r);
    80004ee8:	0001c517          	auipc	a0,0x1c
    80004eec:	ce050513          	addi	a0,a0,-800 # 80020bc8 <cons+0x98>
    80004ef0:	c34fc0ef          	jal	ra,80001324 <wakeup>
    80004ef4:	b5d1                	j	80004db8 <consoleintr+0x34>

0000000080004ef6 <consoleinit>:

void
consoleinit(void)
{
    80004ef6:	1141                	addi	sp,sp,-16
    80004ef8:	e406                	sd	ra,8(sp)
    80004efa:	e022                	sd	s0,0(sp)
    80004efc:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80004efe:	00003597          	auipc	a1,0x3
    80004f02:	90a58593          	addi	a1,a1,-1782 # 80007808 <syscalls+0x3f0>
    80004f06:	0001c517          	auipc	a0,0x1c
    80004f0a:	c2a50513          	addi	a0,a0,-982 # 80020b30 <cons>
    80004f0e:	610000ef          	jal	ra,8000551e <initlock>

  uartinit();
    80004f12:	3d8000ef          	jal	ra,800052ea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80004f16:	00013797          	auipc	a5,0x13
    80004f1a:	a8278793          	addi	a5,a5,-1406 # 80017998 <devsw>
    80004f1e:	00000717          	auipc	a4,0x0
    80004f22:	d3270713          	addi	a4,a4,-718 # 80004c50 <consoleread>
    80004f26:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80004f28:	00000717          	auipc	a4,0x0
    80004f2c:	cce70713          	addi	a4,a4,-818 # 80004bf6 <consolewrite>
    80004f30:	ef98                	sd	a4,24(a5)
}
    80004f32:	60a2                	ld	ra,8(sp)
    80004f34:	6402                	ld	s0,0(sp)
    80004f36:	0141                	addi	sp,sp,16
    80004f38:	8082                	ret

0000000080004f3a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80004f3a:	7179                	addi	sp,sp,-48
    80004f3c:	f406                	sd	ra,40(sp)
    80004f3e:	f022                	sd	s0,32(sp)
    80004f40:	ec26                	sd	s1,24(sp)
    80004f42:	e84a                	sd	s2,16(sp)
    80004f44:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80004f46:	c219                	beqz	a2,80004f4c <printint+0x12>
    80004f48:	06054f63          	bltz	a0,80004fc6 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    80004f4c:	4881                	li	a7,0
    80004f4e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80004f52:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80004f54:	00003617          	auipc	a2,0x3
    80004f58:	8dc60613          	addi	a2,a2,-1828 # 80007830 <digits>
    80004f5c:	883e                	mv	a6,a5
    80004f5e:	2785                	addiw	a5,a5,1
    80004f60:	02b57733          	remu	a4,a0,a1
    80004f64:	9732                	add	a4,a4,a2
    80004f66:	00074703          	lbu	a4,0(a4)
    80004f6a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80004f6e:	872a                	mv	a4,a0
    80004f70:	02b55533          	divu	a0,a0,a1
    80004f74:	0685                	addi	a3,a3,1
    80004f76:	feb773e3          	bgeu	a4,a1,80004f5c <printint+0x22>

  if(sign)
    80004f7a:	00088b63          	beqz	a7,80004f90 <printint+0x56>
    buf[i++] = '-';
    80004f7e:	fe040713          	addi	a4,s0,-32
    80004f82:	97ba                	add	a5,a5,a4
    80004f84:	02d00713          	li	a4,45
    80004f88:	fee78823          	sb	a4,-16(a5)
    80004f8c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80004f90:	02f05563          	blez	a5,80004fba <printint+0x80>
    80004f94:	fd040713          	addi	a4,s0,-48
    80004f98:	00f704b3          	add	s1,a4,a5
    80004f9c:	fff70913          	addi	s2,a4,-1
    80004fa0:	993e                	add	s2,s2,a5
    80004fa2:	37fd                	addiw	a5,a5,-1
    80004fa4:	1782                	slli	a5,a5,0x20
    80004fa6:	9381                	srli	a5,a5,0x20
    80004fa8:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80004fac:	fff4c503          	lbu	a0,-1(s1)
    80004fb0:	da3ff0ef          	jal	ra,80004d52 <consputc>
  while(--i >= 0)
    80004fb4:	14fd                	addi	s1,s1,-1
    80004fb6:	ff249be3          	bne	s1,s2,80004fac <printint+0x72>
}
    80004fba:	70a2                	ld	ra,40(sp)
    80004fbc:	7402                	ld	s0,32(sp)
    80004fbe:	64e2                	ld	s1,24(sp)
    80004fc0:	6942                	ld	s2,16(sp)
    80004fc2:	6145                	addi	sp,sp,48
    80004fc4:	8082                	ret
    x = -xx;
    80004fc6:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80004fca:	4885                	li	a7,1
    x = -xx;
    80004fcc:	b749                	j	80004f4e <printint+0x14>

0000000080004fce <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80004fce:	7155                	addi	sp,sp,-208
    80004fd0:	e506                	sd	ra,136(sp)
    80004fd2:	e122                	sd	s0,128(sp)
    80004fd4:	fca6                	sd	s1,120(sp)
    80004fd6:	f8ca                	sd	s2,112(sp)
    80004fd8:	f4ce                	sd	s3,104(sp)
    80004fda:	f0d2                	sd	s4,96(sp)
    80004fdc:	ecd6                	sd	s5,88(sp)
    80004fde:	e8da                	sd	s6,80(sp)
    80004fe0:	e4de                	sd	s7,72(sp)
    80004fe2:	e0e2                	sd	s8,64(sp)
    80004fe4:	fc66                	sd	s9,56(sp)
    80004fe6:	f86a                	sd	s10,48(sp)
    80004fe8:	f46e                	sd	s11,40(sp)
    80004fea:	0900                	addi	s0,sp,144
    80004fec:	8a2a                	mv	s4,a0
    80004fee:	e40c                	sd	a1,8(s0)
    80004ff0:	e810                	sd	a2,16(s0)
    80004ff2:	ec14                	sd	a3,24(s0)
    80004ff4:	f018                	sd	a4,32(s0)
    80004ff6:	f41c                	sd	a5,40(s0)
    80004ff8:	03043823          	sd	a6,48(s0)
    80004ffc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80005000:	0001c797          	auipc	a5,0x1c
    80005004:	bf07a783          	lw	a5,-1040(a5) # 80020bf0 <pr+0x18>
    80005008:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000500c:	eb9d                	bnez	a5,80005042 <printf+0x74>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000500e:	00840793          	addi	a5,s0,8
    80005012:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005016:	00054503          	lbu	a0,0(a0)
    8000501a:	24050463          	beqz	a0,80005262 <printf+0x294>
    8000501e:	4981                	li	s3,0
    if(cx != '%'){
    80005020:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005024:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005028:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000502c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005030:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005034:	07000d93          	li	s11,112
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005038:	00002b97          	auipc	s7,0x2
    8000503c:	7f8b8b93          	addi	s7,s7,2040 # 80007830 <digits>
    80005040:	a081                	j	80005080 <printf+0xb2>
    acquire(&pr.lock);
    80005042:	0001c517          	auipc	a0,0x1c
    80005046:	b9650513          	addi	a0,a0,-1130 # 80020bd8 <pr>
    8000504a:	554000ef          	jal	ra,8000559e <acquire>
  va_start(ap, fmt);
    8000504e:	00840793          	addi	a5,s0,8
    80005052:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005056:	000a4503          	lbu	a0,0(s4)
    8000505a:	f171                	bnez	a0,8000501e <printf+0x50>
#endif
  }
  va_end(ap);

  if(locking)
    release(&pr.lock);
    8000505c:	0001c517          	auipc	a0,0x1c
    80005060:	b7c50513          	addi	a0,a0,-1156 # 80020bd8 <pr>
    80005064:	5d2000ef          	jal	ra,80005636 <release>
    80005068:	aaed                	j	80005262 <printf+0x294>
      consputc(cx);
    8000506a:	ce9ff0ef          	jal	ra,80004d52 <consputc>
      continue;
    8000506e:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005070:	0014899b          	addiw	s3,s1,1
    80005074:	013a07b3          	add	a5,s4,s3
    80005078:	0007c503          	lbu	a0,0(a5)
    8000507c:	1c050f63          	beqz	a0,8000525a <printf+0x28c>
    if(cx != '%'){
    80005080:	ff5515e3          	bne	a0,s5,8000506a <printf+0x9c>
    i++;
    80005084:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005088:	009a07b3          	add	a5,s4,s1
    8000508c:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005090:	1c090563          	beqz	s2,8000525a <printf+0x28c>
    80005094:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005098:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000509a:	c789                	beqz	a5,800050a4 <printf+0xd6>
    8000509c:	009a0733          	add	a4,s4,s1
    800050a0:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800050a4:	03690463          	beq	s2,s6,800050cc <printf+0xfe>
    } else if(c0 == 'l' && c1 == 'd'){
    800050a8:	03890e63          	beq	s2,s8,800050e4 <printf+0x116>
    } else if(c0 == 'u'){
    800050ac:	0b990d63          	beq	s2,s9,80005166 <printf+0x198>
    } else if(c0 == 'x'){
    800050b0:	11a90363          	beq	s2,s10,800051b6 <printf+0x1e8>
    } else if(c0 == 'p'){
    800050b4:	13b90b63          	beq	s2,s11,800051ea <printf+0x21c>
    } else if(c0 == 's'){
    800050b8:	07300793          	li	a5,115
    800050bc:	16f90363          	beq	s2,a5,80005222 <printf+0x254>
    } else if(c0 == '%'){
    800050c0:	03591c63          	bne	s2,s5,800050f8 <printf+0x12a>
      consputc('%');
    800050c4:	8556                	mv	a0,s5
    800050c6:	c8dff0ef          	jal	ra,80004d52 <consputc>
    800050ca:	b75d                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, int), 10, 1);
    800050cc:	f8843783          	ld	a5,-120(s0)
    800050d0:	00878713          	addi	a4,a5,8
    800050d4:	f8e43423          	sd	a4,-120(s0)
    800050d8:	4605                	li	a2,1
    800050da:	45a9                	li	a1,10
    800050dc:	4388                	lw	a0,0(a5)
    800050de:	e5dff0ef          	jal	ra,80004f3a <printint>
    800050e2:	b779                	j	80005070 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'd'){
    800050e4:	03678163          	beq	a5,s6,80005106 <printf+0x138>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800050e8:	03878d63          	beq	a5,s8,80005122 <printf+0x154>
    } else if(c0 == 'l' && c1 == 'u'){
    800050ec:	09978963          	beq	a5,s9,8000517e <printf+0x1b0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800050f0:	03878b63          	beq	a5,s8,80005126 <printf+0x158>
    } else if(c0 == 'l' && c1 == 'x'){
    800050f4:	0da78d63          	beq	a5,s10,800051ce <printf+0x200>
      consputc('%');
    800050f8:	8556                	mv	a0,s5
    800050fa:	c59ff0ef          	jal	ra,80004d52 <consputc>
      consputc(c0);
    800050fe:	854a                	mv	a0,s2
    80005100:	c53ff0ef          	jal	ra,80004d52 <consputc>
    80005104:	b7b5                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    80005106:	f8843783          	ld	a5,-120(s0)
    8000510a:	00878713          	addi	a4,a5,8
    8000510e:	f8e43423          	sd	a4,-120(s0)
    80005112:	4605                	li	a2,1
    80005114:	45a9                	li	a1,10
    80005116:	6388                	ld	a0,0(a5)
    80005118:	e23ff0ef          	jal	ra,80004f3a <printint>
      i += 1;
    8000511c:	0029849b          	addiw	s1,s3,2
    80005120:	bf81                	j	80005070 <printf+0xa2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005122:	03668463          	beq	a3,s6,8000514a <printf+0x17c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005126:	07968a63          	beq	a3,s9,8000519a <printf+0x1cc>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000512a:	fda697e3          	bne	a3,s10,800050f8 <printf+0x12a>
      printint(va_arg(ap, uint64), 16, 0);
    8000512e:	f8843783          	ld	a5,-120(s0)
    80005132:	00878713          	addi	a4,a5,8
    80005136:	f8e43423          	sd	a4,-120(s0)
    8000513a:	4601                	li	a2,0
    8000513c:	45c1                	li	a1,16
    8000513e:	6388                	ld	a0,0(a5)
    80005140:	dfbff0ef          	jal	ra,80004f3a <printint>
      i += 2;
    80005144:	0039849b          	addiw	s1,s3,3
    80005148:	b725                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 1);
    8000514a:	f8843783          	ld	a5,-120(s0)
    8000514e:	00878713          	addi	a4,a5,8
    80005152:	f8e43423          	sd	a4,-120(s0)
    80005156:	4605                	li	a2,1
    80005158:	45a9                	li	a1,10
    8000515a:	6388                	ld	a0,0(a5)
    8000515c:	ddfff0ef          	jal	ra,80004f3a <printint>
      i += 2;
    80005160:	0039849b          	addiw	s1,s3,3
    80005164:	b731                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, int), 10, 0);
    80005166:	f8843783          	ld	a5,-120(s0)
    8000516a:	00878713          	addi	a4,a5,8
    8000516e:	f8e43423          	sd	a4,-120(s0)
    80005172:	4601                	li	a2,0
    80005174:	45a9                	li	a1,10
    80005176:	4388                	lw	a0,0(a5)
    80005178:	dc3ff0ef          	jal	ra,80004f3a <printint>
    8000517c:	bdd5                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000517e:	f8843783          	ld	a5,-120(s0)
    80005182:	00878713          	addi	a4,a5,8
    80005186:	f8e43423          	sd	a4,-120(s0)
    8000518a:	4601                	li	a2,0
    8000518c:	45a9                	li	a1,10
    8000518e:	6388                	ld	a0,0(a5)
    80005190:	dabff0ef          	jal	ra,80004f3a <printint>
      i += 1;
    80005194:	0029849b          	addiw	s1,s3,2
    80005198:	bde1                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, uint64), 10, 0);
    8000519a:	f8843783          	ld	a5,-120(s0)
    8000519e:	00878713          	addi	a4,a5,8
    800051a2:	f8e43423          	sd	a4,-120(s0)
    800051a6:	4601                	li	a2,0
    800051a8:	45a9                	li	a1,10
    800051aa:	6388                	ld	a0,0(a5)
    800051ac:	d8fff0ef          	jal	ra,80004f3a <printint>
      i += 2;
    800051b0:	0039849b          	addiw	s1,s3,3
    800051b4:	bd75                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, int), 16, 0);
    800051b6:	f8843783          	ld	a5,-120(s0)
    800051ba:	00878713          	addi	a4,a5,8
    800051be:	f8e43423          	sd	a4,-120(s0)
    800051c2:	4601                	li	a2,0
    800051c4:	45c1                	li	a1,16
    800051c6:	4388                	lw	a0,0(a5)
    800051c8:	d73ff0ef          	jal	ra,80004f3a <printint>
    800051cc:	b555                	j	80005070 <printf+0xa2>
      printint(va_arg(ap, uint64), 16, 0);
    800051ce:	f8843783          	ld	a5,-120(s0)
    800051d2:	00878713          	addi	a4,a5,8
    800051d6:	f8e43423          	sd	a4,-120(s0)
    800051da:	4601                	li	a2,0
    800051dc:	45c1                	li	a1,16
    800051de:	6388                	ld	a0,0(a5)
    800051e0:	d5bff0ef          	jal	ra,80004f3a <printint>
      i += 1;
    800051e4:	0029849b          	addiw	s1,s3,2
    800051e8:	b561                	j	80005070 <printf+0xa2>
      printptr(va_arg(ap, uint64));
    800051ea:	f8843783          	ld	a5,-120(s0)
    800051ee:	00878713          	addi	a4,a5,8
    800051f2:	f8e43423          	sd	a4,-120(s0)
    800051f6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800051fa:	03000513          	li	a0,48
    800051fe:	b55ff0ef          	jal	ra,80004d52 <consputc>
  consputc('x');
    80005202:	856a                	mv	a0,s10
    80005204:	b4fff0ef          	jal	ra,80004d52 <consputc>
    80005208:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000520a:	03c9d793          	srli	a5,s3,0x3c
    8000520e:	97de                	add	a5,a5,s7
    80005210:	0007c503          	lbu	a0,0(a5)
    80005214:	b3fff0ef          	jal	ra,80004d52 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005218:	0992                	slli	s3,s3,0x4
    8000521a:	397d                	addiw	s2,s2,-1
    8000521c:	fe0917e3          	bnez	s2,8000520a <printf+0x23c>
    80005220:	bd81                	j	80005070 <printf+0xa2>
      if((s = va_arg(ap, char*)) == 0)
    80005222:	f8843783          	ld	a5,-120(s0)
    80005226:	00878713          	addi	a4,a5,8
    8000522a:	f8e43423          	sd	a4,-120(s0)
    8000522e:	0007b903          	ld	s2,0(a5)
    80005232:	00090d63          	beqz	s2,8000524c <printf+0x27e>
      for(; *s; s++)
    80005236:	00094503          	lbu	a0,0(s2)
    8000523a:	e2050be3          	beqz	a0,80005070 <printf+0xa2>
        consputc(*s);
    8000523e:	b15ff0ef          	jal	ra,80004d52 <consputc>
      for(; *s; s++)
    80005242:	0905                	addi	s2,s2,1
    80005244:	00094503          	lbu	a0,0(s2)
    80005248:	f97d                	bnez	a0,8000523e <printf+0x270>
    8000524a:	b51d                	j	80005070 <printf+0xa2>
        s = "(null)";
    8000524c:	00002917          	auipc	s2,0x2
    80005250:	5c490913          	addi	s2,s2,1476 # 80007810 <syscalls+0x3f8>
      for(; *s; s++)
    80005254:	02800513          	li	a0,40
    80005258:	b7dd                	j	8000523e <printf+0x270>
  if(locking)
    8000525a:	f7843783          	ld	a5,-136(s0)
    8000525e:	de079fe3          	bnez	a5,8000505c <printf+0x8e>

  return 0;
}
    80005262:	4501                	li	a0,0
    80005264:	60aa                	ld	ra,136(sp)
    80005266:	640a                	ld	s0,128(sp)
    80005268:	74e6                	ld	s1,120(sp)
    8000526a:	7946                	ld	s2,112(sp)
    8000526c:	79a6                	ld	s3,104(sp)
    8000526e:	7a06                	ld	s4,96(sp)
    80005270:	6ae6                	ld	s5,88(sp)
    80005272:	6b46                	ld	s6,80(sp)
    80005274:	6ba6                	ld	s7,72(sp)
    80005276:	6c06                	ld	s8,64(sp)
    80005278:	7ce2                	ld	s9,56(sp)
    8000527a:	7d42                	ld	s10,48(sp)
    8000527c:	7da2                	ld	s11,40(sp)
    8000527e:	6169                	addi	sp,sp,208
    80005280:	8082                	ret

0000000080005282 <panic>:

void
panic(char *s)
{
    80005282:	1101                	addi	sp,sp,-32
    80005284:	ec06                	sd	ra,24(sp)
    80005286:	e822                	sd	s0,16(sp)
    80005288:	e426                	sd	s1,8(sp)
    8000528a:	1000                	addi	s0,sp,32
    8000528c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000528e:	0001c797          	auipc	a5,0x1c
    80005292:	9607a123          	sw	zero,-1694(a5) # 80020bf0 <pr+0x18>
  printf("panic: ");
    80005296:	00002517          	auipc	a0,0x2
    8000529a:	58250513          	addi	a0,a0,1410 # 80007818 <syscalls+0x400>
    8000529e:	d31ff0ef          	jal	ra,80004fce <printf>
  printf("%s\n", s);
    800052a2:	85a6                	mv	a1,s1
    800052a4:	00002517          	auipc	a0,0x2
    800052a8:	57c50513          	addi	a0,a0,1404 # 80007820 <syscalls+0x408>
    800052ac:	d23ff0ef          	jal	ra,80004fce <printf>
  panicked = 1; // freeze uart output from other CPUs
    800052b0:	4785                	li	a5,1
    800052b2:	00002717          	auipc	a4,0x2
    800052b6:	62f72d23          	sw	a5,1594(a4) # 800078ec <panicked>
  for(;;)
    800052ba:	a001                	j	800052ba <panic+0x38>

00000000800052bc <printfinit>:
    ;
}

void
printfinit(void)
{
    800052bc:	1101                	addi	sp,sp,-32
    800052be:	ec06                	sd	ra,24(sp)
    800052c0:	e822                	sd	s0,16(sp)
    800052c2:	e426                	sd	s1,8(sp)
    800052c4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800052c6:	0001c497          	auipc	s1,0x1c
    800052ca:	91248493          	addi	s1,s1,-1774 # 80020bd8 <pr>
    800052ce:	00002597          	auipc	a1,0x2
    800052d2:	55a58593          	addi	a1,a1,1370 # 80007828 <syscalls+0x410>
    800052d6:	8526                	mv	a0,s1
    800052d8:	246000ef          	jal	ra,8000551e <initlock>
  pr.locking = 1;
    800052dc:	4785                	li	a5,1
    800052de:	cc9c                	sw	a5,24(s1)
}
    800052e0:	60e2                	ld	ra,24(sp)
    800052e2:	6442                	ld	s0,16(sp)
    800052e4:	64a2                	ld	s1,8(sp)
    800052e6:	6105                	addi	sp,sp,32
    800052e8:	8082                	ret

00000000800052ea <uartinit>:

void uartstart();

void
uartinit(void)
{
    800052ea:	1141                	addi	sp,sp,-16
    800052ec:	e406                	sd	ra,8(sp)
    800052ee:	e022                	sd	s0,0(sp)
    800052f0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800052f2:	100007b7          	lui	a5,0x10000
    800052f6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800052fa:	f8000713          	li	a4,-128
    800052fe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005302:	470d                	li	a4,3
    80005304:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005308:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000530c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005310:	469d                	li	a3,7
    80005312:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005316:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000531a:	00002597          	auipc	a1,0x2
    8000531e:	52e58593          	addi	a1,a1,1326 # 80007848 <digits+0x18>
    80005322:	0001c517          	auipc	a0,0x1c
    80005326:	8d650513          	addi	a0,a0,-1834 # 80020bf8 <uart_tx_lock>
    8000532a:	1f4000ef          	jal	ra,8000551e <initlock>
}
    8000532e:	60a2                	ld	ra,8(sp)
    80005330:	6402                	ld	s0,0(sp)
    80005332:	0141                	addi	sp,sp,16
    80005334:	8082                	ret

0000000080005336 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005336:	1101                	addi	sp,sp,-32
    80005338:	ec06                	sd	ra,24(sp)
    8000533a:	e822                	sd	s0,16(sp)
    8000533c:	e426                	sd	s1,8(sp)
    8000533e:	1000                	addi	s0,sp,32
    80005340:	84aa                	mv	s1,a0
  push_off();
    80005342:	21c000ef          	jal	ra,8000555e <push_off>

  if(panicked){
    80005346:	00002797          	auipc	a5,0x2
    8000534a:	5a67a783          	lw	a5,1446(a5) # 800078ec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000534e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005352:	c391                	beqz	a5,80005356 <uartputc_sync+0x20>
    for(;;)
    80005354:	a001                	j	80005354 <uartputc_sync+0x1e>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005356:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000535a:	0ff7f793          	andi	a5,a5,255
    8000535e:	0207f793          	andi	a5,a5,32
    80005362:	dbf5                	beqz	a5,80005356 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    80005364:	0ff4f793          	andi	a5,s1,255
    80005368:	10000737          	lui	a4,0x10000
    8000536c:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005370:	272000ef          	jal	ra,800055e2 <pop_off>
}
    80005374:	60e2                	ld	ra,24(sp)
    80005376:	6442                	ld	s0,16(sp)
    80005378:	64a2                	ld	s1,8(sp)
    8000537a:	6105                	addi	sp,sp,32
    8000537c:	8082                	ret

000000008000537e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000537e:	00002717          	auipc	a4,0x2
    80005382:	57273703          	ld	a4,1394(a4) # 800078f0 <uart_tx_r>
    80005386:	00002797          	auipc	a5,0x2
    8000538a:	5727b783          	ld	a5,1394(a5) # 800078f8 <uart_tx_w>
    8000538e:	06e78e63          	beq	a5,a4,8000540a <uartstart+0x8c>
{
    80005392:	7139                	addi	sp,sp,-64
    80005394:	fc06                	sd	ra,56(sp)
    80005396:	f822                	sd	s0,48(sp)
    80005398:	f426                	sd	s1,40(sp)
    8000539a:	f04a                	sd	s2,32(sp)
    8000539c:	ec4e                	sd	s3,24(sp)
    8000539e:	e852                	sd	s4,16(sp)
    800053a0:	e456                	sd	s5,8(sp)
    800053a2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800053a4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800053a8:	0001ca17          	auipc	s4,0x1c
    800053ac:	850a0a13          	addi	s4,s4,-1968 # 80020bf8 <uart_tx_lock>
    uart_tx_r += 1;
    800053b0:	00002497          	auipc	s1,0x2
    800053b4:	54048493          	addi	s1,s1,1344 # 800078f0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800053b8:	00002997          	auipc	s3,0x2
    800053bc:	54098993          	addi	s3,s3,1344 # 800078f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800053c0:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800053c4:	0ff7f793          	andi	a5,a5,255
    800053c8:	0207f793          	andi	a5,a5,32
    800053cc:	c795                	beqz	a5,800053f8 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800053ce:	01f77793          	andi	a5,a4,31
    800053d2:	97d2                	add	a5,a5,s4
    800053d4:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800053d8:	0705                	addi	a4,a4,1
    800053da:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800053dc:	8526                	mv	a0,s1
    800053de:	f47fb0ef          	jal	ra,80001324 <wakeup>
    
    WriteReg(THR, c);
    800053e2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800053e6:	6098                	ld	a4,0(s1)
    800053e8:	0009b783          	ld	a5,0(s3)
    800053ec:	fce79ae3          	bne	a5,a4,800053c0 <uartstart+0x42>
      ReadReg(ISR);
    800053f0:	100007b7          	lui	a5,0x10000
    800053f4:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    800053f8:	70e2                	ld	ra,56(sp)
    800053fa:	7442                	ld	s0,48(sp)
    800053fc:	74a2                	ld	s1,40(sp)
    800053fe:	7902                	ld	s2,32(sp)
    80005400:	69e2                	ld	s3,24(sp)
    80005402:	6a42                	ld	s4,16(sp)
    80005404:	6aa2                	ld	s5,8(sp)
    80005406:	6121                	addi	sp,sp,64
    80005408:	8082                	ret
      ReadReg(ISR);
    8000540a:	100007b7          	lui	a5,0x10000
    8000540e:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80005412:	8082                	ret

0000000080005414 <uartputc>:
{
    80005414:	7179                	addi	sp,sp,-48
    80005416:	f406                	sd	ra,40(sp)
    80005418:	f022                	sd	s0,32(sp)
    8000541a:	ec26                	sd	s1,24(sp)
    8000541c:	e84a                	sd	s2,16(sp)
    8000541e:	e44e                	sd	s3,8(sp)
    80005420:	e052                	sd	s4,0(sp)
    80005422:	1800                	addi	s0,sp,48
    80005424:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005426:	0001b517          	auipc	a0,0x1b
    8000542a:	7d250513          	addi	a0,a0,2002 # 80020bf8 <uart_tx_lock>
    8000542e:	170000ef          	jal	ra,8000559e <acquire>
  if(panicked){
    80005432:	00002797          	auipc	a5,0x2
    80005436:	4ba7a783          	lw	a5,1210(a5) # 800078ec <panicked>
    8000543a:	efbd                	bnez	a5,800054b8 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000543c:	00002797          	auipc	a5,0x2
    80005440:	4bc7b783          	ld	a5,1212(a5) # 800078f8 <uart_tx_w>
    80005444:	00002717          	auipc	a4,0x2
    80005448:	4ac73703          	ld	a4,1196(a4) # 800078f0 <uart_tx_r>
    8000544c:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005450:	0001ba17          	auipc	s4,0x1b
    80005454:	7a8a0a13          	addi	s4,s4,1960 # 80020bf8 <uart_tx_lock>
    80005458:	00002497          	auipc	s1,0x2
    8000545c:	49848493          	addi	s1,s1,1176 # 800078f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005460:	00002917          	auipc	s2,0x2
    80005464:	49890913          	addi	s2,s2,1176 # 800078f8 <uart_tx_w>
    80005468:	00f71d63          	bne	a4,a5,80005482 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000546c:	85d2                	mv	a1,s4
    8000546e:	8526                	mv	a0,s1
    80005470:	e69fb0ef          	jal	ra,800012d8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005474:	00093783          	ld	a5,0(s2)
    80005478:	6098                	ld	a4,0(s1)
    8000547a:	02070713          	addi	a4,a4,32
    8000547e:	fef707e3          	beq	a4,a5,8000546c <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005482:	0001b497          	auipc	s1,0x1b
    80005486:	77648493          	addi	s1,s1,1910 # 80020bf8 <uart_tx_lock>
    8000548a:	01f7f713          	andi	a4,a5,31
    8000548e:	9726                	add	a4,a4,s1
    80005490:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80005494:	0785                	addi	a5,a5,1
    80005496:	00002717          	auipc	a4,0x2
    8000549a:	46f73123          	sd	a5,1122(a4) # 800078f8 <uart_tx_w>
  uartstart();
    8000549e:	ee1ff0ef          	jal	ra,8000537e <uartstart>
  release(&uart_tx_lock);
    800054a2:	8526                	mv	a0,s1
    800054a4:	192000ef          	jal	ra,80005636 <release>
}
    800054a8:	70a2                	ld	ra,40(sp)
    800054aa:	7402                	ld	s0,32(sp)
    800054ac:	64e2                	ld	s1,24(sp)
    800054ae:	6942                	ld	s2,16(sp)
    800054b0:	69a2                	ld	s3,8(sp)
    800054b2:	6a02                	ld	s4,0(sp)
    800054b4:	6145                	addi	sp,sp,48
    800054b6:	8082                	ret
    for(;;)
    800054b8:	a001                	j	800054b8 <uartputc+0xa4>

00000000800054ba <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800054ba:	1141                	addi	sp,sp,-16
    800054bc:	e422                	sd	s0,8(sp)
    800054be:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800054c0:	100007b7          	lui	a5,0x10000
    800054c4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800054c8:	8b85                	andi	a5,a5,1
    800054ca:	cb91                	beqz	a5,800054de <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800054cc:	100007b7          	lui	a5,0x10000
    800054d0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800054d4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800054d8:	6422                	ld	s0,8(sp)
    800054da:	0141                	addi	sp,sp,16
    800054dc:	8082                	ret
    return -1;
    800054de:	557d                	li	a0,-1
    800054e0:	bfe5                	j	800054d8 <uartgetc+0x1e>

00000000800054e2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800054e2:	1101                	addi	sp,sp,-32
    800054e4:	ec06                	sd	ra,24(sp)
    800054e6:	e822                	sd	s0,16(sp)
    800054e8:	e426                	sd	s1,8(sp)
    800054ea:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800054ec:	54fd                	li	s1,-1
    int c = uartgetc();
    800054ee:	fcdff0ef          	jal	ra,800054ba <uartgetc>
    if(c == -1)
    800054f2:	00950563          	beq	a0,s1,800054fc <uartintr+0x1a>
      break;
    consoleintr(c);
    800054f6:	88fff0ef          	jal	ra,80004d84 <consoleintr>
  while(1){
    800054fa:	bfd5                	j	800054ee <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800054fc:	0001b497          	auipc	s1,0x1b
    80005500:	6fc48493          	addi	s1,s1,1788 # 80020bf8 <uart_tx_lock>
    80005504:	8526                	mv	a0,s1
    80005506:	098000ef          	jal	ra,8000559e <acquire>
  uartstart();
    8000550a:	e75ff0ef          	jal	ra,8000537e <uartstart>
  release(&uart_tx_lock);
    8000550e:	8526                	mv	a0,s1
    80005510:	126000ef          	jal	ra,80005636 <release>
}
    80005514:	60e2                	ld	ra,24(sp)
    80005516:	6442                	ld	s0,16(sp)
    80005518:	64a2                	ld	s1,8(sp)
    8000551a:	6105                	addi	sp,sp,32
    8000551c:	8082                	ret

000000008000551e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000551e:	1141                	addi	sp,sp,-16
    80005520:	e422                	sd	s0,8(sp)
    80005522:	0800                	addi	s0,sp,16
  lk->name = name;
    80005524:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005526:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000552a:	00053823          	sd	zero,16(a0)
}
    8000552e:	6422                	ld	s0,8(sp)
    80005530:	0141                	addi	sp,sp,16
    80005532:	8082                	ret

0000000080005534 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005534:	411c                	lw	a5,0(a0)
    80005536:	e399                	bnez	a5,8000553c <holding+0x8>
    80005538:	4501                	li	a0,0
  return r;
}
    8000553a:	8082                	ret
{
    8000553c:	1101                	addi	sp,sp,-32
    8000553e:	ec06                	sd	ra,24(sp)
    80005540:	e822                	sd	s0,16(sp)
    80005542:	e426                	sd	s1,8(sp)
    80005544:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005546:	6904                	ld	s1,16(a0)
    80005548:	facfb0ef          	jal	ra,80000cf4 <mycpu>
    8000554c:	40a48533          	sub	a0,s1,a0
    80005550:	00153513          	seqz	a0,a0
}
    80005554:	60e2                	ld	ra,24(sp)
    80005556:	6442                	ld	s0,16(sp)
    80005558:	64a2                	ld	s1,8(sp)
    8000555a:	6105                	addi	sp,sp,32
    8000555c:	8082                	ret

000000008000555e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000555e:	1101                	addi	sp,sp,-32
    80005560:	ec06                	sd	ra,24(sp)
    80005562:	e822                	sd	s0,16(sp)
    80005564:	e426                	sd	s1,8(sp)
    80005566:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005568:	100024f3          	csrr	s1,sstatus
    8000556c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005570:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005572:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80005576:	f7efb0ef          	jal	ra,80000cf4 <mycpu>
    8000557a:	5d3c                	lw	a5,120(a0)
    8000557c:	cb99                	beqz	a5,80005592 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000557e:	f76fb0ef          	jal	ra,80000cf4 <mycpu>
    80005582:	5d3c                	lw	a5,120(a0)
    80005584:	2785                	addiw	a5,a5,1
    80005586:	dd3c                	sw	a5,120(a0)
}
    80005588:	60e2                	ld	ra,24(sp)
    8000558a:	6442                	ld	s0,16(sp)
    8000558c:	64a2                	ld	s1,8(sp)
    8000558e:	6105                	addi	sp,sp,32
    80005590:	8082                	ret
    mycpu()->intena = old;
    80005592:	f62fb0ef          	jal	ra,80000cf4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005596:	8085                	srli	s1,s1,0x1
    80005598:	8885                	andi	s1,s1,1
    8000559a:	dd64                	sw	s1,124(a0)
    8000559c:	b7cd                	j	8000557e <push_off+0x20>

000000008000559e <acquire>:
{
    8000559e:	1101                	addi	sp,sp,-32
    800055a0:	ec06                	sd	ra,24(sp)
    800055a2:	e822                	sd	s0,16(sp)
    800055a4:	e426                	sd	s1,8(sp)
    800055a6:	1000                	addi	s0,sp,32
    800055a8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800055aa:	fb5ff0ef          	jal	ra,8000555e <push_off>
  if(holding(lk))
    800055ae:	8526                	mv	a0,s1
    800055b0:	f85ff0ef          	jal	ra,80005534 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800055b4:	4705                	li	a4,1
  if(holding(lk))
    800055b6:	e105                	bnez	a0,800055d6 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800055b8:	87ba                	mv	a5,a4
    800055ba:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800055be:	2781                	sext.w	a5,a5
    800055c0:	ffe5                	bnez	a5,800055b8 <acquire+0x1a>
  __sync_synchronize();
    800055c2:	0ff0000f          	fence
  lk->cpu = mycpu();
    800055c6:	f2efb0ef          	jal	ra,80000cf4 <mycpu>
    800055ca:	e888                	sd	a0,16(s1)
}
    800055cc:	60e2                	ld	ra,24(sp)
    800055ce:	6442                	ld	s0,16(sp)
    800055d0:	64a2                	ld	s1,8(sp)
    800055d2:	6105                	addi	sp,sp,32
    800055d4:	8082                	ret
    panic("acquire");
    800055d6:	00002517          	auipc	a0,0x2
    800055da:	27a50513          	addi	a0,a0,634 # 80007850 <digits+0x20>
    800055de:	ca5ff0ef          	jal	ra,80005282 <panic>

00000000800055e2 <pop_off>:

void
pop_off(void)
{
    800055e2:	1141                	addi	sp,sp,-16
    800055e4:	e406                	sd	ra,8(sp)
    800055e6:	e022                	sd	s0,0(sp)
    800055e8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800055ea:	f0afb0ef          	jal	ra,80000cf4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800055ee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800055f2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800055f4:	e78d                	bnez	a5,8000561e <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800055f6:	5d3c                	lw	a5,120(a0)
    800055f8:	02f05963          	blez	a5,8000562a <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    800055fc:	37fd                	addiw	a5,a5,-1
    800055fe:	0007871b          	sext.w	a4,a5
    80005602:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005604:	eb09                	bnez	a4,80005616 <pop_off+0x34>
    80005606:	5d7c                	lw	a5,124(a0)
    80005608:	c799                	beqz	a5,80005616 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000560a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000560e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005612:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005616:	60a2                	ld	ra,8(sp)
    80005618:	6402                	ld	s0,0(sp)
    8000561a:	0141                	addi	sp,sp,16
    8000561c:	8082                	ret
    panic("pop_off - interruptible");
    8000561e:	00002517          	auipc	a0,0x2
    80005622:	23a50513          	addi	a0,a0,570 # 80007858 <digits+0x28>
    80005626:	c5dff0ef          	jal	ra,80005282 <panic>
    panic("pop_off");
    8000562a:	00002517          	auipc	a0,0x2
    8000562e:	24650513          	addi	a0,a0,582 # 80007870 <digits+0x40>
    80005632:	c51ff0ef          	jal	ra,80005282 <panic>

0000000080005636 <release>:
{
    80005636:	1101                	addi	sp,sp,-32
    80005638:	ec06                	sd	ra,24(sp)
    8000563a:	e822                	sd	s0,16(sp)
    8000563c:	e426                	sd	s1,8(sp)
    8000563e:	1000                	addi	s0,sp,32
    80005640:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005642:	ef3ff0ef          	jal	ra,80005534 <holding>
    80005646:	c105                	beqz	a0,80005666 <release+0x30>
  lk->cpu = 0;
    80005648:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000564c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80005650:	0f50000f          	fence	iorw,ow
    80005654:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80005658:	f8bff0ef          	jal	ra,800055e2 <pop_off>
}
    8000565c:	60e2                	ld	ra,24(sp)
    8000565e:	6442                	ld	s0,16(sp)
    80005660:	64a2                	ld	s1,8(sp)
    80005662:	6105                	addi	sp,sp,32
    80005664:	8082                	ret
    panic("release");
    80005666:	00002517          	auipc	a0,0x2
    8000566a:	21250513          	addi	a0,a0,530 # 80007878 <digits+0x48>
    8000566e:	c15ff0ef          	jal	ra,80005282 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
