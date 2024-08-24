#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  backtrace();

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// 定义一个函数 `sys_sigreturn`，返回类型为 `uint64`
uint64
sys_sigreturn(void)
{
  // 获取当前进程的指针，通过调用 `myproc()` 函数
  struct proc* proc = myproc();
  
  // 重新存储陷阱帧(trapframe)，以便返回到中断发生之前的状态
  *proc->trapframe = proc->saved_trapframe;

  // 标记该进程已经处理过信号返回，设置为 1 表示 true
  proc->have_return = 1;
  
  // 返回当前进程的 `trapframe` 中的 `a0` 寄存器的值
  // 这个值通常用于保存系统调用的返回值
  return proc->trapframe->a0;
}

// 定义一个函数 `sys_sigalarm`，返回类型为 `uint64`
uint64
sys_sigalarm(void)
{
  int ticks;           // 定义一个整数变量 `ticks`，用于存储闹钟的间隔
  uint64 handler_va;   // 定义一个无符号64位整数变量 `handler_va`，用于存储信号处理程序的虚拟地址

  // 获取系统调用的第一个参数（闹钟的时间间隔），存储到 `ticks` 中
  argint(0, &ticks);
  
  // 获取系统调用的第二个参数（信号处理程序的虚拟地址），存储到 `handler_va` 中
  argaddr(1, &handler_va);
  
  // 获取当前进程的指针，通过调用 `myproc()` 函数
  struct proc* proc = myproc();
  
  // 设置当前进程的闹钟时间间隔为 `ticks`
  proc->alarm_interval = ticks;
  
  // 设置当前进程的信号处理程序的虚拟地址为 `handler_va`
  proc->handler_va = handler_va;
  
  // 标记该进程已经设置了闹钟，`have_return` 为 1 表示 true
  proc->have_return = 1;
  
  // 返回 0，表示成功设置了闹钟
  return 0;
}

