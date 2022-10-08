unit UMethod;

interface

  uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, math;

  Type

//Стек для знаков операций
   Stack = ^Operand;
   Operand = Record
      inf: char;
      lvl:  byte;         //Информационное поле
      prev: stack;        //Ссылка на предидущий
     end;

//Стек для операций
     Queue = ^Operation;
     Operation = Record
        data: char;         //Информационное поле
        next: queue;       // Ссылка на предидущий
     end;
 //Стек для хранений результатов операций
     stak = ^o;
     o = record
        answer:extended;
        prev:stak;
        end;

  function method_trapezoids(h,t:queue; a1,b1,e:real; var u:real):real;
  procedure push_st(x:char; level:byte; var st:stack);
  function pop_st(var st:stack):char;
  procedure push(var st:stak; x:real);
  function pop(var st:stak):real;
  procedure add_que(var h:queue; var t:queue; s:char);
  function pop_que(var h:queue; var t:queue):char;
  procedure Postfix_form(s:string; var h:queue; var t:queue);
  function Calculation(h,t:queue; x:real):real;       //Рассчет постфиксной формы
  procedure parse(var s:string);
  function Check(var stn:string):boolean;
  function met_Simp(h,t:queue; a1,b1,e:real; var u:real):real;


implementation

function Priority_oper( c: string ): byte;        //Получение приоритета знака операции
begin
   Result := 0;
   if c  = '(' then
    Result := 1;
   if (c  = '+') or (c = '-')  then
    Result := 2;
   if (c  = '*') or (c = '/') then
    Result := 3;
   if (c  = '^')  then
    Result := 4;
   if (c  = 'c') or (c = 's') or (c='l') or (c='t') or (c='e') then
    Result := 5;
end;

procedure push_st(x:char; level:byte; var st:stack);           //Стек строк
var
 t:stack;
begin
 new(t);
 t^.inf:=x;
 t^.lvl:=level;
 t^.prev:=st;
 st:=t;
end;

function pop_st(var st:stack):char;                 //стек строк  //Извлечение элемента из стека
begin
    pop_st := st^.inf;
    st := st^.prev;
end;

procedure push(var st:stak; x:real);                 //Добавление элемента в стек
var
 t:stak;
begin
 new(t);
 t^.answer:=x;
 t^.prev:=st;
 st:=t;
end;

function pop(var st:stak):real;                         //Извлечение элемента из стека
var
 t:stack;
begin
if st = nil  then
  result:=0
else
begin
 pop := st^.answer;
 st := st^.prev;
end;
end;

procedure add_que(var h:queue; var t:queue; s:char); //Добавление элемента в очередь
var Newr:queue;
begin
  new(newr);
  newr^.data:=s;
  newr^.next:=nil;
  if h = nil then //Проверка пустая ли очередь
    h := newr
  else
    t^.next:=newr; //Вставка последнего  элемента в конец очереди
  t:=newr; //Перенос хвоста очереди на последний элемент
end;


function pop_que(var h:queue; var t:queue):char;//Извлечение элемента из очереди
var top:queue;
begin
    Result := h^.data;
    h := h^.next;
    if h = nil then //Проверка на последний элемент
    begin
      h:=nil;
      t := nil;
    end;
end;

Function skobki(S:string):boolean;            //Проверка кол-ва скобок
var i,j:integer;
begin
  i:=0; j:=0;
  while pos('(',s) <> 0 do                     //Подсчет левых скобок
  begin
    inc(i);
    delete(s,pos('(',s),1);
  end;
  while pos(')',s) <> 0 do                     //Подсчет правых скобок
  begin
    inc(j);
    delete(s,pos(')',s),1);
  end;
  if i = j then
    result:=true
  else
    result:=false;
end;

procedure parse(var s:string);                //Просмотр строки и замена функций на, соответствующие им символы
var j:integer;
begin
  //Ln = l
  while pos('ln',s) <> 0 do
  begin
    j:=pos('ln',s);
    delete(s,j,2);
    insert('l',s,j);
  end;
  //cos = c
  while pos('cos',s) <> 0 do
  begin
    j:=pos('cos',s);
    delete(s,j,3);
    insert('c',s,j);
  end;
  //sin = s
  while pos('sin',s) <> 0 do
  begin
    j:=pos('sin',s);
    delete(s,j,3);
    insert('s',s,j);
  end;
  //tg or tan = t
  while (pos('tg',s) <> 0) or (pos('tan',s) <> 0) do
  begin
    if (pos('tg',s) <> 0) then
      begin
        j:=pos('tg',s);
        delete(s,j,2);
        insert('t',s,j);
      end
    else
      begin
        j:=pos('tan',s);
        delete(s,j,3);
        insert('t',s,j);
      end;
  end;
  {if pos('arccos',s) <> 0 then
  begin
    StringReplace(s,'arccos','q',[rfReplaceAll]);
  end;
  if pos('arcsin',s) <> 0 then
  begin
    StringReplace(s,'arcsin','w',[rfReplaceAll]);
  end;}
end;

function sgi(l:char):boolean;
begin
  result := false;
  if l = '+' then
    result:=true;
  if l = '-' then
    result:=true;
  if l = '*' then
    result:=true;
  if l = '^' then
    result:=true;
  if l = '/' then
    result:=true;
  if l = 'l' then
    result:=true;
  if l = 'c' then
    result:=true;
  if l = 's' then
    result:=true;
  if l = 't' then
    result:=true;
end;

function sk(l:char):boolean;
begin
  result:=false;
  if l = ')' then
    result:=true;
  if l = '(' then
    result := true;
end;

function trig(l:char):boolean;
begin
  result:=false;
  if l = 'l' then
    result:=true;
  if l = 'c' then
    result := true;
  if l = 's' then
    result := true;
  if l = 't' then
    result := true;
end;

function Check(var stn:string):boolean;           //Просмотр кол-ва скобок
begin
  if skobki(stn) then
  begin
    result := true;
  end
  else
  begin
    result:=false;
    showmessage('Не хватает скобок');
  end;
end;

procedure Postfix_form(s:string; var h:queue; var t:queue);
var st:stack;
    i,level:integer;              //Level - приоритет знака операции
    j:string;                    //Числа
    op,buf:char;
    fl:boolean;                 //Флаг

begin
  st:=nil;             //стек
  h:=nil;              //Начало очереди
  t:=nil;              //Конец очереди

  i:=1;

  for i:=1 to length(s)  do
  begin
    //Проверка на цифру или символ(например: х)
    if not (sgi(s[i])) and not (sk(s[i])) then
        add_que(h,t,s[i]);
    //Проверка на знак операции
    if sgi(s[i]) then
    begin
      //Получение приоритета знака операции
      level := Priority_oper(s[i]);

      if (st <> nil)  then
      begin
        while st^.lvl >= level do
        begin
          op:=pop_st(st);
          add_que(h,t,op);
          if st = nil then
            break;
        end;
        push_st(s[i],level,st);
      end
      else
        push_st(s[i],level,st);
    end;

    if s[i] = '(' then
      push_st(s[i],1,st);

    if (s[i] = ')') and (st<>nil) then
    begin
      while st^.inf <> '(' do
      begin
          op := pop_st(st);
          add_que(h,t,op);
        if st = nil then
            break;
      end;
        buf := pop_st(st);
    end;
  end;

  //Выгружаем оставшиеся операторы в очередь
  if st <> nil  then
    while st <> nil  do
    begin
      op:=pop_st(st);
      add_que(h,t,op);
    end;
end;

function Calculation(h,t:queue; x:real):real;       //Рассчет постфиксной формы
var st:stak;                                        //Основной стек, где будут хранится результаты операций
    i:integer;
    l:char;
    a,b,ab:extended;                                //Значения, получаемые из стека результатов
begin
  st:=nil;
  while h <> nil do
  begin
    l := pop_que(h,t);                              //Элемент с вершины очереди
    if  sgi(l)  then                          //Является ли элемент знаком операции
    begin
      if trig(l) then
      begin
        if l = 'l' then                            //Натуральный логарифм
        begin
          ab:=pop(st);
          push(st,ln(ab));
        end;
        if l = 'c' then                            //Косинус
          begin
            ab:=pop(st);
            push(st,cos(ab));
          end;
        if l = 's' then                            //Синус
          begin
            ab:=pop(st);
            push(st,sin(ab));
          end;
        if l = 't' then                            //Тангенс
          begin
            ab:=pop(st);
            push(st,tan(ab));
          end;
      end
      else
      begin                                     //Обычные знаки операций
      b := pop(st);
      a := pop(st);
      if l = '+' then
      begin
         push(st,(a+b));
      end;
      if l = '-' then
      begin
         push(st,(a-b));
      end;
      if l = '/' then
      begin
         push(st,(a/b));
      end;
      if l = '*' then
      begin
         push(st,(a*b));
      end;
      if l = '^' then
      begin
         push(st,power(a,b));
      end;
      end
    end
    else
    begin
      if l = 'x' then
        push(st,x)
      else
        push(st,strtofloat(l));
    end;
  end;
    result:=pop(st);                                  //Результат выражения
end;

function MT(h,t:queue; a1,b1,n:real):real;
var i:integer; high,s:extended;
begin
  high := (b1 - a1)/n;                //Высота трапеции
  i:=1;
  s := 0;

  while i <= n-1 do
   begin
     S := S + Calculation(h,t,(a1+high*i));
     inc(i);
   end;

   S := high*((Calculation(h,t,a1) + Calculation(h,t,b1))/2+S);

  result:=s;

end;

function method_trapezoids(h,t:queue; a1,b1,e:real; var u:real):real;       //Метод трапеций
var x,           //Оператор функции
    high,       //Высота трапеции
    n1,n2,          //Кол-во шагов(трапеций)
    j:real;

    i:integer;
    S1,s2:real;

begin
  n1 := 5;
  n2 := 10;
  S1:=0; s2:=0;
  repeat
    s1 := Mt(h,t,a1,b1,n1);
    s2 := MT(h,t,a1,b1,n2);
    n1 := n2;
    n2 := n2*2;
  until abs(s1-s2) < e;
  result := s2;                                 //Результат метода трапеций
  u :=n2;

end;

function simp(h,t:queue; a1,b1,n:real):real;
var i:integer; high,s,s1,s2:extended;
begin
  high := (b1 - a1)/(n);                //Высота трапеции
  i:=1;
  s := 0;
  s1:=0;
  s2:=0;

   while i <= n-1 do
   begin
      if i mod 2 = 0 then
        S1 := S1 + Calculation(h,t,(a1+high*i))
      else
        s2 := s2 + Calculation(h,t,(a1+high*i));
     inc(i);
   end;

   S := (high/3)*(Calculation(h,t,a1) + Calculation(h,t,b1) + 4*S2 + 2*s1);

  result:=s;
end;

function met_Simp(h,t:queue; a1,b1,e:real; var u:real):real;
var x,           //Оператор функции
    high,       //Высота трапеции
    n1,n2,          //Кол-во шагов(трапеций)
    j:real;

    i:integer;
    S1,s2:real;
begin
  n1 := 4;
  n2 := 8;
  S1:=0; 
  s2:=0;
  repeat
    s1 := simp(h,t,a1,b1,n1);
    s2 := simp(h,t,a1,b1,n2);
    n1 := n2;
    n2 := n2*2;
  until abs(s1-s2) < e;
  result := s2;                                 //Результат метода трапеций
  u :=n2;
end;

end.
