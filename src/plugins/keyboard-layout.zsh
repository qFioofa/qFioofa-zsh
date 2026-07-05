# Раскладка. Набрал команду с включённой кириллицей (`ды -ды` вместо `ls -la`)?
# Вместо "command not found" транслитерируем ЙЦУКЕН → QWERTY по позициям клавиш
# и повторяем строку. Хук зовётся только когда команда реально не найдена, так
# что на обычные команды это не тратит ничего.

# Карта строится один раз при сорсинге: кириллическая буква -> латинская клавиша
# на той же физической позиции.
typeset -gA _kbd_ru_en
() {
  local -a en ru
  en=(q w e r t y u i o p '[' ']'  a s d f g h j k l ';' "'"  z x c v b n m ',' '.'  '`')
  ru=(й ц у к е н г ш щ з х  ъ    ф ы в а п р о л д ж э    я ч с м и т ь б  ю    ё)
  local i
  for i in {1..$#ru}; do
    _kbd_ru_en[${ru[i]}]=${en[i]}                     # строчные
    _kbd_ru_en[${(U)ru[i]}]=${(U)en[i]}               # ЗАГЛАВНЫЕ -> Shift+клавиша
  done
}

# Одно слово из кириллицы в латиницу, неизвестные символы оставляем как есть.
_kbd_ru2en() {
  local out="" ch
  for ch in ${(s::)1}; do out+="${_kbd_ru_en[$ch]:-$ch}"; done
  print -r -- "$out"
}

command_not_found_handler() {
  local -a fixed
  local w
  for w in "$@"; do fixed+=("$(_kbd_ru2en "$w")"); done

  # Повторяем только если первое слово изменилось И стало настоящей командой
  # (алиас/функция/билтин/бинарь) — иначе не рискуем и отдаём обычную ошибку.
  if [[ ${fixed[1]} != "$1" ]] && whence -- ${fixed[1]} &>/dev/null; then
    print -u2 -- "\e[2mlayout ru→en: ${fixed[*]}\e[0m"
    "${fixed[@]}"
    return
  fi

  print -u2 -- "zsh: command not found: $1"
  return 127
}

# ponytail: раскрытие только по имени команды (алиасы/пути), не по логике pipe/quotes —
# добавить полный разбор строки, если реально понадобится.

# Самопроверка: `_kbd_layout_test`
_kbd_layout_test() {
  [[ "$(_kbd_ru2en 'ды')"      == 'ls'   ]] || { print -u2 "FAIL ды";   return 1 }
  [[ "$(_kbd_ru2en 'пше')"     == 'git'  ]] || { print -u2 "FAIL пше";  return 1 }
  [[ "$(_kbd_ru2en 'ГД')"      == 'UL'   ]] || { print -u2 "FAIL ГД";   return 1 }
  [[ "$(_kbd_ru2en '-ды')"     == '-ls'  ]] || { print -u2 "FAIL -ды";  return 1 }
  print "ok"
}
