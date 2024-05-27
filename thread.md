###Мультипоточность

##сортировка с распараллеливанием
"#include <execution> include <algorithm>"
sort(execution::par, v.begin(), v.end());

##std::thread
thread<F, Args...>(F&&, Args&&...) --конструирование из F и Args
		#пример:
		std::thread t1(&Queue::add_count, &q); --ссылки для вызова метода класса
		std::thread th(&sum, std::ref(result), std::ref(v1), std::ref(v2), j, i); --передача параметров в функцию по ссылке и значению
		#потоки в векторе
		std::vector<std::thread> threads;
		for (auto i = 0; i < count; ++i) {
		std::thread th(&sum, std::ref(result), std::ref(v1), std::ref(v2), j, i);
		threads.push_back(std::move(th));
		for (std::thread& th : threads)
		{
			if (th.joinable())
				th.join();
		}

	}

bool joinable() --true если поток не был отделен (detached)

void join() --блокируется пока поток не завершится
		#пример: 
		for (std::thread& th : threads)
		{
			if (th.joinable())
				th.join();
		}

void detach() --отказаться от контроля над потоком
id get_id() -- возвращает ID потока
native_handle_type native_handle() --возвращает платформенно-зависимый handle потока
static unsigned hardware_concurrency() --возвращает количество аппаратных потоков
		пример: int count = std::thread::hardware_concurrency();
		
##this_thread
thread::id get_id() --возвращает ID вызывающего потока
		#пример: 	
		void foo(){
		std::thread::id this_id = std::this_thread::get_id();
 		std::osyncstream(std::cout) << "thread " << this_id << " sleeping...\n"; --вывод в потоко без гонок за данными
 		std::this_thread::sleep_for(500ms);
		}
		int main()
		{
		std::jthread t1{foo};
		std::jthread t2{foo};
		}
void yield()  --уступает процессорное время другим потокам
void sleep_until(const time_point&) --блокирует вызывающий поток до определѐнного времени
		#пример:
		"#include <chrono> #include <iostream> #include <thread>"		
		auto now() { return std::chrono::steady_clock::now(); }
		auto awake_time(){
		using std::chrono::operator""ms;
		return now() + 2000ms;
		}
		int main(){
		std::cout << "Hello, waiter...\n" << std::flush;
		const auto start{now()};
		std::this_thread::sleep_until(awake_time());
		std::chrono::duration<double, std::milli> elapsed{now() - start};
		std::cout << "Waited " << elapsed.count() << " ms\n";
		}
void sleep_for(const duration&) --блокирует вызывающий поток на определѐнное время
		#пример: 
		std::this_thread::sleep_for(500ms);
		std::this_thread::sleep_for(std::chrono::seconds(2));
		#подсчет времени выполнения:
		start = std::chrono::steady_clock::now();
		std::thread t1(&Queue::add_count, &q);
		end = std::chrono::steady_clock::now();
		std::chrono::duration<double> el = end - start;
##std::mutex (https://radioprog.ru/post/1404) не является ни копируемым, ни перемещаемым.
для защиты от гонки данных
void swap_lock(Data& x, Data& y) {
	if (&x == &y) // проверка, объекты не идентичны
		return;
	lock(x.mt,y.mt);
	std::swap(x.a, y.a);
	x.mt.unlock();
	y.mt.unlock();
	}
небезопасно,т.к  может не освободится мьютекс в случае ошибки, исключения. Необходимо использовать
std::lock_guard или std::unique_lock
		
##std::conditional_variable (https://radioprog.ru/post/1410)
	condition_variable - это примитив синхронизации, который работает поверх std::mutex 
	(если быть точным - то используется напрямую std::unique_lock, который уже работает поверхstd::mutex)
	#пример:
	"#include <iostream> #include <vector> #include <thread>"
	std::vector<int> data;
	std::condition_variable data_cond;
	std::mutex m;
	void thread_func1(){
   std::unique_lock<std::mutex> lock(m);
   data.push_back(10);
   data_cond.notify_one();
	}
 
	void thread_func2(){
   std::unique_lock<std::mutex> lock(m);
   data_cond.wait(lock, [] {
      return !data.empty();
   });
   std::cout << data.back() << std::endl;
	}
 
	int main(){
   std::thread th1(thread_func1);
   std::thread th2(thread_func2);
   th1.join();
   th2.join();
	}
##lock_guard
Это пример RAII. Мы получаем по ссылке шаблон, у которого 
есть методы lock и unlock. После выхода из области видимости уничтожается.
Можно передать аргумент std::adopt_lock – индикатор, означающий, что mutex уже заблокирован, и блокировать 
его заново не надо. std::lock_guard не содержит никаких других методов, и его нельзя копировать, переносить 
или присваивать.ожно передать аргумент std::adopt_lock – индикатор, означающий, что mutex уже заблокирован, 
и блокировать его заново не надо. 
std::lock_guard не содержит никаких других методов, и его нельзя копировать, переносить или присваивать.
	#пример:
	void swap_lock(Data& x, Data& y) {
	if (&x == &y) // проверка, объекты не идентичны
		return;
	lock(x.mt,y.mt);
	std::lock_guard lock1{ x.mt, std::adopt_lock };
	std::lock_guard lock2{ y.mt, std::adopt_lock };
	std::swap(x.a, y.a);
	}
	или 
	void swap_lock(Data& x, Data& y) {
	if (&x == &y) // проверка, объекты не идентичны
		return;
	std::lock_guard lock1{ x.mt}; //сам блокирует мьютекс
	std::lock_guard lock2{ y.mt};
	std::swap(x.a, y.a);
	}
##std::unique_lock
Класс unique_lock – это универсальная оболочка владения мьютексом, предоставляющая отсроченную блокировку, 
ограниченные по времени попытки блокировки, рекурсивную блокировку, передачу владения блокировкой и 
использование с condition variables.
Класс std::unique_lock обеспечивает немного более гибкий подход, по сравнению с std::lock_guard: экземпляр 
std::unique_lock не всегда владеет связанным с ним мьютексом. Конструктору в качестве второго аргумента можно 
передавать не только объект std::adopt_lock, заставляющий объект блокировки управлять блокировкой мьютекса, 
но и объект отсрочки блокировки std::defer_lock, показывающий, что мьютекс при конструировании должен оставаться разблокированным. 
Блокировку можно установить позже, вызвав функцию lock() для объекта std::unique_lock (но не мьютекса) или же передав объект std::unique_lock функции std::lock().
std::unique_lock занимает немного больше памяти и работает несколько медленнее по сравнению с std::lock_guard. 
За гибкость, заключающуюся в разрешении экземпляру std::unique_lock не владеть мьютексом, приходится расплачиваться тем, 
что информация о состоянии должна храниться, обновляться и проверяться: если экземпляр действительно владеет мьютексом, 
деструктор должен вызвать функцию unlock(), в ином случае – не должен. Этот флаг можно запросить, вызвав метод owns_lock(). 
Если передача владения блокировкой или какие-то другие действия, требующие std::unique_lock, не предусматриваются, лучше воспользоваться классом std::scoped_lock из C++17
##std::shared_mutex (https://radioprog.ru/post/1407)
Класс shared_mutex – это примитив синхронизации, который может использоваться для защиты общих данных от одновременного доступа 
нескольких потоков. В отличие от других типов мьютексов, которые обеспечивают эксклюзивный доступ, shared_mutex имеет два уровня доступа:
общий доступ – несколько потоков могут совместно владеть одним и тем же мьютексом;
эксклюзивный доступ (исключительная блокировка) – только один поток может владеть мьютексом.
Если один поток получил эксклюзивный доступ (через lock, try_lock), то никакие другие потоки не могут получить блокировку (включая общую).
Если один поток получил общую блокировку (через lock_shared, try_lock_shared), ни один другой поток не может получить эксклюзивную блокировку, 
но может получить общую блокировку.
Только если исключительная блокировка не была получена ни одним потоком, общая блокировка может быть получена несколькими потоками.
В пределах одного потока одновременно может быть получена только одна блокировка (общая или эксклюзивная).
shared_mutex особенно полезны, когда общие данные могут быть безопасно считаны любым количеством потоков одновременно, но поток может перезаписывать 
данные только тогда, когда ни один другой поток не читает и не записывает в это время.
##promise-future std::async
https://radioprog.ru/post/1413

	"#include <iostream> #include <ctime> #include <iomanip> #include <future> #include <thread> #include <Windows.h> #include <random>"
using namespace std;
void Sort2(int* arr, int size, int i, std::promise<int> prom) // сортировка выбором
{
    int min = i;
    for (int j = i + 1; j < size; ++j) {
        if (arr[min] > arr[j]) {
            min = j;
        }   
    }

    prom.set_value(min);
}

int main()
{
    
    srand(time(NULL)); //для создания ряда псевдослучайных целых чисел
    setlocale(LC_ALL, "rus");
    cout << "Введите размер массива: ";
    int size; // размер массива
    cin >> size;

    int* arr = new int[size]; // одномерный динамический массив
    for (int counter = 0; counter < size; counter++)
    {
        arr[counter] = rand() % 100; // заполняем массив случайными числами
        cout << setw(2) << arr[counter] << "  "; // вывод массива на экран
    }
    cout << "\n\n";

    int min{};
    for (int i = 0; i < size; ++i) {
            std::promise<int> prom;
            std::future<int> ft_res = prom.get_future();
            auto ft = std::async(Sort2, arr, size, i, std::move(prom));
            min = ft_res.get();
            if (i != min)
            {
                swap(arr[i], arr[min]);
            }    
    }
    
    for (int n = 0; n < size; n++)
    {
        std::cout << arr[n] << " ";
    }

    //for (int i = 0; i < size; ++i) {
    //std::packaged_task<int(int*, int, int)> task(Sort);
    //std::future<int> ft = task.get_future();
    //std::thread th(std::move(task), arr, size, 2);
    //th.join();
    
    std::cout << "\n";
    delete[] arr; // высвобождаем память
    return 0;
}


	
