unit fmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, ExtCtrls, Grids, Variants;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    Button1: TButton;
    btFileOpen: TButton;
    btExecute: TButton;
    cbTypeImport: TComboBox;
    edFile: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lbUzivatel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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

uses dabout, ComObj;

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

function Xls_To_StringGrid(AGrid: TStringGrid; AXLSFile: string): Boolean;
const
  xlCellTypeLastCell = $0000000B;
var
  XLApp, Sheet: OLEVariant;
  RangeMatrix: Variant;
  x, y, k, r: Integer;
begin
  Result := False;
  // Create Excel-OLE Object
  XLApp := CreateOleObject('Excel.Application');
  try
    // Hide Excel
    XLApp.Visible := False;

    // Open the Workbook
    XLApp.Workbooks.Open(AXLSFile);

    // Sheet := XLApp.Workbooks[1].WorkSheets[1];
    Sheet := XLApp.Workbooks[ExtractFileName(AXLSFile)].WorkSheets[1];

    // In order to know the dimension of the WorkSheet, i.e the number of rows
    // and the number of columns, we activate the last non-empty cell of it

    Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
    // Get the value of the last row
    x := XLApp.ActiveCell.Row;
    // Get the value of the last column
    y := XLApp.ActiveCell.Column;

    // Set Stringgrid's row &col dimensions.

    AGrid.RowCount := x;
    AGrid.ColCount := y;

    // Assign the Variant associated with the WorkSheet to the Delphi Variant

    RangeMatrix := XLApp.Range['A1', XLApp.Cells.Item[X, Y]].Value;
    //  Define the loop for filling in the TStringGrid
    k := 1;
    repeat
      for r := 1 to y do
        AGrid.Cells[(r - 1), (k - 1)] := RangeMatrix[K, R];
      Inc(k, 1);
      AGrid.RowCount := k + 1;
    until k > x;
    // Unassign the Delphi Variant Matrix
    RangeMatrix := Unassigned;

  finally
    // Quit Excel
    if not VarIsEmpty(XLApp) then
    begin
      // XLApp.DisplayAlerts := False;
      XLApp.Quit;
      XLAPP := Unassigned;
      Sheet := Unassigned;
      Result := True;
    end;
  end;
end;

procedure TfrmMain.btExecuteClick(Sender: TObject);
var
  Cols: integer;
  Rows: integer;
  IntCellValue: integer;
  Excel, XLSheet: Variant;
  failure: Integer;

begin
  failure:=0;
  try
    Excel:=CreateOleObject('Excel.Application');
  except
    failure:=1;
  end;
  if failure = 0 then
  begin
    Excel.Visible:=False;
    Excel.WorkBooks.Open(edFile.Text);
    XLSheet := Excel.Worksheets[1];
    Cols := XLSheet.UsedRange.Columns.Count;
    Rows := XLSheet.UsedRange.Rows.Count;

    // Value of the 1st Cell
    IntCellValue:=Excel.Cells[1, 1].Value;
    // Iterate Cals/Rows to read the data section in your worksheet
    // and you can write it in Paradox using the BDE by iterating all cells
    // somthing like this pseudo code:

      try
        //Query := TSQLQuery.Create(nil)
        //Query.Databasename := PdxDBName; // must be configured in the BDE
        while Rows > 0 do
        begin
          while Cols > 0 do
          begin
            IntCellValue:=Excel.Cells[Cols,Rows].Value;
            //Query.SQL.text := // SQLStmt including the IntCellValue
            //ExecSQL;
            ShowMessage(AnsiString(IntCellValue));
            dec(Cols);
          end;
          Cols := XLSheet.UsedRange.Columns.Count;
        Dec(Rows);
        end;
      finally
        //Query.Free;
      end;

    Excel.Workbooks.Close;
    Excel.Quit;
    Excel:=Unassigned;
  end;
end;

//begin
//  if Xls_To_StringGrid(StringGrid, edFile.Text) then
//    ShowMessage('Table has been imported!');
//end;

end.

