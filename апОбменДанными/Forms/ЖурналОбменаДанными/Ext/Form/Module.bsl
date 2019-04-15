﻿
#Область ГлобальныеПеременные

&НаКлиенте
Перем гМодульК;  // общий клиентский модуль

// ГлобальныеПеременные
#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.КонтекстФормыИнициализировать(СтррКонтекст, Параметры);
	
	ВосстановитьНастройкиСервер();
	
	Период.Вариант 		 = ВариантСтандартногоПериода.ПроизвольныйПериод;
	Период.ДатаНачала 	 = НачалоДня(ТекущаяДата());
	Период.ДатаОкончания = ТекущаяДата();
	
	ОбновитьДеревоЖурнала();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ГруппаКоманднаяПанель.ЦветФона = СтррКонтекст.Цвета.ФонРаздела;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "АПНастройкиСброшены" Тогда
		
		Закрыть();
		
	ИначеЕсли ИмяСобытия = "АППроверкаУникальностиЗапускаОбработкиОбмена" Тогда
		
		Если Параметр <> СтррКонтекст.ВХОбщиеПараметры Тогда // второй экземпляр обработки справшивает - уже открыта обработка или нет
			Оповестить("АПЗакрытьОбработкуОбменДанными", Параметр); // шлем событие закрытия обработки с конкретным ключем сеанса
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

// ОбработчикиСобытийФормы
#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьЖурнал(Команда)
	
	ВосстановитьНастройкиСервер();
	ОбновитьДеревоЖурнала();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаРазвернуть(Команда)
	
	Для Каждого СтрокаД Из Журнал.ПолучитьЭлементы() Цикл 
		Элементы.Журнал.Развернуть(СтрокаД.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСвернуть(Команда)
	
	Для Каждого СтрокаД Из Журнал.ПолучитьЭлементы() Цикл 
		Элементы.Журнал.Свернуть(СтрокаД.ПолучитьИдентификатор());
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнить(Команда)
	
	МодульК().КомандаВыполнить(Команда, ЭтотОбъект)
	
КонецПроцедуры

// ОбработчикиКомандФормы
#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбАгентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	стррПараметры = Новый Структура("ПараметрыВыбора", Новый Структура("Сотрудник", Объект.ВыбАгент));
	Оповещение = Новый ОписаниеОповещения("ВыбАгентВыборЗавершение", ЭтотОбъект);
	МодульК().ОткрытьФормуОбработки("ВыборАгента", стррПараметры, ЭтаФорма.КлючУникальности, Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ВыбАгентВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("СправочникСсылка.Сотрудники") Тогда
		Объект.ВыбАгент = Результат;	
		ОбновитьДеревоЖурнала();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбАгентПриИзменении(Элемент)
	
	ОбновитьДеревоЖурнала();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ОбновитьДеревоЖурнала();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	СтрокаД = Элементы.Журнал.ТекущиеДанные;
	Если СтрокаД <> Неопределено И ЗначениеЗаполнено(СтрокаД.Документ) И Элемент.ТекущийЭлемент.Имя = "ЖурналДокумент" Тогда 
		ПоказатьЗначение(Неопределено, СтрокаД.Документ); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаД = Элементы.Журнал.ТекущиеДанные;
	Если СтрокаД = Неопределено Тогда
		Возврат;
	ИначеЕсли Элемент.ТекущийЭлемент.Имя = "ЖурналПредставление" Тогда
		Если ЗначениеЗаполнено(СтрокаД.Представление) И ЗначениеЗаполнено(СтрокаД.Сотрудник) Тогда
			МодульК().КомандаВыполнить("ПоказатьНастройкиАгентов");
			Оповестить("АПНастройкиАгентов_Оповещение", Новый Структура("Сотрудник", СтрокаД.Сотрудник));
		КонецЕсли; 
	ИначеЕсли ТипЗнч(СтрокаД.Документ) = Тип("Строка") Тогда // нужно показать виртуальный документ
		МодульК().ВООткрытьФорму(СтрокаД.ВидДокумента, СтрокаД.СсылкаМУ);
	Иначе
		ПоказатьЗначение(Неопределено, СтрокаД.Документ); 
	КонецЕсли; 

КонецПроцедуры

// ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область СлужебныеПроцедурыИФункции_Прочие

&НаКлиенте
Функция МодульК()

	Если гМодульК = Неопределено Тогда
	    гМодульК = ПолучитьФорму(СтррКонтекст.ПутьКФорме + "МодульОбщий", СтррКонтекст);
	КонецЕсли; 
	
	Возврат гМодульК;

КонецФункции 

// СлужебныеПроцедурыИФункции_Прочие
#КонецОбласти 

#Область СлужебныеПроцедурыИФункции_ХранилищеНастроек

// #МУ#
&НаСервере
Процедура ВосстановитьНастройкиСервер(Реквизиты = "")

	Если Реквизиты = "" Тогда
		Реквизиты = "НастройкиАгентов,МобильныеУстройства";
	КонецЕсли;
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ВосстановитьЗначенияНастроекОбработки(Реквизиты);
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
	Объект.НастройкиАгентов.Сортировать("Сотрудник");

КонецПроцедуры

// СлужебныеПроцедурыИФункции_ХранилищеНастроек
#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Подтверждения

// Функция возвращает вид документа в МТ (его строковое представление).
// Параметры:
// 		ТекОбъект 	- Объект - объект обработки (результат функции РеквизитФормыВЗначение("Объект"))
// 		ИдВидДокументаМТ - УникальныйИдентификатор - идентификатор вида документа в МТ (GUID)
// 		Кэш 		- Соответствие - кэш для ускорения получения результата
// Возвращаемое значение:
//  	Строка  -  строковое представление вида документа в МТ.
//  	
&НаСервере
Функция ВидДокументаВМТ(ТекОбъект, ИдВидДокументаМТ, Кэш) // gi_170902

	Если Кэш = Неопределено Тогда
		Кэш = Новый Соответствие;
	КонецЕсли;
	
	Результат = Кэш.Получить(ИдВидДокументаМТ);
	Если Результат = Неопределено Тогда
		Результат = ТекОбъект.ВидОбъектаПоИдентификатору(ИдВидДокументаМТ, Ложь, "Документ");
		Кэш.Вставить(ИдВидДокументаМТ, Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
	
&НаСервере
Процедура ОбновитьДеревоЖурнала()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	
	Дерево = ДанныеФормыВЗначение(Журнал, Тип("ДеревоЗначений"));
	Дерево.Строки.Очистить();
	
	КэшВидовДокументов = Неопределено;

	Если ЗначениеЗаполнено(Объект.ВыбАгент) Тогда
		мАгенты = Объект.НастройкиАгентов.НайтиСтроки(Новый Структура("Сотрудник", Объект.ВыбАгент));
		Если мАгенты.Количество() <> 0 Тогда
			ВывестиПодтверждения(мАгенты[0], ТекОбъект, Дерево, КэшВидовДокументов);
		КонецЕсли;
	Иначе
		Для Каждого Агент Из Объект.НастройкиАгентов Цикл
			ВывестиПодтверждения(Агент, ТекОбъект, Дерево, КэшВидовДокументов);
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, "Журнал");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоПустойИдентификатор(ИД)

	Возврат (ПустаяСтрока(ИД) Или СокрЛП(ИД) = "00000000-0000-0000-0000-000000000000");

КонецФункции

&НаСервере
Процедура ВывестиПодтверждения(Агент, ТекОбъект, Дерево, КэшВидовДокументов)
	
	Если ЭтоПустойИдентификатор(Агент.СсылкаМУ) Тогда
		Возврат;
	КонецЕсли;
	
	мМУ = Объект.МобильныеУстройства.НайтиСтроки(Новый Структура("ID", Агент.СсылкаМУ));
	ПредставлениеМУ = ?(мМУ.Количество() = 0, "?", мМУ[0].Наименование);
	
	ДатаНачала 		= Период.ДатаНачала;
	ДатаОкончания 	= Период.ДатаОкончания;
	
	Если ДатаОкончания = '00010101' Тогда
		ДатаОкончания = КонецГода(ДобавитьМесяц(ТекущаяДата(), 36));
	КонецЕсли;
	
	ТЗ = ТекОбъект.СДОткрытьПодтвержденияДокументов(Агент.СсылкаМУ, Истина);
	Если ТЗ.Количество() > 0 Тогда
		
		//ТЗ.Сортировать("Дата Убыв, ДатаДокумента Убыв");
		
		ВеткаД = Дерево.Строки.Добавить();
		ВеткаД.Сотрудник  = Агент.Сотрудник;
		ВеткаД.Представление = ПредставлениеМУ + " (" + Строка(Агент.Сотрудник) + ")";
		СтрокиВетки = ВеткаД.Строки;
		
		Для Каждого СтрокаТ Из ТЗ Цикл
			
			Дата = СтрокаТ.Дата;
			Если Дата < ДатаНачала Или Дата > ДатаОкончания Тогда
				Продолжить;
			КонецЕсли;
			
			ВидДокументаВМТ = ВидДокументаВМТ(ТекОбъект, СтрокаТ.ИдВидДокументаМТ, КэшВидовДокументов);
			
			СтрокаД 	 		= СтрокиВетки.Добавить();
			СтрокаД.Дата 		= Дата;
			СтрокаД.СсылкаМУ	= Новый УникальныйИдентификатор(СтрокаТ.Идентификатор);
			СтрокаД.ВидДокумента 			  = СтрокаТ.ВидДокумента;
			СтрокаД.ВидДокументаПредставление = СтрокаТ.ВидДокумента + " (" + ВидДокументаВМТ + ")";
			
			ДатаДокументаВМУ = Дата;
			Если ТекОбъект.ВДокЭтоВиртуальныйДокумент(СтрокаТ.ВидДокумента) Тогда
				Если СтрокаТ.ДатаДокумента <> '00010101' Тогда
					ДатаДокументаВМУ = СтрокаТ.ДатаДокумента;
				КонецЕсли;
			    СтрокаД.Документ = ВидДокументаВМТ + " от " + Формат(ДатаДокументаВМУ, "ДЛФ=Д");
			Иначе				
				СтрокаД.Документ = Документы[СтрокаТ.ВидДокумента].ПолучитьСсылку(СтрокаД.СсылкаМУ);
			КонецЕсли;
			
			СтрокаД.Сотрудник  	  = Агент.Сотрудник;
			СтрокаД.ДатаДокумента = ДатаДокументаВМУ;
			
		КонецЦикла;
		
		Дерево.Строки.Сортировать("Дата Убыв, ДатаДокумента Убыв, Документ Убыв", Истина);
		
	КонецЕсли;
	
		
КонецПроцедуры


// СлужебныеПроцедурыИФункции_Подтверждения
#КонецОбласти

// СлужебныеПроцедурыИФункции
#КонецОбласти