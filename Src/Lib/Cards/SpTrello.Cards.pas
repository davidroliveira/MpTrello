unit SpTrello.Cards;

interface

uses
  System.SysUtils, System.Classes, SpTrello.Authenticator,
  FireDAC.Comp.Client, Data.DB;

type
  TSpTrelloCards = class
  private
    FSpTrelloAuthenticator: TSpTrelloAuthenticator;
    FDataSet: TFDMemTable;
    FActive: Boolean;
    FIdList: string;
    procedure SetActive(const Value: Boolean);
    procedure SetSpTrelloAuthenticator(const Value: TSpTrelloAuthenticator);
    procedure SetDataSet(const Value: TFDMemTable);
    procedure SetIdList(const Value: string);
  public
    //function Insert(const AName: string): Boolean;
    procedure Refresh;
    function Edit(const AId, FieldName, Value: string): Boolean; overload;
    function Edit(FieldName, Value: string): Boolean; overload;
    function Delete: Boolean; overload;
    function Delete(const AId: string): Boolean; overload;
  published
    property SpTrelloAuthenticator: TSpTrelloAuthenticator read FSpTrelloAuthenticator write SetSpTrelloAuthenticator;
    property DataSet: TFDMemTable read FDataSet write SetDataSet;
    property Active: Boolean read FActive write SetActive default False;
    property IdList: string read FIdList write SetIdList;
  end;

implementation

uses System.Threading, Core.SpTrello.Util, REST.Client, Core.SpTrello.Cards;

resourcestring
  StrInformeOIdentifica = 'Informe o identificador da lista.';
  StrComponentAuthentica = 'Component Authenticator não encontrado.';

{ TSpTrelloLists }

function TSpTrelloCards.Delete: Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Delete(FDataSet.FieldByName('id').AsString);
end;

function TSpTrelloCards.Delete(const AId: string): Boolean;
begin
  Result := False;
  with TCoreSpTrellocards.Create(FIdList, FSpTrelloAuthenticator) do
  begin
    try
      Result := Delete(AId).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloCards.Edit(const AId, FieldName, Value: string): Boolean;
begin
  Result := False;
  if FSpTrelloAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  if Trim(FIdList) = EmptyStr then
    raise Exception.Create(StrInformeOIdentifica);

  with TCoreSpTrelloCards.Create(FIdList, FSpTrelloAuthenticator) do
  begin
    try
      Result := Put(AId, FieldName, Value).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloCards.Edit(FieldName, Value: string): Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Edit(FDataSet.FieldByName('id').AsString, FieldName, Value);
end;

//function TSpTrelloCards.Insert(const AName: string): Boolean;
//begin
//  Result := False;
//  if FSpTrelloAuthenticator = nil then
//    raise Exception.Create(StrComponentAuthentica);
//
//  if Trim(FIdList) = EmptyStr then
//    raise Exception.Create(StrInformeOIdentifica);
//
//  with TCoreSpTrelloCards.Create(FIdList, FSpTrelloAuthenticator) do
//  begin
//    try
//      Result := Post([AName, FIdList]).StatusCode = 200;
//    finally
//      Free;
//    end;
//  end;
//end;

procedure TSpTrelloCards.Refresh;
var
  loBook: TBookmark;
begin
  if FDataSet <> nil then
  begin
    FDataSet.DisableControls;
    loBook := FDataSet.Bookmark;
  end;
  try
    Active := False;
    Active := True;
  finally
    if FDataSet <> nil then
    begin
      if FDataSet.BookmarkValid(loBook) then
        FDataSet.GotoBookmark(loBook);
      FDataSet.EnableControls;
    end;
  end;
end;

procedure TSpTrelloCards.SetActive(const Value: Boolean);
var
  loTask: ITask;
  RESTResponse: TRESTResponse;
begin
  FActive := Value;
  if FActive then
  begin
    if FSpTrelloAuthenticator = nil then
      raise Exception.Create(StrComponentAuthentica);

    if Trim(FIdList) = EmptyStr then
      raise Exception.Create(StrInformeOIdentifica);

//    loTask := TTask.Create(
//      procedure ()
//      begin
//        TThread.Synchronize(nil,
//        procedure
//        begin
          with TCoreSpTrelloCards.Create(FIdList, FSpTrelloAuthenticator) do
          begin
            if FDataSet <> nil then
              FDataSet.DisableControls;
            try
              RESTResponse := Get([]);
              try
                FDataSet.DataInJson(RESTResponse);
              finally
                RESTResponse.Free;
              end;
            finally
              if FDataSet <> nil then
              begin
                if FDataSet.Active then
                  FDataSet.First;
                FDataSet.EnableControls;
              end;
              Free;
            end;
          end;
//        end);
//      end
//    );
//    loTask.Start;
  end
  else
  begin
    if FDataSet <> nil then
      FDataSet.Close;
  end;
end;

procedure TSpTrelloCards.SetSpTrelloAuthenticator(const Value: TSpTrelloAuthenticator);
begin
  FSpTrelloAuthenticator := Value;
end;

procedure TSpTrelloCards.SetDataSet(const Value: TFDMemTable);
begin
  FDataSet := Value;
end;

procedure TSpTrelloCards.SetIdList(const Value: string);
begin
  FIdList := Value;
end;

end.

