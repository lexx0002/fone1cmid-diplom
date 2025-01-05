#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗаполнитьГрафик(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьНаСервере()
	Курсор = Период.ДатаНачала;
	Пока Курсор < Период.ДатаОкончания Цикл
	Запись = регистрыСведений.ВКМ_РабочийГрафик.СоздатьМенеджерЗаписи();
	Запись.Дата = Курсор;
	Если ДеньНедели(Курсор) <= 5 Тогда
		Запись.РабочихДней = 1;
	КонецЕсли;
		Запись.Записать();
		Курсор = Курсор + 86400;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
