program Calculator;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, MainFormUnit, Support, hotkeysunit;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Title:='Калькулятор';
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

