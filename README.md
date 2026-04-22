
<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=00599C&height=120&section=header&fontSize=40&fontAlignY=35" />
  <img src="https://readme-typing-svg.herokuapp.com?font=Fira+Code&weight=600&size=26&pause=1000&color=00599C&center=true&vCenter=true&width=800&lines=🌍+Основы+Геоинформационных+систем;Итоговый+отчет+по+лабораторным+работам;НИУ+БелГУ+|+2026" alt="Typing SVG" />
</div>

<p align="center">
  <a href="#-навигация-по-работам"><img src="https://img.shields.io/badge/Статус-5_работ_выполнено-2ea44f?style=for-the-badge&logo=github" /></a>
  <img src="https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white" />
  <img src="https://img.shields.io/badge/Delphi-Direct-E11922?style=for-the-badge&logo=delphi&logoColor=white" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Google_Earth-4285F4?style=for-the-badge&logo=google-earth&logoColor=white" />
</p>

---

<table width="100%">
  <tr>
    <td width="50%">
      <b>🎓 Информация о студенте:</b><br>
      Фролов Артем Алексеевич<br>
      Группа: 12002531 (1 курс)<br>
    </td>
    <td width="50%">
      <b>👨‍🏫 Проверил:</b><br>
      доц. Васильев Павел Владимирович<br>
      Кафедра МПОИС<br>
    </td>
  </tr>
</table>

---

## 📑 Навигация по работам
| ЛР | Тема | Инструменты | Готовность |
| :---: | :--- | :--- | :---: |
| **1** |[Построение карт в изолиниях](#-лабораторная-работа-1) | `Surfer` | ![100%](https://progress-bar.dev/100/?scale=100&color=2ea44f&suffix=%) |
| **2** | [3D объект с геопривязкой](#-лабораторная-работа-2) | `SketchUp`, `Google Earth` | ![100%](https://progress-bar.dev/100/?scale=100&color=2ea44f&suffix=%) |
| **3** | [3D Глобус и триангуляция](#-лабораторная-работа-3) | `C++`, `GLScene` | ![100%](https://progress-bar.dev/100/?scale=100&color=2ea44f&suffix=%) |
| **4** | [Android GPS Навигатор](#-лабораторная-работа-4) | `FireMonkey`, `GPS API` | ![100%](https://progress-bar.dev/100/?scale=100&color=2ea44f&suffix=%) |
| **5** | [Локализация интерфейса](#-лабораторная-работа-5) | `i18n`, `Delphi` | ![100%](https://progress-bar.dev/100/?scale=100&color=2ea44f&suffix=%) |

---

<a id="-лабораторная-работа-1"></a>
## 🗺 Лабораторная работа 1
### Построение карт в изолиниях в программе Surfer

> [!TIP]
> В этой работе мы использовали математический синтез ландшафта вместо обычного импорта точек.

#### Математическая модель рельефа:
Для генерации сетки (Grid) использовалась комплексная функция, имитирующая макрорельеф:
$$Z = 100 \cdot e^{-\frac{(X-50)^2+(Y-50)^2}{1000}} - 30 \cdot e^{-\frac{(X-Y)^2}{150}} + 15\sin\left(\frac{X}{6.5}\right)\cos\left(\frac{Y}{8.2}\right)$$

**Результат визуализации:**
<p align="center">
  <img src="img/image.png" width="850" alt="Surfer Output" style="border-radius: 10px;">
  <br><i>Рисунок 1 — 2D Изолинии (сверху) и 3D поверхность (снизу)</i>
</p>

<div align="right"><a href="#-навигация-по-работам">⬆ Наверх к меню</a></div>

---

<a id="-лабораторная-работа-2"></a>
## 🏢 Лабораторная работа 2
### Создание 3D объекта на карте с привязкой к геокоординатам

Здесь реализован классический ГИС-пайплайн: **SketchUp → Export KMZ → Google Earth Pro**.

#### Этапы разработки:
<table align="center" style="border-collapse: collapse; border: none;">
  <tr>
    <td align="center"><img src="img/image-0.png" width="400"><br><b>1. Моделирование геометрии</b></td>
    <td align="center"><img src="img/image-1.png" width="400"><br><b>2. Привязка к координатам</b></td>
  </tr>
  <tr>
    <td align="center"><img src="img/image-2.png" width="400"><br><b>3. Сохранение в формате KMZ</b></td>
    <td align="center"><img src="img/image-3.png" width="400"><br><b>4. Интеграция в Google Earth</b></td>
  </tr>
</table>

<div align="right"><a href="#-навигация-по-работам">⬆ Наверх к меню</a></div>

---

<a id="-лабораторная-работа-3"></a>
## 🌐 Лабораторная работа 3
### Создание модели глобуса с географической сеткой

Разработка собственного 3D ГИС-движка на базе **RAD Studio C++ Builder**.

> [!IMPORTANT]
> Для исключения графического артефакта **Z-fighting** (мерцания текстур при наложении), сфера координатной сетки имеет радиус $R = 1.02 \cdot R_{earth}$.

#### Управление в сцене:
- <kbd>LMB</kbd> + `Mouse Move`: Свободное вращение глобуса (Drag & Drop).
- <kbd>UI TreeView</kbd>: Переключение текстурных слоев (Топография / Температура).

#### 📸 Галерея интерфейса:
<!-- Объединение трех картинок в компактную галерею -->
<table align="center">
  <tr>
    <td align="center" width="50%"><img src="Lab3/image-1.png" width="100%"><br><i>Слой: Топография</i></td>
    <td align="center" width="50%"><img src="Lab3/image-2.png" width="100%"><br><i>Слой: Температура</i></td>
  </tr>
  <tr>
    <td colspan="2" align="center"><img src="Lab3/image.png" width="70%"><br><i>Общий вид с наложенной сеткой координат</i></td>
  </tr>
</table>

<div align="right"><a href="#-навигация-по-работам">⬆ Наверх к меню</a></div>

---

<a id="-лабораторная-работа-4"></a>
## 📍 Лабораторная работа 4
### Работа с GPS и картами в Android

> [!CAUTION]
> Начиная с Android 13, недостаточно указать права в манифесте. Реализован динамический запрос разрешения `ACCESS_FINE_LOCATION` в Runtime.

#### Особенности реализации:
- **Картография:** Динамическая подгрузка `OpenStreetMap` через `TWebBrowser` для обхода ограничений intent-ов Google Maps.
- **Потоки:** Обратное геокодирование (`TGeocoder`) вынесено в фоновый поток через `TThread.Queue`, чтобы интерфейс приложения не зависал при слабом интернете.

<details>
<summary><b>📦 Посмотреть исходный код обработчика (Delphi FMX)</b></summary>

```pascal
procedure TForm1.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);
begin
  // Форматируем координаты с точкой
  FS := TFormatSettings.Create('en-US');
  Lats := FloatToStr(NewLocation.Latitude, FS);
  Longs := FloatToStr(NewLocation.Longitude, FS);
  
  // Обновляем карту в браузере
  URL := Format('https://www.openstreetmap.org/?mlat=%s&mlon=%s', [Lats, Longs]);
  WebBrowser1.Navigate(URL);
end;
```
</details>

#### Тестирование на мобильном устройстве:
<table align="center" width="100%">
  <tr>
    <th width="35%">📱 Клиент на смартфоне</th>
    <th width="65%">🗺 Обратное геокодирование (OSM)</th>
  </tr>
  <tr>
    <td align="center">
      <img src="Lab4/Screenshot_2026-04-06-18-15-56-67_57c6440c5213b5e28772eea05054fe6f.jpg" width="280">
    </td>
    <td align="center">
      <img src="Lab4/image.png" width="550">
    </td>
  </tr>
</table>

<div align="right"><a href="#-навигация-по-работам">⬆ Наверх к меню</a></div>

---

<a id="-лабораторная-работа-5"></a>
## 🇷🇺 Лабораторная работа 5
### Локализация (i18n) приложения

Реализована полная локализация интерфейса (перевод на Русский язык) с использованием встроенного менеджера ресурсов RAD Studio.

> [!NOTE]
> Были переведены не только статические надписи на кнопках (`Labels`), но и заголовки форм, а также всплывающие системные уведомления.

<p align="center">
  <img src="Lab5/image.png" width="600"><br><i>Главное окно приложения</i>
</p>

<details>
<summary><b>🔍 Посмотреть остальные переведенные формы</b></summary>

<p align="center">
  <img src="Lab5/image-1.png" width="450" style="margin-right: 10px;">
  <img src="Lab5/image-2.png" width="450">
</p>
</details>

<div align="right"><a href="#-навигация-по-работам">⬆ Наверх к меню</a></div>

---

## 🎓 Итоги курса
В ходе выполнения цикла лабораторных работ были успешно освоены:
-[x] Анализ и генерация математических моделей рельефа (Surfer).
- [x] 3D-моделирование и работа с картографическими проекциями (KMZ).
- [x] Низкоуровневая разработка 3D-графики и сцен на C++.
- [x] Кроссплатформенная мобильная разработка под Android, работа с GPS-сенсорами.

<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=00599C&height=120&section=footer" />
</div>
