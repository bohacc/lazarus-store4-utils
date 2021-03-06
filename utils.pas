unit Utils;

{$mode objfpc}{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uConsts, Menus, ToolWin, ComCtrls,
  ExtCtrls, StdCtrls, ImgList, ActnList, DB,
  DBCtrls, DBGrids, sqldb;

function AppVerze(const Filename: string): string;
function Replace_char(_Str: string; _RepStr: string = ' ';
  _NewRepStr: string = ''): string;
function InitMenu(_MainMenu: TMainMenu; _Name: string; _Caption: TCaption;
  Sort: integer = -1): boolean;
procedure InitPopup(_PopupMenu: TPopupMenu; _Name: string;
  _Caption: TCaption; _OnClick: TNotifyEvent;
  _Checked: boolean = False; _Enable: boolean = True);
function ExecSql_old(_sql: string): string;
procedure ExecSql(_sql: string);
procedure miMainMenuClick(Sender: TObject);
procedure InitDBComboSQL(_SQL: string; _ComboBox: TDBComboBox);
procedure InitComboSQL(_SQL: string; _ComboBox: TComboBox);
function Get_cached_int(_sql: string; _text: string): integer;
function Get_cached_string(_sql: string; _text: string): string;
function Get_licence(_str: string): boolean;
function Get_ComputerName: string;
function Get_UserName: string;
function GetDiskInfo(Disk: char; var sVolName, sVolBuff: string;
  var iSerNum: integer): boolean;
function generuj_uc(_s: string; lan: integer = 0): string;
//function Diakritika(_s : char) : char;
function Q(s: string): string;
function get_param(s: string): string;

function porovnej_ref_kod(astr, amaska, odd: string): integer;
function najdi_ref_kod(astr, amaska, odd: string): string;
function najdi_ucet(astr: string): string;
function najdi_var_symb(astr: string): string;
function najdi_podani_doruceno(astr: string): string;
function najdi_bezne_cislo(astr: string): string;
function najdi_podani_overeno(astr: string): string;
function najdi_zaslanych_priloh(astr: string): string;
function najdi_zpusob_podani(astr: string): string;
function najdi_podpis_cert_platny(astr: string): string;
function najdi_soud(astr: string): string;
function najdi_typ_formulare(astr: string): string;
function najdi_spis_znacka(astr: string): string;
function najdi_ke_zpracovani(astr: string): string;
function replace(str: string; find: string; new: string): string;
function neprelozitelne_objekty: boolean;
function getDateFormat(str: string): string;
function getIdOrName(str: string; typeOper: integer; comma: string): string;

var
  _savebookmark: TBookmarkStr;

implementation

uses Data_module, FMain;

function Replace_char(_Str: string; _RepStr: string = ' ';
  _NewRepStr: string = ''): string;
var
  i: integer;
  w: string;
begin
  w := _Str;
  if _Str <> '' then
  begin
    w := '';
    for i := 1 to Length(_Str) do
    begin
      if _Str[i] = _RepStr then
        w := w + _NewRepStr
      else
        w := w + _Str[i];
    end;

  end;
  Result := w;
end;

function AppVerze(const Filename: string): string;
var
  dwHandle: THandle;
  dwSize:   DWORD;
  lpData, lpData2: Pointer;
  uiSize:   UINT;
begin
  Result := '';
  dwSize := GetFileVersionInfoSize(PChar(FileName), dwSize);
  if dwSize <> 0 then
  begin
    GetMem(lpData, dwSize);
    if GetFileVersionInfo(PChar(FileName), dwHandle, dwSize, lpData) then
    begin
      uiSize := Sizeof(TVSFixedFileInfo);
      VerQueryValue(lpData, '\', lpData2, uiSize);
      with PVSFixedFileInfo(lpData2)^ do
        Result := Format('%d.%02d.%02d.%02d', [HiWord(dwProductVersionMS),
          LoWord(dwProductVersionMS), HiWord(dwProductVersionLS), LoWord(dwProductVersionLS)]);
    end;
    FreeMem(lpData, dwSize);
  end;
end;

function InitMenu(_MainMenu: TMainMenu; _Name: string; _Caption: TCaption;
  Sort: integer = -1): boolean;
var
  MenuItem: TMenuItem;
begin
  try
    MenuItem := TMenuItem.Create(nil);

    if Sort = -1 then
    begin
      MenuItem      := TMenuItem.Create(nil);
      MenuItem.Name := _Name;
      MenuItem.Caption := _Caption;
      _MainMenu.Items.Add(MenuItem);
    end
    else
    begin
      MenuItem      := TMenuItem.Create(nil);
      MenuItem.Name := _Name;
      MenuItem.Caption := _Caption;
      _MainMenu.Items[Sort].Add(MenuItem);
    end;

{  if Sort= -1 then
  begin
   MenuItem:=TMenuItem.Create(nil);
   MenuItem.Name:=_Name;
   MenuItem.Caption:=_Caption;
   MainMenu.Items.Add(MenuItem);
  end;

  if Sort = 0 then
  begin
   MenuItem:=TMenuItem.Create(nil);
   MenuItem.Name:=_Name;
   MenuItem.Caption:=_Caption;
   MainMenu.Items[0].Add(MenuItem);
  end;

  if Sort = 1 then
  begin
   MenuItem:=TMenuItem.Create(nil);
   MenuItem.Name:=_Name;
   MenuItem.Caption:=_Caption;
   MainMenu.Items[1].Add(MenuItem);
  end;
}
    Result := True;
  finally
  end;
end;

procedure InitPopup(_PopupMenu: TPopupMenu; _Name: string;
  _Caption: TCaption; _OnClick: TNotifyEvent;
  _Checked: boolean = False; _Enable: boolean = True);
var
  MenuItem: TMenuItem;
begin
  try
    MenuItem      := TMenuItem.Create(nil);
    MenuItem.Caption := _Caption;
    MenuItem.Name := _Name;
    MenuItem.OnClick := _OnClick;
    MenuItem.Checked := _Checked;
    MenuItem.Enabled := _Enable;

    _PopupMenu.Items.Add(MenuItem);
  finally
  end;
end;

{
procedure commit_tr(_DataSet : TDataSet; _Transaction : TTransaction);
var
_save : TBookmarkStr;
_hwnd : HWND;
begin
 _save := _DataSet.Bookmark;
 try
   try
    _DataSet.DisableControls;
    _Transaction.Commit;
    _DataSet.Open;
   finally
    _DataSet.EnableControls;
    _DataSet.Bookmark:=_save;
   end;
 except
   MessageBox(_hwnd,'Chyba při commitu transakce.','Chyba',MB_OK);
 end;
end;

procedure rollback_tr(_DataSet : TIBDataSet; _Transaction : TIBTransaction);
var
_save : TBookmarkStr;
_hwnd : HWND;
begin
 _save := _DataSet.Bookmark;
 try
   try
    _DataSet.DisableControls;
    _Transaction.Rollback;
    _DataSet.Open;
   finally
    _DataSet.EnableControls;
    _DataSet.Bookmark:=_save;
   end;
 except
   MessageBox(_hwnd,'Chyba při rollbacku transakce.','Chyba', MB_OK);
 end;
end;
}

function ExecSql_old(_sql: string): string;
var
  _Query: TSQLQuery;
  _Value: string;
begin
  _Query := nil;
  try
    _Query := TSQLQuery.Create(nil);
    _Query.Database := DM.OracleConnection;
    _Query.ReadOnly := False;
    //_Query.Transaction:=DM.SQLTransaction;
    _Query.SQL.Text := _sql;
    _Query.Open;

    _Value := _Query.Fields.Fields[0].AsString;
    //if _Value = '' then _Value:='0';
    Result := _Value;
  finally
    if Assigned(_Query) then
    begin
      _Query.Close;
      _Query.Free;
      _Query := nil;
    end;
  end;
end;

procedure ExecSql(_sql: string);
var
  _Query: TSQLQuery;
begin
  _Query := nil;
  try
    _Query := TSQLQuery.Create(nil);
    _Query.Database := DM.OracleConnection;
    _Query.ReadOnly := False;
    //_Query.Transaction:=DM.SQLTransaction;
    _Query.SQL.Text := _sql;
    _Query.ExecSQL;

  finally
    if Assigned(_Query) then
    begin
      _Query.Close;
      _Query.Free;
      _Query := nil;
    end;
  end;
end;

procedure miMainMenuClick(Sender: TObject);
begin
  TForm(Sender).Show;
end;

procedure InitComboSQL(_SQL: string; _ComboBox: TComboBox);
var
  _Query: TSQLQuery;
begin
  _Query := nil;
  try
    _Query := TSQLQuery.Create(nil);
    _Query.Database := DM.OracleConnection;
    _Query.ReadOnly := False;
    //_Query.Transaction:=DM.SQLTransaction;
    _Query.SQL.Text := _SQL;
    _Query.Open;
    _ComboBox.Items.Clear;

    while not _Query.EOF do
    begin
      _ComboBox.Items.Add(_Query.Fields.Fields[0].AsString);
      _Query.Next;
    end;

  finally
    if Assigned(_Query) then
    begin
      _Query.Close;
      _Query.Free;
      _Query := nil;
    end;
  end;

end;

procedure InitDBComboSQL(_SQL: string; _ComboBox: TDBComboBox);
var
  _Query: TSQLQuery;
begin
  _Query := nil;
  try
    _Query := TSQLQuery.Create(nil);
    _Query.Database := DM.OracleConnection;
    _Query.ReadOnly := False;
//    _Query.Transaction:=DM.SQLTransaction;
    _Query.SQL.Text := _SQL;
    _Query.Open;
    _ComboBox.Items.Clear;

    while not _Query.EOF do
    begin
      _ComboBox.Items.Add(_Query.Fields.Fields[0].AsString);
      _Query.Next;
    end;

  finally
    if Assigned(_Query) then
    begin
      _Query.Close;
      _Query.Free;
      _Query := nil;
    end;
  end;

end;

function Get_cached_int(_sql: string; _text: string): integer;
var
  _Query: TSQLQuery;
  _c:     string;
begin
  _Query := nil;
  try
    _Query := TSQLQuery.Create(nil);
    _Query.Database := DM.OracleConnection;
    _Query.ReadOnly := False;
//    _Query.Transaction:=DM.SQLTransaction;
    _c     := _SQL + '''' + _text + '''';
    _Query.SQL.Text := _c;
    _Query.Open;

    Result := _Query.Fields.Fields[0].AsInteger;
  finally
    if Assigned(_Query) then
    begin
      _Query.Close;
      _Query.Free;
      _Query := nil;
    end;
  end;

end;

function Get_cached_string(_sql: string; _text: string): string;
var
  _Query: TSQLQuery;
  _c:     string;
  _r:     string;
begin
  _r     := '';
  _Query := nil;
  try
    _Query := TSQLQuery.Create(nil);
    _Query.Database := DM.OracleConnection;
    _Query.ReadOnly := False;
//    _Query.Transaction:=DM.SQLTransaction;
    _c     := _SQL + _text;
    _Query.SQL.Text := _c;
    if _text <> '' then
    begin
      _Query.Open;
      _r := _Query.Fields.Fields[0].AsString;
    end;
  finally
    if Assigned(_Query) then
    begin
      _Query.Close;
      _Query.Free;
      _Query := nil;
    end;
  end;

  Result := _r;

end;

function Get_licence(_str: string): boolean;
var
  r:      boolean;
  _l, _c: string;
  _Query: TSQLQuery;
begin
  r      := False;
  _Query := nil;
  try
    _Query := TSQLQuery.Create(nil);
    _Query.Database := DM.OracleConnection;
    _Query.ReadOnly := False;
//    _Query.Transaction:=DM.SQLTransaction;
    _c     := 'SELECT KOD FROM LICENCE';
    _Query.SQL.Text := _c;
    _Query.Open;
    _l := _Query.Fields.Fields[0].AsString;
  finally
    if Assigned(_Query) then
    begin
      _Query.Close;
      _Query.Free;
      _Query := nil;
    end;
  end;

  if length(_l) <> 13 then
  begin
    r := False;
  end
  else
  begin

    r := True;
  end;

  Result := r;
end;

function Get_ComputerName: string;
const
  cnMaxLen = 254;
var
  sCompName:     string;
  dwCompNameLen: DWord;
begin
  Result := '';
  dwCompNameLen := cnMaxLen - 1;
  SetLength(sCompName, cnMaxLen);
  GetComputerName(PChar(sCompName), dwCompNameLen);
  SetLength(sCompName, dwCompNameLen);
  Result := sCompName;
  if dwCompNameLen = cnMaxLen - 1 then
    Result := '';
end;

function Get_UserName: string;
const
  cnMaxLen = 254;
var
  sUserName:     string;
  dwUserNameLen: DWord;
begin
  Result := '';
  dwUserNameLen := cnMaxLen - 1;
  SetLength(sUserName, cnMaxLen);
  GetUserName(PChar(sUserName), dwUserNameLen);
  SetLength(sUserName, dwUserNameLen);
  Result := sUserName;
  if dwUserNameLen = cnMaxLen - 1 then
    Result := '';
end;

function GetDiskInfo(Disk: char; var sVolName, sVolBuff: string;
  var iSerNum: integer): boolean;
var
  VolName: array [0..255] of char;
  DriveName: array [0..255] of char;
  VolNameSize: integer;
  MaxCompLength: cardinal;
  FSNameBuffer: array [0..255] of char;
  FSNameSize: integer;
  Flags: cardinal;
begin
  // Nastevení a vymazání základních parametru
  Result := False;
  FillChar(DriveName, SizeOf(DriveName), #0);
  FillChar(VolName, SizeOf(VolName), #0);
  FillChar(FSNameBuffer, SizeOf(FSNameBuffer), #0);

  VolNameSize := SizeOf(VolName);
  FSNameSize  := SizeOf(FSNameBuffer);

  // Nastavení názvu disku
  DriveName[0] := Disk;
  DriveName[1] := ':';
  DriveName[2] := #92;

  // Získání vlastních informací pomocí GetVolumeInformation
  Result := GetVolumeInformation(DriveName, VolName, VolNameSize,
    @iSerNum, MaxCompLength, Flags, FSNameBuffer, FSNameSize);

  // Naplnění předávaných parametrů
  sVolName := StrPas(VolName);
  sVolBuff := StrPas(FSNameBuffer);
end;

function generuj_uc(_s: string; lan: integer = 0): string;
var
  uc, s: string;
  i, n:  integer;
begin

  if lan = 1 then
    s := _s
  else
    s := _s + Get_ComputerName + Get_UserName;
  for i := 1 to length(s) do
  begin
    n  := Ord(s[i]);
    uc := uc + IntToStr(n);
  end;

  Result := uc;

end;

{function Diakritika(_s : char) : char;
var
_c : char;
_n : string;
_m : string;
_abc : string;
i : integer;
ii : integer;
begin
 try  // 123456789ABCDEF
  _n := 'ÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ';
  _m := 'ACDEEINORSTUUYZ';
  _abc := '';

  i:=0;
  while i < length(_n) do
   begin
    i:=i+1;
    if _n[i] = _s then
      _c:=_m[i];
   end;

  if _c = '' then
  begin
    ii:=0;
    while ii < length(_abc) do
     begin
       ii:=ii+1;
       if _abc[ii] = _s then
         _c:=_s;
     end;
  end;

 finally
   Result := _c;
 end;
end;
}

function Q(s: string): string;
var
  str: string;
begin
  str    := '''' + s + '''';
  Result := str;
end;

function get_param(s: string): string;
var
  r: string;
begin
  try
    r      := ExecSql_old('SELECT HODNOTA FROM PARAMETRY WHERE KOD=' + Q(s));
    Result := r;
  except
    Result := '';
  end;
end;

function porovnej_ref_kod(astr, amaska, odd: string): integer;
var
  p, n, pocet: integer;
  aSTR_TMP, aSTR_MASKA, aTMP, aTMP_MASKA: string;
begin
  try
    p     := 1;
    n     := 0;
    pocet := 0;

    aTMP := aMASKA;
    while POS(odd, aTMP) > 0 do
    begin
      aTMP  := copy(aTMP, POS(odd, aTMP) + 1, length(aTMP) - POS(odd, aTMP));
      pocet := pocet + 1;
    end;

    aSTR_TMP   := aSTR;
    aSTR_MASKA := aMASKA;
    while POS(odd, aSTR_TMP) > 0 do
    begin
      n := n + 1;
      if POS(odd, aSTR_TMP) <> POS(odd, aSTR_MASKA) then
      begin
        p := 0;
        exit;
      end;
      aSTR_TMP   := copy(aSTR_TMP, POS(odd, aSTR_TMP) + 1, length(aSTR_TMP) - POS(odd, aSTR_TMP));
      aSTR_MASKA := copy(aSTR_MASKA, POS(odd, aSTR_MASKA) + 1, length(aSTR_MASKA) -
        POS(odd, aSTR_MASKA));
    end;

    if n <> pocet then
      p := 0;

    Result := p;

  except
    Result := 0;
  end;
end;

function najdi_ref_kod(astr, amaska, odd: string): string;
var
  p, aPOCET_PRED, aPOCET_CELKEM, aPOCET_ZA: integer;
  aSTR_TMP, aTMP, aREF_KOD: string;
begin
  try
    aPOCET_PRED   := POS(odd, aMASKA) - 1;
    aPOCET_CELKEM := LENGTH(aMASKA);
    aSTR_TMP      := aSTR;
    while POS(odd, aSTR_TMP) > 0 do
    begin
      aTMP     := copy(aSTR_TMP, POS(odd, aSTR_TMP) + 1, length(aSTR_TMP) - POS(odd, aSTR_TMP));
      aSTR_TMP := copy(aSTR_TMP, POS(odd, aSTR_TMP) - aPOCET_PRED, aPOCET_CELKEM);
      if porovnej_ref_kod(aSTR_TMP, aMASKA, odd) = 1 then
      begin
        aREF_KOD := aSTR_TMP;
        break;
      end
      else
        aSTR_TMP := aTMP;
    end;

    Result := aREF_KOD;

  except
    Result := '';
  end;
end;

function najdi_ucet(astr: string): string;
var
  r, f, Text: string;
  z, k: integer;
begin
  try
    Text := UTF8Encode(astr);
    f    := 'číslo účtu ';
    z    := pos(f, Text);
    if z = 0 then
    begin
      f := '?íslo ú?tu ';
      z := pos(f, Text);
    end;
    if z = 0 then
    begin
      f := '??slo ??tu ';
      z := pos(f, Text);
    end;
    //ShowMessage(IntToStr(z));
    k := pos('/', copy(Text, z + length(f), 30));
    if (k > 0) and (z > 0) then
      r := copy(Text, z + length(f), k + 4);
  finally
    Result := r;
  end;
end;

function najdi_var_symb(astr: string): string;
var
  r, f, t, s, Text: string;
  z, k: integer;
begin
  try
    Text := UTF8Encode(astr);
    f    := 'VS :';
    z    := pos(f, Text);
    if z = 0 then
    begin
      f := 'variabilním symbolem ';
      z := pos(f, Text);
    end;
    if z = 0 then
    begin
      f := 'variabiln?m symbolem ';
      z := pos(f, Text);
    end;
    if z > 0 then
    begin
      t := copy(Text, z + length(f), 10);
      for k := 1 to 10 do
      begin
        s := copy(t, k, 1);
        if pos(s, '0123456789') > 0 then
          r := r + s
        else
          break;
      end;
    end;
  finally
    Result := r;
  end;
end;

function najdi_podani_doruceno(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'doručeno dne ';
    z := pos(f, astr);
    if z = 0 then
    begin
      f := 'doru?eno dne ';
      z := pos(f, astr);
    end;
    if z = 0 then
    begin
      f := 'doručené dne ';
      z := pos(f, astr);
    end;
    if z = 0 then
    begin
      f := 'doru?ené dne ';
      z := pos(f, astr);
    end;
    if z > 0 then
      t := copy(astr, z + length(f), 21);
    {for k:=1 to 21 do
    begin
      s:=copy(t,k,1);
      if pos(s,'0123456789. :v')>0 then
        r:=r+s
      else
        break;
    end;}
  finally
    Result := t;
  end;
end;

function najdi_bezne_cislo(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'běžným číslem ';
    z := pos(f, astr);
    if z = 0 then
    begin
      f := 'b?žným ?íslem ';
      z := pos(f, astr);
    end;
    if z > 0 then
    begin
      t := copy(astr, z + length(f), 30);
      for k := 1 to 30 do
      begin
        s := copy(t, k, 1);
        if pos(s, '0123456789/') > 0 then
          r := r + s
        else
          break;
      end;
    end;
  finally
    Result := r;
  end;
end;

function najdi_podani_overeno(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'bylo ověřeno dne ';
    z := pos(f, astr);
    if z = 0 then
    begin
      f := 'a ověřené dne ';
      z := pos(f, astr);
    end;
    if z = 0 then
    begin
      f := 'bylo ov??eno dne ';
      z := pos(f, astr);
    end;
    if z > 0 then
      t := copy(astr, z + length(f), 21);
    {for k:=1 to 21 do
    begin
      s:=copy(t,k,1);
      if pos(s,'0123456789. :v')>0 then
        r:=r+s
      else
        break;
    end;}
  finally
    Result := t;
  end;
end;

function najdi_zaslanych_priloh(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'Počet zaslaných příloh: ';
    z := pos(f, astr);
    if z = 0 then
    begin
      f := 'Po?et zaslaných p?íloh: ';
      z := pos(f, astr);
    end;
    if z > 0 then
    begin
      t := copy(astr, z + length(f), 5);
      for k := 1 to 5 do
      begin
        s := copy(t, k, 1);
        if pos(s, '0123456789') > 0 then
          r := r + s
        else
          break;
      end;
    end;
  finally
    Result := r;
  end;
end;

function najdi_zpusob_podani(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'Bylo podáno ';
    z := pos(f, astr);
    if z > 0 then
      t := copy(astr, z + length(f), pos(' formulářem', astr) - (z + length(f)));
  finally
    Result := t;
  end;
end;

function najdi_podpis_cert_platny(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'byl vyhodnocen jako ';
    z := pos(f, astr);
    if z > 0 then
      t := copy(astr, z + length(f), pos('.', copy(astr, z + length(f), 30)) - 1);
  finally
    Result := t;
  end;
end;

function najdi_soud(astr: string): string;
var
  r, f, t, s, s2, st, st2, Text: string;
  z, k, p, p2: integer;
begin
  try
    Text := UTF8Encode(astr);
    f    := ' SOUD ';
    z    := pos(f, UpperCase(Text));
    //ShowMessage(IntToStr(z));
    if z > 0 then
    begin
      for k := 1 to 50 do
      begin
        s  := copy(Text, z - k, 1);
        s2 := copy(Text, z - (k + 5), 6);
        if (s = #13) or (s = #10) or (s = #13 + #10) or (s = #10 + #10) or (s2 = '<span>') then
          break
        else
        begin
          p  := k;
          st := s + st;
        end;
      end;
      for k := 1 to 50 do
      begin
        s  := copy(Text, (z - 1) + k, 1);
        s2 := copy(Text, (z - 1) + k, 7);
        if (s = #13) or (s = #10) or (s = #13 + #10) or (s = #10 + #10) or (s2 = '</span>') then
          break
        else
        begin
          p   := k;
          st2 := st2 + s;
        end;
      end;
    end;
    if (length(st) > 0) or (length(st2) > 0) then
      t := st + st2;
  finally
    Result := t;
  end;
end;

function najdi_typ_formulare(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'formulářem typu ';
    z := pos(f, astr);
    if z = 0 then
    begin
      f := 'formulá?em typu ';
      z := pos(f, astr);
    end;
    if z > 0 then
      t := copy(astr, z + length(f), pos('.', copy(astr, z + length(f), 30)) - 1);
  finally
    Result := t;
  end;
end;

function najdi_spis_znacka(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'spisové značce "';
    z := pos(f, astr);
    if z = 0 then
    begin
      f := 'spisové zna?ce "';
      z := pos(f, astr);
    end;
    if z > 0 then
      t := copy(astr, z + length(f), pos('" a ke', copy(astr, z + length(f), 30)) - 1);
  finally
    Result := t;
  end;
end;

function najdi_ke_zpracovani(astr: string): string;
var
  r, f, t, s: string;
  z, k: integer;
begin
  try
    f := 'ke zpracování dne ';
    z := pos(f, astr);
    if z > 0 then
      t := copy(astr, z + length(f), 21);
  finally
    Result := t;
  end;
end;

function replace(str: string; find: string; new: string): string;
var
  r:    string;
  p, i: integer;
begin
  r := str;
  i := 0;
  while pos(find, r) > 0 do
  begin
    //ShowMessage(r+'A');
    p := pos(find, r);
    //ShowMessage(IntToStr(p));
    if p > 1 then
      r := copy(r, 1, p - 1) + new + copy(r, p + length(find), length(r) - (p - 1 + length(find)))
    else
      r := new + copy(r, p + length(find), length(r) - (p - 1 + length(find)));
    i := i + 1;
    //ShowMessage(IntToStr(i));
    if i > 32000 then
      break;
    //ShowMessage(r+'B');
  end;
  Result := r;
end;

function neprelozitelne_objekty: boolean;
var
  r: boolean;
  v: string;
begin
  r := False;
  try
    v := ExecSql_old('Select count(*) From user_objects where status <> ''VALID''');
    r := 0 < StrToInt(v);
  finally
  end;
  Result := r;
end;

function getDateFormat(str: string): string;
var
  tmp, fmt, del: string;
begin
  try
    tmp := str;
    fmt := ExecSql_old('SELECT MAX(DATE_FORMAT) FROM NASTAVENI_SYSTEMU');
    if length(fmt) > 0 then
    begin
      fmt := replace(fmt, '0', '');
      fmt := replace(fmt, '1', '');
      fmt := replace(fmt, '2', '');
      fmt := replace(fmt, '3', '');
      fmt := replace(fmt, '4', '');
      fmt := replace(fmt, '5', '');
      fmt := replace(fmt, '6', '');
      fmt := replace(fmt, '7', '');
      fmt := replace(fmt, '8', '');
      fmt := replace(fmt, '9', '');
      fmt := copy(fmt, 1, 1);

      del := str;
      del := replace(del, '0', '');
      del := replace(del, '1', '');
      del := replace(del, '2', '');
      del := replace(del, '3', '');
      del := replace(del, '4', '');
      del := replace(del, '5', '');
      del := replace(del, '6', '');
      del := replace(del, '7', '');
      del := replace(del, '8', '');
      del := replace(del, '9', '');
      del := copy(del, 1, 1);
      tmp := replace(str, del, fmt);

    end;
  except
    tmp := str;
  end;
  Result := tmp;
end;

function getIdOrName(str: string; typeOper: integer; comma: string): string;
var
  tmp, del: string;
  pos: integer;
begin
  try
    pos := AnsiPos(comma, str);
    if pos > 0 then
    begin
      if typeOper = 0 then
        tmp := Copy(str, 1, pos - 1)
      else
        tmp := Copy(str, pos + 1, Length(str) - Length(Copy(str, 1, pos)));
    end;
  except
    tmp := '';
  end;
  Result := tmp;
end;

end.

