unit uClassIniFile;

interface

uses
  System.IniFiles,
  System.SysUtils,
  Vcl.Forms;

type
  TFile = class
    private
    FConfig : TIniFile;
    FReadConfirmatio: string;
    FCc: string;
    FPort: string;
    FPass: string;
    FSsl: string;
    FAssunt: string;
    FMsgDefault: string;
    FTls: string;
    FHost: string;
    FSender: string;
    FUserName: string;
    FEmpresa: string;
    FDirCanc: string;
    FDirSale: string;
    procedure SetEmpresa(const Value: string);
    procedure SetDirCanc(const Value: string);
    procedure SetDirSale(const Value: string);
    const ARQUIVO  = '\conf.ini';
    const TAG = 'SETTINGS';
    procedure SetAssunt(const Value: string);
    procedure SetCc(const Value: string);
    procedure SetHost(const Value: string);
    procedure SetMsgDefault(const Value: string);
    procedure SetPass(const Value: string);
    procedure SetPort(const Value: string);
    procedure SetReadConfirmatio(const Value: string);
    procedure SetSender(const Value: string);
    procedure SetSsl(const Value: string);
    procedure SetTls(const Value: string);
    procedure SetUserName(const Value: string);
    public
    property Empresa: string read FEmpresa write SetEmpresa;
    property Sender: string read FSender write SetSender;
    property Cc: string read FCc write SetCc;
    property Host: string read FHost write SetHost;
    property Port: string read FPort write SetPort;
    property UserName : string read FUserName write SetUserName;
    property Pass : string read FPass write SetPass;
    property Ssl : string read FSsl write SetSsl;
    property Tls : string read FTls write SetTls;
    property ReadConfirmation : string read FReadConfirmatio write SetReadConfirmatio;
    property MsgDefault : string read FMsgDefault write SetMsgDefault;
    property Assunt : string read FAssunt write SetAssunt;
    property DirSale : string read FDirSale write SetDirSale;
    property DirCanc : string read FDirCanc write SetDirCanc;
    constructor Create;
    class function New : TFIle;
    class procedure CreateArq;
    procedure Read;
    procedure Write;
    procedure CreatSection;
    function EnDecryptString(StrValue: Ansistring; Chave: Word): String;

  end;

implementation


{ TFile }



constructor TFile.Create;
begin
end;

class procedure TFile.CreateArq;
var
  vDir : string;
  vConfig : TiniFile;
begin
  vDir  := ExtractFilePath(Application.ExeName) + ARQUIVO;
  vDir :=  StringReplace(vDir,'\\','\',[rfReplaceAll]);

  if FileExists(vDir) then
    exit;
  vConfig := TIniFile.Create(vDir);
  try
    vConfig.EraseSection(TAG);
    vConfig.WriteString(TAG, 'DIR', '');
    vConfig.WriteString(TAG, 'EMPRESA', '');
    vConfig.WriteString(TAG, 'SENDER', '');
    vConfig.WriteString(TAG, 'CC', '');
    vConfig.WriteString(TAG, 'HOST', '');
    vConfig.WriteString(TAG, 'PORT', '');
    vConfig.WriteString(TAG, 'USERNAME', '');
    vConfig.WriteString(TAG, 'PASS', '');
    vConfig.WriteString(TAG, 'SSL', '');
    vConfig.WriteString(TAG, 'TLS', '');
    vConfig.WriteString(TAG, 'READCONFIRMATION', '');
    vConfig.WriteString(TAG, 'MSGDEFAULT', '');
    vConfig.WriteString(TAG, 'ASSUNT', '');
    vConfig.WriteString(TAG, 'DIRSALE', '');
    vConfig.WriteString(TAG, 'DIRCANC', '');
  finally
    vConfig.Free;
  end;


end;

procedure TFile.CreatSection;
begin
    FConfig.WriteString(TAG, 'EMPRESA', EnDecryptString(Empresa,528));
    FConfig.WriteString(TAG, 'SENDER', EnDecryptString(Sender,528));
    FConfig.WriteString(TAG, 'CC', EnDecryptString(Cc,528));
    FConfig.WriteString(TAG, 'HOST', EnDecryptString(Host,528));
    FConfig.WriteString(TAG, 'PORT', EnDecryptString(Port,528));
    FConfig.WriteString(TAG, 'USERNAME', EnDecryptString(UserName,528));
    FConfig.WriteString(TAG, 'PASS', EnDecryptString(Pass,528));
    FConfig.WriteString(TAG, 'SSL', EnDecryptString(Ssl,528));
    FConfig.WriteString(TAG, 'TLS', EnDecryptString(Tls,528));
    FConfig.WriteString(TAG, 'READCONFIRMATION', EnDecryptString(ReadConfirmation,528));
    FConfig.WriteString(TAG, 'MSGDEFAULT', EnDecryptString(MsgDefault,528));
    FConfig.WriteString(TAG, 'ASSUNT', EnDecryptString(Assunt,528));
    FConfig.WriteString(TAG, 'DIRSALE', EnDecryptString(DirSale,528));
    FConfig.WriteString(TAG, 'DIRCANC', EnDecryptString(DirCanc,528));
end;

class function TFile.New: TFIle;
begin
 result := TFile.Create;
end;

procedure TFile.Read;
var
  vDir : string;
begin
  vDir  := ExtractFilePath(Application.ExeName) + ARQUIVO;
  vDir :=  StringReplace(vDir,'\\','\',[rfReplaceAll]);
  FConfig := TIniFile.Create(vDir);

  try
    SetEmpresa(EnDecryptString(FConfig.ReadString(TAG, 'EMPRESA', ''),528));
    SetSender(EnDecryptString(FConfig.ReadString(TAG, 'SENDER', ''),528));
    SetCc(EnDecryptString(FConfig.ReadString(TAG, 'CC', ''),528));
    SetHost(EnDecryptString(FConfig.ReadString(TAG, 'HOST', ''),528));
    SetPort(EnDecryptString(FConfig.ReadString(TAG, 'PORT', ''),528));
    SetUserName(EnDecryptString(FConfig.ReadString(TAG, 'USERNAME', ''),528));
    SetPass(EnDecryptString(FConfig.ReadString(TAG, 'PASS', ''),528));
    SetSsl(EnDecryptString(FConfig.ReadString(TAG, 'SSL', ''),528));
    SetTls(EnDecryptString(FConfig.ReadString(TAG, 'TLS', ''),528));
    SetReadConfirmatio(EnDecryptString(FConfig.ReadString(TAG, 'READCONFIRMATION', ''),528));
    SetMsgDefault(EnDecryptString(FConfig.ReadString(TAG, 'MSGDEFAULT', ''),528));
    SetAssunt(EnDecryptString(FConfig.ReadString(TAG, 'ASSUNT', ''),528));
    SetDirSale(EnDecryptString(FConfig.ReadString(TAG, 'DIRSALE', ''),528));
    SetDirCanc(EnDecryptString(FConfig.ReadString(TAG, 'DIRCANC', ''),528));
  finally

  end;
  FConfig.Free;

end;

procedure TFile.SetAssunt(const Value: string);
begin
  FAssunt := Value;
end;

procedure TFile.SetCc(const Value: string);
begin
  FCc := Value;
end;

procedure TFile.SetDirCanc(const Value: string);
begin
  FDirCanc := Value;
end;

procedure TFile.SetDirSale(const Value: string);
begin
  FDirSale := Value;
end;

procedure TFile.SetEmpresa(const Value: string);
begin
  FEmpresa := Value;
end;

procedure TFile.SetHost(const Value: string);
begin
  FHost := Value;
end;

procedure TFile.SetMsgDefault(const Value: string);
begin
  FMsgDefault := Value;
end;

procedure TFile.SetPass(const Value: string);
begin
  FPass := Value;
end;

procedure TFile.SetPort(const Value: string);
begin
  FPort := Value;
end;

procedure TFile.SetReadConfirmatio(const Value: string);
begin
  FReadConfirmatio := Value;
end;

procedure TFile.SetSender(const Value: string);
begin
  FSender := Value;
end;

procedure TFile.SetSsl(const Value: string);
begin
  FSsl := Value;
end;

procedure TFile.SetTls(const Value: string);
begin
  FTls := Value;
end;

procedure TFile.SetUserName(const Value: string);
begin
  FUserName := Value;
end;

procedure TFile.Write;
var
  vDir : string;
begin
  vDir  := ExtractFilePath(Application.ExeName) + ARQUIVO;
  vDir :=  StringReplace(vDir,'\\','\',[rfReplaceAll]);
  FConfig := TIniFile.Create(vDir);
  try
    FConfig.WriteString(TAG, 'EMPRESA', EnDecryptString(FEmpresa,528));
    FConfig.WriteString(TAG, 'SENDER', EnDecryptString(FSender,528));
    FConfig.WriteString(TAG, 'CC', EnDecryptString(FCc,528));
    FConfig.WriteString(TAG, 'HOST', EnDecryptString(FHost,528));
    FConfig.WriteString(TAG, 'PORT', EnDecryptString(FPort,528));
    FConfig.WriteString(TAG, 'USERNAME', EnDecryptString(FUserName,528));
    FConfig.WriteString(TAG, 'PASS', EnDecryptString(FPass,528));
    FConfig.WriteString(TAG, 'SSL', EnDecryptString(FSsl,528));
    FConfig.WriteString(TAG, 'TLS', EnDecryptString(FTls,528));
    FConfig.WriteString(TAG, 'READCONFIRMATION', EnDecryptString(FReadConfirmatio,528));
    FConfig.WriteString(TAG, 'MSGDEFAULT', EnDecryptString(FMsgDefault,528));
    FConfig.WriteString(TAG, 'ASSUNT', EnDecryptString(FAssunt,528));
    FConfig.WriteString(TAG, 'DIRSALE', EnDecryptString(FDirSale,528));
    FConfig.WriteString(TAG, 'DIRCANC', EnDecryptString(FDirCanc,528));

  finally
    FConfig.Free;
  end;


end;

function TFile.EnDecryptString(StrValue: Ansistring;
  Chave: Word): String;
var
  I: Integer;
  OutValue : String;
begin
  OutValue := '';
    for I := 1 to Length(StrValue) do
      OutValue := OutValue + ansichar(Not(ord(StrValue[I])-Chave));
  Result := OutValue;
end;

initialization
  TFile.CreateArq;


finalization


end.
