unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazFileUtils, Forms, Controls, Graphics, Dialogs, EditBtn,
  StdCtrls, ExtCtrls, Menus, Windows, fpExprPars, lazutf8;

type
  TMainForm = class(TForm)
    ExitMenuItem: TMenuItem;
    ImageList16px: TImageList;
    ShowHideMenuItem: TMenuItem;
    TrayPopupMenu: TPopupMenu;
    ResultEdit: TEdit;
    QueryEdit: TEditButton;
    TrayIcon: TTrayIcon;
    procedure ExitMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure QueryEditButtonClick(Sender: TObject);
    procedure QueryEditChange(Sender: TObject);
    procedure QueryEditKeyPress(Sender: TObject; var Key: char);
    procedure ShowHideMenuItemClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure ShowHideForm;
  private
    procedure WM_HotKeyHandler(var Message: TMessage);
      message WM_HOTKEY;
  end;

var
  MainForm: TMainForm;

implementation

uses Support, HotkeysUnit;

{$R *.lfm}

procedure TMainForm.WM_HotKeyHandler(var Message: TMessage);
begin
  if (LOWORD(Message.lParam) = MOD_CONTROL) and (HIWORD(Message.lParam) = VK_1) then
    ShowHideMenuItemClick(MainForm);
  inherited;
end;

procedure TMainForm.QueryEditChange(Sender: TObject);
var
  t: integer;
  parser: TFPExpressionParser;
  parserResult: TFPExpressionResult;
begin
  if length(QueryEdit.Text) = 0 then begin
    ResultEdit.Text := '0,00';
    exit;
  end;

  t := QueryEdit.SelStart;
  QueryEdit.Text := ClearExpression(QueryEdit.Text);
  QueryEdit.SelStart := t;

  parser := TFPExpressionParser.Create(nil);
  try
    parser.BuiltIns := [bcMath];
    parser.Expression := UTF8StringReplace(QueryEdit.Text,',','.',[rfReplaceAll]);
    parserResult := parser.Evaluate;
    ResultEdit.Text := formatfloat('0.00', ArgToFloat(parserResult));
  except
    on E: Exception do
      ResultEdit.Text := E.Message;
  end;
  parser.Free;
end;

procedure TMainForm.QueryEditKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    QueryEdit.Text := ResultEdit.Text;
end;

procedure TMainForm.ShowHideMenuItemClick(Sender: TObject);
begin
  ShowHideForm;
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  ShowHideForm;
end;

procedure TMainForm.ShowHideForm;
begin
  if MainForm.Visible then
    MainForm.Hide
  else
  begin
    if MainForm.WindowState = wsMinimized then
      MainForm.WindowState := wsNormal;
    MainForm.Show;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FormatSettings.DecimalSeparator := '.';
  MainForm.Left := Screen.Width - MainForm.Width - 16;
  MainForm.Top := Screen.Height - MainForm.Height - 64;
  AssociateHotkeys(Handle);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  QueryEdit.SetFocus;
  QueryEdit.SelectAll;
end;

procedure TMainForm.QueryEditButtonClick(Sender: TObject);
begin
  QueryEdit.Text := '';
  QueryEdit.SetFocus;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caHide;
end;

procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  TrayIcon.Hide;
  try
    UnregisterHotKey(Handle, 1);
    GlobalDeleteAtom(1);
  except;
  end;
  Application.Terminate;
end;

end.
