unit Unit1;

//ASCII to ZX81 char converter
//(c)20127-2018 Noniewicz.com
//created: 20171206
//updated: 20180416

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    zx81: array[0..255] of byte; //ascii code to zx81 code
    procedure init;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.init;
var i: integer;
begin
  for i := 0 to 255 do zx81[i] := 0; //clr aka any unset to space (was -1?!)

  zx81[32] := 0;
  zx81[13] := 118;

  zx81[ord('''')] := 11;       //note: " -> '

  zx81[ord('"')] := 11;
  zx81[ord('$')] := 13;
  zx81[ord(':')] := 14;
  zx81[ord('?')] := 15;
  zx81[ord('(')] := 16;
  zx81[ord(')')] := 17;
  zx81[ord('>')] := 18;
  zx81[ord('<')] := 19;
  zx81[ord('=')] := 20;
  zx81[ord('+')] := 21;
  zx81[ord('-')] := 22;
  zx81[ord('*')] := 23;
  zx81[ord('/')] := 24;
  zx81[ord(';')] := 25;
  zx81[ord(',')] := 26;
  zx81[ord('.')] := 27;

  zx81[ord('!')] := 0;		//no "!" either

  for i := ord('0') to ord('9') do zx81[i] := i-48+28;
  for i := ord('A') to ord('Z') do zx81[i] := i-65+38;
  for i := ord('a') to ord('z') do zx81[i] := i-97+38;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var i, j: integer;
    s, so: string;
    x: byte;
    m: boolean;
begin
  for i := 0 to Memo1.Lines.Count-1 do
  begin
    s := Memo1.Lines[i];
    j := 1;
    so := '';
    while (j <= length(s)) and (s[j] <> '"') do
    begin
      so := so + s[j];
      inc(j);
    end;
    if (j <= length(s)) and (s[j] = '"') then //skip the '"'
      inc(j);

    m := false;
    while (j <= length(s)) and (s[j] <> '"') do
    begin
      x := zx81[ord(s[j])];
      if m then so := so + ', ';
      so := so + inttostr(x);
      inc(j);
      m := true;
    end;
    while (j <= length(s)) do
    begin
      if (s[j] <> '"') then
        so := so + s[j];
      inc(j);
    end;
    Memo1.Lines[i] := so;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  init;
end;

end.

