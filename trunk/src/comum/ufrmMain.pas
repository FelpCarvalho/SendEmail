unit ufrmMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Vcl.StdCtrls,
  Vcl.Menus,
  Vcl.AppEvnts,
  uClassIniFile,
  uClassUtils,
  uClassTable,
  uFrmSenha;

type
  TfrmMain = class(TForm)
    OpenDialog1: TOpenDialog;
    pnlmain: TPanel;
    btoEnviar: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    edtCopia: TEdit;
    edtPara: TEdit;
    edtAssunto: TEdit;
    Label1: TLabel;
    memoBody: TMemo;
    Label2: TLabel;
    edtEmpresaEmitente: TEdit;
    btoSave: TSpeedButton;
    Label5: TLabel;
    edtPort: TEdit;
    Label6: TLabel;
    edtHost: TEdit;
    SpeedButton2: TSpeedButton;
    Label7: TLabel;
    edtUser: TEdit;
    Label8: TLabel;
    edtPass: TEdit;
    chkSsl: TCheckBox;
    chkTls: TCheckBox;
    chkReadConfirmation: TCheckBox;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Configurar: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    Fechar1: TMenuItem;
    Timer1: TTimer;
    btoTestaEnvio: TSpeedButton;
    Label9: TLabel;
    edtDirSale: TEdit;
    Label10: TLabel;
    edtDirCanc: TEdit;
    procedure btoEnviarClick(Sender: TObject);
    procedure SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure btoSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure ConfigurarClick(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure btoTestaEnvioClick(Sender: TObject);
  private
    { Private declarations }
    FArqCompact : string;
    FWait : boolean;
    procedure UpApplication;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.ApplicationEvents1Minimize(Sender: TObject);
begin
  Self.Hide();
  Self.WindowState := wsMinimized;
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;
  TrayIcon1.ShowBalloonHint;
end;


procedure TfrmMain.btoSaveClick(Sender: TObject);
var
  vFile : TFile;
begin
  vFile := TFile.New;
  try
    vFile.Empresa := edtEmpresaEmitente.Text;
    vFile.Sender := edtPara.Text;
    vFile.Cc := edtCopia.Text;
    vFile.Host := edtHost.Text;
    vFile.Port := edtPort.Text;
    vFile.UserName := edtUser.Text;
    vFile.Pass := edtPass.Text;
    vFile.DirSale := edtDirSale.Text;
    vFile.DirCanc := edtDirCanc.Text;

    vFile.Ssl := booltostr(chkSsl.Checked);
    vFile.Tls := booltostr(chkTls.Checked);

    vFile.ReadConfirmation := booltostr(chkReadConfirmation.Checked);
    vFile.MsgDefault := memoBody.Text;
    vFile.Assunt := edtAssunto.Text;
    vFile.Write;
  finally
    showmessage('Salvo!');
    vFile.Free;
  end;


end;

procedure TfrmMain.btoTestaEnvioClick(Sender: TObject);
var
  vEmail : TEmail;
begin
  if edtPara.Text='' then
    exit;

  vEmail := TEmail.New;
  try
    FWait := False;
    if vEmail.LoadPropertys.Send('Email teste',edtPara.Text,'envio de teste') then
    begin
      TrayIcon1.BalloonHint := 'Email enviado para '+edtPara.Text+
        '. Caso seja necessário, confirme o recebimento com o destinatário';
      TrayIcon1.BalloonTitle:='Enviado!';
      TrayIcon1.ShowBalloonHint;
      ShowMessage('Email Enviado!');
    end;
  finally
    FWait := False;
    vEmail.Free;
  end;

end;

procedure TfrmMain.ConfigurarClick(Sender: TObject);
begin
  UpApplication;
end;

procedure TfrmMain.Fechar1Click(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmMain.UpApplication;
var
 vFrmSenha: TFrmSenha;
 vValid: boolean;
begin
  vValid := False;
  vFrmSenha := TFrmSenha.Create(nil);
  try
    vFrmSenha.ShowModal;
    vValid := vFrmSenha.ValidPassword;
  finally
    vFrmSenha.Free;
  end;

  if vValid = false then
    exit;

  TrayIcon1.Visible := False;
  Show;
  WindowState := wsNormal;
  Application.BringToFront;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if messageDlg('Deseja encerrar a aplicação?', mtInformation,[mbYes,mbNo],0) = mrNo then
  begin
   ApplicationEvents1.OnMinimize(sender);
   abort;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  vFile : TFile;
begin
  FWait :=false;
  vFile := TFile.New;
  try
    vFile.Read;
    edtEmpresaEmitente.Text := vFile.Empresa;
    edtPara.Text := vFile.Sender;
    edtCopia.Text := vFile.Cc;
    edtHost.Text := vFile.Host;
    edtPort.Text := vFile.Port;
    edtUser.Text := vFile.UserName;
    edtPass.Text := vFile.Pass;

    edtDirSale.Text := vFile.DirSale;
    edtDirCanc.Text := vFile.DirCanc;

    chkSsl.Checked := StrToBoolDef(vFile.Ssl,true);
    chkTls.Checked := strtoboolDef(vFile.Tls, true);

    chkReadConfirmation.Checked := strtoboolDef(vFile.ReadConfirmation,true);
    memoBody.Text := vFile.MsgDefault;
    edtAssunto.Text := vFile.Assunt;
  finally
    vFile.Free;
  end;
  Self.WindowState := wsMinimized;
end;

procedure TfrmMain.btoEnviarClick(Sender: TObject);
var
  vEmail : TEmail;
  msgBalloon : string;
begin
  if edtPara.Text='' then
    exit;
  if TEmail.StateSendEmail then
    exit;
  vEmail := TEmail.New;
  try
    if vEmail.LoadPropertys.CompactArq.Send then
    begin
      msgBalloon :='Email enviado para '+edtPara.Text;
      if edtCopia.Text <>'' then
        msgBalloon := msgBalloon +', com cópia para'+edtCopia.Text;
      TrayIcon1.BalloonHint := msgBalloon+
        '. Caso seja necessário, confirme o recebimento com o destinatário';
      TrayIcon1.BalloonTitle:='Cupons enviados!';
      TrayIcon1.ShowBalloonHint;
    end;
  finally
    vEmail.Free;
  end;


end;
procedure TfrmMain.SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 edtPass.PasswordChar:= #0;
end;

procedure TfrmMain.SpeedButton2MouseLeave(Sender: TObject);
begin
  edtPass.PasswordChar := '*';
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  if not(FWait) then
    btoEnviar.OnClick(sender);
end;

initialization
  {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := true;
  {$ENDIF}
finalization



end.
