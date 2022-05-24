unit uClassUtils;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Zip,
  Winapi.Windows,
  ACBrBase,
  ACBrMail,
  ACBrUtil,
  ACBrUtil.XMLHTML,
  udtm,
  uClassTable,
  uClassIniFile;


type
  TEmail = class
    private
      FConfirmationEMail: boolean;
      FNomeEmitente: string;
      FPeriodoCupom: string;
      FPort: string;
      FSsl: boolean;
      FPassword: string;
      FTls: boolean;
      FHost: string;
      FUserName: string;
      FACBrMail : TACBrMail;
      FEmailDest: string;
      FArqSale: string;
      FArqCanc: string;
      FEmailCc: string;
      FMsg: string;
      FAssunto: string;
    FDirCanc: string;
    FDirSale: string;
      procedure SetEmailCc(const Value: string);
      procedure SetAssunto(const Value: string);
      procedure SetMsg(const Value: string);
    procedure SetDirCanc(const Value: string);
    procedure SetDirSale(const Value: string);
      const CHOST ='mail.teste.com.br';
      const PASS = 'senha';
      const PORTA = 'porta';
      const USER = 'emailusuario';

      procedure SetConfirmationEMail(const Value: boolean);
      procedure SetNomeEmitente(const Value: string);
      procedure SetPeriodoCupom(const Value: string);
      procedure SetHost(const Value: string);
      procedure SetPassword(const Value: string);
      procedure SetPort(const Value: string);
      procedure SetSsl(const Value: boolean);
      procedure SetTls(const Value: boolean);
      procedure SetUserName(const Value: string);
      procedure ConfiguraEmail;
      procedure SetEmailDest(const Value: string);
    public
      property ConfirmationEMail : boolean read FConfirmationEMail write SetConfirmationEMail;
      property NomeEmitente : string read FNomeEmitente write SetNomeEmitente;
      property PeriodoCupom : string read FPeriodoCupom write SetPeriodoCupom;
      property EmailDest : string read FEmailDest write SetEmailDest;
      property EmailCc : string read FEmailCc write SetEmailCc;
      property Host : string read FHost write SetHost;
      property Port : string read FPort write SetPort;
      property UserName : string read FUserName write SetUserName;
      property Password : string read FPassword write SetPassword;
      property Ssl : boolean read FSsl write SetSsl;
      property Tls : boolean read FTls write SetTls;
      property Msg : string read FMsg write SetMsg;
      property Assunto : string read FAssunto write SetAssunto;
      property DirSale : string read FDirSale write SetDirSale;
      property DirCanc : string read FDirCanc write SetDirCanc;
      property ArqSale : string read FArqSale write FArqSale;
      property ArqCanc : string read FArqCanc write FArqCanc;
      destructor Destroy;override;
      function Send(const NomeEmitente : string; Para : string;
         Assunto : string; msg : string = '') : boolean;overload;
      class function StateSendEmail : boolean;
      class function New : TEmail;
      function  LoadPropertys : TEmail;
      function Send : boolean; overload;
      function CompactArq: TEmail;
      procedure Save;

  end;
  TZip = class
    private
      function ZipSale(const Dir : string; Date : string) : string;
      function ZipCancel(const Dir : string; Date : string) : string;
    public
      procedure CompactZip(DirSale: string; DirCanc : string; var CfSale : string; var CfCancel : string);
      class function New : TZip;
  end;
  TIniFile = class
    private
    public

  end;
implementation

{ TEmail }

function TEmail.CompactArq: TEmail;
var
  vZip : TZip;
begin
  result := self;
  if (DirSale ='') and (DirCanc ='') then
    exit;

  vZip := TZip.New;
  try
    vZip.CompactZip(DirSale,DirCanc, FArqSale, FArqCanc);
  finally
    vZip.Free
  end;


end;

procedure TEmail.ConfiguraEmail;
begin
  FACBrMail := TACBrMail.Create(nil);
  try

    FACBrMail.IsHTML := false;
    FACBrMail.From := EmailDest;
    FACBrMail.Host := Host; // troque pelo seu servidor smtp
    FACBrMail.Username := UserName;
    FACBrMail.Password := Password;

    FACBrMail.SetSSL := Ssl;
    FACBrMail.SetTLS := Tls;
    FACBrMail.Port := Port; // troque pela porta do seu servidor smtp
    FACBrMail.ReadingConfirmation := ConfirmationEMail;

  finally

  end;
end;

destructor TEmail.Destroy;
begin
  FACBrMail.Free;
  inherited;
end;

function TEmail.LoadPropertys: TEmail;
var
  vMesAno : string;
  vFile : TFile;
  vMonth : string;
begin
  result := self;
  vFile := TFile.New;
  try
    vMonth := (FormatDateTime('mm',now).ToInteger -1).ToString;
    if length(vMonth)=1 then
      vMonth :='0'+vMonth;

    vMesAno := vMonth + copy(FormatDateTime('yyyy',now),3,2);
    vFile.Read;
    DirSale := vFile.DirSale;
    DirCanc := vFile.DirCanc;
    NomeEmitente := vFile.Empresa;
    EmailDest := vFile.Sender;
    EmailCc := vFile.Cc;
    Host := vFile.Host;
    Port := vFile.Port;
    UserName := vFile.UserName;
    Password := vFile.Pass;
    PeriodoCupom := vMesAno;
    Ssl := strtoboolDef(vFile.Ssl,true);
    Tls := strtoboolDef(vFile.Tls,true);

    ConfirmationEMail := strtoboolDef(vFile.ReadConfirmation,true);
    Msg := vFile.MsgDefault;
    Assunto := vFile.Assunt;
  finally
    vFile.Free;
  end;



end;

class function TEmail.New: TEmail;
begin
  Result := TEmail.Create;

end;


procedure TEmail.Save;
var
  vMessage : string;
  vTable : TControlSend;
  vTableLog : TLog;
  vIdControl : string;
begin
  vTable := TControlSend.New;
  vMessage := vTable.Insert(' dir: '+DirSale +' - '+DirCanc,EmailDest);
  vIdControl := vTable.GetId;
  try
    if vMessage <>'' then
    begin
      vMessage := vMessage +' ERRO ao tentar enviar arquivos empresa: '+NomeEmitente+'  email:'+
        EmailDest +' data :'+DateToStr(now)+' dir: '+arqSale + ' - '+arqCanc;
      send('empresa',USER,'Erro Envio de arquivos '+vMessage);
    end;

  finally
    vTable.Free;
  end;
  vTableLog := TLog.New;
  try
    vTableLog.Insert(vIdControl,DateToStr(now),Msg);
  finally
    vTableLog.Free;
  end;
end;

function TEmail.Send : boolean;
var
  AssuntoMensagem: String;

begin
  result := false;
  // envio da mensagem
  if (ArqSale ='') and (ArqCanc ='') then
    exit;

  ConfiguraEmail;
  try
    AssuntoMensagem    := Assunto;
    FACBrMail.Clear;
    if EmailCc <>'' then
      FACBrMail.AddCC(EmailCc,'');

    FACBrMail.AddAddress(EmailDest, '');
    FACBrMail.Subject :=AssuntoMensagem;
    FACBrMail.body.Text := msg;
    FACBrMail.AltBody.Text :=(StripHTML(msg));
    FACBrMail.ClearAttachments;
    if ArqSale <> '' then
      FACBrMail.AddAttachment(ArqSale);
    if ArqCanc <> '' then
      FACBrMail.AddAttachment(ArqCanc);


    FACBrMail.Send;
    result := true;
    Save;
  except

  end;
end;

function TEmail.Send(const NomeEmitente: string; Para, Assunto, msg: string) : boolean;
var
  AssuntoMensagem: String;
begin
  result := false;
  // envio da mensagem
  ConfiguraEmail;
  try
    AssuntoMensagem    := Assunto;
    FACBrMail.Clear;
    FACBrMail.AddAddress(para,NomeEmitente);
    FACBrMail.Subject :=AssuntoMensagem;
    FACBrMail.body.Text := msg;
    FACBrMail.AltBody.Text :=(StripHTML(msg));

    FACBrMail.Send;
    result := true;
  except

  end;

end;




procedure TEmail.SetAssunto(const Value: string);
begin
  if Value ='' then
    FAssunto := 'Cupom Fiscal período-'+PeriodoCupom
  else
    FAssunto := Value;
end;

procedure TEmail.SetConfirmationEMail(const Value: boolean);
begin
  FConfirmationEMail := Value;
end;

procedure TEmail.SetDirCanc(const Value: string);
begin
  FDirCanc := Value;
end;

procedure TEmail.SetDirSale(const Value: string);
begin
  FDirSale := Value;
end;

procedure TEmail.SetEmailCc(const Value: string);
begin
  FEmailCc := Value;
end;

procedure TEmail.SetEmailDest(const Value: string);
begin
  FEmailDest := Value;
end;


procedure TEmail.SetHost(const Value: string);
begin
  if Value='' then
    FHost := CHOST
  else FHost := Value;
end;

procedure TEmail.SetMsg(const Value: string);
var
    CorpoMensagem: TStringList;
begin
  if Value ='' then
  begin
    CorpoMensagem := TStringList.Create;
    try
      CorpoMensagem.Clear;
      CorpoMensagem.Add('Prezado,');
      CorpoMensagem.Add('');
      CorpoMensagem.Add('Você está recebendo os arquivos fiscais referente ao período:');
      CorpoMensagem.Add(PeriodoCupom);
      CorpoMensagem.Add('Empresa: ' +NomeEmitente);
      CorpoMensagem.Add('');
      CorpoMensagem.Add('Atenciosamente,');
      CorpoMensagem.Add('');
      CorpoMensagem.Add('Enviado automaticamente por:'+UserName);
      CorpoMensagem.Add('');
      FMsg := CorpoMensagem.Text;
    finally
      CorpoMensagem.Free;
    end;

  end else  FMsg := Value;
end;

procedure TEmail.SetNomeEmitente(const Value: string);
begin
  FNomeEmitente := Value;
end;

procedure TEmail.SetPassword(const Value: string);
begin
  if Value ='' then
    FPassword :=PASS
  else FPassword := Value;
end;

procedure TEmail.SetPeriodoCupom(const Value: string);
begin
  FPeriodoCupom := Value;
end;

procedure TEmail.SetPort(const Value: string);
begin
  if Value ='' then
    FPort := PORTA
  else FPort := Value;
end;

procedure TEmail.SetSsl(const Value: boolean);
begin
  FSsl := Value;
end;

procedure TEmail.SetTls(const Value: boolean);
begin
  FTls := Value;
end;

procedure TEmail.SetUserName(const Value: string);
begin
  if Value ='' then
    FUserName := USER
  else FUserName := Value;
end;

class function TEmail.StateSendEmail: boolean;
var
  vTable : TControlSend;
begin
  vTable := TControlSend.new;
  result := vTable.SendedEmail;
  vTable.Free;
end;

{ TZip }

procedure TZip.CompactZip(DirSale: string; DirCanc : string; var CfSale : string; var CfCancel : string);
var
  vMesAno : string;
  vMonth : string;
begin
  try
    vMonth := (FormatDateTime('mm',now).ToInteger -1).ToString;
    if length(vMonth)=1 then
      vMonth :='0'+vMonth;

    vMesAno := FormatDateTime('yyyy',now) + vMonth;
    CfSale := ZipSale(DirSale, vMesAno);
    CfCancel := ZipCancel(DirCanc, vMesAno);
  except

  end;



end;


class function TZip.New : TZip;
begin
  result := TZip.Create;
end;

function TZip.ZipCancel(const Dir : string; Date : string) : string;
var
  vDir : string;
  zip: TZipFile;
  vArquivos : TStringList;
  SR: TSearchRec;
  vFileName : string;
begin
  vDir := Dir +Date+'\';

  vDir := StringReplace(vDir,'\\','\',[rfReplaceAll]);

  if not(LocaleDirectoryExists(vDir)) then
    exit;


  vFileName := vDir+'Cancelados'+Date+'.zip';

  if FileExists(vFileName)  then
  begin
    result :=vFileName;
    exit;
  end;

  vArquivos := TStringList.Create;
  zip := TZipFile.Create;

  try

    try
      zip.Open(vFileName, zmWrite);
      if FindFirst(vDir+'*.*', faAnyFile, SR) = 0 then// encontra todos os arquivos dentro do diretorio informado
      begin
        repeat
          if (SR.Attr <> faDirectory) then
            zip.Add(vDir + SR.Name);
        until FindNext(SR) <> 0;
        FindClose(SR.FindHandle);
      end;

//      for I := 0 to pred(vArquivos.Count) do
//        zip.Add(vArquivos.Strings[I]);


      if fileExists(vFileName) then
      zip.Close;

    except
      vFileName :='';
    end;

  finally
    result := vFileName;
    vArquivos.Free;
    zip.Free;
  end;
end;

function TZip.ZipSale(const Dir : string; Date : string) : string;
var
  vDir : string;
  zip: TZipFile;
  vArquivos : TStringList;
  SR: TSearchRec;
  vFileName : string;

begin
  result := '';
  vDir := Dir +Date+'\';


  vDir := StringReplace(vDir,'\\','\',[rfReplaceAll]);

  if not(LocaleDirectoryExists(vDir)) then
    exit;


  vFileName := vDir+'Vendas'+Date+'.zip';

  if FileExists(vFileName)  then
  begin
    result :=vFileName;
    exit;
  end;


  vArquivos := TStringList.Create;
  zip := TZipFile.Create;

  try

    try
      zip.Open(vFileName, zmWrite);
      if FindFirst(vDir+'*.*', faAnyFile, SR) = 0 then// encontra todos os arquivos dentro do diretorio informado
      begin
        repeat
          if (SR.Attr <> faDirectory) then
            zip.Add(vDir + SR.Name);
        until FindNext(SR) <> 0;
        FindClose(SR.FindHandle);
      end;

//      for I := 0 to pred(vArquivos.Count) do
//        zip.Add(vArquivos.Strings[I]);


      if fileExists(vFileName) then
        zip.Close;

    except
      vFileName :='';
    end;

  finally
    result := vFileName;
    vArquivos.Free;
    zip.Free;
  end;
end;

end.
