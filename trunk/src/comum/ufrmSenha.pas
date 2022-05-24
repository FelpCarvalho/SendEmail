unit ufrmSenha;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TfrmSenha = class(TForm)
    Panel1: TPanel;
    edtPass: TEdit;
    Label1: TLabel;
    SpeedButton2: TSpeedButton;
    btoConfirmar: TSpeedButton;
    procedure btoConfirmarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2MouseLeave(Sender: TObject);
    procedure edtPassKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FValid : boolean;
    FSenhaError : integer;
    const SENHA = '';
  public
    { Public declarations }
    function ValidPassword : boolean;
  end;

var
  frmSenha: TfrmSenha;

implementation

{$R *.dfm}

{ TfrmSenha }

procedure TfrmSenha.btoConfirmarClick(Sender: TObject);
begin
 if FSenhaError = 3 then
 begin
  fValid := false;
  self.Close;
 end;

 fValid := edtPass.Text = SENHA;
 if not(FValid) then
 begin
    inc(FSenhaError);
    edtPass.SetFocus;
    Showmessage('Senha Incorreta');
 end else Self.Close;

end;

procedure TfrmSenha.edtPassKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btoConfirmar.OnClick(sender);
end;

procedure TfrmSenha.FormCreate(Sender: TObject);
begin
  FValid := false;
  FSenhaError :=0;
end;

procedure TfrmSenha.SpeedButton2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  edtPass.PasswordChar := #0;
end;

procedure TfrmSenha.SpeedButton2MouseLeave(Sender: TObject);
begin
  edtPass.PasswordChar := '*';
end;

function TfrmSenha.ValidPassword: boolean;
begin
  result := FValid;
end;

end.
