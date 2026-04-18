program Classify;

uses 
  Distribs;

const
  MinSize = 0;                              { минимальный размер частицы }
  MaxSize = 1000;                           { максимальный размер частицы }
  MaxParticle = 50;                         { число частиц }
  MaxSClass = 10;                           { число классов крупности }
  modul = 1.41;                             { модуль шкалы размеров }

type
  real = single;
  Values = array[1..MaxParticle] of integer; { массив целых значений }
  DistSAbs = array[1..MaxSClass] of integer;   { массив числа частиц в классах }
  DistSRel = array[1..MaxSClass] of real;

var
  Data: Values;                             { исходные данные }
  fabs: DistSAbs;                           { распределение по крупности }
  i: integer;
  Seed : integer;                           { посев }

{-------------------------------------------------}
{ Процедура быстрой сортировки  с использованием  }
{ метода сортировки массивов в памяти.            }
{ Генерируется список из MaxParticle случайных    }
{ чисел  между MinSize и MaxSize, а затем он      }
{ сортируется в процедуре QUICKSORT               }
{ Отсортированный список выводится на экран.      }
{ Cтек и проверка диапазона отключены путем выбора}
{ соответствующих директив компилятора            }
{ QUICKSORT сортирует элементы в массиве A        }
{ с индексами между LO and HI. Процедура QUICKSORT}
{ только служит как "interface" к программе.      }
{ Фактическая обработка данных осуществляется     }
{ в процедуре SORT,которая повторяется рекурсивно.}
{-------------------------------------------------}
procedure QuickSort(var a: Values; Lo,Hi: integer);

procedure sort(l,r: integer);
var
  i,j,x,y: integer;
begin
  i:=l; j:=r; x:=a[(l+r) DIV 2];
  repeat
    while a[i]<x do i:=i+1;
    while x<a[j] do j:=j-1;
    if i<=j then
    begin
      y:=a[i]; a[i]:=a[j]; a[j]:=y;
      i:=i+1; j:=j-1;
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;

begin;         
  sort(Lo,Hi);
end;     {quicksort}

{--------------------------------------------------------------}
{ Классификация данных по размерам для заданного числа классов }
{--------------------------------------------------------------}
procedure ClassData(var f:DistSAbs; Lo, Hi, MaxData, MaxClass: integer);
var
  I, J: Integer;
  Step: Integer;
begin
  for I:= 1 to MaxClass do f[I]:=0;      { обнуление массива }
  Step:= round((Hi-Lo)/MaxClass);        { шаг гистограммы }
  for I:= 1 to MaxData do
    for J:= 1 to MaxClass do
    begin
      if (Data[I]>=(J-1)*Step) and       { если >= размера }
       (Data[I] < J*Step)
      then
        f[J]:= f[J] + 1;                 { частицa в class}
    end;
end; 

{--------------------------------------}
{ Генерация равномерного распределения }
{   целых чисел в заданном диапазоне   }
{--------------------------------------}
procedure GenerEq;
begin
  Randomize;
  for i:=1 to MaxParticle do
    Data[i]:=Random(MaxSize);
end;  { GenerEq }

{--------------------------------------}
{ Генерация равномерного распределения }
{ вещественных чисел в диапазоне 0..1  }
{--------------------------------------}

procedure GenerUniform;
begin
  Randomize;
  for i:=1 to MaxParticle do
    Uniform(Data[i]);
end;

{====================== ГЛАВНОЕ ТЕЛО ПРОГРАММЫ ====================}
begin
  Writeln;
  Write('Генерация ', MaxParticle ,' случайных размеров частиц');
  Writeln;
  GenerEq;
  Write('и сортировка их по возрастанию значений');
  Quicksort(Data,1,MaxParticle);
  Writeln;
  for i:=1 to MaxParticle do Write(Data[i]:8);

  Writeln;

  ClassData(fabs,MinSize,MaxSize,MaxParticle,MaxSClass);
  Writeln('Распределение числа частиц по ',MaxSClass,' классам крупности: ');
  Writeln('');
  for i:= 1 to MaxSClass do Write(fabs[i]:8);

  Repeat until keypressed;
end.
