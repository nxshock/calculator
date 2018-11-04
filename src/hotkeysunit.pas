unit HotkeysUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows;

procedure AssociateHotkeys(h: THANDLE);

implementation

procedure AssociateHotkeys(h: THANDLE);
begin
  // Hotkey Ctrl+1
  RegisterHotKey(h, GlobalAddAtom('Min/Restore hotkey'), MOD_CONTROL, VK_1);
end;

end.

