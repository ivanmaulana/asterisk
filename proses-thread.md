# Proses

## System

`int system(string command);`

- menjalankan perintah pada string `command`

- dengan memanggil shell terlebih dahulu: `sh -c "command"`

- contoh `system.c`:

    ~~~c
    #include <stdio.h>
    #include <stdlib.h>

    int main()
    {
        puts("Running command");

        system("ps f");

        puts("Done");
        return 0;
    }
    ~~~

- hierarki proses

    ~~~
    ..
     \_ bash
         \_ ./system
             \_ sh -c "ps f"
                 \_ ps f
    ~~~

- bisa menjalankan rangkaian beberapa perintah sekaligus, contoh:

    ~~~c
    #include <stdio.h>
    #include <stdlib.h>

    int main()
    {
        system("who | wc -l");
        return 0;
    }
    ~~~

\newpage

### Latihan

Buat program untuk mendapatkan nama pembalap yang terbanyak menjuarai MotoGP dan jumlahnya.

Contoh masukan:

    2005 Rossi
    2006 Hayden
    2007 Stoner
    2008 Rossi
    2009 Rossi
    2010 Lorenzo
    2011 Stoner
    2012 Lorenzo
    2013 Marquez
    2014 Marquez

Contoh keluaran:

    Rossi 3

\newpage

<!--

~~~c
#include <stdio.h>
#include <stdlib.h>

int main()
{
    system("cut -f 2 -d ' ' \
          | sort \
          | uniq -c \
          | sort -n \
          | tail -1 \
          | awk {'print $2,$1'}");

    return 0;
}
~~~

-->

\newpage

## Exec

`int execvp(string file, string argv[]);`

`int execlp(string file, string arg, ...);`

- menggantikan proses saat ini dengan proses yang baru

- contoh `exec.c`:

    ~~~c
    #include <stdio.h>
    #include <unistd.h>

    int main()
    {
        puts("Running command");

        // using execvp
        char *args[] = {"ps", "f", NULL};
        execvp(args[0], args);

        // using execlp
        // execlp("ps", "ps", "f", NULL);

        puts("Done");
        return 0;
    }
    ~~~

- hierarki proses:

    ~~~
    ..
     \_ bash
         \_ ./exec
    ~~~

    setelah pemanggilan fungsi `exec` menjadi:

    ~~~
    ..
     \_ bash
         \_ ps f
    ~~~

## Fork

`pid_t fork(void);`

- menduplikasi proses

- return value
    - jika parent: PID child
    - jika child : 0
    - jika error : -1

- contoh `fork.c`:

    ~~~c
    #include <stdio.h>
    #include <unistd.h>

    int main()
    {
        fork();
        printf("Hello\n");
        return 0;
    }
    ~~~

\newpage

## Wait

`pid_t wait(int *status);`

- proses parent menunggu sampai proses child selesai

- return value: PID child

- parameter `status`: untuk mendapatkan return value dari proses child

- contoh `wait.c`:

    ~~~c
    #include <unistd.h>
    #include <stdio.h>
    #include <sys/wait.h>

    int main()
    {
        pid_t pid; char *msg; int n, status;

        pid = fork();
        if (pid == 0) { msg = "This is the child";  n = 5;}
                 else { msg = "This is the parent"; n = 3;}

        while (n--) { puts(msg); sleep(1); }

        if (pid != 0) {         // parent
            wait(&status);      // wait until child finished
            printf("child exited with code: %d\n", WEXITSTATUS(status));
        }

        return 0;
    }
    ~~~

\newpage

## Zombie process

- proses yang sudah mati, tetapi masih ada di memori

- biasanya proses child yang sudah selesai lebih dulu, tetapi parent-nya masih berjalan

- contoh `zombie.c`:

    ~~~c
    #include <unistd.h>
    #include <stdio.h>

    int main()
    {
        pid_t pid; char *msg; int n;

        pid = fork();
        if (pid == 0) { msg = "This is the child";  n = 3;}
                 else { msg = "This is the parent"; n = 25;}

        while (n--) { puts(msg); sleep(1); }

        return 0;
    }
    ~~~

- jalankan pada terminal, buka tab baru, jalankan `ps f` untuk menampilkan proses zombie

- ciri zombie: status `Z` dan nama proses menjadi `<defunct>`

    ~~~
    student@lab:~$ ps f
      PID TTY      STAT   TIME COMMAND
    12031 pts/3    Ss     0:00 bash
    12032 pts/3    R+     0:00  \_ ps f
    12027 pts/2    Ss     0:00 bash
    12028 pts/2    S+     0:00  \_ ./zombie
    12029 pts/2    Z+     0:00      \_ [zombie] <defunct>
    ~~~

\newpage

### Latihan

~~~c
// Berapa kali X dicetak, gambarkan pohon prosesnya!

#include <unistd.h>
#include <stdio.h>

int main()
{
    pid_t pid = fork();

    if (pid != 0)
        fork();

    fork();

    printf("X\n");
    return 0;
}
~~~

\newpage

## Signal

`signal(int signum, void function(int));`

- untuk meng-handle signal

- jika ada signal `signum` yang masuk maka fungsi `function` akan dijalankan

- contoh `signal.c`:

~~~c
#include <signal.h>
#include <stdio.h>
#include <unistd.h>

void ouch(int sig)
{
    printf("OUCH! - I got signal %d\n", sig);
    signal(SIGINT, SIG_DFL);
}

int main()
{
    signal(SIGINT, ouch);

    while (1) {
        printf("Hello World!\n");
        sleep(1);
    }
}
~~~

\newpage

## Kill

`int kill(pid_t pid, int signum);`

- untuk mengirim signal `signum` ke proses `pid`

- jika `pid == 0`, signal akan dikirim ke proses child

- contoh:

~~~c
#include <stdio.h>
#include <unistd.h>
#include <signal.h>

int main()
{
    pid_t child = fork();

    if (child == 0) {   // child
        while (1) {
            printf("Hello from child\n");
            sleep(1);
        }
    } else {            // parent
        sleep(3);
        kill(child, SIGSTOP);       // tell child to stop
        sleep(3);
        kill(child, SIGCONT);       // tell child to continue
        sleep(3);
        kill(child, SIGINT);        // interrupt child
    }

    return 0;
}
~~~

\newpage

## Pause

`int pause(void);`

- untuk menunggu sampai menerima signal

~~~c
#include <signal.h>
#include <stdio.h>
#include <unistd.h>

static int alarm_fired = 0;

void ding(int sig) { alarm_fired = 1; }

int main()
{
    if (fork() == 0) {  // child
        sleep(5);
        kill(getppid(), SIGALRM);
    } else {            // parent
        signal(SIGALRM, ding);
        printf("waiting...\n");
        pause();
        if (alarm_fired) printf("ding!\n");
    }
    return 0;
}
~~~

\newpage

## Tugas: *Simple Shell*

Buatlah progam *shell* sederhana dengan melengkapi kode program berikut: [sh.c](http://cs.ipb.ac.id/~auriza/so/sh.c.html).

<!--
Kumpulkan dengan format berikut ini.

    Subject: [SO] Simple Shell <NIM>
    To: auriza.akbar@gmail.com
-->

\newpage

# Thread

Memakai standar POSIX thread (pthread).
Kompilasi tambahkan flag `-pthread`

## Create

`pthread_create(&thread, attr, func, arg);`

- membuat satu `thread` yang akan menjalankan fungsi `func` dengan argumen `arg`.

- fungsi: `void *func(void *arg);`

## Join

`pthread_join(thread, &return);`

- menunggu `thread` selesai dan menyimpan status exit-nya ke `return`.

## Exit

`pthread_exit(return);`

- membuat thread keluar dengan status `return`.

\newpage

Contoh `thread_hello.c`:

~~~c
#include <pthread.h>
#include <stdio.h>

void *hello(void *arg)
{
    printf("Hello world from %s\n", (char*)arg);
    pthread_exit(NULL);
}

int main()
{
    pthread_t T[4];
    char *args[] = {"Alice", "Bob", "Charlie", "Dave"};
    int i;

    for (i = 0; i < 4; i++)
        pthread_create(&T[i], NULL, hello, args[i]);

    for (i = 0; i < 4; i++)
        pthread_join(T[i], NULL);

    return 0;
}
~~~

\newpage

### Latihan

Lengkapi program berikut untuk menjumlahkan nilai semua elemen array A.
Gunakan variabel global `sum` untuk menyimpan hasilnya.

~~~c
#include <stdio.h>
#define N 16

int sum = 0;

int main()
{
    int A[N] = {68,34,64,95,35,78,65,93,51,67,7,77,4,73,52,91};

    // TODO: array sum

    printf("%d\n", sum);    // 954
    return 0;
}
~~~

\newpage

<!--

~~~c
#include <stdio.h>
#define N 16

int sum = 0;

int main()
{
    int A[N] = {68,34,64,95,35,78,65,93,51,67,7,77,4,73,52,91};

    // array sum
    int i;
    for (i = 0; i < N; i++)
        sum += A[i];

    printf("%d\n", sum);
    return 0;
}
~~~

-->

Sekarang, buat satu buah thread untuk menjumlahkan nilai semua elemen array A dengan fungsi `array_sum()`.
Thread utama hanya membuat dan menunggu thread ini selesai.

\newpage

<!--

~~~c
#include <stdio.h>
#include <pthread.h>

#define N 16

int sum = 0;

void *array_sum(void *arg)
{
    int *array = (int*)arg;     // cast void* -> int*
    int i;

    for (i = 0; i < N; i++)
        sum += array[i];

    pthread_exit(NULL);
}

int main()
{
    pthread_t t;
    int A[N] = {68,34,64,95,35,78,65,93,51,67,7,77,4,73,52,91};

    pthread_create(&t, NULL, array_sum, A);

    pthread_join(t, NULL);

    printf("%d\n", sum);
    return 0;
}

~~~

-->

Oke, sekarang gunakan 2 buah thread untuk menjumlahkan nilai semua elemen array A.
Pastikan pembagian kerja antara kedua thread seimbang, yaitu tiap thread memproses $16/2 = 8$ elemen.

\newpage

<!--

~~~c
#include <stdio.h>
#include <pthread.h>

#define N 16

int sum = 0;

void *array_sum(void *arg)
{
    int *array = (int*)arg;     // cast void* -> int*
    int i;

    for (i = 0; i < N/2; i++)
        sum += array[i];

    pthread_exit(NULL);
}

int main()
{
    pthread_t t[2];
    int A[N] = {68,34,64,95,35,78,65,93,51,67,7,77,4,73,52,91};

    pthread_create(&t[0], NULL, array_sum, &A[0]);
    pthread_create(&t[1], NULL, array_sum, &A[8]);

    pthread_join(t[0], NULL);
    pthread_join(t[1], NULL);

    printf("%d\n", sum);
    return 0;
}
~~~

-->

Bisa? Sekarang gunakan 4 buah thread untuk menjumlahkan nilai semua elemen array A.
Pastikan pembagian kerja antara keempat thread seimbang, yaitu tiap thread memproses $16/4 = 4$ elemen.

\newpage

<!--

~~~c
#include <stdio.h>
#include <pthread.h>

#define N 16
#define T 4

int sum = 0;

void *array_sum(void *arg)
{
    int *array = (int*)arg;     // cast void* -> int*
    int i;

    for (i = 0; i < N/T; i++)
        sum += array[i];

    pthread_exit(NULL);
}

int main()
{
    pthread_t t[T];
    int A[N] = {68,34,64,95,35,78,65,93,51,67,7,77,4,73,52,91};
    int i;

    for (i = 0; i < T; i++)
        pthread_create(&t[i], NULL, array_sum, &A[i * N/T]);

    for (i = 0; i < T; i++)
        pthread_join(t[i], NULL);

    printf("%d\n", sum);
    return 0;
}
~~~

-->

\newpage

# Sinkronisasi Thread

## Semaphore

Nilai semaphore diinisialisasi dengan bilangan non-negatif. Terdapat dua operasi atomic yang bisa dilakukan pada semaphore, yaitu *wait* dan *post*.

~~~
wait(S):
    while (S == 0)
        noop;
    S = S - 1;

post(S):
    S = S + 1;
~~~

~~~c
#include <semaphore.h>

int sem_init(sem_t *sem, int pshared, unsigned int value);
int sem_wait(sem_t *sem);
int sem_post(sem_t *sem);
int sem_destroy(sem_t *sem);
~~~

- `init`: inisialisasi `sem` dengan nilai awal `value`
- `wait`:
    - jika `sem = 0` --> block
    - jika `sem > 0` --> `sem--`, continue
- `post`: `sem++`
- `destroy`: menghapus `sem`

\newpage

## Mutual Exclusion

Untuk mengunci sebuah critical section.

>   A critical section is a section of code that can be executed by at most one process at a time. The critical section exists to protect shared resources from multiple access (Jones 2008).

>   Mutex is a key to a variable. One thread can have the key---modify the variable---at the time. When finished, the thread gives (frees) the key to the next thread in the group (<http://koti.mbnet.fi/niclasw/MutexSemaphore.html>).

~~~c
#include <pthread.h>

int pthread_mutex_init(pthread_mutex_t *mutex,
                       const pthread_mutexattr_t *attr);
int pthread_mutex_lock(pthread_mutex_t *mutex));
int pthread_mutex_unlock(pthread_mutex_t *mutex);
int pthread_mutex_destroy(pthread_mutex_t *mutex);
~~~

- `init`: inisialisasi `mutex`
- `lock`: mengunci critical section
- `unlock`: melepaskan kunci critical section
- `destroy`: menghapus `mutex`

\newpage

### Latihan

Apa yang salah dengan kode berikut ini?
Perbaiki dengan menggunakan semaphore.

~~~c
// counting to one million
#include <stdio.h>
#include <pthread.h>

#define N 1000000
#define T 4

int count = 0;

void *counting(void *arg)
{
    int i;
    for (i = 0; i < N/T; i++)
        count++;                // critical section

    pthread_exit(NULL);
}

int main()
{
    pthread_t t[T];
    int i;

    for (i = 0; i < T; i++)
        pthread_create(&t[i], NULL, counting, NULL);

    for (i = 0; i < T; i++)
        pthread_join(t[i], NULL);

    printf("%d\n", count);      // 1000000, no?
    return 0;
}
~~~

\newpage

<!--

~~~c
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define N 1000000
#define T 4

int count = 0;
sem_t sem;

void *counting(void *arg)
{
    int i;
    for (i = 0; i < N/T; i++) {
        sem_wait(&sem);
        count++;
        sem_post(&sem);
    }
    pthread_exit(NULL);
}

int main()
{
    pthread_t t[T];
    int i;

    sem_init(&sem, 0, 1);

    for (i = 0; i < T; i++)
        pthread_create(&t[i], NULL, counting, NULL);

    for (i = 0; i < T; i++)
        pthread_join(t[i], NULL);

    sem_destroy(&sem);

    printf("%d\n", count);      // now, it is always 1000000
    return 0;
}
~~~

-->

Jika sudah, ubah sinkronisasi dari menggunakan semaphore menjadi mutex.

\newpage

<!--

~~~c
#include <stdio.h>
#include <pthread.h>


#define N 1000000
#define T 4

int count = 0;
pthread_mutex_t mutex;

void *counting(void *arg)
{
    int i;
    for (i = 0; i < N/T; i++) {
        pthread_mutex_lock(&mutex);
        count++;
        pthread_mutex_unlock(&mutex);
    }
    pthread_exit(NULL);
}

int main()
{
    pthread_t t[T];
    int i;

    pthread_mutex_init(&mutex, NULL);

    for (i = 0; i < T; i++)
        pthread_create(&t[i], NULL, counting, NULL);

    for (i = 0; i < T; i++)
        pthread_join(t[i], NULL);

    pthread_mutex_destroy(&mutex);

    printf("%d\n", count);      // now, it is always 1000000
    return 0;
}
~~~

-->

\newpage

### Latihan

Identifikasi critical section dan perbaiki kode berikut ini supaya hasilnya benar.

~~~c
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

#define N 100000
#define T 4

int sum = 0;

void *array_sum(void *arg)
{
    int *array = (int*)arg;     // cast void* --> int*
    int i;

    for (i = 0; i < N/T; i++)
        sum += array[i];

    pthread_exit(NULL);
}

int main()
{
    pthread_t t[T];
    int A[N], i;

    for (i = 0; i < N; i++)
        A[i] = rand()%10;

    for (i = 0; i < T; i++)
        pthread_create(&t[i], NULL, array_sum, &A[i * N/T]);

    for (i = 0; i < T; i++)
        pthread_join(t[i], NULL);

    printf("%d\n", sum);    // 448706
    return 0;
}
~~~

\newpage

<!--

~~~c
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

#define N 100000
#define T 4

int sum = 0;
pthread_mutex_t mutex;

void *array_sum(void *arg)
{
    int *array = (int*)arg;         // cast void* -> int*
    int i, sumlocal = 0;

    for (i = 0; i < N/T; i++)
        sumlocal += array[i];

    pthread_mutex_lock(&mutex);
    sum += sumlocal;                // critical section
    pthread_mutex_unlock(&mutex);

    pthread_exit(NULL);
}

int main()
{
    pthread_t t[T];
    int A[N], i;

    pthread_mutex_init(&mutex, NULL);

    for (i = 0; i < N; i++)
        A[i] = rand()%10;

    for (i = 0; i < T; i++)
        pthread_create(&t[i], NULL, array_sum, &A[i * N/T]);

    for (i = 0; i < T; i++)
        pthread_join(t[i], NULL);

    pthread_mutex_destroy(&mutex);

    printf("%d\n", sum);    // 448706
    return 0;
}
~~~

-->
