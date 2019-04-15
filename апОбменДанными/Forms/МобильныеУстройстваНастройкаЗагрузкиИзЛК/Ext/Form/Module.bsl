﻿
#Область СовместимостьСПлатформой_8_3_5

// Подставляет параметры в строку. Максимально возможное число параметров - 5.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  - Строка - шаблон строки с параметрами (вхождениями вида "%ИмяПараметра");
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
&НаКлиентеНаСервереБезКонтекста
Функция СтрШаблон_(СтрокаПодстановки,
	Параметр1, Параметр2 = Неопределено, Параметр3 = Неопределено, Параметр4 = Неопределено, Параметр5 = Неопределено)
	
	Результат = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
	Результат = СтрЗаменить(Результат, "%2", Параметр2);
	Результат = СтрЗаменить(Результат, "%3", Параметр3);
	Результат = СтрЗаменить(Результат, "%4", Параметр4);
	Результат = СтрЗаменить(Результат, "%5", Параметр5);
	
	Возврат Результат;
	
КонецФункции
	
// Разбивает строку на несколько строк по разделителю. Разделитель может иметь любую длину.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//  Разделитель            - Строка - разделитель строк текста, минимум 1 символ;
//  ПропускатьПустыеСтроки - Булево - признак необходимости включения в результат пустых строк.
//    Если параметр не задан, то функция работает в режиме совместимости со своей предыдущей версией:
//     - для разделителя-пробела пустые строки не включаются в результат, для остальных разделителей пустые строки
//       включаются в результат.
//     Е если параметр Строка не содержит значащих символов или не содержит ни одного символа (пустая строка), то в
//       случае разделителя-пробела результатом функции будет массив, содержащий одно значение "" (пустая строка), а
//       при других разделителях результатом функции будет пустой массив.
//  СокращатьНепечатаемыеСимволы - Булево - сокращать непечатаемые символы по краям каждой из найденных подстрок.
//
// Возвращаемое значение:
//  Массив - массив строк.
&НаКлиентеНаСервереБезКонтекста 
Функция СтрРазделить_(Знач Строка, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, СокращатьНепечатаемыеСимволы = Ложь)
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Строка) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Строка) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Строка));
		Иначе
			Результат.Добавить(Строка);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

///  Объединяет строки из массива в строку с разделителями.
//
// Параметры:
//  Массив      - Массив - массив строк которые необходимо объединить в одну строку;
//  Разделитель - Строка - любой набор символов, который будет использован в качестве разделителя.
//
// Возвращаемое значение:
//  Строка - строка с разделителями.
// 
&НаКлиентеНаСервереБезКонтекста 
Функция СтрСоединить_(Массив, Разделитель = ",", СокращатьНепечатаемыеСимволы = Ложь)

	Результат = "";
	ТекРазделитель = "";
	
	Для Индекс = 0 По Массив.ВГраница() Цикл
		
		Подстрока = Массив[Индекс];
		
		Если СокращатьНепечатаемыеСимволы Тогда
			Подстрока = СокрЛП(Подстрока);
		КонецЕсли;
		
		Если ТипЗнч(Подстрока) <> Тип("Строка") Тогда
			Подстрока = Строка(Подстрока);
		КонецЕсли;
		
		Результат = Результат + ТекРазделитель + Подстрока;
		
		Если Индекс = 0 Тогда
			ТекРазделитель = Разделитель;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

// СовместимостьСПлатформой_8_3_5
#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтррКонтекст = Новый Структура("Значения");
	ТекОбъект = РеквизитФормыВЗначение("Объект");		
	ТекОбъект.КонтекстФормыИнициализировать(СтррКонтекст, Параметры);
	
	Если Не Параметры.Свойство("Значения") Тогда
		ВызватьИсключение(СтрШаблон_(НСтр("ru = 'Форма ""%1"" - отсутствует свойство Параметр.Значения.'; uk = 'Форма ""%1"" - відсутня властивість Параметр.Значения.'"),
										ЭтаФорма.Заголовок));
	КонецЕсли; 
	
	Список = Элементы.РежимПоискаПользователей.СписокВыбора;
	Список.Добавить("НеИскать", 				НСтр("ru='Не искать пользователей';uk='Не шукати користувачів'"));
	Список.Добавить("ИскатьПоТочномуЗначению", 	НСтр("ru='Искать по точному значению ""ЛК.Сотрудник""';uk='Шукати по точному значенням ""ЛК.Сотрудник""'"));	
	Список.Добавить("ИскатьПоВхождению", 		НСтр("ru='Искать по вхождению слов из ""ЛК.Сотрудник""';uk='Шукати по входженню слів з ""ЛК.Сотрудник""'"));
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.Значения);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДоступностьЭлементовПоиска();
КонецПроцедуры

// ОбработчикиСобытийФормы
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗаполнитьЗначенияСвойств(СтррКонтекст.Значения, ЭтотОбъект);
	Закрыть(СтррКонтекст.Значения);
	
КонецПроцедуры

// ОбработчикиКомандФормы
#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РежимПоискаПользователейОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаПользователейПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовПоиска();
КонецПроцедуры

// ОбработчикиСобытийЭлементовФормы
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДоступностьЭлементовПоиска()
	
	ДоступностьЭлементов = (РежимПоискаПользователей <> "НеИскать");
	Элементы.СоздаватьНовыхПользователей.Доступность = ДоступностьЭлементов;
	Элементы.ТолькоДляНовыхИОбновленныхМУ.Доступность = ДоступностьЭлементов;
	
КонецПроцедуры

// СлужебныеПроцедурыИФункции
#КонецОбласти