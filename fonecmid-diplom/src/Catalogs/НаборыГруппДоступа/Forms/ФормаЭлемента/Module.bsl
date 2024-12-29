///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТолькоПросмотр = Истина;
	
	СписокВыбора = Элементы.ТипЭлементовНабора.СписокВыбора;
	ДобавитьЭлементСписка(СписокВыбора, "ГруппыДоступа");
	ДобавитьЭлементСписка(СписокВыбора, "ГруппыПользователей");
	ДобавитьЭлементСписка(СписокВыбора, "Пользователи");
	ДобавитьЭлементСписка(СписокВыбора, "ГруппыВнешнихПользователей");
	ДобавитьЭлементСписка(СписокВыбора, "ВнешниеПользователи");
	
	УстановитьСтраницуРеквизитовПоТипу(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЭлементовНабораПриИзменении(Элемент)
	
	УстановитьСтраницуРеквизитовПоТипу(ЭтотОбъект);
	Объект.Группы.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
	ПоказатьПредупреждение(,
		НСтр("ru = 'Набор групп доступа не следует изменять, так как он сопоставлен с разными ключами доступа.
		           |Чтобы исправить нестандартную проблему следует удалить набор групп доступа или
		           |связь с ним в регистрах и выполнить процедуру обновления доступа.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьЭлементСписка(СписокВыбора, ИмяСправочника)
	
	ПустойИдентификатор = ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор();
	
	СписокВыбора.Добавить(Справочники[ИмяСправочника].ПолучитьСсылку(ПустойИдентификатор),
		Метаданные.Справочники[ИмяСправочника].Представление());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтраницуРеквизитовПоТипу(Форма)
	
	Если ТипЗнч(Форма.Объект.ТипЭлементовНабора) = Тип("СправочникСсылка.Пользователи")
	 Или ТипЗнч(Форма.Объект.ТипЭлементовНабора) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		
		Форма.Элементы.РеквизитыНаборов.ТекущаяСтраница = Форма.Элементы.РеквизитыНабораИзОдногоПользователя;
	Иначе
		Форма.Элементы.РеквизитыНаборов.ТекущаяСтраница = Форма.Элементы.РеквизитыНабораГрупп;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
