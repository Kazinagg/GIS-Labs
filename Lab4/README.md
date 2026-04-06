# Лабораторная работа №4. Работа с GPS и картами Google Map при разработке мобильных приложений под Android

## 🎯 Цель работы
Разработать мобильное приложение по навигации и определению положения пользователя или объекта на глобусе с использованием ОС Android и среды разработки RAD Studio.

## 🛠 Технические особенности реализации
В связи с тем, что в современных версиях **RAD Studio 13** поддержка разработки под Android на C++ Builder была прекращена, данная лабораторная работа выполнена на языке **Delphi (Object Pascal)** с использованием кроссплатформенного фреймворка **FireMonkey (FMX)**.

В ходе выполнения работы были решены следующие технические задачи:
1. **Динамический запрос разрешений (Runtime Permissions):** Начиная с Android 6.0+, недостаточно указать права в манифесте. Был реализован код для запроса `ACCESS_FINE_LOCATION` и `ACCESS_COARSE_LOCATION` во время выполнения программы с помощью `PermissionsService`.
2. **Обход ограничения Google Maps (intent://):** Компонент `TWebBrowser` не умеет обрабатывать scheme `intent://`, на которую Google Maps автоматически перенаправляет мобильные устройства. Проблема решена путем генерации виртуальной HTML-страницы с тегом `<iframe>` и загрузки её через метод `LoadFromStrings()`.
3. **Потокобезопасность:** Обработка ответа от `TGeocoder` происходит в фоновом потоке. Вывод полученного адреса в пользовательский интерфейс (`Label`) обернут в `TThread.Queue`, чтобы избежать зависания UI-потока Android.

## 🧱 Используемые компоненты (FMX)
* `TLocationSensor` — для получения географических координат устройства (широты и долготы).
* `TWebBrowser` — для отображения веб-интерфейса Google Карт.
* `TLabel` (2 шт.) — для вывода числовых значений координат и декодированного почтового адреса.
* `TGeocoder` (из модуля `System.Sensors`) — для обратного геокодирования (перевода координат в читаемый адрес).

## 💻 Основной листинг кода

Обработчик события изменения геопозиции (`OnLocationChanged`):

```pascal
procedure TForm1.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
var
  Lats, Longs, HTMLString: string;
  FS: TFormatSettings;
begin
  // Форматирование координат (разделитель - точка, обязательно для Google API)
  FS := TFormatSettings.Create('en-US');
  Lats := FloatToStr(NewLocation.Latitude, FS);
  Longs := FloatToStr(NewLocation.Longitude, FS);

  // Вывод координат на экран
  Label1.Text := Format('Широта: %s Долгота: %s', [Lats, Longs]);

  // Генерация HTML-страницы для обхода переадресации intent://
  HTMLString := Format(
    '<html><body style="margin:0;padding:0;">' +
    '<iframe width="100%%" height="100%%" frameborder="0" style="border:0;" ' +
    'src="https://maps.google.com/maps?q=%s,%s&z=16&output=embed"></iframe>' +
    '</body></html>', [Lats, Longs]);
    
  // Загрузка карты в WebBrowser
  WebBrowser1.LoadFromStrings(HTMLString, '');

  // Обратное геокодирование (Координаты -> Адрес)
  if not Assigned(FGeocoder) then
  begin
    if Assigned(TGeocoder.Current) then
    begin
      FGeocoder := TGeocoder.Current.Create;
      FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
    end;
  end;

  if Assigned(FGeocoder) and not FGeocoder.Geocoding then
    FGeocoder.GeocodeReverse(NewLocation);
end;

![alt text](Screenshot_2026-04-06-18-15-56-67_57c6440c5213b5e28772eea05054fe6f.jpg)