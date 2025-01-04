#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Для Каждого ТекСтрока Из СписокСотрудников Цикл
		
		Движения.ВКМ_ДополнительныеНачисления.Записывать = Истина;
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.Премия;
		Движение.ПериодРегистрации = Дата;
		Движение.Сотрудник = ТекСтрока.Сотрудник;
		Движение.Сумма = ТекСтрока.СуммаПремии;
			
	КонецЦикла;

	СформироватьДвиженияУдержаний();
	СформироватьДвиженияРегистраВзаиморасчетыССотрудниками();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияУдержаний()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РегистраторРазрез КАК РегистраторРазрез,
	|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
	|	МАКСИМУМ(ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.СуммаБаза) КАК СуммаБаза,
	|	МАКСИМУМ(ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.БазовыйПериодНачало) КАК БазовыйПериодНачало,
	|	МАКСИМУМ(ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.БазовыйПериодКонец) КАК БазовыйПериодКонец
	|ИЗ
	|	РегистрРасчета.ВКМ_Удержания.БазаВКМ_ДополнительныеНачисления(&Измерения, &Измерения, &Разрезы,) КАК
	|		ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления
	|ГДЕ
	|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РегистраторРазрез = &РегистраторРазрез
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.РегистраторРазрез,
	|	ВКМ_УдержанияБазаВКМ_ДополнительныеНачисления.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник";
	
	Измерения = Новый Массив;
	Измерения.Добавить("Сотрудник");
	
	Разрезы = Новый Массив;
	Разрезы.Добавить("Регистратор");
	
	Запрос.УстановитьПараметр("Измерения", Измерения);
	Запрос.УстановитьПараметр("Разрезы", Разрезы);
	Запрос.УстановитьПараметр("РегистраторРазрез", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движения.ВКМ_Удержания.Записывать = Истина;
		Движение = Движения.ВКМ_Удержания.Добавить();
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
		Движение.ПериодРегистрации = Дата;
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.БазовыйПериодНачало = Выборка.БазовыйПериодНачало;
		Движение.БазовыйПериодКонец = Выборка.БазовыйПериодКонец;
		Движение.Сумма = Выборка.СуммаБаза * 13 / 100;	
		
	КонецЦикла;
	
	Движения.ВКМ_Удержания.Записать();
	
КонецПроцедуры

Процедура СформироватьДвиженияРегистраВзаиморасчетыССотрудниками()

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
	|	СУММА(ВКМ_ДополнительныеНачисления.Сумма) КАК СуммаНачислений
	|ПОМЕСТИТЬ ВТ_ДанныеНачислений
	|ИЗ
	|	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
	|ГДЕ
	|	ВКМ_ДополнительныеНачисления.Регистратор = &Регистратор
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_ДополнительныеНачисления.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВКМ_Удержания.Сотрудник КАК Сотрудник,
	|	СУММА(ВКМ_Удержания.Сумма) КАК СуммаУдержаний
	|ПОМЕСТИТЬ ВТ_ДанныеУдержаний
	|ИЗ
	|	РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
	|ГДЕ
	|	ВКМ_Удержания.Регистратор = &Регистратор
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_Удержания.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ДанныеНачислений.Сотрудник КАК Сотрудник,
	|	ВТ_ДанныеНачислений.СуммаНачислений КАК СуммаНачислений,
	|	ВТ_ДанныеУдержаний.СуммаУдержаний КАК СуммаУдержаний
	|ИЗ
	|	ВТ_ДанныеНачислений КАК ВТ_ДанныеНачислений
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеУдержаний КАК ВТ_ДанныеУдержаний
	|		ПО (ВТ_ДанныеНачислений.Сотрудник = ВТ_ДанныеУдержаний.Сотрудник)";
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.Сумма = Выборка.СуммаНачислений - Выборка.СуммаУдержаний;
	
	КонецЦикла;
	
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записать();	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли