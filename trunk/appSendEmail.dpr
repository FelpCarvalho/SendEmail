program appSendEmail;

uses
  Vcl.Forms,
  uDtm in 'src\Model\uDtm.pas' {dm: TDataModule},
  ufrmMain in 'src\comum\ufrmMain.pas' {frmMain},
  uClassTable in 'src\Class\uClassTable.pas',
  uClassUtils in 'src\Class\uClassUtils.pas',
  uClassIniFile in 'src\Class\uClassIniFile.pas',
  ufrmSenha in 'src\comum\ufrmSenha.pas' {frmSenha};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDm, oDm);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
