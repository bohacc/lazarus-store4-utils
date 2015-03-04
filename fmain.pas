unit fmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, ExtCtrls, Grids, Variants;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btFileOpen: TButton;
    btExecute: TButton;
    btStop: TButton;
    cbTypeImport: TComboBox;
    edFile: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lbY: TLabel;
    Label5: TLabel;
    lbX: TLabel;
    lbUzivatel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbCount: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MainMenu: TMainMenu;
    miImport: TMenuItem;
    miAbout: TMenuItem;
    miHelp: TMenuItem;
    miFile: TMenuItem;
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    pImport: TPanel;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    StringGrid: TStringGrid;
    procedure btExecuteClick(Sender: TObject);
    procedure btFileOpenClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
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

uses dabout, ComObj, cestina;

{$R *.lfm}

{ TfrmMain }

var stop: boolean;

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

procedure TfrmMain.GroupBox1Click(Sender: TObject);
begin

end;

procedure TfrmMain.btFileOpenClick(Sender: TObject);
begin
  if OpenDialog.execute then
      edFile.Text:=OpenDialog.Filename;
end;

procedure TfrmMain.btStopClick(Sender: TObject);
begin
  stop := true;
end;

procedure TfrmMain.btExecuteClick(Sender: TObject);
Var XLApp: OLEVariant;
      x,y: LongInt;
      path: variant;
      xx,yy: LongInt;
begin
 XLApp := CreateOleObject('Excel.Application'); // comobj
 try
   btExecute.Enabled := false;
   btFileOpen.Enabled := false;
   btStop.Enabled := true;
   XLApp.Visible := False;         // Hide Excel
   XLApp.DisplayAlerts := False;
   path := edFile.Text;
   XLApp.Workbooks.Open(Path);     // Open the Workbook
   xx := XLApp.WorkBooks[1].WorkSheets[1].UsedRange.Rows.Count;
   yy := XLApp.WorkBooks[1].WorkSheets[1].UsedRange.Columns.Count;
   StringGrid.ColCount := yy;
   StringGrid.RowCount := xx;
   lbCount.Caption := IntToStr(xx);
   ProgressBar1.Position := 0;
   ProgressBar1.Min := 0;
   ProgressBar1.Max := xx;
   lbX.caption := '0';
   lbY.caption := '0';
   for x := 1 to xx do
   begin
     ProgressBar1.StepIt;
     for y := 1 to yy do
     begin
       lbX.caption := IntToStr(x);
       lbY.caption := IntToStr(y);
       StringGrid.Cells[y-1,x-1] := Win2Utf(XLApp.Cells[x,y].Value);
       if stop then exit;
     end;
     if stop then exit;
   end;
 finally
   XLApp.Quit;
   XLAPP := Unassigned;
   btExecute.Enabled := true;
   btFileOpen.Enabled := true;
   btStop.Enabled := false;
  end;
end;

end.

