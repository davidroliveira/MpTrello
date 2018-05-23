unit SpTrello.Authenticator;

interface

uses
  System.SysUtils, System.Classes;

type
  TSpTrelloAuthenticator = class
  strict private
    FKey: string;
    FToken: string;
    FUser: string;
    //FId: string;
    procedure SetKey(const Value: string);
    procedure SetToken(const Value: string);
    procedure SetUser(const Value: string);
    //procedure SetId(const Value: string);
  public
    //property Id: string read FId write SetId;
  published
    property User: string read FUser write SetUser;
    property Key: string read FKey write SetKey;
    property Token: string read FToken write SetToken;
  end;

implementation

{ TSpTrelloAuthenticator }

//procedure TSpTrelloAuthenticator.SetId(const Value: string);
//begin
//  FId := Value;
//end;

procedure TSpTrelloAuthenticator.SetKey(const Value: string);
begin
  FKey := Value;
end;

procedure TSpTrelloAuthenticator.SetToken(const Value: string);
begin
  FToken := Value;
end;

procedure TSpTrelloAuthenticator.SetUser(const Value: string);
begin
  FUser := Value;
end;

end.
