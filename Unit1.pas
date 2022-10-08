unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, math, UMethod,
  Vcl.Buttons, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    Button1: TButton;
    Panel2: TPanel;
    LabeledEdit3: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn5: TBitBtn;
    Panel3: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;  
  
  str:string;               //Строка с функцией
    
  head,tail:queue;            //Ссылки на очередь с постфиксной записью
  
  //sign,Func,skobi,sg:oper;       //Множества скобок, функций, знаков операций

  a,b,eps:real;               //Значения
  
  locker:real;    
  
  sl:Tstringlist;

  N:real;

implementation

uses unit2;

{$R *.dfm}




procedure outik(h,t:queue);             //Вывод посфиксной записи выражения
var ss,s12:string;
begin
  s12:='';
  while h <> nil do
  begin
    ss:= pop_que(h,t);
    if ss <> '' then
      s12:=s12+ss;
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
LabeledEdit3.Text := 'x/(x^2+1)';
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
labelededit3.Text := '((3-x)^(1/2))/(3-x)';
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
 labelededit3.Text := 'ln(x)';
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
labelededit3.Text := 'cos(x)';
end;

procedure TForm1.Button1Click(Sender: TObject);
var ss:string; i:integer;  h,t:queue;    lk:string;
begin
  str:=LabeledEdit3.Text;
  a := strtofloat(labelededit1.text);
  b := strtofloat(labelededit2.Text);
  eps := strtofloat(labelededit4.Text);
  N := 0;
  if a < b  then
    if check(str) then
    begin
      parse(str);
      showmessage(str);
      Postfix_form(str,head,tail);
      outik(head,tail);
      //locker := method_trapezoids(head,tail,a,b,eps,N);
      locker :=  met_Simp(head,tail,a,b,eps,N);
      Form2.show;
      Form2.Panel1.Caption := 'Ответ: '+floattostr(locker);
      Form2.Panel2.Caption := 'Кол-во шагов: '+ floattostr(N);

    end
    else
    begin
      showmessage('Неверное кол-во скобок');
      exit
    end
  else
    begin
      showmessage('a > b?');
      exit;
    end;

end;

end.
