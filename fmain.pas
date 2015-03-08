unit fmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Menus, StdCtrls, ExtCtrls, Grids, DBGrids, Variants, sqldb, db;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btFileOpen: TButton;
    btExecute: TButton;
    btCreateProducts: TButton;
    cbTypeImport: TComboBox;
    edFile: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    lbCreatedCount: TLabel;
    lbX: TLabel;
    lbUzivatel: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lbCount: TLabel;
    lbImportCount: TLabel;
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
    ProgressBar2: TProgressBar;
    SQLQuery1: TSQLQuery;
    StatusBar1: TStatusBar;
    procedure btCreateProductsClick(Sender: TObject);
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

uses dabout, ComObj, cestina, Data_module;

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
      xx,yy,cnt: LongInt;
begin
 XLApp := CreateOleObject('Excel.Application'); // comobj
 try
   cnt := 0;
   btExecute.Enabled := false;
   btFileOpen.Enabled := false;
   XLApp.Visible := False;         // Hide Excel
   XLApp.DisplayAlerts := False;
   path := edFile.Text;
   XLApp.Workbooks.Open(Path);     // Open the Workbook
   xx := XLApp.WorkBooks[1].WorkSheets[1].UsedRange.Rows.Count;
   yy := XLApp.WorkBooks[1].WorkSheets[1].UsedRange.Columns.Count;
   lbCount.Caption := IntToStr(xx);
   ProgressBar1.Position := 0;
   ProgressBar1.Min := 0;
   ProgressBar1.Max := xx;
   lbX.caption := '0';
   SQLQuery1.SQL.Text := 'DELETE import_produkty_nike';
   SQLQuery1.ExecSQL;
   DM.SQLTransaction.Commit;
   SQLQuery1.SQL.Text :=
     'insert into import_produkty_nike ' +
     ' (ARTICLE, MODEL_NUMBER, MODEL_NAME, COLOUR, NET_PRICE, REC_REC_PRICE, LAUNCH_WEEK, SIZE_DESCR, EAN_NUMBER, BRAND, SIZE_INDEX, DIVISION_ID, DIVISION_DESCR_L, SPORTS_CODE_ID, SPORTS_CODE_DESCR_L, GEND, GENDER_NAME, USERCODE, ARTICLE_DESCR_L, COLOUR_COMB_DESCR_L, PRODUCT_GROUP_ID, PRODUCT_GROUP_NAME, PRODUCT_TYPE_ID, PRODUCT_TYPE_NAME, GENDER, AGE, MATERIAL) ' +
     'values ' +
     ' (:ARTICLE, :MODEL_NUMBER, :MODEL_NAME, :COLOUR, :NET_PRICE, :REC_REC_PRICE, :LAUNCH_WEEK, :SIZE_DESCR, :EAN_NUMBER, :BRAND, :SIZE_INDEX, :DIVISION_ID, :DIVISION_DESCR_L, :SPORTS_CODE_ID, :SPORTS_CODE_DESCR_L, :GEND, :GENDER_NAME, :USERCODE, :ARTICLE_DESCR_L, :COLOUR_COMB_DESCR_L, :PRODUCT_GROUP_ID, :PRODUCT_GROUP_NAME, :PRODUCT_TYPE_ID, :PRODUCT_TYPE_NAME, :GENDER, :AGE, :MATERIAL)';
   for x := 2 to xx do
   begin
     ProgressBar1.StepIt;
     lbX.caption := IntToStr(x);
     // ARTICLE
     SQLQuery1.ParamByName('ARTICLE').AsString := Win2Utf(XLApp.Cells[x,1].Value);
     // MODEL_NUMBER
     SQLQuery1.ParamByName('MODEL_NUMBER').AsString := Win2Utf(XLApp.Cells[x,2].Value);
     // MODEL_NAME
     SQLQuery1.ParamByName('MODEL_NAME').AsString := Win2Utf(XLApp.Cells[x,3].Value);
     // COLOUR
     SQLQuery1.ParamByName('COLOUR').AsString := Win2Utf(XLApp.Cells[x,4].Value);
     // NET_PRICE
     SQLQuery1.ParamByName('NET_PRICE').AsString := Win2Utf(XLApp.Cells[x,5].Value);
     // REC_REC_PRICE
     SQLQuery1.ParamByName('REC_REC_PRICE').AsString := Win2Utf(XLApp.Cells[x,6].Value);
     // LAUNCH_WEEK
     SQLQuery1.ParamByName('LAUNCH_WEEK').AsString := Win2Utf(XLApp.Cells[x,7].Value);
     // SIZE_DESCR
     SQLQuery1.ParamByName('SIZE_DESCR').AsString := Win2Utf(XLApp.Cells[x,8].Value);
     // EAN_NUMBER
     SQLQuery1.ParamByName('EAN_NUMBER').AsString := Win2Utf(XLApp.Cells[x,9].Value);
     // BRAND
     SQLQuery1.ParamByName('BRAND').AsString := Win2Utf(XLApp.Cells[x,10].Value);
     // SIZE_INDEX
     SQLQuery1.ParamByName('SIZE_INDEX').AsString := Win2Utf(XLApp.Cells[x,11].Value);
     // DIVISION_ID
     SQLQuery1.ParamByName('DIVISION_ID').AsString := Win2Utf(XLApp.Cells[x,12].Value);
     // DIVISION_DESCR_L
     SQLQuery1.ParamByName('DIVISION_DESCR_L').AsString := Win2Utf(XLApp.Cells[x,13].Value);
     // SPORTS_CODE_ID
     SQLQuery1.ParamByName('SPORTS_CODE_ID').AsString := Win2Utf(XLApp.Cells[x,14].Value);
     // SPORTS_CODE_DESCR_L
     SQLQuery1.ParamByName('SPORTS_CODE_DESCR_L').AsString := Win2Utf(XLApp.Cells[x,15].Value);
     // GEND
     SQLQuery1.ParamByName('GEND').AsString := Win2Utf(XLApp.Cells[x,16].Value);
     // GENDER_NAME
     SQLQuery1.ParamByName('GENDER_NAME').AsString := Win2Utf(XLApp.Cells[x,17].Value);
     // USERCODE
     SQLQuery1.ParamByName('USERCODE').AsString := Win2Utf(XLApp.Cells[x,18].Value);
     // ARTICLE_DESCR_L
     SQLQuery1.ParamByName('ARTICLE_DESCR_L').AsString := Win2Utf(XLApp.Cells[x,19].Value);
     // COLOUR_COMB_DESCR_L
     SQLQuery1.ParamByName('COLOUR_COMB_DESCR_L').AsString := Win2Utf(XLApp.Cells[x,20].Value);
     // PRODUCT_GROUP_ID
     SQLQuery1.ParamByName('PRODUCT_GROUP_ID').AsString := Win2Utf(XLApp.Cells[x,21].Value);
     // PRODUCT_GROUP_NAME
     SQLQuery1.ParamByName('PRODUCT_GROUP_NAME').AsString := Win2Utf(XLApp.Cells[x,22].Value);
     //PRODUCT_TYPE_ID
     SQLQuery1.ParamByName('PRODUCT_TYPE_ID').AsString := Win2Utf(XLApp.Cells[x,23].Value);
     // PRODUCT_TYPE_NAME
     SQLQuery1.ParamByName('PRODUCT_TYPE_NAME').AsString := Win2Utf(XLApp.Cells[x,24].Value);
     // GENDER
     SQLQuery1.ParamByName('GENDER').AsString := Win2Utf(XLApp.Cells[x,25].Value);
     // AGE
     SQLQuery1.ParamByName('AGE').AsString := Win2Utf(XLApp.Cells[x,26].Value);
     // MATERIAL
     SQLQuery1.ParamByName('MATERIAL').AsString := Win2Utf(XLApp.Cells[x,27].Value);
     // POST
     SQLQuery1.ExecSQL;
     DM.SQLTransaction.Commit;
     cnt := cnt + 1;
     lbImportCount.caption := IntToStr(cnt);
   end;
   ShowMessage('Import skončil');
 finally
   XLApp.Quit;
   XLAPP := Unassigned;
   btExecute.Enabled := true;
   btFileOpen.Enabled := true;
  end;
end;

procedure TfrmMain.btCreateProductsClick(Sender: TObject);
var
  Sqlquery : TSqlquery;
  NewParam : TParam;
begin
 try
  ProgressBar2.style := pbstMarquee;
  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'delete sessionid_temp where kod = ''IMPORT_NIKE'' and sessionid = 999999';
  DM.SQLTransaction.active := false;
  DM.SQLTransaction.StartTransaction;
  SQLQuery1.ExecSQL;
  DM.SQLTransaction.Commit;

  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'begin import_produktu_nike; end;';
  {SQLQuery1.Params.Clear;
  NewParam := TParam.Create(Sqlquery.Params);
  NewParam.Name := 'text';
  NewParam.DataType := ftString;
  NewParam.ParamType := ptOutput;
  SQLQuery1.Params.AddParam(NewParam);}
  ShowMessage('Krok 0');
  //SQLQuery1.Prepare;
  ShowMessage('Krok 1');
  DM.SQLTransaction.active := false;
  DM.SQLTransaction.StartTransaction;
  SQLQuery1.ExecSQL;
  ShowMessage('Krok 2');
  DM.SQLTransaction.Commit;
  ShowMessage('Krok 3');
  //lbCreatedCount.caption := SQLQuery1.Params.ParamByName('text').AsString;

  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'select s1 from sessionid_temp where kod = ''IMPORT_NIKE'' and sessionid = 999999';
  SQLQuery1.Open;
  lbCreatedCount.caption := SQLQuery1.FieldByName('S1').AsString;
  SQLQuery1.Close;

  ProgressBar2.style := pbstNormal;
  ProgressBar2.position := 100;
  ShowMessage('Založení produktů proběhlo');
 finally
   ProgressBar2.style := pbstNormal;
 end;
end;

end.

