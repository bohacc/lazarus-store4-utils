unit fmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, ExtCtrls;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    btFileOpen: TButton;
    Button2: TButton;
    cbTypeImport: TComboBox;
    edFile: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MainMenu: TMainMenu;
    miImport: TMenuItem;
    miAbout: TMenuItem;
    miHelp: TMenuItem;
    miFile: TMenuItem;
    OpenDialog: TOpenDialog;
    pImport: TPanel;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    procedure btFileOpenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miFileClick(Sender: TObject);
    procedure miImportClick(Sender: TObject);
    procedure pImportClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses dabout;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.miFileClick(Sender: TObject);
begin

end;

procedure TfrmMain.miImportClick(Sender: TObject);
begin
  pImport.visible:=true;
end;

procedure TfrmMain.pImportClick(Sender: TObject);
begin

end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  if not(Assigned(frmAbout)) then
      Application.CreateForm(TfrmAbout,frmAbout);
  frmAbout.ShowModal;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  pImport.Visible:=false;
end;

procedure TfrmMain.btFileOpenClick(Sender: TObject);
begin
  if OpenDialog.execute then
      edFile.Text:=OpenDialog.Filename;
end;

end.

