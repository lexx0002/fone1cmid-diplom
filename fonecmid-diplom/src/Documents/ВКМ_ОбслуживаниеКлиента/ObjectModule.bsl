

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка,
		|	ДоговорыКонтрагентов.ВидДоговора,
		|	ДоговорыКонтрагентов.ВКМ_ДатаНачалаДействия КАК ДатаНачала,
		|	ДоговорыКонтрагентов.ВКМ_ДатаОкончанияДействия КАК ДатаОкончания
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Договор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	
	Если НЕ (Выборка.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбоненскоеОбслуживание 
	И Дата <= Выборка.ДатаОкончания И Дата >= Выборка.ДатаНачала) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	
	
	
КонецПроцедуры