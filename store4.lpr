program store4;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, fmain, dabout, flogin, Data_module, Utils, uConsts, cestina
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.ShowMainForm:=False;
  Application.CreateForm(TfrmLogin, frmLogin);
    frmLogin.ShowModal;
    frmLogin.Free;
  Application.Run;
end.

