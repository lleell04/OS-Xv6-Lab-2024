#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>
#include <pthread.h>

static int nthread = 1;
static int round = 0;

struct barrier {
  pthread_mutex_t barrier_mutex;// 互斥锁，用于保护屏障状态
  pthread_cond_t barrier_cond;// 条件变量，用于线程同步
  int nthread;      // 已经到达屏障的线程数量
  int round;     // 屏障的当前轮次
} bstate;

static void
barrier_init(void)
{
  assert(pthread_mutex_init(&bstate.barrier_mutex, NULL) == 0);// 初始化互斥锁
  assert(pthread_cond_init(&bstate.barrier_cond, NULL) == 0);// 初始化条件变量
  bstate.nthread = 0;
}

static void 
barrier()
{
  // YOUR CODE HERE
  //
  // Block until all threads have called barrier() and
  // then increment bstate.round.
  //
    // 上锁
  pthread_mutex_lock(&bstate.barrier_mutex);

  // 来了一个线程, 累计 ++
  ++ bstate.nthread;

  // 查看条件变量
  if (bstate.nthread != nthread) {
      // 放弃锁并且睡眠, 等待条件变量来唤醒
      pthread_cond_wait(&bstate.barrier_cond, &bstate.barrier_mutex);
  } else {
      // 增加 barrier 里的计数 (只计一次)
      ++ bstate.round;
      // 清零
      bstate.nthread = 0;
      // 当最后一个线程到达, 直接广播给其他的线程
      pthread_cond_broadcast(&bstate.barrier_cond);
  }

  // 解锁
  pthread_mutex_unlock(&bstate.barrier_mutex);
}

static void *
thread(void *xa)
{
  long n = (long) xa;
  long delay;
  int i;

  for (i = 0; i < 20000; i++) {
    int t = bstate.round;
    assert (i == t);
    barrier();
    usleep(random() % 100);
  }

  return 0;
}

int
main(int argc, char *argv[])
{
  pthread_t *tha;
  void *value;
  long i;
  double t1, t0;

  if (argc < 2) {
    fprintf(stderr, "%s: %s nthread\n", argv[0], argv[0]);
    exit(-1);
  }
  nthread = atoi(argv[1]);
  tha = malloc(sizeof(pthread_t) * nthread);
  srandom(0);

  barrier_init();

  for(i = 0; i < nthread; i++) {
    assert(pthread_create(&tha[i], NULL, thread, (void *) i) == 0);
  }
  for(i = 0; i < nthread; i++) {
    assert(pthread_join(tha[i], &value) == 0);
  }
  printf("OK; passed\n");
}
