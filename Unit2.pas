unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Grids, Vcl.StdCtrls, UMethod;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses unit1;
{$R *.dfm}


{procedure Graph1(var f:tform2);
var  x0,y0,dx,dy,h,w,xmax,xmin,mx,my: integer;  pe:Tpen; y,x:real;
begin
  H:=form2.PaintBox1.ClientHeight;
  W:=form2.PaintBox1.ClientWidth;

  x0 := w div 2;
  y0 := h div 2;

  dx:=40; dy:=40;

  xmin:=-10;
  xmax:=10;

  my:=trunc(h/(abs(xmax-xmin)));
  mx:=trunc(w/(abs(xmax-xmin)));


  with f.PaintBox1.Canvas do
  begin
    pen.Color:=clred;
    x:=xmin; y:=calculation(head,tail,x);          //
    MoveTo(x0+trunc(x*mx),y0-trunc(y*my));
    While x <= xmax do
    Begin
      x:=x+0.01;
      y:=calculation(head,tail,x);
      LineTo(x0+trunc(x*mx),y0-trunc(y*my));
    End;
  end;
end; }

procedure TForm2.Button1Click(Sender: TObject);
var x0, y0, dx, dy, h, w, x, y: integer;
    lx, ly: integer; dlx, dly,mx,my: integer;
begin
  {dx := 40;
  dy := 40; // шаг координатной сетки 40 пикселей
  dlx := 1; // Отметки на оси X
  dly := 1; // Отметки на по оси Y

  h := FORM2.PaintBox1.ClientHeight;
  w := FORM2.PaintBox1.ClientWidth;
  x0 := w div 2;
  y0 := h div 2;

  with form2.PaintBox1.Canvas do
  begin
    textout(w-40,y0-26,'X');//Подпись X
    textout(x0+5,5,'Y'); //Подпись Y

    x := 0;
    lx := -trunc (x0/dx);
    repeat
        if lx <> 0  then
          TextOut(x - 18, y0 + 5, intToStr(lx));
      if lx <> 0  then
      begin
        Pen.Style := psDot;
      end;
      MoveTo(x, 0);
      LineTo(x, h); // линия сетки
      Pen.Style := psSolid;
      lx := lx + dlx;
      x := x + dx;
    until (x > x0 + w);

    y := 0;
    ly := trunc (y0/dy);
    repeat
      TextOut(x0 - 30, y-5, intToStr(ly));
      if ly <> 0 then
        begin
        Pen.Style := psDot;
        end;
      MoveTo(0, y);
      LineTo(w, y); // линия сетки
      Pen.Style := psSolid;
      y := y + dy;
      ly := ly - dly;
    until (y > y0 + h);

  end;

  //graph1(form2);}
end;



end.
