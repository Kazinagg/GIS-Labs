import os
import re
from deep_translator import GoogleTranslator

# Настройки
SOURCE_LANG = 'en'
TARGET_LANG = 'ru'
# Путь к папке с формами ('.' означает текущую папку)
DIRECTORY = '.' 

def is_translatable(text):
    """Фильтр: определяем, нужно ли переводить этот текст"""
    if not text.strip(): 
        return False
    
    # Пропускаем технические имена компонентов (SpeedButton1, TabItem2 и т.д.)
    # Чтобы скрипт не переводил внутренние имена, которые случайно попали в Text
    if re.match(r'^(TreeViewItem|SpeedButton|TabItem|sb|Layout|Panel)[A-Za-z0-9_]*$', text): 
        return False
        
    # Если текст состоит только из цифр или знаков препинания - не переводим
    if re.match(r'^[\W\d_]+$', text):
        return False
        
    return True

def main():
    print("Инициализация переводчика...")
    translator = GoogleTranslator(source=SOURCE_LANG, target=TARGET_LANG)
    
    # Регулярное выражение ищет строки вида:   Text = 'Что-то'
    # Оно захватывает 3 группы: 1) "  Text = '"  2) "Что-то"  3) "'"
    regex = re.compile(r"^(\s*(?:Text|Caption|Hint)\s*=\s*')(.*)(')\s*$")

    for filename in os.listdir(DIRECTORY):
        if filename.endswith(".fmx"):
            filepath = os.path.join(DIRECTORY, filename)
            print(f"\nОбработка файла: {filename}")
            
            # Читаем исходный файл
            with open(filepath, 'r', encoding='utf-8-sig') as f:
                lines = f.readlines()

            new_lines =[]
            changed = False

            for line in lines:
                match = regex.match(line)
                if match:
                    prefix = match.group(1)   # например: "    Text = '"
                    original_text = match.group(2) # например: "Save As..."
                    suffix = match.group(3)   # например: "'"
                    
                    # Проверяем, надо ли это переводить
                    if is_translatable(original_text):
                        try:
                            # Переводим
                            ru_text = translator.translate(original_text)
                            
                            # Небольшая корректировка для частых терминов горного дела (по желанию)
                            ru_text = ru_text.replace("Сетка", "Решетка") 
                            
                            # Собираем строку обратно
                            line = f"{prefix}{ru_text}{suffix}\n"
                            changed = True
                            print(f"[+] '{original_text}' -> '{ru_text}'")
                        except Exception as e:
                            print(f"  [-] Ошибка перевода '{original_text}': {e}")
                
                new_lines.append(line)

            # Если были изменения - сохраняем
            if changed:
                backup_path = filepath + ".bak"
                # Делаем резервную копию оригинала (на всякий случай)
                if not os.path.exists(backup_path):
                    os.rename(filepath, backup_path)
                else:
                    os.remove(filepath)
                
                # Записываем переведенный файл
                with open(filepath, 'w', encoding='utf-8-sig') as f:
                    f.writelines(new_lines)
                print(f"  Сохранен: {filename}")
            else:
                print("  Нет текста для перевода.")

if __name__ == "__main__":
    main()