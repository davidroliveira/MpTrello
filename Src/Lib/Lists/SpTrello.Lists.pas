unit SpTrello.Lists;

interface

uses
  System.SysUtils, System.Classes, SpTrello.Authenticator,
  FireDAC.Comp.Client, Data.DB;

type
  TSpTrelloLists = class
  private
    FSpTrelloAuthenticator: TSpTrelloAuthenticator;
    FDataSet: TFDMemTable;
    FActive: Boolean;
    FIdBoard: string;
    procedure SetActive(const Value: Boolean);
    procedure SetSpTrelloAuthenticator(const Value: TSpTrelloAuthenticator);
    procedure SetDataSet(const Value: TFDMemTable);
    procedure SetIdBoard(const Value: string);
    function Delete: Boolean; overload;
    function Delete(const AId: string): Boolean; overload;
  public
    function Insert(const AName: string): Boolean;
    procedure Refresh;
    function Edit(const AId, FieldName, Value: string): Boolean; overload;
    function Edit(FieldName, Value: string): Boolean; overload;
  published
    property SpTrelloAuthenticator: TSpTrelloAuthenticator read FSpTrelloAuthenticator write SetSpTrelloAuthenticator;
    property DataSet: TFDMemTable read FDataSet write SetDataSet;
    property Active: Boolean read FActive write SetActive default False;
    property IdBoard: string read FIdBoard write SetIdBoard;
  end;

implementation

uses System.Threading, Core.SpTrello.Util, REST.Client, Core.SpTrello.Lists;

resourcestring
  StrComponentAuthentica = 'Component Authenticator não encontrado.';
  StrInformeOIdentifica = 'Informe o identificador do quadro.';

{ TSpTrelloLists }

function TSpTrelloLists.Delete: Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Delete(FDataSet.FieldByName('id').AsString);
end;

function TSpTrelloLists.Delete(const AId: string): Boolean;
begin
  Result := False;
  with TCoreSpTrelloLists.Create(FIdBoard, FSpTrelloAuthenticator) do
  begin
    try
      Result := Delete(AId).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloLists.Edit(const AId, FieldName, Value: string): Boolean;
begin
  Result := False;
  if FSpTrelloAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  if Trim(FIdBoard) = EmptyStr then
    raise Exception.Create(StrInformeOIdentifica);

  with TCoreSpTrelloLists.Create(FIdBoard, FSpTrelloAuthenticator) do
  begin
    try
      Result := Put(AId, FieldName, Value).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

function TSpTrelloLists.Edit(FieldName, Value: string): Boolean;
begin
  Result := FDataSet <> nil;
  if Result then
    Result := Self.Edit(FDataSet.FieldByName('id').AsString, FieldName, Value);
end;

function TSpTrelloLists.Insert(const AName: string): Boolean;
begin
  Result := False;
  if FSpTrelloAuthenticator = nil then
    raise Exception.Create(StrComponentAuthentica);

  if Trim(FIdBoard) = EmptyStr then
    raise Exception.Create(StrInformeOIdentifica);

  with TCoreSpTrelloLists.Create(FIdBoard, FSpTrelloAuthenticator) do
  begin
    try
      Result := Post([AName, FIdBoard]).StatusCode = 200;
    finally
      Free;
    end;
  end;
end;

procedure TSpTrelloLists.Refresh;
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

procedure TSpTrelloLists.SetActive(const Value: Boolean);
var
  loTask: ITask;
  RESTResponse: TRESTResponse;
begin
  FActive := Value;
  if FActive then
  begin
    if FSpTrelloAuthenticator = nil then
      raise Exception.Create(StrComponentAuthentica);

    if Trim(FIdBoard) = EmptyStr then
      raise Exception.Create(StrInformeOIdentifica);

//    loTask := TTask.Create(
//      procedure ()
//      begin
//        TThread.Synchronize(nil,
//        procedure
//        begin
          with TCoreSpTrelloLists.Create(FIdBoard, FSpTrelloAuthenticator) do
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

procedure TSpTrelloLists.SetSpTrelloAuthenticator(const Value: TSpTrelloAuthenticator);
begin
  FSpTrelloAuthenticator := Value;
end;

procedure TSpTrelloLists.SetDataSet(const Value: TFDMemTable);
begin
  FDataSet := Value;
end;

procedure TSpTrelloLists.SetIdBoard(const Value: string);
begin
  FIdBoard := Value;
end;

end.

