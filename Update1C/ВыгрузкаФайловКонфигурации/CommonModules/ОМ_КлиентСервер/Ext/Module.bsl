﻿
Функция ФорматЧисла(Число, Знач ФорматнаяСтрока = "") Экспорт
	
	ФорматПоУмолчанию = "ЧН=0; ЧГ=0";
	
	Если ЗначениеЗаполнено(ФорматПоУмолчанию) Тогда
		ФорматПоУмолчанию = ФорматнаяСтрока;	
	КонецЕсли;
	
	Возврат Формат(Число, ФорматПоУмолчанию);
	
КонецФункции

&НаКлиенте
Процедура ПерейтиПоГиперСсылке(ГиперСсылка, СтандартнаяОбработка = Неопределено) Экспорт

	Если ЗначениеЗаполнено(ГиперСсылка) Тогда
		
		Если СтандартнаяОбработка <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		
		НачатьЗапускПриложения(Новый ОписаниеОповещения("ПерейтиПоГиперСсылкеЗавершение", ЭтотОбъект), "https://" + ОМ_Сервер.ПолучитьКонстанту("Обновления1С_СерверИТС") + ГиперСсылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиПоГиперСсылкеЗавершение(КодВозврата, ДополнительныеПараметры) Экспорт
КонецПроцедуры

Функция ОбернутьВКавычки(Знач Строка) Экспорт
	
	Возврат """" + Строка + """";
	
КонецФункции

// Пример
//СоответствиеПодключаемыхОбработчиков 	= Новый Соответствие;
//
//СоответствиеПодключаемыхОбработчиков.Вставить("ПослеУдаления", 		 				"Подключаемый_ПослеУдаления");
//СоответствиеПодключаемыхОбработчиков.Вставить("ПриАктивизацииСтроки", 		 		"Подключаемый_ПриАктивизацииСтрокиТаблицы");
//СоответствиеПодключаемыхОбработчиков.Вставить("ПередОкончаниемРедактирования", 		"Подключаемый_ПередОкончаниемРедактированияТаблицы");
&НаСервере
Процедура НарисоватьТаблицуЗначений(Форма, ИмяТаблицы, Знач ТаблицаЗначений, Родитель, СоответствиеПодключаемыхОбработчиков = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЕстьРеквизитФормы = ЕстьРеквизитФормы(Форма, ИмяТаблицы);
	
	Если Не ЕстьРеквизитФормы Тогда
		
		ВызватьИсключение("На форме нет реквизита формы " + ОбернутьВКавычки(ИмяТаблицы));
		
	Иначе
		
		Если Форма.Элементы.Найти(ИмяТаблицы) <> Неопределено Тогда
			
			ВызватьИсключение("На форме уже нарисована таблица " + ОбернутьВКавычки(ИмяТаблицы));	
			
		КонецЕсли;
		
		ТаблицаЗначений = Форма.РеквизитФормыВЗначение(ИмяТаблицы);
		
	КонецЕсли;
	
	Элемент_НоваяТаблица					= Форма.Элементы.Добавить(ИмяТаблицы, Тип("ТаблицаФормы"), Родитель);
	Элемент_НоваяТаблица.ПутьКДанным		= ИмяТаблицы;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		Для Каждого Свойство Из ДополнительныеПараметры Цикл
			
			Если Не СтрНачинаетсяС(Свойство.Ключ, "Колонка_") Тогда
				
				Попытка
					Элемент_НоваяТаблица[Свойство.Ключ] = Свойство.Значение;
				Исключение
					// Данного свойства нет	
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;	
	
	Если СоответствиеПодключаемыхОбработчиков <> Неопределено Тогда
		
		Для Каждого Обработчик Из СоответствиеПодключаемыхОбработчиков Цикл
			
			Если Не СтрНачинаетсяС(Обработчик.Ключ, "Колонка_") Тогда
				Элемент_НоваяТаблица.УстановитьДействие(Обработчик.Ключ, Обработчик.Значение);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		
		НарисоватьЭлементФормы(Форма, Колонка.Имя, Колонка, Элемент_НоваяТаблица, СоответствиеПодключаемыхОбработчиков, ДополнительныеПараметры);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НарисоватьЭлементФормы(Форма, ИмяЭлемента, Значение, Родитель, СоответствиеПодключаемыхОбработчиков = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОписаниеРеквизита					= ПолучитьОписаниеЭлемента(Значение, ИмяЭлемента);
	
	Если ОписаниеРеквизита.Свойство("ЭтоКолонка") Тогда
		
		Если ОписаниеРеквизита.Свойство("ЭтоКонстанта") Тогда 
			ИмяТаблицы = ИмяНабораКонстантПоУмолчанию();
		Иначе
			ИмяТаблицы = Родитель.Имя;
		КонецЕсли;
		
		НовыйЭлемент						= Форма.Элементы.Добавить(ИмяТаблицы + "_" + ИмяЭлемента, ОписаниеРеквизита.ТипФормы, Родитель);
		
		// Если тут ошибка по константе - нужно посавить на форме галку "Использовать всегда"
		НовыйЭлемент.ПутьКДанным			= ИмяТаблицы + "." + ИмяЭлемента;
		
	Иначе
				
		НовыйЭлемент						= Форма.Элементы.Добавить(ИмяЭлемента, ОписаниеРеквизита.ТипФормы, Родитель);
		НовыйЭлемент.ПутьКДанным			= ИмяЭлемента;
		
	КонецЕсли;
		
	НовыйЭлемент.Вид						= ОписаниеРеквизита.ВидПоляФормы;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		Для Каждого Свойство Из ДополнительныеПараметры Цикл
			
			Если СтрНачинаетсяС(Свойство.Ключ, "Колонка_") 
				И СтрЗаканчиваетсяНа(Свойство.Ключ, ИмяЭлемента) Тогда
				
				Для Каждого СвойствоКолонки Из Свойство.Значение Цикл
					
					Попытка
						НовыйЭлемент[СвойствоКолонки.Ключ] = СвойствоКолонки.Значение;
					Исключение
					// Данного свойства нет	
					КонецПопытки;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если СоответствиеПодключаемыхОбработчиков <> Неопределено Тогда
		
		Если ОписаниеРеквизита.Свойство("ЭтоКолонка") Тогда
			
			Для Каждого Обработчик Из СоответствиеПодключаемыхОбработчиков Цикл
				
				Если СтрНачинаетсяС(Обработчик.Ключ, "Колонка_") Тогда
					
					Для Каждого ОбработчикКолонки Из Обработчик.Значение Цикл
						
						НовыйЭлемент.УстановитьДействие(ОбработчикКолонки.Ключ, ОбработчикКолонки.Значение);
						
					КонецЦикла;
					
				ИначеЕсли ОписаниеРеквизита.Свойство("ЭтоКонстанта") Тогда
					
					НовыйЭлемент.УстановитьДействие(Обработчик.Ключ, Обработчик.Значение);
							
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			
			Для Каждого Обработчик Из СоответствиеПодключаемыхОбработчиков Цикл
				НовыйЭлемент.УстановитьДействие(Обработчик.Ключ, Обработчик.Значение);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОписаниеЭлемента(Значение, ИмяДоп = "") Экспорт
	
	ОписаниеКолонки = Новый Структура;
	
	Если ТипЗнч(Значение) = Тип("КолонкаТаблицыЗначений") 
		Или ТипЗнч(Значение) = Тип("КолонкаДереваЗначений") Тогда
		
		СраниваемыйТип = Значение.ТипЗначения;
		
		ОписаниеКолонки.Вставить("ЭтоКолонка",  Истина);
		
	ИначеЕсли ТипЗнч(Значение) = Тип("КонстантыНабор") Тогда
		
		СраниваемыйТип = ТипЗнч(Значение[ИмяДоп]);
		
		ОписаниеКолонки.Вставить("ЭтоКолонка",  Истина);
		ОписаниеКолонки.Вставить("ЭтоКонстанта",  Истина);
		
	Иначе
		
		СраниваемыйТип = ТипЗнч(Значение);
		
	КонецЕсли;
	
	ОписаниеКолонки.Вставить("ОписаниеТипов", 	СраниваемыйТип);
	ОписаниеКолонки.Вставить("ТипФормы", 		Тип("ПолеФормы"));
	
	Если СраниваемыйТип = ОМ_КлиентСервер.ОписаниеТипаБулево() Тогда
		
		ОписаниеКолонки.Вставить("ВидПоляФормы", ВидПоляФормы.ПолеФлажка);
		
	ИначеЕсли СраниваемыйТип = ОМ_КлиентСервер.ОписаниеТипаКартинка() Тогда
		
		ОписаниеКолонки.Вставить("ВидПоляФормы", ВидПоляФормы.ПолеКартинки);
		
	Иначе
		
		ОписаниеКолонки.Вставить("ВидПоляФормы", ВидПоляФормы.ПолеВвода);
		
	КонецЕсли;
	
	Возврат ОписаниеКолонки;
	
КонецФункции

Функция ПолучитьМеткуВремениСтрокой() Экспорт

	Возврат Формат(ТекущаяДата(), "ДФ=ддММгггг_ЧЧммсс") + "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	
КонецФункции

Функция ИмяНабораКонстантПоУмолчанию() Экспорт
	
	Возврат "КонстантыНабор";
	
КонецФункции

&НаСервере
Функция ДействиеСНаборомКонстант(Форма, Действие) Экспорт
	
	ОМ_Обновления1С.ОбновитьОтборПоДате();
	
	ИмяНабораКонстантПоУмолчанию = ИмяНабораКонстантПоУмолчанию();
	
	Если Действие = "Записать" Тогда
		
		ДоступныеНастройки = ОМ_Парсинг.Получить_ДоступныеНастройки();
		
		Для Каждого Константа Из ДоступныеНастройки Цикл
			
			Попытка
				Константы[Константа].Установить(Форма[ИмяНабораКонстантПоУмолчанию][Константа]);
			Исключение
			КонецПопытки;
			
		КонецЦикла; 
		
	ИначеЕсли Действие = "Загрузить" Тогда

		НаборКонстант = Константы.СоздатьНабор();
		
		ОМ_Прокси.Получить_ЗначениеЗадержки();
		
		НаборКонстант.Прочитать();
		
		Форма.ЗначениеВРеквизитФормы(НаборКонстант, ИмяНабораКонстантПоУмолчанию);
		
		Возврат НаборКонстант;
		
	Иначе
		ВызватьИсключение("Обработчик для действия " + ОбернутьВКавычки(Действие) + " не прописан");
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПодключитьНаборКонстант(Форма, Родитель) Экспорт
	
	ИмяНабораКонстантПоУмолчанию = ИмяНабораКонстантПоУмолчанию();
	
	Если Не ЕстьРеквизитФормы(Форма, ИмяНабораКонстантПоУмолчанию) Тогда
		
		ВызватьИсключение("На форме нет реквизита формы " + ОбернутьВКавычки(ИмяНабораКонстантПоУмолчанию));
		
	КонецЕсли;
	
	НаборКонстант = ДействиеСНаборомКонстант(Форма, "Загрузить");
	
	ДоступныеНастройки = ОМ_Парсинг.Получить_ДоступныеНастройки();
	
	Соответствие = Новый Соответствие;
	
	Соответствие.Вставить("ПриИзменении", "Подключаемый_КонстантаПриИзменении");
	
	Для Каждого Константа Из ДоступныеНастройки Цикл
		
		НарисоватьЭлементФормы(Форма, Константа, НаборКонстант, Родитель, Соответствие);
			
	КонецЦикла;
		
КонецПроцедуры
	
&НаСервере
Функция ЕстьРеквизитФормы(Форма, Знач ИмяРеквизита, Знач Путь = "")
	 
	 Если ЗначениеЗаполнено(Путь) Тогда
		 МассивРеквизитов = Форма[Путь].ПолучитьРеквизиты();
	 Иначе
		 МассивРеквизитов = Форма.ПолучитьРеквизиты();
	 КонецЕсли;
	 
	 МассивИмен = ОМ_Сервер.ВыгрузитьКолонку(МассивРеквизитов, "Имя", Истина);
	 
	 Если МассивИмен.Найти(ИмяРеквизита) = Неопределено Тогда
		 Возврат Ложь;
	 Иначе
		 Возврат Истина;
	 КонецЕсли;
	 
 КонецФункции
 
&НаСервере
Процедура НовыйРеквизитФормы_ТаблицаЗначений(Форма, ИмяРеквизита, ТаблицаЗначений) Экспорт
	
	ЕстьРеквизитФормы = Ложь;
	
	Если ТаблицаЗначений = Неопределено Тогда
		ВызватьИсключение("Таблица " + ОМ_КлиентСервер.ОбернутьВКавычки(ИмяРеквизита) + " = Неопределено");
	КонецЕсли;
	
	Для Каждого ОписаниеРеквизита Из Форма.ПолучитьРеквизиты() Цикл
		
		Если ОписаниеРеквизита.Имя = ИмяРеквизита Тогда
			ЕстьРеквизитФормы = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ЕстьРеквизитФормы Тогда
		
		НоваяТЧ = Новый РеквизитФормы(ИмяРеквизита, Новый ОписаниеТипов("ТаблицаЗначений"));
		
		Массив  = Новый Массив;

		Массив.Добавить(НоваяТЧ);
		
		Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
						
			НовыйРеквизит = Новый РеквизитФормы(Колонка.Имя, Колонка.ТипЗначения, ИмяРеквизита);
			
			Массив.Добавить(НовыйРеквизит);
			
		КонецЦикла;
		
		Форма.ИзменитьРеквизиты(Массив);
			
	КонецЕсли;
	
	Форма.ЗначениеВРеквизитФормы(ТаблицаЗначений, ИмяРеквизита);
	
КонецПроцедуры

&НаСервере
Процедура СообщитьПользователю(Знач Текст, Знач КлючДанных = Неопределено, Знач Поле = "", Знач ПутьКДанным = "", ИдентификаторНазначения = Неопределено) Экспорт
	
	ОМ_Сервер.СообщитьПользователю(Текст, КлючДанных, Поле, ПутьКДанным, ИдентификаторНазначения);
	
КонецПроцедуры

Функция ПолучитьРусскийАлфавит(Массивом = Истина, ВерхнийРегистр = Истина) Экспорт
	
	Массив = Новый Массив;
	
	Массив.Добавить("А");
	Массив.Добавить("Б");
	Массив.Добавить("В");
	Массив.Добавить("Г");
	Массив.Добавить("Д");
	Массив.Добавить("Е");
	Массив.Добавить("Ё");
	Массив.Добавить("Ж");
	Массив.Добавить("З");
	Массив.Добавить("И");
	Массив.Добавить("Й");
	Массив.Добавить("К");
	Массив.Добавить("Л");
	Массив.Добавить("М");
	Массив.Добавить("Н");
	Массив.Добавить("О");
	Массив.Добавить("П");
	Массив.Добавить("Р");
	Массив.Добавить("С");
	Массив.Добавить("Т");
	Массив.Добавить("У");
	Массив.Добавить("Ф");
	Массив.Добавить("Х");
	Массив.Добавить("Ц");
	Массив.Добавить("Ч");
	Массив.Добавить("Ш");
	Массив.Добавить("Щ");
	Массив.Добавить("Ъ");
	Массив.Добавить("Ы");
	Массив.Добавить("Ь");
	Массив.Добавить("Э");
	Массив.Добавить("Ю");
	Массив.Добавить("Я");
	
	Если Массивом Тогда
		Возврат Массив;
	Иначе
		Результат = СтрСоединить(Массив);
		
		Если ВерхнийРегистр Тогда
			Возврат Результат;
		Иначе
			Возврат Нрег(Результат);
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

// Создает объект ОписаниеТипов, содержащий тип Строка.
//
// Параметры:
//  ДлинаСтроки - Число - длина строки.
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типа Строка.
//
Функция ОписаниеТипаСтрока(ДлинаСтроки) Экспорт
	
	Возврат Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ДлинаСтроки));
	
КонецФункции

// Создает объект ОписаниеТипов, содержащий тип Число.
//
// Параметры:
//  Разрядность - Число - общее количество разрядов числа (количество разрядов
//                        целой части плюс количество разрядов дробной части).
//  РазрядностьДробнойЧасти - Число - число разрядов дробной части.
//  ЗнакЧисла - ДопустимыйЗнак - допустимый знак числа.
//
// Возвращаемое значение:
//  ОписаниеТипов - описание типа Число.
//
Функция ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти = 0, Знач ЗнакЧисла = Неопределено) Экспорт
	
	Если ЗнакЧисла = Неопределено Тогда 
		ЗнакЧисла = ДопустимыйЗнак.Любой;
	КонецЕсли;
	
	Возврат Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла));
	
КонецФункции

Функция ОписаниеТипаДата(ЧастиДаты) Экспорт
	
	Возврат Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты));
	
КонецФункции

Функция ОписаниеТипаПроизвольный() Экспорт
	
	Возврат Новый ОписаниеТипов();
	
КонецФункции

Функция ОписаниеТипаБулево() Экспорт
	
	Возврат Новый ОписаниеТипов("Булево");
	
КонецФункции

Функция ОписаниеТипаКартинка() Экспорт
	
	Возврат Новый ОписаниеТипов("Картинка");
	
КонецФункции

Функция ОписаниеТипаУникальныйИдентификатор() Экспорт
	
	Возврат Новый ОписаниеТипов("УникальныйИдентификатор");
	
КонецФункции