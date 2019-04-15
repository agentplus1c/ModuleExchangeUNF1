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
	
	Если Не Параметры.Свойство("ПараметрыВыбора") Тогда
		ВызватьИсключение(НСтр("ru='Ожидается свойство ""ПараметрыВыбора"".';uk='Очікується властивість ""ПараметрыВыбора"".'"));
	КонецЕсли;
	
	СтррКонтекст =  Параметры.ПараметрыВыбора;	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.КонтекстФормыИнициализировать(СтррКонтекст, Параметры);
	СтрСвойства = "Цвет";
	Если Не ТекОбъект.СтруктураЕстьСвойства(СтррКонтекст, СтрСвойства) Тогда
		ВызватьИсключение(НСтр("ru = 'У переданной структуры ""ПараметрыВыбора"" должны быть свойства: '; uk = 'У переданої структури ""ПараметрыВыбора"" повинні бути властивості: '") + СтрСвойства);
	КонецЕсли;
	
	ПредставлениеЦвета = Строка(СтррКонтекст.Цвет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ФормаПоУмолчанию.Видимость = СтррКонтекст.Свойство("ЦветПоУмолчанию");
	УстановитьЦветНаФормеИзСтроки(ПредставлениеЦвета);
	
КонецПроцедуры

// ОбработчикиСобытийФормы
#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	
	cтррРезультат = Новый Структура("Цвет,ПредставлениеЦвета", Новый Цвет(Красный, Зеленый, Синий), СокрЛП(ПредставлениеЦвета));
	Закрыть(cтррРезультат);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоУмолчанию(Команда)
	
	УстановитьЦветНаФормеИзСтроки(СтррКонтекст.ЦветПоУмолчанию, Истина);
	
КонецПроцедуры

// ОбработчикиКомандФормы
#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомпонентЦветаПриИзменении(Элемент)
	
	ИзменитьЦветНаФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеЦветаПриИзменении(Элемент)
	
	УстановитьЦветНаФормеИзСтроки(ПредставлениеЦвета, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеЦветаОчистка(Элемент, СтандартнаяОбработка)
	
	УстановитьЦветНаФормеИзСтроки("0,0,0", Ложь);
	
КонецПроцедуры

// ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьЦветНаФорме()

	НовыйЦвет = Новый Цвет(Красный, Зеленый, Синий);
	КЦвет = КонтрастныйЦвет(Красный, Зеленый, Синий);
	
	Элементы.ОбразецЦветаТекст.ЦветТекста  = НовыйЦвет;
	Элементы.ОбразецЦветаТекст.ЦветФона  	= КЦвет;
	
	Элементы.ОбразецЦветаФон.ЦветФона 		= НовыйЦвет;
	Элементы.ОбразецЦветаФон.ЦветТекста	= КЦвет;
	
	ПредставлениеЦвета = Строка(Красный) + "," + Строка(Зеленый) + "," + Строка(Синий);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Функция КонтрастныйЦвет(R, G, B)
	
	Яркость = 0.3 * R + 0.59 * G + 0.11 * B;
	Возврат ?(Яркость > 255 / 2, Новый Цвет (0,0,0), Новый Цвет (255,255,255));
	
КонецФункции

&НаКлиенте
Процедура УстановитьЦветНаФормеИзСтроки(СтрЦвет, ПриРучномИзменении = Ложь)
	
	СтрЗначение = СтрЗаменить(СокрЛП(СтрЦвет), ";", ","); // на случай, если указан в поле цвет в формате R;G;B

	Если СтрЧислоВхождений(СтрЗначение, ",") <> 2 Тогда // неверный формат значения в СтрЦвет
		Если ПриРучномИзменении Тогда
			ПредставлениеЦвета = Строка(Красный) + "," + Строка(Зеленый) + "," + Строка(Синий); // восстанавливаем прежний цвет	в поле ввода		
			Возврат;
		Иначе
			СтрЗначение = "0,0,0";
		КонецЕсли;
	КонецЕсли;
	
	мЦвета = СтрРазделить_(СтрЗначение, ",", Истина);
	
	Красный = СтрокуВЧислоЦвета(мЦвета[0]);
	Зеленый = СтрокуВЧислоЦвета(мЦвета[1]);
	Синий   = СтрокуВЧислоЦвета(мЦвета[2]);
	
	ИзменитьЦветНаФорме();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Функция СтрокуВЧислоЦвета(Строка)
	
	СтрДопустимыеСимволы = "0123456789";
	СтрРезультат = "";
	
	Для Поз = 1 По СтрДлина(Строка) Цикл
		Символ = Сред(Строка, Поз, 1);
		Если Найти(СтрДопустимыеСимволы, Символ) <> 0 Тогда
			СтрРезультат = СтрРезультат + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ?(СтрДлина(СтрРезультат) = 0, 0, Число(СтрРезультат) % 256);
	
КонецФункции

// СлужебныеПроцедурыИФункции
#КонецОбласти