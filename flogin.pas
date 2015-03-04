unit flogin;

{$mode objfpc}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IniFiles, DB, ExtCtrls, FileUtil,
  LResources, sqldb, OracleConnection;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    edDBName: TEdit;
    edPassword: TEdit;
    edUser: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sbOK: TSpeedButton;
    sbStorno: TSpeedButton;
    Shape1: TShape;
    procedure edDBNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edPasswordEnter(Sender: TObject);
    procedure edPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edUserKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure sbOKClick(Sender: TObject);
    procedure sbStornoClick(Sender: TObject);
    procedure Shape1ChangeBounds(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmLogin: TfrmLogin;

implementation

uses FMain,Data_module,Utils;

procedure klik_ok(aKey : Word);
begin
  if (aKey=13) then
  begin
    frmLogin.sbOKClick(nil);
  end;
  if (aKey=VK_F5) then
  begin
    frmLogin.edPassword.Text:=frmLogin.edUser.Text;
    frmLogin.sbOKClick(nil);
  end;
end;

procedure TfrmLogin.sbOKClick(Sender: TObject);
var
  l,lg,s,uc : string;
  Ini: TIniFile;
begin

  Ini:=TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
try

  Application.ShowMainForm:=true;

  DM.OracleConnection.LoginPrompt:=False;
  DM.OracleConnection.DatabaseName:=edDBName.Text;
  DM.OracleConnection.UserName:=edUser.Text;
  DM.OracleConnection.Password:=edPassword.Text;
  DM.OracleConnection.Connected:=true;
  DM.SQLTransaction.Active:=true;
  //DM.SQLTransaction.Active:=True;

  // uložení přihlaš. udaju
  Ini.WriteString('DB_CONNECT', 'CONNECT_STRING', edDBName.Text);
  Ini.WriteString('DB_CONNECT', 'USER_NAME', edUser.Text);

  // uživatel
  frmMain.lbUzivatel.Caption:=UpperCase(DM.OracleConnection.UserName);

  if neprelozitelne_objekty then
    MessageDlg('Byly nalezeny nepřeložené objekty v databázi, informujte administrátora.',mtWarning,[mbOK],0);

  Close;
finally
  Ini.free;
end;

end;

procedure TfrmLogin.sbStornoClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.Shape1ChangeBounds(Sender: TObject);
begin

end;

procedure TfrmLogin.FormShow(Sender: TObject);
var
  ini: TIniFile;
begin
try
  try
    ini := TIniFile.Create(ChangeFileExt(Application.ExeName,'.INI'));
    edDBName.Text:=ini.ReadString('DB_CONNECT', 'CONNECT_STRING', '');
    edUser.Text:=ini.ReadString('DB_CONNECT', 'USER_NAME', '');
  except
  end;

  if (edDbname.Text<>'') and (edUser.text<>'') then
    edPassword.SetFocus;

finally
  ini.free;
end;
end;

procedure TfrmLogin.edDBNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  klik_ok(Key);
end;

procedure TfrmLogin.edPasswordEnter(Sender: TObject);
begin

end;

procedure TfrmLogin.edUserKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  klik_ok(Key);
end;

procedure TfrmLogin.edPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  klik_ok(Key);
end;


initialization
  {$I flogin.lrs}

end.
