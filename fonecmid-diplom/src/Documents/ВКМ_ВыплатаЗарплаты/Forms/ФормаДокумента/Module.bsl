#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Выплаты.Очистить();

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник Как Сотрудник,
		|	ВКМ_ВзаиморасчетыССотрудникамиОстатки.СуммаОстаток Как СуммаОстаток
		|ИЗ
		|	РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(&Дата,) КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки";
	
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Объект.Выплаты.Добавить();
		НоваяСтрока.Сотрудник = Выборка.Сотрудник;
		НоваяСтрока.Сумма = Выборка.СуммаОстаток;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти