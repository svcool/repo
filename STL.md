//for_each c лямдо функцией
for_each(cont.begin(), cont.end(), [](auto a) {std::cout << a << " "; });
//[] переопределение квадр. скобок
T& operator [] (int index) {
		if (index<0 || index >= logic_size) {
			std::cout << "\nIndex is out of range" << std::endl;
			exit(1);
		}
		return arr[index]; 
	}
//[][] переопределение квадр. скобок
T* operator [] (unsigned i) {
		return arr[i];
	}

//переопределение оператора <<
	friend std::ostream& operator << (std::ostream& stream, const arrTable& arr) {
		stream << arr[row][col];
		return stream;
	}

//переопределение оператора <<
	friend std::ostream& operator << (std::ostream& stream, const arrTable& arr) {
		stream << arr[row][col];
		return stream;
	}



//ввод значений  в вектор, пока что-то вводится
std::cout << "[IN]: \n";
	while (std::cin >> a) {
		s.insert(a);
	}

//
//вектор из map
	std::vector<std::pair<char, int>> vec(m.begin(), m.end());
	//сортировка
	std::sort(vec.begin(), vec.end(), [](const std::pair< char, int >& i1, const std::pair< char, int >& i2) {
		return i1.second > i2.second; 
		}
	);
// вывод map из вектора
	std::cout << "\n[OUT]: \n";
	for (auto i : vec) {
		std::cout << i.first << ": " << i.second << "\n";
	}
	return 0;

////по возрастанию
	//for (auto it = s.begin(); it != s.end(); ++it) {
	//	std::cout << *it << "\n";
	//}
	////по убыванию
	//for (std::set<int>::reverse_iterator it = s.rbegin(); it != s.rend(); ++it) {
	//	std::cout << *it << "\n";
	//}

	//по убыванию
	for_each(s.rbegin(), s.rend(), [](int a) {std::cout << a << "\n"; });



//std::set<int, std::greater<int>> s; сортирует по возрастанию сразу

//формирование двумерного массива и удаление в деструкторе
arrTable(unsigned row_, unsigned col_) : row(row_), col(col_) {
		arr = new T * [row];
		for (unsigned i= 0; i < row; i++) {
			arr[i] = new T[col]{0};
		}
	}
~arrTable() {
	for (unsigned i = 0; i < row; i++) {
		delete[] arr[i];
		
	}
	delete[] arr;
	arr = nullptr;
	}