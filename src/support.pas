unit Support;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

function ClearExpression(input: string): string;                                     // Удаление лишних символов из выражения

implementation

function ClearExpression(input: string): string;
var
  i: integer;
begin
  // Замена десятичного разделителя с точки на запятую
  Result := stringreplace(input, '.', ',', [rfReplaceAll, rfIgnoreCase]);

  // Удаление всех лишних символов
  i := 1;
  while i <= length(Result) do
    if not ((Result[i]) in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '+', '-', '*', '/', '(', ')']) then
      Delete(Result, i, 1)
    else
      i := i + 1;
end;

end.

