unit Core.SpTrello.Lists;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Core.SpTrello.Base, System.JSON, REST.Client, IPPeerCommon, SpTrello.Authenticator;

type
  TCoreSpTrelloLists = class(TCoreSpTrelloBase)
  private
    FIdBoard: string;
    procedure SetIdBoard(const Value: string);
  public
    constructor Create(const AIdBoard: string; const AAuthenticator: TSpTrelloAuthenticator);
    destructor Destroy; override;
    function Get(const aParams: array of TJSONPair): TRESTResponse;
    function Post(const aParams: array of string): TRESTResponse;
    function Put(const sValue: string; const FieldName: string;
      const aParams: string): TRESTResponse;
    function Delete(const sValue: string): TRESTResponse;
    property IdBoard: string read FIdBoard write SetIdBoard;
  end;

implementation

uses System.StrUtils, REST.Authenticator.OAuth, System.Threading,
  REST.Types, Core.SpTrello.Authenticator, Core.SpTrello.Constants;

resourcestring
  sLISTS = 'lists';

{ TCoreSpTrelloLists }

constructor TCoreSpTrelloLists.Create(const AIdBoard: string; const AAuthenticator: TSpTrelloAuthenticator);
begin
  inherited Create(AAuthenticator);
  EndPoint := sLISTS;
  FIdBoard := AIdBoard;
end;

function TCoreSpTrelloLists.Delete(const sValue: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmDELETE,
      Format('%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue]), []);
  except
    raise;
  end;
end;

destructor TCoreSpTrelloLists.Destroy;
begin
  inherited;
end;

function TCoreSpTrelloLists.Get(const aParams: array of TJSONPair): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmGET,
      Format('%s/boards/%s/%s', [TCoreSpTrelloConstants.BaseUrl, IdBoard, EndPoint]), []);
  except
    raise;
  end;
end;

function TCoreSpTrelloLists.Post(const aParams: array of string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmPOST,
      Format('%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint]),
      [TJSONPair.Create('name', aParams[0]),
       TJSONPair.Create('idBoard', aParams[1])]);
  except
    raise;
  end;
end;

function TCoreSpTrelloLists.Put(const sValue, FieldName,
  aParams: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmPUT,
      Format('%s/%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue, FieldName]),
      [TJSONPair.Create('value', aParams)]);
  except
    raise;
  end;
end;

procedure TCoreSpTrelloLists.SetIdBoard(const Value: string);
begin
  FIdBoard := Value;
end;

end.

