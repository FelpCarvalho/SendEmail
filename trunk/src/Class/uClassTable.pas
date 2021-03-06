unit uClassTable;

interface

uses
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Comp.UI,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  System.Classes,
  System.SysUtils,
  uDtm;

type
  TTableDefault = class(TComponent)
  private
    FQuery: TFDQuery;
  const
    EMAILDESTINO = '';
  public
    class function New: TTableDefault;
  end;

  TControlSend = class(TTableDefault)
    FTTableDefault: TTableDefault;
  private
    FEnviado: string;
    FID: integer;
    FDataEnvio: string;
    FEmailEnvio: string;
    FCaminhoArq: string;
    FSql: string;
    procedure SetCaminhoArq(const Value: string);
    procedure SetDataEnvio(const Value: string);
    procedure SetEmailEnvio(const Value: string);
    procedure SetEnviado(const Value: string);
    procedure SetID(const Value: integer);
    procedure SetSql(const Value: string);
    property ID: integer read FID write SetID;
    property DataEnvio: string read FDataEnvio write SetDataEnvio;
    property CaminhoArq: string read FCaminhoArq write SetCaminhoArq;
    property EmailEnvio: string read FEmailEnvio write SetEmailEnvio;
    property Enviado: string read FEnviado write SetEnviado;
    property Sql: string read FSql write SetSql;
    procedure OpenDataSet;
    function CheckEmailEnviado: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TControlSend;
    function SendedEmail: boolean;
    function Insert(const Dir: string; const email: string): string;
    function GetId: string;
  end;

  TLog = class(TTableDefault)
  private
    FTTableDefault: TTableDefault;
    FSql: string;
    FDataEnvio: string;
    FMensagem: string;
    FIdControl: string;
    procedure SetSql(const Value: string);
    procedure SetDataEnvio(const Value: string);
    procedure SetIdControl(const Value: string);
    procedure SetMensagem(const Value: string);
    property Sql: string read FSql write SetSql;
    property IdControl: string read FIdControl write SetIdControl;
    property DataEnvio: string read FDataEnvio write SetDataEnvio;
    property Mensagem: string read FMensagem write SetMensagem;
    procedure OpenDataSet;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TLog;
    procedure Insert(const IdControl, DataEnvio, Msg: string);
  end;

implementation

{ TControlSend }

function TControlSend.CheckEmailEnviado: boolean;
begin
  result := false;
  try
    FQuery.Sql.Clear;
    FQuery.Sql.Add(Sql);
    FQuery.Open;
    result := FQuery.RecordCount > 0;
  except
  end;
end;

constructor TControlSend.Create;
begin
  FTTableDefault := TTableDefault.New;
  Sql := 'SELECT * FROM CONTROL_SEND WHERE 1<>1';
  FQuery := TFDQuery.Create(nil);
  OpenDataSet;
end;

destructor TControlSend.Destroy;
begin
  FQuery.Free;
  FTTableDefault.Free;
  inherited
end;

function TControlSend.GetId: string;
begin
  result := '';
  FQuery.Sql.Clear;
  FQuery.Sql.Add('select max(id) id from control_send where 1=1');
  FQuery.Open;
  result := FQuery.FieldByName('id').AsString;
end;

function TControlSend.Insert(const Dir: string; const email: string): string;
begin
  result := '';
  try
    oDm.cnx.StartTransaction;
    FQuery.Append;
    FQuery.FieldByName('DATAENVIO').AsDateTime := now;
    FQuery.FieldByName('CAMINHOARQ').AsString := Dir;
    FQuery.FieldByName('EMAILENVIO').AsString := email;
    FQuery.FieldByName('ENVIADO').AsString := 'S';
    FQuery.Post;
    FQuery.ApplyUpdates(0);
    oDm.cnx.Commit;
  except
    on e: exception do
    begin
      result := e.Message;
      oDm.cnx.Rollback;
    end;
  end;
end;

function TControlSend.SendedEmail: boolean;
begin
  Sql := 'SELECT ENVIADO ' +
    '  FROM CONTROL_SEND ' +
    '  WHERE DATAENVIO BETWEEN(' + QuotedStr(FormatDateTime('yyyy-mm', now)+'-01') +' ) '+
    ' AND ' +
    '(' + QuotedStr(FormatDateTime('yyyy-mm-dd', now)) + ')AND ENVIADO=''S''';
  result := CheckEmailEnviado;
end;

class function TControlSend.New: TControlSend;
begin
  result := TControlSend.Create;
end;

procedure TControlSend.OpenDataSet;
begin
  try
    FQuery.Close;
    FQuery.Connection := oDm.cnx;
    FQuery.CachedUpdates := true;
    FQuery.Sql.Clear;
    FQuery.Sql.Add(Sql);
    FQuery.Open;
  except
  end;
end;

procedure TControlSend.SetCaminhoArq(const Value: string);
begin
  FCaminhoArq := Value;
end;

procedure TControlSend.SetDataEnvio(const Value: string);
begin
  FDataEnvio := Value;
end;

procedure TControlSend.SetEmailEnvio(const Value: string);
begin
  FEmailEnvio := Value;
end;

procedure TControlSend.SetEnviado(const Value: string);
begin
  FEnviado := Value;
end;

procedure TControlSend.SetID(const Value: integer);
begin
  FID := Value;
end;

procedure TControlSend.SetSql(const Value: string);
begin
  FSql := Value;
end;
{ TTableDefault }

class function TTableDefault.New: TTableDefault;
begin
  result := TTableDefault.Create(nil);
end;
{ TLog }

constructor TLog.Create;
begin
  FTTableDefault := TTableDefault.New;
  Sql := 'SELECT * FROM LOG WHERE 1<>1';
  FQuery := TFDQuery.Create(nil);
  OpenDataSet;
end;

destructor TLog.Destroy;
begin
  FQuery.Free;
  FTTableDefault.Free;
  inherited;
end;

procedure TLog.Insert(const IdControl, DataEnvio, Msg: string);
begin
  try
    oDm.cnx.StartTransaction;
    FQuery.Append;
    FQuery.FieldByName('ID_CONTROL').AsString := IdControl;
    FQuery.FieldByName('DATAENVIO').AsString := DataEnvio;
    FQuery.FieldByName('MENSAGEM').AsString := Msg;
    FQuery.Post;
    FQuery.ApplyUpdates(0);
    oDm.cnx.Commit;
  except
    on e: exception do
    begin
      oDm.cnx.Rollback;
    end;
  end;
end;

class function TLog.New: TLog;
begin
  result := TLog.Create;
end;

procedure TLog.OpenDataSet;
begin
  try
    FQuery.Close;
    FQuery.Connection := oDm.cnx;
    FQuery.CachedUpdates := true;
    FQuery.Sql.Clear;
    FQuery.Sql.Add(Sql);
    FQuery.Open;
  except
  end;
end;

procedure TLog.SetDataEnvio(const Value: string);
begin
  FDataEnvio := Value;
end;

procedure TLog.SetIdControl(const Value: string);
begin
  FIdControl := Value;
end;

procedure TLog.SetMensagem(const Value: string);
begin
  FMensagem := Value;
end;

procedure TLog.SetSql(const Value: string);
begin
  FSql := Value;
end;

end.
