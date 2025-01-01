
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Добавляет команду создать на основании 
//
//Параметры:
//  КомандыСозданияНаОсновании - массив.
//  
//Возвращаемое значение:
//	Неопределено
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

Процедура ПриОпределенииНастроекПечати(НастройкиОбъекта) Экспорт	
	НастройкиОбъекта.ПриДобавленииКомандПечати = Истина;
КонецПроцедуры

//Добавляет команду печати акта об оказанных услугах 
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Акт об оказанных услугах
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОбОказанныхУслугах";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оказанных услугах'");
	КомандаПечати.Порядок = 5;
	
КонецПроцедуры

//Сама печать документа
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОбОказанныхУслугах");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьАктОбОказанныхУслугах(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оказанных услугах'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОбОказанныхУслугах";
	КонецЕсли;
		
КонецПроцедуры

//Формирование акта об оказанных услугах
Функция ПечатьАктОбОказанныхУслугах(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ПФ_MXL_АктОбОказанныхУслугах");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Дата,
	|	РеализацияТоваровУслуг.Номер,
	|	РеализацияТоваровУслуг.Организация,
	|	РеализацияТоваровУслуг.Контрагент,
	|	РеализацияТоваровУслуг.Договор,
	|	РеализацияТоваровУслуг.СуммаДокумента,
	|	РеализацияТоваровУслуг.Товары.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Количество,
	|		Цена,
	|		Сумма),
	|	РеализацияТоваровУслуг.Услуги.(
	|		НомерСтроки,
	|		Номенклатура,
	|		Количество,
	|		Цена,
	|		Сумма)
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьДанныеТаблицы = Макет.ПолучитьОбласть("ДанныеТаблицы");
	ОбластьИтоги = Макет.ПолучитьОбласть("Итоги");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабДок.Очистить();
	
	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ОбластьЗаголовок.Параметры.Дата = Формат(Выборка.Дата, "ДФ=dd.MM.yyyy;");
		ОбластьЗаголовок.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(Выборка.Номер);
		ТабДок.Вывести(ОбластьЗаголовок);
		
		ОбластьШапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(ОбластьШапка);
		ТабДок.Вывести(ОбластьШапкаТаблицы);
		
		ВыборкаТовары = Выборка.Услуги.Выбрать();
		
		Пока ВыборкаТовары.Следующий() Цикл
			ОбластьДанныеТаблицы.Параметры.Заполнить(ВыборкаТовары);
			ТабДок.Вывести(ОбластьДанныеТаблицы);
		КонецЦикла;
		
		ОбластьИтоги.Параметры.СуммаИтого = Выборка.СуммаДокумента;
		ОбластьИтоги.Параметры.КоличествоСтрок = ВыборкаТовары.НомерСтроки;
		ОбластьИтоги.Параметры.ЧислоПрописью = ЧислоПрописью(Выборка.СуммаДокумента, "Л=ru_RU; ДП=Ложь","рубль, рубля, рублей, м, копейка, копейки, копеек, ж");
		ТабДок.Вывести(ОбластьИтоги);
		
		ТабДок.Вывести(ОбластьПодвал);
		
		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	
	Возврат ТабДок;
	
КонецФункции

#КонецОбласти

#КонецЕсли